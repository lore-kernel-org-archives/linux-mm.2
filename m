Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66539EB7EA3
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 08:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4058F6B0088; Wed,  4 Mar 2026 03:27:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3566B0089; Wed,  4 Mar 2026 03:27:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294CC6B008A; Wed,  4 Mar 2026 03:27:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1952F6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:27:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 996321B808A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:27:40 +0000 (UTC)
X-FDA: 84507701880.09.695BD4C
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id A143A140010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:27:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lCaUzZP/";
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772612858;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VJ7qnUVAuB93mBsI/0QGNEfBqxGmxIa1xMiepB9jQE=;
	b=LBvML0V18hbRrxA7jvANOeSGTByRnWCUw337iL47lljCMhbyvBUyhBoHY3ZAw6prbMub1a
	pkUcispEFpyrbw/Ot+bQotllVZS14M/jMezxLhs4JqhVFUTOd3+bV6qVftidnmjDau5TFv
	V5XnlKwBYHmHvS1ZLRBkqzvkmpOoCA4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lCaUzZP/";
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772612858; a=rsa-sha256;
	cv=none;
	b=LXcID/X9MsrENIRov70hJDzIu6/XI8SQqRR52Bx2aLOm3CEaWkdR91PIY9R8KVlH/oTwqV
	ZLb0clYaXId7zHPEd7TP06WQ8lyZrw4HCMot9ehC3MnlgEQTgGaIAj/IWsN7US9hs1cPIY
	VLRVJ3k/Lw7I63evArEkM5SI6wfIVmg=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b8fb6ad3243so971428266b.1
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 00:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772612857; x=1773217657; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5VJ7qnUVAuB93mBsI/0QGNEfBqxGmxIa1xMiepB9jQE=;
        b=lCaUzZP/ABt/T2oS/7P7t8UykgF+lkXDy/rc/NCzNPJTJLG3WNyJecMGY5d7CzRRvh
         k9hOdnaeuePKaK+w1Y67ibabrmSgA8kmz5Z3J3SL61JK1WUzUIhhUym7jgM1J1OMNek+
         l6yJFZmy+AZj/0xceEuiUvM0ATWD+zcmjibOAljZj3bmr4DQ1KGyTYIvl+WIPaBZeZFi
         aj6cYwBpIkqbYOkM4c/C7zR+1Q6wN2csEeNBN4JN2dsnGS7UQP9IXsPDNmAhGuKDxH9V
         AL3/b9OCq+UwTKZqcuUY1zTpol7LtPXywtyM73uH5M10yBr7SLa1iehjeWYhqQEvx69f
         q+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772612857; x=1773217657;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5VJ7qnUVAuB93mBsI/0QGNEfBqxGmxIa1xMiepB9jQE=;
        b=q44JcYbXs3ThcrIWc936dMTx4vWWbUts5oQ9Sl518FLLWDEIVbnul00b4IXrk0bW0j
         o5YNnhfJ0WoviajTWwAyZNqmH/mwvf74C7WYNe7jWC3F7S1xva2URi4bjgUu36AKEQ7O
         eCBcUD4MHLGTHclSQksRlBgMT0eJHrKhXz/ZCmxdrCKbgBw2BPxOUf4rEwEKVGJVKe/H
         tg4y8Suk34IlOATJnCJmF8cLuJEWhVwgjPqQ9E/JH70u+AzBXfYY8VksoYB3kf4q+T8+
         +0vnz5NFAfK/mXr7TB90R4NzJq4iq/ISZ8JYfptZonRcrAnmFXtqE1d82ERXfHWlxBTC
         bWtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqTppXnkiJLejsM0r14rTqOx1d2H6VUkCsRYUGXvYpKjVUBka2xybalBfyGfSe3BOIbUoq/s2RUw==@kvack.org
X-Gm-Message-State: AOJu0Yy1rK8kk90W88WAksUVefvoqYDLJRfKcpgFn2dqLlYwsWHyX9QD
	BUFHJS9bF28Snt08XGQDA2zrABth7bHKaP1fqF650x3tSN2punA9FH27
X-Gm-Gg: ATEYQzyWWsnYC4PFqpbcFkviu1Ls7elubWtTrgM2pduFfXMWV1eYfFsMlqlhaLNn7UR
	/9wylMhWlDI38AZS8WcRuvro0DS8S+PKCKUJPvUoFs7/J4LjAFJ3cBIpMZLJBL1dYsL1NEz532w
	IX8bTOhBBiI6PVG3G3Cn3+5WYgJnHZHnGadvMwT3ec6xBV2fHKvc/n7hWDxpT5mbdLMrRWI/vie
	Mkw8OvVpFH8iUrfpuDBjPOmRmGvQFHTu+6w35CxRDag1nayzBF8QvdYAQuHmzVqGhahDIm08gaw
	GsZNB1TeRpcYQLu50IdLmVOB0+dNHXU0NCNCzH7cCOEGes89yGo5teyCzsXLKR3jMbdE6XE8KA2
	E0t2zLtJT+TJ7taOrSMAAFwFuSJxlG5htXPA878Bq1fBGYxukcqARWRIu/KKBD4+gEMwWCcxvz9
	vJX8ijE6ZqQUSlQipwMVw8X7QvIh+1Bqr9
