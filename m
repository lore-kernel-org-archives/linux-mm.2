Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BF7F428C9
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 19:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9416B0005; Wed, 15 Apr 2026 15:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AEDA6B0089; Wed, 15 Apr 2026 15:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C42E6B008A; Wed, 15 Apr 2026 15:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B11F6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:37:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C939E1A05D9
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:37:42 +0000 (UTC)
X-FDA: 84661799964.02.43348AA
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id DA73CA0006
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:37:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=h2JAgEER;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776281861; a=rsa-sha256;
	cv=none;
	b=Ffo7NdRSuqL8hRkDahx5oszsP7mSle7tfLLNJu4UMQf+N55hWEpEaD7XG+XBwsmoSQIEIQ
	6wVcfkUcTVFXZxNhwQYxyMt4xdHhXmW12BoAzqBsg0M5twmg6UwGYlNgjJf9qHiBIlwCdR
	zLajVxugSRFZ8B0Xlcs691JExKrrxcA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=h2JAgEER;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776281861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5MDbzO0CGfZP12oWRbENuxmCpD7S72IZUtgRoyvkXQ=;
	b=NBzQ6enb5Z9EkD0Svg0dHpde0+mgnMPns61AzcupwDj36QcWPZ4T1/ShU1JnaLq8/WZfKM
	ny344o1RmryLaW502giofhH8miyUs4+zHhWc9nqskpLVcYjYnydAPftqHaglGZupuf7VU9
	Qy9fHwt1ika5HRzLETVt1j1AUWKZ4mM=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-506a7bbe9d0so56747961cf.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776281860; x=1776886660; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c5MDbzO0CGfZP12oWRbENuxmCpD7S72IZUtgRoyvkXQ=;
        b=h2JAgEER9gLMgp/Toggd48eozo7wWLQVVO3LYHUL0p9vnX79fbIWQqxZcA9f1Ec4Lg
         P/286X7poqbOhnQ/T8aFU1Eeaa1AYS8MBX8NH601BvLKbdDfNhdKpdqjCk5eQSY8JL4f
         BVKnQqYGk3Od7HFdGbV+i9BCX5kSDPgsADI0CPYMBqT9j7CCDpiOnMUCVdbFtw7rG8tI
         VUKlT+ABSLkorf8uStaZyod7PbPaTvK9yCIaZfaxsDli/uxd3hsB5ToOuX6IW+qveJQ9
         oA4Fb2BMWI9ktjK+NHlkDSWc8n/E23EhchTX22YUYQAMLHdZtRFnjorB1ZNWnrNRkN/w
         xF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776281860; x=1776886660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c5MDbzO0CGfZP12oWRbENuxmCpD7S72IZUtgRoyvkXQ=;
        b=FayglxZFjccgLGgEEB170m0eyTQ0pyTNUf6p48nlorMO5ZUoDpFpHI+UBkQfgiTlB+
         8f9iEtaO1sYigOqR2GLQhDfDCLAEVQzw3uquHquXbOOSm2duHI84sRfUalQdOc30W3Bo
         peSYXP+rTFTuyXwf+yS5ZldNKyz5puiflF2FMfYnRFTRXUqIpYSzVuJ1MYD506UL0wpz
         PayPWOv46g4NdDFuQVyhh8gKItRNcU71XH6+K+HlJlWHdOv4UW0GP4fxxQoGUXMzBQsT
         ti2xDnyb2f+rUGhf3/xh0bBKM+jihnKj3m4XZEXSe0mIeFHNwR9wjhRYQ0axDtcKDFQt
         BGIw==
X-Forwarded-Encrypted: i=1; AFNElJ/bHd9XAS0U7ZX2oPSMgjt6r7SPa0Lu0Fqy9sgOeDJf36x4etzt+o9b8FSQ0jlCXoB8jDbILxsAxg==@kvack.org
X-Gm-Message-State: AOJu0YzeQXcbDzYOygb+6xtaSNkWWITXnxB3YeiPqz4lZpfV/b9QF7Jt
	KMh8ky9YWVzeONxZosfKeK2Q0RIZuLU3oGSFbv1/HGSPh+BltSm+S0AVAW1wWL157PZBaeFmQVp
	jQmAT
X-Gm-Gg: AeBDieu6MEMwjQtNrcrCbD4gG++SWvPGydIeKW99XgCwYgIkqpAkqO6mzhpbsMIpmfD
	iKCHu67PM22il6HHlQfVhNIigtnDwREw9/dsbQN1AOsO1ecVcC6lV42U6+neLTE7mDi0lldSBLn
	pCxKZ7WO24C+JA92c/EwbnTOQyiiTXxj6h2Kv/AfY1jFWicv0+B4EjSPACaugZZRa7BWuSDOIWk
	YiWHMD+QiO1WQZ/nwfatdujbDcKtCbrsv1A4xi7rxMGhj6muUnIjjlgtjQZ2w/GidOMthjddLqA
	UuuBUnnqdJjDXBDBLgfPiSMxMCdc+Qzqwk1aCxCU9SbYIWAZFXnwkkhsZMWUZS53seffBGz7Uo6
	0/8egUNaq1C5A1hrioVqVz3RetYgIZ55+moE0YjDlKVnZEkbniFxnT3Fz60Sj6e1Ce3mzDcgSYP
	IPoAsAovAG5nMof2Bb5J80dnzOYWWQJWGfqu9lrB8lRMmVXkVmaEsoXMva+/s7fs5MEQ==
X-Received: by 2002:a05:622a:aa4a:10b0:50d:b164:5e40 with SMTP id d75a77b69052e-50dd5b7cc85mr271864731cf.37.1776281859850;
        Wed, 15 Apr 2026 12:37:39 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e1af9dc5fsm19788171cf.16.2026.04.15.12.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 12:37:39 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org
