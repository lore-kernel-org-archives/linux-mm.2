Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E5BD44C69
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD506B0095; Thu, 15 Jan 2026 10:49:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240C86B0098; Thu, 15 Jan 2026 10:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115776B009B; Thu, 15 Jan 2026 10:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEFA66B0095
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:49:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 807FCB8F81
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:49:17 +0000 (UTC)
X-FDA: 84334632354.29.3CB35B8
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 757BA120006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:49:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J2k01ntf;
	spf=pass (imf29.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768492155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXRuTPFBhVzftunw+PucDMtc83VmTNtPzLCRx/k+Eos=;
	b=dORg2mjouSpNdI4N6P+Ig3UKsfqBnUyjHQtwsO9oF8D82HCJ3KAgVt5G1+yE1y2AxeUPHf
	c1CJez6A7rKAdMCrBM0LqaHHtKuCGrd1KbsxDuXIsAerqcFczJO5xQqBegZjXTe3cNt8KM
	iM9U2ZC8lCGS+OTFVpWpjmSaSI8rGTk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J2k01ntf;
	spf=pass (imf29.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768492155; a=rsa-sha256;
	cv=pass;
	b=NEl8lo10GAiWFyxA26s60ddLccujBDW9G1JEYKGu0tFxNvMubd092n1tHscj6VdNV1+N/F
	IgPg/56tiCZyZYj8eoiV7lO6pkMbO65mMnVGxTEhYQpSboPev31XhYqfUsk30WhaBvo8hR
	mY2fme4yPdHlnvWFKW0N8zWn+lvL59E=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso9086a12.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:49:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768492154; cv=none;
        d=google.com; s=arc-20240605;
        b=iBwfHo00yYIdDAW5i49pcKuO4knVOBR1a9VjEyst3ryVlSa9RRSEvL82XwTaQCRA/F
         prOL0QjXMGQycJ4wGPwcdvi5ZwVjbjuKBzoDoeKBbPP3WTpN/x3+j5YdczR4saCQqDTo
         ctE2W2HC8a/VZwfsG/jvy/q5P8g9rfQMk7fAuBMaZX2sNbGsVkk1kEwNdJXUOdzgJ461
         6NLGyUtuWgFEgHinaI4myL0DIDFCudQlSlW3dCDsvnqNQsZ4oEluy08izN4r1+j/BqYP
         KXexq+raKqNKuaRNegUvVH5eXBjPFY0rqMayDgb9IQa1f8xz72WQO0jN2ue0uJhOBJdX
         rdsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NXRuTPFBhVzftunw+PucDMtc83VmTNtPzLCRx/k+Eos=;
        fh=BqqWAXnlCI/ThSPAxOcBuY8wWeET7pnt/dSqULDhve4=;
        b=FoXeT4P1DbBUcDg6TV+DfMLAc6usZHgHWnarMPf+CoA+pUYAPyxWw+Nhhd1mEqQWB3
         /FRjsdzvU7fS8Keshw2U6FYNnYEzHs4rAAJVo8asvR/4o31U3KzpYfj7V7CfHhV53GcE
         BB/ALVEWXr+JJX5L0R+m6W7bDhdftfykoPuJEsPhOrQNQ1pQNZBIfiUcJyyGkg1oB02O
         zLUkBokd2Bkl9mrCPOA8Cc5cr2/yhgBiyG3OfxLaAtHai8D94DPpOjC0R9Uyg9SWuF9J
         On0wkB3seqxmSzwcWT8y6TJIVbUhTUVAa9ObrapDRiO4mR7z+ZOc+PvJfQTfXT4pZPLB
         BBQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768492154; x=1769096954; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NXRuTPFBhVzftunw+PucDMtc83VmTNtPzLCRx/k+Eos=;
        b=J2k01ntfju5BwB5rAKkcPgayOnK65z8VUJ278vZ+l+dgv7PLNqvwqRHB1wu1cfr9sA
         mAlsd19+Ogk5sKpLjYrzCZX7FLvDgoP9D0BksIOfdXfU9yjI97iCU4EwDLKWkh3uDs6i
         Pdw10ZrXyatETkcYRRlDvF1TenJ/IBnAq6ckiQBgcKAm5fckABVXl7U21XV5PYbRePE/
         /zrorOZHLAtTVh+qNgMtPDGjKBA9Oyp/Nslrh85rXMOYy1hoGV7BwUUy2p+S6Ll95LH7
         +i8Zn/HO9gownWsQOyNCXsnIQtg6L7A0qNATmxfQZGMTv/uW89K58UMsjN5yiaDSvv9c
         siQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768492154; x=1769096954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NXRuTPFBhVzftunw+PucDMtc83VmTNtPzLCRx/k+Eos=;
        b=Ti4CqAXWBqpWCG6DorYe0UlPuaGOSc3qtqNmBDq8Q4cmpZ2OOYIW33pIlMniARLfZ6
         3bnZs34G+KyeUPkIoWtS86fAzD9Lsj8YCFB5dbUXO5eYnYBtZs4b2AKHj8aj7yEx/kn4
         cHroLussN9/it9kboGedGP9Rf1hf6tp79Hz2q8xJxrm7fjiIbH3rwMcu7Tg2IxIru8on
         vLAH+vWwprYlMiD/vuHjPSrQF/UPfwT7UY1gN28EWLWdODLcDe198H8teIzjxPR5iLoO
         7Xa93ej6H2AnuUa6/u8CyauJJtuQL54V8h6ClJgoxnBp6SmzO+vJF6ZDC28mXePWqrMN
         XETA==
X-Forwarded-Encrypted: i=1; AJvYcCUjnpe1P40OYajHAGMwxFhk6hmJutX2zfju5/KZLAJSRprCYNqadbPNln9B/pRFqLZr3O6sYoqjBQ==@kvack.org
X-Gm-Message-State: AOJu0YwEAL4F61d2aCNIRygSuxvqMAK8nd8nXw0hS9df+QPnXNN+n2qO
	QuZaiSN6f+5YSoU+ao23X+nVj6gm1v8jiIJNeU0VKQ9zvalBkd+z9FlBepVHRuahvY4VAPwi+76
	ajsruBqwQleoHJmcUr/cXoNk90gjgvuVkLqqTQWRU
X-Gm-Gg: AY/fxX5Z5vGQBqHqwskzwIh+HliMWH4R4uNmo+0Drk7DkE9BJyh2QiWZbTfJj/4GAaO
	MLMGcmFfSS4u8UhVFYzcLBTfQSNUDeMI95RwmB4cRds4lHxg8XKPDp6gh+MwuisPTR1KJoFw8wp
	nQsov6qfrO8GHr9oUvWhCFTahbdklRclX1yPpz5P7zz1pN5Swj9UmIrRlcxngOPeVLA/OfLp5Bk
	LOJ0x0iVgs4Oi0JttUjSQXlv4+YmyqqzgDH9OM/XfFbA3+lL5Clqwl0S1MTFoTvNQBPyO0IMmpl
	5aRZOSv+cZfx3MX3w2vONQ70XA==
X-Received: by 2002:aa7:d919:0:b0:650:5d5c:711c with SMTP id
 4fb4d7f45d1cf-6541ff5f95cmr27130a12.17.1768492153365; Thu, 15 Jan 2026
 07:49:13 -0800 (PST)
MIME-Version: 1.0
References: <6967c517.050a0220.150504.0007.GAE@google.com> <CACT4Y+aFaijS_CvzTnHB+ecg5nzYW1-MWPSp-Ad_0ax85=DvCQ@mail.gmail.com>
 <CAG48ez0iyjjZn1U7LeG4SBXjRGo3PR-a0MWEhAJZ02vHOUA6BA@mail.gmail.com>
 <CACT4Y+Z24oSCssMnYwtCkGHpCKTOX2J4x+8HNoGovVxeZ5_TzQ@mail.gmail.com>
 <CAG48ez0q6ZXAk8D3frvXyeMsFDYfmY0sc=PkE6bRM8QP0gEVfg@mail.gmail.com>
 <CAG48ez3+t-uv88cUhG6=YfMyRVW5REi3-aaW3a_yXSZDK38_ow@mail.gmail.com>
 <96aec792-7d10-4dfa-bf35-cc94300f4d2b@lucifer.local> <CAG48ez28kdkX1imCj3rDYNTi9PKQBx9Cqf+N2Rg92o9BEdo9QA@mail.gmail.com>
 <23daf873-1e80-4e19-87d4-b9d54ff081a9@lucifer.local>
In-Reply-To: <23daf873-1e80-4e19-87d4-b9d54ff081a9@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Thu, 15 Jan 2026 16:48:36 +0100
X-Gm-Features: AZwV_QhPqB39-YZnKtB1aelwj3gssOzGzxlDIojgG8b_5pDZT-EK-AxWXwC4tUc
Message-ID: <CAG48ez2p=X-=9V64RfDQoP9C86D0mMoKS5Yc6OeWTnDp+vohvg@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>, 
	syzbot <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com>, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	riel@surriel.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 757BA120006
X-Stat-Signature: u1kko63mwkgu4smpuwfr9autuwpnygj9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768492155-89221
X-HE-Meta: U2FsdGVkX1/Epq+MxEkZLF2VFbTAIURkzCp0UemFhlxYKLEB6xmeHyg+pXFp9lPyMplCFhXeitwtNcvicYgPGoYH9DygWrtpduNbXuihHWCfj8ziK3gyHHw+E19rcLLsHyVNbsCnleWf7qyyrNImome3xxUA1MHK4K/4ZLgeZdNMQLevMWu/xFGvZinNpJWyoV73CQNvwPQHCVNg9ofWLEpmXgjTzo9dSbtajnwQJwtv1dEbJpZIRI7CMDCvHqNncSZa1SBPT3OIdIV5+lr4t1HD/EQ5+teL7osSEVkZuGl12wDXdpIcYOdu4QMgjwWhSn2RWm4vHrYQ3cy9Pesc0sPSaWrhb6AdRHdbOBZ42f75TYhvdfeq+1qr3170tFn4dq+ms92ED8vFVEOewnh3Gl6a2Fqz4vquuyTpKD3aabLTu0Xet3MgHhGghmtwjMbKij6PaTcw9UQBfkgBTJurhbqHbNEmI95+VK50ZXtmR+JCCkLfrVfSpOds2JGSeMnPiasPT+sdy4AeiIfuleOBRYVnSBfsR2CaIeELREC0vjYfW9hv3RSXAmyaxwr1A8a3ASiTC+ckYVIc3WrwBLnezPH6ndlWIUMQf74h46S0tHhesFU2FQzJVwykMFO0/KSEokdg0KfqP8OgI3MfGlxd85qsWjuTcUwLTs4Ne0crCw7dreG+Uh0YqBowggx6GeCT46d9iFQhTf/DWIgCUDz0PZ/Vyls4PrlWZNhWqSo6ErYYUGYIrseQHqEGWBDEKbGrjoJvrRSV/iWHZfnNCYmlUM14G4vFFB9dHxdLt2TR7OeUTNjMbr6t0MFdXIEcSvUbtLIGvdPg/8oGuzH3caI9Nj4pTZ5HQriUAlCQNvBMzrw2L2GkpB3geOm0a4sAuhG3LrYYlGbhqv79y/qaUuoBsdnAii35XmD1xnW1pX7BhcOqMBuiPfCq36sB63RTRlMFuNrBU/5VBVPE1lN+Mg9
 vr/FRlgI
 3ZtlgkzJ/e2s9hVbF/hpq4sf7QkNDfgeP5lUcvJWJ/TfnPw30IzEr4fn90XTINDp1S0XW16iPEczH3rmXs52K308BtnfJawHx/rtsTjKGjOnGetpbuHLn49TQ9mP53e+zd3PbuGMza4Tk5TqVUvrrl4AzTtO5x5M6L8AHP580JiQqHNCh7zEIP7X7MAIW1LFvcmGQDt7fhcP5aTh384ya7nQ+mBSrMGgGsgRhUslnJWWWKYMLn8bXq5wyGlM0Le1yDHAyGSL5ZcpTMHt2ceoe1MFisaPTvZS3XYBUbQ2nMsa7HHHc/AhQwACMJZ8hYGXfnlvMo8BPdIA5ObMatC2/iEHKXIpaXKJAE10ydWDeJRsFKlQwK3qLWphMeyWk02wyPr7Ff3stbtIfVP6zz4SN/ezWiozQWmMjkmSV8ZZsX20n+kjzofgQ2xQS+b1EmR1AwH9ILsa69/vvvsNdhGr4N30p8vNZn2mHGbCC9rEJDZgXoDEt+J2+U37Mhp3uw9WjRD2nGTaT48gWfoWXAKU35EVn3twC7LmuqOLG0z9ctct5iuHaHZeGzcW5ayhQY8bSRLyslTntGNmUs6BTiaohmmRJXSGn2ffrdH4+JqPfy9lqMzFRcF4NKGiBPVefVD2dyLPibOzfoaBPmJlNoQvqD4Ip8z23e7GJ75RBJvMCTetiFKAJkAYSEQ0yBtbtZk6worepG/7Jp0cofgBUVZ3on2tHxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 10:16=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Wed, Jan 14, 2026 at 07:23:37PM +0100, Jann Horn wrote:
> > On Wed, Jan 14, 2026 at 7:02=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > On Wed, Jan 14, 2026 at 06:48:37PM +0100, Jann Horn wrote:
> > > > On Wed, Jan 14, 2026 at 6:29=E2=80=AFPM Jann Horn <jannh@google.com=
> wrote:
> > > > > On Wed, Jan 14, 2026 at 6:06=E2=80=AFPM Dmitry Vyukov <dvyukov@go=
ogle.com> wrote:
> > > > > > On Wed, 14 Jan 2026 at 18:00, Jann Horn <jannh@google.com> wrot=
e:
> > > > > > > On Wed, Jan 14, 2026 at 5:43=E2=80=AFPM Dmitry Vyukov <dvyuko=
v@google.com> wrote:
> > > > > > > > On Wed, 14 Jan 2026 at 17:32, syzbot
> > > > > > > > <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com> wro=
te:
> > > > > > > One scenario to cause such a data race is to create a new ano=
nymous
> > > > > > > VMA, then trigger two concurrent page faults inside this VMA.=
 Assume a
> > > > > > > configuration with VMA locking disabled for simplicity, so th=
at both
> > > > > > > faults happen under the mmap lock in read mode. This will lea=
d to two
> > > > > > > concurrent calls to __vmf_anon_prepare()
> > > > > > > (https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#=
L3623),
> > > > > > > both threads only holding the mmap_lock in read mode.
> > > > > > > __vmf_anon_prepare() is essentially this (from
> > > > > > > https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L=
3623,
> > > > > > > with VMA locking code removed):
> > > > > > >
> > > > > > > vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
> > > > > > > {
> > > > > > >         struct vm_area_struct *vma =3D vmf->vma;
> > > > > > >         vm_fault_t ret =3D 0;
> > > > > > >
> > > > > > >         if (likely(vma->anon_vma))
> > > > > > >                 return 0;
> > > > > > >         [...]
> > > > > > >         if (__anon_vma_prepare(vma))
> > > > > > >                 ret =3D VM_FAULT_OOM;
> > > > > > >         [...]
> > > > > > >         return ret;
> > > > > > > }
> > > > > > >
> > > > > > > int __anon_vma_prepare(struct vm_area_struct *vma)
> > > > > > > {
> > > > > > >         struct mm_struct *mm =3D vma->vm_mm;
> > > > > > >         struct anon_vma *anon_vma, *allocated;
> > > > > > >         struct anon_vma_chain *avc;
> > > > > > >
> > > > > > >         [...]
> > > > > > >
> > > > > > >         [... allocate stuff ...]
> > > > > > >
> > > > > > >         anon_vma_lock_write(anon_vma);
> > > > > > >         /* page_table_lock to protect against threads */
> > > > > > >         spin_lock(&mm->page_table_lock);
> > > > > > >         if (likely(!vma->anon_vma)) {
> > > > > > >                 vma->anon_vma =3D anon_vma;
> > > > > > >                 [...]
> > > > > > >         }
> > > > > > >         spin_unlock(&mm->page_table_lock);
> > > > > > >         anon_vma_unlock_write(anon_vma);
> > > > > > >
> > > > > > >         [... cleanup ...]
> > > > > > >
> > > > > > >         return 0;
> > > > > > >
> > > > > > >         [... error handling ...]
> > > > > > > }
> > > > > > >
> > > > > > > So if one thread reaches the "vma->anon_vma =3D anon_vma" ass=
ignment
> > > > > > > while the other thread is running the "if (likely(vma->anon_v=
ma))"
> > > > > > > check, you get a (AFAIK benign) data race.
> > > > > >
> > > > > > Thanks for checking, Jann.
> > > > > >
> > > > > > To double check"
> > > > > >
> > > > > > "vma->anon_vma =3D anon_vma" is done w/o store-release, so the =
lockless
> > > > > > readers can't read anon_vma contents, is it correct? So none of=
 them
