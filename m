Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6735CC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 03:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0CC16B00B5; Fri,  3 Jul 2026 23:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBD9D6B00B6; Fri,  3 Jul 2026 23:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF1A6B00B7; Fri,  3 Jul 2026 23:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71A356B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 23:53:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF00816833D
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 03:53:39 +0000 (UTC)
X-FDA: 84949724958.10.DBFB6D0
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id D6ABE4000A
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 03:53:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Waf9+Qeo;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=souravpanda@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783137217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYlGNEHT7zqOC6TgLilg9zgYpI8pI8J0xcE4GiiaPHE=;
	b=zcKxPiyROpdV5+vsdhTBkzMAIBnUXKa2u1cPA8qClqJ2ky4srryYyySGJg+EtBIPZNrkP5
	kzY2sSgvhwVm9q/8lamK9rlBn2OqM7rj89aof2Hz6bo2wPoXlQKWxUFb3LqJCpxyCqiS6Z
	F8XMM04bDDAZjkCWFwbqRax4/OrRpDc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Waf9+Qeo;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=souravpanda@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783137217;
	b=3LuewlMGJ20ApYgR0N+Pmzz/8tYdKToLuaJRGZe0FWWjIKs/IlsscO+LvLBdHKhrbotWlQ
	JsoTSuoq5y0lIY2scjMKTZWC++2+VoAtUr2UxuNe2uOYBwGj3yiVTTcD1/jNKSbZC01DO8
	5dVG4qKEO8xpH+G4R+yOy3y3da4cdnk=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so43395e87.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 20:53:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783137216; cv=none;
        d=google.com; s=arc-20260327;
        b=TRSC6UDSaTYOCDCVEPQsKN/u8pyM4Sv8my0ysHREMPCunb8p+V8OBAxIA7+U/Cb344
         Upz4u3JK+oTo+FQoHl52leqRl/7kIdrEEMGiNaoUfl0uRp/TzRWTbtGb2JzC9g6vxO3j
         lCes5n1M2PXhvjPVWsRqKakKK+yVXah/whO71cgFMt8jqVM4Q6l5GrW2tDZjwuuEPUsX
         oyrwUzE0P/C697QkkE1T5iORkJJQMnylj6eFQ3qgH7F/E6W7W8sbG1VFWC0KxDhGqxZm
         5eByONoIgBfI4P5sErr39w8Z581SjdatGCZbEpMvfA+kJA6VX53fDyxrPvPKmAR2X1Nn
         4Tfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZYlGNEHT7zqOC6TgLilg9zgYpI8pI8J0xcE4GiiaPHE=;
        fh=e6Q1Uq6UtCwc88ka5SPWCZ40LVgtteTfX3M9FVyd6kE=;
        b=b05Zfms+Z+DOLl18B3/xe1flAVzFnJzsBjrykZSzhfI/fDtnzOVxOtWLjqh2iVrxvj
         wtfe2rPLPVNg7sU5Oo37KJKJJ9rpczzzwgojEsurkcJ38t1IGvFHnmh3aYavInFOm9JN
         +niQ9uowvEHsanUc0hFr2a1SuqzcrKA8qyw5GYrxIi+fTixYHvUTosRq2UKCIJ1wHduR
         T47RRIlUmj96ZLEtFG2uAqfjTcJW+587E1Rx0Ik+FkxDLLkPgaY5Cfm3MOp04iCM8UjF
         ELu2a1rea5v2Iyd20C2XhmAetgl9cF3KVKSDCfrVqc7LGW/IGPn6rafPUa1bzqSpO6RL
         aJag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783137216; x=1783742016; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZYlGNEHT7zqOC6TgLilg9zgYpI8pI8J0xcE4GiiaPHE=;
        b=Waf9+QeobTZFLtsDxwn6xDMFKCDdDW9EaEPEsK6bWsM/rA3zKcVzspJQdTXaBG5xAK
         esGLYdmlYTNrhKSy4sgi4VbX06ZhIHMUN9u8KKyC8Kn6bYUQ2Se0c75Gyl7uhFWjdj9e
         RtpMJWyaQhavCJ/8629zBS9v+ycUkz0N2AGlHoc0BALuT5LGYnuJMmVHerPzoGi2FX09
         CEoWtt5l0t5wBzIR7jsVAQeb7mk8gC1TMovBivi/uhOMfdzHuUuvKZ3uoIy1kbOhwxdC
         BM0cXI+ofaD3Du7gMvEICAKT6eMCrSjeDvBE7fvDJEhopSRet8px0XWcqYror1szsUPp
         YY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783137216; x=1783742016;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZYlGNEHT7zqOC6TgLilg9zgYpI8pI8J0xcE4GiiaPHE=;
        b=MZND+86fmnV3iTgJZtFWUNPZrw6HbtkcM0l0oiQkqJPtWpZNqVs8bB+z4YAYgvDAVg
         xyq6BLbUUpsaxXG5x5cTqNl/vMZDquLLMXDOGcCP4Gg8QqZSBaIe0oocGWDGwTT6vUTC
         jSPzz6hI4rRQOy0OZJ1XtWC5b4g94PZbzX1j65G+tfET32GZX1mV7XITdvo2eDO9/6t1
         8S2DzYCtnvmh3mpyjFQ38P6V9lZtZjYc4t+3fFOenOWTdP3kVIWLZPMJiVhx0VT9fvnj
         Fh082GD092VSlu/hcRcmQkHarxWpQFiOtuxbSjtK+Nb6bMevYVcJxuKra806hO8SLC68
         6jTw==
