Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 385FD6088B1E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A2/gsEkz
Received: by kanga.kvack.org (Postfix)
	id 3FFEF6B00EF; Mon,  2 Nov 2026 10:00:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7606B05BB; Mon,  2 Nov 2026 10:00:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EEAB6B05C1; Mon,  2 Nov 2026 10:00:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 013C26B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:00:53 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83A70140165
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:00:53 +0000 (UTC)
X-FDA: 85390491186.13.A76C8F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9637140015
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:00:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A2/gsEkz";
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WexYP4n/eJfrpqN/7Y/99TWN9UmEAiTX3zfhZnWQ9bk=;
	b=tFwSTJZ2tjPzXpLgUSYJzl8hLOkEl/BajoXr/LmUUb6WQygpy1hhM/WXNPUqcYhDZlnACT
	Ij3Rk/QDSf/YwUzynIsKSETTh7XwFEn5mOfzbHNkzsJj0IWUwMIpKxAg0JG3cf2lkuKFyR
	SaI/KypPegLw5P/IvPEyvXCrLUu2NxE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631651;
	b=yDuXDtFGKIGcjTRfgQJpI9icfHi3tERyy0zv2g3RD1fws6NvEMryZ152avFNm9twF6aAcG
	+3yocnjPuWTvSptpMlVI0HIwkKZyDzDYtbP1Gp6Kr80lRY5940DyMrWJ4XVH5Da6v5jw1j
	ykrA8cASTbp3KWPwE021Gj8vKredZaM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A2/gsEkz";
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D66F3411C8;
	Mon,  2 Nov 2026 15:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46471F00A1B;
	Mon,  2 Nov 2026 15:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631650;
	bh=WexYP4n/eJfrpqN/7Y/99TWN9UmEAiTX3zfhZnWQ9bk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=A2/gsEkzx2kBH18SAsxMbRE7DBXdXekO2k0AMONwA38NS2BeDGH6AlKZL03w4/28l
	 7qWi2rG2rJCWCR6+fbGSYz+CfWBV0Ci0pF1WeeGvh6x87o68IUijRVhLCAnsysE63g
	 gFW4a3WlIujXOTwoCGxu2R7gkXBHQf9Y1YqE1Xn6xpgRz7WVUtfd1WZ2apgDKGSK05
	 CHRuIqGLl2EMG0sbV4xVnf0DD6i/OjIG8NGo5Z2uNU2Yncmc6lhQtFvkCw+w0QxB8K
	 hyIvh2pJ26eus4ARKhd4/cgXcKyC0J9MQ7UMZ1MRtXXvwcQWXKCar7BuOtiH+1SPZY
	 WmQletXJipnOw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:56 +0100
Subject: [PATCH RFC 16/16] Documentation: seq_file: describe how a /proc
 file uses seq_file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-16-75df35e4f8b8@kernel.org>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9637140015
X-Stat-Signature: p6cwieazxkbupr9btisae1nnbtyat87s
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631651-849583
X-HE-Meta: U2FsdGVkX1+slS6CekCsUbEEskW17/obd708q5qIjuZI6wDThfsN3/JNaH6cZD/q8lEaGWB/HwKFtQgqm4NOVm/lQUbIb1LGB7ZzP1n/7IXKIWNyt8cxSKEBd2BPiWAFikpxavmc2ELuTmiPDGbIxMVo2e3g+QNkNV7p/uLFtOSXZ2JfwaqRavQT55X9KMJLvlkqe71R5yw25wdJKwIvqka2Dhq1JxAdnI39RoJNRLQ/1iTY8h40OyuElRnMX8nlgle90+XElO3KvZxUpcwW8Ems3g2EHZnulk2gawPfJFV9TWCW7oC3J4A1RHIRXdq6jbHF1rVGE4Jx+rcTwZfS96g7LkpJfx96AOXqo0C7itfjparLP24zlAs/rQnOAsxueFQjh7M8kylPEnpHa1PkR/Zdljeqs/MMnF/oF2CnlQFgTy0pTW5T4LHnqZjWDDgy7+qgKi9VmLj/FL4WKWpBYQyhYQ5EHkoOxAJDQSwpbUXr8M2b98StvypE9b4GysLcxlruq1N3rhoo9WOXBBQrt4R2XZZrrTIc9P+P0dO1lRzKsYUcL92PRDffsGqEusNgxbfTnUvKI9mmdsBkWxp+TeanlP/yJFuLEnjM0Jqgmnan8Yk52v/IKtJXtIMnXAD+jLe9b0ejCpdwVJEjnK8Pf4lQGyyTZJdAhB89FEBokcnjM14TVAvCqNUvVKZapih3sXm18Sz63z1lrCiFshAr06rJBGrYgwf63mwZ2iFITFdjESo2wloQFs3cbgukhQmJMIvSvDsE+zOQybn+Cuh1zN8cX7nFoFFHUTvby/tQvflGS15PIm91gpLfvEDHG6Hl6fSZZebFOtkfaXWhW2vwPgaFxfHZayu6hJpIQF0W1mG+jDKC0GsbFb0i4Nkgff4LcZdERxffPC6SUdwIZ7wiLf6Og3is0GUKaoMi0EALkE5IAnir1ATmjjsjHjFZ8Vo2Wa7HEfP+6PczusgcUUJ
 r0Pmki4/
 xxjMzuThyckt7lFkpnMg5RBKOFlGfjwSFLmrx8VgNX7UZW4ZubL2+L3FQoJRqJia9x0h0bjXKXDcTWixUZch1AEPgvNDNzYXlJAgHH3kkZ76/x33jaywX+XbkmnqQNrCM+hxMcdXEtLj9xl5/pol99GZiQwTYYICzT814HjetXSKi+35QVHq7Z3zdNhKS1/LHHBE9ffIyn7I6nMCpYQMCzlHCAhU0Es557zuvHgEXJdiswDOTl+4/BEw1MJHF4fXDBPjLFhJdM4pP5Q2/SE/1GVFWLYu+/5hUKnUjSFL8b0ZJp1PUokCGyqNxwW5+3G/C3Ofs+QeElGFIkNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The example in seq_file.rst hands proc_create() file operations built
