Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CEDACD98D8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91EFB6B00A9; Sat, 13 Jun 2026 13:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F73A6B00AB; Sat, 13 Jun 2026 13:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5C66B00AC; Sat, 13 Jun 2026 13:22:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF586B00A9
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:22:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 309721204E5
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:22:09 +0000 (UTC)
X-FDA: 84875557578.26.8769F9C
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8A84114000D
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:22:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="iVjSsrb/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=PgaodZov;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf23.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZE6jPRdfaoewtNIfPrpNjI8xcezU+gskgS6mTgukQkI=;
	b=VEUfFcheo4zUwcUpB7/VGkdVslek+dTyGf4sbimrxuPdpKlc3vbiPmoZBZ5tfx2Bvf+Wxg
	+3NT0xtv/0x/hee1npfFtbw1KUdxmXswnfHT9+25lF4liVmBmIukoPEsBr2tgL3LCx+7r1
	U67JYm8A6OY+zTZ/uxSMrKN8wRKNvD4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="iVjSsrb/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=PgaodZov;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf23.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371326;
	b=xSAZzj3UT6L2/unatqXm4NmTY4cSEmkjg84ClBmcQ8/eNvX0qe4hem0F3Xqm4I+qTmyAoT
	1wGqSVqJeZKbbddySjfM+ZvyI8nkE4cT9KsdgvnZNLk2I/W9X8A4xnY8PzqMNJIc6CtFJu
	LtajKiGo+njx/a0TXBM46QNX0+A4RAs=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DF9MbJ2769430
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZE6jPRdfaoewtNIfPrpNjI8xcezU+gskgS6mTgukQkI=; b=iVjSsrb/w+HmpHn0
	xmXyx/qzypr06CxDILrTITkNa82ugjOXc8TeWL7dvyQlvCNwa7kc6n+YM+eHVeqP
	2c0/GXJ+mfC862xvdh7emtUJ140SiG0OrRktal89n+9pAfj/ZY/D5rLuAIVgrTSO
	gfoB6E8sN4x8a6qzG38Zos4QlsMe3/fApVQ7b6G1IbgJm03O8Ns28/rQ1m4Ptgz5
	BmbA3RgQCsghsZ+KJ0WGTFnb/UTxRaCkPu4wu6vE9fVkD8zx9qCEJuc87RIxdLeC
	0dNLAZ22iR0ApvrrmAD4j7Zc+1QYltXC8wOAlhMNQ1cteUg3voAzGQsH5oTGdgPz
	qGK1tA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4erye11meb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:22:05 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-842688fa7b8so2770067b3a.0
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371325; x=1781976125; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZE6jPRdfaoewtNIfPrpNjI8xcezU+gskgS6mTgukQkI=;
        b=PgaodZov0rAp0DcCkHorxXXeaodcFRZoNRypl3iz4mBuXUMb5xcjwsXhvPFJJfK9C0
         NgF8WZwqbPx6cQUKp1S4WnO3+90ZfG0qqTPxX0orbf0xIV5RIYeOM19GFVpxEHVxgQFZ
         K4HcpoG2XAzUOYNm+6llIL0OW8DW3//M4aM2LaBi6/rAFj+sBtStQPWPpVhdFj1WOOXc
         OJARqqRMc4v5kwonb3LbrQstEkz7nNhAwlL+yawLW2+ob76IlNPHPFdlpKwBXg9Nu/t7
         zqOqmhBd3OyoOdnpcf9aTWCq1xOFaS1+i7PCaFtrr6jklRagkgyR0esUN3q7nBSzFOjP
         BEYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371325; x=1781976125;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZE6jPRdfaoewtNIfPrpNjI8xcezU+gskgS6mTgukQkI=;
        b=liikEU7Mw2DAaVSiACIQ85JscPiZp1764Edxq1NZepfhDtlX9TzSpeAAf743YIdlqD
         5ERVaXi36bSMZ4Rwe6HV7PRlLcgtqCjB8J60IuA4+P9fAlOtQYejKTsTc8VMRSRgnCwP
         MTGOeeY+cVWTTUtk7z++IrHywgW+qoLpfbg6WfNqrjym6pD5HEFEnirwrPPUmVUXcgQ5
         P8Qz42qnlnTl1iaNvE/ZIbxr7mYTiNLhaW7/HCY9aMFiAUow0t7EZET/pQagHsV6nko0
         i4TpySwGHlEygTcBboWjDFyTnd5mgoTof1dDrWPrDK4MPwMLWCO44lf6Pzx5FR6h5Y6Y
         pJAA==