X-Forwarded-Encrypted: i=1; AHgh+Rr1sRU1lsejMP4K5+Sol+GKEyG5ax8Jvsj6Z8K7y/u7PJjg0/nHp7vB93TsCG+oS9D0mnw4WNK4VA==@kvack.org
X-Gm-Message-State: AOJu0Yx8zPcsTRJUKuv622WGps+kefAv6xMoS35R/vLJVaz1FzFZtoWT
	2NkUEtMYo9D3wHQOfxc/9XZrf+ctm/GPdMCMU289azxaVCHzdIDqhiB81U8Sj9k/2s29gIUzOol
	TvNF6DykghKVGdHXtaM3yci1Y5B8NFeTeGo62DzLP
X-Gm-Gg: AfdE7cl76UdLqfzSBCLNEim4gGEjJY6NKUstcCKx+pFo/233O9WkPL6AN0ItN3M1pis
	Ns0hSt9cGgoIt/AWMIE8E/+oieSykQVwqoZ+RgisPWsOLIQIzD9gSZB+a19HhyHl2gST7+o+nUu
	g+eNp4wywiHo3YpwScl1q3VSvooIHT8sPP7C+lNj42QuyX3a1qD3Vf8/EAWxKPL9bFWzjpMDqco
	iNGCKNh1URriCAFzRwTSdilUKz9xKylK8HaXZeExGtsLtgR+FlMOASPIw+XICYt/FTWhwh5cgpl
	0nldXiCCbY4cyvmtJ/l48slbC0L8jVrYk70TWDgwU6ccZZT9k7IhH+Svagc1VA==
X-Received: by 2002:a05:6512:6c7:b0:5ae:b7a3:6dbc with SMTP id
 2adb3069b0e04-5aed45b91cdmr20954e87.3.1783137215663; Fri, 03 Jul 2026
 20:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260702215713.627941-1-souravpanda@google.com>
 <20260702162415.142571f4d8c43aa4b95b9f7c@linux-foundation.org>
 <CANruzcR+uQPisER8KDFH3x4C-O22xvUwQEgv2=TQ=MHooO11Gw@mail.gmail.com> <CA20002F-CF0B-4E27-B5F8-EE1D17EDE6F4@linux.dev>
In-Reply-To: <CA20002F-CF0B-4E27-B5F8-EE1D17EDE6F4@linux.dev>
From: Sourav Panda <souravpanda@google.com>
Date: Fri, 3 Jul 2026 20:53:24 -0700
X-Gm-Features: AVVi8CdFlRxe69QC6ZOKMA4xr0uKxjXRh9UQKQCxKRROKO06aK4Y4EC28zyK9sc
Message-ID: <CANruzcSaFozBpy3SVFz_uoNKYV=hJyhAxuO6F6fEPtbrrvnojw@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: Fix null pointer dereference of nodemask in hugetlb_cma_alloc_frozen_folio
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, osalvador@suse.de, david@kernel.org, 
	surenb@google.com, fvdl@google.com, gthelen@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D6ABE4000A
