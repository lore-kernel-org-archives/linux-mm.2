Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 614ECCD98D8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FFA6B009E; Sat, 13 Jun 2026 13:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C779E6B009F; Sat, 13 Jun 2026 13:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FA46B00A0; Sat, 13 Jun 2026 13:21:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A15886B009E
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:21:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 762D11C1E59
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:19 +0000 (UTC)
X-FDA: 84875555478.25.34B640C
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id E7C93180005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=kfAi0W0E;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Ayf6Qtoh;
	spf=pass (imf06.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/I6iFme5fkx2C9j5fdSlySDSrUwV6eedj4hKkQAifjg=;
	b=z1bfh01p7ZWPpphkuE99LnpkTs97R/dK+q8IpBlta8FkIUQ1yBizck6YsXKNM1lM+ZUx18
	c6WgS7Z6Va3dL6kPqOdqew72RJKDrArWI12W0e32wsmQ0HkAe/loFvdRkXGLQPbPU7hiH/
	qHKstqia0DaetgEQKcafsyDnoBmSoiY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371277;
	b=u8NWlb86987W/Xa6P71gQSRMqjBvmz3yCiq9lejMHaLFm1nqEJktStXfEM7aAbQMaPS8LN
	5OFDShLPtwv1aTXEPKjDh1scnD8YwxHrq6q29sMk25GgdPlb3g4q7SKR8mEowlJnqAnRZI
	Ytauh3IoEYN5Sfio9XtmA2RWGNULEsg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=kfAi0W0E;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Ayf6Qtoh;
	spf=pass (imf06.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DFAnAn3142963
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/I6iFme5fkx2C9j5fdSlySDSrUwV6eedj4hKkQAifjg=; b=kfAi0W0Ea2oNzZlF
	pbJ3BANSwcs3xnk4Dt298ANsFrPlm4UA5OGzoapOvGsOIIn3Dfnvg2qjppwHgHvB
	WA7QgSTVohXpxXUHKlbcs1W/tfKRAdLnGhXsl66VQbcGYMGkzExJ4PN7ZE8wsfMl
	rMG0T7XSSM+WVOsoqrz7t1fcwoDvVe69vul8cYFErN1xz3Y+65NPicnHT7GTrthh
	MlOrB8Kj0IuhXen3mDUIPSlsOhwO5Wxh1inH37pgpPp5wkPW0qS6sFQFJSCZZqQm
	YqkSgOvuLDrYfiXAUXtpU9GG/r/o6imNQ+i67vJafYbHeV/6VnmyQzGbxs/NdNlm
	kgP4yg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eryk69mn2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:15 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84238e83851so1316567b3a.1
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371275; x=1781976075; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/I6iFme5fkx2C9j5fdSlySDSrUwV6eedj4hKkQAifjg=;
        b=Ayf6Qtoh3xRN05Nh7vIzbdmsOLUE2rQmibprjWWP0FE8gcQRxQ/ph/l4oPfeTAxth/
         LgB1Kg18UWhi+s9+O+exYxuKmuZpfAt02jieqikz2BkaPrXy0nsrpRAtgtjU/LBI2bXF
         2cvLnnQZyyOlfR6ixNHO1cXJlhPJXsOo99shgzO37dgItpX4e7Sh9S8S4484Kn+2XWQ2
         ApktjSj5wKVD/NlNC0l3N3ABO6DdmpE5tzGV3cnDmLRUPeZdeftbjR9w80u0KqSpmtw+
         lOzC6+PuZBASKd5ZnTuW708zNmuYzIUBguzJwJFxhHf0BonJjekQg3shq5JDqZis6b3Z
         xbXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371275; x=1781976075;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/I6iFme5fkx2C9j5fdSlySDSrUwV6eedj4hKkQAifjg=;
        b=erYIMcozl6ZokHfbt3iV0NDnf+s4HPOe7B2hNxVb38VxrNJQXBAlJVybkLTDEdxJTm
         cO3WDpymDRyLllD164S1bNZp4Z9gpr53VoTX4f4Fap692/OA46jGFwgDQAtzCxsoSjE7
         qs2VNpmgzzalVKWEYrCRDZi+VjDN2Q/v7jFwYFPlGdepTv+18kXMqleXz//QtQ/uMGdB
         kVubsind0XbGMn52oyHrGPn5ZGhQj9xki+dimJNDSOF5+zl3IjdmdxDyXc/NjzYzO+7t
         BzqyHI6c/QULdetic/1IjEBMbPBzUAEFRWxmZSL4InH8QqAcGMBSXP8fugm+tFTRKnpw
         bjrA==
X-Forwarded-Encrypted: i=1; AFNElJ//ieUyJaAKLfYmWw75DscS2jLCQElsWcWEVUxtp6XHrteeEgeLxiCHYHikCozmOi9drFpqIZLsIA==@kvack.org
X-Gm-Message-State: AOJu0YzjLUoKOJlsdjiUd6jmPokXr6kwo3YTPdXrPTwdPeBvc6DzwVmP
	DoQWKUYQNY07WxAPOhoS0qG7UayiJOrePBNqRJwyXKx+H+yonUZxXMM2lyY9YTTzTZ3Fg8uicQ1
	Va5+q+xe/ZMNagCAHBS6+Sq0oRLxo0hwZjCOyhf3PVNFEkv7HUUfi6g==
X-Gm-Gg: Acq92OFQcEfQhKZZgf79UtGvJwFgClxvGFZf61nthOHb4jV14sx9d5MHnsDsjo3D4bU
	dKqoutIk7Yyd2UGmXXfUZVW8VtuTWtt7LynEUobOy8Mopnzo729LF/n7pTinCKesWtRDN8yMXGe
	2LkFO2T185dF/e8J50X1xh8eAJfbjj2zSGPY0yXDv89suUT8Tf8E7E0edfT5MrfV0wr9T/dE2qf
	ViKNe2mQy7Espn6wW4y7TC61X2yRmUC1aXSapb9noq50zSLAymwo3uUmlfyXvBvsk5Zljf2pJgl
	SR9DoCXjQZhfnsltaTFcEMELYKodT1MhNFl4W/OYZWgkZaaVPrb2eNrrdzzVSMxbQMOaLARgxvR
	SBk2+bAp1by194d7ipDelMhiZUXVtKDnoq+K2cfWxk/LH5y3JY1taLw==
X-Received: by 2002:a05:6a00:238c:b0:837:e9cc:d46e with SMTP id d2e1a72fcca58-844e1a2af43mr4931710b3a.21.1781371274583;
        Sat, 13 Jun 2026 10:21:14 -0700 (PDT)
X-Received: by 2002:a05:6a00:238c:b0:837:e9cc:d46e with SMTP id d2e1a72fcca58-844e1a2af43mr4931674b3a.21.1781371274064;
        Sat, 13 Jun 2026 10:21:14 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:21:13 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Date: Sat, 13 Jun 2026 22:49:48 +0530
Subject: [PATCH RFC 06/12] mm/vmalloc: tighten alloc/free hot paths
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260613-vmalloc_maple-v1-6-0aa740bb944b@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=18494;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=zbxu+zhrrq8kNARCxboH4iwVnk+IT7v84v8g4HuQcSE=;
 b=6nysurH5i68Eunbid0E9yIxoEU1j7CC37Xen+8vyn32srCewr3yrDNXjXSb1C4oOv2BtOpyVX
 5l2hc7ejOSGAHu43D1gJQjtwsVNhnNBooF4I6rHvvcFNLBNmY7ZdabV
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfXza1rJKpacMuT
 wUhXExrPEIKF9cKKxke9UxctU1vvNvJOdRnJQDHKBPFV806MjZAH2D0lLGTST/UGch95jYNbMzQ
 YigRd4+uMZ2jS2fYkD4A3aWBaQ1y/aU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfXylb6/Eqfbf9C
 JoZyIDk9VzAO2yJYJff/P0dlEDY9smDj0k7DyA0ifmnK0wzLF6Dz+WpbMXjzq/eDJavWDu4/7b3
 S4un+Hwwaau0FRC+WTJlGbmIq5ylM9FbG5IXabTyyLKmF5Rn2jxjoVRt7eS6z+hAqttwhlFZBNn
 Czu4yCxeRnepPcB5vhMxcxG7U8Sm4CBPmR7bRCZaisubJbNsKCvLDbjbgbqjimrzA+pf3azwG/D
 SIh3bgAUYTc1+evliFPTRXZFZXWf9JguTTJM5dKsUg8n7GLGkTd+/NJyd81Im15EatyTfZgOFLz
 7s9rdHxqqux5n47DfI5gAB4D0RwGaPbgS+qkb9HPPPxKsUH7A32EOHWPLaLFS44Bt+MQTdSKraD
 5670J3yetoP5N9sGneaSluinmfoKGu+VLlc5L5hyAEh1gxgXzrlf06+Tu9Kqh+GkKBP3BXewLCh
 LywO3Ma+5l7UH2w2A9g==
X-Authority-Analysis: v=2.4 cv=NrThtcdJ c=1 sm=1 tr=0 ts=6a2d918b cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=bFY0SaVsXT4y8Vv8kk0A:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: 6ckuLERm1qMc6Zld96BYKP7aOEmur0Pq
X-Proofpoint-ORIG-GUID: 6ckuLERm1qMc6Zld96BYKP7aOEmur0Pq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606130180
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E7C93180005
X-Stat-Signature: 5wawchymhkzzoenmefhnca9cht7aod78
X-HE-Tag: 1781371276-146003
X-HE-Meta: U2FsdGVkX1/y3lAxZK5i5mzdcCGbjBLOXUzEjmqVODdkyP9qUexlGwqhUi/0G6HjKq+X4AxExtQkkWEmF5+U2irwVPS9yHZ7Wdcdu8BNE+aAqx19e31E8FjRsXZh7XH2y/ZpRYsdpyIQhVSxyhAEbqJI2T2KveBBhL8hypgLfQbYEvSSRKFwy+garqDhPSsiuWagnRtLryaPepuFGyuNlTwD+HYXZEkuPg6Ai/MF6x6x9GtW6ZZaX8odDhF7Vp6t6cTYBnHuBPcwe7xMCOZu0Hd0d3YfLd9kZoGXYgNNt3/LAPUW/oZz3/ALOLn6CSMW16AfqvV0qwI5Mc05gQU4YiPu/FJG+2t3aKslP1RGPPtl4VI4H7FRnQtgHlrO2jyv9oQYl5wzBb4QuO/1R268UoPamDFUNP9GTBlCO8Fo5uqWgb/Z10sa9ul5WCuaqEgowj9IMsFFSW7iPmmxOT9zlrFb1b7yybPsdWEmviFopRidInN2M8XHNFJgIgW5Jg809yRbGK6TYnSxec/VYlGMnn56AONMvZmlIvWwzDU6qDKGuJzaYC9735RP9TD3PPzdnuN5tX24Ny+/gcsMfOKXO+AqN26NfH7WXy73HdeM/Pj90fq/k8OvsC/lcuO0r8ZL4uGjTetfV92WZEK/BOJK5tgFdFb5Er5cefaI9Txj9O5TojLNJKKQ27xNmrw36/EMOgyZKwL0O44+oDYGMbTimvZjR0abYSvdWCBeU0juvoYItLoCngRMkBv7EIGOh+tcejTK4ecIpQq6oih0XSgFd88auJHH7rbfYv0AHSeTuE4wb7lQMw8F+0H4U/jEdUrdZS1I0LIPW2nt0ALUMqZt9Bt5saj4ljqlRp6jWZ4itCfyLE0Sq+RvrCc1UpnmeYbmdMacGASJORdYstUmTGRZurGAFAhO+azRhy1eb5Mhjy3y+o7VVvSwcefASNRYdxZSkHe4XDqyHg3BSj80JWn
 8YkMFjGL
 TUTQaSxXrnDG6eEoARh0eEre5VCPrbdq3mFZztv+an8I4S+x/GfWFp+OzgZrkByTAutFQCDHVVCEacJ/IZN/sbnwnGj6OuiggTCudKfRpWAMFB820kZNGRK1y8iTgJappcCPu6uWlUoHt4sQuprd8WYphAjA340jZWjOKb1ueY07QnDTleCh0EBhVt4JbyXHPag7r9Sq4PZ/UnOM8Mqu68q6h+uNsLLKoJYCcvxg9q5F/IqYcGPXLxtxdEi3WRRNAk0ec9NgLvbJsgz5OAwEQ+rBlT/y8LX3SuOmZDEJ9aXX7zVtdZ8kl038xwXlOdGGwazVZZOZVRVBoUHdKxlmWMoXlQfYUErFWREHnysiRt3vSeRXmf6EQWmDJZ9MDzUlJ7ZEvlfR/bk903hmthdt49NK0YVjY5w/HxKw9IarYs2cmwgKrgaA0V76s1XBVDN+nb19Rwt3mhUHB6i3Q3KNou642+ouuUQt/B2I5m3WT+SQ3L0F8FiM06j0OHshZ9PuO18g5Por4h1xNwiIaw9hC8cFNZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three small refinements that follow from using maple_tree more
idiomatically on the alloc and free walkers:

  - Carry the MA_STATE through the alloc walker instead of dropping
    and re-positioning it between the gap query, the candidate
    classify step, and the post-clip publish.  The walker is already
    pointing at the chosen range; reuse it.

  - When the gap query is satisfied by an entry whose start is not
    yet aligned, ask for a gap of (size + align - 1) so the first
    match is guaranteed alignable.  This matches the effective
    behaviour of the augmented rb_tree's gap traversal.

  - When va_clip narrows an existing free entry, store NULL on just
    the consumed sub-range instead of erasing the whole entry and
    re-storing the surviving prefix/suffix.  mas_store(NULL,
    [start, end]) leaves the un-trimmed sub-range of the original
    entry intact, so the re-store is unnecessary.

  - Walk the address-keyed occupied tree with mas_find on the rare
    decay path so the per-node free-area scan can prune ranges that
    are already aligned out.

No semantic change to the allocator policy, the free-area shape, or
the addresses returned.

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
 mm/vmalloc.c | 338 +++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 283 insertions(+), 55 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7feb1b182cfa..5bc1e47c456a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -899,6 +899,7 @@ static struct maple_tree occupied_vmap_area_mt =
 		       free_vmap_area_lock);
 static bool occupied_vmap_area_mt_enabled;
 static bool occupied_vmap_area_mt_init_tried;
+static bool occupied_vmap_area_perf_mode;
 
 /*
  * Preload a CPU with one object for "no edge" split case. The
@@ -1073,12 +1074,13 @@ static __always_inline bool free_mt_store_va_locked(struct vmap_area *va)
 	if (!err) {
 		mas_store_prealloc(&mas, va);
 		mas_destroy(&mas);
-	} else {
-		err = mas_store_gfp(&mas, va, GFP_ATOMIC | __GFP_NOWARN);
-		if (WARN_ON_ONCE(err))
-			return false;
+		return true;
 	}
 
+	err = mas_store_gfp(&mas, va, GFP_ATOMIC | __GFP_NOWARN);
+	if (WARN_ON_ONCE(err))
+		return false;
+
 	return true;
 }
 
@@ -1119,6 +1121,31 @@ free_mt_update_va_locked(struct vmap_area *va, unsigned long old_start,
 	return true;
 }
 
+/*
+ * Trim a stored range entry by clearing a sub-range from one end.
+ * Used by LE_FIT and RE_FIT in va_clip(): the original [old_start,
+ * old_end-1]->@va entry survives intact at the un-trimmed sub-range,
+ * so a single mas_store NULL replaces the explicit erase + restore-at-
+ * shrunk-range pair, halving maple-tree work for edge clips. NE_FIT
+ * uses the same primitive after first inserting @lva, which trades 3
+ * stores (erase + store + lva) for 2 (lva + middle trim).
+ */
+static __always_inline bool
+free_mt_trim_range_locked(unsigned long trim_start, unsigned long trim_end)
+{
+	int err;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	if (trim_start >= trim_end)
+		return true;
+
+	MA_STATE(mas, &free_vmap_area_mt, trim_start, trim_end - 1);
+
+	err = mas_store_gfp(&mas, NULL, GFP_ATOMIC | __GFP_NOWARN);
+	return !WARN_ON_ONCE(err);
+}
+
 static __always_inline void
 retry_queue_add_va_locked(struct vmap_area *va)
 {
@@ -1175,6 +1202,11 @@ static __always_inline void try_init_free_mt_locked(void)
 }
 
 static __always_inline bool occupied_mt_supported(void)
+{
+	return occupied_vmap_area_perf_mode && occupied_vmap_area_mt_enabled;
+}
+
+static __always_inline bool occupied_mt_enabled(void)
 {
 	return occupied_vmap_area_mt_enabled;
 }
@@ -1194,28 +1226,48 @@ static __always_inline void try_init_occupied_mt_locked(void)
 }
 
 static __always_inline bool
