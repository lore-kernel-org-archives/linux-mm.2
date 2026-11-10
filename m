Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE7560A2604
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ba3Pyp5O
Received: by kanga.kvack.org (Postfix)
	id 1F9AD6B05B3; Tue, 10 Nov 2026 04:16:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA9B6B05B4; Tue, 10 Nov 2026 04:16:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0714D6B05B5; Tue, 10 Nov 2026 04:16:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEC096B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39E91120421
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:07 +0000 (UTC)
X-FDA: 85418652774.08.E0D4B2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 687174000E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ba3Pyp5O;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Uxnm4Cd0mizACq2HNobDQRQcgrPnhEO2KA80+bveeM=;
	b=ZFxY+mxvWr7rhPJR9mHE47vyaa/Y48DVL2+RJGYUBLoG7dz2TQjqaEdBcHCUyMzWClh1PH
	mG+ip1VwpzNAkaigzGKXArcNqlPviL0BYuqmrXXCQN0/ZlslvXAwRVKVIxygw6vrsu0gke
	Auin1ZhoWXMxex2HWNTwE8wdG8+aq7s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302165;
	b=CLUiUb5OqOxrbAeRy3m5qF0lUzleOpCwQYECNgU9WK1r4sNrRRfGHLHJCXnOd3BD31NNBR
	G3HEkZi+GtDsNiOzkvYaWANw7KSvekfUOomnveJxpnoB1b3jk0amvsY2kAGEJrOha7RgB1
	6MSxdq8DITKKTqE2RYllHixhweD8epg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ba3Pyp5O;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95A4E45731;
	Tue, 10 Nov 2026 09:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92891F008A2;
	Tue, 10 Nov 2026 09:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302164;
	bh=2Uxnm4Cd0mizACq2HNobDQRQcgrPnhEO2KA80+bveeM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ba3Pyp5OpjsLWNS18IN6KJmuJFLn691WGOW4O+tQFCTWln2eXYVZ3JE1wBRhcmoW6
	 hLpwpT4jz67cKW4CJB9uIhzhbMhfgiFHlr2CZK53VaqCwK5HM1YqSaiFHCScsFMBkn
	 Q0OzOCwsepsGyP/WRgtRo4+3FcZl8eUfyuWZ7KuL8XDVDG6tcU8rd25pxcEBVszf1y
	 XJvR4c13VrmJU77uH8rLkN68FB+fLrhpSvF6buW7PxoKBBbfZNWSogmUA09LLIYVWc
	 o8T8B1sqCgT2o3NyN+rjS4hlvf0pw7ESlo7MI8nYdimYq23hA2cdZ9j7+asrP+da9o
	 Z/f8j2gHp/WZg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:17 +0100
Subject: [PATCH RFC 01/41] loop: refuse backing files that aren't open for
 reading
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1688; i=brauner@kernel.org;
 h=from:subject:message-id; bh=k5rFTn5qwSY0P1NIV6SDcJMZmh5p3efbZZ8FHYDs+to=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejBVvfNKBs+f5kIhpoaev8LtD4oXZ1xL0i19ll21p
 i5fZsmkjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInc3s/I0OHqXaH2k1fp545n
 UtNUpkUwfzq4/7uEmpjnzfcNZ9bvT2JkeCygm5CxsPhqWqRgSqf6D/8dk2afLnMX1LJ/rjh/3zZ
 BPgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ehix1tz5x46xjwn7qaf68anr446pystr
