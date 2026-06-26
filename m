Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4263CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E636B0118; Fri, 26 Jun 2026 06:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755CE6B011A; Fri, 26 Jun 2026 06:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6444F6B011B; Fri, 26 Jun 2026 06:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3964E6B0118
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:47:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9954C8DB89
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:47:24 +0000 (UTC)
X-FDA: 84921737208.16.6C5A73F
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id D70F4C000D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:47:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=iD7nxymC;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=TmCc7Eb+;
	spf=pass (imf28.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782470842;
	b=W1VEhNh5o0GkvI6FzuG/sbu2uqxt3unS/s3QQHNrtlPOqtCokzHbAIudim2UU5APp2P0/g
	u32k6DKDVgT4kB81QZCG5EVSrmmNL5eFj9jjg0khTYhCUQQmfzhOVxqxphBFa1tQg/Cm+B
	Q+0ahmrWA3I13bV4Sa4cQQtdLjBVuIA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782470842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PChBsdJTdy39hlcQc2xrVoLyCX7474bgwLOt0FMf6Ls=;
	b=PV8reNSNM/6tSd5UEgweoHwKLqhqyGqsQY/vV/F0jVC1055JID4koiP9rS9YxR68pGz8WP
	vCg109vlrvbMK4o7vvNs84t6XadCUKTZGffHoSUbd2gmHbWbgW0+slvHou/23d8anHE4T6
	ipwUmv6yg2s72DW4UvEuj50K/rQlgxQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=iD7nxymC;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=TmCc7Eb+;
	spf=pass (imf28.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65QAccFl561276
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:47:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PChBsdJTdy39hlcQc2xrVoLyCX7474bgwLOt0FMf6Ls=; b=iD7nxymCDFJjKejM
	yeACrs8LlvKBV3jswNLTh9psxaiW925eHUDLfBLMJfzSiROAU3dbupadpJwMvfLa
	h2JHcUBRcIL8wvD9gun5NNueROnQ/3zkjJ6g1y8vo/nseg2QDL+0GXjQ97XyRfMP
	bsZrUWOeb6z+nZ0oiTuF6juHHQOHsjTBD5GERvNKQac86Lojqjd0fFuZdM7HUn7M
	fv9N0L1X39Y6EgYGYMvanQeNvLQlTURU5+7TezrCFUYYyDs0UBJ8xA+A1w6UdTNm
	WcvliyHGhaxwusIwekR63QIMEPE/otIMFHKdN9UN7hr8tcP6TL6bWCJee12h+wrV
	YZX6bQ==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f1fgdt1m1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:47:20 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c95b0e22aso2330687eec.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782470840; x=1783075640; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PChBsdJTdy39hlcQc2xrVoLyCX7474bgwLOt0FMf6Ls=;
        b=TmCc7Eb+WrUTDmx5HtSWOZh0Qds+yBvMrPqygGDZquVFm6eDZCUUbQhxad33X9SQ1e
         duh1jiNlhUG/LFesmFUxEaDXeDmKrAubPcvo5ftN8SFRUvqMfZGth9WnnaxPZBhhr2DA
         aYSs+wEPwfN7xYUhZrxBVQlQ3lQ+06AjOxxgir94sYiSMva0rR3M6mZjSdL5Qt2hx+rJ
         n1cIq/+pyYlDaze93GMn9GRvDENXo7QmOaAH4FTb6wPkWkgFwoRse6gGX2+pi2C+WwYc
         qdNEmyz4HMYkcUMcBAfcKpXtcqegRkJBpBMT5JWZRYqeOX7fDxNQSpeaZxg4+rxwyov2
         eQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782470840; x=1783075640;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PChBsdJTdy39hlcQc2xrVoLyCX7474bgwLOt0FMf6Ls=;
        b=K+pN8chh4iqs7jfRqgGhNK8c7R+nNVMXtmkgqxkSWCWoT9Y2CG5YEJhNcj/xvk0Cz+
         YM+2f6ryAaH4wmeHRDc/3ounSPeaJM+cZo4Upjvh7DniF7cdS1TfEK6mavMW0Ui0tfqc
         iMBldxHcp2DH2b8yzX/imD2wSOptUNur+xGtoowyQQd13fLdHNuUTI9d76vc6F34RLrQ
         rdGR4XXf0T7W8VB3sObh9V4xq+wcmwXBc9N4J8YeWQMUzGcDY/jfMqjtRhY4gS0jfIX8
         KEdHApg6uBd1d9E+Dpt3OkXjB+PKCAvhoBZjIDMndgSrrSFb/L6AKglwIt3tMNkoHdoI
         Xsaw==
X-Forwarded-Encrypted: i=1; AHgh+Ro0m/tqMONeHtgMXVh+FOOLu6ouTWxhnuhvmD2KG8h9ksuUbn5fBIS6Lz/fAuqeabTvhf4vf0wN6Q==@kvack.org
X-Gm-Message-State: AOJu0YwqH0jnmwPe706nPs6xfRsEqrp5wiGui3EqOFeGz09NNc0RGq+y
	0q15frRel3bjuvckmwzC+jXrdRwqRX/2TNTbR9ouH+mdSiyZ7RjrCnG2u/4aQM3OzKAvavl/stH
	411+HU2VH34lhIheRtIz7ln/zUN7Omi7dMpuVxtW5bPcBkmfyHwgA9w==
X-Gm-Gg: AfdE7cmxLTlTmmab2o7nvairLEyR0IyvfgYLG6bmuQdi/1514wknyPaORIN9nyypc8t
	Yv2cV9ZI8Ri6cn+f8gfDTjGL5C/tWiZ0JzTUsjnfkLQ60OvI2xW+d5UjJWvMiDstR4u+t4PKXI6
	6WjUO+/qNd0PLb9zYZm+UhV1Li1HZc8x7Bk2oftI49OprjZ7Lw7icUBh20Kj7mPpQQ3kG2mCoYZ
	a+a2dJZWsSHlzV/qOSNBeJ+bZRHzY308yI9cNN+NcZFpcdVhX0lUmS55OUdFVIe6qa+rfehv6Qe
	XzMu64p84Plo+hds6RIYB/fTu9yoyhFt2Oe7YkAjqAFkVW36SnsHB7ecQm4LiRgFhkGntrZgvFU
	afXhNrSTFN2xSH3crKnMmMQPlRW3Eckva5aRr9qF7
X-Received: by 2002:a05:7301:37c4:b0:304:ab8:f899 with SMTP id 5a478bee46e88-30c84bcdac4mr6511070eec.8.1782470839616;
        Fri, 26 Jun 2026 03:47:19 -0700 (PDT)
X-Received: by 2002:a05:7301:37c4:b0:304:ab8:f899 with SMTP id 5a478bee46e88-30c84bcdac4mr6510992eec.8.1782470838306;
        Fri, 26 Jun 2026 03:47:18 -0700 (PDT)
Received: from [10.218.25.225] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c4ca240sm17658216eec.4.2026.06.26.03.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 03:47:17 -0700 (PDT)
Message-ID: <e65e6153-10b4-403e-ac40-10687ea5cb68@oss.qualcomm.com>
Date: Fri, 26 Jun 2026 16:17:08 +0530
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
 <ajGQ_WPT3Ra2kPCQ@casper.infradead.org> <ajPDDkV7yqWlhPIh@pc636>
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
In-Reply-To: <ajPDDkV7yqWlhPIh@pc636>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=API5kwXb c=1 sm=1 tr=0 ts=6a3e58b8 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=O-PE4fd2i0mDks678lIA:9 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI2MDA4NyBTYWx0ZWRfX+qfR8/ypdsSP
 4FYd+8u21MiGbEgsVsIQREzqRGlPltF8mlBJztgs+wr1cwKSTnT61K+qEEKpvVmg+sRO0ygum0g
 rpxgAlJQxtVXDT14ZvCVMiYdJST8EXXHlB6Nis3b8zvF11O2SD70KpuV+TkOlfbl6lBKwn7s4LG
 b67hAhLSleEuBZdsI+sSVgd+ltEk/4Z5h1AKXIn7fhfbsbXQ0F95WOHCSdi/ePKr70qkL3q/9IQ
 hjhKfEkAVmR/mV8epWPa/7gTH0c4rLbIZURWRLQOBIkmyNiYgddYRdF3sNWm+V/AOW0t4YAFSzb
 tGVVZFa+h8sHUjYe+wrqSAhVMHJaCCSlGUED5rlYQljQIqxqV8TV+0x5JKh8by1x10E+9y1fKQp
 ACYShQhz+/eYJcRcCEVzWZTLPd5jtIhtPTEgZrXSbXQRkfSe9bUVciYdcfrfznnabpVmuOR/h+J
 XfzcQuDrFnKtcmjbs2g==
X-Proofpoint-ORIG-GUID: wrgTxHGDyK8mMp-GfPTG0jHrOSn8b57O
X-Proofpoint-GUID: wrgTxHGDyK8mMp-GfPTG0jHrOSn8b57O
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI2MDA4NyBTYWx0ZWRfX9TuwyxXby5de
 Of7iw4T9nDkdz9Tsoe33sY9latIpIn+3RHvYrovpALwE5HDf9d5GoAILH9YWxnw9b1baMtZweqW
 1JBTGMX2feHtgFXeNe/T8rCp8bCA14Q=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-26_03,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606260087
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D70F4C000D
X-Stat-Signature: rg313o7gr46n3zbwpc9kcwp7yehaxhk5
X-HE-Tag: 1782470841-347030
X-HE-Meta: U2FsdGVkX1/Y/STuuFjwGJBEN7euCJg9sAURhKcaDJXS6sIF8xQIgJf8USafkQcpqfQrJUgpVzI99nIrafhu0JWvqKALpoKcOZPQXUfJN4OO1D89e1qu+jfigVPlq55mnfG0o/vpGHYjPqs1BUnwHgE+jZHiaLqqr4cf5HjR3z1bHHcAeOupOrf3M5qz3uJTurHAk0gpOsnan+rLUzojoLS+jPTL+37RBlx4EVqV7BBk9kSme68rUiEpRlhuQsqKDrhLVtJ9fz0oSER4pvw4R6ZqtA9eZsCHwjUeqqI2W4BVSKQe1ApCKpJS5K7RZ4Nnn/KwMsSI0jSkKSSvsXFZe3Hv/VYApPVaSV3JXI8HKnWRQvQxOHFhbdTD50zDQQ81ytkdiHW07P5qLqQN5xqkv1dfmlqSbRAwhnMv+B2eRhQK8IrevrywtIXtdMlWVfjKttxtoTwNrnwuDSW5QV8uHxoN9IX6qNtYAUqrylIWGPWBviY9UaIdXhIs/mspUDJHgkyG/8Yi1rEInc77TdC/xzpf3vaLfArc3QHS6X03S1AhBMxiqIIKG3ITs66PWzspjo/WlDqMV2URAsYNsTwm9XQ8PRGriMP8DTnqTclV18sclZF34WwT8ugL6QfhR6Gv65JE2YV/WxDhh6rNeQfTjjNbREDrT6TIhTrhnGtMPbP/FEfI9F74XIuyECbHeaNYy3e/5tg8wotYS5tTZoMt/HXGzC82k4chkL26y45VXmXTW7ebNsuXZuSg2wk6y8xbhjTe7+jM6zh6uA5x6ca8+WlG3yBEEGzzy1AtL/cpDLClbLkl6XNokq+/V3nvulVXo3ec+nFKJ/KBevvm+bNzHoe8HowfPJYT4DWw3xZjuUFbzmRxide5K/My0cO0rFISYiWuzDaWiz99pHHsDfFftM7cwDJ4estmntedQn8LTp9znzYJxvzGOFCTHBB8hcfeJhzjjMuWFNtBAgeoAtl
 vBlj/gRf
 gIaTuU70AFsPVIuG3yKPxQ5gMp7WiHEMJAUKCAuAA/VPlkifB+fS2AO2ClH2FzVNP9m92IGqQM9O78qfI8LCuZtMxl9ybNu/LInT8SyO5+/UMuuPmPGmFFX3EvpvOLpLHsFAB08q9jQpxqhzER1/VxuANU4pst//3SpzM1uYGTv9XjU5smEB1YBcygtQEVxUZOoHk+sK4hbBFc5nFyzedaIHwtnfQkNXDMs3jueQDShmAaiT7wcuypiOX3cHhVA9BIgRdUl9FxkKjuBn0qjIqi63tpKIRpw9Fhe99/VYA9N0sNKvnJ0MYzZN9ekPXRvtbYdSCyMZepNOFExx94MoGdeEXcSHxr4DhFnCsVH/KbmFGlCwc+Fd0XnHO9FD8zLZlGgKGF0VRSPITkQS02WtQ280l6svD5jqLwabRE6A6uxo+bRwSzTuxt9DHxeMnfUe6AHBf8LDHNFaZwS/xNl6+iWDT1x/7qxpMT2lYKSKRorGsur6G/R/zoSJRYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/18/2026 3:36 PM, Uladzislau Rezki wrote:
> On Tue, Jun 16, 2026 at 07:07:57PM +0100, Matthew Wilcox wrote:
>> On Mon, Jun 15, 2026 at 11:52:22AM +0200, Uladzislau Rezki wrote:
>>> On Sun, Jun 14, 2026 at 12:15:28AM +0100, Matthew Wilcox wrote:
>>>> What I don't understand is why you maintain a separate "free" tree.
>>>> It should not be necessary any more, but maybe you tried removing it
>>>> already and found a performance problem?
>>>
>>> We maintain it in order to split several entities. That prevents
>>> interfering between allocated data and vmap-free-space manager.
>>> So in that case one context can easily access allocated data, for
>>> example vread iterator, etc., whereas another can do an allocation.
>>>
>>> So by splitting parts i minimize lock-contention.
>>
>> Sure, but there are many ways to reduce lock contention.  One is to not
>> take locks at all; the maple tree is RCU-safe, so you can read the tree
>> holding only the RCU read lock, as long as you obey the RCU rules.
>>
>> Specifically:
>>  - Write side has to RCU-free the objects that are stored in the tree
>>  - Read side has to trylock the objects it finds (and retry the walk
>>    if the trylock fails)
>>  - Read side can see a mixture of objects if the tree is changed while
>>    it is reading, but for any given index in the tree it is guaranteed
>>    to see one of the objects which has been referred to by that index.
>>    That is, if the write side overwrites an index that referred to
>>    object A with object B, the reader will see either object A or B.
>>    It will not see NULL and it will not see any other object.
>>  - If the write side stores both object C and object D in the tree,
>>    the read side may see neither, both, only C or only D.
>>
> Some thoughts about it.
> 
> Having the tree which is RCU safe is good for sure. We can benefit from
> at least in the: vmallocinfo scanning/dumping, possibly in the vread_iter()
> when access to /proc/kcore and other places(which i need to check carefully).
> But this is for read-only traversal.
> 

I agree. The RCU safe busy tree is a foundation that enables lockless
read only traversal. Will implement it in next patchset.

> Switching to gap-based approach requires quite a bit of refactoring and it
> should be a full switch without any hybrid schemes or mixes. I expect that
> we remove more code then adding because of some parts will become hidden
> like lookups/reserving range/erase, etc which is good.
> 
> - replacing free_vmap_area to maple-tree gap based approach;
> - rewriting pcpu-allocator which lives in the end of vmalloc space;
> - refactoring per-cpu allocator which is also part of vmalloc space;
> - vread iterator;
> - vmalloc dump path;
> - vmap_node logic(use gap-reserve to minimize contention);
> - and more...
> 
> To me such rewrite makes sense if we end up in something structural not
> just because maple tree exists. The criteria i would go with are: at least
> same performance level, remove more then add, the design stays at least in
> same good shape.
> 
> There are some drawback i am thinking of. One of them is maple insert path,
> mas_store_gfp()? First we need to find an empty area, then set-range and do
> mas_store_gfp() that uses gfp flag for its internal allocation. If we are
> under spin-lock sleeping is not possible, using NOWAIT or ATOMIC is not a
> case thus we should somehow pre-allocate outside the lock and store the range
> without any allocation.
> 

I am planning to have following approach on this:

  1. mas_preallocate(GFP_NOWAIT | __GFP_NOWARN) + mas_store_prealloc
     will be fast path. The preallocate attempt will be non sleeping and,
     if it succeeds, the subsequent store won't require allocation.

  2. mas_store_gfp(GFP_ATOMIC | __GFP_NOWARN) fallback: if
     preallocate fails (rare but possible under memory pressure),
     GFP_ATOMIC will make a non sleeping allocation attempt inline.

  3. vmap_retry_list recovery queue: if both above fail, the VA will be
     added to a non indexed retry list.  The allocator will scan the list
     on subsequent calls, and purge workers will drain it. This will avoid
     any leak or panic under sustained slab pressure.

Neither GFP_NOWAIT nor GFP_ATOMIC can sleep under a spinlock. The retry
will queue provide the correctness backstop to avoid GFP_KERNEL
blocking inside the lock.

> The allocator operation:
>  - finds an empty range;
>  - publishes VA that blocks that range.
> 
> those two have to be serialized among other writes. Otherwise two CPUs can use
> same empty range and both try to reserve them. If preallocate outside the lock,
> the "alloc" side has to validate that a selected range is still empty and only
> then store VA to block the range.
> 

Sure. Both will be called under a lock. Holding both under the same lock
is the better serialization approach. No two concurrent allocators will
observe the same gap and both succeed. In the next patchset, I'll
explicitly add a comment on the lock declaration describing this approach
in commit message.

> I think it is worth to prototype something to see how it would go. I may be
> missing something for sure.
> 
> Thank you for your input!
> 
> --
> Uladzislau Rezki

Thank you for the detailed design questions. This will make upcoming
patchset substantially cleaner than the RFC.

BR,
Pranjal

