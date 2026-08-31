Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1EECC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 23:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D165F6B0095; Mon, 31 Aug 2026 19:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0096B0098; Mon, 31 Aug 2026 19:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B42186B0099; Mon, 31 Aug 2026 19:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 806636B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:38:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 756A814029C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:38:27 +0000 (UTC)
X-FDA: 85163181054.18.4376932
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id DED8CC0004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:38:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fNSgbsm2;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ivRC0qkE;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788219505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArSGj7c2DTB+uNsBgzHLh0fINaLzVW2mblZJGAkXJLo=;
	b=2VlfZDoOh6a2e/1fusiRyrjgHKsr+kzsvrkUAbJfnf+r+VSfQrBvdDCEzjQQj7+FREx9h9
	zb1oVgPh56uZwr0iGvLiTCYke9EtYspQpfdzRv4FhosU135qt8kWdmuVw3KkgLlCBd2ZBZ
	RZj3xcXqz5dWLStE07cSnu2vAtrh4LU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788219505;
	b=S1Mzx0698liqEwNDtD5eLwIfcLuC8pvVcaGzGZbtsbwZqQJjP6LfPUD689Oy4be7Ao5z/r
	AwD111CxqwEKB1FwbfHUd17ta6eEQKlk0fvC7FUUbpmCDgjbiOFCiFVQUBiPVL1ApXk1y/
	FIr6uzJ4odEcQy+rJLC5bQyAzouOzqE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fNSgbsm2;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ivRC0qkE;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VMYlbC3590062
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ArSG
	j7c2DTB+uNsBgzHLh0fINaLzVW2mblZJGAkXJLo=; b=fNSgbsm2VvfDqMfjzfYO
	k0YKPxEysqgiI6D7Qf4ZFTCDJV9N0QIuF2BPZOoiNOV3kiSxo7SP6AlJBGetjbTM
	FpQgZwtkh+gLVBrDjDS8LrlTU+1kF796i5o8VKkueQX0cYI4g0RI0IqReI63OU3z
	9qjXb1dFa2QIa51yi9Q3daDT7vMs8/zG/QWrYMjPKslBk6cON02goPUKF/eL8wgV
	RBu2yXtAHunqGaw+PDFbBTvPhtSsNfZSBDttQzy5gnGNdopWC5yPuweJSwZec+eD
	eFuqMD0TM+s/mOf6s9NzMwyi1qwUBYQSYJHucxHv0UpLURgN1leF4AhgPMCnOcw3
	jg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gdeqba4nt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:38:23 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-9390a2c895bso905516385a.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788219503; x=1788824303; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ArSGj7c2DTB+uNsBgzHLh0fINaLzVW2mblZJGAkXJLo=;
        b=ivRC0qkEb0ADupMixlmwTN4R4o4l/L3t23EwlI1KEZyCaNPKTLQmQ4D08NAuibibAa
         vXhvaHqyiKJ5fQK6KkqrxRe73zVRu2eKEtga1RjqP8bCl8uyuE64ofA4mw7ftOxTrW4J
         J6ZWr197S29D3YOVz2Qg+h0ds8+2wxmiFJ5a5vOxGhiT/xzCsAPlfQiureeKi/6Q15nH
         /b7XlJl053ZP8PDrbWhS3kUgCD0vL8umHwFShuvJbEjjUYJ5jpgzqkie4KNTLraTbFL6
         Jb5A+xQofiYV9LcctI2NrVoYmRdeH2iJvCtYYxHthRX/iREd78l41sJ6lQLCXplWtmlX
         M+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788219503; x=1788824303;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ArSGj7c2DTB+uNsBgzHLh0fINaLzVW2mblZJGAkXJLo=;
        b=bdwZhQmJJZ2DFy6rb9OzrSXBR+QuXFS/S97u7bRrWxlSI+QE67s6c4+zZTqqYLFUkC
         wOkGQcSzM3xbQZbu48dUmi4HYuUPPxtFkRMn2BSEJvO6/JWvN2NeNWOkglpsctKLGGPF
         OU3YxcrkwOp0ImBk1e7pcOXldQaE0797BO0A26f8kn8y19b7C04bRjlsNdONZcdPyTW1
         /jPdNcp9ZYelD2WDhkEvy3/Eg1bBq/fVkam4FD5gyDgrbpabGefdOcTChI6ZnTEQvUNt
         36YlF7TxMadQwOUtp2UjxOuVFEtlZa1jIo6MD6hxK/U0QpH7c5yjFBZfuYLF841pTJNg
         EAsA==
X-Gm-Message-State: AFuF++m1+WyMMgVuJbn99tpdgblCDo+TBaBb7MTfwDJqBidwcg+VvzuF
	yL9vAq+dL5JJoka9s1Q6tCpOD6i5a7tNMURyJND9fdH1yjGfJ9DVW9Y0WFf2oWyXoHYAkmfvjbA
	DhbEytq0ruH7eSNcO4iaD4aoAtGzzN4AIlakNQUw8tt/UIIoH
