Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D1A3C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296A96B00E6; Wed, 29 Jul 2026 10:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203466B00E7; Wed, 29 Jul 2026 10:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9FA6B00FB; Wed, 29 Jul 2026 10:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD52A6B00E6
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:32:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C5D6405E2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:34:20 +0000 (UTC)
X-FDA: 85041152280.03.08E14D3
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3346C1A0004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:34:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=mfmw4weW;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf19.hostedemail.com: domain of "prvs=667098ed21=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=667098ed21=alexghiti@meta.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785314058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Trtz2XPNLC7KoZV6jg2uWSprqh1Z81NyKjZp3w6DGEo=;
	b=vje17VM0KSo/R2fM+U41chy1Jg+kEFjw3knnjoQacReZaIRMd6bMxRyLOuFn3YmWjCRemQ
	5kPEdIbgGfGk/1VoNM1enbjBFrHuHH+CIFx6FHF9EN5NMzhZyCpU4gurBEp0yxuP0XjTxN
	HHhd3ZOgt8k34nQN/dwD7B4TIdWSHMk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=mfmw4weW;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf19.hostedemail.com: domain of "prvs=667098ed21=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=667098ed21=alexghiti@meta.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785314058;
	b=BADqacS6r5jrz4xI6FlKz8JzyxapRJc1+Bcy2XmcsFwIdErC1FCPcJ8KE+WVQFKXMdgW9G
	pa0RQTpxhKzKdAi+fAwdrIHA2492OmH2zsWqytTLt7BaE9xKGjzzJebOUMlh2vvHj4JYHD
	JqfCju0iSlgI0sKgNKT4sKzWXTl3Yrc=
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T7awUa2554794
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:34:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=Trtz2XPNLC7KoZV6jg2uWSprqh1Z81NyKjZp3w6DGEo=; b=mfmw4weW4jQy
	WoRdAxfmX5Q5nygSUX/2hoIKuMG//IV0hJ/EDU/elqsU5U56Dg5Ci8Is80mHenhO
	hIS77I/lqZAavXRIDgaLLiN/QpmrattOzgQB4tp3nuSRLRLxSQne2m88LxG/izNT
	pqwCIwRtMZKPbqBKPeamqsntpKWM8BqV+zBlNt9LlvhBPeVZLsffIVGYrEty0uR5
	woeocC2WpZbpUh5xXea+IlimxptkmTFExxjyyO8eFaTmki4UslEJjU41AEalJYPo
	y0f4Y1i2y+roMCiyK0Ckp3cCYomOLIQalrpFpZn3yLN7Xlps1nQZOnUMbKYJ2767
	Zjw98Qx3yA==
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fq14n50as-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:34:16 -0700 (PDT)
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-698c15b962cso739667a12.2
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:34:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785314055; cv=none;
        d=google.com; s=arc-20260327;
        b=k7w1Z8I3D5wUT1GKJaVhpleANsGYihG42gDVgVNCZenqEpQEMYpCfWwOcvCG/+uw4T
         ClKenrSvzhNGWa8acaebx04qlWtRnHY++zaVxlY325JRIwI1YfNEMeeJn/k5UCxov7gn
         Nw16XT5fDguJD4x8fbIk7vYk1voY5jL5/CNXX+eeF1c4JJnNxket5AjXOj5b650l8blB
         VFAMZg0RA1aTDyHaaa4i+UlUT8Eq/wpsUVkIL08ggh100SG08hz+Vw7gRbA3Ky1BhEB8
         58Drv6ARJbDVfeNxbm+UGzuxChWqxP5M5EmF+U+o0u6Z1Z4uHRX3urk4r/cxK/fPjFde
         x27A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=fuEIQKIblYBIfpn443b/vHvFxKnCDuM2Hbu5e3yS3wY=;
        fh=YncXUrn4nCsJvlROw00ZLw4d/cbyyQRVR5mMYmcfRbQ=;
        b=ZN+guNN/6V/Z99DnVUzUjv1cZlGk48vAw5kJ5DY4ZBMAyr4Fz7IN0QIR4ROiyZpbrb
         d8OjIblnh8hkQZDjZF8FPvUm5x92gjIG6OnTe5gDQhqPyVYMh9YlDQZC0lQqy0cKcUtr
         UxUQfNzzFfTkfvW9IuxFG6ISYEli+XkeQuvg4pPmFItzGfdndty649TqRD6BkTRw4tNz
         X+Qt5bK3FuKCb85DS6CHbUgy8CXOsBQ2SKTt14BQQ7YqIOrzoarNRF28LATwaRM+Zg72
         n0CirQJu9gsPi6m/kZE6j6DiSwGU4TDXztt+b05GxX4slczOdgof8tfbJpQkYvaCM6yM
         1AZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785314055; x=1785918855;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fuEIQKIblYBIfpn443b/vHvFxKnCDuM2Hbu5e3yS3wY=;
        b=CdPjTyriQCoX4S199fcwHsMGsgyacxyRgoJqOpSHP4ZVVMqWufYIY42MXDquCBaGH5
         RjKb7H/WDZUWeTdTIqTOBH5TFbT81FZQOMo/MnFQxFOTIOmhGpS7VqYzQINLJb/VwwL1
         ++1l5tBuE8fYsVhA2Bs+3HSlu1bUYDYJBjT0b5hXXYsBdtnkDiE1nrqY+DBK7JsHUDSi
         I5JvWmWbh8uCzfq7KCQoGDqYXe7/kHgjYzjzogO0JJYCr5LDfsEt25XC3gPp4QKP/Q/P
         ttae0LfLHFDQtuCz5UzDZSQMm7UTbeDIuQzexlOJmM3mQ1Ab47lxkutVm4qQv/vKJQ8z
         I61Q==
