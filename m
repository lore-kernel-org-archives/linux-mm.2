Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 229FCD35669
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 03:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89E816B0088; Tue, 27 Jan 2026 22:27:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D606B0089; Tue, 27 Jan 2026 22:27:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FA06B008A; Tue, 27 Jan 2026 22:27:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 627C96B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 22:27:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B3BD1A043E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:27:12 +0000 (UTC)
X-FDA: 84379936704.03.7B5938B
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1D1B54000C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:27:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LE1H+0Ya;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of joshdon@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=joshdon@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769570830; a=rsa-sha256;
	cv=pass;
	b=gg/qWwsXtlO/ifYqGEFu1I4a7gv1qOVpyIkfOwHR3TZoEFV0zj0t7TvrjMP1xerw25c7rL
	Ozj2mup8AY+mZMzZIaMbSmRZLxhUjGcuy8NZiolRTNdN5xgAw41e8TEw4VaSjDckHCK3Yk
	/INZxkzIZLbCRCKds7o0ILcijEStTac=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LE1H+0Ya;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of joshdon@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=joshdon@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769570830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zf7Tm2Jip/HxUQQ0xjmMGOCazGDoMelLUCNE/JwSuI4=;
	b=8e+lXE/a351+/OzbHoMlcgKoH81OMhS2R23doIV8lW4nqDEBnfmfdOrV2vgjQt46p6nUr2
	HvIgw+Zum5TSE1tObJtr+m33ifD8FfrcUVP7wVsvRC7BBxn1IKmPo2cryI7l1g7tAXxAzm
	v6nIdZUZ/sRHegep0FZbNPWdt8Ezo3U=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5014b5d8551so181801cf.0
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:27:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769570829; cv=none;
        d=google.com; s=arc-20240605;
        b=hwUEdze4E+LoZvWu8dwrbnePIz0oz7hMVhZk5jR23FUr7PknTR2gAc0/Gt04fwuS04
         +wUqCzmGDNlzccoN5cirQ5C/8ZQLXc7e0/tZKJ1OxtR9u1rUDKwXTnWOhBvMAINkAcIa
         /mZzxM2RDuufVcjndfvPgQTlSXGOg8XRgop2yBBuNDkRfil8PWFlSRl1PPTLXnDd2Yoa
         z/zZHTETiYXo3yEW5TLX/wi74iQLGLZIRz6lZr4SFi+SKky/g/XC0HL5BW4ivbyKKvG0
         rC+JQRKeMP44e7daqtKWzjADFyCsMn136N+OzIFVrKnHE4v9eNi6BxkBiJZ+YFgf+xgz
         lRlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zf7Tm2Jip/HxUQQ0xjmMGOCazGDoMelLUCNE/JwSuI4=;
        fh=txiiYxXren3IPqT/+HRXGt+tG3Dpf3x3ZZq2ZeBgwg8=;
        b=WNoUmvvRSvlZG7guZWergwbHMdoykRY6d0JFyge9IAmUiY0ufc1StI5qbN9OFNgowx
         fOIkS0Wol69opwhaCX1H32T4AdOqCJ2g2PaLtKjozWXYlH5lW9nenQDASeSvQJWHLd8J
         81GRcbr5sI3kFN1FdlYKbCH6TFdyStF8TB00Ggs+5xJs9Fy+XPNH40pocrzBK1jbpc8m
         spfYQSeU1P+Nue+VO1blIa1wAheYQt8J5tPdmvrRULL/fxUXyDZAmRN3gR2EhWvUZuG5
         BIj513o+1lGr4j8vLZ8qKBogDHLHQafaOGLpNwxpQc3POZeVj1eccP4iNeDyrNrjHv8J
         9p6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769570829; x=1770175629; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zf7Tm2Jip/HxUQQ0xjmMGOCazGDoMelLUCNE/JwSuI4=;
        b=LE1H+0Ya+GJIHE84k9XcSHsGtCfM77PeNKBlxATlYsDleiXh36SbsmZBKKFkZDzjIj
         1w4vXJokRHKWZGgqjs9alqrVYuq8AE+L0Y95QiBQknGuPITmJ8+orbjrd5WM7xUF52aC
         YCt6DLHcdr1mHpVI4f8ztKsTbzYY2rKjEAbQHFFZU6+wX0jEt6p5wSzFTdIuCFsUWuKV
         3wVLyjJ1EYrUo9c5+DFmWwoGiVw78rFPXifRoMl3iaJg3B5ORptiyM7csb4Ya1FmKJys
         jzn/fa7+ZNHYqnrYsk9UHuG8M5D7FByyPjhfBOl4Mld9hMsJjJpWXO7z1e8NIokLHlwo
         SkvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769570829; x=1770175629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zf7Tm2Jip/HxUQQ0xjmMGOCazGDoMelLUCNE/JwSuI4=;
        b=vyhtzsHX1bu8e/ZwgX8ebLI0N6EkA+MXZkoti8e/AyQGN8li7ppDNCdPGS4d103kLQ
         Qf2LgWqsDwYE7k+JEogjWGw082HDSLap/4peJ0Psu7YroQKqrajK0d6d9D2cYinUsAzo
         GO0zknmq5E0d1pP8IG2SRdGqe33x4emE6x60e5m1vfxaXb5dD+G1cBJdvQtrxY68iuae
         8fyA4XtDiHQ/avuAfPnd+fScfWqUDE8WpNNKyCX5QVLczVQ+oNeV+oNK0GlK2EIIF6O4
         6C52eEZjcTOqUZDVb7rcgvscxmx+tPNXFqgf9QBZwQF7LD322npuuKJuhZVjZU15uvFp
         BVnw==
