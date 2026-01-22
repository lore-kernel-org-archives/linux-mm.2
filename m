Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36340D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D29E6B0319; Thu, 22 Jan 2026 14:26:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9FE6B031A; Thu, 22 Jan 2026 14:26:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483666B031B; Thu, 22 Jan 2026 14:26:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35E1F6B0319
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:26:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C61F4C2FE8
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:26:06 +0000 (UTC)
X-FDA: 84360580332.27.8F1EA41
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id D3EA64000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:26:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="REYy/dr3";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769109964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFar74v5L9caJGm55iUvf49HTBsbtdcK0qJVDuGPae8=;
	b=vsNcikKojeG/G0obOtq3ZtbLKlhkycQK/9JMly2dCObFKktzyKoPm4JZUHlKpw+UOdhkKx
	G1eRSf3LuESrxnEOSDPsthZqy+Xo+MlHn/HzVee6ksurFG6dBnKaWt+vXjO2vF0rr8ep1x
	OJWmoiK83Z4XiWwfMnFga1Ps5o+2Evc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769109964; a=rsa-sha256;
	cv=pass;
	b=cXFTrXPyZ4SiSOiawzNqDHQ/xxaiqTqmXaIBfPVUwWVc4wGYFSnrn2YLfLCPRrF5Q+bJ2p
	xqZ3fNZ1xUKwTCK/4o+j1tZRDQl2weFMNYF5NiZJqFvYUkJj9VuaECqdK42KWaf6CZ1F16
	wsya+bhdzKWdcuc19p4f+BLgnsIlXtM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="REYy/dr3";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5014b5d8551so79241cf.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:26:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769109964; cv=none;
        d=google.com; s=arc-20240605;
        b=J70Eb2BPQhdJHJzMqwuzGtNEO6tYW6EyntXXORoYRrJ71WD6lu8V4lw4EPgUmwQULk
         mnoEIF3+TErJ4yZr29kXAyaUUs3cgACV3VVC2bP5OqDb+mvAmXMuyRzcP56E5TDMvQt8
         e070IUHnjq8cwW3sms2YEn+3Ll8JG2Wa51r2PFKHUOav9on5iENlh4DYqnFS0hIV9l1c
         Hr+oHcMOHn42vYZhSDGgXsl1xDVRuE5YjiGHOL+baKIP7c0b3vEbJgP/FoYnNf7nKrUU
         DzhQggTcEzUHPFVXlAQQqRHYvKDpkmArFiKrpWK18+NYbJ7WyQImGSHFMUpj8YiTVpXA
         5sJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dFar74v5L9caJGm55iUvf49HTBsbtdcK0qJVDuGPae8=;
        fh=3iLuOa7TemiQ8C+JGWSwEcpeQ69LmfPEdCvtc6MtH68=;
        b=PTMtPtI/IWgrZq49VeTrwj0fnW71t7VAxHtAbxysxYMUVJDdMQrq+fS4bI/t8XXcGX
         HsXm6A+52hn8vaD/r7bJa54OwUA/CjI7PGeJwb+seq0XAoeG1nv9UsaC5UQyxvSz9k9c
         ZM/GqFXhBUBVJMznUiEHuqMs/+hk5EZbvbi3uw4AnaQqmbiDcKxnNgIeEBw8+fdVSBs8
         VXFoidXRxfFMuJZZDHn4VPfrg83+Vayho+xi5A1tX/eRrTe+F9yBMD/vZ/tX7EOKePuf
         I84WtanjCHLjyzkgI/+sqPo1iGs/p4brWNmJA8+CPoJFl3AKpHn04tpvm1dJT9W6rSRN
         /O5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769109964; x=1769714764; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dFar74v5L9caJGm55iUvf49HTBsbtdcK0qJVDuGPae8=;
        b=REYy/dr3vNyx8LdqJK7/vgSqPOhQ5xxUw3k0tPID7t+cZWz8wDtwvAHJBtB0XvrmXI
         VCQPSSKzLQeQhWC7YY6lR5say3rWcfhf4q0vbr0fz0SuN8wS3TtAnMI8TXhSWLa8a6cI
         Mt4bIq3GJC/qILfhOPXyUEG+vMWwc/3+jkcYtqrrXRZyIYQ0Fgxl+moabvQAO02pKUo5
         rLiwZzOzaJmOlUkppcc93v+GW+ByeCoEFV5CxIlOGzRT30pk/x61ArFlDyO85Ta9oVSV
         xa3lulsyEBc+yLDvxZN95n+6+ycBc6CyxY1MXJYulXtfi3A4lxWFR0MdABFix8mYnolH
         5PNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769109964; x=1769714764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dFar74v5L9caJGm55iUvf49HTBsbtdcK0qJVDuGPae8=;
        b=k4rohanbUhVkvgOYdTSESE9RJ2yutiMGEc3QPe46k8bN2IV3+bCc14EnZRA7WltjOj
         rwoeWq/qrUOPytD5AyHMUeLk75kCpZGqcdkBuWhrxq0eV56JHhjF5xyAqWgFvQ+t9HtK
         coiOEYa5n7mtayg/x5pmP91fC6A7Q8CCjjA8gTvM7t/Z4ED/xqr+GAdL2SftrM8PzuZS
         cKzD+ZTTSQsolGyid1xATpytPEbygUfzh9X4Sz4SQqqfTTmSK+oT8KnG9EJ6+lFDUUIi
         APt9Al4FgPuZ3KeTckRRqKxYN30ZWd6Ygv9V3zvTY35Xzz0tKVXT8z+WIDtSq8bBlvwH
         rFnw==
