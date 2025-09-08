Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C6ACA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 10:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236296B0005; Mon,  8 Sep 2025 06:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20D866B0010; Mon,  8 Sep 2025 06:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14AF78E0001; Mon,  8 Sep 2025 06:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 014486B0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:38:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C3AABCCB6
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:38:31 +0000 (UTC)
X-FDA: 83865734022.30.7DFFD65
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90DE7180012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:38:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="S vdiaH7";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gXfecqra;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757327909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXniMLCiqQTMUody1zzwv3fUVrwRPJjmN26qgb3DM98=;
	b=7Qxg8AWY/7Kt0FW45rWKdtIX1H8BHygL0GMsU8gWFsqDrWXCXfqaJqCkOEUod6KKW7k3HT
	A8SW60YEmmwgPt5BaO1Hdh+t3Xf4ygzFa5fDjHfO/wZokPldp3xprYO3yfb0alfttJYfXH
	su/28ZGZVjM0wE3Ax/e4OZTaFssH0iI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="S vdiaH7";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gXfecqra;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757327909; a=rsa-sha256;
	cv=none;
	b=xcaTeyveNR3j/iBZYrQwZXQx4xSfu47uZDoyX09XJNWe1fKZcJm8MJCRbCbHleeZXymqqk
	781q4NsRCGR5vi87R1WAC74dDnVj2DUAm8f+WFd8MXcJZ2fk/zM63Hi0u4loZsmdde+xCP
	YwZduVfoMn5tHyARV/f9OCqmV3/qJdY=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 4404E1D000D0;
	Mon,  8 Sep 2025 06:38:28 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 08 Sep 2025 06:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757327908; x=
	1757414308; bh=eXniMLCiqQTMUody1zzwv3fUVrwRPJjmN26qgb3DM98=; b=S
	vdiaH7yTVuslaE3BszjLcuRbCTa0WXuayxZFpsNJvMRFOr5HL+ko6YOK1rbcoCIF
	3wsZiHR0xT64TLaXj0YTqCsbsWwryehZvSN5ywp/I1CWPCRibWM9xFCZ1e607jl0
	KKgqdMaoxjS1DeisHPw5srvkO2pu/OpvMfYu2o5q93rts2tP5M3cFbuiZCTLdmSX
	GsXs+Xro7bYmsX1MbFfeYUlnLLcRq1bQbpEDGzKlxoKJF81WaewOrBWZasIlLfdm
	QfM04d4D/v8IHGBJpITuFwz5hqpJzXY6Elexn9CR2c5s98oIbJJGacKNGIiuICBx
	k8KPpxKjc/s5CnQV1pFhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757327908; x=1757414308; bh=eXniMLCiqQTMUody1zzwv3fUVrwRPJjmN26
	qgb3DM98=; b=gXfecqraAjS9e/kHJUWSkipJgdxF1vCrh1jZZo7MNspz+MkYkb0
	6+xKbIZKQhvvWDzoikPDUlG1qWJD+HKjLXcr50NH69fwHw8b+xJus38p7Zxe598l
	0Krow51l5t9gkFUY1RsLg9LtfCzE0dbn1W4j2I/7/iyfKwt3p5EBX26qiIrxGsJV
	gJP+3X4UEJ89kDM1HEqE6OCbA9+OmDOh98HOY6EhGZg46jz4ymoePfgnXN70lOZM
	92cX7aJB8w2H9ylInkOQbeBH5xfDoBQPinwp9nOrAai8fY337pMPaiNWrqgF3SXV
	NxAHYiX3MeQRusjJjV6iKXtTfgMdkUAERYg==
X-ME-Sender: <xms:IrK-aNwyPJqk8RAX8eyK9qLoa4NVvuGwrUqCGke7__atON0G63r9fQ>
    <xme:IrK-aCZmx_XrQ2LkhBsiki7LOdk-Ak0o68gwtMjsSAv-eNk_dNRPLUwldgOF2Yns-
    1qJpZxnJy8iAHhUy-4>
X-ME-Received: <xmr:IrK-aOmrZTr91I02nRduiYx6lIZwoYlerLKnbPwFxBIWOaxmiQ2cTEApWD0GfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujeefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlrghntggvrdihrghngheslhhinh
    hugidruggvvhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhn
    rdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtoh
    eplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopegsrgho
    hhhurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsggrohhlihhnrdifrghngheslh
    hinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopeguvghvrdhjrghinhesrghr
    mhdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrgh
X-ME-Proxy: <xmx:IrK-aHFpN7yD3L3v68dpSVMjqtgsCyUPZlNVx3nvsh3WBmUiNMixbQ>
    <xmx:IrK-aFi-olsfiMcbQVZOUByIyjtHhPRenpYPtp3hYYcrd3uY0M1Bbw>
    <xmx:IrK-aJkFKek9xQqFNHOWw3mhUIr38xR4E7NdN2MGtMsEfQgCtVI85Q>
    <xmx:IrK-aOdb1nRV3qw4-lsnNHpQUflhtRGh8iI5_IDItHQxP_jspy1hww>
    <xmx:JLK-aDBfv8WSueAMnt9H00NY5N0c4M6DEJ-hSaFcA5Imto2AdNWRUj2M>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 8 Sep 2025 06:38:26 -0400 (EDT)
