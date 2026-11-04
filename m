Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DA0B606BEE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iqFhZDQ3
Received: by kanga.kvack.org (Postfix)
	id 49DF06B05B8; Wed,  4 Nov 2026 14:50:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475416B05BD; Wed,  4 Nov 2026 14:50:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365346B05CD; Wed,  4 Nov 2026 14:50:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16FD06B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:50:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D203C0865
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:50:53 +0000 (UTC)
X-FDA: 85398479586.17.0ED1079
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id BF103100002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:50:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iqFhZDQ3;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUZ4tW9HsyUaK/ejkkNMI5ANy0GmRkIlRIJ6yNjac0o=;
	b=Mg3ptV4JH8p1rOZzTNDRqFqAFDycf3IKLZgGa8ArqgN11gm7SbEQA+Gd0f9QtpAyl7pDSi
	H+hW3Vdl0w21fEXQzxJylDwGj9/BaYL8D6zc+NAU1Vubbon8HoBM2qom1bo2+hCUk9+s+v
	b4qm7BQY0UslaTWMIMw03oScGODCUTs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821851;
	b=U27ujVKnzHUO+czdZBxM4tIcHu6iowo3KdwByLy8rB2faX3O9kiVicGr+nZFmYnjE4Jxf4
	PYL/VQF19cKKJcWxAZmXM1fg2pPhgU8SB4J69hjdqRBn/hcpq3QNFzZx2B7VxXM5NMvQSR
	SjnIJK4XywzQYFkN8beF9xSp2XIqdjo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iqFhZDQ3;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0987F40E0C;
	Wed,  4 Nov 2026 19:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEC31F00919;
	Wed,  4 Nov 2026 19:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821850;
	bh=PUZ4tW9HsyUaK/ejkkNMI5ANy0GmRkIlRIJ6yNjac0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqFhZDQ35GfK/vsXy+ylTu3Eh9YrS9nTSq27+28SnBC9XKvW7PfMWDO9W5Ft0iDiC
	 2su6MPY9k2TxuW2AnVg2vkBoLPH5Ce+Yj7iPgWE1OMfQXuAjt+wKv9ns1AIE6Zh8f2
	 36rTQxsqFfC8trxeiSZnRnFYf6vYHW9H/wwq7q3bPyDytQtzWderj9LRXTMixQp4Qn
	 iDLkoWDCDGU0TpyQelcs1HXFXKLJrD35LCYzeMiq0HAZIegNRaAkkGVKs79qb+wzhh
	 UnoLohKjRfX7+w2z/A62dlh5PLszggZKXcxYK/t9f4zySuslTWVXxeONmWQtVIKX7q
	 3JuDh2CyL543w==
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
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 04/30] lockd: let procfs copy out reads of nlm_end_grace
Date: Wed,  4 Nov 2026 20:50:36 +0100
Message-ID: <20261104-work-procfs-fs-v2-4-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1305; i=brauner@kernel.org; h=from:subject:message-id; bh=yC83pog7S4Eh2+psAQ8qDYZ/OTNKlefl3tGbza44dqI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97tFPEq3Pk861Kea+tknP5Pec7S2X9JWOzJkzvcjg8 eGGlXfdOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZS/43hr/CRtGIJZ4n01d4b H1v+y1f677Dj1MpcFgcZT/+6tVNuRDEynBQ9vcEl403OpO9xU4NMHs3nFGp3Oh6vtE0lecu7jQH v+AE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1z1b5frsojc6e67d5jz9r167d6udp4rf
X-Rspamd-Queue-Id: BF103100002
X-Rspam-User: 
X-HE-Tag: 1793821851-118577
X-HE-Meta: U2FsdGVkX1+8eEEMuGADdnHOx1BOzKPuQZO17p/rXkfQOyFdHBdbJhVpZPvKfC7Ds1zHK+xis3aIDXHWSjoCUcRZN4yjmvXmUWaO3MUI5Li5FDLgBktXGIIwhP0/xZvkhYdvz0EGH9t/Et19X5Xi5TFLT3FePpKfK4VugZcrPDLyVRZUIQmX1wKJFP0AcB8iYM3qI33flTx0gXNXzdYYI+ZETZgWfBWsRhViC/aT1P2T4hzc05W0yAjXGuz7qRsjMFi+GAIJk2eBr/0Gx4uIVHHfW27MbFV9qkrdfzrZTtvMzPqSuB83x7l0CHyjpRN1M8enKsbP/iw0gHJieHsGcAtf+1vvINvO/SjfGBLD5LR7DPZDyr0OgD1S72NBylVBelaV/DoNquolFvL4if1wcQWzid9n/vwnAf5UlQ2LdvU3d9zm0o5HSobnpCc0yRitIys3nynqz+vv+K4chiy7pd5JiULUe+N+AyUrWztjpqCzBZtncbpwN9Mbysm1VZ3k8eiefvj3U21j6TdGjH3mRS0pZ0cfP55HftZza/oX+wUQzO399xptr0VvxcJ8YX0FMfKzXSulLtlRrn8p+/BffPA1EeZI/WIgniBtsRcNUrJrjlwUR4kPmgdVNsx78OYNmJIZhJ9ZDOrhkfQqm2HqisvWhhW8U9VF2dMYKC/wGX0GzxyZugvCHirlmzsaHyUCs56Q0h15ZBIWxAxNfRa1L4Yl2V4dALugxbThQWpugD9MT5twFYXQEQzDiFIcKN8YgUqNVvabaLuFQvhy79U7KooYHsgg+kmF8/MEgTCrSBIcLxKnRWLTsE9uN1r9hiwejlj4r8Y2u7r3Khl8IX5vIVjKGwfCoJnh/qLAQl31CA5b1DHPYMgqMnqT+KkTSRrsRUUE7AXrYBRwc6jILGM4CEy8IhOmUjYNVwfUaJdKH73niYTrj15Y/JTBHI/YGoTLAPSLRaPu2E6gM2QJ8Xk
 DDsohjRG
 QWyTMV25vQRtpPStKqvxZLCbyzv+ENSY44idWEABNMfeDlIYFbhP0jOKd8qEPsOgwZODcQIeTT/KyITOXtegH/81BnHcLK6/VJxIflgth9dMx/HJonV3iDi0/3L12bix6XJVAKD5mcPARl+Y+nSW7LFa66L23VVOK+MXLPworQb6H3HU2gtMyxwnBPukMQdpaq0XHY7lj7N4Pj7S4TrsFHQb5qMVmQSX8aQIFj/LX6GiNL02yBLMfG2wsfsxzhlZ5Y7h4NW9A2spMJlEGiwfZEW7AF5w72imj9rgGuVClUMoIqAUVcbVx4kQ7axnfZZMgVX1aumXDQ6NNHZ+J7pNsneKdzFmVgUvXqYnjo58tIzfdinzfa0jFtj8FVX6wZOeSN7sJ4+rHg99QzSAveQPv9qWso7ntHa/QgSnFvjNJl6kgUUZHAwHz6RCL0esGQO42uESm/oWe6G+xRvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry.

