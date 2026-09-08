Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF8A5C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 18:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4B386B008A; Tue,  8 Sep 2026 14:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFB926B0093; Tue,  8 Sep 2026 14:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F5B6B0095; Tue,  8 Sep 2026 14:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C72B6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:20:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF4EDA4D23
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:20:56 +0000 (UTC)
X-FDA: 85191411312.03.E0EB603
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5643FA000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:20:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="Ez23U2/Y";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=DSchCrKT;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788891654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FiZbubyoP3HtKI9tuT86fH46V4++xl/Hu2bmom4u9Fc=;
	b=ZRmJPkZn55/9HbbDdRT8Mm2zj4x0jX66vpJPmO5HXzhWlHo7SK0Mgarpqp+5WbUtfgvfHJ
	mwULa8Z8ho4PH9VSIqWXBwdyb9jlNLt9/ZPwAlHPJ9g8cx7MwqwWAnT7GLYHXFS1mZZdqg
	JGB2cEBj0b5M3vZjs/wiLviZOyQAfBs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788891654;
	b=0QS1A9plgxLeU3NI1M2S6/7JHX+jGagrugVeYLfnJW4RFWGjhzyfMtoFvbxVUfzXRr8mEt
	Xcip9fRel6rbTn+jCisZ3myITtNDPSC+T/cxKGI52kyNlH536HR8r4HDtKLo7x4k+YB1qX
	rw33eV0c546F1pM8svK6T0YCFDEnsWA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="Ez23U2/Y";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=DSchCrKT;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688HvZXu2919531
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 14:20:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=FiZb
	ubyoP3HtKI9tuT86fH46V4++xl/Hu2bmom4u9Fc=; b=Ez23U2/Y92kvNjZkkMvv
	Z0de8+cWkmWr0Ru6KQ/R90lpdG3zB1/Vq9ydz5ed/hXdK8TuO/qX0RQWhwriO2ts
	kEFE5uhYhgu4dP5YvFYgK0ce5Fqn3STMa9VW4tkrxu92pr1xNMFBItCleGsIg76E
	MKbqMEc3YS1aqsvMjqDPTe/KY4geTohctvlhV9EalJgYohlfrhhdaqf3+P+3aP9d
	AijG4i6Om5AgOaJeGclSB5CIUSSh8y4dXeZxCgMjW+UvVnOGVifTEEfdAaJhBK6D
	M0UEkg+eM4j6yIZX4LOVV+oRkz47aTFSYh9IcMLv/cMC1qVitVAfxsJPrBsqdlI4
	5w==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjnk09ayx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 14:20:52 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-9105be46009so33031256d6.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788891648; x=1789496448; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FiZbubyoP3HtKI9tuT86fH46V4++xl/Hu2bmom4u9Fc=;
        b=DSchCrKTBAJ5btU9WDuUz42aje2Hdhm43ErSbM3hvIi8RPQlcKfoAvP7Jed01iZqes
         uHGcjDSE5FNKK3PsrTcB2JgB/RrV2IUIAnRIKUzRLAp61GQzFPn5lTp3+coDNx2czAuN
         aIpCIrnBqvkxbpE4Wp6DP13ShE8HGJjtQUfl6R3j733ZyBsVcfTDARdoSRAHXAWxcpS3
         wQPVaTDTjE1mHoSd9XxhXmzqXvUiX7p5hFh8NHmxx02SXY7O8IOKzq+idG5b804i8fgB
         rqeOmGQGRErDXSbj0uXTqAaRmWbEBBFiz3UkBfyaRUFkjdK6WFR4gLEyMwQq/pYm4uMc
         gogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788891648; x=1789496448;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FiZbubyoP3HtKI9tuT86fH46V4++xl/Hu2bmom4u9Fc=;
        b=oRj2d+PLXqRvWzzjMHWStAu/1t86YthOH48ntVarS9guM0zmo1y4trlJ78UuzdV7Ur
         xeJAXSNLUEliY1eF2+oCvzOSAwMgT+JseT6ud7ge8UgrLs25/e4jZdUqa3lTbbt7fHZV
         ieP+fy/JeIRAlajbP+Hj+a3fq/cLJpTmkxgzvJnHn/lmYBqK7+53aC/jz6mZAU6GFcub
         v7bJY3wrbJDIQkpertAwwOnopSmk7X4ACrwzFp7NIvwFo81GtjADHH87xLxKlTWTpJx+
         LsGz1rrF0yOCx+hzNCmsyGetuTApuoC1KF1Z5Cc1ooqjgsDAuslQvs20g23WgzZIqwxV
         N8Bg==
