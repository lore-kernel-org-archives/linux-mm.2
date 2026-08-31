Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57E7EC61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95A06B00EF; Sun, 30 Aug 2026 20:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6DC66B00F0; Sun, 30 Aug 2026 20:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83306B00F1; Sun, 30 Aug 2026 20:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2D7A6B00EF
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:33:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 221661403CD
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:33:09 +0000 (UTC)
X-FDA: 85159690098.11.97A15CB
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2157C1C0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:33:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="O CmelH2";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=RpxQvsoh;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788136387;
	b=thuaBg9r7l+BZNKvqEV0rcnfEoLjmKuichrKOPyTL02y2ZQJBIn2Y5m+lBjfqiz4/Xu9Y9
	XNp75E2WzKuSFbS1Q8d9NmIJNkMCeYH80NlKO9hmGC142bE3alwtPthHdCoV5/g20zWMlh
	vYUJKqCVNfDF/wtsFnChp733xiDQFL4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="O CmelH2";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=RpxQvsoh;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788136387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJPZCOLUDNk+g6cYgbr1iPsO5mhcNg4J4ioSHDPrZzQ=;
	b=gyoZc9xj6hzMjfhUBpH90Tx8R7icbLw+ov8+AbjskEMQxHVv0CK28uZDOlcYdHniuJl4Rc
	huutAwOpJqDduv38kjruCpBVn+BJHHEtzu00Za9TByaZpcRS/xsPbX97hfzN1tWxJljOxc
	dxz9VZIJ1QPTacLjJxyojUW0X4ave2U=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 72C95EC0100;
	Sun, 30 Aug 2026 20:33:06 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sun, 30 Aug 2026 20:33:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788136386; x=
	1788222786; bh=lJPZCOLUDNk+g6cYgbr1iPsO5mhcNg4J4ioSHDPrZzQ=; b=O
	CmelH2IdrjYn+bNwwwhrxZVydaRfNGuwp1PZU5tE8CeSV9af5FkMFp1aAZU98ffS
	tjLkPLY8r48f8zNo2K42YWTNI2TM1noM29FCSCPxM7x2TtLmzmq9V5gNj1ycJW2q
	7q0WU2K0AFt7DTHgh00L7gkJZVZT8vx5ASEU2bDdNO023pXHfJkPTSmnW0EgMilU
	G7tiLA1pwkMJvOEP1xPlNEv5TVTOwfeFNOL3hUU2BcY7pj5fVKnB67Bas+D1ARXt
	0kEZcBGg+3Rhc19SaJKS4Kyu5ggYpmQJd3WDRA7LNYkDgnCTIQgGa8u1l/b2TQsx
	lD4ivyNg/wj9bcieMHXFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1788136386; x=1788222786; bh=lJPZCOLUDNk+g6cYgbr1iPsO5mhcNg4J4io
	SHDPrZzQ=; b=RpxQvsohqxwK6JUe9I1qFnA4xYca/pTCvYXLSqxn3A81E0zU4H1
	F13noCR91GcBL/1Y1YJ47n22BWhAZ3gCv+kNsWjs06RDKNSc1bHliu/n+5lGbdBV
	MX0oHU1rkGIaa/y/08kZL6woyhABvPIWb6iB0WedetbZTOu3+/mYj8/ml8iWUtn4
	cbhHU0DyEkuxxs/8IOPKWT3Lw0msoLjscRlrD028TWuPwCluOuNAt+1+0opaBTBT
	zevvyEyR9eaSHx2AEAPmmjTig4rs/Wdb/4QoWTqocUElLEZcbkTA+CAbiZTtt3+4
	Rq3qYfynZyrNwJ3Txq9NOy60DBzmv1a+9Qg==
X-ME-Sender: <xms:wMuUashmOIEJMK-IAgNtOy9BHlHXjkLM3x9UmGE9OSqnK7OXcIxwSA>
    <xme:wMuUar3Y24WYrNNkb8frTWR4kapMOngfq30hF801UHZmxtZjm9maS2HXaFt7ApEXp
    J50SyCyNm8mOD5yyw9VFSbv9vEQuOPK8h9N3tf20aE3IAMPU88rNIo>
X-ME-Received: <xmr:wMuUatCsHhXp2QN_Z431LzCXG8n2LrVi8Wy7sQSztbtHChLKasyfXA5vXbA>
X-ME-Proxy-Cause: dmFkZTGWxIZKkq3xUOgUH4ygv02cvLsZ+hD3NKWU+FsQjPNSZgCQwwPv+JmWL5uCS4cqsg
    3/sT4jCc0KHHG/Z8X0iJgpyNqUAuNz3xsso6DalAvRQKx5sqad53FONoT3236JY1ymED6h
    ZN8kzGUvseACenUQxSwpIBP1MTBMcg5gVzZZ97jTCcLtIAP0NKZSI+azvAoiaQaNjpqH3F
    wCCZD0BK9KSJVz+IMysk4BmIlj4bMsjPYymXcytnWPsV3t5kGLyCE3x83J0C6qbL5n6mSq
    uPuKxKEFN1BWy1CEoDRkvwP1K74G1vsxqWfRCTguUzbdHZtLkLD9HdVbXGqU8xqM2pD8Nj
    YnePeSeUFlIlmf3OOJO9zq909PkrNP2XHZzYzawt/dX7y9EtzL9tFTZAmuszAP1Jkt7pjL
    IogkAI6Swucxn86WJAsRSt13R0laSBo8y9vDzafncz+Po+mK+1dtwxWvJ1Mr+sW5uI7HFU
    y9lYQuIsCBGIjXhl0GQcGpabjnyCwU0vPoaCVXbAdR+7t2GVBKjR6e/JxBcsHN1plYfnQG
    vkSEyBRWJaeWOiHix/tnpIpw5onSGN/KSCynDx0mhuqNOwASo3OTReKPms1rUFmmA80YuO
    vJQ9wWLZVtDf4AodRcnzqlkXDomOo4f4ay1mHeseWItXomCNbiOx7zmnTb5w
