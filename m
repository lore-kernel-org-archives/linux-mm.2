Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D82ECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 13:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8052F6B03A5; Mon,  1 Jun 2026 09:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC7D6B03A7; Mon,  1 Jun 2026 09:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CBB86B03A8; Mon,  1 Jun 2026 09:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AC356B03A5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:32:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 022FE90D76
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:32:54 +0000 (UTC)
X-FDA: 84831434310.20.9A80495
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5AA3680014
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:32:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="PF t2RAa";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="Fm0bCp4/";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of robin.clark@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=robin.clark@oss.qualcomm.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780320772;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSWiEO3+qeWSnedTIbwacWBgpl1B0hKJbCUNlgrD+t8=;
	b=zTU091O3aCScaBtETr3xTAGmm/Jfp4DeLmr3MgglSU4ytSOh9b2gOD6LbVY3TR7RX+vxco
	PHaah8ND1mMvQNyxmhkCdIClHHUIKASxZNeuBwy1r5kYl3jy11P2IbTE7ctdX9BmppTfhW
	Z7fxcx7U/RHV7kFYND2+H2x92E0STxA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="PF t2RAa";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="Fm0bCp4/";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of robin.clark@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=robin.clark@oss.qualcomm.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780320772; a=rsa-sha256;
	cv=pass;
	b=dZT/GS/t32lC+agQ1tIBnqcHqmL9uj7iHhcRdw6uYC8WRSEiyRtKY/dv5vmMQj00uMiijk
	KDv8JH/nk8pkF4vsATQ6A3zt9gRnL6GPpH44MEYtJIk6NtfA7s6RoqSC6OEH4AVTObCS8w
	tj4pefGtqy6dCLmknep+hq9i+sREvbk=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651BLwVV621967
	for <linux-mm@kvack.org>; Mon, 1 Jun 2026 13:32:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=iSWiEO3+qeWSnedTIbwacWBgpl1B0hKJbCUNlgrD+t8=; b=PF
	t2RAar6Rx4C+bsZIRoMqTfW1WZG9nbsuJlWkqn83U135u0Z0bylMV0sOgc7F72gV
	sqKCXLPyNmXIQQ/LM30PPnvWdr+IvT+bUtFdYo+RGnFTWLchsKVSlh0FDoPSne/x
	pT8kRmrDo3AgwU10bbeSYRFnjrk+ckhVN2RePt2wOCFetIxgLNKUCdTFwqKwNPpH
	/4urPc305YRMDkPdekrkeylcnqus27uRpJqJZU23OIJXdUhw1wsfdevOrPX/7UiD
	bCTMtjBiSsut7/eI+6phiKEIvPexyRmaB5KOJrOAmfDDzb3RzByJ1NpduMDLwrt5
	I75z8vm444bwcKCfbr9A==
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eh954ggfd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 01 Jun 2026 13:32:51 +0000 (GMT)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-485ebc5706cso3861005b6e.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 06:32:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780320771; cv=none;
        d=google.com; s=arc-20240605;
        b=P4MyOiDCU7AAvHc+EYAgLuney1vdKAXpQrpTsy3H+wuIAMvbf/OS4rHTXo9hDp7oMi
         Uc8GzVdqaIkhYWpnJSNmVo8SxEfV1WK5ahdE/bX8J86ys++VP5lM+FYVMs9H8sOHguOS
         T46TH7Mb2ojWWu9S3eRVuGDUhlWoyYeDlkD8Q3TgxKHVPafppxsXmCWjxkItSfG4MuPB
         ym3dcJTKBEmmbDs+bZ4RyP0m/zz28E2Ysf9W5Krp1zD+fAv3yqb6Umzc0vAbp0qJKcNW
         Uer8YeqGB8LwRkxLOiyUPD+oSNmyA/8Cy9zp7dDExeDRTa/0uNAeLa2ZvTkdPgv7JSSi
         MbrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=iSWiEO3+qeWSnedTIbwacWBgpl1B0hKJbCUNlgrD+t8=;
        fh=Nutih+i2amhCV53V6+uWSrR99JADR8Qg1y3YD1tr3wM=;
        b=hd4ACH7iwR8rVWA7gf+pfQT5hmO4TNo9rHSnF/36wYy6/jMHswkJ27cecWbM6Mb+Cb
         GeMJOP+k3mvxJnV/2gJhAAgEcvaXYXr0n6McUwiy1QtsR8Hh2HEA/6z2YSstg6JT07u5
         QL/+PSLsv3Y0njFA9DcWBmtHQXxkGwy9JHO/Tnj8/TZrFokN1YpN8w/tFsMHvfm2kLbc
         cQK4n5gSvGDgiBoSvh4/2tWWdWq/EwMz7kbsmnVXd5ijWoB3VTNEvdyVz1nIpDJIV7jC
         AMEYwAxUnzMfRQFVMxA96B/gcajvJj62d52akEYAw30Hy6pOvAKKIFr6Yy/HU93PqBgd
         9S/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780320771; x=1780925571; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iSWiEO3+qeWSnedTIbwacWBgpl1B0hKJbCUNlgrD+t8=;
        b=Fm0bCp4/VOd3gfwQTvEW935Pi62SiIttb8nqytpA6o2LzRE4OQ/HHFEVSduuEi0h8o
         tU1GOGZpR5JJVkHccapcSt0n/Gxz+NkjpcVcuZhd2PVkoLkNQFTFG2RvGOTiY5U4F+Eo
         81OC+J0e89SDxGHWQy1lRwvsWe4BCwiHIevTIztDLUEY+IbX3gnM6XPnpMllm54MiYwD
         /Z46iPSIQRhaYSxqUMECedx2Vv2fQY7JB9mRoA37WfJ4KmH3HGsFGouc8b5lqMWahIVp
         NSvQO0rrQ9ZwdpzlcH4zzJClFaUrU3uA1yfw3ZauueqQyPMvhJZOfL/TA7IZwm21Q8+n
         Bwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780320771; x=1780925571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iSWiEO3+qeWSnedTIbwacWBgpl1B0hKJbCUNlgrD+t8=;
        b=YBjOV8Ve4P+jOQzruwWTUXPwlmDhRtmcGxP2q/j9QTBDTuCVCEkj6PvcJ2D+er5+a0
         GW+QRQEnZKKZsA6LlLrUPi2eazJ38ywDHPpNvqy0U3liINAT2uO+qwLrWQG6LnjveuG2
         JkZxd8KqxMrzMAXlep0tvt2JZFRf+5tuxlxzPcrAazM7QGgQKN2+g0SW1uLTkQQh2V7l
         XRVOoJFuh2UJjigj4zeRXN/eSByIvNs0X9Dx04kHlNp4MfgnUT8dgiODJVySoIb7bpn7
         91C8ThbZ1wdPprtmHAHbMyGlxKzT3HjCSlRTS2FBSFAVYWhP1lmBFt/7aw97pOOjiq1u
         FUMA==
