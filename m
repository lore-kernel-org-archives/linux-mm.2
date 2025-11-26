Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 388BCD10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 14:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 585E36B0024; Wed, 26 Nov 2025 09:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D206B0026; Wed, 26 Nov 2025 09:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BAC6B0027; Wed, 26 Nov 2025 09:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 327866B0024
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:26:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7801160608
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:26:40 +0000 (UTC)
X-FDA: 84152984160.24.77C7DC3
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0622A1C000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:26:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tDI8hikf;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764167199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VPPLsvVDEd9CTC6yHY+fYpwZTiGy4/39LYX3I9kr9M=;
	b=Nh7Vt8QzEL/Gdc7BznF41h5y2kF/XaloIhfoaF8ynRj369bISF98aq+j0gS8G9yRHHSM0u
	fBxKeDHOMGBNmDTpdU8tLEagZ5jh5DeZaCjiHFlBaKZt1Ae+MAchukfAohWRTVQthQXiHN
	fCGUlDivgCHsp+NbbSpiklVUygApJ94=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tDI8hikf;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764167199; a=rsa-sha256;
	cv=none;
	b=zmK6zPY/1Z88+wQ38ZjQfTezGPfOc9B0X0PjnW5qP4t8ya3tEmzjdyFlbSMcX98xtKGrcu
	/wtkZpxZskQUO4yl617qAddSPfhK8K/WVp8THXQ1/h9C5CL21qV+M/DIm/UbACrweko429
	cQYimvQUrQyaVa/1YiIB8kx0rXpnfyc=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ed67a143c5so364381cf.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764167198; x=1764771998; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5VPPLsvVDEd9CTC6yHY+fYpwZTiGy4/39LYX3I9kr9M=;
        b=tDI8hikfJ5k7+fOcveB2MsWcC+wcwLDx3+Dz3IkqtGMWTX4xlHdvf9NsiA+8O6Spcd
         EGhLDAJDa4wMh6EwhWhzd6cV+aElZMxCwZZk3SCxuQqIrRl8R5M81t+5kJAsO0/y78Tj
         lLNUb78yW0ZnTAbdveffqCYu35wYve2RwcahU6v/YWrWAQJSIuCYbP05gu5qbbxezsUp
         6aCnkXw9tyL4Q+r2yz8/OoTUw62Ml8/ZGFd9bC1PRgerKe7RNMFt4AkY8eYZhSMT4pHe
         7ZqDuyf6R5OU9lKByul3LZHdMowO2XS3wpXPnZCbKwbQDltdo7Bc4SklPPxS3biLcR6v
         EMzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764167198; x=1764771998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5VPPLsvVDEd9CTC6yHY+fYpwZTiGy4/39LYX3I9kr9M=;
        b=SRsy2upf8MQ4/ED6XFIb9Vq91dGzH58Ngs9RPHWN1SQkElEUR9parhLZmJSJ059Q3F
         92cjKDA+GROKK/dCpc8K8h7Kdl4InfVWY9CvpoVcWg7EAlraGEvNiyq4UkBq0KnwcpLJ
         JwzjAJesqO9lElF0xIWpBpHOjv1MftuLIt0lxslFAuu2akHWgdj9ObpVaLZTeNw17mmj
         fSIQL9AT238xUndhxCfZVmPA69qug7beI+6QpekeM0lxV3cbkevlrlIfgIQNkKi3BDzk
         MWYDxWzgAXzvemp6OKG5tbNYmUKRrnDxvu6nUFEDPIusHPfo42oGowps9FzlnRWJFWRt
         Q/5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUhpj00uKfnLnac0g9BDZ4QNSJld1NHKiyFn/QC2fC8Ae8HIjJlvKF4sU6S6gvDCcLQoRiuHp1+tg==@kvack.org
X-Gm-Message-State: AOJu0YwbDB2/oAc/RTQkWXuU8s/ADJNI/LX97Qgo5hPwD+fI+pd17GLS
	zADAJ1guju+6UERPI2Wnl6URK5Jg92W2eIjh9gqGOiRET5DP+5tqwYUWC3qgzuNloKzxe294D/j
	ixwyZU8WERq18vRHDHyKBBRfiJtzVdGTHBTa3h0lN
