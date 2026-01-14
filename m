Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD73D37E3A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 14:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D7E6B0005; Wed, 14 Jan 2026 09:48:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9B26B0088; Wed, 14 Jan 2026 09:48:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ACD36B0089; Wed, 14 Jan 2026 09:48:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08DA86B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:48:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A18E41A0544
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:48:33 +0000 (UTC)
X-FDA: 84330850506.19.CAC3481
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id C0B4D1C0008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:48:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=U2o4S6vX
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768402111; a=rsa-sha256;
	cv=none;
	b=jAyD25yuhP4ue3boO247hpDml02ptSVuEVVyrsPBb8LHCLwp1FxFvT58HBFW6QXJYJgXOt
	N58MJekKSAIroy2gqSaaXfhvzjSOz09yK5GMg+mVE1ofOlhFXPBa9TimnU+YDCxZVv7OSy
	3JLOKUx4/jKpbzQOVdBMDhcLud6JRVU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=U2o4S6vX;
	spf=none (imf18.hostedemail.com: domain of boudewijn@delta-utec.com has no SPF policy when checking 209.85.218.45) smtp.mailfrom=boudewijn@delta-utec.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768402111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eti2jnWjJ/3cvre+2VBJiNqFzyCXhnTtCeagxJqKsCQ=;
	b=1kSG+4UDzKABWmJm7ahBXjnsopx8hRAjXpyj97Kx1yVwOt5DfMMDwowKlMg7D3iCkClSWD
	W5tX8ahdYRij4Ixro0KB0qJeTIWRRZjs+Ih6yntMaQ1XAYEJch8yVAtd/ihwpw84fi53ep
	gsilLTWjeJUlewSPC9ESf75fT23KuDY=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b86f3e88d4dso579081366b.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delta-utec-com.20230601.gappssmtp.com; s=20230601; t=1768402110; x=1769006910; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eti2jnWjJ/3cvre+2VBJiNqFzyCXhnTtCeagxJqKsCQ=;
        b=U2o4S6vXyurCcyhn2sGcCMjoMoha6zN/rfWWDtSMLeWE5qmFqLy7VY2qLXLgVY835D
         xyg5Q+q50ZfZDbcs7HxrcbC8aGlARpSSZWeNpsbSUkP/e68jO3Nqy4Vk6aXCXwx99gak
         mXIE2feJA6sQjGmd22n3oOobqE4uvkFSn0AkhJ+f8NAEiJj0IAR6RWNPe/8yfafnadpI
         opAkOwBwtBGhGBKp8nTTpY9wplN72S69TkM40K2n7hMfSFuZJK0/jeXKtQyErEJ/Sndd
         vp7E/q74TTpcL4ks89u16yP1EaL3wNLks5xnu01TIVsFOxWHrEXtrjbNCnt8JM+aNKAw
         g5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768402110; x=1769006910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Eti2jnWjJ/3cvre+2VBJiNqFzyCXhnTtCeagxJqKsCQ=;
        b=bCzYLUoyXQUs9/uuZDM8L8+6cWoy7Opfo6eyjVW2MR8+1WxdkJHzR6P2qr+FCsOM88
         ToIVTg37xbc1PX5AjJltcKMhobi/ZXmwEwkd0MDAlzybsdeYFlOkcJhH+A1GYaqjQ2fk
         izwooutaut9jY46/N/oM1VqXePOmAwSL2e7p2r6EhgjygiIL0pG6sls0Zi4HpKur7BSs
         HeAC+xbf8FYGGWtcaLbiQrsyf3i0l456mshZ/cT+jYNKkST17RkJYVWr/BR5e/sAbFSc
         VbWTH+yAiAcuJGl7CyBVxg3+W73PfmfMSGpV0YgteubOp/L27pEOgumVyA9l2qJ3g13N
         JPIg==
