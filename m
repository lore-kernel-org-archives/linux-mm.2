Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E39CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 11:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A1B6B0092; Wed, 24 Jun 2026 07:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EC256B0093; Wed, 24 Jun 2026 07:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500C96B0095; Wed, 24 Jun 2026 07:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1026B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:59:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B93D1C589E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:59:12 +0000 (UTC)
X-FDA: 84914660544.22.797158D
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85C10140008
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:59:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I9+kkofv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782302350;
	b=v/8ZdzHff4oZZ5MntHkWu0n0OF6y50Ko/j5g9QsQyQksRsqSu2v5dkpT/yEaUHgQlobmLZ
	oDMbKeFyJ7AF2Ko0B5gkPrek7DmCFMmXqzmCzjFtnlmET/axFP+UriKFd1tR+DSm/BoALF
	RWVW0gpSDkimqwI88SxIlv9WUYUPXoU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782302350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcnLe+6H7fb08Bv+rWkSEkyMo+WogFkYHLdym+VtEGk=;
	b=5xqQk5Y1YPHCHa4nQNO6nQRjifUUSlChff9uZxHMQbMCwwtNgfTwyuvoaAb3Q7TvoLkaDx
	kg5hKMn2K30N7GL/sbBib11aaWIlLuiybkEuzXvZ0kbxyt5o8J7USnKwxAsU5A2hbHQck4
	SSXV34cxtOmiSGqNAg4nv1t6ey26z6A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I9+kkofv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-37cae11ba85so701156a91.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782302349; x=1782907149; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AcnLe+6H7fb08Bv+rWkSEkyMo+WogFkYHLdym+VtEGk=;
        b=I9+kkofvaDUGqrKqOP5j8lezgCMM78dJilmYfy9eRl4DlQfpLnMBQ2PAoRuNTjBv0v
         A4c6PGaWMg1BW2NAkEZSugKiVnbWl2SwGMSJ/INle7F0AVE8qObKDy5pDOVfUN8pWZ+7
         4qLQY82iaOL+6brJE1LkhScIptN3j3pNla7SiVvJ8fj4x+ciRpOiOjeL7WHD4rVtv54C
         oJwdfu2AmLOtQeDnypSz1VyVFFuQk8gfoESeZsCl9qCkkNOWW+mmOk5Y8MD/GP+DJXaC
         yH0Ny/aM988cQT5ojz/Ep2njHd8zk5YXISCXD2A7sD6AH1ZcXDFjRauzIPmMEuLIO0u/
         LAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782302349; x=1782907149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AcnLe+6H7fb08Bv+rWkSEkyMo+WogFkYHLdym+VtEGk=;
        b=bM1hdUgHjoV5hXoVoxu8InDWWS8Kvc0ENpSyCZyxmqj+7ZV/7Pq6vsvYN34+tQQuFS
         Xv0h52zsRjnR9rVQJtkwfvd18gGe36QwzhKDstJvUufUAoKRAQkkEy+cw6WYrwNmCVXB
         OiEn0eEX2G8jalYvPK0/BZCKDM8/+knGim7J5G7Xgl/l+7CY+SewiX3y6gG1PzkYwJcV
         rRo+hrgYFI2ypFUwzL6MvXk4jmLde5mwAl3U2eMTlDBORqzLcmnOXkr7l4+ifVu74tTf
         zdjutMzRA4G0iAvFPNrjc9jLRgfNU59GN2UAruszHqquqO0V3+aLRGG2IkdVNd2AG2BF
         awNg==
X-Forwarded-Encrypted: i=1; AHgh+Ro/xHtXzjaFY+o2cSZ27wy34vxMa3N5MUvnjWKewxUQhoVCpjPfupe1KcPymij8naueULAdT9umdw==@kvack.org
X-Gm-Message-State: AOJu0YwtfTWAwnhATceZhsL1CmsQy3j0H880dAMu27kqluJynFIT7e21
	CagvQVeo+sBEtQOlFGXAYZzRJtCtczxLqkngwp+CDWYyq3rmwUHcdHzU
X-Gm-Gg: AfdE7cmP9hfoRK9JB+hEPk+dSaPiCdVQUmVOeFntf5/udKWUX4rHKoRISaUOA0oMPAc
	155uZdV5cJqg3q8FkwQUIR4KK3OOP0XQc5nqfpdLGUCFmfhEj42bWBf8KCzyhLUE2OFLK7Eo9Ry
	XrXb/W2DZsuopRtqaT16Mw9Bfgc6DAqmpWzq+vrB74eORkO0zfq01j3jRk045fAjBkEz45tgPNV
	5CS313SviksvSnxlyr2FTGrynhuuiyUHPgPa+k9yV9lVIM52Y++ZeqJM9v2pge6TzXuUidhghu/
	ACcca+0S1kyhTXhT6m3RyAKsbpYN/x26yS5wV5hE5JO4SVV/dksU7jV/m1SPPAyMPsuCFyUxMC+
	E0w5Ua1vB61VG4Sf2pa3JeonvLsqGMRmlVpKkhT3ci1wG9zJM76OZujGwGubf++zKALJ/sKSg23
	a/bTo9E0Xm1YOtGTqtzeAmw+lLNdcK9CtTWZ0H9R/DP50=
