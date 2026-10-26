Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B20C606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c8Ahxz+L
Received: by kanga.kvack.org (Postfix)
	id 406066B05B0; Mon, 26 Oct 2026 16:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDB26B05B1; Mon, 26 Oct 2026 16:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BB26B05B8; Mon, 26 Oct 2026 16:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 125B26B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:58:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 914A81A082A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:58:18 +0000 (UTC)
X-FDA: 85365990276.26.551EB71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C5E50180002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:58:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8Ahxz+L;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793048296;
	b=xmjpB3N/aYrpJ21CvvdSEIglVQ/j+EOCN3UtTq6wC+V488azIhvNeiK5e4Yq00sGUXklJY
	oWYLfSjhKN1IBBI3YVjY2jZlehD4IU/9DSnPX9+vcWSkD5QfZm8xwFJNOFTmeQ6YQo25x8
	bZrUpceHCqf13fWHBzAXjCpf5tdztVw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8Ahxz+L;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793048296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=icmUq+qL2c/gwZjRUiz00O2bxdKoJyT2ITQRS8SDc+k=;
	b=Nl80N8Yj28whRciTspS6MSy4B48bRRJjDXyuHbWkfBCZYGHaJFwyQ/CvAt2y7KO2uoV+pu
	BbvNPWt39Cws00zK4Wt8gEw4o4Gdm2rCAdzgyvxw+BMw1BsZ6dsPBQh41mXMZcijWJt4hq
	BPfdYZk3qewbqxPDXRYXSBxc7Ua472o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 864DE601EF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC7D1F031E1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793048295;
	bh=icmUq+qL2c/gwZjRUiz00O2bxdKoJyT2ITQRS8SDc+k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=c8Ahxz+LtK0cK80zV6kg8UGyAghjfA0p3hs9m5IKO7imlTjuRbPZ+YWwVA8GXrV1J
	 vHHpMylEfor90qdVsHO1EWbJ711CTvV5FnEqmxY+jAh+oj16Uu3g4JU/ULctNeQBT8
	 M81B/4dEEle7aqWzOV4XkJqegLUGDxysOYzRVj6ddtAUxeJP47tcufPOhTXsEIQMd/
	 d1prtaXbqKqDbuQtZpXPZTcbpNO9gMrTeWXNbCbOJvPcWLij3ylBetKULwzCWyWkbU
	 QQRvZ3kC+eMRggyFSpjcmFJPkmo+Wdko+nPmjJNTXclQgtZlIJtITyoXQMnL9OxBMW
	 GsnMkvZrRP4mA==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93e7ad9f78dso411894585a.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:58:15 -0700 (PDT)
X-Gm-Message-State: AFq9FYJ9l+5R6iTmAFzZ14f37k7a4O7FCmE2gvVWTrboSo2YCpdWGjkd
	NkYfmy6GbIrWu/GamC7tAVnWRk+o1pmGDof/TyhDOCD/OMFmaIMg5eBQskhyIUn9WnUDvffCLWH
	fht8bIIMOm8HnNYGmo2HDdQbutIkFHjY=
X-Received: by 2002:a05:620a:271d:b0:93f:e53:a55c with SMTP id
 af79cd13be357-940ef95200fmr1180262885a.78.1793048294632; Mon, 26 Oct 2026
 13:58:14 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev> <CAGsJ_4zUVpBJazRxc1CzN6u5XvpUaGnaf-_7JMz-rGK_ZTYMtw@mail.gmail.com>
 <e865f7f0-087c-4fe5-b729-6e6946cd20f6@linux.dev> <CAGsJ_4wp_jCtCeMx39nW0Z1Jm5pja7_V6XNwLB6p7zTan0c3VA@mail.gmail.com>
 <dee39669-b726-480e-8ca6-10f19512da68@linux.dev>
