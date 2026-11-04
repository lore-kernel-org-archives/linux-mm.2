Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97DC4606F6A8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dr8wSvAV
Received: by kanga.kvack.org (Postfix)
	id AF34E6B05DD; Wed,  4 Nov 2026 12:56:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB106B05DE; Wed,  4 Nov 2026 12:56:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9DE6B05DF; Wed,  4 Nov 2026 12:56:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7CECF6B05DD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:56:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05325120785
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:56:45 +0000 (UTC)
X-FDA: 85398192012.05.AA1879F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 21CE0160005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:56:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dr8wSvAV;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793815004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5t8qKNo68SCWoforDimF8hL2ZYL+p0Okj8bWoZ1JT0=;
	b=Ilvu+lirnJNPVH28MJfF4twnhNStXWZCL/ntnzfQpET6+Ml2ETGbIgH7LjyJVSNqyoSV+K
	Cb5MmYEMaNHDgnr1gxCckGXJWABiep+mztZIfcc/wJSIZm9ouTSDZZu1VrA3mcOiet1JDI
	3N/27G2QFb+x/H1OX+CY+gaMi8k2efQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793815004;
	b=wMW9X99peKnJBWZU7Ts6/x+47ZM8Xc5CvZIc7CYUoNzd6PszMxOAL9watefq84FdjMZGKc
	F3Twp2nKpVxLa+K5XWy00PYioa3Lwu/ZaPr4aoeLg6EFZvNymB5uSjiKcfOYh50gSFDLcB
	N9A3Ftz29Qyi4GdF9/BR3HV1xR7tz2Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dr8wSvAV;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 688A343313;
	Wed,  4 Nov 2026 17:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33CA1F00919;
	Wed,  4 Nov 2026 17:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793815003;
	bh=v5t8qKNo68SCWoforDimF8hL2ZYL+p0Okj8bWoZ1JT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dr8wSvAVbxP/ZcIFTBwPH9dzXvhuBn9mA9nVh+Xgz7CJcVvdC39CZkNme4AyXP6YJ
	 FWGyi7uuOUICVXiiTT/mIG9BdyZemGP4/ngMXLnrprJvuOVJflcC9gK/hPD0oGCWag
	 aT5p1c3BKTvIpwJq4lWpELTuhZe/zgt3mUlYbqxRoekrxsz67uxzSSFqG5FXwM9E/o
	 G1ugeyanFn0rXRDRijLJnbwzKap1acFDZxxJu4ignABfVoZxvW4pCLBHKwBhqj5cvl
	 DjsJARsAA6SkUoD00o6dTzmSQNCeteiSTEpImZSPqwk0YU1IwQ0d1qUYo0SM+byxVD
	 zCyAfk3cQXcsg==
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
Subject: [PATCH v2 38/51] powerpc/crash_dump: check ioremap_cache() in copy_oldmem_page()
Date: Wed,  4 Nov 2026 18:47:24 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-38-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1312; i=brauner@kernel.org; h=from:subject:message-id; bh=2dbZnDPFapx3dAW5qeN54CL6hHWBvjsrs28L3h6tsIk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9znt7V9L6ks/CitImMTaFT/P3tq0qmfiJVas86t5hC 6GvD3+pdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkXpbhf8Xs/zMjY/xX/2qd /0Cs7fedC69yp7xLetqeaik/5Q+3dQEjw6/vcxdp8XXWMTbHvTmdmR79flXw2aaoGkbuF4vOPfZ YwQ0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 21CE0160005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: iojiexso8bohbogathdx19iwtt6apbw9
X-Rspam-User: 
X-HE-Tag: 1793815003-250129
X-HE-Meta: U2FsdGVkX19Tm2gUg0rFAv8GEwb1N/RKJRB/zaBb96RDFbhq2Dsq/kbcKaVl2nfmdk4FWeOF6haGy8wYbb5FFBUUCjaYAgffqxN4hQ/ci3VrRwLaRSPS/Yemk4/V+C9VBUyFk+x/u4McEZhg6OZ1zaFtH7wvcViVOYMly5g9vLGh+01JOLUeg2JaNkwTf0bsYMh6me6pJuejLf557PwYP66SJ2A7IXkmyWB5SNu/fyIhqOs6901gvYPjZRnlYIeCVFxXGnRvaAXxFq8zY9yNZwj2PvHz7emDi7qP0efKKjaZhtjaNl2g+ByzEy+Jx0UIm1PkU6r/tMSZLbilKm68JBL6RhB407PGzhvRNmxgRbr2EuRkVQO01YmdkEnbhGMBcMZpma0+KJXXr6zGHOMJU28wme4BGdJ/nLcAYRUg4Rgs/EVIFiCq6CKzYKmZMacCEsrqWbJ6VRluvGh87oty/FbEMIv5VErd2N1NnfZdh5o9wNSEJsBGTUr/iYf8jikOHLb9vT48k6JmQPeBFGRlny8JSKS61XPXqBoVOmPZcKik50LJlp3c+x7Xtke9HjoPL+k6d8CVXvOjIBpaD0gBbUomB3q+n8Lj8TAxAl8rYazh7HQDQc8sps1aSqO0U9wEtfwPfXLCeIt0tfAXr1iKp2eJ82u4t7kGsUk6R3UXsE5n6CvJIlu4aiyBg52V+jmLjuGdstyK8HwkAaOJ6MRj+KTRw0WYy3QNbnMEPQs4UHSoBHoEG1fsRIHu9lyY2mmDVzWQeZEfn84wtnayVpve7rPYTV4hHDnxb3gWQ3hGJuHM2rNkZc1ymNUORsr6DMMWA/Iw5GvEUsLzLkCFHHG8LsyHOUQDMVzW56hpbFILWedqc2APmlChR5bKoPUVRAMCfatAdH82aPPlqJtnUMLbbk1rzoj4lb4xqY7mXexKcMEbqwiXXsOzxEFVqwQLazH1hObDxtMPyI1uZqotVYK
 lL2Yzc62
 tGPQRZMR36fZCLnnvbrc65s/64GG0giVNlto3HxWyXWAjdHckqWPrABd+Vm3ChKHaYbdyakhP2b80KkTBpqrdZ4IZW+Ylsn1mB+YaSW0lKKKsr04TVvPdif8qsenEP9huL76x2hYbJo7AUb9wCsISe7b0VF/MeKf/UfeVbBfnYzA+4l3eKiJ/Syq+sCOoYWVPcLMoUjqSm+PkrQGkSbj4uF0Yefj5/kEmRomzVJfb6HunRzyPuPF74lfI09FqFKRsf54tWsPQAxW6xRlP3GOYiAy3iDW9sDUaLTbAzzqYBMqP370mYZby9XwKRI8cZ+XN4walNrtaNyJaYFNap8xossH6lsrbYne5oy6V23SPafqMIRwVrbxQ5cFrfFtxwB1HEF3f8Th3I7joiRRf5cXJzH1mcb2pPQBQO+qNB05bMqdaalpA31rxzMy4SkbueXNo7Dfv
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


