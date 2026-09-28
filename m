Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D183CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8DD6B00A1; Mon, 28 Sep 2026 08:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B136B00A2; Mon, 28 Sep 2026 08:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA086B00A4; Mon, 28 Sep 2026 08:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEC0D6B00A1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:17:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 574D5C0151
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:17:54 +0000 (UTC)
X-FDA: 85263072468.18.F92949D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9BFB52000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:17:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JPEG/58+";
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUWE1Nns7BSebGwQ1gbt/Sg0nKXkGgJZK1GCdXS2Jc8=;
	b=GoAs8pO2sgmcInaZ7kjda904UCClB2YThKE/mIt2aLT/eJkPbRLhBzKWHWJqHR/mm0TSOz
	cmiRxsq1QLeu15HpVaJFULTAstkaNP0VnyZB2MVjJ3Qxj7IUHbyBTXU+GyUjwpV1vIzIu3
	v7HYn18H3EI6SFSqVCeCwv/OfQrRKZw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JPEG/58+";
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597872;
	b=3EQWwn00QkxDp3JLKVLVScKIzWhSAyzDZ3aZKTGTykb4iX8JiicxHdPc/537Gtz6Av7gPI
	vcmhRUAUMm1yqTMz36O/6r6KfQoV9VCenCmecKzOCxZM0eI9jiNUdt5tWWIculM5r16Dp+
	mjO5k55/xrn3wK/btNLJsdhk4ctXsro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD7594164C;
	Mon, 28 Sep 2026 12:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B015C1F000FF;
	Mon, 28 Sep 2026 12:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790597871;
	bh=qUWE1Nns7BSebGwQ1gbt/Sg0nKXkGgJZK1GCdXS2Jc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JPEG/58+zJnmurdypr8TjzQsxuvsVil0Pev1L5z1BFKhc3aAa54QqiISdgVscORKH
	 Xn3S7sfgSQ4Ep/sfoXQXEK4Mdr2AW2mf5/Ssk7kUaO16YpjNxY+2jFJ1+nCpeXKA3p
	 Xp1phBI/6Ir5ODbctL5zt78mymPzKYxCTUPiZrFPimEk196Mp6ae9udyzsA7d7g0LK
	 cMiTxdeWkjMkeqiZYlfvZS2XzDtZmsxSxMTjf2katOZz8HaNN6xdNtwK3q06EGeFQC
	 K4wgQ0Z3Eoh/Spdk+vCQz2k8S3wT9jeteeGQ/mUYvlQMFw1dqI4t2Wzn9KTdR73wcf
	 7v2I8DqZy8h3w==
Date: Mon, 28 Sep 2026 13:17:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: check MREMAP_DONTUNMAP mlock accounting
Message-ID: <arpayEY9Xk5dB-rj@gremlin>
References: <20260928111055.482136-1-azpijr@gmail.com>
 <ae606df5-7d14-47b4-8569-fe47321bfac7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae606df5-7d14-47b4-8569-fe47321bfac7@kernel.org>
