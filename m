Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E39BCD98D8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07626B0092; Sat, 13 Jun 2026 13:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8326B0093; Sat, 13 Jun 2026 13:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BC16B0095; Sat, 13 Jun 2026 13:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1CC6B0092
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:20:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 406DF1A04C1
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:46 +0000 (UTC)
X-FDA: 84875554092.12.8F7DBA2
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7C3E84000B
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ReVyqThP;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FWZtDaLt;
	spf=pass (imf01.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mMQ+LL7Rsw0V5Gp6IYVyB67DNDJRzawcpfiN2k23OTw=;
	b=13W7couU5JmEGriSod4lkVWbYukrBSrZPTfhZGKLPc4PYE1NmKEFuN3/AKffR59gWd8Pnm
	i2OCuPRdK5Tsa8ksVxq7zXcXTlbu4t+UM27i0I4YHTxO3ZgYFlnIvXHhr1Cwzq/ZclXibT
	24JL4mz4F8lXbDVT1gX7/kHxArXNQgA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371243;
	b=lZ14Obg7KdYlBQylKmsX37mfVloBEZJEUiV0wY4Dhbcxam+kTd5aZa6A6ST2AjiSqN9pFQ
	H2TmgPkYTdjf+aeuH38q54MlYszZvvleD7TACS1EvDesS7IVyPHO0A8FRchJoLOwrZVANk
	77CVxP/OQTcaFUQMkkMUO3M65KdXQUk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ReVyqThP;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=FWZtDaLt;
	spf=pass (imf01.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DFA0jO2690590
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mMQ+LL7Rsw0V5Gp6IYVyB67DNDJRzawcpfiN2k23OTw=; b=ReVyqThPMiH8nkUc
	cAeZlpJTYISvPRsLWrHlWxkj8kUDo61PFMSa/ly8poQqfNkmsQca5KZuKtn9zY6O
	GKihXHTbnvpj6xhoMovSZBn54FITkoWsxf4q1x9k+8x/xGMZmB1P6brG13o+d22Z
	BfVc3Xo+LzYD0bJ42StiAUlLtvPsvr77enIwTaAvNum9XhBqTXhalqt0Ow2EiAVx
	gARBROt8CWn2M0hSjcuKDs/TNDVdHA641TXAXx58M2sEtjnRSERsuqxLo5EXpV69
	TFWYaYuAYwO7+Ki8DqyqKOr8NUT+RLB6NI6z0JRpRvouf+Jf2CZuk/Ztn9utXSLQ
	Sj560Q==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eryybsj4n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:42 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-842211d6e48so2366327b3a.0
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371241; x=1781976041; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mMQ+LL7Rsw0V5Gp6IYVyB67DNDJRzawcpfiN2k23OTw=;
        b=FWZtDaLthOc180a1OeE9mWLO91MFRXn2X66/QlhuW+0P5PGWNDlDXO83PtegBRoahv
         +jpJj3nAKSVTcn7KzSyyichtV7u0ozY40B4dnaDfPyQ7AzL8MomYrio5ccQpVDmVoMBV
         85GvpMfmzC7YYOR/bsCsWQfJCwUoJO7WxW/P9FYEvNbpfB/R4+vaWY7/CWESspah4u35
         gqh/bgsYgaPcV4Xu2eKqL1g48ZZ8j3ama/54nPTn9xfk52dnmDTbUDU0CPxsEDv6mCro
         PSpcU8xFTHy8rRleeM6ZMVbN4ZbFqhS2nZ/2w3oU0R0ER0sVpz3ZQLnySS4MBsMaoDP1
         48qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371241; x=1781976041;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mMQ+LL7Rsw0V5Gp6IYVyB67DNDJRzawcpfiN2k23OTw=;
        b=fwRo38IWyOgRAJip2pWUo0c2wYNBLSL85ryEJBdHNDsxCZyXp5sbnFpf7iTjdHd/NX
         f1s+qGWhjBqeAokZXgyQJUtD4bEwIWyiV9wJRNzPfwJJeL/vuuGEIKUmi9bFsYoB1RzN
         qX+w9zJkjeK+HAC8xi1Z0RAs367Vk47Tq2a8GUCIyGJt5sv4fTpoewJFprwPbpvsUVKb
         iEVY8ZDDQx/v4ETZWv1/VhTFyc8eomiBt0GDM19YRzr7jCLl+AEbnhoLEvEs1oE5og9z
         E+avpvaBW0/HnmMwVNlYaihM4DKgTsdNpwKGhs/EYprdOqOzgGvzGcYNkbbnBPcg7ido
         2pZA==
X-Forwarded-Encrypted: i=1; AFNElJ/HQvPCXjB7dYjbn21IV1kFn+4r+Obxuc8I13QQ0nYNJARXEYvWeb6wsUBmJHdqcteGIiL9cpCWkw==@kvack.org
X-Gm-Message-State: AOJu0YxY/zGuodbXr01XiXrqV6vZPQT8kp2v/49hnmAZEFcXJPydRm/l
	NeajcjC2HeqBB5yepV6O2lYjIZM/UBqQUuhke4raotz14ftBfBZRXEFOlx+pCCgAhVXQJwP1CBk
	S5SbmjPvTJ1eQ5r/vm9ujcolVPkyqbzABbM2IVMAQjxN8TtD/2XVpbw==
X-Gm-Gg: Acq92OGpJWX/ZabUTDBWsP6hkMPqOpXeitsyJfTs80VWhbIZfLxm7Ak+Iflaj/p4RCq
	p+1cukvBuL+0mAQApk/6zJ1SPKOoxHJxu8DidJnERy3pyCm29CdGqg9X9lvlpMOMAgMnIczUwEa
	sPZFbWZiwzl8QUsGGAEgyvQDsOgy90eVjE+y6/JK1awb5R7UXYGSDDeGHP3d7old55//jzmwF9v
	WqnqA+xpaBkPA3ietJtYB8LOsCgsec97PX2d3ulGuUYgS1S6vKA4vcsF1geahrLxfgnI2Ra/A9Y
	U/U5rPus/YoR1X4COapTpG8a0TGaDgIIKwhJPAH+90QkQz3Vh5WfUXz2k2UM4ioN4UyMdWzLO5Y
	t7L3qKuKvLIco4bR4n4RCGaKdAFQigmIxTvbGG+BO3eXT42xBahwc2g==
X-Received: by 2002:a05:6a00:22d0:b0:842:4907:d089 with SMTP id d2e1a72fcca58-8434ce2921cmr8490704b3a.34.1781371241170;
        Sat, 13 Jun 2026 10:20:41 -0700 (PDT)
X-Received: by 2002:a05:6a00:22d0:b0:842:4907:d089 with SMTP id d2e1a72fcca58-8434ce2921cmr8490658b3a.34.1781371240511;
        Sat, 13 Jun 2026 10:20:40 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:20:40 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Date: Sat, 13 Jun 2026 22:49:44 +0530
Subject: [PATCH RFC 02/12] mm/vmalloc: convert allocation-side gap finding
 and insertion to maple_tree
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260613-vmalloc_maple-v1-2-0aa740bb944b@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=27873;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=mzShuQjsivGBwOJFNo2gMC1ZvtaDXX3KGiVDadnIc+k=;
 b=mGVagTALUpXKoJTvjX1xzksAIiQDKkp7Jbp8u6A4xxsdoJVlQGaXoQ/FJc7kThKELh8l19Qem
 Ry8mot6zxFWB+nAQpn7K6G1SqyJXpe4OMFQfBFKs+DcisWStadqPjbH
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Proofpoint-GUID: FH6Qb22g3IllIl90FL6YITqYCGCnce0z
X-Proofpoint-ORIG-GUID: FH6Qb22g3IllIl90FL6YITqYCGCnce0z
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX6CtCCKifu989
 FeRznlezTzsJwtHuBOXnHuevakgz+BuoBIynbz2u+pXIrZwJgvi2mqmP6R46je5xxTX1pbsDKQ6
 8QgIph7ENhoiypGt2l2xx5CMBWsPlLI=
X-Authority-Analysis: v=2.4 cv=JLYLdcKb c=1 sm=1 tr=0 ts=6a2d916a cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=iIov-Uo6zy7MBde1-YQA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22 a=yDLO8QUhx1Xh9DD4DYOy:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX0a5BbhxkFxWM
 rLlcIc3U6uGvAd6cZrh/HvcxC/rY3uf7Zn4c8+RWR55Bl4F57YXUwe9tiPJ3PndUTDgdRGE8U6n
 pp8k8YoiqtuNuVQV7XL9FQkrEyNSmUEc9w/I7ekVt85Qe6kl+kyaz73Xu5DXCUtsu2TvEot8Yfy
 n1CqeCrl9vSVnAhxbHwp/Pqu0A9ZOF4uFvbK0TmFM7nrltZbi4fbkXO+IBjfDgHqoIqlxDNpP41
 O2iPgZ80QyruuUzuJmdTZY8ozPehVGQBgRlzJva8ewJnBaxzumfea1Qm7SDl6dLPrRA2LS15884
 f9LEbLEcjFeRg+OxAXTzgWDipBU26a+bwzOAtS7sKXplYchOrE8xHSABrIse6jHEyauToXiYH3R
 mpH6N3zCZfXLdfz+2j05iKvbeup5IIvrJ4uRtRctfD+E7DPNmqGeX4Mf6SlaXJB44CBNTa9TNmj
 B/tR30GCzdXxs5zkYgw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0 adultscore=0
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606130180
X-Rspamd-Queue-Id: 7C3E84000B
X-Rspam-User: 
X-Stat-Signature: ij9tucafqhbcyk68fud6yd87wf3fj3i7
X-Rspamd-Server: rspam08
X-HE-Tag: 1781371243-831886
X-HE-Meta: U2FsdGVkX1/eRn6nmn0xscqCRJrqCyHe9MhR6tOdYZUxGdPfcSggQl4+/1gRutt54X3K8b8CMKqgEfW5HYHoV2yRfh3HsQ6yfda+Z+umMxmvPf4GjtQEN5KfLQfP3JtFhTH/fvuoIRgAedJYFvnEydbnHFseCG4RT6oGd8rVosFeBSIyG3Kh1Y8IRMgiMGZsCFMt4LHYd3BLLJkGseFnEG5NQHKJ4N790eqdXo50KqepkgghPVI1+pnHy062tItCNTHtR4wjYCoj+Vlp+4mnoZQeGBQKPYkwTH3uyuvy0SgpfL9tfhg6X7NYtSPu0OY/+dTEAVXRXMIREfQyhlFcmfDgu3WG2v9ZjI9ZaRYhQupqYn97GycxpmLe5oqjwQmaFijjtplAcXQwE+lZn51jRW8SFKbvbLHHi43og5NKhVGLyEw+vAFbfIA7j8pwWCdPomtDGFg4MLHcAKUeYOD29ZyMQhsLMbC8mw3XcBspo+vCw8/IJlBYiAUlmTQZDvwqcZ1l2ojb8Z02dfoYV6g9ydvPRe6IssD4zo3zIpUICKwKJ70elBTxoC4Tc8AIYAcylhcQVEAe6ZxK+4c6hu6aXfDzJtrgLCy4zYzj5S0jl4bXe9ZywtukDM55GAE31HTwiMLplKJlCa/qIMkTUrUUOnePBaxYAk1N9xzXoQSTZtc1IKi2ums0bOgdJwDiq8jHsKnRG879jiNdas+7Udfm1ZhEKS091uQONPgP9YmX/Y/kEs5RW2khu0XJPS++2Md2b1bhfNtZ1Yt65rlGt1cgaKNeDMRg8jlrNCmRMZgis+1rIzLgT6fPWwDzsFjHoZpSYWirFgq971w6dmqGkMHFPOW3JaZkCDUUDpLH4JNd5COQsQVeKR+9i7Omq/mgWN5P17S9h/lx08JHsusYnCaYh9pBIs1HrtrJmavjVadlNbWm23EtLzilBcSdIDPP880/1RhF9eqLWNQZaTepNkt
 oWSf1Lrz
 M/7wfoGzyIrkkJhxhXpP1maTt5NH2hzWD6/ju/hMlNnoP7Mgj6ORRiQbmaWSuzYGPMT+MSwTtaxyjBKIb600ENrH+p/Q7gLnGuTI2xLktPNTUBnbcITlSi5aMGjdm7GgKHrjZdewUZ0G86ma7c2nxkn9aEYI3j9UG6Z5bkV7n350TyBqrGgfBzfrD3Qyfgu9VdWEUoXpsaW3rLm9t8goaO/eC2/LPsTXvYsY6u3VnlL36LSziKMglAF2n9eUUNhWf4FdspdvBNTottzKms8Aux59Y11ZOFboxDhtIrG+GkiuXl21nnB25GFUj7YY2WEvwpKEWyguQQnHQrYjH+no6LwU0YbGYdGTDWKf3qUqmpsSpcfGrUQVNlqT8WhcFsttMvpbeCi50UfdhNUd9zSog8GWDPT4J0xfakQ60eQTaSPPDfM9tvAD6VCvsb4UjkloxddPNb14HYcDGpI1Kq9XR0bQRIO580Ko14MMkUcM9MHvQA35ssPY1WwPjilFI6AlAHximod69wfpRw5nXUaTvgKNRjWGJvblUFG1vjCHO+o5NFodiQ2pFcdMsEhZ1FBba3hJNJPoTf4ISEisS1MA/4Sa2OuHkAGdA/Emo2BvF9SZpyIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switch __alloc_vmap_area, va_clip, classify_va_fit_type, and the
insertion / merge helpers to drive the global free-area state through
the maple_tree-backed helpers. The augmented rb_tree walk
(find_vmap_lowest_match / find_va_links / augment_tree_propagate_*)
becomes unreachable on the alloc path and is removed.

The alloc path retains a list-based next-fit walk over
free_vmap_area_list driven by free_vmap_alloc_hint, but its
insertion-point lookup, neighbour validation and free-area indexing
run through the maple_tree helpers
(find_vmap_area_insert_point_mt, free_mt_store_va_locked,
free_mt_update_va_locked).

va_clip handles the LE/RE/NE fit types via the new free_mt_*_locked
helpers.

The pcpu and free paths still drive the rb_tree.

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
 mm/vmalloc.c | 653 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 323 insertions(+), 330 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 67f753d04c96..c5f509f033e6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1535,261 +1535,155 @@ find_vmap_area_exceed_addr_lock(unsigned long addr, struct vmap_area **va)
 	return NULL;
 }
 
-/*
- * This function returns back addresses of parent node
- * and its left or right link for further processing.
- *
- * Otherwise NULL is returned. In that case all further
- * steps regarding inserting of conflicting overlap range
- * have to be declined and actually considered as a bug.
- */
-static __always_inline struct rb_node **
-find_va_links(struct vmap_area *va,
-	struct rb_root *root, struct rb_node *from,
-	struct rb_node **parent)
-{
-	struct vmap_area *tmp_va;
-	struct rb_node **link;
-
-	if (root) {
-		link = &root->rb_node;
-		if (unlikely(!*link)) {
-			*parent = NULL;
-			return link;
-		}
-	} else {
-		link = &from;
-	}
+static __always_inline void
+insert_vmap_area_busy_locked(struct vmap_area *va, struct vmap_node *vn)
+{
+	int err;
 
-	/*
-	 * Go to the bottom of the tree. When we hit the last point
-	 * we end up with parent rb_node and correct direction, i name
-	 * it link, where the new va->rb_node will be attached to.
-	 */
-	do {
-		tmp_va = rb_entry(*link, struct vmap_area, rb_node);
+	lockdep_assert_held(&vn->busy.lock);
 
-		/*
-		 * During the traversal we also do some sanity check.
-		 * Trigger the BUG() if there are sides(left/right)
-		 * or full overlaps.
-		 */
-		if (va->va_end <= tmp_va->va_start)
-			link = &(*link)->rb_left;
-		else if (va->va_start >= tmp_va->va_end)
-			link = &(*link)->rb_right;
-		else {
-			WARN(1, "vmalloc bug: 0x%lx-0x%lx overlaps with 0x%lx-0x%lx\n",
-				va->va_start, va->va_end, tmp_va->va_start, tmp_va->va_end);
+	try_init_busy_mt_locked(vn);
 
-			return NULL;
-		}
-	} while (*link);
+	if (likely(vn->busy.mt_enabled)) {
+		MA_STATE(mas, &vn->busy.mt, va->va_start, va->va_end - 1);
 
-	*parent = &tmp_va->rb_node;
-	return link;
-}
+		if (!insert_vmap_area_list_sorted_mt(va, &vn->busy.mt,
+						     &vn->busy.head))
+			return;
 
-static __always_inline struct list_head *
-get_va_next_sibling(struct rb_node *parent, struct rb_node **link)
-{
-	struct list_head *list;
+		err = mas_store_gfp(&mas, va, GFP_ATOMIC | __GFP_NOWARN);
+		if (WARN_ON_ONCE(err))
+			disable_busy_mt_locked(vn);
 
-	if (unlikely(!parent))
-		/*
-		 * The red-black tree where we try to find VA neighbors
-		 * before merging or inserting is empty, i.e. it means
-		 * there is no free vmap space. Normally it does not
-		 * happen but we handle this case anyway.
-		 */
-		return NULL;
+		return;
+	}
 
-	list = &rb_entry(parent, struct vmap_area, rb_node)->list;
-	return (&parent->rb_right == link ? list->next : list);
+	if (!insert_vmap_area_list_sorted(va, &vn->busy.head))
+		return;
 }
 
 static __always_inline void
-__link_va(struct vmap_area *va, struct rb_root *root,
-	struct rb_node *parent, struct rb_node **link,
-	struct list_head *head, bool augment)
+unlink_vmap_area_busy_locked(struct vmap_area *va, struct vmap_node *vn)
 {
-	/*
-	 * VA is still not in the list, but we can
-	 * identify its future previous list_head node.
-	 */
-	if (likely(parent)) {
-		head = &rb_entry(parent, struct vmap_area, rb_node)->list;
-		if (&parent->rb_right != link)
-			head = head->prev;
-	}
+	int err;
 
-	/* Insert to the rb-tree */
-	rb_link_node(&va->rb_node, parent, link);
-	if (augment) {
-		/*
-		 * Some explanation here. Just perform simple insertion
-		 * to the tree. We do not set va->subtree_max_size to
-		 * its current size before calling rb_insert_augmented().
-		 * It is because we populate the tree from the bottom
-		 * to parent levels when the node _is_ in the tree.
-		 *
-		 * Therefore we set subtree_max_size to zero after insertion,
-		 * to let __augment_tree_propagate_from() puts everything to
-		 * the correct order later on.
-		 */
-		rb_insert_augmented(&va->rb_node,
-			root, &free_vmap_area_rb_augment_cb);
-		va->subtree_max_size = 0;
-	} else {
-		rb_insert_color(&va->rb_node, root);
-	}
+	lockdep_assert_held(&vn->busy.lock);
 
-	/* Address-sort this list */
-	list_add(&va->list, head);
-}
+	MA_STATE(mas, &vn->busy.mt, va->va_start, va->va_end - 1);
 
-static __always_inline void
-link_va(struct vmap_area *va, struct rb_root *root,
-	struct rb_node *parent, struct rb_node **link,
-	struct list_head *head)
-{
-	__link_va(va, root, parent, link, head, false);
-}
+	list_del_init(&va->list);
 
-static __always_inline void
-link_va_augment(struct vmap_area *va, struct rb_root *root,
-	struct rb_node *parent, struct rb_node **link,
-	struct list_head *head)
-{
-	__link_va(va, root, parent, link, head, true);
-}
+	try_init_busy_mt_locked(vn);
 
-static __always_inline void
-__unlink_va(struct vmap_area *va, struct rb_root *root, bool augment)
-{
-	if (WARN_ON(RB_EMPTY_NODE(&va->rb_node)))
+	if (unlikely(!vn->busy.mt_enabled))
 		return;
 
-	if (augment)
-		rb_erase_augmented(&va->rb_node,
-			root, &free_vmap_area_rb_augment_cb);
-	else
-		rb_erase(&va->rb_node, root);
-
-	list_del_init(&va->list);
-	RB_CLEAR_NODE(&va->rb_node);
+	err = mas_store_gfp(&mas, NULL, GFP_ATOMIC | __GFP_NOWARN);
+	if (WARN_ON_ONCE(err))
+		disable_busy_mt_locked(vn);
 }
 
 static __always_inline void
-unlink_va(struct vmap_area *va, struct rb_root *root)
+insert_vmap_area_lazy_locked(struct vmap_area *va, struct vmap_node *vn)
 {
-	__unlink_va(va, root, false);
-}
+	int err;
 
-static __always_inline void
-unlink_va_augment(struct vmap_area *va, struct rb_root *root)
-{
-	__unlink_va(va, root, true);
+	lockdep_assert_held(&vn->lazy.lock);
+
+	try_init_lazy_mt_locked(vn);
+
+	if (likely(vn->lazy.mt_enabled)) {
+		MA_STATE(mas, &vn->lazy.mt, va->va_start, va->va_end - 1);
+
+		if (!insert_vmap_area_list_sorted_mt(va, &vn->lazy.mt,
+						     &vn->lazy.head))
+			return;
+
+		err = mas_store_gfp(&mas, va, GFP_ATOMIC | __GFP_NOWARN);
+		if (WARN_ON_ONCE(err))
+			disable_lazy_mt_locked(vn);
+
+		return;
+	}
+
+	if (!insert_vmap_area_list_sorted(va, &vn->lazy.head))
+		return;
 }
 
-#if DEBUG_AUGMENT_PROPAGATE_CHECK
-/*
- * Gets called when remove the node and rotate.
- */
-static __always_inline unsigned long
-compute_subtree_max_size(struct vmap_area *va)
+static __always_inline bool
+lazy_vmap_areas_empty_locked(struct vmap_node *vn)
 {
-	return max3(va_size(va),
-		get_subtree_max_size(va->rb_node.rb_left),
-		get_subtree_max_size(va->rb_node.rb_right));
+	lockdep_assert_held(&vn->lazy.lock);
+
+	try_init_lazy_mt_locked(vn);
+
+	if (likely(vn->lazy.mt_enabled))
+		return mtree_empty(&vn->lazy.mt);
+
+	return list_empty(&vn->lazy.head);
 }
 
-static void
-augment_tree_propagate_check(void)
+static __always_inline void
+move_lazy_vmap_areas_to_purge_locked(struct vmap_node *vn)
 {
 	struct vmap_area *va;
-	unsigned long computed_size;
+	int err;
 
-	list_for_each_entry(va, &free_vmap_area_list, list) {
-		computed_size = compute_subtree_max_size(va);
-		if (computed_size != va->subtree_max_size)
-			pr_emerg("tree is corrupted: %lu, %lu\n",
-				va_size(va), va->subtree_max_size);
+	lockdep_assert_held(&vn->lazy.lock);
+
+	try_init_lazy_mt_locked(vn);
+
+	if (likely(vn->lazy.mt_enabled)) {
+		list_for_each_entry(va, &vn->lazy.head, list) {
+			MA_STATE(mas, &vn->lazy.mt, va->va_start, va->va_end - 1);
+
+			err = mas_store_gfp(&mas, NULL, GFP_ATOMIC | __GFP_NOWARN);
+			if (WARN_ON_ONCE(err)) {
+				disable_lazy_mt_locked(vn);
+				break;
+			}
+		}
+
+		if (vn->lazy.mt_enabled && WARN_ON_ONCE(!mtree_empty(&vn->lazy.mt)))
+			disable_lazy_mt_locked(vn);
 	}
+
+	list_replace_init(&vn->lazy.head, &vn->purge_list);
 }
-#endif
 
-/*
- * This function populates subtree_max_size from bottom to upper
- * levels starting from VA point. The propagation must be done
- * when VA size is modified by changing its va_start/va_end. Or
- * in case of newly inserting of VA to the tree.
- *
- * It means that __augment_tree_propagate_from() must be called:
- * - After VA has been inserted to the tree(free path);
- * - After VA has been shrunk(allocation path);
- * - After VA has been increased(merging path).
- *
- * Please note that, it does not mean that upper parent nodes
- * and their subtree_max_size are recalculated all the time up
- * to the root node.
- *
- *       4--8
- *        /\
- *       /  \
- *      /    \
- *    2--2  8--8
- *
- * For example if we modify the node 4, shrinking it to 2, then
- * no any modification is required. If we shrink the node 2 to 1
- * its subtree_max_size is updated only, and set to 1. If we shrink
- * the node 8 to 6, then its subtree_max_size is set to 6 and parent
- * node becomes 4--6.
- */
-static __always_inline void
-augment_tree_propagate_from(struct vmap_area *va)
+static __always_inline bool
+insert_vmap_area_free_locked(struct vmap_area *va)
 {
-	/*
-	 * Populate the tree from bottom towards the root until
-	 * the calculated maximum available size of checked node
-	 * is equal to its current one.
-	 */
-	free_vmap_area_rb_augment_cb_propagate(&va->rb_node, NULL);
+	lockdep_assert_held(&free_vmap_area_lock);
 
-#if DEBUG_AUGMENT_PROPAGATE_CHECK
-	augment_tree_propagate_check();
-#endif
-}
+	try_init_free_mt_locked();
 
-static void
-insert_vmap_area(struct vmap_area *va,
-	struct rb_root *root, struct list_head *head)
-{
-	struct rb_node **link;
-	struct rb_node *parent;
+	if (likely(free_mt_supported())) {
+		if (!insert_vmap_area_list_sorted_mt(va, &free_vmap_area_mt,
+						     &free_vmap_area_list))
+			return false;
 
-	link = find_va_links(va, root, NULL, &parent);
-	if (link)
-		link_va(va, root, parent, link, head);
+		free_mt_store_va_locked(va);
+	} else {
+		if (!insert_vmap_area_list_sorted(va, &free_vmap_area_list))
+			return false;
+	}
+
+	return true;
 }
 
-static void
-insert_vmap_area_augment(struct vmap_area *va,
-	struct rb_node *from, struct rb_root *root,
-	struct list_head *head)
+static __always_inline void
+unlink_vmap_area_free_locked(struct vmap_area *va)
 {
-	struct rb_node **link;
-	struct rb_node *parent;
+	lockdep_assert_held(&free_vmap_area_lock);
 
-	if (from)
-		link = find_va_links(va, NULL, from, &parent);
-	else
-		link = find_va_links(va, root, NULL, &parent);
+	if (WARN_ON_ONCE(list_empty(&va->list)))
+		return;
 
-	if (link) {
-		link_va_augment(va, root, parent, link, head);
-		augment_tree_propagate_from(va);
-	}
+	if (likely(free_mt_supported()))
+		free_mt_erase_va_locked(va);
+
+	list_del_init(&va->list);
 }
 
 /*
@@ -1804,29 +1698,20 @@ insert_vmap_area_augment(struct vmap_area *va,
  * ongoing.
  */
 static __always_inline struct vmap_area *
-__merge_or_add_vmap_area(struct vmap_area *va,
-	struct rb_root *root, struct list_head *head, bool augment)
+__merge_or_add_vmap_area(struct vmap_area *va, struct list_head *head, bool update_mt)
 {
 	struct vmap_area *sibling;
 	struct list_head *next;
-	struct rb_node **link;
-	struct rb_node *parent;
+	unsigned long old_start, old_end;
 	bool merged = false;
 
-	/*
-	 * Find a place in the tree where VA potentially will be
-	 * inserted, unless it is merged with its sibling/siblings.
-	 */
-	link = find_va_links(va, root, NULL, &parent);
-	if (!link)
-		return NULL;
+	if (update_mt && free_mt_supported())
+		next = find_vmap_area_insert_point_mt(va, &free_vmap_area_mt, head);
+	else
+		next = find_vmap_area_insert_point_list(va, head);
 
-	/*
-	 * Get next node of VA to check if merging can be done.
-	 */
-	next = get_va_next_sibling(parent, link);
-	if (unlikely(next == NULL))
-		goto insert;
+	if (!next)
+		return NULL;
 
 	/*
 	 * start            end
@@ -1838,7 +1723,11 @@ __merge_or_add_vmap_area(struct vmap_area *va,
 	if (next != head) {
 		sibling = list_entry(next, struct vmap_area, list);
 		if (sibling->va_start == va->va_end) {
+			old_start = sibling->va_start;
+			old_end = sibling->va_end;
 			sibling->va_start = va->va_start;
+			if (update_mt && free_mt_supported())
+				free_mt_update_va_locked(sibling, old_start, old_end);
 
 			/* Free vmap_area object. */
 			kmem_cache_free(vmap_area_cachep, va);
@@ -1862,14 +1751,20 @@ __merge_or_add_vmap_area(struct vmap_area *va,
 			/*
 			 * If both neighbors are coalesced, it is important
 			 * to unlink the "next" node first, followed by merging
-			 * with "previous" one. Otherwise the tree might not be
-			 * fully populated if a sibling's augmented value is
-			 * "normalized" because of rotation operations.
+			 * with "previous" one.
 			 */
-			if (merged)
-				__unlink_va(va, root, augment);
+			if (merged) {
+				if (update_mt)
+					unlink_vmap_area_free_locked(va);
+				else
+					list_del_init(&va->list);
+			}
 
+			old_start = sibling->va_start;
+			old_end = sibling->va_end;
 			sibling->va_end = va->va_end;
+			if (update_mt && free_mt_supported())
+				free_mt_update_va_locked(sibling, old_start, old_end);
 
 			/* Free vmap_area object. */
 			kmem_cache_free(vmap_area_cachep, va);
@@ -1880,31 +1775,97 @@ __merge_or_add_vmap_area(struct vmap_area *va,
 		}
 	}
 
-insert:
-	if (!merged)
-		__link_va(va, root, parent, link, head, augment);
+	if (!merged) {
+		if (update_mt)
+			insert_vmap_area_free_locked(va);
+		else
+			list_add_tail(&va->list, next);
+	}
 
 	return va;
 }
 
 static __always_inline struct vmap_area *
 merge_or_add_vmap_area(struct vmap_area *va,
-	struct rb_root *root, struct list_head *head)
+	struct list_head *head)
 {
-	return __merge_or_add_vmap_area(va, root, head, false);
+	return __merge_or_add_vmap_area(va, head, false);
 }
 
 static __always_inline struct vmap_area *
-merge_or_add_vmap_area_augment(struct vmap_area *va,
-	struct rb_root *root, struct list_head *head)
+merge_or_add_vmap_area_free_locked(struct vmap_area *va)
 {
-	va = __merge_or_add_vmap_area(va, root, head, true);
-	if (va)
-		augment_tree_propagate_from(va);
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	va = __merge_or_add_vmap_area(va, &free_vmap_area_list, true);
+	if (va && va->va_start < free_vmap_alloc_hint)
+		free_vmap_alloc_hint = va->va_start;
 
 	return va;
 }
 
+/*
+ * Transitional wrappers retained until all legacy rb call sites are switched.
+ * Follow-up patches in this series remove these wrappers.
+ */
+static __always_inline void
+insert_vmap_area(struct vmap_area *va, struct rb_root *root,
+		 struct list_head *head)
+{
+	struct vmap_node *vn = addr_to_node(va->va_start);
+
+	if (head == &free_vmap_area_list) {
+		insert_vmap_area_free_locked(va);
+		return;
+	}
+
+	if (head == &vn->lazy.head) {
+		insert_vmap_area_lazy_locked(va, vn);
+		return;
+	}
+
+	insert_vmap_area_busy_locked(va, vn);
+}
+
+static __always_inline void
+insert_vmap_area_augment(struct vmap_area *va, struct rb_node *from,
+			 struct rb_root *root, struct list_head *head)
+{
+	insert_vmap_area(va, root, head);
+}
+
+static __always_inline void unlink_va(struct vmap_area *va, struct rb_root *root)
+{
+	struct vmap_node *vn = addr_to_node(va->va_start);
+
+	if (root == &free_vmap_area_root) {
+		unlink_vmap_area_free_locked(va);
+		return;
+	}
+
+	unlink_vmap_area_busy_locked(va, vn);
+}
+
+static __always_inline void
+unlink_va_augment(struct vmap_area *va, struct rb_root *root)
+{
+	unlink_va(va, root);
+}
+
+static __always_inline void augment_tree_propagate_from(struct vmap_area *va)
+{
+}
+
+static __always_inline struct vmap_area *
+merge_or_add_vmap_area_augment(struct vmap_area *va, struct rb_root *root,
+			       struct list_head *head)
+{
+	if (head == &free_vmap_area_list)
+		return merge_or_add_vmap_area_free_locked(va);
+
+	return merge_or_add_vmap_area(va, head);
+}
+
 static __always_inline bool
 is_within_this_va(struct vmap_area *va, unsigned long size,
 	unsigned long align, unsigned long vstart)
@@ -1924,74 +1885,103 @@ is_within_this_va(struct vmap_area *va, unsigned long size,
 	return (nva_start_addr + size <= va->va_end);
 }
 
-/*
- * Find the first free block(lowest start address) in the tree,
- * that will accomplish the request corresponding to passing
- * parameters. Please note, with an alignment bigger than PAGE_SIZE,
- * a search length is adjusted to account for worst case alignment
- * overhead.
- */
 static __always_inline struct vmap_area *
-find_vmap_lowest_match(struct rb_root *root, unsigned long size,
-	unsigned long align, unsigned long vstart, bool adjust_search_size)
+find_vmap_lowest_match_list(struct list_head *head, unsigned long size,
+			    unsigned long align, unsigned long vstart)
 {
 	struct vmap_area *va;
-	struct rb_node *node;
-	unsigned long length;
 
-	/* Start from the root. */
-	node = root->rb_node;
+	list_for_each_entry(va, head, list) {
+		if (!is_within_this_va(va, size, align, vstart))
+			continue;
 
-	/* Adjust the search size for alignment overhead. */
-	length = adjust_search_size ? size + align - 1 : size;
+		return va;
+	}
 
-	while (node) {
-		va = rb_entry(node, struct vmap_area, rb_node);
+	return NULL;
+}
 
-		if (get_subtree_max_size(node->rb_left) >= length &&
-				vstart < va->va_start) {
-			node = node->rb_left;
-		} else {
-			if (is_within_this_va(va, size, align, vstart))
-				return va;
+static __always_inline unsigned long
+clamp_vmap_alloc_hint(unsigned long hint, unsigned long vstart,
+		      unsigned long vend)
+{
+	if (hint < vstart || hint >= vend)
+		return vstart;
 
-			/*
-			 * Does not make sense to go deeper towards the right
-			 * sub-tree if it does not have a free block that is
-			 * equal or bigger to the requested search length.
-			 */
-			if (get_subtree_max_size(node->rb_right) >= length) {
-				node = node->rb_right;
-				continue;
-			}
+	return hint;
+}
 
-			/*
-			 * OK. We roll back and find the first right sub-tree,
-			 * that will satisfy the search criteria. It can happen
-			 * due to "vstart" restriction or an alignment overhead
-			 * that is bigger then PAGE_SIZE.
-			 */
-			while ((node = rb_parent(node))) {
-				va = rb_entry(node, struct vmap_area, rb_node);
-				if (is_within_this_va(va, size, align, vstart))
+/*
+ * Next-fit scan with wrap-around. Use maple to jump to the first candidate
+ * around the hint in O(log n), then continue on the ordered list for cheap
+ * neighbour traversal and deterministic coalescing behaviour.
+ */
+static __always_inline struct vmap_area *
+find_vmap_match_list_next_fit(struct list_head *head, unsigned long size,
+			      unsigned long align, unsigned long vstart,
+			      unsigned long vend)
+{
+	struct vmap_area *va, *start = NULL;
+	unsigned long hint;
+	bool wrapped;
+
+	hint = clamp_vmap_alloc_hint(free_vmap_alloc_hint, vstart, vend);
+
+	if (hint != vstart) {
+		if (free_mt_supported())
+			start = __find_vmap_area_exceed_addr_mt(hint,
+								&free_vmap_area_mt);
+
+		if (start) {
+			va = start;
+			list_for_each_entry_from(va, head, list) {
+				if (is_within_this_va(va, size, align, hint))
 					return va;
+			}
+		} else {
+			list_for_each_entry(va, head, list) {
+				if (va->va_end <= hint)
+					continue;
 
-				if (get_subtree_max_size(node->rb_right) >= length &&
-						vstart <= va->va_start) {
-					/*
-					 * Shift the vstart forward. Please note, we update it with
-					 * parent's start address adding "1" because we do not want
-					 * to enter same sub-tree after it has already been checked
-					 * and no suitable free block found there.
-					 */
-					vstart = va->va_start + 1;
-					node = node->rb_right;
-					break;
-				}
+				if (is_within_this_va(va, size, align, hint))
+					return va;
 			}
 		}
 	}
 
+	wrapped = (hint != vstart);
+	list_for_each_entry(va, head, list) {
+		if (wrapped) {
+			if (start && va == start)
+				break;
+			if (!start && va->va_start >= hint)
+				break;
+		}
+
+		if (is_within_this_va(va, size, align, vstart))
+			return va;
+	}
+
+	return NULL;
+}
+
+static __always_inline struct vmap_area *
+find_vmap_lowest_match_mt(struct maple_tree *tree, unsigned long size,
+			  unsigned long align, unsigned long vstart)
+{
+	MA_STATE(mas, tree, vstart, vstart);
+	struct vmap_area *va;
+
+	mas_set(&mas, vstart);
+	va = mas_find(&mas, ULONG_MAX);
+
+	while (va) {
+		if (is_within_this_va(va, size, align, vstart))
+			return va;
+
+		va = mas_next(&mas, ULONG_MAX);
+	}
+
 	return NULL;
 }
 
@@ -2015,8 +2005,8 @@ find_vmap_lowest_linear_match(struct list_head *head, unsigned long size,
 }
 
 static void
-find_vmap_lowest_match_check(struct rb_root *root, struct list_head *head,
-			     unsigned long size, unsigned long align)
+find_vmap_lowest_match_check(struct list_head *head, unsigned long size,
+			     unsigned long align)
 {
 	struct vmap_area *va_1, *va_2;
 	unsigned long vstart;
@@ -2025,7 +2015,10 @@ find_vmap_lowest_match_check(struct rb_root *root, struct list_head *head,
 	get_random_bytes(&rnd, sizeof(rnd));
 	vstart = VMALLOC_START + rnd;
 
-	va_1 = find_vmap_lowest_match(root, size, align, vstart, false);
+	if (free_mt_supported())
+		va_1 = find_vmap_lowest_match_mt(&free_vmap_area_mt, size, align, vstart);
+	else
+		va_1 = find_vmap_lowest_linear_match(head, size, align, vstart);
 	va_2 = find_vmap_lowest_linear_match(head, size, align, vstart);
 
 	if (va_1 != va_2)
@@ -2069,11 +2062,12 @@ classify_va_fit_type(struct vmap_area *va,
 }
 
 static __always_inline int
-va_clip(struct rb_root *root, struct list_head *head,
-		struct vmap_area *va, unsigned long nva_start_addr,
-		unsigned long size)
+va_clip(struct vmap_area *va, unsigned long nva_start_addr,
+	unsigned long size)
 {
 	struct vmap_area *lva = NULL;
+	unsigned long old_start = va->va_start;
+	unsigned long old_end = va->va_end;
 	enum fit_type type = classify_va_fit_type(va, nva_start_addr, size);
 
 	if (type == FL_FIT_TYPE) {
@@ -2084,7 +2078,7 @@ va_clip(struct rb_root *root, struct list_head *head,
 		 * V      NVA      V
 		 * |---------------|
 		 */
-		unlink_va_augment(va, root);
+		unlink_vmap_area_free_locked(va);
 		kmem_cache_free(vmap_area_cachep, va);
 	} else if (type == LE_FIT_TYPE) {
 		/*
@@ -2159,10 +2153,11 @@ va_clip(struct rb_root *root, struct list_head *head,
 	}
 
 	if (type != FL_FIT_TYPE) {
-		augment_tree_propagate_from(va);
+		if (free_mt_supported())
+			free_mt_update_va_locked(va, old_start, old_end);
 
 		if (lva)	/* type == NE_FIT_TYPE */
-			insert_vmap_area_augment(lva, &va->rb_node, root, head);
+			insert_vmap_area_free_locked(lva);
 	}
 
 	return 0;
@@ -2170,7 +2165,6 @@ va_clip(struct rb_root *root, struct list_head *head,
 
 static unsigned long
 va_alloc(struct vmap_area *va,
-		struct rb_root *root, struct list_head *head,
 		unsigned long size, unsigned long align,
 		unsigned long vstart, unsigned long vend)
 {
@@ -2187,7 +2181,7 @@ va_alloc(struct vmap_area *va,
 		return -ERANGE;
 
 	/* Update the free vmap_area. */
-	ret = va_clip(root, head, va, nva_start_addr, size);
+	ret = va_clip(va, nva_start_addr, size);
 	if (WARN_ON_ONCE(ret))
 		return ret;
 
@@ -2199,35 +2193,37 @@ va_alloc(struct vmap_area *va,
  * Otherwise an error value is returned that indicates failure.
  */
 static __always_inline unsigned long
-__alloc_vmap_area(struct rb_root *root, struct list_head *head,
-	unsigned long size, unsigned long align,
-	unsigned long vstart, unsigned long vend)
+__alloc_vmap_area(unsigned long size, unsigned long align,
+		  unsigned long vstart, unsigned long vend)
 {
-	bool adjust_search_size = true;
 	unsigned long nva_start_addr;
 	struct vmap_area *va;
 
+	lockdep_assert_held(&free_vmap_area_lock);
+
 	/*
-	 * Do not adjust when:
-	 *   a) align <= PAGE_SIZE, because it does not make any sense.
-	 *      All blocks(their start addresses) are at least PAGE_SIZE
-	 *      aligned anyway;
-	 *   b) a short range where a requested size corresponds to exactly
-	 *      specified [vstart:vend] interval and an alignment > PAGE_SIZE.
-	 *      With adjusted search length an allocation would not succeed.
+	 * Next-fit with wrap-around lowers repeated list-head scans in
+	 * high-churn workloads.
 	 */
-	if (align <= PAGE_SIZE || (align > PAGE_SIZE && (vend - vstart) == size))
-		adjust_search_size = false;
+	va = find_vmap_match_list_next_fit(&free_vmap_area_list, size, align,
+					   vstart, vend);
 
-	va = find_vmap_lowest_match(root, size, align, vstart, adjust_search_size);
 	if (unlikely(!va))
 		return -ENOENT;
 
-	nva_start_addr = va_alloc(va, root, head, size, align, vstart, vend);
+	nva_start_addr = va_alloc(va, size, align, vstart, vend);
+	if (!IS_ERR_VALUE(nva_start_addr)) {
+		unsigned long next_hint;
+
+		if (check_add_overflow(nva_start_addr, size, &next_hint))
+			free_vmap_alloc_hint = vstart;
+		else
+			free_vmap_alloc_hint = next_hint;
+	}
 
 #if DEBUG_AUGMENT_LOWEST_MATCH_CHECK
 	if (!IS_ERR_VALUE(nva_start_addr))
-		find_vmap_lowest_match_check(root, head, size, align);
+		find_vmap_lowest_match_check(&free_vmap_area_list, size, align);
 #endif
 
 	return nva_start_addr;
@@ -2441,8 +2437,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 retry:
 	if (IS_ERR_VALUE(addr)) {
 		preload_this_cpu_lock(&free_vmap_area_lock, gfp_mask, node);
-		addr = __alloc_vmap_area(&free_vmap_area_root, &free_vmap_area_list,
-			size, align, vstart, vend);
+		addr = __alloc_vmap_area(size, align, vstart, vend);
 		spin_unlock(&free_vmap_area_lock);
 
 		/*
@@ -2589,7 +2584,6 @@ static void
 decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 {
 	LIST_HEAD(decay_list);
-	struct rb_root decay_root = RB_ROOT;
 	struct vmap_area *va, *nva;
 	unsigned long n_decay, pool_len;
 	int i;
@@ -2618,7 +2612,7 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 				break;
 
 			list_del_init(&va->list);
-			merge_or_add_vmap_area(va, &decay_root, &decay_list);
+			merge_or_add_vmap_area(va, &decay_list);
 		}
 
 		/*
@@ -5456,8 +5450,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;
 
-		ret = va_clip(&free_vmap_area_root,
-			&free_vmap_area_list, va, start, size);
+		ret = va_clip(va, start, size);
 		if (WARN_ON_ONCE(unlikely(ret)))
 			/* It is a BUG(), but trigger recovery instead. */
 			goto recovery;

-- 
2.34.1


