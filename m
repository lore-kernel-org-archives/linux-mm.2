Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B06BCD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 01:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D7BA6B0088; Tue,  2 Jun 2026 21:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089B06B008A; Tue,  2 Jun 2026 21:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9C66B008C; Tue,  2 Jun 2026 21:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D782C6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:08:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61E991C035F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 01:08:53 +0000 (UTC)
X-FDA: 84836816946.21.3AAF061
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8756A100011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 01:08:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DuddUUxl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780448931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3GAR7SC93N2eePKpNe9tCYUdzk5c1g7WEzw2IFy6ZM=;
	b=RLekYiI8nDHxPMW1pWY2NB/AYC/CEpLj3n239/YOehFgAvJJzP0RaGLYByW1BZk7j5MJ01
	dCz/oxNTGvSqCs2LnRM6G99DJsP16RVU3gKUZIcMm3f8exqdQj7qpU9NNHiVdYnwdTM5yz
	mbX7kfhmrgBiO7HzpPJ33B9xwKrOtLI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DuddUUxl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780448931;
	b=gDpUjg527ZW+ojkIvECkmF20hHDpurtvy5Y2Brh7QrVct5owG1ck9ynJqxZaLmSwnR3Do9
	Lmp0ZNEEKvOCFYvgh1FqrB178F3nZPHj2g2jhG5zsClmO8AbvLF8mcEBzlRneP47AL9m4+
	6Ffm/3xCCA5hvTrxNoNhHKYiI6JIr88=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490b2b037d2so11151375e9.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 18:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780448930; x=1781053730; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d3GAR7SC93N2eePKpNe9tCYUdzk5c1g7WEzw2IFy6ZM=;
        b=DuddUUxl1HYytDVgRTok/Dfks2f68UhoSt0WiS995IC0MwZw6WNvvPO5xk1TiY+CLE
         zl43+mL5SBh2zw0L8u4YMhEzv102pUU1IOS6OVJV+ITGHnIEahhznzxsUW4A3wN6mpmv
         rLc9ELN3L2SatOn5p4NDtvIcrYMc1qvSCtyGSYJY/jswxyeqbI8+ceyTc6toPDo2meHs
         x0p+MnYCBqmEtKAsdPwQNjQgD6fLrcjTQgFLCr8DtPb7IpSE5ppPtrgTpskEsGvSsDCJ
         P02X9aWDqTPl7xDIcu5afeSDO4DMJUxXLJ7GXywn5vWzWagI2iERSI5mzLWFRiUgb6vC
         faPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780448930; x=1781053730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d3GAR7SC93N2eePKpNe9tCYUdzk5c1g7WEzw2IFy6ZM=;
        b=suuwOey8wuaRhe8rZQhI7OxeFIpfJk2IovEBWKrsi/Z0QVMnHKrdXoRTBVz9SQBPD0
         rAVUoAFlcHC2p1hlKdYHvYtOCAFuqlTxOLam2vGUc3+0bYtYdfmWWV7qRuckgyH7MWGo
         LLbdHgj1R9oI1X6D5qB+XxCwN1DjKA4suAo8aJU+aUSgBUovVInftlgH761AJp2eGhxp
         GibEgLSMxeVFzTXU1tOx7c7kL5ginLeLQCtj8jqcRXko4fFnTF/ko2p45lXPb0CXJ5m6
         +MVW0ca4OXLhuHuP3Q/Rg9PaJYL6ydvfDTfi6iLajZwgCvacmiEMdXjEbjp6L5OkAhLO
         GVQQ==
X-Forwarded-Encrypted: i=1; AFNElJ86/bailLfWU2u0fCwWFPli8IHAHYtOeVVOSWpCFEC2nSeMxunljAkxwKAEYymHeUMqsI9bjjNVFQ==@kvack.org
X-Gm-Message-State: AOJu0YwiuDsgLEgnKF2yBfbtwE7JCa5Oyyc3T9Mzk9dahcm1vxJI2t4+
	bfDby4MXLwjiEOfX8L61/TGgq21FYL5hN1gY3GwcRx8Yk31MAndrvlYN
X-Gm-Gg: Acq92OGPcDji/sGsgjdD3AhKSHWsFzQoitktaXOFZoyBFshpYdjsYKLqPcfOm9PZ9h4
	ub3B8mpvIlT9+sLhAIkCH4KkJo5H2cZaVnDqOXrT4pr++GniJEQo3M6mHWUUQyVe6dVBMIuUl34
	7qA5t3ti05oUk0hxoNzDzovLfgaxPB8Si2q/Hq5LGH/ok2bny2ZZx5LYiXx+705efrRoaUBetc1
	X72jt/9eljP81ABTLMYpZB0HnLSOaplCKQD/J3wBqYRkmEilUU9RXf0d7jjjCt5o1ShjUOvye2L
	NO7Z5fZ7LeH2PTKplPPluqPe301OvfVMzCtYXpJzTLQO2ICHYcPwvx1/LlyTN6/TCXF43rH4kTq
	HrYN/yTjHOWYGkSBTwSgdB7koCmfHxXuuBZuzoslHj5v99cWiH9zWs+dga1zc1unH6ICscrvSJI
	vl/eawcxXHgFi0nxoc+9zBYPno1SOt1g==
