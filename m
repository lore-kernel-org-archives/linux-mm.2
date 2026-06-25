Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AE7CDE00E
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 21:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6636B00BF; Thu, 25 Jun 2026 17:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CED96B00C0; Thu, 25 Jun 2026 17:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB34C6B00C1; Thu, 25 Jun 2026 17:28:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4E466B00BF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:28:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 496E714025C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:28:22 +0000 (UTC)
X-FDA: 84919723644.27.EC2904A
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 98FA618000F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:28:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=bhsprzAC;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=EOp3vwcy;
	spf=pass (imf16.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782422899;
	b=UejNz1UabMt5YmcBSE8UVHWsyzQw97vAaX4nR8haWcO1n6LSmzmOa68gfpp/B6LyAEiUr1
	GaKSVrb+z9ISLAALJ6V0jFozrWc8vi9gdHGfu/jObDZqHFfLZv8GKCo1xQ5mJ3uJ+BxyxA
	Kk6CCGWHL3JRrFSN+PpE2ttYxQeWLm4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782422899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QS7UHeLZQ8FUPa0FNvzQZRUxB4HFWhnIDFIBp7tIS6w=;
	b=wayYb6JQBYGaFREv92ZMQFz+yxpwmIgdij872Q/86hxG+Xy2G/KW53Cun9F96t9PPe+81y
	NWHSwIIDNwKm5x+gbrj3ZuZ20JdTlEXbnyb6woMvWQrT2N/+HPSEXBF3Ud90rMNnLGH2aW
	GfSEq4Ua7gecsBurK6U2Fj2VUV3K0qY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=bhsprzAC;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=EOp3vwcy;
	spf=pass (imf16.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65PJkb1J3388125
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:28:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QS7UHeLZQ8FUPa0FNvzQZRUxB4HFWhnIDFIBp7tIS6w=; b=bhsprzACOGqjhen2
	Nt0Y5lU8ib3eUGl3WmeWVM07S3w1G8hoBh7Y8fPitS0YnTc0muQRKdkKq1BXYeDN
	ZmFG8f4rtiZ7RuSDvVBMw8iIlbF1S37lqzaUCrcwYPdKAHq5W7j1KhgiQ00wERwM
	tDlGXG91vHqjZk5bsDPLOgCEROI7TLmCpZE+ujqzl8tgHzvTv5o6R8pbvc95Gl6j
	czOU/9bOCDde4vuD/yxKzWVT87G/ML0UcBgGzvvN2i4Suad8HOj786YyuDcmNthZ
	cKYisTflEGgBPVROWcQmWVnqWnWUY+76GkPUb63dfqinaESZoUrUP/qtxHn5J4pW
	T/Zkuw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f1askr99w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:28:18 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c8a940e76so349269eec.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782422898; x=1783027698; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QS7UHeLZQ8FUPa0FNvzQZRUxB4HFWhnIDFIBp7tIS6w=;
        b=EOp3vwcyarUMYhoPCiBhTd5sNRKXQ1RGRIylmOFd2gJMCllm8jVmGSKSqxVYESoaZ1
         OU0yYqGbuFaPMHNCEXx+Im/KbL+QoLrbIln0ckxOzJVv+yRT2wLmoZUJnB7DeRrwRniC
         Ks335OuaGXUN+ts0GKNUeQU3mBjmOrUnylhNc9O8XMXwHf5VPRpT39ZqXKDY15vwt/2n
         kkHKWNz36VRlJyQX7BrgNEZT3GGUamUg/7IMiarWleo8hstVEH7AOj0WKZlkojZVAtQ1
         o5QlwRFt2ZJnspmXCBYcli6AjtCxaDeUGijooxTvHX3hO6MsInwB9YV9PZHepha+/gM4
         fvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782422898; x=1783027698;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QS7UHeLZQ8FUPa0FNvzQZRUxB4HFWhnIDFIBp7tIS6w=;
        b=GhTQcJkPObat+IeYW/AeI+IlBGu+lDLnTrvEl+tp/kzHuoUSMQOWqdSz32g6EzUXeN
         YW6NpW7U22e1ooZh9A1LcjK1mzH4cwiNih9y4AOwzUx0ONt35XdPzLtbh27EBX/dSj8k
         SkX03jQ8ELNnqGuhEI8B7IqlOaesAtpFefSzEnsqTc+XbmLHe93rhStrJQ5TNhkKOm+X
         t4o08j9X82mfenQ2NFy+4oOMsPb8qwNFgtBHXidmB+JymtED97UYz3dLfo4QxFjPfnSV
         9kKEz/wwvD55htA8dn0f2dZ/874hiN0FMYevhldmdq7c+sbBrxIYNZPOC5yfdyvJbEZb
         tfMw==
X-Forwarded-Encrypted: i=1; AHgh+RqwMqE31cduYwA3JcTv8y3WlSnitW1sUKUe7jGCGdEy7Zlj1yZpa+KJ2TL+eRxhNyCSmRWXoMDUaA==@kvack.org
X-Gm-Message-State: AOJu0Ywa4nw1Dq4YLVf6FvYqLFGvlF+MrGNZ9Xsi0QfAu8yLy8IO6hPF
	v/3UUT+38rtzBoeeglp1tHdFRc/DVB6IG5bzxmlS2a0Kt9gfSCOCZSWUO+g02reOW7MP3ClmoYs
	EBJBDcWZcGW2KX3n/sPjGfLJuyQDdi/1f6nI3RKeCM5YjEZYUZ+Hx4A==
X-Gm-Gg: AfdE7ckNZu+Boo6/b91KPwpb9dPXIheY+iVXoQklTWFITmU6W0NnLQiG5vPMPs3phCo
	Z1dOyAy7ElPn5jjFbNziwahAq43lu4rAJBB4IYml6lVEK6JcVauV15LiLFCxWfuvMYXEi48zkVL
	ZVY9/T3/Nunq52GQZHiTAyvmHVGA/0R73h5WD5hK1UUfpJeCL5zS7hVC+Pr6ueX6xmr86LxRWoy
	Q3sLdSn9onwgx/5vuUbUJPYc/pamMkBT3gND11EQsQlOmnOSM0FfRjVrJdB2k7FtflKTRTL6IXa
	b3Fy69EP3u6z7Akxjxh3JpO7eAnJ6WEwtGf9xztAV3vIdV716odr9pn1BXaZQekwibnBpSgX4kz
	x8H0k/kmeoPDXrRolh4Sjb9rrX3d0MOzOqSYtgvWW
X-Received: by 2002:a05:7300:d021:b0:30c:536e:3a8a with SMTP id 5a478bee46e88-30c84b7208amr3993381eec.6.1782422897690;
        Thu, 25 Jun 2026 14:28:17 -0700 (PDT)
X-Received: by 2002:a05:7300:d021:b0:30c:536e:3a8a with SMTP id 5a478bee46e88-30c84b7208amr3993332eec.6.1782422897093;
        Thu, 25 Jun 2026 14:28:17 -0700 (PDT)
Received: from [192.168.1.4] ([122.177.247.87])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c4ca21fsm12718751eec.6.2026.06.25.14.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 14:28:16 -0700 (PDT)
Message-ID: <5285b561-d610-43d7-af76-ba5da19e70ff@oss.qualcomm.com>
Date: Fri, 26 Jun 2026 02:58:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
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
 <ai3kkIpaR0aT_6q5@casper.infradead.org>
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
In-Reply-To: <ai3kkIpaR0aT_6q5@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDE4NiBTYWx0ZWRfX5PA33/frZluD
 lJ3r6bySe5+Onrz+go5PuqBW9apUI4EqJggXvGQYMsAdtbzQc35LYcKGpeGHfEpWV4gDs+GPii8
 5ZKI0lDFIgKkOKBo2cSJNG2GWzJun0M=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDE4NiBTYWx0ZWRfX4AGBQC0Ajqan
 GNGRx2wyvf29WkkY5dMXemwReLl04ftA6BYcDU6cit9fYBTK2vwK5QJI6xZrjOqCAy7JyAnXorl
 gmp+bv9O9aq4Y0iv1Qp8FxRhTBti8qG6/6g6Cpd7QUhX6FIA1+sLPe56XMVBZmT5yB3qQVpTyJz
 OAilRakTjpuP8LPG0JYYWqj5SS3wn2NCoIM/WHl0l0yyF/+qgJrYVG0p2tNR/xBGogL9WUvRR/p
 guWofkrygAu8f6RK3xN82f7YZwu5jFDTx1Fbm3xr1OnyQzXuFYNko80dFB3yL8GI/Lg1sTL8IyU
 NIMkcXjV6pycfIXp/QnNbwFmji9aQFE6K3kUbZxvIky/uMnfgK919i70IqyU7NifF30k86NELlp
 I2RmOVa4QonfoOAH7/26aeOX5jtxx3lfiHnvn0rVcvEK3cUeLwq36/lFpnRBC65C3YAZYF3YXpZ
 i+UQup5SjP5xbFGpNnA==
X-Proofpoint-GUID: HusUyC95aKj_dZLtBnt3JhX2OJIids2y
X-Proofpoint-ORIG-GUID: HusUyC95aKj_dZLtBnt3JhX2OJIids2y
X-Authority-Analysis: v=2.4 cv=AMxnnMPh c=1 sm=1 tr=0 ts=6a3d9d72 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=/mmxY0Z96yNuczEkiZ583g==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=QrJ9IbtdTVaOtOl6jMIA:9 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_02,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606250186
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 98FA618000F
X-Rspam-User: 
X-Stat-Signature: qqjj1nx8fep886cuyqzjfbjrcfq41h13
X-HE-Tag: 1782422899-645061
X-HE-Meta: U2FsdGVkX19/O2z1Q8LgaFNDCTZoKSzF8lZTY2o3KPjpx/O++w5v/HUIg9+ggLSAmH3t5RoPKjVNzDwaQIWY1iruu4fEcRz5JilArm1WM0RiCFCa5LnCeIiOVutK1q8tV4nD7RfQ5Szrgy+Ou+MTJEIwNWyMIXc1d9IdAq+68WZePOR2UF51JNm/6Gl1tqtu0OZ0XgyUfBydwQ2Robc2bSIdtdnd/Loon9pKh+rohLqNAg7xbQVIxb979FMPuUDNUo6Cc+FPdT/3pKgXXo3Mfzv9sBvGxhdJ4x/qyAHW2YhqyAb8jHhtaFoxfKspHi4JPe4vzm3ihNWyD3+DHD4AXfNwEwF/3MjT3T3SOLwQef3S7re1287UGSEyfXWzrgJSj6Z5TdlETgA+i0naOqBQnt1b1X4JwY7MWNc3ZlX0r6jRlcTjzUXTMYsggBHV9YBrARnMGcwb9ISzv9NZ3U5ACgeMs8TJtrqvRj1B8gVN7B/IsiUCIoD0Dm2JziNW8aAngUUzFIMCr34PXLPRsMD6jRQYROuGY+duAASMAEjE0yvAwUfHsNp40jODeKB/VLwv88JwmrpG/QxHr79TEBs5+dtCz9GQTLVlmg0goDVx2iHzx5gCqVU9v0xVq/3Xr/YTuBJFDT630YQvJpxaAl6wuLUGhPbKezetWLZZupuHwfXVBGUHt+TmrFTd5YuUxLlrXFHheOIdY+2hXx1D7f7Doy4kmVqZ/AInsN93VCJiNAYt/yhguNBfRnpESheVMWpWg2pThsGsawCwZgyX08rVc4cM4uTOls4GKs0TPEZSv0Ckqi76xybvlY/hVnlh35HEmtpGH0TQ1rJkNgUG+8geYcFTkLifFGZNXOpJQsbe3E77EvN3zDS6fkgGHZge0zeCZFRlKkDM6SeYtmppu2sKjOkTyRI4jfHup3yK6dRxfPxlJBrDJ0fHtZwaFzGeAqHJc4S6kez7Q8bJhd9Jjjz
 ycZzEdGL
 H0mVNE0j8Ioh9C9gux9kwEWysaWMXq8jSx4BvOQARxSUJW5TtAv7fUPlQ9b9Ij0M6SW5hlsbVB1hCJTSrbGcsd4FqeqcrgLN6okajCPSUjnJV/WBTENCF8V9TmjcP+kucS1rwTiePrlmTqh/GFYWbNBZndBDk0XYvaP0DnavxdmqpWTUiPBJCiUlqHu9IZlg99rRW/6QR796U69UaF8/wORfyIs8VE4Q+vk0I02eybj7X/LvpUcL9RFcQSOve4GHtfg5+048ta0exiKprElvTI73W2zSPncy0reTBQekRnGM4azlMxCDomOUnvmHmm1LU1ZJYlHL/YKb9AoRKbYhTWIymhFVs1bCJux14sj9E3E9qsscHAUY4vL8rky0NfDWTguN9OfQog+0yoSAiZZ6vehs/XsE629Fjl99FUx3BPx6C2UgbJfV+GShQECTQsuM/gL1chRTqgNcPcyWgSY4Z27cuPoZucB4jSxvUvdswk0gN9JAeX2h9YP28cPatnp4woFnQHVjVW3k4zWUgS7d5Y2wOajpwWE896oXwj+F7cVUz43RE0es+RXDDOWFI1Vhryobe+/AFt8HHUP3nbp/ZGVKTSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/14/2026 4:45 AM, Matthew Wilcox wrote:
> On Sat, Jun 13, 2026 at 10:49:42PM +0530, Pranjal Arya wrote:
>> vmalloc's free/busy/lazy area tracking is one of the last remaining
>> augmented-rb_tree consumers in the core mm allocators. The rest of
>> mm/ has been gradually consolidating range-keyed indexing around
>> maple_tree (notably the per-process VMA tree in mm/mmap.c), and
>> the underlying reason is a structural mismatch between rb_tree and
>> range tracking:
> 
> First, and most importantly, I love this.  The maple tree is undoubtedly
> the right data structure to use for this purpose.
> 
> What I don't understand is why you maintain a separate "free" tree.
> It should not be necessary any more, but maybe you tried removing it
> already and found a performance problem?

Thank you Matthew, that is very encouraging to hear :).  The maple 
tree's native range primitives and built in RCU support do make it a 
much cleaner fit for vmalloc than the augmented rb tree was.

You are right, and I'm going to remove free tree next patch. Allocation 
will use occupied maple tree which will walk the gap space of the
occupied index directly.

The concern that motivated keeping the separate index in the RFC was
lock contention separation. Uladzislau had originally structured things 
so that the alloc path could touch the free tree while unrelated readers 
could access the occupied tree without blocking each other. Your follow 
up explanation of how the maple tree's RCU contract makes a separate 
free index unnecessary is the key insight with MT_FLAGS_USE_RCU set on 
the occupied tree and call rcu deferred vmap_area free, the same 
contention reduction is achievable without maintaining a second index.

