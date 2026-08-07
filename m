Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 367F3C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 10:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96976B007B; Fri,  7 Aug 2026 06:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48996B0088; Fri,  7 Aug 2026 06:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F566B008A; Fri,  7 Aug 2026 06:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 667A66B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:30:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D356F40355
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:30:51 +0000 (UTC)
X-FDA: 85074105102.29.FFDDCBD
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0EDFF40014
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:30:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="UsId/xx2";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=gYFZXen8;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf17.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786098649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jNNGud5Y1SDXcJg6DqyzuNF6B1I5VLZh+0vr3B83jZ4=;
	b=T/rWnEKVOv/VSYDk3RCB87Iba3Eenvj24up3SEPOaM3c9rczrTmt0Yb64pIssx4s6DKPg9
	gFI49kTd9AUnpUL1wxdgkkjAkFmg0lfnWLvDiMAjusF8MOHQgZaDLziXGYp+7CO1X+WPFh
	ORYe6307OOkrl20iy7R8lrYs+jSHpO0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="UsId/xx2";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=gYFZXen8;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf17.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786098649;
	b=j1DSGByhF+p9wNaX6b56JYu9nwLo5LGgzRAtoHXZ8W8iJDszX4EXsVyhWP/28EzJBdUiNu
	O6lc8Dh7AMrhaAI38BE4Y8F7VdjB3rTsFJ0K6Sw1H4UzvS0ql3ySFe47lw3MV9MHh38/gt
	7Qaq9t73mPyZWwNndKuWrt7nZgo8ctw=
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6779Y5qh262298
	for <linux-mm@kvack.org>; Fri, 7 Aug 2026 10:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=jNNGud5Y1SDXcJg6DqyzuN
	F6B1I5VLZh+0vr3B83jZ4=; b=UsId/xx2AOkyItWNmiEn8DwzbRyPzBAjDH1btM
	6Rw2lQYUjDeSUataQ/oyG2MHvaOnDThlTUv84GEtPwIwSrPapCXz5CF37cVEQm08
	pHoBXyCUhgcfPAEcJvU7Z1JzeoxTC+re6lyWj8iUz2/jJGFgrHbqAYlSfMoCs0j6
	qWeppnzkc0z6IAx+VmSdR63+cky28CKoMWntrmgqwyLYwLGstuJpYJ8qSHYFr+EZ
	Ty38U9/5nNYoxMWC/6oqlxkO/6hM1KgZUPw2W5RN5kT3xFWaG7U4RuLYT5PjrMdt
	R61t7QmZS1shUV2W25RIlS5P+Fbradpy+yIfabpsg/ZtqBLw==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fwcujg6m8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 07 Aug 2026 10:30:46 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84a251c2e3eso2465711b3a.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 03:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786098646; x=1786703446; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jNNGud5Y1SDXcJg6DqyzuNF6B1I5VLZh+0vr3B83jZ4=;
        b=gYFZXen8pRKmacsTEsYjV/mHB6Ow8Zw2dJMATY/PARZvxZoOvW8fftvwwfibWP/5O+
         1dH0lCbXDek6PAYHWBV79BEYKrHHh14hT9PXMhT377kOLGentcTe06qXdZ1qR89VZDda
         t7An4o17XavhaGf7pFFL3XxZZ0JtOn5HTGY9pJTBXhv69lk3forfXPH/1dx9OYShBJD/
         nKkmc+vA6nYlspg723dV+TiW6YhMT7svDqnap6Z+1vLSRaLBCzeN+4v4QXYS1ujdiKA+
         bUsV4Z9VCPCL8sWJBIrtk61D5jLECWB7vuP52NCBsnHZR9ABwWJoTaORqjM+UchQ4HKl
         u+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786098646; x=1786703446;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jNNGud5Y1SDXcJg6DqyzuNF6B1I5VLZh+0vr3B83jZ4=;
        b=s8/seEkgKRHzhSGq54eO1YfoziOuqc7XS2JA8RaDK4y0O2rTHb48u7MqwrOwOu551l
         4RxJxPWx1uz+xrb9EmOslm9bTYVWGOjMi9LCTCZ2WAZDHy0bYYxN1cexeaYmXBFTsYEw
         meStgiHNZ1V/018DoXh6hzCnu5gCei5EhpCI0up31L6gz5urN4E1i5rncKvWunSUxLbM
         TGm/kevZiktMzjoYyn0EfxqmPJXfVJi/IAxg6F39fkYqqdkhUy8QkiBGLpFfXDG65qP7
         AJtvRbjj+eMys+v0W0j6JYqRhuboMjfDT8GuoNipm5RtxJ8zDpvVFZXFlwBczSofho2P
         /new==
