Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFA00106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828C16B009F; Thu, 26 Mar 2026 05:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FFD66B00A3; Thu, 26 Mar 2026 05:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653276B009F; Thu, 26 Mar 2026 05:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6F46B00A0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0D305C9D5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:18 +0000 (UTC)
X-FDA: 84587756316.13.1F93C03
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id A257D180009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FP0IFOVL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BmTYABnQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FP0IFOVL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BmTYABnQ;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKch3cA360fq6oe1hSv7172yeidWMBNx7GuKOSTC8+c=;
	b=npa9WQsHjS1mbR4/GECXuCcPFk14Qh9N9FCbybAK1xJLcJKByBp6CevOuJwD00bB+kEBb6
	UQCVjlp5EDFaR6GD4l5o5HxZXuZyhQ3dzWjDFZ0QZ+7VrD6+zhllalZ24aDaaSlYvaJ4IM
	bqI/p1zX0GPw1oKrI66Zu2GYIvl2CRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518916; a=rsa-sha256;
	cv=none;
	b=yLukjnnav21vF6SSl7Zh/fZVdZrEmujuisYnzXNTkgYIP6M85hRu45fTg8T3j4wZoWvB5f
	32k7wEVcmZr3nVQwwiBP8i1sPJnCtDEi9/nN4qN9ThO+3iW9G3yeCk7WY7T6mA1alETeJ9
	X/RACF+nlf2egWnTI1Y01b3fw8uJ+h0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FP0IFOVL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BmTYABnQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FP0IFOVL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BmTYABnQ;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0C49E5BD8A;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKch3cA360fq6oe1hSv7172yeidWMBNx7GuKOSTC8+c=;
	b=FP0IFOVLysghcpqVbJ03MdX6UHraRclKDo3dlVL1UFh8G6/BbnR71znq4V05rL1CfNpjvl
	0rqQOnijioZD5b8+J3ZmHcvF/8kKjTbGoZU7O4GNM0CL48bJkfTJSP2mO0MWZia+f1CKbR
	IvjdtnIOkZ6DdTR9bTvu9Oc2amsQg2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKch3cA360fq6oe1hSv7172yeidWMBNx7GuKOSTC8+c=;
	b=BmTYABnQ95hB3DqtwiWJ0l4pzqyRfE8C6ZKjEVy7eCjj7bHeAr5UwAoolgptjYwzKFscX1
	DdERTvCfF5PONRDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKch3cA360fq6oe1hSv7172yeidWMBNx7GuKOSTC8+c=;
	b=FP0IFOVLysghcpqVbJ03MdX6UHraRclKDo3dlVL1UFh8G6/BbnR71znq4V05rL1CfNpjvl
	0rqQOnijioZD5b8+J3ZmHcvF/8kKjTbGoZU7O4GNM0CL48bJkfTJSP2mO0MWZia+f1CKbR
	IvjdtnIOkZ6DdTR9bTvu9Oc2amsQg2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKch3cA360fq6oe1hSv7172yeidWMBNx7GuKOSTC8+c=;
	b=BmTYABnQ95hB3DqtwiWJ0l4pzqyRfE8C6ZKjEVy7eCjj7bHeAr5UwAoolgptjYwzKFscX1
	DdERTvCfF5PONRDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 034824A0A6;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6IvLAHECxWmyYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9BEA6A0B63; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 06/42] ufs: Drop pointless invalidate_mapping_buffers() call
