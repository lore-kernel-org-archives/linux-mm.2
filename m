Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 862CBCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA20D6B0088; Tue, 12 May 2026 04:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C716B008C; Tue, 12 May 2026 04:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1AE56B0092; Tue, 12 May 2026 04:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFB106B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:22:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E2171C02EB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:22:46 +0000 (UTC)
X-FDA: 84758076732.03.7CBB57F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6967D40007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:22:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a8Fr8KxJ;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778574164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUVIyD9MRktQzvJ81HTdLgPfbSAlk/Hl7tzeX266SNo=;
	b=WnwJpLVRH3msZha8QAHMFnLasz8inKDsjFMt6egXVpX8+nCBBMFgnOFnEE1zF3oEbBDkDD
	dzNlhLK/hGVC3jd0WSMnkSWO181TsIOwihbB2UgjqAroA8uHFOXTdWtDcC2Or6jkwbsNDt
	q8lXdpbuqswyiswjQqFWHGXkYUW9EDw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a8Fr8KxJ;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778574164; a=rsa-sha256;
	cv=none;
	b=yDo69VAf84h4aGDoZzwSl0zITHlzq4LLhqQg9b2HEYaUOoyAIN+Z1u0qGnfBNS9E2tnZ82
	PZOkZsDmQiAff8ygbfr3yu6MmVA4DPB1f95nzUhwjdW7Zcqkym6lS1tvtR4NHb4JTR7YCL
	H8G1e/LbrDo3Lz7L9dUWDFwwisf2dTM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CBF9F60121;
	Tue, 12 May 2026 08:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E8EC2BCB0;
	Tue, 12 May 2026 08:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778574163;
	bh=ni0UxaK6U6J7nDb32Vm336GAcjOxiGHM4mmYEl06cwk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a8Fr8KxJOOCGoI0HMLCHdruOThN3aUAAXoiQ0FX7e8xaSxBlda2QfjkE4vUYRFgeE
	 VIkg5CWLYbbTzAtIxVcT67HMj4s0/mNv7A66FF7fhUtRKCy1pSe7y4nbD4Xl4C7q2b
	 3hIk/sEB2KBVVrnoYx16qaMP+Ke+LjRaYyJV5N6T+4jz8o40lPloH1JMyVTk5IvVgU
	 ferDYsrDODOhojxaF9xK5A/WrZTHmYmXTFi2sHBohOWlIgHhXNokikQc2N+p6awpId
	 1hIK5d5HW6U3z+X/siVn8UpTVYHuxfpGSUchEa72TcyFt0JhZ1eZbxxBuPMocHQMDQ
	 4lYjaHwDekm2A==
Message-ID: <8d4940bc-d8c4-4e7f-a35d-979e6a781966@kernel.org>
Date: Tue, 12 May 2026 10:22:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
 <20260511-ecc_panic-v6-3-183012ba7d4b@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511-ecc_panic-v6-3-183012ba7d4b@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y1khsex9dyg8rddwf5xqexiziikhbqy8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6967D40007
X-Rspam-User: 
X-HE-Tag: 1778574164-848086
X-HE-Meta: U2FsdGVkX1+w54q89hUnFOHgqKQw1E4CJUoProfXnb9AL5D1HJQMWvsOgqJ042msmy5Mf0wUqtXqmypaIspWpmY24YgcfiAPDsoOAHtgWbDx3iKopsvYBn3ovzMI/hUm9LKeEEkb+Q+vhyUD+fWgxlk3sltmfCt0rexNsWsHsTRN1MgKsyT1ClqT+7ZJ5VbET/qYy285UmvxQSdLdATK6SBJMKZyWo6wHWBRnv1fKWt2GbAZIzdi54DNXnjESiMy0SAf1O3wAeh36yhia6gSZ8l4m0jh5F3HPjmzZmreZEsgEafat/tED0JQ0cjab8KQHfnT2gQmR3yCNZDcv8gjh/T3TkFUFqN0PdmA0xLYv4JEW0QK+jNC5lPA1KmwkicoKW/hjpxie1rpcDaqLSkOQpGTu/bPeoLX/ccaEsmkCQ5zANsplrrU3mW4GBzs4EQgCa+UzDi8/Fzf5V4FuUCCj7HqPql8Ca2B3+soP8v+ktiXBSsrFRDao7gK6dpedYMMmvjQhx0wPZsgPBXEvO+F6PzCYH5qSxhbwAYEwk+y0M6YIg3AqHTFylp2oQBNVyl+7+XH7F1/SUwTngUyRwNbfn/RNFAoUe+OEv64o9D8pNq2TtoOCfn+AVPFiXF1+ls+8NSubQo/2FHoSH5R/CY/0IOQCAP9OVDA0EZY8jcqZWa3IgZAbkBBqhkU3Ja3iqgbWEwPJfDpXCAtVVdqXwycAwIVXB+hTxquUzN3+Nv4fL1hoBJhZMXQX+/3O15IAPQV2MPrX9eYXq5/U7fw/JJJGuTFNIXIU0PN0j6fccPtY2Aq5yl6mcNB6mwOJF0KbFWSpAY6M9bNtv/Y8dwJYChItOJgFPZ30pk/vMMKA8UENZWYhHHZ1e5oPPnXpYgYX8ylOkpGRqhPi/LEAUidYEeoC0yVt/OhN/uxOMPvjroG2Omn5j5Iuv3kajGP/PTCoV5yvVUnYjpQ4dJH0smhyym
 BpqAK/6G
 aIzlMAJ8i+LjicuF7irKDtgHpP1f5s4uBFqOy+72HehYYHI5lOqLaBKQBtsj6xxDnOLXhuTDcWRqwwR882f9BVKa1SaBKG46HM4ogvznD6yuQQyPF283SAvFYkprIlwGKKR91PhjJNgITDZGc6k/YsH9n3HsiH0SnqttXbCUBruYo857iLyXFhx2XGJhCYeJZGQu4P3WU6nAMPwW5SyVc2LoLUzqk3+Y2As2GR5S6Ow3RaBOJeZMBHb+o7NqhJsy4Ug/HVxJfNdwNBAe50VyQmuAGEnlCX4tNYEjr44a04wAXjRi4AuHDJqJ0enzITJ6s8OUGdmgD5ZOqG4sNGFm98VEEv3IzvRuSlPOo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> @@ -1281,6 +1292,18 @@ static void update_per_node_mf_stats(unsigned long pfn,
>  	++mf_stats->total;
>  }
>  
> +static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
> +				      enum mf_result result)
> +{
> +	if (!sysctl_panic_on_unrecoverable_mf || result != MF_IGNORED)
> +		return false;
> +
> +	if (type == MF_MSG_KERNEL)
> +		return true;
> +
> +	return false;

return type == MF_MSG_KERNEL;

might be simpler.

-- 
Cheers,

David

