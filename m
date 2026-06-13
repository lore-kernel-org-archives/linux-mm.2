Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4534CD98D8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155EF6B00A4; Sat, 13 Jun 2026 13:21:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D576B00A5; Sat, 13 Jun 2026 13:21:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CC76B00A6; Sat, 13 Jun 2026 13:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E23CC6B00A4
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:21:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADD261C3608
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:43 +0000 (UTC)
X-FDA: 84875556486.09.02D6689
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id 284D32000D
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=SvBF5DYb;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="idKE/vNx";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf31.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFBZitbymj18mEAzAGK9dmr1JcGda6wnYCfgwxi85K8=;
	b=Q9LjTU93sq6eDE4I1hGyqXhfCi41sAfHyjmw7b2z/abSKucOCCKKn5Eqdb76DayDuUhabz
	L0n7blH1rei8stvNctFFv1i0KrgYAbjkUGelQvGuFQrrD/QUo02PnDed7sFmdq4BVnEi/j
	+9UTu9w+oydEgXCtA5T212j70MFL/Ro=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=SvBF5DYb;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="idKE/vNx";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf31.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371301;
	b=WQvJsjOoe4SBvXuxyFSDrZPjgEcKNZL+8yD55UKX1cwNCxhtmhf4iI+ou4pc5rw8pLGKG+
	Unq/a8iz/e/db0+FnAW/e2BSnFQJBBit8tZppessxYaUI375WgYiszkdzu1+7kCADR/cAo
	tD23Y3TPzrx1cWRq2o7v2wD/eXVg5hw=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DF9nPV2785801
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WFBZitbymj18mEAzAGK9dmr1JcGda6wnYCfgwxi85K8=; b=SvBF5DYbflsHrzFH
	LzJ9fajfCViGVsueUX7G/m5reswGqPPsm42cLiDvPCNv9GePjUXBEenrHZ6QKLff
	G4DzPycl+CeTCjOy6d45UjFY7+lHNFTORrRErZ9Y/MC6SIrTp8ZZGx2sNPa/kFWz
	9kbcEpB/kmZmp3LHzy85tGeFTJEXwuCaqM87/pTIYM79ET8cju/1G1N+gEBmUK27
	ieUADs4vmWASn9626/4wPj8c7RxvPqx33gJ5ubnQHEQFdBfhrdG+NtUJC9tNlvaF
	iE/5a16R9KLtIAUZhqrxGTD25MO4ZJcWpk5nonzTWbVIS8+EjrxMMwRkDf6WCp8M
	YR6Rcg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4es0cghh2a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:39 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c8584e80bfcso951115a12.3
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371299; x=1781976099; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WFBZitbymj18mEAzAGK9dmr1JcGda6wnYCfgwxi85K8=;
        b=idKE/vNxvISyMmvIlmzPB6YUsYpjt6mFcpKcA6ROo8ONX1yuoshXrbL5UE8atquD+c
         EjA1SFTFO/xllFDotIMwfJuFG1gLYn5ehGXk7Z2SSSMcxj8ckaX8W2Sey3iO0EsYr62u
         QBzrpBMbByqTolhnPPvJMBYRcNoQfFs3m1Wuj2iIe75e3Mf2L0HuT3IkP5o/dW5Pna6u
         Mm/pznLMl9TeOPn3joqao4zXI08b2uDF/qUv7gJvdRonrjm4nn7v1lGNg3g021OYvS5v
         OXqA2e689yzCEBjbnzebGYx4unuU8Lue3iSYryVUqg2dFT/4yxNW497BKzSgd0+fIKRh
         LjYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371299; x=1781976099;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WFBZitbymj18mEAzAGK9dmr1JcGda6wnYCfgwxi85K8=;
        b=pPXQpLdXy41YnyttdbEJ5WjHhQWQ72vBGhRbSiL2oJnrNbIZLv2v2J37LT1NpyFM15
         1I13dmM6bchbyGkoiVEWLxqTFxKPmSoY8PHYbaim1tV18dl7SwXBhlx0r59menNy7HpA
         Ig4Ef9rfmxZg+FEx3iwI2Pi9vBGk0A3xWizhHSK4e5M3F3psZtQ34rcIxMbUmcxmNtcc
         pTMu7DA/PpaS3s69YP85vpgW6XCVcIyHx6a8jePXWDR/sIx+INoWnlrnFLKWF6zUeV5B
         ZBUHcGjCN2pAEMtZ86DGfA5uvMlFgOgPRfbQDtcIzETQZ9ixUYLxBSrOWI1K5zhiWKNS
         Wolg==
X-Forwarded-Encrypted: i=1; AFNElJ83Sn00z5iU6Faxy6tKP0UaKJtiDXssDiig5NDbg6Get1KC92QB7vSnOMQJUI6w8he2UKKeUDbz3g==@kvack.org
X-Gm-Message-State: AOJu0YxqeYrctSYPs5BnNZxpvwZpKhhpWdPM/bsPwH9dcfnW3O0rZG3J
	LNSdNMQeMOUD0iUpGu8gDnzMkPGOy8ZbYvhE8CTa++9pLAoGSsgnXxx5Q3rT/gD1KcDmfyueGiE
	uHtLRsW/YmW8sSIqsKo7pNDEZ1jPB/EeFI1nReln/+cDmNi92Ru9+uQ==
