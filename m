Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C59D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172D46B032A; Thu, 22 Jan 2026 14:31:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139E56B032C; Thu, 22 Jan 2026 14:31:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066476B032D; Thu, 22 Jan 2026 14:31:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E9C3B6B032A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:31:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFDFE1B0B9C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:20 +0000 (UTC)
X-FDA: 84360593520.05.FDA0B56
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id B1F06A0012
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RxVYQBna;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769110278; a=rsa-sha256;
	cv=pass;
	b=Jvw99qXckUNi3nlWsXcAzV1m7tsZm3PljWraUBUJVZXTPGlJM1Inr0SbzoH1w2mxDLViYE
	Slfnda9Sf6bBy7IMQoUIxhXtubtpPJ07DL/Q5qO8lx6PxuZEnQ8g6QVxdI4br5/gs5aNSA
	boWCx3S4ru+sYXlL53wOMs0qfHf1sSg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RxVYQBna;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBW80lcnBEWjjyGPBw5sRao2pYz5O7Wa287570viMLE=;
	b=u4H0f4LTYrd7eECWe6d6NF4Rf3VWEm2qZg0W+zJL+/Xk735uRxt9yJXAyR9Iy/EQDaRIZp
	bYsDKuhkbP2gYB1h6KCScWDZCUhQGZ3q8cKbk44klAksax7TlSbLWz5p/bB06VCKEHJqUx
	2Zx3maIuQeNmZu2xlL0MBkDGBsCLt2E=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-501511aa012so57771cf.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:31:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769110278; cv=none;
        d=google.com; s=arc-20240605;
        b=j/yetKguJFAs0yMkVfJEykW4Dq+bhatpwOQSWgNoI6gBpDYTHfqb+0cBC53wFxtBmm
         EU3Djlzh9GKB6MbriI3z+TmUL8+C5GapCWQhySfbcasZAYZU9qQhftzqoTGssmN7dgRy
         vjSdlGaHdsoESuuy/l7wga3wcxtUMfJiDw0+EpZkrPo7ATUGZFGyRZzzyE6IBon3PyG7
         KTUrTECzC6etOzocegP98qgICfeHlpIu1AtdW0eb8cKTfDpW2ADiPwEXbiF5cZ4PH/Gn
         OV97sxXKElKq6u0qsvm21hh29YbYj62wZnpuCzi6cOtrF7rdSj13KngwcTyhqppuO1b+
         934A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WBW80lcnBEWjjyGPBw5sRao2pYz5O7Wa287570viMLE=;
        fh=8004vXfLHTDtw3d6hmuvkC2MwZFhzAFKdxAOknoRFRM=;
        b=GmPlWHcGBGDw8RGoAcnXJGwhOzEsvsEcfTRFjWL3M1UYBJWS6VBrvrhrRVwXlaPDnv
         pSQ3ZDgqnlxLcg6pM1jJRtfyJ7tQeS5aP1GTCwPsMkzld6u26RZBi9su+zYEScaddU3o
         +0C+KMNyfexxJFDPzKHOj8id3Nqc6OpsJ1kwygY5nvAYubwb8dlOGhvUnBwp8VKuGz+j
         +XI8SeJsG7cOsOUWnSUvRSSXwRJFZiyX1st1o270JH2D5AlRrY03ZY5arGvYxqyG7tBD
         0jApGJg94nFe+zYU9qm623ZUSH2LGKG6kEcMCxW+v2msj/FzhOYYYuiVYXRwa/N+1L4X
         ZPxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769110278; x=1769715078; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBW80lcnBEWjjyGPBw5sRao2pYz5O7Wa287570viMLE=;
        b=RxVYQBnaoxrSwlJv/Oh7x820Hq5EoTV/RjGciBDXjKb+9YRWG8UfT3O/v5tYu7T5D9
         PKcd562B4jOxdX4Evu/7RPEWnXTp1KHFNx/Kvpyy6FasTDilkGfHuVTv4KBtca7QE6Iu
         n7MxPtL/x/phoXPIvGHLjiLRS+X3UTQ98z6/qMeXXLtQ4P8XNBskl8NOflbO6Ajl+6m6
         W2pNV+v2ySXw2M1Q2vBElczGrcxPPEN9rY/DCibnW1lzuGjVfwtDNwsaxMfOTpxv0Q3l
         e0F4RXoZBhArWtL6PHCNywFMH7XWo5MeBNp0xh5x3B4rusV+uCrpOcLkXdzagulQUv5g
         +Ecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769110278; x=1769715078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WBW80lcnBEWjjyGPBw5sRao2pYz5O7Wa287570viMLE=;
        b=nsrA6KZLozUZkJwHKNSLQvNxZQr38Yu0xoXv0W7AYbA/E21tSSDfxOVRKp33K6sCNg
         Ck25MXiGe8AP/R7jal60MydZ4QXGiqgP86HbBr2Bsb1rWt6NM/nbQK5ekgnMbPCcMh5N
         BYaF6DzIX9MnQwZzV591f0bVGeqHp2UBRNvUXFnpj9Rlidbn79HCf+fctnV9vnNGmwGd
         UZxazvxmm6SKKNgSvrTwkU9MUNgBLUlQSlMlzXO/I15e9O76357tAVGWfCCsRXt9zw4q
         j3T2/MsDuEgcBLRjzLERlpZxbhCXQLKsN/rf3xPn7Zs8WfOkGSjjd3PvGzlwwACPKDj7
         TPgg==
