Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F607CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6A76B00B6; Thu, 21 May 2026 10:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9981E6B00B7; Thu, 21 May 2026 10:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886AB6B00B8; Thu, 21 May 2026 10:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76FD26B00B6
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:40:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 321988DCBE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:40:15 +0000 (UTC)
X-FDA: 84791687190.02.037ECDF
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 37001140016
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:40:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aXAtwDct;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pETZ8fM2HZBGp3r6phdANPEwcKJJ9mevi9pfUImaGvM=;
	b=16rK7nFK7XATzSa89Zze7TbHYxqhq06K+18v+eHzdJeyfZtpQpQcdePiBuxIaNncGWgSA7
	k5YFdnNOzbVM/Cq8hdKSQWD5+lszskWU1swlkYya6YwR0oHE+748KJASRgqJCqW/47V767
	kQr9mBOiviYsQBwDA/vDoDdytBV6E+Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779374413; a=rsa-sha256;
	cv=pass;
	b=vGjHLh9vp0G/jZELJ8TKps6O13X6x81lT4u1kEWyD/vNp6z3+CabeGaESQRUvXVExX3tIc
	1aHXwRVvEQTC+tdAJ7Ip4e8Xr55C65osQ6baYSvhNwyDxf4kOiO2HLkIgisChe7ClnereC
	NLOAVB4cMEQ/ZP8CHNbaKR2CVMu1dns=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aXAtwDct;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-6312bdd281eso5529989137.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 07:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779374412; cv=none;
        d=google.com; s=arc-20240605;
        b=VJGy4grNMo2vapurL2zmvkvjMjDFhVJEovFpVs2EOxrtYNcPWhTyAdIIGi54+rhxOH
         BFchZSUDIVHsHzO41cpjnJpO8ntIGQDkOnr8g86dp1QC2qG7Az+e8U7iYWkEls0sQtNq
         KJ+QiiUiS5cXtQmhZTaukuqjduqyON0gi640/tE/f5BggGRXhckApDsO0HvY88JHivFN
         +okpm35Zan0IebCqJY9gOg7nlY3JXJpOzLivUoBKXl/YH3JBnuoTChbZ+nsUska+uUH/
         GhpuDoHuRl/RlncOYy1AsHBEyaJFeYevTdXYUcXEtVuo3w6on72/D/MJw14BlSdeSWXT
         T/Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=pETZ8fM2HZBGp3r6phdANPEwcKJJ9mevi9pfUImaGvM=;
        fh=wRbZrgpk1SlWNaDb2xNuoDuw5T6A70WfhOxFroy6A+Q=;
        b=IEbavk4UZ3nIwFZbfVxyNhnZ0cDg5GwtInK5vYGYAiaorUC9aYHSs48bK1T/SzWzyJ
         vv+/884gOHaDvwXJ6kIPH9CGEr0uqu1RMt9VsojLWaZ0y8IsYNx247XFykMo4jOQwmlb
         ps7keBxHJmPqaRSboAblNYqgHt8D78+7qOZh76O8Q6+6eHFiJsgEUlSPtCNT1A/Z3jXy
         IjEFKsmQqveusf8bTAM4JPoYD0gPcobW09riQHxfMXbNb4SkEPjofCTSepbvj3MqRSFC
         6/RQwFsrwQzXUBmVs0WVzoeSxL/Nb88E8n+1zdsyv3OBBet6i94N4ofUivxQKC7QJtN6
         sL6w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779374412; x=1779979212; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=pETZ8fM2HZBGp3r6phdANPEwcKJJ9mevi9pfUImaGvM=;
        b=aXAtwDctOEhm+zfCfjBr0aDkrnW5Wu2nuBTGswH/Ua2IRkQvVpvcaAsie60qJgK9Ci
         0RqQnRWtjrl2dAARvSkYOXzW2BMCiYpASXRaklHdD0hRjv25JOyMiwDJEWQj6ifVvZtp
         6wVjkbGExwufjlNgA7T8z/vqRoAmipuHduptY2UQuftyAC1LW4JDQONFF89O7KuNBl+p
         MzS7SI3zvPQ+XxvMqJiAilHOK4WTKleQtk1JX+JuKryfNXLO+tJpt6PWTWxX1yubRo0Z
         UWVsOMI9DdEwa7pUcGp4qxbBF5DpBicsCp7fPO9XPqZKhhQFOKwbh0/gS8Rq8nfc2al6
         zjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779374412; x=1779979212;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pETZ8fM2HZBGp3r6phdANPEwcKJJ9mevi9pfUImaGvM=;
        b=SphBWoBnvlZx2Q2zYXHbDVkT2iHHYjCXUmqRoplh0jXd8OIHox0wP0x/zY/1RzK1PU
         gl8WfSFS1u5LhKkmYFBh6ZemcQPZ3fpp81udBHrIo9oT7foOyYTtMx+R0ePOC4jZCrNi
         uXYTnkeXxkDGFmUfH4JKtChSIqEcThsVnjwLC7/R7PXNxpaWkPQwfx5lWrw/09XefW5j
         wMQ5FfINj84jWqG2MlVh93DZAqUSDAtaW+dENcTh9SQO6P/SLYslSH5/IKGaEa7jwR5S
         8d8DONfawCnImSMnPujl2yfiWW9uJXrRIJk1/0PLXSucmYcaKGw0ZJ5sOYWHChF/ifIr
         1HGA==
