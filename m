Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBFF0606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=gentwo.org header.i=@gentwo.org header.a=rsa-sha256 header.s=default header.b=XQwVCcDl
Received: by kanga.kvack.org (Postfix)
	id 4B9426B0A8D; Thu, 22 Oct 2026 19:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4444C6B0A8E; Thu, 22 Oct 2026 19:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3130D6B0A8F; Thu, 22 Oct 2026 19:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2B796B0A8D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:35:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51A5D140329
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:35:40 +0000 (UTC)
X-FDA: 85351871640.28.DDB5E54
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7512B80002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:35:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=XQwVCcDl;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf02.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792712138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3rZsUW/t975keV+PsdM/QVuwN5VmNIdhd9sOD/k3Cj0=;
	b=Y3hSSiUKbsb2CgqNk/2FWln+SVuUEM11jZKbi4ZbSG8Eq5EhZmnJketA0GaQQ9IB+pRN4y
	2lzZIuhrB44P91upbKl3ruSszZARRfHV+yiSFl35tOdCVV5NspHKwU2+fGwTqqXQBFQPb6
	pHpV2C9DM5LTy4cREEG18lPYhiMOQrU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=XQwVCcDl;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf02.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792712138;
	b=C7Av5F/j3ao/toI1euCRRfImn19vULDieciVat0eXAXYCqy2epNUlzUzzDNf+5k+IJ8fh3
	9S80Y391V4MUFKxgScUt5Ap4WYy81fnJmnP5u2wUoQG9kkF3A5JNI48nJdDottCG5YL5Qe
	r+M8O+fE/FDHyO21IoGo4iqMGN5A6bg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1792712137;
	bh=jrV/IxGbHVYF0qqZq6DY+V5oozOvXQzLj5lILV5c1M0=;
	h=From:Date:Subject:To:Cc:From;
	b=XQwVCcDlayyAlX12D34bUwhCL1c4UIM9owFW6qpIPS6aEA5SEkQNQkSCJRTsRklBm
	 PWp0DQ1gA/nqITNhcu3UIjr+Lzoqty64flwOC6PWinFX6mYF7MoRt2bGk+kM7fPVbp
	 MDYiYj4k0cbuOvbuscE4as2KOXJ5chhHjy7Ts8xg=
