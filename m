Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3B6606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=efVM9o/h
Received: by kanga.kvack.org (Postfix)
	id 7B2056B05B3; Sat, 14 Nov 2026 08:05:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7633E6B05B4; Sat, 14 Nov 2026 08:05:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C796B05B5; Sat, 14 Nov 2026 08:05:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4142F6B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:05:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B65BEC03EB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:05:46 +0000 (UTC)
X-FDA: 85433746692.30.FBFDDC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id EF9AB180009
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:05:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="efVM9o/h";
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661545;
	b=UT5u8mjbeB81bQpZDt+5R0CRQCj/b2XMl7O+GUPiqHvDygltIAw8Gg6cODHylHL2LqMmNc
	R9T2x0pMzqL/ESKI3sERjNdBZCkHwQKZsJ4anLp9o1pmHBpvrOkjDGzjgIcWUEjmR6kwMf
	I6xbCb8ROzLwNrrqpoLuuLrkZln8/Qk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="efVM9o/h";
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFO9l/21W/p57UQi3nxXvGylhBlGyaXo8dkkR6Kzl3g=;
	b=w+d0inhyD3qhjFE6xOLs6v7D3xOz/Oy1zquYk2uIjb/bZFgsqrhY7xAty3OlsrFGjXEUZ6
	0IPTIqIATt8bE17Q519IH3U5JQj6tI/mjyzAkE2VXTFnZJk4rVeJzH8ZIsu+JwEZ0Qe0k9
	S6wJVCwQJN5YVJAFQV5FvX4+ENIzgM4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E79A6234A;
	Sat, 14 Nov 2026 13:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1041F000C5;
	Sat, 14 Nov 2026 13:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661544;
	bh=UFO9l/21W/p57UQi3nxXvGylhBlGyaXo8dkkR6Kzl3g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=efVM9o/ht18LNBayF3D7oOTcXQ+zQCvKSlyCayqwAYKv8bDYhkCN28KsHSlR6cMw8
	 4vF4PVm13UDKS8+oQ2cZQEBkjysVe3A6Nrl6NtQAxof/K3X7FCHiReyLELP5MDb8hQ
	 d2gL2CxDePyruIvRh5R3YjiY7iLYLYQu27gg+QG4usERJo01RD8CffYKDn4Arsbfb0
	 kqmBhVnVPQD8zke3AZtVSBf8thbVIXaf/i5ZGVCckkNQ1RDwJaoqZxxDbFNlrAQ2pS
	 KE4SKdC5qQmh16hHjDsNJDaG6MSH9S9GaVw+gzEFRuyMQOhbFY55PU1Zxdk60HYVRk
	 7XRSI9AN43uWw==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:42 +0100
Subject: [PATCH RFC v2 01/42] loop: refuse backing files that aren't open
 for reading
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-1-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1829; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RNS20EKOa1D5gB/WqkZbolMxn0bhv9TmaIu0BLZLG3o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iEk7N/1b6Zufav+udO25utxD3izgpkPn8SDLhSpbn
 xXzJ6mEd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEfwEjwzfdzxP2LSu3zMqd
 fkThvaV5jphdtEzbnRkiz6M9DdgE2Bn+B03SrPulVrXhk4t5hOLZRXPS3k0t/7U6s9oxvnojx4J
 dXAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 1pc5mhhgcr5ts5sfq3roktgddjytu98j
X-Rspamd-Queue-Id: EF9AB180009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661544-996932
X-HE-Meta: U2FsdGVkX1/v4Rkrdz10duKNITKbJOSs2oOP6l7+AwhBbiWwEHU+zL3M5v/1MWcIbXahvD6N9SOfZKA3noLv40MjHqiHD0d17LPbzlTZFXz1l9Nk0Txy5IfBryHbQ26bVuayo92cmJtBC4ij/Ur04Sp82/5gr1T645UG4KJNz2Y1PJUr0BlqP7T7nR30sWvBrkRadvaWQBlchInZA6GA26P5NdLqVKi9ffDitNQp8H1BzpyBdiVtUXhDmBVOqfo2V+gmZ39mytlMQ1bcRyhKUJmw2a9cJzEDz6LhGsMmci4AeH7PMcxgKfCQ46ASdQ+vkZEtMiNfOaLE1QYRrmUn0XxgcySOi8Ut35OOJ5KThm74Nd+6hwA/R/nSbvwNk1IHPxvOfQ3eNBOYfroKD6OgQwpMl+4jEbrVv4S2FJ4CVYS5ND31vOkHYn4slS5BRYuEq1tl6VhgdcuZPv3miAXQ6MAb5PbkvxXimkogPbwWS5JdxkrIL/MkEiuyYC1XKv56pkFLzkc/AZ54CH5jgOhQ+huqWj/o2RloxUJy+Z2BA8IZJQS+9md6YdVRHafydtvr2D/YyJ1t/n+hC4oBNjmZEFnCruJ7K8MZEcDQ15yFqOQ4NEUHeNAc8mGuFD4IeC1ARJmMrjtVweeErUgGSNFR67Q7k1P5W8tHOKxbNmRSfZLDQhibB+68UNrhBz8s7NdNdZK0S1gT17Q0+Yj/jSfo33BzMzlb/tA72oBUaIMwXV/vYiBOPYQ/WIvdbyWSkIPRiago9L6yo6LAvZ9y6QB7w5td8Jlq2rj4eimuhkrjoISc8NJTT6dR6t1d0Iuae3xjvpbW/KxwV6RQzyaNBBZ6GMQ4PHfXX8UPupCsiLAKG9bNls1YW3+GGIvZ+MiMRtOf+xyaMsNs2uAUV0RPucUyGd5QivuqtPKj/wu8O2hPHzbVNhWnTIIF0JYTxcB6H8fmdovywJ2+LIxCG8N/QjG
 9bfD4rXS
 4TSrp3hkauxT3u7M8iWP9iTs8r26PS3rVZRlwa5DNMCT4H4pw09UClFSFsuDCZjrc9uTMR5TwK7ToCwEHrBHZBK//giyIED2QxSmaOym1VbRd/nsoS5sl82d3grw1UBILBuJpmnKryJs/WFgqLew529AFHGGB5Y32OpUaY6YNRWWPtdldMZNzy5wAxsa2bGVfz3CZbCpfd1S4cSfhxVkmUqbycrX/HV8uqeztWaLPIcLXpZltBIJsxgtF6Rc0k2HBtKye3NBQjVOQiDJutcwBMzVPR5btUFcq5Q1dxJzpLEOKnznia4fNt7K82A==
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
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/loop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a3325ceab484a..c96e35c3ef423 100644
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


