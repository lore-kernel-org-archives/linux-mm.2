Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 760D3CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2636B008C; Tue, 29 Sep 2026 05:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88AA16B0096; Tue, 29 Sep 2026 05:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723986B0099; Tue, 29 Sep 2026 05:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DE796B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:16:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD141140440
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:16:19 +0000 (UTC)
X-FDA: 85266243678.30.ADBBB75
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf31.hostedemail.com (Postfix) with ESMTP id 64C6F20004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:16:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=KWF2oOLW;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf31.hostedemail.com: domain of "prvs=8732277d27=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=8732277d27=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790673377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXOt0DR/qucJrjzcbWN633PqrJV6/4ZYqTTDG6UnQU4=;
	b=WejucaV6HjMaKz7cJdvy26aGzFMaijGSm16X4MSk1bqgYexAyFR/Kd4PEs3MPmGPXBaYjs
	mQytsRZWugCCvoG7zelm2DBnpkY3WaXe63AU/xnjIsEPbjSMMsZCZ45tE7BZbcR1ysKEZK
	/DDSkZG6ARX62iFlzZaHdCGwl8X/x0w=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=KWF2oOLW;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf31.hostedemail.com: domain of "prvs=8732277d27=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=8732277d27=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1790673377;
	b=L+IDCPeuLOQA6qFWMtVs8/tVBoxDQAUkW4AkBhIhtTNk4S5VsuA3g4FR2v0zXq47n4utTi
	PMNqnjwM2NHKE7wrOmUqfaxNZODPFOoKYPf5TrzPAhc7vC8q8pFupKDxu3yXnkSmr8StWw
	+p+HHTZmvdaiv85f8x0JaJ8ctjylwCA=
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68T7TVsh078085
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=UXOt0DR/qucJrjzcbWN633PqrJV6/4ZYqTTDG
	6UnQU4=; b=KWF2oOLWZqV0qtVOV+RAoOj/bKInEHA2dCJiDhdsxUn/NCwq6IWJK
	Tz9cgDhv3tNVxM3VJLUJOe4yxCcEK+JG2p7LZE30TQ6S+jz4iogQ/XPcGPCUoHpl
	n2OZjxjDadiP4BLSbClNOosKwfwSyLfPFHvexb8nKGF1xK7HnOT/hpbdziidMu0V
	eQXF2tvCjJaQ41VREWyRlkPJTDNG+C/OAxmLb/QCFg+CQzx5lSmaJozJIeLxDsN0
	KEdLb0JNvn4tAmjuRaLLGTRdHr5jcwsnR4ZmzY89fKCoj2cdHLguRjp7XGPQw5D0
	PTPMWHscS0t5Gai/UfjzDBFfpPbvpuoUA==
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by m0001303.ppops.net (PPS) with ESMTPS id 4gx9q8ud2n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:16 -0700 (PDT)
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c29c391bd2fso366218366b.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790673375; cv=none;
        d=google.com; s=arc-20260327;
        b=XCjJMrRanTchFXYykAzszbj3J0e/JuBWvbEICNAVD9dZuQ3eth2ojyb9tU5+FEFrr6
         J1RceddLpcn+htFZQ219vgZ1G97mzopkxRrDdRje7s7oRwgHObawCvT5iQqMTEB4sf0U
         IBym5l1dtVlpawyQAuueBXhDHC9Qflls1sLqqadAlTV8HKEui/IV5uAnRwmAlmYvE8nm
         EYZBIuwCeEwckIS5Ulr/YULOJqozwh8LuM5BhenLZ+NreCxP9OQYR/nZHjIO8lIdkDW3
         kUmmY94UnRqbwbQBL0/I5jgwa5Vv8r2PYZdpGYc0arQx2T5Ddv01bR3MARRI729FfJPR
         x/og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=RutqN0XzeZ2DQTMI7Gduqm3yztWbS2+NpNwUibf3R/c=;
        fh=juf+KRGqQZCRu991KI6+f3JrvoFsbypfflKJHdp8t/I=;
        b=bh5bDp9GbtRdrI2EAp4EDUlz52weVbo3+C0TI5P/sWg4LmKh2M80yNxYj7LFAmrs+r
         zQ/wzU7L4hTeZe/jysyNohktgZ7aT5aK0Qh+oyDcYtdoQiN/XJr0qH1APf7zfg6m6hEc
         pzdf45URyHOmUQ5IHf00b8MfDYGN88MRhrB7JpSQSqKpNQ+QSPzx8IscTch3gnxG/Sno
         Bn52O+kJmB19ZUP7ifV1fFPTxg1AX1VqihOtySYjT7vfnBm5Z99BjRySXqExb0KZhiWD
         JvRd20h/Rtee//2mMV8SO+FUcpx2g7CCKsP6gdrolZ595pw2mKk9dNF2rbWhLp0jGp2B
         LfsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790673375; x=1791278175;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RutqN0XzeZ2DQTMI7Gduqm3yztWbS2+NpNwUibf3R/c=;
        b=JK8+x9fXjoxgfXO4/WbkSWxuz5FbBZPBPID+HC1JryDZBoFp/4ciMETW3tC17ualCF
         hB3KSF5fpWSaHeCOguXM++/08q6z+ASKzNpRqUQcHhe3j8iKJp8RV1A8OPsilURXRNk8
         GUg0X4Lzc7ghXTSZI0Sard0U10N2qip9UEnPBn4Cc0hRcvB265Fr4Jwi+9PsNSFonWKU
         kLLdTZze6VyoOSLeFMyFm8CAgvCZ/Vc11H53HEaj4flzco84u2MWuF+/hBs5HbMVoZb7
         7dD2iP8HNXiWdphNuolVbJOM5PBCcLPBLUbvuibOaVuzbQ8w33JrDO6GzomLLV8WvJCe
         8ilw==
