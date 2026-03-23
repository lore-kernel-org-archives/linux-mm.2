Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E871BF483D7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6004C6B0096; Mon, 23 Mar 2026 15:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0E56B0099; Mon, 23 Mar 2026 15:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7326B009D; Mon, 23 Mar 2026 15:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4A16B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:24:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC34513BC23
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:24:03 +0000 (UTC)
X-FDA: 84578303166.25.80D9C15
Received: from mail-dl1-f66.google.com (mail-dl1-f66.google.com [74.125.82.66])
	by imf07.hostedemail.com (Postfix) with ESMTP id CDC584000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:24:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RUJqHBln;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774293841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kd/Ap1nB3+5l9lLzCyst0NQXC8reE8pKqs/t9xxDzCM=;
	b=TjzeR38nRRKRnPl2tpzV1EW1Ivhbq25u1kw5pwI7SHt+FXedRRXxGS8lT7nQlgOb1KZ0Hh
	DFo8+xOnxkWaao9yORjqSej7Yu+KOeOrnkwKPb7nZqQvmoI3ZRA+gskCei+Gf6sRk2LxhT
	i1iUzJPHwvQIQ53qDfHOmlMg7+hq3os=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774293841; a=rsa-sha256;
	cv=pass;
	b=fzv34g2CuBAjU6U4+3GoQxZmwcB+ur3md8mc88bocIFgRYJ4RxXpeVtnGtJfgWr+iP5DiY
	H2BAzoKFLsuxb+79z9f6HHH6XYL8ARUWfWree9aLNXOSkqwq6kXQSsOc6eFDr3wjmo/wET
	fs887aW6qqTC4ndahxE77Int86wJWF8=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RUJqHBln;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f66.google.com with SMTP id a92af1059eb24-1271257ae53so596543c88.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:24:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774293840; cv=none;
        d=google.com; s=arc-20240605;
        b=cNHN7JZy3EHGosRDlnB4rQ4GeEULRsIecGTfj5n5SceURbfzu3eqd6Y2rEWWXwOtDo
         vo8PWRhacxTtk5TsV9IyLwvGpUXHgkwOSAGOL3v8RDB8bv/GOVStabBT3s4CJxQ0X2RD
         m3wElvepXO1dyVNre2PYKkKYaGeCPk/rEByrsis97b++hzf0gDnQiCHHCLA5nwkGUQAI
         vLem5hDckOrjuUeUT4Cb1SY7E1blD7DjfOHsVPODn+iYg8TYc96f7ej1nYmTrvTh3DTg
         pXZsjZb0qnPMw+NRq+IVV6p2olWzSWaMbkJWIp9dz2qGEriHlMwJdElNcoUtyzMcWh4G
         mgRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kd/Ap1nB3+5l9lLzCyst0NQXC8reE8pKqs/t9xxDzCM=;
        fh=4ENSzgU1ItM0+0ymxG08LDbc3vYFyS+2AlMfC7qISBs=;
        b=ftzW/ymmRWYoLXVzQAgTCq615EK9dKajHFDWCrJAP5Gx11nNNhog3bLkaBS6yRgrx1
         6aKIlSPuzlbz24egdyR3SKC9Ks3ECzUAVP8+ktfBtNwgyPf5HSeMMIDCY2w7b2/avvUo
         RMuuQTkkVQX1vHYOvdY/QZHeZU7so+a7HCYJxdL412HvPVGoJ+j0EkGuEsdIHBRPcBpg
         aiQ6VW/LP0Rc7OIhle0S+TUkge+aYgFvi/0vIqA6oH+KukJVn5LkkaFB8q+YmmAvuRQi
         ojpfR6oa5aGRBgsTX9/SORjJ6NyBupi7PIkqeu7F+oJW3xri8lEJ0dg/2JhETClLgnI5
         l7Xg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774293840; x=1774898640; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kd/Ap1nB3+5l9lLzCyst0NQXC8reE8pKqs/t9xxDzCM=;
        b=RUJqHBlnwbzdmtQXMeTnlPDYI52RL5Sa/ogi2DqPS91z/ou7NdY9FsVejxBZnKhn4S
         LkrO/QtdX+ijCwwySe1PfCPgG5RySGy8SCV4c54tlTcb+FZj7cwXhX3BEiPXz80jkgBp
         SZoyk4lEfqK34PAGZNbeptxVAqX+neaXoDnRpJ5oZxoZc2h3HPl2kAAAODzxhar95zvb
         RmksioSFpxgCosXHCwwFh2+/zpa79V81wfuye6uRA2Jdfxt5K/Xj9EiEJdGC02LtZvFh
         tnycggh+kYR8f1ZdG2i6zae9q9HYyDP8PR75PSdkz6fUfPA9zrtztYqVnN/1hM5RWrhD
         0jMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774293840; x=1774898640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kd/Ap1nB3+5l9lLzCyst0NQXC8reE8pKqs/t9xxDzCM=;
        b=Q0iL47l9fltshavVQthdpTNdp7pi41RmKwN/2rtOszFGk460KVNJxQSfmXz6WfwE+K
         0vQXEBTl49yXF16OG8lIC3k5DC79Ta+RTpFzd3JRF7XuH9YDVTGSAOD9mL68hDnHHbIK
         /zq2R0Wilt6OouS9+IzT98EnooLUySCXBdGfHcDJaQWcXeDucSC97USwpabxO0fQRnO4
         ZF0GG3OYXkru0o7a7HmyJotcgHc0Jrjdqk8ak9zLRq3NAqia3XFD9O3wSDGbzCmIjtGt
         S+dHeah/Us/nZlS8EzqhkGxt4m39gVz+ZCa3aziXnuOe/FpHnfdmzMoM3z3PzjEFrHIZ
         cnyA==
