Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2074606A330
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 22:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=netKusrG
Received: by kanga.kvack.org (Postfix)
	id A79216B05B2; Sat, 21 Nov 2026 17:18:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02386B05B4; Sat, 21 Nov 2026 17:18:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853C16B05B6; Sat, 21 Nov 2026 17:18:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2146B05B2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 17:18:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D913A81FE
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:18:33 +0000 (UTC)
X-FDA: 85460541306.17.FE9033A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A872B40006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:18:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=netKusrG;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795299511;
	b=v5fVJ6pXQ2Y+NIa6+A4gwLAU+vBF82gviLXKfcaHukluRcz3r7rJ3zopscuTYPp0+Z6RfC
	aQfjwEYS+pyUaUqJVGDR9CJMNNZlM9BbRjiRYiCSreIfvN8x68SPnRCum/13WNtMUPbXhX
	IS9ZQ36duXzj5sLzQHuKY6C5/6vHY+A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795299511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=2ljPbviUXKu1SCaRavSk4LhU7mdn/H04EXeK9PLuTmo=;
	b=rl+fbHxumPhzvfRmntpo09sqT+q5LjvFrQYj9CzJzryE/ZHGzP5yN63qjM47klAvhpWtH7
	6buxnA9SAyP+Fx+h/mVkTo1IccURVom6PJD2q6JOrOXg7s8AQ3E6OebXeJUHjRDgwSHjEq
	b12Tz+7WEEpLTFNBilvd1/wfRzPz+nw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=netKusrG;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B39060D9B;
	Sat, 21 Nov 2026 22:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D4A1F000CF;
	Sat, 21 Nov 2026 22:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795299509;
	bh=2ljPbviUXKu1SCaRavSk4LhU7mdn/H04EXeK9PLuTmo=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=netKusrGp+sRX3aLeD14XWKNNKdUwuLOvn3Qwv4wmun0xK7jJndf5dxL330bWqmqY
	 UgbTecV3leJ3kDr1miff/ZmDYs8G6aaGo6zgPqM0/xUVGCyH6XSS3c1hDgFGzs8i2Q
	 mAlbHFhWgb5PyOwx7vpMdKc1AZ+sf7o1DGSj03jU=
Date: Sat, 21 Nov 2026 14:18:29 -0800
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Nickolai Zeldovich <nickolai@csail.mit.edu>,
 Baoli Zhang <baoli.zhang@intel.com>,
 syzbot+73641b60a3bc11dfca8c@syzkaller.appspotmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <08ceefcb212e4dda9767389fe7f162a8.1@linux-foundation.org>
In-Reply-To: <08ceefcb212e4dda9767389fe7f162a8.0@linux-foundation.org>
References: <08ceefcb212e4dda9767389fe7f162a8.0@linux-foundation.org>
Subject: [PATCH v2 1/2] lib/test_xarray: check the offset of new root nodes
X-Stat-Signature: cri8iweripbxa44ndoexmzmwjfo1ybug
X-Rspam-User:
X-Rspamd-Queue-Id: A872B40006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795299511-139633
X-HE-Meta: U2FsdGVkX18jGP05uahrelcF3Stj7fleyIKKuO8qtuSUHHRY8ebLtYxzmVbiGDqpEunem5MGtQWQUDj+tEHLq/gJhh00xkMRULwv+6L8c6VEwnaw+Er9zixAtQRwN28evGAbPi81DBYXhCufc7UyGWU2XfrUPceDh3Lpz2TvovPOFEXmpDzrv8pqrSuOuYDfpLy7pr4VpAKBJIMRkBSGs3gaoX5Sidis9fg68Rm7LHEmwUa4H84iIpkXG3tRYzphW/eZrUiyN7+kMlP2y3c/mo3M7HT5eFTfCGQn4twBUCSmetJofSg2+92jtjbAKD2DnqLJLMqfSq5v3ggaOvlaocsftMTTxOSsrKBfmcLMPgvypAENQAnmctmZ9cECY9U3GZEyqEN83yd+H1QVO2xQwsJwLhSZ/4S2eCB1yrMz74USvXx+VLLk+/hwtfax6leCVe1vTnnpd48Rlj3zjuaunbWybBbXgzzjWtHTR/AIpqyl5H5Q7gaFuMtzqCjOnGj4Ctpm/MoHSihSx+UAJVPtCri/+wJ1vge3U4vgLzY0IOtyb+MSZERzNaM8hXn9gOUxH25oFa0vCOZkDbZ5znyu/5VJAoFa0/bQj/fCa6EvULOc7fMqtnaeozz0Az6bW79K810JwGOWApDtuY7bTpaHSJ77ZmR0sOXebuco+AekJgU33LdllcGsA8WBupK7sUcEjPRq2MfXgbsNi7NY/c6jB9xsTM9qfsXwhJ0VuADqvZ7lWmcs1veFyzFmb0v6R3nqZYZspFrye8VW/PPn0N5XJ5wvq1fWrxMBmXc5PsbTKLZ5OSEqhrL0SVS0Z5JVmMNCgQg+JCw0XXT4tPnmCEVJh7ziF9MPGvpPnd5Qu/+0s6FY+A2o4pQJIv9Px3RRJR2ghh3bnPOtmFEgOZ+ZUp55kS1nUv84NsC45gIXfEF7VLjuFmI6YTXHlwOtu7xu29iT1CuUCHqL1rEdjXrRXn2
 r7+a9f28
 NUdKBQmQ+0kBcVVNpHQzh6g4pILk8A8d4QHpR38telYXJgZcmME9z6OarNzhAyicPVz1Ws0836UP+Gp7xo+GJKV6IbFrXlwTx55wDmlX1eNYSt445LIdPD16Omlt4bfZ6Z7Gff7f8RWnbJHqVCP/wK4e6o8G2sfxtHHcuwJsIvFIhFu4hEyED85AQvDGrB8sEIKR/761d3z54PBsQkOzq0G+Bjp0IG/OS5oUTrTMcCuA3WVzrYpP/bc8pP+CXWxhKEAMh08k79KoKf9/4XpiuOvJYuLXJjXz7ibCBhdI5zgtt4XJVtoo9wweAsGqwBbyRFVQk4/q0BWg0P4zovA3hWILuzAhIaPK+4dI7ua89t5gfE2AEfDKkryjuxgPpyEREL/V9ymG6Vf98a+lI+2lBJDzFhfAipc2Ku7aC5Z0CtFjAMyyjbLoUGADxDk/xYtAyK8Z8M04EkiaTJN5aFJn6jWMhhaJZSyRHCNNBfxT24c0BaEWEj28T6xbqI2JTTvgxkx1LDE0R486DxXFaDGt5G6LLeWnMNF2OFc5vagKfh6HIyk/74Sv/5KKtoMGlq2XSeObop1JReY2L3DIPXpid/6rPe7VE2zjJoUv0ZzsYOCez2U8JcKGUdl1u7OLV9wMdY2zOspXreYC3/7xf09gEaVEVrWFvqqSylmOYkB4RJenGlz56X+USR1eRKEj94wtIwWNjS7hJVOewfFkWwF7DezqNr7jl0vaxGx83B8XZKVyj52Oy71+mTC2vrIXDCwXhPZyswwZnSQXJdt7wvbLUN3YuUKpyr2qupOO/1uA0e7TBZO+KLVcWb5GfSekB2NhNaVZXYKD0AV27yyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

