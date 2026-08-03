Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96892C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B836B0098; Mon,  3 Aug 2026 09:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A731A6B00D8; Mon,  3 Aug 2026 09:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A276B00D9; Mon,  3 Aug 2026 09:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 703506B0098
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:54:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF9B4160685
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:18:01 +0000 (UTC)
X-FDA: 85059557562.27.C6C714A
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0B99D40005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:17:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=MBFfMPgB;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785752279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VKXo9RLOepuEerEoxhJYp3T5k/j3I7Y2xiV7gulHRd0=;
	b=QD2UTSxssAMu/fWevfGCwJuLiOkUoNYeWkZXrz5PBk5LWQMP2yKhkOAVOBRiDzA5tLtg5L
	Ybk5SRNBKg/5vO/AVeCzUNi56aAaaNnhKczZQifIfplw1uLRjycUGoRykwz/Yva0mwkKms
	PZ5gEjB/pJg7Pa4w93fKgLBfR/3TsAM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785752279;
	b=VCftlXxI/h2aLUVeMR7D/Xl0jKHcy0DvmGD4oibIlPPS1t0EcGHs5R5Jor9bM5+ESKZDCD
	hw+VeFZLRv2MsAjUplpHgx2SSsPM2MKe8vNrMPszrZ30KjdOqW/j0slIaVETvVIeOfnel1
	nm0ij45s9mv9wvGkIIZgftdBRDOtP+w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=MBFfMPgB;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6739ekOq2218026
	for <linux-mm@kvack.org>; Mon, 3 Aug 2026 06:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=VKXo
	9RLOepuEerEoxhJYp3T5k/j3I7Y2xiV7gulHRd0=; b=MBFfMPgBbJ0yIGiWLH2v
	HB974bvrFxozlgqRWYxtC15s3RvfcdcK7vMveioJv4/C7D/+tmmTbthOnGWq4iqG
	iaMzBppt/rCsVLj4QwUmnu9Z70FgaJ4zh/UtDVEKXNCVD0vhuS/6kISKvNu6Yi9t
	YB+jitHakUElGsDL5MYNCeCk+MW+cWXoaD9zNZ2upz7slZWy0NDnpN129HCoClgB
	PbFDi8IJwjggoLhMuQgI+97joQrvWB4tmkayC4vEYVT29APN0xU0omTcgHNgKqvY
	x5WVsSdct5qh/ibjzkQFrgYyi3fQqAHbk0ErQJYGCrBToTEr2h2jzPeQz2ZVv+U6
	oA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ft1stc8w1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 03 Aug 2026 06:17:57 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c1b4d961dso23955621cf.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 03:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785752277; x=1786357077;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VKXo9RLOepuEerEoxhJYp3T5k/j3I7Y2xiV7gulHRd0=;
        b=S13NQiMqKOjo9BQD61BXbkAji/kTVWiQy/KsGYoKzh0mN5G6tEjcGY81aSyZLUlN8d
         H5JWcTP3+n521blEp5sDXFXIOELCYkf1LhwqzfexOBJPvq7pP9SLIcKFiSklXdz6sL5Q
         gz7jp751REowvgPHQD36KHlw0CHJwFriIG5+pU9yZqHsZ0L/2xfkC+usnxBuR8R0XwF7
         BeyzkSdJJskpMn5CiL4CU9yNTnkxHN/X5SC5d3dcS21P3tMXqeOnQ7sFV8FRPYp/yVT6
         ZnSPlY/LsrEI4aBBWKD9x4ZhsWxRtcSVmGluID8pI9Er9hDdqQ3JEeBVQMxKxEPE1Cg6
         k4AQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp3YDT1bsH47AlNoFSMERjCBXVnuhxZcqqddnc+STF3D9wnTaXOXrXDVwBSU1h+5Ys6w3Zuu4tjHg==@kvack.org
X-Gm-Message-State: AOJu0Yzc4tXzOhHz0slFPeshgGCCcK9gNJMQ6Oqgzyw1ugIF1zRkPsBz
	oAM9UhSYG1rnQov2fyh9Smog258B5UssyWjinlUNnmB7n/Tp3iBHdlgBH3w8LgBzldfSxgEQGH/
	YHqnU6r2mbXSON6H/hf/UnGdcjVTkNdHM/1XtA7iCkNs6+aXi
