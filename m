Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42EB0CD98D8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B836B0093; Sat, 13 Jun 2026 13:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943B66B0095; Sat, 13 Jun 2026 13:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832416B0096; Sat, 13 Jun 2026 13:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71EC66B0093
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:20:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FE81165679
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:54 +0000 (UTC)
X-FDA: 84875554428.12.65F29FF
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7443914000A
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=NuwBzWrd;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VthMpMFi;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf23.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCURNgSWRUFOFyKhAq/7V/tz5RhnVVGkvQX7hSUp9RM=;
	b=wSHHYvojvtQ0dBiWO8ymEqgnqhpCl2iSywLwvWvF/MV2WQN7maw4L+Zo+3CncP1jEd0BjT
	ldX0ldesy5syr+2FwfknB1HGpIdUJfkXwaOGHzMjRYMmmDY5IY4j1mE4dWyPs57gLFZmE0
	QYvuPv+CPJT/kvn9vRzhhAnPyI2qCnk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=NuwBzWrd;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VthMpMFi;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf23.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371251;
	b=ZcHk4owEppK2/UGUSVu4dfKVhBmsvhJxqON+WJkD1/IOIoALDMsnoxaQ6rrvkEPZ6VaMHf
	TVY6KFADQUrJKlus6vfV3sfB3URtT8Ih9ljbtAP2ngYLmEeK262yFhT9+8Et5TIidg7L4R
	nnzNTHvHSMLKSCWlbH2Fd/jFK3zrl/c=
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DF9M0u2759966
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uCURNgSWRUFOFyKhAq/7V/tz5RhnVVGkvQX7hSUp9RM=; b=NuwBzWrduzG3GLBq
	c8tAxU2Tazzqv1lB3qZ0HY3ukFxGsv/eZzNdJ18GIUa3G+vt07gawMkvTjrvhRqQ
	81HsEUN7s/czX+/NmBrXJA1qEmOFpZek4W+JEXbnJa/2pPaxm3AM0Wi8zD2Bl8bl
	CmOAiW2vKS4On9F8Gz8TrR7M0If9GJNpl9X4FuW0tNQoHDc6MBcdosyKh6YIXP4l
	QuDUSwsk6oI8um57xKx1uOnkkB5o4mz82/NlhR99bqPhrm8N/3DlA2P/DRDQqws/
	AvsXoC/t62X6vROQe32UD0MM8irOYiSdX2IZTLtF+KwRl84Wal9wr+sarGMZgtCk
	Vee3Jw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ery9f9p0b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:20:50 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84233efcaadso1358422b3a.1
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371250; x=1781976050; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uCURNgSWRUFOFyKhAq/7V/tz5RhnVVGkvQX7hSUp9RM=;
        b=VthMpMFi8LZkpZkLQb9UyhCh/3QCII7FvGUnHlTwPUjOcXH58tJEgjQ2seSk+tZhxX
         a25DJlb+TIhHUmI7vtVTiV1HqXvooG3pnIptdqkJHj0bVOMb/zwkYOAb5Hh84xkuSjo+
         34gAv3boHYjMSc6Frq1IneJ4etv7xD4ipWTLf95kg8xbh/cJW6EFIK9UGyZ/Fzpv+53b
         JEMluy0LAAI61IirCv6g2thMJUYkYgGiPrM2mf1PGZLlIsdG1DiRdC96088t4d8io/VU
         s0Yllo/LNYbYVRTy7iF0H0WxaYuZtT0PRcY1f8CPEB79Wfjh/WSnmEgWAJk3x4az7ILk
         pApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371250; x=1781976050;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uCURNgSWRUFOFyKhAq/7V/tz5RhnVVGkvQX7hSUp9RM=;
        b=JF9Z6f7GMpD2/7Qilpi89OtTOgpfEMi/eR/lJqqkjPEkovSr77dQT7KG+zB+eitvDh
         AFtZf0vyFt3TxO4pf8l9DAY1Fj8OCYAP9L6aVewmGnNxA2lvzaxjd9iPnlJ1jkW1jEUu
         BP1mwGy1rfdR63aI5RigZASKJB2fiLpjfpsbfUW8uaImmE4cvuDhNGHghjbO3jjcKxkQ
         MB8yXGpa9uJzpdsmiQKxbz6opggUeVQqwUV4rWRqRmOGOEMtnallC5qQBkADHUqagXqT
         5MYiUHqk0j1tMUdbAprNPQp3XdLFwvJ+FtJiNg/2SrBbs0Uo/54yyUI3JM5epD9i8ynU
         TsfA==
