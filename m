Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA1C606A321
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Wex5J+IG;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=zl5FseUH
Received: by kanga.kvack.org (Postfix)
	id BBF806B00EF; Fri, 30 Oct 2026 17:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95776B05B1; Fri, 30 Oct 2026 17:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A864B6B05B2; Fri, 30 Oct 2026 17:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68A316B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:17:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6028F40856
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:17:18 +0000 (UTC)
X-FDA: 85380553356.03.44E1A4C
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C6D3180007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:17:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Wex5J+IG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zl5FseUH;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793395035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRWmd33IApW1k+d/oOksSuFh5i5/RIsJsgeiYg6URG4=;
	b=N2uhciFtStg8pc5YqJL8Sm+yCBHZttehnUp4QQw6lWhz5CJgaP9d2ky2iFAGFFJUir4c5d
	c6lJKD8w3YDWJuM5V2B5ewx3YJKQaoMSe+nqonXp6t50XuW039O30YMn5WY3vnJpfgavXa
	YA41eZzjKNquJHAxMHE1AyIoLf8wDIU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Wex5J+IG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zl5FseUH;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793395035;
	b=Tu5gqKCMh3F5IaCVRjnuNAiUrZ0cMdbzcJc5226mgPK8HxuJdZBRw5vBmg4Qe+WV6KN+k1
	FVnBtIzX3qb1vvvd9FHHFJfmFb1moVMl7zD/TsEqOTVu/pMRnpUU6foK8osRySGQelZYff
	yJJiTelhYuqlyyVKGwQPJYa0DiiM0xo=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ULDHio2847022
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:17:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=fRWm
	d33IApW1k+d/oOksSuFh5i5/RIsJsgeiYg6URG4=; b=Wex5J+IGavi3xM77v4st
	urUui2rt1HL0QfmD9SviL0UY6IuHUpYTjKLd1izClGVAuBD89z2nAtYIU2RGszT0
	sxZjpOZI0ZoHH8VUdj1XpHSxBN9lJcj/be/+eq94Ct/tBDV0+MolLPlX7FeXa8id
	b2PXLmY92feDlZVKhyTDP/WDw5/h56jcpb74WKcpgBIBefMsre92qSus3e/nnj28
	YrX69GdxW/udNNtPBmbeObpRyzKWePNtmI2HExTK+uvRh410YbT+SdYEy+sMfvLI
	ji0ej+JKb7NmmYHqSLQZ34pSVElEmuU/f9apgPiwyw1bWi7qm1QF/6zyjVR578HM
	Sw==
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com [209.85.222.70])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hn2x3g1rn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:17:14 -0400 (EDT)
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-9907539aff7so807164241.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793395034; x=1793999834; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fRWmd33IApW1k+d/oOksSuFh5i5/RIsJsgeiYg6URG4=;
        b=zl5FseUHafFSE3dcnHnp7PTfr1KgxkCmtlFmNvhVxi9tX3zeTdUxF/CY1aPxhTntGX
         /PBUGDCZmm2SGNGNWtHXE23w2t3XJPFR5IosRl5fkKBFSfiLLB9Y9tdex2ssLrTv972Y
         M4RrITWah/uGCFZ5VBQEgB4nGyBZiQy/oZSLmajeT+LbM36B00DBVgsj1KYqWm/546jf
         T0AZ1BU8YF3dEVW6i1NwEcW26mso0kMyZ6IyJz30vyzAmsCP3UsW8XImyJ73zEEIuIHe
         B6ORNjG2LJ5ePqP32LtxWThqHlxzM7SNJjKM2E/7kRoJwfbCq5UsuxOXKWOGA7JsgQd5
         VowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793395034; x=1793999834;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fRWmd33IApW1k+d/oOksSuFh5i5/RIsJsgeiYg6URG4=;
        b=MeUqTN+JaDhBLumDsoFSnFbMebBHysZ2RbkZiBNVcAShzRdLMmTwt7R+Kk0UDmoif2
         uQjw1jwov6FblrZbDq3UI/hd9YOTdoyAjFAOQbUeg3rHfdWLCRhJ/CfCydaYA2vfEyEy
         UlFSD+1tk+0X9EKj5NYYWbdfZSihXZbZ8QsE3Xaqu1ZDhw3/hJDOVUaXlzCG3fyZLgRv
         oy1q6YMKFnhnaP1SPpQpo6Y+mE/6c+HpzNbzsFrxx4LMpR1wtOeKpDnQ1Lo5DiFIebli
         DrYtykPbA4GCJTZmzbyN3ctdEAxhdVyhXEQgQO2Odu/ueN5FbnBFbe1ajNttVvqwWK0i
         OCSg==
X-Forwarded-Encrypted: i=1; AKwUvBznkDK4a6aG7LH+KvOGKdF0tuyFW7LpnS6Ju6hvj1uOoVJi0k1vxUp5dPSYSCJHEd1oqnhvRpTf/A==@kvack.org
X-Gm-Message-State: AFq9FYLPNh+HopOeJNbyNEE6ZeTjqjDoioecYUrybD/njHpHxagQpqEl
	pnX00XcrS9j+Cf/3976+Dl0oQ07it80nzk5dnVyUh0e7MSoEFZ977zvvIOmb/zvuzSDn4Zm2K46
	F9nPMGCs/OJr6A/d/x6owyk7MybV1wvkz/BYaZvrr8GI3EN6f
