Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0426C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 19:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654406B008A; Fri,  7 Aug 2026 15:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6057E6B0093; Fri,  7 Aug 2026 15:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CD6F6B0095; Fri,  7 Aug 2026 15:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 238106B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:30:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A39AA1298
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:30:31 +0000 (UTC)
X-FDA: 85075465062.06.11C3DAF
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id E076F4000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:30:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=eYpBsPo4;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786131029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpKRPnIV4oqYTKJqE+EJ6z2rQqJUSwLGbqnj2YwhhoU=;
	b=JUoZxxpkI7pJF4vdohNBQxNEAUztLMPEX+kC0t0s43zcTXdnzn9v/TGCRDSmfr7URWwxuy
	zWI3RJG3CsWpMzXlAY5rQXGsH9nvKnj9o6Vb5yH+BVADyM63p5odMaDOlzuAV/wnkrvvjm
	WYucFP0zfxDJJ70eYpNCxGWwfzHBr3k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786131029;
	b=tRhWXKhH3zUjfNAa2ZBWFyGuX+RvtvEuf2WXjy9oo4jmSBLMn+BoFHI12KZTRMdBwoQ+He
	Rl/bwS/tmT0urSipnke0MATpZDdPi0TL/1P29/G0LA9oSZdKnAV0+DS6KccqNw5QDIagXT
	6OKdbueta2oXf+rKF2RkoCC1rRK+zrA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=eYpBsPo4;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677JMnfC3591229
	for <linux-mm@kvack.org>; Fri, 7 Aug 2026 15:30:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ZpKR
	PnIV4oqYTKJqE+EJ6z2rQqJUSwLGbqnj2YwhhoU=; b=eYpBsPo4DNchJAVl//xL
	SIIhPWAbH+nX3mmGeKiVpmRTKDl38qaFmsI46+aLpEzKD7mI9gWCZIqA58jGcVCB
	FLDz5LloHgp0+3BsXmmBAQQQNeUjNph/cxadntGO6zdmwXi8OTsOCRvtvfEXHd8D
	N0hz3upW9KgdkMFAEMEKgVgzSAVziujsG6BnJHRuhGALmEAIUyvyy41XoHRv+hjm
	FQZFHkrgY69AKt0XDg42u1F0rr+KsR5eKcHiuKMEn2ZkL6/rJufXcOcvsm2L16Dx
	4o7delZbyGuk9Ezh9j5TNdqAuKi6Pp/s7MqEf3LUlxx/W1sOGGor8z+v2RI5K3XL
	8Q==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fwe1hkhd9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 07 Aug 2026 15:30:27 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52cd0374265so61848101cf.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 12:30:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786131026; x=1786735826;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZpKRPnIV4oqYTKJqE+EJ6z2rQqJUSwLGbqnj2YwhhoU=;
        b=jHXGuXWXPI6i34zUl2c2K8K41vxE4GJgziCVUOrIsbXZWDbt94qktPJI/9LgEIce7h
         +5NUmSyVsCQsnJcmHDu4d1P8gza+cZ/WdfLmmtGpxMfURzBH21sExE5j+0FiQcxRAuDw
         HyFOoYlpB9RXAJuhavBkESPi2/R28h7OQGdStp8mnkicbaPhZaaZNsn9qBmZj1sz5cLd
         l7Ra/jRUsH8WsHhO4L5s78MkLao4vH6t8OD4ozvOIoAVL5eZRbd9GB0CEgQfhHCtoaIq
         FviiX8ANo/8NTAdF8G+S+S0Z+LViaoZpk7oCFDP/oTN4knQG1TwS4GNOfeqx2tiNw1bB
         p/lg==
X-Forwarded-Encrypted: i=1; AHgh+RpysV7xT7LDP5zqDn2pS3CXMnqoN2ZrSrjAmxG1Zv23Pvi94Bdy0Ko5vi2eWjlDDgvNHQ7W2Ku3fQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8tl5LdJWYVDe4j1F4xaIcyVS+9VRZqQ5PskA7lDb/1CAERL3r
	enU2pCxwK3yjulGOx49ei/nlJ9q/pQ8cl+IgKV+e7Q9/f46PBwChcaxn5Im8c2PJHO8xjAwfwKQ
	q/qeg+J1Rn61Hls1Zk/SqeR3YaPm3jusScvlRz2IvhD2xeore