X-Forwarded-Encrypted: i=1; AFNElJ9rTszZXRUqSHQ7mgSKN7tlIL1ilwA1izwirIRUxIsK8f7Hth7liEbZvHquw+FsB6Znnd39Xh96+w==@kvack.org
X-Gm-Message-State: AOJu0YxQUHQbY7saE1R2E/vVpTVcNCukwwhZ4r1N5V7sikcb755Cpg7B
	Q02YqyCg1ZXX2cn1H63euXI7QelDgS+/v8vCySvIsfQgCJ7ZtQOfZIpRpB44r6kwxQH1t6xYRSZ
	xULuTtbqLnpFb0QGVwEhSbX6SV8jaB2rgfxt2QA2VC0++vYamYDzRQw==
X-Gm-Gg: Acq92OFG7lxLi/koZqiRdbWXPbb83RM/fdWrd/klLhpQjRIxYkmn+w5qLNeJcRCLT6J
	LI1BKNYNzlwcgNENYnuGcwwTkAim3r1UDndyHaSkE8W/L2MPTl+Sb7teZ9iK9t2EI2QKPWIVh+x
	okZoEAjqArZ4kWINqdJHFDivyiWJBgqwZMQo1t8AWZI/CjyE1Y4iPjGy+B55I3m+Cuo1bMMYXbD
	YcpY6D6WACJe8YcLVew3i/nMvJaPYx0SdB8DGjnowi3kASG7wJj/V8VWlq28Mn18AME6SJIYkdj
	3eJC36IpLIoUspOTyTONSYC8z52R9MCLSt80z+pYUuhM8uz+dTXxwXQWHGf820+fYeX+8Hl4mka
	/g8KYj0Ca/7XtU/ZU1Nz78DsEL4uzTnup01PXa3kgCPIIBiwhHjCgIA==
X-Received: by 2002:a05:6a00:ad04:b0:842:6594:de with SMTP id d2e1a72fcca58-8434cd4558cmr8150262b3a.15.1781371249350;
        Sat, 13 Jun 2026 10:20:49 -0700 (PDT)
X-Received: by 2002:a05:6a00:ad04:b0:842:6594:de with SMTP id d2e1a72fcca58-8434cd4558cmr8150235b3a.15.1781371248892;
        Sat, 13 Jun 2026 10:20:48 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:20:48 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Date: Sat, 13 Jun 2026 22:49:45 +0530
