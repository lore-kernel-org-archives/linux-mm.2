Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E3FC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 20:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6D36B00B5; Fri,  3 Jul 2026 16:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167606B00B6; Fri,  3 Jul 2026 16:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0559D6B00B7; Fri,  3 Jul 2026 16:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7D6E6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:04:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B65A1C12D1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:04:47 +0000 (UTC)
X-FDA: 84948543414.06.769F601
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5F47B1A0008
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:04:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t2I845Nc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783109085;
	b=NpfG6aWgyhQNA8FQOLYfPe5cxODx6kFlowcJZuC53AuR6VgyBaT1eMKQdrlotDXPyCe7eA
	3NE5pDS9PyBsSFOF0uySWo64+Re32RWBWGzXoplPtsscbaBz/RO4bHkhG/NaF3erKT5hZ9
	pZd9mhG3iI0BsZ5Ytt8tDtwuJhPND3Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783109085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caiPVIc5u9Qorek0yTCcNMWpnd4ICIjbHGVVeywoPZI=;
	b=asJwxA173kj681S6GvVmgtRnhZiQr/KajPemTnva2nWf+BCUAoMCIAVDJRgWASvNUWxw2n
	YbGe0oBudOJkd9foa091GVp6APBoAawOvBBab6Z5UhvUGOyq/DwMnlsvWNFOTgrIy8ydj5
	29NE5+487BVqeGq6ej63Cb4rUPr/GSo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t2I845Nc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aebbe750f8so26217e87.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 13:04:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783109084; cv=none;
        d=google.com; s=arc-20260327;
        b=g6leDTheZHrwv3JTsvos9NjO0DB9Yt3jrInBdZiOSHal8SgjApslbJUMQGK7cGeQ/h
         9X60RcXKVq91wBODHSAjcHID14W+SA3f3zRWI7zH+yji6JGifhrdeBgFeP2vWLD1g3SG
         RazSQ5TlJz/5HQewtVnxlg3eHuwsOwXH5CzHMAeEbyiy1Hif/9QNQoj1xZEOJHntxlgq
         0zpR1fSWyZ+AWfrYv3oKpFQJMxeYUeMD9TyIFhaLiDkENVG4CM1ReKFVqgtUuN5XgPhj
         3ODlFTHEw5jEkzknoZ2BdLzu6p3CfZwBfC3BBMiDx5GLCNwG7MWilTdWoRmwVMy9l/XG
         Vm0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=caiPVIc5u9Qorek0yTCcNMWpnd4ICIjbHGVVeywoPZI=;
        fh=CGeZ6SnJsD60tx0t/jO912HdKpCNwqT/OThRCEznezI=;
        b=dXdD57a+M0j+aAbJBUnNCzhjPi7B2day4ZByZ8WSPGeG3AH9tGb8lx5mKajQA6cL0/
         onL+SZH9JWUt0FyQ4IFhqfGyCMZ+y+xtSLkRz8AKzDSrWdFhXkCtljzXJef9t8fCvY8N
         HsFTNGYGWhuGli4R4vbb5BeNvWEsMc8wXd1UOug8dax02V10oNsjaZfEca4+Hy5pixqC
         hyt8k/gQzOpCut+y/HXtLGK7u7cgw/locGHGBl0xnQbQukKKINK60SMhAFWLDGg7BrZ6
         1zbbu6xfv3i3pm0o1PoBYTSF7OMVFhIF6drYFpj3mF4knqnhh5LCyxys+j+L7lMdp1Ha
         bMnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783109084; x=1783713884; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=caiPVIc5u9Qorek0yTCcNMWpnd4ICIjbHGVVeywoPZI=;
        b=t2I845NcOohSySXXdMXjvOo5cYxlIwDYYD783SuZYZFYEE0WEQLP1pldkFay4sbmyD
         dg3cpIH6e0U6x3tG+jV+KTaaJ7i9wPTJ3FinKT+dCRMagXXteCTEVHFCmRaZSOaFJwjv
         umzZ3wFysHQC65ul+FppwvnEmjoXuplsBAVjBasxiYMy6yFY1qGOTSC8BRUS+8+Vb/e8
         BLkoUu4d95vuaMu3NT5Nta7ByQTnLys7dxKgqhBwfMteSCWG7zurdUbeSDRL/H96zMup
         EoXDertZjmz9ypHfewcxMLdABkWJ0en+f2yiyVHLdpnkR7DO2RIL+ziex8a1Hp4CFQj1
         +vCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783109084; x=1783713884;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=caiPVIc5u9Qorek0yTCcNMWpnd4ICIjbHGVVeywoPZI=;
        b=Pdu2QiXUVuW4UW6QaQ21A4VuE7ekSo0egjaRNxurrLkB+S5bPxfAvdTXuSxcN4glkl
         v2TvM8VYNlGRUec2Bph7skjQefLtB155tZDnoNj3wRnUI6YHMvs5yo8P6tkIjndOod/J
         Orbw3bnFo0CkRbAA2t1jzSvM5+V0zKLCHd2ulooIFhea5miKvGMDx6bnf5nXwPKXq2Bz
         ++iI9uJIs73CFzZlJg38rgMygdH9PC3RsHLGA0KlZHONkFcPKQL5moxGgUDemiypCJU7
         NEPPBnNFvm/zvKsfavBP333Qxv4Du0Wjmoyjam/60Z2TbczsnUn2KqE+rvDEdvW/oaiM
         u2fw==
