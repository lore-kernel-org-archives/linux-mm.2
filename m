Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4FBAFE5215
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE526B0093; Fri, 24 Apr 2026 07:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56EB66B0095; Fri, 24 Apr 2026 07:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436516B0096; Fri, 24 Apr 2026 07:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCCC6B0093
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:59:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFADFA00AE
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:59:32 +0000 (UTC)
X-FDA: 84693304584.20.33C1B75
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 629F88000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:59:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pp+Vu8IM;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777031971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHQYPzAV990Uhew6eBIq9GNsVsyr4/52nVfMb6QSTqQ=;
	b=DuF/846tqlqurNIYA5S75+xBJ4Pw1B5fcckRKeHujqsdE3NhctENXMNYpQCHPkpBTbJHRs
	Q4TzGdacd9qL0PWvzwLConcc3yVAwH6SuEArpin0gvfCqTksIdHoWl6++97ZWal88hQ+Cu
	SgCTc8a7HkIw5ReddpB9bk+y5ZnoMio=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pp+Vu8IM;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777031971; a=rsa-sha256;
	cv=none;
	b=EkPk/+2eOD0x1lc503m+PuplXikePfXD4pYfVE0EpSnSlA1opB12RPL6kAxvExUd38R/EK
	7roaLl8VDMJewNpBNheyIsMNl8blV5bWXnD1gbfmEFSE2sDa7pQvyylOePfsZjICmYRlAW
	DsI+jEussaPTrAU64Ds4s4X/FJpyu8g=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777031967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IHQYPzAV990Uhew6eBIq9GNsVsyr4/52nVfMb6QSTqQ=;
	b=Pp+Vu8IMlRT1HXTy/rykslM1Plape2KDpGMSDX3NKXZ68euahDQGlPY8zAIrMbOEcYapEb
	ZGM7yA3d+S/yRj2l5FezOlNTDHGJWWQLHweIq05WAmXtCWycRusfEBhThWETI5BGIIT0th
	3cJOz5zV5HFizSDxO8DsXIHMwEIoprI=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v6 7/7] mm/memory_hotplug: Factor out altmap freeing
 checks
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260424032039.a43516455eb1ef7c7fd7867e@linux-foundation.org>
Date: Fri, 24 Apr 2026 19:58:32 +0800
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8C537157-7EE6-4542-A922-6D34C3A88F47@linux.dev>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
 <20260424025547.3806072-8-songmuchun@bytedance.com>
 <6dd8e62b-97e3-4261-92c7-ba3a02ae6397@kernel.org>
 <20260424032039.a43516455eb1ef7c7fd7867e@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wfjmh453s3fjkczkd9jc7xezerhbwkne
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 629F88000B
X-HE-Tag: 1777031969-515867
X-HE-Meta: U2FsdGVkX198royYY1qKfwXq2ILqa9ux6QwyGlEg5W0rhFIqaEnlez++snblD8Cd/L+zWZBrztCv2Qauzaxkk+bAKeonsQANjcu6WNFtQPBNphAwbzwtP/KwJirlS53IaC8JAhMjYvzAUvXVOXqGOwhIld7U4R/6AC9YuXgfS9aX40B8qEjXIAYMsr+sUQPUksqqZ3/0jgBUpi1GGIGl04BpUiaiMZiYYqSj9wwIh8ciG9laQnhzWhaq8siYzEieclCazPjcETSIJw6X1+O6OGBCEcJjB+jbbtLcSLIQQeCM094LrxetqewxRC7JaYLzBfta9JLgq1dHG5hGpuAVdJEuSKf1eLIuvo4SMECcvUKUX2cHGBVYUJk/lUbqOoJ31bydRqZB0FXEofbKcX/gU4AUrFsjgVvEK6MMKOOYGfNP7C3At4HkFyPsoBPrSYXdxo23PC1AF33U09GikElipi2B0dy5yCvM33b1gn8llgET8+mrwKZplZQnCJIQtJGYDiq4lMqOesiybTsQVMvkguaS8ykq5C5p+nBJBhP2NyGD2i2IVWqO59CgVq4d0zwlON6f91XbT3k9QajE9TyBfXPkqQZmKDn1D1ulPnzKqvYUQudYaEr2tDk09msuYbTfczCazeMoNmEaUuZoSFBjjBWLpIkqmvdkCVLmtE0wO5U3MObOORmlSrq0uw7OcMv2VlIDut7QDyMZmeRfrAuDJx6sfLuiO4+pzRUeI0C03U2muyamRRgaNJyMCN4+9uM15b42VWtWPrmfzuho4GV3y10g9aMc7Vi3k7+9xj7Ix5KnQTAwtyWfC1H0JrEE5WNfNeF017XNgM7I6m01ADdUkZvqbgrouipksPJtGbW/6usEwEtcTcKZfisX4U4mSABNmiq61IYkjsFZKcEMwTiJg85h8X+PDkJKZqedsLCZlvFG1Sa+b5yToJqlhB8+akRqIRqNOZh/sAR5SKmt4tY
 4/JvUBwc
 +ZkfiG8ndgff/bAKzSwkMGZU9L7UaGFi02kZwcNcv3XD+y2s+XF0EcWJsj7Zp0k6/chrOquoDj7CoUO+XksI+3fQ6DtMF+7kM+EArMQJ14eiHj43/EgTI1r/H57xKeyWPH1yUy6l5p9POeINSwqBxFZNkAo4zlXG3blJWdVNc7txxVNv8O+JzJ7YVB7I4BPn/u1fBetPEnVjd2rsIbK6aJ1z4xkb6XCmLY3/YFiSPd9oxuACMz1iY3ixcY4qCKPs3e+KCn3KlG5DWcWdk0Ab19mOsYWFi4eDAMGCHTtFiKJPWOowaiJaGt4Ca+YOu1Dzoh06cwawCHkaDOSEaLqNHsXowaeWpJ1iuNeup1huytOYHQWwd9vEuBk5lmB2N9IyxyUFs548NfrKbw9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 24, 2026, at 18:20, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Fri, 24 Apr 2026 09:34:43 +0200 "David Hildenbrand (Arm)" =
