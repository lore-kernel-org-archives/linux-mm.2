Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F05FCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5E66B0491; Mon,  1 Jun 2026 13:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B866E6B0493; Mon,  1 Jun 2026 13:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A759A6B0494; Mon,  1 Jun 2026 13:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91D336B0491
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:51:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57CCF162714
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:51:09 +0000 (UTC)
X-FDA: 84832085058.07.3CDC490
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4EFC540010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:51:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nGjQVpHF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780336267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1oyN2GHO/W1PVNw6MHzzvIqAiryGCw8vjjyfHSwiSxY=;
	b=xshK4DhEOBrAROJGCXMUzlJOj3f/oLg5j+DOxOE0leTOqsb25HUYg7Z9IS7U6Su38oHEK5
	chWdELSzgVqvkmFVgKLgXfWNz4Wx1VlILxBXrCwt8pEI3m/KmHzzDGDzvlVaB5WHpmjrj9
	9RlyrCDvN1IcI4m1QZjdTQ6ce//xot4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nGjQVpHF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780336267;
	b=PbkkvhGJZDvwS4xDRyX5VklBAYo4EaVAmdnAJBy+IkHQwUBdgq3RMR84rB0ZdevqKV42k6
	nHBZjDq/gdY+zATsbjfk+8ZXQ/Sanb/0cxsKa0mycyk1AbA0ZW0cBLcLsqY769Zo1l3c0o
	Bj2s39A71qi2wngQoQx6tyGGVZa8++0=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-68acf0a15b3so6994361a12.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 10:51:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780336266; cv=none;
        d=google.com; s=arc-20240605;
        b=X79t2TwKHfQBI5i79feKQOgU22G872ag57T4Nbkdc5oeW5gWUUhUAF4MNgrstLkx58
         UITNeuVW6OrtyDVmlKZYMOeik0Iqe5ISIfn83zVkxmdsRCuEwVe8Kf6f7EFhMhgbf2F0
         VaWLxgLh8iuVbonDmMfqwKbruLCL8d37ceY9Rf2DEcCMASG0dxF9xITfq3g4KEijx+g1
         baLV0n43K7amds29YUXE9smK8VTe+8g7L8YVsa1noxhxCPLBkCzhFAIylu/1OPqqRZS9
         eJ+PhOLAjCGIaPzb4T414Zjs/9sXUbQ+gQzqmRaaVxS9aPgizjc/j2obeX9JSt2ixDL8
         Kh0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1oyN2GHO/W1PVNw6MHzzvIqAiryGCw8vjjyfHSwiSxY=;
        fh=tXTvh6XTyMwqDW+uyg2hNuHFR0rqaf4jQ7kEtBjCUUY=;
        b=f33XKm+K1YcGkp3CVP52RevhD/TsOClAuwjheqD7gz+ar152x8ciC49jNjYf8w655g
         pPhWuk4ER+3J4xZtDyOdDru3WKfxd78IJC1uYHrl0YmXyYrTYXBZ3sqLd1/qfURkXgdr
         NUHuzTWI2QVQyRzzErhPk/uB0RS7gXgsuX2M2j59qwN7Cx7rtbrlHMDBG5PQcDg42DFO
         dunKDM793gtIQQ8B24BJOMsEMXYK0H09fc56vU+JynWWgoGQTi+nEVAyLbgJuTuRFBps
         ppAzAZgo3+EOgdjo8nmDVX949CYsGCmedB7WI4vepl1GSPhvSN5/w03gk0800Qq2cqD2
         b2IQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780336266; x=1780941066; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1oyN2GHO/W1PVNw6MHzzvIqAiryGCw8vjjyfHSwiSxY=;
        b=nGjQVpHFQImMKdfrs7mnOCSJfazXPngvQCbJG+1mzUFDVTsCYXO9VAwaOBDlNtE5Bi
         yKi1OoQbWHhWDwfMqsZEIzEFgYzr2Q8ZsEoes95c7pPm7i9KXnQdMKFca9P4cQ1+32wd
         TOIf+jWPewzbP/2FxreqhVQXP+tUyfjgqrKtcSWwUwSKZxkjKiZaxC9fWm97m/cK2T4/
         CWRLLvU5X0x1unXxcUzdujBYjCihvofho0hs4Lo2n97d/KrqsK5VxlOkncnUbiZAFCEU
         JYXAVlZThTPOdYcfji7hdnXFjHdEQAhKGMbFgIgAFKWJwZosmS7zI7D2crfiqvmuMOYi
         lOyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780336266; x=1780941066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1oyN2GHO/W1PVNw6MHzzvIqAiryGCw8vjjyfHSwiSxY=;
        b=NGO6EFd5Zr9f0F70V87x3TZGjj0sJPmnrzMAQI5tOh+9Z6r9Z2AfOYEj+jGs+Hwk4Q
         uju5XCCoiTcpmTurR9+Vs4UZ/8FvEXUzEzAg9CuDinfZ3irHK9Q3RarRAONW4kpG9t5C
         sEbzsjg9+1JVtmQITAONBCq3HrC9Q/L9499Ti0eq6A3Rf4babRRF4Vyx3Vis+DaRZWUh
         98Upi0hJJLlJh2mu54caCcKZngfPnqonwpfvaiAKbThwMlXGn5dAr+m7V4xXyMExHl73
         HyR6Al10RLd7PiEv8gNuaGH9JfPSx7uztLbhqoqDr07jcL9u2wHI+1QWdEB6Wkjw6a6A
         UEEw==
