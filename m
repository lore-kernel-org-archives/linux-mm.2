Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5938FCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2476B00A0; Fri, 26 Jun 2026 05:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2036B00AB; Fri, 26 Jun 2026 05:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CA46B00AE; Fri, 26 Jun 2026 05:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E84916B00A0
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:34:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B1111A03B6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:34:19 +0000 (UTC)
X-FDA: 84921553038.30.4C75AD7
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8953AC0003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:34:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Psswdn2u;
	spf=pass (imf10.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782466457;
	b=pZ2wqh9VMum48tuTfvYYhoRceAHj10cx73V+GQNEAOfFCzQj5Bmo+3Eh6bjUr8EteQlDLO
	duyur+KfumxrnO+iCLTlVtCrM/l7zn4B1/JjRqfyxX37PcQpqyFEJf0c70xNUoX063gdH8
	imrQxYGS/iII7gQKW+VQD2RKZFuFLLg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782466457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6q0TWmjkzL+X7mudBOsj/WPO6I7LcjT/WtCR6sSA4M=;
	b=wWu/51bEIzk8wdQ2PzzBPuRGjSgxaJaUEW2BFv2mOtFDvtGHX2ajEo/BNgJ8AYxeH1iFeO
	gatv0Z1haOeXNDaG/kV+IjpGV+QMQICiuz7knBtqNRPD3GgjwiOYYrzTdwD55s1+0nZyho
	OHBQM5pPXtYbkx9hooyMhDJjyrohCyo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Psswdn2u;
	spf=pass (imf10.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c81d971f9cso1956955ad.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782466456; x=1783071256; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6q0TWmjkzL+X7mudBOsj/WPO6I7LcjT/WtCR6sSA4M=;
        b=Psswdn2uiaedeqbk/6M4NqEqh6mZ5GwaYbqOfwgdw94gjUyip7A/AfAM2ipLhFI2IC
         ioRIMo4yOoDAZD14ElVDXDrd69VjhBi7EiX2ZntLe2PgX1vGtr3iMWuoq88obNzDqf4Q
         2LSc/IrLIB5eV+V4gw4/iSK0CbMR8ABhcMHJmEYerdqOMtViAEXDipP+3O2ruQzWY6Oz
         dLbYEfc4nRz7lGaED1cYloCC/GsIDhlgmdQF+Kwg1EnwnUMnPJEjY9uzjLiatUMLEfxG
         PgqSiGpzz0yzt1FeHuwwuIwF24trpK7bCjvNtptcHxo0GXdrRrMQFCQV763OjCuosCJK
         w/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782466456; x=1783071256;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/6q0TWmjkzL+X7mudBOsj/WPO6I7LcjT/WtCR6sSA4M=;
        b=JSXNgQySjxL0+iFXH/frNZbmZJvdxFhkoQa2DOYLgjsSWPDURpx3daLhuCQ+TpGYLG
         ajm/LXs2osybXjqYpO9Mae0qvAsvMP5ZwpSoKCdpsXXbyiKVN7D+RPuv8o6so3Mdz8oz
         1E1q1TDEXNcF9h1EX4IBuI0y3+RuCE2MHFROe3N1Onlc1vXueLjYpMJeExyjgcIW0j9e
         3EFk579gK6pNz1yCuBxKl6b50X1I4M+wk4sFdHS1/BbjThJ7aRKsKLSSy7cU/XXVjzuN
         qKBPnSTysNQiYpMY9+aS8958ty4D5vaGOkwsitOOy7VigXdJYfu9PLLn0KriEJdl+//0
         yyyw==
X-Forwarded-Encrypted: i=1; AHgh+Rp0hP0BOkUP8yZo/QMQ+dLM02/PIA0kjNFX9pqhsP0wNe2OGlp2sT5J7ccEysfozrcOH8EFWKFNUw==@kvack.org
X-Gm-Message-State: AOJu0YyTjtGv8jDLa0JxGQNigTbHjtOlgpLwdQntNd/aHS+Y1Wc6QJv6
	5US5zsNdYSztHBsN78qtM3+kMgCBsQgaO8KgyRtgFiKy81PTg7LZcwuK
X-Gm-Gg: AfdE7ck8Z3+BovtYnt4PPybhgg4lbEGZ1xHVCrq5cU9EsznHaYoMV58wqHv29/ejqvy
	4C8OKrjaiZiVB1MvHgRkdnrkV3g2fSp6TZsEDqfHGhExDEVwWxVBvWjLPsZkzXPkpH/IXAcWvTy
	766iohJcyCzyjNRE32ftv/yEmpKvF8CJ5eC96Q/BPHx+78afNoOO+EP0/qjkQyUkjUSGG35mSer
	qSupcr+tsG5XFlXX+qVwb8/NqDYWx5thO7MAWQgCSKffoe8d6X8nt5Y4ScDsOnOch0ljqWkNVsx
	zbSbMCj0mC9X071uIWZtKjE8nX/lBVkjeYFN/Y3M+pnbTr8mMXCIAfpmvwHF0TmzokJQIVqjXR2
	fDEMJ0rFAGKBQ/5Tk3fc+BhKbLdOfwIhJ3nOwnkDvETB/Ag5IJ9P5Ro41qdSv+olDUNT5odQTAK
	RM1z8GBfE9azoOeUe8PGT9ZUV3FciP7yU2
X-Received: by 2002:a17:903:946:b0:2c7:c385:c5a7 with SMTP id d9443c01a7336-2c7c400fd16mr121554335ad.26.1782466456241;
        Fri, 26 Jun 2026 02:34:16 -0700 (PDT)
Received: from [10.125.192.89] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f65082ddsm35597065ad.78.2026.06.26.02.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 02:34:15 -0700 (PDT)
Message-ID: <f1cd1ec9-48b0-1b03-0514-6c9958f3c77f@gmail.com>
Date: Fri, 26 Jun 2026 17:34:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 2/5] mm/zswap: Factor writeback loop out of
 shrink_worker()
To: Yosry Ahmed <yosry@kernel.org>, nphamcs@gmail.com
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-3-jiahao.kernel@gmail.com>
 <ajnGTt8tkbAWX8Oc@google.com>
 <0916e673-861f-b472-7417-afbffbcc98ad@gmail.com>
 <CAO9r8zPSZLaqLXw87V3q4tZa8WD7xCympKqfLMLB+o-++GksJQ@mail.gmail.com>
 <91297bc0-268c-e9c2-57ae-6066eee5df2f@gmail.com>
 <CAO9r8zOYgjbuG5i+LrCcMK764nVpOS+muo-5Q45ZFdiVus-dTA@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zOYgjbuG5i+LrCcMK764nVpOS+muo-5Q45ZFdiVus-dTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 761okuaai84x9qna1165igunnf7m65wd
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8953AC0003
X-HE-Tag: 1782466457-573893
X-HE-Meta: U2FsdGVkX1/R8GKdr2lzr9F9oHEBO8IIpXFZBYjjgv/Yvwr/g9jX7SkUIBcHMbKSxcV9eoF0FD5ZgiQe9kKoVJz4OEbieQtHCPUyg4KcjaC7sMAk9rvQp8iinwTq8tsGPj5y5mVoG9G+yAzqsq3Xx1eMhHTiBuGVqTSsxUaQ4K88SA3kVEaK+2m46QAWcfj/lf/eAIaXuUEQgvvDQUWKWr6Zpl0SrsLpDjeN/m6s38YOMDSyHqHKkemLzaXJDyiEtFFGiLNPie3YBLn8EmAdI0tiaXkQPgDZnxhRysl35fh6Yce8Q2xgQLAgnXNX+CEHk1BKqi7quCVmsQL/lZQjyU4qrktRRluarsYfGUIT+jkfHDPVxiEymZUpXfRbpLsubF9OfNnFbDw+wxhM+WBAO4ENiFmWBkY6XPv+eHKeNqdmEeOH7QrEJsvhNxTnAExtOz6yEjZu5OXeDKfyRXCbC+M0+RdjsIYKG9+QPYABRYVYYw0+6AihLbxnxRqfUrqWLXWiJWOisepb3EBUobupujlpNCndmO7u8oM0jfllbTu1vHY9bHUZyCxaJBU66mlPf99CrM/tOob+LqFGxpIdR1mlC0nBb274GcK/srlX/PqYqL9B+VvaqLFI001SjXbfwYqp3OkEfm01mWpfRh2K3eV6wEgZBsYD/Cfbzu9H1/Eq8B2hwQl7/V4xahmMvfwVvgmPrsh4NwSIVVO6QW8YIut4iYiVqzjO6v37JxAGz4tTLTfw3YksCQ/G1K07NFaqgsZCAF7gBOvYqRBXVQTxOjLvCaZnpWZwZNtAAPWo0oIPNz5gQrVo3OMyp/HV95FPtTmfVOfaRZ7daCETBSQxbm2qCGjFZ8/aVahSuNx5361GGVzXU5W0rJFWkRqqwmQFTnr8HjbsC0CIVu58gmaW3cvDVOoOAXUnQeo6HHhlqOiPEtVT2eni+TKTxUt4W1S7hM28kQclT6dQ+rYVO+1
 DjQ2RQOA
 9W58sTln7ec4Nrv0Hpp0iY6bBy/tSAEIFv8N7rwMGOmA7cbVU5FtVnlCJKC4fM4tArW1MOqvTSZajIdzixsPdF2jm5zRv2ErHsKyB/B0ovUZm/APqZAxdzNQXa6YywSsrPT/jGQTqW4cfRENghRIBSyVEn1HdehpYqSc5L8fG6h5BCtkrPC5rb65BEU8+oMWEHZwcpOPEiSBtknqSR3xId4CM5k+Fjr/zk8TSzxPW5T6OdJ10OagQZQb+PSwPM1WmrQRPjuZDQHktM30IXOcNmh+2rl5JOHgJGbgKIScFFWob/3DxwfAw72EkVnwBHnJp0PUDvuBvLJ5Hniz56KidUgaLv5FzLXrNQ9uS4+o6gwGABmuh4Zik5jhi/7WwVz4t8qz2UkjQvB5KgHBE1q2CplGTnBy/EVM2eXkIgCm+giBJVk+giKbrU6G7gKVyIwT2Z63KOjnnW2qGG3TW3nHcshNhcAhRqbnUzhpF7ddOfGQt2xE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/26 01:59, Yosry Ahmed wrote:
>>>> static long zswap_shrink_one(struct mem_cgroup *memcg,
>>>>                     struct zswap_shrink_state *s)
>>>> {
>>>>        long shrunk;
>>>>
>>>>        shrunk = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>>>>        if (shrunk == -ENOENT)
>>>>            return 0;
>>>>
>>>>        s->attempts++;
>>>>        if (shrunk <= 0 && ++s->failures == MAX_RECLAIM_RETRIES)
>>>>            s->stop = true;
>>>
>>> Do we need 'stop' or can we just return a value here to indicate that
>>> we should stop (e.g. -EBUSY)?
>>>
>>
>> Perhaps we could return -EAGAIN instead of -EBUSY? This would align with
>> the semantics of the memory.reclaim interface, which returns -EAGAIN
>> when it reclaims fewer bytes than requested.
> 
> Hmm but -EAGAIN tells the caller to try again, while here -EAGAIN
> tells the caller *not* to try again because we exhausted all retries?
> 

Okay, let's go with -EBUSY.

>>>
>>> I think splitting the shrink/retry logic over 2 functions makes it
>>> more difficult to follow, so yeah I think fold
>>> zswap_shrink_no_candidate() into zswap_shrink_one(). Then the callers
>>> only need to iterate memcgs (depending on the context) and call
>>> zswap_shrink_one() for each of them.
>>
>> So, something like this?
> 
> Yeah, something like this :)
> 
>> /* Track progress of a memcg-tree writeback walk. */
>> struct zswap_shrink_state {
>>       int attempts;
> 
> While at it, I think "attempts" is really the number of scans, right?
> Should we rename it? Maybe "scans" or similar?
> 
>>       int failures;
>> };
>>
>> /*
>>    * Take one step of a memcg-tree writeback walk driven by the caller's
>>    * iterator, and fold the result into @s, the retry bookkeeping shared
>>    * across steps. @memcg is the iterator's current memcg, or NULL once
>>    * it has wrapped around after a full pass over the tree.
>>    *
>>    * The function returns -EAGAIN to signal the caller to abort the walk
>>    * after encountering the following conditions MAX_RECLAIM_RETRIES times:
>>    * - No writeback-candidate memcgs were found in a memcg tree walk.
>>    * - Shrinking a writeback-candidate memcg failed.
> 
> Orthogonal to this patch, but I wonder if this can be simplified. I
> wonder if these two conditions can be replaced with "shrinking a memcg
> that has zswap entries failed". The "no writeback-candidate memcgs in
> the tree" case seems like we should abort right away instead of
> retrying?
> 
> Nhat, WDYT?
> 

Perhaps something like the following is what you had in mind? I've 
drafted the implementation below to make it easier for Nhat to compare 
with the previous behavior.


>>    *
>>    * Return: The number of compressed bytes written back (>= 0), or -EAGAIN
>>    * once the retry budget is exhausted and the caller should abort the walk.
>>    */
>> static long zswap_shrink_one(struct mem_cgroup *memcg,
> 
> Nit: zswap_shrink_one_memcg()
> 
> BTW, the existing writeback logic has been broken for a while now when
> memcg is disabled. I think we constantly hit the !memcg case and run
> out of retries. Not sure if your patch changes this in any way, or if
> you want to fix that while you're at it :)

Yes, I'd be happy to do that. However, would it be better to submit a 
separate fix patch or combine it with this one?

> 
>>                    struct zswap_shrink_state *s)
>> {
>>       long shrunk;
>>
>>       /*
>>        * If the iterator has completed a full pass, update the shrink state
>>        * and check whether we should keep going.
>>        */
>>       if (!memcg) {
>>           /*
>>            * Continue shrinking without incrementing failures if we found
>>            * candidate memcgs in the last tree walk.
>>            */
>>           if (!s->attempts && ++s->failures == MAX_RECLAIM_RETRIES)
>>               return -EAGAIN;
>>           s->attempts = 0;
>>           return 0;
>>       }
>>
>>       shrunk = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>>
>>       /*
>>        * There are no writeback-candidate pages in the memcg. This is not an
>>        * issue as long as we can find another memcg with pages in zswap. Skip
>>        * this without incrementing attempts and failures.
>>        */
>>       if (shrunk == -ENOENT)
>>           return 0;
>>       s->attempts++;
>>
>>       if (shrunk <= 0 && ++s->failures == MAX_RECLAIM_RETRIES)
>>           return -EAGAIN;
>>
>>       return shrunk;
>> }
>>
>> static void shrink_worker(struct work_struct *w)
>> {
>>       struct zswap_shrink_state s = {};
>>       unsigned long thr;
>>
>>       /* Reclaim down to the accept threshold */
>>       thr = zswap_accept_thr_pages();
>>
>>       while (zswap_total_pages() > thr) {
>>           struct mem_cgroup *memcg;
>>           long ret;
>>
>>           cond_resched();
>>
>>           memcg = zswap_iter_global();
> 
> Do we still need this helper? Or should we just keep the memcg
> iteration open-coded?

Done.
> 
>>           ret = zswap_shrink_one(memcg, &s);
>>           /* drop the extra reference taken by zswap_iter_global() */
>>           mem_cgroup_put(memcg);
>>           if (ret == -EAGAIN)
>>               break;
>>       }
>> }


/* Track progress of a memcg-tree writeback walk. */
struct zswap_shrink_state {
     int scans;
     int failures;
};

/*
  * Take one step of a memcg-tree writeback walk driven by the caller's
  * iterator, and fold the result into @s, the retry bookkeeping shared
  * across steps. @memcg is the iterator's current memcg, or NULL once
  * it has wrapped around after a full pass over the tree.
  *
  * The function returns -EBUSY to signal the caller to abort the walk when
  * either of the following occurs:
  * - A full pass over the tree found no writeback-candidate memcg.
  * - Shrinking a writeback-candidate memcg failed MAX_RECLAIM_RETRIES 
times.
  *
  * When memory cgroup is disabled, the iterator always yields NULL. All
  * zswap entries then live on the root list_lru, so NULL is treated as the
  * root memcg and shrunk directly rather than as a completed tree pass.
  *
  * Return: The number of compressed bytes written back (>= 0), or -EBUSY
  * when the caller should abort the walk.
  */
static long zswap_shrink_one_memcg(struct mem_cgroup *memcg,
                    struct zswap_shrink_state *s)
{
     bool disabled = mem_cgroup_disabled();
     long shrunk;

     /*
      * If the iterator has completed a full pass, update the shrink state
      * and check whether we should keep going.
      * With memcg disabled the iterator always yields NULL, so fall through
      * and shrink the root memcg directly instead.
      */
     if (!memcg && !disabled) {
         /*
          * Abort if no writeback-candidate memcgs in the last tree walk.
          * Otherwise reset the scans count and continue.
          */
         if (!s->scans)
             return -EBUSY;
         s->scans = 0;
         return 0;
     }

     shrunk = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);

     /*
      * There are no writeback-candidate pages in the memcg. With memcg
      * enabled this is not an issue as long as we can find another memcg
      * with pages in zswap, so skip without counting it as a candidate.
      * With memcg disabled the root LRU is the only target, so we should
      * abort if it has no writeback-candidate pages.
      */
     if (shrunk == -ENOENT)
         return disabled ? -EBUSY : 0;
     s->scans++;

     if (shrunk <= 0 && ++s->failures == MAX_RECLAIM_RETRIES)
         return -EBUSY;

     return shrunk;
}

