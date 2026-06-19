Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 261D2CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 20:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9186B0088; Fri, 19 Jun 2026 16:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0126B008A; Fri, 19 Jun 2026 16:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67246B008C; Fri, 19 Jun 2026 16:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 876AE6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:44:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E86108F45F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:44:31 +0000 (UTC)
X-FDA: 84897840342.24.1DCE0D3
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2308920002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:44:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=aPEAIOaD;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=A+qweSI3;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf03.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781901869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z1XEjmfHIHBIydnGFB3ZVQBYU0/qcr0YwGi76rS8gMA=;
	b=XXc5Zi5TFZZQne8aqquRsLZn7/5hHWAE6IrZz5Eik0Z+Fp2zUTuGAC0eK9pvRDc6dNjl0e
	SmminrOTFx2FStz95QwMEJDIhr9wvTdtKEb/rOS6KEtNKjF8kpcYhD6VtrqvHOXjh+/s4q
	/MgVWnJBA2Ncj25X+qNazcNMPkaASzI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781901869;
	b=J15GVwDaYGO9v/VaF+M6hdcVn/UzlLUoagQNZOs8lYGyKlfVUUwdfhv2ZaaDkJrw8mIYj8
	j68BENK8lf1jR9VTiQ67Yer0zAA8GvJNeOe6M2R29dkZoozq+joNWZ4G431GI0KAyfDg1P
	BMD3JK/yJIobhciiXL05XnBn1zgZpHI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=aPEAIOaD;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=A+qweSI3;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf03.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65JIw5SW925865
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:44:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Z1XEjmfHIHBIydnGFB3ZVQBYU0/qcr0YwGi76rS8gMA=; b=aPEAIOaDupADdyB7
	U4hJorJptV4zgsdshtkV/gtxxfRaNwZ+vRFkVLS7Gf35Cu0do0qGo9N7EeNXhGwW
	n7Lq8IfplsAb36Z/8Vn5WgvvOixXKBtL3/87rW2aKAzeqezWmj6I8TKqDsSPlaRZ
	8v3RI7c9Hade+DX5hiWQcnOpLc+AaZ/e5Tllke3J9Vz+glh/e0c5Le4nJxGK9Jri
	gi8QIKyXxKjzcaDVAuocK+DitFTIbo/NQzOUQ3GYs4zn1a1Gzo4rQ1egNwRhWft7
	YXpRYWQS5cZPE4ABF/wlIzyMqCWrvmW9dKjddFwW1GHjiHIe1uv1wwcg5ryxA9FM
	leYiDg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ewbgp89wx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:44:27 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2c6a9bbcc53so25480075ad.2
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781901867; x=1782506667; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z1XEjmfHIHBIydnGFB3ZVQBYU0/qcr0YwGi76rS8gMA=;
        b=A+qweSI3s4J0ysGKxqx3g+ARR6BO1+AL3evW+0AMQnxXE8RFsPqkuwCReOtqGkOPQ1
         FF9mkKR0L8c0f3JRhYXwKilHzyPkXINNxkugKeGlIPTLxlx6kaePN9oEL/8JccwxqQeb
         Vp5Nh0hS4/PYLC6VdJTcbMvH5TgGvkFi0n2Gne7rpKgdeqpGhPGMXJNpk7MSjSfMgYCW
         9vruO6I3QDpW2MW7eXwjOnMtj8+Ie47T/88+d5dBr32Sd1GJoVLb6BMFx7+mdSQRSLiy
         lqMz7zw2tGzLNKfgC1kSN+5bf6If0Ft9KonCpvHfvlWf2kvtlTkAE+pA+Qut/YrFiwH6
         Aj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781901867; x=1782506667;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z1XEjmfHIHBIydnGFB3ZVQBYU0/qcr0YwGi76rS8gMA=;
        b=dTnWU7NQGkMp8NjL1UkFlGb8SfAbpyNLj9VgkH+W1HPmxLGkpDpXMfNVU+cVkVSl1S
         lnTkcXReG4h4XYf7d5VF/B4ailCF+Pjc1QTyNk4o3dYyuwYZs6gX+3OId5aC/YqBP/vf
         Hi9UEh48PzSReUlh1wnwByHzGov9mhlDZZdrzgw81Svb/uXZlxhirOvYk65E77P6hxRm
         KFjyAQE+nyYJszchSjwbWkWeFrYH6asuYfet/3RCMK2k7tmSyH6+bPkV6pP2J37o+Ptp
         togp60ptMC/d+p13JLrXmjuc1AQc2sLxnfLH2ucBs5Ey/nHFGxQrSmRhfd88IQKaXQwf
         7O0w==