X-Received: by 2002:a17:907:3f9b:b0:b93:9905:c4f5 with SMTP id a640c23a62f3a-b93f111815dmr66757666b.11.1772612856689;
        Wed, 04 Mar 2026 00:27:36 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ac73d2asm703606966b.26.2026.03.04.00.27.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Mar 2026 00:27:35 -0800 (PST)
Date: Wed, 4 Mar 2026 08:27:35 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] khugepaged: remove redundant index check for
 pmd-folios
Message-ID: <20260304082735.j4brgesse3vp34rz@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260227143501.1488110-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227143501.1488110-1-dev.jain@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: A143A140010
X-Rspamd-Server: rspam07
X-Stat-Signature: 58dry5q6ax847qpwkty4cekx5ohmzw96
X-Rspam-User: 
X-HE-Tag: 1772612858-84495
X-HE-Meta: U2FsdGVkX18ewAITDG80SyRqM4+x+WjZGkD0iqctew8c4MJaIQcmjHhJpr8SwHD6nRRkZSX6JWtKo6WfnHvYJ6+LHhlh9Gx4/XkZ1iZUpUc7u1HMkZpWKlhRS2MO52Iy5aoq+qHTA9mNaPFJ1yt9R8wtEpwG7MLG0qCUiBXS8bN0GDeWKrlqkSF2KWxvmLqNt8Gb8XPg9ebn787EqjqUAn0LIvetFjAQCy3MOquywFeWACN1PpJU9UyIf01RfEezdxYIDM0kLy4XT92d0OQ9SZKyuntYsG6NECL3auZ6sXMQndOCrYaIgpCoChqKcCRO84w5zueK8cE4lcRDECM1wdIjNGNZY0LQgIPkrPU6M2x73XHE1bfcCv9MwO/orM48IYG3t3oYFNR4JAsG4YHZyXfUHmAGFzjs6EEaJSkZCT+WhI4r/Cfk74VkZwWSHNYSIczr6DI3w1sFdGQPpGPx6wglo1Mi+IkRMsT3ygztf4MB1AiTG799o+TaDMvqwdM33+e1FG/objGWEUrWmL95AIoh7KuBdwi2A65DnIdkjDe532+qgnLygFWxTzSvlVteyngirEZ0m69iew/wJS5/E7rdmMimv743NANGU76WrKW/0hZP431n2smPeMuNbD4mq5WdyjTxexmHYOUq33zUtAA8qRwGkWwSXcLtIfn1Vgo81lidIHvff0Y1xJZrZgynhZGdaSs2cgy70BCMXl3iNlP/mXHdTTcYogpBj/cluCVtG+lQ8Mkf4wF//CqAI+uMrdu+JLbuP1+8f5K/Y4wqE19ZvV6lNG7kUPwbYKcTcO4w/285Prco+PCM9rd19YyX1QeUxNhiAz35vyj4LWPcAKNRYd/TOXVh5ZxstoG7cBOx88mgtWSdlAFTC3sKbUJyosGrGl8i2LWJP2gYcycmmFbfoG7g1luDrDluz4z2/oId9DZZd0tfHi3kGeNW/1S9Hvlr0OrhH9KYjQHdIwF
 R9kVNgbE
 vBUofDx0M3Z0d//1J2AxERKNuiQy//yKF17gpv7HZ2s9pL+dNVoFRgt951P+FrQh1VPHP6HnMQ2l3TlE1sQjCZY1Ovgqd6tKzSDYH9V26cSjJS+KMIGsFSxJou1ZNBlIeDYOOTHc/aZrvUhgwXHjCysbABFnqwaVQ/cv+xtg0/LDi9Y6P7ey7oCHZGQWPbOYvc+JFnvXliC4C7rjcca6fmFuRePoIAH+EBqfF3M5tiPKhKgONKuMku1/Iwxcn3CbxQmkD/a+mm8akmHTgtRFSIiHuJjb+eg74fi/Sd81WKXp2nizfpy4LYuiS+0NlV8+2chXQGiaeNk34SkMJKIrHrA7h8cNgpe+B9gA76XBbvPmVutyZGPWiQoHqKME+BKJ3pctiJBPtkIXTCGY5GC9S/sHNGj7wrHL9YUrt+tEa56wkVWQSguqiiW25xe8ANBEmxcmal/a7cU5OI9wLYiBzCsmDFtACSZ81yVdmw1Mb+VxfwnoQcdNxXiha8qW1raf0DP71W6sNqKqJnCl6wyMmAbNttSpO50r3ihockve2HpHNV3N+YaES7vrVCcNffXGO9/sDIhkKitvXHnx+qkg2LKBIFDF/9Wt6w/nlRGWjk5jd8DU09PkblfxfNXZLqvp8emj8AV//hn2KELVuko6HgcZgvyK7zijG4D3zqDFNaNazJiaIamxlTU7KGE7og2BtMLpu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 08:05:01PM +0530, Dev Jain wrote:
>Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
>
>Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
>iterate on the xarray, have the invariant that
>start <= folio->index < start + HPAGE_PMD_NR ... (i)
>
>A folio is always naturally aligned in the pagecache, therefore
>folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)

This is because __filemap_add_folio() align the index to folio_order(), right?

>
>thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
>offsets in the VMA are aligned to the order,
>=> IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
>
>Combining (i), (ii) and (iii), the claim is proven.
>
>Therefore, remove this check.
>While at it, simplify the comments.
>
>Signed-off-by: Dev Jain <dev.jain@arm.com>

-- 
Wei Yang
Help you, Help me