Subject: [PATCH RFC 03/12] mm/vmalloc: convert free, purge, and pcpu paths
 to maple_tree
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260613-vmalloc_maple-v1-3-0aa740bb944b@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=8254;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=d7Rh9moU4PlywobCCQlby0ESibig6WBPrZyoRaflKyI=;
 b=i4ZVjEUEpATUFw1AesbsDlvUbQAz4biJWSgx2WlatBpp99/Fh4zL92ovokQ6YvX3lYIEirA4W
 qeSCLC8FcQJCFfFoCZXnrUVBMNf37s3X1mpNxtFxc/JVLzamPLd3Rr/
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX/lFIjXteFhXM
 LF7ebbhe3wEgoZfOv5uykmgPJ7ROYIpPl1LvvjFl5in7JWChJQHk82ZMRQLpxJKG6saImDV2st9
 /OEPyZjUipA45RqWpJxBdwDcH4fnzpFX/XZOZQKG6Dma6xv1Dy76PLg4h1cItt4EN315O03eVMx
 Ry7lTM+RZm3hw+TQJYOQAIAj5x7C6GT40QcQ6/vozbioSpXUxnpqGG8nDIue2TPPiztyv2Z+T9e
 c/WPqZIKRNIi1uWGt+ILFoZ5ck9TXzIVDSKKtBoJtf0/5VC+wOnwd/EN8Kf0yToDBw+afPLZfIj
 gxzTmwxFBpRcMN7ib35A5E6GwLeLFeh6sr/5YZ7EjmexUDmjIIcuLkUhVZq3FLg4liD0JWIQl49
 zp5gy6vZns2LtrrDtvu04i2EV+fP6wXE/7aOxfDth9wa4vIAk+36tLJXjZUeixwj8/moz12F2zd
 wK8/LvxUVKW9KfNEkkA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfXyGO70NcHLblg
 sU6N09T2WYsbgkAZMjifYjwLxPuWkNQs6GrNR78l7i0id7YsKk7MlgHwCyz6vVkhuTV8ME86CsD
 olYbInOXg3uRvyx7KiiP1QbjqJ7/d7c=
X-Proofpoint-GUID: hxYHLsJgWAHRzaJOM8OV4XsU29qSk6mw
X-Proofpoint-ORIG-GUID: hxYHLsJgWAHRzaJOM8OV4XsU29qSk6mw
X-Authority-Analysis: v=2.4 cv=ULvt2ify c=1 sm=1 tr=0 ts=6a2d9172 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=r6JOZ6DJY9FYdPoncJEA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606130180
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: oueu78t7naada9nayxtfbrp4swtc1eqr
X-Rspamd-Queue-Id: 7443914000A
X-HE-Tag: 1781371251-288587
X-HE-Meta: U2FsdGVkX18RMGE4rCzA3BDkam7/gYkBCOEPiu73HzU3CnLui4HKPgNiNPxCHcCB6HS2JeH401CMQY8RwHQXrMjnWbBszxXCKnPkOUs1qJ5f352hzESX4wlKccxZOIEDhGSoBlPDlOABKV/zl4pY/2hiWzW8EmMT2OB8HxYBTuRfEICbM97FZZ5cBEnhe4KQWR1HnYkSTeJXH7yBQBbeSV6s5hTlQdnJml+CIXGlRJvNeXBBgYlcsxSxZ0h4THnkTqFJmIYU3LNusxm7ENOu4Vbu9SwTvsq5dGGuMNKQS0my5tPUbmQ4jP29oUBTGbGmEmXfoEqI/fonFmveRFdXydXrfYEHTMYsUFJ2f0V4i8q26L2EcsDJWYqgIuqXaZZWWJB7AWISoRIfltqNcwZbVEHy03YRb3pP9oifVXaf4YhlAMAWQQcwr9MVwp/hVDgLS+w+XsCwWQmNq/yBP9RAMHYo3dRex/wXc5M8bhsBzrds9XzWlBHNupbpfO3KkRpjnm8LzjVJT7qIPjaL/e2S+iu6L8iXU38u16kvHFh+Bt6yspvIjgtKiC3P/ujLIvoZclj0xYXPkvtmzIiGf9AkCi6vg2nAemYADxBS9VoS6lS8eLswMMWB8VtsXemL8N/MT9ph1fuzfPROrVVC3sFmHB0v5tP40HJd1+ni1UFsjkRXdhXE6gAw5TYPJKQtrJHuqcTffcaqCQU/Nm6nTZ6w/SYtDs/oVXMSumgvA8NeZrG9w0E70uJmxWZ6rD0GfU2dBtOL1GvzsgRoBmHooAZHevVdwMdnV6OkORO/P7i4HHbz91oMEvi6LBrfYOa+QmEQhq1+TOdQbt007w9z4L6Bvum7oT3/9VKT3rJ9M13FpFbhcgDtH8ZSGc388mqVZlGuTDvdssts28W1pHUwIOlonDKf0pTHkagpHxLWupQsA5O3IVH3I5qtEK2+QOYKDo2gTcVtOkqkU8yUOzDzthi
 gvGkNCUv
 MFEmEnfD3y/m0VLfMDO74lNpSKL1+qt1vbQDpstyWazvU08xa8qFbnQoyYwMrB8ksB6Nzr7voFPqbu+yz2ZpCnBQtXTvbYPQUsFkUBTh8YyXyDqVnsV2E5j/vAcT5zox5Dzk4/SiwoHAxTy72im5wfIRDo0Aq+WcD/dMRaDi94NZiWqqVrTR9oPiB0MW+yjcuTb9uFfpG5gr4wS8EVc4IFbljsZXG5kWf2QTlAR9i751g2e39pHrxKG7ZVSsLj0R2wvVu9wiBBGJ0quQvVsODJtvsCzIsJwc1MIbyYBywqCyAuCaY8WiBedx6bZHfaoJXCxFuYsz6+tn8hqEau3nJw8YzCdQ7WskRgPPaPyGvHSZ6apugyianuhnDTRwXlTnermFEpbugTuyHFodEM6Qoqo+7qhglwaM6suoy27HwrmA/s0/llmoQnjEhwPVIsc1/81VQTZ93TpoIdItaaXqHCNlx1YvNtHkFJ+EOYj6sPX76FdK39z5IxKq04wQOcYPGnsyD47cMejt4yEzn1/QAgF64HeLtBGsoC8HhzIaDFG4b/4ZLSgoP/FkuOIApF8W74YEzLJnh5iQ7kqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move free_vmap_area_noflush, the lazy-purge processing
