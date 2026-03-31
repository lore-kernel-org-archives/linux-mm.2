Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4136FFF60D0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859276B0096; Tue, 31 Mar 2026 04:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830C96B0098; Tue, 31 Mar 2026 04:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747306B0099; Tue, 31 Mar 2026 04:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66B806B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:05:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EFC31A0B85
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:05:03 +0000 (UTC)
X-FDA: 84605622486.18.E510755
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id D50A110000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:05:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eaNfKyIj;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of zaslonko@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=zaslonko@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774944301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLXfFb8U8Zgq1sbn5+Sf1i+7GC+yyn45UCcNC9RaZio=;
	b=1SH35zMQan39DraBxIpRJx6lG0k3h4zU9iXG3kpim2a/u1VqvaN8F4clFALAdpP+vHZfQV
	uGVXBOg4vcX8u2yGS3k97eds/kaieOdW9TYZEVkqcLG4hddAqFAFoY8jh4NUrtM1jzNrhz
	QTbAF7paMv3HcqpQiW5pU25UKfVA23k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774944301; a=rsa-sha256;
	cv=none;
	b=tt2Tteg9pd+rbu4Elh9AcEbsEaXVwbtauaXs6/rHhh4hnOr5h0/JA1SQ6vnWB5JHzqKGOO
	qMRkpi+iXOUDCPokKofhGLZqtXzuIddusl83q77MN800pvHke3H5z/AptJEhcjBlI1+lL7
	NtWtSqsFFIYiyjmZYmLnbzwLkIH1fro=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eaNfKyIj;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of zaslonko@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=zaslonko@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62V7k0rJ505649;
	Tue, 31 Mar 2026 08:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HLXfFb
	8U8Zgq1sbn5+Sf1i+7GC+yyn45UCcNC9RaZio=; b=eaNfKyIjjmlVVCAWOwd/A+
	cA+U8IBsJpyFJ9yvkFJ6UJEUtEEJ3d0/tuCg7ht9ZC9+k5MOn1IwUqlX0ov0c8L5
	kmudaJxRNehQw9r28ybncfpuEd6Ro5n0e8uwaHkpgJzW8SbTxo4XKIrd8HzLbOa6
	m5ypiEOPMOza2DYmAj8XPe4WB3V/rDFSA6rbVe2yObfJXrxqH8CI3PMiScomXrZn
	jn9i01oJ58khCd9WPss7jm2X08Q1VM03wm+sLyb3upn/LNvQ/O0NA2pdGI/N5icV
	6BobtWnn/1yibe7bPh7nWgiDG5aJmpCgxI96tAzZ/XpumHElFl6Qi2OLDlambgnw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66g1t99e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 08:04:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62V63Zdv021659;
	Tue, 31 Mar 2026 08:04:55 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6sasg9s7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 08:04:55 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62V84s5D4850178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Mar 2026 08:04:54 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80BBD581BB;
	Tue, 31 Mar 2026 08:04:54 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F39C1581BA;
	Tue, 31 Mar 2026 08:04:51 +0000 (GMT)
Received: from [9.52.221.31] (unknown [9.52.221.31])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 31 Mar 2026 08:04:51 +0000 (GMT)
Message-ID: <65d33e3f-37f2-434c-9d39-38cac66aa7a5@linux.ibm.com>
Date: Tue, 31 Mar 2026 10:04:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru -
 [s390] panic in __memcg_list_lru_alloc
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
 <4d3f8d79-3593-47df-9de8-f94f7f09a403@linux.ibm.com>
 <acrf5_rS7hO5Ec0Q@cmpxchg.org> <acrjmBx_hX-Aa_SH@cmpxchg.org>
Content-Language: en-US
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
In-Reply-To: <acrjmBx_hX-Aa_SH@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Fdo6BZ+6 c=1 sm=1 tr=0 ts=69cb8028 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=bDKavUFbIZVm-0GZW4UA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 4GdaSQlSImMa_KzvLy3rjzfO77vK-sHP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMxMDA3MyBTYWx0ZWRfX1twzc2BG99CB
 TMuWES9DvXucC66Yhoje0lleePR7zGvBHW+Gzq+yLxE7s80widTi/buSvb7zXyLwFFXPQuGPvQR
 sQ/kovp9E4t+FvZ8G2feMbgyCEsN9Kl4WQvO8vmXHOCABfn3Nz+horWftwhWMsVuhL8seR0w835
 EPEMD1atamxKZSVNr5/G+Jh/u17J5UqKeGmInHeXOHBUYJYsflsBGxC/M3RjjM+DN8VrNJmbfSC
 DHJojbTtmJ9IB+wf2qJz5xSQaPpq9PYCK4W2KmIOR/IxMYUsxfWDa+MUeFWR41DhTxCUpG21rDz
 D/4zeoLNBkipiZ3+mx88eCmeLsGE78XJ+GeI+3AwslvJqSWlREgZ9r19TOD1hcAw7Ajd0ygW+0G
 a/Vk0P7ytYPTEuuCDz6+YzOhgfmtZcwSmmiFRCw5MKPZkuauxfZxk0g4d/+MY/+dj61BgqtIrwb
 KoyQe85Dox9/PyzfxHA==
