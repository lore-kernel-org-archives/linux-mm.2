Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 384ABC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793E26B009F; Thu,  9 Jul 2026 18:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744A56B00A0; Thu,  9 Jul 2026 18:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A886B00A1; Thu,  9 Jul 2026 18:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 32B676B009F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40FA2120305
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:37 +0000 (UTC)
X-FDA: 84970683714.22.4508814
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 76C5E14000C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9EQRxo2;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ep96HpN2SK4tV1yyd6qS8lQW48a4xg5uE8G8cVQ2aXg=;
	b=vUjYMHT/clfSaNfBmp9wtB/9JWssj/GHYKeo3okDGgiLrA9LsXwcIX2hDx1LU9zJtI1VNb
	YRKlBYFEzyhzxIEE2R9ez/pqY26OR+8kXuZzPykKTNNWYQThC8dn1OWt0YDRK6mdI+qkLm
	qEzJsrmlT0bwg+ZtBDDYZGKB2xoxegY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9EQRxo2;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636235;
	b=MHf8Qk46gUgKFwN23x2YP0uPwBV6e4Mk+HUGGSpOsQwz6zGXIRWuxDL2eMgk4D5esmnYpt
	umeUIZy9GAgmysjA81Paqxx7QnFI9PxXJHkO2WkjxR1N+qrYJhyo3gm0nYsDlTEjNlIgZn
	YSRmk3c6J3O/qulomrZgaljUDLIUYBo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB031408CA;
	Thu,  9 Jul 2026 22:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F461F000E9;
	Thu,  9 Jul 2026 22:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636234;
	bh=Ep96HpN2SK4tV1yyd6qS8lQW48a4xg5uE8G8cVQ2aXg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g9EQRxo2bEmF3C8XIG6Za4s1fstrqTQQR+kvBk98pzjWdqAw4hEUJ2BgBg8vj62HX
	 DgnHdrGygvBXcHuJq4D0DWNnU8mUcRtxNgkqqB5tRDBQF6Xb6kbHlhG5EwIY6UUp2H
	 nsF+EeXO5fgrc7KekF3kYsabbAI38ieewUZj1TRWbmmawGkuZdNUC0EOgPnRmyraJu
	 4ThDCj+PxO+Y2s0SH0etE5j6Vu3i9ArygEJLGimD23Byw5VLKGITG34Aq5k6N/sbbA
	 rWS3/6OzhJXDGEwEqBeAasRn7wM0MiLNFXSGw52vpuldk3vKXu1RW8MlTMkDjQF4ie
	 YIPfYdRFWykTQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:04 +0200
Subject: [PATCH v2 09/23] binfmt_misc: remove the VERBOSE_STATUS toggle
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-9-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1219; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FSfISUu2uiT1hQ4aaqoGKq/dHZb/P7clvTUP8CP6BKc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHzl3qeZ2tO5/daCta3TkvgW7vaWCdHr8262vcqjo
 F22U/FlRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETEgxn+x3/dVjbvvHTnZe5P
 dWmnQw0vKhr39oVrTY3asWNdY45QNCPDyTOLc1we+sjxaM91f7svcHvA0xdCF3b/eJDVUNIj0b2
 PDQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 76C5E14000C
X-Stat-Signature: y3bpwrzgh5tmy4omu3mkstd983uc3cya
X-HE-Tag: 1783636235-715792
X-HE-Meta: U2FsdGVkX1+PJf3Hpe0Qa1B5EzdpkQtmlt4l35masXT9djGOz5x7sf0AmM3GUydiwJWqzWZ6HpXZYv61iUiOY8GNz3oMYnwFqC6nCEx+76R66+qFPamgbc/LRELzH2XYX8cHiwfAOPLA5GX6wzsh/RED0dE6MZE4utH2wJ0oqln2laAGuHE7ZPe948397LbSd00MXJfRL89JVlRGYuGfSswi8VXiEnOc3KVP34VR5+vuN+PxO4gjnIAEPTpkn1U2BmkUwP6tWpaFbzlpL21qkibdF1lrwAm1MI1oE/SL6Kx7OQJ0Cqmwyo9/DuK0RjyeTDwYFexsjpEwyxtbG9VHI+N7PiNdQwN36+SVci3ohWRypeDxQnMpX3cIvRduzd/nVJ6H0kae9sp907Vq6Jg++1L9K54aPp/lHuYUeO0CHbMhaR+sVPVONRFhwi1S4GXkhiaD6yYUX9mtUxb/+XmB7FIWvjvcyjGc/pxBzA1VP4hV3nXpu2HfZCnVFqvUNxnr3AARy3AeugBND9nWTI4Lk9WUO9VZ50C2QYQSRh40sXUueWEHSM1J4ljRJuJWI5RcX6kPgLHyz3S0D8qUSbT3ljZSd1jmTczgu3oECz16sMWYJlgLG8A2iVjWDSzUyRw/OVHWsZ+yXvaknnNcQ9ClDo8qkNRUuUmGbRmv8LLgdx5ay/johGNLU9TPXemuk4K6mDICHgz7YD8GbfVWlplU0zc8jr14pkJAEa64CtRqHRIrpv106pb82Sv9FZO1Sn0QkV2Hgyf8+oojjLNMWoDyJoj3iIDeQgkLjlKYXeaQBKHP1aNNvuxKeSKEpsP+SVpRxbwBBTLAXwJjhD6zwTfhTp5VgZo79/FNI5PB7enS9OA/ZPrsS4ieko655rCHNyZvm3EKf2KCzNlwRTtNcwxwCLDOVMfr7VVOzZ+g5o3dPK294XBbyOAr2mx1lUxNRLEe18EPdF/x38v6UIDRMpD
 USIP3yCj
 qPqeV0MqnZ8f4ElesGiICP7AAghW+PiHn5wBG9f0Hgsu5zIrU4TMcXFAzslaI0vDkTHnv4yxqM5EbLLsLpwiqX+POmMnifkWeegI/v/CUJ/IfJKvSX8AR0zSlWguah1/G/S4j/enajZX0U4h2NyrKm2i55W3VprGsvleC89DESirQHMg3+mtAljgTZBdQP443mOnviLgJudugJxvjLoHzM5TmQBwds71n+FrKdYio2g/6AS55HloWAxmfmQ8mL7SJ55G3rZ1LLaA1j6yn3hv6FOHb8b8lWRzdrOqZNejI7yQSV3+zs+v9K/hY1CgccdSSaqNLzXxcRPpWPw3F6/7gcno4K/uRdkx3yfFQERfePSVRXNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VERBOSE_STATUS is a compile-time constant that has been fixed to 1
for as long as git history reaches. Turning it off requires editing
the source and yields entry files that only ever report
"enabled"/"disabled", a format nothing has ever seen in the wild.
Remove the pretend knob and the dead branch it guards.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 93d315758d53..947ef6dfd55b 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -38,10 +38,6 @@
 # define USE_DEBUG 0
 #endif
 
-enum {
-	VERBOSE_STATUS = 1 /* make it zero to save 400 bytes kernel memory */
-};
-
 /* Entry status and match type bit numbers. */
 enum binfmt_misc_entry_bits {
 	MISC_FMT_ENABLED_BIT	= 0,
@@ -607,11 +603,6 @@ static void entry_status(struct binfmt_misc_entry *e, char *page)
 	if (test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
 		status = "enabled";
 
-	if (!VERBOSE_STATUS) {
-		sprintf(page, "%s\n", status);
-		return;
-	}
-
 	dp += sprintf(dp, "%s\ninterpreter %s\n", status, e->interpreter);
 
 	/* print the special flags */

-- 
2.53.0


