Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5341FE9A768
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B592A6B008A; Tue, 24 Mar 2026 06:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25546B0095; Tue, 24 Mar 2026 06:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9780F6B008C; Tue, 24 Mar 2026 06:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 804176B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:53:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E72D21B94B5
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:53:33 +0000 (UTC)
X-FDA: 84580645506.06.68D42DA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id B960B4000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:53:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GI0tPE6a;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nCWI1Jz7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VTF4HZmQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Hk2xsjOM;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774349612; a=rsa-sha256;
	cv=none;
	b=Bo9s/X7hXdOVSCEqXr141yWhlKl2noAlZYExMEPyznIIgzD5tOqIo+xPHds5I4kMC2NGj5
	e3OxRg+ve7lo3B8tgd0/7UUefmadTTsT14UMRlukybGticAInCRBSWIYXNd96r5rcdMnmq
	4SuOY7v0ZUOtIcj8Q9o4zgWH1T8i/Bw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GI0tPE6a;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nCWI1Jz7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VTF4HZmQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Hk2xsjOM;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774349612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNdEBZhmsc6hucLIl4T7bCxD9jPms0lHLZLnsrtP3RY=;
	b=0xPASyb7hSywtjjgbunubZbd+Zt/zUapUZozbQnXZ/rbEkS3RUbH19ZNAbaIU4GZWTa0Tn
	bcQ8Wu2/DO/faHIj+Q035XAs6/hMHfk/Q8CVAPoOaCrD3eNS2puvvGbRVlEP/CPLIghGpW
	Wlzv1SQBgffvqr57LZi/ezvVCeYFbmE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C30E85BCDB;
	Tue, 24 Mar 2026 10:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774349610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kNdEBZhmsc6hucLIl4T7bCxD9jPms0lHLZLnsrtP3RY=;
	b=GI0tPE6aAzu21syTaeEseHgg4an+bKTpuYRXrRSHJ0/wnm7ivMYQlrtA77fhYH1YAfytxg
	peloACZM3ka9Gc+V+2G4qwS9pLMwvtYkwJL01fjWO+I/9dL8m2+pDR33p/iqKpEk62zrTW
	VbaLw45JEWIBCioVbrFOonA7MxuN2K4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774349610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kNdEBZhmsc6hucLIl4T7bCxD9jPms0lHLZLnsrtP3RY=;
	b=nCWI1Jz7W283eQ20SeTGujrhd3mjASrJwAZZb3IGM4ZToJBlatuDfdhaHhwqmQr/JVRooW
	vSUufyF04/dzd+DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774349608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kNdEBZhmsc6hucLIl4T7bCxD9jPms0lHLZLnsrtP3RY=;
	b=VTF4HZmQjFt+qYEd+hYgn8+2id2lBlgeew6r8Q7hIRVCTk2fBXWRhbjwuo8vmsVJ4NZ/sQ
	avtjz3G2OZbBCXdHlWMEvmIPUlIQjxqnmIvPp5gQ5BNRQLq/41kPEyQKEjQZqnS0WkKCrz
	iqMv7jdD+VEx2Tke8YokHSIjRgCZ/6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774349608;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kNdEBZhmsc6hucLIl4T7bCxD9jPms0lHLZLnsrtP3RY=;
	b=Hk2xsjOMmsxhI9xaZnuSPXz5FP0WURS3yJpm3EHKfwY4mCJMypYyXrPvujOWwnrviPZzv4
	tWBADs7AngTxtGDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4C7943DD4;
	Tue, 24 Mar 2026 10:53:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FsAfLChtwmnVBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 10:53:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 662A1A0870; Tue, 24 Mar 2026 11:53:20 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 1/2] writeback: Export folio_prepare_writeback()
Date: Tue, 24 Mar 2026 11:53:12 +0100
Message-ID: <20260324105316.28684-3-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324105132.30490-1-jack@suse.cz>
References: <20260324105132.30490-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1899; i=jack@suse.cz; h=from:subject; bh=drBU03f7QI88s4x6d0Lpqfmv3CW37W7rs74N1PvScuE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpwm0c2uE6LQXataL8c4wj77Q2GsrSlP23o/0g4 StFXPgh75WJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacJtHAAKCRCcnaoHP2RA 2bZuCADYGLcwRXkm6oAkt9+TJ3ANZ31+xMTrwVbfu6z0H5eKMiodtjgBEF++dzsLY8kh2ta87y4 SnvxquJ2SWW9ffqQ4lpsR6/wj+l+1dQbEE36JCLG0pmkFWarEJVEtTTyhcak9dHTyliTkQmStHq pwfTHxsxoqAI6lQheGA7WmE4wHoQpQseSLNe1JteJifegPK0+GBnMpc6BWNSsdKP6pn1i2g7dh1 bVQimLLg/bfxGujYxWk+rwPPVGq7vu8XZ1B/onnuXjALw9mZw5VRBeyxqM59ZORJldG+Dr0IgO9 PSFRwEl0snCqDmdb6/xXT93binZ9vaxGCqFg/gzTJjfmQdR4
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B960B4000E
X-Stat-Signature: pbm35k3h3xf8foeo58yj31zuxp8fcf4d
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774349611-994337
X-HE-Meta: U2FsdGVkX1+0Mr3o59lsBBJlD7iUjN9QWT8/cOFKxUGeogYfTDaCwZDn5suLy17zNDDzn79Au/2W599pURATEW6ajNB4VhlBFg31Vg5rv5EHXVTRi+P4TCb8YDDFQWJ0RQK7Qz5LVjoC181SSfbRYdlmk7+TCr8FdgJaJXpjjGp3LQmLf3NtqYPQCmP2uRo+eTQwIkO1Hh4s2d/ahmT4wfbRCpE+JKE1/YBsvLCGT5v6zuGwkCQfvMR0lRIFhHt3v7EnQrGANZqX81/0p5xZvsvGCgZc6rKhCsS6lcifuKEDWoDoY303Vs1MkMSC0wEzuqUuZGDQlFFwdQm4YYEEhHwdOx+3PGNnbCVwhUvn6McCQrJ3RBbghv8EPEvxQn8otzTK/F4RfZvjdr3lHNsbaphdXVqJ6F9RtFtgZbUe9zf4WwRPFINbJse4dAwmqlQ6dm+5CRpb5HwQnpxa5U/s4fcUnGz+YmmzUkGjPV3xIfLFEv88cMlXE2tEXT+nAOE3DbgMGvPJPvfNecSQp+4hd4ybUSnYkOhYttZqVxNQdorORI5z1y979YleIlZ2VoKRhyzC7LT1hm1jj9Cqat02IW24OG8AQkwONOv0gQua3cp76qb4eZlm7lio0wn9KjUJfDYe65di3uVo1NhMbWfXjOo2tTd+FXb0PSz3gvdOGQlLOuqHy1j+P7weVyatnEJk/hKKVBr0ULn9q8m1AxcIRhryxUxbhajgLByLfaZ6Mrm9Yiu/dDC+4kfukCZ50EByhrWbWVLXN1+Vv7YBJTZwA6N24AVfRXgvnXxUH31EnWXVScetAbx6E0wZtXXqPNpIwIqLapZcFnZo2oQ+bgaRsMhrOmEJyIYnHZWUlj6dOXthBoYmKidD/szsWYEOLlS6eJPumC2ahTSR6LRD2c5wlGcwGKcirEKP/0AIO+xJVi4BXLcQ/WyZpfQGztDlFEdwFeN4UzBBHQixgZ4ZZZ6
 GUKE/ap9
 l8y5xq6bVircm7B8=
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


