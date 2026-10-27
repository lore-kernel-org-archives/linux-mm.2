Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92BB0606B589
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c/6Wo8In
Received: by kanga.kvack.org (Postfix)
	id 78EF36B06BD; Tue, 27 Oct 2026 07:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F606B06BF; Tue, 27 Oct 2026 07:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62EDC6B06C0; Tue, 27 Oct 2026 07:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5D96B06BD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:33:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B160FA0A11
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:33:25 +0000 (UTC)
X-FDA: 85368195570.08.3874F2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id BBFF840007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:33:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/6Wo8In";
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793100803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJ4KhwrLt3mSjQzIDeyl2KzSTIVdhJovj7+98ElkoQw=;
	b=BH8Ic4osM0j0w89jf4fJVSyPPxN5ccahswO5g4deHuQJoahGmYHIETlKI8BChJH49sU+n3
	F3oRJcyouhuWHgrD6oJCyIVTzWIh4mkJ4Cpn0XuofZxP4eBHGO+EUrU1VZHFakLqHsjVf6
	DaU5+XDB4Uo2kq6fPfhZtoy+2fTCFl8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/6Wo8In";
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793100803;
	b=MIuebaZB8JxHP0OSYaGWfV708IdTNVjmELx3nXnsoOQJZKq8LUK9wfAy89jJLyY4l2+Qtb
	5DX2FyXWYR+9n7O97JOhPQZKq78CsuqgaN+yshPp5xwNcv1Ydqwg0BTDkeR8hAt/GmYfxy
	9ULTMaLjHfuGkPMDLIIEczp/e8bAmdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35C5960A58
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09951F013C4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793100801;
	bh=YJ4KhwrLt3mSjQzIDeyl2KzSTIVdhJovj7+98ElkoQw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=c/6Wo8In+boLLDqakrzUyFmlACTCliA3iOZiTLnxHU4QwL5dnqhQhynNDY6DYzgu8
	 U+FhNhk497xOqOa5k8g2NmnzpoWtbKuI2T68/ccOUMf68+cFm1Sjo52QOjTfNK3C0M
	 4Okz7ybXwovG3T/qC3YfNflP8GShDh/JDqRO8QaNRBrD7buOHfhUU9XhVF6FlPE2Tu
	 FoLeW1UvaBoZ4pg6aX+Dr9pVBzSul9sSWV6bicdLb4ZVsaAF0bBxUAoQ2s7GiFEGL6
	 0OKDgpl06/U8IsOidKkyXsUorbhdHTIjdHXcZJhcIuXUGUSrSXDgQRwpBqASPxcrTk
	 8WwOI8qupiS1w==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f3c616c84so330372585a.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:33:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw99ClcaWaUxRlxy0irSIVY+MHKWztlP7w4eONrB1YIkQJ4khspnLu6nL1vOJMqOz0C2nNMWR7q7Q==@kvack.org
X-Gm-Message-State: AFq9FYL0lJgP1aCR7Iww3tdZoi4ImGCL0c/5kmk/N2HzCPpKK3WKL0jM
	KAy3vtcuEeNap9QjEp61R2pENHTqVIKGAm2WjAsXrW3Ah90ccP9BVf3z1k4MN/hMnCrDPLS7am9
	d7klyt4DRzFxDLu2zzz05w2bB2gHxXq4=
X-Received: by 2002:a05:620a:4543:b0:93e:c12c:9dd3 with SMTP id
 af79cd13be357-940ef9efaecmr1359298785a.83.1793100801302; Tue, 27 Oct 2026
 04:33:21 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026084035.535989-1-hui.zhu@linux.dev> <CAGsJ_4z46o6fs16T0ctLcTXiinL1+0CXpvueDN1rVc2-rLT6NQ@mail.gmail.com>
 <c42ec8e1-6be4-4faa-8175-174fd2f11218@linux.dev>
