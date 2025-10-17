Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE2EFCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B86F8E009C; Fri, 17 Oct 2025 16:13:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943598E0092; Fri, 17 Oct 2025 16:13:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798CE8E009C; Fri, 17 Oct 2025 16:13:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60C9F8E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B6E286DB9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:25 +0000 (UTC)
X-FDA: 84008705970.20.855D91C
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58459140005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rt9G1wum;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3YaPyaAsKCMAgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3YaPyaAsKCMAgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760732003; a=rsa-sha256;
	cv=none;
	b=RyJ0FxisBoSUfkAYHzHnYSbS/FiZEYCiqyhHiXte5KW6pnBzSMYpRErMX9bMWmOfASpkN7
	HEc1YG6Prbp4VL7e92Jpt9qVxH3ypWoM8WMs5mD5VrrRJsv7hSzDG3BxVJK9K1LEr19Wej
	/kSrm4jDIxeFlqe4U+PLuf7qqzHtojQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rt9G1wum;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3YaPyaAsKCMAgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3YaPyaAsKCMAgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760732003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mpVwCYbwMET7AecOcE2QimVcHIz1TOOFcfyLkjDeGo=;
	b=0QpdlR53J42Rs1LvwQM0wPYvvvli0B2oza10hOwyw6ScTGjV3bsNMCIN/3tw9gbqJ/lOOS
	9eSqI3RRstWa4CgFIS8CHPjtpB9nsJvCyDkPxcth/TUqPAiP0aK2Yf+IxqtoRVCHOwsgM1
	f64tQvo81UcXsmnlyoNAGVm3yrYeiP0=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befbbaso2806609a91.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760732002; x=1761336802; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0mpVwCYbwMET7AecOcE2QimVcHIz1TOOFcfyLkjDeGo=;
        b=rt9G1wumBB4CoCgSjro3z3/o5K2AbnfZGD0NtPYpS1xH/TNiO3K30GobitlounrZGN
         cNyOoTvfe8JY+R1G44KFJtVOpSvcnXleXcDcDXm5Ai1LPPvJoscZ/sNEaJW415u9LRg+
         0fpEeLCLd9q/4eV3DqQPJ4qHM7KCQ2k9Wy86S/U7soBUl4NYmifKKlukhyLvDmK4TS+B
         Nh9W3qfSIvVDgqrz4UCt/3ghk/fV74jLUVOjyGfKZSs+bZowWqbTrurGEgg8SDLHmvzt
         ekjL7CEe++dNVktzG+DoHpMrmgfVRHv7h3NnsPMud9zKYFEHfH8WG3DYGCwOvKvvDCJ0
         y6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760732002; x=1761336802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0mpVwCYbwMET7AecOcE2QimVcHIz1TOOFcfyLkjDeGo=;
        b=S9CJcZXLS+VmSk3wK2cDyGn4K1jVuEIXaoG0CdO69mXiiYLPxySTtOK8WrT/arzfeH
         mfV99upfZzuO1lAystxqZP7qi7S2eIyN1kpsoBlsAX0ay/CxaR+xy2h0d2JvGKI86nTt
         vfVN7J/jXUECpSbPNsXD2DPyApDYuizAprrR8mXRHMSL/CWDMlt44mFKUubDP81QoP8w
         kRk7SzRpa0dFQ7mi+5rM8BLquCLzBR2NSDsxROkYh8hOvNMq4sbVJAW0rLBvd9ByYSOe
         A1HRnyOiQGtokTiXkScv1IEI1A+5ilsBZPr9FnAkJOnQ5biN/YmEuiTpWrA1te4bz8jo
         GFsw==
X-Forwarded-Encrypted: i=1; AJvYcCUjOj9KpenEvR03Dz1AEXBBvMN9FC1ba7ChpkPT8LZ1jct4WFu2ygTlfBYdhIr3Q2y0g5//kSjspw==@kvack.org
X-Gm-Message-State: AOJu0YzzV2B9Q2yUgtlaATtqiG6IcveUPpVuuN6VAZgguhOXtGDGX7CS
	dTwz444T/gi5hZakSBqeBDDkaQN075RAytcrnUYCDpby/Iu7GgYanaQTXV8I+P1Jym0ZIV8eYKO
	78nyJBrI8dQ05sIHi8L1Osul/lw==
