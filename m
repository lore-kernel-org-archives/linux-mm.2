Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7426CEB26F5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 18:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89276B0089; Tue, 10 Feb 2026 13:00:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49E16B008A; Tue, 10 Feb 2026 13:00:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35926B008C; Tue, 10 Feb 2026 13:00:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF3A66B0089
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:00:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52049C26B6
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:00:32 +0000 (UTC)
X-FDA: 84429311904.01.EE93B8B
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id EF4B7180020
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:00:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RM4GDJUC;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770746430; a=rsa-sha256;
	cv=pass;
	b=w/4bP9O/OkjKWaxxqpJZ8rOaiWs0RZcTMj+CQTrNymMXUmYAu5spz+oLqZKoFA5kNzhg+C
	5zh+aPcR2AjtTWczO2LQpdaAC+AbEmu44QLqwLvx95Bwrw+dnezrHKGlP215ZmOJ1mkTEi
	6dLWCmSvO39chFzIg5jAb7tsBB9UXjw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RM4GDJUC;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770746430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hdRTnu01EfTLlWfa93ik5AfgskXe+NnblBS+DARaXSc=;
	b=we0Gsm3ktBaGfra95HZJNPdfGgK6TlM+0ibfVWOQ+VFdBv2hui7r9gjhKKxfkm+WRxb8k6
	uKduNljNO7oHj/X1Rj7GjBMl9TIUEqdDh18VoV1rrkHVCj/h6glij2LWWNkeH8m7iD9PGS
	KgTxbW9Jlaaq15BqIcL2Z6x+HLkZfzM=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43770c94dfaso1202090f8f.2
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:00:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770746428; cv=none;
        d=google.com; s=arc-20240605;
        b=ZvqOzXsl/5y0e2ys1UJ2GlT3LW++OVM0MTaxjItUZJ4NtIx/n3602+7KSwQ1mdbUlL
         4QAAC6XHbCODN+vxRpBA9wajnt+PogF3caD7RA7ab89jiLcBfoBL6pTmdUH3Xcthjqvi
         2z4LyrG7HYAwLN16KdPqZREuwZn8SQaXyiCwP2aA7vORrgtZqkXKkk7piJimO5LBY35I
         rQ9jp4f2PEAwJdUz9evFO6Dd7VTLqFTYbCZpSeV3A2QsSSnao4XefhcykECdlHfX4a/d
         w3J12TTUT0AgZ5Mdoqi3kNUPgXuVsQ3RmeSwO4TTNu/+0haFUGRmbAp7RQZ/4c+oDPQI
         nUcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hdRTnu01EfTLlWfa93ik5AfgskXe+NnblBS+DARaXSc=;
        fh=Hwz6jraJ2h7qp8xgyY63VaK7cOPpvVaaCimK7buAY0Q=;
        b=ES8GG63DTf+zARFNqSJEmtrOgl+OdxO0J53ceZUw6Y712Jwhy+/gHIXv9OZ56jOcey
         qN+hUh78rvnMJ0t4hoZ9YqFbGiXLLQXXpd6G2QJDmf2ts2GWWvAIAkDpjDXwRK//wWk+
         NaxZ4Kq41N6XZLP4D64Wp2L0grsbgyuFf+7BmOZH0WucjURvij6eL2o0H0fp3z6DOFpD
         XqUVTEFwoXXY/OF7eYiz390Xf3CMRH8gylUN5bAgylcvqBrwKzbU0Fhcfc1SJKgZdrCE
         wkNySM7TmP0fgSuEtbcEkvYG/ELKbVWFSfd4B1T6X2B6J5OwREe0Wbjhbo+ey463KzSl
         AGyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770746428; x=1771351228; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hdRTnu01EfTLlWfa93ik5AfgskXe+NnblBS+DARaXSc=;
        b=RM4GDJUCOQOoONfep4DDhFF1oJkfsDDog8blc898t1fiLymTmIIvnBALONBm7veqgM
         e5B/I5rx+Mw5VD4E3X/uMK07rp7aRdmRymPLVcWU7KHE3ntS+g1nSvKK6S1mY8FqJHlT
         nnAQpvfayHscGVvuN+QGkkE18HCXdsBs7tH8oF+pMOtMKRdsINO0h5JsbSH9q+RM3WJG
         Z3/qv01tWoM0I/+DcU3lx55jxM4soQ/klJLoirp0P3JEL8Ot+WTM1rr6KfTKKu1lnm8B
         hoYssUvV650tLWxTurKgbmiirWP0PjfTv+EVwqcu301j5FRW22rb+wNQbg0WRRox2Uei
         vAgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770746428; x=1771351228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hdRTnu01EfTLlWfa93ik5AfgskXe+NnblBS+DARaXSc=;
        b=gLpV06p+ztNUOeLB0R3dlrmXeHo6LeQrMHuBU1quPZjVTEuWdmSNrwIvibQLXJ0PgU
         oIXNTDv7IwhwSiFUBed3Yii0v5W83dpgsLvr62tWpvzZ4aDChtUHjF2wlklKwCXyzQ4o
         dPMlwgVJC1XXvnydHZeOnZ/1FTRgImVcCyCS8R9dYVyIgx1uaFitM0/LkJRhjZp98lrc
         Li4AmNr+TP5NyhjnnqQrwdOoeVLibjHW39Llc6k1aOCqw7bsOwBCFTgbJK9N17RB4sZc
         kl2mD9690vsIVM6lpIHR56+1Axy52lUIBvCyumaCdfGThF+xvLfZiCEfzcauVcltyCMv
         v7Fg==
