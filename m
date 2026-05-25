Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D880CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67E96B0005; Mon, 25 May 2026 11:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18346B0088; Mon, 25 May 2026 11:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E5A6B009B; Mon, 25 May 2026 11:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1EAE6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:35:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5AAF31C0628
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:35:25 +0000 (UTC)
X-FDA: 84806341410.13.87A1D61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CDEEC160006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:35:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m9G55K0g;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779723323; a=rsa-sha256;
	cv=none;
	b=byIKUITNyB4RXw+4J6yYDkX4zfAXDKJQkYXZxnYgLncmQHY2aOdRR8yP54XyieDmubi7al
	UsIm7Q9GXALW+YieI8ba0pKr6vL6Abr5WfxByQgpDXrPGxFvmqpGURqnHTgHD10wY3CVXX
	3m3yDE9C12z92Y3rG6gC2cYlUOsNc3k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m9G55K0g;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779723323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4RU4mhDc8qVs92H5+4lAVgCVBlE9tWSHjhCyliyrIDc=;
	b=uVtJ0htOPacsXB2tL3OH4H/6MKZZ+RmlR4PYlTmUlwc+wsV2z9lKHf8eN/iAYmaBWJKw+y
	wSfCFQnRVAz6V9yukS21WWNZ8FMbE97JGH3M6ZNSuB9dEmi/OXJGd3jfvuiCAWSKoVUb3d
	wX5K16r7M8nwobgVsWO1PhfdBFlRP94=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49F64600AB;
	Mon, 25 May 2026 15:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D641F000E9;
	Mon, 25 May 2026 15:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779723323;
	bh=4RU4mhDc8qVs92H5+4lAVgCVBlE9tWSHjhCyliyrIDc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=m9G55K0gx7YOL4cj4gOb2FGACR+7Bfe15lfJS/RfnYvFNkyHit4NSk1tP58/sP/tB
	 I6BOAYqUijW0t3roijovmeXpwe+RYWH4i0wH4oy+ac1ZmzLdvi66K+wjlpUQYpNELv
	 1lKvOPvFAcdMFR7xUTT8lv/k3BEsHVZjwLIy4VZsl7ih4LD+H4fnh6ZTddSBJ7KQJw
	 tzMDh6byuS6tJ5F0VQVYeWFeuc/ElBGk2PStD2NUvnfeS5t3Zrq8qkwLCKvMmrrO5Z
	 fErvA3e6nOrwsEakVqIgbbUUd47FrMMe1YW6ktTI03sm1dOOu/0NjeGsKqitzfLIP0
	 aKLB5Pny4Xk8Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-pci@vger.kernel.org,  Adithya Jayachandran
 <ajayachandra@nvidia.com>,  Alexander Graf <graf@amazon.com>,  Alex
 Williamson <alex@shazbot.org>,  Bjorn Helgaas <bhelgaas@google.com>,
  Chris Li <chrisl@kernel.org>,  David Rientjes <rientjes@google.com>,
  Jacob Pan <jacob.pan@linux.microsoft.com>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Jonathan Corbet <corbet@lwn.net>,  Josh Hilke
 <jrhilke@google.com>,  Leon Romanovsky <leonro@nvidia.com>,  Lukas Wunner
 <lukas@wunner.de>,  Mike Rapoport <rppt@kernel.org>,  Parav Pandit
 <parav@nvidia.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pranjal
 Shrivastava <praan@google.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Saeed Mahameed <saeedm@nvidia.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  Shuah Khan <skhan@linuxfoundation.org>,  Vipin
 Sharma <vipinsh@google.com>,  William Tu <witu@nvidia.com>,  Yi Liu
 <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 04/12] PCI: liveupdate: Document driver binding
 responsibilities
In-Reply-To: <20260522202410.3104264-5-dmatlack@google.com> (David Matlack's
	message of "Fri, 22 May 2026 20:24:02 +0000")
References: <20260522202410.3104264-1-dmatlack@google.com>
	<20260522202410.3104264-5-dmatlack@google.com>