-occupied_mt_store_range_locked(unsigned long start, unsigned long end)
+occupied_mt_store_range_raw_locked(unsigned long start, unsigned long end)
 {
 	int err;
 
 	lockdep_assert_held(&free_vmap_area_lock);
 
-	if (WARN_ON_ONCE(!occupied_mt_supported()))
-		return false;
+	if (!occupied_mt_enabled())
+		return true;
 
 	MA_STATE(mas, &occupied_vmap_area_mt, start, end - 1);
 
-	err = mas_preallocate(&mas, XA_ZERO_ENTRY, GFP_NOWAIT | __GFP_NOWARN);
-	if (!err) {
-		mas_store_prealloc(&mas, XA_ZERO_ENTRY);
-		mas_destroy(&mas);
+	err = mas_store_gfp(&mas, XA_ZERO_ENTRY, GFP_ATOMIC | __GFP_NOWARN);
+	return !WARN_ON_ONCE(err);
+}
+
+static __always_inline bool
+occupied_mt_erase_range_raw_locked(unsigned long start, unsigned long end)
+{
+	int err;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	if (!occupied_mt_enabled())
 		return true;
-	}
 
-	err = mas_store_gfp(&mas, XA_ZERO_ENTRY, GFP_ATOMIC | __GFP_NOWARN);
+	MA_STATE(mas, &occupied_vmap_area_mt, start, end - 1);
+
+	err = mas_store_gfp(&mas, NULL, GFP_ATOMIC | __GFP_NOWARN);
 	return !WARN_ON_ONCE(err);
 }
 
