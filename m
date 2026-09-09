Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF78C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55EB6B008A; Wed,  9 Sep 2026 10:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E067C6B0092; Wed,  9 Sep 2026 10:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF0D6B0093; Wed,  9 Sep 2026 10:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8D56B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:36:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E581D1602A8
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:36:24 +0000 (UTC)
X-FDA: 85194474288.24.5D1844F
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id E862BC0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:36:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E7PX4OLg;
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788964582;
	b=NLz52ZaDx3JqDa7uCE/RtZvKKc1DpcW1IEO9XeUiyIxFBHv7M7t347BtQVLUHzGfeFq9Kb
	a1vQ3uaq+nznaob2p3/v9Yoj3Xdgkg2dDXzj3vX53DY5PCJ3lFA49Wq1ji/b3LFpaQybkq
	UCrpFw5Q2K5OdIEZf/el92LgVBmYbKI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E7PX4OLg;
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788964582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOdNfCxlVFqMCNwG5WAXrbnbeG8MIfsFEPI5I8fCsWw=;
	b=azkc+OatljN3D4ryeTBfmHZUUAdvV4JrlCzQjcyeDtK8ptn3xfXfuFE1Lw4yNodVJK3DDE
	gZWQSWKgVCDZ/fq5QCERIHxTeJVBX1cFImPC7TtvAF8krnXoYHSHU28syoENugpaI6QO5J
	xFFr5VSAmty2KY9jVZrDPYdFk3TYnTo=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-9106ffe17e9so7257036d6.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 07:36:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788964582; cv=none;
        d=google.com; s=arc-20260327;
        b=p5jpQkyrAcMUyh04TSEX8eAbJSfxAC/g0J1Nizka1O13kvX22NvK5vjUxLgwgD9lIn
         ZxEvj60R5FXsCtKBsoQqzAdu7cGo8sv+jE29r3R8wCfmiFjFeJ1cIvWMBj1R00mzXQzY
         A/ayLRf3sHcNF6EhY41KYs3h84f7V+w+DQTw5stsXI+Jm5nNch1THg83TnDlMBLlbzDf
         UhOEiheKa4XKP+lw4HCnLbVlSVM+l5iCizioXbbp/vqvBQkG16LMgutxZeAirxPp9rgq
         jDAPnTuItUy2tNcM5qNBzd3GHxwkE5Xncg5vtV8t3/KZu2OI8/PxaJQnO87mXOiS18Si
         nX5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=WOdNfCxlVFqMCNwG5WAXrbnbeG8MIfsFEPI5I8fCsWw=;
        fh=d7N12b32zxtJXnzHRp84MuCFfh7nIi3XyyFewpz+ynE=;
        b=KbC++IbinG8cjzSUu3yM1ITRvg+2y2X8EC9lZ2XgcH+LIWIEHTiWuCAMrp0A0KDxlr
         GDllDnPbU7srWybICdvsn6aiwzWyT1hrM7MB/Jg79ZEOi6ye75IC8QaKrf3ajktlPYaO
         DomYnxow7fH8nCLrfYDbMlIGdLVd+ysMJDSrg3vE4ILKR3GFD16sMqKRHWbfLcFuId5Q
         AVglAD0CRxnAfrSK5IhhnY9C3Zgljpx6V8niCNRhPLr6x6zrIi892aJgQeVMDJjSBsfF
         MhTgs3fUmwIYgtcoXdQjVyPjDB9UTBaV7TErV1ldtboxhNLyBBuUJOfTXaPRhlIJInwq
         gBIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788964582; x=1789569382; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WOdNfCxlVFqMCNwG5WAXrbnbeG8MIfsFEPI5I8fCsWw=;
        b=E7PX4OLgp1YBK2spRUb+XX2rsU+jSgqiyq6jIc7UGegyrFRVmQCa3W6A7K2Q6TaC2A
         YFduVY28vYnspOHXTUGB4vlCwQ5E9dzhcA3CG7u+810IVw/ao/VGEvd3nRucGoomkfuU
         M76jXsJdfllpOcOhoGFFpKHsJS0TwmfglrXSyAeEpdqKcnOZCoiN5rskPuudz4YnYpNi
         s0gbV2cGx1X3j5c+DCvDq7ggIA1oWZyZogUYC7717ZJkOMN6EwgIRBuq2H0j5ZoN4cpq
         EexGXEzSZ7ywkJBZB/sHQvNqiZfgIogcTbXvzEkbu0gfMnl0MhyFjrNsH8cLvsPV8NJA
         jIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788964582; x=1789569382;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WOdNfCxlVFqMCNwG5WAXrbnbeG8MIfsFEPI5I8fCsWw=;
        b=Uh704KaS0JADZhFFD5Xq6eaq9t5yoHn1ARn1cMXzMCUKSGVjIScW2Oecr3UWbm5oj4
         xvQ1vyo4xv/UtW176nccusIyVBhqhh1BXQYGL+Nbo9ntcD8TS8cDggwlU6X6njvSplyi
         XMeEE2vOQvLnYAbmE/7bTbVZNzNNKSMgYVhDMyU4YyhSRzdN+rEf6RMsBwI5tIGBrThE
         6GdzwfAd3c/k4TNTl58EqNBhp31mS4RUoPNANVM/x33ys3faWqywkL9LT36nL9YA1Qj2
         KvW9kL2gts8TvyEPFDTxtfBN77EED4fzJRz726rxYkxCF0OM64WLtIdWuy8pOfPolM8A
         HeQw==
