Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EBCBCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F1746B00B4; Thu, 11 Jun 2026 12:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8B96B00B6; Thu, 11 Jun 2026 12:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEFC6B00B7; Thu, 11 Jun 2026 12:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC8B6B00B4
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:24:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F2A912075E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:24:01 +0000 (UTC)
X-FDA: 84868153482.21.8F75F75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3C0171C0008
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:23:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SbxrVoYn;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781195039;
	b=zP1LfJObtEZAslzwLDFch8yYV26pHm3T9hM+G4dqSqgqmX2LycoN9d54bm9bfCS1EEVfhp
	4gjGTBAa592z2afE72k9NXZUzzE+VODORe6OVJyCoKwiHWiigr3trqCCCrYOrMFcBwiEVK
	/NPO1PE/wmaAbqzioY9DBu4auzYJGdo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SbxrVoYn;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781195039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZajxgs8H41vz+bZ2heTynPzuZ7XRleIa9mbFJ8vkSM=;
	b=QpatjipfA7ChU6deIq36+oyXI9jcwK14kOMJsnjUaKE/SzsgID/5FQXrwkNE15fw05/p08
	1TEscQzT2RTnREgY6DNfc55nwPeqwTwSd6DXPgm7cCTBeMe0+SrvGS05XXZgkFRc+HoDCz
	kdBCAGvdtij2hSy4QExkW+523h4BLKw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EF71600AA;
	Thu, 11 Jun 2026 16:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB211F00893;
	Thu, 11 Jun 2026 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781195038;
	bh=HZajxgs8H41vz+bZ2heTynPzuZ7XRleIa9mbFJ8vkSM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=SbxrVoYnzUEhF0dvOc0CbUo8e7jG1jhr3NvuAGR7nMfOSKGxdavR76v2b100bmsSQ
	 nXOx8DQIg16YMD5vee+Cm0ol5PY/W7eOFbfq4/TNoxeqXENspAfs7THNMAgsJFVLFD
	 wd3RdHLKIYPJkXC1Qk/2ByEs5dnt1MW3Pn/4Uz6jn9fg17NOv7JnxQ0hBBma6UoDeX
	 1myU2Y4yGY5UWVDzFC5uwCLNGJhdhAbR1iyXrC3FA5jFWFRtjYLwIB+U9//E1HTIXy
	 yn9fiN9+5eVunEnyvAVq8BHiOAGibvJ6XuuZv6CqRQClULlPzLiLPns4sh3SSNjqcf
	 QB7uwqNqf7lUw==
Message-ID: <58760bd8-4979-4fb1-96a3-eb94f0e8ca0c@kernel.org>
Date: Thu, 11 Jun 2026 18:23:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug Report] Elevated PMD nr_anon after running selftests
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Nico Pache <npache@redhat.com>, Linux MM <linux-mm@kvack.org>,
 linux-kselftest@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 linux-cxl@vger.kernel.org
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
References: <c5401e8d-0b46-4cc0-88b3-f438d610e73b@redhat.com>
 <7e7cbc60-e9c7-4a63-9d4b-4e8fcad7bfc0@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7e7cbc60-e9c7-4a63-9d4b-4e8fcad7bfc0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3C0171C0008
