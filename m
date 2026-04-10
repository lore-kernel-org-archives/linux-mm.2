Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F12FE9905D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5736B0005; Fri, 10 Apr 2026 05:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F8B6B0089; Fri, 10 Apr 2026 05:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207216B008A; Fri, 10 Apr 2026 05:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0CB9C6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:40:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90FB01B7C35
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:40:05 +0000 (UTC)
X-FDA: 84642149970.01.EC591E2
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id BA42CA0006
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:40:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SCXViYt1;
	spf=pass (imf15.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775814003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99FMaXvDwUdtqA4Kvo6xXkRxUDamAjmOyuXrrlPWqrM=;
	b=DDzwix3rEq6wjapmHgcLpMw43BEFi9PzWNce+jJzqOpQEqpJm/+Vbzl6ORs84HQ1nfgzAN
	zxG2+iyUSWhelPmBj1LI59dLZA6zUn9sdEzp1w1e0FsEXEmvOG+wCiVrx3AcubPvfO6wXn
	DRsF12DNVBLIS0BfDrBx1QmgqqsUTUs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SCXViYt1;
	spf=pass (imf15.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775814003; a=rsa-sha256;
	cv=none;
	b=5FDawwdCOvKHnUr4jabHeNvK45ulb4yB93A1xS8Rly8Z9pJu3U7tkxO98La90RRWQmQZ1S
	8FdP8yOh/qoPkiHZZiFPLtd5ZUdO0WaN6OBSG6l0k7inT5XfavicQesJkiv7NwWyT2b5SJ
	MF4Kp9VXogIJxQFgaspmbLJWknqU5Yw=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-824c9da9928so1655821b3a.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775814002; x=1776418802; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99FMaXvDwUdtqA4Kvo6xXkRxUDamAjmOyuXrrlPWqrM=;
        b=SCXViYt1irEYeDQH3/tTEfFBUHLs04HKa1LX8ddb9n890m06dRFNfBlBMkJMtZ4l9f
         V31f/v/8hbm+moRPRGpDmhTMmcfRnO8P8evqV0zTGiHJc2N9Oy0bNNrdOwLzZXH8fw5d
         YYEqYeG4f3u4NyRnw4PjVEaiAWz/l8czPrkkcgGkJ20rg5GxbsVLGcosIeF/7QPbmffp
         0hBr38Vr4zsrFr9UMKM+a5En+Iz+Cd0XLwrG81wjJbRB4SXqYI8WnOF/T1EAoxsz+SRi
         VbTSCeUTK9xooJIeGt3qa6NH2A/pCViSBNqiwa+CLMu+Er3hxo1gZY35et6J94pvDqDW
         anIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775814002; x=1776418802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=99FMaXvDwUdtqA4Kvo6xXkRxUDamAjmOyuXrrlPWqrM=;
        b=Vfxo9i1YPVkABXQ3Uc6DxrOE1AJOuVtnsgtxtmtyazoe3/F04cEAyLwtZbvDgSVegi
         qsjZxttbdPLA3NazOalEdxgnoWN977ES7DG01b0YaqKfqtDYL0wNRzAKJgmRb39ucYaS
         6H6yfTlFoeFrqJiA8x2VzPeYprFUH0HXGqr8xNr6IdK17KfUyu5PkZiLQ4JnAqJCn2oL
         NIols+pj3W5C2UwOS4XGGhbiRG9R6JMdDDXTGZrw5x6fgHGaAlXYqVpYMDBQfnNwFmfV
         wt8NDBAFl70mA/nr4f5iU79Qwv1Zgb6sSUdtyZ7KKE7xbWSK+nwWg0ySMQfsD0ZOUDew
         pDwA==
X-Forwarded-Encrypted: i=1; AJvYcCX/3ZWSu/tQ9mbrJqK9K0VneoS5kOAS/J/C2uWqOMg0qBDYKlbVVWQSqYTctwCRxoS8m+AAqotRGQ==@kvack.org
X-Gm-Message-State: AOJu0YyOQYF4IA1jmub/PtCeDaoSAizpSmJooxBp8Ztn5ysR7mSmdBiT
	lARYEKlw/jwxHQQt7K++QqSkXMrHBCaupUmP/1V5QOpfYIQEp7T8SoQP7FAEJw==
X-Gm-Gg: AeBDievoCgWZPpk2yEICc9oi5dShnDWcqpYlV9SHlYMqfFfqm0Ccc/9zQOplj2f3H62
	7+wQpZ8jXcvJ68FDmTU7Rh8KRovMoz4OCxdLy4zyVf1sK6wjcKATPReaPsIg90Gk00ieW91G3lX
	GgHOjPyHQziL6sKjp3jf2F7geDKk8Xp8if3KJybLgcS7CMP0JGTy5sJmozbBqz+OEnbu9wzx3Dz
	ORnTODKjCfuwYF0i+pXsqR0tRU4UH+StRagJctb6ectOMbjgMQy0mcOD58VSmcenH1RI0pwVjSB
	+jhAciOn4eSYAN3sl5LzHzgYlbvcE1HoNDaaoWkv4hLo0NWRHvrwTUw3l30AKnLoXhEUQcVKg1d
	nnMFWlP2hLFRcTId8bdmFklFyLcHm6j7gS0GaxUWNzzzcFFuUUGtnlGvKpItHhXQPlk+6hcuYdp
	UU0a5S1TQQQuiP8M7/MaUkJa7lOio=
X-Received: by 2002:a05:6a00:3a19:b0:81e:f1c3:89df with SMTP id d2e1a72fcca58-82f0c288c6bmr2738256b3a.50.1775814002219;
        Fri, 10 Apr 2026 02:40:02 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c52cf05sm2278831b3a.61.2026.04.10.02.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 02:40:01 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 17:40:04 +0800
Message-ID: <20260410094004.193555-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410044259.95877-2-aethernet65535@gmail.com>
References: <20260410044259.95877-2-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA42CA0006
X-Stat-Signature: t4ifg4xrni6znogojkia7g8tq54b5kof
X-Rspam-User: 
X-HE-Tag: 1775814003-159570
X-HE-Meta: U2FsdGVkX1+ElVD3N1A8tkdnVPMdrQMq5j706gqIHAVF6Q026RTeX6c+UYoPINv161en4VtGFVsKxJSQBaRmrrVckg+pDWqUcx1D2j1ZuSl7YDMsCAjHb4anT0ZOMvU40R1DOQpGyf1rAfFSBzq7icUhaMz3+qFD1Ly7h/LCn+aOzJrO2b18pmDtP2miU7SSD8gJYpmYT+z2xzVdzezJK1D6WttgTmp4H74svfsBhTeaWMuzbrA0yCI4zGzliRSzaO0bwEDKwkO4dl5TzbLWSqe6w4OF6cmSKPzU0/juyEqIV32Ayq7Sqk66R8L1TvQR2psW3JtIWIs5Z61k4ec7NAER6tKeuylJZFXnp9bzM93RRQ9VPRDdnaeL0iwOkKCPz38sZXPbQ3BHSFcZT67186TLaf3Cm0BAM/2eWz+RV8jYmUueN6wzL5lkwiIzsu+7m+qQbPY3AAP4s41EOhYxgzq6X9LrN9Xs/+43KTruJ/OWpQkRLke0Cz920zOgGsuPcW5sbs2tHFn50JTH6eUM061YzP3JuKCTKca7YscpHgVtMJaRh66jUQsvBvjwmMvYXSGXXGZ7xN6fRn4hy9mv9ho7e6HthQ+F0E9k2Pw+xV2wQnftaobf6EgA/mbmjmgMQP4Ej/f98d4Hh+HGGVAajO+On46IoL6XRiXHGl4voLQppWbUAe7x2xlzcq44dsL8Wpvt7JIse8b/0PqCPWb+4bIEiHGnFa9nZeDGcjaVAItAQ9JbD8sfOYYRMRsRPvRmdEErh8teFFUB0aFgc5P/0cS+YRhUgDv2ks+nHGJIg1eTiJ1K/caNu8KZsQAZRZf7vGbLLZ3k4SAs7d696ZblwgkTKrbY+3NfGrdZv5Hk+N75aiM2xma87r67RGKbUiw/kbshpH9/3TQn/cVw/IKQ4CDlfHJj8+hmxoZC09u1Q30QKWrzu3LLlpKBpJKPxbCHv2Zh4BKIVG7MShBi0sV
 HIALWX0v
 T+KjsMFNFi0KYyRa4KGQXbtiAgdpYeJZpfJKzAjO+yA4YdI2EfO9pXyEDx9z0hOb5zyOePbj/CZ+UsQSkPK8PLCzt8L5rPHncAqgQrV+SN8iJIKNbYRtoRFZWUJQeWcm2Ylq52V3LWuoum2LJLplnr+vCZ0LKRyEpiWloXL6e8icFYhgmlSf7BQOW8GnkjTODl0pCeSzrrCyFZJkNbSVX/CjIQuGTAThKtY0CGMh1MsOATUAm8du0rQvo6upPzDHXDJf1uCXWD2T0faVG3PL/3coMQhrMhN8IYfgoJCtW+xIVC70r5IUnIFF6Y2JLv6KiEVLW+4ewJsTkJaod0BTcOTB8nvFqWfIL/Rl+im886JtVQQQJWOlXwQ3cTiLfEl4mdspQ1ctyu2cXJO32HkXjGLtEjrtN8QDOFiPkpmZ9QwhkFN2x+H+YakNNC6v7Ah+rpIRsayxl5m0a+psqtW+iwy7EhFkfdlQLFlgL+6b+wkbz3aRbwmjo0tHAt5Dr48QShzfouO4yuXsTdYmZ+cOqlWF3P9wE+nFphwn0JYuv3TXj4in8OGkUyaGGwpAKyXmj26sc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko found some issues.

Forwarding full sashiko review in a reply format with my 
inline comments below, for sharing details of my view and
doing followup discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260410044259.95877-2-aethernet65535@gmail.com
> # start of sashiko.dev inline review
> commit bc048f9325d07815d621e80f3c40408c0210af75
> Author: Liew Rui Yan <aethernet65535@gmail.com>
> 
> mm/damon/lru_sort: validate min_region_size to be power of 2
> 
> This commit adds early validation for min_region_sz in
> damon_lru_sort_apply_parameters(). If the user configures an addr_unit that
> produces a non-power-of-2 min_region_sz, it immediately returns -EINVAL to
> avoid setting maybe_corrupted and unexpectedly terminating kdamond.
> 
> > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > index 554559d729760..3fd176ef9d9c1 100644
> > --- a/mm/damon/lru_sort.c
> > +++ b/mm/damon/lru_sort.c
> > @@ -294,6 +294,11 @@ static int damon_lru_sort_apply_parameters(void)
> >  	param_ctx->addr_unit = addr_unit;
> >  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
> >  
> > +	if (!is_power_of_2(param_ctx->min_region_sz)) {
> > +		err = -EINVAL;
> > +		goto out;
> > +	}
> > +
> 
> Is the DAMON sysfs interface also susceptible to this regression?
> 
> When a user configures addr_unit via sysfs and writes 'on' to the state file,
> damon_sysfs_turn_damon_on() builds the context. The min_region_sz is
> calculated directly from addr_unit without a power-of-two check, and then
> damon_start() is called, bypassing the damon_commit_ctx() safeguard.
> 
> Since the DAMON core uses min_region_sz as an alignment mask in macros like
> ALIGN() and ALIGN_DOWN(), can this cause memory corruption or infinite loops
> in functions like damon_fill_regions_holes() if a non-power-of-2 value is
> provided via sysfs?

This issue has been discussed before [1]. While it's a valid concern,
it's outside the scope of this backport patch. SeongJae Park has
indicated he will work on this.

> 
> This patch works around damon_commit_ctx() failing due to !is_power_of_2()
> by performing the check early, but does damon_commit_ctx() still have a
> regression leading to unexpected termination if other allocations fail?

Yes, unexpected termination still exists.

This patch provides a minimal workaround for the specific case of
non-power-of-2 'min_region_sz', which is suitable for backport.

> 
> If damon_commit_ctx() fails midway, for example returning -ENOMEM from
> damon_commit_schemes(), it leaves dst->maybe_corrupted = true and bails
> out without rolling back the partial updates.
> 
> Even the DAMON sysfs interface, which attempts to mitigate this using a
> test_ctx dry-run, could experience a time-of-check to time-of-use race
> where the test allocation succeeds but the final commit allocation fails.
> 
> Since these modules operate under memory pressure, if an -ENOMEM occurs
> during parameter updates, will the running reclaim daemon permanently
> observe maybe_corrupted = true and unexpectedly terminate itself?

You're correct. If damon_commit_ctx() fails midway, it leaves
'maybe_corrupted=true', causing kdamond to terminate permanently. This
is a core error handling issue that needs to be fixed, but it's outside
the scope of this backport patch.

> 
> >  	if (!damon_lru_sort_mon_attrs.sample_interval) {
> >  		err = -EINVAL;
> >  		goto out;
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260410044259.95877-2-aethernet65535@gmail.com

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260410044259.95877-2-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

[1] https://lore.kernel.org/20260403155530.64647-1-sj@kernel.org

Best regards,
Rui Yan