X-Rspamd-Queue-Id: 687174000E
X-Rspam-User: 
X-HE-Tag: 1794302165-812822
X-HE-Meta: U2FsdGVkX18YkYUudM8BUE+vSc1TdRy2hi2jQlLkRF/+nFVPaE90D2aw6Qc1gOsc+BuQWi85OJvgo4U1Ml0SryXG6P/m5kHsSfWtT4oSa09NZQ2l1IYR9zhajV8ABqaAr2HMokKr1BAepd45+HZF/EC3KdID1C/0Yq2SE6daomqcNV5fqKW+VhVXofIRkesFO3E5uGXuyfsgu7sPZQSBFO1YTYYdD0uZf352M2Xwik/APZp0JK0y9CUBw4O1IipvoXRjomNioo0BPvFx8Gl035XaMofeP2WWontixIKuiClQXMu/THlsHOzQAI1wBobGmm0Rmg5G4wnH4cLKVyLIESnGGSVg1JKdZ45dNlqK4PhtuatuZKKBbBGM+hVal2BTX0jte5G6h2QGwuQaRFo76gwkp8sd3w5Vj4dCLGdIR1/MJIbVuTmOp+zURLHslcI8IzFMJJBTUU4gNzg6XytKUc7+decXM/TXsym3qdjuxHJ0dEriSY/g5tNvpBT9z5bd2lumCToJK/jfmR238VCQtQKMIwT71zDnjGsRZMNNT3SNUA/esbUb6aPzwjBevNmbugBZXbI814uJ5C6P3kgXJFcy2hs5TPVUTJ1EbyeVvR85VKqHDjcMsIkt1k9PaNiCQ9BtrL4WNkmMHNI+SVmi4r+wIuzG4dFk/RZU4InC2MsSRkL8n2y44Kj5fXWLWuFzdfssQNCBcKM0fwxjQwrDdXpdUPhWs0HbNGTXpKLE1Qka8DJVCzNlg04nDWLe688CO5MwavtOll/6Sd4GG9zVnfSNg8FCGWCnFx/p50FDPl/PJIggmk/x6AaeMTY6cs1uSQ3f3Q2uo3BL/yEfzd0AEZDE5wJG0j6XozuFXOvytppT4zcIXrkf22YO9XkKdB/hnwAnSShajs99TXm+BOQTuPJhy//RRRP88VQqLWalg+QpeULEb0Rdn4VB8YeDpbqTy6/NICLN64synV/MUWH
 O742tgHn
 I/OY1CcYBcz1AERbVMlkxSu3gccOwHQrD4Ex/bfWs519qwmMwHRbo4mPJ9CApN0eHZmLpos1O1JgjGx0VIXp0K9Z+hUJJIcLP4V2vUk+GgwHLPlpgDfbVaUUavRdydD6qMorKJ5VtOsjcqVm3gLb0ZjKrMWzboM2+qwiyajQiU89WKVvPQMLZpFgKXK5aWnlWPDrki+ezUIPxXY2JBYkXbQbWcdi7iGUFcTxUWMweVqlI7kUuC5L3M7iDWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

loop_configure() takes any file as long as it implements ->read_iter().
Loop itself never checked whether the file was actually opened for
reading. Buffered I/O went through vfs_iter_read() which refuses files
without FMODE_READ. Direct I/O has called ->read_iter() of the backing
file directly ever since loop grew support for it.

Since commit f2fed441c69b ("loop: stop using vfs_iter_{read,write} for
buffered I/O") buffered I/O calls ->read_iter() directly as well. That
commit was about O_DIRECT handling and the FMODE_READ check went away
as a side effect.

So whoever can set up a loop device can read a file it was only allowed
to open for writing. Open the file O_WRONLY, configure a loop device
with it and read the contents through the loop device.

Refuse backing files that aren't open for reading. Loop always reads
from its backing file so a write-only backing file never made sense in
the first place.

Fixes: bc07c10a3603 ("block: loop: support DIO & AIO")
Fixes: f2fed441c69b ("loop: stop using vfs_iter_{read,write} for buffered I/O")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/loop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a3325ceab484..c96e35c3ef42 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -528,6 +528,9 @@ static void loop_assign_backing_file(struct loop_device *lo, struct file *file)
 
 static int loop_check_backing_file(struct file *file)
 {
+	if (!(file->f_mode & FMODE_READ))
+		return -EBADF;
+
 	if (!file->f_op->read_iter)
 		return -EINVAL;
 

-- 
2.53.0


