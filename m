Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1888CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CFC59001AA; Thu, 14 Aug 2025 13:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380C5900172; Thu, 14 Aug 2025 13:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E1E9001AA; Thu, 14 Aug 2025 13:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 12605900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:00:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E44DC0747
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:00:09 +0000 (UTC)
X-FDA: 83775975738.15.F68110B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3D7471A001E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:00:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gu1DoccY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755190807; a=rsa-sha256;
	cv=none;
	b=M4NTxLSyOXa07q4dpO4J6C/ki5NE1DEW58xbRAJ7E8ZwCzmOGxAYo+Bm+QjL6Sg8H05v2x
	rKMJ5O/HFcbxrrfQHkZ6jVNlS26gxK3FB6h1AZTb7OnN8We2rrmCNnFWPuSgVRNki/877N
	1jRd55L0MKxhaIWuRSYfz7Dqr3j/apk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gu1DoccY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755190807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVrCmyYJ7+hVRCA1extRm8Ry35qk0L+BE8NF8QgnDsw=;
	b=vtqRRb0pDjFEc4eeJD8NpNDOGPVArePTnuQO9hR6LFSK2w48T7TU0+P6IoazgmCLG+CYQ4
	iGDCx1KInatcMVxIU5R9w3U5C0SGZr9eZaB6m3D0YPdDTU3+M4tUPd9eHNTyr10bn+15yC
	q23NJClaI4H8gjVQWQJ3trzu1neILNo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755190806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVrCmyYJ7+hVRCA1extRm8Ry35qk0L+BE8NF8QgnDsw=;
	b=Gu1DoccYtq7Vn0yhy2Y29rA1ye6cThKd5Tz1cojEIJHZIPtirv9IUFAkbZi7XIkdM2sUiN
	wxHMa5VwGxBZdtNexsFs7MxmtxjG7lz6DDtuAjIcyMY76vK8Ow+C4t6yOjpyBKFXnicenP
	kRpuw7KXMrJ5qo64iVjDB2HlU7nLhhY=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-KHwpBnkfPYCE87ieMzdeoQ-1; Thu, 14 Aug 2025 13:00:05 -0400
X-MC-Unique: KHwpBnkfPYCE87ieMzdeoQ-1
X-Mimecast-MFC-AGG-ID: KHwpBnkfPYCE87ieMzdeoQ_1755190804
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-55ce520c261so528203e87.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755190803; x=1755795603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZVrCmyYJ7+hVRCA1extRm8Ry35qk0L+BE8NF8QgnDsw=;
        b=wr0D3jU1Xz1xkcmjt0B49j3H4ReAJyj4Lh5Obp2rSJ9PRLyOpnzc2GKbPwNynoVi7M
         z4cb41mS9Gm5cTYyahEowQlC7r5ynuXvNk+W7AMOEg2D61FrYQ32I/WGijAFLfWVcBsO
         p4THRuuGNkJNWa/+re4lgWxxnvJmE8mmjwqqvp0YFcZ7CvuC5oRM4d3F5VfCZEVxZzNN
         y/fvMeJz1Zdrjo1QHItW535cRd/PR7QmO9AM/WvYnq0AacxpULT3jitbatdA3Ih29ByU
         6/swvOGq0aRb9ok+4ymbBFB6W8P0sQ1Ozvw3E0m3r+MQ3W00jZO2wC/XXH0wLc9PTON0
         EtQQ==
X-Gm-Message-State: AOJu0Yx8Nb4sxEYSHCNzGiUMywbRxJow4B6T3wej3+h8/cIqVGV344zX
	s++qKUEvZhL8aTWXGMxiW/Vvy+89GRFIK2U+IVtDGMY7y+TkrOph408AHk9ZarZA2grX2j+zkhU
	NlR/3L2dPOeGmdrexoz46GxO0MIlFrM79DooKlwlZ72epoBm0WN4=
