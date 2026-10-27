Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2285A606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=A64+ePD3
Received: by kanga.kvack.org (Postfix)
	id 2398A6B05E7; Tue, 27 Oct 2026 03:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB276B05E9; Tue, 27 Oct 2026 03:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101526B05EA; Tue, 27 Oct 2026 03:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4E646B05E7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:25:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5ED95C0923
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:25:12 +0000 (UTC)
X-FDA: 85367570064.13.1FC0E63
Received: from mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1E8B51A0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:25:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A64+ePD3;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793085910;
	b=mBO+xSzdjku37udK0CJ0U016gXwvhDMWCj1C3rRLZ/OnF6FPXToFst6Pf3W643weQ9ZWz7
	5n+Lqcq1f60iiC2xGewspV0BKMGAdDbf//eCdpdDvk0duzrSsUjC7p8BTjVmWnJI/kyARq
	g2XUsQFzkf2u3BV/QFEXiQbFwLknzcM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A64+ePD3;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793085910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYwlk5SABAXJfCGJC/CIrpBqm46Lfjo6fP+QGuM8Wo4=;
	b=b/6XG8Scn0jWegdfvW+2XZuwVelqMoMUWR9xMCl5QTLk8PVHvitkIQrRA57zvQC4z2L8lK
	Tdhph9j1W23QpnJevJ5FZt7BWCy0tRutykbVZcnISEaIiE3sql4Iy5ABJFXD10o2F+HrfI
	okaW9swaRxTjohzkE8RZs6J4m8GJgdk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3EH6ZExPcZqz0wmFi1VNDDcCIIEYlOenwQf5HgNEt+M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793085908; v=1; x=1793690708;
 b=A64+ePD3rRIeAuP/4lB71nO4+tOkGiryYLOgek3aUTDrus5Zed53htjDTY4vHmDQfyiZmmBb
 NKXLXxVXEWi6tp6rS1ZDIHUujL/XAVA9heHTfwzTokOBngqM0DYOFKsL9WoyEVZJwgFe/3TsISN
 ymlG9Ovu7hW8MYjormJF8xWQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 079adf22c9d54636;
	Tue, 27 Oct 2026 07:25:07 +0000
X-Mizu-Trace-ID: 079adf22c9d54636
X-Migadu-Flow: FLOW_OUT
Message-ID: <c42ec8e1-6be4-4faa-8175-174fd2f11218@linux.dev>
Date: Tue, 27 Oct 2026 15:24:59 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v2] mm/mglru: fix a no-op lru_gen_clear_refs() call in
 lru_lazyfree()
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <20261026084035.535989-1-hui.zhu@linux.dev>
 <CAGsJ_4z46o6fs16T0ctLcTXiinL1+0CXpvueDN1rVc2-rLT6NQ@mail.gmail.com>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <CAGsJ_4z46o6fs16T0ctLcTXiinL1+0CXpvueDN1rVc2-rLT6NQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yzea53899fnnj8zsmjyf7e6zbo5dqadn
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1E8B51A0006
X-Rspam-User: 
X-HE-Tag: 1793085909-898529
X-HE-Meta: U2FsdGVkX18wbdUfQwLJcw+ndnX/ho3F/6adh8vnM7S+ZRMOvH+R/pGAHv1eFzbtYf8aprW249InMJwTtGFPnMJt5zzQSp+lAT7rCHRw1l9Jpo2nuZSfus+JBTi4w+XI9sQER0y2Py+9PMlhl5ba+7i75m4j65eYuZPNiUg81EJTA0GdXZIgAFztvaoq7iGN/Rc6l45HrlimMLNwQtqPRxgr8icT/Zku4MFgsUyF+ZdGxY6QQYfAkrb0c8lu+CX9H1ENp/SKQZKdkMq/pl8yvysqhTRI9aafqFQedVuCWd7eSXlI70EC9VrDAAdTT7b6nBq+dKDP0tL50sFtQTVvGqq5f2CEAH3+/YXeLbyzHA8WfVbftADC0D0AynqfbvGArlIa5r7uLyMOfRYb2RXUj/1MS7RAmUJXc/mkZ1EoQRGSgh9TxJsmfGfRhbFPKkgpe7HwT/CR1yXbXFZ+OImAnJmI3HhnbqQKmrMyzrMeNTN5yvkiL+3EMvaNAgeDFoVHTlP6KxQ97Q8lGJzPrurFevYxXljfaW+1XT+5qKAsfX7sNfyF6oWFpIf43h+CHvM6py4bSZ4TaoYtzw/wOyQHh98reAUKmQ7MFrqA2sSeUY1JyOAYRpre+XNAdcYsg0DEnry23niX8EhSxqEHTeI16zXIHGaeTgPF9JMvewNv90rZGR53v8yGSmnD1TO9XAppiMwGsgayh5ramwnmlSvTXjhSTJkJCDByWae4eoNMq8VYKKfMbvaPl1IEZS+CF4sngi8gyio+JAHDK6aSAYtk9Axf8ZJWMI5xEoAHwyaIyv65GOp5ieKETs81MRHd0BK/DPMg5IC/HSWVBcMZSyjz6l7qCndGCkN0JZXMoZtLInq6kL6pNNoTAa/zNJ/XRAF1Gz6q3MR2HrBUG9SVlIMsLTzzfJNvueIwqRyOlULuSktrx7TNWocZBLjK5wczoLA2dhJRdD7hvfQ0M9CEW90
 A+dtD11s
 omUDt53rFUPPPCtTrhSQxfibMKQXmhEFWK/LBlvn35zE6iLpb5uyq/2l79IipM/qHaxr+Bl12UySB/EylmzAyXYsm0DZ1FsJJEkO+BLURCuyv2TUJ2cs2BvI4yp4RVMrP4YvV7pJyHwMYvxFo9Px9L0m9Gs6ipoVaVAexkODguK0OkCCkcu0FnEDsp1Z1SY4w+VY4mhHO4cZg/p/ajr5yqiJyGM1SJAxGISWQaPCp2z8GGnWsgAXpZkQRdo5wsNo5pxz8aGXnR6A4i98/6EZuhCbis8PqP6zx7RunJq/ZZYefFzDQ8eMFUHmw51uuew35k9zYxvDcRJaCJZVD78/0AsajGsNkdD/G2Y3PmQoB1I4kecWes3Emmi/j8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


