Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696B1C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F906B0116; Mon,  6 Jul 2026 05:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6CD6B0119; Mon,  6 Jul 2026 05:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8C26B011F; Mon,  6 Jul 2026 05:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 108176B0116
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:17:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 900EFA0329
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:17:35 +0000 (UTC)
X-FDA: 84957798870.03.47BF86B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A732510000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:17:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqJ9j9hs;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783329453;
	b=EVw3sFq5pHfa/W2y4vKdH1r0Pj1j60Cqsqsz96IKaafOBjibJi8KuM6Cq/Y3g6td+z+wQ7
	wM6xd2u0WiFSoKrT9ZLVJB1WoeO3SvD6DC/18eOM7ezxsnbSOG4dOwuUT0txB/X8Ygb3vu
	NMO6ZHBeNEmx5DSYCu2VqatppqKfUEI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqJ9j9hs;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783329453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvMq3MNtjXCJ1IvPUkIecLk9KXmk63v3FWkVp2zdkBY=;
	b=pVQKcAdnrsFbiHtXOJV7UPBkr5nhI+33KjKflN2R5b+u98Vc5830oRpfZPeNXHncdBjucD
	dkP2HLXb54M6BbNnCwKgSdNh/kQQJg3FFBzK5WwHCnhYQCZ+p65i4JWE0Jd6/rI2ZiEQkO
	6o2KtM79JCyhn5AotZBwbecffWXdIxA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5C60419A7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AA81F00ACA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783329452;
	bh=LvMq3MNtjXCJ1IvPUkIecLk9KXmk63v3FWkVp2zdkBY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OqJ9j9hs1UG/s0KHESFRE+rMV1dy3UbCzarXHvvNuUZjfo6pWV1XzzMV9xzLsX+aw
	 WXuW4iunjsDPDfwtwo1T6k9McPK4hgVTePfg1Gu5CDIy9uOkIE6WF08g0NF+8D0iM+
	 iF7J05TACn0UV8dmSTuz1/e+So3V2x4wnX33QluzBETPZD2lgFqi9jsi5BdEDFB5e+
	 V7Ggb3gMMIBj7irAtrx/AbPIzJQm+3TBXXjthSHN0RoMVrLge3k3wdEF2d2uhvkB7t
	 yNZpIesYQ9hvy4b7GuGscufaGnHzTk/WAUhJPEbD7n/mU/BnRO2WDbxM1Mw7vx2tqH
	 02uWrL/fCl8CQ==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e50a650a0so131641385a.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 02:17:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoPyg3UpTa+SZ0p+vU1Nri5lbsYn56DkKNIunA3blu/O2X2Iwp5Rqb68+ZxffEGJeJDJnGrT2Gw/Q==@kvack.org
X-Gm-Message-State: AOJu0Yyk13zGHroG6ArdBOPaoiGeLREYE3ipDC3rlZIQgm2EBWgT5Deo
	8ToOxVR7OD75ssNxrlX6UW9k/Z00/j4t2WpuKw+tzrMODi+hTCEOu7fqNLk/Nm6Kq0jfBzrCq8G
	vUKba6/+iF8/1j3fGpJbU/u8eDLFEsrA=
X-Received: by 2002:a05:620a:19a0:b0:915:8bf1:bb10 with SMTP id
 af79cd13be357-92e9a34480amr1332446685a.10.1783329452003; Mon, 06 Jul 2026
 02:17:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260701235955.36126-1-baohua@kernel.org> <20260701235955.36126-2-baohua@kernel.org>
 <a9829fdd-75b3-4035-935a-f3a74fdc29bc@kernel.org> <CAGsJ_4xwfCoy3utvtAqAstKGD9ScH-n55bTTKrLiHj=c2doZFg@mail.gmail.com>
 <aktxkCILD63YMtv_@MiWiFi-R3L-srv>
In-Reply-To: <aktxkCILD63YMtv_@MiWiFi-R3L-srv>
From: Barry Song <baohua@kernel.org>
Date: Mon, 6 Jul 2026 17:17:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wxzC6YjpGG=MNfss9Md3ZJqZ6SR0GtFcDpHMpMGHN0gQ@mail.gmail.com>
X-Gm-Features: AVVi8CeWbeZJ4lGs6_qeEu1Ttn-JOk_wY4xixeOfYoUs6MrET5HMDOiTeyukUHE
Message-ID: <CAGsJ_4wxzC6YjpGG=MNfss9Md3ZJqZ6SR0GtFcDpHMpMGHN0gQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
To: Baoquan He <baoquan.he@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, kasong@tencent.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, chrisl@kernel.org, 
	jp.kobryn@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A732510000D