X-Gm-Gg: Acq92OEi//05SpHq7SQaK2cJcvvy14CNcCux47sbk6bk6b1f692pQajT9mkDOilqjAE
	8JfM7WhBYcTThM8xBlo2rfJJX4vsEuUu5zmiThIjzyITPN7Vrz/mQolxedofjbKd1c+s3bABJrk
	Qw4NzC7GgG/xpnN0vc2bGl3d5cEkW7ODhkKpVHEqFw8w25eBqyM77A1h3p5p6g4XuIoqvQuxfmn
	xEdQsSeMEHIoc7UW5+J/1iXP15mcA6AiL7fPkDv5Z/xZEhYjTR0hRmx/c10pTOmvyDbSh3lp/Rc
	f/PV5NLB3izxa6CXCRItGkXk+OHkwh98wY/gtqJJXKo+SiJheLqEdcdPSI8PlIR5JXf5B1bOPRo
	TwTIQ6vH8yFJprovjXT2RPhkBqV/wekBJg8cQTl7n4QtNC9JGXPZa0w==
X-Received: by 2002:a05:6300:218c:b0:3b4:8268:23e8 with SMTP id adf61e73a8af0-3b783f0a3f4mr9239537637.21.1781371299348;
        Sat, 13 Jun 2026 10:21:39 -0700 (PDT)
X-Received: by 2002:a05:6300:218c:b0:3b4:8268:23e8 with SMTP id adf61e73a8af0-3b783f0a3f4mr9239494637.21.1781371298918;
        Sat, 13 Jun 2026 10:21:38 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:21:38 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Date: Sat, 13 Jun 2026 22:49:51 +0530
