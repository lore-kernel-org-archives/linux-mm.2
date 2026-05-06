Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E350DFF8855
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6236B0088; Wed,  6 May 2026 08:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDCF6B008C; Wed,  6 May 2026 08:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3036B0092; Wed,  6 May 2026 08:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CBCE6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:55:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6618C0249
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:55:19 +0000 (UTC)
X-FDA: 84736990758.03.7E09BE6
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id B8BF8A0002
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:55:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JK8bwUvF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778072117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKcm7qSGID1d7+0fCs/2lQ6KEpi3TnEwsbyagB0V9rA=;
	b=NQ0Xl2pviOoZbZDrxvVde5kgyfuv23yAqliEaqJFM1yMANio2fRew1U4wZe4xq9WTY0CD1
	DJ8feZv1SS6QiM2yZEFCQfmUzq0cxyquk1SQCcT93ooR7eFPfjgShvgtwwnIOBPbG+1nZ0
	q7vLCbGNbaNhQXJ+4Q45jX4MeqEECbA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778072117; a=rsa-sha256;
	cv=pass;
	b=L/9UcBfvffQiyeDhUP4GWxTKTP6TMKA74phuNnxErF6krZmM5OJE2SF36U0Wv5Zve44ilf
	U3aHn2/LEEat3nhNG91Buap+eKnEKQBaI4TMpIQGm0mCsA9paeHeagpt2FNhyLaadVSj/j
	jEWWd4QCyTCX9GWTwm5Npwv0LoEWrl4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JK8bwUvF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-38e84ed22bdso65547841fa.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 05:55:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778072116; cv=none;
        d=google.com; s=arc-20240605;
        b=UPb16UV0SNXFb0HSPlCzZURey07li80cP+HMgkYj1Cc3H+3iCCM/4vQ0TnvpAhOQ5I
         AXz8G5ns9Z1ujpyAKDHYESpJXw6cTa/IsIw1FPZG2Pg+SifBqaNtmOaEDreUZtLGVuLh
         Ii6++f+1MPpZicDeVQ8p4skEubg810mzvgFCMqTDHdwU7xKEZxTLRtEOthxHR/HSKYbn
         8yVWrYnrwhPGXNCH5XLXCYQHyIDjteLD8ZSNUHSvzpt+V0hjB5YxBBU8ydN4J3gI70XV
         Ktgiu+bQaZRFHVcbqVxSAEIU3yqwpkxr3e2l6hmebgSGz/IQLA4PvE/MW5eq3Ls14lQ9
         LA0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HKcm7qSGID1d7+0fCs/2lQ6KEpi3TnEwsbyagB0V9rA=;
        fh=XUsS/I+HEQk2NKajeUfO6pXA7yqOvBFrkNE+G1O2mys=;
        b=drKJssHh3RqptOhG7V3T+XDRPFy3SM0s+OVzZWbXAX8JpdHPHnUmGzPx8m0s/paKgs
         D4JCdRTnlAG42BW3nezhtra7o/q8I0bU+TK1tOX/MZ3ApqMWV53EVX49Mu1D0nvie0P6
         DXAg/23YrtLFCgQBjooASa8OtFSO4b71eLEwLRxnSB0gbhbpVsYqqkfPsUx13nhNd3VU
         GpmmQQh4Nr7PzEoYQyCC7uCnzM07aA3FYqYxCj26KSMrQSn9cmdqhp0kYhX+G4WnQtPA
         eGcKexlXriCsj5A5uJI4kUlHbXMM01fiWXPCFxwW0VqBv5l7NewvokeIVyrZzFOTB48x
         pg9w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778072116; x=1778676916; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HKcm7qSGID1d7+0fCs/2lQ6KEpi3TnEwsbyagB0V9rA=;
        b=JK8bwUvF1mkODRvlTgvdFHOTJUG41fEWJlb8AztVcU2KcIdVJIchAPHWhoJgO9NUey
         1Ii3EHMruK+F6hieTqhoQxVQvIA5siACSBe34iXdyKukE9yVixXvCTBqtSnHrPZTKwzD
         E0Jj5dIcMgqVqWmk1XTJZ1GxJ9f9RtWItUF7maBVDe1mgROsJrS1docXtcXSOI4QsCl3
         bcsOwKK89bgK/3IHayWuXgi4jiKukqA91h7WofPf5KOH9VHySxDsMB5HTPciwLi0pPnV
         oNXanX2eBq1DcBtesd38uoHNiKxJh5voNS75fqE3RQKZgA1ErWxyPmuFfSb6hM6Wt9Pg
         HIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778072116; x=1778676916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HKcm7qSGID1d7+0fCs/2lQ6KEpi3TnEwsbyagB0V9rA=;
        b=E2Vrf9wFDcKEdbUrtG6mVHSd5cD1qeCwYNdldl32GnhKRFkfOLSTGKQlZTZNu1C3wh
         E0TZ/G+uXwfqlY+VHQ87FzqITwhPawlntAbt6ttt/6kgpBMAnC5t3jgutv3fdAZefv2X
         Dw8T5jsAiMFbxe8ULpze/62oavCpjk9YgMGh+qEkcOEZPSZv2q4oOnDU2eY3zHVmlwda
         z2fraCm2/DFXWO+nD1KelQYVoVLj/Ue3/t0ANocMjsqzM7jCLdCNF4u/dQxQYpB/xtOJ
         8uAo5D2bNOuLBTGJ+gsRPJGsLubFie1n7hag5PjE31kAq5D0TgbjtS6Hlgg2VWQNCbrp
         0FRg==
