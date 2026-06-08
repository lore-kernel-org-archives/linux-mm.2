Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A802DCD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 22:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9079C6B0005; Mon,  8 Jun 2026 18:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD396B0088; Mon,  8 Jun 2026 18:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819DD6B008A; Mon,  8 Jun 2026 18:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70E016B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:26:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1297B1C1F8C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:26:22 +0000 (UTC)
X-FDA: 84858180204.18.E2F5CD0
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9583F80009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:26:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=skwSVs6w;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780957580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R032pw+MUGAC5psDqJFtlX+YlXSRVhLJfeqjnFhLkAc=;
	b=fSoZ8uUIervefoJ9KbGxiIQLeg2ntW8ITIpq1Lnwm1M2PWPfubEw7F6uncr2VMVQOAqXel
	QhHX1JQjFvPAg996TEloaPoApEPIWxWUCM8Gbr4sDvPE5bkwuDgTzyNiHlQqC6l8yI6x/R
	ao1cuB186rHxwbdy0rD6M7G7Ftn90Qc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=skwSVs6w;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780957580;
	b=DxDU/NZ+1mNdv1c0VNYDsyZ+P4Klvneomz8MVgtqMuineOXSKDKum/zypgaPPgt0GeEObc
	QZCBT+m1rAnoHOaUXaG6kNcrUHPR+WTkqzH1TwGUAVgjrNKixWhmRxG8JzIb9TYDpXSa6N
	K5mud2Vbwk0HAct63sk00Q1pROTln4c=
Date: Mon, 8 Jun 2026 15:26:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780957578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R032pw+MUGAC5psDqJFtlX+YlXSRVhLJfeqjnFhLkAc=;
	b=skwSVs6wwyiFuGTAKEz1neA8EwFRRvgEfXA5P2gEtm/D0phiVv7bgk5PkoZwMkskGRdcS8
	R56w+WMkwTR+4nZzJ5wGDOe9UX8gOEpD1fcg5NhqB4Ah2qmZzVNpPCPQEyJHW5KhfK8/KE
	gua3WaW4eMWh8NBUbxKIEhT+clupfUg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 0/2] mm/vmpressure: reduce CPU, memory and code overhead
 on cgroup v2
Message-ID: <aidBd3Us5FSBKZVo@linux.dev>
References: <20260606114158.3126210-1-usama.arif@linux.dev>
 <aib11jSWosT6635u@linux.dev>
 <750406a5-1819-4ca6-81d8-5a1d82e0644b@linux.dev>
 <aicdqucZVqAUfh7N@linux.dev>
 <744aae62-ad99-4534-906e-92ddad978ee1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <744aae62-ad99-4534-906e-92ddad978ee1@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9583F80009
