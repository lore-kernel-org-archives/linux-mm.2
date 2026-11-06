Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF8A606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jeFNHfv5
Received: by kanga.kvack.org (Postfix)
	id 9CC6C6B05B8; Fri,  6 Nov 2026 08:19:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A24D6B05B9; Fri,  6 Nov 2026 08:19:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8AF6B05BA; Fri,  6 Nov 2026 08:19:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6351B6B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:19:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD52B80D51
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:19:28 +0000 (UTC)
X-FDA: 85404750816.03.ADF16B3
Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	by imf25.hostedemail.com (Postfix) with ESMTP id A8E17A0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:19:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jeFNHfv5;
	spf=pass (imf25.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793971167;
	b=ue1pyiwdYq+oX65XBGVtwtgB8tzMhh5aFahWDimg5Z9gmw008VpdGd1+6Z4byfV8k0yfq4
	BLmXJpVdR6Y8bA97DKD0075AZnMnqCeJXImxAmTsPqMLS3LTp6qWLvwfKJxfO5lv9erGA+
	2B7JgZ8IcFH+KlOjBfuSSgpbk5d/sFs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jeFNHfv5;
	spf=pass (imf25.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793971167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjxbtrTpVECakggq3aaOcAKtXEWGwtyTzHqRGiNRk7Q=;
	b=0v2h6rIUaYfuAAa5C6kKKGLy/PWvL6Bj6HlsmDDlt/qOEX5d7a2Qff1vHKjznCAIu2MKTh
	KOMAk0iA/22HHfdEKLxEMcInPsa4B7y3FHaSWzxyIH/7cDVg4eCp3M+00LC9MPjV6FRmma
	cLXbQFbEgOFuMrDa0TS5ahFMTHmBKX8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KO2+Pw/HQKx0a4JyoCFPhhmUGDsn7IBoIsdjd3UIB1k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971165; v=1; x=1794575965;
 b=jeFNHfv5f4zmg3psPVOfCRejiIcbH0mRSeUBXfYvbsOUUduFnoh4Xb/lFO75h7OZwr3xb52j
 hl5asAf3vpi1tP7ZCwkufcg0keAVYJ9DH3vunUx+P7OTGGe6hcvnkzOe8I6jXRUX5LbI2tCx1XU
 DqQcY5Z6CBplWlVJlLCwbnXY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 99a7a9ba11e11fd9;
	Fri, 06 Nov 2026 13:19:24 +0000
X-Mizu-Trace-ID: 99a7a9ba11e11fd9
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: akpm@linux-foundation.org,
	dgilbert@interlog.com,
	mkp@kernel.org,
	loberman@redhat.com,
	jmeneghi@redhat.com,
	kraxel@redhat.com,
	vivek.kasireddy@intel.com,
	mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	stefanha@redhat.com,
	sgarzare@redhat.com,
	rostedt@goodmis.org,
	vdonnefort@google.com,
	mhiramat@kernel.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	axboe@kernel.dk
Cc: linux-mm@kvack.org,
	James.Bottomley@HansenPartnership.com,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	phasta@kernel.org,
	joro@8bytes.org,
	will@kernel.org,
	linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com,
	robin.murphy@arm.com,
	mason@kernel.org,
	aesteve@redhat.com,
	tjmercier@google.com,
	harry@kernel.org,
	vbabka@suse.cz,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH 1/7] scsi: sg and st: account the command buffer memory to memcg
Date: Fri,  6 Nov 2026 21:18:23 +0800
Message-ID: <20261106131829.3228926-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106131829.3228926-1-cui.tao@linux.dev>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nyfewnhtjyb4mxppdzrm3us1ed36tru3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A8E17A0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793971166-308931
X-HE-Meta: U2FsdGVkX19+e5WCMw39KnWPzCiES/mbCBITeEFF7uj7O8lgec7vaJ+cdDrwnLbPNZklZxLBlh+GeAQzD9XCOLn7cZw6AwOvLqS0JTs1HDFs1G6ZcnKFRiedjR1bcnnwR9sydRx+2B1YEX7jP7ztRsgqV5EwyRU/NgZqMXOjWmLHyJbOrzxyw2SkXpopVXJm7Wy8wdKx+fLdcPBhBseQT/wwH1ka0MVaosC5P0jwwPrm0i2isI7wS+t/KaCxylg//PPgcpEVDS2pF4/wHvuz13UYdPim/jlBWgt+L822Y+I1goqlCu6dekrM8ohOSxT3BLvqM602sI/TS252JA/h2hZPUWmMOww438xcHONSNH1lT/cYR/ns2P+do6QsDxrhyVqGdWaNOUsn7uaCOWcUAKR1mD2tVJthQxXsYXW4mhw+K0NGLwos1e+0k+L+3UcfRi48ki0dFma8Oo8vJNAVtDAkR8rzyodhIBe5NF8K68SOLXNOXI+btE7kFCRM7TSG5NYext5LhwUp/67MfVQ3j9oIn3iLr6VlPHxttHHUgZQDx9GSBw02xy0BlorsF4wMQ1AwmdUhPBZiJPAQry/tV2HjW7vf2Cv9FiuLNn8ffSOHp+wmIVVH9Q+pIerKha0SWbmUTE/HiXQfENNGhXyPO3YsIiBxa+5gE6y5B9BcAUvyrZgorl6z72y0sRka32Wr9j9bnz+Z/rtxw42EAttHp4C+7wiGj/2bw7IKUWi3ocFpKkp48MdR24oouidcGhO59pjbRV7gvItXJUjhuvswTdqnnfHX/52kU6Cmb87TSZz2rFDDYr1gSu1Qx/LkbbD066/fFLJn87WtI/4ygDCq8FyF4GF+HZQK4SkaW2qbckTf+ZnzqUuOz1V5VTqzPJ9FmPteE/ZR1gzFXUEt77efgu/lrsLGGDdn8c4GKnAh+XBmdhUFh+2YSS/cJrTtjnqc1jOT6FmfwRuCnV6F6u/
 pkM4Whqv
 9XD3NRphaOHi8KTHWQU7CEZFRWjHGz0I0tXV3NFMy6oPFm961O3R8ZQpVdKFYeos9UOL4AnI4563824W7fK8l2BosGUUe62b33xbVvA+rETxkzCTZaWZimQhH4cECLFQR7mNu6+LDmuUbZhvHj+6QZNNppcb7Ikly43he+4+vTiK/4vA+tYUvNM4xN8030vYFXsS3TWCrTuokO0LcD/XK0l3aUYRZIw0gdyuj4fGb6xkAIs55pV+BKIazSLgT3VzmWUTnm8MhJUBtSZNMafHk160Hgqimbj6q0i1HdXjqDRIfC8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tao Cui <cuitao@kylinos.cn>

The sg data buffers are unaccounted: the per-fd reserved buffer, the
scatter-gather page array, and the order-0..N pages behind it, plus the
per-device tape buffer in st.  All of it is user controllable.  The
reserved size is capped only by the device max_sectors, SG_MAX_QUEUE
(16) commands can be in flight per fd, and the fd count is bounded by
RLIMIT_NOFILE.  Nothing is charged to the memcg of the process driving
it.  The September 2026 fixes in sg_build_indirect reshaped the element
sizing and left the accounting alone.

Mark these allocations __GFP_ACCOUNT so the driving process pays for
the memory it induces.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 drivers/scsi/sg.c | 23 ++++++++++++++++++++---
 drivers/scsi/st.c |  7 ++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 6551f1284d44..9c1414479b21 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -911,6 +911,19 @@ static int put_compat_request_table(struct compat_sg_req_info __user *o,
 }
 #endif
 
+/*
+ * The sg passthrough of the blktrace ioctls has the same exposure as the
+ * block device path: holding the node is the only requirement today, and
+ * a created trace outlives the fd.  Must match the gate in
+ * blk_trace_ioctl().
+ */
+static bool sg_is_blktrace_cmd(unsigned int cmd)
+{
+	return cmd == BLKTRACESETUP || cmd == BLKTRACESETUP2 ||
+	       cmd == BLKTRACESTART || cmd == BLKTRACESTOP ||
+	       cmd == BLKTRACETEARDOWN;
+}
+
 static long
 sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 		unsigned int cmd_in, void __user *p)
