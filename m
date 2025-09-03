Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62219CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC47E8E001B; Wed,  3 Sep 2025 09:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74C48E001A; Wed,  3 Sep 2025 09:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64538E001B; Wed,  3 Sep 2025 09:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8E88E001A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:01:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 564DD13B47E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:01 +0000 (UTC)
X-FDA: 83847949122.23.7D61327
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0B66040004
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=omytXGUa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uLDg7Ai";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=omytXGUa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uLDg7Ai";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04FJ6mdlY7gFitpo8K6WI1BZw3Xwifvtp3g2IfjcN5g=;
	b=Hiwvkfo8DBUpa9DQL7pOP8Y8GKk/UwEG+kXiLV9a/5DlG7b1cHhvmlLP2rqYy33BMXrDnM
	o9g6oaZyx/xshZ5UIzx25bvmL4bzWb5H1cMu9d8YgrfWnhCXsIOburGo0zZgx3ovXVZUg1
	+0a4onVJwf9jUWHuEl0C1Qy54G6HAWE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=omytXGUa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uLDg7Ai";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=omytXGUa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uLDg7Ai";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904459; a=rsa-sha256;
	cv=none;
	b=4XeAdD2Bz9Oa0DPoBeC/SLFVJye0QGQ66b2DqCa5QBRe2s+6WbOtgiCZMGcdmi7NQ+FjSr
	cGBUFMDSSNqqpOIAOQZ6RgnAVMA+kqmlYr25IoU+YAgB1AMNYXWV/0gMEqIBJEW2wWnWr1
	JCyeRt1jPO4gVw4mJFWkrhB1JUHayng=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7FF9B1F46E;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=04FJ6mdlY7gFitpo8K6WI1BZw3Xwifvtp3g2IfjcN5g=;
	b=omytXGUab1APokv8IgrliU7EEnaR7rjmj689H5mwTxRcyC+zLjitLaAQcuqSM2LSvMeUSx
	6IhI/bsfGSdYNop32O25YDh5nnEOUk4MKjKPcF9s9Gx1fEQ83wc/8mCjZ70h1Q5NAQFyc1
	VaRLZxprUijo2uRFllSgCyocBoC6jqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=04FJ6mdlY7gFitpo8K6WI1BZw3Xwifvtp3g2IfjcN5g=;
	b=/uLDg7Aimp53izI7djRGz4dVIz4AAglWuPzXAwP4GzKBPMdo6k5EC7X96oW4P/aSDpKlqS
	xsDJJe7apmqrTYAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=04FJ6mdlY7gFitpo8K6WI1BZw3Xwifvtp3g2IfjcN5g=;
	b=omytXGUab1APokv8IgrliU7EEnaR7rjmj689H5mwTxRcyC+zLjitLaAQcuqSM2LSvMeUSx
	6IhI/bsfGSdYNop32O25YDh5nnEOUk4MKjKPcF9s9Gx1fEQ83wc/8mCjZ70h1Q5NAQFyc1
	VaRLZxprUijo2uRFllSgCyocBoC6jqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=04FJ6mdlY7gFitpo8K6WI1BZw3Xwifvtp3g2IfjcN5g=;
	b=/uLDg7Aimp53izI7djRGz4dVIz4AAglWuPzXAwP4GzKBPMdo6k5EC7X96oW4P/aSDpKlqS
	xsDJJe7apmqrTYAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C7F6C13B02;
	Wed,  3 Sep 2025 13:00:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4PaJMNk7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:51 +0200
Subject: [PATCH v7 09/21] tools/testing/maple_tree: Fix
 check_bulk_rebalance() locks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-9-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0B66040004
