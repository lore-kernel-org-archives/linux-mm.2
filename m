Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B041C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F89C6B009D; Thu, 20 Aug 2026 14:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A97A6B009F; Thu, 20 Aug 2026 14:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BED86B00A0; Thu, 20 Aug 2026 14:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6B4F6B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:44:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8610EA1C05
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:44:52 +0000 (UTC)
X-FDA: 85122524424.06.D9DF9FB
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 980D21A000D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:44:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HwJZP9ut;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787251490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ra+u2k+WGBbYHMuPstN144hB8VFxEn7aIl8UwdTV5yc=;
	b=gSBszIadN7VpgOP+emD9e68wbBQRZz5Udq+VylpY2+Cj8va6OdqFubvQFoE8fGXIcvGJx/
	ua8TAeGZLomOACNFbYIZoUX1DQeMxtQ+P+ZO5IgpxRA2t2p79/BfGo5mWNvb6oaCtWpspi
	aV2mQwqaS42S3ARZQWiydkHPvkZI5Fg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HwJZP9ut;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787251490;
	b=LF28eo4dt/+1RWqDaDvwf93iztI801dmWuuw8PjVQR2fxcu3ZOs8J7CrPolYJf8dOl1b/1
	tpESnYiVLdjHZfrclnF1UbcLNkrKwz+Y0rIeoiesx3+yChh7L+cVLMTbVAuJxGeCsHnBib
	rOU1L4i3K73Zt4ZeMmeqIPLDimR0xLg=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ccdf36f63dso13495ad.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:44:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787251489; cv=none;
        d=google.com; s=arc-20260327;
        b=cl7ySJ7qwG9x0njUCX2MpaLtq39x524Ybsw/M3isaqySejkMv4ogQ9dyyvuA/cR1IC
         DEAjoEQdYNM7rTIeOEKh0i0UxIgb1VHdkW4cA15hneAyuoDEAJaxC/4GzwnChryoDdYd
         4NdRv32/pXZADJJgFQ6adSsb83H5MbX1MJ4MEu4T1jBTUw1PwGLPwJYwo7IxESCsTkvG
         t7uib8vjeHYVcuOZGy9/l0DmSsMp/NWRzjnrVDzvsyBHV0xQVTRvgy1JSBJiasRPN5f+
         JKqinDXNPd4Yl7BNI50Pu5kPog0ellDQ/h1Ei30TL/gnJDVTCSo0vh+qPQ4YT5ZFpBKy
         njvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ra+u2k+WGBbYHMuPstN144hB8VFxEn7aIl8UwdTV5yc=;
        fh=IS2Z2J0Ubi9XZdzJGNMhphmBuzKlHOVgGtmGBvJM1n4=;
        b=SBAxftzMA6LPcpd02LG8VE9GTyMYn4GPzD1jfq140/bt1hGNbKl6fMH9vN8oEoyjTB
         D2e9/kvzSAqioNxEdbSwYz80O/JRdZw7PzmIIHdG+G/Yli+JK28zWlKUuVgrJaENDIPT
         NoKnYLh7WXuet0XcyzPc8UdvOufLN6FHk8u1xORnjlG837tFynVE5SjASu8rwoU21PJn
         7q8fGCQj9l7UYiH5XRjw0tjE00EASoiJ1KegD5k9Y8QNWjsZnxmnlofdi/I3cjjxcM1T
         HZCcnQ5G8AS0c3QVVCOUg9TA2oj9U6WQLVxwbu6D+OwwQpgIOc7vvu7x/8YGEx1qdwIm
         flWw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787251489; x=1787856289; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ra+u2k+WGBbYHMuPstN144hB8VFxEn7aIl8UwdTV5yc=;
        b=HwJZP9utXIl9VIoUcsTsqWtQ6sBEzyi8WA4n/9+Onc8LgQJarNcDJ+dVJy/MtjcmuQ
         RMNqznLu/N8wVV6ces0SwL+RbnogNkwVPIcwE09BsCPkfmkX9HN79/mFE8Ty4HP3lCd2
         WQk0RwV6l8KEarPc6cGe8j+DcBa2WEZKUqA9c4q9fx1h2A130oDiGPKnANOJxxiQXlYi
         B+F7fiWNmeEyNp6ITdUl43c1bB9xmuCLC7GBa50IbxRc3mRsjG9hNrtdN+rD8uJXjI/y
         zZK4vYMoUC3A+oU2rdfeDEOH256URTAuuAB2HnMARhSzfvlU5w03EJt1JbPYSVMeN+ya
         NYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787251489; x=1787856289;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ra+u2k+WGBbYHMuPstN144hB8VFxEn7aIl8UwdTV5yc=;
        b=lV0lmncWittl8dVaGh3WDpBtn+OQf4LGzs2gsBvmaNhjwSpCdMDpCcpIDrh+ZNsDBc
         jZeXK3sWUKdKBoMFCsvqpEwalq/53VeAOsW8EIVKPGNS6ToEcer+vpYOFKph85tE9Iu0
         JldDKmTHeXFtLDXor9FevFrTLPr5b0nIGe8eQP1wM7/mvB7WVoP43DdYETegsflhjwAu
         3GavQeFkQkr6g18zW2ni3/8Xxt+16W0RbP53DmPajFyqARoj+12Ni2r4rYwxGAFedKaf
         FnOfx8ymB3WOPNi1aF1XxM9ExWTFopuXm0nMwHPRg/Z3B0V3xrw3hUFz8ukYmCg9lt5E
         wvsA==