X-Forwarded-Encrypted: i=1; AJvYcCU+nvyU2wt5eaPKctoC37sP/KSvr8lQ7NgBCvE4PQ0ZKIuwr92N6JII/5r/sWxA6SiwnX6rm0tDuQ==@kvack.org
X-Gm-Message-State: AOJu0YzUzguLrhl6MmgedTIjepkGsky5/PPkWtElUtBDKjBa/01FHJSJ
	j2JXCktA4S2TM3TLicUXu5OamPul9TBJSeBNhDfcJlWfDGcEaCMdCMeWvje/Yvv9yXrAXOnjj9q
	gHl1GLz+plC2rOPHCy0QFSkoLbrM4SPHnFKknh18u
X-Gm-Gg: AZuq6aJ9+CjIaADdwvhIu1NKaQ/xTUeGpwFTaM3sTBPWxKke/5z5EzdcYitC25dwLQ1
	2Ug6s3Qjy274E2R+orcpbXaGdV5FEMMBLUDHBjtAU1q5MPehzrdNrwr9dY+5Zyk3cJi9GufI6Xt
	xkRqaSS+a0eesFcEHc3NUivl5y8BJn4peuh0ohIvzRRVyRRgo2a/BatmeqdpX+qlHako0fH5lnD
	wEhbT0QIOF0yTSq+WHovBNLVD+6UdysEpnR8BnS45LAAAirdYI3xNMNC4/G4vpHSlkjH7/BM3zx
	IRlx1Ry+63b53id1SjDh0Ayh
X-Received: by 2002:ac8:7c44:0:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-502f808a608mr1477551cf.14.1769109963495; Thu, 22 Jan 2026
 11:26:03 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769085814.git.lorenzo.stoakes@oracle.com> <4703b7320796908b9a0827c3d42d74d11b703714.1769085814.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <4703b7320796908b9a0827c3d42d74d11b703714.1769085814.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 11:25:52 -0800