Subject: [PATCH RFC 09/12] mm/vmalloc: collapse busy-tree find-then-unlink
 into a single mas_erase
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260613-vmalloc_maple-v1-9-0aa740bb944b@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=1577;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=1Wo2lxnikoSv9JichvG4ITxBxFpg2W31gcAukcfik7I=;
 b=spWOO4QH0SPH6dKaihPuUAG1gV/jkwgr4CrTNhi9QWp9XeyW4iqebvtmBC0BAL7LESeXg0rG0
 +AxtMJsVJytCUVtXjiAeMTCHd8dC34JkXXxIOXx0OtYDeVjqGqIvmGQ
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Proofpoint-ORIG-GUID: 6eHPdjoVc8zP6w7jTRLXZ4zDlkEKod5B
X-Authority-Analysis: v=2.4 cv=NPLlPU6g c=1 sm=1 tr=0 ts=6a2d91a3 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=qy1EqpzxIlcnHA3QzDgA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: 6eHPdjoVc8zP6w7jTRLXZ4zDlkEKod5B
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX1a5yY44RkxGS
 xucNjovYSVwVlfwZ9/L1K4V4Hu0qA0m0swAWFxdEPjdLqnw8BX5kHtTYJIUxmtUyI233TXaYdPW
 V925ZB/AFzjgN+EFpVpTvJtfnzh9UrQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX76ZSF2kiiCOT
 6RUkqjbomvVGbJcFs+wWPT3wNwVhFGoG+UAOkPOvTRqg7lYQtpYUrbsw5c2JrV2qEoc4pQ+usJf
 EQxynvT9S/Ynsc5Ot/9Kw/dfz8ilnXCPo5kz18Vcdgun6vedZ69XrWZuuJGPBFikF1kE5sOOwoF
 lwi4gBEw1ZlvYbRygDQHNsYUtsqQ24ixaFYtQxkZOAiCSnTvmeOq28Fpm3yMdddcyNoXnxtm4c+
 c5KkVQ/g76jlplQQ7WvsZKv7zoCBHAGBr8xM8Rm3EwhAfRcbl5zt+dtPunghNoSqC1DuV7W/qKj
 lh0sDo2WORc2C9yDGi1RX9I4D6XNcYGpmB3zGlvQsrL4jLiOVIPHEFh1OB1QGuAfODwfDR6MKUI
 FR/g8Mbfog9DVEuEvrhckV8RnIbGih8xe2YZGjYc+fvfKsofqNBo0m0f3lc0ExSbbVGet7rpjt5
 MXr0RXVIdyeJ5mPmsxQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606130180
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: kdzgs5ru9rokzd7seuh3njupinjyk75z
X-Rspamd-Queue-Id: 284D32000D
X-HE-Tag: 1781371300-178685
X-HE-Meta: U2FsdGVkX1+3zRY701+/QOCdTzDAqBphixgf5Diazjuj72iu5x9I2Imt8cpCNFhh4uL6SfZVilBDUL6W05aM6HDlwD9t0uDnYpzgMVOUsQvBpWbEe6nJgzThN86kY2e10s7bTP98a8PEe5Y+P0aIR74DHgJwLGKYoX4y3fRowRLjTVqcsyUFRTVjXOzNXbUlI5HztCX8UWvTCvHt1HDcD1+kbF5FZZhssTEwKX2KqTUjde1pEmhLqvCTqGHClWPrm85GPDel5rlFEiXJ2phN/1ayMkTUZnF8A2ovbtXYfeA0gJSRkd89yLr8D6DPTqYKPtUEsZWRiRxMH/UhCwFTh6Jj8mHj1b0ATil0M38+5zEZHNbey3TgmLJCHg410nDkjMCd1/6zdAhz7uDYBV4/ZyJyXqmV6zvrlkYktEgWH8DzQPDO4L6DENp0g5p9aU65+pvKPX3IN9EFIW9MLPJvuLmC5h4bOvf81V9Mu6weGq+OCt5d0ktlrLXO0HowMS8cpqjqXe50PhStqGMZw2UgpCytvTtIFZzA4hV8g3xWlHRoBdDjPiKy9+OI9X5ZmiU83CNM9p/gByJuePSvUgUW0P/BtxrD0mNmpmX1pINrKJ8en/w4Hicco5Z4TfZbl9IqDZBA+UEEPFMd+UdS23DOl5vyUPkfjA29T7eoKvexV26NRrl7PKgCAUahkqCYrW11V3KR1qS+dC7MSRgaAKMgbBpg6EvaRlQaMzw4D1GvJhu0N7cUmaenih5rkE2oXlUQsFFrYW5frqGra+8ZQY57YL6/dxeA/h3i0LU0hYeYWxiRYi6j2JenedpGedgeLCxXiYOVBaQjRY3k6drHuWX+2IiwUmGSJSPlrAsEXkqgqaBMrgW+VdjIpQkN9llCtQEMxwsLvbz8D3uUwwigvvz8Enlm266qJDRQFw1I0GFM1+iWz/RlhJc/LbOyDiAWgwaR8LdB1oUjNuWtLyptg2v
 J5NgiFoJ
 ebcsY2/qQKLFJJlsPSkJWv7O/+T+NarQNo6EqIoaF98Fa0GxGuvf4hHNgVe823xYAMPa83iUzyZ5fxntgVlRqmtuLD1maeskYofuV0J4oZq8yDLSf+nE4clNXWbcQjoM1a+giRo/yMgE3bfRBoWKvvjFMW58XlSRkdOsgudhqitl4u321lRxhW+93oirkd1y+p+4elWHpceBswwNIhbavM8jwSvzp+1mXrHmcLsPFN63OLwysHbX1RU4xJWkId/89YbZ/Gtq6DIB+mGcBqk6jv6tot5zyE61w1k7JHMImF5Iy91hY/Bb3rMc2ByvTkMFPheb93+3F1dBRQsaV6nJdu/JjjjgzYZzKQuoJX2rvGfKURKs/otH9KeolKvI7MdwrDpjMZQQdJju53J6NOedFAihf21gfn9xidwSsoaxAeO5i59DMGsJ5YGDjq1+g+Sf5W5Ahbe29E+R7X+F6vCSnhXV8ufXV20vj0U4fAdCvTwwuDARlWdq3sD8lvTxsnIsn9cLLHIH0+g0NhbxajBjxd3mGH0TDh3xeRRyvEunPlmyDq2J7r1cz6frQjC1xBmvUeqGKxO3ObmvAPJs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

find_unlink_vmap_area() previously walked the busy tree once (via
find_vmap_area_busy_locked() / __find_vmap_area_mt) and then erased
via a second walker (unlink_vmap_area_busy_locked).  Two independent
maple-tree descents, one per call.

maple_tree exposes mas_erase() which combines lookup and erase in
one descent.  Replace the find+unlink pair with a single mas_erase()
walker.

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
 mm/vmalloc.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1b73001e197e..463127d5ce58 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3122,10 +3122,24 @@ static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
 	do {
 		vn = &vmap_nodes[i];
 
+		/*
+		 * Combine the lookup and removal into a single maple-tree
+		 * descent. mas_erase() positions the state at @addr and clears
+		 * the slot in one pass, returning the previously stored VA.
+		 * This saves the second mas_store(NULL) the original
+		 * find_vmap_area_busy_locked + unlink_vmap_area_busy_locked
+		 * pair issued, halving the busy-tree maple work per vfree.
+		 */
 		spin_lock(&vn->busy.lock);
-		va = find_vmap_area_busy_locked(addr, vn);
+		if (likely(vn->busy.mt_enabled)) {
+			MA_STATE(mas, &vn->busy.mt, addr, addr);
+
+			va = mas_erase(&mas);
+		} else {
+			va = NULL;
+		}
 		if (va)
-			unlink_vmap_area_busy_locked(va, vn);
+			INIT_LIST_HEAD(&va->list);
 		spin_unlock(&vn->busy.lock);
 
 		if (va)

-- 
2.34.1