X-Forwarded-Encrypted: i=1; AHgh+Rqt3EfeV0fwzgbQdDPYcQE2UxQAXMhkPmks8g8CtdZCC1/U918AGlIhIalyi3kmIk4LxoCzoFcFuw==@kvack.org
X-Gm-Message-State: AFuF++nlNrQX0o7cx3sgA8inm6shUkgyDkR6/HY7aqEXQICToy6z+jxS
	zbwzrUO2x6IdJsANuMx65iFN5RWcJpAv6Tg+Sqvf35d03QuqTaHN5sTNnFajFqTdMYtS2d6Ao1N
	QjxOIb3+PwYHQ/sJsdr/SNWN1adDG+VcyX7pey/8w
X-Gm-Gg: AR+sD11CErhLVi8Ss8FYTWFkoDScPV8ThJszLGnxjmIeUvsi+uJ66EYbaBBYRd63hrM
	3LFuh1gnkUDvGmYwVn3Fd9rbSksoyq0yzXBEdml8Pe22shs+4KXcYC20l/O6I8nE7lXQYyOi8vI
	HN5RZyvGV4ZgK8IzXenoXpiGea4BCcls9Gkvp9PZ7/ViGroVFgTzGOFk0GltnzKQ3mJQMlyNm5b
	VM9pCeOXQwZdhTiJAhOJpUqigQ7DTezfHE5sf43gj/TsOGQJm4TfzhJDpjT7rFud1anlhi0J0yQ
	0nE+M5g8uCSdYH+9F64cwmQwxQpe9dEh+TsI+vX914jviCBZI33xubUUO0hFFAX3ArxU1KqWg/W
	yTeNTDHzE/wVYIRXBsP+IUWVcm1mBnA==
X-Received: by 2002:a17:903:22c7:b0:2ca:cbe5:c3af with SMTP id
 d9443c01a7336-2d64b50af9cmr824745ad.7.1787251488719; Thu, 20 Aug 2026
 11:44:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com> <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
