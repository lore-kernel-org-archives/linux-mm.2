Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E61606C67F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WqGsamIv
Received: by kanga.kvack.org (Postfix)
	id 360FE6B05EB; Tue, 10 Nov 2026 04:19:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337A76B05EC; Tue, 10 Nov 2026 04:19:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227066B05ED; Tue, 10 Nov 2026 04:19:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F23D66B05EB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:19:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81A34C037F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:52 +0000 (UTC)
X-FDA: 85418662224.07.8F32316
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id BE544140006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WqGsamIv;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnImahtJn5lfCdVuO4byE9DJbFXiWtZ50f1CyF0t2Q8=;
	b=dyTNqMOy1OsygfK+6rO6YEyndghnMO2opsrjIj6SAt8Efmkw26/m/fazxrFUavEGE71u8X
	NX2ZPOPlXzR1je1vSeyeQCbhZjbU6luv4h+lQU6o7+8DsRuExrjoSep+VZ8H7gjYus5Ek+
	En1HK3HSovbVkjkI/cVP09eMrAbQDGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302390;
	b=JIIJ+fD2rvcmemZLt9NvaXtQnSx8YDDvVcNz16o1qm14pkc6ElLeX77SyNwYo8JHDp2S6U
	ESoab+5Y+1sDPIRCY+00OUYle/1zhQCK5ZqTbqZN8a8ZJiTTdzG8FvBr/haA+34lqFFik3
	lJyp0nvQLhWSsinonVIOhPbUhAyPA2I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WqGsamIv;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FA0563819;
	Tue, 10 Nov 2026 09:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DA11F0089F;
	Tue, 10 Nov 2026 09:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302390;
	bh=lnImahtJn5lfCdVuO4byE9DJbFXiWtZ50f1CyF0t2Q8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WqGsamIv3dtdaZQphHLu2DsjqE2y3/FcP3C64OYa+8HjMiTSq+RUo0e7SVbClrF0O
	 Rn64RbDtjIQ3O+Vwx+jQosyxP133oDpbH9LaXZygD1MM6NsgOa8bfIBMBWinhY4voF
	 I9LMB4dtUD9EnoSvdxBHOJx1kUnEZi+cO6zl0AnUxitmo0r0cS4AhTxoDqU/IE3/8N
	 uJ4rAQbKeN2qr/1Nlrm7L9UeP+8U9vKXU8KBqCqhmY0R54patPnEALsIObSrmc3hKW
	 Bz6GWE9fyD5MsVicN0uDrDB/5zSB2xN3jmDYfNnm8pkYJ/yFyaHVRy4YEgK/zJNLVt
	 IxoVCfI/XEEcA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:50 +0100
