Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC4ACAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 13:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6D58E000B; Wed, 24 Sep 2025 09:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9ED98E0001; Wed, 24 Sep 2025 09:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4578E000B; Wed, 24 Sep 2025 09:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA668E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:23:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37ABE11AA1C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:23:34 +0000 (UTC)
X-FDA: 83924210748.05.451D010
Received: from mout.web.de (mout.web.de [212.227.17.12])
	by imf25.hostedemail.com (Postfix) with ESMTP id 10B8BA0008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:23:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b="Q//IkjTE";
	spf=pass (imf25.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.12 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758720212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oUx7FQDk2SiuLavlx/HNjgWtSxwt+Njd+F6PUkWYXZc=;
	b=NXGVs7SVvdX6RckLPs6r7xl0IHAOCeufQ+n5eojeGAJ4Geq3BJdZ01/frVgsFZdzNPwO5+
	AhaY+8w+X1TN+Xbw2GNhSVFz1/GVX2c1MO3REXj5Ivh0l9gsdHX7fBYwKpHuERqiGcKdf8
	Qsp8Bn8O7d9OFDHWVnucCBzLJCnEok4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758720212; a=rsa-sha256;
	cv=none;
	b=rlQhFTeKwPrBovNPqOeFWTr3yd9VpsOCNx1HgjHOWgjMcOhOFs8vLxGJ6gEChSDJiKyDrW
	qnXdILSqHdw/AlmweBEBuh5EDWwxYbkKoiISzkHVuT+97civBVP7xMDzTuehi08qFtleNM
	DU4pXwJpk3cM0nkskX3Ap2kM0PRhuOs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b="Q//IkjTE";
	spf=pass (imf25.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.12 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1758720208; x=1759325008; i=markus.elfring@web.de;
	bh=oUx7FQDk2SiuLavlx/HNjgWtSxwt+Njd+F6PUkWYXZc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Q//IkjTEddC1uTTET7XqodQwxs0USK5Tp0NlciUFBdusrkoOVGlTSrFHIpLDEqIn
	 Q56RlA0hhswnOoWSLaWOIFCea5SVxrWvvjbCLIo2aczMHrTP8LxAkNlBWQjfC1bwv
	 63tCnddtkYK00S6i8jf1CUtxBlXjkgDtgbrIN8cLEV34ni7Bbd501LkisWsg7abDA
	 K7xdrEOEixs5kFYillU7uEN6W9ixv894l5PFtGtUWreXHa5pdLqhfUnjtDeKODZoE
	 93WBshPIcXDzD7e9f6j9xy6g8N3NF0gzcOXdoM3w14Glw9iowmKuleSlejR/pGpq/
	 IyF1ElCPUk/pk4BYZA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.191]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MdfCN-1uRnfK3hGD-00nFl0; Wed, 24
 Sep 2025 15:23:27 +0200
Message-ID: <8f0366c8-f05e-4687-817f-90a5b47922c9@web.de>
Date: Wed, 24 Sep 2025 15:23:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Alexander Potapenko <glider@google.com>, linux-mm@kvack.org,
 kasan-dev@googlegroups.com
Cc: LKML <linux-kernel@vger.kernel.org>, Aleksandr Nogikh
 <nogikh@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Dmitry Vyukov <dvyukov@google.com>,
 Marco Elver <elver@google.com>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20250924100301.1558645-1-glider@google.com>
Subject: Re: [PATCH v2] mm/memblock: Correct totalram_pages accounting with
 KMSAN
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250924100301.1558645-1-glider@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GbK73zxLYoS2kQ137BowTVrHDqoJ8gk83c2ByReHUM2nq/LRqlh
 CZO842TFixdnpUk1ktMJFWudMgvfOEDHLgTrHpvgtEf6VDZAlIkg892QjA6IwmIm4AZAGQa
 oNuryIfeGvJ2wsDd3/FylPuN2EIt+UCxKigm6SB0DvsaAXNqmFhAss29qpFku4zedN1kKB/
 RSZKpA/cm2WPRO972GolA==
UI-OutboundReport: notjunk:1;M01:P0:q/uBpl4JHmo=;6HT6GiaWj/LEuxTLU8Jcvzj9PSt
 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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10B8BA0008
X-Stat-Signature: faseftpp3wg3kjhimpkyot4hnm987mcx
X-Rspam-User: 
X-HE-Tag: 1758720211-41584
X-HE-Meta: U2FsdGVkX19APRgQvmxf1qUkJVBs72ClixCnGIvmvBCYlXdns6V7PbplXOapbi13h8fSBthCzDhSloqo+QWgglVwFxSHPULfHwOwWIuzDOJXIupUgTbiuYvy8+G5dC+39A8rtv4YNPX0l0nfmeu55AwoZwDpvyOyQ8vuHz61kBHg0BTKw9m51kb668LPj2ntlgTVso7wHt8NPp9wen1JXWKZ7iSz/rk/eU+nbGKAGWKSkCR9FHSx9gLvynUx1+STpMlElC+kFoh7Td1LLwdjqkQA9sfFPW9upkVqQnwwKn9n37UI5+gkdlJPJ1BYoQpHpKB0d6zoFQXW4ZTTtfcwW6HMu4RyJprfhQJhV6Drkp/6CzmdzRlVRzA9gDb1pXKsB1Y6o5d4HjlpLVCQj2avcuy4yjSaV5Z7MszMeA/6O3WQWv9vz5dMud0vxSXD9YmzVqy5OVF7hxbXhKPWg61N6elf3ePJRPubiUf6/tl7KWXV6r4goYxX+txvRVw2kE3rZYPjCvMYg3ClH2OM6sWl0IFwS2FCZitl2A1yCtWlwqERmbpqSLw66CZGl5lfMhwvDq3nmJtcVNgQTz++hcgckcYra7XbaeijhYxCBBRblE/dnkDB77ZkkwOEykO/PmKOTVCNzJ9k2mfivfhnqmGmWQnnO0HR4h9gpWz/kMKgGfCIIAKIgavEbQplM0QyqSWeh8k9VL6u0vjWPwYdD+N2NzSuSBhwakzx6PMsSMk3vIYr/nsTgrM0egA/jZmtw+G1WQemKT4hRdt4Izey5OTcpTvUz4Gab18Dbbx7MRZ3nuN9W4ubZQvyD1SdhCWRgV6ZuztCziEXNdp3Vhkx/qUwfOFxbSkIjocJc1DvY2BFlyaRHrkC5FyJFkzjIlDFbxToyy2AFlIFjKxEBWX0h8rV40xjxV4P0G3MGsqwP3213MtwbUlXx2iPvQVMqO9I1M/9xhe+8uCZJFupLheArR3
 g9VDl0uS
 mQnRKDlmix5grm/er5wc3bZqi/RTVAMV9z38WuWpT22P4gN/73u1MsaqmDUr7Xqlnaez3fKiOsw4q5XQH7AgT8MYCBixENi/LE3/cjvy2gOplRFzyCGI+9h8QQjldgJQTeZT9ZjxRa+3zWgnzEvfnGJU0+RvMIHZhB05WjZvdUQ8KZkdaeExM+xxx2Wia/V4Tu2cv1axnh5bzKKSGDKNI6XXbvsW7hfcdqKt2toP5D2WkbBfqz6vrPMZ3tgRUemwYfSRPI2Wyf8+DQmc5035aFHaXca6KZX4G8NbJOWoL8vC2It20nNo3S1ml4hSEulnaezNSIU5q/9fL+NZc1uA76+oYjEWpDNgk3zE+YfnJqwnKh82zfky5STGn6t5vs3AF7XoqXDWANC6Z6wC01ua5Ex4lz+YVKadeRAPM4l04j6aywQQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> +++ b/mm/mm_init.c
> @@ -2548,24 +2548,25 @@ void *__init alloc_large_system_hash(const char =
*tablename,
=E2=80=A6
> +unsigned long __init memblock_free_pages(struct page *page, unsigned lo=
ng pfn,
> +					 unsigned int order)
>  {
=E2=80=A6
>  	if (!kmsan_memblock_free_pages(page, order)) {
>  		/* KMSAN will take care of these pages. */
> -		return;
> +		return 0;
>  	}
=E2=80=A6

How do you think about to omit curly brackets for this if statement?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.17-rc7#n197

Regards,
Markus

