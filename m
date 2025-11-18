Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74134CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66878E0022; Tue, 18 Nov 2025 03:41:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16FA8E0002; Tue, 18 Nov 2025 03:41:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54888E0022; Tue, 18 Nov 2025 03:41:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B891B8E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:41:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55D9314043F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:41:42 +0000 (UTC)
X-FDA: 84123084444.26.991F693
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A3C41C000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:41:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=kRoO2gVK;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763455300;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wj6NtuoUx6rorSoJrKwRjGX8DQ+3LbRm6UPbWp7kXpM=;
	b=QC/4a6eqTIFs9+24kWZ/UwBBm2vEb38rjcr3yGO5BWS+JdJ9aD3Tb/1JNrMOheobRRX84p
	ZXRP+/ODnJf7PZfnxwhVbHsZjltV1QBlYHapyjgUlo+6plFTMXPMOmjBHWJniQ0D21S026
	Huj/rXCMTdPP/2xb66+vN6bU9SPjCtc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=kRoO2gVK;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763455300; a=rsa-sha256;
	cv=none;
	b=ZOU2PfUo4o3nzN1TGrJWKW8obVJAxIv33C1h2nFw/EA8CQpmiw7kPfYnzhMuL3fI5Yo7Gq
	SraDBv59eOTHKtzb8wbmIPMKxE7ZmIbHT/paDeLxahb/5PxlWycXyyUpLjUpnuPbGEOcVV
	5lZxd7zBh1CJHMricQvz7Cv7rUpv/pU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Wj6NtuoUx6rorSoJrKwRjGX8DQ+3LbRm6UPbWp7kXpM=; b=kRoO2gVK7d/cWqBJ6oqBUlnxJH
	PhTjJHkTsQ83nuQ9+vhtRJ8QzehJ3LyLXh5vXFlKySjTDD2J39bDe/QAeQjkboxVZ3qqGUZIHXKnt
	t2CTLX+Q1auCj0k9O/9fdY+TiRGfykMKhF0OVCj2HS3tmT7w+g5QYzstUb/2rtQknF5pkF2vamB4H
	RYoIoGtUJrv8jQISXhpX1bgNQKTKn/LFLjd7/h5fo4kg7ypdg4GaP8sX0RyEPxEjIEOS/Dr+nz0GT
	JreJhFuS/cYBtc965Q+g0ADUymVs0TT+phfONbdrB9vnyxiJde8/FCIJ/+y7e3z23zj+RnwyTeLEq
	Ww3jTsBQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4a-0000000GEhn-42P8;
	Tue, 18 Nov 2025 05:16:13 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 53/54] kill securityfs_recursive_remove()
Date: Tue, 18 Nov 2025 05:16:02 +0000
Message-ID: <20251118051604.3868588-54-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9A3C41C000A
X-Stat-Signature: s53iayosbbebdcun3hddaum5ywana5ao
X-Rspam-User: 
X-HE-Tag: 1763455300-170888
X-HE-Meta: U2FsdGVkX1/TYbTHeLODigvfH/dMVZ8weGpBd9YR+9sCs8FeUCwM/WWaq0d4spZgqyFj8XvZOzVJfGcEVCDP3KLuGdOBN1nE1KnRksD4pWznaq0WJ5CwXkJur6BoB0JDCwafDgC4WohmqkNmzwXmiPWiBDrsPg51DHqt/oz8OixZx8bRCkX4jA48MBKwIP1J517+sfJUfXDrOvB9DhMEvzVkpdEMeaproeZeOsJnD5oGc8mn9rFUei6KqDncJ9WnkTXWdfWuKnqlDr6sJDumAwO5R+gCxk5pd57zD0GaxaqDkmmT2Px0tN552zurdoe8Ms4mSrP+4QFGSPhML0QYg4oToNtToovwpN9E3kVwy/utXCBGu9QnNBRFquBk5BWFaVTBEP2yumLyArj9Op+jSuME4rq21DIqb5MKawifzJtCA2EAIwImAD6GcSvY9p2fPNOfK0PMEysJU5RCX3lfWpfF0dm9nG02qEASWZ5L8iYDkIuNLg35q+2DtaCDfxXn6kT8rvLIzp04RNiKKfwiM6LRI1Kp4yWjLm3IHUy0gSj4kpVWhU4po4vk2dXEchnPkJd83+1VoALaGmfZC5C00h4gM4Taf1LDurt0liHfYLZG74nBlRtq9EiQnoLEi7b7G6dvvuH3qX+YeD+ka696BXYPywacrg6GgTehZX+Q1SGJoV2XEqV6cdtRS8zifnr6EZzvHIkuDdBeYuY0U3naib/I+N+OOVrjqJsnJbAvzDggKTkryJ+Wv1FP5tn0UgBqlHZJYIX6VF9jTLCZqz83YUvdPTs/BUPCvT6oUnHSvRC45gSuXrlnMZ3ckVq9P4brG7SK/W3LH12d6b7NTzTaNDPhO9u05R+JMu1nvAderK+BE8DNnAc83BkKemZctshL6Y670/NSJFraQ+RTDzyYcsA2ABjhu29vVwjVj5oxU6nrJwF3xwVG47CSzqUdAfDp2hVH/v65fuI8JF5Bbbq
 lEIb2hNb
 jLsNga+oXL1TthTZGum1bxvfcGBvX8LAPHOqmEW6QRsPGp2he1IKhpWKmOvxV8RTNJySste7cNSDejaOOlIiGGr+uNRAxnUWY8AOAUytSQnGdW80WtSo2hN55lhJFEmLg31CdIqscLi+RwUc0qGWi2RM/tQ0J6N1IHe8jWxH7vtI/56RNNBv5njWEuHU7HDOlkqKr/mSr0SplT2tvzOyKOvha4liGYrK5D8CytRDUD0aB3IETAKeLakBPPqRzHhZVugVSVUF3KP3MtxWC2gf6ZXD1InUwBr6jXjz7tVF8QcyUmkILquc8kLd3HqPAl37jfOCzDhlc7KGsjYFVxRpXVLMXLTeW2WRAfTmZx0Gvlq3NiqT/rnYgqvEqgfvlimxiIIl9BT6tw/BD41xu2yge/IsY11pAVMgB/ooGoL56gsOh4gv99dxu+uetmn9w7VzycWENKZE2xnmOtOl06aE2BAZhgjJQRhXRipPxrx7CoOny1M3aTVmynqbCKijpyJK4O8oaE5ObcsFJ15Kaqy9KdePiW3YfBH5SVSdPFJTWuiHQNFp+o+9wV69OXHH4oKXj6TMYg8hwQRUfaNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

it's an unused alias for securityfs_remove()

Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/security.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 92ac3f27b973..9e710cfee744 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2258,8 +2258,6 @@ static inline void securityfs_remove(struct dentry *dentry)
 
 #endif
 
-#define securityfs_recursive_remove securityfs_remove
-
 #ifdef CONFIG_BPF_SYSCALL
 union bpf_attr;
 struct bpf_map;
-- 
2.47.3


