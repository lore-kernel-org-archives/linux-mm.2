Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C31CCD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 04:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5BF6B0005; Mon, 25 May 2026 00:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986BE6B0093; Mon, 25 May 2026 00:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3386B0096; Mon, 25 May 2026 00:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7B96B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 00:02:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 367971C0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:02:37 +0000 (UTC)
X-FDA: 84804595554.03.429B696
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf10.hostedemail.com (Postfix) with ESMTP id D4748C0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:02:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AWYPrHGQ;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779681755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ef4XEinfeY7PdsQMAtEr1Lcv0NaIMIY9uuCtzsvnryU=;
	b=Y8fHaxg6GjreaQE0+VZs/Q9d8Y7cCFscZJ8IDY4PcCS9tgDYvk7Fn59gvn6WJaGnuAR9XQ
	AIEnJDKwfzdIHuS2kFyuayYSNS1ZF1mz494eYtg+490VY1+8o7wLlaXeu3D5MIIQb3qGu1
	t6mV+ZvWaYqfWqz5/BZ9/Yj6YLZ3qo0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AWYPrHGQ;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779681755; a=rsa-sha256;
	cv=none;
	b=XTDsdbuzBduqT0yXHc9y7eyraZJw7jBHj+ugv9X5AuUkSWv2HpPkx5up1KBhm508qdzIym
	Cj8aQ186TNMbsYSI+fyVG3lU3eDW1ZXdI7uLDVpjplsww3g01ojGeStgrl1rBPy8un2NHR
	5gEGPl3um2cEPPgVQJW9fxmf45I67t8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779681749; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ef4XEinfeY7PdsQMAtEr1Lcv0NaIMIY9uuCtzsvnryU=;
 b=AWYPrHGQ1oQubyOFZc4H/KZBIioSGJcqh/XPhcUlkmtuwfvll4Op+i23L4SaajcZbCqZyL
 5/HtYQWMbznwFNneZP5qFKliuLxerHYCbZzroZ0zdEfDidvHvwbep67XAiuno6wWRXMp9Q
 7HD33VdEAmmoi1rzIAhW9HcdwBR6IrreWytA8sW3yhCe9xtdaUI6gBm7HFToTbhxCpyHBZ
 p5xoHgObFeFngrmgrprbaznrpsFhmgwrB4ublLm3azFBz1jk4UzecPV2ZosPUP1V8guji8
 gLZeYuQg54kn7coM7zO0K1XekkLK2jg5J+i3yYxQUcl78JaYStZZJJ4jvsyV9g==
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260525040206.96739-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a13c9d3+b770a9+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<tglx@kernel.org>, <x86@kernel.org>
Date: Mon, 25 May 2026 12:02:06 +0800
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <177953825218.3959652.8194606082469375738.b4-review@b4>
X-Mailer: git-send-email 2.45.2
References: <177953825218.3959652.8194606082469375738.b4-review@b4>
To: <rppt@kernel.org>
Subject: Re: [PATCH v2 3/7] mm: add a template-based fast path for zone-device page init
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D4748C0007
X-Stat-Signature: zds4ckdqxp5bp49rsobw9e4939ahjf3a
X-HE-Tag: 1779681754-381042
X-HE-Meta: U2FsdGVkX19g3dJvSr2VgO33wzqO2pj/VeA6KvU6iO6HKNDyuFMesCLfXFd8Ic+5GlWNly0y6lb7tGyAdUoXQsg1G/gCkJb2S4hsmXjz9JIbaB7Ls79c4e89WOvJLmIMpexAIE+UYTr1zz2X7AeUDhfsN5y7Svj/N+AJgVt/NoYkfVxJkXbP+kwv1Oi1YtjzC77YSoxmVxns3qjCSy+7sp7O6kpp7eQLUXtJUffFvN8E53xYByor4vuUV1Qo+esUFwAFqhajgVsjWl1I9rtZ+C7ctQ7CJ86mMfM464/sOYRMeYL0F37nNeDw3kylhJU6Yg9h6rl0TXPTXLHqd8L3M5XAXVpJQE/alXAhRmwriM6+steqJRAqsrOwTjdrNJuTdK7CSdXopq+Py8+C1OrKP5Drnr4dXGEBGIquEXZjUk1STKhJjg/TsglhpeG8HVKlD6UdIqXwMpRmK6Tb2JnfZ6v77wxwaBtPwhka9G1ExEL6HV47W0aGHld3zGKeKaj/qAqOh6w+DOK9dnaDtxOSwEtN4J7iWPQb3T/uWnzzXWjHKNz6iJyNwRUEhzfByP3W/gcEAaF9WhDrw+22WYGIXeE+KXy5DNP0qtuqILRIIc/qP2cnUCD+Iv6s7TJ9pGVe99zLJ8z3DNksgiOOfoRrtUvSNAGhW8FcgtpWPw0QXNrDeFHw1wWHbkfzoALkPeusHa/Gw7eTRSPFRkdTx1GeycIVA4k+gOBqUYxS9HcTX1AzgOWIzaG8TE2RQxnChHEkVPpOORCDILJWIkgRnZ7DHfNQrB8g2qTetjpX2esrgRXW4GaKHOcCcLW/JY8Omr0TX1NT9r5gl6pLIBVCi6akznnxkFUsK/PHoCroIsjhg+Y51GdIPGjeoecHQ+3+RD/MkAGwlg/1ZcADsS7JxR/+7RnBOWEzWi710FKX65F2gLoP0snSNCaZ+tOJ1XhK+FUxebIDFnMuv8Efx795G1/
 MZbyfRdL
 DyMNP9Y8tdtkMNl4I2dKTPn4zsW2meVS4lrQpHubt6y92o4oO4kcT9JpmgqUwX9uppyEL5LL9tp47uWaP/NOhBl1gdvCg82mOwM2HaAUrDe4S51kPm8KGXOKC12V3+L4k2AkdSaST7vsxGqXykW9jmAYpyReLJPryeAogLLTRCHviSskWF8zevSvElt4Uf3qM9jNvL2pGlPefK5B4qoaueKgsHTgqGks9IgOSkkdKFmVF4uJJL0l1MgZFF5XPcdmh4vB4NTCboirp/yQGIoaS0Hk8hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 May 2026 15:10:52 +0300, rppt@kernel.org wrote:

> On Thu, 21 May 2026 12:01:20 +0800, Li Zhe <lizhe.67@bytedance.com> wrote:
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 4ba506df93bc..2992711351a0 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -1066,6 +1066,63 @@ static void __ref zone_device_page_init_slow(struct page *page,
> > [ ... skip 33 lines ... ]
> > + * The copied template already provides the PFN-invariant portion of a
> > + * ZONE_DEVICE struct page. Fix up the fields that still depend on @pfn
> > + * after the copy, namely the section bits and page->virtual when present.
> > + */
> > +static inline void zone_device_page_init_finish(struct page *page,
> > +							unsigned long pfn)
> 
> Please align the indentation for the second parameters line like int
> zone_device_template_page_init() or use two tabs for indentation
> everywhere.

Thanks for the review. I will adjust the indentation to use two tabs
for the second parameter line in the next revision.

Thanks,
Zhe

