Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E997ED35668
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 03:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1676B0088; Tue, 27 Jan 2026 22:42:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1901F6B0089; Tue, 27 Jan 2026 22:42:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 046DE6B008A; Tue, 27 Jan 2026 22:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E306C6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 22:42:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9063E16043E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:42:04 +0000 (UTC)
X-FDA: 84379974168.09.3703264
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8FD2340005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:42:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YRNarkVd;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769571722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SwBguRWAAmYItGLTzIr3Mm+ozYbVg5d6gnrYtiYn2zY=;
	b=S3frZW31fvjfCmcx/PYrPwLy3TTzhstUpqfaTDW8W6LIAZczH8HKTFohNioQwJgUhGDAPz
	iE0xWiUiUv7RJUNYoy0EI7bg2401KbjmO3QBAaa7e8NhUejZwk3a8AfQ2Yp2khgJQpiWOO
	QUDBdAigh+qIPXofg3BOh9SBzrUipY4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YRNarkVd;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769571722; a=rsa-sha256;
	cv=pass;
	b=0Mrjijtcy3UgjXfFyqbDM89Pq/C72y5g/5/DRIferRE2lfkCCyAIgwTC+IMIRMMUy2ZtEg
	ZX5yFlLZGkBB27wTgAPxlrshWYCVfnSgYaR9iOfuN2iN/5E4gMqgUm0Aw3H+rjsJGGjZY8
	dcXtwqhA+JD1MqjiKHoCqPGesrSGD/0=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50299648ae9so156111cf.1
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:42:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769571722; cv=none;
        d=google.com; s=arc-20240605;
        b=Kpsa1OcU7k/HWLTCk3i7gTW33aXlkdkge8KIuNeYezouwfAApoi4Q8iCVf400PFmoN
         +aHstpb1LMbABgCrxZYUqINEXyrbxmSzrAY43Kbqq6MaQESXF+NMKlBOhfvBHW+Jvq7H
         s3hRuFbIzZGjpol7s4ZaG6pemXe4qCCSDLJ49ibBAJk9UJANGTDDwCJ215CINT9eeLW3
         Ctu9waz90ZdIbsGGxy3sHrIEFo0RYSTFNX5du/F1ubP5rhTqvqrebLeiYgPfThT2vwbG
         iAaj8SrY93X5Fx674lyQBswWoQVGiPzSWHnP15R9Hokom0N6R6hVy5PY8AE280zF8vAM
         84Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SwBguRWAAmYItGLTzIr3Mm+ozYbVg5d6gnrYtiYn2zY=;
        fh=Ff18U4lZXCyXCAhtG1S3YdLhHJLiODRkWpHBbxDEixs=;
        b=bQ4FpbGm4yZIDyJ2SNv/ACuhClqVV1TMjUH1Z459lkztZuAgAFVT2vrbf0kQ4ioc7K
         2NnFk/x8MKi+gz5s7D9uCO6DHm72H/ws9YjLian6qsGXtP4/PtKapc6XtOYtop4Ko2gG
         bnXqQxBKQDjHC7X8YeYNw68vsMAHuJMcPgfxyxhS8sd5ec86t0Bm29gQrBP1PZ5yy3zf
         5TIS+yvNPtCVb/LzCGSX6jRFhmmTSS6DM9yxbzjG5bw93dF+QctUt9WxgwEcnomA56N+
         W3590NSobozu/F6umFW6QfEMJKnB/ECQ2vebIjgZXQ0kNwPwIE6u5DJGXovLq+lkspIW
         W0PQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769571722; x=1770176522; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SwBguRWAAmYItGLTzIr3Mm+ozYbVg5d6gnrYtiYn2zY=;
        b=YRNarkVdrGmAjUmcyPkwDClxnd0/zZ2RDKedj5mN+p1ClvVs7qG5kpGz4zyCVlc9VK
         S1vJ++zF6geXr6plC9zzHJ74c2bS7++iniWt/GYLw3hYtGYbGbR+/xWvjxHaIRyOUhWi
         2qu9nw5MPLMkiYSeAZBNSieWaNVhdCHlYssCK3uoRuify/DDeopnpYC5v1C1iEx+j7Jp
         dXKOF8XKVpfZFShwJY0m4fB0eZ/cVizuZnDCPalgKteCV6OqkoGUGV0G98xtslH2XRdV
         dJWi3HZlwgafwe0GxBpi1wp+y9RVcrOWa/a9bf3MUwZV9XHEBZ5MG/sS7u9YX78wZ2id
         19eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769571722; x=1770176522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SwBguRWAAmYItGLTzIr3Mm+ozYbVg5d6gnrYtiYn2zY=;
        b=B3vB88YY/WfQtTRFK1gcSk2ItYMnGMCIn7EUVBHIJDDIuq/NeStWKDSOE8+6dE20pg
         gjQu9HtHY5lDdhL9sHu9rV3yqzHVMK5aSnNRYAny1xDheDmgoz5fMtjoNxf2jFJ16Odg
         lIJBIrH+vT9skweJ5xQCdq49SPG9shXl6sbkbCC3NCOF/DFgO966UgJnluCj2pQyVZEU
         gudlGT2OgLPBtWRGoFM9/TExpxbn4FUrsrSsptgCTZIfTRHO6J4eRUV5Gxb+YUgw8ZWf
         mV6s61icFn+w+MacmmWKE3FwEggNbR6OngdKuJiaNyqlAXLNpee81nuX24HqEAa/iUpq
         FSzw==
X-Forwarded-Encrypted: i=1; AJvYcCVOmb9UhCNI28u1kynNKSL8b28wiT4USMojCxDOjy9pNQkXb1rJWnQ/k2G5JfFY7wi+tH/DgP41og==@kvack.org
X-Gm-Message-State: AOJu0YxuGmab6kJ/MA3baBvtH+KgqkojJtGYfKEX35lcWCSnEh1dWWXP
	sKEKJbDvQmTwEN37kJ/SCqjtbYGdDbSYV9AQ1EP9rCWZfbeJqwepJoLK2b+O3T9cK22SpxVjAZI
	WQ6Af21xED/zYXY8OYuwmE2P8FehTKKKS98zgVcb7xDlLJn8Ct2I/a9dh
