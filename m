Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E7BCFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 08:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A126B0029; Fri, 21 Nov 2025 03:02:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA086B002B; Fri, 21 Nov 2025 03:02:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627186B002C; Fri, 21 Nov 2025 03:02:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5502D6B0029
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 03:02:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0601212E9A7
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:02:13 +0000 (UTC)
X-FDA: 84133871346.02.B0BBF46
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id A600FC0010
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:02:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=taEnaWnq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763712131; a=rsa-sha256;
	cv=none;
	b=RB+sX6ThRAkRHGfo/gpYZdocGAAPw+8qh2LtMXYeXGbo1XqjiSyNrfVljkN8j0/M/hcKBQ
	LBXvGno63/485iJLmfFFS9Ptcrmfpj9cB7Lyv80VPykwLpbtwBQP2HS08KbuIhMratCBl+
	/bE/12MTNAlZbR58b21dWSdnZnkcH+I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=taEnaWnq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763712131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jsx1i9elE0kDy4CTyd+VjXt9Xr7+9oM0mXmmN+UPkWY=;
	b=K/ByfC9dNcFQNC2UC778XUpNT1KbUXIJX6xiQvP40cFvZoqS54M+6ESCPbubjmZNPZ1Onz
	uNFOTO7QUsIJUhC707L2jqKexJJwwv/EBckdZ4oTyDDdO4bQ+GzuNymfM/akIDN8HqnS3e
	PlOFmcTcL3cZ/4trIroC0oAsJXYXBdc=
Message-ID: <9f41a142-e640-4bf2-86da-234e2b758a0a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763712126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jsx1i9elE0kDy4CTyd+VjXt9Xr7+9oM0mXmmN+UPkWY=;
	b=taEnaWnqKI1qjRkC8sjACrh6zOxo6tHvxfEgfzFsPVjEj3u57ibs7qBmM16cc1EKavRs5K
	kR11+LgUdgSVU+9F1+MxkChLBosbnglXHf7NGET+/sGrIqBrCB7T+6fgZf9ksEZ1bGWQ9+
	IU1R2QlzzuIkQxSy3FVZqwKhUty8WZ8=
Date: Fri, 21 Nov 2025 16:01:55 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 21/26] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <d5d72d101212e9fb82727c941d581c68728c7f53.1761658311.git.zhengqi.arch@bytedance.com>
 <aR_ZQjoAA9CFwcKG@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aR_ZQjoAA9CFwcKG@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A600FC0010
X-Stat-Signature: 7imdd9koectedr14yy7hbnjqi15bweyu
X-Rspam-User: 
X-HE-Tag: 1763712130-489792
X-HE-Meta: U2FsdGVkX1+bC6diCDJabbKxY2fn9bzIby+ZxN6k4q2+TvzKv4bYE6qcUNfbEvTjwcznbMlCoXRA4FApzmRsxhds9S7KyysM7cgMKLpLH1jhnWg80SRR81y00jDAtv0/abrR98vJl+OwtyLUVblqhAthH+bXJmUhtvJ/1qKJnZe9807yz/ssVg3aUiuPNPrL3G7mHEti8E+lh5JeLUarSnqroaFAaMPAOdcRMszCXMZKRyTVE4KncffJhnA9/lRbfBZiy2zFfWLRBsGXL584KYY0corBrV8cHttDtkE+SxrLOnGAmBolNMsqlurJqDuTl6e68LbljIeGa1XJ0xEI20Lwk0e3Ml/irzzKzYE8Sam5JsYvurqmbjoEXwDqUIiGrqLcXPPcEQHdYbNJv5sPN1RN5p8yR6clNkRViwsqbI9EPMyiSpurBlxg7TC9JlwFlMuNPnz+VGFlWhXXbu4U2qhl+4veRSo8LlM1HDil1yN7QT5NengAQrHEfZF3F8gfc6qKqc5m/iu9p/1ADPcvPIEuALkPLvu1Z+8JPD+6Y3TMY/jMcWH1J2lcbCak51eeA1oYTB/5u0Qd7YF62bHJu/Yz/V4MaaXzh2KFDX00Bli8GZTUuIwRD8qZrQzZzW0UrH/NDMOI1oZWv+FwEBbnGh2FBwlTEK5gugeQbpbkleewdPW4nJ5I05FY6JMjRt9DBl0lZpJJupc6b2SuopfMeEiicte3K/QjcHQJYhlhOwVUTNVp2FjUZoqqWTs2cQGbAi6zGYLUZBPPJtMGPBehUWzoMpIsox18R2cyqtUZ3jZGNYmDmInsDMXWGDVMl3WnplZYxss+0s3KKi+BtcoAcLBCn0aqDFhZvB/1FSYfy052B8JAG9ZzFYhWJK01Umyxrj1wOlHWV2zM7hN3hlaDaagSsvc+TdhmTfB0Vu75OBl+Gn/T60nRd3NKLlcWKfROwHX3qR7hrqff0dV+kE8
 U5ooLDtH
 TbWEuU4EDeQzxHTDBu5hy94O7G7tELVQWZX9afqazpfsskIpUAfzpuH+MKdzJSV1OEbCzPWSi2xEuagwXAO1+j5rJaWTn01QXMP7QdC5uZkj2TPl2dNc/CyJ0UgCVGB2rq7ggXOcSUdCKSCopR8NTKul9i666pY7muPhIBXw//xl42u0B4RvyToGYMv3w9cmbBgKPiCwhwu3POebAuxt+/KNN9bTwhs+F+H2/sne7afa4528=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/21/25 11:15 AM, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 09:58:34PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> The following diagram illustrates how to ensure the safety of the folio
>> lruvec lock when LRU folios undergo reparenting.
>>
>> In the folio_lruvec_lock(folio) function:
>> ```
>>      rcu_read_lock();
>> retry:
>>      lruvec = folio_lruvec(folio);
>>      /* There is a possibility of folio reparenting at this point. */
>>      spin_lock(&lruvec->lru_lock);
>>      if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>>          /*
>>           * The wrong lruvec lock was acquired, and a retry is required.
>>           * This is because the folio resides on the parent memcg lruvec
>>           * list.
>>           */
>>          spin_unlock(&lruvec->lru_lock);
>>          goto retry;
>>      }
>>
>>      /* Reaching here indicates that folio_memcg() is stable. */
> 
> Does that mean we call rcu_read_unlock() in lruvec_unlock() instead of
> in folio_lruvec_lock() only to avoid false warnings inside the critical

Right.

> section, and technically calling rcu_read_unlock() right after acquiring
> the spinlock is fine?

Right.

> 


