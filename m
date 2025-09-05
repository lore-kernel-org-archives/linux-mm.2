Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE105CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5318E0008; Fri,  5 Sep 2025 11:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD0E8E0001; Fri,  5 Sep 2025 11:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14DE8E0008; Fri,  5 Sep 2025 11:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1E468E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:36:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6036DB75F7
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:36:09 +0000 (UTC)
X-FDA: 83855597658.25.493BD57
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1EBC140002
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:36:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IyVZz3Tk;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757086567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+1Bqq+FnslisdW0YRe0dxNCffyMt+IzohJvV6m4RhE=;
	b=5l/J50NEc8nl1l6Zw4NS8Ic3YUp4wTrjaCx2/Z/qSPYMJgVe9cSoqGCYBFvnePurvp4/tb
	MJK7g6lddFCkrEPZlNnwi1A+4zYrxNYVsgGPIBT/PxAjwiC2TQ8wN1+4JrC3X9TPgw4Qp2
	d1Dt1jqXg1ge1NNLyna/W6OsNSbl0lY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757086567; a=rsa-sha256;
	cv=none;
	b=iMxLM293fPp1h8u2inzJ3ccczh/aqiiSUc1BlgdzEBSGIQL8diBp6yL3F/l5I3Cvyr6i4S
	rwpFeb+71SD/7eSwfEGft+wJ39WVdK0drLBwiB4UkmfbPEPMq8LqlZ4xu7pTVbDO1KDU7t
	l6IVSkZXxB+9wywu868sK8AkN+fMOUs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IyVZz3Tk;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757086566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=t+1Bqq+FnslisdW0YRe0dxNCffyMt+IzohJvV6m4RhE=;
	b=IyVZz3TkAQx1DGrW2jResxV7oS0zKFcMst2rXcZDcsb4IxIkJfxRzf8ez4ZtCh6eaAj2qu
	L6wcbS0BiWw9IgdQSn3gfl3+SgEwiGtvsKSjhF4XMhzaI7Bl1ZTYvRQCwwYdRR2eSSD0h3
	VqdlW68JayjyPCQIxs2gawQT2ohd0dE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-ZNNssK1OMVag3wiQg5szFQ-1; Fri, 05 Sep 2025 11:36:05 -0400
X-MC-Unique: ZNNssK1OMVag3wiQg5szFQ-1
X-Mimecast-MFC-AGG-ID: ZNNssK1OMVag3wiQg5szFQ_1757086564
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3dbc72f8d32so1044256f8f.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 08:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757086564; x=1757691364;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t+1Bqq+FnslisdW0YRe0dxNCffyMt+IzohJvV6m4RhE=;
        b=uEcBmdhtj8ZP/leRbfPKo2PIfpot2mwM04T97lwuEuNLigRkFxtK+Uek22etKcQOd0
         LMIeeYdQ/40o11nvWzVKavwOC2f7/JuxwcWYIpBvbDTJ9RfHhQcrbfOM7zw7nXoO5VsW
         5pd49Qj2HEgfFuUID4GDibxv5UhcXNOf95vQME3vJMJfWTh3YcumtYrX4538xakuSrQP
         kYpWG+/PAeIQHMxUOIzV4pSw5NQzl/hO1UfcQTjUXzInILDhBugrcRdpB0dgU/ht7rQH
         PvxttHoRRsUq9Ogjr83CObHBC911SKpZfARfMF0FSJWSoSpfNubcwQV5REDLJStIAeiv
         +4xQ==
X-Forwarded-Encrypted: i=1; AJvYcCXP0p/Beoiuq0qdmarO1PmbA+IYC0OpFAM0Wg3godPez52RxUGdpM4JRJkK9QOF6F/PIHCR7eu4qA==@kvack.org
X-Gm-Message-State: AOJu0Yy134636uqiNzg5NuhzWxM3lQDBwOxn8kDAumxU7YN83KJErKoI
	Mdafylc6UKB3JqDePFo2YIWKeWlI2fmB0F4OEs9u/2dB0IoKPPS+ic+h4cnzmee84By3bcczzzo
	TQ1pNmyWSaCFDVRKDVJGASxarMTfbDHBI2qCJoVqOOOLitiPv0E23
X-Gm-Gg: ASbGnctMMNetYrj/iBnsx67eCCMiSSD1f3EsQlWfGtrm0kPJY3i5f15qWHbfQPT7AhK
	B/ajbvOMjZPjZlfY7eyZFJZcZSzX5/3PpaMi2H0cUag+r6qAhAGrMnoPS6DruTnwTOArorYD0mJ
	itClppe8UbHn7p/aJzzy7zn4MsjMPQPJapsyGvIOqGlW4nxOSN2Oj7E7CdiMkLSFZ+OBZ64NiA6
	lMtNk53xlflttkdR6n8KatZF5EneK1egiKxP3DWjyE5PjlQOPAcc9yJERcPkxBV2ofcayqfScpD
	fQXhKUYBmNNC80+F6l+Mp9aTc3EqJeA+3gGd+eTNI5pz1xDooj8RcnxtNLVlxOwCTWRNWyfnn90
	QqHW9cePrRhckMwsX+GTuTOkVTXcMb3VtDrPR4edW8rtb5xaP/VGER0Sw
X-Received: by 2002:a05:6000:2dca:b0:3e1:6a9f:38c with SMTP id ffacd0b85a97d-3e16a9f0881mr4572175f8f.49.1757086563861;
        Fri, 05 Sep 2025 08:36:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPlMc8QhnvcGKMFuw3VSmRdAqDXHHYXYoy8CclQh9OSK0B+Zxf4DNSi509b0SGeITY1Jg8gw==