X-Forwarded-Encrypted: i=1; AJvYcCVWL/y7lUgnCR2vsSgg5EO6WTQK6HYW8K8ywcLqwZalbLgIQ8152QXgk1C/jDBpuMjnnLDLekQSIQ==@kvack.org
X-Gm-Message-State: AOJu0YwzAGi8GKsdjFIamPcAJBMRkE7XEoFKOb9zX85RbxiCqrt9KnJB
	MFS7Kb+rSU9jucfEtHKO+rWuXzNScOZSqeh+sl2wu19HrGyEmf0OdeIQGsF2jAIPD+I8CDEaniA
	UwRe5OtzgLrYsT+4v+2AFbPaqUe120Kg=
X-Gm-Gg: AZuq6aK3TUqHXw11zoyFg8BxKWIioKnc11MaW+0LUfhIyvFWIzLoJNAb7lCAjUACJ1F
	EDGBE+Hb11owyLba2G+nlaNk5mjDNVHoc0OCL5SNkgzUT5YeKkcuWINFZcC4Yuogv+tQQ8c1SAN
	Cnz4AWSJ5tcJK42ytlDqBLSCJNW9k8Z5wWXEPlBRhdUbsLdEJMFfYW8t5DpglvTSvjLjuXY5BbO
	dzYH1bcU362CPMjN79eLo0gBAaKDtbWwOe9CVASnvNb3OSS8phKjh1RCnLQD8wjjI3K3m6+bG9r
	J+7Ws3L62FpfFZt1/y63qQfd30j9WJiUn6pynLgrU44/ac2EBg==
X-Received: by 2002:a5d:5c84:0:b0:437:75c1:577e with SMTP id
 ffacd0b85a97d-43775c16550mr10674286f8f.11.1770746427427; Tue, 10 Feb 2026
 10:00:27 -0800 (PST)
MIME-Version: 1.0
References: <20260208215839.87595-2-nphamcs@gmail.com> <20260208223143.366416-1-nphamcs@gmail.com>
 <CACePvbXsngZmn0OrJZjvMhhHnL5FazxYX7ShEpbU9RwHSJaUuA@mail.gmail.com>
