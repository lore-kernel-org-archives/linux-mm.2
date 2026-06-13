Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F39CD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5D16B0005; Sat, 13 Jun 2026 13:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486F66B008A; Sat, 13 Jun 2026 13:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34EA26B008C; Sat, 13 Jun 2026 13:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 213F46B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:20:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9FAC140446
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:29 +0000 (UTC)
X-FDA: 84875553378.04.9DFFC6F
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA6F240014
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="hzOa0aP/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=JQ7Z+dSl;
	spf=pass (imf27.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371227;
	b=QwseQd8kBxisWx+tcptQQlf/OA2YihVMUVRgPrfWY/5/RinXr8twBTSoB1SIjxe/00kepa
	aNB62EPCFmBg0EGLV1PkFV2xixv02CxhVv0meae8z4D1sTqVIXQ/lJNB3Ex3bOVMWyh8GT
	oh1ESW7pRFa+0knRuxXKMHonJ0SwTmI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="hzOa0aP/";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=JQ7Z+dSl;
	spf=pass (imf27.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SFwY1cVGy7O7iRsmuMmTz2lob6iJy672xeQWyTFfBQ8=;
	b=k8Qvb7HmV8uZX4POPKxPHZ7tNhX3XFho1uxw6olPeZjkxNSUvU9fGICJMXlYDcy3JEWMDK
	O/Jk6S7GFayrpcwGhEqcyVc2RteU9/ZRRETrVm5+Lo2mDUgW7HzRzJafvCuP7eguq9kkWp
	AntK5hv1d7H8DRtFNC5uVhYYD8uwmb4=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DF9iQ82785670
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=SFwY1cVGy7O7iRsmuMmTz2
	lob6iJy672xeQWyTFfBQ8=; b=hzOa0aP/TsDIcmr+is8HKVg6GBPCrSEtg1CMfZ
	a9WfJvRd52rqlgFYaVIbOx5YOujf3cCdrZo5cUN58H4DTmBkBp2yUwwxhq3JdH9h
	huQXK1dN1gi/3wpTpjRZCFk1kHICC/O6FJmMi3SyTcwpTXsrAzyLPoNcfsZ2wO/p
	DnHs6QO/sdhuI+399WpRP0uozikCeMRTrkR4+QOzm6Bia/E/QVE0Pm3qWvVWNgph
	tTiD2Z0nXRGE8s6pCOdeWxxS51JgrCJvEEuxA5zqnGhHQugOmTdaSzhwszwTbmlL
	gz7UQ2ScQfOV+F8/MLAOUPTutyKZnYOmqmBcv17eiYTiRDyA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4es0cghgwt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:25 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84240683a82so1459725b3a.1
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371224; x=1781976024; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SFwY1cVGy7O7iRsmuMmTz2lob6iJy672xeQWyTFfBQ8=;
        b=JQ7Z+dSl8TgSSs3kt5qzEGEuyRNI7NDpDT0zf6kAEG2sK5RzIv/SfFOyAKwRq/bIqy
         8EysYtyfE4x5logbnX6i4zi7i1trb1iiI87HGNcgl7ACNFYZPQAVthq+l/vyJ/9iNjD3
         aCc5pbOx1jM3Vwdtr9jkVRz7bfAth27dgXd/dRZmngkaoHA0zd5QhKoTWehgBSAOwKnX
         IlIQhL6vPY569JZkc2+pircaKGoLyKCADoR75hPqq2nCjepXwZwxdhuxqM1741X1hukv
         Y7gAdU0+tnyb8RAS4rxd5mLMWPcYQMtZZbN3cUhE5sqUABH9ZVJac0dJxWx84V+jZAPM
         ZP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371224; x=1781976024;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SFwY1cVGy7O7iRsmuMmTz2lob6iJy672xeQWyTFfBQ8=;
        b=YpPL0aP9JMkPRqnLWxy7eOc9vsv4Q58QRUQfK67AfgQT68dFbUnsWx20VhkCQyJvuU
         WbHO4OyNhqiBwpKdQhscuhjz/o89pz7ssclcif9BQmoHLiqpDSIzfqU7hcMjlf7yyOvz
         jJCVJNLJC9O9mu0bi5ADUcJwFyI7OEL7BDLon3SLlwS2B/WKgTFt5GrtNBqooZ/yZVal
         4ZMu6vFkEUxZSWNnRs6vS7uQ4d48EWQKS1ABjIOzw5UK//MqfSpeghGBWSDhQVfcEQMx
         fvJsdjiqOr+dFA1kV4xGEUV2EE1Y1BxN4ZWMSBmVPHR2WwHWOPdOPfj/X7Gixlwmk7n4
         FRdQ==
X-Forwarded-Encrypted: i=1; AFNElJ/ihMcdiGvL4vxkyU5qVbU/SjgXX1p93jS33ysVB0QdkTei8VuhRwlUQ38of1jodyw+sCD0PYt2tg==@kvack.org
X-Gm-Message-State: AOJu0Yw1SGyuYwVidHJzXICQll2BfS+qnpStaqXi7J0fK5IZWAMHMmbp
	57qD24KrYJvtdn7J+jAM/DbitTaSeaZlAO4S6L5QmDJj3ikC6aSYXUnH9MtuQA+kmvrZrE3M39r
	9GgpbLfJUJtKrZEK0Epq20KlTCjSZWpILH7d52EwgXInFFW70qbJAaQ==
X-Gm-Gg: Acq92OHxd5ouFF+FYvXFTiGKiPvI868/UjkF7cXxUujSnJdVa9z8xohVOAe1bPJ6wup
	/8eEnmxm9wX6H2mLBLj4bgwPYK80IGUEFC/g/eAoKwAtk7ggJx9Xy1O95UBnpbmg6oJGM+rCE3z
	PpHov8g11UYtQQ8jdccHmeSVaU7Zz4nsEaBBfpxiEO1IjrRjyPYjw0JjudL8ZtyDaLM4dOQanV+
	P1XP5pazBDoPN2xBht15DEK2buKxlHysPW20cJ5k0HMabMnOFBrwLwMhlmrpAFdx0WwB6F6DkTL
	GFj0sNNVGkj52l/euQvrl2uJJknuKdOjy75ikwcEloZ/TVkG7UA+E7yJpkWjavHy0TBfagpYQ6M
	l4vNeTGMsOQOO3kIXlqRNL0NFGliboZmaFcfUahFgMM8+frSNGetCfw==
X-Received: by 2002:a05:6a00:1951:b0:842:3d8d:babb with SMTP id d2e1a72fcca58-8434954765emr6974833b3a.2.1781371224230;
        Sat, 13 Jun 2026 10:20:24 -0700 (PDT)
X-Received: by 2002:a05:6a00:1951:b0:842:3d8d:babb with SMTP id d2e1a72fcca58-8434954765emr6974804b3a.2.1781371223676;
        Sat, 13 Jun 2026 10:20:23 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:20:23 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Subject: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Date: Sat, 13 Jun 2026 22:49:42 +0530
Message-Id: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC6RLWoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDM0Nj3bLcxJyc/OT43MSCnFRdy2RLs7TUVIvUxORUJaCegqLUtMwKsHn
 RSkFuzkqxEMHi0qSs1OQSkElKtbUARrRo83YAAAA=
X-Change-ID: 20260613-vmalloc_maple-9c96fee8eace
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=12885;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=078Rn9HRSv89Rn+MUYRZY55Vxl8XkfUICgXKlh9NAec=;
 b=M1mBaqJ/zbG+WYeYcX58kwiZtXFR8A27VjnD97AEGHo09TnjZnBlSfqz86TMJWIFJCkoeLF2V
 S8tLwy6t/aFDp7lO6BTwbHFuRYhFxNJDT0UKWE9UnaGrEg6oe4EOxyR
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Proofpoint-ORIG-GUID: Emf4T80xD28d4bWr3ZkiTDtsd6XS8ofG
X-Authority-Analysis: v=2.4 cv=NPLlPU6g c=1 sm=1 tr=0 ts=6a2d9159 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=H29dQRUrwOwFP1tYY8AA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: Emf4T80xD28d4bWr3ZkiTDtsd6XS8ofG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfXxdQ4h7Lns4mC
 e8G+B6x2MSFpp9seWyfeZFKbY1mxavU+x80HwwPInksSAFAXfov1b4Kc1ErFPjcLYJlX5HRe1im
 GIVBgyoDsHdA8Xk1xrdl/BP8BfshGOk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX4EE9D1OUDfmP
 ZaM/ooO+kn9aHRfDX2IAj+8P0P16MPVjA81C+xVI4L4IhjWrS2Tn15X5neengtuSz09SasIcMoV
 uaSrF8TkzpZv+RyZvJSuomfpeZ0D5A8kFcL0VEBiX1+1XJOkCyyknE1yFRDS1Td52ngjtKDzlQa
 0hFKltv0vlN2Y5AMxiBeBOn+6ZW3feXBtUtUaii/hrxMbx09AZY3PIES9H5ksm8dt2NfI0h7WSj
 o8I1kZngMVk2eBDKUCVmx3o2r9uI0VEg6a0MZp071crntRK0RjyO8IjVUahx6v6fOaP8JO3oJtO
 D9qess6IClYnBXK5ajZ28JffbYEoTeDAXorAitaHbWVg2EGFYq2HoJn6XW5Y8UMVfOEqj9LEbyn
 glKbZQgMZBDXvwi2tBwnnLGr50a2bkXOLD9Bw2D+ascLrHKA+0O8HHEKLJqD35joZGkd2O9vV5/
 b1ENeWhlTJjkCJUZvPg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606130180
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA6F240014
X-Rspam-User: 
X-Stat-Signature: 416thghht7m9npxxmnc8jrhqhyp5a4fu
X-HE-Tag: 1781371226-798686
X-HE-Meta: U2FsdGVkX19ubeejeHLN3OyicXuXnm+AwmsQgUqYUjH/ldRZIh5NwrlZx8+IDZes4O5qbl1F/r940DqyDfOkq4LNFHHYepx20BXA2k9t5aKtyrdlq9QtypSLuMS11TMBnHAa25BCAT8GUd5pmnBqQHAAB+xbHTupj8oCqTtssb1tDPeM6j8qlppbyqC+QsuOPNNf4Dc9tHvXcjGIUGqbomVMDbwwNERHk3DRC/ckYxVnwXNZAZKK58hkNRhSubh1kcJ/EmDEnvTpRPNDGYOoxOjsuirMgsU3WtbR99S2WM2fPJ1CfQ6m9VwsrfRkfskuU+1sa+4MJgBdoqicPsieJnkN++1lDvgCugOf2OmrM8qBo/msnJMKveiFAPLYakPn6ivcyPbfE3bhskfmMrtC4f2d5HiDODuqQN/EwUoNdIb9hK3cNztEbtZeBfGB9WBPQAk1wzwdSJghZkVciJqoZAOTrqkjd24Wfp3ljpnjU3SQyZ+DWms9PtMYg7RUfGW7TQix8oiDefXVnAL1In/GBlK48GBzUWHlDCCiJiBfht1t/bpv2JMjSabtkWbNb32hrZ1e0fFiTW0vZ6MRIOiPcQUM4W5PfSBY+e4w3bnGMJ59sI3QobzURnGCwA7y1Nr7CmWW+gcZTFqKcqy7cc/6qN5S/oaBAE1yQn7obGZytt0XEEvGBir4kuh5JMqnJMm8RNSlnFu1SfHLpWfTdMzBiTdbAfEY4znVQKdmg+EgYzkmqftcvP42Fuo77YUEPL89c1G3atLSdKsvx/58JXaNKm+nchXy8+tYnaeh+RGAexUV3TNwIlTenXs74ZhYY80VRYjcqVZihcW9zyLgY017xjk1/poddcOq/F/eGKSVykYZ28b79tHPl3ui+njVXQWS8+mUGWhqPvzsRMOfJ6QeGw357Av5zTZvfh3PKsnNXx9/XJcKCp02Br1rBcRjYYiWkG5O5Wcuwkj5yQ3w9Fe
 nZt9qscx
 dk3Ry5HwIjnSoNKQrU0OZEJI5Ba8tC2AVxiDrj1IyPYpxn0mBbI5IFuh9hfQPHsvKtML0NgiRCLZjyk3EmxamauH/WKM277vQUXjr72n5gjC3DwGecWnDdYZv5FkE/rqXRroFboLN9/63+SfpJ/cVRuYTRBxtmNZ5bq6TIDw5pmYrpnpVw0LWgi48Bs0jqig8I2L/Ter9W/5Sk+jQBzgQ7M5VDEqIrhnJXzCvAZlV9CPEgOf50vSuaXPGSyr4vO+lYAsQRnPiIX3dBArWItBisz2+6oamXmJNJhdyPKNx886U1hhmj5dAp3ExZLTlnGyEL2aZArF9Cj+5JIJKN6/Utor7iJAbcuOqeat055EIzLlT8Nwzeq1lKDHKrbowheYZmeEsQlHBAFAM/BRMib9Tyxs+vlm8QUPc98ynn3NKHomoB3TM64/7ppUSBJ4kpdQ6UHaynQDCAsgHGRgShdG54+Fdx6qvH+ytaK9BJgz7kNjlwyg+PozQlGTO02gYiOebzHuNaeMyPDuDbxaZUUun2UrnRpvavL7Y80N+RitO2hVGXfFWA8IiN5PaTQbeA3RQ2Gj4CI+ACzRKhZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmalloc's free/busy/lazy area tracking is one of the last remaining
augmented-rb_tree consumers in the core mm allocators. The rest of
mm/ has been gradually consolidating range-keyed indexing around
maple_tree (notably the per-process VMA tree in mm/mmap.c), and
the underlying reason is a structural mismatch between rb_tree and
range tracking:

- rb_tree is a binary tree with a single entry per node. A lookup
  walks log2(N) nodes via a pointer chase that touches log2(N)
  cache lines, with one comparison per node. Range queries are not
  native to rb_tree; vmalloc has historically maintained them by
  augmenting every node with a subtree_max_size field whose value
  has to be recomputed on every insert, erase, and rotation via a
  custom callback. That callback machinery is vmalloc-specific
  code that exists only to coax range semantics out of a
  binary-keyed tree.
- maple_tree stores up to 16 ranges per node (fanout f=16), so a
  lookup walks ~log16(N) nodes in tightly-packed pivot/slot arrays
  that are far more cache-friendly. Range queries are first-class
  (mas_empty_area, mas_find, mas_erase), with no augmentation
  callback to maintain. RCU traversal and sentinel range storage
  (XA_ZERO_ENTRY) are part of the data structure's contract, not
  bolted on by the consumer.

For the vmalloc allocator's hot paths this means shallower walks
under the same N, fewer cache lines touched per lookup, and no
custom augmented-callback machinery to maintain. Aligning vmalloc
with the same range-tree direction the rest of mm/ has taken
collapses the augmented gap walker to a single mas_empty_area()
descent, retires the augmented rb_node from struct vmap_area
(-24 bytes per object on 64-bit), and exposes the range,
sentinel, and RCU primitives needed for a per-CPU range cache
that the augmented rb_tree could not host cleanly.

This series completes the vmalloc internal migration from rb-tree
indexed tracking to maple-tree indexed tracking for free, busy, and
lazy vmap_area range management.

The series removes vmalloc's internal rb-tree dependencies and moves
address indexing and range lookups/scans to maple-tree-backed paths,
while keeping ordered list neighbour traversal where coalescing
semantics require stable predecessor/successor behaviour.

In addition to the direct rb -> maple migration, the series includes
robustness and scalability refinements in the same code path:

- deferred/lazy maple bring-up to avoid early-boot allocator hazards
- maple-assisted ordered-list insertion for busy/lazy tracking
- mas_preallocate / mas_store_prealloc fast path for common-case
  publish work, with a non-indexed retry queue that absorbs the
  rare publish-under-pressure case without leaking or panicking
- single mas_store(NULL, ...) sub-range trim in va_clip() in place
  of an erase-and-restore pair when narrowing a free-area entry
- single mas_erase() for the busy-tree find-then-unlink pair on the
  free path
- consolidation of in-use ranges as a single authoritative index on
  the steady-state allocation hot path
- list_head representation of the lazy-purge queue, since that queue
  is bulk-drained and has no address-keyed query
- per-CPU bump-allocator overlay layered on top of the migrated
  indices for short-lived, page-aligned, common-case allocations
  (design and chunk-size derivation in the 0010-0012 commit
  messages)
- explicit lock/serialisation behaviour preserved (no lock removed)

Primary advantages
==================

- struct vmap_area shrinks by 24 bytes on 64-bit layouts (72 -> 48),
  removing the embedded augmented rb_node and the subtree_max_size
  field that the rb-tree gap walk depended on. Verified with pahole
  on arm64.
- maple_tree's per-node fanout (multiple pivots/slots per node)
  replaces a binary rb-tree descent for indexed lookups, giving a
  shallower walk for the same allocation count.
- alloc-side gap finding moves from a recursive augmented-rb walk to
  mas_empty_area() over the in-use range index, returning the lowest
  matching gap in a single descent.
- vfree of a chunk-resident allocation through the per-CPU overlay
  resolves addr -> vmap_area in O(1) via the chunk's back-pointer
  array, with a bounded fast-reject for addresses outside any
  reserved chunk; the maple-tree busy lookup remains the fallback.
- correctness behaviour preserved: ordered list neighbour traversal
  for coalescing remains; the locking/serialisation model is
  unchanged; lockdep is silent across the test_vmalloc subtest sweep.
- robustness in bring-up and high churn: deferred/lazy maple
  initialisation avoids early-boot allocator hazards; the retry
  queue keeps publish failures under GFP_NOWAIT pressure correct
  without leaking or panicking.

Real-silicon validation
=======================

The series was tested on Qualcomm Snapdragon X1E80100.
The patched kernel was booted on the device against an RB baseline
image of the same kernel revision, and exercised through:

- GFXBench, run for several hours of sustained graphics workload;
  the patched kernel ran clean throughout, with throughput matching
  the RB baseline within run-to-run noise.
- boot-time module loading via the finit_module / kernel_read_file
  path that exercises the bump-allocator's indexed write loop;
  this path drove the patch 0012 hardening, and the patched kernel
  is UBSAN-clean here.
- repeated insmod / rmmod cycles to soak the chunk install / drain
  paths under live workload.

No kernel WARN, BUG, or UBSAN report was observed across the
multi-hour soak.

Quantified validated performance improvements
=============================================

Numbers below compare the current upstream rb-tree-based vmalloc
allocator (baseline) against the final state after applying all 12
patches in this series (patched). Each row reports the median of N
reps under sequential QEMU execution (PARALLEL=1, taskset-pinned
CPUs, nice -n 5) on a production kernel configuration
(CONFIG_DEBUG_VM=n, CONFIG_KASAN=n, CONFIG_LOCKDEP=n,
CONFIG_UBSAN=n). The baseline label is RB; the patched label is MT.

Aggregate observation:

- x86_64 KVM contention sweep (smp=8, 30 reps): improvement on every
  measured nt x mask configuration, range +5.1 % to +43.6 %.
- x86_64 KVM saturation sweep (smp=16, 15 reps): improvement on every
  measured nt x mask configuration, range +28.2 % to +64.9 %.
- arm64 cortex-a72 TCG contention sweep (smp=8, 15 reps):
  improvement on every measured nt x mask configuration, range
  +19.5 % to +32.6 %.
- functional sweep (1 rep, all 12 test_vmalloc masks): all 11
  passing subtests pass on RB and MT; the 12th (mask=64,
  align_shift_alloc_test) is xfail by design and remains xfail on MT.

x86_64 observed faster cases (sorted by gain):

- full_fit_alloc_test, smp=16 nt=16:                  +64.9 %
- long_busy_list_alloc_test, smp=16 nt=16:            +62.9 %
- full_fit_alloc_test, smp=16 nt=8:                   +51.7 %
- long_busy_list_alloc_test, smp=16 nt=8:             +49.3 %
- long_busy_list_alloc_test, smp=8 nt=8:              +43.6 %
- full_fit_alloc_test, smp=8 nt=4:                    +40.4 %
- full_fit_alloc_test, smp=8 nt=8:                    +40.0 %
- full_fit_alloc_test, smp=16 nt=4:                   +38.2 %
- full_fit_alloc_test, smp=8 nt=2:                    +31.2 %
- fix_align_alloc_test, functional sweep:             +30.2 %
- long_busy_list_alloc_test, smp=8 nt=4:              +29.3 %
- long_busy_list_alloc_test, smp=16 nt=4:             +28.2 %
- full_fit_alloc_test, smp=4 nt=2:                    +26.5 %
- full_fit_alloc_test, smp=8 nt=1:                    +20.4 %
- long_busy_list_alloc_test, smp=8 nt=2:              +17.7 %
- long_busy_list_alloc_test, smp=4 nt=2:              +15.3 %

arm64 observed faster cases (sorted by gain):

- long_busy_list_alloc_test, smp=8 nt=8:              +32.6 %
- long_busy_list_alloc_test, smp=8 nt=4:              +26.7 %
- fix_size_alloc_test, functional sweep:              +26.0 %
- full_fit_alloc_test, smp=8 nt=4:                    +25.5 %
- full_fit_alloc_test, smp=8 nt=2:                    +23.4 %
- full_fit_alloc_test, smp=8 nt=1:                    +23.2 %
- full_fit_alloc_test, smp=8 nt=8:                    +22.3 %
- full_fit_alloc_test, functional sweep:              +21.9 %
- long_busy_list_alloc_test, smp=8 nt=2:              +21.2 %
- random_size_align_alloc_test, functional sweep:     +19.9 %
- long_busy_list_alloc_test, smp=8 nt=1:              +19.5 %
- no_block_alloc_test, functional sweep:              +18.0 %
- full_fit_alloc_test, smp=4 nt=2:                    +17.3 %
- kvfree_rcu_1_arg_vmalloc_test, functional sweep:    +16.9 %
- long_busy_list_alloc_test, smp=4 nt=2:              +16.2 %
- random_size_align_alloc_test, smp=4 nt=2:           +14.3 %
- long_busy_list_alloc_test, functional sweep:        +12.6 %
- fix_align_alloc_test, functional sweep:             +12.4 %
- kvfree_rcu_2_arg_vmalloc_test, functional sweep:    +11.0 %
- pcpu_alloc_test, smp=4 nt=2:                        +6.9 %

Memory impact quantification
============================

struct vmap_area shrinks by 24 bytes per object on 64-bit layouts
(72 -> 48; verified with pahole on the patched build vs the RB
baseline). The shrink comes from removing the embedded augmented
rb_node (24 bytes) and the subtree_max_size union member (8 bytes,
formerly union with vm). list_head (16 bytes) and vm (8 bytes) are
retained.

Aggregate savings scale linearly with the number of concurrent live
vmap_area objects on the system.

mm/vmalloc.o text grows by ~47 KB on x86_64 / ~95 KB on arm64
(absorbing the maple-tree call sites and the per-CPU overlay), but
the linker-page-aligned bzImage / Image size is unchanged within
rounding.

QEMU validation and synthetic benchmarks
========================================

In addition to the real-silicon soak, the series was exercised
under QEMU (KVM on x86_64, TCG on arm64):

11 of 12 test_vmalloc subtests PASS on x86_64 and arm64 at series
HEAD. mask=64 (align_shift_alloc_test) reports xfailed=1 by design;
the same xfail is observed on the unpatched RB baseline.

KASAN, lockdep, CONFIG_DEBUG_VM=y, PROVE_LOCKING and CONFIG_UBSAN
boots are clean on both architectures with
test_vmalloc.run_test_mask=0xFFF (full subtest sweep).

Each commit individually compiles mm/vmalloc.o on x86_64 and arm64.
checkpatch.pl --strict reports no errors across the series.

Methodology limitations and reproducibility caveats:

- arm64 numbers in the validated wins above come from cortex-a72
  TCG emulation, so production arm64 silicon
  would be expected to track somewhere between these TCG numbers
  and the x86_64 KVM numbers.
- Independent replay can change the ranking or sign of small
  sub-millisecond deltas in test workloads whose absolute runtime
  is below ~1 ms at the configured test_loop_count; the headline
  workloads (full_fit_alloc_test, long_busy_list_alloc_test) run
  in the tens-to-hundreds-of-ms range and are not affected.

Reproduce
=========

Apply the series with git am, then build with TEST_VMALLOC=y in a
production-config kernel and boot under QEMU:

  $ git am 00*.patch
  $ make defconfig
  $ scripts/config -e TEST_VMALLOC -d DEBUG_VM -d KASAN
  $ make olddefconfig
  $ make -j$(nproc) bzImage
  $ # boot in QEMU with test_vmalloc.run_test_mask=...

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
Pranjal Arya (12):
      mm/vmalloc: introduce maple_tree-based indexing for vmap_area
      mm/vmalloc: convert allocation-side gap finding and insertion to maple_tree
      mm/vmalloc: convert free, purge, and pcpu paths to maple_tree
      mm/vmalloc: finalize maple-only indexing and shrink struct vmap_area
      mm/vmalloc: tighten failure handling under memory pressure
      mm/vmalloc: tighten alloc/free hot paths
      mm/vmalloc: consolidate occupied tree as authoritative index on hot path
      mm/vmalloc: track lazy-purge queue as a list_head
      mm/vmalloc: collapse busy-tree find-then-unlink into a single mas_erase
      mm/vmalloc: per-CPU caching of free ranges from the maple_tree allocator
      mm/vmalloc: O(1) lookup of cached vmap_areas with bounded fast-reject
      mm/vmalloc: harden bump-allocator alloc/free against UBSAN array bounds

 include/linux/vmalloc.h |   16 +-
 lib/maple_tree.c        |    7 +
 mm/vmalloc.c            | 2378 ++++++++++++++++++++++++++++++++++-------------
 3 files changed, 1748 insertions(+), 653 deletions(-)
---
base-commit: c425609d6ac4012c8bbf01ec2e10e801b1923a7b
change-id: 20260613-vmalloc_maple-9c96fee8eace

Best regards,
--  
Pranjal Arya <pranjal.arya@oss.qualcomm.com>


