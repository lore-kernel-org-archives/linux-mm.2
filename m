Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5E9CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB336B0287; Mon,  1 Jun 2026 02:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34296B0289; Mon,  1 Jun 2026 02:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFBD46B028A; Mon,  1 Jun 2026 02:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBDD96B0287
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:26:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6299012050B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:26:24 +0000 (UTC)
X-FDA: 84830359488.01.6694083
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1BA6A000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:26:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UDWGUBrq;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780295182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilE3N4BOTdn9nDgsIqVIX55BotssAoPQjZsa6oIPMLY=;
	b=kRYi7eE7mYL+1X+HPkGjjXgT2CrxhV5qEMzH3gXko7ckR6s78hRPz7CEwIA2DPgTQIevRL
	YE7SycZIx5mrqU33zfI7mUWki4zzcwYTwDPpCTzw+1X+0Uz1uyM8+I3TMSYYElYQPcIxjQ
	79Quj+KRXav67/8YB/iKyXB7rDawnyA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UDWGUBrq;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780295182; a=rsa-sha256;
	cv=none;
	b=Su6c0+Mx+pvryF20oi26PUhwE33iXwTdaY8OsBvE9IJ7EU9O8ZBViSQ6H3TkUDc2FkrBiX
	bQQcYFSAae9Bvci4fl5a1yG5IeKf6b4ZeocMM5FTkO0qlzraJWFDvecPFCvVep0tCc3hJy
	qM7avOyGaC/fPzeRVODmrevjqew+T9I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88BA0267F;
	Sun, 31 May 2026 23:26:16 -0700 (PDT)
