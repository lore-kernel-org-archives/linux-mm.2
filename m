Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E392606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=lzMdWQRj
Received: by kanga.kvack.org (Postfix)
	id 881056B02DD; Thu, 22 Oct 2026 10:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831DE6B02DF; Thu, 22 Oct 2026 10:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721A06B02E1; Thu, 22 Oct 2026 10:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4856B02DD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:11:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D53F1C0B5A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:11:54 +0000 (UTC)
X-FDA: 85350450948.13.C273776
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id A78664000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:11:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lzMdWQRj;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792678312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0ObRZqURp05kcBQ0Zv+pu1j99ivc4QOppayGe5sXtU=;
	b=ULJrdtjet6y1OLLtIDvLUV+/QQU9KA/Jd7BPm06Nkyn96S4sEq0heT2Ve4NMyG/BcR1uv/
	btKLrOYoQaOhhfgHpzBkMdovuy6MSeRSQh/myvJuBHQ/3bLc+/veSwQfXGNwt/10Cc0+Wb
	ilndRtzvmRWIbOiFoAtdUSisX3jQWiY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lzMdWQRj;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792678312;
	b=UxfhbK01mWcASwypattkJrgkVUhiYj4Sx6Qwt1N6KEj0iLRzz6c+BmxJwKGvdVqdk3mb6J
	I4wGutgcsZSDgfdhTqBzeDyRrFPRxyrG/b0NZNaKEVMDq/LiM47u0vL3YckFTomHb3yEK2
	vlSIuTxhjxJ2vZ5RXL8rJpvMA4M6ZCU=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91c2fc03880so3422486d6.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792678312; x=1793283112; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J0ObRZqURp05kcBQ0Zv+pu1j99ivc4QOppayGe5sXtU=;
        b=lzMdWQRjdJKrTFyiAr6d344LGeDeOnJk1fud84Dpd25vf5WRDJwEHrpbadywSgSq01
         rwIamfCzqulnvl1jC5jtDQpeWHW8f8Vjym117kgHJbVZay9Hy0Edo9P5aOyhPusyciCC
         oYWNuqhv2mDJoRB0TmVa8ZDusiXfijQiaEzd1YpgofBuv2tYVEjvemTA0PH/OIHGkcxh
         BeijjJtWa1QH5q4Qq4LPxlDzekAEYra22RRrS2aJHim7L+tD6L4V6Tdg2OMagTEvURIs
         +T5WbGgLpgp9WgLqCVwjkonPxgDh28J2HSVcNik7BQPpbIsmlkREypEcVJ75gf6n9shN
         5utA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792678312; x=1793283112;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J0ObRZqURp05kcBQ0Zv+pu1j99ivc4QOppayGe5sXtU=;
        b=XITNXcl/BCHLyW2cMcGZ2T2HSXh+sqS86jIcmPCgYA9VVAhOwbG1TqMZE8rspTVAut
         fbhi9iG1NAlUxCUTp+l5PobWrv+DMwheJ4oy8F64gRWDMKC/2V6ofQ6KuAcXXjVzlHsz
         dIEY0xsIgfW1U3RwpeqXe2BGUm1YnjPM+dimtnJXst1t9jsLVfKMkBO3/cN1OyuzpIP9
         fcUVDjJhxZDEUU0QMrrU/neFQYRrqgIGsPkxQqbBQHUmhy3HAAmrTOZqCiUijrLeG2JJ
         FGdb9U0dVh8lMpsnxzH9/m5vQT8l4MTddLM38eIE0Q0OUZZi3MUUty+6ifUSoi7csv70
         h0yg==
X-Forwarded-Encrypted: i=1; AKwUvBwf2V8AqCgYWrsCMBAQ4/N6YwDZKVhLyQ2l1QmcDXDINbI/MrgQIBVwWZgjrPvOHsiBGWBuwKWfnw==@kvack.org
X-Gm-Message-State: AFq9FYIsbKiE/x6QINlX9yQ9hvXp1hTfMvh5q1QbXqMsxxUxAYh5qDa3
	PvLpPVBbm+9RgB0JeevH3Dl1iGfllntTz+io5mRfz9S9PtIv+ROSp0q4iJvX5R9NEJ8=
X-Gm-Gg: AYBFou1DkaY6AGBvKjkPpvY5D8+YKbm3ov5XDIHc1H9eZCYm01qbtQlZtlFoUHquJic
	/bEtmNUqcZkdb/xWySsNq4rAWW4YWbEaf02YUNVyGqJtTtvHKYDAjjsxR8fwU/X7djT22EYrpkt
	MJBQ/uXvkG8XKk1xKzt6i8aHPiJOgGFq2qIZ9o0W8a9eazlClxFeEqrkk3FqHP6PLCFo/w05RJa
	z+b/98BXtLZTKspj9wCZqaVLCNqfXWhm0MuUGoRJn69QSHNnlh+WjTKTZ1XFVvgs+UqcmDNuiiA
	QQo/njTom6YRj34bjriwgjnylid+/cQ7CRVfkhVA7BCfMnHX9EDfgaV/IR9UD63vYIlJtYE5Z1b
	y4SzE3NOuWg29TjmI4fG7I1Kz2oCfwe8sk512P5vLsvjQTpKFAobEsg8KthBZQp/zByEm+amv6l
	9uXxuq7lqVDfiAzWs16znddJy4XkzXoA8JgnsMwWkXS3sX0CZgLcQfDsoDe7l5sGtiJ1SN4g+Yi
	xV7zbQPA3KIpmGRrp6vaw/1l9JN9guxPS6QDKnSmcoVYR3cgodRU/Jp3QQj2is1pJqXUBO2GbW+
	3yG0UuIKay33HWXH2b144+OwSKfdpuRwudyyOg==