from an open method that calls seq_open() and from seq_read(),
seq_lseek() and seq_release(). procfs doesn't work that way anymore. It
opens and releases the seq_file itself when the entry declares its
seq_operations or its show function in struct proc_ops. Say so, and
point the extra-simple version at ->proc_show() for /proc files.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/seq_file.rst | 42 ++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/seq_file.rst b/Documentation/filesystems/seq_file.rst
index d753d8177bcb..8cfb5fdabe99 100644
--- a/Documentation/filesystems/seq_file.rst
+++ b/Documentation/filesystems/seq_file.rst
@@ -68,7 +68,7 @@ kernel 3.10. Current versions require the following update::
     -	entry = create_proc_entry("sequence", 0, NULL);
     -	if (entry)
     -		entry->proc_fops = &ct_file_ops;
-    +	entry = proc_create("sequence", 0, NULL, &ct_file_ops);
+    +	entry = proc_create("sequence", 0, NULL, &ct_proc_ops);
 
 The iterator interface
 ======================
@@ -277,9 +277,10 @@ seq_file system, but we have not yet turned them into a file that a user
 can see. Creating a file within the kernel requires, of course, the
 creation of a set of file_operations which implement the operations on that
 file. The seq_file interface provides a set of canned operations which do
-most of the work. The virtual file author still must implement the open()
-method, however, to hook everything up. The open function is often a single
-line, as in the example module::
+most of the work. A file in /proc is special, procfs hooks the seq_file up
+itself, see below. Everywhere else the virtual file author still must
+implement the open() method to do that. The open function is often a
+single line::
 
 	static int ct_open(struct inode *inode, struct file *file)
 	{
@@ -343,19 +344,38 @@ file_operations structure will look like::
 There is also a seq_release_private() which passes the contents of the
 seq_file private field to kfree() before releasing the structure.
 
-The final step is the creation of the /proc file itself. In the example
-code, that is done in the initialization code in the usual way::
+The final step is the creation of the file itself. A file in /proc is
+special here: procfs opens and releases the seq_file itself, so there is
+no open method and no file_operations for it. The entry declares its
+seq_operations in struct proc_ops instead, and the size of a private
+block in proc_state_size if it wants procfs to allocate one like
+seq_open_private() would::
+
+	static const struct proc_ops ct_proc_ops = {
+	        .proc_seq_ops = &ct_seq_ops,
+	};
 
 	static int ct_init(void)
 	{
-	        struct proc_dir_entry *entry;
-
-	        proc_create("sequence", 0, NULL, &ct_file_ops);
+	        proc_create("sequence", 0, NULL, &ct_proc_ops);
 	        return 0;
 	}
 
 	module_init(ct_init);
 
+A ->proc_open() method of such an entry finds the seq_file in
+file->private_data and may set up more state; ->proc_release() releases
+only that. It runs when the entry is removed, which can be while a reader
+is still copying out of the seq_file, so it must leave the seq_file
+alone. procfs only calls into the entry between start() and stop() with
+the entry pinned, so nothing that runs there may wait for something a
+reader can hold while it copies to userspace, like the seq_file's lock.
+start() and next() may return ERR_PTR(-EIO) to say that the entry is
+gone; procfs unpins it right away then. An entry that wants to start out
+with a larger buffer, like single_open_size() gives, calls
+seq_preallocate() from ->proc_open(). The file_operations above are what
+a file elsewhere, in debugfs for example, uses.
+
 And that is pretty much it.
 
 
@@ -394,3 +414,7 @@ value given to single_open() can be found in the private field of the
 seq_file structure. When using single_open(), the programmer should use
 single_release() instead of seq_release() in the file_operations structure
 to avoid a memory leak.
+
+A file in /proc puts the show() function into the proc_show field of its
+struct proc_ops instead and procfs does the rest, with the entry's data in
+the private field of the seq_file structure.

-- 
2.53.0


