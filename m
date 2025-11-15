Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98963CEACF9
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 00:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF63A8E0023; Fri, 14 Nov 2025 19:53:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5CB8E0005; Fri, 14 Nov 2025 19:53:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6DC78E0023; Fri, 14 Nov 2025 19:53:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEE7A8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:53:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56164896F6
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:53:00 +0000 (UTC)
X-FDA: 84111016920.28.92F7E74
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 922EA10000B
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:52:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vhRRHgjH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 36c4XaQsKCDYSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=36c4XaQsKCDYSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763167978; a=rsa-sha256;
	cv=none;
	b=oLlcmzOrZlZiSgjkFKf7Nbu09mK3QfH7CaGdE+QwGzajRULuyqxprqyYo4UmoOsxEUulZx
	GTuzAEwH9YSINNKOSwPcxS4zmlJiACO5fvMCA9+z05Z24Rlx/0pKF/yaaDn9E9ovASgJW4
	27QNWFP4nMmYy2DA84+OmwAfmPzP7p0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vhRRHgjH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 36c4XaQsKCDYSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=36c4XaQsKCDYSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763167978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U9SSTkCfK9gXlKFXxpFitF3UmgPFfqReOkQFg2JXAv8=;
	b=7B4gRKtq40y2Ua9Yyy4thJcQ6lTt9BN+josOQ5w64hBhYEhzybIp5Ivqqe9elC4Sy9AO1P
	G74iGx+z8V4RcqWhOxShEvVlE+S69P2Zfa897Lpk2TsNcoyhPW8kVUZXx08sb92aeLbCZO
	YT5yRaakfClWigPtF72I1OQstvca0/s=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343e17d7ed5so2773267a91.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763167977; x=1763772777; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U9SSTkCfK9gXlKFXxpFitF3UmgPFfqReOkQFg2JXAv8=;
        b=vhRRHgjHxXA+e6noVWq3a6Mz73iczR66SM0VHSI3bRbVln4iZZxIHDRGzJr4Fwmg/E
         /76LWCQdcMgOP4qw3RnPaTe6u2mOhfS49elZyt4O0gVsbZR6BML74O7aoQtEEwT9Yhvs
         dZR4GUHspOFBejDxdX4OheKCNkc/TQRst4uWRo8yPASKY1ym0Uz/m20xijAxm/m5dM0a
         uChNpnPB/ELzUgfgf7dZGRTlvmNZsehikhosAbiC49jlk41tXhhDP/ytqqFIUhff6dQo
         MfOkHbH9JdPuVrhAPHhWq1pH9/GIUa+RlLESn/YY03Udd7e5nmhDOY2/swYhj4HFxb7C
         6Ovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763167977; x=1763772777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U9SSTkCfK9gXlKFXxpFitF3UmgPFfqReOkQFg2JXAv8=;
        b=JLuooy4plVDwwOS1Uv/C1jLBiRq4yTn5V9MTp7g3vConwrtmU4h9bbs/trIrGWbKoc
         7C6+vPHTxj564Uky1Ao7oDInp15GK+j9X3acB/EaEdIKrBqf0nZZqQtDBCYfyravS1dU
         8DZRjJwCxxVTWkLVOAH48dnqXbMGacYsK/fMncZPxKoBMBJyE87jAngJhLJJseMBcbyR
         utdW7puS+o90g5ULhfHsOrYX390/w2Un42mmZLbNqhrlbEdeSzG9tNCHdD7+5htMFTns
         sBUlWrC8JMvHzBVoiOhGRXtAU77n8NUa/9+tBXmz8ZUnf2ZpaQVjiQJmvRlAqPit+3wC
         yW0A==
X-Forwarded-Encrypted: i=1; AJvYcCXXLm1ggxMOmod5nK1ujEUqwujhTjocugsi4EwGQ4IAZDWQFgitZPitzobsXwsIdMpKtu6SG4jmJw==@kvack.org
X-Gm-Message-State: AOJu0YyqbRP+xi3kRWxJftpnoBgqcebQI0SU/PByMZv+EnqDHnIxAHlP
	qm9sg5c7L0ZnOFJdr2FAdAfKsZjfjAj5Ev9EQszsZdbXTdiWeBrWnpN2xPn4YcFsQ2F2UIfPLWS
	hgDwr+f1pJ1xJWmJQuqRUlaaEdQ==