X-Forwarded-Encrypted: i=1; AKwUvBz7rUYT0Fl2sIxt6EGare0zzzQsj/mYy53LCzsI44echHaxRH94O7/JhsFmPOxSPPHGpO8lULJ2Xw==@kvack.org
X-Gm-Message-State: AFuF++l5+PFjFEx0OOpaPtfGHuOdEn7Of3uRp/Gv0mS6zgFwYxz3OggB
	ednOLclJgO1LdgkFcHAmDP8VIHNDpThXHQ+E2QazTTmyXdbQh+BBAQLsYkMlPvNAC9oHnm9Madg
	5iLoeVdqI37PtW48dK0a84dK1weeRIDrJre5dCjUunMW2mqQU
X-Gm-Gg: AYBFou344/UwTB7KZBhC2AgRiaj2+u4SSkBy4cFFGgBwdi3J6aBESo381FgesXNVm9x
	ErHg3AHfHM2xuB53dpeiTgpYJgt+Hgx6OblfjDSuoOdBTsKI5vFUCUmEKq504g7chSGYoa1zQ81
	iW3Xnr3BJHs/4LKeMqWwCsjgUOJqZveG/90u3blQh0O+79b/HhSsno5Rpf3XV3fuahYeVh4Yo6Y
	fOitlBJ/V1DLTRZlnv6ljlz2mGZ3LIu1E+6i3fbijLCHcabwG3QZr+ygW1bUPqeaeTM/bz5F5Qc
	606fJmWqCUjMN1cRtMHcoO58huuTjCfxOT+fuDa0aqhj842iAZrClr0IMUz348dK3e0KF8BnnfG
	JXiuHmuAkKWOiaFJFEA1BcG8b+kw4s9mDl+wsqJ7yKQ7DME3W
X-Received: by 2002:a05:6214:130f:b0:8ef:74ad:e62b with SMTP id 6a1803df08f44-91061f8ef49mr103030606d6.7.1788891645893;
        Tue, 08 Sep 2026 11:20:45 -0700 (PDT)
X-Received: by 2002:a05:6214:130f:b0:8ef:74ad:e62b with SMTP id 6a1803df08f44-91061f8ef49mr103024766d6.7.1788891640717;
        Tue, 08 Sep 2026 11:20:40 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9104059559dsm123354136d6.1.2026.09.08.11.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 11:20:40 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
From: Tal Zussman <tz2294@columbia.edu>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
In-Reply-To: <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
Date: Tue, 08 Sep 2026 14:20:38 -0400
Message-Id: <178889163877.1334491.3646957026033534678.b4-reply@b4>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788891638; l=7108;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=9To4jbmxVaHU3YyuLHtldfm/+1dYUB3KmBeKEkAyIg0=;
 b=dhSBI6ucL59FpBAGiQbj7EbpiPEM0NTxKglQM2e+fxAAMJcz6JHiE6WPjaSAL4vYEtNdtKSfh
 Xc+ZbX2afaGBA+BJy+LCqsbdKeZjC+2iag0hd78rs0jseRBBFMBDBNT
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE5OSBTYWx0ZWRfX9df9Sd477OCp
 YbGPLQRuGfuvzOUQ+4Pf3FldDhmYPW0L6eJSLjYaeyDTNQRFspUDL/FgvqeXlQXVTQRR8W3drth
 lSBqD8SBanpHUJEvvm4eSELQDOyha9L0LQ0lk83ks57fgncQ5F70
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE5OSBTYWx0ZWRfX09TkoSgB6Nkr
 O9V41S9syz0+vR6pHzhOVm1AiPCvEbs4I8/8YhndGlErwBI97RkY6G3CcID0S6zlZB+F4at/ere
 px8dsMnktKoOwFPJtdCayzOqmkLOecl1v44/MXcz3cjExnNHX2bBGw/YI3f9nBGyfJeZK2WmrRd
 uOdTOnB7BvWQCdJji6uZOXGEw5Pdq/7+RUcNbFjac1laEKGEpygIO0lrK61UfdWqUI3DkGtQfFm
 bm5uVfb9UgL4+3wLKDAnHA9ccHIomg8u77uUFyo7gMYoFF2tL5fBAQ0QjwrkXn41xaXXXT9kTPT
 qXJLgV18UUF8z/30bRNzh1S0/9qe64dfX/qdx1965OoRavbtQcArM5qh8v2l374i6vHGahsdLnp
 OgBTPR5ZsV+xQCU0Cbp0Z4BcCCqyExfPFpxMo8cRMZ1EwJR+zuTSslZAZrura12CaHPvOxr+dEW
 C2NX8GCi9ZvMWNGpPSg==