X-Forwarded-Encrypted: i=1; AKwUvBwTy5BXp3hIzG4e/IGVa2rPugPw9kRs5P+EZQUJvgIAJkQ0yN5Rutt7898gzhCxEzmlFnmWwsk8YA==@kvack.org
X-Gm-Message-State: AFuF++mXmZyXd8eh+3wGxPbd9I2gYTGrt4BcXNHhwyCdx5tyOxvV0ARr
	sqvtAdOZMwQjBJaeqUYLfCY3ZzPSPOKDbKwncuJTjPzJ2qKSCI80YFtOw4KLNtC+mnT9oVUgYo6
	EiMTJvR7+mc89D9pCZ6yCansseI0jHo+gD/lfeQ1WmJnA3/WJsbodPXYPRB8TaUp5r7NDh53Wxe
	dt9DShifWPL/3n26E9pI2KVLKq9g==
X-Gm-Gg: AYBFou0dcjjSV9ruAdIMi4yPpAxruzruagWv2qknDp0IxrlqIal7CX42R7ta7WwwzE/
	r1sBjN9e0Z7MbhKIk1lWP/wUCTSOky2P+vAL9FdSRw708g/RVrZ+Eml/cSGrFi98mq7NuNXvauE
	dwjVqQfHQ1lCq9zxi9u8UjFLHYc8sUMz/069ZqGY7r/8C9/gz/kfL9ntEI/jtZfQ67aPJIaaCU9
	lPdJE/DWwR8QW6RUg==
X-Received: by 2002:a17:907:6ea3:b0:c26:1649:47af with SMTP id a640c23a62f3a-c2ac53cb0afmr1291012566b.37.1790673375163;
        Tue, 29 Sep 2026 02:16:15 -0700 (PDT)
X-Received: by 2002:a17:907:6ea3:b0:c26:1649:47af with SMTP id
 a640c23a62f3a-c2ac53cb0afmr1291009966b.37.1790673374768; Tue, 29 Sep 2026
 02:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260928081900.4187482-1-alex@ghiti.fr> <20260928081900.4187482-2-alex@ghiti.fr>
 <aro28ZGuYgmNg_n5@infradead.org>
