Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB281E9A02C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 02:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE306B0088; Wed, 18 Feb 2026 21:04:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5E36B0089; Wed, 18 Feb 2026 21:04:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2096B008A; Wed, 18 Feb 2026 21:04:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0A46B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:04:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB3791603DD
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:04:09 +0000 (UTC)
X-FDA: 84459561018.16.E994F02
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 26815180004
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:04:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fLthSt4e;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771466648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Elu91ZuWQqfAU6C5nqsrouvyJQwhDNPPP/WnEj46gXY=;
	b=8r1EzaWoBnx8exbaaTf83f0IyzUoONAuzG2KoISDU8JJfMp4jfFnj9s9fElGb2GUTZxShf
	Xxg7tMofUymmQI6/0SAyTuD2xMzv3XlAz3JOOBBAgrUgzbJcKoKCSQO5o53tgERmVRwS70
	eLssfX67Ry8SPPV5seRH95+lP+7FCDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771466648; a=rsa-sha256;
	cv=none;
	b=JQ5hGE8a0XS/gbEmDvHP5YfFIGwc9yTfCk+p3q72AenI4hO282d8QHJcmv/LKKTBjvpn3o
	USX822QSI27jBxie2FcERmplvo/Ygie/vMOnUr4dTbmPH6Tp87qvmCbl9O2Bv1JBgIJ7yo
	ABdFW5rU5lFVUQKGqTMgudkTIkpI78Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fLthSt4e;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d4c383f2fcso422555a34.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771466647; x=1772071447; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Elu91ZuWQqfAU6C5nqsrouvyJQwhDNPPP/WnEj46gXY=;
        b=fLthSt4eZucdgWX9D1UBdH+qBBNa7uM2Z96lJe5qw86nRIkKS5SflU7+5YIjr1CLUq
         8pG9veqNrF5RtA4SY92shRLhEGt4fRHN+NXfLbIyUmg3cM79W3HXI81bf94og+dhAW+k
         ECX6wTGNsixWVpTMl9QT5638ntI379i+MfaLor6Baa3Sf5c1F28J2lzNn5VkqCZemyrk
         DLY9H3SNPBKtSyI4LOffTJwQXxfX1b9F8uvZbK69ubufOwlXfBnHdRh+b6GWhwkSn7/Z
         iAM+O3laV7FcqY/OLXWcR9bogvRdE6hhhFKX9F94q2zHvf2S/BOXP97Go8kEE5ONd9Cg
         GhzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771466647; x=1772071447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Elu91ZuWQqfAU6C5nqsrouvyJQwhDNPPP/WnEj46gXY=;
        b=ZFIcONoQ2dy46a9WSBjLBl3Bi16B5jbVfrqur8z5LZ2CHfxnZslBSKh+BTu2evCm2y
         aZWIgS6fw1JMOX7By1HD081STQFdNraTNkBIWUh3ndZDNMO2VVQx9j9B63xHyUZA4KiH
         itv6yA5xO3JNc4To/DKVZY0PaJ7IPHJxCsP8HDMmomACAOuLq/k019uWvIpiqLKN8CgQ
         uUKzCwwNNfjr8x8+Dglb4HdRYv21Br69qIfDPIezsNAGCcIjAx7Qb1lQsV+CtQKBNqAN
         E3PsRSMKyJPojalElr+OjShMRq4FI5WxMue6yb2NAe6RQREkbBtAQ840fNJD+HbIREpA
         Masw==
X-Forwarded-Encrypted: i=1; AJvYcCXBC+Ihk9mvUSKmiKhX9k9oi/akDIe+8U+ehMLXoQ2jEmGMioefLvFEUJO33za+8jP0XubXSv7oog==@kvack.org
X-Gm-Message-State: AOJu0Yzx9SuajV0IWn1k3D7EzDTvei4j7i4I6EjamKeKL/9Q2zupxdTT
	AyB8jHp33+DIU5tnukYjwsqsaaCwIUCbcLQbQkmckbawJdKyRmXJFEJq
X-Gm-Gg: AZuq6aIgPq8c/vckSBaWZQWGSko2RmTe+mt2PfHBvvQpdMl9/ubj5PLjGEU8zFkBzEH
	GhmlswOPrGUj+haJCKtZw+vMuTX7Q7A1oFDgP6FOj6fWj17hwF6kMnL9Zl8Xt0wYco2fBdHID1j
	Z/LSw9AecWOJLWvFDdaZfDY3mfZpnq8fPxXntEYZh+JDTWNo84NVqCAWDL22mNK/arWuBQDA1MO
	kvnSwnN1/KTfdTptnfmtYfiFOjjSvFLOJ6v9vLlOvcsZBi9LS5x5+IuCIU96tNuBuHsLVJ7Vqym
	rY0qJZFFfYFBnLD7/OufN8SxIjtJWvpahKCg12sbOGFmMZAPG4McLGvrSddrjwMM+0jQ6kJRBoL
	LPXGGOUZWRFZKtWxRSbVOWKZAk0WhNQIHYIwcm2XCl1TL4PKUCAtvmVg3zjlDFKiljLH7NLRfRB
	7uyCtj83y+bjX+xJunvtYym9g9U/IUijM+4aC+e9Kf/VOWibYuaQQp/Kh1S7p5zuE0xQ5yJxjae
	7fyEPSAmecWH3Bn3eS4qAoLosup5H0oZClstQQ=
X-Received: by 2002:a05:6820:220b:b0:678:24c4:2ef4 with SMTP id 006d021491bc7-679aef1a1d6mr818698eaf.50.1771466646825;
        Wed, 18 Feb 2026 18:04:06 -0800 (PST)
