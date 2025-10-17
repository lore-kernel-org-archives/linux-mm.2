Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0888CCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17248E003F; Fri, 17 Oct 2025 16:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0058E0006; Fri, 17 Oct 2025 16:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8366D8E0047; Fri, 17 Oct 2025 16:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B54B8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA14B1DF671
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:51 +0000 (UTC)
X-FDA: 84008704542.03.BDFE344
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1F8C1140014
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gu2Tc3mW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3QKPyaAsKCJ89BJDQKDXSMFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3QKPyaAsKCJ89BJDQKDXSMFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KR72vgpCvELPyR/ICJ3IjpNbxUCWAnmK6eB3NpuYbR4=;
	b=1bJ6OS9w70VxcWsLgCd9FIdjp8vgyqYEEA2jnATfBEEqQ2EjNl5FTkvRlpvbjPQPonKD1Y
	Qi1QhwqL8K57avZX0A3PMiVXTCMbNBeRXSVqr8azS5tL0jKqbkQjU0qLY2Qh+CDwnwDUBD
	Xk+0xm94vIFl/DLdi3/9gkf73v+QaQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731970; a=rsa-sha256;
	cv=none;
	b=fy+CQebhzY1JOovPl5jy1/T4SaWrR9Cpb4N1ABJogAZGTTepgAaWqudJrEHBUpFNVC9i0c
	qX2aNJxN9H6gBbAk0Nb0J8jIqPuyJj75j4X+8vJnCaklE/BRuUx7CMhlaw7PDvQFs5IfmN
	jz3v8raXGHzOc1054M6KvFQ9z+Lax0o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gu2Tc3mW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3QKPyaAsKCJ89BJDQKDXSMFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3QKPyaAsKCJ89BJDQKDXSMFFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b631ba3d31eso1635676a12.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731969; x=1761336769; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KR72vgpCvELPyR/ICJ3IjpNbxUCWAnmK6eB3NpuYbR4=;
        b=gu2Tc3mWjJbjqeOoaBVgzV2CNU3rKyD+jq+qYzxq6D3Sp6JMAq59hg6HnAbX/ANGs7
         kMzNuUH7ZKXtZ548JzOOGtgrTmAmWjIyAdxsoD3xAgG9mWs5a1Fx5U8qJcO6PSEYrYnr
         etX2axY1nmiIj/mpqFMImTFdiAgBS2tE8Ms5kfei0/OytwNt+F7MFlKaAhpeier5QhDe
         xCL+7hybD6sR6Nzx5hqgXtQKTpuEJVIOJiLSTCBp6gIG5WBuW4vMzubB10xTbTcWRLxR
         SVvPCPUWiE9O5Sy5AQZQo9DZEVBMEw/HtvYsjvzMwNVlr6aYMOz3hvpaqj1bapsVTqUC
         EHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731969; x=1761336769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KR72vgpCvELPyR/ICJ3IjpNbxUCWAnmK6eB3NpuYbR4=;
        b=AOT7/IaYbFnNAYW7rrmkFSNvWwiZe8SVWFBG9o0n7FovVji4cBJAqU6GpdLnOqWW0I
         mZ5fkdDZlCzNNOaldOyZ87Id8mV22/aTlGo/D1BJXngexf1mt/FTDeNX5T9V1S6aiUVv
         8r9fdSE2lpaTtB9rQB1ii3yZbsOSdTVMWHgy5rwyanByal7nXA8C+pkfrVYnFQWsE7uy
         QVetzMRDK+4D5bZpT64V8hRHfmTWOKKbmJ6NYBz4CU80pxOHp63ReC6uvwfPQZXjYtJK
         8FXeJJaLgmt6s0OEntpvqsMUoMBxEA7kZXTX90rVzXVWCyy/EHhhgFexOhEym5h9COrV
         kLFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqGndTahFMWjtL1q0+E8gkkvdbbZ6HFRGW8WfwIvvTARwqZxJI2sBIvI6TOJUU5AF6FnDiMNOLIA==@kvack.org
X-Gm-Message-State: AOJu0Yx3voJKzET1kOnEW99jpHo3cfKbm8/WGmbueYEmK2/KowxOMZ96
	e+V3O6bvEIjnfiPsYteACTbZaiscKjCvsTy06+9PupP6b2gw+fkCMsYL4A8nPdWYahAWZLOjdg7
	rNipTEu2H3Iy2eq5wNsokuAgpRg==
