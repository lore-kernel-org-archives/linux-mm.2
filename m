Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F0AC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 19:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699B76B0088; Fri,  7 Aug 2026 15:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A2E6B008C; Fri,  7 Aug 2026 15:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5609B6B0093; Fri,  7 Aug 2026 15:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5CA6B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:44:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD81C12015A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:44:39 +0000 (UTC)
X-FDA: 85075500678.10.16342B6
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1E28B1C0006
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:44:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QfX7SW0r;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786131877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0lx4iywkNKxnTPjSBYYQtmhkZa83nvl0Z99WU/9Vws=;
	b=HyxM8PffGKPN3Y/bhWzUIh0o33ruhSmLLgy2VU7JrVkLaarUiPBvBiyybOSqTXUTmatjmL
	DmANys2uIAzR0XThO8Ax+8d7T+9gspg5EUX1axbrVmG/pZHPP2A1M6Uo7UdSkfQBLsaOqw
	d/as2DkOGXkxx04bCIXKcV2prqf7nkc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786131877;
	b=PxgSHtY2E3UIvhUbKC5ZUvJzX7x2DTZu/P0g/MaWN7KpcjEGTK7Z/nzLA++Aztox9Hd7w2
	sDG+Dl7g2TGZkqdQHT+MRs/OagHTwrBysn0KC8idSXA7HMED9OFCsp8qNftFvSLmuLiu6q
	hzzTVubBGXgueyuLvYC8I8/wbbyxnNs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QfX7SW0r;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677JMcON3447993
	for <linux-mm@kvack.org>; Fri, 7 Aug 2026 15:44:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=C0lx
	4iywkNKxnTPjSBYYQtmhkZa83nvl0Z99WU/9Vws=; b=QfX7SW0raxUXgtNulJxJ
	mWFRDUSsTkumiLcTsdu/PJuc6IBS9SlYPx+BM8e/KPInveQ9gjg2oULeK936M2u5
	rcEaGyQGxmE5Pi+LsSkVB7YexSFifILIg81furOM+hb+kodlvbdEylSeR4qUXfyA
	WaQmRXd/OrgZvSVeN+MgwO9OEH3NUcTXy8hBpFJAB9BpWvv7GwfhJSjcsF8pL0yj
	dKP1b4neDUqddMrUTYayKfdcdOB/27TDicbrtTHy0HEUCQqdCciWmxS1H6hhh/4u
	u4ddF7FW2k8kfmAlgXu7yntT//3ZAw45sCfHl1ytCrmwtvMrszqE/H7JDFhiyaC4
	kw==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fwg4e2xen-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 07 Aug 2026 15:44:35 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8e9489f62bfso38145156d6.2
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 12:44:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786131875; x=1786736675;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C0lx4iywkNKxnTPjSBYYQtmhkZa83nvl0Z99WU/9Vws=;
        b=rbE7MBbwmeoHHbO5xEGXXrZ8YHUVdq8/T4Rn1FtxUMyWO2l3btU7eLxhw6KcRg9DPq
         K5d6AUiIcqLCTMBdI4V2DIDKUTY9Br504Nb7u0JADXLgHca5dLUNbQ6C93+xXrYJzQvA
         K8nadbYBTaamazcVT6aPqbkyqNOr1+4yTivo7FpUyHdGtANjMtTjUFCLU01zHYKYHqgW
         jyMNCpA1uK4NQYIePwDrqqx9Y395FlPqyY6KH19LoLCbh23e+JH9ZWZhBYy8w5flez7I
         wasRHbG6GkG9n/e5UX99wLeadAIm5SRSCaaDud0TkaAz7eUA8TOLIMSNkX8+B3lLpjd5
         pS1w==
X-Forwarded-Encrypted: i=1; AHgh+RpV6DJ/szKep+sbHkIQKH7Oa/qgG4trArQrJyVM6MtZckMIk88asFcr/E9jkb3Ftdfe7/3MCpor7Q==@kvack.org
X-Gm-Message-State: AOJu0YyjvgVyai/iCcmYVnohmi8Ghd3Csp6Y7r9fQpthM4HJFTls67ig
	ZlgyIpSNd3LMAgICW+EExp2Xx50tNo58hwTv1v/L6G7EtR21Jml2xNJkWIFyj7mZhPu/8fOjG1r
	hybodjGAmoNicbcAvdJg2bMR+qcTwePO2c7AQJSkziYB4CtLC