Acked-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/lockd/procfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/lockd/procfs.c b/fs/lockd/procfs.c
index 852cca8c3588..64195c564cd3 100644
--- a/fs/lockd/procfs.c
+++ b/fs/lockd/procfs.c
@@ -40,7 +40,7 @@ nlm_end_grace_write(struct file *file, char *buf, size_t size, loff_t *pos)
 }
 
 static ssize_t
-nlm_end_grace_read(struct file *file, char __user *buf, size_t size,
+nlm_end_grace_read(struct file *file, char *buf, size_t size,
 		   loff_t *pos)
 {
 	struct lockd_net *ln = net_generic(current->nsproxy->net_ns,
@@ -51,12 +51,12 @@ nlm_end_grace_read(struct file *file, char __user *buf, size_t size,
 	resp[1] = '\n';
 	resp[2] = '\0';
 
-	return simple_read_from_buffer(buf, size, pos, resp, sizeof(resp) - 1);
+	return memory_read_from_buffer(buf, size, pos, resp, sizeof(resp) - 1);
 }
 
 static const struct proc_ops lockd_end_grace_proc_ops = {
 	.proc_write_buf	= nlm_end_grace_write,
-	.proc_read	= nlm_end_grace_read,
+	.proc_read_buf	= nlm_end_grace_read,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0