+static __always_inline bool
+occupied_mt_store_range_locked(unsigned long start, unsigned long end)
+{
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	if (!occupied_mt_supported())
+		return true;
+
+	return occupied_mt_store_range_raw_locked(start, end);
+}
+
 static __always_inline bool
 occupied_mt_store_va_locked(struct vmap_area *va)
 {
@@ -1227,17 +1279,12 @@ occupied_mt_store_va_locked(struct vmap_area *va)
 static __always_inline bool
 occupied_mt_erase_range_locked(unsigned long start, unsigned long end)
 {
-	int err;
-
 	lockdep_assert_held(&free_vmap_area_lock);
 
 	if (WARN_ON_ONCE(!occupied_mt_supported()))
 		return false;
 
-	MA_STATE(mas, &occupied_vmap_area_mt, start, end - 1);
-
-	err = mas_store_gfp(&mas, NULL, GFP_ATOMIC | __GFP_NOWARN);
-	return !WARN_ON_ONCE(err);
+	return occupied_mt_erase_range_raw_locked(start, end);
 }
 
 static __always_inline bool
@@ -1303,6 +1350,24 @@ __find_vmap_area_enclose_addr_mt(unsigned long addr, struct maple_tree *tree)
 	return mas_find_rev(&mas, 0);
 }
 