X-Proofpoint-GUID: 4GdaSQlSImMa_KzvLy3rjzfO77vK-sHP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-31_02,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603310073
X-Rspamd-Queue-Id: D50A110000E
X-Stat-Signature: 1hxi63zws7k1tk4sj5myjodsq74cs6cx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774944300-618266
X-HE-Meta: U2FsdGVkX18qF4gtvqOzVJy4jF9C4nLTw0th/oLe4SYUK+W5riB/TGuUqgucDXtGaBdpEZ+XKz4QdoCYofTpnbN0G6K2Pn4gj1uKyOGrz6GQj9kXDu+H0+FTC2EJHYCLH4InU/q8xoP0ZTDbkx7BkYY48ZZnsZemjpO7fj1xhDspde0a7W5ZlAEjSQACjEUe7+Xmy7wQMCaVPEP2WoUu8jubaGYG1Oi+9HgeKIk8dJKuTsDTqm83pZ7RXIVxgVsmHmk5yZuU3lTJHq0y0JaOeaLX2NsK0+55HjWlyrWKPPF61EED4kqm48VTn6W7i682enlEpmYnfBZNPgqoI74pwyiodR9o5/AQlwv+7DboXGjABEOHJlLOLTGOyLUnNWLn1SEn0RjPD9E0lz2B+QmYSKSmMW53t6Bq69wXw5oy0OV6MokfZP9kDK2Vv9Y6CfTz9hZ5HuFVbvaCTFcnqtXqUHs8D/yDYuyWTE4UeV1loRZBA5w80zaZVS95IQNRUsDH+ADgzvM3UPWxmCPLSU7ouhIXZbzycnGDKVbdQyyNc6hxWVlTm1HYVFMBjjWocH1xINil6yjFUkG82Wziq4beNUiiy3Zkf004jWl/jK7nxOgbLNnD0jOIB5fka4dCa6H5jGncR60ZMUWX5kt3b4XgCzSrF/jIqmaFh92UbWSgmHZttzA+6GlWBxTg8+OvAVZasxYz47vsqrac+pB10wISQu6sjHzriNh+fGr3UBLnKEn6PdaYxLP41CKb8LdJ4UjpFVNcjnjU5w+ocYJyfFi2kj+ZqcOBqkJV4lXoncNGr0FRAEBVIAlZR+vH9Bss7XyaQJibUtRw8mudRYBX3ZdOU/HWPeiE9U/aXLvCj6z9eY00WAtWXkGIVsTZ59kaP6rpRrVM1pCFnCiOdNSGj/xSaM6bJXkJD5wUdOs6PwkPO3gEjzTdhB9vtBbvbB8WDPmpPgFxKebYMMXZ9V+wgQN
 VYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30-Mar-26 22:56, Johannes Weiner wrote:
> On Mon, Mar 30, 2026 at 04:41:16PM -0400, Johannes Weiner wrote:
>> Hello Mikhail,
>>

> 
> Can you verify whether the kdump kernel boots with
> cgroup_disable=memory?

It was not a kdump, but s390 specific dump tool. Yes, here is the cmdline (forgot to include):
kernel parmline...: 'reset_devices cgroup_disable=memory nokaslr numa=off irqpoll nr_cpus=1'
> 
> I think there is an issue with how we call __list_lru_init(). The
> existing callsites had their own memcg_kmem_online() guards. But the
> THP one does not, so we're creating a memcg-aware list_lru, but the
> do-while hierarchy walk in __memcg_list_lru_alloc() runs into a NULL
> memcg.
> 
> Can you try the below on top of that -next checkout?
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 1ccdd45b1d14..7c7024e33653 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -637,7 +637,7 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
>  	else
>  		lru->shrinker_id = -1;
>  
> -	if (mem_cgroup_kmem_disabled())
> +	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
>  		memcg_aware = false;
>  #endif
> 

I confirm, this resolves the issue.

Thanks.




