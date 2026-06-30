Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A394CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7529E6B00C3; Mon, 29 Jun 2026 21:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702D56B00C5; Mon, 29 Jun 2026 21:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CBB56B00C6; Mon, 29 Jun 2026 21:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 396136B00C3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:23:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1A931A0306
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:23:36 +0000 (UTC)
X-FDA: 84934831632.01.D5955EE
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id CC87C4000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:23:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=avZk2JwR;
	spf=pass (imf11.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782782614;
	b=8obmLRpUDvTYe5qwroYJNI9cvUmbuZ452/cW/gBsq/1SiZS22cOs4ec2h31BnGWbgL43Rd
	04WIzzlGKm4JRqf0UFb6xAZvQg2J+UXqmz3I9OqpmTWVvrLCkryFPkYn/SMol/TLA0rru7
	pnanIYzDbP+UKVb/8yglAb3oatJX1eA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782782614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46A0ohYojyMmQy0oBsGSx+Y/V4MLJFoEQLBGXRE8WBM=;
	b=uFi7EtiUVKykme4Dn6U3gkVfDbQ4oCSGw4eIioZr3oBNQefpE3IlXN9jj2irVbp9/P5KyC
	MlW9QIRFEniurVj4ckpc+HjmDHPv5GMK1a4oo8V2dXzzmQrF3Vjx+tDXJSAR6mOoGI/59Q
	eSvnogwlQGDmYBc9PTZJgrp7n7BHxVc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=avZk2JwR;
	spf=pass (imf11.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aeb78090edso1599700e87.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:23:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782782613; cv=none;
        d=google.com; s=arc-20260327;
        b=fRTc1JWfTkDBAuGj7u1RocNzXi4gLn1qsPhGGnq5JrwioocBY6lKv/yTqhr4+fmsSo
         0aMv0UGKvbFsohWBiHqux/L4j73YE9iFBQepPVBUDJpiAutH9yJ7AihE6aoV5Gst1wmW
         FmfBkIELs5RqvW/GFvWbPwP6BCvZNeGnEKk/g4ITTt9k/OfEYBL3XbLHE+aKF6BaT41h
         Flxo6HeueiPJsIRuLpUt1fCn/AuvuasJ6xy2VQRL6MgYVcFLWf9+eEH8nPqsd9JbmShM
         6rGVfaCjWG5gXmgVR4QLBSnLmSeFS423RCpK8DcnODKIgMq2K/qFeUCOMflASP9b15fF
         Giug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=46A0ohYojyMmQy0oBsGSx+Y/V4MLJFoEQLBGXRE8WBM=;
        fh=k16j8Q9iY6P7TOXACbGzi39nMnKbJy4E/asMKAOC0wY=;
        b=ZpGFni979xOTIuk1LDb0TGdgyC1jcNy1XDhhTIhp+PvnJY/ClW7GAkaszQAkU7e3XJ
         o7cWOAuZT7SepPvEZVGRwEYzrfp9OMHj2CIrAe8q+UNgc50L/5jgf/4aI4K8jsd+p0os
         FpNJP+cYMshnVcbNHdDNKrasO3hAYxOwHgX76jUjyFbz/XqtsuqMuKtZEETDr56pG+fj
         U6eOkvKwedniSCmzZ36KtP0YjccYHkriobzr4UG6yYSHk8DU/k9Uo1ac+QHuvuunNs0o
         OypS2Uqa4nu6YMkgnHEW3lpsR+pp/z8j57V/O3ZHWbbJzVcBKqOfLFwaZrkbDLABH71z
         rD4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782782613; x=1783387413; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46A0ohYojyMmQy0oBsGSx+Y/V4MLJFoEQLBGXRE8WBM=;
        b=avZk2JwRnvKpkQzu3ENiqsL3PtX3Llg3DegLRonPVps91TnHFZmUi/LJ+T617j6XIx
         qwa1+SxA5wPzzwFGdCQ3gGnmOJ84UVIq0xGHNJXH1QINlzkwnJo6B2DKPRjU3ikP5x0Q
         KkIc/ZBzfVuLjsxmirJCiPMTvSKXjou/ReFfUWBaI6d2jpgAxkSyP+fPK+mh6UCiy1Mb
         Cgh+V34OpafLudViB4/kQ35M0ltbjmYja46AgVvP8876pQrf+w4Q058Ve+W6c9HPluST
         J11/VVRVrADPXVYQgCR8GcYwzD2JD7P7gLy+/lA7K7l209SpVMi1qREF6WFC1dt6Q1zV
         gvlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782782613; x=1783387413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=46A0ohYojyMmQy0oBsGSx+Y/V4MLJFoEQLBGXRE8WBM=;
        b=I5MzwiIiNf4vxra4sDiR4/nYb9kdwtC3EniPym3j+cwilyxIghqrbzzmYtdIbPcD4P
         BruSaGEayiihbApAnQMdHXPCYdr69p5mlnaXyHIziKat1m8/grIyYxfUCXZ/gaVKFC2A
         kvOkYJcJW4cCZIWXruO0UDU7ThDwBLSZmUHklVQ729iblNYFEann7uJ2NLfsDYW5DsM3
         mSrfhkq867H6RSbrjeegoN/UIkMKmpdFrmJoepYvuoyTW3j1v8LOsvWYlCjQg8koWPbG
         CoW4asX0ZKORkCFqGmbW9XYzLMpjqFuHQsh8scjxocg6cadfHHBZ5r5NuOcW+FVXlP1J
         K91g==
X-Forwarded-Encrypted: i=1; AHgh+RpWNaw8tSeXZDC0f71Lc/lvGnNcvWJRYVtDq4ON39sJMM/pZb+qUBXudFYy47SRggz9A3F/PCZ7jw==@kvack.org
X-Gm-Message-State: AOJu0YwyZlldjjlzzGkSYA6iDjAADJlPjd9afeNNrpxgjNwDGrJ3FOFr
	6SaW6ntHrTt1upEVD+n3juCusj1MLSxEzze329v8h0WrYPT4iD89gremuLa5hOeIAhKtw7iSo8O
	IBA+ZWmppO+qU846e+zoOIltrGqdNiYY=
X-Gm-Gg: AfdE7cmOPEkOvFKUwMBIh8PsG5IhV58lKBHSRweF2S9xEJon/FP+iWSkbpmdC1/DYK1
	KGDNXDN+BVxteBWIDbxhSIwpdjnf9anBiQHavyfELYB2vsdg6/mn697e8i4iqnB0JI4G9g2NBlS
	4kJBPmMuk8qzkVWlrDb8IF76c9/a26Z/BGTQurwZdFQRUvaFR3yPfTOxR6kPEuzufQnJCbX7aXi
	hiXIWuXlKeNlggF1dDVX1l9byJJOnag9yQ9F4qDaHHvTduUPDltKjyKXYPXpoc9p08DJR0YEP1t
	eIHQ7Oc+kMZM26Kh0HlF+7jagQ==
X-Received: by 2002:a19:f00d:0:b0:5ae:ba28:a56e with SMTP id
 2adb3069b0e04-5aebdbc9aeemr208126e87.35.1782782612898; Mon, 29 Jun 2026
 18:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com>
 <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-2-4627aba8ed1e@gmail.com> <akMX9hoSgBmulBzv@casper.infradead.org>
In-Reply-To: <akMX9hoSgBmulBzv@casper.infradead.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 30 Jun 2026 09:23:20 +0800
X-Gm-Features: AVVi8Cedsz-VebzwdsD-jm8opqU7__wn8vihfYFrkRMOKiwHn1ix3nY7PfwlmWE
Message-ID: <CAJxJ_ji9i-Mi0tAwiM9hwpSr4Y=hwZg69P-RHo2y1H3YgQLYkg@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mm: rename swap.c to folio_lru.c
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ekc6t6eru4cbk8ktdbsznz9y9a1qx6zy
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC87C4000A
X-HE-Tag: 1782782614-580918
X-HE-Meta: U2FsdGVkX1+c87JqD3as+XNOXquTfYUZDdvw5qP0CkYzkHNacb61OFM/c0obBTdrJFQ8EYNHb5pauNa1vAAs7bxjDC+kpH2mSftzeJeHzrJNchnZ68jfl6FPNLVbxBilySE3W6XtFz+yDHGNgdUYyoSxyVxAEIIw+snk6TtZs4xFyyXCF7yZMBYpIzFV7uNl1pFAzqobw/rZtUShCu0Z3bk/GFkrN1YjLtVvpEzyiPEPDzwfhiN6SGhNAZ9AbUXxtBonfdYYoZ4/AQfpv3AHwL1jvKVCZJKqfWAewwgMjVQqs51hglVqtj0S7fS8+ZhDsVvVjsmJ2KpRsL7U5n2k4HoyeRgnqyZzFiSMHPTkBBh/WlGTj1Ox3HsBTEB8r5iv2NltbzZk7q65CyvBaOCf8cGqNDfkwEPeQujhVQUQMJ5qZM99yU8nsL0VILMHpXcspKtxkiSzNVQf/FHf77AM5Que6lhn2NbQmul7Vz8GDHBu+bbNSMGpr1tFgLGGhym/vVi6Naa9YpzyDnzy3cCARgnF8JC5UmzNdiGtS+FpAo4VbvNI1bXYbY1nB0IzJhutbuMurGqkIp5xyp21MJpoqkR4Uyj1jyOr/VT82HkGH4zUHTDVq2d3/+KlGqQ5amMPNTSuuWfB602lspc0dXg1z1FRHWCZ8S1ESpppp+luHDCEXc+taOJhLP1pGxE7x0PErIB5RRo3m0jGtpRHhEd/YACjnYEQGUv/+4qvHPHZZiwq7GUJkxsbMCphCgRVfK8GFqa6aGi5RM08sBLpgwpyTVMg7W5ejOVZ5ve5TPMnsK839rrp9anYWs+988wXM0Blpxg2XRR/CV4LeCa/8mp2BEb33C9Kb517Vu4AsK8XB9Fi38hwkaN9dpWn3ByJknqhYVy5HeNN8in2c5YxzRjs0WuasRFxTGRuSLFUu7UWDP7K9O3tkQWJCB9sE7kCFWWx/meCsTr2ziYvKQOweWY
 TVm5A4Hs
 KltPuTZgsv7A12bgj3rYk1CXMPT9qdhj/sL/c62CLXKg0J8dUOXkeP+QyfVSuhCGeEhuinZfTGEpO+CWmrqdVf8J3DuPWsi2X+jIRLfyBTV/p3SQjwp94ltEZB50jEgQ7kQMPaoEFBWXhJQ7LL66nGIpoD+AelnPvD2iMeqK6BrdT7yAnpy4BiY1smmRsjZkkUh03JiztGeEK62QKCKKOJI8SduM138s6eYkW/ULeQQXuHELRy/C4H0dRCBhDHjSUXsq1ytkFyddylyTVjbYmV5TvpRleYh0IknJYEdWsSJpONEr/pbkrjVIOZPHWVMwfjuoHROOCoxeBNOPwAnkbZRWc0Vp+OJcweogCwPEyff4+MdcfcDo2Si/iYlG7iadcCNi3GhilKpr3X+9J+VtMBjoCzeCmOX6KpVjxbkaPxGe471vbPThZkY6uIMdSyCSBbKRAg0/83i2MsoC1A77bb2d99uMswn7kZNaZDw15tHxVieETFXBd6lxFFj0wvr+QqeFAddJMNaeJLH5JfqwwEf95zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 9:12=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, Jun 30, 2026 at 09:08:18AM +0800, Jianyue Wu wrote:
> > Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> > the code's main responsibility.
>
> I said I didn't want this.  Rename it to folio.c instead, and then we
> can move some other things there too.

Thanks Matthew. Will rename it to mm/folio.c in v6.

Best regards,
Jianyue Wu

