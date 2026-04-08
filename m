Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8012610FC45F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 22:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC5D6B0088; Wed,  8 Apr 2026 18:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85F96B0089; Wed,  8 Apr 2026 18:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926466B008A; Wed,  8 Apr 2026 18:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6E96B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:51:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29D241B73ED
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:51:40 +0000 (UTC)
X-FDA: 84636887160.25.2BCFB3C
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id BFC1B4000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:51:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=iYLVepDS;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775688698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0HMTyjU+3VWME3neIOtWAUbmcTCr0jHyC7V9xVqa7uE=;
	b=OGoe7tS32S8ofOk5XnvAKFSvol+7xtQBBNYPZqDEYSeP2dB1trm33AWvCVP8w/3OsBiK2e
	mj4+bdB9XaXgRQulxNWx8zct6CwhjaBh+yunk2LLcZvyt0b56DQEFQmKup4QDqrVw3DcA3
	J9GDvZMfxrT4H1vl1Y2oW+Ap7DhOeLY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775688698; a=rsa-sha256;
	cv=none;
	b=pz5jWxsrdNy5wsPF2Bn6C1NiYZbNsbWtMGvthq1L0pLHdVpwBQ+1XRTjmSFyT6kF0lp3xi
	Z/D1cv5Q+z7usP4JDtXfdwbrfqSmb0Mkv2X1Frsr9WW2RxJHh/ahjcgJvLQA3bTL7FVBTJ
	b43321tGEXg6FB8aGx+5DN8ZSuJkpKE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=iYLVepDS;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638MgVUW968535
	for <linux-mm@kvack.org>; Wed, 8 Apr 2026 18:51:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=0HMT
	yjU+3VWME3neIOtWAUbmcTCr0jHyC7V9xVqa7uE=; b=iYLVepDS0lKOjgw+ZsdC
	ZWja2OTdpkfhNueRHpTof39JrY0XGw5tnXPdf8MWu7FTxzuJk1ppxGkISTR1zMwH
	zjK++sUyrla/vSpzgaHI8mCeaf7oelKQ2DsSDzEpYDFy0sBiv7GyYPjIlQlQ0xNa
	f94iycbv0Iwc7JlBKB4Z69n3gBmRaEplbtA3GkFBc0/EF80LNlS2CFtrEjseHD/2
	L1ndgJl5EST0f9oHbXarVMmhw9ub+TTHdIN5V8O6mhR0lretkp9PlaKbCmGkgmbp
	NoWaIr3WXzAG3qKJ/Cb82OrDBLMMiaHr10ys2DtT9AZpBvFuhP8jVx8vV/B+0AyG
	5g==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3p0mx4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Apr 2026 18:51:36 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50d9a6a853bso11491411cf.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 15:51:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775688695; x=1776293495;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0HMTyjU+3VWME3neIOtWAUbmcTCr0jHyC7V9xVqa7uE=;
        b=M0XRaQZ6Y5sZyON23L/u5XHJRNCszvFRQqxUCVU6cvlbDJ12XU+zjPmrCLbfv3kMSb
         zEXXRCd5NQ7zd1rKGeLE5lSPWK/OaOIGcJbzhpXgvE8cZ4YvZkD6n8Fr6VlzH1odIS83
         ZkUgwX9P1Kgp01xs80I4C7AoS9TRU2HCiyDZG0S+SbGpXYukELe5enkUAnpDp1qblX1K
         4GYVYflfB5LxA+7eAk0RJlKJJbJG1xtrVOuDXRgihhfPXMsftL7B/i+uUCkD0LY0QoO4
         2bcx4M90yxWg8cYSZhvigtuJwhAIrt5/7kU8ZRsS5CIyrMva57Hw49VYI6+9qMUP4OyS
         7qiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYNUowlryuV4WhRTHMB7DEHPPUijPYPc5YzHIiPoLMW3GYoGxR4K5Lfuvoqnw2c/A/qVUA6DsxXA==@kvack.org