X-Forwarded-Encrypted: i=1; AFNElJ9ZHZszGJ1MttmxhmLeRkUrpHg6+L+b4mMKxDHdjG6FkGNRzcfa2PFjwA6QwpdqCBJzGawyaBJXbg==@kvack.org
X-Gm-Message-State: AOJu0YzzIyphe4+cRUQZb3tPuFhSr1GVPKTu266IHJMVmdKhnR7vsp4H
	grTt9gBjvLm+dFAQrB966kkOUl/Tjy6ojkFS3b6S6NKiHIA+/au0zvZAvLmdlcVRZ7D3Stf9hLl
	AkPLpaNy3LApmgYHA04ez9LggUyPW7+Q=
X-Gm-Gg: Acq92OEK88UvCW1ZP1amv5k6qHAka+hKFwOXZ4JL276PIg+Map29k2pJwWwgRdZ/kZO
	g9DhcF0RXWwEtCaYm015VUUauCM1k/BwnjPKzFXAtfrW9iCa16XVgQWN2r+x1Uc2peEeyO4SoMY
	VX/ItdffJzHTMQP02jLQYuFiWIvQ+6jOK7UJJL2dzHyWRTc6Mq8VNyEWOAM+UpXejYmW9J074LW
	7AUXRCew4kZ164Mx/77g7n+ortJ+hR9jfsRArjp3MzJRSbQSkdTTmIRlYsWNXcwX9vvbTRRjHfA
	GvhCES5iTrMx6D6+wlTq7FmnwdIcLaz8dxkGuUTZQPTBa7LhVqo=
X-Received: by 2002:a17:907:3d55:b0:bcb:4046:63ee with SMTP id
 a640c23a62f3a-beab17aaa7fmr558548966b.31.1780336265621; Mon, 01 Jun 2026
 10:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260601161501.1444829-1-shakeel.butt@linux.dev>
In-Reply-To: <20260601161501.1444829-1-shakeel.butt@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 2 Jun 2026 01:50:28 +0800
X-Gm-Features: AVHnY4IV1F6PCCbzzYjlKLYKIUjD5M0VssnH2_2WxHth41_Ifdx4MpgpS8XDWPI
Message-ID: <CAMgjq7CQt+W5jAB1DM=nCRpLOFnCK3FkdKT6O0sznOEGpo6=Zw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/list_lru: drain before clearing xarray entry on reparent
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Dave Chinner <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: mob1hd4i8gwm6sex4czxc59hcxmona5o
X-Rspamd-Queue-Id: 4EFC540010
X-HE-Tag: 1780336267-214354
X-HE-Meta: U2FsdGVkX1/EiOKmjDIBLzHelC4Asv5cXedcF5+Tq8Ur0Qd8OGRtM1P2hiVMsX1xkHQDeAIDFvDzZgQMoMso2hsl6/reo3L2DEW+0fzIkQS9AE83JpUlkMeXi7muopsOxXJQ7Rv8sc7MXSzZOoUy6XmaIu4o80x3cy24raAFt3sRIcQ67JuV15n1V79XB9os/rTzIO9bnSfkJjfjQoEqOgHkYbca8Y+PYItbeyHFmKHvCRLzJtvCz3eW+7laSZ90i66yik9GBFPEWyOseEY9jgaWuFAXtj1DcDLQQBjyhXvPebiBEMmw0sYqCVnIDYxCU0w+oY3oxBudQuFHh0CqRUIC91/ENhuROSvH01BljKLNnB4lT60pO31/OjN9BHrYHIGErklKv74q2IqtmSZEyzxUoSWnmQQfOtnThuhsigLEu+kdW8GGakVZVMKvG2KmjhguG23cQhFl0EJ4p6hIj38kOornNCynbrqV/bTE33pC53wQlgyt5W8rsS6dOIv3ieg1OTXRJcdEfUXO+HZ6LwWAjKt06Q6LaEDDNRAe+t39RtGM3EM2n+0Uai6+I8sl7Y3Ezv4EVBMRlv39fswXBSNbM3mO+UjxGmHhiJdwoJN678gv+2oO8MM7b9cT9hwoVP95ACxaCFWz9X7/BJnOzMDtuzQjETQFpaSdwsNhsw4y0Ajp3133oGzvCaDj9IdmP5m+KAB2oREgoam8sqBetxODQF6mncQgcuGMC4B63MCHNxtTA/wKg2rIZuyrE/MhrQHhzTDvL6PgoVVvlr/jafNOXJKi/SdNoW5Fnha046WTFLk/YgpTNxPYEBtU8KODiAdKUxeziTiJFQVsrVOKAIeSj3HBSLqkk3q4Us7PTitB80rGiN6rr4tsuTAVE67E9Mq+kw3XJAV+/t2MX4960IYxWQbADA9L2UCkAtv4H48+BZRDtjPJL+rm3R2itTfF9GEgWP+vJHalIor5svD
 75ULIGam
 AmDGGhO5Zi9l9/eeHHet21UFiHV5HwlVmd5plQrTo6oBhL+zmwMrehzo3VwV1+xaiVkaKMNV89ex1wvPHAgXxLkekjDB9oQ3ji348HmGKFS25ww1uyReXLQAmMdPIBSSSA+WhQ7BXZ8accVNUxMgg0shAIC6fWP+nZKdKb6LJ5t+AI/HWQUAZgmnAngZ1Qco0NYvdm6VFNPYG9JInc9r+i5RsMX9cOYHJOtEds8B8SPOdamrrpcaz4K8hSIoVWQyJPvGOHvhK1/cc7ZiIhSQDxXVeB0RoyitddC7h5UACbjc3krzoiUevF8rgneulgfvddkXVzpwEZuUJDv8xYeYef3yVcjWPQyo6Rr0Ek9UKIVGnQ80lic4qya1vBTHrHX8JmS49iex8akCZQHVDIRVcqDNEBgFdVizGHhYq7X5NZETLnqiHW2JmzBt9cihjDDDsNg6cZjgmUN6EqfOp9lARc9r4SxNMlsikoMy8J2ZrBUjco058RdHyyRjx/h4Rd9urX4BRF0d+Veo8mLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 12:28=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> memcg_reparent_list_lrus() clears the dying memcg's xarray entry with
