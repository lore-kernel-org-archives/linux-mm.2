Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D409606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tgmZOCzA
Received: by kanga.kvack.org (Postfix)
	id 6ECCF6B05B3; Fri, 27 Nov 2026 04:53:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA0E6B05CA; Fri, 27 Nov 2026 04:53:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9F96B05D0; Fri, 27 Nov 2026 04:53:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38B416B05B3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:53:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5C2F140280
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:52:59 +0000 (UTC)
X-FDA: 85480435278.25.1A1CDB7
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id DA16B20002
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:52:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tgmZOCzA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795773178;
	b=He1GwG+Jk6C6koRw/351atod/Lzm/CS/25YSxdPRQvDxjWUv2b1liiSia1mhbqk4hGSJMh
	YWBiyemUZ0FpsF1EwZL6iYPG3lunmuRN/9uvrGJBaJs+BNHNsV3ysyFSxaER3T4c8uUDh+
	mJ77q50p8wFas1ON/sSksWZ0J4NeVBw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795773178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5pXxomQGUshAFoqI6uHcYdcJvzpozshg0czLPfcxkM=;
	b=MUz9RLkd1fUYthgkUuGUYDnjnShycl2kPontXIdcRNid3QND4OUyEb8tb2wevhXNt4FKfd
	YCECyls1YjP1m9AicPZwXYcWCf/NEe4jGxzFUh+alU2W6Uv0wNbSCTRJ2Pu5swrFUrfcII
	YJHvms17mNIKG3+8DAtEMR2KYR/BzzQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tgmZOCzA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4a32576da88so4563553f8f.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795773176; x=1796377976; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q5pXxomQGUshAFoqI6uHcYdcJvzpozshg0czLPfcxkM=;
        b=tgmZOCzAScVdS/bRsepg690BLGzGmoPnSk+xytIn6P0hOriZe8iJGltcikJlJIueJS
         n/reIviiSYkGbr3H7Jek+Us9SG+rOV5X1CX4ZOtO48nicMmlRDce8Ti3iSrscJl60uya
         Eo2zqqjBrdnwizdkN+Sji29pnxUkQ2rWSw+SNupxjFiQZFvruGF06LvW+CAzkM6U4ME/
         j5l7dJu8K/cjCDwPx/SAOLv74tnCuipAIpGg6vI26S1C/DCHAoOF2FDFUbwxKFqQu5gM
         n4uE/CtKm3yZwmAuqShQ41qZHMHNHWYlYSCZ25fJ29vix26if8GsIYQr9TjM8KhcSxzc
         eKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795773176; x=1796377976;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q5pXxomQGUshAFoqI6uHcYdcJvzpozshg0czLPfcxkM=;
        b=YneHzJP/bSEh0cekE1uXNJBTzYHE2BMwgKv12la6FMILy7DBbC0yILRyh11msgYf/u
         UGokSrvYBtbpH6lLZJbnyXwc9yZBaIKkOtuLNeIS/JqjW8xXNNK8aw3gy8ZdAH93H8u9
         oOaywmNEP632mlveRA56y0JZGqQ6CjlIwe++n0YnQEpcrEhQ7PP2GCHjBa0/CcgNf4E6
         yt/+jzx9oY5pu6RtSWjWmhwVg3T4bfqH6f23A0HBoIFNlvGotHtx9ur0tP4sMtn7yCLZ
         qFWhRSlxX61UDomheCO941Nwevj1jYibzx5FIa+wdevT6c1lnIwWrpZgfZebJLsHwoYa
         bzpg==
X-Forwarded-Encrypted: i=1; AL+hErFcbizYThEFh4qFMeuNAzTz5X79tftz6cPXylzj6qNEKze2iiYoi3cDSTu/v8Az4L6DguxBW7nzhw==@kvack.org
X-Gm-Message-State: APuU4Z9ALM3Uke4sHB4Q4ajf3fzQAgQObgFs7S/AOxcLZP49H6wkWQBd
	UOmPZIPGTPeamOOQKH2lUgDXXNjJfynts9saaZ3neEbXbsCqbmYrFLcI
