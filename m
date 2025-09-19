Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E68CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDDA68E0006; Fri, 19 Sep 2025 10:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67368E0001; Fri, 19 Sep 2025 10:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56638E0006; Fri, 19 Sep 2025 10:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6548E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:23:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46A428759E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:23:25 +0000 (UTC)
X-FDA: 83906217570.30.1A3617A
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8DA5540015
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:23:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=microchip.com header.s=mchp header.b=W5PlB0Nx;
	spf=pass (imf11.hostedemail.com: domain of "prvs=350b08d43=Nicolas.Ferre@microchip.com" designates 68.232.153.233 as permitted sender) smtp.mailfrom="prvs=350b08d43=Nicolas.Ferre@microchip.com";
	dmarc=pass (policy=reject) header.from=microchip.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758291803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRT5Nwn2wzURoZ8UuGQ3v7ArypGDz4ExisVSnJCpO/Y=;
	b=t3lqpCDqXa0x6rdrGtqyTum85aqKnrX8+JUxMpSq90nqCztIFlDhfUhR7Cx4hFi1em02xo
	eKRWXKL2bukvm5M20VlAgo1Dhx9y9chp+dHVpxU/iEOES6aSKkQafXOxMeY3SoyLNbCCCY
	Fl6qQv1iNSMpXKC7w8NCcCwjghuaUvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758291803; a=rsa-sha256;
	cv=none;
	b=M1Y+9UjPNN+0y2wQoa524mnHP9+gaSms1wH472zUntqg/1MvjPzP0wKcYW12DeJ4bIDzKb
	dS48RDW9mCgmTcRM6dkyYNDhiniyQXkSrBgKhBtQ9LVeBl49C4txqPnI6FrKyeKd3I+OYD
	pQsFvuyTj22RQRopf5BkWS+kxLXroQ4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=microchip.com header.s=mchp header.b=W5PlB0Nx;
	spf=pass (imf11.hostedemail.com: domain of "prvs=350b08d43=Nicolas.Ferre@microchip.com" designates 68.232.153.233 as permitted sender) smtp.mailfrom="prvs=350b08d43=Nicolas.Ferre@microchip.com";
	dmarc=pass (policy=reject) header.from=microchip.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1758291802; x=1789827802;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qurIkcqttoZIUncvhRG2Ez96lBIE03pACZ8DNjCjo6Y=;
  b=W5PlB0NxHRmuQ/KzAc4cEsfgifm58KyijYMYafbU5rM3PYFTw6S2UD/+
   zdEjZtxX2Wf+pjtwQtZN6KWvfDscI6vOcNzOJlrdIJu3FeCrgk9x1vkDo
   0kExCa9NHLcPrFEp3t5XftmyJk4vu/Ccxn0K95Aa+0MpfB9gAczbWHZgN
   emA6nk4EqrtrtjInsYmI3WHe5wdFcUIl8XKo8v/7AUVuzzKepudDX65jI
   RpTPdEqfK5VLUknRTqgPBulEBBIh5ODMrEFuO3mWzkP0VrwMTq+bNMVVh
   UuWbWhE1TH0ZvNTjSH+AMozqIM03EwhP90LK5a4X7TQRGpamTOXeUEhoN
   Q==;
X-CSE-ConnectionGUID: JybeGcZkTJ+KqZUxcYOinw==
X-CSE-MsgGUID: 4qBXFe4MTX2xEanG6m6MKA==
X-IronPort-AV: E=Sophos;i="6.18,278,1751266800"; 
   d="scan'208";a="52616540"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Sep 2025 07:23:20 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Fri, 19 Sep 2025 07:22:15 -0700
