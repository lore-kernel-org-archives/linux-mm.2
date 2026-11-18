Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B01606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GQRHehmx
Received: by kanga.kvack.org (Postfix)
	id 91E3A6B05CE; Wed, 18 Nov 2026 17:35:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7F16B05CF; Wed, 18 Nov 2026 17:35:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6F26B0606; Wed, 18 Nov 2026 17:35:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4421C6B05CE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:35:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C56EE1601E6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:35:55 +0000 (UTC)
X-FDA: 85449698670.24.C2F0819
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id D00E220008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:35:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GQRHehmx;
	spf=pass (imf03.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041353;
	b=dkMZSJ+P6Pl6P9MRY5im9RjkzTHExILtgwG2QHenuYgZs0pktYO7WZ/0qGVca2OFpmihtg
	cvc/2YD4qMYM8CdqxHeiLooJRBE6FxgZvbULRYzf91tEVFsjwSvpnZwSNUf24VLTUzJcZD
	qxVozCN2PfcO36QAfYzdXrLjfKDhgXo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GQRHehmx;
	spf=pass (imf03.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1QlJHCek+NUM+XDDyqHX4umCUytIfs6olrzBCKAfC8=;
	b=B49Sol7w1kLu7xMQE4Ci7FKEgnz0fYKzem28I8/64c54DLej+9X4bKLPXK39u8YNVLtNw/
	T3ai15t5FGLcxloJZXcBdVHs6PX4zXgdz9X2Ml0eBFbFk3EEwrQ14TTeoX5kmi3y4XXaCY
	hDMDWBMmvN5vX0NzDS1XQ67iVDV9jmI=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4a42b34e930so1270911f8f.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795041352; x=1795646152; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/1QlJHCek+NUM+XDDyqHX4umCUytIfs6olrzBCKAfC8=;
        b=GQRHehmx+ZW2GfBqz8MblMBI3aGaMYDg39990JAwR+n4Y2IV1tzNRjpdvByibUojK1
         CxxznseoNQvVfoSgsHVRtvG7//SXUR0r/qpMLQ2UkvdA3TX39vTaJ2fc9sSYRI+u/ckD
         q7zriDBUX2IvgKU/Ve3isZMWIsLGoc3XEMvKpO4mC9oW/JT3/mwlbDtdByoRRlss84wr
         Uz9T64EuRIAetbX9bOeZxYnK9f6fKOXN/51hmKKjXJmZpn+Yr1h26DUp/694KLpg2vzb
         GRcYSClEXbYtedMx1MqmL2ZHhhdQLk5S2HRPP20G38/aHvdE3gROyN8GipLhQQeNgS6A
         grgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041352; x=1795646152;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/1QlJHCek+NUM+XDDyqHX4umCUytIfs6olrzBCKAfC8=;
        b=C0EzKySRQDWwIuDFQh7Jg73ptIoE4y5RE7SvKGPipHZGzjZfttq5Hk5vTo8XEEuIP3
         3R3HW1OpH4pG9MnFqcUSWDlbwvR3i+extkRH/qSfRud96aj4kUTjewRUMMYEjcxbr9Fu
         guUanH+ovfZsUjCZE5VKJVbrtCey8EheonegDWFmiwwEVMzWf9DdQ2f55Cld3gjIQ8NQ
         vlAN+bpo3rxFiRLl81fdhvw5t2OZC6H2oB/odxdlbxO0ORrQGWA3cmt0vfiG/X8dFla0
         7yHajrwN+UMT2/VPCks6yxrKvc5D2CmYqBjhXPq+cBn+yVnMiqompZDnDa+ZtubDNJSn
         YQ8A==
X-Gm-Message-State: APuU4Z9HX6rMffUd2rBzgmO6YF19E1eAQV13TIb99K5jNa4NYMM5s5lh
	63RY5py++hTmSXmOclm7SOxoToj+h8bfdXgdd+zGmfHB5OAgbqkzH1CE
X-Gm-Gg: AYBFou2jmknv47hwmLYWe1FA7Q1eFXLNnkwnJ+eVv8Ax2xg6Y2tUKuMvCjfIsSFkFo3
	YKvwuDxC3PY8fQcHKQHm8vCHWnFKsG2IMg1Of3sQ7gXMLghvWkd6IsQMb1MuAlnr4wRUSswSQDq
	fdp67j95i3/y44ziRXta6nbhuz3m9T5LWzOL0ZM7jzxUdlbnydh5Eg/Qd3AG4VEcbRbE+XtYMlb
	ZkvjY/dlNpAB36p9cz8Pisk1Xbq/Kee1zrhvTkDX4rL+EAfBItu+ypka8ui9cffMC2kK28Q+b/7
	9NOYqndmalFCLht3IA/+vgY3brOoZqgG5KsLEEPFNz+UZvZy+FV/OKCvg843PlK2sRfq13ZNzE0
	t0rlxvzwwXTM5XG+Jk1z0Y3oEKc9CL+JpOFa+mzlNEyjNHH+pHUugJKrkEQbkoQ+ionYm5jLqzn
	U1OUazWLxniB5jyFRUOCUEWRn+npMr7tPcJip2iY1qvVFw2JDJU13a0nKwXwSfZTnyaRSrl9Xyy
	MLG6HYXYUQAzbFa1RdvbWDcuvJboiRLCxZBuUPdBSWHAa8MHaeV07qBDre8QbpLyuxUFCvcpmOx
	umzEWYuScN5QPkdriyUV3fbY
X-Received: by 2002:a05:600c:4f14:b0:4ac:da92:2bd4 with SMTP id 5b1f17b1804b1-4bb7d6cc934mr90494465e9.1.1795041352279;
        Wed, 18 Nov 2026 14:35:52 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb844ee2absm4881495e9.13.2026.11.18.14.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 14:35:51 -0800 (PST)
Message-ID: <ad22c01a-dfd0-46ac-bd51-ac5d331c9a89@gmail.com>
Date: Wed, 18 Nov 2026 23:35:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm/vmscan: flush deferred writable TLB entries before
 unlocking the folio
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 =?UTF-8?Q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>,
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Mel Gorman <mgorman@suse.de>,
 Sasha Levin <sasha.levin@oracle.com>, Rik van Riel <riel@redhat.com>,
 Ingo Molnar <mingo@kernel.org>, Peter Xu <peterx@redhat.com>,
 Hugh Dickins <hughd@google.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
 <20261118-file_folio_flush-v1-2-e9e739ed14e0@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261118-file_folio_flush-v1-2-e9e739ed14e0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D00E220008
X-Stat-Signature: r6zjobsjxcob9i5ceyktca1ka3w8di8i
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795041353-136
X-HE-Meta: U2FsdGVkX18xwS/Elb8HrlxDxqEPllJwjcb4297KPn/1GLYwlPJiCyDIYV1qi40XCJGQhM0V6iqvsNWUvjieToD+Ip/HYREtvm7mstaESjJH1Lq9g9UVCOiVh2ltnJ4T7yrbvTvbkN1Z8C0zXSjYdqBu8WeZ/xOd59qQf7vteamGfEFs7RtDOWtdwzTqqxFgsfaiTqr/cQIK9fHhGH1hIlLICrcaExPavIV/aiAOXbEZY3krTNbQ7SnzAJUJgfEKejgBWwJSPuIjsJOcBFmtMR6jVdiQaP6q6CIzr5fGXVJVfCTKtpQQcWerX4LXg6GbKF67aHBfklYYD5LgH5BxO15bVqcF17dK9Qf4ozhCnH5UnkBZtvpANkqo7W5/CiNuUqPh36VKrjF/h20Oo8D/mn9//O27r3n3rmqJE88rsKIPd3rFOpxu6FBXnsllI6UpKX2KkkhRKtSYAf+eoA87AH9npvZQ2snGgSLgAJiS8mCqK/ItebJewewEIsQBv61tsIVXyy0HG/ICgBD3i6ru5kiIWfG671eCJ0xuj39jEwErGdHatH5SMGiisyZy5CuAs9EZHpdlgSo7gHGl1EXPebGJM3l9Q+rrIzogcfQpy4hmkipzCqDTDXLyMVHuRqKxLh6eaL2dDwai1FT2FVUMDmUd4hIqdet8/lKVVHEmc/h+EmKKXnEzijUn+Gzj2kV+nB77dqB0iAUxvSHaHic0fVsGk6ojZZFv2tIedLFOzL/0AqiD4u9G8dLP9SR8ksVBelXprj/htpO2RY2cG1dK7TGVpMIyKqYHGorXXOatJNvU7ekKp+zITWwSr3CE+PziNJZKKNWlR2ek25SjDs9AlFFHnAEKaoLusEBNNZoHwNRvsEU043HxsUnwvgUF37GZBQCfltuN6BBDEOB1GGog9P3R5uRnSC8HSJbqVtOozQ6P+Nd47J7I41UdxWEihQLgD21XF0b6AUzaklmSsnQ
 GCw3Qs67
 QhzwOoB0pBCTlCwz+Fjclwj0Vbs+WKZ3iQYbgZbFS7UajvyuUDUrDUj+P+G0uUk72Q6sTAtFtvHMdT3BqHXly6FgLIFzFnRzqL0bazE4Zgw1bLrzDTrQoWXg4aMb/v9sToNLcRv7ZyWVcP2j5aiKiA9L/cv4IiBOZSGldJPm2f47LLwy81p4mFccbbtgWXsxEpkpA17kmCN4zHAcyrQR5CQBYpahszQGVQ5bASPSKjUbs2onOGLqRok1WGqSmxGqjldRPLvkRqgyq53EYz2XnYHigJEF3GPhfq0ucYOiscCZ7bXCNxzABsq7nsefbacKzqsHJRgCH4eR6dp4lK2WaPz85aAhbt7nxwMx3dYHq2qFLIhSyfeDEDmbbbnd2RndThTdo2EbaOv2CuEeAzx0IAtPgZXDWqFQtHcEDxSrzUS1asDJ+I2n0ZT99NOnsjLOTY4mUVWMu0A48WgZ6cYQRqSqSpCeEqmQz1SVrWTJgM8dE9NSsnWr169sMx9rMOAUSE6NSbDXs7XxdsrfhQ5NlpPvi1leo9Lmz/EGmGy0ssK8Ga6Ex9Hs1Qwh2Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 10:20 AM, David Hildenbrand (Arm) wrote:
> try_to_unmap() with TTU_BATCH_FLUSH transfers the PTE dirty bit to the
> folio and defers the TLB flush.
> 
> Reclaim must flush the TLB before unlocking the folio, otherwise stale
> writable TLB entries might be left behind temporarily: writeback started
> by other mechanisms (e.g., fsync) will not find any mappings in
> folio_mkclean(), so it will neither write-protect nor flush anything.
> 
> A write through a stale TLB entry after the folio was cleaned gets lost
> once the folio is reclaimed.
> 
> However, reclaim currently does not flush the TLB if the now-dirty folio
> does not get written back (e.g., gets activated or kept instead). Fix it
> by flushing right after try_to_unmap() if the folio is dirty, which makes
> the existing flush before pageout() unnecessary.
> 
> For dirty page-cache folios that reclaim activates, we will now flush the
> TLB immediately after unmapping them instead of batching the flush, which
> is the right thing to do. Performance-wise, it shouldn't really matter
> much, because folios with dirty PTEs are usually young and reclaim won't
> even try to unmap them.
> 
> Fixes: d950c9477d51 ("mm: defer flush of writable TLB entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