X-Forwarded-Encrypted: i=1; AFNElJ8/RwlffjlbtJ9Vg+bOERQ6GsPrTEGyB5s/gnPviT6EE6RjRkcqr/gD4xLjsR13cjvquSIjY4U3+w==@kvack.org
X-Gm-Message-State: AOJu0YzbKfojXw89giyiwm7GF45K9/XxUsQa1zuttzsFZDznOl1q2XwN
	T5zEm7E6RoOZ+DvwiPihFzuFquDgfmrwr9caKNV+sovxSPo4vN2I8QqHDpFh8JsXsGOzrXqFQqx
	wHH60ixHOKvHu+MT2ysj5UYhbiGl4AMpKmOfEJbLMVWX8y4uwp+PGmJ37vQiOTehMex+59U7Z16
	bhXxyPoeHzaMKplamng4shHzABfrd0
X-Gm-Gg: Acq92OH2DNwVRMSOUOe9pJ7jkwiSiruWI+k5uGt+qH/ZgTheECrq/XAJiT7ndKurscs
	ocxskc+QmvzN6/MSF7r/bbPwsRPsi1gLcyIo1tRadqGsxzpZNqnBr6KvUjCnU7kQeFW6EwNV7O7
	tSeZllaH1MKPMAxmxRgP8qCA/amPwki4yoV3/WLaYtnTZaU30c0UnBTc9Au3j8DtW8JGPfTORpe
	IqhdPy5LOn1Vw==
X-Received: by 2002:a05:6808:c413:b0:472:c4ba:32d9 with SMTP id 5614622812f47-485e73685aemr7697311b6e.20.1780320770636;
        Mon, 01 Jun 2026 06:32:50 -0700 (PDT)
X-Received: by 2002:a05:6808:c413:b0:472:c4ba:32d9 with SMTP id
 5614622812f47-485e73685aemr7697281b6e.20.1780320770193; Mon, 01 Jun 2026
 06:32:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260528093437.2519248-1-hch@lst.de> <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org> <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org> <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
 <20260601113831.GA25535@lst.de> <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
