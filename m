Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B58C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 19:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186E06B0088; Wed, 23 Sep 2026 15:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138AC6B008A; Wed, 23 Sep 2026 15:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0264B6B008C; Wed, 23 Sep 2026 15:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D662E6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:19:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FF621408D3
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:19:10 +0000 (UTC)
X-FDA: 85245990060.14.96DC772
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf17.hostedemail.com (Postfix) with ESMTP id 49F6140003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:19:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ASCxU8WP;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790191148;
	b=hPjLptsQzzBj71ESYUdFMqQZJTbCbW4wyocvu6wZmSRdjqYxo8WHNumOCPVqxCEOIQ0fjg
	7JOwBR8wKRtCHMnwR6vXav/11NuKY5aUXb51iVfZ0NWDWYEQsa2vr/Nmk4SxRq84ZxFvrf
	VDgKn/o9R6DJ/b6XhxnG83YQSrWCDN8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ASCxU8WP;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790191148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCgcJNY4tK9emEiCWTTdHOrgzyz8u4VHunmn5NQXF5Y=;
	b=pBatCahXYEbn9QQmh0c6sUVNPzkByj2V/6yBfkLaCvaOJpntTSouShOamKAnZHpvCrC0Hg
	kEd79FUOK802Tmtrt1WulXaYFyyO2yPxqhOKS+KGx3jgJaDKMVYxRZyrnl32iWkZ0zfo+j
	00hzywbcsoQ7vkmD3v2/4um39lMMkJM=
Received: by mail-qk2-f42.google.com with SMTP id af79cd13be357-93bd580489dso120919385a.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790191147; x=1790795947; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UCgcJNY4tK9emEiCWTTdHOrgzyz8u4VHunmn5NQXF5Y=;
        b=ASCxU8WPgmXFUvb9ssetdH1FyhM6xZTrOoy0PSHObdKg4r2PaLsOLtBCWeM2NnWeQz
         FbZifi+7cFSnqSk7TocUAIutjPMcadKw5tSz3kRitVF15RjLFUTHDemvtTkhb8rLHMV5
         ruPTQm8nu9jJ+kwPPoNSXMMEazEFmxsdAgT6hNp2GSiUCX4hcuetFrEAMqdsZs0PMtP5
         hwV60oShOM7DQXD+0793rRn649rletlSboWLnFKUs6luZNhiLTgGdB8Dwe3gMO1DT72C
         qgfb07s9ONVGcCQfubhiR7VTJa1DAp7pDj1D+NvZhPyUM1Cryu5u3pc7Hq80DepPZCel
         obEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790191147; x=1790795947;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UCgcJNY4tK9emEiCWTTdHOrgzyz8u4VHunmn5NQXF5Y=;
        b=ycEzUBebIUMuT73JHonppd/rniOwq79/VJHSGowuz5JeHiN6NQ8IxU9VwCDd/3yYq7
         YkefNRsQE3OEBv7ITc88ClRi5BTol5zRf9ZNnZ31YWNW1lTXltA1KZ1BQDuHs62V0Lzr
         SnypOAx1zlahRzTyFFXVXUawOoI89n2H69sUypn4p9EqSdCWCHaFD88vOjkVnpFMq/dF
         0bvDH9cx8sSsNH/VvgX1zzWppYq6e6Qvqxfl7FVyRKiKw+PdOEMQZvYsv2ec2B/y5CdN
         giRyrdSXHsi3Nvk/zrCbh1f2HLnTG2ionqJxkhbr5KIw4EnbYvEaQdfCOA39/pkk8Aq2
         erew==
X-Forwarded-Encrypted: i=1; AKwUvBzdSY6ezN3NgrNvMD99aj6KaFzcQ7yF13IdMLoC/rpi41ao+NAeQOJx1tMlTFBA/MYbbRT79A03pg==@kvack.org
X-Gm-Message-State: AFuF++kQKa+b2WcAgBJZtehl5UzIfIPbWtuJ5h/292eSqmRxwHA6iDQS
	J4l1r2U6CpIHIT1PsL8gMrwQ5cAEt1LAbWp8CWDI2cREQJSclDf6Y8ti0ESW/Fctv8Y=
X-Gm-Gg: AYBFou0q3h/iOQ5yp2fV0EafYpstU8bfRmkHlBYTpMzCMUK3Io03p9NAgaWcad904oU
	c5aHY3ZHf3DasbpkoATNdx32eZtKBW2poJFd6HKbYkctfyz/MG3eu68VJnIc6dYl/9DOIj9GOf2
	hyTNIu4n9Re4FuimG7jDp16CdR4cDaix5ofXs20a5p3j239sakuzhvvKb6CFQtCIuCoeKRaWOaR
	mqq2ZgCRIkDxdaaPJLvaeF1OQtyjomL8THcl3G4osNOJ17DeBKzC69w/AnoH7z5xrYGzdKFmefD
	xKuhlYeC9IRb9eGSTOooJVvL+rwBLiVAfpyyAK3tifL0Ds5rGJ/Q36MbIJ3wWEw3sUHysuT3HNA
	ux3nmB5IcsxmygOKb25j4ncvFs+etqvo/9dvb20gUpcVbP38RlALYckykucF6QBpmFIxWqIMZJQ
	wdE6CjQ5RBt0SZsaNgT/UX2QXm6rC8WcCwf8Gf0onDAfJ0S5/nQpo0rDN7r0Ia1Mg/hpb435MEh
	QQ1ajw/m9KoyGJQp5oY9pkt9k75unEmd7cAUEyBlMtWRPRmlAyOvfjm8NVhfyui1Q==