static void shrink_worker(struct work_struct *w)
{
     struct zswap_shrink_state s = {};
     unsigned long thr;

     /* Reclaim down to the accept threshold */
     thr = zswap_accept_thr_pages();

     /*
      * Global reclaim will select cgroup in a round-robin fashion from all
      * online memcgs, but memcgs that have no pages in zswap and
      * writeback-disabled memcgs (memory.zswap.writeback=0) are not
      * candidates for shrinking.
      *
      * We save iteration cursor memcg into zswap_next_shrink,
      * which can be modified by the offline memcg cleaner
      * zswap_memcg_offline_cleanup().
      *
      * Since the offline cleaner is called only once, we cannot leave an
      * offline memcg reference in zswap_next_shrink.
      * We can rely on the cleaner only if we get online memcg under lock.
      *
      * If we get an offline memcg, we cannot determine if the cleaner has
      * already been called or will be called later. We must put back the
      * reference before returning from this function. Otherwise, the
      * offline memcg left in zswap_next_shrink will hold the reference
      * until the next run of shrink_worker().
      */
     while (zswap_total_pages() > thr) {
         struct mem_cgroup *memcg;
         long ret;

         cond_resched();
         /*
          * Start shrinking from the next memcg after zswap_next_shrink.
          * When the offline cleaner has already advanced the cursor,
          * advancing the cursor here overlooks one memcg, but this
          * should be negligibly rare.
          *
          * If we get an online memcg, keep the extra reference in case
          * the original one obtained by mem_cgroup_iter() is dropped by
          * zswap_memcg_offline_cleanup() while we are shrinking the
          * memcg.
          */
         spin_lock(&zswap_shrink_lock);
         do {
             memcg = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
             zswap_next_shrink = memcg;
         } while (memcg && !mem_cgroup_tryget_online(memcg));
         spin_unlock(&zswap_shrink_lock);

         ret = zswap_shrink_one_memcg(memcg, &s);
         /* drop the extra reference taken above */
         mem_cgroup_put(memcg);
         if (ret == -EBUSY)
             break;
     }
}


Thanks,
Hao