X-Forwarded-Encrypted: i=1; AHgh+RoJ9RpPVhx5/U8KeBBlI9zRDAfVFhmtAQDzojovQBwGRqstJcjWIXkvdoKPsXtgQXMyF5Ahx6RY2g==@kvack.org
X-Gm-Message-State: AOJu0YyvPPK4HY6wmCDpgi1uktFd1K7+dI0fb3Qvz36k4qNQrDZinm3m
	nhcqyPXGz3yitWHu/ZKoQZFWEPIgrKxtChnWMqA0WIrMJcglUHtR6hyRFAMVergcxVcKkRFcdq6
	mo38DKvYk+L5yWtqbpTXFHd8qx5EHZnVmk/HQDxxpc/Hfrk+PWXuYc1kuouzGIA==
X-Gm-Gg: AR+sD12B1k4MNSsbQbmpJxochCFa39lFB91j8qtGmiqO7ynPctzguqLC9qZuHgMjs2s
	uIyO/sGCkwGceTE9LDAVfjIJP7kNMpI7rWhSnJiaLDabdUIggEcB9/OfUPQ8rf8jyHF0HkbTm7e
	KiMMmEDiaEmUAGd9inG/ZoWdQTtijqIYfMHMwOU2gQZpkYE5p9wc8VEgPQ4B3gc4JIx9OG1IICO
	GGzBaGm7JKwyzbN9CPuxrM+uoCQI+JX7tvD36GKHScUJezPnroUhS9vAF52RGhfnUws3G1cjCu6
	Ca9vylNk0hwXL3sLhzbErcbgdrFiBarAN0z5uY46VhqX3d/aOpLVzvrrA49w+HaOKiOUnyDjAEk
	c/0+d6csQd6h63D3O/P0Y8Ipd1W+n0zjBkw==
X-Received: by 2002:a05:6a00:8d2:b0:84a:2b96:5986 with SMTP id d2e1a72fcca58-84f41ce55d1mr15227373b3a.8.1786098646201;
        Fri, 07 Aug 2026 03:30:46 -0700 (PDT)
X-Received: by 2002:a05:6a00:8d2:b0:84a:2b96:5986 with SMTP id d2e1a72fcca58-84f41ce55d1mr15227302b3a.8.1786098645623;
        Fri, 07 Aug 2026 03:30:45 -0700 (PDT)
Received: from hu-ketakish-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f5a797697sm808039b3a.61.2026.08.07.03.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 03:30:45 -0700 (PDT)
From: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
Date: Fri, 07 Aug 2026 16:00:30 +0530
Subject: [PATCH] mm/mglru: fix lockless folio_putback_lru() race in
 evict_folios()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-evict_folios_race-v1-1-b167c6b4cfde@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAMWzdWoC/yXMUQqDMBBF0a2E+TaQKGjtVooEHSftiJiSiSKIe
 ze1nwfeuwcIRSaBpzog0sbCYcmwhQL89MubNI/ZUJqyNg/T6LzB5HyYOYiLPZL21WBtSwZ920D
 +fSN53u/mq/tb1mEiTL8QnOcFWfy1pnUAAAA=
X-Change-ID: 20260807-evict_folios_race-f3b119e0cf97
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
        Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Yu Zhao <yuzhao@google.com>
Cc: kernel@oss.qualcomm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Prakash Gupta <prakash.gupta@oss.qualcomm.com>,
        Ketan Kishore <ketan.kishore@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786098640; l=2499;
 i=ketan.kishore@oss.qualcomm.com; s=20260617; h=from:subject:message-id;
 bh=03icba5gD3M8Iez6fP1ztq8ZA8gmGbH/j8kr9FuxWoQ=;
 b=G1HUb9nGoo87p9ONwH4GkEEDK+reId7ArB8zljs5knheZCjPGL51D6TVhz8wkQ9CUK3Vu4qgL
 MMwO0qQ2eNSCtwftKga5O9ABBvWLBz1UZ+8TFmewiQoIsTcl/yF6N7A
