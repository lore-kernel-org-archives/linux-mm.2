Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B00C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA256B008A; Mon, 13 Jul 2026 21:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869EE6B008C; Mon, 13 Jul 2026 21:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7814B6B0092; Mon, 13 Jul 2026 21:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 514836B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:43:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8A9A12020B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:43:22 +0000 (UTC)
X-FDA: 84985684644.19.AFA5212
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id F168018000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:43:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SpkxnFaW;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNMroDnaFepYZc/4huUd7Zc+6s2smxbRPSRvFEcecJg=;
	b=LRaWYE1kYKsomG5nW7FHQNRFgphchCT14/LbSLFujwJFgqZtDBBjASnEqKelMtkjZpdeas
	Na0Fgpa870kn2wMLeV/uGk+NCNbxprtqpiDkhFXcBq1Q/BMk0NBnrKaQlvt/o+xR2mVIEO
	9QHC3mx+PCulRzqD6OaLCxbk4rKRhcY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SpkxnFaW;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993401;
	b=P6esT8OnQlo75IU5LYtYC+QnE7Znz6vs3lbTELioEtQBZkvrKiU0LjJ43UmVpdeSsOc4z3
	7xOMIMHVuwdvOPb5SUyhGkfFKhfMjI22lpCyZkw3UadWwhnc+JAbkdcxrcSmMsU83BPtsi
	dBKpx82N2n+OGRJ+ttrpwhMZcCo/iPQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6ACA860120
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3E01F000E9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783993400;
	bh=ZNMroDnaFepYZc/4huUd7Zc+6s2smxbRPSRvFEcecJg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SpkxnFaWHOTlnomiAK5xhXSnZQ7KgvpHNeMNEbrRTVh/9P+b2IcN0g/0wbTIo3uiE
	 V3B19G27nYJawbYLWHSTZtS6yocGcVRgLWfXDAr5mJU59zV+Rdi5O9jjFmSSfen1g+
	 UHwggVK/mIKkQuCJ/V8Ftn8M2yxngNXv2vPI+Rbdykoof9qCtUTXFnK9sxTF2ejHjF
	 40xwUodA3Vl2flw0AZTiEfkZCYv8sjTQzOcXG8Lz3ldFQ9K/wh7aGMT/aeTIjdvQhX
	 IFy2ZYWgLwVMBFnc5mQV+y6ECr7CslOiIMjfT0jsQF8A3/Z+h+DSnqDXzmFMp/NKBK
	 6QBGGBemgdRxA==
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c15bf5000so22485751cf.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:43:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RraoHz8EqR5rQAxVGXXtMBhVM5b4EoutEKd9Z5l/BR6Dj7JvyBQjEsp9SWyL52lmZQBXogx5L5weQ==@kvack.org
X-Gm-Message-State: AOJu0YxBpfmXOcfao4rKQ4V46jSeku2SKYaLEF2quvADcF/OSxSEu4p5
	MqCaSzMfjTvLfXUiN4RC3kOS0kU1nMNsl5+onryAUm4Lga2+YVxtlQTT9FFVtZY9k+izYtSbBol
	XXJPV6ZKXW28PazOne9OFd3IOrvG2TrY=
X-Received: by 2002:a05:622a:5513:b0:516:ea30:8756 with SMTP id
 d75a77b69052e-51cbf1426d9mr108072891cf.36.1783993399516; Mon, 13 Jul 2026
 18:43:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-2-ridong.chen@linux.dev> <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
 <87dc4105-b98b-4541-bafe-c0adfbf58836@linux.dev>