X-Forwarded-Encrypted: i=1; AJvYcCUeF61KISBmCvrgF8HaFZZdMkYZaFutGaDFmZlgm/seuk5JrsLY/leJUeY6QGaEByrC+x4aG2Lg5Q==@kvack.org
X-Gm-Message-State: AOJu0YybtBoVb4NPC6PoFR3XzPlf1LuVlAU/UkLb9TNxyeP50CGVUXfs
	C0QYnfnHj5fxrabOQRQHYvrmUbTxNW90r+zvorqlx0fuvUWeSRfR+ReuxoWir6f4GUeDummJbU4
	vrX7tFRACn0oxSAtbgyEYDhkEY5n9zi4BCX7LKl+upb6iYHth2fPd8cCMr2I=
X-Gm-Gg: AZuq6aJWImWHiQXQ2b4Lku5LkxSaSodaVpkbaTuJZRqsAp5WtpSw+RWGIZ5aZ70KFya
	Wprw+fjhDSBuSLR+0WVG3OXnS9RcVTPyVZ9K6N9ZcPiSFh5q4ynySH04wlSWKXU9jW19G6fZREp
	RzC2IiU3p2sQCi7cJ7Kh6CVSXx0wPVBDvLOKNS2nEJ6b/XJUnWxvaSNM1/F/aM4DKW4pvf8riym
	zb7X2UYtnMkhU0MjziONog9Aq1dX/FYR2b2pUeX31qUsoyfAOQsKRaHvnzZmXT7mk7be6If
X-Received: by 2002:a05:622a:1789:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-5032f45f3bamr11080631cf.5.1769570828932; Tue, 27 Jan 2026
 19:27:08 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev> <20260127024421.494929-8-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-8-roman.gushchin@linux.dev>