X-Received: by 2002:a17:90b:520c:b0:36b:9daf:1504 with SMTP id 98e67ed59e1d1-37de421db3emr3545553a91.14.1782302349378;
        Wed, 24 Jun 2026 04:59:09 -0700 (PDT)
Received: from [10.125.192.89] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37de3cf70b0sm2368408a91.11.2026.06.24.04.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 04:59:08 -0700 (PDT)
Message-ID: <057ea303-4c27-1a6e-08de-cce26c699097@gmail.com>
Date: Wed, 24 Jun 2026 19:58:59 +0800
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
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zMgaqP=n6rmhnMU+qhp1Www1Y5kdbLTLX1v=fj_ybHyiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 85C10140008
X-Rspam-User: 
X-Stat-Signature: oypkfkz664o1wzkeqc3ti8jwjju94ctf
X-HE-Tag: 1782302350-637449
X-HE-Meta: U2FsdGVkX1+EtVVstY05fTvQ4wy+3+eB9ptwdbLrwZDZUlCzbGnzifb4hiQyloJO9yZcQnzgsdpOuwpJ+d57ULhHIuYwsiJER/HKoKePmf/wQY74mMhb6K3kHOTRiX1qmOVOhvFI3mCwf/Faw9Z5uhQncnHWMeoRFjdp7ZgeMDm7plXJPAr0+DlGmm83VldcsltDThnaeAn/7cKERWdHhhQNdNwCTdCzQgvUABDT9Tl3nla9/Uy0R36Dwl9t825y+KWmxARZ/9xnh1UGlgjhUReVeaTdO9WA/Nl+0a0nmLCGeIYc7oq4tucNG9ttCFuIAH9UcB4f13S0+G0Bp07ny8OEflOQFM05LZ3ErhJjjnJdQE5gRR7iW8h6dj921OGnjq1dYfZu9s4xiTSRpGc635QpQP6RVDGo3sHibkhrkH3zjRIjxhwZW98Oc7EtTNRs0tnBcffQDwB12pdllX+NrC+al6s1n52lYWuIHjAMNXoQEcUVVhUoX57LhQuQJXgIXRPzFzxJyOHMrhKF74gRoZa7bJEujIfwjiYTVQcoezsPd8kAmsDlujzQ4rsRGst3rA+2tdw7u0jJERz2SgJyOgTIRDRWLMSF3DW9fDS9qtLCiJgWMMrTmZTfQ0+TSyNpP2+t1Tjn7F2VCfS4lghrSdYA9yjIdTLVBvCc94i2vu0sgcj2zbWtpRt7qTQlU2fs/zzvEuv2ffdFp724fgcZEHJSvHHx5YSmMf84ktmRcJpBrH049JNPBvEflefhWFg71xHRU410wS3od06++cFg8iuuWSqwOyvD3MLvEhITyFz/pctgnVCtFY1LUnBfJuiQvabHM5yaxxeykASm7EF5tA9dbDTEfZZoswt61V8DB6Thbw+O7vCZFds6JZ26vHUKndVVGMY2vybvZ0Bw7a2Yvh7vdFWn00ZU6+nSljcqOnLnH0zNqKE874cRNu3IlEPKowIpJF2wNYbc/Q+h5Vk
 pjOv89F1
 ZzpNpcOTw8a+GsL8O3HnwQ8SF6tPii1TyUflfbnRaRVSTQ7kDcT0Dv7TVb5lWqy+mBttAAskK3Nmy5cX2HEaRLeoG214/3GSahcvD6VWxGeVSjxn8FYY7DDpo4kewqknI5KoZWYRkLEmE6Vl7IOrx9vSe+hpitA9FL5O5s11Yxv5S9IMLCMgemj9hel/1C6Qr5UInig8GNYbjZyyub6T0vyNkIGN/wmsddojfKbXDGtJGn1nb1L6ddrTzdWoAE3iBjKImYc4TKIgYZfivWu+m+pVR2AUgF0wmwTikZ2BRMs7LcIZEiGjv6UC1bD5yNSAuqVI058+aq/7OLmUbL9+67cvhORCh4TSVNHnd5cCL5EIqoNpKYQuSrk9/cJJY6JegvnmWTlj3pdknv+/+7cvRSdXtYY1nWKlTt10guFevjKnzHgsWiwxgoaEU8LvIt1e2xpCxW9P95lGrvamhSLJCSCCadNGKATbFGvsFsG1Lc79CqaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/24 02:17, Yosry Ahmed wrote:
>> My initial thought was that if cold memory is evenly distributed across
>> nodes and we are doing a large writeback, it would be better to balance
>> the zswap entry writeback across all nodes rather than just draining
>> node 0 first. However, since we currently lack a proper metric to
>> represent hot/cold memory (such as age-based tracking), doing this
>> probably doesn't make much sense right now.
> 
> Yeah let's start simple and go from there.
> 
>>
>> So, perhaps we want something like this? Please correct me if I'm wrong.
>>
>> static long shrink_memcg(struct mem_cgroup *memcg,
>>          unsigned long nr_to_scan)
>> {
>>     struct zswap_shrink_walk_arg walk_arg = {
>>       .bytes_written = 0,
>>       .encountered_page_in_swapcache = false,
>>     };
>>     unsigned long nr_remaining = nr_to_scan;
>>     bool memcg_list_is_empty = true;
>>     int nid;
>>
>>     if (!mem_cgroup_zswap_writeback_enabled(memcg))
>>       return -ENOENT;
>>
>>     if (memcg && !mem_cgroup_online(memcg))
>>       return -ENOENT;
>>
>>     for_each_node_state(nid, N_NORMAL_MEMORY) {
>>       unsigned long nr_to_walk;
>>
>>       /*
>>        * Cap the per-node scan by the current LRU length. A referenced
>>        * entry is only rotated to the tail (second chance) and may be
>>        * revisited within a single walk; without this cap those rotated
>>        * entries could drain the shared scan budget on one node.
>>        */
> 
> The comment here is a bit misleading. It's not just about draining one
> node. One call to shrink_memcg() should only scan entries once. The
> caller can then choose to scan the memcg again, or scan a different
> one. In this case, the caller should iterate all memcgs first before
> retrying memcgs again and reclaiming rotated entries.

I have updated the comment. Please see below.
> 
>>       nr_to_walk = min(nr_remaining,
>>            list_lru_count_one(&zswap_list_lru, nid, memcg));
>>       if (!nr_to_walk)
>>         continue;
>>       memcg_list_is_empty = false;
>>
>>       nr_remaining -= nr_to_walk;
>>       list_lru_walk_one(&zswap_list_lru, nid, memcg,
>>             &shrink_memcg_cb, &walk_arg, &nr_to_walk);
>>       /* Return the unused share of the budget to the pool. */
>>       nr_remaining += nr_to_walk;
>>
>>       /* Bail out once the whole scan budget has been spent. */
> 
> The comment is unnecessary.

I'll do this, thanks.
> 
>>       if (!nr_remaining)
>>         break;
>>
>>       cond_resched();
> 
> Did you observe a problem here or did you just add this due to an
> abundance of caution?

The cond_resched() here was just out of caution. Given that both callers 
(shrink_worker() and zswap_proactive_writeback()) already have 
rescheduling checks, I suppose we can remove it from here."
> 
>>     }
>>
>>     if (memcg_list_is_empty)
> 
> Do we need memcg_list_is_empty? Can we just check if nr_remaining
> matches nr_to_scan?
> 

indeed.
>>       return -ENOENT;
>>
>>     return walk_arg.bytes_written;
>> }


/*
  * Scan up to @nr_to_scan pages across the per-node zswap LRUs of @memcg
  * and write back the reclaimable ones.
  *
  * Since the second-chance algorithm rotates referenced entries to the
  * LRU tail, the per-node scan is capped at the current LRU length so
  * each entry is scanned at most once per call. It is up to the caller
  * to handle retries, deciding whether to scan the next memcg to complete
  * the full iteration, or to rescan the current memcg to drain its zswap
  * entries.
  *
  * Return: The number of compressed bytes written back (>= 0), or -ENOENT
  * if @memcg has writeback disabled, is a zombie cgroup, or has empty
  * zswap LRUs.
  */
static long shrink_memcg(struct mem_cgroup *memcg, unsigned long nr_to_scan)
{
     struct zswap_shrink_walk_arg walk_arg = {
         .bytes_written = 0,
         .encountered_page_in_swapcache = false,
     };
     unsigned long nr_remaining = nr_to_scan;
     int nid;

     if (!mem_cgroup_zswap_writeback_enabled(memcg))
         return -ENOENT;

     /*
      * Skip zombies because their LRUs are reparented and we would be
      * reclaiming from the parent instead of the dead memcg.
      */
     if (memcg && !mem_cgroup_online(memcg))
         return -ENOENT;

     for_each_node_state(nid, N_NORMAL_MEMORY) {
         unsigned long nr_to_walk;

         /*
          * Cap the walk at the current LRU length to ensure each entry is
          * scanned at most once per call. Referenced entries are rotated
          * to the tail for a second chance, and this bound prevents them
          * from being revisited within a single call. Retries are left to
          * the caller, which can choose to rescan the current memcg or
          * move on to the next one.
          */
         nr_to_walk = min(nr_remaining,
                  list_lru_count_one(&zswap_list_lru, nid, memcg));
         if (!nr_to_walk)
             continue;

         nr_remaining -= nr_to_walk;
         list_lru_walk_one(&zswap_list_lru, nid, memcg, &shrink_memcg_cb,
                   &walk_arg, &nr_to_walk);
         /* Return the unused share of the budget to the pool. */
         nr_remaining += nr_to_walk;

         if (!nr_remaining)
             break;
     }

     /* Nothing was scanned: every LRU under @memcg was empty. */
     if (nr_remaining == nr_to_scan)
         return -ENOENT;

     return walk_arg.bytes_written;
}


Thanks,
Hao

