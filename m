Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A4EB606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 00:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EKlCtyFR
Received: by kanga.kvack.org (Postfix)
	id 43D6C6B0615; Thu, 12 Nov 2026 19:27:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE396B062B; Thu, 12 Nov 2026 19:27:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B0B6B062D; Thu, 12 Nov 2026 19:27:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2976B0615
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:27:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78749121C27
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:27:42 +0000 (UTC)
X-FDA: 85428207564.11.5C2BF6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC1A7100006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:27:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EKlCtyFR;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794529660;
	b=RjFbwPKro9jN9dGExwC434/mWwf0IXSxSj3YJ5ZVSWmF11ibilS4HW12w92pCTysvp29pS
	6guB5o06RtPf3OTwuFN17tbtlqT0ijO2uZMzXpn5OgjMhIL+2K/+JSiAerTBpCFibcbroh
	YQQv4vCI27pTSuS0Qam5a2mGjkZ+Gpo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EKlCtyFR;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794529660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4uyCKwoU2ZUCtJEnB2UmwB5w4/Naib62nyhZDy72sc=;
	b=OeXz+MMKPxy1o3v6LVreBeOEoQQLmWu+r0pJwxVSRAERgyAm/h+FgWL2urI172gamA0w3k
	SoChSQ2x1XzpaCFdNYrZ+7K+iMHOBKrjRdiuwW46tTm+eLLnU9EU0L6b+rWZ0uqVlOlWeY
	eZYlMaeE1aGP2b/E4wAjcdrqBatHdgY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 140BD601CB;
	Fri, 13 Nov 2026 00:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FF91F000C4;
	Fri, 13 Nov 2026 00:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794529659;
	bh=J4uyCKwoU2ZUCtJEnB2UmwB5w4/Naib62nyhZDy72sc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EKlCtyFR0G3LjMnWtYrdKkTgBAehi0VR4yOuK+2aRnoodEo+e1zmWIfkZTHLjYB1P
	 pMSxyfyQ0J0Ri07DLyGs/JZxFILKGtIY+BkEeQRW7wJpPeGqeemXoa8tbeg0Wce32L
	 dyK4nVN/Bzh+LcPW6JZ9e5fRVWKngprMwyRK+Xp0=
Date: Thu, 12 Nov 2026 16:27:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mika =?ISO-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>, Leon
 Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Lyude Paul <lyude@redhat.com>, Danilo
 Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
Message-Id: <20261112162738.d689b46268e077ac06f41d91@linux-foundation.org>
In-Reply-To: <ec4431f1-e70d-477c-b09a-eedc35d97691@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
	<avWpWBl1nPcRVmpQ@raptor>
	<79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
	<avXoJSGh5xjGFgod@raptor>
	<20261112164752.GA3692174@nvidia.com>
	<ec4431f1-e70d-477c-b09a-eedc35d97691@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC1A7100006