X-Received: by 2002:a05:620a:6605:b0:939:1483:55c with SMTP id af79cd13be357-93c346d3600mr19039085a.19.1790191146453;
        Wed, 23 Sep 2026 12:19:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c267e80e6sm254479085a.21.2026.09.23.12.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 12:19:06 -0700 (PDT)
Date: Wed, 23 Sep 2026 15:19:04 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] slab: Remove slab_folio()
Message-ID: <arQl6rYMkBXZ4beo@gourry-fedora-PF4VCD3F>
References: <20260923183655.3364885-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923183655.3364885-1-willy@infradead.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 49e8crzswweujcrnurhqccn7h34983oy
X-Rspam-User: 
X-Rspamd-Queue-Id: 49F6140003
X-HE-Tag: 1790191148-290869
X-HE-Meta: U2FsdGVkX1+OkO2oF9adeGXWPB5aw9eO+/7OZuI/7hWFBN1L5mJuCB0IayQZAnUSkhA1Tl/o563tfUx/PcdUa32Ti7RU0DElHnK6TGbLczQFl8Zw5PVC+X0Phlmr8Y9uKpHHSpZSytNhLV5Nb12i2fxCI6RR6zErRXcoF6YKoVrPE3QI3nAfRFxCle1NRiMZL8ijjV2ks6xVErWn9iD9bNcz8Vq5A6b88up4Mo40Raszky2nvXwShhDBXG7TxzIVLI1dspjjuQur7arxvLPLLFrOA4mxZQzfaM6R8L0Ov26h/yC5V4EKfMKgHJLfMyElScHAAqSRx6z52dcJKTKUqWEytgj3+Mm77j5JkhdiCoRL4tw2fMQoA+A+vRGxe32mrrUMj02m82nZa8D4e9S3o3z4kQWKwHqe64wlkmsuoqfCANeLeGRAuXy7RPk+nQOP2xQ3UgDygX5z11+cwcedHOJKBKGNTYEHN4+TiAlptvOGkYr5Vbs9Kaq+MOhzjSHj3oyLbcD8LpkXuHTHBlVl6NLQX/zl+bFLC3u3BgPbHD5pdd9LJMZSTIFzapuT8y56yaYiAXtPjKLHS/qNbhwuGuUJ8EQbQ1WHW4Pu3glS5fDrg2s24s3cwcegCHn06I7+lVJ7K4M1H4jmt2PThSmRBaw/dAPXsYvsOv602mB2UWrk+mNFAiBMhOj2aQrE5aXipHnQ0h1AIp4DFYkgZn/pmMuZc7sCQxmOSuSogMZfwgPZ8qp1Sg5RGv9RaJkspqcUbn5mECzVrhkzjuW8RZ2678sekrFLKcFJl6smmoPm7J7JymqmzQDCCvgLpJ3NHwqF4K9lPLMs19ahgV7Y+FWiWsoEqwVECKXkW98uZF61tVYvL+kfoz25PLTWZ5Vz6ORWVSDsKoaKUaNUpd500YoJ8WB4GXBHUyJmdvfMWLXIDAx5lqYqGAaAN7MqdRi2s8re/JV5uRHX3Aa0dsOh1aI
 Ucimx1lM
 RA3uaXE1h6e5injK09OLwZPl5ucL1TetlPsapkUm+qI/mjJpRCXKDbq9CuFyWefl2OpoKeZt3+W3e/zei8igB56q9dZrnhnDrZCnLRxpJgkE3uKb/5/cdCzdth+nGNtw/IQE55GrPVIv7qVA5ZDRg/Jn/r2FzgTviGbelyUwps7yA5jUoJr9y/5KsGZRcXvLItYNfLPkuTcUHmL9QA0mOF/Xoprq1WPntEx2aPY2iNMeH8EX+u7sPotwbXxfQcfV3qegwOVY4fnPc99VkmknqJfzfwyVh3j3+nISO7PFrukhi6nzBjYjhntpWx/a7NvIC3wbjPdh+wjam8+GJM2H+D/0Hxc2IUTHVWyC4Mc0sc38kmnlTt4zqxRIHWupY9a13ez3qHTTIzuFBr46sQfwDABhYGj36XC34TeLTTlluMFAEJTaoPlF9Qv19x3oLZ9bnwO+trdWujr5IjhGbTqUJwhL4DpJ0Q6qEwPZb9JQuzOAJxC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 07:36:51PM +0100, Matthew Wilcox (Oracle) wrote:
> This is the final step of divorcing struct slab from struct folio.
> It's still tied to struct page, but there are no more mentions of folios
> in the slab code.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


