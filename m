Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB8C606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 00:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AU0JOoKa
Received: by kanga.kvack.org (Postfix)
	id E46876B03C5; Mon, 19 Oct 2026 20:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7676B03C6; Mon, 19 Oct 2026 20:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D8C6B03C7; Mon, 19 Oct 2026 20:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8836B03C5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:43:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2498EC085A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:43:25 +0000 (UTC)
X-FDA: 85341155970.27.A50762B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 49F8940002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:43:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AU0JOoKa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792457003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4ZdPaHrQW6w9mgMz6+ac4it4iyaDjTjOK6psKUBxIk=;
	b=Dy1FxsLsHNbeBf5RO+CJ7SVIRQoJKna2EnsRMDWpdoacEwalYZt2CizLB2zs9C+buCbigx
	It1iYEDfAmVqvAN1sDfAV578vLbOFh2vJP78+HDUNyyOJ3U0SRNVpaYbtO7dmI98tNTq2f
	wE3y+M+1XnqRzwKRemDEPxtwjxffJuw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AU0JOoKa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792457003;
	b=HqRCPh2wJvvSsgeTkD2KfQmijZKl6t9fSknZ2AkgKuAamgSXvXgPXoJJ5RO+AT8ukn695O
	1nmn1Mq/GnvredF2mWlJW3FzQdz89txZ8GzF2cwy5kLohAIwHWJUba8H19pqLCuDfg4smd
	r3HVFnvDXxhHITHf9oEZKzYnso1o1sQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5F5F60211
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4311F000CC
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792457002;
	bh=f4ZdPaHrQW6w9mgMz6+ac4it4iyaDjTjOK6psKUBxIk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AU0JOoKaq7nzA+pLcOPR1wjiSLeTxt/51qv3AI/sFJpHZDbCw53jHvO8Yan67gXpq
	 uxibzw9bD2Sd4dCEmYphGe6YVDBR0niQzlSGi0M+CX6SZ7MifLTKIsXXW79i5zSImR
	 BrwAdqbAHEzSRLpeD20s0L59TpaU/BObRagL05aljpJ1PnVKovI5dSqZ8Ks4RX0o89
	 UQUGKKfChmiPITDbOWnDB8vuYfe8JiVlQbSYn1miwcbpdbAmqFmS76egf53GLk5URK
	 sBLsi+rurl/ZLSc+prlE0lj1+6vaeB0RYxs91DecRqYy2O5IqbTFApDAF1n4O/qH+Y
	 f152jgG5W0Ndg==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f2493c28bso213236885a.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:43:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxoQREy9BDaJFIephS5M0VEQeXGL7if1WZBLJ0y/PsMM0ZdIFewXCzzK+WEUNk0xFO6694UDT611A==@kvack.org
X-Gm-Message-State: AFq9FYJCbk7+2rGxgXm6MvuBdT4J6ub97pSlPSDO6vc4CqIN0ztDNoi5
	uKDLbApxbyg4QoU4tnUsxnm+iqJjReEd+fhnVsfDwSgrR2IzNme/NJ1VjXlHbVV9pWPECeD98yE
	MK84VEDn+tC9zTWbsFVAoGTsdZrckbuI=
X-Received: by 2002:a05:620a:2989:b0:937:6de8:b40 with SMTP id
 af79cd13be357-93f29ceec65mr1607493085a.15.1792457001621; Mon, 19 Oct 2026
 17:43:21 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
 <20261017050928.128582-2-sidchintamaneni@gmail.com> <CAGsJ_4wGq9oc05=-g4aWptLdCbTwUjMjXk4Rd6KjJ6x=tzMm+g@mail.gmail.com>
 <CAE5sdEhGFtGF6LC4xNkMwGj3vTxLOW=GNBXnk3-JmsgjntXx0Q@mail.gmail.com>
 <CAGsJ_4wmvBvEn_vXu8-c6BRAnRewYmTs8iUd8T7KRx7_svZrwg@mail.gmail.com> <CAE5sdEiq3bY1kgMUQ6x7RRJCx0JH4sQ9Z_a9_YQSM5FKNwpk8A@mail.gmail.com>
