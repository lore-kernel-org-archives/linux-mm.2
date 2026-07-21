Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02923C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22B46B0092; Tue, 21 Jul 2026 12:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA476B0093; Tue, 21 Jul 2026 12:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9381D6B0095; Tue, 21 Jul 2026 12:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 573276B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:23:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7BED1A01FB
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:23:50 +0000 (UTC)
X-FDA: 85013305020.10.6F2511F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 321D54000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:23:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKMTfTfZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XB4al3rOoBg4JSOO19Uh9eYt2qBCEAxlPfiPknctj/I=;
	b=dqpKNH/DjhfxyrQWpaqCvP4Y51RVE/q0UcB9Zm7IDrPlNwsVarx0DzO0icS08A711lkUqE
	wgdpv0Q4FbN8Mx3KDaipFXuUSjdLjvfNk3ese2OcixuyehJPv189P/4YjJeGceOP2Sm5cu
	iQaBsZHC38KUW5biE+uWCDogYEHuknw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKMTfTfZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651029;
	b=f5k7GdOEaEqnJZSiyoiTE6wFuZUhRrAXjBT8+KPVe+uQjufL/L84RwJRIcz/oHU/YsLVJR
	AtzUh44ZSLOtD3NAWxljft2kMeG/bHNxgxDCLhKrVY3mOPXomsoVlLSuWhu7ykdcaRiS9F
	bv7+BZxnJ8xHWxMnaZ9CUZeUo6YZMvE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1129601DE;
	Tue, 21 Jul 2026 16:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C571F00A3A;
	Tue, 21 Jul 2026 16:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651028;
	bh=XB4al3rOoBg4JSOO19Uh9eYt2qBCEAxlPfiPknctj/I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mKMTfTfZUJdKGwWB88q3MmHstD1zIbNqfuQyZ+BRaAhhajf7LR9JlLvHXO02AACeZ
	 FTlA0E0QLniF/9UduU1JcK1Zt/0PJvKV+ojBQKZCr+3D8Ut/wKtGHCRw5BkHT5EPSj
	 GQD7zZIHCIv9D7iMSQPw7l76zQxEOd5wMZ+hwVjw9NzgIyfjEJrr0pK3P8do0X2/YS
	 z3gNy8oRMf0+fn8Cqp1vwF8N5ezh4wRzEbz8gk/+aeM2Qdnu7V800g9/NYGbN1OOIj
	 Rwp6d5daE20K+Y5iJgr+4zLFeNl5BXFmfKqOxS7DGq5Y/CxU4aIDzlJE2qmeCE88N7
	 pQhTF9DI3MSNA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:24 +0300
