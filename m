Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD0010AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AF2E6B00BE; Thu, 26 Mar 2026 18:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5137E6B00BF; Thu, 26 Mar 2026 18:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4289A6B00C0; Thu, 26 Mar 2026 18:25:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 289DF6B00BE
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0475D1B9536
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:12 +0000 (UTC)
X-FDA: 84589646106.13.B8D8CE6
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf12.hostedemail.com (Postfix) with ESMTP id 059D640008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vv4KnvZs;
	spf=pass (imf12.hostedemail.com: domain of 3RbLFaQsKCBYwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3RbLFaQsKCBYwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKAErh/ctHw4bBFHVNVYhm/xs3KUEiqQAb+NxvlWO48=;
	b=Ygkw1oS2xI7ZKE4Ku495omNlFY837WmSm9EmGAhbH2Niohfagn7K781j4ANfAo6gZoxINp
	nx8ROuVMmww5UJjq8565tumdgqdAd6vQYukK3Z6NYXZN6cGkA1pkZpu8fy5BBFexsqpMZY
	udQVeBb50y6Fq7qqs9eDEZdixneQXGA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vv4KnvZs;
	spf=pass (imf12.hostedemail.com: domain of 3RbLFaQsKCBYwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3RbLFaQsKCBYwy60D70KF922AA270.yA8749GJ-886Hwy6.AD2@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563911; a=rsa-sha256;
	cv=none;
	b=KrJB5DFfJlxgfjse4pMPZ0Cv/tuxV1KoBTSVvBcRnNLE0+3lztGlpIcPuy6dM4tVwHQHf5
	wNXg4PMzq5jqYu8XpOf9zQja08qQxeCDK8/2f1LH8XthMgfut3jMPALWBckcQROyQWAv/M
	bsxdFydLHKadYtEwIiO0+4mw51O3dOM=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8230d6d54a5so2543541b3a.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563910; x=1775168710; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BKAErh/ctHw4bBFHVNVYhm/xs3KUEiqQAb+NxvlWO48=;
        b=vv4KnvZsa2O9bvgURClijTaBOqnB8tjxb6ppDcY9IcxAb3+n6zIWdcC7V5UB5eaOhc
         JPbNk4UUCccA6wKGLHXJzR873zRU4JFQly7gCgjWOAajCFQgwrZCLEN7pp1fx/Kzodth
         vK9W5ktIO/nJ/tb4Dw0zz3IRsWhvYAmZonqhsw22tJyRqzwzmX3+RnMMbk4sChsuoWhN
         HF0rhgEP74nQQd9Eypb9aoisTdrR5S/LDSWArIGf1/mlGwx7Z03CCCW+SNNquqrPy7Cr
         t8VnUAFFNKT9d8iVWEsA7gGRIfueCrbYvzycYYle8QV9evjVAdvEHKEERvL1q+VdDcVi
         GPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563910; x=1775168710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BKAErh/ctHw4bBFHVNVYhm/xs3KUEiqQAb+NxvlWO48=;
        b=cO/SKfFOlxN/U+1Oi91QdH27cUAVNTxDr834oGDUk3ryD9VEXGQfwkeeGA3DK+TCxV
         nGrc1/bjROAIMPr9CyJaR6ByfQCapSYnPpn3lrEqjswL8yCf74Fmr60LFbJ4ZClIkJ2d
         Z2JK4Nl/pasP6Wt81wOCpZs3vs9rnd6gl0eiwcW2Oubcf00Im3BNnQdy2WPez3U1Awj1
         oHixszMKf0IUXOrT6fatTg7sHY20JU6UsgknE5ixdTIN6uDhDJhzi7SGqdZwNByyfkmW
         YqcTQ5BEAikX6MdZGhgc+jjppCCuH6vr54GcwxG7iVeImhRrzOKgLJqKUP93kiAlaTAV
         YNBw==
X-Forwarded-Encrypted: i=1; AJvYcCVY3HFx3cA7b0WbRHxDOlQvnOX49fcwyOPiJdiIYW5VACQfCLv2XW+uiIAjt/r/31NbLvWOeWHDHQ==@kvack.org
X-Gm-Message-State: AOJu0Yyl2txO6vbPrc4ScmBkBKq3De8WVjB8BIoMdz6d+9bgbGo+cfbw
	3WO1RpIGoATcJ4/n6B92R4Kl8hA++D6Fg56S9hgNmmlU4/7wDgi7L98RIh22V+wO957bRMn/H3q
	2eMOMkq04+wXSQJp5yKoSA0xVXg==
X-Received: from pfvf6.prod.google.com ([2002:a05:6a00:1ac6:b0:82c:63f8:59dd])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1bcd:b0:829:7b30:92f4 with SMTP id d2e1a72fcca58-82c9696ee44mr32265b3a.16.1774563909447;
 Thu, 26 Mar 2026 15:25:09 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:31 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=1678;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=keOumRETk/gmfETxrp2mpR7R5rvo3p/7A7+F96j8jbs=; b=NE1rni1CgJtrAphsc7U2X9T0bOxF0e+UOsyULzNujOmZouX64/8+6HJYWpj4MdSaexkYeIq1A
 gHippqmvpB1CC16FucD2+hckjbybeObuIuqg4FlEecf9ENkHDM8/f5e
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-22-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 22/44] KVM: selftests: Update framework to use KVM_SET_MEMORY_ATTRIBUTES2
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
X-Rspamd-Queue-Id: 059D640008
X-Stat-Signature: 1w3ifdpifntqqr5mcr3aig8or7zpryit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774563910-454354
X-HE-Meta: U2FsdGVkX195/cZBZ8cgJlgtYQD5/nWHN0iLMJRBd/WqZ0EnlU4l521RyDduPasFXnRPJRJUYVkVocSv8mS4Ew2sTpQk4lKqHW74PmFJjTLKYg+5JNHhNJvOEA7MCPhDfRXmIhD9nUg39rV13c1gU5qkJRGh5oCx3aA//JIq4qscvlmAJraI80f3MtCTlq0qK4iO+tPtrE5DMPIqDUoDuk/XzsgnUggRniZeRcKcJUrnuMW9+sHq97v5BNzDjVEbIu3LUhC627AAEMdwSrfUreYwm+MANRCkZhHv9S63rLmeWjFA6FqbN4JGvVisiq9YSMk45G9EM72bUiVR1QJyiFuTU12vCu8B9vObfASDc94Keg3BkDMxQsxcPhInbqGRhw5gXxtO0WRKywXajtng+pbGDrIC7kpAOhasoTuPBh+3s6wWqQ1RZWX7hpCEGbqAIG4vR/9okZexZkf27hgRlZwWnnPsb/UxKyImc30J1kEZrtkE7frNb7r2YYKBZN9XSPvshuj5FJWuTCjHe1OnvD/9M/yZHKW1x0UsyzWJ0Up9QFFbuNU00zsEYzo+s8QnxK8uW0RvGXFzJtP3H7j/T6iWIP0yozzTunUZfEday9FMUmnLLnx/UwCLCriL++qTzcTnZDoIf1wrpTDoe/3pKufkBn6D7I2Mtf/vPiowRjdV6ub2grFBpHkcKmAvP27f0PHiAXAvtJXUou8v8SK2bq3b7sj8Vyw5C1h6HefTnwjqi65jl0ZQz+Xqeai7lHKOWm6F9HxlNnbmi3HeNcLOxqa8NJ86Vxvwnwc0P7m6Sup9+1F7NmVSkDKGk9xdV0dAw3sOKDB8w8JUSlczGYAmZ3VDeJ0Zjse/cmfmHQ9zXcEx6usCj1Yg+an6miAUHC0NZgNz6oWe6z90prjlf4eXfDU6p3d+VJnZssv9byOopTmZf5JI+FdNAzJjYL/3lLv9mGQ61ALunWXOr7vf2cG
 3WAMhnow
 DEXOMwkIP7wkEuc2PY5lvf9i95rfj7T2CRUngKrRcnDL+ZXM9AGT69Giqcz0fDtAHM4VzQmt+rWptPSxzKHcVDeHKJCmwvDAzLe1myh58cc1e+JvzLc92MCc1CSRTVvz3WelKeyr+md3I3uXnndA73+De1hGpDIgB5Vp8KGapGPgoP4P73j3TxobmnSWAnJaUdo7dkTm12Z3KeF6I2S0ztbmpFEB+qUNmA8y4drJOue4qJv9n95gqWIojjXjC5AQq0w1d8dxypva+9roWsLoQkySinzIOsbN3qqiMsLQA6FbJ/7zMByjHs6IvXHM4oK8ek21RqvsIa3d2/mbJBPZ+QCeS5LZgj4i/CO47YQF6swwefs1uuPVP1o4coRIdoRyBCStbXdC28p+wpuhiDmt021jgrEscGjHLeoV6TE+Ai3rgMl8ruWXhFcLrJh+XlFD+jrJtoYDi34b32cPGCJWhvR6joJao94XyYf+lod1aABuLgZh7EC98YQO/xaJMAUtFpMbPD7M8fDvaLjQytuvA8Szb6PbRz0KYImAqa8n9jJxAFHFoMEcnEY5SPqoKX7MkB52z6RVph/d6VMtiOFyZep5FReLnUwHZJ03imf5GMd+3f51HbSp6gy7qSrEJE78s9fikUCiqnep88SLBcFVLu4eoEPxEmBGgVc7D3ppgDBlhBxGSHJWJQFApau6hytCyEL2E8dt8r0oNDo79KPEUxLEDQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update KVM selftest framework to use KVM_SET_MEMORY_ATTRIBUTES2 and the
accompanying struct kvm_memory_attributes2.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 4e06724cd2935..1e00bfa59dcd5 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -420,7 +420,7 @@ static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
 static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 					    uint64_t size, uint64_t attributes)
 {
-	struct kvm_memory_attributes attr = {
+	struct kvm_memory_attributes2 attr = {
 		.attributes = attributes,
 		.address = gpa,
 		.size = size,
@@ -428,13 +428,16 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 	};
 
 	/*
-	 * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows
+	 * KVM_SET_MEMORY_ATTRIBUTES2 overwrites _all_ attributes.  These flows
 	 * need significant enhancements to support multiple attributes.
 	 */
 	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
 		    "Update me to support multiple attributes!");
 
-	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
+	__TEST_REQUIRE(kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES2) > 0,
+		       "No valid attributes for VM fd ioctl!");
+
+	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
 }
 
 

-- 
2.53.0.1018.g2bb0e51243-goog