X-Forwarded-Encrypted: i=1; AHgh+RooxL+8Mfjl78vJmYpB//pxYqB86ZDGL2tyepk6o+K9tJeE4b3Op87lOjQh5x+5v9qU5xQ9QFVmWg==@kvack.org
X-Gm-Message-State: AOJu0Yz5ZOfDM/H/2JRW9NiMIrNbwKtqUbIvMFV8pVXh3TFR7r6QYDnp
	j22l9UGin4AvCAqc+h2Iqyb53zgM0q0pCmbIDfSkreRgM4nYuRZ8wAiksICygvzvNQqVX01zU9r
	6EwcaNwWxWBRLI6WP7kg9nKT+QYVo4LjTjTfo7FWV
X-Gm-Gg: AfdE7clS65Rg9S8g+9AuTIhqt8uGyCXsYy8Hi+ViB5ysYruYyRZ2kyBRy7gSDDzrq2R
	XbqyipKF2Rwt3VsLPMkGsx8eFtGwTr6LWcy6hDo123cbk4Vo+y3q/zDSbe9t30dDK4wwPZPNRpV
	60yfGVWQxNtQpythV45uL+8hbiPEF37kA3GTOyNo8j270XwZFuolDFlDDvKepDbfID2WJ8EdG9K
	fs3xQRNofbHQelg/40k5YsK75u7gBe3g4uyq5iz5NAUFZLjzsWMYJgUtXl6u8g8SPyjRILcZH8m
	FxZsyRd6sg+awDnBeVMAnA7TaQDp5sOmEwepwt5SyhKtY8OQjDNpwE4ME36/vA==
X-Received: by 2002:a05:6512:b28:b0:5ae:b9c5:f29f with SMTP id
 2adb3069b0e04-5aed45b91f2mr18854e87.2.1783109083225; Fri, 03 Jul 2026
 13:04:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260702215713.627941-1-souravpanda@google.com> <20260702162415.142571f4d8c43aa4b95b9f7c@linux-foundation.org>
