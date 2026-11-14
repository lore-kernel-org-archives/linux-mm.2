Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D9E606D2A0
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHocOdW6
Received: by kanga.kvack.org (Postfix)
	id 5E4726B05F3; Sat, 14 Nov 2026 08:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC2C6B05F4; Sat, 14 Nov 2026 08:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D16E6B05F5; Sat, 14 Nov 2026 08:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C35E6B05F3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:10:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB43A1203DA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:10:03 +0000 (UTC)
X-FDA: 85433757486.09.004AF45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E256580005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:10:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHocOdW6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661802;
	b=Q/20mA+I3B42R8XBI32i7Ae+fU//1mdxL2sKl6eRNHpM2HtIT0fCqclmAORD6ko9rUHzP5
	LaQHHHv1fKRA+jpysNcg28IT64oh955PrR+A/H0Cu2FMv6E05FgsrJEHSKotY49qWMiIhm
	SDUmu/msnckl6bJQHmMlvfAv0wbiaFc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtdVhasomzr0bfxo27t8Irh0dfW28m0T6GW65uzhTXc=;
	b=3/HkTLzN3eQShg7F5hRq0ViwJjt+VVDuVPa2cBQimDWUSYDFRJJM21E5RTi7cc41dtfnK7
	vjux1513/FiCLDqklSMrcJMS36JnXGpfV9BDHfjYoiRK/XQTWkfa7iDW1AZBp3oT2vbnWw
	JuKD+WFGwNtuorPFPoRzU/t7uyiwFuI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHocOdW6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4162140C03;
	Sat, 14 Nov 2026 13:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AF01F000C5;
	Sat, 14 Nov 2026 13:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661801;
	bh=BtdVhasomzr0bfxo27t8Irh0dfW28m0T6GW65uzhTXc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RHocOdW6W3FpasM0EYmnFsXgxF36o/JK6WS2DdytW5tVYqJjWMISgUoBOsWmYXoz8
	 8cuAgHtoR3/4JGCuVTBVa6TNJzyWo7Rn8kALoXvU81rS7TBOcX/WeoOhTQDeQjMX1N
	 KTmcoH8tEAJXXnQi+46MgcKsaJ74xkFRIMalxhSu0fRwUdgfRAmprIgYcxclGQpVpv
	 m/OYB5cOGueEYAb6sJxKMVFXTu9cdUT7Nz1FJ5RJGAOqZBnLtSGyEic+ZCGuIFWNTT
	 NyjKBdSXxoQ0RtqgYl2GTfzZ0SkSuzexfL2JtdazdHQZOrpYXI9dQcaGC8BVxNjlwb
	 I3tgtCasNQh1g==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:19 +0100
Subject: [PATCH RFC v2 38/42] fuse: refuse files on pseudo filesystems as
 passthrough backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-38-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1390; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2GPVGdPmuRydfdxygQI1vepom0ppxgkvC8v8Lqvdx8k=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iJnomXd12pWfUVWTpW7s1uFaJbz65rLkQEZN5j6RF
 KY/m6Jud5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEW4Phr1xIEuNTx1T/Ht6n
 hlVu3fM+HJX4fO0n7+/d4fcSF9yrfcrIcJjh3o3qm9JZX1wXNHfOCRb+0heYGJQ1wecpZ/6UMiF
 XTgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: E256580005
