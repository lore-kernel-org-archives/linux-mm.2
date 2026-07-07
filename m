Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDACCC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 03:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FCB46B009D; Mon,  6 Jul 2026 23:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ADDC6B009E; Mon,  6 Jul 2026 23:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59CD46B009F; Mon,  6 Jul 2026 23:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 251396B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:47:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74EC4168A27
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:47:22 +0000 (UTC)
X-FDA: 84960595524.16.F9D8B16
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7A28C0007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:47:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=PCsuMmqq;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="K4Uhy/uD";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf10.hostedemail.com: domain of ashok.raj@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ashok.raj@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783396040;
	b=PcNKDxkn+C6LnrMxXBeGrPUv+q5rpVNJUime3z8zE7ZjL6V1EuCyf2ENdBaesVwLEbZ4SN
	ZdxgwkNlNqjFZPnaL+0g19tgfSostR6kRB/iUxr8u+MP4J2b/nXN2qP3XGmwzmnWCHAJfu
	m26cDJlGhy0FDqatZ7NsHXsAYmt8lEI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=PCsuMmqq;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="K4Uhy/uD";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf10.hostedemail.com: domain of ashok.raj@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ashok.raj@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783396040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10l19KTCxqSqYBdgxJawtbugfIDCCKBH6sLy1qfvrv8=;
	b=wAji7cpA0dWbOg4XrB6xze/dcY48VfYuZYQkT7BRUWXe4RG28oLlNWqLL5SUVbsPxlb7vh
	u7TgHzKH6fGAx0xFwbeHvC/P5WzB/g5HqThk4p7p63k76cPTY4nFHN+E7TJ8pynCkBSGEs
	ew4otB7oqNYUJphqkWS9O2BtFAxH5YI=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666KE4FL1626316
	for <linux-mm@kvack.org>; Tue, 7 Jul 2026 03:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=10l19KTCxqSqYBdgxJawtbug
	fIDCCKBH6sLy1qfvrv8=; b=PCsuMmqq4w6H8IKL4WBNW/wOKcccb1RfrTXGgngs
	i5Y4KjftEt1aheYFGe6WM5ujcx2y7DfRXzChlPcTs/rMe+X41JrJJDSGaXnaGNax
	3u3W9HUrrCcLI7mAwkfsMu+clPpxiVxzWQA1VcpAvxuqOCFl00nz4qRvqHu9Klf2
	9genqowRTUZGoDrS3anzJJT0dxsryrsR9gjmaxjJkxWxTuwPFTj7N3WBBePYelWL
	94Fhk1NOQlkLLalHLZXlmeNpurVQ9oW8dv/ZIAXDTb4ckf0hysc8GuX47/qJvt+E
	eq6aWDlZRXzSaVyEyuR5hId7u36XyYQUZALUUckKBtNjtw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f88h9cer6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 07 Jul 2026 03:47:18 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c89704da8c7so6251802a12.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 20:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783396038; x=1784000838; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=10l19KTCxqSqYBdgxJawtbugfIDCCKBH6sLy1qfvrv8=;
        b=K4Uhy/uDZ342UA7Y57UEei4nMzcPpPm+Rwb6dpFsPE4YOwyXfO2tf7O5jMUMd+ZMET
         ksKsGu1C9a9Edr1RKuvx575mG7JuAy001zzQxz/M4Pc2o2KQ1hO2GpZn/vG/n+a6jX4G
         r/24ui2qFme9pqlP0mX7KX3r9OgIIsTvANcUnHVMrl1H1mzsS7UYOjmoJ35sYftTi7mg
         rr/nyL9pNRiedKBgBLNEKUgn4fq2b+HUPJccAznGbLqZbZlQt0RtmAoj9NU2DssaSVtr
         SMe90+irz9zBxh1GcDhCqrsXLUF90KSD837Azu+SnysOzT6hRXwKg4YUYGEaI/SVUzgx
         wWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783396038; x=1784000838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=10l19KTCxqSqYBdgxJawtbugfIDCCKBH6sLy1qfvrv8=;
        b=c6Wi/w0sOsZjvFskQk4gu+pUue+kBsyGI2+TPRjsptX8ZQbPeozt4PzsamfEY7+6w3
         CGrsQuCwJfHH8Qi8Jxd//yeK2Sfj1gjGTJzEuyHiPNzjvnLetNxq6XbieC9J+YeMOz8X
         VFCI+MC9fQcPIQ8hHox+RwGLU2FkIrQfEL8azGQTLo+jJk/L+VwAR13l3iqwZ0DMT/1S
         11QCBGhNqhb/3t9pQR93mxEoBcMioVnVvNgyGXD+3AalSJRhkeEXV20wzvNTVPcvA7QB
         iolXYNSBLSf3unj8DNENUdIrP6tQatxto/e/W1h5vBgnVt/cRO/NqI/T8u7yL69a3tYU
         cyjg==