In-Reply-To: <87dc4105-b98b-4541-bafe-c0adfbf58836@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 14 Jul 2026 09:43:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wDMrdvGksTJ1SMGE=aHY3CMY529ceKDD68cXLsHQCjtQ@mail.gmail.com>
X-Gm-Features: AVVi8Ccz7OC-clOMQQnSoiYTuyEXEArtL6roBTyfk92e5g9qCCo-JodquNZChkw
Message-ID: <CAGsJ_4wDMrdvGksTJ1SMGE=aHY3CMY529ceKDD68cXLsHQCjtQ@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F168018000A
X-Stat-Signature: 1eoa3ygscxajo1c7ofp1od7oxcqdpc4t
X-HE-Tag: 1783993400-37027
X-HE-Meta: U2FsdGVkX1/3k0eT+3H+uOZ/VsVWHD3MLz/LkUfY6qaANm020FGujeKtJbUNLV+9AuL1QoqfPI2URMtyc0w8c+QLuyuPxBlmyzrgJK5ZPaqtyXanr6GUKkUbRzwTUhbCpJ7dUV581loEeTj1yVIK4TwN8VjosPO+3r0szC0RPm0xUZXA5qu/3DVUCAHisvcrA2GgoJzP3/7apwsl1RKmd2VPeR3YKrq4IuOnQDchWvza1fofeyGWJqejGl/9vk0Up+QPPReytjc5/0HPQbmUIhijT93f9KLZcOtN47tlDiHhYvyXQ7F8/BsUX4nN3JGXDOun21+F6d02slXb6qzshtgfctfqOyugN7PcWKNZ5JF7LOFen1wR7/sOQSuyKriSSXKPBreZ7CeAw0RhaytD9pHAO6DQTptmQpOvg49DY54+9CKyRVuvAzu5ewwUPIUDs3XesI8NL9aTsDoaoPbjkssn5dorVK93j4RGiSWLupsOIq3oo4TM5vAPIoYuWV0ckOohebKiyNJY9bVgYW1WXpZV7rRLuzxENs82t3tZMcS2xDn+DOhqlBP5F/LVAscEV4Y58fMXHNCCkwV9stOQfI2Ol25f0F3G/7iH7ePO9J3gNMtWuzfPCXfebOiJJxIdub53tS5k9rqNfNRm1VhAVN6jwnhJBTX1wuqo3oMr57ooe85KLFDCfluVC3q8dOtTC0/ZxKf3VDTdxnrZTKZAyI+yoGeLSwlx+WmFo+MxZKUKRXdgrGxgE1UzJZITNiG1Kvv3V4L+hHVTy0D405ETTMFsnPfiRitCmSIU7cB0VsuZS3pNFVRDyXvETItWH7X6xZS7AgqcUvw5xf1EXGuwUAiuaBCSOLFFqOv/pHicE7L0ac4nkPNsB79EFwIuY/JaIJ/fwLXWcnaQz9y1r+GCD9FUtitbUauqexiG+UZ7VIsvs/AoxIS79RbrNlCXf8QH1dE6hD/C0ZQ5nGYwHar
 gFvWU6x/
 2DwtIX53XXkBjgC2bVSLocQHjm+rIJ4wuJmvHF1kPvyeYVr4PXpn/YpT2ysfdUIxV31/gVDrQb5yI5uyvqhOl/PKbTBF40CS868j8UJRzUMJdCE7uYr/wh22R71HfCY9tG86MqM6qbRbtBmWwTooYSh4to3+94XZDb1a1DdtcCStG4VnnfVHLdOos4T6Dzm/qKP9Cg47zDNHTgHMKOsdQHRJnySj8OJD+r3jbhJDBcDKhhzcuzBmEdD0rW2rOQHl9IIHzKYYGTraNJS65uCumNWsSrwDt2SkKAXqbXOixSvp5qU12bRbX9nkHF2Mguu+OrTbTUxcEZk+4UIQLkwf6rYigRHBBnQEZAuLgi2MhdyT1PzXf9ugFOko3Bm6+4Iv/IOzzGEQWdXnLJMc2iTgL4LkpCPQe5ViQFPnU5QQHkrP1hDM0FMh7ttXpWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 9:20=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
>
>
> On 7/13/2026 11:08 PM, Barry Song wrote:
> > On Sat, Jul 11, 2026 at 5:12=E2=80=AFPM Ridong Chen <ridong.chen@linux.=
dev> wrote:
> >>
> >> From: Ridong Chen <chenridong@xiaomi.com>
> >>
> >> The per-memcg swappiness knob is v1-only; v2 always uses global
> >> vm_swappiness and ignores the per-cgroup field.
> >>
> >> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
> >> to memcontrol.h where it belongs.
> >>
> >> No functional change for v1; v2-only kernels drop the unused field.
> >>
> >> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> >> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> >
> > Reviewed-by: Barry Song <baohua@kernel.org>
> >
> > With some nits.
> >
> >> ---
> > [...]
> >>          struct mem_cgroup_per_node *nodeinfo[];
> >> @@ -365,6 +366,9 @@ enum objext_flags {
> >>
> >>   #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
> >>
> >> +/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
> >> +extern int vm_swappiness;
> >
> > This is a bit unusual. I'm not sure whether mm/swap.h would be
> > a more appropriate place for this.
> >
> Thank you for your reply.
>
> The vm_swappiness variable is not utilized within mm/swap.c.
> Furthermore, since memcontrol.h does not include swap.h, retaining the
> extern int vm_swappiness declaration in mm/swap.h will result in a
> compilation failure.

If this is the case, it still seems better to keep
extern int vm_swappiness in include/linux/swap.h.

Then we don't need the comment:
/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */

It also makes it clearer that vm_swappiness is an extern variable
belonging to the swap module, rather than the memcontrol module.

Thanks
Barry