X-Proofpoint-GUID: InLQjUZqIOYN-0JEabV7Edhvfzbvsbqn
X-Authority-Analysis: v=2.4 cv=Z+fc2nRA c=1 sm=1 tr=0 ts=6aa05204 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=VwQbUJbxAAAA:8 a=FP58Ms26AAAA:8 a=Ikd4Dj_1AAAA:8 a=tbrFcHqVj0uyXfjc5ToA:9
 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-ORIG-GUID: InLQjUZqIOYN-0JEabV7Edhvfzbvsbqn
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1015 bulkscore=10 impostorscore=10
 suspectscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=10
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080199
X-Stat-Signature: kgqbyxpfo9rx4xr88uxjaj9awnccyni4
X-Rspam-User: 
X-Rspamd-Queue-Id: 5643FA000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1788891654-506038
X-HE-Meta: U2FsdGVkX1//B6WQQfXiBanqSUrQs425t6a4C/NTTbp4q9/y4xKIrzveBE8S6HwES73D+enG95XOpDAF+e29u/UkVWfbdY+gdWEO+LN1sSg8b7E/0JH6TSKaVEILU9v7yhwtSY+7ct1sjpGPBzBD4UVCyiji/PW8UgsIk+hmdxAQya36esGDKuL1eiB43FDvSP8FhjfQpQrN1pRZDRpY9fZ13UcHC2fYkVf9nw8lSxGo3AkgvMWK2mxixQIoqYTbQDJWTztfMNgt8Rsypi6RyzdTJEdsg1qAT368I8QhH5VXpJTJPpdxpandhPcNF695bfq5qVGTB4jYyvOue8YCiq04RkAdKT0ecBMNmuuf8yVp1fq18KDf6VMCp4Xg6hPjfQ+b8vYojllLKEgAAABTLL9SfMHTk6ZL40JAYF9yFG62c6EmF4aQL3ITjSeCCyUzFFWnX3w/yc/HFCEP+LsdQ1fbVGIfGO36Kl/zaSJym4Y2sKmeiQH2LeVVs4XI6qyJL1CG8LxYAY27lLWpgW2UD8jWzx0taRUNmd3j6QuiVrEbBrLFMY+thKJkjWzq/Ur54s3n6gSaqEFtjpcjk3yYcAYHuJe3IPh8xBWXuKnGoQDtUEUMnKMt/ctvcuaKgRg/voKIdjPIaNu5t2ocBSSLMy8gGFGyqaHybHENjc++mq6+zV7xCA1vzFUNBXLtzARPIIiARZGGiA8TyCVsWM/dbzK7HvDcvIhaujypw/SRP4iSZcoqRoVgWrCnFFzo7cY/lRJeBz51aMTufeK/dMITk6ilZ3NLOz4ANTjwAJyatW9gJZUDQL4S5nSYJx8L5HI/r3q34y7tx0h3uYdAYp1XP/j3WPi9GfgxVhFNojaqhr8HACf2RqVmPfjEgH0L4BCw/+yyaBzfWdYZAparyzI6sC1QV7M7BxbbAyl0EEEj0BkfM8vsw5Zy47TDoHDXWZyCcgLbjj2qbk21pvSrrJA
 pUnmSRvr
 lEMHPry6CubEOImJFofPMdMwOoom9jMpN7z1E4KkPQKUlfUSvtsVGAjCHrXKMo+RMwOUHi5hYo3V+z/GDsjL0V+SXUASwYcSZoaRKqADQWWUfLNLIrlQq6RaKbGKDvdMbm7RVDsm6i5PfsfTAGGwrMYG5+cwmxeYtXjn6svwdv64ntURIy0sXAcbzAJ13SGC7227a2NcpKQMtpIeOLygkwbjB7DlpcVqylOl7PDdwD8dBoQ4+LrOIWwScWpTlIDfeBV7KrBaHelLQLACL3HTHGCnlccMkOiVfBphA5vcvGd1W016N2AddfHSA/oGhBErQmW2GQYcgS2hNwFk+u10YrBtuuo4wW8x9WZME8zyB07ddpBqqUVkMk/mfAk8f+UorzDR0CAgHaVL5LvPltPcuj2xgnp2od0zyQCnMuEOPpQGj+fxd8xAePCb7u4OfEX24y+YXBUqQOHwMAGRBHPimPoLZy0Fa0R6XfnD0MuNjKJTUm5A7ySsTEp3cJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-08 17:47 +0200, David Hildenbrand (Arm) wrote:
> On 9/8/26 04:56, Zi Yan wrote:
> > f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
> > page->private != NULL is equivalent to checking PG_private. Change
> > PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
> > page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
> > but it can cause confusion when PG_private is removed and
> > page->private != NULL is used instead. Change it to initialize
> > page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
> > semantics.
> > 
> > It prepares for a future commit that removes PG_private.
> > 
> > No functional change intended.
> > 
> > Assisted-by: Claude:claude-opus-4-8
> > Assisted-by: Codex:gpt-5
> > To: Jaegeuk Kim <jaegeuk@kernel.org>
> > To: Chao Yu <chao@kernel.org>
> > Cc: linux-f2fs-devel@lists.sourceforge.net
> > Cc: linux-kernel@vger.kernel.org
> > Acked-by: Usama Arif <usama.arif@linux.dev>
> > Acked-by: Chao Yu <chao@kernel.org>
> > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > ---
> >  fs/f2fs/f2fs.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 9940a6cecf1a2..2f7ab5888b078 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
> >  }									\
> >  static inline bool page_private_##name(struct page *page) \
> >  { \
> > -	return PagePrivate(page) && \
> > +	return page_private(page) && \
> >  		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
> >  		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
> >  }
> > @@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
> >  }									\
> >  static inline void set_page_private_##name(struct page *page) \
> >  { \
> > -	if (!PagePrivate(page)) \
> > -		attach_page_private(page, (void *)0); \
> > -	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
> > +	if (!page_private(page)) \
> > +		attach_page_private(page, \
> > +				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
> >  	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
> >  }
> 
> Very weird interface. Why do we even need the page-based interface still?
> 
> $ git grep -E "(set|clear)_page_private"
> compress.c:             clear_page_private_gcing(cc->rpages[i]);
> compress.c:                     set_page_private_gcing(cc->rpages[i]);
> compress.c:             clear_page_private_gcing(cic->rpages[i]);
> f2fs.h:static inline void set_page_private_##name(struct page *page) \
> f2fs.h:static inline void clear_page_private_##name(struct page *page) \
> 
> Seeing code like:
> 
> clear_page_private_gcing(cc->rpages[i]);
> if (folio_test_writeback(page_folio(cc->rpages[i])))
> 	end_page_writeback(cc->rpages[i]);
> 
> Makes me wonder whether we can just use the folio helper instead?
> 
> In f2fs_iget(), we enable large folios only when !f2fs_compressed_file(inode).
> 
> So naive me would assume that we can just get rid of the
> set_page_private_/clear_page_private_ stuff entirely.
>

I have a WIP series of ~30 patches converting much of the remaining page
users in f2fs (including the below) to folios. Still have to do some
testing and clean it up, but hoping to send it out in the next couple of
weeks (in the hopes of eliminating some more folio_compat.c functions by
next cycle...)

> IOW something like:
> 
> 
> From efcde918178604de11d16c6dc5485542ab4dcdaf Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Tue, 8 Sep 2026 17:46:06 +0200
> Subject: [PATCH] tmp
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  fs/f2fs/compress.c | 29 ++++++++++++++++++-----------
>  fs/f2fs/f2fs.h     | 13 -------------
>  2 files changed, 18 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
> index ce88092d9ce26..0e9cc0fa297a4 100644
> --- a/fs/f2fs/compress.c
> +++ b/fs/f2fs/compress.c
> @@ -1064,13 +1064,15 @@ static void cancel_cluster_writeback(struct compress_ctx *cc,
>  
>  	/* Cancel writeback and stay locked. */
>  	for (i = 0; i < cc->cluster_size; i++) {
> +		struct folio *folio = page_folio(cc->rpages[i]);
> +
>  		if (i < submitted) {
>  			inode_inc_dirty_pages(cc->inode);
> -			lock_page(cc->rpages[i]);
> +			folio_lock(folio);
>  		}
> -		clear_page_private_gcing(cc->rpages[i]);
> -		if (folio_test_writeback(page_folio(cc->rpages[i])))
> -			end_page_writeback(cc->rpages[i]);
> +		folio_clear_f2fs_gcing(folio);
> +		if (folio_test_writeback(folio))
> +			folio_end_writeback(folio);
>  	}
>  }
>  
> @@ -1078,11 +1080,15 @@ static void set_cluster_dirty(struct compress_ctx *cc)
>  {
>  	int i;
>  
> -	for (i = 0; i < cc->cluster_size; i++)
> -		if (cc->rpages[i]) {
> -			set_page_dirty(cc->rpages[i]);
> -			set_page_private_gcing(cc->rpages[i]);
> -		}
> +	for (i = 0; i < cc->cluster_size; i++) {
> +		struct folio *folio;
> +
> +		if (!cc->rpages[i])
> +			continue;
> +		folio = page_folio(cc->rpages[i]);
> +		folio_mark_dirty(folio);
> +		folio_set_f2fs_gcing(folio);
> +	}
>  }
>  
>  static int prepare_compress_overwrite(struct compress_ctx *cc,
> @@ -1477,8 +1483,9 @@ void f2fs_compress_write_end_io(struct bio *bio, struct folio *folio)
>  
>  	for (i = 0; i < cic->nr_rpages; i++) {
>  		WARN_ON(!cic->rpages[i]);
> -		clear_page_private_gcing(cic->rpages[i]);
> -		end_page_writeback(cic->rpages[i]);
> +		folio = page_folio(cic->rpages[i]);
> +		folio_clear_f2fs_gcing(folio);
> +		folio_end_writeback(folio);
>  	}
>  
>  	page_array_free(sbi, cic->rpages, cic->nr_rpages);
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 9940a6cecf1a2..0cfba8742d4b4 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -2707,13 +2707,6 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
>  		v |= (unsigned long)folio->private;			\
>  		folio->private = (void *)v;				\
>  	}								\
> -}									\
> -static inline void set_page_private_##name(struct page *page) \
> -{ \
> -	if (!PagePrivate(page)) \
> -		attach_page_private(page, (void *)0); \
> -	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
> -	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>  }
>  
>  #define PAGE_PRIVATE_CLEAR_FUNC(name, flagname) \
> @@ -2726,12 +2719,6 @@ static inline void folio_clear_f2fs_##name(struct folio *folio)		\
>  		folio_detach_private(folio);				\
>  	else								\
>  		folio->private = (void *)v;				\
> -}									\
> -static inline void clear_page_private_##name(struct page *page) \
> -{ \
> -	clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
> -	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) \
> -		detach_page_private(page); \
>  }
>  
>  PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
> -- 
> 2.43.0
> 
> 
> -- 
> Cheers,
> 
> David
> 



