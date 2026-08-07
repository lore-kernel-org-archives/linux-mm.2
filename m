Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62927C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 19:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737BE6B008C; Fri,  7 Aug 2026 15:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA076B0092; Fri,  7 Aug 2026 15:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9196B0093; Fri,  7 Aug 2026 15:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31AC96B008C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:27:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB00D1401AA
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:27:20 +0000 (UTC)
X-FDA: 85075457040.20.3B4F480
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 87908100014
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:27:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VIx7pPXe;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786130838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+D6EJxpOusMJIngkH9gqN2jeKN0j1wGUyv/qwF+lbU=;
	b=PquMLaYgr2Epbn/w+boAHZD8rz1dOEt90JcVpY6s4YQPmdP/XCHK0G6aTFKI/pZ2n8QzAk
	dO4zO40SvvJSuXnP54s8IrJdxZsnFnsHIjj2a0Slehs4JaFiOeQ73FBZ6MCmWfUjf1nC3D
	5SeY9FAA2UHSjrmS3Gu7XpFwmBF8qvw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786130838;
	b=QSJT4hp/qbsp4hsXiOfmQGW54+n1SoXruczt2gf2zYDkRqQtNTuf+pJz4G0rrObq6rI3jN
	tzaH4dL7yLM2EnEgbhlICY+mGJo+w5beiQCRFOufc2kOBQWF8KPGNy32saLrHLhHXLLMYE
	tFxBPvu3Rw3WKwQ2ZxZApHcJ3gcjVOA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VIx7pPXe;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677JMpwC1808077
	for <linux-mm@kvack.org>; Fri, 7 Aug 2026 15:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Y+D6
	EJxpOusMJIngkH9gqN2jeKN0j1wGUyv/qwF+lbU=; b=VIx7pPXeJAufDHCL9g7e
	rhYgt2rXZlkq0bpH8mqE/EG/H7Ii4ML1gqLC2GNsKmfs8xD4wQXwIVWf/GQRKRDv
	zAJHtydPZ02MtzsWe1vlMSe/ov7GCq6GlGmh1A2K7Oo2CgDqgj/cUCgYPWJeYKW/
	vAc3Qqzbf4sYN1vVZZuZnAPhjv8Y5acgYUDRvlYkz0BZwDZf17vTOLO7G61wDYB8
	YyKlYatP311FWSzQUhBm9TGIs828Iy+89IOQaKxuPALUPtSsWUPSZPJU9rnlFmk8
	KjcnMvLuqXFVdWrrxmJFF/mTLgqlHUi/9Q2Lc3Knys4khnKzdNxvl6986l4JLkSu
	Ig==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fwh9223t6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 07 Aug 2026 15:27:16 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51bec738909so37907431cf.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 12:27:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786130835; x=1786735635;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y+D6EJxpOusMJIngkH9gqN2jeKN0j1wGUyv/qwF+lbU=;
        b=mHYz7OIasQ8LJkZCTRIbE1Z0ePQIUhqIJ3bhiRroJq0UNHzVqPMaQGZ/HLBlLbSyVT
         TJ/97X4j7muXHbooutCtntampT4sw4MuL+eNg6NJzwfIeP+ea61g4xeSG9oYHvUdT6h9
         kwYJ2m3nuXiLLrqQDUajFn8MNNiyKUhCuRWGdFYlQw92QNuIexBUHuGQ4ywqqhAioxx8
         jcIa0YC11+vOSg5zH06EDun6sKTjwFAgufnFfzu3duy1mBv3GXPm8sAs9yC2WJgImrdN
         sNjOdQ1pe3d1rtxQfm9kF2a+HnIcv1BDFPQDtS9THgcZeoD9Eug/lKwQcbQ0DtPXYDkx
         wVYg==
X-Forwarded-Encrypted: i=1; AHgh+RoFcvJl946HFjf3zPtZbrEiNRo0OsbzdLasAUPs7c3KbR0hz957qO0hg8AWHCoDmQxdToiYl30Xfg==@kvack.org
X-Gm-Message-State: AOJu0Yz/SCiXM51ZxwD30qMKkkQu4EkHioBOokxrKv/PGrCMUyLGm4Er
	a+8V/fuQDaMs5PmZA56EkbFdISS57o0Xe4b5vpRH4nNHD9/pJGKi0ORDn/kR8XByBTJaF+2gtgZ
	8nS2s0x0w5zdLRNUwhBcSwbanLW/flt/GVRChIiyXMmR1Ond3
