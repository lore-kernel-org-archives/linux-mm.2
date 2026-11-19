Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A19606A331
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 21:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lLqObKIh
Received: by kanga.kvack.org (Postfix)
	id 278676B06E2; Thu, 19 Nov 2026 16:58:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24F706B06E3; Thu, 19 Nov 2026 16:58:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165E36B06E4; Thu, 19 Nov 2026 16:58:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3D196B06E2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:58:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C914A8B3A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:58:35 +0000 (UTC)
X-FDA: 85453233390.05.3CB1DC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 63D10160003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:58:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lLqObKIh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795125513;
	b=zFz0rBNO2+vkropCc5srmOQAFYtlCYMcbl2GrDRjDeAI3jqATJsEg+GiuF/ffm94rGXI7O
	p3rRR/GdBDhMP+LnSaB03Km6OEyIsNsnT6CjOmpjmdrmZ/L4YkwM2p/OtSbTMvIq6JqMJ/
	YGufvml/X4GRV1d/hTwbT41XLhzdUKw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795125513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8SDR2t2zxVahCHAneVGOMZ3puioc9QoYqLU0d97Nqk=;
	b=zyuSb1Pgp3wB6aKR9lRqQibX7ZHai8eH7cYTrfisf9IUX5m9lJAdbG5dzVJNdLgpGzRPKR
	RpcnixSMbznuAMDEWzz2FOJpZ7eNctaRU+MqAMqujkuL3az4iZy+zx8j0gYl7FJpAKoWut
	jn9JAOXz/rwb8kAli9kyxQDZjRY9pUc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lLqObKIh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D96A41187;
	Thu, 19 Nov 2026 21:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96361F000C0;
	Thu, 19 Nov 2026 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795125512;
	bh=c8SDR2t2zxVahCHAneVGOMZ3puioc9QoYqLU0d97Nqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lLqObKIhNNygk4h2p82iI261CxTr2k2iY7ayjr3+8jnZqelIIDtb7ImBiKsbVC81i
	 kJpTPr1JSVDZe+BADiKqaGTMPrdC10YlCHIaF33ijt2YWvD2JMIQ2iq7jfWdsgT2nJ
	 8yCSPWI78Use2UT0j8ekj0uwBhV/HNveSEX09INgg6WGWzOZowNAGJfhG5YADJ3Puz
	 XTW2cnC7o5eON1rbY4EYT4e7cWOODWW9XO2wohGTA94oSKizYwDqMfbcv/DxPAWam6
	 ctMoZdwNn/OPz+IMjwcWQxVRpMS2j7B/1JRpQB/iXO6Wc4qss5NthvifjfKYuUf20s
	 axP8cloY269SA==
Date: Thu, 19 Nov 2026 21:58:20 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 00/13] mm: batch of (urgentish?) fixes in oomk,
 cachestat, dev-migrate, percpu
Message-ID: <av9wrAMy8tzYPyOh@gremlin>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <90a961f5-e488-46de-8872-0e1540eaad4c@kernel.org>
 <av3dRm-Gkx9kcYWj@gremlin>
 <c3098f88-cb7c-4e9e-84e2-1d22023a795b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3098f88-cb7c-4e9e-84e2-1d22023a795b@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: w37575s8x9tzae8hoby9k63idkdfj1hh
