Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DFF1098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A09B6B00C0; Fri, 20 Mar 2026 09:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84AAD6B00C2; Fri, 20 Mar 2026 09:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53EBD6B00C1; Fri, 20 Mar 2026 09:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1491C6B00BC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCBC5B6FC1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:39 +0000 (UTC)
X-FDA: 84566556438.07.6107210
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 91ADD4000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o9A8q4Sf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kd3Un9Gh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o9A8q4Sf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kd3Un9Gh;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=7fzL4rX1Uz29PrgFjBwDa6NYnmdytjeU7g05rK5ZvCjvN+ys8m3z71FuxQkPNB4HJhbGZZ
	TvvIeKTkvJMZK0SQxZ44y+dAwZuqIL2RwhCz2EIxZtkn1SbUwcRn0WvsUL5/3tqo/zjuwS
	MrB9+p6FYOnv3W6tfxJC/QscWdeB9EQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014157; a=rsa-sha256;
	cv=none;
	b=ziiTdQqSedOaFiL9Y2vgetaMzCAcBY1UtqBw7Q856cqvC1dM9/RutEhk4h3rvyaUfbYqPK
	/nw5YqekWcKqEpZ/FQ0keFsy0PmO+65rmSM4ZTUj7KVHmBp/o6WYyq5oIpyAXniqBYkW6O
	ksZrVtHmCN664YxEz8PrabkN1ZjlQZA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o9A8q4Sf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kd3Un9Gh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o9A8q4Sf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kd3Un9Gh;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 36FDA5BE0A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=o9A8q4SfN6POiJNVhSIutXcnM8Fmu4Es9FPpBZe+cD3K3s4yFl1/+Iur1f3VavyrcE/HXw
	5GZ3C/704XN8JaVaZE6xSiyGqCG5cfBoL81kEY+tc2Kig5bfIhl6F3Pn4suSMFirpWk3Eo
	0hoVUfNfRFawqFc0Wv6Fcyunr17tq7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=kd3Un9Ghd8AdhdmWcqHGhD5s2w2vdotXHSHdu4DiXHYzT/5Y0baFXm2YsvN4cTbng4TwjT
	DGFWYlUsMzLdIEAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=o9A8q4SfN6POiJNVhSIutXcnM8Fmu4Es9FPpBZe+cD3K3s4yFl1/+Iur1f3VavyrcE/HXw
	5GZ3C/704XN8JaVaZE6xSiyGqCG5cfBoL81kEY+tc2Kig5bfIhl6F3Pn4suSMFirpWk3Eo
	0hoVUfNfRFawqFc0Wv6Fcyunr17tq7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=kd3Un9Ghd8AdhdmWcqHGhD5s2w2vdotXHSHdu4DiXHYzT/5Y0baFXm2YsvN4cTbng4TwjT
	DGFWYlUsMzLdIEAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C65C42817;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y2/ACplOvWlnCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C0A8DA0B2E; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 14/41] udf: Sync and invalidate metadata buffers from udf_evict_inode()