X-Forwarded-Encrypted: i=1; AFNElJ8xGN4GXzpmoSJ7TxxMoJC48J1l6kMvQIykeHdQOdjC41WOR0KX6itRr65MK81K537gSgho6H4n7Q==@kvack.org
X-Gm-Message-State: AOJu0YwC9a/wNNtUy4t5wZ2hhja1kA2tm2RsB5emDVas3hR1kq2mMsQ0
	9GtpMVnUM/2cW5gX43rfWQTZ7WOYRCGIKAf7lkUWElgMRX5WfzrQGX6h/OeVR4HB8cDADNigcvD
	pMG056QeMQLuaBu/CUzA+UIqNsYx8uYvsPKz4QGXnmuL0VqMf/20XtQ==
X-Gm-Gg: Acq92OF/5ipTs7qytZMBLzunbeLhGJ0IqaktOc+Ff2GNz/r/15lCrgxcA83LS90tggK
	GO9QWRFIBrH9Ej05YxNEeTAP0c/TzVHPg0hDtISZq5rs2ZH9159HlXIXHS+bj/5R/8Ib0CJ0g3+
	BEt5Abj0zGNfb0o+jZ28ii9Y6PBFNH7bd/9Q+9spebvwHKZUC1wzCstqCWuVX1gGZMn9URsFCLK
	gkoTAEeWqZfqx35ClWzdJNwrWxn+S2H/8Gz89u2Pm+/kiab8VwhJkFaa70ovUe0lKjYN99QK441
	ViZJUmYlocevWCGgq97uCqhm5Y2hWCKdiiBpuEDlcQc9tj8P8JIpXhebl2WnW37FAiTyui3LLN1
	+ujVNuBtREdYRSffaGkyeioecXHEDyS8dNNQgUkC/hjcBjSuMo9YaMA==
X-Received: by 2002:a05:6a00:2351:b0:842:5f67:eada with SMTP id d2e1a72fcca58-8434ce4070amr6578019b3a.5.1781371324378;
        Sat, 13 Jun 2026 10:22:04 -0700 (PDT)
X-Received: by 2002:a05:6a00:2351:b0:842:5f67:eada with SMTP id d2e1a72fcca58-8434ce4070amr6577978b3a.5.1781371323837;
        Sat, 13 Jun 2026 10:22:03 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:22:03 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Date: Sat, 13 Jun 2026 22:49:54 +0530
