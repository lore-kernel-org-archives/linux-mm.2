Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87302C5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1176B00DB; Fri,  7 Aug 2026 17:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73506B00DD; Fri,  7 Aug 2026 17:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88196B00DE; Fri,  7 Aug 2026 17:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9125B6B00DB
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2FC44A0443
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:03 +0000 (UTC)
X-FDA: 85075824246.04.5CD6A11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 36680A000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRwBCpot;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139581;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCc1r9LFGMXBcC2eT49sEhtWavsfsAcbxjxR2VN5vIc=;
	b=AOaxn+rekdf97VcUa8xxf13BY95dmBr4CnO5M5KCzlEeBW0D6heZiBAUUWyzctA8pvMGOY
	aO7SPXfoJWrsFflEhtjwwEl0Eqi9CpaYitgfgsUVt6Ym13GIaXrpmcjd+W1rO7HHfvIm4o
	WBJDhTlpatCOqT+gL/7J4jmHCP11GNE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRwBCpot;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139581;
	b=NrTcJEZioLc3aNtP20XNVerrtv1Yz06DNb7Qa1YNDDhHSOLkq2yhyOqse/UXYlCxlb7JXD
	dIbvVIKMoB8rBrz0IuPb7HMLVozfFCvGjyCU8DIwxCtWp11LcAszx6GBMg6dWNteJmXQJy
	24FVHJNpTP4Ul5nFJDMCOkLY9o50vBc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B01B844096;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D2D5C2BCFA;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139570;
	bh=zMXMT+CDwoTrBMuFmmiwUiagBKEjr4ONLUkzSNsyvXY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IRwBCpotsMnRqE/t6vavV+M4sse+zzk7TBSXJwNTqlg1x94Vbeksur0htLnBjMrvM
	 1SwGLaiJ0o73mnoTwcgUEQaZQSv1y/EdT+2UWYvtm0i0D4KUR4XGYjNvTYBiJqrJaO
	 QoMoGIK3AySjaXRQL6LxeRjJM4RkCc2hyAMnq+sL9qq1lVEkSrU2S+ewYBLzUvH8YB
	 oXF1rnmjkAl9vzvwFCegc1hua66gfVuQPsSVHFIgUjN+DdorY5Dn60ffJ2vMBWkB2s
	 Yxt6yhXfo2cz/SKCdnfN3OtqMhkbIc0S593XUDwor3TSQyj4lyMSgCoFcoLw8k1x73
	 wroXB1cSBBYeA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7611CC5ACD3;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:07 -0700
