Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECD0DD73E9B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237256B0092; Thu, 29 Jan 2026 17:11:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158AA6B0093; Thu, 29 Jan 2026 17:11:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9EDA6B0096; Thu, 29 Jan 2026 17:11:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DE4B36B0092
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:11:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7FB21A03B7
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:11:55 +0000 (UTC)
X-FDA: 84386399790.20.893C85C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 989D01C0011
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:11:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769724713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vr8K7jMbrjePTsQ5CIr07MMQfe33exwYmYbVtc/5goI=;
	b=Efsj/1dGUhA9LYemCYREhr5WxUZKmuBC7e/VaihzvPKVBtPaf2rvSHReBC/mPpsbFqptXf
	FutvQcv3lQhPhygP04sIUMEN4AydGrsEI7vqid2SWJp2hcGSA+oNV1SKzE4ShM6+XTgWU5
	VIiDWwsJb+6baxBeaLSoJAP7i4bct1g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769724713; a=rsa-sha256;
	cv=none;
	b=ADOoH0hH+z7A5xPniviqx2bx/I6PBKRF8V/s/BDUqlEjp3ZnmXDordTrQDDjdNn1vghKKT
	wFUywiN26z4eH5NWyAwQsX1wTnyJveLG8CwFA1k70e8T6q1vOD6VHjB3XJ5yeMlmMhrWUH
	4+3JALBLeH0WnVJ+onBthS0S+XI38vM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 480125BCF6;
	Thu, 29 Jan 2026 22:11:48 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DFC103EA61;
	Thu, 29 Jan 2026 22:11:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UltvKiPbe2kKbwAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 29 Jan 2026 22:11:47 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Subject: [PATCH 1/2] io_uring: Support commands with optional file descriptors
Date: Thu, 29 Jan 2026 17:11:37 -0500
Message-ID: <20260129221138.897715-2-krisman@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129221138.897715-1-krisman@suse.de>
References: <20260129221138.897715-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Stat-Signature: 9a38ydxkjcbb1breyepwo7yf8yzg159f
X-Rspam-User: 
X-Rspamd-Queue-Id: 989D01C0011
X-HE-Tag: 1769724713-471312
X-HE-Meta: U2FsdGVkX181GyGKJoEeerMsCmS/4Jk3ShkgS3QSIN0WCfmpvhOR9LIcrSuyoXtL0j7UHaqbfl9/2dC1O+i25PsbsdbH9dXcvW7DdhdDg4V7IS1L0bP3szG5gyOqNyiw4px8atYNq0mgm0WMCWlKX3zC7iuxKRMNQ2Hnw1/Qfqo3GoELQVLl1hG90kQeS/koboyWbqEjQzn8D5HnDMeTlDl2mv1FYLDNTASVC/vUEsilR7kmcZDwEfQpjHLYlfmt48i5byZtgos6KFsIiPi1s4jRH3yakB6YBhvRvUtJydmz0EAMMteKjA1xISmWgPoQxvPZHGBxV/F8D1xhSk+MuMMkUqsKfNL7Cr+7j1BQGBrJO9IzQYeksN0gF9XpY+NTuYwBUtVV7YMNdPt5dJMCcEiWfKTHhftXSldNDHp+g9TVHdCa3piRCE3wdPWB2TA6Od5e9zGZptM0oqGLZo1iUd4mcG9weLiI+ATeG9/uuQYvz/OyU8AZpZ7PJeZUW+h0fyXUt1Y76tQVR00CefQ2FHDcgtK5AtcyVVfQXY2GOmQAaQjYdl1oIr76Kc8fPvZv1+1JS3+9FWCnw5mbb2Oc8pr/RJj/X7LziJxTG50ofBX+F/ydE8UHHj16sWXc9IoeWFGbunCpClTu7zy5d3KU911BVOftM9eTDr0xoIYNw8WmwPXBvTKpEqNOmK/SBoSx+yZny7eF3Ggydr6n+mzwx64ZlvJlNyg7IREcYnz9H2Nz6iRmczdFjcrG2sp4vEmXleQGOC/bzIl7qp7zURcLJjX0viNKOw6vSTvaFUPmtuHPq9YamBkrQTmD7uZjZJTP2X0k5mOH11LJCLuAs8vgH8Gixh1ypecuF5kJ4rTVAf1Mn7h30rS09Y1Iu7qsrHC8+qB63ilcxpe8+fTIl/oIlWjYDyUry5fJPVty0LxRbHMuP9Txl8z8nFHzz4qEqF2a7jWa613eQD3tuvT23q3
 mDtPVFyz
 lMSw0C3+JKbEDDhbZ0UBi7e7wi+h9T50s4KE+D9l7OZx1a+aG9QLkLi2wRGa21iHk9Mk7jB6kSs9BF/KbzA+S2AqPEWHaW+Y/sYAMuAW+D0Li9Qrip7qHS/irL+rPksHSlQ8TAE7gLrxKWvztl7B8ymvthRXyHbBkJVGFLNy9+/oble0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap can be called either for file-backed memory or for anonymous memory
in which case no fd is provided. This patch allows an io_uring command
to request optional files for io_uring.  If a fd is provided, io_uring
loads it in the regular paths. Otherwise, req->file stays NULL.

At the SQE level, Use the ancient mmap semantics of fd == -1 to indicate
no fd.  This feels more useful than a flag or using 0. The later because
I'd expect 0 to be commonly used for direct FDs.  We can abstract this
details in liburing.  It is a bit ugly and it could be a flag elsewhere,
but we don't need to waste a flag on that.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/io_uring.c | 15 ++++++++++-----
 io_uring/opdef.h    |  2 ++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 87a87396e940..158e9823a72a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1756,10 +1756,17 @@ static __cold void io_drain_req(struct io_kiocb *req)
 		ctx->drain_active = false;
 }
 
+static inline bool op_wants_file(const struct io_issue_def *def,
+				    struct io_kiocb *req)
+{
+	return (def->needs_file ||
+		(def->opt_file && req->cqe.fd != -1));
+}
+
 static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
 			   unsigned int issue_flags)
 {
-	if (req->file || !def->needs_file)
+	if (req->file || !op_wants_file(def, req))
 		return true;
 
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -2200,11 +2207,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (!def->iopoll && (ctx->flags & IORING_SETUP_IOPOLL))
 		return io_init_fail_req(req, -EINVAL);
 
-	if (def->needs_file) {
+	req->cqe.fd = READ_ONCE(sqe->fd);
+	if (op_wants_file(def, req)) {
 		struct io_submit_state *state = &ctx->submit_state;
-
-		req->cqe.fd = READ_ONCE(sqe->fd);
-
 		/*
 		 * Plug now if we have more than 2 IO left after this, and the
 		 * target is potentially a read/write to block based storage.
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index aa37846880ff..5b81f82c2359 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -5,6 +5,8 @@
 struct io_issue_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
+	/* Optional req->file assigned, if available. */
+	unsigned		opt_file : 1;
 	/* should block plug */
 	unsigned		plug : 1;
 	/* supports ioprio */
-- 
2.52.0


