Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6263310AB82D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D1F6B00A5; Thu, 26 Mar 2026 18:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204C46B00A7; Thu, 26 Mar 2026 18:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00BB96B00A5; Thu, 26 Mar 2026 18:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D33876B00A5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A226E5D4B8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:00 +0000 (UTC)
X-FDA: 84589645560.07.29B76AF
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id C44B1A0008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Wm0iFOr/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3ObLFaQsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ObLFaQsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563898; a=rsa-sha256;
	cv=none;
	b=7YNKgeU9PxqwAdw27elA9xaTqSpp2lmvXCG8Nhr2LWpbO5zGENh8L/ZWEnT2U1Rfy3f5Xg
	Cy6BNnhKQRQGHDBVS5qRlRzgcL3xZRr46JdRVxQ4n2CAuFSxbUwELrrJtUsEHGNWXZmEyh
	aHduu+BRwlCYO8/9Y4T18vYb9JQY1Bw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Wm0iFOr/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3ObLFaQsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ObLFaQsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TP0m4OKRUtxmtY99mVH8PUf9pC8qTzihU9Otk33F2IE=;
	b=QMKqmkY6sBKWm01onY1cequnrb7VerMOmZJUfpH8dzPRclDdBQNUKAOoG4A8RqJJG5pJWx
	8pJR1FOsTesy2lrNyCeG2IydskRGix+Zh2zDeHW3I+u/SsuHgaC+WsyMLMEaei6EAUr9m3
	Xc5g5Ac3oJlWsjIXLM7WVER+EJKD7oM=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3568090851aso4602091a91.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563898; x=1775168698; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TP0m4OKRUtxmtY99mVH8PUf9pC8qTzihU9Otk33F2IE=;
        b=Wm0iFOr/kxqSEmsbKRpikIqu+sXZXi7cdRzFsDedMiZveLNaWYSpv85ODhHekJf6Fl
         Ky2nregbpeKMX8uCKhVgFsNBHXgrqW6f/AcrvJSzCGhXbgMQwEzPsR7xPadsTO+apXqf
         3W71cH3tCbLVrjHBVrWkITx2ZfBHw9LB8mhaMYp9ot6kpj7sa6DYAbcgWu7lvblvl1Bl
         2xRszq5OEB3FiT6BogkkdA7Gi2QofmMAf0asT7FLqiPNL3P15uzX2MeNtMH8GL1zEV2e
         CAn35LdWDEoAOoGR7Qfz+WJCUNVPltBkxLh8C6ZuV+AuXA9BwDyL4orjszTehzMXzyBr
         375g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563898; x=1775168698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TP0m4OKRUtxmtY99mVH8PUf9pC8qTzihU9Otk33F2IE=;
        b=bnuR4ucUDA5PA36TCwF6WRW1vN06dNF8/OZ3ZMsf49H+P5/mYqAP3SgCqBLGAcDmEp
         J2bdLOWLIo1bICYiDTKn10fhp95/ilZYqQzX1YcrFYCIVaINxDeIVigI3a/kC0VmmBHZ
         tBLhm0q1XaQX7c1//4IlHWKJ/AkkRc48gFWcFWR1HVvhxoKWE8awIUCwc8xWBaI2lhHL
         MZBIQAqJX1CeUE0w3j6RfJUb+PE98Hhtk/moJGHhXx7Pir1xL2t9/GuxgBfRTwiZoiuX
         +bSUbFSs4aGtJjHI9VYqzqVMzy70rqSzY6X35woawwPbs9SURwRrjkS9ugR4Bxja0X+B
         6wcA==
X-Forwarded-Encrypted: i=1; AJvYcCUvd+bb+IeQpZ6PfRZ3kIEZTU/rBpz4Fhzp6EIXp3dUMGFJhk/3XfthExxjyQw/NOstPzUtvMuNaQ==@kvack.org
X-Gm-Message-State: AOJu0Yyftu6gfUQfJKSZiBWOC3gJffJEQMC/Yf29s+fGsNZ6qEumHi/d
	p2v2QStiGUoFTQS4fGf6FG34cME24vAIFglpdIzAFpZyeUnL3y1J0Gr1AiCFDDHwIOspo2RGYd7
	En9ixHFO/i7QYuq5hUUf78ndrDw==