X-Gm-Features: AZwV_QiC4yCOm_6Ck4ofFpS5FHz68e_QvqRz-MHIzMZU7qBT286p_RXmTzVHZJI
Message-ID: <CAJuCfpFLXtMnO32ffUw91917n22FqFhBRO46BzfOpUe7v_xjPA@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] mm/vma: add+use vma lockdep acquire/release defines
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D3EA64000B
X-Stat-Signature: g9rgrfm7jw3jtah6g5px5mx7mskn77om
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769109964-351062
X-HE-Meta: U2FsdGVkX18X1fa3p9mKKkI7zIGIQvCoMLS9sr6GfdWzF/Sw4Nro30YyM63OWJcaP1Zt+ht6dURs3AdIDnicTbUP+mPcwckMjTQp7MAX7aCifI6SLm/4OWQ1M2NkCqjOGwniFO8o/W91BoaVlo9btoFVTI92UPXudGkl1ORVHfDtF+cWlYeyAbgF+b4QQ9JpZvp799v2xxq6U45cF6y24nvxcX46Cbxql/vCJd5kEwYt472h7g8qRr7Y4Gpr0b+T8ougAER3nWs46LGvaUG1a1k9PwzXT8hKjyYWCWcD87xPO7TlGW0LAaoBUkr4KNl36pKmDCKg3vo2st76FWS8Vkm32WUWtblZE9fBS9+sFZRoaxHniNZE2W7MMhiqNde/ZLTNL24I/dTGMNeNYMSW0ew0nN2aERLPFtj4HqjDcfYgeErMGdMBsEKPrB/clfSB50OQf9Gyg+v/84Sv4qypTG2guSWUdwubFUE6GJFaiTIn6HgIZK/jPqHQDSQ3POvi4lDHHicuXb0ILIOvArXrxd2ZBcuQB3RFSivunS1UdyAVT71PWsH/ZH3VN8+Dc1UrnRrczGi9+BDKDWU9oRhJVN26aZ8pwm8aM+D9+oLmNxHPw0+FKxMj2FupS6f2dktR6V9YCysJMDJMAVYZMvp3UsfzctiogHwVMx+HlXLEpcjvw6rYQKri09+NdIPKcYme+/tUIrhMTLNJxUX+qeqFmXEucKub9KK0r5NWsBLIfQZVSQ0Wv5BsaAzas/n8iOsM9cCg1+SukxOp0Tg31dkzCYNNiQ46L+mSGJH4lmOcYh5qWI96bs14pDJ7Dg4ujXBnquZ5x0bIB6R0lFiQdtSeEN9B/6D/XD49rcqCh13E9LcPN+tRyOo6xKhQhG2P8hMnwrv/x0iIbEdJHcq2NLwkUcdB+qp4y+Umw37oyes64kFT80juexcYBs3wSf1ZNon5tRL9RLz4Z5fBmDiJozH
 kA46Aelu
 9aZe8y7aSvBTftN29+MHiqdSkfcr8DoipXunbXedXZZTz/9IS2GB0pfYtF1DFWsw0BAnmPsxicQDDbx+P/NjkLBHJLB605R9pQj4cRcLrCJ45Fyek/wLBpbX1Oe1z+g3tM+g92IqCl1hES4GaXUiWbNzYOcB/g7R/zr7G/qaSv1GZqNjFdRpW7qYZr0G3NS/cH1Jep8Xtb/x5BW5crLALFT/ssdoeD2t5hmWKx0PAE++aSnpmAGTkJWHyAwomr5dGJ64zSJdyWOzTs1mfapmZj1jGCe263zLEuzh1vC8A869OutWHagLfmwojWhnfgKcsdFEe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 4:50=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> The code is littered with inscrutable and duplicative lockdep incantation=