In-Reply-To: <CACePvbXsngZmn0OrJZjvMhhHnL5FazxYX7ShEpbU9RwHSJaUuA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Feb 2026 10:00:15 -0800
X-Gm-Features: AZwV_QiMW6htW4OFyqSRGIEJjQNZwOYzKwbMsr4VWLpUrYQn5NoISn0POI_HL04
Message-ID: <CAKEwX=N0=ns690uUYs1RBbOJPBBGYBgkQWgLqqdd-82sb1jpsw@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, 
	yosry.ahmed@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, len.brown@intel.com, 
	chengming.zhou@linux.dev, kasong@tencent.com, huang.ying.caritas@gmail.com, 
	ryan.roberts@arm.com, shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk, 
	baohua@kernel.org, bhe@redhat.com, osalvador@suse.de, 
	christophe.leroy@csgroup.eu, pavel@kernel.org, linux-mm@kvack.org, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com, 
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EF4B7180020
X-Stat-Signature: j7c34rusyjzpsxk198qq5k34dtkzxx3i
X-HE-Tag: 1770746429-41612
X-HE-Meta: U2FsdGVkX19MQClT4X1LnCAEEBmcR+EFQ/NtqBgVrhElK0nvqfGUMNLESiQQT79w+RfiKfk28y7b84MprlPVNjav4HjaqrE1BILHOb76zvkQJLNIChjETnAZDA7O4JrL+Qn2hyg1POu/dqB7zf32BjklC3Che48L+1WuslEvrVEcNke6LDtCDfz8WrKHtElF8jCWw4o7U4Li1GM5FCufr2suJW0qx1t+Gu+974yHyuF3cKyWYtjY53zSf693blRrKM1LS9ZKSGqPJff7UlqHhiUOHo49EQn7AkM6VcnJiFMPuWaFQ8vBIpt6dIBDtZOMN/FmH6DNIpSJEViTUFON6fmTRG+L+oN23OYkvpvnkCP/Ln0tIcRGh2FZ0XpbChpSeZs4S1ouag0jMNPwcHysFPDE2Cp6bOQjnFGNLn9aOoF09MO+Ad3ZGO2pDwws++5D8hm/1kPkP6BSFU9ETNCFb1O07uK3WJwGOFrlQKT5vHXtXiINabc1W/BBXObETdMQlO4saafPuSkZjMDtfOGrAHiBSSaG4tZeR73X414pzuhuUfzX/hAWB2vZqbNvZ5J5sIMI8GT8c9dacB5nQWJ9x5NK3tCT3bAsgSWQg1qlioMRfjuBZj2dPOBOJXuuU2k9hNji4BrdjOIndlAA/wWcPZ7JahtSffsQ0HMi7ghZvzBY3kTKP4tQTAImWwdKWwfHwhJoPytDg6Favq8TZ1Zipiu0TkJoV0xwKZiyQ6QxPleDBWIgh8XYsAcb3rtLjuEhCNWi+/s/naiLQ+gACrgZ3Aiz+PhaaXGUwIkGB52jl0Hq2muYULHTHnL+qtu1a8Zp4/gmm+k0Dr0WvjVPnFfT91osuxmtdkEKCad1SJuBIn6XbZAxMUZ7DfhUCC4WXxYiJXwLZWLT9K8PcNCHzevdnDe4o5qg0d+YZtVFjLrVU9UeXMrmbt3yEq2tvdcirA+9jlTM4jfxG/XUvCnhsDx
 y3IL7uHU
 S2Ngv5t7UjVZ9s6yCByRC0QuI0M+/21gRkIhi0rg1UJulACbKrbIlC1CmsSzOv+doOIvrayocyWt9bh7FUZ7y3KuIHWvH9EARax15XjNlO1AR1kz07z1TQX64eH9KhWSpuONJpi4+N3juu91ca6IobSUQiV+YAlGX97Y/HnsMJ4cJXCTqVqiNzXQn3Rav79AX3iumPtEizKLYsUruAHfUhiIhFlNh80tdThh0Sc/Kh0Z2eLATDmk2Kt3p8PUFl2KpgNMgB4GXAQcLzqFopHi51/i4v5GW5YTi9Wf2BKP3bdS/3x3GUtNFz1vVwCCH3o7Avsb1AzX+UlVmkDJ0SiFhyTLM34OuO8c/ZwcsV/kemvZ9SScxLTN9rpK306RtqwPnuGRsbO9QRaYdq55g50rWlCRAbGrWzJJMFoTr07aQuIrfNuxlW9Kmgxg8PocddKANwS5Yh+8c49TWZvtOHFO387p6zSKX+UlyA54aB1tgnWgL894pf9PKn2x8yKLt7H0cfFEjXCvni3JknWb1TJVCEJXHtrEp2je/vKj/WNjxlPKyIM98MiDGt/nuAShwEW71FP8JP1sE1aSq2INMko+rRHA+in93VL2FgcASTyAbMfLz0v6vFsUz31O4mDe2ENdRSkjjV5y0NDM2h8o05aIdU+UAl29s1Lcgmbu9HAoQgHXR8oHiBZHum9qZRSa48Zo0NpiXALssxGnDYvFPCMNsHXIHZ/cIU0nmbArxWoZ/NefbuLGpADibB/j+kkvrVw6PRFlsD2O7twLe3897LE2f7wba7JLUWGpKxt80QSrIxinpjD4J9DNNQvNcjJQKlpBjE7aNwiHOWLLULD0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 4:20=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Sun, Feb 8, 2026 at 4:15=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > My sincerest apologies - it seems like the cover letter (and just the
> > cover letter) fails to be sent out, for some reason. I'm trying to figu=
re
> > out what happened - it works when I send the entire patch series to
> > myself...
> >
> > Anyway, resending this (in-reply-to patch 1 of the series):
>
> For the record I did receive your original V3 cover letter from the
> linux-mm mailing list.

I have no idea what happened to be honest. It did not show up on lore
for a couple of hours, and my coworkers did not receive the cover
letter email initially. I did not receive any error message or logs
either - git send-email returns Success to me, and when I checked on
the web gmail client (since I used a gmail email account), the whole
series is there.

I tried re-sending a couple times, to no avail. Then, in a couple of
hours, all of these attempts showed up.

Anyway, this is my bad - I'll be more patient next time. If it does
not show up for a couple of hours then I'll do some more digging.

>
> > Changelog:
> > * RFC v2 -> v3:
> >     * Implement a cluster-based allocation algorithm for virtual swap
> >       slots, inspired by Kairui Song and Chris Li's implementation, as
> >       well as Johannes Weiner's suggestions. This eliminates the lock
> >           contention issues on the virtual swap layer.
> >     * Re-use swap table for the reverse mapping.
> >     * Remove CONFIG_VIRTUAL_SWAP.
> >     * Reducing the size of the swap descriptor from 48 bytes to 24
>
> Is the per swap slot entry overhead 24 bytes in your implementation?
> The current swap overhead is 3 static +8 dynamic, your 24 dynamic is a
> big jump. You can argue that 8->24 is not a big jump . But it is an
> unnecessary price compared to the alternatives, which is 8 dynamic +
> 4(optional redirect).

It depends in cases - you can check the memory overhead discussion below :)

