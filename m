Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF1A9606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=eyBQmLoc;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=sGTZsweM
Received: by kanga.kvack.org (Postfix)
	id BE93C6B05C1; Mon, 23 Nov 2026 00:46:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC08F6B05C4; Mon, 23 Nov 2026 00:46:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF886B05C6; Mon, 23 Nov 2026 00:46:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 731246B05C1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:46:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0C0CC065D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:46:22 +0000 (UTC)
X-FDA: 85465298604.18.4F79262
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id 210BF40006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:46:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=eyBQmLoc;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=sGTZsweM;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf27.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412780;
	b=V+lLM1uEwUTzpQr8Gd62r4RFvGyBFE4sgb28PbaeUG0xrY+GGh7PyW6XxiF+TlJKFKLWSl
	or6HshXYAbOwB5zkgyX9htqR0RDwyP99WXNg2FXlovgFUvNFugg08F5f3GpY+JbPwJ7IV+
	0ZcVWmkLDY9pVOwQxDx9tnSbTkSzRLo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDdOZbAef0VZJUq8GHeZZN1Befvz7h+o1H703vna+VE=;
	b=FdWmNuvHXvhTUaeEVfLSn1uDTh1QObFF8sWxjrrVeAmddsOneA+2t7xUr4h9vSMdNUF/yt
	QWpujWvg9T6XoQ8Fe6zbKhtEQaJGhHkZYN5FalRg92dRP9e8OO9A9niUUNKed9UsDPHBns
	HbVZ7jrGyMwIFZwY4SLtKG4PnQyWrN8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=eyBQmLoc;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=sGTZsweM;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf27.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AN4IPJm1900737
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:46:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=WDdO
	ZbAef0VZJUq8GHeZZN1Befvz7h+o1H703vna+VE=; b=eyBQmLocBEnxAn3RL7SN
	cxpvSnKSDfx4CShgBEFehjOQkpPAto2AqDp1fZc3OV6rEchZANMo3ed39PVKMCuQ
	rlIaSuz6+KHv2xwQSPeGMJCwwzyGmyteNde7PYNE4qOcfLkq8m7RQf4df9WqNU5S
	OGu4TKiVPPLMEYcukEciniTiC0A2W99NS0wwhyL6s/q9LBLCoFhEJDjH1OLYebJQ
	s40EfeUkrq4RYceMa4Sk+5kmmowqEer1xw2BkHWOB2dGL1BPh5AACK7oW06otfwy
	h7uu2lNzh6gdYQz1I/9lNZsD9mOjkRcIBpzSURKurTJk5wK2lumfS8J2jFrUz4nf
	0Q==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j4415anbj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:46:19 -0500 (EST)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-92125ff2d08so55111886d6.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795412778; x=1796017578; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WDdOZbAef0VZJUq8GHeZZN1Befvz7h+o1H703vna+VE=;
        b=sGTZsweM1gidT3A4Q/dm456CvtsGpeW7ks0EFwdMpgYPXmz622g6PKfSfIoPPmp8im
         s7gb1mqE4mGSu2NR5wLyNYuUVtqzX3VNN3nVXABpk1A+AABUyoyj12P8LvjWOhL+7VY3
         Tg3cgflVhreik/+dWj2uWhhFdNKE2RMOpIRZ+vAFv91XOUtbcMXMpgSrpYarfurW456U
         bxs0dW2qyhaDJionlM5TWSlXITwqHjFogfYYrMUINcgs2VeXrQNC+OtS4raVoVIvU9U7
         nU8VNRlJYu4mfp2ZIIhLxCjJ3Z2gI7mYvo79/4ncCDK3aVGs26Zf5mmh1FrOr5z5AuZY
         qOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795412778; x=1796017578;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WDdOZbAef0VZJUq8GHeZZN1Befvz7h+o1H703vna+VE=;
        b=ioxl1ZjZHjV7pQZhojGtGNodSjZegH8uFoUtgQTD3DPemskUVOEvt6EnieI6qKzA/Z
         arCVH8sfIvSPsDOpVSEPX8vqb9he733mAfHYtm6CAJI7NewHpZYsNBE64pslqwijiZ9x
         41xpDlY4G9ikWNeP8xLTH0lfElsX8Cpnu6EMEEexhLvbFntJPedDh5du0Epmm/dLrq6/
         TSDJaVoYepxPYaBUDOGJZo59unqsD/VSYFtMcH6qwFjMey2bPHvCS6DNV9C5oumwtTx9
         GT5xJaNRkYXmj4BE093441CV4+D8xgEM7ztkmEYa4uBR/YDp4iCI33D0gfdjqDAu+eMo
         zRQw==
