Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73691098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCFD46B00CE; Fri, 20 Mar 2026 09:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8ED6B00D3; Fri, 20 Mar 2026 09:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6EF66B00D4; Fri, 20 Mar 2026 09:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92F8F6B00CE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45F6DC119C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:59 +0000 (UTC)
X-FDA: 84566557278.04.5E03C0E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id F252FC0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M9gGu3aD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nSk0RBup;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M9gGu3aD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nSk0RBup;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=66R+gMs4TM8nj8jBIrhM+BBNQuCPvrO6NSrEAuXq+IwBmN6RI3tMY1q1z0v1QWdm7ZsT/w
	3g8V00UgUEqlZDNOBu2upT4YzNpS9rP9BdNMwf7rvOkldyMjyQUP+gT2uLW2B93HQKk6J3
	2cQpKvTxBhex7dTfXnSAhxAEfPm9VlY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M9gGu3aD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nSk0RBup;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M9gGu3aD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nSk0RBup;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014177; a=rsa-sha256;
	cv=none;
	b=rOmOyrIFd8kDyGnJ+DzwQ6iKWrwGEYh1YaJwnLaTEakCu4HTMgx6eCvU2628OBjY7cb5ND
	iCkUdccT30Cz47ssl5EiuwKpQTvH0lR6q2Tmlk5GoPpgINNedreLgas/LLpp1cyZXHUICJ
	WUmbygruTWH5Rm4we2UvldpMbQHBNKI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 648435BE0C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=M9gGu3aDJyhewDfcx2p+4+NebAYSCJrZ7c5uWFCX8FJLrppFqxlt9dj/a1ZOETh99UM8z4
	m03oStBYdXsG60pvQYOtJ4Hwczavjch0+kdJdSgzwWr1utqC+4896BmtJnA8PNLaiz7tdR
	XkvAOGNSCws9Cdfbt/69o6KhjuaZoT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=nSk0RBupajTRGfRCv3ivRYdFhzDC7g/Vf+MS3lMStXGx4Ccf/Dl+xvUM/aVxJCyETtBI+7
	CnGZ1th4KJ/8mMBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=M9gGu3aDJyhewDfcx2p+4+NebAYSCJrZ7c5uWFCX8FJLrppFqxlt9dj/a1ZOETh99UM8z4
	m03oStBYdXsG60pvQYOtJ4Hwczavjch0+kdJdSgzwWr1utqC+4896BmtJnA8PNLaiz7tdR
	XkvAOGNSCws9Cdfbt/69o6KhjuaZoT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=nSk0RBupajTRGfRCv3ivRYdFhzDC7g/Vf+MS3lMStXGx4Ccf/Dl+xvUM/aVxJCyETtBI+7
	CnGZ1th4KJ/8mMBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 599CF42819;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tR3dFZlOvWl1CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EB3EBA0B58; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 19/41] affs: Sync and invalidate metadata buffers from affs_evict_inode()