X-Gm-Gg: AR+sD11gbVuxli5DbZNJd6EBA4JQjJKXwJyjXhu2TMcQWDay3GCKhxzaUldCLwpzV4n
	d6fsQ29xEMx+VcTM80JyjJexv+poVwrcY3dFH+PG67TNKilIOpP1kuS8N8gUiLc0bMnA6ymqgg6
	gNBzu93GJ6OJ34QnN6q14ACnLH70gdhGr+88TbhUPB/8GCcHN+dzbzKgALxcFL/oS2erAJwTJFo
	EAJxs03UnesNA4hLVfFsExgFYQcCx8JBkmOSiESDunqfIpd8R7unqHiynppmvkpuqbWWEpfFpkb
	vdXBY9nMrBd3wNF7Rl/nivpwX9LTzEafs6W4DjUyEbU1JdspT9CZLrK+/ZVK9lY0YrlPdDib5Mf
	vIMBM/M6pprNdPj/KbgY8ChCh8e8zcb/Bl4yp+VzACNZrUnPufG/j7eaBjO/X19si
X-Received: by 2002:a05:622a:14e:b0:51b:fde4:cd4f with SMTP id d75a77b69052e-52ce6183c7emr264779571cf.30.1786130835396;
        Fri, 07 Aug 2026 12:27:15 -0700 (PDT)
X-Received: by 2002:a05:622a:14e:b0:51b:fde4:cd4f with SMTP id d75a77b69052e-52ce6183c7emr264778931cf.30.1786130834911;
        Fri, 07 Aug 2026 12:27:14 -0700 (PDT)
