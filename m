Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5371606C571
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PPfyE6QJ
Received: by kanga.kvack.org (Postfix)
	id 011C86B05C3; Mon,  2 Nov 2026 09:24:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2B316B05C4; Mon,  2 Nov 2026 09:24:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68426B05C5; Mon,  2 Nov 2026 09:24:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8AEB6B05C3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:24:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 635101C0B81
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:24:24 +0000 (UTC)
X-FDA: 85390399248.26.2107C1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 834E0A0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:24:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPfyE6QJ;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629462;
	b=5Lh+JyRqFGgkqcSY92NIHWuvwHYl81Dul5cpR9t2Wagj/KJTWT8O+kGy6otzJK8K1ZSsNk
	pH9Lxq5K/BiSkzfvFFljeqWCfq0nAQvmxB375Q8XohGqS1cCZmsQZW8rwa+0Hk+4i+RirU
	mWFeafQqO/HXITQpdtznlwsDBdRYzH0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPfyE6QJ;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrGvZ3iuNEQwh46pZ+Sey+hIl+TylMI6LnuDESRA+nc=;
	b=HjBbWr1eiddBG875ZgpzpP8CsvuscdeZVdKCUrH9L/y5LyigECA8hgz7kDfQX39Eg50bQD
	I1xl1expM4ExSI0txZRGxWBR53Cwusw254isDuEU85PHKQNEP90bsRFHHjNk6nsVUwgG7v
	WrOU5GqM4WdZIVN5XJKTYCVc75UTNs8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF8D2437B0;
	Mon,  2 Nov 2026 14:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527D01F00A17;
	Mon,  2 Nov 2026 14:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629461;
	bh=LrGvZ3iuNEQwh46pZ+Sey+hIl+TylMI6LnuDESRA+nc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PPfyE6QJfnkYegdNJOVyvRw2w0u6zk/zq1ATvwc/6eUWjFe4vJ1pRwfd7t9Ibhm29
	 IG8+/3Y2h9D6Ml0EqluGiF7ZzqNXzL3BnjR04OHSHQICnr6q/zg5AgXD6brOztOzhp
	 Tm5r+Xn3qFTr/0ct+giZygbQPAoKv9HR1rxcIMLZsGHigSCh3rld2MQkXvCo/Ahi3k
	 OPLhbcK1nwFtdEjV44unUVPhIPYHIiNsNsBvSGn2WZYWfU7Yx81G3k7ZcW6H6YJJZZ
	 iSvJgVc7lHHoAy7pZXSTctPPyJxiyAjwkTJ8kb6zg1ymJ6Dkna5fZS/L05pAfwaVCn
	 /p3edvhBr30yw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:26 +0100
Subject: [PATCH RFC 11/38] scsi: ips: don't return 0 from writes to the
 proc file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-11-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=745; i=brauner@kernel.org;
 h=from:subject:message-id; bh=AdCDbLhnpBt+TcsQ0P6GBBq6Ub9shryNzqH+cUsZhBE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJPdt/hGgM8qEaYIn9fiBlE/kqwu7y3d1vz/wn2JQ
 1nljmYxHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNpYWNkuMNVfzzE8+fiU716
 eVvUz3BoagZsjeKTeFXs/sHF2WvyS4a/YldW32kR8Rf1s2fVtZ1uwyx92y2ElcvRtJJH6bK80SQ
 2AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 834E0A0007
X-Stat-Signature: eoxcghbae7mkeajddbwo1hg3fj1t9ecz
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629462-562395
X-HE-Meta: U2FsdGVkX189ZGAQ0JInyFHGken/WvlTbztoQv6p8TW0LHXtI6SaEPYEnL+wlubKuJWlQ+EEVRCF5jOpfZTerlk7RVXlJF5OPSeQL6wEAk+O1uZVDo45Scm8e7jRLR/5XTHoohjZ398setKkrGKFLB8mSXPL5b6t6ahmV8DsgQLz/yjKChs/VOHlgUq2Gd7B5YoIuD7m5sNizFzkCczsUmpkkHWG0+DYWvlXkTTX7e7SN+t7+VyvYPY03kMBQmon1oEX0/kpC91VRMhazJu9s6KD5lGbrytA283edNZARRWfk/d2XIRMQbhWBl6pt9jkZS54o0PsJzfZy7tvyK8rD2oxAyEt4ynntvkFRpEALwG+GRmRp8JsaLzlrdjL80FTABJd4xf1DiNI3L/BGbyNkKoLkU3LMq+npaXNj46dzh0igV7Z36OMAu6C+SgqqOTQ+oaK2kAamoyeStigOIXEdTz+e9Bqu0NVduWgbo1gyrqdeZbQPXhzLWqnzjxHcTCniqAmkoDURATtT0S/cHT1y2GOp4jWlNIZl0koMavUBPzFJy/rHdhrMMGSawpS9n5BKhZcdqcR6ZOu64R8l3iWr0qT6gdJhDs1BBBnte4FIG5HaDwGGVfpw4EIOfvCwbTiCVhlJkkl76NcXa6/HN7+ofcTJP5fDKBHFk3n3mBD3sOZ2qwHzdGXEK795zNcGDWZhWX35xcNxzQJZAZ6zxH5R6TDkUoEiASAoS1+NCe8WJ1skxlVtpufAMDgMh6gK7vpEPQzBjuMvKEekVHSqlzH8oQa2SS+0e5B8zgq8wDTJ/fGt3P2Ze+13tjw5QMVZFDxtmVpJsoxfRPeVDJz7b5tbdcQJw7VmF9cg4OW6/g9P129yMr0wrESVM21CvggoqBihAo00CqyWMldYH8/1QH4fO7Gld9ckv9gVz4MBfXJ9wLeHhv6mJBBO80LWT5HqJcYnkezPTbcJZAlRJJs5Bj
 4nKkz0Qz
 HBbhSEu1Uy38Mnc0An+PTBd7VaaSfo2XBY1SoZPRskpr1qZ4O3W5iCt9O0PsPoR7HHJPL2XSm2W69cxajDFukCJOM8d+v3tCDLEXVrRG2+uZxRueARjOvSxLXO9EYE9C58sMLZprkCzTmdQco/AkEqxN2yRJwtBXu5WU4PUYt/gcgHg5Iv8Lvq98b6VHA1JT4GHQudbHT2GriUILeh8xE6OUgWOmFfZ/PRMomb3vAfw48D3Dc5+ZazzfbO0+L38l3led5PiRJCjJG12ykkh4qoan70BLvWuGXYRCv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ips_write_info() ignores what is written to /proc/scsi/ips/<n> and
returns 0. Writers that use stdio, echo for example, take that as no
progress and retry forever. Return the number of bytes that were
written.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/ips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 45c5b9acb664..bf3a961834fb 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1428,7 +1428,7 @@ ips_write_info(struct Scsi_Host *host, char *buffer, int length)
 	if (!ha)
 		return (-EINVAL);
 
-	return 0;
+	return length;
 }
 
 static int

-- 
2.53.0


