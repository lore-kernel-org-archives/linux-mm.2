Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A6F5CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2406B008A; Wed, 13 May 2026 06:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83D16B008C; Wed, 13 May 2026 06:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A356B0092; Wed, 13 May 2026 06:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7FF76B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:32:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4589A8EDC1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:32:43 +0000 (UTC)
X-FDA: 84762033006.01.127D334
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B8A9A18000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:32:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PkdigcFq;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778668361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Vays8x+y+TnHpt//KEgyCfpbymoIR7MVrgJDMaqlXI=;
	b=LpvIdKIKpVpK8d+rIgWB/IdnbXDB8p0rm8upLM8L2A7Mgj8D5Od57XGxIY8luHFKFP9MQh
	c/nkf1q2KKe+nx14gv2St9dSEBatHSz3qmHXuTLeVkR99ZU7wJja1PHpMG7D+TH4FYo5ef
	aQRSyMnUm24Qmy9xnURvTIpEfCiz3Tg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778668361; a=rsa-sha256;
	cv=none;
	b=PHHzngjTaGElLs9GdqECto33C0X/1A4DnGSludLcTGChgV5Ssc28IRYFIWHTgqIs93TCQz
	pYcvQeRZDzLD6xSh9ABANwAG5Tw4TOMPn0iDD/pzT3h7U79FfotkylFpb638l0bTMgvpRt
	I81aU1qhRLOVHK2iWyG6oiGAJ4Bq5Qc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PkdigcFq;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EA3A60121;
	Wed, 13 May 2026 10:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23970C2BCB7;
	Wed, 13 May 2026 10:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778668360;
	bh=ZzMQKwrs8B6u4WEOzanO567l+RO2hrydIn7OzIi6yAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PkdigcFqYg7kgngvmc1Zg+e8nSoebVC897YRbfvvcVJb338fBeXZLs8HdeIzRy354
	 SzKevcBnEP4R3NeTNSCKNCcQfv4lNzl0Nf4bWMNfIQLLzJ8IQOtb9tAwaJpqKbEuKm
	 d6tvQ1P8fm/l9DZ3Oq94JuNh2/qbdFT4nVQneTibUmCVhcgQepdkHNVZqwadU3ZRv3
	 wNtg//yn0q1p8KhJlxevexxGaBX0RI6Gk3we/zAvKpKuw36Q2rX0CebFL/U/0trcCI
	 GwD+B+a7LSlauF2OQVxcVbzB5Htoar2TJgBhYC88x2NIeSpViE3GfKmXsvtT+HDnwe
	 61/OXJ9VmdcBg==
Date: Wed, 13 May 2026 13:32:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] kho: generalize radix tree APIs
Message-ID: <agRTQLJv9pMEZe_7@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-2-pratyush@kernel.org>
 <agG-OuOTAg5YD-CV@kernel.org>
 <2vxz8q9pdib3.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz8q9pdib3.fsf@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B8A9A18000B
