Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A01CD8CAC
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40036B0005; Tue,  9 Jun 2026 04:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0686B0088; Tue,  9 Jun 2026 04:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906866B008A; Tue,  9 Jun 2026 04:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA976B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:26:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C8201C1EBA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:26:38 +0000 (UTC)
X-FDA: 84859692876.07.4979799
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id E1F1040009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:26:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mJaSDUGc;
	spf=pass (imf11.hostedemail.com: domain of vladimir.murzin@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=vladimir.murzin@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780993596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNEiL25jLm9POHPH27wOyewK7kZxaI+xHPG08xT1M34=;
	b=TP0GlFT3BpvKUCswSktHjl9xGx96dcIEdlAMtV5znTy2CYrfZZsQ6NsMc3wg6YlZIlfcK/
	f+UYLczbkVSuqCIjRn4pnVO93BsebwsuN9fBAYD9vODdh/3RRIdmHLxKlCp9AieygNV29i
	ADG9EnHWp53GCPRf1MHvqUF3Dl6ABeY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mJaSDUGc;
	spf=pass (imf11.hostedemail.com: domain of vladimir.murzin@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=vladimir.murzin@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780993596;
	b=6V//PU0tlUZBG/l7GffRwO2Q5ZZyIanAsa1v+90IGbMoWpZwQES1IU/0rnVA9ulS1REaEd
	M3a9ftPHKxu23Grhep269ykodZFqLVpDIuzzO1wPkK1Y/c1wDxv7mcJW5Cvv+yHi0Z+WlD
	dN2eJ0fhiB4jgUZkkJqXqga1Ei8VlL0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BB552437;
	Tue,  9 Jun 2026 01:26:30 -0700 (PDT)
Received: from [10.1.38.173] (e121487-lin.cambridge.arm.com [10.1.38.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF7863F93E;
	Tue,  9 Jun 2026 01:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780993594; bh=Yoo/97pymrQY5ONHYeyzpmC5cmDHw3EWNj3VX3KKs18=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mJaSDUGckTEW2cEbViQ2Y9cbstKnsRfKnWiSBkOsT20+8kN+ghoWrdrovk4UE4G92
	 gj/2Tpf8iA1JtlD+yUL6Ew15movzmGVGJldLk+P4cITzDAI/Y+W3366q2yK018N9RJ
	 V7e5CVm3j2zR/TdePl7zFwH4kY7u9AHYNyBhTkkg=
Message-ID: <4f635592-b294-4303-a045-d529de29875c@arm.com>
Date: Tue, 9 Jun 2026 09:26:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 15/15] arm64: mm: Unmap kernel data/bss entirely from
 the linear map
To: Marek Szyprowski <m.szyprowski@samsung.com>,
 Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Liz Prucka <lizprucka@google.com>,
 Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
References: <20260529150150.1670604-17-ardb+git@google.com>
 <20260529150150.1670604-32-ardb+git@google.com>
 <a1b27e97-182c-485d-a448-56c19c5de2c2@samsung.com>
 <CGME20260609062840eucas1p1d49831bfdb3447e38a3cadc803a9afc0@eucas1p1.samsung.com>
 <6a9c0f55-fe98-4063-864b-8f7e1f4fefd7@samsung.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <6a9c0f55-fe98-4063-864b-8f7e1f4fefd7@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E1F1040009
X-Stat-Signature: aonyqyozm371nyjoaeaq36zj5q8tc55w
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780993595-422271
X-HE-Meta: U2FsdGVkX1+LHJJYH/wkT8tTo42mVCoxIFtz/pJRDchff1S/G6JduBSLo3lU/vecdMu34jC3Het6ksbsVDRVepTVYQc//4tbIapse7z1lz1qTJmhAytwbTAForPn1uDHgsC9u/6EcnkdwUTFL3luGtK5QuCm4/n4UYW5RfLVZV0lLacuKg5evSTdKeAOP2nQmq5heJ/VDBusd8gKD6T43Jii3YkGE6Pb/K4uUcErN3hv3z74fMaoWLqHVvjTW9UIPDA2NfbR1eeu3YKQR2qGFrHvGCtJDyD2JitwFXJh3l7rxAzwtMmqUQ4uP3qSo3MK5krPnVqRufZQxQjNZqTlrtsYNsSrlp9POVoeh39Omk/DM45OEeFJDHr2sBUg8x4DjauI38dFynkJN6w2N23MzbAIuHC20PUQrYGgTT8Gk2LzkjB2k2P2zH4dx6NDkk3WHOFzyllV59HGrkNDqtx3rllfo96kWBt5hw4V870MuqhLvKPPrF4lvslLbXxEu0p7Dilh8iqHizzgio8UPgRKZHt0RNdyZy1Bf5ToS1tKV3gzGeAJhUpeY6QsHjHuDLoSmWQKb+wDy6/gz/Pe3F1v3ePDzutZeU0cndrKppTZT9FATOPxr47ZrJ1Gu6GadIG1REV8DDoAUCHLast781qWVvH2lphKaFZzwzpkCruiCdUuEgBkZbNWpJeRmcSvIKiK2dZoufu2odK4lWZug/8YJYrXyll7ydfIuuhJylcWWD1I/UD7gb56I40850Z/siV65cauWCPp5yyuYndgpYxnMWR5syIvpDOHl+s14qd2RpaMjdOCc21fOYDm2wYps1pzU/6aXX4BgkffLCK9brfQ85YBKBZbM2MTVWx8s6LH8z4AB7bAmK2Jde0q48CNBXni6VbqzCeDTpyDWdvbJKzwnR173Xm43JQsL11RQGfdVl0/mbB8lhkXO6bEgkhXR5R+JusnoBvcLJm2v9vhU/D
 L7iYzip+
 R0/v5gCagmnwCSoHlPMT+ZFOlWYK20pJbPK81PFr3v9Hu6nyKVop2azUvDxnT6GcR7rCKv4ONMphk+XTyw1/aPPM+2t0U2jBjkC4W1q1cy/m46643gd6amewCpsng1UGqI8wOF9wH5xgy7R6QQwoyaD25Sdk5/J55SK4Iton2TdWdXrIYEbPNk34m4YcGnXCXxmD9kVxtWC9CKr/FU9hobxNE/4vetKcKmXMATTeb6jn33UetsDE3XUqMuujljJEbef6rcCGnICGQOPYiEQR8H4rC8Q5Qe8ZiM7EHqPcKaXFtw/WJNnfMGHW793G5/8f7FkLVnm7rY3FjSh1HjZ9wh/orwLzqeiWNePldc319r7cey1BIaJBWeLIfCf29tzg0ip64UHv/8iYKty4Ii0X5NcYhLWWxQ2KRuC2ARPmUyvjvhXK5ieeM8RGn0hkRKhbhljevHv9l4mHp98I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 6/9/26 07:28, Marek Szyprowski wrote:
> On 09.06.2026 08:22, Marek Szyprowski wrote:
>> On 29.05.2026 17:02, Ard Biesheuvel wrote:
>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>
>>> The linear aliases of the kernel text and rodata are also mapped
>>> read-only in the linear map. Given that the contents of these regions
>>> are mostly identical to the version in the loadable image, mapping them
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
>>> map/unmap the region as needed.
>>>
>>> Doing so is required because pages covering the kernel image are marked
>>> as PageReserved, and therefore disregarded for snapshotting by the
>>> hibernate logic unless they are mapped.
>>>
>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> This commit landed in yesterday's linux-next as commit 63e0b6a5b693
>> ("arm64: mm: Unmap kernel data/bss entirely from the linear map").
>> In my tests I found that it breaks booting of RaspberryPi3 and
>> RaspberryPi4 boards with the following kernel panic:
> One more comment - reverting 63e0b6a5b693 and 53205d56212c (dependent
> change) on top of next-20260608 fixes this issue.
> 

Thanks for report! It seems it already has been reported and discussed in
another thread [1].

[1] https://lore.kernel.org/linux-arm-kernel/aicVyebkEMs6w6UV@sirena.co.uk/

Cheers
Vladimir


> Best regards
> -- Marek Szyprowski, PhD Samsung R&D Institute Poland
> 