X-Gm-Gg: ASbGncu14fhJkBcM7H1bjMzhOdKbUIoECdmGUkFeA4CUOktL/e5fafq6fleli+0/iuz
	grP5glJq9DosUeS40E0YWWgTxaRyOwGIFYlzCKHaHWU1sSeePnjGvVRZAR46JMpCifBRpmZDMwm
	ApS3zlJIAxNnTENfEDwIOOJKuKYhlK/Uzbc+l24ZSrhPfByl1iExpGWC5tcW0M/cAJeAOhyyEtl
	IgWRlgtNXLFn1n6E6/DgeYb6jqtsR+kCIvTq0B8jEehI6fDZj5Lof01leTY7Qb3Lr8Q0g==
X-Google-Smtp-Source: AGHT+IEPoAZkKOpilwPAptI3s0B3tzdeW3nrnf6UAjdN4XbCU5wZqigCPTnmNHhnQhINBzyTNTpE3TKtJR4B94kNn4U=
X-Received: by 2002:a05:622a:1653:b0:4b7:8de4:52d6 with SMTP id
 d75a77b69052e-4efc6b0dc4amr5433441cf.2.1764167197724; Wed, 26 Nov 2025
 06:26:37 -0800 (PST)
MIME-Version: 1.0
References: <20251126034404.2264317-1-willy@infradead.org> <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
In-Reply-To: <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 26 Nov 2025 06:26:26 -0800
X-Gm-Features: AWmQ_bmN1Uwu13W4NrHUtDvmW-KG2uAkfNBqSpwb6IphsxLee_ZtBn8LuK-5quc
Message-ID: <CAJuCfpEge7MJD1joXz=tKgcD7DQgPggjCKF9PLPr3NZEaw=ouw@mail.gmail.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0622A1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: jzqdnnm9fjig6ro5sfxbodb5ra8h93kp
X-HE-Tag: 1764167198-959694
X-HE-Meta: U2FsdGVkX1+GGhsVIX5JQiko/O2yvg6gYEWsy7/cpiQIZvGyLh23BFSIzzHpGeleqrAO4uvwHMg7oPed1qJfhgIue2Vz1kXdOHzu0J/EcmepBCt/Qep3rrRdwIHVlhjxJiljofiLzyg//aWMZo98dplThMVa0bEzhv8z6GidArynDvKn8ta/9r08cprYeQaq4N5MHyhplkTElbP7wgNQ+K6z1ZZE4+9aiaia9vo3YI5Mf9M8cURd13PZPsOCYaOum2rEXHsIQAl7ky0sB0peFrjPx4duV6FniwqILGJwsa1y6mua83AnCpMIpw6wm4OCO8qiNeytMaa0CTwvaYQSrGIYOH7fHdhqMnzqAgezydLTUge0w/7K4g9pEb2AH/XpYwaWJw0Rv/fsycCFppSO3bo9vAtS9bukn/FLZ6r0tnw3IURDEujQhPuJ/t2ThY763R0BQdIK54DQPEP3vxYAvaXx7HCCb26Y5+rUxqs5xNS5/sViirFfGgNMiqzK3gtRqJOZWYyz4/u7AnyqDajk8YnvTsRcc3+jsYBrc7UUzJHYs4fVr0U4n9uRft70xZhN5aHziJZyqVuy/85XzXLTzHn9vpKMLsO+DCU1Gy/bwkYKGlDa66Ojb3l1KxZUcpEjxlaePnsWzwwUDJ5WZPRkt3kTR7QW6u5mXqjgvfz88YzgPw9Bed3TNPY6/XTmhgTj58Ifc3iN60r/30WJObTSThY+1MoHTLEh6zCAWY6z+AOZs4GOnEBpFZNOqO7yyiUWUJtSUucpbMKx0vSXBZijdGfaRCHEspKXu8uk7ZrpHGsvVlFQrbmpCZv3OJNRyEkPf6jNdIhS20TUjWlF2nR+29kYuoP+6mxNyM7xXIwV2vSNxIgf+C9QZKLVbQW1lXX6rWBwCMBuUvy61qiZ/1gO45TzW8UUfOyfROdx7huzPiIFFWtrkqPSVsj4+J4MNwacqz0b6gigNKqya6vzVWS
 xKGHAopk
 z3RaRuJVji+36LeynqIlHppl58ROSDBgoM9plgqUzuOzdJoI2pa1hpCJ2NhfoLaz7dLCmxl6NQKOF6CoahVmNFQT7dBFoT4KQsgzTSwqUXgRAj4bKGTb/ualvoiasrRJBM9wSXpHBSVmJVces6hYn7ZKvqCJqQHfAw9SYUjkyyBqW3P7J0k+ztf/KY48gHuySZTFEFiQBkQdsD/vVQXP/8w+rY3CytlHtaGWPoGTYECSCGpumTsW8KGL7IQfQliD5wbCEWnQSiObSqVUdpImFRA/PJ6RQR5j4XBQtYXTquQudk+mrDOBZTfJ0Jq59OVYwG0ERme/b50H//nbU0vcJe28L76VnNQBFuyg37PQ6LHN32lnJ2HZZXjqDW3XczyTtNgmPqFf1bzgNJsoLa/L33loqRxLiYDOoR/iNkj3qe8geGnarRIjd8R9Mhd//COizb+PSShhuocuDGH1aefmR+wXGIlswi0/9iMcrORDNcFjZ0LR+MbOCqZIPMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 8:28=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Nov 25, 2025 at 7:44=E2=80=AFPM Matthew Wilcox (Oracle)
