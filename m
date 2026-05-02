Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09A55CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 06:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D2D6B0005; Sat,  2 May 2026 02:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E006B008A; Sat,  2 May 2026 02:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51CEB6B008C; Sat,  2 May 2026 02:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40D246B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 02:56:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D073B1C0B0F
	for <linux-mm@kvack.org>; Sat,  2 May 2026 06:56:44 +0000 (UTC)
X-FDA: 84721571928.22.D2AD567
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id B854140003
	for <linux-mm@kvack.org>; Sat,  2 May 2026 06:56:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MqS05ezk;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777705002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqsOmE4q8CYbuftk/Yrt3ftCgKR4ea3DM+2qgJR1yfw=;
	b=TCyraW//e26fEncmXKx8Sqc7CgmALrDsBtKhxO1iSviYQ9WgiYr7M2NQ5eBfdBdZjsxV17
	Cx+E2api6YgEEFDy+b9lqanT0ptCXuXorcdVyU3g8OpTVqtVIisXmaOXUekQArd/E9acCg
	eDAVyredOE/3dU+TGCbqEXjMyUGB8EY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777705002; a=rsa-sha256;
	cv=pass;
	b=zFr8zbs07cfwC1qGonbWPbTd1tyuGEucn0XYaYdLlgcZiHVu53gpOCvTtr4n6Y920hkXhF
	fS1cmWWaRYRQa0haxhynzG14F65w8ywcXk0qmCaN7djC9QNbybN8UQPgVYL4wWle5eXefG
	K5sZqe7sUjs/Tdqfsq8OS/L/arEK2eM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MqS05ezk;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-448528f4e69so1441633f8f.3
        for <linux-mm@kvack.org>; Fri, 01 May 2026 23:56:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777705001; cv=none;
        d=google.com; s=arc-20240605;
        b=FZ4y2JsnPl/n/rq3SoZgq0D4Gde+QCbQC7aIzSCLe/GL9kpqpWjY2ht8o5ajP5otPb
         smgFMPqyLym9KQ8ym08ADiCAb9ZalYZKhEpHMy1sR2yj36haIU+u1UaJoMlIVoSyfgHP
         D4mpHoWy26nR8MHJSf1xPfmGJWlPmn8W2gNWmyWAht0U2G3Ko4bhWY43U8/o4TsMJvX+
         sOIPvghvpVIDgjvlN0ue1JYY7z7h/MUSG0kKCja9AQ53v2FCIPVeQaudlecmp49Ah9p8
         WPNFhzKZ44sPVESYFlklBVC1eL+ljBLmQQS3tmUm2Okb8eoubtLMh925wX9JYn1dm4Yb
         /KaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rqsOmE4q8CYbuftk/Yrt3ftCgKR4ea3DM+2qgJR1yfw=;
        fh=nrR7qGY8kTADzcJjA8r7DnUagcXJ213DUYo3RXAQoLU=;
        b=GA86OPDv11FHhu5tvl47n9dfB2l02R9aNJCJ6gvpYLXtujG3YuA3EeEeLBr/8KHZaQ
         iDzjZy4l84gVO3mwvZIjIMwjIMCkxvnzLEBd5uUPBRdyOnuXABPWfVeyQZ8wJvBjcJGh
         7YkUup37/W9PBe9a4isMD2dUfrvbGeKy3XHwbu1kI8OmsXFeYY+PdttFpIKewo8BjodW
         CFBg1qkuwiUoba/3DLWelP/klNo3xldXOAf4hxQcgIl5W+BnMwBrxHL5eCn5CrH0/IbJ
         4b3ciWg+iGOmEjdxuL7FIKUge8PeUfDoEXz3IZoneCGVpyfS+LNymFaReX/s27jBvrHB
         hlcA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777705001; x=1778309801; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqsOmE4q8CYbuftk/Yrt3ftCgKR4ea3DM+2qgJR1yfw=;
        b=MqS05ezka4c5g98wFXtBrVgEDmgijU78eReNAntVuCQr9FgOnCBc7EI9DvN3WnjVjX
         WAhrP8XqhhKXNN71NZefhuR+VN5zbMXl+aCFgm/DIE9vMu9UMZVjRXUV0K4l3ek8awUY
         eOCVpsMZwuqmurKjhlwEqWc6xNWtCB86FoLN0RhHAW2i3+OqQy413ZwbDjLwcDpQXrLR
         OM36VKKAlj660/Jyz6o6c+lbYo/+Jpwm9wxqnAMlMuVGSvpHxqnj5GN2Vr8/1D3lskB2
         BKwO3K4+1jTItdkAH1ZJtVFEVQcgiK2THKwRdbWGhFqm4yjcOufKu683IM/74zV9NPXA
         /m0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777705001; x=1778309801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rqsOmE4q8CYbuftk/Yrt3ftCgKR4ea3DM+2qgJR1yfw=;
        b=IGJypi4Iy+2HvT3vn63ElSrVTw0NBzve6ONelkGX/STQBaIEESp34zSOBA4Yv7EuxE
         s4Zs+mrMgBO6h+mk+7fWlHji4rD7z57TRvyaW0WULGhhXzzajg76rneSqFp2k45b9Jk0
         Dfq91y0XAGRtvbKXpBLN3HfzQqCExGHGr9GyqpT8ucQYxROSOE0rKah+zd2Twl1kxO1Q
         YG0qa1UGFZWmedTv6ljsVsjzRvMBGIS4eekpoIYQvL/+SxTaJPt2t08HFShkA3jIM5Du
         pHp/NK6g8+mI2ODddlOGFt5tDw16/DsMCIWJ75TTCdoFtpEpaW0W9gvxQ+tCE5NwyFVO
         /asQ==
