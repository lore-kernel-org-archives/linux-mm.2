Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2A65CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 10:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4016B0005; Tue, 26 May 2026 06:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9BC06B0088; Tue, 26 May 2026 06:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8C56B008A; Tue, 26 May 2026 06:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 906636B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:52:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24411C1991
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:52:36 +0000 (UTC)
X-FDA: 84809257512.09.25DF76F
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4CC57C0009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:52:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U2R4Boz9;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779792754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EimiBjgOCp06jII9evM9Ox6UF1NmDidggHL41B0/KNs=;
	b=LtzFvhng7QR7TldR22K8IPoBq1pe4dOFev+zy12ooBPawrn/NMO2d56aZkHoHcZx6/FjeC
	H3aM0vcKJNTlQtlcXuEtr8M3PeOmA3cHinBd5TKdDsMXYmS4e2WPoFPeUpVe92OLQWz5rA
	k9ihIt4YtecB1FEpbhO9xjn7p8HNjSE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U2R4Boz9;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779792754; a=rsa-sha256;
	cv=none;
	b=NKokl993ZAx+4UKcMr1+LYO1Sh4oeA9uTzismd8Kk3wGu6pel4a2zd7DnDKQZfJU/pglE0
	QlwKk2AWy0E9sbEkrMEpVyGUA8PZTzUtP4jUck+ShzhRDv6HTt6bwc+JZ/BF8QGUTzvqFK
	eLyPpS93qFT0+pi06QLCrTHcxKf6QMM=
Date: Tue, 26 May 2026 18:52:20 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779792752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EimiBjgOCp06jII9evM9Ox6UF1NmDidggHL41B0/KNs=;
	b=U2R4Boz9j3fv/QALraxNzQIYVODUZOIGIyH3Y+xXsZMrxKEy7Pd2QIppH7GKvOlCyPimyb
	k7Cu160hgk7TX0HCzfHRBlAAd0SWVX61AUoKlNBTnUzKR1VF/h7jzFgBj81Gks+b3RFo6q
	gync7ieKZoeiOll1XyxmVkCVS36nMJ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 1/4] mm: swap: introduce swap tier infrastructure
Message-ID: <ahV7ZJfBSNUtT4jo@MiWiFi-R3L-srv>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-2-youngjun.park@lge.com>
 <ahTTv5OWpaUF6S1S@MiWiFi-R3L-srv>
 <ahU5N1Yi2Ww+vN21@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahU5N1Yi2Ww+vN21@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4CC57C0009
X-Stat-Signature: 9hkifzfeospt191rgigr6pf7egmhmruk
X-HE-Tag: 1779792754-246512
X-HE-Meta: U2FsdGVkX18p7VC5fQJARGX8u+X93J1/jFSB3EYAXjgkut+X5oR4RTXiCsBHyrddYGvpku2Kp2DF1yiOnip66jZ8ezUbBi2WNFO6uOVEjtOF44XqWk3zpuv/tPspKUg0MOl8X+GGlqPTwWIGWzqBXLmSDI0VaGH1NxdSZUCD+Lf76TL47EGZdyYf+qQQ1oG3Z/wtgCR8L23DAfcGYbYa6cFaEcQjGCAGnYFNuBhWXcER8y1H53+jo22IxA+mNfw0zXUuzHmspcyFUeeXD0Je2aBhLMa/1z/zglZ85ITIEk9ZKfjopDlib0q9GOkgSGH0HCiRXuSIo87Imc7dNHAvqTlhkRN71yeuwG5upZEI+n/wShxVntWpElKtLOMaYlc2xL2JCm4Pj/S1UI/6wHo/QcoJv44MnBhX1DMcn3Of/FtiLbB4zSsR2sDYgTxQtQ/MZdQym9jF+sDJWzBA8uN6Flxvlz9K1sNeL+x8TfoZalvCWSajRe13gBu9Zkn9JBd15sr1KePZ/jJ3S1/h71YrO1QytpS25vd/q6eypiWMCVi2uL70mlK/TvVdCC/Oskz6PWYFy9oV+Ay2JRj7Sxs2ccIxVNYvpmBhu+0bYTTu1gWgJeg2Yt3b+0keKLnuZSHtWYVDN4cNoSydypVpjlYPUg3uYxObpgBpZHq/WRedaTvfTx8pwSqFslAbsv6MG5GdktaRny6CQhvgf4BiKc+iCvc9EHMyBDuRnFQ+2AmCUer7/5Q0piC4M6Q9U9qHzo4jy89HjXFZHBfXvl2a7jSesdfFDUNlgE1Jk+tCU0RD5Zb/PbehW7353oNmCG6U2/yfgJvEX9FdAYYCJETPQqw+DGJEAw/Q3oKWzdRh4J36joN8Txy/QXkQ+jyx3QMg9lEptfXBCIlc7LMK7g96E5SPB56bFHw7e6tQaDK7Bsmjp+TjRj7mi9eP3VfwWqhbBiqlSBDAo8ixw1rNplxUMbW
 8gWzA5EY
 p3eESb21PTI/dC26Rn4KtsRO73u5XZOSKaVdv3dWgDNlmhIKfHO0f3B3DYGURmMvRouUTGEu5keIy+/9FA1eozJaCZjv9u3LbGuxl18osJnAUSw2Bev9XFsUjR6ilIYgiEdZu4Y7Nxus0EaBkPBFT6nPvwxBjNDXKJSBSADrevmcQQ2X5JOCGQ9b1GB6IEQ6KSwn0IlBoVrf68fP54NNmyV8X7LoxrKm9ZOooVAMHvUsTpy1RauLu17hiaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/26/26 at 03:09pm, YoungJun Park wrote:
> On Tue, May 26, 2026 at 06:57:03AM +0800, Baoquan He wrote:
> > On 04/21/26 at 02:53pm, Youngjun Park wrote:
> > ...snip...
> > > +bool swap_tiers_validate(void)
> > > +{
> > > +	struct swap_tier *tier;
> > > +
> > > +	/*
> > > +	 * Initial setting might not cover DEF_SWAP_PRIO.
> > > +	 * Swap tier must cover the full range (DEF_SWAP_PRIO to SHRT_MAX).
> > > +	 */
> > 
> > If so, do we need check if the upmost boundary SHRT_MAX is covered?
> 
> Hello Baoquan
> 
> It naturally covers SHRT_MAX.
> Because  all swap_tier object prio represents start of priority
> and the prio value is assured on the range of DEF_SWAP_PRIO ~ SHAR_MAX
> on the privious routine.
> 
> swap_tier_validate function is for checking the first tier cover DEF_SWAP_PRIO.
> if it is not, it breaks the assumtion "cover DEF_SWAP_PRIO to SHRT_MAX"

Thanks, I got it now. We only track the beginning of prio range via tier->prio,
while deduce the end of prio range from configured tiers. That checking
is reasonable. Sorry for the noise.