X-Forwarded-Encrypted: i=1; AFNElJ9V44CQYXiXITxehADglH9YW47Vn4TjyN14w0mRslqqOtHdhjAYfPI6z67vv6Wg90USTFqZtURlBQ==@kvack.org
X-Gm-Message-State: AOJu0YwiRt9Er2DAjhBD0odxHzsF13n3ILtyDbwpE7Gczvo1F0V9MDb2
	4iatrI3BVDJLaN1mK6Tca6YPoRxvw55cKOXjEWGlneI5JHpIU1ec4iteHIGULkqB7vDdCG8/OeN
	ASPfYYgwT6AFOpBMrtfO4NW/wRvdMB7k=
X-Gm-Gg: AeBDieun9VaTS/pE+D/xa6kQqqc/kFOlRO4thFTLAJcukX1Q/cySreEhV61AFJAHp5Q
	0chnC1Kgqo+kvpwPRUO8B+2KbtD1Rw9ymX5gXk1vViy46qcI/ZmbvniFrn5WXe2OTJ5Rr6XVYpQ
	dkXDJQiSxzdVABihis24jht2muUg3IUQRxMic5WLW5MGKXj310YGapANfwewVVp5VutEPwSk4UD
	+ZxrP5nZIa2SSerKSpVGCtUKD+dTUAy1hmr3hbuyluoVqHdsl50MYK1be3alhxI5Z/SRCF27z+w
	oxRFtVj7MvSCIN3p
X-Received: by 2002:a2e:9d86:0:b0:38e:7a75:8763 with SMTP id
 38308e7fff4ca-393c41e12b9mr10705851fa.18.1778072115706; Wed, 06 May 2026
 05:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260503165024.1526680-3-vernon2gm@gmail.com> <20260503172520.376AAC2BCB4@smtp.kernel.org>
In-Reply-To: <20260503172520.376AAC2BCB4@smtp.kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Wed, 6 May 2026 20:55:03 +0800
X-Gm-Features: AVHnY4LN7DcPgfQAMn9z_9QQ6cdKCWiSeJ-qn33sbqiuvSP62RoVofl8dYPVkWY
Message-ID: <CACZaFFOJEBC_yJyprzUsbBzn7Rn6MB60Yi5jwxCm890TgjV4Ow@mail.gmail.com>
Subject: Re: [PATCH 2/4] bpf: add bpf_cgroup_{flush_stats,stall} function
To: sashiko@lists.linux.dev
Cc: bpf@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, inwardvessel@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, ast@kernel.org, 
	Daniel Borkmann <daniel@iogearbox.net>, surenb@google.com, linux-kernel@vger.kernel.org, 
	linux-mm <linux-mm@kvack.org>, baohua@kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Dev Jain <dev.jain@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B8BF8A0002
