Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91558606EE9C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hvt3N63R
Received: by kanga.kvack.org (Postfix)
	id B62306B05DA; Mon,  2 Nov 2026 09:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B39A06B05DB; Mon,  2 Nov 2026 09:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A777C6B05DC; Mon,  2 Nov 2026 09:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88C9C6B05DA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:27:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E3CCA013F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:27:36 +0000 (UTC)
X-FDA: 85390407312.24.ACD3863
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5A84C8000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:27:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hvt3N63R;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5t8qKNo68SCWoforDimF8hL2ZYL+p0Okj8bWoZ1JT0=;
	b=GgOP/5J/XvBhRWLidSbQjSQsdZKdIV/zfpncOe7OR6lH9eNgk6p8bt+RxHFOWy5oGmxnkj
	ckD/uuWla3SSiWrQ/D8VIanwHCOcU+Z019kiXSNj0Y1XO5qqB/PY6i79rWuVyWUI6dCl44
	62HFq9FkO9S4Izl+iY8W2UZ/aN9NlGg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629654;
	b=jA69f0VOq6VTJ61X5Sn7DrFfaj40/hms6vROky5KLrA4cio9ZxAMRx+ryAWWgJRy8VaEif
	DazE3aSnh5hV85OckW9dASujRd0bSqrloXqvyL7XGnmjdp6/Tq+8fn3Di02GzNdoh7BZ4A
	PYCHKSpWtFb069v+ouvR7r3ZJUvEkTU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hvt3N63R;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7D6A60238;
	Mon,  2 Nov 2026 14:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFDE1F00A1A;
	Mon,  2 Nov 2026 14:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629653;
	bh=v5t8qKNo68SCWoforDimF8hL2ZYL+p0Okj8bWoZ1JT0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hvt3N63R16p2fDZtChXjcMwdKVbvtxfkoL2k4OxbkJ9NXiN3sUvoI90Anz8tghLzV
	 tw7TRLB1mJI+ndKzKgYA8EusdDfCEFHDNDNB81AIW3QjjgCwg/TU6I079wNwJuekME
	 GgYfwUhSITW0rfvdsRQDJf8rj9zB05fpKjF8xVxdybjPcer/CH1qH37gxEgqe+026Q
	 OuFUuk+WcD3uSGWDc90qsgO7GgFfaxkgSrLrqyeXVxjbcarjoj5jc97EhboLO3/3O0
	 KcAvyFsBb08Hf5sOjHYp74WBf8FtRIs604ayotkQgHKNOSX4SCmldQ2ODja09nMv8N
	 2p+DzdlRSt69w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:40 +0100
Subject: [PATCH RFC 25/38] powerpc/crash_dump: check ioremap_cache() in
 copy_oldmem_page()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-25-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1312; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2dbZnDPFapx3dAW5qeN54CL6hHWBvjsrs28L3h6tsIk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJOT3t4mUyCor3Li661vsa/yObLOB7XeUji6boXCC
 secScIdHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPh7WFkeC/LwqiVxiMX6PN4
 IXM3/4WNlnf/rlkw4SVrp5CBfEGgISND+4Gm4KSDXU7MDmLZHq5y5z4dYP+8p+ODD1PYa4mTduu
 YAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5A84C8000C
X-Stat-Signature: 3qhchgwzik7nkmei7gmjgd59jpdhay9z
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629654-393007
X-HE-Meta: U2FsdGVkX1+7Dt9FiAsZILCuATROotoq+jUzYdRUoWk60D+padOIYes6Ua4czpdeBncxzKAGOxUUklpetZkW2cjBmR5HcWBTlJaTywPsV4GoYvYefPpu/1HMJ9AqNisfHvPsnv7RxXjyfcXieDUcvy/pn8pfPJv+0OegizVkSl8RnKuV2Xs+ap4V3etv1W51y/mtev1fa9z0iNpwdbI1vN+dkJf3+IhbAJancVhPdu3eHg1jqOet73kNkjFuY1CFUGcGR2S1WpT7+WCB1WtH9FgnrNQqjrzNuetIeZXC5QBiqSQhy2wAZJ6dfxFM0IlN7miR8iveNexEuoEpXsauL2v5tB8uLUFDvkE9WpBxIkUGS6bfuXlQY5Fgw7eTrJYKkmGx6HGK6ob2Dh3JCfP3liiyUr7LeTJ+K2+PHmyFoGO2TA6f7ZuTYSY58/uq3cuBi6ThiUdx0P8EzrYKjyUt4fD9ZL3ltO+mzCguvZp7aGuKA2yxv6ccnc1bPOOorrROMkAxUZl7h3AWNhO9H5ajMxx3PXpcOyCaOH1P49uyZ8gPikGTH05McHsq6QFz5jyRnrKwT4BOEowYgMMvXuD1BghhJY3Y1uKVE3tQQ0z8mOKRubZDPtqFW386AYPh4fNmHoj/TK/xzr9/rKhh0aP9AyLr7+ziS6edluhteBWkkG8qcfVVZSK0G70g14LHTPJEApUwuNevqMggRVrzLwE5JDhTJ8ntVfz2eiA2mrscJs5pdJs1qJLS3ajFGmJNuCBOKyMAZ+f4RxqEnzU9YB+cUKpby0wW5BaixlyDlI/2Zn4HBqvFjfvzZWcT9PSq3VMX4VlRuowgMf15h2bf4WB3jUICSCy+M/jrnBUN2FkUNfuYRQYGYGPT5EH62xCrNMJwPmBOkz4R2Ngfv59fQ+q/JUMOhvparcIMVQMoK7CRjtRXhV2se/jHBfTTZz66lIsgpAzxfe7V+N8hmzHDREJ
 Uk4HUoK1
 9ZH+yb4HN3g/Iv/qRFqLlWAX4bLpgY1tethJOH2vY7FP6lRZZQncn8Gr3Q7/Y8OzShsUyzYZ/sL2dergHFvrzbFIQwWPF0sR1phzEPMEq9y0d9HAcIQjOXfbvoTWPAUVzyayvc/P+PDKNUXX/YEMb2S6+xedZnOpiPi332vT9Mv/S+sgxTyZ6KxabLCbLPQgVrbvftqvDI5yzfwMEPRhFY62R+Irr/E8ij13SIiX18FKRLuV3KxoZiikpp+RXkpMqKi0os1ogmwdXY/KGaA2Dyr0NatAH9JRC9wJMG3q+yogYSwZnQ8jZTqfXgDujORu562LxvRx5uhYT5qE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

copy_oldmem_page() maps a page of the old kernel that isn't in the
linear mapping with ioremap_cache() and copies from it without checking
whether the mapping worked. If it didn't, the copy reads from an offset
into the NULL page. That oopses unless the copy happens to be a user
copy, whose exception table entries turn the fault into a short copy.

Return -ENOMEM like the other architectures do. read_from_oldmem()
turns that into -EFAULT like any other short copy.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_page")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/crash_dump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/crash_dump.c b/arch/powerpc/kernel/crash_dump.c
index 103b6605dd68..1543917bd3e1 100644
--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -86,6 +86,8 @@ ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
 		csize = copy_to_iter(vaddr + offset, csize, iter);
 	} else {
 		vaddr = ioremap_cache(paddr, PAGE_SIZE);
+		if (!vaddr)
+			return -ENOMEM;
 		csize = copy_to_iter(vaddr + offset, csize, iter);
 		iounmap(vaddr);
 	}

-- 
2.53.0