X-Rspam-User:
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 63D10160003
X-HE-Tag: 1795125513-653333
X-HE-Meta: U2FsdGVkX19KADrdM7+Wv+t4+FzOt9O7EiLZwMpmC4oOmUWVSA8WaC/TQykPMLmGo6Aji3+5g1eD/+nlgU8u5VUskdqX3cPVpv97PT9vnUDbdKGxH1yK1g4FGScvJYCUG2dHd/Sq1h/px5jQgKVaJz8MmNgzR3Eha0cnJEwFALBKrBBd1aTMyegAC0uo7Go7cstBXslaxZw1f5k29vl4Cf/SnLP4xewiKJki9+tsxusyfV6dlsqSnJWxZNQnMqyxXxQcyJz/MmQ0dy8OIGQRr/e5uo35K1PtQ0D4dTCfkIRqmReApDPT3w5qiJJd3VIXExWWr+9XsLveaHXnnfkwcjRotoBrJnCQBVDeShhmpQ/TrjP5roDGq4D60xbDNyLI5B6zUKp8AHM9ysPvTB2s1k5QSZUnKdDdSRUabuJJoF8dWL6xDXZDsP+6eNYajba/Sx1Nwjbn5scxBOSTRxvgZzz0/FSOclPM6tW/dhihpfQ3ZvlATpohVL1n63vmcglfgxevEVUPk5JZWCuRfDs2U4CCB46bzJoihARwK6ZB4bQZsvK4lOeW5nR4lpnkUuxSvWy9kikgJULrHiQ9h+4Lhdp3UsWz+25YDpbR76z9suM3KG/W1De8zwGS0e2wwdL4VFePrZXTinx18+VtPD+h9EePDopmUBriX/4spbcRkoSMDsXV+2FLXljCoTqWenYBY52CyFcId5/xoGOeSTRRv4w1DfRi0Pz0ifHTZZvRrED5ddUDJoOO3HbiLxyU/whhzmVgmlBw9SXAvyHHwAvb1uGMICuAJHTZblsAxqwbs1DQQrLKAI8nPxTTcVf6cs0g8+QXsZq8iaQikA5LzhnToUVOmYJMprAvnOI87TszZtvsjnP+t9jh9NJEbjvPaHgElHu9xxQ3fgZHRXaBE/s2jwqvSwUG911wo5kCptHU7QXKfbInZDbdocyksF90U3IwuZljboZxAv1FDFqKywX
 pkXFH3M+
 JOO7bPvS0yf1SViiVefN1VElVQfUISUHa0tSbt4oXJanP/gFzpJTxDEVwBy2BZpamh4iIsiBFXIePyF0WXO7V4J8bNigajIXX7DbfoHs38eoWhlPFmJ5KVeECS/gOeom5gYM4yb5LYEo8/HtCROpJ+JQuQicbPR52MMKZPxyQHOwJy2YJJvTn+KlVaU4n2TwnvI4IT6t4dlQ/D4zRBstD+na6kUYaCD4riUFEIKn7/+s+W1wQRkKRGf4Io7TYmp9O9B/XNFH4hUNoMa7ahCeYPrbIvi5gp7hEQ4PwDQKXhkm65wayAhyWvmvvyePPbKpHgHNGJa6jKAEdas6PjVW1LLSY2IxDiTnJ4olFnTnlqpHJE3my7sTKWZdqpSJy93KMgT2jd8IllrPnVEb0dYDtjiudguKTLRDu1XJsnAhnyUymylq8rOYjpW+Qqwqc+rs9216djNaiZPq4S/eC5iWHDxtuC28BVBnpw0+ZKUB6Jcn0qJEMXviM4FRErVB6mzefXsXcp5yjiHuxtPFRFmr4Qp1xK25yUpXiS199rysUjF9Ckxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 08:47:49PM +0100, David Hildenbrand (Arm) wrote:
> On 11/18/26 18:21, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Nov 18, 2026 at 04:35:32PM +0100, David Hildenbrand (Arm) wrote:
> >> On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> >>> A bunch of fixes for oomk, cachestat, device migration and the per-CPU
> >>> allocator.
> >>>
> >>> These patches were originally AI-generated, tamed into upstreamable state.
> >>>
> >>> Some are more reworked than others. Those which needed a significant
> >>> rethink are submitted as mine and marked as Reported-by the relevant
> >>> original author, others are smaller edits which are annotated as such in
> >>> the usual fashion.
> >>>
> >>> Please check for correctness, sanity, and whether the cc: stable is
> >>> warranted (I have not included it for 3 where it seemed unwarranted.)
> >>>
> >>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> ---
> >>
> >> Lorenzo, I would pick up the migrate_device patches now.
> >>
> >> Which one should be fast-tracked upstream and which can wait for the next cycle?
> >>
> >> Use-after-free, shadow stack and out-of-bounds write ... look rather bad.
> >
> > I think given Gregory was able to repro nearly all of them, I'd say most. They
> > are mostly small. So patches 4-9 I think should be.
>
> Just to clarify: The later we are in the cycle the less non-hotfixes Linus wants
> to see. AFAIU, really urgent stuff is the exception.
>
> So the question is less "can this be reproduced" but rather "is is that bad that
> we want to fix it asap".

Yeah I guess I'm kinda saying it's hard to differentiate between them :) or
maybe I just want the migrate-device horrors to stop :'(

Given the ones I reworked fully were more involved maybe those are higher
priority than the rest, as a litmus test?

>
> >
> > Actually the shadow stack one (10) is unrepro'd and super borderine and requires
> > a broken driver and etc. etc. so I'd say that one is less important.
>
> Ack.
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