<david@kernel.org> wrote:
>=20
>> On 4/24/26 04:55, Muchun Song wrote:
>>> Use a small helper to centralize altmap freeing after verifying that =
all
>>> vmemmap pages were released. This keeps the check consistent between =
the
>>> normal teardown path and the memory hotplug error paths.
>>>=20
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---
>>=20
>> Thanks!
>>=20
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>=20
>> Andrew usually prefers sending non-fixes separately,
>=20
> Patches which are destined for the current -rc cycle (and possibly
> -stable) (aka "hotfixes") take a different route into mainline from
> regular next-merge-window material.  They go into different branches
> and they have different timing.
>=20
> If a patchset has a mixture of hotfixes (upstream next week) and
> regular patches (upstream mid June) then I have to pull the series
> apart, stage some things into one branch and other things in another
> branch, rework the cover letter etc etc.  Problems with this are:
>=20
> - what goes upstream doesn't map well onto what was presented on the
>  mailing list.
>=20
> - the hotfixes (upstream next week) may have dependencies on the
>  regular patches (upstream mid June).  This is backwards.
>=20
> Much depends on the urgency of the hotfixes.
>=20
> In this case, iirc, the determination is "not very urgent at all".  So
> the series is OK as-is - it's all "upstream mid June".
>=20
> This is still a bit suboptimal because when the -stable maintainers =
get
> onto backporting the cc:stable patches (after mid June), they may
> encounter merge/build/runtime issues due to the absence of the
> non-hotfix patches from this series.
>=20
> So generally, it is best for authors to have a think about these
> timing/priority issues and to present the patches in a suitable =
fashion
> - hotfixes/-stable patches in one series then non-hotfixes in a =
second,
> later series.  This way their presentation matches what goes upstream
> and we reduce the possibility of problems when the -stable maintainers
> get onto backporting.

Thanks for the clarification! Since I'm heading into the next revision
anyway, I=E2=80=99ll go ahead and split the series.

I'll drop the non-fix patches for now and focus this series on the
bugfixes to ensure a smooth merge. The regular patches will follow
in a separate submission later.

Thanks,
Muchun.



