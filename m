Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE4D606B1E9
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DsO3tGmk
Received: by kanga.kvack.org (Postfix)
	id C70446B05CE; Mon,  2 Nov 2026 09:25:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47516B05CF; Mon,  2 Nov 2026 09:25:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D6E6B05D0; Mon,  2 Nov 2026 09:25:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1626B05CE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:25:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3CDE21A0135
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:25:49 +0000 (UTC)
X-FDA: 85390402818.19.7635673
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5C1B818000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:25:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DsO3tGmk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKQgab6F/A3kQED3xQkQ3++bbO+NbqHo8+XrgOES7ts=;
	b=7rjyBbePqtOBLqiQ0T1bmfYhjB95x0jjO7TBP770ghiX9wq/t7jH+n6+xHLSKHXStNa7B8
	hrixi73uA0L1dq5PrAzeKJMzKg6oV5P9CjRXTWWzTxuLgFPgnBetH5oFab8VFBmMurvuuE
	UDFMCWUk46Lclc5wdg3+2d6pk++S4Ks=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DsO3tGmk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629547;
	b=RMpLzu10nJnvc2D5fbsIMvLt00MbCYH6B4/9kEA0+OYCAcAJoCcqstQaU7sp7xpHvdXp2g
	HvEOdeK1mh82S3jqzmlzzTRDyhwp35IIY57Ix6aCwOFG5PC+U7XO9nRjM1PUo4unc2e3td
	5fhYZ8MaIh129bwSt21dfKKB22h9jNI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE2B241609;
	Mon,  2 Nov 2026 14:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D251F00A16;
	Mon,  2 Nov 2026 14:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629546;
	bh=QKQgab6F/A3kQED3xQkQ3++bbO+NbqHo8+XrgOES7ts=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DsO3tGmkPm0NrZBAy36Ik2sKieKOlgJ0mgJL9J8HUXGWM9u2I/c3pHtKiQ0Do2PYm
	 7gQh5TWLbJfjqkyLpRYxtlHQknQ5ICn+rBMWeVJe+1wUDcrFokW3QV5BRKEjIIM1g7
	 4uK1dsR4VmTwi1xfPzeMKa6KM54nvBM/9lBOIH2sBK5vfPjnFtHLtg/MR6utvOuTbr
	 BhV4LYIsAevL+sCKBVvYYsxh9K52tALkm+ZraCF9ZgTpQRr9LK+Kf5i1yQ7qyCHV1I
	 CDizin0EMhnII/l7E8fS5Bk+dgnSr97jORnukihffTpxsXFFOekF7M+lAIoxR9VIie
	 WHOn5K7hwiJoA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:32 +0100
Subject: [PATCH RFC 17/38] net: pktgen: reject device names with a '/'
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-17-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1684; i=brauner@kernel.org;
 h=from:subject:message-id; bh=F9CLtO30/n/hY0YqeSuPpMfy319PBmjhBXOfLkB61UI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJOdP/nSfLcrXttv7FH7+buGK2LZ4TruhxXmP3hSF
 uVMm/phfUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEjPkYGR7c7BeINg2bJuR9
 a7LIdeFTC7/c3ff8saxRtWV+/N3pzG2MDF/XB9+RXGXonZWutHZr+BHB7Po/GQd5V955MO/WnZP
 Br5kA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 5C1B818000B
