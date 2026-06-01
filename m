Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E980ECD6E64
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561F56B03DB; Mon,  1 Jun 2026 10:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5101B6B03DD; Mon,  1 Jun 2026 10:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362E76B03DE; Mon,  1 Jun 2026 10:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 204806B03DB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:39:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D06C3C2365
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:39:34 +0000 (UTC)
X-FDA: 84831602268.18.CE89C99
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42570A001A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:39:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="fl 2WHho";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=IOdiPIJV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of robin.clark@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=robin.clark@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780324771; a=rsa-sha256;
	cv=pass;
	b=07baZB8NFNANNTErpEgF0G0eqK+X5EwKNBOM+jBHva3TVfpjE2D9oOU+5zBg0+XEawvBr1
	AZ9BlXdyrm4nqIJFLzmA1HOez9rVxJN/V+kY3hrR+dPj1p0meN6fns4x7QaxJTJSm5BYiV
	pSbvGH7AN0vyany34yFWTKm+47W6UzM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="fl 2WHho";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=IOdiPIJV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of robin.clark@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=robin.clark@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324771;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VN4C3LVZuH1k7AUd4KK8MEyJP8WIXP8lg6sKthHlaQM=;
	b=1iJr2xviHScwcJaJaRHigrWesNItY/dLLMCg4UTJZ1shDq+HupkObrbNe3ifu8g9R++j4W
	FuMuZ9TSinkfRUUYLjvf1AWd3u1rjQ22RE8ZdgcH99Y2FdvTm64CHZ/5PrjVJ2tEW0jX7Z
	DbKs1UsP53nIXOFolfey0l18VQtDFZI=
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6518fm0Y4066046
	for <linux-mm@kvack.org>; Mon, 1 Jun 2026 14:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=VN4C3LVZuH1k7AUd4KK8MEyJP8WIXP8lg6sKthHlaQM=; b=fl
	2WHhoU2ZbOBnQayMN29RXuPbvfhRf7VSTallEctg+EVOpuK7OgxdBm1XKyW8KVTE
	2FmNSvRNQVGx1p8XxVrQ/Acsaz17y44FmnZf6SXtJAHS7yz6ptk3108QtY5IBJ57
	rGpDJvhLyR6ZpSbbxiv5Cd5Mx+Nx50TKvl7k7InzYMfbjxMf+CT/ouAgiL0kUY12
	hQjpPFe61B5qE52vZYVpldryQZ1paFipGZJISOzTfsMA4uSAHXUCQAf2UYW4q44Z
	m1eRBDEscpykCOKXssGcU4hCKIBbpc83YhNKgOd/8ieznHfQ15SoeqQ1iy/P0qG3
	yGRx31p+5FW9UFEHz3iA==
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eh6swsfs4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 01 Jun 2026 14:39:30 +0000 (GMT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-48638da0e05so296203b6e.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 07:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780324770; cv=none;
        d=google.com; s=arc-20240605;
        b=VLdg0zuKozDtyAnCp2/gbDGAB22imV4DRO5Kf/xhdw//RMiIhdToXJIdN1EjgafwMO
         XMw6nvUPaTMN+W7Isc3bYeHUShr698TaSPBEkbJIrpsMo0pGVnhvlS1qbGZ5hewa1wWr
         9jrlyBCjsTAn5u5+/IN+0LeLn7ibQF4lSj3iPXZaTGux9xhu9atzaBx/gPalYiWX85kj
         BEzc5hgWC2J45VIUNRUIv1ISXA6M1o/vDk973QHRM8vV8OlHqD9XgK6PbAEwYdTIAbV3
         TWuECUJx46YFVSK1N7EiU6FVzJWqVR/gdAgg8Z1C5y1pi6E33K4CboFCBxXtM/Am6On1
         hZsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=VN4C3LVZuH1k7AUd4KK8MEyJP8WIXP8lg6sKthHlaQM=;
        fh=vtGnM4u/NzMtEumHXyjiXYGb19N8RltBaBXaYIXm2+g=;
        b=JujOI+broofEhSgYJsBU5mStOLJT/DZm9XWME4Re6MHduk6fCg0ycCkS+PP1HbUMOw
         wf0lFbwZMPPsUz5b3HgzF3WhaWLXObo6YjljdubsJNfgiztTFy1oNkdQBC1iHKr1CAue
         m0rrxA9hQqqDu4gkV2tYTnG8zTAXqj+jxVnwe12U1fJaGusEnjSaXY5+AUlYntiQOdEW
         uy5uYRlqU78YzWuB1GSTRGpNRYPTe3ABX3I9h3yQ2hB3uwUxrWRLfneq+uVgD7w5lsDd
         tRPh9vHMfDb+UQ765WL7U/rUeX8fKlC90gqgaiDLgcdvQPaR5Q7uGGZpn52jNDoLyC/O
         Ta7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780324770; x=1780929570; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VN4C3LVZuH1k7AUd4KK8MEyJP8WIXP8lg6sKthHlaQM=;
        b=IOdiPIJVOv7Arn9pOrdXzLVpVu7fS2bo3XKpbnV43ZTn66iv8cZlkmyezf9BvMm1Km
         bxi7lbU3+zfUHFeUqWRgEKfeJI3K7Cw7Sl0qbJZOImNFrjpgjBLnNrbux804Cu++xBS/
         QMiSsN5d+Yl3Lik+bJErMkQFsyzh80m2WGv7wdlrSEc8YzW9FfUjZcTNlOu9I3ti51wy
         s6BG85/bKubdKnhfuoRVG0/fxDKfm0qJ6BRITS1dngM/U5tJNgmL24kvMTK2vBwt6aLz
         tGEzxCH284Lk4GkSS5BifsUfr8cYulYgovkLmmNG1jl0ANyCbtfw6nIWj1UpOgflgF6B
         K2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780324770; x=1780929570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VN4C3LVZuH1k7AUd4KK8MEyJP8WIXP8lg6sKthHlaQM=;
        b=bAhCafCy0iv7cPylBAgc4QtmHysiM/dhLNvfVEosqr9ZXxtfz679bvtlWekHXH63k0
         AVBtFi2frSxGnEqM179OdJgTaJLY8/bpWaeK9YKonS39etjSlwxBTwIY5NVq47gXLfeK
         e0/p4Km4Zw+POkymtR3wTiagUxhzpvxLmU2BlCgwviLid9QYBKmpE+H9FvQOKjwogSbY
         5/4OG+q0Mmuf0/lRVfEeDJng2NJhMH49b4l6LnmIn+rRvFL1PN+qw8DoxgCwGmiyFul9
         AxoPX7sx808nD99SgRq90XqNs5EQ5QdsLXXSNi9hYSYUNc092gxYRAk6IeQWisnrf3O4
         WGYA==
X-Forwarded-Encrypted: i=1; AFNElJ/m4jo0oEvxZYqF4barYhKe3QK6AdDE56OQTAl6gdPKIx1Do0Yt84ULsRPmqHEkN1bCTkIHN5felg==@kvack.org
X-Gm-Message-State: AOJu0YybiJ1sF5HSM0e4XDzrAq2N2jU2X3ERuViZmOpCwFdrylN9IAz2
	/JiQGOx7MMyaFquxw7jHgScJHAc3OCZBn7mXRbTtZxIcG8ewRnoLL3gfTwvOiPgHhIDofFe6/EP
	JB9LSuT+87nKH9zJjKrdGOnNvJ7VhoIyFgIEdL1I4bT/vL4/+e1vJODgpfo47Up9jh1nG0MJ/0O
	Q1Xcy8lEvUYjw8cclLMgvTs3E4ofaJ
X-Gm-Gg: Acq92OFvSWvnD1foceOsHAd/TIGypCluKWpTS1WjkHJ1IVrtzxQrmcz+MAjPj8mQ3GM
	Pl40/S30sowArx/m/mqnvaT+I2vCCHNFDMeXJhY55VEGCRk9rIwxI0emepiBPiWjTw0SHBbEl0B
	B5UoHFVdRj/Bk7wZbzjT3Eg5Xi4+Qpa/e5I2bWypimk2CJYvG2Z1PW/sX1sH9TvStYlx5tzWxnw
	X9PGoPzeNSCzg==
X-Received: by 2002:a05:6808:1912:b0:485:41fc:71dd with SMTP id 5614622812f47-485fb6a8ec9mr5078458b6e.13.1780324769622;
        Mon, 01 Jun 2026 07:39:29 -0700 (PDT)
X-Received: by 2002:a05:6808:1912:b0:485:41fc:71dd with SMTP id
 5614622812f47-485fb6a8ec9mr5078428b6e.13.1780324769126; Mon, 01 Jun 2026
 07:39:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260528093437.2519248-1-hch@lst.de> <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org> <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org> <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
 <20260601113831.GA25535@lst.de> <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
 <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
In-Reply-To: <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
Reply-To: rob.clark@oss.qualcomm.com
From: Rob Clark <rob.clark@oss.qualcomm.com>
Date: Mon, 1 Jun 2026 07:39:17 -0700
X-Gm-Features: AVHnY4IeX3RPNliDvhMevHdXSnbKaPpqnSaYQnqMtv5VzgFC7cHejpPkwD8NES4
Message-ID: <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com>
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
X-Authority-Analysis: v=2.4 cv=Z4Hc2nRA c=1 sm=1 tr=0 ts=6a1d99a2 cx=c_pps
 a=4ztaESFFfuz8Af0l9swBwA==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8
 a=dBKglsDaislA0vfKbgwA:9 a=QEXdDO2ut3YA:10 a=TPnrazJqx2CeVZ-ItzZ-:22
X-Proofpoint-GUID: Z5SYZHCfXzMicQIo1KQLLifCXhZtQLtr
X-Proofpoint-ORIG-GUID: Z5SYZHCfXzMicQIo1KQLLifCXhZtQLtr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDE0NSBTYWx0ZWRfX18/1tp60sd8a
 +ILyo1crR1monQXseFSjSW/QCy6siw1RBpdFsAVpFH3mTtk/TDvYDcW2ufmFbWcgw4fLeqjrhhR
 W2X+16rXaNFDSXAnK4aIzBcvuaK5olbHWBtBHpwqcLoB8aSM9nvflE0YBt5M+eVP1vxFQY86Gwd
 qN3LqzublP6RqG/CaFljszaMsVwPkvzWQktJaGvikidA43JKB+HUeXRx0enbjdht+m/lqaRHqea
 wzHH97S6+UJgFi4jcu1MvAnCkh4te2LTaMkODb/3W/UaG4hyrcmSQ6l37kuMB0Sl6QqqyUqFU4+
 GoQ/+pqo58AH1DfATspSKizFlohI/CQr08wotfR6a4+wURpqrOTOSg1LRjBxTsa3+xyF60v3f67
 H5ffsIbjIcTeJWsabmqFkiDoYxoTucdOiPgJ9GKVX3kgVSpJaBZnbIs4zH6xcGwZb+6d2DUYzed
 XAnLX6garOiROZe3y0w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606010145
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 42570A001A
X-Stat-Signature: riboo3phz3ogehfpx1a16azpwrg8ocy5
X-HE-Tag: 1780324771-840185
X-HE-Meta: U2FsdGVkX18VmD9RMbxfcAL7qL2K6+upEhZRRqGRh2RunLpMGCHtiEvtOzM7yjwXrdIZ2sy2v3+i5wGIJRhH4mDlUdCzAgKOdOfsSZuuDancqdTaeGOEsWZg8dJrBvsc2FZbdiexLfYOQhTgoT1ZfWS/NWy1f74BRNbpJL8ak4hajBZfF+trJvWdm6QbVJ/Yft1we8fOkpneCj+nNtUkVxmhNaC2hAgiwRuKwhz9r0mqrGjjHgKt9aP/5iOeBmmE935qIcZyKjFk0O4mS0tJNhhRxA7LNNT+FXOhMZzmJ52y4D6Y4xYLlSAivuWsyFbr7ddLiswnF+XdzS0cXHeYaFrDxy9/9ZXE3ItTSyu7Nu1yFPytzpAq9YllRmCYRR6ta5RgzceMbelNLmiC5Vw/atdq//iuU/gYi4qTx7j+9V6tFG/VUJbwYXdC7r6ixIsNkrkrFP2E1kNu7mcdP96EqOsDPDFidKJa3NP4vhjQRNO5pb/GYgdp1/Ku0ydQGyWT0yRWz0DXiAscIThPLY4GVALwpVsDJ8v/KDxZLOq/h0xCYmQ7Yn8FA00q1OgzGOAL/fFS7T63tpXybFu/p0ADiIn3Q1IvQal7oJ6Zm7H7LJwvHngCAMo2PZfm6309tMilq7oh6lzmIjtS59KtySsh0O+xxEJkEQ3+hno9HZUH0Ej38bg6IsXOkePF4hI/daDuOAuNTguEFO8xvnd0xEYNB3lC3l+tcVhTkJJaoG12Y/WF05/yFkZOpv5c/UfxZolAohgmXIEAWfmLCyO+wXR3lr6r9q6aPJoZ7O8+KZSWd+dJtPI3CjF3D+FxBpBI8tt80Ny5BHP/4gdpQW2qGqNlskTAK5Be07uH7PJuKeGm+jGqDPnprG3rzHy1XFol8cPLgWA11X1vEcztpTn3PPu7C8/q0PtxWelxOVrfyxOdYdV8Su+3m+yxFUs51yJPW7sRCyMF+7siGAkO2wko1Qw
 bF4bhpt6
 Hl6jsuzZyRZ7DW57KphWWRnw7tUDt98XfNa9IkmTRcYae+kz28r42ODvw70u4x03ZhFm53+wZMv7+1Pqo0sIpFKHIvdqmPQy5OaP89WJzuM3WO3uyBu/3pkTG1mpQAYnjyAhvqyXbk4P1PGv8UcilXUTi+POJF0E9M1IaSLTXU73hci97OkUpNOL5U2QlX/3y42nG9yJQn5wUs7HRziol1HwLh2nbKggk9l4/s2hOQ3CJd/qRykY2P2iNkbDrAiRU+JkyAPArMq0vae4oWZiESkPbh00Tlrc6oauNAdiQjAxBNdHiKRculIaliqzI8FDKmQVmcQCFijF1BqCCtcwxEHF2NAfVFELLOu2P9gIE/jpRbtu2WRh532gkUcGVT8s+P5Y3/eX44I9mH2rDTXftiU1pR3w02JRUJwTlnJYD4300xSg6zm6ZeyKpPgANp5Hw5Dd20GMru+kloO+qVwBh3Lx/chQDa1ntGsZgfz9g37ognMomko2ts3zpbJqnshF7EJ9L+JaY5x3swUa5sEpm415VSDM0Fft0HwUy+jL90W1pfbv86qWLBYqGLUCKx5J5RdI1PddMmkEpY9Jx/e+Hhev9j2XJROxtBbb1k0gXBDXhzar+IP4scdTU3aKtpwD2OQC+bFaLwjMG4hdt4Zyt44qpXIaKBQyzzbgKRKFNkxmsXaIcS1aGwZAJu32ok3j912Yo9MrnhN4kzytN3tWbJr1W0p//Xfoc3I/brOBXAc1eUCWEb1yzY+svPD/2fD1TpIs2+NnBlus2X9vgbhRfxgRr7rAaavOpQjKfOzH9f+x1eEtw+2KgUf0nTntESrTWWykJYo+vPZ+suGTTi+l1uwX4WSL0nqzjJNrabNuS+MWqK06QkWfnJIehozbQWwfghXW1lVCc4Ri0vVdVDVAm5RHGPU+cqpL7uV2m110TFBHIgUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 6:32=E2=80=AFAM Rob Clark <rob.clark@oss.qualcomm.co=
m> wrote:
>
> On Mon, Jun 1, 2026 at 5:50=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@ker=
nel.org> wrote:
> >
> > On 6/1/26 13:38, Christoph Hellwig wrote:
> > > On Mon, Jun 01, 2026 at 10:16:30AM +0200, Vlastimil Babka (SUSE) wrot=
e:
> > >> > kmem_cache_alloc_bulk() returning 0 was considered a success in th=
at case.
> > >> >
> > >> > Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing =
the
> > >> > user sounds fine to me.
> > >>
> > >> Would it be wrong if we just returned true for size of 0? Would some=
thing
> > >> else break?
> > >
> > > I don't think it is wrong per se, but it feels like the wrong kind of
> > > API.  I.e. I don't think the MSM caller actually wants this, as they'=
d
> > > also do a zero-sized kvmalloc.
> >
> > If p->count is 0 then indeed there's a zero-sized kvmalloc so p->pages =
=3D=3D
> > ZERO_SIZE_PTR but then nothing breaks because nothing tries to derefere=
nce it?
> >
> > msm_iommu_pagetable_prealloc_cleanup() has a "if (p->count > 0)" branch=
 so
> > it seems it's considered possible. But then the rest of the functions a=
lso
> > seems working fine, i.e. kmem_cache_free_bulk() of zero size does nothi=
ng,
> > kvfree() of ZERO_SIZE_PTR does nothing.
> >
> > It seems to me kmem_cache_alloc_bulk() returning true for size =3D=3D 0=
 fits
> > naturally in this world and is less likely to result in a gotcha?
>
> I think I was probably expecting kvmalloc(0) =3D> NULL ... but it
> happened to work out before
>
> Adding an "if (!p->count) return 0;" at the top of
> msm_iommu_pagetable_prealloc_allocate() seems like the thing to do..
> if you want, I can send that patch (but traveling this week... so
> let's see what I can do)

Aaaaaand.. sending patch from hotel wifi doesn't seem to be a thing
that works.. but I've tested the following w/ deqp-vk cts, and works
as expected

----------------

diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iomm=
u.c
index 7d449e5202c5..ef744d154bbe 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -332,13 +332,16 @@ msm_iommu_pagetable_prealloc_allocate(struct
msm_mmu *mmu, struct msm_mmu_preall
        struct kmem_cache *pt_cache =3D get_pt_cache(mmu);
        int ret;

+       if (!p->count)
+               return 0;
+
        p->pages =3D kvmalloc_objs(*p->pages, p->count);
        if (!p->pages)
                return -ENOMEM;

        ret =3D kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count, p->pa=
ges);
        if (ret !=3D p->count) {
-               kfree(p->pages);
+               kvfree(p->pages);
                p->pages =3D NULL;
                p->count =3D ret;
                return -ENOMEM;

