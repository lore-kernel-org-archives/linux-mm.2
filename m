Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D63C5DF93
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4CA6B008C; Fri, 21 Aug 2026 10:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1846B0092; Fri, 21 Aug 2026 10:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1846B0095; Fri, 21 Aug 2026 10:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 463FF6B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:49:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA459120178
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:49:13 +0000 (UTC)
X-FDA: 85125559386.30.DAE8C09
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id D932E120004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:49:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QPYnsWjJ;
	spf=pass (imf29.hostedemail.com: domain of jannh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787323751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vlc/iU0BEBi/KNin4z6a2IXssoOeWKNQCCK9ZmekGRI=;
	b=zzHOxgDv+K0v6PawmPtm38lTAMkN7IHd3d+PdvlAoUZHZ9qfb3temCzKVzv1aCn7zbfU78
	wc595DsXtjFO4+fOcKh5KfS/OgTsILOgkzeqajTLvlSlCAyTospZr7i7IqM5N7P+1w0pcg
	/KQTjOY7l8ce81tyU84uAF9eL+trcMo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787323751;
	b=PGfufqzEWBGj9J/Miwygk2m2paS5sOUsuKKm2525x2e8ylW7sdLrQNM0KW6Py+AMPDTIYa
	85FqDkNHHxTguFkOzHUHNirAhAOz12xzg0zoCaeXW0icDrLWlyFyNmwwKfDu5AKZoPoyML
	8gjF3/KtXXuXhP0y7zS3eHrRCFWwlcA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QPYnsWjJ;
	spf=pass (imf29.hostedemail.com: domain of jannh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d3b445a84fso79745ad.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:49:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787323751; cv=none;
        d=google.com; s=arc-20260327;
        b=Md1eodbhmJmk4z0H4lxTL+Qe4vhV94Iy7xoHd62n5cJB+DMCOiz+gkRHShhXMDz3ay
         yodWKfDa29V32cR0rp9wxzcP6ncJtYwnLHyW16wwwLoKmrDP06jYBpWTkSQ8FVu95G/I
         J+V69w0G9Lla6EL5LpVfHfxb1iUnG2F4WM4fE2z2Tilf5/52d3DCjf+hbppOkmgplawV
         HSF8aUm1l3xAmSf2DQdsuvG6aBjmaAluaby+6dQ3dvrlaow2CYiqkU4LKPqkrcxoEZqu
         0NWIHsTIlD5bKBVNtFfi5eFMITaYdb+x/QIZ/f0PIu/nXDPyMgch90EJRdy/YYYKQrGG
         m2fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Vlc/iU0BEBi/KNin4z6a2IXssoOeWKNQCCK9ZmekGRI=;
        fh=BmSWEJQvzdxI7//EefCfHoa6htiWjTXq9kwBBCZiAvw=;
        b=LJF1NLAx1NrUJO2Gz4wWf0EQLkvTqLusmoq9WuRgh6CpurKP04mJiD6xHfSQkfQsZZ
         ykWqgBVOLI7tWYKY6QClMrxTnWeUk1HmKjKslxxLWFGKO4AIQqIYV5jMs7HEtWw1wWO0
         WLkrjjFkGMXg7U15gLsXzvC0q+IPENEBWEjN55SeB2zNMFLpEu43CIHmbaiS/rEBLQc+
         fL01RBy9R82qx3gZF4efvX0BquozNzywNKy6zroRDs6PHbsK47z57zX6b/xH1bBTFGJ8
         oQaFOrHbw1+vSiuZWUB2UUlr35stNXiS0mCvT55H3H6ZzDtRXA7b7VRQIr/DC7aF1+5J
         VbSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787323751; x=1787928551; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vlc/iU0BEBi/KNin4z6a2IXssoOeWKNQCCK9ZmekGRI=;
        b=QPYnsWjJwaVlKYQ4BvGCfWf1hVDG2CvpEi6N6Y8QP4sFwVnW9DMUM59lXwd0/pn8n8
         0MJt1RVuNCJOqqRM+x1zT0mzdrZU/lLhZplzlmSbDwKhsGOe6Nni+F0HWpLZEnYq4rSl
         LcARe48AAdlyLx9e5Kh5yC1jpqOqkaQApsf2qRve0nqagwVrrRqnh7Ck4lXKCP5qx6W9
         /k/PO/5Xqgm18hSe0qKgYIcRBuKZJirGx/HoxtGsNilBygKXesM3Jr+Xmy9ZHntWi8d+
         pTjb3fX6n19FcDOlTsUn3Lddc/eYLIQoM/FMt+VuHuPEnzTRNPtT5dhy8Qs1L8h7GW0E
         xUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787323751; x=1787928551;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vlc/iU0BEBi/KNin4z6a2IXssoOeWKNQCCK9ZmekGRI=;
        b=gW04D1gpFuacsOGG6zbL3lzvPsrIJHMTDCOOjf2efoIeq+33YOLHNYXnXi2MYi+Ts0
         6fIAzna5HdVCjzpNMzQYYh0C5apHeM2t1SzACc65rEQ3710tg3ymdAyk5xq6eCue5Gay
         fBt6duQF6uP5W2R0xY7TI2XVTmgq9l4ReT2xoRI/awcLJVBy4Do0t4wgKPyo96B4tda/
         hLHwpypict1k2u3/XlCfyPk0vrVDMfDuv6zxkEDtNQcqCxx0VZ6MoQZ+6VLfV0G773rT
         OsavBVmOQLCez58rXEWd9kMFbKxFesiRYzTy4+LHWqAAbTdDvmxv3nnjugjgVtuMeHPn
         zW7A==
X-Forwarded-Encrypted: i=1; AHgh+RpUJeDbkLV6aqXEg0x44xz3M3f1OmK4npu6vbfCsHUzINQicIhZW2gs8MbI9fTBXHTNzPa7tIhGnQ==@kvack.org
X-Gm-Message-State: AFuF++lRxdAnt7dBtowMaTMuz9ec/yabYgB+uNzSJi0rwDySU8BF9Bgc
	aGGnl9AZpdaCzW2+i/U+54U03mzhjvKO2a/XfOaWze2Jxb8aLdKfkZdoswp782kyhfHxtfk3VLV
	W+IjKa6NN4X4Fsw67GSqh4OnC0+0tHFDY/QqqENRW
X-Gm-Gg: AR+sD12Oy8h4Sr0j7ulSScAzYcVlG3bv3Utqhut9K0i0nnnxBWarAb6QPYfddScPg5J
	gPBcExRYghzC+vCDu4lRi9vWrPyJRsaNRA4Rk5IfH3SZamfk0/fH1vYzRt9kQVWKYyrKvjUG76+
	lk1SZbrG56JzBXCEI6mKIBphGpudW5PhP9bM3o5uPG/ScUa4sEWHtx3mCn2V3DHHXIL5ff/kxyk
	KiZ3sXAwbcj0FX2Zm0Br+8Py0pZKJ/BT0n6SuU/2yedv7D5P608u8jyQk4spfL247xNjNBuGzQ8
	C04vJIFwDXvwb1Bo1msc523hFY1fk2+T8Q2rKfHprEnMmE5JcjaYqTEN4s/LKgTGhuObTIWJp5K
	noAmU+oghHDKOSlnXzGekh3MDI7lKutowSaDfvMM=
X-Received: by 2002:a17:902:d98d:b0:2bd:3bfd:74f1 with SMTP id
 d9443c01a7336-2d64b0242damr7580045ad.2.1787323750012; Fri, 21 Aug 2026
 07:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com> <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
 <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com> <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org>
In-Reply-To: <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Fri, 21 Aug 2026 16:48:32 +0200
X-Gm-Features: AcwNN1XIz1KzlKUYbPV7VaC7KEh2VkyaYQONO-MSpK_iCwFkMVBjZQBPINMVB_Y
Message-ID: <CAG48ez2bZEV+3ww2x9XV_5vRPZ_3jU_zg6+h=BDKQ94Xrd3Tqg@mail.gmail.com>
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: bzyp3pkeqt7imdbqtc3iq5twp4xxdnd5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D932E120004
X-HE-Tag: 1787323751-561712
X-HE-Meta: U2FsdGVkX18vyE7frZmhiOTNaRAO9sTSkyouwkivAYMiuFS5NyKrFD9s8QlaLl0Xkkbf0s2V4CFC1TfUJ6EwExDVSMTA5m7x0tCMc523ZQtdldfk6KoAEJDj9SIlwyd2+zRWIe478Fc+a2oTIHzkYpA38ILjnB0y4Jrnbq7yfzMrxFCxPklEEySmHMBmsMczCL+/tFpRANFaD04CHXJCJAHphh0lzIoi5Pqq9plD05hbVQp756kJczmyWq1b4i7+fhxIzvF9twe7fh12AiaUzVOrlKwfKeE5gN/H6OvS1Del5qY3jZLNAXyWd1uXc9r4z63wurbOhdFD3xQwECPflCPbRTgK8BSNr2MVFIaKX/9nsRVC+aG8FIJDGlj6r/kreG8tNwhUm8vJEaNoXDaBuUBCJBedsR3MAEqcAvV9nDJmMC+PvIAPZX2ske5wwHBgg5CYbLOT0EOWUORCFg2cgZB3t4MFWOm+DO9yr7YXMUhtozPdIc4H3Xaf3bbdxtnYEXBTONfo5IJ4U7AaSt3M78nwKgq1u8BP0U8GscqjMFp6nUYDw8nPWIRwxOJcSG/edifPaaycgtJU5at0vcD/undzB7uPPVYzbOarZXS4bBhvh/nYN/Ed4gr7G9z+xg37wDb+9exUtEZg67e+8dn1ljE0CgNXRDL+EzBPfmmNQZGo97KBWEXPPJ+1ljPBlf1CI/fqQP8E69a1nOrTVKlPjlyMBElz5SoPZibTTcx+Yeui3Ztw7a64kt/dDVxOi30oAqy05rg9XiGBHbTF3gTeD3slFKkzNAhVeLFV57Y1z94D5LmMIm3BkBQjrpJgqFqYqW6A9gAyoxT4xYfA5O3wTv1ZY3uvioVjK7tat8JLTAS+grFgIwvpNTmOU2yw4MECHlkUvAsracb/DbgyjJ9O3jnQk1UF/o1osCS4fCVvdhnnMkw6VLwJnu+j2w3kEFAu4B3cgG01F/2e4I7Am7F
 kubeKSNz
 Huqg/xvd9KR7/YIemtuiWW6xhbE+17eZnr6qw9aSScsfKIzEpTKij8iElHyAlnfqWhXwqBfrWK+bI6FvpCY36ivLPxN3aEYWvfN0LkAbm0+5ifz4NXQe6md3X+p5A7xKuYjEi3OIwYOVJmZyhxKApbFtJ3OlAV4LjvSWnlIhZGlQji8F/Dr3iOEyuFbZ84vvv11dp5V8u8xqTD/Q+P/HPyXBxjb6zC78b0KBTguY1V/fL1RIfWn2uGJKanlau3pa6w66GKhyqZ5eSMFwDU0Wmgn3VXLCXL2hoxOCDDMcsvb0pigtF6cLd8SsYs8WS/G7dGDig75Ed4Ey7ayyLU1tABc6OOOpsFRcq3l0GGbC9m17cJ0Ae5OBZ4D4+f1Fr+70YfPydqc5rDZO8GovUYFw3zPbKZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 4:19=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
> On 8/20/26 20:44, Jann Horn wrote:
> > On Thu, Aug 20, 2026 at 7:22=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >> On 8/18/26 21:51, Jann Horn wrote:
> >>> If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently h=
ave no
> >>> good opportunity to block a process from overwriting read-only code i=
n its
> >>> own address space through FOLL_FORCE writes via /proc/self/mem.
> >>> The security_ptrace_access_check() LSM hook is bypassed when a proces=
s
> >>> opens /proc/self/mem because this is considered "introspection".
> >>>
> >>> This causes a hole in SELinux EXECMEM enforcement, which tries to ens=
ure
> >>> that a process cannot create executable anonymous pages.
> >>>
> >>> PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> >>> accesses are only possible when the LSM allows ptrace() attachment; b=
ut it
> >>> is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> >>> environments running lots of third-party code, such as Android.
> >>>
> >>> So, introduce a new LSM hook that can forbid FOLL_FORCE specifically =
for
> >>> such "introspective" accesses.
> >>>
> >>> Signed-off-by: Jann Horn <jannh@google.com>
> >>> ---
> >>>  fs/proc/base.c                |  6 ++++++
> >>>  include/linux/lsm_hook_defs.h |  1 +
> >>>  include/linux/security.h      |  6 ++++++
> >>>  security/security.c           | 15 +++++++++++++++
> >>>  4 files changed, 28 insertions(+)
> >>>
> >>> diff --git a/fs/proc/base.c b/fs/proc/base.c
> >>> index bec6197329dc..3dfaef49bb70 100644
> >>> --- a/fs/proc/base.c
> >>> +++ b/fs/proc/base.c
> >>> @@ -851,6 +851,8 @@ static int __mem_open(struct inode *inode, struct=
 file *file, unsigned int mode)
> >>>  /* private_data for proc_mem_operations */
> >>>  struct mem_private {
> >>>       struct mm_struct *mm;
> >>> +     /* Was the ptrace access check bypassed due to introspection? *=
/
> >>> +     bool introspection;
> >>>  };
> >>>
> >>>  static int mem_open(struct inode *inode, struct file *file)
> >>> @@ -864,12 +866,14 @@ static int mem_open(struct inode *inode, struct=
 file *file)
> >>>       priv->mm =3D proc_mem_open(inode, PTRACE_MODE_ATTACH);
> >>>       if (IS_ERR_OR_NULL(priv->mm))
> >>>               return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> >>> +     priv->introspection =3D priv->mm =3D=3D current->mm;
> >>
> >> Is the feat that the fd could be passed to someone else that would the=
n not be
> >> detected as introspection?
> >
> > Yes, exactly, that's the primary reason why I did it this way.
>
> Okay, would "opened_by_owner" or something like that be clearer? At least
> "introspection" is less intuitive for me.

Ack, I'll rename it to something like that for the next version.

