Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D1D3CA5FFF
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 18:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99CF16B0088; Tue,  6 Oct 2026 14:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9271C6B008C; Tue,  6 Oct 2026 14:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7426B0092; Tue,  6 Oct 2026 14:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 528166B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:20:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 182021601F3
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:20:09 +0000 (UTC)
X-FDA: 85293015738.18.72948BF
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 61AFEC0003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:20:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=I285338H;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=cZLnTvYj;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf22.hostedemail.com: domain of ashok.raj@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ashok.raj@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791310806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eErMTVv+GI4Tv4XbuyvCgn3LWQksVnWHpw5fdcoGEqI=;
	b=nRzCkVZUrcKMpnP/ZLBh4BPAOjResZubCYrx09Kb9cbAnhfu/TsXNOlp9gLvzK7zACWP5T
	G455WP4ga59LvV/aq9QVLjsd89yKZ0UhKeH+PpcwmMqOJVQAN/1m/s9sogw9V0nm5+J7MB
	7+tFMslFNQGiJGLvr5JvNSGdt71vq3I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=I285338H;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=cZLnTvYj;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf22.hostedemail.com: domain of ashok.raj@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ashok.raj@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791310806;
	b=nPB0SFZkulVyIjWtOOs4zSyBmYQJAw+RZzmRxrbSldCx+50uDFPHMX10pU6gmJa02LtwL2
	0by79DzowowYvDpp+D5pLl2W5K67DCyzSL/+a3wgyrQeGsLUco5jk0/3V9IzUqV7vobiHN
	75CE1roUR/Rz1Fkz/0ZkjsdTAM535X0=
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696HetMk1499677
	for <linux-mm@kvack.org>; Tue, 6 Oct 2026 18:20:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=eErMTVv+GI4Tv4XbuyvCgn3L
	WQksVnWHpw5fdcoGEqI=; b=I285338HN6WS3wZTHKFiclQi87+58QmBhveu9Oaa
	PirLWkvMUxQq9UvUOJUFIolv122tUDXOUsE2Ugw0sbxN2xK3T6NtgIcUocti9/JO
	7zL3yfK9ZvPTjfcY/t7ETBBvxtrbwWwAvt79vZizt4yyt4S/gSym3vBxwvikiJ55
	JnnwprW3rdM7rM3GKSy2EZTo3n+YrFr1/GgvJtZ5JU2XIN8edDF3+I7woCzQCyDv
	9hLMhqokP0+KLqFq/UwL5A7uWW9ug59X7o0dk8rUrMz6vXVTdPgb80ezqbY5/TIY
	3D067Coff3bBeq/dJzDuRhvapbZQs5Yh3KdIJ/+Ny3M0CQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4xc9t4gr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 06 Oct 2026 18:20:05 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-34ef5fd7934so8608416eec.0
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 11:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791310804; x=1791915604; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eErMTVv+GI4Tv4XbuyvCgn3LWQksVnWHpw5fdcoGEqI=;
        b=cZLnTvYjz3dwsGrqf8WnJcCm5fsqtP/N6fOZv2ZgGbTeLhKLfRdbLpz2jSM6eBlzc/
         wN2QWZqbyQteOj26HQLRZQMd7DuT435glcy/flrhkh9g+D6aTHKB0hYgjGcA3OrKMgAI
         KhgRfeilpUyy4GWDa05gq35eLEs5rhxxcVzhfwS368f5ZnnbBGHSLrIMDeQdsOTdewII
         FE+ASkmiLQCpC+Ci78GXbOIRCScxMmwPQTTSps3iN4OUqZwLfxloMDM8kwDOV7LQ/42A
         QhaI6tj4JY1fna/W5LG5WLizhlnHZ16Mhbq1ON13xVQwC4P22dENztFwZt4594/Nyheq
         Fwtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791310804; x=1791915604;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eErMTVv+GI4Tv4XbuyvCgn3LWQksVnWHpw5fdcoGEqI=;
        b=CvGWV68G9qcyutBu3xxno26VMETeM0KdfADj7wzoVbGvRn5mF5ix+iIAW9ua41Tkro
         5GAo/0XtUaR0z8vpy41vIkRjlPJ80fiNkXuipnSn6QGq3wdBRFyvjnCUoD67Wn/wgrvq
         q15bBJbsdf5TRrOnDChhMIxIZxS6wQOwiehW5FgRyIpt2pFNSfOKr2XuS1ddulLjb2wl
         P9nqvEYLsjLElghIOAEQRgb+hqUgeWNAE0DQe46dUAndremwkref7jQKX7ViqB6nvBkZ
         LQPxHCJzB/nSl+mNCgdAwNMF8aDKTYGLlA+8d2r4raWZNfxzo6ZL3R+6BmDsIW9BPxL3
         aIOA==
