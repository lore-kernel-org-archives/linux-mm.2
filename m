Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD16C607BDE0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DrI+PNek
Received: by kanga.kvack.org (Postfix)
	id B61BA6B05D8; Mon,  2 Nov 2026 09:27:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B396A6B05D9; Mon,  2 Nov 2026 09:27:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76546B05DA; Mon,  2 Nov 2026 09:27:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 841F66B05D8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:27:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AA80A013C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:27:23 +0000 (UTC)
X-FDA: 85390406766.23.BB7A223
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 38CE94000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:27:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DrI+PNek;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlRe6ByN3zpYNOlJQq83OVbC6fU3d9RayIfuGISBpLE=;
	b=W4rPTIDHM+cRDPUkrMBs3u76XbMF144JvIO4DyWWNqYdgGUtjyNp7DEZPQ4J92uLjWLnJz
	FZ6QTdyLUYgWw5S/Gp4QLW+ijlu7Q1kcNTu/V37x/Od0s77tlr4enqj3URSpmdByIrUNcc
	40q5jW8gnu3g51WSsWUrLfPLhgyJMag=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DrI+PNek;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629641;
	b=QoCOt0GywqilpYQSZZc5oAtS6vNNLx6rCpO/cfjVVW4N/h0CkVBIRjH2C9oMgjP6mfJD32
	UVeiA0xIbgCDJ5qkWyA+0WVOIUExNkUKTezwe+JIyDZ0QERfOjwrKJa31oOgu8VT8qzwm9
	GQed9F1u4wXG5wWNvKYQ3fnmyaXAkzc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8497B41787;
	Mon,  2 Nov 2026 14:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FE31F00A1C;
	Mon,  2 Nov 2026 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629640;
	bh=xlRe6ByN3zpYNOlJQq83OVbC6fU3d9RayIfuGISBpLE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DrI+PNekNretHUZ1kn1KtVLM1VAQ4asWCX4darvbDfIiADMbVebIHhgZrW1oD/LQm
	 ET27Dsfxtbv5Bx6RMcyog3VOgeXPBOtvOh2VXPyT8GPO6Ybp+ewD3KRsx4thesz8VP
	 QA7RHgKiSLQ1nhgNIeJZ4ihrXQPO5LDA6Zn+C6+rSuuh9NM+5LbiX/ev4owvWjFJK+
	 w88KxP2goEYkeNG1aUmgx8CoQpiUa0JgLD5JUUs48hMCG8PnbgpkAsa8uZGjQLF3EQ
	 k2GluFIjmgjBfX+GXD3ZOzpKoAHK50KNKTlCQq/MS76QVFek5Vdqcyn24CZ5KtXYnN
	 gpYlqS5cSCEuw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:39 +0100
Subject: [PATCH RFC 24/38] proc/vmcore: don't let vmcore_cleanup() run
 twice at once
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-24-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1758; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gmON/Vwu30bm66aR7FLjt15bWl4pslPspuVjwp92LoI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJN9ymzS0mChk/OuHxLcK7hCIChOYcKK3y/vZOxX9
 hTemFvv2lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRv4kM/3SchYRYG9b+Xrc8
 wduJ9XImq3xMwSbxeTeYAicKTFfkvcLIcC/DZqdZ5/W1Oa+zPiduuy4Y56u/3qrMJ2nqgj3fHed
 9YgUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 38CE94000B
