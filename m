Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E478C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 07:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F85D6B008C; Fri, 10 Jul 2026 03:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9AD6B0092; Fri, 10 Jul 2026 03:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39AE16B0093; Fri, 10 Jul 2026 03:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B2AE6B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:43:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DEB2403CE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:43:36 +0000 (UTC)
X-FDA: 84972077232.05.85B1907
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id D5D4718000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:43:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xTrQJqnn;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783669414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTHbaDxrPNNvtvGI7FMbsU1QRQRo+zezVyhSZmeVvmQ=;
	b=MYIzs9hEyDyvxU41UgCJ8+k9rIwCbeHWdJZ3sYLHp8l6pK9CvxZGwO2h4G8wzJsoHllD26
	5ddvOnxCEsXuyHgEYsdBxClX7hquxjI85wzXLB0k+VX+CcIuq7DMzgNOwt7hO6pI8kinqf
	/8OcgkpNctDliwMFK/lKcuKyjJlfK4o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xTrQJqnn;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783669414;
	b=mnRT6aZPawmRYSVz5xuMS0o4Sb7yrQn1a1oymMEhxYD7cjR0fFtzsloia2efn4zJGduTCZ
	HgPN1IvxglVDIS3DORg4YbEafTitjSkb22weL2L4yDZZIAnn7qFHPvQBcO0mCrAFCiid/L
	60LnX2NzVSIwVwNAevOG+/7oLI/Lhgk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783669409; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wTHbaDxrPNNvtvGI7FMbsU1QRQRo+zezVyhSZmeVvmQ=;
	b=xTrQJqnnXDAk0bAiAFZUZmEYY4GRo0rmDkC9VJ2fvHsnnheBIU8aClMhU+AuAJU/JBQzMI1yIST4v7jkId8DbEhpD1EOCDoGi9eQSVzveoFHKtUJpArIU9qkZm0AFzeco4mkXiQ6JuhO7R5BiGRQFiXQ96av705qIeJ8mMx8Lg4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X6n2i-3_1783669407;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6n2i-3_1783669407 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 15:43:28 +0800
Message-ID: <d818db13-0e95-42e8-aa56-78215c2b227b@linux.alibaba.com>
Date: Fri, 10 Jul 2026 15:43:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] mm/khugepaged: introduce a count_collapse_event()
 helper
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260706154500.39178-1-npache@redhat.com>
 <20260706154500.39178-4-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260706154500.39178-4-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D5D4718000D
X-Stat-Signature: nekixq8mfk3ubn3iu7babadb8cmcayzp
X-HE-Tag: 1783669413-531497
X-HE-Meta: U2FsdGVkX1/qoFmHQmLBBSMnm/uoDRJQguC25IQLM0RweO3S5jH2TgoD8VaA8NTDt/AK3w1Zd67mk3YqXtUoUWDxiSwj/DJ6Ew78ZQUC7S2j+vGpuh6xyTiPc8+NHN1N8bpcZQj6OFA1eUPQitugvIawv8txH7fUpzDMR2sQr2BUrmPSFp5usK/JewW3QlAjS179hf2YhZaTPvp9gmV6Blr51kWhhpj7t8wurEsF3DOInu8T5Hcg2pVCOpL/KB+uatNbesA+L7qUQegtZw0SBBue7cleEZbo2jzm15i4VMCsv+E6qiq9BppLt4uBCd8iZyDYcWjwODz9um5LB9gEcMWHHG+h0JwtfutfYS8WuF6k1ZeQOsI3mzYpXFU1Xble+3agg4N5bK8BCgysR+cdY8qABpfs4pr+Pqg2FJkD2NZayJ2tKNmq4a/3VZBfKJQvlTY7uDarDXN1XLsxxr4gwrkZmicyQ6hmr7RSBdYRA+vQWAX0UvBAeFkzM+Nux4S0zLw3Db8gajt1KH5D8WyMaNMnYYNvmz1/QHhN+lnChaXgX9ZUmFJSqbKbCj+RLlPO0JjUqvXrtbPh6XIWMvKI1egM3huqYKajoN07opaHxcnQN74o5LAAZOEzxcSEGiIIZZ9Uv5hDsj5TlgOt5T21Zr70VHmkeQphrLiVocqKTKYjE2uooW1sjBBeiHV962LesPM2jZIF+4mU5nmtA8VGVEfKfs8WAGxI6/W4ZS1jIWGrDi7EIqKpN14UkixuQATh7Qq9HvEYSQ0CANhN1eSmy560xBcH0f/EFdASq7IlUBlnN335WgNPW33gwCM+Tda4ngutQxFQLk5G2dVj7O6bpVAdv1KrZivvIXF2AdlBN+jtJ69lfuW9Dr0Ek+Rv5zzuJMRsYRYnu1HQnE+g7Ug8i6RcjEpdUNJnnF2Tb/dJUQMTbLatz1j6prrWo9UBZ2mt91JY2mRrb8xHWENAMQM
 zWkC9czm
 GXntFtlTb980uwD14jx9w2dKS9OIu48XqUhOrSFwq0v4SpXl7tDSF8k0yg5Z8pP4hVMNGg8zfDESiBvf5vwbGk74MFqLIw9ZrP861EbGjHMUELfSTl9svdPryIzMoshP8QCKmh6uK+aT2UCD4HZyyuvEyby0hWwSaIeD9WfBBoJQf3A5ftCn7Rn23wv+a/nXarblwAI4XJlJBFmkivF7JLtui26si9BMKQgpQBgLJ7UkXwE5Dros4Imyv0WM/W/VwIlKCd/ryW3ExPUVIOb18G41yPrfXmaK4ewCQPiaHYSewtWIJXD56kpiMVAtM3KePSPA0+1I5A4+1Q60ZqryGRq4mhdZQKNUv05KIfBFMJv8zA8jL6W6dpee5TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/6/26 11:44 PM, Nico Pache wrote:
> Provide a simple helper function to help reduce a often used, and
> duplicate pattern across the khugepaged code.
> 
> When collapsing to a PMD we need to record a vm_event and the mTHP_stat
> event. When doing mTHP collapse we only update the mTHP stat.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

