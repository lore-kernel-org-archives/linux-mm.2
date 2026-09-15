Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F0D8C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12FED6B00A6; Tue, 15 Sep 2026 10:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BAF36B00A7; Tue, 15 Sep 2026 10:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5926B00A9; Tue, 15 Sep 2026 10:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BECE26B00A6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:36:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F0D180431
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:36:42 +0000 (UTC)
X-FDA: 85216247844.08.8BC42E5
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf13.hostedemail.com (Postfix) with ESMTP id 493992000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:36:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YANOEQP2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789483000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMRn/ahkKA5Dzm0qrPRXaVCV5b26ohTvkifPgSZR0R8=;
	b=z/bRHxisjwaG7ro0VITpqZ8IJUegQrxmsz0+6b0xYvwyMlEAq3vgRIiY505r9fFF0gF4rn
	OVVaske8zy0RpPAvCotKBTjDqf1S5CdT6JS1Yfp5lr+8ywvvvXt+pfa2KnF+dL5LnF0ibK
	zT2YS8b2vDxL0Pfp1MD+7XE+X7suUgk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YANOEQP2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789483000;
	b=2Y+aHK+x6KzRaCEub92AtaGGqQAM8o48XQpKZeAIceyu0eTMk/+FhkJM/Gk9VAg4sU0ZVd
	n+2JJxKZNq8XeleHrs6XBYBVP5uv9yx56mpBlbsGOltdiJnF5fxVnOey7+3dPm2a1SIfmG
	5c/0T+ZaMiFDmlyyyb+PsqAWRMKeRLM=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530d5fc2cd8so29461cf.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:36:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789482999; cv=none;
        d=google.com; s=arc-20260327;
        b=A9W9ihBKruXJdgv8K5EcERZQQRy2jNoXxt7h48NrryUkisdZjZFBPysG6UHV1B/Xx0
         QqLjuThHV+Jc6+FFL6WjvA8H0Lfzk77BgDCPSBBYEQpftSxoqY8+30uxg4EoI8DmiysZ
         HfsTgipL9yERza/DiM5ypoeKalDdKzPwl8EYyvgQWuIvLVxE1mKCcbTo9L7AYhtpBPgW
         2FtMAexS/hd0UzzLqKAF1taiErKgTCtbdci/vx6JdUUGrplTH76dnOwJwZt8kLeP9xTW
         mWsSLZeNbp6A/EWe+VGi/+/GFi77gP0Rgfi1FwYo9PQ1w38TyxBa4rH3mtFM0TgCxvFF
         brCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wMRn/ahkKA5Dzm0qrPRXaVCV5b26ohTvkifPgSZR0R8=;
        fh=ebuAKljOjHOE6Hlidej6gUbY9G+c70nwSm+81HWSIDQ=;
        b=IOWh88T2Jvvqjdz2zd5P/ygXVLSi0xLHORJ/Vh920OYuqP2MBRFBDGA7ZJA994foot
         SGVHIfRwgqVHPQYv4oVXkV45cLjNbaA7ypHUmLvJgUsBbjDHISIePXiVyaWD/G/4re5J
         RS1WEof0iHSLZQ2Xfum5KSPG2ak2JVBfIEz26Oa8O7lKWw2zHConafOH8OKcBHDU8M+B
         yBQpZNW7+fHh2ARmWC4Cnrw0SafEi36Vr8oRHn6rxp+a2/h8jacnD+mrxGH2xVgwgsB+
         4gqbY/Vb8r1xV699uQFv6lBMaHQeYRNJGDx+E25WMMxutoAEAWXtUvKMedTovQVpFPID
         oAqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789482999; x=1790087799; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wMRn/ahkKA5Dzm0qrPRXaVCV5b26ohTvkifPgSZR0R8=;
        b=YANOEQP2B9hZdXVMdG7k+c17qf+j9RMa+sVYUME29m8a5ebXXT4bC6E8RyXfS42lwR
         rw7CCzMSx4zxJ+0GHtPYysRxWwLgE60fkEvFIpVESMVChybxr+LvCQev4fhPC8+EVvqC
         RRGwho00xVw55+ABlQd8LOrcnrVdRyF8KtxckUsVpGimVHhFDIJWrfL/OfWxftNpHqIk
         mnt4tWVYwjmlwu2wKIKIcx1iYK4TVlZSuEPNHxz7yvDVuRRrUd3R+wHgNgqg1GxPBUSE
         R0rGRUDJCWbLEDHHn8gvnfeHTE+UQqp595xF09CAMrR3SyJIZJzXmZRavN9nhV0TFR1C
         JsrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789482999; x=1790087799;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wMRn/ahkKA5Dzm0qrPRXaVCV5b26ohTvkifPgSZR0R8=;
        b=QVCLjVOFS6nDb0Np3l6bU8qYcxxpwNPQemlhrDfQKqy+XBhoqugYNOaXEbHlJooF0x
         IRKl24cjS+2Hm9MYsdZvbyIP7IHFFUnQtT6Jm9FlzhdI8LTQG2oB08I7E0R0pzrG9CvO
         kn/yYEtqvP/LZM5/NohJQVUO7FAndh84RoyC+9TRiqm1/Gjyb+azQYEcXY29/njIsk2r
         hHqMUfh9uXwFti9k4xP5TO3xjJspHFk4asa1D+hXZqdassvZ2W51TV3yZexyPtq7eVGD
         OdKUUT5E4Om6QqugDdjc1+n8LJsYDcznA5FbUu96X0cxMCylgJxnKGoh0+mE5eCIQlw3
         6ArQ==