>
> >       bytes, i.e another 50% reduction in memory overhead from v2.
> >     * Remove swap cache and zswap tree and use the swap descriptor
> >       for this.
> >     * Remove zeromap, and replace the swap_map bytemap with 2 bitmaps
> >       (one for allocated slots, and one for bad slots).
> >     * Rebase on top of 6.19 (7d0a66e4bb9081d75c82ec4957c50034cb0ea449)
>
> My git log shows 7d0a66e4bb9081d75c82ec4957c50034cb0ea449 is tag "v6.18".

Oh yeah I forgot to update that. That was from an old cover letter of
an old version that never got sent out - I'll correct that in future
versions

(if you scroll down to the bottom of the cover letter you should see
the correct base, which should be 6.19).

>
> >         * Update cover letter to include new benchmark results and disc=
ussion
> >           on overhead in various cases.
> > * RFC v1 -> RFC v2:
> >     * Use a single atomic type (swap_refs) for reference counting
> >       purpose. This brings the size of the swap descriptor from 64 B
> >       down to 48 B (25% reduction). Suggested by Yosry Ahmed.
> >     * Zeromap bitmap is removed in the virtual swap implementation.
> >       This saves one bit per phyiscal swapfile slot.
> >     * Rearrange the patches and the code change to make things more
> >       reviewable. Suggested by Johannes Weiner.
> >     * Update the cover letter a bit.
> >
> > This patch series implements the virtual swap space idea, based on Yosr=
y's
> > proposals at LSFMMBPF 2023 (see [1], [2], [3]), as well as valuable
> > inputs from Johannes Weiner. The same idea (with different
> > implementation details) has been floated by Rik van Riel since at least
> > 2011 (see [8]).
> >
> > This patch series is based on 6.19. There are a couple more
> > swap-related changes in the mm-stable branch that I would need to
> > coordinate with, but I would like to send this out as an update, to sho=
w
>
> Ah, you need to mention that in the first line to Andrew. Spell out
> this series is not for Andrew to consume in the MM series. It can't
> any way because it does not apply to mm-unstable nor mm-stable.

Fair - I'll make sure to move this paragraph to above the changelog next ti=
me :)

>
> BTW, I have the following compile error with this series (fedora 43).
> Same config compile fine on v6.19.
>
> In file included from ./include/linux/local_lock.h:5,
>                  from ./include/linux/mmzone.h:24,
>                  from ./include/linux/gfp.h:7,
>                  from ./include/linux/mm.h:7,
>                  from mm/vswap.c:7:
> mm/vswap.c: In function =E2=80=98vswap_cpu_dead=E2=80=99:
> ./include/linux/percpu-defs.h:221:45: error: initialization from
> pointer to non-enclosed address space
>   221 |         const void __percpu *__vpp_verify =3D (typeof((ptr) +
> 0))NULL;    \
>       |                                             ^
> ./include/linux/local_lock_internal.h:105:40: note: in definition of
> macro =E2=80=98__local_lock_acquire=E2=80=99
>   105 |                 __l =3D (local_lock_t *)(lock);
>          \
>       |                                        ^~~~
> ./include/linux/local_lock.h:17:41: note: in expansion of macro
> =E2=80=98__local_lock=E2=80=99
>    17 | #define local_lock(lock)                __local_lock(this_cpu_ptr=
(lock))
>       |                                         ^~~~~~~~~~~~
> ./include/linux/percpu-defs.h:245:9: note: in expansion of macro
> =E2=80=98__verify_pcpu_ptr=E2=80=99
>   245 |         __verify_pcpu_ptr(ptr);
>          \
>       |         ^~~~~~~~~~~~~~~~~
> ./include/linux/percpu-defs.h:256:27: note: in expansion of macro =E2=80=
=98raw_cpu_ptr=E2=80=99
>   256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
>       |                           ^~~~~~~~~~~
> ./include/linux/local_lock.h:17:54: note: in expansion of macro
> =E2=80=98this_cpu_ptr=E2=80=99
>    17 | #define local_lock(lock)
> __local_lock(this_cpu_ptr(lock))
>       |
> ^~~~~~~~~~~~
> mm/vswap.c:1518:9: note: in expansion of macro =E2=80=98local_lock=E2=80=
=99
>  1518 |         local_lock(&percpu_cluster->lock);
>       |         ^~~~~~~~~~

Ah that's strange. It compiled on all of my setups (I tested with a couple
different ones), but I must have missed some cases. Would you mind
sharing your configs so that I can reproduce this compilation error?

(although I'm sure kernel test robot will scream at me soon, which
usually includes configs that cause the compilation issue).