In-Reply-To: <CAE5sdEiq3bY1kgMUQ6x7RRJCx0JH4sQ9Z_a9_YQSM5FKNwpk8A@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 20 Oct 2026 08:43:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yZ3rueVMaRJ_+25Nnab0WH5ZLQeLjporWAFj7xJnJFHA@mail.gmail.com>
X-Gm-Features: AclHuK_z9u93TiyYoAZaSFwx9j8LW96gLUQ2eqyJQLstVMCqEWfGNy3WkacpWX0
Message-ID: <CAGsJ_4yZ3rueVMaRJ_+25Nnab0WH5ZLQeLjporWAFj7xJnJFHA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref in get_lruvec()
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 49F8940002
X-Stat-Signature: gpn33zzdta9sabp6zfmtgxr4cicgbe4t
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792457003-706101
X-HE-Meta: U2FsdGVkX19FFPH6eyluQsuff+zCMXJd1hneb+crgsVhEU9n0jOSgTYGmEHWy7Cw0AVfasHYyQITHl3+Djx6Jc5ZWFY/afIUKmnf882Wv4cewwAyqzPjLM4Jf8XY/GLwU4uma0sdwALQoVL/X+4XvEmXAkVxxIx5ChMDCyjxYCJTy4Qk32LlJUL4zxH2RYFkm7j+Xvh2jTiL+1A1CwOnAst+5+zMCRY/99Ggd6yNmAb52zvfjWW1Rz7BPyX9LOgyTyiPNrU/Dn4pKqO3O9MwuABnXZDkXNytLvFlz/rUg2ljetb7DyGttTvPJ6uDWyzpDnmMPHuFHaxqQ9ebHFSKRTXlVC8qZAxoE7Yi0B8XEnYuQc0IF2zf55jUVBRTdZKehPTFGWV/x0rjmDtSZrfsdPgNu87FgIIQy/AQ+lAVQzKsT6TtJrVMDynyL7fvnNbfCbfD7GOjoTrv0b8P2SEpTw7dAOkT8rEXfzq/t8NNggeaQzi6cKDJmmiQw5Gt7UsV6Jqlh84gJbtqI8nYiV+lvcu2L5Fu4mQFQr3tub3D91gT2IKGMs01S/Jn23fNECZ3oBg2NlF6Yy6Zgoxo2qMBT86+TRLebjesXsypJGgnMjFrBKMaPkHPkLE2/tMEsuz1m56fhRilgB9rvtSxnO3Gd4Qb6c3p+leaS1gzcWFtrb/vvtz/3psTxJ4ErhRRHbluaVZrsMXvP+2CEseJlsTC29I8slSfoGZrZ0V5xEkOJg5IedOwRcgvf6GAS5l8Ygu51BFBnUsKpw3XDyYPHTXzIDMFAWbhhWdMHZXE4980kHmqhEnD06UGoh0Trg4kpTgf0Gl9uCunpb14XrMP56FA/9P1wQ/5j2oUkwpaA9BxdxXhX+CoEXslKda4ZK16jtUKTryMI9neb7Ra1p2mBThukr7U56UvwlKZwpAMCrv6SlM4HQb8FZLU3pQZUL5lwix99RYZJKzdSk03wiBYmR3
 QjycYSzL
 aJQXf1TPyGzVUDyEJgZmsx9XXZGNDVl9Wm8QhSqL2VKyWx4i1cVXLSme+YX32629SdUcqOqEvLWxG8mv5QhKJG0rB/IVLRaU79oIdmMUGDqX/f0N5AlPBAwJnUynHmTYnKl3stli1f0YfZpXF2bwLgNwWBs+L1TY40uheAHW+NjFsWIY5TT/Vy+393Jb6vOwWK6qrA7j2wzvrfhfCsStqgSBxxEbIHacLh6Mf/shMa46akFS0vi66Bp1ZrErmV92wHD1pD1TDC+lFDg19xLfscnWJ1//c8BW8XyWNgVi0WNWXc1iryvSrKzPsBKkt7rCN3wWxBgb2tHi5oGTK97149sp9f7XtAKpP2bNwelyE20EllpHkQcRO8jqMWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 8:16=E2=80=AFAM Siddharth Chintamaneni
