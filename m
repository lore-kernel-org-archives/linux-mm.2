Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB28EB28FE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83926B009D; Fri,  6 Feb 2026 04:58:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A346B009E; Fri,  6 Feb 2026 04:58:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05E06B009F; Fri,  6 Feb 2026 04:58:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3FB6B009D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:58:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AA581C74F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:58:05 +0000 (UTC)
X-FDA: 84413580930.03.CC2CB44
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id CB87AC000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:58:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770371883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOfi+/TUnFYJoYH2UD0vWDTQp194y8zoB5ghAq67F/Q=;
	b=aAOEzR1b9dMJOy+AENu4JrtJfhr0vvPUUyWU5E5l5oN0o5XOmQ20+vkZbUBWcM8DGKWIii
	tzBZ/X7Y5T0C32jvGHZjvuhVmB6pV+PuqE+4JCk1W2QAJ4mNPQ/HqQqFsD2AXfzcDuD2wf
	x4fR3yfCCQ8x5OFBgSFdhXmvQZWo5xk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770371883; a=rsa-sha256;
	cv=none;
	b=b0rerttHP2paLn6Er8wTZxjLKf3IBMAdRjBgjqgVGUe6/oj0taQd/IlJI33Rwfx8AJciIT
	KzvPXHOPxd0cXs1qoovhBXUHC3Ui/OK67ucvPKg5OipSdQToLH1o3q2bKIaqsJ84jif6am
	ttAGVKp40+qTwYo7NzQCzxEf3N1i3lQ=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4f6qK35vYlz5B1K3;
	Fri, 06 Feb 2026 17:57:59 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 6169vg3f001817;
	Fri, 6 Feb 2026 17:57:42 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Feb 2026 17:57:45 +0800 (CST)
X-Zmail-TransId: 2afa6985bb19e39-1d165
X-Mailer: Zmail v1.0
Message-ID: <20260206175745201sbMJ9Ru8QZsjAo7YMopKS@zte.com.cn>
In-Reply-To: <20260206175609696_A7uH3a1F7VmQN-iTzjC3@zte.com.cn>
References: 20260206175609696_A7uH3a1F7VmQN-iTzjC3@zte.com.cn
Date: Fri, 6 Feb 2026 17:57:45 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <david@kernel.org>, <akpm@linux-foundation.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyIDEvMl0ga3NtOiBJbml0aWFsaXplIHRoZSBhZGRyIG9ubHkgb25jZSBpbiBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6169vg3f001817
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Fri, 06 Feb 2026 17:57:59 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6985BB27.002/4f6qK35vYlz5B1K3
X-Stat-Signature: cfnezqkqszyois6m5ukcjd8i9hs5xyws
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CB87AC000E
X-HE-Tag: 1770371882-17058
X-HE-Meta: U2FsdGVkX18NF7G0Mx1tVXIIMq/EzPYp/R4N0adx1j8FrFEf+arpJBylp5T24rh3jkPB/tIioNf6nZBBQZ7jQGHFDCHS0NnUBWJdc7As6Y10Ad9bI0LTARU2jsLITKvcynKsidzz0kWJ4D60cm4SJSavxlrfvLbXBsOZ92FPy82TiQD6fIF/tV1pEHmslcug9Ur327e5Fc56tvrb+WsMTmyjNDYmAGr3X1aRf385qU7MNGRD+iI9Wxal/z6BtqIxY4wwAdnwhKr4Hef02x015lqp/SPhRqbnE8TNvalG2UzjHJBAau2NlBpvJ1e88A9Jd7jrV/MTDJ8AUvCWbU/yGSnEnKc42DblB3/7RV8CVDveeJXCc5WaYGGmCpjXBT1dTGfs9qfD04JMX7fSR6Lsjdu5fp4IOs72jEJeEJEIfw2woAwOLpQULcUrCL0vEMGrwPovjdM7ufRcAxZwS9DLPWBrwuJCrkUKVljAlIMAYV0Ft0J8FGNLdpFbCKE4T7gHa3JUik1EBnA6081pXi2pmXJXJV0IqS5NspNJ6JQaoXRhvouXy2Ab0TAeAj4a1ntv20UgCLK3fIqlL7bU/RUkOUigK4ReTVK2E/AaEJr2bqka0OFDC8SJaGwFn3C7TGWktFHLC529m3Kn8lRGN2c5twnzUjfa6qN/OZ9p8dD91Z5UmfJDICVwux7YZPHi0ZuFG3U05iatVdJuRA7LBHWVKXa3IjuqiuRLgMrh7zZ2vDyWcamvcR6kOlSDHTOv2vfKh6QPhdCJm4WAqztD3R+RrSHprUrzeQiI+tyx1qlxqorgNnL9JD4GrdGmfX1qebqu1Xrq0Jzt2eHuT5MkIznZU/EFj7jwARdN0esu14IoAJy2c6AllyeIxj2iV+AZVzIEUsQwz9y32q/HFhDgHOtbcZOpOgjf+ywvFkNIm/bpf1BHMN2H/fOUlnQjBzWFTjOQSCg6FDJ+IsGm5lk/3EH
 zVb+cIdc
 KQWN0ObbkubF7P4oEY0LAKcSnkxz1kjrdakGY8rsJ4GMf46aPVLan6SQhaD7l+qbSPf4wuu1/oDh8Woos/dfBT6yO3ITz0WU+S2LEqn9Ds91NvwTJLM9IV7hddxHYZ9hsKyVh06urNHQ9AN3v3xm7fypbLFhTLWt6stQ5KXNPj42xYhKNdOBaei9Ak9ljBGraR3Mv5ofJtt0DtZ5h3jkh1kBrcaAmAmNS6yM9tfmBX5y5hhyVBSVMl8migORjXRQHJ3XP0BpfKSswXV4Ajjo4T+ZfjvAXr+r1X3gOLhmAhdJSuro=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

This is a minor performance optimization, especially when there are many
for-loop iterations, because the addr variable doesn’t change across
iterations.

Therefore, it only needs to be initialized once before the loop.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 2d89a7c8b4eb..950e122bcbf4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3168,6 +3168,8 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		return;
 again:
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
+		/* Ignore the stable/unstable/sqnr flags */
+		const unsigned long addr = rmap_item->address & PAGE_MASK;
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
@@ -3180,16 +3182,13 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			}
 			anon_vma_lock_read(anon_vma);
 		}
+
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       0, ULONG_MAX) {
-			unsigned long addr;

 			cond_resched();
 			vma = vmac->vma;

-			/* Ignore the stable/unstable/sqnr flags */
-			addr = rmap_item->address & PAGE_MASK;
-
 			if (addr < vma->vm_start || addr >= vma->vm_end)
 				continue;
 			/*
-- 
2.25.1