X-Gm-Gg: AR+sD13gkoznJvyf79DH7jWGmtoW9j7l5aySBcJuMTvRhYbMUARv8A0xwbZWqpMmmTm
	QUbZhL5sI4Vx4yjs3qIzBOdM+Ev9uY3I9XrGCftVHg6Oj8yj1v8kNzAwRlde1BipVnl/VkjnNUd
	VJgPclYEgXADnVGXXJK97hFNTQ5QcAAgaqLphiiGfFzOcoIqT9QtrY5ha97X/HtxRcD6h5w6bFB
	v/E/HXwytTFdQ7BjoqHENYYdsNjhKGUgf90o7lEtmOndPkOs8VDYm11oR80oO9uafrZS+kZmx2q
	6N51WgrhyIqU6Q4BLR8R4VTysM9e/i12DymdqcFLtGlg0Xon5zgH94RUOGGqNolhYRDd9tOZ5gX
	fcravsA+038VEnD/jg697o2WnOYd+RoJTHe+HlB7jdhQlh6+D5MmX7sFB6KQ/Bn2W
X-Received: by 2002:a05:622a:109:b0:516:e10f:7140 with SMTP id d75a77b69052e-52d20a5023dmr38290831cf.35.1786131026485;
        Fri, 07 Aug 2026 12:30:26 -0700 (PDT)
X-Received: by 2002:a05:622a:109:b0:516:e10f:7140 with SMTP id d75a77b69052e-52d20a5023dmr38289631cf.35.1786131025892;
        Fri, 07 Aug 2026 12:30:25 -0700 (PDT)