X-Forwarded-Encrypted: i=1; AL+hErFHC16DLbIycNzpBBLt4eBC/XIUCcl4fl995Semw8jwA6gz4ds9hoM9FcbajqF8GMeg1ZPb60xgLA==@kvack.org
X-Gm-Message-State: APuU4Z/sExrBoQIDoFawGlVsazuZUB/iO859BnLUaQz3LeeQehFY0RSB
	JGP05JCykivyNeGqMyDTHsfeZOm1lFF49m3yiHErIZrOJZ0Ui03JVXFYdbxf/tBlAT4SRiufMJZ
	aVozFwWv2dQidT6MgE6b85YVVcEOy4FSQma9rG9IOPEKb2Zgl
X-Gm-Gg: AZFdTZcUyDjyQ9sCFtKEAKLN/dHSNJN8q3MhtblH0KcOY6AeNU2GAR6bcu7Whv/4sCl
	ON2ug0Vsn8IoZPh3QOn63hPHPeJW5DHgHTdfNE0pJn69CxC/GYm4p9Y20Zg9yD3aZU9628wB9Rp
	/zcSiQXY14flvLiwTI5IqdHKgn+TL7jtmADDptcsZ0+Ds9oom4Ret/5tYA4vrCEv/xUI0R97K0p
	qsKMPXvTgAtxJbdXFW3ywL8VSDuFsNJdSjDzLC1vOZQ6QHFJBO1Sj8sLO6CVtKpGicGIGFY1Pal
	fZ8NvddPOGx+1Y+XT1xP5Q2Q+Kh3Sjm1jrUZk7pWvHA/1oRSob4ReUDjkD9JhHhmf5pCT/JWJel
	USe9xpjJ8i58Gqt5h9y5KVYCYE1KeOgp41/z85VJxwWBTVXjsqXjaIfsK83NTXMOFBQVG3V9Wiq
	xEPL6OiwkmDPOy098Gsp6+xVOnYW4g9c2MPQMqIje/vP8YGOs6HzmoyTXpHPcgiE5pSFpd8sDqD
	1qA7p6Vm+cPtJfcJN77+IRWPu1LbcWmqdzt0lfKekxfRljsR9hbuDIq/KTovIrIA49+qOZnEaQG
	8hOQycshmocXutIa3DPfmtQ=
X-Received: by 2002:ad4:5dcc:0:b0:91e:76a7:187 with SMTP id 6a1803df08f44-92134a9e8bcmr183190076d6.43.1795412778497;
        Sun, 22 Nov 2026 21:46:18 -0800 (PST)
X-Received: by 2002:ad4:5dcc:0:b0:91e:76a7:187 with SMTP id 6a1803df08f44-92134a9e8bcmr183189906d6.43.1795412778183;
        Sun, 22 Nov 2026 21:46:18 -0800 (PST)
Received: from [192.168.0.76] (dyn-160-39-51-212.dyn.columbia.edu. [160.39.51.212])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a0a454sm95684796d6.35.2026.11.22.21.46.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 21:46:17 -0800 (PST)
Message-ID: <2e11ba52-b5c6-463e-a5ea-c165ba935704@columbia.edu>
Date: Mon, 23 Nov 2026 00:46:16 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory_hotplug: don't offline a hwpoisoned page
 still in the page cache
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Vlastimil Babka <vbabka@kernel.org>, Gregory Price <gourry@gourry.net>,
        linux-mm@kvack.org, linux-cxl@vger.kernel.org,
        linux-kernel@vger.kernel.org, tz2294@columbia.edu,
        stable@vger.kernel.org
