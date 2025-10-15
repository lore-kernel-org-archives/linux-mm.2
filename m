Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1960CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 05:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A419B8E0007; Wed, 15 Oct 2025 01:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1A18E0003; Wed, 15 Oct 2025 01:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0298E0007; Wed, 15 Oct 2025 01:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 794488E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:02:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EDBC11B2CD
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:02:48 +0000 (UTC)
X-FDA: 83999153616.20.E5132A7
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4115F40014
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:02:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KrqBAPQf;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760504566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFXCcHDf7en4W6zLXEVP2nd4RatmQMAnLxWOZHGzM5M=;
	b=syY+oeh44KNNsiIAsOd0tH3SAJa8o/CDkJpa3lqEGfegZzIzOYPoBSsApz/4rw6zFMHQ2j
	gfYHhMtqIjEH01JAnRua0Ewjgra8Wzj93VmT1UBMB/YZUistjXIdUblgfolG/C81x/swiR
	J+jZ/0ux0QkX/t7Sg/mhanqiHO24hsk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KrqBAPQf;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760504566; a=rsa-sha256;
	cv=none;
	b=Qpdod68s4iGr2mi07tuvI5AGyH0aQZcxx9i79z0vS5HdnaoK/VCXr39uAL4orzYcZGnySr
	aqTu6jOLoonq0xs4rv1XHNdwoPa7+M0NVgz2q6wJ1hKKE/fKUHqHcOjGzfCcQCh1J1TAH8
	WjIK7JxwENnPkSDgiV1IyFPAusXLNHA=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-869ecba3bd2so967940385a.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760504565; x=1761109365; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bFXCcHDf7en4W6zLXEVP2nd4RatmQMAnLxWOZHGzM5M=;
        b=KrqBAPQfv297L8O0FbnOCVsKsU5XM41cMNE+QfRg33MovOMTj9JeA2ORTxmkspNNi7
         flG+yNGsw32eGGGSIjZe0NejRbEIWbjAHERlthdJqmSTKP3I7gGGqKBpwWlITKFHz4qg
         oPzT5LxcTQ9qIozsAteRUHgldEWnQqhXksYYfkyDIf24cKMCi4dZpRD4QPmk6xr6tGr+
         8dqGugLxLwfXqaBmkBDLbERzaLND9DCGp6amM6G3yZV8LIkcp1r4zfDSvR9UvcJNfIHi
         GjTwDknLqFXAw/vTgeCbKBBnvfE2Gs1nN4z/J8fw9ZoYlW9svdskn8gtodDB482xKkjf
         loXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760504565; x=1761109365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bFXCcHDf7en4W6zLXEVP2nd4RatmQMAnLxWOZHGzM5M=;
        b=snTPcqcbEzPFx50XzCSdAX1KV1ugPKAKWTVQdMuWKvAZuCBvoOYvHMl2Rhq9fLSBtZ
         ZTF/jGlGWxqSZLcQDg0L5xfo3+758yhc9Qqi/l3LBou5G4oqFUkUglRG6dpZVVR66xjU
         jOsJRFGa9QRwR2M+8RqB3AX74N3SnvXWCZ4+geP5wZZq6hy/Iw9e6TNCw7/qcd2ACGeh
         iUAkUX4LzvTryONT1x2ypVDQx1VcxsyxOXF2BcMPtxtQf14mFLnZIbgsWbWqjPkkHgqp
         wf5PfbaKwzWDHFPKO7uWlPIlUJejfqJCXlnO3z1oQZ2z0pYEk+Ci2EukzYuU8v1LPR+7
         tfBA==
X-Gm-Message-State: AOJu0YztHINwjPBLQBwflBpIRdattGNEwaPNSfmbakoe99BISD0MPJfL
	4c0RMM/q46TWJj5KjLlCKpEZBCzjdWuTKejZczs8ZJ1+fUceKygbGfE+oNWzboj0v3dXOpMC6zR
	g95/7DoZOa9bxOKQ7ZF6wEW1VmddBDKocfcj5
