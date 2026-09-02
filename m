Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 994E3C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D6D6B00AD; Wed,  2 Sep 2026 09:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945196B00B0; Wed,  2 Sep 2026 09:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833C86B00B2; Wed,  2 Sep 2026 09:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5706B00AD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:28:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D68C5C01F0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:28:31 +0000 (UTC)
X-FDA: 85168901622.08.7C95496
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 277CA20006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:28:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YUfwhx54;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7gwJtRN282x+tCWLvqdh4zA4VQZ73eNGEmZwXXg9AA=;
	b=fMqa4BLNGzW4YB/YFFq5eazJ0qgMzw6HFFURm1bpekGfAnNuLlEPA+EszN55KCGClQKndl
	S/S2tTtpcCW7IkerVWYmuSd/t7MiLd3sJgURupj835VIxq/fvLkFPsBj94pe9J0XldiK5U
	VFdfvFW+idP40iLtrQTdm0j+S0SN7Qk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355710;
	b=y4rJiTlzwzl14jv/Ev6Ebzud7oZoxVNgKmpRW9Klolyj7g/pvbl3lGejMjVJt+TgHYqCcn
	UQhoXOCni1WyAEh9XB314127P8e2ZalcTMgbohHIi/PcIt7p3bxx2PiVaJlflDfM0t/OZB
	JCbHaZliCV96fcDBNaeSwhdoN15CwkQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YUfwhx54;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABC06600D2;
	Wed,  2 Sep 2026 13:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561D11F00A3A;
	Wed,  2 Sep 2026 13:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355709;
	bh=X7gwJtRN282x+tCWLvqdh4zA4VQZ73eNGEmZwXXg9AA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YUfwhx54IjYX5Ey/zFGYqewmbqaoJ6TrjvfumzLMK7iM/U8sK5VpTQjpMxyy43ryX
	 /Eo9EnkVyXkXT3Cfs0aRWlwdwb6NH7i2iggVOj43ZbBP0tTOEFtK/jekD0iUqPuewc
	 5LyYZyPA6Fd5rPaE4BsbsB3/iQ8stZUSZ59iYXPVnmX/plkb/oh8k2rfcOPMbaC0Rw
	 YvKD9GFuWlQF8pfXXAmHutTk4HPoY33h17zj9T7cxrrkK49Xi0WqmoLn4o3Sg6Krti
	 2I0bshwofTUlzt1BUa94WoMO7+DG9xnVQ0VcLC4MaafqE/c8aDg46x3fzjZUPO4QJk
	 lLAsSO8Kj4F7A==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 02 Sep 2026 15:25:59 +0200
Subject: [PATCH v5 03/12] xarray: move xas_result() and xa_zero_to_null()
 to the header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-xarray-entry-send-v5-3-d18adae40708@kernel.org>
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
In-Reply-To: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2745; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=qh/kWsxpWtJTnMsjGDetI3+BPXuYwIehfqEkMzoAKOk=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQbKtU2TBroNoHBj4gHXVX9d4qVvUTe3v5l7
 WHLs1k9iNCJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkGwAKCRD6UCkIqsW9
 0AApEACtvY4bZttqTtKgG4ptRmCZeXOYE0MPktLb/8/ea9/SZRCy8yzPZlN3pzNq/EzI5dX0fYo
 31bJ9XOJas2xPibfFTAvrxYUOV1abZxiu2M1fagVBF//mZ3oEydoi696PMOgOjJNd+J0RGTNAHl
 pfCRn15HO0aJUaow6XnYWdJX6I0nG2oMbiF0fXHuc8jeBvPa7uS+RWBiAqQsALpl7vQQz09IlZa
 iiG1HMl7gJ2VxvlStC4oMiMU4xg1IBFOV76/BUYvTgVJwVEVERujj2++HCjQyE/iRzaonRMNaCD
 Ro5Lkc086QvEvuvj5J6qw8GIVH/9JL//owEXcMEY7FHxCbwhYBsUHIrSgjj0xhx2e7PFNQnpCW+
 zf3nxBzzqtT/loJ5o5F5QbU2GibP47awBVdfmzWGwD0qI2RlGypGddQLDCJzAuyoEAJO3v2adMd
 2WCzT3dkAK+eyjiL4xF+xTIBXhFg+/8mUU5tUFuN+17hOT6zQw0R2Az/lgpBt8ah94Mngh07WqI
 fVrLdESuNxxGVext+AjR5Rbgje9KdvdUeO5h7NjhOVjpsIEMbkVWvCdeOHC8SrEK37YfzLxHEyq
 yfhgBfNFwYC06b9faLttEBD1l7A9Y9mpYF5OjgE7v1W+FbcyPFek/4RAJ3hyK73pCWMhZ90sqo6
 QzzutF1hJTxulGQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 277CA20006