X-Rspamd-Server: rspam12
X-Stat-Signature: saykj84yb5ssynzoku6pk4sobbkc1ton
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661801-891086
X-HE-Meta: U2FsdGVkX1/8FISrYUbn/Q4X2OTlCYEB/WIRdmZHoRNTs5z7Dr/baIt0MT8DUtlxs3cf/NukIOMtENlwGiJsTFzOftI5bC1s10qg6Wr+1zsYQVIXmNn5sLvP5uBwH3BJh45OvNKulG+j9GKS3JA9k7CbPibaYuHr9v3oMTTRXMWZqUojM+HFgMWmTBpPSzJ0MqO7wuNWX8h6/z+iPyY/HIA5snhxoKXwfg666klmgt7sLdVfhNGKzonSVbF8K451jhpHrdO5hEAeRuFZ9iTA4qNNZ67OugTQprEmbIyat8wP3ON3vSWv1vwHwRnYR/n64RrcwfebPxgW7seTDka3CA5AgvfCeojAY2I+vvy8152K8iTnqzRW9d0NJDBIEVxUgyJO572LL5WS9mSXLN/AMHUd/FnDAMikTkS+bONZA2PNGJjS45M8PheM9/9sylyhfAziMVs7fIKxvO8qkroiPur/Tje/ku4RVOpaRRoLCNxX6FqB0naJAGgYOE6fP8jg90mKMPKLBLUqKiCDv3mSgKEKEWEIBx1f59s0IXvDWTFGO2NNpnHr51mUFLZoSaxPzgtvh3Ip2AuGMG+aY7v93iLS6zvAEm4Cx2LggyG8tMRfiR6hpYrWuZDcaQEsMe6FdbI6xTzCi4mUkfYH5oxdyNKTDMNvhWupicN8ZPAstNotnofI+ieCV1/Pm6tKG6+3+BcKsyFHEwqDK5LkOITq3UOaKSMdBM8GliiysSb91XfB1ssuYHQ5oNMU+xEOoj5/3xCbxW8NW7iDZZmNDsV7zavM/I5R1mc62RqhoqUTagAl6USTOIzrWES+ZGiqLNKfdecE2Lv1ypAoOolCRsfircSvuy1A3MZRqZ6+13QK07TtimIfF1BE+x68Mf8SbfO2d8mifoeZzVifdxyieA9QTOuT6uVxK3PUT8Qz1h0u5GTlTsDCVsaKbbEMUl5INLHTucjHvNDLPbEdbInoVw8
 OM5WcKCp
 nLCUXNGufzDlV5WA5ixhE7g8Chn90jfSFWijbbn79HyoSwfEgInq/ofBeNNcspxia9LAYe6dTe8gZ4u2VAxD3Y/SQVkG2OVXIMKdadKCaAIgtpV7ePMekFhNbFhwDP/fWqEXRrHgJtft0NYCnUBNz2xgv8hGxm173VuRZDsQLEjWEL6spcFKf0w41OwQGBYnfLSp9e5aSLTSdcZQclI53D1zX4cy64iYJ8EN4HJQcucG1ks6LWx21CWd8TZ0TizLTcwoTjQzVS9/4+Q/clTmcPpWFvf3+pWBhxFL6AS+9ApepwcPjxorbpiVgeFvmVYmy+V6HsPYoUALu22+wgr60X6/ONp7WS2cIMOhWtjJ9Nd90XXbmnVPNf9KM/Tl+1KpuDQBJ66FLbrxURnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fuse server can register any regular file as a backing file. procfs
and binfmt_misc files are already refused by the stacking depth check as
both set s_stack_depth to FILESYSTEM_MAX_STACK_DEPTH. sysfs and the
other pseudo filesystems aren't. Reads and writes of the fuse file would
then be done on the pseudo file with the fuse server's credentials.
Refuse files on pseudo filesystems just like loop does.

Note that the backing file is only registered here and opened again for
every fuse file that uses it. Only its path is used and O_PATH file
descriptors are allowed since commit efad7153bf93 ("fuse: allow O_PATH
fd for FUSE_DEV_IOC_BACKING_OPEN"). So pass FMODE_PATH to
file_check_backing() to keep them working.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fuse/backing.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 8c21a8a74efb9..7527f3ecb90dc 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -147,6 +147,10 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
 		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
 			return -ELOOP;
 
+		err = file_check_backing(file, FMODE_PATH, 0);
+		if (err)
+			return err;
+
 		fb->type = FUSE_BACKING_PATH;
 		fb->path = file->f_path;
 		path_get(&fb->path);

-- 
2.53.0


