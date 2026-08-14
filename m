Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B35DFC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0D76B0729; Fri, 14 Aug 2026 19:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92526B072B; Fri, 14 Aug 2026 19:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF4F6B072C; Fri, 14 Aug 2026 19:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D70A6B0729
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:52:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05354A02CA
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:32 +0000 (UTC)
X-FDA: 85101526944.05.59E1C09
Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	by imf12.hostedemail.com (Postfix) with ESMTP id 03CC540004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXV7KOmz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786751550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+99t1LBPWwoGXwe+1R1sUgaiMoADZSJjatmbR2Xr3YY=;
	b=NOVNzY7edG1of7Wv0AUj1aNYab9IccRkUeTDHRqMRBFl3cbB85Wp17ecIT73jVHe/L8XUP
	fcVatdG5znxVHuUlGuo1eKOdwhGoAEPj90vjLN7U9/e7M5F/aoD87l9j3WbLdOLCI8CdS2
	WDZXyxppYKA8RWZEHGNSjY83wQ4BE6o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXV7KOmz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786751550;
	b=FqKFfH7V1KsM8ctFHY9R+PoOm6omiMFQF3ePNbai6ZeIX10HO32EtffNmQE0TSpGHjLUg3
	ibAu2loClktCgkxrxjs0e4lEvouE4mPzuVOJ94n3FN7tpLieXzb8SvCXxh4UFGbB3qn72o
	rGXV5xeAYVviumK1fkHQS3cs+DALQcg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3SbJTWKQRPJhm3xT71jRLeUekhnVMPArD1wBhzIMjeA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786751548; v=1; x=1787356348;
 b=lXV7KOmzqR8iGl6VoV5rXX+OFnis7m4KHdy+5IWTA86+ds9jZWZ6CUWjcz/mn/sN3AffirvW
 OwUszsqFGuOTT2g8RbkhiAGahro2O1LmQyfjdJsvVTPB+CVvBX2Chfo1JTfaEhgfNtu5SyEKC9b
 fXkG8B6whRtYKo2wHkNc5rEk=
X-Envelope-To: linux-mm@kvack.org
Received: from isolodrai-fedora-MJ0FVMD1.thefacebook.com (2620:10d:c090:500::4:b8fe)
	by mta10.migadu.com with ESMTPS id 781dcae87522a580;
	Fri, 14 Aug 2026 23:52:28 +0000