X-Gm-Gg: AR+sD13Ody7e9WwLzPwIraJUphY7cW9QJ3k3Ll5sSbiIAF6dusRU+dAzDmSludm9/w0
	ONp1qS/8s2uT7aDaGHF6Vmro2OMyG/JGoekVGxaQuy2mm/NgPV8mfOaxsaA4cSUz5gcufdguH54
	7UMNvlu/CpOYADoUsgXYgqnVUpfFGQcL7NDRmLyjvzyltFgu4lPT03AFB6+7B8024C6BEQOxRRS
	Ph5KCIOy8O6n23o+6c9r9mlJPunxnIdvfoZeDF9Hxfw+aFvmIw3rvQ3P9hUlRMnX5U1hlwheT+A
	A2QUY1HgMEtEfvAGbzvWk3X8ZPIzHfKSV5zRr1P5CUlY3FXNYPUTboZxK9t/6hLBD+flVqsHDdi
	V49yiwkOTMzeYAmg94ijXb5sJym8fFrWQtxrJfoQS1inskNMUvQ==
X-Received: by 2002:a05:620a:2acd:b0:936:dbd7:fcb3 with SMTP id af79cd13be357-939138ffddemr2919446885a.21.1788219503254;
        Mon, 31 Aug 2026 16:38:23 -0700 (PDT)
X-Received: by 2002:a05:620a:2acd:b0:936:dbd7:fcb3 with SMTP id af79cd13be357-939138ffddemr2919442685a.21.1788219502721;
        Mon, 31 Aug 2026 16:38:22 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939173a4254sm893939785a.25.2026.08.31.16.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 16:38:22 -0700 (PDT)
Message-ID: <61dd4d89-1b1f-4185-903e-a2b1ff089836@columbia.edu>
Date: Mon, 31 Aug 2026 19:38:21 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] mm/huge_memory: use folio_swap_entry() when splitting
 a swapcache folio
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
        Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
 <20260830-folio_swap_entry-v1-2-7786b52acbc8@columbia.edu>
 <DL37OCFFKFCH.2VWZ3CMY3EFG7@nvidia.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <DL37OCFFKFCH.2VWZ3CMY3EFG7@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDIwNSBTYWx0ZWRfX7UwhCLPd4SQi
 2wntIPjTrG9cl9VjHdVd6YEZw4D8+YxfXLhmZ3YpeD2EWVmhgV8wY7zpFNx6a50bjXUiNgeon6O
 og2nFBqXMLAOi0+NCN0Bg9bEAU+82+4dtGe5mU+2EglkKQI8xVta
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDIwNSBTYWx0ZWRfX0c68sdDKAW2H
 JuHIONczzPh6z1esDkeRE69EgUeHLJnkckhH6t5sm0d9swiAnqTunbDOZmYMWlpI27aqVQYPL1F
 pamoKzc5UTHlN4eKpqvwcuijQTH1oeTsVMOKd+N5gxFZobkS+IQ/S2WNAoM/whQYlBJBjIns9jw
 7/6YEU8Yq61AhwJwNL9h+ABUjZr8B6rpxhdBU4tnPSBovnB5Ltdg2IDTI9tbl/m4wLm9vH/9C56
 6cveSMsLFxIMwCqDppVUvEjl6Q10yLmw2D4Zd2vGzjhslsB6BFvzGpCGvT/r6Rw697+Ox5WlFCX
 GuYceNvkjAD0s7V5PiPBE0DnFlhcJHT7o7CweuEpaQtPKs9OStC3zJ/4BicgZCTCI6QMXu/Pghk
 EZ0hPsOmwE2+9CHop+fY5ikMXLAh/A0Db8xtFMOb0IK/wiiqh7CSvbqDSHBNYRsvzXtjHREOto3
 hCglnK8cn3px7qTKtdw==
