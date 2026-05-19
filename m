Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDBACD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97BC76B0088; Tue, 19 May 2026 14:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953386B008A; Tue, 19 May 2026 14:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869846B008C; Tue, 19 May 2026 14:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7808A6B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:56:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 159EB40687
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:56:43 +0000 (UTC)
X-FDA: 84785075886.01.85BAE9A
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3AF1A0003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:56:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tujU1boF;
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779217001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJ1om1XG26k9c/pw0fQSTui/sos+jK8LcvkwRi0HW+8=;
	b=QcBOH3nGyfzf69lH/wyv56gR+0bzR391QMHnd8T9ZncD1rpv8iQT8uu0lN+ehbVwkXWhXC
	5ujLpQpG1kkmm6KOU2BUh59k8T87qd1/02F5byeHJJvwbZOqor6BtaO6pAoZ7JI0In+nHT
	dLyY4SL5x4NhLt9//x5gtH/q/XIedpw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tujU1boF;
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779217001; a=rsa-sha256;
	cv=pass;
	b=fHIQWS/5fBwBoaXz/wb9c7f09Oj1S9NhLu7cctO3o5HmtmUbprbQPkj75s+6dn9FZlWTom
	1nBEnAfa7npkUY1SWw6R0ReeouyPtKA82aYL7kRPPlViOo/0vQdDshm8ZRSpRPPvPoj5je
	vxRdpOZ1/6zJ4OsGj95r+TB4HNkqpTY=
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-575267e3398so3234237e0c.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:56:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779217000; cv=none;
        d=google.com; s=arc-20240605;
        b=UrjsAVZ0lJfYOTnNxMva4rl5VjqVQI38ZLrDKewlYmlfyQ8X8OpvoiHbpfaMOHshyA
         LXpl5po3WlFxRAOrW2z13qI6b7UG8hUILxkHfN3GD6/PzjdtQpe7A4s6W3DRYObB132p
         3ke1F+yNIU+C5TqGXKojxwSzSdAKgjQFnCf5ML70iu2WS2lGYWnTtN3/a4DOm6GGxT8o
         51ot6EZ660nqantewTebJZmmuhhPSIGqy2YvyE7+0fZlhv1fakhYWQilwxSrcN36eisu
         W6f/80aePzp1ZcgSB+ccm8TnT5zXVHAxJeHgzxpb2AtO1Owyz5yTmk6ri1+w/JATlr85
         Whmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ZJ1om1XG26k9c/pw0fQSTui/sos+jK8LcvkwRi0HW+8=;
        fh=mKa8AgDPtJPCseROymMvXRXtcCOMPEvCOmVP41vPrqM=;
        b=H1oZ+dvi4yDG9WsDm0eKjiyP74mLQbhBkhyGGdaDRRhHw2bozqGoa44c8fnIw/bwr4
         NFrJLsTSuM25jyYz2zt+5GYzeARV5908cFdB0kngE5eWh90hCWaWmT32z7kKH4OAc0u3
         7+Gv6Ch+0m7iRH6I7OMtRelvgz/EuobOkLnZeD512iMRuFoPs4Dli9y21Rbo/Ebrzmok
         mxyL5Qe/yuhEwISq0Ch6TI2EdHfK53S1UmJXJu1OUwJkaEMxx3pFDX+iDxCHOFG8xTCA
         DozxtpcLckVWPw63HBZzxs8OmaEVIdjZ2WibQ/xpW/I9MmskA4uSlas1FIze11mxI6Y9
         Z22w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779217000; x=1779821800; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJ1om1XG26k9c/pw0fQSTui/sos+jK8LcvkwRi0HW+8=;
        b=tujU1boFknyUl2NWuSUa0KeHUK4WdIcQvwP5Uy9SY/xsDxvCHn+9m+HSshzYWetn68
         yghshlYTe8ujQsGwkFC8ow8GtNIvqx4LY7FvDUFbQl9Mtog7cdvwLimuIV3+jssIVP29
         xCc/LtjIAgLsCsuXe4C/rzm4w+JIsnltfqkkkPDWAnN+y8RxrnrAcBiZD1pXoVArsx3m
         DZLBB3RIbetgpZJ9FGp97WwcsCsbfz912+C5ah5OOV4fV6zL40a4ze2OiqKial6WoXl1
         HFzXV0SUx1n4khJQDmR+FZhUDeZANaUJoR0hxZg1jYdGlSs8NQrMJX1knxcnWGZ1QmO7
         JKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779217000; x=1779821800;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZJ1om1XG26k9c/pw0fQSTui/sos+jK8LcvkwRi0HW+8=;
        b=IcUFGWMBeMc3nXm8xhLwuiVtAvvqcrUAD5YrVf8ZDD/qzzntHIVsTohn8ISSa78OTv
         BQxoBeKzOix8/qn/y9ObArg2sphl3k5oUdZsnGru+5T1bcz5yUEURdPBJLobO8UyHyhw
         0ILADBXYXQxm3sqD9/zm8yoPhtPiILejhpXPDzG7JRutooILoG/1andv8MzjIpPsr0K3
         V5sPDCD75IHV08Y+VulltwcKOv9zTcS/MSg+c1DyLyj4K3fCqPKtHtkUOCe77qVrBHhF
         HwSz1qBCMs5fzquUXMqASB3SzOAujg0a7ZyZpBK8leIIGKT6+WRfAchJa4iYeHGbSPkJ
         0mCw==