X-Migadu-Flow: FLOW_OUT
From: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	bpf@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 2/5] x86/cpu: Initialize boot CPU cpuinfo defaults early
Date: Fri, 14 Aug 2026 16:51:31 -0700
Message-ID: <20260814235134.3461435-3-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
References: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03CC540004
X-Stat-Signature: wpdqm4t3exb6uwhkfz1yfnrjrp76zqcm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786751549-861771
X-HE-Meta: U2FsdGVkX19ifBNv8zhN0RZpDXDmBFKtoWlfdZDar2oC5kf/A03SThuawA9Ua8ZhN/h3iYar9L6YI9c1C2/nmB3fOtYX8PUIpgia08j2iTpBHXNvBEhYslXmqP1TDNYCJQkmtz6PCkyaPG7JiOATFajWwRECLHs3lDbWJe+5E0wTnL4Gq2o6AcOAPX+cXcNa0bU3vaYq6vI4wjsTGK9zTFxstKWcaTyloy1VUU8QBX+2u1pVU82Rfj+HHdHmllXUL9uGaWxSsTEsLuaDf0hDcNdkCK3LxosqYyKbaJdgEwgTvxHhPB1IJ2zq5ZqVB/p/Cx6jWlELa1yGxHHv1YL8NYcGFedQL4AsFQETuQeGMYxrNaXP6qOGiuRo05AG00MFcML3rXyWrjtxYDykjP0SMuHCKNLgEZ3JJPKRqeA4byI0mL7eWk+TUHk1InzrwCADjUD/SxilXYUOd9iM+qENE6vTmsVUd+AGa5i9R66xIqbXRbEc5NbcQizKCOCx7ligU7+mgJHqsuf+0i14SKVavaH1W0rK6m7b5HifiLXEuki2cZ4IHtNTqL/P1laDN1eLoSiPcOC6pZpCHVxGaXgz9kmyTyoAHjCe5bmP/zZ6ANInVDIMQg7l5E4g4BXAg967CZO/xPZc2cVRd8sXOEVs7olU77PQbIeKnKPvNsU67UjQH4pv//MrhFCMufd2F8nUTEbr8eTmx58U3YgmcfmNrRexPvTo8utLElPNQnXiZLY9tpchSqVFxxgP2viceRqmgXDEReCLusYTiySa7W1qTvte64yTEi6zK0wtbIH17DzkY+kSXTUtVPOk1hdIktZ3hlJ1NNriB/tBSXA3EG1ldnE2BoafUIA98tuDYVCzk5y483wP6sFZFlgebKAyUqrh3ljj6cvC9dXYGe8Lh7LmCqpmok/LHJ9Icm6q6GraTmt/9rJ8FaSht1d1c/ldu0tc5tnV6yvxeIMDNrnjHht
 OsdTmVoG
 MhrAT+qxY3GL+UYRzl0yTyP8oyl8OEJFAwFxKNd0j0IHKSw4dou2pFP6+Lsi9HySjg6xuDBNZen/zp5FQoM5SD5ozva+6X1Ff64aPZPNPzctTKv460a7V50hTdpSGX5oPmRrARB41GxvrviXKk4mgCFXZYCAO4o12RsCmij3uWkWimH04yRbXX1Uv2LaGdfQfa1pqQT/QXMyntdKPj6X1/C7TOXyVGeLR+uwMBfppHj7p7LJYMhDtFK5k+iAYypvADrzQcf+c+CXGwAJfzOuYHMrT2wq9SHbC3jtpZFUkKw4QMOO9gPPmPwwGyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

early_identify_cpu() clears the capability array, the CPUID table and
extended_cpuid_level, but the architectural defaults for the rest of
struct cpuinfo_x86 are set only later, in identify_cpu().

On x86_64 x86_clflush_size defaults to 64. Until that default is
applied it reads as zero, which get_cpu_address_sizes() interprets as
"not enumerated" and replaces with 32. So on a CPU which does not
enumerate CLFLUSH the boot CPU runs with an x86_clflush_size and an
x86_cache_alignment of 32 until identify_cpu() resets them to 64.

Use the same defaults from the start, so that the boot CPU does not
depend on a later reset to end up with the right ones.

The values the boot CPU ends up with do not change. Early users of
cache_line_size() on a CPU which does not enumerate CLFLUSH now see the
architectural 64 instead of the 32 fallback, which is what they should
have been seeing all along.

This change comes before the last patch because that one removes the
reset: without the defaults established here the boot CPU would be
left at 32 instead of 64 on an x86_64 CPU which does not enumerate
CLFLUSH.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index bb4525523222..f43584c8aeab 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1802,16 +1802,15 @@ static void init_cpu_info(struct cpuinfo_x86 *c)
  * Do minimum CPU detection early.
  * Fields really needed: vendor, cpuid_level, family, model, mask,
  * cache alignment.
- * The others are not touched to avoid unwanted side effects.
+ * The others are reset to their defaults here and only filled in later,
+ * by identify_cpu().
  *
  * WARNING: this function is only called on the boot CPU.  Don't add code
  * here that is supposed to run on all CPUs.
  */
 static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 {
-	memset(&c->x86_capability, 0, sizeof(c->x86_capability));
-	memset(&c->cpuid, 0, sizeof(c->cpuid));
-	c->extended_cpuid_level = 0;
+	init_cpu_info(c);
 
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
-- 
2.55.0