X-Forwarded-Encrypted: i=1; AKwUvBxdlHfztT0IJm9xHG060axpIiXWS6vyo5UPM/K6TqYsXcS6CSARJK1q5zEA2j1rpItsKmItkdSPPg==@kvack.org
X-Gm-Message-State: AFq9FYLnl048zGW99wqOh/uAk3xvhxhda8gTgWpmb8hnRLS0loYT+Tvz
	U+YTXoVj660kj+Dq0lIP3t5CCBhLhSu690CHIFb+uQDsQHrZwadKE4JT2u1SjYTk5cUTJ3bGdoD
	tirgl/tQaciuCqSzSwhDwdxiRVxKY5wV/IG65/RENwEYDMDgOnbBcqw==
X-Gm-Gg: AYBFou1a8Q3q4yBZ9r9RdaMp/dBLVTY6qHlVC7kn+pEz3C9+JFa2mEKvi1SqDYd8Ceh
	OKxiKhMORoPAcakxK4zl601SxnZHJr//YHl+yKtyhEqKIQlZfx0Lpbp6NbQPibwfH18mA3aTKhK
	7cukConKI8RUPsRqVPNM+PnaPGAgcbmGE4juHHbWKhKuBSTM5hKe4qe3yervraLyUrKML6IHcjI
	eox/P6SrGMp5xnolregtJwSvsiAW/+bH8erh+8ZxWc+oDlZgCyf+M7ySsWOkJkpmjh0nKhGGWPg
	Ca955zJAYE3jog0v93hwAO53qpaLCTn9WG9mLO1ZlxIuqbq7EPcrPsPH30aukIohouyNhdooG+d
	+p+5fvyRQL7bLZB9IlTFbG6qwqP6VB+cb9MbCPoPygJqMxmIR
X-Received: by 2002:a05:7300:e9d9:10b0:34c:bc38:e2ee with SMTP id 5a478bee46e88-3514e2f4ca6mr2600618eec.8.1791310804046;
        Tue, 06 Oct 2026 11:20:04 -0700 (PDT)
X-Received: by 2002:a05:7300:e9d9:10b0:34c:bc38:e2ee with SMTP id 5a478bee46e88-3514e2f4ca6mr2599280eec.8.1791310773165;
        Tue, 06 Oct 2026 11:19:33 -0700 (PDT)
Received: from hu-ashoraj-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3515abb67e5sm302800eec.4.2026.10.06.11.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 11:19:32 -0700 (PDT)
Date: Tue, 6 Oct 2026 11:19:30 -0700
From: Ashok Raj <ashok.raj@oss.qualcomm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: shijujose2008@gmail.com, rafael@kernel.org, akpm@linux-foundation.org,
        rppt@kernel.org, dferguson@amperecomputing.com,
        linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, tony.luck@intel.com,
        lenb@kernel.org, Yazen.Ghannam@amd.com, mchehab@kernel.org,
        jic23@kernel.org, linuxarm@huawei.com, rientjes@google.com,
        jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
        naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
        somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
        duenwen@google.com, gthelen@google.com, wschwartz@amperecomputing.com,
        wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
        prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
        kangkang.shen@futurewei.com, wanghuiqiang@huawei.com,
        Ashok Raj <ashok.raj@oss.qualcomm.com>, ashoraj@qti.qualcomm.com