Date: Mon, 8 Sep 2025 11:38:24 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, usamaarif642@gmail.com, ziy@nvidia.com
Subject: Re: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in
 deferred_split_scan()
Message-ID: <niywtremc5kfhs3lenmfxvbiiizyexnaw3m25twedmzovfoeno@lk2o46tfdklk>
References: <20250908090741.61519-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908090741.61519-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 90DE7180012
X-Stat-Signature: u7m6t1mssmosasyge5eu8hufe1ye6xo9
X-Rspam-User: 
X-HE-Tag: 1757327909-141091
X-HE-Meta: U2FsdGVkX18PZvYmEMnL+MOcrzsCeaY3AxNuNZEqjfWbrtpK8fs/iDCH+fLjxPfgzs+lyhwPBmYcRxWAARmqbmMWB+dAl7M0CwhHct7Z/Gqh8k+2CWDAkPA+1RvwK5ni2OMUOIaEvHmb9GBp/+6Dj4nwwLSX/QrQXKw4lNO8LQGhR9IxkF9sLm4M5retczZQpM7SwpUmt74v1Bnkj0WYMuCIBBxPM7vv8IkDCreJVWmAbSm7GF7Jqp1RjhvA0v8wXjqA2krq2IR6YRfqcYs9owKDuKrSrt6MfnjshQ4iOgV4e0D/E9vzn2Aw+BvoC8HqU6fQLuxAbsKcjgbN5a/A6ZcJ2Vy5aJOoQWC/S4ciLxcypnN4FayRv12bjiFjSgZ195P3dtnlN1V93uo3zxl8IoLt8oeDiX39gu8+2iUuQ2UP2mbSMgx62S+MZ3FhLrGXbLv1jDmdcXN5kLoQpGz3Xf9VhhyXHVqKKnogEXObG/mGCxeoszWX40Ww3kdcmVr4DDNrwuTu8QC2vjynCLMfAVAnQVuFwpx9qBgq5UwFXkiTrxh7+L8qOib1mIFj5RiVBNlHcr0bDpQjxM/x3aveCtTdjeqahypaV8U4BHYU+3XYljOdoKNM7lEK5NNNkptUZzppsToosTRF6QDEVc7Dlpj3xTew8CBcWVMDzGMsEPheLrEiQt1Q0FY07qTMtl9TJ8nJuaIZB02+iHQS+kU2duGOyzoUKHA9riRum2mzTiNE2J/nAs8ahH4SWYKo2/Rn0lCRdceNffJ3lvO6taoai7F/7Hr9sZr1eG5ByEqsUj5PRoPjFlKj7KZicO1pkciyfgCq3i2RULVpPIG+kz38IR8WRvBZFuvSorYQ+7qdyTiMHTwOkIQfvAYfyiNeZbtjwb0lR2OAPuoM4dZrwexbdw0khAqEolK1fxR8OoMAy5PEc7z9576mk7YdqO71L0gMg2UJtiEWMdddI+cym3B
 xbXzSNcr
 8oTjYCnOKFKfmCiFqyS0u7tAykqcrGNS6i8CNfVHLNrsl7bi3d2Sd8eceZi6O8PZMBY9gIbgvsgfCYdI+4KfjnX6hFoDDUceHtHRJtDtjLmjX3VL1jVu0uDjZ6ME9M87pxUp+F98kNAA0yMOCMbVvIGQ1HKTAOuxTRxkL4oy63KE7woMAaPFyo5vlwZNlnQaVNSSz7r9HU3b5mCE7LTTGghqcw4WZbKds4ZDhdX7V2efWEs2EbzeuEQtoQnWV8cid9zfG9H/gVAmx/cLYtz6SxMle+MmmL3cgRpN4Ut/RG2g9gM92wZF4KTwnWMDNK9m0V6slSeC+6HPSSLo08JEldQFF2xwxe4PnpqnlV3irC+b2dshOGiici+2qmBA0ApyVyvZHzKWWz0qNG/8z8+h/itZDteEfb2z1oX59BNrYlWqF5shnyf19ImWedEPyR0GjPAwHKo9UxGMfKjo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 05:07:41PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
> it does not make sense to try to detect whether it is underused, because
> try_to_map_unused_to_zeropage(), called while splitting the folio, will not
> actually replace any zeroed pages by the shared zeropage.

It makes me think, does KSM follows the same logic as
try_to_map_unused_to_zeropage()?

I cannot immediately find what prevents KSM from replacing zeroed mlocked
folio with ZERO_PAGE().

Hm?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

