Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E4960A381D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LX1qXbg/
Received: by kanga.kvack.org (Postfix)
	id 3099B6B05B8; Tue, 10 Nov 2026 09:53:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA806B05B9; Tue, 10 Nov 2026 09:53:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10CF46B05BA; Tue, 10 Nov 2026 09:53:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCA6C6B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:52:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA359A8616
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:52:58 +0000 (UTC)
X-FDA: 85419501636.04.2F821E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE77B40006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:52:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LX1qXbg/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794322376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwatasSyxzcSR5rQ2WiN2NCOOtGU337FRGLRO/rHFE8=;
	b=sxGsIQKZdx5B7VfQJl/SZ69M3yKVYGekCAVf2d3HmnRg5/5oY+KmccsvPFylY0mInXwm8D
	sU0Ok6W4xAEeNmI4Spu9WivOEE8YoBIdlPwbZlw4ha54Nq/OAs6+/3POolghHhJ1ybKQNN
	Qs/+RHgi3Z1pWljNhx/xIdfv8Dk1zaY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LX1qXbg/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794322376;
	b=idDYB9E7Xmm4ml0S0ofvh2WgjSRiSu07BtNwYjt06Xwtj2cyZGCUcEuEmiFyq5ntT9+dMh
	Hy3Ab+4IdEk3DgEnMUMbuiE/i/jfH9QlYhd6MKpeC7hjijwZC/Qq+bJ1S9Zv6dhKIdn+iX
	IBpTnAmrdqzNc0h7jrKjwGtEkKs7gVA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0076041473;
	Tue, 10 Nov 2026 14:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2752D1F008A6;
	Tue, 10 Nov 2026 14:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794322375;
	bh=BwatasSyxzcSR5rQ2WiN2NCOOtGU337FRGLRO/rHFE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LX1qXbg/O3SqIsVhXX5dPqCS13Wb9i92E6l1n17yBCB4OnnKsvUxOGHeu81PxeX7o
	 o9eck8S+w+0r5NELLlXM4xl7NZV8dRxCp6ToE00Tw5D+Z7Tui/RG4GWwu2JFsQFsJi
	 uxbQdEwE3QStUrUSmR6bKmEHkVfiMqG400XCA+HN4MOHgsqkF6inqyAQrHYqbxl8v9
	 pyqST8S0AxK1Q0GMPTycGbw8HLqOelVkDpZSS+JeCHLv7YU8w2YUcHPczuyTWknQZL
	 102gRAvIHoDGXCB3L+qju6iBqqo+ljQiWDMkM08229BdRSA4bVXnDoy5uAnuHsigSx
	 Kegoc9W2ZZabg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 663A11980047;
	Tue, 10 Nov 2026 09:52:50 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 10 Nov 2026 09:52:52 -0500
X-ME-Sender: <xms:wS_zak2W15IeFWn6kiyZTKk_0WwBxL9eKgrsBBFJORWUCTtbi7-08Q>
    <xme:wS_zavMM2PnWiv-kvgrNmh_7ZbXZrCvUZjOBqfMrGl5_tizfJQ5VrbbI9PHrD3z4m
    IEBWjWChULmn7DArkv60t8ZxFGiLMayYZZYDsbqkXHbzP3bozL9XrCo>
