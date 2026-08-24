Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 319B5C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 115336B0092; Mon, 24 Aug 2026 08:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ED536B0095; Mon, 24 Aug 2026 08:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1E676B0099; Mon, 24 Aug 2026 08:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC8D6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:17:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B5B040111
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:17:16 +0000 (UTC)
X-FDA: 85136062872.25.7C4DA10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8DFF1C000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:17:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mW/hFf5G";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787573834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9G+2pR4S+ko3JJWwpOLkXez1wvJqD3jZzDSrEX5v8M=;
	b=nIe30B94HpJ6Vkc8zqOeQCJUVU2huHOwB52pMKMX6kE/HIdKVUT6mCDKim7AJjGFHh/ihQ
	yrU/os8LjWhSoJqVHZ8wGhubnkXddHPOkLBdDUMZzJBoui/zFigBTeleW15HSJ5hmRo/NN
	sYGu/y5j8ILST+3p7SsiCCPNIOY/kRQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mW/hFf5G";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787573834;
	b=NiMp22xAlmrP7olVu5XuMQhBplIMm66oUcSUG3Zz8HY4FRFPtWMeiQA+tuyTh8n2oz4GpZ
	jfP0AMaVIHX8PUGfC3k+RNsMzBq/emzJS6K3bWepdDgQaZraKSLn908oWMNpzrlExmobGj
	VYCtzFwoVxB5eBko63M8ZR4/PcaphlU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9ACF41A2B;
	Mon, 24 Aug 2026 12:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594591F00A3A;
	Mon, 24 Aug 2026 12:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787573833;
	bh=I9G+2pR4S+ko3JJWwpOLkXez1wvJqD3jZzDSrEX5v8M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mW/hFf5GQRaQ9wugKNZZrfdTcCRiHg95Gg5mArsWXJg+ZyTkK1fCiQsevUocW2+kk
	 w98u41xT9vSlJ0tnn1GnY7HZ9rQMESvfWKfMHZFr2LUkwz+v+XlYn+i1IpUrCldS0I
	 g8ZKkihlumtUH2TQjqznlLAWOtes98bfAzxMX5LJiM0nxrBsEtd3PGnUl6jXOY0bdv
	 q6aPdnkeO+vy3Bjw89c0oDIUApCOi4iirPuNPSsJuUuAQlh6l2gD6aQQZ2nvBdHsiz
	 fjrYFbh5HPIcvsh62m8kCUvV9SvJ07ajA/FfsKfP52LBp+M8G/CBgjkiXUNIg7KmG6
	 skGXj7cd6v4Ug==