+static __always_inline bool
+find_vmap_area_insert_neighbors_mt_locked(struct maple_tree *tree,
+					  unsigned long start,
+					  unsigned long end,
+					  struct vmap_area **left,
+					  struct vmap_area **right)
+{
+	*left = __find_vmap_area_enclose_addr_mt(start, tree);
+	if (*left && WARN_ON_ONCE((*left)->va_end > start))
+		return false;
+
+	*right = __find_vmap_area_exceed_addr_mt(start, tree);
+	if (*right && WARN_ON_ONCE((*right)->va_start < end))
+		return false;
+
+	return true;
+}
+
 static __always_inline bool
 validate_vmap_area_range_insert_mt_locked(struct maple_tree *tree,
 					  unsigned long start,
@@ -1310,12 +1375,8 @@ validate_vmap_area_range_insert_mt_locked(struct maple_tree *tree,
 {
 	struct vmap_area *left, *right;
 
-	left = __find_vmap_area_enclose_addr_mt(start, tree);
-	if (left && WARN_ON_ONCE(left->va_end > start))
-		return false;
-
-	right = __find_vmap_area_exceed_addr_mt(start, tree);
-	if (right && WARN_ON_ONCE(right->va_start < end))
+	if (!find_vmap_area_insert_neighbors_mt_locked(tree, start, end,
+						       &left, &right))
 		return false;
 
 	return true;
@@ -1499,10 +1560,11 @@ unlink_vmap_area_lazy_locked(struct vmap_area *va, struct vmap_node *vn)
 }
 
 /*
- * Transition a VA into the lazy index and drop occupied tracking. On occupied
- * erase failure, attempt to roll back the lazy insertion; if rollback fails we
- * keep the lazy entry and let purge-side erase_occupied handling repair stale
- * occupied state.
+ * Transition a VA into the lazy index.
+ *
+ * In the default mode, occupied tracking is dropped while the VA is lazy.
+ * In occupied perf mode, lazy ranges stay occupied-indexed so hole search can
+ * avoid repeatedly probing unavailable gaps.
  *
  * Returns true when the VA remains lazy-indexed; false when it should be
  * retried via non-index queue.
@@ -1518,6 +1580,11 @@ publish_vmap_area_lazy(struct vmap_area *va, struct vmap_node *vn)
 		return false;
 	}
 
+	if (occupied_mt_supported()) {
+		spin_unlock(&vn->lazy.lock);
+		return true;
+	}
+
 	/*
 	 * Keep lazy.lock held while dropping occupied tracking so purge-side
 	 * lazy extraction cannot move @va to purge_list during rollback.
@@ -1588,24 +1655,34 @@ move_lazy_vmap_areas_to_purge_locked(struct vmap_node *vn)
 }
 
 static __always_inline bool
-insert_vmap_area_free_locked(struct vmap_area *va)
+insert_vmap_area_free_nocheck_locked(struct vmap_area *va)
 {
-	struct vmap_area *prev, *next;
-
 	lockdep_assert_held(&free_vmap_area_lock);
 
-	prev = __find_vmap_area_enclose_addr_mt(va->va_start, &free_vmap_area_mt);
-	if (prev && WARN_ON_ONCE(prev->va_end > va->va_start))
-		return false;
+	try_init_free_mt_locked();
 
-	next = __find_vmap_area_exceed_addr_mt(va->va_start, &free_vmap_area_mt);
-	if (next && WARN_ON_ONCE(next->va_start < va->va_end))
+	if (unlikely(!free_mt_supported()))
 		return false;
 
 	INIT_LIST_HEAD(&va->list);
 	return free_mt_store_va_locked(va);
 }
 
+static __always_inline bool
+insert_vmap_area_free_locked(struct vmap_area *va)
+{
+	struct vmap_area *prev, *next;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	if (!find_vmap_area_insert_neighbors_mt_locked(&free_vmap_area_mt,
+						       va->va_start, va->va_end,
+						       &prev, &next))
+		return false;
+
+	return insert_vmap_area_free_nocheck_locked(va);
+}
+
 static __always_inline void
 unlink_vmap_area_free_locked(struct vmap_area *va)
 {
@@ -1634,8 +1711,9 @@ merge_or_add_vmap_area_free_locked(struct vmap_area *va)
 	new_start = va->va_start;
 	new_end = va->va_end;
 
-	left = __find_vmap_area_enclose_addr_mt(new_start, &free_vmap_area_mt);
-	if (left && WARN_ON_ONCE(left->va_end > new_start))
+	if (!find_vmap_area_insert_neighbors_mt_locked(&free_vmap_area_mt,
+						       new_start, new_end,
+						       &left, &right))
 		return NULL;
 
 	right = __find_vmap_area_exceed_addr_mt(new_start, &free_vmap_area_mt);
@@ -1657,7 +1735,7 @@ merge_or_add_vmap_area_free_locked(struct vmap_area *va)
 	va->va_start = new_start;
 	va->va_end = new_end;
 
-	if (!insert_vmap_area_free_locked(va))
+	if (!insert_vmap_area_free_nocheck_locked(va))
 		return NULL;
 
 	return va;
@@ -1690,6 +1768,10 @@ occupied_mt_find_hole_window_locked(unsigned long min, unsigned long max,
 	MA_STATE(mas, &occupied_vmap_area_mt, 0, 0);
 	unsigned long search = min;
 	unsigned long hole_end;
+	bool retry_empty;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+	retry_empty = list_empty(&vmap_retry_list);
 
 	while (search <= max) {
 		unsigned long candidate, candidate_end;
@@ -1709,7 +1791,8 @@ occupied_mt_find_hole_window_locked(unsigned long min, unsigned long max,
 		while (candidate >= search && candidate_end <= hole_end) {
 			unsigned long blocked_end = 0;
 
-			if (!retry_queue_overlap_locked(candidate, candidate_end,
+			if (retry_empty ||
+			    !retry_queue_overlap_locked(candidate, candidate_end,
 							&blocked_end)) {
 				*addr = candidate;
 				return true;
@@ -1751,6 +1834,70 @@ occupied_mt_find_hole_lowest_locked(unsigned long size, unsigned long align,
 	return -ENOENT;
 }
 
+static __always_inline struct vmap_area *
+free_mt_find_enclose_range_locked(unsigned long start, unsigned long end)
+{
+	struct vmap_area *va;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	va = __find_vmap_area_mt(start, &free_vmap_area_mt);
+	if (!va)
+		return NULL;
+
+	if (va->va_start > start || va->va_end < end)
+		return NULL;
+
+	return va;
+}
+
+static __always_inline void
+occupied_mt_cache_gap_miss_locked(unsigned long candidate, unsigned long vend)
+{
+	struct vmap_area *prev, *next;
+	unsigned long blocked_end;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	if (!occupied_mt_supported())
+		return;
+
+	prev = __find_vmap_area_enclose_addr_mt(candidate, &free_vmap_area_mt);
+	if (prev && prev->va_start <= candidate && candidate < prev->va_end)
+		return;
+
+	next = __find_vmap_area_exceed_addr_mt(candidate, &free_vmap_area_mt);
+	blocked_end = next ? next->va_start : vend;
+	if (blocked_end <= candidate)
+		return;
+
+	WARN_ON_ONCE(!occupied_mt_store_range_raw_locked(candidate, blocked_end));
+}
+
+static __always_inline bool occupied_mt_seed_from_free_locked(void)
+{
+	MA_STATE(mas, &free_vmap_area_mt, 0, 0);
+	struct vmap_area *va;
+	unsigned long search = VMALLOC_START;
+
+	lockdep_assert_held(&free_vmap_area_lock);
+
+	mas_for_each(&mas, va, VMALLOC_END - 1) {
+		if (search < va->va_start) {
+			if (!occupied_mt_store_range_raw_locked(search, va->va_start))
+				return false;
+		}
+
+		if (va->va_end > search)
+			search = va->va_end;
+	}
+
+	if (search < VMALLOC_END)
+		return occupied_mt_store_range_raw_locked(search, VMALLOC_END);
+
+	return true;
+}
+
 /* Lowest-match scan directly on maple ordered traversal. */
 static __always_inline struct vmap_area *
 find_vmap_lowest_match_mt(struct maple_tree *tree, unsigned long size,
@@ -1939,11 +2086,39 @@ va_clip(struct vmap_area *va, unsigned long nva_start_addr,
 	}
 
 	if (type != FL_FIT_TYPE) {
-		if (free_mt_supported() &&
-		    !free_mt_update_va_locked(va, old_start, old_end))
-			return -ENOMEM;
-
-		if (lva && !insert_vmap_area_free_locked(lva)) {
+		if (free_mt_supported()) {
+			/*
+			 * Drop only the consumed sub-range from the original
+			 * free entry instead of erase-then-store. The maple
+			 * tree leaves @va at the surviving sub-range intact,
+			 * so a single mas_store per clip side suffices.
+			 *
+			 * For NE_FIT, insert @lva at the original entry's
+			 * left portion first: mas_store overwrites the old
+			 * [old_start, old_end-1]->va entry only across
+			 * [old_start, lva->va_end-1], leaving the right side
+			 * still pointing to @va. The subsequent middle trim
+			 * carves out the consumed gap. Trades 3 stores
+			 * (erase + restore + lva) for 2.
+			 */
+			if (type == LE_FIT_TYPE) {
+				if (!free_mt_trim_range_locked(old_start,
+							       va->va_start))
+					return -ENOMEM;
+			} else if (type == RE_FIT_TYPE) {
+				if (!free_mt_trim_range_locked(va->va_end,
+							       old_end))
+					return -ENOMEM;
+			} else { /* NE_FIT_TYPE */
+				if (!insert_vmap_area_free_nocheck_locked(lva)) {
+					kmem_cache_free(vmap_area_cachep, lva);
+					return -ENOMEM;
+				}
+				if (!free_mt_trim_range_locked(nva_start_addr,
+							       nva_start_addr + size))
+					return -ENOMEM;
+			}
+		} else if (lva && !insert_vmap_area_free_nocheck_locked(lva)) {
 			kmem_cache_free(vmap_area_cachep, lva);
 			return -ENOMEM;
 		}
@@ -1965,7 +2140,7 @@ restore_allocated_vmap_range_free_locked(unsigned long start, unsigned long end)
 
 	va->va_start = start;
 	va->va_end = end;
-	if (!insert_vmap_area_free_locked(va)) {
+	if (!insert_vmap_area_free_nocheck_locked(va)) {
 		kmem_cache_free(vmap_area_cachep, va);
 		return false;
 	}
@@ -2048,6 +2223,7 @@ __alloc_vmap_area(unsigned long size, unsigned long align,
 	int ret;
 	unsigned long nva_start_addr;
 	unsigned long nva_end_addr;
+	unsigned long search_len = size;
 	struct vmap_area *va;
 	MA_STATE(mas, &free_vmap_area_mt, 0, 0);
 
@@ -2059,6 +2235,28 @@ __alloc_vmap_area(unsigned long size, unsigned long align,
 		return -EINVAL;
 	if (size > vend - vstart)
 		return -ENOENT;
+	if (align > PAGE_SIZE && (vend - vstart) != size) {
+		if (check_add_overflow(size, align - 1, &search_len))
+			return -ERANGE;
+	}
+
+	if (occupied_mt_supported() && align <= PAGE_SIZE) {
+		unsigned long candidate;
+
+		if (occupied_mt_find_hole_window_locked(vstart, vend - 1, size,
+							align, &candidate)) {
+			if (check_add_overflow(candidate, size, &nva_end_addr))
+				return -ERANGE;
+
+			va = free_mt_find_enclose_range_locked(candidate, nva_end_addr);
+			if (likely(va)) {
+				nva_start_addr = candidate;
+				goto found;
+			}
+
+			occupied_mt_cache_gap_miss_locked(candidate, vend);
+		}
+	}
 
 	/*
 	 * Free maple index is authoritative for allocatable ranges; lazy and
@@ -2067,26 +2265,37 @@ __alloc_vmap_area(unsigned long size, unsigned long align,
 	mas_set(&mas, vstart);
 	va = mas_find(&mas, vend - 1);
 	while (va) {
-		unsigned long search_start = max(va->va_start, vstart);
-		unsigned long candidate_end;
+		unsigned long search_start, limit_end;
+
+		search_start = va->va_start;
+		if (search_start < vstart)
+			search_start = vstart;
+
+		limit_end = va->va_end;
+		if (limit_end > vend)
+			limit_end = vend;
+
+		if (unlikely(limit_end <= search_start))
+			goto next;
+		if (unlikely(limit_end - search_start < search_len))
+			goto next;
 
 		nva_start_addr = ALIGN(search_start, align);
 		if (nva_start_addr < search_start)
 			return -ERANGE;
 
-		if (check_add_overflow(nva_start_addr, size - 1, &candidate_end))
+		if (check_add_overflow(nva_start_addr, size, &nva_end_addr))
 			return -ERANGE;
-
-		if (candidate_end < vend && candidate_end < va->va_end) {
-			nva_end_addr = candidate_end + 1;
+		if (nva_end_addr <= limit_end)
 			break;
-		}
 
+next:
 		va = mas_next(&mas, vend - 1);
 	}
 	if (!va)
 		return -ENOENT;
 
+found:
 	ret = va_clip(va, nva_start_addr, size);
 	if (WARN_ON_ONCE(ret))
 		return ret;
@@ -2571,7 +2780,8 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 		}
 	}
 
-	WARN_ON_ONCE(!reclaim_list_global(&decay_list, false, &decay_failed));
+	WARN_ON_ONCE(!reclaim_list_global(&decay_list, occupied_mt_supported(),
+					  &decay_failed));
 	list_for_each_entry_safe(va, nva, &decay_failed, list) {
 		list_del_init(&va->list);
 		WARN_ON_ONCE(!node_pool_add_va(vn, va));
@@ -6043,3 +6253,21 @@ void __init vmalloc_init(void)
 	vmap_node_shrinker->scan_objects = vmap_node_shrink_scan;
 	shrinker_register(vmap_node_shrinker);
 }
+
+static int __init vmap_enable_occupied_perf_mode(void)
+{
+	bool seeded = false;
+
+	spin_lock(&free_vmap_area_lock);
+	try_init_occupied_mt_locked();
+	if (occupied_mt_enabled())
+		seeded = occupied_mt_seed_from_free_locked();
+	occupied_vmap_area_perf_mode = seeded;
+	spin_unlock(&free_vmap_area_lock);
+
+	if (!seeded)
+		pr_warn("vmalloc: occupied perf mode disabled (seed failure)\n");
+
+	return 0;
+}
+late_initcall(vmap_enable_occupied_perf_mode);

-- 
2.34.1


