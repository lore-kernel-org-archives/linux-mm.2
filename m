Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE29960A260F
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=WSYejO69;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=M6I9y08p
Received: by kanga.kvack.org (Postfix)
	id CA3886B00EF; Sun,  1 Nov 2026 13:58:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53B96B05B1; Sun,  1 Nov 2026 13:58:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BB76B05B2; Sun,  1 Nov 2026 13:58:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83F456B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:58:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BFEF160A6E
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:58:07 +0000 (UTC)
X-FDA: 85387460214.16.1B0FABB
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id CCC7A40003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:58:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=WSYejO69;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=M6I9y08p;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793559484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXYY2davx3hhXmREYRpR7y9c/hR6BJTh9T5lsz/xFXw=;
	b=Zag+5b2YkphGQWjJV2zsija4lUrsmmzxkB22ADnmPSwtLc2g1VQcuqS6VWpK1naY7p2z1P
	CJZxTL3woU+WIWIiCJiJaZuUagY4i8+9RCVygX401MfCEfp1i5ilSDJ5cBQcm14+PHZm0o
	FNdOs64iH+T6LAYGCrRLMHTC9/mf0uQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=WSYejO69;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=M6I9y08p;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793559484;
	b=TrRZigbPVzEGTLPthPPlaLsx7/wu18c4xJu9P9pm4cydScXzEl6X0c7f7hy8IJCfJZUXuh
	wuMALzKSyaXPKSieR463huhBdIpEzUwLSssF+WkissIzI5J09L567pKdpt5DGJ5q+pWL8x
	Rhli7bxk9hJWfsuRJcUcXx3lUQ9F9W0=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1DVakG751487
	for <linux-mm@kvack.org>; Sun, 1 Nov 2026 13:58:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=CXYY
	2davx3hhXmREYRpR7y9c/hR6BJTh9T5lsz/xFXw=; b=WSYejO69CfdNT81DJFNR
	cTmv2KRMB2Od6Hr6tPG8f678k8F9kgVny2jDKBb7rzPcX8OzDcQ+Q/nHuHfrLMBE
	Wuvye5NceqxWELSLKYTzrwKWhInhEq2ZXZiJjH7TiVJP+RrydeRait9QXjJrohcn
	IazreHB5Ht8aD5qiFeapcTqQhP211JwT3xRQ+WQkTye4Izdv+tuDejCl1m2eL13x
	+UV70Q0BlGM7Qt9pKdSq4W3CqfSrDl24yloIiDMU1BmVJG5/YcMYV/Xi5lp0QBRn
	4g5Tnui1BW2bPVelveiAE51q0wprWe7sX0wMBqJ6dvkasteXLlVlFjeLZWPU7bol
	tg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hnw6nu6ym-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 01 Nov 2026 13:58:02 -0500 (EST)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93cb98809caso394677385a.1
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 10:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793559481; x=1794164281; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CXYY2davx3hhXmREYRpR7y9c/hR6BJTh9T5lsz/xFXw=;
        b=M6I9y08pcgMplrxk9XoJcmva11cQav/hqYPD/cMeNIbT9spmala5sa5nYNASlyZRJv
         rvBdtZdwXTyEHxzKl+JxvbbCYX6rwhk71e3doNl4c2krnV0BRrEKnBpKfcnbNskcfCo9
         QMzRFB7fRnYUwnw+Org7bZnMBAxcXTT0w/oaCRcIBIj5WmZ8HQCRqzwKuZqoGchE0gX6
         SVOPf7zj6Gr8HUvMOUZY32nqWWNSmc5YrDN+kJlUiy1uqr0/ef65MQszI48E2R61AT2Z
         UZy9TxTFFOJJdK5bIy6yZwk5K7nP+mUQQmjhJuxADPYXRRxUsbdLV9SiKn1DUYAsv6A1
         +HnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793559481; x=1794164281;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CXYY2davx3hhXmREYRpR7y9c/hR6BJTh9T5lsz/xFXw=;
        b=fRY1fwa/3kfQaKPuMBMEglbauyzaI/FRiEf3Liez0+kA8K/fzeP3N/HJi+Z6u2MoFR
         5FllBb8bfM5fDaDd6r049XimVaz/Hh/1TxvYa1g3BqApy8cyBrrAVdGIi9WSB2a7uFiG
         E3vNqR88nXgphrgq0ncgVw9baAJELgNro3CnZDsFe/iAqchyI30Ed+39WkTH2BbfxoSl
         e1xfdc4bOQtmJ9+DuMeIjvEQ7oPtYFyIGAjPBQC6tDdIVHepYjqaXX+QY0YdMx6R+uq8
         edu0xFa84mhrDdGH7Ve3VsZi85ZlD33TA3Oi3F44B22re/uDKzGJdSf4nVWMfAZaX2LD
         rlUA==
