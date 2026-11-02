Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF09608C94B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ge/hcfes
Received: by kanga.kvack.org (Postfix)
	id 2D85C6B05EF; Mon,  2 Nov 2026 10:10:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0656B05F0; Mon,  2 Nov 2026 10:10:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED976B05F1; Mon,  2 Nov 2026 10:10:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 017CB6B05EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:10:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8162840138
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:10:42 +0000 (UTC)
X-FDA: 85390515924.21.964D3AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B88F980007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:10:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ge/hcfes";
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632240;
	b=M/5aX7kJ8yW8Vvu6BwSuYqlFFB5Gan6gCFCurl0omzurGfrNP2qWn6w5x3ieRxE7xQdvHw
	ZievN4W2X1LvRyyBOF3THe/ogoPbH0+ZtMI09c6i3zNmaZ7BiMj1oroDUI9Q85QBYjbySx
	IfWy3FCFNhSNMmsaryj0pk0rGysHdrk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ge/hcfes";
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhE82sMafPzxvfPBNz7KCycPN06o3nm9WBF7ozqhvvQ=;
	b=WUGkbiE+n1cJAYoqt7hs9xAoO1V2+5bnriB77nhjYhQAsi7KicKXMwO9XrYn4RY+judm6i
	timVKVx4dVLAA+QssAWPaInN57T9o6xZM5bYQ09+21ICfL4Kkvb2zzyvXOMzu1pVOP+kUo
	+MXR0YzgP+Hn7Z9GaNpginGVr8BpXYk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6028C60624;
	Mon,  2 Nov 2026 15:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBAA1F00A16;
	Mon,  2 Nov 2026 15:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632240;
	bh=uhE82sMafPzxvfPBNz7KCycPN06o3nm9WBF7ozqhvvQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ge/hcfesra4b7uwUf9ZqYWB9njrsdW7ikBhB2+TOOaHniD4pDo5CkBQJygC306u5b
	 wB/PtUdGYF68K8Wo2p8YgjLfxD3D2QhC4+E4fHRnOPwNucxkzf5DU27WF/NlWY0Iqy
	 GAJgUzmaayVQyj5BRZUykLpT+rpgSNU232/4wjRYpPZguWsLgLHVBrYn151kBTwpRV
	 nXPzhip9LUf2q59LdnLw/8JsXlkcQJRIUj4EgrnieDoD7zSduQEyreNMEArDccn4Qs
	 hw/iWwFl3I5EqeuSbLMiGYZHNpZsLMqiQMwr9TKPFUnb5SsH7J+RiUYOedx6+niPBc
	 3NqMUySut53JA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:08 +0100
Subject: [PATCH RFC 01/23] nubus: let procfs own the seq_file of the
 resource files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-1-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
In-Reply-To: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1301; i=brauner@kernel.org;
 h=from:subject:message-id; bh=x7z4QEHcj9RNvDtDgoKANKctl9Sfloc7qmQpa+Y73Ns=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WK7fFm4VGPxTRVG9kNHvu4d2mV3i6b4vmrNOVrR6u
 yuKTYntKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmAhfLMM/qxq9uhSer5rKl2Ql
 TFnt4xj4b6+efHfdMuZlO/bd3bPxKSPDGfl1C7eGHtq3U9NZa+MW4UvzrpQ9y/tVL3jEJn1i6Nl
 SLgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: B88F980007
