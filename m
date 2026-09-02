Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B46CC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7420A6B0092; Wed,  2 Sep 2026 13:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719526B00A4; Wed,  2 Sep 2026 13:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F826B00A5; Wed,  2 Sep 2026 13:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3C46B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:34:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C71E8120280
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:34:43 +0000 (UTC)
X-FDA: 85169522046.08.BD28D5F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id B100340004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:34:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GDooSxlH;
	spf=pass (imf11.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788370481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnfEm+OhRi/45mFVUOgbuCPGW3hJeL3DRZRk8bidxUc=;
	b=BGD/ak6/I3J7/UYo18mtRC5xWTsEmvwcmmzoW7kTVp6aM/7gL8FrOBq1c8bjf6T9KQQVcr
	9qzx/YMzjHt6aC913wXjda/5BEPdbib7p2+vGJbGmgvNnixFvUJLpewI0MViru3Mq4qDyT
	BnDJRYqqo6lRLk4frROFLjoVcZ/sUHI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788370481;
	b=wQ36+Ki4fBFWjs6iUxByyVmh8Tf+fViXdAlVah2nAifzD/HxvgJYSD+cbtRVULMtEYVwSA
	gskg6muwBhag58yMg6OCktajmN9TRr0X4Cm3bSeDY9XxcqEw+b7Sd1lHJwJPU9MdTGQ74Q
	lyoOj+Hj+ic4VUauWdk/s5jB9fw7V9A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GDooSxlH;
	spf=pass (imf11.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnfEm+OhRi/45mFVUOgbuCPGW3hJeL3DRZRk8bidxUc=;
	b=GDooSxlHuSzQyosw46KsiDKZheDfIVpul6FcnaoI/YRsDU3NOQH8QtQWvdNkK1WJlEhryg
	6GlXVIMMBfcIOrNCB63JVRLjEvku3MfghbSymvZRTzFlW70No5VSAwlntpgAp4CC6YaRe4
	1Y35UVqWNoAiLqrp7zafVrU3jMA41ng=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-133-ErtfLEkNMF-ON6266K0J_A-1; Wed,
 02 Sep 2026 13:34:35 -0400
X-MC-Unique: ErtfLEkNMF-ON6266K0J_A-1
X-Mimecast-MFC-AGG-ID: ErtfLEkNMF-ON6266K0J_A_1788370472
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A272A195C241;
	Wed,  2 Sep 2026 17:34:31 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7AE1718005BA;
	Wed,  2 Sep 2026 17:34:24 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v11 03/36] mm: Add a bulk end-writeback tool
Date: Wed,  2 Sep 2026 18:33:15 +0100
Message-ID: <20260902173350.3468672-4-dhowells@redhat.com>
In-Reply-To: <20260902173350.3468672-1-dhowells@redhat.com>
References: <20260902173350.3468672-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: gmpJq1Ga5rdrK4JDsQW_3L-Z-KU8sZPTluvOvrp1E7E_1788370472
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B100340004
X-Stat-Signature: 87bkhq8ymp9asdioi845hui9ztnjd83t
X-HE-Tag: 1788370481-775009
X-HE-Meta: U2FsdGVkX1++R0PLbQCutssyVb9uJJPzoRJzu3k8T0CBxUQ8ntjNEzD0rDcVr+GryRWUsxocFeAh0w6xoAEFO1iwOITpm4LLPTT78PNhNe5tC5yJMquabRN9O3BxLTT2ftb07K0KtU7eehf4jZqMe7Jcl3pU+NKZNXyOCgt9ZtBVeADSRJ+37niuHMn42BrNiqwO+8ToGsaRvvQaItW6NIU+STWT4k0NiCvNhHqN66kd7Y1mRKg0lPLYiWC5TQsWAti1Z/COPdKhUfKYPy58FLfjWQ/fN2KWG22giL0VrQ8TqLwPzmp6ivmMqMtItPVdel3VndGKgegZXsKPaxZcPCQAaDVZHTwpQJiWJ00xP/omc84ndNym75eiZq4uXM56uIxZ7Zv0Mf7o4LNzQaS3eU95+1VEsTRexdVI3DpHcMHBuFe4HO1kN6AXN3OqWjN3lRPu6Q29V9knj8Xr9eq4P6rzjXG922/InW4OHzXciEDuLRda/WD68fmhAeVFYretixXUNpX7w6wmdaA0TckjRmJIWWY9cZm1o9jdp3qR6OeTIxT3tu+hbgrc/ocOTntWh+zESj47oUu49uqfC9KsxM+999eoskEAA/4Xh35BSQYVHPE8Q695IsbkMUmvUQxyANxHoDXjbJJSBloKWBr7u5kM/rBLPDjWRw8WdGJoV5IXecvwlNU6sjOF2KiT4NRJnx/PxYKF4+ONxbYnLjsbBvSaBRaoucPBt0uOv0HCilYqU6DVXKiI3JhFT0jKlXiluD6xoJSZDQmiAQYiMSwDVcFptceYqRvNHA5HEO/b4YHp6S8Ff9q/yowZ4baRWS9WSWevxas18vtj2efYn2Q8z/ma4+XrU9xZacZ9jqxTAMqOQlQF93o0iy8TDDIZ2fTGpl6Bc6C/In0aM3Z03GtXQlIJTynul3dQtTB7b7ZC7l2UFTi2U/tgI7+EsPZj0duSxPzyCWgdTKJDa2nS4p7
 Kt6gdZlX
 CNLdUSKUYrg5Lazv0BjN3h8xL6maV/YZYFXoXj0wZ64r9Nrh0DwQ0P6atgCs+Er5u6XgG1lskg9s66DIvIdrYZ09UfWElC2IEFnpRB98TPSRQ1MSe/l7jRD6eQHqBI0OvLzpl/zQ1qBPgrZXwyNiI3AgKOYCyRvvxZ+UjNxvuaKaEqAa5Ao1+mwAvfARFK7misjYqOsVkF+sI1X/X3M2fNeYBfkNR2FTaye7uYMoedF+IpCp4VaIVWU5kV4awc9YLTAHIGMy8XavQZLzKrQYsdNkrjQzgwXSkgiRPjtoXxKMSTrNxCpNVhN4K6nny0yMly7+4OPn1mSucMuplW3kLSoMTVpjIl8VLvWXj1U54HrWrTHHB2u2QepLdZvF3oYNgAuc5VO5wonoS5QpxtlyWHgInU3UMvAq1DBn4q55Cq0rdbfdikslo1KOwgoD4qDUbkLi0ctMwasbURiH75tuFGUTIAD9miAEXxOqENr+6xAlfFAnLFDuVgruNm2GhNsOqavissvoGKtLPKdnkRJ9thdsJuhKGeLfy/ssh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a tool to perform bulk folio_end_writeback() across a series of
contiguous folios.  The function takes a beginning and an end file position
and ends any folio that lies wholly in the range, leaving the end position
of the last folio it considered in the iterator state for the filesystem to
use as a hint for when to call again.

As folio_end_writeback() has to access the xarray to clear the marks set on
the entries for the folios involved, this tool provides the opportunity to
merge the two xarray accesses (the iteration and the unmarking) and also do
statistics update in bulk.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_collect.c  | 51 +++++++++++++++++++++++++++++++++++++++
 include/linux/writeback.h | 10 ++++++++
 mm/page-writeback.c       | 45 ++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)

diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 210eb8f3958d..c5b07b3201d7 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -21,6 +21,57 @@
 #define NEED_RETRY		0x10	/* A front op requests retrying */
 #define SAW_FAILURE		0x20	/* One stream or hit a permanent failure */
 
+struct end_writeback_ctrl {
+	struct xa_state xas;
+	uoff_t fend;
+};
+
+/**
+ * end_writeback_iter - End writeback for the folios within the range
+ * @mapping: The pagecache to modify
+ * @from: Pointer to the starting position
+ * @to: The end position (exclusive)
+ * @ctrl: Iterator state
+ * @folio: The last return from this function or NULL if first call
+ *
+ * Remove the writeback mark on folios that are entirely within in the given
+ * range, where @from is included in the range, but @to is excluded from the
+ * range.
+ *
+ * Return: The folio to end writeback upon or NULL if the next folio isn't
+ * wholly within the range.  Note that this does not necessarily imply that the
+ * ending is complete.  @ctrl->fend is updated to point directly beyond the
+ * folio that was considered and may be negative if cast to loff_t.
+ */
+static
+struct folio *end_writeback_iter(struct address_space *mapping,
+				 uoff_t from, uoff_t to,
+				 struct end_writeback_ctrl *ctrl,
+				 struct folio *folio)
+{
+	if (!folio) {
+		lockdep_assert_in_rcu_read_lock();
+		ctrl->xas = (struct xa_state)
+			__XA_STATE(&mapping->i_pages, from / PAGE_SIZE, 0, 0);
+		folio = xas_find(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	} else {
+		folio_end_writeback(folio);
+	retry:
+		folio = xas_next_entry(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	}
+
+	if (xas_retry(&ctrl->xas, folio))
+		goto retry;
+
+	if (!folio)
+		return NULL;
+
+	ctrl->fend = folio_next_pos(folio);
+	if (ctrl->fend > to)
+		folio = NULL;
+	return folio;
+}
+
 static void netfs_dump_request(const struct netfs_io_request *rreq)
 {
 	pr_err("Request R=%08x r=%d fl=%lx or=%x e=%ld\n",
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b749a9a5a5ee..4f34cbc964f6 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -358,6 +358,16 @@ bool wb_over_bg_thresh(struct bdi_writeback *wb);
 struct folio *writeback_iter(struct address_space *mapping,
 		struct writeback_control *wbc, struct folio *folio, int *error);
 
+/* end_writeback_iter() state. */
+struct end_writeback_ctrl {
+	struct xa_state	xas;	/* The xarray walker */
+	uoff_t		fend;	/* The next file pos after the folio last considered. */
+};
+
+struct folio *end_writeback_iter(struct address_space *mapping,
+				 struct end_writeback_ctrl *ctrl,
+				 uoff_t from, uoff_t to, struct folio *folio);
+
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void writeback_set_ratelimit(void);
 void tag_pages_for_writeback(struct address_space *mapping,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 6c9c7ba89b8a..632b0616eceb 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2546,6 +2546,51 @@ struct folio *writeback_iter(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(writeback_iter);
 
+/**
+ * end_writeback_iter - End writeback for the folios within the range
+ * @mapping: The pagecache to modify
+ * @ctrl: Iterator state
+ * @from: Pointer to the starting position
+ * @to: The end position (exclusive)
+ * @folio: The last return from this function or NULL if first call
+ *
+ * Remove the writeback mark on folios that are entirely within in the given
+ * range, where @from is included in the range, but @to is excluded from the
+ * range.
+ *
+ * Return: The folio to end writeback upon or NULL if the next folio isn't
+ * wholly within the range.  Note that this does not necessarily imply that the
+ * ending is complete.  @ctrl->fend is updated to point directly beyond the
+ * folio that was considered and may be negative if cast to loff_t.
+ */
+struct folio *end_writeback_iter(struct address_space *mapping,
+				 struct end_writeback_ctrl *ctrl,
+				 uoff_t from, uoff_t to, struct folio *folio)
+{
+	if (!folio) {
+		lockdep_assert_in_rcu_read_lock();
+		ctrl->xas = (struct xa_state)
+			__XA_STATE(&mapping->i_pages, from / PAGE_SIZE, 0, 0);
+		folio = xas_find(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	} else {
+		folio_end_writeback(folio);
+	retry:
+		folio = xas_next_entry(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	}
+
+	if (xas_retry(&ctrl->xas, folio))
+		goto retry;
+
+	if (!folio)
+		return NULL;
+
+	ctrl->fend = folio_next_pos(folio);
+	if (ctrl->fend > to)
+		folio = NULL;
+	return folio;
+}
+EXPORT_SYMBOL_GPL(end_writeback_iter);
+
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;