X-Stat-Signature: a7qg7kgoyt8tzitcksifq5uky54jgd78
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793629547-710248
X-HE-Meta: U2FsdGVkX1+v8p9SRSFXDNDCdrd3FZVc5/ciBE7420DdOvoeQpqn7Dggy5hXNbyf1uPe0wo4IpBwrdwz8fun6fBK6h8hUEGryBvJoGSwMLsEFrhseL7c779ypUUzzqQVq9CHyknkqq2Z1RMo4sDAkiHuNOl1HWWtHk9hWkyNYeIKkuNB/HvVr0s4afYaZD/WMNss4d1K9ODPX50Rkp2dIq1gOGzfmFjVYj4lvKrqBARqeWMwmAZVw/k5j+o6hdqI8VK5yTFsp+HOdpi7iAFhBjnyY4/rQOMjoI0lO7FMamWr3yTdWnyk9E/yh0GWjI01rK8pVZF2Wgz4B0955AysOluyulnOuFbes96s05qLtN/BHY0EyyH0MmzhQH8uo31345dZtGN39iT7LUSEq6O4BUV5RJqiQG65LQOE8af8uQMsfO9DKjFv3+jH5GyY69WehqO17gfLrjCTYW2ddos9kK1CW0xXIes9yILQV7O3218wMryYqnd3xRxmJIUi3x5WgfiiqvCEbKM8fRtvaO1vbcPc15K63CTVhItcCm/4YMvnqL8hW3u8URwXcKnMXEIZ6QPQV/wbfmb1985/HgOl3oNr6miZNc/P2mEpdTV1vebtubgl7ZNRUILh9avKW3fRbNOkwZfyjvfD+0oz4twUbojLlLERqJlhvDQrX/tb+NgK41wzGmW4hgKPrnL37FaO/DR+z7FBQHFzceYhegfGqxY/EpCSP/EhAJcXyZYtsRgYGNjj80i5IFLpxklaAvWj2Z1hDWzuGDGOH8gLn69L9O5eDaANkhIH04BML8kOaIfOcVEFGGbMlp7i3j23XS/IqrbTbBX1x1kuJ2nkIDZdG5xv9EvzWe/IdQDWkOA/Y0vwiEAgpZNV2ZJhMg5Z9y2OWgxe1lvRWp0N0KbGZsY9sTB1cYuenS60iT2RyUSnZuY4sbaFSl4wGRn3UgNB3Lken+Na76+2p62Oc+twR0g
 Cqy2PZ8u
 zL5Vvund5oJsjkOMgLBiRhojpg4OQrn4EJz1rg1RVscgjODlNamK1UH7oemgzDlZ517QLL1NNOop2Mn5oGfuXXp8hx4LO21lfLDH+nmCkuGmbhWZ5ghCzwTgjaQU5FYSHfwNUUyVAnUCUf15WKxFspJxLmgGHTvm8wbatqPkw4tiCIxvFMw5gCb2mFnLgdfcoYt/b26bGpNAcdRY8KuoINNc3QA2/Yo/PTpTMlT2HtWgNiXz2DzY00HmJxlLuLwt+encVPZ5fs9DGlLMN/nuKqpPmpIaDtqlvSbBR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"add_device" takes a name like eth0@1. Only the part in front of the
'@' has to name a network device. The rest is free text and all of it
becomes the name of a file in /proc/net/pktgen, where procfs takes a
'/' as a directory separator. So "add_device lo@a/b" makes procfs look
for a directory "lo@a" that doesn't exist and warn about it. Any user
can do that in a network namespace of its own:

  name 'lo@a/b'
  WARNING: fs/proc/generic.c:174 at __xlate_proc_name+0xb1/0xf0, CPU#3: bash/241
  Call Trace:
   __proc_create+0xd0/0x9b0
   proc_create_reg+0x45/0xf0
   proc_create_data+0x77/0xf0
   pktgen_thread_write+0xd8d/0x1750

With panic_on_warn that takes the machine down. And if "lo@a" exists
because somebody added a device of that name, procfs used to register
the new entry below that regular file, and removing "lo@a" freed both.

Reject names with a '/'.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: e6fce5b916cd ("pktgen: multiqueue etc.")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/core/pktgen.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index d63eeadddfcc..02af70d360bc 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3831,6 +3831,10 @@ static int pktgen_add_device(struct pktgen_thread *t, const char *ifname)
 	int err;
 	int node = cpu_to_node(t->cpu);
 
+	/* The name becomes the name of a file in /proc/net/pktgen. */
+	if (strchr(ifname, '/'))
+		return -EINVAL;
+
 	/* We don't allow a device to be on several threads */
 
 	if (__pktgen_NN_threads(t->net, ifname, FIND)) {

-- 
2.53.0