In-Reply-To: <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
Reply-To: rob.clark@oss.qualcomm.com
From: Rob Clark <rob.clark@oss.qualcomm.com>
Date: Mon, 1 Jun 2026 06:32:38 -0700
X-Gm-Features: AVHnY4IDUhXdIIQ59yCVYlfBYI5ZXqh2r6jh6SDaQfttaiXqq2hNkv_bQjj9LiA
Message-ID: <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, io-uring@vger.kernel.org,
        kasan-dev@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: uaPwtzO2Qu9sP-mWFG-uNZonpvkVpSHU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEzNSBTYWx0ZWRfX517dZYyfOePq
 5ICJXWZm5BnO1b4S3ot6qTOwyHuP2JgsB67S0y72j/cozN7UOaWmGuoFR5qiAbDTHmoKhacsB3R
 RwWRZA76uIvp1IQkstlxjEZQbND2s6Am9aGDwi/VLFdNK34+OFNTh7tfghQSbgL/Bj33Y2QyD1v
 SEamJBB8v+TJYYhhcBN8Q7XG+DlbI83tLHRhqaW4A1u0IK0lbFk0TNxE09/ox2y1qbqFL1CC2kY
 UBHU0R7ZWqDqbQvY3vJVN2EYDptjP3QWRjwl68a8QH92iRACsdwYanYpnf1v0GBRyVvZplYpLMI
 yMOipZ7nVeXBnp3YVazMoy9ijYMNCOpR7QsFx/kZbaF5A7khyIbO25/pXLyxzwa9Qgag49S3BqZ
 o+BtpSvbDSN7vRzOmpYjLMHEI8hADmVBnqbPRfLCx+vBH4W5Z5smtDo8NvW4o64ACXZfvdOaNkC
 eLiLVy1EIMboDonHZrA==
X-Proofpoint-GUID: uaPwtzO2Qu9sP-mWFG-uNZonpvkVpSHU
X-Authority-Analysis: v=2.4 cv=VpcTxe2n c=1 sm=1 tr=0 ts=6a1d8a03 cx=c_pps
 a=AKZTfHrQPB8q3CcvmcIuDA==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8 a=gxV2vm59AnE_F2JHV74A:9
 a=QEXdDO2ut3YA:10 a=pF_qn-MSjDawc0seGVz6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606010135
