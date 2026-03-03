Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CD4EB3659
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 02:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7416B00B1; Mon,  2 Mar 2026 21:44:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794FE6B00B2; Mon,  2 Mar 2026 21:44:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6974C6B00B3; Mon,  2 Mar 2026 21:44:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A76A6B00B1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:44:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F68C1C5C6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:44:25 +0000 (UTC)
X-FDA: 84503208090.27.28C42A0
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 20100100006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:44:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZPI+Dt3G;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772505863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cR+wLrLoELcTzOOU9ZIrHUzywv61u6DPcXV28/52+78=;
	b=o5XVc+ef9idwEV1ultg3XYo/hX+mCrww3vQkLqm9Y0AawNdoLCLcCyoN1BrVn/3gT129uX
	MkZNJejysFdSnsF2M1Jil+WT+aptZF4paQgMN5L3zzINJtaIZoHc2KvEOGp1z8JhMVI3WT
	ldp8n/Zlk+ajw40OJyPukX0sR/yUcaQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZPI+Dt3G;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772505863; a=rsa-sha256;
	cv=pass;
	b=w0x6xAAOKJlqgeKjS70N8DtU+RukaQ+yfrgn2jbb7R/wcN/IBwOGvf7uchJbebPJwMtpm7
	TH46UPFqlpSYYUwPZ8HXsRucKF/krjWqLSmUV4VYAF3CWJgJHrtTdEP6Unvd83qsOc9EjC
	I/nGWqDdv51A0SViOq6rubfG85SmVWc=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-64c9fcc24b3so3765458d50.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 18:44:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772505862; cv=none;
        d=google.com; s=arc-20240605;
        b=bOWJF94zdzOJmRwg+aO+kwf00phx6x6n2Cah3gfdxawff0My9jm08SCWiGc2aBwimd
         4FxPFYm+09QuxK9DGf5nydaBAkOTM8VvRbUB1XBj3c2rM6UwMjHe8DbRAaaJtt5CTdDv
         Md/25nGd8Ty12wzjy0v55E3Etv9/uQcQ1iHcUyxpGcYVRfJqs5rUvdhkhDGXLfDSo6C6
         bjI7lKzyEoPkQpRM4lgV62+X2fqBpd6GThDthiApAl7us1+HLoPoMSFjh5RPmJmajE4Q
         XVG1vN96xzbwKvagi8YD3XZQG2SDNyds+ByUpg5xJFfxhCIxKhGrVSCq/plgLLOUVX3v
         eaSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cR+wLrLoELcTzOOU9ZIrHUzywv61u6DPcXV28/52+78=;
        fh=V+EPbtGbyb0lsFe4NpFygmLIv1IRDtgxPRaj1N7g5pg=;
        b=AovwkZWTFM0gVJpUewpwyUP8jtoAceiRAJPxiX4DNzXiTSLUVNw47p8DxDcPoyeIzh
         lv8d4zoHqat/jw5n9DMzdJDCBEsw8sS9Pu0lJf0HlYsSElLSD+zgRfvwbhPtMlQqvJuY
         1pW3Dwn2Ef/Z93heDiK0YhxuVAAT/rTs9F6jw0pBGL5lexdCIFo5cIsYK3w523aut0D1
         x2Q7qYlE5dbN7ssML+fAUV8h29zu1Bow3s4nVxNrJqOeoplcfWGO1zW7jqLDRvg1jG+j
         vYuhHOM5xW0FkFxV7gi6MOSF2j09iX2K+ZWqnCZ8F6hza5CbAC4pkA5YbqYMNvkcrXvJ
         olFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772505862; x=1773110662; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cR+wLrLoELcTzOOU9ZIrHUzywv61u6DPcXV28/52+78=;
        b=ZPI+Dt3GjMCnEtPkxw3Yp1UaA6GOkotXo0ynibsYrSD7BvCVLng6xiMdRsH/49EF01
         hZy3Ir9db2DnXnBYelg9NdiAZS6p+JcH69Q2O76Y1WvKjZVmbyAQQLbYRVQHQv+GiZ+f
         BcvwbGodvRtYrIliYak0y5oU48xqNG8e1/OKd32/HNap7jUl/zU8LoBdX+SMtBdY5Cek
         Kas7DY28KTre2DKi7V1h3FGmukO9epwiiKviAzMm17F9BMIy6NbOA6ijH/E2xcDPVccO
         AeFpKLOkIi0diaGcBgrk7uD/eRNIqEjMcVrfp27KeNG3u7uGFLlyS/FW2Y4uQMN6u2K3
         ZT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772505862; x=1773110662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cR+wLrLoELcTzOOU9ZIrHUzywv61u6DPcXV28/52+78=;
        b=stgqkjSf9vnSyz2h60NUPQTJJHAHwqpfdc9IeZkRuUvo7TklMT/bktnYpOMomoZmGS
         AyaGTjw6Gm9ICEhJTB0LCtw5hykn3ep4fCp3v/uaYAVhjC7nCMFwoJkmzsHZEarvOLpT
         N6QiEjzbE9OusaoFfbehuB7C1Jf6oO1CTLLgs/J38VYph5IdRlzOhxEdmV5ASFRxYqr5
         hI0s+V+YWmWvKL/GCPPlJLM3UU8oYEHANdQ0CusFFI1K44vmPoqR41ImBJbTITU1ql7g
         Vq/g7cxLAeP4Eb9CoEecfObXpp2nWmOzwYP0v+vt4nzTCh0YmNyud6HeOQHKYBRRpaWw
         DRsw==
