Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 848CFCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E176B00CD; Thu, 21 May 2026 11:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965606B00CE; Thu, 21 May 2026 11:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A28B6B00CF; Thu, 21 May 2026 11:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5CA6B00CD
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:25:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2794C1611AE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:25:05 +0000 (UTC)
X-FDA: 84791800170.24.0420B5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7874118000F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:25:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2vo3dMm;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779377103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9zFYHAmIgNm/7flQVgpj3X9/gjkem6kk5Xx6XIMJjAY=;
	b=j/qcjpaRuXUSZPKGPMyJERHB4vw43b5Q6i6O9LBUGbbh7/65o6Ch+tN9A3TRxwTpGtmGMU
	LbP4kO3ycbHiGOZy/Erh/MfvUF1U5yfTqPbYaRD7A2RSBf6fS2UKp4oGRfjtV9ddW7QfOU
	k9Yn8BZwfAaUjvM6bs77vK7U1K0Qm7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779377103; a=rsa-sha256;
	cv=none;
	b=6MQE7oAIRxAZ3TDFhOxB8cVaD6b7cTP5JtRbzOoUeOXq+Px2qTtoidFGNtpMAaX8je7sOe
	4qeGqTnDk136lXQRnazFPOhTicACkIiD4EqtP1+DV8HK02bfwqwCNhUIakH0IPO0bRUW/H
	8CVABoRDdopFmZo1j3st3iAWeFAJgY0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2vo3dMm;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A27BE41E51;
	Thu, 21 May 2026 15:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7077D1F000E9;
	Thu, 21 May 2026 15:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779377102;
	bh=9zFYHAmIgNm/7flQVgpj3X9/gjkem6kk5Xx6XIMJjAY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=k2vo3dMmsz1YrhHDDleGFlDK7u+xaENxpBPvl+fBKKW1aznTAtkUIgXdz9LtYBh7N
	 gnn2sIQzXh1kx1bfJOKZN3QkLk6P7BkiOGJ59+ljgxiys7EaUeibrLPiMaJW/azwxh
	 jKynHj4P7RiLbkAuSFoU/x9weZ824wHRAcEALqketQdiKivd4tA5wTYDikW500Wsaw
	 lbopkDmFTMVfY54DUQfoZhbKH8e2gKZ09+LEFiegf7x0s1pbBsTYMcCsCT+bUev42H
	 EKwDBrnSCtDpZqj4GuHN/a+8nFWDjMjPnFFii+PHzNaTZHyzF/vOcfcVsHpPxEZRuW
	 J0K++RD2/ucXQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org,  linux-mm@kvack.org,
  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] liveupdate: document systemd support
In-Reply-To: <20260519152957.548119-1-luca.boccassi@gmail.com> (luca
	boccassi's message of "Tue, 19 May 2026 16:28:39 +0100")
References: <20260519152957.548119-1-luca.boccassi@gmail.com>
Date: Thu, 21 May 2026 17:25:00 +0200
Message-ID: <2vxzbje8944z.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 7874118000F
X-Stat-Signature: upfy1qt7o9ys8zdxdd8yb4jtowmokyxy
X-Rspamd-Server: rspam06
X-HE-Tag: 1779377103-500954
X-HE-Meta: U2FsdGVkX1+t1ziERMZD5bnOYw5xM30zgL/9fVnfnY+scTm+MDn2JM0zqZEAIlxFELsS87yZvE38NKPe2OHWSPGhRvW78zXVjmyMztqZpEuY2+V8htqI+Hzs6tfkgWMXqGQcivLAED/CMq2igaDPKBhpauVVGNJPTxytI9WNDRgLXQrz9p56xV60v2/8URk6vDLg7VPPfqX7RCM1gfRoBFLMK8kd0WEFZdzvXzvMf8D5LOMbyJ7CQpDquXKdxmLJkNvJoPedrSkNGxFJuTPM/3XnPuPJC7fWXLnDcdWWZ0FHCGSdrG0wUM8372SOhBtwACN8WMXCogaxFxgcC/6aZHM9PCVBWZj6t7RZhdQojwJciSULg1FE0/rpvpgTxmkftcvzzii1ZOMEI9P1UxFOxLRn7knPDG6rqux9e4CdcmZNkyu/giltz85yih1ftdRhJ6lMk/B6zTBAWAjq88SNaYIDFE0jgUqAoLP/0sr4H7qFleoWYQBpUfob74oLVlxf4xkwncNyYrBwFiG1LCcZSf6/DIjO4EfUSf6Khf/uO8RjcfFyg/Tf2i9N272sP+bUUs8w0F9zzzWjynL0fGkCs+FmsP9uB0pal+6du8kba46KXTpbbdjXgmIm/yfMHY4s25V48WfdZD1lPttNpqULbXR9CdmTYWpvqpoJ/7bJDxs3HF++aCQ0X1wM33nWQSl6TpqwM/PTPYFOX0D6jHXFWhfclMZQZt0q5jpfUKmOM/3mbjxxlTV13Wxi7pdQOUGSj9RkBTbkBiXdiVyn2x/SVaMEO2Bf83lHZTRuyRoLhnKgBeA75QDhd1PhJ7cKdAbCL2OLqpizDhPdFQEPU6+CaMgS+PARckoBuHMt6+R0Z4riGvaZ2AnRSl8tbrRX07Q5KT9mslR9RgOcd1ObUgPcZNyD22rB9Kj6yIBfjDDTNHylZKfq7aoi51HJqmJH02imj+ADcRU2EYSkDS3Ij7X
 zr86j/j4
 fJ/8oZ9csBJfFXT6P1IsjCwgHlJHYiE9gZoASme1H41C0WBjGn5nA6Zk972zLCuZ1o2KyzcwkM2vrBekzthhnDg5+Uzrjmlt+kTz04QZA5kUTll+F4yz3+2yPDkHOSaIdaFZRWXzShI8EmFSr1wEq/SIHEUtrG67RP4vawsAOiOXaf7kiSa9itk0lndHwqjjv4RCqXw1x/vuDWjJy8zsU/3UDrA/arbo1Je3a5YVk0Q7oPsUo4je+dhMadAbxEpZ59ox97YbDY5JxHjn0p5XKFuIObRayI6TonpQe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19 2026, luca.boccassi@gmail.com wrote:

> From: Luca Boccassi <luca.boccassi@gmail.com>
>
> systemd v261 will add native support for LUO via the file descriptor
> store mechanism. Add a brief paragraph in the LUO userspace documentation
> page to inform users.
>
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>

Acked-by: Pratyush Yadav <pratyush@kernel.org>

But of course, we should only apply this once systemd v261 is released.

> ---
> NOTE: the external links will mention LUO after the next release is
>       published, which should happen within ~4 weeks
>

-- 
Regards,
Pratyush Yadav