X-Gm-Gg: AYBFou3Rk2cAkQq2tk5KrRZtoBfik5JQk9K99R7E33UYxqMFs5XWazHkWLDeVRIiuEl
	Vy/e8PhVNCsxqzMUFRfHLEqutOCSjXy3AvNhGpy0TFu0ba2ivATmEyMpNwYK9I8J/VPS6QkPZ94
	b2UJn+7w32gO8apeL6GYNzyfUNCEeqOsDkxVHfEX+QEj/mgfmysE88AARFEJdhbHrLiHNcmYCO9
	Shv1Anvb3kj/aL/RUFhkzYK6rgaRrvaE8axdo2oyWMLxsKpuxK9NzMVGgVMagO3IjQr3pI6QW45
	h9vQxRu/L8GZWWiBnHk/NOosI3uOwDrcmBvakMoFG37DNiEVszpg9DvWR8UHzk2zykn3xX+Ogco
	VC8rh9ddhlSmsCJPuHZNMTKEp72WSumgdTaYr3bnt0dyttIibPAcLFAPxD0k2ZWJbk6Yxzdm3mY
	P0qh5NzmCPAmYIJLZeJNgRQn9fcz8b1MMVxA==
X-Received: by 2002:a05:6102:5494:b0:7cb:bc5e:7d9f with SMTP id ada2fe7eead31-7d072bb3829mr1865963137.11.1793395034070;
        Fri, 30 Oct 2026 14:17:14 -0700 (PDT)
X-Received: by 2002:a05:6102:5494:b0:7cb:bc5e:7d9f with SMTP id ada2fe7eead31-7d072bb3829mr1865951137.11.1793395033663;
        Fri, 30 Oct 2026 14:17:13 -0700 (PDT)