Date: Fri, 20 Mar 2026 14:41:14 +0100
Message-ID: <20260320134100.20731-60-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=759; i=jack@suse.cz; h=from:subject; bh=NDPLTZYpyB8AvjWnfTi4NCpTDfiFBgirFbbT2/Tf5G4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU588HckfhJ1pkI9JwuC2AULW5aPa2lEuXAbV pQDis2S6F+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OfAAKCRCcnaoHP2RA 2WDzCADfC4fa+IJVDAAwMJjeuztdgooJjRRn4iY4Qee74Y6iUHpMBDwDTNHYBne018cMAQy53ga UD5bRfWOFexpcLGqWDxt1t5SE0hv8U04vtudLBj2zFiiVsbmGrHX7NdVtzYqEdW6fT+kvoOXn0w 9dXYmy0chBimaNkO4m2WNZCsRtOMwgKv0yzJhxkQAXKbA5QZ/ZeHDr6UcDLjEvSQycdl8/veQer eePo4OVJNLaKp5zJV2AoRzPxh5PHk5Vuak6mBLV9ryzg7Vc3A9SnqauQXPrq4lHL74/fT0TmroE tLD6aCePkAdk152o78qSkMU46PAz313VABsLemTV3C9kn6za
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F252FC0005
X-Rspamd-Server: rspam07
X-Stat-Signature: 6b5sruxwx48h9s8y6akus6rxp51u6tec
X-Rspam-User: 
X-HE-Tag: 1774014176-632581
X-HE-Meta: U2FsdGVkX1+0b1Yb01IT/zJSstUhV2ss9xc6NeXpKgEnFjsiJOwInwfpUVw3IzNuioByUcWvSm82I/jDCno74zXBsJjLFbMUG/dodmYYRPOoqlea+RdoC6C5ZTm/tfdRupXZMHevb2MIfkrexrIRodbtzv5frBawexrAz3YtNyhCZ2PaX6tcDzjTed4zAxzbQR0ww5FEqGWfGujvm+WhpQPRGy13EhbT5Z3//IpByjKt8Mpx5lp+z9pduSiFgCG3ehPOQX4EU7tTXzDoTvwv/yEX1odqx7MTRoUKuK0ArEBTJlZblxlLioH9iH8YRZA/6PY5xY1ni3wvXjT1N7367fF9Fu5PI454BED/OS2vzT7KFYGUsU4mVHd2ipolrryzo3bQoXU5WRdHeQEP0feTCzlYkHICaG1O96+ADQobUrawwFKziXht9AEkeJhWOSlc62URd/gIvQp82OZQOEQcSlzuVi70/0wjSanwP4aVyEjmhVYrQX2d0BrgTnQ18oTPFT44aCkBeCwdldmbziyOw/Qe3QvUj1ivyxCwkRD17+FQqPEo+nb23vQA+6IWqx15Qa1ZpHKDH6nSFl/AMXBc7gA5lW0UGYqQMbQkud5QUT4FUHQ2QurJD9Ucv56AKWfPcj4LUnEcDBdBOgChGlgWAlhE3LNPJTiw8qlDjGKoCZTXS4dAboSJmk9k4OEOwf8AmlvInp/4WVPXV1UwtSnw1FJHoU+vEeHGc+y6eV9q4u2zN6F/a0W9LFWPhBANUF9f+RMe0JLYfNw8SSEUFypHCAQ7Vzo0ATM7zeYD4S/KdlfVyKLTd8eao3GA7X+SpdQ6BjqfKy/8eLuY2kEDk5W9QST8xNs+xErVOGHt0LvkvyCht4VmV2DP+27K4ASTaU94+yt4UzRd0p2oo4/HVIlo/xlqxKd3DpkQZRcH5FHtaCUajq79cK78Ro4H12RuDnGJ0Z6I3YViNJzZiT9QZ+8
 v5jnKthn
 5pKCFUQ+ATnHfVO8yhG3MI7wBKPgwqcGNnGFa/tCzo42T3C1OT4CnXO9+A1PdBd6JBwrPqcirt2pcnpO/UYfPNVel9r05udCbgkRV+3+hz0bX2VM6Iua5eqPNTiypx36kUKF+tGeDhyr4mA36EHtu8slDj3Fgo5elEBu2R2LIj/oSpDxb2oV5Q0G+MIsYRUbrmXfMbxUL3/03dN+IgNLAzjWlR//0a7tC0cbf8krsYZwcXMyjaUXijByFJGboRI3ubGes1WA47JwH0k9DCko+Oz21TTqX5obC6eAuvvkK+yJpV/bf0wVg4EOXCtVHmiew5KUp5Oe6yMwAUrIlAWY5QwlKVhabQtZwRqQb4L7LexFHh0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/affs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 0bfc7d151dcd..84afa862f220 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -267,6 +267,8 @@ affs_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		affs_truncate(inode);
+	} else {
+		sync_mapping_buffers(&inode->i_data);
 	}
 
 	invalidate_inode_buffers(inode);
-- 
2.51.0


