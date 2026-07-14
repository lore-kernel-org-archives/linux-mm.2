Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD9C4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C383F6B008A; Tue, 14 Jul 2026 06:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0F8D6B008C; Tue, 14 Jul 2026 06:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF406B0092; Tue, 14 Jul 2026 06:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87B5A6B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:22:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 178B9A02AF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:22:06 +0000 (UTC)
X-FDA: 84986991852.19.4C21005
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 21D4620002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:22:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4Rqp1Sn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784024524;
	b=Sx9EZxRf8RCWeg/Ii66ZN+Z7DyvECe7zvruilvixm4qzWDD5dl0or4eI1yNSak/mFAofUH
	a4oLu8JvW7S/hGJqO6BcuRscIidY6emkidwqS+lQAyiz9d3ya8s2viMhvqOsAQxmzdZ3QV
	pJ9eOUgylGigTgLOXfC+3p3zMM46Lew=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4Rqp1Sn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784024524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9MWqkbaVeSAs5QQWSSS7b7WvPqPkyKj21JCF4S69vs=;
	b=wJJB9ujh20C56QREvNX71y5OxCS03n5RoPjiIemsmTlJ02zwL7mvdZedzKKjbCns1yX3uo
	KjMXz+ylnh4kwa9vBMIbLpnYO0+SD2j4+HUYk2Kwlo2c5plpN+x9m91UbE+7eXckjXUWsO
	4DzSkIs+U/FlnXPBsi/oNAuTTNRAjpw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F7C9436A5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DF91F00ACA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784024522;
	bh=N9MWqkbaVeSAs5QQWSSS7b7WvPqPkyKj21JCF4S69vs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=l4Rqp1Sn6WdWoE4yLXk5VsGX8HcCgBXMmRWPd8Hc3mRvzrdBZQ1WE8IU1YiBFJpyH
	 B2e7iTWkk0/NF1WnAl2tMFiIN24nKSVgrfm/06kFm936EyxeKJ4OSB/2oZaY4b9eVf
	 Udied/4vKMyJmPRtXuwn/FU9J3nmlSlpqUWMx+XX198CMszfCrvYUAR5v/nKys+Vk5
	 vUP6I7RuKRPwOspnyDiJgvWGLv7Nw0E7/Nw91ykVjASxTSA8UHZaLMJZSYuoD+YmRJ
	 50mVDdC4q8DKDZf/0BdZCirdypixonSyUXbsrrVjHzpUL8e567u39CIooaI2yJy3Na
	 LPHuNjyqVaCbw==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92c7a0a701aso269934185a.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:22:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpRpwXVdarwoU3REktZ5fdA9waJBU5sBTDSw9s86jxFhDWfJieqqEjToiVYWR6XXUHlVjeUgE1SmQ==@kvack.org
X-Gm-Message-State: AOJu0YwWQd5WJno4DpMkL8JN0VO9HQB4YlKVnZ6XujHRGTnDDUgyjtmZ
	etpY5AuYKseKtKSh8Db7e88wNzFemRyMU4AMhSqjjugZNiOO4ngAz3+r/dqut99XQznRtOeXgfr
	goZMCk+uHxhxgYCcE+bwEIqlAGmmfn5E=
X-Received: by 2002:a05:620a:4543:b0:8cf:c106:faca with SMTP id
 af79cd13be357-93083c77332mr261027385a.36.1784024522021; Tue, 14 Jul 2026
 03:22:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-2-ridong.chen@linux.dev> <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
 <87dc4105-b98b-4541-bafe-c0adfbf58836@linux.dev> <CAGsJ_4wDMrdvGksTJ1SMGE=aHY3CMY529ceKDD68cXLsHQCjtQ@mail.gmail.com>
 <CAGsJ_4zcgURKZKBAc6i0Y5g7u2OXjENDE7A=nqYcQ9TTVuR=Hg@mail.gmail.com> <0545ee70-b0a0-4a93-ac2c-3e84ff504e5a@linux.dev>