In-Reply-To: <aro28ZGuYgmNg_n5@infradead.org>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 29 Sep 2026 11:16:03 +0200
X-Gm-Features: AclHuK-D9BofbMEsWSFPaoMRP_iu1F-Wj4thWHCh7PID9jFqkf7sbSb8Hc_0i2s
Message-ID: <CAEmasaX-6v_EpwAxHtnhA5SXk=jGW8+Lm4m8zAC=+f0yXmiCxw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] block: do not issue background swap bios as root
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        david@kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: oXks9cBiV84fK6s9Gpnm7Yfo_qx0qs-Q
X-Authority-Analysis: v=2.4 cv=Oc0NnRTY c=1 sm=1 tr=0 ts=6abb81e0 cx=c_pps
 a=Ak8bExYEjeps3Jj0Zi+cTQ==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_78whYxrdx1mplLwxq1U:22
 a=JfrnYn6hAAAA:8 a=gdocsb_8Clbhv9H3gegA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDAzNiBTYWx0ZWRfX+r5uoqe9RjEd
 AhIo/7s4CIs1bzQoF3PUEoUzmzkMOQeImm2UWghi930/Ct0AuQVwv0GNEgVmt8jPKjKHkXzsXrv
 89dfuW5dv/k5YRMAfhGc2CS+m6pOpsDLbULIqdKYLsjwE24v7HYgZevy670fDCZWHUmWsxjqERV
 +/FkBmPH888+S7qtGfJhNQevIQyOWbWluD2XKGA7ju3li/Xmd7j9IcnGjkLfPn+jiZAWX62AAFO
 XszPI4XtfP+9wx9vOHqJyY9FBzDYMJm1q/y3xoERYrMwd8EpS/TGd03J0UPZnEIlgi5P5G3v6od
 mNWV38sUi7rYleWGE0BVVvSgWqqLyq7Kdo180AmDe25PlBCY2nbb82+Xpf+Hz92Qr6DU8ZeelKp
 HUvwh6Y9IVybRPdd8zriVFGacF5AnbaBRAJbkkEmphyR9rv2TTj0Tpn+BdKiWadClWaI1JBZ5q8
 ppjHS8h5qsj0jnw3Myg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDAzNiBTYWx0ZWRfX87jEwPT/ZHT/
 0SCFg44Ifh3o3iNfmjBsBFyNhwzOhzR4lG52ohiXTxZiYqXP31NFE6NGdsI0K51m5mA+gKphNNT
 RehZYfbdCS5j4093CeQyt0m75gOLQ4k=
