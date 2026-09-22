Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 399FBC982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096246B00AB; Tue, 22 Sep 2026 02:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E926B00AC; Tue, 22 Sep 2026 02:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F066B00AD; Tue, 22 Sep 2026 02:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B176C6B00AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:04:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2018E16025B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:04:27 +0000 (UTC)
X-FDA: 85240358574.17.0EA17A7
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf24.hostedemail.com (Postfix) with ESMTP id 62912180005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:04:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XZXba116;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790057065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZ4t+Je/NuLiMzspe4ek1fsrc4XzG00tppqvK5+4Vd4=;
	b=0FMTV5MoL3SGITd1X4NXhBfG51E841iI23Om3P0dhCxYfbgIvgsFDeatbMtUNJwyLn17eJ
	18BKftNNdO/f8hgzcO7k0HtwYjFV++VqbqDRqy5+EgWaZhijiuMiE+FCVfsh9f2OFfB0vs
	oOJ/vVKueIyw3kfm8wTSRXvkCSpB2jM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790057065;
	b=mEOER1YRZ9F/0vUKwtucbmrF9axk8KKVg7juRZ9Bf3UUWRfPqEaWjA3AUcsuybeXUCXBgb
	E3ett81WW/iRb3O6OuFXqaYDp7P3sRuoM9WlHp/FV0kwpiF+hUhyvLCU8qnvE3Aq9q4CCL
	VDCp0nLm0Jvls1nNodKe/jw5D0kZuC0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XZXba116;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7bcb94d3so25380345e9.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790057064; x=1790661864; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hZ4t+Je/NuLiMzspe4ek1fsrc4XzG00tppqvK5+4Vd4=;
        b=XZXba11654tJyprzJZ2TiJI1v4tvLduhINLG35PSl/iMYBW3heNyCZf8YF4WVrXHUM
         KMuh8cEl6qM4euGj14CJXsZNXSEnR7ybaLkyG4eb9l8cY8dqopyVd35X/f3Wg1zdQsxW
         hAR9yhn7jtIItufJ6L7K0/s1Ly3VVR1mIMV/BQkIHGRB+VagTufdhkxdApmEQ2mrwvZJ
         agcjP1HyMuCXMdryyExx6lnWqHS4yIrtHgesDCz/0r+lblWniodFDtOaeahHt71QwVit
         Le0DJ1TIT4hNtXJuioIV9iLytyEu4PcFASilsX+7FxI/MBihB9ql7tgH7L4m/VrU2+PT
         B+3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790057064; x=1790661864;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hZ4t+Je/NuLiMzspe4ek1fsrc4XzG00tppqvK5+4Vd4=;
        b=ac7FUDy+V9LisUkrsNEipOYcS+JKdSL/OMLVXbe+BGM2JHSnnsITYUN+EDHEYq/qal
         E1JKpRyj6iE/40rwvVkW5TdXCJN0Kk62Ck8uaecnFZsWG+OdYylmB9TPZzZDc73aKfiT
         CYSlw+jaFelBAdmI58L+yWA5wn11TpAGU0QlyE2TD9qYPeuBB/k+QbC9eLCJ6/2VcDC8
         2DqnFsxzUbb2Eos56GfuY1u4OUD7M9gQt7BYcWxSpsrVXR2BTsaIhTa5nRzAJyXTlijy
         O1wf/eqkIIC9NcqBK99yKdMqQ9K0v3jKdHav7Z/jHLAO446rWESMSbun41CdVbDkDvNJ
         B4lQ==
X-Forwarded-Encrypted: i=1; AKwUvBy/923fXzgp1YtZnocp47RWeYIhOYjIYawy2x1laS/V4X1InuYYgC51mCyvDw52jZtK/8ZAgczf9w==@kvack.org
X-Gm-Message-State: AFuF++k6LOaE37X8bUSNba25TBjU0fPMe3Gu+VJNt2z/1qcM319SgDqs
	o7694+4XNMzf2QNoYMgom7OSYGL3iYYHNg7yMwSx0nEPalaxt2J6DaLZ