X-Forwarded-Encrypted: i=1; AJvYcCU35ZdxSaXd88Gwatq+oHDeciRrvV6fOtAB2tQC8P459RXTkWyBC2hhF/q5GQCEOdyLJVcvO/JaSA==@kvack.org
X-Gm-Message-State: AOJu0YyAsNV54Exhf+jQx3O+0I0ya2icUb018WvTwCoWMzmu5clVy6t8
	gDGt0VWUlLbV1RN9WNZ7exi+/8YyoWimiQh2U0ijhdQrYxWXgS9ljmMbKHX54x1B14XNxeU2dIx
	nqogQIPbbepD22Kz9NSawMjaxX95lig==
X-Gm-Gg: ATEYQzwrdHHbRp/DVpOuu66lgcuYGFP1LgknluWQNvHk/lyW27lzupG+Fti2qMNsToA
	hYpbQ67TZyYroqBH6ypbSliSH/TqjLdsXDKgLA4mFiWWM2GtyAG5LZ1XVVUpvfLmgaG3oR0/lWi
	U9FofREYbM5hW7iz4kJvrOVv9wUbahQ+KN9AdozCNm1EmXChRTDN5XsVbR7quJAAxx+xgd8xrLT
	gYlG4rspEEfiycuUfKDVgRErweKge0rRhdlWUGZJPCkwem2BKUnkJx11A/iWT5boW59T5z8/2gG
	XGoGJGY=
X-Received: by 2002:a05:7022:2507:b0:123:3500:b688 with SMTP id
 a92af1059eb24-12a726dc4a9mr5332008c88.19.1774293840376; Mon, 23 Mar 2026
 12:24:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260320190453.1430-1-ravis.opensrc@gmail.com> <20260321165746.84394-1-sj@kernel.org>