X-Forwarded-Encrypted: i=1; AJvYcCXs7LsNQZzR1br2pnspImeG5VPAA/k3yNGyEN58QnVnp4eXTGKBYiA0D1FUS7jxBeHf7nj+JeWGtQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1R2/NMiYV7wG18unFaPjE5RqYx+9QBCjJWiy9uFJEtQVLOqiF
	zVGXKhduMj20mc1OZbLaVJSuSLfc9RVucXWcIWhQbQ3uyS/HxswJvsIvLnnnpBLbU4tY192t2H3
	gwVtMBc/I5FyMXxemoPwI0A22KD00G68=
X-Gm-Gg: ATEYQzyRpbRvbJ/HIxS/Xi9P3+6hVfh0rF3Nob58ty3PHq4A4b2mAyNFcFLcXq8InB5
	8LfwyDEP7Z7EEVAMnuRlI7FZOzz5qPX2MezMyTzE2hV+pAbNwzN11va0I+b8/mS3hBwD5iSxw0Y
	Ji3S5CukLOlHd8wKuDJu05otd3N+wL4cC2nSS/7LTLyzE1oO9OLIe4kt1iKAISWF4o2vLzT89Y0
	dkY3hg0KPaYvilu24oyphfY175Ut32PFkBo8hvBpZMMBzRw4JV3NDlxBGjyzZOA20WE/0tCNvxr
	ERI5l/Wl
X-Received: by 2002:a05:690e:58a:b0:64c:9d01:aa66 with SMTP id
 956f58d0204a3-64cc22c5425mr8693400d50.68.1772505862141; Mon, 02 Mar 2026
 18:44:22 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
 <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
 <CALOAHbCma=SW4nu_GPv_pbuuXv1V5JPB-9cA3z1TeemWqU68tg@mail.gmail.com>
 <CAGsJ_4yAkaqqzSu7SS=_fgZ_AQCqtbv8LmuPGCb7SiFpGk4csg@mail.gmail.com>
 <CAMgjq7AkvgzW96-JQzEg5c4oW0cMsjPHcCnukCUZXgSvXL4-DQ@mail.gmail.com>
 <CALOAHbB3rQ2b7ABqFegt2afYRL7KjpWREucrhOYfTT=onV1+Gw@mail.gmail.com>
 <CAJj2-QEO=9Nt+HP6m=xtFD8qcXCdGCRmESmcs0haeiMdqqTA1Q@mail.gmail.com>
 <CAGsJ_4ynhyROTMsy1m3AZNsAzFsjZY3EYpSOSTLR0dQSxO+akw@mail.gmail.com> <CAJHvVci8nc-yTHkAbSEQQtqkRvgATJWcSTwBCY49A5W4AQcd7Q@mail.gmail.com>