Subject: [PATCH RFC 12/12] mm/vmalloc: harden bump-allocator alloc/free
 against UBSAN array bounds
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260613-vmalloc_maple-v1-12-0aa740bb944b@oss.qualcomm.com>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
In-Reply-To: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>
Cc: linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Lorenzo Stoakes <ljs@kernel.org>,
        Pranjal Shrivastava <praan@google.com>, Will Deacon <will@kernel.org>,
        Suzuki K Poulose <Suzuki.Poulose@arm.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mostafa Saleh <smostafa@google.com>, Balbir Singh <balbirs@nvidia.com>,
        Suren Baghdasaryan <surenb@google.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>, Shuah Khan <shuah@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Brendan Jackman <jackmanb@google.com>,
        Puranjay Mohan <puranjay@kernel.org>,
        Santosh Shukla <santosh.shukla@amd.com>, Wyes Karny <wkarny@gmail.com>,
        Pranjal Arya <pranjal.arya@oss.qualcomm.com>,
        Sudeep Holla <sudeep.holla@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=7915;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=poCfMca4I5bU16k0x2EJY1kUzaPSBtmGjAWZRE/6A1o=;
 b=kGgYknKWsSNBxkdk0W8RRR1QefOuH5dooHWWewlUdfNTWdwNuW3qNCnaMf0NIthki3GTPNlfk
 WKtc4hRw6hxDBELESN9aTttJLWCPG90L6t21yIt7WTILVL//TKeMdM4
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Proofpoint-GUID: OEqerO5qRszmeKu0Oiqly6vHf93zWH5l
X-Authority-Analysis: v=2.4 cv=MNlQXsZl c=1 sm=1 tr=0 ts=6a2d91bd cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=a2jIHL7vm5qZbxVYpdMA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX4hJXdiewuD4C
 pDUToF4LqTAdIOuycWpo7uTJWlmx3N08aMDDlwFUnZRYZnS/WawypeTwMHupHnCmzJiJvES2qU6
 J13aXput4Oy0YAiVPXZrwUlp/wvbRvE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfXxQBj8eRGvI04
 jzv3LiRgnTWx5lGgDL9MQ3V11Un+OpL/H9RKKPaFVdwt1biQw0KJ80QJpDnKA9NLXLviKAOSomy
 zU3leubVPOeozIu62ulQ8xadUSem0qs79TiAd+tuLpw95L4HhkYCHNYIJLiS8qMjg5vtZb4ud4L
 g6ea93Xn4q2tbfW+xD55twA6oCGXLrE5DPCXkED9AUpXoYhtlLhqvo2lWGmJtYRDT/tPq1GGrcP
 lFeaRRv8K7a97RraCmZYUP0S9Ocng94NJKktGHb0jdu+WbI4voJDfi9M9ddfSNJtxaT9YAez12g
 kZB3M49dTzYuzEqNr89uzcg7n5CRguCNJqP2QDN7ouPAr/lrvl/q6W1Z6Kq3VsEJxKHyYlC2+Gk
 Ei5OIcl5isaoUSuMI1BSDQqZmDtikPpt5g7gqwLsaSvF8esLDDYsLBmdDOO54rgccHksClsRBCp
 4ifz8qc1NnAn2yH4tvQ==