In-Reply-To: <20260321165746.84394-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 23 Mar 2026 12:23:49 -0700
X-Gm-Features: AaiRm53G1dtITD6OPSmNFBca8dgCST3mqTjoCxapaAIAN1uqhVUWdPIlUbgjZ-w
Message-ID: <CALa+Y15sBCyVgGKC5994-WhS31nahyT=8uitDPG_isZ7sp_g_w@mail.gmail.com>
Subject: Re: [RFC PATCH v4 0/1] mm/damon: add node_eligible_mem_bp and
 node_ineligible_mem_bp goal metrics
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: n9qw6q1d1rg6i1bhx813p41yfyua4x8g
X-Rspamd-Queue-Id: CDC584000E
X-Rspam-User: 
X-HE-Tag: 1774293841-593359
X-HE-Meta: U2FsdGVkX1/ZKCXXI+uC29dnJOBAPk2etyZpipVjoquzP8GNm3QgNgYGULyOlfRzEY+cjQQHgZ5FCjoJzKRK3gjz2vuUs2NBdxZxqU6WVk8TjbA6stRQbt9M6mGbli+Pu4jRsvhlEYSYmCIbamBfD2rzHpsX+9SfND6hInIDT63N9AeCVKEp+dTRRrPB3SPqoYmFUVpOoiNWzLg14yLM64U6x91b4D3mYlwn56W4Y/W7nFZSYRhlIT+tnnfJliew4m6EZ9Ohpa6TuCOH1Vz7p9ZsHdxGBEGD1cBHPM33RdYxHzUCnxiOEOQb+po5gNNYY4mPaaCs9QXmDf+SQrL1pj7MgHclwJhESRiLEkECzUb+gth56dhWEZqlAd+49MSkL2b/ChgoOwr29e0f83oLUGr1S61I5qFL/8xa8Yr0+z4tl+O9jPOctOUwfqtkYD3Cj4NuM6SY7f2uFPjfcrPGfZXDDXRxqYIq2aRihu6UyTAuYnAwLbFhsOwMcnC8d0x23F1mkcJNvK/cgXGSYbdN3aVzD4cZznjN7jpBWvXMymKBCaKO/YViyT97QHIGpnVJdqqpsw4QCNzxyYKjO1GY+ZYJltbcFBneaSp66kM+A17TESug1m5Id55nbkExwkzJbfBv7Yu+lvusJEk4uOHS5+dcSwL8DZSmMiArh++vRmu880C3vrSI9TP/eqlGUI74M69xsSFHme7Dp8zMAOsaasiXanIoipdlP1hQV2LpymY2C5w085yinAiS/fll7puWHtLkE4kITTDmWkRa07aFKIvrWH5tCazivi8LC6QvypqeAQ8I71spaP0mJmvJ0CMmzq/Fr1D6SWhQR9eubofp9L+XhQBuX4/CSiGNlFbV6sABfxP6eX6r9f66Ge3Ds7ltZGe+Qq8gikNNbE6cYJQGJ8XuL9sgMpKRETbW6aRHMYMnVTXQ98umh/vxzBvDxuIKU7CoobWUXivfpDVHs8o
 UuG5HyUn
 cX56q1c96NtAOPE0ev+fhRAjI85VI3+9+EIc6ehmCJs259lyVBRXXay9SBk6/p7Pfq/4+Alji31FtrEPgGemqDkP/JJWS9OsZX5uu0B7U8PjQZaAadmgE5EiC0GBMeSCuo6SZb3J/XMtKTJBHa3eZLSf9ep3A3LM3SuXqnF1uKDCvRCkGRQPTRxR1OK2mPcaJhC850cZ9Hjgu1dczWtTY5J5/4nYzyzbkwJnLvJMufktUMEX5BAKqKkks6rnzVbK7ur8GavKOHP8qoxZny28Y0VHeCzk6DrHoNAeIUIjUdVOTuJ1+OolMyecyZyvCIlpcHD7iuf2oYW2gpwu3ILuE4dVCcFESn2G4rM/w3P0zOT+1I4fgyJFy8IMJRiqryLn1PEroz4MblOHBOxF33s34lu6byA8Diai6MrQvGv/zjqKtolTID7kPOnDU5o6Mk9by/xqJRA1yvr8uWl+9VGxWY/Z7mmrUYyPFwDpnZvIZNs3Fy80zdTQvxgt6C/QhO5DF9IRMQnlMDgGT++CG6BvfgKbIITsz3okeDsyFKUMmw9ojdz33iLUBB6hITHlC4YKntrqhTvFWmN6w8rJjxe3yXeKCnzb7N9rAM3ApyoEtnCYmyKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 9:57=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> Hello Ravi,
>
>
> Thank you for this patch!  TL; DR: Other than trivial things I commented =
below
> and to the patch, I believe it is time to drop the RFC tag, and work on m=
erging
> this.
>

Thanks, SJ, for the prompt and detailed feedback!

> On Fri, 20 Mar 2026 12:04:52 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > This patch introduces two new DAMON quota goal metrics for controlling
>
> s/DAMON/DAMOS/ ?
>

Will fix it.

> > memory distribution in heterogeneous memory systems (e.g., DRAM and CXL
> > memory tiering) using physical address (PA) mode monitoring.
> >
> > v3: https://lore.kernel.org/linux-mm/20260223123232.12851-1-ravis.opens=
rc@gmail.com/
>
> The above link would better to be put on 'Chage since v3' section below.
>

Got it. Will take care of it next time.

> >
> > Changes since v3:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > - The first two patches from v3 (goal_tuner initialization fix and
> >   esz=3D0 quota bypass fix) are now in damon/next. This submission
>
> It is not also in mm-unstable :)

Good to know. Will mention this in the next version.