Received: from [10.164.18.45] (unknown [10.164.18.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E34D03F905;
	Sun, 31 May 2026 23:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780295181; bh=3+mbuSOPINRIL9Kin6A2TyWfF8smoqgqWi2QxpvIA04=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UDWGUBrqwtsm4H1kD96qnayD0Gt/6wSVCIxG5vO5Csj9ooOqWdtqv2TeXpxpgnnkD
	 JaX1+6lMgNLdmd3e7hD13QzppuwXLD7Jmq9oTWar6RVvfw6ik0y113eW97KQYI2P0g
	 dygsfiUREkcoUVD64lZgCrEQV8KPI7LXd7k6GL/w=
Message-ID: <1e50b8f4-22ae-4ff7-aac9-fa3242bb23ca@arm.com>
Date: Mon, 1 Jun 2026 11:56:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 01/14] mm: Abstract printing of pxd_val()
To: David Laight <david.laight.linux@gmail.com>,
 Dave Hansen <dave.hansen@intel.com>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Usama Arif <usama.arif@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-2-anshuman.khandual@arm.com>
 <74f66e30-ab3d-4352-89ef-1bccc7e9daeb@intel.com>
 <20260521104206.1c7d3fe0@pumpkin>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260521104206.1c7d3fe0@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A1BA6A000B
X-Stat-Signature: auh4aaybeghync1hceriyxsk8gj9co1t
X-HE-Tag: 1780295182-250772
X-HE-Meta: U2FsdGVkX1+zeHxbSY9C+i2EXhYUhnOV7KrNS0GnmBGcP5sRi+599IL4B8Y4NQo2d7YAN+vYXJgkNYD0cJOtBk1QT5aLezqEc5G8DVPH1QDKXldEfWwzylXJXuhtRd/y6tBDACkW/URCnTiR9t+iigtI7GW4ldpPoHiXzTrknxUKnT4qWF6OWLdHd5meYEuxTjOOZyQQSnSEEmPesN6Aw316rqHCsSeJBWISyX1+Ij6uhETAVGp7RRppVaUYWOjJX7hmjT/D2hsc4lOBO5Wb4AIxV2kbOBiWAxzxZhEM5o/JJfETlqFV6gTrL9am0mXelwaPU9eiKlvnZC7s6IaI45ToNWoIh3hM8PF222RAeJWSzIaMtHTB727YAOep+QxeBwwI1rix2RbaAJhhSEWzK9i4gICs1Bx9QMuVnBaw1S9OWB+3w4Pow1yCvX7lDiP35Ti022JaJ9DLP/EnzRQ8q8K6QHaALDQq9eiim5tJp3qRGYhb+48ttYCye7vUTxYTmN0ge3n0RgOu6GRVdZgwkWRRS3o3cEuczgTr5s69HgQDTaYcxcJwQnJ7IksVqFri0oNWyIORvaXZGBKMARyi/cIYfCzz1vLC6Aa8D9ONVenS1SpwD1Z1MIEgq9QygP3jHa0q2CAKmL5Azaq8LFidwp0AFWT4Mwet5Vg+ZuRh8hPqOL0Qxd/jhTExx32Vi9wzdRVRxDG+x3GZ3Jjv6BRSJK4ObtuROCM0FawrLg8OseryFWOXNfktDcmn7HxeW97OBi428d0X5ZRiI2UNbS6LYTQnJGmmkCcBBxGXaDq4odU1ZEMMwXAsiD9lUtVwWGN9yBrQT9YRoeKI0j76Sns0IuptABLokTMlicZYrDlchBHmKn9uPi9FdNkq6WxRXvzJmm23k1u3AM8H151XujGcXjGZm0PgUhwpI08k/1Rj6CgEzOSdDx/lf46twssTl+Lr4pjUXVYqpnWjOT40N8o
 JfHC5RR5
 chQa65vKp1hioHbm09pH2uWUZUptkrb7p9nEQ3IOFrhQkrE9/EW7XETkQHf7PMSRVZjl/LHe3vg0iw4pTgwSRiNuSp/MNmz1YYIYCwUdi9+Up01+nlYd566XUukI8mUHqZ93L7q2iygKidCXqQtWhdhA52ZQXdVeF0Ytc6hLsr3rzZ45unRabq0CeP1Byw3M7lcl1fxZdwxfkDGUaC/CUUE+6VWU8z4rooKbA0kTclBwlMok3/QVxsz0Im7QG/ZLt8mjuKbk6Gp5iU/dR0lHhvspOncDd6hzImhaHB/tJECdWSTC1ahvTeczHZWv8cVlPPAuMiPq9tVEXH/vX1TUiV43gRtR/h1rh+z4WozF5eGdVL51yBIUKV7yq7i6tw049IE8oFi2v6KWKd2/IP8m75B5QuxlMZcAWPhsdEANM5c2mpTSYZ7+V7sQgBfbljt4roNYVmfio1pCF24U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21/05/26 3:12 PM, David Laight wrote:
> On Tue, 19 May 2026 07:28:17 -0700
> Dave Hansen <dave.hansen@intel.com> wrote:
> 
>> On 5/12/26 21:45, Anshuman Khandual wrote:
>>>  	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
>>> -		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
>>> +		pr_alert("pgd:%" __PRIpxx " p4d:%" __PRIpxx "\n",
>>> +			 __PRIpxx_args(pgdv), __PRIpxx_args(p4dv));
>>>  		return;
>>>  	}  
>>
>> That's not the most readable result. Could a printk() format specifier
>> make this nicer? Maybe use "%pT"?
>>
>> 	pr_alert("pgd:%pT p4d:%pT\n", &pgd, &p4d);
>>
>> I _think_ it could even get rid of the p??v variables.
>>
> 
> Adding another %p variant that is only used in a few places just makes
> it all harder to read.
> Perhaps a local helper that lets you do:
> 	char pdgv_buf[??]:
> 	pr_alert("... %s ...", ... fmt_pdgv(pdgv_buf, pdgv) ...)
> might be a reasonable compromise.

But will not that also create a similar code churn as adding %p variant ?
As mentioned earlier a draft implementation could be found here.

https://lore.kernel.org/all/1d694f9d-4f40-428b-aa28-9d6e0febd54c@arm.com/

