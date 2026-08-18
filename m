Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D3EC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2586B0191; Tue, 18 Aug 2026 12:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779A86B0195; Tue, 18 Aug 2026 12:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6116B0197; Tue, 18 Aug 2026 12:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F44F6B0191
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:33:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF2C1140158
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:33:25 +0000 (UTC)
X-FDA: 85114935570.17.ACE15D9
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id EFFA88000A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:33:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HfOymPAN;
	spf=pass (imf02.hostedemail.com: domain of 3UomEagkKCNEGxEHAFx4H3BB381.zB985AHK-997Ixz7.BE3@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3UomEagkKCNEGxEHAFx4H3BB381.zB985AHK-997Ixz7.BE3@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787070804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYCxMBx4BOPF4yBl5aKpfQIqd2cMC8x5BNz4F0URw58=;
	b=j3wZpmmC5VS9gs8bQcfC3r2WO9xDcMDzGxBIl6YsTdD1A99LofXorqBD5l+DsT1Ostemz0
	p3A+jZ4JwzmOpHIy9V2ptABSZ2BPgtZE+rgLXFV1d3CsboZhnp4/SeLrSkgsOSKmUehDol
	cY6sGwvMUqGQixE6KLDXfE9kPf50s6E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HfOymPAN;
	spf=pass (imf02.hostedemail.com: domain of 3UomEagkKCNEGxEHAFx4H3BB381.zB985AHK-997Ixz7.BE3@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3UomEagkKCNEGxEHAFx4H3BB381.zB985AHK-997Ixz7.BE3@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787070804;
	b=OAOUGLwjdhvumv9QnNBT4isyq4I7uq2YgCTwQ3ZYNsmeXY77tKYu3DqC6ge1k60ZTLuXQm
	OMPQFBZ7i95x4SlE/fS4JmgY/xoNjgJmWRz0Skh4M9Nfn5SCELOb9R+0yDIBr7XZVjQccK
	liFreKKCIH8kun383p57mQeMtVKMACQ=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c1686e23b9cso57183266b.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787070802; x=1787675602; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NYCxMBx4BOPF4yBl5aKpfQIqd2cMC8x5BNz4F0URw58=;
        b=HfOymPANocPwIX4EgEF76DL9yaNJmiMbXwk0a6Z+U1ff/H81PerPbvc4boC8mwcMqw
         JZALNPZ8aDoGF5xLR0QgbNA2ocg8cyDcaisjnINjd5ZfHZTV1PUbboFxHOoChVuGace7
         +tsWh77+RvASjmBuDZLcXG9EO5kC1XulYmoKgtVq1/UK8KpBQtc16+izLdh7Ydz6oNx2
         K2OID6h41k1z6kzviQ1iED8Z2Mb1Dbqkz7YkKwZCJGyDrPhzPPzzeOUleDppnXTadqJo
         I7ok1gux4xNsvrIxRcKLh2rn5+jXmF3wp4shGh7fSUY+I48mrkfIk4lAaAVW+6EH6AZt
         eAsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787070802; x=1787675602;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NYCxMBx4BOPF4yBl5aKpfQIqd2cMC8x5BNz4F0URw58=;
        b=TDYGSdl6djp+NHvhZ8zWOwKWn3x67sDdKRvi4/AKcwCJCXR2Ai0chqxiWJl0g3JF+u
         98khnajkHLCjs01Hev8a0skQa+dLMzuslvIRezodSjX6UsSZNKTEfYmrus5mwAnontC5
         b0YdAkCGKRM8cKM0BP4DmJMJ0mOE6roNtg4xOhVuFYvMdpKpKRk/QJ/1ADxuP0Ntoexw
         691sQuAU+4T2ZM3A20ipFOl0pV6/4pTJlaQnxvLP5XwtTeOSXXIf2SvYYDGovQFhC7jM
         rVsrjz2Xn0r8lkJb0oyMaMh09qnUism2DbzGGI4N+DM56sIUaFd0U6f5pxjAf6265m6+
         +oOw==
X-Forwarded-Encrypted: i=1; AHgh+RrdfQlCryDBG1eWGQixofp+gRtygBtUygfabXcdQwUjOEgbE2/UqesCt8MPCUbl1uB4WsTlUhKX6A==@kvack.org
X-Gm-Message-State: AOJu0Yx5sfxwdICWp+Iu4mcV/7Xkq9MKf7/PO9O8oTJxPY+YFkabjdiJ
	oDT6LwpBSGUUlLve+P43DaUCKmbg5nGUNqbx45wUdw26ZLS2hK8LUV2S350E3KabvP06LOkKoQj
	JDT+grcSMZKaUs/H/aA==
X-Received: from edea16.prod.google.com ([2002:a05:6402:a190:b0:697:8356:d9d6])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6938:a091:10b0:c15:a487:3482 with SMTP id a640c23a62f3a-c2188a9df89mr438613166b.21.1787070802257;
 Tue, 18 Aug 2026 09:33:22 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:33:21 +0000
In-Reply-To: <anpieno-RyRl54fp@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-8-tarunsahu@google.com> <anpieno-RyRl54fp@google.com>
Message-ID: <9huzfr0bv166.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
From: tarunsahu@google.com
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EFFA88000A
X-Stat-Signature: eom965zon49htcq5sssxngpb5ipa3oib
X-Rspam-User: 
X-HE-Tag: 1787070803-434357
X-HE-Meta: U2FsdGVkX19OIIUxgsLIAEJUMLtZmFgPMbQBwGvDJr2vWYI5kM+AbejG/GccYnxj0z4Zq9ber3aJJsjRw7AYBelWgbUPwNASph/Q4G/5447XgqEL2hbpFmspnqlSCz0cgCInOMcqJVJsAwD+Na16M1P9/W5vPvCcW08ylhsZbc6Iv/ETACmiyr/HH3+EpzZwJ75e8SZ9GYXk/9a+O6Fp2N1LrLNgUjuJJcoeLfpsID9e9dTqmBydW8jtAE13a9WYuamZ9rL4RmDmq/4T8kJHx57aDlEBAddQ95xgeMGIhez5744SC9B6uuWD8kMgq6FfO8O9+D0ou20vtlxtASvYu5L4ayIxYMebGgiFcZhv/sU0ud6vCxLNdMXLr7vE5WJuDz+75t5ahaNUJgvXAGf2LU0MxTwg34o5deEv0CNjMfZSp3OKUHwOdOQUB6Leo6fGqDgwLqZ/i2NMVoNRXLM3v2zNt6U0rBqpAQx+1Eh60TdhQ6EVIYDblBkHbh3q3zMNOPTg6s8Mjnf3WTfvhEd0xWKEV5HyGgfbk665qWp88eVYYcrWzmY/jjwgV5mn7YZIkyj5SDHcSTLtHbmxQ2DbTHKpzVBBRcEyEIhc5TGgUBe33FEHj6rlgsT9HgZD5snn4IBfdPVAbwka7a6LOlEQPEax2sqhJvW8ZluKWr2VkttPAM0N0PQEvhZRz0bN8y6YkVaosMq4hXUKTa2N0OoO7gvHdXYak/dqiQUuKFOuG6Z+ZyOF8QvsaKySIhDAXWTf1f/NyODiONaR+GE6ttySHetqeqas2+0o1i78F/IoNgWYdOBJWwiOAnpZDXgLL2bn999Z4rAvI/g0lQaNW/KgCNTYJ6cMFWe9sghAToUwCYrmRPxtWw4QD2s3mz1gT9p2RH2Wa+2rngd68UeLQsmodGK9CXc7yKDxaliJ3cIB8LLDZwUCfRRTtTsxTGmpiG+csldOLGUm0BNtQclhYZk
 fZnCkfMY
 L8w3gHYQx4WP0fpOhp9A1FjRQS+4xiuigmUMbci9YSyqZZAA/wlpMU3xX+STgpnJsW2kjDFVDnt/J7C6gMfL3HvdrdeVpLEGNuk061lFQ95sjiwqPv422ag8Q9JZM7+X1e6BUjBI2t5s7VkEF7G1pvlRgGV8LXaN1nCEnAZrpMDlkhVi5KBNAoIsxGIvm3qkyy73zmsngsvCippYOVfhZw4dwE3FVE0F5+coD4CQktLjjVqD5LAwiyDrHdNTcP3dOQrM0L+OJAxgXJhtnMphClyGe2S2X52AE3f+F2MK4+nTH/QfoSeA7k53/zqQ6KRgDhfz0jp68YmYm9SLLWAIM1vf6zxwfZgVlgcBXW7Wki7ndKaThT5VaZTlRhfXF5FMQ/98hFCeKV7J4nnH5HP4ssb/R7drxdH1uUF33cm6hN4jT0RVkhRse6+fIlODKSspVcTGRKBINp56eiLePSHLSpbd7HqZbwxzoXR3EoWZJZGhHdxuAH2fOrDFlmgZ1cTC6lA8XowCRa3I8ddamCRdArxE1uHhOeXX6Ry4Mh5pu8hnXAHp8URJP9x0VzwoK1TMreR5u1KtFrdhqeba41yES5VF1DQLO8I/fxq6pqCeRBpeT4vVOxPPdekbNVepEOCvCELYH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jul 28, 2026, Tarun Sahu wrote:
>> +/**
>> + * kvm_gmem_freeze - Freeze or unfreeze a guest_memfd inode mapping.
>> + * @inode: The guest_memfd inode.
>> + * @freeze: True to freeze, false to unfreeze.
>> + *
>> + * This API is used strictly during the live update / preservation transition
>> + * window to prevent host userspace and guest-side faults from making any
>> + * mapping modifications (such as fallocate or page fault allocation)
>> + * to the guest_memfd page cache.
>> + *
>> + * Synchronization Strategy (Sleepable RCU):
>> + * To avoid high-contention VFS locks (like inode_lock or
>> + * filemap_invalidate_lock) on the vCPU page fault hot paths, this subsystem
>> + * implements a lightweight, system-wide Sleepable RCU (SRCU) mechanism
>> + * (`kvm_gmem_freeze_srcu`):
>> + *
>> + * Global vs. Per-Inode SRCU
>> + * ======================
>> + * A single system-wide global static `srcu_struct` is used instead of a
>> + * per-inode SRCU structure to completely prevent unprivileged users from
>> + * exhausting the host's per-CPU memory allocator. 
>
> This argument doesn't hold up given that each kvm structure has two SRCU structs.

Ohh okay. I was very skeptic that per-cpu structure are not counted in
cgroups and liveupdate is once in a while usecase So avoided making it
per-cpu. But otherwise I am fine with going with per-cpu. Will take care
of it in next revision.

Thanks
~Tarun