>
> >   contains only the core metrics patch, rebased on top of those fixes.
> >
> > - Simplified implementation: removed per-node eligible_bytes array, now
> >   iterates scheme-eligible regions directly for each goal evaluation.
> >
> > - Handle regions crossing node boundaries: uses damon_get_folio() to
> >   determine actual NUMA node placement of each folio rather than
> >   assuming uniform node placement within a region.
> >
> > - Pass scheme pointer directly to metric calculation functions, avoidin=
g
> >   container_of() derivation from quota pointer.
> >
> > - Fixed 80-column wrapping issues.
>
> Thank you for addressing all my comments!
>
> >
> > Background and Motivation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> > In heterogeneous memory systems, controlling memory distribution across
> > NUMA nodes is essential for performance optimization. This patch enable=
s
> > system-wide page distribution with target-state goals like "maintain 30=
%
> > of scheme-eligible memory on CXL" using PA-mode DAMON schemes.
> >
> > What These Metrics Measure
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >
> > node_eligible_mem_bp:
> >     scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000
> >
> > node_ineligible_mem_bp:
> >     (total - scheme_eligible_bytes_on_node) / total * 10000
> >
> > The metrics are complementary: eligible_bp + ineligible_bp =3D 10000 bp=
.
> >
> > Two-Scheme Setup for Hot Page Distribution
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > For maintaining 30% of hot memory on CXL (node 1):
>
> I think it could help easy reading if the above sentence also explains
> node 0 is DRAM.  For example,
>
> For maintaining hot memory on DRAM (node 0) and CXL (node 1) in 7:3 ratio=
:

Good suggestion, will clarify the node mapping.

>
> >
> >     PUSH scheme: migrate_hot from node 0 -> node 1
> >       goal: node_ineligible_mem_bp, nid=3D0, target=3D3000
> >       "Push hot pages out until 30% of hot memory is NOT on DRAM"
>
> Seems the sentence assumes the actor is in DRAM.  It was not very clear t=
o me.
> How about making it clear?  E.g.,
>
> "Move hot pages from DRAM to CXL, if more than 70% of hot data is in DRAM=
"

Got it. Will use your suggested wording.

>
> >
> >     PULL scheme: migrate_hot from node 1 -> node 0
> >       goal: node_eligible_mem_bp, nid=3D0, target=3D7000
> >       "Pull hot pages back until 70% of hot memory IS on DRAM"
>
> If the above example is good for you, to be consistent with it, how about
> rewording like below?
>
> "Move hot pages from CXL to DRAM, if less than 70% of hot data is in DRAM=
"

Agreed. Will reword this too.

>
> >
> > The complementary goals create a feedback loop that converges to the
> > target distribution.
> >
> > Dependencies
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > This patch is based on SJ's damon/next branch which includes the
> > TEMPORAL goal tuner required for these metrics.
>
> Your test might be depend on the feature.  But this patch series itself i=
s not,
> as users could also use it with CONSIST tuner?
>

Correct, the metrics work with both tuners. Will reword to clarify that
testing used TEMPORAL but the patch itself does not depend on it.

> Also, as I mentioned above, the feature is now also in mm-unstable tree.
>
> >
> > Testing Results
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Functionally tested on a two-node heterogeneous memory system with DRAM
> > (node 0) and CXL memory (node 1). Used PUSH+PULL scheme configuration
> > with migrate_hot action to maintain a target hot memory ratio between
> > the two tiers.
> >
> > With the TEMPORAL goal tuner, the system converges quickly to the targe=
t
> > distribution. The tuner drives esz to maximum when under goal and to
> > zero once the goal is met, forming a simple on/off feedback loop that
> > stabilizes at the desired ratio.
> >
> > With the CONSIST tuner, the scheme still converges but more slowly, as
> > it migrates and then throttles itself based on quota feedback. The time
> > to reach the goal varies depending on workload intensity.
>
> Sounds reasonable!
>
> Do you plan to further evaluate some performance metrics?  I'd not strong=
ly
> request that, but it would be very nice if we can have that.
>

Yes, I am planning to run additional tests. I will send v5 addressing
all the review comments and dropping the RFC tag. Results will follow
as the testing progresses.

> Regardless of your answer to the above question, I think the current code=
 and
> the test is good enough to consider merging this.  I suggest dropping the=
 RFC
> tag from the next spin.
>
> Thank you for doing this, Ravi!
>

Thank you! Will drop the RFC tag for v5.

>
> Thanks,
> SJ
>

Best Regards,
Ravi.

> [...]

