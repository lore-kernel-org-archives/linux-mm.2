Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62523F4484C
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE27E6B009F; Fri, 10 Apr 2026 08:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92D66B00A0; Fri, 10 Apr 2026 08:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82666B00A1; Fri, 10 Apr 2026 08:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3AE86B009F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 433598BC13
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:13 +0000 (UTC)
X-FDA: 84642550986.09.AE460C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BBAF11C000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YwhpP/sf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=hS8C4KqVeUlIUjtSj7w2Upw8HyApf1Pu0cIqAYxRChU=;
	b=uJRL4hmt0k0T3bS83qnxtRrQneh51OXza2xMTgJMHtFVm3Gak/ZEjiibeZI/CA9RA0RxHi
	fkty3o6653Rlxm0EoJ/IqApILQ9IQuO1piuDtIf9rqYzmAxvMgmv9dSp7UvJMX5fMmqwVn
	Qqw05ONgi80DFNnU9PeTl3Q/cHCBwgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823551; a=rsa-sha256;
	cv=none;
	b=rM83bmVaYljvac0VIG89pSFAZWWW0Qv6rF9q/B9CphVjpKV1sddGxX47zxTH92I9GikIeW
	RGZhnqebHDs4Cd8K772QmNzysCA0gfAyeX2Meji0dHFKliFeyscLz6VyuZFgVcXM37FBgo
	FV4Y79fagfDqNSsBYae+zO9z8dq6eBQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YwhpP/sf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32D916024D;
	Fri, 10 Apr 2026 12:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455B0C2BC87;
	Fri, 10 Apr 2026 12:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823550;
	bh=bea3byi4f+lJwA9RE9L4RIIWG0LfPmc09XAUdHtlAlE=;
	h=Date:From:To:Subject:References:cc:From;
	b=YwhpP/sfl2uNAokHMGyDzPyXqsYG5Z3HHapkhzwVASiSkGSv1ImeSFBY018VYZGU6
	 EPRk8H/tD4bE94DCGFfik82fydH/mvkzeKH2zcGHFzmiPQlK2yTJNXmBvp6CR6/aKP
	 ZUXJ1ridIfNl+octSklnUsCiAFVq0bMAbDZHArZ2XlGiEpILEnKNdARJlXe1YoLGU7
	 gTGiAjrmuKfAH7Stm5YSWpKnJ3J0WABG0fiD/+Dm/7aJCfY6aDBkC0dcXhqkELemEA
	 OLCKD9b/UmnIij2UMaT5laELpK9/RUq1POEHXDOcdk6mujQiavRoj/L2U3OHpVV16q
	 LiEll066ex31A==