X-Google-Smtp-Source: AGHT+IGTLI28yZrk0rADnL8AJRnYpgX7fVX5tQYbza0e4ND5OU4Hj5SMJ3v64nlbDhoh1Pqxs5RCZmim7dvJP9f9Zg==
X-Received: from pjbdy13.prod.google.com ([2002:a17:90b:6cd:b0:33b:ce80:9efc])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2e46:b0:335:2823:3683 with SMTP id 98e67ed59e1d1-33bcf953e72mr6347941a91.9.1760731968802;
 Fri, 17 Oct 2025 13:12:48 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:53 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <36defde6a09d2a7b4ff5507b752546a906b262f9.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 12/37] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
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
X-Rspamd-Server: rspam01
X-Stat-Signature: hwruxnjttecf7c1duccbz67sfdgpija1
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F8C1140014
X-HE-Tag: 1760731969-173461
X-HE-Meta: U2FsdGVkX1/JrQ7hOHRmNl1fodjuxbEZVOJcU+XFv1R347JuoK5yySV5oE0xBAHq3eMzQsSWZZuENqvVLepHt7fThZJWO3CFtcT6b9d13GgqVKkZaS0tWZcnV4uSVqyyAjxSmi9D/slhJK4Y2LZ+6TtI2TM+el6KhUr8NOPE7XmRY6AAiPCLKj88IjnmCadgzpZx4mPg5XoTut5bIA0GC8EWueUeCOQ8LrkVjyludm8PEKWsUrMIQQWe7DFpRB1SkcA2OW+E1gPHm7XGyGSa79gxcNzcdt9CROjUIVhMkUMb0rHMbKMaRHqHIN9ZSp5XqQ54hrA+Xqg3EQbLJ3qwQeVeVZTvBZcaSCx2TJt8VKB+N9PdcBFG2K5ML2eExu5Fdr+7YVtUncKFI9XtCxSgjAq8R11dS3rGiBk+/kOB+TUSGDOdpNKvOuckUI8FSaLhebO38y3xltXQEZeusgSgM4zR/VM1mmqh1I1/hEtACaVF91g2YBRB/91h5lQ+eb/opC+dH6TqdajNzu5zT/rLF/DAW3fhNAB6DAteEiWwmIYLK2I8Mp4Ttbp91c9jnFs/YdgZ5krV3/rZIe+wenwb3a7w7pegSqV6UOwLTNd+AcAQfaU0dDhTr93gj+L0lYSwHqz+jxBf3Wm59iQJl7XYPA8W7cBZ06jPClqo98uOma4zDp2vdIDJN/xwySnt++Nprlwq1Dp2c9W6YvKtbAxe/nldMxziJ9vyX+epqXQpzi3N+W25qkMnRR3Li5PtD0x6KKfG3bsoIIyVVmLNSwjWMB5g1b6W3+BqVF3/fswSwYcHUY8XoLSrWkDQwPp1X8f6RwYHeFbd1MogndY7oOhFFh9p9IsOmupP+mNYtAhuSDMGK83SP9OVr6o4rJSbMra2lXOYdglMxdnhS9ZT53NSw2M+TbHHOcnmR+3/K0IngbksMzCHJMOHAWbRHO6d0aRTM1gWocYNsGbMw9yT1j3
 MAm52HkM
 RzrT4BpP9Jfp8KWOm38JYt4ZrujWhhNpWMwkBA5BBJ9lStNIONVN26k1cOIoeydqNnROr/isoItC6JyEeHenGqp9pzvGbmBpzOJidfKWO0miNU2thMbiQv03N06GD/Rvn5ObqmVx9PWAs98dU7iMEIZqvDjQrHY50vCDBGykqzBmt34VzcmmzEjze1AsTKUQpPW/K8kH5L1BTZM2Bm0qG30Xkr1A8pi+scxe6w7FLf8M+S/82m2KhSoFLggyxm5hXuYdk/objiGR3+OHEfzKaWxxXNMZvaXXXIo9AHGIUDwHHf0tFkNPjYMSx3Q+b+30JTiHhbo3JSFCY9z0W+UeoMDPgP8WU1F2lUuajlBsFTOynUYi5N6Gz3/WwfiCJR/EP4eS/nI3FI3OPgqQlQaSK2Taxcv2W2HPdWtMVH1SAsrfy2JeFlFEmWoHGccIQ2MAsZ+0kxmA3kp88y1LvCKp1mGDOEaWPQCzclE9W7FM8WjzSFoCK433pUcDOlr28y+A0pNeCXwyS+Nm/e7iG6DQSgJKP+QlmW+vnr1+OtiFmWwmhgjZgaaEV+5dSOup6rRr1Bv9Ov9OmEtLT8hA8vJso4Qw9EE+rYzQwWmUE4sLVkLh5jPOjidXVWkhcRgM54/hqSCHcpt1Dz853mCXGoPnpfnGcvwKqww1/Xr/X+folcm27St7Nnm4g+GrZypqkLDVLouMnP/zOryO0R+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Bury KVM_VM_MEMORY_ATTRIBUTES in x86 to discourage other architectures
from adding support for per-VM memory attributes, because tracking private
vs. shared memory on a per-VM basis is now deprecated in favor of tracking
on a per-guest_memfd basis, and no other memory attributes are on the
horizon.

This will also allow modifying KVM_VM_MEMORY_ATTRIBUTES to be
user-selectable (in x86) without creating weirdness in KVM's Kconfigs.
Now that guest_memfd support memory attributes, it's entirely possible to
run x86 CoCo VMs without support for KVM_VM_MEMORY_ATTRIBUTES.

Leave the code itself in common KVM so that it's trivial to undo this
change if new per-VM attributes do come along.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 4 ++++
 virt/kvm/Kconfig     | 4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index acb03b45ba050..49c7709e3d895 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -80,6 +80,10 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
+config KVM_VM_MEMORY_ATTRIBUTES
+	select KVM_MEMORY_ATTRIBUTES
+	bool
+
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index b3473aec4d24d..72b19813e5412 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -112,10 +112,6 @@ config KVM_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
-config KVM_VM_MEMORY_ATTRIBUTES
-       select KVM_MEMORY_ATTRIBUTES
-       bool
-
 config KVM_GUEST_MEMFD
        select KVM_MEMORY_ATTRIBUTES
        select XARRAY_MULTI
-- 
2.51.0.858.gf9c4a03a3a-goog