X-Gm-Gg: AYBFou0KcTjjPIq+namdVLX3FlgEc/FD+ORRClnr8ltM8J5eFVQSNA1jHJVXRYLlzyZ
	KdPFyctBTe/gngRFXiOoyrlUwASLJQZUfKoVW4klyvrKCgzhP27Zu3oaFznVJn/RV4V+UPBQihz
	gsZ1cwlo9b1dr4NlUwcghJ+P/vG3g9qoGulhQoaiDjfuqu/PbCShn051A7hznxiw5JYc8e7XlDo
	gi+UyMni1i6KY2WUEOm9VmvSMf+H9zifsG4qO1fAzlF15RAAtvSrC4szNd/2tly472TDHFprcWB
	w6CEHgwcYMTtu+SaqvmwXHPwD/lJDH56GaobPM/Zuq7VybISOL5fkGObtlrNfiyytS9fvWa4LID
	6dIT0nRstlQAr6RlHY8LfEG6Rbm8Xpo5K9tBdpwvrMP/EzYbz7yFKqXjXc2cxRisRzQ7l0Onnok
	DmM9Qd+c44euRLjFOv3M4JZ8GFulsI1eDO1MeRGBpERJFBzmQJQa7pZyy3gku4bllH1cTkaZVFs
	DsKUJbhrES6Zu4fMhkzEWK0ikn0kYdZI0rejk65JLdbvguMWYEEo2BmZ/lV2/mXVSgwiaSsEGtu
	sb6R5s0HI0FDT6nCygphHQ5TW6fyc2gMEt7EZ1PRXItg3LijlzQadQM8YFHnLAeyNEYUrGWgWQ=
	=
