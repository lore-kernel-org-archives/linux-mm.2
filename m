Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8EFDCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 08:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA6B8E000F; Mon, 20 Oct 2025 04:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1BF8E0002; Mon, 20 Oct 2025 04:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0B78E000F; Mon, 20 Oct 2025 04:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0857C8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 04:41:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8EBA86CD5
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:41:38 +0000 (UTC)
X-FDA: 84017849076.17.70E5386
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id EB501C0006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:41:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DqB4ZAUz;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760949695; a=rsa-sha256;
	cv=none;
	b=pZlueuea/JMSD15scJZoH/+ehNOsc5J2zGrMEN9msiGkV8x0Q1qjq09GbSrLMa3SwqgCdk
	Tv0qgcu+Wkfxo6FHT3CetPrMLKJpCCLRaPk70peixTIm9hW2F42CBdeKjBA8WgD7+p1ejX
	mvCh3FRkSpGOJNRa9oU1FSyNyNRqaM0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DqB4ZAUz;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760949695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3U5rH6VCQJeyIqlNEvg4+9+sRmixO07jGft8Tq1QypM=;
	b=emLX6fURsoZGMGv9NiV6fsE+8+edJ1ghkVrzlY0HKYgRUcVWJdEdP5RbmiAnCGIf/xyXyY
	UgrU0vSshSv3UuOXQTgoCSn3lAJ/yiL5ncG+Do4LUwObtd8Uj962NiyHwHquF80vr74GfN
	I/S8EganBOrN7RB0J1WPmPLd/EbIcOg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760949694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3U5rH6VCQJeyIqlNEvg4+9+sRmixO07jGft8Tq1QypM=;
	b=DqB4ZAUzzfe97S2voLjy1yuSsrZYNOeGk+/yw8t4o3zVRW5E1d124xjIwB3mIMz2b8PUTm
	ktu+vJBauKudo4au/KxfgsAYfoybXwwL9CHWPZ36+jrnnh9otY9q6IwcTn86AOjolUa8Vr
	88SIbtTYWe60x8X6ATw6VYJLtlHnv30=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-QBTPzR_gMLaUG5FxiYQQwg-1; Mon, 20 Oct 2025 04:41:33 -0400
X-MC-Unique: QBTPzR_gMLaUG5FxiYQQwg-1
X-Mimecast-MFC-AGG-ID: QBTPzR_gMLaUG5FxiYQQwg_1760949692
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-470fd5ba449so14373455e9.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 01:41:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760949692; x=1761554492;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3U5rH6VCQJeyIqlNEvg4+9+sRmixO07jGft8Tq1QypM=;
        b=lcCJQL+5w/DdJwdt5t+AIDpGDwhTPUfO72dkdFpy/rIwdRRh+Njx4ZiWhbgs6H5T0L
         HxsbZhiRy3haNE3MnADcaK6vmKE+z2UaV2vyoby5Fy2e+W1r3HMQxkkmiX7SOMsQqY30
         GrOrq2/z6vF2nuzb7jlt/xRgazJzKG+KZXxSkFcKpogK62otwVL0jYczZLZcKIDDTDZK
         1zCl2+PKBrL8HwaaB8l429bjNkwJ3H/rZuZwUQwud92oxX60g2M0GpZctO9OgPPt900C
         +bs0gh6dU+nESVXtB71Jlr60eZooSnaDu7JMA591uqb2Ue/KoYD+TsbiN16NOwk2dBHA
         TnFw==
X-Forwarded-Encrypted: i=1; AJvYcCVHB106Y0hKmmPbTDk+8EPeF4EGeg4E4xQ6FlYcpW8pSn72ZG257psrlqvSvYNFitVFiQ6rC4EYPQ==@kvack.org
X-Gm-Message-State: AOJu0YzKuk08VLGd8UA/5rH6EzMf9tdoh29A+hg/VO+nCb48hbUWa3MQ
	+stIBN8HC4j4LXh58PROwpz036xXNhUq8gxnigrtjJzNeaMY/fOjFtC+4xXbeW1LTkKn0T7BvhK
	B2ewvC/9qqnc5cptA2WbN/eESH9ewPR+xY5o2E9pYMHczGiCYrEsr