X-Received: by 2002:a05:6214:29ed:b0:919:57a8:7537 with SMTP id 6a1803df08f44-91c232e5013mr44009236d6.18.1792678311640;
        Thu, 22 Oct 2026 07:11:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10c0bd4csm51371086d6.30.2026.10.22.07.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:11:51 -0700 (PDT)
Date: Thu, 22 Oct 2026 10:11:49 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	ying.huang@linux.alibaba.com, ljs@kernel.org, mhocko@suse.com,
	muchun.song@linux.dev, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, weixugc@google.com, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
Message-ID: <atoZpXaCRc7etPW8@gourry-fedora-PF4VCD3F>
References: <20261019141401.11927-1-lizhe.67@bytedance.com>
 <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F>
 <30457046-a662-4ff7-a6a8-100398d7a806@bytedance.com>
 <179264138036.2549665.17429111144570830454.b4-reply@b4>
 <9b715272-3ed9-42da-a6ae-467e8ae00c0b@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b715272-3ed9-42da-a6ae-467e8ae00c0b@bytedance.com>
X-Rspamd-Queue-Id: A78664000A
X-Stat-Signature: jgd5xc9o66kztjd3atusgdo7ttxxhbio
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792678312-800017
X-HE-Meta: U2FsdGVkX18pWxqPijQSVEt53xOVSkQFFGJLRFzdafgstQKcU7vn2RixbrhLFFzySLrQ2uBD4GT76K8clge3xL0Yg8SW7/rwCFh0rP0cpSplJu/OC8Dqel9v5NPHeh6dmQ5WGPy3FgtA1t2LL+0ukn43RmV/2lL7/V7EPLEKFduBovNcRqHrgPsXSXJttDCiZuOn5OI/pjL6ewzYXRT7KlAjS8XrFZP3mVgAv8E/YEZQnxd5PP5L5jN1W1JVNyD9sdVju/n19gvzvInPIOnY09f83W7A8O9cL5zt6XOt01vWE8TFZHSBmIvaVqjBjhs1l2lpz2ITFWviLPN/mrFJFcWdGVyAkS3TSu7ToLkCNYafX1cBHbaqoQGNKmh80eW+lJ2GSUT6LSEoorptHQui3NAV1DAs9A76CjHAUyKmkC1uo5fKgxOaXbnMv9jcNNgIp04AmodkTly0pYuOcvAF4LvHGt77H6gj+dftDrUXo9hk4ZIRDLkW/6PPHqAbmchnvCIq6phwp9gpMeuTebdMeXY5ESdV/Uu019qTCYKDncbBvyLbtOTYLFqMB1qjq1F/WKtMxqCrI43hV4B1oTJGjSZOMLe2GQHFWhq9fg1sODoYqY+nxLSVJ4tYgHEBl4Mg5NmNscrRrogExaDiaFMSqC9VuPxJRz8ywt9jhLkQQV0nlsFujq7Lp2qXwQ0qlIT6kHBfOqsNp9ZFWN60NxNyEHly4/ULWNWyAkHPEw5juokRTsLTf7yZpxJFjKURpC0xS44px9LcstJKTutPCI9OaEm4JIBcW0L3nGgCDTY7Y0v5wECGMUKVQdEVZH74oq8yvz+Kq7geU1uxc0MFx5j1AXL5bcTv5fsxUVUbAhcE6pOU4r8ePB0MCnUCT1+0uTwwXf7UqVX2bZ3WsX4PuFquXyGxETwbpz+iDNHtqDYSl8xeJrxqCr2NluiyMs34yZv0Kq7VZZptRdz6nScwR18
 HcXMEdzw
 D8DUnhTxdDo4HIKx2Xzdj9s82YWiskZF6uKqT3GN2qeT13NU54f3hcTmIi73I9AwJYM9r+mUwkS+KaFIr8hd/8aIvApK5J60ucwTnJxM/dz7RwbwBn6uyxQmxJfzbv0uFNwbArMboWXklnDal4QkqgINqy+KYXaX0lICkwYUqSXm+3uiLQgU5yNw0ghDXNCXeYMuRNMOdkCS85tFqqvgHxUCWBuHkJ9CGXnhHAcFCFnfh38vxCeBUQrjm+srRCb8W0Z5J5DzxUHeM+0WQhAeYnrOXYwFkKTAZvgHOqX7UefbjOfj7P/IoQdRjzaB3Lg4Y33HwkFoc9/Rz3YkY0wnR/pbB3QVYRT9MOKBw+UDywz2gKdB2kh2Bo79BRFEJ5EefboJctCFFC19gRNAzbnN+tPxLVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 05:43:49PM +0800, Li Zhe wrote:
> On 10/22/26 11:56 AM, Gregory Price (Meta) wrote:
> 
> So userspace cannot rely on one write to memory.reclaim to produce a
> final per-node distribution. The intended usage is a feedback loop: the
> controller observes the memcg's resident distribution, chooses the source
> nodes it wants to relieve, applies source-scoped reclaim pressure,
> observes the new distribution, and iterates.
>

I think the critical question is what CAN userspace rely on?

We can make a bunch of feedback loop interfaces, but there's no
guarantee they'll actually be useful.

> >
> > At the very least i think you need to add details in your cover that
> > demonstrates the process of doing something like per-node resident
> > ratios, and show that it works as you intend.
>
> Agreed. I will update the cover letter to make this model clearer. I
> will also make clear that source=nodes is not a final net per-node
> footprint guarantee and does not change memory.reclaim completion
> accounting.
> 

To be clear, I think not just making it clearer, but if you can show
some tests that demonstrate the reliable behavior of the interface
extension under different scenarios - that would be compelling.

~Gregory

