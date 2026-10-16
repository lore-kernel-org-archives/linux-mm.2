Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E2F4CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 05:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1336B0088; Fri, 16 Oct 2026 01:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79A36B008A; Fri, 16 Oct 2026 01:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69696B008C; Fri, 16 Oct 2026 01:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 960346B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:50:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A8E0A02D4
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:50:22 +0000 (UTC)
X-FDA: 85327414284.13.CB2E116
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id E8A44180003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:50:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=a6Vzh7EL;
	spf=pass (imf16.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792129820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrScfHS4GnofBvxxw+MCiqt5aU/I+G4MuOJOP57DfZg=;
	b=aypzL381B+08wKiHy4xjLbfpm1B4YyvtpZnYG25p4v09nOItbIa3wc05r+PbhYSjC8vFPy
	kTTap39T9ykjU4TBmPwEaFRd6FPKJ3dCJXGBcG1TdO4eaoIOBCHfcPSyX/W8BjBSuqP6RV
	WNzXA0lIYWPBhDwwd826eT8sQmr4AT4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792129820;
	b=HTZNPD2obCOyTyeQ+ZrbOAKbvR4Kpkywcdvm0dOyZTBkGO7M4D8Q9gWnBRSxP/HVZ709pf
	X8YnueQfCLTQGD9hDRuGTCQn28MPiNakZ4I5MT3ke5rFoEVlOcrH0TLK8BVcW2TE4/8P/B
	Bbrrtjj3DOaHWtb73cNzikb3QnjkWRU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=a6Vzh7EL;
	spf=pass (imf16.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 991B540E0498;
	Fri, 16 Oct 2026 05:50:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6lR6XK1SbiMP; Fri, 16 Oct 2026 05:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1792129814; bh=rrScfHS4GnofBvxxw+MCiqt5aU/I+G4MuOJOP57DfZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a6Vzh7ELny2/ijHAne3MvjQiPhqiFTEk9p8jT6zcvEVeckQ51rZ8PiRWKubQuEPJv
	 5FKFazziykn0ueVhB++eGdNrcyJDaGQL14aH2rf27Zpvim8BjyIoMJ3KwJ6zVPVUgI
	 95FsSiX3t/GzeRkF0qgv0S55JYCFcptg8rBuGV/3fBtIpRU/5Vw2YafTGafAhE2TR3
	 AgVEtJIjGJ31NXIh0/uESaNGA3nQOvTPoKbV8heJa3gjHBFUzjxkQkyDmlRRlpUNNN
	 nYYuHC18l7GZpXA8lW2dktbmH3ArZVSoLx56ByxEqXEoz7YArwEjmFSVtCfGa/haQ4
	 jIOZqJkGHLcJlUpMq33Bs7nB1OdKCd9JfWV6NVPB9c7mOc7Ky41BffUl6iwyNHDs8M
	 RcHVcQ+F1kq1voUGFofYupgtn18lnQrV29Ag/wE3mzrIXdK0Hq+cMYRs+SR9bFqOGg
	 PrKMGVJGnsXzD7nL7odIxRjFmEg5R1KlUE3SYy69kxkihBuD/Kg1oea1fGPexYQEht
	 StW/bI5AaruwIb9z9jh8banhSn9zMg5Cgx4SZE04CcYCRlxVU5rHwPkfXkhMJ7Q9ss
	 lUsVR4JiHvPeyuy/dxqK+HNSU/TNRYWT4TaAyV8CMFDHo+1kVo4+6fBW4CnNUzDiZS
	 DW/Avq928yeGxMrFZUj+l12U=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CF7BA40E00E5;
	Fri, 16 Oct 2026 05:49:57 +0000 (UTC)
Date: Thu, 15 Oct 2026 22:49:54 -0700
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	David Laight <david.laight.linux@gmail.com>,
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, david@kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
	luizcap@redhat.com, pbonzini@redhat.com,
	Tal Zussman <tz2294@columbia.edu>,
	Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
References: <20261005132113.43548696@pumpkin>
 <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
 <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
 <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
 <20261009090042.39ba9c06@pumpkin>
 <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
 <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
 <20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
 <20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local>
 <20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
X-Rspamd-Queue-Id: E8A44180003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zg1ger5m4hqoiez6onwthjkmx8ifs4du
X-HE-Tag: 1792129819-715869
X-HE-Meta: U2FsdGVkX18NvBKuZD4sp1tGDWV3tFhVo7EuE3gCtLc0EW2pD2DQOqwQKjoQRtZ3D6fBu5noANudBe4EMrUpkdMixGeadBAKn1AJd69i87D1jsqgbr43ATdHIzfHZ+hoi+cxrU+TF8Qryr5EXgxHZDcG//pKz4cEZ8Oy01wGWufVAB6EgGNc45MxbWyDq0edM+jtzRUQvpKixs6LU7FP818JE3f1yWF1r3TT3PqBeE9XA+0/HyfJ1ggdLqGSTksFy/NeNQuIrSFX1z0ToUATR7r4nbPIjMgOXzGzWfvayHJPXTdOZ7sEnaNxigTEmrkY+3JLB2MiFp9fEPlmzho8WlOPW0TbuvY/zQtF5G97JLOP4S56NLaXCrVkUrhJWzn67iLAZzg728TQPnytxXRK5fhyKe66rd/Qgrzng2yaFyQIASXHq1MRV8rBN+RUmfE2VugzTA8DKKTkkd3B8EupKT2T6I+t1bgd2ygbWD/L/OzwDiH/gPgOD8CIdBjYWl3zG3M665O28Pdk+D4wLVENxQmQ8DyWG/QsxiO2JHcrYs67xqgWo6bYxx/9w0hfiX8w7AzMV49N5kekhI60u55tYqtGkdDMheZpQZccQbP0+eNoZ8ePms4pmYWxduD4kMw7qtnXDQ/7Asf4MOQ3Bzr1g1RRnm/THGN7JIxbPu9UsVhx4jhRcmDTyG9UNKyMNM/9vZsesZ1h5m4CyY99D5NQFw10BjJXzImPuMBTfat1PtCSifo9jHzMD7nws4ckHRaLO20vplNCF2dQuPl9u5WyJ1O+ofyThiFe5XRFC4dJRavXGrhecAU5EbPZQVbd45Ki14ur4BwCNRblay04k0o60eOxkxn00FaB0dyRwHk+ssdBM54aUlQDd81GlEAAon5hbOJnkDV1+6jxF+8mOw1ETyzz3fNVldQSQozG0a+8QGrFm3zBh9qG1UGti7x7aOupOfX2siW2vyI29zsRzHA
 14VT00Gg
 UwQnhEIDuaZXlfi9TIlnXZKTDUOv11KJ766d7WcRPO3aHx5rPj6HjG8iFtrOC2fbJKIDWY2ImTftWBdpKwYHJvY+P96cl8RtIhSReXpjj8od09/V3j9Ta5ZB1ZoHXNqQdmGMF+EQ8gu2I9JcXIY2sEV+CLmD0E7O9n23Ol0uCITl/ilM0XPVUrm7p9v/NGc6F/jpYU7MsHqu2hz9bvCtFOS4r2zlhnaRYAFzUgjBA+BuPx0/uCosvqivoWlA4TRszDIni4BxvBspv7RY9nWB11o5dKTzccC5vswF1AuJ2z2JaiCkxl3BHmxYywKwnnT5xLBy3Z4Pkl18DAJiK0QCGXh6CliAukCtxrWF7trsqhUjKne2pNe9+/tAPFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 09:18:32PM -0700, Andrew Morton wrote:
> The corruption patterns strongly resemble AMD VMCB state, particularly
> FS/GS segment data appearing at the expected VMCB offsets in unrelated
> host memory.

Aha, ok.

> This suggests that a VMSAVE operation may have written to
> an incorrect physical address.  Ordinary KVM performs VMLOAD/VMSAVE
> without nested virtualization, so Boris's objection doesn't eliminate
> this possibility.  However, the relevant assembly is essentially
> unchanged between 6.18.55 and 7.3-rc6, and I haven't identified a newer
> commit that convincingly explains why the corruption apparently stopped
> reproducing.  The earlier candidate 55780d8a1dcc remains poorly
> motivated without evidence of nested virtualization.
> 
> Two investigations look worthwhile.  First, test 6.18.55 with both the
> KVM TLB-flush fix (26505e1b5b54)

Pff, we've been looking at that one recently too, trying to figure out whether
it was really necessary.

> and tlbi=ipi;

Yeah, we checked that, it ain't that.

> the existing results don't conclusively establish whether that combination
> was tested.  Second, examine the vmcore to determine whether the corrupted
> host pages contain complete FS/GS state matching a legitimate VMCB, rather
> than merely a few matching values.  If they do, inspect the VMCB's
> VMLOAD/VMSAVE interception and virtualization-enable bits.  That could
> establish whether a hardware VMSAVE was allowed to write to an unintended
> physical page.  The successful 7.3-rc6/rc7 testing is encouraging, but it
> doesn't yet prove that all the reported corruption symptoms share one cause
> or have been fixed.

Hmm. I guess looking at and around VMSAVE handling wouldn't hurt...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