>
> > that the lock contention issues that plagued earlier versions have been
> > resolved and performance on the kernel build benchmark is now on-par wi=
th
> > baseline. Furthermore, memory overhead has been substantially reduced
> > compared to the last RFC version.
> >
> >
> > I. Motivation
> >
> > Currently, when an anon page is swapped out, a slot in a backing swap
> > device is allocated and stored in the page table entries that refer to
> > the original page. This slot is also used as the "key" to find the
> > swapped out content, as well as the index to swap data structures, such
> > as the swap cache, or the swap cgroup mapping. Tying a swap entry to it=
s
> > backing slot in this way is performant and efficient when swap is purel=
y
> > just disk space, and swapoff is rare.
> >
> > However, the advent of many swap optimizations has exposed major
> > drawbacks of this design. The first problem is that we occupy a physica=
l
> > slot in the swap space, even for pages that are NEVER expected to hit
> > the disk: pages compressed and stored in the zswap pool, zero-filled
> > pages, or pages rejected by both of these optimizations when zswap
> > writeback is disabled. This is the arguably central shortcoming of
> > zswap:
> > * In deployments when no disk space can be afforded for swap (such as
> >   mobile and embedded devices), users cannot adopt zswap, and are force=
d
> >   to use zram. This is confusing for users, and creates extra burdens
> >   for developers, having to develop and maintain similar features for
> >   two separate swap backends (writeback, cgroup charging, THP support,
> >   etc.). For instance, see the discussion in [4].
> > * Resource-wise, it is hugely wasteful in terms of disk usage. At Meta,
> >   we have swapfile in the order of tens to hundreds of GBs, which are
> >   mostly unused and only exist to enable zswap usage and zero-filled
> >   pages swap optimizations.
> > * Tying zswap (and more generally, other in-memory swap backends) to
> >   the current physical swapfile infrastructure makes zswap implicitly
> >   statically sized. This does not make sense, as unlike disk swap, in
> >   which we consume a limited resource (disk space or swapfile space) to
> >   save another resource (memory), zswap consume the same resource it is
> >   saving (memory). The more we zswap, the more memory we have available=
,
> >   not less. We are not rationing a limited resource when we limit
> >   the size of he zswap pool, but rather we are capping the resource
> >   (memory) saving potential of zswap. Under memory pressure, using
> >   more zswap is almost always better than the alternative (disk IOs, or
> >   even worse, OOMs), and dynamically sizing the zswap pool on demand
> >   allows the system to flexibly respond to these precarious scenarios.
> > * Operationally, static provisioning the swapfile for zswap pose
> >   significant challenges, because the sysadmin has to prescribe how
> >   much swap is needed a priori, for each combination of
> >   (memory size x disk space x workload usage). It is even more
> >   complicated when we take into account the variance of memory
> >   compression, which changes the reclaim dynamics (and as a result,
> >   swap space size requirement). The problem is further exarcebated for
> >   users who rely on swap utilization (and exhaustion) as an OOM signal.
> >
> >   All of these factors make it very difficult to configure the swapfile
> >   for zswap: too small of a swapfile and we risk preventable OOMs and
> >   limit the memory saving potentials of zswap; too big of a swapfile
> >   and we waste disk space and memory due to swap metadata overhead.
> >   This dilemma becomes more drastic in high memory systems, which can
> >   have up to TBs worth of memory.
> >
> > Past attempts to decouple disk and compressed swap backends, namely the
> > ghost swapfile approach (see [13]), as well as the alternative
> > compressed swap backend zram, have mainly focused on eliminating the
> > disk space usage of compressed backends. We want a solution that not
> > only tackles that same problem, but also achieve the dyamicization of
> > swap space to maximize the memory saving potentials while reducing
> > operational and static memory overhead.
> >
> > Finally, any swap redesign should support efficient backend transfer,
> > i.e without having to perform the expensive page table walk to
> > update all the PTEs that refer to the swap entry:
> > * The main motivation for this requirement is zswap writeback. To quote
> >   Johannes (from [14]): "Combining compression with disk swap is
> >   extremely powerful, because it dramatically reduces the worst aspects
> >   of both: it reduces the memory footprint of compression by shedding
> >   the coldest data to disk; it reduces the IO latencies and flash wear
> >   of disk swap through the writeback cache. In practice, this reduces
> >   *average event rates of the entire reclaim/paging/IO stack*."
> > * Another motivation is to simplify swapoff, which is both complicated
> >   and expensive in the current design, precisely because we are storing
> >   an encoding of the backend positional information in the page table,
> >   and thus requires a full page table walk to remove these references.
> >
> >
> > II. High Level Design Overview
> >
> > To fix the aforementioned issues, we need an abstraction that separates
> > a swap entry from its physical backing storage. IOW, we need to
> > =E2=80=9Cvirtualize=E2=80=9D the swap space: swap clients will work wit=
h a dynamically
> > allocated virtual swap slot, storing it in page table entries, and
> > using it to index into various swap-related data structures. The
> > backing storage is decoupled from the virtual swap slot, and the newly
> > introduced layer will =E2=80=9Cresolve=E2=80=9D the virtual swap slot t=
o the actual
> > storage. This layer also manages other metadata of the swap entry, such
> > as its lifetime information (swap count), via a dynamically allocated,
> > per-swap-entry descriptor:
> >
> > struct swp_desc {
> >         union {
> >                 swp_slot_t         slot;                 /*     0     8=
 */
> >                 struct zswap_entry * zswap_entry;        /*     0     8=
 */
> >         };                                               /*     0     8=
 */
> >         union {
> >                 struct folio *     swap_cache;           /*     8     8=
 */
> >                 void *             shadow;               /*     8     8=
 */
> >         };                                               /*     8     8=
 */
> >         unsigned int               swap_count;           /*    16     4=
 */
> >         unsigned short             memcgid:16;           /*    20: 0  2=
 */
> >         bool                       in_swapcache:1;       /*    22: 0  1=
 */
> >
> >         /* Bitfield combined with previous fields */
> >
> >         enum swap_type             type:2;               /*    20:17  4=
 */
> >
> >         /* size: 24, cachelines: 1, members: 6 */
> >         /* bit_padding: 13 bits */
> >         /* last cacheline: 24 bytes */
> > };
> >
> > (output from pahole).
> >
> > This design allows us to:
> > * Decouple zswap (and zeromapped swap entry) from backing swapfile:
> >   simply associate the virtual swap slot with one of the supported
> >   backends: a zswap entry, a zero-filled swap page, a slot on the
> >   swapfile, or an in-memory page.
> > * Simplify and optimize swapoff: we only have to fault the page in and
> >   have the virtual swap slot points to the page instead of the on-disk
> >   physical swap slot. No need to perform any page table walking.
> >
> > The size of the virtual swap descriptor is 24 bytes. Note that this is
> > not all "new" overhead, as the swap descriptor will replace:
> > * the swap_cgroup arrays (one per swap type) in the old design, which
> >   is a massive source of static memory overhead. With the new design,
> >   it is only allocated for used clusters.
> > * the swap tables, which holds the swap cache and workingset shadows.
> > * the zeromap bitmap, which is a bitmap of physical swap slots to
> >   indicate whether the swapped out page is zero-filled or not.
> > * huge chunk of the swap_map. The swap_map is now replaced by 2 bitmaps=
,
> >   one for allocated slots, and one for bad slots, representing 3 possib=
le
> >   states of a slot on the swapfile: allocated, free, and bad.
> > * the zswap tree.
> >
> > So, in terms of additional memory overhead:
> > * For zswap entries, the added memory overhead is rather minimal. The
> >   new indirection pointer neatly replaces the existing zswap tree.
> >   We really only incur less than one word of overhead for swap count
> >   blow up (since we no longer use swap continuation) and the swap type.
> > * For physical swap entries, the new design will impose fewer than 3 wo=
rds
> >   memory overhead. However, as noted above this overhead is only for
> >   actively used swap entries, whereas in the current design the overhea=
d is
> >   static (including the swap cgroup array for example).
> >
> >   The primary victim of this overhead will be zram users. However, as
> >   zswap now no longer takes up disk space, zram users can consider
> >   switching to zswap (which, as a bonus, has a lot of useful features
> >   out of the box, such as cgroup tracking, dynamic zswap pool sizing,
> >   LRU-ordering writeback, etc.).
> >
> > For a more concrete example, suppose we have a 32 GB swapfile (i.e.
> > 8,388,608 swap entries), and we use zswap.
> >
> > 0% usage, or 0 entries: 0.00 MB
> > * Old design total overhead: 25.00 MB
> > * Vswap total overhead: 0.00 MB
> >
> > 25% usage, or 2,097,152 entries:
> > * Old design total overhead: 57.00 MB
> > * Vswap total overhead: 48.25 MB
> >
> > 50% usage, or 4,194,304 entries:
> > * Old design total overhead: 89.00 MB
> > * Vswap total overhead: 96.50 MB
> >
> > 75% usage, or 6,291,456 entries:
> > * Old design total overhead: 121.00 MB
> > * Vswap total overhead: 144.75 MB
> >
> > 100% usage, or 8,388,608 entries:
> > * Old design total overhead: 153.00 MB
> > * Vswap total overhead: 193.00 MB
> >
> > So even in the worst case scenario for virtual swap, i.e when we
> > somehow have an oracle to correctly size the swapfile for zswap
> > pool to 32 GB, the added overhead is only 40 MB, which is a mere
> > 0.12% of the total swapfile :)
> >
> > In practice, the overhead will be closer to the 50-75% usage case, as
> > systems tend to leave swap headroom for pathological events or sudden
> > spikes in memory requirements. The added overhead in these cases are
> > practically neglible. And in deployments where swapfiles for zswap
> > are previously sparsely used, switching over to virtual swap will
> > actually reduce memory overhead.
> >
> > Doing the same math for the disk swap, which is the worst case for
> > virtual swap in terms of swap backends:
> >
> > 0% usage, or 0 entries: 0.00 MB
> > * Old design total overhead: 25.00 MB
> > * Vswap total overhead: 2.00 MB
> >
> > 25% usage, or 2,097,152 entries:
> > * Old design total overhead: 41.00 MB
> > * Vswap total overhead: 66.25 MB
> >
> > 50% usage, or 4,194,304 entries:
> > * Old design total overhead: 57.00 MB
> > * Vswap total overhead: 130.50 MB
> >
> > 75% usage, or 6,291,456 entries:
> > * Old design total overhead: 73.00 MB
> > * Vswap total overhead: 194.75 MB
> >
> > 100% usage, or 8,388,608 entries:
> > * Old design total overhead: 89.00 MB
> > * Vswap total overhead: 259.00 MB
> >
> > The added overhead is 170MB, which is 0.5% of the total swapfile size,
> > again in the worst case when we have a sizing oracle.
> >
> > Please see the attached patches for more implementation details.
> >
> >
> > III. Usage and Benchmarking
> >
> > This patch series introduce no new syscalls or userspace API. Existing
> > userspace setups will work as-is, except we no longer have to create a
> > swapfile or set memory.swap.max if we want to use zswap, as zswap is no
> > longer tied to physical swap. The zswap pool will be automatically and
> > dynamically sized based on memory usage and reclaim dynamics.
> >
> > To measure the performance of the new implementation, I have run the
> > following benchmarks:
> >
> > 1. Kernel building: 52 workers (one per processor), memory.max =3D 3G.
> >
> > Using zswap as the backend:
> >
> > Baseline:
> > real: mean: 185.2s, stdev: 0.93s
> > sys: mean: 683.7s, stdev: 33.77s
> >
> > Vswap:
> > real: mean: 184.88s, stdev: 0.57s
> > sys: mean: 675.14s, stdev: 32.8s
>
> Can you show your user space time as well to complete the picture?