X-Gm-Gg: AZuq6aL+TQeTrXXiR/yKl3jb1WKv8YN+61bKfT44a9i5+YLymPa3a63D0Emo5mHCRZH
	ONEqMuevhS5Hy24sjSjgusavb6DVHE/wbzk5HS4UrC2QaNL7JSQN9KraM0WSC7B3RpUIQtciwTo
	eGSAgZ3UwV/DoFnO36outO2gwt7F01QojBgCx2C3BJYqrLrUy7WsYIls5oTlkbGWRcYPIejo1EA
	rai7ioTp+P5HDfVyoNH2r2TASwtSXrXRORvy1+UxfHLcRrcEy2B6Fg/KAy8ZTlj6mQFHQ==
X-Received: by 2002:ac8:5a54:0:b0:4ff:cb25:998b with SMTP id
 d75a77b69052e-5032f4d7461mr11243681cf.12.1769571721106; Tue, 27 Jan 2026
 19:42:01 -0800 (PST)
MIME-Version: 1.0
References: <697400dc.a70a0220.35de72.000a.GAE@google.com> <20260124113148.2398-1-hdanton@sina.com>
 <CAJuCfpEcqAiK-z=EZ5im12F2wfGHYogiMHaTC4t5uopLmBKQPw@mail.gmail.com>
 <CAJuCfpEJUeQcpfbh-0KTsp1UdTs5yrKTbvAV6QOKdQHJZ2HWww@mail.gmail.com>
 <CAJuCfpF_a=-kTZLdOzZpKrWhO2CyowwT+PdZ7_tP-cXxe23DiQ@mail.gmail.com>
 <CAEf4BzZxEVSFtu7uozpr-7NvRqt2WqjzmHrvQgG6TDoJQ9p_AQ@mail.gmail.com> <CAJuCfpHMJ-5hP+eHpD1jyJtdmFb9qaSfaZ8GdsHY8BrorvUdkg@mail.gmail.com>
In-Reply-To: <CAJuCfpHMJ-5hP+eHpD1jyJtdmFb9qaSfaZ8GdsHY8BrorvUdkg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 27 Jan 2026 19:41:50 -0800
X-Gm-Features: AZwV_Qh6vf3Ai4CvWQNcsmL-MiMx5KE3bntdJctuw9YitA0XXF6MJdVfmPVbZ6Q
Message-ID: <CAJuCfpFbGeUBVRh7KqYLRB2PBQrXDjfPuHKjW+yunXr0cj5kMQ@mail.gmail.com>
Subject: Re: [syzbot] [block?] possible deadlock in blkdev_read_iter
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>, 
	syzbot <syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com>, axboe@kernel.dk, 
	linux-block@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FD2340005
X-Rspamd-Server: rspam07
X-Stat-Signature: qzd8hubyomnt16n5bok41a9gsdspa4w6
X-HE-Tag: 1769571722-877941
X-HE-Meta: U2FsdGVkX1/+GkwogmBZejfuxNNsf379Owl7w0jcxnX5PRDBFROQurCMD2Netu3rKcd/StXviIcdqUNXMeSL4vm1TkkwtV4f1y8ucFaPf8vUOfD1wJT8tCi8gTxB4SfyeNtA+p8vsK6F7s/ypitcTrPHrHW0zUedirnEUF6UMv6EvCq36h6WbsrxCT6wEnXRTuyX/Qo8qYQFR9Lz0Gy5phQPcqZGgIh9NoLOIYHtSF//Rri700k5hAUN3fRf9CDIZPvbJP1TjDUt/w2ztQ01Na7QnG3hDMcx43DYeKIcAE1AbWOIYauIjrh55VVgtGTDoVS/R4krah/KNXYaFyCkv4ILypJyIi38tmBfQrW2btWQSF/4qhcLoCDTkeGDFuFKh+8I5BfgpL9uY4+MBXGj3ZLxR93Riu6wiL7gehfMVwSnp/CEiiKXdGN/CdbrBoM5rKTpgwMu9nKiLflZST3QxsZdLy3Mr8jy1TFssdhryVmn5MeQ+zHGyHA9/dO+gYk9FsLROGttBl+SFTR8CIviNL/i1PoVIFUdnrdlzZc+2pTNqoYauuJwbGUIQx6wZlIKd8YMbNIXGTlSQZUcy+m9OzU/+pmFussdyupOKyhE59JvwyBxOTEUmgTYAKAsCxjGGbyiL1jdgHFYwvHzSq9U+fMSrcSxFuXmjDBkw8Jrh1uEHBVXEIqBmD3GehyfRHDfHsZjldzdv9p/91pg6jzw5UNEFizP5RkMqFL9iGnpOcUqiDh60AYmchzNWhn/BqiCjCSLxXnFBPCXQAP9s09uuMF6c1SBKnrzCJEZkM5wIC50f+fnDd/TM10XivilnhMnpq9fyW6IubgBlGUrIechZdwnIx1L3ya7vIwieh+VOwREUk0/GCgNcxhA8FewBE//keY6bJJARsKoE0gk+y4CDzvDG3UowPsXLydomj3xLoUctroW2UPhdVpq11XCF2pByKAhLHndB99hmN/y1yZ
 8V1WHpGa
 YGLJU4vEfYGENkaAR8aQEBJP8gccSIupmoPJqCR6KQ6M91wEWDu6l9T/AuzJNQ9RCP8ot1I6smgIaEk2A8a21N1z2t+lnNNecvBkv26PfaATntqX29GtEaqEf7RwewjN4h1JIndlAXOet/weZDwSaX2jWrtE14K6o9sZlXHLplbRYZjFdH3nGULYKwZtLHNUYmBpwz6nZmS11fvNLHPhtNA3GrraC0by+YMivwA81HbNk8r4hy+Pe/bt11ttgSN0A7LiO2TwIQAbj+uAfhLjPxT31Imad+Sn8vMzbCXT+jQnWPaDrg+eyiM07H1WBFEpQK8uNAVCDOAsRZ51kxvlw6rHDW9PAqcFcY/vLO0dMUo+TWWPcdju/U4BMcoDGx4fA7gXSf20CQSzPnVSYwNNUTbVKfUx8UZJbU8WbMsWxlgUY90mkYJuNb2OYyjl4PoHP4ic3klk9E/aGiUGPEBE8rIWPcwb5Ykq0cVgKSwzNJxYLcMFCLFnmcYBVAn/QeW3yknOs2cGHx1myYDZb8DuBF8ImHmYBoZZjNySQ0zpEy2e9GjV32CsHyJM9gzIM1N6RqGAp2ZAalF0lrC6r5fAhsPV9L96scEkbeiJh7ZHVzBLl9ibVI/emTYsdivOnbpE7KDpyWcoo9OkOr8nyX9LDvvFNypBDbuC+rMojo8W9ahrKCC42+1cn3KDE8zkK7DtWyr3sN+cLg6z9BDovwQjyGSi4APLpVPV/+fUg9a1dgdH10Ab8LhYOqhkJBvhpAiJxRaRcwg5p+SySc8WFk9xLNgJV6n5pSclE6C+dU9EmpxxTmaAJB4sKUkEZbpJhXbrA0mfQom1FZ0HUNn7oHERMX4oKedOQO+k0RxXVL6GAnRlwyT6IrlnsvsZtWIcw6RMK3sLe6DjyejlnSRaYK3xSfsWFowAEmrM4R/kiLvqmn5VokUb3pa7+0m68nyy4OwAO7AqjGmG3AIUc8bQf58HpEne29IPU
 hhQOg7mh
 SbSXdrHDoTs3r67me+oefij5ibnExNr9/JtH8MhlXa4ntHNEuzdH2kPMhm/3fpJnXD5Mcmau0Eo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 3:52=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Jan 27, 2026 at 10:51=E2=80=AFAM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jan 26, 2026 at 6:22=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > On Mon, Jan 26, 2026 at 2:33=E2=80=AFPM Suren Baghdasaryan <surenb@go=