(__purge_vmap_area_lazy, purge_vmap_node, decay_va_pool_node,
kasan_release_vmalloc_node), and pcpu_get_vm_areas onto the
maple_tree helpers.

Per-node busy lookup (find_vmap_area, find_unlink_vmap_area,
find_vmap_area_exceed_addr_lock) and the vmap_block free path
likewise shift to vn->busy.mt.

pcpu_get_vm_areas keeps its top-down free-area walk; the new
free_vmap_area_prev() helper returns the previous free-area neighbour
via the address-sorted list, while enclose-address queries
(pvm_find_va_enclose_addr) move onto the maple_tree where supported.

After this patch, the augmented rb_tree is no longer consulted on the
allocation or free path. The address-sorted free_vmap_area_list is
still walked on the alloc path's list-based next-fit scan and on
neighbour traversal in pcpu_get_vm_areas.

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
 mm/vmalloc.c | 78 +++++++++++++++++++++++++++++-------------------------------
 1 file changed, 38 insertions(+), 40 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c5f509f033e6..f2117eafa9cf 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2240,14 +2240,14 @@ static void free_vmap_area(struct vmap_area *va)
 	 * Remove from the busy tree/list.
 	 */
 	spin_lock(&vn->busy.lock);
-	unlink_va(va, &vn->busy.root);
+	unlink_vmap_area_busy_locked(va, vn);
 	spin_unlock(&vn->busy.lock);
 
 	/*
 	 * Insert/Merge it back to the free tree/list.
 	 */
 	spin_lock(&free_vmap_area_lock);
-	merge_or_add_vmap_area_augment(va, &free_vmap_area_root, &free_vmap_area_list);
+	merge_or_add_vmap_area_free_locked(va);
 	spin_unlock(&free_vmap_area_lock);
 }
 
@@ -2431,12 +2431,13 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 		 * Only scan the relevant parts containing pointers to other objects
 		 * to avoid false negatives.
 		 */
