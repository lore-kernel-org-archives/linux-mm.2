Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA12606A33B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MTjETDRa
Received: by kanga.kvack.org (Postfix)
	id 5021B6B05B2; Mon, 26 Oct 2026 18:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1B36B05B3; Mon, 26 Oct 2026 18:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6996B05B4; Mon, 26 Oct 2026 18:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBA026B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:30:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6829F1408A3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:30:50 +0000 (UTC)
X-FDA: 85366223460.18.941288D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C45D11C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:30:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=MTjETDRa;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793053848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1dGqPdZiLYrsql2Rc3j/ObDweNiJt+El8ZFD+tFnEU=;
	b=AE5rKtQj+m0I0R69xTXRci4qaKFqodjhZvPdiy1IBJjMFmRR+KExOLpiUa6L5821DBXw91
	+1OU1J0yqrrZxIOJIyxYyBJ6/ZokOekrp3ylbgXWgHbWdzEiOVxly5R2XMPDOQ+oJvloSI
	bRaHsK1QqUtsVZxxxjvpbKUzcR7ROpM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=MTjETDRa;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793053848;
	b=Va9eKPbYGV+iTmQtbJF9KV0gKNuyOeg5e3ji8kSIgCc2qXyO1D9nXZoCn78dcrurblDReS
	Z7LFk+Ydm0xAOSqjeEa+ghKw4x8u6LMvuF6F3Zlu2NI5FRBSz9+yGzto+2uAOI4vWz30GC
	3/R5tpjkNaymJP6+SvTauQyojw7CQ44=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25DE243E2B;
	Mon, 26 Oct 2026 22:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1371F01828;
	Mon, 26 Oct 2026 22:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053848;
	bh=D1dGqPdZiLYrsql2Rc3j/ObDweNiJt+El8ZFD+tFnEU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=MTjETDRaX5IWRNr8zo6eKcsiJTMXj+jN5NU52GNhzTuJRRqsP1n5ZBGqcFAjr6fxu
	 EzlWBsvul3YDuKCrGi/ceYnyJDr/B1kyJy9gRkhZRGf8lF5CJDGR0pa/RpbRCnrHme
	 T4f28IThtV4cEhl2fY3ZvlQdIPaRab8JY0x4rOR0PyNYR4PblnjRrkwVxvMr6ADALH
	 ks3gMfQjUnxNgrqTZVy/T19F6SFiUB65MhNJqWOaJa0qIpXuouqUvHYVovS86BiDjp
	 kkmGyJsLpZN/FjZ+88pcWMIHWomiqz+cotPEILty6LvMiMEQSSkMj+afYnYn0LZV1u
	 yMMY50v3U71yA==
Content-Type: multipart/mixed; boundary="===============4380318559748323999=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <da7bb91d95914febc9b2b981c0b8292022d6f6437ecb68ed2b717f0f4a3a04c2@mail.kernel.org>
In-Reply-To: <20261026215226.3713941-9-jthoughton@google.com>
References: <20261026215226.3713941-9-jthoughton@google.com>
Subject: Re: [RFC PATCH 08/10] uaccess: Refuse and warn on __copy_from_user_inatomic() without an mm
From: bot+bpf-ci@kernel.org
To: jthoughton@google.com,akpm@linux-foundation.org,viro@zeniv.linux.org.uk
Cc: tglx@kernel.org,peterz@infradead.org,kees@kernel.org,arnd@arndb.de,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,seanjc@google.com,pbonzini@redhat.com,jmattson@google.com,axboe@kernel.dk,asml.silence@gmail.com,James.Bottomley@HansenPartnership.com,mkp@kernel.org,dsterba@suse.com,mason@kernel.org,ast@kernel.org,daniel@iogearbox.net,john.fastabend@gmail.com,jpoimboe@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,mingo@redhat.com,acme@kernel.org,namhyung@kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,kvm@vger.kernel.org,io-uring@vger.kernel.org,linux-scsi@vger.kernel.org,linux-btrfs@vger.kernel.org,bpf@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-perf-users@vger.kernel.org,linux-kernel@vger.kernel.org,jthoughton@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason
 @kernel.
 org,ihor.solodrai@linux.dev