X-Gm-Message-State: AOJu0Yy7AvCM36nt1imNDd22p5ugjbjtSWvkxPBhH1Gcl9nRs8afKpTz
	M5JDig1pQKXAcBUt3QFw96zxZeXmMuLPgayvVEdIdHWl2pYRgqFklA+y5CEsqSZ6IlqEZ9aB96G
	/YNi4L/ALlypATXa8H/3OsxrHVXF8xJXOJGp4Pim++20IS47a
X-Gm-Gg: AeBDieuWTg08M0VSi0uI7TRVA2UFD4rCHN8AdH2Vp26ZHw9nxX0zpZ1ARmdOrKRZ8rj
	mmhAcPXJD7R3tpbN7g1yfPRyOJoWK91FnGqLPhrZ92909ArEH9T/CGcnkGJAeFDQ3hXUPdjqRb6
	Q4YW7lrmjzxrj1A17bqgOgQhcJ3Snt5AkgMaq7h9TZkffiV6QPBK6LN7PbV6eaBcgrxsbFCXUig
	L1RCWf45vPdnCI1HX4icmmnLp9virnTRX63Z7NS/oM9nXT+tAl04HN6AxA3AYp2aV9PSwOcRao8
	ZbMxv5pWo4mLwOBeosGb7aOZCozKL6gfJDIWEy/NYVWpkxHGwrX43CcUC6Pgpnhs7eo43o1LFxN
	4uH6SM3u9NjPwy1tFmkeHtFFo+izw6XEks3Jp8M0X
X-Received: by 2002:a05:622a:51:b0:50d:9e36:f95e with SMTP id d75a77b69052e-50d9e370192mr170670261cf.39.1775688695364;
        Wed, 08 Apr 2026 15:51:35 -0700 (PDT)
X-Received: by 2002:a05:622a:51:b0:50d:9e36:f95e with SMTP id d75a77b69052e-50d9e370192mr170669871cf.39.1775688694967;
        Wed, 08 Apr 2026 15:51:34 -0700 (PDT)
Received: from [192.168.129.206] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d521952c4sm164382331cf.4.2026.04.08.15.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 15:51:34 -0700 (PDT)
Message-ID: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
Date: Wed, 8 Apr 2026 18:51:33 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <c4453f4e-c1a2-4f5a-b278-76b63d5dc4a3@kernel.dk>
 <01e6c582-fbab-40ec-97ac-02675e6a08ed@columbia.edu>
 <699933c1-c150-4e10-a5fc-6f128260d0c1@kernel.dk>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <699933c1-c150-4e10-a5fc-6f128260d0c1@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: qDyf2kkDl0BIfMt1GKNzDatCF2tEPh6g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDIxMSBTYWx0ZWRfX++35KIcBm7gT
 gI/r+BCShPd4LH2UbtcyFh8VadRAVO8KNzTYQEtP5XsFM4GIhJrbpbshGel221R/Z47Dz0/JLbS
 vjt7ZoVl1BdjAVkA6BVnMXPz+2jksCcLWLYppVkxAQkdNIuNOp1dQdi4mYTlS2K8MTZ0VEF1SAf
 bvgapYMmxVIIvQgN+TlA6P6J6606pnVv8tjYorouDbZaNRDulbpZEic7lv7zENE0Q+aNS1VKg1j
 6/2a6zXpfWVI+egWVpFnYPkghSbnea9ZZvXGAtjPVaD2ZP0xaYmW6m87ULCJ8klLBpQZ4D8IH8p
 SXBx919JgiZhLoMwI52YL8es1ZeXjIenjUVlnN5E5OXZeMRWoKIXtSCb3RGyYYPbwr9pQqGe9UZ
 jU6UYcOa66p14TEwIbkJtD2EtI3oWN1XfdrbBcTyXhKvdiexKNnSaC0AKYRiJXSEXr42rWkpFWy
 1FgQ2rfvNibKky1TlkA==