X-Gm-Gg: ASbGncvL3d7L60735Sxt560TOr5BoYScweLF/Q+pmZUWD1EczvHJo1P23/RM1hefE+W
	2odQm1nm2ylpaACl+GBUqwscWzCAhINICxxkX9Z82OIOPek5J7vqW0rJGHOUdaNwKk8Q5coZtJM
	k4JmDBVx5BUP4ec8XoY6D0Ax42qZCgoXfI40AU1ICgiSXOIv5EjOrmGG8b0J3wEeeyc36fzOZG5
	2nY6rM6YfP5SQCqzVrYq6dIk4RjWJk/vp+HEgB/fVK4WSRUhuJZHC8ZnDjC/ntRo0qiAHiZoWiC
	x55sJCa96eK88RpNFIPJ9Cbgr4JGrIozSB4eXj5WvDhwgf7aZvFXoy1NYDM4ARNOA7bW34lQCSt
	Hftdc5ROtxmYvZMRdyybqJy+CAHVLlSm9pHuwaHMHmIjY8F6Ubx6SCazERW2H/zaxqfx21tmLTn
	QRM+bB3uj9ZJCD1jFGoTsgB4vNiQY=
X-Received: by 2002:a05:6000:41f7:b0:427:548:6e3b with SMTP id ffacd0b85a97d-42705486e44mr9085839f8f.13.1760949691740;
        Mon, 20 Oct 2025 01:41:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGtvbw0Lrl9i4z+HwCLH5RJB7pExiJlS7u8wTdbjX445/94A4mdOgKmXGH4NxxYxpJbuMvIw==
X-Received: by 2002:a05:6000:41f7:b0:427:548:6e3b with SMTP id ffacd0b85a97d-42705486e44mr9085800f8f.13.1760949691255;
        Mon, 20 Oct 2025 01:41:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00b985esm14635943f8f.34.2025.10.20.01.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 01:41:30 -0700 (PDT)
Message-ID: <748cdc18-e32d-41bd-90d1-a102b1c51e06@redhat.com>
Date: Mon, 20 Oct 2025 10:41:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: KVM/s390x regression
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Balbir Singh <balbirs@nvidia.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Liam.Howlett@oracle.com, airlied@gmail.com, akpm@linux-foundation.org,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, dakr@kernel.org, dev.jain@arm.com,
 dri-devel@lists.freedesktop.org, francois.dugast@intel.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, lyude@redhat.com,
 matthew.brost@intel.com, mpenttil@redhat.com, npache@redhat.com,
 osalvador@suse.de, rakie.kim@sk.com, rcampbell@nvidia.com,
 ryan.roberts@arm.com, simona@ffwll.ch, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-next@vger.kernel.org