X-Received: by 2002:a05:6000:2dca:b0:3e1:6a9f:38c with SMTP id ffacd0b85a97d-3e16a9f0881mr4572156f8f.49.1757086563428;
        Fri, 05 Sep 2025 08:36:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dcfcb1497sm43961335e9.1.2025.09.05.08.36.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 08:36:02 -0700 (PDT)
Message-ID: <ebb2a888-a111-4c27-925e-58bfa8e07852@redhat.com>
Date: Fri, 5 Sep 2025 17:36:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usamaarif642@gmail.com>
References: <20250905141137.3529867-1-david@redhat.com>
 <0cd87ad4-206c-4367-b7e8-9c1ccddc15c7@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <0cd87ad4-206c-4367-b7e8-9c1ccddc15c7@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OhA2J5E0vonuSNJC12ILV7vZpSptRvXPXqOAQlyrhb4_1757086564
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1EBC140002
X-Stat-Signature: jgdqbw1jtqn8ao1k47jyjmfywmrdbpne
X-Rspam-User: 
X-HE-Tag: 1757086566-618655
X-HE-Meta: U2FsdGVkX184KBHhY8LNs7qnj5PjIOcbST8F5T1FnmsppOp3dWNam8jzZiTt4ylZ7u9KDvhc88LSPBsMvTjXvbolaaViOHSCw2NUAFzktgJteQ7cieZK41e83gyeE1tYjeDThrTd7/5rSq+ITJWUxRySaJTPbBoMEWN7tF4iOgIr5gVc8Iu7cjQUSlaMdhXBTQSJbEvl7PIsjvEDQ5EMoY/Un6jsTtnL+6SDXpsHI+3lstTMDSbZhejvRL4Pzt5sjWOwQPyOYy2xxA7CASswEl6Gk+UplzKb9CfNIAGFtOslNvYc/KLH/duQ0O2KWDuHtmxdEzmpNFlWSSdgW0aj1kaY7at/XrNeWJ9y92FC+odfnz3TSKCZV1SX4ng2ZTgxgoZFnA4f5FK0g28QvEKIlEXcGObg7z7mMh8pPoHbLV2/Quua90qg1MVQ4jzRXhxPfxJwoQurs423EWxYrg352Dua8aPugRL05MISSqU1DnIc0sRHFcg3vZprX3ffTFc4kYC36jf69h0y5Dos/0nwADSevCqkN7zikfqdLTR/5Vog6escP2pZLJu96qmHjMtC6f1CmePgHN0AmCZi7VwvTgAQSRKAnmVZYoL3Vu49ghjF76Vrkmap31NWbIOtOtBQFcPPnVXCpceWFd/HJ0vJZrDOwW7KVp3egfwTi8x70K4EU8d8g74aQzQei631iH/0gaQB8QlluRMwahOMV1IavwCnc4aczCYkVlKhfzsWbs7vHTw6srLn+OJXgBCPCWECBEukWpJzuXbMdGgr6HIOaN6EYi/i2pFgi9KReGFgLLS1Rc2pOQRzGidUnfUDvjVwHvALhw7Sp54tWsKSdQ5wc0C7oxmU/gjkivwDlkKp9/jOo0JwPMoTGO5+ZBLiKdxXzNt0NNKdB41F1o4F+LyfG5qtJxkKnXwR+yMoKKDg8HHqU32G6PsqYm7qpezrJ8CBj5t/ykOf8q/oXb/Kp6a
 X7zeBN1Y
 yW7En4LM6OoqY+uVq7vnnbW/9HYnB02Bji9CI7b3SsxDFtV2lvUOnnIJeFAI9vecgq1f2wpnAV1jX5fzbQitIyIK5Sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 17:30, Lorenzo Stoakes wrote:
> On Fri, Sep 05, 2025 at 04:11:37PM +0200, David Hildenbrand wrote:
>> We added an early exit in thp_underused(), probably to avoid scanning
>> pages when there is no chance for success.
>>
>> However, assume we have max_ptes_none = 511 (default).
>>
>> Nothing should stop us from freeing all pages part of a THP that
> 
> Freeing 'all pages which are part of a THP' rather?

I'm German, I don't know what I'm doing. :D

> 
>> is completely zero (512) and khugepaged will for sure not try to
> 
> that is -> that are?

the THP is zero?

> 
>> instantiate a THP in that case (512 shared zeropages).
> 
> But if you write faulted they're not the zero page? And how are they shared? I
> mean be being dumb here.

The shrinker will replace zeroed pages by the shared zeropages.

> 
>>
>> This can just trivially happen if someone writes a single 0 byte into a
>> PMD area, or of course, when data ends up being zero later.
>>
>> So let's remove that early exit.
>>
>> Do we want to CC stable? Hm, not sure. Probably not urgent.
> 
> Surely this is worth having?

Alrighty, let me cc stable.

> 
>>
>> Note that, as default, the THP shrinker is active
>> (/sys/kernel/mm/transparent_hugepage/shrink_underused = 1), and all
>> THPs are added to the deferred split lists. However, with the
>> max_ptes_none default we would never scan them. We would not do that. If
> 
> Nit but 'we would not do that' is kinda duplicative here :)

Yeah, fixed it already while rewriting: this was meant to be "would now".


Thanks!


-- 
Cheers

David / dhildenb