X-Stat-Signature: ggbi4mhurgp9s69krzz5fe36wzibwwwy
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629641-853514
X-HE-Meta: U2FsdGVkX18CJc2ClZ0bskh7J1aAHp2DqT5b9SB0yBHzJt87I9xsjfFIl3dxIvZmHMgP338rRpCcVaUNI1IzcQJa958LmhJ7kAu7+9W3ux4zZ5BCWDCewgIdjGPdAv3WVkB6HOE0IOJabS5jyG3DvFN6eZoeOKdEF0foPpd3MfgN4W4qJd6JleyI/qyMqt2eJvSbxkZnHEK5MLuwT+hmkJzUHtw1m4AMGspTXoCeK3UAHSH7DVRPrH4tzCJnbIyiCFi8XSPqAH5XmsFdxEaikI8fvRVDYFrflSibiUp3DD81CQAmbzSrJul4PG2Dr05uouJi8HTE3Rl5UqrQNSegMliZMFjrOJv98eVzZzUC+1Y2zL1KcXdiwWUzyh0tegV4ON+PzqUbiif9uDoguwpd6/4YMXw1DctsC5ejmn/9vzKpkusX8v9h9tDn1r/nE2Y4YQFQezwsYHhvykCXLknCxA6s6sjtzdxlTTtL9LD6tBye2N5DnqF2qTGBJJt6L8milbsx5XW6kdDhgS9VRdoACMJ1WjyIW7kjCDhoMtjfRh2r9MB5IZ0dEwKYtfuFhG2IieDZCmsXCMvHHUXsCH4olxKrencz0m5qQwFM8wEEcWepRxNyKlDGCUpPLibReWVmwrKFHWNGHnZx668px08R7YwxvZYCasEIWSAJWDeVh3ynTTX2YeNrI1SnHnzDi2idSTnA5vMZAEyxgOu7+0Ja3g/5pnt6zJONId/psiFMqgcB6P5ElWDgQTAsW17vRQfcmlcDFb97+kGzE7BVJ18bOoS3+476/y+PGESJB1o+VGJjUQhpwyffaKGZLkbnDuA5WWZtIEje3yllkNDsDNj4K1Z2vCvd/Qj3kwcfO3XJXKd4iokUXc2kmpTSRTOpyHkKoLlI/dZqsXS+yZhandEqmMiUMSPWZpgqDWNeaokfXeAC5YxCGUBY1wP1aiMy0kb6w/zk4ex0UsDWlDws5Pc
 OArPIGOc
 LXEKMO2ylZjqSzAC1xc4qvAnVTW9FbNNf3yKKhVggQvhkGOmjHwhehD1e3+jkZP5+0r8LWj3wrwHa5MbsJXo6J9zmtJjnX3VDIGm5ZhOPHyrbu6BkNpjmjVoyXPiRWZ4qmO0B77jAwkwej65zrE/uTAdwA1XnrNMZHGxI1MBZ33YOLaTXZA60J7s2vKLBwOHBw6kXNC2bpBni9PqMoBNoe1HnIHfN1JwKevJ7Dzv0bVct0q1uOu3/MmHOeDPL3Am9K4UujgnYEO2uAoiMXUDBESmXws0qYvNq7DfG/XLwnLscbl2RZ6ECSsISEfWDAQmuJR50TNSfV6BqnQ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmcore_cleanup() has a single caller, fadump's release_mem_store() on
powerpc. That checks fw_dump.dump_active without a lock and calls
vmcore_cleanup() without one, and kernfs only serializes the writers of
one open file. So two tasks that write to
/sys/kernel/fadump/release_mem through different files run
vmcore_cleanup() at the same time.

The first one removes /proc/vmcore and waits for its readers in
proc_remove(). The second one finds the entry already unlinked, returns
from proc_remove() right away and frees vmcore_list, the ELF headers
and the device dumps while those readers still walk them. Or both of
them free the same lists at once.

Serialize vmcore_cleanup() with a mutex of its own. It can't be
vmcore_mutex, removing /proc/vmcore calls release_vmcore() which takes
it. The second caller then finds nothing left to free.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: b500afff11f6 ("fadump: Invalidate registration and release reserved memory for general use.")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/vmcore.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 1fe70c4ecc54..ccb795b85509 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -1764,6 +1764,11 @@ fs_initcall(vmcore_init);
 /* Cleanup function for vmcore module. */
 void vmcore_cleanup(void)
 {
+	/* Not vmcore_mutex, removing /proc/vmcore calls release_vmcore(). */
+	static DEFINE_MUTEX(vmcore_cleanup_mutex);
+
+	/* Two writers of fadump's release_mem can get here at once. */
+	guard(mutex)(&vmcore_cleanup_mutex);
 	if (proc_vmcore) {
 		proc_remove(proc_vmcore);
 		proc_vmcore = NULL;

-- 
2.53.0


