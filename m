Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4E7C1098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5F96B00AD; Fri, 20 Mar 2026 09:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8CAE6B00AB; Fri, 20 Mar 2026 09:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41E76B00AE; Fri, 20 Mar 2026 09:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB9456B00AB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C1FEC12CF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:27 +0000 (UTC)
X-FDA: 84566555934.11.7ECFAD1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7CBEA80010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=CjH1wqMQUFAQIANWuBDyrcKujigqnWg5r44saBzQ9SpnO9pm5iwi/8MSVsbsIi5BKZsjJm
	SNMyqhIQJuE1dHOdqNc9BM8ZyQQOPovGnAwbraYqGXtJ/rT7n3dQV+bhcqFD1nEU0JYq/S
	4HcyJC9QpeboGcvO2EQTB5lV4fgHxeo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014145; a=rsa-sha256;
	cv=none;
	b=o3kQ9Ut7hu7pSu3eOuaN0EhkctMvk4wNulwxY0GuJfCZ4pKIasxf/B64/FtJz60LGvLSbh
	STADPCNZbE2fDyj/0fkgiaiFWZwY/68ocnzFgVY3CXNl1keE4FQph42JvWcHNs1ppoeJgX
	qAHoX+6HBGCPcU6z/BZ1Xg/VNDlIbfE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 178E15BE03;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C7284281E;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eZcAA5lOvWliCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B9EA9A0AFD; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 13/41] fat: Sync and invalidate metadata buffers from fat_evict_inode()
Date: Fri, 20 Mar 2026 14:41:08 +0100
Message-ID: <20260320134100.20731-54-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=858; i=jack@suse.cz; h=from:subject; bh=rtWRYYCi+3xOxheWOY6jlzCuMWKqys5cHOCNYJEuNWY=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGDL3+pWHG+xI3GLr71bh+3qG6ombcmxvv7+uXa/s4V5ax lEusUS9k9GYhYGRg0FWTJFldeRF7WvzjLq2hmrIwAxiZQKZwsDFKQATeTGZg2Gjpe7+OC4XV1km B7M/sic+/DrfKVI4vT/xvrBtS6GArr5H88MXtgFT5oT+EEzN91z9xEog6OKXP0yq+6/MfuJuKeD Eto9z1qqyslu71rgIJptxfS7st6nXsWdSUDh771Kg7+ukIK4HL99wGIoLVXY8dSvVifCZvNgnzt BVUzPlg2Fk6HSN5rBNyrqubzX5jp7mlVO9ksnBbjs9xah+qc3lvzFV8n251m9nVhl/3SIsIBv+i +ndUcU5ekevaS+p3Ge16X3eTiWTWd9erY7eXel3/sc973xHH+4u27cJ/pEXWfnufG8RDa2c4TZr vrXyas5nW2Q+Nv7K/PhWrX/epU2/NvNc1sp9JeSm8novAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7CBEA80010
X-Stat-Signature: yqs9yf7w13bo6wdex1f1tk19yu6d5ay8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774014145-154076
X-HE-Meta: U2FsdGVkX194tOYmVrZen9558BzrfPKYRDV0TFiIYHhCuEqMqkP91WTECJ6vyvmYJXwDIJezfCQ3SbrD1oXmw3/FQE9MDFuXHMTyUmXt3MOyvksAgq3cfr4PTCT8eVWL94VyAc8KyUvY4j9TfQJcgiokt8PEjrPHTsvzLbrzMj9/s89/TRTjXLU+lEnzxWom0l/NLmy8w00iogsj0CdnXJKOMZv4/Qaf/Yl36inMUH6UOwltOOJP80olO/ke8UkWuEXfY7FBt8jLlGRIVhUGBRtgz6zQuytquobt/fyk3wVEkhausWvalB5diDUPM7v2kr6a+Pf7VjqMBl+qu5lclFWKhox4X3ZCytJODVCXPIkj7hU3IA5FWKcsIdKvHt9wX5VxUTeB0IsFlBKjsJ90HhyfF4DMFv/u9kYE6ZgQk8hhepw2i70PaqwesXWzpwV1K28jCCXcBw+590urhY4q1F3KL8K9weqreC/dut+EmnGo3X480tJUWE4q7CoX7lK2lraiOBSSzYd1ndXoMrZGzZRAlRY0sb6kovcrbOf8sZbt/mR3y2KSzSvnpFBCf+4RnCqeT1HzTwBrAWMEkQxSaZY66yE3zThnDTmS1LgJgXWM7sSMgYYQTmt2F4wnUFSkCBPsuAyz8Hv7JpHqp0RfzULMyGrOdKjvs6tStyiArYcAyE6P3IDUmRrWvrJiyvHTlnKw6JxwbeLw7kjIaKJrneOgpM+mjUGx8OpbTQpxU+/JN0ChmHLGhaoU/lWP58oEsUd+V5O3IifoLTQHfq77V8hH/8T9GoJwykMX8dO1DRXwvcXIyzUYQ2lGJUCn2LnW4EGS8DEbF5rbRYPwm+gxautRj33mLAym8jpi1GDbEOL+wy1wg61RoGJehHqKw3d7iPEWUJxNuCEXbPxQe2OLoSfkf+3y4fadlXPtRJ0HhYA=
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
 fs/fat/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3cc5fb01afa1..ce88602b0d57 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		fat_truncate_blocks(inode, 0);
-	} else
+	} else {
+		sync_mapping_buffers(inode->i_mapping);
 		fat_free_eofblocks(inode);
+	}
 
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-- 
2.51.0