Subject: Re: [PATCH v23 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Message-ID: <asU7svV8g2Hb5DZl@hu-ashoraj-lv.qualcomm.com>
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-2-shijujose2008@gmail.com>
 <20261005235021.GBasQ3vXTivT3NLbBq@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261005235021.GBasQ3vXTivT3NLbBq@fat_crate.local>
X-Authority-Analysis: v=2.4 cv=ctMOAF4i c=1 sm=1 tr=0 ts=6ac53bd5 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=MvuuwTCpAAAA:8 a=VwQbUJbxAAAA:8
 a=vzhER2c_AAAA:8 a=EUspDBNiAAAA:8 a=NDcxwIbCrCWPj7GKXwgA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22 a=FO4_E8m0qiDe52t0p3_H:22 a=0YTRHmU2iG2pZC6F1fw2:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDA3MyBTYWx0ZWRfX4lSR42wGaaE5
 2y4Q53kLWZNHPwtG9Md6G4BReXDw13uXYs1XKVYcaUMzyfy23iEUScP+M0Wb5FZ0gT71u4f8bnE
 16o4SE8wxjyJSWtbt5d97cjeT/njM6c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDA3MyBTYWx0ZWRfX6oE1hV9pn+6r
 HoZ94MiDtWkAUM3Mh2XxYa7Qd/BgiCAC1ZuCcNAEtp2AqF5nnH1CxRlvn0R/QXoQeq0XbpU0F+W
 LSuZpeqlXhmU7CyUjsLW5jqrLduXxFJd9fae3B/eLgeM0ZnTnhC+fQIfj4WeAIDQjWqwPp2bco/
 SGTYXYBFayvXqjX7FdqvRJJcD7mUEpTHtSufH9VgFKyJ1VLohsf6u4tO3QuZBeb48DDGwz6zNY3
 V+ENajvZnuKpIQITeYxBV9iPV07EExByjG0uqgiYDWPdiKHZdyoWBeTSLo+pIh1eI9mzBUFMqbu
 zQe+dIDwPrxQt+uzYeI7AD/h78SgC7/KlZyIg2HCfpdmRTnU6QKDum1KifZKZ8c6Pa1Nw+YU5cy
 PoXn2e7zM3dW0C8yZ+cfX8YwRfhn1FYPoYu/9N4m1X+LuEAGF3FOPao52pCUBMUZg9SKxi2O4Tm
 dycvvkE3ocnZkFtB0OQ==
X-Proofpoint-ORIG-GUID: talaW1uwWSS7VR4S1M6f9l1RKyyqM17v
X-Proofpoint-GUID: talaW1uwWSS7VR4S1M6f9l1RKyyqM17v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610060073
X-Rspamd-Queue-Id: 61AFEC0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 7qkdfpe7z7udjwxetahngd4brxeih6ks
X-HE-Tag: 1791310806-632280
X-HE-Meta: U2FsdGVkX186uRDm/zPgXMB6IesSN0MeRTuE38Se3d2VBZe5WpmctQmvTIhP8nfeENEWkfsaDL0frvCnAmMxjSrczTyk21QMuASm26bAZT2iRGok4DJ2vVCIDsBcixCGMeMv5lec5W+uo0yBMTKl9j8IoXbENKWbgjkoLQGwzv11dU4dRZClpzhYK4cWAK8u3xI4a8ZIkwrj0fJ4WhqYsV+XoHAYuSlqjkN0MbyBiOQIM0TaAdrlg/gtTmma6r/iSOCz2OZQAuX8go3cwI2vzr3vKJdHYY/oB3ZDSZIHsKY29iOS+a7rfUGtEJwW2oQsvKJQ6Wd0g74MX/e3g6g6PLG1vDO8cqrhiE5ilCYOagos7VimAaDGmM7k19IVr/3O8pPiKkwY5/4LOKN/lywuxSx1NTo2hr3LqknI0n8iilr6+9jHlTzkfGYAiNxpeXRXPeHDhDZrN6gDiA0lrj4d0d8qH3DMycRBW4kfXZ3Xw7QcUutBeS5xREoU33IC1XYtHUbGZY3id06WNXNz3eNc9ChqGG0oR7VfaKVie2Ry3Jk1HJfYqiQAxzqEA+rGNkkkcjajjYoRozvgnwg7qtt8ms6X8Fv5MEJJKEmRhnb+bRKyyPPpKJwOahISnIcZz6yTX/8NegprWfXO5x9jBfPdI1TGwqVwDrSf30YnyT++B2YVvP3LBC4TF5/QvDy4eKKkHOtlyvgRV3GTYYnNvInBC3Tz1sbg32/K2x5j/wVWhhDTzquwPSLVlvy3UBcIEM8S7VbzF+pzUnGETpOgHLWj9xOdExDRcM//TV7vBl+ARUBNyjeTyn7e+voDL/b80w1KxW6HPCH4m40gn3iBLOGmFnYVd5cWVXYhTTIP7I8fek+ekhMWVATwhpj0Oa+NWWokxeZTqLJQ9cHixGmtS7HQjJ4TsYvvKWcnoNQnL3cM9lz0+dRToJLM5OJ2zb87trthLgGa0HhEAhPa53B+Hxr
 29nIJb1z
 vmXEiRAxKQKIOK9yH1g4EgDfb9dvRgg1rXSRDW9F2EN6uzMoEucDjEosEfYPwt3anrQrk0uC4eSbfSyyuOnQu+tqVNfL/uF6yCyEjRHaY2B5Gi96muZPEn81iJdS6S2W9UsENBFcXbQnFLr11Fka5r3FAw+U7EWsNP7hNmiN1FnPX/X9QopxrjkL1kM94IEzSg+3MKBbXZnK34WWQAurD9qGx8EPyzZgm/F2MH73+anlLCTpNQCdXgT3+ADN97RHqZs97vHUg23wep7t+lJ35YqEGw+B2PQJB9vZQvFDO/2hrimSrV8yrR0ngqPSe6Kr872JPv9csPnjp/N+w6DCGfGCnYm0F+LUJe6QL1jJRGH6pGi/7ZXs7TqYKBBJqwgP0bECCsAtYyx43STtk+K7ab3PDH1SFSdMMEcZcGzVLk+ZlM+MZxFDPlLIJibhIXFwKlyb7vz5HJt6A0WSLkSAe8gr8iJJbBG/sm8FKNFMZFGKT/ZoU8UW5wn5m0NxFmQpv82IG8er5sV+Lb5MOSxwewNS7osg+24N0cfC5xDjZH5QVygij3iCOxBMvjU89SNTciuhi5fUiW/lRuoXEkwukUAG2DyDCF6VDNcf225V3lSuVVixbsUnp96QGdbX1IBcFVpTjXiozZZKaOnHXYfYGTYnHM/3TiHLjvH+NsP2M1Xi05IbMdggkU8rXsKijwTXjOzRTFXHSWg2Cbe1QX80kW2K3FBufwn7x4u/1HZkrOx0dOSo7uukpVTQSYao1y8LS2uyN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Boris, Hi

everything looks great, just one minor ordering bug we discovered, noted
below.


On Mon, Oct 05, 2026 at 04:50:21PM -0700, Borislav Petkov wrote:
> On Sun, Jul 26, 2026 at 10:28:11PM +0100, shijujose2008@gmail.com wrote:
> > From: Shiju Jose <shijujose2008@gmail.com>
> > 
> > ACPI 6.5 Specification, section 5.2.21, defined RAS2 feature table (RAS2).
> > Driver adds support for RAS2 feature table, which provides interfaces for
> > platform RAS features, e.g., for HW-based memory scrubbing, and logical to
> > PA translation service. RAS2 uses PCC channel subspace for communicating
> > with the ACPI compliant HW platform.
> > 
> > Co-developed-by: A Somasundaram <somasundaram.a@hpe.com>
> > Signed-off-by: A Somasundaram <somasundaram.a@hpe.com>
> > Co-developed-by: Jonathan Cameron <jic23@kernel.org>
> > Signed-off-by: Jonathan Cameron <jic23@kernel.org>
> > Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
> > Reviewed-by: Ashok Raj <ashok.raj@oss.qualcomm.com>
> > Signed-off-by: Shiju Jose <shijujose2008@gmail.com>
> > ---
> >  drivers/acpi/Kconfig  |  11 +
> >  drivers/acpi/Makefile |   1 +
> >  drivers/acpi/bus.c    |   3 +
> >  drivers/acpi/ras2.c   | 509 ++++++++++++++++++++++++++++++++++++++++++
> >  include/acpi/ras2.h   |  57 +++++
> >  5 files changed, 581 insertions(+)
> >  create mode 100644 drivers/acpi/ras2.c
> >  create mode 100644 include/acpi/ras2.h
> 
> Ok, went through it one last time, I hope. Caught a bunch of things, see
> changelog. See below if it still does what it should.
> 
> Thx.
> 
> ---
> From: Shiju Jose <shijujose2008@gmail.com>
> Date: Sun, 26 Jul 2026 22:28:11 +0100
> Subject: [PATCH] ACPI:RAS2: Add a driver for the ACPI RAS2 feature table
> 
> The ACPI 6.5 Specification, section 5.2.21, defines a RAS2 feature table
> (RAS2). Add a driver supporting that RAS2 feature table and which provides
> interfaces for platform RAS features, e.g., for HW-based memory scrubbing, and
> logical to PA translation service. RAS2 uses PCC channel subspace for
> communicating with the ACPI compliant HW platform.
> 
>   [ bp:
>    - Massage commit message
>    - in ras2_send_pcc_cmd():
>     - check check_pcc_chan() retval
>     - remove else assignment to rc = 0 after mbox_send_message() call
>    - Do proper error unwinding in register_pcc_channel()
>    - Do proper error unwinding for auxiliary_device_init() in
>      add_aux_device()
>    - Cleanup parse_ras2_table() some
>    - drop ras2_ prefix from all static functions
>    - unbreak long lines
>    - minor touchups ]

Your cleanup and unwind path is good!

> 
> Co-developed-by: A Somasundaram <somasundaram.a@hpe.com>
> Signed-off-by: A Somasundaram <somasundaram.a@hpe.com>
> Co-developed-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: Shiju Jose <shijujose2008@gmail.com>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Ashok Raj <ashok.raj@oss.qualcomm.com>
> Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
> Link: https://patch.msgid.link/20260726212812.89266-2-shijujose2008@gmail.com
> ---
>  drivers/acpi/Kconfig  |  10 +
>  drivers/acpi/Makefile |   1 +
>  drivers/acpi/bus.c    |   3 +
>  drivers/acpi/ras2.c   | 517 ++++++++++++++++++++++++++++++++++++++++++
>  include/acpi/ras2.h   |  57 +++++
>  5 files changed, 588 insertions(+)
>  create mode 100644 drivers/acpi/ras2.c
>  create mode 100644 include/acpi/ras2.h
> 

[snip]

> +
> +static struct ras2_sspcc *sspcc_get(int pcc_id)
> +{
> +	struct ras2_sspcc *sspcc;
> +
> +	guard(mutex)(&sspcc_lst_lock);
> +	list_for_each_entry(sspcc, &sspcc_lst, elem) {
> +		if (sspcc->pcc_id != pcc_id)
> +			continue;
> +
> +		if (!kref_get_unless_zero(&sspcc->kref))
> +			break;
> +
> +		return sspcc;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int pcc_id)
> +{
> +	struct pcc_mbox_chan *pcc_chan;
> +	struct ras2_sspcc *sspcc;
> +	int ret;
> +
> +	if (pcc_id < 0)
> +		return -EINVAL;
> +
> +	sspcc = sspcc_get(pcc_id);
> +	if (sspcc) {
> +		ras2_ctx->sspcc	    = sspcc;
> +		ras2_ctx->comm_addr = sspcc->comm_addr;
> +		ras2_ctx->dev	    = sspcc->pcc_chan->mchan->mbox->dev;
> +		ras2_ctx->pcc_lock  = &sspcc->pcc_lock;
> +
> +		return 0;
> +	}
> +
> +	sspcc = kzalloc(sizeof(*sspcc), GFP_KERNEL);
> +	if (!sspcc)
> +		return -ENOMEM;
> +
	__mbox_bind_client() reads knows_txdone at bind time to promote the
	channel off MBOX_TXDONE_BY_POLL. It must be set before requesting the
	channel, otherwise the channel stays on polling and mbox_client_txdone()
	later hits the mailbox core's "Client can't run the TX ticker" guard.

	sspcc->mbox_client.knows_txdone = true;

> +	pcc_chan = pcc_mbox_request_channel(&sspcc->mbox_client, pcc_id);
> +	if (IS_ERR(pcc_chan)) {
> +		ret = PTR_ERR(pcc_chan);
> +		goto ret_err_mbox;
> +	}
> +
> +	if (!pcc_chan->shmem || pcc_chan->shmem_size < sizeof(struct acpi_ras2_shmem)) {
> +		ret = -EINVAL;
> +		goto ret_err_shmem;
> +	}
> +
> +	sspcc->pcc_id		= pcc_id;
> +	sspcc->pcc_chan		= pcc_chan;
> +	sspcc->comm_addr	= pcc_chan->shmem;
> +
> +	if (pcc_chan->latency)
> +		sspcc->deadline_us = PCC_NUM_RETRIES * pcc_chan->latency;
> +	else
> +		sspcc->deadline_us = PCC_NUM_RETRIES * PCC_CHNL_DEFAULT_LATENCY;
> +
> +	sspcc->pcc_mrtt		= pcc_chan->min_turnaround_time;
> +	sspcc->pcc_mpar		= pcc_chan->max_access_rate;
> +
> +	sspcc->mbox_client.knows_txdone	= true;

        ^^^^ This needs to be set before request_channel above. 
> +
> +	mutex_init(&sspcc->pcc_lock);
> +	kref_init(&sspcc->kref);
> +
> +	mutex_lock(&sspcc_lst_lock);
> +	list_add(&sspcc->elem, &sspcc_lst);
> +	mutex_unlock(&sspcc_lst_lock);
> +
> +	ras2_ctx->sspcc		= sspcc;
> +	ras2_ctx->comm_addr	= sspcc->comm_addr;
> +	ras2_ctx->dev		= pcc_chan->mchan->mbox->dev;
> +	ras2_ctx->pcc_lock	= &sspcc->pcc_lock;
> +
> +	return 0;
> +
> +ret_err_shmem:
> +	pcc_mbox_free_channel(pcc_chan);
> +
> +ret_err_mbox:
> +	kfree(sspcc);
> +


Cheers,
Ashok