X-Forwarded-Encrypted: i=1; AKwUvByqXA+pSQvOjSNI377WgbYswwtml6lDlzmGz73TCdHEtWCfKQ4hrBRg6jPHBLOotGh6VhSDNCIFDA==@kvack.org
X-Gm-Message-State: AFuF++luZjcsAZS9mXcZQJi7CE/umAiVryewgVzevMI18e8KoKd9u0I3
	voMVVZ3suA1g1YBNnbMqaD1lPUA23MEyEyHf81LpMJgYHag8BdRJ2VbNoGNqrfaFYR8FxJqdhL3
	f7Ck8bZXJC5wN/zaRFeBGjSsi8bB4Yn26KpZt4349
X-Gm-Gg: AYBFou00JWmwsoQEKVutyAhpaCIswGceO5Zlov9ds021NI5mWiFNV+U1MYzo5ZuIyXE
	6kuoEZXLWWDt/f34vMd80dNSnHqTcxWm1aKblR2bMsTIk8spc9M95kwrMc3uOH9yCKk/nXbNsy5
	seHUfmBhiVNzmgt+MiEfZVCj/NpZiIol6FDw+F8nUnWkx1KMPHuu2e6H48tplHX92RdvApYGMlh
	3vogG0lx3+sn74Z6Dh8IdMI6RifRf0lS1sss/R55esHu2Ue/cFiz4FhI8vLi4aaWVSdmSUgzzel
	OWHRtPOshe4unHRfNLdZsE/j0G8mxwFfYi1w20Y9sCMtj2u0j3kuOPpJnUkm6KRrKWsYaSluBNq
	RwuioKyhn8B8=
X-Received: by 2002:a05:622a:5148:b0:527:f08f:56a2 with SMTP id
 d75a77b69052e-5311a698b88mr18698561cf.8.1789482998727; Tue, 15 Sep 2026
 07:36:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260817062726.106511-1-hao.ge@linux.dev> <20260826203914.347c42aa00081ee9e0eb858a@linux-foundation.org>
 <afa606df-3d5b-47c2-9972-f3e0c2e13c12@linux.dev> <af33dfe1-04ef-4bfd-8c79-0593b24c6bdb@linux.dev>
