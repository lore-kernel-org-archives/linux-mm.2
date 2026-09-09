Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D09CC79FBF
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0E136B0093; Wed,  9 Sep 2026 14:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBFCA6B0095; Wed,  9 Sep 2026 14:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4FA6B0096; Wed,  9 Sep 2026 14:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5D26B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:29:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDB9A1202CB
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:29:26 +0000 (UTC)
X-FDA: 85195061532.14.9CC63F6
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf21.hostedemail.com (Postfix) with ESMTP id D290B1C000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:29:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Z+/PU7pE";
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788978564;
	b=f2hOC/i5xqh0P6+fVidV0Xe1Iw/lkWtalRlDUQagn4f0F1aNBiOODyomg7tiNCFeBp4zDB
	5Vx/9uODsSTCGBJOIMwA0x9sC/N3cml88SqHNpmtygqSeCdEFyMEKT586RKfQABB6FGzea
	JIb7VQ5SE7DOSfBNvDqhwiJwTnUbL88=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Z+/PU7pE";
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788978564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O80U+VoanmQGpDG/i4GPzQW2Nc5FZMWWwqpPOFq4e5M=;
	b=r+6B5YVY+9lTByGqdjUKQO/jX57mCzFtDWef0tQLAri8e6QEsVR7x2V2rlqrFvBcs6r94e
	oas1k+swK6D/hW8RDpfCxAQg7ypiU9UZ38NG5XjY1Hpg//Gp+3qsN0JRXXg04XVHgRPNHA
	Rgwu5KDmpEOJ6fYN+vFfax3FBYaYd7U=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so341081cf.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 11:29:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788978564; cv=none;
        d=google.com; s=arc-20260327;
        b=Yq81FT7Vz6Q8/ICMAPuxrep+q/4BbJh6xK5C1aNa90OjiPCqTW+h78FHh9kHY/GXL8
         QoYmi7nQcQd48WRqhSXS1NkqN5gExlyaCJlDO2/A71cOwCrHdfeX/aLHtISHy/Y6V5Pr
         MF/OgZXpZZsaO2UbPqt8KrWtfSD5BbvOfIY50FwqgxyTRCSzOiqOb+Gw2sPT5HuMDPgR
         m/eHYdT7Ka9yJ6bRS8kFO8KSzFUzlEeLHrP8ZWuWuP57o6rZzWB78gd0wj8nPzFH+Fl3
         vj1Vmg2vPO04/BHo8fdC647ISlW9SGz2mC2d2EbDTP8LW2sRqythW+gptwIc+5i6gu88
         MucA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O80U+VoanmQGpDG/i4GPzQW2Nc5FZMWWwqpPOFq4e5M=;
        fh=dCNcG/yynyoHFE+28iKAkJDj0Fis28KDmniJhop9ReI=;
        b=mgxFl7+bVlC7HSO1XQEwFwY77YNK6g7lpnYcLR/yFAJDWbr4kR/Aot0fJNTItf8e32
         XzLNeVVIrACm61/N3Jp/OI981Ni97xd7jSqX+Fb3i5HpfTlwjZ+/30jMXGwIF/1377fA
         Uy0x4umTBLPyOB5qgPfiWZf+la/xSOEO+ea9hyNe/0VnvEQN/QQnpe5PUnTJOi5VyuvS
         y69WHQnZuao7GE4z47afWBeR7M1z1UsRoTuxZ9zuE8LxjU9CkKJBRixoYLgT+5esCpKO
         6Wy44fPPS1QhFQsng+gwu+KiwXOV/2KdcNQBZKgMDXxloKeJP4E4ZlE+jm8zQMEEtFVu
         GPMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788978564; x=1789583364; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O80U+VoanmQGpDG/i4GPzQW2Nc5FZMWWwqpPOFq4e5M=;
        b=Z+/PU7pE5dAsaVKNez+bB+ZyMBO5ucC/ggpQJw1LB9XUD0AikJmF1VbvdpQxyzY9ai
         GyKENnLBvYWIb2V/6MacSUSIXBlWbn9lpx1Tgq3vf1RVBJlM/2HOn1HiMGBwu/r8lPNk
         LCpBtVOb8vUV/yxTI1Tw4KR8JEzjkpNFZjC2Mu8axt/2pIXhJSRnU9wZk8M+/v4OauUD
         ArZccH2xQprOwr1wCboY3MfKqOwax0x2fzgx8uG+KLOItT6aoSEpQ/0S+LDQrRgF4srl
         KkFMqJ+l+19jL0LMOKh8yCKJFnb2G/AuXwr+/hqQuceNugsrVo6Yif6g0HpLhVgQI3gb
         hXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788978564; x=1789583364;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O80U+VoanmQGpDG/i4GPzQW2Nc5FZMWWwqpPOFq4e5M=;
        b=CXPWDxOEBH52vbn6RZWgu0wMqNAjqqXgL5j2b2uAist2+ukLC50iCC79+kwQlBbNN5
         DekjA3pfqV0Rkrrn7DnQNTl/Xv3hX/1qYVV44KjpwCx8Xf6bEVAqrO65fQ9+89rbKkmT
         HWC3tFTiMcwIjhSY9/GXCIkmBsYRidvwa3YbrN0ItmNWKSJseFgSZNPWJ9d8g6qgyPkA
         KnHnhZGwqKRackdcyqF85pqOYTOygRM5uL2G292uUJ8EucpFtuRrBjujpikWrKMsWW04
         1Msmd4FGyHnQsVPFkYy5QyA40PLk3D97JUAiVBlKr4lpLx0kqItCWgFEB2BJ5unkjRVX
         yyVg==