X-Google-Smtp-Source: AGHT+IHcO4NwxOJfZLNEBbx6WNz/S52BTLMchZETWWpFSftU3iw+fmFyD6t6Of9AgSIAzGHhdhWoKd+61TBtvxNmOQ==
X-Received: from pjbfs17.prod.google.com ([2002:a17:90a:f291:b0:32e:bcc3:ea8e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d87:b0:32b:baaa:21b0 with SMTP id 98e67ed59e1d1-33bcf853679mr6444234a91.6.1760732001959;
 Fri, 17 Oct 2025 13:13:21 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:13 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <a3126618d7cb353faad7b231e70c2b732498f449.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 32/37] KVM: selftests: Check fd/flags provided to
 mmap() when setting up memslot
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xroxxr4etqxu7z6b7w8ma68ds5e17jba
X-Rspamd-Queue-Id: 58459140005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760732003-964708
X-HE-Meta: U2FsdGVkX187kPnQMwL3CPw4fozbGVs3UDi4lvyp3Kh8PayZ8zZoEwz8oH93TpJvd0y7jieaxYdrDX4gPmtEfpwPJEeJYKPtW5QUM4eEyyLMJ5fWBzc4jY0/YjlSE6LeH2eZWzwu0omfcipvIyqlql3w69dySwpuLkIeGDwhPbg615Auv2Yy3kTF5oo2I7vPlCLg01PE0PFwgxw/CzoBtUNP07jiZg5mF/riLo0nU3LFVIpY+vvRQS68Cfv9Y4TRyo28sRimE0XCEso6hKoa5xqBFwOk8S68e0rXj+jcDclxudCPCsKZfOpxbf2QDsmS9Jhif/xAxCKrFg4OnCfk6Qc/AtMMdrkliqCSyLdWNGrPGKPo0bGblC8gYa9GSNW0+skEEc54Gp8E7QGcHrGX/wbS+X0h8RalomsAuylud0g40e9lZP4mDS+leXs4giyHT85vfOdC/rxJTDEk5DzNh09mqLBliumoyFiN95NwM3rgjbQLyu6EOR8FC8MXcSD96HEKANpkF8+1wBgR5rB0UL3EUhtQws6QDaeDV+a2q4EHi0DsK/zgl6f60soqbnFhI+ElYLgUKx8ZNM/KC/AGnGLv0cruKBgWUtWk92+Fx0nK39JroNe9GAoSSnVERmDnPPxjopwuUbOnvYSTgijONXNM/L4uN9+/12Yw8LI0el5hRzhRxvZ876gceHMoVmcqgqpyBZjEgUit4W6KDAdDxDXUNM6PnF/dUyBSOe7sVfMdZoGI8mZilVd4V1ua0OXYT7FTLeJQpLZ8egOvVyVP+Y4hvZiFb8Op9tm0Qv3iY/Nzxf6y/Vp98jW00s2Dq6IXjbTHaFtXUPvLizeIgBRsEk9l3wwNqX3D+IHWJWdk8kzCOFcPxmfr1VIIiNHUpLbALhRtROXf5VtFb+4QRNky4ZrmNnSCY9JC91dnEbtC3zVrGf+pQlOvUP6FfdnEx2DM8/h3fUmzdzhCMR5frfE
 hTDXREWw
 w1XA5+SrTxewzLaoL4pVw2B0i15vXoZEC7uGK0zjVQpAPqQhUNedAoylK6Zh2bO84r1OzRy8GvpBzRO462i2ED32jWBBgcspbTNwRMNtggJcrmkkr78VObQ/dePygqsAI6r4/WTAWtmotOPoupSe+veBlj6ofNXQGrez1bZHNfmGQsvEqLfomyLEOnyxREL93zd1UDEO/bLP4W1M1JB7G7TAE32lpe6j4tC/nXyBVpGcwdtPjQpclH2lEGh2zhQDgrEQyF9nCARThtKp0kBCyZSsHJb49fSRvRh0rvFKn8mYnlEo+X3Ce5v3WbHAUwuKT9cmdiN41/BASQqBeTF8D37TShAi57lHiihiXmJvIXgDFn0r0UOa/kwaw8r2u6lq6PwAMjQtmAaOVYMeQ7hPyDCfCKUfQG0wc1FDQdvlAy92uQNIe70ONIIa8jwxzD9YRMpggCWLTPbS1POi/v+G4J1Hb1wmwl63hv4smSYhvilvnqsWxeQfactZ1NJNNtG9+O2UM77Y/gL0uec4q2kFjgodW9nhVmpI1ULtR5AOfMzz89+hn1uSxDVZVt9dUnU1Wf0E3q4vnZf43+clu8U3Tro94D/WH83YVg1ny9/jPpKNu5Nw5mtUXVTbgkQPvVRG6JqU/zaWrhazSQMlxBO37kXMZ3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Check that a valid fd provided to mmap() must be accompanied by MAP_SHARED.

With an invalid fd (usually used for anonymous mappings), there are no
constraints on mmap() flags.

Add this check to make sure that when a guest_memfd is used as region->fd,
the flag provided to mmap() will include MAP_SHARED.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Rephrase assertion message.]
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index cb73566fdf153..8603bd5c705ed 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1057,6 +1057,9 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		region->fd = kvm_memfd_alloc(region->mmap_size,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
 
+	TEST_ASSERT(region->fd == -1 || backing_src_is_shared(src_type),
+		    "A valid fd provided to mmap() must be accompanied by MAP_SHARED.");
+
 	mmap_offset = flags & KVM_MEM_GUEST_MEMFD ? gmem_offset : 0;
 	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
 					vm_mem_backing_src_alias(src_type)->flag,
-- 
2.51.0.858.gf9c4a03a3a-goog


