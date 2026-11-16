Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9527F606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gpjC7PZJ
Received: by kanga.kvack.org (Postfix)
	id B15876B05B9; Mon, 16 Nov 2026 07:49:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76216B05BA; Mon, 16 Nov 2026 07:49:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9658B6B05BB; Mon, 16 Nov 2026 07:49:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75F736B05B9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:49:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C18DA031D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:14 +0000 (UTC)
X-FDA: 85440962628.27.6691DF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5A5BC40004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gpjC7PZJ;
	spf=pass (imf07.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqMiao7IUsYqKs54ICvEuqwO8zDV+6ATbJVBuhC4jzs=;
	b=2XN0fOvVAS/X8VvdKfYNpX9RGnjuMpM+HBo6LZ0zBf9TxjurQMH7y2qKXObUG3Tzuv/e9+
	8f6gTsa7bxXs/sSUEYBonuqRwW5kGDyRZ4NDi77cuPf0zOUcKVHmyBzMxTiqWpGgiM+/S4
	L1cnJmwdMaSsSYUwyU8zXFdgBpD8cFw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833352;
	b=HSdDEmcJCMJWXXe1cdBKG3tCy/DLBgX1lAAGux/Ig8e8XvpB4PnljIEuF206xK17u3rrso
	gIqVL8bJKIwVCANNB/bw7FsdNZ3XPiZqO06rZU+Bmd29QflWRaNRfQXrXgISGC0tzo9VpU
	t3uw2r3X3apY8bQFi5O+Sjpub++c6T8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gpjC7PZJ;
	spf=pass (imf07.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB4E6612ED;
	Mon, 16 Nov 2026 12:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292C31F000C5;
	Mon, 16 Nov 2026 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833351;
	bh=yqMiao7IUsYqKs54ICvEuqwO8zDV+6ATbJVBuhC4jzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpjC7PZJmXae3Ug6YBRcR+8bfcqu4PinQAZYVOw+KwcZk6WxhZD4lN24ddrIomqNG
	 Tjc7iRfpoEVYgnl2OjTRIDVmKZYCzKQYV4Xkj263XiW4qgji+556X1K0E+4G//fyn/
	 i1HzLH6xsPRXu/fCpishNMA/oZUalIKcIOocxcogWC/je5O4ts9z97s/t6sw2F+N9R
	 4Euy1GQaelLkbtRVa05un7cyZynZsXxkTqTSnvzvbZE0hIUN5oy/ekJ6RyfbXl+zPx
	 z8Vx7uVvTxw3/gInPP+Kn5cYLwYfOUuXpks2xvFUidQy15WoNQKtH2MtWImunv6Cw9
	 zU6NBp8N1IOtw==
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
	x86@kernel.org
Subject: [PATCH v3 05/10] ARM: add CONFIG_VMSPLIT_2G_OPT option
Date: Mon, 16 Nov 2026 13:48:27 +0100
Message-ID: <20261116124832.662455-6-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116124832.662455-1-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5A5BC40004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ktqi5aunfjtoo4eezr45ckxmzfwkocmz
X-Rspam-User: 
X-HE-Tag: 1794833352-626820
X-HE-Meta: U2FsdGVkX1+KB3N9djhpe6BSsZeaSZPA+6BZAczRqcZmt/+drdG0y9ejK7NJuJy0nCKGr+TLovmO014z3bx98wYNVAVOEGe9jWEnIuFvmmLPzWyDd1w7vq9y3QJSVP7qxQMhdDGdCQYm/X9Mqr9IMSAWOwe7BwXbhqb+/+Lnq2wGPhKBQgexqFv3hDKptqkZXfCSQmDrVn7JjZAPsEsGqhMKAZCuKrV4HYZeHscXW2XwmAOVKZGAPcj6kSrGBwEzDYI6Sub4X4xPjqAd6UfV6Ns/BiTacU6QdMMzQoE8fmq5JRIi6DXzU+c48X2hR5qpux/UiZpanPNZFNYNxcpgwM2KV/uAmDfHAjScLe8ikV4bi0ZfWNNXuFs2zfe9tzcFswDE1XGZ1jtzeutFgWPMzq4bwMyn9CYMf1fUGzE8WhXszwJ9HUvRwqx0dJmxKYtMOKZ2Eoz+0z5n7YAu+DCQs9WzyyXnQwgxrdFGnRnVkADYBATNNNV+5RQHOcfDn7ff1HDWojxblW7ttTzrNuEBmqbzqyuia32rjGggObC9SQA/xmfsFwll+JU814yR1kvwInebNJmR1WcVW+46heilzmjYkGIyszgYtVIOuZkU+X2AvVyqylE+Yow0e1D/bSjS7um3yELGDY1lv9DDffRDCUIW1nH8prGKXEJPapLDmJNum7masKW9Z7itiT7B7gelW5r9ea0ZzYdUC4fYVx77FH4ruAoNaHAhk7Fc2cJYCyPIJfCcDpx3cL94kRjiZ5oT0siMDSh8c9r+2QtmD0aiKd9umE0glTZXbQOpIMSDXsS0wYjnjKl3Qssd4Er/fOVzLDf7df8hx1vqOjZCkUOOz3OqVMW/drMg64I09K4jqgScCqHRaBH/VrNU11RNCmVixQF9xBeNXuvG/1k9iH3ItdOqs10ZKRmj3H7NvnIby2/j2qwplvCFn6A/g1DErsaCP/KerXPATnme+/9yqpK
 BEKapGza
 DBIXDtg/Cn1KWBFqbA2ITF2JlhseAOY6EX6FVUygcl3wbKpdB3gj9piDJ532+6GHtoHWXq5+mL2ZnFhb7ZMthGnlXJBFjyx3IUdeR932CkTkSHuQaaSA2HHz5MOxN8HniyXDiCaBDS/ANPG7xYAmhPB+D9VFe9C9abq1UfZAZp9vIzLBpbFpPTCpMg8zLMI1HoVb8bWwkWvMW5+oJa3wIEgc+3Wu4KuK+T9nRh9hm2rH2waeQBk8XbfnKKORJiRAp459790BwijWX9AW0eXzRKjCI0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

Unlike x86 and powerpc, there is currently no option to use exactly 2GiB
of lowmem on Arm. Since 2GiB is still a relatively common configuration
on embedded systems, it makes sense to allow this to be used in
non-highmem builds.

Add the Kconfig option and make this the default for non-LPAE builds
with highmem enabled instead of CONFIG_VMSPLIT_2G.  LPAE still requires
the vmsplit to be on a gigabyte boundary, so this is only available for
classic pagetables at the moment, same as CONFIG_VMSPLIT_3G_OPT.
Keep ARCH_MMAP_RND_BITS_MAX at 15 for this.

Tested in qemu -M virt, both with and without HIGHMEM enabled.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: Change ARCH_MMAP_RND_BITS_MAX for PAGE_OFFSET=0x70000000 (Sashiko bot)
---
 arch/arm/Kconfig | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fc66d52d847e..270ae2b89407 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -333,8 +333,8 @@ config ARCH_MMAP_RND_BITS_MIN
 	default 8
 
 config ARCH_MMAP_RND_BITS_MAX
-	default 14 if PAGE_OFFSET=0x40000000
-	default 15 if PAGE_OFFSET=0x80000000
+	default 14 if PAGE_OFFSET<=0x40000000
+	default 15 if PAGE_OFFSET<=0x80000000
 	default 16
 
 config ARCH_MULTIPLATFORM
@@ -1039,6 +1039,9 @@ choice
 		bool "3G/1G user/kernel split (for full 1G low memory)"
 	config VMSPLIT_2G
 		bool "2G/2G user/kernel split"
+	config VMSPLIT_2G_OPT
+		depends on !ARM_LPAE
+		bool "2G/2G user/kernel split (for full 2G low memory)"
 	config VMSPLIT_1G
 		bool "1G/3G user/kernel split"
 endchoice
@@ -1047,6 +1050,7 @@ config PAGE_OFFSET
 	hex
 	default PHYS_OFFSET if !MMU
 	default 0x40000000 if VMSPLIT_1G
+	default 0x70000000 if VMSPLIT_2G_OPT
 	default 0x80000000 if VMSPLIT_2G
 	default 0xB0000000 if VMSPLIT_3G_OPT
 	default 0xC0000000
@@ -1055,6 +1059,7 @@ config KASAN_SHADOW_OFFSET
 	hex
 	depends on KASAN
 	default 0x1f000000 if PAGE_OFFSET=0x40000000
+	default 0x4f000000 if PAGE_OFFSET=0x70000000
 	default 0x5f000000 if PAGE_OFFSET=0x80000000
 	default 0x9f000000 if PAGE_OFFSET=0xC0000000
 	default 0x8f000000 if PAGE_OFFSET=0xB0000000
-- 
2.53.0


