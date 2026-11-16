Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1057D606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M57vuNNQ
Received: by kanga.kvack.org (Postfix)
	id 2D6D66B05BB; Mon, 16 Nov 2026 07:49:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2878E6B05BC; Mon, 16 Nov 2026 07:49:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F9C6B05BD; Mon, 16 Nov 2026 07:49:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E333F6B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:49:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 167BB14012A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:21 +0000 (UTC)
X-FDA: 85440962922.17.F201794
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6183240006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M57vuNNQ;
	spf=pass (imf01.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGOore0aqFXAZ06xvWyDlan0KU4yYp8rx0Edd4zUFek=;
	b=3OZnqm3qb6zZmMQKIY3bixDm5BXWOFl3aUi5FmC/gJbXHlM+XvIMxRymK+kAFv8o0ID+uz
	H1toOFXlVIFJjRLGADQErwodPNRMdEPIHKhY194c149FoInpy6PvTquCYz2TDqYQz6WfLZ
	00ulCEmdbvpeN1F39+Q+t6kUk57Vcw0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833359;
	b=kjw+9POURJtPJDbXhz9z6dWZq0Uxi3RZcfX4Q7z8ADU+9fE9zCS4wNcEhZBe22VoEv1VU4
	Oi6/O8agky4Z7YPsCWI4O4FriztIoxgfkEug7vV7xE4vM7/iVnTWJj7OQ9jV3F6FM5R2V5
	OWcX8bUWGRr0yIM6fILReGqwRjijxFk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M57vuNNQ;
	spf=pass (imf01.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB39042D94;
	Mon, 16 Nov 2026 12:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BC91F000C4;
	Mon, 16 Nov 2026 12:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833358;
	bh=QGOore0aqFXAZ06xvWyDlan0KU4yYp8rx0Edd4zUFek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M57vuNNQ+rigr2j7HQi9geTBGsIcB57FFa0DypApH0gj2koyesHw3VMj7THcgkdFA
	 4D1W1goEqGnf5Rc6WwbbRTrBiRNhy+UIYGa88FW0H6nmDOVgxemRZh2o4zK80xcvWD
	 92f6skufamAEkV47s6BXsO6Dx3hyNj9IWon9PRdgRZ4rLpXpFRfRNk/j5g646e59yh
	 xSSYROgB0xENEY9jPsz9oTev6VAeHrXa2oUzW7I0mN5vpCdVAJ72br6THAn3RNFIOC
	 GmWpVlEt6WMSzy9TupHBeO0YVLjybI/eE0HpWzsNFyPpDJoK6xEqEpEW9kvdZVy49u
	 O2vDO9SXhDxyQ==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lucas Stach <l.stach@pengutronix.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 06/10] arch/*: increase lowmem size to avoid highmem use
Date: Mon, 16 Nov 2026 13:48:28 +0100
Message-ID: <20261116124832.662455-7-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116124832.662455-1-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ofk58iwhpws3kjiy35f511wbeqwsuqed
X-Rspamd-Queue-Id: 6183240006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794833359-28560
X-HE-Meta: U2FsdGVkX1/TVyFW97LWPrXWFumwm8+QUO5yExtElkgBqwhfJ0PZt8pUaDGKxNzyFW7p0fRwttELz/w11VrNAILtGySzVS4QaAjgop0hbBSlKRDq7++FyegY6P+TKYzpcvlgePdZf05AlzL558i+Ooxiw9eKaPHauqx7/KMeqzGvBjXnqxTS4ctytWKyPuK3nO4hPYOxP5H3SkOGdst4TqicBB3w3DmyOkeE7irxnXJe7CxHjQkh+WLquNzwiA2lV0gm4LMBrPlVQIEqYwE4UJzwwa3oDaH/DK5A4/r+wWZ+0z6YtvODQAihj8envjHiCSCNDH67Skr3GRb55kfJ3om4dQG5oKEhhuX1/SjFnOUKUwGMKELv7rFfm8MqMnj3psNjpwSfpIQYpwssd67Aag4Tz1ZgBEvT//3feTxsl/AjIpED+TpWSKkXdmMhnfWKH8QeVKJwXIZutbzrSFj3SniXM2iU9QXJxUABCJeaFHOL0T9WIaoMBSjzvTttaj+jTUin8AsWAHjRMXUKpfg8gYbQFFGVWPwY/TtJQom3201WYHiS9UwNmYZ43e8wPk1Jy5vhxlxxMy4T5RSo/fuANWWhyJCwxUg9zaSfskdQooBs8766j3LzBRva+Glhi5bsN89P1ulhxgIYsfMkEtqwPO+NxhlRHb3h2Omhd7WIHQMOh2NvpJOZ2m8bkcZ/Z+1SHx+fe1zew04VJSczEKN3C85+iqFuStHoEu/am5/bS4Bixx8khnspPBwzqGJJWf6eCEdqvDjRltnBcwRzBNQ7iuljvARSHFeTTa9FAf56y9ZmURaOPdTrzYyw61GIn694deJjlyV2iFlCyqqIcTctalMUlJY+0YTqKEfBq0sssM9aXfswuOOWAsPn8LsxeYnaEZLkNiuXZ3eKE4DUurrlWoqfgYsJmqfFmrCR7Gpw9hq7z5PTgJiNXPp4Cb6AUnFTE1tVLX0wrl92m6aLjJ8
 v7W73tE/
 ylSLehrPnbuQJD0QhDJwnBeM8bGQ5AG0BEmJLlTi1b8RzDb5Y4acDpuSls/c85dEd1bkQP2VFzO25COG9YkmzFm97iv2gskHmsefXvnrILWqyECdFPp9OjS4j4I7DfcvuRNlwJ6yKAT5oYrEm92cI7szkGXYgoGEh7ycAfM4laHqd4DuEIgxcVXhVq3NtzhJilAN72vEq0dj3QUajMNfzpdxBhNRNi3apX/3nQYsqI2b2p9Zcykdwg0UZI2WEKQeCORd+j47OjP4hj3aT082mTH5+BWNcP18S2dc/BzJJ+5neWVpGrzsMd/Qdyi3F1m8f2oQG8emKMuFS53nTisV0bWXb3AL7pZs4mBm/v7CSt64XgrXT8oqZswtQLbSybBqVS5Fxaxw7KdSAuThY2qVbfpkVlT7NF+XSNycnzehhQqhcRhct5nTN//WQFfSZzWCtAIhWogxX5nkYbXw3QXojgP+fePJSRGcR1IibW1RIlXWxgxYvwP/QA6F6JVUqNT6G7yiXHu6NhVPRjV0TEi5UkWTcfA3Ldkc0/xQ2kobbpRG7uIDl2bYa/nRy26hkaDBeiYnAkFhpGlLfagW4RemkuMQqIkpFymI74g78li2AWj16elRe400BRjt410AMPajxIt6Wki+SDnJFdu4Tq2VPqAUpps8+8qsoeDmFFIMQqxfAaxSLMr6vYVnBYtUlY0Y8RTwtPCYTIvYv3j0TbgjXv3mXyw2zI/ZACebPJGUPZUEvj64uX3yXhZs3UOxU4ArISbNGenvduGk2RxOmIYaHjj64J26/0Z2qaBsoqkat8/OXeuIkXwSLh5za+zkK8kyKydvwYfPyCkBjEGiGxvYBLoR9JcJGaRbit+G4YmbSz3KL2ewJ9Ch0NcMaETkIWgyfdKPuTTrDJY64m/k5xWvfR450p56TIoQksMXzoTyNIp6yOQ0LPz4aPKtho6VLHzDsksI+yW/UX7MPbXuCtb1S7yQjMs4U
 yUuvcoD5
 B400sgLYH1kxbuLkY0nCb7hv/7Gtc4DMXWkBUyS3jK7sngjcd68W7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

Most of the common 32-bit architectures (x86, arm, powerpc) all use the
default virtual memory layout that was already in place for i386 systems
in the 1990s, using exactly 3GiB of user TASK_SIZE, with the upper 1GiB
of addresses split between (at most 896MiB) lowmem and vmalloc.

Linux-2.3 introduced CONFIG_HIGHMEM for large x86 server machines that
had 4GiB of RAM or more, with the VMSPLIT_3G/2G/1G options added in
v2.6.16 for machines that had one or two gigabytes of memory but wanted
to avoid the overhead from managing highmem. Over time, similar options
appeared on other 32-bit architectures.

Twenty years later, it makes sense to reconsider the default settings,
as the tradeoffs have changed a bit:

 - Configurations with more than 2GiB have become extremely rare,
   as any users with large memory have moved on to 64-bit systems.
   There were only ever a few Laptop models in this category: Apple
   Powerbook G4 (2005), Macbook (2006), IBM Thinkpad X60 (2006), Arm
   Chromebooks based on Exynos 5800 (2014), Tegra K1 (2014) and RK3288
   (2015), and manufacturer support for all of these has ended in 2020
   or (much) earlier.
   Embedded systems with more than 2GiB use additional SoCs of a
   similar vintage: Intel Atom Z5xx (2008), Freescale QorIQ (2008),
   Marvell Armada XP (2010), Freescale i.MX6Q (2011), LSI Axxia (2013),
   TI Keystone2 (2014), Renesas RZ/G1M (2015). Most boards based on
   these have stopped receiving kernel upgrades and later 32-bit chips
   only support smaller memory configurations, though in particular the
   i.MX6Q and Keystone2 families have expected support cycles past 2035.
   While 32-bit server installations used to support even larger memory,
   none of those seem to still be used in production on any architecture.

 - While general-purpose distributes for 32-bit targets were common,
   it was rather risky to change the CONFIG_VMSPLIT setting because
   there is always a possibility of running into device driver bugs or
   applications that need a large virtual memory size. Presumably
   a lot of these issues have been resolved now, so most setups should
   be fine using a custom vmsplit instead of highmem now.

 - As fewer users test highmem, the expectation is that it will
   increasingly break in the future, so getting users to change the
   vmsplit means that even if there is a bug to fix initially,
   it improves the situation in the long run.

 - Highmem will ultimately need to be removed, at least for the page
   cache and most other code using it today. In a previous discussion, I
   had suggested doing this as early as 2029, but based on the discussions
   since ELC, the plan is now to leave highmem-enabled page cache as an
   option until at least 2029, at which point remaining users will have
   the choice between no longer updating kernels or using a combination of
   a custom vmsplit and zram/zswap. Changing the defaults now should both
   speed up the highmem deprecation and make it less painful for users.

 - The most VM space intensive applications tend to be web browsers,
   specifcally Chrome/ChromeOS and Firefox. Both have now stopped
   providing binary updates.
   Testing various combinations on Debian/armhf, I found that Firefox 140
   can still show complex websites with VMSPLIT_2G_OPT with and without
   HIGHMEM, though it failed for me both with the small address space
   of VMSPLIT_1G and the small lowmem of VMSPLIT_3G_OPT when HIGHMEM
   is disabled.
   This is likely to get worse with future versions, so embedded users
   may still be forced to migrate to specialized browsers like WPE Webkit
   when HIGHMEM pagecache is finally removed.

Based on the above observations and the discussion at the kernel summit,
change the defaults to the most appropriate values: use 1GiB of lowmem on
non-highmem configurations, and either 2GiB or 1.75GiB of lowmem on highmem
builds, depending on what is available on the architecture.  As ARM_LPAE
and X86_PAE builds both require a gigabyte-aligned vmsplit, those get
to use VMSPLIT_2G. The result is that the majority of previous highmem
users now only need lowmem. For platform specific defconfig files that
are known to only support up to 1GiB of RAM, drop the CONFIG_HIGHMEM line
as well as a simplification.

On PowerPC and Microblaze, the options have somewhat different names but
should have the same effect. MIPS and Xtensa cannot support a larger
than 512MB of lowmem but are limited to small DDR2 memory in most
implementations, with MT7621 being a notable exception. ARC and C-Sky
could support a configurable vmsplit in theory, but it's not clear
if anyone still cares.
SPARC is currently limited to 192MB of lowmem and should get patched
to behave either like arm/x86 or powerpc/microblaze to support 2GiB
of lowmem.

There are likely going to be regressions from the changed defaults,
in particular when hitting previously hidden device driver bugs
that fail to set the correct DMA mask, or from applications that
need a large virtual address space.
Ideally the in-kernel problems should all be fixable, but as a fallback,
the previous behavior is still selectable based on CONFIG_EXPERT=y.

Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Michal Simek <monstr@monstr.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org
Cc: Richard Weinberger <richard@nod.at>
Cc: Linus Walleij <linusw@kernel.org>
Cc: Nishanth Menon <nm@ti.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig                            |  6 +++++-
 arch/arm/configs/u8500_defconfig            |  1 -
 arch/arm/configs/vt8500_v6_v7_defconfig     |  1 -
 arch/microblaze/Kconfig                     |  9 +++++---
 arch/microblaze/configs/mmu_defconfig       |  1 -
 arch/powerpc/Kconfig                        | 24 +++++++++++++--------
 arch/powerpc/configs/44x/akebono_defconfig  |  1 -
 arch/powerpc/configs/85xx/ksi8560_defconfig |  1 -
 arch/powerpc/configs/85xx/stx_gp3_defconfig |  1 -
 arch/x86/Kconfig                            |  4 +++-
 10 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 270ae2b89407..e79becfa9e90 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1025,7 +1025,9 @@ config BL_SWITCHER_DUMMY_IF
 choice
 	prompt "Memory split"
 	depends on MMU
-	default VMSPLIT_3G
+	default VMSPLIT_2G if ARM_LPAE
+	default VMSPLIT_2G_OPT if HIGHMEM
+	default VMSPLIT_3G_OPT
 	help
 	  Select the desired split between kernel and user memory.
 
@@ -1034,8 +1036,10 @@ choice
 
 	config VMSPLIT_3G
 		bool "3G/1G user/kernel split"
+		depends on !HIGHMEM || EXPERT
 	config VMSPLIT_3G_OPT
 		depends on !ARM_LPAE
+		depends on !HIGHMEM || EXPERT
 		bool "3G/1G user/kernel split (for full 1G low memory)"
 	config VMSPLIT_2G
 		bool "2G/2G user/kernel split"
diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 2fe25f5eb9a5..b284c2c31758 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -6,7 +6,6 @@ CONFIG_KALLSYMS_ALL=y
 CONFIG_ARCH_U8500=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_HIGHMEM=y
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_CMDLINE="root=/dev/ram0 console=ttyAMA2,115200n8"
diff --git a/arch/arm/configs/vt8500_v6_v7_defconfig b/arch/arm/configs/vt8500_v6_v7_defconfig
index 33a81c5a84d0..1f6dca21d569 100644
--- a/arch/arm/configs/vt8500_v6_v7_defconfig
+++ b/arch/arm/configs/vt8500_v6_v7_defconfig
@@ -8,7 +8,6 @@ CONFIG_ARM_ERRATA_720789=y
 CONFIG_ARM_ERRATA_754322=y
 CONFIG_ARM_ERRATA_775420=y
 CONFIG_HAVE_ARM_ARCH_TIMER=y
-CONFIG_HIGHMEM=y
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_VFP=y
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 9063a91cfb41..8ce8d108bfd7 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -164,7 +164,8 @@ config LOWMEM_SIZE_BOOL
 
 config LOWMEM_SIZE
 	hex "Maximum low memory size (in bytes)" if LOWMEM_SIZE_BOOL
-	default "0x30000000"
+	default "0x80000000" if HIGHMEM
+	default "0x40000000"
 
 config MANUAL_RESET_VECTOR
 	hex "Microblaze reset vector address setup"
@@ -190,7 +191,8 @@ config KERNEL_START_BOOL
 
 config KERNEL_START
 	hex "Virtual address of kernel base" if KERNEL_START_BOOL
-	default "0xc0000000"
+	default "0x70000000" if HIGHMEM
+	default "0xb0000000"
 
 config TASK_SIZE_BOOL
 	bool "Set custom user task size"
@@ -204,7 +206,8 @@ config TASK_SIZE_BOOL
 
 config TASK_SIZE
 	hex "Size of user task space" if TASK_SIZE_BOOL
-	default "0x80000000"
+	default "0x70000000" if HIGHMEM
+	default "0xb0000000"
 
 config MB_MANAGER
 	bool "Support for Microblaze Manager"
diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/configs/mmu_defconfig
index 7f9b19d0d9db..19a13d3ece5c 100644
--- a/arch/microblaze/configs/mmu_defconfig
+++ b/arch/microblaze/configs/mmu_defconfig
@@ -15,7 +15,6 @@ CONFIG_XILINX_MICROBLAZE0_USE_FPU=2
 CONFIG_HZ_100=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE_FORCE=y
-CONFIG_HIGHMEM=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_PARTITION_ADVANCED=y
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c3b6cd655606..1eef831faf3a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -489,6 +489,7 @@ menu "Kernel options"
 config HIGHMEM
 	bool "High memory support"
 	depends on PPC32
+	depends on PPC_BOOK3S_32 || PPC_85xx || 44x
 	select KMAP_LOCAL
 
 source "kernel/Kconfig.hz"
@@ -1190,7 +1191,10 @@ config LOWMEM_SIZE_BOOL
 
 config LOWMEM_SIZE
 	hex "Maximum low memory size (in bytes)" if LOWMEM_SIZE_BOOL
-	default "0x30000000"
+	default "0x40000000" if 44x
+	default "0x70000000" if HIGHMEM && KASAN
+	default "0x80000000" if HIGHMEM
+	default "0x40000000"
 
 config LOWMEM_CAM_NUM_BOOL
 	bool "Set number of CAMs to use to map low memory"
@@ -1207,10 +1211,10 @@ config LOWMEM_CAM_NUM_BOOL
 config LOWMEM_CAM_NUM
 	depends on PPC_85xx
 	int "Number of CAMs to use to map low memory" if LOWMEM_CAM_NUM_BOOL
-	default 3 if !STRICT_KERNEL_RWX
-	default 9 if DATA_SHIFT >= 24
-	default 12 if DATA_SHIFT >= 22
-	default 15
+	default 8 if !STRICT_KERNEL_RWX
+	default 14 if DATA_SHIFT >= 24
+	default 17 if DATA_SHIFT >= 22
+	default 20
 
 config DYNAMIC_MEMSTART
 	bool "Enable page aligned dynamic load address for kernel"
@@ -1242,7 +1246,8 @@ config PAGE_OFFSET_BOOL
 
 config PAGE_OFFSET
 	hex "Virtual address of memory base" if PAGE_OFFSET_BOOL
-	default "0xc0000000"
+	default "0x70000000" if HIGHMEM && !44x
+	default "0xb0000000"
 
 config KERNEL_START_BOOL
 	bool "Set custom kernel base address"
@@ -1258,8 +1263,9 @@ config KERNEL_START_BOOL
 config KERNEL_START
 	hex "Virtual address of kernel base" if KERNEL_START_BOOL
 	default PAGE_OFFSET if PAGE_OFFSET_BOOL
-	default "0xc2000000" if CRASH_DUMP && !NONSTATIC_KERNEL
-	default "0xc0000000"
+	default "0x72000000" if HIGHMEM && !44x && CRASH_DUMP && !NONSTATIC_KERNEL
+	default "0xb2000000" if CRASH_DUMP && !NONSTATIC_KERNEL
+	default PAGE_OFFSET
 
 config PHYSICAL_START_BOOL
 	bool "Set physical address where the kernel is loaded"
@@ -1295,7 +1301,7 @@ config TASK_SIZE_BOOL
 config TASK_SIZE
 	hex "Size of maximum user task space" if TASK_SIZE_BOOL
 	default "0x80000000" if PPC_8xx
-	default "0xc0000000"
+	default PAGE_OFFSET
 
 config MODULES_SIZE_BOOL
 	bool "Set custom size for modules/execmem area"
diff --git a/arch/powerpc/configs/44x/akebono_defconfig b/arch/powerpc/configs/44x/akebono_defconfig
index bdb0e6ece6ec..cc1e3da5f8f5 100644
--- a/arch/powerpc/configs/44x/akebono_defconfig
+++ b/arch/powerpc/configs/44x/akebono_defconfig
@@ -14,7 +14,6 @@ CONFIG_MODULE_UNLOAD=y
 CONFIG_PPC_47x=y
 # CONFIG_EBONY is not set
 CONFIG_AKEBONO=y
-CONFIG_HIGHMEM=y
 CONFIG_HZ_100=y
 CONFIG_IRQ_ALL_CPUS=y
 # CONFIG_COMPACTION is not set
diff --git a/arch/powerpc/configs/85xx/ksi8560_defconfig b/arch/powerpc/configs/85xx/ksi8560_defconfig
index 9cb211fb6d1e..f2ac1fc41303 100644
--- a/arch/powerpc/configs/85xx/ksi8560_defconfig
+++ b/arch/powerpc/configs/85xx/ksi8560_defconfig
@@ -9,7 +9,6 @@ CONFIG_PARTITION_ADVANCED=y
 CONFIG_KSI8560=y
 CONFIG_CPM2=y
 CONFIG_GEN_RTC=y
-CONFIG_HIGHMEM=y
 CONFIG_BINFMT_MISC=y
 CONFIG_MATH_EMULATION=y
 # CONFIG_SECCOMP is not set
diff --git a/arch/powerpc/configs/85xx/stx_gp3_defconfig b/arch/powerpc/configs/85xx/stx_gp3_defconfig
index 0a42072fa23c..1033977711d6 100644
--- a/arch/powerpc/configs/85xx/stx_gp3_defconfig
+++ b/arch/powerpc/configs/85xx/stx_gp3_defconfig
@@ -7,7 +7,6 @@ CONFIG_MODULES=y
 CONFIG_MODVERSIONS=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_STX_GP3=y
-CONFIG_HIGHMEM=y
 CONFIG_BINFMT_MISC=m
 CONFIG_MATH_EMULATION=y
 CONFIG_PCI=y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58dce0b66179..18b3eeebb7ce 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1410,7 +1410,9 @@ config HIGHMEM4G
 
 choice
 	prompt "Memory split" if EXPERT
-	default VMSPLIT_3G
+	default VMSPLIT_2G_OPT if HIGHMEM && !X86_PAE
+	default VMSPLIT_2G if X86_PAE
+	default VMSPLIT_3G_OPT
 	depends on X86_32
 	help
 	  Select the desired split between kernel and user memory.
-- 
2.53.0