X-Forwarded-Encrypted: i=1; AJvYcCUTn6F/1ppjRWR1hIVkeaFxrGsybzX/I+FfFeSNqYijg8xmk6ENOSuiwpbmibceHzzPA8FRJXtAyQ==@kvack.org
X-Gm-Message-State: AOJu0YzqLVmBQ+noSdZjmq980Ls4PPu34ef2RPQFlC/G8isD8jZ3osgd
	Xsw5kRrr67hqKK8SlT1e1C7kFN67QQ2WZ6XRzBudA3XJvzvbyOrjLJf6m0BVReybHuywXfJKgBV
	csXEzmuKr4c8wsMkNEaQLfYeD6G7JypcuLJuj8Qxb
X-Gm-Gg: AZuq6aJOUgOaHcbZPRNPd/rZTQC5z0PohAvra1wZvNM2eIw4xGCSR10cuybCinj4wt8
	b2ZBm7SlADOZgQnzEMKonIWC8bw0eNqpZTz2Uor1xbckl+BPuhhu58Ka9nRQ0EAnVuXAhlMtJN3
	EbHNK+sYbq/tKsOhMqMT7lGEXgg2MIDYT5IklTU8D2VKfKnHDB50cvtmv+VSjcjT7MuY0Wtb9sN
	ljspo19auxnLGd3STDa95BXYJujnsO3F7/xht9TLkKxSJVu9grYx8LZRoX3JWrJG1ax2JmUvLke
	mA+0elJMMmhbkswIZ1m00DWo
X-Received: by 2002:ac8:7dcb:0:b0:4f0:2e33:81aa with SMTP id
 d75a77b69052e-502f81098f6mr1305041cf.11.1769110277213; Thu, 22 Jan 2026
 11:31:17 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <c51d6396d78532d85a542da07ba783bc838b852f.1769086312.git.lorenzo.stoakes@oracle.com>
 <6f45d01a-7586-4d8a-8339-fdfbda4c971e@suse.cz>
