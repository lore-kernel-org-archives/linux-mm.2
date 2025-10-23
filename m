Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F65CCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B89148E000A; Thu, 23 Oct 2025 03:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60D08E0002; Thu, 23 Oct 2025 03:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9DBB8E000A; Thu, 23 Oct 2025 03:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 992A48E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:21:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 317DE88EA8
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:21:06 +0000 (UTC)
X-FDA: 84028532532.28.6A97FF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9A8481C0005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:21:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XJfjDTDO;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761204064; a=rsa-sha256;
	cv=none;
	b=AsBP9Gfqhevi6eEnoWXFDui82akGaAIfgy6UcyPk/SQgwcCTn5r1BKTRRvX9qSNmlWOZ4X
	xngFk58bWuAd/22sfTEQjh5MKA7uXvFRdIbZEH6xE8ulwoR3yyOboKrOTWaVzycYd10fx1
	S7M0CC5yP4xxu3Y7YwP1Jf4uDoZ2i4Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XJfjDTDO;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761204064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYBYpakV/oHXlqK7vYeuZr2C2laeQWeSXuhMhDH9eok=;
	b=vMIpPLe+GtCMmMqger2/qsV7+LcnwQhkMTUtwyLABK2fPXsDdQ3Zlb7yCLatMY/wlRKWCC
	gaViGw708QHedFB/UpWDdvUyzaBljoXKgQ2Qm7pUwWOrCwSjVsR3Wxtwdnn/SmLCf1nmUo
	jTjQJSa68e4bTIYI3nyzrisKy3OAbxw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 08E4063EB6;
	Thu, 23 Oct 2025 07:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CF4C4CEE7;
	Thu, 23 Oct 2025 07:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761204063;
	bh=GEunqVYG6q61dM4benmxjxOVFq+a4931xrkxsYdnZ+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJfjDTDOyC/FjwMNQylaD5MrDantTgYxOhKCCP5U3juDPgS14qRbG2gc9z1//5vld
	 U5qStXNYcvSwPpKgLhqJRC2eTZZPrGY8vYdl08nF14ofhNRa45ZtQD2z52X3pXJxEH
	 jv0Nj2iq+tgTWN1+Xt30cECOfbsxtLCkXQ9EGo3wN2q6lvANrqmRuHbkjjqvwJ5cA1
	 Suq++GZGLNfjSz91IkxN0TVeO+Y7npqe0mB+o0RP8Hqwf1b6KIlMLPvFoxVQ+Avj4K
	 BjL4vzqg4vlgpK4F7uhQrPR8BYEnEKBuMU2gZu2D/YwId8MtYUZGBwx06E7gHtYVoZ
	 p+cqXQjQvXWAQ==
Date: Thu, 23 Oct 2025 10:20:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
	brauner@kernel.org, corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCHv7 5/7] kho: don't unpreserve memory during abort
Message-ID: <aPnXVmD3cNmYNRF_@kernel.org>
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
 <20251022005719.3670224-6-pasha.tatashin@soleen.com>
 <mafs0a51jfar1.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0a51jfar1.fsf@kernel.org>
X-Rspam-User: 
X-Stat-Signature: mnn9hnehxj9ystnwf457ia9yk4qhqbw3
X-Rspamd-Queue-Id: 9A8481C0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1761204064-393784
X-HE-Meta: U2FsdGVkX18eWBhcnyAFgzSkhIIQ+R15LsByfmsV1YDQzfLGYJIk8VKtotjzyyBNWO4YpXOEIP9Fa/X7zF4OXqYDgWU961t2R2J+QkuZ1eV2JMouOWVh332pq2ZhKugHiObIDEykHe9ZY75V6DkuegktXcLZUpNZCkQhEyQShvG+ieD6Q7Qi/UayP3uGlJ/QbizGylLKgfN19x9yYmIBSuSU0FtMHZeP1eKgahz6DQ6jYVh8NdxLls3O64BVhI7wF/sMCPlbU6ebLzR6voaJP8+F22GvW6tJORiMBKmDubaRwLVx/HYYJIfPa+HIllbrx3H6kUxwGZoVUUqrkaDvm/ZFbB76cJbhnruo9jRoANBWX97CLMmAdxl/OV5cgxjuvmUih5lOCwNcbUd5YNaB+EuiXEeDyt7MgaQP64BDS21gQ7x96jA2Jr3rOPixbgWbuX8GMAvJMDQfSb8UlD1KszZRpkN3KhTNeDnasQm37u09TDhiKAFcj+uw3GkwRTHPPdHQHTGNjrH+Voc+bTuKm+MlSlWggq0256DRguuI5h4pnqQEVU5YGcnFXL5sb+3oRc/+TdiMlh+z+rMwc1UXQd7XKoZPqARAKupy1sTYSLo8H/4ZrNg2ys1FBtYfR3PGFSc0U6LYC9BBg2S8vqGtR5258W3od5hRa9arHxIQcgwDxg/EPZhZ4dC0q1McFbpZ3Fs9Hq7TZk0ZLmJlP8KyMgmI8CJYK3eHdZD0Ml24qpb1aegEEyww1Qg6sjJX6/R1NHak9gMm/GvTdGUKKig85nzYLpLUQZOdazeR+qc7PqyynZYZLZ5GKgzPS0Hpt3BgQBvf8WbLce+LSkmD6wjK0cWotz9AuP8xly01QoYfV4Jiujji3gbCUuKmQ1GY1iMga4wdMwIVNeZuv4PjvgQOk4HRh1R1F2ozEtV2N18h2Go7t2uBd7lx1k6ovbnLKdT7LMvrAUqyBBuSA2wMtnJ
 bc9i8GxJ
 CJfijrVUb0zdNWCNkFdKcbMKe6IAfKnKbLEjFduP4fRhY3EsHOHBi8M1r6bD3C1TZMZVZbe8GGLW+F0hcpFJrAzkdost/Z5/Wvzk12k31B9+GsFnEmHTx7YcLKwfJl+2e5wwF4WziSTaTwM/qLcc27g8tqXbC9dN/+VZV/2sVhXmVL/k6FBlVg8ZFtSQkm9mg0mTwfXe2X6jFqqsZgSf6617g6abIl95FUNxiY2Dj30M0D6m8ThjtV6b3K3F9PetgKDFq+GBuggYxNVZ3SJj1IuxcHOUUvsqhnNcYe+H5OqQvNn0qsz8862gb8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 01:15:30PM +0200, Pratyush Yadav wrote:
> On Tue, Oct 21 2025, Pasha Tatashin wrote:
> 
> > KHO allows clients to preserve memory regions at any point before the
> > KHO state is finalized. The finalization process itself involves KHO
> > performing its own actions, such as serializing the overall
> > preserved memory map.
> >
> > If this finalization process is aborted, the current implementation
> > destroys KHO's internal memory tracking structures
> > (`kho_out.ser.track.orders`). This behavior effectively unpreserves
> > all memory from KHO's perspective, regardless of whether those
> > preservations were made by clients before the finalization attempt
> > or by KHO itself during finalization.
> >
> > This premature unpreservation is incorrect. An abort of the
> > finalization process should only undo actions taken by KHO as part of
> > that specific finalization attempt. Individual memory regions
> > preserved by clients prior to finalization should remain preserved,
> > as their lifecycle is managed by the clients themselves. These
> > clients might still need to call kho_unpreserve_folio() or
> > kho_unpreserve_phys() based on their own logic, even after a KHO
> > finalization attempt is aborted.
> 
> I think you also need to update test_kho and reserve_mem to do this
> since right now they assume all memory gets unpreserved on failure.

I agree. 

> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

