Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076D0CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 14:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598936B0096; Thu, 11 Jun 2026 10:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56FE56B0098; Thu, 11 Jun 2026 10:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AC8A6B0099; Thu, 11 Jun 2026 10:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3796B0096
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:02:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6841C2525
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:02:15 +0000 (UTC)
X-FDA: 84867796230.08.101E4E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 005D51C0017
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:02:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLFrWxBs;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781186534;
	b=NibmhJM0uPflu8aiEUikGxuKj1MXk+A0sPvQnj0EDraAFcCt3+Ym3txwEeRNG/u1rv8GIz
	2zkAqTKEUapJ3B8dekJa32jMhnnKgZ5IfSEA2ET99J3xkHUOvNCvYHVWmLonCWC5ZMjlwL
	drL9HB3k4Jfm+jAhYIyYq3p5JnyB/Ng=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLFrWxBs;
	spf=pass (imf18.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781186534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGx263XN3d4QK7OHcwdkEuuULCXh8jD+R0LCjmF4YNE=;
	b=Ho/GLd4HLeP4bmt6owHrANEtCCxClYuRQQ9+JaCcGyb8qKs4yT676REg1Io1tYplxfWcWG
	3YTgGpQAGPmSbgDkS1EDXF76PNh1nquhN7m8EVsEKI8thwCC6jG/9YjMpuAKOPuoZrTqmi
	6DgWKDUdHmNLGbQiB1tsCshwVhQHDF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B3D6600AA;
	Thu, 11 Jun 2026 14:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857AB1F00893;
	Thu, 11 Jun 2026 14:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186533;
	bh=TGx263XN3d4QK7OHcwdkEuuULCXh8jD+R0LCjmF4YNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kLFrWxBsFlBrI6vfhEMMxjaZZXc+1g4bsxZ8G+G+yDP/93GCUruzLJyFRNYzs1LZ8
	 26OquQsl8XSVmbfD37l+a6HG4oqJz8rU7XfNfBFZpkObBxiw5RlnWq8vq4V0uq7ZLv
	 2wvqO5INdyP6rbh8df+Hqdb/0wxsoa1kqNRVbpcsAUNm/D73SfkIcSUZGszwKhCOx3
	 vZIAfaBVUNMGvobJMK39Ob0jNf/rOofkeN6f3FxzmWA4DefcuC3gd76G60C6TdKFhY
	 7vB38WLYHDWLg1+8+EAROgw1JQKZ72fkHesso7wkGkN7rQVt7RKEVYncCQTGOyVen8
	 tBANP7uoOD8sw==
Date: Thu, 11 Jun 2026 16:02:06 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Peter Zijlstra <peterz@infradead.org>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm: cleanup clear_not_present_full_ptes() and rename
 to clear_non_present_ptes()
Message-ID: <aiq_3rp9fwFHyLwl@localhost.localdomain>
References: <20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org>
 <20260611-clear_not_present_full_ptes-v1-3-49865fc82629@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611-clear_not_present_full_ptes-v1-3-49865fc82629@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 005D51C0017
X-Rspam-User: 
X-Stat-Signature: 1i6zwsdefynrbqnzp46gs39k88s7hrre
X-HE-Tag: 1781186533-853412
X-HE-Meta: U2FsdGVkX19woPidUFgtnxraXRkoISEGmxKrV/Zmu+mSFwE6rpRGRN9mQzA2UxkUV1rQtmWjBgfoiB5RuLwVkVwOsekj9aGc29S0mA94PlhUk1bZ+sgIxl7VYmzMvTyIVICLy1sS4rtmJvErTBfZJUZHySarkzVR5vVY2sHw7Oz2J2RMURXjKm7Ojfihwd5ZJiuAbDwhZgMTm8soXyR2b4/efSB1YagNPVCnyGNqadmy4D+GJepTHTo1XFMSOmW5EqwDQRi25E9J0aqVFVLMiUIn117w/dYxKfVDGBAgVD0dGwfDe3iaR/VmjI+Tjzx+BotYoglxe8IQNEJunsRPOcRCY02gYuohfUr32zFue3yzsCM0jdMSybQfrtoFLyuv2NAThnYeyJOpKTir77HUXwKk3Z7oxOC+mghUFuzIDJnQjyCMnNQ/aBIkmBejf+TFn172rbg6WrFCCkmNFeto/gOLYdDRr7MyZDGNzXFtj+OqyNB0MAnCeB3FMYSGW6BT93WLzcZRtHs+TNkuzaxruhw1a1S0Y26Ov06+vIAbNuIZDEPPDOmzvshf2128Xg3drY/dkNMl8YNmxjsOdkYpJ045XzFKBCWuXnKzshU7pgNPeQCsuJhaH3VFPHETYE8YOJK6zyES0YJnaLbgasRXRQgy+kja/70IfgVEdDnbodFPzbfPhHj/nAdTEfe94pZzoNdM+ElfajksWQfZ3Og2dgsAMMj6h5WniWcr8bNyA9LZ/NhiyXi/cu+6aHVTwl1BuKWjysdysa4mK/JtNz67Nw5WtXDf53tCxjs6ivZNLCOi+KRIMAGHlLTl8FTBubuYSxY1aMD4mHM7RtdD9k7MJgxN72sX4AhCyEEw5fYVHnRliUIREfryGu29zciXYrEfQkppm6BVdpIv3R8Y9z+l4cmEyAsqDOpPuidHNjxsXdfvYVvcLGJPNjqj0rTpXUOeUhotP90JubZG86DyajQ
 p7iNZ89x
 JwHcJQq3dmDhZbx2JRZ0TBd834hHIFyURW7TiL2QxG2VCWkHwUrNQJm+Jp4mypuH7vguKL7d/xxnXmy/iQuzRwzhtGMVEMLUOi43xLTj+csrOvjROaEZECFNe8vVd0dr6aRxXx9w7s0jr9wDoPbtOICq8A2QyShfQlMU+F/EMun/gPN4mx1QcsJjyAXVVXGI/pPbDzDi5HDFgajT1C4waOh4KvzDaJy9rg/RnilqBc70OczU/ytJg8Vd4j7qlylRkr51M5fNT/xU+F7uNAFUCvAjnwSGLflpgEqTr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 01:50:49PM +0200, David Hildenbrand (Arm) wrote:
> Let's clean it up a bit:
> 
> (1) There is no need to pass "full" anymore.
> 
> (2) No architecture overwrites it, and there isn't really a good reason
>     to do so when dealing with non-resent PTEs.
> 
> (3) While at it, call it "non-present", similar to copy_nonpresent_pte()
>     and zap_nonpresent_ptes().
> 
> It's a shame that we have clear_non_present_ptes() correspond to
> pte_clear() and clear_ptes() correspond to ptep_get_and_clear*().
> 
> Likely we should rename pte_clear() to pte_clear_nonpresent() or sth.
> like that, to make it clearer that it is usually the wrong interface
> for dealing with present PTEs.

Is that always the case, that pte_clear() is only used on non-present
entries? Or there maybe users that do not care about the current value
and just want it to nuke?

I guess that such a renaming would have to first audit that all current
users obey that? Othen than that, is there anything else stopping us
from doing so?

> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

