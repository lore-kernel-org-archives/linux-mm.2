Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB7D606A330
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hdJNDh6O
Received: by kanga.kvack.org (Postfix)
	id C10286B05CA; Wed,  4 Nov 2026 14:25:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE79C6B05CB; Wed,  4 Nov 2026 14:25:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00246B05CF; Wed,  4 Nov 2026 14:25:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9386B05CA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:25:49 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 288D680846
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:25:49 +0000 (UTC)
X-FDA: 85398416418.29.12D4217
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6DF0BC0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:25:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdJNDh6O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeQgphPdxdiWtw36JzKqWooMSgzPZU+EeD4NlyLVhDM=;
	b=FZNlQW/HpOq8O28d0y7jM/rhDEFFkdFv1nFMbGSTv3JgANGUZPyEKifN/cq3Ur0XZgw5Xi
	sJ1c7K4XZJSTQPZ7gkppw8rZDYP8Ad9uHsu1vSQEQUYLPzNwsax99ZhvvtSaOharbwVfcw
	hkdWN5h3h3XyZMaEO+dOT7XE5dc428I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820347;
	b=Ol+ZqElj7JlQGCgOXyYc0tW1iok2fUaUjskVg4lXyVV+RxJRzfwStjVFONpOgMqqfMsfZF
	eIHzh6bZus3IqVt3KW6ar/AT5f04y5wc3vwloLr3RPoZr1t9YnEB6fHjlU/GAza20ewhwE
	hIEbCCksi8vwMkosyKRvXVWJNht3Sq8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdJNDh6O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01C3560DA3;
	Wed,  4 Nov 2026 19:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752A91F00A18;
	Wed,  4 Nov 2026 19:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820346;
	bh=qeQgphPdxdiWtw36JzKqWooMSgzPZU+EeD4NlyLVhDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdJNDh6OaAui4lay7OJSmMgInc6T7e+u7rQGOiRGT5ecgJvEKZTk+bvy31gj25xp5
	 EMlVcNskaOB166UEuHcs9M+Arv+SuzxXQANcu/UbyUjMc0+sWDzpbdt76bmGDk4jwv
	 dzXVAXuyKiSVZ4ea/xwRNPPO1mVA9tLUIKS+h63z+xkJopkB5HFxrzEYzXBr5K3/DV
	 4tqBQSe+LfkRA0E4BHcJdz2FUN/7x+h1XEREGcZZ7zmxMVbUH/gH7DuyHZmLjtDcQc
	 J1yVCFHrELmM7UJtS3ngB8pEivcyFDbp7nlx9CIfgNwUk9+JqlDkEZunCVDa84Tte0
	 905iHrsfzrTdg==
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
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2 39/51] powerpc/crash_dump: recover from a machine check in copy_oldmem_page()
Date: Wed,  4 Nov 2026 20:25:32 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-39-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2421; i=brauner@kernel.org; h=from:subject:message-id; bh=VIVKq8y+KdCJwnDd/z4L2OCrr1yqDfObdGoCOSjiCdM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bvzdev5O1pqOqInnVq7QehNleaUr+ZQXg2RwxdMDB mu8jeRsO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACby8zTDH46/Ovo1n1rt927Z GbOo3ko0bH+/ELda9QrWhpqiI0sd7zD8Fbm2sNi91NhmUkJA6g2DG31172P/sXlZMGhOKDWf+aC ZDQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: txdae83uctbwkt6x5jhktymrhu16ocxe
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DF0BC0005
X-HE-Tag: 1793820347-46422
X-HE-Meta: U2FsdGVkX18npSatxgz5lVWpvm6b+syGnpMpmSWgFmv6zidLPz954aDoxul1+mv82IP1nHcEYtrfEh/gYAnReoNr8yWtSJYlPnbm69uN/6JbfaDSnsnqX4oSY7dkziT7tEQYzAHgJgzKxhtWCMJBYwkhzucbxrG/myoo0emx9gaG2VUI68mClpy3ucEMBn9E0R22d7mKeBwYGEc6mF4jKFL8TrmVEzdWyKWec+Snzgno985M0NwsHKSYAfVsQ8J0V/YfJdNUmAHrJUoCAYmoT37aIo/+slwvLsS2kxjtRbV/UwaznyZAjblYxlyPu9dQRCpK8ZxFUc8mEicXIFSgI09LRsDI+JiGH2yr6kbiK1xppTt+vJuEnxEZZghNQNyMDC2XEz3Ta9YeEMPALjl04eLCNxh7wrAJ3INtaJYGn7G2ejqhz6prUgO8+Vgje6X80lYU9PLMZMdG3MSZMdXwhvPwCAF01aQ6QzuFoy0wri7lftn9Dt1WqmXXQwBwu9eJ6dPUxwYxmmlILtLkBDb+NbCo5nsOQXGwN4DpPTlu3PokzUmeECEVd6JPoYiGNBj/U4/UXHD8M8QVh/OGdh97Ux41ttx/P6V260CJCIDKM7BdbvQK/BKu67SZITaq7Bx23yEDIQ6AqlGHJwNNXsyA2fn8ArUxGL1GPwJ3kJ0n1TBZY1xt8pcMEIUS5zgiUTxJ7Azf5SRCO5Otwm8DAMC+jLYxUgUY+g2wrkf2eoU/rFZGMxnnotCSd6gakh/+r0kH9mCv95TPCvsLEsNhyKfOFgz/jaOzV+Y9WBrbve8UNxDu9ZenA5Czg8T3bJqZDujiFmdKpo4aQgWbm2hWvmsAD1HzpShDux7v2OcgQC6+bTNzZk6Al06uzghB+R1r8Y/h+195OrtUWx+Ehw69fQBhe7ExsgnmWdKYPYmpX1OHj0lbipUEqu88xARldt7+VtO53yDmHc72sKGn61n+o1a
 oVpoE0xb
 WO1ouq1y79zaB70ly46GqbUqRZn8DsP64jUSk3jh9DnwIx41VU70KQlewOyHv0QM/0W+vA3v1spiQ89NTsN3mQB52IFv11Wiv4awR99MhlWDc0TERivjwr/aHD0PV+Q9PK6d6pqdhJWq8CxHhSsN4oe6xWSou2Cguvhxf2cJEp4EOW8nwktR4Y9PgBS2ZFk/O5rNOHLgiH0BQQxSt9KR/llu0JTOXO9T1SuGUPRmz8Bl1TopoeEPWjQaALgo4htfyobUMzWjn6fDC8iaTk6V1cD52bjMlRetWndx6wwJRXujUGm5vpeLRTpipSlTI5PHtM44ptg4uZKMRGABZrzxnH9OiRBdEgRGeC/XvTxyMbgi9OM3xFFn3EO4iiy5QFtIbkpGLuhxUCpamZBWZaKu/eX8G/1f41o+H0YBKN0xP4bSPbfeACGN6lRSePhvTdM4g+IB/W7gKlpI/uFk=
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
vmcore does itself, and those have been memcpy() for as long as
copy_oldmem_page() has had its kernel buffer branch, since commit
54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_page").

Copy with _copy_mc_to_iter() instead. PPC64 selects ARCH_HAS_COPY_MC
and there it uses copy_mc_generic() for kernel and user destinations
alike, which has the exception table entries. Everywhere else it is
_copy_to_iter().

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 54c32021eb6f ("[PATCH] powerpc: Add arch-dependent copy_oldmem_page")
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


