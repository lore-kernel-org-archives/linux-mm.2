Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C265C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 03:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E868E6B08E9; Sun, 16 Aug 2026 23:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E101C6B08EE; Sun, 16 Aug 2026 23:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFE7D6B08EF; Sun, 16 Aug 2026 23:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90B4D6B08E9
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:08:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0189F80608
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:08:02 +0000 (UTC)
X-FDA: 85109277246.13.76AE179
Received: from mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
	by imf08.hostedemail.com (Postfix) with ESMTP id C3B77160003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:08:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vYDg/dDJ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.33 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786936081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJL2/Cel1NyCH1jz8GraNjQ5flXYsrXujTT5Wrcindw=;
	b=JRkk0BH6H6mwTaAxnHfYqX+WdR9/f9qV0fHjL8useJzk+N8PEj9mmFTJfH1mwWdKsqH5QR
	hfLaYQrB7IgIbb4ZwCKa/qkeLHpEkZupKN290i1KrzNlQIiQuagfsKi+OYERMs0LErP1x9
	VgSkHwxqnd0iAf01/elMU75vm27RQuY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vYDg/dDJ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.33 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786936081;
	b=wVPc7/uO9YiqcHtBUvncv5xlrJmZzqwZZv8fND4LXzTEZw0EdMuVcxwQw4vay6zqJQ+vdT
	vwYWaX+ClFd63r27+C/jMKG4jEEXcrFLxoebI138Y4iNdTDU4MwtWac9xzMA5VqC3rw5hr
	H0zWD+HqEKsSLpiFd+etwtx2+dm7F4g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BxW4UAvk2xb0ecZRGZbpgODOejmvGyOqgKfMelcZ780=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786936079; v=1; x=1787540879;
 b=vYDg/dDJziUeP8QkyWYwysiyoKIJ0KXZtEl+RlDhvx61EcwjuJwlfxmKoMYSX5DnxmBIU1Ee
 AfuU+xhqB0XtC/EdAki5buYqJzU54ZcVMxdGXpMbqfwXSE8S4BUrKalqUsWo3cwzy0XC3sspAY6
 leF089eI1pWTu/4y0Xp06WfM=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.244.244.3] (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 6049414b2e7cf9f4;
	Mon, 17 Aug 2026 03:07:59 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <a2ec5fd7-fe7c-40ce-a78e-029b2fefcb84@linux.dev>
Date: Mon, 17 Aug 2026 11:07:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/rmap: synchronize lock and unlock target in
 anon_vma_clone
Content-Language: en-US
To: Eric Kim <seohyun.kim@outlook.kr>
Cc: david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <OS7PR01MB1391443074B4A2A774B7A956C96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <OS7PR01MB1391443074B4A2A774B7A956C96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5hf57h4149d1bzj9kwrxsrmxn9jswkcw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C3B77160003
X-HE-Tag: 1786936080-684186
X-HE-Meta: U2FsdGVkX19F9dOyKWKmJWJKPM1CxXxEIy2rb44AQQ7kg++RR9QmgFVNBcqEcfw2TfNYEHJZK4wODW8ArDpq8tYmRuDwxYcZxgSfhvrHyEww/4bnZYMOObc+dbH2sGgCgsZtO2E+NstRmCHm2+T0gwm5aHHNlQvf5VYqACzWOPOiIzFnl8gyR3c2YVEPzZwMaceuu71nyJM3WLKRGiXMCkoL7/16VPIcwBFYJzR4kNrAkhOQe68Dou3HjuB4eQfJ/FcvAEbDkvH8K0WMHRPDWGUOwsHNFbeFazBaW1/BekHq33cgq0ml3pOPBttvQromCWwWm9Dm/d9D6NWMFdXQXjNmSzbeXkdmoF9jhV1Y6GstmF49tkqlAJiGNC/n1+rd/z8IYXOmrNX2Ff6WCVlvZzViyVfS+dAZhoT8E0Cg6GLEYhCebPFmGQ8MWisFahZIAs9bXaGVSppm9SSs8HOCmcIJBwRvDkt0lwhV9JcdHNaGOHoJkB6bBdGxN2Hs0y+TtNIn7szD8EA1s+kvXr0FuEV0u16B/l6ZaX95NBGr9+aRLbeTnFuLGTT99RB2KPMgopOOM+2s3zPRfg41asGTLIPYtMmrAj7wRIqL15WkiiunI+HDhzIMKdqBx8xvJkvDNP/6KICZEjxjtFWM1tP2gXUgsqI7bfj/SVuvFW7NWj9s2D/c4QvcusMOkEbQnjyocUoLIbgQVU0Q7PSnaotVf1lcI1PrZVFfPSF3A8MUXWDsu/YoXWinZh+qV3s3IS7LnoZBzOtEo3WojOXInei3heQ4nXMoBlgOSbReyAcCKbixb222c7NRZlFwi3oe1Gzlaro72RHTTeJqXJIaYa93zxZYhFLiP8bgCMroXuv5NsjgFF3asW7G3HnDmKW3QHDaBHhCAmD4d46l0ucYVRrgl8do1AEs556CjP+0fykpV8/AjZyiS96k/3f56vac0SKbElXZbPMIByG8AwCjdSC
 cs+NROtK
 GCxFiqNBxpJZn+b+xfUL9omosngJP2pRSjzPfoJ1Y6LI0FATFVM2lV+PdPrtGWuIVSUozI/d/pC+/2WZTOGpVTV+7Q8ga8LJTiyXEPhderEB2qIiiF5zxpVd3Od24IF62xFDa1Ttyj3bNektQVCTzrKkpjzR83zrIiIZLGnNbU09aNI85Z1ivyazFz59NSVLQirv8KyojKkTyu9wSKg0ih8+e16fZCfB/3WxYNrEEGBbzQ09P6UU6iBmIFd7Y7W7i0H9bf21aSsHSIyo1DsyHLPyy9L/9QywXD5yIsdmzQeMCtcyqE5W17bwKN4ekZS/z94Ar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/17 10:34, Eric Kim wrote:
> Currently, in anon_vma_clone(), active_anon_vma is assigned from
> src->anon_vma and is used when unlocking anon_vma after linking
> new AVCs. However, the corresponding lock operation uses
> src->anon_vma directly.
> 
> Use active_anon_vma consistently to make the lock/unlock pair explicit.
> 
> Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
> ---
> v2:
> - Clarify the commit message to explain that src->anon_vma and
>    active_anon_vma refer to the same anon_vma.

Just a heads-up... since only the commit message changed, the Reviewed-by
tags from v1 still apply, so please carry them over ...