<sidchintamaneni@gmail.com> wrote:
>
> On Mon, 19 Oct 2026 at 16:36, Barry Song <baohua@kernel.org> wrote:
> >
> > On Tue, Oct 20, 2026 at 4:33=E2=80=AFAM Siddharth Chintamaneni
> > <sidchintamaneni@gmail.com> wrote:
> > >
> > > On Sun, 18 Oct 2026 at 14:24, Barry Song <baohua@kernel.org> wrote:
> > > >
> > > > On Sat, Oct 17, 2026 at 1:09=E2=80=AFPM Siddharth Chintamaneni
> > > > <sidchintamaneni@gmail.com> wrote:
> > > > >
> > > > > Andrew Morton reported that get_lruvec() has the same problem as
> > > > > lru_gen_shrink_node(): when memcg is disabled on the command line
> > > > > (cgroup_disable=3Dmemory), it returns &pgdat->__lruvec directly a=
nd so
> > > > > bypasses the initialization of lruvec->pgdat. The MGLRU debugfs
> > > > > interface calls get_lruvec(), then dereferences the pgdat pointer=
 in
> > > > > lru_gen_seq_show() and other paths, so these can hit the same NUL=
L
> > > > > dereference.
> > > >
> > > > So userspace must have booted, since otherwise we couldn't read
> > > > debugfs. The reachable case is therefore a memory node with no
> > > > LRU folios when debugfs is read? So this could happen on a multi-no=
de
> > > > system where folios are landed on other nodes but not on this node?
> > > >
> > >
> > > That is my high level understanding. I'll let Andrew to comment if I
> > > am missing something,
> > >
> >
> > I made a silly toy setup by running two numa nodes with one of them has=
 only 4KB
> > memory, the other one has 1G-4K:
> >
> > qemu-system-aarch64 -M virt,gic-version=3D3,mte=3Doff -cpu cortex-a53 -=
nographic \
> > -smp 4 \
> > -m 1G \
> > -object memory-backend-ram,id=3Dram0,size=3D1048572K \
> > -object memory-backend-ram,id=3Dram1,size=3D4K \
> > -numa node,nodeid=3D0,memdev=3Dram0,cpus=3D0-1 \
> > -numa node,nodeid=3D1,memdev=3Dram1,cpus=3D2-3 \
> >   -kernel arch/arm64/boot/Image \
> >  -nographic -append "cgroup_disable=3Dmemory
> > ...
> >
> > Then I got a machine where node1 is very difficult to have a page in lr=
u.
> >
> > then i ran the debugfs for mglru:
> >
> > / # cat /sys/kernel/debug/lru_gen
> > memcg 0
> >  node     0
> >           0      14972          0         953
> >           1      14972          0           1
> >           2      14972         18        3308
> >           3      14972          0           0
> >  node     1
> >           0      14972          0           0
> >           1      14972          0           0
> >           2      14972          0           0
> >           3      14972          0           0
> >
> > now you see node 1 has no page in lru but yet i didn't have any crash.
> >
> > i think i will need more time to figure out what is the problem and how=
 to
> > reproduce it.
>
> I've asked AI to repro the issue with the similar setup
>
> qemu-system-aarch64 -M virt,gic-version=3D3,mte=3Doff -cpu cortex-a53 -no=
graphic \
>   -smp 4 -m 1G \
>   -object memory-backend-ram,id=3Dram0,size=3D1048512K \
>   -object memory-backend-ram,id=3Dram1,size=3D64K \
>   -numa node,nodeid=3D0,memdev=3Dram0,cpus=3D0-1 \
>   -numa node,nodeid=3D1,memdev=3Dram1,cpus=3D2-3 \
>   -kernel "$KERNEL" \
>   -initrd "$INITRD" \
>   -no-reboot \
>   -append "console=3DttyAMA0 cgroup_disable=3Dmemory
> initcall_blacklist=3Dkswapd_init panic=3D-1"
>
> and it was able to repo it. AI identified that kswapd is initializing
> the pgdat during boot, so blacklisting kswap_init was able to repro
> the crash when reading /sys/kernel/debug/lru_gen

Thanks!
I guess you mean the following:

-module_init(kswapd_init)
+//module_init(kswapd_init)

Yes, I can reproduce it with the above as well.

But kswapd_init() is definitely called before we enter userspace,
so this doesn't seem to be an issue here?

So I feel there is no bug here, but this cleanup is still welcome.
Am I missing any other scenarios?

Best Regards
Barry