X-Forwarded-Encrypted: i=1; AHgh+RpcN58K4kyeZbCoo8DFCzzInz/ea/A/AqBnQafaumoUlpRjBZ5AIHSV8paC9ylX+J07EFOvMzoXVw==@kvack.org
X-Gm-Message-State: AOJu0YzVrZfQ8SRJFEorDk97O0A+zrUstB5v8U9KwMT8mvI2UWWSlR/M
	Ew4mIE9DK2t4iXXEHcLiciHKjXeCXLC1100ldCeIez1VWKFImRi3jyGigsGPUjzJAF0MrSxOz9J
	8xRDKZ6rkVIJgo45hhbgepPYtzBm2o5ix7kmnED89Y6nYrpOvCsCO72Ja7JW9lc1wWOgkPQRMSB
	RLUF8q7usox9NeApCntsVRXcwdKg==
X-Gm-Gg: AR+sD10X4GJdNqXoXKxP3VEY8u2EWxU9k9aTyWnjC1Lr5efH4bRuO+iyVioVfmNFQIZ
	e/H9PBYYpdJ/9i/3TSNKKPG3T4fNZJIMImiyyhSrTKmc++4dHmtcf+ZjRuD0fzFQtfsCfXNqIvy
	/oLipl28s41UW68eUZ/GjPW8j3Ayj1jLPkIdY8tGiGL4Yh1nmsVixqvc6/xb/w7MRk+365mM9kU
	fq9Uh6HTz7i3XAGOA==
X-Received: by 2002:a05:6402:2b8d:b0:697:f6b2:a94e with SMTP id 4fb4d7f45d1cf-6a0349f8f61mr2915397a12.13.1785314055563;
        Wed, 29 Jul 2026 01:34:15 -0700 (PDT)