ogle.com> wrote:
> > > >
> > > > On Mon, Jan 26, 2026 at 9:20=E2=80=AFAM Suren Baghdasaryan <surenb@=
google.com> wrote:
> > > > >
> > > > > On Sat, Jan 24, 2026 at 3:32=E2=80=AFAM Hillf Danton <hdanton@sin=
a.com> wrote:
> > > > > >
> > > > > > Add Lorenzo and Suren
> > > > >
> > > > > Thanks!
> > > > >
> > > > > >
> > > > > > > Date: Fri, 23 Jan 2026 15:14:36 -0800
> > > > > > > Hello,
> > > > > > >
> > > > > > > syzbot found the following issue on:
> > > > > > >
> > > > > > > HEAD commit:    24d479d26b25 Linux 6.19-rc6
> > > > > > > git tree:       upstream
> > > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1=
00033fa580000
> > > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D1=
859476832863c41
> > > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4e7=
0c8e0a2017b432f7a
> > > > > > > compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld=
 (GNU Binutils for Debian) 2.40
> > > > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=
=3D11451b9a580000
> > > > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1=
045e852580000
> > > > > > >
> > > > > > > Downloadable assets:
> > > > > > > disk image (non-bootable): https://storage.googleapis.com/syz=
bot-assets/d900f083ada3/non_bootable_disk-24d479d2.raw.xz
> > > > > > > vmlinux: https://storage.googleapis.com/syzbot-assets/d0f3c47=
f6869/vmlinux-24d479d2.xz
> > > > > > > kernel image: https://storage.googleapis.com/syzbot-assets/80=
0231513703/bzImage-24d479d2.xz
> > > > > > >
> > > > > > > IMPORTANT: if you fix the issue, please add the following tag=
 to the commit:
> > > > > > > Reported-by: syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmai=
l.com
> > > > > > >
> > > > > > > WARNING: possible circular locking dependency detected
> > > > > > > syzkaller #0 Not tainted
> > > > > > > ------------------------------------------------------
> > > > > > > syz.0.17/6091 is trying to acquire lock:
> > > > > > > ffff8881061287a8 (
> > > > > > > &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: inode_lock_share=
d include/linux/fs.h:1042 [inline]
> > > > > > > &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: blkdev_read_iter=
+0x19e/0x500 block/fops.c:855
> > > > > > >
> > > > > > > but task is already holding lock:
> > > > > > > ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vma+0x1=
0e/0xed0 mm/mmap_lock.c:334
> > > > > > >
> > > > > > > which lock already depends on the new lock.
> > > > > > >
> > > > > > >
> > > > > > > the existing dependency chain (in reverse order) is:
> > > > > > >
> > > > > > > -> #2 (vm_lock){++++}-{0:0}:
> > > > > > >        __vma_enter_locked+0x260/0x770 mm/mmap_lock.c:72
> > > > > > >        __vma_start_write+0x21/0x160 mm/mmap_lock.c:104
> > > > > > >        vma_start_write include/linux/mmap_lock.h:213 [inline]
> > > > > > >        mprotect_fixup+0x4e3/0xb80 mm/mprotect.c:768
> > > > > > >        setup_arg_pages+0x4a2/0xbb0 fs/exec.c:670
> > > > > > >        load_elf_binary+0xb5b/0x4fe0 fs/binfmt_elf.c:1028
> > > > > > >        search_binary_handler fs/exec.c:1669 [inline]
> > > > > > >        exec_binprm fs/exec.c:1701 [inline]
> > > > > > >        bprm_execve fs/exec.c:1753 [inline]
> > > > > > >        bprm_execve+0x8c2/0x1620 fs/exec.c:1729
> > > > > > >        kernel_execve+0x2ef/0x3b0 fs/exec.c:1919
> > > > > > >        try_to_run_init_process init/main.c:1506 [inline]
> > > > > > >        kernel_init+0x14a/0x2b0 init/main.c:1634
> > > > > > >        ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:15=
8
> > > > > > >        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:=
246
> > > > > > >
> > > > > > > -> #1 (&mm->mmap_lock){++++}-{4:4}:
> > > > > > >        __might_fault mm/memory.c:7174 [inline]
> > > > > > >        __might_fault+0x113/0x190 mm/memory.c:7168
> > > > > > >        _copy_to_iter+0x1c2/0x1710 lib/iov_iter.c:196
> > > > > > >        copy_page_to_iter lib/iov_iter.c:374 [inline]
> > > > > > >        copy_page_to_iter+0x12a/0x1e0 lib/iov_iter.c:361
> > > > > > >        copy_folio_to_iter include/linux/uio.h:204 [inline]
> > > > > > >        filemap_read+0x6b1/0xe40 mm/filemap.c:2851
> > > > > > >        blkdev_read_iter+0x1ac/0x500 block/fops.c:856
> > > > > > >        new_sync_read fs/read_write.c:491 [inline]
> > > > > > >        vfs_read+0x8bf/0xcf0 fs/read_write.c:572
> > > > > > >        ksys_read+0x12a/0x250 fs/read_write.c:715
> > > > > > >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > > > > >        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:9=
4
> > > > > > >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > > > >
> > > > > > > -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
> > > > > > >        check_prev_add kernel/locking/lockdep.c:3165 [inline]
> > > > > > >        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> > > > > > >        validate_chain kernel/locking/lockdep.c:3908 [inline]
> > > > > > >        __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:=
5237
> > > > > > >        lock_acquire kernel/locking/lockdep.c:5868 [inline]
> > > > > > >        lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
> > > > > > >        down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
> > > > > > >        inode_lock_shared include/linux/fs.h:1042 [inline]
> > > > > > >        blkdev_read_iter+0x19e/0x500 block/fops.c:855
> > > > > > >        __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
> > > > > > >        freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
> > > > > > >        __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
> > > > > > >        do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
> > > > > > >        procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
> > > > > > >        vfs_ioctl fs/ioctl.c:51 [inline]
> > > > > > >        __do_sys_ioctl fs/ioctl.c:597 [inline]
> > > > > > >        __se_sys_ioctl fs/ioctl.c:583 [inline]
> > > > > > >        __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
> > > > > > >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > > > > >        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:9=
4
> > > > > > >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > > > >
> > > > >
> > > > > It looks like:
> > > > > #0 is executing PROCMAP_QUERY ioclt, read-locks vm_lock and then =
calls
> > > > > build_id_parse()->__build_id_parse(...,
> > > > > may_fault=3Dtrue)->__kernel_read() which eventually takes
> > > > > inode->i_rwsem.
> > > > > #1 is a file-backed page fault which asserts that it might take
> > > > > mmap_lock for read.
> > > > > #2 is load_elf_binary()->mprotect_fixup() which write-locks both
> > > > > mmap_lock and vm_lock. I'm guessing it already holds inode->i_rws=
em
> > > > > before write-locking these locks.
> > > > >
> > > > > Originally I thought the issue is most liley introduced in
> > > > > d9d1c2d81797 ("fs/proc/task_mmu: execute PROCMAP_QUERY ioctl unde=
r
> > > > > per-vma locks"). But if #2 indeed takes inode->i_rwsem before
> > > > > write-locking mmap_lock, then the problem should exist even befor=
e
> > > > > that change when we didn't use vm_lock and relied on mmap_lock...
> > > > >
> > > > > I'll try to analyze this more before attempting a fix.
> > > >
> > > > I was able to reproduce the same issue even after reverting
> > > > d9d1c2d81797. The deadlock in this case is simpler and involves
> > > > mmap_lock instead of vm_lock (see below).
> > > > Looks like the race is between the read() syscall and do_procmap_qu=
ery().
> > > > I'll continue investigating, in the meantime CC'ing Andrii.
> > >
> > > So, here is a cleaner version of that report (with d9d1c2d81797 rever=
ted):
> > >
> > >  -> #1 (&mm->mmap_lock){++++}-{4:4}:
> > >         __might_fault+0xed/0x170
> > >         _copy_to_iter+0x118/0x1720
> > >         copy_page_to_iter+0x12d/0x1e0
> > >         filemap_read+0x720/0x10a0
> > >         blkdev_read_iter+0x2b5/0x4e0
> > >         vfs_read+0x7f4/0xae0
> > >         ksys_read+0x12a/0x250
> > >         do_syscall_64+0xcb/0xf80
> > >         entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > >
> > >  -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
> > >         __lock_acquire+0x1509/0x26d0
> > >         lock_acquire+0x185/0x340
> > >         down_read+0x98/0x490
> > >         blkdev_read_iter+0x2a7/0x4e0
> > >         __kernel_read+0x39a/0xa90
> > >         freader_fetch+0x1d5/0xa80
> > >         __build_id_parse.isra.0+0xea/0x6a0
> > >         do_procmap_query+0xd75/0x1050
> > >         procfs_procmap_ioctl+0x7a/0xb0
> > >         __x64_sys_ioctl+0x18e/0x210
> > >         do_syscall_64+0xcb/0xf80
> > >         entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > >
> > >  other info that might help us debug this:
> > >
> > >   Possible unsafe locking scenario:
> > >
> > >         CPU0                    CPU1
> > >         ----                    ----
> > >    rlock(&mm->mmap_lock);
> > >                                 lock(&sb->s_type->i_mutex_key#8);
> > >                                 lock(&mm->mmap_lock);
> > >    rlock(&sb->s_type->i_mutex_key#8);
> > >
> > >   *** DEADLOCK ***
> > >
> > > Both threads are calling blkdev_read_iter(), which uses
> > > inode_lock_shared() to read-lock inode->i_rwsem. I'm not sure why CPU=
1
> > > shows lock() instead of rlock(). So both threads read-lock
> > > inode->i_rwsem and mmap_lock but in a different order. IIUC, with
> > > read-locks this should not deadlock until some other thread
> > > write-locks the mmap_lock in between and this becomes a real deadlock=
:
> > >
> > >         CPU0       CPU1         CPU2
> > >         ----       ----         ----
> > >    rlock(&mm->mmap_lock);
> > >                                 rlock(&sb->s_type->i_mutex_key#8);
> > >                    wlock(&mm->mmap_lock) <-- waiting for CPU0
> > >                                 rlock(&mm->mmap_lock); <-- waiting fo=
r CPU1
> > >    rlock(&sb->s_type->i_mutex_key#8); <-- waiting for CPU2
> > >
> > > I believe in the original report this write-locking thread was the on=
e
> > > calling mprotect_fixup().
> > >
> > > Per https://docs.kernel.org/mm/process_addrs.html#lock-ordering,
> > > inode->i_rwsem should be locked before mm->mmap_lock, so
> > > procfs_procmap_ioctl() has to be fixed to follow this lock ordering.
> > > One possibility I can think of is to use build_id_parse_nofault()
> > > first and if it fails because the required page is not faulted, we do
> > > freader_init_from_file(), then drop the mmap/vma lock and execute
> > > freader_fetch() outside of these locks to fault in that page. Once
> > > that's done, we'll retry the whole operation and this time
> > > build_id_parse_nofault() should pass (unless we already evicted that
> > > page, which is extremely unlikely and in that case, we'll retry
> > > again).
> > >
> > > I tried a POC with build_id_parse_nofault() but without the whole
> > > dance with freader_init_from_file/freader_fetch and the deadlock is
> > > gone. Andrii, WDYT?
> >
> > I don't like it :) Too much complexity, _nofault() variant only makes
> > sense for BPF in non-sleepable contexts. I think this can be fixed
> > simpler and cleaner. We don't need to hold VMA lock while fetching
> > build ID. Build ID works with vma's vm_file, so we can just get its
> > reference, drop vma lock, then fetch build id. Below diff passes our
> > BPF selftests. Might need to think about a bit leaner code changes,
> > but the idea should be clear. Diff below will be butchered by gmail,
> > but you can fetch it at [0]. Do you mind validating that deadlock is
> > gone? Thanks!
>
> Sure. I'll test it later today, once I'm home.

With this fix, the issue is not reproducible. Once you post the final
version I can retest it again.
Thanks,
Suren.

>
> >
> > [0] https://git.kernel.org/pub/scm/linux/kernel/git/andrii/bpf-next.git=
/commit/?h=3Dprocmap-query-vma-deadlock-fix&id=3D7faf95b63a8a7ac6e78b6d9010=
1c94bfa6ecdfd1
> >
> > Author: Andrii Nakryiko <andrii@kernel.org>
> > Date:   Tue Jan 27 10:46:04 2026 -0800
> >
> >     procfs: avoid fetching build ID while holding VMA lock
> >
> >     Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 81dfc26bfae8..564bf82e3731 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -656,6 +656,7 @@ static int do_procmap_query(struct mm_struct *mm,
> > void __user *uarg)
> >         struct proc_maps_locking_ctx lock_ctx =3D { .mm =3D mm };
> >         struct procmap_query karg;
> >         struct vm_area_struct *vma;
> > +       struct file *vm_file =3D NULL;
> >         const char *name =3D NULL;
> >         char build_id_buf[BUILD_ID_SIZE_MAX], *name_buf =3D NULL;
> >         __u64 usize;
> > @@ -720,6 +721,9 @@ static int do_procmap_query(struct mm_struct *mm,
> > void __user *uarg)
> >                 karg.dev_major =3D MAJOR(inode->i_sb->s_dev);
> >                 karg.dev_minor =3D MINOR(inode->i_sb->s_dev);
> >                 karg.inode =3D inode->i_ino;
> > +
> > +               if (karg.build_id_size)
> > +                       vm_file =3D get_file(vma->vm_file);
> >         } else {
> >                 karg.vma_offset =3D 0;
> >                 karg.dev_major =3D 0;
> > @@ -727,21 +731,6 @@ static int do_procmap_query(struct mm_struct *mm,
> > void __user *uarg)
> >                 karg.inode =3D 0;
> >         }
> >
> > -       if (karg.build_id_size) {
> > -               __u32 build_id_sz;
> > -
> > -               err =3D build_id_parse(vma, build_id_buf, &build_id_sz)=
;
> > -               if (err) {
> > -                       karg.build_id_size =3D 0;
> > -               } else {
> > -                       if (karg.build_id_size < build_id_sz) {
> > -                               err =3D -ENAMETOOLONG;
> > -                               goto out;
> > -                       }
> > -                       karg.build_id_size =3D build_id_sz;
> > -               }
> > -       }
> > -
> >         if (karg.vma_name_size) {
> >                 size_t name_buf_sz =3D min_t(size_t, PATH_MAX,
> > karg.vma_name_size);
> >                 const struct path *path;
> > @@ -779,6 +768,28 @@ static int do_procmap_query(struct mm_struct *mm,
> > void __user *uarg)
> >         query_vma_teardown(&lock_ctx);
> >         mmput(mm);
> >
> > +       if (karg.build_id_size) {
> > +               __u32 build_id_sz;
> > +
> > +               err =3D -ENOENT;
> > +               if (vm_file)
> > +                       err =3D build_id_parse_file(vm_file,
> > build_id_buf, &build_id_sz);
> > +               if (err) {
> > +                       karg.build_id_size =3D 0;
> > +               } else {
> > +                       if (karg.build_id_size < build_id_sz) {
> > +                               err =3D -ENAMETOOLONG;
> > +                               goto out;
> > +                       }
> > +                       karg.build_id_size =3D build_id_sz;
> > +               }
> > +       }
> > +
> > +       if (vm_file) {
> > +               fput(vm_file);
> > +               vm_file =3D NULL;
> > +       }
> > +
> >         if (karg.vma_name_size &&
> > copy_to_user(u64_to_user_ptr(karg.vma_name_addr),
> >                                                name, karg.vma_name_size=
)) {
> >                 kfree(name_buf);
> > @@ -797,6 +808,8 @@ static int do_procmap_query(struct mm_struct *mm,
> > void __user *uarg)
> >
> >  out:
> >         query_vma_teardown(&lock_ctx);
> > +       if (vm_file)
> > +               fput(vm_file);
> >         mmput(mm);
> >         kfree(name_buf);
> >         return err;
> > diff --git a/include/linux/buildid.h b/include/linux/buildid.h
> > index 831c1b4b626c..7acc06b22fb7 100644
> > --- a/include/linux/buildid.h
> > +++ b/include/linux/buildid.h
> > @@ -7,7 +7,10 @@
> >  #define BUILD_ID_SIZE_MAX 20
> >
> >  struct vm_area_struct;
> > +struct file;
> > +
> >  int build_id_parse(struct vm_area_struct *vma, unsigned char
> > *build_id, __u32 *size);
> > +int build_id_parse_file(struct file *file, unsigned char *build_id,
> > __u32 *size);
> >  int build_id_parse_nofault(struct vm_area_struct *vma, unsigned char
> > *build_id, __u32 *size);
> >  int build_id_parse_buf(const void *buf, unsigned char *build_id, u32 b=
uf_size);
> >
> > diff --git a/lib/buildid.c b/lib/buildid.c
> > index aaf61dfc0919..c0002129d526 100644
> > --- a/lib/buildid.c
> > +++ b/lib/buildid.c
> > @@ -271,7 +271,7 @@ static int get_build_id_64(struct freader *r,
> > unsigned char *build_id, __u32 *si
> >  /* enough for Elf64_Ehdr, Elf64_Phdr, and all the smaller requests */
> >  #define MAX_FREADER_BUF_SZ 64
> >
> > -static int __build_id_parse(struct vm_area_struct *vma, unsigned char
> > *build_id,
> > +static int __build_id_parse(struct file *file, unsigned char *build_id=
,
> >                             __u32 *size, bool may_fault)
> >  {
> >         const Elf32_Ehdr *ehdr;
> > @@ -279,11 +279,7 @@ static int __build_id_parse(struct vm_area_struct
> > *vma, unsigned char *build_id,
> >         char buf[MAX_FREADER_BUF_SZ];
> >         int ret;
> >
> > -       /* only works for page backed storage  */
> > -       if (!vma->vm_file)
> > -               return -EINVAL;
> > -
> > -       freader_init_from_file(&r, buf, sizeof(buf), vma->vm_file, may_=
fault);
> > +       freader_init_from_file(&r, buf, sizeof(buf), file, may_fault);
> >
> >         /* fetch first 18 bytes of ELF header for checks */
> >         ehdr =3D freader_fetch(&r, 0, offsetofend(Elf32_Ehdr, e_type));
> > @@ -324,7 +320,11 @@ static int __build_id_parse(struct vm_area_struct
> > *vma, unsigned char *build_id,
> >   */
> >  int build_id_parse_nofault(struct vm_area_struct *vma, unsigned char
> > *build_id, __u32 *size)
> >  {
> > -       return __build_id_parse(vma, build_id, size, false /* !may_faul=
t */);
> > +       /* only works for page backed storage  */
> > +       if (!vma->vm_file)
> > +               return -EINVAL;
> > +
> > +       return __build_id_parse(vma->vm_file, build_id, size, false /*
> > !may_fault */);
> >  }
> >
> >  /*
> > @@ -340,7 +340,16 @@ int build_id_parse_nofault(struct vm_area_struct
> > *vma, unsigned char *build_id,
> >   */
> >  int build_id_parse(struct vm_area_struct *vma, unsigned char
> > *build_id, __u32 *size)
> >  {
> > -       return __build_id_parse(vma, build_id, size, true /* may_fault =
*/);
> > +       /* only works for page backed storage  */
> > +       if (!vma->vm_file)
> > +               return -EINVAL;
> > +
> > +       return __build_id_parse(vma->vm_file, build_id, size, true /*
> > may_fault */);
> > +}
> > +
> > +int build_id_parse_file(struct file *file, unsigned char *build_id,
> > __u32 *size)
> > +{
> > +       return __build_id_parse(file, build_id, size, true /* may_fault=
 */);
> >  }
> >
> >  /**
> >
> >
> > >
> > > >
> > > > [   62.320932][ T9229]
> > > > [   62.321471][ T9229] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > [   62.323016][ T9229] WARNING: possible circular locking dependenc=
y detected
> > > > [   62.324618][ T9229] 6.19.0-rc6-00001-g40bea6261b2a #42 Not taint=
ed
> > > > [   62.326013][ T9229] --------------------------------------------=
----------
> > > > [   62.327560][ T9229] hillf/9229 is trying to acquire lock:
> > > > [   62.328821][ T9229] ffff888145b7b5a8
> > > > (&sb->s_type->i_mutex_key#8){++++}-{4:4}, at:
> > > > blkdev_read_iter+0x2a7/0x4e0
> > > > [   62.331102][ T9229]
> > > > [   62.331102][ T9229] but task is already holding lock:
> > > > [   62.332722][ T9229] ffff888183a6e540 (&mm->mmap_lock){++++}-{4:4=
},
> > > > at: do_procmap_query+0x39f/0x1050
> > > > [   62.334795][ T9229]
> > > > [   62.334795][ T9229] which lock already depends on the new lock.
> > > > [   62.334795][ T9229]
> > > > [   62.337072][ T9229]
> > > > [   62.337072][ T9229] the existing dependency chain (in reverse or=
der) is:
> > > > [   62.338998][ T9229]
> > > > [   62.338998][ T9229] -> #1 (&mm->mmap_lock){++++}-{4:4}:
> > > > [   62.340646][ T9229]        __might_fault+0xed/0x170
> > > > [   62.341763][ T9229]        _copy_to_iter+0x118/0x1720
> > > > [   62.342913][ T9229]        copy_page_to_iter+0x12d/0x1e0
> > > > [   62.344167][ T9229]        filemap_read+0x720/0x10a0
> > > > [   62.345298][ T9229]        blkdev_read_iter+0x2b5/0x4e0
> > > > [   62.346480][ T9229]        vfs_read+0x7f4/0xae0
> > > > [   62.347518][ T9229]        ksys_read+0x12a/0x250
> > > > [   62.348584][ T9229]        do_syscall_64+0xcb/0xf80
> > > > [   62.349707][ T9229]        entry_SYSCALL_64_after_hwframe+0x77/0=
x7f
> > > > [   62.351116][ T9229]
> > > > [   62.351116][ T9229] -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:=
4}:
> > > > [   62.353012][ T9229]        __lock_acquire+0x1509/0x26d0
> > > > [   62.354213][ T9229]        lock_acquire+0x185/0x340
> > > > [   62.355323][ T9229]        down_read+0x98/0x490
> > > > [   62.356441][ T9229]        blkdev_read_iter+0x2a7/0x4e0
> > > > [   62.357619][ T9229]        __kernel_read+0x39a/0xa90
> > > > [   62.358767][ T9229]        freader_fetch+0x1d5/0xa80
> > > > [   62.359927][ T9229]        __build_id_parse.isra.0+0xea/0x6a0
> > > > [   62.361232][ T9229]        do_procmap_query+0xd75/0x1050
> > > > [   62.362434][ T9229]        procfs_procmap_ioctl+0x7a/0xb0
> > > > [   62.363687][ T9229]        __x64_sys_ioctl+0x18e/0x210
> > > > [   62.364863][ T9229]        do_syscall_64+0xcb/0xf80
> > > > [   62.365977][ T9229]        entry_SYSCALL_64_after_hwframe+0x77/0=
x7f
> > > > [   62.367394][ T9229]
> > > > [   62.367394][ T9229] other info that might help us debug this:
> > > > [   62.367394][ T9229]
> > > > [   62.369637][ T9229]  Possible unsafe locking scenario:
> > > > [   62.369637][ T9229]
> > > > [   62.371237][ T9229]        CPU0                    CPU1
> > > > [   62.372441][ T9229]        ----                    ----
> > > > [   62.373687][ T9229]   rlock(&mm->mmap_lock);
> > > > [   62.374688][ T9229]
> > > > lock(&sb->s_type->i_mutex_key#8);
> > > > [   62.376444][ T9229]                                lock(&mm->mma=
p_lock);
> > > > [   62.377956][ T9229]   rlock(&sb->s_type->i_mutex_key#8);
> > > > [   62.379165][ T9229]
> > > > [   62.379165][ T9229]  *** DEADLOCK ***
> > > > [   62.379165][ T9229]
> > > > [   62.380952][ T9229] 1 lock held by hillf/9229:
> > > > [   62.381971][ T9229]  #0: ffff888183a6e540
> > > > (&mm->mmap_lock){++++}-{4:4}, at: do_procmap_query+0x39f/0x1050
> > > > [   62.384162][ T9229]
> > > > [   62.384162][ T9229] stack backtrace:
> > > > [   62.385458][ T9229] CPU: 3 UID: 0 PID: 9229 Comm: hillf Not tain=
ted
> > > > 6.19.0-rc6-00001-g40bea6261b2a #42 PREEMPT(full)
> > > > [   62.385471][ T9229] Hardware name: QEMU Standard PC (i440FX + PI=
IX,
> > > > 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> > > > [   62.385477][ T9229] Call Trace:
> > > > [   62.385482][ T9229]  <TASK>
> > > > [   62.385487][ T9229]  dump_stack_lvl+0x100/0x190
> > > > [   62.385505][ T9229]  print_circular_bug.cold+0x185/0x1d5
> > > > [   62.385521][ T9229]  check_noncircular+0x14a/0x170
> > > > [   62.385534][ T9229]  __lock_acquire+0x1509/0x26d0
> > > > [   62.385547][ T9229]  lock_acquire+0x185/0x340
> > > > [   62.385557][ T9229]  ? blkdev_read_iter+0x2a7/0x4e0
> > > > [   62.385569][ T9229]  ? __pfx___might_resched+0x10/0x10
> > > > [   62.385583][ T9229]  down_read+0x98/0x490
> > > > [   62.385593][ T9229]  ? blkdev_read_iter+0x2a7/0x4e0
> > > > [   62.385603][ T9229]  ? __pfx_down_read+0x10/0x10
> > > > [   62.385612][ T9229]  ? lock_acquire+0x185/0x340
> > > > [   62.385622][ T9229]  ? is_bpf_text_address+0x25/0x1a0
> > > > [   62.385634][ T9229]  blkdev_read_iter+0x2a7/0x4e0
> > > > [   62.385645][ T9229]  __kernel_read+0x39a/0xa90
> > > > [   62.385658][ T9229]  ? __pfx___kernel_read+0x10/0x10
> > > > [   62.385671][ T9229]  ? __lock_acquire+0x481/0x26d0
> > > > [   62.385683][ T9229]  freader_fetch+0x1d5/0xa80
> > > > [   62.385697][ T9229]  ? find_held_lock+0x2b/0x80
> > > > [   62.385712][ T9229]  ? __pfx_freader_fetch+0x10/0x10
> > > > [   62.385725][ T9229]  ? __asan_memset+0x27/0x50
> > > > [   62.385737][ T9229]  __build_id_parse.isra.0+0xea/0x6a0
> > > > [   62.385751][ T9229]  ? __pfx___build_id_parse.isra.0+0x10/0x10
> > > > [   62.385766][ T9229]  ? __pfx_find_vma+0x10/0x10
> > > > [   62.385774][ T9229]  ? __might_fault+0x129/0x170
> > > > [   62.385788][ T9229]  do_procmap_query+0xd75/0x1050
> > > > [   62.385798][ T9229]  ? __pfx_do_procmap_query+0x10/0x10
> > > > [   62.385807][ T9229]  ? __sanitizer_cov_trace_switch+0x53/0x90
> > > > [   62.385817][ T9229]  ? do_vfs_ioctl+0x226/0x13b0
> > > > [   62.385828][ T9229]  ? __pfx_do_vfs_ioctl+0x10/0x10
> > > > [   62.385839][ T9229]  ? putname+0xfc/0x1b0
> > > > [   62.385846][ T9229]  ? putname+0x101/0x1b0
> > > > [   62.385857][ T9229]  ? __x64_sys_openat+0x143/0x210
> > > > [   62.385867][ T9229]  procfs_procmap_ioctl+0x7a/0xb0
> > > > [   62.385877][ T9229]  ? __pfx_procfs_procmap_ioctl+0x10/0x10
> > > > [   62.385888][ T9229]  __x64_sys_ioctl+0x18e/0x210
> > > > [   62.385899][ T9229]  do_syscall_64+0xcb/0xf80
> > > > [   62.385913][ T9229]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > [   62.385923][ T9229] RIP: 0033:0x412209
> > > > [   62.385931][ T9229] Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f=
 1f
> > > > 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8=
b
> > > > 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7=
 d8
> > > > 64 89 01 48
> > > > [   62.385940][ T9229] RSP: 002b:00007fff380d5588 EFLAGS: 00000217
> > > > ORIG_RAX: 0000000000000010
> > > > [   62.385950][ T9229] RAX: ffffffffffffffda RBX: 00007fff380d56c8
> > > > RCX: 0000000000412209
> > > > [   62.385956][ T9229] RDX: 0000200000000180 RSI: 00000000c0686611
> > > > RDI: 0000000000000004
> > > > [   62.385962][ T9229] RBP: 00007fff380d55a0 R08: 0000000000000000
> > > > R09: 00007fff380d5640
> > > > [   62.385968][ T9229] R10: 0000000000000000 R11: 0000000000000217
> > > > R12: 00007fff380d56b8
> > > > [   62.385974][ T9229] R13: 0000000000000002 R14: 00000000004a0e40
> > > > R15: 0000000000000002
> > > > [   62.385982][ T9229]  </TASK>
> > > >
> > > >
> > > >
> > > > >
> > > > > > > other info that might help us debug this:
> > > > > > >
> > > > > > > Chain exists of:
> > > > > > >   &sb->s_type->i_mutex_key#8 --> &mm->mmap_lock --> vm_lock
> > > > > > >
> > > > > > >  Possible unsafe locking scenario:
> > > > > > >
> > > > > > >        CPU0                    CPU1
> > > > > > >        ----                    ----
> > > > > > >   rlock(vm_lock);
> > > > > > >                                lock(&mm->mmap_lock);
> > > > > > >                                lock(vm_lock);
> > > > > > >   rlock(&sb->s_type->i_mutex_key#8);
> > > > > > >
> > > > > > >  *** DEADLOCK ***
> > > > > > >
> > > > > > > 1 lock held by syz.0.17/6091:
> > > > > > >  #0: ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vm=
a+0x10e/0xed0 mm/mmap_lock.c:334
> > > > > > >
> > > > > > > stack backtrace:
> > > > > > > CPU: 2 UID: 0 PID: 6091 Comm: syz.0.17 Not tainted syzkaller =
#0 PREEMPT(full)
> > > > > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16=
.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > > > > > > Call Trace:
> > > > > > >  <TASK>
> > > > > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > > > > >  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
> > > > > > >  print_circular_bug+0x275/0x340 kernel/locking/lockdep.c:2043
> > > > > > >  check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
> > > > > > >  check_prev_add kernel/locking/lockdep.c:3165 [inline]
> > > > > > >  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> > > > > > >  validate_chain kernel/locking/lockdep.c:3908 [inline]
> > > > > > >  __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
> > > > > > >  lock_acquire kernel/locking/lockdep.c:5868 [inline]
> > > > > > >  lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
> > > > > > >  down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
> > > > > > >  inode_lock_shared include/linux/fs.h:1042 [inline]
> > > > > > >  blkdev_read_iter+0x19e/0x500 block/fops.c:855
> > > > > > >  __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
> > > > > > >  freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
> > > > > > >  __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
> > > > > > >  do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
> > > > > > >  procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
> > > > > > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > > > > > >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> > > > > > >  __se_sys_ioctl fs/ioctl.c:583 [inline]
> > > > > > >  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
> > > > > > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > > > > > >  do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> > > > > > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > > > > > RIP: 0033:0x7ff1a238f7c9
> > > > > > > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 8=
9 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48>=
 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > > > > > > RSP: 002b:00007ffebbe538b8 EFLAGS: 00000246 ORIG_RAX: 0000000=
000000010
> > > > > > > RAX: ffffffffffffffda RBX: 00007ff1a25e5fa0 RCX: 00007ff1a238=
f7c9
> > > > > > > RDX: 0000200000000180 RSI: 00000000c0686611 RDI: 000000000000=
0004
> > > > > > > RBP: 00007ff1a2413f91 R08: 0000000000000000 R09: 000000000000=
0000
> > > > > > > R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000=
0000
> > > > > > > R13: 00007ff1a25e5fa0 R14: 00007ff1a25e5fa0 R15: 000000000000=
0003
> > > > > > >  </TASK>

