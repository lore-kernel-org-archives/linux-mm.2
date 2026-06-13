Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95603CD98D8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092ED6B00A0; Sat, 13 Jun 2026 13:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042846B00A1; Sat, 13 Jun 2026 13:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73E96B00A2; Sat, 13 Jun 2026 13:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D42D56B00A0
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:21:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DBE840463
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:27 +0000 (UTC)
X-FDA: 84875555814.08.9CBE25B
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id F3589180007
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=GuMuwRMT;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=bM+Pzm0l;
	spf=pass (imf24.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2jvLZ77aheSe+DZjMUpTRiQcTblxiXsbYokkj4oN64=;
	b=lCY9eGAI8EczbOIbrrpBNW2qeBBbc5KM+QfDUsaEoVOLeXhj2pMR3IacKxO0H9q3MVfJLl
	dQnPUGUvMS6N/f7EFBwrUzg0/u5WapnfZd+Rt4VH9HvbeW0T4n+ie9BbPaVCwZ1av8wwO4
	XfYdJVkvOAFuaaYfDmGIfSg6+g4H3BU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=GuMuwRMT;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=bM+Pzm0l;
	spf=pass (imf24.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371285;
	b=LuqwyLijG6SM4eYasz61rzaeSTch+MG8hAcKCyNilrOPG6GE3LfAE8FlEerMn/Qfv0+09p
	Pc7zhXVIhWguOinx8h6/y8KwPaPVLC7mau5y0vUFKvAa5bAlZY7cvZ2Xk2DkA+8CiUQK+9
	oiqAXcwE9eggNWfthRteykAIdzCXMVk=
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DF9Cj81235274
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	l2jvLZ77aheSe+DZjMUpTRiQcTblxiXsbYokkj4oN64=; b=GuMuwRMT6fUnEqLr
	pC213gqGmouhs21S7DrTYvBiPMsV4SEiEZb0oYQi4HhjH4Nl8ulsTRXX8qRcB+wk
	KIoeVBFWaQxpwWXI6CAf/mOcKFNOYlZ88RdcxvVteMq7Xi81Rbtgo8ayvmOsr0NZ
	6UdlO01TF5PYz9o/AH8c6cvQkS/wkyc+ob7rhawynYsLnbJVDMqhe8zlF4Y0RVS0
	RT2GtsWwLvrwpl0vudoNb9FwNppSnZHeYbWHEbE1mlwBtMjQf7bOs/fV/sHZb0Ua
	sQAo1RWI9DoIyF/PZK1ebUw3vbajZ6Rni1T83CoN29DayOeez+CW49qqrzLjqVnh
	vQtgkg==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eryffhkuv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:23 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c8584e80bfcso950992a12.3
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371283; x=1781976083; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l2jvLZ77aheSe+DZjMUpTRiQcTblxiXsbYokkj4oN64=;
        b=bM+Pzm0loC4NsSAXeS7Soiwetk8m00BLzGm5CSOxZyBw7fCaR+0WucpZCwxCZTssME
         rBblGE/t+tfFvtyWJwljIZsOw73JxLpli5gtawqSiZRMic4x3DhPlr9NeZ3AYJxCdshU
         lEcumZWtI/k0uW3UkKX9EfOGQ/FtTM5eCWHNqclZn74VvDR6drCjhxVWVThcxQHtjfnF
         p+BJPkkQXi7BeH0yd3JpbLpUs+nPGK51a/mUSX7a0DXN21sGbMPmgnzAG8DV79xcMlV/
         twPOiof/JcC6Wy2OB0sOipSxTgsSG77IQZYVMGIWIJfexLjAPEpC6s0rgOrYfxDB0339
         2zgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371283; x=1781976083;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l2jvLZ77aheSe+DZjMUpTRiQcTblxiXsbYokkj4oN64=;
        b=keDkv5oSYCpOEx9n+ImprKYEsSg2EOsneB8gjth380uORAkN99J+nkePsIDLXnXrO3
         PSV8YFGfn3Ff9Z6IMyy8X8cW0nd7g/V/KtotMomhzppJPfCbFX8WtJTepoIkkSuBAowJ
         ZBfxFlz9CuVFW2byrXzUBQ+M//z2kzI9IXcWdOZKaZgpPhMxv+mUs2CBR+ZYOzm/ZwRz
         9t++5D2hNpGu20uwXCIxXAgpF6pm37KIDVZo1PZ+3cXTEE4iL3w7rbsdjCFslNy99ebR
         G5/CLd1m3zow0bk2lLwpyamCfiDgkkPuhHzNp0p9KUPZwODb/t9pkpCewuFZz1UFCiSL
         JqWw==
X-Forwarded-Encrypted: i=1; AFNElJ894w5v4vFDKqYJYFX5Sc9HoYD8ueIPuXgJO+EZJLV11IS5medsG0OjJBgnPSdOI300NbdbkNBN5w==@kvack.org
X-Gm-Message-State: AOJu0YwThYfI1C3iwdyPIsVnPnHb2wpwXUUVnhx4C5yjEJ166/EzJ8sq
	H5Ene+6U/LgTKEmeCRpWqdvSTzDGYR2b6UXwWdZxToo2tEFNVHY27K8yVFCN4H1E96t9sZkRSGL
	YS/a23fAeebGgMzJC9bbMgksAn4w8xfl4o9xsdriplzsfTKmKu5sGeA==
X-Gm-Gg: Acq92OEBXJqeN3CIektVraof3UNmqIeZh9kMnGELqEmYnD/yVRUn3ygh6pI6NNkYlqh
	tf+Z23KeZgSloXzwBipIkYFshEWMJ626wYPQlizZ0b8C4zu29zdJDdBll4/5LDWdhQLRuX+7Mb0
	NHfKgqur/WBpW47Clb2i8cRGSDo+ZM0+1GFikklvYDIo7a0+iF0yBDa5HWGnLGqeYVuKeVSzP4D
	TVBjFE7Sa/YqZtI2i7S1iX0EqeZzzNPeeEcc7RnQNX2XGuflJB6+40iHP68RNl+SCRvF0GDiv+H
	ExltJu08pxkyiCf9LWpli4/KE7ksjQCqJOOgqmKN3GKrhKKQ9KKhP57JJn1WFX7420l/feOwmdj
	I7fNh5Ns+NunKPDFEQKNF+OU/pLKRCu2elk+LBed5jkv6jNjs9ISkpQ==
X-Received: by 2002:a05:6300:408d:b0:3b4:774f:d18e with SMTP id adf61e73a8af0-3b783fb3955mr9237972637.36.1781371282883;
        Sat, 13 Jun 2026 10:21:22 -0700 (PDT)
X-Received: by 2002:a05:6300:408d:b0:3b4:774f:d18e with SMTP id adf61e73a8af0-3b783fb3955mr9237939637.36.1781371282373;
        Sat, 13 Jun 2026 10:21:22 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:21:22 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Date: Sat, 13 Jun 2026 22:49:49 +0530
Subject: [PATCH RFC 07/12] mm/vmalloc: consolidate occupied tree as
 authoritative index on hot path
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260613-vmalloc_maple-v1-7-0aa740bb944b@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=11442;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=3LvVzlcvTfxyqrRYasoLmm+6K2iynv8qA2cCL5g/TxM=;
 b=nqUV4Kw0eSIXuP8FCMkdgzDqt1rMN9t/16SjpKiMChJQMzFkHtSb1Hgy1AomHVYAHaBNoGEE6
 i18NaLje/ndC3qri/cczcfs/kygPhF23UV2KxUmTnbyFs28Fwq+DAUT
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Authority-Analysis: v=2.4 cv=HuxG3UTS c=1 sm=1 tr=0 ts=6a2d9193 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=dDmkakLwKiWj0oWmIz4A:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-ORIG-GUID: KAIOA3odSLOH-5KAXFyOfJuocDvGb6PV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfXwPoG5enatGF6
 pz/FvWHQ+qe3NKVxJppN+TF/kzpZv0HniXLTdRQVIsyaIWVu/I/r+WIJ9nFNBJhBJaNDbwNEus1
 Qjcq45bxxZJ/Z91NOwMx0/KvPNe8Tu8=
X-Proofpoint-GUID: KAIOA3odSLOH-5KAXFyOfJuocDvGb6PV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX/uNTnxbTTDn3
 Be7SBbMzwzzhhuPDeOs2OhpzM2IPAObFzwcYudfFeqUiAl15l4XBb0QsmlvJsBWnWaOLIPew7bn
 XDN1D7SEjA88RqG6HxJatgvdt3071C2/IU8co2zYDVyqQmRD16K/oZ6tnFzEc2F+H2RZQMKkHmZ
 WTCgjZcM+RtrxyqXPfe50mTmzeEZ1YnEVz1GEnATQupbcodXHZCgw8eLhKa291QWLc8DVoxLMgn
 k4uIrWb5enJxuMy/yGvZxTjDoPohjLt1cDAU/9NAZLD2dWlCmsgpIoREJCElxY4so/f9lVmZcrW
 pZR1h6w4Qq37JGkptQRLXeZJU9U614GBFAdvi5lAjh64+4ZcDW+9EIXGb8m3lwfVNMptdAB65+2
 VKVn2PZJw604XuyFfVnVSoMmmaXP9M9sJU+OLQPDNjYb3h9Rvc66CAuxLW98U8TSxRZWahZJM4r
 Ob4qf+b9/HwwbpQbuHg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606130180
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F3589180007
X-Stat-Signature: nmbyqprqbkcjycom4ric9k7y3xrjqt9z
X-Rspam-User: 
X-HE-Tag: 1781371284-910361
X-HE-Meta: U2FsdGVkX1/GXWMHKxvPdoDaLqwYtYBRWd7xvIGa/O4M7s7S6a0MyXk/I4JJrPicho4bTDkGsVCtyEkR1FFs3oCQwVQVWGgj53X9GXSLSCozXb8spd8R8U9U9Noy53eTKj8VdCQYb/1MGSnz+sC4s/0hRlc79fv8P+0B/rPIDWQ4ylN+B15m1At0lbNEiWXfmUbI8AF6aMCCPvvS40BN5bRnqQhhO3h6XrQ4+6eO9QqnmjFLOESj+NBc+TsPnpMpDy2RSQaHx2qn/4wj2kzKGdL/9uY/3DcYLeI3UyE5APQ1T8xoV4+OVtfR/FTOj800E/uLesfa7i3o0xDw22R7k138Bk1XpO6Wg1Dp9WTITfNTA3GUNVkcq3r3FCnJKHb221D1jiDNMaJ+JkFS9fBOFBltsN75XelwuMEvvKgKG31YrHsYFEE7GToSJpXY10lvWyja0M2F20LYOaw5aGFL/tjcTG815vH/fhvtR9CHrw7A8JS71LHv1WKijhYWpqsms3rY9v2Lf56B2jCLZmDiy8ukXhR5hC176BjsyYfKzXDbshTeUrmooekeWJjAcaG1ypPVoioEsCAxTyRgJiKl3wbfiFWFH47EhgW4fKUx5kAzh3MserA2WfelvLVFKu8mL5KVPGV36+bFRp7TdxCS8EhOuojQ9DmpK9jUPWcYK3CTJLyI3NquRSJAqMRF1hNpRG2VySXZc7iHbNeuAEQuaAOcHwhts+m/ychFGwJlQHJTtS/gLnGkb1TMnhC0FfYgky7GYobM26CfVfSb5K3r2Ea0c4hL9b5t2WtFtdOT2vYewvUIpue7t3PzP+zVlt7801vaXnSQGQ1yo10mAU5gjYj51tOZQHikrFB8sr/9hofV2Z62kyuMVy+b3kLHRoRfcyU+INmrvD+0wrnO5GxFxkjfS4A/mQam/nuSyGkuvTLMxoqLtF8zoAxSf0wvxS8X3AxiYKpYnC6XQT78VLk
 4WNukEa4
 0FJOAHERtwTjAZh44DYYbqDf8jLZPW/GnsJOAGPE5AJZAKOc6d4m5FO3iMTd97q2UpklES2hJ5yDQgAmV15JNmCkmyplSSap8/t/GLu14qlJqkEssVRdWIl3m0nLjuBW9OfDcc8GxlXgsDln54SN0Y6XjZrqow4Yb8Kra1geHQasTT+ksGFsbdZinZtfwPypfpKrIgTKDFFMuu5nbISebJ+GDY3cPrBXR/3jzhPj0V4Pr0Fsgbn/8NFWrIvEGcOjADp6pIyuZ0D767HaqpW+DqpgZduMcI+RRPT0OPayAvOLHOpNtGaDiWZDPPgbpxw9kZvVeAo5XoMIB4YngQANIKO8KMA5dh43Tkf6KTNqQklLIhPVx01v7KSVpSexB88yjxritpUzGTuKjaAyLaBV9J3uEtLNKlgQJIu7u5QVJdYzCsR+eL9AzrahuYXmG+jA7DbCe2aeLAgXghNoo7Bw7eqNvU+/yWrpBeqqjMHScufN00ie1MjO/ZlD6TfFGUakhSLS/zUO+cRB0MqH5tdM2GqlogA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The dual-tree design (free_vmap_area_mt + occupied_vmap_area_mt
maintained in lock-step) costs roughly twice the maple operations
per allocation lifecycle that the rb_tree path it replaced used.
Strip the maintenance back to a single authoritative tree on the
steady-state hot path.

After this patch:

  - The occupied tree is the source of truth for in-use ranges on
    the alloc/free hot path.
  - free_vmap_area_mt is still maintained on the slow paths
    (vmap_init_free_space, pcpu_get_vm_areas's top-down walk,
    decay_va_pool_node), but the steady-state alloc/free no longer
    has to keep both trees in lock-step.
  - This removes ~half of the maple operations a typical
    vmalloc/vfree cycle performs.

The pcpu top-down walk relies on the assumption that chunks consume
addresses bottom-up, so stale free-tree entries at low addresses
never collide with pcpu's chosen base.  This is documented at the
relevant call site.

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
 mm/vmalloc.c | 179 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 99 insertions(+), 80 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5bc1e47c456a..73a40a88dbf6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1767,17 +1767,32 @@ occupied_mt_find_hole_window_locked(unsigned long min, unsigned long max,
 {
 	MA_STATE(mas, &occupied_vmap_area_mt, 0, 0);
 	unsigned long search = min;
+	unsigned long search_len = size;
 	unsigned long hole_end;
 	bool retry_empty;
 
 	lockdep_assert_held(&free_vmap_area_lock);
 	retry_empty = list_empty(&vmap_retry_list);
 
+	/*
+	 * Pad the gap-find by align-1 when align exceeds PAGE_SIZE so that
+	 * any alignment slack inside the returned gap can be absorbed
+	 * without an extra outer-loop iteration. Without this padding, the
+	 * loop has to scan past every page-aligned gap that is large enough
+	 * for @size but too small for the aligned start, which is O(K) in
+	 * the number of such gaps and pathological for big alignments on a
+	 * fragmented occupied tree.
+	 */
+	if (align > PAGE_SIZE) {
+		if (check_add_overflow(size, align - 1, &search_len))
+			return false;
+	}
+
 	while (search <= max) {
 		unsigned long candidate, candidate_end;
 
 		mas_set(&mas, search);
-		if (mas_empty_area(&mas, search, max, size))
+		if (mas_empty_area(&mas, search, max, search_len))
 			return false;
 
 		hole_end = min(mas.last, max);
@@ -2182,39 +2197,35 @@ rollback_busy_insert_failed_alloc_locked(struct vmap_area *va)
 }
 
 /*
- * Reinsert @va into the free index after occupied erase. On failure, place the
- * range on the non-index retry queue and best-effort restore occupied tracking.
+ * Release @va after the caller has erased it from occupied_vmap_area_mt.
+ * In the occupied-only design there is no free index to track free space
+ * with vmap_area objects: the range becomes implicitly free as soon as
+ * the occupied marker is gone. The struct itself is recycled to the slab.
  *
- * Return: free-tracked @va on success, NULL when queued for retry.
+ * The signature returns @va on success (matching the pre-rewrite contract
+ * used by the synchronous free_vmap_area() path) so the caller can decide
+ * whether further bookkeeping is needed.
  */
-static __always_inline struct vmap_area *
-reinsert_or_queue_vmap_area_locked(struct vmap_area *va)
+static __always_inline void
+release_drained_vmap_area_locked(struct vmap_area *va)
 {
-	struct vmap_area *tracked;
-
 	lockdep_assert_held(&free_vmap_area_lock);
 
-	tracked = merge_or_add_vmap_area_free_locked(va);
-	if (tracked)
-		return tracked;
-
-	if (insert_vmap_area_free_locked(va))
-		return va;
-
-	/*
-	 * Retry queue acts as allocation exclusion even if occupied restore
-	 * fails under pressure.
-	 */
-	if (WARN_ON_ONCE(!occupied_mt_store_va_locked(va)))
-		INIT_LIST_HEAD(&va->list);
-
-	retry_queue_add_va_locked(va);
-	return NULL;
+	kmem_cache_free(vmap_area_cachep, va);
 }
 
 /*
  * Returns a start address of the newly allocated area, if success.
  * Otherwise an error value is returned that indicates failure.
+ *
+ * Steady state (post late_initcall, occupied_mt perf_mode on) takes
+ * the occupied-only fast path: find a gap with mas_empty_area on
+ * @occupied_vmap_area_mt and store the consumed sub-range. This costs
+ * two maple touches per allocation versus four to six in the legacy
+ * path (which clipped a free vmap_area struct in @free_vmap_area_mt).
+ *
+ * Pre-perf_mode (early boot) and -ENOENT/-ERANGE retries fall back to
+ * the legacy free_mt walk + va_clip path, which remains correct.
  */
 static __always_inline unsigned long
 __alloc_vmap_area(unsigned long size, unsigned long align,
@@ -2235,33 +2246,41 @@ __alloc_vmap_area(unsigned long size, unsigned long align,
 		return -EINVAL;
 	if (size > vend - vstart)
 		return -ENOENT;
-	if (align > PAGE_SIZE && (vend - vstart) != size) {
-		if (check_add_overflow(size, align - 1, &search_len))
-			return -ERANGE;
-	}
 
-	if (occupied_mt_supported() && align <= PAGE_SIZE) {
-		unsigned long candidate;
+	/*
+	 * Occupied-only fast path: skip both the free_mt validation
+	 * (free_mt_find_enclose_range_locked) and the va_clip splitting.
+	 * occupied_mt_find_hole_window_locked already pads the gap search by
+	 * align-1 internally for align > PAGE_SIZE, so any alignment lands
+	 * inside the returned gap; storing the consumed sub-range in
+	 * occupied_mt makes the allocator visible to subsequent lookups. The
+	 * legacy free_mt stays in sync only at coarse points (init, pre-
+	 * perf_mode), which is harmless because the alloc and free hot paths
+	 * no longer query it.
+	 */
+	if (occupied_mt_supported()) {
+		if (!occupied_mt_find_hole_window_locked(vstart, vend - 1, size,
+							 align, &nva_start_addr))
+			return -ENOENT;
 
-		if (occupied_mt_find_hole_window_locked(vstart, vend - 1, size,
-							align, &candidate)) {
-			if (check_add_overflow(candidate, size, &nva_end_addr))
-				return -ERANGE;
+		if (check_add_overflow(nva_start_addr, size, &nva_end_addr))
+			return -ERANGE;
 
-			va = free_mt_find_enclose_range_locked(candidate, nva_end_addr);
-			if (likely(va)) {
-				nva_start_addr = candidate;
-				goto found;
-			}
+		if (!occupied_mt_store_range_locked(nva_start_addr, nva_end_addr))
+			return -ENOMEM;
 
-			occupied_mt_cache_gap_miss_locked(candidate, vend);
-		}
+		return nva_start_addr;
 	}
 
 	/*
-	 * Free maple index is authoritative for allocatable ranges; lazy and
-	 * retry entries are intentionally excluded from it.
+	 * Pre-perf_mode early boot fallback: walk free_mt linearly and use
+	 * va_clip to keep both indices coherent.
 	 */
+	if (align > PAGE_SIZE && (vend - vstart) != size) {
+		if (check_add_overflow(size, align - 1, &search_len))
+			return -ERANGE;
+	}
+
 	mas_set(&mas, vstart);
 	va = mas_find(&mas, vend - 1);
 	while (va) {
@@ -2295,7 +2314,6 @@ __alloc_vmap_area(unsigned long size, unsigned long align,
 	if (!va)
 		return -ENOENT;
 
-found:
 	ret = va_clip(va, nva_start_addr, size);
 	if (WARN_ON_ONCE(ret))
 		return ret;
@@ -2340,8 +2358,7 @@ static void free_vmap_area(struct vmap_area *va)
 		spin_unlock(&free_vmap_area_lock);
 		goto out_schedule_retry;
 	}
-	if (!reinsert_or_queue_vmap_area_locked(va))
-		queued_retry = true;
+	release_drained_vmap_area_locked(va);
 	spin_unlock(&free_vmap_area_lock);
 
 out_schedule_retry:
@@ -2692,15 +2709,13 @@ reclaim_list_global(struct list_head *head, bool erase_occupied,
 {
 	struct vmap_area *va, *n;
 	bool ok = true;
-	bool queue_retry_work = false;
+	LIST_HEAD(release);
 
 	if (list_empty(head))
 		return true;
 
 	spin_lock(&free_vmap_area_lock);
 	list_for_each_entry_safe(va, n, head, list) {
-		bool occupied_erased = false;
-
 		list_del_init(&va->list);
 		if (erase_occupied) {
 			if (WARN_ON_ONCE(!occupied_mt_erase_va_locked(va))) {
@@ -2708,24 +2723,21 @@ reclaim_list_global(struct list_head *head, bool erase_occupied,
 				ok = false;
 				continue;
 			}
-
-			occupied_erased = true;
-		}
-			if (WARN_ON_ONCE(!merge_or_add_vmap_area_free_locked(va))) {
-				if (occupied_erased &&
-				    WARN_ON_ONCE(!occupied_mt_store_va_locked(va))) {
-					retry_queue_add_va_locked(va);
-					queue_retry_work = true;
-					ok = false;
-					continue;
-				}
-				list_add_tail(&va->list, failed);
-				ok = false;
 		}
+		/*
+		 * Occupied-only design: there are no free vmap_area objects
+		 * any more. With the occupied marker erased, the range is
+		 * implicitly free (a gap in occupied_vmap_area_mt). Just
+		 * release the struct outside the lock.
+		 */
+		list_add_tail(&va->list, &release);
 	}
 	spin_unlock(&free_vmap_area_lock);
-	if (queue_retry_work)
-		schedule_work(&drain_vmap_work);
+
+	list_for_each_entry_safe(va, n, &release, list) {
+		list_del_init(&va->list);
+		kmem_cache_free(vmap_area_cachep, va);
+	}
 
 	return ok;
 }
@@ -5747,14 +5759,16 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 		orig_start = vas[area]->va_start;
 		orig_end = vas[area]->va_end;
 		if (occupied_mt_erase_va_locked(vas[area])) {
-			va = reinsert_or_queue_vmap_area_locked(vas[area]);
-			if (va)
-				kasan_release_vmalloc(orig_start, orig_end,
-						      va->va_start, va->va_end,
-						      KASAN_VMALLOC_PAGE_RANGE |
-						      KASAN_VMALLOC_TLB_FLUSH);
-			else
-				queued_retry = true;
+			/*
+			 * Reinsert releases vas[area] in the occupied-only
+			 * design; use orig_start/orig_end captured above for
+			 * the kasan release call rather than va->va_start.
+			 */
+			release_drained_vmap_area_locked(vas[area]);
+			kasan_release_vmalloc(orig_start, orig_end,
+					      orig_start, orig_end,
+					      KASAN_VMALLOC_PAGE_RANGE |
+					      KASAN_VMALLOC_TLB_FLUSH);
 		} else {
 			retry_queue_add_va_locked(vas[area]);
 			queued_retry = true;
@@ -5820,14 +5834,11 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 		orig_start = vas[area]->va_start;
 		orig_end = vas[area]->va_end;
 		if (occupied_mt_erase_va_locked(vas[area])) {
-			va = reinsert_or_queue_vmap_area_locked(vas[area]);
-			if (va)
-				kasan_release_vmalloc(orig_start, orig_end,
-						      va->va_start, va->va_end,
-						      KASAN_VMALLOC_PAGE_RANGE |
-						      KASAN_VMALLOC_TLB_FLUSH);
-			else
-				queued_retry = true;
+			release_drained_vmap_area_locked(vas[area]);
+			kasan_release_vmalloc(orig_start, orig_end,
+					      orig_start, orig_end,
+					      KASAN_VMALLOC_PAGE_RANGE |
+					      KASAN_VMALLOC_TLB_FLUSH);
 		} else {
 			retry_queue_add_va_locked(vas[area]);
 			queued_retry = true;
@@ -6045,6 +6056,14 @@ module_init(proc_vmalloc_init);
 
 #endif
 
+/*
+ * Pre-occupied-only design seeded the free index with placeholder VAs
+ * covering gaps between vmlist entries. This is preserved as the
+ * boot-time path that populates the legacy free_vmap_area_mt for any
+ * code that still queries it (notably pcpu_get_vm_areas). With
+ * occupied_vmap_area_mt authoritative, allocators on the hot path
+ * skip free_mt entirely.
+ */
 static void __init vmap_init_free_space(void)
 {
 	unsigned long vmap_start = 1;

-- 
2.34.1