X-Forwarded-Encrypted: i=1; AHgh+RpM8A8E/a2CXNyDbB2CVGgFEd0icAf3kHnczIGxmdONZIp4wXN5axe98kx4hlOHEhjAh96S6KoXcA==@kvack.org
X-Gm-Message-State: AOJu0YyKNO5QCMtgu31D/2vts3J6Ej0T0cIzfMYAxDcWsG8FWA4Ev6wg
	wQOwZ8no7F1r5NaIBjBofFvI39YcdvWdOMcBGNq2QjDRgPJNsqvr437MV4NcxhbqGXzkg2JwRA2
	zUeJAy6dcS9xGy0zCMz3LwVkgby62pa6mHHTPsWziryglcn5WyV28sQ==
X-Gm-Gg: AfdE7cnxquDTc7rJ8E76cRk3lODsBLK0OCRLamJnBDnaKhZDQYdvK3l38BTdQTJpiq1
	bYpUB8jkiFdHMjb10zHFc2f2FR1UhYdg8EBLHiCKOVF/0XKnkHRSW7WBdZ5fhUf7UvvEEk+Fvdg
	yURMSjVANyGrH7BYMvBeG/GDHxblqDbCX/wg7/6st3uBJD4Ds/jxesR+G+HL8AwTGDeRbJgYemD
	fuaSYP3l4cTlz9u2/u0OT8CI5AHi8K5tF6pbLgLwSK9FALjU+WtsNFwW/2dZdm0qH12IxawoBQk
	o+pb2yKehUk6fXEMJzTSjXcC80JLwcMDJ0bx2717WZGTX7JRtgFlf5vjtyDmy0L/Iu0hrCsk5yh
	1oMc0rUJzrYzktxpFuSwp+ZPNl5veBJAqNTA2x1lnEO8IhY10O3U+eIELN4t+
X-Received: by 2002:a05:6a21:6497:b0:3bf:b9de:854d with SMTP id adf61e73a8af0-3c08edf0234mr4305553637.23.1783396037830;
        Mon, 06 Jul 2026 20:47:17 -0700 (PDT)
X-Received: by 2002:a05:6a21:6497:b0:3bf:b9de:854d with SMTP id adf61e73a8af0-3c08edf0234mr4305480637.23.1783396037283;
        Mon, 06 Jul 2026 20:47:17 -0700 (PDT)
Received: from hu-ashoraj-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b6593c76dsm2875802c88.3.2026.07.06.20.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 20:47:16 -0700 (PDT)
Date: Mon, 6 Jul 2026 20:47:14 -0700
From: Ashok Raj <ashok.raj@oss.qualcomm.com>
To: shijujose2008@gmail.com
Cc: rafael@kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        rppt@kernel.org, dferguson@amperecomputing.com,
        linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, tony.luck@intel.com,
        lenb@kernel.org, leo.duran@amd.com, Yazen.Ghannam@amd.com,
        mchehab@kernel.org, jic23@kernel.org, linuxarm@huawei.com,
        rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
        dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
        james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
        erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
        gthelen@google.com, wschwartz@amperecomputing.com,
        wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
        prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
        kangkang.shen@futurewei.com, wanghuiqiang@huawei.com,
        Ashok Raj <ashok.raj@oss.qualcomm.com>
