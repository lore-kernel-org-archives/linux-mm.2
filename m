Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAED7C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 15:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F069D6B008C; Wed, 26 Aug 2026 11:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE266B0092; Wed, 26 Aug 2026 11:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6C56B0095; Wed, 26 Aug 2026 11:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B262D6B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:22:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDBE014016C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:22:19 +0000 (UTC)
X-FDA: 85143786798.10.1A6CCF6
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4EDD740008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:22:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b="GGt8II/F";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of "prvs=6698cfb698=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=6698cfb698=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787757737;
	b=mLhTj0aswvOg5+e/EVaERGTmbrsDWeQKZUz3xpbhUGVD+rSI+NsmGtIq+B35UzgMRoKOLw
	LA1y1Z1BtYBMtWX8EFvg3HIynyzvAvbG7GB2BG42ZOmG6kPowVdq9rH8E81UF4fRUbsFma
	QbWmytm3YMYD+bSTqmO8lRFrskRc/iU=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b="GGt8II/F";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of "prvs=6698cfb698=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=6698cfb698=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787757737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+LTR6BXv6tEKpHsIOyT7jkiT7z0eYW8jTeQ94/tcik=;
	b=q+YvmRwkB0/+H6u7EgM0T/PiKhAprv4idc6TfKJZGTu7uDlZM64+SjkmvD7Oj/hhznx+BN
	Ir0IWX9iRULRvOhHOlB9QUq4F0rTv9z84D5Uq3TpsfxRVwiXLKT0UeKPHN1V2E0umqHsUb
	ulH54CavzSuLiZa7tA+KQo/e8v5xx4A=
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67QEsWk92080482
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:22:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=9+LTR6BXv6tEKpHsIOyT7jkiT7z0eYW8jTeQ9
	4/tcik=; b=GGt8II/F5RNbHBYjWqojIIItYvtQEMLEYrsug/kfFhGNKrKzj82Uq
	KDNSXFMi57MLGeqsRz9Ca7l4+Bu7iPaghOzlfjesZMhfR2PkaoDDJlSiiJ6ClX65
	FkPv/KCJrS8kW2M43oGMUf2LV+KzHtZm6xTXtFuSK4D4I7LnqXUOkyclyhVOQR4B
	h8ELEvghrTTSwIWcRT2Pdv4eaAS2NQUUTKLlNsvdUlPTykd+U8GfjfcieYDRM47W
	PB1G4kVzSV7ArBAF7KE63YDlanTzyxKTpwC9/NUSlNLy1CmLmOZoHdLGQ6CnLAbe
	rRVo2YyFKKeXNdC6UPfZCpDohjuG9y3aQ==
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g9ce9rkq2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:22:16 -0700 (PDT)
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c20262b5e10so112020666b.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:22:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787757735; cv=none;
        d=google.com; s=arc-20260327;
        b=o4P+WoJ3kGpfJ04meUQSKivnraQmKmZUfElHOK3Oj1xxFZUR0z/MI4Ar628r+z+sRD
         F/QMNwEhBXPlJdvymJcIAOUV1mvWxHyQRf0MgDeWh9IaOSOvr9dhpfJ2fVjsvIr7JA8z
         S+StNxVZTaIbpd2yvO2LKYpy+/JKN2F5eULSpUDHi+KHL/2rlNAEuWLccHaDBoHn4mM3
         YeyvC3d12hjjjx+IA6PYfGsuEDh52DAViX72nwbEqc2dQyMzOiSMPC+A4qzEmF2IEFlM
         152Qt75GpfXrWQ2fRAC0iOzpxSfpRGzB/8DHFUbss8Wxhe3Z36yvYUveMUIb49p05V4R
         fINg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=lzzYRpHE4OUY/HCDzx2PwKyUvmKQFWNuBcWQsYBO99Y=;
        fh=VR8tTVhIwcVSG/II+oT1sNp/ba/H1zZuYB6A7Mvj/Rk=;
        b=XISO4VFWgF6eWePhqknEdFhnWShNxC0vH7Mo3FHVC8FzPeYj17zJOBGiE4Y0Qq6IaS
         pANyMAgOTMFZLwJyY6MhIZm+mnLS5956+2rGO5vQDRuNKtyPK7fp9TBLyw99TueXoF7B
         h0MZz75XCqFOmKf9VHsYjcAtU5fI31Ig/sXuNhIJm+XP6ElinuYldCyy2zz5QwOgVIBd
         kzawiFxcfD7GIRqwUHShhwSnj/kNmuFvheweEAGFHvtIKASSOlS15NSx17EUTnJF6df1
         x/5pwSem5KEeXu/U9xq/rqHMJHu+78KcLhGp884e5dRfi7X1GjeKXlgQKXoXKLq0eMcH
         xQjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787757735; x=1788362535;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lzzYRpHE4OUY/HCDzx2PwKyUvmKQFWNuBcWQsYBO99Y=;
        b=JoGIyQTQL9USlwsxsLe1xHDw+kg2c62RTj0UbTMPggzTzOGstYlfF1tBt7JMsXOjbQ
         kBhsFtsNRQ4nCqNe5UXcJrkBcfsCRCygGshLufHEkWresFaHM56sxdU/9ob9VXHOJINZ
         V7Fmub8NSziCh9q5ajjBvqHCHd8Q9UX6Qjy/BaYIjcigJoviwOlGIs9tIN5NrCl2zrnd
         ATdVAeKGCrzulvixmStw0c0RrHPTwx5Eif30KYvHlEGtcn2tMMYuOj94Uoz2cWTXfIVn
         LR1TCyOxqwaFzRJSailJIk5HBkUMw/HdPcHjptsrdSVaLIf8bk0vF9lcMxMDQRs7f50u
         YslA==