Date: Mon, 26 Oct 2026 22:30:47 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C45D11C0004
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kben75r5whhh5oyryrb4xzjbzaeexaet
X-HE-Tag: 1793053848-839943
X-HE-Meta: U2FsdGVkX1/hCFT9dOZ+1oJgjF8/pZiZ5B7iMiC4yxq3hl+pLkU2NqkPMqcqtE8am+AQIabv+F2wISiOhfUgEWILudDCoYHwqaqhIxcuDeStTkaKBj7GHPgNMU4gxSvgfF65SneLoM7EGA7gD4Gpg26EjmC3s5ljwzO3XE6jY8XwF2zfk5LAC9fx6leSrfk4kiL8+1xDpwATBhH8+HZ129oZde8ydV/rTszXIhhm+FtjGQcWxcWKNt+i3ka7T2OX3r5iDH29ezfL6Wrcs+ZU3VElv2kWxuZY4a8bH0dIKFOLQEERQPpN/5bmcrWOVE7/73eiU7tAG6n/LgHO1+y/DX/I9gMPc4SuFAMSm+MKBXSgVngwc76Lm72ErnY001hk/Lq6tnnG1KhCtL6UghrXGcXVwWMK8an0DzOlNvnKkSrzRCy5j4WtujJ1RqCvh/Fy0D8tamniZ3cc4Yu4JcBZT3397eu7jIBvtnkFvAwphom44uGbFjHMZWIaYD+XqaPJ/jZEHUohw3un6NHYxIqpQlX/5DQA+WpMNpvAm6x/gcEIM7DeU6fp+3GIeZDffVElzAdBIkPaay/KZFh/zIAuUWVthnoPYX3d90RsoHzrmtK2tEE/JnAYOt3aF4KaWQItAnvIAQqAlkInI4WqxN0Myha0zEUBzSfKk/ojZfsv5bKQmiA0k9MN/GGfJK9IEGaR0slpQURsBViyvbaX/WZ4CwMwwKdwYKWL9VJCnjY1R62eOyGJcGTvjPNDuTuq4EfK5kBvIJZssIUKHUzjf96y1/aruNYohmEFziUR9ctog1o+fMHsJUs32sYpRd/IFJH3JZFdJnSMbDR9x4KC2oPhhN5ilCTfxG1d8IPKDK5MFzz4gQ8rylK7wzCLQdg9LHv1z6xUCgGwzGGSig0GeerpUDkHJxJnEQR6c8fTm9p3LHAcnSGJ74EsITwMVMiRf7ASIe/27XGlvYn0Czg++X6
 YUamuyxZ
 e8UqMsCUp+8yerwcJw6HXX9nAlQIhXENoac0PId4XyS3Ke6cfgmoyQacQwMff+PZtyGOUcL5o3iPlHpju7XzD3N0kkwR1UZajD2L+nvtADGj7boTnZXMyXWeGjGd2gaLgxbLL6PrMQkF9cL7TvNDQKvobdtwpSxm/JN17gzbVlAIcReCxrTmvXxJRZN/dKdV8ltaUNTbxiNx51vfniJBluA4Y1GUvm42NGOshcYjEx12uCxA8b5Os1fd0oei8GkNW+5kz/gpwdIvYlp+YTTJNcnvJTVb61bpEPgy0jKXhnPIUlJOe5rUtJtdqJfyVMiLjEQMCYIpWP8lx7UuiJGlQ/AQ++wAB4k95sskAEP5rYDu2NvnoImN/0nUCAktVczpbhSWwJSYMg1LNEWWNc2Sx6mH2qIhuNek+uBx1g9/EbPEKvdZtDt7SvGy1aQBvSdpYC9tT60yIITFKWYzPBneGTuyLfY+1QxfwYahnk9wnX7e5nJO1sMeWqx2v3FrLeMHUTKyQ8PFH/AlfJCifxGzOujtKJBNQvf4IO+hiTYdFjY44wdLaOSYGH/XoxaXO+8jpxhnC6Hf7YTT/dw32iZzVCXYJEC/7iNddKaXF+TJg3mG3uN9gC/jl8iQT+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============4380318559748323999==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> uaccess: Refuse and warn on __copy_from_user_inatomic() without an mm

TL;DR: Commit message only: it names kvm_read_guest_atomic(), which no longer
exists in this tree; the review suggests kvm_vcpu_read_guest_atomic() instead.

>     uaccess: Refuse and warn on __copy_from_user_inatomic() without an mm
>
>     __copy_from_user_inatomic() never called should_fail_usercopy(), so the
>     NULL current->mm check added to uaccess_should_fail() does not cover it.
>     It is used e.g. by KVM's kvm_read_guest_atomic(), by several
>     architectures' perf callchain and stack trace code, and by the generic
>     copy_from_user_inatomic_nontemporal().
>
>     Split the NULL mm check out of uaccess_should_fail() into
>     uaccess_without_mm(), and use it in __copy_from_user_inatomic() to warn
>     and refuse the copy.
>
>     Don't use uaccess_should_fail() there, as that would also start injecting
>     failures into __copy_from_user_inatomic(), which some callers don't
>     expect to fail in practice, e.g. __wp_page_copy_user() warns if the copy
>     fails twice.
>
>     copy_from_user_nofault() already fails quietly when current->mm is NULL,
>     and the generic user stack unwinding entry points (perf_callchain(),
>     get_perf_callchain() and stack_trace_save_user()) only unwind the user
>     stack of a user task with an mm, so neither is affected.
>
>     Signed-off-by: James Houghton <jthoughton@google.com>

The changelog names kvm_read_guest_atomic() as a user of
__copy_from_user_inatomic(), but that function no longer exists in this tree.
It was removed by commit ef82eddc0e31 ("KVM: Remove kvm_read_guest_atomic()").

The KVM user is now kvm_vcpu_read_guest_atomic() in virt/kvm/kvm_main.c,
which calls the static __kvm_read_guest_atomic():

    static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
                                       void *data, int offset, unsigned long len)
    {
        ...
        pagefault_disable();
        r = __copy_from_user_inatomic(data, (void __user *)addr + offset, len);
        pagefault_enable();

A grep for kvm_read_guest_atomic only finds __kvm_read_guest_atomic() and
kvm_vcpu_read_guest_atomic().

Could the changelog say kvm_vcpu_read_guest_atomic() instead?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40410166379
--===============4380318559748323999==--

