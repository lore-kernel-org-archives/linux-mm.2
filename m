Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66907109B489
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48176B0098; Tue, 31 Mar 2026 11:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1F3F6B0099; Tue, 31 Mar 2026 11:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C676B009B; Tue, 31 Mar 2026 11:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93C296B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:07:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26CC914027F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:07:46 +0000 (UTC)
X-FDA: 84606687732.22.E3E3199
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8524FC0017
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:07:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=b1vfivYB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+59c2af5217c32a82be5b+8255+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+59c2af5217c32a82be5b+8255+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774969664; a=rsa-sha256;
	cv=none;
	b=mSatFW+U5xpQUBzInbgzHciHQmvrIy2VfOLUxutQNY2gJZ6HVZWaZcXMRb94/yj/oxiIHb
	NDpHWGyCg4dBwtGO3tnkGOe/kF57CiaS3xCh6eVQKt1PT+n5fRfVC12Hdm8rOiFq+ffBjZ
	IMFJCDc9nRhOrBhyOrOFr2O24juJvvg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=b1vfivYB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+59c2af5217c32a82be5b+8255+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+59c2af5217c32a82be5b+8255+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774969664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=xspRiOHudA1tnHj6tMM6VKR044Lu0LJaJ2Ggjy/Fm5Qz3YHwVg7ox+xJJtldfRmM5TYkmz
	y72tRVeDJJHPuyNmi77aqaKfQP+oBNCk0iGC1UeLdIufVQMW/hmmwfIBA1/HF1rE9HnIun
	GoVZnTS7tf6B3wpfMUlkilvtm3sU2+Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=b1vfivYBRqsffpDGrrry2hl7rs
	TWqN/8pxHnzFI+7zDqTtLOR8vd7GUT5SC1xd+zDe/6lY4ydI7fVynYKGsheSSe+ortUjbBN3dBX1s
	OvuMx2MjEiSxwDgFvwosmrPWI8hkD66JXL5bMjE9DK/LXeoHW0TiPAKYE/Q7Xqnieuo36PgleYrfS
	wkvsCypJ+oIi4XGw2CO3ph5HyDAPeYDv2QHDazAGpRZoL0f9YID7a4tFg1l11/DYz46+3wRbtvs6K
	zfxwbMzA/5stuMRlLmQToPY3bxUL3YqOtKMTAsn+b6UG8c+ek8lOmYbtuPa6m+TTiA3Zz+an3+P7p
	X1BB98fA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7agt-0000000D9BB-46d5;
	Tue, 31 Mar 2026 15:07:40 +0000
Date: Tue, 31 Mar 2026 08:07:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	Qu Wenruo <wqu@suse.com>, Avinesh Kumar <avinesh.kumar@suse.com>
Subject: Re: [PATCH v3] zram: do not forget to endio for partial discard
 requests
Message-ID: <acvjOxXdmMRebccm@infradead.org>
References: <20260331074255.777019-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331074255.777019-1-senozhatsky@chromium.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: d4pjxwuhkjgptukyxuqf3jciua1xs7ht
X-Rspamd-Queue-Id: 8524FC0017
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774969663-212442
X-HE-Meta: U2FsdGVkX1/RyZmDkzhG4We5bFeE21snBGGLEKi17VuFkzatcI96rk5m1+stBlb7eSQYwt+GnB3yYFKHsMGXERYrP8dyXacuNhOrcgi+cdo68pPm/bI6OFy9qwSTK78KtegT2zJ7+zy0pKpPfAh6JwRPh9Up0b1APTqIRlulxzeqtb6vtaTwWrnj9AQ4P97r/TWbuxD6FZkJr7Ynae6gI/521H8ONzMynDUTqVD85Io2kA229V+fVQ1bD1wRaedk1MbwiNVNbURsqNWHD2mInshwVkFZ4FHK6utEmCXoeHR11bVh7fKz0miQctI0S4sHAkxIOlJ8owwIHThydWbGeEIZGQmzumjy+hExwGV1PHEc9oPaJi4DMw9FjA5fNA2jiW0y1uBvqvD6MFY9AxAb4bz57zWBRJHdAoBaSoJxI8s0aQ0G8F7fl9xV3HelZzTMItcNoXMfIc9VG5NOIcUJ5JXTjV5ISxJR2octeIw4M/O5PaSkBA1lCNwIYYGSy1uYCt2c+PCnTmJjXG9Cvt0uXWgSrLH6de9oxwhZAuD811bUrOBW1vEzgNth4slz88ejRyQXB0i6pFPw24NzOOYnL9aYkmdnWvhbl3P/lKRqLc0hv5SKgqfkVZ4A5DiKEwH7Y1jkwbkPybU3MAtWteAYOj/R+3NWeBw10gdJX8NQgtPFO9h73qIA851AwmuQueEj9KwXisHK01y+lKI+Zpyd3lwgM5iDfD+V7sFuAgWfYC3eB94L9ZjKEuhM3Em37mO2M3QspwQ3EHuroWAfdcR9n+GjYFbpyz5UBiYAOL1wb1GuRlfsnxysuVGNUbHo5U61QGc7E9uwH0e0HiRbOBc8RhGYu4ovcjohGF3eFtqGsiO5MlIXurqvy64B0//VqffQSPJ4BrstgzQkL+BzMA+oYBsy8/jRBO7wjdsccFitmtyRyb9msVHyWJfuSgZDdWGuBT1zdPFo1PbM5GVcb9Y
 c8vKM5Xl
 BsAy/0hwFMtVMTu9zKK637j3DH/FqKPpaXDG4uuAGUMpPanfOcsThFSV6/LpqVqYh2odzlCOTMZ5bjTWpRsyZBkuQyD5/Rvhln0A0B1I32VNJfUB6RCZlnfoBPDpDcCdz41LkD/zGvOhAnM+iz/vha/J9g9ed01od/TtdKw2bNawtw7Ff+gokw2ZvDcGNaRZqBKND3Ng71NCyN4nuD2HXM20HhkdmVWE1b9UTjNzE4Lo6FTMTuEV7ps8gkpEW61mb79QfDQG8JJfCi4vN1wBoGvgn4pPmGa8mze+moZtnaIiHlcbqKuVKAfmTOuwnci1kqVczMVHN0rpMtXay1IRyYXZbhsm+EvhCuWOUb2/uVjRUHPxKu61S50wnjnMYOPuJWkFU52ukKGgDO74G+MLYzTyiSQJlo+LGuFyXVs/BCjH7qrNWew1JrTadb08Ve0lgwsPmodkPJY6kd6+sOoUiEFqS6QfhZouGvSf+WCm7b1Rhd0B1GycqLRHTCnuY185hE12HWN9bEoD94z4Vl/gZuUvwJ3dX0wHTSa8XsFdJ4pATO1+3Y5HrnUXYsp2LRSptTnlgSknF3dLujECDSSLUP7fsL65Ek0Nh+txb8j6GI+ezZbGkaGSbRmiVYy6N684u56Z78sp6n174ApTPbTEqq5+Eu9ymX47i1tHbErvr4gB2dj5Rwg+8hwAnNuZWNosu5GsEHWZtHuAxsmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