X-ME-Received: <xmr:wS_zaqszeiG2xVxpOI5pnM0D7M68peht3izRM5FN63Gqq2bMAt2oxnowDvE>
X-ME-Proxy-Cause: dmFkZTF+Cn+fSgda5ibRlg8z0HHd47AdQqgPs/uBN4NgEssRGADLpXszo7EdJ4hc6xz2Ef
    EUmaDyZaXcY+YL0D35VcXklWSGO8Ug1cC0CybUOo3mwF9pj0hl/2YQ82hQmzmrFF0mRvwv
    gl679KsfUxnSOavz6lY9EBi8U3CsSXr4Qnl0BS5Rjmt6ZpTTzNrlaWD4twI7L0h6db8KXe
    hL7mENu+NTXE/lgl7zKZ9G10X0CMpXoxVLVIFrzoEBolZB0xMHBwNm+EeoQ0TpWfQSdq79
    aWiko1YyVPAhQzDQdIdJfHn8x09SHcsYyBmY2iIQ7sfSmOyy2AqqhOBitTCqCwP/4fGaI0
    XAaUzKekg4g5tv+R3G/J8OgkJRg9K6kNgoFNH+6Oy5Q7CcgTDen2gesRc62jCx+fjrLQ3K
    2exx18ViYCt6lbV6J24anM3UtlAkUjkngmjn9FUZijG1U2klJLxsqPn/kUMOUAEGiFpYrj
    OmRQdmGlCGksTx5ePE0T6RF2aRHEPgskEVJZXZpTlDZPiTuaoAqQfRkg7/Bg14Z7++dpwB
    SbwlTGt4xiBzrauvN2gFWqvxlrwBjsEu+xnbV+fNgH9vS87ZH0+8a558EIaVVvFotxIcgc
    ipM7UkzR4MenaTa2sJ5cP+Rz55HMVinydGQ70cCSY6Q3tFL4HhSWy9nTppMw
X-ME-Proxy: <xmx:wS_zaiHhDIsmgyNP81PC0H1Q7IfNyS-g10JBq9zAvIUESBWt-MKB8w>
    <xmx:wS_zalQvRUnfbzsKrRN4lLJsJkcphv-zz0_tiCgtm4R_d7bHP_bY8Q>
    <xmx:wS_zamiS8IMRsBzbbfQ1rdhM9UuJzkM474EIMj--zuKpuwNHRR--2g>
    <xmx:wS_zapbsSVzo7a-eRELIHRz4o6nUtAzAPgYE_RcXz3jFzrJe0NQdaA>
    <xmx:wS_zanWB491OLGGbLJ0DXsP-bXV7GHeVBZEJMR_pyA8jGu0_H-ow4j2u>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 09:52:49 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amit Shah <amit@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
Date: Tue, 10 Nov 2026 14:52:36 +0000
Message-ID: <20261110145241.536019-2-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261110145241.536019-1-kas@kernel.org>
References: <20261110145241.536019-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AE77B40006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gaeeb5skwn73oapfube7mq7p6fs47pwo
X-HE-Tag: 1794322376-162471
X-HE-Meta: U2FsdGVkX1/XX/92dLXRoqDOuBL/9zMmXfL0ECxl1+MUC5gQdlRquhEfN9pOWlqiPZ9rF8fvRNp20BqBneKEM0UwGpFyWXhJ+0nFG0NnK7i3usvgY1enTfllcc/QVf+ItzZF2u8INMfuHf5IJeN01rZ3QNc1ZMuXKQTaNtoFPXIZ9Smo57SEEECliaS50snumjn11I5deM2cxzBITYu2C2VrY2Ipxq9i8W7kkBDBw1UHdWGu/EpkLadLf2CXVGWNImlkBPovVKCQDasCBqIbAZQ6LLAE4REVp5/UQPIep9Q1jzORdP/3imFS9B6ekUrDrQQ0DQnDKByFzV0rlurmsN9qKdcSrZtNB8kQHvGizpoa/JL3jEc/b0G0cy7B064ZoHPcd1yCCn8sN8cBVFxTHxT9SCw4FbRSdzFlaFx0ytlOGzxLLi1F9GJhGcKpMByufm4pxI3jhj4R18UgStJl/DiqC3YDrU9efpYD0XvylpgTTwOxZAE8mVTUa6IIv+Pb8Ui7pduU+IrHkDlYWuYyDq1Y3OBbj4oLq7IorKRhQcyvJ/VF5qEcIIdBbPuZW71CPnXHswcocPU+1HLDFJOb2GvLZrisOo6A+JeXUFXq+Ca+NJno/0YnBySocSTrUar/nivgtcmS67eriC4XU9M949/u9onar+7/d+cuEzrchekwFSnq2effSzQ39WsdXrYFG5tj7nWDgYzP+DvkH+A6knCnrigsWVrU6MtHFlQ98pYsgDYznUhXFerFuVRxBaNgIS8jzZAY4nS/9vsByq9aHsehZJ1h045+xvTZbXZal5xWO/EXzSFh8DPRB09Qf12mNQntQAMD7tja8qMzG5JK/c/wTc31mo8dTPxidyWHgIa4JjpbkP5toM47joaMKrkzCjHtBnEG57hDw+vmHnGYfR33BIli5H//UQvDeRSod4WXEaA0+PbfJPJ6CQcQ3z4JCtyKzMG9U2FEgkTnFbp
 Gxvrk7Bu
 dqc8DbkMOUCNA2aixVMNLXm4/3ivVu8uGlXhZaPruLTEJsHBg8ht7jiCthevOfkCs4scD4ipqIjq2jaehSQKBSaPuEwoEIF6HJBPAF626Be85HLJKVfi5xCSSZ0fDmL7HJiQBG5l3prHnog25dNQr7Dsc9hKBFG4vidyqMgsspK4nsnYJFP5UXrdtz0xLB577EVvrOhaCIw8bLWI6jnel0oLeY0J4IlbOGa3LdJzkrU6Xkxc+2/A008LNNdORREKxu810903mXxCAjXiZTioHeEl/a03HWJLEELUmXHX8WKNi0gANpt9mabqHmZx9C0QEHOFq4venxha79gM0aPWJr4OASME21IupCOEBh9HhbMVDipDcRlBC01hw2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

