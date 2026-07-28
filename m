Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C77AC54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 17:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C0276B007B; Tue, 28 Jul 2026 13:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499626B0093; Tue, 28 Jul 2026 13:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0076B0096; Tue, 28 Jul 2026 13:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 196446B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:27:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AEC9F160491
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:27:25 +0000 (UTC)
X-FDA: 85038866850.10.69F1407
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id A831A160009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:27:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a5OQ13vv;
	spf=pass (imf08.hostedemail.com: domain of linkl@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785259643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2E6APFuXL0QO5MYtiHWWH1dGFecBH/tJuYUj2zY9aQ=;
	b=6YJii3Ywg+AVIsiT1i42BjahkEdZZZZPdWCB7Rm6NYiI5yteD9jukEsgZhmywikhCa3t7p
	MS4ypOP47BvgORl2ExOjaITiE4PmNnMZR+oLsrji8JlHshhKkEbBt5tO8+5HuxCLkc09je
	QmpVimLxqBKSLPl9+KFborx+CMb4N2Q=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785259643;
	b=tGvbhvQBrzNzHz0qVica1dCX7osE2Sg2Lt8/+6SAXEFtA5qJCeppzb7ayl2o8zNUCvJxg7
	ieuKyTuEsvx64fGCkdxys9ucbHHinoDxLZuYkBH/ZL+YApi+Y2ED18A1Zpp9QNY5b/ZC5o
	UWsRrel2qt+41Vl+1SeaSavIAViRYQc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a5OQ13vv;
	spf=pass (imf08.hostedemail.com: domain of linkl@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c10ed63c0so12371cf.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:27:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785259643; cv=none;
        d=google.com; s=arc-20260327;
        b=SXvmPPQ57cC/4CJyWVAQ/yqWQEAkZTVQ2PqVgv+t2lSWcAx6dJDYIJfZUmz7QPtlZT
         HkwV4uGUpfLbY4FwXOd6rxt1kNoudf8epSFYTImattyBybpBAWQi18EHvIzey3tbNNWQ
         j15zxt2HTXukwuRAbMxtOFJ0yBvIOKxteTBC+o8YDcSAwZWiu8hefqad8vmaHfQeMUU6
         gF4vprkDfWXySzd5bTZHU4Ws3RIvH6g+5PW4JUukQEnvPMzo3rsDJe5GK9vVE17EMp7/
         FTKxW097b77K1dHRiRZX5x1bma16QPLmpftxvaLG0IU0o/5uWfAFYqyQc28TVW1VCwyD
         zyvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X2E6APFuXL0QO5MYtiHWWH1dGFecBH/tJuYUj2zY9aQ=;
        fh=QVyEuDV1NVrETal9WlLaObXH7Z53A6/OpC4ES0/gRGI=;
        b=eEBwGhtDHMGprJr3gCYE3qB1IfzdcI0/yeu6osRZK/IRdv8EfTVIP6Nw8KVZV6IXCj
         9KCCMCXxpNOHTPL5el/xqJ3q3sRMypT3Hvvy6pbewuN3W5+Gs31DAygwQFd8A7HY+smm
         ZKl06gZW4WtR8b8I4lqwlJYhBILfoYXYTik0+zjtrnE2L1zfbD+r1CbSEkiNJmQa0XTS
         x4RLmHR2pvQHeeZBjndYPQhFpQxQ2A81GR2UJHSXTTS+9glivS6IWTbvS7Vk3z0KlKI3
         mEgCqjthjaeM6TV5onvNpNi9fODas39Fu2goG8wC1tkI7NRn4WtaIbwWTnRKEbeYf/h7
         1uJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785259643; x=1785864443; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X2E6APFuXL0QO5MYtiHWWH1dGFecBH/tJuYUj2zY9aQ=;
        b=a5OQ13vvrAJ6kFHC+7sMml8lNP3i3eydj0eTSC4NWDpmD3bMsChKCVXo73go/klmdM
         Smt+UlZlRVvfYNl9fXeoVCUHr3I96KChnG1Ue1II/TtWs1yZUVdUOIhR6HDvEayMrKOU
         f73cBpGklCcSn55OXqUtwTQwN38mr1NS3AbpwwBCL4sTr7kzfffDjNjTqDKdBq0lDdgE
         3tH2FsFpcVr+TKSPCbq6MuprjewqLDrHWllukTSAqov4JwY4SFSYd64wEkULZLLO4fG2
         rLbssDfwBcii5dYtl2rf2xSgpye5BuVPbMmMzMIyCvAhS2vREjhFANdDXBJQiZa8NwBJ
         Jv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785259643; x=1785864443;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X2E6APFuXL0QO5MYtiHWWH1dGFecBH/tJuYUj2zY9aQ=;
        b=fgsajFxvn8c3yDHN2n6KHPIGTaqaP70zrLlRpVvSIs1MnWKiZ0ZJ1OVvHxbsTfTq0b
         h2hQoYqo4S5h3o5QijOdL+rXAcqzLh3eyehHBhPt9+8DlFDNDSXnhpis/HUYIM34pBRr
         M/WY0Er77aZ2NHczwH1cNzU17VIDcJ6tHOXNChmXpxGqqxSGEcOHeOgnAXtYj9FIkXNQ
         Q2XH22/hU2eSCa3c2qN0Clu3NhVn4YEPA9fNGAfDOkk60x6bBpdr3GhQsfuBthY/EpRV
         bPhCY7X85/OmvZkJ2c5x/XWoxhEUxdR6j+84BEi51kWV/lguUxudDub093hQFSCcQQ5X
         tkvw==
X-Forwarded-Encrypted: i=1; AHgh+RqGDoV1sE6F9IALiMo4055RBdMikUAfPaKCOdnRd2CJJTLjEoIEvz+nVXGpvDilirP4SR6tZLHpUw==@kvack.org
X-Gm-Message-State: AOJu0YwlWXnC9/E+7jzIZlkS9ks1d4BNe0ubQQI4U2id4E6WcR1Q8gyR
	RIfb/oxK1hfbKhvMxp8vtD9VBRxpafDrCTA18/3LFsYWj/KcdbXc7+3bxK6AuflGGWCay6OuT15
	FsGbsFfZBtG0DvniqU91FBP1KOnANCRu0c7AKKNXN
X-Gm-Gg: AR+sD11Y5XeFM8TBa4npbR58jVl2RPgO3mKjpyJJ4F/LNabOC6BieokQUHPVID/5oiU
	MI+CuD7mMQCf3ygFMniS+ma/Hjvw2t5Is2MIQiBMXAbRSPfGAwVZJg/4VZhe1NBVrCQikBRJnhw
	00X1OD7dtu4TaIYub7xw3TDSx/x/SGO6VOwXIjvO7Wqzs2UbEPuimfdHDonKFNNvRGM4J0HsSiL
	L8W3qKYFuGc+vbRnBR3eGAsneoFV0GGRMcnux0YjOSrYxXsEoGlZ1cyBag5dsaRyafDOl5Qdogp
	Sjeq4BYgZRR+So0i9EsHuSpXNFo=
X-Received: by 2002:a05:622a:1b91:b0:51c:ca9:3d15 with SMTP id
 d75a77b69052e-529a5eb936amr64182801cf.12.1785259641228; Tue, 28 Jul 2026
 10:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260727230545.262579-1-pratmal@google.com> <20260727181355.481ebbe3b56425a760583f39@linux-foundation.org>
In-Reply-To: <20260727181355.481ebbe3b56425a760583f39@linux-foundation.org>
From: Link Lin <linkl@google.com>
Date: Tue, 28 Jul 2026 10:27:09 -0700
X-Gm-Features: AUfX_my4-h-mRu6xt1IzheayW3fQeJD2Yt8OpFWkkfPN4RkyCQvO8_8aaLNkCj0
Message-ID: <CALUx4KTL5vnGdPt5L_j8qew=HG=Eo-6jokdA7cPOC648BWW-Cg@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms module parameter
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pratmal@google.com, vbabka@kernel.org, david@kernel.org, sj@kernel.org, 
	corbet@lwn.net, skhan@linuxfoundation.org, anshuman.khandual@arm.com, 
	gthelen@google.com, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, ljs@kernel.org, liam@infradead.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A831A160009
X-Stat-Signature: t7gc4n3dohmmpip9wfhktrupzyjuy3hi
X-Rspam-User: 
X-HE-Tag: 1785259643-369657
X-HE-Meta: U2FsdGVkX19HauF40PoVLMTDY6mo9QzQIvDixyRfIibJpvlqGP46FjWmrLRLkZlQin0FZIycHhRYx9xp7irQU0SvCUCOjHWrhPL3VY2OuORIcXMki+HotCVDTR0FNAikUeS30d6rRKglhctnFliWCAgHN0B76+AZC8cQkAo0oxWSLVWUdHOYT9YJVuHlx5MwkEnaq0u3tXdalNfHLLhFdygBWz88iEcC03HpOj0qUtdHwVqgph1EBq9txBNkiINYpKwD36S9AhsKaHCuClPmhIoUTefMbZF+qyR0438OQsQT5zMcvgzrWJmYzSti01jyFEnCgZftBkG9Fo0nMnQOrHi216421b6Kj3cw8gXyUzWeDcaxxCP8am8mpSTPgsEP6zHz5Q7wiLu5Yr1AZ7XXqX7syUTt7skD7FziXuLOPG6JseVKiSuKaQTb16+dwnSHv+HcgpR6qL1c+Ucu2FdQinEuERWf6bTGf/UcQAEmA5lYrvTvoe6e0Gceao1S/gQUZvHI5nnqOazYZPBCrgZ1G4HfbfpZo9PVNv0HTfUuPe4mkN5ucOgByObELCZHn6diPEKbrKrhSSYt5WJ7RJXzpbuxthqfjhZuZzBXzfoEmoSt/9oLjx/CmDoSbzqw9NgTU/Xq9xYJOKlSLDfoBoPkU+T9YPacdbli/2aOrQkp+0/mVqAHl1+7mPn819nvSECOiOkhORcQYPvfG0CheVN4Wxk0LcKY7KGrGCfc5tvKbwDC0MH6bZ7MtGGNjUyLzfCucG7cl3p28ZqFH+cz7A/1lPkm5g04OZPsc2Jfs+vrI3DHYPzvBbYEaDPBi3a4YAVvYM2lMJNVCnZtT7nZgkY/7HCaYHTPn9gyS6OKu1vEtV/iVTSojTbz0soD2TnwUe4MSL6OBXP8DUxKuXLwAv3/bFKmorc4Ro5ys8a2VD8wt8lp09v+vWynoFKBvsYVfNpJdHZvdkAq98OjgyG2ZgW
 4iZ/bD7w
 OYBBFLJlR3CT6sl3YjXU6PtzvD3Npyo12+LjSVhK3fPaCuMTSC1Sy90WFVBN7PS7b/0nBIcGZ2hrhe5fx58dWB/LepgVGVCG+iTJh/5JVhdARDG5/W3E4NPODoLE+RJFzMobjPDiIktoRTrCDjL/ZTKRfkMxMofgkP0ViNjttVF71QPvnkBXnMrzleNUHg25OL5xYz+LXrQ49JVNKW9Vjr+HhfKOle5Xaafz+FZd1XGJ8XDCTm/R0dN09q/JM94JIKSwbt/aJKkv77b4kBD41+DU+4f2akxWipgGx5EnqTJKhnbWLUwVrWptqHumvMnh7vrgzviIOCfkXDNXPb4eovsb1cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 6:13=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Document=
ation/admin-guide/kernel-parameters.txt
>
> lgtm.  It conflicts with Link Lin's "mm/page_reporting: use
> system_freezable_wq to fix UAF during suspend".  Easy resolution:

Thanks Andrew for handling the conflict resolution!

Sincerely,
Link Lin