Received: from sut02sys-r112.scc-lab.amperecomputing.com (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTPS id 1B98C401A2;
	Thu, 22 Oct 2026 16:35:37 -0700 (PDT)
From: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Date: Thu, 22 Oct 2026 16:35:20 -0700
Subject: [PATCH] mm/vmalloc: reject overflowing vm_map_ram page counts
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org>
X-B4-Tracking: v=1; b=H4sIALed2moC/x3MQQqDMBBG4avIrDugI3HRq0gXIf2jU6IpkxIL4
 t0buvwW751UYIpC9+4kQ9WieW8Ybh2F1e8LWJ/NJL1MQy/CdfMp5cCGF8KHc4XFlA+GGyU4N8U
 xemr12xD1+z/Pj+v6Ae6MR+ppAAAA
X-Change-ID: 20261022-vmalloc-reject-overflow-e532c556f3fa
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, 
 Shubhang Kaushik <shubhang@os.amperecomputing.com>, 
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792712137; l=1615;
 i=sh@gentwo.org; s=20251010; h=from:subject:message-id;
 bh=jrV/IxGbHVYF0qqZq6DY+V5oozOvXQzLj5lILV5c1M0=;
 b=SzBwHj++h+fkwY+1kXehypo54pxgSUEaigbNFY/5izvxXwfy7xCiw3YV+kcCPzHA/7Eb9UNpN
 bJc+xN+7lD/Au/hr0EX0htn+tSU2rNB/LA7E90yob+38UbTliKjJilk
X-Developer-Key: i=sh@gentwo.org; a=ed25519;
 pk=jc8YIRvxPSyJaBRe5y+a4N0RXKBUEcAh8+OFhlROXPY=
X-Rspamd-Queue-Id: 7512B80002
X-Stat-Signature: xksx9rhb1z4419tz57zpno1irb64cyyf
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792712138-632005
X-HE-Meta: U2FsdGVkX1/C/wobFUG7hfzhyfpWazlRq47GIaJglqA4ixfWIo+X9rqFwc91/bJlKCrsoy30ygcipvsIkQoSAwX+r2R+CeahNoW4NR9u8m/f5Vl4lEDL7zCCQyUFZF39HgehpM/4rVZzJQUr+5jZsMi5TUfxgsZ0QpVZCOiW7cwE5SkRGX8vveHgxJXyaqgICEAOtge1bTyzAfRQb8NglBJGOlsCoywgKyJERAgBi6J0RjmPFIpTeMWecU4mQ/qt6IEmmPok6fnHx5zXz9gI0oaGQmxGq5AyxcS803hkJWEU7bel2jqCo/V2DiUiIoofd+NlujDPD2khSReqgDtE5uAMPvTpR9r3yLXtTxm+Md8EzyETKJTqUr5Qjn/vtdGo2E0/roBL97wC3XE5DaPg5mJeLyF09ePBSqtvtbGZ8bwf38IrWIhbF5cCEziTCBXMToI+0lAKtu0sR7t+sNDRNAaF7qrjHNWDs9y9lOdJ+p4DLSpWFGWI+gsfndgCIcj/y8e0si07ScGjkhhgLKT32fp8lObWBgDMIOy6uszUWM3OTlN6zcm7EDlzYkokoaFyZ/DY4jSdVCvo6OtH3odG9YoZZbxk84BDYb/dleYmJ8fjiqO+BoU/PdRr18u0EGDoZcvyPDyJs9Ja0CItweNzhLYhrfq5AXT2EtuCxkc79XK+o5Sx78viVbrAn/TuEDTQ2tV8sNh1T6Z0ySXhDZlraXo5TETFkydMdReZe5yorApE26oM7GykRQLdhkzCRyU01+sRBddrrDWu3j0i8JVol9DEZnc45lLWs2HOfk5nQhHQvUWPquGK5LEivge3KM2tIt3XhSs+NyFXFibQ32WvYk3Mf5t8VXs3AdQdW18iBmtthEeM/ZbTP84szQlAbJhbgmKqiMr54yj+Mi1ey/hQdwtcEATubCxq/NlfDepUb3o5qHnjCPvUpsjDjxTkcBnAflW3RPfUICZbS0yM7b0
 pVT1V6e3
 GY8bu2Y3U2KetxQ1LHIKa94D2iOgHw9RdZ3T9ZHAtUEIu0dIwg1Azi4vVYPKYeM7H6WIBIqoSZTLx4Fb9AnM63cXClBCgaILbUZo1oPjyBTsPS2+CHmd+c9ieXVulJYPC+ds7gvDAsIjrggnM1u/whRf0kUxuNffMLlF2Tu01G0EE57ZvsIW0EqPkSH/GmfYYCp2wiHnyIbx73wi1p6+QCYoWb/gSvT/NgWVPoadcZ+Siu7bF/3R/B2fcsahjDt7xkz2CYs1Lea88D+NXJxw5SOzgFmIVJKDlJ4gqTH+KlxBXHYo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vm_map_ram() converts its unsigned int page count to an unsigned long
byte size without checking for overflow.

On 32-bit kernels, a count greater than ULONG_MAX >> PAGE_SHIFT wraps
the byte size.  vm_map_ram() passes that size to both alloc_vmap_area()
and vmap_pages_range(), so it can allocate and map only the wrapped
number of pages while returning success for the original larger request.

For example, with 4 KiB pages, a count of 1048577 produces a
PAGE_SIZE byte size after wrapping, allowing a one-page mapping.

Reject page counts whose byte size cannot be represented.

Fixes: db64fe02258f ("mm: rewrite vmap layer")
Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
---
 mm/vmalloc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e74247d4ce919250c2f02dd5c36483..e98d3aa551fe205ebd9826daad9ad6bd578b91ea 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3083,10 +3083,15 @@ EXPORT_SYMBOL(vm_unmap_ram);
  */
 void *vm_map_ram(struct page **pages, unsigned int count, int node)
 {
-	unsigned long size = (unsigned long)count << PAGE_SHIFT;
+	unsigned long size;
 	unsigned long addr;
 	void *mem;
 
+	if (count > ULONG_MAX >> PAGE_SHIFT)
+		return NULL;
+
+	size = (unsigned long)count << PAGE_SHIFT;
+
 	if (likely(count <= VMAP_MAX_ALLOC)) {
 		mem = vb_alloc(size, GFP_KERNEL);
 		if (IS_ERR(mem))

---
base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614
change-id: 20261022-vmalloc-reject-overflow-e532c556f3fa

Best regards,
-- 
Shubhang Kaushik (Ampere) <sh@gentwo.org>


