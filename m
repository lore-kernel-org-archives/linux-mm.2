Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D6A6606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qgv4ByLt
Received: by kanga.kvack.org (Postfix)
	id 52C0E6B00EF; Wed, 28 Oct 2026 21:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5D36B05B1; Wed, 28 Oct 2026 21:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A78D6B05B5; Wed, 28 Oct 2026 21:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FAF36B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:29:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85185160260
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:29:09 +0000 (UTC)
X-FDA: 85373930418.19.0393A2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id B2E2F40002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:29:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qgv4ByLt;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793237347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qwyeiOdfw6vGb0L8uIG6+BGz4UgyPwLOvdoFvPupG0=;
	b=2wL9zI6yf/Y7AFb9f8HfpD+/Z3m5nTBQ5Bn4d8VO/hUTpm/ZyoiQrdf/ClQ0xUQd6GLwzV
	a7lj4IPMArpEYu3QpoBXpl6nm5zprY7j8OMbeXwixRkHplRoIctDQNVJz7lbUpzTwJRFeF
	N2pKd/jhVKzkvFxQ/BqgtoNTaE6OKlQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793237347;
	b=O+Wv+kSf+QYsGaauA635J3wot/OFteLzLnJ7yA1rJrPdDGcGl9SuwX1qUf4/XKruVwlVKP
	QhewDNG3BRMXC9jXJFaeTiS6c5/diyFYckwPL31XX3EA3VXNQq5QI5Hi9vA58gAcGpIBiM
	t4ZZ1noX9KLQapYi1YitH7IaAE+NUCA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qgv4ByLt;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 024A2600D1;
	Thu, 29 Oct 2026 01:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BF61F01825;
	Thu, 29 Oct 2026 01:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793237346;
	bh=8qwyeiOdfw6vGb0L8uIG6+BGz4UgyPwLOvdoFvPupG0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qgv4ByLtJAZquTR5cCSx5SeRbA+nAU8G5F0i3qyZkYx0ByYKUvvP97WRdju74FR7J
	 y0Q2vKypJjTmZA0gN92NrcG+ab1nrvBk7oD56b6cigPnqfoZsgf0gbNaCCPrfRSVIC
	 8D3ptcD2U9O8dmbdC/z0DsqvVqQDD40Qr5+Rbcb0=
Date: Wed, 28 Oct 2026 18:29:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Memory Management List <linux-mm@kvack.org>,
	Bradley Morgan <brads@mainlining.org>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	Cc@kvack.org:Arnd Bergmann <arnd@arndb.de>
Subject: Re: ERROR: modpost: lib/kunit/kunit-example-test.ko: symbol
 '__mulsi3' undefined!
Message-Id: <20261028182905.016f44ee406076e80c6e2f5b@linux-foundation.org>
In-Reply-To: <202610290106.o8Fs3NvO-lkp@intel.com>
References: <202610290106.o8Fs3NvO-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B2E2F40002
X-Stat-Signature: g8ycrsepebchoksjbwjzuboqrd8t8ej7
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793237347-78551
X-HE-Meta: U2FsdGVkX19lJJw+k2RU6q4cKIQo8VCE4kjZXTlOAlQ3Xh6Mgh2UaAVuUPhkuSK3iypUGaQtY+n/NbZTAJo6+mkkcenUN7iWtDn63r28ffRmhrSjJO6g/wCfAFkl2VS5Fr/1x2S9kDtFyL8oilFCXIp0r8eNNQ4UvpeR8qaH3561/gTOwphlO7GEw/f8NLLy2bR++si4NsLmfPNkLzwNf08No954TiblLJKq38qTu1iNMXTgZf0culK7fuwFc4bSHvdeC0kNPC3l1Qj0L9V5Uhiw+H0BbV8FifDke3Wp++OUv21SasZRTFCzuqFofnvb4i3lZ0FSrXB5cV28w7JAxxuRCUu7i5IevlFTW9MiuV08tVkSBwUPus44PXfMuZoq6CgOxPKXb5On2ShV6m/4Pq6n/i43LBM7459ns1RM5tbmpzttgcDkwcZEv4e+PsJ4VRbSaaLiiYTAn0uyeZ0t/5lizN730Y9PnTSwbwp6AkUBIQTQXKa9JA4H7ji2YP5+egc8P2nBSTKza7ocpaADiv7wU38pHVt0EtMoL0J6o7nlnejbZ5Tleb6/AaQiQXLqaGKK3s1Qv888o0D43ruIG7oimtJfOh519G5MQgeNBSqiED0hVZxBXO+sqGKYK9+X5X2teGlX2HHVQYL8CWfpmWylVhMtySS+hNzsUXSWLZm/PWAsfaCGbgr7H4cEP6e2UiWlxytobG+UO7Tl44kGljYYKUKpYeGBFHAZ4sfn3yUulTsJoOEThevVYaRHDZvEfYANIYX/fiUSm+GFuTfxfkTIwJm/nEK1rmRQnVX+6CZ3pw/MEUTUWukaI55MZIeFtkcG4UUdJ1wGGn1SXw4tptSPV5C/aR+i/Zoyy42IyhXMp+gWyhTg79M0DyIkyrZFKzhjcmjasXJrARmZEfMGD/VALvFaykl53PqIhXI4ZN1zKpazSfQaX2SlUvA+JOLg+eO68RN5Nl0A5qy6OfQ
 SpNH3N71
 KCMAXf6PLnc32OWe6EiJpgpe+Vrxp1HUdE5iEPQQluOCViuu5QDO0hHpd5qxtVnAeNO6gGM2xEtRQ5WB8/WM1+0+bi0mFC1VyD17FFj9dWB2gA8tHnekTFhki/N7wVw+lVBKgEUTKP/A/gYXVm/2R9OQREiQTyyqmuc3vpdrGF6NGca5WkCJwSrPLk+h9cOP+GMxezCWFJOYJpt3y0xLBuMgYmHk9ApI216EFkYzPr+HtbCZQVWQaZzlAwGInxntKv+Ae3hItMWq/9f+jSQh3DUvPTzvM+3x1xU2+BabNxfaAr/WsgQ4+/GlP7L8PWsyI1A+Jsl1lVuxJnvfVuQR+8hO6zcJ2zAwqyLYMiYsKudLo4ODZ4n7TU/Vaattc06/iBcfYkToWPm9wLGD2zSGmq++P10kJNOZJiIaawSOHjxfg7Ba7GImFpU/vuVxnRUOsLHqu023+O37R8lQo9CFEk589L7OMk5qI2gz9iv/T0zfIH8cRg9wpzFaFtqwOy1VlSk5uZegnV2JRFhOqU8Wddvy09w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 01:59:13 +0100 kernel test robot <lkp@intel.com> wrote:

> Hi Karl,
> 
> First bad commit (maybe != root cause):
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   c339f4010dea8b0d754f84ace70cd1b089878ef8
> commit: 7c3f4d699f34535285d0ceb184927d71543d0064 resource, kunit: stop selecting GET_FREE_REGION
> date:   2 weeks ago
> config: openrisc-randconfig-r2306-20261028 (https://download.01.org/0day-ci/archive/20261029/202610290106.o8Fs3NvO-lkp@intel.com/config)
> compiler: or1k-linux-gcc (GCC) 16.2.0
> sparse: v0.6.5-rc1-1-gc4640450
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261029/202610290106.o8Fs3NvO-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Fixes: 7c3f4d699f34 ("resource, kunit: stop selecting GET_FREE_REGION")
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610290106.o8Fs3NvO-lkp@intel.com/
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
> ERROR: modpost: kernel/rcu/rcutorture.ko: symbol '__mulsi3' undefined!
> ERROR: modpost: fs/fuse/virtiofs.ko: symbol '__mulsi3' undefined!
> ERROR: modpost: fs/pstore/ramoops.ko: symbol '__mulsi3' undefined!
> ERROR: modpost: fs/ecryptfs/ecryptfs.ko: symbol '__mulsi3' undefined!
> ERROR: modpost: fs/overlayfs/overlay.ko: symbol '__mulsi3' undefined!
> ERROR: modpost: crypto/asymmetric_keys/pkcs8_key_parser.ko: symbol '__mulsi3' undefined!
> ERROR: modpost: crypto/ccm.ko: symbol '__mulsi3' undefined!
> ERROR: modpost: lib/kunit/kunit.ko: symbol '__mulsi3' undefined!
> ERROR: modpost: lib/kunit/kunit-test.ko: symbol '__mulsi3' undefined!
> >> ERROR: modpost: lib/kunit/kunit-example-test.ko: symbol '__mulsi3' undefined!
> WARNING: modpost: suppressed 1014 unresolved symbol warnings because there were too many)

Thanks.

#syz test

From: Andrew Morton <akpm@linux-foundation.org>
Subject: openrisc: export __mulsi3 for modules
Date: Wed Oct 28 06:24:22 PM PDT 2026

OpenRISC configurations without hardware multiplication fail to build
modules which contain compiler-generated calls to __mulsi3.  The failure
is widespread, affecting filesystems, drivers and KUnit tests at modpost.

When CONFIG_OPENRISC_HAVE_INST_MUL is disabled, the architecture Makefile
passes -msoft-mul to GCC.  The multiplication helper is supplied by the
libgcc archive linked into vmlinux, but or32_ksyms.c does not export it. 
Built-in callers can therefore link while module callers cannot resolve
the symbol.

Export __mulsi3 alongside the other compiler-generated helpers.

The omission predates 7c3f4d699f34 ("resource, kunit: stop selecting
GET_FREE_REGION"), which the robot identified when reporting an additional
failing module.  It was already present in the initial OpenRISC export
list.

Fixes: 616257669e1a ("OpenRISC: Miscellaneous")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610290106.o8Fs3NvO-lkp@intel.com/
Assisted-by: LLM
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: <stable@vger.kernel.org>
---

 arch/openrisc/kernel/or32_ksyms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/openrisc/kernel/or32_ksyms.c~openrisc-export-mulsi3
+++ a/arch/openrisc/kernel/or32_ksyms.c
@@ -35,6 +35,7 @@ DECLARE_EXPORT(__divsi3);
 DECLARE_EXPORT(__umodsi3);
 DECLARE_EXPORT(__modsi3);
 DECLARE_EXPORT(__muldi3);
+DECLARE_EXPORT(__mulsi3);
 DECLARE_EXPORT(__ashrdi3);
 DECLARE_EXPORT(__ashldi3);
 DECLARE_EXPORT(__lshrdi3);
_


