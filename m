Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2426606A7DD
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lt+YaIK4
Received: by kanga.kvack.org (Postfix)
	id EB7556B05BC; Wed,  4 Nov 2026 12:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E676A6B05BD; Wed,  4 Nov 2026 12:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08F96B05BE; Wed,  4 Nov 2026 12:49:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A83436B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:49:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EA78A853A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:49:42 +0000 (UTC)
X-FDA: 85398174204.28.BB89E77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 81D71C000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:49:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lt+YaIK4;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814580;
	b=F1X6YpvDtUiCEJlhRl3m4+eDZSQOtGCJmJZNEJimT7Lep0dz494fjlZVYp/Y4MtidP3kR1
	izVDxp1cY7GYuCsF7TNWvGd9Gen36LiHJ2sctbfu8Pu2tyaQm7GCrRlY9LxDv2WIOKX9K9
	nHJCw/6t+E+TUEFls9iHrF/qeXGzyxY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lt+YaIK4;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXeWRtHDTvlcvQqGcGXKpHSOkC75TIYAS6cttW7V/+A=;
	b=Q/N/cLyPSbqZJg/PgBbkH2bfmMhrUtf+mdDRH+D7TJPdQnoUTrjuXbtcuMKu4OVYgVjooc
	NVR8gjsdPT1y4bZlD9gF803+22FUzWilui+54QU79ldK5poqLKMLFcIEY3/wK+TEACubyz
	1E9la5Pg2gS42vhNQewRiJBbzNhD374=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA84D44098;
	Wed,  4 Nov 2026 17:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBC01F00A02;
	Wed,  4 Nov 2026 17:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814579;
	bh=WXeWRtHDTvlcvQqGcGXKpHSOkC75TIYAS6cttW7V/+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lt+YaIK4iwvhO88yz6f+jCVQ4EeVtRm3q99whbt1o/jNi7xtD4GqEdXZoJFzfX6Mp
	 WhMZbYdWqf2DxTyriqyK8bk+1pkoMOeKNlWc1KnsmnTw9VPIopuCsvCi1M52TYyyYy
	 mLRpfJ5+g7TTPX7fTPYeQh+RWFIoWO07NXukL0yXrI10YEQ4gET0I5LF9DVoDQmUfc
	 lxhs2rswNnIdaIHeRhuWnBLDBlekuRGf9w/PHx4KPTJhR73a5GVIB+8eRNFo3DUyff
	 XmvJcy95iTPua8zzn9tBaoG3qUN1vOZ1Duxa0Dj2HpRO0snpxh5ps1EWgqor16H8rg
	 xLTK+rVahkKTw==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 18/51] platform/x86: toshiba_acpi: reject malformed brightness and fan writes
Date: Wed,  4 Nov 2026 18:47:04 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-18-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1850; i=brauner@kernel.org; h=from:subject:message-id; bh=dBPyRrfA4AE5uU+SDwP01KQAXBYhly7L9ZsRpXHhzrM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zruys4H5zATJQ56FL4QUZwrEz3fqPb76g29l8a1fL 34Us/t+6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIpPMMf0V6J05hXXkg4U7m Il2PkyIVrevVp6rG3zbnfJ6waxtPdw/D/+K7i173sLVVenL7Mu5oFdvPFn8nM9t33dyDiXp7bPP NWAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rbxmey61o49mshqziz6nuo4c6919ikdd
X-Rspamd-Queue-Id: 81D71C000F
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793814580-496787
X-HE-Meta: U2FsdGVkX19RBf2JPs/2ghSFw2Gq6u1aUewN9c+szbIFMHbiwuZGIEqAtTJWeaeXRTgIqH0CK7YPl28Yie1wfoptIdg+mIELpcR+YZEHFpqjk/g6PJ0VsnhuzPk66uhIeomhvWuqpxbFR6DYLbJecPrZLotZe/cGillpA9rB5wOPoFHl8IAzfzQ/c/oZuCJBZAcotMxn9ANtOY9DDmWVEF4nlIJbYJ+ldJ1iaBMvRHMw3ZZdFUgQ//J2aPV6eM/HWeRB+azvr//hCP2OzE5Y+xBJ8qaZkxdQX/dQWuWXZi0lYf5w44FgV4zNiMQr5j7slQv8LxjtfzBwy+1yKWeFdsioF5tUTDHapJZhnypf3q6o4CGwQGf0K4PbaWZvQRBcx5ill29FSxLIoK9MH+sMHpMtXO1Haw4/I1X15av+uh4CGYUCidQzDVilRAbs5g2cTIbFMSgQAasqFbzWcw5FAHQouD+DB3WdqE16k9PPnStXNFxjat2dzU1KTKDbP2CnAs0XIDXAwb/2UxTigQ9Dqs1/oMXdi/0FW0EzgZayizM3GQBKocMAVgsBILEiKbWSbb89XVkhqz7a5/gHb5ie/i+YcFY+vFrrPvUbqr3UY7OXNqihClbhzAPdw1ZjDQut9o9LKdjL5P3/yhLMqgCu78gAXDoTASZcwEC+vX8WVDrxTFyRh6HQnnXAshOQFFo8ahEiy7uasGkY3d9GYjVvNgyil04fpzWXoJYQxsFiGRRM2PN6HfXVNAsvm3YNOQTHOitOO36wVLI+oMRZlOmZRTMwuwL4BVatlnqBkG/DjJCvCUu4RgR4+hFTeBtBi3f/P9wvnzSJKPSWmjuaoR+QDUikZyPXW38KhQXkTwKm8pJVxvH3FsRTyycPH+Grcm7SehGJW+FzgycVBWoofwr0pw9IGtD7iYMqdlMPiu1zRvTKSiBC23Nmw4q72uBTPdIN86zq19o6sn3Up0ElziI
 uk8Jhdl/
 ep7FkXKsAYr7RamKPP2bKkkOlxSELRQBZBR0KtPQnATDCW3ZMi+4raYUL7w6yg4CeItXErhSWEtOIL9YgEWpIRQFgnE8gwQHZ/KZRSJdmTG8yNujL0oSyL6Rz0DsYt1Qnifl/ZikLRBW48OOAEhBLVS/Pf0JowbtHoPkmgkHbTA7uVH799X/liUcqL0pldNzVV0DdMuDQr1GY/s0qPq76eTQp/2ALliFYDBTQdLfXObCKHG5yvfEJFjB261imzmsiq5Y3WtqCS8PGB79BC3iymKyw9RE/Un37cH6nAdtIH2lefHLsCwf6NjVwitsVSfaSGGosX7e9StrYlDkNpy8ICJjsb4/u0JD6YvGOSyMhg+1cs394TsC2sX6GZk2L3FbfeUMMqjPhuyp8fOqKQEkt1GLXrJdbyxwpbe+4TUGFFUYJKwNtGuMcJtJ1Kj7TECis72Yd
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