In-Reply-To: <af33dfe1-04ef-4bfd-8c79-0593b24c6bdb@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 15 Sep 2026 07:36:27 -0700
X-Gm-Features: AcwNN1WtW5KqgGvhvlIri8T39xiLzrD7Zw5VwjZHMceFUigk0u27nHuuawn3KBE
Message-ID: <CAJuCfpEUYztqobQDHt9GwJZOcn5JrOs49a+8AVpu_ySUG_KkyQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] alloc_tag: fix a leak and a deadlock around shutdown_mem_profiling()
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: cpqzxi9911uckimho1yfjkz365mxp5qn
X-Rspamd-Queue-Id: 493992000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789483000-740927
X-HE-Meta: U2FsdGVkX1+oQH2/hbcvPraq2KnoJVbRH7TYVCb8lcvz8rjoWfRFgqfFIVAp1xvyC5tdVzU5XrASj2Q/tSt83kn4Se1BPeNxXGcoL3fVlmjGl0IITtTveONdMn12wZJgE1NUXvkRUdPx9B6DIfH8iI7RLt2TIWxZoy03CO4aG93FEd3rnacKcfRWIqHcxA6VGXgo9Q2HCkGs/ZTuB+9o7OalZCVbfYHw7wGBoEJzf8CT59xj4qDaVgu45IYfLMffPDGNO5AHx13ZkGPRzK+jwr99Urv931jZIIbxiAFtuiCBfc52C8CBMUG8x5yBx6sCzQg98Irxj1k+dMSonf8KrP7LNX8MfCkVKQYGKjzL0r/re15YVJFu/mv5+ho3Q0hlWyPrI4aKK7oCFbYIHSKl9oPKjVBWQ4mtXxwcRVUxSHgJazm9ATO47lSCf5zZ60dxPuA2LxaEM5mmvPq+xS2CpG6OPvwg1qp6tAi9rB6XabfLkJz7YhEX+e16Vn4gIlHMz8dSQpYDxzFAqzlcbJOSj4zMZMVGGOa8Hl04OPL+1Rn4EdzbpRQLM8BcMDXQwtV8XiLMYOqUcplRX7zmNmFQtuy+mFKTeCnYtsS1yS3PvP50B1TuTnGNcOcbY+CSsmWhEFIxlsyxuDonAQjsZ8fldvkMs3QIXhGMOm+vPzKb7DjI10j3b03J2EtzdgnypBGbFmZZtKXFnmIzJOBrTTxPrwc06MYWwfUapmXgyu0CEch8ADc79/B6cSqWR00471PpcRR58/SOYBqSJqo03wt4b0qyeEi6aAobpJB1vvGpUAtahq9UQ0eGK3zckCPMSgA1YLNTIuLv4fDjO4WIpi6j+Kc6UEgb2hufsZKjyko/k8Lco78nu+GW2fdxHAkzQ0RPwD0e5QbyK6KL7Q8cttVJB8Y9YfJnqCAQwxp7+QMZ48pdS6wYGZXNx7zrBbpot7vvPEarDrC1WJLoVXkF+B3
 84LMItMi
 +scTHgLxjkVeSoBfChnp+YNXsaTCenZyVSmhH7V0B2ZX0xc6d2I7Erc+falKYk0bHh3ZNyIRBVbfJSe++YGPPLB86rpG0htnmkE8/npNFqOI4h9R/M2j1Fot0f1Ran6tpC3a1hnHJgvB/hToE8OzW6B9IQrLMKsaW8uqqbXGSGlL9sxPHT6dEaHTs/0jv1Su71IfNwW369Sd0SDcAkwqYQ1OzyIOswRL+F8uEWa5QPGcue4X2sTs9dWN8bPo9pMVB4BAtQ0N/k8t5zWOw8RJs1ZBYhiExrjBWoOu7n+nfODAm2EqeXooI3xPjFVI1u1ztLfEsbIIQclF3vNOgboVVStE4fCXYH83X7mrtgB8IKBG1dWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 7:49=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren and Andrew