X-Rspamd-Server: rspam04
X-Stat-Signature: e9a7axhrecfj4nma5zxbxmsba3yacc76
X-HE-Tag: 1778072117-362393
X-HE-Meta: U2FsdGVkX196Ej8aUC6LHnEm5Y9cLS/1uOm6TxLZwCTG5rjLfBr0d6jUZWkyQaQiFfps/4vzavPuxqGgDJtkxVDMzS1paFRQLfUn3126JWTYZEp+yPOPS7FbW1Hi4sVU0hRXRQsMJ4ylNPO+T30fGKFbpOChaUaOM7eTmjlULAxmU54YxExn6Mh9CtgyTOJJzmxqsY/gzZku40pxaOuCgXK20KYsWYNUZLtGl4dyMx7Evu4M2/AS1Gkob0zllDEaKEDuMLeWq8tLSTFWTnhZYEyGtfCCARceHDwfZHjTsLEEPPl762ZjOSs6Dhebc8Xr11tGoWsM3GPN1l9+NaAsqepX+qcxM9+oy8sX+Z/lUm+G95trWldofG8Dy2Obe8zB/bUAxVncr/s/8DGz1Wqm7G7mi1d3F5Sn6C6Z6HyNa2APSACYrwARYTNnsGmbhPca2rag+ZCprYaCgJcoijgY6Zx/duKU3pjdoxBsjh/OIZ8ExvffAOOHce2FHs8h2IQfwLz7QVSs2GhZnwU4N2+SDKgQqTw0c88JdFYt6IxgPBSGwaviygtPe90cli42NoyUpKbpXfgID3JJfkTx6a62kjp7wcNSgq2RAY5NZ2cfVWEkuYviPn1CvXyU7xSLymCc2NwZBW5HrgCD2H4Ez+BFKYgBYCa2Xak8Rvxf8acBZeYq/oYlP/rSpBYBGVnnx+spbflh6jlFHL/3YzDQvXey1/93k6PA14z6gsq/jRuH2e4CYDcZ82usFo4O5tiz8kDtUcvZl+qhEpuw5wCgqe1Y/sDgCcB+rItufgC2k09ii/pmq7tANYjTazujEo8sRK3qBlzTet4jv3C+9kyqbVFCTswlZnSBfZbCuAtDrkoaSy8SZzVSuz/Nroakw86GvNhoHKFZk+4VU7wEewYzUtsisC5MMgzmmuX0DG9BJsCIVZD0Ddk7Xi2TlFZLkZmnjeZNCbxp/AC/gy2Q+DUKXR0
 BzlujBEm
 kWyatjcPaPrpM4vZX3/6AQlLGjQBZsFxs96eKYIbs15tyEfJsuQrp9suyDv40rvwbCrMQfvVlVxEVKxxJ6y+44vn+s2RGe0UAjBTF+MXHvKk+iMqXiq5tqBnzHGYrByqXAX7/2jO4XY7TUHWQ9C663Ib49qHj/X0WUcSZRZVWOrm5paOkGNX8H69E+1ADE1wtEd/W4kst8m9JRORhSB/lJVRDYDUcd2NstlatXjooIuqsyOFNJ9w5ltIUZ3rOpHYWDR8lE+mqoPUkrHgQxOwnCRR6PUAifHj5BN81zPRMhLCoDmGGkarllzXRgue74uSWAqQkJmI5D1RI1q8lXvnYz5VoCMqbxiQPwJ8+BkqWsGpInN9z7bVrRsdnpGy+omq30KD7KLFp3PAsCMoIyPuRh3NLIAuVfobFKdb0ZiAQ0bH5coG6QtCRzSa63H/YiDpiQ9fD4eeTjHOmc74rfLBgAw/kPbZhhNb1lld9VLU+YTfHtnd84Dl6aqODSzpSMFQau9ohT/Isb8wSnd0U09X7eA9qajie//hNVrV+/MKzFGIEnyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko review

