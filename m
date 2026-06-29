Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFCFAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4506B0088; Mon, 29 Jun 2026 05:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC046B008A; Mon, 29 Jun 2026 05:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB536B0092; Mon, 29 Jun 2026 05:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0C56B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:59:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 103D81C6B2D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:59:37 +0000 (UTC)
X-FDA: 84932503194.23.69CEA8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5CD9740007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:59:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRMhkfmu;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782727175;
	b=NKbnjCXx68fsOoKkYH6boVV/8c1GjPI0Prznt5y4G+E742aL2n38LDmtVoOW4u6jW33UCq
	n/WajcI2CgAdrP+V2VXo7plTXBnQEvOG1YZOT76Zcee0I22RRvXLgerE4XnONga2ua8akj
	HiTZxBm2ccyDsOLjnAMOH91t7CfFAd4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782727175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMapsRFdm1PFSt4n5Kx4fRcXn2nJ3ZS+Q6JyTjzdMu0=;
	b=yWzxrSB8lo3KJ4RMI0rUJVEAquTA6GHSsVY7jOA2xBek0GXkCEkwq8gM79CDQFcf+7PrpB
	BjfZ1YrNVxg2b/GNQWG8fnuqui4hkqhEJM/erkxWXa21h06hZ29OwOJel0u8ir5mU2pUVp
	jsAUXU6O1rO/Y+Fw5YXaqnXMnVF2hdc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRMhkfmu;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 761BD43E05;
	Mon, 29 Jun 2026 09:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D1F1F000E9;
	Mon, 29 Jun 2026 09:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782727174;
	bh=xMapsRFdm1PFSt4n5Kx4fRcXn2nJ3ZS+Q6JyTjzdMu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lRMhkfmugXROtoJKY71+zIary7pV5lG50fYBXPzQGviugLtdYhw3yg+eQyVnF3C5A
	 anfGNxHpT5nsMdb9JKuwkixzHvdWTdxdWfhG/+PwPzeXg26RVHaMz8D1xz7D2YE9D9
	 sqvsrHAqAAoondkDcXQTRVF80fo8nMFvUuzUPTDABK7YVH3+/oPQDEiW4DTusTR293
	 LPMbOdVRzKTN8dI05sVpilcE1kMRGhLuj7e94dFe8qSuukkIaX+JQiF9ycO5bTrjec
	 GfdJU1Lqtm2MXXSKjiXumpFFjs2mXyc628+h3kZLx8QWwoG6WkNcWfogvP/7dfpoT9
	 YwjOmJBYAiY+g==
Date: Mon, 29 Jun 2026 10:59:25 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: s/SeongJae/SJ/
Message-ID: <akJB9EYPerO90rEh@lucifer>
References: <20260627195630.24519-1-sj@kernel.org>
 <e29d1211-8bc3-433a-b1d7-d7fb44c2f0cd@kernel.org>
 <2vxzo6gtk89r.fsf@kernel.org>
 <akI8lkVb5CICUcWi@lucifer>
 <4b12ba64-5e2f-492b-80dd-b9be95604026@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b12ba64-5e2f-492b-80dd-b9be95604026@kernel.org>