X-Authority-Analysis: v=2.4 cv=QPRYgALL c=1 sm=1 tr=0 ts=69d6dbf8 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=lI5dGhs4q9fbHD95aMQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: qDyf2kkDl0BIfMt1GKNzDatCF2tEPh6g
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 bulkscore=10 malwarescore=0 phishscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 impostorscore=10
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604080211
X-Rspamd-Queue-Id: BFC1B4000A
X-Stat-Signature: 3xqh5ubswak4xgja5ndcyoi34zjqaypt
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775688697-439116
X-HE-Meta: U2FsdGVkX18yVLbFiYb2CJ6rBRdBNm9PhxNrm8isC5blb/NZY5JxsgJhTw/j3VlmQNr2Vrk9V8+uOJqE8z/6qQ80It4aGJ8r7tVKXJFbIp7V9G3G4/bDGkNdNSbiQ3O/ivL6Rz/LOzXslk3T/4dVAJHnPDYi6wwPzASHPLoaZb9RDVSMcTxmlJtPDe4ORLYzPyRWVaBAOuDACttZNf6acJ2OpjdVuXKkwHrUy8i8A+r9N5309ztiX32AwFGVUZ8guIIu8HhReWKMsjW5DnPTZ8YwnLurVXd34iKNf7++5YIgRcrh7qJd/JuQm3azoqnR8bIuxIBfGW2CtCTkJx2ULGH/Kj+SxIAt1mpIs9ivkaADvKa1HswvIbHcpcg7sV/DUHj1GCc3cMc2iTuZToMOsqsk1EIcNjeYOOd/tbm+KSj3bNPlSx46WP/BRru7ra0QlhR3n0WaINCBs2e/O7KP64LXhR2veU9dZ9JQid4sq4s13dAXHMLDbqe3whAFrpAccNyguenCcjJ5f/dwEkS6n4ZGQo4j0g5/zDnlnB0lhPPdatWQMBVJBDRtlAQkxRW6GHUQgP52aRX1rNu4vc+6BJ02DrNhmdvqTzO0V69xtjeaAV4vL3+o1FS5ko3ZOKTY+a5PV7OfbZz3dSOIJrTDEwwaA7lFgA7j4T/Aepl278PVs+STivADUqeu1nqQv7U18XUJY+uVhjnaTk6LDbys4k96La8ZI/yXKnLs41BXnpIGp/t2wKKG/N28sDrBj9349QPq9RaFKzsRbTIL1D7Dro906K0a4iJih5AomjIu/v2gqKPaxjaOfC9sY4oP3kFf5mQcUoWbYymKYjF/1ZsCYtbYklEKgTocZf3CLJKSIp0qL2vBBiJRedNEdEwDfK6npb0EI5kKzXOtgkh4Ae67gA8BFnQ+mcswjiGaCbbz1/NRVS3gFHxaS8ZObg/rZzubp4AfhpSxa5zP17AV7YG
 8V+L19/5
 y66TeoCfpz7NNxFWmCfhoN09EosxMP4Nc/K9V+Xvwzh1Cm5lMOX7qIaaxGuGziO+uLTPxz7GYoUFGe5r9XZ76fX1rfM15HQWA3RhYwr0OSyiMfRYcaBFCUipGcDBhsrHemFvYb7yTMURcS7YGbfU+iEI+l5Qa2FzOgve0Tnll7L2lPTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/8/26 3:51 PM, Jens Axboe wrote:
> On 4/8/26 12: 48 PM, Tal Zussman wrote: > On 3/25/26 4: 14 PM, Jens Axboe wrote: 
>> 
>> Thanks! I'm going to give Dave's llist suggestion a shot on top of
>> this as it seems like it'll simplify this nicely. Looks like that'll
>> involve turning bio::bi_next into a union with a struct llist_node.
> 
> Since these lists can get long, I'd keep an eye on llist reversal
> overhead there...
> 

Going to send v5 shortly -- tested with and without the llist reversal and
it didn't seem to make much of a difference. This was on a single-disk VM
though, so any stress testing you could do would be very helpful.

Thanks,
Tal

