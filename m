Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73331606AB2B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G1PL0TCS
Received: by kanga.kvack.org (Postfix)
	id 81CE66B05F3; Wed,  4 Nov 2026 14:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F54C6B05F4; Wed,  4 Nov 2026 14:48:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B476B05F5; Wed,  4 Nov 2026 14:48:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6FE6B05F3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:48:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCF2180855
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:48:54 +0000 (UTC)
X-FDA: 85398474588.28.02848E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B106A0003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:48:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G1PL0TCS;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821733;
	b=eVCkZVGgvTZKA72KkqElrV6R+xOvov2Z7dccwC6/Hj/YbhN7dni0+CsrF5NY71g86IEga/
	IqkHlTm1zc8xZHnTNyxXmDoI/03v+0HIZuYy1wv8Xax/9uA0FX4ekZ1uQDcfZEUDXIoDTE
	/mzpmRbXmePEJ2NqxrmWHqPJPVCUluQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G1PL0TCS;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8WPUZ8Xzk4Uf3KLwo9v6zFft8hyFZnIr4Ta+1e+n9o=;
	b=BQaJUpOPrhL7j+cctoQVVdCNEKMaD+LoPvWu6OElEZt0N1nKJwQSh5PStgwTTsYUrlLToz
	D9VrcR6ijt45boasOtLZ7a0be2eEL+0lIeBTm+Q6jNnmbLNU9Pb7rVK5r6aA2pJt/iCk7s
	OBCfExLCaXXUKd1k3S70gyPNK/+D7Wc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 499E04071A;
	Wed,  4 Nov 2026 19:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A081F00A17;
	Wed,  4 Nov 2026 19:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821732;
	bh=b8WPUZ8Xzk4Uf3KLwo9v6zFft8hyFZnIr4Ta+1e+n9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1PL0TCSVDwmq6lGU2BKIO3vpAy9ola4AujwmSLJkb5KMUnTLPKnCEvvzLMviPtgn
	 wND4dUemZH7RzXVci0wodw5Ce5v9lazZa2PJvSlXlL50ggFDTSmwojOvxU4655sT6V
	 da1eeT2llGyW2Eu8uZBGRP3z0bbZYTxk2n8D/Foa2zoY7iqG+BVIhTnHhNZAOkWxK4
	 00B0IFoyr+ECjUwAY17pI+6EKbEfW3y0CVh1pSS5m57e6CtXfHKw4ln+bCYcwItAdI
	 P9pOOC3vNTRs9xSAmPdROXPvJKb29eGdAkqsnQstZewCU65bM0CCjaHNhaQiD25bxA
	 MmdfbQAJQvIJw==
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
Subject: [PATCH RESEND v2 26/26] ALSA: info: drop the poll_table from the info entry poll op
Date: Wed,  4 Nov 2026 20:48:37 +0100
Message-ID: <20261104-work-procfs-drivers-v2-26-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1550; i=brauner@kernel.org; h=from:subject:message-id; bh=YteJ3j6/FblA5UteLfKk0N1VeXt3kJcYQjXVJOX1kxo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97pocuEQtOyVxSrtIrlLVW6YsviVsb7cE3Er6v6NVN EuJ7xFfRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQSWxgZzvozyXl46z6zj9qs wOZhqjrL/zyXKUPnOr7f0ol3l6+NZGTY7Dmr8rLwiZlvru6dp3epj+dff5pW5ubNCo5fef2qu8q ZAQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x38rc316d93s98krfsbgbmuwr4e8rkyp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B106A0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821732-801413
X-HE-Meta: U2FsdGVkX1+EFzNyO0whdlodI+Nnhfi7IhFkNGZxREiw328u1i7rtol0g6JdJoeaGSvIsP/dhfzTqW3TEKad4Z/6T38EzWCQmAQeA7kQe521C3GiI7S9PKtW4CP5fzfsL+pfHxqaA0om7w1yYFDqhyfnYFWzH+alqKiPj+pI8Ae3YQ5Oawzp0bZCs+zTPMLxq/A5MXFX/6wWq2F7yCGxw+AmXZQSqyQj4+s65D3Ot7Fmca0eZB6FVP5FzPwyFe4aWQ+J1rvYFMeUgWPHf+FwUBkgHPdMgNQX6Bwu1bkEGfAwRIIaoCLuE+rqFwNW7gAD3zJlqDPWFgvFClttfPUzNG0uVpzhrodgJcjaallCe8nZmr/Wu4vRiWiSb2NW/FsY3MzrN66At7diz0eowiy2mUCldAdoTjsqBlwEyx6hb47Avv9XSH3NarSTeU0h8PLfFcvvzP+y8fH+APFN0sS3eA09lCgKJ1zqyuN7kYMeqUVqPyrNo3qTNCyZtOyZLDpRQpLmrZY3YUNIH41/mM9VqACfnIGDk+XuLNIqGIN3PpDDCKVy6b9vzjNZa59Clf4CxVG6cZMXEZ3ZJ8uhINjbRDBJy/AZYVVFFDBZ31kvFZLwX1CFvWnLToD8bvc6PVNMlG8b76P3kPq6MGXWygmGQbcMmn0xBOZX2bERJrSFopjEc2qhDh36Sb2lhSFXl7xp6Wm7rv8rOz6PxABHc0/AwxtSp0U8dBUMRC/V1FmyppdkI6Ar3JUGTDndDiuY9TvrtRyPglrA9Ne2o+yNcIvEI9E9/eJlecO6Hp0jO67lTUB2KjT46TBqYneEuTMOutdfK+LKbRhPcOrLiQ7M+KBm/clS4ms0ygulkxI7Z+R3R9I9Iwjhl/980Ih0Rf9ajNFADNZmdaif4bPwMSfNEoryKbUxq1UO4LwDZ1qZqKupGplSDc3r/YD2WnqZSPtGz8M4e7eHTK8wh7vLHXPKBQT
 wtvv/9vQ
 WnVy+3yLNOt3Ak+cTecFPlsLCSTrk8zdD42QGSO5JYHRxQ6/KynjrLjDx8gS3+gG05uPN6itLVneuRiDkSq4Wxz8O2JgOwrOGX842wKuEK6RQGp+XyxI2W4ELjKSlbUYaANwxQDg8XfzSDuDEnMkfvhg5QcI4jA+zsjTsNFwneA++8qwjj6+CBKsWwY9EMetLdXYbGSp5CnP/On4qTAO6ylDsbLZkugNgu1BRvBTUrsDkWBr1ah6Dg2ih5bpWFsdz/OdNm9H4jRxO/b0CXVul5cUQHHsX0CoFBGHWQbmvHNpKkyB4Ekdp57Bntf1WQOd7nUfRRzjcig2cbDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