X-Stat-Signature: j45yxhzbfoije1ckrnqe6w1dea7mxc3d
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781195039-864155
X-HE-Meta: U2FsdGVkX1/JfAgeW82WKu5OffYtEyXwBbLDGdFWE6RX+sIJfNrsWTK6v+uPFqPry4L94yxYz+gsWq4DFtwPtjFDQhK1lEaBnMZ8LHypivtxdvYxSZZZEaqmesQ7RwkUv7eBf/8ph4B01pVsiJxQ4glHakC2c2ljSeziHfc/hsIB7ltj5z3jffei+JN/GlzqryHXJ8dZ0BjOA3FP7+FjCG7RNIPt1NNqhuY+x5yVQWJEidmQOLfLzB16smgiHB6FY8VQahtHYGNyTV9hiydWXhVntkXbY+6P8nVs5sezTzPWpncoXw5X4ogEUvTGBuQeQS8oXSUDbMbiHK3GErNobxgvuUBH+j6w0WN2MzCyN/30/sTE/yRc+uJixUS+RGx3tHyaui2wSPxFdgxan0guuMdmPcWxbcj8T90F1mN3GmOCg2sJX+/2o4m01SuHYV32LPO7uMxUte0Hmj49IygjsdFpEDXeInqwQsQBoWEFUqAy5pqn5px5OPW+BqchgM0BPBlatu1JU28Iqs8u0vQhevzbatzr8SWBpcY1xgxI2TQnU+83K47YzoI3aOeBD9xcSteTU5IG+osfZWpDhPYln+swft7BnsC7S1qqIykQiWVNQyNSlq8hvKODk2d2kxOuZm438Ll3Szf8veWZ0eaDrykm6RIU+XAb35x39n2PXd4pQ5AYG5hjPXpUEV3qv0utg6Tpx1jTYzoBvhrZprqi72rBB6EEaj5O8FSR23cOHWTLVGq4lDR9wasHUY4N8b1OyJIqYNOTo6Udx5BmcgwGLljj+dFNxZpHF3lyj95XW70I6phZ0l0TcqGPdxbmKf5BvADouVL55RIsENvyR/pY/TpPnEQCMn546y6IhOFo3ks4gNHg13++nKeTDzrzj1pEJVZO75Du2ebPyiaSO1gEiL4JvaubOBFuBB0U/Eh03KoTpl29CbLAFgPzQ4J9gsR9FO9pF5JpywSI21TF1Jd
 7E8ro7h4
 PgcMHdpJbsH297/MfEWj/BZODEPrekEKe1Mi5F0HeE4zZA8A28kBrrHMsu2157ZnPJp3d0qw13KYO+dKygr9fHvicyk64Ss9xGR3l2G6Tpxsx40lUh7nPeQDnQJotwR83g7XNVP1Byq1JTN8m161fyUAvJ4vyEiYTEzNoCceQbmcqcBhpkxWPZPmqk65hgC19Pm3PMTj0xKYbu3qFtm/IDkGxlEJfHcj6V3Mydw5eBneisyaSWIWVPkX5PHM180TZOyOxoPCzRc/oPE0UTnJ3Yh5WMnz91neDK/j1YL1u/z8GRlex2PNMFodMWzloYwgDrpcgIO3oYUIEpY7HDAQi/JWqL5EGEvaV/NHgK7ROMlysPOA+HVZVEKyqQspzvhMOq80/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 18:09, David Hildenbrand (Arm) wrote:
> On 6/11/26 17:58, Nico Pache wrote:
>> Hi,
>>
>> While testing my mTHP code I noticed that mm selftests caused an accounting error in
>> /sys/kernel/mm/transparent_hugepage/hugepages-2048kB/stats/nr_anon
>>
>> At first I thought I might have caused a regression, but when retesting with 7.1-rc5 (without my code), the issue was still present.
>>
>> This issue occurs in two mm selftests:
>> 1) hmm test
>> 2) migration - private_anon_htlb test
>>
>> I spoke to David about this and he suggested the following diff which seems to have solved both issues.
>>
>> David would you like to send a formal patch or patches?
>>
>> Cheers,
>> -- Nico
>>
>> Diff for (1)
>>
>> diff --git a/mm/memremap.c b/mm/memremap.c
>> index 053842d45cb1..683a77dd679d 100644
>> --- a/mm/memremap.c
>> +++ b/mm/memremap.c
>> @@ -425,6 +425,7 @@ void free_zone_device_folio(struct folio *folio)
>>         mem_cgroup_uncharge(folio);
>>
>>         if (folio_test_anon(folio)) {
>> +               mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, -1);
>>                 for (i = 0; i < nr; i++)
>>                         __ClearPageAnonExclusive(folio_page(folio, i));
>>         }
> 
> Wasn't there another issue with hugetlb?

Just realized that you sent this, but somehow my mail client got confused and
hid it.

-- 
Cheers,

David