2026/10/26 17:47, Barry Song:
> On Mon, Oct 26, 2026 at 4:40 PM Hui Zhu <hui.zhu@linux.dev> wrote:
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
>> lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen()
>> returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check without
>> clearing the refs or PG_workingset.
>>
>> A MADV_FREE folio therefore keeps the state it had before madvise(2),
>> even though madvise_free_pte_range() has already cleared the accessed and
>> dirty bits of its PTEs.  lru_gen_folio_seq() places it one generation
>> younger, and PG_workingset puts it in the last tier, so sort_folio()
>> promotes and protects it instead of evicting it and charges it to
>> lrugen->protected[], which read_ctrl_pos() uses to balance anon against
>> file reclaim.  __folio_inc_gen() clears the refs but not PG_workingset,
>> so this repeats every time the folio reaches the oldest generation.  If
>> the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it and
>> lru_gen_eviction() packs the stale state into the shadow entry, so a
>> later refault is promoted to the youngest generation.
>>
>> Call lru_gen_clear_refs() while the folio is still on the generation
>> list, as deactivate_file_folio() and folio_deactivate() already do.  Its
>> return value only says whether the folio is in the oldest generation,
>> which lru_lazyfree() does not need because it re-adds the folio below.
>> Keep folio_clear_referenced() unconditional: the classic LRU needs it,
>> and it also covers the folios that lru_gen_clear_refs() skips.
>>
>> Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
>> Suggested-by: Barry Song <baohua@kernel.org>
>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>> ---
>> Changelog:
>> v2:
>> Call lru_gen_clear_refs() before lruvec_del_folio() instead of
>> open-coding the flag clears; drop the lru_gen_enabled() branch and
>> the comment (Barry Song).
>>
>>   mm/folio.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/folio.c b/mm/folio.c
>> index 35e242b48870..ea3adb6a89d7 100644
>> --- a/mm/folio.c
>> +++ b/mm/folio.c
>> @@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lruvec, struct folio *folio)
>>              folio_test_swapcache(folio) || folio_test_unevictable(folio))
>>                  return;
>>
>> +       lru_gen_clear_refs(folio);
> The only thing I'm not sure about is whether we need
> if (lru_gen_enabled()) here to keep the semantics consistent
> with other places where we use it.
>
> ...
>     2    676  mm/folio.c <<deactivate_file_folio>>
>               if (lru_gen_enabled() && lru_gen_clear_refs(folio))
>     3    695  mm/folio.c <<folio_deactivate>>
>               if (lru_gen_enabled() ? lru_gen_clear_refs(folio) :
> !folio_test_active(folio))
>
> So maybe we still need
>
> + if (lru_gen_enabled())
>          lru_gen_clear_refs(folio);

I think we maybe don't need it here.  The other two sites consume the
return value, and that is what the check disambiguates:

     if (gen < 0)
         return true;

An off-list folio has gen == -1, so without lru_gen_enabled() both
deactivate_file_folio() and folio_deactivate() would take that "true"
and return early, skipping the deactivation.  lru_lazyfree() ignores
the return value, since it re-adds the folio a few lines below anyway.

The side effects gate themselves, and on something more precise than
the global key: a folio on a classic list always has gen == -1, which
fill_evictable() even asserts,

     VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) != -1, folio);

and drain_evictable() clears LRU_GEN_MASK on the way out.  So an
unguarded call either clears the refs of a folio that is on a
generation list, or does nothing at all - no flag writes and no lruvec
access.  The classic LRU cannot be affected, including with
CONFIG_LRU_GEN=n, where the stub inlines away.

Guarding on the key would reopen a narrower version of this bug.
lru_gen_change_state() flips it before migrating any folio:

     if (enabled)
static_branch_enable_cpuslocked(&lru_gen_caps[LRU_GEN_CORE]);
     else
static_branch_disable_cpuslocked(&lru_gen_caps[LRU_GEN_CORE]);

     memcg = mem_cgroup_iter(NULL, NULL, NULL);

so while MGLRU is being turned off the key is already false, but every
lruvec that drain_evictable() has not reached yet still has its folios
on generation lists.  A MADV_FREE batch drained on another CPU in that
window would keep PG_workingset.

What about add a comment instead of the check:

     /* no-op unless the folio is on a generation list */
     lru_gen_clear_refs(folio);

Best,
Hui

>
> with that, feel free to add:
>
> Reviewed-by: Barry Song <baohua@kernel.org>

