Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D986CC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8246B00A6; Thu,  6 Aug 2026 12:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7BE06B00A7; Thu,  6 Aug 2026 12:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B495C6B00A9; Thu,  6 Aug 2026 12:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88AC96B00A6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:29:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87D63C014F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:29:48 +0000 (UTC)
X-FDA: 85071380856.12.08744FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9E847C000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:29:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P1T6nSa7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OL5sBD5AHeLDVn25oNMEpQDloi1YNoxgi5Bau+T+ONY=;
	b=cL3E22tNwUuMSl6hwe1PYbuqkysiYFe+XcGorRFuV6bqf2l5ljHEueNWqbflPVdVNG/YbH
	F77+Nt0xQca+LaXVLeB3dzSHxGTyGMiqlRjQ8/kQIriVUdyznKEChLoC127aMn1GnCL7eo
	7gFBS4ZGGPSu5zUWGgTcFh5kKgTeLZY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P1T6nSa7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786033786;
	b=ZZkLK3vs8Z3iBcBk657xRw3d5mTmUq3KCi5jJRtTshRZw2vVgk5SIny3hhga4psjp0pUWS
	b5wWfbic6Qi6mMcl54RNe0CGtR8h02quUGj5FaFg/0KHCTmcvl0F/Dxm7ogcMiWZl0g3Wx
	E0+Nh5kU3W4j44v3MPmk/gmvu1xc7BU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D0B843223;
	Thu,  6 Aug 2026 16:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12C61F000E9;
	Thu,  6 Aug 2026 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786033785;
	bh=OL5sBD5AHeLDVn25oNMEpQDloi1YNoxgi5Bau+T+ONY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P1T6nSa7/6J9hjdPqziiNCkSj9cxGRjrNBfL7hCxLGEVIVMpxfzyDSfj0jiQ8kFIY
	 Jbkn5sNU9wEds87zC6/V+k1vgwytFpiN8es5VBo/B1Vd+jQKNkNnsdrLCxxN2KhOCZ
	 0LEmLyBkfU0puG1BSGHl/nnFxvaBS9dyZwN2JAFtSVx7DuMx83b70wg7H7K96LDVUO
	 1hn0AdoRt3U85VO9MUGxVrDyW7bSpGUqctGqY//Cp7pIwb0r1bMSM3e3sIf2QhoAI+
	 yWDAPyttO/vpRVrcG2unviRW5SbAxpiTF1otf/t4wMI+AqUlby+JU4AJOOwNcEOiUP
	 FGNeuatkmw3LA==
Message-ID: <564e64b2-1b71-4d8e-a29e-dc98e8deb006@kernel.org>
Date: Thu, 6 Aug 2026 18:29:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: fix always draining LRU caches in
 collect_longterm_unpinnable_folios()
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Ackerley Tng <ackerleytng@google.com>, Frank van der Linden
 <fvdl@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org>
 <f616e9fc-339d-4430-43ea-0ec8810c5f3b@google.com>
 <20260801122040.7230a8eb0dc846ce357fba67@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260801122040.7230a8eb0dc846ce357fba67@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E847C000A
X-Stat-Signature: 4e4cqfu3byr7gsq67h1cr57jgojh4r9n
X-Rspam-User: 
X-HE-Tag: 1786033786-567945
X-HE-Meta: U2FsdGVkX1/oJMkcZelr57kf6dVpbZoQIftAnjvecvuXugqTScJfDnWHmATafLWXEZfm2kOZkem7W4CsTZmpXIgGowizlugO+fyshd10rk/Q7yhFFcC9ZBqkxGTjrDTpcYs+S8MZzyKEA+Mh0NhiCYR4eTbjvtOqKuIPdQ+z5dMvbP/EE22RddPMCWd6dglybtLT2eR0RMPg6GXrEaMA96rq0tfv835oD3ictEbpLm2S8MU9kvIdAG1eOfa9PIikYYZgp9TRpuMin74LRjaB2mbbLb6cm1oqmgSI9xMKTNe8EQME6Wr7lJ9LG5VtNy4e3pT1h5L8O8wm8gYNEIGDoKGO+W99yAv9z69tkJXvzLMz0cIUUV43jN1uRbwarvyW0UuvrdXMLyjG3tUxpRAo7r75XOtMaavKILoKtg5gj7LIfiGHKyBfHxtwzlf/nZfPAJlRmKh1R4Q3basNbcZ/JT59roJjXmoj19UHehxGX4/O/YcwC7PP6XkvV7a2nukn9RTOPfgaV7jynp2lWyPUp13jsLWVprOIEgLIeFwvJLnG8phaEK0ESzMuDyO1CpOvQFxQwWDB5IMGk51kSlgrvKt0bJHiuT7WDR54h3rK0amjVI7yGi4r/ZNRA3NJsaeV2n6YzRU8ftKpUeXLeyGeCr8XhBdTU8BmODLpcSsbeilPxezAgrT6e2zs9nAkQzaXfKEsBgfA4to4RiRiNfYXyO0aDpHcl27pY6y7mk2R+XlEhtUdUn7h6R47jdhXzbinNa+ecnzRIfRIjlvj1fKVdUxJmq/Llq7vMYulbR4AxoLleZEVozPFGaflfvsycr2tEq7n1mlj6CpZKNPPTGil/tWVJ4sZ7joJe4gyDfjVR00IVS9mTPZP71iPOzFkQ5MZWpYFYvI/khj3fG8EHCbSJQDBNMGHvZWG4ZymNkm57vSIC8ZoIcnndi1CJLmvjgGeemHf+CWSQ7JUW2gyFmo
 SfTGdlJG
 4QE9wQWqnoQ6YNnCXBaQo+2+n9/qkOM/NBLdZDpxqluJbkVjmsEiO/lgkyk/vEvchL6B3a77aZAJ9TpAM+VdnDZOVAbezcc1nZbrMN0QjLhS5fgRWuW6cJd7mQmAmuDLc4FZWWoT5q4P6ueGCWV7O22Q33EoRptowYrg+Dup8UlGSXsn/TpGb3K4rttMtJ6G8yB2tizJBt5y26S54SdB5Zce7AaldVa0bGsDr2NtNTEBN3ce7fKoEZjaHoAhHUS7BEAK1CAacha9p33U5QvKnk/vrNq6D63IrP5/PqaXn2TS/gPIq4hALy1M3f1rZYnsbrurVyjDnsV4sc7o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/26 21:20, Andrew Morton wrote:
> On Sat, 1 Aug 2026 11:49:39 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> 
>>> Found by code inspection. If someone has a testcase that can easily
>>> trigger this and result in migration problems, please test! But this
>>> change seems to be "obvious the right thing to do".
>>
>> Sorry, I don't (as perhaps is too obvious). And I'm a wee bit afraid
>> that some of the problems which those changes happened to succeed in
>> fixing, might now reappear once the drains are finely targeted.
>>
>> Am I arguing for a delay before advancing to stable?  Perhaps, but
>> I think not: it's probably best to get that working as intended,
>> then deal with any fallout if it arises: just be on guard.
> 
> This patch is in mm-new, so it's still some months away from -stable
> eligibility.

I hope you meant weeks :)

Can we get that into 7.3-rc1, though? There is quite the overlap with
guest_memfd work, and I'll send another patch that depends on this.

-- 
Cheers,

David