X-Received: by 2002:a05:6402:2b8d:b0:697:f6b2:a94e with SMTP id
 4fb4d7f45d1cf-6a0349f8f61mr2915363a12.13.1785314055197; Wed, 29 Jul 2026
 01:34:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260727143618.1582318-1-alex@ghiti.fr> <20260727143618.1582318-4-alex@ghiti.fr>
 <CAO9r8zNJ1cfCVgxtpqx4Db380bjZ+Z0P842eAxPXw6Mh4XBrww@mail.gmail.com>
 <CAEmasaXR5EmGCv3T5AzM_2908R-VjfMcObrACyVGokY2U=+i+Q@mail.gmail.com>
 <CAKEwX=P5G=Ckafy6fm9ws3njWP_Zm_AHRKOFERScB9Pkd_KvGw@mail.gmail.com>
 <CAO9r8zNsZUvMknjmH7MvkQ=09DnB9YvtYoA0ei5Hj_cESQAVPg@mail.gmail.com> <CAKEwX=MPPEBBepeaJtvZUZBJL0KmP6zGevD9HqTiUCKO4Pt_Cw@mail.gmail.com>
In-Reply-To: <CAKEwX=MPPEBBepeaJtvZUZBJL0KmP6zGevD9HqTiUCKO4Pt_Cw@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Wed, 29 Jul 2026 10:34:04 +0200
X-Gm-Features: AUfX_mylvwT-a_Iq9J_Pzrl5e1_Hilm_Ktb9JmucbbE5kH74CuZaqKgFv6dnS3M
Message-ID: <CAEmasaXKFkyo8q7Or7DEeLYacptozw4RtSBGrPLChbpQS8UMCg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
To: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kairui Song <ryncsn@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=aoqCzyZV c=1 sm=1 tr=0 ts=6a69bb09 cx=c_pps
 a=CYpx6mtW7qE8U/l5VCnCPQ==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=8elwO82fXORLTBIkMd32:22
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=AMAE7NpZmBqY-1WNrTMA:9 a=QEXdDO2ut3YA:10
 a=22KAYETGZJnyhCxlFjxL:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA2OCBTYWx0ZWRfXyM23DkAR8xnz
 Y0NoiSPWHjJtDtRCAkXoCyIGY+hLazHxw4J8C4ID+/LFcs3fn66ekiWN0nxfbj00H22KAR2ATyD
 IAHMyJ/hlQ7rWb+yMgFuvS4rFCRgCkc=
X-Proofpoint-GUID: PXu874WEqFrgoogC3BKSZD5IMxCGYrs5
X-Proofpoint-ORIG-GUID: PXu874WEqFrgoogC3BKSZD5IMxCGYrs5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA2OCBTYWx0ZWRfX6hoK2pqPAgGT
 P+Jpoo3JU/3pyNXRs8xEZOb5/Ccvrh5wbpWP1x5Fu5qeHazHh5WQzcb1T5PzyOKIY2I5N7pjGC3
 AFM6Ris17WpSZM4KJlClm1WMLIQ+gQeNflufcRYfURTFMdT2ZiHctu0x+nptk5hDrpcZI98rN5O
 qwZWegBLMa22GzlevhpcDxBtrVmJQLQoEqH/9pPELNi9FC8qHYZ8M5vRA0Jb+CeEJyHWjWd6wsO
 eDPp4j68rvramoI2PfeRfLydm2N3zAB8GY3H2x7iAOMzGsRAOOzQaEDjZa1gIhCUS7i26aXIb2A
 HDw3hm1NcMh1EGgFQPaT0Wx9G3rMbU2B0eLd56yzPZEyjje8Ui8x/LtOuhFkigcWgcLxAf5je53
 coWyMdcj6bwGdUViYEbsKIyEDDZFsinSUqeMXZ3d9acqa/N3Vyv5pYoL3VXkx1GQIZmcuXukgbu
 Wg0jAQM7cvc+gg7lZJw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3346C1A0004
