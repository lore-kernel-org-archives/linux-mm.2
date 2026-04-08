Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 336F410F9958
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 15:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725AD6B0005; Wed,  8 Apr 2026 11:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FCE66B0089; Wed,  8 Apr 2026 11:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A036B008A; Wed,  8 Apr 2026 11:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 586916B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:47:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D6D2B6411
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:47:42 +0000 (UTC)
X-FDA: 84635818764.26.3BDD55B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id 08BF240005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:47:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=UEQzZNC+
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775663260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g56auhKAY5j+dvmNG9CeuB28V6/CJ5EqcS41m0jUuFE=;
	b=abjHsRvYFc31W/IapW7bH/h0smDY0k4DF5tpp8COuY5fv8iJkeYzL3a+AyR4ZyyqpYJe5B
	Vqodr/jkN+qC1QPT+lQ+YBbyVSM9gkQesndB8/c7MoDO9xRwymGfXF2IFRohMeriiSBZLa
	F7xhQobX+Zlww3Mj/myDpcv6gf6xOkE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775663260; a=rsa-sha256;
	cv=none;
	b=Fn5cpw7a3BMeKWF/UPS/4oGj5ms/4+6RNLwEze8c+o4T6kCpptAenOeZlElZJk+NxLN+zw
	rWhEhiTTJCpdfGU+Yr7QXFLVfhePK5lubfDaASw1V4KQ4X7Ua2gYQpqXA/9b9XB2aELSU8
	pypJkUHwt5X3rgBPSCzw5o2hLpE6kRQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=UEQzZNC+;
	dmarc=none;
	spf=none (imf27.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=g56auhKAY5j+dvmNG9CeuB28V6/CJ5EqcS41m0jUuFE=; b=UEQzZNC+f7LrCH9J/cy5DtjfSM
	8092LqJ1MyKxSiue0T+1tZmMWlQvTOMbzlv8K+x3pPnNYOAlPUmDlFwoHDL1ccPsmyOp2NGrAQUZH
	u2sGsbmLYxH8ahlhkUeVF207qcX3fWNLbKWKeO0DUbXJhVH54IID0/NIx2CB0XTvJOIbU13CA+0Fx
	d2u98SjvgckTKKqW151JTDvlZ8R2urpx+DkEzhH77iNfO9rguHMWT1jbrWYf6aaJRlTI3gJro9Ns3
	gg8KuwAVWLdcVsvou1Ahm7sRYgeL+iVDeogo/DdArgk8+GGdYpkv8nfG8N7+9tcG6pDkK/fth7gf0
	WtxhX12A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAV7q-008Wdy-22;
	Wed, 08 Apr 2026 15:47:30 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 08 Apr 2026 08:47:00 -0700
Subject: [PATCH v2 1/2] mm: huge_memory: use sysfs_match_string() in
 defrag_store()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260408-thp_defrag-v2-1-bc544c1bde4e@debian.org>
References: <20260408-thp_defrag-v2-0-bc544c1bde4e@debian.org>
In-Reply-To: <20260408-thp_defrag-v2-0-bc544c1bde4e@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=4937; i=leitao@debian.org;
 h=from:subject:message-id; bh=/sCYxACzHeKOBBtKbTf0JYBh6CfVPvs9YQezkVa8oQE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp1niIWX4L/u4+a9VuF0VbZDMLGe4Jc6QrcS85Z
 NJRBgw8Y7KJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadZ4iAAKCRA1o5Of/Hh3
 bWyBD/9t7F391FzPemA6wI+p/T1F7yuIR/Frzv64pDqioDHGIAkFzQBcdEMOty8LAlNgOpioAHT
 AO4kjK+OBn2+jGezyf68sukbQuxCOioVuade3ueVws2wNn5JCz8itLc6p7AIEUaRduPpCLZSWnS
 dvMIYUqL1sZXUKNOZTckmRuRgMNSa01drx1bV6Xj3zf8l+f63jJnp8GMhLch1jSf1TBzDdLlmPy
 edbNel9XFzhA7b3fg3iwUtyjI7gOV7FaFdgBGkMTVOH+LTx8oUFVbhGnCEy+LVt9AOs0RjjwHpa
 Xo72K/0BRWtPeoQVmI69drU2tJOz59U7IPF4xtGFjQKHRL/0va5CZReh2oNA1FfEBwkpO9WDdGc
 aXcEpnDyF3vxygqx+3LuPtk0VQlc5s4Fas88NFW0Aw3LopG8+kqQVNF1RiCqp/HMwUrUM+OC7+4
 4rwfiWrPibc9k4zGF0IcRf5YDgO1BEu+xr5TRCQojStEF5EKmM+ZXTN2x56kI6AP4AjAUsbD1gr
 kd65zFRDxFkzzTmdTx5TsZ9MLhZQJdIIAw/5oIms2K4nk+gnc952rFyYA2fZmzkqqK4kTTQKs0X
 sQFmfLwbZ7z+lnRfQWobqP+LbxVOOKJK48lSlThZpP2+5Mb+OZx4V52cZCJFD0o/KxhbuNUhUK5
 RRQ5MsGsBkAuE5w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 08BF240005
X-Stat-Signature: tsiidzsbwiez9yhsxeg3gfcgix5w7tq3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775663259-928592
X-HE-Meta: U2FsdGVkX18QRjpsMAAjJHk8NL2t2wTm5o5RZ1W9wGluxmuXGnG21Vr/lFppQZaT1dV0YG7Yzplagx63WJXjEW03maiDQmtXw1pQ330CYCLEQZTLJEtjVbC8+iqGweHVSSwlNOrZwnX/HE9QacQYfjNmGpDJWTzw4GmEf9HGXySTi4/DwNiLcOox4ckBQG9Y4xy31i6x5rEpsJKEhDKZ2473dswJwP3l8KE4msUOp+bT3YT6Llj54SmjT15VKHr7jwpsgKYLkhcHLfVS2b1nVHgCvHRMsBqWM+romQ2a1+ldM3GUknhuesFZKlsstffku5C1/l9vbOIf8QJt9KmLkRv4bJK4Y7hKJUikniKllFTN3EB4l/sdfO5n7k9/KFLKK0XGGKn14QC6JjjjCCb9mJivjnVnz1pZJqDnxAHi0M5iS8FtPPryOT1eggERQp43Bqvr5Qo63VGHh5AGuFZWD7TaPcDkJhA9e2G3LXfYn7J8RTfbMHdKq9nhbnIYknXyHPR8GHIdEUM8qWgLnZUt5al5JRwvasSunKsV4ySI1Xc0rZvPWU/WXw58jdtqDbCHL+o+gGqcpux6J+oaI5NyAaJLDtm8sy+Z0KweqPflgcDS3QdabiXXyludKLp6IbiBT/r6mczCqPn+RnD7qzxpdM60XBLz+25jO6UhvnOwJ4LoYD7HEuHQtZVeMWSrOaLGD1ly0BdXlhHMmthtCtmDAYYMtaxMfDSJsV+hhZFzNou7+VYKneQ/CREm8E5hhTkiSlQW9YmNzJYGNzQpLigniCScBX68MLoO7V2KdHnFs42vHoupl+YaHxoQrHrqF4ewjtN3+W0Ph8UMRjFjd3mm42JXHswVpgMXhtkphmaRq7KHCDMHdsFsuAa25Ltv+g6QKOevOm0F6z76JWlorYWVaufRDvgLgPOMTJvLk8tX8OIRIRZivmaQVJfO/zjKrTi00gglHoMOWdYHNwSpy5X
 HIma9xW/
 BPs0LEgeKnEfQNlpYAnbR6SoJmut3/YCFNhdmaiD+Uy0FlVtm5sVt4/YxC7VQyMCj7ViV3+2+h9nF/cJI9NC8VwzmyxVoRRsQhs0E5fKe/H/2OTefo1f5ZWSXrMkU5YBD5UKwI/V9OiaRDz+oaxbjLZN77o+8wsBi7CNJdUyWAgvU2myUHgQA+Z+onY0FE2kHX0h/8VDrYqa8rhWIODsaW4vH7rG0Unsnh1el
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the if/else chain of sysfs_streq() calls in defrag_store()
with sysfs_match_string() and a defrag_mode_strings[] table.

Introduce enum defrag_mode and defrag_flags[] array mapping each mode
to its corresponding transparent_hugepage_flag. The store function now
loops over defrag_flags[], setting the bit for the selected mode and
clearing the others. When mode is DEFRAG_NEVER (index 4), no index
in the 4-element defrag_flags[] matches, so all flags are cleared.

Note that the enum ordering (always, defer, defer+madvise, madvise,
never) differs from the original if/else chain order in defrag_store()
(always, defer+madvise, defer, madvise, never). This is intentional to
match the display order used by defrag_show().

This is a follow-up cleanup to commit 522dfb4ba71f ("mm: huge_memory:
refactor anon_enabled_store() with change_anon_orders()") which applied
the same sysfs_match_string() pattern to anon_enabled_store().

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/huge_memory.c | 60 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b75..76f2d32428c7f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -429,6 +429,29 @@ ssize_t single_hugepage_flag_store(struct kobject *kobj,
 	return count;
 }
 
+enum defrag_mode {
+	DEFRAG_ALWAYS = 0,
+	DEFRAG_DEFER,
+	DEFRAG_DEFER_MADVISE,
+	DEFRAG_MADVISE,
+	DEFRAG_NEVER,
+};
+
+static const char * const defrag_mode_strings[] = {
+	[DEFRAG_ALWAYS]		= "always",
+	[DEFRAG_DEFER]		= "defer",
+	[DEFRAG_DEFER_MADVISE]	= "defer+madvise",
+	[DEFRAG_MADVISE]	= "madvise",
+	[DEFRAG_NEVER]		= "never",
+};
+
+static const enum transparent_hugepage_flag defrag_flags[] = {
+	[DEFRAG_ALWAYS]		= TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
+	[DEFRAG_DEFER]		= TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
+	[DEFRAG_DEFER_MADVISE]	= TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
+	[DEFRAG_MADVISE]	= TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
+};
+
 static ssize_t defrag_show(struct kobject *kobj,
 			   struct kobj_attribute *attr, char *buf)
 {
@@ -456,34 +479,19 @@ static ssize_t defrag_store(struct kobject *kobj,
 			    struct kobj_attribute *attr,
 			    const char *buf, size_t count)
 {
-	if (sysfs_streq(buf, "always")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "defer+madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "defer")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "never")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else
+	int mode, m;
+
+	mode = sysfs_match_string(defrag_mode_strings, buf);
+	if (mode < 0)
 		return -EINVAL;
 
+	for (m = 0; m < ARRAY_SIZE(defrag_flags); m++) {
+		if (m == mode)
+			set_bit(defrag_flags[m], &transparent_hugepage_flags);
+		else
+			clear_bit(defrag_flags[m], &transparent_hugepage_flags);
+	}
+
 	return count;
 }
 static struct kobj_attribute defrag_attr = __ATTR_RW(defrag);

-- 
2.52.0


