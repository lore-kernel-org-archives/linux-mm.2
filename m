Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4EA3C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1A86B0096; Mon, 27 Jul 2026 13:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861656B0099; Mon, 27 Jul 2026 13:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7503A6B009E; Mon, 27 Jul 2026 13:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BABD6B0096
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:26:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4D7B160147
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:25:59 +0000 (UTC)
X-FDA: 85035234438.26.40C797E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 19B154000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:25:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LC6RXQIe;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785173157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2htWxZI5vn7E2i0YfEdShm4PB1qNxAj1RVbthnzmsY=;
	b=vCRvJ8tAVK0WdBDpkmKkSXNiLpLdFJq+EXxmzXitUi3h0212Lz3F/UOcsuwrm1AJVxwybT
	2UMiRifGZNqCBpgcfizqYIUWhnsOdtj+STgLLq4WUUq1SGfTwdQ0bPx1c2e6lJFY3V24PU
	r3ADz1jkn5PXq9MWM6Qf/Ut6wHHrd4I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LC6RXQIe;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785173157;
	b=P9b6Txwp2zjTL7RG8YNgZnUj3zrlJgqpjKttCS5UIdYQuNg4ukYLcx6Nn2/flPclWTqc8t
	X0K1moiZ0pCWFc1SVwYSQlA89WW0xyYhvaXIFBuGfmYKF5GG7CRNXEzLDgf09MO2NiVn/0
	sB6vLu2EFggVMpd2naeUnEPcs5Ox3VE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785173156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2htWxZI5vn7E2i0YfEdShm4PB1qNxAj1RVbthnzmsY=;
	b=LC6RXQIebMdPNFZVye6xEfT2xJtqVrOtCTH+WDKkNtl5HYcbO6tdjOcbg3q6PwbpuZ1zyl
	Pnt/lZ1F3MLWBuAgwquBXnOiIbhfTKncgDXJaynBB1Jw3ppC3GwDoZ74jY8hCUwnK8YW5k
	2saL3Gtxzri3kQP2+4SvtDSMF0ZapEY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-m7DIsxr8MKuBvKZK0ngFPg-1; Mon, 27 Jul 2026 13:25:55 -0400
X-MC-Unique: m7DIsxr8MKuBvKZK0ngFPg-1
X-Mimecast-MFC-AGG-ID: m7DIsxr8MKuBvKZK0ngFPg_1785173155
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8fc6b670b4bso36816486d6.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:25:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785173155; x=1785777955;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s2htWxZI5vn7E2i0YfEdShm4PB1qNxAj1RVbthnzmsY=;
        b=BSBmkRxtmyBD+05bEDndQDxgf47DOYpoqUvVP0tqKyv4hgf6M62ZRKlNjB+m91U1r6
         zA0giKjEC04BlSB7tA5q67zeKLHJKkJAZtPPRf2CFy3LBzf6Fg4UGzJPzYbieq4fJ3xQ
         55Z42BpsHrQnm0+R7yLV+vHtz+9PTLKW108sc3dGYdg1ZJtszmaBPEpBAE0z9YlUQc7r
         4VxZJdqPL9ZxrU/o7JyokC5VWE9mGyjCBJ9hhRLhBR/8EQ60GpMJa+RHcUoXpGVzpu/5
         M1zWc5WYlwnv+lFj0+n6kXj+OC8eqvBtl5+HN74PpkGtgT5BssJ8g96Z914MNMLFTZHJ
         vL8g==
X-Forwarded-Encrypted: i=1; AHgh+RofOMctfWpVHpmOHEl3aDAZMptidbvMhCVEqARs2ZmSKsA6XbhEqhNeyDQ/wPqWFp0AX0uqsUxsbg==@kvack.org
X-Gm-Message-State: AOJu0YwHaDvkNQHKR5G6mTsggGgLOITKaSNtZ9H0qriDcj+mK50z10qK
	AEfH0ebr1IIVO4hW/I5Y4+5tg1sZA0LqBsmsXjRT6BXbNzq+X0yba3NY7FS4dB4tcYzNXSbstWE
	IZJgksqEEmfl96ZSQ+M99EfAoiCLfcwT6qrnNQ2GE7IBr54Z0NK8O
X-Gm-Gg: AR+sD12Gpng5fTjjGHar2idSonD5u9MDkD+tsIqgwHsOmSrlpjrlagnqgoDHl3olisH
	Q6b5/p/lC3F995SXvjXj7i+nJrumlm+qNpSnMkeFEvZTLF0D25TO0Ops40Njcwch0qeI3e712Di
	LvXnoyfM5hO+xhb4nTPuEiTJX9tVxaP76W8eJmpIetq/APfHhUzRWq5j1J2JnZYCFWU8/RTVccK
	XWj2sISZ824cyJY6gFa9aERSmNVjZE9ya9so9v3S7opCnHS1LLjt5yEu2Ab0vcfUMjyQT8Lu+Uk
	y5KGJvArhTumwTOCxpJrwmGMGtdMLiVtG5t9Jsk7wAT2Ck/anZgAITfOIR2JSbD9JLCnrhaEZgj
	b
X-Received: by 2002:a05:6214:4984:b0:8f2:860f:4dec with SMTP id 6a1803df08f44-907ec768badmr108097756d6.15.1785173154486;
        Mon, 27 Jul 2026 10:25:54 -0700 (PDT)
X-Received: by 2002:a05:6214:4984:b0:8f2:860f:4dec with SMTP id 6a1803df08f44-907ec768badmr108097326d6.15.1785173153995;
        Mon, 27 Jul 2026 10:25:53 -0700 (PDT)