X-Forwarded-Encrypted: i=1; AHgh+Ro2Uo49CVVsYJgoS/0WsJBu++7UuoA32l6CvrK89Ymnhcl73NaK43lOMI+4a4C8qQXWmHVnXUhIRw==@kvack.org
X-Gm-Message-State: AFuF++l2VSOyrjpukI0nSsPEQFJGwCivhZFq1Dt1dXNixaotGgxx7WuP
	GHOCr4QAjLXcH3KbVIU+f3WtJZgdOW1zd55+FynPaM0Z2Dsm+W8JGHK7XCrICLVg4ZrFHmGoQId
	xVohcazaNJnHfYqzGi6C5dFyluPYS6UCaMyDexcOsSOK7ZMiFLTrm3f/hkK3suyMgX06nu2RPuN
	REdCaxQT3+5rYw5VVJo+grMqHpcQ==
X-Gm-Gg: AR+sD13XM/EuxeRLxLGNnx8lsLOA+5JYstDSxdaV1QVrHVbyDLDON48N7lKYt3aXyAd
	aJQG4pdX9kgHvxl/ZWvVK7n0Yyk8Yq1Tc5gVDYdY86rL7TWeZBcFD7U2uxxBb3skOMFCChEd74k
	KBXNZbdNPFQlESVoM1Bg8MgVxVUrqHqhWaLjmhqmSgLnr1MuSyLrxB4rcHhmfkSvR1k2CZPG4y
X-Received: by 2002:a17:907:9341:b0:c20:56e8:5457 with SMTP id a640c23a62f3a-c250baffcd8mr856850066b.6.1787757734948;
        Wed, 26 Aug 2026 08:22:14 -0700 (PDT)
X-Received: by 2002:a17:907:9341:b0:c20:56e8:5457 with SMTP id
 a640c23a62f3a-c250baffcd8mr856840666b.6.1787757734389; Wed, 26 Aug 2026
 08:22:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260825172604.3243589-3-alex@ghiti.fr> <20260826133130.806177-1-usama.arif@linux.dev>
In-Reply-To: <20260826133130.806177-1-usama.arif@linux.dev>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Wed, 26 Aug 2026 17:22:02 +0200
X-Gm-Features: AcwNN1VOI_k5zWxrGWx3SOcmXeyQASiKVcWoJt9T6GS6mTNv-MvRHMSAit0jpnA
Message-ID: <CAEmasaWvKWR_2asHtFdLYao7OboBmyXpbWVahUFWZJMRwGfkMQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm/swap: refault on swap-in, not in the swap cache allocator
To: Usama Arif <usama.arif@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: 7KTlLVsU5Aba3CfSrG1KKktO2WP8tIKN
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDEyOCBTYWx0ZWRfX2oNVcnZ/mHqt
 OCtRpLeF58VILy7T63nQAcE+/OqA+299cWBMnCMOxlSuk3k+DDYE/7D3uqWPIpIKF0DFV8zlkGU
 NGb4vpztE6UgotV/X1fzy7wR9DvDi9w=
X-Authority-Analysis: v=2.4 cv=aepRWxot c=1 sm=1 tr=0 ts=6a8f04a8 cx=c_pps
 a=jJvPsHQLKLf2UdvVr97r4g==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=GbPsI2Ihf5RTnMjR_gZv:22
 a=pGLkceISAAAA:8 a=e7hYlneb_oNGxzrjXg4A:9 a=QEXdDO2ut3YA:10
 a=q7aydO1c4wibL4nb3gNS:22
