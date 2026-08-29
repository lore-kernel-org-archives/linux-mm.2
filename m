Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C80FC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 16:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475846B0088; Sat, 29 Aug 2026 12:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427496B008A; Sat, 29 Aug 2026 12:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F15F6B008C; Sat, 29 Aug 2026 12:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E94AF6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:10:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 526AC140139
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 16:10:04 +0000 (UTC)
X-FDA: 85154793528.08.6D67E56
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7C6982000B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 16:10:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cCuEdNbs;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=lkfWykv3;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788019801;
	b=3P0/Gm8H0IxX5w5QtTL7j1RPHpovnZvp6XWQxmMog1jkyoxcYhBHIN33s0LOkoLA3hn+X7
	MmCSYkCHrHCbjsOPE8r2uknMDWKbVs0kIkTVBXRKI0Nw1v7GPMG0lfLo0vWsBSdHnJZDiK
	XIskIORhcjbKUx/8jwIElbiROiEoSEk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788019801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+l4cyquDZdPm1CRZEtsdD5WsyEM3FltNV4XbzdH7Ws0=;
	b=X5v27A0BgHWl6Jq7FF6lATyD4fGLBKwc/1R1j4Q0e4NJE9xkHxRCXq9KNIqm0e83QRpMm9
	kLR2dSX/bu6DzEvzKi8efsc1nvk8VD+pgyTyNq3Q6+/EdkIjbPkETF6vmDXdAwMC52Fv2U
	qDrWSNzTxh/kEAmdz7QpacbtxX6iIEo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cCuEdNbs;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=lkfWykv3;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TEfSWA1323549
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:10:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=+l4c
	yquDZdPm1CRZEtsdD5WsyEM3FltNV4XbzdH7Ws0=; b=cCuEdNbsSPHxSxNaszD9
	0bwjJ0fU1sRllrQXjJOZdhZoZuCbl2ZmpowDV89UeZunY+TwnqRjnLn4NFaN70NU
	OErugq2WxJ4DlIbBPh74RuNVt4NM0z0vg3cnRGmNrf8ncWLeqVQ7Ml9Pik6Oxa18
	g7fSr/qowFZk+Lnu07M+U4Kk63HJOGB9JgLXGcJJuM4CVBnQGlPY/r01B8brU4Kk
	qq2uZzIUQeRvzdpkwQNw8o/0WhG7p3O7KCTXZXiOoFAYIlLqufkLL1CId2ZlUzzC
	oo838p6yO7ct4Q7epkB49MukSs3qsnS1jUQRtp6M8eJjpI7XVqiCjcRI3iSRPr9P
	dw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gbsppaasd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:10:00 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fa5c5a4a6so47328571cf.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 09:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788019799; x=1788624599; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+l4cyquDZdPm1CRZEtsdD5WsyEM3FltNV4XbzdH7Ws0=;
        b=lkfWykv3rhrI5nswlm5wkIlR5lmQ4pRER97BeSNvfmfqGJf1a0LNrnVqlrGp2vbnXk
         zWFECMxP4pSvITOLzNlmst4EV50gJWX5V8kw8RZCh3uBpc4cD5EWXz60u9ZZ5Qmsr+Kk
         h61aN0t0VVC6acBmjfoYE/bPXXQuvOveBvY0ZXPrTVkZgIbD8hX3PR2O9YX2Qt8bRi+0
         HeJPtzxYF9XVJjqD3ABdYKiYKHrsqCIpJ70JEVdkKkdd3Goa96c0YoiKMbV+g6x0T0jJ
         zcwHwcOWT/teSW3z3Xz2p6VjxtH26OHnJNB4NJRXNQ3Pj8zGpQzle/d6pZLW1N19uyBK
         v07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788019799; x=1788624599;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+l4cyquDZdPm1CRZEtsdD5WsyEM3FltNV4XbzdH7Ws0=;
        b=a0UY+4AFAGDIVWtus0eZD//nZlbrOEFWu/ji5J06VYfnGVpok4jIF6Nh13gxTIr6Q4
         +rSAkTWlh+7qZRrNa5CJfsalm6VbtMj6azh4sThHiApMvNMrIa0AKgMqNpd3iqUkjI3T
         uC9Qj9iGK9FfHLfkjLvholZJmHZOARWo2vQnV32GUAbcQQ6+z8VnbOatsUqJmxIWim10
         yvJ1G5V0VRF5RrZrvj6mqtDcNrj7MmpSu8yVPfl6IreDmHU4fZQnF5gsQFeVp7ZwNET6
         qnanrYyh7Mm45jfvbn09uOMuHfAviWMoz+rQ7U0/PEtnAwoVlXfVC4bI/GXJN9mSelb9
         TQeg==