X-Stat-Signature: 5d4kxaiw5kbimff9kwqmqxkt1otpb3n8
X-Rspam-User: 
X-HE-Tag: 1756904458-249926
X-HE-Meta: U2FsdGVkX1+57SExh8uajcfhEgYQPXx3uJutuuuP5+D0wpmRS496XdLBxmjOAVRrenGI244CN3Y/A284T9Sh5AfE/uC9H1w1CS05R3TPI1EWhzCh7K0vanS1N4XYD4kB2pLWrw3fi03ocGCz8ysfWs8Ve4LjkhY5NGtESyp/PM13ieSrOPc+liWNOuBfYGw5SC/PCp258KQf0xug6SgtULH14+9BFbxxhwWpyGfjOJN6cyz2Uam2ZcoTWh2UOuDDWO7PWGFzv60brQHVsWc2Lf7lpom/3I35SwYThpImgJANImIp/1umdcWqRvh4oYUffgH2AuYJ9ywlTCX6Otwv8x/01EkO6543mNDmmaUR+FQnIbwsjhZ/Ng/A6aAI88uWXbej0Ug4lS/Ztof0F5qZ/wtLfZekmwNbfpd5esKE/LQ9Gbz8Evjw5sXWKbexpKh09Thepu7AJsD5AMw+yVHUhPpti26FZASqfWQISqCqVzZ5403J+HUMR6sV0j+qoi/rQ20gb/Or77c5ShK3/FLlcjv/eyPTwLlbUYaYvmCfNbszV5SQHqbZex+KiSP7rlZ5j5pl0xRqhD5yR0O7rny55usnhPsXBsRn4suTt7I7x8wVW8eJNuzCqipojtJ0IPEzfMmQO7BsfS2VxxvVwrJWuFke2ZPGbNAYqbXuptMGTuyYSg+llTfXednU7gcGdxB0/w8XgivrISsw9IeQtrJw+6l5glYkYmaYucaOp0x/nC+DopFBYPGw7lEa3Mmgaz9icwN0iFfzh/hmU5tPpbHRJ1f6lVO3uaZ6zkgFPKEhBT4yamud0dphzwYSpziMLhLiOHM/ajxJ/iVUoethk/NafAgDeRbWkHljh6AEo+nl2d9yi0EuWkefDTsk3VQ89hfQzuziiL3mPcEtp0zU/ECdfrUWzF5qT5UJgexsLTNeZOFaO8ybVS1CBrJdw6J7gyRjTJXcCWBgIyCmHWt8+zH
 xVvi4NTS
 3WCEEz1tiNhg0ouLqJYoGCdjz83BKIeef6hJBuGWaMxyABiOzQZbouVhQFp+w/MCweAk4/wUEilMBIPOVeR55yqI0NrxiE1gXlpFOy0LV8eiFnWdPK0STahKLq4xn9vLKnsYZR9eUZzOrKXI98onNpCgaj49gFZeoAY/XD0y4p1iWlwKi0F9lxpIUswYPLYcPuao7m0jFzVsP1f61rfD12dQr0W0bmzByAwtTb6+Z51dvAkddqtFERcQKRYp3dLD9mIdD/uNnpA4+syJVils6dfEBg4fkUMyFWPcjb02DUbl62E/NXotVtVcnANgKXrlYJUkIFksrIsou4ebmZiKcrgBYCsd02ixqH6yv+oO+eBFpuhof5LbgrqPUt+ADi3tKti6IuNDpTmRcLGxQfW/8IQxi/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

The check_bulk_rebalance() test was not correctly locking the tree which
caused issues with the sheaves testing in later patches.  Adding the
missing locks fixed the issue.

Fixes: a6e0ceb7bf48 ("maple_tree: check for MA_STATE_BULK on setting wr_rebalance")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/testing/radix-tree/maple.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 172700fb7784d29f9403003b4484a5ebd7aa316b..159d5307b30a4b37e6cf2941848b8718e1b891d9 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -36465,6 +36465,7 @@ static inline void check_bulk_rebalance(struct maple_tree *mt)
 
 	build_full_tree(mt, 0, 2);
 
+	mas_lock(&mas);
 	/* erase every entry in the tree */
 	do {
 		/* set up bulk store mode */
@@ -36474,6 +36475,7 @@ static inline void check_bulk_rebalance(struct maple_tree *mt)
 	} while (mas_prev(&mas, 0) != NULL);
 
 	mas_destroy(&mas);
+	mas_unlock(&mas);
 }
 
 void farmer_tests(void)

-- 
2.51.0