X-Gm-Gg: AZFdTZedCiiug+8QkYkKzlwiVmYYqoh/t1eYhyj2Nkc54pcGWIpcpHIGuk80/YSv71t
	GgLCAOsY3XHU5fNRhm1j57hrIEMjXz6Jv9sm3GGCgb1jhYnk4xyF0+AJmdftx+h+64DOmqd0T0u
	LMICI6XTpw8OIJywvMSv54+Cj78AKgznriQoM18ZlPcOKn8WBZHJ8M/8OmNZiSvapyMgj44fEPM
	ou+/Obo73gw3yHvQ23MjGPa/lyPTqrLlgZ59MLQ/GNcPgfp3yXDNOiailKC/btseYAwLUsFzJLo
	4Zdc8F0xhioUS2rvJhHgsjbg7LxMKM6xuvtVi0TVBMHxuYKC+Ycy9KY0SUCsF5Qs44Qv6JazZ6B
	HDnDJaR0E6OmVV5pdgMFutd7VQjOdLmQ7SHYoT9IvNMoAo1Gr50dJ7RTfGr57xoUAPqkoqFnrJQ
	QQ8lFIq9mckBZxWsJ3JzGUm6ZmbxmoE0sn2nWjC6BXLbwiEbF7W70Y/7okLz0OokMPL/h1U1ZDx
	KtMyEzHCf7E7UicNse7ekRHxh6VA+QNM27mVdCQiawvczx9QLhTtNHE4Jw0UebokwOmkUmYaACM
	Q9CDWdFfvxP2Hx7G71po0PYg
X-Received: by 2002:a05:600c:154f:b0:4bb:6842:66ef with SMTP id 5b1f17b1804b1-4bb8893a963mr457766045e9.30.1795773176243;
        Fri, 27 Nov 2026 01:52:56 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b8b7888sm46119266f8f.42.2026.11.27.01.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 01:52:55 -0800 (PST)
Message-ID: <c2e176c0-1ca9-4624-9a25-7ae0d66710f9@gmail.com>
Date: Fri, 27 Nov 2026 10:52:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: track pending subpool requests separately
 from used_hpages
To: Aveline Noir <jm5905938@gmail.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Usama Arif <usama.arif@linux.dev>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Ackerley Tng <ackerleytng@google.com>, Zhao Li <enderaoelyther@gmail.com>,
 Jinmeng Zhou <zhoujinmeng@bytedance.com>, linux-mm@kvack.org
References: <20261126-hugetlb-subpool-pending-v1-1-e1831a48f19c@gmail.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261126-hugetlb-subpool-pending-v1-1-e1831a48f19c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DA16B20002
X-Rspam-User:
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6xt76iq3tk1go7ka3tx4fu4ufgc8j38o
X-HE-Tag: 1795773177-655354
X-HE-Meta: U2FsdGVkX1+EuU/mGWLmInXTRBSAnaAXHvLrazuvkGO1/v5rtwhlVVFoGNkc5RBFrICa8aZwvKGoF0nOvVXTIPiy53tZr2YYix3vjpx/yWLWGVdw9yTh8ZqqJt6IdIIvfJdEHFYRg5TchmuyS13QeGk2ZwNEwJDS0w0oXIlwCsZuojh9X538yAe2p93rOQJJWR3KOz2HO4+ASFt5yqrzAdDUPilzrd9tqVZ/aKeglRpLm6nQjJaksWnxvNY/4LCZNp1XsOW34NiN7zoI0Sd7aATxq4RCQUMhGx1RAV2MraEh9ah6Sh/2yxhxXJ5Nb1tP1J/iuvRqp2BwbRd4k6/PHo3huzFXS7zjKG6q3O6QM0DiaQxiPFdPfeYSzJZnIGxxNR5dXmxQAzS+oabvWI+26ZZ/LVgsQt11lMAsfGwrTacdv066Uz696aQSHO0wAknEUiK2wwJEKNtk8Idl9PjQ58SWFR98dN22OhSCUJQv2AQYo1l+IHqX6oJwPmv6AK3BDWGU/ncm/imTMWARZbkvapt1vbSo0hJLb+NocbUb8+f/r8+xRS82dk3LX1QPoMg7rVli27SYDjL3rdgPQFjRrwGMsY2EysrzLSmGGG+w0jE+h0yvGy3Q+LlqTVGzgs1SFQy5tFihZTJzgTNpCtqwa8xWd7lWFrx/qgVJgjrgSYZM2emuhRAzKuSvp+pVfJgaMv8UNu+0C8p4Cesc7JdSkvu/FtF2hkaZLYAH0y12LItnq0uSRcOySpPMDgzLB1qz+zySKJuZaGvVLpV5Zknef2vx6X6gaW28UGHjRLYdiAjE9lK1YbvQUJ+bXw33FyvKCN5xYjPznHCSS7lCt2BXLad7QXit6MEisyD3vSbFQQwnHMJ3XuKTwCC0jIi7TFe/EaYOQIR56y/p7OEvwigLhAiEimdni+GRClXBfDcxZRF/Wb08yWhIsIkmdopc670uvc23hMvdNRqDZZ0FdMR
 sgKL6Foa
 Oznf0P8dNq1a19OsdsJXAOXe585Iske7/oFQ6Nk5p5YdAAUdX/JZxCG2rjTG7pPmCC83YYozgwmky3ETcCJyOvX7AAcW668W5gr7aqKsVYNyw8iFIrS3ftjL5+6Y3uJkzirLfACMMeHFIyMkNPTMYOl7bY8qQmBq3iNVhMeHfitC1gzaBd2akeg4AN5G7jIxsAQykkSoeXICOidMn+zEIptgjoR6Wuw9p4yzwR88tYS1jpPMjcIXAAm48tNXe8ApHuqEaW9UTeGVdbQlLuYJfuP83C4hzBzVJII4pfZY7t478EqJzGVOAloHHoMW3JJWsMlXq5fhLvdTC5+qbO+4CUBr3a1DSULXeyWmHGLXnUhtq6aS2Gmu2rkxfsjnrKikInUGf+0U6wDBD9HZGzjkBvO3D2+nNHraLF8LOoIJ9qeVNPnCRhMq43AHhaK57E4jIxh/ODqskGINcMUyNhLhfu2oii30H9EqP773B15yeH70PyF2NlUHUSObCmuLK7gQrKtBzm+163OM7aFohOlnkMM5b/VyLychiq8ysjHhf9O1M3m7Edn8ewPfaNLq3x+/hg3fy8nFSiNLCkNQKG2mONVSAnHpNjq1Lor7s9GYhX4KtPG19N7MvBSdKlaAbefzkYff8Uk2fho7x/rPW4cSd7jzpjR8OLpWxbZHW5LAv7DjuK3tfCJ3L29jK4mHt1JV/8O8Xgfczr3+7Oo5kJMFCaQPxRm1JYjoSNUoxT8Gjvm/9exkUED2kJIWEvIr+VLsFo3o5APmwB5BsN3nn66fmZrDkI6gkfF+JZClekW0x4DOit/o15fOlPkbo01cOa7zPTcqxqN83PghXpoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 3:10 PM, Aveline Noir wrote:
> On a hugetlbfs mount with both size= and a positive min_size=, a
> reservation that fails global accounting while another task releases
> pages on the same mount can leave the subpool short of its minimum
> reservations. On unmount the subpool then drops all min_hpages global
> reservations, more than it still holds, so HugePages_Rsvd underflows or
> another mapping silently loses its reservation.
> 
> hugepage_subpool_get_pages() adds the whole request to
> spool->used_hpages before the caller has obtained global reservations or
> a folio. A concurrent hugepage_subpool_put_pages() compares this
> inflated used_hpages with min_hpages, skips refilling spool->rsv_hpages,
> and drops a global reservation instead. When the request then fails,
> hugetlb_reserve_pages() only subtracts the failed global portion from
> used_hpages, so the refill that should have happened is lost.
> 
> When both max_hpages and a positive min_hpages are set, keep the portion
> of a request that still needs global backing in a new
> spool->pending_hpages counter until the caller commits or aborts it, as
> Karl Mehltretter suggested on the out_put_pages thread [1].
> hugepage_subpool_commit_pages() moves it to used_hpages once global
> accounting or folio allocation succeeds; if a concurrent put refilled
> rsv_hpages meanwhile, commit trims rsv_hpages to what the minimum still
> needs and returns the excess for the caller to drop from the global
> pool. On failure, hugetlb_reserve_pages() drops the pending count
> without touching rsv_hpages, avoiding any positive global adjustment on
> rollback. A request that overlaps such a release now fails if the global
> pool has no free page, as if it had run before the release. Mounts
> without both max_hpages and a positive min_hpages leave pending_hpages
> unused and return 0 from hugepage_subpool_commit_pages() without taking
> spool->lock.
> 
> hugetlb_fix_reserve_counts() commits its page as well; if
> hugetlb_acct_memory() fails there but commit trimmed a refilled
> reservation, one trimmed reservation covers the dangling reserve map
> entry. The max_hpages check, hugetlbfs_statfs(), and subpool_is_free()
> count both used_hpages and pending_hpages, while minimum accounting in
> __hugepage_subpool_put_pages() only considers committed pages.
> 
> Fixes: 1d3f9bb4c8af ("mm/hugetlb: restore failed global reservations to subpool")
> Link: https://lore.kernel.org/20260927170103.2381-1-kmehltretter@gmail.com [1]
> Suggested-by: Karl Mehltretter <kmehltretter@gmail.com>
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

is it possible to do this with less churn?

-- 
cheers,
jose a. p-a