X-Gm-Gg: AR+sD13hlvlUe8j9EGgSm33IY+OUwlT1LeGbEuhk4Veo/2vz3fxOEfrFo5a3en9Y/F5
	2ZuRKATqpmbKLvLbX6KfQzia5KdXAKtNkVNDiPz92FECpv4vn/+fY0hvoBBPwkauvpHtoRjfQvL
	K93leCWrIujVecWJuIwQzRulZT2tRA34JaW6A1MndrIKLtGs1oNNTidsq+6LH8cnTceXKqprtBh
	3NwwONdFf8XFbQSqmkLzO3Kfanj/t1G56TO8jS3Q3yWEW+tYaAPZerwt+fF8RHpkq4CFGKhBQUI
	uZFzUipymRdV9+4l+8Wtwu7S/pk/fi+VWHW2gEqIR5tqdgypAJoybdD2uS9Pyr3snL9v/fCeSix
	u3frTlRorQqidsCppdt0gu2vCbwTxvXaOTx3loVL91HMBOd/hTACUsj8Yxl4eq+Cb
X-Received: by 2002:a05:622a:907:b0:51c:94f:8ce with SMTP id d75a77b69052e-52ce618b513mr320507781cf.34.1786131875385;
        Fri, 07 Aug 2026 12:44:35 -0700 (PDT)
X-Received: by 2002:a05:622a:907:b0:51c:94f:8ce with SMTP id d75a77b69052e-52ce618b513mr320507201cf.34.1786131874978;
        Fri, 07 Aug 2026 12:44:34 -0700 (PDT)