Date: Fri, 10 Apr 2026 14:19:08 +0200
Message-ID: <20260410120318.121043259@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 08/38] x86/tsc: Use rdtsc() instead of get_cycles()
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
cc: Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
X-Rspamd-Queue-Id: BBAF11C000A
X-Stat-Signature: ocgpe5cd996mygzcy8ur9hjd88mfnfj7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775823551-40472
X-HE-Meta: U2FsdGVkX1/DlSPx+NG0lvZc5xAJwj3GqYn+2y+Jw5+EXTfiB7N/shRAyqG3M62nOEdS8roSOxDD31pjfJAtuR5VLiFwCDUNT8s9Nmu5Hl29bs+Y1Ztk3tC+0Yp7XpTTVlUsHSohtqEY6xwQmUUBIpZ61WT0A2OZNPuTX484rMZ4vIbscYRLvTjdQuK2HqdQ2cOvD7XNWqR02dqKnNWuJxF3X0ZpNN3bzlMMSYU4+MhkP/+ajfbIu9sr9rEAJSNml8m3EoUeq0V/TkfHoJpPaU1FHHSy7yjImdTcdxp4yu7tuHCrViA8Mobz5/FK0o9CmLf9Kw7AnqSHVNaJwvS8Un7Gfv1aIgIRNHJhThwpNpQzA4LZ+gcwYxA7khUo8bxSjZ2lmO0NLcGCNZsTYlF4PQB1/O4V/09FXQxKuG0sIIuhi7Tcgcl9M5QP8nG6tkEfzzqHxMToui+7QWdVWuqUeFovZPGyaW9j9gXYQ3EqnnJJADXY6aUjT0eHGn1LOV2zkXXwrZhmhbCB4k9n6wq0GKxUV5HkPQGkk3fLBCXkPWj/Np4MYnusNefdD+Hdiz+jm8NSR5vf3xT1dFCwHyIGQKMn6rUkkvd1AbV0XN1eQYIhMMqENAU7eS1ZpEvVj/xmrlBnL6Ppn3fMDLpAWx57Y1QQ2gqWhLd6M3VzmN+tb2Ha2eN/a/06QRvrWT0K2AcaOgVb4pBPJfxzz6RZugmvz6V5ynNzsCxTPuOki/GmIDQUaweWMtitqzziEAkESs3cQqPjnHbcIRgArC6g2wQoiAQJcZVNik76P45vP0M4ehu9oAeaHkYjumJtcdWc6I2eabeJ8MGCcVvRKL2xE7TZyzfLLFcIskoXOnIGzsPaitwvBsU9M/GmfAGvCWOKjbUb+qFBTVVdnOIEt0cpdwB20POFD6nxe51D0kp8eluH45xLB0FqXr1xv2uxPuMGcTMsK4sHZJ2gJGbV26cNNKl
 70hhorrl
 ZriT/I3/K1uzURdWX45mkln0qJa73n+Uc9UIvWmtRYbRh/BWB6fjMwa2/k/5qDlQEn+2OR+dzrLcXqoUKo8LGiE1zI0CPL5IAhFCoCfcpTxs/waD1lN3omciOihP2eZ9mU43J/ho0u4jjmIzCFq6lEI8mn3fY8BiTsx3EZme6qj/xv4efXMpj30ZTt0HxYNOmlabqPvd5WaUwBleIA/Zi9k0oUFZVPP6qaV8rQwyvB/6s+PPFl2FSx0xCGxusqdnG6enB9YmaYNzVgiGjRXy2rveBrJ9HoE4YWOO74ISV5iIaLswq+Y601mZs8oHGRuqccINTbUFt7v0DWAEQPMVZw/kuq3h5uTOitAHZORH8bk1qtIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This code knows that TSC is available so there is no point to use the TSC
feature guarded get_cycles().

No functional change.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
 arch/x86/kernel/tsc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -371,12 +371,12 @@ static u64 tsc_read_refs(u64 *p, int hpe
 	int i;
 
 	for (i = 0; i < MAX_RETRIES; i++) {
-		t1 = get_cycles();
+		t1 = rdtsc();
 		if (hpet)
 			*p = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
 		else
 			*p = acpi_pm_read_early();
-		t2 = get_cycles();
+		t2 = rdtsc();
 		if ((t2 - t1) < thresh)
 			return t2;
 	}
@@ -468,13 +468,13 @@ static unsigned long pit_calibrate_tsc(u
 	outb(latch & 0xff, 0x42);
 	outb(latch >> 8, 0x42);
 
-	tsc = t1 = t2 = get_cycles();
+	tsc = t1 = t2 = rdtsc();
 
 	pitcnt = 0;
 	tscmax = 0;
 	tscmin = ULONG_MAX;
 	while ((inb(0x61) & 0x20) == 0) {
-		t2 = get_cycles();
+		t2 = rdtsc();
 		delta = t2 - tsc;
 		tsc = t2;
 		if ((unsigned long) delta < tscmin)
@@ -553,9 +553,9 @@ static inline int pit_expect_msb(unsigne
 		if (!pit_verify_msb(val))
 			break;
 		prev_tsc = tsc;
-		tsc = get_cycles();
+		tsc = rdtsc();
 	}
-	*deltap = get_cycles() - prev_tsc;
+	*deltap = rdtsc() - prev_tsc;
 	*tscp = tsc;
 
 	/*


