Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86999F483C8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96006B0088; Mon, 23 Mar 2026 12:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45F36B008A; Mon, 23 Mar 2026 12:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6BF6B0092; Mon, 23 Mar 2026 12:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEB066B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:30:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E9151A0C5A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:30:37 +0000 (UTC)
X-FDA: 84577866114.29.39334E0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id E79761C0004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:30:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vnph5DgT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oQ7YF+BW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=O0+9DRAy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+RteFXbC;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774283435; a=rsa-sha256;
	cv=none;
	b=vdVmO4PbP0RnGiUX7TeCREs7JBWa2XExuHrV0elRhCF38t11r8WttZ80sJe2Q1Djr5KS+D
	iQOvMPJ6gdbdhvCOqrEUiCeLQS2dpWE+KhReiXTtjow2tcBcy9nHL8km2rZDgJUMnsBYGK
	QvdAm2IOalOhB1LxPEb/TvShrYYpOno=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774283435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNdEBZhmsc6hucLIl4T7bCxD9jPms0lHLZLnsrtP3RY=;
	b=M++WM1u6m7t8egBJHhI/VhM7m32FBsD7qo7UsJ/GERZeBlg37OWACcYaWeP2+VaeDtKt1v
	Ps4q1QmQM1C7vFl6FbWse0ZJb/kl2qBQGZVIQGqW2KSxfVHtTlGoSp7hWmaLHe/AUo2LcA
	SuxxEzL5u0jvuO0ZGT9HOFandNsCXBA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vnph5DgT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oQ7YF+BW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=O0+9DRAy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+RteFXbC;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1FC765BE47;
	Mon, 23 Mar 2026 16:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774283433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kNdEBZhmsc6hucLIl4T7bCxD9jPms0lHLZLnsrtP3RY=;
	b=Vnph5DgT2nV2ZAC7XCxFcN9qE7YevKBUUUJA8e+4iHRj6e8Uew4OUKOp9jx2W8P8S6L4eR
	ehK4fgOx/lt4z+wk9K8EdCDS3k95ZgcYVWb3lpujHbBuSx+3vqBxPTtVoCVYT6NsJjXxeK
	DpoD9cquCS5CgcyiWd7Cg6QLlXlNK5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774283433;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kNdEBZhmsc6hucLIl4T7bCxD9jPms0lHLZLnsrtP3RY=;
	b=oQ7YF+BW++dZ8jioZswvtnLoCNATMWv9FJGnDRUzEQk9BytpkuNxcpU+Mke0t9K+WIvdHj
	tPohrXITm3MQxRAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774283432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kNdEBZhmsc6hucLIl4T7bCxD9jPms0lHLZLnsrtP3RY=;
	b=O0+9DRAyTBzvTVPowH+3MjZJbMIw7U1FuyfkyrbU/mWEbIltcYAV4XKloymrJ1QXjhZOjo
	umulhWLmIYmTK3K8K88+NwZWstSU2Sa6+cTAtgDMShzqPS4SI9NIhOU7YA9+z0yWrSfZEE
	WwRpvXNahhZZazOl+pF8VMV6CEi1MtQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774283432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kNdEBZhmsc6hucLIl4T7bCxD9jPms0lHLZLnsrtP3RY=;
	b=+RteFXbC1XKKxrmjqs5+JIHqy8fOOZLUrauz5SD8u872TBzgJ77mPVANYvwc6YBs48zF2V
	w09D/7vWGCtDEGDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F6BC43984;
	Mon, 23 Mar 2026 16:30:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U7a/A6hqwWm7IAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 16:30:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B9CD0A0B3C; Mon, 23 Mar 2026 17:30:27 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] writeback: Export folio_prepare_writeback()
