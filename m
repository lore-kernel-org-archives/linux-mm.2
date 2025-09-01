Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F2DACA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11C28E0006; Mon,  1 Sep 2025 04:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9748E0002; Mon,  1 Sep 2025 04:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926C18E0006; Mon,  1 Sep 2025 04:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 816FB8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:01:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B27B1606E0
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:01:32 +0000 (UTC)
X-FDA: 83839936824.05.4B6BFE0
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2405610000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:01:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=VQk8N95B;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756713690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ElVgYPiPhFnmapkjg+o9uJKTkd6XvGBVXP9+0Qz77V0=;
	b=BNbERkOwg5a7FelUrUBvz/LTbc3ByQVBGaT/C/wjhutu+nN761TliMwx3xbEAlMW+UN6Ck
	NxHyyALv9FYkyXd01yagFxOpxdHu5NCz7O0bzf9A/vRlnznkfGbzTV9N9rYcUjLQ21sbpH
	M7ImS1PTF92ujFf7n2oEGW3g+TmHVts=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=VQk8N95B;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756713690; a=rsa-sha256;
	cv=none;
	b=zd5mk9olK4eMJi+PoaQdAPoe+ajvP5mFY2DwTyPwHiQKNrq96nNOKDmQ0X+n8/wx2dm5B4
	eqG5rr5BVy5yv73TylXSprtVchq77WYi5fSQG+QbsYpkCkftd7COR7dR/kvtv2/vc+4Ey4
	/Tc1i9vsFGDIsVysUajqHJE30ZyABak=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-afcb7ae31caso776327566b.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756713688; x=1757318488; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ElVgYPiPhFnmapkjg+o9uJKTkd6XvGBVXP9+0Qz77V0=;
        b=VQk8N95BrMA7ME8h/rO61ObOAMQvQb5NLHejSiwtJJj+6b+qb36AZpA1o4vNJOolLD
         q7g8XaSQwejdn/BIHGtilq/g8s6cBY7gDH7sh+o/cBhLaJdV82xROCdBrCZmqJvKj5mp
         01EIiSfqJyh4HyHylxgsrZUpnXylmPLPfNuLi8DuqqKM/DElLqCs2h5C5PiT7iUSpPlG
         FREH3JEbbTgEUFEQVeyarHrMlX5uRJN283fS+o3z0ew+rl/zISmH4XrfbvJso9c1ShOR
         UrBx7/5hXt12frF67CtjtOPXsDez2KDtne1GjF5VDyDICgVg65LymzhbW77qolAbUy1I
         63xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756713688; x=1757318488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ElVgYPiPhFnmapkjg+o9uJKTkd6XvGBVXP9+0Qz77V0=;
        b=NpouVwVGXhNqegnYO4c7QOaFj9xacxYlOeaktRF5PBbGonUKTITtn6poYvctrqeY+a
         ly4VtmG733Fx6WFbpiqbWXUtkgYcsL9r3lUzapfoXXwdFtJch2FZIfA5OHsQgWvHd+vN
         uWRL1emUtwAdQ5nEg7w0sKItfXoq1ai/Jc82VYTjdGj1skhbd47FyofUi8k3TUkYdT5K
         OrcpxxYhRGj4dTvFD3otwG5nBw4DzdXQepg8rZXgMB4S385FGTG5pHJKGLJ0rVtOyS9z
         P56Hpexk8ZfsbFbiKn/ed2qFZeiOhUMZU5rdOeq09taDV23AAw7lxhnL0G4n1Ejtocw5
         kLUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUq/Sz6/NFk2/GfYaOqapkfAt2a6YSTy+DAR3IOZqrMPuruy72J0FfpSSDn8TzAuVp7STBG/zQU4g==@kvack.org
X-Gm-Message-State: AOJu0Yw3S/1A8CJaKr8ODWrUy9FO3XDVeXnLCF2mgQ6RQxMPYNZeymr/
	G9+dw3elc4BjVaNs7OudJJbERLqhJZMQBvK2GTkK/zhwZAkxGHusJP2gQD0nO+c7WfX8Ornvzjd
	smJVCtf+Hl+Nkw9apWq7btO43XlQqFcIfE3gFw/HZ6w==
X-Gm-Gg: ASbGncsMQ/8JfUqjx3GBemHq8aE36Dv7D60CFAxGba57T9jmskK4aeWLgVJhsLMVGXp
	dgQOU9slLuh16Ulk2PA8/+OM8Z1OfWmodfbjhZwZnR9QNodQpDGY2v11IRhsjC1k9Ye8NmwKd+D
	sMdEYEeWleHGr9bYTVNCzAFmbpu37/Y29caELJvhkRDZ+jbhavhjW0VloSU4/PiI3+2CVlZFIdi
	Bul/FBkrq4h5oFdbCdXrwdU94SGbPwh8s4=