X-Forwarded-Encrypted: i=1; AHgh+RpQ/lSc8PV23NJ9sTuscWD+zUmkFAfPddeULe3eqAYhpPW/x2RtXuF/FjcB4uchF9yVhAEqJ1ydvg==@kvack.org
X-Gm-Message-State: AFuF++mMtEtjXyaid3WqJ44TnF04xZQaV9SUQ4j3xhrGpDWPv0gPaYuv
	OrDWbRbq0h66iqqhRTenqSL8zThIb9PSQqqPtyredoHoyZAo3eP3jEdHN2NKQRqlS0soIRXbCUi
	4KoUkYyTCjgMOIX81X8k5hc4QXi0U0Ep3dwu9RyGK8Anv/sQj
X-Gm-Gg: AR+sD11akOYI3DHhZYJECoUSR2kpvQQ/cicOyojmR5uJ2sv49tSSUechTC5jMMbTMis
	sn1rdzapWHePt//mSq1qbMRj6mk2BeLQB6vxPzzIvaf2QsFTFAWsxv1aad0NVuu9+jgFRBFs5uF
	L6F73hOSFvMPUXArHunDobJE7MQhCTJR6GSf9ihqs6QgToZGFqB3xlkMhTRsPO84ftRRG5cdGKw
	iTgFBZF1LvmYveKcJCcnaIvnDe9Y7xB03X3kSWa0k/TBxrFdXjoWGs2kXpoqOKHjTyiDzFRSSHZ
	Pb4OaB4zyGltFGlerIYPaiTrgRf+7X6ZzqvvHp9i8EKzjN0flvWXbZmTy+UefSA8ta7DGOJZ/hX
	Pe//3YgOZaLvgQYSI5JkFx63KboWrVcysvQNnjfQvoJKH4KM=
X-Received: by 2002:ac8:7dcf:0:b0:52f:f5f4:e9b6 with SMTP id d75a77b69052e-52ff5f4ea4amr82043511cf.20.1788019794350;
        Sat, 29 Aug 2026 09:09:54 -0700 (PDT)
X-Received: by 2002:ac8:7dcf:0:b0:52f:f5f4:e9b6 with SMTP id d75a77b69052e-52ff5f4ea4amr82042871cf.20.1788019793958;
        Sat, 29 Aug 2026 09:09:53 -0700 (PDT)
Received: from [192.168.0.175] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b955e7906sm117685355e9.1.2026.08.29.09.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2026 09:09:53 -0700 (PDT)
Message-ID: <37fc5d8d-f226-4885-967c-3e873aaa662b@columbia.edu>
Date: Sat, 29 Aug 2026 19:09:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: filemap: retain mapped dropbehind folios
From: Tal Zussman <tz2294@columbia.edu>
To: Wenjie Qi <qwjhust@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, baohua@kernel.org, axboe@kernel.dk,
        trond.myklebust@hammerspace.com, qiwenjie@xiaomi.com
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
 <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
 <178801880005.667254.16521776519325089161.b4-review@b4>
Content-Language: en-US
In-Reply-To: <178801880005.667254.16521776519325089161.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: jlDQ2G9EusFbUgiZylOPrwuThkudLIAF
X-Authority-Analysis: v=2.4 cv=B6qJFutM c=1 sm=1 tr=0 ts=6a930458 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=pGLkceISAAAA:8 a=IeNN-m2dAAAA:8 a=B8_SjZw1YBUlbbQ4_qUA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDEzOSBTYWx0ZWRfX1flIYCgVaFFs
 eWrNWiHt/WFQ48PCzc9xCR/GVfl+quka965IWnbbmNtjNBngfi1P4L0PxdcnONs3y0a5i6LBWY8
 AOFF9ndd3b5MqiV4hhRPpOBvdhCrn1jXjzX+a7hfo+5cepvx8dePguT4LcZRDRkk8UmolYUFJpR
 u4FzKwQJrVZPITC5MGRUvvdWekzOBkgouMbsguTpbmcVJv811G2cctDUvsFW5ktQUM2vN4ZQTdJ
 x7kEwipCt92SFmr/9ohyW0G1/Cwk2l6QUxuaU5w92LGjsFis3unnWBzyfK5kY4ZX+XV9deE4zkz
 5OD11CU5U6WrNaYBD8Mq0wojIrZxNi5sbxd1mXBiHvNDn/Q1q341Oza0i63tVvMUEpGUf25Q0ko
 DLcAljbTYdBIolK7nOZhwnutmhVduDDye6JopkGyeMD4+xcCZ03hD5Uuiyj4DUbKmp99O4/h9oZ
 QNKppnD5pA1M42dnLlg==
