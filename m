Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA71FD778B1
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 00:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E706B056A; Fri, 23 Jan 2026 19:54:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C006B056C; Fri, 23 Jan 2026 19:54:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178DB6B056D; Fri, 23 Jan 2026 19:54:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0089E6B056A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:54:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5274816012A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 23:36:12 +0000 (UTC)
X-FDA: 84364839384.01.FF00F02
Received: from mail3-164.sinamail.sina.com.cn (mail3-164.sinamail.sina.com.cn [202.108.3.164])
	by imf15.hostedemail.com (Postfix) with ESMTP id 22949A0003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 23:36:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=rBni7HNS;
	spf=pass (imf15.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.164 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769211370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeRxzUMP9svcMWdDmykegfRAU5lDXzkoq901kD2a6LI=;
	b=ojn2MDwDvcxhOO8x1EL4J35xy3X5mZ1ZSXuEsQ+F40+TujYqcGd4NoR0VZu4zZiIEx80cT
	8FnjqjA+LY5mhsXCMwZ7ePJHOEF8cCtmLvpm6q19M0aKHN1PAhXBFufv8BKu+h4xY89C15
	4ey5x2CpPENnThrSNx8cfypSDUnRgdc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=rBni7HNS;
	spf=pass (imf15.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.164 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769211370; a=rsa-sha256;
	cv=none;
	b=RZZS2eWOmk8LeuIRBxeGRgEiwb/5cx39o4LO6MxllNYLjj97p94g7/dhqRIAEXuaLJ7BO0
	396eUEwPdaBs2hMH8+85WAISwbSE/OQMMoOk0kNt/fSgiiTLA1KLCIz035mQfGIl/yaE3L
	6lXmP2ENoPC8OcPTyHoMxKqbr1RtYYA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1769211369;
	bh=qeRxzUMP9svcMWdDmykegfRAU5lDXzkoq901kD2a6LI=;
	h=From:Subject:Date:Message-ID;
	b=rBni7HNSQkviegzmMIYKUKGnJC8M0h7y0hW3lthaKE3GKY7HjD00sKE8//f0Ed03h
	 rxLxqdAJM/Dpq94DgrzvabDnAjBJ2352UAhi6SiZPcbqa2x5/Owwhlh/Iry68YUskO
	 N1I//0Tt3wEte8QwrzsRX9ZWeNGhxEZgTrFFyMFg=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.160])
	by sina.com (10.54.253.32) with ESMTP
	id 697405E00000164D; Fri, 24 Jan 2026 07:36:03 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 4303764456699
X-SMAIL-UIID: 3327A5830D0942A58BDDC99F01B85E9B-20260124-073603-1
From: Hillf Danton <hdanton@sina.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH RESEND v3 10/10] mm/vma: add and use vma_assert_stabilised()
Date: Sat, 24 Jan 2026 07:35:48 +0800
Message-ID: <20260123233550.2378-1-hdanton@sina.com>
In-Reply-To: <43c90424ba0874a71bb7ab9d6423b3a2bf616f8e.1769086312.git.lorenzo.stoakes@oracle.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: zqdxsrc4zibfwhe6xwpa3boaae7or84g
X-Rspamd-Queue-Id: 22949A0003
X-Rspam-User: 
X-HE-Tag: 1769211368-798635
X-HE-Meta: U2FsdGVkX19tnqOT2SkupdZnQ7pdUhDELNWWU0C5oYpiYLTG1he8uLyYPKJmi26FDq1iZA/QHA7tAG2JZ0MgwxI/tN2qKmb7k7aAcvr0dZYMJK2FJ5OkQb3NDkGxnWKboDokyO8H6zO0qkxbo9rXfZtgNPrI/DGSl6oJs1/Ur04HtnAcpYCd7gaabaRkp1HQdCMto8OXSf5uSCp8aUJ8YOO3oZxHuCUR7lgIm3rXg1AscGNMfl7iJjOAwZsyQlgbzNe5lSn31Tc/WYJlZ96/1NAtRBJrWnsY4Ljl2q4/7jJvhWQveIn5E5QA5z3YpMDqCDABd2eis25VMjYL2r+OvTZlMqtMkWwlTU5Bd9vNKOjpUtasslINC+3sM4g5y9OPgUYaP6lwyjQwBwtofWY2zPwCT4FSDqqU+BLRzbRmzRma99BPEE60JtueJ5lYbagHbxwCbwsbbtqc5257H1maGyH8F17PXgqS2x4bkz7jb/xFi8fPOmgpGCwoCmdCOxkI9Eq5HuzHlM4TaNjtIyJidm7fL7Equ0qOVLbpUPX1kNVG6OWZNSut6A80jvqmY+RtNe475LzWXh1y9XcIUKklpmszWu7zctmHmAo0kKenqMFfw1TViy89F2j1Lq3AZSbg8ki8emBUc47/tp3DcbTlLDJlAVXv1fRxMrymcj8Pmg9TATKGTskKD6fYQggCfdfPZsAurRZ53Jgxg9RaHTFIfjHlxew8Y+j2v5AB7QbjXXOow5JOtd0cMtMqU/uSH4Ibn1L3/7wSEZ3YgUq56BYle9dtQf/C0xRTIWCWdPwY67sdXFCyfFos4Z4VZfuIvUJxJhU5Hrz4tjMZh8qHkdVevPf9Jk5++5KVaEdpFJoZCC7MfvqvMpb6+so3w+tqEaiKbFlAGbej9p16GHUc32PPzrOLr6EiIte+/w21YwtogRSQs2RjfIWYtmKXLEiP5eFQrHntNTq+1tr8cbpDmw8
 0GVSSgcF
 vG7Z6bqMl2Xq5JSZbXjT+U6U/3bRy3BNtODWQO2DxsWwQnysHxlb6rhsQCiDjX8Xky0y2/sI/nNdE82hvVEMX21r59mUy8j6Jzaa3VInVbQaOS+9c9See1NrW/XICRUxX5MRq5bGYEtUcdBMjqx7l2nxzHkALGqQNm5Yks3k8UfHRQYwnmXfeqbNz95/cqAIxwhgsm0Qn6ULliPln9jwbhvJzfthmo5PlDOvu+I6mTcDN7jGXIY2vMr2GR1Xrd8e9s2AH24VtUBqevFjnSlKBO+SbMi7dEa5P8zXX7rsMWObDu+t4N0NQmEczC4OYyNEJS0dKpsq6lbiyqAYeZS6EBEmwmRY4F8hJVjXl61a3KRgKJ421DvUA+seGf+kt6FxuWW/ENsLGT1eUke1O3DaAMV8MOoQrs57VI+Ixjgj8j+DgtmsZgH4u4t2F/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 13:02:02 +0000 Lorenzo Stoakes wrote:
> +/**
> + * vma_assert_stabilised() - assert that this VMA cannot be changed from
> + * underneath us either by having a VMA or mmap lock held.
> + * @vma: The VMA whose stability we wish to assess.
> + *
> + * If lockdep is enabled we can precisely ensure stability via either an mmap
> + * lock owned by us or a specific VMA lock.
> + *
> + * With lockdep disabled we may sometimes race with other threads acquiring the
> + * mmap read lock simultaneous with our VMA read lock.
> + */
> +static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> +{
> +	/*
> +	 * If another thread owns an mmap lock, it may go away at any time, and
> +	 * thus is no guarantee of stability.
> +	 *
> +	 * If lockdep is enabled we can accurately determine if an mmap lock is
> +	 * held and owned by us. Otherwise we must approximate.
> +	 *
> +	 * It doesn't necessarily mean we are not stabilised however, as we may
> +	 * hold a VMA read lock (not a write lock as this would require an owned
> +	 * mmap lock).
> +	 *
> +	 * If (assuming lockdep is not enabled) we were to assert a VMA read
> +	 * lock first we may also run into issues, as other threads can hold VMA
> +	 * read locks simlutaneous to us.
> +	 *
> +	 * Therefore if lockdep is not enabled we risk a false negative (i.e. no
> +	 * assert fired). If accurate checking is required, enable lockdep.
> +	 */
> +	if (IS_ENABLED(CONFIG_LOCKDEP)) {
> +		if (lockdep_is_held(&vma->vm_mm->mmap_lock))
> +			return;
> +	} else {
> +		if (rwsem_is_locked(&vma->vm_mm->mmap_lock))
> +			return;
> +	}
In case of the mmap_lock, rwsem_is_locked has nothing to do with lockdep_is_held,
as the latter is noop without lockdep enabled. And the former fails to match the
us in "assert that this VMA cannot be changed from underneath us either by having
a VMA or mmap lock held".

That said, you are adding confusion.
> +
> +	/*
> +	 * We're not stabilised by the mmap lock, so assert that we're
> +	 * stabilised by a VMA lock.
> +	 */
> +	vma_assert_locked(vma);
> +}
> +