X-Developer-Key: i=ketan.kishore@oss.qualcomm.com; a=ed25519;
 pk=4sb5Ima5x03wc0KSnl57v8kR/7FxMt01+xlZJ53rSJU=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA3OSBTYWx0ZWRfX7WUnbBuQRNkY
 yEYzHKJbu5H82tItSwcDrQCd+D1s9cKa6xUCjAYMOUZ+F48F33K5fxgLjnZf/yXKeeF6IlUsGIs
 FdHtOFuCMagynHHUf3PyMgn74i/ylK0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA3OSBTYWx0ZWRfX5CIO5sn19Etz
 rJqSqnrUJmeFFkUOBiFauQNYNIWsriKLqXup4U5bvDQuP3lj+knhQlhBlU9YsnLgA6GggzZufCd
 4jHEb9zpABBb9NLkDO0LviN+B9/w29LFvESZomRvyi5C5SrWfD4xnMcocCnrVV6Qy7EpVfbx9Eh
 uh2WA2q0FPWkmiOrbcmDc3ggNomsjzA0YHWRSREFro2aLStPoKI9SIFqaUVogsu26uL6rH3U7wW
 mWfz/RpfYXCL4vgEfncsJtrnln4tVNb7CdIVTXkfl5lerts2f/y52/CdL90nwF0Tbt82gYXux7y
 AqM0E+/r210AJkDHwIE0qigBeqADXZlOqG5dX53XwUPak9w+MBHaSRIpYNmq1EarA01mPwzlhNF
 uby8vntywzZ5jnrVfBs9Q436W2rYpVPj/tOZMox+ASL4mx4YlD2dMAe0gwsV0X072w1cd0YuIPA
 nqybLG/jR/mqDY3l0dA==
X-Proofpoint-ORIG-GUID: cfWzqD38BXTXuahzXdHgvHF67hH1o_Im
X-Proofpoint-GUID: cfWzqD38BXTXuahzXdHgvHF67hH1o_Im
X-Authority-Analysis: v=2.4 cv=Wssb99fv c=1 sm=1 tr=0 ts=6a75b3d6 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=FFEyItaQ3BNzhykpSc8A:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608070079
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0EDFF40014
X-Stat-Signature: z5sif8iz6ocewsdhok8gqu9im8gcaoh5
X-Rspam-User: 
X-HE-Tag: 1786098648-75742
X-HE-Meta: U2FsdGVkX1/sPhecL7ag7CHqKQDLSvFRnn30x3uxwTIGCzRyV+37GAEBX4nK8Cofdzo745eCFPFfsK+SfmYud3Y/88nf55IpoWVLMsy04UtQ4Eqy44xGtM+xDtASoPupvc9VYze3IK6xsZNqf/F881bcT9KKCdtOX7pXbkaTHTnWB/hka33Pz/JdMTpWVMWgCg2nlA+R/tqUEYj094Pr/MsXhGYK4LsRFjwxBsArl8jmsbLV4hrFITYryjUPrIkxuh5qLEzYR3krE82Jx6Y1vdZ8mi6tcRJq9RTRrLS0NZRm91u9UopTTQKlbWiqm+b5MnhqCXNruGP3OrqeLbGOMaK11X2L28dCSC2kGyKj16kDedLoH9dgPZAKELK9SK6p9aDSHWxVjOg+gOldKDoWXicCUJouXlgn/HVVMryMg4F/+mlySN3Kb0YPXxcZrnHElLWJw33UDxJ63swLQytjtzM9bTfAsqfVZcLMLVArRrlRGRw28Ka74bN+EWn1BYNxAUC9hYJdnDmQ1UOGqUK/V2e9lq2PAZ+KhBtluHKb1y1bnMkEb+m3NdAVhWSG8W65I9WSzp180p2nYNvp8lA71PznChc4SQfp1qs2L03PO0iXWZPLvDptO4Y7gj2E+zbwUz/HrOod2/EQO4fZy/2X0iYdANgyfKsqEDkwKYb8lk+YMGOpgoEyKW/DXaWapgh42NvZNDebOdWBKGFToJA3C9iMm0qs6/1+kRGLDyutLztXPQX/sWLnYNlT+XD1W2PtxlMkUVoMRrJ5NGE9+dniIGdmP2NC1drXS+3RQ45NOs69Os0bqonD5O5LFYI8QvYnQEoi/x+boDf1E1R1y7pO0j7xrSJLm/f6VnP/I8+F+kYoyaFVF5wKfAyIUHug01+mytnaClHvculNNtxbGoDElISXSCIdseaf3WEE1hhi4RFrrBnSQbNjJF07QFdhSy9d9AXcdMJxqnVdz11CpfN
 5ie/8VDl
 f8jIOWbssidkoiA4be6BG1c9JIVcO7KU3vXC1Tg9RomeLQFKuJFRtJFzOaO/2fgdTK6TBKLsGpsPQDhnTKYKCh+NJNFWjNMqMsPpqtlWbUfBEcngv13zUtcBk+va4KchaXK6F1zKLZDp1D91QmYsfpXmLEnJLsRCc7tbQqsVM/L30ueCo4+D7djnkAIoy03YyDerNr17mVbN9UHXOQ7DAovgsPNE86gBrqbDA7pAJnqF6H4Dy3MClDSoqmpt4u6UUJ85zaTAHc++hMH2Rf2cHnO8Rk9er16Sf+h3H3PW7N1okkJbjX36nC8uxlGnAsfcZvH+lqoxi+0737vAc1AyT+YYOLx+LL7V+jw81IkFi9fcTa/lFh54trHhiyHwZZh5vxr5SYdLQD5xby93N2XPG92mNq+opS9mIMcfQWzmiz2JcANeDoXY2tuwzfYn7Bggx8j9t/UA+G0XkQJd5zsG+Vmg+AhMG+mXJ8nlh7PeOxpWnKcHupDB8Jwy2hddIbLYvSc2cCMuLWRPm7nQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_putback_lru() requires lru_lock to not be held by the caller,