X-Gm-Gg: AR+sD1090bJt5XcXvYhlRje7Zl0BKec1XN5VA/VYGsLVsT0JRKcDh5Z6YyRc9yQePZn
	s0iKX2eZrFD2kYKpzXGh/Ze+Z4RUqKOTad4pEjQgmwGvD2ZS+FcIaLWGjDgoz1zOs09tUCw9KUc
	6EXQGGh68HoAnlNlUFPXu/8jB5lZ/PKOvYno6QxVgzX7DGJggrEV4R5o5Vk9y9951PWELSS/jhB
	yXkzQ4X51UIIA8Ub9AgjGqrALMRkXHb865gPw09nDQAcLyCIF+aCxlcrBEx8ctzkllzJRBHCfxH
	LoS0ZLx/+FJS+26M3/MPBSO1r3yfPy7D7TpgCIcAzQ7L+n3HR7bjHsGBP+9y3ivSSxBTg1ADpJZ
	+PzFZlaLGtStApRxEIQv9g8J4EtQQEXib4Jw9w6UjDQcX3aT+W96w1I9c
X-Received: by 2002:ac8:5850:0:b0:516:d83d:b28 with SMTP id d75a77b69052e-52b4c5ac831mr165492451cf.17.1785752277204;
        Mon, 03 Aug 2026 03:17:57 -0700 (PDT)
X-Received: by 2002:ac8:5850:0:b0:516:d83d:b28 with SMTP id d75a77b69052e-52b4c5ac831mr165492101cf.17.1785752276751;
        Mon, 03 Aug 2026 03:17:56 -0700 (PDT)