X-Stat-Signature: qw3u9w38r54wyzdw81x658uifng68ye8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783137217-529283
X-HE-Meta: U2FsdGVkX186ufzuEHj1G5/cFcLERcNC8VXdoAmRp5Dga0Z2iXUZMSgaFXN7A/7wdblfHwV73XLG66rdE1hsCHgFt4QDRCqafgRZNQ8xUnz21T4Qy5gn9+zn7b4oeEiXPFsg8YSY48ssufzTe7iNY0NwSTtt2dZ3yo38AM0AvK4p7g82cceRcuFAzUMT+HbUQla2nwbuM9rORqp2D/FBMi7UJob5O/CJNZpMXiME++r+nZ1Htyo9ps5+C7KzHmjoyry2Ibk3B1CJwjPjliqkPjHTjeKoeYLkM6819tfQkXyw0Fu9VCvAT7ZdagM83LSjCsszdUZkx0dXUn/xYES1aBtT4R9NijxrL6rD4oh+hp2UQpvmRfVZRFDx8MTjBWt5HG7Jp1lOYWEcD4nPNbp/tGJYzxhQFsQhtFi3vSvGxiU5Qzify77pk26gIAeJ+qvLlsbrwyZYZHnwj1V8Kt23YwSs8cS4Tp9c5jRM8qKiNkf2epywl44F9dsUSOolddZC+HKoFt4x11gJI0m2cghrV6AH8Kffwg7cnjdgBwXWoYhV0sBWiL6KTzTm8UrwPT4EP8k/9lkJhpnxxE2v/EXaRydWp5TpG6LancWbOnLZAEC1/3T1cjUyVWeRubkLe67VUtlVRkBEfmH13fcFEsYV7jIbK8LGBfeYuIOm2gxBaaXu5IufWiS8IsKmwd4v0Bqbp++rUdlazD/ClbNcwrVd/T+fn5e+1AHtv3E9ITBc8fLxdOqzRwVVdO7ClyD+lbbcySst2czrp2MyMn3f6DQFiZ85n2T4VSwAzlSH4YdfRu2jGQOhF768pg6swjCpKAC0iJF3ekO45+KZPyVTbTmRyvXUTDsQno6JlyW5n3InSomIMTyIKCEZgpik26RJ1FUex7SB+qFaa/rTszVWdrGBcarg3CafZaBovl5+mEK12F9t/i+qOQrlTsVuPcZfEAYkObO0x0sGcNjThkGmLuB
 RxFusySO
 0GcnjmNXU4h9oPp0FfCRcZD5jO6N1AQVuOLL5pmO3vPa4Yyg1l+FW7MxaTpu41owbUQ0wwT722XY1wvNFE52DpAdb+nzbN3NqfFB/5jLe33136OJEcoeUX0yr0cQtgwjrXO7NqI3IXMbKOAde7tBdCJWpZmF3Zu6Z5NxeIu6as9Z3QNQaOkYuyalxbVEyODSNRHmCHL+C5zrgqxktG4XlVII1zFIgl3ckc/lOKTaSzlk456PRkL79NPHzbmXg8RCsZ+dyb3TbljMieJCh3VMPYFVS0LM7OYFDCdUnNSPN6Di3ukKTdH1lEyviyFNthMsDzZkRihkyxfOz0v15BRntHg7JOsKx/0FSk256NZMzkRBWiFQTjPqaRSnryiKAoKfJQgWEbkb7wUfdfygcb8wMmGMOC93bJi6Lap4LYROMBU2zI7XEfS167M1VzDek4tU+3uAV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 3, 2026 at 8:05=E2=80=AFPM Muchun Song <muchun.song@linux.dev> =