but it internally calls folio_add_lru() -> lruvec_add_folio() ->
lru_gen_add_folio() -> list_add(), which modifies lrugen->folios[]
without acquiring lruvec->lru_lock.

In evict_folios(), lru_lock is dropped before shrink_folio_list() and
the subsequent list_for_each_entry_safe_reverse() loop. When an
unevictable folio is encountered in this lockless section,
folio_putback_lru() is called to return it to lrugen->folios[]. This
races with any concurrent CPU that holds lru_lock and operates on the
same list (e.g. via list_del or list_move), corrupting prev->next.

The corruption is detected later when move_folios_to_lru() re-acquires
lru_lock and calls list_del() on a folio whose list linkage was
corrupted, triggering BUG at lib/list_debug.c:64:

  list_del corruption. prev->next should be fffffffeead4fbc8,
  but was ffffeafeead44188. (prev=fffffffee4fc4c08)
  kernel BUG at lib/list_debug.c:64!
  Call trace:
   __list_del_entry_valid_or_report+0x100/0x14c
   evict_folios+0x145c/0x16dc
   try_to_shrink_lruvec+0x228/0x35c
   shrink_one+0x94/0x158
   shrink_many+0x1c8/0x1f4
   lru_gen_shrink_node+0x94/0x110
   shrink_node+0x468/0x8b4
   balance_pgdat+0x4f0/0x9a0
   kswapd+0x268/0x470

The race window is amplified when unevictable memory is high, causing
folio_putback_lru() to be called many times in the lockless section.

move_folios_to_lru() already handles this correctly: it drops and
re-acquires lru_lock around folio_putback_lru() for unevictable folios.
Apply the same pattern to evict_folios().

Fixes: 359a5e1416ca ("mm: multi-gen LRU: retry folios written back while isolated")
Signed-off-by: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
---
 mm/vmscan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 26436059ea39..7c4adba13e4f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4923,7 +4923,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 		if (!folio_evictable(folio)) {
 			list_del(&folio->lru);
+			spin_lock_irq(&lruvec->lru_lock);
 			folio_putback_lru(folio);
+			spin_unlock_irq(&lruvec->lru_lock);
 			continue;
 		}
 

---
base-commit: ea2bff00da89d7767d677bb68470130ba96f4928
change-id: 20260807-evict_folios_race-f3b119e0cf97

Best regards,
--  
Ketan Kishore <ketan.kishore@oss.qualcomm.com>