Received: from ?IPV6:2a00:a040:199:782e:ad40:551f:594a:fcd1? ([2a00:a040:199:782e:ad40:551f:594a:fcd1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145a2bsm8291357f8f.4.2026.08.07.12.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 12:27:14 -0700 (PDT)
Message-ID: <1b688500-230a-4733-99da-bdd8adc9f67b@columbia.edu>
Date: Fri, 7 Aug 2026 22:27:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] mm: remove PageReclaim
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Christoph Hellwig <hch@lst.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-2-0899bac3b826@columbia.edu>
 <anYocInoXy7KRcZ8@casper.infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <anYocInoXy7KRcZ8@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: -dfeNfekrzvnVGGr7yB1_i4rFN7YQoB1
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDE1MSBTYWx0ZWRfXwgpHo9OE1XHI
 RCB3u/b6WfhcdtjxhDc83tWGO0MotCn/eYdDID7iGfKjlKmuppp8Pc3es0XDf8SrinciKgJcceo
 6bCO3OMkFQ7ronYlZlt4YE6tJRhennhIIqgxOiNWphp5STOj6VPg
X-Authority-Analysis: v=2.4 cv=I7FVgtgg c=1 sm=1 tr=0 ts=6a763194 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22 a=JfrnYn6hAAAA:8
 a=peVdY9tWmQCycwUogXEA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: -dfeNfekrzvnVGGr7yB1_i4rFN7YQoB1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDE1MSBTYWx0ZWRfXyMGbeYA+jSMh
 X0YMv319HCKjC1PwzPruwbEsJniwHWnPglWdEIVSCo4gRc4TaLQ2H6D5zlOpPklpBRL2pf4viEi
 e7ihWLgPKOReHiYInEBlyJZl0T7z2QvjEpJLuxkCiDNK6HuGLOr/0B9xl6DRngQzjAR+OXbINyr
 H+TqzTzIEwFLZA/t5vCX5gWRz57d6XjQrAbVzxDvOBGDiquUpVCicoz+Za+G9UcU7n1kvnfElCG
 qFtvrS1mvDdOSLFEyF8gCTwWQ21HIYx7Z9KQzJc0aC8EnXImbepvk0DJJTwGM4cXu3Qw97Hprbr
 sF34NN46eW8ZKV/KVFWReXPmks6F+d6BEIqwwG6BBro1oS2T80sCZwsGFhTM64j5LgW7x3l6Ycz
 gvey8aFMFVzOdrQW7TQWSV4fI53u0vOcuk4KloE/4aVgCDfrIOHUfw3BinMJSTNf7LZ7JbJrveg
 Bsh+CdBFWvDZ0EuAgNQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11868
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=10 impostorscore=10
 bulkscore=10 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070151
X-Rspamd-Queue-Id: 87908100014
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: itfrf7m5hhotxcwuihpmd46wsixckexe
X-HE-Tag: 1786130837-330516
X-HE-Meta: U2FsdGVkX1/zRgk4hlAKMSuLF18ipPALCKQtmWcI4flhTJ1lkBi2IxSDYx507l+ISZcI/K7uMKQ8WGJQHeW1qXWd/3kYD1ntqIOVESGMSXPc52R5vxIQv7j8fCTkqTffzqhsigEsmLdfutiKzhnD6Wpl+Fa72jO3Y1iXFe6rXKednmDTVcF+ramxtTxGyL5wmx8ATiRf+L1y/1Ge8dfC3DbLVu9/OVOTEUltkspVcctdpXEMoy6BJ7ZNOy/PcJGE/ZyZlJVcCnJa84Zr2CVIzVXJUdpAZKDxc9dDU1Mg5C6VsllBhh4OVc/z+z1RfhKP3ra4zFwicwXn0Z2MUeiumtorE4bMJcfQk1uaIeNxHmlPq0bO4yS+w+yd6/Fya2aWhkrDb1hFVYNaOUmZZGJPbnyniiHtcJzNJAVqAuuwxpSiZaLTKDn5ZxeF0EP238gcB0xQk9as+dxouMA7othqvUqz5JqKTszpQi9KoRmOXFkIN9gzfm6owd8eQSDBErYEk7U93HdClTPPNcS/+6rLKgVPlLUlGi9kA3+IBQt1SK8mBKKJTQyvYuRyfFC8z2NaIjf8frnalJyoyX0CP41u+tXygOGQRgfOBdbJM/JD6laQo8sD0OPlfCeHs+efFfe6w0pzf6JUCc5k16YGlP0wJT9i4vbu4L+rESazaXSq7Ga2pN7CfTermofLQlg5CdYUB0nnOccZJ01iD2HQ05TinK4dIp7jwhuu0Nb0VpwPWsglJkYyHYAi3L+BtDr+uIrSnfI088DAWV39RQP0DHMRi4k+DNYmtCtrB9TpDxfnETMgL8Ko5Qe8JOyg3QEOPExKi3oBr7Plh+XGs2elPAm7MtinB36xzflctlrEhwb4QwbYtE6uQ+fcKUpTblBTbJDGOqZpTnTO4d/Vg62KhxjmAqRJY6YAfaaNVH0V3/bx+0iaeqh8NZEQq5BI65WkJ1mH7wpmRqU7V3xk/FtoW9c
 FaOos9LG
 60SkuVu1QR/7z6VNbzttpuJZKQzwwpzOhljeUExw557b3RGV7I265oWeI3K9L0VlFEfzj71pFdOHlosoJAnwAdXxefr6zViX3oUWx355+581jRwRakra8pAoUItOmoWotQljHZM+7ZFl410ppF9UJc4zm30JBtqOl2dlYH5jpxi/w5h+TFDNBOGiP4xvOvBz56GIwWiwA7vLxxm9Fss1ThmGfbVETM53+IrlT3MQ8TZRd6ByJ7q74/gXNjqKT7DvTLBF5shfZAf8AA/PGDVtbehqfZYdcvRW2CrCh3YrA96CBozgn30Ed3jniu4euxCxg75zC6oMQNh84Mja1GmTF8U5Kykwx7GXKRRBa2R+9+OGC/hA2quOdGWZqgbeWRhc4NttuhDrNjmDWNVvyV3UTCZF+XJcVh+JuAFxDzcq4kWPqhudtxOIMPLN5nI9wXCwCsV7hN3z/s/Oc8xnDi2fe+/gu4JWOvXtqsw3OduNxvalNpju7l1bb99gA84PxmkCWKwdH4rEwz7Zyf4gOew/XszCvBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 2:48 PM, Matthew Wilcox wrote:
> On Thu, Aug 06, 2026 at 06:55:34PM -0400, Tal Zussman wrote:
>> This flag is now only used on folios, so we can remove all the page
>> accessors.
> 
> And we don't use folio_test_clear_reclaim() at all (it's mentioned in
> a comment, but that's it), so we can drop that line entirely.
> 

Aha, I missed that - even better.

>> -PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
>> -	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
>> +FOLIO_FLAG(reclaim, FOLIO_HEAD_PAGE)
>> +	FOLIO_TEST_CLEAR_FLAG(reclaim, FOLIO_HEAD_PAGE)
> 
> With that last line removed,
> 
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 

Thanks!

