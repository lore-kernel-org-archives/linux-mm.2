Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB63ECD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A4F6B008A; Wed, 10 Jun 2026 09:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A976B008C; Wed, 10 Jun 2026 09:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF2DF6B0093; Wed, 10 Jun 2026 09:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA70E6B008A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:48:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1814412011C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:48:58 +0000 (UTC)
X-FDA: 84864133956.23.FB0057E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5B4641C000E
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:48:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mzvSoMIP;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781099336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3b6jtfHdt+DM81j6PGpxnkEQ5y2+ZVP7rl5UvHWjKc=;
	b=vTgM9Jt25BuYovimL93XwZXn4XiTe1kuKNYKz8Trgt2zfZB7BSG8AFEPub+hhvFp8+uKBp
	wRh3B5GciHFxYEAhdeGLPWbsdf+ghjVAmaELuxDW6dBYnRABgD32UCMfK55P6OfEzuSFTf
	pYKucgDqTN+5Rs1OF6rjfHyrKdZLwQc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781099336;
	b=pm67+jzelAnhnHW5zgyhneYmcRUa4e/SE14X1WOhuCEMcFWnSBNJwH4GEVfnE7/Sytj2jK
	IMAfVb7gbg1qXPkzGERUvGCTUfgrhCewYlSDJ6QeIIgOdpxV7i6MtPnSOUo56Cugnm6GH+
	orGSSQsXZDdHv3bROcpaXCqzJZLveHY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mzvSoMIP;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D52B1600AB;
	Wed, 10 Jun 2026 13:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A101F00893;
	Wed, 10 Jun 2026 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781099335;
	bh=t3b6jtfHdt+DM81j6PGpxnkEQ5y2+ZVP7rl5UvHWjKc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mzvSoMIP2HjG+elecPeQvCOzv41AlCzbrYnx8/aCNpZR1DSmsvpP8n0lzaDlE5X2P
	 Q9lYyAgZ+vD790/sccrE+ClGkAQXFhOBwcRmk8HSxj9UWcv3lofWEaw49k8ogsclrZ
	 FLktRIe0oHUMhvB9qJKFz1ciOVxkB0gCvd10fgubuz2JzMGGnnotn3LdVKdkcFiaWS
	 2VRDDF0lonvOj0ms5p2n9i+VDU9KRnMMowQG7SqnJ083KuvGSWIxMaITAMFbdGr0ha
	 sajcOh3Ka0b8GLxtjL7+vgtRFndLgjo1DMcKvgfM9mZWowIcvzDtMSl4IiLEaBcwdM
	 EEqqqTRkv8xxw==
Message-ID: <14846f4d-3d23-4f87-9d87-05bce67f6f99@kernel.org>
Date: Wed, 10 Jun 2026 15:48:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
To: Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, ljs@kernel.org, shakeel.butt@linux.dev, alex@ghiti.fr,
 kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com,
 Linux Memory Management List <linux-mm@kvack.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 chrisl@kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com, kasong@tencent.com, ziy@nvidia.com
References: <20260602142537.198755-1-usama.arif@linux.dev>
 <aa712058-7b4f-4421-b265-c3173fcad87c@linux.dev>
 <52cb5ce7-ece2-4e52-9e4e-5e476c34f8be@kernel.org>
 <1acea238-0495-4e2a-8026-22d5cbdbab21@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1acea238-0495-4e2a-8026-22d5cbdbab21@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B4641C000E
X-Stat-Signature: kgojssik4pfiyg19ekqbctkohqawxqw4
X-HE-Tag: 1781099336-319738
X-HE-Meta: U2FsdGVkX18Vt11p3i6mNXtNCLP6VaoLwhfWmLAc4y7Bm9+n6LVCXWm1+QVp29Ngs0s9/Ecl0sdEy35L29Hv+178R/MwsICHeYdZostrlAfOuB0ZaS99rQb9sOP3+1nfqRsgXIEKFSahSnZKLfIyWakkkXY9AhkbOyC3tPF7p5OXMwHRzQ9ZirUhR2ALfCb67fL0Y0ZUYtY3+h8g0uEJ3QxU6wXYlIBmMdv27XUqtddjnWtY17/JF5qgH3/RyNMS0uV6anWm0KeaO2pmQLotlNXZweeG3VGHBYvUe8Nj1cL5r97hOXMH+5Y9U4wtTog8/bMN4yEKPehTGYlthZaktJcYkWCMlKU3UpQptCkR204YR1o6F0uvsAMI3bfhIs8/2qNqZ4vDhnfbNRB1I1/QS31eUsvO8/us776W3s6p8uepV4166z4o616QggNU/E8OzPfyZfy4/h+JzIpYB8C+H2ZwFPL5evB5sdT1V0iyJ5Z/zlHGo6/oiUaXJfYuzMswxGfYIBD49bPwlBTpA3bCFIbb3z+7MfncmvPCIzID1ZKd9MFVLnNMovpSnAbunEiKEOIvsAbX70Pput59DZxrSdmFFxex3AsrUWA6Av39koy+AKdeorAOrvLkc2cEmg7kUpqvEFH1ID3eNM2ZacKStOLof8bAW5Sc9q+7ZRF32ViKiHqiFrU6N/XOjMvHFdQf+ipHqXgfg6Bb7BU9DxYDdHiFkL9rO1U1atXaqYJ/s5PIFQTZUVcgftHL94N7cjYB8as7Bx605W1g/XBXlATunZBn8cpPdcib/+h3Fe16TWS6wuOHXJDTpmEh3FywY5jPfEbcGIhB5aizbp1USiy7icIrtS7xD/B8YCiQ2qiDEDArNdwENQARXRqKFw20xQClxIdt50RGZtQhi+L/0Gw+mwNBiEAYWBAx3OKrCu8uVL/Yk18hYviJqgCe9GN1TE9TuKieP6u/81Tv8/DORJz
 +lOwZbks
 eIXAyFPhWpJNz27nXarAwTxedsl8VZXQQssOviPdJnvqDuKvjUUS45Cj0dKKdmaMZfzY2fz4GPbEqLdV4tQrB0UQHMvh+V9HjRyx5U7o9h0yhPL6trkf+m26rDsDBbQonhRqzQ/ME03gbeMm4ggHhvPx6bXJDYLJkMAUT9xK4+GyJwJfQ7Ljrjtanj2qabjzk7QqY/esJNY3JDDCXlVzRlgWU6ra1izUqCDs1RHUue97tSn734XC34X8MuYutgYYU2AmQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 15:01, Lance Yang wrote:
> 
> 
> On 2026/6/10 20:24, David Hildenbrand (Arm) wrote:
>> On 6/9/26 16:29, Usama Arif wrote:
>>>
>>>
>>>
>>> Hello!
>>>
>>> Just following up if there were any reviews/comments on this series!
>>>
>>> I know its a large series but was just checking if there was any
>>> feedback?
>>
>> It shall be reviewed. We just finished the mTHP khugepaged review to get it into
>> 7.2, so we've all been rather busy.
> 
> Right, mTHP khugepaged was a rough one. Glad we got it over the line,
> but yeah, there's just been a lot of THP work lately. pretty nonstop ...
> 
>> (I mean, just take a look at the THP-related flood of patches we are fighting
>> with on a daily basis, it's not funny anymore)
>>
>> This is clearly going to be 7.3 material, so there is plenty of time given that
>> the merge window is about to open soon.
> 
> Usama, I'll try to make this one a priority too. Looks interesting :P

I have two other bigger series to review, but I should soon get to this as well.

-- 
Cheers,

David