X-Stat-Signature: s875geebijm1ay3jbj7thtk649r9okpg
X-HE-Tag: 1780957579-255642
X-HE-Meta: U2FsdGVkX19pk69UcF3eWI8qhP2/kWYyN6qeYzKqzrK3WmooE7sY5DIDjFqc0I9+j0MCEkp2cCtUHr7Roj0TnLoP4Fw1C/8xlHP5lpLFUu+IhJ9ps3eKwkuVKrDMXvgPNdw26GCGPNcTU5mPebCQE61Gn2mZp6lhf2KtuKlURBcgU7z7+OHyGvjUTMKariTk09jsDZFTWTkG5c5N9M2jtXgmint8EQa5SQQ9jcVZzFONhytRlwU4Rb78qiHKGILIYmYK5QYn5ee834WnDnKF/VK/2tKQ/NR//87q5I4BnAnDfxaueaqIRF6CiDwjTPLpF1NSIt7tydDrGNIi4DyB8ONHrPpvUfauu6gbUE375NgI449MS5SS1XsZk4StbuHOKkTmt3nnjmhFebkLMV7hWLinGkPpWWHBLyFkcyeUb6rPGLThAN5EZtrpVTH8741GWCC9EwSzuUYs7bqso1yg+ON8Aj3aoxxDR7UMAyK+4bKJXEjheDDDFXumE0UY9c4OWy9Pa9D557ChJgMhVzf/xU4/RICXj1Q2oyzFgAnmnoYgGQcDcKUOlUACmCeoDFodW7T+e/GgR6bjqbuzcCXxHbMaCu3i1rdzrFttfWvnjyyYXLBv6q8OGBOLl70y74+BPg8uuxOFjc1BWQRKliLUTbCMMYw09v2+1YymMPG0xGKYeehU3cyoTIHo8p0k+SW4HPPWksHRfWgNaJLNaPeXep3+SvvXS39UUcCw/wQPQhdQ/VEA3e+W93xdiEpPBUib6qMrMeVKXfgObR3y3vbV3mDJKTH8AUVXA+PwF2P25UjErboMPGOtXOvOg8cIWmNXiwA6/wn4PoV11Xte82HD6sS6USqJs7hllprf5eLD4CRlo/4t1mnCYnjvRHONB9xmZXZzGU6YcWmp8eVJnA7BF6VISYC3mj4jtGgubCzBifIxPdbuREc17cHemw6QgKfCOCKJ9Iexo2BK9kozt6l
 oJfYUSO7
 Tk5QqGhWFXHPt7ddFrjVJT3f+ZvwKgnGR5sBJ+x5kOR/0EsU1nwwnwcBbwZgZ/4npuK8kvBLb+ybeVAap2Y4xZV8Mdbx25VbhSRBN8vEHfpCu2KSg36Iajhb/RcvR0dTP0sLFkXl3T97SPj2KyRfc5Pxue+gZpk74f3cEPZDVg53lA65JddWRUej4fIMvKnafQxwrSzlJQh2HP9ItMDQlL190mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 10:19:36PM +0100, Usama Arif wrote:
> 
> 
> On 08/06/2026 20:56, Shakeel Butt wrote:
> > On Mon, Jun 08, 2026 at 07:49:45PM +0100, Usama Arif wrote:
> >>
> >>
> >>>
> >>> For this, I am wondering if we should just go ahead and work towards making
> >>> vmpressure memcg-v1 only unless we foresee a lot of or complex work is needed
> >>> for that and only then patch 2 makes sense.
> >>>
> >>
> >> I think there might be a transition needed? Because vmpressure and PSI
> >> do not work out to be the same and people might notice a regression with
> >> increased memory usage or a hit in networking performance and might want to
> >> opt out? A solution might be to switch socket pressure to PSI while
> >> keeping vmpressure around gated by a defconfig. And then in a few releases
> >> remove it completely for cgroup v2 if no one complaints. If we go down that
> >> path, we would need patch 2 for the medium term.
> > 
> > Yeah the reasoning that PSI is not an exact replacement for vmpressure makes
> > sense and it will take couple of iterations to transition v2 (networking) away
> > from vmpressure. Can you please update your commit message with this and about
> > the midterm or transition plan.
> > 
> > I assume eventually we will just have vmpressure-v1.c file which will be behind
> > MEMCG_V1 flag, correct?
> 
> Yes.
> 
> How about something like below in the commit message? :
> 
> This split is the first step toward eventually making vmpressure
> CONFIG_MEMCG_V1 only. The v2 in-kernel socket pressure path
> (tree=false) cannot be removed today immediately: PSI is not an
> exact replacement for vmpressure, and switching networking socket-buffer
> back-off to PSI may regress networking performance or increase memory pressure
> in workloads that today rely on vmpressure's hysteresis. The medium-term plan is
> to introduce a PSI-based socket-pressure path, keep vmpressure available for
> v2 behind a defconfig as an opt-out for several releases, and only then
> drop the tree=false path entirely, at which point everything that
> remains in mm/vmpressure-v1.c is the whole subsystem.
> 

This looks good to me.

