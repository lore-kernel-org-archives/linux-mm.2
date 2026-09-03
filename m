Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 449BDC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144F76B008C; Thu,  3 Sep 2026 05:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6296B0092; Thu,  3 Sep 2026 05:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F256F6B00A5; Thu,  3 Sep 2026 05:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D35846B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:05:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F576C048A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:05:23 +0000 (UTC)
X-FDA: 85171867326.21.DCAB7BC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2E9BB20003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:05:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E7+9IUPX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IxO8S6L0;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788426321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OsQyZMa+a6GTeNgszTa4JkkgsOwEiJ5IGoTKayGkFxo=;
	b=VcbZRA1LdvTqZmvvnGrNEu4s8i3l2qJTX2Net/EOlkv7o6fE7i+25KSjyoUKZPyAvIIc08
	BirmCtrjtUWj4NIAdDPC0DX5cVsqT9ekz3VlibptKJ4E52ImEwDKuc5Dpz/G0Omyw9q5N7
	hBDYIpoSNkXqlyGcXKhlj2dXKNYyiko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788426321;
	b=A0F+XThwVJn7iyy00U0WFD7e90Htz8gLUCDPAMERLoRPAqMjo+IR+e9otz/NMKegF4Hstz
	YweoRm4exFn0YKf2Xy0DlRjkwDFlGcD6I3ZyFbDwZi0iYRbw1ovV9LZX8QW+F93hFrgE4O
	9wVN2AfeIN8ctRSH+bzUEFWr62Drn/o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E7+9IUPX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IxO8S6L0;
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 854B81FE0F;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788426315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OsQyZMa+a6GTeNgszTa4JkkgsOwEiJ5IGoTKayGkFxo=;
	b=E7+9IUPXgsXjhG8C9EVGTJYzFboyZ/ZhXYg0QjiFFeIkrcvcaVDEoBbSJhcjBgfVPx65tD
	c3S5hJkxUZV4fam/ttAtlq90xnGVtTUSpNm0OU6t0X75wjuCe2DUOvq0e6AxqbqaLWEEBP
	kl15cDDfHGV3Ug040edWP6Qi1ClCzH4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788426315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OsQyZMa+a6GTeNgszTa4JkkgsOwEiJ5IGoTKayGkFxo=;
	b=IxO8S6L03zlA1aCbkz4Qc6/Imcxhs2wpP48AtLSTqglqHtZklczBJHdsMXIiT6Wlc5l+Hq
	p6HeRHtnLoAzIrAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 65BE913736;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AqTQGEs4mWrCTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 09:05:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DEB52A06F7; Thu, 03 Sep 2026 11:05:14 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 1/2] ocfs2: Refuse to enable ocfs2 format for another filesystem