Received: from [192.168.2.110] ([70.49.81.60])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e851b717sm69356736d6.7.2026.07.27.10.25.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 10:25:53 -0700 (PDT)
Message-ID: <4fd6df44-fa50-4c3f-9d0e-8a785278f84f@redhat.com>
Date: Mon, 27 Jul 2026 13:25:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/14] s390: move has_transparent_hugepage() out of THP
 guard
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
 corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org, dev.jain@arm.com
References: <cover.1784856856.git.luizcap@redhat.com>
 <3ab69c6a9210d2764f714a093eff731dcb55ed14.1784856856.git.luizcap@redhat.com>
 <a0be91ef-7e19-475f-ad0c-0f0bd14d3f1d-agordeev@linux.ibm.com>
 <cab6b125-f028-4d71-8500-5f7a6b9ab646@redhat.com>
 <e462a3f2-1a29-435c-b64c-2876f98059bf@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <e462a3f2-1a29-435c-b64c-2876f98059bf@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vCcYvrhrvo0u8HbppYbM2fykjx-9AaQjH5_0airm8cE_1785173155
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 19B154000A
X-Stat-Signature: ixw43j4pca1qiy6yy67gorbs6kh86pkb
X-HE-Tag: 1785173156-71146
X-HE-Meta: U2FsdGVkX1/LnYNQf2cNd5WuHCowpjSqU4rGWCJgUtgyaGJ/rbVSs+XlzVOQtZShlH9ztEtXFdLXfKY8+zIkGsDLVifVpAm5r3D4xhez4KLGl2qlXMTsV/yg6OEW38NiCKTl957xUk7aifOBKBsU4pI51MoCFN8VRbJuJQDigp/gRtG0LjM7+YUda6cGWygBnN/OKsVdk0y7JiCzi9egwcrKGKYA+l+cBrtUdSadarqF2q30sZw/c+/gD+qP7njEYewWYS5LZ/E/+nSrCCnZtVBkim4wAle7077RxAgxUPD6FmX1JkZEtlKEYPC3+hftCvPZtIeVyZL8zhTP2gLwg0CwRxVGSs+ugM0Vb8UMtl7oF7PAcgVvMpzP3vduUawGjIOzDES5MAs9UEe+u0OiaJA3fE3HJuRdT/dv2hxvjf0ovTiOlH19YTxs+98zhBZqlW3D3y3Ha7o9IEJuIciP/HgcAIju1RWC1HmBjrSF6ltepkpTOb4VTOsv72f+YfdnhC1Rho2LQd4BfXznb3/7hRRkE9f6TY12McUlT0URP+9DNy8EQb1zvip6zkoDMnLEW+O+VWhYqY+8Q/XOd2mPtW3J0FKT4EBGnvlRMwd68zEQI9haqWM3/8XT29Qmr7mXCvW2yCC0np0nnYaLgK8pqiaiIFVNJGrx1v8QkKPQEAeQptGfNfngaEiuOxaePItXm3x+hF2DDQt11PP740Lq8RgJLsM87I6ezmwm1tXLDMxA+GxI9H+cOzscs0nfx4qIIzdM+8rmeSFXhZvbH3ZfxjvyvOhiCs0bbFn5JWm7dt+dZZQOVUPy4eBSlkwR8C7uBmRPMjPt6b6z/8teRlo3UGzP0BPOLXzNZ//07mGx/xBbs8tKJYZJJ/BerI85NHHMzqeFDqBjWqbWLDEy+ZiOJoYeH+K45CM4K0BcWPba25KDismYqhy1balwu7H2z8he/UoNc3ePdLIZJjAd7a+
 4WcK8iS4
 kuyAVr7N3JbBVGWayzzglvQTHfAaPf8NYnJniP+pcXgCAaTYa3YZx5XGyNI1LZdh/856cGNeV4kbJ4KOmE0SEsnceIr8981dlc6ppxeZmf1VMeeAGu7Pn8ZCugHNJKUJqn5BtxRGWhRyphb4vaRPrp10iFNBI3ZBmMWii3zaWiAPcbDV9iyVH3tQ0Rq7utu0gQQqlzllKWOY112mBLQCYjKIqs2WNSORvQe6INpPfreycndebhh3meSa6OPvmglaObPJ+SDt3l51pw/Vo+gMwAH/wl8CzuavkpVZIogKwT0x3h89XLSLYTkpAmTkqPJLGBFMbtrk+R4VEVuWBab/NNTySsUKmqFtZyydwF8Nh7UKcghtsPwkTz9wCdOQmP126NaGHQ1ap8x80f50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-27 13:14, David Hildenbrand (Arm) wrote:
> On 7/27/26 19:06, Luiz Capitulino wrote:
>> On 2026-07-27 11:41, Alexander Gordeev wrote:
>>> On Thu, Jul 23, 2026 at 09:34:12PM -0400, Luiz Capitulino wrote:
>>>> has_transparent_hugepage() definition is guarded by
>>>> CONFIG_TRANSPARENT_HUGEPAGE, but there's a need to use it when
>>>                                      ^^^^^^^^^^^^^^
>>> What need? The commit message needs to be self-sufficient or
>>> at least explain why that it is a pre-requisite.
>>
>> This series is adding a new API, based on has_transparent_hugepage(), to
>> check if a CPU supports PMD-sized pages. The new API is orthogonal to
>> THP and must work when CONFIG_TRANSPARENT_HUGEPAGE=n.
> 
> Alexander is asking for that to be incorporated into the patch description :)

Sure, I can do that.