In-Reply-To: <c42ec8e1-6be4-4faa-8175-174fd2f11218@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 27 Oct 2026 19:33:08 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xsc6CZL3YLBQcXCOxL=xwTdZpWsRiSrZFwuHzti1RC7A@mail.gmail.com>
X-Gm-Features: AclHuK-61WBlBg98b5PE6LnRMMAHlWD0i0f-CRpjM6_4wkBHIJZA5jcGM8k9Gts
Message-ID: <CAGsJ_4xsc6CZL3YLBQcXCOxL=xwTdZpWsRiSrZFwuHzti1RC7A@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Yu Zhao <yuzhao@google.com>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BBFF840007
X-Stat-Signature: 9w8xgqtzajtiky4s5ou155u3ahosy4cu
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793100803-141421
X-HE-Meta: U2FsdGVkX1/0qcyKeUiZz6asnotRU4wbD56M3Jvd/EFhtA4+Ab2sB/K5x21fISNEl7hVQpoKXU4iSJpyjntoXDYxNHJr4NSJeQ+bZgX/wamZZ73anNbeE94KL+5mwj44+0LtbO/4TUeET//I/OcB0wsV0j9JBNL0hiRY3QtFf4X69bUeLFYQqU92IIYRpTwU7ALI1CwUxSodD+ilDLpuxJFtxwkc15n6qZLzhUtMq1C2/HrvmwjCKEkEZoS5Gp1FCcBbn/O2DxJUIk6CG8LOScam0JQZvKrQuPfUq88E8t7rN9tPRuIAlFW7EBn+ldPX9SN2EC5syEjJlIlRd/fPHSzPuTHUHfDrlhXksA4thY4xz5EYAVXJXVkoTRzSxIS7gTmlHc14r71uFh+MnqD0GFv3t6z8w2iPZs40EC8tuunMep8nujkOUEOIlJPUu67Q5RXoz+5haTipBi/VMBsyQlZRoFIIULAuFufNLG+gkeac6i4ECCAsc2JIDEXqMl3xci5yeRQjk39DRVhKFHM5mmZEaWTpdsfZSaB7o/ybnLHUATaKimGOVSejm43EH7xjkAnvHVy0itTMcZhbmXW9O7lob9uRHV9t1mEfC56iMXoEkFbvEkGdVKIJV70IUyvGklLAR+7yH/pWDE/PjPnEoznh8+IixeGwMh2mTs0WJ5YgbEWR0hJPJCQFz6ULig//2jIMJmrV0I3Bdq0q9qMuRyQAS+t5H7HZRhMXRNILQfubcRjLFYKXlo29Gak6ktphtjEjcIr0vQVqhk9mr/UHNNNwazsXGA3s8EyboQJeG4YRKARFP7KLyrviJOUd/aAt7N1Umn/MAXysUrU4o5Bu1xhhNiR2H6MVA8HowoS95XJ1Iv0JXqLsK2MTvDZ7kDjUSSwMu3+cbPmdLlLQeBdnGedUyPKxAfR8IIfGPqryNSGAuBZuFgjLhUT8hEhqsZTAL8UK/lQHshORyNxsy8N
 v/+bU6U5
 m6kGUuAIX+2uaB+csEyAD94UODHHR0pkkI79oXgWy/BcmlkJ/9ay/ymvjAN8O8ba6O7NSAGvWQKpJCASHHw88NJkSUnZgniuVTO88Qh+VTGqHqprY2azI1ulRKxSDH+ukc8qN/8nOUYL5JTociEMlAgDt6UWvKEqUuqadopcZtLKZ6jEmahwhUDiP+NFvtDThhrphtdLCzaih893eonrIdzWs3TqmW+tbe7QGXjKkTnDDTpY+RVItOlsQEkGbsKAnhyYrhIlCf5Okau61k0ydUQdJygV36e7AB7LLCvYxxkS2oCb2wXSWyN4vuPqdA7pUWaIza1O2Ud09b7Lkqj0NrbXu7o2dWNLEz7cX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 3:25=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
[...]
> >> +       lru_gen_clear_refs(folio);
> > The only thing I'm not sure about is whether we need
> > if (lru_gen_enabled()) here to keep the semantics consistent
> > with other places where we use it.
> >
> > ...
> >     2    676  mm/folio.c <<deactivate_file_folio>>
> >               if (lru_gen_enabled() && lru_gen_clear_refs(folio))
> >     3    695  mm/folio.c <<folio_deactivate>>
> >               if (lru_gen_enabled() ? lru_gen_clear_refs(folio) :
> > !folio_test_active(folio))
> >
> > So maybe we still need
> >
> > + if (lru_gen_enabled())
> >          lru_gen_clear_refs(folio);
>
> I think we maybe don't need it here.  The other two sites consume the
> return value, and that is what the check disambiguates:
>

You=E2=80=99re right. Thanks for the thorough investigation.

Reviewed-by: Barry Song <baohua@kernel.org>