Free XArray nodes whose offsets are nonzero, then check that roots
created by xas_create() and xas_expand() have offset zero. An old
root with a stale offset can make a concurrent iterator resume in
the wrong slot after expansion.

Link: https://lore.kernel.org/r/20261024014344.830116-1-nickolai@csail.mit.edu
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Baoli Zhang <baoli.zhang@intel.com>
Cc: <syzbot+73641b60a3bc11dfca8c@syzkaller.appspotmail.com>

 lib/test_xarray.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/lib/test_xarray.c~lib-test_xarray-check-the-offset-of-new-root-nodes
+++ a/lib/test_xarray.c
@@ -370,6 +370,38 @@ static noinline void check_xa_shrink(str
 	}
 }
 
+static noinline void check_xa_root_offset(struct xarray *xa)
+{
+	DEFINE_XARRAY(tmp);
+	struct xa_node *node;
+
+	/* Free two nodes with non-zero offsets so the slab can reuse them */
+	xa_store_index(&tmp, 0, GFP_KERNEL);
+	xa_store_index(&tmp, 5UL << XA_CHUNK_SHIFT, GFP_KERNEL);
+	xa_store_index(&tmp, 6UL << XA_CHUNK_SHIFT, GFP_KERNEL);
+	xa_store_index(&tmp, 7UL << XA_CHUNK_SHIFT, GFP_KERNEL);
+	xa_erase_index(&tmp, 5UL << XA_CHUNK_SHIFT);
+	xa_erase_index(&tmp, 6UL << XA_CHUNK_SHIFT);
+	rcu_barrier();
+
+	/* A root created by xas_create() must have offset 0 */
+	XA_BUG_ON(xa, xa_store_index(xa, 1, GFP_KERNEL));
+	rcu_read_lock();
+	node = xa_to_node(xa_head(xa));
+	XA_BUG_ON(xa, node->offset != 0);
+	rcu_read_unlock();
+
+	/* And so must a root created by xas_expand() */
+	XA_BUG_ON(xa, xa_store_index(xa, XA_CHUNK_SIZE, GFP_KERNEL));
+	rcu_read_lock();
+	node = xa_to_node(xa_head(xa));
+	XA_BUG_ON(xa, node->offset != 0);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+	xa_destroy(&tmp);
+}
+
 static noinline void check_insert(struct xarray *xa)
 {
 	unsigned long i;
@@ -2336,6 +2368,7 @@ static int xarray_checks(void)
 	check_xa_load(&array);
 	check_xa_mark(&array);
 	check_xa_shrink(&array);
+	check_xa_root_offset(&array);
 	check_xas_erase(&array);
 	check_insert(&array);
 	check_cmpxchg(&array);
_

