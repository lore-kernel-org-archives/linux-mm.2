Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 829D0606A916
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ScTRyul4
Received: by kanga.kvack.org (Postfix)
	id A53D96B05C9; Mon,  2 Nov 2026 10:31:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33156B0614; Mon,  2 Nov 2026 10:31:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968436B062E; Mon,  2 Nov 2026 10:31:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 730266B05C9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:31:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14C048017E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:31:06 +0000 (UTC)
X-FDA: 85390567332.15.0FE1DD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5A183100012
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:31:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ScTRyul4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JYviDqoWsEGN3uNb5Mh66eaw6snQ2TUUnHcmJoMJ80=;
	b=t7cDxt9sgY+3Ho4pAb6+sSwl2HfIjm6Q6RLRjBIWG/QsqxAFEyvgrK871EXDT2lR++/FIJ
	+ywAkNo1pCrYboZgppawsqqc7uG8xEp84lIYmhFMfA+dg9MNgYe3srflZgtGu8jKhU2WKW
	t/gArlUqMAxhAXfcli55lyProXfGl18=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ScTRyul4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633464;
	b=LfpDVtPPCXTCvcVNcGwLgUClXYX6zVPb0CUucImMsZ0w/s+elr1PM7hyY7eKoXbyiON2Xv
	Y7eQD19Z47nE+y3x+nmmpgYTyFQNa2dM4pk4r4NlMfveSTGTVNhPw+BL6uxcqlJJ19xP5d
	nlmsXXab9+VQeONpztqHMVHG94p7/tw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA5E660DB6;
	Mon,  2 Nov 2026 15:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FC01F00A16;
	Mon,  2 Nov 2026 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633463;
	bh=8JYviDqoWsEGN3uNb5Mh66eaw6snQ2TUUnHcmJoMJ80=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ScTRyul4UqS1mWJvOzmwvwPQ//Itx9TsdsxsJwGYb3Gmm/J0WkPfUMLBfXwRwQRsr
	 Nim+Y+d24g3hKICsmz4+hJ76wRo71Zgu8JYSNQex1bY6jYxc4yR4NIKTkU/b0bzekF
	 oTZ8Mqaf/qJiOTrQ3fVHdV5XUUZFZ9Rv79SVAaVRi4pTwuCDqET0rxCczTm7RhsOI9
	 GL2XYnYI3rKEga2Ls6G2iIhPzet32Cl17pJvVFcx5D8ihh7MkSTm+FLpZqjgFDVWCL
	 7PucMdluq4M256zUScAZVO6B7k8GrovbDY4lddqqcnnXFtmxqpelNIoflJ7mv/9GqF
	 EQVHm3m/21Cfg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:15 +0100
Subject: [PATCH RFC 01/11] atm: let procfs copy out reads of the device
 files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-net-v1-1-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
In-Reply-To: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1517; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gPjf1XFsI8l/uiq7gtBYaOS5PIZm1WCyT/xvmcgXYrk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG78cE1u8seuk/K3unk+6P7jWeW5b87CvLufg14ar
 jS+H74/oKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAis2UYGeay2p/6sZbx0Dzp
 lNKfYqc/nLPyU7XaNW1f+AvTfu35FjsYGdonXm11v5fkNuWfeN7rc08f7rarf8sV6GTp9Xk23+y
 Xx3kB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 5A183100012