s,
> replace these with defines which explain what is going on and add
> commentary to explain what we're doing.
>
> If lockdep is disabled these become no-ops. We must use defines so _RET_I=
P_
> remains meaningful.
>
> These are self-documenting and aid readability of the code.
>
> Additionally, instead of using the confusing rwsem_*() form for something
> that is emphatically not an rwsem, we instead explicitly use
> lock_[acquired, release]_shared/exclusive() lockdep invocations since we
> are doing something rather custom here and these make more sense to use.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mmap_lock.h | 35 ++++++++++++++++++++++++++++++++---
>  mm/mmap_lock.c            | 10 +++++-----
>  2 files changed, 37 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 0b3614aadbb4..da63b1be6ec0 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -78,6 +78,36 @@ static inline void mmap_assert_write_locked(const stru=
ct mm_struct *mm)
>
>  #ifdef CONFIG_PER_VMA_LOCK
>
> +/*
> + * VMA locks do not behave like most ordinary locks found in the kernel,=
 so we
> + * cannot quite have full lockdep tracking in the way we would ideally p=
refer.
> + *
> + * Read locks act as shared locks which exclude an exclusive lock being
> + * taken. We therefore mark these accordingly on read lock acquire/relea=
se.
> + *
> + * Write locks are acquired exclusively per-VMA, but released in a share=
d
> + * fashion, that is upon vma_end_write_all(), we update the mmap's seqco=
unt such
> + * that write lock is de-acquired.
> + *
> + * We therefore cannot track write locks per-VMA, nor do we try. Mitigat=
ing this
> + * is the fact that, of course, we do lockdep-track the mmap lock rwsem.
> + *
> + * We do, however, want to indicate that during either acquisition of a =
VMA
> + * write lock or detachment of a VMA that we require the lock held be ex=
clusive,
> + * so we utilise lockdep to do so.
> + */
> +#define __vma_lockdep_acquire_read(vma) \
> +       lock_acquire_shared(&vma->vmlock_dep_map, 0, 1, NULL, _RET_IP_)
> +#define __vma_lockdep_release_read(vma) \
> +       lock_release(&vma->vmlock_dep_map, _RET_IP_)
> +#define __vma_lockdep_acquire_exclusive(vma) \
> +       lock_acquire_exclusive(&vma->vmlock_dep_map, 0, 0, NULL, _RET_IP_=
)
> +#define __vma_lockdep_release_exclusive(vma) \
> +       lock_release(&vma->vmlock_dep_map, _RET_IP_)
> +/* Only meaningful if CONFIG_LOCK_STAT is defined. */
> +#define __vma_lockdep_stat_mark_acquired(vma) \
> +       lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
> +
>  static inline void mm_lock_seqcount_init(struct mm_struct *mm)
>  {
>         seqcount_init(&mm->mm_lock_seq);
> @@ -176,8 +206,7 @@ static inline void vma_refcount_put(struct vm_area_st=
ruct *vma)
>         int refcnt;
>         bool detached;
>
> -       rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> -
> +       __vma_lockdep_release_read(vma);
>         detached =3D __vma_refcount_put(vma, &refcnt);
>         /*
>          * __vma_enter_locked() may be sleeping waiting for readers to dr=
op
> @@ -203,7 +232,7 @@ static inline bool vma_start_read_locked_nested(struc=
t vm_area_struct *vma, int
>                                                               VM_REFCNT_L=
IMIT)))
>                 return false;
>
> -       rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> +       __vma_lockdep_acquire_read(vma);
>         return true;
>  }
>
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index ebacb57e5f16..9563bfb051f4 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -72,7 +72,7 @@ static inline int __vma_enter_locked(struct vm_area_str=
uct *vma,
>         if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->=
vm_refcnt))
>                 return 0;
>
> -       rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
> +       __vma_lockdep_acquire_exclusive(vma);
>         err =3D rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
>                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
>                    state);
> @@ -85,10 +85,10 @@ static inline int __vma_enter_locked(struct vm_area_s=
truct *vma,
>                         WARN_ON_ONCE(!detaching);
>                         err =3D 0;
>                 }
> -               rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> +               __vma_lockdep_release_exclusive(vma);
>                 return err;
>         }
> -       lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
> +       __vma_lockdep_stat_mark_acquired(vma);
>
>         return 1;
>  }
> @@ -97,7 +97,7 @@ static inline void __vma_exit_locked(struct vm_area_str=
uct *vma, bool *detached)
>  {
>         *detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLA=
G,
>                                           &vma->vm_refcnt);
> -       rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> +       __vma_lockdep_release_exclusive(vma);
>  }
>
>  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_s=
eq,
> @@ -199,7 +199,7 @@ static inline struct vm_area_struct *vma_start_read(s=
truct mm_struct *mm,
>                 goto err;
>         }
>
> -       rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> +       __vma_lockdep_acquire_read(vma);
>
>         if (unlikely(vma->vm_mm !=3D mm))
>                 goto err_unstable;
> --
> 2.52.0
>