Date: Thu, 26 Mar 2026 10:54:00 +0100
Message-ID: <20260326095354.16340-48-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=595; i=jack@suse.cz; h=from:subject; bh=RkkBpF3L87rXPRrGMrmQZXeEBfTEFrhE0WIyjhBNgtA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI31WeqiG0jNa0YkM8N4dWqoWPubtNi4LGzk SOQHx+qqECJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCNwAKCRCcnaoHP2RA 2UfKB/9DDO+b9sLudpGGjgiD2JAI03bZrlps0G27v4opMDq49NWLPuD0MGyMo58IrZj79u3Vr9j UDgz7kBwQj7J5sdNzmUQs3BgQOtRV5VqWak/r/DNnWYtASVZnIsKc2o85PdBR1a7myJuBamquJh xEoaUu8rAh48Sd/3d/bTPHtVpTfpgx57KSBwuLBTeMwv0j2ROLNGSqjOBk1F1JJLV6K7i8XPQF7 4BGfq8UYL3RDrjL+STwQSRl5GqfPTF15xYnU+778k6o7XklGuIjUeKf7Pu10RiUp6o9hHcKHr/B N+L0I+LYymR6f0g9C/bgDKRreCpF1IYMjXFv97na0cMbkdzY
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A257D180009
X-Stat-Signature: tcun7g1aie3u5ycgesxn6hdb93swqoob
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774518916-695355
X-HE-Meta: U2FsdGVkX1/3PNE6v6h5ukwWvS0FSTsaZkh6fATg14rhZUURPfG7UvuhCrxyiPSnaKt3bEN7dJbNXdVKF3mXezJ8ApsnICyEo1CV/s8K45hyeNwaxFQ8b++VDv5RCZ00AWrCqaZvEyYnqB9mESab2nzmtQ8YE3cPj3JA0pO4bKFz+8l/m688juLy5QADd2vVq8Sueekcxx6YMctOVgWX1GMVcTnXrf6YFbopfjUNwg0bpZVWKJgKaNm6B2uEK2MVOfiQeR5GwgHVTqOuEL0BKmzwhh/dOG7fsAatrnY+UJ4lGHO274OZBaafBmi6T1NaLqIuZ7Bqj9kU8Qcqtny9f351tPGYODGYrs8XsRw12vd7YoW93MdWmD1f5DMos7UwU+2B+M9S17V4esE9QGfo/AMJa17xNPK6E5YCTJirI3cFLl7kSE7DRs4yXXIhUkfoxWL9McglW4Fdql/kRfKLqMRS2EPkLpfpJJpuJRLMTV28M26wsPwaFKsHdzUBbf84j3IlXDnmv6ffg8vQI7yiQRlCMg7jg2gzmC9J65cD5AiUFFrOi6WXC9Bu3cfsZnLPqGH7C+71T9NGYiHB6q5XCPKPIF0asyeqnwEnH8k6ABSA2woqeNUOsjoyWj9oSuhttVtSQg367izrFlFLimI12Dqkv/r5pWcNRjzV9Im/wjT4dniSNvLcoBbpqnDVfZ8SniVXykR4pMoOMJzOcC1F/ke3OxBlzpyF9TQwmjIYdImx6vRRdz1wXAW66vN+xSXOtkvw1Ic+/c2qgl8aMIgo5Y2mKRnww/HpMmUJThce8pfl/kSv4Fm0kD8cpPQ8E0vOC0Pzow91AXAcrC5HE2hj4hpAYoBmFIyqHU3Wf+evyQoLE1wi0yZfLVlBOrL+CCqf6KS/ctYVjBVq7AL2jECM+nzwAwmkP/WMwoW0b8Dl3HfoTpVi8bZjqOaPJIRMwWHD+lD9wQCi3U4HOyU7X4j
 98NYABwM
 2ZjX3J5aI4bsu7z+pqg5FMLNeSd7SbrEKM8jO6AzRQnRU5J3NbK0DMke2SXPa2E5oemhGhOvaEENHQ0e86HoQa0/pnYUpSl2/HQOaqbn8ixi84paOnpKvmPAY0giLC7K1zBzMEv4AWrbk/BLwEC9/lMcPhf/buZiiWQAgeY9evrURUd3vxfgSZapn3oECcmy6Lfw1ijUcoCIBJD/u7Vqb4G+cgEOZLcWKBVpfGy97ZBhAHSZzh1qni2jBqVb+V1oJHYDeFwuPt0nu5t9n40kmhXLEYqE1Ds13y4DM1P/qhG6yvWnQQup2gIzpA5k64v3x9gZnThLm4K2M7TZZ2ASGbk1BZjWzg73I4zRCZalvq5Se9ZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFS doesn't call mark_buffer_dirty_inode() and thus
invalidate_mapping_buffers() never has anything to drop. Remove the
pointless call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ufs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index e2b0a35de2a7..77617a31d517 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -853,7 +853,6 @@ void ufs_evict_inode(struct inode * inode)
 		ufs_update_inode(inode, inode_needs_sync(inode));
 	}
 
-	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
 	if (want_delete)
-- 
2.51.0


