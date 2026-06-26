Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5FA3CDE00C
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D084B6B00FB; Fri, 26 Jun 2026 06:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0416B00FC; Fri, 26 Jun 2026 06:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD656B00FD; Fri, 26 Jun 2026 06:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 906376B00FB
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:18:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A56A40413
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:18:28 +0000 (UTC)
X-FDA: 84921664296.30.8DF1D8E
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 68982140002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:18:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="koEB/bCN";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=XdZ4ai+2;
	spf=pass (imf23.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782469105;
	b=YO7gyk2rDyAta6UvU7S2US58hivwCThyZ+xno9wfyEn/J91uKuzSCXS/vfo4ovLPlIbmT/
	GzeRSEcvlxPfTWaVIE4qrrcsIeWBl9E97piWju7il7lME5VbAheusx1cm9tXvnudWkutK7
	pmMLjAzXQdwiNQ3/rMVvzTNqB1o+zhY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782469105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIfc2dW5D9lK3/GVNNe/Fcf9TU8SCV3bTMPzuN/zFww=;
	b=7i0A7rxybzYjbmotuiyhuHoARd0fYhWi4LHrV6DU+B5aqnCuq9MeH32MxoYWC93DvoM6K2
	eMMR0jfYU9+OmgxIryRyA6nsCmR5r7SAP+dFMmdyR1lEcN4JfbqHG0cJEs7AhFnmKyA7Nw
	dJluWcoP3ATsm2Xb2MT/Q7oxFU5UFWg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="koEB/bCN";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=XdZ4ai+2;
	spf=pass (imf23.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65QA03rJ984362
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:18:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tIfc2dW5D9lK3/GVNNe/Fcf9TU8SCV3bTMPzuN/zFww=; b=koEB/bCN9dHGYL+f
	0r/RdoyBw0jGZdj0v8eGHDlxiXnSa1v8ga4jGjcP59J5XlmdvP05FvieAcM6Pc7d
	ytZSPRBjm5rls5FAjru0hw11vkvfJdH8B7awrc6klgjm4dHXfeQmhPWtthtmarK9
	eZfmpkzJWzATEcShiaCE9QrLG9Q56O0qZvrr3Xhe+6bLhHFDBvUnf9O24NIOzXJM
	9ii6P4gC8uAscYbPm7M0QolduDZnueodaIRnF9hiVTfXX6pM+HVCSs//LlBgXlk0
	jm6K5UMocRt4B7sgXFrp1j1zQdF8sGh/9yUcsPFjgZKClmAJZa1kx2bpS++lk+n1
	ltQL5w==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f1fct9wm2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:18:24 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30ca3374c6aso749099eec.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782469103; x=1783073903; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tIfc2dW5D9lK3/GVNNe/Fcf9TU8SCV3bTMPzuN/zFww=;
        b=XdZ4ai+2QNN0WqKHpbTNxS77M1Q/4cD0BBZoGcdIpohBk1F7/6+PMIRk0j+7aaMw6C
         mETTVqp42pYmj3jjJtR+XP42m+gNGLNPyZABHWJJ4VQys8a4SI8+PLlcDua/NQDpzDTJ
         9hiTNfwdAzH5q4UXqQegVfIi231k7VtCBYOuA2n3frgYvNnaKNK5u9gdHQwQgKrF064e
         sMSdAIEcXkGxMVCkuR4rOSug9gmqnEMJrQdOnh+01qbEnCnH6r5tLPi7p/W2RxnlyBrQ
         uK/Qwsy7pQxq+Y4hunFpAOV/KQrkZhzwOknTT7wxFx5upQiEMV51dcYGUWsS247yoVq3
         fmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782469103; x=1783073903;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tIfc2dW5D9lK3/GVNNe/Fcf9TU8SCV3bTMPzuN/zFww=;
        b=DV4MVn7jmc5pTOmNCUR6vUdJ8DNKQNqQU2SFso86DgnQlvfIoLhibbOh6XSS7tR46d
         qkCcOHNQnhmfOidWS7zkYysByQJsL43PEbZ0Rv6E8hx/8vrXQaGfdf592nfVc4qm6txP
         yOZHdSjetLhdxqA+JPGvuHtFeyYh4M8XukB1iq718hRKMJOsDMNPNKX9Ay7KilRWBaQK
         whs3vobNue58HreZX53qEFojJSHRe7K279D8iqYbejLVKIPlF1QKOfYkOLQhSlOFWkJV
         XxRnhQzjY8X3Qho4zJRKyIZB/fdSoobguY9U1ay4wn9CJPhrdv2wfnpqMy7iOlRbyhoJ
         +h0A==
X-Forwarded-Encrypted: i=1; AHgh+RogmMTnlOu/+vh8/mwHFOlMTLDziiA9PAs+DOBYx4gV+6yXcweLnzMnXUIhcA3qMUD4bjLfLtBxBA==@kvack.org
X-Gm-Message-State: AOJu0YyI7mzYQNg1Zeen32JVmdpNLvxfv/LruUzUI9mzj1kThjDJqzcl
	/L1BBYki+qaIqk28qEaeHBW/mRke1GF6pcCi9GNe+IlKrlyL9yWcsDE2jI0Z4MTXjZeU8pJ7YID
	1WPRTfD3bfm9rAgaORDiPLWO1A60OjSStW9adpzbE5X9knzzGXL1crA==
X-Gm-Gg: AfdE7ckM4QzwUj//DneDXjswogSM1PX4jZVurWXEjtEL8Bm1OpVL/hYdiwBS4Zeecq7
	EKoOhuqhoJN+TOdsh4Ra5wpkKJ0ft+/RQ/horuLD+EGHNDQjXBf9BXxSMEhezgiw4RP6j9NvB6a
	VAGoZ/Py7CWSLayvNuDeBD7YlhhNNy6BAtqY72zv06cer2se02orFEimnss/KKqqwyAHPFkIrfg
	ww1IMwwT5aiLOCvdyoANsIRDW6icb33BkfzwUX+PFA6bXA41xsLcbwCyvsFR54+FLCjlk00uGGH
	THg0+zutcI7qSxtXkq6S+wq7njxK0LrBSZ+K1Ga0kLiq096PP96ka3bsyAAYIrpi3hxvt6LGUiy
	YAjMur9CkpFtk44zkv8UAB1cRn+12DRMh9uNsAOvb
X-Received: by 2002:a05:7301:9c95:b0:30b:9b64:4a3e with SMTP id 5a478bee46e88-30c84b6c547mr7176385eec.1.1782469103339;
        Fri, 26 Jun 2026 03:18:23 -0700 (PDT)
X-Received: by 2002:a05:7301:9c95:b0:30b:9b64:4a3e with SMTP id 5a478bee46e88-30c84b6c547mr7176368eec.1.1782469102833;
        Fri, 26 Jun 2026 03:18:22 -0700 (PDT)
Received: from [10.218.25.225] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c4ca240sm17372659eec.4.2026.06.26.03.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 03:18:22 -0700 (PDT)
Message-ID: <9eca8338-bfcc-4241-954f-2bf2fd14db1d@oss.qualcomm.com>
Date: Fri, 26 Jun 2026 15:48:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Content-Language: en-US
To: Uladzislau Rezki <urezki@gmail.com>, Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>,
        linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Lorenzo Stoakes <ljs@kernel.org>,
        Pranjal Shrivastava <praan@google.com>, Will Deacon <will@kernel.org>,
        Suzuki K Poulose <Suzuki.Poulose@arm.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mostafa Saleh <smostafa@google.com>, Balbir Singh <balbirs@nvidia.com>,
        Suren Baghdasaryan <surenb@google.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>, Shuah Khan <shuah@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Brendan Jackman <jackmanb@google.com>,
        Puranjay Mohan <puranjay@kernel.org>,
        Santosh Shukla <santosh.shukla@amd.com>, Wyes Karny <wkarny@gmail.com>,
        Sudeep Holla <sudeep.holla@kernel.org>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
 <ai3kkIpaR0aT_6q5@casper.infradead.org> <ai_LVreyRWx-RDEd@pc636>
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
In-Reply-To: <ai_LVreyRWx-RDEd@pc636>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: BmdlCUjcInkJnnvHEWG2qpKeWqNoZdt5
X-Proofpoint-ORIG-GUID: BmdlCUjcInkJnnvHEWG2qpKeWqNoZdt5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI2MDA4MyBTYWx0ZWRfX1fqxyrWX9o4b
 JIQyCIBSlfbIn5Ep9zIY0wohdjzbQXcd/5IDr0rwKrJTCksfSBhkuWCJcVQjmOR7h3WZpJKDy6S
 v/8YQGW/eEKoT57h1mm7pm9HHOIOIXsJY7JUfHu2ezLP5N/pYa86+9OOIJcLNjscRPQJyMHJpdK
 ViC2WSIcD05tgoMqr4Y0gWXlWf7m/XLibzagyk60LowvErZ8GrNO2dM647TlW9dNAuYxSzKUTj0
 a2NVwo4GkBZW8FQYudBLrIRJkyOgd0pVcQDkX48Im/feInSc8jXHfJZVKFAPOLkV1RgK6FBc8ch
 x8gPrGaQJsSJWhbSVNgVXhznOX6aKSxF2RWyOQ+730iGAhKQjV6ETvoQQ7VTUYezG9DbOrr+J1y
 i4CXi9/mB1FOtJg60I8DJapDhnI0eQxGF7Z6rG3wg1WQ9U967Lpu2Zm4Gb4RaK4O5yuC7ogLkh6
 84XbkzJ0yGKpSPy32+Q==
X-Authority-Analysis: v=2.4 cv=FPkrAeos c=1 sm=1 tr=0 ts=6a3e51f0 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=3FYh5rYaCfyF3NCrosEA:9 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI2MDA4MyBTYWx0ZWRfX8L4siXsiZNBC
 sq8tpuuU0PPZAFHkxJRkRVzmTBq3E0yoTYN6pCy7ZJS2nei3yo75zzea7jPfKYEeRoPkmSRK715
 XcvpBcx+Yau1jvVD3i4bFIdmzqoiEMc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-26_03,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606260083
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68982140002
X-Stat-Signature: dcfdfgbp8j4otrk4tku8ebni8ty6ssk4
X-HE-Tag: 1782469105-657241
X-HE-Meta: U2FsdGVkX18Kc5HwYHkmt91XYC/GCCHE1Iah6NcjHvqyBVHVYCiXbOJaH/TIalAQk6x5E7XYGR0/F0nsPfUO1/0Tn4Rowv02gJinJGTkMjiJqXcfH7T8r0kL7mXU5uFYQGr1qOkhjXVKgHXsPX9I3lpcs7rRdp9TIrGNKGNAspsy0/by1LqLQM9BTCXoD9m/Jkj6zqq1TFzUW9S0w/SJhu11WFLkjQeh7LHHhX5CDGw74D3atS1Qp9XG8ka3f8sGATjx9zeYYOqYceIq+dn1FTzEX4a+yu4Sp66HZ9g9AggxMdR0Y09M8Hfm2h/BrkfVCbPDqL8RIvka6N/HT1UPGR8YRysF9vmkbgxsHav/xpL9xn6qA71f29v9KwJo0wzldYUsT8MknIDLTJptglXid8WYvB6togHhJPUkAAORVXlz2gqVrestOCwknaLi+ugksZzMKl3rTV7YBu+0NZZNDsaO6bIlMFHF/9LS2Sq0aOeTH5Z/s7bgP0B+CjtDgUS6/UUbuA+YgSpe2EfytXrwvpsYCUHnQCxrPskXNZMqVPlXxUERdIOcga4kTg324OcISlQmiO0+Tx7eqrwUXEcR1ZmlR2vMjhYu7gChTGaj4e3p5d9TqBlpzVtVcNL0+slTrJQciJqhxcP4hyV4duVG8EJ1HOAZtu2hHFJFdTLAtHIih/PYqBC8cRN6ZbAZeJ3/Pi1usYRb/j43E43SjcNKs5zeFY2AJF9fpfOQFzyCpDJU6/FmR54A6rpCQh/Ory+S9li3fXbsWln6z9j563qXmpjvmr9z7/kD2RScWSzQVzvR7yMxiDXe5HcEO703NMXS2aFHf6Joa1LWZ8JnGnrrvxXOEi8HCmogM+ruvOv9sgqIiUhBSweFP8TgovpbXW4wxkxq3QCiU53rczl9pDU34rURO8TIxq8+hU06Vcmai0coezzoW7HwrP0H5V/VF3CEe1C5uCGyzx1b8gnT9Fl
 lHyxJSDC
 foxhY6wwXdWWDmqCHkB6fTVXulhhtZMwXycFhJUk8Jo+VOnKjGV67Ekth54B/aUNsHJF6P80S89hIHgohKdUvtu0tz5rlvoE5y3ri4PptUtzhCbSqMgXyiEXARxh2iGt9ogMl1KgO9Tk2QoTVoMDjRzNPW17s/k5RMiBcQCnQyfwg71kPGwjDwiHMfJdZL7zTvHRZlbXvp8ruTgr4gusjHSligE9ZtwhBWUXibFzxcqFnfaTgs2fj7aM40czmPWZcvVDJ9VSLuSDYOGevuk2EQbA4zQSTQjPLR165EoxHOhjU/jHQNmjGBsxa8+BSZ8eH1SQh6zbZ+ikd0EuA+EJnCkpalWtuR1qxS7r8y2NRJov1dSGRlHiWb2BV0vhLKq4GWveKZssann0d9QpbKyfQvNTsyjzaLwqu76THxWx1xbj7jy+eVnlWp08L+OELerlii3cDtE6z+f1/aKl/a0MvXkaYl9PUBv70YPAOcIGtreEioYaz1ORkbsASYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/15/2026 3:22 PM, Uladzislau Rezki wrote:
> On Sun, Jun 14, 2026 at 12:15:28AM +0100, Matthew Wilcox wrote:
>> On Sat, Jun 13, 2026 at 10:49:42PM +0530, Pranjal Arya wrote:
>>> vmalloc's free/busy/lazy area tracking is one of the last remaining
>>> augmented-rb_tree consumers in the core mm allocators. The rest of
>>> mm/ has been gradually consolidating range-keyed indexing around
>>> maple_tree (notably the per-process VMA tree in mm/mmap.c), and
>>> the underlying reason is a structural mismatch between rb_tree and
>>> range tracking:
>>
>> First, and most importantly, I love this.  The maple tree is undoubtedly
>> the right data structure to use for this purpose.
>>
>> What I don't understand is why you maintain a separate "free" tree.
>> It should not be necessary any more, but maybe you tried removing it
>> already and found a performance problem?
>>
> We maintain it in order to split several entities. That prevents
> interfering between allocated data and vmap-free-space manager.
> So in that case one context can easily access allocated data, for
> example vread iterator, etc., whereas another can do an allocation.
> 
> So by splitting parts i minimize lock-contention.
> 
> --
> Uladzislau Rezki

The lock contention concern makes sense, and in the next patch I will
incorporate the suggested changes.

1. find_vmap_area() will be converted to a fully lockless RCU walk.
   With MT_FLAGS_USE_RCU set on vn->busy.mt and call_rcu-deferred
   vmap_area free, callers such as vread_iter and vmalloc_info_show will
   traverse the occupied tree without taking vn->busy.lock.  This will
   eliminate the contention.

2. The global allocator lock will serialise only the gap find & range publish
   pair on the occupied tree. Per node busy lock will be a separate, finer grained
   lock will only need to be held for the busy tree insert after an address
   gets selected.

3. As Matthew noted in his follow up, the maple tree's own RCU safe node
   retirement will need readers holding only rcu_read_lock() giving a consistent
   view of the tree at every index. So the contention reduction goal will be
   met without a separate free index.

BR,
Pranjal


