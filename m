Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81385C4453A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6256B008A; Wed, 22 Jul 2026 22:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BDC56B0092; Wed, 22 Jul 2026 22:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D61A6B0093; Wed, 22 Jul 2026 22:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0C976B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:26:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF5EBA0396
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:26:49 +0000 (UTC)
X-FDA: 85018453338.04.3E1B7E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DBD3B140005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:26:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWj6+AZP;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784773608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXsVlmF90dROvzP48MILnB+XTtMTqASu3QOaKuy0MMk=;
	b=1TedZaXERwbPfqaDimmzp9nYEIv4B0PztP5Z3gvms6AA9K1xRRvZenbEx4QzJGa0NlGx82
	jEM7B+QH6ryof6t3k4o7YdGAByGN4ChCxYzdiGgwiIRtdUeWqgHXvu26VvLEpaqXM19NQd
	iA8n6ZO4wAwNuDNuk79wdzpjWlBtTpI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWj6+AZP;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784773608;
	b=r6ZirvusNa0ORWtgA0FKL3g3yV7+DHb2LrgLAADXP55O/OA1hAimRc6C/d63lciDTZdIaI
	z9Bb58SkLy+VxPNtOwzdQf+A1monU/KcbLFj9YcGVjmJhuA4ntUZ39XBSZ9hsB2PAVUwNG
	5bAGS99jTlGwcJ89ZTik3TkkliTFmkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A634844FD7
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A70E1F00A3D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784773606;
	bh=XXsVlmF90dROvzP48MILnB+XTtMTqASu3QOaKuy0MMk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LWj6+AZPDsIg4QUDh9i1bGVcasj1B+e9CU6+I4gq5vkGa3CWG2lHuPWvtBfb/WGGk
	 PIlKIw9Vwc40oCsFopbvoCjX4qWnl2aODgBSmh05hXlqcMR5XztGmEB0YPBjA0aSny
	 GXZgRo65tUBK6q4+gapJI3ZVW9wnKoY9Os6ZsF6M+l0sesNvNM1pkj3uQ09fyffU3l
	 URWF54aR6B6CF8z99tQ+htv9nqpG6T8BA4eILiUzDmmQt1Zb4QLiLUcF6o78mTU7Mo
	 FifWpf0h+hMu1QHzLlOugmG0QQng9dVNMtNs7R5pNgwK7ZpMoC+0ciRRH4H0yE2u3v
	 ofGJUC8YzchIQ==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e85499ffbso13033285a.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:26:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RogDhqJQ9+TQAggkUiYN1TjBknDoZysimymRue5Ev0CWDqsEoQ+yeGYfLxLYvlfYp4QK/cOzyE6eQ==@kvack.org
X-Gm-Message-State: AOJu0YxmDxfnuedE4lFTDmp8qehIw/FrvsLj5soqNX81uZQHv/PCdodJ
	MODT45amcNTu0IseJTZKV/DlSLi1EkgcE4ZhEk/XCVVLNoOzsmlHHlZWKsDxuttUAieVIjyj4Ji
	JY7+cFMCtjllAjSJntitj0ZyvBtpj3Bg=
X-Received: by 2002:a05:620a:46a6:b0:930:e2ea:2881 with SMTP id
 af79cd13be357-9310385710bmr132032985a.36.1784773604948; Wed, 22 Jul 2026
 19:26:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260718095251.82937-1-ridong.chen@linux.dev> <20260718095251.82937-2-ridong.chen@linux.dev>
 <CAGsJ_4yYEaoiTY0vFtqJK5fsXZW2PTkMu-qZ=X7=cqmMVa3YCg@mail.gmail.com>
 <bcace78f-987f-4908-9e65-bf0b9a52855c@linux.dev> <CAGsJ_4wbLAky6B9gPGmyLkZPaqrbC4eSMXXK1n4bLfnzs5+-sQ@mail.gmail.com>
 <52f41904-d6fb-46b9-9e89-296cda0a988b@linux.dev>
In-Reply-To: <52f41904-d6fb-46b9-9e89-296cda0a988b@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 23 Jul 2026 10:26:33 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wmWNcpTtcTASTNu0nDQEnZU+4ruD9qC2nqLA5Zgx98+w@mail.gmail.com>
X-Gm-Features: AUfX_mz4aLlCXhq7_XG_mrycNftD7hRrs5udgv0ohdNmpm-lNWcnBZf0HxOErpU
Message-ID: <CAGsJ_4wmWNcpTtcTASTNu0nDQEnZU+4ruD9qC2nqLA5Zgx98+w@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Ridong Chen <ridong.chen@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hezhongkun.hzk@bytedance.com, muchun.song@linux.dev, 
	dave@stgolabs.net, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DBD3B140005
