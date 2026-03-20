Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD28A1098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F2B6B00BB; Fri, 20 Mar 2026 09:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE216B00BC; Fri, 20 Mar 2026 09:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD276B00BD; Fri, 20 Mar 2026 09:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 115EB6B00BB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2B761C8E3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:33 +0000 (UTC)
X-FDA: 84566556186.27.C3C7FB4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 94B4918000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=i73wMeEtkkSD/lqf6VnIMKTYA/D7NU8izTe6ozkhpfBDaVsw1W1cjF+T8E8EEFrndqXb8e
	xNjnRsiULH6vXyxrImrQTn90fK24As4MOkAHWUPJx4jbLkRiN6UBPNH5yRrwzeUKEgL2xG
	PJCB2f8KnKQhaYsq/aAXc72bBbNDAKg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014151; a=rsa-sha256;
	cv=none;
	b=w1HYzmD6vqGylD1bb+C8qkGA+nRET5xZiBjKkwr580IN3+Rb+CEmcFhImFalOz/YwJ8fLO
	JRSmDxjr8JBUNHlWNx7zmktUShMzQQ8Yb51FbtZaS7L0KWcEP0iJHXdjJeY1+2qLePAI9c
	Dz/p/EQo5ynSxgQc3yRfQvcX0mktT3A=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 534CC4D286;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 480504281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qOySEZlOvWluCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C9A0AA0B39; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 15/41] minix: Sync and invalidate metadata buffers from minix_evict_inode()
Date: Fri, 20 Mar 2026 14:41:10 +0100
Message-ID: <20260320134100.20731-56-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=796; i=jack@suse.cz; h=from:subject; bh=S1BAqXV/Jqi4FmJijCh+slBc7/Xi7wKphfEUon5Scy0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU558bYqxZ3+JTUWtvnp18qagzJO877Mdw6cB sfHYzZzTaWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OeQAKCRCcnaoHP2RA 2RWYB/9lvcI3m1d1cVF9w+HK3/HDWcztscAHT9bzHrltK9PnXyeRONw758AHBO5w7z/Eepmtl1K HhXl2TI7v7tgnkfEQB/ZhGMVWEcoFmWb3GFNv5+tNbzOkTvW7/SosNhz6CSR02NHCL8Bgs4K0Fw 5+gm/W3fTj8rAJBQv0462vVUqNtvJCIw/fXd82CHjU8HkBcsyHLvwRLGKciF1dFTDeWGXT8JnsQ Me+2RzzESp9AEWtTYQaZ/raRhupU0872yztiDsqeNpCCWq2QQDizbjOZuPUJrYQBhq6G75hFku+ PzxzHw5wkKxIVnsDw7DWlgkgtQ9SaVTAottPfd5MAcdoYBNK
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 94B4918000C
X-Stat-Signature: nuzr8yhdg7j18ti93hwfc96dx1fbi378
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774014151-955632
X-HE-Meta: U2FsdGVkX1842aP+LRlCS6d4leb68VvZfjy77GjWB1UnzkxcAL7Ng+6tL58uhlR2C78nu2G9VsIypkpcQ76CqubVffVeEtuvi0et+fgGlxZCshfQ6chJMtYn0Gkxfci6nIhHT15dqzbLgz7lUin0D1GqfnjrbJDwwGILSo7WAUEbjYALHIlLfWVKVfqOhuthIgq1dfVhpeWdfXU+ELNW0LZym+N6yM4eevMfeJqlXetYDn9sAzySyyr1FUgeIPS7vI/qgkdJsQhd0RrX7kWcGICZu23ECgDvdjFye5A8BEHHRFkbqrdgFFKqVlwPxFkxPs6LCrv7a3FIPqxwbrpAgE+IPPIzt0GF5Uc9WayKZBQboOyD0Mg06vXs3XOKML+kGNflB++0bYz0hhfwR18ACPxghqDghSTtGLOaccZWqLdlra2IZg/2ITN/gxE4cr7q/WJWOm2zLVDmqrKaKKbNn9sxxcu/gkdIRTQJKGNEpVuaM1KTdZ1mdM4UUf5n0vnftPLkU+pn3wrS7Pm0QA0VPB46ALk73DCTpxImAyYMmVMq83Lb5xGGMWgYvk+VMiqEFge2nklx5svtTrsFp/pu+oZw+L54eCEYW4KjFolna5/913QsAyGctRhYdXygH2ThNEmgfi5Hk3AucLFHDP1IAVhBgZGj1dE67N3Rd+WzYmALyuAwk8mv0DC/52yFCiTmlh+/io3W8/ZzNYlEFNzFZFw+amoMNJ525PHqlrM4mzSDBMpCRNVR7tmm8I5NRxPRxbaTKVTawPOd0yVo9uZLfY3pZJKo74cEOgzDqeoPkIDVFV/Sta0sOam2PqolRayvjihnybdfu0iqzOkMWRuTVdEUSQgzoaWJu32SWgQmnZOP0SxTsJys8GMalPqdMrTe/pKXZLrc5eb5lPQ/xTki1u70JmMnZm1D8GAErhIuMPqrUE+5MVr/LRqtMTptg2BF5xZ1fnhBbt+LsrDWAgs
 NX/aWUSh
 sr9tHDBxKOgKZpwP0nfnTHqjd/GpsV5ZlmWgkO0wnudDNh3PvFkX8nY5mxPIvzDhmlbpHtOoD9cquDdmDiMHzwyqRbXgdV9zbMLOBrHaqpbaQC1SdXVc2wZng5fc4ZXswG6iElTbs8GrYKXhcNXSidk/8OTdu0P/86KxIGzQEg3aE6Zs8EeNLCb5xIG6MTmgdklNr
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
 fs/minix/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 99541c6a5bbf..ab7c06efb139 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -48,6 +48,8 @@ static void minix_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		minix_truncate(inode);
+	} else {
+		sync_mapping_buffers(&inode->i_data);
 	}
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-- 
2.51.0