X-Gm-Message-State: AFq9FYJguw1ozMjgjUtoHxo3of14J89CmooiNFHzfVaRKoDaahUyvro8
	/oSFS+oGsHankAGXsAd4sWSNFONZ5oXtGS568+fPlJVw/qzka/P3WYXmMmrmYATssCMzXbEOBQa
	I+woLnlCmyZgcB0brVnR3A9eRkQ/5aMLgkZtMESameFbnNSch
X-Gm-Gg: AYBFou2rlGph6VpftxOERMfOM71TSMbVzSELw/h2B96JgX1c7TTBJHqtDSySLXB5tRT
	qYm8Xd8PNCJ8YvOajkva2STekckLzXWH68W+I2okjatNQffNMdWAYXe3VL1IZ26cfqxMiqesHnP
	B8FU4neKWOOwgrSRZW9PcfFPMztQ1bVyx89FIBg3az6VOkIa5ZfnH8b3cpOIeRiu604REKRK2Gv
	NcWxXfYSKg8jkRF2ALfmUmsCtznCPXePccrlKCSMAfl4OhXkPQ6XIfO/xo5DULHdw6nn0jGZF+H
	bwWs4tqUODsZFCI1GPNTw/U+oZFGqMgh3ZMQuie3lz5Yizt1lBeCPiCn/DZdxhxwAORAMwCiHHt
	8wwxHYDMPhzUElkmg0QQF7fPElIcKoxQqiIhYd4JpXQegErCxCK6zfe81ukSqGVPyaIY8hPUU8w
	N2R1Lf4QzF0uqdOUxpFVh/9B0clOwhfNIGbBQ=
X-Received: by 2002:a05:620a:468a:b0:93c:8544:6ad8 with SMTP id af79cd13be357-94421747024mr1398577785a.28.1793559481394;
        Sun, 01 Nov 2026 10:58:01 -0800 (PST)
X-Received: by 2002:a05:620a:468a:b0:93c:8544:6ad8 with SMTP id af79cd13be357-94421747024mr1398575885a.28.1793559480868;
        Sun, 01 Nov 2026 10:58:00 -0800 (PST)