X-Proofpoint-ORIG-GUID: oXks9cBiV84fK6s9Gpnm7Yfo_qx0qs-Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_03,2026-09-21_02,2025-10-01_01
X-Stat-Signature: 87fbuut95x4c68nb7bximtm1tmgr5s3a
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64C6F20004
X-HE-Tag: 1790673377-508983
X-HE-Meta: U2FsdGVkX1/qmRPVC24qyKsepG+sHrXRsUoam6ozpY2qVunPiX98jEwpyKAQWYDL5dRSUebJJcoT/4pCdFuvsR9CP9Vp66Z+7/8wEMDUYIaIxYNZhPT6HxDv3z/ah+zPPiLWXwT6ZdHQtgbTGngnBxxR/cCpzrbGXM7FOP6bJXdXQxUUmHwEUzEP6IihYeEjMPEBDEQGD6uztH9H6dnWIDUdlVyicTmT9kQ+pTAjUMv6vSCz9K95ZPSgwDNvjhhGktkMigI7ibePAWsKiezHrtyGfEjXGYI6TSCUi35dbbfofMt/y5CvMR99JvXn8blzNDeSUJSedOfBrb9RhXKCIi7k9Q3wA2fCrPXwBpHrm0H7EOy0kOD+I6uUAIdCx0ZFx7gcM0H4mhxsrGaH/Lq+3oA6yjhi5+vat0V4G7pSmsdXNIAeVxyj6yhwVlElSnI5Me1MvHlq7sksUs7kbpldsXuwKlS9v2cjOQCCzN807by0WSQ14iDMdkqdR5hsDA10jxHkRu9oiXUgPOXmvXcP2H7/vxiHa5jg0Rhd3jN9AZZ9I6m7BR+9VYT7hyQfTTOHEide0zl4Ys0W9ZusSUGJhmLLqXv9Fq/Ka+UVr7+3mFhNRU9dsg8G9x/w58gCLBcFUGfUlf+IqlmrFpvAvpjmdO3H6GRppw3LBPDALlDZCMYQoJ/NqTIIIHhPRmYoDkKCcBCANZO0W5Q0Ds7XSDm+xIfUu88ImLWa/QFJb4rh+aHkxfQBoI+AUyeQMLVcYhe/9oYhXY6zco8O2792LhCvO1jFI3WkchdmBKesnx1CDV+uWSIaI0Gf2rIVHJCOk6dd0bJqpyJOyq5GXXcAwBJK7e88HihT5zwqTV2OCH9nOXLF8TRXtUmlD7KyDniGi5FpGaePu1Rladdo5t2gw7/zCNRZgkOEtWR33Z612IorAneAzLa1iY1KS5knEdI9F4jmi5KHFbZ/e+Pi7rUAoUx
 6vGjIYh6
 TJhnQaDluYsOcTcJQ64V3yvNHIFi/3d7KByyMCHBDcI9T/wOzr7IzUzPndXuLYRKPyLPfr5Lhc6A9eGwkPgIWs7Iza8nWQVPDj+gUs4XwdXfKQqFsRTPR/wFBSR749RSK5D7hR/21IcPOH3Lgvs29HUkQkdJfvONQ+gotNtUZTs0Q0i7bFRPLnfAD/oJwW88cNkvKcpFHBbVAAsoK3jv/NS53SOUld1+cfUQR1HGVqhUaKx7bMciNKmAb/IIQKFf/yowiIkP16lvGx8c2v8dquCLXcRe1KB+PoyLWzzR+njpC2hFH3a1zLP3jOfIEAuJTokW6N2BWRUwH+fuj/aa2YDJn3rjzG05FNyjKe16VDZeH8rGkYSLFzu9pLF2da6cs0YzoTtPQMocZIi+Us/noHLMKWxipaW71Blv8Oi/R1piu2gcJDC9Z/cMS8kZPFEuO4hlb2s9XgIexVY9cf3TuQQiOMaJSSXsGEHgDT6lf2EqLl9+dhn01ByYSaXplkI0Wslz9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christoph,

On Mon, Sep 28, 2026 at 11:44=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> >
> On Mon, Sep 28, 2026 at 10:18:36AM +0200, Alexandre Ghiti wrote:
> > bio_issue_as_root_blkg() issues every REQ_SWAP bio as root, bypassing
> > the cgroup IO controllers, because reclaim cannot stall indefinitely on
> > swap writes. Some swap writes are not urgent though: zswap writeback is
> > best effort.
> >
> > Such a bio cannot simply drop REQ_SWAP: dm-crypt and dm-thin rely on it
> > for limit_swap_bios, which caps in-flight swap bios to avoid a memory
> > deadlock, see commit a666e5c05e7c ("dm: fix deadlock when swapping to
> > encrypted device").
>
> Is that true?  REQ_BACKGROUND very much implies the I/O can the throttled
> and thus better not be foreground paging, and thus the caller should be
> able to tolerate a failure.
>

Yes, I agree, zswap writebacks are only best effort and in case of
failure, the compressed entry still lives. I don't see how
REQ_BACKGROUND could be an issue there?