X-Forwarded-Encrypted: i=1; AFNElJ+99MYNZE/zcbsGuXKog3oqmS+6frv0R2S9rIC5gFFPJPgwSRljgkkjKYHWEzleyg5OJCRoXPQofQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6wsAc+5E1quMCmzVsNp9OhwC2HQzKBdCUsT9bhXOnr8BkZXJ4
	fZ0chMytdjlGI0pAvaUB7DrAtYgtM2dr/TGAEBVxtbTqUBQkE/0bj0EzYyDgtjnWIs5GcB9RcZy
	rrWO/N1dwljtX37Zs7CZJ2qXZrwKKkjM=
X-Gm-Gg: AeBDievuqeVyrH8Ocfbham/sW5ddLOYBiRDU6u/Av1wwDUdVspraPTlxDs35zaxpGsh
	jA3RV+GIm8zEUFcy6phUrD5LXMGv6IC3WRAse736dXT3S8sGpUly0kZkvZj0Y45YDW3rF9kwsGi
	USHVwf+z4ZvCC9O9r3WxEQSHjVGsBq/TUATp/KeCJIi4fn/Fuks9P2OPWrvgWB6u6Ihi5nJ3GZP
	6NHehW6cq4Ph06TNYH8fwecvB1hiXtS1TvPiBqSlqo3eKjyBa5m9d5QVFxyJ6+jBXpdPw62EgFM
	5xafh7xXtArLnitqVyCkqnbvm7LD9zhU2TacgA1ZG76wEgLcR9nD2LMcS2VBP/MdsLnMAxAjx8G
	b1H4=
X-Received: by 2002:a05:6000:288b:b0:43d:7a97:78b5 with SMTP id
 ffacd0b85a97d-44bb5e2deb9mr3228296f8f.33.1777705000845; Fri, 01 May 2026
 23:56:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAGdYFN3uXA6gqW0yrsCcfx2pY5An0V1PQm1YBL5Zt63RaEAy8g@mail.gmail.com>
 <2026050112-gumming-overcrowd-a945@gregkh> <CAGdYFN1Z9xtOk_VP6OsZ8mcpsw5pZEk0VB_CrtKDk-AxhcuYKg@mail.gmail.com>
 <2026050112-hatchery-tidbit-3420@gregkh> <CAGdYFN0BdcM_QpsCh4YVD7S=7MeG+AgM63ZuUfaZS2gSUYHqPA@mail.gmail.com>
