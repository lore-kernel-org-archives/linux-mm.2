Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19480D29DF3
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4406B008A; Tue, 13 Jan 2026 04:31:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA786B008C; Tue, 13 Jan 2026 04:31:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9C16B0092; Tue, 13 Jan 2026 04:31:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59F6D6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:31:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 093BC1AD276
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:31:01 +0000 (UTC)
X-FDA: 84326421522.23.3B6AC6D
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5049D180004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:30:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YfF++4Xg;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ZVBALL7v;
	spf=pass (imf24.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768296658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Eiifu80j52RijGjXr0wmDrto47lICEqQroalzmp67M=;
	b=CQ8yuS3a+j58ZvOxCRkb+rKIMdtPdVlWY0e1WEwaCw/cDcJ2DM+tsP36oLGkeyolLWrfxm
	p/iZnw4EyiAfllDJ4obAfouUeyp0Pe+UTME4MAi5pwen7IMk/IwspQ4GaNupsQ1eHVdcQI
	Fr+hvMmJ23x0n8ZC4pBviayMdm6SMWU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YfF++4Xg;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ZVBALL7v;
	spf=pass (imf24.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768296658; a=rsa-sha256;
	cv=none;
	b=SHXkEroMFa+3VOnWAUbxeCtPLFRVE45Jw+X3rLWFdPBg1KmHx2EfpRL1CufjYf9o9Tfh7M
	ATjeiHLBEpgty1CtsRnQBT0BrlW/dLb2C60DZd4GVqvzuwAEG/sX8OqC3inhIAPkHaPit9
	f7oE4W/mymc4ygpFEb/9Ihx8OxL6Mi0=
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D5asm43636970
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1Eiifu80j52RijGjXr0wmDrto47lICEqQroalzmp67M=; b=YfF++4XgPIGbz39f
	eSVF+zTnBwNCHcw/gGjlutnVpdpecUfbiB+jHVkJzzUHyQJXovhoff48zNCeAqg0
	fP/kOeiUSuscrgmJmjXMJBIgM4JvwJuCazXpyWb2VuDdte8CAdj6qw1d+SjT4FyC
	Fc9WNKzF9W57WqCcO2lof9P5BUI9YsfaSUogOnOGjBaNpvtn7QikbP6MBYb6YAIb
	XKXMw4y+z8vSYQlflYb5FvTMETvqXurmRqr69+yH76VftkKJC3gmSD/8/Zf9FLvn
	YR5qea1DHhH5hDHRgSgA+W0BF0kLEL06TzWONOLL2eUsPgnYs0N0ZQNq4BZDqt5Y
	LSwfOw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bng2c0q71-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:30:56 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-81f48cec0ccso1911549b3a.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768296656; x=1768901456; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Eiifu80j52RijGjXr0wmDrto47lICEqQroalzmp67M=;
        b=ZVBALL7vVnQvRpK1N6Fujdvh2GC7EUZVYAfxYFMWr1BxPYBJB25lA8oCpDaT5mhg8P
         7FW34lhvd2ZvSc+YWB62BXB5IodQZJsW2+MnGTwBXaO5DGyRdBCJyGrppO6eKO8Krx9g
         j+GAyBRMNpUGZK4JNoFX3P0Cm79s35E2CrorjsYMENeyPAPlQR6fQ+hJDqNToMkIH5XZ
         mo2/cUC1QzSt2IDDYhcQ95mIrI8Mz6sHgnFgQI70GXAknkvmADlJ/52ALHAtILUoJDsh
         UUo7QB2nF9eB/FERXLBUoUnIo/reZoFEk9En/0m3G9NTZitqb/JQkRg8eWZP0rkU397B
         5wvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768296656; x=1768901456;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Eiifu80j52RijGjXr0wmDrto47lICEqQroalzmp67M=;
        b=N2uM3Zc7sCOCtJ6+vR/1n3UaQ/Zb2X+ZjTiDHXmaOJmNxsXNAX06g/hOo3OhY9B0V6
         9aD0ECbxTPe2ws4jdJK/rrpu3zOpJAN9QKSXIYIEJWxpfS5/LEwLOClgBsP+JDhTehs/
         PWpym58huIYnnKS62KHmm/VLfQ/jht8fKlcxKo0svWc/DAZQbb5khZ2uX7nrQ+sVSefh
         iIoR6cMTUoCEs+DCerfEKo72PlwWPSZSMeBNXJMJ5cXRAfeUcTGxcBtMhxQeZC7PImeS
         b3yCu2OAitypUloIufYJQ01BbTwhjqQqlA6eKJnbgwVeQSApo27nSIOUXyHCYHnabZrt
         rwhg==
X-Forwarded-Encrypted: i=1; AJvYcCUeo7rN1wAp2JaUbCVGUwYSGzI6Jw/x1SC3qOQhIBrgV9RnjMopvlZCizEXu+sPWc3rvfbp59bb5g==@kvack.org
X-Gm-Message-State: AOJu0Yx29ggwxxRArZnkdL6dgx0aO+X7/ukVE7f5ZDU0x3Ja/CfrK0e1
	r/A+WvleD+qjNDOM+p9s8IcjUSKAGAB6CyjzqGOy7I4pnZ0VdwCD/kgedqfIatwQL9zPVE+w5fN
	toeizpdeeoMrsrp3Ux7Bk6mJjPDXNeJFZN6YreDa263HIi94p/qAjVw==
X-Gm-Gg: AY/fxX5fKh/oCIi9Xg+lRcVguZLO8MrcgdkjEuRwB+xH4DRFugp5FNsKpW4LWy6zV3s
	SDW8cEcE2k7GeCY25kbdoaUFxzE1ea6VwHE6RpHjzIxUQo0baERZECGKBEY+9PnNE836ZiLpEXe
	gJzhalmvukIejBeRNZaJfTS4olgGffTGeHBn4L3aGbcYTAQqyyKALVDcwhLtWabsh4jcf/+Ux5T
	KT6giSRYOFiUcDeZGo9sMBoIMa5IwfsoPaOgLPhToN9Kk84h1Jsa80KpHVSlVUn/zgCeWlWaPNA
	FO6++Gk2X7W4cCcX6pgGou3tW+cxFnlzS8reYd/6QRhGn+WaoDJGwT0HuqimaARJaHSHeX1tlLO
	TKu2JCJWNaWEVXnQDAiiEfMcTGDyD13/5HnfQiEfhvg==
X-Received: by 2002:a05:6a00:3018:b0:7a2:710d:43e7 with SMTP id d2e1a72fcca58-81b7ef0bb9emr17349002b3a.24.1768296656225;
        Tue, 13 Jan 2026 01:30:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2N3I1HNLXa81G+Nxk9wRLz1YLh513Pjh3sJ7JFqYDVnyvy2PqTNvo+R990+0YE7pSjEfJsg==
X-Received: by 2002:a05:6a00:3018:b0:7a2:710d:43e7 with SMTP id d2e1a72fcca58-81b7ef0bb9emr17348979b3a.24.1768296655747;
        Tue, 13 Jan 2026 01:30:55 -0800 (PST)
Received: from [10.218.5.175] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81df6b3bd16sm11616850b3a.25.2026.01.13.01.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 01:30:55 -0800 (PST)
Message-ID: <0fe751c5-3816-4666-b0b2-c1427662e369@oss.qualcomm.com>
Date: Tue, 13 Jan 2026 15:00:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: akinobu.mita@gmail.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com,
        axelrasmussen@google.com, bingjiao@google.com, byungchul@sk.com,
        david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org,
        jonathan.cameron@huawei.com, joshua.hahnjy@gmail.com,
        linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
        matthew.brost@intel.com, mhocko@kernel.org,
        pratyush.brahma@oss.qualcomm.com, rakie.kim@sk.com, rppt@kernel.org,
        shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz,
        weixugc@google.com, ying.huang@linux.alibaba.com, yuanchu@google.com,
        zhengqi.arch@bytedance.com, ziy@nvidia.com
References: <20260113081453.8293-2-akinobu.mita@gmail.com>
Subject: Re: [PATCH v4 1/3] mm: memory-tiers, numa_emu: enable to create
 memory tiers using fake numa nodes
Content-Language: en-US
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
In-Reply-To: <20260113081453.8293-2-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA4MCBTYWx0ZWRfX4sc9STafZCKi
 FQPF8l+8FaWxGo4h7RbXZTBUhvoCkETGimMAcSrmCLTZLM90ZW2ivwm3TyBY47+ma5WQRfcCusy
 /jPvJzjC5v/lImHJK0QhM4j76OAJNlKGnU5PS17+1g8sGGffnpgl9R9S8t+4uhaauPH6IaAwC+4
 czJOAsr50wwP957Aoj58oaKIwhBYwIDThvrE4VmTTZO6DMLeuoULtZ0bpZp0HlKRCuws3q6W9VE
 dRFfLcCBAT0Px5LJlEdbVmeDUodYnlYEb6sWFmVgRpSsboNFKmg/Q+h64U0y5Zv3ZbYn55eoMQS
 AN/7kuSN3oa7InDTYa6cuF5exApijFEntwOgHC+j1buaTf4KHbbb96da1i6SIGFq9FnEVJ3OBu+
 ej56uh3k43WLHIRU4yBMGUFcjvQbJywXL4BtWgrJRJ+J/xjuhv7FHHLhApfjseuk7JSsp/kVfL4
 tEZuMEsZMKTnZ1//OAw==
X-Authority-Analysis: v=2.4 cv=C5TkCAP+ c=1 sm=1 tr=0 ts=696610d0 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=UdPnmgDXQIG4_xgNs28A:9
 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-GUID: 6J1IcQRFZ8jJFpWbKcGJ_s3FmElcye0r
X-Proofpoint-ORIG-GUID: 6J1IcQRFZ8jJFpWbKcGJ_s3FmElcye0r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 impostorscore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601130080
X-Rspam-User: 
X-Stat-Signature: ds7nqud3yaibp9mfw6imsh6sqtg6fgyy
X-Rspamd-Queue-Id: 5049D180004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768296658-5039
X-HE-Meta: U2FsdGVkX1+T80km4RYY/TzkXkz38v3gvRf6UVHkj9ruuv1XD+GzEFZvdR3Qf6EDZtdgFK3CjaaRW3W4hPn9F1tg9I/+Iukiuk1AWW6NfpEipIf2vlYM+241u0HGQxzjqFh0QGKBPCa4Sh+lKwgA/JAxl1y0Nw4ijW0uoFCziGHVu1JmLfAhbtUfG2eNeDUpg83PW9P0yh+8WWQVUUbXDJatNKSaxAJA0/To5mS1/HxXYwa8ePJaWZYVzuXxw46ls05ElGUSOm/7di5kjm5jXA6hlJEXbxKdvDq2x6nPwa9/CtOTrZ0sPQoLVHdKWX+EGF1uebGURaw5lmcBzU+Gbs6NmU9qUb+zMja8KvcyWIlwqvOtne/hb27KWrLYiSqRzOLMjyNunzgVsQwnhx6zelqtXQ3SqcxuEak6grlmlWK8Sz2DGdtcD08MgbgSGboKNCgzIADDNmV6QpofWW9k9f7RQ0zW2kDdbhbGV6JP/g988JkQsSyZnNa1fwBjCDKH2U0GcowKsApxi864sjrAMGqBzuvDNjiMpuX8Jj8w+Zu3/zx9nAX5zjj1zlsEIM4b5qoHUUD/rA83yq84ypp8imoxRAJXpg7x9rJy0+hdlIw1DQJOnmaB756M3Jr3n/YZc1ugrXWzkpK2X9hOokxnvmU8NSDpTrG4gzI+Je6ayNfXfQizzJ50+aWU02gCl4rXwwvvYqN7fq3K4HELWHIe+5uaZGwRayIEfW3sm54cCVugcUagA6wh8NhsMbZDZk3lmc+MeuyF8hbnD4h3XnxhcxeVL+/sp9dpcikXpdSxGNCDYAgtOqGoMy83TMlYwkSblMuqLgsYVjBIQi6OJJnaSz5MEAOH65I+YBdvsFcCnSHqyDb7HCNbPs0qb7d09zH+/tVC/klLxK6mLC3kpfWjNBr2PbLYcZ+a3cRqqUZlEl7i3vaaCzs4DVZ3IIT5pT+oZuzwBrv6ZhnBxXj5ndd
 lz5+ozR9
 2fovMKf+Hw4DzTVrWF794tAt9mh93xRT5zx5qEkAzcNZQ3WjX9NKnsW5A7mZeTzNyTbHR7A1FoRULYrU+r2t4at8NIzO84JT+itHwcYT6JJvAY/0G1UA+xuHH+8y9TUf4f+rWBwCahOkJqYMY9KzBh6CkmGNyl5s0A8VruZx96fpEtQPAhEMA5tSBJvZhdD0/M6Az1DW33k6+Ca8scn9ljAf56RSvsOtmfdOKjMcTROO2MEY3NQaAAf5l7AWZ6v6JjL+yAJlqNFudWoTCCZC0hg1gsP0qi0okGkgdP8ml/2SBPGJ+pH7RB+MiWK/5EhNl1w6mLsKYHNE//lizTRuJwCrNxg70ot4hiFE9WoMc6k/d+6KMNi7Ki0lNpgL7USQxn9B8jhoZLP+mXPEKFX0M+DMEb8c+rXkwqdv4g7hfzE20pp64QCZEdBqqdgWmdOYvRh33ayedOc9ReQJQzHGZgIA86nQSps3WooBZbF/lnt8Y98JqaEErusfnBDfN/OVvYDITrb9WtcmMNtt+GYdOIV1aLD2unTRWZPHtSti5k2VzbfgkxLxNa2ilUMKEPpw8rUxPiD/XSyoHBFO2rmcdGwm6ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>


