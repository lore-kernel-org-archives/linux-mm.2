Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C9760A262A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ij+IgiF7
Received: by kanga.kvack.org (Postfix)
	id 8B9E26B05B6; Fri, 20 Nov 2026 08:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A826B05B7; Fri, 20 Nov 2026 08:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7FF6B05B8; Fri, 20 Nov 2026 08:11:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 52BDB6B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:11:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2247120EBB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:26 +0000 (UTC)
X-FDA: 85455533772.15.8BDE054
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 10D0812000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ij+IgiF7;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180285;
	b=YdA8NUXoIdQjQcSe1z54PU2O1TzYT09jrMQgay2d7n+EWx9TzbsEkV2QyI5iuwhCNDBcCp
	MSDJsTdTmdidcK2Y/7JqtqBrcmw+6oQ6h/edMakfKl3rAGk6GXaPYIggh2kcKEj1zdojaF
	rXebhZk9iPaF3Xuq0sCZESpx8K/cxIU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/+gZzyL81rIhTfQl485EM05rto2HhCWsUis8cJpLtM=;
	b=k2jK0+CQvFsRpFckR556ciyN8K+zt5VuNqCUnh4v7ks/ICDqUg3klu4Up2RiwSPWa8Ms6e
	Sek0wzoXB8MEpw1k/ryKBZ69bdgGNHbd3Vsxq1yYdxEmALw1V3heP+kcXzEgTKL9KFMEKy
	rt2y0tEdIKcu5vZHueOzTV6dpkvYrVE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ij+IgiF7;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52E8B46A42;
	Fri, 20 Nov 2026 13:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C841F01566;
	Fri, 20 Nov 2026 13:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180284;
	bh=A/+gZzyL81rIhTfQl485EM05rto2HhCWsUis8cJpLtM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ij+IgiF7PHYNpwNc92yJuJt87XUOL/CmbXVr5DjpF9qJfdOVNVAlXaBuIWkpx3sPX
	 PHaUng495YTQN+wIQceCjtMVbfAUougzkdJRflY41SyKb4jdZQlwU0Yt3+D8j0gWiz
	 +c/zpihzO+pwvgK9nWb9Qi+07x5lfGke2DpOjSVIED5jqp9MsVkgcQQ0n3HR2ZkyMB
	 hu55iMX3BHiJw/Se/bg8pO96BnQixbBqiTgZDjFwBOGaCBExO4t/hQb4WVBCuA80ai
	 +ewmynKEeussF/o/Wbyy0zvaIaieFopK3HoEwkEXGHzdO9hSP3ArHVLwfsWRW3gFGP
	 YrLYfNL9dX11Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 14:10:14 +0100
Subject: [PATCH v6 03/12] xarray: move xas_result() and xa_zero_to_null()
 to the header
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-xarray-entry-send-v6-3-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
In-Reply-To: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2723; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=ca+4WUJBKKfPYSZI2hkWUZre4cjwUXs8x7GoxKkJ+V0=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrAEbFnFw9rCz1Jelb3iakHInaQsNRR8kKr+7GN
 w8gpl0GTkCJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawBGxQAKCRD6UCkIqsW9
 0J3CEACzMsK+m4Dg1xcrEbxsQuJ6A2tsRgSLRenMoZVnVmZCFXa91CIJAJjAHGYufxyjSiRNGaf
 CMTMgh3au4y1+w0CNdn7IQsHpCZnesqFIGkSx30ONJgijxCvMn29faGLvUvIcsGLlbLq/0INZgj
 GGjeMJlMIMklMIPq6OSmyg8/ghAc8X2AksxqSolcQJJVS2n7/MhoxbNnHvP9utkfuf63XwmkbU+
 6PchkUVhgUleFswDlr6LxZcKHpRXeWa6eNiG5e1ve6RG9hiLg6LgKJ47eBXMi+pApUP7Oko5g06
 NopeANniQ9yf5eyTCQsOK7omt59/0XEINdHIBxhQyn0RMLIxCwB/7HhePp9ygHM2i4R+hdFV+Cu
 qDIfInt3M5EO5hutxnt7ZRtCiFVMyz1ZX9RZh3HZ7mbjcWccuWSk1oNIYa1W03MQvlNZp46M0Ps
 xvXcqFMThGzNONErsCDC234+Rc8VIPFNKU0xw0oLg/1YP2zEvf1Y8HP6mvnv1ize2Gezc01Hgl9
 +xy9vogiSrovDdiJ+YM1xCuTgOq8UmsM/SReX1qSWhU9ouI8kzkBB203ikD60m1tyHBnAtKyDbl
 xNn1PlYt2XXB0LWYvXCJuOmVSx6qN6qoPhY0Z4u75vKT2Sq4FqTKx64bVxPBG7oeaAOvpoz8Ulj
 IGBeCmbtnUUpmhw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 10D0812000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zjf4fjcfwq86jw67pn3qyspo4q3amhug