X-Gm-Gg: ASbGncsJfVLYpcka+/1BZFGRAH6KY2ZPTWzu2wgN1LdL5t2+abf6l5bPWqLhFlzVNE/
	C5Ir29+9oueoBABjqx8H39sss5rKzud5wN3zMS53hjcMHLWfpowBzF1E+vsEDflupiEfsw/wn4D
	2rYfOf8BjKjPO5XxC6uz8FlR/1SVO/k8Aq5P09USGV8fQg4/nEhycMBaK4b+IGPuwlu2AN+y8gK
	x0VYpBmEDFJ7UTSHqbg0JoIl2ezIqiqtuHd7bd9QVIxONIKRTkwH06xvwRrun0LTobmdmG/XjNs
	W5iZ3/+YnoRKaAOCaDlBky2zluhHS9roGcOJsG7KhwXeeRRSinrASZB3NFLXaIjB5w==
X-Received: by 2002:a05:6512:32d3:b0:553:2e37:6945 with SMTP id 2adb3069b0e04-55ce5029232mr1515215e87.32.1755190803374;
        Thu, 14 Aug 2025 10:00:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeIK5K35ICkkmYZHKZpv6mu77wrgGmsQiud/3+kKsoxMAm+BhkPNxb08y2Da10qFDFHZ67Og==
X-Received: by 2002:a05:6512:32d3:b0:553:2e37:6945 with SMTP id 2adb3069b0e04-55ce5029232mr1515201e87.32.1755190802869;
        Thu, 14 Aug 2025 10:00:02 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55ced007873sm711e87.63.2025.08.14.10.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 10:00:02 -0700 (PDT)
Message-ID: <c7bbbbc8-b9fc-40f5-b86f-e43b9a85aaef@redhat.com>
Date: Thu, 14 Aug 2025 20:00:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] mm: use current as mmu notifier's owner
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-3-mpenttil@redhat.com>
 <20250814124041.GD699432@nvidia.com>
 <2da9464b-3b3d-46bd-a68f-bfef1226bbf6@redhat.com>
 <20250814130403.GF699432@nvidia.com>
 <67b6e041-4bea-485d-a881-cc674d719685@redhat.com>
 <20250814141136.GG802098@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250814141136.GG802098@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gSaCSU2Zmu-okq0hRyhsyjBBfjRRX9P4WJ7WpJlTjW8_1755190804
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D7471A001E
X-Stat-Signature: mjdwywk8yn5jcr4it4kpnptaaum16y9i
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755190807-829644
X-HE-Meta: U2FsdGVkX1+Ra7ABBdRprOmzh+utb8HRIiOdPKXnkPYQO8mQJCk7xfSeHu6XJ9+ZbrckJDbXgJtXOiV6NXYc1j1dS/LmXoteOkf+R8lqtz/fQS6cF6rp10ZC/ZlScZAmsGbKbGO6dR0O8eGxp9+NskCFHWyIkW84MDwaNIzQVSDo26M+51pb+898p7JL6MsomRkiJhQg/uQIu64N5iBaztCSvERnNkglsJX14b2vnKYfuXNcl6fpb/S73hnPvOxhqOy3PNSRR0/iOcZXFhpmCAmoppL4QgL348kWwKO74pE7AIylPo37mEUMSJjEwykytjHA8CPTcpoEf08iyRLiJex0BwuQlW4rMiu/raFWDsWc6YU5ePdPNvEz4/3pMUV9z0n3djqevTAp/vbXP6ipWpRvANy6PvdramM6i/Q0O2s7y0n9uCPNw/o9ytEq9RHsDVuTFUoL3xQdvgMGzaWMhF455D+PFkuYE9Wb+2Qq9OQDy5Y4r9+9wXO3kAJkkrmiMzp2FEkreJM5sGCb9VFosTxcGebUD85GZlyUvv9eHVazEegw7aEfzJNdN8rVCtNBRD1Ok+ifauWOqj700LP8bSDjcI5j4i6gVNOgnGtrM49uCdtiWeYL8Jn/OAsdBg4JV0n9VVTrn+aiNaehllOb0aISSbbpzi5k6bYNlCkEltkOM4VJAS2GWGDJqEsArzzn3db2z4MDNr6AZYIXzKlpDjVLO/q/liT9zbs+cHT5SAp7tNhHsT5jCIvx5i3nvIr2zkEjom7wWIWYJsLwDk23fXyfNSvEN9PK6QVA3TYiaDwumX/R41S6AMv/fJHhVPTrQ/bYhu9Pw8EuH+h6NfXefmpcrVl+iyA9BpVmAaovCZAxkWuyBcf1pY7tJN8D15g1lRMlmJ+aw8cbNc3Ka9tnqIjIJgAkjQcJ/eEXarhwb70k623TZLFw/CG2pF1j3smGEpkZyuHDDoSviYFNFqZ
 j6Tf7As6
 Br3TDPtaXQhtUx17dNNSAYcJD+oPB0aTmVt3ldcIQF1hUMxU60KLdO0+neOMIYNVphO5b8073+IS5GwI4vjK4ViapP3Pk+hkSpYOhGNTffHFuJPhLke1C9mKxK8bNXJUaKBc6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/14/25 17:11, Jason Gunthorpe wrote:

> On Thu, Aug 14, 2025 at 04:20:42PM +0300, Mika Penttilä wrote:
>> On 8/14/25 16:04, Jason Gunthorpe wrote:
>>
>>> On Thu, Aug 14, 2025 at 03:53:00PM +0300, Mika Penttilä wrote:
>>>> On 8/14/25 15:40, Jason Gunthorpe wrote:
>>>>> On Thu, Aug 14, 2025 at 10:19:26AM +0300, Mika Penttilä wrote:
>>>>>> When doing migration in combination with device fault handling,
>>>>>> detect the case in the interval notifier.
>>>>>>
>>>>>> Without that, we would livelock with our own invalidations
>>>>>> while migrating and splitting pages during fault handling.
>>>>>>
>>>>>> Note, pgmap_owner, used in some other code paths as owner for filtering,
>>>>>> is not readily available for split path, so use current for this use case.
>>>>>> Also, current and pgmap_owner, both being pointers to memory, can not be
>>>>>> mis-interpreted to each other.
>>>>>>
>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>>>>>> Cc: Leon Romanovsky <leonro@nvidia.com>
>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>> Cc: Balbir Singh <balbirs@nvidia.com>
>>>>>>
>>>>>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
>>>>>> ---
>>>>>>  lib/test_hmm.c   | 5 +++++
>>>>>>  mm/huge_memory.c | 6 +++---
>>>>>>  mm/rmap.c        | 4 ++--
>>>>>>  3 files changed, 10 insertions(+), 5 deletions(-)
>>>>>>
>>>>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>>>>>> index 761725bc713c..cd5c139213be 100644
>>>>>> --- a/lib/test_hmm.c
>>>>>> +++ b/lib/test_hmm.c
>>>>>> @@ -269,6 +269,11 @@ static bool dmirror_interval_invalidate(struct mmu_interval_notifier *mni,
>>>>>>  	    range->owner == dmirror->mdevice)
>>>>>>  		return true;
>>>>>>  
>>>>>> +	if (range->event == MMU_NOTIFY_CLEAR &&
>>>>>> +	    range->owner == current) {
>>>>>> +		return true;
>>>>>> +	}
>>>>> I don't understand this, there is nothing in hmm that says only
>>>>> current can call hmm_range_fault, and indeed most applications won't
>>>>> even gurantee that.
>>>> No it's the opposite, if we are ourselves the invalidator, don't care.
>>> I think you've missed the point, you cannot use range->owner in any
>>> way to tell "we are ourselves the invalidator". It is simply not the
>>> meaning of range->owner.
>> Usually it is the device but used similarly, look for instance nouveau:
> Yes, dev is fine, but current or struct task is not reasonable.
>
>> Yes the commit message could be better. 
>> But this is essentially the same as nouveau is doing with 
>> MMU_NOTIFY_EXCLUSIVE handling, just not using the dev as the
>> qualifier,
> I wouldn't necesarily assume anything nouveau is correct, but this is
> certainly not the same thing. nouveau is trying to eliminate an
> unncessary invalidation for it's HW when it knows the memory is
> already only private to this local device.

Yes but it is omitting
  mmu_interval_set_seq()
in that case while returning early, which is ok.

as well as hmm test module with :

         * Ignore invalidation callbacks for device private pages since
         * the invalidation is handled as part of the migration process.
         */
        if (range->event == MMU_NOTIFY_MIGRATE &&
            range->owner == dmirror->mdevice)
                return true;


> This is not a statement about callchain or recursion.

In my case the unnecessary invalidation (self caused) causes hang,
so whatever the reason for unnecessary, the mechanism is the same
and used elsewhere in kernel also.

So technically I think that would work. But there are others ways to do that
without using owner, so will look that way in next version.

>
> Jason
>

--Mika