Subject: Re: [PATCH v21 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Message-ID: <akx2wqr3ULcmpCmc@hu-ashoraj-lv.qualcomm.com>
References: <20260706000338.362421-1-shijujose2008@gmail.com>
 <20260706000338.362421-2-shijujose2008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260706000338.362421-2-shijujose2008@gmail.com>
X-Proofpoint-ORIG-GUID: PsXnsWQvBqNSDr6icJqFcQXv0D6bgLCo
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDAzMSBTYWx0ZWRfX4MMuOuvMXH8t
 FC2HSVRJG/mV6jwI1HLZzxtzI9Zx/9zTjeGFFttshue/5n4oBAK0w9Kw6EZzF7UxkuAktHEj0sh
 Ijic/F7kwEWQG2s20vqjnFOFO568cyU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDAzMSBTYWx0ZWRfX1CqeUOfZ+R6f
 /2Co1dpI70nqU8q09kQ6whz6Q2XBRKqy2n/DJM4hyWjiyCTD9oAM46dptqPvY1NeGmQpBMU7b4p
 g1tk7jugwXpy1VBQop8v5y3xh3llKJSPdKlnfqyK1yNqIGu2cophzooEcXJ6EoQyNH2fbtJMiXt
 XYWe/vRTK1ACyYW2t7PMCuaBTIGOfDZg8LXMXdNFrHxzQpu73yNzWS3vLBQW+VqQWxd2tQ7uM6I
 dirst882/bGwWiDOQsymaLh6IzNdh6U44HLx2t6bkB6OhV3Jy0qvMB/yO2TFPy3ehcUZJmQ2I9T
 ycgYOUiAniKgNj+L5zSR6/XVIvt2puQFFWUaZb2Z5wrxrum2/8oO8fQlD3gN6YG7sExKWbIGfDO
 XV1tqq7aWK6kLV4yH3szEZ3R1YmszkLJkRBCKicfiVwLXw8mj5o2JXp2gq461Gje1n7SD8Zh/n3
 mvefLC+OS8lMQndd3JQ==
X-Proofpoint-GUID: PsXnsWQvBqNSDr6icJqFcQXv0D6bgLCo
X-Authority-Analysis: v=2.4 cv=GulyPE1C c=1 sm=1 tr=0 ts=6a4c76c6 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=Go8T6LQju8gDQlRwKi4A:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_03,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607070031
X-Rspamd-Queue-Id: E7A28C0007
X-Rspam-User: 
X-Stat-Signature: ghi73oy5hsk5drcrpwzxsexakz74j5dp
X-Rspamd-Server: rspam03
X-HE-Tag: 1783396039-684258
X-HE-Meta: U2FsdGVkX1/1jcO0rsX6Zl1yBT5iUwc+NSwu4wSvTz6yqbqJw5K4PXpIouGvaJTWILgB0QD7sxcTRBorbkkfEVbDkHTfnEnNhlIqncxoS/ynYkFU1wVWiwJNfCBY/augrPuPlhxsv9QSliPeop7NwLK1v8wsG1AR9WqL7EkMluD+1iEheDAGnyMzv7cEiGVS46f2kdOJt3M+0+r+ufRfD72JC78C1Izrisz5Tn3O/7cCxVVrrIyaTP0clGTae/mxyyfbFG0K/YYcjeZCdJlqv0tGKP2vs8QZ7JQkFMg+4Hqk6I6QKaVK+1/eqt4CniTGoHJaEGO9qFqrMEPpnjuiR3TL6w0/p89TbGgujkQtg/j1blqUANcXuqXTFvWcxKK0ohn2vlDkZ3e+M4JkMGNQsKXi9d1AZDko0uwQwq6lkhytOCjo+1wAVuogGJj9mJOJQ9mnS4bWIDfrujc7uvNxlFZcUQNpBuOv3mmJxnjnVRIUZH+Aa4iYCZws+NaDAauIQz7AiynKg0FnaExshCyNGQOH8WXix/Ng0XXn1dW+4THX3xxcnT28A8RP+T/V7OEXiWvWel5XLw5YnkvNwf5ATTRphDATQXSBVrucNAYLS/r+vUuDPszJdqtngPnh24wrBqhkeO3t3vRb2yDWLlYFvZqv9SaL9NZdBSvVyHrO5siTbug7di6Zjxvlej4kMRQBCbJdSE79I/qmEicEFzHy4iZR1AFVfO8KYBHpnXMl4Af+zIE+4HanGbFI0XR0nUqBWnz3HT6Lp64M86cQ9sb1cH7OfeBbPwecuD7o3EadJK0mYR7YxFIREgtejp1qdxaVd5+Zt1zXR1bISKaMUpZ02st/2TaQernendJoWNzfC3ivltge2H0l/k3cZg2kq8oFvy25x1ILTMt7Fj/NKAs7TWCHi8JeV/146fNDFWqU4SnjKWzbUHARatIjOEGIcgEaNOrC7hPZxTR+OVMgtI4
 36LqtY1Y
 Dsi1K1nLWNOG2Y6vJSa5kO5f6aa4Ds7R8YyDDCDBBzEmmho90eLWhkdAoL/BvwjZ2EFbOyr5NliLo703hCi1tsog/YQEB5gpE5EXBNidlh7qm+HacaAltTb+M0vDiFYJQ0/LXwJ+9NiHF0pePRTCPbCYiwyYnCPOcJhq5kojhj2HJRfNplsaZ2+NrntnlNOII/WTGn0d61SHkrTmC0lWBRWLCAEzELtClyWGV9iwCx/56BCXbrx2/xywtqEGtOo2y5wc6tJ5zmwI47OC+il6wphnG5wQUfmpBodd9JLwSIm9RhWD1E++A2XF0/gUs0t9JmglISWwuYhZKqG5XmyWFZc+kYoDRXty3hlnimbuqa2B860jfGjXAKvLN94GF3Fkxo1GG8R9I194qzW7A6EUUvgAaofPVfnbjzVnedG0vQ3vmnsUtaz8fVAYLHmyBKOcnteJ1Vc78t9O+lNGRrSFTQtGmIyrmkxTnUbHdRlSCTG88Xsssf5G1/cf3ZaE9jzGff7JCCj2y0l7AXXyBt6YNef6D1/mQQYweq1ZXI/y8IQe5ZtT4rzBWkCZGSdrG33GBA0Z6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shiju

Thanks!

On Mon, Jul 06, 2026 at 01:03:37AM +0100, shijujose2008@gmail.com wrote:
> From: Shiju Jose <shijujose2008@gmail.com>
> 

[snip]

> +static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int pcc_id)
> +{
> +	struct pcc_mbox_chan *pcc_chan;
> +	struct ras2_sspcc *sspcc;
> +
> +	if (pcc_id < 0)
> +		return -EINVAL;
> +
> +	sspcc = ras2_sspcc_get(pcc_id);
> +	if (sspcc) {
> +		ras2_ctx->sspcc		= sspcc;
> +		ras2_ctx->comm_addr	= sspcc->comm_addr;
> +		ras2_ctx->dev		=
> +			sspcc->pcc_chan->mchan->mbox->dev;
> +		ras2_ctx->pcc_lock	= &sspcc->pcc_lock;
> +		return 0;
> +	}
> +
> +	sspcc = kzalloc(sizeof(*sspcc), GFP_KERNEL);
> +	if (!sspcc)
> +		return -ENOMEM;
> +
> +	pcc_chan = pcc_mbox_request_channel(&sspcc->mbox_client, pcc_id);
> +	if (IS_ERR(pcc_chan)) {
> +		kfree(sspcc);
> +		return PTR_ERR(pcc_chan);
> +	}
> +
> +	if (!pcc_chan->shmem) {
> +		pcc_mbox_free_channel(pcc_chan);
> +		kfree(sspcc);
> +		return -EINVAL;
> +	}
> +
> +	sspcc->pcc_id		= pcc_id;
> +	sspcc->pcc_chan		= pcc_chan;
> +	sspcc->comm_addr	= pcc_chan->shmem;
> +	if (pcc_chan->latency)
> +		sspcc->deadline_us = PCC_NUM_RETRIES * pcc_chan->latency;
> +	else
> +		sspcc->deadline_us = PCC_NUM_RETRIES * PCC_CHNL_DEFAULT_LATENCY;
> +	sspcc->pcc_mrtt		= pcc_chan->min_turnaround_time;
> +	sspcc->pcc_mpar		= pcc_chan->max_access_rate;
> +	sspcc->mbox_client.knows_txdone	= true;
> +

  Probably a minor nit .. 

  sspcc is published on the global ras2_sspcc list (with a live kref)
  via list_add() before sspcc->pcc_lock is initialized a few lines
  later via mutex_init().

  Once list_add() runs, ras2_sspcc_get() can find this sspcc and hand
  out a pointer to it (kref_get_unless_zero() succeeds since kref_init()
  already ran). A caller doing so before mutex_init() executes would
  end up with ras2_ctx->pcc_lock pointing at an uninitialized mutex.

  Currently harmless because the only caller, parse_ras2_table(), walks
  PCC descriptors strictly sequentially, so no second register_pcc_channel()
  call for the same pcc_id can land inside the window. But it's relying on
  that being true rather than the code enforcing it.

  Should we initialize the mutex before publishing the object, e.g.:

        mutex_init(&sspcc->pcc_lock);

> +	kref_init(&sspcc->kref);
> +
> +	mutex_lock(&ras2_pcc_list_lock);
> +	list_add(&sspcc->elem, &ras2_sspcc);
> +	mutex_unlock(&ras2_pcc_list_lock);
> +
> +	ras2_ctx->sspcc		= sspcc;
> +	ras2_ctx->comm_addr	= sspcc->comm_addr;
> +	ras2_ctx->dev		= pcc_chan->mchan->mbox->dev;
> +

> +	mutex_init(&sspcc->pcc_lock); <---------------------

> +	ras2_ctx->pcc_lock	= &sspcc->pcc_lock;
> +
> +	return 0;
> +}

Otherwise 

Reviewed-by: Ashok Raj <ashok.raj@oss.qualcomm.com>

Cheers,
Ashok

