Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB579CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0976B008C; Thu,  1 Oct 2026 07:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980B16B0092; Thu,  1 Oct 2026 07:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897856B0095; Thu,  1 Oct 2026 07:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 694F56B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:06:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3504E80344
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:06:58 +0000 (UTC)
X-FDA: 85273780116.12.9681915
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 839D7180002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:06:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TqZk2SZ/";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790852816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkXuyHSbtVf4eYHlPuWTnVc0hAJ85ieRSImmWIYe7/4=;
	b=AR464+6//exqWEOTPoHJui2vF5wnhyyOVDOJsIqmsKfKtgwr3DPWcl8zb7DLhyl+E/JEIK
	UeWEwUW8BdI4XXBXP9o7+z8lZ71v//DumwIG6Jjh839fKHK86G4fn4Si9CnjNajCd9E+qC
	FbT0Yq1XM/4nVIBUo9cjQcdgc6pw/6I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TqZk2SZ/";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790852816;
	b=uWYWD0oVWajn8LbRj2RQVAf2jE+B17wGHmJAv6+Bx76Jb1+RUYA6dKoXI5v+TH524ooDw4
	Ex0KygGA1RKdARXwIvE4lYPKIhW851M5mfjN49H3UZvdHMZfBqdEwc44RwMpxuDpBVdUoY
	hsrpBgmDORQJGaLy9dXgnV6gK1Ytgq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2B7743C16;
	Thu,  1 Oct 2026 11:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116C31F000FF;
	Thu,  1 Oct 2026 11:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790852815;
	bh=CkXuyHSbtVf4eYHlPuWTnVc0hAJ85ieRSImmWIYe7/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TqZk2SZ/8pigdRKHqYx0leDaHTQMicntgZgVWLIj/8lyUDWVcCxo2ayEdd+gg0geh
	 lU92zvlhLMZNr3NNjlFOp/Oekg9VzaUVc3T0L6z3VNWI0xNRwTgcA1XHJdYf/4FP+j
	 7ZDv8Fzf3ygiXZ9aGAbEFkeX5PJuDdWLg5lYgOXH1+wx8UafefVWrpEOz5hACzdv8E
	 flzBLVvshzqJrHgxgKEIraQdDlNSHpSoOjt2A11kbg9N9AHbZqeczL+5T5R63LW/F9
	 wB5J7nZOK0RILQNXUNmgE9wq89o/fLLdXB2MrB1Fgw/Fk+5CaPXSlE7ZVoS49ySMVc
	 LJh7EGRfSfvcw==
Date: Thu, 1 Oct 2026 12:06:49 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Aveline Noir <jm5905938@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Christian Brauner <brauner@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: mrelease_test: fix retry limit
Message-ID: <ar4-wT278zc2Fmh8@gremlin>
References: <CANOyQmFzsssM_BXHUDrV+UuVD5SZMBmSkg3UQnmw9Ns1PV7GCQ@mail.gmail.com>
 <9a6a1c15-89aa-4504-8585-0f7861c3377b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a6a1c15-89aa-4504-8585-0f7861c3377b@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 839D7180002