Received: from ?IPV6:2a00:a040:199:782e:ad40:551f:594a:fcd1? ([2a00:a040:199:782e:ad40:551f:594a:fcd1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995e9f0230sm61113715e9.6.2026.08.07.12.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 12:44:34 -0700 (PDT)
Message-ID: <0208741b-ba5d-4044-9991-575d162f7513@columbia.edu>
Date: Fri, 7 Aug 2026 22:44:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] mm/swap: rename __swap_writepage() to
 __swap_writeout()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-6-0899bac3b826@columbia.edu>
 <anYPVB3dwJCVoXVv@cmpxchg.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <anYPVB3dwJCVoXVv@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDE1NCBTYWx0ZWRfX/ahyxtP/EkLW
 6LfqmTzoKl3uToraK70t7eg+YEeAv5ul/HzW+5IlTASJROeB0hGTZVyJo0IyWLLW8YTVBqHotHu
 0nRMCOvA8oAwuo8naVYZVrCmv2wxTuTexcQDpVNxZo4T/eje0uys
X-Proofpoint-GUID: lQd0_tVSYv-BcUZN4RyPQu04jWN2c1Cv
X-Proofpoint-ORIG-GUID: lQd0_tVSYv-BcUZN4RyPQu04jWN2c1Cv
X-Authority-Analysis: v=2.4 cv=f+N4wuyM c=1 sm=1 tr=0 ts=6a7635a3 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22 a=GxAceEfXOW9Y-sC6IEYA:9
 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDE1NCBTYWx0ZWRfX+ns9m4rZoImh
 S9W9bLOjd1sahC0/UD/fMWY40TUGDSKKiEBnVOsp2Juk6UiZJ58ZFkkQXRkjRUJIvlC2IKZ4uWu
 qIT8XNEr18PbyEkyN/O+BtjLE7nMDy8dN2egGg0IvfvaLvSGjnEtzqrjcy3jyyV59kKklPx/i3t
 VcPyAChpziEdMaOexSN4+ZC8YqsUGM0fizA2AfggZFVLQWz1PC5YSXBPxpStZpv9N3DNNrM9zPq
 1DZOr4dKQ4a9AU1Dvj5KImwLZ3XK1yIqX4FLzc73SdSVdv/Qewierhd4HSUORGKZSSZHK72a+ew
 NuZFpsyRzRUdtM4JTFw7P0IdZ53wSVTCEnHMdqipBA+i5wu2aixtou5u1FAqGT3RIR5eN6fKlcd
 Zva40JpVy4kKrLc0IP56KJUSoCmdHPuW6wXPWUVLYsll1X4zm2dqkZnfGz5tukqvI16q/Dmq4t6
 +dNBgR4Y9Nvzo7hmxbg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11868
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 impostorscore=10 adultscore=0 spamscore=0
 lowpriorityscore=10 clxscore=1015 malwarescore=0 priorityscore=1501
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608070154
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 1515kemgau6uoypbntk4khsaingtyj4i
X-Rspamd-Queue-Id: 1E28B1C0006
X-HE-Tag: 1786131876-18671
X-HE-Meta: U2FsdGVkX1/2LuwdxjUVLgYSxnWwNpo+GAqUvxzKptrbcgaw8np8i2WgKtaKB9Ssb8crX1Xxs8mdi63EpLEzbAdelK3CA2V7jzjGCSK0vVe4gSr/Fs2imr1s7HXQAq5X7t37t8yoRi7iUuH1JK1Gt4nhOurneoMJ3gqYG7lEUvx2qes4boH11gNITTKlNFJhj76YrsxDA5OE3zcN4crpVuL8uKVxzsahznc17nc9J7V+fcgeUjtQYdnRok4GYn0wjfH4jjhIn1PpV4va/xXuvVdy/lNh51aVEa2BB6DUyCtzQS4qbSkgGTwR9Xn7fTkqsBmGMmb4JtSpytiwsw8Vd2BnNCvo0SEkxeGUqcBA9//G06Or3DX6XdjBuM2i4NZx+e+UKYiock+0IEGcmDSyM3+EIMyQvdpXu/XiPshL88Dk/Kkt8TffW/OfOMU3iKRhs4zemKDtM7w+83UwyBNvYZ+iPTW5CSp0SOnRMd1O0fv1GVcfQ3lGWiJE5GEIkbMlekM24DHGZWXDEdWWhGwUxvElU0OonmnVQD4VHH5T0r1NMvDPtiQJWGy3moMLDAvVtRcKjR4eClVMHHTq4cul0P6w1KvNgtNGxRjIY+v0yPWjzWtFX++Ny9/mww0xr1tLme/7WKFOu1y1jnemVb+AB0KlEBUKwvSuGk+Y95Zp5QSX0FKlr9SKnik/Kjdg+arud0pv+pQV4cYOSUNqCNfNWymYXAhuiiq5r/VrVvWz7geSIBiYVLzyG9SeUj0xD+whZIjBmyP6lUGG0dqYsokrippdvgQEqOjOFePttkvo5TM/XDkCUyFA+2b4TcPUBdwwK5a7k2Jbo3x9+wFkM//t0a/KaZarEyHis3WY0yczMOTHd3QFTQ/frLtbfrSbP/Aiy7cxXE57+IjKFkn1AY1uzUBlAzPzY4KlUHL2U3yKyBCMy/T23VX7Q1nPOZAoVR5lL4hNsZ8cBcKuQmNE5gZ
 X4swTtF+
 KG6p+x595rBZOwi2QLRK0THmlG520HngFwyQtvVaChrx89ccyGMdgh0CkKGkTCN51R77FOZzp6vFDxZnBHlmzsDpGsFYtDz24jNAlgUDpcUfov7Xq+jOJEOibhWQdfSApsDpnd8AD3MUMH5+cIjK3i0Gz/rWoHiBkxIzdRi+oYB4ShdD5iZDFLe3QMCO0Gz5T07N+04Jn2hB9pylMhtx7cfW7QXg/7gzi9Agshc+vD6lrNg0zkh9vRKYF0ivf/2Njxs/Ejs9oSd4SzBl6eYXLJcw3VO//Iw5jEKROKM6UVC2sAJxzhgoOorzyshQMS0y7Ai+HctRtRcYXUVNFEjxLmKCHvzm4WBr297ugy9UnKuUV/Q13tbD5TVDyHOb/Dl4HaajUMqnWa50itlWhZdl+Ckyo6ce6NJ+cZ1XDUdVhN2vzKHtwYq7fECZ9Nt1JxVN8JKe+sFRh/DermLt0/Ol5yhhpmDYqLEENZaQK0jHn708SfIaDetHykUGyLLREcVybtJSBKWTS19nOHh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 1:01 PM, Johannes Weiner wrote:
> On Thu, Aug 06, 2026 at 06:55:38PM -0400, Tal Zussman wrote:
>> Commit 84798514db50 ("mm: Remove swap_writepage() and
>> shmem_writepage()") renamed swap_writepage() to swap_writeout().  Rename
>> __swap_writepage(), which operates on a folio, to match its caller.
>> Update a stale reference to swap_writepage() in swapfile.c as well.
>> 
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 

Thanks for the reviews!

> Looking at that commit, I can only guess that pageout() had an
> influence on the swap_writeout() name.
> 
> However, on the read side of the page_io.c API, we're following
> swap_read_folio* consistently.
> 
> [__]swap_write_folio* would seem more symmetrical?
> 

That sounds reasonable, will change it.

> [ At the risk of starting something, should the file itself be
>    renamed? swap_rw.c or swap_io.c or something. ]
> 

You said it, not me... :)
I like swap_io.c - happy to stick a patch at the beginning renaming it
if there are no objections.