> > > > > > really reading anon_vma, right?
> > > > >
> > > > > I think you are right that this should be using store-release;
> > > > > searching around, I also mentioned this in
> > > > > <https://lore.kernel.org/all/CAG48ez0qsAM-dkOUDetmNBSK4typ5t_FvMv=
tGiB7wQsP-G1jVg@mail.gmail.com/>:
> > > > >
> > > > > | > +Note that there are some exceptions to this - the `anon_vma`
> > > > > field is permitted
> > > > > | > +to be written to under mmap read lock and is instead seriali=
sed
> > > > > by the `struct
> > > > > | > +mm_struct` field `page_table_lock`. In addition the `vm_mm` =
and all
> > > > > |
> > > > > | Hm, we really ought to add some smp_store_release() and READ_ON=
CE(),
> > > > > | or something along those lines, around our ->anon_vma accesses.=
..
> > > > > | especially the "vma->anon_vma =3D anon_vma" assignment in
> > > > > | __anon_vma_prepare() looks to me like, on architectures like ar=
m64
> > > > > | with write-write reordering, we could theoretically end up maki=
ng a
> > > > > | new anon_vma pointer visible to a concurrent page fault before =
the
> > > > > | anon_vma has been initialized? Though I have no idea if that is
> > > > > | practically possible, stuff would have to be reordered quite a =
bit for
> > > > > | that to happen...
>
> OK I'm confused how we can end up with an uninitialised anon_vma actually=
?
>
> The write gets ordered before the initialisation, somehow?
>
>         anon_vma =3D find_mergeable_anon_vma(vma);
>         allocated =3D NULL;
>         if (!anon_vma) {
>                 anon_vma =3D anon_vma_alloc();
>
> WHICH IS (maybe inlined):
> ******************************
>         anon_vma =3D kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
>         if (anon_vma) {
> |-----------------------> ??
> |               atomic_set(&anon_vma->refcount, 1);
> |               anon_vma->num_children =3D 0;
> |               anon_vma->num_active_vmas =3D 0;
> |               anon_vma->parent =3D anon_vma;
> |               /*
> |                * Initialise the anon_vma root to point to itself. If ca=
lled
> |                * from fork, the root will be reset to the parents anon_=
vma.
> |                */
> |               anon_vma->root =3D anon_vma;
> |       }
> |       return anon_vma;
> |*****************************
> |
> |               anon_vma->num_children++; /* self-parent link for new roo=
t */
> |               allocated =3D anon_vma;
> |       }
> |
> |       anon_vma_lock_write(anon_vma);
> |       /* page_table_lock to protect against threads */
> |       spin_lock(&mm->page_table_lock);
> |       if (likely(!vma->anon_vma)) {
> |---------------vma->anon_vma =3D anon_vma;
>
> Am I totally misunderstanding?
>
> How likely is this?
>
> Given the anon_vma_lock_write() and spin_lock() are we not avoiding this =
anyway?

Acquiring a lock is an ACQUIRE operation; the "vma->anon_vma =3D
anon_vma" can't move up before the ACQUIRE operations, but something
like "anon_vma->num_children =3D 0" can be reordered down below the
ACQUIRE.

So the sequence

anon_vma->num_children =3D 0
spin_lock(&mm->page_table_lock)
vma->anon_vma =3D anon_vma

can be reordered into:

spin_lock(&mm->page_table_lock)
vma->anon_vma =3D anon_vma
anon_vma->num_children =3D 0

See https://www.kernel.org/doc/Documentation/memory-barriers.txt , which sa=
ys:
<<<
 (1) ACQUIRE operation implication:

     Memory operations issued after the ACQUIRE will be completed after the
     ACQUIRE operation has completed.

     Memory operations issued before the ACQUIRE may be completed after
     the ACQUIRE operation has completed.
>>>

> > >
> > > As far as the page fault is concerned it only really cares about whet=
her it
> > > exists or not, not whether it's initialised.
> >
> > Hmm, yeah, I'm not sure if anything in the page fault path actually
> > directly accesses the anon_vma. The page fault path does eventually
> > re-publish the anon_vma pointer with `WRITE_ONCE(folio->mapping,
> > (struct address_space *) anon_vma)` in __folio_set_anon() though,
> > which could then potentially allow a third thread to walk through
> > folio->mapping and observe the uninitialized anon_vma...
>
> But how would it be unintialised at that point?
>
> See above.
>
> >
> > Looking at the situation on latest stable (v6.18.5), two racing faults
> > on _adjacent_ anonymous VMAs could also end up with one thread writing
> > ->anon_vma while the other thread executes reusable_anon_vma(),
>
>         if (anon_vma_compatible(a, b)) {
>                 struct anon_vma *anon_vma =3D READ_ONCE(old->anon_vma);
>
>                 if (anon_vma && list_is_singular(&old->anon_vma_chain))
>                         return anon_vma;
>         }
>
> Hmm... again I don't see how we're finding a mergeable anon_vma in the
> adjacent VMA which is somehow uninitialised?
>
> > loading the pointer to that anon_vma and accessing its
> > ->anon_vma_chain.
>
> The VMA's anon_vma_chain you mean? anon_vma doesn't have that field.

Ah, oops, I misread that code; so I guess the first potentially
uninitialized read would occur when __anon_vma_prepare() passes the
reused anon_vma to anon_vma_lock_write().

> Is it again based on the assumption that on some architectures we might s=
ee
> a write of an allocated-but-not-initialised anon_vma?
>
> But I also don't see how this is harmful anyway as anything that touches
> anon_vma state meaningfully has to take the rmap lock anyway.

I think the rmap lock itself could theoretically be uninitialized, too.