In-Reply-To: <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Thu, 20 Aug 2026 20:44:12 +0200
X-Gm-Features: AcwNN1WPc46lB25I9dlQYQePR9UcO75mKPz3cBjmzriG3esMrA3mvmTFFADdtWE
Message-ID: <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 980D21A000D
X-Stat-Signature: 94eb51nyfaunjbwnj1m7jjeckdd8ge7q
X-Rspam-User: 
X-HE-Tag: 1787251490-766621
X-HE-Meta: U2FsdGVkX19ZMzeAXuuOYHTv3ct/dbm2scbCH53NHyGFrN3roKBY3WbgfrnXyA+MPNdYe6T0VPkMIYCBDV2lAJSob2lq0KfOTq4sMI7LagLqlIJMJGvfEluKc/WYxt+/zu7is6Q85tNUG64Sa+yPI5XTdVlR/eeE1SLSGt1ZJmy3DTm7jjQWVWCVON5nPlabk0NPD/VGBg56np/tJXpEWEBdeN76jT2r1+M+mKUyJ0XEv0fyjFBZfZtkAGSh4U6ncKJOB/0Waf3EQJWvrlP+u/s2JVRFpwaL3o8a4yg9vL9CPjDDSjn+RK7TOklh1+r822r3eWfVoEAzTQtgoNpfLc1Iex4W3K4y4GbiSr+BQSen1SnAnKETInMvQPmJZwPrZNZprJBSNCtGwojV9KBx14W0wEAmcoB8jGvXJalCjPz79+UxU4BKCEcRLrzvycY5H2iWAnmRmiwDAmraZnd8ieXa0+IsCkUdG4/1KCR1E29MBlXr4+fNE4eek07kX9HO4gAf3FNKHGXK96G5hgrUW54iuy55AhO79Y38Fl3plCw4vlj++FhD7hNj0q8p2G3S7lMCpeOTmk+c/oT0V8zSNQDnUgIBFpXIsFiRBhtycZ86qD5nXE/F/EBRXvwAZZ08FXtA/B8qZdkdTZE1UM7gB+OOVlAI+SFuN72XUmt4OAaPjsy9iNhYOxcmDoXyhupIbjrm3xQVBZtn87r9meJaNzCipFpm2yEECGS/KFC9xpXkWf89vomY4CCSq/B5PyG17V8gwb6+hhiN8BhvV1kNDGIPfVx8D9UOcldtKoYDDsJVElCsCiPC92bayRarLk70QwcaWe75aFU3fUxFiYHoxJirzFZCCW2SJMcK/UPBg5VBnV11hXpifFcj5hZ3DHHmGtNGezUqFK2H20nunJG4r++D5rsSD7QCBFO0IBuy8YF2ruYBQGOMcD/2Neu9ar9ebfQyk+AKID1kd0XeDEa
 D8F22yAG
 xYJH+yNgsfmr11hF9+h1y5qiSJGDC1CDwJNpUQ4t3yCehFmtMsemg9IM8B5JmY41m6ggzqRg4UVQM9UwjqkLNiz6rHRUjJRwb1xPD0354zR3SY0+9o/+VALu06X6vXNvWSc+oiVyf0yxJqOPpKdlKD44b/pdfx+rTomPcPZb2sshp4uD5ssGpUA0FEN+KSD8K7nH7wHhKFlws92memlFtGgsp4FuPm6ccTLsLP5SjchVvFIUzkQqA3v1uObq4XfPQacbOG1o1uD1FseQJK6Jba+Uod/iRlFg0mzSQMOY3Y9aJRKjw5kH/SrWHquG0VUhDRP98cxOUbcfYfTolBIl+0J2CsjHJe8f1V7Q+r3B6dQI8lNLe/deIeF9bWpBzw+xSXSepcdSDS+smmXh7+8C2d22oSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 7:22=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
> On 8/18/26 21:51, Jann Horn wrote:
> > If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently hav=
e no
> > good opportunity to block a process from overwriting read-only code in =
its
> > own address space through FOLL_FORCE writes via /proc/self/mem.
> > The security_ptrace_access_check() LSM hook is bypassed when a process
> > opens /proc/self/mem because this is considered "introspection".
> >
> > This causes a hole in SELinux EXECMEM enforcement, which tries to ensur=
e
> > that a process cannot create executable anonymous pages.
> >
> > PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> > accesses are only possible when the LSM allows ptrace() attachment; but=
 it
> > is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> > environments running lots of third-party code, such as Android.
> >
> > So, introduce a new LSM hook that can forbid FOLL_FORCE specifically fo=
r
> > such "introspective" accesses.
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> >  fs/proc/base.c                |  6 ++++++
> >  include/linux/lsm_hook_defs.h |  1 +
> >  include/linux/security.h      |  6 ++++++
> >  security/security.c           | 15 +++++++++++++++
> >  4 files changed, 28 insertions(+)
> >
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index bec6197329dc..3dfaef49bb70 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -851,6 +851,8 @@ static int __mem_open(struct inode *inode, struct f=
ile *file, unsigned int mode)
> >  /* private_data for proc_mem_operations */
> >  struct mem_private {
> >       struct mm_struct *mm;
> > +     /* Was the ptrace access check bypassed due to introspection? */
> > +     bool introspection;
> >  };
> >
> >  static int mem_open(struct inode *inode, struct file *file)
> > @@ -864,12 +866,14 @@ static int mem_open(struct inode *inode, struct f=
ile *file)
> >       priv->mm =3D proc_mem_open(inode, PTRACE_MODE_ATTACH);
> >       if (IS_ERR_OR_NULL(priv->mm))
> >               return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> > +     priv->introspection =3D priv->mm =3D=3D current->mm;
>
> Is the feat that the fd could be passed to someone else that would then n=
ot be
> detected as introspection?

Yes, exactly, that's the primary reason why I did it this way.

