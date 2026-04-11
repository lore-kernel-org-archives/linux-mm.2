Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72F93F3ED4A
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 11:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764EC6B0089; Sat, 11 Apr 2026 07:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715E66B008A; Sat, 11 Apr 2026 07:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDE76B0092; Sat, 11 Apr 2026 07:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF436B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 07:46:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CAC65B344
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 11:46:06 +0000 (UTC)
X-FDA: 84646096332.23.14C556A
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id B60681C0002
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 11:46:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AvwwHgA7;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=HsMp6bIK;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf18.hostedemail.com: domain of jie.gan@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=jie.gan@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775907964; a=rsa-sha256;
	cv=none;
	b=XTnDKqYoH6/fa8f/fp7K3tESYUXNhS0aCi0iM5J0VQnjs4/rvHWFcBnsIBHotRgLVvrY0K
	HB2JP/I+Q6UGKmObG+i20nvTMIqcuFguEXCMTrTfTLfQJT1G+yaVDW6aeu0iNuYFaLqlWw
	4zxHkTTUpfHTFSrAb7GgmaGEiUaWsq8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AvwwHgA7;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=HsMp6bIK;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf18.hostedemail.com: domain of jie.gan@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=jie.gan@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775907964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GleO7BA+2+K6ec48larGiOiwXHMmUAomJOlDM0oY6pE=;
	b=u45DQlcEP2nKnGfVUIft62lVB9IPHhlriDlSKolFeN2j7A7PbENRlItswNFvC/GenU6Kgx
	ZRtjSJo028gG3hjFuOPQyGW9oz50OK5EqysyRXtcx06s2yg5pRNhdWKt74sMZAMKZOjwlv
	s8je45yK/RzZV5L0ROQjdZv3jzRkZB8=
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63B41X5Y3377254
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 11:46:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GleO7BA+2+K6ec48larGiOiwXHMmUAomJOlDM0oY6pE=; b=AvwwHgA7IiE/h/dD
	oR7LwSaIT3TAm9M3aFB9lotgk+S2CDySBCfY4n9VdwcmJvBZANhF1wmklvXnqX5A
	6w6Z0OxYmaTG/xe3M0ouYNUeoTzlSL7t4EGiQIm09naLy5A0CD576svG5clynEZd
	ukwDg5bzB3jkwTRnHq1pYJLOfPxRWzLVN5WvfOw9dqma6L6TWkWMi2RXvstcNTcP
	yBKzWdjIig9UAfMD1xdNy0oxJI39AnCxTl8qCPw7n0HuFS3RuI3hhz39UlJ1o+Wi
	xf9L0p/hN7sJIDCx8kg3kU1vP1qSQ86261KaifSBKQw4rktVyxpqqumDbpunsKLw
	1r768Q==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dfewkrmem-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 11:46:02 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b2497cc190so14032325ad.0
        for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775907961; x=1776512761; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GleO7BA+2+K6ec48larGiOiwXHMmUAomJOlDM0oY6pE=;
        b=HsMp6bIKWjDGnhXmLbfZerQ8dYDjaNG8zewi6Ygk85U6hOesWA6SXQPKmuV3Yi7fJ/
         G1X/bJgGuNr8bSMRUID9DyiVTHNZWNfEDMlhjg1JMFZ7aU+tp7MIjNeUPvpLaOrmpswh
         9Dx96/TSyVwTzaBJyNUi+iRjiw8Skz8lRDcMO5p+j8OAdm/lifiOkv1wEWAvRadh1jPT
         tCrXcfbidT/GCIlPBlTkR05SAn9nHm6PemyNdsYuvgIzFpJhT7RBjaFF6D1ZEH3Pi1c3
         BykKo7NrbmOX09AXzIEjTBbPvZiAPBfn6fZwtKW7G9MATw2QCzdjrTRzqNQuitN04Rgo
         otjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775907961; x=1776512761;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GleO7BA+2+K6ec48larGiOiwXHMmUAomJOlDM0oY6pE=;
        b=OfIU+s85WbEg/Lzwup6ZowHRWLST/FIySbYSWxgb04HrtYuW23wkMroh75QpRDSwhG
         SrfgE1c36qGoPf3Z8OqHjq0ZXA0UtSheEsf/0S4yT7vJMZYTi/YjgB/j5IohowNnlsuz
         im8gEMPtAB77pyGB+YbGDMnYjQGa3U6G6vdS4QVjOK7+NtOfUPeeX4Y2G+7H3O+CKsf0
         rpdmKXxdouIojZXhphXfa6ZNIbvsdqFH1y+bnZ0ybfprw+mqF4ZL283AwnOIQvRIY4LM
         /BlkgPQ+WhUy7X4JRlNo0ScgzcVYdHLKXK+zY4NAiQFU1AlT9+4c94b3UftyTq49sHCx
         bNVA==