-		kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask);
+		kmemleak_scan_area(&va->vm, SIZE_MAX, gfp_mask);
 	}
 
 retry:
 	if (IS_ERR_VALUE(addr)) {
 		preload_this_cpu_lock(&free_vmap_area_lock, gfp_mask, node);
+		try_init_free_mt_locked();
 		addr = __alloc_vmap_area(size, align, vstart, vend);
 		spin_unlock(&free_vmap_area_lock);
 
@@ -2479,7 +2480,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	vn = addr_to_node(va->va_start);
 
 	spin_lock(&vn->busy.lock);
-	insert_vmap_area(va, &vn->busy.root, &vn->busy.head);
+	insert_vmap_area_busy_locked(va, vn);
 	spin_unlock(&vn->busy.lock);
 
 	BUG_ON(!IS_ALIGNED(va->va_start, align));
@@ -2575,8 +2576,7 @@ reclaim_list_global(struct list_head *head)
 
 	spin_lock(&free_vmap_area_lock);
 	list_for_each_entry_safe(va, n, head, list)
-		merge_or_add_vmap_area_augment(va,
-			&free_vmap_area_root, &free_vmap_area_list);
+		merge_or_add_vmap_area_free_locked(va);
 	spin_unlock(&free_vmap_area_lock);
 }
 
@@ -2719,12 +2719,13 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 		vn->skip_populate = full_pool_decay;
 		decay_va_pool_node(vn, full_pool_decay);
 
-		if (RB_EMPTY_ROOT(&vn->lazy.root))
+		spin_lock(&vn->lazy.lock);
+		if (lazy_vmap_areas_empty_locked(vn)) {
+			spin_unlock(&vn->lazy.lock);
 			continue;
+		}
 