wrote:
>
>
>
> > On Jul 4, 2026, at 04:04, Sourav Panda <souravpanda@google.com> wrote:
> >
> > On Thu, Jul 2, 2026 at 4:24=E2=80=AFPM Andrew Morton <akpm@linux-founda=
tion.org> wrote:
> >>
> >> On Thu,  2 Jul 2026 21:57:13 +0000 Sourav Panda <souravpanda@google.co=
m> wrote:
> >>
> >>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> >>> hugetlb_cma_alloc_frozen_folio() as a fallback to allocate from all
> >>> nodes. In this case, hugetlb_cma_alloc_frozen_folio() blindly
> >>> dereferences it in for_each_node_mask(), leading to a null pointer
> >>> dereference.
> >>>
> >>
> >> oh.
> >>
> >>> Fix this by checking if nodemask is NULL and defaulting to
> >>> node_states[N_MEMORY] if it is.
> >>>
> >>> --- a/mm/hugetlb_cma.c
> >>> +++ b/mm/hugetlb_cma.c
> >>> @@ -34,6 +34,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int or=
der, gfp_t gfp_mask,
> >>>      if (!hugetlb_cma_size)
> >>>              return NULL;
> >>>
> >>> +     if (!nodemask)
> >>> +             nodemask =3D &node_states[N_MEMORY];
> >>> +
> >>>      if (hugetlb_cma[nid])
> >>>              page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], ord=
er);
> >>
> >> It is possible to hit this with any known testcase?
> >>
> >> If not, why not.  I smell the smell of dead code somewhere?
> >>
> >
> > Currently, there are no selftests in the tree that trigger this
> > specific  MPOL_PREFERRED_MANY  fallback path, which is why it has gone
> > unnoticed.
> >
> > The bug only triggers under a specific topology: Multiple NUMA nodes
> > where gigantic hugepages are backed by CMA, but only on a subset of
> > the nodes.
> >
> >  1. The Reproducer:
> >    #include <stdio.h>
> >    #include <stdlib.h>
> >    #include <numaif.h>
> >    #include <numa.h>
> >    #include <sys/mman.h>
> >    #include <unistd.h>
> >    #include <string.h>
> >
> >    #define GIGANTIC_PAGE_SIZE (1UL << 30) // 1GB
> >
> >    int main(void) {
> >        void *ptr;
> >        unsigned long nodemask =3D 1; // Preferred Node 0
> >        int ret;
> >
> >        /* Allocate 1GB gigantic hugepage area without reserving */
> >        ptr =3D mmap(NULL, GIGANTIC_PAGE_SIZE, PROT_READ | PROT_WRITE,
> >                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> > MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> >
> >        if (ptr =3D=3D MAP_FAILED) {
> >            perror("mmap failed");
> >            return 1;
> >        }
> >
> >        /* Set MPOL_PREFERRED_MANY policy (mode 5) restricted to node 0 =
*/
> >        ret =3D mbind(ptr, GIGANTIC_PAGE_SIZE, 5 /* MPOL_PREFERRED_MANY =
*/,
> >                    &nodemask, sizeof(nodemask) * 8, 0);
> >
> >        if (ret < 0) {
> >            perror("mbind");
> >            return 1;
> >        }
> >
> >        /* Trigger page fault */
> >        memset(ptr, 0, GIGANTIC_PAGE_SIZE);
> >
> >        printf("PASS\n");
> >        return 0;
> >    }
> >
> >  2. Triggering the panic in QEMU:
> >   CONFIG_CMA=3Dy
> >   CONFIG_HUGETLB_CMA=3Dy
> >
> >  Then, boot a VM with two NUMA nodes, restricting CMA to Node 1, and
> > run the reproducer (+pdpe1gb  is required).
> >
> >    vng -v \
> >        --cpus 2 \
> >        --memory 8G \
> >        --user=3Droot \
> >        --qemu-opts=3D" \
> >            -cpu max,+pdpe1gb \
> >            -object memory-backend-ram,id=3Dmem0,size=3D4G \
> >            -numa node,nodeid=3D0,memdev=3Dmem0 \
> >            -object memory-backend-ram,id=3Dmem1,size=3D4G \
> >            -numa node,nodeid=3D1,memdev=3Dmem1" \
> >        --append "hugetlb_cma=3D1:1G hugetlb_cma_only=3D1
> > default_hugepagesz=3D1G hugepagesz=3D1G hugepages=3D0"
> >
> >  Inside the VM:
> >    gcc reproducer.c -lnuma -o reproducer
> >    echo 1 > /proc/sys/vm/nr_overcommit_hugepages
> >    ./reproducer
> >
> >  3. Outcome:
> >
> >    [   33.586151] BUG: kernel NULL pointer dereference, address:
> > 0000000000000000
> >    [   33.586512] #PF: supervisor read access in kernel mode
> >    [   33.586680] #PF: error_code(0x0000) - not-present page
> >    [   33.586879] PGD 1023c7067 P4D 0
> >    [   33.587668] Oops: Oops: 0000 [#1] SMP NOPTI
> >    [   33.588265] CPU: 0 UID: 0 PID: 336 Comm: reproducer Not tainted
> > 7.1.0-virtme #5 PREEMPT(lazy)
> >    ...
> >    [   33.588960] RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> >    ...
> >    [   33.592469] Call Trace:
> >    [   33.592672]  <TASK>
> >    [   33.592853]  only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> >    [   33.593127]  alloc_surplus_hugetlb_folio+0x6d/0x100
> >    [   33.593284]  alloc_hugetlb_folio+0x3c5/0x660
> >    [   33.593430]  hugetlb_no_page+0x3d9/0x650
> >    ...
> >
> >>
> >> Sashiko said things:
> >>        https://sashiko.dev/#/patchset/20260702215713.627941-1-souravpa=
nda@google.com
> >>
> >
> > Sashiko is right to highlight the following: By defaulting to
> > node_states[N_MEMORY] instead of
> > cpuset_current_mems_allowed, it appears the allocation loop could searc=
h
> > all system nodes, breaking NUMA isolation for containers.
> >
> > I will apply &cpuset_current_mems_allowed  instead of
> > &node_states[N_MEMORY] in v2.
>
> Hi Sourav,
>
> Thanks for your report. However, I suggest fixing it in alloc_fresh_huget=
lb_folio(),
> because we also need a right node_mask for alloc_contig_frozen_pages() ca=
se.
>
> Muchun,
> Thanks.

Hi Muchun,

    Thanks for the review. I completely agree with you :)

    Here is the planned diff for v2:

    diff --git a/mm/hugetlb.c b/mm/hugetlb.c
    index 571212b80835..ab5deba4f7a1 100644
    --- a/mm/hugetlb.c
    +++ b/mm/hugetlb.c
    @@ -1865,6 +1865,9 @@ static struct folio
*alloc_fresh_hugetlb_folio(struct hstate *h,
     {
         struct folio *folio;

    +    if (!nmask)
    +        nmask =3D &cpuset_current_mems_allowed;
    +
         folio =3D only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, =
NULL);
         if (folio)
             hugetlb_vmemmap_optimize_folio(h, folio);
    diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
    index 39344d6c78d8..79dbd0baafa3 100644
    --- a/mm/hugetlb_cma.c
    +++ b/mm/hugetlb_cma.c
    @@ -34,7 +34,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int
order, gfp_t gfp_mask,
         if (!hugetlb_cma_size)
             return NULL;

    -    if (hugetlb_cma[nid])
    +    if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
             page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], order);

>
> >
> > The other issue Sashiko highlighted is also valid (but unrelated to
> > this patch) and I can bundle a fix for it in v2.
> >
> > Essentially the preferred nid needs to be extended with a
> > node_isset(nid, *nodemask) check.
> >
> >>
> >> Ackerly's "mm: hugetlb: move mpol interpretation out of
> >> alloc_buddy_hugetlb_folio_with_mpol()" made big changes to
> >> alloc_buddy_hugetlb_folio_with_mpol():
> >> https://lore.kernel.org/20260702-hugetlb-open-up-v4-2-d53cefcccf34@goo=
gle.com.
> >>
> >> If this bug is real then it would be better to stage your fix ahead of
> >> Ackerly's series.  Possibly with a cc:stable.  Then I can redo
> >> Ackerly's patch on top and we'll need to check that this bug isn't
> >> reintroduced.
> >>
> >
> > Makes sense! Thanks for connecting the dots :)
>
>