X-Stat-Signature: 4h8y517g4nt4n8inr8oydwg9hyc1jcpj
X-HE-Tag: 1788355709-899716
X-HE-Meta: U2FsdGVkX19xWx17A/EMVewXs9Wl/yJlEIDYXKJH8cdjOTx8n31fB8LW0zd865osjKDoUQMQFBUATCi/QHoURC72W7EmnZb85+isQsGJhqn2x8BVAt/XEnvnk4nV98PgNrd2bOl2l+HVpgKVMS3yikxADDk2eDoqY+eb1Fh9rrM86maa42aQqIB9hZ8rS2lsICbdXMiAGh4nvkrtqGhOAOhmENym1Hy7E1hQkgCwssB50yElAUkqI+nMjcMmN1Ej4secc+ncH0WoR3Zks9ELM1+eNT+oMQQa9pcMZd2VMWDZ3SRKqaxoGAl9aZxgtpPvtbZndkFG2/4kqiIC14a1jFYWr2txfgUWrMUCPYgoGRJ09Lvs56oLJrGyeBKO3+lV0eL25M2cUf2E6R8udpDGl0FcNkJSQpJy8h7NERUBI/y2WKZQ9g5AmUrVIQcXjwd/UN7sqIVSrOFQhCFALW+2VmwoFbpsXgBIH6QLIP8YiAsDlVPmxEDS+m+RQD1viF1HPP/HvTmYliA+jdouY8dRHvLUlD+ncTmu9EgmzP0bzSQpOoBSSSzGWM93MVbhHIYdkMCY7kJcNqMV0D59Q23G3GVGEU/Xh104LecZMJ+Y2OnIOYDF/xJ9dXwTGjhsI2N3OBHtZ4p1p6CyZSn2B/tdR0er1heC9rvt1x+aby7SFn1kWcvXQq8Iwt1a2Hk9YEEyxS5kpC9jnNt1xScRv8poMNqfPj4BqY7hqYn4cghgUdWqW7iNsF3PPObiOFYjOQXgnW/t3lPE3CJRvJvrQij4BhkeNRU3S0+x1hwmNnQGuw8+rmmGQrCGIOVmjYINHYg8nxSsa7znCEBubUzt21VfiXPyxLHVAfbPDcgHW9JiuG++0P4eyS13psR7PyoY7OpMbncKuKQZSjX2mxL+xU7IMWPW3ptR3Dft8AlYHtFD3g4T2C1S1pyLu7s0aXcijGR5MUOIBm8oliool/HHcJO
 Geh86cT2
 ASvoPhCJPPts5VBMDCZOQyX+9oUPCIgHyXoIIHlAxCCdx8sn9ZcQNK08ZFabtM/kEY8ab+B7zdwy101GDZZhqiFlmAWn0ERQksEppL8TtPGUVCZ2tPVmvF2uSRsyJowkqj2wXfLE7+iEPn1pmkjF9da8qHDErm7PhXckCB3jZH7GEqBhC+hxls4E+aDiwAz432GoTAxYMXAx81Y5/QP9AawHI8nNiR+VTdQRaXeDeMGg29taV1RdUQ87neMVWMsPE9QuR2rGHjuOrQW+RWj2jDnASJwufM9VmxwXF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The functions xas_result() and xa_zero_to_null() are static in
lib/xarray.c. Upcoming Rust XArray changes need to call them from
Rust helper functions. Move them to include/linux/xarray.h as static
inline functions, following the approach of commit 79ada2ae6615
("xarray: extract helper from __xa_{insert,cmpxchg}").

No functional change.

Suggested-by: Tamir Duberstein <tamird@kernel.org>
Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 include/linux/xarray.h | 26 ++++++++++++++++++++++++++
 lib/xarray.c           | 12 ------------
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index be850174e802e..db2520864aaa7 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -191,6 +191,17 @@ static inline bool xa_is_zero(const void *entry)
 	return unlikely(entry == XA_ZERO_ENTRY);
 }
 
+/**
+ * xa_zero_to_null() - Convert an internal zero entry into a NULL pointer.
+ * @entry: XArray entry.
+ *
+ * Return: %NULL if @entry is a zero entry, @entry otherwise.
+ */
+static inline void *xa_zero_to_null(void *entry)
+{
+	return xa_is_zero(entry) ? NULL : entry;
+}
+
 /**
  * xa_is_err() - Report whether an XArray operation returned an error
  * @entry: Result from calling an XArray function
@@ -1437,6 +1448,21 @@ static inline int xas_error(const struct xa_state *xas)
 	return xa_err(xas->xa_node);
 }
 
+/**
+ * xas_result() - Extract the result of an XArray operation.
+ * @xas: XArray operation state.
+ * @curr: Entry returned by the operation.
+ *
+ * Return: @curr if the operation succeeded, the error encoded in @xas
+ * otherwise.
+ */
+static inline void *xas_result(struct xa_state *xas, void *curr)
+{
+	if (xas_error(xas))
+		curr = xas->xa_node;
+	return curr;
+}
+
 /**
  * xas_set_err() - Note an error in the xa_state.
  * @xas: XArray operation state.
diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b4916540cf..cddb44f6b4ab2 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -437,11 +437,6 @@ static unsigned long max_index(void *entry)
 	return (XA_CHUNK_SIZE << xa_to_node(entry)->shift) - 1;
 }
 
-static inline void *xa_zero_to_null(void *entry)
-{
-	return xa_is_zero(entry) ? NULL : entry;
-}
-
 static void xas_shrink(struct xa_state *xas)
 {
 	struct xarray *xa = xas->xa;
@@ -1624,13 +1619,6 @@ void *xa_load(struct xarray *xa, unsigned long index)
 }
 EXPORT_SYMBOL(xa_load);
 
-static void *xas_result(struct xa_state *xas, void *curr)
-{
-	if (xas_error(xas))
-		curr = xas->xa_node;
-	return curr;
-}
-
 /**
  * __xa_erase() - Erase this entry from the XArray while locked.
  * @xa: XArray.

-- 
2.51.2