X-Stat-Signature: pm4b5k5ccz3r1mjrsot4b6t5kxsmy91f
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632240-684652
X-HE-Meta: U2FsdGVkX19vaFn98G7fpmXXkJaX4uPGT+YdNc6S4kVRyuoP6hP6AQshUUbZYuj++DF/bTNnDdRFVDN5uz0sqnM2ISPctxbG3KV/ny3cRJRknxIto8tEUii/ShUJ9Zn7GuxaDramz/E83vWj7+Zgyia9IKVxMKRQxNUgwnhmAZr7PkMQoZDn+eLXpnAqawShDC/yMX+yMBuOfkgtjA8Hf9oiu5rK0wbBNwQR2iVGl96novBc/AxdhlY67eQelyK67HqYS0qXc4d0JbCd5FVuLRrObh5nbhHghYmFlmer7dCiIRyCL2toR1rsCMUQ16pqk747f9JbHKyrDKUbNFPje08Dux+eEAQlVPs+8cCK0Ew+Pl6asRTD+vE1G19Mk4WoGcJUuLszoAAD8yRqtR5N11tL+p+hFYts9lib3WiEPBXO5acI89scABoVr8b6mnvuRAsTzYyjWEz76+9XWf+EYxFU49Pj2l8SmvAJ5ZoCu/wVrOMuM+F0TPwYnlI0Hdg404xDln6bh2s2X/ENSryxDRW8kved0SP0oOKMAbsL5hngpuNW/Rf4g6YmtJXIFjta30mjTc/8Yo3N3WuX6DOAMUmHet2v92Ke+uGucwh+fGcICwMPsJEYsvJqRFUuoRLuyuCpniOOLqjwZGlroYszXNXgQCQUddYVpkaLqeqFTlcTn6qOrcd5vRV5R7vatlsyCI+0g6DjVkGt2bgeUcOXZtQaq7sYfBvap9L3a7WlZgW1neTiyiKr9CA/x8ehLIThnLEFu1XuT62gtyOgqKICJ/pYsDDXxOzswsYerMmUfjtK5NLlCgaoPclikeQ6pQJ6EODGtM0ovy8ctJG/+7mqjVr4Dr6SrGVO9cNMnA0Ciz+SI+HlMX0ZAWzMtkuwfQN+FC0clW+xVr7To8OCn10/QgLoRASNlLj5vBcy0R1OXte/0vIYFaCn4oW+WYc0rU5wTDEbD/QZ3ASeWHtdvuj
 /2ds0kOz
 HNU70bRVh/ysa6OevaFKxzDWgpbWtzNT/gQmm8LX1QjgQ360CHZ/G3lNqWlwbeoAWt6qmx+seU9wVMrYCG/pKsgkEBkcHd2T2YKBuwOeMG4qvd6SWBdkmvjZsP7mrZ6GI5ui0+ULzpIUUmzYBt7DRTYc7C6tXIvVNFl99lraNT9VMbdl24hkhz9HJcCQ5+HjDl20WuyKU/TX9W4vJoKUq+ZBHHCnV8Vp9Ckd3O2494E6X6EAf6RPigQmLEJz/5QuzrzwUxAfzgaDikIev1BryMdRVymkj4i/AL3HgAt5yOWLFWLa+xVVaegUM2D3rJic+86/8pHxKw/FpmOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Get the inode from the file instead of ->private, declare the show
function and let procfs open and free the seq_file.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nubus/proc.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/nubus/proc.c b/drivers/nubus/proc.c
index 3ea3d1738eae..cb21ad1d9964 100644
--- a/drivers/nubus/proc.c
+++ b/drivers/nubus/proc.c
@@ -107,7 +107,7 @@ nubus_proc_alloc_pde_data(unsigned char *ptr, unsigned int size)
 
 static int nubus_proc_rsrc_show(struct seq_file *m, void *v)
 {
-	struct inode *inode = m->private;
+	struct inode *inode = file_inode(m->file);
 	struct nubus_proc_pde_data *pded;
 
 	pded = pde_data(inode);
@@ -138,16 +138,8 @@ static int nubus_proc_rsrc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int nubus_rsrc_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, nubus_proc_rsrc_show, inode);
-}
-
 static const struct proc_ops nubus_rsrc_proc_ops = {
-	.proc_open	= nubus_rsrc_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= single_release,
+	.proc_show	= nubus_proc_rsrc_show,
 };
 
 void nubus_proc_add_rsrc_mem(struct proc_dir_entry *procdir,

-- 
2.53.0