X-Rspam-User: 
X-Stat-Signature: 3d5u9pgxwnoj9bte3ow6ckjfbpkim5fb
X-HE-Tag: 1790852816-261637
X-HE-Meta: U2FsdGVkX1/fG3xGRmkt9z6qtjBSinIh8qLdM79a2maNKhfq0xGR8a0NAusUj2qT75Pv+4qTIArYtxj/WMigk8O2VMZ5Gn6fv76+CVWwSsAjl8zviJrwZLB1xWFEbT1zQMGd11c3/p4NJxy9qZWuQHjC/j11OkWtqSpZ0APhABHQVx29t8h6n95IjA+MW+kWWIqYfUJlVbHZAbzAKTTi5z2V1HSpq7rCL2Njzg/AEJ3O9UjovjdqdVk4pqg6SjWCJIx3YdqLBvbb1TSuxIhPUUrHPIxkhH73cv/lENk8y4C3Ah8MhJSU5h0tbIy5ZARR4IIczwlOGcNQwzrKZwnpwO4tg8Tc6PR4H2gRJc9w4UvQDIJper67MBwfSHYte+qY4zz7g7ktmoH35DlamGVS62eKypIB3xxlFkir6LFL+tAYnvng5MGYsca07iDf/MuVUzWVsRcK0ZvH5sZMzlnaHj10h1GpPmhc41bT8rkkv8EgKUT9VeYYH+Vj8dBKTCOGjF+yTVZErPms4QdUz6Vf/3LYb8AyN9x+TDdZTHknJmGqeAd0zj9tPOXHbB3NPikkuU8TPgCyEp3aU5fvz4cKtfYNDSAny1SfLQsZqIfuoribRK/8zy+XYfMRW6XrAFmdlP7+1V/bwSEtaF7hTijZ0xPHSLiQINMIZqpapF8E3tx+g2w4VHJQ3DgRYayXKhqOoQGM1LG82P5qLkT5yLAH6Wesko+Ftjwzn75usGWGMneLCpwesPMniJRrRDye33xMLRJKNYdUZNa7t09IViQ5h40zSpR/mmCz88jpBDMl+lwCXLwuGu8dRHDaEU/rIwLFfXWeYReaFUJ/mQTxTuEj4DVIN/SU3jAyyfgWWKLHgPbaWSdhscAL3srawXqGCHp8XWJkJ6bb1B8lV3QBhEuNPcIp2rh7ctg8HloVWGdoMXvsTeJLHH8jm63AotiD+BaYv7M9WhglIIxvuTstep7
 aKyNkLrf
 LpKbtJyaNEchrx1CWyjPmiPRbVSanN9lUP8Yn+tPb3Pbk6BmdjSEL/nEjQ/CVAPgYx53BvzLfow781GRsLkIsK8kVpFQWnMMS05M/vyH+QWTvH3MhdoK4p2xreFkf4OxL2cUoJvq61ahOHQdVtoDADD8uxYUsZxN9WOHkrOW9LyrcC1V16vUTeqx6YcVF3YbG79iehmH05CGH8PkDZpkdsdaWnD7dwGGwk3E2XvfVUk/C/iQBQ/jJGNde/IAYYyx2wWl8/T7oxUZ7u92Y+jfbTO0TxQmlQmm9r1XZwmMiFQbQcRHucVWyhNSeK9AmlGGscPt4VPmCNuPHGihIIPVyQJTVb3am93/jMRC6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 11:47:01AM +0200, David Hildenbrand (Arm) wrote:
> On 10/1/26 08:00, Aveline Noir wrote:
> > mrelease_test doubles the child allocation when process_mrelease()
> > returns ESRCH.
> >
> > When size is already MAX_SIZE_MB, the current <= check still allows
> > another retry, causing the allocation to grow from 1024 MB to 2048 MB.
> >
> > Use < instead of <= so the largest allocation attempted remains
> > MAX_SIZE_MB.
> >
> > LLM used in discovering bug. Changes were made and reviewed manually.
> >
> > Fixes: 33776141b812 ("selftests: vm: add process_mrelease tests")
> > Assisted-by: LLM
> > Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> > ---
> >  tools/testing/selftests/mm/mrelease_test.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/mm/mrelease_test.c
> > b/tools/testing/selftests/mm/mrelease_test.c
> > index 64e8d00ae944..a5124c9e9f43 100644
> > --- a/tools/testing/selftests/mm/mrelease_test.c
> > +++ b/tools/testing/selftests/mm/mrelease_test.c
> > @@ -157,7 +157,7 @@ int main(void)
> >  		 * Retry until we succeed or reach MAX_SIZE_MB.
> >  		 */
> >  		if (errno == ESRCH) {
> > -			retry = (size <= MAX_SIZE_MB);
> > +			retry = (size < MAX_SIZE_MB);
> >  		} else {
> >  			waitpid(pid, NULL, 0);
> >  			ksft_exit_fail_msg("process_mrelease: %s\n", strerror(errno));
>
> Makes sense
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