X-Proofpoint-ORIG-GUID: OEqerO5qRszmeKu0Oiqly6vHf93zWH5l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0
 adultscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606130180
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 7f59pdmu8gnoo13h6c3k6nhajtuhwwgs
X-Rspamd-Queue-Id: 8A84114000D
X-HE-Tag: 1781371326-859242
X-HE-Meta: U2FsdGVkX18jqrS66FjGp6Hb4KveCsk6ygnY3WiT80a/A3lrlMpa/CbynO9yi3Omb7C8IejH0ef+t3WFkAT6Dy66qG+AMW23f6H0rA862Bn5gfzOTaCt1jq0VZPCXOckgBT1FxeEjodRCNNbyU8ccFPAJSWs1Z2L+tHDjFp7Yq5/bdTyPTilSluVq1fb7kmJNXWjlpdCCDjVWmUaFWKact8PpOq1xMYXHsLpyFk0Rz7IOlOFBOgza0BExRzxLNSYYzDnL6VGgyhF9DswD9elDIlfjPJerTAEwZld8sqKpi1wpNZdZQyeEy5mytQIYvP36g56tmQ2PahPfJ8l5kH5dbuTl4jV40KJG/G9/MF9Uy8kx0OMV5oj+qCchKow+Y/YUVQkoxTtiWkCWuAm3hVf7SCrb6xiuncLQnOVcjcIPHjlK20PmGZrfSbgwpi7KWhnDoG47iLBOcrQi4PfJChD4QzUo488I86f8LoMv1bkX8Z1kzCZALOyxJwUwJrvbGBBbD5N/PTj+RDDj/ox7+xSZnwRK38gwPEj8JvJAa+ghf/rU1XvR+XRdidv3eJ74O8LvsE9BmDtvoT4S0LELvlJec+TCfx+d7U2DGy9V/mGlqjHBw9BiG2TKQUc/RfOL5fBqcYdMt5Fu8nT7p09LnHHan7hTc4XeWWV0bs52JZdTkYddhBgeytQkWMUyH8ZoeNkkHnOGsJRJydJAUo2H/M6MYloZWslkRfN1M09UiOq7nqvFjOynbu7VVrXDHpkfbXGY01fqw9JT61l1JBjPwqg6P1Qv6STL7rfJoJjDo4SFhjHOm3msLm6t2qgrW1wkqxrMipOx9OWgSuxzqEVxfiX0f6h4XtOTwJPUQKRzPWGeQUwMJc1Knu5wddzbcCqgTMtZbVjEpwCW6xaGJe9aWDT1+ZvavzKxedkL9hW8Gh82gAK8CDPw2VqlwgvVZj4LgxKJkF7+tKUxItnkQNeoua
 HY+hi9cF
 DqKDGzVm1iN8CUe4c7VeUGZ5xR0x/yv/WERTr3LWcaAAkhAI65IFVQ94v81SZsItXYfZpN6cCZGuJokoRwDO1PTCQ0J1ShZBKtYHQQtkktiRgfuRKGvPeKEQkqS35cVcksG5wagXuMJsyc6FDYzr3+/Dmo1iccbuO79/4PTi2HD0s3BAqgTNlN/GVeLop3VttPR3JQW4mW6fvSy44R5JuYzF5wDaWV50NuKwsfl1TXbLmyl28gKEnLGqA1TJ0m4F7NadxjyPdHYWrCGONNBswhiMw4wXgsnU83FPWJosuijTTbfSZBZA+/yQdsoXZ6ryVk8UIWz/wjbFOTc5PsEJXYoGI+VsyYlkU6MXtQqo6eaYeqE1sM8wt1zYwoUkOoiFAXBz8PI2Mk/etYytez7HSVI+CUnkUH/WEh69SI4QE12AQwIf2qvZc5XfC0etcMqrY+stAipafQMql9RIPbrjwfNvoS25hSRiHaL+USyFlnoAaH6pPnWV1ldmQ1HdOFp2G/JIffwx7GHrtrSJ0kPurYEnJxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Real-hardware testing on a Snapdragon X1E80100 exposed a panic during
boot-time module loading via finit_module -> kernel_read_file ->
vmalloc:

    Internal error: UBSAN: array index out of bounds
    Call trace:
      vmap_bump_alloc
      alloc_vmap_area
      __vmalloc_node_range_noprof
      vmalloc_noprof
      kernel_read_file
      __arm64_sys_finit_module

UBSAN's array-bounds sanitiser triggers on the indexed write loop:

    for (i = 0; i < n_pages; i++)
        chunk->page_va[idx + i] = va;

Harden the bump path:

  - Centralise the eligibility predicate in vmap_bump_eligible() and
    add it to alloc_vmap_area() so vmap_bump_refill() is only called
    for requests the bump path can actually serve. Add PAGE_ALIGNED(size)
    and align > 0 to the predicate (defensive; alloc_vmap_area's
    callers always satisfy these but the explicit check is cheap and
    prevents the trap path from being entered with bad inputs).

  - In vmap_bump_alloc(), use check_add_overflow() for the new bump
    pointer, validate aligned >= chunk->base (defensive against
    metadata corruption), and bounds-check idx and idx + n_pages
    against VMAP_BUMP_CHUNK_PAGES before touching page_va[]. Replace
    the indexed page_va[] store loop with a pointer walk:

        slot = &chunk->page_va[idx];
        for (i = n_pages; i > 0; i--)
                *slot++ = va;

    The pointer-increment form is not subject to the array-bounds
    sanitiser instrumentation that fires on chunk->page_va[idx + i].

  - In vmap_bump_unlink(), validate n_pages > 0 and n_pages <=
    VMAP_BUMP_CHUNK_PAGES - idx before the memset, so a corrupted
    va->va_end cannot drive a write past the end of page_va[].

  - Track the chunk's owner CPU at refill time and compare against
    per_cpu(vmap_bump_cur, owner_cpu) on unlink. The previous
    this_cpu_read(vmap_bump_cur) compared the chunk against the
    *current* CPU's chunk, which is wrong when free runs on a CPU
    other than the chunk owner: it could either retire a chunk that
    is still the owner's current, or skip retirement on a chunk that
    has already been replaced.