References: <20261105-memhp-hwpoison-pagecache-v2-1-029d35634d42@columbia.edu>
 <d4812513-6cfb-4865-8636-b83dd92c23a0@kernel.org>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <d4812513-6cfb-4865-8636-b83dd92c23a0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDAyMiBTYWx0ZWRfX1AMn1os4mtfh
 8Big4Nob18Vd0IvhikpcbjwzlSFWc1ECQYb462juNQ4TQQcL3KD8XRJY3o0ud0XEoQGGjDATLyd
 lODWtRk6w/rlTysxWa/VdZI85COlIMoRevyusJQTS8LAhvt4eQLK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDAyMiBTYWx0ZWRfXwwfeOHlxCFAU
 pUuZTObjpstYhRUQ4mFq9eooDH8TulB+1pXrj9dXIDTSwEBGWdZsyN/zRLUVCD7JG7cHnnOLgbM
 1R2H+JoBtUPAvy6Rqzm2A9S02aiZWz7KiyMPxDm/ub5OBxOEohtUIraFNJ5v9X2NkRC7BN51Uwq
 u5A0o07KhzfF5t+5Qr+dtgx8GhazyVd0BOg90hCo7W5bT4JWY6/kmlBN6wgX/q/rpVDDQEfAmMB
 +5ih+nFe66Lpgoj+vYDUsK7vTjd9ZaTV6qn7S9PztIZEUmvCL7rYOPDGA9vmkp2BIcgLaHfV1FP
 JATrN+K5oINezJSboJT9y1odoB1WCU7WaJFq39HCBlk+gTnvgxVc4iDJHwNP6vB/3+mOYxmnrZu
 uRZW215vL/9wCwttCBu9VtQ88VyuCZI42BoivXI6eDvQEK1xDM21xAMyTS5AFND+gdMvF3e7fxA
 lanrG03w8VLCVsBxnLQ==