Date: Fri, 20 Mar 2026 14:41:09 +0100
Message-ID: <20260320134100.20731-55-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=790; i=jack@suse.cz; h=from:subject; bh=MUD4hvw0kKK4/k9ZuBglb9Pnr5A53izwByukHuzgvfg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU54iH1edR4ShwUvYoFKD7qhhaBFBhSp0KWEX 3MdhTPWkEKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OeAAKCRCcnaoHP2RA 2S98B/9iXM9RsuUz7FFsnc0XxjO2JK6Oup15kyPkPqu6EtRBHqgyvzSQZIUV/Bt9JNa5lD2Mlq0 LgDwAKjaMEvXNx5UChQLTNZYcvMnYW3AZd2nZ+CE/ZZGUBWAkMcFhc/X48BewPiR2XAPVvv+kSJ arqy2+zINGarKl46Z3LICbG6MY/V5xS9x05oiuvmsoDpTT1pXmC7/1g8Duopt40w+SQTLc+G2iD w20Hbbwq8ZkkIPFDI7FcXGxwY5hvzEdBzzdlwV59D5wNvOWAMUtIxM8dQIkrCrMzupYLTE7lxKG kJfIypXUHofg+PqW825aQlJqVCwY8oKOVk4DVhCUDjdk3as1
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rt7heahaa6tau4a561r1r76u6u1ab66c
X-Rspam-User: 
X-Rspamd-Queue-Id: 91ADD4000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1774014157-366069
X-HE-Meta: U2FsdGVkX1/jw1lU1KJ92TG8EwhvsNeCfAHwubl7SuCfm6f71NjIUSGBDcXF7NWlnpHH6HxyXJi+TkBa84AwoXj7mdeZPSqJ5sZe3MLW2MgqYFNYCKdSPP7vt7WBFmhcw7RLgkNG1mfzPghFGrSlnHRpEh/S09Q2iZGZh+NakSun+0rB1a3JhaSTeEGU8nDPIXhhBSUtmD/LO22Jps6ksBoOLe6tj4ra58zmzzmIlPXL3sarm/X5dDBRDVieC6mvIi482gds1wPeitIz1+quLlRuLcVsnA7hC0D2umMQN7C3V5uShhW8zpaG3V2OmeBz9xhmr1J9M39z3ZVxl3BGJYLs+EwwvMKbJwMvbN2rRIRQ4Zt41VsSMsEB+9h6JuaqCiSUvNy2a03SGmXbYq9iw9ILNA/6e7FtB3XWhXjGArgAFh0rbP5R63SxBGH++WXBB6LFgLC96A2aDFyUE9ilArm767WkMeeFtajj3gbsMIvVdVfRPXFDh10turH5malkK1mt8k+jp//qSHSc72053yySAwNxqyUf3tqHPjnRQZ27Wn/Lqdn0MFfAp1JqXQxolxzK0nd5zaTMPqzKfQlxNhYy/IiKH+8un8zGDckV4xIIwaGTae+UOXWjm9vwn0LPL9Oh32drnkQs9YwLm0sNBPyzYAe4mZR0HqPpuMM4r68Wwj/uLatp6z9YZXLXOvUOaaAh/eIwdCkt2WsskRugS8rUj8e3CHtIEcj0shyesDlVi+zmRc41dBUfzvdrdzDVuVRHGr9FDjRAA2LOONrWG4C+6IcvQVAE0nbMNXFrh7+jnPL2eFFGDoPd4G+ux/v/qdq1N/zNh5P+M78LXN/adWPPTQwvchgHLNOSnntYWb7yu52Ab4KDypUd3Q3mtKN3mwsY6Job5FNhgjYMQMQslPSpEndvighKz29tnuAug04FOKE5S5aG/WvC7eSZY94vBgwtj9e5s6mX/DLa+4A
 AFZytuSt
 odPjM8PUmGleiVRycAevm+RBWFMEctd9WThz95bhe95lR+jvKCybzJ/tim0QyT2L60fZG4mJ2De7z5QiYGPvYZQ+Ht/LhB8Fd4vm71n6buRvxuUnj2ctD1zIF/HHTcMPbyKzMJQmZklCnwIRClWDDJ8emrvADglrUTuXy0S2lC9gfUScBftKuSu/0zLHO3RV4wvRoHxcyPpyEe8oFC+Ic9dy93cA4xwTiLreaDy0AYqdg7cYKubGmkYUWfdJrfihi4U9+7ATobyB5J1QKsugp5z2sv2XaLtJ1uT0+JYb6owP3BQW0sKCYwTRg3/38K7JEp3pYL3rYZouPjXSyjtcoolAqDR5qneNNKp1KTNjrFGwbouM=
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
 fs/udf/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7fae8002344a..739b190ca4e9 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -154,6 +154,8 @@ void udf_evict_inode(struct inode *inode)
 		}
 	}
 	truncate_inode_pages_final(&inode->i_data);
+	if (!want_delete)
+		sync_mapping_buffers(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	kfree(iinfo->i_data);
-- 
2.51.0