X-Forwarded-Encrypted: i=1; AFNElJ8Zdd4ViRkvvZHQ+WskEzybCyOyoZ/LRLHynrBQvcpw+gWbcKcYIkyCSoEi7hTapJV2ErZxS28uuw==@kvack.org
X-Gm-Message-State: AOJu0YyZz5VQUscWoeysPga1KbHpSjxV6KMalBvqdpd/+y9DoK+GM0YK
	BgAIGMqu+wuuA45j5hqjtmaOuBqfGA5hx18IBeSSw13dYCgoI2ICfuni48f7clQrT0+66RPjick
	OPEsESSbUFfrYSoByRUMMb2oXNGzslkhrFR4yCtYY1g0fUWJpt1NXsA==
X-Gm-Gg: AfdE7cnCbDpvssP1a904h+qTqN2VhzavVu4hXLOWTGXSCjlCQM6uKRpyjlQWec9AhKY
	0frergQey2T94TVkhUvy1CUVzcd+KBww3bc/hieONanKxpmoAXtqc8QhEfviurIMa0Plk/FLL5W
	0+EXbT2Z1gJRoUjfhOORTmwhB7m1t0q8u8wcAB0CqKBtmeSHpN+OH+eSV4heH7CenAc32pkpXKc
	E31dKukTmH2vjatE4FEsOxsvrQDgr4h86B0BqzaiAFpExTrvYNx6G8xjxSeNHDy4701E3C/t9ZP
	Iut3gzNKPU5jQmVVj+GScbFX6FUZt4Ct8TWys+QGSUMlmwtN31GesUVK+2193eHtW2dPcOrjQjq
	PciTyq0TAXVSC7koR4TbUMtq0jAHX5+qFox7f6PXzIQ==
X-Received: by 2002:a17:902:db0e:b0:2c6:8e82:977c with SMTP id d9443c01a7336-2c718cbdd0bmr53694805ad.15.1781901866917;
        Fri, 19 Jun 2026 13:44:26 -0700 (PDT)
X-Received: by 2002:a17:902:db0e:b0:2c6:8e82:977c with SMTP id d9443c01a7336-2c718cbdd0bmr53694605ad.15.1781901866455;
        Fri, 19 Jun 2026 13:44:26 -0700 (PDT)
