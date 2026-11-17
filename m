Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91877606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 17:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=KiPNgY+X;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dtMdYCsQ
Received: by kanga.kvack.org (Postfix)
	id 93DBA6B00EF; Tue, 17 Nov 2026 12:59:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EEC86B05B0; Tue, 17 Nov 2026 12:59:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7AF6B05B2; Tue, 17 Nov 2026 12:59:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 514B56B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:59:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B26A81A0547
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:59:24 +0000 (UTC)
X-FDA: 85445373048.19.12D1FC3
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 43DEE140002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:59:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=KiPNgY+X;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=dtMdYCsQ;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com;
	spf=pass (imf23.hostedemail.com: domain of ze.huang@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ze.huang@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794938362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hdpv+Cv7ZBNO9I+6HoT8nAyHfxPrhmzzO1euuczH44Q=;
	b=DRr2lIJRd5YjMfE/J01KvfbdkgdSrTP7beI9lZyl+38NLnf0yM3NNV890mZ4DNvxtmSaU6
	eyl/gxrCeepFgaMf+7iqN+8Ncce/YXAcdkJE118yu+W0wUm5kIyNRhxa82PH/2WH9NLa1C
	MMsHyWb8C1KHhceWWV3EbWdtqXVNkDw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=KiPNgY+X;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=dtMdYCsQ;
	dmarc=pass (policy=none) header.from=oss.qualcomm.com;
	spf=pass (imf23.hostedemail.com: domain of ze.huang@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=ze.huang@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794938362;
	b=b+DsbHdKk9mPRdFMCHO/x929jr4buYuY2PZsDP/S4/9Br47lPTkIE95tlVPxFJZDKeAIG3
	6TDLAPf378pml6u8CMoklV24pDg1n8eTx0JsVrZ0edPqbzjmKCJnRcBazhSW5Qby1ksEMP
	FPC4s4hZPw6pYLnx4AuRWwnIdmKFDuM=
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHFQgdG995151
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hdpv+Cv7ZBNO9I+6HoT8nAyHfxPrhmzzO1euuczH44Q=; b=KiPNgY+Xq9K21SfG
	3fEjB3drWi6zzyoIewogFQngiovoqU1eAPHtWcBNUcIOI1CJxijS+OqteJSXGH4X
	7Ol9r37XWjuXJJOBklZdN0Rpq3TR0W3GUwZuj6pCyq6uzPNYQ5j1NsCkxRIiJGVp
	fd56/G/DzgaT+NMgxUyrJgCZFskprYRmn4V/GgJYS96FkA3jLw0/KtDOsq1bcdgV
	F+fIfcKAniBqrtp47eWpCcmPa35HQHbMb0mk5f1YedxGzJFM251S9009BWSkuznY
	ZfrBueT9A4ZsJF6guzd+FcsEuXInbXHfYLdQ9V8/K3pqVVWlYKX5hirQ2KgrWuN6
	tpY0hA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j0hkd2vhc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:59:20 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-370230d93efso422038eec.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794938359; x=1795543159; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hdpv+Cv7ZBNO9I+6HoT8nAyHfxPrhmzzO1euuczH44Q=;
        b=dtMdYCsQG/CtKGjCu09DQhDh94KJHPTLSZD0wS04CEJ5e9ghT5+ReX1G+e9o9g2ttr
         WAHpHSXPpvZ5H40sZJS9Qpi2vmHu+eptRm63Ps52WiOpvgCVKS5/IgW7F1rytotW/a/c
         Hg4VCzvxSUB0dyrVXs42kw+hUr88lxSvp5OoZj6JktMChssTiZBb/EBJRTF2hrNM9085
         QzhKBujAWc8AsR4CRfgzq4ysKMjF6fGVepMFmP1pkO03K2ueA7nqp3TjrcQeh3at3vnu
         v/T7avBAelfObNctNZqSjOHEOTMx7TPWKH4f5Z8W8HrlaS8iBcIBAvAIcge9zKEij2qa
         GsSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794938359; x=1795543159;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hdpv+Cv7ZBNO9I+6HoT8nAyHfxPrhmzzO1euuczH44Q=;
        b=Tz8XlF7MUTtMBrdmuYP1/MwRjPaPkRbcsrqr6FQCEvc6dC2O++N8eT8KmSOaAOJnp+
         93KfvTLej02mjIoA3wBpUM0xpfY9LBz/lOlxWpRTEtQeOqEXxY6voOZQHBRzXkyUYuS0
         ONhQmnsdubo2fSm1eLtIKsCkv/yQRHfFYWDRLiDxPCBaZD51+nnEii8jKLf7tzySIpSw
         DrHlltsyvADhXzk/iyo00BGddxcI3gMFVP/3pUYlY+OSyzTuFoMr6+WFb4kqqPMEf8o+
         /Y8y6giP1v2YbRse+6MU88cVycogimAg4AI/+eW49zUAAphH4WH+5adNmDoUOolpZS3X
         Zanw==
X-Forwarded-Encrypted: i=1; AL+hErHNR9slg5cowwSQLcpKSZfHXu3weAF403LMNNqScqiyoJmG3yuO/z5j5LPO70sDzHvxlo0iGCZA+A==@kvack.org
X-Gm-Message-State: APuU4Z8dT7NKL3A2gZydajdTSyiEOFlVhM5UX5jvqv22+dL0YocKWnQL
	3pmPn64oDv8CgebJ6ME4TkgNKHFukwnn852PmxLV5YO6Gac2vpdv8PsoQcLCg+dn46AdBcyxuml
	CtErjoT/65ySICvJwpL2baBZcvf9pjotaD23Ru1o8iVKcM0v6zJpMrQ==
X-Gm-Gg: AZFdTZe8/TSltHwcqcVnKHs6gNTdTolZfNAmUjLf/fbPjpVl5ZbVtYMziKi6TW6jONz
	5hJlPYbsqulfZq501NdAgmcwPTYomyq3rvziDUzQ4Pr9FoJ/GA4Z+gl3R+XtpdPLZoakCiFGrXx
	6DUsu/siZW/MFRpYvbkp8i5hGnu63MqkWXQVQqDt9wrEL+2Q4dc9nL+a+hySsO5GAcb70K2GwIU
	x/A9Zv2mErBuF6XQY0L4GMxyRfzDWtqt9o/jmBnxmHIQZ0qSb+kcQ/82yewcXtZ2H/10LyRU4b8
	FK3U7p+0jImStYuNsdTz0gr/zDFkO3JkswFLJaYO2JVZuJaHa/oPzyF7OfuzM6btaNddQ/YQBvx
	ILc8zwDH7Uy6ANngTiozRNtWsdEzRQL64z5e5yBOwS4NfgHDN+IH7tg==
X-Received: by 2002:a05:7300:ce93:b0:36a:1709:458 with SMTP id 5a478bee46e88-38280e29b80mr154459eec.27.1794938359104;
        Tue, 17 Nov 2026 09:59:19 -0800 (PST)
X-Received: by 2002:a05:7300:ce93:b0:36a:1709:458 with SMTP id 5a478bee46e88-38280e29b80mr154424eec.27.1794938358353;
        Tue, 17 Nov 2026 09:59:18 -0800 (PST)
Received: from localhost ([188.253.117.185])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795533170csm45168429eec.7.2026.11.17.09.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 09:59:17 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Nov 2026 01:59:01 +0800
Message-Id: <DMXOJEFHNR8A.SHYBI0NLEFPJ@oss.qualcomm.com>
Subject: Re: [PATCH v2] riscv: mm: Skip the icache flush for special PTEs
From: "Ze Huang" <ze.huang@oss.qualcomm.com>
To: "Nickolai Zeldovich" <nickolai@csail.mit.edu>,
        "Paul Walmsley"
 <pjw@kernel.org>,
        "Palmer Dabbelt" <palmer@dabbelt.com>,
        "Albert Ou"
 <aou@eecs.berkeley.edu>
Cc: "Alexandre Ghiti" <alex@ghiti.fr>, "Andrew Waterman"
 <andrew@sifive.com>,
        "Jisheng Zhang" <jszhang@kernel.org>,
        "Karl
 Mehltretter" <kmehltretter@gmail.com>,
        <linux-riscv@lists.infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <owner-linux-mm@kvack.org>
X-Mailer: aerc 0.22.0.r39.g5d778487
References: <20261116022433.49952-1-nickolai@csail.mit.edu>
In-Reply-To: <20261116022433.49952-1-nickolai@csail.mit.edu>
X-Authority-Analysis: v=2.4 cv=eqFKXYpX c=1 sm=1 tr=0 ts=6afc95f8 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=RQ3dwY0XcLBFaqRX7rIGyg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=Bcon8dCWmj9BmVmNv9cA:9
 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA3MSBTYWx0ZWRfX3Jf0UX1BOHxR
 +l0H5YFW/jPl7on453yAYBWh0tzLBM02FjAJxDRcyA1kR2iHxGqb7QYn985JbJ0HdKrxo8j4sq8
 BU2iAgSzXAPiw9PP7Mn9LzjXdCGxPZs=
X-Proofpoint-GUID: 5lvLQ9ONxhQ7QjJ4lo8-k46mejhEpZ4z
X-Proofpoint-ORIG-GUID: 5lvLQ9ONxhQ7QjJ4lo8-k46mejhEpZ4z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA3MSBTYWx0ZWRfX56sKW0lKj0HU
 GNM5zYOQ4ocUyF8cH3KZf3pJWdobQIy2mkbuZwcmIUxbj1FS+YeYQSO8YQIIdX8XS+Wx1BqqRei
 1/oi5ZxKNryy/dQEtiNkSwuehwG0DX4sDcA0hjbQgEqZwyj8KmEEy3zIegf2Yi6OiCrH6ETwmNO
 UtfhpL/s0SYtxjcox4gR//iZdLkepdkMeoHKdMuxtmgrExEvn2BqvYRviCD/1VC3dZdnWX/w08o
 Y0pF8uywEI0U7bBV0+zMz37sMJyidHafQZqm/d3oKEwG9fD5viQo2sQ0OR9rg3L5RbgKmGJy7Ub
 LhGkeY5buo1YPOv8edXcLmpbfrxTHSwHHfL5l8TfeTLJU17AkQMpAlgwGskhfUdTvxw3gHSTEj1
 omW2yiJbfTEsFONeN3wciubl2cBU0BV36F24AB2TInjDrvPjpAKezDKrnPqbAAdPwg3nJc8bVo1
 PLSuoiVoIG7CaAvKJsw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_03,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611170071
X-Rspamd-Queue-Id: 43DEE140002
X-Rspam-User: 
X-Stat-Signature: r7ux4k3rdzb6h1td9a5ecrhx78bjqpj4
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794938362-333206
X-HE-Meta: U2FsdGVkX18MJn3qKtil60+uOOTknktfV4cNiod591l1A/I8GMSLGO6ESzvqOyKa7Sm3XQ9bwTxTj/CPjbbWvLRY9qm0ElDW8IRJD6z/an9PFRKyXYmynDo2kyUTipyjS06ZX0aNeZdY4e93vwxU8uFUN3Jac9sErsvgNKZt/dbpwgbTjlQsyaPCH6RzsUjYJjMDJWi1Q35WctKq1xlZACsxaOA/MlCI9ctoUgijNEi7TClAVLlMgckD98WFLfo59z1fZIrAO79buI4KVxZUeOK1QFfK+LKkqVUcVT1zrX6HSQPGrZ+TSf7TOnVEi9zZlkAMTkKfp3XO7kClHatAmsg87y6CTYM6xD6R+P55EPLMFYunwXZPA0X5E7cr39Pp5jkl4/WIBcVL9UczoPW+QZn5yfeecwDZMXKCnmpd/eigOednrjP4+4+Yrloks8anG/RGy7plK7ZjA3KkW34O6+JAhm1Fk9o1vLYvaiCVYfPnVvhtULKGEMSxMBcjgc62VAQQwnujnEq39Jk4a5KtKXaZlLj7t+xeawGYkuVx6fTklhEfvZAQhLrzxLiWi39PSZGcu2sfrMCxwyBQpRJ1qQQeliN2nV/kCCufQ5/tcycl1s/T6dBxkfj9ODd+5Sg0+xfvbh4niJP74pPF4UCbVR6WypycrrG78eaz1CtGQKRATQwe67NcAs71/KsorZEu5xMO8cx/oi6E1yYQPpweRlRAUpSeQGdvkV8AbjgpFRhp6Hf2BU95lHbopHftmbvngOXqgM9iJ79tpwLd8JGh9HCVAFQ8Yvlw1+YQbg1ABNjOpRIFzyujczGpOZ+X7sKKIRM629pOPpf58R2F8an799zm0MgaPQpY+clfolGcamD4HFBJwJibHL/ziWTiop01RcS0Uo/mKhBMPftUQMWDC6wl3JxrX6z+fJxKkMglLG1cAmj0gDT7/G1EojDhTlsJJoDFIbqzCT0G0Qk4qqr
 z1ojLRqc
 sfaodA7vIJdi/qd3O1rursjJgaNvEn5nXUXEFHtLM6MCey+V5BlhIEerIjMbqOuGAtWFa9jYiPVIAim7mXYfwwESls9NUBDwZQTi3pvam/koOTQlvCOlYic2nd+bCAoAdvMnu41R3ctxqy1neLL7q/f4UGQ6cU4BXGRB8ZtbtWMP9YLNJK9zR8F0decXmQky4cI92vGweHf53/uk+6w9yHZlWN6EZc5ywS7a75JgLQ8aCj0nElA8o/BsQDptU+e+w/nm8VXNqpYmyhdeu4kkEXwTysRg0jJwndjeMYM0/fN1PGUQYfHuRU52wZfQJh83TnZbG4dJIyGAIe+tuIX7x5hWusduiysN+H/SgAnpAXUYNR/cT537PGiFFO+N3DiWjL7czge5VyFKCR4BX26wZ97TDrr94JydpkckIkIptLYesntkCKNJyQFPD5OHpsvtSh3YUTw/oDE9T3hE6cPU57MpbWSaULS9BURJXCgoEWvUrpGJjT7/l/9HcQkevNbg9furLHdHeBjx4rp9QLuO5m7rB6axAfghr1ID2cfRHq19odK6NVDiJU3xZqSY5dqIMQ8Xz2sV7NZePOAo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 16, 2026 at 10:24 AM CST, Nickolai Zeldovich wrote:
> An executable mmap() of memory outside RAM through remap_pfn_range() or
> vmf_insert_pfn(), such as /dev/mem or a PCI BAR's sysfs resource file,
> oopses in flush_icache_pte() with the page table lock held, and the task
> never exits. With FLATMEM the kernel instead sets a bit in whatever
> memory lies past mem_map.
>
> __set_pte_at() calls flush_icache_pte() for every present executable
> PTE, and flush_icache_pte() records the flush in the folio of
> pte_page(). A special PTE may have no struct page behind it.
>
> Skip the flush for special PTEs, as arm64 does since
> commit 71fdb6bf61bf ("arm64: Do not synchronise I and D caches for
> special ptes").
>
> Reproduced on QEMU virt with the riscv64 defconfig by mapping the PCIe
> ECAM window from /dev/mem with PROT_EXEC; the patched kernel maps it.

Tested on a SpacemiT K3 with v7.4-rc3.

mmap() of the pinctrl@d401e000 MMIO window from /dev/mem with
PROT_READ|PROT_EXEC oopses in flush_icache_pte() without the patch and
suceeds with it. PROT_READ-only mappings and anonymous executable pages
are unaffected.

Tested-by: Ze Huang <ze.huang@oss.qualcomm.com>

>
> Fixes: 08f051eda33b ("RISC-V: Flush I$ when making a dirty page executabl=
e")
> Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
> Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> ---
>
> Notes:
>     Changes in v2:
>     - Reworded the source comment as suggested by Jisheng Zhang.
>     - Shortened the commit message.
>     - Rebased on v7.4-rc3.
>    =20
>     v1: https://lore.kernel.org/all/20261017013634.792220-1-nickolai@csai=
l.mit.edu/
>    =20
>     This patch was prepared with the help of an AI coding assistant.
>    =20
>     Reproducer (QEMU virt, riscv64 defconfig, run as /init with /dev/mem
>     c 1 1 in the initramfs; 0x30000000 is the PCIe ECAM window, any non-R=
AM
>     range does):
>    =20
>       riscv64-linux-gnu-gcc -O2 -static -o test exec_mmio_mmap.c
>       qemu-system-riscv64 -M virt -cpu max -smp 2 -m 1G -nographic \
>           -kernel Image -initrd initramfs.cpio -append "console=3DttyS0 r=
dinit=3D/init"
>    =20
>       unpatched: Unable to handle kernel paging request at virtual addres=
s
>                  ff1c000000c00008, epc : flush_icache_pte+0x5c/0xa2,
>                  ra : do_remap_pfn_range+0x284/0x3e6; the task never exit=
s
>       patched:   mapped at 0x7fff8418b000, first word 0x00081b36
>    =20
>       #include <fcntl.h>
>       #include <stdint.h>
>       #include <stdio.h>
>       #include <stdlib.h>
>       #include <sys/mman.h>
>       #include <unistd.h>
>    =20
>       int main(int argc, char **argv)
>       {
>       	unsigned long phys =3D argc > 1 ? strtoul(argv[1], NULL, 0) : 0x30=
000000UL;
>       	volatile uint32_t *p;
>       	int fd;
>    =20
>       	fd =3D open("/dev/mem", O_RDONLY | O_SYNC);
>       	if (fd < 0) {
>       		perror("open /dev/mem");
>       		return 2;
>       	}
>       	printf("mmap(/dev/mem, phys 0x%lx, PROT_READ|PROT_EXEC, MAP_SHARED=
)\n", phys);
>       	fflush(stdout);
>       	p =3D mmap(NULL, 4096, PROT_READ | PROT_EXEC, MAP_SHARED, fd, phys=
);
>       	if (p =3D=3D MAP_FAILED) {
>       		perror("mmap");
>       		return 2;
>       	}
>       	printf("mapped at %p, first word 0x%08x\n", p, p[0]);
>       	return 0;
>       }
>
>  arch/riscv/include/asm/pgtable.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pg=
table.h
> index 2ebd5fa5adc5..48eeeac1019b 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -624,7 +624,11 @@ void flush_icache_pte(struct mm_struct *mm, pte_t pt=
e);
> =20
>  static inline void __set_pte_at(struct mm_struct *mm, pte_t *ptep, pte_t=
 pteval)
>  {
> -	if (pte_present(pteval) && pte_exec(pteval))
> +	/*
> +	 * Special PTE mappings are not intended to be executable and may not
> +	 * even have an associated struct page.
> +	 */
> +	if (pte_present(pteval) && pte_exec(pteval) && !pte_special(pteval))
>  		flush_icache_pte(mm, pteval);
> =20
>  	set_pte(ptep, pteval);
>
> base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3