X-Forwarded-Encrypted: i=1; AKwUvBw+4wNou2bJBqmR8oiAhmDZpiLEjMNDzBSzX0CXHNMi2B6wGmcPu5hzr+FMqHmjz9Q6y8TB9rcMxA==@kvack.org
X-Gm-Message-State: AFuF++nVnjI8bh8J4OG2BhQTBoi9JImU8d1bRy3bJ2M4/843ZQIgARPf
	Oozf0xSeAPPQxZoDfH4pAzzft+jl9n9DzU5CqEZ6Bx9Yx1dG8DpQZTkEE67GJpr8wxdY21yLIGp
	3jwNNj+ZvDDSGjUz2hH8ffKaIaaBtCl8ih44cboq2xDBC+iPfjKvi78H4
X-Gm-Gg: AYBFou3QXJWYp2fhOM3rdJEQFN7vG+unH3DrkbQqYRfmVFr34xsqgLD5hDgjXO30giJ
	WXwQJxzoBlAKkyWZpOUHxu73i9mY3BXYWegwzuaGIbaZ9vhdNW0dwwVLrQFIeHJvLmKN2AkNdLW
	/3TbdiKT1Yt3uO1bFYoU4FA0GVqqoJdq3iYrEMI19hwjzTSRY9RfPnnnXwvlR/qb7fFUI6Hfviu
	JHwIUKT29ffbaLNKzJYPSmwq8y6y6iHbtehuDXoJMhrEanSQmjYYpbT559lif5xZUG/oepKmRkN
	TpPiLjnaJFknbbJuwdbOsibLDSkcwXX5idZPwaLZ3u4jql5u4ZJP9J3Beg==
X-Received: by 2002:a05:622a:250d:b0:52b:4ec6:52ba with SMTP id
 d75a77b69052e-530b48fd11fmr591111cf.6.1788978563357; Wed, 09 Sep 2026
 11:29:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-2-surenb@google.com>
 <1d5011f8-26a1-41e1-bb9d-8d72c08b8fe9@kernel.org> <CAJuCfpH25ML1+hdhTtZUoSjgrNcGv9HbQD8o5UErmAdW-7C8Bg@mail.gmail.com>
 <855cb221-cd57-4226-9c98-6a66454d3e62@kernel.org>
