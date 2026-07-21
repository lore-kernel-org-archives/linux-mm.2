Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D181BC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A963C6B007B; Tue, 21 Jul 2026 09:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47146B008A; Tue, 21 Jul 2026 09:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936646B008C; Tue, 21 Jul 2026 09:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53B5F6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:39:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5F61120167
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:39:19 +0000 (UTC)
X-FDA: 85012890438.14.3419C81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 102C4100008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:39:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pu3HEcyY;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784641158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXr8nAH/OpXorVe7dIf+Ay+5j2SAJc+gNgKBaUAvsys=;
	b=4DS3mRSGfR7GYsx06lzbWZkkBr3hmjHCZi7nFNwC7uaHomzyd5qz3AzKRvd26/hP/FO9Gs
	DPIWwj5TA2bXBuBoi6GzMrhdQkJUPO1JwrwdHuUx9bptQfeSUYrUYr28fLdQvqHpv/LI67
	S+XPMRGVZbcGF3o+MzHdlePa37XK71w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pu3HEcyY;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784641158;
	b=F/qUOFbMj3T5Z64ivWufdBoIt4+9N2XS2zyXc2feUbiFQIsUGQtT/s6YDsszdM10XTup8k
	ef3uFAgWnmzoFW5w0qhPTrHPWCDSpObGi5MiEYJ0zeXUJOufl5cYW9GdAmmmhA2nTQNQh/
	woxw6F08K752AF/WsgfirbRPpi2tvGE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DBE6600BB;
	Tue, 21 Jul 2026 13:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2411F00A3D;
	Tue, 21 Jul 2026 13:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784641157;
	bh=BXr8nAH/OpXorVe7dIf+Ay+5j2SAJc+gNgKBaUAvsys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Pu3HEcyYIEd73b1l9R0JOFWTlWrkaVsgoNhd687DTLdIL1BKdrY+QnXLkPrXK2yFQ
	 jm9AiCtiUJa+wwIBSpxGEqprGpnCvoZk2ezc+9338S/nyVPixNJiaL+7CJRaAUKCb4
	 YNmjGGeZXeNOj7Ktddk2DJx/h5EzB6wudiMPtaj97oJ/8YYHjp497I2qDwlrlj3AYf
	 i7DLfs/K2QRUmPYOVqvBQrrbkFVhKI4+uP93STMSFAaUh7o31XVhdLP2BsUgXhFakj
	 Oe406EYXD67TKkihFyyY6k4GLD2lnGYk7vlDnW2JVSdnP3Pv/d9PPHjJZ64fcriu4C
	 AIBNFh55ARRXA==
Message-ID: <b66c233a-7956-461a-a3d8-3421c76c937a@kernel.org>
Date: Tue, 21 Jul 2026 15:39:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] selftests/mm: make file helpers return errors
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
 <20260716123226.197736-2-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260716123226.197736-2-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 102C4100008