References: <20251001065707.920170-4-balbirs@nvidia.com>
 <20251017144924.10034-1-borntraeger@linux.ibm.com>
 <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
 <c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
 <8c778cd0-5608-4852-9840-4d98828d7b33@redhat.com>
 <74272098-cfb7-424b-a55e-55e94f04524e@linux.ibm.com>
 <84349344-b127-41f6-99f1-10f907c2bd07@redhat.com>
 <c9f28d0c-6b06-47a2-884d-7533f7b49c45@nvidia.com>
 <f5debf87-0477-4d6a-8280-0cd95cd09412@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <f5debf87-0477-4d6a-8280-0cd95cd09412@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wlRo4e4pax7mYDC5s2DqZxbbHPSZxJtAqg4swtUEZx8_1760949692
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 75affp8k7wa331nzwz9oczwssf9cbfjy
X-Rspamd-Queue-Id: EB501C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1760949694-870064
X-HE-Meta: U2FsdGVkX1+Ogxe0S2YcMXMGLcqy7rhhtHCXoN+YiJZ7viy7m1Jzg7akfoPTfpGdCYWDsv4Lz7pStjEEpPTUxsWYGVAiy5dbgd3uTFVTu2QpnKB6uFYV1I2VBBMMA7TF+ZbxUnknd99BM5HqwT3o1KsBC3lw+SDttHt7k+uvEwbaZrrEE4EZI38VGHLA/l+/4e/okP3zUCnzF/g5L9AuB0PKbG+hAF1DY4Oc7njoFnWMvYjmlGAXoNGi5tuDHvqBDN1eiV/Se7jDNIEatRXtIDTjno3XSyYsI7LDzShwuslR3QDz7gVKmxCjGd/IXLipM17PqrTEH1nntgW4VNWMLZhwlinnOS6ZdGt3CulvJRBI5/lDuv69UPXwqpatt9+8z5pmGXuA6emnKuKUt0q35wogv3tQ00PoDJB6ghRFGSf4MqBFLDrbslqUgSMh2hFGzLak+nef0RiGpCDpO33l5CTwXbuMca02w58ZH746k8128fxCm/Q9X5lkJK5+L02XnMsmK7ld3N+P15R3zrzMHGN6KqwVYgIzF/OBBPAFTp8cV3c8n/14bLyTeNCaqfTE8QgZEOOuB8ZvzBzLvDEF5o0229Q5oSmIy8BCSxbz7aRg4xwSPkUQUdA3uIz2cewNeIteyrzC/OI+5luepJ2vSajd8p+tWoFmmCu9zayViFEYoYNl/9LshLcvU+78SNZRS0hCXj+hTlbAZDeYhhaeouIxWkTyFhU0ESnC+IriBb6cApUkaIiavEMZ42yvONYIIRpnmNXYuV5oaYGrcmOwYH+FOf7u0UcmYJ3j1jZ0QsX4JAhaDgAu2Pams5Jzs+ehtHEM/JJ5y6y5sKTdj5202zE997FjcAOs0vTfAbTMNShazXnro76s6HY3yny4FFDtFZuZcvVKzthu71qtypkTvCvHLZidOglx3dG8ygJ08jRmZctQJxpEa8L2QIkoyzVetYo2oFBr4AAtayeBi+U
 4xlI2yaP
 omatWEy/HF2d0ud6nk8AcUxp3k0+YkiFMl6FOCAnA9gASs1Zn4MThFPtQdfqyHfETQhsZFshh3MOJh49JGF0MgQBDGpJt4uodUNPOQNjiV3JpCl5gqgF9J2d/iUai5dFBjAWRtS/HTsDnggh8luMYmV2SwXTWm45qJZ5nWMoO/p4D+lZO1r6wFfjLBpHzjFAuP8QPGpYEnBrBYy5nqsVjQ0CJ05dKoWsTFd+so0sd6BjieAqMUhv1SOmGN1/RD56kbE674SbGd0chMC9f59QF6SYVZaiQnZ1MorQlohV8XUiTBIBZSc/iAwu7QE31cevaHNxXFVC7mxyP7nBHAMnQBEPsBoiDmXXUBmu9pKG31XqxMZHpIIcJPKkVenfRgQOG2LgfFGXMAVnSQ+fcIst0Oc0rTnVa95JE0+PQ3U0dkkSOLa4X+cTzHwS7W6mPCtm4nFXPCqG7g76wQWYRWCtM1zsov6+Yil12uuDv19N0yKB2Pimf9bky7PfjyfZ/D2crfIDwVntFMhcsoLRRKOy+ZRffTvL1SzrazRfR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 09:00, Christian Borntraeger wrote:
> Am 17.10.25 um 23:56 schrieb Balbir Singh:
> 
>> In the meanwhile, does this fix/workaround work?
>>
>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>> index 0c847cdf4fd3..31c1754d5bd4 100644
>> --- a/mm/pgtable-generic.c
>> +++ b/mm/pgtable-generic.c
>> @@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>>    
>>    	if (pmdvalp)
>>    		*pmdvalp = pmdval;
>> -	if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
>> +	if (unlikely(pmd_none(pmdval) || is_pmd_non_present_folio_entry(pmdval)))
>>    		goto nomap;
>>    	if (unlikely(pmd_trans_huge(pmdval)))
>>    		goto nomap;
>>
> 
> Yes, this seems to work.

Right, but that's not what we will want here. We'll have to adjust s390x 
gmap code (which is getting redesigned either way) to only take the page 
lock.

In the end, we'll want here later a single

if (!pmd_present(pmdval))
	goto nomap;

-- 
Cheers

David / dhildenb