X-Gm-Gg: ASbGncvCWfrsdFfsJgHjHqvrZgLwwuBgr/4aJZKFOh3oROUc+Jn3HLqU62YK1LaSed2
	mnYeF0cEvhiQkYN5iwbjxhFTz3Aq+qZcywC2KubfIVcOV/HswvcYOeog1d239mwaYv91u1x+w93
	u5IPBPn3JnD8BXUrfx+f3/1Y1IuV8d8ZsUqF546iQF5Cw+kUlCwfBV85k8JGKlE4xLnS7NIS6u3
	NuZ3LZKSoQy7swLVzSidZDiy+yqQLLa48DXOFkiqFBCh+E3aAt/K8t7cVFZiOkqIjRjrkVmC3P1
	4Jo=
X-Google-Smtp-Source: AGHT+IFpBzV1D65BPoFAcqyBYeO1w0unePqCmMDfZmXta2B1t5+ZR85oCuRY3HGuzM7qJjr3prZIzl4NLuuLEZ9Ba2o=
X-Received: by 2002:a05:620a:1a2a:b0:870:6891:9c1a with SMTP id
 af79cd13be357-88354caf304mr4281625385a.71.1760504565075; Tue, 14 Oct 2025
 22:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <20251011081624.224202-1-bhe@redhat.com> <20251011081624.224202-2-bhe@redhat.com>
 <CAGsJ_4zvtdqzvBNmQjMy0L6JAz_XpvR=rGgNC_Xdo36QVW-g4g@mail.gmail.com> <aO8PuhNfKOQ8SJUV@MiWiFi-R3L-srv>
In-Reply-To: <aO8PuhNfKOQ8SJUV@MiWiFi-R3L-srv>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 15 Oct 2025 13:02:34 +0800
X-Gm-Features: AS18NWDwPKhy8Nm3E6urj72YWyVGpn5sYuH-eJQfwVPB7PeORGB6DWOvAwbSLbE
Message-ID: <CAGsJ_4yv66kW32Lr--O8qWq3gbrwF110cT7MzqMWumRabFNj1g@mail.gmail.com>
Subject: Re: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device
 according to numa node
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4115F40014
X-Stat-Signature: u6ik6undckp3ohhxg4n8h8ggc1eosojz
X-Rspam-User: 
X-HE-Tag: 1760504566-349864
X-HE-Meta: U2FsdGVkX1/WA+QDrLaMxvFRHV049kbAxKl6ndElK7QyIGa/3gRMg63SpP2c5K0YR6f6K+Ys5cIzsDQAM4OZNRwgW4yCvHSfa+XhHtQR/YsX+5Bxcqd6/COnxMRvVINBGSMklAru05/8I3tbTCVeOZKCLQ6L87lz8yCdF+IIs89ZKpXd7okWfAcTtKMmln0vwqkhsu2xa4D2BufQc/jAxRGBrIirfvo7WMXvXMcAmC+cKjXOPYNCEQO8PnspGGaWq4hPkdzf4RpiHWSlM/4VqXm98OisvEv51BLIFLtQc+qxBrsQExHxaS0kckW7YhK/wR9V8Jo6n6Gjt5sd7bNqfCCGCYou18+cdGyE4Iu4NfMg2qfjefOqlQTbgNIMCAugOIVUBScvzQt1qoIA39GlrShvMUgDHCsW0lg8DTJvUidpLWA1Qpb3KpL2ymzB3+2ryeCuDXWDsbMJ63OIaFOpL9mnHpkZjRDcFgDTKM0F6ehPu014s1CNVH4F2spSMbexlDuqRzKB3lfSay1AdglI7Ra82f0+PkZrXdhs8AYMHbMJTJ1vP81lMVvDN03Yn9C4A0TkA5D4l6GeJnKXKzzzBjdYSOyKPOcX7FGeMvaCxgcuCCEuo9rHAdZd0MZqi69fctmb0ohiDzrENGuC9pSe5tv4ra3PTsQgbA8yMgO1BSV57L8ydZ+bzhLqX60UJ9oxFKi4NvaGC/n4RI7VjDsnE38ClLvsV6V+S0YVxwF3E3CbE1cDwuXQtwrNgDcpkF1PVhhhy/FWFze06axLN6Cub6bkrDzmpaA9xi8oRyV8fElqcYorkI1aVNyARoRXIiYjTyu5hm4Z7sA35haGm28APZ+7vK6PVACG3N9LQplwKe0n0WtGyl5qO5F/N6MULByCntSC6WKii1lDdvQ6N/wlSu+HuvECJY9lVQEYUviBItG7qSvKGd/yzb9Xi/kRnvktjSmd2URrkN3H8tCI0WX
 afTStF81
 MUP1XjZiGxtwq19flH9kabxG9Hg4p7mk1KJWS21p65fcNkYaYqN0lk8d6ilxRKfBGoXpdTLBMAUOZk0rSsGUTi816u+jUtxvmDEz9ehWF+7JDCf7I5JLcmxqxn5m/5EYuGV8i2bBSUOwm/3RLbq7yxhMcd0qEPgs+w7T+1FNYyfOCO8Xr0zM+7mhrqA0r6VcKNRYB6CM4sakLS8Opiu8aYWM0zBHN+5aMrOJIoOGgrqwNZRKh5kq4q74VrG1g0kP6jThC4rTkvFn6pGs+AIahGBWUMToLPJfMjU7Ctc5Oz4uFQNWsWk0ZnIJ+DDWY7lWydzRNvHLGdLg4rcMFVuD5Hk17YAU9nSZf81M1AQf9B7CgFeCaeyyP3zuNCZRftTwiP9r0ra7N1ln7gRsFu27xDFhkRjPn8OoNvEAvgNHy2Xdsu/OqUWQmfRVMzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 11:06=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> On 10/13/25 at 02:09pm, Barry Song wrote:
> > > -static int swap_node(struct swap_info_struct *si)
> > > -{
> > > -       struct block_device *bdev;
> > > -
> > > -       if (si->bdev)
> > > -               bdev =3D si->bdev;
> > > -       else
> > > -               bdev =3D si->swap_file->f_inode->i_sb->s_bdev;
> > > -
> > > -       return bdev ? bdev->bd_disk->node_id : NUMA_NO_NODE;
> > > -}
> > > -
> >
> > Looking at the code, it seems to have some hardware affinity awareness,
> > as it uses the swapfile=E2=80=99s bdev=E2=80=99s node_id. Are we regres=
sing cases where
> > each node has a closer block device?
>
> I had talked about this with Chris before I posted v1. We don't need to
> worry about this because:
>
> 1) Kernel code rarely set disk->node_id, all disks just assign
> NUMA_NO_NODE to it except of these:
>
> drivers/nvdimm/pmem.c <<pmem_attach_disk>>
> drivers/md/dm.c <<alloc_dev>>
>
> For intel ssd Aaron introduced the node based si choosing is for, it
> should be Optane which has been discontinued. It could be wrong, then
> hope intel can help test so that we can see what impact is brought in.
>
> 2) The gap between disk io and memory accessing
> Usually memory accessing is nanosecond level, while disk io is
> microsecond level, HDD even could be at millisecond. The node affinity
> saving nanoseconds is negligible compared to the disk's own acessing
> speed. This includes pmem, its io is more than ten times or even more
> than memory accessing.

I agree that it=E2=80=99s fine to remove the code if the related hardware i=
s obsolete.
I found a paper [1] showing that accessing local Optane PMEM is much faster
than accessing remote Optane PMEM (see slides 4 and 5). That might explain =
why
they started the project to make swapfile NUMA-aware.

My point is that we should at least mention this in the changelog to
honor their past contributions. But since the hardware is no longer used,
we can remove the code to reduce complexity and stop maintaining it.

I see Aaron's email is no longer reachable, which is probably why we haven=
=E2=80=99t
received any feedback from them.

[1] https://www.usenix.org/system/files/osdi21_slides_wang-qing.pdf

>
> If there's a real system which owns disks belonging to NUMA nodes, we
> can test to see if the new round robin way is better or worse then the
> node based way.

Yep. If there might be a real user in the future, we can revisit this.
For now, I agree that we can drop the complexity.

Thanks
Barry