X-Forwarded-Encrypted: i=1; AJvYcCXQoq7Dicw7tOpoTkCm/Z9RxboxfRL79alNHjO2Sj9fgA/T3tk+7QEGJVBfSUhr1TolfkXj1un9cw==@kvack.org
X-Gm-Message-State: AOJu0Yz8Fh0L3uoQv2o6o9yaYcFwxq0xyb226329ksPzIIdjWyzimzMW
	u4R+FILeoOHRA9MogVL7/heqi50I2h2EfeIMWoOgc74yvB5yfCcya7faQmXWp/cJ9w==
X-Gm-Gg: AY/fxX6F1i4hPkQiRkRPvv+LHP/kvRBJczbtpUg7FUZchviw8BUmNuzpeW1BdxxlDKm
	iPIotFrBWZbAnIbdLpEDt50JKCefcilqcWBaKt0FNiiTpHoR2RAQSVLvQki85sXSXBvAIqOH7xq
	sEQF2Pz+i7nzAVRG8AEUqvtDwcov66Q08QoMxJ1xNVvBWLIgxVHibxX/7itK/B3eTjj1/gUz3LD
	3cge7fAPOXrPp1ogVr5J4huk/5KAkgbEwBJo/nhkns3vfpziZYxe9aNrnUpoEl+Q1NCvxpUvP+I
	0wzOGLhCN1KqdPn2OSHow+BHDrye/bEPdlGFOu07gealrDsCKY9WCFLbsxo/VjKg8OrAKyhzeRK
	RPVeHYpkSEvvuvUEGzlj3lNnqBWPZCWnN9bBk8bPHVYYBGaK3EkGCvWgLoyUw/KntDEzR/zWWsc
	97lw6OxKMhtR997fOrpFpiMBBZXLE9szmsoejrwGky3PhyAq+GOKNqhHQt98BKhY22eoz6PZYXP
	qw48QQoMaDNOfdlxBPipF+J9+rtHLG7dOueuAj4N1cRL3enxRw=
X-Received: by 2002:a17:907:6e86:b0:b80:42cf:1157 with SMTP id a640c23a62f3a-b87677a81aemr176504766b.36.1768402109968;
        Wed, 14 Jan 2026 06:48:29 -0800 (PST)
