Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85718606B024
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g5u712B9
Received: by kanga.kvack.org (Postfix)
	id 8C83F6B05C3; Wed,  4 Nov 2026 12:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8774D6B05C4; Wed,  4 Nov 2026 12:30:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7658C6B05C5; Wed,  4 Nov 2026 12:30:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7706B05C3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:30:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D64881A07E4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:30:18 +0000 (UTC)
X-FDA: 85398125316.07.E96DC7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18046180012
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:30:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5u712B9;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793813417;
	b=uiW6iQeEmTj3LsiR40G80uzsxPQZT83tU8jPg+f8RQue+muLW0nJHUQmmqzsoeCR3CmRiK
	0Pf80aEO5h3MaF0u2OASAaePA9pkYk6mVMX6NSmF1bMqZAa1SQJGjoMUd/Dkjc0Cj7iLVo
	dxA5w6pBZpgc2ewjHUEkY5o5CkQWZCI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5u712B9;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793813417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bp2DPgSMAVNPpocNHMMHSMxcgQhQwNKqaFQNAmEUdgU=;
	b=3LYyQ9N3fX8Dpo9zZIDlzkZWXy1UzBE1A9zl/X+B0QpfAYZZ7M/DO2l6McEYz8sPW3Xc41
	r+/SmlVJkAPfMDuwHd7aZk3tDy4FdT14Fny1QFBoCsOfQ5/OnLFMPjA0+J4MLIsV9U/DDw
	1+HlJ+ij+6AYSCDZAzGZRO84EPB6Cbg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DB7E601F0;
	Wed,  4 Nov 2026 17:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FBE1F000C1;
	Wed,  4 Nov 2026 17:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793813416;
	bh=Bp2DPgSMAVNPpocNHMMHSMxcgQhQwNKqaFQNAmEUdgU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g5u712B9uyY/EHBMvMcIJjwX1Q9oNafVwZZdSTe+wWNmne5PBjIRnbjMdNBKEaIP4
	 4sN1akBTM0upEXPMnrPesATu9t0mv+J9tGR4BfcCUQnJpzUcbcj+IvUqAQlpKvEFAP
	 maIQiS285xRthBs8kUjqLULi7ZlP9EZaMs6jvYgyfDdyykDtrKuOIUKXiUE5xq8j0K
	 rnPkE+GVlVCE8ozm0404SgO7RYqyMkzZKzwWo1p+WxGQXY8MTkERhkp4+WNxvZiOYe
	 CguRECqkxpVtUS2A9kODUDoxnBc90vENA1/MJjeZ4tQ9xNPhj1ug3QG1Rnyknyga3s
	 5rdxM+QnpKA9g==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 04 Nov 2026 18:27:24 +0100
Subject: [PATCH v2 07/51] lockd: don't hand out the terminator of
 nlm_end_grace
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-work-procfs-bugfixes-v2-7-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=879; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tKzHzMLxBoW/zY681xcBM67Jqe2y1s4JEAk9OycZ8F8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zma88mPSwzMZES8ZvfsaK7K5NIr2+azZ3b+Xc1Xpm
 7Wz/9nbdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkbT3DP623G/ymh8nr95bL
 Sj1ZqVz5I/v5xTDO2LLF07okt9w1Ws/wP0bKWD8yk0Xj8wP2OJmbXq1N7z9lRV6ZFj3BvzE/x+E
 BNwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 18046180012
X-Stat-Signature: pth7zugq5w8bnrq9d1tuofk99dk3tofo
X-Rspam-User: 
X-HE-Tag: 1793813416-960883
X-HE-Meta: U2FsdGVkX19KZ/51X7FvD2oR065LphpBgjp66E12w//2XJSa6YX6RSovAzhoWhJJhWLxeXTnN76cAtM31OrE/mSAhyuQZpgZJD6NxGtJrOYyosaxel3EoPRTbkUP+DOp9p0HENpgkRyfyLflkdUBg2b41itCcqJtnalSc8dYWzJHwkOiHnHVxPAuujKekrByHffQ8sjyhlpXkxmsvpCrbLet7YyAV+sGggc7sMAsbemWAEfVUhcanfDLUPzqvuTkEkdNqzh4rFnhDmnIUYkIcZHHLDFIUeh3kXfHGYR6OM10xapdoVQroPPpfQMKAL4cadD30Rjs+mCPux7oEDR4KGCkLEwyLSmBBOEEsT2RhWCZbFeGu4YiT1cURti1W7BMgiFRdOqjvcGk9Z03JWBnGLl9GhbvGwNMjANf8/IymaT8ZoUOjcEf/UOaJDrn1NA6AONzOK0k+e6dJ/QraCi6R6URCGwq8Q/jiibWlEZpsEfUY/H72sT4jysT7mIGn3hc4YMVaKnKuivcbECeLSNsEfluS41yAo0HDUs6pycmofd3Ta6U2xsBXxd2FveOt4Yi5Pq3WxB17+0xooaESSyfPJ+/FvfpKG9TYNJPy37SwdyGqdDB7mIOGmu8VHksALZt8dhcVIm24xXtJJMnYs/Ndt7a/q38/3kwgeUoW/DXQ9rQv7GMnyuRSD7PDNtClPQ3e8JaDCmFDibQJVzwDwjhDxH4abbTQvqGTFebxTao68U9i5M3fGQo8A/EKDmQDximyTNVzmCvPp92v1zRDoQBk4Jgaekik04HeJ1FsrdYD3ADY2j8Rogugs8z61Wg9AQjKS1iYL/oHRpDlltDDzMkiRBsHnNnIEF7PetD6zGV+vOBJFZ4nICm7LRt8Qr2o8I/p25Th98gWG1aHJlJV40/hcW9pzNNg3T3VG7acfjvyq4hHszA2N7JOkM/RTIbYQT7borQh7zwUxZw8ruapTH
 juoXfrDY
 45V2N5jwqfJ010YGTdV/EGGtjmJDjAkQmDG/V6xw/9RJ/SheWf+lo2wv0cZfgxwwBAUz6Dzwz1o4UyV2qg2eY6rTReZGo7zHvm8Lx6MvxniJm1VUGM4Hjsd9nMQhZ9SZxWgI4D2XTDDy4xBv4mtUAO/Now4bWIeHMmDzKjml4X3wwljEcyzjfR22j62rDVsJhvbPwQ7Ts4RuCIvQop3mnWuFF9Ke4gvXCrsw5+mSDWOaoPZwwGkDl9tXY+kQh8DMgzOPLp/QT61Ypg9SZ5OyBbTF5kauhuvTGaTflHmUVSuD7a8710/YLrOoBjG8BFJtvleH3AJTbdze6RYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

nlm_end_grace_read() answers with "Y\n" or "N\n" from a three byte
buffer and hands out all three bytes, the terminating NUL included.
Leave the NUL out.

Fixes: d68e3c4aa416 ("lockd: add a /proc/fs/lockd/nlm_end_grace file")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/lockd/procfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/lockd/procfs.c b/fs/lockd/procfs.c
index a01f08c8c2f3..74f7ab77535a 100644
--- a/fs/lockd/procfs.c
+++ b/fs/lockd/procfs.c
@@ -57,7 +57,7 @@ nlm_end_grace_read(struct file *file, char __user *buf, size_t size,
 	resp[1] = '\n';
 	resp[2] = '\0';
 
-	return simple_read_from_buffer(buf, size, pos, resp, sizeof(resp));
+	return simple_read_from_buffer(buf, size, pos, resp, sizeof(resp) - 1);
 }
 
 static const struct proc_ops lockd_end_grace_proc_ops = {

-- 
2.53.0