X-Proofpoint-ORIG-GUID: 7KTlLVsU5Aba3CfSrG1KKktO2WP8tIKN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDEyOCBTYWx0ZWRfX0ZIxo7rXlmAf
 2kHuJdx2YNMeIRiajNHHOsuBLLpx7ZMxyyM6LoZEcaYEuvAbt5Zb4W9U+CjkwlEKs03gscvyfKe
 99BSpnLcTOQ0LKIdcumdWUK6VodRbjVCihAv8EX4qE2hyAqoxuweL2lohf5+x+b5ual78Yne5ds
 syt/QaZhO63/8tkrlK5/9sU9dLgP6ZPXYsDE56d59Mb9veSZcJHcs/s/FBBBecL5Lksj3KNNiZf
 yRFJK1u4ygfJvLUUGLiMy01geCzoguvQP0Z1P0XLEnb1Sn1zkmOyNZZ0QdJMmOybwcflpXn9IKm
 MbfR7hCZlmkK3f0JMbnIZhy0lt9HE6PhZ7CkYnkYnJ0BvnWGa90DIEY+Rwq9uHw4nb6vXTIVhbj
 TpuvkVbF2bXMEaVQ19AS/ybVIza+WaXh/8q0k14ErwcDUWT8dvscBci5YbrsWdGD3W0Z95yBLe7
 OEdEdAJ0JuV+kmnSn0A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_04,2026-08-26_02,2025-10-01_01
X-Rspam-User: 
X-Stat-Signature: ai3usswptkn4siunx9r4m49uoqhygiqm
X-Rspamd-Queue-Id: 4EDD740008
X-Rspamd-Server: rspam06
X-HE-Tag: 1787757737-313061
X-HE-Meta: U2FsdGVkX19QBjPpVEDQH9C+H3OHJuzwd3xuaGlgwSHG/4/xaNRKK14kA5NkXgzeBNU7gm85mi6xKgx8Xnw/MSqPPv586p/3DoYXEcYXkPnG35CCvL2oz0VggFppZRWqwYWqSDXIPcWbBtXFr9N2QcAxKNl7Lo2DFNBCXlRuDkm1A0f39b5/Dyl5HQnrstuHnr4JraN8lE8K9BYRU3vVo5QjFXnfEs+TyFSBXzmXnE4NRf4Bbe9ZrPZpeG5fesLjvGCj2ND12U4Q1/+ZcXZUiMv3olVFiiLG+6OYBpwCunCLxR6d3KSPSwJnLG+dZkX/ccDllxjZzvvIuOL4AXzkzmPuI/eNc54p1sKqSf5yVF7XxBNjoZ0nWmgBOhqJG7av+OxZdmPet9N9IbxesIHjdYCs/LyAe0iszD96xa1LgBO6Rnt7ghXsunFoB5OqtQGmNDo85axXZN8tZWuTBY1N4+oCBkssmLG37NfVhwJvH2oViZRrb3Qn4Neha2qrm8eavlrz5KNZOd1GeLrXMHTeJKr6ihvm7G+6kVKh4oy3XdudJMFNWwl7zqKp1ARbe5nhf99tN1aBhaN1BsNSKUnTuL3WAva4KQjWTncqgB0wXNCaWm9azFy0lGkxKG3oreGxHK6erVpdklu9H5p6ASmSbP9qJIMkuXsURL3XlkhTzNaOwNfx7FvNWrq3ywl4UwRrhEMpFdia5Hiq2HY0qr4T754Oc7aYkpAaPHI4honWQD8wy+q+Rz4Xjt9LCiNfgint1Is9P+bwmD4CQ3NETjTvxf+qFn6nmFqqjbvgI/3YTtLDBj1owr6Tsp/rRVHB4s4V4rFc0sTRAkQJszpfwlFL56rqkrql4RixwOZEk1tw6CyQjq6Kc6Vybis0bYrGtngKieukbTCjQ/qUoKyxPo0GtEcvoX2yoFBQjpPmQOwzXcvvtcaAVwOx/Pqf50zt21cZFOmbF0ROV60GGuEkodq
 irnfUzxl
 ZgQrtkHtGnVBFi6kjxm2o2FgUPLKlYLzAYUni4+xmLrf6XtDAB61/a6mAspx8IgQPYPvCj0/+luMHxVexop7Ryo3BakahsS/Apr/PyhFzWtCxWXmSP5cUCSM6t1T7UU4aHJ1yLy5ztn4hB+D9+7Pu8ahIwy5Z8W0Kcm9eymfbPuk3HD3tYcHMbIiyHt8hvTU4trr7YoNVijiRUSPJCiaN64cSX331VA3a7MxzE8hkBESHpqTQhyHHVnmuNBrzF1d8V78dUG3nG8RMlVpHyMB8VPtabMrpTNJIwQWrXZoMp8HUF2VQDNkeoQ5MoihBKY8HDnPU/9IM9fvIZ77gkhqy8BXnZIPzniDgXg4ZVNAnHjABmZ43ZiHQWbhwG9wQbaBRxt3gbxL5BIYlSCVXGKLmE6278U1g+43Yna2GYCdLoeqHkn+eR3j2S38J648En4P58Wos7N0VeVEejp2zsTE7RgonhizKOxH78rhYFnnEJBt3ByaH4p9Aal2AqVjl0+MTARfB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