>
>
> Update the status of this issue surfaced by Sashiko.
>
>
> On 2026/8/28 11:11, Hao Ge wrote:
> > Hi Andrew
> >
> > On 2026/8/27 11:39, Andrew Morton wrote:
> >> On Mon, 17 Aug 2026 14:27:24 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> >>
> >>> Two fixes for issues reported by sashiko:
> >>>
> >>>   1. percpu counter leak on modules loaded after profiling is disable=
d.
> >>>   2. AB-BA deadlock between module load and /proc/allocinfo readers.
> >>>
> >>
> >> Thanks.  AI review asked two questions.  One pertinent to your
> >> alterations and one pertinent to Suren ;)
> >>
> >>      https://sashiko.dev/#/patchset/20260817062726.106511-1-hao.ge@lin=
ux.dev
> >>
> >> I'll queue the patchset for 7.3-rc1, with a note-to-self.
> >
> > Thanks for the heads up on the sashiko review questions.
> >
> > The question on patch 1 (codetag_load_module() error handling)
> > has two parts.
> >
> > The lost error code issue is already fixed; I sent the patch and
> > you queued it. (Thanks).
> >
> > For the rollback part:
> >
> > I've also seen Sashiko flag this same issue on another of my patches.
> > At the moment this case can't actually happen, alloc_tag is our only
> > registered codetag type, and codetag_module_init() cleans up its cmod
> > from the idr on every failure path, so nothing gets left behind.
> >
> > That said, if we ever add a second codetag type down the line, the prob=
lem
> > Sashiko spotted will become real. I will follow up later to refine this
> > logic and make it more robust.
> >
>
> Daniel also raised this issue
> https://lore.kernel.org/all/675259f9-c093-439c-a411-1937b23ddaa2@linux.de=
v/
>
> I do have the relevant fix ready locally. I plan to hold off on the next =
batch
> until we close out this recent chain of fixes. I'll bother you all again =
when the
> time comes.
>
> > The question on patch 2 (async /proc/allocinfo removal racing with
> > alloc_tag_init() failure):
> >
> > When I first read it, I think the window is unreachable. It requires
> > alloc_tag_init() to fail after proc_create() succeeded, and a process
> > to open and read /proc/allocinfo in the gap between schedule_work()
> > and the work running on system_wq.
> >
> > But CONFIG_MEM_ALLOC_PROFILING is a bool, so when enabled alloc_tag is
> > always built in and it cannot be a loadable module. Its module_init(all=
oc_tag_init)
> > runs inside do_initcalls(), before /init is exec'd. Failures inside
> > alloc_tag_init() are already very unlikely to happen. When the failure
> > happens, no normal userspace exists yet.
> >
> > That said, I realised the fix would actually be quite simple, we could =
just
> > move proc_create() to the end of alloc_tag_init().
> > I am not entirely sure whether we should do this though.
> >
> > Suren, what is your opinion?
> >
>
> I've been thinking about this quite a bit lately. Defensive programming
> is always welcome =E2=80=94 there might be edge cases I haven't considere=
d,
> or scenarios that could trigger this down the line.
> Furthermore, if alloc_tag initialization fails, the corresponding sysctl
> entry serves little purpose.
>
> Besides, I've decided to fold these two patches into this series:
> https://lore.kernel.org/all/20260908092412.115953-1-hao.ge@linux.dev/
>
> This is because Sashiko keeps flagging this percpu leak.
> https://lore.kernel.org/all/20260908094736.2B1A61F00A3A@smtp.kernel.org/
> And patch 1 addresses exactly this issue.
>
> We'll fold these two patches into that series and let Sashiko run another
> round of review.
>
> Please kindly help review the folded V10 version.

Hi Hao,
Sorry for not reviewing earlier version of your patchset and thank you
for pursuing this. I saw your v10 submission and will start reviewing
it. Due to time limitations, completing the review might take me a
couple of days.
Thanks,
Suren.

>
> Thanks
> Best Regards
> Hao
>
> > Thanks
> > Best Regards
> > Hao
> >