From: Josh Don <joshdon@google.com>
Date: Tue, 27 Jan 2026 19:26:57 -0800
X-Gm-Features: AZwV_QipzviwRyw_75oZ7mX7mlAb-G56PYUvE1_6oR5zZnsnwBraNgz192rZadI
Message-ID: <CABk29NvSku-zb5sodOYjWhW253EHGu52VNQ6+pQ8QuvEoVQYRA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1D1B54000C
X-Stat-Signature: zk68d9kzgsdduhx5mgfamhhd9ntkdkwd
X-HE-Tag: 1769570829-512169
X-HE-Meta: U2FsdGVkX1+MHnGm7uOxKOaGCMMc7JsSFmi08brADNie7cIcUpYS86cnTAShcCzBusdEvWgGp4B4tggt5sLw4CjEWPP3CtGr0kHmhBHkuhH4LyfyUF1iDtz9B3nUUHB/n3OjXRCgZ4/UBhELD6a7+SuaGi4ntAvcmpMgj34v28rE2I8Q+oP/ttIaAocVGP9IRqBIQ1YlgGfAwbsAm/ELFKeGBWaA1B4+7/G5kCfd1dQFUaJAm6AXsMiYfwdOLm27YAMeVW3yqd1RhY/esqfOnwbzEQm/8AWJu3ke2k4vKhGQ7+7VUiZe/okLbXGSApwsggG0l/4nNs75blvoYeF4FZlK4UXTyZoOdGPoesa7/P3maeds57yM1Ifp7gq09CUlbup1uP5G5U1xl8hqsPcXA6+T2NK76lBK7iCfa0zm2Co1XvqOVITgFgfTBVvSDYS6loXBFI1i7F2KM3KHlvI8NATl1HRWxNGyYtQSjrEJerrKGnr+C3jA/nSjuSJSjTKAUIrHIDkzqc89EmeJ/FBy6307je+BlNueeqsnUCMhLBCwi1XeH74LRb14oCRc8GcPBhvW2STKbCSprm9o+KNyR8nLsn+a8cy6yAyVhLwUdImFzusV1cPvTWgceIHlqfaiONbIuVkX62LqvYvjuckHpH8KP0YnK6+eDaDf+poYhw+0odK1tcjwwBdOM3Sov3RJztrVjYNi9UGyuyIGre+eZIEsJ7Isqfsfh1XuPI+9izAMri8ZVWKS2m+chFgde/O8H3zzLdo4ErePkvAKawV8VsqO5gdEhPqkZll0lCw1YGKpi5emppzlPbm/tA2LiUYx72XEM6SA/ty6uNqymAt7YOIKJ99Txr4NJxC5Y5uzQ6PsuAGYvkLZQIM2pLFK7TMGcHGUfNDxxzxUdte4MBC4audAbhxUbxg2Xfvw3i1AMjYwGUngdx1MRzSW4YpTIGNJD4qgtlP/4Uj5y/jZBTP
 yYPd+lch
 nylak3KovLimOSM0KwB1lRLGZV7YV7exJQHY8E5CRitSjQQcHddhRrhK0/jA+PXJdZsTn66Dho1oq0+We8PVgdZiDKhCU5uDz7ZgneQ55iBw/6+sK5OgydIrPE1iC9gagD9tRPRKa3Cqy8Hd4XXyy2YoCnkkk2JU4lHjs9x/MC/mdzxaGz1jSCnusJ3N3yx7bZ5WuX/e6GiTuqJGfWvNXEeq7UuyEgMJRmM5Et+txRlCjwmg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Roman!

On Mon, Jan 26, 2026 at 6:51=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Introduce a bpf struct ops for implementing custom OOM handling
> policies.
>
> +bool bpf_handle_oom(struct oom_control *oc)
> +{
> +       struct bpf_struct_ops_link *st_link;
> +       struct bpf_oom_ops *bpf_oom_ops;
> +       struct mem_cgroup *memcg;
> +       struct bpf_map *map;
> +       int ret =3D 0;
> +
> +       /*
> +        * System-wide OOMs are handled by the struct ops attached
> +        * to the root memory cgroup
> +        */
> +       memcg =3D oc->memcg ? oc->memcg : root_mem_cgroup;
> +
> +       rcu_read_lock_trace();
> +
> +       /* Find the nearest bpf_oom_ops traversing the cgroup tree upward=
s */
> +       for (; memcg; memcg =3D parent_mem_cgroup(memcg)) {
> +               st_link =3D rcu_dereference_check(memcg->css.cgroup->bpf.=
bpf_oom_link,
> +                                               rcu_read_lock_trace_held(=
));
> +               if (!st_link)
> +                       continue;
> +
> +               map =3D rcu_dereference_check((st_link->map),
> +                                           rcu_read_lock_trace_held());
> +               if (!map)
> +                       continue;
> +
> +               /* Call BPF OOM handler */
> +               bpf_oom_ops =3D bpf_struct_ops_data(map);
> +               ret =3D bpf_ops_handle_oom(bpf_oom_ops, st_link, oc);
> +               if (ret && oc->bpf_memory_freed)
> +                       break;
> +               ret =3D 0;
> +       }
> +
> +       rcu_read_unlock_trace();
> +
> +       return ret && oc->bpf_memory_freed;

If bpf claims to have freed memory but didn't actually do so, that
seems like something potentially worth alerting to. Perhaps something
to add to the oom header output?

