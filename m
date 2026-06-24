Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 792C7CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73CCC6B0095; Wed, 24 Jun 2026 10:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714916B0096; Wed, 24 Jun 2026 10:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6522E6B0099; Wed, 24 Jun 2026 10:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0966B0095
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:42:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA93D1403B4
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:42:06 +0000 (UTC)
X-FDA: 84915071052.13.08969ED
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id E14E9C000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:42:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NMYyA2Vz;
	spf=pass (imf10.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782312125;
	b=1lKqZ++yMDMxUmSpAkgPnYoI13fzCvS2IM9QQTQZnt6IFvIxipNbob68PK1xAz64yjCeLb
	XGw1AwvnCN1WB42xc41N1JmbStbzOOBBvpWWXLdVzB8jWw177HxOkVPUlFCfAFbIh1ODGV
	7eNxIySCaW5AuAFebqdNqIdsPh09WD0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782312125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xecAOTCurKESIMIgUzS8m+lTP6YeTvYRkWiz24CsRnc=;
	b=65XMP/9kUdcOffdYEpxlnssIggnkKcm/CagJLyUYUQnCQ2szym0cdnl9hpVO8g2U8j6/aK
	ApTUlPYJsXURG2Z5O0lqzgVBT2TyMMBBCjng7jXBPpIHEykU0+VP6+G1H1MGM/yXfes4Tr
	khSH+y63imGs+mccc+ODXfQdfLSlNNg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NMYyA2Vz;
	spf=pass (imf10.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <9abb91a4-1990-40d6-ae36-53ee2add765d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782312120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xecAOTCurKESIMIgUzS8m+lTP6YeTvYRkWiz24CsRnc=;
	b=NMYyA2Vz3iRqg0pVeiFzkpqoEMuDTwjDkyW8yNeKWS8yXpDEC4H0JaSx2Hf5d6SaHkHvdY
	Yg92UrHTuZtAfR6YRSjNL74hOIB4GFnWvcqNEwCtrXpROidU1lyP1xGHleMB3AN5t+kmqi
	YD5k3guCfi/VHklBAFzrOYyK+UtosEo=
Date: Wed, 24 Jun 2026 22:41:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] memcg: bail out proactive reclaim when memcg is dying
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, yingfu.zhou@shopee.com,
 Jiayuan Chen <jiayuan.chen@shopee.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260624135839.2596358-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260624135839.2596358-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nnmx4xujioq3x68yw4m41qjxgq6zr568
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E14E9C000C
X-HE-Tag: 1782312124-203211
X-HE-Meta: U2FsdGVkX18i8zdQBG42CMm9xpmsGMAoCh6sGglNn7dnWvOYUQ8t8a8CSZ9kcOxdFI6vy4IkucnDxDRx6hqkHiy2AwHhHVGxqJ8HxH1LMSamV/Ie42gVh4+ggCk1G2hhyOceo0ENYubxaqmWUGAr/lHGbbOM/0rxAAtgz/Y1l/nvO3RZmGKH6PQPpKxjUlOF8jf41ALEM5p13AYV61bq+9yUHE8GkPplkWFF5SFw57+TXpdW8y1h09WpNSVo+uOllZwFv61MYsMpJpygmXp4kEKTh28fhpt1gzKKLM6tM9/NaMs5483nX/BA5lBzBw0ZKRBUVTmfe+Xlsmry7Tr4XIp+Bu2vg8wM9T2IDDEGcwx8E55uobfObD5fSck4TobmJ5wrqqWlBPlb4qmdTqEeNLOehx04MjztbqjVW89NqjuPPONT/m3AWx2muEdOs9rDbsl9VKfym862tTQV6J5QgvaDETawigXGbLqV5Ur55LaJB8mLdH68F4oHOwTsmukcTIJmkBMdfe+4jXSUjIZLBRG9PiS4FzdlC00vbZIYvT2/rFozFoMTlH3RpFV9jygdOvixge01RHOlQy6hJooJPJ8/8ropdYiy+1LvCC+QViu1/EgPJ944pRqsLh1/9dI9u1xnXiSI9tn1M6CwJrXN1IlKa6vqIg2pNYlt8c/3b60uBx1yAl2+N3+ltPaI9Az4HR+q7QGyUM5aW6ZhLANJE9Tej6ZUOweiHDk3Id1JDdasM5vzxYm+qrTNaKeavm3AUEVAXKDFviLFnB/w1qVUDQZknwxO9oFgrDDKzf1Cwq07QHAEoh5WYeSJ+wClYusggxA/GwuvmTSl1lrvofT12uqg+y4FtqMor3X+t95o+QPjiOJfCQDKZleFvg6vC4Mf96RsF5BbtxxNvn6bA+Qn4E5bbtSpq0WP+FE2mHM64+OygHIAJwsT2qJAYW7a9ARTd7UM6E4sHubAKDbNFa1
 JK1i4z0p
 bzlI/OfbYi/mWXSLLGisvl2POJqza9IR8hlSsHisqOyVic7dG3SHUmg9LYzGuSUemGKNTAk+m6xVSsnNrdbGfF1worI4geiA329XUPdJfN9w0hErB3fuI1KtGknotILiq8OD4gO8dC4xy1xoZ/im2czLIptV8FjEV6xAthZ20nsTYaoT0LIqGl/k7XPCqwqiaysl9gv1mG59Akl53SyNx8Yuv0bVhhjgGLpptV9OjJ2MTq469tSFtQAuuGM3y7esAMtfFfpLrBVEX8lAA+NIPzHKU+0atbIwyid58c8s3orDgR1WEFBd0s5m+Mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 6/24/26 9:58 PM, Usama Arif wrote:
> On Tue, 23 Jun 2026 14:27:56 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>
>> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>>
>> Proactive reclaim via memory.reclaim can run for a long time - swap I/O
>> or thrashing again dominating the latency - and delays cgroup removal in
>> the same way.
>>
>> Mitigate this by stopping the reclaim once memcg_is_dying().
>>
>> Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
>> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
>> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
>> ---
>>   mm/vmscan.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 8190c4abec84..1162b7f76655 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -7922,6 +7922,9 @@ int user_proactive_reclaim(char *buf,
>>   		if (memcg) {
>>   			unsigned int reclaim_options;
>>   
>> +			if (memcg_is_dying(memcg))
>> +				break;
>> +
> This exits the reclaim loop with nr_reclaimed < nr_to_reclaim, but the
> function then returns 0 and memory_reclaim() reports a successful write.
> I think you want to return -EAGAIN here?


You are right that an error should be returned instead of 0.


But since memcg is being deleted, I'm reconsidering the appropriateerror 
code.

-EAGAIN, -ENOENT, -EINTR are possible candidates



