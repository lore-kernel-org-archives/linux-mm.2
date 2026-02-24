Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB3CF3C99E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F716B0089; Tue, 24 Feb 2026 10:51:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843806B008A; Tue, 24 Feb 2026 10:51:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723466B008C; Tue, 24 Feb 2026 10:51:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC4D6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:51:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAA901B5DE4
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:51:40 +0000 (UTC)
X-FDA: 84479790360.29.B71ADF8
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id CFB3440016
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:51:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dAX8Owhm;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771948299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5ETdepbMQNUMnuhr2VD2neSs42BrkDotrEf8tSgUw0=;
	b=piZpYGs1ozKe5ed05uvz9BcvIxZblMUPNh798Uwz3uhdR3w2GHdn12X7sijQUlx6vGd0yb
	hILx8AVa/0AouPHa3zk39aI8Ycjex5OMvQRzThThkWWlwf9ObwGk0uWGMetXeZ1XEmAwbk
	nx5ZdqwLwWv/Pwe4oGhig6j5jFKUMyo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dAX8Owhm;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771948299; a=rsa-sha256;
	cv=none;
	b=fskpy69jFRT5I6XyuDv9F0NpKm3FfbBbsMVApuJyapD2xYWZVy8u+BYTYArvymm5ouK73p
	MNdj17hcjHeTbO3e3Y+GHTtO9JFueIsscFKTNlY0QSvpT2nNaMbojpROYdGnCnlDgYSxIf
	lvpA8F8ghLsY8IDs0z12sJSCR93NR0Q=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4833115090dso55110565e9.3
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771948297; x=1772553097; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5ETdepbMQNUMnuhr2VD2neSs42BrkDotrEf8tSgUw0=;
        b=dAX8Owhm1dFPs4BJWkFb1q5qjRz6GouwZ2Rhs7zQwxrTTwn6zdV4K3U/EJabr0bfP4
         3Do7+VQXVoEs47lG63oyHfky0GAnAbBbRGzKmI7j+MB71d5SLougWTmFThcxI9Dcqmhg
         E3hFF1YF7gz/icrRd6p2+xup3d9XRUmvLOZJ37nASitk7PKD2gaqyhU9+WmiNS1FjE9v
         GtohHB7KVgZYu5cx8AmeVgyQ1+J5PSqt8VNRI6AI7h56ul9pyXf6XKq9pnbZizytd6Fq
         eWxRuHsbD47TeMmBOrkuvzdxtT8YSvIdfTF000HHCoSYn9Ow3+XuMi895p/PzEbNNNTm
         PSLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771948297; x=1772553097;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z5ETdepbMQNUMnuhr2VD2neSs42BrkDotrEf8tSgUw0=;
        b=ItzMQPtnugP4RjRTo3Zg5sbIwCZ2omA46BdcuAT5FqLRnbqGXeVVZUMjYCqskJm/6U
         +7o5AOHpvmCu9OxnKtVxT/ZO1efYSmG06Yu6P2EBaMUwIv4taasEGGCSYF9GzEQVjFNm
         QciEZ5ca62sXOG/FAUnRrlP5hg66YbLweiHLcKdrQlG2/j6Y0y1TNn3027CchXpNq3JC
         VfZcciv4Tc2I1HWScHowT850g0Y1TSMmlEqp2EtLxV5hSygEup6srno2BG1CSXctHO9A
         +vAbgthCTc953fnUNdDFOoOBxQolXqKFJqjmt3lnAPshqMMOc1ETv3yJVVTgGZfGr2lP
         dP/g==
X-Forwarded-Encrypted: i=1; AJvYcCXZdsaDwBChg5DpwF5ZbxEsfmkhFMickVVQL7Kd09q+OX6AsKIo9KCPv/t7Q8RXFSq7SXOs4/LPvQ==@kvack.org
X-Gm-Message-State: AOJu0Yxwm5DJ2MsN823ZcyHVDK8cHQhTEkWz393ROm8RS5ytX96viAYU
	+OI4eS/bqMzIlI0mCm7+RD+BHlCveLawGIznx13NQ23N/V4cUvXyHM9J2qDmIj/Bo5A=