X-Stat-Signature: ai9at5zad6987x4iiwirdnfaaxfko59n
X-Rspamd-Queue-Id: 9BFB52000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790597872-119096
X-HE-Meta: U2FsdGVkX19BKbYfPrYrw1K+ZQ7jCjn6sy9MZNZZ46w0vGeVytx5xzW+r/oWHmqQXv99eNWQYyCycRs5ah4XFeQ4TNT+SXIrWlGVnmSCmmEye7MivgARcNm2qsLY1fpFFqa6VQV3Ou03F4hGQzgFyYFLuJPKNnAwNP7tbyB1fdsGPqV7gP2Ep868DvoTf2cXzuznaV6n9rp6E1EBxJsh5D3hNE0nSzLr4pI4qyLNvkfU+r65+rr76gFFT5ww1jmiOfQYr/BbefQpdd7piJu3GKmsuZ5kksNBRSv1lKMz9X8/HhsJqvX0HxPScJyLJrqJIZ7CmHweh8iJTNc6R1ZbbTi+xFRqKe8I7tFm12Y4OcpEfh2r0I5DrDapfGkLFAI1HLWbfW2gHavImLmDYWyjGBu4lLYGj9JCjj00AM/5a59laDby4vnamHsiJPhknFcweIaC+ovXet6pqEPniXAOTY9HSrXrw/8ezuN99z9rNA15EPyjhAdDYQ7JwSfgLkZrIHrv5j3td3hmOmmaMu0nim+0pbdauyK4rkHRmUhGhQMbZzo2DmrPhjomy6N2VbXIN5pNkR+RxZ46l34lvKqxcoT3CMNx9skgVp7lyQZFIT1+raqqzmLIqXTBCvob2hOSx0a1ozoXSWvHLxVIEraju1f7T9z4acUFg9PM74VvVxbsqdU8Fd7Vok0LhiY16PQciGJB4u4qXJ3M1i1HPER+T14vopYAFWBqPwJoSzBw/NyqsiJQ827EB0R9fJLwk4PXgPoCUYRKIad+E0u9fatEtcsHkFt01aWgUro1r52gil3s8I43wwQf0Qonp95bu/FAPPl1DQ1o+73YTVQNbLOZuCG/RKGENdj67qqJl+FEAOr7SL//00uWMbTh7m+7ll44MG8KqWLh1Ei5R/FuBb9r8CdfxoEXqpCLFjgT7A7k/P9TSt+RVUUsw1uYyaNovzV4SKbzU2ccOhCvk4msHCD
 b28EiQnu
 kI2i+jvHr9ZktgBokUN/5unQpWazn+aTQJQIl+A5jDrgK7tgDLQwi+GZNTTGTFKzASuprSeKF2/LAez9hGJtDaVfsIHraNam4o8+mvv6OGZs4OnTks2lsH01H5zMKEt3J9HM9CkNNLyE6pU0rwVR8iJkt+FMabOFnVkniEIH6T3ETUVSsizOB8dbnRp1SVuUumSkk8b7FvkpgeJPwncz+0uRfOBp6S4VATS4U6xxwsM4CuGHTvQOpOJrK6GDZS4LVStJQ33JY9NaTRqey0lB8zWNUEkTeqp8/bk3MnKNY5b6S9oICB0vBVO1OB3KFZ/wXwOvG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 02:08:51PM +0200, David Hildenbrand (Arm) wrote:
> On 9/28/26 13:10, Jose A. Perez de Azpillaga wrote:
> > MREMAP_DONTUNMAP keeps the source VMA in place, but clears its mlock flags
> > for the whole VMA while setting them on the destination VMA.  Two cases
> > leak mm->locked_vm as a result:
> >
> >  - an unfaulted mlock-on-fault VMA moved behind itself self-merges, so the
> >    single resulting VMA loses the flags without the accounting being
> >    dropped;
> >
> >  - a partial mremap() moves only part of the range, leaving the pages which
> >    are not moved accounted as locked in a VMA whose flags were cleared.
> >
> > Add three cases to the MREMAP_DONTUNMAP selftest which mlock() the source
> > VMA, with and without MLOCK_ONFAULT, perform the operation and check that
> > VmLck comes back to zero once everything is unmapped.  Each case runs in
> > its own process, so it starts from a clean mm with VmLck at zero and a
> > failure cannot propagate to the cases which follow.
> >
> > Verified on x86_64: the three cases fail on v7.3-rc5 and pass on
> > mm-unstable with the fixes from the "mm/mremap: fix two issues with
> > MREMAP_DONTUNMAP" series applied.
> >
> > Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> > ---
> >  tools/testing/selftests/mm/mremap_dontunmap.c | 273 +++++++++++++++++-
>
> @Lorenzo, could something like this also be implemented (maybe with less churn)
> in the vma.c selftests?

It's unfortunately a bit tricky and the work touches mm/mremap.c which is not
isolated in such a way that the VMA userland tests can exercise them.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

