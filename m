Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94AF606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 00:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Dqt0i3GV
Received: by kanga.kvack.org (Postfix)
	id A1BEF6B010D; Mon, 19 Oct 2026 20:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2D76B010E; Mon, 19 Oct 2026 20:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2436B010F; Mon, 19 Oct 2026 20:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5AC0F6B010D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:16:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3A15C078C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:16:40 +0000 (UTC)
X-FDA: 85341088560.08.1B2C2E5
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id D8AE914000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:16:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dqt0i3GV;
	spf=pass (imf23.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792455398;
	b=hC1eETAhEBSX5ejv5yF7vegfYZptVRfOGZD14AuPIAUr64etLRUJNKqpcWHVL8Tli0KV5q
	WVggDGent+wTk99A/TKyL3cmsnDf3jUr1+4APEZLhgLvD2vrtDqCK840aqCWp9lb40+kRP
	xSJ3IS0Q1otDM9USBmpg441G8eyCRxQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dqt0i3GV;
	spf=pass (imf23.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792455398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeN6lMsAWhAX3rKxSpB3MVxlEglVTKUqWIRPPdmiiXQ=;
	b=oGUc5Sl//rVNMTYTtIfeNjZCEYkxxHn/o5KNPrDp846FxHRSnWziWGfPS15pndQfEzPWN1
	b9D4eu243THR+NvcXtI2xlKl0HfexYpgLCrRNXu5yprY8E58Lkk3+hP0OOP/TmPFeR/kUi
	fhUV2fVcWf1qv4RLJ5qlU6GkRQpDn0M=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8ad98c3fb15so21181237b3.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:16:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792455398; cv=none;
        d=google.com; s=arc-20260327;
        b=lIZMurAp4jgR6JKmCU/ROdPViktYhLMy0DHA+yt4U134xOKC7VwkDVs+QYMDBrVbNJ
         IOUH90xiZgt3+b8nrUhe1YdVArz+m6eb9882/4CCG5/BJCO4DOx9VKbUYt+uCAHnEM9y
         bm2XW5i1l58DTL6PjAALDKbngF0ncMHJw50HD8kd8aeWu/IhKhNmxeQ+uYWP0DTK3abN
         BPv9KVXyRdMb7g4NsUr2jRKD8355mfN598wf0MALe+8JOJSqNo9w1/GX4swA3McAFeVK
         NVuH2rjLiv59rXEuhtZyxGStMdoVnLS/R398PMGEjcY/7fHEreRZaQQ+ej1PBMCfroE2
         +G6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oeN6lMsAWhAX3rKxSpB3MVxlEglVTKUqWIRPPdmiiXQ=;
        fh=cQLBR6DIIwZsWDqQmyjqHM3ujo3VZ//n2yNJDyuOLvw=;
        b=IZUWdeHnEzSTuH0OYDWz2Fv3IHq44Km/GyH73S8aTu0GnwZQqUCouyLj6fkdgAbEgy
         XfoLTK++NN3C4KPD2Wd30WVxzuPMtdnwXWU3HmQcxhHq6pAKh75piG4d46RzlwAXa6EK
         NzOtbT8N429Xx7IVhioug7RqPj4ODvO0F2dK+A87J+6rxfG3KU5sgs7dr2oX1dHfq9we
         /ddBT6E5D1xFYgjfOvvz4jVMeiybSzDD8pEwW8LsyWRJta69dIAAlXs4gMvsE4Xi36Yw
         KK8P4IgSqXRh982ajep4FCrTdkrJH9X2EtJmQqpolGwOGQgU+gKw6wNnpgZSat1CF12T
         /H5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792455398; x=1793060198; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oeN6lMsAWhAX3rKxSpB3MVxlEglVTKUqWIRPPdmiiXQ=;
        b=Dqt0i3GVK/Mcqjs32nJN7+eYEAhxpApZdxOkHMgOuVrGCXeX/dNHNQGTR/HqBOR2c5
         0iRSLPAFjiPjfL+mZn/JCq5wRlsq7y+uXY9iFURFsERrkMUGcWs0ItrZLm/Q9TFDIcDa
         8ubwdkEvii3Feus/UPlsjxQTqJs+PQm6r7gQJ97v68xZHE7xmwq1fmQ1yXsd4KvchBRB
         H+ILwLrkhoTJ5RjoWqXVsH6F99oetENDKyZZnLXRgA2sQYl5FPJPb3xG/236hS882BUd
         zIRBRT23LqgWMHm+Oaq6o8xUd1LPHkNY5J9tdDBYkRGRITBqQ3xfM9pvC3NzyV8tJ0Za
         XMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792455398; x=1793060198;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oeN6lMsAWhAX3rKxSpB3MVxlEglVTKUqWIRPPdmiiXQ=;
        b=pk5xBbl2zm+kfKVtuGnHZB6/6K+AjE4laUtct4HYjrIwavzx53nibV3kbJ02Te8zDI
         L2RoHFIIJ49qfSugVERe4hM3v2+6zqCw9Y5NStnoYoCdYvzIXkxtCzBNJgSqsL0Vk8FA
         51ZheWFY3zBbIG2A48qsXIB3NpZXhnlLkf1TwvpmTh3SGMNNT8N3jnMehffTIsCZ7yyO
         mRGU05aQ3dWG35JryEyh+6tWQPKUKyexkBaTcsPGl+jDeuunxY5cu1NcqSxXTlcfQyPO
         ORXJ3GfgHEyBj/44ArrQ6X9XM2YjgVcbUfO6exbBuUcswizlk4PVfgvl58RiblwOHv+3
         P/oQ==
X-Forwarded-Encrypted: i=1; AKwUvByzFKJreUb+cEg4CWkd6d9SK+H8W67wCb1BLOSERkwoIHKteTICcpghQM4qdl4f1PmqGmIKjmT00g==@kvack.org
X-Gm-Message-State: AFq9FYJygUBBzKFXpkzxkMPOc1ko/Kesz6vFRZ6w0g6EPK20rBMftYpl
	3QUYUJ22TiPQSBzBd7r/hkI34tg7S2k4DzKW3xpZuRFab66iBHY8fhY77776PEjit6IIAt7ZrzX
	W+Rhel/qvM0Si5pHTmLxlnXs31uY5boc=
X-Gm-Gg: AYBFou2DC9GUYk0J8QTYGjIaT8LtmEdm64yZvs0kSZOZ7HKqT1ye0XI5f+XzgelUEso
	Nnc0UOa02LqK3F3QYr+4Y92CGaQWIwGUNBSHS8Kcwa0sTgAY/jvyEj2sVzDu3IihyaCMZltp/Hn
	IyQPIiyBWVl9kUQ2rqBcm9/8btGRvp1zdsldjm3DZpGqldrEzk2EQiYkqn6xg9lsgTP+h+3+tMw
	mVgcVYvCxkNf5WGkE8KyWfFbQsVRn16ThopanNbYKMr8V/JPhxC6X+UELXxLljqUNzY+2BuCw9D
	ed76pGEIIBWL3jzs+2QAHyAZjMzj3Dbq1dhHy+AVzfnAXwbvrdGsKzgKo9/Q3mmaX2hJCTmak9b
	rop0v+7FPZi/5mb6Z0wj31+laT4AntDc9ZPmcVSZvcpV/FvmHug7lhHXRxji7UqIgjF9fZk0Vv1
	pbOfauBsOIwGpFqUfvr5fJB4t5lF/8aF0Ayw==
X-Received: by 2002:a05:690c:f8c:b0:8b0:f116:122a with SMTP id
 00721157ae682-8b0f214020cmr42505667b3.14.1792455397879; Mon, 19 Oct 2026
 17:16:37 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
 <20261017050928.128582-2-sidchintamaneni@gmail.com> <CAGsJ_4wGq9oc05=-g4aWptLdCbTwUjMjXk4Rd6KjJ6x=tzMm+g@mail.gmail.com>
 <CAE5sdEhGFtGF6LC4xNkMwGj3vTxLOW=GNBXnk3-JmsgjntXx0Q@mail.gmail.com> <CAGsJ_4wmvBvEn_vXu8-c6BRAnRewYmTs8iUd8T7KRx7_svZrwg@mail.gmail.com>
In-Reply-To: <CAGsJ_4wmvBvEn_vXu8-c6BRAnRewYmTs8iUd8T7KRx7_svZrwg@mail.gmail.com>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Mon, 19 Oct 2026 17:16:27 -0700
X-Gm-Features: AclHuK_duovmGh6MgK6NvBiqxnyMv5OCjdQqCPJY238RVK32rd2T9hHtvaZrtRM
Message-ID: <CAE5sdEiq3bY1kgMUQ6x7RRJCx0JH4sQ9Z_a9_YQSM5FKNwpk8A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref in get_lruvec()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: D8AE914000A
X-Stat-Signature: p4zs5eexsi7jrkd7skq1inomqtp14yog
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792455398-645016
X-HE-Meta: U2FsdGVkX186idM6cCdbyjsYNTZIDzf36TEQn9RDSBTFgbpHnUSeXehbJD0sjTet/bS+49kOx1jlt/DRqUGJn+TIldjrfzQHRmX4iwH5dKzUqhS2aAUWRy8M3Xw6YmouXpVjO9f8MWotPIDx4xGSjTQzDi6mZ6vZXpJuveGzNWPB/zPKIS+j5ElN+a7SZhN/m0mpIgt/bofbzR+5pGbWHIqE8meGdVTycJ9MjtrlssP5PzK16rugeBXNggM3be+6WKvlv720M3Tw4giFe16f0ljlZakWaURdkNICfpSh9qadlncnw3GVPriPjRlO7Y0KbhBe6NHOmv9usXhSDmzLsJBRrieZVmdYrob2ofMtEi+g7+eJ14HDpOoGclCbReLDE3lua4qsfaT0HK/F7jqcJrYZFqj5kD1O/1FHp50zgDPxPdGnOmGvXlc3C4Vw6WR37frRf26slFAC7W6S2efHfRw+2asGz0QDfb7zY09GUgHfc7KtGpBpmekKXz+1FjI7nGvqOYIVQbLyMbgbHCy9FX8/ohll6uqTPZArcPOCmiCtmxhMsbUZCYgrJXPga0SpmS9McgT3pqiturWaJcRSmOL6f5JlMKBFz1ihAbtkiccDnr+TSFvH1AUansR0HJ6ZEEQKmx/XMZiqZ+ZPSKlW2RSLHYuuFU0zynva31BhRzaUQU0AQSdt4EkUKBKU7nb72LKJdsCSVAW7NUXVpeslyJKZ5DUqn3ZZqGX8vPjSrF9nhFrzEkmXi3DEnmUNyJ3kbUWn472PhViQ5vzNG02AimAPlmpYpLemByjl2tHd/7MbJpHYR9XqzuVmbkhzOtqorinnVl6P7g028A+/cNVhit6cqfEFElLngYepsEd4JgbdWLYvaJo5LIPYtlHcaMCY3JcdGLLy7tL43UlI+Zaw2T4+CPoI8td6uvpY+WCJ6pXNhnFK6n4VN0d/DtYDjT9fj8tQxAFe2fH4sdwXN+q
 kpm+LFSj
 MQwIXOpfgZFRPxPBo1d/0iahiNw/pCWsE0mxFP3gAAm8euD3ryDp7VJnXfU5QJEQ84ZrBb4uNcCwfV+VWUMSspQSbREJmkJaRSWr+XDoQT1L0JvAw7gO4ze1K6//XU8mKE5kbpe9Oe9yXUi1SS/La+MmCe51nXUrsiFxrafiIjYesF6YvhsQXmPB4SI6f5ESUGKUkrFzqbZhAZlkMOrZFrZAuRP8Cx/8vPn7Q+DHFZStqFh9PI6Y0QyiIwf/vifZxiGKxuzpqmDHp3Zn6kS30OuxdBUFyGN4DYyrDneSw11NIl3s9GlC6quhOBe2+Po1Q2iYAswqYlSRqU1YTrvP3idne5z0vk3zBbD/QZilyouEf25A4nhxCZ7z7Q7XsKLT2oHss12HArmn+JoEpnYNpkpihj7dVUiWv+o8MuQ2NRv7bROqThOfT5SJ84tOltI94TCfkUc0AasLyH1fpTB8HjpvGojRIdKz84GeMC1pZg6t1Ey5jjsOTxhRc+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 at 16:36, Barry Song <baohua@kernel.org> wrote:
>
> On Tue, Oct 20, 2026 at 4:33=E2=80=AFAM Siddharth Chintamaneni
> <sidchintamaneni@gmail.com> wrote:
> >
> > On Sun, 18 Oct 2026 at 14:24, Barry Song <baohua@kernel.org> wrote:
> > >
> > > On Sat, Oct 17, 2026 at 1:09=E2=80=AFPM Siddharth Chintamaneni
> > > <sidchintamaneni@gmail.com> wrote:
> > > >
> > > > Andrew Morton reported that get_lruvec() has the same problem as
> > > > lru_gen_shrink_node(): when memcg is disabled on the command line
> > > > (cgroup_disable=3Dmemory), it returns &pgdat->__lruvec directly and=
 so
> > > > bypasses the initialization of lruvec->pgdat. The MGLRU debugfs
> > > > interface calls get_lruvec(), then dereferences the pgdat pointer i=
n
> > > > lru_gen_seq_show() and other paths, so these can hit the same NULL
> > > > dereference.
> > >
> > > So userspace must have booted, since otherwise we couldn't read
> > > debugfs. The reachable case is therefore a memory node with no
> > > LRU folios when debugfs is read? So this could happen on a multi-node
> > > system where folios are landed on other nodes but not on this node?
> > >
> >
> > That is my high level understanding. I'll let Andrew to comment if I
> > am missing something,
> >
>
> I made a silly toy setup by running two numa nodes with one of them has o=
nly 4KB
> memory, the other one has 1G-4K:
>
> qemu-system-aarch64 -M virt,gic-version=3D3,mte=3Doff -cpu cortex-a53 -no=
graphic \
> -smp 4 \
> -m 1G \
> -object memory-backend-ram,id=3Dram0,size=3D1048572K \
> -object memory-backend-ram,id=3Dram1,size=3D4K \
> -numa node,nodeid=3D0,memdev=3Dram0,cpus=3D0-1 \
> -numa node,nodeid=3D1,memdev=3Dram1,cpus=3D2-3 \
>   -kernel arch/arm64/boot/Image \
>  -nographic -append "cgroup_disable=3Dmemory
> ...
>
> Then I got a machine where node1 is very difficult to have a page in lru.
>
> then i ran the debugfs for mglru:
>
> / # cat /sys/kernel/debug/lru_gen
> memcg 0
>  node     0
>           0      14972          0         953
>           1      14972          0           1
>           2      14972         18        3308
>           3      14972          0           0
>  node     1
>           0      14972          0           0
>           1      14972          0           0
>           2      14972          0           0
>           3      14972          0           0
>
> now you see node 1 has no page in lru but yet i didn't have any crash.
>
> i think i will need more time to figure out what is the problem and how t=
o
> reproduce it.

I've asked AI to repro the issue with the similar setup

qemu-system-aarch64 -M virt,gic-version=3D3,mte=3Doff -cpu cortex-a53 -nogr=
aphic \
  -smp 4 -m 1G \
  -object memory-backend-ram,id=3Dram0,size=3D1048512K \
  -object memory-backend-ram,id=3Dram1,size=3D64K \
  -numa node,nodeid=3D0,memdev=3Dram0,cpus=3D0-1 \
  -numa node,nodeid=3D1,memdev=3Dram1,cpus=3D2-3 \
  -kernel "$KERNEL" \
  -initrd "$INITRD" \
  -no-reboot \
  -append "console=3DttyAMA0 cgroup_disable=3Dmemory
initcall_blacklist=3Dkswapd_init panic=3D-1"

and it was able to repo it. AI identified that kswapd is initializing
the pgdat during boot, so blacklisting kswap_init was able to repro
the crash when reading /sys/kernel/debug/lru_gen

[    1.347868] Unable to handle kernel access to user memory outside
uaccess routines at virtual address 0000000000005040
[    1.347920] Mem abort info:
[    1.347929]   ESR =3D 0x0000000096000005
[    1.347950]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[    1.347964]   SET =3D 0, FnV =3D 0
[    1.347974]   EA =3D 0, S1PTW =3D 0
[    1.347986]   FSC =3D 0x05: level 1 translation fault
[    1.348249] Data abort info:
[    1.348277]   ISV =3D 0, ISS =3D 0x00000005, ISS2 =3D 0x00000000
[    1.348291]   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
[    1.348302]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0
[    1.348345] user pgtable: 64k pages, 48-bit VAs, pgdp=3D00000000485f6600
[    1.348369] [0000000000005040] pgd=3D0800000043640403,
p4d=3D0800000043640403, pud=3D0800000043640403, pmd=3D0800000043620403,
pte=3D0000000000000000
[    1.349148] Internal error: Oops: 0000000096000005 [#1]  SMP
[    1.350414] Modules linked in:
[    1.350896] CPU: 0 UID: 0 PID: 1 Comm: init Not tainted 7.3.0-rc7+
#9 PREEMPT(full)
[    1.351111] Hardware name: linux,dummy-virt (DT)
[    1.351411] pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    1.351581] pc : lru_gen_seq_show+0x5c/0x460
[    1.351800] lr : lru_gen_seq_show+0x4c/0x460
[    1.351898] sp : ffff80008034f9a0
[    1.351975] x29: ffff80008034fa20 x28: ffff0000035e67e8 x27: 00000000004=
00cc0
[    1.352297] x26: 000000007fff0000 x25: ffff0000035e67d8 x24: 00000000000=
00000
[    1.352454] x23: ffff80008034fb00 x22: ffff80008034fb28 x21: 00000000000=
00000
[    1.352626] x20: ffff0000035e67b0 x19: ffff00003ffc2f20 x18: ffff8000803=
60060
[    1.352775] x17: 0000000000000000 x16: 0000000000000000 x15: 00000000000=
00000
[    1.352915] x14: 0000000000000000 x13: 0000000000000000 x12: 00000000000=
00000
[    1.353058] x11: 0000000000000000 x10: 0000000000000000 x9 : ffffa3468a0=
20c5c
[    1.353226] x8 : ffff000008b07000 x7 : 0000000000000000 x6 : 00000000000=
0003f
[    1.353367] x5 : 00000000ffffffff x4 : 0000000000000003 x3 : 00000000000=
01000
[    1.353511] x2 : ffff00003ffc2f20 x1 : 0000000000004000 x0 : 00000000000=
00000
[    1.353732] Call trace:
[    1.353925]  lru_gen_seq_show+0x5c/0x460 (P)
[    1.354110]  seq_read_iter+0xec/0x4c0
[    1.354213]  seq_read+0xfc/0x148
[    1.354290]  full_proxy_read+0x78/0xc0
[    1.354377]  vfs_read+0xd0/0x338
[    1.354453]  ksys_read+0x7c/0x120
[    1.354528]  __arm64_sys_read+0x24/0x40
[    1.354611]  invoke_syscall+0xa8/0x120
[    1.354695]  el0_svc_common.constprop.0+0x4c/0x100
[    1.354791]  do_el0_svc+0x28/0x40
[    1.354865]  el0_svc+0x48/0x2b0
[    1.354939]  el0t_64_sync_handler+0xa8/0xf0
[    1.355026]  el0t_64_sync+0x1b8/0x1c0
[    1.355250] Code: f9000fe0 f9432661 aa1303e2 91401021 (b9504033)
[    1.355647] ---[ end trace 0000000000000000 ]---
[    1.356555] Kernel panic - not syncing: Attempted to kill init!
exitcode=3D0x0000000b
[    1.356888] SMP: stopping secondary CPUs
[    1.357525] Kernel Offset: 0x234609c00000 from 0xffff800080000000
[    1.357675] PHYS_OFFSET: 0x40000000
[    1.357762] CPU features: 0x0,00000000,09000020,00100002,0800821b
[    1.357901] Memory Limit: none