> xas_store(&xas, NULL) before reparenting its per-node lists into the
> parent. This opens a window where a concurrent list_lru_del() arriving
> for the dying memcg sees xa_load() =3D=3D NULL, walks to the parent in
> lock_list_lru_of_memcg(), takes the parent's per-node lock, and calls
> list_del_init() on an item still physically linked on the dying
> memcg's list.
>
> If another in-flight thread holds the dying memcg's per-node lock at
> the same moment (another list_lru_del, or a list_lru_walk_one running
> an isolate callback), both threads modify ->next/->prev pointers on the
> same physical list under different locks. Adjacent items can corrupt
> each other's links.
>
> Fix it by reversing the order: reparent each per-node list and mark the
> child's list lru dead and then clear the xarray entry. Any concurrent
> list_lru op that finds the still-set xarray entry either takes the dying
> memcg's per-node lock (synchronizing with the drain) or sees LONG_MIN
> and walks to the parent, where the items now live.
>
> Fixes: fb56fdf8b9a2 ("mm/list_lru: split the lock to per-cgroup scope")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reported-by: Chris Mason <clm@fb.com>
> Cc: stable@vger.kernel.org
> ---
> Changes since v1:
> - Use xa_erase_irq() instead of xa_erase() (Sashiko & Claude).
> - Added comment on CSS_DYING check in memcg_list_lru_alloc avoiding a new=
 mlru
>   allocation.
>
>  mm/list_lru.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index dd29bcf8eb5f..d454bce9a78e 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -473,26 +473,29 @@ void memcg_reparent_list_lrus(struct mem_cgroup *me=
mcg, struct mem_cgroup *paren
>         mutex_lock(&list_lrus_mutex);
>         list_for_each_entry(lru, &memcg_list_lrus, list) {
>                 struct list_lru_memcg *mlru;
> -               XA_STATE(xas, &lru->xa, memcg->kmemcg_id);
>
>                 /*
> -                * Lock the Xarray to ensure no on going list_lru_memcg
> -                * allocation and further allocation will see css_is_dyin=
g().
> +                * css_is_dying() check in memcg_list_lru_alloc() avoids
> +                * allocating a new mlru since CSS_DYING is already set f=
or this
> +                * memcg a rcu grace period ago.
>                  */
> -               xas_lock_irq(&xas);
> -               mlru =3D xas_store(&xas, NULL);
> -               xas_unlock_irq(&xas);
> +               mlru =3D xa_load(&lru->xa, memcg->kmemcg_id);
>                 if (!mlru)
>                         continue;
>
>                 /*
> -                * With Xarray value set to NULL, holding the lru lock be=
low
> -                * prevents list_lru_{add,del,isolate} from touching the =
lru,
> -                * safe to reparent.
> +                * Reparent each per-node list and mark the child dead
> +                * (LONG_MIN) before clearing xarray entry otherwise a
> +                * concurrent list_lru_del() may corrupt the list if it a=
rrives
> +                * after xarray clear but before reparenting as
> +                * lock_list_lru_of_memcg will acquire parent's lock whil=
e the
> +                * item is still on child's list.
>                  */
>                 for_each_node(i)
>                         memcg_reparent_list_lru_one(lru, i, &mlru->node[i=
], parent);
>
> +               xa_erase_irq(&lru->xa, memcg->kmemcg_id);
> +
>                 /*
>                  * Here all list_lrus corresponding to the cgroup are gua=
ranteed
>                  * to remain empty, we can safely free this lru, any furt=
her
> --
> 2.53.0-Meta
>
>

Nice catch! Thanks a lot!

Reviewed-by: Kairui Song <kasong@tencent.com>

