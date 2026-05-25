Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38034CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46EA56B0005; Mon, 25 May 2026 12:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41EDF6B0088; Mon, 25 May 2026 12:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E266B008A; Mon, 25 May 2026 12:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 210616B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:48:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3A961A012B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:48:27 +0000 (UTC)
X-FDA: 84806525454.09.97A6A89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3C22DC000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:48:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYW7aLWw;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779727706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8+rOuAsw06eyL6NJoqLksg0G4h6H1UZY/EYUW4dvjM=;
	b=QU3J5/C/YbrxEq6IGrTVGBjlLptqJ7tusMfuny4FTqHJQ+Ti+VFKR7bud9ppWGJ3xVCq/s
	cLvMJmHk26swo+xyvr6BWu7dzmSrCit2b68h5enOYmTTtJiSNBsH7+Uyz+p5ETxW8JZY4f
	NKnOptSQBtCszYn8eVU0HCY+v/OkOY0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYW7aLWw;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779727706; a=rsa-sha256;
	cv=none;
	b=hjX0yMIkgmhfBHYIIfQ2XJr5DLR9XLAq84Xfnv44wPgUWgflJrpEdAAIHxSJFyGhQS+DHX
	iPAucDl+H/8zt9RDIXUbeuMnj26zT2Xkr4+zIH/+hJVGtwT33H54FINy01nbgVnR/YS/Au
	UdZo/CrPJKSKAjMOP6zqDBwXz4j6dws=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7FC66008A;
	Mon, 25 May 2026 16:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C321F000E9;
	Mon, 25 May 2026 16:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779727705;
	bh=X8+rOuAsw06eyL6NJoqLksg0G4h6H1UZY/EYUW4dvjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYW7aLWw9P8M36AJuw5en93j8uTOmjGw8dW+zJWYXUxbA2d2yDHupGk7l1/L0HRbr
	 oMv1bauOvKGJw9Du/krlKcu4OysJEimCSPZ/L+6fIVs6AAjj1281k7BjxXMdp0UgdJ
	 ygrF/WvixQqhNUyvQpOcDtrNx+C2wJ5PCJ9mVAgM6wyfwnFsKg5byVkPEudyV0ADwO
	 8kJGAoJ7VyCW1HRjPTMvGsK17e+MiXYPraj9G4SXmaMVPtT9Usl1tcfYGmSv8qJCCk
	 In3ZvvkRInC1vLLTb38QK3r4Ob3gDeK7oVyFEPSLrOgqQZ0I2FWiRqWsJH+3UM7rNb
	 Z4wDIe5gBs9vQ==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Mon, 25 May 2026 09:48:16 -0700
Message-ID: <20260525164816.8864-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a746583d-af0e-401a-b1f8-d4a0e60d5cc3@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rntqn9brk8f1pgasjwzw5ui5cbur6gwy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3C22DC000D
X-HE-Tag: 1779727706-218537
X-HE-Meta: U2FsdGVkX1+kGvmytnQZBRmLuRDJbWq2cQ5RZscIV9CdGjBBmbjuWLI57QylUFbzGqoB0eyeV4TWrFMugZHBq8XtZmLz/HEBMyQZC9mLLOyfyaZMoEUnKV4zHfBuIps9t29FaJnWwGnUmt9SXNBePs2fcQKjdtIXTOIRxcSZQkUNs4DKkEqrFW4sAtGQOusJUXytQPG9p4L26WK1m/SLs3VZgp64pZRm09bCrH1lLRttiRn+taJPCAr6eqapOtwm9eHKTCRY6IQGDi4iI3vHtRy4x1NPRZZsQRDh+4vbsF/rGwzDAvdK+s8KsYHZAdrPUFx2frulAPIieHNhYKClKh0qgfxqRnJEJana8P3RShRAwJMx0HOgY497IfHJ8FpkAaagnKoMle54huyNbuvUPG/8W78Z6O3At7dmogZShYoILvZQ/w3Z0LOKjFZSXU+LATKHGaE5cswh4tHa9aVp5oyBJFhLNADwa+VDrv0JIIYmcWfF2NLgDYNfugFchR68aCl7AMHrK9F7DSuzJU+jHWqgqWvfyvKEN7KwAShS9JAhbZW+Dey2bA7Yx7/NbWX6v009MHVDZ3jaa0FhBkTj6RFFFgeMq8i9Xl9+xTQQVxmTjmc6x3Cqb6U141kuf1W3gV73nTZOUskJDd3HHdDmbYAuxzrJj0S0jttkC1TpPkt1SOf+jkEObl+Nsh1qypIMX7w+JzBPF1YJfkp8F1e3ffEkqdC/zEOjPyzDbP37eq6kv2oeKJg6Zs5V9iJER61ym7e9MeitBFsLuM3X7hCMI5Kll5yufq9yq7v3drXur/6mJCHHGtL0Awi3ATLpGuScQ7bZQ/9HX6xwlM+9gIjylDz8Z/FzPJ4iMX4YDwU6B9QNNO1YAhhpmUrwmxh6OC0aGBwy6y9TBwkanUkyefH+qfQr3tZy0HisXDHWjQ0bNl2J3xMPk/98OQbRE/lISktx6zgmMm5cg6GZRoNIXIx
 0AA67EUE
 EAj8aTTPWRgLtpWTxKOw1/THIYHLm8gdplWJTXRCM6iT4tIw+KwOfXlsk/FUEEUcSZqevhD8Jsgl1aVtWQAyyytO2UW5e6KCDSrtC43GOjUXckeTiC8RhTOVs43I4G9d9ku/X6paOzO2Kbg1pkd+PAwtgogIiefMV4APyJWELGvfDlSMrurszuMALcs2TDtxYBD+gRNzy4IEldPGNspB62WGvamGHp+wSrFZ40uLKTG7P2C/ZrsTsqg8E3NMBM69fEqrnbN5LkNHNCPHIAnBo4YXvsnQOAczVYA8lQpwlimFGGfSnBY9W1pudPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 16:53:17 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 5/23/2026 8:17 PM, SeongJae Park wrote:
> > On Fri, 22 May 2026 14:55:14 +0000 <gutierrez.asier@huawei-partners.com> wrote:
[...]
> >> A new module is introduced to demonstrate the use of huge pages
> >> collapse autotuning. The goal is to collapse hot regions of a given
> >> process into huge pages. The module launches a kdamond thread for a 
> >> certain task provided by the user through monitored_pid module argument.
> >> Hugepage goal autotuning will automatically adjust the aggressiveness
> >> of hot region collapses.
> > 
> > Having a module for the demonstration purpose sounds good.  But, for the
> > demonstration purpose, as I previousoly commented, making it as a sample module
> > (put under /samples/damon/) or just drop when you drop RFC tag would be better.
> > 
> > Let me know if this module is aimed to be as is even after you drop RFC tag.
> I'll move it to samples. I'll keep the RFC in the next version still,
> so I make sure that the major details are polished before I drop RFC tag.

Makes sense.  In the case, I think we can further reduce the number of
parameters of the sample module and make the code simpler.

[...]
> >> TODO
> >> ====
> >> - Support page splitting for cold hugepages.
> > 
> > Sounds good!  By using two DAMOS schemes that doing collapsing and splitting, I
> > think we can make more complete access-aware THP system.
> My thought was to add cold page splitting as a separate RFC in the future.

Makes sense :)


Thanks,
SJ

[...]