X-Forwarded-Encrypted: i=1; AJvYcCVmqdackdKTwd4lon6vHw8pNIiolSIHvadq1X4491D6XDAbxTbQ5ItKbUcASQ08TC6TM+txUTC0Fw==@kvack.org
X-Gm-Message-State: AOJu0YwGoDiCJGAKICAfVzwefYnPBI89iw9yGCroVgNTB+L4K//rGbBV
	S4LFHlDMpJnM64fOH61t8NIjlLFs/U9ro0JQ5DBiOKoszCzPs30/muetb81jvNGPC3/hGhgIwY+
	e0VhS2A0RsH9KtDgt8tlNCbNRABNu2ybWydwp2bNAUSduF+09CEjwSQ==
X-Gm-Gg: AeBDieurl1j0UPLUg0QGwz0yoG5yroPMsxkJEDVJ9ijttvyrH9mNzBRQOA1fQcXHggX
	FuyPIwfMQIJUXeWAmk6iMwH+Q5ymdgiQ2AUO89UcJipsIXVbAQgRU5+6U1gJj0do2pfFLEE0pYH
	+ZM+TSvj263rzcE6EBE1xG9rGu3rPkYekq8tzJyuf70KVaaKsFYkBeW67LByQo/ZPrCy99KvOjz
	1Ln9VNt7YTJHm3wDYaCJbXBLwUa43diyARaThEqdVazEnKcWBTn9scBv8eERGuOJHN6KJwpzRXz
	33dM0lwaT33xegP0aqm4BTqI/IGT3MkRDRvuYJq+zwG9JG1oBlTKGfrHwzxt7PQIe+8v5Qkg/bv
	5A2LRlODqH5nakJIVriiFMywGVHEm5se8BdyCkX+ZWp3d9CnKA9Kpq3dNp6ByqcS4eRCxWGPMYS
	s4AD/c2fe8gg==
X-Received: by 2002:a17:903:3d05:b0:2b0:b258:2a57 with SMTP id d9443c01a7336-2b2c739f784mr97874845ad.27.1775907961503;
        Sat, 11 Apr 2026 04:46:01 -0700 (PDT)
X-Received: by 2002:a17:903:3d05:b0:2b0:b258:2a57 with SMTP id d9443c01a7336-2b2c739f784mr97874635ad.27.1775907960980;
        Sat, 11 Apr 2026 04:46:00 -0700 (PDT)
Received: from [10.133.33.83] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dabcdesm61571375ad.2.2026.04.11.04.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Apr 2026 04:46:00 -0700 (PDT)
Message-ID: <2bfb7fd3-fc0c-47f7-8450-6180b0251ae5@oss.qualcomm.com>
Date: Sat, 11 Apr 2026 19:45:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] mm/rmap: refactor hugetlb pte clearing in
 try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@kernel.org,
        hughd@google.com, chrisl@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
        baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
        weixugc@google.com, riel@surriel.com, harry@kernel.org,
        jannh@google.com, pfalcato@suse.de, baolin.wang@linux.alibaba.com,
        shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
        youngjun.park@lge.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
        anshuman.khandual@arm.com