X-Rspam-User: 
X-Stat-Signature: 6gzg6eosojdhxd9iywczns8jr7xa7j79
X-HE-Tag: 1778668361-99505
X-HE-Meta: U2FsdGVkX19Be8OQjhnkD+zSSDU3/jonkrEfRDsllRIhuYXDXqWQ3Dyy2LSeEnFc78z4/Z4TJP+frijnfBzfUIfxEW85Ib8CkFjdbZYGeOhgRQcxD3N6srmhOvMyGEcMP7ex+YACCD3deMYi109SvOt+OqQRPdBF3Z0zr7BQd5QCzasp73HrzSvgqxO7MQwZpntf25rjzWE0e+/SKsjYiRf2k1Z/dtQRBYTKtKpt2O2MPJw9ml276pxdyn5Df6fK30P26SOuCDlitg7xV1cFf95nXjVlzW1FUOWasswjHERJWPnrUUPorRiP2D0qw1F/628lSvZLXZqSnZUjAFwr1n6LixoprwqSP81wzHXTwrVlt8dQD/9+B3i2G99VxYobnNH3NhxwmupVhpcTpaeVIcTkN+7TRLKSmGKPHaGPOBQygm54zDXxRmKI7S1RIjUaGokoih1wCdwc4P333wdpm0vpncHpaS5mglPKXdO7WqcwGPpUpmzBzhpTA+uprymZtwMlo0xcVgvRwqOdHvjyq6TlTW4IRn/WS4/hUVCexIAKu9os2Tp/hfCPQu+pHJqSTASkJn1M+5ucjTnd31yLH17qc9SBNqnX9C/mAPGE/XcEUPWNDr1+gLCroUkJbNCcBLasQpuaCYItVoY3fZdDWGjBRnRBGyRW7NzCHkSPNhupX6MVkPYcNlpgsWjxE2JqTE0MXrzZLKy8/JmYmRUtkD7FAzpSMWOogHRV+3NMt+rAIj2AX0o6JxX14blPMS8Zx1RifPHUIH1J0vV8BOnEbI/1sRaPPQjDJrULRBGLlGC1ESg1kht8PIT4fnBQ5U2gyyyP12lczs8yZUALY7n9v2VTWGy2dgVvBC8aaq7PVJinZ4ga6Fo/1DnT4cfRudDID223U9Je4TPRSE2Is8bOgGm55enBYzAqB+QVKeGB7tmNTe2vzSC4uNdTPu7ygsSGl/8TphmZLO2fCy1ID6S
 V/K1OYi4
 1NM4UEEBowinv8sZfLEsa5YzHz1JqQ+w12fiZXjpjM7D3kPyVMfG04w1pf3UD+HMTCzs2DtC7fbynBtbOSv2VPOdIhKkGuhW/0oqLAMoruczPZLl3eK0MN+tSIBxTKLI344fYh6g3iDkrkY+3mH/dNmyDIX2RxKfCd8Xlg36O5saj0R8EpyOmqyxzLmcR+imP9ma8Ns/uNdTPj4auk6ELPmWcjIZxWvnWddEFUs72WgMC5Ae1TcCZLbKR/UG5nvB9D2BOv6zRaXQYwgsYSMeDD/1ZSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 06:25:52PM +0200, Pratyush Yadav wrote:
> On Mon, May 11 2026, Mike Rapoport wrote:
> 
> > On Wed, Apr 29, 2026 at 03:39:03PM +0200, Pratyush Yadav wrote:
> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> >> 
> >> The KHO radix tree is a data structure that can track the presence or
> >> absence of an arbitrary key, with nothing inherently tied to KHO memory
> >> preservation tracking. This was one of the design goals of the radix
> >> tree. This was done to enable it to be re-used by other users of KHO.
> >> 
> >> Despite that, the radix tree APIs are very closely tied to KHO memory
> >> preservation tracking. Adding a key is done by kho_radix_add_page(),
> >> which encodes it as a page tracking operation and takes in PFN and
> >> order. kho_radix_del_page() does the same. These functions encode the
> >> key internally that goes into the radix tree. kho_radix_walk_tree() does
> >> the same by baking the PFN and order into the callback arguments.
> >> 
> >> Generalize the APIs by taking the key directly and doing the encoding at
> >> the callers. Rename the functions to kho_radix_add_key() and
> >> kho_radix_del_key(). In practice, this removes a line each from the
> >> functions and moves the encoding function call to the callers.
> >> Similarly, update kho_radix_tree_walk_callback_t to take the key
> >> directly.
> >> 
> >> To keep the naming convention clearer, rename
> >> kho_radix_{encode,decode}_key() to kho_{encode,decode}_radix_key().
> >> 
> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> >> ---
> >>  include/linux/kho_radix_tree.h     | 18 +++----
> >>  kernel/liveupdate/kexec_handover.c | 76 ++++++++++++++----------------
> >>  2 files changed, 42 insertions(+), 52 deletions(-)
> >> 
> >> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
> >> index 84e918b96e53..f368f3b9f923 100644
> >> --- a/include/linux/kho_radix_tree.h
> >> +++ b/include/linux/kho_radix_tree.h
> >> @@ -85,7 +85,7 @@ static struct kho_out kho_out = {
> >>  };
> >>  
> >>  /**
> >> - * kho_radix_encode_key - Encodes a physical address and order into a radix key.
> >> + * kho_encode_radix_key - Encodes a physical address and order into a radix key.
> >
> > Let's keep kho_radix_ prefix for namespasing please.
> > This is the common practice these days.
> 
> I am keeping the namespacing, just moving it out of the "kho_radix"
> namespace to "kho" namespace. The mental model is that this function has
> nothing to do with the radix tree. It is just something KHO uses for one
> of its radix tree, so it should live in the "kho" namespace not
> "kho_radix".
> 
> Does that make sense? I can add this explanation to the commit message
> as well.

With this explanation it makes sense, with "to keep the naming convention
clearer" it felt the opposite :)

> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