X-Received: from pga10.prod.google.com ([2002:a05:6a02:4f8a:b0:c6e:1954:345])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4ad0:b0:35b:e594:5038 with SMTP id 98e67ed59e1d1-35c300b7e5amr211045a91.17.1774563897304;
 Thu, 26 Mar 2026 15:24:57 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:25 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=1752;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=eWTeX+992GeYO26dNFWGC344Wuak8bbQzmW7qdSnDKw=; b=SL6pYdxlhvPJikdSi+mQfL/6DG+UDH5L2C4BN1AeU1jYKBkDwTYhcD1AK0H3INZXB0ml7c0AA
 j3kIXGoRZuyCSKk9sI3NBJpxVzzQomxNO1Xr6/eqMY1cnRkZkNjdzmW
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-16-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 16/44] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 89s1xbuyen8uug6z6sceqos9zc6tsmcr
X-Rspamd-Queue-Id: C44B1A0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774563898-353083
X-HE-Meta: U2FsdGVkX1/zK3UNK43iGXU0Flj+k11La5C4bvTOewagJK4GMjW6KPY8I33/SLPp8mdBc0YCE75AuQ3gSr8M+WEo98b11HMhaNi7O5onLICF7yRC23ZM+uxOOOsP8/YZ2XB67XDGHwn7/j5359YTnT09gaKJFaLMsWYpcwe5WX50B/4Dpjo2X7kXxYOfyAwQGi7xSyw1s7swV+spcp0G6Eh+HkBKIizOIKRq2FVwre1Ut53N6833kyQv9v/FpLw914c4mljQ8ef5ZX0rMcIUpkwgUo9hLkJM7CxCb8czzglOX57VND46cD72l2tcKPYN3XUvswLVD8q5kNF2qwoEx7Rbve1XM3H7yadv3hu3qQmoyVNrMxQL+vdN/0v3vfkYCF45i+HiE70NIRb4A9NsTGxpYLU1M8KOUkvXSACHUGSArvvvoUYO60xzEXdn6peWObMR+2fnZc35BRocvkgh4EwTJhv/AjQz6sp1MuWI/KrlDqusja0siLWxMmS8VKX2QufTvKV+6juO1ifkVn22bfDGxB7YooKcd+A+wlPbRvsnOx5Lfsjkx+I3v51MppXEaStai1mlJbonsgemqiwxNAzilVc+BRcznQat0CugdlIi3ZpN9rhvhx3E4Ikpa1PJgoH7wQ9yjdThQkWexjZRdiOal0NNafbeoSnZgbuofelTGVQGaRi8eHLS0skYqbBIPbJrRFq+fmRT18SH/g0+oEDxYAzgsY3b/QABi1Hn16i5HRUgHS2w231FmGsQxz9dID+1ifIbxvdimnwTzG2BnrWtXb14ucVlSrtVOVp40GNc6ZxzEVL5LsD4dMjG89AZqmeb/nH9GT+61hPAztqczLxhkzLFlsC8qYfgH8C7gnHDXbjA6Ud78wx9vsNhWcIxLcXgXBEuu20BWEzTkLzJHbIt7ptDmtpUjSzQq13MeS1LbcslqLx7PyjQ8kt+rolxd7HEaygQYCucrlhkD1c
 OqjXjIrR
 wYINjkNCrriaVkAn04tJXy6jil0rc6BySfriecGHyi6kRzBgQ4WY+XJmzyJCNYidkuFm4cdDOw1+Uep8tgdTyzvbanEC+qam+1yXeNxG7YddPBbRUbnwFcJmkpG/vZF4atMhYCMzIlTU7/oekpWwwJE1hQ3kNtrUtbE8ZguXtTH7nj3JgQ/URrkFBzqdx4TPHjkPT+l5h0HpvvhGaSbHaV3fXL9saXXaxHU0MYCxzyBRVDFYOl3IVF801TPfm9z5628jGza0bgr4gkct33IlPQQjMEPw77F1TPrUDUMyT1ZF2xDwRxIByzlpOfVe7vsGhoXP+DTaG3fbKHLMiUdaOks5H7sX0QPp5dEMf03ewXZ2U8J9sF2WKE/jMcAY4Vdh/CL84l9zx4oqXoY9nTyzyCrLm2k5S2MW9lhOpRGwn32u9yaCaFPHSsxKqyko7e32VAj1XN3mGKg5okKTR65c2SS2LNGOpcUa2O5CI4pINAfb/yK7R2R6WkKUi+kdCIeMSAQtOj1Y21U8iMMQvZBwlRjZfQH62OjqgTeHkDJtOJG2w8EqJeOQ8DV0inDTQx7o3HacPqMEN3SfMOZbYufxoim3rHdmHat+L0chkVfeWUW9fIRvw39QaP0ZWl2WnEOjSlqPw489toAAuvtv7uprlq8zpZ897a3Q5LSzejvP7v062yvgburA4Pm9vLxAR8ATG/8Q9jnNhc2Rm1TN/5jdmAcWRmw==
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
index 26f6afd51bbdc..b6d65ee664d0f 100644
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
index e371e079e2c50..663de6421eda2 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -103,10 +103,6 @@ config KVM_MMU_LOCKLESS_AGING
 config KVM_MEMORY_ATTRIBUTES
        bool
 
-config KVM_VM_MEMORY_ATTRIBUTES
-       select KVM_MEMORY_ATTRIBUTES
-       bool
-
 config KVM_GUEST_MEMFD
        select XARRAY_MULTI
        select KVM_MEMORY_ATTRIBUTES

-- 
2.53.0.1018.g2bb0e51243-goog


