Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA12CD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8741F6B008C; Thu, 21 May 2026 03:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84CAB6B0092; Thu, 21 May 2026 03:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761D76B0098; Thu, 21 May 2026 03:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 650E46B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:31:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0388CC1E69
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:31:19 +0000 (UTC)
X-FDA: 84790606320.07.B98AFBF
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1922D1C0009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:31:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vmcTDZg6;
	spf=pass (imf20.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779348678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1nov9/2BtMfIFSe84psXHPo953z02mFT+vkGOoJChBc=;
	b=w+KPybAX1ab1OE+DJ1XGpOZ1flZXUWmmy4euNU/B2LKHWIcr+L/1tAWXLoSpz0qwwGsluK
	OtdoJm6n2b6wfou/Jpj4V+F4RTm0fGEtEqwuEjGOag6okB7i1zbqhE7h0cAWaV9T1tKTK/
	WR5dCFvtBGXxsJhxuH8hND6QQ/i8C4c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779348678; a=rsa-sha256;
	cv=pass;
	b=n/WI1CRra+KXTpmTW58RE+ncqtYgWeIFueHBQdlQ2T3ES7xWl5cSvBH6wTKTcwAg5Ozy4P
	dD4B/Ee3KMyh2freao9ZCSHND4LR6vxYKqWpl/Kin4Bq78mE7t3qihnn9pMYWQ8H9/gygL
	/K8HSwgQNuJAejbITpus8rtb0Jjs+RU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vmcTDZg6;
	spf=pass (imf20.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50e61648f10so6861cf.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 00:31:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779348677; cv=none;
        d=google.com; s=arc-20240605;
        b=IQrADtVr9Dk8ljR9+7j3v3HhhB0ToUpFw12fvdTkWmN9Cc+ga+am+qzSDIyAs4Mudi
         93W8tjK2+sQdEGcDCXml3vHjQ/f3EvxWsW5bPFyz85xO7Bes2x1qnqyYcIcGmi685gW/
         KmO+vd9wLzORbKhzFBG1svS91pwf5WWWOs/M9TcoM5kQ8M1TXIRJq0w8HIwg4PVM2iNq
         pv3YqjifRlFKljIl12QJ6zipBOqmTvcpON36KVD/cEAKsfGErggpw9FR7rRcU5TeJIXP
         Z9hB5me27QQGG0klKjdgJbLXfjZVUhMUcN5NqAPvCBTpYaS17RO5PgfhcgNwHMufSNsa
         6mew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1nov9/2BtMfIFSe84psXHPo953z02mFT+vkGOoJChBc=;
        fh=BiKJTLLTAihzyCVQEeG4LdDpf8LBRUQH8Cy/nSktXEA=;
        b=EZ/zykGyNLQqhx3ivsDG/3Tcx1/xCUuqOk/RsJEQl9KDNDb+kMUSBDz7JbHn3jkdL4
         XPc77RkTE25xo+FX/nt2J/KALAS2JxGO+1zwjyJHz7Sa9MTfxmvHCi6XtlCxSP7QDACJ
         tLbKknt8jkdn+IBDt+B+qHgQNFEgKPpH9rJV0Mj1qxf08qu0y8iKL4bIsOI8RzDjPowQ
         ejAkEvO55jab6zKsF/mDsx6U0BD7+nYUsksv8r1A4suh0JeUchQIIG3wd/SQVy25YiOe
         l+KyVojvYFxJfbFPpPPDTszBrz48J8Y++P8vkm3iRne/OW+9nVYhvq6Hw4hMvXNOX4Dk
         7uTg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779348677; x=1779953477; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1nov9/2BtMfIFSe84psXHPo953z02mFT+vkGOoJChBc=;
        b=vmcTDZg60cqT7w4jkQ9CbniAqa6fg0UMMOZ6fIMcGquNucUk6x38NZ0VtL8UsC5Gx8
         AWltN3zAnxI2vIeXlQXqre7UGW/nWpMd88pF7+RFGBdAYMtFomi31J0zl2eAOCu1EfjA
         9XcCCO5jFcshYMQNvwWtMJfvBvoAFLE32GVmbpxvRI4FlRB+A+Re8+b3oseBnFUCzlvc
         YcJk1wXuJfnwnJTWJNyTQFCWisL0+sIH/dU9npnTfBcRGEHw86zdfRuD1wDP0R5NjYGL
         DhkIlrgt063Tn7dd2rhJyXjJkUfOpb8REzz7w1t8XfLVcTRrhju6MdzGW7WEyEwHI2w0
         I1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779348677; x=1779953477;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1nov9/2BtMfIFSe84psXHPo953z02mFT+vkGOoJChBc=;
        b=inLgAIj/sDvqXAU+CoUkwOejL+ZwM4jAmSlfgAfS4egJU69AOihzJNnPHq6tuLFakD
         ZjBrh45I+eBtwjVGys56JlYKRkTsNfG7biQxPuoWqCKxl0LM/67zQltSWezL46VTrr7Y
         SkIm/7cI5y67Kw62mffr5W1jZccwn25YcE9dsyv0+bomsxg4hwg4XmwPS03/ZAGdRgwn
         qP2lsDkYTWvwZdkMpSisZB+Wuai0yJrLcJvREFsMj2KAOz0zOyrFe+zf2CKrYlIeA6A5
         j5ocGmJFU6UdRUgFuNHxJDU8mTm0GpT7JTtI1mLVY/w5jrDaBPul+vKxqEtvtcPYYTRK
         blPg==
X-Forwarded-Encrypted: i=1; AFNElJ8ykHCYPjUbiI+8QDTqKaUVtft+g8Llxv1XB4CLXDrJ2YWtRwoVxbxkNHntrDIyefK7xyMwY+u2nQ==@kvack.org
X-Gm-Message-State: AOJu0YxvfUZs/B2HjIUOgtHJrRb0gheCMdRcL45gZjdr/w/pjJ+GHUUC
	3zyW7FU6HSbDFm0HcwWt9uBXfVnFdoD/heTGfUyr9CiHKxq62f3HwYZvAWQp3msfRTAe/56ILlK
	irCcPoQSX9Y77pToj6M+XcnI6r8J0P+DL7FcyIiMd
X-Gm-Gg: Acq92OG7sCUbK7UOZMafY+scvs+CsOx9bz/TkYyfobsXdix9hV0fMz5c/RVvziFRK9G
	2CwW7rICxMBdsLP/4qhNfd3Z7m5HqU1oRAa79avI4IT0zGri92TwXbTeFF8yq81h9z2Fla+HkgC
	bw4OfqVa83uOc5TTE8ft704zQLOW1nE421szdr+s09FigEHQAhuYMNkiYfbL8oqYjYDuXUFFGtd
	zMj2oeier0oGfOpalTm3jfE7EJm7D8dBb8MtQJLiWB8s9aLnGhtveaqG73f2FuVvYfxhs5pror1
	1cEXIrQYgy+37/X2q/8=
X-Received: by 2002:a05:622a:9005:b0:516:4f62:85e6 with SMTP id
 d75a77b69052e-516c54d8a37mr5382941cf.17.1779348676536; Thu, 21 May 2026
 00:31:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-16-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-16-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 08:30:39 +0100
X-Gm-Features: AVHnY4JV7zINIc5-OFXxSXoQ_2kIaSiAQNVZEIUteRP4GKUxLGDjyOPiw4qGQa8
Message-ID: <CA+EHjTxcadguOfOo7RpJVtAzcY5JAFZTbrAT_wcN6akMi8gCUg@mail.gmail.com>
Subject: Re: [PATCH v6 16/43] KVM: guest_memfd: Use actual size for
 invalidation in kvm_gmem_release()
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1922D1C0009
X-Rspam-User: 
X-Stat-Signature: ib7akkp3wb55pqcy5skdc8758xiab59m
X-HE-Tag: 1779348677-285098
X-HE-Meta: U2FsdGVkX1+pdgZUg9DHtQOheapaNAOW3KERolpxcQ4bC7ShHut1RuG5WaxVmzlazzoXHAOX/7+UFBRK6YiIualFh8gkTudViEmPBEzgLIcu5ECrnDZBrCOVyvlG72ZpKWFIQIezgUJPlXTm7JzSv95EO0jjr7oKEo2zVN775JfvLvKQQxU/w0GmJILvGMaI4cHL4OchrsO4fH49I7ORjpzModQl0vp9ZW2geLUD3FOfquae299jO+/yyBKwIn1gMABi1lBsApxe+tsCPBPJ21TnkB0FTqnP1gs3/+DapcquxYWZWv9la4WfZQf4JaGL61t2fIM6aOqcs1DQeRwDsv9uyuBQTvQkUOype1WaNTgv7/i+QjDuB/59dY3ub1+9nRdylkMVIpB0sIQ9fHZ+n1Vgi90OueLtIFxmiJS16vGdoEx/i73kHjLTAA8vZXUnGKyvP2w5dEF7Qcl/c29yyCNKQo4k8In3SDiIqRGFHL+vrJ90RbDrBvbFEhYTSwElJdeaaahWcroh4H4RBlq74EdrWM5jh68wp2FLQvHHgY2OOYNoO1BNDlraiOU93uE8u2cU0cqe+/FvW75gonc5hGnTSqQYHli1nQGh9UjQb9xzviWTSdXmMTLCPX468/BKJzlK2VLTdYPaqX5uEN2LpGQwhXk4mxMhSYHYu8GoKj2s93jqHtkSI8EzEA6JasyQ/r425YJUU2dO5je+4QDKyhbXbxbTg9nv4g0C+P4jJSZW9q6k6WtJzn6fpzdWScugyArWGxe73IYwjqJeXGwUhLvTTrhLox21a2NViHkDWxEQozOx+DVaKJfeFGwD3WrOcybTskzuwaxzeGA0JrUJfOPWFhtgvJ6RlW+mLkv+ekOz+GctbVn9RktJSPpnIwHSp+VZlAyDzRZZd+MkJAkTFHtg+biUcnGJ80z8Os880PXifxPocsPpATohzhB/Q7w2Ps0b1VouBjLwC6dBwM4
 LkGhlREL
 Fu8y4jpkulZQ+1kpuA14pUAjew40qLUnYpyNJLATo8NLbqwpTwnSMXUIYBQ1qS9WVxhM694UFmUVEW2L4UENNmxYCpf4Epn7PxiE2wDsQAqYtozR1ExvTso1T75tfZYu/B/ruyHelVGN0ReUBMRS7fehL2cr0NC7zYLsTbYSGZbExkBFg5JChAnQjx/vOIy8xr4qGsT1kf66nOxiKTXqTpuKKW20mkl+jfBi3QbO/PlWHwujh6l7tz9drcdLusgluo81a0+QS6FLa5kwv2wl3AIkOGN62ZrgYdB77VTmZ6xUIayNIkqm9s5yZXB0n5ZNuWZKiTWQwgJGeP+ym5AaGvx/Ms0Qxn/LVXboheh/3i/E2lUbLjZoJXQzRxLhHNKYQ24ojhjoNubQ1R+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ackerley,

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> __kvm_gmem_invalidate_begin() and __kvm_gmem_invalidate_end() actually do
> not specially handle -1ul. -1ul is used as a huge number, which legal
> indices do not exceed, and hence the invalidation works as expected.
>
> Since a later patch is going to make use of the exact range, calculate the
> size of the guest_memfd inode and use it as the end range for invalidating
> SPTEs.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Want to look at what Sashiko has to say? Seems to be a real issue:

https://sashiko.dev/#/patchset/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4%40google.com?part=16

If I understand correctly, the fix should simple: use
check_add_overflow() to validate the offset and size parameters in
kvm_gmem_bind()

   int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
             unsigned int fd, loff_t offset)
   {
       loff_t size = slot->npages << PAGE_SHIFT;
   +    loff_t end;
       unsigned long start, end_index;
       struct gmem_file *f;
...
   -    if (offset < 0 || !PAGE_ALIGNED(offset) ||
   -        offset + size > i_size_read(inode))
   +    if (offset < 0 || !PAGE_ALIGNED(offset) ||
   +        check_add_overflow(offset, size, &end) ||
   +        end > i_size_read(inode))
           goto err;

What do you think?

/fuad

> ---
>  virt/kvm/guest_memfd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 050a8c092b1a3..9f6eebfb68f6b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -370,6 +370,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>         struct kvm_memory_slot *slot;
>         struct kvm *kvm = f->kvm;
>         unsigned long index;
> +       pgoff_t end;
>
>         /*
>          * Prevent concurrent attempts to *unbind* a memslot.  This is the last
> @@ -396,9 +397,10 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>          * Zap all SPTEs pointed at by this file.  Do not free the backing
>          * memory, as its lifetime is associated with the inode, not the file.
>          */
> -       __kvm_gmem_invalidate_begin(f, 0, -1ul,
> +       end = i_size_read(inode) >> PAGE_SHIFT;
> +       __kvm_gmem_invalidate_begin(f, 0, end,
>                                     kvm_gmem_get_invalidate_filter(inode));
> -       __kvm_gmem_invalidate_end(f, 0, -1ul);
> +       __kvm_gmem_invalidate_end(f, 0, end);
>
>         list_del(&f->entry);
>
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