Received: from syn-2603-8080-10f0-ab80-0000-0000-0000-1382.res6.spectrum.com ([2603:8080:10f0:ab80::1382])
        by smtp.googlemail.com with ESMTPSA id 006d021491bc7-676e3b52902sm12187297eaf.11.2026.02.18.18.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 18:04:06 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Dave Hansen" <dave.hansen@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	akpm@linux-foundation.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v6 0/4] Convert x86/mm/pat to generic page table apis
Date: Wed, 18 Feb 2026 18:03:50 -0800
Message-ID: <20260219020354.321088-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26815180004
X-Stat-Signature: czhwcdar8rs9cejp6xzfzpmo5oyodzyi
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771466647-251872
X-HE-Meta: U2FsdGVkX191QEdvFGq5xGDeSEK2HL6aAH8TK3k45TkEx2hOJCYHUE9PYGA0xeMFO4cgHabsNCpsQMtTobrZDjLB2jupJ7QKD6KiL0uQpx33j4SMordq8xzI2BNl9FeRo1Fqr30m+gCUDMEQV1bBsIQtJXSAhItCZwBEwlAHK52FaRCuLRhBY5H4Tbavv1ekFCI1inE/LD9T0UQjOB8DeHdRy9w7GGtDo7/xJosOGaHk5iLsGi2nzfrp8MXrIX0lpjrHO754NRQQHnOMqfdm+/Ur7aIEeRmtRroCFCL/51kuIU6URvCFUtI2N6J1Elu2zF3hT9VYT3HNyieOIGbpfGJSJbfMonhkLFCg39fkj8hCxRXMLpvZgl8bNBQLJnr18HR+JcmwTQXzQtKhXZcu8t65/621x5Pn6f6jKfaYn8KOoHlw30EI4ozrqlijJZbB7wOafPVAWv5/W16TXSzwuwiCGmTEe0Ebz48zyqpKM/q9vuPkf09euFgG8TZ7vV5oMUCzeY+k0iVbFkjC3sxPTksigIMwFT/FVolAfaRWF1W/NIP/X0+Bm/R7Ee2BcRr9yK90YsQ45J3Lo6e3PUpAle3piT3H8Xv3Cg6eNIkmRWxh+IWblLbARxzUpK1tJ6em7wGp91fufBdLOdP0UN0g/tZnq/qL7/qPG4HVrbmCERBJMIe+IHHN/bA/3j8MMxCzXaGp1T70dnocK8Gt4G/uuOuBdJynKh3ZqBRFnNCa4jMisW2uKIX7p2BS4KGkZlM/d+Ztkg9cD9TjywkPIwGc1mPJG6bfLS3t6lQxoP7L1wEVCBQ4cF7BG9c5bw885Sz0/BOWGs1z7vG2aih8jGFp0C27yqVjz1dLpIv+f6FCBYcSz73UTwPVp7FYfrjT0x6S9PenLGkkJ5puHTnR6K99Y7KoAk19TYzgLQUKieh46TF48qpPG9GfKAlJSOSz37NR37b3oxm2Oq0AmJbcixp
 50ucfwHZ
 PbzexdK97GbQbZEvS8z4zQ2O1fvmUJRRI4JnFgjZuZX/C2npSVZ7NKY/8YUCs2J+8p6AaOnBPiZHLLA032DEXwjO34qXWFjpd9/Y+nqK9KpdEOrUaZ14fCuYIiy34dbpP/tq64LnDx7i/ym7rDsPElUkk2jsXBA9t4MZkrH9Bp97wrn0K3axLiggaML/oeb8sAjWhp2H9prcS8IBsnAtsaiya0PicQ36U9b7cLlBE+8J7+QVDiq6IOjF8Pdu/fN7HjECKNjJBhgF485drBpB2mBI380IXPFPscFjo9NCQhnxUzB64ItubOpN5/Vy9J5h2KJZ6TunSqs/zqYZtaUkQSQsO+9VKV2Z++GJaLjjZTfMYWKMo6Hk10I5R2CMhOBBqqiRb1OnDeY3I/51cPSpHgGWwoh4iiIHjBmpB0WNCNhCuI2aomQ3Wb6KPWr0lyUYYP7wqRyelDY6meNeElz4MMwPvm9kHcolPfHugjSNedd2C3/7Yrq9O0yhRDUrmF17Ylc0G70AHYZqXQLGDVzmjCXEU7PgtfpQcho+mZTny8k6L6SA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

set_memory.c has a call to pagetable_free(), while the allocation sites
use get_free_pages(). This causes issues separately allocating ptdescs
from struct page.

It turns out that we can just use the appropriate generic pagetable
apis for allocation/freeing. This helps simplify and standardize the
code.

In the short term, this helps enable Matthew's work to allocate frozen
pagetables[1]. And in the long term, this will help us cleanly split
ptdesc allocations from struct page[2].

[1] https://lore.kernel.org/linux-mm/20251113140448.1814860-1-willy@infradead.org/
[2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/

------

Based on current mm-new.

v6:
  - Drop the renaming of *page* functions
  - Use existing page table api instead of creating new apis
  - Split the pmd and populate_pgd() changes into separate patches
  - Reword the cover letter to describe the new approach

v5 link: 
https://lore.kernel.org/all/20260211195233.368497-1-vishal.moola@gmail.com/

Vishal Moola (Oracle) (4):
  x86/mm/pat: Convert pte code to use page table apis
  x86/mm/pat: Convert pmd code to use page table apis
  x86/mm/pat: Convert populate_pgd() to use page table apis
  x86/mm/pat: Convert split_large_page() to use ptdescs

 arch/x86/mm/pat/set_memory.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

-- 
2.53.0