X-Stat-Signature: xthqd5p9yyhace87psrqgrjo1z5yp43n
X-HE-Tag: 1784641157-609336
X-HE-Meta: U2FsdGVkX198I74j/v+pczywuA11KZ6PHxBysaVz3o1L0QKUO0+mIRn9sxvNVlQ1pGAlCHmRsr5+WiXkWG54elkdXFJKmCuvVqPxx039CDGxjqoBxWIDgq5bOhfyiA8Q00pn71GheCiaNthQuEye31uMHAf1T6z2ot+aPvVdoCZr8HzUAT1PwQT/KpDMb/pdNEbk3rRS25z8VM1Ak7O0myogG7ZfE8elM4FRI8hyGRXT0oziHZo4eQr3dlEHYni2Lj6gbJOJR2hWYwwCxrwR/1RfVC8wUoy6Owg4L297geIylo7hOUJvF/opkHJz2msBkxq8KvsiRr4MgW64ZUNy3O4Bc86SnIWLOkBMevwbbyVqiHzchF1jXfp2+VsuzQJ6e9KtgjDmcFhEQ2rBEIUZFbL/CgpcsxU+HGSbTUIQkwZJCXUoI0qFbxBSl1jeDHmw1iysFKNxag+6OFCakZyXVSik1/WZO70ygMxcvIXrsRyDmMSoSmdcO0SCsLdQJQf4N1GtVp3M71NfHVrETTchEpJQrukHMtRu/zFAKd8Nyxdg+BF22VfBIADahofy1VZ18bL/zUbgAbCvxTN/OxFgL7EgXOy4xI4MkiuZ7n4CXK7dZRNjrJzZKpFmrEashIa6Otz7kxwmWMk/HjRmWcUgHnN3vU9VCwIeBzFGfT+zIryrutn2JY/pb2EWpaQ/ZQLkoUySP4brSa59+mA6Ub3brxqHQn5cIsBwqtsB2L37G7bJ+qNXsm8N4whpkXc2/nzJj68SJQWGs02IrGlASGuwsl4KHh38mbkKO0v8NgRaE0gWVVkoJj0olq0mqHX9ARxeu+sAIwrQVnvij3xuwtGN8gRv9aNuCpSwa68fDiS4teQ+lFatt+CgN5rQ1bqLplt7jaAjmY5PczsKGDtWBz/sgFZeex9N4bg8iOMiroVNZ03z+NE418ZfwGFfx5bqylUi1bXMSe0QB377ccY8iXi
 n2brF6jm
 4N/UuYG49MG+KLZh2c82835NOpDkIM86mQzuSPEDSwDTvd4RgNbBhUzouBbeWsj3X0XuADVwpg0NrAEnal5yACuqwjle77Cp4TaW8eySDtXDEAGIRTy3vKecXYxuf3+5XirB45wRLpDlLFVMihs/PoHzr5Lt6UdYikKRaFbfgYIruVFLPEWaXqGN+wcl73/KzcPqHlPanHhhdlpcMQvaicaMVK1KpjLuqAKVJOxxRkH/q2JHS4PHdglhLqgy3G4vcb6v60g88br84gHNhMj0kokaHVj1vWxF3M2Gbhj0ozj4epCPoAvj5eHv1bPzISfiuxbGf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 14:32, Sarthak Sharma wrote:
> Change read_file(), write_file(), read_num() and write_num() in vm_util.c
> to report failures to callers instead of exiting from the helper.
> 
> Update the helpers to print TAP compatible diagnostics before returning
> errors and update their callers to handle those errors. This prepares
> the helpers to be moved to tools/lib/mm without carrying selftest-specific
> process-exit behaviour into the shared implementation.
> 
> Also, make read_file() return a negative errno on failure instead of 0, so
> callers can distinguish a successful read from an I/O error. Make
> read_num() reject negative and malformed values.
> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---


[...]

>  
>  	fd = open(path, O_RDONLY);
> -	if (fd == -1)
> -		return 0;
> +	if (fd == -1) {
> +		int err = errno;
> +
> +		printf("# %s: %s (%d)\n", path, strerror(err), err);

Shouldn't we be using

ksft_print_msg()

That does the magic "# " for us.

[...]

> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index ea8fc8fdf0eb..28c3d7c1faed 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -164,10 +164,10 @@ int unpoison_memory(unsigned long pfn);
>  #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
>  #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
>  
> -void write_file(const char *path, const char *buf, size_t buflen);
>  int read_file(const char *path, char *buf, size_t buflen);
> -unsigned long read_num(const char *path);
> -void write_num(const char *path, unsigned long num);
> +int write_file(const char *path, const char *buf, size_t buflen);
> +int read_num(const char *path, unsigned long *num);
> +int write_num(const char *path, unsigned long num);

In mm-unstable there is now write_num_ignore_einval(), where we want to ignore
-EINVAL and also not print any information.

Which makes me wonder whether we really need the diagnostic information, or if
we could just use return values that are clear enough when printing+failing in
the caller?

-- 
Cheers,

David