In-Reply-To: <0545ee70-b0a0-4a93-ac2c-3e84ff504e5a@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 14 Jul 2026 18:21:50 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x7cg-L_OzCdyZy+8zoKptVi-Jh18k1HRkvTBTbn-EQRA@mail.gmail.com>
X-Gm-Features: AUfX_mw2KgsaUXheEE1KmhPftKrhTRh4Ox0BToKgjyllBsTmCYfrfr5f-D4f_Ig
Message-ID: <CAGsJ_4x7cg-L_OzCdyZy+8zoKptVi-Jh18k1HRkvTBTbn-EQRA@mail.gmail.com>
Subject: Re: [PATCH 1/2] memcg: move mem_cgroup_swappiness to memcontrol.h
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 21D4620002
X-Rspam-User: 
X-Stat-Signature: ybjtnqamufcwpp377iyy9ms34oqrc9dd
X-Rspamd-Server: rspam03
X-HE-Tag: 1784024523-497985
X-HE-Meta: U2FsdGVkX19FDKGshyQpVeRErwrqE/SK4YnI+ndrsW036prP6j7nQ1qs6Bl9RHhL+NvkeGOzcDGeopiEjbhTJIT2osvHCAGC02ezFJ2e39GoAZBmGXWP7k15pN5w8XL8Kq9SsDJRxSI9702GRL93GCUdwu76FO6tIp0Mz8zpIU7jIEf3zVubQ+Zze3PHrGRSlTDq5D2DJNzVTjZhMAmiuJTJh72CLC9PdQMlcJpnnKrulNQbk9XPbSO+k4g8YdMWEVtBmfJmEeKc9zb5HbVI9qYXlka3+hmGqkl54ZO0O5TCeVV82Fq0UE0PQZ4Ae+jJZ9QfXvnHk54rnw6UBScpdaEEL4tgEnY9IBP1nNsLV7LTj+Mai1dSesSG3ZcIpseCwdew2s8Z21KhUbGwwOIFMaX5hpHw477CUDxqXqi2bo4x/ycpcfzW34jSavh4OeF9AQDr42yrqxrA/cYUr8yUxh6at1mn3LExvnhVjaTveVnw40+UyrunDkAfVGMb1KeLaibyNz1WxUuPzp3Sz9VgzJLNqpiDdTcsYGqLfqWFdP8BjgIvs+upuOzkImDH+YMMnIdvLTCrYpxhv3SIdYCD9ZtXIWMV/S121Q+vsh3FA1e1+6R3nPjMeMYFee69CdXEPMOxX7m1LL0nniwyLWjEn/sH010i7BzDQjk9rilgqwEimW3i9pbGCrARSnA9izSDEN0ni0nJ6LHE6N5//2dqN4evlRgLp40bPPXjg8Cq6zuzRPRaxZVoIIA8iDMhW35c+uoBvJqjYLqe3f5Vd4zkRBll8AaGXJFq/i0D8RRdvteotdYZJdKN2qeVthWBJ9UAUreiwhXDuSLGe5o1KhXcQoNWli/vjI+Mrfl5+3k4StJMADT+C1ecBrlEbxpB0Br0cNr8pYlLL1sa2LKBPLCOgkcJjsi2xSAYvfyGE4azIgU9OCJsrV31CCCoLGUY26MwGpeI6Qmn5zEObHJwQwu
 BRD/IjvT
 WBc4zPpx1eP61W/tv8Gr448ZBNl1giIe37WtDmU8B+Mx5vcV7vcPeTtDay3kL8ifWLH67ySY/dz5mokPKs1eeYZW6121vkyQRNz8xsBoduOswexrrwLnM5N4XWZWdcMxOaR8/aEBYxJYMlBdVlXu5W3utmaPD5p7gQ00RrvUGM6cMxRP5i3ofJsjVNQ9ZwUMuQGhaw25yqCX9YtPTvh3Wpti4H/u3hkGvuPpfBteBmPY8QYeoKNSuu31TBdWoxy9POJ1o8+K2zbXcwa/B5AocHDXD049rhLmSyprwhlpd72ssS4/8LvMu/awqljyCmt/J6unblJzXxl/trRLLgqRbmUB6EnDOMqx8wfXOk5ize/t2uKegUXT6MdrldkzzQC7iPc9GUxgfyqv83vADsM4h00EPRruhVSZ9dGR7odHsIDZ77+HAl0woZogtV7S0a7Q8ZByZmVQesJKQUdk9cIAbIhJ82g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 3:43=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
