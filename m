Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8548EC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 23:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E12DA6B009C; Tue, 22 Jul 2025 19:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2E96B009E; Tue, 22 Jul 2025 19:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB24C6B009F; Tue, 22 Jul 2025 19:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5EE46B009C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:07:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A7041A0540
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:07:39 +0000 (UTC)
X-FDA: 83693439438.23.71209B5
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf17.hostedemail.com (Postfix) with ESMTP id C213040003
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:07:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="DjV7/uHB";
	spf=pass (imf17.hostedemail.com: domain of 3uBmAaAYKCDclXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3uBmAaAYKCDclXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753225657; a=rsa-sha256;
	cv=none;
	b=6K4m3phPjuKVYPo5TeTP8j5DJ+cOBxwjOzSni/v42NHKXaLUsIfklGYMC19MmxZ1n93pPB
	kIXtMhwbxIEMt25iqax0uQRck43jMWkOOUFdew/G0vZ1lgybUmhWLiStHjR+0YHb6dltVl
	uq7gZakBA+b5tCgb7z/Y7wWBHGKdpgI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="DjV7/uHB";
	spf=pass (imf17.hostedemail.com: domain of 3uBmAaAYKCDclXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3uBmAaAYKCDclXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753225657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+m6qI30JHvrm3ONaGCpQMi0L8lxI7PYDb1Mu/Pb3F4=;
	b=UxOEB/CCkNFfwB9iW9OKhsysU3T+Jw67TzekxTsQh5lGSEV0iNUQnCr4VM8c6VH2ozRe/+
	H5NYvTDYwXt+1TUafGLeH1eL8S0R2osR5sZXhjZcMGgPqGjexDD2EqQZiheSF4m9mRyR5X
	9NUlntqD6pRwOa0U1xyKvfyOUpVd0NE=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31c38d4063so4242687a12.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753225656; x=1753830456; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f+m6qI30JHvrm3ONaGCpQMi0L8lxI7PYDb1Mu/Pb3F4=;
        b=DjV7/uHBOJP4yAG/VtqFU6VyiYroNHy00sBy96IJtO49yIl2Kj554OU4/fQHNm17/J
         t65UymrGu2pCEmnUvYEOWEKrN6EWfaMjGWN4r8VcqfxBJ4fDfqM5gb1HIG1Q0nEXODnb
         kt6E3bIqOEcGkAAGFXTisqxvIPoNx8EK3WOUVzT847Zn8sJ7OkxFBOvaokxcGS4+KZLB
         wu0J/al3f9p7X8VpBW/SWbd493VUWDUdBkJ5F1gVLpuyru396ZVioOlYI3hPgVio3DCa
         G4mxVmlkjn0ESQuAPgQQqrIDSVf4SKI2hd06610zmqBx2Ba03uTEAoR9qVGvlReKd6wX
         EpXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753225656; x=1753830456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f+m6qI30JHvrm3ONaGCpQMi0L8lxI7PYDb1Mu/Pb3F4=;
        b=B2K1kjhftFq79Z2qJ4GBrFjvMQpq40RJR6DoJvfX5CNTui9vogpttUjjgXeI7UKXg8
         oqc4IddFnF0lGsstgiFlodOVr5w7A/YWcbP5MW5LdSo4HuTcebPrltqp66AZLA6gIFsD
         oQE407i2KkJ174shgKmb8UkT+bW4s9S56RyQtO05HJzjU23kJMd7g1BL8yHRl57LQ1on
         kkMI6rtasM7NtCvg5KIdmcIpCOJtBrBJunbUG95n9jmQyVjDUOGHwldq6t7nVyEaoEVK
         CgY7+Q0KU7qbTj1gP0zqcCQ1mUlLgP9Aonj+bCty5Djj3KZeRRpLX6bfZymeH5Z/0Uv7
         292g==
X-Forwarded-Encrypted: i=1; AJvYcCV+Y6suzI+QR884ahQzr72mGuR8fjUobrY6cLkjV9ZXyce7UICt4Zyjf4wYwA/7rq7bErPoIIjLiA==@kvack.org
X-Gm-Message-State: AOJu0YyB+2Gs1CEFEe273gPPI+GBdCJ0PtJDAs12ympohkuCuGPAstwN
	GjOfF0M7A0uoQcvBNAD5OVo09+25qPy8HOgi4YlvJ2N2HeIjLeayWjdyo8Jw2k4Ts0cBDD8E4Ya
	SDm0oeg==
X-Google-Smtp-Source: AGHT+IFOb8KYXXobVAAvvjW+Fe1YbH8mwfp6V2E801ROWDybd0+20juthdBHS5x4qZEtLjQQN6CpBVqzr4M=
X-Received: from pjuj4.prod.google.com ([2002:a17:90a:d004:b0:313:242b:1773])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5647:b0:311:fc8b:31b5
 with SMTP id 98e67ed59e1d1-31e507abbc6mr1697551a91.14.1753225656408; Tue, 22
 Jul 2025 16:07:36 -0700 (PDT)
Date: Tue, 22 Jul 2025 16:07:34 -0700
In-Reply-To: <80a047e2-e0fb-40cd-bb88-cce05ca017ac@redhat.com>
Mime-Version: 1.0
References: <20250713174339.13981-2-shivankg@amd.com> <bdce1a12-ab73-4de1-892b-f8e849a8ab51@redhat.com>
 <aH-j8bOXMfOKdpHp@google.com> <80a047e2-e0fb-40cd-bb88-cce05ca017ac@redhat.com>
Message-ID: <aIAZtgtdy5Fw1OOi@google.com>
Subject: Re: [PATCH V9 0/7] Add NUMA mempolicy support for KVM guest-memfd
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>, vbabka@suse.cz, willy@infradead.org, 
	akpm@linux-foundation.org, shuah@kernel.org, pbonzini@redhat.com, 
	brauner@kernel.org, viro@zeniv.linux.org.uk, ackerleytng@google.com, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, 
	bfoster@redhat.com, tabba@google.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, rppt@kernel.org, 
	hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, kent.overstreet@linux.dev, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C213040003
X-Stat-Signature: pqgneaa7i7bbsnfnp15bnniuh6bapfpd
X-HE-Tag: 1753225657-765539
X-HE-Meta: U2FsdGVkX1/8SVn8GPHsg7K74PhArP9aS2a3A2KG47k2/I+7E1AVLxqSCYpuZ0DZoiP4lrcrzy+XDOpafmyj4pOHqm+34w29saxvi9AO4KpgTkKs1+tKH2X+JwkKuV/9d4uL9JQLsiYLuouBhYC1xiApePlsj2uuuPmx7iYqhA/xRMeg7vO51RFlzm4sgRf6+YaC8GKJq896ADaYCaP9sMZd/fFujvKduLoVw4fhu3oVDtySeXYKUgQF9fEnHGPPkY9bG7Q/GY3iuHHayki0jGPE8UTACmWUizrFORzScQm526HjR+KZ1eSqrBleE8OiViPtS41/8De+/DpGxvc9hX+yUHbFTbEStDLNJHu3Xr8G0EUZCwksYPZN0Euk6uLtvmfhGQj440F7KNNssSQ1dbxeGCDzy8ykETGQnKrbjeZwFWP4/qLKwOOpYB1uqISe07QWWkqzk5ox23z0A3RWsmC2/dnwof1loHZ3FdXIsk7sUser3paBrOvzo6C+WA5knufHF/7qvrGturW1b7GEk6Ii2hHBpKuvDdhtpAFAxGbA5s5INE/R2SnVOMEF9rUmUdau8PUfD0/xZMnZCV1PxPplrNFuS2PuKKcleyTb1e2UWblpXO7FC2RNoCtfS/AoUOsMYniOG3h6e1ZWJb9T5VjMlbMfteVfCpUjs43HInjBb3Nmi+nbCKYZf6EDYJ/7bQeMBlfnQdETxjDFfjlhi1+ONuTI+tgYtysK4PK2N1mxlfCjFK00yA1LbRnZpfLmI1DZje1DspWxkpziJX6GUAnfK6L1zbcFVZbL/vGBm9o98XLrbEjovKKwMlDUlr7IC3zoKBNUP6QnVe+FFfpA4mFxPCznVAExPjALgfqs3IAbr9qWZtlRwbMQ8MCp8p/jHIMij64jLPtmUtGKA86QLQarrvHfS47M6ZoRpBfPDZ5PCuKm3Dyj+BrAwmnwQFFZXndBKrgB+rk5m/lhmvo
 qKCkU96y
 XdukLHqYrYHwdFBHFOlvM3ZnAwRl3cnh93oN/neaXJCCUo69CuVYoEaC8GaSz7OXAe+TE/j7XL1aJdpXAHJN4aZfyEWVV4KLraQohbPO5p/7ZKWCGL7TFgjMS9mIcE3Acsl/LsrSNyXl6LgKOPtTU/ngkjLj+Xvu9KDZC0VvWMA3fKGHmZX//S3U4rwg7XXfVoJrbdgxnQc3rzmBH2QizYYJP6qX9JvuM4pcOKs13opMesaBoV/fXNygo943WaytofUNR9UtrMxVv8sHgMDLf8leApuTH+ZkeKI8N598U3aEAUlGt+2eJuhjO9DR4xA/SefQG++h389k0rY3VNiYA93e7GzGq32PHQO4+dyrsRz7gdIQmCdl3gc/2ehtmx9yt1S9l9epuLY0or5Q/mTrWGg4Pjvjq5wM0JXLNcQ/nzJCGYn6CG97j/LIG0T5cQsVhaYmNES8qg2giViuqJZhnFvwjpQPhY844FnumkEftPIuiYiiixa4kMSMPf5twZ1mpt686n3taBHPRQAiEdzpLUBPqKToTMKCsGUI4qyt8ch96FqfdPJVQNIMdMnzdsnFZvwsaYJsNXtvBSTlRmNK11Mt4LIxAwpyfH1JaxHIBl2m4WtNHtXic2Co/pQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025, David Hildenbrand wrote:
> On 22.07.25 16:45, Sean Christopherson wrote:
> > On Tue, Jul 22, 2025, David Hildenbrand wrote:
> > > Just to clarify: this is based on Fuad's stage 1 and should probably still be
> > > tagged "RFC" until stage-1 is finally upstream.
> > > 
> > > (I was hoping stage-1 would go upstream in 6.17, but I am not sure yet if that is
> > > still feasible looking at the never-ending review)
> > 
> > 6.17 is very doable.
> 
> I like your optimism :)

I'm not optimistic, just incompetent.  I forgot what kernel we're on.  **6.18**
is very doable, 6.17 not so much.