Date: Mon, 25 May 2026 17:35:16 +0200
Message-ID: <2vxzbje37b9n.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CDEEC160006
X-Stat-Signature: nmypnubo77dhewaxh1qrqp69kj5uziaj
X-HE-Tag: 1779723323-541400
X-HE-Meta: U2FsdGVkX18MA1hEbUufijwszQN/YooUEcmlWrE45cqlBLhuleHFNdd8a+1r6rmp5QTAhtSPKFNTTL3tSMFz4PYCrTPVsbwefGkeJWbnU3RDtWz+22ZAJrQ/7h+IztQ9ZFoFcqsxEkox+nY0fj3jO1jedtR0evw7adlXhibi55xQDXWrnS/CGy1Y4UykEOGlT9jdaoi3LFpBieQW+I4iDgd75UHzeYyORUU/Hzub/qUzVRC+dHZweNe/ceUh/Ol2tQ+mkXjuckT7iHkg9wfVRadM7EXDuLyAm8Z5DzbyLYofMCTUlLLOxGFmYvvrFO96bVOSVec3AK5iVBYofV4lrIqG4iOFq1dstxN+Ammo2dWrv+UwNZ8GzqvrkfF7ynrQ0jPg8bjKz9KpxSacwXgkRR7J7ctuzaS6qRUZZjdRtTIi5DEDeYC04tJdNgq6d037fCzsJcEjI74FVz+VgvePl4wH0uvh6zpsq6OeSup7O/HJM8Y0StlPg8pMBvGzIP0AtaJcuAHboiHD9e1noYG57zPE3GVATPrFr9jLVYGmxvA7wkBuPM5ECSA0iuEr6oupBUcg+zKAWQklp2Qkj9dTkN47En5YPX6vYH9vAT4aKCbznDXf5g0UVORDCnfYGDG33rO6HdVIGwnzh6JNCJMaQ+GqmOii8SlyP5raGW/Hui5Tt67YtAl1WkrIQkiukoY5WpSj4XoEhWYrMYx7mrrvHOlAhu2OfeO3QY9k61Sk//5YoBgXaPDHgv9bXwOIn61Rli7sIBDvwW2bFp095x0EECL0T4azzWoRV7IFVHqhiDE6gPhHfbM80CKxBJME2imuIPfT2QzgS7x95BETeHrlKASXsjzQXD7LZe9D1l47Io8EwF0dAvW+SgHw3c9JtoCCvTbUMmEYe366m5HTQO8nqX9gOhWcKp5Bwl996OjW9sYH9JF2GL/65lLF2tM1A0Jm+tJuo61uf7SIjM/Y2rU
 b71dCAQE
 LSvUI1Aw+4TEBx3X881vRhBqAziZQUlSQ7cffZmxHtcNI0i315yhpiwt984nzGcKo1vUYsK2bKeti90fFiJ78+NeImXdeY950QkrMvMntgSzz/pnB/+i0O//mYfJilXBES7/K7uNJmmFx3ToxH5FonOCt3rw+qlViZne2a4JiOlx1lGnriQWUg4cVnmbLKt09Fue2I/UZ4kU94BjVttWoJpF8oBkOdBiNvUSa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22 2026, David Matlack wrote:

> Document how driver binding works during a Live Update and what the PCI
> core expects of drivers and users. Note that this is only a description
> of the current division of responsibilities. These can change in the
> future if we decide.

Nit: Should you also note this in the documentation that this can change
in the future?

>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 96c43b84532c..4f2ec6ffdd16 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -70,6 +70,22 @@
>   * preserved. These may be relaxed in the future:
>   *
>   *  * The device cannot be a Virtual Function (VF).
> + *
> + * Driver Binding
> + * ==============
> + *
> + * In the outgoing kernel, it is the driver's responsibility to ensure that it
> + * does not release a device between pci_liveupdate_preserve() and
> + * pci_liveupdate_unpreserve().
> + *
> + * In the incoming kernel, it is the driver's responsibility to ensure that it
> + * does not release a preserved device between probe() and
> + * pci_liveupdate_finish().
> + *
> + * It is the user's responsibility to ensure that incoming preserved devices are
> + * bound to the correct driver. i.e. The PCI core does not protect against a
> + * device getting preserved by driver A in the outgoing kernel and then getting
> + * bound to driver B in the incoming kernel.
>   */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt

-- 
Regards,
Pratyush Yadav

