Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B08D2C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814AC6B00A3; Fri, 10 Jul 2026 05:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776BE6B00A4; Fri, 10 Jul 2026 05:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C3A6B00A5; Fri, 10 Jul 2026 05:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47B506B00A3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B88E5403B9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:42 +0000 (UTC)
X-FDA: 84972354684.06.FD15563
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1954CA000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L1eOk0sg;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywj3OSM/tpO9RFBhWxAbwFVrl+4a5zu77M9ARvzXN70=;
	b=5lcGYmnxHOCOo9xqxA9g7SGRpxbfLtu202MLEpi1oSuFHYTaDJyg9RcIAa9KBU25v+dyjK
	j6BjLJTufWC1ifceoK3Fe3LcKGne8cOFY6q3/W1n5wFS1tg3A3iZFE/p+S4PHU+JEz5Mhg
	5V5tk48gyueEUAv6nwyxe1kl3brDJm4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L1eOk0sg;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676021;
	b=YnH69DNq/nxcXxVzESw2cLVl3EzIvr0V+4z/8y33V13RTcBPUkyAVSrP20fLF7vqLpMnLa
	OsZF6Pff4a3XFNciIu4fIoxlFMY6yQVi+AHB+NlYtMRHosSSyw8oNYTM1CpGzuUX+h39Mp
	rKIgb86K14QG431BVvPyLuQbFw7Ok2o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4A0D6136B;
	Fri, 10 Jul 2026 09:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126851F000E9;
	Fri, 10 Jul 2026 09:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676020;
	bh=ywj3OSM/tpO9RFBhWxAbwFVrl+4a5zu77M9ARvzXN70=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L1eOk0sgBSNn+NBvcHfqDOGZuUYkLtu0mT6EzsNqXIiwvPJNXSZ3QXdpdblrB1+WF
	 CbGt7NwXCJkauourAc8s/u2gJApHrhN2X4kdJWFJhFnZR5KPhoAF5iezWd15FLNZLL
	 w8SFSBTInOagZd6gQkcBCEwYw87OUhtIe+WVr7RpR+R3QqIjvkM4Lrq8iWbhvWJfz1
	 ZPR7wUeeMr/7RnmlP8liGpLDnhJCxUdAP3auCBvrWUii0F3t/db4tSFEEQ/QgwGbX8
	 LCYuEfRVqID+a/whgPACvYtUjqgqsssABfjrZRhKmevvLMHQbk75YPgwAjuYkuYCTp
	 3bkMMNR+Uj0Jg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:11 +0200
Subject: [PATCH v3 10/24] binfmt_misc: remove the VERBOSE_STATUS toggle
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-10-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1219; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FvKU1KMxNauxWYEG7K5xbJSNxDdCZCqayB1AbvUm0s0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7InLW7r9146G2PZtwnxv3M1T/wq985lk/6Zy6UfTx
 WVzT/1s6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIFVVGhs0WCSv3/ft546n4
 2aMBM+7kdxYf7LL6t7nrGNeHnvJCbj9Ghk8RprJOnYK73E/2Lvi48PB3af5zu98Ldcuf8RXIvav
 1lwsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ogncr41ortcwq96upyk39ses9jan3bt3
X-Rspamd-Queue-Id: 1954CA000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783676020-118484
X-HE-Meta: U2FsdGVkX1+EZrg4KsYi3SQ0hjaXH90jqE5lx++bILmSjfdUBQuW5jigQmriJK9q+te3xKNdkI9eBzW5jWtPtagwo38KFy/aFEij6p4mln+M9pOUd5wP7g+O2seEuNGP7ToPpugYD4jUkoL4Xb64EcDEm+mgkwkBbDyLNXo44izF4Y4fr023pjZunrmhJMy3wqAhzsATYCAFR4PUbAPpoATtwnTkkSnsbE2WoAL5rbjyFkLogyCWLwMuQ7J9Rs4MWa2xZZqVSnXcj5PcPzxMmzLRy+3RfG9dgCU8IbhyNd/FjsXW5HZN3FzPD2ADbrC5lRx0ynECRWwS8YvUbOgOjH/iC5Ax/xqLd3wm1c4JxExMTilaTGqvxtqDZzGCR4EPGA0pZ25wzz3K4wWHTT1OnTNSCgAsiNaqZzMSjZKf8+cZCyoGJQRhObwNNpJK2NKixbMYBq8Kk2pZ5uIvmu9qF5VlGVkIfCfHoee9qsGk7YmcCEX1cIz5mNOXXgT4/qM1NQ31Jvs/xP0tjwqqSQ1oadfvB5NVlwx3tgl0HSvI6xgUrr3Dh1UT5jT38DacUVcJT1bUTGj3OvrOVeZtydklgG2Yk9vCpMiFoGAAo2F65cHdA6vrPpD2h+PnP5m8ZzJt+cg7WjHkaJUXHA0qEUYp8DMR96B6B+AEYNEGdSyy/Dn37Qun5JWRvawWNzCVL1KPhJ9YXJYkiBXos6CljX/atHc/SAZ/5MR3/ffqHRpQ9lcxexnfUfpCcWWpTVyel1HYFKVoXIsZqMRWqAqqX6AtBtJ/hbbZ+TLp6LBvfePCp1lssj5PpUMYW1CsGEKqruX+2/mHOV8ooXCEkiwIzB4Lwt0RZx/NN4qTB73DECE3Kz/B6aWcmSmKgQLMjSNFtpGZhB0KjLY7K4LcM3mbC76N3VLkVSZil0Y9hZ6WTpVDgaESODfItvJDTjttBY0HaRsLCvdDHGA+tA9pgk8jjzg
 3pGHlHbf
 F4DmEo4jTgMugSgqGRvSl53sZuA7T0FfPY9ydOslERlvQPStXn3tLv/phL0R+x3vz/XF2lopKKMWns2elANoG6dqmWumGu218ewRGb7QK0iLuc0Kf/utdMPXAECBYQeqgRWBvHle9GQoFOKVkPMz18iEHsO7HGnH3mejXXdL7HBC/PnE4h1myhWzXlpTc3D37W8AZJgsZlwxrzK93xbXmQ8wSQ0Mx+IADVoA43lnWf8s3LR1H+xEjuMJn6NRhicn9wANt05dT4dKfclWCcBOw7lSKsAejC7fCiGnmik2vEmtEIvBr4G7TGu7dKusNw/cYYr7CrOVO/0QLmdBsf0WV6bkKMM1nghoDW/Z9WALObmBZdKE=
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
index 9be57f387524..96f9ac752511 100644
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
@@ -611,11 +607,6 @@ static void entry_status(struct binfmt_misc_entry *e, char *page)
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