X-Forwarded-Encrypted: i=1; AKwUvBxIeVEGQUoBkKKzuBzpXIu7v6DsooaoSKwoUSSON5w6UefNJh/5CPQpX3y9moQAoduh1RkNoVHvIQ==@kvack.org
X-Gm-Message-State: AFuF++lf3PtpfdWVyflqZ/JE9HjHCACjCv+bM4p1LhyFuGehgUOIrsY3
	Jx5O0KvCuROkNe8c85qAb12C4viwKR/ii4Cr4GciGwWkXS8W8o6R8y+G0CDTPJvuijEuG02Pgyt
	J4kvMtrwbsnUMcwliniF0ALB4diWgQZ+RqmpN6Pu8
X-Gm-Gg: AYBFou2vuvXpFs8XySGVJ7sOOsFaYrgLlkFdYmUJ8LYbhidyxxWjNwVMFftjE5xT6Oz
	6vcm0t6H/TvaUouXKPDT2+yarkpMnrRMFcb6+l0zQSkqERKuABLyc6LerDtGZ3ZK9gw0jKy6hP/
	I7BbozElkqFELg3Sfpmp6DpsX3EuZmQBW/97EwX03N9rGuKgfdccXeVp/dWqppcOcIKmatDXD/B
	LOHi7DiQLha2tYz8LCt9DKd/gHZ5jzrV/nxk5PK9ArpgqeMjiptXYWAkbQ68jH3Sq+oK6IB81Lh
	en5OMquxccVZcnlxm+dOJyyXdrYT7CL+CTdmx/HDuuXkSZdpIRIDTpK5TApOGqZ0vj5YYZOxRme
	yUmxze6kZVjs=
X-Received: by 2002:a05:6214:2f8c:b0:910:3451:341 with SMTP id
 6a1803df08f44-9103efb48afmr490270826d6.32.1788964580576; Wed, 09 Sep 2026
 07:36:20 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 07:36:19 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 07:36:19 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <apetw3aqXSawLBt0@yzhao56-desk.sh.intel.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-12-85e5fd25252a@google.com> <apetw3aqXSawLBt0@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Date: Wed, 9 Sep 2026 07:36:19 -0700
