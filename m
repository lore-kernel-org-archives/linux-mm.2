Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF11C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D806B0095; Thu, 27 Aug 2026 11:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E946B0096; Thu, 27 Aug 2026 11:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33CE96B0098; Thu, 27 Aug 2026 11:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 001E46B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:15:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3E4B804A3
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:15:39 +0000 (UTC)
X-FDA: 85147398798.26.386CB41
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf02.hostedemail.com (Postfix) with ESMTP id CDF3980003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:15:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="V h8rLUY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=elE2WPi0;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787843737;
	b=NA+8BE7Rc0euAvANiwioBSVz4goFOSdtFZ0McZzt+CkM0fbp1OK5BYJtitBUYI55PlkQdh
	MChFn6CnKIQwD+NgQP4LnbfZoxLZvnjh5JdCieqBBFQMRpKH1k6M6VB2miqQZXRSPUhe2j
	uuYJWnNDR/CEN4mnXBdfV/+TkB0/Yac=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="V h8rLUY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=elE2WPi0;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787843737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7v3jZKyW5YM/dZvPHiNitrQbB/s0Wrf3eO5lZfLNvo=;
	b=TnC8X/GFvG46nLGEU/9DNBxaBpwBEf3x4x9/1nLgK8IRRsPirQiDYg1be88YdZ5EWB14f9
	yqFbJtF5GVT3LoOPj1P2r2BiNN+2aWhwCY8tgbYagqRZYXQ1m5btcNSsj8rF8ZdkvmfHgn
	NjrOoZ2VhD/77dGLODXZAqmemIzmlT4=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id 32CEA1380023;
	Thu, 27 Aug 2026 11:15:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 27 Aug 2026 11:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787843737; x=
	1787850937; bh=w7v3jZKyW5YM/dZvPHiNitrQbB/s0Wrf3eO5lZfLNvo=; b=V
	h8rLUYAEp6IBdGqRDW3bR20Q8yA7ENN7eqrmvHy0PDCFf90onNqb9+wGJYTa3Cft
	wskH2UNXDnn3ybOY4l86B301cTdxVJspQ6zQFuFErdpHz0oRbW2ouu65RAJ2LIeO
	jumFfgyaZIRX3SrRcR5O1N40P1xcCzQzelzwaalbdFEJBS4Ppafs3RVwMjhfQweY
	WIZ76jBo6ZuXnPmX/yNytavQ7yFVAy+e0gZiZ/hu5Q//VOWPKsxwq8ObkiadMO9x
	rQH71Ga95PAQwrBhIvdT3CqKQrftcKV8kav2GYcS+egAlx5Ds9WFOeRY68RgbiS/
	laZfB5eHrVKubPhvphQTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787843737; x=1787850937; bh=w7v3jZKyW5YM/dZvPHiNitrQbB/s0Wrf3eO
	5lZfLNvo=; b=elE2WPi0unuyaqdBwDmtf4TTMIehjErNAil5+mWE4WtYVeyiuLx
	Q9KfgEX8yCLzNGhfpgBGHhSJsxjAyKKb0PLmZGK1N39Ju57niUOulvUrXF0lxkh+
	uFZypeFwMiCT8bLoKJyEm0a/kojVzXz7lR9IrfENS0fLJBq3+4p+bypmf0V71zJR
	6/snfMBIha9cFQkFoIePrjdotiIwPGUTgZppMkx6DEfo3pcK1DWycfc06lBTuIfQ
	ZdQMInmIl8moFiKsbFu5J2U+bPOvn///EWpKiCEhXOxYQHzADLPKV3REpM7IS9cA
	o9YW/iQqc2MHoGJO0UXSeKn7K0CiFDlzxGg==
X-ME-Sender: <xms:l1SQamo3GtLojnOzVAUjlhsW__lSX8S37BnxT0hoAGRN0vwJkb3qqg>
    <xme:l1SQajHlG1c7DmBjjUxS5NALq-jAmGXlF9QIWVthXmPKYd-mb_fbJ-Qiq5QIuqy-O
    0V--SnEhx5QKWgQnzwyzH_tORm0bbHcmadz5LiT-yiwoEV4IEmBPZeV>
