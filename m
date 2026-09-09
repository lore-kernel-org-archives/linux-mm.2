Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9EAC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7ED6B008C; Wed,  9 Sep 2026 13:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468486B0095; Wed,  9 Sep 2026 13:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BCA6B0098; Wed,  9 Sep 2026 13:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF89C6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:21:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25E35802B2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:21:47 +0000 (UTC)
X-FDA: 85194891054.15.9A32ECC
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3F11EA0008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:21:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lnF+tDfL;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=tZkdnzSe;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788974504;
	b=C3rz2fK8u+fZcA/K/QC4BORCaLyXKTtyqoMe13Qmh3I8rRCLfr6OE39Aj8ruqXiRPdO6+M
	g1HDnBwRtXsTNovtur1tAPGw8NmifR7leHOabsUl7tcbLRbKgdVy3P+JB7fxeoKNjeIRSU
	kwbIQ8Gg2kBZtRXSqxuTuvFF1lqWX7Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lnF+tDfL;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=tZkdnzSe;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iW6sRnR+oQYWv1NkGkTa8AIJzqy44SrJn9mDEbTMddw=;
	b=tV2DqA8pFy994xnZ6ohbTrR98t9iqUlKSOGJt64CJL+JW4TEImgXmJEWL1GcijEztWkOs6
	GPw6HTbV1Y02M0OWH2IH/jYaTWTjml5J/TIkRoMJU79StJZcEUeUOLzg3slSX/ZkFdasPb
	Y07DPm+GqV0Zgr53sf11H59w3Pfu9Ow=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689GZGLv638863
	for <linux-mm@kvack.org>; Wed, 9 Sep 2026 13:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=iW6s
	RnR+oQYWv1NkGkTa8AIJzqy44SrJn9mDEbTMddw=; b=lnF+tDfLDLC8zKGeJ7sI
	xJRtIeZcNmXG67Zr5UNCF1jcUSs7Md6RqW3R8kY6eZrCG9TVNI1Yv+yWlQZkoyxq
	FcVfcIdTqnVbLEFqBdLQcYGzf6a1eOJTGf33c0PEH1gsXdMHLOHa1fHresCicD6U
	hWzWNsR+qVSKFpg8DA1Uztk5Wmyg55jb58Dpt55AgxlYchc2hPL34WEb0ZPRmGk4
	XcZR1lxgEWXDmw54cBX0Qlv5FwHZl9d67dFz3cHGXK7XORSdN7F0Lk0MBhtmFY1J
	swFKU15gKmi9tUGWNQi7gR3DCAA9XUsgQi0wveu/pG3xI4T1h8cnoKKJ2VkVBlEt
	/w==
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com [74.125.224.70])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gk41jv0hk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 09 Sep 2026 13:21:42 -0400 (EDT)
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66c7115a286so8347525d50.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 10:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788974502; x=1789579302; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iW6sRnR+oQYWv1NkGkTa8AIJzqy44SrJn9mDEbTMddw=;
        b=tZkdnzSeE+qn4SqFXJkuKvqXCWhPlBdtQF4PUgVcUqKQhu4DQp63mM157xMQblDghK
         DQRn4sOSTQjXB8Y5V7iRPWjg4TfB0sZtRSAXCAXinop01FQBYUO4Fr3gDUTVga6HQnNu
         MiVu5kECw80+Niw3euqCtFd1/Sz3t81z4NnZNjL/e9Q1DVTcqS4BtwusPOOnJ5C+iGzq
         G+l5wjCQ3V6F2HTtE+T74aI6KSQFJvIYfea2LotSynGEYbDcRi/uBXbEVyKA0ifUZ8jE
         6loK9JBvgyIm5zgs4KYvGTFrusm7dzlhBmTIET5BLJ9ImCZbhKkqIojhjhyw5qAgJg9x
         vmAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788974502; x=1789579302;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iW6sRnR+oQYWv1NkGkTa8AIJzqy44SrJn9mDEbTMddw=;
        b=HkmgV+0vOLElnzy7mJwO6c6rhWs+eCbN3bnjbppAB7+epNOJnK7M60ZDETHLn5kwJB
         Se+5Z4IMneEkGvNtT4ENseg4Bjm0gktKh+998SDwNAIPnuAdmQMgt9ngcBUW6UtlKkSd
         ggPXEECBfBAWhyKWIPV0kxxynNRMq9oLqIOKBfA7VJPGyxx80c/AKrfMiT+pxAG9ek84
         UowOJzC3QcnQGr1gUBWC+NiJNygZoPhewmnfHQiapoLSWeQ3rjmCAx0xCu9sTFcPsIVa
         v9nHwRt3sd13G/f2E8fZGf88BsuhWkKX5VTtWiN84kogoKz5rfqbRfgVCDJcTVDG3GXm
         gwuQ==
