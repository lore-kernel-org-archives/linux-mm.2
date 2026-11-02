Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D75606F201
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RVwyyj26
Received: by kanga.kvack.org (Postfix)
	id 967046B05DB; Mon,  2 Nov 2026 09:27:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E4D6B05DC; Mon,  2 Nov 2026 09:27:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B706B05DD; Mon,  2 Nov 2026 09:27:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2E86B05DB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:27:49 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1712F80122
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:27:49 +0000 (UTC)
X-FDA: 85390407858.17.6830D19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5BCD3140008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:27:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVwyyj26;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3x3EcOd04d3k5+O3dMfsGmWB77s9fU2q2h860UaVdk=;
	b=dNLU9RE7YYmQ8Q8X7axFb829wwhWF77UTU0qqYfKt57hYWBFLy5IdprXIaFaGlRyMcfB7j
	E5DvQmT62+NXff2aynpa60q+lRNH0ZHinuOqHb+AFzXOdRPhp31P6fAZ6jzlaPseCUGqdz
	S5Y2hVc2AQ2oSv3+NV7TDF+ibMCCZ6M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVwyyj26;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629667;
	b=HICoHAiDOvACzClBzikAm0hDwYkU29Uo0HwZf3Z5+m4wBQyNpDjJnOuezaIu5xgQ2XcDZT
	nY5ujvGK3XMBBO2/qFiciviqaMhlJCHZYDK26ojjxNYYd4oQuDfSLLJnlQ4VMhkuyUUznO
	1ZK6gyKh3emD7yAmWaUYGnQtMlXTV+Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2296601F1;
	Mon,  2 Nov 2026 14:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5CA1F00A16;
	Mon,  2 Nov 2026 14:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629666;
	bh=a3x3EcOd04d3k5+O3dMfsGmWB77s9fU2q2h860UaVdk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RVwyyj26nRGz0YAa3qJjLMbMcY59GFv7k2/Yo4WgpVWb59sfMb8Zl9naRaGYP0rou
	 MMpo/iaTuwZ+wi6sRL6CWH+xBh8p8Hh0LzLpasPr6e/4udRG/oCcZ29xKchnIx3/p+
	 B3Jo+wFAlApWU/ThwP5etPS2jmB2GKh3nFbyeKDeBWGAaYO2fqeijfiRa42kJVjmo5
	 eE8+TH9zCGeavvC5T8ODN/DYi8pcd4vmfSKYG4AUNTrxGouYTZAQo3PNclBsTunvuS
	 i1W58HX+mcpImcnTaTchfOLoReuEjUSRmdexvU8N4yNjatMl7C5uOyxR6YUyGiu2Qj
	 eJ8cshD06UL+w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:41 +0100
Subject: [PATCH RFC 26/38] powerpc/crash_dump: recover from a machine check
 in copy_oldmem_page()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-26-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2160; i=brauner@kernel.org;
 h=from:subject:message-id; bh=46QTFCl18GYq9rYmjhc3/nfnECuPknUgrDKXTEluZq8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJNjfd/SLtTaSr/hcs8Or+rV/z323q+aevR7v4GS5
 AXFwhMXOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyv5Xhf9Ujn1e//n02s36h
 97fg8AGx5+WqXD/VJ1+ZtszhE6fMyz2MDAuiVhYyzznyU29ZeOz86L3bl/VWxVxten6I87kdz7q
 Q9ZwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 5BCD3140008
