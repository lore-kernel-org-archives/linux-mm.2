Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77D7CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F2E6B0005; Fri, 29 May 2026 04:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329356B0088; Fri, 29 May 2026 04:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218616B008C; Fri, 29 May 2026 04:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1049E6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:49:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7B0E407C8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:49:26 +0000 (UTC)
X-FDA: 84819833532.10.70502AD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 039A540009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:49:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ivprReKs;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780044565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Yr74bm5b1I6er6TsjOHvM8O63leqKbgA8DFDU1A6jw=;
	b=Ifd+V+7suf1n7lHyCJgCUD2ajvaeORWx2N7AMRACnEUl6RhN6OK/09++EICE6WEknwv8E2
	fuzinJcYX6O4suIhuPDCWo+zy4jbwHrSX6zkKbnmHdoItKwxZWJCvcDAxMWsmTEs+apfnO
	prjjV3rVnGkjYT1qyeZo0orivT+DJIo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ivprReKs;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780044565; a=rsa-sha256;
	cv=none;
	b=DsGOb7GLA8CGZu4LIxDbsgldEd9yFpHA56VL7g/nQQsDOShsQaMywx36fCxipPv2BSNHu3
	PscWy1yVGMoNRXq1CLL0SbcDeGxhZ15/cV6B6CzYEPldm7zinEwFPokw/gdkBzYy/Td6wL
	vVqR/kjqa0hddV1//oCmtjuGdGr6SS4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20A2E204C;
	Fri, 29 May 2026 01:49:19 -0700 (PDT)
Received: from [10.57.91.162] (unknown [10.57.91.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 430AC3F632;
	Fri, 29 May 2026 01:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780044564; bh=0Yr74bm5b1I6er6TsjOHvM8O63leqKbgA8DFDU1A6jw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ivprReKsUadaCcTb8g0Y6fux7oLRv4zPPNFSi1TEM201qLpgF3A20EQN4tJDBDtM3
	 S0nbog1ouGDatXNHMgkBAd+V9ATrxI5QR8icYHXBy454uuQh3yuqWKsVaGy/XI47P3
	 ZKILKdQnLDYLJUH2p/YTF/kixb3dzjPrfQvx+zsA=
Message-ID: <32458c49-0e3c-4d27-b1cf-0e2d7ee0273d@arm.com>
Date: Fri, 29 May 2026 10:49:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 15/15] arm64: mm: Unmap kernel data/bss entirely from
 the linear map
To: Ard Biesheuvel <ardb@kernel.org>, Ard Biesheuvel <ardb+git@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-32-ardb+git@google.com>
 <22042b98-cfcc-428e-bb08-ebcfe785eb69@arm.com>
 <8082b77d-6522-472a-9030-317087ecd7e9@app.fastmail.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <8082b77d-6522-472a-9030-317087ecd7e9@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xn1omyw9msmbordn11jpkbr5okadaqdt
X-Rspamd-Queue-Id: 039A540009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780044564-311899
X-HE-Meta: U2FsdGVkX1+6KU5F86gZ+GcS3wnpNL+rWvEOMDRL0AgbrdngLQ2upHdSLMoGyWzwH3WbZ+wXzs0yh2lGZKLgV6BVTL5jc+/dfqCM5Yq9D/QEQkAnWq1x0kEmcQwVJMiunotywtA7EZG4WxMv3J7ggpZLnvIxSVdu0LXLd9jKnoTLafqIKAjKV3K2qwCflIMnwpwlv7TNpUaEWaNRk//W6VoOXfhmEQrqi+bN4Cmax2KovoRSd7MM7STIyHNaeTJiuigx2QaYdTW7Bfx9W+ls2/n2bqSprGrOZ3oq59ZOnXylzOebozzVjiL+cpVewm3nNBXMB6WD6yPAJRmlo7SJe1a8GQkY6A/FXnMrQglwCDYFqxozZoQeyUHuU5m1P9mFoH4YKohbCf7tSxygjqZxTsl5ftHR2LLLoHu52ot7PHTH/w/MziHw8btUk13oQX0NAalRbGle8KO30OYuMXNF1FwHnmUzgwNwXzvUCvoaygfYMt7C2BShnOkKsi5lqzs5Rn9jqOBAHPetWzAkXfOhhJHIeyTxjnmJy69lUImmTderzuPeZa7K+5VgotcduUHc9bzfyWwsjqjdQt44xdwtvYdWWwQvJikkjRL86SqBnAtAOPBdVuts/giG9gdwt3P5ZGecKCOs/34xQZlfWGhzCtxYesVCGne5ZuI9XvP4ns2MneAs676iYIHt4JibT7ZqfBKrswzCBXX6Tsj1Dyjz44NzhOEMSjhubNwpsfnWY9rkdL5MzFTbByI+vaizQ/JREkenJ0YX9G3ltPB77nGp80aOrQe9nj4eCVVLuookzeItsq/yhh3e4VC0jFuk+tbm0eslmaMCqc4uWhTyes0WSYLroVkPQ5tSulqz+oDrPPvqxrR5NCbDZGyYpxizR7pqSmjSxLff8ax/pNcivHW3PFlJQrFzUMaYVV2wryNrT/g7fHhyf0iQPaSV64R/QwreVKxDJiGN+1p0swjSn/+
 J3tX7IWG
 vrRGsTWQd15KVOOaV4STplGOyp7YbrhcMrg2+Wj5HcC/BmSrBdmXqflddUY0WZ5XmNATzThNHvbtnd4dWrPZCZVtQwtFfBrYf4UWaeNK+VjGaJXuB5bTekoeFhA25W5D/hiNlxdSCC15zwMVHrzdZaWmjWBZJmzdsZcbj6ZUJBfHzVkc0L2+1SweX7N3cjfkACsUVttPhNIIt20GnIthnKfNwqGYb6latS66Vz4xjWICYqJCb72cd9ZeWUxQfWyDczPnHUq2rtOEkY5AAmDOzCNbHxPYm3EI8++BuKGEuIIHxDD+5U/r8h12iqH623U/GUjDxrdMtMe3Pnc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/05/2026 10:34, Ard Biesheuvel wrote:
> On Fri, 29 May 2026, at 10:29, Kevin Brodsky wrote:
>> On 26/05/2026 19:59, Ard Biesheuvel wrote:
>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>
>>> The linear aliases of the kernel text and rodata are mapped read-only in
>>> the linear map as well. Given that the contents of these regions are
>>> mostly identical to the version in the loadable image, mapping them
>>> read-only and leaving their contents visible is a reasonable hardening
>>> measure.
>>>
>>> Data and bss, however, are now also mapped read-only but the contents of
>>> these regions are more likely to contain data that we'd rather not leak.
>>> So let's unmap these entirely in the linear map when the kernel is
>>> running normally.
>>>
>>> When going into hibernation or waking up from it, these regions need to
>>> be mapped, so map the region initially, and toggle the valid bit so
>>> map/unmap the region as needed. (While the hibernation snapshot logic
>>> seems able to map inaccessible pages as needed, it currently disregards
>>> non-present pages entirely.)
>> I'm not sure I understand this, is there something wrong with the
>> kernel_page_present() check in safe_copy_page()?
>>
> No. If the hibernate code decides to snapshot a page and it is not mapped,
> safe_copy_page() will do the right thing and map it on demand.
>
> The problem is that pages belonging to the kernel image are marked as
> PageReserved, and so the hibernation logic will not even consider the
> pages for snapshotting if they are not mapped.

Right I see the check in saveable_page() now. Maybe it would be worth
spelling it out in the commit message (hibernation logic ignores
non-present Reserved pages).

- Kevin

