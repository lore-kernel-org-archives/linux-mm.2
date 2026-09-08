Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6FC2C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AECB36B0095; Tue,  8 Sep 2026 10:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A766B6B0099; Tue,  8 Sep 2026 10:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93EEC6B009B; Tue,  8 Sep 2026 10:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70FE16B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:30:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F7271406DF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:30:29 +0000 (UTC)
X-FDA: 85190830578.21.5DA92E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3B31F20009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:30:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RLsG+ePv;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788877827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1fcP7/pBh9KdtEegdsKqPfiQ9bBYmCGdHpPYEo3xto=;
	b=oaBZ5WLsIttsEgMAl/Pz27BU3rEgHaUwg6dT/0CFLAAvd9LhCANkj0QxY50lMzfE/NyaGb
	EOoUN/hphAlggnUA0ugFkZ+e7A8DDWQK5twRnvSxQ1Rm6gtnxC1X1aUu6ydJ124JB5v9j5
	En8j6p5l3NEgtgJHar8MwPmxoV/NaTc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RLsG+ePv;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788877827;
	b=qhNp/LaO+fXJYfjhoIgOnE/GZruHoRjbgRkyVI55PMqhkklzY92GrpEHZsA42v+82tA32G
	IU8vz9NGwAj2ac5JO94OxIi6GhdoYRziWAigmkKe6/72d/abm9ZlNSdh+ImgNKhDuIcKK2
	4OTBJazoMsoTWn4jHbeKd7cTw563hB4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 864B1601DB;
	Tue,  8 Sep 2026 14:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5711F00A3A;
	Tue,  8 Sep 2026 14:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788877826;
	bh=W1fcP7/pBh9KdtEegdsKqPfiQ9bBYmCGdHpPYEo3xto=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RLsG+ePvr3FjX3wQ6Fy+T38pvjKoC5pSHq11Uj/V5WKegnkmcAlGSriwspSUl02Vc
	 9IIAMQIczl8YBeu1uSmr1BrVMOQNqUX+jF3G6KOnsM3r/YJ6lsKXU2iwwYfrwcr9ea
	 ys3tByR95VJ6BhptNlWyccA5hb47KdnZY3zpAOInfuOKmI28tCEBTx+Zw9v6tGdjkl
	 FF82MNV7/khA6CnYpot4aLAZuT95sKKyUX4V5fdnbz4KFif2expQYCDYXLN/Q2ewLK
	 rKSAoc5nQqFlQR7l+PlxiaOzXj+h7fup7IGMMmlCp6oOq8dYM7QLSzz9KE95mYwIIK
	 MuXIef5xL7sxg==
Message-ID: <79548641-25f3-4ec3-a549-782fad168962@kernel.org>
Date: Tue, 8 Sep 2026 16:30:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: Zhen Ni <zhen.ni@easystack.cn>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907082620.2083838-1-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B31F20009
X-Stat-Signature: 15bs5fkjwf6n4564yjj4gg7opcu1b7ay
X-Rspam-User: 
X-HE-Tag: 1788877827-348650
X-HE-Meta: U2FsdGVkX1+pYV8mzu/PhGQ/JZbFtL7+Z5CYtVyyKlg26q6morulHNk7LUD/nrpkcwHNHOesSHfblfJblHoFMLDjX7CN2viHZSHIrzKuFK7f/1prtXrgaBN7eGRSgQuQhhZA+MXFN/gW67qL7tb/ujesRheyIdn1YFhXHV2rYJuv+ku6Ccz6ArTOZBm8iSdTwVT/7iCDvG0dterQCNYQIKGAqd3w2Qwt+k9Ke5F63VrW/1KzuOyKM2C4nGkHV05HiYNvRDH6StgBLTaJPpe0CiN5tUj2vZtQj0WLeFoUYxXLt4tAtlF/NdrXrWY9i8j6wakCGWpCWVWPdByaSguGkmvMwwJYZYt1z0/tCy+/9ToySWsEKWO/6mb8YjThRQBt7wFAeoEG8UokgSFiAjtbcaKhr/Us8m+0NkzMl3TKZKYEw2yHKFSuBSKtPT2/vt8CUOicsddVVCxIvQEIHLRuTmc8vyh+onvzCSRaA0AJz4zVjmTEi9SFyhKaOFV+VnGDL0YEmdTxOTcK74CI8gSOjf350b3Ezb2wUzScO6REKBJajyICL1OHDn+/sEwF/18Gm/Xd5PqsbAlorA6TbL9FZpbFQPxw015Q7mMDx+nxjw0Ojg4eQGNpxttS/VgN7WYBWmUQw9ewv3GlKFLudn87YMFtKfgVIsj4mcM96jhRoDabel/fx/I7oWt/vykA424DVkBGtbJKIVrclDH1lC9FYUidxiWEnziDfuZiJrWJHUaXMwG4CBvKN3InWzBSt7/tMCPQNRrPxw5GGL5ybScc+17Ygu+jnkjWoi+DdmFZH5BnKnroWk+PDiIKE2tf0dWe/Krpz12T6eeNtMgmVFHcoxZnKJ8iM09otPDB5kgn9K55O24273k5QzWWg1W+WKKYnD8Oj0jVnHgi1TZqNxYK2kgVxILZO8uf/+gkb+APNI+WXy15BfIdIMM7nVYC1qNaNaAX6r92h0fqxBoi0Vh
 cq4LCaa4
 s7B22wMckr3fpfxZXuks62xqkmMvUogqMEks6qeUOVQwnPzI5h0/As/w4lJ/USnQ/zi/ba2mu6fsC7nQIU1lXEGHfCeWKfunG/LL7kzCRoU+4rcwtb4TiKANaKH8zv0l5tIlAjlr2MIV3X18ppgQKlaIrtcSGlvGU/b8GEIKp72F6Jl0lLVzvRZKzNXcA3k+pT0wsgwUR8SUNIH3TVwTXDjNCv7R7ZHpIK3YIlfueyI/x9OWSNfIkQmNH8AJH4Z2DtfDqliClny3v1RFt32H9YO9jfNdpOws5Zl4ARxTYPnEySNn3HJGgZuEBp9PGzA2DN2VBSHcaD+7nsPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 10:26, Zhen Ni wrote:
> This patch series adds process and memory cgroup filtering support to
> page_owner. Following the previous series that introduced print_mode and
> NUMA node filters:
>   https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/
> 
> This series adds filtering capabilities to page_owner, allowing users to
> filter output by specific processes and memory cgroups. Users can now
> filter page_owner output by PID, TGID, COMM (with wildcard support), and
> memory cgroup path. This makes page_owner debugging more focused and
> efficient for tracking memory allocations in specific contexts.
> 
> Targeted filtering provides significant performance benefits on large memory
> servers by reducing both execution time and output size. By filtering at the
> kernel level before reading, only relevant page allocations are processed,
> dramatically reducing the amount of data that needs to be handled in userspace.

page_owner is used for debugging. Why do we have to add kernel code to make it
faster?

How much faster are we talking about?

Or are there other limits to actually implementing it without kernel pre-filtering?

-- 
Cheers,

David