In-Reply-To: <6f45d01a-7586-4d8a-8339-fdfbda4c971e@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 11:31:05 -0800
X-Gm-Features: AZwV_Qjh5g2cATvu-aLTXs8yqxbYjNLzEtyyRnYIZ49mgFssb3IevuginMU801g
Message-ID: <CAJuCfpHhVOC5kzapSPtvUHGy3jMr8DyjPba7tkSv5zOWotvcQw@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 03/10] mm/vma: rename is_vma_write_only(),
 separate out shared refcount put
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B1F06A0012
X-Stat-Signature: 6es9mpgrbjyozxige6mudadyz4pfsauf
X-HE-Tag: 1769110278-530397
X-HE-Meta: U2FsdGVkX19ntH53mS4LL+KU7KcD4cLoJYhhyLSeXfEFJZN/Q1shhmsL7IIz5gosf2NVUIPcXSeLD1CUmbIcj1thugnXQSPY9pwrSkmbwtsxSCU52bbR/eIOwTefn3SOOEB1bbNuY2ZYzGM/kiRdrweFG5pe04yg3FqS0hSapnu9jMjEQUkcpAm8pCGBC7KEp+mHw6ch8lX6fAKUKdRnn0yk4gq+jIl6gxdfoxRtkrQGppjw+sRrLcQYOj9GLaU7IDTetJLle+nLQ+BSEBdtEnPeXSE+EPIcfDZr+M5Xgan+1xNyMQchoSnBR5WMsdOypsTRQpQt9LCeNfBDH8IuqDbUo6OYG4C33nZgaFQ5MEaMT7PlfQQWqafrkR6HHlRVjpxGBneS3EJqfTQv5qxsK/YrHwfOwbHi8THzNxoQCSIz60hggWADRMHmc0x+F8X4G8aWiKeTN/G1sjT5xyTTBZhNfAcww0h22Ry+jWuZPkHI76zHgbrIBrK48CLvOO/iGJAKzOWa3A/KWhTTySrXoRcRAi5WEf9Ag8cfZ8Ty8YUAOGNUrDXd2IsnMM2ueSMVTR8759nWkOPdRZ/KhGru8U6AQVrBACQ6FfHR7xaPgv5UJdaJI1GrhMiLJ8M0/Qr69rA0gesBCt/iK+5Or+eKeWq5vimE4jql7Vyq5XiqPunJs6gq5egDScpQT2OkP7IvReojNmVCZ2VAmxjG4b8B17ixr0HLcsFIQvCvi1nSFbqNqA4FqQ5gvBA4PtruQWM0PT+slit8F/7dvKO7YJnhLX4VyY7EH4wlK4hMqbxJtViVsa3wLSj0Hrk4jiPbtJOv2xl9M9O7t3Ssg1LsRjEAebleS3M0NL3IExIzVumsnQcZOfDHU9sFxJGumgOYBabwjcy/n5oo46WIYrY1W1Np0jhiqC/YqM9VW//SoJqU1jpGbQYhnuAKgKaViy6q0LQ6gECGc5alG76mWjHFZk1
 VHPcM815
 OvDAmnPpocmFL++PBYTxGZAxV/q3sYaZgNqeagxANogOMSA9XM8cjCWMNei1mv43C0qkOoeF9uIrT3Ce96nGBErRUoiYG7fxif4NBYiPx+dGqK06NhjHxDgGb8rsLvJohB9CCQvDcJsS41mHIIfjpv0LKDzjgwT+KNCjWGRHXD4+Znn9eyrzH5fMCOKGAELd3mUHzvYI8jo72mZfVbGrB9dXMGX5ZaizjQb6Y7bqjDlhaoFnEkzlNigiflCzKn2cMfFn3DYq0wgoMgRcj1qGLQr9rFVmELbqfkinW3iCOp0P2y85Q1aNnLjTn47BT3aJT1F14MZnCRhpcUYR3WbT7OlYha/qDSTb8z6B/R0MsSxrILW8rHDa26BCa/tK3Avr9Cr02e7cJypRSZC6a7sU3ZSmjF46QfLEyLcaxkMI8HFyBEh4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 9:36=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > The is_vma_writer_only() function is misnamed - this isn't determining =
if
> > there is only a write lock, as it checks for the presence of the
> > VM_REFCNT_EXCLUDE_READERS_FLAG.
> >
> > Really, it is checking to see whether readers are excluded, with a
> > possibility of a false positive in the case of a detachment (there we
> > expect the vma->vm_refcnt to eventually be set to
> > VM_REFCNT_EXCLUDE_READERS_FLAG, whereas for an attached VMA we expect i=
t to
> > eventually be set to VM_REFCNT_EXCLUDE_READERS_FLAG + 1).
> >
> > Rename the function accordingly.
> >
> > Relatedly, we use a finnicky __refcount_dec_and_test() primitive direct=
ly
> > in vma_refcount_put(), using the old value to determine what the refere=
nce
> > count ought to be after the operation is complete (ignoring racing
> > reference count adjustments).