X-Stat-Signature: h86jfizg5bwt5su1mn6y1fkbkrnxmos9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793633464-617264
X-HE-Meta: U2FsdGVkX18ohVueSLzC1mq4F2XqgDnz+A7i1x2jSu2Sr9EUJ/OCGhG+y6fqPLFCdyljiW190ohjbSq6vwimh7/kZBUZ8lZjSuPkZgcnTftKhmamm0ZTOcpFpo+9QukhyWywwqmTpaw3qSvK6Iwib8ZelXwooRinrllJ2W9r7duSXDoE5lEz/COuFt/bd8h3DeJvSpKGKIWqccN8eLcPdb1rAzEY3J72MEryeKgSDZKd1FeM1+Nsxcz0m55hSxWN109Ig3gYzjMDkyiyF4zlaXm2al65YfDDitE3Et7CJcXSt/NI3dh1lD+FyND9/CX0gv5VLQ2nXe/yD/GQJN6fWQ5d5Z9D8ESnN3XSt/UGYMSgYF0vKftHWevxZQ1IA4wbsGg6IqVIEf+cyZtvGQjBTSTJatYrDZeliBRFZ5pEZ5ewuvmV5l2dbm61MsW6LobmcG0hnqZkS0sncRUuRHXmBYEyOXRYLBzdXHKD810mF5al+akdWS7WkSkXc1iiWknngiT51UB+wJtpD+ANlk+nHfsdQM3lzdkNXWqZzAhkIx8TYVZL0OJMzQ7nECAqKir62lCYmx5peug47lULtiYQ1ih/+V7fah4wg1wO0TpIgi2JvXlHbhaoHxMzLqzidHw0J4dZGN5TSgIQr93G/VJwmLG5cWWrEr4mXmwzHUkFIjV5BQJ1JlOPuMPAYAycy0hCIUOt/E8gh4JIlPZ+TWLo8q6ZgZFRhigPkoytRJfUWtR12ZMGdPwaKjSg8R+ttvP1AQ68AwGMVmLuuFmj0birtyB1NLAUppdX0TuubXAg9+qNr3bnSkM/EVP8UVgko2+82GTWxWIS7VvPQo0aJNWEmYJnfnmaqR6nie+/V4pt2WlUWx5Ol9WhK3WL4utJZFCVOmQTHuScpEquUzFy0WE8hPIXwjnDFY/75XZ6BI+Nnat9Bon2ic353SZv7OcsE7VqzAAlmbRXEVmfWr9K5gN
 aFZexn9C
 gVlo7KGaur+G2SoFC9hz4jMlLwsKOtq5Qp3+cEscgPhbc0AArUQjinNRJWFrWV2utcJ/Qdf65FiZb50lG1+Y0wQePxZfo3xxZgDcm08Fv6ouGi19XHGhfoajX+I4qbafSQ1mVYhdMEaaaZaPyV5SE+xJTo7UK4MvBi1T7MZFNmOy3eKpHPltyMQjFlW11SOeNhCQN/VX/hlczh22jPsSMl17ZN3FhEE+NssMICE2Xbk3FOmPi8AitMlcOJG9YPEUWHLuz5Q4h15KHo98rad+9hT8SNK7d4BYUqQfW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read from
/proc/net/atm/<dev> to userspace after it unpinned the entry. The
drivers' ->proc_read() keep filling their page.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/atm/proc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/atm/proc.c b/net/atm/proc.c
index ca0fc6b90998..cea930b4b840 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -30,11 +30,11 @@
 #include "resources.h"
 #include "common.h" /* atm_proc_init prototype */
 
-static ssize_t proc_dev_atm_read(struct file *file, char __user *buf,
+static ssize_t proc_dev_atm_read(struct file *file, char *buf,
 				 size_t count, loff_t *pos);
 
 static const struct proc_ops atm_dev_proc_ops = {
-	.proc_read	= proc_dev_atm_read,
+	.proc_read_buf	= proc_dev_atm_read,
 	.proc_lseek	= noop_llseek,
 };
 
@@ -246,7 +246,7 @@ static const struct seq_operations vcc_seq_ops = {
 	.show	= vcc_seq_show,
 };
 
-static ssize_t proc_dev_atm_read(struct file *file, char __user *buf,
+static ssize_t proc_dev_atm_read(struct file *file, char *buf,
 				 size_t count, loff_t *pos)
 {
 	struct atm_dev *dev;
@@ -267,8 +267,7 @@ static ssize_t proc_dev_atm_read(struct file *file, char __user *buf,
 			length = -EINVAL;
 	}
 	if (length >= 0) {
-		if (copy_to_user(buf, (char *)page, length))
-			length = -EFAULT;
+		memcpy(buf, (char *)page, length);
 		(*pos)++;
 	}
 	free_page(page);

-- 
2.53.0


