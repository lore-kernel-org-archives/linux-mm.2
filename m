Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C2B0CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 06:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18E780014; Mon, 27 Oct 2025 02:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC96C8000A; Mon, 27 Oct 2025 02:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C042F80014; Mon, 27 Oct 2025 02:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC62E8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:03:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E72159386
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:03:16 +0000 (UTC)
X-FDA: 84042851592.05.6F808F3
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf13.hostedemail.com (Postfix) with ESMTP id 743D620009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:03:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=OgePVYlo;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf13.hostedemail.com: domain of joshi.k@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=joshi.k@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761544994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZJD6tbrr7iDfFmW+CWqwnzZbJ2h3gEHO1zpYTWAHuI=;
	b=WWCrotIYgUcBRu6dy+/HNJq+VWcrkcQ3clJJiAbsjXgcthjINTRawF3VpAwnIeN/7G44dk
	mhReNKwJ3OKIgGKw4VeBhkwnFyJj4sJcQCY2iRiLCEMD7sGMlwZlSXRMbxY98wUg+cS9Qu
	oZLUlV1noC8N334ziId8ecfocHRiUMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761544994; a=rsa-sha256;
	cv=none;
	b=epiIYejY0t9PL6U4Hyuu96UpYdUN/OMp3U1Ju3vO9Rb5qbswHywxnH+GTwCdI7mzXl8Fc/
	ky8+5AejLAGwuuhy24zuxQzw5tia5RJRUK37mh1lzW0DBJTLBS6kSqqzzMR1K1P0cFMcEY
	46Yfm5FucAZ4pxfTwTRBvqXrnaBofEM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=OgePVYlo;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf13.hostedemail.com: domain of joshi.k@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=joshi.k@samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251027060309epoutp03cc2d3da0a3d75aebf7832f5f30255126~yQ9XJEo0_3229132291epoutp038
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:03:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251027060309epoutp03cc2d3da0a3d75aebf7832f5f30255126~yQ9XJEo0_3229132291epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1761544989;
	bh=vZJD6tbrr7iDfFmW+CWqwnzZbJ2h3gEHO1zpYTWAHuI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=OgePVYloTzMwdpjohkzCoRbk4F594k8Tqaycd53CWK/4krMeBYswwPY0NbmBS9PBu
	 wtuTBit1R7Y5ZmbTlhnks9aswEv8cxqajljKWVsieRawVmwlKi8iZaFx6DEc+WMjxL
	 pSM50i2hP1e3Hs47qMMg0/B6/xElN1FimN/KL+dM=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251027060309epcas5p146799ade6f600a50131d97b45f1b58dd~yQ9W4y1Ee2957529575epcas5p1Z;
	Mon, 27 Oct 2025 06:03:09 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cw2x82ngLz2SSKh; Mon, 27 Oct
	2025 06:03:08 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251027060307epcas5p1eb3ad9d4926616811459f164f5b55354~yQ9VfuJ5m2957529575epcas5p1T;
	Mon, 27 Oct 2025 06:03:07 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251027060305epsmtip28f9d9c355023391ee7a7d7094627680f~yQ9TSqnzg2329923299epsmtip2B;
	Mon, 27 Oct 2025 06:03:05 +0000 (GMT)
Message-ID: <03b69a96-161f-4c5c-90f9-9be55d58d8ff@samsung.com>
Date: Mon, 27 Oct 2025 11:33:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] block: make bio auto-integrity deadlock safe
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton
	<akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, David
	Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, linux-block@vger.kernel.org,
	linux-mm@kvack.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20251023080919.9209-4-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20251027060307epcas5p1eb3ad9d4926616811459f164f5b55354
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251023081005epcas5p371dc081977202f0e60a47067d8109064
References: <20251023080919.9209-1-hch@lst.de>
	<CGME20251023081005epcas5p371dc081977202f0e60a47067d8109064@epcas5p3.samsung.com>
	<20251023080919.9209-4-hch@lst.de>