References: <20260410103204.120409-1-dev.jain@arm.com>
 <20260410103204.120409-3-dev.jain@arm.com>
Content-Language: en-US
From: Jie Gan <jie.gan@oss.qualcomm.com>
In-Reply-To: <20260410103204.120409-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=bcFbluPB c=1 sm=1 tr=0 ts=69da347a cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=7CQSdrXTAAAA:8 a=k2Dk1EQm_lty8cjT5JkA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDExMDA5OCBTYWx0ZWRfX89tXkFwhXeer
 i9BCXy2KYpDXgJ0b9i03bctup3Jd3Q6nL3lHZaUoPuGnikatDodHFjygTPuArzYv0QaQWZiRJfY
 8wH0yl0lIMCFHiXgNiAhRNY7U84CYuO2jykDOCvvxSIGy7bnHnBz7Q5ejcSn0iDvDpzKlPlNTnj
 y9QLmeumrARrMRL8OAMlJeD3/KpY7q/KSqJO5v4KRFXB82l8tGxPxK10xdzOHuF2eAcEwAgCLBg
 bBCWa0kTlmejRXEaMnynXCbteA8oztN96BA4sU6G77ykGQgwHWakMjRfNOFCE/9EKGf16B+gfs7
 0WTyy28aVADSlP5VSoFz8htEA6Y9wwwtSOvLpuy9jQtFAJ/Dz/LDklqySvRVjP7hY3+3xVFFgW/
 pFtgt1O3rxAmlnKXgbFCGhKfcM8rxlZ4w/aaBv02h6shpA0VqQjpYDFFsedJ2WVAtFScRBSsWk/
 Ancs00+bLi4ruwHXrDw==