X-Gm-Features: AcwNN1VdQII_SBwvozqnLJxonm84Qmsr9AHJ5M73oMtr5q_ETKWllQrAhks6iFI
Message-ID: <CAEvNRgEmO-R35susJd+U+k-nB_yFE_gfh+ACrnaOR=ECJdWGuA@mail.gmail.com>
Subject: Re: [PATCH v12 12/45] KVM: guest_memfd: Always fault from guest_memfd
 if in-place conversion is enabled
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E862BC0007
X-Rspam-User: 
X-Stat-Signature: j35o65rfw3b1petkuj17xaa67n3tztf8
X-HE-Tag: 1788964582-869651
X-HE-Meta: U2FsdGVkX19sMOuoOaJqhAT5dF5BdI977/P3C1tJEcL/zdSeVxFB9UAbYhUrKCldS3qrosUDZPoSJBfHrNU9kXTZ+/cRFecjJqJTc4Mh3qYU7ppAp0R5s4qkRwxnh2pSluTlrjy5UJ7flX0C4ThXW7SU/3Indgd3oyP+F4hvTMwyRA3m4Sc9pDwtTGyU10K/IXyr/KVbTRByVgN+58CGH0KkhBs58r5HCI6U8QmbizOMO3LTUTr73VeYup+qniwcDZb36msWwLU6xGXK10CHvshuJprlKNv9dyQ7bQNbZVjmXTCLD7FW0T5nXbdUmuG67FWTTY54JWcabgzkYmzqx4AMTCZoDE8MtBnKCOJhGyEkT4IakO8O8dVz1SMBPuEfIUSUNNQKVFi3wCL4/mKkAYRhDFR8rH3Gf5HAju6VigjZObwtqdpob3sF8Mk4YAm75MQ1rjeIzc/J5RlBswLhcfUun9xh6SpSvBakhWjmWmgyQ74BDYVJVpP1J/uJfoJHM5aHMkA2cRFnTijbQImk5qewFzYXSP729bStukzp70xsHWYB2Q9pCltBMIryqBiwInKiKqjggI3+RefypUYuOS0ukVAcrq36wqUNYa+g2TvY3Fsz/sZ0Jfjs/N57aVAoNuZTgfsMzTmIPdK0z0LHfY7f1sjxxT/45weG52TCmZIyIImEdSlwRY8X3DR8YBTRb0VdCiAsNpuaCwdxUf5V2fcnURw2VZCmW7GGSIEJ8lwJHFd65m9FHlGKbQedZIr7jdAjaQTA8RnsBXrE27/OU64NXvAH7bQZmN22rfGu+QA0qFNTtz4IXdHDkPKYqRG6djlpV+/LKZgcDUvqIkOZNvjChtHY91kecvDqZHWZRCsFRlNanYgCla2y9O0nhek3v491qKQ6m8SZkhNkQIzPOoN4MGhh7mpJAWtNP3BDfv11AuqDjjoxw20vpxdhlojD0zHIFN5oA3rBhIzM7V2
 QAlzuZOO
 oYkVBjNsgCALcXP86gBM0vWDJo/J+pFfLZnJhHCH2kB8joWOx3nRoFsOvnG64QZyCOcn6H+VK2IuY3OAskC/2KeWx5zuwlW5L6ZsgLWWF3TxO6gep6VBnKTbfHoZjJvkplmhGTD49zGT7RvRNmnadgzH4GY0oBOp668DW3GBPWh1EVBTP/iTU5P5TYxYF7JxSN1KTpKPCtgiSzskoOUDlTLyTjHm+UEIHPjBTHE/OPALqpE1lPFzFqnuNaIhE8cdSwRcU6723McJhusdh7XL5M3vkMcE9W7XsEBdE/yMq0oNalxkkXbiY0G3F4ybSrvc9nDk0CgRccuFvk9RfI/CehqZrML7++Wwt3WDm8Z5XPa0ghAU45nWoihsd8SLYRcZRKkszGVGupzG11ts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Sun, Aug 30, 2026 at 05:25:13PM -0700, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> If a guest_memfd memslot is created but the guest_memfd does not have the