Cc: pasha.tatashin@soleen.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4] liveupdate: fix return value on session allocation failure
Date: Wed, 15 Apr 2026 19:37:38 +0000
Message-ID: <20260415193738.515491-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ad-xwh2Ecr3Yg270@kernel.org>
References: <ad-xwh2Ecr3Yg270@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA73CA0006
X-Rspamd-Server: rspam12
X-Stat-Signature: x9uo78zq11b6aq9gnf18namjqqwfrx5g
X-Rspam-User: 
X-HE-Tag: 1776281860-917996
X-HE-Meta: U2FsdGVkX19z/nGJrPpoMZJQfq3yTnIegfab4XFhE0Nmod4cg6CIa99TtbbxGLnqrVrS4+u8lnOW8cHnm4HJVvJpkWIPWrmle28NOxBYjwxVM3KnWuf0u5PvjO8TNQniGGOCp1Kus6JCq3Zwn9pGKT7ttnESScwA8vc6y6jcno9xrBb+0zi1llFlR9GifKjm6qoHtspwp8lLsFTsUWyu8hl0CIZ8opVXmWAtIuABpW6dJQ9VisOX0m4USaCvIzFyvWRQCkx15v5OFNpLFKMOJlGmN4yH9cuPoqR2MMBiJ42ohgUO9wRfPLAbxHXXva77b6PfdN7RiQXHl8TVrdGiGWrtjptvN6WZan8nMyie4+Ld7EIJRip/SD81i+y9V8r398ZaKAF7tbHN8ywE88BUXAzaw4QnlktGfhh99zNgXeyMrvPkvjy5i/1WdBVd2dPFBaKt7uMRs9fvKJ6NdehfWIwmUZ6ymR4sJ+R69ZraGU2YTHtIOhYGI1s6/FirtNneFh2yk68TIIWlGnt8hW2bjV6mhNL3acZn8GQXh4K3XJetlG+2YoLwZ//bPkuq+2ChH+4pcKuZF6oD9X98WZYTiJEFqDY9CQlZ2hdTaOyGBJehdy/PgfLa6N0JnIJqs+rH0vkESJZm8IIx8YJXUCjs4ls6TLHT0azZtILZuQETT1oiiLRiSI7Aw6W6gUma3XKPNxHb4zDb31pO3MFc92Izfbo1G3Q61Z2crPHj84APSCyg+oQqkmZWZHqp7koTeUJ2G1QB/ImJHZWwdHE3C8M6Kp6o6TtolcnOOHT9PsdPqmBkAQTnrAC83JHSIwOpFGjEue7h4q0HKDcOEuEgZmpSXWw2GHEWNFmAqaTbWywMLPotsUG4WC2JwRJRzma9ieXapVLr5pdsALx36fBCuIo4RpREpsIL7lwoUxLD67JPoSxcKFlAE+6w9jM5GDhb0GEB0ujqlqso7hSgow5usbm
 EyST7S15
 mseVCX0rfxNrGGIKLCwivb0fgkj+dqOLos7whiz9WelrDVWm8L+jFY2AT9bVgbX5lE3JKvdmBW6UC0iNZ6iiKYqrLJ+PUupha6a1yIeCw9L+tzR/b1nEEM7osEqGeTBC86pxS3XmO5tR0NmBh9nkxW89Hx4KEtaazK/yWzvolgNL6zcvpsOrGM0sTyylacHL8b6r78Tbd3sGzc5Jdvrpcc0IJQlZQNsyxkMSawWWNP/J4kK5Bkr2rahi7wq7QuNbmnun2d+GDLAtnBSm4AtCTTwE/TsPrE1HiDoOU+1JfaPyW3nJLsnjv0oBNV2cqLDQTekHlrPO1M9f0EDfe3Evn0PJzSHG+KB5SHccQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When session allocation fails during deserialization, the global 'err'
variable was not updated before returning. This caused subsequent calls
to luo_session_deserialize() to incorrectly report success.

Ensure 'err' is set to the error code from PTR_ERR(session). This
ensures that an error is correctly returned to userspace when it
attempts to open /dev/liveupdate in the new kernel if deserialization
failed.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_session.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index a3327a28fc1f..7a42385dabe2 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -514,11 +514,12 @@ int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
 	static bool is_deserialized;
-	static int err;
+	static int saved_err;
+	int err;
 
 	/* If has been deserialized, always return the same error code */
 	if (is_deserialized)
-		return err;
+		return saved_err;
 
 	is_deserialized = true;
 	if (!sh->active)
@@ -547,7 +548,8 @@ int luo_session_deserialize(void)
 			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
 				(int)sizeof(sh->ser[i].name),
 				sh->ser[i].name, session);
-			return PTR_ERR(session);
+			err = PTR_ERR(session);
+			goto save_err;
 		}
 
 		err = luo_session_insert(sh, session);
@@ -555,7 +557,7 @@ int luo_session_deserialize(void)
 			pr_warn("Failed to insert session [%s] %pe\n",
 				session->name, ERR_PTR(err));
 			luo_session_free(session);
-			return err;
+			goto save_err;
 		}
 
 		scoped_guard(mutex, &session->mutex) {
@@ -565,7 +567,7 @@ int luo_session_deserialize(void)
 		if (err) {
 			pr_warn("Failed to deserialize files for session [%s] %pe\n",
 				session->name, ERR_PTR(err));
-			return err;
+			goto save_err;
 		}
 	}
 
@@ -574,6 +576,9 @@ int luo_session_deserialize(void)
 	sh->ser = NULL;
 
 	return 0;
+save_err:
+	saved_err = err;
+	return err;
 }
 
 int luo_session_serialize(void)
-- 
2.43.0