X-Rspam-User: 
X-Stat-Signature: mbuymtms4yf8bh75cmbs8yxex4q7wgxi
X-Rspamd-Server: rspam04
X-HE-Tag: 1784773607-227399
X-HE-Meta: U2FsdGVkX18lC31qeS1JzvVwkZYMKYfyiuQiRefFHpM3+Q48Ii3j59zWSL3BxCnNZYQFv67GVyGKQ5W71nHgSJ2zpLTqEMfomaDyp4zmSXuei+9hYYEYhQIbTUZP9Lu7BS20FNyrMSh5EotyK27jS6QMxPCOHSx3flZ4Q4s7Zzvx0KXdiD7zVo5J8D6H5BhwcYh1Ne3dh3jxjwotes+zQ3pBDX+emOWFmDCeOvKtrLXF/Ql3YeRKOVh957pWl7p71pNDts/23m9jXzDfB/g/VEBXTNVkrcFsIMJOAtnP1RmUm1k4n6qiz99qyWoCOCyExkSQAcLOcZdRjvD3Wh2BsL6AIUAyrQleUWcD8evbo2aP43+TnEUc7ynVEjEUV8Lpd17SbJIeQs5wraq3fgURTDFB+eLuGe7ypvI39IwS6aZBMdqCiJVFoLMXdyI13NN1S0cniHFiB4hF1czXA4JQQgXz86GNUBUZEIK8VFdbH1/yvjAJ7rX8xfXFAsAtoAB92+8ebQvwYmFZWCB8WD07dAZ1B2ynu9u4OLjbzED1KAcjFuJ9R+6Ofjzj6dzm+++I35yItyFF3KpIGZIBl0oqwgf3WIVKOGFVrXPxM/FpTWnLzoJkvDUAAmEwGJwf3GydI3RX9Wf2/tLTj/MgQWy0gM2ReuDIex3Mna05sL+GNJdF6UPaNU+EEIhnYOMdBLPDtBtnd3USg1Ma3o9RaozZvte11Mb6rr+gpHzC3ZCd2pKbjZb8szN/YCgZT3NHEOFWdqa8Dek50IJdv0uIGZ3K2PWMASJPIhSczhGVVC0NF/cCX6juICKQMuBfmMC0Sfexy8+YJOLh8/jtozTbBFrqoawZA1vYOqeU0dV8OChzPDEDLRgSg01BYHMJQ2ZQUi+j3yii0sGoDLX0SabHJI/jC0rGS51bOtBfkFh3RT1LrbjaPc3R4eGQYqvfBwMZCiySyDFQ+izgjhKFKAhh7+t
 oMVXtJoX
 AzjQz3VTOjsCtHcVIQGW1OX3dH4shGadObDZcjYibo3+X68WmhO4tIt6ekXuY8JqwxaextPF/8gVpEFZgPj0mho+glM+sgcIrLWpBHtewAIcRh54KHrAZ1ZGftXj9K2EkYj3Sd9k/K+o8dV/3EIjZ4YwGy5rwdJ8n6vquXD+OVMqul8YMFhkaQwtPwpXsljXEj9yejUDMJ1PVcCUFUcMQji+0renhKwGaafjIqvz3UzI/xzomjCUdEcEyHldugAffydKlszyhIPVdiv92S8HDJnIBd2HuLJ2+QOGB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 10:00=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
>
>
> On 7/21/2026 3:45 PM, Barry Song wrote:
> > On Mon, Jul 20, 2026 at 12:43=E2=80=AFPM Ridong Chen <ridong.chen@linux=
.dev> wrote:
> > [...]
> >
> >>>> --- a/mm/vmscan.c
> >>>> +++ b/mm/vmscan.c
> >>>> @@ -2501,6 +2501,17 @@ static void get_scan_count(struct lruvec *lru=
vec, struct scan_control *sc,
> >>>>           enum scan_balance scan_balance;
> >>>>           enum lru_list lru;
> >>>>
> >>>> +       /* Proactive reclaim initiated by userspace for anonymous me=
mory only */
> >>>> +       if (swappiness =3D=3D SWAPPINESS_ANON_ONLY) {
> >>>> +               WARN_ON_ONCE(!sc->proactive);
> >>>
> >>> I feel it's a bit odd that the WARN_ON_ONCE() is placed here. Maybe
> >>> adding a short comment would make the intent clearer. For example:
> >>> "SWAPPINESS_ANON_ONLY is only allowed for proactive reclaim."
> >>
> >> Hi Barry,
> >>
> >> I didn't change the original logic in this patch. I agree that adding =
a
> >> comment would help clarify the intent.
> >>
> >> I'll include that in the next version.
> >>
> >>> I'm not sure whether it would be better to issue this warning earlier=
,
> >>> for example in try_to_free_mem_cgroup_pages(). That said, I don't
> >>> feel strongly about this.
> >>
> >> Since patch 4 will address the MGLRU issue and could also include this
> >> warning, I think that triggering the warning earlier makes sense and
> >> would be more general. Would it be acceptable to add a separate patch
> >> (e.g., patch 5) for moving the warning? That way, each patch stays
> >> focused on a single logical change.
> >
> > I'm not quite sure where the best place would be to move it earlier. We
> > already have two places that perform proactive reclaim:
> > try_to_free_mem_cgroup_pages() and __node_reclaim(). There are also
> > other reclaim paths that are not proactive. Since they all eventually c=
all
> > shrink_node(), would it make more sense to handle it there?
> >
> > If we can't find a suitable common path, I guess simply adding some com=
ments
> > to the current patches would be good enough.
> >
> Eh, shrink_node handles MGLRU global reclaim via a special branch, so we'=
d have
> to add the warning at the beginning of shrink_node, but that feels a bit
> jarring. Let's just go with adding some comments instead.

Yep. I also failed to find the best place to add the WARN_ON earlier in
a common path shared by both MGLRU and the active/inactive LRU. Maybe
just adding some more comments would help clarify the intent :-)

Best Regards
Barry

