Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D92DACD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 02:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321166B0088; Sun, 10 May 2026 22:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F85C6B008A; Sun, 10 May 2026 22:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235826B008C; Sun, 10 May 2026 22:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16B4C6B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 22:46:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C12316057B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:46:44 +0000 (UTC)
X-FDA: 84753601128.07.6D57E6E
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9ACEF1C0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:46:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FNkuj+7R;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778467602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gOruJiwgPqsph3RYrW3+oyh0RZhj3ctmBB/K502L17o=;
	b=eShqwPmON+P5HEd00p0SYuwECx7qn+2/kjUIIqu05lSfXfI/kPxVeFwUCrYB5ERUkD2yzj
	G1quIT+kUvFe41ZFGpOkGVp9PXKiniRLkzWniJy5Vrch0xAYKsikph8uq120v+bXrS847o
	p6O7U2YScEPN2ypYvN+Fs6dzAQuEb+4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778467602; a=rsa-sha256;
	cv=pass;
	b=5es7bKn11SRJeHFFHkDB4NmzdvO38c8IJ6ygHprl2ivVqj1xzdJ9jVuaNJyNXAMmVkHu89
	89deTHZoovWipkK88wmlMcFfKoCtSXOab0VWfNLVXVSU1pDaPqj93syZMcmjIT13/1CLwN
	J+1brU6bbJQIrp0hsmxaXCHoBDTlzAU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FNkuj+7R;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-40427db1300so2939243fac.0
        for <linux-mm@kvack.org>; Sun, 10 May 2026 19:46:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778467601; cv=none;
        d=google.com; s=arc-20240605;
        b=NmjVhyGJcZz9mDAPjlwlZ0CmbGBqZqNZWjWwRd+cR0O4nCkwPsWTx1kcP7TeDiVWrT
         Vx3LJ32ZjGe6G+Jnshn87ZaXckX+PSnIA1yd6ayaLJGpPB2J1TOpGEUeWDoM21W4LKHo
         YvqAlBoKRZkl5OD5qYfBiQYx/77POwK1+JNHud9GV+5yXjZmfJ9VaPns+tODJe0fjUKF
         W1sCq29k3dxYatfbORXJQ7WyZwSyQ8klpP02Izg0NiA3DlE4y/Yyn+XlPtJ5Gtfc186p
         NabCMofX86e2Ga+brG8XB7UQHmJvd07PypxyCkHJDOgpEGDnZe3QJOrXP2Twz/TqKI+/
         Xh0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gOruJiwgPqsph3RYrW3+oyh0RZhj3ctmBB/K502L17o=;
        fh=3XCmak8bvtTBwz1iQeMqjO5NyaXlLaBLiZ6jnOS2NcE=;
        b=E+EpPhtFlYTW6L1NNgpBbg4jSyUl359EYV6J9tU5Dsr70oD1ziH5Izwy0+Cw5qpvQh
         2GQEQ0VhH97R/yWCwmzD2uWXBHNOq+BR0xvh62Hiyxp6w3Q0P8owU4pcoCE/vq1WiJFQ
         FwMDcZ4W0pXmDPMYyE6Va5j5WQURnaIT8Z11YEbjH9yevICD0R0iZAcfujTfjwJhuGc8
         qUs9khiPQnpCD9Jo4grFLpGgLKPtODS65N8xQdLwYK1zQMNAvovnGQB7Anlm34dIP1BK
         3KAkb/uuBDIjYVCYmCf9V5lRdVLXGoyLaLTnoZI4Ulzlyub1dFCE4E8gfRFJYOWIo3gZ
         LeJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778467601; x=1779072401; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gOruJiwgPqsph3RYrW3+oyh0RZhj3ctmBB/K502L17o=;
        b=FNkuj+7Rm/cKb/c0q6xl/6PFxomKgT2hgR8MlCNMOdLLIKBnxqIWpe2PHc+4HVr1e/
         ioURQVDAk7Uyi7JJEvDwJGRpNza3tX4NhQBn7tHXA6eKg2YkIlgF3yRgiuDB2z12Jdp6
         EuJHvzscL5IdjIgm2vKhPO1qQsaInNnaiymJgzTuSS+UlVYEaaJyZEg83bEWy/0AYjhZ
         /WvKILeX51B1jtsR4W0+TYh4InKzvBosM9pYLRILn/ihOda0bxyZGlkEpwXBQJANTUjP
         PFHyhT9s6nhpNVFhOJAj/4Ug3K14QgmpdPoBRaHngDMp/D5UzUayWibLnltiFY7tJZt3
         6vrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778467601; x=1779072401;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gOruJiwgPqsph3RYrW3+oyh0RZhj3ctmBB/K502L17o=;
        b=Ids25VTdip9fl3yMHyWEPotfSnYFPcAYdRs3qe2c9ufw2TcCp5+doZHpQ7IWPayuXC
         Eenh05SI24tJ/pKdrOn0vImXif8v6N10tFh3MU2mQbREUwAsoFTFvEExtuSR1pF+pCzH
         5gwDQ5XSbgNC6NDsEQi24AS9TPVz6soTAuYpOhHanyHj/G5K5OSaeAn6KTpOTAHSrlb5
         f0O8aDDFOEuTRI6DYTe0pdgNb0vDwtOox4+80iFQGMwp1qJECcWbDSzQ0BOfSrlvuWsH
         W0aAu1hD7eqKxftOQC/VU1To5Du0BijUSs4GrpYaZxIG5+1gLFy0+voldiurw0SIGtsJ
         /E/Q==