X-Stat-Signature: 99f8xm4guiqpzx3rcsw3tou13s43djds
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793629667-695602
X-HE-Meta: U2FsdGVkX19reXJWaq6vOfY/FrGC0ziB/oxGNbPQ4nhdCsUFEOYYmcXxbRzE6jIe3J4UIMMMhJCZqPY+/Cbk0rBSDAUQ0umChVW3qOeGbL9WUPE0/khjLpgjXspFovfhcVnjN/RrZ1YLXeLr3uthwwzZ0rcdlAksmr2SUctreIF319M/4pvpRR2EfKwWeAcAeqDEzy0VG3Q1JYX1fwt9/Mn0qevX0mvYFvdZfXpDLr2C4tHB1dHlIAvG+gSQCZ12Id4nNCApMztZcwc0g7ObdzKqMNZVqDfYlhQLaI9YTgv6PxRANYQ7caugzvBY+S+GhFG4ZeM+TLtKz0rMBPZM8/dNdPjUhTymMCgJvRg6N3i1hh72n3/F/9bhIMB5JvmELIvYYse+y8OTJE03VBlHcE0aN/kCx0axLreahAKY/lvT+o5uHXsAR/m6IKBX1f4Vl4ubb4hicAISr/8V07v9qDy6K8ksIrqlsVawpajZWDKOdjlEdIxv9S3EX4zXqZ/b0/bq0gv+/dLVq3SkVG+S+EJv2NwqTEmLrIdbMfQxjI48BvedHw2csvxdLTbakS9d/XRQGDC7LaFMBn3HrdW9WtLAd1Kk+xBPqJEuEVDk7UPQkAY+CP1+Op482XdQNmYA0EckpBrYVdQGjniatbYJyuKIJtzKcuqUo96RsyeM/TyRlHadgQo7H8vboyQgvcSuVouw0o7LOBSf2mv2VfSEKSqpbv/vG5hJ9ZfgCqataWr5y5hZpm6Pbi4AzZIG5ULh9IQaNc9r6fR5lGoq8OcrzCr3zncOhvRpsgNDk4AU3UjZ1GKFNnrNQ8gn0nSvJfpeMJ7ZDRZl+N8f/nPHD+lSvUMuzLOcLmh67M3DhitfwTX/syZ2nZ+IJy5+ciffOV9kSxG2eV4rH7qFpNnRupH0/XY9MNuGkTZ4Y9iSLFZ6tPCNmyDKAnQP5wvRQCw6Hc7XP/vYOML2B9xLwmlsZMf
 tfMMkf8D
 H+O4+2F6qk8QjpznPccWSO32oEuwuRghDmnvPfvLrRK+9ax+XHt6v/px3ut7w+zLdNugSUzhOpbv9hAxSe9b8IISuVv6VJZO4Niu1ZCUMHwWxhV01c0vvF4g4aueLgrXgmqvE1DoWyR85Umfb78HMw5X3+PZPNXz6n3GtwjlbOjCJFeYfWFNSzIbLrUYSZ/2DH0Wk7q8dTEeFnEg+Lm9pLxcZSMosiHYcY0vZ90/13pUbBt/O6Gg0Af83bLN/pdndjXPgU1kB1Tzb0tooBRpemr+LfHuqbyBU0tpWF3XUqYx2M+zrcPk2EBsQksCq5JWROC6D9J4px/4pHZc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A capture kernel reads the memory of the crashed kernel, and that memory
may well have uncorrectable errors. On powerpc a machine check in the
kernel is only recovered from if the instruction that took it has an
exception table entry (cf. mce_common_process_ue()). copy_oldmem_page()
copies with copy_to_iter(). For a read() of /proc/vmcore that is a user
copy, all of whose loads have exception table entries, so the machine
check turns into a short copy and read_from_oldmem() returns -EFAULT.

But since commit 4a22fd20379c ("vmcore: convert __read_vmcore to use an
iov_iter") /proc/vmcore can be spliced too, and splice(), sendfile()
and copy_file_range() copy into kernel pages with memcpy(), which has
no exception table entries. A machine check there panics the capture
kernel. The same goes for the reads of the ELF headers and notes that
vmcore does itself.

Copy with _copy_mc_to_iter() instead. PPC64 selects ARCH_HAS_COPY_MC
and there it uses copy_mc_generic() for kernel and user destinations
alike, which has the exception table entries. Everywhere else it is
_copy_to_iter().

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 4a22fd20379c ("vmcore: convert __read_vmcore to use an iov_iter")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/crash_dump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/crash_dump.c b/arch/powerpc/kernel/crash_dump.c
index 1543917bd3e1..ca7e019ae3e9 100644
--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -83,12 +83,12 @@ ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
 
 	if (memblock_is_region_memory(paddr, csize)) {
 		vaddr = __va(paddr);
-		csize = copy_to_iter(vaddr + offset, csize, iter);
+		csize = _copy_mc_to_iter(vaddr + offset, csize, iter);
 	} else {
 		vaddr = ioremap_cache(paddr, PAGE_SIZE);
 		if (!vaddr)
 			return -ENOMEM;
-		csize = copy_to_iter(vaddr + offset, csize, iter);
+		csize = _copy_mc_to_iter(vaddr + offset, csize, iter);
 		iounmap(vaddr);
 	}
 

-- 
2.53.0