X-Forwarded-Encrypted: i=1; AFNElJ9sYLxavt3GP0zxfhnHMkLOWhKaQBZBfxmo1svTGN3KQqpNgGMCD0GWT4txnZZqgaX21JwCpbo1SA==@kvack.org
X-Gm-Message-State: AOJu0YwAkQXbeJY7kHSTFK6VRUol9VKEVSmPfCGiHfyoYcfSvPJ2fqGF
	zJSUpvY6yEfhtgOkjmUijlk+igHkHUavcoaY4X0EZBQySubJ00CrRYgo18Xp7jppkVvGVHyBbwW
	k/qYDsAt4aWC7p5MJ0vNM+FBnP8koQc6LaMRriREw
X-Gm-Gg: Acq92OFsk+3TQaC+ROsTakzyB3UjO7Mgi9NFBhyaFNnQSPG4gG6Lm1O59efqPFMCo19
	ZGoa5UX2ahr7yoizce/DVHZe2UhFINzI+eFsfIW0upm9N/KjkYrfLF6vyvnOPoNaEvLHeDbbH8b
	ieDDZC6slvvQgs5yI2MKHsGBswwE4KYqnMGd8TGhKPf0sMIjcOetNfbpyvaRIqd6Nn7v/8aU4Sb
	S4dnQ1FD4GD1WFl0P3nrFUZMLtvetC+1kXTDOMuqPLJ6wUYQg7vyJa3ykKHII9bEZUhgslFWEnS
	+1hw1XhYhEUuxUvi8Spo5ceDGzozFY6zIT7hFrCQ8NUNyfZpPQ==
X-Received: by 2002:a05:6102:52f:b0:634:248f:bc04 with SMTP id
 ada2fe7eead31-673cbd0ce21mr1147276137.10.1779374411627; Thu, 21 May 2026
 07:40:11 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 21 May 2026 07:40:10 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 21 May 2026 07:40:10 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ag8BmtzxTlcuA_zy@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-16-91ab5a8b19a4@google.com>
 <CA+EHjTxcadguOfOo7RpJVtAzcY5JAFZTbrAT_wcN6akMi8gCUg@mail.gmail.com> <ag8BmtzxTlcuA_zy@google.com>