@@ -920,6 +933,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 	Sg_request *srp;
 	unsigned long iflags;
 
+	if (sg_is_blktrace_cmd(cmd_in) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				   "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
 	read_only = (O_RDWR != (filp->f_flags & O_ACCMODE));
@@ -1829,7 +1845,7 @@ static int
 sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
 {
 	int sg_bufflen = tablesize * sizeof(struct page *);
-	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
+	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT;
 
 	schp->pages = kzalloc(sg_bufflen, gfp_flags);
 	if (!schp->pages)
@@ -1844,7 +1860,8 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 	int ret_sz = 0, i, k, rem_sz, num, mx_sc_elems;
 	int sg_tablesize = sfp->parentdp->sg_tablesize;
 	int blk_size = buff_size, order;
-	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
+	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN |
+			 __GFP_ACCOUNT | __GFP_ZERO;
 
 	if (blk_size < 0)
 		return -EFAULT;
@@ -2134,7 +2151,7 @@ sg_add_sfp(Sg_device * sdp)
 	unsigned long iflags;
 	int bufflen;
 
-	sfp = kzalloc_obj(*sfp, GFP_ATOMIC | __GFP_NOWARN);
+	sfp = kzalloc_obj(*sfp, GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!sfp)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e9d41e3cc2dd..b92633ab2757 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4074,7 +4074,7 @@ static struct st_buffer *new_tape_buffer(int max_sg)
 {
 	struct st_buffer *tb;
 
-	tb = kzalloc_obj(struct st_buffer);
+	tb = kzalloc_obj(struct st_buffer, GFP_KERNEL_ACCOUNT);
 	if (!tb) {
 		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
 		return NULL;
@@ -4083,7 +4083,8 @@ static struct st_buffer *new_tape_buffer(int max_sg)
 	tb->use_sg = max_sg;
 	tb->buffer_size = 0;
 
-	tb->reserved_pages = kzalloc_objs(struct page *, max_sg);
+	tb->reserved_pages = kzalloc_objs(struct page *, max_sg,
+					  GFP_KERNEL_ACCOUNT);
 	if (!tb->reserved_pages) {
 		kfree(tb);
 		return NULL;
@@ -4109,7 +4110,7 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size)
 
 	max_segs = STbuffer->use_sg;
 
-	priority = GFP_KERNEL | __GFP_NOWARN;
+	priority = GFP_KERNEL | __GFP_NOWARN | __GFP_ACCOUNT;
 
 	if (STbuffer->cleared)
 		priority |= __GFP_ZERO;
-- 
2.43.0


