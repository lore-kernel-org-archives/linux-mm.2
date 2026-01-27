Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46EDED25932
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 03:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8C26B0088; Mon, 26 Jan 2026 22:48:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166D06B0089; Mon, 26 Jan 2026 22:48:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09CE76B008A; Mon, 26 Jan 2026 22:48:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB5156B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 22:48:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 235158CCB1
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 03:48:29 +0000 (UTC)
X-FDA: 84376361538.05.BBE00C5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id B0A131C0004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 03:48:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hjeMWgTV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769485707; a=rsa-sha256;
	cv=none;
	b=xBm5stiNdk8vJ/MwLopWBRkJCvbYaH2bjXK7pzSqNgDPzUqPdq/Etg67y/fEZbc9Mg8fJk
	QNE0QSYMZ9x0NuY7Grh5tfHHj5w00R0SjuZiPp9++rgSmGDwYuLcmqyv7gsioYmdO83alz
	xn3VaDkjSTs8Vjr5z1gwFtr8Gkz4meM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hjeMWgTV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769485707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGjFBW4UN91d6sFxGyKPtDlxiJ4aYX6kwreoynEpBAY=;
	b=a2rsgZpTmgUqmxithUgZ/HH3dKmwnEyXIm8GRqhOZIDknb4KWnVSCeK7+5B5KIYxWLBvzb
	sj7NVh+qrIwV4YMz2IeSDTLGELKTgThYuQXnVFBE3hs8/LJd83FoaG1h110zFLgcUCjIAn
	K9debyDdZTVrHS1wzCcbv288qR2QhL8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WGjFBW4UN91d6sFxGyKPtDlxiJ4aYX6kwreoynEpBAY=; b=hjeMWgTV22fZUAZwE27itRCxD+
	rtlt+wm6zSG+VYG0E2W4hr5sbzO39jo/6PcHISQJY8DsF88UdFJTrqUlsxcZaelxUOFnWDzqq2xBI
	astHLOsQfRU41v6TnSwweoNASgKosrwY8Ca+WaRqM0oWlbVnqCyk5WB9ltnrXc5ftd5bErplyNLCx
	hpYaRtJTdIe14VuIK/Wd8InP12+FAhgDccCrlqQKSeEry8IabZcB4Wc2u16HCKLnQPqko2hIkqAv4
	5wFfYi++r39VIc6ZsegNDsgVPTtOfZj1UnmIHudFxSmuKPkax55lhOu2S7TqOsB6g7pGyqgRFV2Jp
	/aDpQT6A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vka3w-00000006sUP-48dQ;
	Tue, 27 Jan 2026 03:48:21 +0000
Date: Tue, 27 Jan 2026 03:48:20 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shardul Bankar <shardul.b@mpiricsoftware.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	dev.jain@arm.com, david@kernel.org, janak@mpiricsoftware.com,
	shardulsb08@gmail.com, tujinjiang@huawei.com
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
Message-ID: <aXg1hHkvHbd62W0z@casper.infradead.org>
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
 <b2b99877afef36d9c79777846d19beeb14c81159.camel@mpiricsoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2b99877afef36d9c79777846d19beeb14c81159.camel@mpiricsoftware.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B0A131C0004
X-Stat-Signature: 5gqqd5m4puhmp3eocgzohps4npo4s4af
X-HE-Tag: 1769485706-41582
X-HE-Meta: U2FsdGVkX19zZtQBJe754QuTSQML4fX9QFRKRpyC50/wNxPBVULyUGtqdo7OT84xXoQcHRZOdL5X+uPdjUXEQnYelKpVNedpt78Z5VmUcdOLW2gOxkmW36nlZkNlJgGqs+LBXL8G8fIMk45WzbUIWu5iFGaGu9nw6LwSl+cZ8AcZ5fwG2cAyE14buI982wRH+eCAHwNLKIgdgDTOYhTrFaqv8ocrqPAGY1MPXnXEwGmrXtPeUAGmC5qUeFAYHcrgWvinTTngwauT4+TakPBPVuzJJezCAKxxedWQrNoESQtn4r1mFWOoI1smzwdZNoEYrQIQjwIPaCPzqrgxP1rqDeMkd++ONc7SDNLEENSvw+29e9rLhTLU0DjYrvHhQQHzu2Jwaawb3cwe9qS2yR3G8ff2H08KqcZD8iMfR5di3AOCBUfRqdi3e5JQEh+IwcODxADybRNfqOW8S3r7y2nuwCOX5y7oBcpU2pjiigeTOweyBkJ4ancK76o/yneuxrImz1uuefpxP0nxoPOL9DcFCzX6nRWZfg68HxYAgAcEMHjpo+3vqDqa6AqAnN2Vs7PDbKnG47IgsB+me99qO6ET5wSnHayY4R3Y0s1SDNNqtdxaZwmZ+wwt1SQnpGTHYjOLyC0ziB/tdLClqvX+gqTsXZsQmXt+MGqLpmGKXHFouuMC8A6xGeuYNhi3e7Gy3oaLc19nj7XDL4x1FtiGRWXg+Ekw5MEeYFANIQHK22DONNUtykqEco7Mx3EvvSt7PQ5pzsPzS8jBnYyOkQ0PV+50v32gENV0P8RGr1TU3bLcEBctQCPhbBjbNV649/6QmZHAhuW1962V2Px64d+awmxOAe5PdcuzPYECK5qI/oo82G+pAxLlY9wBzaRnKcFAGWPkkoyHyv70IRIGiport9rd/V+D/KeRePEAJiUqjIOYdzQ+bOGURaj2HZliLnLcbp2PT1RfZFDh8M1mHCebsIf
 JeFm/aCD
 u3ww8+vO9SfPR906ovFfdXcGRnapBRihVvukUB6D+haqs8IPW1eEDKMLkmnZjTwbF79egmkSdlk29ffIzwU2+zhbZWMsQRuINPa32CQMrt3pkD+Y4rZt07smV+TRIcWo3As5l/1r510LywPFV6R8BLSs4wuREiLo5QlVqyEI8MLVjM0ri6KB+0TTXBYcw+pegttTHjkn2Jn/cp6oBguv/UZBJeboiFacZS0gUftodW8ZjJ1ffEJyfiMghO2WMOS6Kb+6JOFEUB6AtRDBiubH4IJGdAJV6eT4YPigXlu1ViEgNj7U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 11:59:42AM +0530, Shardul Bankar wrote:
> Hi Matthew, Andrew,

pinging on december 31st is an entirely ineffective thing to do.
for one, oracle is in shutdown.