Received: from ?IPV6:2a00:a040:199:782e:ad40:551f:594a:fcd1? ([2a00:a040:199:782e:ad40:551f:594a:fcd1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995dee21dcsm73783835e9.0.2026.08.07.12.30.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 12:30:24 -0700 (PDT)
Message-ID: <612ed1ce-e7a7-410e-9ad7-256e77bc867c@columbia.edu>
Date: Fri, 7 Aug 2026 22:30:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] mm/page_io: rename bio_associate_blkg_from_page()
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Christoph Hellwig <hch@lst.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-4-0899bac3b826@columbia.edu>
 <anYqSDnC2BbJXv1h@casper.infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <anYqSDnC2BbJXv1h@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDE1MSBTYWx0ZWRfX4PSTv04QYo88
 hdVLr769jwixXeTa1VwA9kH9ux0EKJii/RWbRJktaCWE8N8u4olTcLhxoUKpyxSKdA4uu7wPxOj
 2P56a/Ub0boO3g5XgBKzJH45HHECKFtO9fI5Aj8bpbqSnrLtpCjB
X-Authority-Analysis: v=2.4 cv=QNVYgALL c=1 sm=1 tr=0 ts=6a763253 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22 a=JfrnYn6hAAAA:8
 a=UXSnSC6aE9JLshMh4N0A:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: sYBcNNyX_DWGS2qJP36eJzVtPNs3c0fx
X-Proofpoint-GUID: sYBcNNyX_DWGS2qJP36eJzVtPNs3c0fx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDE1MSBTYWx0ZWRfXzXqSQ83sxXS9
 FeR624QazkOjIyTaByW3hiC/VF0yubvLcVOuzg3RZiqFfZr4qp0XluNXM8x77+p7w6S/mMS3P0E
 ta8DFnGPRGQbQvQtu4AmnzytD6jThO0I75+ReM67zjkNC1dEvPabOkVemmtKL+e+spIR4Ti8DFB
 QdalJGU4YUzjUq5WzZY8yjtqRkDccRsYjCZ5grCdm1w0NPp/ey7cW8mugvw6R6RsLDlMIZ+rDoN
 4M+EAcCyXOuZ3EF6WXX5ZaoKTzcIauZ2X+y9UG38D890uwYEFcdvssQSiAaDt86QtmE4uzErwoY
 5BLyJ0/hIqynJ1jvcCgVJ0C4vAsz7z5pIXGh3ART40EKffYnTlQHkyEwwrsvbfnUmkIGwMTs0MZ
 IUXYAYDdNoNVNemDQhFj964az023dDhPn2Gkve1JXtIXiijYTnduv3lt5Mg1oK5i9FYjxO7MdBf
 2rPy/MdRDHqBQEePJRQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11868
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=10 suspectscore=0 spamscore=0 lowpriorityscore=10
 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=10 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070151
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E076F4000F
X-Stat-Signature: pqi48sn7zk6byzyuj46xys1n7r8fmnw4
X-HE-Tag: 1786131028-190728
X-HE-Meta: U2FsdGVkX19wZYTIglJmdUHFUvVhZRGU82n3H/VKg5n6BESJtpOHvIYyaPdrnp5NJuwgEZcE/M7GcUhLiGbYHL89qLuY1gQ1gkbUo9e+hGqnz2DFKRy3w5aR1FCOnMtWb2PH1NpdrnVXjyN0s7piOIrqpCqj3vl4MGwMt8Yc9bYSsuKSXmE4of5g/N8g2MvGUgqtCoC1UKA33ncltZ6r1/pC8mYlL44cMKsI2d7VzEr8x5mjD46yESipJSaMVEm1sasFdMTdJSyfbo/WNYkqGj78c4PcL0L69JXwt1YCbUNOo1zpiXwqeVAxiMMdR8jJey/FYDymACFgGkkBshPqvYcYLCw68uvRh/gDRIIexTnH9MO/VhJUgcKXl5OpmYaaaPVL9244gJMAO1q4OdP3P9RSnsAxpODKF/cLPf7g6AW7qa+y/7AIKq/rJdvyx1EXEupxvZhpFp22CIdAS9p9l6HLNC8ufLUjIer1x3UVXH+yGp50YPzJ19a/IyBKAvgmWhLgFlJrnxdSOn0OI03YWlPT9vrwEM+W6GhN2zomVx3yd5Pgn8H4hg6+PXCjX1nWHtfpaGPQTeOk01VczTgNGX37w/YOtcDbfMq0eQxsvTJPi2hLpKy2mUkQroWUs7E55u/X9MyuRtPrXIwASYLDfRF+Z4BZpoEZ4x9kCXU9Gn8riR90ensZMdVXVRDuoGNg/Zvh+bvGymEW0eCb7N7NDj0c8O8WY1OtII5HXLWc/dKtUfD99KleDFHxFlL+gE+qyBq/igWh8fhukRouhmQPgve4FeKABXfGuiDvrzNXFVsFYjMyhpzBNzGxWtNHjRhBC/aeMYlllhjL/KIVSJip/1Tn8B8IqDi2PNRxfV2YztX10TsBGK73TBObtnj46IqQIKA/vDCxArYVYtmJRxSs3WSE5hL7GbEwckuHRzkejnHmCI26vpUktLxU0F/8MTEHDb879dejlGgMXO82nXd
 pXtH0d0Z
 c4HKZmXYB3XXqItMWWEuIf3cVOZ43Ynpv3hd90UCfCAtNOfU1xd7nHJj9ZqAEDh7p4kL4d9Ow16p/vaO8VKKBQCXrS8bpdD9+23Gt2jSt82Zq7WZsNkW8KwB0Jf6vuWav2kisVxUCPkj/LNdXQhQhuxzyvAhXAp6YJ0mDJkqeIrxee7dULGiRpzVJQUf5NkCl5k+rw7FLn9wSaBc8hfRSPiudODv2CO34nHrgslK9S7rcOstLmaNBkpk3VRBouSWM+RlgLB/mdBtQ/Kt9R0J73QnJAvFQReXYtlxi+i8tYG1zGbwrMMIMIVlCwLO7K3gjd0osLJnUGUQKNOMYM3oAhLkExgkpPUU/DeyBklIzp9QjFW7qSf+0zA1wtbvCgE5FFqs8zcLiUtaekKE8+6UqtAAYqjuhomJZJxuA3WnmZOYOd5CgGTgbg1Vknc5UD14DlfAhLe2PH0iKLuo0UKdu5uQd2IIAK1s/P1ndLwrmowpT6tWje/4SGF5KqcpPNjGgRp8A2D/2aMVO+V00ajAuLJsa0Rn4ZioQ7TwdU83kSpauPPdOZan9uJ/iyHYEJ1S1Ij4M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 2:56 PM, Matthew Wilcox wrote:
> On Thu, Aug 06, 2026 at 06:55:36PM -0400, Tal Zussman wrote:
>> This function takes a folio. Rename it to
>> bio_associate_blkg_from_folio() accordingly. While at it, convert the
>> macro in the !CONFIG_MEMCG || !CONFIG_BLK_CGROUP case to a function.
>> 
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
>> -static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
>> +static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
> 
> It's s shame this isn't const-qualified (after all, we don't modify the folio).
> That needs folio_memcg_charged() to take a const folio pointer, which it
> could.  And folio_memcg_blkg_css() and folio_memcg().  That's a followup
> patch though.
> 

I had the same thought when looking at this and went all the way down the
callchain to dump_page(). I didn't want to flood the list with patches, but
happy to send a couple follow-up patches once this is in mm-new.