Subject: [PATCH RFC 01/18] x86/mm/pat: Don't gate cpa_lock on
 debug_pagealloc_enabled()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-1-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org, 
 Dave Hansen <dave.hansen@intel.com>
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 321D54000D
X-Rspam-User: 
X-Stat-Signature: ncmy4qby6rno43kffi6ib8q8rgjw3pf3
X-HE-Tag: 1784651029-400251
X-HE-Meta: U2FsdGVkX181Gas9/CPd30MugeLwPuCy3lwR9M0rBMRo8di6sByznAkY09Uz7VxBJMMe7L+hnWugHqaCbb3HD/MzvdoBgrZMld9iNLOv1BUY3yPUHXb+g1QW6vxcXc+zMvLMafcbR4OH7eFqEOzCE7TSrYSCNnwTpFhakXZ4oku1CTDlb5/Qre6P0Itc8PctU78/ou5/7K4Tds3+UsgLFzHFz6Tn6+0meO/V+47b8Oc9p5pP3U5OZixNsZDe+wsw9X+anezXTNkNxyryKZOtWZxmdhh2FZm3t5/JeObUqaOcW8VX3vIO69y75wRUHrgtfMPDdHV8JjonMpZHyNSq62GXI/Vfq2G/inGpR493PRjaUZRzvyBT/tIb9doZzHZl7JlzAv90sG45b0NroJU2WOtIiraJCIefbqVZn+GtZC+TStExzRc3JMxw+3HlkRSvWlZqLBL9vjDrS+Vsn2DQX4+AnwLobO3kCVZq7HBgOOwLV/1wRyHnA+/2aKbxoILs50U3qDFdEWqQN4ji6xMuyVUO1l2XzANJoymg8/2jqxnXaZqzJMWBD1fVjAKHyXCebs7Zi4aKGycNJEK1ZUP2b1Skd5QSCd9vGPDIvejLOHcEVUATdpYaqdFLWLwo9xOKLqjf0IHnYLdjP3M3BQQfc99TlBwN4nJBILVF+hQKijk+AftvIvHyzOWbFdeK1IBgTudKUShlLDwsVf8GIfFAh9YugINFIHdT3QJSNPN0+CBZJ4J62UnLYHGjK9EgXzvFDQgY7Z7OF+KdXSNPZH3Pf3lUMmG8YD7vrjQ8GtwRmWmjb9HwERtCj4I0V79oZbBsoEll5kC3gOa+TBHmmT7VpWBC6Zk9kpqNlqoxur0rJ/P3tJCgPBQqepozzr+VC1WLRklVw0LJ0VkNrOwd+zMa6Dt4ydT9jTLTyBDCCaSNsXJvi4MqykV4BBtA9J7HU3hhj6e/vLmNPWAtqQdNjAZ
 EJ0vkzSw
 acnHlw8mez80wO+pmx6vzl13ZJMUkn5uIGSZ0ONHJtZ74tn0AF5UDHXz/42kDrT2AKpfWXWEJS8ucc9X4wl/wD0gHRIe9/JNFRVTvIB0dRlxiL2o1tjin7zEgv7oAIwwXGX/ILsutqd4ozkjtQafxyZ7g24HC2aB9Lka96zPMP0OsGHmmXkTnNeH51lC0S5bY+FVmLCiEMPKHLAxNhXkDatiyk6HDmPg9wb4MAjVfY1l1EBismSI1FXzWhXPQQI5ai9xw9JHTeVQ5zIQSX1BotxeTZhw+IvF76f0LPbvH+SVsnCEnlmQzNDBhlHVVbkBvLZK/7nqM5U1OmqM/Q1MNMW/HSFYk+ghRbkJw+7Vpgpn3515WRT2F08+/gIoGLxOCneWZRFSHJyuu14wovllwf7AXeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The splitting and merging of kernel page table mappings between small and
large is protected by cpa_lock. The merging is relatively new but the
splitting is ancient.

The splitting has a locking optimization: since DEBUG_PAGEALLOC forces all
mappings to 4k, there are no large pages to split. So the code that *might*
cause a split can just skip the locking (and a few other things).

This is entertaining, but it adds complexity and makes for weird locking
rules. Plus it's all for a debugging feature which makes the kernel super
slow in the first place. Optimizing something which is already super slow
and not used in production is not the best way to spend our complexity
budget.

Stop gating cpa_lock on debug_pagealloc_enabled() to simplify the code
and the locking rules.

[ dhansen: flesh out changelog ]

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://patch.msgid.link/20260715144519.934289-1-rppt@kernel.org
Link: https://lore.kernel.org/all/aab44f08-89f8-47fe-bee4-0ab6b25968c6@intel.com/
---
 arch/x86/mm/pat/set_memory.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..e8316f5ffa8a 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -62,10 +62,9 @@ enum cpa_warn {
 static const int cpa_warn_level = CPA_PROTECT;
 
 /*
- * Serialize cpa() (for !DEBUG_PAGEALLOC which uses large identity mappings)
- * using cpa_lock. So that we don't allow any other cpu, with stale large tlb
- * entries change the page attribute in parallel to some other cpu
- * splitting a large page entry along with changing the attribute.
+ * Serialize cpa() using cpa_lock so that we don't allow any other cpu, with
+ * stale large tlb entries, to change the page attribute in parallel to some
+ * other cpu splitting a large page entry along with changing the attribute.
  */
 static DEFINE_SPINLOCK(cpa_lock);
 
@@ -1235,11 +1234,9 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 {
 	struct ptdesc *ptdesc;
 
-	if (!debug_pagealloc_enabled())
-		spin_unlock(&cpa_lock);
+	spin_unlock(&cpa_lock);
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
-	if (!debug_pagealloc_enabled())
-		spin_lock(&cpa_lock);
+	spin_lock(&cpa_lock);
 	if (!ptdesc)
 		return -ENOMEM;
 
@@ -2023,11 +2020,9 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
 		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
-		if (!debug_pagealloc_enabled())
-			spin_lock(&cpa_lock);
+		spin_lock(&cpa_lock);
 		ret = __change_page_attr(cpa, primary);
-		if (!debug_pagealloc_enabled())
-			spin_unlock(&cpa_lock);
+		spin_unlock(&cpa_lock);
 		if (ret)
 			goto out;
 

-- 
2.53.0