>> GUEST_MEMFD_FLAG_MMAP set, KVM still fulfils guest faults by looking up the
>> memslot's userspace_addr.
>>
>> Set KVM_MEMSLOT_GMEM_ONLY if in-place conversion is enabled so that the
>> guest_memfd's memory will be used for both shared and private memory. With
>> in-place conversion, guest_memfd will be the only backing memory for the
>> memslot.
>>
>> No validation is performed to require userspace_addr to be a mapping from
>> the associated guest_memfd because even after validation, userspace is free
>> to remap something else at the provided userspace_addr.
>>
>> userspace_addr will still be used by functions like kvm_read_guest(), and
>> if userspace_addr does not match up with the corresponding memory in the
>> memslot's guest_memfd (whether userspace_addr points to the wrong offset or
>> some non-guest_memfd memory, etc), that is a user error.
>>
>> Requiring both shared and private memory to come from the only associated
>> guest_memfd simplifies invalidation in stage 2 page tables. On a PUNCH_HOLE
>> operation on a guest_memfd, the invalidation is now guaranteed to be
>> invalidating only memory mapped from the given guest_memfd.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  Documentation/virt/kvm/api.rst | 22 ++++++++++++++--------
>>  virt/kvm/guest_memfd.c         |  2 +-
>>  2 files changed, 15 insertions(+), 9 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 90a29424c54c8..668886f50024d 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6381,10 +6381,16 @@ mapping for userspace_addr is not required to be valid/populated at the time of
>>  KVM_SET_USER_MEMORY_REGION2, e.g. shared memory can be lazily mapped/allocated
>>  on-demand.
>>
>> -When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
>> -userspace_addr vs. guest_memfd, based on the state in guest_memfd, which is the
>> -sole authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD`
>> -to find out more about the creation-time shared/private status.
>> +When mapping a gfn into the guest, guest faults are always serviced from
>> +guest_memfd regardless of whether memory is shared or private.  KVM determines
>> +shared vs. private based on the state in guest_memfd, which is the sole
>> +authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD` to
>> +find out more about the creation-time shared/private status.
>> +
>> +userspace_addr is expected to be the mmap()-ed address corresponding to the
>> +right offset within the guest_memfd. Any mismatch between userspace_addr and
>> +guest_memfd is not validated and is a user error. userspace_addr is only used
>> +for host-side guest accesses such as kvm_read_guest().
>>
>>  If in-place conversion is disabled, KVM selects shared vs. private, i.e consumes
>>  userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
>> @@ -6490,10 +6496,10 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
>>                                 page tables. Private memory cannot.
>>    ============================ ================================================
>>
>> -When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>> -guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
>> -consumed from guest_memfd, regardless of whether it is a shared or a private
>> -fault.
>> +When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
>> +always be consumed from guest_memfd, regardless of whether it is a shared or a
>> +private fault (unless in-place conversion is disabled and the backing
>> +guest_memfd does not have the GUEST_MEMFD_FLAG_MMAP flag set).
>>
>>  See KVM_SET_USER_MEMORY_REGION2 for additional details.
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 0afe1468d2d9d..e41802944756b 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -746,7 +746,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>>  	 */
>>  	WRITE_ONCE(slot->gmem.file, file);
>>  	slot->gmem.pgoff = start;
>> -	if (kvm_gmem_supports_mmap(inode))
>> +	if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
>>  		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
> I like this change, which actually enforces in-place conversion -- when
> gmem_in_place_conversion is true, if userspace sets slot->userspace_addr to a
> different backend, the host and guest will no longer be able to access the same
> backend.
>
> However, since gmem_in_place_conversion is globally and statically specified, it
> essentially disables the coexistence of VMs using out-of-place conversions when
> gmem_in_place_conversion is true. Previously, VMs using out-of-place conversions
> could still boot successfully as long as they switched to using per-gmem memory
> attributes. Is this change intended?
>

Yes, this is intended. gmem_in_place_conversion is intended to be global
for the entire host.

> On a separate note, is kvm_gmem_supports_mmap() still a necessary requirement
> for setting KVM_MEMSLOT_GMEM_ONLY? When gmem_in_place_conversion is false, if
> userspace mmap()s the gmem but sets slot->userspace_addr to a different backend,
> should the KVM_MEMSLOT_GMEM_ONLY flag still be set?
>

Before this patch, requesting an MMAP-able gmem will set
KVM_MEMSLOT_GMEM_ONLY, so if we change that behavior, we'd be breaking
the existing contract.

If userspace requests an MMAP-able gmem and then sets up
slot->userspace_addr to something else, I think that should be
considered user error? MMAP-able => use gmem for all faults has been a
thing since before this patch.

Just like how there's no good way to check and maintain the validity of
the mapped memory behind slot->userspace_addr in relation to the
provided guest_memfd, the mapping can't be used to determine whether to
set KVM_MEMSLOT_GMEM_ONLY either.

>>
>>  	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);
>>
>> --
>> 2.55.0.897.gb25b4bd76c-goog
>>
>>