procfs owns the wait queue a /proc/asound file is polled on and wakes
the pollers through proc_poll_notify(), so the poll op of an info entry
has nothing to do with the poll_table anymore and only reports the
mask. Nothing in the tree implements the op.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/sound/info.h | 3 +--
 sound/core/info.c    | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/sound/info.h b/include/sound/info.h
index d6cb0346f77d..327d92059f67 100644
--- a/include/sound/info.h
+++ b/include/sound/info.h
@@ -48,8 +48,7 @@ struct snd_info_entry_ops {
 			 void *file_private_data, struct file *file,
 			 loff_t offset, int orig);
 	__poll_t (*poll)(struct snd_info_entry *entry,
-			     void *file_private_data, struct file *file,
-			     poll_table *wait);
+			     void *file_private_data, struct file *file);
 	int (*mmap)(struct snd_info_entry *entry, void *file_private_data,
 		    struct inode *inode, struct file *file,
 		    struct vm_area_struct *vma);
diff --git a/sound/core/info.c b/sound/core/info.c
index f837cfbe7313..c8735a6ec789 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -193,7 +193,7 @@ static __poll_t snd_info_entry_poll(struct file *file, poll_table *wait)
 	if (entry->c.ops->poll)
 		return entry->c.ops->poll(entry,
 					  data->file_private_data,
-					  file, wait);
+					  file);
 	if (entry->c.ops->read)
 		mask |= EPOLLIN | EPOLLRDNORM;
 	if (entry->c.ops->write)

-- 
2.53.0