MIME-Version: 1.0
Date: Thu, 21 May 2026 07:40:10 -0700
X-Gm-Features: AVHnY4KEEzPCaNbBUek3sDUc3FN_Enrlvw5CRgr6BoNKh9-pt1QUYC334HSuCXU
Message-ID: <CAEvNRgGDL=_XO3z=h2RLqb_gZFe9QtxwiMFJHCzQY3HEoaUfHg@mail.gmail.com>
Subject: Re: [PATCH v6 16/43] KVM: guest_memfd: Use actual size for
 invalidation in kvm_gmem_release()
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
X-Rspamd-Queue-Id: 37001140016
X-Rspam-User: 
X-Stat-Signature: pc8o3k3ijedia8zryqtadknbuqychkpe
X-HE-Tag: 1779374413-602992
X-HE-Meta: U2FsdGVkX19Tth0pZ6YskdWzWDOR4v6gTyHGsSkF2hMaB/CSsxDWwyVqYgWaeZGlpUQFNfHuBateH5AcZahOpY1GjJdDUmfqx889fXhYZ/EZ0GsCMOc0XRUpP1vt7K3LN84W1lglwhJdaRBWo/SSxjAtCIjeoR/tVSyV82jLHVXvz0YQe+f3+c6fv+1AUg06nJwLkklWXLvZfhgJBbht4OJcqJkgaT7KTcDZNfjNkMPA2i1NQorW8TQMEht7r/kVLA7LWtpxr3d8mFlQ8LWOe06Xq1pybeJMUTqJbifO2Cuw8P5x55X+zydTYiab8A4Akmptg+rbH9/ms6MbvD7l5VkhE+1JjXtane7FS2KwzcSuPPz6BTlJPcj16ayJwdYlHqiWkE2112p7LSeIqUuvH/ZcEWKAdmV/rYpNocD8rOKcrhwTE74tIgaNSh7vOfrDDEGemZqpQZxzUvQ3yGAZ7r9YRW1SXwZBYk9+cBjNumO3uR0CoL8bVGaKeDwi5Ff4Lnlqv0JtTREgARN9IHphlugG9Lb3LfApxiaxLGeNBSbwTitRb8GUMEd6ZiFOqP6giA6fW1FnmGPybd7L05w2YICCuCJj6/ESP447lAB9B7DuU7RatW+dOsi/fW3EmYo4lbv/0W2EzwUCtRyXLQeLRmeDIiSIxkf+lBzriZi7R1d4L9q1mtx13qavXEdKmyahnVi3tFOdrw2FlxhYxnVxMJM138WJZpsu0KO+8gG9jrOpJxJg0Aq9keNixCYeHZxHRtaD2CQf+4qgW0LgbWqAy4flIF+qyRySLb7oDE7YJXjrzY5xEs5gWbRwmmYBO6ktW2lIDuLhT4LvKZ0+1Rhc4+KzaV5cHW2bFY2Uk1cICXMfmyKg4F+rBG3eU9sME0bHmqXoCUAFB7T+5EjreX51DMdiNzBeOrfc6TxZs9ahk6a3SU1FrGS32hk1eNBF5JNZOTHvrqzc5JV1y6QdRNR
 FREkEslv
 CYDJU8b18+0zlX7y4ZHSvQAq6sSn8lOFikC5PAnLJP9PBb4L81WHsYzrTZZxAZ61wskSbA+kLhn2HV0TzbdbTSutH85QJUhsMme3EOWxGxrwoSrJtHETQ72tseDp1tR+bU7iQPn3Lv4CygyeVAjIYr8fq3u00eCVAb2kGThpIbXhXZIVIrLfGsmy8gFOmMv+zBLzLtJ0prrahXXNBF+WTTMtwJOP9cKdb6Q0xg7vb0QSLOywOT4SIKHkpeuGrf+gsaeNnKPlPl93BLpDcrpGVQOZDEHdBCAdJFqPF0I+LSWmwWa3qgd8fhnWvJT0BSFo/weqIGD6LwnegmxV92Pa9GgDm7H7X6nDb+7cZJaPa+z5WCLBBvwjjyizoGlfRF+TNF6FLGz4vZiNLE2kaSt5tTxXAnw4ojWMj9KVjD6EjvkUzqHaTkIQxyQpHOaQxU7Esr2tiGcoYi9K2kn0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

>
> [...snip...]
>
> --- virt/kvm/guest_memfd.c
> +++ virt/kvm/guest_memfd.c
> @@ -640,9 +640,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  }
>
>  int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> -                 unsigned int fd, loff_t offset)
> +                 unsigned int fd, u64 offset)
>  {
> -       loff_t size = slot->npages << PAGE_SHIFT;
> +       u64 size = slot->npages << PAGE_SHIFT;
>         unsigned long start, end;
>         struct gmem_file *f;
>         struct inode *inode;
>

My mental model was:

+ offsets => loff_t
+ indices => pgoff_t
+ sizes => size_t

But looks like loff_t is more suitable for places where return values
(possibly negative) matter.

Good to go with u64!

> [...snip...]
>

