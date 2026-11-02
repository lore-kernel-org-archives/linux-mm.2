Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EABA060A2622
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kvHRMzqf
Received: by kanga.kvack.org (Postfix)
	id EDBFF6B05BA; Mon,  2 Nov 2026 09:23:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3786B05BB; Mon,  2 Nov 2026 09:23:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2956B05BC; Mon,  2 Nov 2026 09:23:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B25576B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:23:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39C0CC011B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:23:01 +0000 (UTC)
X-FDA: 85390395762.29.446DBA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7795FA000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:22:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kvHRMzqf;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXeWRtHDTvlcvQqGcGXKpHSOkC75TIYAS6cttW7V/+A=;
	b=Aoc8zDR5N7OPTZBoCQjIAl48uGrStiG7Or1zL3Tm0uaeFD37mV0vrfniWPYLddOyFWIbci
	FbYBWcW43UO0U+eaLt9hstci4XrMlveBomGupZg3+d0Pbwa8XIC9BZ6qpumMDJYM10vTMS
	wmZwOj9qjdmB+85dhGOO/aE0iTL/tBg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629379;
	b=kIeQXEMELyf39YPmFuSrP/9VpggPzkFQbObMMld03oGiFFjcRtFBbyjBflJgO0JB3OhGzE
	m24s9kf6waCyI1hVh1Hz/stSC29s9CN/K1nkxdv85xVGbQraFz5MPYXmqHBVwtSxp0tQvV
	iVk9N0Yvq/p7qMCD1qUifBGVSrS9pfE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kvHRMzqf;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09D3C602C4;
	Mon,  2 Nov 2026 14:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AA61F00A17;
	Mon,  2 Nov 2026 14:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629378;
	bh=WXeWRtHDTvlcvQqGcGXKpHSOkC75TIYAS6cttW7V/+A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kvHRMzqfiFxfaykdXJncqNCKytFOYdWEA6z2XKwrpx1cXAUWC/1f6IelPxZz69lt3
	 bZzGsPY7tAF+nhMSErY6rPc/3QL/4TA7hlVU8tM89mYfPX9Z6KS6p4IW1PsDrhG0OQ
	 bkcIKIyEY1GGRPu5UaBXvghHdY/CIfOPJbzAJZHTg7fVeaIOTOcs6v9yzyjdbAXIjO
	 eLo1eYZ4IN84HHP6CrAMeFl9oPgWiHXBV4hrBwe2eZenA/caTo8Hx2CSrazCqEHP19
	 DS3uVg+WucdQObp90U98MCzPe1bAhdyoN7eZZYLpOUglkgctnTto/e3gh/m1uyI5m1
	 KND/LIH3rUy8Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:20 +0100
Subject: [PATCH RFC 05/38] platform/x86: toshiba_acpi: reject malformed
 brightness and fan writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-5-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1850; i=brauner@kernel.org;
 h=from:subject:message-id; bh=dBPyRrfA4AE5uU+SDwP01KQAXBYhly7L9ZsRpXHhzrM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJP1X33fLpsJXpWBaifTEsT2SLto6RSE/d33f+fli
 mfvjj3d3lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRafMYGSYH7L886UKoRuDq
 G9c+FRp4acs2loQbL5Kbz/ZCoj25bhYjw/4HhzpE/VP23N4kdd2x9P4SBZmAjRbxpyfu2bkqlD9
 1GTMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7795FA000A
