Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BCF0C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F446B008A; Fri, 11 Sep 2026 13:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326CE6B008C; Fri, 11 Sep 2026 13:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217996B0098; Fri, 11 Sep 2026 13:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC1DB6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:10:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8ACBDC0301
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:10:51 +0000 (UTC)
X-FDA: 85202121102.08.E6953A7
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id D70B4180002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:10:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=FzBEV+AC;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=I+r8FKMT;
	spf=pass (imf16.hostedemail.com: domain of ashok.raj@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ashok.raj@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789146649;
	b=05iiDrcA1xFVa9k20NEkzDNShzHAVGSjvtMYx+c8/s3YJwkAK9PbQtRuZCGX8F/n6+g/2a
	NqcsZZm6mWgUc19JetatLADNOvxngnK2ASEyF7ghI5d5CPXIEOM36MUfcgardKmiBiSftD
	geQNWCiyEj2bJhFUWu4faGEZT8NgEUc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=FzBEV+AC;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=I+r8FKMT;
	spf=pass (imf16.hostedemail.com: domain of ashok.raj@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ashok.raj@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789146649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43JV2CT34ywMCqvN1NXrOAtOdXSh1XmrnXb+Ch1XFq4=;
	b=zefmNnlIQYcUPFzB+0THfmAEbkm2h1/w+V7qknA/7iwufJNcw7ttGf924K+sgYDIKm5xmf
	n12mb204G/VPZzm9qBI0oB9+vLp5BmoNdb9V9PiQLtuVNOUIieZxeybBLnfNzB13z5sE1U
	Ty91eeRDVt0dQcdDfZr/5QLr2JBMjuc=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BEmEYQ3780630
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:10:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=43JV2CT34ywMCqvN1NXrOAtO
	dXSh1XmrnXb+Ch1XFq4=; b=FzBEV+ACGiWF9U3C+hHFMycemyMOgnt8Heo9eeUg
	Xk1dzhykslO7j3yYf79ye1NNrPoGwkZnCbXssagGG/hb6b3Ikxzsw48UiQfMAP1d
	VM8HwcnEnKSdO16IIDZR2rhE8c6fTuSenrhs5zFgwrbee7EHmmztL88hcC9pbrVJ
	tuPsu7g1u440kKLrjWHNLHGpI9TTVNKQFlxRzhaNgEUqWhNJysC7GRf0YZI5gK/w
	gY33dg5Qd+S6Lb6FlwIJPflwEroZRdMXOLJZqHKC+fYewR8giBbmGfCyQ2gtJMdw
	ToM77AlpTgeKgVYll6O/OvNShehart6d8M6SEYoTVwwPkA==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmcgfjm4r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:10:47 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7f4e9fe8b17so1321175a34.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789146647; x=1789751447; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=43JV2CT34ywMCqvN1NXrOAtOdXSh1XmrnXb+Ch1XFq4=;
        b=I+r8FKMTx5yyDQDN6iE4wSAoulg7iu/JSyqjh2RKp40vl1ejbX2t4+LQqiAu2wDgfj
         K+S/qRDFOXn3KMJBAtI2KbgEuBen0MsGNCB+TVTk51Q+mqch86AipkhVlEqIr2n0vFPI
         lwDU7Ba46aRN19N3cOAyeaWPgcPnzZZ3aCSPj/vsSvINENxsjM4H7CW3IhZ1RYlPjZ9S
         V0Z5b1KpuR3wl0RJITdgSgGn+3Evc+HSCOMN0D9Jj4y41BwSqcKp30BPHUMmt96Ki4xI
         CH2RYne2Rcxgdb8azPKf/Z07xLkpCC6pB5ZQmCHKcgH5uVQiymqs2PWyfo6O/nXNJtPD
         JNUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789146647; x=1789751447;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=43JV2CT34ywMCqvN1NXrOAtOdXSh1XmrnXb+Ch1XFq4=;
        b=INaK63C79MYdBRO+hZlL+GyEvFCSZ8abSVh0hlCEb/hrrGe5I4bqtAP8NpMGEmR575
         14kKwmIKwab2tPqwQks4hLErTEBpWgUQJJ5LAAalGVerjiwfbdKZZioFUIyLmJROKgn8
         SJ+yOjJmJXVXf8Qmck97Rb1zBiHiXArLNVa15XjMtkeO9GT+v2XfGu9FkhA9pyYYQXoG
         3Przip43C1ngno23l9QMutbmPUJtnyYEvsZJE1lMeLJT50keqxYmwCjwKj686rm3pptU
         uVa6p5QOFt/o9WxAGkrSP2TcBdHplkCSoK9GArBCCLbFbPgFjDJoJ4H4nUAD0DFloudP
         dQuA==
X-Forwarded-Encrypted: i=1; AKwUvBzUqu1aXI/X/YitCQi56bccfWK/mMFlLyxTo7u5qgF/UQu24H+9FdeChveJYVzBQ/41L6TaDAApiA==@kvack.org
X-Gm-Message-State: AFuF++nAIylwGqMbDywR6FeKW5b9hRIEXiWNEcYTg9vWTjoKGwvFK1Xe
	/MoRacvVQf8w4nbvTrbY0zjkZ8ejrzj+z/FX3GRro3fZeXzyJtwrqZT8Ark9Jzbq6JVFpZIYO8c
	hqhTMc3vN9GuSXS+0tcsV8K28gg8NAjFShGSl+tkFuzTpkgfJJDrtcQ==
X-Gm-Gg: AYBFou0skqbBRqPZk/MMKTnle9osVq0sQOKwW0vKhCnNxtPWK2FjLejkVlR0giMIhrw
	AQp4SPzsUN7xMWRQIcOhPUdZ172XAdModSCn+AEGC+IFGj+j+iTzNFwF3eQ6qyQ4iWWPSZmfpux
	DHBuh30d6LaJLT7TFGdIFV08Jx4FpoH9DJF7kPpupH3iqixkbtdL7GxU8HM2p7dfghZ3pyjVSh0
	LI3wzW4pe67Cqm5nGSVT4n9Wr4/RQI5SrN79vlEkDNUHtaSDfZp/R/C59evjmrGuLqSeFe91UCq
	A3+ZcZo8ZsCz+Dj1VHi2t3nLEeNVDMm0LLn+wo2aa6vjxUWdQ+kPDZ23Sx+USp/HBNMjIdIJMjQ
	T17wA+fDxdOB08UBS8XqeSdlKLQe5jtsKidQ++kP/jc+330iRPg==
X-Received: by 2002:a05:6830:81cf:b0:7dc:df37:844b with SMTP id 46e09a7af769-803fadd1e9dmr4468521a34.4.1789146647047;
        Fri, 11 Sep 2026 10:10:47 -0700 (PDT)
X-Received: by 2002:a05:6830:81cf:b0:7dc:df37:844b with SMTP id 46e09a7af769-803fadd1e9dmr4468492a34.4.1789146646681;
        Fri, 11 Sep 2026 10:10:46 -0700 (PDT)
Received: from hu-ashoraj-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-803f59ea2f9sm2763387a34.9.2026.09.11.10.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 10:10:46 -0700 (PDT)
Date: Fri, 11 Sep 2026 10:10:43 -0700
From: Ashok Raj <ashok.raj@oss.qualcomm.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
        liam@infradead.org, maple-tree@lists.infradead.org, linux-mm@kvack.org,
        jgg@ziepe.ca, kyle@mcmartin.ca
Subject: Re: [PATCH v5 0/3] iommu/iova: convert from rbtree to maple tree
Message-ID: <aqQ2E68lmU3Fbjsk@hu-ashoraj-lv.qualcomm.com>
References: <20260818152505.1057922-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260818152505.1057922-1-riel@surriel.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDIzOSBTYWx0ZWRfX8Hor6x11Ee+f
 d16IiTfttHrc2g9/aiQMMWAUyEI0wayDSa/J63lkBHGXO6cjhyWHx8IfrKwGOyQZ/WHPlnpjEM9
 78xdjh5nLiPD3avkJ1U+kijWhiqCwn3lkuxfwrxRxtC7Rl5g1vohdtcGPsd077zt/yRltTzia5U
 RMSn/GnwOvizVSZC/i79p/hZoJDaoa/+8xs30Au75Iyok9wE2MAeBOkEggDopYODg+vlOoAZx6U
 aS7xZ9D4A0S0ezgHzCUWS8U4mBdHJ8b2qE9j0tyhcG3Uc0qyLFtD51POrWlP126RLplXzKAMlXc
 p50BkCnN3gCrG+G80zQxqkklI6s4mPnRjWQQNvuX2/ZGpM8LrWanhOMS1tCcRqOao9HyTJhOMSr
 JsYTlUG7UgHFmPwwnr0ak36sLhNYGmEVunLeopGmzrVU7TqubzQxtfs+h4uhg8hqYsSt+2RvPSo
 jkJX5l2D+fnjkgKW4Gg==
X-Proofpoint-GUID: HplCTdFRXSTCik2eCXiQ_7AYACqfQNwt
X-Proofpoint-ORIG-GUID: HplCTdFRXSTCik2eCXiQ_7AYACqfQNwt
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDIzOSBTYWx0ZWRfX0pBx4ETxAoUF
 hQlXfXIvJuRrO3oh7Ad4DEDCegqvDx5t74b9cXiiY1TqAAkZllelcwURw2/YK9U4koqLQsrfrSg
 E4mir/uYSUuRiAXmBBPCM+E81sqe1EM=
X-Authority-Analysis: v=2.4 cv=ULtIjyfy c=1 sm=1 tr=0 ts=6aa43617 cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=fwyzoN0nAAAA:8 a=EUspDBNiAAAA:8 a=nI-UuXyqNnj8uUgxqL4A:9
 a=QEXdDO2ut3YA:10 a=Z1Yy7GAxqfX1iEi80vsk:22 a=Sc3RvPAMVtkGz6dGeUiH:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_05,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110239
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D70B4180002
X-Stat-Signature: qx99gepeztzjwcma7ejdfss98oao4xgw
X-Rspam-User: 
X-HE-Tag: 1789146648-356141
X-HE-Meta: U2FsdGVkX18GyeWRWaUUGHVBGXS/HBQ4tIf+WEoS/EWpiX3AIQm8rpsqf4Wp5qxQT5sLeT/PckUCaUYAupjAxC9X4OH4T5T3lBqT/dqb5XqgrSViZyaaN7KZJw9xeuwLKNUf+DmAbcSfKVc7BhgxmEaWwrvBHTEAqDFqeRcxs/XmWPDtDZSpz61Dses1z42AO0HyiSarxujG4E+WgrB5KYN04frPV+yIYOiPimCw589vTdYHLBcMKr6pT4ZnvgwoyhSOFNliJ7HlAI+qKWVDrzLnGBsggpogoeZAk32I98WbPAJFyARHCZV8KRXdN2cdEy1QIMD80n4p5UbbecqwDxsRCT6Es5xu/Tq8IWsgWY46QO4YHHnIX37WrelEluiGqyNes3X8n9Jetj8Ir372HaERF0U8g90+uPmNK70EhinwaKhxsj/SiyWi3/0zLAhi2vPs9FZX6JXQnEAmW+Y1lKNHtE7w3xSrPrC5YwAzABkW50wH6hFtYbxSv3hT9e7uVBakWqudb19xE4Xvjp6twyO55LmqJh4auNGhUaXyD0/P3EQBXg14kZIKlktUTc3hoPQB0xj3DJuvnFmwuLyZYspqOj9+dl5JbEaUpj6/2VGY2Z+fz8U1XooeLq0MPRkD5BJeUCSaX/mXPJPZzxTPJHG3xN8UiC70Cfg1C5liJiFqMLheunBXsLyTtSQSv3ZexTDr5UtQt5szIA8LNfNuUKx6gxT/0qno/jC11pWyvX6pvNM/uj7w4z66VYLS5C+T9k7/Us5fNAlAIq2X28zc9owR5dltiXMt0jv2EHSaPrDrHuXl8AQi0g5Jz1jBVTYgKeK1sbO4D/ik2lq3BV03T8edtFO3fKJOec/bL8GMLcCtHntcoflLyaVPIHt/a11KACKAjDRxbSVE2tATsBBdJwfLneso7kBj9Dv5TRNqnxPd2eScE66wAtCkeiYwbs0lQOrLaQi3O1VcU3USlQH
 6iRynMgt
 0qenIgJA3ey+RK0rpEsnPDu/eQp2zS7NGCJp8//YzGP4Nda1SmAR20DRFO7OZ5LmpVHNiCKUr5y6TkVcmhKcfyS9K9yCJKTL0hGe2XI34Eejl+uFwf6qaIV0HVb6tw4H4QsXHC1L+u6qm9WlvJ46Bg/LXAjE4B0cNmmsPnITLIdvnqSWdbnceuFe+GCL5JLCZXFLatN+KQhCXSxsQ171C14+Wssf8HWyXRz2bCkV/XxhfbbXVF0FHyOEuSsc/8VX6OdJMkOg4gQqhqJ31EBnZGlTC+BGgXV43OM4NA1J2ZuEkfVYQe98e0wgZWlb/EXsRDMLMaX5BnGgkNSI9TWCdAd5BbVhWyORt+PFIqRqrlalYhDlVZjmuKtzR+FQkiug5MOZS5P5CLWwoQ188DCEwX5Nme/5zb46CLi3zx8NovD+V4YCZ1pEabsWBqA036WVRCpE2NM7/zzZKQa9JkGNIAdb/SC5rmfSAiT36GJShT1m2RPfryBmlyx5/O201DA9/6BbONR48hI68gZNOQiq+zMUyjif8MWlpa5Lu6KqzP1lriQqhguHFtl50nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 11:25:00AM -0400, Rik van Riel wrote:
> Occasionally production workloads at Meta run into the linear search in
> alloc_iova() in ways that cause real issues. For example, when enough
> CPUs at a time fall into the linear search trap, systems have been known
> to get stuck for so long that it causes soft lockups.
> 

Something odd, except your cover letter rest of the patches are missing
v5 prefix in your patch? 

> This series indexes the iova ranges in a maple tree instead. Its gap
> search makes alloc_iova() O(log n).
> 
> struct iova loses its rb_node and shrinks from 40 to 16 bytes.
> The maple tree keeps its nodes outside the entries, so total memory
> use ends up about the same as before.
> 
> Patch 2 handles the one thing the maple tree does that an rbtree does
> not: erasing an entry can result in the need to rebalance a tree, and
> allocation of maple tree nodes.
> 
> iovas are freed from atomic context, and GFP_ATOMIC allocations mean
> the erase can fail. When it does, the entry is marked IOVA_DEFERRED
> in place and the struct iova is freed. The marker keeps the range
> reserved until iova_drain_deferred() retries the erase.
> 
> Ashok Raj asked on v4 whether the marker store can fail in turn, since
> the WARN_ON_ONCE there reads like error handling for a case the comment
> claims cannot happen.
> 
> Code examination shows that, with the current maple tree code, the
> IOVA_DEFERRED maple tree store will never result in an allocation,
> and cannot fail. This series adds a test case which allows us to verify
> that maple tree property continues to be true.
> 
> Only a corrupted tree, one no longer holding the iova at its own range,
> can reach a store type that allocates. The WARN_ON_ONCE is more of an
> assertion than a recovery path.
> 
> Liam Howlett's "maple_tree: lock checking and clean ups" series adds a
> WARN_ON_ONCE to mas_nomem() for a GFP_ATOMIC store under an external
> lock. This series is external-lock and GFP_ATOMIC by construction, so
> both stores would splat if that lands as posted.
> 
> Liam, is the intent to disallow that combination, or to flag callers that
> cannot tolerate a failed store? The iova code handles failure on both
> paths.
> 
> The code was written with Claude, and nitpicked by myself. Don't be shy
> if there are more nitpicks remaining.
> 
> Tested with the KUnit suite in a VM, including with PROVE_LOCKING,
> DEBUG_MAPLE_TREE and KASAN enabled, and on an AMD Bergamo system with the
> IOMMU enabled. I know of no way to reproduce the linear search soft
> lockups at will, so that scenario stays unverified in practice.
> 
>  drivers/iommu/.kunitconfig |   6 +
>  drivers/iommu/Kconfig      |  16 +
>  drivers/iommu/Makefile     |   1 +
>  drivers/iommu/iova-kunit.c | 544 +++++++++++++++++++++++++++++++++
>  drivers/iommu/iova.c       | 561 ++++++++++++++++++++---------------
>  include/linux/iova.h       |  21 +-
>  6 files changed, 901 insertions(+), 248 deletions(-)
> 
> ---
> 
> v4: https://lore.kernel.org/r/20260624030853.2340880-1-riel@surriel.com
> 
> v5:
>  - subject prefix iommu/iova:, matching the file's history
>  - put_iova_domain() takes iova_lock across the tree walk and
>    __mt_destroy(); without it lockdep reports suspicious RCU usage,
>    since a MT_FLAGS_LOCK_EXTERN tree checks the external lock
>  - explain why the IOVA_DEFERRED store cannot fail, and check it in
>    test_marker_store_needs_no_node()
>  - deferred erase is now patch 2, the test suite patch 3
>  - rebased onto v7.2-rc8
> v4:
>  - reduce the size of struct iova to 16 bytes
>  - simplify the (hopefully rare) remove_iova GFP_ATOMIC failure path
>  - test case for the deferred free code
> v3:
>  - switch to maple tree (suggested by Robin Murphy)
> v2:
>  - clean up selftests (thanks Jason Gunthorpe)
>  - drop the search-with-alignment, since most iova requests should be
>    of similar sizes, so the worst case behavior is unlikely to hit
>    once ranges are excluded by the augmented rbtree
> 
> base-commit: ad8d485e665829ecbf3c97b22ce251f8ff5f8037

-- 
/ashok.raj
ashok.raj@oss.qualcomm.com
Qualcomm Inc