Date: Mon, 23 Mar 2026 17:30:11 +0100
Message-ID: <20260323163015.3734-3-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260323162617.2421-1-jack@suse.cz>
References: <20260323162617.2421-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1899; i=jack@suse.cz; h=from:subject; bh=drBU03f7QI88s4x6d0Lpqfmv3CW37W7rs74N1PvScuE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpwWqY2uE6LQXataL8c4wj77Q2GsrSlP23o/0g4 StFXPgh75WJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacFqmAAKCRCcnaoHP2RA 2W1ZB/96GkEQrkRMbG6QYX9NArHU5xZQowAPFMSC1QChSiy653phew8l5zGucUjP54BozwKlWdq zgBVOXXbCHe090Uz0T5M3JMlrz+tW9eqqlb77iWvlq23CESq6FBYd1mGhcssziKj2yqWcBcoOK7 2dgeJbAcHGVOSZAOKixPVIIa9tRS/ijArlhKy9PTEW+EHWNjgjWiAroxdyJzK13ohRYSkTp5viO 6ejKSQJB+2I9LTpcZt37Ph66fJOrAYH8GREUQ8uybiYvJBzWMollG2J5IXfjUnYaUs4unGxc0qr VIfOMgKVEHq3kjRt2U9DDp+tw0aObHuWvjJVI4WKjazioMzw
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E79761C0004
X-Stat-Signature: dyje6baa5tqgwie8dgbhopqtnpzjyuuw
X-HE-Tag: 1774283434-418548
X-HE-Meta: U2FsdGVkX19Hr9vyDEQpAY12ui6DB63wQX3j6AmCcFU3ng326kiOG+38EDlQx6Ouoev2TYyuCT8Yz5t06zMcceUHnszC2qMbO/8Nbd30tTdQ9h7V30wostFnlhwiZI0cA/uTFAfF8SLzbNkLN7MiOLTZry83Xqknmp5gCmssRJ+hOCR3qGFiY2vzrYm5no0IrPNmbH505SiumprE2UAHN7sTYq+FJ0PZ+9pKIT0snStTOu8EOzMlgnw3Y6Wb4aja6CE5kfGgnCaw2Cv1z9fLMcrtxJTdkhfMI67Vba92X3w+Yat2jrzB5DEK62hykS7CEVfzkgSzVkc3y/EKKG/RA8kPKNDfVRVd84MWJ6zxhNHOw6RWYcRwZKPPH0s/+ai0AYu72i4iuWOikct/dxl6Lv8/ark1pgwIELFCocwyNjExMfhIIRCAwjiCZJiK/nXVHI4QCJsbGY+eIILgz6tXQqHYRgqYwh3CgvSdFMPWYrklb1H4wD2g4bHivi7Q1CeBwtNK+GEntEDPIo2qOOYLodZcDZvObDDoZnE1p0drwwQUdGbggmNGYtpBLfNA2eynFDQiAqfJBO4TAo1JH0FxITAiFL3lMBM1XHHa/PHsgyBx0pojUw1b0Xh1Z7Yd2Sf3H8nQbvTpHXZjgAPx/Zg6QS7+QKyh4Qe2moDeH/SBHGy7u4lHY8PjLOkWso7of0AQ5NHS9FPUBjA3NAxM05TveJfyu+tuIYnaV9cMETZ7TSBpqYaEqGKYzJCmsS6Kf13hm1I/IK40wJvdbzFI+xc7GMLHnnAN6/ElvVW4nig5inJlpyngQvx06KD+OA6tRStzTm3uSZzDYnxLsBeyAp6mL4rNHfHZ4rWmnXlCw0gw58rYI3ocnGQZw9x7Vsm5dcVykZ1ZAplm785f8sLRpGHHAZRjYCtRZIJBKgc/J42sPx5LCe8LVJUqHBMmnicEtpkSzslH31XOl2jiGL+dPVi
 43fd+6vn
 nWMoosX/PvigJxsx6xv82n0QI52BPPrKtQFhsyQ72C9tV4Hdz5wf0GTEfS5rv8AgxMXZyvHRwfDihOhaGtBk3sgy65ik1X2nX7T0ebBSFTR+TE3YFBIZ+gHgFBcl4GGqfPo3GA5k++cCMDexhsvE28sEcSGAogffv021Sw0bqNvfDkMaOm49leg9dskT6DucYxhgSd7xRw0l5pJ/qKRxYm0XApzFCyHQ7H78Bf7Q6kJsxFQrsaRuy6tXHinR9iNoLenS41+kUAwHW5ShoqZZD+w5IVE3dZeHJ9bv0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sequence of operations done in folio_prepare_writeback() is needed
practically by every writeback method. UDF is unable to easily use
writeback_iter() for inodes with inline format (due to complexities with
racing conversion and fallback) so export folio_prepare_writeback() for
it instead of opencoding it in UDF. Later we can use this helper from
other filesystems as well.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/writeback.h | 2 ++
 mm/page-writeback.c       | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index e530112c4b3a..3e5d215c8d27 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -357,6 +357,8 @@ bool wb_over_bg_thresh(struct bdi_writeback *wb);
 
 struct folio *writeback_iter(struct address_space *mapping,
 		struct writeback_control *wbc, struct folio *folio, int *error);
+bool folio_prepare_writeback(struct address_space *mapping,
+		struct writeback_control *wbc, struct folio *folio);
 
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void writeback_set_ratelimit(void);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 601a5e048d12..ceb78798fc00 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2358,7 +2358,7 @@ void tag_pages_for_writeback(struct address_space *mapping,
 }
 EXPORT_SYMBOL(tag_pages_for_writeback);
 
-static bool folio_prepare_writeback(struct address_space *mapping,
+bool folio_prepare_writeback(struct address_space *mapping,
 		struct writeback_control *wbc, struct folio *folio)
 {
 	/*
@@ -2389,7 +2389,7 @@ static bool folio_prepare_writeback(struct address_space *mapping,
 
 	return true;
 }
-
+EXPORT_SYMBOL_GPL(folio_prepare_writeback);
 
 static pgoff_t wbc_end(struct writeback_control *wbc)
 {
-- 
2.51.0