X-Gm-Message-State: AFuF++nrH1HYN90NsY9Bq84eYR3k87h/Uq+0IFpZsugCLF3n+3Y8kHOF
	42w8ZScS2tCVTPH1FkaktSln5jy1ZB5KG0F0WD8xknitvhaqFhVJcUB8rTY3k3mzi3bAPjEpnRT
	SQoVXnwqrOVAO5+qIm0343bYKPfvFKrFPvKRNa7KNWIRAgtks
X-Gm-Gg: AYBFou1DyYVAg3DHSm1U9mqWxNyl+oG41+6LBNv1UhcJdXe/HFDJmwLVTg2UVPvhR9p
	fqnU0R74b2/le4p+Nl879Ro00bXnYFPspoXCoiDSw+EVzE272H6JOz7mx2RnN+ocIXvZuji+6Bu
	Ltpbl+MIotUlqsOOQEr7bOOt7KzwqumdOr8icsZgbC2aLC1ufZxuV2RZkRNw22uPACjE4m0GK7O
	lst5f1+IYCC92HP0Kv7Y0HerGse+r0EOyfvI7liCeSG8mmENdyFIuRzOz88p5CTC0lN++3Q1cWQ
	V+MSAsjvG5zZEhb3/yeeMPXgfFxHpSlUqvF7syCuCNYjvuvGsOkFKUEvlOHDRCoXHH+cPMDF7/P
	NEXjWrTx3kVcNrzPJtLz6XJ5VvPuKrkKGgCMaCosCWAwOggfFqzC9
X-Received: by 2002:a05:690e:4141:b0:66f:bca8:78d6 with SMTP id 956f58d0204a3-66fbca8b1d4mr11506155d50.18.1788974502296;
        Wed, 09 Sep 2026 10:21:42 -0700 (PDT)
X-Received: by 2002:a05:690e:4141:b0:66f:bca8:78d6 with SMTP id 956f58d0204a3-66fbca8b1d4mr11506121d50.18.1788974501815;
        Wed, 09 Sep 2026 10:21:41 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-176-193.net.columbia.edu. [128.59.176.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9106702d8f3sm43456006d6.23.2026.09.09.10.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 10:21:41 -0700 (PDT)
Message-ID: <cf9a0873-5ef1-4a5d-ba16-8ba3583ac8ba@columbia.edu>
Date: Wed, 9 Sep 2026 13:21:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] mm/swap: add folio_swap_entry() and
 folio_page_swap_entry()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
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
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
 <20260908-folio_swap_entry-v2-1-ee6d01dfa5e1@columbia.edu>
 <d0aa1ccd-d99f-4fa5-98c2-21cea0f413c7@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <d0aa1ccd-d99f-4fa5-98c2-21cea0f413c7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE5MyBTYWx0ZWRfX9EnCQji7iY6b
 JhwJ4jlwiLbM+CS01YzSWYOpTFycKCLGkQGcZ+ofNTUFZAw1rTJIEElfWYospXEVaoL3odHJ0T3
 7oMlO0lajqxQ4GmB/NbljeAGTvVRnisUWgiludW3487MIVRAlRUjf1LGca0oQD4tLEA05Qh3lXm
 U3/C//gBZuTiyUqeETC1crMwpn1vAO1PIP+WCrOWWB0N+twJ4AY0c/oX5IADrDaiognfDs+j/9h
 Vv3iZXBJzmxg6CdiAC3l+znWa3gM67YJDGnUJcK3vhOE2czg1hxMZ4CX/+FdfrmTTAYH+8f+H7z
 lXrD/0X9JFCrr4W+iA6pSEQQZymAgbAx0magNwy7vgSXgDrkAd2c0fpvQ/uW0yGigZm7RLg3Nns
 fF/jg8vx6iWZHmM4Ez/TGGKbe+pgNBr5eSukJTOTKIoxGHvc/5Y5N0KyG4t7IOD4t9IlObtdz8p
 jIDuNXqF9UNPcyTJV5Q==