X-Forwarded-Encrypted: i=1; AFNElJ/8nxyTfx/AQ/6vAS5C7fEdbyqYAWulaaWuk3N0qs/+57Cp+7WQXM0GskQVKSZ53BR9ccFvIH0GNA==@kvack.org
X-Gm-Message-State: AOJu0YyJiOYWgOSq55jSs2KzEXG0fqiYn0lRP5e11DaxJfb8vOQVpiRv
	hARVlT/3cpQCElHP31+3FlQEXKn8jDhCSqjwTrx82VGaeYBldgT8oCYIoaW4PCMkFAhTpH2uipM
	VqM+3JvmoebKWwK0gfgG74FqC6hnf3bE=
X-Gm-Gg: Acq92OFdLLqa1CyN5Fug4nO8lSUV3kuzKFkM1U/mkI+hTid67EOFydvgCNNAd5tYJD/
	yP5ODZLbQtDNV/ZMi1kVRd56AmqKVMKSjC3l+Za+i/jGNOzh67HH91PNSv2VYESmPSsMBD2fEdI
	2dB5ovRSmmuiwdXMDdMbHlVpXtCf0BR62sfV4johd+HRYo0Cgbzx+jQ8O6c8m6D3OO5oayxb3lC
	+Ujw98b97u7MCIvNXAjVz/fhKrdbqeppEfZ0d+X1Rhfq3RQnr8GcHn7Sr3Kl1CJHrw+IoBjq01J
	V1wsAtKhC4VRKYml3E+OYJXKBdiQTG5mZtpx1A==
X-Received: by 2002:a05:6870:d394:b0:423:a076:9034 with SMTP id
 586e51a60fabf-435889126a0mr4351359fac.5.1778467601624; Sun, 10 May 2026
 19:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260510183700.102475-1-devnexen@gmail.com> <874e88a3-414c-4e9f-8bbb-5184fb8516e8@linux.dev>