X-Stat-Signature: 331xo6gjosrzk5nq5m7y3tgd1tmaeazz
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5AA3680014
X-Rspam-User: 
X-HE-Tag: 1780320772-61694
X-HE-Meta: U2FsdGVkX18SQShiincNi39/3EjqMo/1OLdBjcx4cdEkV8idvkXfbgrYyGh5shyr39WGVJV2subIe5BIPTfzoJ/hQlw4xB/R1O43EpYVIcLq1WR22znmNuKi6Z9Fv/w78ioJMPUhTvo9SelTeHJevNSa96H3zvxg10rCJq+DkdBLv7iSjLV8kghn7QR/DcApo5HOFkF/386pHLeRMIh4QFM0yHC230Ecm2l8v8ABnb66mbNsS3tBlbyJBf4mVPwHD1fIy90JUve3Bvd6eoIuHShy7EOE1wTiXJpPhzjDPUKGrIbPlwZ6RDpVs/URQupGVssLzkVjHYH/W5ZgwNs+OJs/Kq8NtrLuAAb82aE2XRnXwFNDQTcIbuwmaEHlUAD7wLzS4ojm2wpJbhP7iSTrpRvI65LbU0a6FWNX/SF3hmYDrNterWMzqZM+vMPv9Gsxc6GcywTexJLWbf4dyEFZchrqkB12uHS8zrrFCJUQqX67xo8RzMtDKRDnTZwgB9Y2aLlJBXdZFOB/N6E0iBWJ23J4dZGQdCfiTfybjegNP7in+E/v+wbwo06xWM8QMFymuL9M1PKeNp3/0aE52dRaLP/A2xYrIxmn4OZI7BukrazpIEAd4TnQQnG5M1GMFO/UoeOQmYOGr5XbyB78QkqSbUy2SERRjYU1cZz8XQHHKvAaz+IyCuJlP2zRY33fFiev8IwSfiQ3c9cjCSCpTiojDrxJL9osmOOvREOxhIZ0xqUGpcxeUkKpq4dftWMbWkOinE85yo9zi8Z0DVPDihNwUWmOfdj6YrIzZRDpXxI8JKBtgiVpxNLO8rcP7XQKd+Sx2R+TaTZWHQBs4OD3UyID5XYJDfLBVNbgi3JmxMrcDhmK86agMICpcJNWvEYWRAR+muALhsdcgRtfBu1W42K8VelxMEvDaJCDIzb2dF25oMAXZoYK8HcwxP8kQ1aE7fQes62hb2GeFjVLCeZ33EB
 YtbJKyo2
 CnOcuhYof2LPah25WsryqtRS7EUMt9C2Ool8i4/AMTYcMrkoyI1ovv7x2TKSkJYPt5WFxf+Wvjkm1ZwueupFz2s94D4UbeqUKa4fnBQ1D5RnKDHv2Gx+eKjVxFOTTJuvZDWcRK5te77/0PlYmxM+kEb7sY5NMp4l/nru0mfTzBv1cOaHJIO1mbLl1cR6jb88FSeX2orqrs8dB8C4ieWlxD46cwtN9HwBnT0HIOuwE4WCjKp+BwSlG5nHTktSvn+Fk3rIFgv5BhSdWY6IiP3a7vko5jMauDYS542N2y88+r7j6lZYTv1EuWU6QdNmpIAqn3TEKOLyfh+zujwsjKSd87kuJZBwQKe2KWSDMToJoTg1L0prTL0fh4jhp5keOkWWGZAijjDbnG6HL95txaE8zRrSEjneLZmKPuHAoVZOkgMPjizIZoq+ds8Hwk4ASwMb7ISp7vhfIcJUuJOZHVVQnsSRpyZ4js8EusX6/4baYaB4cNzLDqxgM5HUZh1u4bsd6YqN0gVfg29n83CGSC7UhdvHZt5efMMTnrTtX4FfQuqy15BNinw4ya4mMTEEtvRXiGD3cJHtdYgVi1mLvTJSx/MX+zb3WBsvVYUwVtrBLt1mm2K+qnmL78C8fXgl8IlNsxSffFkTpaqrSFovuH/xqRdxvIF8luNrUnF3525fHX2crbTvtPPzJ0TEvIiSWFIA5nGCTQN5wkBJH+ejA2MP5k51EE8H/5PUIHjQaLJu+bN7CnTAyP9BtSDaEaAjct8TC3ugy8VByaQ7QgIMuwQeO1/9mqratfvziG/Lbtm9DJTAlKwRlN33jdI/0I4MOh0gz2HgKnDsaONslmZku6ZskOYuHT+WxqTlsCyK1AJFF0FH6gfEA93RwsOuJvaoKmcJPBsEXbteV93OlWYxOzpKVL4BpeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 5:50=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@kerne=
l.org> wrote:
>
> On 6/1/26 13:38, Christoph Hellwig wrote:
> > On Mon, Jun 01, 2026 at 10:16:30AM +0200, Vlastimil Babka (SUSE) wrote:
> >> > kmem_cache_alloc_bulk() returning 0 was considered a success in that=
 case.
> >> >
> >> > Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing th=
e
> >> > user sounds fine to me.
> >>
> >> Would it be wrong if we just returned true for size of 0? Would someth=
ing
> >> else break?
> >
> > I don't think it is wrong per se, but it feels like the wrong kind of
> > API.  I.e. I don't think the MSM caller actually wants this, as they'd
> > also do a zero-sized kvmalloc.
>
> If p->count is 0 then indeed there's a zero-sized kvmalloc so p->pages =
=3D=3D
> ZERO_SIZE_PTR but then nothing breaks because nothing tries to dereferenc=
e it?
>
> msm_iommu_pagetable_prealloc_cleanup() has a "if (p->count > 0)" branch s=
o
> it seems it's considered possible. But then the rest of the functions als=
o
> seems working fine, i.e. kmem_cache_free_bulk() of zero size does nothing=
,
> kvfree() of ZERO_SIZE_PTR does nothing.
>
> It seems to me kmem_cache_alloc_bulk() returning true for size =3D=3D 0 f=
its
> naturally in this world and is less likely to result in a gotcha?

I think I was probably expecting kvmalloc(0) =3D> NULL ... but it
happened to work out before

Adding an "if (!p->count) return 0;" at the top of
msm_iommu_pagetable_prealloc_allocate() seems like the thing to do..
if you want, I can send that patch (but traveling this week... so
let's see what I can do)

BR,
-R

