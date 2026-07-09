Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58935C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4126B0088; Thu,  9 Jul 2026 18:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462D16B008A; Thu,  9 Jul 2026 18:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3738F6B008C; Thu,  9 Jul 2026 18:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AFE36B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A335A02D0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:21 +0000 (UTC)
X-FDA: 84970683042.11.6E651CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 88B8140006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/2udjMJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpRcp/2dJk6gV7eAG1xmqQEL3beSixOls/uDr77Rs8Q=;
	b=MbD/1aW67VXtjLJIdGw13H+kMQwyrat96tz9qO8jPZK1ei+Snq4TFOvvTkGfp/5F3HLLRp
	XpGgdAJEGIJ/855kibqkTorWCOfOOrVLls7OlXzOBdPUotwjSlBDanXxtHBYq8291j4BtG
	5lPUgKo6+242YVgAVocXB3D3f2SFAHw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/2udjMJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636219;
	b=kB5vKkxcgJliI6FeSNOf9qBiZ5voq6NuCecwGv46Wmx+ORvOTCGm/xWim6ohd+x2HZcQQd
	VOPq7s0Cg+l69qSVzHWxd6TF1bYnujt3xiDW91fDKYT2lXDrJsgvcYSC6ZcEM72bIrbYc3
	jhshobRWs1S7MkddKY/tTBBsSxxq7NM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9469043D1F;
	Thu,  9 Jul 2026 22:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E911F00A3A;
	Thu,  9 Jul 2026 22:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636218;
	bh=dpRcp/2dJk6gV7eAG1xmqQEL3beSixOls/uDr77Rs8Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=H/2udjMJKhsRxr1MvEvq4eUPt+vKw9iK589MD1x2J7dTv4kCE+oEFU2IcfkPxCjuP
	 YkPzKqZemTAGZwKoIg7WFYiyjx/Ni1q57XqOcWkoX0bpmgtsEH2gibYZzRRL3IKbt0
	 Yb/kXjj2mNlpWrdZM653UCHCCenx8Cw3buKcFS4jcfKhiJJw1mT7Dhk3z2XNd9EGuC
	 kHAnuRw5NX8X5eFHLLLkPuWd4FskhVHLILyDT1ke2L+ezRUvUCa5MGzGlOxhKv/TtS
	 xIe55GnToFdt5tUzy2Jz8pEzl1A2gFqhvDDCRR2Xl1ODDiwkE9fRDqwxLPo/GNKK56
	 UY57bq5ggIXjg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:29:56 +0200
Subject: [PATCH v2 01/23] binfmt_misc: restore write access when removing
 an entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-1-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1605; i=brauner@kernel.org;
 h=from:subject:message-id; bh=t8nER3lsjLzcjeJujucgoUoGrAUWFYH7V6NQav6UZeY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHzNfVZ7rshjEgfT2v9loRPYj9RdS9xe+fjUw1kPW
 WcYuVaad5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykRoGRYcoKtfvZnEX5xtq8
 KtwpynF8d88c5F4jtuPxFfX1f9hypzL8Zj1oW7eLw/LtpmkXVbhPPHzw//sZmfUZtwQFJZgb5n/
 awQ0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: erwxekwhau6crh1wwcpgokw7ws1qpgq1
