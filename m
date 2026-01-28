Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E3C9D25B44
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67E66B0089; Wed, 28 Jan 2026 06:37:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12106B008A; Wed, 28 Jan 2026 06:37:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C148B6B008C; Wed, 28 Jan 2026 06:37:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1A6B6B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:37:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77B6216012A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:37:54 +0000 (UTC)
X-FDA: 84381173268.05.9396C44
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id A57F320006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:37:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=jECwzv8B;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=qhFYLLD9;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769600272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wtyO7XYUaz9mOuesnWv95Jo4C0Zc65c4VM15labksX8=;
	b=rv0pMqeAlLPjkIswSF0n5QiiPu1sRsR48fQFNnBZAn3PbcjiFUC3Hh7dzSQQI3/O6SDwfi
	0wSjiUZRJW3V180glbb66Z0m9SlVHJYXCvuYnAjo/IgxYtphVRg5H6X+5VzjDGT1QZIE71
	MAeAF+NQnim1e5KxbUm5bpjJjVOzv/A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=jECwzv8B;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=qhFYLLD9;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769600272; a=rsa-sha256;
	cv=none;
	b=MXlpIaWQpfZ/1cLoLMeGyxdZHFPZYz3IOb86a4WooMqggtLozC3NfP5OYokmzka8Cg/CE/
	WhqKBBgSOJ1j8gwTiAET4nkBubLep0h2nNp0DtEMsiaNWUqciQX/P1uCUcz4kKMPlCCOxn
	WXQGOcozyTTMJxCORdWa77m8hp+WNhc=
Date: Wed, 28 Jan 2026 12:37:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769600270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wtyO7XYUaz9mOuesnWv95Jo4C0Zc65c4VM15labksX8=;
	b=jECwzv8BRRAbVPN1XHND+5m14GiJR1JxVaaes+gZcYKB3hkIlz+n8Z5JbRRfOSzpi+eESH
	xFXOCta6VH50L2NLlym5L1ExphxEaYFBlZjnOYs0HGC/pRF+J4Q2/dniNngbA3SsLM2OgK
	gYEj2ajwAqV7a2+vovTmeqy9mldXBN/AwYJ9feZOL1JAgNG6LodtJiJeB270J3bQmIuZl2
	dR7rfXqQOhqEx3ZgQrk+3T6e7QHY7mzJrrz5sagI6AFydoGl6umcGrJWoRNU9DQpYGy1uT
	KNOXuuVOCHSAUrf090UzRsY+8ZgwLkgnH/qBbCOeIP//nT7n2GYd6/UnQgM6mg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769600270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wtyO7XYUaz9mOuesnWv95Jo4C0Zc65c4VM15labksX8=;
	b=qhFYLLD9tfYykNB2DRE2Fk9t3+/bbeA+5JcJi0VnRgghHk9FVWEvsf5SMlVmXGU7PlFATQ
	AmKZnTicB/bgCiAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 04/10] mm/vma: add+use vma lockdep acquire/release
 defines
Message-ID: <20260128113749.osNjwNqo@linutronix.de>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <fdae72441949ecf3b4a0ed3510da803e881bb153.1769198904.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <fdae72441949ecf3b4a0ed3510da803e881bb153.1769198904.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: juruyg418tkc9ipa87enbrbaujgqzxxy
X-Rspam-User: 
X-Rspamd-Queue-Id: A57F320006
X-HE-Tag: 1769600272-51475
X-HE-Meta: U2FsdGVkX1/fGwSLpbPaufodHvMyC7UM4ycPZb6Yz22h6Gd27IwyG/S8w05byv/kwjSOOAjsZII7W4FcYFxGdx6HQ6BKoW77CUIIlEUKbaJ/hTn66Was0wZ638NTNeXcEjOuoswCTuUq+8gkA8ACGERonRrPljlscokkclVH/4+i4ezLzJ0cBbZU/aNw3VgXYb64JVfhRpn1mAhfyEragbboo5ChA+RU8ovp9TpvVmRJOsWwTxFHZ97sCti52v+gQNkoOYyHSyC9BLrFCdA+cWDlIawMs7Fom+yjG7XvOpq6gWgnA6XsKL6VaDeQmVgfSbxCIXToGJfIa3Mk0V94wYogkE5sVBtUb75lZXMfm9ZN/jADzlzNAFo9+YEg/wIvq3n8WTl/ecroLSup55lmD87mBQc+mCmFPLAysoa1boC57RkNwoEC0mRpDN/jcSRufMRrO3bwbg2Qk3vklHQ3ZvXAoyqNIXRK7KAbTGYIh9N/1GIg1uLJIUBJgyx5j31Ht+VY1AJvUa/pu5s7zZPInDlzp5kq9xfDv8wPS67BONCccg0N8MiUDRfx9DpElmbdyto7CbAPHkOY5X8EW0PodYNwdHPRzlQuATLb76sawrlCiTUNgRJC+ZMwo2MNe76dmpXcKFHocsi5b8YNmRo6cmdtQoWFM/C5b4LVZ0ZEgn+I5oANEOryIRbNMhAgy+txYEfDsttYF/qO6G0U42VF0D1XrAxVOXEn05uxDF2Ji2lKg/gIEE/53ulVBx0T7kQ+QCx5GZ6XsHZMmY+MeCP+MFxszvs+dFKXEDfXG/8i11roFVWi1EV3eYyqCdVEVx30b7VssjEoQBMrF0ESbVu7TvtkUshNXaIZ9T+ah7I2yuafOQOQTCWq8N6sUwMt6mSpd9jUZIUKKqXoJ+Zd/X4ONa6Pfs7sjAjJJVX++blYSLS6Td85p9JG3LDQ2b9EDZqRs7QU7vry24FfPyFn+O2
 5UScr31W
 fecvgWC+eFPj0rFgM6T/ga/cFZCPE+iZe+n3yNxb1OI63vy358DHj5YpalGLocEmBtOYdrilotxrS+/yJ35sI/xb8xGzBV++9mWBSPhPJyv8P49ug8o6NkyOffNm0ZpvzNnhiWJ4yuf9C0UuwO5QqvdsZv4f7Ceqz3hK2s6tXAG45kSlOB1qY2WIu/4Z3YAPcQ+wacqIV4UywVp8Ue0xpX2z8+s5dgx6mie1S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-23 20:12:14 [+0000], Lorenzo Stoakes wrote:
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -78,6 +78,37 @@ static inline void mmap_assert_write_locked(const stru=
ct mm_struct *mm)
=E2=80=A6
> +/* Only meaningful if CONFIG_LOCK_STAT is defined. */
> +#define __vma_lockdep_stat_mark_acquired(vma) \
> +	lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
> +

After going through the remaining series, I don't think I found a
matching lock_contended(). So perf/ tracing just give you a few
lock-acquired events. Wouldn't it make sense to also some
lock_contended() events where the caller had to wait before it could
acquire the lock?

Sebastian