In-Reply-To: <20260702162415.142571f4d8c43aa4b95b9f7c@linux-foundation.org>
From: Sourav Panda <souravpanda@google.com>
Date: Fri, 3 Jul 2026 13:04:31 -0700
X-Gm-Features: AVVi8CfnhBcwJDwHXGRiTXGwScnvInbaFovID-t0VgFmuRQDW2iG1p51j4ZIosI
Message-ID: <CANruzcR+uQPisER8KDFH3x4C-O22xvUwQEgv2=TQ=MHooO11Gw@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: Fix null pointer dereference of nodemask in hugetlb_cma_alloc_frozen_folio
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	surenb@google.com, fvdl@google.com, gthelen@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5F47B1A0008
X-Stat-Signature: 1q5h8wcoswgkmxd41pmcg849ybc7qixc
X-Rspam-User: 
X-HE-Tag: 1783109085-638732
X-HE-Meta: U2FsdGVkX186SMvxPJta3kW+T3HhLALtYj4SG3UnwXZ5ZKrmsvtiwKIP8LjPcQU6SLOJWf0WhnhweqpLhezNDaj61ETkttSZW1JdOW38AaoLpSerooiUxjPyURdUHPlhfQl5EBur5tCFdrI2PcNB++qdr8zG1TJQ6JHKjs/FO9K8hrUCjityS9Hyk0/fyv77EU8p02NMNvtMYrVypNcvMW8c13UVkelQMNY3kg4WpJjeneg/szPNVcYYf1/MY8iIF2qn6SMhMRn33pQiy41D4P27DqSl/fJFbn8BQVvtA0Ib36crB0pamaAMwXzaUep+alLc8MQPR+NGzCiErn99aA7OGONzAd9fVF3q7c5lHdkKCNrR5Wvh1zwsx8imM9zDhEvwRLY0W+Xepl8BsQOTSfqwvEAKuMVsUeRq21/JsBS4R18ZEaZtGUYRApDeUW+1Ny+z6NSjtwZ2k7ql3nc2Sv3imFTHcx9T99qmqdMfUCrfkShD0JzoTu3z2UqlIS5mB102Hqxb/BYdY9outX64b4BcXqUspCD73UfevCHtdMsvkpio/7G8fxYRcUeUCjPLEqKItR7jKhr+QBwSUMxaZW7NlSdJOJSn8HwM2J+IrmskZQFmBWeenVMwtXhrBUbX62RF43h+hMIwnXDCVxz1YOU1By1ITfsJfwAFcN7oG59IZuI4GNamdFgDSssp35UIU1b1WfSOyhIiOeO2JI7sr7FWKuxSN5SH+TwdO4dgTLUrOel5M74kawbFYerowl9qZL7YlyE1dC8AHJA42BiZlw8AJXNizgIkMG5zs9jtaGa3FQK6vzOSJeHL+cIewx+pHFyuqB9fkYvB+S8j0flEENI8kFktd2VuzVkQrzgXrLwxMvh+yTYrXR7AO45eEqYKnGzpgz4F+TOTzcTfqqQmJa4zkQn+tl+HGWjoDy33l0OVd1JDzBxXa3Tw417ZyORx7KrrUPHENUVvvyLF7E0
 4OeQQG9r
 HFjFIFjHwULTbyCmT3Ci8I1rLqRX45FBDm+qCRiEFBRFnBDFzIPJw2JtT9BZzC2JdrF31jcYaDrF9WiR/wmO/mRkob+WzZAlL3V3S5P6bkqGdQpxyU5WKZMboLsvGF0ROpcC2wjDAGva4WHC3MDm1CL0YmC566D4ONEkvQKXiWe7Yt8OoueW43BHjt+0+AZJpWCKGgk/G6N3V7RV3Lhy57tZT3BtUBOLKU5lcNWcdR1jWWZzoYnKIVRiewNPp2tOVUyLBOn/gK551jNB7N3Syci3XVYQYNYCjoPlUTnnHxfswQ9gymhKCehrPAhq8LKzkdojK0UARzpfhWBMxURJqpr9/fS3rSFD4sAB7AO5wwXut2fl9Bykfv5FpKmnaXV2pNqeVjP4W4COYgVxfrQT5bRJQF+k+jwIXzF26siBOa+3kfz17q8dbmjXTMkkfgFeEb6J4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 4:24=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu,  2 Jul 2026 21:57:13 +0000 Sourav Panda <souravpanda@google.com> =
wrote:
>
> > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > hugetlb_cma_alloc_frozen_folio() as a fallback to allocate from all
> > nodes. In this case, hugetlb_cma_alloc_frozen_folio() blindly
> > dereferences it in for_each_node_mask(), leading to a null pointer
> > dereference.
> >
>
> oh.
>
> > Fix this by checking if nodemask is NULL and defaulting to
> > node_states[N_MEMORY] if it is.
> >
> > --- a/mm/hugetlb_cma.c
> > +++ b/mm/hugetlb_cma.c
> > @@ -34,6 +34,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int orde=
r, gfp_t gfp_mask,
> >       if (!hugetlb_cma_size)
> >               return NULL;
> >
> > +     if (!nodemask)
> > +             nodemask =3D &node_states[N_MEMORY];
> > +
> >       if (hugetlb_cma[nid])
> >               page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], orde=
r);
>
> It is possible to hit this with any known testcase?
>
> If not, why not.  I smell the smell of dead code somewhere?
>

 Currently, there are no selftests in the tree that trigger this
specific  MPOL_PREFERRED_MANY  fallback path, which is why it has gone
unnoticed.

 The bug only triggers under a specific topology: Multiple NUMA nodes