X-Proofpoint-GUID: jlDQ2G9EusFbUgiZylOPrwuThkudLIAF
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDEzOSBTYWx0ZWRfX4vPn/u+Y8v4w
 TVasQveBNAU1+ag02UgeA+LouoRCdNF62F7yjzOMilMMGynyPPF6EqOBLBtl7X4/e8sn3SNkyUz
 75+nVeMZelPFYDnFkPESUOQKYgQIr7gxqjnjDgWKiZwRCM9d/4lP
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=10 clxscore=1015
 phishscore=0 bulkscore=10 priorityscore=1501 lowpriorityscore=10 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608290139
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7C6982000B
X-Stat-Signature: 5w9mkdwcjj5tbtnebeaepz8zubk6iado
X-HE-Tag: 1788019801-356874
X-HE-Meta: U2FsdGVkX189EBnM3DIOn5d/OtYx4LTwm356GwupM5lNyB1dzXC2PKy14uj6UvHurgc+ObPVuu0ynTt3Z0jGaoVsL1Ijm092VsnvyDUBYzOZJ9IHITe2KHTD2lOyYZ8rfyX6tHljkGkztHF/JbWGfyM6EWd5c/IiUWx5Cdmjn1QxHokdw9BfGE+e+AJoXvH/oX6kgfUL1p7XH3TZ+uszl1xr0Au0X+1kyC7rpvZIbciDuryMeiFx6VN1OSf0QB4SQ/JKgIQdy5OHPU+JGI/Wna0Gfi+0dakaiuwOfQwbqtmXgGmvDUNm7jDKnE3wQb45DyuA/lDgVaqVDeZosycIRa8QyByBfkpvNrawG1rJJVQcLGRabM1Ywz9+RLrWE2DEuljrDHZzaULAbHd0AQgZJPWW1gFNiajx9tcvpcz/GFNEZ1i/GFaI56JpffXW4V42RaJEJXVb8OY7+mwDmOzboHavx5rMq/+XDo/pmfqxBslw1TAi1xP1wWQABmZokXLPTQ9f3a5YxOqrcawHM4e3oDl1hYQwOA6XDeBJowthlbIIjpAt5jKj8K+U+JYKnSu292apZ8e8hNwlvIz8vIF4YgMh/k8myd+KVoD5TPIYDXLbU8Ne/XK7Bm6TSXUuZRKdNwJdkOtZ5YC36IT11I8nujAndMYD4XlCxUvZlY8Jp+ale6lsF8PoIU25L2LhHg2TssOBEaiuISUYdmx0/EhIk0lgE4iCRqYKQA3JNaWxaEBO4/ak2G+ZdQGGpeia5xlpDWOgMEjG3h+m5Xcee5KAJUts+mMI8/XeBa0LvxVCyuLhDBP4Eql0tlsVo4cvXy9DI/Ekbu1I5xsMulH2NPQ0vbxKGYg8VuEdYOXNpNEtSKrM02iEFv6OdS8nx5Ti2DsabDH9KAXUA+vjLLehwwAvC9gKUwojvWYbWzTRYLPD8Cpqg4yA1AedM4vnJmeadZlHhx0oRSvSTFgXbq8DhKE
 MgjNArZv
 zMtfDVJbcRRsc1Fzd7pJ3kg4L4+IXcCPiXEM0apn3m27vEXB5P24UQdfrglFhs08XcCcRJoumiCmiTkZFNAP93G+C7iHJbQJuIij6pLWIDA22+eTIbUGMMtzkE9DrTfPfEyx+oCuQfFAlUso+iTP50bObChi3+TxhgMzbZjkiN32ov5BKs4g9nVw7CqB9dASE63+Bx50oH/lR8gDmaWdErXezN6VaLv0kluf9qHCmnsUaPlYqU7pQXnCDW1zxMPMXhDsLVJNs8uUWksyOOSdRIKqugi6MKD3cvP5Zo2AhVPzB0HpC7h69f76ibViPGFmEBxJtoCfWNT7kFE6Mfo5Frnrxm3r1VHtNfXqd+ssYxLWl3tmQzNi4c5+ELeFzkCJN5VfUfUsXRV6/d/kqM/NX9XojyJTTSiM/u6yC7iVBBKKyUTaV7ZIYxa5G4ikYh6Na9phyg/kTsjIQxLaIWYiux5iGng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/29/26 6:53 PM, Tal Zussman wrote:
> On Sat, 29 Aug 2026 20:30:47 +0800, Wenjie Qi <qwjhust@gmail.com> wrote:
>> Fault-around can map ready dropbehind folios without going through the
>> normal page-cache lookup that clears dropbehind. A mapping represents a
>> competing cached user, so retain the folio instead of forcibly unmapping it
>> when writeback completes.
>>
>> Unmapped dropbehind folios continue through the existing invalidation path.
>>
>> Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
> 
> Overall looks good to me. It may be nice to add a sentence about the
> safety aspect of this in the commit message. Maybe something like:
> 
>   folio_unmap_invalidate() may sleep if the folio is mapped, so this
>   also ensures that folio_end_dropbehind() is safe to call from
>   non-preemptible task context.
> 
> Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> 

And maybe:

Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")