In-Reply-To: <855cb221-cd57-4226-9c98-6a66454d3e62@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 9 Sep 2026 11:29:12 -0700
X-Gm-Features: AcwNN1VQzVaIrt4CsqSl4wbBcmo6cgneSWi70hN4qsyBG-j4NAiE3BNAF6eDoQo
Message-ID: <CAJuCfpGFYjs7pAstoRhPOWFbi5PdiX10mqBzOBpuJ8qQN_zsQw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] proc/task_mmu: remove unnecessary helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D290B1C000A
X-Stat-Signature: jbqefnrorm8akrzfpj6gj5qi51itbusm
X-HE-Tag: 1788978564-510885
X-HE-Meta: U2FsdGVkX1/qhhLlHnWtdIagsCLJEdCe2C1vN0rfLOU8i34nPREI2OO5Pgo/AKRnvtGPeL66VnF4PvVSVLbupWIjMOZugKl2UUUc88cVjJKtLCnwl/22IyCZySJgJGXHOAwk2eCc8WRw87bqr3Y+iIUfE8D3jh7wCMDz8N19BXuh/NsaVkXcVheGHyaFLGG/yVYHbIBbV5GXKkku2HW5HAXm1xPg9HNlXuqVKwYKmGf+sHcsHv8Rts8tFWJexh2yIIZrpUWZbnR4DveXRcv0eb7lPj6CQcTaHD4D5vr3HXlT/4YngolZrwb70+8oeVHZZ50XP8yFnYxSPM/mS2rX5SNmq+AGyvFi659V+LtCOUBtB6rvClsNw8E7561aZHuhh5QtNYykTlNtNH8iHa/8gqdckoWBg2yTcd4vmr63umT3ODqw6ZJZAyjN2znz8QAZMfMmGABhouaRp7igzCtuZb22I/YknGaGVBeF3lGvlzwo83N9A39PHLlRDyK8R512fon26vX53ev2ab/dyMzmw9v1+5CIFfDdTQUVamY+3TMRdgCt86P/x4ybhn8M/vOIT3ehDfFPE7fBYBVjeexmmJM0pr3R6Qj8121RBoTiKZvru73XR5QwXPiqVdExx/cQGXgd6ozIwqpokXZQjMrFQCs/d688BdJ8xRZoerE631G56u7C73PG+TAh+vzKaRoWMw8tzhHfvoGcv2QIINgYTTkOuWLexIESGAQxjCyYwRrE0J41Xt5HzucPbhX4Qv8lFNPhSxzC/YWREuoL1AGiumVRVlnrPGViCTvANIBWiYh3mUr3Bb9e0gneZukuRKk5TIbr4QtP1uVQpqBRD4IDJ5L51u/v9Mmd5t10BIhvQbntL6w84e/MpRKbPdJeW0dA8nVS4UmbxCBlJIViESI8njXRHSZQmfpHGP1VuyjPNfRCmXgdrvA2s0sLnRGhCaUOTGKk11OtcUyFpHB0yIs
 3yBrDhVA
 ctKGilyAm4FqRECMrI7/Ae241x+ETn3EA5tLMIbVD04dS8VjzAytGM/dKCDaOOOQALPGu8ydjMNApWK9HjE1bpISs7qE4gj4zD9gNQ7BjKSwMhExNPIwdFpgXV8nQo7U7vkXGpS7CGqc3MMx4W533eAx2McErqzNdIdZ2Vrt8AXUNrbHUln8ppqnCQgp/F5mdMsYRDTE6OksWb7gQ9oHWHiSdAhcwmtQnN4ft6rPi73t9B0DboF5FcdoRphNT3LQ0TLipXadtDCOYr+OLZ0LD5MOB4PCxIBz4we+UgVhVK4VqCNmbuk5oW9SiRZinAq8VDV9V+pByoIKjKV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 10:17=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/9/26 19:13, Suren Baghdasaryan wrote:
> > On Wed, Sep 9, 2026 at 10:06=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/7/26 08:39, Suren Baghdasaryan wrote:
> >>> When per-vma locks were behind a config option, a number of helper
> >>> functions were needed to simplify the locking code. Now that these
> >>> locks are universally available, we can do a little cleanup.
> >>> Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
> >>> query_vma_teardown() helpers.
> >>>
> >>> No functional change intended.
> >>>
> >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >>> ---
> >>
> >> As Usama says, this could get picked up early independent of the rest =
(maybe
> >> even as part of the other patch set)
> >
> > I can post the 3 cleanup patches separately from the one that switches
> > to using per-VMA locks if that's preferable. One downside: I'll have
> > to wait until the cleanups are picked up before posting the last
> > patch, as it depends on these cleanups. Please let me know if I should
> > split them anyway; otherwise, will keep v3 as a single patchset.
>
> Let's keep it as is. We can reconsider if we realize that the other patch=
es get
> stuck.

Ack. Thanks!

>
> --
> Cheers,
>
> David