where gigantic hugepages are backed by CMA, but only on a subset of
the nodes.

  1. The Reproducer:
    #include <stdio.h>
    #include <stdlib.h>
    #include <numaif.h>
    #include <numa.h>
    #include <sys/mman.h>
    #include <unistd.h>
    #include <string.h>

    #define GIGANTIC_PAGE_SIZE (1UL << 30) // 1GB

    int main(void) {
        void *ptr;
        unsigned long nodemask =3D 1; // Preferred Node 0
        int ret;

        /* Allocate 1GB gigantic hugepage area without reserving */
        ptr =3D mmap(NULL, GIGANTIC_PAGE_SIZE, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);

        if (ptr =3D=3D MAP_FAILED) {
            perror("mmap failed");
            return 1;
        }

        /* Set MPOL_PREFERRED_MANY policy (mode 5) restricted to node 0 */
        ret =3D mbind(ptr, GIGANTIC_PAGE_SIZE, 5 /* MPOL_PREFERRED_MANY */,
                    &nodemask, sizeof(nodemask) * 8, 0);

        if (ret < 0) {
            perror("mbind");
            return 1;
        }

        /* Trigger page fault */
        memset(ptr, 0, GIGANTIC_PAGE_SIZE);

        printf("PASS\n");
        return 0;
    }

  2. Triggering the panic in QEMU:
   CONFIG_CMA=3Dy
   CONFIG_HUGETLB_CMA=3Dy

  Then, boot a VM with two NUMA nodes, restricting CMA to Node 1, and
run the reproducer (+pdpe1gb  is required).

    vng -v \
        --cpus 2 \
        --memory 8G \
        --user=3Droot \
        --qemu-opts=3D" \
            -cpu max,+pdpe1gb \
            -object memory-backend-ram,id=3Dmem0,size=3D4G \
            -numa node,nodeid=3D0,memdev=3Dmem0 \
            -object memory-backend-ram,id=3Dmem1,size=3D4G \
            -numa node,nodeid=3D1,memdev=3Dmem1" \
        --append "hugetlb_cma=3D1:1G hugetlb_cma_only=3D1
default_hugepagesz=3D1G hugepagesz=3D1G hugepages=3D0"

  Inside the VM:
    gcc reproducer.c -lnuma -o reproducer
    echo 1 > /proc/sys/vm/nr_overcommit_hugepages
    ./reproducer

  3. Outcome:

    [   33.586151] BUG: kernel NULL pointer dereference, address:
0000000000000000
    [   33.586512] #PF: supervisor read access in kernel mode
    [   33.586680] #PF: error_code(0x0000) - not-present page
    [   33.586879] PGD 1023c7067 P4D 0
    [   33.587668] Oops: Oops: 0000 [#1] SMP NOPTI
    [   33.588265] CPU: 0 UID: 0 PID: 336 Comm: reproducer Not tainted
7.1.0-virtme #5 PREEMPT(lazy)
    ...
    [   33.588960] RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
    ...
    [   33.592469] Call Trace:
    [   33.592672]  <TASK>
    [   33.592853]  only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
    [   33.593127]  alloc_surplus_hugetlb_folio+0x6d/0x100
    [   33.593284]  alloc_hugetlb_folio+0x3c5/0x660
    [   33.593430]  hugetlb_no_page+0x3d9/0x650
    ...

>
> Sashiko said things:
>         https://sashiko.dev/#/patchset/20260702215713.627941-1-souravpand=
a@google.com
>

Sashiko is right to highlight the following: By defaulting to
node_states[N_MEMORY] instead of
cpuset_current_mems_allowed, it appears the allocation loop could search
all system nodes, breaking NUMA isolation for containers.

I will apply &cpuset_current_mems_allowed  instead of
&node_states[N_MEMORY] in v2.

The other issue Sashiko highlighted is also valid (but unrelated to
this patch) and I can bundle a fix for it in v2.

Essentially the preferred nid needs to be extended with a
node_isset(nid, *nodemask) check.

>
> Ackerly's "mm: hugetlb: move mpol interpretation out of
> alloc_buddy_hugetlb_folio_with_mpol()" made big changes to
> alloc_buddy_hugetlb_folio_with_mpol():
> https://lore.kernel.org/20260702-hugetlb-open-up-v4-2-d53cefcccf34@google=
.com.
>
> If this bug is real then it would be better to stage your fix ahead of
> Ackerly's series.  Possibly with a cc:stable.  Then I can redo
> Ackerly's patch on top and we'll need to check that this bug isn't
> reintroduced.
>

Makes sense! Thanks for connecting the dots :)

