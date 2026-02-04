Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC71FEA7948
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 22:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06BC6B008A; Wed,  4 Feb 2026 17:24:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAABB6B0092; Wed,  4 Feb 2026 17:24:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75846B0093; Wed,  4 Feb 2026 17:24:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94F1A6B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:24:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41AA5C158A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:24:20 +0000 (UTC)
X-FDA: 84408203880.27.B6FA6A4
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 407371C0006
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:24:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eWQXuME8;
	spf=pass (imf20.hostedemail.com: domain of tytanick@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770243858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5UJBYDY1coRDDbsPYBH/VdKciJPykBb+VXYigiAII0=;
	b=JLaxS3BSt/QEdRDslcJuyRyfjFgL9DQbcTxasIR34NFGG6Sn/RlJkRwbstjyY0xKjFVB3m
	EGkdMISc7rxmL7TCDt3f3WvJZSAuDVkJI+7bcx8eSZmb6vojD3k7i75qo0RSo82Z6wg+Fc
	hoOlzyVksKZYdX0CZL/jJW4D9gNDndc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eWQXuME8;
	spf=pass (imf20.hostedemail.com: domain of tytanick@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770243858; a=rsa-sha256;
	cv=pass;
	b=djuOBulCMsWhAsPzNISCv6wVMoXfS98TfEupq3Jc+U89rT3c1Ze76rdyusp8dUgig18tRr
	Lxua+DL/BkaWA9HCen+RwVBPJUUumbNYqvzFwhWcFMsdYDm8z4AMDlvypSk5NpxZXgpllD
	KOdj93PDWr0eQZpHZr3FYTS2zBgjhes=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-386914b8e81so11394291fa.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 14:24:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770243856; cv=none;
        d=google.com; s=arc-20240605;
        b=Dh5rptUAPvvle/MZm6WWR+d2HX6dEyJ/IHRO8LKu/zk3wIf3SPcyFfHYnvvAismzwU
         I8fHoMKqeNoADG46hSkgo6mOwPdxkVYQQHNLtE3sOtlQqdffNfRH4LXbbVAKPi7fAhQR
         C4CPWus8t6KTwtzKJlQ2dsS1Ab9deOSs9LXTiiyAGNu/BH9Qvub9ZXaaF3LrSFuzKXTs
         sJlWuzDqIv2ciASHJU0cU4aH34csz0UI3Cuq9ZrqgqlDD2UoO1ybr9uDRFLp9Djssvl7
         fTDtWXxuto7s971yK3snDqQtGOcZ+BiqpxqZiuDAQQ8qEeKlgWX8iN8a35mgYZWUZh0Z
         TpOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=x5UJBYDY1coRDDbsPYBH/VdKciJPykBb+VXYigiAII0=;
        fh=Tj8Yv+68Tat6f33mkdvmlxqXOlmx6a5imWfRenmQQUo=;
        b=TwOx8OsAxAtmcgreULdvJMR38uhmBnyQPN5P7qLAPCp7qhyuacsA7Cx+ZRHcGVN4Td
         TbrnPegyaMNHtvbEk31XnflJW2yTv0KXeNv0I64BUNv1WIhC3JlaZq7ThmA//WxaJVXS
         RjCLkaMq6WYOEmhLd3Cdqbn/6FNMtHp47Dieuzn166XbWKI/8HDikYMCEJ6JeoSqo4G8
         hbj4ej5qvmQdnY6GBHhcf2j4a6q0NjZYHecLuIoLYvR9aSpiDuofbiiclLvKppVFYWIO
         9rBXHcN562DabrGTD53PmxTl06BP4UksxnfLWIOBfGZi0rQTPpic8pav2R5cNOE3zG14
         v5xg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770243856; x=1770848656; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x5UJBYDY1coRDDbsPYBH/VdKciJPykBb+VXYigiAII0=;
        b=eWQXuME8TWGOF/VC+Qh6mut5mlVcB6rRrqbcmqL5gmUzG5Ts7XCsgefZ97L1b/ZbnM
         yrhsFnuTMQ9qKd0fPhSvr1M7wpx7nk6qdUYq9HqVBORj/8v5P9TnSH88ZUmN0PsoUUma
         AIsR+7isv0Uas8wo7HT1l2BlOPdQq1fpSlHp/u/YNio2m2juFiT6VSlrbi+J4ALqwhB3
         5i1hv7Jy0/RU7GcrWkZpmdTOHKQ6aeI4bETJ8Qcc9fEt1YISCd+pe42DVfqUC7SvbaLv
         8mlH0E/QQMFGtvYsN1hYG/XdYIV7pJsHsN+CHJpjAQCBT1qdbQN288msix3REzbYTOG6
         C5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770243856; x=1770848656;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5UJBYDY1coRDDbsPYBH/VdKciJPykBb+VXYigiAII0=;
        b=fSL+NwHrGmfH3zAtQnWPjrwaf+GzLPRcjfEPw5UjghhgnW/yaOm7/m2eC75+8fInvc
         BjVo7iCHGGtomDieSp3fZwUOAh7sTdHrLXolLbQmRVN3vmZ4GVyudN5JJK9etlbFbesK
         A4OTEQol0P8DvIY8iW3umHFdZq6KmdMcO4LjCQDzTdE3MZ7DfgqdHMjPhs5bR/lKRL52
         lBknM6W+RJNve3kX4G24+cPEcVBI4EMCs0Vsc3k3WVWYMDB1hksZbtJ5wUUuS3DW/5+x
         Ql+L7fcTbPfAFWZxtcBiS0hZPfPYZgNJA6r6w3bUDj3QGwMDaOVWd+BBF1O+X27obxt3
         93iA==
X-Gm-Message-State: AOJu0YxyXa0uYYaBd6ctbNaatbAdJ78GEmBMEeMuPPrEreMLXEMOKl/c
	nG2KHhcAjSOyqa7aelsAPqgaGIJeM+zz2wINbGWKbOG7qW/8j+LDvFPhkvnDEfWeh5gF7o2CDg6
	xz2xkDuVzPrCTIy6g4i/0GVTz2YbQ+s0=
X-Gm-Gg: AZuq6aL9IeIIguVeNklwZSuugxiZOZeCWBfKkq4+4oo1HHUUjq7kRwA7fSgCuqzU67S
	2FxRiC7Q1u3h3XYdrGSyubB5THoEOamxjcZI4rxps8xntkFaE7/0pMAMjGRLqqK2Y8AEibZMM4l
	dNsEx33VHAGYVfs0prkfv1+N05051jZ1sqhOBXtLSn2xyWLYgB6YYVIjv258cVRecN66dNXDwla
	vXe4kC5eEt1hlO2JAoyKSVHvo5wB1kD1pz2LwBMil7cNSKdTjEVpHzXwIpjfkBq55lR7Crd84s8
	ue9d+EEOi2ccWSi4KLH9fh4J9SpFuOe4Pm6WdFEidYmEbYu5Y27MvKliZO4bqV3YQ6Pqqb7KvrG
	w9U98pn+AKzX5kw==
X-Received: by 2002:a05:6512:32ce:b0:59e:3288:6b06 with SMTP id
 2adb3069b0e04-59e3c7c6b26mr237735e87.14.1770243855854; Wed, 04 Feb 2026
 14:24:15 -0800 (PST)
MIME-Version: 1.0
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org>
In-Reply-To: <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org>
From: Tytus Rogalewski <tytanick@gmail.com>
Date: Wed, 4 Feb 2026 23:24:05 +0100
X-Gm-Features: AZwV_QgflirvpnubaVXy-WLN8zFmP2DMhzRT07X_himWCmKdOUcUmb_qh2JIPyk
Message-ID: <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de
Content-Type: multipart/alternative; boundary="00000000000031aeed064a07045d"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 407371C0006
X-Stat-Signature: 964idf4koax5ykoy7kw15cyrpszpffcg
X-Rspam-User: 
X-HE-Tag: 1770243858-110960
X-HE-Meta: U2FsdGVkX1854D6ktxKa87YIwNj893QVSCoz/j3biYilfpwU9li22K891Ek0KGtcIAVaWQTM872WRRlafXPI0YTre1GpyyYnEE1Ya9D1B+6SK47TjY8R8O4L2AmwbdZ4PQsEPuQWeZMUXwJruWnJxVEZ/Cs5ezIkhGkA7hOdWaNNCeCWes+Jg8umbu0no8dhoE2pbIjlizB7D3zPg1ETkVc5ZnT9yxRS4GOFETGG10yghdDMCKeOdBh9ZvRi0BpHSiAhmVH/lkV7a3ihA1x+a1Vvq3rB+uTBmCoV3rAwh5xwwQiLwk4d1y25p1YHi/ESuXqjsZs8hHdd5iPDHV5JoQWrubp0ouP3pZx2jgy68fpYitxPmlJkK3BkKjbewPOdkbsS6DiBMxtT2c8HDCJiqcxapQTBT46QW7gw52LVUh9Cg1iHcK9JjaSw0lzRefLi09pbZ6K8mcD1QgQcnkGkdB8xl2yG+xhELefyPCF2K9k42Vm5paSEavCw/Pj+VR7vhXU404O9ZmYwnKtm/cMiwwC65Ai9VTQXnVJHEpUQwIoS1WGH2tgaiqexGd8ttEHrnyqyq/1sI65zoCzdkFXU/FeGAwOtGxLI2Woy/oMcX28P1F+mVsDvF2YflXp3L1XT9X+UW2tt1xO6B89P+jTA4CE+SIVojOtjPeGI7w8Ag4I9MamO57FKYLtKeeosFhV0vcuzUXQHz6quM/7+zdBPT4zDAksQ3stcPsUwgpkLZnUxIbVc1U1gQbsRZEfy5JI+4Vpu1tg63OmwsifF61kiLl0/S65ywWzch86GFvkyl+6Zo1QvN2Twt1dONWsUbr10uydkpvEKJw4sSt0NLu+HKcYoVkzRYuBZeJN0QVQPxwrnaAyOCJHkH53ng6qzSkuDNC10/0R90KMp4nCFwjApIhBxa5xyUuuzflf6WyhTflkiiA+xb+AEh0zcE29aYMJ3ue8nqcx9AQ9FNyL0lgR
 FbC2LWWH
 qteamcQJ2myhBLuvBnBPZPB46tnRwAlFNuq0qfk6pSYQj6VI045F0pYUnVmrWdPCnsHCc8woNkYFW9/b5y2EMFyCXqcb/8kt33l4XdCyasxX8v8WmAv7v+b9PEJZAFxiJ9QO5qR4ZZbESR1No/+0m/fL3wHZn19SvEvvtFU9TjwjuWOmyVf1ZZa6+t6EY//jHHC2AYiUKLsM9oBYoS+2PSogJhWz74jHszP1I9tXaEQhOIoDvnpB4IBrseLbjvJFkh0Kym1kOX5+2ZIcOgrxiQlAmYwwaMKYN6ngF/mlkVy2XQ+dqvoHOKM20yxUC7GAodoATowOIv2RDen5FQPVuq/KkwbqXGz+TC393et5FbWd/39ve+GMGtpRGoeXt18StRLc9labaHvkOb/eD0Gjts6cvUIG3RBNGo17/RwCv8v7fyiDPh3l8CVuuUQk8r5OfHVFkcCY25sxDewJOn7PCiISVQpzEeLOuDH0rWbzNNGJAUoJyQKh+RrX72U38xITTW56DGLjMi07U3CLiTFqK+R1YF0nVeCOkJ4QFd3OZ35XzBtcqf4dGxxpYAM1YJbBui+ns
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000031aeed064a07045d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

hugepages is qemu term probably.

Yeah 4k is default and booting is hard with that much memory aspecially if
you boot , stop and few times.
But this issue might be strictly related to vfio passthrough mix.
I did not tested 2mb pages actually because why to use it if i have 1GB ?
Do you think it could be more stable than 1GB or should it be the same
logic as 2MB ?

Well. i started to use 1GB ones recently as i had to get through all this
iommu cpu labirynth with binding proper gpu to proper memory and proper cpu
affinity in kvm. And proxmox ve does not have such logic.

If you tell me what to collect, i can collect it.

I have other symptom actually. Hmm maybe its related or maybe not.
Still i had this second symptom from the beginning and i did nit had such
crashes on 4k.
I am using distributed network storage moosefs and mounting it via fuse.
Then using qcow2 vm images.
I am having freezes sometimes in VMs but that might be related to that fuse
as i mount one fuse share and starting even 8 vms from that one mount.
And from time to time some vms stop responding or freeze.
I will soon rewrite it to use NBD istead and that should be fixed if that
was caused by fuse.
Still i am not sure actually if thise are separate issues or related and
which triggers which.
If there is blocked fuse process by vm A is it possible that vm B might
throw this walk page bug or it should not be related even if disk slows
down ?

--

tel. 790 202 300

*Tytus Rogalewski*

Dolina Krzemowa 6A

83-010 Jagatowo

NIP: 9570976234


W dniu =C5=9Br., 4 lut 2026 o 22:52 David Hildenbrand (arm) <david@kernel.o=
rg>
napisa=C5=82(a):

> On 1/28/26 15:14, Tytus Rogalewski wrote:
> > Hello guys,
> >
>
> Hi!
>
> > Recently i have reported slab memory leak and it was fixed.
> >
> > I am having yet another issue and wondering where to write with it.
> > Would you be able to tell me if this is the right place or should i sen=
d
> > it to someone else ?
> > The issue seems also like memory leak.
> >
> > It happens on multiple servers (less on 6.18.6, more on 6.19-rc4+).
> > All servers are doing KVM with vfio GPU PCIE passthrough and it happens
> > when i am using HUGEPAGE 1GB + qemu
>
> Okay, so we'll longterm-pin all guest memory into the iommu.
>
> > Basically i am allocating 970GB into hugepages, leaving 37GB to kvm.
> > In normal operation i have about 20GB free space but when this issue
> > occurs, all RAM is taken and even when i have added 100GB swap, it was
> > also consumed.
>
> When you say hugepage you mean 1 GiB hugetlb, correct?
>
> > It can work for days or week without issue and
> >
> > I did not seen that issue when i had hugepages disabled (on normal 2KB
> > pages allocation in kvm).
>
> I assume you meant 4k pages. What about 2 MiB hugetlb?
>
> > And i am using hugepages as it is impossible to boot VM with >200GB ram=
.
>
> Oh, really? That's odd.
>
> > When that issue happens, process ps hangs and only top shows
> > something but machine needs to be rebooted due to many zombiee processe=
s.
> >
> > *Hardware: *
> > Motherboard: ASRockRack GENOA2D24G-2L
> > CPU: 2x AMD EPYC 9654 96-Core Processor
> > System ram: 1024 GB
> > GPUs: 8x RTX5090 vfio passthrough
> >
> > root@pve14:~# uname -a
> > *Linux pve14 6.18.6-pbk* #1 SMP PREEMPT_DYNAMIC Mon Jan 19 20:59:46 UTC
> > 2026 x86_64 GNU/Linux
> >
> > [171053.341288] *BUG: unable to handle page fault for address*:
> > ff469ae640000000
> > [171053.341310] #PF: supervisor read access in kernel mode
> > [171053.341319] #PF: error_code(0x0000) - not-present page
> > [171053.341328] PGD 4602067 P4D 0
> > [171053.341337] *Oops*: Oops: 0000 [#1] SMP NOPTI
> > [171053.341348] CPU: 16 UID: 0 PID: 3250869 Comm: qm Not tainted 6.18.6=
-
> > pbk #1 PREEMPT(voluntary)
> > [171053.341362] Hardware name:  TURIN2D24G-2L+/500W/TURIN2D24G-2L+/500W=
,
> > BIOS 10.20 05/05/2025
> > [171053.341373] RIP: 0010:*walk_pgd_range*+0x6ff/0xbb0
> > [171053.341386] Code: 08 49 39 dd 0f 84 8c 01 00 00 49 89 de 49 8d 9e 0=
0
> > 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 ff 48 39 f0 49 0f 43
> > dd <49> f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff 48 8b 45 c0 41 c7 47 20
> > [171053.341406] RSP: 0018:ff59d95d70e6b748 EFLAGS: 00010287
> > [171053.341416] RAX: 00007a22401fffff RBX: 00007a2240200000 RCX:
> > 0000000000000000
> > [171053.341425] RDX: 0000000000000000 RSI: 00007a227fffffff RDI:
> > 800008dfc00002b7
> > [171053.341435] RBP: ff59d95d70e6b828 R08: 0000000000000080 R09:
> > 0000000000000000
> > [171053.341444] R10: ffffffff8de588c0 R11: 0000000000000000 R12:
> > ff469ae640000000
> > [171053.341454] R13: 00007a2280000000 R14: 00007a2240000000 R15:
> > ff59d95d70e6b8a8
> > [171053.341464] FS:  00007d4e8ec94b80(0000) GS:ff4692876ae7e000(0000)
> > knlGS:0000000000000000
> > [171053.341476] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [171053.341485] CR2: ff469ae640000000 CR3: 0000008241eed006 CR4:
> > 0000000000f71ef0
> > [171053.341495] PKRU: 55555554
> > [171053.341501] Call Trace:
> > [171053.341508]  <TASK>
> > [171053.341518]  __walk_page_range+0x8e/0x220
> > [171053.341529]  ? sysvec_apic_timer_interrupt+0x57/0xc0
> > [171053.341541]  walk_page_vma+0x92/0xe0
> > [171053.341551]  smap_gather_stats.part.0+0x8c/0xd0
> > [171053.341563]  show_smaps_rollup+0x258/0x420
>
> Hm, so someone is reading /proc/$PID/smaps_rollup and we stumble
> somewhere into something unexpected while doing a page table walk.
>
> [171053.341288] BUG: unable to handle page fault for address:
> ff469ae640000000
> [171053.341310] #PF: supervisor read access in kernel mode
> [171053.341319] #PF: error_code(0x0000) - not-present page
> [171053.341328] PGD 4602067 P4D 0
>
> There is not a lot of information there :(
>
> Did you have other splats/symptoms or was it always that?
>
> --
> Cheers,
>
> David
>

--00000000000031aeed064a07045d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hi,</div><div dir=3D"auto"><br></div><div dir=3D"auto">hu=
gepages is qemu term probably.</div><div dir=3D"auto"><br></div><div dir=3D=
"auto">Yeah 4k is default and booting is hard with that much memory aspecia=
lly if you boot , stop and few times.</div><div dir=3D"auto">But this issue=
 might be strictly related to vfio passthrough mix.</div><div dir=3D"auto">=
I did not tested 2mb pages actually because why to use it if i have 1GB ?</=
div><div dir=3D"auto">Do you think it could be more stable than 1GB or shou=
ld it be the same logic as 2MB ?</div><div dir=3D"auto"><br></div><div dir=
=3D"auto">Well. i started to use 1GB ones recently as i had to get through =
all this iommu cpu labirynth with binding proper gpu to proper memory and p=
roper cpu affinity in kvm. And proxmox ve does not have such logic.</div><d=
iv dir=3D"auto"><br></div><div dir=3D"auto">If you tell me what to collect,=
 i can collect it.</div><div dir=3D"auto"><br></div><div dir=3D"auto">I hav=
e other symptom actually. Hmm maybe its related or maybe not.</div><div dir=
=3D"auto">Still i had this second symptom from the beginning and i did nit =
had such crashes on 4k.</div><div dir=3D"auto">I am using distributed netwo=
rk storage moosefs and mounting it via fuse. Then using qcow2 vm images.</d=
iv><div dir=3D"auto">I am having freezes sometimes in VMs but that might be=
 related to that fuse as i mount one fuse share and starting even 8 vms fro=
m that one mount.</div><div dir=3D"auto">And from time to time some vms sto=
p responding or freeze.</div><div dir=3D"auto">I will soon rewrite it to us=
e NBD istead and that should be fixed if that was caused by fuse.</div><div=
 dir=3D"auto">Still i am not sure actually if thise are separate issues or =
related and which triggers which.</div><div dir=3D"auto">If there is blocke=
d fuse process by vm A is it possible that vm B might throw this walk page =
bug or it should not be related even if disk slows down ?</div><div dir=3D"=
auto"><br clear=3D"all"><div dir=3D"auto"><div dir=3D"ltr" class=3D"gmail_s=
ignature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><div dir=3D"l=
tr"><div dir=3D"ltr"><div dir=3D"ltr">







<p style=3D"font-size:12px;line-height:normal;font-family:&quot;Helvetica N=
eue&quot;;margin:0px"><font size=3D"1" style=3D"font-family:&quot;Helvetica=
 Neue&quot;;color:rgb(0,0,0)">--</font></p><p style=3D"font-size:12px;line-=
height:normal;font-family:&quot;Helvetica Neue&quot;;margin:0px"><font size=
=3D"1" style=3D"font-family:&quot;Helvetica Neue&quot;;color:rgb(0,0,0)">te=
l. 790 202 300</font></p><p style=3D"font-size:12px;line-height:normal;font=
-family:&quot;Helvetica Neue&quot;;margin:0px"><b style=3D"font-size:x-smal=
l;font-family:&quot;Helvetica Neue&quot;;color:rgb(68,68,68)">Tytus Rogalew=
ski</b><br></p><p style=3D"font-size:12px;line-height:normal;font-family:&q=
uot;Helvetica Neue&quot;;margin:0px"><font size=3D"1" style=3D"font-family:=
&quot;Helvetica Neue&quot;;color:rgb(153,153,153)">Dolina Krzemowa 6A</font=
></p><p style=3D"font-size:12px;line-height:normal;font-family:&quot;Helvet=
ica Neue&quot;;margin:0px"><font size=3D"1" style=3D"font-family:&quot;Helv=
etica Neue&quot;;color:rgb(153,153,153)">83-010 Jagatowo</font></p><p style=
=3D"font-size:12px;line-height:normal;font-family:&quot;Helvetica Neue&quot=
;;margin:0px"><font size=3D"1" style=3D"font-family:&quot;Helvetica Neue&qu=
ot;;color:rgb(153,153,153)">NIP: 9570976234</font></p></div></div></div></d=
iv></div></div></div><div><br></div><div><br><div class=3D"gmail_quote gmai=
l_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">W dniu =C5=9Br., 4=
 lut 2026 o 22:52 David Hildenbrand (arm) &lt;<a href=3D"mailto:david@kerne=
l.org">david@kernel.org</a>&gt; napisa=C5=82(a):<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;bo=
rder-left-style:solid;padding-left:1ex;border-left-color:rgb(204,204,204)">=
On 1/28/26 15:14, Tytus Rogalewski wrote:<br>
&gt; Hello guys,<br>
&gt; <br>
<br>
Hi!<br>
<br>
&gt; Recently i have reported slab memory leak and it was fixed.<br>
&gt; <br>
&gt; I am having yet another issue and wondering where to write with it.<br=
>
&gt; Would you be able to tell me if this is the right place or should i se=
nd <br>
&gt; it to someone else ?<br>
&gt; The issue seems also like memory leak.<br>
&gt; <br>
&gt; It happens on multiple servers (less on 6.18.6, more on 6.19-rc4+).<br=
>
&gt; All servers are doing KVM with vfio GPU PCIE passthrough and it happen=
s <br>
&gt; when i am using HUGEPAGE 1GB=C2=A0+ qemu<br>
<br>
Okay, so we&#39;ll longterm-pin all guest memory into the iommu.<br>
<br>
&gt; Basically i am=C2=A0allocating 970GB into hugepages, leaving 37GB to k=
vm.<br>
&gt; In normal operation i have about 20GB free space but when this issue <=
br>
&gt; occurs, all RAM is taken and even when i have added 100GB swap, it was=
 <br>
&gt; also consumed.<br>
<br>
When you say hugepage you mean 1 GiB hugetlb, correct?<br>
<br>
&gt; It can work for days or week without issue and<br>
&gt; <br>
&gt; I did not seen that issue when i had hugepages disabled (on normal 2KB=
 <br>
&gt; pages allocation in kvm).<br>
<br>
I assume you meant 4k pages. What about 2 MiB hugetlb?<br>
<br>
&gt; And i am using hugepages as it is impossible to boot VM with &gt;200GB=
 ram.<br>
<br>
Oh, really? That&#39;s odd.<br>
<br>
&gt; When that issue happens, process ps hangs and only top shows <br>
&gt; something=C2=A0but machine needs to be rebooted due to many zombiee pr=
ocesses.<br>
&gt; <br>
&gt; *Hardware: *<br>
&gt; Motherboard: ASRockRack GENOA2D24G-2L<br>
&gt; CPU: 2x AMD EPYC 9654 96-Core Processor<br>
&gt; System ram: 1024 GB<br>
&gt; GPUs: 8x RTX5090 vfio passthrough<br>
&gt; <br>
&gt; root@pve14:~# uname -a<br>
&gt; *Linux pve14 6.18.6-pbk* #1 SMP PREEMPT_DYNAMIC Mon Jan 19 20:59:46 UT=
C <br>
&gt; 2026 x86_64 GNU/Linux<br>
&gt; <br>
&gt; [171053.341288] *BUG: unable to handle page fault for address*: <br>
&gt; ff469ae640000000<br>
&gt; [171053.341310] #PF: supervisor read access in kernel mode<br>
&gt; [171053.341319] #PF: error_code(0x0000) - not-present page<br>
&gt; [171053.341328] PGD 4602067 P4D 0<br>
&gt; [171053.341337] *Oops*: Oops: 0000 [#1] SMP NOPTI<br>
&gt; [171053.341348] CPU: 16 UID: 0 PID: 3250869 Comm: qm Not tainted 6.18.=
6- <br>
&gt; pbk #1 PREEMPT(voluntary)<br>
&gt; [171053.341362] Hardware name: =C2=A0TURIN2D24G-2L+/500W/TURIN2D24G-2L=
+/500W, <br>
&gt; BIOS 10.20 05/05/2025<br>
&gt; [171053.341373] RIP: 0010:*walk_pgd_range*+0x6ff/0xbb0<br>
&gt; [171053.341386] Code: 08 49 39 dd 0f 84 8c 01 00 00 49 89 de 49 8d 9e =
00 <br>
&gt; 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 ff 48 39 f0 49 0f 4=
3 <br>
&gt; dd &lt;49&gt; f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff 48 8b 45 c0 41 c7=
 47 20<br>
&gt; [171053.341406] RSP: 0018:ff59d95d70e6b748 EFLAGS: 00010287<br>
&gt; [171053.341416] RAX: 00007a22401fffff RBX: 00007a2240200000 RCX: <br>
&gt; 0000000000000000<br>
&gt; [171053.341425] RDX: 0000000000000000 RSI: 00007a227fffffff RDI: <br>
&gt; 800008dfc00002b7<br>
&gt; [171053.341435] RBP: ff59d95d70e6b828 R08: 0000000000000080 R09: <br>
&gt; 0000000000000000<br>
&gt; [171053.341444] R10: ffffffff8de588c0 R11: 0000000000000000 R12: <br>
&gt; ff469ae640000000<br>
&gt; [171053.341454] R13: 00007a2280000000 R14: 00007a2240000000 R15: <br>
&gt; ff59d95d70e6b8a8<br>
&gt; [171053.341464] FS: =C2=A000007d4e8ec94b80(0000) GS:ff4692876ae7e000(0=
000) <br>
&gt; knlGS:0000000000000000<br>
&gt; [171053.341476] CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 0000000080050033=
<br>
&gt; [171053.341485] CR2: ff469ae640000000 CR3: 0000008241eed006 CR4: <br>
&gt; 0000000000f71ef0<br>
&gt; [171053.341495] PKRU: 55555554<br>
&gt; [171053.341501] Call Trace:<br>
&gt; [171053.341508] =C2=A0&lt;TASK&gt;<br>
&gt; [171053.341518] =C2=A0__walk_page_range+0x8e/0x220<br>
&gt; [171053.341529] =C2=A0? sysvec_apic_timer_interrupt+0x57/0xc0<br>
&gt; [171053.341541] =C2=A0walk_page_vma+0x92/0xe0<br>
&gt; [171053.341551] =C2=A0smap_gather_stats.part.0+0x8c/0xd0<br>
&gt; [171053.341563] =C2=A0show_smaps_rollup+0x258/0x420<br>
<br>
Hm, so someone is reading /proc/$PID/smaps_rollup and we stumble <br>
somewhere into something unexpected while doing a page table walk.<br>
<br>
[171053.341288] BUG: unable to handle page fault for address: <br>
ff469ae640000000<br>
[171053.341310] #PF: supervisor read access in kernel mode<br>
[171053.341319] #PF: error_code(0x0000) - not-present page<br>
[171053.341328] PGD 4602067 P4D 0<br>
<br>
There is not a lot of information there :(<br>
<br>
Did you have other splats/symptoms or was it always that?<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div></div>

--00000000000031aeed064a07045d--