X-Stat-Signature: cooj56sd8w5e3xw3gesxkztbgt7m7qqq
X-Rspam-User: 
X-HE-Tag: 1794529660-203862
X-HE-Meta: U2FsdGVkX18Fs5aNvQ0nEfpEKR2CkbkcqsC7ZxjlYmxXpvHkk3DX8X/5UhTg3xBfxGT9PVpBWr+Ty2r5BVsqv/WJt/GliGc3NcRrXM79idXMdFmFgRxNu62X9TMhy9APcCkQ3GkOJtwZLAniZJPnpJXpMR7Vobqdh0cOdiRCfggOQqjTvgAQxqn+HLkUA+jRfCfZJxX6L9/K+GBgTLy6d0YemFQKJKP5+07Q5sp+28qhkONJTnYPlw/IF0ma8S+6X9BBWgB3H6lW9+6CxznS/9pd0+pqtFPkFdxSqLg3i+6fhiNCxArPY8DhMGWDvRccShSRjtNzMwc97t+r6+60ZLA+THUahRRshRS04YJ2E8HPfcnXiUqM/A+KQQqSCKnDiWKQbttEB+CogCwymeAroe5qLOQRvcHRJc08L440OYZgdfNNTz4g6v0lozoAAJmhDzl4Nh4sLIiW0J9YjQ31U1hegIPDeXqQbRpXA+fVvKxzDjStg98pJXSDboqTtbsPnJuHEPFSBcChtG0Rk0EioH/YPf2CUx9qqv4XcW12nnUBfCg6cz/Syj73xTz18coNGbbjWNwzZl9BtP3UIeerDDLNVa4roKBr+HcHnMpkKuC85OasWJwV0UMelkfpwC6gECXVS/DP9w2GvHmGqdF7IRlwdow4pQKoA8i7qukxKlhQg5LCOdGAaSEgELDRXcSLz3XhCZS94beZq69PvkuYU08N6elH3MfeM0ATg0njfPT8Wl/MatN+C4Ur9cvjeuoDw8aCDHDgSdUHgW5V8vNKM6+A9tgNcKjNVwZQalR/gMu9E/L/jj6XVkJzq2CXMPQV99zIGNOnoNPshSSeMJGnlcfGZ+LQLDN9W0RBKwa+5Wqt2q0MvZwnSLd9dXdjUrm/eZbbjW7AUMdLGU1MOhOJST24Fj76mprOF9o9hgrh8WLC7vBcqzlrUP7kpoPc3CrKy5hnLQuRMNdXHBAp+rV
 6ZASNhtj
 cqFZ02rqEokHxnvCuH/C8E6rhddBR7azWISn7ATO3OJui5fYW2sfenCsiwcJV5aYjRgTHthYZyy6jvW4Pjxkpdmjy5YIjTCYEeEI1pmC5hZLUnb1gW25ozrxBPuT0ZOIDXzieCHOS18rAVEtOFBRjp851VHYGAdk1+oS+h9Md7KuGW55ylvwkqPyFIc/tmFxavPlJsA7zWnEwXnsYRxOsPAs0111N8m/VGCu4G7tyktTL6Pc9orzhyp0xUr0LN8gGXH40z96IapAuJvldmnRICmWkhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 19:01:58 +0200 Mika Penttil=E4 <mpenttil@redhat.com> wr=
ote:

>=20
> On 11/12/26 18:47, Jason Gunthorpe wrote:
> > On Thu, Nov 12, 2026 at 04:24:05PM +0000, Alexandru Elisei wrote:
> >> Hi Mika,
> >>
> >> On Thu, Nov 12, 2026 at 04:00:09PM +0200, Mika Penttil=E4 wrote:
> >>> Hi Alexandru!
> >>>
> >>> On 11/12/26 13:56, Alexandru Elisei wrote:
> >>>> Hi Mika,
> >>>>
> >>>> I want to help getting this series merged, and I've been familiarizi=
ng myself
> >>>> with hmm and device migration, please bare with me if the questions =
I'm asking
> >>>> are obvious or downright silly.
> >>> Thanks for the interest and willing to help! I am preparing a v18 of =
the
> >>> series and plan to post it early next week.
> >> The series is big, and as far as I can tell the MM people are hard at =
work
> >> reviewing bug fixes. It might be better to wait a while, to give peopl=
e a
> >> chance to have a look? I know that if I see a series being reposted of=
ten,
> >> I am less inclined to review the patches since probably a new iteration
> >> will be posted soon. But I can only speak for myself, you know best.
> > It is at v17 and it is still getting high severity sashiko errors
> v14 was first that sashiko managed to review. There was a regression in
> last posting, but also false potsitives, and sashiko reports same issue
> then 3-4 times, so the reality is not that bad.=A0

Pining for the days when all we had to deal with was checkpatch. =20


Mika, afaict the entire patchset is a performance optimization, yet you
say "I don't have a benchmark showing a gain".

Recipients look at patchsets wondering "why should I spend time on
this", especially in these times.  It's best to answer this question
right there in the first sentence of the [0/N].  That means numbers,
and the better they are, the more attention the patchset will get.

>  Documentation/mm/hmm.rst               |   45 +
>  drivers/gpu/drm/nouveau/nouveau_dmem.c |  402 ++++++++-
>  drivers/gpu/drm/nouveau/nouveau_dmem.h |   12 +
>  drivers/gpu/drm/nouveau/nouveau_svm.c  |  155 ++--
>  drivers/gpu/drm/nouveau/nouveau_svm.h  |    5 +
>  include/linux/hmm.h                    |   51 +-
>  include/linux/migrate.h                |   59 +-
>  lib/test_hmm.c                         |  174 +++-
>  lib/test_hmm_uapi.h                    |   21 +-
>  mm/Kconfig                             |    1 +
>  mm/hmm.c                               | 1075 ++++++++++++++++++++++--
>  mm/migrate_device.c                    |  618 +++-----------
>  tools/testing/selftests/mm/hmm-tests.c |   56 ++
>  13 files changed, 1984 insertions(+), 690 deletions(-)

also, yikes!