X-Rspam-User: 
X-Stat-Signature: ekxc4wtoucqeami7jzqqqcat7zn87hm6
X-HE-Tag: 1785314057-837923
X-HE-Meta: U2FsdGVkX19P7e+9AAYtUHAmd8nAIxHlW7R6oxq/Xp1y6AWP/T4nemxMc01LPj0Y5WTKGSnmlI+TZSF3rpg6FB9kj4kwh/uhWnRsSO9zpwZPD78+7+XKZk5MkskmjWauhcCsHemitcO5gEyperrabdtVczUI231eTWesWf/V+tFrr0LBGWsbCOvazvQOFmixS+O/blLJObvS+nuNCy3nC4Z+pObwCpEFFAjko+p2GCuYDvLr2CC/uqnJKFzYCo+1aPU7MDbnFw4CTSzcBsqOhQsiYaX2nZgZiw7qeBuEZzlZCLjybbBIgBwY3+VD8JuolhYXZmf+rhoTe9HL25PaH5bd8tHUx4kCz+iYMSwzemGMh7HZJNTvkLvNW767rSQS6bDcCTA8eV8/fZtkrF+A2fdtDobKd9SZiFOdKcoBTpUJ38CtPlOOb3fHoFPvHwK64IOv4tJdCKOuB24zm7m5/0R2eNVvYlmqBLa32ogmnflhvm2HH+ftyJLtw7LUY9jcf6N56y/WNLcG9em3z16fNzc3Zs3X8p0M1UhbK8pm/u0SRNrASQKlLxONxncgu1iSs3qcpff3isoZYuWJqAmcizzAn9GrFfcICMFKtQVILTuQuLPnWV7FaZRA5YbnQuNgMDNoYWflGcVNSaebju8Ga+eorBipsRvj7kH6XzGBvME1YlbYPpL13Otu7gUq1UXm8HJdVDQd3GMpTiPHV6g8Fwxx2yFwYB1F7DP5wbskCJhamNJ7on6qj/a8cgOkfYOgARwsMqarrPKUBBeLe95k9UlRpjdSx9S1w4JMj3zIk/hDejGzhve5PCHYZNKJc3Z8iXSc81rqxv3XMliVmgCmTOckb0oht1i+Sd7Xbqb0rj7lI13Jqsz1QZAxTsp2B6QLhVVDBh9AqsosEgrvfq5s3Onz4W80oCp8nQFThuRZwfgyczXbm8skDxyxIupipit99LDBWfV3FDUhDnFlxSA
 lnjQG4wi
 bcPbStJMq7u0QfLSl6wpnDH721RiwajWH1piwFLnLGL77nLKVGF4Q+c3/ai3qP+iD2BLuMq3Ooq/uOfpdy/kmWM4vqpPrqbTJ3gfzTsHOIAqlcNCLgnm2uU+BeHUsk8mxGVKyJNS6+Bo0Dhqgafx7w9vJRcmenPm/XtmmmecgDR8v3tOagUJQ5TK0GOxgwWOIqRueD5II5mvHkkIvRMp2o6F8yuP8/kfGuzMGsYinug3Uw7GiRRXmt3563WvfkBOOOLv4O+JFPfGX44V2C6OYIo2OEQUplbfARzcCSg5x7bpgIe/nm1uQCdCPWHDO5WzYGF+B25ksBwq3pVCRdK9aaa4Y4e8dD6HvF4tf7dMBkId+ILMoswIJsWEuyP5uvd+BzBTTmdoBT89dssCnJcyAbJLHhC5eOfvWC/LwcLCU3F4YVt3LJSqUZlzlIYF1bXwbxDvgJOTYc2xj6cq6fQZ6bDYSbnWjVb7q2+kdSITzabGjiPyi7m0l6x1cMj780fBccQxniwLMWEfiNUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 6:13=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> >
> On Tue, Jul 28, 2026 at 8:52=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Tue, Jul 28, 2026 at 8:48=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > I don't think it's worth optimizing zswap + sync backend tbh.
>
> Yeah that's what I'm thinking too, to be completely honest. But my
> mental model for sync backend is zram, so I'm not sure if there are
> other cases that are interesting that I'm not familiar with.

Thanks for your feedback too,

Alex

>
> Normally I just use zswap on zram for correctness stress testing :)
> That set up fishes out a surprising amount of bugs.