On Wed, Aug 26, 2026 at 3:31=E2=80=AFPM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> >
> On Tue, 25 Aug 2026 19:24:52 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:
>
> > The swap cache allocator evaluates the refault of every folio it
> > allocates.  zswap writeback also allocates through it: the shrinker puts
> > a buffer folio in the swap cache to write the compressed data out, and
> > that allocation is then counted as an anon refault (and, if the eviction
> > looks recent, as an activation) even though nothing faulted the page
> > back in.  On a workload that writes back continuously this inflates
> > workingset_refault_anon and workingset_activate_anon substantially.
> >
> > Move the refault evaluation out of the allocator and into the two
> > swap-in callers, which read the slot's shadow before the allocation
> > overwrites it.  zswap writeback keeps allocating the buffer, but no
> > longer reports a refault for it.
> >
> > The refault is evaluated before folio_add_lru(), as it was before this
> > patch, so workingset_refault() still sets PG_workingset/PG_active while
> > the folio is off the LRU: folio_add_lru() consumes both when it picks
> > the LRU list, and under MGLRU when it picks the generation.
> >
> > Fixes: aae466b0052e ("mm/swap: implement workingset detection for anony=
mous LRU")
> > Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> >  mm/swap_state.c | 20 ++++++++++++++++++--
> >  1 file changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index bf8ff2d2dbf1..8046fea015c9 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -483,8 +483,6 @@ static struct folio *__swap_cache_alloc(struct swap=
_cluster_info *ci,
> >
> >       /* memsw uncharges swap when folio is added to swap cache */
> >       memcg1_swapin(folio);
> > -     if (shadow)
> > -             workingset_refault(folio, shadow);
> >
> >       node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> >       lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> > @@ -646,17 +644,26 @@ static struct folio *swap_cache_read_folio(struct=
 swap_io_ctx *ctx,
> >               pgoff_t ilx, bool readahead)
> >  {
> >       struct folio *folio;
> > +     void *shadow =3D NULL;
> >
> >       do {
> >               folio =3D swap_cache_get_folio(entry);
> >               if (folio)
> >                       return folio;
> > +             /*
> > +              * Capture the slot's shadow before the allocation overwr=
ites it,
> > +              * so a fresh swap-in can be evaluated as a refault below.
> > +              */
> > +             shadow =3D swap_cache_get_shadow(entry);
> >               folio =3D __swap_cache_alloc_folio(entry, gfp, BIT(0), NU=
LL, mpol, ilx);
>
> Can this refault against a shadow from a different cache generation?
> Another swap-in can replace this value, reclaim its folio, and install
> a newer shadow while this caller is allocating.  This caller can then
> win the locked insertion but still use the older snapshot.

I agree, you're right, I missed that. Thanks.

>
> What I think should be done here is have an optional shadow output to
> __swap_cache_alloc_folio() and return the value captured by the successful
> __swap_cache_add_check() under ci->lock and se that output in the swap-in
> path?

That seems right, I'll give it a try and report back.

Thanks,

Alex


>
> >       } while (PTR_ERR(folio) =3D=3D -EEXIST);
> >
> >       if (IS_ERR_OR_NULL(folio))
> >               return NULL;
> >
> > +     if (shadow)
> > +             workingset_refault(folio, shadow);
> > +
> >       folio_add_lru(folio);
> >       swap_read_folio(ctx, folio);
> >       if (readahead) {
> > @@ -688,17 +695,26 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_=
t gfp, unsigned long orders,
> >  {
> >       struct swap_io_ctx ctx =3D {};
> >       struct folio *folio;
> > +     void *shadow =3D NULL;
> >
> >       do {
> >               folio =3D swap_cache_get_folio(entry);
> >               if (folio)
> >                       return folio;
> > +             /*
> > +              * Capture the slot's shadow before the allocation overwr=
ites it,
> > +              * so a fresh swap-in can be evaluated as a refault below.
> > +              */
> > +             shadow =3D swap_cache_get_shadow(entry);
> >               folio =3D __swap_cache_alloc_folio(entry, gfp, orders, vm=
f, mpol, ilx);
> >       } while (PTR_ERR(folio) =3D=3D -EEXIST);
> >
> >       if (IS_ERR(folio))
> >               return folio;
> >
> > +     if (shadow)
> > +             workingset_refault(folio, shadow);
> > +
> >       folio_add_lru(folio);
> >       swap_read_folio(&ctx, folio);
> >       swap_read_submit(&ctx);
> > --
> > 2.53.0-Meta
> >
> >
>

