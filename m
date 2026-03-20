Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E0D1098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02F16B00A5; Fri, 20 Mar 2026 09:42:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC4E6B00AB; Fri, 20 Mar 2026 09:42:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2CF86B00A9; Fri, 20 Mar 2026 09:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEEAD6B00A6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 87F3C1B7060
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:21 +0000 (UTC)
X-FDA: 84566555682.20.AB78AD3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6BD6640019
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZQauWmFi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=thFV+0oG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZQauWmFi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=thFV+0oG;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFDMzNkIKFRwME49O96e1E/DlzdsPjtIa2wUBLqd434=;
	b=X2TwV5Sfxxg13zqnHvgriSg55fyShr9PNTej9qJmwknlpwrFc6QDzn8Mhxz7owQlkYA5G8
	pTZHj/lxIXtdqnQ/DpzALcTFFaxikgNE1Bnh9Ws0e1/efRaKro3o9RW3LUEl8WghJvzCuN
	X6IpOpVbTAp/00+PIq8lGtIUUqBCYfI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZQauWmFi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=thFV+0oG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZQauWmFi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=thFV+0oG;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014139; a=rsa-sha256;
	cv=none;
	b=xrdbCujoZsGAz97tv6Ptdb5c63+qloC2PfpsTNG2IHQLsz7+3AdCQkiWY+2vMnutXmQ1R+
	SeAMPlRZhtwpRRzOEF+5PsSafaRhM3tLahhjZcRFYIGc5V6tbWTp3CzU2ydwQonPDkmXwY
	5ZxWKWX1s2+nM2XKD9LAp/DY4ZjCSyQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 138AF4D282;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDMzNkIKFRwME49O96e1E/DlzdsPjtIa2wUBLqd434=;
	b=ZQauWmFiwqpUdfPdNvTjQZO6GcSfzBe52AZA75vz5j/W8BjqiD7b1mGxb+61EH8HJWHJQc
	SM0n21r+lyBzTCB07aimu+UNWsHEF1C6NmqAPhPcYNrwnJX96XL6uelLEf5mqcWw7ykp1o
	WHlli41i3W/fTl6adrGzL7XC8xIFYfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDMzNkIKFRwME49O96e1E/DlzdsPjtIa2wUBLqd434=;
	b=thFV+0oGTSG/t8eIOl2hO73S8N6xUdTUxJpBfUHzoUt7fShuPk+OsxVklupbQRGtTQKGM/
	09qhr0+9iq+2HcCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDMzNkIKFRwME49O96e1E/DlzdsPjtIa2wUBLqd434=;
	b=ZQauWmFiwqpUdfPdNvTjQZO6GcSfzBe52AZA75vz5j/W8BjqiD7b1mGxb+61EH8HJWHJQc
	SM0n21r+lyBzTCB07aimu+UNWsHEF1C6NmqAPhPcYNrwnJX96XL6uelLEf5mqcWw7ykp1o
	WHlli41i3W/fTl6adrGzL7XC8xIFYfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDMzNkIKFRwME49O96e1E/DlzdsPjtIa2wUBLqd434=;
	b=thFV+0oGTSG/t8eIOl2hO73S8N6xUdTUxJpBfUHzoUt7fShuPk+OsxVklupbQRGtTQKGM/
	09qhr0+9iq+2HcCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 09E624281C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0kRpAplOvWlgCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A3FB4A0B52; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 10/41] bfs: Switch to generic_buffers_fsync()
Date: Fri, 20 Mar 2026 14:41:05 +0100
Message-ID: <20260320134100.20731-51-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=696; i=jack@suse.cz; h=from:subject; bh=mkQehyIZTRqI2My1mwA67UAiWijrKIFYPNFYBKrsS7A=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU502XSBQHbfk5JrAF1ElRgQTVpaRO/gFy4mD AWVgYQpnxWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OdAAKCRCcnaoHP2RA 2c4pCACyRJeP0BH7vip1BL8HeZwhZtsJSQUSxFbR0YKmJlCY4ZRo2/aUBJrBT4op54JDd7CAe8O siGb20WcA0iOzZ+/K+/udwoMlEcDMvKv3CgLLESWqbZv83kKuGATgYfr3VfQeJuJUPwCLbtMR3t OFaONtf+ewkx6tpTMJaD58uNZRLSzalU+R6YVWpAuk3sLPZ3wkmz7ehWUz3zFQYi8zWWUM3K5S6 eERoU2tpADafXUXCm5FWvAT7Wum+0AJyO+2svyjur5frp1u67FhK8aa6bB9nXEviJ7Ff+qBzKRb ZbR8VdcKhVi5b5J0M9rmJgTB996GLHMFrhtSd+LE3sAHXToa
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BD6640019
X-Rspamd-Server: rspam08
X-Stat-Signature: h59s8ghx1s7pae1y34qgmggnhbxsp1mu
X-HE-Tag: 1774014139-972886
X-HE-Meta: U2FsdGVkX18VPqEU7xFIZA//mjW95ssuFbYplDsr5XAkPgk65eMFLhh1cmAh1PyEjrfQWsTF074mrbC9zes0DOUx2g0gXhkbESszXBxkycL0BoBePa+yI/yF5o+N9k/QpVK5fQ2A/EtqbM35S39Q4nR3PgouIQxBwScpwz7iS8uhqhwRj7A2V6M5l0C8gzY8ZAkixcA+Ssy1l524rult5I5wD6NcCsWBcC+u9rZSfKUvA3iW94hVQ9Q4VXjZE2jRsSwN88/Pk0xopHnsUUXgCnkxZZiizVRbcue8CP+gry/t6dIcprbWjajX4zi7hZ2ZxTIWAJLQnW8r3hI/VxMSMG6Y4lUmc12yCnEwQZKIIJ9k5HNRHLzaQdtUHZcdMn89uv0XYYKC17dozoHWiYppsaAOkIo5IK8LXHWTgpika0rW/9wjBf3R4Jkz2RFACAnyRhmYzt/gRw5pRPQlxCnRJbEUHwkqxwydNm1vdLPtFJR7a5OMBfuv+p5UkNo4g4lmf+B1H7LD7PYN/ysM8EKc42jHub6g6fiG5YI12ZNU/je8P32FYhNAErRB0v8wfQC43qpiPDaZL5bRNWo/wFfOk0ZACkyw5poBW81jVnZnTCHN1cdgzAwQTEpHZlSERw9XYPd4LTh0sCjnP44586krl1W3schyQeca7HIaRsHgS1M+DjC8J8TrQODHuvwq87CwY58v5Cn/IoXaugcye3kyk+1KgyveXRXrS2Zt662CXATvyAA8cy3lA+ibM1OXXEuAQPxgwg+FrfrTdolNmKgOv1Mqgay2m88y9T37gQSWhVgPtMgI7FKbuU/k3NR+f90v0Ny6WSy0tEHA1jR5l3j3T7zrkgWNHk29buCVPIDuKqGegwMNy5HguQ+/LcuUev3N+WgLOUiFoeiXrt/z8StpiOydL5OoZJwwCKNwfnasDuFs6dWzZTLWXJy6cJbEM35oY/67Fqp5/fh6s5rCSoP
 453upBq0
 IAZCWoaW2funVG/w048TQzHcurAiYuraN51HnmqwhmTc8+Pw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

BFS uses list of metadata bhs attached to an inode. Switch it to use
generic_buffers_fsync() instead of generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index c375e22c4c0c..1b140981dbf3 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -71,7 +71,7 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 const struct file_operations bfs_dir_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= bfs_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 	.llseek		= generic_file_llseek,
 };
 
-- 
2.51.0