X-Proofpoint-ORIG-GUID: ydRlbqeqH0apQOnLkiCh8b72PTcRk2MI
X-Authority-Analysis: v=2.4 cv=fcSdDUQF c=1 sm=1 tr=0 ts=6a96106f cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=X7tRCqHdiWbQX_0A2iAA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: ydRlbqeqH0apQOnLkiCh8b72PTcRk2MI
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11892
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 impostorscore=10 malwarescore=0 spamscore=0
 phishscore=0 adultscore=0 clxscore=1015 lowpriorityscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310205
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DED8CC0004
X-Stat-Signature: uqjj5u8sazak336ksttiqfkgt7rmez6u
X-HE-Tag: 1788219504-827734
X-HE-Meta: U2FsdGVkX1+p0A/ZJtIHA0ust0TllPWZf0XL4Qr5Z5vYK5tqi/8VI03kDrgH5VgdsMaJi+uRZl96sNeTqD5qB5FbydfjLgPFfC5fJSJtD/QoKysN0erD2/AJQGNZ3PAf3WX52HNU+0KCf8p6kYuQciS0VKn5QXqL5ZbFdBwDXLihIVBGrkYKlDdRF+NjX6GXLGTi39mNTkKERzOwrkBzrzOqQ51dwyYpfjDqlrRza+fzwtaUt1yVO+NlkmDrHJJV3LfvmBQBVJLFb+1Gkvd8nrQFSdPSy0R492Y5Nl0oo4LvL11Lp4ERWAdaMsu77TBrrc1Hoxd6fFrbe2mhuPlcVw7b/0drcsiKcqEhpXkqOFDtj8oN2iiGDF7987HOKK+RUCe1z4jIBsJGPys12Lo/JpWtLwreDWTLnETyjcLPqFJpFz/l3t5cisqqrVA2/jdTD377VhqFk35KiS58mm2yZReAM78j2WMLqBbS1IHdPKC7JTRwwtwJwvHQR5YSh6VBb4LH2mArjOnuMnLO0jdeiorQ1yOS7cypIsj5ldFI6Z/7yuVdvB9fjcYtVWMyaOYa8/U9KFQf6rk6j/pI8M2mzwwv4rgg0IZR/8hFj4AWZ2WWkQWq2FAKX+AL2FNijAZGgrue+99XiYcpNDvpTJculrK4u4XWgVNJKwhFJ5+GYTqYKUBCx0azR7s9DQzJT9Bg/Ni+yoryMZDa/oJfoBFhbCh3k2de13jUFzODYakG+pFjeTnwXyM6MUmM7dvEHfSoJz51in/ShlqgCAtuSgr8tNoplpzX/6iMRSKZ0cucXgzupOflLNV/aRXnaWWfEYYRilQM+c0nla0LeRwULyZlPRgpC+scXBEZA3q0DbEA5b16+iFY6qupK9okCwhybJ/wI8Hc/DyBqdyYj+YZrggKFArpXsaiBOHMv0IaT8UIv6tdr3UPc7R37kS10HyfWWT8xEZiQj3hWE2JH1iJlsr
 ZO49UHbQ
 Xu+ZV5WxadMp1lYVL15Tx/4q7DqEilohvcXewlfRv6pjx/GFpM9vKHeTU0smuvGhpqzYQF9hzO3ZaOZIWyAUiuggtROq/sPYq0qYasgxIJL1K5fahNx55EJiD1sdGdpN1ajAJkSwUi/6bFDve2Q0CkDhO3KecohP3pXtAzp+5lLvN2hk24BIHRhIWv6oOV7bDJDEEGQfchghPc6Rp26rptTk/7/7Li/FE8bG5pHO9Lkf4v4OjNizwgJusjJlRfu6yx1ksfrrGq+9nGtvFjlz4LCOPvbVmfdPyJdHoJ30yVJpvM0peJVEZu3MqQsbDcPv6FjFtBi7QJrQCNxar8cQuWmFt6mJHPcPaimnoJGxHRzQfmfq7oKg+NUAvkoPzzeU2ISy8vcqR9nA/0YnRyWi5J5kJq5iEf2MhbHE3XwUo1vmDkOZ9laZQemeGtBAwqFnA9eZuYq1qhKJZ90jdb3HDDRpFmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 5:50 PM, Zi Yan wrote:
> On Sun Aug 30, 2026 at 6:32 AM EDT, Tal Zussman wrote:
>> __split_folio_to_order() open-codes the swap entry computation for the
>> split-out folios. Use folio_swap_entry() instead.
>>
>> No functional change.
>>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  mm/huge_memory.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 54494c3fa983..03287f995d92 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3760,7 +3760,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>  		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
>>  
>>  		if (folio_test_swapcache(folio))
>> -			new_folio->swap.val = folio->swap.val + i;
>> +			new_folio->swap = folio_swap_entry(folio, i);
> 
> folio_swap_entry() checks folio_nr_pages(folio) internally.
> folio->_nr_pages is in first tail page of folio. If new_order is 0, it
> is basically checking memcg_data in the first new_folio. And after first
> iteration, folio->_nr_page will be clobbered. Without
> NR_PAGES_IN_LARGE_FOLIO, folio_nr_pages() is derived from folio_order(),
> which is in folio->_flags_1. It can have the same issue.
> 
> Please keep it open coded. You can add a comment like "during split,
> not all folio fields are avaialbe, open code the swap calculation".
> 

Thanks, I'll drop this change.

I was debating whether the warning was worth adding. It'd be nice to
avoid accessing swap.val directly and abstract it away, but given that
that's done in a few other places too, open-coding it is fine.

>>  
>>  		/* Page flags must be visible before we make the page non-compound. */
>>  		smp_wmb();
> 
> -- 
> Best Regards,
> Yan, Zi
> 