In-Reply-To: <dee39669-b726-480e-8ca6-10f19512da68@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 27 Oct 2026 04:58:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w4ozXM+=T0qGBAhC323F49Y4LxrrKKt3GFCs+en_TVCg@mail.gmail.com>
X-Gm-Features: AclHuK87m9cZBrXF70X-vghHkwSRiCol7Tl6VccIZSTsfEiuILsGNXgum-WwE1U
Message-ID: <CAGsJ_4w4ozXM+=T0qGBAhC323F49Y4LxrrKKt3GFCs+en_TVCg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
To: Nico Pache <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C5E50180002
X-Stat-Signature: 8p5mxmwkbgod13mg3tqquaspt9p31ujf
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793048296-859157
X-HE-Meta: U2FsdGVkX19VEn0zAE1GvyVr0sZ2J5/lbNW1I3EDBkMBkLCcIXbgOxlLpK5jArFqEmbr46CNvRstJqUtAaHVH7OuqWyQek/FxJVS3KcmxeyTUdfG1R4wV2YfpRiCqWqTs0tXuwNGQQ5+8rZ6cunZwntYMSMR8FQDaaJCRrc89EGo71EpBKK0kIubQRll7hRUQt98xO1nyLnC8jgVcza0G0XeaJHeonGCLbZj5V4tFt/MDjnJJAlrnJingbfrtsKFpMFiQQ6fVpuSSez5zKKQVOWTBFpEajCp3cw8mlwKUlAVF/cnpIC0WgHV7C5LfXI3davEZgk4krRjWlmhttuonE60Dt7myhCqsdJsdaO2eQHB/fR5/yfFtlKakgiRhXd0ymfvAf4OmjZALqJ8wmmvKnXybJcMOYzhSDIUBYq4pbloq0+iJIMxSJbdRewkDCUuJEFN6xK51pYcGKxHI4kVIB1ZinMQrai6+Kjk91SICMgQ5K3o+h6vs8iL7o5HOrvMbo1Imq4/iKJa3Oy2jb+8FmVkNQPFp6aNv+2niu2NbABIqBKOqC8i1+5ff9+hQpzkw8P57DM0auuPuKNIhO9KfSr0hNcuzYMDJLJz0O34rbKBkC/TJXeyNJvGsTxwM2rXmRWtdlzPPYaNP463AcsdLwxHOn457J43iQMs72PSFS9n5kMjfak8iuhXIX6ksCNAOI9M1HgwZq7aLH/OD+hmopwLzLw0ANvMW353x1OJyog211mf9sqNtYRv+PqjxAVw2sHt4WC1Hd6m2QDM7SI6ogPQcjio4OtMJC01VpITz3n/nTWqVIIY7G8NiqkLGyWpqP6dV7ptVPflDfp/giObBzYP4pXWp3vXWKnW88hooONAsHugzU2leoO+JMoTJe6/nZiZJsj/xljIfUVWjzqiczCGeJdcQ7vvjZH8Zdy2uv1xUxVof+ve9GZtOkSsVqaCO4JGPhKhEKfllpsRB2Y
 TVHrT19p
 Nh7Tx+PtNgTD9VgVQJXrkq+r7OTM965zVhiLy9MCreGyYM/kclCCaCzUwoiqnHPn2t50TKiRobvy9F2qU0rpU7A7MEucSq6zrlC7q2zKbbpIcy2KtgX1Uf9Mo3zCeNNUNvQE8pcOdRfFPsx1CzN3Myw/NcXMADddkZaYm0WUvMxDWQc0nAHj3dHt6yPG2viGDFHgluVSM5o0KhKWpG4HYa/vtm0UFrxmrskrimieVFC8uttF0BAzEK9crJUfqsOjpSujTE1XNbqTgo91sFFh+osFNOez7SwDJpAgUdTG7cv32rua5Ew4C1AQ0C/4ht04BhLJm2CHhbmLzdE8n7/feRZBIvKTZng4qLFqBGL/D3/DsN9VeUFOs3LLZJ5hsIlm+8k51uKgBXMw2EMuMK64i6PPz8VyTtw6/eu9WzmcYsEmgd7lFKW1iTj0BBLC7LpoM984oafc+UadnGy59tUjSsWMnsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 4:02=E2=80=AFAM Nico Pache <nico.pache@linux.dev> w=
rote:
>
>
>
> On 10/25/26 10:52 PM, Barry Song wrote:
> > On Mon, Oct 26, 2026 at 5:48=E2=80=AFAM Nico Pache <nico.pache@linux.de=
v> wrote:
> >>
> >>
> >>
> >> On 10/25/26 2:28 PM, Barry Song wrote:
> >>> On Mon, Oct 26, 2026 at 1:40=E2=80=AFAM Nico Pache (Red Hat)
> >>> <nico.pache@linux.dev> wrote:
> >>>>
> >>>> The zero-page remapping in __folio_split() was added to support the
> >>>> underused THP shrinker. When the shrinker is disabled via
> >>>> shrink_underused, gate TTU_USE_SHARED_ZEROPAGE on split_underused_th=
p
> >>>> to avoid scanning subpages for zero content unnecessarily.
> >>>>
> >>>> Suggested-by: David Hildenbrand <david@kernel.org>
> >>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage w=
hen splitting isolated thp")
> >>>> Signed-off-by: Nico Pache <nico.pache@linux.dev>
> >>>
> >>> is b1f202060afe a correct fixes tag? as
> >>> commit b1f202060afe has no even "split_underused_thp" there.
> >>
> >> I believe so. IIUC these two series were merged together. While
> >> 81d3ff3c6f7 introduces the toggle, b1f202060afe is where the behavior
> >> started.
> >>
> >> I guess you could argue that the Fixes should include both?
> >>
> >> Not entirely sure!
> >
> > Thanks for the clarification. I guess it's fine.
> >
> > BTW, with the code below, we no longer add fully mapped
> > folios to deferred_split_folio. So the scanning code only
> > handles partially mapped folios to set up zero-page mappings
> > for their subpages.
> >
> > I'm still not quite sure whether this is really harmful, though.
> > Am I missing something, or was there some discussion I missed?
>
> The issue is not in the actual shrinker code or the deferred split list.
>
> The issue is that any split leads to this zero-page remapping
> indiscriminate of the actual toggle. The same way this toggle is gating
> things going on the deferred split list, we should be gating the actual
> zero-page remapping too.

I'm not quite sure this is true. The toggle prevents fully mapped
folios from being added to the deferred split list, so their
subpages won't have a chance to be remapped to zero.

For the remaining folios that are not fully mapped, or those
that were added to deferred_split_list while the toggle was
on and remain there after it is switched off, allowing
remapping to zeropfn doesn't seem to violate the toggle's
intention of preventing fully mapped folios from being added
to deferred_split_list.

Anyway, I don't have a strong opinion on this.

Thanks!
Barry