In-Reply-To: <CAGdYFN0BdcM_QpsCh4YVD7S=7MeG+AgM63ZuUfaZS2gSUYHqPA@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sat, 2 May 2026 07:56:30 +0100
X-Gm-Features: AVHnY4KSX28W869pxdI4xCchakONyBbQW6sC1tDOJIXccsy8bw92w-d7h5NXG-I
Message-ID: <CAADnVQ+M2AGCNU3f=1XA_bG=_KUUZTjZmpu5sVy70Bi0H_=BWA@mail.gmail.com>
Subject: Re: [PATCH] mm/bpf_memcontrol.c: fix refcount underflow in bpf_get_root_mem_cgroup
To: =?UTF-8?Q?Caner_=C3=96ZDERE?= <cnrzdr.dev@gmail.com>
Cc: Security Officers <security@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B854140003
X-Rspam-User: 
X-Stat-Signature: yzje9g6skmmodhbufk4emqkwn9dbxozu
X-HE-Tag: 1777705002-188807
X-HE-Meta: U2FsdGVkX18xsXTQ8zgiSA5h/GWhMshj5jXav7zkjCqCQEFhOqeAN75zT/HjQS61FrVHigyqoi+UonY+enZ3FFhT1jRJVDkMBVcN9Brwco5zRtX/a5TnX0CVuRh7mItiuuLl0b2QL1pGQoJLTf2+RNNE4HhKqeWeH6dxa4E+DdnYSNzS93JgW2MQY3WIYQFIVSDLZ5MaUmGOJqjeFDPjcga+vuKXuonjcvZP3RIG1MUTYcSx1mADyi4ov269E4sqva5YSOd+iYhnIfvu/lCauCl9/dbqk4gyaKKajjq6w828U89LlLhw8Z/HdM3kzf4pk8IRYnDKSOdkJGMFaZmf99DwthL/gC6YbBZIUJjK885sewxThoEi38gsioPzgPAEZ99tcOdpjslI/gwLsCnnHmL28K9eC0HfOVsc1m7f7zhCjnAORNKzK+Eylf+n3U6fb2GFvTqJhscQWpvUkhxbOnkJ0C3FM9lZscD65tVVfZHOnZVrQFIJuFcMvlLpBHWfAqRFDnJH8XVUGSNvP+Lhgf4A2+T2eSemrAC4GP2GPdGN8gLHVRXO/tyTsC/j5Qv0kCB/VaxskwyzuwBZktURegqFFhNvzUXEh0rLRcrpMeIUe92sObE17e1BVQH7X4r3JeHIjm+992clYid1+ZaRDlaylVS16ysjj9JnsxUUF86hY1k4ltXHQASC76kB50sF7/d6dC9+Zsn/zHndfdK17afhjlQaf4hg3cNLJj7eJ6Dw2PLVvwvyfpxts7XK6EkG3embEpeRHw9Rc1BXnISgEks096ZnGp0UUJCC4WxdyrUhpSji/liV7Z9exMbwwzUZQ10mqBLk7egTFjlIfxo/V9roGiBqK/4dxSRSoo2mt5wVgVSlNZal/svRQlaoS4XaGMb/zthu9hRcDDHtKrG36kkk+NpIz4jCmBGCTrBGW2e5PsD2HEi7WHQaWnKrws8OTW/EAL/sl9DbhM5y6aH
 +cGig6R0
 2aqleGCq0L4/bTynmiYTK2ix8jd/fj72dbyr6qqEv7OjlwIQV4TUJCoGBRSobcxBxtpGLfiLqJsgR7+x+urIjOk9v0hJvzFrXU2CJ2Y6ai/9AMp/mfaFRTKqG68jEbxxzLN5UjrNLplLYO9J+TQD9UgOa++0/79J/sp8XzF2AHA0+CSi8DAQ2G8PR7XMtYbqta80K7MzTw/tbO4lTgEKPEmmEvxm38giPPO3ftIoJNxhXvz9ev2Ij6l/hmhfUAL2S6ambesv9tQmUfmKWTWNtEYq915cJ77tgyZ+Kh6QS0x5iBS80NZOdXsGVMxDYlNE2ERV5RcJVvWA53s/GdAwcgUYN4CaDQvRaBzhfUzaZOnTCRjAeoZMiNwxlPG3g3E1ka99DJMCsc1T2uO2O72CpMZbECsKXo5ObBaKoH/V0M9NevogpzM6byJjRGgmpNItSLysEfOZL5zWT6461Pzr0gi/P5VxGKfHpBUK64WaSopyBVsU2IwIWD0QLp08LqH/MZUzOTVsa5RmhUmk/6mLDJxqWjSqkU6BOaFjRl6RxKUhCHVHuH9WVH2NGe3V/e9zwkofGbOdWNs5qa/PxKqz76KhQnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 1, 2026 at 3:51=E2=80=AFPM Caner =C3=96ZDERE <cnrzdr.dev@gmail.=
com> wrote:
>
> bpf_get_root_mem_cgroup() is registered with the KF_ACQUIRE flag,
> which causes the BPF verifier to enforce a mandatory paired call to
> the KF_RELEASE function bpf_put_mem_cgroup(). The release function
> unconditionally calls css_put().
>
> However, bpf_get_root_mem_cgroup() returns root_mem_cgroup without
> calling css_get(). Every valid BPF program using this kfunc causes a
> net css_put() with no matching css_get(), producing a persistent
> refcount underflow on root_mem_cgroup->css.
>
> A previous attempt to address this removed the KF_ACQUIRE flag
> entirely (commit e463b6de9da1), but that was reverted because losing
> reference tracking semantics negatively impacted usability in practice.
> The correct fix is to acquire a reference in bpf_get_root_mem_cgroup()
> to balance the css_put() in bpf_put_mem_cgroup().
>
> Link: https://lore.kernel.org/bpf/878qdx6yut.fsf@linux.dev/
> Fixes: d0f5d4f8f328 ("bpf: Revert "bpf: drop KF_ACQUIRE flag on BPF kfunc=
 bpf_get_root_mem_cgroup()"")
> Signed-off-by: Caner =C3=96ZDERE <cnrzdr.dev@gmail.com>
> ---
>  mm/bpf_memcontrol.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49..3e8721b 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -25,7 +25,14 @@ __bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup=
(void)
>         if (mem_cgroup_disabled())
>                 return NULL;
>
> -       /* css_get() is not needed */
> +       /*
> +        * BPF verifier enforces a match between this KF_ACQUIRE kfunc
> +        * and bpf_put_mem_cgroup() (KF_RELEASE). Since the release
> +        * function unconditionally calls css_put(), we must acquire a
> +        * reference here to balance it.
> +        */
> +       css_get(&root_mem_cgroup->css);
> +
>         return root_mem_cgroup;

Please ask whatever agent you used to produce
this patch whether this change is actually needed.

And do the same in the future for all other patches too.

Really folks please learn the basics of agent hygiene.
It's not ok to spam the lists with AI slop.

pw-bot: cr