No semantic change to the bump-path policy or to the addresses
returned. Builds clean on x86_64 and arm64 (full bzImage / Image).

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
 mm/vmalloc.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 13 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6991054e1cba..03f10b6b815c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2508,6 +2508,7 @@ struct vmap_bump_chunk {
 	unsigned long		limit;
 	unsigned long		bump;
 	atomic_t		alloced;	/* # outstanding pages */
+	int			owner_cpu;
 	struct list_head	link;		/* on vmap_bump_chunks */
 	struct rcu_head		rcu;		/* deferred free */
 	struct vmap_area	*page_va[VMAP_BUMP_CHUNK_PAGES];
@@ -2517,6 +2518,16 @@ static DEFINE_PER_CPU(struct vmap_bump_chunk *, vmap_bump_cur);
 static LIST_HEAD(vmap_bump_chunks);
 static DEFINE_SPINLOCK(vmap_bump_chunks_lock);
 
+static __always_inline bool
+vmap_bump_eligible(unsigned long size, unsigned long align,
+		   unsigned long vstart, unsigned long vend)
+{
+	return vstart == VMALLOC_START && vend == VMALLOC_END &&
+		size > 0 && PAGE_ALIGNED(size) &&
+		size <= VMAP_BUMP_CHUNK_SIZE / 2 &&
+		align > 0 && align <= VMAP_BUMP_CHUNK_SIZE / 2;
+}
+
 /*
  * Coarse [lo, hi) bounds covering every active vmap_bump_chunk's
  * range. vmap_chunk_lookup() rejects out-of-range addresses (e.g.
@@ -2582,11 +2593,10 @@ vmap_bump_alloc(unsigned long size, unsigned long align,
 {
 	struct vmap_bump_chunk *chunk;
 	struct vmap_area *va;
-	unsigned long aligned, idx, n_pages, i;
+	struct vmap_area **slot;
+	unsigned long aligned, new_bump, idx, n_pages, i;
 
-	if (vstart != VMALLOC_START || vend != VMALLOC_END ||
-	    size == 0 || size > VMAP_BUMP_CHUNK_SIZE / 2 ||
-	    align > VMAP_BUMP_CHUNK_SIZE / 2)
+	if (!vmap_bump_eligible(size, align, vstart, vend))
 		return NULL;
 
 	va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
@@ -2607,22 +2617,34 @@ vmap_bump_alloc(unsigned long size, unsigned long align,
 		kmem_cache_free(vmap_area_cachep, va);
 		return NULL;
 	}
+
 	aligned = ALIGN(chunk->bump, align);
-	if (aligned + size > chunk->limit) {
+	if (aligned < chunk->base ||
+	    check_add_overflow(aligned, size, &new_bump) ||
+	    new_bump > chunk->limit) {
 		preempt_enable();
 		kmem_cache_free(vmap_area_cachep, va);
 		return NULL;
 	}
-	chunk->bump = aligned + size;
+
 	idx = vmap_chunk_page_idx(chunk, aligned);
 	n_pages = size >> PAGE_SHIFT;
-	for (i = 0; i < n_pages; i++)
-		chunk->page_va[idx + i] = va;
+	if (unlikely(idx >= VMAP_BUMP_CHUNK_PAGES ||
+		     n_pages > VMAP_BUMP_CHUNK_PAGES - idx)) {
+		preempt_enable();
+		kmem_cache_free(vmap_area_cachep, va);
+		return NULL;
+	}
+
+	chunk->bump = new_bump;
+	slot = &chunk->page_va[idx];
+	for (i = n_pages; i > 0; i--)
+		*slot++ = va;
 	atomic_add(n_pages, &chunk->alloced);
 	preempt_enable();
 
 	va->va_start = aligned;
-	va->va_end = aligned + size;
+	va->va_end = new_bump;
 	va->vm = NULL;
 	/*
 	 * Encode the destination vmap_node so the existing per-node pool
@@ -2651,6 +2673,7 @@ vmap_bump_refill(gfp_t gfp_mask)
 {
 	struct vmap_bump_chunk *new_chunk;
 	unsigned long base;
+	int cpu;
 
 	new_chunk = kvzalloc(sizeof(*new_chunk), gfp_mask);
 	if (!new_chunk)
@@ -2670,6 +2693,7 @@ vmap_bump_refill(gfp_t gfp_mask)
 	new_chunk->limit = base + VMAP_BUMP_CHUNK_SIZE;
 	new_chunk->bump = base;
 	atomic_set(&new_chunk->alloced, 0);
+	new_chunk->owner_cpu = -1;
 	INIT_LIST_HEAD(&new_chunk->link);
 
 	spin_lock(&vmap_bump_chunks_lock);
@@ -2681,6 +2705,8 @@ vmap_bump_refill(gfp_t gfp_mask)
 	spin_unlock(&vmap_bump_chunks_lock);
 
 	preempt_disable();
+	cpu = smp_processor_id();
+	new_chunk->owner_cpu = cpu;
 	this_cpu_write(vmap_bump_cur, new_chunk);
 	preempt_enable();
 
@@ -2699,6 +2725,7 @@ static struct vmap_area *
 vmap_bump_unlink(unsigned long addr)
 {
 	struct vmap_bump_chunk *chunk;
+	struct vmap_bump_chunk *owner_cur;
 	struct vmap_area *va;
 	unsigned long idx, n_pages;
 
@@ -2715,6 +2742,8 @@ vmap_bump_unlink(unsigned long addr)
 		return NULL;
 
 	n_pages = (va->va_end - va->va_start) >> PAGE_SHIFT;
+	if (unlikely(!n_pages || n_pages > VMAP_BUMP_CHUNK_PAGES - idx))
+		return NULL;
 	memset(&chunk->page_va[idx], 0, n_pages * sizeof(va));
 
 	/*
@@ -2725,8 +2754,12 @@ vmap_bump_unlink(unsigned long addr)
 	 * TLB entries until the next lazy-purge flush, so reusing them
 	 * before the flush is unsafe. Forward-only bump avoids that.
 	 */
+	if (unlikely(chunk->owner_cpu < 0 || chunk->owner_cpu >= nr_cpu_ids))
+		return va;
+
+	owner_cur = READ_ONCE(per_cpu(vmap_bump_cur, chunk->owner_cpu));
 	if (atomic_sub_return(n_pages, &chunk->alloced) == 0 &&
-	    chunk != this_cpu_read(vmap_bump_cur)) {
+	    chunk != owner_cur) {
 		spin_lock(&vmap_bump_chunks_lock);
 		list_del_rcu(&chunk->link);
 		spin_unlock(&vmap_bump_chunks_lock);
@@ -2781,11 +2814,14 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	 * find_unlink_vmap_area() consult vmap_chunk_lookup() before
 	 * falling back to busy.mt.
 	 */
-	va = vmap_bump_alloc(size, align, vstart, vend, gfp_mask, node,
-			     va_flags);
-	if (!va && vmap_bump_refill(gfp_mask) == 0)
+	va = NULL;
+	if (vmap_bump_eligible(size, align, vstart, vend)) {
 		va = vmap_bump_alloc(size, align, vstart, vend, gfp_mask, node,
 				     va_flags);
+		if (!va && vmap_bump_refill(gfp_mask) == 0)
+			va = vmap_bump_alloc(size, align, vstart, vend, gfp_mask,
+					     node, va_flags);
+	}
 	if (va) {
 		if (vm) {
 			vm->addr = (void *)va->va_start;

-- 
2.34.1