Sorry, by mistake I replied to an earlier version here:
https://lore.kernel.org/all/CAJuCfpF-tVr=3D=3DbCf-PXJFKPn99yRjfONeDnDtPvTkG=
Ufyuvtcw@mail.gmail.com/
Copying my comments here.

IIUC, __refcount_dec_and_test() can decrement the refcount by only 1
and the old value returned (oldcnt) will be the exact value that it
was before this decrement. Therefore oldcnt - 1 must reflect the
refcount value after the decrement. It's possible the refcount gets
manipulated after this operation but that does not make this operation
wrong. I don't quite understand why you think that's racy or finnicky.

> >
> > Wrap this into a __vma_refcount_put() function, which we can then utili=
se
> > in vma_mark_detached() and thus keep the refcount primitive usage
> > abstracted.
> >
> > Also adjust comments, removing duplicative comments covered elsewhere a=
nd
> > adding more to aid understanding.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Again very useful, thanks!
>
> > ---
> >  include/linux/mmap_lock.h | 62 +++++++++++++++++++++++++++++++--------
> >  mm/mmap_lock.c            | 18 +++++-------
> >  2 files changed, 57 insertions(+), 23 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index a764439d0276..0b3614aadbb4 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -122,15 +122,27 @@ static inline void vma_lock_init(struct vm_area_s=
truct *vma, bool reset_refcnt)
> >       vma->vm_lock_seq =3D UINT_MAX;
> >  }
> >
> > -static inline bool is_vma_writer_only(int refcnt)
> > +/**
> > + * are_readers_excluded() - Determine whether @refcnt describes a VMA =
which has
> > + * excluded all VMA read locks.
> > + * @refcnt: The VMA reference count obtained from vm_area_struct->vm_r=
efcnt.
> > + *
> > + * We may be raced by other readers temporarily incrementing the refer=
ence
> > + * count, though the race window is very small, this might cause spuri=
ous
> > + * wakeups.
>
> I think this part about spurious wakeups belongs more to the usage of the
> function in vma_refcount_put()? Because there are no wakeups done here. S=
o
> it should be enough to explain how it can be false positive like in the
> paragraph below.
>
> > + *
> > + * In the case of a detached VMA, we may incorrectly indicate that rea=
ders are
> > + * excluded when one remains, because in that scenario we target a ref=
count of
> > + * VM_REFCNT_EXCLUDE_READERS_FLAG, rather than the attached target of
> > + * VM_REFCNT_EXCLUDE_READERS_FLAG + 1.
> > + *
> > + * However, the race window for that is very small so it is unlikely.
> > + *
> > + * Returns: true if readers are excluded, false otherwise.
> > + */
> > +static inline bool are_readers_excluded(int refcnt)
>
> I wonder if a include/linux/ header should have such a generically named
> function (I understand it's necessary for it to be here). Maybe prefix th=
e
> name and make the comment not a kerneldoc because it's going to be only t=
he
> vma locking implementation using it and not the vma locking end-users? (i=
.e.
> it's "intermediate").
>
> >  {
> >       /*
> > -      * With a writer and no readers, refcnt is VM_REFCNT_EXCLUDE_READ=
ERS_FLAG
> > -      * if the vma is detached and (VM_REFCNT_EXCLUDE_READERS_FLAG + 1=
) if it is
> > -      * attached. Waiting on a detached vma happens only in
> > -      * vma_mark_detached() and is a rare case, therefore most of the =
time
> > -      * there will be no unnecessary wakeup.
> > -      *
> >        * See the comment describing the vm_area_struct->vm_refcnt field=
 for
> >        * details of possible refcnt values.
> >        */
> > @@ -138,18 +150,42 @@ static inline bool is_vma_writer_only(int refcnt)
> >               refcnt <=3D VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
> >  }
> >
> > +static inline bool __vma_refcount_put(struct vm_area_struct *vma, int =
*refcnt)
>
> Basically change are_readers_excluded() like this, with __vma prefix?
>
> But this one could IMHO use use some comment (also not kerneldoc) saying
> what the return value and *refcnt indicate?
>
> > +{
> > +     int oldcnt;
> > +     bool detached;
> > +
> > +     detached =3D __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
> > +     if (refcnt)
> > +             *refcnt =3D oldcnt - 1;
> > +     return detached;

IIUC there is always a connection between detached and *refcnt
resulting value. If detached=3D=3Dtrue then the resulting *refcnt has to
be 0. If so, __vma_refcount_put() can simply return (oldcnt - 1) as
new count:

static inline int __vma_refcount_put(struct vm_area_struct *vma)
{
       int oldcnt;

       __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
       return oldcnt - 1;
}

And later:

newcnt =3D __vma_refcount_put(&vma->vm_refcnt);
detached =3D newcnt =3D=3D 0;

> > +}
> > +
> > +/**
> > + * vma_refcount_put() - Drop reference count in VMA vm_refcnt field du=
e to a
> > + * read-lock being dropped.
> > + * @vma: The VMA whose reference count we wish to decrement.
> > + *
> > + * If we were the last reader, wake up threads waiting to obtain an ex=
clusive
> > + * lock.
> > + */
> >  static inline void vma_refcount_put(struct vm_area_struct *vma)
> >  {
> > -     /* Use a copy of vm_mm in case vma is freed after we drop vm_refc=
nt */
> > +     /* Use a copy of vm_mm in case vma is freed after we drop vm_refc=
nt. */
> >       struct mm_struct *mm =3D vma->vm_mm;
> > -     int oldcnt;
> > +     int refcnt;
> > +     bool detached;
> >
> >       rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> > -     if (!__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt)) {
> >
> > -             if (is_vma_writer_only(oldcnt - 1))
> > -                     rcuwait_wake_up(&mm->vma_writer_wait);
> > -     }
> > +     detached =3D __vma_refcount_put(vma, &refcnt);
> > +     /*
> > +      * __vma_enter_locked() may be sleeping waiting for readers to dr=
op
> > +      * their reference count, so wake it up if we were the last reade=
r
> > +      * blocking it from being acquired.
> > +      */
> > +     if (!detached && are_readers_excluded(refcnt))
> > +             rcuwait_wake_up(&mm->vma_writer_wait);
> >  }
> >
> >  /*
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index 75dc098aea14..ebacb57e5f16 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -130,25 +130,23 @@ EXPORT_SYMBOL_GPL(__vma_start_write);
> >
> >  void vma_mark_detached(struct vm_area_struct *vma)
> >  {
> > +     bool detached;
> > +
> >       vma_assert_write_locked(vma);
> >       vma_assert_attached(vma);
> >
> >       /*
> > -      * We are the only writer, so no need to use vma_refcount_put().
> > -      * The condition below is unlikely because the vma has been alrea=
dy
> > -      * write-locked and readers can increment vm_refcnt only temporar=
ily

I think the above part of the comment is still important and should be
kept intact.

> > -      * before they check vm_lock_seq, realize the vma is locked and d=
rop
> > -      * back the vm_refcnt. That is a narrow window for observing a ra=
ised
> > -      * vm_refcnt.
> > -      *
> >        * See the comment describing the vm_area_struct->vm_refcnt field=
 for
> >        * details of possible refcnt values.
> >        */
> > -     if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
> > +     detached =3D __vma_refcount_put(vma, NULL);
> > +     if (unlikely(!detached)) {
> >               /* Wait until vma is detached with no readers. */
> >               if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) =
{
> > -                     bool detached;
> > -
> > +                     /*
> > +                      * Once this is complete, no readers can incremen=
t the
> > +                      * reference count, and the VMA is marked detache=
d.
> > +                      */
> >                       __vma_exit_locked(vma, &detached);
> >                       WARN_ON_ONCE(!detached);
> >               }
> > --
> > 2.52.0
>