X-Gm-Gg: AZuq6aL1y194toJQMVfJhjfCjbGgsN9N2gpwYTKLAWoKMFCSKpTOWRJBwMxnQeCLnn3
	A5/S6d5N6+7LaraKmigMj5N3g4pEn8Y02BohNFdPZ9KRTGiyT6SbqFfiH1F7uYrELpwH3XvzJZV
	LM2L5q5OjmjqUMROfhIrge/F9gFA1E/OGkLl1jp7YPmpQ+8jgan3Ae4NL8/VIs2eYn1oTvnYaoy
	13Y4kOnd8c7YAnDBq8HKCGZc54JrIZWwmjSuHFlzetAcYop+lmlzHLkMKprhfpTzTIyoD2L4qM6
	Tw+fzM1hCLma8/UApZdFSQoVL9US2A9DwO48hEpScqIaE8gjqRsEhDXzZvcfOhPIAbG2RxE2MSM
	fcL2+4J6W4eKF1EHEDh/Lr/PlsbvgXTHcWloixFyQHnBjCq61kwiHpC4YtFkrTluEFpulgGl4nL
	7sNhBnX6+Xh1UlPsjmRLLE9eAjZPSlhoU=
X-Received: by 2002:a05:600c:468d:b0:480:7162:fa48 with SMTP id 5b1f17b1804b1-483a95c8f2dmr230149145e9.13.1771948297024;
        Tue, 24 Feb 2026 07:51:37 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d54760sm27459593f8f.35.2026.02.24.07.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:51:36 -0800 (PST)
Date: Tue, 24 Feb 2026 16:51:35 +0100
From: Michal Hocko <mhocko@suse.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ3JB5Xm3SCmJW95@tiehlicka>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
 <aZ3HaVuIA4Ezu1uY@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3HaVuIA4Ezu1uY@tiehlicka>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: CFB3440016
X-Stat-Signature: fea4wcxhbiw5fdfxrnbori6f1hqorgjt
X-HE-Tag: 1771948298-255011
X-HE-Meta: U2FsdGVkX18m3efJS/GVrFx/be8IekyLp697eRu71xV1mRRIkDZz57NI3X5WwaSyC++vzDjNtpuKv3xrhCtZUt++G8vCCb/4/zVHBV0oYVd4gsti+zVV/rOztWHIeSmpbQMI4pvvV9hSYGZ/lS/qxC9YrYDSviZ0dqUNshE4On+9BI4fMw2VzpgOKtHn8RWIth4Hp4Z8s97InRNgc0a4+QH/s9Yr0TIvfAJjkU1X4sTbsdSYf06ANWxcGKSm/0ynz/ta2s993H8XsM33hNqz1oQ0o2kYGb4WUjSsgMl6l2HSqS8/drck50vODPj7l1NT8feu6ixTBHbsBr2P4uO2Jk7CGOEeFAts3JY8xmd82ZkT/XiPRYt0ralxgCaDHnWv4sPi9WcEkYmKmBgQHXS6uQ+Jm8pzQrixbV5crkZYHYbjJDwYGexfNbNIyH4Lrn2ApqS2KcCm2uJzmO0LTNr62N3G6MAPKs60+wBxRQlnEbdDZSI3lE70AFyKT1DjYj65vZHjqcBMSzXbTun6tWC+3d7fB/s3okHIUSAhuY+tbMkoGcgnW6OlbbS2PjX4Lh8LwquVNbmtZ6Qg1UJFaQ/FiRqotxMG33/pudN22C6R+x/MvXgHae/5+2q4ndOjFPFuhDdrXmap06jHoJO9lAR19qguQDOxTh6o1undCtV+xaTffP9CgWGN0rTySfW9uAtFmsiyjHHG2midWdOyN+VlA4e6Smd2BkfngHUKN+8Bl4IOIAPeNBeMhfzDN3fksH8cIV4CnkdVkSi8e6v6IRBKw495AEAKSLbJuSV9CX8SUzbJH33FN+JFIMlft/sAjKGj3smogaiZ9vNfttXwk45Yp3cyFONjlrGGogyjKAkW58NzJDi6nozyOCmmkbsN9CQsWfkMIP8pgasWUFp4SHAsgKI5eEH3vTVqYS2h8rIgsXFd4x5rDz6zkSkEPccKudG7WES9+MAAtJdQOXyE45t
 ClhJQuGV
 M+Weq3F1eGwcSsZembn3ExWa9Lokqkhveni65aMIa6WEPa9ZRkYHor/+43cRdLsf1AWHQ8AJNqv6z9TNpQ5XbIbdqmN7EYmrtuNxob46VwVk3ujmSg7O5iZs9pQTnS8T7JelD8KZsLOJ1/QRfcJNf5NkYYWPY2VAy9jbnzqH1cUyu1ZDdCNIraSYqVitumtW8piyNSh3sXORGFss+AbZpi6k8vWAtvx7C43j5QV1uZGqAM98JxQIjZKvAFs6BqNDYNonjLc0XskuDz7jTjRamFKrDXbN4Y0hedaZ1sdrYHglp/xjcUzX7Lp1kHjXkXI4todWPq9+XP0VP7qTi5Ra/FGHbDjB/yB2rf7CLFvfuGpjMVCvGyfib4CX1KsJiWC+wGXlWX4+aT8YuN5dzVqo14/qGTJ+BMBD8vSbonMB6yTvCLiImwHGek0Yl1MZd0SorMTVeJDP1sK531Hagzcj/FU+Ew5G921Kd2tyF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 24-02-26 16:44:43, Michal Hocko wrote:
> On Tue 24-02-26 16:38:01, Uladzislau Rezki wrote:
[...]
> > I do not have a strong opinion about workaround you noted. Maybe Mikulas
> > can switch to NOWAIT flag instead.
> 
> using NOWAIT for the full vmalloc allocation would be just too easy to
> fail under moderate memory pressure.
> 
> The real question is whether we want to provide some sort of backoff
> early but not way too easily allocation semantic for vmalloc. If yes we
> need to get creative in the vmalloc internals rather than expect callers
> to be working around that on their side. History has proven that this
> just leads to tech. dept and more work later on.

Just to make sure we are on the same page I mean something like this 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..791366fe44e2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3798,6 +3798,8 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
  * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
  * GFP_NOFS - memalloc_nofs_save()
  * GFP_NOIO - memalloc_noio_save()
+ * __GFP_RETRY_MAYFAIL, __GFP_NORETRY - memalloc_noreclaim_save() to prevent
+ * OOMs
  *
  * Returns a flag cookie to pair with restore.
  */
@@ -3806,7 +3808,7 @@ memalloc_apply_gfp_scope(gfp_t gfp_mask)
 {
 	unsigned int flags = 0;
 
-	if (!gfpflags_allow_blocking(gfp_mask))
+	if (!gfpflags_allow_blocking(gfp_mask) || (gfp_mask & (__GFP_RETRY_MAYFAIL|__GFP_NORETRY)))
 		flags = memalloc_noreclaim_save();
 	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
 		flags = memalloc_nofs_save();
@@ -3940,7 +3942,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
  * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
  */
 #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
-				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				__GFP_NOFAIL |  __GFP_ZERO | |\
+				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
 				GFP_USER | __GFP_NOLOCKDEP)
 
@@ -3971,12 +3974,15 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
  * virtual range with protection @prot.
  *
  * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
- * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
+ * %__GFP_RETRY_MAYFAIL, %__GFP_NORETRY, %GFP_NOFS and %GFP_NOIO.
+ * Zone modifiers are not supported.
  * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
  * by __vmalloc().
  *
- * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
- * and %__GFP_RETRY_MAYFAIL are not supported.
+ * Retry modifiers: only %__GFP_NOFAIL is fully supported; 
+ * %__GFP_NORETRY and %__GFP_RETRY_MAYFAIL are supported with limitation,
+ * i.e. page tables are allocated with NOWAIT semantic so they might fail
+ * under moderate memory pressure. 
  *
  * %__GFP_NOWARN can be used to suppress failure messages.
  *

-- 
Michal Hocko
SUSE Labs

