Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3310DCD3430
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 12:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665146B0005; Mon,  4 May 2026 08:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6150E6B008A; Mon,  4 May 2026 08:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52AE06B008C; Mon,  4 May 2026 08:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41AD56B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:31:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5D16A0198
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:31:12 +0000 (UTC)
X-FDA: 84729672384.25.EE208B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1D406100015
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:31:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNNU7bwp;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777897871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVb+ppMB0w8s3UvWnM7bUt3mkeqrxtOjP4Bg9jTK9xs=;
	b=E1oKwOe7NpnLEDqmZQRuyOHz1D8BE8aotfr4CMaKh74rgZfjj0ctGBk8tv6m3zCCWWAPGE
	sHUx4t4kh+GwrIAl55WqCqxPr2XlHzT1HgYPqybDoesRUIH0bt/BOIFEzz67VJnKyus0uX
	Hb/2fUy/K8A0sq/DJ/oRm5LAmXPHMQ4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNNU7bwp;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777897871; a=rsa-sha256;
	cv=none;
	b=Qu9Gxsb8cVvqQ9q30ohaX73x0b6ivBy+BKT1Ioqnrf4vuvJ5hz0bDZx8x0ymNdHiOTskT2
	vWrzlqVWL1eqI0elWkyC27HAD7fhb3c4BebWMW3u87bfVMuQ2OZ1ukJ9lZUFtU21coYobu
	zKTZlJMVeIgo0wHndOyHVO2wqcmZw9g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDE2240326;
	Mon,  4 May 2026 12:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51516C2BCB8;
	Mon,  4 May 2026 12:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777897869;
	bh=NPNbC063QOfWG5TCrFhK1JH71yuTWi/FepePvYALnQY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=KNNU7bwpyY9vGuO2B5LRRiwBmdQM48/MI7eTNCBHqV7ntd1c5gB87cTdUbAtRMhXy
	 zTnSZhjE7VW33WT1TXwl6QP69riPJ5I5YIQToisIlhbrS6ZL5zWYT5CchS0QTEpOZm
	 dmQsbbPa5lnvLMYrbH5Vt/gVThqBdZGxdbYygzsF+LD/A5ExZl5AvW2uGcQs6RKgv2
	 9WamxQKCwoHPrN/gnTh3HZeXZ/RdnYWSDTRryzrJVLdyfk6IZFpxo1RUiV9lxlk5bA
	 kDmZW7om+r1aAMMZZtLgXdsSEJpFAeRIkPRBFF0C6G1k6k2V+rX6naG+bqlWbWs4Zx
	 +drSNMW/parbg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Michal Clapinski <mclapinski@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memblock tests: define MIGRATE_CMA
In-Reply-To: <CA+CK2bChn3bAFBnmD-fNw2zh-JrAaA73DNmm416EbjXr=mTakA@mail.gmail.com>
	(Pasha Tatashin's message of "Mon, 4 May 2026 06:32:11 -0400")
References: <20260504102742.3833159-1-pratyush@kernel.org>
	<CA+CK2bChn3bAFBnmD-fNw2zh-JrAaA73DNmm416EbjXr=mTakA@mail.gmail.com>
Date: Mon, 04 May 2026 14:31:06 +0200
Message-ID: <2vxz8q9z2w6t.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: c4u63no77ipnfara44ap7yfkzkzm7qwy
X-Rspamd-Queue-Id: 1D406100015
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777897870-522277
X-HE-Meta: U2FsdGVkX1+C1SYI8yLx5KrD3Fq3ug9ampRzC8QsW1E/xHxcySIKg7l+BNoXXObdpZXNOC3QrAg81P/+P+DB/tY8uz+drD/Rky0fsRBJkArhT2RjcEPqjcg7uvdD0UfzRFzyABo4A9OvfdrjXPWSbnW/mru8IIU66Ke8mZ46dgtbW3CP3gTI+3KRI+p5I7GH5FY5DCzi8vEXn3xy1vbL7w8/gMDBwSprqM9JHy/ByJqgaBCVavLEihwy+oF5AnpVQLksFwKZwcp+IH48DYi3T1ly/CefzhQBVJbJY77w3chyEkFarzOeENdADBQcPOVepdK2+QZmX8smeOljfVBCNM+dd1SdafwQl4BuALLgBwfDGn7YxlHc997LkCo8ax9tOMoEqw8C9Kp9MRpQRVmoG3Jt3hdEyv2PVqFUgKiA16jVMwNHBXWKXhm1rFAnciVjFYrRCW/sknud45USiklh+wdVG1dCD20i5xEJO7uXQsHRBmInJc/naR7Xj5Hfh26fy5pRomCZbVl/sOuZR7ObROfCFBPsIvULZH2bcoGU+oDoPJcjva7rSMcL/FImJeywlMzhrK8aKXdi+kwW30tLZM9Mx1D9xfAzlLECEO4DBwLHhuKWN1UMh2Fh8EWCEjKU5KpgZeD1MGJyMykp50Np18Nkui16W/vNGvbf1rkWZzwETLrFzS7+n04euhew8O4tQpwUeDrdZlEiZabU1shke0e/B2b8YNvBcFiPC5OgfLjBcgLOjP0d4DbXTS+Bol2tqWf4AkaHavY0F4pDrCEfI2IgR5Dc5jMW2nyy6GmPF2qTdodCsDWq7v7WKw0k7QgPXl2yn5SHVKbqMYl4hPnQWa7/ro43IhD3X7b7ADRJvNKKYKdI8dR94r4Hul7GpFjrYUPqN0ua8EPuEbFzIuFYhym1kWOlTzysPMDI+EsucfD2/xBU+yhc+F5ALR0S2Rihrsd7MdAv9xxBMIxLVRu
 LIGlYuWk
 FUPbAcroTRo0GSCYAR00QjVcAYAG6/F1CCUM708umNUq5JaqwWM4vd+JEFN4ca0GPc+neB8u/Q1JQrt4r6RoToG9mraSb1TXql8mNhOh3Fvsb4ymY1hUcI44IqYAawNYVEVyqNJymFKYXHWnEX81H9aSSWeDh5EEUosBg0tymJlfCtJ85JI75rmYzHiPgrffavt9wgt6t30ndAx93S8+V1M1cafqt+2EXu+657NVvx5ZcewdhevpPFO7tRyv25AqdnGxq+g03YMp/L1/Q8m3nshFKY2+Wk2KBCyvm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04 2026, Pasha Tatashin wrote:

> On Mon, May 4, 2026 at 6:27=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>>
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>>
>> kho_scratch_migratetype(), defined in include/linux/memblock.h uses enum
>> migratetype. This breaks build for memblock tests with:
>>
>> ./linux/memblock.h:634:73: error: parameter 2 (=E2=80=98mt=E2=80=99) has=
 incomplete type
>>   634 |                                                        enum migr=
atetype mt)
>>
>> Fix it by defining enum migratetype and MIGRATE_CMA. As is the case with
>> the other headers in tools/testing/memblock, do not bring in the whole
>> thing, only what is needed.
>>
>> Reported-by: Mike Rapoport <rppt@kernel.org>
>> Closes: https://lore.kernel.org/linux-mm/afcdDm4aAJvNaQqH@kernel.org/
>
> Link does not open for me.

Dunno why. Works fine for me... Maybe some temporary issue with lore?

[...]

--=20
Regards,
Pratyush Yadav

