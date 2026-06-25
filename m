Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86073CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE806B011A; Thu, 25 Jun 2026 07:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785676B011C; Thu, 25 Jun 2026 07:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B8C6B011D; Thu, 25 Jun 2026 07:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46F956B011A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBF881A0558
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:53 +0000 (UTC)
X-FDA: 84918220506.20.528830E
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id E1A49140006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MJAkYwyH;
	spf=pass (imf09.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387111;
	b=s6HwTza5rwCjplxnyYZ15GuEOyhjbBHkqzCC3A80Rr6oTQqjG7Ld7EejlDwJhNzuO8HRIi
	vmhHI0yjXhK9sc4VX6+rIRAidloJIxy3QqbQs4aEp1I6fLXYa5YmDmdmKWM2vS5eDg6GNG
	BSfCHYEXQ+qGuzIm56NuZq5uIBIRvCE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ok1cwbmp8dJ1uoK/AXAMwxzmJvYss0SZo3EXCeeNnlE=;
	b=gQBmI0Il3u+j3gAQStk1ucyHgOxjkrrkP7YhtfOpfgibQ9okDZa8DG0u7akySKn1TeViRy
	nIa0rNuIGQNHIUoAj9CyBRWWeBxtM25OiikKgII3wCd6vQ/2WBycXYTv4HxWpyTdl5V96P
	59ewGLFqjiJT1nodV+5Kci9Xx+VIGdQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MJAkYwyH;
	spf=pass (imf09.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c85a2c012e5so885233a12.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782387111; x=1782991911; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ok1cwbmp8dJ1uoK/AXAMwxzmJvYss0SZo3EXCeeNnlE=;
        b=MJAkYwyHBAprjmq5alv6SoZ/Ab9TOuPtH0ygIWDjkN7Ca2dMd1kwB2XEvMuJdONul0
         F4pck8qH1n9f7Ls7F6Xs6LxyhV9tAXjBqtTxgVC27u57+UfjjbrY79V4Jw8xIwOHsyWy
         FiZqEWDOkkITmFIsBFStFzlOKjQcA0ZB1wr3cgZQDYqqCk/A06sEBLcncTZsUBh6htb6
         KXat37tH1/QCbYWxx8fonlPYjzu4fXED3QN1sSGx/FM8MSyFN3U6gGukFjjBZtBDirDY
         aw1JStJm8by0HcdT8PfXTJkzMgj2yufgzNNVO3/GZ+nkVNEW6/vmz/+8l3Imgg16dxPA
         uXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782387111; x=1782991911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ok1cwbmp8dJ1uoK/AXAMwxzmJvYss0SZo3EXCeeNnlE=;
        b=sDRk/3cg/a12w0TPDKR9WOg2krhUL0Z3NMZYn6X4F1eq1SdFA+BaUHilaRKmJ6iLyf
         5dLdwlKp0oSxdz9N0eqXaIY0pAFMY03IKNwxYg/0yUtbq37jF7e5XmyPtFgQlV165IBo
         EdKqNfd5Ea602/0Sk9cmAYxvA1ngM/u3LLBqpJsW+l4V3hzgDO6Cxz6s+RHVqDcN1Rgs
         O6FYC7NNGfIwvtv8eNTZiDXhYEFjBXdbUHdyfOwzZNcMNZsdK1d/sbSWd+piGD73x+y4
         y0g0H0Pk34Ggzdjn8829vMosZ63xQqrLy88e2uHM/Eqqqj0Xybzy16H0+x1l88Z0lxey
         EHPg==
X-Forwarded-Encrypted: i=1; AFNElJ/3ftSUeRfnadMVsGKZNWyNvaDsEKsVrDwb3g0Nmgv3V+8MWFnasJGAoyiOijh5bVxLPW9H5nwO4Q==@kvack.org
X-Gm-Message-State: AOJu0YzT6oThKiXA1eM0G4p91lHQaZRLB2tM/FnKZ+pjBFNMNUfq4yxt
	xrFMmu+sU1AchCtncNpUn2mPMxzUadN33rtU7zqS32hHz5hA2OAcns2F
X-Gm-Gg: AfdE7cmt0XkOOvzvPUCcel7hS9pOgbdb7xB7UU6sd8POqlIr89aOaWEuZxxZEX6egYc
	cbbMf6gzMlO7aeiGQC01xLQnXKvifDTMGvnDgE/qEptTn1VjoKE5PjJYEEZwaAHk+98iSJ29iqn
	1ARIVnc6HIVKUM5bc6a8crRuanslQBGB9roCtwWyJXl+h9j4/ukpof11L+NF87qLrkO2vk9hGw5
	olPw+mPjSFB9MHQIKqSS2y3+eg/d+Ax2h8nYp9E/FHU54zgC9C3UemVdxzgmlN96qEY8vOcEx5B
	8sfFNoMHC/vnbcaZXic73+NX1C/8MmKhtkEYEIcdt5ReYoTur0bpzrpBWNaZ6NS6XX1G5LXRlRv
	yj4J8L5mE+QC2ZTw6+bWNYon2U+uK1VjylWGymz+lR5dOTPbmr1n4XOinFNKtGnUEjOiQgNqd4D
	GRMpbZHmXRVnyn/MkClfZDBJYTt01oigWr
X-Received: by 2002:a05:6a21:9d45:b0:3a2:f7bd:a9a5 with SMTP id adf61e73a8af0-3bd4afbcefcmr2587154637.38.1782387110797;
        Thu, 25 Jun 2026 04:31:50 -0700 (PDT)
Received: from [10.125.192.89] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c92bd26a52esm1482636a12.29.2026.06.25.04.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 04:31:50 -0700 (PDT)
Message-ID: <1358cfd4-7d3f-1238-e4a8-b2301dc16702@gmail.com>
Date: Thu, 25 Jun 2026 19:31:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 1/5] mm/zswap: Extend shrink_memcg() writeback
 capability
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-2-jiahao.kernel@gmail.com>
 <ajnB8IZrFZwbIr9P@google.com>
 <d0f05c35-457a-4b2c-6faa-7a83d4bdec01@gmail.com>
 <CAO9r8zMgaqP=n6rmhnMU+qhp1Www1Y5kdbLTLX1v=fj_ybHyiw@mail.gmail.com>
 <057ea303-4c27-1a6e-08de-cce26c699097@gmail.com>
 <CAO9r8zMmnYkXocZ9Fb9DL_rdAHt5xtT_FLMxJD1bHcM3B4wTFw@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zMmnYkXocZ9Fb9DL_rdAHt5xtT_FLMxJD1bHcM3B4wTFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E1A49140006
X-Rspam-User: 
X-Stat-Signature: p5hhtubaxbzpnjzd47gsotpwushn87si
X-HE-Tag: 1782387111-705732
X-HE-Meta: U2FsdGVkX1/TS6uHvGTUkZKwGTxSOczNZp3haMr+1bIQ9zhBz6qgokaRPLtKfO2NS9l+p0tJVCO7oyf8cZPaKdK1COwVe3PduzVa0iUuWwdBZhcMuj+9VhRNfrYJack4yISdlTBKLrSqPYQwFR7mBCTdBvPactOr92QLybZPX/i2GIx4cthc85eKyVPgmOSC9GD15gXPbAaB8pIfnwtBD6OOe/nF/TLl20TqGjc7ze+BeN0iFAGKAxbfp3NP7ikIAM+50DTvNWg5ICB65vQC/CYhI8/IMgAGNVH2T4/DbDofDGvE0gGBR33dmuzCiKCoSJTj9NQ1uopLxO45pTCUsirWgA6qhMBS/g236XTvx/vK5DUuntECWQR0Hnjp+ivWfK71vQKFsRObzIyjfDuDTyVAJUbGLbb58e/dmvTNCe1O6685AlZ2RQmFVmq63JRvZeFimdQn0vyxmuOQmSupJ5xZrTNkWro4YEa81uiOAPYpq+pNqYDBs/YjYMxwWY8UA0h4GJl0R2G6dBzzjm467RUA/XHHBNy0dW12bsQgjUEsSbEId7Orn0mvb7BkA9kuF3qRxqw8BfwhU1n8o2l/q05J9ipjLLtHEpyXKXP0s9IzYNWyk8Peq6gItvsp3fAgXtlvVr0t6kFmtd1DOyCM0t25Q5xS4iMrFUm/RYApWI6wpOigybTwiZPKWKIhHuUSYOmLxpoLpfUPhDimlDl7dFW9ggSzYD9Af0ZWJ3Rrx4LoHSx+i+KBxGjKHzS/zoaqRrkQMUKAdgy7iImUey/2lU9aAtfi1SRrCJzInWvSzRO5cgYy74jbEDniIpDsTmdZlA6EBe14Yy3Qcg4yDLBcyQ9x3LtM92Bbm8rzkU397cPN9t5EFf8bDnD/OUmh3dYyA2rwfPrJlunGLk5m4X7NwL9kwWQoAlETztLAj37p+4fIjYu9pLoaeDKQmucKXgaXLt+ZIKF/BTb265l2fmz
 0G+dl3pr
 c+4UcypTfo6nwaUSuCtRh+LxOO5FwL4V0DdJU4MkGhYEJRD8m7/UKh9BtYRDaXZDpHuJEWksRFAVgHua7LLq6oPzsufbN23xWuZw9bo2+OmOmC2uEvMcIZkTLu4vbgjKjE+/cBMYrQToceIGR5b+T9QQjnNKNwktmXbGIESTh8YzMlua1GSIH4BnVIGpYMbwS0ktFbzOOdtQaACqAXF7J7Aam6eFKGdAKz2tdZCYfH6ZFnGqkUAhoazx7eDVGSeeUoPS+fRBrxQCu64rKjq1j8xKBN5RPKWiR8JmslSS5MwBcPWLjdTvXOnQTh1lyOi10HF91ZcEE9eGmJw5KJb8YGP3cDxrL+V4LLLHlg1xpXsTMT+3dBNgeegQNuxXAbFc2dDqCVBdjXKPp5d9WlRUFiaA+492czSP6abedPi4NsUqwJ78bj83VTz6BzNekFFKORJR2nKSmQs0wXGgax2HVWRVf2WbskX9tOJ3XIKSoLOlc0ok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/25 00:57, Yosry Ahmed wrote:
>>
>> /*
>>    * Scan up to @nr_to_scan pages across the per-node zswap LRUs of @memcg
>>    * and write back the reclaimable ones.
>>    *
>>    * Since the second-chance algorithm rotates referenced entries to the
>>    * LRU tail, the per-node scan is capped at the current LRU length so
>>    * each entry is scanned at most once per call. It is up to the caller
>>    * to handle retries, deciding whether to scan the next memcg to complete
> 
> Nit: "whether to scan another memcg to complete.."

Will fix in the next version.

> 
>>    * the full iteration, or to rescan the current memcg to drain its zswap
>>    * entries.
>>    *
>>    * Return: The number of compressed bytes written back (>= 0), or -ENOENT
>>    * if @memcg has writeback disabled, is a zombie cgroup, or has empty
>>    * zswap LRUs.
>>    */
>> static long shrink_memcg(struct mem_cgroup *memcg, unsigned long nr_to_scan)
>> {
>>       struct zswap_shrink_walk_arg walk_arg = {
>>           .bytes_written = 0,
>>           .encountered_page_in_swapcache = false,
>>       };
>>       unsigned long nr_remaining = nr_to_scan;
>>       int nid;
>>
>>       if (!mem_cgroup_zswap_writeback_enabled(memcg))
>>           return -ENOENT;
>>
>>       /*
>>        * Skip zombies because their LRUs are reparented and we would be
>>        * reclaiming from the parent instead of the dead memcg.
>>        */
>>       if (memcg && !mem_cgroup_online(memcg))
>>           return -ENOENT;
>>
>>       for_each_node_state(nid, N_NORMAL_MEMORY) {
>>           unsigned long nr_to_walk;
>>
>>           /*
>>            * Cap the walk at the current LRU length to ensure each entry is
>>            * scanned at most once per call. Referenced entries are rotated
>>            * to the tail for a second chance, and this bound prevents them
>>            * from being revisited within a single call. Retries are left to
>>            * the caller, which can choose to rescan the current memcg or
>>            * move on to the next one.
>>            */
> 
> Nit: Make this more concise since it's already explained above.
> 

Will fix in the next version. Thanks a lot for the review!

Thanks,
Hao

> Otherwise this looks good to me, thank you!
> 
>>           nr_to_walk = min(nr_remaining,
>>                    list_lru_count_one(&zswap_list_lru, nid, memcg));
>>           if (!nr_to_walk)
>>               continue;
>>
>>           nr_remaining -= nr_to_walk;
>>           list_lru_walk_one(&zswap_list_lru, nid, memcg, &shrink_memcg_cb,
>>                     &walk_arg, &nr_to_walk);
>>           /* Return the unused share of the budget to the pool. */
>>           nr_remaining += nr_to_walk;
>>
>>           if (!nr_remaining)
>>               break;
>>       }
>>
>>       /* Nothing was scanned: every LRU under @memcg was empty. */
>>       if (nr_remaining == nr_to_scan)
>>           return -ENOENT;
>>
>>       return walk_arg.bytes_written;
>> }
>>