Will do next time! I used to include user time as well, but I noticed
that folks (for e.g see [1]) only include systime, not even real time,
so I figure nobody cares about user time :)

(I still include real time because some of my past work improves sys
time but regresses real time, so I figure that's relevant).

[1]: https://lore.kernel.org/linux-mm/20260128-swap-table-p3-v2-0-fe0b67ef0=
215@tencent.com/

But yeah no big deal. I'll dig through my logs to see if I still have
the numbers, but if not I'll include it in next version.

>
> How many runs do you have for stdev 32.8s?

5 runs! I average out the result of 5 runs.

>
> >
> > We actually see a slight improvement in systime (by 1.5%) :) This is
> > likely because we no longer have to perform swap charging for zswap
> > entries, and virtual swap allocator is simpler than that of physical
> > swap.
> >
> > Using SSD swap as the backend:
> Please include zram swap test data as well. Android heavily uses zram
> for swapping.
> >
> > Baseline:
> > real: mean: 200.3s, stdev: 2.33s
> > sys: mean: 489.88s, stdev: 9.62s
> >
> > Vswap:
> > real: mean: 201.47s, stdev: 2.98s
> > sys: mean: 487.36s, stdev: 5.53s
> >
> > The performance is neck-to-neck.
>
> I strongly suspect there is some performance difference that hasn't
> been covered by your test yet. Need more conformation by others on the
> performance measurement. The swap testing is tricky. You want to push
> to stress barely within the OOM limit. Need more data.

