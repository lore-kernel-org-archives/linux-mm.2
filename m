Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5D30C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 15:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9A46B0092; Wed, 26 Aug 2026 11:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B08B6B0095; Wed, 26 Aug 2026 11:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBA046B0096; Wed, 26 Aug 2026 11:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB8106B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:23:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27F2312013F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:23:30 +0000 (UTC)
X-FDA: 85143789780.23.4AF6804
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 431521A0005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:23:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=YYpzw2rO;
	spf=pass (imf19.hostedemail.com: domain of "prvs=6698cfb698=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6698cfb698=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787757807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qa9WiTOBruKSejQpy5vX1+ZNmguPqrLfKFdD+WBNetM=;
	b=3WGE/3lqhGxCRhWUPMcQWB+QqVDrHBl0FdCeptz0PoSUZN4fMWMBcy83QpcxfiBoo7b5E0
	ZdWEzIYCHUzAE8tYLG9YjdfQGKDZ7YDe2l7QUodtnh/e8PFU3LCyClTCetoHgJyGI1Z2tE
	fA970FEWOSXEVCKVg6qlaU54+cclVig=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787757807;
	b=nAy0lkxUllHEOkycb4jMU/aTCcc9sjb1TThCpJloXbqG0VvB7A3REO+zdOdQzXvDj8WxS0
	2mx5NIxBA1B6we0INZ89k8O6BwZQ6e2nsTVZhJuu+ngKxwLDdXU3H6ib0eUoNgyfnTel06
	QRngcvEX+27CgXroeNG3blar5oSRWTw=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=YYpzw2rO;
	spf=pass (imf19.hostedemail.com: domain of "prvs=6698cfb698=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6698cfb698=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67QEseMG2359921
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:23:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=Qa9WiTOBruKSejQpy5vX1+ZNmguPqrLfKFdD+
	WBNetM=; b=YYpzw2rOOakYVYLUp67awx37TtLpzPdFrSOicHSNC3dIpyTaXwZE4
	LslP67ckd1n7U5R6jh3AhimynEppefe85DwoCP1PRAxwjB+jxgW/S+TqVvkQrg/h
	bJ4Lp28IjEwAwNO9qx0tJ6FB3iMYmJSYpUCuO2FG8mmGlfu/MMydR+ZP9oU4BoeA
	//R6qTLgmETzuML9ReuyTMSQimOP36i1pP47by9cLJVOVk2nimhYkSRaRA+bnZV9
	Y3asbPnDgOTqqszhqwx9eeX2akesOooedK4qXaO1NwUcqkzrL0EFCC51nZBWnKas
	qk3YuTx70el93O7qzmwLYG3ycwM+SuXwg==
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g9ce9rhst-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:23:26 -0700 (PDT)
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a5d57a8d51so1222541a12.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:23:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787757804; cv=none;
        d=google.com; s=arc-20260327;
        b=OXNWFDPluXGebgj74gXrIBGwUZfw1+z0EEjbJTEdVcEt5IpX/Nc+rScBCs+6zabuxU
         SCP2BIA0uXTeX+tOahYRqialNuVLUsQ/UqW0NfueoWr8oXLWFDHSMZMuAW7IwRmeRF/Q
         t32+pE96zJIFo6gCdDObwSQNR3pJ/Lkz2kMM2Psis3r/UF7fsQkJMLmtgaNV/J4yTuHv
         XmE+TTxhwlqgV/VLqJRMpPxtA+puZQ7gf+TFp+IiBT4C7iDpwBgmos3D9Ln/pTC+jOJP
         b6UqlK6FZNbxljVIhmA0SlAiRrwIq6gKxsaetZOh3ZYtBFBSP8+SXKDNJTRLkQNCQTkC
         ofAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=WMiMFv8KParNnf2Hm2vAw/N6YmijsTbpNE74wr8F5vM=;
        fh=s0SuMGJmZsQ3rJ4ZcAAhh8VMl9aolj8DUecxZ1CNSPU=;
        b=WkWWJKqoeShXRgOM5cQj71prH2bmyQbFiR0zRPK4ddehq1A2Mp7yhNRB2EyrR4guHo
         EAv1jGln/2D7tzc4ibn6i2XNwGiP4zDTalFNPw6JLXq7cMWbon3T1EYK6tkdHHFeDx9r
         ITmjJkgMmHbE2os35iYjn2A1lPQJCOVZdOGqZv9wWzRRAOsLbbJs9vphrqJnsmlPERha
         zLvYfL7jITORBBX4Wb/hLr8nlxa03I8B8OibQF2z5hInHxyof4QNTmfMw4XeUuUDWxeB
         CSzTzt3pNjBFVDcUtpP8S9ph0XtiJbNbXPe62lOevXbtuj1SlT4hgK0E7L6JcA/yMFuG
         Ol3A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787757804; x=1788362604;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WMiMFv8KParNnf2Hm2vAw/N6YmijsTbpNE74wr8F5vM=;
        b=dzwYzFF7VsqyRvq3PgRPOSK5qYYSgoZoimsJSWdLnYmD7UxcES9DjZdSxGLYmWXSV9
         bwg/TswMhvr0hnFY4IbWnd2DKEg5P+GWT3avIcv+GZGgkgPQhs5eUGunZR1ncatfkwYG
         6DDd0qFOwnptdyMjE0UfCU1l8BT6fM619uPkHfId86uNtvd9iQ4vexuQeNU8U6W6h5WR
         HwSVxNAu72cNn3peyxCDI+pU/+ht15J9+QpCxmAQfIQtCe31c4trGdp9QUeuxAAvg7qF
         rDLBR4FpsP1ebQqXuHdfFuZAQATnkXrynwkuORN08Xj+tcr9jkmh+x7lcWqe64bv58XT
         4FNA==
X-Forwarded-Encrypted: i=1; AHgh+RrwVcKXpLibZcaG2Ucd+54c4iDitZtKG5chZd1l0ekXHa1Hb/MhmI1f/o1drNT0rPRq8j0VGp+Upw==@kvack.org
X-Gm-Message-State: AFuF++k2Ea+wLIHQE456er1J4izvnY//qln3LGR8Vj0wxZwQI5sB1Aue
	s/H20bd3pZdivCNiZmDDHKe1dSnwE0cCBHxs/I8xhblvoF2+I+5fdcHyVIvB7hAyHwe0zzxs0xz
	9JDTsw+LPmpAXIMV6MNzSkBjaor3pu+ctun/gk2gHj27O4R95E/v4AxwS6GpWlT5H3ylEcHeV4+
	DUNyQSWtspRyqa1HBn0sGQyd8MLQ==
X-Gm-Gg: AR+sD13QXPYSk55dAtYcoR6ip/e5GZsysYJSA+BRSFk4VsNPRQC63cdeyr0+FX9StzU
	rFCLolYvgF+AT6HG1s7fLidmyDkJwA3SLEClrkH+l0+5Zy9c4VWiQ5MHSw6swTdENBCMW5/nOpb
	8cx7VjuiPEVyJv6MjihauAkndYzzQIcjLlRBXjwBIh+8VdT1/+HLO4NRlJ3XotpZloZvSomKe2
X-Received: by 2002:a05:6402:13c5:b0:6a0:a644:355e with SMTP id 4fb4d7f45d1cf-6a5df5b7c3amr9749044a12.2.1787757804510;
        Wed, 26 Aug 2026 08:23:24 -0700 (PDT)
X-Received: by 2002:a05:6402:13c5:b0:6a0:a644:355e with SMTP id
 4fb4d7f45d1cf-6a5df5b7c3amr9748970a12.2.1787757804021; Wed, 26 Aug 2026
 08:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260825172604.3243589-2-alex@ghiti.fr> <20260826132159.433469-1-usama.arif@linux.dev>
In-Reply-To: <20260826132159.433469-1-usama.arif@linux.dev>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Wed, 26 Aug 2026 17:23:12 +0200
X-Gm-Features: AcwNN1Wo8nO1dMvXKnL495mi39rOONd4666rDugRTP83VRf3os1hkdgJ9zdQ6ao
Message-ID: <CAEmasaUKFZKFjf+bQA3_=V0vE2wCvwF4duy9sTaS_oEgF_f11w@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm/swap: move LRU insertion out of the swap cache allocator
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
X-Proofpoint-GUID: y82lUjV-UWy4fNhLdYHoUL9Z1uJiAYwJ
X-Proofpoint-ORIG-GUID: y82lUjV-UWy4fNhLdYHoUL9Z1uJiAYwJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDEyOCBTYWx0ZWRfXxtbk97mhP4xZ
 YjeAsETJaxQuab9ZMov/Uwa+jgHz6GMI33tH3aNAHigDq3rFy+8egNOrkTWzPUPOpb3SFZFe+rr
 WTTr0kqJhmAWMyZVDn1h8H+xOfabsSVZfiE1NCPGxwyff6/MarzXclM+N9lmV2AdwJhvdZh20nA
 i0us4Ym2xSHAPYhSz5qYWsekZOPpuFiI3H8UB7Pzg2aaMiKd+pzMXkUKXN8mYyuikKt6LqILXPO
 OAiiI2AzkMPbf0uS4vPEuopd37Jjm9w6sVgC3eNOis5rXm7+Gfupy0Hpy4flQdvmiYusUxwPq8P
 fUrsp8MpgMRFEiL8jbj1zeiY0xUzKfHv7kfEaMl0M1GojnXS5gCdqNRB3RFlxXsBoD41uYLbh1e
 9f/qWxpfEVsCrkQOuFNlqttV/QDH5jq/EpQIkmiC4AG+k9CA35WWS2UwqNdp0JfVgJ02lzf6nbD
 PxQnri/mlpeEIZM/Wtg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDEyOCBTYWx0ZWRfX4BHTLs/S7PQ5
 QvHU2tVzl+JR5NCkqdpcnukL1SjsUJiJ/lE811MSr1WqG4hJID/vLNdjyDRTT6vB3kKi5pdYghf
 QHjIwf061OWCEy0cKB+lvdDWUKJP9FY=
X-Authority-Analysis: v=2.4 cv=eK4jSnp1 c=1 sm=1 tr=0 ts=6a8f04ee cx=c_pps
 a=CYpx6mtW7qE8U/l5VCnCPQ==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=4h92JMTCafKA-fb_NiOh:22
 a=GvQkQWPkAAAA:8 a=ewRncaucmhy4OkKyPHwA:9 a=QEXdDO2ut3YA:10
 a=22KAYETGZJnyhCxlFjxL:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_04,2026-08-26_02,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 431521A0005
X-Stat-Signature: h5qrfjg8wu4fq79tjzspd36gi9fk47ju
X-HE-Tag: 1787757807-17455
X-HE-Meta: U2FsdGVkX18+lYRag42w3KmmW8QWUCV62Qf9fFhu9Hr8Lj0E2MN58CxMyRbaIIDdx53tVQtpTJLG45RMaE1hOuLNKuBGccTibI7i2+67pPFbJjSQWTngGliRYg59zHqJ1HiYrMFsyFPsCw/i39bNfUMJVK7Dxd4C7/+E0A9T2ZampipQc2ASX0AYWa1H3vq2tSxMccv2q/UEz+4tki92DIYJCPUO07Bk87eQl3MZtHcSk8IZdD+V/+cHAQCeaEFSmLdAVrCVo89QKKokVX0oaT1+BQbz3vu/rCajuVLbpXtB2TAzQ9DBB89y5p6VfVI++UFUbYmj+BrJEbk8QZlgS+wjtzN2CIdJUC59oEZf72Lc4aqjeZVldaEt+tw4iR00Ms1+FPuEtgRPFSkv2s6asBeSvjKsAJcE0N5xK1kKxoF0x62z6baInSyFX7/opHl0fkm1di2wQ8t92ETXccmb40PeIIUfkUB1Jw7ZOpgGiZxTN9y2XqGP0tsv/FgmOkxG/kXSy9yqytHA5BfTO6/qE0pUFCPOPTIpe/S3izikoGCJmnF/iNbGujJoUERv9Q1FQ1wJTHTCBoAuVymXUSoesD1dbrujXrT0bfstHF3mXqAIWcx1uEOePi9xcYDC8QigWbIZLBkK/QDlPBZkxJHhQQ5AU1hRNVOTke4Pq1zjhg31atdXuAHBNnAb231sSSdtRJ6svjn7OcsRkrGfe4WCgmzDC4u1+9rzZ8VVJkg+JCz6lA/kpcYxg4CJgBYQJbRvqtdm5sU21ONfRbwRLshIvYuvfB4OtES7OpXSKvEbpbLxrbpEXa4dhG/LWouTf2Q+tjrGO/Hdbte1hmL4sO5vvimeyLSmYWwdeCqAore8i2r+M9VRjPaTdhtv+SoFxpdR+SxjFXRIScSR+Bc1/rW9wkpGhRhVOQFKc0YJAFrMbw5tjiVwhSSPiDZo7RjfzjISWc6Z/uBIg1p6EBkPCp4
 j+r0Khuc
 BVz19uX5LJ/4i1rkYCPkwhzJgN8/4sHqfiuiuiI0D8YOKXlhHJ0esOjMjsa6e0qZuG7xieZsHljvX93VTaENQwSWZLvnpQMqju/1PrYXf1WdbP1iByBuFMMN4XQSwGEYxZ8XShjFRP0kwfp8c3ta2n4UOY3JrNWxm9OQysZZKDEpu+BhAfy7NexZgHnuK7G0YWjL0Ea/1tsNvfwM0AczqJKYV7RH6PykaxDFd4q4bL2+rUDMFFJbH4hQedSi9HADgSKs0l2AvYDOB010o0pXHEISFb6V7VnVPOkgKWphiPd+NQwxrBwdwKyIb/CotPUiErNYASjZVSz9bWIf/MUCwxNYyKO6iSN7FwLjSoF9xRmi7Q1W5SZSn+dyfH6L8e3n3dvs94KsjOvrF6S2+AyYgRZbukZLzI1aDkRxvHmvoawPM2YfxxiPaZt1HztxBtjvyGpNNtkICiTh3FHDucSM4PPCSJAAhiCCqIHUNvEmCytVXmJDW4xGMeaRs8uKNpXZMQjW9mmSWKyhVaC7YNdEEtvyGd0VZ6t21eBRI/YpyU2PWn9eWipZYQSkFoZQHkHkM+dNiwRHR6PAG2DQd03iYj/+E623Mzj+EqJwOFwUrf79Am7TqKcp49GkWNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, Aug 26, 2026 at 3:22=E2=80=AFPM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> >
> On Tue, 25 Aug 2026 19:24:51 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:
>
> > This is a preparatory patch.
> >
> > __swap_cache_alloc_folio() adds the new folio to the LRU itself, which
> > leaves its callers no way to act on the folio before it becomes visible
> > to reclaim.  Two users need exactly that:
> >
> >  - the next patch moves the refault evaluation out of the swap cache
> >    folio allocation, and it has to happen before folio_add_lru(): that
> >    consumes PG_active to file the folio on the inactive or the active
> >    list, and under MGLRU it also reads PG_workingset to pick the
> >    generation.  Setting either flag afterwards does not move the folio;
> >
> >  - the upcoming zswap writeback dropbehind implementation needs the
> >    buffer folio to stay off the LRU entirely, as the per-CPU LRU batch
> >    would hold a reference on it and keep remove_mapping() from freeing
> >    it once writeback completes.
> >
>
> I think the kernel convention is to not say "next patch" and "upcoming.."
>
> Especially as this patch is in 2 series, so you don't know where it will =
land.

I have to admit that I don't know how to deal with this shared
patch...I'll drop the references as you suggest and we'll see!

>
> > Defer the LRU insertion to the callers of __swap_cache_alloc_folio():
> > each of them adds the folio right after the allocation, so there is no
> > functional change intended.
> >
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>
>
> The code change itself looks good to me, so once the commit message is fi=
xed:
> Acked-by: Usama Arif <usama.arif@linux.dev>
>

Thanks for that.

Alex