X-Google-Smtp-Source: AGHT+IGbf2+rtrG5OsSWDupeVt2DyJOST/f2CR3y0EAEtEchftiG5U1wyRNP5BqRghvnVqjtrLUrmIVj5/y59HxwLBY=
X-Received: by 2002:a17:907:86aa:b0:afe:caf7:6def with SMTP id
 a640c23a62f3a-b01d979a6camr770360566b.54.1756713688363; Mon, 01 Sep 2025
 01:01:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
 <20250901061223.2939097-2-max.kellermann@ionos.com> <052aee05-4cfc-4fa2-8944-4c85676c95ed@lucifer.local>
In-Reply-To: <052aee05-4cfc-4fa2-8944-4c85676c95ed@lucifer.local>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 10:01:16 +0200
X-Gm-Features: Ac12FXyLver_1AinPcvhgsFNWur1r_pRnDcdlhlX6jXPmQjj6RJlaLuNO2Kj3Wk
Message-ID: <CAKPOu+-A6EoBnJhYkgX3Ktuivo2hpDZtbCKPfcmR_SNsvPQ02g@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] mm/shmem: add `const` to lots of pointer parameters
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2405610000A
X-Stat-Signature: zenrcw6udfw3j6bz69d8wkjsa9t9gkgn
X-Rspam-User: 
X-HE-Tag: 1756713689-349359
X-HE-Meta: U2FsdGVkX18VqqXnPRVQC0Y+YzkZ1OuemcN0ms+l3+u5pbWaQv6FzBA0vbEhKt7vkTimWSk//gCibCPyDUZgwEQj6kPOgoLK8RP/tVhsuIcPTxHKt2hiZ9NwHwVYYooc2vE9LNhFrjAIk767xxWPg9ERHo2K3JNnJDpJMDb6Bqok+g26cf6RGnZcjwFe26elqAHRpYhAZg+vmh17kyaZ42QNv9f6INFBV6xT5r7FxvGdm0RhKTQw7Apy1w08OLFJZOu1au7nqHo6vEqjN39vLpKnzwWeqA+Zupf2Lz9OhpBfRUn4BoK5RupvGStCpp+ZljQg7Qie+XyL8+BdyNhSfrGWNZlBBXF/CyGhSCQYfBBTOSQpWoDCxSENgJh8aUEfLRZuuuOHCoH54yrqOobrbuwlzRDc+7umj6leLUbAivV6Vg2HBVOeG704lo93LYRzbUJP6+2Y37jUvVPLNS22etXF36NiN/30B+DiU/GNXHFTsEQ7TRSSgAhMggHxYZEV7q5J4D0eemtCYivZ345jaMBtusCpPksvU5UQGMti6uXE8s0GpZQzbUZwuN+cTXFbvKedtWHn9HZCeyTTEofGJMbA3sAGWdAuC1ahdE8Y71AoJUQcjbjml7m/bo4Jl1S0cOVS7tmXDr1hpDJtoGslTyKGN0jCCX9czf2WRUeChsHIAVS36DDiFr+s7PS4mdhEDzPRGS5ZB689M/HhCuKAEpj/dGQryUXMjuJJbjGCvk1Idu84We8htHe7IyJ00INrygvGl99eN2tOHrWUNZHuCbqgcYdShs+/JCIeCje14hrMwuXoWKoB6Znr4ULWjF4vxeQJ1ZLJ7kVhMT3Iamgcf+hgxA5oYpcR8x511nOlpNgbN0IzXofh/tvxeaDMJqtDBU9JELufxfziMc30A3oHf8ANou9Hj/HWvq8yWcwSLEc91fzQUTmfWATkh2bOP0vwaz+0/RR1z6aIrAmlV1D
 pANTLv13
 3j20z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 9:44=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Sep 01, 2025 at 08:12:12AM +0200, Max Kellermann wrote:
> > For improved const-correctness.
>
> This is not an acceptable commit message, you need to explain what you're=
 doing
> here.
>
> I'm thinking that review will be the same for each...
>
> For instance, reference the fact you're starting with functions at the bo=
ttom of
> the call graph,

My 00/12 already describes that adding "const" to mm addresses the
lowest level so higher levels (outside the scope of this patch set)
are able to constify their APIs.

Other than that, there is exactly one dependency between the patches,
and that is documented in the commit message of 06/12. The rest has no
"bottom" or "top" that I could describe. All other patches are
standalone.

> and mention which functions you're changing.

So you want to have a list of function names in the commit message?
Maybe I'll write a Perl one-liner to extract that from the diff, but
.... will that really be helpful? To me, it looks like noise in a
patch set as trivial as this one.

