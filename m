Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA7C606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 08:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=honor.com header.i=@honor.com header.a=rsa-sha256 header.s=dkim header.b=SYFjnLmD
Received: by kanga.kvack.org (Postfix)
	id BD47F6B0B21; Fri, 23 Oct 2026 04:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C086B0B22; Fri, 23 Oct 2026 04:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A749C6B0B23; Fri, 23 Oct 2026 04:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8350D6B0B21
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 04:53:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01B8B1C20EC
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:53:01 +0000 (UTC)
X-FDA: 85353276204.01.0600261
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf22.hostedemail.com (Postfix) with ESMTP id E52EBC0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:52:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=SYFjnLmD;
	spf=pass (imf22.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792745580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5PwMVw7smUN62UD1e5YSyFTBD/on9Hsq1pWaywHq+Y=;
	b=vw5aVi1ep3VmTnNYxzNR2feliIJ7cGjNyryPqI2aIxX1urVtVBwiVDK2wGInNAQHGksLV1
	aO6ix+AFXWEnz3Yzu/qB/ncxy94SUIkeN7M/olfgAFwUjcuX8gj8fPDa7BrQMUMC14V5+v
	+OxtMmvH/+y5+IE5acLw4o/bDWAkuZE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792745580;
	b=eIGn4ZEfP0aplEFgoS0/2v9SJpE5NNyB9UzrDNHvYKIUnq3CfXMWzdZ/TvgEykEcYZYVKU
	B07AQeRc7R0n6Yk7PzOt5cDOJMTIno5uZb+c2prg2XqcdznA4IZkWvqfLaJc7Pmx9HuIqW
	VeT59pMUIY6DLpKAs1ows/Ji81eZcqA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=SYFjnLmD;
	spf=pass (imf22.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=r5PwMVw7smUN62UD1e5YSyFTBD/on9Hsq1pWaywHq+Y=;
	b=SYFjnLmDeVAK5lRBdrtreL9fj+ZmnVGlGj0rojwK7gQO0zfIUJ6P2csHZDeBvTlvsthgkkZiS
	1Ha7BXdcDv70SyaGNwiHaCk0aiDa6KXOWNmC1g87Fgderf0hRaZRCuW8hW015d7KthCCA/XW/1b
	2KoNBQTDmz/MQb7D1tx7OJU=
Received: from TW003.hihonor.com (unknown [10.77.199.161])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4j9xcP13KTzYl21J;
	Fri, 23 Oct 2026 16:52:53 +0800 (CST)
Received: from TA012-1.hihonor.com (10.77.199.132) by TW003.hihonor.com
 (10.77.199.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Fri, 23 Oct
 2026 16:52:48 +0800
Received: from [10.144.5.36] (10.144.5.36) by TA012-1.hihonor.com
 (10.77.199.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Fri, 23 Oct
 2026 16:52:37 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH mm-new] mm/mglru: clarify the generation placement in
 lru_gen_folio_seq()
From: <wangzicheng@honor.com>
To: Ridong Chen <ridong.chen@linux.dev>
CC: <wangzicheng@honor.com>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He
	<baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Ridong Chen
	<chenridong@xiaomi.com>
In-Reply-To: <813b3f19-1cfc-4d07-a9b8-ea20f8fb0bee@linux.dev>
References: <20261020023548.3242028-1-ridong.chen@linux.dev>
 <179257189711.741142.157439930403322311.b4-reply@b4>
 <813b3f19-1cfc-4d07-a9b8-ea20f8fb0bee@linux.dev>
Date: Fri, 23 Oct 2026 16:52:52 +0800
Message-ID: <179274557215.1623101.1816617712512017779.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792745572; l=9658;
 i=wangzicheng@honor.com; h=from:subject:message-id;
 bh=Z8APWKK9r7zgMro38a2UtSMaA8pp0CPBrFMeqPt5BUE=;
 b=Dr8o0DtlGGEa+LvjL88HVOYru+iwRhKjhCtHBaHrrSlSCGoUrPiwRCx9WCMGxKPqRW/cTeIoX
 deWyHRvQ+pyAvouMmZ/b9PqXYcydxtS2wjDp6YlQIayetTfByQUiJev
X-Developer-Key: i=wangzicheng@honor.com; a=ed25519;
 pk=g+Qn/iierc6RbauMzxguVPAh7jEJCJf1WMdMV9Kk2sc=
X-ClientProxiedBy: TW001.hihonor.com (10.77.229.151) To TA012-1.hihonor.com
 (10.77.199.132)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E52EBC0003
X-Stat-Signature: rbjo9438hpt1971d6nwox8zm5z6gfnsw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792745578-247399
X-HE-Meta: U2FsdGVkX1+z6H3uJFr1nz53+9IOjsoQBvaT9LNFc1h/FLfWejW8/PmC2v6yp1nLrLzg1KOTdLIb7ZdxYgi9+yBpjybeUV4llEj/OmenTio1GJ6UixnCxIAwyfj4NoXPBtVk05DGPF49MDKlx0IPi3oma8PiNG+KcruH4dtIN/va4/5Qw3lF4wKmxfHstRXVMMAdR38TRf10F08hKVO5EMZD5tzU03smTrKMPbxaBWyVZlyGNkGQKBSVx8rZnu4OMmSOwTUEpbnwr8SKqR8+p+LvJXfKbSCYxJSz9uKJfHS47FRItAdTJDCz5Njq0L8xfrkPQox5sz3W79xymEFZnH0XUjg/K8r0YMfJpSVbp6qUMEWBc1TQVSBz6Hjlf8QSNVKmz9YYbnFoQqxITFB1BeFwEo++G4zNLTlwCiJrghP9e/P6zMnR26oKTQcA9kslM/9W2b/Nk2xDYXv8kbncAMV+LlNuKMTXn+dfRYJ/5s3mYK/qurRFu7bEyIFE6CnjhOAVe+mvdfnpCBTdD0sdUkzdRmY2oOCesg+mkZNsAHcE5Vp1rUpC+dpWBv4OaAVaH0OamLiqeH2FMap5f68lITaQoRKkHfa3qXUYpL6wI/U4RR5blpx4Ic2UJVHVyyvmj3nsLXOyxbUcYxGDS6XcaZ0kPMRzB7lHJRELPyoEjKNVqJN+uZ6emuiwoT0eeIZa2ixAdnnrwL8Y6nCtKkCrT+xvi/nHkPRfWVAKvvAerSYhGeehF5m3Tm102Z9MIYDcU3qqjSfacKPFouApAZPzdOZuaQkTiOi+vLNUheJPXNiFeLKsIAPv7qL9Guek5HBTG96sNboGmdtp4iPJkaFGGt64yArEcj6n/26mr86EXayNsyj+qIzk/RUZLb83L1dBD7bQkFbxMH0MFuFsXbROvwslT33tR4o0pwjML1WmYmr9pKv3aawzBGzfHEUZS94qOXRIg/qS2bqQHTss+70
 ZoEjc2TS
 wRFilT2fBHqo1TlOnQKKbFnuYrfPqghu11MdWHVjLZwFL9sXS7zSx1TZObp3d9P6U2WUEkTv1yjX7cKbmLSS9VAEGts3XVAdejiPaSfmEmkMYniVIM3+je2ETwq0HQimWKB1IVxovwIivk8xqHtV5+8I7FkYUkPm/zm/yMXsVVkw2RUdgdvdruSTv5e+Itvygje13cad/pllimuYPsbCzTmyie3lrqt8gUeqlo7cRifULwwwOMxpTZKMHDO/j5ZTTTEIo6jK3Tk4n9EQM8e8zdIBnlTnrcy08yAkzjtbJssz6IC8G88kHtvg1CnFbYEaIEGl7x42jNOK2pdksXuOcEZxjyNmNDCTwiFhb0g0FJsE56oje75LwAebD1lb3w5Mp06CxJFQIfrdSI7ddjwjBtuhzJ+Qgn68BNOQ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-22 14:41 +0800, Ridong Chen wrote:
> 
> 
> On 10/21/2026 4:38 PM, wangzicheng@honor.com wrote:
> > On 2026-10-20 10:35 +0800, Ridong Chen wrote:
> >> From: Ridong Chen <chenridong@xiaomi.com>
> >>
> >> lru_gen_folio_seq() computes how many generations below max_seq a
> >> folio should be added to, but stores it in a variable named "gen".
> >> Elsewhere in MGLRU "gen" means an index into lrugen->folios[], i.e.
> >> seq % MAX_NR_GENS, so reusing the name for a relative offset is
> >> confusing.
> >>
> >> The comment table above the code also no longer matches it. It only
> >> covers the PG_active and the final branch, leaving out the reclaiming
> >> and "can't evict yet" cases, and it lists LRU_REFS_FLAGS as an input
> >> although lru_gen_folio_seq() never looks at it.
> >>
> >> Rename the local variable to "age", redraw the table so that each
> >> branch maps to the age and seq it produces, and note that the result
> >> is clamped to min_seq[type].
> >>
> >> No functional change.
> >>
> >> Assisted-by: LLM
> >> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> >> ---
> >>   include/linux/mm_inline.h | 48 ++++++++++++++++++++++++++-------------
> >>   1 file changed, 32 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> >> index ab69b9930893..a933d8c14558 100644
> >> --- a/include/linux/mm_inline.h
> >> +++ b/include/linux/mm_inline.h
> >> @@ -302,34 +302,50 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
> >>   					      const struct folio *folio,
> >>   					      bool reclaiming)
> >>   {
> >> -	int gen;
> >> +	int age;
> >>   	int type = folio_is_file_lru(folio);
> >>   	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
> >>   
> >>   	/*
> >> -	 * +-----------------------------------+-----------------------------------+
> >> -	 * | Accessed through page tables and  | Accessed through file descriptors |
> >> -	 * | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
> >> -	 * +-----------------------------------+-----------------------------------+
> >> -	 * | PG_active (set while isolated)    |                                   |
> >> -	 * +-----------------+-----------------+-----------------+-----------------+
> >> -	 * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_REFS_FLAGS |
> >> -	 * +-----------------------------------+-----------------------------------+
> >> -	 * |<---------- MIN_NR_GENS ---------->|                                   |
> >> -	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
> >> +	 *            +-----------------+-----------------+-----------------+-----------------+
> >> +	 * age        |        1        |        2        |        3        |        4        |
> > Hi Ridong,
> >    
> > Agreed, I also found this part confusing.
> > 
> > One problem with the new name: in MGLRU a larger seq/gen means a
> > younger generation, but a larger age means an older one, so every
> > read needs a flip (max_seq - age + 1). Assigning the seq directly in
> > each branch might read more naturally.
> > 
> 
> Hi Zicheng,
> 
> Thank you for your reply. We both agree that this part of the code is confusing. 
> 'age' is not perfect, but it is much better. The bigger the age, the elder it 
> is, just like human age. And it is a local variable, not used elsewhere, so it 
> is fine for me.
> 
Hi Ridong,
   
Thanks for the explanation. To be clear, I have no problem with the
name itself: it is a local variable and there is no functional
impact either way.

> > Also, both tables run past 80 columns (~95 for the art in mglru-fg
> > 4/17, ~96 for the redrawn one here, tab as 8). Would you consider
> > something vertical and shorter? I had prepared a comment for
> > mglru-fg, and since this is being discussed here too, here it is
> > (conditions are per mglru-fg, where the flags became the refs
> > count):
> > 
> >      /*
> >          * The seq is clamped to min_seq[type]:
> >          *
> >          *   destination     | folio state
> >          *   ----------------+--------------------------------------------
> >          *   youngest        | PG_active, refs >= LRU_REFS_WORKINGSET
> >          *   (max_seq)       |
> >          *
> >          *   2nd youngest    | PG_active, refs < LRU_REFS_WORKINGSET
> >          *   (max_seq - 1)   | anon folio not yet in swapcache
> >          *                   | PG_reclaim folio, dirty or under writeback
> >          *
> >          *   2nd oldest      | refs >= LRU_REFS_WORKINGSET
> >          *   (max_seq - 2)   |
> >          *
> >          *   oldest          | reclaiming
> >          *   (min_seq[type]) | otherwise: refs < LRU_REFS_WORKINGSET
> >          */
> > 
> > With a comment like this, developers can see the generation
> > placement directly, instead of working it out from the code.
> > 
> 
> Thanks for the table,
> 
> As Kairui replied, he did not want more code details in the comment, which may 
> change a lot. And Kairui will pick this patch with his FG series. Although I 
> wanted to add the table, Kairui felt there shouldn't be too much detail.
> 
> What is more, I think the following is needed—it is what this function initially 
> implemented.
> 
> +-----------------------------------+-----------------------------------+
> | Accessed through page tables and  | Accessed through file descriptors |
> | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
> +-----------------+-----------------+-----------------+-----------------+
> 
> > Best,
> > Zicheng
> > 
> > 
> >> +	 *            +-----------------+-----------------+-----------------+-----------------+
> >> +	 * seq        |     max_seq     |    max_seq-1    |    max_seq-2    |    max_seq-3    |
> >> +	 *            +-----------------------------------+-----------------------------------+
> >> +	 *            |<---------- MIN_NR_GENS ---------->|                                   |
> >> +	 *            |<---------------------------- MAX_NR_GENS ---------------------------->|
> >> +	 *            +-----------------------------------+-----------------------------------+
> >> +	 *            | Accessed through page tables and  | Accessed through file descriptors |
> >> +	 *            | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
> >> +	 *            +-----------------+-----------------+-----------------+-----------------+
> >> +	 * PG_active  |  PG_workingset  | !PG_workingset  |                 |                 |
> >> +	 *            +-----------------+-----------------+-----------------+-----------------+
> >> +	 * reclaiming |                 |                 |                 |     always      |
> >> +	 *            +-----------------+-----------------+-----------------+-----------------+
> >> +	 * can't      |                 |  anon && not in |                 |                 |
> >> +	 * evict yet  |                 |  swapcache, or  |                 |                 |
> >> +	 *            |                 |  PG_reclaim &&  |                 |                 |
> >> +	 *            |                 | dirty/writeback |                 |                 |
> >> +	 *            +-----------------+-----------------+-----------------+-----------------+
> >> +	 * else       |                 |                 |  PG_workingset  | !PG_workingset  |
> >> +	 *            |                 |                 |       or        |       &&        |
> >> +	 *            |                 |                 |  PG_referenced  | !PG_referenced  |
> >> +	 *            +-----------------+-----------------+-----------------+-----------------+
> >> +	 *
> >> +	 * The resulting seq is clamped to min_seq[type].
> >>   	 */
> >>   	if (folio_test_active(folio))
> >> -		gen = MIN_NR_GENS - folio_test_workingset(folio);
> >> +		age = MIN_NR_GENS - folio_test_workingset(folio);
> >>   	else if (reclaiming)
> >> -		gen = MAX_NR_GENS;
> >> +		age = MAX_NR_GENS;
> >>   	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
> >>   		 (folio_test_reclaim(folio) &&
> >>   		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
> >> -		gen = MIN_NR_GENS;
> >> +		age = MIN_NR_GENS;
> >>   	else
> >> -		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
> >> +		age = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
> >>   
> >> -	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
> >> +	return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
> >>   }

My real point was about the form of the computation: whatever the
variable is called, the return still does max_seq - X + 1 and then
clamps to min_seq[type], so a reader has to juggle a plus, a minus
and a clamp at the same time. When I first read it I had to go back
and forth. By comparison, the 6.6-era code assigned the placement 
directly in each branch (roughly `seq = max_seq or
seq = min_seq + 1` style), which is a bit more verbose but much more
direct.

Anyway, these are minor points with no functional impact. I don't
feel strongly about this, so I will defer to you and Kairui.

Thanks,
Zicheng

> >>   
> >>   static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
> >> -- 
> >> 2.34.1
> >>
> >>
> > 
> 
> -- 
> Best regards
> Ridong
> 
> 



