Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2196CC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 05:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5F46B0088; Fri, 25 Sep 2026 01:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50316B008A; Fri, 25 Sep 2026 01:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D184D6B008C; Fri, 25 Sep 2026 01:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A73D06B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:58:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BEDC4050E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:58:28 +0000 (UTC)
X-FDA: 85251229896.03.402CE69
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id D852520004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:58:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dpUz65+m;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790315906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFmH4rK3RuleiChH3Brg/+jAhEcDUYox1Ynn+R6XLKg=;
	b=j7rpWJBCHACUUOMcK7EKO9PBFQAGkbMZPaGupro9Pze+epAgJogNaw1wGsEOz3kp+755I4
	fuAI+dH69/z9+Ay4J5w04tiHbeZZQYuyjqo+XP0QTc7cLGPhp6KwITxA4YQQt6Uf0NXsCw
	TSMgg4m7IK+OoUzLebtMHNcBwF4S4Lg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790315906;
	b=PZ4UMPL1D8PsnP0XP2GQgValsMbQx3Zo01d5HLETFWrT8Zdh0UhESFqK/SfDYs/iNW+NHJ
	WQjIYZTeYygEesAXNQqn76mGfnFqCEQWz/2o1RMpgXbXpBet4xcAOHkSCkawMFDbPyYblR
	4oyUOpasy1gBqsQzBCJGO4h2v+MjGXA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dpUz65+m;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd4b43b20bso1827315ad.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 22:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790315906; x=1790920706; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wFmH4rK3RuleiChH3Brg/+jAhEcDUYox1Ynn+R6XLKg=;
        b=dpUz65+mL92oXebymosJ/ZjegcEEn655g5CJFb5iC6ZvpfGxtiw6/auNXF/Uef7+Z7
         Q+n9q+XToVDMgJTtSw6+6COjV39w30FzpBHivR0PWe75d5wABcIkKlAj6VAXxf4fZBS1
         DTSkaxVpQs70cSmsr+YkE443pn33Yt/3hhKBpI/xzu4ar0f58M0/aQ0ycwcqePo24jn/
         x/Y2ugmJaCsPI6cc4eUr/NR49XLS0rJK1K9zjX6Gfb/JiSBvneAIWfwvQAxRnhf3xHXR
         rMG9/itopxL53+5aLX0USWMYeexjEWND+LV01bmtSq7w3VwCqhEMkXqoNR6wvaaTbZ+h
         Wwew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790315906; x=1790920706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFmH4rK3RuleiChH3Brg/+jAhEcDUYox1Ynn+R6XLKg=;
        b=cQ78zWxumCVGd7do7iWMhL0hPsu7A2zaGG3ozhyolAT9U6vlcfiDiFdBjvwsUtXjw1
         j1LAlmHYeHLT7mJ0Y9nf+NrL2Sc14F7Jz3KAEBZEqYlj1kPYmpSIZX6WDl23ULz9GS+W
         dduOWFxAVAGg430fRasZ4yUaa9Ac7yHLHK76o6QbbpbrxsoKhuAjINyzCiG93xtQrSWF
         NSDuVvr3c22wMwSAOIJ49O0z4zAMiaN5DfXVJjMP6iKFrsNsF72YVWMJj+Sb41yh48Fn
         2V8ph5zULzLv5ubCFNJvmA3cTV3Ud1JC511B2SAT4DhnIjbu0f4Qvaqfu6bR1jf8F0IF
         UMzw==
X-Forwarded-Encrypted: i=1; AKwUvBwIz2PPt5auOMo40KKhvssPu609e48OEpYghio2t+mg7qvRxiUGSsuUo0cvyV3Du3ilQLdTdrvZmw==@kvack.org
X-Gm-Message-State: AFuF++mKkItFwR2obZLSIAYlVF+xZMvEIkIuEshRmVfhlcvRTTChNE+c
	n7FNE2DuN8iMDYpB6NoqjSCcs3LaLVf9ey9NjKAP5AyUSxBXW7CSxEys
X-Gm-Gg: AYBFou2ffeViGx01YdqWWj1Fj26XFbXTY7K3AeYfZ9VVkZeHDzcf1239nUPkeq/iuhA
	nePPS7y9SYO90LsaOBa1EvsorO8IeC9Jvh3H/0mxT+0c8uaRaDhRG1XogH8d2x72bv9mtaKNisK
	Me/0GaKYZUjwhfJ+OEDdmrg/u370qUo05GKBy8zL73azKK96BEDSjxeQkzLU9TU4UcbHwCukDs6
	NxspZI6fJA+1ShmNAW/Nvho0vMgd4xWpPsWQGZORj2+LzDEH23fOGDMLqj/XHcoD8Npe4CRCyFK
	i5sld3uTSneEdwdPP5OGy+z3adblwAfg0CbuUbIfjHseUfryBl+0iBggpGwlog5f+MGPRKn/KP6
	GUBkD+ZyZ7igNZRVqX+L+p9RFM2Y7J8uHJdr7Ebnlmni3cZL+lVIhQftS0/Zzbi+ME/Gx2h69aV
	yXv7n5XwZcReeFlJr8cRS7+6ohrWUuQJOFiO8LE95DT0WBgWKX24NDR9qPVlRp5qIyENpLOgbWy
	Blpkwt/Oi8r/ph6bCt1rcKb4Axidj2mKPhfCuke
X-Received: by 2002:a17:903:1987:b0:2dd:3ddf:b87a with SMTP id d9443c01a7336-2df7da68a41mr37782425ad.0.1790315905645;
        Thu, 24 Sep 2026 22:58:25 -0700 (PDT)