X-HE-Tag: 1795180284-943900
X-HE-Meta: U2FsdGVkX1+D7T95jgFwMIzoVdPqOzqb2a6SBL8LbT5+4JD0GbOkOJjwxqT1HPvWMn5o7RGlfZciwZAr98gd+M2VZpeWwUknNcR2tQaQWXXu0x14MJtPXcwHy3g/cmprKkF53R9Q+fUCp5SZqKMr/lwtEIkfscAUlfHmJ3nxddDQH3J0P6V1N3xki62GApi/h40BQap+2AFj/7xVdUwZIpQ6VIpmdh+oMYzVS2Td7M+kgwpXS9zfVI1LDrceg8/GKKmoy99LcWqkbuPM3VO18a7c+urT0fqLvBjZ/l/07G0pB//g3MXt3hV1Quhm6AGcw0UWEYXPLdFBnpr8Vh9gWHxbj3/EZ3VS7amF0BAK8W0RsmgwfJ5SseLtl7EkPuzE6zVkmcVIUr+QDXBSFmCdtRAcfyBKCLLcv4ZFrNfdDJcMLSEKU+fT2A3R4gaXDwhPc8p9Ynm9Cvk2N6FDIr3mgNNeGFVHWPvYTB7dE9RpUxZvtOTv3t/j4XsIg5u9sMD+jsWa/VrWW+VMhQA1ap0PtIOxtTCIoSHewKPsGO8jCJxl8GGeo6NwoIRwQ1tVnhMthWK9YwtE+8rfJYWbYA1Q3N+itIMM4NFcuvMLUQPzaNy5yN57MpsaoJS+EzSkiXUSizbPCTXnE+hhnAa5wgJPkh5ppNVtxHSFMagSLhIiu5aI0SOo+KdjeN1zv6M0ZmXXazxRFSRI4ucO3BEtVFFLAkaO6b/BDDJiZP5niS+SWEMEo/dUFs592FuUeqWOxQckJvClNqTC3YxQDmKAdZQJBxbmU0uHH+KPJ2cJqIrgaqgaVry6jqMuR3v92XEqCV/ncfdduYVe659hUYy0wrx2jNcsRScDzlvWTNRmHzByxuwiOmTS+5Dqai4WGUnXP9/k6UOF0LFO/hCI+RY0teAkIGzx2Jev9cZwND0czgBkaVcRmSDSD7+GwmNKMD4fXe3YV4IViSHPv178PjJXVcs
 PB0SsBT6
 uR7eoZoDLv/LamULH/ETZDEqmt0+g2OCx5SOX0tI+BTPZK7KCWXmST/pG27NAIrv1G7Cd28CxwfBUcIjg+L77iW+xE6oONLRjboC9GJF5xYZk+UkHtFwVLNYLLHGt5KbWsugFoMsNxpqAtgteAdmKY6MzoHotnaqf3kVuhUPPWwfU8Po/M6eZQ2kqk5+4FdpSt0M1QMAlMEu1hLj4bOcSViK7eFsVas+oEW+5IyDkYg9VyHbadrM/QA6FaxtUzjx2r9hHP7XKEloUGWH7wJEdt5T+nEXK7E6ic1RF0QDVGdRG+UUIqetLw4F3QM2H2V8trcaNv6FVi6NpAa/pF1ky96s+SmRClfi79XdfYbE/fibnKCVRcsl2J57RD9TAuS/Wkfgc+syqGQ/VVAc0pOETacex7yp1wb9whXjxlTt+6hTqKn8bRAp3RqwyrRKcSxeZBkFCF7CTEYPaLocxh0ejmI4HFDGBG73aXgYGVOHKiYzIuckMh47JylB52wQQLwOpehGNWZofJiIfDJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The functions xas_result() and xa_zero_to_null() are static in
lib/xarray.c. Upcoming Rust XArray changes need to call them from
Rust helper functions. Move them to include/linux/xarray.h as static
inline functions, following the approach of commit 79ada2ae6615
("xarray: extract helper from __xa_{insert,cmpxchg}").

No functional change.

Suggested-by: Tamir Duberstein <tamird@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 include/linux/xarray.h | 26 ++++++++++++++++++++++++++
 lib/xarray.c           | 12 ------------
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index be850174e802..db2520864aaa 100644
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
index bfe7bef80f34..49fbec5f6c38 100644
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
@@ -1627,13 +1622,6 @@ void *xa_load(struct xarray *xa, unsigned long index)
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
2.54.0