Received: from ?IPV6:2a00:a040:199:85d9:400f:a731:3a5c:25b9? ([2a00:a040:199:85d9:400f:a731:3a5c:25b9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf67aa704sm205875525e9.8.2026.11.01.10.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 10:57:59 -0800 (PST)
Message-ID: <b8847a58-1c43-46a8-823a-4ad7a14c8f93@columbia.edu>
Date: Sun, 1 Nov 2026 20:57:56 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi
 <nao.horiguchi@gmail.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Nico Pache <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>,
        Li Youhong <liyouhong@kylinos.cn>, stable@vger.kernel.org
References: <20261030-try_to_split_thp_page-v2-1-c957c9b42eab@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20261030-try_to_split_thp_page-v2-1-c957c9b42eab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfXyvMbQZPmEwP2
 Nq68M0EADHmAwVwdgV+DHaEmvLr2q4OaRyEllDdZGGh1cUWk2Mu/jczbB04OWjbv8MK7GaCrIkR
 Qm1ZMlcs6oIVlOd6S+/bQvwXIFJbo/XbCfDXrJCNs0neIJ9cr4y8
X-Proofpoint-GUID: zEZgdt8gkU2wlB0MPReEvvYQSJEnhFcZ
X-Authority-Analysis: v=2.4 cv=P8SvFSAu c=1 sm=1 tr=0 ts=6ae78bba cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=Byx-y9mGAAAA:8 a=Ikd4Dj_1AAAA:8 a=SRrdq9N9AAAA:8
 a=i0EeH86SAAAA:8 a=ZVJNLgniXcJRS-GVAekA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: zEZgdt8gkU2wlB0MPReEvvYQSJEnhFcZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA3NSBTYWx0ZWRfXz87ebiqTkdg5
 4/VpBFLoomBFrX+RZcJaejB2YGo6QIj933tA+o1Nl3UXwmeMHU/aP5EhB9JFgk+u1XMOhtLUljB
 byPejNRL7wJckB4AMfWtFsRiz+w1rwrkHNLKvqt2VPVg1NeD68t6F/9K0N/D2YelBxn7mG0wkis
 zg/viiqLG/dm9M9DCj5SgHS08kMeeniNAbuGbiNnLtrYUI2ZlnrzjXzUK81kAiszJc6yX2VYcW8
 NlsB0VnstGl+Ul2yxMdqpNX+bXKJC372i/G1jLzQ2upUSdAhD4JXTNjQe25fRV4yj5bhtlHwLx6
 kW01W6TW03cNfnF5GZB2ANHn+129w8SO0XLFHm+pWbJmhTVyLBGbP5RwsWraP9qZcyGqcjjWN9w
 GzN1rP/e6i+7cTQ8YHU/6FvAl4MS80Bo1yyTrZgGR/tgycFNzkBCmBQszfnRzyRj5zELv0B80Q4
 6g3cpOrLbjWMB4cZceg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11953
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=10 lowpriorityscore=10 bulkscore=10
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611010075
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCC7A40003
X-Stat-Signature: k7byugaobiaknrcx5wyhj3j3kdk5rm9w
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793559483-10660
X-HE-Meta: U2FsdGVkX19aJgnqFS88aG9VH8xCDsxJ89VkTP/9xkdf73BNVN/LoF7wp0pK1arKbjKjLz0ZR40ioQI186LF2tvR+nC2KlNuaTIu20n/HwCOTwwcyemdrx8wUStveBoLno4rq6EPqARmxwyR5Q3/EAMpTGSoC997vuoYBNYyETPorEfJDfINIYcDRB441ct9IU5O84ohiGjYNM+D6nQ28vdwdheO4l4GPU7y/YQtnq+JT4yFhgbec+qAb6+VHcgkDav0LsP5t2cFfjGYm4y91O2z7rZd9d9Mc34nAGJsp7O3sKX6mqEHpRp7Iif8Sx1zgb+FhqhuP7gzQWs1sVfbL1qBbFDa6xgIopeBOhlVInSQqL/gg2LeqI5uetq9tbOriytmc71lux3DTmC3JfLHNMeVoqCatI/pBkSweFMEWtKphxFyUwOrOszD+wpI484LoDGDobu16c3euKaunGX27GIhfCm9VBvs7O+jeZUJwOzB0ibShmX/UHF0SGFZOCrzX0Tsuit8zYKmHNy/80LeQ7UJYr84xbglwMVCMIHk7tTHGA2p8GELvPxCeWq6ZDzAzbSzo24B8C3htId3gEGR7Pk3pRXQ2bEI0tVjYIxTu9u05VrIOKnH1WMxqmkES2fdTKVdXjZNvWPJhdNv6bs5mBHpii3368Sc/P9xW3G8MxfYp7epqatKrlcENT4Iz37rU4jN4BeEZD+dW+/yuOnZjexULRqMQiMf6sOib535CDy5HBS+jOuHpquprK91BwZdpYQA3U41z80gJGs2+cX7pPn4+qiHjQoSRkivw1+8yPPsg6cz3OoaRA65EVQlSdeB/a9SfMc70oyYml7xJlqst2BI7hSBjPX2Cqqmtze1sHhcwZR2tZMyGXz08d7edoFlF8+5+3JRmUz8AqIvA+RQK9RK/rle4g3LE+8hch4zsYGgY0yFA8YDS4nPd/Euh5OSj6zrGh+tiQGQ+XG28k6
 PKumA7Ga
 sDWl965NAXX+H4Pea7teSw+dIoOoj9y38jwocZZfc5zr75WsWzmnC6Q4qE8eQgBLdx1LoxUve5//oLzMnOAcQKSukHRsSZsERVePU1Z/4fI2gJrsihTPdbzMxw4EsEDHvlWrhUE9SbVg+WdyEcz3pneVHFXqU2cY1JySDGaugaXI2x+oxVbEiVhg+iy8xYxVsRBKBYCuG9HM25eG/BIFf02NznBP9MJcFm3jBcS1VC5doYnUEJU3DFacmxeka5a0yYRcjv5BQHayJmYwp8XBJXbZJBoGNit6mmzm6l0mlGeCGLL3luVSt/Mh4cPOOumK5HGA9tlXxeQYtTKwkUGvMQdOeaM/5uBEMEWA813bHDl+XD8AQeWlgw2e2fBYeiPMqAesjyzr8AVfIRwAl5hUeCikEDaxq6o2JQfh3EIPCqgv21xVrUAv4LN71JZO6XltPHZEer32WXHatavHCkcVJoYhG1dGAKAm+uDKRjJOtJV5uPxi+tGxFp7qZjEzhP0Qn6XxkGwK3xmuoiZDbYt1x6RJaLlaYIjBa2Rn+LVBQaiOt7J9PMu1Ci2HLGKrU0QCqq9zWGxHOaPw8E67Y3GRkJZpYHireOBDdlkE6QE3q7uosXupZt8Gp0naVuxOVdSUL1B/8HFH8XWXCRDIgSkGQd2avOSFhR+6ljN9aoEGmfMXfOZDILdrfvDDEesQ/EuaFrrhwLyBI9AQX0BeB3klYIhJSCKdfu4kbooUrGtBBRKiHjkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 6:29 PM, David Hildenbrand (Arm) wrote:
> hwpoison code can end up calling min_order_for_split() without holding
> the folio lock. There isn't really something that would prevent
> concurrent folio split. Consequently folio->mapping can get set to
> NULL after checking for "!folio->mapping", and if the compiler
> reloads folio->mapping, mapping_min_folio_order() would try to
> dereference NULL.
> 
> While very unlikely to happen in practice, let's just enforce that
> min_order_for_split() is called with the folio lock held. We can
> significantly cleanup the calling hwpoison code, and just get rid
> of try_to_split_thp_page() to hold the folio lock for a bit longer.
> 
> Just work on folios now, which further cleans up the code. We just
> have to be careful about doing the page_folio() after splitting, which
> we have to do already either way. Do not change the way we split for
> now, this needs more thought and should be done separately.
> 
> Cleaning this up we fix another issue: in soft_offline_in_use_page(), we
> would currently have leaked a folio reference.
> 
> In min_order_for_split(), document and assert that we need the folio lock.
> Drop the questionable VM_BUG_ON_PAGE(!page_count(p), p) check entirely.
> 
> While updating the comment in soft_offline_in_use_page(), just drop the
> "NOTE" part that does not add any value to current code.
> 
> The folio->mapping problem was identified by Sashiko, and Li Youhong
> reported it by sending a proposal fix.
> 
> This likely does not really warrant CCing stable, but I expect little
> conflicts when doing the backport, so let's just CC stable because of
> the refcount leak.
> 
> Reported-by: Li Youhong <liyouhong@kylinos.cn>
> Closes: https://lore.kernel.org/r/20260804035828.2684059-1-dayou5941@163.com
> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

I managed to trigger a UAF via folio->mapping due to the race with truncation
that this patch fixes (KASAN output below). Soft offline is preempted inside
min_order_for_split() after it's loaded folio->mapping. The file is then
unlinked and closed, the inode is freed after an RCU grace period, and the
subsequent mapping->flags read hits the freed shmem inode.

As noted, the potential folio->mapping NULL dereference is dependent on
compiler codegen. x86 GCC and Clang only load folio->mapping once on the
versions I tested, so I couldn't trigger it.

The above UAF was very, very hard to trigger, but it's less theoretical
than the NULL deref issue, so I think the Cc: stable is justified :)

Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Tested-by: Tal Zussman <tz2294@columbia.edu>

KASAN splat:

BUG: KASAN: slab-use-after-free in min_order_for_split+0x78/0x80
Read of size 8 at addr ffff888114bce3d8 by task mfsplit/230

CPU: 0 UID: 0 PID: 230 Comm: mfsplit Not tainted 7.3.0-virtme #1 PREEMPT(lazy)
Call Trace:
 <TASK>
 dump_stack_lvl+0x66/0xa0
 print_report+0xd0/0x630
 kasan_report+0xe4/0x120
 min_order_for_split+0x78/0x80
 soft_offline_page+0x900/0xc70
 soft_offline_page_store+0xa0/0x100
 kernfs_fop_write_iter+0x2f5/0x4a0
 vfs_write+0x60f/0x1100
 __x64_sys_pwrite64+0x18a/0x1f0
 do_syscall_64+0xfa/0x5e0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Allocated by task 229:
 kmem_cache_alloc_lru_noprof+0x1e0/0x5b0
 shmem_alloc_inode+0x21/0x40
 alloc_inode+0x5f/0x1f0
 new_inode+0x18/0x180
 __shmem_get_inode+0x173/0xdf0
 shmem_mknod+0xcb/0x240
 lookup_open+0xbb7/0x1760
 path_openat+0xc8b/0x1dd0
 do_file_open+0x1d2/0x400
 do_sys_openat2+0x126/0x170
 __x64_sys_openat+0x122/0x1e0

Freed by task 231:
 kmem_cache_free+0x29c/0x610
 rcu_core+0x691/0x1de0
 handle_softirqs+0x204/0x8e0
 __irq_exit_rcu+0x153/0x1e0
 irq_exit_rcu+0xe/0x20
 sysvec_apic_timer_interrupt+0x3e/0x80

Last potentially related work creation:
 __call_rcu_common.constprop.0+0x80/0x270
 evict+0x4da/0x910
 dentry_kill+0x1f1/0xa90
 dput.part.0+0xa0/0x180
 __fput+0x42a/0xaa0
 fput_close_sync+0xe7/0x1a0
 __x64_sys_close+0x7d/0xd0

The buggy address belongs to the object at ffff888114bcdf80
 which belongs to the cache shmem_inode_cache of size 1400
The buggy address is located 1112 bytes inside of
 freed 1400-byte region [ffff888114bcdf80, ffff888114bce4f8)