Subject: [PATCH v10 28/41] KVM: selftests: Test conversion flow when
 INIT_SHARED
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-28-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=1820;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=LCMkQdX+H3WVboFtkpu0Izn3eeZarl7aVfYLiu9r/3g=;
 b=Lg18aCDxNaQup8NnlNTU3r1S8o1MRkDWstNEis+KSXSyH1OUBseYjRh3CJcj4zFmpEdW+XyOJ
 IxkFnrEGoYoAIKkN6uEs1bKZAjbgT73XPsOUXQEIVLnllJdawedKU53
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36680A000B
X-Stat-Signature: xg5pjw9bzhun71wizfoabosyeng7t4j4
X-HE-Tag: 1786139581-158527
X-HE-Meta: U2FsdGVkX1/R8b0l5dcFOy50BLbFqcF7eRCsFiQNxFAUFD7pvzpDvAnZvG9R2Vc77rYQdTyhhDLWALF5VQQB9uFs+4wJlDOea3WzUorc7JILVqqMbdeikpgnMzJjamc/PsH5jGBRUB6o2gdx8JfrqrdvXH9jm67jkHDFy+1FfJhXQmPiuz3S5AjUTrXxgecKVpbrJqMcZuJNWlGXYVXbiOVgpeiG6BBLGJCfHWAhpxSSjBV8J3n7AvZPN1HQ0G0nBA54a1l1/P41D+K4I/u3vqi93OaC13GHVLZwN3tdYZ1FQode648QG6ZJaq5AIHowINXPcfCdoH90JN9ofFDVbJ02XlUSL8AmFHCyeEjFXulOlP5oBXYVv1f74ojv5aKRlXRWEc5yIWQvlI6wH1EivHFFZRegU/DN8t13MT+32/Wq/vVWpUwdXZjR1fivDTZB5tBs0E4Xb72vQ1/9+4vUqaRiMm+jALWMVGyODzS6AnGED+HeuwOjT7hreZAQeeSHJ01MmZ1LYhEM13p/dVlKmAevXsKyui7aSK+0wiRyNkGVtWVU0wY1R8kR6XEa/qG0emyhJUPp6c4zWN60tehJBXvNQmbBp2tw/c9gHEv7cDuMR1bZ3z+z6GkpNQjNIlDnYB05zeRbxp+ryFXnl36sgmC+87jFGBOfLaw0yhdoIPMMqu9aUrAFfXwIaOSnDqir4GeepTyuoJSG7Wut3PG/U/n5P+M01FbJS+A8Nef+/N0riesz8WLS8BmmMoDQbvOPAa7XptSWd8J8/B284+ZZSHy/Tfk8oZ14Q9LnuH/umvA87VYzXf8Pf7hfLBFR88oS30VZE5WoTxhGaBHBtrSS5Ci/VKgHnp5n9FtGXsJA0guQ8Vt0Wh+QJhyDNf/ax7hSRMRKYhd/I8QLTFVwIVxaPw309q6JSRuNFdNA8kP/9Zm+FsQqUpquwr9ZY7BIm75KbvyszH40JQapzRcmrlp
 b4YNPOb4
 f0fNyZzC6g2BZu3Y8YjOXwspARsRdgfiCIX7mobJ7W7+Wc7cJusVeZT6bS4zklOmmHeuJv/6hFBSG7h6TVmICUhPVXsUGmCQVEnBRNaslmfUpacOXEva/4Ud4EW+G76l9IKxjA6jf43sbSlQI0gyUubMPD+Av30hpi+t3e6eUi17cichtWeyNTP+MqTZUBhjj3bA8HgbkrUoq/PbdG8caycWzxCobcNJDmLzoJs4v7Nf6UgmgBIszMupupmZq+lQxJpcABUKbVLhjdAiumlWPu7Go8Kb6zeWxBnlLzlNcGFSbKS5Z8DXQMwk7L24JCSEyGTk3Ul70qpOqZJK680zOffyUhgGy650l/MVwJYgFFuhBQd44NXiO5VplIGEyyG3lyXaHIhTJOf4g1GMqQz1koMCFu+ExXhnoUT+sfK/s3Uuuxxz0eEAhS9RED88hG9snuQye2X009K/9P28r6W+Dz1xElqhksi9gwERl9HceWr+w4w6vch9phqpr0afJINqrijlIXh76SVna8F9Hivpg9Tj/1qT8UaoQR1uPjeog/XC6BG4H4aRhD4gvrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a test case to verify that conversions between private and shared
memory work correctly when the memory is initially created as shared.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c        | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 77f95d49349ce..4c20d3d8e9349 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -97,6 +97,12 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
 #define GMEM_CONVERSION_TEST_INIT_PRIVATE(test)					\
 	__GMEM_CONVERSION_TEST_INIT_PRIVATE(test, 1)
 
+#define __GMEM_CONVERSION_TEST_INIT_SHARED(test, __nr_pages)			\
+	GMEM_CONVERSION_TEST(test, __nr_pages, GUEST_MEMFD_FLAG_INIT_SHARED)
+
+#define GMEM_CONVERSION_TEST_INIT_SHARED(test)					\
+	__GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -188,6 +194,13 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
 	test_convert_to_private(t, 0, 'C', 'E');
 }
 
+GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
+{
+	test_shared(t, 0, 0, 'A', 'B');
+	test_convert_to_private(t, 0, 'B', 'C');
+	test_convert_to_shared(t, 0, 'C', 'D', 'E');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.55.0.654.g21b8a5bc05-goog