> <willy@infradead.org> wrote:
> >
> > If we get a signal, we need to restore the vm_refcnt.  The wrinkle in
> > that is that we might be the last reference.  If that happens, fix the
> > refcount to look like we weren't interrupted by a fatal signal.
> >
> > Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
> > Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> > Andrew, since the vma_start_write_killable() patch is in mm-stable,
> > I don't think you can put this in as a fixup, right?
> >
> > Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
>
> Doh! This is embarassing...
>
> > Any other stupid thing I've done?  And am I doing the right thing
> > with refcount_set()?
> >
> >  mm/mmap_lock.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index e6e5570d1ec7..71af7f0a5fe1 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -74,9 +74,18 @@ static inline int __vma_enter_locked(struct vm_area_=
struct *vma,
> >                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
> >                    state);
> >         if (err) {
> > +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_ref=
cnt)) {
> > +                       /* Oh cobblers.  While we got a fatal signal, w=
e
> > +                        * raced with the last user.  Pretend we didn't=
 notice
> > +                        * the signal
> > +                        */
> > +                       refcount_set(&vma->vm_refcnt, VMA_LOCK_OFFSET);
> > +                       goto acquired;
>
> Wait, why do we consider this as a successful acquisition? The
> vm_refcnt is 0, so this is similar situation to an earlier:
>
> if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
>         return 0;
>
> IOW, the vma is not referenced, so we failed to lock it. I think the
> fix should be:

After sleeping on it, I don't think we should be masking EINTR error.
__vma_enter_locked() result might be the only place where an outer
loop is checking for fatal signals, so returning "failure to lock"
instead of -EINTR might cause the loop to continue. I think this fix
would be better:

          * If vma is detached then only vma_mark_attached() can raise the
          * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attach=
ed().
          */
-        if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
+        if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
+                if (fatal_signal_pending(current))
+                        return -EINTR;
                 return 0;
+        }

         rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
         err =3D rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
                    state);
         if (err) {
+                if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt=
)) {
+                        /*
+                         * No more users but fatal signal is present,
+                         * still return the error.
+                         */
+                }
                 rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
                 return err;
         }


>
>         if (err) {
> +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcn=
t)) {
> +                       /* Oh cobblers.  While we got a fatal signal, we
> +                        * raced with the last user.  VMA is not referenc=
ed,
> +                        * fail to lock it.
> +                        */
> +                       err =3D 0;
> +               }
>                 rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>                 return err;
>         }
>
>
> > +               }
> >                 rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> >                 return err;
> >         }
> > +acquired:
> >         lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
> >
> >         return 1;
> > --
> > 2.47.2
> >