X-Received: by 2002:a05:600c:3e19:b0:490:b58a:dcc1 with SMTP id 5b1f17b1804b1-490b60fcd56mr18908035e9.29.1780448929768;
        Tue, 02 Jun 2026 18:08:49 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b725fb1bsm11254325e9.8.2026.06.02.18.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 18:08:49 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Wed,  3 Jun 2026 04:08:44 +0300
Message-ID: <20260603010844.257094-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
References: <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8756A100011
X-Stat-Signature: f4m1y665chf865ffcti7haud7new9eyk
X-Rspam-User: 
X-HE-Tag: 1780448931-19360
X-HE-Meta: U2FsdGVkX1+c/YDxyJdIl5AKHNvxhx/leDd0swQvLmxiQNpbhy86cDoE1zrebTaP/AOrisb/3+nToB1gtxFpPDIWv/KEMgsKFTmP+bI+/rTNNHs5jhGYRCN7yHZfl/2nFVfbL0IxnmFb8Da4pJO03+GImJmQN8xPpPK1yZn7+6CQqL8HKITUwn/+jc8ByxilJ9ai+qxZee+71zC8tcemuAOxZZsXiEgsn27lqQL0OFbita8o4L2JwEDBM/4e1SdNTqZi3cPKfRnhpZ1M2CYyAGP4vfQqOrphJV9U/KrfzwlzAYgByuIpMdSThklYL813/AZQp05hy5LtqwnsTUXsoDcwfU5aMQXr98xBBgu/PBcd0pYncd4i/hT52eDlgM1Qte/7Gxyk1C4BVncyC0W3yDXq8y1gpP2qltqZaUU5mXWe8TtP396EM+yVh7m858ZRAeE2qJS90AfhKz5uiy709S1VO81RiIRPxfyX1GPc0AyqfajF580PusNsG+luqfGZ3+Wm69U0oHNjKKIE9mbVWxs2+vsOsOuExDN8ypjN8dFwTVvStXmyDyoPqI+VsLTo1Og3/XVE09MSWehFCQ70A5VU04lsAlfXH0T+PjVs+qejx271AVd/c3p25ckCQ56wFEzQO0IxVXxYzFCSpjrNRZCe/oFVv/2wlclKykQqSgTiQc9BP7D/1H9/xV5kgAfVe1S3jwXz1mnQFoujF/n3jt+ezDjH5FWKNHTUhmQb34eaMObNh8Z1lcHWbS5Z667+zg0La8jhFBmkrfzwZXws3ab5P6eWywmZ6nL0GaMA91RyleI5TkhNwiyHX3gOapzFK4veeTHkjpvvS271rmyc9Inz5QKF8rTxJY6y7QGXaq5HuBP9x0UwmTZ8MSr4tOVR3w2WwPOsONIQ02GV8iPKbReLEoy42VhV63lopE5/HRyTTBZXi9xaSx8j9NKJ/9Y/UYitHpxMtY70DG1Ernd
 mWjcn3Kr
 Tk1/CeddY6TJETLsoreA9Lp437SB2QTudTzT2XQEH8XzYS+t6UgLMXBhJp2jlE6+wtNX17uZw3548XnkbQc21dHlLKAe5Fqr4do0C9eKs0p0OHXk7a0o6QjqznK/7m9EnqopkrvtqpTt91IyDCp8FAnYPRKE31lDZa1YiKWV0dD21J/Cd356Or2WbsNHDp0X2Rm4yE1JgbzDVfX0t722kkhwa0SVdbsoIMotUGrd0cJKKHCyP+BVVmc/JVOcXKN+7fMr5Vd4AtYHQjJlk/833qNSx1wXpfbGBMu/ADFEXrZN4h66V5+wUPo0pwcv+wAkeiUrrotV7rIXW/y7KCr5D4BBa7mfz2Nd4h6xIc1IRPspBSQ5dHo8+f1/W6xq4FocS4/2j6Q2if1TI5WsdnLsxArEpOcI9AU+ryebHtIA/xBGTKV3GzR5QHZLpKVwiL03XERSefP8GfhxBN54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Linus Torvalds <torvalds@linux-foundation.org>:
> That absolutely would be my suggested next step.
> 
> Something like the attached - get rid of filemap_splice_read()
> entirely, and just replace it with copy_splice_read().

Okay, I will post something like this soon.

But I'm slow person, and also I will test things in Qemu, so this will
take some days.

-- 
Askar Safin