In-Reply-To: <CAJHvVci8nc-yTHkAbSEQQtqkRvgATJWcSTwBCY49A5W4AQcd7Q@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 3 Mar 2026 10:43:46 +0800
X-Gm-Features: AaiRm51qtSlLfriiCH_nNFRA-iR0bpo7cuo_7xPSo_NXyYNBR7JsX_K8v2LQlno
Message-ID: <CALOAHbC0XbvG4OCy94j+ZUyTZt65QB0Y=p1UwKvGcsgcWKy7mg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <21cnbao@gmail.com>, Yuanchu Xie <yuanchu@google.com>, 
	Kairui Song <ryncsn@gmail.com>, bingfangguo@tencent.com, lenohou@gmail.com, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	weixugc@google.com, wjl.linux@gmail.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 20100100006
X-Stat-Signature: j41cjs8xy8z4kxnjyjxmiubqepobakow
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772505862-491538
X-HE-Meta: U2FsdGVkX1/47l0GOF9P9K5k39zLnpcXznXcp55lw2vptY8cGuZNo0HA+f6HpbZV3kzmA2fPYk7oP3Xqc+q2F2n/MYCoWSCORDiK5MzWIIoU8mIwyqT2kNqjyLTGxejiUStKA1f3XWj6zQUA6Vzq+R+4GDh2x4M3CTLougLlXDu8gdR3lpLAaB+0+/hBeM3Y3ZfbUNy+TwzJB4+6TifmmmNI75t9+HAzExqW1y6Erev9S6F7t5HI0VoXRe/yjr3y2wq6mj636eZvlrABimbTNN2Ne8zmvcyd8RCIYoKqMaqqtWWKMbEvY/Jjdcr3OHjqYKDnIxp6h59zxFr0KdMIyLU8MYGWrWZz+uJlugNS64kvJDL3wTR8xj5eyT0rQ18wugQVnsBvDqNNFyxwf0HB+Mj2bRjOSzVVnQM5qt9j1rTuXJVNpZwkKNyIwaIWUlVIETulKqcYZr7IuwPlbqGoExPm510a0Lg+UAqlA8KKkDBghhbCmJ0eR3zxPpHTH8leb0ijKMpKZddRkCQA/A+ZCD/fZH7LVkzf0raEPpqpFkwU/lFojyF5n40c0yu9miQLNdcyVV8h2tYjvSdvqteoePxQ+U993pSg9AMifZxKsQkwYcsNudcR3WnVpjnqoFn+AVgtdOVCZ0QmX4dsVrwCxwAE7CtR4UlF8y8/1GxE0afykPyQEupwlgbPB4uC9vRgdpQvFvPk5U9hz1Mf/uwTt69NVByVvD4rsta+rSoqQ6jdJIf+U/plYzDgUmZjO8Nv1J4OKcPSqU2EBdIcWl89DDar8KXuuNWMtrWU9EnkKEOsugINFR4cQTZxt+DE6MNPu0ajKtFGLne5sTI9U4r+sS5AxUjJuHAKgK3ONfQ/ppM5QxjlgnKeEET/XCWoQVTEgw3TwzJqt6nrDDc3uxltSOF5rFJy8Hl0VaylBDntx2AFWg3JF1OC8dvcbMdQdp8MNqcjX9+ubCLv09o9tuj
 PfCUMeee
 2yYLS6Ef+cFigfFq62Km/HgpAo1arAds2sVof5bWEa2fHDu9bquSXacOuApM84xaMydviO396+LJCWAIdKNBfJMkHFBlCgoIDom+Zl52YNBJwtQuNym05uqBNjaX6gerbS1OglAeLKWg2GPMJc3nkK9mZiXeTPXm/1txgGheThesNHnVhEg6cbulubdO91MtnYNxqf2imJ2SW5P1pVNjmz42T1ROAFTix9Cwns4SM/s5nopamdLcp21mH6NzLFoILFz3WhOXN79YfQmyWLvzbS3IG3WcoBHrOQ8CKLAAHqSpSNe4NNJUNVN110EgJ/xtui8jAM4Ct0c0Hfp83ODNJRCQIytH/yotdEdOUYNjsOvZj8zi87Zi505xJByolDVRfiNKAK447GNvRaed7ZNJnj7gg9FBlJQ+u8/Uc15VVErkbSFeGdhrE/+4V/2sIAPc3ZWAm6sKYXiacWVTg+x89kaxPHYbU1poTSKfw46gYcXZhD2pxzSljqMZpq62chSkFBs0frHqnq0QH8E+8XF5yjYV0BZc0tBbLTl2f5yduffTk2kQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 9:40=E2=80=AFAM Axel Rasmussen <axelrasmussen@google=