pipe_to_sg() tries to steal the page of each pipe buffer and pass it to
the host as it is.  When the steal fails, it copies the data into a page
of its own.

Pages written into the pipe with write(), gifted user pages and page
cache pages can be stolen.  The ftrace ring buffer pages that
virtio-trace splices cannot, so that in-tree user always gets the copy.

Always copy.  The data that reaches the host does not change.

Preparation for removing ->try_steal() from pipe buffers.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 drivers/char/virtio_console.c | 39 +++++++++++++----------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 019bcae81af5..b1b1aaf43e07 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -891,45 +891,34 @@ static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 {
 	struct sg_list *sgl = sd->u.data;
 	unsigned int offset, len;
+	struct page *page;
+	char *src;
 
 	if (sgl->n == sgl->size)
 		return 0;
 
-	/* Try lock this page */
-	if (pipe_buf_try_steal(pipe, buf)) {
-		/* Get reference and unlock page for moving */
-		get_page(buf->page);
-		unlock_page(buf->page);
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
 
-		len = min(buf->len, sd->len);
-		sg_set_page(&(sgl->sg[sgl->n]), buf->page, len, buf->offset);
-	} else {
-		/* Failback to copying a page */
-		struct page *page = alloc_page(GFP_KERNEL);
-		char *src;
+	offset = sd->pos & ~PAGE_MASK;
 
-		if (!page)
-			return -ENOMEM;
+	len = sd->len;
+	if (len + offset > PAGE_SIZE)
+		len = PAGE_SIZE - offset;
 
-		offset = sd->pos & ~PAGE_MASK;
+	src = kmap_local_page(buf->page);
+	memcpy(page_address(page) + offset, src + buf->offset, len);
+	kunmap_local(src);
 
-		len = sd->len;
-		if (len + offset > PAGE_SIZE)
-			len = PAGE_SIZE - offset;
-
-		src = kmap_local_page(buf->page);
-		memcpy(page_address(page) + offset, src + buf->offset, len);
-		kunmap_local(src);
-
-		sg_set_page(&(sgl->sg[sgl->n]), page, len, offset);
-	}
+	sg_set_page(&sgl->sg[sgl->n], page, len, offset);
 	sgl->n++;
 	sgl->len += len;
 
 	return len;
 }
 
-/* Faster zero-copy write by splicing */
+/* Write by splicing, copying the data from the pipe */
 static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
 				      struct file *filp, loff_t *ppos,
 				      size_t len, unsigned int flags)
-- 
2.54.0


