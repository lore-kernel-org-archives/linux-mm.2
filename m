Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB7DC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F276B00DA; Mon,  6 Jul 2026 02:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B073C6B00E7; Mon,  6 Jul 2026 02:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6096B00DA; Mon,  6 Jul 2026 02:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7606C6B00DB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:45:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D66BE402CF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:45:54 +0000 (UTC)
X-FDA: 84957416628.30.3F03F5C
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf31.hostedemail.com (Postfix) with ESMTP id B8F6A20002;
	Mon,  6 Jul 2026 06:45:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nPWi6xoaRUzjJzQF9Ulwi4QFP9UEd5i6LMvnT2iqIPk=;
	b=4dNKWRh9EaVepClCN4oHrMvnzcfinCYdzed3gtvtv4uDo9NeLdEtEkYX0+f5eAIGP9iBMv
	gkMEcmkE1zHPtKKEK7EE1I//z8M3jsFjtb3+E9dOkZfdLd+maARb1cXC0lp8TagMlsd/wz
	GTjCHIgMhlm4krX3LmSzBveN2PZwitU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320353;
	b=G7kVbtz0vIs/Ge0IoQ6MS5vNp/jjUAqzTarj4gEr+e0EegfN+eveQXvqeWjYHhM6CF878c
	VGqXA4uk9v27oUUVY4ZlYf/l/YFQr66O5vz+nO0Fc/UGYr5lCC5QYgZJGlekxdKSiAerN7
	/Lft+xppQuRdYphqQiLFDGDG/q8sIlY=
Received: by verein.lst.de (Postfix, from userid 2407)
	id AF04068B05; Mon,  6 Jul 2026 08:45:47 +0200 (CEST)
Date: Mon, 6 Jul 2026 08:45:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] block: split out a new blk_plug.h helper
Message-ID: <20260706064547.GA25268@lst.de>
References: <20260706041125.642097-1-hch@lst.de> <8583b332-0d24-4f6f-8831-69e3aad936fd@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8583b332-0d24-4f6f-8831-69e3aad936fd@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B8F6A20002
X-Stat-Signature: czusjx7jm1wsiio9fcbtjf9kyh65hooo
X-HE-Tag: 1783320352-325121
X-HE-Meta: U2FsdGVkX1/0jUIYDPqg/NZ228x+oGzeIjdq2PYHhuQ29NJT7Dzdt0FS7KcSmdGJ+iwbhdNXfFJsSasS80l9/+A2OKUpzGA6eSoyP7B2ZRrZcjjU3Ev6VtBUe/yxq6EjQ4Cn33WjlxDzdM04p6yPNNghPWTUo3+zD1vcj/I91L7H74dF6F5e0jsGK7MlJslaPIfl1TpiQWmmpKaENq3TsMG4E2JQaMclUlWYd3hoM68HuTzWgZjq5NdTsZDUdHyC4QBspgVE2e/lCd9y9EgQURNFM64cVnf/rtz2yzoemtIamB+KcgfbgI2kmg1vPozcpHtNx6VgQt6KWT3Ff6kWbjlcRlK2Vmsri/QB4IRos18XU5CzDS7AB3BoyoFTIL+cEFcNt8bZlmMBxL2fg3f099Z5//iwlgyQqVqHSBlMXDVKcBiFF1hV5OKID8IKk8ABL+OgKdt1iadC36Dm6ZBuubMV75xJ0oP6R1pQMW9vO5FtJ1QmVZMOYna/PD8tqIAoU+4cD/cMZgCgcf09vcMYfr672/wYReFgpnRrvDZcxuKIFJw3rZA1Eu3lgPtQf3VyT+pnIDDfX0AriJ+gmBljgpWK3netVfx9sCW26iM5osFCpTQCUXWDJvnW5Wbp5e4Ybizdd37X6Mr7Yjmk3suB7SMTQgZbal3NZEwQSxmpnAcAozRA2LaHey7ghG7X/kUesD/M84Ba49pqqxOVWcbDuiVctHdU/ajrQxcePuS3dkgNuc8bi2O2sXpp7Kv+TJXVe3HZZMZDMe9fU28OMNnuAuUK/XFxr/imDbhZ9bJivde+/R1GQdAGthcW5wgb2dn71G+0kyMBGsB4kQIKJfhnJ7HuoiWscMEdvNBw7hXStip/XtFune2CsmACcMA3nguLXGOEa+AxFBsmpxWk3VaeIfr2XKzynFTzlsO4QMZcsvvpeRSbZtEiqdpT0x8ZDLXbMl02Z0j0RSQLk7vnTpW
 a4nMK+5A
 ye+Y0KjDK7o9gTlsCcDHuiGd7TrxaXiF+LgN+jIyNs9pTJuuBXZk3eBbHaRYgfD/XiQ5Do1GGsdjOCoZHg1TQS0Z8bkMvqXxnGBb7H7jn1nn2rswDYyXzR/c5Or17TqGwDj7nkI9dB9MicnWrtBTousMb3Vpa1BGNKcpp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 08:38:12AM +0200, Johannes Thumshirn wrote:
> On 7/6/26 6:11 AM, Christoph Hellwig wrote:
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 9213a5716f95..20cb8ed7d987 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -7,6 +7,7 @@
>>     #include <linux/types.h>
>>   #include <linux/blk_types.h>
>> +#include <linux/blk_plug.h>
>>   #include <linux/device.h>
>>   #include <linux/list.h>
>>   #include <linux/llist.h>
>>
> I know it's a lot of cross subsystem churn, but wouldn't it be cleaner to 
> not include blk_plug.h in blkdev.h, but patch the update the consumers? A 
> quick grep shows 68 files that would need updating and some you already  
> have updated.

Right now blkdev.h needs the rq_list from it.  So we'd need to move
that to linux/types.h or something first, which feels a bit iffy.

And no, including blk_types.h in blk_plug.h is not a solution,
as that is still touched far too often.