X-Stat-Signature: c8frm8qgxiog9gqu7mgi6rgm9i8brae8
X-HE-Tag: 1783329453-546905
X-HE-Meta: U2FsdGVkX18FIoqd6hEmm1rKkvkrKSGJ6yscxTqC6kLusLLKQZP73r0gq58PSL8271AXbt0QfnCFc6HB8AI7RGnL3nwHCRjftiPEThRdnIwxcb7rQEc5yDlc4BwIFvuXbHFUW9tPVdzxzjrx3OmY2AKHFDWVMGfd62aRWqicwXkABiP05n7By9spRyJefnl75Vr32OeF9KrqYVH+FzJCWTeGyIy4RTsaav+Ak7SVmAgoOKaVggx593u0CtTIi+Jf8/8n1DhZp1BhAiLDwb7t5TJPXbOI4icaavnd0OquD986cWYikQoUAdT3vQbqwM+eeZiwq3LgoFzJuYz0DutgGhT7SsafhXY2EzU4uQZIDs7suqsB7RkktxBuVi6ytaB0xJQBwDSp4ZKiiz2yipOHVsYe4oiDew+nG3YiQm8b9/YbQbmJX2aAAfbHxLnvX9kZatjAsZXIaCsjEaRI7GRFrZsrIySDSG7qHY06mElnLqYxt8Pz8XBDHUnlhF7Tbv4UFZJmLbE+PUsKDpgWLAp3vGAaVQgXsqw5+koXli1La/Hao607NV+gyIGmb8m7Ps6bUs536Nz/ADDX7Wgd8y3p9p6qdJtu5c7S4PP15nyhSSNmL//zR9VF/BLlVGud62srJ3hiihLR0LEhpFdql4r2LwufDPZ8bfY3of4U8LKMzzITKm9FbU5l7pVaZgFH1oBjX17mPf0SugMGX7YUtsaY0i2ljcu5Wm5nlUUtyk6uClEI83wY9SopifgSR1FS7WNImoSR2CQR9YXwBgIhSX7RkKsYiwBRWkqblW/O2aUagZzbriZDX4FLBo0OvxZ6a3pzaBp5I0NdSQp5p8ePguBqPQxjOfIdpxHm5oDH/D2HihZxu6dJ28h9rUpZld8O7z5oPEoKtGKRhuRrJuUHg4ApGPDvH9v8xvlLJMihcg3pDhqc6jIlksTfZlQ3MHMgLUX92N2tCCkPZu5sldrl5XY
 nqG60VQa
 7CTEidtyYGdBfwheRWDeMFCCxWTHXrEt706PqjsHXQRJW9mSOY7Dvy8HsbAW4Gh7wrzel4bLvd1rvTNpGgbI+C57EcJdNM/kX/vkHwReQ+ejZEzOC4LEAH4U1TzXiL6f8YaABz+QMa3VB93l6nq6/aPTEUpTE8rcOFjT1gIMarPOy66qewXjA/QhDx0KKDOkzCestdrHJheiqE/nR3ktP9DRfcPFGi+TJ46ENiBY7dWf9n9ZHof670BBlA40+NQ0OHuryPN9hKvaGZh10Vpr5GvCjLQES3YBbd4QuJzXRirYcI02MHuHuennlxmDGlxmPuhv8EQfXlFCqMPz4t/ANo4fVOxQ+rUb+k77wCz+kWMw4f13DxYE8ADV9k+PEjl7MBjnO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 5:13=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> Hi Barry,
>
> On 07/06/26 at 04:18pm, Barry Song wrote:
> > On Thu, Jul 2, 2026 at 4:05=E2=80=AFPM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> > >
> > > On 7/2/26 01:59, Barry Song (Xiaomi) wrote:
> > > > There is a case where `folio_ref_count(folio) =3D=3D 3` and
> > > > `!folio_test_swapcache(folio)`. In that case, both
> > > > `folio_ref_count(folio) > 3` and
> > > > `folio_ref_count(folio) > 1 + folio_test_swapcache(folio)` evaluate
> > > > false, causing an unnecessary local LRU drain.
> > > >
> > > > During an Ubuntu boot, I observed over 5,000 redundant local LRU
> > > > drains. For a kernel build with a minimal configuration, I observed
> > > > more than 20,000 redundant drains.
> > > >
> > > > Fix this by checking against: `1 + in_swapcache + in_lrucache`
> > > > instead of hardcoding `folio_ref_count(folio) > 3`.
> > > >
> > > > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > > > Reviewed-by: Kairui Song <kasong@tencent.com>
> > > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > > ---
> > > The other folks should probably re-review this patch that changed qui=
te a bit :)
> > >
> > >
> > > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > Thanks!
> >
> > Hi Baoquan, Shakeel, and Kairui,
> >
> > Would you like to re-review the patches so I can re-collect your
> > tags? If not, are you okay with me removing your tags when I
> > send v4?
>
> Is there change you need to do in a new version? If yes, please remove
> my tags, I will review v4. Oterwise, I will check this v3. Thanks.

no change for v4. Please feel free to re-review v3.

>
> AFAIK, usually, if patch is updated in a new version, any reviewing tags
> from the old version should be dropped unless the change is minor or
> trivial.

Thanks for the clarification. make sense to me.

Best Regards
Barry