-		spin_lock(&vn->lazy.lock);
-		WRITE_ONCE(vn->lazy.root.rb_node, NULL);
-		list_replace_init(&vn->lazy.head, &vn->purge_list);
+		move_lazy_vmap_areas_to_purge_locked(vn);
 		spin_unlock(&vn->lazy.lock);
 
 		start = min(start, list_first_entry(&vn->purge_list,
@@ -2823,7 +2824,7 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 		id_to_node(vn_id):addr_to_node(va->va_start);
 
 	spin_lock(&vn->lazy.lock);
-	insert_vmap_area(va, &vn->lazy.root, &vn->lazy.head);
+	insert_vmap_area_lazy_locked(va, vn);
 	spin_unlock(&vn->lazy.lock);
 
 	trace_free_vmap_area_noflush(va_start, nr_lazy, nr_lazy_max);
@@ -2873,7 +2874,7 @@ struct vmap_area *find_vmap_area(unsigned long addr)
 		vn = &vmap_nodes[i];
 
 		spin_lock(&vn->busy.lock);
-		va = __find_vmap_area(addr, &vn->busy.root);
+		va = find_vmap_area_busy_locked(addr, vn);
 		spin_unlock(&vn->busy.lock);
 
 		if (va)
@@ -2897,9 +2898,9 @@ static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
 		vn = &vmap_nodes[i];
 
 		spin_lock(&vn->busy.lock);
-		va = __find_vmap_area(addr, &vn->busy.root);
+		va = find_vmap_area_busy_locked(addr, vn);
 		if (va)
-			unlink_va(va, &vn->busy.root);
+			unlink_vmap_area_busy_locked(va, vn);
 		spin_unlock(&vn->busy.lock);
 
 		if (va)
@@ -2955,8 +2956,8 @@ struct vmap_block_queue {
 
 	/*
 	 * An xarray requires an extra memory dynamically to
-	 * be allocated. If it is an issue, we can use rb-tree
-	 * instead.
+	 * be allocated. If it is an issue, switch to another
+	 * indexing data structure.
 	 */
 	struct xarray vmap_blocks;
 };
@@ -3133,7 +3134,7 @@ static void free_vmap_block(struct vmap_block *vb)
 
 	vn = addr_to_node(vb->va->va_start);
 	spin_lock(&vn->busy.lock);
-	unlink_va(vb->va, &vn->busy.root);
+	unlink_vmap_area_busy_locked(vb->va, vn);
 	spin_unlock(&vn->busy.lock);
 
 	free_vmap_area_noflush(vb->va);
@@ -5238,9 +5239,15 @@ void free_vm_area(struct vm_struct *area)
 EXPORT_SYMBOL_GPL(free_vm_area);
 
 #ifdef CONFIG_SMP
-static struct vmap_area *node_to_va(struct rb_node *n)
+static __always_inline struct vmap_area *
+free_vmap_area_prev(struct vmap_area *va)
 {
-	return rb_entry_safe(n, struct vmap_area, rb_node);
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	if (va->list.prev == &free_vmap_area_list)
+		return NULL;
+
+	return list_entry(va->list.prev, struct vmap_area, list);
 }
 
 /**
@@ -5255,26 +5262,19 @@ static struct vmap_area *node_to_va(struct rb_node *n)
 static struct vmap_area *
 pvm_find_va_enclose_addr(unsigned long addr)
 {
-	struct vmap_area *va, *tmp;
-	struct rb_node *n;
+	struct vmap_area *va;
 
-	n = free_vmap_area_root.rb_node;
-	va = NULL;
+	lockdep_assert_held(&free_vmap_area_lock);
 
-	while (n) {
-		tmp = rb_entry(n, struct vmap_area, rb_node);
-		if (tmp->va_start <= addr) {
-			va = tmp;
-			if (tmp->va_end >= addr)
-				break;
+	if (free_mt_supported())
+		return __find_vmap_area_enclose_addr_mt(addr, &free_vmap_area_mt);
 
-			n = n->rb_right;
-		} else {
-			n = n->rb_left;
-		}
+	list_for_each_entry_reverse(va, &free_vmap_area_list, list) {
+		if (va->va_start <= addr)
+			return va;
 	}
 
-	return va;
+	return NULL;
 }
 
 /**
@@ -5419,7 +5419,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 		 * If this VA does not fit, move base downwards and recheck.
 		 */
 		if (base + start < va->va_start) {
-			va = node_to_va(rb_prev(&va->rb_node));
+			va = free_vmap_area_prev(va);
 			base = pvm_determine_end_from_reverse(&va, align) - end;
 			term_area = area;
 			continue;
@@ -5474,7 +5474,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 		struct vmap_node *vn = addr_to_node(vas[area]->va_start);
 
 		spin_lock(&vn->busy.lock);
-		insert_vmap_area(vas[area], &vn->busy.root, &vn->busy.head);
+		insert_vmap_area_busy_locked(vas[area], vn);
 		setup_vmalloc_vm(vms[area], vas[area], VM_ALLOC,
 				 pcpu_get_vm_areas);
 		spin_unlock(&vn->busy.lock);
@@ -5501,8 +5501,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	while (area--) {
 		orig_start = vas[area]->va_start;
 		orig_end = vas[area]->va_end;
-		va = merge_or_add_vmap_area_augment(vas[area], &free_vmap_area_root,
-				&free_vmap_area_list);
+		va = merge_or_add_vmap_area_free_locked(vas[area]);
 		if (va)
 			kasan_release_vmalloc(orig_start, orig_end,
 				va->va_start, va->va_end,
@@ -5552,8 +5551,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	for (area = 0; area < nr_vms; area++) {
 		orig_start = vas[area]->va_start;
 		orig_end = vas[area]->va_end;
-		va = merge_or_add_vmap_area_augment(vas[area], &free_vmap_area_root,
-				&free_vmap_area_list);
+		va = merge_or_add_vmap_area_free_locked(vas[area]);
 		if (va)
 			kasan_release_vmalloc(orig_start, orig_end,
 				va->va_start, va->va_end,

-- 
2.34.1