X-Rspamd-Queue-Id: 88B8140006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783636219-864356
X-HE-Meta: U2FsdGVkX1/m4Wgdt17aXsyCABryYiIRh3Ytff11w5V6N/6xH5rG+t3UyyRfqYS+sMs38McO6CZkQG+/FXz2VuH2XBLvECf0wsv7tabRA93MTwVMichIlwrQ/I1Y/8Z3EutNt4A4J/a8kicuAZukE3eTxocxYgSWH/fke8U8dTVpwSWXx+Gy03vKEEOwMw+o4RrOJDMJRbTyHg+auhLV4n+GkHWIZ4kjQhmy8SL7toC/83rneiihag3qRDvpAvol6XESb6+stDnseqC8caB6PIeFlzMc41U03G+zqOIISVieslMCWm4FkKLQQxCYrPaMC8rWEiTDCWVWsIt1I6lUh7jEMeF1ny5GQVsc6YWYGiWGVkdSuQj0YOOAe+dVszx3o2CebdEad1XdyWTVGd0/1LprEUXJ+7Gd+DtAOyZ3+Pu5rW1trgAmRXa9Rp8Q5avUuW3Llglc9QGBtUcEb2Su5lAjHUvs6+jx6NJhNWe+EgoPlHFH+SfWRHE40UKj2IVzKmzEpWeNInerLn+YR9CZEM6/PFlrwiNmEqDjc3yl9oAQGZQ2GeyiNyBbDkPQLTvCWWEQMyEJOi5yE1YTFw+R4thScIrNkulVfRnEY/Q7G6De61G5IGDmXSrt7ZxazB1ukHJrRwQNplQ6frD1dubki3DrhnBSLqeC/t1lOcwQcvnKbfO8q2vOuIpv7qNIAsZrhVekRSql31SLfFlAIxW0cGqCKVKPhWQe5N5LE6L4w8v/QRHSykp8XryjSVcXLb4sias8C5mOEtcRmk4SXkUTjnP5ZA2PiYkqSAaYXSG0Q6W29n3T2dYtvg1xqVcHXHEo1r+qnKHpI1JdNeSgY0XjtkeZ0VUwl8sY5617E5odY7z+awNF7Hj58mRe5EuMAo51KaDyhOk2OYC69tZrDQGNKm6o0o7vgH5ZPAwPTN0g0M/aig3JspFQnSQyoDPe91UPMPmOXGJWEMTosoteMZU
 ZxLuK8uM
 /xOW/1K+PsFRanKsMY5O97XY61uNuAJgGP1TUycsjdLhg/X5nK+Nj4WGopNXuXXPozPfrx7abGXagjf80dvyDen1CKus65h5mAqf1/HlrP/KS2te/K+sAJXqsMJSDtlzPS8EbTzDwNzngIEDsMYfy7tf4VfJkPhQ8jBAbV2wEcivd+n5CRNpyu39Ot72v1zyK4EmpaHc6c0OlCrN21JCzcEpvh46I13Gph9i6fTE/M1CTMa03H8dzEY84xW7+XheJESVcaEpuPjo3k92MBAdCBwvn6FubHKtotMnYmzO5YeMIX+2xi5k1lrBAFfXbs5LVoaKeX+1owWo3ZeXSIBeogmKZkgrrkbOvI37KHEuv9b5eDesB2duV/IPg3JpI1O7uW2kngK3Hw3XzTXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Registering an entry with the MISC_FMT_OPEN_FILE flag opens the
interpreter via open_exec() which denies write access to it for as
long as the entry exists. Removing the entry closes the interpreter
file via filp_close() but never restores write access, leaving the
inode's i_writecount permanently negative. Opening the interpreter
for writing keeps failing with ETXTBSY long after the entry is gone
until the inode is evicted from the inode cache.

Commit 90f601b497d7 ("binfmt_misc: restore write access before
closing files opened by open_exec()") fixed the same imbalance in the
error path of bm_register_write() but the actual removal path has
been leaking the write denial since the introduction of the flag.

Restore write access in put_binfmt_handler() before closing the
interpreter file.

Fixes: 948b701a607f ("binfmt_misc: add persistent opened binary handler for containers")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 84349fcb93f1..de50a7468b07 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -162,8 +162,10 @@ static Node *get_binfmt_handler(struct binfmt_misc *misc,
 static void put_binfmt_handler(Node *e)
 {
 	if (refcount_dec_and_test(&e->users)) {
-		if (e->flags & MISC_FMT_OPEN_FILE)
+		if (e->flags & MISC_FMT_OPEN_FILE) {
+			exe_file_allow_write_access(e->interp_file);
 			filp_close(e->interp_file, NULL);
+		}
 		kfree(e);
 	}
 }

-- 
2.53.0