X-ME-Received: <xmr:l1SQaiUjY-2MsoHSA-byma1BGA2z3fnXTF_Qst2Uq8y-0dudqKhFhJaDL_g>
X-ME-Proxy-Cause: dmFkZTEK2w8SRbJqzGnH6ehcVK5N1qa5p52AX6WHPYzFNTZiHkb2XIoweUi+AenE+O52CY
    jnx/t5shrleOg8Roeoj1Awr1mVPEkSbBBUa/blkcFR2EIeGEtMLr5YMn9gIebwPs615/jG
    5MrlYenrv555VDhVYUXwZYPJstEhfJfeBlpC38ShgRGy3/C6X5Hx1oWf6v685LC9i8/Xub
    KcacxxWxHv2lzAy+H4Ljqul6w7o45k9q99p0sX7icTcOkqRMR0CjAF91iJ7eOrNtOLRVbp
    5V1FQHrNtyPXTEfWGz++lNNUongVLq06lmIl4uaGADJuKpJVtkfx1XLxdfx2hNYhnaanBo
    rAFHBgKSVvn1SjfBcWx3CTavhB0j6bpN9SQo/qVVoSUHQN9v9gyT1/rXtqjYU/f4HLLCav
    g83GQ5YcK1lY6rCqJSA7EOkzvjQsXy8DtMmHIP0guoihX0EID5N0XNxU4BWGLm3fKJloQo
    Ko9zL2sSl+7XasTyo/rVRDPorv0ONc1jO9fKn0lfR03UlbViEo4krJNd8EgBHq62sMPEjY
    Owk4itnnOOMod4qctfpyS8nD3DkjAIoi0mR2KVaMXXQb1x4dlwjitVILmOYXpvGikCh0aU
    AnqWbyCjXHxv7uA73tPCSbi/N8o744pxlHzPZ8bpCJ8EKZji4XuwSKcsi8Lg
X-ME-Proxy: <xmx:l1SQapfpH1PoP9-9NAVqdo8yRoSTEDpaqL2RRuKw5EeejUTp76eGaQ>
    <xmx:l1SQapQ7jHsAy7l81qsh5lHFXyDFDC7Zp0UO6Iwey2gkRsZkGhsDkA>
    <xmx:l1SQajALTqetQVYAVWOXM_2421xwPW2MyP_t2d5uSR6CzENCQk0ilA>
    <xmx:l1SQanuWtsQ0DLKTXoOY7vGA0ScKlcnaamBJzsvEJE8MhPOfD-RB2g>
    <xmx:mVSQamTGGg9Mv1BBnEqNNU8yxMe2u4A3mKUgG01VfG3wZz-04HyrAKO2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 11:15:34 -0400 (EDT)
Date: Thu, 27 Aug 2026 16:15:33 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 06/18] mm/huge_memory: consolidate irq and locking for
 folio split