Received: from localhost.localdomain (vmi2317699.contaboserver.net. [85.239.239.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9143cce5sm4734955ad.54.2026.09.24.22.58.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 24 Sep 2026 22:58:25 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: sj@kernel.org,
	mst@redhat.com,
	david@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Kairui Song <ryncsn@gmail.com>,
	kunwu.chan@gmail.com,
	lianux.mm@gmail.com,
	baohua@kernel.org,
	xueyuan.chen21@gmail.com
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Date: Fri, 25 Sep 2026 13:57:49 +0800
Message-ID: <20260925055807.32678-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925054408.10431-1-lance.yang@linux.dev>
References: <20260925054408.10431-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3d711hmwhhotpd4osb7gox9gfjh317hq
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D852520004
X-HE-Tag: 1790315906-985523
X-HE-Meta: U2FsdGVkX1+tffxaELmYgdHf5aB/Dyp3fv3SAd+/B/HYGZMs8rOasci8LOtZiC7ieu0qqx+dLE/OvRc4f78cY8Cxi7YnOhi+GDg1meFWlNhbSPd+stLAJOfcniOz4gaUbCKl99pzyLYNIakBSy3KGAOESnkx/mFK8lYPWnu8ZYsqOOQ9C8OmCm28zqZnFythi29jeP3RCKwGfaUshpFSgxGsZPDNbQb5bTL8/GK8RtxkY3O0MSwdbKp9Cvx4a93DaJmqXwjwmvwCDRQV3WzIpQVt5rCgeCq59ec7NKtOTE4rD8yws8Y8Dw+83j1GSSYIIMKekwgnoDsO4hH8dccVlRTK/l1V9qgR+NJCuzpR3EWXQ78hUsrMcefFyH2cJhpsKKacLJmaluZ7wNWtIDDF7fKDJiAr1MesMmjpQp2/zymVa0a8QsWbb/b4EDPBqwIK8sE/ekxp5OX+Zxeh66Ywy/8ldHqI/8SWY2pizyxnd3fVfguWNBlC+LhxppaxwuGu6uYR1HUS4BpCBc6ASfbYwndUGPSZ2gzuh2n7eiHUG8hwafpn9T4t6VA90tkvLrsq0hR3pdcBWWECZgtcwuLq0fs21a7p0WtrN46YCXQQAM2tab3AHzLLjfzoXfFjQiSVYwKwkvwG9gX6XZpH5sZdixLz0fimrmRzNPXUyVdRYcmW74PQgV+yXsC2gwbZmaSAyYeRQJe3fNwUBOXnW99a9W9zBOAgTISY+S7aKEN+E1yqlbMRokn2zekwaK1YCQpp2MsGrcpWHSlGjONoLkaoFVYtMjgQQEsHnwEFXQkrpT6idXSklsxfADmmGYe7CSboZuC6HQv52slmqm+eN1K1KxAhDtQdQOsWfjjAiYDStk6g6qJCu4P8BlBqaUj1m8NauDvUaB8wIcPmEc1bYHQvcjQnEoeV+LlVrHr9L0aHMiLaWK0l+mIhNU+PU0HTMF/Z35sxIcjMB70WSMZX0cu
 V5vYJloe
 sJK3DdzZ7ZLYMqXaHESQRj9KbJyHgGhpa6fgSpvUajekV/1MXzBf81qFqwszMagauW5U0IpZsdFgC8wN8sZxuQhlAelBfPyZx5pFbz1Bu+djtszEyMLEkX+OSlR3W5ECNVmeD0mjYoDSX2PkbPdrRbPVZf/g3tcoun/yfmNz+l/QhHk9sL/33Nji8TXvE0r7h8oc9+4z50MJT5Iku7Ns3V7r3Hl2gGnnEbNtRgdi6PG/Pa2HYljqomykLhE4WCi9EN9o4A/lsNxQEc6sPB8kJD7ciGz3ro14nbJ3VME0NpOKetHZF+7DjXdMHb3s/ACFeAdN1mqXWJ+1ZhCOr3VfTxnmHrhxnZDIGpGQVnUabnzJ7Ql0/BH8v0V4Jp6nKSC+DXEr7wY0wKKlaixKNGhQn5V6S5ERYYBZt4LZobRWDVefNPe6WWDPFzX/jm+k9uUDVzCycmxoUXjPs8lGUxdwORdQ7tTwkffGXCZ+I6t5EugXwlDqqQmegRy5HwkNO3EXuMA/j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance,

Thank you very much for sharing this and for your interest in the related
work. It is great to see DAMON and virtio-balloon being used together in
another real, large-scale system.

One scenario we have recently been studying came from Sangfor. In a KVM/QEMU
deployment with guest memory backed by shared tmpfs and host THP enabled,
host-side DAMON can report a much larger hot-memory proportion than the
guest's fine-grained activity suggests. The related discussion is here:

https://lore.kernel.org/all/20260915025514.2434-1-lianux.mm@gmail.com/

We are preparing more complete experiments and improvements around this
scenario, and we plan to discuss it in more depth at LPC.

I am still actively running experiments based in part on SJ's earlier
introductions and our discussions. After LPC, we hope to share results on a
more regular basis, together with discussion outcomes and reports from more
scenarios. I believe DAMON will continue to become even better as these users
and perspectives come together.

I am also contacting the authors of the DeepSeek paper to learn more about
their setup and experience. We hope they can join the discussion so that we
can work together to improve this area further.

Kairui is also very interested in this DAMON use case and may already have
discussed related ideas with SJ, so I have kept him in Cc.

Thank you again, Lance, and thanks everyone!

Best,
Lian

On Fri, 25 Sep 2026 13:44:08 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> I was reading DeepSeek's new DSec paper[1] and found a nice use of DAMON
> and virtio-balloon:
>
> And it worked: time-integrated host memory use fell by 21.2%, while peak
> usage stayed about the same, with no significant CPU overhead.