X-Forwarded-Encrypted: i=1; AFNElJ87yGFf03wjz5uKdOG7vVAxjOQNzgMcjWSWz6KRd7lsdyWcFr+ElxAtrEMKhu66piu52PEHHriMug==@kvack.org
X-Gm-Message-State: AOJu0YwdOlBC99n15Dq5NVIFYl/jJ74W6ell0a8Xm+eoliAgQ17uNX66
	Mm3NwAjqj8acMKxbeVoPNm3RfL0Tn0K3IL+YvHbAgIZa/23ZE4m9ZKPrixyognx3xjpaZVsW/KF
	yuxk8s4OJ9fx6HgYsQB1su5TS3ERC1slafOrxEyIQ
X-Gm-Gg: Acq92OFlsuL3wTUUxe/Ds1sm5taba1rzHGMLJYAcPh/SLS1EvDdfYBAFp5DoBYrWc+6
	ju1k1JRq0Qj1PhfNj6BWj1O67u94C1Prej5HqgMqZI6WRWvLNu1UUxgkPeWW9GZVf9s6f2Hh9uO
	ZOMHrmuBZRohqHs2rMDfXFg/KYPOyOMJpSUnzBaHnKu2iC9OOVYlvKKO7Ov395M0RyWPrsgaT7T
	eswguaC4qLsef+d2jDps2e7OLuEhLASna2uXGZygRtklH0paUqxezHUbOgmE5rHSxKmBuyax0Z9
	RcrqrngZFxdINI7Qkb9cwY6d1aIAF4yX9owM1giK5K0WpsoavWlDO1YjgRTNwT0YR8ilfrXw8QZ
	IvY+0
X-Received: by 2002:a05:6122:d86:b0:575:3b1b:ef01 with SMTP id
 71dfb90a1353d-5760c0a6a7bmr12548926e0c.9.1779216999523; Tue, 19 May 2026
 11:56:39 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 19 May 2026 11:56:38 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 19 May 2026 11:56:38 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <agt5wTK5I-FvlB57@google.com>
References: <20260402041156.1377214-1-rppt@kernel.org> <20260402041156.1377214-14-rppt@kernel.org>
 <ac7oE_1j6gxf8OKT@google.com> <CAEvNRgHd4azPaMddvqnSG+Z5fmg+LWd+pz=LSB3PrJTW618dww@mail.gmail.com>
 <agt5wTK5I-FvlB57@google.com>
MIME-Version: 1.0
Date: Tue, 19 May 2026 11:56:38 -0700
X-Gm-Features: AVHnY4LPzDj9g5FV4_YaYz9tvR_M1MnLgRQGl6BwcjJkV-QhnQjrw8WLfhjN4fQ
Message-ID: <CAEvNRgE+xXRTWHzAetYhQN-OeTHipspbfvYNzaExe89E_sRkBw@mail.gmail.com>
Subject: Re: [PATCH v4 13/15] KVM: guest_memfd: implement userfaultfd operations
To: Sean Christopherson <seanjc@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrea Arcangeli <aarcange@redhat.com>, Andrei Vagin <avagin@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>, 
	James Houghton <jthoughton@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Oscar Salvador <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, tarunsahu@google.com, patelsvishal@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1dozbzia7uq6r6hiptfa1yjj5p9a59j1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F3AF1A0003