X-Google-Smtp-Source: AGHT+IFQ6ztt0EQFHe4KI+3WuxtLaazXI8OcEuS0OZM8dxl+4bnHUaopiO2H4ku8y1VZu9JaoG1ZZurdE58bMYL0dA==
X-Received: from pjbpm10.prod.google.com ([2002:a17:90b:3c4a:b0:340:a9b3:320c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c89:b0:339:cece:a99 with SMTP id 98e67ed59e1d1-343f9eb3128mr5188244a91.13.1763167977228;
 Fri, 14 Nov 2025 16:52:57 -0800 (PST)
Date: Fri, 14 Nov 2025 16:52:55 -0800
In-Reply-To: <aRG35j3OhMvQo85n@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <a3795f7fb4f785ced19abe18c2f33aa478c4d202.1760731772.git.ackerleytng@google.com>
 <aRG35j3OhMvQo85n@yzhao56-desk.sh.intel.com>
Message-ID: <diqzzf8oazh4.fsf@google.com>
Subject: Re: [RFC PATCH v1 06/37] KVM: guest_memfd: Update kvm_gmem_populate()
 to use gmem attributes
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maobibo@loongson.cn, 
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org, 
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	peterx@redhat.com, pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, 
	qperret@google.com, richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shakeel.butt@linux.dev, shuah@kernel.org, 
	steven.price@arm.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, will@kernel.org, 
	willy@infradead.org, wyihan@google.com, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 922EA10000B
X-Rspamd-Server: rspam07
X-Stat-Signature: sqyuj4saybawm4p3qhpoia9i6tpy39fh
X-Rspam-User: 
X-HE-Tag: 1763167978-30093
X-HE-Meta: U2FsdGVkX1+N2FiiJTnvTaUK48AHF8630Wqlhnezrp09OvycwEQVz+tIJ++KQy00W2siWxKCg3zeTC+oGo9mYjxB7KFonRlwtCeXueMIFeOr79+K9j5mk/YnOuEul4GcSuNdD82j1k3wFLbv6ObcSCoHAycxqo/BBuDxdG0c8P+qL7YTqf8JZWeeNKpkk5k2JAQ8PKm/nxbUa7DY4HjH5Y7rlhui0BegjtoxOrJxqm0xTM/Q7CLTs3QwK+YYH2LPmrME3DJ9b52qLsd8FAsiT463JnmEy2xqPVa3+sgX9GWj11siFxSj+C5T4cS1G1lxIAUzBdGv1w6Db9la/AXeYHOBAp+dIqKngfa6cnGg1YGve8V3HuS9HIUM1y0BuGrvq05m8irJIHtxjPzI3XXNbPxaosilWAjb0QUFDmzhS758qlpmHF8PcwfWOq1OLaHk580WHtOKcJEsF5Z08/Va2Q4tBB+SEUyrMCIQdSyz9VXj1mm5U1xQo8HrYjzLfI+fZ6mlOX/D0XcssL44p8cjctl4DprKI/+bkZfOlKuqC1BO10Y6/IF+8uph5oI7ofF9+xqYlcDEAxPMUKL7Qb2MGbkfJmzVhggOW6Nw7XjIqvwoRc1CzVovlA2fz+ZKcART3kHft3nX6hwaRSqYrNzlTyAUukNxKaax8qO8r6WVuheNff7xyoXZkYok0cY7upi+aRye6E+V64KPjZgGBpUD6MnhyN+y5G0BAikLlD3IME/R73N8SURe/qWdrIOpHigYjdpa8OUoA+lg4eOwQkhQx3GK7CXodQInNXLAs+uwnjSfbIMZWeDX1AKf9cGC7pBXhKcfA+wBHLkaIuS3rc5KlxqxovIn3feVbKwnG29/7jZsrWq9EAbdOMg+XNvu1/spVByLqM1c9GLou4HOCK5ehuFrIeNFw2KbzF6FSWmvo80PlfolOeV22/IERnx/tiWGWTu+VzQhOfrorhWwrqx
 3kHxWIJ+
 ZqkDzs3H/LF4ld8AuHsT1nwS8KDl/dj/v5kZp6iyMONir3vwISN9aTe1+fHse2pbEyNd+DZVcdW+GFtuOhvhpjGZ7XVkdsKSUtKDrnt5/fF6B4tn6/At2iBfxlbllGNwSmzzP6eUPWWXJ2+0MyTAfEFjzSY9+h8ZDv9ImK/qpm1PD2sJxPH26pM3dFADTfB5IzsslmhT9H20nLItpTPTN2jlgl5iEkSCsRvfmnoLWMZJIsDLFS7TIMA5MrXgXSmRS18bkiCBBsjk9jqfoTCE2tiyDIx2cyujDLIBWZdj0Jm0VVwC6hEjD/DcWg6+noq1X6GjjImWaAm+bAPVWDwJoenVgrUAYuYlROgJoSF51K4VbVVyuW43lweXNAYP/nGT8UiyK3XVZn9OfRwJFwTlqOr+fabLshP9DvAOBCyHWzXwU1NkCCfK0sAs1jgn9FVw1/qMmNmkBKNsXsWlUS/ZRM1G7OcQNIJ1hRf6lYYwA91usKZ6iaQsWxHLjYqY1b8yFOd2+soRgqWgT4CyQs11+Xwg/QGA52ul7SHftIOrS12TvA847YZpEfLKXPvfSqc2F3ugwZQ8vGGn8EJR/uAeA/OHxGcEyybEG1RCT4UYsQLI99MMxx4OOx+sBKZpNma6uG2ZFw09XiFn19pFKfAMrr8M7ItWfG4NmGuTq283L3UigbPZeH7N+YZd7QhOM7m5lVHNasH99V4xEQKdKJvkcrHOvbHbazLCu6NkEmS8MaaNTEsNlkcHEC11b1Ui2iw6VJOTKRd893O+qp0MUEthMygF8FpD6N5FU0Vzj4XJeOWfsHWBrPd74y9vcwiVvE/4xjCqJmt/92G+PtvUJhryoG0BzCOcGWNcOi3mnCHp0N5kBnK/7nPqqnvjXlXHESANa6UQa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

>>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>> +static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
>> +				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
>> +{
>> +	pgoff_t end = index + nr_pages - 1;
>> +	void *entry;
>> +
>> +	if (vm_memory_attributes)
>> +		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
>> +						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
>> +						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
> Can't compile kvm_range_has_vm_memory_attributes() if
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set.

Thanks! I will fix this in the next revision.


We've been discussing HugeTLB support in the guest_memfd upstream calls
and I'd like to add a quick follow up here, with code, for anyone who
might be interested. Here's a WIP tree:

https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring

This tree was based off kvm-next (as of 2025-10-08), and includes

+ Mmap fixes from Sean
+ NUMA mempolicy support from Shivank Garg (AMD)
+ Some cleanup patches from Sean
+ Conversion series [1] with some cleanups (Thanks for the comments and
  reviews on this series! Haven't had time to figure out all of it,
  addressed some first)
+ st_blocks fix for guest_memfd, which was discussed at the guest_memfd
  upstream call: slides [2]
+ HugeTLB support without conversion: this stage does not yet take into
  account comments from the upstream call. This stage provides support
  for HugeTLB to be used through guest_memfd for private memory. This
  has to be used with the KVM parameter vm_memory_attributes set to
  true. This stage can be used to test Yan's TDX huge page support by
  setting up guest_memfd with HugeTLB just for private memory, with
  shared memory being taken from elsewhere.
+ HugeTLB support with conversion and folio restructuring: this stage
  also does not take into account comments from the upstream call, so it
  still disables the INIT_SHARED flag, although HugeTLB can now be used
  with in-place conversion for both shared and private memory. This can
  be used to test Yan's TDX huge page support.

[1] https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/T/
[2] https://lpc.events/event/18/contributions/1764/attachments/1409/3715/2025-10-30%20guest_memfd%20upstream%20call_%20guest_memfd%20HugeTLB%20support%20overview.pdf