On Mon, May 4, 2026 at 1:25=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 4 potential issu=
e(s) to consider:
> - [High] Missing bounds check on the `states` enum parameter in `bpf_cgro=
up_stall` allows out-of-bounds memory access.
> - [High] Both `bpf_cgroup_stall` and `bpf_cgroup_flush_stats` uncondition=
ally dereference the pointer returned by `cgroup_psi()`, which can be NULL.
> - [High] Compilation fails when `CONFIG_CGROUPS=3Dy` but `CONFIG_PSI=3Dn`=
.
> - [Medium] The `bpf_cgroup_stall` function truncates its 64-bit return va=
lue on 32-bit architectures.
> --
>
> commit 11e75919a882d61e2b11423881cab05305d77c18
> Author: Vernon Yang <yanglincheng@kylinos.cn>
>
> bpf: add bpf_cgroup_{flush_stats,stall} function
>
> Add bpf_cgroup_{flush_stats,stall} function to prepare for the
> subsequent mthp_ext ebpf program.
>
> > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > index 2bb60200c266..87f3072adce3 100644
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
>
> [ ... ]
>
> > @@ -2819,6 +2820,32 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u6=
4 cgid)
> >       return cgrp;
> >  }
> >
> > +/**
> > + * bpf_cgroup_stall - acquire the total stall time of cgroup
> > + * @cgrp: cgroup struct
> > + * @states: psi states
> > + *
> > + * Return the total stall time.
> > + */
> > +__bpf_kfunc unsigned long bpf_cgroup_stall(struct cgroup *cgrp,
> > +                                        enum psi_states states)
>
> Is it possible that div_u64() returns a 64-bit value that gets truncated
> here on 32-bit architectures? Since unsigned long is 32 bits on those
> systems, would changing the return type to u64 prevent the stall time
> from wrapping around?

Yes, I will fix that in the next version. Thanks!

> One more thing regarding the build, what happens when CONFIG_CGROUPS is
> enabled but CONFIG_PSI is disabled? Since struct psi_group might be defin=
ed
> as an empty struct without a total field in include/linux/psi_types.h, an=
d
> cgroup_psi() wouldn't be declared, would it be better to wrap these kfunc=
s
> and their BTF_ID_FLAGS in an #ifdef CONFIG_PSI block?

Indeed, this is a problem. Compared to adding =E2=80=9C#ifdef CONFIG_PSI=E2=
=80=9D, I
prefer adding follow, as it is clearer, Thanks!

diff --git a/include/linux/psi.h b/include/linux/psi.h
index 7b4fd8190810..243dcf97bea4 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -52,6 +52,10 @@ static inline void psi_memstall_enter(unsigned long
*flags) {}
 static inline void psi_memstall_leave(unsigned long *flags) {}

 #ifdef CONFIG_CGROUPS
+static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
+{
+       return NULL;
+}
 static inline int psi_cgroup_alloc(struct cgroup *cgrp)

> > +{
> > +     struct psi_group *group =3D cgroup_psi(cgrp);
> > +
> > +     return div_u64(group->total[PSI_AVGS][states], NSEC_PER_MSEC);
>
> Could states be out of bounds here? Since the BPF verifier treats enum
> parameters as unconstrained scalars, a BPF program might pass an arbitrar=
y
> or negative integer. Does this need a runtime bounds check like
> states < 0 || states >=3D NR_PSI_STATES - 1 ?

Good catch, I will fix that in the next version. Thanks!

> Also, is it possible for group to be NULL? If cgroup PSI tracking is
> disabled at runtime via the cgroup_disable=3Dpressure boot parameter,
> cgroup_psi(cgrp) can return NULL for non-root cgroups. Does this derefere=
nce
> of group->total need a NULL check first?

I will fix that in the next version. Thanks!

> > +}
> > +
> > +/**
> > + * bpf_cgroup_flush_stats - Flush cgroup's statistics
> > + * @cgrp: cgroup struct
> > + */
> > +__bpf_kfunc void bpf_cgroup_flush_stats(struct cgroup *cgrp)
> > +{
> > +     struct psi_group *group =3D cgroup_psi(cgrp);
> > +
> > +     psi_group_flush_stats(group);
>
> Similar to bpf_cgroup_stall(), if PSI tracking is disabled, group could
> be NULL here. Since psi_group_flush_stats() might unconditionally acquire
> a mutex, does this code need a NULL check on group to prevent a panic?

I will fix that in the next version. Thanks!

> > +}
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260503165024.15=
26680-1-vernon2gm@gmail.com?part=3D2