Received: from [192.168.0.8] ([49.205.250.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436afd00sm3131675ad.15.2026.06.19.13.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2026 13:44:26 -0700 (PDT)
Message-ID: <2c77c4f6-cae1-4bd4-aa7b-82da96334d6f@oss.qualcomm.com>
Date: Sat, 20 Jun 2026 02:14:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_ext: validate section in for_each_page_ext
 iterator
To: Matthew Wilcox <willy@infradead.org>,
        "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Luiz Capitulino <luizcap@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        kernel@oss.qualcomm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
 <1dbebf73-6c46-44e1-ac6a-f5ffa9849b37@kernel.org>
 <698e5cdc-8f1d-4984-bb54-a4b7979b4dc8@redhat.com>
 <3149fcee-eded-49b0-baf4-ab69c27ff063@kernel.org>
 <ajVGQg0hJCUThz5Q@casper.infradead.org>
Content-Language: en-US
From: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
In-Reply-To: <ajVGQg0hJCUThz5Q@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: ZKZrUpIoVzBclHAqcdTwjjvcqnJPWv_M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDE5OSBTYWx0ZWRfX7YFDlpzFKUq1
 ksrlLxZhTufi/kMKJy/9COvDnP1qg0Vya6jFz6x0/FWlpMNPPHN3dMbp4PE+qUAJenyizeWgG8O
 U8GZjSNND+STrOd5W51LWFZlXtJt77tI9jR7S1kFHNavgkoVjy+YoYZypp8St9rcv+s+9gWcEtf
 1ubSBu8cyhMt6fy9LpaU1rP8Expe7CCeD5TF64lse918MzUs394RYnAJ7YFnYbbNbaNr9axOpCE
 BYNpZU3KsqeEGPB949L6zrIiwGp2tezg0mSVJ24YtfNCcfN1qx/cmVhldM/Is7mTCnW5GfDEOSw
 owveYvugut7lPUiD01CPSHTy3ua8cPth9dPR4KUObeU1DGL8kLcm1mgxFLBAQ9lYKo2KE4lMJ8y
 Cb0grXDXigBlaJ+1foVdXmnx0WNxUm4l6Zb3mhASnFDAi0H8+LP1JlRWVO0/lcHTI+DJ9QrbxPz
 m7wI3Eq/oxG0OdBK/SA==
X-Proofpoint-GUID: ZKZrUpIoVzBclHAqcdTwjjvcqnJPWv_M
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDE5OSBTYWx0ZWRfX2UDB/RYFBATo
 M7vfcy8eeCE2URqW4LXLUor+/XkSJw/Ngk34qqL2VOWbOqyksf9Q8PpqN5JXo1VoPtoZTYGFv9b
 VYa8kvKOqWWk0Jm7klhYNWLBg4ksXxY=
X-Authority-Analysis: v=2.4 cv=d8vFDxjE c=1 sm=1 tr=0 ts=6a35aa2b cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=BL6/p84Y3ifFzq3ZkNxHwA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=POoiuOz0Jj2GNAffc_kA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_04,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 malwarescore=0 spamscore=0 phishscore=0
 impostorscore=0 suspectscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606190199
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2308920002
X-Stat-Signature: 9nsir37xjpuykmaer88ffef17pku8isy
X-HE-Tag: 1781901868-544232
X-HE-Meta: U2FsdGVkX1+OIk1/UfO6yvnMpoo4Bu+lQ3R47rpyHBuTkwYXokD1VUDNSK6Ul6CHkqt/jn3u1M6uwx/fbEpMgwxxiGatxBVUj2H/seKG37sDWYqKWDrRJb9NcbvXc8+z4Gae4Xb8BBHVOARfad5rU2vRRbtAeKo7jGLMkdNdClLDfgjNq+O+QHtSHzWg7pPwr50i5Ta/qw3CjESx/QEKoNF25CWZvXa+tgwTjMwCDBNUuxhV789Hu9pF4v5IZqL9s4coOq1YgzRgjH9uq8njbajo2Rce8bMjBp1pBrVrrWy/wfO5qMUbLZUB+LqESLvhqj4Y6CP8hx/09WsgyWCNTrcqCe+qbiI+a6U1+utc5VHP/IArZC17oQSIf0AY27SJGvS2K0M8xZFslac3Vp00E9/BIQN9VhaucXhnGDVD3ghMlN294rxNpRhMFL/uf8Pd81OWfzy2JjLT4RA/Fdq9UyhsC3Er/SKgwO1Hvyy9tmUlwduweTs3pGENieMUCjjhLXZOZF/VoIGqqYGfi8yonsbKe+yKNlaccWoWukccnCyw1wl0/REF1PjIxiSC4tFwAlUBHHFlMe7YzfcGIE9I7Ujdn6aSvx0NsTxHCrO3UZEivNamru2rSHT3/Y6yUQ/JAVZF5qdJLieu8DFGzE9CSZteJewnDYRLnhtMGAP4VQMd85NnS/Kq2iJfeOF+OL5+jH/1pUITNDKK3UtP1K8RcKpW6yaxMlfCt4f0GnS/D59NjbkpC4RVxNV0fdwU41Q36ske4vDVzQgT0yWXaMzC2FyTw4u/hhc8UezVyhDrnQtTcZ9iqfI8lHXGJyzzI9ddwBGnflaWEdJsWBL3M81Od7P5P7Ta8+3KNgKBC0bEHG/BUrUZHgLVQpjaKzAYsD0Rlvv9NPl01LW9YvMcU8Zv5WupG5OP8tOcqiipQrZ2zQpnCfIV7vZBxrlopS+oJ0HtxUNfoxlzLFIBQ+GEriU
 qzBj2Zli
 77Gpkx0krfmkyntISBSRlNQ9Ik9EmnXq9+oOsWRTnTJfmptPyvK4aWVYkNbZZnJhJ5BdLXvFPdqsZgiTZHgqIsOoU62L+AMAIbq/RIZZytrOQ4jkg4LyxXzWtstrRnzw5d/j2F8M7BEnO8P4mptEibiFx0zUp1M0e4lYFYqVUhxdGvLz9i18MMwtKgjlfNO2pH2kClvjYT5rR2kZG6cvrN6Wcm1XvPlJzrsh6C7TcaOIzmwcHI5lGLqrRlhfLAxqnmVihIoeJlVRxliZE2/K4s7m5Py2bpACX02kGb4QGQdoidti+pxDwyq1Cymqxxbx+yyjoWZ987HnIbAllFt3dBeNYhajsGG3cHK6oVmM6OxYDgDnfET00Oury/E1H6muxEhThYBxtkThURbOPECg15PuAv235fRgCwMyiPROfPQ/uCN49F4l51zY7PudVj+sfqhLDsemWtdIICbi6C8taz/k3K5MbBeaT3QstQGi0y2gYUiv/vn/rDVxel9+qHAfpaWyihLMqV40Hc0J4Ad8Ng/7BDnnwbbFgzcjgtIvcFsNaoYADKBqRHbYhAkFBSHvV3hzH7wWHeXFW4BoweTT6JYOfxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/19/2026 7:08 PM, Matthew Wilcox wrote:
> On Fri, Jun 19, 2026 at 10:00:59AM +0200, David Hildenbrand (Arm) wrote:
>> Likely we should just handle that in the iterator, looking up page-ext for something
>> that doesn't exist is weird.
> 
> Yes, but I prefer to pass 'max' to the _next step explicitly, rather
> than put it in the iterator struct.  Untested patch attached.
> 
> The other way to do it is s/index/remaining/ and count it down rather
> than upwards.  But that assumes none of the iterator users look at
> iter->index, and I don't have the patience to check that.
> 
> I find it weird that somebody botheresd to add kernel-doc for
> page_ext_iter_begin/next.  They're internal implementation and really
> shouldn't have public documentation.
> 
> diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
> index 61e876e255e8..4f7d7a8709de 100644
> --- a/include/linux/page_ext.h
> +++ b/include/linux/page_ext.h
> @@ -120,14 +120,18 @@ struct page_ext_iter {
>    * page_ext_iter_begin() - Prepare for iterating through page extensions.
>    * @iter: page extension iterator.
>    * @pfn: PFN of the page we're interested in.
> + * @count: maximum number of page extensions to return.
>    *
>    * Must be called with RCU read lock taken.
>    *
>    * Return: NULL if no page_ext exists for this page.
>    */
>   static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
> -						unsigned long pfn)
> +		unsigned long pfn, unsigned long count)
>   {
> +	if (count == 0)
> +		return NULL;
> +
>   	iter->index = 0;
>   	iter->start_pfn = pfn;
>   	iter->page_ext = page_ext_lookup(pfn);
> @@ -138,19 +142,22 @@ static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
>   /**
>    * page_ext_iter_next() - Get next page extension
>    * @iter: page extension iterator.
> + * @count: maximum number of page extensions to return.
>    *
>    * Must be called with RCU read lock taken.
>    *
>    * Return: NULL if no next page_ext exists.
>    */
> -static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter)
> +static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter,
> +		unsigned long count)
>   {
>   	unsigned long pfn;
>   
>   	if (WARN_ON_ONCE(!iter->page_ext))
>   		return NULL;
>   
> -	iter->index++;
> +	if (iter->index++ >= count)
> +		return NULL;
>   	pfn = iter->start_pfn + iter->index;
>   
>   	if (page_ext_iter_next_fast_possible(pfn))
> @@ -183,9 +190,9 @@ static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *ite
>    * IMPORTANT: must be called with RCU read lock taken.
>    */
>   #define for_each_page_ext(__page, __pgcount, __page_ext, __iter) \
> -	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page));\
> -		__page_ext && __iter.index < __pgcount;          \
> -		__page_ext = page_ext_iter_next(&__iter))
> +	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page), __pgcount); \
> +		__page_ext; \
> +		__page_ext = page_ext_iter_next(&__iter, __pgcount))
>   
>   #else /* !CONFIG_PAGE_EXTENSION */
>   struct page_ext;

Thanks Matthew for the suggestions and the proposed alternate fix.
I have tested both your and David's patch, the reported issue is not 
observed anymore with both the suggested patches.
Since, in the reply from David on your suggested fix he agrees with the 
changes as they are fixing the issue in a similar way.
I'll go ahead and post the v2 with your suggestions.

Thanks & Regards,
Ketan