X-ME-Proxy: <xmx:wMuUagFAFFWbY2YjWwrsV20OPBml9H2Nk2101ufKBG8yzBEXh8dE7w>
    <xmx:wMuUauCpvGk6DTb_7Vqwd0UFqATo4PgnGgQixx7xGeOvEVL1lG25nQ>
    <xmx:wMuUaqb8YcMT644qNhyozAIWGQW3TbFh3tzLrfw507XEmoKSeI3AnA>
    <xmx:wMuUamPzfSGhBpdUc7tEQO7KLDjN7DPHYKID1D9tvYN8iM_NBJF1bw>
    <xmx:wsuUal5jylNIC9RMDN8Wv07F436UfPYuSnMuUrC-hyYzYxvUbkRSJaCx>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Aug 2026 20:33:04 -0400 (EDT)
Date: Mon, 31 Aug 2026 01:33:02 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>, Balbir Singh <balbirs@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, hannes@cmpxchg.org, lance.yang@linux.dev, 
	hughd@google.com, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com, ryan.roberts@arm.com, 
	balbirs@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mm/huge_memory: do not touch frozen folios in
 deferred_split_isolate()
Message-ID: <apTKkAkdUZYv-Zab@thinkstation>
References: <20260826162101.1314941-2-kirill@shutemov.name>
 <20260827163838.1813081-1-usama.arif@linux.dev>
 <DL07CYI5866P.2HCBRH4BWPMKN@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DL07CYI5866P.2HCBRH4BWPMKN@nvidia.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2157C1C0002
X-Stat-Signature: qz5zt9zobacd9og9617eiowqa3utom8x
X-Rspam-User: 
X-HE-Tag: 1788136386-868431
X-HE-Meta: U2FsdGVkX18fdi26iumX8MhtoLdrNWfGXljzrWYbzxv9volvM50Hjl5ydJTMuzJmbBBVUn8ztTOid11Ve4c9/ddYggWbGZJvnQeDp+9McE0oJUEjxu7YPESjPMXNdghNQQ+Ht42EHJum0oNrnL4het2dw9TRiO/IGCrroNaS+kEqeMbejDrw/8njbpyRQ9S0OpNnSj/lprxwiXy2VctzscL4MF0JIF67/kXDF+WKppP/lt7f2Hq1yqeutPkDgj64IbnJq63HupUuJrRpO4Q9WnwjsEH67y5Z8opNCBM5f6arMvuSdgZ6PIMhfvBJBOIdXwoGy8S7VBaSHxi8cioolhqfPPPrsnUpTNCIQpL+MDMsq8t7bO0M8jSjbjCGklGEyXhUfXyriSBJOTt3M7PM4FjmtQGf15MyFVR9xOg/jcpldA2pHmZIUZpOvJceTlOFCNyq3ouwwiOD1yZX7KipVnV+p44y4DKSB0OINeErv2NA8h9yXuwASJkIfu7RM32dwQddlMZ94VJ0/bQBzST7SX6UewqVbVKeOTCZdn+LEDJ+Dc3RUJbu8jn67ZboD8FrYAJt9ZMfenrPUeiUV+8sLUgV1HqSL5UvSjVlwNzi8rjxhAAh222ufjmeVJRkvqOmgtNeD4nLj5zEggIkmvNLnCfX7MbAQuLs+PHyLx8uikdJ6XWMZ/P2lXYAuLlJb6sKf8QvM4jcsdi+9HDVhEGGw3bhsvJChp/Hdd5euPXFWClge9NWp4wl6OQuha1cPCbPBAvxo4CTDwKgf2hBLHftzYX2kATI5OUky09IO0EIo2+0TXTeXvUOMsOgBnIlHLQGy5SldVgmoPmoE+rfm6TCyQuHAOyqvjvq9CfHDKcGdjoUxt5FQVwU70G7E3YSAEaClmoT/tHCTtF3p+QdjNvkfWwo7zu2zeW/XoyX2BeT2tcIoj7HDgToefRJRxdNHJyFlDIyozf1FblrVoopF1z
 TQVg8tKl
 2smf7natMGGJX0ixrTFstpvxze43GsNqh8Xq5VtjY11B+/orCrheZKuDUq7vP9/SU+0bnqhPIeyfah0XtuQRye0nW/e6AXQg9qTGwifiqrfnFZArcKSF6Lf8PL/PJ0asH8et2QsShEXxRWOn0iC+1rZbVsaPdcJhNMhpaivA0nmiO3hKGzd7+pXseyKPZaiAmWTGdzuf4ZXHdUgEqhIakXEL1sALgd3fWE46n2aMj0w3w+qtGOY7Uqn8dt2z5M7TsfpEYwaRajKjFaNNffQpW90nH12ouhrt6f7ZXkw4zUTMPJ0Rq1xc9rt/31O+hXTyx25+TAU7dz5/mKmZ24joHSxgA/+fFtj2N5LMthyjESMgFm7oXchgD8UNug5X2yz7m4K3owMiTmDQyUEqD58aByRXDNRVf1NC2Jmh4WSr/jiXZiiuFBc7DdfaaeTe+VdpSrMdGeleTbSVwIGwBGDR2pICptjphEcJ23xph42UCLDgkB8Gp1ea0Dpwb0vhOQyomtOvqqMe+8ub5rpp051wvTEILN2l+PaAWThjnhhgLtHLoYUU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 09:57:20PM -0400, Zi Yan wrote:
> On Thu Aug 27, 2026 at 12:38 PM EDT, Usama Arif wrote:
> > On Wed, 26 Aug 2026 17:20:57 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> >> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >> 
> >> deferred_split_isolate() probes each queued folio with folio_try_get().
> >> folio_try_get() failure is treated as a lost race with folio_put(): clear
> >> PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take
> >> the folio off the queue.
> >> 
> >> The folio_put() race is the most common case for !folio_try_get(), but
> >> it is not the only option. Another scenario is folio_ref_freeze().
> >> 
> >> A zero refcount in such cases does not mean the folio is going away.  It
> >> means "don't touch me" and current deferred_split_isolate() doesn't
> >> respect it. It can lead to unqueueing folios from the deferred list for
> >> no reason:
> >> 
> >>     CPU 0                            CPU 1
> >>     ---------------------------      ------------------------------
> >>     freeze a mapped folio            deferred_split_scan()
> >>       folio_ref_freeze()               folio_try_get() fails
> >>                                        folio_clear_partially_mapped()
> >>                                        NR_ANON_PARTIALLY_MAPPED--
> >>                                        folio off the queue
> >>     give up, put it back
> >>       folio_ref_unfreeze()
> >> 
> >> The folio is still partially mapped, but it is no longer a split candidate.
> >> Nothing queues it again until part of it is unmapped once more.
> >> 
> >> Skip the folio instead: whoever freezes the folio, owns it and owner is
> >> responsible for its fate. It also covers the folio_put() case:
> >> __folio_put() unqueues the folio via folio_unqueue_deferred_split().
> >> 
> >> Reported-by: Lance Yang <lance.yang@linux.dev>
> >> Link: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/
> >> Assisted-by: Claude-Code:claude-opus-5
> >> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> >> ---
> >>  mm/huge_memory.c | 19 ++++---------------
> >>  1 file changed, 4 insertions(+), 15 deletions(-)
> >> 
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index ced400f72d43..6281ed993243 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -4590,22 +4590,11 @@ static enum lru_status deferred_split_isolate(struct list_head *item,
> >>  	struct folio *folio = container_of(item, struct folio, _deferred_list);
> >>  	struct list_head *freeable = cb_arg;
> >>  
> >> -	if (folio_try_get(folio)) {
> >> -		list_lru_isolate_move(lru, item, freeable);
> >> -		return LRU_REMOVED;
> >> -	}
> >> +	/* Lost race to folio_put() or the folio is under folio_ref_freeze() */
> >> +	if (!folio_try_get(folio))
> >> +		return LRU_SKIP;
> >
> > I think we might have a problem here for ZONE_DEVICE folios?
> 
> For coherent ZONE_DEVICE folios, yes. IIRC, private ZONE_DEVICE folios
> are not added to deferred split queue.
> >
> > This assumes the final put always dequeues the folio, but ZONE_DEVICE folios
> > bypass the generic folio_unqueue_deferred_split() path.
> > With memcg disabled, this can leave a recycled folio linked on the
> > deferred-split list?
> >
> > Should we dequeue folios in free_zone_device_folio()?
> 
> I think so, before mem_cgroup_uncharge().
> 
> But it is a pre-existing issue. We need a separate patch unqueuing
> folios in free_zone_device_folio() to fix commit a30b48bf1b24
> ("mm/migrate_device: implement THP migration of zone device pages").

Agreed, and it is inert today: nothing allocates a large coherent folio.

amdkfd is the only driver with a coherent pgmap and it hands out order-0
pages, and test_hmm builds its coherent chunk the same way. With test_hmm
taught to hand out PMD sized folios, memcg on gives the WARN_ON_ONCE() in
uncharge_folio() and cgroup_disable=memory gives list_del corruption once
the driver reuses the page.

I am not sure what the right solution is: keep such pages off the queue
or dequeue them on free? Or both?

Balbir, I don't know much about zone device. Do you want to take it on?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