X-Proofpoint-ORIG-GUID: 0CNu7txkP3UkpmqlZnvpz41tkIxlJt1L
X-Authority-Analysis: v=2.4 cv=PMw/P/qC c=1 sm=1 tr=0 ts=6aa195a6 cx=c_pps
 a=S/uc88zpIJVNbziUnJ6G4Q==:117 a=fJxgZNdXt3opHMdyAp+FXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=umqIAqnQUIpxI_lDA3YA:9 a=QEXdDO2ut3YA:10 a=nd2WpGr1bMy9NW-iytEl:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE5MyBTYWx0ZWRfX4oWUSdrnalM6
 cnuvhxdPBPugW2BHTkvO+/NUEbleYZS0L6qlY7pexHOJ+YiwpByP2T3VJS4iBDUJbMgPIfv7hfW
 0KJMekGWEb7vD2ppykecrCMDWPsVoMLx7SClrCW/4ShmCIWo3BmH
X-Proofpoint-GUID: 0CNu7txkP3UkpmqlZnvpz41tkIxlJt1L
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=10
 impostorscore=10 phishscore=0 adultscore=0 lowpriorityscore=10 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090193
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3F11EA0008
X-Stat-Signature: 3rhmyjrpx6dkuh8y1fx5c9ryg5pq1auu
X-Rspam-User: 
X-HE-Tag: 1788974504-873532
X-HE-Meta: U2FsdGVkX1/Aj4LF9LjhxBGJVI7gm1kGGZwYXeZ+v9wnDTATujTooOZdDoQ5xCebvv9Elfau/Mkk/LCgjWV8F3mjcQQZX9QBDPyXrXg16phwUeegII4Q9CvQPcz0AxzRifBbEPLXmWkIUhwwkEw+Vf8+Ie3Hq2Nyspv5xnfvkeXX/yxMiy33kuYeHYAGglI7FKXbH5A5wzV6zYtA+A6oALNpvBYaXNIv1hHG4x2H11iGutJTu0S7YDCV+yNNkFMC2Rh7z39PEyhmLQMh6wrEmbSKLSv0g3pEp1fa1PlPYcFTH6VR9DKGmwbDXBQVLpWpaUxWJxJyLQfHywc8P5lJaRVf7gfkugYql77St119Ia6vosC1dqy2BXrlIUSIgrcmTioQ1+9vKjI2G6TLkmLtFVfU4KOmbBwMDu2XdO7djjK7ox6on/jpSBBiLlTZry7V3T5HtBLyPG57Q+1qAUUIJujIJdIC3GTgJJg6jkpB750O3D5r3medMaS7d1FOmI1m2blYp1neNlyxjjmuY2xhm6hwpTrVRpxRAWaBZ5IpeRzVrg79h4aEDR2DQYJM6w/RjUB2Qaqo8SXPr7lTl2FUhZkz16L6QOoclzlqn3nUf7Y3vDseF2cfmoobWGZFFpSjE+FxKwJT7AfdKsgBO6RX+ce23sdgv74xIuZ27c5Gzx81mIABUx4Af7JH7wkl2RR34xMKl4kzzovvty6NnzpzsicFpsFAA+Ke8y5YeiiU1FWwTKEIJDJTdazw2387/8nzLWHm7dCWvoW+ArGAcIZi/ZPCrqU/T4grR9eMZYPiJk8EYAg1mZaqOChvYpCyeyqqUU1zwep+CVQF1eJ8o0/jrX+Q37kyGwbEZB9TcJ6WsFaPGHipCK0S1ca1dED3z0EJISvzsjB23JQUnV87O1ZQwfNSj4Vd+0Wcd/LjgkE/QKYvG7+MK0XOoHwuSR6BJndotvdcg0129nI1GoV5Z9r
 FZNLgrAw
 S2lPWRlQs0YphL/uGsUqZYHWJK6vR/SUXaD+WVQpdx7FZ1+WXOdeG/JWFnsuAIi/4yK9d6XncAGGdmAvC5lPSst6mgm0ZpkKAuKsRCxw4BOAaxrKXhbifA6AkUCjcc5x48RULgUPkAaywDTOi7pjWVHCv4cfa+9OuOvf5T06Rg4D3ImynBPGbvBF8QWeXKQAN+Aw+xhHY9RGsgFxnrU+B5Pc/bDP9f/+1ha7SKK7G+JdBFOUOBPY3r4WeN92BMk/ex3DSKu8O70Rb1jarusnPa6FE5lmsF5olMuqEKQ4lVMSghlQlbwnJel6nzbQOUdaGZnItkYuK2wIR1v30u1kcGW6q3w/KrRaIVm9sgQRyvX6XMoB5OMZKHe4M3l34we6jRhkmXCza6+q2ennOykDERZ+3l89/4wskq8av+qVC9H5nw+Uo9W6UnxXUuhde6V5lUZszGD53vamJWfaYOoK65KMKkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 5:00 PM, David Hildenbrand (Arm) wrote:
> On 9/8/26 17:16, Tal Zussman wrote:
>> A folio in the swap cache occupies folio_nr_pages() contiguous swap
>> entries starting at folio->swap, so a page's swap entry is just
>> folio->swap plus the page's index in the folio. page_swap_entry() hides
>> this behind a compound_head() call, and callers that already have the
>> folio sometimes open-code the arithmetic instead.
>> 
>> Add folio_swap_entry(), which takes a folio and a page index, and
>> folio_page_swap_entry() for callers that have the page.
>> 
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  include/linux/swap.h | 33 +++++++++++++++++++++++++++++++++
>>  1 file changed, 33 insertions(+)
>> 
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index fc290e29e4a9..1d979e76e78a 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -272,6 +272,39 @@ struct swap_info_struct {
>>  	const struct swap_ops *ops;
>>  };
>>  
>> +/**
>> + * folio_swap_entry - Return the swap entry for a page within a folio.
>> + * @folio: The folio.
>> + * @idx: The index of the page within the folio.
>> + *
>> + * A folio in the swap cache occupies folio_nr_pages() contiguous swap
>> + * entries starting at folio->swap. The caller must ensure the folio is
>> + * in the swap cache and that @idx is within the folio.
>> + */
>> +static inline
>> +swp_entry_t folio_swap_entry(const struct folio *folio, unsigned long idx)
>> +{
>> +	swp_entry_t entry = folio->swap;
>> +
>> +	VM_WARN_ON_ONCE_FOLIO(idx >= folio_nr_pages(folio), folio);
>> +	entry.val += idx;
>> +	return entry;
>> +}
>> +
>> +/**
>> + * folio_page_swap_entry - Return the swap entry of a page in a folio.
>> + * @folio: The folio containing @page.
>> + * @page: A page within @folio.
>> + *
>> + * The caller must ensure the folio is in the swap cache and that @page
>> + * is part of @folio.
>> + */
>> +static inline swp_entry_t folio_page_swap_entry(const struct folio *folio,
>> +		const struct page *page)
>> +{
>> +	return folio_swap_entry(folio, folio_page_idx(folio, page));
>> +}
>> +
>>  static inline swp_entry_t page_swap_entry(struct page *page)
>>  {
>>  	struct folio *folio = page_folio(page);
>> 
> 
> "Return the swap entry for a page within a folio" vs. "Return the swap entry of
> a page in a folio."
> 
> yet only of the variants has a "page" in the name :)
> 
> A bit confusing.
> 
> Not immediately sure how it could be done cleaner. The minority of cases seem to
> use folio_swap_entry.
> 

Yeah... I considered naming them folio_swap_entry() and folio_swap_entry_idx()
(or a variant of that) but I liked the page version more. I can update the
comments to try to differentiate between the two a little more if that would
help. How's "Return the swap entry at an index within a folio"?

> -- 
> Cheers,
> 
> David
> 