In-Reply-To: <874e88a3-414c-4e9f-8bbb-5184fb8516e8@linux.dev>
From: David CARLIER <devnexen@gmail.com>
Date: Mon, 11 May 2026 03:46:30 +0100
X-Gm-Features: AVHnY4K1w0XP42QOAjIQsssxdKNQ6OKLDdkQv3F0dCD11V1cbc808Whf9y1o2lg
Message-ID: <CA+XhMqxHxQgMK29FjYL3xoKhZLjG+bBKy2PorVnAEjZTCRH14w@mail.gmail.com>
Subject: Re: [PATCH] mm/shrinker: avoid out-of-bounds read in set_shrinker_bit()
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 9ACEF1C0004
X-Rspamd-Server: rspam04
X-Stat-Signature: 39eqtft3eixiwaigm5ngs65g56z1n6hn
X-HE-Tag: 1778467602-587554
X-HE-Meta: U2FsdGVkX1+59+GKz0pldgBWgS01zvRV5rETCrCAVnzcxApOf7OmoNFCNleCnGf3LzoJU5ANAUefiUsnfLORktGe0rTEaHPEEpCW2mtDiWhi2Io6Hfe/TiJ73DUOW6Si9o+kliQ9aX15C8MC63j5QxRWVb/0MguHWuksTYj+bXOobxx4RaI9lWRFeQG0t/WmM6ivcZKX3eO3U+LTdVdLjytXYViEIbrP+GjoGwzunamtw60x1G5LxwbNymoGxTsxf8txenJlUHjWMM4Z1MzPWKjn+2dGqk2gv2rTT/Kgjzsw8s1x1M7QZCEnHE195JWy+z2DZ10ya69Cl9sVSwed8jN5NLQv3cw2vxOErkma7J4t4g/0PI6gJyH+4IEUKyvquFq6lacl/2jGJJwHRibDkP6sHu5PT1AZWKyhE4NKV0wj6+ktL1upfvtyxXWiV0eYQ9/e3c4LNv3KpJOnNpyL0fWWjUfX8X0ykuGAE86BxHuOyxF8DBEBfSqdUaeG+JBN6+VdtJyU9Tl1DboxjjtXNyHXKuj0wmS44xtv9HugjN98gX82E03Njr7cjJBeundrTFakpMQPF9XhVkCnUFGc6SH5cneVMMWoArEVbjIdDAvHTQd/qnUP0OPoNoHEvxw++jrysf+kiaEGSjynH3GDMmFWH+1P9OkZKXRoFPKzVe2QuyV3pvaJ1S+doP/wAhzzESS6+XUglVMfZWpUYrfyB2VTGhOgPn2j/XqZJQVi8zSUonHeiy2ly3+pxAwmBt0hQB8vdnz2zTbwJ/AhsUXTQT+RJHo96hZdidV6HhB8UvAnsW9WPufdbBHGM67kqn7GMW4FiZ/+7fgIO8IeWrTctecBDL50Sh6FkNy/MUyqP9oPPp4wGnsfPHLNjuJtFLcIPT9lB9rmay4lEydPJODwvVvEN/Y+KwAgxg7AC6SlQ9niOkqd/y8KSi4yRrNhy7ZuMDaVMVyPi/rMVqvKGR/
 rT0G6c2H
 DChwDYumRbQyzvkYi5iiiAkLkCwi3ObNYO5rTu+H18033ltHd2QViG24qwRv+FWBUskQ9fCfWZTBJq+2Pk4GRYmqzM69neVOIG27LdWZIkBtqh5miMKjYK92m5vzL9ohm05dnhMsqbo+txVyt14oUc9d46yuAoQY9FFbLaFXN6chVJ5OHTMmFJOv2hFDX/p4pvlUHg6Xpj9jzXoH4QKhmWgOT9mViKbB7q6c99/U4HOIgLP2TDamhK+sD0yxFJEV7hnKjUF9u55to9Mo8D2sB6b9nG8RelIjfFzybMIyQk1QkI/jpPEzCmsfkyIZw1RpsdUe9yST/IJnbBFqDs9zgSGwIPipTWQxzxy44zsrF7eeuCitLAM3O8KaR6VkyRdmiDL+K4bV2knhG2b/WGb2/rY6HqsnW8VexdqyAoO5k3dQ5cvx99iqxCsqiZoTsRTYJe437O6EiosgyPgnz12MFIfA1eX6MOnAf09LIkA/SX2LfGSyBYfjBiqdzTFPlTKzPHEQeQnk4c6ZzunYNnpDgvI3nPu8HbP02zbl7DLioAoCAmv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

On Mon, 11 May 2026 at 03:45, Qi Zheng <qi.zheng@linux.dev> wrote:
>
> Hi David,
>
> On 5/11/26 2:37 AM, David Carlier wrote:
> > set_shrinker_bit() reads info->unit[shrinker_id_to_index(shrinker_id)]
> > before checking shrinker_id against info->map_nr_max, so an id past the
> > currently visible map_nr_max reads past the unit[] array before the
> > WARN_ON_ONCE() catches it.
>
> Did you run into this problem in practice, of just find it via code
> inspection? It's virtually impossible to happened, which is why
> WARN_ON_ONCE() was added to catch it.

Definitely code inspection.

>
> >
> > Move the load into the bounded branch.
> >
> > Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
> > Signed-off-by: David Carlier <devnexen@gmail.com>
> > ---
> >   mm/shrinker.c | 5 +++--
> >   1 file changed, 3 insertions(+), 2 deletions(-)
>
> Anyway, It LGTM, so:
>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
>
> Thanks,
> Qi

Thanks !
>
> >
> > diff --git a/mm/shrinker.c b/mm/shrinker.c
> > index 76b3f750cf65..49256f81199f 100644
> > --- a/mm/shrinker.c
> > +++ b/mm/shrinker.c
> > @@ -197,12 +197,13 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
> >   {
> >       if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
> >               struct shrinker_info *info;
> > -             struct shrinker_info_unit *unit;
> >
> >               rcu_read_lock();
> >               info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
> > -             unit = info->unit[shrinker_id_to_index(shrinker_id)];
> >               if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
> > +                     struct shrinker_info_unit *unit;
> > +
> > +                     unit = info->unit[shrinker_id_to_index(shrinker_id)];
> >                       /* Pairs with smp mb in shrink_slab() */
> >                       smp_mb__before_atomic();
> >                       set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
>