Date: Thu,  3 Sep 2026 11:05:04 +0200
Message-ID: <20260903090508.1360863-3-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260903090053.13120-1-jack@suse.cz>
References: <20260903090053.13120-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1148; i=jack@suse.cz; h=from:subject; bh=3JBfHEUmQEeir0ZG+UiiHyOtOKEAxaWjeNMa7kJX3+k=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqmThEFmm6om3WsRZLTl/+C0uVUKHZ1z7egOZZA trFRd0xQqSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCapk4RAAKCRCcnaoHP2RA 2eivB/4n++1IPW1VQWFADRVpNtb3Hvf6wN+mg9r9TT7CbmTValtrtGUS1ZAIrGKKfqAvjFxESXJ YWxusz+sb/C1wNJNsbEADwqnIdnh7Nddy8RWR6W4HtIVSaert8xH3BfJwWogzQanYxk19JsUXZB I9rrlb+x849KYmkUkD2Ejp2AjjlX0jZdy5COuyib7evecpSbZ5Vwbt0LlXzq3FGf7OoJdQEvXcd 4tbnmrtYXGLP2R0ndmx2mnaBiQnhZeDA6rKPajG+oMAvZ9EVeC8kshYaqpGfEMwl4e+g6N1MWUx FeKs/1EZbijzQYDDh976hDxe32avwAuqBEY2+P5+H8iiiV4v
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2E9BB20003
X-Stat-Signature: 73dz8hobw4jq343ynopj6j68gexdjnrw
X-HE-Tag: 1788426321-865034
X-HE-Meta: U2FsdGVkX1/EyXDXEEQOdkcJb6Oi+vUrJbudw6sq05NBJ8pRid5LAjkURndkhcgYmTGoOeWhkXiLk0d9DlJDSTkB/DLJjoPgouBe899I9BYmuNYGHJC+RcuvLEM0WtZRn9XK3Zr8SI1YjfwROk5lla5ZswdK2q/WQ1eQ1h3kjX9+eQHMP7UnbiZlbNUQMgVp/KF0PY+4r/ZEnwF/pDckzz4BnQ4TuV56rtAVtY9CQU9GmtOODI/DdTy/53t8VXmaILHXCe2Tgkf5NmRI5DbrCvXQdK1gEKE+PVktGk51ELQbjncU1bS8sYk5ONblYdhnBfHLLmrJ10P2/PcpuLkszxH7t+I0n/j4FvF8WY5niClnNGB8ghg++jGWsTXr5eCdi5WqIUoRC08XEcutEhjRaKJoczjtWyqZFV1mvK/nJcTg6S+f+lvLRYnO3+UUVvvjpInMB8PQDyVA3Au5hQ6zMare+T0kSiakYPOnAAqV3ixr39F/PLCwQLnZd5uuILcI23kf0fklGuQEPOPVPkd3WWpvk2otKCdmCe6sMYnPbyrQnOb38n41cKBOHtuZ9ftql8eEvBqJAFE7VIqCfGoW4tbzDFPcN5vy0iJaTTn4OXO7kEJtfjvm5iyNbRb2Wj3TgJlloJ2+x5LLANYe6NIqJEr7kmJUJiJIE0mDpd2uj+ROeyex5a2CuHuDaZoNCKgzFN6CUxIbfaoS3OHa4jI5IczPeaOMIRIo3lp0zJuo8jQubydFCailLgxOfmzx1H4ZEIW4tie2js3otnP4hWvZBJaK/XaBhsNDDKl5aR4FEuedAxuCdiMf7A61dVdcRE+BPgoR+hLuwDdVA3EHpAgE8Zd9nn31rwpk53/8wTgME8ydTwKtZEOqSXJAzUdRqPo4N/b/EbVTbOgd6gxkzciCHlHse6HWq5J5cnulhOpTJz/p16Y0Aj2kM7FhdnpBpgANt24FsKftRV+NGYzpQ3y
 MHJ+jZCo
 4AeY7QtKr7/WfWHLAmovMgExRI8IRYz+SNPylOvWVCUP8svQ7nTm2ljdghQS5RS+nP+pI/aFeMuywDW4blM9ah3J9dgm1DiHzduQaH2rldGRge3LYqOAPLgeophYgANGncEf+j/3t9xliFQ/XGYqiwHmn/Yyvfoqj7AXHbhDCLlBITYFXG8rxe1cdHzt16T/rSYHQQvMzh9GzT9SCK5uLKSvKPrMHMG9SMab7isyspFdsB7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
requesting to enable quota using ocfs2 quota format. With suitable
passed arguments this can get upto ocfs2_local_check_quota_file() where
the passed superblock is from the ext4 filesystem and that can cause all
sorts of interesting things, most likely crashes. As ocfs2 quotas are
specific to ocfs2 filesystem, verify we are indeed enabling quotas
there.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_local.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f55810c59b1b..a2b276bcd0a8 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -171,6 +171,10 @@ static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
 	struct ocfs2_disk_dqheader *dqhead;
 	int status, ret = 0;
 
+	/* OCFS2 quota format is supported only for OCFS2 filesystems */
+	if (sb->s_magic != OCFS2_SUPER_MAGIC)
+		goto out_err;
+
 	/* First check whether we understand local quota file */
 	status = ocfs2_read_quota_block(linode, 0, &bh);
 	if (status) {
-- 
2.51.0


