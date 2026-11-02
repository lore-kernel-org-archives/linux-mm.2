Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC073606B0EE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XY7sAPiB
Received: by kanga.kvack.org (Postfix)
	id CEBB06B05C6; Mon,  2 Nov 2026 09:50:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C766B05C7; Mon,  2 Nov 2026 09:50:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB24D6B05C8; Mon,  2 Nov 2026 09:50:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0FE6B05C6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:50:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EEE0160118
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:50:05 +0000 (UTC)
X-FDA: 85390463970.29.07FAF6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 90C9020002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:50:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XY7sAPiB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8LiDRsnJChLwJhIiURqMi+IEx07pT1snt20aq8E9rM=;
	b=Aru79B8pWjy72G9r+uXYzmpvYtZNUGt7mD+HEmhOQM7aCu+wI5vTuD24s7f2ZRq7abcWCp
	d77kqa8fewoCHdpZwJp7rE1vKhpLrIkl34OFCORHn0+1AnvGroNPVaBxxLxv4Q098k0AG/
	dV4/FrBHKVHrkGEHC+o4Ysi3Q9v6Sk8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XY7sAPiB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631003;
	b=SdVm6qfgarmxVkmAr50VmV9lhhbzDxPFjs2T/fMeYWiXaEEV5jAs7y5NcaIGqsxXzYVBvt
	maL58Ba2TdT6TS/1gyY7N5TIzmRK5spqECikARCniYzhKxiEntpWi4aV1VQRwfEgbnXgGg
	L+H6r+hXuZDvjeYSFpfJF2blnWU0Nq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC68D43B20;
	Mon,  2 Nov 2026 14:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F511F00A17;
	Mon,  2 Nov 2026 14:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631002;
	bh=D8LiDRsnJChLwJhIiURqMi+IEx07pT1snt20aq8E9rM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XY7sAPiB6xKRBPRrgdmo5CijbkY/r6DYQxS9vxj0LNqLx1chyKoXYwlcmR9Mg/gpb
	 F5C0xihgbQhfrRyBVIKVVrcpdePkU6bEJfTWaA6K8y2wjqTkj4PljLtUxCT7+gauaD
	 vHwKtdNq2oUH6aKWC1zQ0Fmc3y7lbPX7eigS9suG41uI9/NTMrzrBGRYqs9CSX8QqS
	 YHVefpo812EYRaSZV1x2NbZgumIN44gD2ItNTsSmmJa5JrHmCPJLdjSS1kkVCvCbJM
	 MrIkF/uQGgReXjaN3sfePFQ4ESoroUQ2Y58ypaPjPARPc+jYMLSzHsU3vR/cAPSiPd
	 ApZ4JPzTvFg3A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:43 +0100
Subject: [PATCH RFC 03/16] proc: make room for more entry flags
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-3-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
In-Reply-To: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
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
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 90C9020002
X-Stat-Signature: b6n9ohdqpxudu67w18qit4xge8wcb5ny
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793631003-966494
X-HE-Meta: U2FsdGVkX1+iXhHEIGvxu7Rtm7gzchAbVtKOSmwO1a12KnDahygIh7TqV8C369q2wYhvUBndBBL/rCvdEiQUcOpAkY4lvJOl1IF+7iTy1PHViLA6ZC3WOO889/nK9fkYNkryUWSjDsZWk7k+3ODLrLp0nr6WEXXcsoGfp2nDPT+FUH1rkzdhA+BS6a8zyVZ0OWfTXNsVBEfoZ0dsvGO9/UUtO7Vyv0mtCUx0FNYJKdn9X3QMwVoNDwDGHWeGd8l9pXbyUfnbDlYwwy3qHLM7KOurCUceLX6tQVzWTdgzvuby4dRTasUwKKifUlXKyOW+lwqpfzmbNV4qJIip628CKKgzAbP9cr1RCZvT28iNyjdJwqAVrRAIC+nqeEV8psbMEX4BD7AgZQbuF5ukNJD1RdgzEqt3/30tJjAgnKy4Jjpc4wu5Xf07mcUNlRNe12RNdojVeIjx+n6BXrIGbhIEWl4tBJkOkwtca+qjTrqAdgjbMsvKWnCa3wOnm79U7M+69oWACbo5XDQc4kHE5ExkLGQR8Lf3l5A+5u6xBqGBn/tRcqlPGX6RpXe+feyaww8nfxxMMTfcuPrDn1QowZuR0VLbybFeeSnp8IKbEmZGutYFYVy3p3DvR6nJVfNxuBqG7B8ZO/50cqJdZsLJsWN6AXgsYK5RYDGI7vdMIN/g9wwDaPDTwsimHnVW7HV/z2GJL7cn/dAVWVJeTbyV+SWLJ2icAaIBipFXjkbCEbXAej4SEuwwLb9W7Sh/6y0E5UC7ZJ9HWg1XlXkJZJ8TmniWUZVPx9B3FFbWWjSGd1S0XywhQGb3FGE8Sp6cmPr6mFnQgJGJvj+ZTBaywLF+L0Twczf8DwD/aSI5+7xe2WxokTBE8aY457mipz1lVDGqJbzsFOnFBKezLVPKyOGSbmoOJoJoE+gF5vyw89Eiqokvqdz9TplHXhU9hgP1Y+Zr0rUVrlHMeIt+LGz+sJdrD1J
 U/9OrhQ4
 dWg59bybXXSTL5MHqOtPkl6+ZsFQqp/epy9C+z3kaskuf/PgnHWZa/CaAkSeJn7v3d842fQu45s/YahEgdZphZhosXhaE+ESnDa2u+mkPOH7lfHD1O5U3C12u2J9ZY3a42u/nMH9liJwqMQc+4hh8lwxw63wH2AuCydLLuHL1A6TTfi1LVIeVFfJoF8EB1vfUL8QvVPXu1dLEVU/nZznFxowCzd50BdP1nQz92oEOm5DGgmeYCqtOKfLWtPLp+I3ndzbCkA3XtywuVuKeQKVr8U7pbGZSxCeebwKm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

->flags of struct proc_dir_entry is a u8 and the next patches need more
flags than it has room for, so make it a u16. Bit 6 stays free,
vfs-7.5.mount takes it for PROC_ENTRY_CANT_MOUNT.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 268a0523be12..41e00c978ddd 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -61,7 +61,7 @@ struct proc_dir_entry {
 	struct rb_node subdir_node;
 	char *name;
 	umode_t mode;
-	u8 flags;
+	u16 flags;
 	u8 namelen;
 	char inline_name[];
 } __randomize_layout;

-- 
2.53.0