X-Stat-Signature: q7588qgf184fh1qqk1hgghueipyekzpt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629379-492449
X-HE-Meta: U2FsdGVkX1/7v0fmO4J9Q5PIPuOzlxulsA64tlGqTy9X5dRhzmnXwywpe9LIbPdeSbKGB9QyrvUOhNbJSqyDX//J49RtaPXjhCCYvPbyMsPpx3QgtbAyyXsRNkDD9Y5IcyFxKMIsV7XRd70tS2nPUtU9fDbR0AsQdp2E60xOJqp2KgTchpr/9+R4xYflgx7qW3ZFpmHmwa4uvUkgd78TqwQoDgujkROoWfAnQ8NeBrY5ya+Xg1eP4BPZVCplkNYpNoVY1BzjYFF0GxnLmIZ7r8fL5BC6HbXxgwUeRSvpyt8jskR/ctbnnXlVFkPRmMfbkQXI5W6FJycVw+VeaDSBelXClZRB2osHWKf5EM/xXn4R0t9k3w9PjRsgNgZ7/7blAJCM+PWVZmLdoS92VlkqKCBUTCv3uM8x4ailT+p0/PkV1AhlVpSVuiUtI534pmb78tuDxMjeRW1ImmaUC/oEPSMREXp5bg05GnrAUpkHT0XH3eg88c1hYPzAyyxBQhryAwkxdF8p5hGbzuSuR4SwHVBm7IO+lFCtuD34WsWZqVHs2KxZDm+ZIG+LcLazfAUMrgDWmBT3c/vErhUOmK27W8AgUPopkWI5ooyPDaKDWeyM3JJZMsdjqA/7sWErBp//Y2160kK8JwKCBW0JGLdCrlCzgoiYt2fggGjp4tJEip3xbUoQWMh4s3StM5I61Gm7r9Q9e8gAh9n2YA6FRPz64k+rN8SnWOjURGuavH5MjRbu1CgYa0gtZ9jBLCj/CIkEKvquJDnBkRFK/avVkrCrWfuPhICtSLxHZ3/r8eUU0NPVVyN4ProPvalJZRD99WuHOZUBOnEYlVx5QaGsh30y9af+BALJygTdl1gUc2U/L0WZK5kX5updnyYOqoC+i76v55S0UP0TaoNyF6+1PMt4lqmNy0Dj4gndqXTWNf8aIeXT3Ct2/Bo2ReHfCAsl9l0FQS6MTU5r8JiX5g0LZ8H
 d+yZ1x+z
 LdJ4vaw45gGyMjSmQ1KXp14bBMRmyuFetGZUyMauaacyPT4yjtKSrby1oZVFW/3PChsruYlC+AiMPYRCLHOecIZhxEDLj9y9DH7O4BKUl4Jxbn00/my4j7BUkHXL/rcPOxBjzAvE4ZbYhyeySikHQsIwpNKiipQ+5uuUUYov0+T0eRnT2fFzQ+rMtma/EkiWZWXiwB2YAocBgDtmGxxSE++lPiR6ti/O5ehPyAVIdnXCzalBlhAOZU2OsvbXAyd8r3nEpMQp7TJGXSBHXvGz57n08rhkSZ/sQDfN8YTKXS3oaXCAKCKhy1xrVKpqTbWMPks25YIyuadYGA5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When lcd_proc_write() and fan_proc_write() were refactored their checks
were inverted but the && stayed. They only fail if sscanf() didn't
parse anything and the value is out of range at the same time, and for
the brightness value < 0 && value > levels can't be true at all. So an
out of range brightness or fan setting is passed on to the hardware,
and so is the uninitialized value if nothing could be parsed.

Restore the checks as they were before the refactoring.

Fixes: e1a949c1b988 ("toshiba_acpi: Refactor *{get, set} functions return value")
Fixes: 3e07e5baa2af ("toshiba_acpi: Add set_fan_status function")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/platform/x86/toshiba_acpi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index a0b8060836d0..9eb8f1e5aeda 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1498,8 +1498,8 @@ static ssize_t lcd_proc_write(struct file *file, const char __user *buf,
 	cmd[len] = '\0';
 
 	levels = dev->backlight_dev->props.max_brightness + 1;
-	if (sscanf(cmd, " brightness : %i", &value) != 1 &&
-	    value < 0 && value > levels)
+	if (sscanf(cmd, " brightness : %i", &value) != 1 ||
+	    value < 0 || value >= levels)
 		return -EINVAL;
 
 	if (set_lcd_brightness(dev, value))
@@ -1678,8 +1678,8 @@ static ssize_t fan_proc_write(struct file *file, const char __user *buf,
 		return -EFAULT;
 	cmd[len] = '\0';
 
-	if (sscanf(cmd, " force_on : %i", &value) != 1 &&
-	    value != 0 && value != 1)
+	if (sscanf(cmd, " force_on : %i", &value) != 1 ||
+	    value < 0 || value > 1)
 		return -EINVAL;
 
 	if (set_fan_status(dev, value))

-- 
2.53.0