Received: from [10.159.245.205] (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Fri, 19 Sep 2025 07:22:10 -0700
Message-ID: <775e175a-6699-4b7b-a997-3d142fdf64e4@microchip.com>
Date: Fri, 19 Sep 2025 16:22:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@nvidia.com>
CC: <ksummit@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-mips@vger.kernel.org>, <linux-mm@kvack.org>, <imx@lists.linux.dev>,
	Christophe Leroy <christophe.leroy@csgroup.eu>, Richard Weinberger
	<richard@nod.at>, Lucas Stach <l.stach@pengutronix.de>, Linus Walleij
	<linus.walleij@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>,
	Ankur Arora <ankur.a.arora@oracle.com>, David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Matthew Wilcox <willy@infradead.org>, Andrew
 Morton <akpm@linux-foundation.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Suren
 Baghdasaryan <surenb@google.com>, Ira Weiny <ira.weiny@intel.com>, Nishanth
 Menon <nm@ti.com>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>, "Chester A. Unal"
	<chester.a.unal@arinc9.com>, Sergio Paracuellos
	<sergio.paracuellos@gmail.com>, Andreas Larsson <andreas@gaisler.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com>
 <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Content-Language: en-US, fr
Organization: microchip
In-Reply-To: <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8DA5540015
X-Stat-Signature: 3jnn4hbrghqe1cs9u5zhudukr1ezznhd
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758291802-125414
X-HE-Meta: U2FsdGVkX18GLPRGxzf3d/3OcO+lAV6x4GdRFFkkmFBlDfKvktIA8G+XqvkNFqVff7WwbdoiISchozMaQryVbkequ7ssRBEZio15cYiDZy+CjRhcrW6mysBDaW+oPj7XgmzF2YbKetqxbEoXzJGODe2gJdJlfvkPqSi9t1cNP05kgOPUI25URy0daUTtrOXbGspJ8r5TjjJIKyQcTirmOkL4vVeM7omTyt/+9hv/aOVTE7X+TXyYocKZXt8telkGT8qMqtE6f/H09wJO0lnh37K3+BbIzTQ7tswz+NixWy67AtFyKZtah0gEzILlxYrKZZGbv+dSI21ZkHmAZV/AOmctnlAzgQC1ef/494aEYu8gCNDG8pSHCgyGEAkNxiVz40PkDOl0fe1/nCCuALH31HcwdtxZ9phC6eH4t+yc7+RERktV3a2fGvy7SdpnNkQqJaUs+8JjiHbXgUFnKbEtujOTSh5z7bgoUqlx9/Bhlag067cgTTwe+6y7y8Zn5jo6C1iCsbD3ostQNpz1vmon8Ex0nXOMvKEZ7XNwyLTpWNdUNci41HyoSIZkTRKPSzkl2rms0t6gt2xENeuxauMvMiOFSz/ltAW430svU1lq7QZa0VKAYnhx/JPGwk3tmMXAdOEF78Dl7Oto+bhplHyY7uBarO9Y+5oa7zFwXdUuMseUKG3XqTkSegYIv7xQP3Is0HEIH+80UJwQnhP/xMNB83nHsm6I9tuQrse1ZVepAKVRTu99i3edvL6tXg1oYwToSFq+EEMBL5G+QhzJ8mCQfMUKeweZZNJ4dzs5m+KGrK0PLXn21GCZ1iVUAqxZf24dkMNzxjmz0pEg0ihkEa2wykoXBNMmY3Wz5JONbogvbU5ctJA9WCiRGR+lCDwNFSnNcMktTe2uSvlEuW3BPU3S5MAhJI//KvjLJrnZ0MLYdbmKMtDRKpx4Fhivw2pYsqam6MqLkmLdgfF325Xp8cW
 x0pTtCuR
 ykAJuCeGE009FVxQootUliwX5jeY6s2M35kHljn1tfsrl+IK9yw+HWMV3t/slGG8FVbNBCEPUjqwfT33ZsgZDmgpFq0b2+wyU3dNn89FyCilbshWJJrGVcukjkUvMfpm693MCslbTezy8MIORwjuDJHnWjn16/TR32ylXhTxtRRaCR+fqY0RF5ZcHj0D9Pju9sJsMi8WQxqi/Xu4kO4CnraXPT8hwoFEJ7F36E3xMRpJTBFLI57jQ9v3SpAg4TrVfQjFEgEu5chdgRTf8DxIxV+3gJ49Es/qB4EIjg3CghTlGnXO2Zsl0Z9r3jBseRsVS3kY1OYk8EXJ2jBuiAUtELIVEkVg7ZyWfdavxkRrZgVg09V04z9V4oRQnJqUt0qTZDeCBl9/K/aiTBetlVVilWxZhyOok0fuIRukHBhZflU9BIavo523lc96Z0OWy/bnhohxzp6g43DGaRKD3HDrHW2y4dMxjSXsmBQG+Ve38K26NUxcDJKBQcLwITKrYDyrh/qU2Ea2Dom5oQeVX9utX5W4W7/0pSRN6RCac21CQkUMOlT4yZug57vJB1ujYb4u305TYraFik87V4fdcF8lqTHpqQI9RSGlYDUXqjWHRXMyMEiWda7DeFqF9M01OGIO8LsIJujw3tFguePM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/09/2025 at 15:12, Arnd Bergmann wrote:
> * Microchip SAM9x7 is the newest ARMv5 chip, clearly does
>    get kernel updates, and the only one I can think of with
>    DDR3 support, but seems to be limited to 256MB total memory.

It is indeed.
No difficulty on this part of the product line ;-)

Best regards,
   Nicolas