X-Rspam-User: 
X-HE-Tag: 1779217000-520277
X-HE-Meta: U2FsdGVkX19VOO4LbVby9T0AmcIMejFiDByYZNPJHBSvnKSdTajFIcZTDjKNiNHUPG3rHb/gwf8OYs+07bhBHjPBN9qPJ6HC4qJp5ifjAVz+1q5pNGEOe6lpT+EL+MvoGpVDLRdyd783vDco3AwEJTve6axumwuKtLksVH542DBEQNIeAUuhH41aN6dTIUswL4x/+PD8Be1zEHPgvcQgepgqKpW/GXULfGi4FfUCyZ/9I0jjg5nWsTALKowuitsHHHO7KYO2PWh5nXubArJ6Pb6tP2hC1Q9rlvo8DtPeFLTTRNeRkujOjNnWkm6OEAmXQmtB9G+NcS/y7spZ6shIBGzCsgHZQj6TGl2o213RKjFJtX5Uig8fjzThm+15vTmxZXZjGLRwAElDSZ6fLIp6RwBRsWgGnO45FYgRwRf0lO0f7KYsCvXCX+TCH7totEv2bQ4hsmSKWubUx8pIIlf3PDERv64Wq74ipUcxAHedQanAPcXZ2cpIxHWYN0J6x/c8WoCxkoRi2bi/DzYGKQVT4SFUSFA1VS9Fd3jBYQ/8LraT+V5cQ3Bhs003APHXzSTJKDA1okC0Im4S+xUFkPFS5sAyEd5l5tk9vAMNu/835o/P4bnsiLHQ+QMJ6a/1JHGmIBXFbBAWWZQpzEiJcUpEWQbzqEPGwbxV1gPiQyfuVLuu0632lNBvEyGL/0o5BjdWZ6EjONz90aCnuSD7h7XiBjXyy5CprpSXMFc0CI+tBlnVtfIhQIlzx6BXMoLhOwxbl6/L/5MFEoa4KbHbmoVy6p2Eg5zeaIQVb/PPilXTv1UZJ+9OYjvbdxhBCDBdTrdZJnXmYD6lHZHc3EhJVFkkS0r6xkQQiSmDe2HSiDL033BcuYGOjgKPOn4GxjnrcsQSMpdNr2wTtN+zE+3/ZjKMYYrjqjJbsboJegdaLXkLS6Ag2vzxcpz2Lf9b+Ih9NLsrv8dV2f/MrwECGhJTY3x
 PUSTe/xU
 iHpH6yKgbNSQ+U9/Y2YkbHF5uHoLIxUfTqpGAlBaL2ADs8LPgqruV7onUJbHKhcbPeKqBXCr8w31SijS87PtcdgtDGi4pqM/gJ9X2NG52GIX/iCEw7+YEFBfojpt78hbJbqzxNssM7l//CCL5qzoeV8obs1AjNvz/4F3DxExZJn+A+BEOd94gA6EsTl2oYaqY9MT3lZgCu3AYjJgSz26PMWyZgulDxOoF5q3HYjVFtuzT0Ri1ncbCC5UYAzywTi/CQrn6bnUUEWQFaf9hyP5o1LRYvMU9BH9MMvSiD0x7znNN6ZwBnzfyQPEMV8NJ4zxQxgSh1tkWzUAvK4NxhpiQw+e32ifnFwiQcULITwoPeCyCCGlFL23i4UVeXX0CVHeShyoJzyIH52f9yh3OEGbRDiVE0ISgkjmzI9jB/90veANfyFLFZUp4PPYHNdgKds1reE41FUoOjHM1iwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, May 15, 2026, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>
>> >
>> > [...snip...]
>> >
>> >> +#ifdef CONFIG_USERFAULTFD
>> >> +static bool kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
>> >> +{
>> >> +	struct inode *inode = file_inode(vma->vm_file);
>> >> +
>> >> +	/*
>> >> +	 * Only support userfaultfd for guest_memfd with INIT_SHARED flag.
>> >> +	 * This ensures the memory can be mapped to userspace.
>> >> +	 */
>>
>> Is the principle here that any memory that is allowed to be mapped to
>> userspace can be userfault-ed?
>
> Yes?  It's more the opposite though: memory that can't be SHARED and thus can't
> be mapped into userspace can't possibly support userfaultfd.  Six of one, half
> dozen of the other, but I think it's important to highlight that there's no
> judgment call being made, i.e. we aren't deciding to support only SHARED just
> because we're lazy, it's a hard requirement.

I guess this series is only intended to support some kinds of UFFD, but
IIUC technically UFFDIO_CONTINUE can be used after the private memory is
inserted (e.g. for TDX live migration).