X-Stat-Signature: y6ctdj3sq4pzk3t1ea9wzb59mh8ip7a8
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CD9740007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782727175-227106
X-HE-Meta: U2FsdGVkX1/rcRBoQf44IzpcGFSwOvlOTHZL5mU8IsfFpP1kuVwa0BoqbKl2J7vJhXmKfMPE+PGl+BpBLrBAoO6/rQNprzrndh6ORfrwS9jqOUsbklw1u1Wvr2vxatGO8uKWhYluf/lYIf2oL1OnpvgBLxctyB/3yHZU1SaNhNCmoshV9YYYV32ESRHMchcgoc/jV+b0p9P3gSyF2orlNiHtEJS7wklQLhYtlf9zOZNBwvwKGSMO8yWrE8pHrV4B3igHmPszoE810uVL7HUavR2WBb1CUzsAfoQ/WkosASFy1eMDU3H/7a+JddU6J+pJAWvWEGLmXGPvIQRIAJncO4sznUgkOrE7hUHyQ8ODuj0CgMpAQFn0mVDBIGy24FXp98p8/XdJDUw90D1IxhPbdhNTGVreeePrGLtPlrO6o27pvgRM2EZXQFUmWc1gPEYv4/jWw+k9xR8ytQ6MO4ca6zYbBwvGyf+IgZebZYeL6ThX+0EQ8iwTgBmg+INaUQMb8HmDGwe0V9vUv/3ahFbI1v3ia3yOtQHS7fAgwtX6LiQ7odWeOlTh4120+AmBktXe2zMAvOiFgqBGeGpw3zRqCqcnN4+Umt8+1Czo/TUosGbFu6tZEE4zuOffU2oKb3j6t3BGmijsvhPaVvqNpKf6Hhahfc5CIzbCijkJs3vp70KsHD1vvDfSx+ZIXxOVaP9QQRjB4PhgRwpDXRVhA9Ur4cEQkTm5TjBlIKnE5NSHjLzRsBrE1LCg81TXNkmNBI4W5ciBeEFYlE4bsoPeCWO/eWVmjaYXOYUeqfkoJzwPQJuQLeWrZBK1AesW7AUxPWs8KUG9obhlLJc/LnHCG/xypQuFCGdimAjt3xifG7bq5aJmwmQu3apFfdbcPj8wwiTwagKhfZT8FbZVZrHkxX/p6fU9ILtOsAhJp+VADEQX4rloUMPCgy8l4Dj1tKa2lXkkWgm9NfQCy3ZCreXWE4F
 AWiLcRmo
 zyzGXYC6ggz6I+qtIiUsQdkxt0yPlq27zkovaF0YJGnHxVvRJjeVw0awjW8l23poJxs7raWp8f5Ni6TO9sSpLxwr0AEGFtsxzgfX+/8nR5/X61Y+ZTSn2tG9GMOyAnVWFB7FEQFEk3hq2lAUvdM6AjoTmhcg5czEYAXs3icGUFufMuiaBs9RKa3JcdcSMYsTOsxOrVWcLljeMvWM8cnDyL2DWM1ldAecq0cGrCBKwt56xVbLpvttgJJYnP4DNZ9c94dtM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 11:45:03AM +0200, David Hildenbrand (Arm) wrote:
> On 6/29/26 11:37, Lorenzo Stoakes wrote:
> > On Mon, Jun 29, 2026 at 11:25:52AM +0200, Pratyush Yadav wrote:
> >> On Mon, Jun 29 2026, David Hildenbrand (Arm) wrote:
> >>
> >>>
> >>> [...]
> >>>
> >>>
> >>> Just curious, why do you drop the author and copyright information? (can you
> >>> even drop the Amazon copyright note?)
> >>
> >> Off topic, but I am curious how these copyright notices are supposed to
> >> work in the first place. From what I have seen, the person who creates
> >> the file normally adds one for themselves/their employer. But then other
> >> contributors who make small/medium changes don't add theirs, even though
> >> they should hold the copyright for the code they added. Bigger refactors>> sometimes add a notice but that isn't done consistently either.
>
> Yes, I saw it on bigger stuff as well, but not on small stuff, really.
>
> >>
> >> So do these notices even hold any value? They certainly don't list all
> >> the entities who hold the copyright to the code in the file. Only git
> >> log can tell you that. Is there even any point in adding them?
> >
> > It strikes me as a rather loose convention.
> >
> > I am not a lawyer, but I would say that individual and corporate ownership of
> > code are implied by S-o-b, not by comments in files.
>
> Guess it gets interesting once the SOB does not carry that information. Also,
> some people might work at company X (and send code from company mail address)
> but may hold all copyright by themselves.
>
> So even the git log cannot tell that story.
>
> But in any case, I would expect a comment about that in the patch description :)

Right yeah that'd be nice agreed :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