Message-ID: <apBUezypL2aITw-0@thinkstation>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-6-9b43f5163238@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-swap-thp-cleanup-v3-6-9b43f5163238@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CDF3980003
X-Stat-Signature: 8t14ufxz55bxzoj3efkhyfb976k557fd
X-HE-Tag: 1787843737-678768
X-HE-Meta: U2FsdGVkX1/HupLWv3eNtyDPOise4TrxYRWfKfKrnxasuErY1FqCxxgTA3T9QaesAmj0CS7zhYW900cgliNUvr9j6xm2XM068MDYOq4m+FOp7POUjkZFbSI6sm//oyv6y020TtUGUC8kY1UdTiB16q1QrATmEdlu1Oj12OJiOAjHqfNQHf0eY/GBeL88uo14KmTLLE7YcFx4cTD3CFWl0MkAjYVKk6LAYSlIVeKjMrRDfde97/OuJN4kV2nl1VEn3+5h0dRAj5ihyuX7a3Uj9J2CC4UkTHH0SCsobTQ5dXq4sNbg1UPg6qA2HRqYwZvYQs8IT95Q8eoOKS4D+Az4t6NmOmj9D6p6nDSPgIZlAMiRXDS1J7xQRDqBtO5BpbEjJVSYmN/aTCYieHJDbJfPAxHCPo6c+w8GhQSKlslAqfyHeur5GWpp6pM/Die7k8CXnqAJCO/yqfchkOSBZbxxJFJoc/pnV1RGulB++CMX/dlzDd/T0BLXVkHHf/NKDe7YQ5guCCzqwAHLXEZR0aFCT69jkjseXTEWUPBs3RvTyVr+e4v9LLFmFvK/D3RCuk36TLAK4b06AkCt1nb2w3wUm58mIndBcMAk2qfuHRHfcdJwG+DVhOJQZyyiY1DNW2Y8xPzvSam93Fbt/YPuZ/tL3XQ0El7k+p/ak6n3VP7bKNfcxItOqKIJDWpyr0hD0/pRlF1uYmvSg4Z0XSuCY7grUWQ85AEudiKm5eq5NrMx7SAImM2GzZaznVOwnEgH4tIPLl1QG/2/qldpbCneiQ2nKwsBhSgASHhR7R2rMaeLEPaIcZUOFhVBMnEQEZG3SpOwBUm3pB7nvq+3luJjx6RNTrsO7DdNgvgfB0TkAyTLOsu/PFe6ev6cRRPmmoOKnwomHmVh5z9UOkSATdYJeZUyKHwRHnEuR/IACvY4DPBDzSE1kLbg0iFtOnTM6vjWOzUwXKCNCfQ84KKXic+OOTb
 swARQwbv
 JtImSjs324rjGFRM/GQy/P8DaIZPr+LtGNz9cg5jGbz12C9Q7XzVaxIAOfSJB8YNgJrVLHLh/U/l79T5OaGD/b+y81uK2WKIg+mqmBmm1RWdJtbwGO5/JW0SzfUYOOXuQn1KJjywBoDTPur6Mq4fBMoQMx3Or3xiWg3hTK6t8424jQJ/MX27kBEvd5CchvNY2IM25Ic51Q24TAGbgJ9VqKIQVEbNJgp1awepIdfAOJxd5gSgdsvpX1Cw3WCzqKWWUBWwAX9QFEo3wyoruOTmaxvTcVk7Q3oc0+TpH91+OlWnYJBKO1iOAgg5dBewX0Pt8tdEgxiZyEjTP6P1ps5gWGsaqxRfC2GOJUyHC85rPNoKw0sgPNeR/GZxoeolyo2WbI8xTT1I+tYOvJnrvs7zygBFWIGFREEMNOkJBBFMq76JgRYReszgPIOQKxXib7XB2ZLBtpVsIVLoV+Ea8lc1PitJ2BK0TC67mGon8mDrAYubpA+pVZ/GCV6cIbRFczGPmzRoy7BGBdpECmcBVE6IwKG1cAo/AFyeLG14QhAZlGCniyHDQy7qYe9JBbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 02:55:19AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Let each split helper handle its own locking instead of relying on
> the caller, so both helpers manage their own irq and locking state.
> This lets __folio_split() drop its local irq handling and fail label,
> preparing for further cleanup.
> 
> The file path now uses xas_lock_irq() instead of local_irq_disable()
> with xas_lock(). The two are equivalent on non-RT, and
> TRANSPARENT_HUGEPAGE cannot be enabled on RT anyway. This conversion
> also buys consistency: every other place in mm/ that freezes a folio
> while it is still reachable through the page cache already takes the
> lock this way. This was actually the last plain xas_lock() on
> mapping->i_pages left in mm. If we are going to support RT, spinning
> on frozen folio refs could be a problem, but it already exists in
> many places and should be fixed generically.
> 
> The anon helper keeps a single local_irq_disable() as before, because
> it has to cover several plain spinlocks at once.
> 
> The dropped xas_reset() was a no-op as the xa_state is not walked
> before the xas_load() under the lock.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