X-Proofpoint-GUID: ZC62u6IRb2D6aNRmdEJNp0l8kJLRc767
X-Authority-Analysis: v=2.4 cv=cP91IVeN c=1 sm=1 tr=0 ts=6b03d32b cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=l9izRfKDRJJ6Wn/vzKnQSA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=CtMvlx9HVXp8zQbR6KoA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-ORIG-GUID: ZC62u6IRb2D6aNRmdEJNp0l8kJLRc767
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11974
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0 lowpriorityscore=10
 bulkscore=10 malwarescore=0 adultscore=0 priorityscore=1501 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611230022
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 210BF40006
X-Stat-Signature: 3gy3gtoqe1pgbnnc4ohmq73pdi453ehg
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795412779-953158
X-HE-Meta: U2FsdGVkX1/U85HvfYro35I/j1TPUTTMaeel9u+ZpFwMFq4RMl5mZHpoItHzaQsnVcDijdOq6GTjvlgQjiPEXeSGWzW+9Lf8Hqp1mdkyBTG4r8DNf2QimDkw/OOnzm2iwtkpvLWj8X2mODbR3fR772SKY+23z3Wkqe6VAboX+ROZ7DcYeZ+k+aG03+FdWh5TCiwr0N3bAcbXr8NMG0hJS9wvD1xsBm7UKJNvrw5fz3l+fJlZJ9keAwH2uPqEegOe9RGkCFeHRuA2MlQwyZd1MgtwUHSY7Lsnd/sKUCl93zaRm+UL5EvQfwN+xXxNG3h0kaEE5MJccklxThSKQ0uI6oXnnY4iQ3jzSk1iBxOcMtKeSHyGHToaR6BKfRty4eyiylGbaP0BGbW3kwi2p4ZQKFs9uWt2hvktr5nv7yuw7iHwVDqOV6D0MCEDzEd4NwvHPQpwz+OsERXa2sAu3yh2hsraGidfLME7gY4uL8EaVdST9O72Y/3fj+EXVhvynTsmwomNF6vrAZQ4oN67a9sAdYGID/nDUidoiO+MeSII7aA/kHs9u/V99svqVGqkTcxa5qDPfz0nFtCCw4kp8cqoWMBzI4MtmsJtv3/Rr3xYEQaoBZW4+jPQHL2t6xuKV7mdBjL0MZRhw3IhykyLJSUvrtNXx2HEra7kQlhmyoYI9FnJ/AVfWC57FTFV+SD+XabHUiLsej+zcaQ1gUcS7g1PzHiCWJRBnAFoes381uH1ZFbePFQAUVdmGQbvVV8klGnM1bjHwEDzLG8v7QUHyDOHyZ/qU3yY2z4RUZgGBqIBNs+MqZU+OGtFuQHPx9/lIZGfEe/peR/wvjG9pbY1x7sXsAEY6DHhBp+qbqBHSQrjy6ngdB0m+N997XVnQOB0XewErEHVabCyw4gguqIUc2EW2RQ2BJF3llsDywszw+ut/0+Oj5He3pTRIngRfW6std2W+hvoiGac3FNZ6m6o2l2
 /oAPSi93
 XXv+iqbrxCTjMfg1FymIz65uXuv7DTL9Smqhf80GMMhfgHKI5vHdiAL+wBiSf1Pgsukvj2hpeHkSfXTe/++wnhFTvrSVqbQ/3XI929RqpKdWNCTeGuVnAZiVhgRM0krHN79FF/E6VGA/ZAw91MBX28K4jdrgstWvmiMkkM1WBOGPcbPE/NaOYGFLRozrhc9OjKMcbRTPhJX1bCYbIBRtWTTEKv11pJp4gRg84MsQR4PuFZW2ZGmhX7wEpyz5wsQ8fBj7x4eIwFAQw9Xi3EC9Fpa0BV1mqkjie9i+ADBkcihD6xpxAYNTR6rTk6nMB12JwYXgJ0aT+A22rKnvgioaqwd2/tUtitH/+7dfxB6NdLIoa4xSVB/4wWmOoMsy/RloqrFeV5ug3UBB5rjiZQt5EZ+3D7wvrpWV0FmZIaPBsOQ8w6VFK/IPJBlyX9KwhuZZeWExkNCFekhITryYOhEDwdgBffZR2R9WJP8wSBEgxFcvuW0shWcY1f9+GSUAzTd/15VKdk/LyNf00b7jOkevdXwMavFF5/XdDS7e10LsQ0wxQFedeCzU63/eHnIBAX0uk32oPwCEAbN9lph45EW3LkbH0UBY/2iUdFA9RGngvRFrZC8oIdPIuioVUw8rqkGOlbSoeB6apRcXLk3Z7Ayh2DD56hnUsLddltIcuO0WgX+gyjjJYDXVQx1bAdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 3:58 PM, David Hildenbrand (Arm) wrote:
> I didn't understand why just checking for the refcount is not sufficient. Can
> you elaborate once more (and please not send a new revision before the
> discussion is over).
> 
> Memory poisoning must grab a reference when setting the folio hwpoison. Any
> other reference (pin, pagecache, swapcache, mapping) keeps it alive.
> 
> Why can't we build on and?


Right, but memory_failure() doesn't always hold that reference. It i)
sets the flag before get_hwpoison_page() grabs it, which waits on
pcp_batch_high_lock that offline_pages() holds, and ii) gives up with 
the flag set and no reference when get_hwpoison_page() fails (e.g.,
a pagecache folio briefly off the LRU). In both cases the pagecache
holds the only reference, so offline can't tell it apart from a
page memory_failure() already handled.

So I think if we move zone_pcp_disable() in memory_failure() before
setting the flag and keep the reference when it gives up, offline could
simply treat any poisoned page with refcount > 1 as busy. That'd cover
pins too. What do you think?

Mani