X-Proofpoint-ORIG-GUID: I5d4jYjFoDO4OXVdVSp7ycHJB_s0lxa4
X-Proofpoint-GUID: I5d4jYjFoDO4OXVdVSp7ycHJB_s0lxa4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-11_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 suspectscore=0 adultscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604110098
X-Stat-Signature: 465rsbifue775cni99y1ix9c1dax1t93
X-Rspamd-Queue-Id: B60681C0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775907963-479435
X-HE-Meta: U2FsdGVkX186uhD6B8/zKalBr4kT5eki6VoZrcWNrXjW5/nyYIAAendlES4PhN6fTGtzc4SV4kPu83I7wYzrq2cSydKHwzvgV9duFM/5BVf1SQXTAxNDEMfxqw5NMaEjds9PCsMKAYk8M4jEvfW2mvF1YAmhRiKnLUhTxRdOjOci5ffIhAWiY5swz2sl0QVD+QUI0Oh/6DnFgV5mDy26eVM23C72qzHU1cvp24/NvBs8hEUbiu4tgqZnOxz9wMl8AQQwLQnH0tAgbQNAZpIAHX+kPGljaH7dzzS9u3NNzVh6jfhMldoyb7RhqjTvqvF42bKGNyZD5bJgt2owS3giHTDXUg9uQkXQip28SJZ/7HeNuxzCYo/G7kR52b39csSMkpoKjwWDrBiwtgxt7DtPEcKLssrtB3qosaBv28lAQJLO7Soeob+M3qyudCIZ3Y+2VQUaVmSygvFsnjgFMhvdizHCYOahwi+ebe0on7SlSC06cfpKqL3zePDFMkxrNzknhD0kHt/l75YyMmEwtIw/uxcR+60VHc40Bb3MB02WXR7rKEX+kb7QfjzHgdS+Sjuj5yJQlSgef/uRy4bupYxijL32ImbHsj/qboPIX6TYpGbmZybV2FpvXlr9/p55mME0TYE7d3tzMyOB34kKkE+oX3dMDAo7jpShspMaqcto9gzwNMoPZsU/gUoclnfdrRs0mQlUCa6iNmEqbL1J4Hcch8poXnJNCefmfGUkMymto+7eVwCEA/wd2juu+M0jJCc0k/u1Kew8BSyqje9tP6CTfkFUbEJzsTARy0fU90sDH5AT31DVJWjQ7m+TFsrOud3vPMWgyPzjn+6vEk8tlchLAh1+aj6emv4Uh8d6EP66o1oC/57tODNvf8jLYIaeHCSG2siwD/H8zK2+5Hmayf7EREoS0qL1yhxIlBUsniGF1xPWLz2IJw0SBu4T6jPGGOMZYgvV2nW4zGSUbr3h6/7
 lO1JIVy9
 OB4o9rUiorHe7/qfsVsyrjn7GhvXGJtB6gWJJreHJ3VT0KN1vJTocbT/kwZF8qvqXl1Pp0evJlkUG1YiLjWmOblPnljZuozWUtzyMzMrES47aeY+xZWdS6eEFZaqAvrIT+bKt5sHrJZUZ+wVpladBKDsXO9Rd5LWTc411I6ErOWTpsEd6sJGkt7Kl5dVRNMJjoyMkAHSj3m1rEvj1bn36/B87HHda8Ak4xRR6pYi98cWI1nB1Jmq7LxfG12YJiViwBhsePXgH4iTrii9u2u7cyOydN8oBv4Cs98sXh5+uvybOdIn5UoM8hklXnkaQDh/maROJxdgXw0GdzyGECOAY7YLtHLkGywZJ6N2z73SPRx0k3PkGUUS7qqb6VL6rdlo/+MMpCUIv25Z/Cet4KTH7Y88gxEPIMZf1MYFUFR5lX616KVVdRR6rw5O+okS3dGtrbeP2MBxYoiWjgesckuXGYOxqhbKyl7DTmg9ytl2BzxyxT4KpGhtI0Iln2QvCU7yoVrbdHFd6gN1BQ796hFfQpSotYDVDjV/akJzCxxdRmkHz174QX5UWD3GUdquxadAv8SyKXLTB+v5IYsmiVnzREuPHuKjSHu937LDnxuQMQsqnWdWjl3hCiOz7phKwXKlvbEY/rhtZ4+pzJ/Zfwh0mVZSUxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/10/2026 6:31 PM, Dev Jain wrote:
> Simplify the code by refactoring the folio_test_hugetlb() branch into
> a new function.
> 
> No functional change is intended.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>   mm/rmap.c | 116 +++++++++++++++++++++++++++++++-----------------------
>   1 file changed, 67 insertions(+), 49 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 62a8c912fd788..a9c43e2f6e695 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1978,6 +1978,67 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>   				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>   }
>   
> +static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,
> +		struct folio *folio, struct page_vma_mapped_walk *pvmw,
> +		struct page *page, enum ttu_flags flags, pte_t *pteval,
> +		struct mmu_notifier_range *range, bool *walk_done)
> +{
> +	/*
> +	 * The try_to_unmap() is only passed a hugetlb page
> +	 * in the case where the hugetlb page is poisoned.
> +	 */
> +	VM_WARN_ON_PAGE(!PageHWPoison(page), page);

As you mentioned "No functional change is intended." in commit message, 
but you have changed VM_BUG_ON_PAGE to VM_WARN_ON_PAGE here?

> +	/*
> +	 * huge_pmd_unshare may unmap an entire PMD page.
> +	 * There is no way of knowing exactly which PMDs may
> +	 * be cached for this mm, so we must flush them all.
> +	 * start/end were already adjusted above to cover this
> +	 * range.
> +	 */
> +	flush_cache_range(vma, range->start, range->end);
> +
> +	/*
> +	 * To call huge_pmd_unshare, i_mmap_rwsem must be
> +	 * held in write mode.  Caller needs to explicitly
> +	 * do this outside rmap routines.
> +	 *
> +	 * We also must hold hugetlb vma_lock in write mode.
> +	 * Lock order dictates acquiring vma_lock BEFORE
> +	 * i_mmap_rwsem.  We can only try lock here and fail
> +	 * if unsuccessful.
> +	 */
> +	if (!folio_test_anon(folio)) {
> +		struct mmu_gather tlb;
> +
> +		VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));