Received: from [10.100.102.30] (CBL217-132-158-98.bb.netvision.net.il. [217.132.158.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd456a5a4sm32063433f8f.20.2026.08.03.03.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 03:17:55 -0700 (PDT)
Message-ID: <f404ed75-2b9f-42a6-8ee7-b4564f3624b8@columbia.edu>
Date: Mon, 3 Aug 2026 13:17:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] ceph: add ceph_folio_snap_context()
To: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
 <20260802-remove-wait-on-page-writeback-v1-1-6c35d6b3ad36@columbia.edu>
 <am-8AaWEHm7I9b7N@casper.infradead.org>
 <DKETLELGS8KI.1B0MCAPS99CXH@nvidia.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <DKETLELGS8KI.1B0MCAPS99CXH@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA5MSBTYWx0ZWRfXwruyhpcjhg7i
 INZJ3G2Z0Dxou4UotKAF/nYzcBap1Ik6TANUaO/GupAoxT6eQTJNz6JzUsz+VkCPuZy8gmIkLqd
 8XBP7jh0aL1/LEcce2Na/Ad9NO93NTcLvCl1EVaaio3+n5SjumzVVG+v8hhYfLtQaqI4BZTOUCZ
 2Q5/PLXu7SwEOUVctqILDHUDjgLCABME/WC8LINMQwkQvg8b0jWBZtK0pLzdmf1gpDZPTXF7z8o
 FZkC2CbLvVzK1qCdWKN1EmKzWrpn0eY5ux2qkqbJAkAGmORu0IaBZrkU00GyGUqBopuwSyiAIB0
 0bw0Pb2q8Pxb3CWVbK7MlvJcUJ14ui0zSos9i4COGhcjJzlgBI2sAP0PEnD2pi0o2Oh3xeQSOHs
 wvuKdIV8CAiZVfK2VaXVKVWE3kHDu+S95gBVyxcOGGtCksPaE5Hc0gC9JkSfvEENHmkG40S2flf
 O2FAb6Rxd3usJDtTQVg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA5MSBTYWx0ZWRfXwuiaa+hNLocz
 2necsuqx3qzOGhVkO8TJprivLKmcddDhs+DVk2S9GH+4NmKCbf/P8zbaieFNi+AzC6VWUkQhc0m
 oHh+YWY+D7wQg2KhZ1mNLX1eujTp3Nd0Fntq7ifEoGMTqPsm0TNI
X-Proofpoint-ORIG-GUID: -2lMsPgKGEfHYgRT8DEos0EqspJ4TN-7
X-Proofpoint-GUID: -2lMsPgKGEfHYgRT8DEos0EqspJ4TN-7
X-Authority-Analysis: v=2.4 cv=TuLWQjXh c=1 sm=1 tr=0 ts=6a706ad5 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=C4zMR0+CEq2lM/mtmjScOA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=DIPjSMOhCAX6BCWRsZYA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11863
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=10 priorityscore=1501 adultscore=0 suspectscore=0
 spamscore=0 phishscore=0 lowpriorityscore=10 bulkscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030091
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0B99D40005
X-Stat-Signature: 4bpg6s3hswmd39jhiz31yzw6xpfskdys
X-Rspam-User: 
X-HE-Tag: 1785752278-225328
X-HE-Meta: U2FsdGVkX1//+N5g5ySKlmybSVK8SXJ8MtdMQ0gdigelZDL3dr9ta+LxUzacH3OkCns63XyE5b5We5BDqFieaQPo8K7+U8WygKB8X/7CvzIIKGzpOXvMOi9hVqFAgebzPbKV0foxfFvhlgrO3YLVWTf4m7GVtBLedu4aWmB0TroxiAzcSS8HBHgF8C5c16JYIrPwvR+jqc0LRwL6eIF4kJ8cNnORzr4d4iNxQf+Aemf4dJeY7B0CUiyDiUK9IiivHAzLFJ2TQhHAYb7+sZByAcPopx99oR4mRuqaIQNCMwVYAYB0Ur07BfqXa6izLd9rp/9/jg1eAKyZV8Gl2w+B0+OC8CuZtI94bfbHTCSa34RqODXvT67CHpKI6EihMCVlW6PKMKkZU/FRdJG1kxtyMpuzvNJ5ssfj3nZtA7vwd8+p/UK6XD4q5TMskykZjBK9/1CstPWd/ClP07hMEvtpCgD+V0cmcLz2ZNKl93BqHDRI6TIpoM5abmXopsmTegmGUYUY5/Cp+g7ioLcYgtg/AGA8q1slp8ixo16bn8fTldAqCwmBgoBC81Rra7S/X0SIuJP4qKA46P3SRAq8hAUVADAoSr2jI/IIZCc+SCBN+KJHSUNojLwdhSZ9Rh+GrJ/QCOmUWc1FM2p8fuv6rgdPW5fUf7LnP+2S8YYwSRF00y1vo28ySPwIsCtuE0dNmc85PwjfJqArEP4j6FilAByFOviBZ11DzM777MiYUdY7km2Rvc1SRVqQebbDhX3roUqDRaBWeeyJSFA3VkziDVAaM7GAP5gHQ7nOcJKdCNPseL/jWYyqMicf6NwCfTsrayOrt/M4MZsH5137lGpXbdFNTCXdqlnVd6v2/vumFok1CVFr7ufBGhpad5BVMc3rcp6iisnhGdQ1TiQoFXHVuhXFCyfFNXZQZbIwp0nTN/qJ/QMrMHdQypvYUIjX/jDUjscbem7CsQk4JB8ZooOqtLC
 4F5+n9kM
 4RyDby+rmYDwNAi1MoH8w7nBFRUMP2jZBZrul7ozjW1Wj4Q+5vedovY4Q6rqAlhV2HNSmBHUfGWRnVBS/qpsotHF5HDaUikASUjn7kGdi0nzx8S5xdmv/VLVnT2meViesXzPTBQvQWt74Ndc76lwIeAB0MzhjsIWa7fTHPJ7R5E4qFXUhUZlxotot5me8CPw9YG4uS7FQh2dxOPL7JIIdtTIMGX/xBD4yoc7jY4r8ZtWXJepzlcpPUBd8FSKJSw7BqN3VaSDVbPPqcTfXO1Hjmxaaz6GXsPEU6CYJM913tZUgImKZD4S20YiTFe6NJjeFrdkBPwaP/ZpCs7vRlNgioMQAk4aa9i1JuGjtDCNM7IBnqfQtN31EAK3nPWCLqShfbKlEu5AbGh+2gOY+gzAILettDik6PmN0OvZoNMxJRMgdrzrND6xN8wjDcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/26 6:44 PM, Zi Yan wrote:
> On Sun Aug 2, 2026 at 5:52 PM EDT, Matthew Wilcox wrote:
>> On Sun, Aug 02, 2026 at 12:50:02PM -0400, Tal Zussman wrote:
>>> +static inline struct ceph_snap_context *ceph_folio_snap_context(struct folio *folio)
>>> +{
>>> +	if (folio_test_private(folio))
>>> +		return (void *)folio->private;
>>> +	return NULL;
>>> +}
>>
>> Filesystem folios _ought_to have folio->private as NULL when PG_private
>> is unset and PG_private set when folio->private is non-NULL.  Now, ceph
>> could be doing something Bad (I believe hugetlbfs does not honour this
>> for various reasons), but it looks like it's using
>> folio_attach_private() / folio_detach_private() appropriately.
>>
>> So I think we should just do:
>>
>> static inline
>> struct ceph_snap_context *ceph_folio_snap_context(const struct folio *folio)
>> {
>> 	return folio->private;
>> }
> 
> Yes, please. So I do not need to handle another exceptional user when I
> am trying to remove PG_private[1].
> 

Sounds good, will do.


