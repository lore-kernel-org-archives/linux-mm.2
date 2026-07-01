Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D97C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934CB6B00A8; Wed,  1 Jul 2026 09:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5536B00AB; Wed,  1 Jul 2026 09:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4146B00AC; Wed,  1 Jul 2026 09:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 536C96B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:50:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B1D914028F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:50:48 +0000 (UTC)
X-FDA: 84940343376.24.14AFB46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE2DFC000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:50:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nWWc9DcK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782913846;
	b=CqWshDe3N+AIoWM2s2XtI4fGKGabMva3R5QEQB1Eo7NKOUpiMULAfVsCgtasaegxHAk1Vc
	sqXAJJYhgjbB1n6oQgTjRclryVwnxyStUJ71obk97msaYH9v8TaAvaNerPxZgpdetJhVPS
	/sqLixeJiRtutU1GUZ/D4p74Z4yiiJk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782913846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ie8R7oVh0jgJpbjerp22bW6nCIKQRE3693vV7WPgBXA=;
	b=t7+wteD65HC1KbypuoeNuBdaa3/TfVV486c00UkGq/2mPdNQKLchmQdfje072mGvPaMSeg
	/GpVXTLIIdRL+Edh7OdDd3xGXViVMY8GLEZpgCU8YSKxp5k1NSiCc9GJ9EbWepyxvZmJwt
	ugnCP12Z563mBjlGSFCWOEVHZBEUmXE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nWWc9DcK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8D5F43F1C;
	Wed,  1 Jul 2026 13:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E291F000E9;
	Wed,  1 Jul 2026 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782913845;
	bh=ie8R7oVh0jgJpbjerp22bW6nCIKQRE3693vV7WPgBXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nWWc9DcKOfk9brqgIj8O56He2iH5VsBU3XE+1yCaLLVN+LUcuTKToV/2wwChCwT6S
	 NlxpFP7sq9JeVsc51fuD5bejBNcUsvdPbU481DWQZtb46PqEVF9yAeRTsLBp8rpBHQ
	 yaWaqdLYGOQ0JAh+5D9PFOvpuNFEPwDMelKnt00yu61YbFuhKyazGbcPsPrFwiPp2x
	 2HyADEiPSDGo4fppXAQRFo8JA/ZI7p/0NFBNIJwFTk21S0USj2Dx3X06T6eEvvmY4e
	 TucbpRuXzf2K/OSioOp/8nmSPxsojrfbx900L1GLuBEcMfNLwIdlXV3HG+f5RpWJjg
	 Mxl+PGg+RUZHw==
Date: Wed, 1 Jul 2026 16:50:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] scsi: proc: use kmalloc() in proc writers
Message-ID: <akUbMCOyt2NHNWCM@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-2-494fb37ebe7b@kernel.org>
 <9d23ada8-8b43-4ab8-beeb-b51c99ea0eba@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d23ada8-8b43-4ab8-beeb-b51c99ea0eba@oracle.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE2DFC000E
X-Rspam-User: 
X-Stat-Signature: oxj8b3gbuic7h43kcnkihfc1xcopkz98
X-HE-Tag: 1782913846-468607
X-HE-Meta: U2FsdGVkX18usWAK9qYLakkzPFUDlFdXhtxII56HXpCW1Ds5IonWUxg8q1eubpiT3QRSDTgcZChlJK1E4zqLR6qsSbZLEuDOPcgb8vrjzpDEkeQnKn3mXwRF/fk0NJVALGHB9IRuZ+oOCQGU6zcWqq98OlgGqPkAMgegr4bgB8qDc/iDHxt2rVLJQKg/bXkcJBhXpNlr6XzUCT0XYmru7j6rP76/w4xMSdvdv6CrhP4ULbLoi+VKFQ61VxOITcZtZmwFtKLlvHMwwF+8HHa2W3q5OsCdYth3PiaUBvaJATx8F2bgwzKbaqvIvjgj3MnsU40WSL5nwXTSBnHLlO8GWjqME8ssJi4m7PKsjGJxmO0XwNgGjvUZF4MBHgi46rc5QLB2b7kswWkHAQ5hSfsMfyW57Z4ZOnYVoO09BP1BStmwQFnqs/31VL4Fd9lvqGNIVuEfztG7WRlcjF8aBpMpxodNv0BAsUhOkPaplv9WSOD4Cto9qIcUGV1ugJyGVxwJqK3t7sg7Sw184tIiMh90DEqXuCCwTbtP1iRJXaijsEPNbKDVOPyrVhDD9xASOKlXYNOZ7frEAP9vuyxeyRuMGpjHg7uFyDPi4HpVj6gCaNyG0baj1MCb/3yNox48RfZJXBhTVQHmZbDboH2TIoMCQYvlVz/WD3ZXt8MFlTKmjyS+1+69Hh1mrtdi5J5QGbUjDvXaWAl9KopMY3rabzzo9Ep7tXR9Fr2dLC1uPdRzQ9PQfXhR5Kn35zU1J536wWRGBfQ8EaOqmbMq8DsGoSUw/CXUdTSmnnRX5DoEYFo1rGJHwiv/aszTHhb9VB3kJcVdHO9vWO04WE3a9BSz6M2xd1DG5DRv+ISsOHLn5voGeXjo5IhY4cr7A15e5t8pH2PuoYVrOJWLEXO9I/VaK4l5EpqIlAQgXrZq2nMZamTOESLEWMvga2r8M8aJs1Nrh6UzstUekkJOenX++k7KMzo
 fEKFa1cP
 B8rcrhtDw4lpY1L/3lMAXWIaveMCmcz+0oSiU4H8wqXb8bvJ6/8+wEj6OUbTX2JaIrdfF3WSwJqNGIE5+9f9gDAhZQlX33iuJ+zDdT3D8/NYT4xrpyBjE7y7yh5lWo6avVO/oLEhb9DKTY0h+kVwHnddja9ZrwzXPJ4z3jd5gx4m4OiKa20UoJyk6ylAas+jTgZs7oMATUxnoBBuKkouwlTeM1T6XmEbakSr9+RLRaXU8B8oMqkZkv7HR0WMSFwtdDmHKI4Fbv34fHUgUaeTqe4c7Zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 11:52:21AM +0100, John Garry wrote:
> On 30/06/2026 11:54, Mike Rapoport (Microsoft) wrote:
> >   	if (!buf || length>PAGE_SIZE)
> >   		return -EINVAL;
> > -	if (!(buffer = (char *) __get_free_page(GFP_KERNEL)))
> > +	if (!(buffer = kmalloc(PAGE_SIZE, GFP_KERNEL)))
> >   		return -ENOMEM;
> 
> It would have been nice to use standard coding style checks for allocation
> failures, i.e.
> 
> 	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
> 	if (!buffer)
> 		return -ENOMEM;

Sure.
 
> >   	if (copy_from_user(buffer, buf
> 
> 
> Regardless of that:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>

Thanks!

-- 
Sincerely yours,
Mike.

