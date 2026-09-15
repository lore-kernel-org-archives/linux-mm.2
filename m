Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F0D9C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 00:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8797D6B0088; Mon, 14 Sep 2026 20:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B776B008C; Mon, 14 Sep 2026 20:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8546B0092; Mon, 14 Sep 2026 20:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BFB46B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:57:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E8F6160248
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:57:40 +0000 (UTC)
X-FDA: 85214183880.09.9E8A1AB
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	by imf23.hostedemail.com (Postfix) with ESMTP id D39FB140007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:57:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=oHRZ7SjR;
	spf=pass (imf23.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789433858;
	b=syMrxWU5mi41C9jozUKAnmETESy+DkqEe+wONv/gcvSaFUWjJbokiX1aAc+9oCCMwKxIOF
	LXerRKsuMzKdvas/nEcIrGs5arG51Y1JSsRGDxYhLFUPjJpG1qWyF2pJL3KYUItT7xk+xj
	HLICvUu8cD+CP7FbQY8vUzNI08ZVQr4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=oHRZ7SjR;
	spf=pass (imf23.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789433858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OS259iErZnBxTgbybAxhMxIa2SCl4Sz3q64JgdnS2yg=;
	b=j6q2jsL0iarLHhlzfdWwRza8/4kYWQMgyEmdrc1q809qmBWartua2v6V09bLyUm7eEz2qY
	lBoD1rQd2dcNUYgzT7pPQ+T6Uq6ZFpeFGjZaeKDkh8eyY3gpk4wra/37gen3j95QrWwhMu
	RXKJjUinKJexUxUEiEO0UibUc0hcNco=
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68EN3pS43403440;
	Tue, 15 Sep 2026 00:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=OS259iErZnBxTgbybAxhMxIa2S
	Cl4Sz3q64JgdnS2yg=; b=oHRZ7SjRZFoWlHuqcXVhmfDJ0wGKX+/3mpgx0AfSCG
	zyvpc5MC3hwNTiLzQDrzBIcuzozkvFEuZ2U0h3QlKnj6bu76KZiuB95M40+5Zdvi
	sMZvrP4xkB/agoUhMwd92aKH/pFhyeEf9PGN9KBBy+IG0WFQJm9Ue1306kpaZJMt
	sAJCVikyL/DAIgbkMcDD7l4eR7ge+5yXnMGYKQiPS8AWGEGhYcxmIaXcB02aeNBE
	bYNvgxFlxVGYxdpLnrj5+A9Wzi/5WMGWCVEbJ8HRouGFvb6RUAMgQrjiJIY9dEi/
	YIpPCYED1oKg9SOWDfBqiWEMW4ZJTxbvdm/s+Y0DfquQ==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4gppy1khtu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 00:57:11 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id B5122806B2F;
	Tue, 15 Sep 2026 00:57:09 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id 827A7801710;
	Tue, 15 Sep 2026 00:57:05 +0000 (UTC)
Date: Mon, 14 Sep 2026 19:57:03 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: corbet@lwn.net, david@redhat.com, linmiaohe@huawei.com, shuah@kernel.org,
        tony.luck@intel.com, jane.chu@oracle.com, jiaqiyan@google.com,
        Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org,
        jack@suse.cz, joel.granados@kernel.org, laoar.shao@gmail.com,
        lorenzo.stoakes@oracle.com, mclapinski@google.com, mhocko@suse.com,
        nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
        rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
        surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aqiX3-TxmbFkU8xs@hpe.com>
References: <aqiIEkrc6aDBOqRg@hpe.com>
 <20260914173700.346dc533f1f21ef170b7722f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914173700.346dc533f1f21ef170b7722f@linux-foundation.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDAxMCBTYWx0ZWRfX1J48re0Pg76+
 isfei2rI9AQNEKpzmp0oGGQ7+UgNmRXG6g8gKGs2bzMjqbPzityDM73+bGjAhzPS7KlFCRTCd6j
 QEblYzHBFdNln+P8vYgR6jBTU38dP7nj6rvUn3bMbYb8CRJo1k+YIt5PaeCLeHORqzXQOxOuBrO
 I8e93cWpAPEWJNzwwrwrz2az0ri83aYEgZ8crHhfDN9frN75ABYbJ+xDz80Xw/eBo1oxSUFC+Vz
 mhelffqylCDlX0b/AXClyQzByaSWykcB4IQ32kZVL1g1P/GP16ZXC6MhHKJW6YZorpvib3ebP8n
 ucJmktJ/5oVpXLCDQ1rpCzsSbpqx5VrDiQ22zMz2u7LB0I8m1CdoOEzEApVT4mKgUIWwFEwJ41f
 YpvNg/IZtZe8dbRFuYIUda9LA5pMXFFSFa7NC5ALQ8Iw8bF7+wcL/XvdVowuMIeBT/8idp1S1Oc
 0BqsyKKMAIbzqutDtvA==
X-Authority-Analysis: v=2.4 cv=LKbz05W9 c=1 sm=1 tr=0 ts=6aa897e7 cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=ModqzXLkJJ0tFyq98apW:22 a=VwQbUJbxAAAA:8
 a=MvuuwTCpAAAA:8 a=QyXUC8HyAAAA:8 a=8QjRa3sHNxljrvLfDkgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: r2HkFnvshq4dFtHu-OxLp914XimHte7n
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDAxMCBTYWx0ZWRfX/uPv4lyY3U70
 +n+WkuZ7wkaUjohP3ln1OA8ZTlhbOl5UdaLjpEvIfoodrGnwjaYFQsQPhtK/bFJW9pReige7eOf
 Bef4U7tldSqIwBnAlrNfoL7YPykIIto=
X-Proofpoint-GUID: r2HkFnvshq4dFtHu-OxLp914XimHte7n
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_05,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150010
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D39FB140007
X-Rspam-User: 
X-Stat-Signature: uhtnkx5zairqb4hc494oh3xeyeaj5ean
X-HE-Tag: 1789433857-823609
X-HE-Meta: U2FsdGVkX19YvhJYlkcem5G/hmrswA15a5eVAsTOfn1/hFZn396FJNi3uKyPWk+hprQVL8R10emTQvWC4bfi8N6S0Z/5VJeIINEK89scEvjaZ1DzPdohVc6W6cJIMSd77EJ8A7WJkZYudMFviY5/oBGuNbA7DTXG1bGqSwdastcZkl/6CPA40MqvXCwI740XbCXQKtLKkQ2Ec2dupffzLJSCiLtS1DqeyzdaRwAr+HVTb48rfQBqFrDuu8mxID6msRCdZ2HaLxKZoSHV946uyxESWrIxA1td8c2tvaJe/WTxLvXcIMZHnIoYRl8+OMN+j7ZPwP7Ql7N69KAp34OBzXFh3fwUGJzxuWhCzfC7fcofJ5f8QaAhhqnqUt+Ys6+nr4mu5b+23RQgRV61Z0czASIUkgvFRele9QuCOUydLriW5YYdhUm1G69v1ELgI7UXW713P3CeXkBmRlBbPNNfRszVgDjBg+6bkVbNuHnKn7toL/nz6j444ge0l19/ZMA57acwBw6iJ1bpDU4IM+DkYbaCZA+HRCHpTFCgLGt1kT3TgnnC3bGW479Vr3WCfZ3ZKk0fIt9vjjzKj0lzxP71cxW9jHg2NIEJFiql0JJ1voeLQCLvd0WT0oDutwo/jC+6H1GvoAKp+Hg3QoAdoHoG29lGYJyehTXFYMVEcLtpA/BGFQDLs6CKIwf+Sb+YmFuywmyfsClvAZcyAEzBsKFlnBzDIoekskEvwYACgIF1TFMkYZJl/dFBhGdukMSugiC/Z129pxl0y2lyOlVmK58vBVm/sCIDlCkj59tqfwukNLMXbHYlA7OtOeSCOppbyOsux/Z6sKxCUgorlw+02j6Xu+IfoZmH88efkCfYbFPx70jeiJySIMHzmd8RFoPuTvtlL68I9fZGFS+1MiJhb5tHB7ziUi6M1QMR/v7jugr952CmtPCnrETpXmvRyPqRM0GlDaX49lVN3b/V3ZUd6y5
 tRIb2Y0e
 gpkilyxA6v10A0fjFq6bBrUsheHBaM4+gUr/iaKBUkyFbBnZCz++mVX4fqpNqydg7TaJSpTJ8y3uveDzLTetuCWBLxnVoZoh9sNdau2KuO9kLPP3Nd1upIvfmt3lVZ133tfbEa0LAcyD7zf8v6HiuogBsOKtEv8WkK7HOkpzouxrEYzTk6xJHY7NpIILvAinIvby5nBU6UVLxWWO+OIXR54AZZwASkk9kWzlQ6VwgQv8bSRXF5UkEMsjX5Jo1mS9U6qmrQ5iHMq27Bk4CGlltA9sBEgXD+pr25bucZmNyBKiLeJPGgc74TZDI9iYd7FdDbKMR/b/mSzAXTSm8xh/PK7mxP2GwrkCJkwtMSNUM/X+ZGzJeXPuYwXB0uyRtS0nuGbbY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 05:37:00PM -0700, Andrew Morton wrote:
> On Mon, 14 Sep 2026 18:49:38 -0500 Kyle Meyer <kyle.meyer@hpe.com> wrote:

[...]

> I'm hitting some rejects against
> https://lore.kernel.org/20260825085756.63030-4-husong@kylinos.cn . 
> Please update this against mm.git's mm-unstalbe branch or linux-next.

Sure, I'll send a v4.

> I'd updated v2's changelog with this:
> 
> 
> Tony said:
> 
> : Recap of original problem is that some BIOS keep track of error
> : threshold per-rank and use this GHES mechanism to report threshold
> : exceeded on the rank.
> : 
> : Systems that stay up a long time can accumulate enough soft errors to
> : trigger this threshold.  But the action of taking a page offline isn't
> : going to help.  For a 4K page this is merely annoying.  For 1G page it
> : can mess things up badly.
> : 
> : My original patch for this just skipped the GHES->offline process for
> : huge pages.  But I wasn't aware of the sysctl control.  That provides a
> : better solution.
> 
> Which is cumbersome but I think there's useful info here so please
> incorporate in some way.

OK, thank you.

> > Suggested-by: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> 
> v2 had
> 
> Reported-by: Shawn Fan <shawn.fan@intel.com>
> 
> which got lost.

checkpatch.pl complained about a missing "Closes: or Link:" and I don't have a
pointer to report, but I'll add that back to v4.