Received: from localhost.localdomain (2001-1c00-3405-d100-3dcf-422a-3166-cbb7.cable.dynamic.v6.ziggo.nl. [2001:1c00:3405:d100:3dcf:422a:3166:cbb7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8715952fc3sm962438766b.50.2026.01.14.06.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 06:48:29 -0800 (PST)
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	boudewijn@delta-utec.com,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linmiaohe@huawei.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	nao.horiguchi@gmail.com,
	osalvador@suse.de,
	surenb@google.com,
	vbabka@suse.cz
Subject: Re: [PATCH] mm/page_alloc: Fix freeing of failed-split poisoned compound pages
Date: Wed, 14 Jan 2026 15:48:23 +0100
Message-ID: <20260114144824.69960-1-boudewijn@delta-utec.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <54CB622C-0BB0-4772-A939-162D63433A00@nvidia.com>
References: <54CB622C-0BB0-4772-A939-162D63433A00@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d66jo34mgx5rmx4gnzkodsojsf3awjjk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C0B4D1C0008
X-Rspam-User: 
X-HE-Tag: 1768402111-550813
X-HE-Meta: U2FsdGVkX188/28X2/snuPuovBA081ADKitd6zZzOkSmv/NNuBmnaMRr++T3pyyL8GEuGeBqxBLhqbdwSxKRu3NLDU9hgrdsFOsu/wyD9D77lh9L6Eqfa2YGZvq9Rt9H/cMVHdMNaUP8YptG/Hseqy+YmLH2YQrWKptgx7uqKRVAK8L4zE2dMlJRANi4aqwq2Btq388MrjV3S065JMfPuA0lf/KkIKyJdg5GMwV94Ox/ZiKXYgoChQY2q/5fYHZVu6CVpEjXXZxrvq7iPB6mioQELPlD/beNzOtSHx77i0PBBPhcf6e4Wq3KuY9puaQvlTEHllGxkjRxK8Iv1qN+xbdk3MxiCSjVha2GQceWTxsFKQLzBM601oehLPmBpNd2MJYfTL/5XOeQ/52jYLCgqSNK0xfMf6Puxve8R91oKlegmKQGLvxAsGJn4uuopRjA8lKKDz0NYPOqVOl4+a1SFWyrYbJUBEG4gdoEzohBIBTlbBt9KR3IAZ3JzSHycB66l1HOjRueMPl1Ko6IUCnGLQR21HySXZLTwx8sKY+Lb/sTbMI4JDD8YXjdi80AuLoXZqGmMSpaX40pKAuntbM+fEKfHUExKguDlKYxeFxXVM1ojPEW8hvV7brJBcx7+wsQ8jp6BcJDBNf9erQ3Nbx4htdKuTjaHD6YgvMWzdGcF8hXf+/X180Mpfl4FYcNz0rT6Y5K07n3Tef5NaRHmEKZ1avAx44KZhiQLurHsC71gKPbw40BxHSY/vRT+BRLdrp12JdqquWxMMr5tqL2pppXPOPxBJQizqC9DeBfKeYjWyWzzF3EpbteNY/mkszGqLVqIUbtKTerI3jm4XqIMKDXvRAzHHnlrfcLPoUMTh2NpS/Z4CNKhleZpSgy0JKkeaoIyttcl4+fHIO4is+Sp0SS1NI88VzcoY8MvKULZ3yC1K9B9vFwO0HIT4ym9tk7D2X5wPSMNGCIKhzbeAnyxYZ
 jVHtYodA
 bEyLRRj633J45z0/mwVqqh2Ufc1sYiMxp9khqWVgZBBbnPgBIV37VFULiQhRUWd6VzGEOAyw7wCQLg9BCS7AHCGkqffpn3tKXe1ZVaaIqTCq+tHyVLpslOl19vynvJaAiMnsXkF5aRZd612D1ndKfWJNuaXJutuUXTMeOf/x4qMchFj6Gfl2qVTCMFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > free_pages_prepare() only handles poisoned order-0 pages.
> > In memory_failure() (hard offline), pages
> > are poisoned before attempting to split huge pages. If the split fails,
> > the page remains a compound (order > 0) but is already poisoned. However,
> > Soft-offline pages are always poisoned as order-0 after migration, so
> > they are unaffected.
> >
> > The '!order' check causes these poisoned compound pages to skip
> > poison handling, leaving them in the buddy allocator.
> >
> > Worst case, a poisoned compound page could be reallocated,
> > potentially leading to crashes, silent data corruption,
> > or unwanted memory containment actions before the poison bit is detected.
> >
> > This patch removes the '&& !order' restriction. Cleanup functions in the
> > poison-handling block correctly handle non-zero order pages, making
> > this change safe.

> This is not a fix. IIUC, for >0 order free pages, memory failure uses
> take_page_off_buddy() in a different code path.
>

Thanks again for the quick response and clarification! 
From my understanding, 
you correctly noted that take_page_off_buddy() handles already-free pages, 
removing them from the buddy lists and setting SetPageHWPoisonTakenOff(). 
This prevents those pages from re-entering the buddy allocator.

My concern is about in-use THP-backed compound pages:
1. A compound page is in use. 
2. memory_failure() marks it poisoned (TestSetPageHWPoison).
3. try_to_split_thp_page() fails.
4. The process using the THP may be killed; 
        the page remains compound and poisoned.
5. Later, when the page is finally freed, it reaches free_pages_prepare();
        'take_page_off_buddy()' is not invoked in this path.

At this point, the current check:

'if (unlikely(PageHWPoison(page)) && !order)'

will not trigger, because the order > 0.

> Miaohe (cc’d) should be able to elaborate more on it.
Thanks for Cc'ing Miaohe, hopefully Miaohe can provide some more insights!

Thanks,
Boudewijn

