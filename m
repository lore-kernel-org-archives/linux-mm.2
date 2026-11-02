Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AB166084424
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PWJB1/iB
Received: by kanga.kvack.org (Postfix)
	id 259A26B05BB; Mon,  2 Nov 2026 10:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231D46B05CB; Mon,  2 Nov 2026 10:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DF66B05CC; Mon,  2 Nov 2026 10:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA1886B05BB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:04:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F6E114015C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:04:59 +0000 (UTC)
X-FDA: 85390501518.26.1197965
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9CC9C40019
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:04:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PWJB1/iB";
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631897;
	b=lzltermSCgpU6IOux3/bX3XsfqSKkqlDFgm0L9k0pxLg7W6k8QWGAhEbF6sGQUAvRzzVz9
	7sJxopGHVPKlCVwmLzP9IdUBauUFGtuTDh9WXbqCmfR6IaipEeiPD9bt3U+tl9SEteVz9j
	fJWyhqwQhMLe3FWJJL4CrxEGDHi2bZw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PWJB1/iB";
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7nrFZB8SEXLZU/mzbmWvrr/UMB/DFOM38jlkmOKcofA=;
	b=asB1vX+iwFBcdo0sQmanaasbB/ifSONzrwEu1sfS94cHAav65ZVhjoQDWFeQc0PbzYSvO4
	bwTiElHMHPyG1ixniASGgAZpEGgLjRdQ8o7St7vjuX6ZElRH3DX0Le08mozpx3nYmJV40b
	SJ/mmJlyi07i4L+yNTAZiOnwVjLl2a0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D1816061A;
	Mon,  2 Nov 2026 15:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C841D1F00A16;
	Mon,  2 Nov 2026 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631896;
	bh=7nrFZB8SEXLZU/mzbmWvrr/UMB/DFOM38jlkmOKcofA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PWJB1/iBfhOBGJhYFAN08DibMR52AbswEVevpOPJlFFd/6YKCBFk0rjdPQlcIsJCu
	 M7wETxh7POrPS2R+Bxe8GmEN+ztbrfn17IFousp5Q45SpUKBKeMwCZa4HLCkdaAMTL
	 nGuwpeu7tYiAoCalRJnwkfTozxEROSln5Zntfv5jW4jL6w1IaglXpEtlA1N+4XsaUQ
	 ixKM+Nu24AeZWPtukuV1DIGkbYg3XlqbEgIkFveiguvX3I5APXV8ea+vTsUzrvxLhH
	 oQKy6vg2GUEAk0BT3S3W863rpi7gQfQhWY1o71BBu5E6HzUMTMlRLe2ZVsoDsvf6bw
	 X9nFDARzygnDg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:37 +0100
Subject: [PATCH RFC 10/22] sparc: led: let procfs copy in writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-10-c9492ab08480@kernel.org>
References: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
In-Reply-To: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
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
X-Stat-Signature: xp9x93qr6b4aunagobtycuxyfmo9dg5y
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9CC9C40019
X-Rspam-User: 
X-HE-Tag: 1793631897-402326
X-HE-Meta: U2FsdGVkX1/QA1Y6e9reagJczUXQK4tpEB4AantmGnQ4gPzxIXucwAc6wBWOTIV6raLsajLI3QIIGM+Po+wvjSxZC7a55uKQBPhA1i8hJ3V7xjhVsnKMzuKfYKpJA40Phaz1eJwNFUhX3ik0W76Lv2J7eqQUhUuxCOXYc78Qs/euoSlOzfkXoKsEUncHOz49Zj3wOb6T+Ac7DWl3fJ9AoXhe7pKGmD6ji/tum13HWfArPeFY8JPYAggWcP+ISO9GOFaQB8bTo1ENV2oUHKa4RVEr0+DkV2XzQnsHhF+jCPwOHIU1KgI+5AdZLQw9eG915425rZNmqcuDdVOVLeznEkj5UFqyxv4u3AQJp0PuHgqbapnxuO19QV3grEBSsgKvP+wiViwhEBx4qdiDlwjYkS4G4QcigU8YUUDOh/rNM8hBxpSgY3bMdEQjyS9J7lciRAjkPuqCpppn9snlZ4j2SLstks/8y+fgOpmx7b8gGT4pCfjdMxx/rQb884dEUCVF97LCnUFcs/MnzZ4aw+rgd307e0Q10YRXr90Nr3/Qh4E1v7DNo6t/TAirwTztjvhnAFYmnsaHpk3XjJH4OM/nbf1yjfa7AxyzheHC8MHwlpxQLF68eCOr7MrrPDhaaG2vg36nTc8I9DsVqduH89drG4FiLfJbdudPnD1IO5QowjfzSAzuH69TCxeGeqVtHFDe8cZl0NpRHP5wQmfU9JNJxFogjmf5NTvDU8oVlWG36Y6PnsNkCq5+beSp6MiylNnSgoGao03PWJILL5SjJotxAWfzAMeYzkyY5OI1ohVdc0XliecxRRAeOSflxqZZTt5uJ6N5NC5Vk8WdIz1r7eTYRsmpPpQVxY3i50JFzlM3Z88aH3zAjrQDSJtVC+GEwvzfm9n2ZgorpVVr6w9Cg3E8TQlu1Fzvp6s75slvZCSdCL0TQzXeBWTvPI6/Dot3r/S1MmLXDzWXU8HoqQF+AGC
 0o/aJTM0
 4Q6K8ESNFXTFmBqdPBXsoVFVahcOOdvt+OB/qgAiM9aHQyXj2/23bEgOgzjQvfwwFr6Sx98G+ZPj/zQyeCHNSnxUngrifoDuo0qg4pHRAGt5B7ASNFuGJIx9ooXkBXh1k2a9B5IPfOIHaxPnNlHAgfQvokPCggM3+PA38vt1pkLMErOn5BMKb2KDjIMchat4mW1CKS7AmVydxSgAIh59TSnpePhj9q+b3l6wqdli0+g9ULzHIPEIjrsGufx8rwNlgwM/2JRZOCT+UbgwJWv4+Q/HjxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/led before it pins the entry, and parse the command from that
copy. Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/sparc/kernel/led.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/kernel/led.c b/arch/sparc/kernel/led.c
index 12400bb59ab8..01449b056cdd 100644
--- a/arch/sparc/kernel/led.c
+++ b/arch/sparc/kernel/led.c
@@ -60,17 +60,12 @@ static int led_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t led_proc_write(struct file *file, const char __user *buffer,
+static ssize_t led_proc_write(struct file *file, char *buf,
 			      size_t count, loff_t *ppos)
 {
-	char *buf = NULL;
-
 	if (count > LED_MAX_LENGTH)
 		count = LED_MAX_LENGTH;
-
-	buf = memdup_user_nul(buffer, count);
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
+	buf[count] = '\0';
 
 	/* work around \n when echo'ing into proc */
 	if (count > 0 && buf[count - 1] == '\n')
@@ -95,14 +90,12 @@ static ssize_t led_proc_write(struct file *file, const char __user *buffer,
 		auxio_set_led(AUXIO_LED_OFF);
 	}
 
-	kfree(buf);
-
 	return count;
 }
 
 static const struct proc_ops led_proc_ops = {
 	.proc_show	= led_proc_show,
-	.proc_write	= led_proc_write,
+	.proc_write_buf	= led_proc_write,
 };
 #endif
 

-- 
2.53.0