.com> wrote:
>
> On Mon, Mar 2, 2026 at 5:34=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Tue, Mar 3, 2026 at 1:52=E2=80=AFAM Yuanchu Xie <yuanchu@google.com>=
 wrote:
> > >
> > > Hi Yafang,
> > >
> > > On Mon, Mar 2, 2026 at 8:36=E2=80=AFAM Yafang Shao <laoar.shao@gmail.=
com> wrote:
> > > >
> > > > On Mon, Mar 2, 2026 at 5:48=E2=80=AFPM Kairui Song <ryncsn@gmail.co=
m> wrote:
> > > > >
> > > > > On Mon, Mar 2, 2026 at 5:20=E2=80=AFPM Barry Song <21cnbao@gmail.=
com> wrote:
> > > > > >
> > > > > > On Mon, Mar 2, 2026 at 4:25=E2=80=AFPM Yafang Shao <laoar.shao@=
gmail.com> wrote:
> > > > > > >
> > > > > > > The challenge we're currently facing is that we don't yet kno=
w which
> > > > > > > workloads would benefit from it ;)
> > > > > > > We do want to enable mglru on our production servers, but fir=
st we
> > > > > > > need to address the risk of OOM during the switch=E2=80=94tha=
t's exactly why
> > > > > > > we're proposing this patch.
> > > > > >
> > > > > > Nobody objects to your intention to fix it. I=E2=80=99m curious=
: to what
> > > > > > extent do we want to fix it? Do we aim to merely reduce the pro=
bability
> > > > > > of OOM and other mistakes, or do we want a complete fix that ma=
kes
> > > > > > the dynamic on/off fully safe?
> > > > >
> > > > > Yeah, I'm glad that more people are trying MGLRU and improving it=
.
> > > > >
> > > > > We also have an downstream fix for the OOM on switch issue, but t=
hat's
> > > > > mostly as a fallback in case MGLRU doesn't work well, our goal is
> > > > > still try to enable MGLRU as much as possible,
> > > >
> > > > Our goals are aligned.
> > > > Before enabling mglru, we must first ensure it won't cause OOM erro=
rs
> > > > across multiple servers. We propose fixing this because, during our
> > > > previous mglru enablement, many instances of a single service OOM'd
> > > > simultaneously=E2=80=94potentially leading to data loss for that se=
rvice.
> > >
> > > Would it be possible to drain the jobs away from the machine before
> > > switching LRUs? The MGLRU kill-switch could be improved, but making
> > > the switch more or less "hitless" would require significant work. Is
> > > the use case a one-time switch from active/inactive to MGLRU?
> >
> > I guess the point is that if upstream provides a sysctl to
> > toggle MGLRU on and off, then that sysctl should actually
> > work as intended. Otherwise, it would be better to remove
> > it.
>
> I think the problem is the requirements are not well specified. :)

We are planning to enable MGLRU across our large server fleet. During
a previous enablement attempt, we observed multiple instances of a
single service experiencing OOM errors simultaneously, which led to
unexpected user data loss. Despite this, we remain committed to
rolling out MGLRU to more production servers, with the critical
requirement of avoiding OOM events during the transition.

Given the scale of our fleet, it is not feasible to enable MGLRU on
servers one by one while continuously monitoring for OOM occurrences.
Therefore, we need to modify the kernel to minimize the risk of OOM
errors during the enablement process.


>
> Is it enough for the knob to function well on idle systems? Or does it
> need to function "ideally" under all conceivable workloads / stress?
> Also how do we define "ideally" - is a stray OOM kill acceptable or
> not? Is that preferable to waiting on the switch / drain to complete
> during reclaim or not? Reasonable users could disagree.


--=20
Regards
Yafang