X-Rspamd-Server: rspam01
X-Stat-Signature: t3szzidrqbfa35rak5sozjjb8a8ruoow
X-Rspam-User: 
X-Rspamd-Queue-Id: 743D620009
X-HE-Tag: 1761544993-780790
X-HE-Meta: U2FsdGVkX19kcWqpEXNg2N9a4Fzi9Djnjztr5SBkrlmBlrTNqkqI8YPE4T7r7479kmXwUsgMDTgAq90sWuzzJ0rQ4TT67/HITjCuKNGHssiwFZJhOHFChiZ4W5CozbPoYORbSboRlQE7hAkeIEGzKuopXeic2ZY+FQOVs4IMPcb7e3aXOyCwxjppgIq1RGWhT8XoT1UWMcUiLHAgqR95CSDSV5vUZd2DBenEColp+P1UrMQZUDCwJ1hNx5rBDVRnaqsrgzdW169wA3PWwQKVBGiCrNNLqCwoXb3HDgMzBh+5pMjsih9gAEZa0Or44CFGU+/e3NQfmmTn0HPhaFnUwAcDCVDOnLC6J27/iEFEAmjn8vPXg5cbVr7XUGPi5l8HHfN2UiQNnb0Qkks8cs+klbt18GVpVX6vJumBbvHXbIYUuu2xM6LRDT+4hbtEeqH8Yb3FiSwjdhVzwqZq1kZyN7FdhrYNJiFpfUaO9TU7C893KXpV8sV8OAB3WSPcui89TqajteZ5wNCMH2ROGYg1cLjwQ2PWAoLgt39Xv0bHxZ/7w3DNfwxxQJXpKfjbEU+xrfVURcusunf4yxp68ZrtHJw2TPrkNs3TxKOrcm52Kdj/UaV7bz890OaLTVIPlWeOIEi0GnJFTlpVkzoKT5yO9t8UP286U1nRfJ3P1tk2eyby+sqRQ5j356DmGaSrcUvZvyGLs3NdKxqTRJyjC0y12b+8+wg7/qY31QgKn3V5KWrx/JfdfgB/M93s/zgLY0T5ZDftgF7XB0C/ir5EXMUYUerpTULP8IcAAtVSSLAnlb9u5ko1Nzy4HZK8CVYVbWHz2DtqVRKO3b5D30rkfCPws4mAD6zpMQEfr1AcTbvy9is+y75TlIWWLFwvhaYddh7om3N32HpXssCiLyc/vRbHKiReov09UPexb9erMSJpZrTmAvVh75B1wUF48llT3i8/v/0xBQdweSKis474KPc
 BbgOEANx
 JuvzNZ+ehJxCEED8YBNGbFKEUpDB21gWSMIOE1bpJ7s0cH0h1I529zDTFZ2JHBqhmKIbP1boY/W7O5pQZZ6lHzMPx6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/23/2025 1:38 PM, Christoph Hellwig wrote:
> @@ -194,6 +194,17 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
>   					(1U << bi->interval_exp) - 1);
>   	}
>   
> +	/*
> +	 * The block layer automatically adds integrity data for bios that don't
> +	 * already have it.  It allocates a single segment. Limit the I/O size
> +	 * so that a single maximum size metadata segment can cover the
> +	 * integrity data for the entire I/O.
> +	 */
> +	lim->max_sectors = min3(lim->max_sectors,
> +		BLK_INTEGRITY_MAX_SIZE /
> +			bi->pi_tuple_size * lim->logical_block_size,
> +		lim->max_segment_size >> SECTOR_SHIFT);

Two issues:
- When underlying device has pi-type 0, pi_tuple_size will be 0 and this 
will cause divide-by-zero.
- The second value in above min3() is in bytes, and other two in 
sectors. So this clamping may not be happening correctly.