Received: from ?IPV6:2a00:a040:199:85d9:d6b:b848:9578:6d4e? ([2a00:a040:199:85d9:d6b:b848:9578:6d4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b7270asm5274449f8f.11.2026.10.30.14.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 14:17:11 -0700 (PDT)
Message-ID: <1b2cd93a-37c0-4ca1-a8db-8ffaeec565da@columbia.edu>
Date: Fri, 30 Oct 2026 23:17:09 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
        ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
        lance.yang@linux.dev, usama.arif@linux.dev, linmiaohe@huawei.com,
        nao.horiguchi@gmail.com, richard.weiyang@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mcgrof@kernel.org, liyouhong@kylinos.cn
References: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
 <20261030105022.903008-1-tz2294@columbia.edu>
 <40eadc1b-5057-4286-9be2-021cb16bc020@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <40eadc1b-5057-4286-9be2-021cb16bc020@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA4NCBTYWx0ZWRfX0ZAFNx1zeXIl
 f1ejTMQRpV3tV8M475ZS0uA7zA+XAjzbobfQM8Qg1Xe0pz16WF+XmzaM2jbz9sGR/UgKcZiRlMa
 LQ0N9AfpUNo14StqDXueo9Z9k48U7jThMU4npNvPyyORNNviAcq8
X-Proofpoint-ORIG-GUID: AYH_IVY6TFS0Y_aBCdh7esEpTd6r37Qi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA4NCBTYWx0ZWRfX1Oo7+d33jy9S
 Ty1E7WiJCHXyaKjTh3iiPbMHGWCIiejNs2qkw4fwHI/8gB0Y6mazwf3w/mgJJ1/mSuuwXRt+an7
 iljKi0fJXma9R2oHssyPzfvN0y3EIIbC+TIV7nH0m3KpyfFjLkj+4nn7CZn8XYEvmZ1YzqvQrOq
 S7buj8C2kjT/Ff+OW1k6n0XtVNvnMPC19BvfijWT927q17X/V3njLLsme6uTbkiORl19TNuwkC6
 7fqmQxLjZbuuMBnqPPxCdXqZVZxRFHrnPMv8Sv/9HHW5LzJWA7Ot5lxnZIzs1TyIEVE0h30DEUS
 RpFnYeRsXCBPHDEEp6iEip0USkOPt4lT/BGr+FLwEgpMj6Z811ngB2OJm0EZ9R84KxsOdu+Xhos
 X05RT9uNUCdC13vKeShGZ2aPcCbbbQ==
X-Proofpoint-GUID: AYH_IVY6TFS0Y_aBCdh7esEpTd6r37Qi
X-Authority-Analysis: v=2.4 cv=cpsOAF4i c=1 sm=1 tr=0 ts=6ae5095a cx=c_pps
 a=R6oCqFB+Yf/t2GF8e0/dFg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=QACC7Yd5LT3gdyx-e0gA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=TD8TdBvy0hsOASGTdmB-:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11951
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 spamscore=0 adultscore=0 malwarescore=0 bulkscore=10
 phishscore=0 suspectscore=0 classifier=typeunknown authscore=0 authtc=
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.22.0-2610300000 definitions=main-2610300084
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6C6D3180007
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: dksfoeoyj9fpd33fqp3r1dtruukm6tex
X-HE-Tag: 1793395035-562592
X-HE-Meta: U2FsdGVkX18XoqV44N3uazNqPhRdxdqfTjq7+I9wgKur1GV/JfCwp5vztdfpQttRiGZ1AXrzX2qSXL6qNkmh9Fnl/lCbeqk3RrLhahKWo5qgbvs6KFlC2tNAqfhgWgxffIFYM22sODvQIC73Eo2mes89HXCqMXlzXpgRL4Ji5xED6Opvf3KCATJEQpKK+yR3cjEWTJkLFACPlNkISCa5tp4hE3viqocP/Y2FjSe9c6ojoP+84olF4NqPvXrpLPO/PVP3165qigLF7Em/HhnQHvrYM/ahp8oEaGy5CyHe1rLBdUToQS8ohg4BUpRcp65zkFGKKrBtwxKH3171m8EvzPLGnTC3Aeonk4vf9zJR1E6I3A7N1Hku9DbdRSFf7aqrFLCAlmeK7NKPgLTutHZtZcp80a8+vsDuNPJYxY8s50vEsMf5LnT2TFasr1SNYGVtxAP0eHq+1yiawVYSoQY3aByWTyDkd/WKSk3g3Pz2403jvPhwT3QjkAwQc4A7Qx4pZVEqDnsoKNAdhUhNAeg9hJMdH/lEZQRT/C1zsFW522jnJJd78db2q05zLOeK7yITOIzj0sb98hLXNrsmu8Za8NZIwB+9XjryIwLNoBcwileA5DJZ0jMjDLhIrX7C1OO9v9Dzq7lNh2TIFi/o06m/sz23InQckftEuwtIPXH1YG1+KG7v3rwpK4qwt4yTTCUZVdeZsFr42TWtvOjQGZ2yGgcg92JBosqCijdBudt7KcrJPYinJ61WdVLVQF06NLN1cMZUtpeXYD5h6DJndtbh5p+Tn/oRpgZM2rz/htIKlyp4qEjv9p/wEs4YmI28ClsZuBpXvXSQeEJevwoBakvn3EByqK3rX9VbC9cGb0tKGTtVKw7yFn8MXEPi9b8Ww9lD8h4E9C/RWPo+HAvHqXGMxfYz7Z1/4dQaiUltTQcO32sYuNZP3dHEk2/rhm5ZBn3lrnvE+RSHaBdUBvCuVmD
 ACjtRtUk
 QbFRVlt8/mERdDyW/jczsDSK8ksL5MRN/vtmB3AuQ133zgkqzRxEtzd6Hx2qmo+OvSJngohytqDduxpGHJyw+an6PWc+Ih5xOIX+j5m/MFdY9+Cd0dVlr5G7nNdMU81SwQA1WA/BasRwrNMpmobnYPMwdW17Di5jSbFMctkSEuazZGMpmDMYn5TgjIV2XMgloanxJFX2Rd58fmKmS2yyBWxgKKvayUnlulrUkhmIfKcNkgCpRSoXaorYbAOGno2gdJ+jvG7cLU9EveY6SuukcpQQN8x0LgmC9dbMzLQeCauRBrctiWTC4EOpG8ieX17xQ7vKFhsS55s7ABqAwm6aeXX3rPlM3MC6A/zoVhusclPg+B8yI+WNGlrVoyoEw0ITHh7Df7/eR6IvsGkt11UbRAiyH1ReE+XQGCG9ap1Wlqu70D9fucUdpdr6fAjJiQvNIpEkEMmObOTONQuNCUlQ5y6wJ2ZkkwQ0RM47w3udLsjYQI3K0lv0UQM57rIJ58RraienrXrRXC9I7lMAqIfLDRs9oVUBihp9gFWRAbUidr0dzfAOET1le501q+wJym22jdAc+HzbhDuldiTzLgZx8jg135Zm2CxdSHLLv0u/emB0zsaHsxjYIUaXToUBG9i90W4SAtxTnLbZBjNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 10:42 AM, David Hildenbrand (Arm) wrote:
> On 10/30/26 11:50, Tal Zussman wrote:
>> On Thu, Aug 06, 2026 at 01:14:38PM +0200, David Hildenbrand (Arm) wrote:
>>> hwpoison code can end up calling min_order_for_split() without holding
>>> the folio lock. There isn't really something that would prevent
>>> concurrent folio split. Consequently folio->mapping can get set to
>>> NULL after checking for "!folio->mapping", and if the compiler
>>> reloads folio->mapping, mapping_min_folio_order() would try to
>>> dereference NULL.
>> 
>> Hi David,
>> 
>> Did this patch ever make it in?
> 
> If you ask this way ... I guess not? :D
> 

:)

> I can see if it still applies and resend + apply.

That would be great, thanks!