Subject: [PATCH RFC 34/41] loop: refuse files on pseudo filesystems as
 backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2497; i=brauner@kernel.org;
 h=from:subject:message-id; bh=chnbD225AeAwL2r22LyY9vS4RRPeXQFSJ1x6B/QmHi8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erD71lG1GUFqk8J3zhE9HKjc6rfqomb6Dp9nHvd2b
 viaPiNickcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE7v5lZPgek5sy6Z/MydVb
 5OSibJ/WcXMc/DFdcI1ZQY3Sv+l7b1ow/OHYs+VfAseimIV2yX857n1k8RKW83f7u2n9y0MtbJd
 Ss1gB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: b5giwj31irjguyx188zgr7zwya8q3i3i
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BE544140006
X-Rspam-User: 
X-HE-Tag: 1794302390-357801
X-HE-Meta: U2FsdGVkX1+DVoCqfODmIlhaEtSGoTDtCJqa/s7HZ6EkOU+thjw7GCrqMgI6JakhJ9r8bFXLAl2N9KI21/vBJmAcQGOmr+x7XS0UsVfbVxRuG2AG31lIy+QL1+Cs4/XUCh/spG9iYJnjU+hzIlivSGd9LZrsBhwR+1vnXKeVzhweani5VKDpdFsZYbPPOGcp3yadme/A6HEKz344kMP5XtNcpkl42K20xDcAGIuKFXH3RnajKUYdRY5QxYZLz+lpZBeaqg4gr0ypTBRH1GJIEz+EvlrISjWzifeDQVAz2qRQ0q8QKKYpWwFDrat8Q3dsKbYY9saXup12Zzow9cFv21hgZ05AOLl4ZjuXK7L1j+ndSS+J2GMZ86dp0PmO+2UiY5v0v1w2+OAmbHVPsjuRIv4tnTcbXOs3KQffFO8GPmd3s+NL1xxFWfaFtLviBdlQo9r9DeUUSGWw3jgAmRP2CfjzJAcWuJP/oackZBKgjEIGUITagrCgCBAj1YIjfWb+Ae+Aa5RzZbF6SLAJt2wOqXgm4VzuUwG+udfXZzhHkKcZ7QAo4NdwCH9H0KXNmTHPVSt/9Q3t46cL5nS0+m4Bf5hWUIXDibh9hmNwNqxghFbzPmZs/NR8LXVggd4yMBm3YX0diaknLfbnesr5eGHRhNRHL82HyaAIlxesFfwA4RX35cyPf63RGhcYXtG12SHjSa5zFiZkq83fJ4585H2WIQoslPdIU7++Kj+BZAhc4fuMAlI2OMEiHkngoBdrJlsqXeINfephE2nHgw4NbOZemyCd2x8klcagIXgUQy4j+kyOIdyFNAR52+ms2LVY0B+xAd0kMQEehe35BERj/qPMGxYNstVkwHLgiArpcrKJufbWSWt2PABOtCEso3pEPpHFT7twVDTCS0LzVYQDSIBbL8foeZKKEqYBPi7H0bFdi0rcBJtD7mNdbH/RLNrTVgQVmrFIC9pKbs1/nDcpXfp
 Eojn/td7
 0BsrgRJ7qTBt6OpNiEtnDRcPvJCma3r6bYplgmnAbh1EED/h7Ws7mlozShqW93mBdBvXMUziYdEAykhdOeqMCXyI9wF3hb8Jq3HWzHIUBgC8f8dOy1MKRLQBZIH47nnIprtsocjn+aUyWV0HAum7ycoJjtwQ2Q9l5ZFDzSAYFQyWubilyvg4ptibrsi9uglxYcbZ0FPGHA3lzZfHeZZlJBwrA21PrmU+xNZzFC1eVTzaxaV08Rlt6mESYLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently loop accepts any regular file that implements ->read_iter() as
a backing file and any that also implements ->write_iter() as a writable
one. That includes files on procfs, sysfs and other pseudo filesystems.
For example, /proc/kcore attaches read-only as a loop device the size of
the kernel's virtual address space, 64 PiB with 5-level paging. sysfs
attributes attach read-write as 4096 byte loop devices. Writing a block
to the loop device of /sys/kernel/mm/transparent_hugepage/enabled
changes the THP setting.

That's not just nonsensical, it can be abused. Loop calls ->read_iter()
and ->write_iter() of the backing file directly from its worker which
runs with kernel credentials. But pseudo files enforce part of their
access rules at read and write time against current. Dozens of sysfs
->show() and ->store() methods call capable(). Behind a loop device all
of these checks are done against the loop worker instead of the task
that opened the file. And setting up a loop device requires no
capabilities, only access to the device nodes. So on v7.4-rc1:

- uid 0 without any capabilities can't write to /sys/kernel/reboot/mode
  as mode_store() requires CAP_SYS_BOOT. Writing "warm" through a loop
  device works.

- uid 0 without any capabilities can't read the files in
  /sys/firmware/dmi/entries/*/ as dmi_sysfs_attr_show() requires
  CAP_SYS_ADMIN. Reading them through a loop device works.

- An unprivileged container that was handed a loop device can't change
  gro_flush_timeout of its own network devices as
  gro_flush_timeout_store() requires CAP_NET_ADMIN in the initial user
  namespace. Writing it through a loop device works.

The same goes for hard_offline_page, the md and sd attributes, rfkill
and others.

Refuse files on pseudo filesystems as loop backing files. Note that
file_is_pseudo() looks through overlayfs so stacking overlayfs on top of
sysfs doesn't get around this.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/loop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c96e35c3ef42..1482580a1979 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -537,6 +537,9 @@ static int loop_check_backing_file(struct file *file)
 	if ((file->f_mode & FMODE_WRITE) && !file->f_op->write_iter)
 		return -EINVAL;
 
+	if (file_is_pseudo(file))
+		return -EINVAL;
+
 	return 0;
 }
 

-- 
2.53.0


