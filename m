Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511BD606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VHF3XKzl
Received: by kanga.kvack.org (Postfix)
	id 703116B05B1; Fri, 20 Nov 2026 06:06:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DADE6B05B2; Fri, 20 Nov 2026 06:06:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1566B05B3; Fri, 20 Nov 2026 06:06:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 353836B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:06:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8DF6140E54
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:06:41 +0000 (UTC)
X-FDA: 85455219402.28.7E0C2F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E22D7140007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:06:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VHF3XKzl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795172800;
	b=T35fOL9Gwpo8NkjMgUmj937zhla0O/8aueaZ8aiUFqC3esENJagJ5jEpvfDqg6RGQbGdkr
	b/WihDEAi85XnNUzp3DYueEtITRBY8s0p2UGZ4nUFwzlnHnGVKayseJYWjUVx1nIP5YBDZ
	FW7WHcTskc6KujDs1KJyCMGEIXUJUrU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795172800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZxxrJ4+1dwaaCLrNywuHc0WppGGCmAO28OQpudFtxs=;
	b=YvDKYPpeJukp1fEHeKNcP1H+RMnzqMSFE3HwnwqgbKfZ4OgLOyGBlhiNn3U4RaFbxU+ao3
	5u2QPDlnUDeRjYC7eZ4HsrTHFwC93FjwbbrK2iBFg37NUWh64cIw/VFcCO/J+v1P++3oeI
	26TKNBbc7yregQ00KA37+1nRoYsojys=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VHF3XKzl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ED1861D24;
	Fri, 20 Nov 2026 11:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0579D1F000C0;
	Fri, 20 Nov 2026 11:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795172798;
	bh=yZxxrJ4+1dwaaCLrNywuHc0WppGGCmAO28OQpudFtxs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VHF3XKzlZjjLr5PvExKP4J1emSl9Sz9eN5n+qEOjST4G7bHfY7sB2OdTgew7PP7PF
	 JL7uqHZHTOaLBbpmaNzTqMPqd976QyhOuDn3xHVVJO2PY8zBhz7q8lv+gOwYkfQX/F
	 eakxQHLcQ9CniupcoCXacCEdVRDrFXl5iYYSVfcFmJPO5xeMKM37FyOToY4CGk8JBI
	 mZaKStLUFiEqxWCjBlu7YRehpXetpaMidsq7dOKYrLnPnbuoCA+9v5FaLlIz7w7Bd3
	 iSSQms175XLXHzDuIyw/MP28l56uXr3B3lpX8ejrktP1L4XfitCmBRiCJx96kYwgbx
	 qabMNRNLNM/tQ==
Message-ID: <52b771c0-9ddf-4a90-af6d-b21e5fafef55@kernel.org>
Date: Fri, 20 Nov 2026 12:06:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/msync: return -ENOMEM if page-aligned length overflows
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Wupeng Ma <mawupeng1@huawei.com>,
 Ding Feng <dingf3ng@gmail.com>
References: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: 7i5xyesxjxi8r9fpeu41ukcq474nrtn8
X-Rspamd-Queue-Id: E22D7140007
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795172799-43426
X-HE-Meta: U2FsdGVkX1/JlOqqWaV7aqsxViFQe5WXNf4FTA2kOORO0JypTvFAMkLEIDvcWncW/ta7AVw6BKn7C9SLJVOlxrfZMesSD5TJ1tfu5eYi4LDOkhX0ufDBbWlHojXqDVC9JuBiniuC7kD5kcKmyL4dd6dWtMEo6dEKLY/1pIFZ+hOYV6lAJcAQIElbRh9dkaxDIbOg+Ra322/nJpmdFnKw+ekfICsDStyrFfAuWjR6AZkJpUCiNOJQnE1PEy2asCPeHj7q0nkMJTBvuwUY7EUhOTpwv5FxgPMPqrtIqtKHwo/f614O3y4MV3QE+zCbAUbLG8gfYPr3gmZMkecRhN6tyGm8rA6k9DwkQV79xxp/jJRHQH6GkZmi8V8cZAvt7BLzkyaNjS2HKD5JotTKrYklOTmLsEFUWO1ic8ef/Mgw2OtGO20A6wFhtKc7Bccd+wErxsiUr8w0rN0QlraWpC5k1tIgMpmvE0qWSatIKUfWiolHYFBSd19F9UTBGF/0+lhNNMIF00doni3AModJpF4hpdm5nwX9nNzfkk2I4z3NxuagTDyPdJ7g2Ft8oikyQxTR1lYx4IXPJzXRsEa/Qa7hq+JHxeE04gXY30ujbWpo2uKg1I3bFldFWo997jTbo4OIjVjSn9kkeg8btJ7xFiIH+2XEp9B0BNvxno7rI/TbWMIt2e9KFHybjcIV0sieLPQ9Wedt6TrJrOh/0MpVORSRazNxxOH6ameb8BUHW9wZnf8ybYbIPX+pQjwxLkV60Vv7JyhJeVmXDk06QTLjaiGK5wzj3zfcQ75aDlx2iIqkHvBk/Yzr0PLyOYK42Jb7rKPE+2RDQDRpuuO3YfGzTVmW/LBvxIVTT0QEw6gLqevuv02P/mz44WAwTHorxA7EbvZLUHBNU+ERxGEHxWDylhEgdMGmHIFtU1XZ6oDxAvnjzacSCy5BH46Oyp7+t0qycCwt6bI/HfmnCzOu9hNiEvv
 yte1hAsf
 gdH3IjIYCosYTgNBvkPWlpSsNm9Vs5yxl7DHXJsrUV7WxEP/BsHWKmyGc5qGbqT6LiTWRae5Kp+4WH85eEYx5G+zz/6jYBw31zJNbHQCGJkPHsDT7JlF8iBZ3rvLtTt3PNI86GdlRNyvOoi/CMiSgfRKI38PfPsO3cy5LP8RI3qBrAnTZyScPWN4f5hfkpfOayUfRfdv5UoPXqViw8ZJsaR02vqLU35nGAVHe/DwnL11txRNFcJggDQXzdlEKQFszDXvtsdwH1DtFUnRZ7QMCqyp3HiOhXDssTlYAWE5nkHuzg1GlLXqPmnVMUMgSLkFsmerq/Hiy4kVQ8JlpBz6Jio4pQIFxPCrztvn1rVk9C6r6RWMCS/4NlmHzhX+MR6XRfK4od62mlCbXeE/Coz52KMZSfk2AiX+2dl4JezmCmRlCC39BAeqCcjroXL9LqBK0lejtyBraQ7aySdsTAXqukn/ru5Q1lXTtXs9jVLwLI/+W48VRM/XbHp/KpG5bakN4tLkGyAKI3+9eqTzn5S1/UJDmqT9FdxdkK6CbX4mLC8XhgaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 11:59, Lorenzo Stoakes (ARM) wrote:
> Currently the msync() system call will simply return 0 if you provide a
> length parameter which, when page-aligned (rounding up) overflows (i.e.
> SIZE_MAX - n, where n is in the range [0, PAGE_SIZE - 1).)
> 
> This requires broken input, and nobody has complained about this, but for
> correctness this should really return -ENOMEM, so do so.
> 
> Also, since error is assigned within the following loop, remove the
> unnecessary assignments prior to it.
> 
> Link: https://lore.kernel.org/linux-mm/20230321074035.1526157-5-mawupeng1@huawei.com/
> Reported-by: Ding Feng <dingf3ng@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20261120051413.46167-1-dingf3ng@gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