Very fair point :) I will say though - the kernel build test, with
memory.max limit sets, does generate a sizable amount of swapping, and
does OOM if you don't set up swap. Take my words for now, but I will
try to include average per-run (z)swap activity stats (zswpout zswpin
etc.) in future versions if you're interested :)

I've been trying to running more stress tests to trigger crashes and
performance regression. One of the big reasons why I haven't sent
anything til now is to fix obvious performance issues (the
aforementioned lock contention) and bugs. It's a complicated piece of
work.

As always, would love to receive code/design feedback from you (and
Kairui, and other swap reviewers), and I would appreciate very much if
other swap folks can play with the patch series on their setup as well
for performance testing, or let me know if there is any particular
case that they're interested in :)

Thanks for your review, Chris!



>
> Chris
>
> >
> >
> > IV. Future Use Cases
> >
> > While the patch series focus on two applications (decoupling swap
> > backends and swapoff optimization/simplification), this new,
> > future-proof design also allows us to implement new swap features more
> > easily and efficiently:
> >
> > * Multi-tier swapping (as mentioned in [5]), with transparent
> >   transferring (promotion/demotion) of pages across tiers (see [8] and
> >   [9]). Similar to swapoff, with the old design we would need to
> >   perform the expensive page table walk.
> > * Swapfile compaction to alleviate fragmentation (as proposed by Ying
> >   Huang in [6]).
> > * Mixed backing THP swapin (see [7]): Once you have pinned down the
> >   backing store of THPs, then you can dispatch each range of subpages
> >   to appropriate backend swapin handler.
> > * Swapping a folio out with discontiguous physical swap slots
> >   (see [10]).
> > * Zswap writeback optimization: The current architecture pre-reserves
> >   physical swap space for pages when they enter the zswap pool, giving
> >   the kernel no flexibility at writeback time. With the virtual swap
> >   implementation, the backends are decoupled, and physical swap space
> >   is allocated on-demand at writeback time, at which point we can make
> >   much smarter decisions: we can batch multiple zswap writeback
> >   operations into a single IO request, allocating contiguous physical
> >   swap slots for that request. We can even perform compressed writeback
> >   (i.e writing these pages without decompressing them) (see [12]).
> >
> >
> > V. References
> >
> > [1]: https://lore.kernel.org/all/CAJD7tkbCnXJ95Qow_aOjNX6NOMU5ovMSHRC+9=
5U4wtW6cM+puw@mail.gmail.com/
> > [2]: https://lwn.net/Articles/932077/
> > [3]: https://www.youtube.com/watch?v=3DHwqw_TBGEhg
> > [4]: https://lore.kernel.org/all/Zqe_Nab-Df1CN7iW@infradead.org/
> > [5]: https://lore.kernel.org/lkml/CAF8kJuN-4UE0skVHvjUzpGefavkLULMonjgk=
XUZSBVJrcGFXCA@mail.gmail.com/
> > [6]: https://lore.kernel.org/linux-mm/87o78mzp24.fsf@yhuang6-desk2.ccr.=
corp.intel.com/
> > [7]: https://lore.kernel.org/all/CAGsJ_4ysCN6f7qt=3D6gvee1x3ttbOnifGneq=
cRm9Hoeun=3DuFQ2w@mail.gmail.com/
> > [8]: https://lore.kernel.org/linux-mm/4DA25039.3020700@redhat.com/
> > [9]: https://lore.kernel.org/all/CA+ZsKJ7DCE8PMOSaVmsmYZL9poxK6rn0gvVXb=
jpqxMwxS2C9TQ@mail.gmail.com/
> > [10]: https://lore.kernel.org/all/CACePvbUkMYMencuKfpDqtG1Ej7LiUS87VRAX=
b8sBn1yANikEmQ@mail.gmail.com/
> > [11]: https://lore.kernel.org/all/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmj=
XHGBnfisCAb8VA@mail.gmail.com/
> > [12]: https://lore.kernel.org/linux-mm/ZeZSDLWwDed0CgT3@casper.infradea=
d.org/
> > [13]: https://lore.kernel.org/all/20251121-ghost-v1-1-cfc0efcf3855@kern=
el.org/
> > [14]: https://lore.kernel.org/linux-mm/20251202170222.GD430226@cmpxchg.=
org/
> >
> > Nhat Pham (20):
> >   mm/swap: decouple swap cache from physical swap infrastructure
> >   swap: rearrange the swap header file
> >   mm: swap: add an abstract API for locking out swapoff
> >   zswap: add new helpers for zswap entry operations
> >   mm/swap: add a new function to check if a swap entry is in swap
> >     cached.
> >   mm: swap: add a separate type for physical swap slots
> >   mm: create scaffolds for the new virtual swap implementation
> >   zswap: prepare zswap for swap virtualization
> >   mm: swap: allocate a virtual swap slot for each swapped out page
> >   swap: move swap cache to virtual swap descriptor
> >   zswap: move zswap entry management to the virtual swap descriptor
> >   swap: implement the swap_cgroup API using virtual swap
> >   swap: manage swap entry lifecycle at the virtual swap layer
> >   mm: swap: decouple virtual swap slot from backing store
> >   zswap: do not start zswap shrinker if there is no physical swap slots
> >   swap: do not unnecesarily pin readahead swap entries
> >   swapfile: remove zeromap bitmap
> >   memcg: swap: only charge physical swap slots
> >   swap: simplify swapoff using virtual swap
> >   swapfile: replace the swap map with bitmaps
> >
> >  Documentation/mm/swap-table.rst |   69 --
> >  MAINTAINERS                     |    2 +
> >  include/linux/cpuhotplug.h      |    1 +
> >  include/linux/mm_types.h        |   16 +
> >  include/linux/shmem_fs.h        |    7 +-
> >  include/linux/swap.h            |  135 ++-
> >  include/linux/swap_cgroup.h     |   13 -
> >  include/linux/swapops.h         |   25 +
> >  include/linux/zswap.h           |   17 +-
> >  kernel/power/swap.c             |    6 +-
> >  mm/Makefile                     |    5 +-
> >  mm/huge_memory.c                |   11 +-
> >  mm/internal.h                   |   12 +-
> >  mm/memcontrol-v1.c              |    6 +
> >  mm/memcontrol.c                 |  142 ++-
> >  mm/memory.c                     |  101 +-
> >  mm/migrate.c                    |   13 +-
> >  mm/mincore.c                    |   15 +-
> >  mm/page_io.c                    |   83 +-
> >  mm/shmem.c                      |  215 +---
> >  mm/swap.h                       |  157 +--
> >  mm/swap_cgroup.c                |  172 ---
> >  mm/swap_state.c                 |  306 +----
> >  mm/swap_table.h                 |   78 +-
> >  mm/swapfile.c                   | 1518 ++++-------------------
> >  mm/userfaultfd.c                |   18 +-
> >  mm/vmscan.c                     |   28 +-
> >  mm/vswap.c                      | 2025 +++++++++++++++++++++++++++++++
> >  mm/zswap.c                      |  142 +--
> >  29 files changed, 2853 insertions(+), 2485 deletions(-)
> >  delete mode 100644 Documentation/mm/swap-table.rst
> >  delete mode 100644 mm/swap_cgroup.c
> >  create mode 100644 mm/vswap.c
> >
> >
> > base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> > --
> > 2.47.3
> >