>
>
> On 7/14/2026 9:48 AM, Barry Song wrote:
> > On Tue, Jul 14, 2026 at 9:43=E2=80=AFAM Barry Song <baohua@kernel.org> =
wrote:
> >>
> >> On Tue, Jul 14, 2026 at 9:20=E2=80=AFAM Ridong Chen <ridong.chen@linux=
.dev> wrote:
> >>>
> >>>
> >>>
> >>> On 7/13/2026 11:08 PM, Barry Song wrote:
> >>>> On Sat, Jul 11, 2026 at 5:12=E2=80=AFPM Ridong Chen <ridong.chen@lin=
ux.dev> wrote:
> >>>>>
> >>>>> From: Ridong Chen <chenridong@xiaomi.com>
> >>>>>
> >>>>> The per-memcg swappiness knob is v1-only; v2 always uses global
> >>>>> vm_swappiness and ignores the per-cgroup field.
> >>>>>
> >>>>> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
> >>>>> to memcontrol.h where it belongs.
> >>>>>
> >>>>> No functional change for v1; v2-only kernels drop the unused field.
> >>>>>
> >>>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> >>>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> >>>>
> >>>> Reviewed-by: Barry Song <baohua@kernel.org>
> >>>>
> >>>> With some nits.
> >>>>
> >>>>> ---
> >>>> [...]
> >>>>>           struct mem_cgroup_per_node *nodeinfo[];
> >>>>> @@ -365,6 +366,9 @@ enum objext_flags {
> >>>>>
> >>>>>    #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
> >>>>>
> >>>>> +/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
> >>>>> +extern int vm_swappiness;
> >>>>
> >>>> This is a bit unusual. I'm not sure whether mm/swap.h would be
> >>>> a more appropriate place for this.
> >>>>
> >>> Thank you for your reply.
> >>>
> >>> The vm_swappiness variable is not utilized within mm/swap.c.
> >>> Furthermore, since memcontrol.h does not include swap.h, retaining th=
e
> >>> extern int vm_swappiness declaration in mm/swap.h will result in a
> >>> compilation failure.
> >>
> >> If this is the case, it still seems better to keep
> >> extern int vm_swappiness in include/linux/swap.h.
> >>
> >> Then we don't need the comment:
> >> /* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
> >>
> >> It also makes it clearer that vm_swappiness is an extern variable
> >> belonging to the swap module, rather than the memcontrol module.
> >
> > BTW, if mem_c_group_swappiness() and vm_swappiness are only used
> > within mm/, could all of these be moved to mm/swap.h and
> > mm/internal.h instead?
> >
> > We are making a big effort to move many unrelated things out of
> > include/linux/swap.h recently. Could you check?
> >
> > https://lore.kernel.org/linux-mm/20260708-ch-swap-series-plus-folio-lru=
-cleanup-v9-0-2bc72b4f8730@gmail.com/
>
> Good suggestion. Moving them to mm/internal.h makes sense. Will update
> in the next version.

Either mm/swap.h or mm/internal.h.
vm_swappiness probably belongs in mm/swap.h rather than
mm/internal.h, right?

BTW, I am not particularly eager about this cleanup;
it could be done later as a separate patch.

If you decide not to do the cleanup, I think it would be better to
leave "extern int vm_swappiness" in include/linux/swap.h rather than
declaring it in include/linux/memcontrol.h?

Best Regards
Barry