ditto

Thanks,
Jie

> +		if (!hugetlb_vma_trylock_write(vma)) {
> +			*walk_done = true;
> +			return false;
> +		}
> +
> +		tlb_gather_mmu_vma(&tlb, vma);
> +		if (huge_pmd_unshare(&tlb, vma, pvmw->address, pvmw->pte)) {
> +			hugetlb_vma_unlock_write(vma);
> +			huge_pmd_unshare_flush(&tlb, vma);
> +			tlb_finish_mmu(&tlb);
> +			/*
> +			 * The PMD table was unmapped,
> +			 * consequently unmapping the folio.
> +			 */
> +			*walk_done = true;
> +			return true;
> +		}
> +		hugetlb_vma_unlock_write(vma);
> +		tlb_finish_mmu(&tlb);
> +	}
> +	*pteval = huge_ptep_clear_flush(vma, pvmw->address, pvmw->pte);
> +	if (pte_dirty(*pteval))
> +		folio_mark_dirty(folio);
> +
> +	*walk_done = false;
> +	return true;
> +}
> +
>   /*
>    * @arg: enum ttu_flags will be passed to this argument
>    */
> @@ -2115,56 +2176,13 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>   				 PageAnonExclusive(subpage);
>   
>   		if (folio_test_hugetlb(folio)) {
> -			bool anon = folio_test_anon(folio);
> -
> -			/*
> -			 * The try_to_unmap() is only passed a hugetlb page
> -			 * in the case where the hugetlb page is poisoned.
> -			 */
> -			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
> -			/*
> -			 * huge_pmd_unshare may unmap an entire PMD page.
> -			 * There is no way of knowing exactly which PMDs may
> -			 * be cached for this mm, so we must flush them all.
> -			 * start/end were already adjusted above to cover this
> -			 * range.
> -			 */
> -			flush_cache_range(vma, range.start, range.end);
> +			bool walk_done;
>   
> -			/*
> -			 * To call huge_pmd_unshare, i_mmap_rwsem must be
> -			 * held in write mode.  Caller needs to explicitly
> -			 * do this outside rmap routines.
> -			 *
> -			 * We also must hold hugetlb vma_lock in write mode.
> -			 * Lock order dictates acquiring vma_lock BEFORE
> -			 * i_mmap_rwsem.  We can only try lock here and fail
> -			 * if unsuccessful.
> -			 */
> -			if (!anon) {
> -				struct mmu_gather tlb;
> -
> -				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
> -				if (!hugetlb_vma_trylock_write(vma))
> -					goto walk_abort;
> -
> -				tlb_gather_mmu_vma(&tlb, vma);
> -				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
> -					hugetlb_vma_unlock_write(vma);
> -					huge_pmd_unshare_flush(&tlb, vma);
> -					tlb_finish_mmu(&tlb);
> -					/*
> -					 * The PMD table was unmapped,
> -					 * consequently unmapping the folio.
> -					 */
> -					goto walk_done;
> -				}
> -				hugetlb_vma_unlock_write(vma);
> -				tlb_finish_mmu(&tlb);
> -			}
> -			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
> -			if (pte_dirty(pteval))
> -				folio_mark_dirty(folio);
> +			ret = unmap_hugetlb_folio(vma, folio, &pvmw, subpage,
> +						  flags, &pteval, &range,
> +						  &walk_done);
> +			if (walk_done)
> +				goto walk_done;
>   		} else if (likely(pte_present(pteval))) {
>   			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
>   			end_addr = address + nr_pages * PAGE_SIZE;