Message-ID: <75738049-24f9-4056-98c8-b4075552ab78@kernel.org>
Date: Mon, 24 Aug 2026 14:17:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] selftests/mm: make file helpers return errors
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-2-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813181230.483746-2-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8DFF1C000B
X-Stat-Signature: rwortp3jqkgwbnmjmjrwuomq9euj8djs
X-Rspam-User: 
X-HE-Tag: 1787573834-263012
X-HE-Meta: U2FsdGVkX18frbnThtFhCikFYXpnQ4HxgV2hUd7kf/CfwwSsWiRA2FYjEXBuFnkKrWg7GjxMZS1V09Tx5VTnDELJqGKZVVj1fb/oe2Ji3AjTfTAE49Npc2UKWK3eZfdgI/hecvG08rjhncstm+dPF6UWUg8WEiX+bwrpvzZcWhC65CPwjvzECJuEDQVPBVXx1afVMcVSbnziKrERk5z+lJU4ZMzkhn/CVcm0tjBUYGO5qBiQqVkYw7Re8pH2RWrh2P6P9h8MF2quW4CDHD3lq7b+eQ3LqqYFoqg1ORZZXGXXe8De06uRH6yh7XXLToswYaLxibqpeDLDzuaSeh0+p8WIZcvZan/RvNoZXJTTo9iuc1dDdC0E/6ZiAQnXbMB+D1e4ls9YztqGBAK272U+JNyoTlHR0JBsKUOcSCQzjKaxEeRfSjeQOqlc6SiA42uiyn9csPVSHflvE+1jwis5trEa03cdaWqHSPaOuduSg7PsitMNCLBr6XZ+qNzPCUxoFqwJIbeaqcerWBN/fiGfdWihvQ6BpeV0B+SN5NafACpxgcWJPFHO0sU0jID8mBYKIcDr3pI7HjyF4H2NtRbNAnJMfRZYYFwPnV7FE00anDkPP1mXjB/RQZ/NjhNJGrL+y423iekegY6IMTt0h8KTAkeeBj5gkfDjCJ6HmE+hu3nXQcL9Zlgh841JVCVSyPnF7uliic0altQOAzk/97T/Op8keoMW/cqw+NJJynUVOa2Itn9QvZ30I/XE9k7ideEKq+XVBtCalacDIoZNwxLlua12Y+5I/Xib98X6PPuSoHqDMfdVzVs5xDMTYp0C0Hxs4x6huBxuK89mvabZwshp+O+GPPcclVqsWwa2CR/Sb89rYgpXwEz5ezPVfvzZhewhNInuJoCEnphGCcjf8/WyZd3+pF3Mo9q2eg/K4yxqqgJ9jyeZwqvBZ8fj2wZoQrbzc4Jn8p9L4dd3gzYX1rt
 ooLhKSIy
 AoIAGdlIthrjGrhtjqL0c+DdUxILjdC4Vt8u4gtTat8tOBUQJB5s0s0ZUmNGVjouqTfpJRTSPTC7oZ8bsMQxzyrmX9haQyv9/EeEtsXqOrDanQgaGIOOehI3jvKcCReGXkAGQtjJem2/aziP45xTWbaS88stkh4WpzhsMmY9bSL4fsjVo4O7twkQsAV0oYFkhgxWzXJNdvQspRcXgRmUTj4siW6X0xzMSJ7SO1E2/ndEW6Hl99tFq9SM+cl83FyL4ywAlbxGgbWcgWy2uEP8uFKqcUdNjWY9HXv6o2I/xfnDSj7XQxUe8Di0KsmsjBZQla5Q0YugMgStV7VOyHga36sYqLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 20:12, Sarthak Sharma wrote:
> Change read_file(), write_file(), read_num(), write_num() and
> write_num_ignore_einval() in vm_util.c to report failures to callers
> instead of exiting from the helper.
> 
> Make read_file() return a negative errno on failure and 0 on success, so
> callers can distinguish a successful read from an I/O error. Also make
> read_num() reject negative and malformed values.
> 
> Keep write_num_ignore_einval() silent for -EINVAL while returning other
> errors to its caller.
> 
> Update callers to print diagnostics and fail wherever required. Also add
> a helper print_file_access_error() in hugepage_settings.c to print
> TAP-compatible errors without a kselftest dependency. This prepares the
> helpers to be moved to tools/lib/mm without a kselftest dependency.
> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---

[...]

> -unsigned long read_num(const char *path)
> +int read_num(const char *path, unsigned long *num)
>  {
> +	unsigned long val;
> +	int ret;
>  	char buf[21];
> +	char *end;
>  
> -	if (!read_file(path, buf, sizeof(buf)))
> -		ksft_exit_fail_perror("read_file()");
> +	if (!num)
> +		return -EINVAL;
>  
> -	return strtoul(buf, NULL, 10);
> +	ret = read_file(path, buf, sizeof(buf));
> +	if (ret)
> +		return ret;
> +
> +	if (buf[0] < '0' || buf[0] > '9')
> +		return -EINVAL;

This is to reject any negative or hexadecimal numbers I assume?

(essentially anything that's not a valid number)

Worth adding a comment.


Apart from that LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