X-Received: by 2002:a05:600c:474e:b0:49e:7cff:f8ca with SMTP id 5b1f17b1804b1-49fc5743c69mr172251345e9.29.1790057063419;
        Mon, 21 Sep 2026 23:04:23 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a5e6-3401-ecdc-1e24-2e52-02d6.310.pool.telefonica.de. [2a02:3100:a5e6:3401:ecdc:1e24:2e52:2d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48862793792sm2769226f8f.31.2026.09.21.23.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 23:04:22 -0700 (PDT)
Date: Tue, 22 Sep 2026 08:04:21 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Amery Hung <ameryhung@gmail.com>, Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, 
	bpf@vger.kernel.org, linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: restrict can_spin_trylock() to preemptible
 context on PREEMPT_RT
Message-ID: <arIY0wMQjCCsqidI@gmail.com>
References: <20260919171443.90512-1-kmehltretter@gmail.com>
 <DLJHZEZMLW0F.27OPPS218CX9Q@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLJHZEZMLW0F.27OPPS218CX9Q@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 62912180005
X-Stat-Signature: pnnutp8gsyed9oth5zes5otzhxg9gd99
X-Rspam-User: 
X-HE-Tag: 1790057065-731335
X-HE-Meta: U2FsdGVkX1+UCDfelezx7hV8jA4kEprW7wTvSS0LPFqrf64ha+xRejFK5iaOmblfwvkbxZ1IthmFr+bJTod69bzztbwf16HSa9kfjFcCS600KQuXZhXBc+bU7iDje0ZvwAiqLDSHoxCoNzJfv1J5bHVvlE/FhuO7h/157QNgFeqo61OnBXqd7FK9Hx8V8P8BrNWQdXERC/pk3BeY1nvnkjb6RTtKSaiatgI71qVh8ZgXQFY77JgEbCPy4mUmVEOm7eP0AWs4LeHOB1PKF4oIf2pySa2uUSS0sypIuHWDYZUxnJmjMHBYj78TfJY6UhXLW5uAM2AfB8tf11jTiuLyYVlo+tTpQ1vixZ3WijivzvVOtL2HpnzDpQwuUzvahw1qwHl2Z/5DPyS8M3ZodgP+EBnJ4gFTmUR5PM8KmIKsnV1XbA4gZpu7WJ7K71FINZyYI5K2NQ4INv16r6i5tLSSbe+bJYiPJIDK20b3gKL07HyRhoDfGiIjGUkx9Tb32RoxfWg8SKAsj0DiS+4pyHeoqk+901udNvj4by+WSW5GWunnMcEAvoEqqamp1VDq/Y5ngi7xcraHnIi/ySC7lfJ9Qm2pIjl5VDKbiadkgHZH9r3dbxI4qjEkdYvnE3o5S35eVUq83HfjqbQPkSd6w7NE/AbplQnGVQ3u6jdvFUDBam7+Ie43ygEjMsQ+Jo4MffF7q1xcSN7sjSxajzaykS2h8WHt1ylYUaGBiRKyEd9+/k3MlsFq+aFjAEMCnvg90S8mUF3hZbYOq4NNLUP5AZfzMcG8bPeF2wo5KRwxKoFoVUZOUlKaucImuj0mgu3Asp2uE4e9jjeO6qB2mbe0H54oU6dXzC2WAcyKl33jBvuJf2a6CLooR0kRxKPF4PymbiK6Y/JxzwUzIuqOy0QzxB6q8kSaZ4SXrSKXkb36joVKsT43w2O4czu/HaubGDWVwwWfJNXY9vvgNeO6ftw5z+e
 y7jFVSmO
 StoinTD4ktBintpyPDeIBPwbv8zsEf5y3d6qxsYnsBgwT2XZT49GLBqwfZv2/b2g/Fl5iO4Dsgkhd7agsocsxHA9Q01f4VTkgrWd2EGu+/L776zZc8aRn9h9OWJ6x6iukaNDA2gaWBaBS4aPCqeZhOwr0Sg9lAcRyqqqQrjJIsD0ATOlH8YVpaAwKrDFge7/i9NK5EuqbnQKgDXmZsLKWH8QIZ3o4Z6w8txBHghKHtwdK4rZpLo+DoHiJyXgxNV8iEPRUP+OOlGum0jz6afXvVtNDBdDjn5FatEqxQ6Cch+Zj0Zy4Muh8xOe8S3pA2TpbJ3jDDnGwMoBhO56Y2JIka9NdmHnDCtGpX0IIHgnUVUPFKuWLSxS0UfCBRH/7MuZuPamnCxZkVlbjTCpb2aZ/zNyHHOFpBkNNx6nEJD8og4MFE8rTSlZUqcZTkC5kSIl5qmicktMQu4x5lPEogpOawBRvobL/+Tvqm7M5blhwVZQctqtzjIDvfry+TWrDuS4jsbY+2ZGPt5rwI8zNJ78/dcmVsTPbX7/E5PRA2nX3Qy/T41G04usBzqrGP+T0km0I1XG10MK5s0m3syTQcbzBZFH/X7WPQPyfke+M/N3kfu15ucEo+UeiPYWzsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 06:17:30PM +0100, Alexei Starovoitov wrote:
> 6.19 had this check in kmalloc_nolock() only. alloc_pages_nolock() and
> free_pages_nolock() allowed irqs disabled since they were introduced,
> and arena was sleepable only under a mutex back then.

Hi Alexei,

Thanks for the review!

> No. This kills bpf arena on RT.

I have now confirmed by testing that the RFC breaks both BPF arena paths
on PREEMPT_RT.

> As Sebastian said in
> https://lore.kernel.org/r/20260831143500.x-saxdAs@linutronix.de
> raw_spinlock_t is fine in general. pi_lock is special. rq lock too,
> I think, since rt_spin_unlock() can end up in try_to_wake_up().
> The check has to be about those and not about every irq/preempt
> disabled section.

This leaves me unsure where the boundary between the MM and BPF fixes
should be. I see four possible directions:

a) Change MM so _nolock() allocation remains safe and can still succeed
   while pi_lock or an rq lock is held. Existing BPF behavior would
   remain unchanged. Is this feasible, or would it require substantial
   allocator changes?

b) Restore BPF local storage's dedicated allocator, and document, with
   debug checks if possible, that _nolock() must not be used in those
   scheduler-lock contexts. Since the allocator change would restore
   the behavior before f484f4a3e058 and be confined to BPF, could this
   also be suitable for stable kernels?

c) Have MM detect those contexts and return NULL. This prevents the
   deadlock while preserving ordinary raw-lock callers such as arena,
   but task-storage creation from scheduler tracepoints then fails
   deterministically.

d) Combine (b) and (c) restore BPF functionality first, then add
   the MM restriction for other and future callers.

Are these the right alternatives? In particular, what behavior is
intended from the _nolock() API in these scheduler-lock contexts?

Thanks,
Karl

