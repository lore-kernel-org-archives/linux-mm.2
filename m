Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D911FE7DF13
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5916B00B5; Mon,  2 Feb 2026 12:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A39E6B00CC; Mon,  2 Feb 2026 12:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AEAB6B00CD; Mon,  2 Feb 2026 12:50:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 16A196B00B5
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:50:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA178139FF8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:50:20 +0000 (UTC)
X-FDA: 84400255800.07.4CD3FDD
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id D853040006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:50:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WUBIuzE0;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770054619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqHEa2lIJ8aAbOSZMjCmc3C/32OqZQFOZt8cIZMm4X0=;
	b=0HWqub3JXds5kwV5+2og25sidAlhAxY108GPtMzPjAgzRoWtf7f17vnpN7rRMGuSAWkPtb
	bU07voULwsIcaKPoIdFjsmHmcg9aEPh3VC6HwmGoSnKyy7qYeA+1VTepm1VQyWqZl5O0p9
	sWalYlr0YXb0OiirWUpPatNjqL2Q3zY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WUBIuzE0;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770054619; a=rsa-sha256;
	cv=pass;
	b=7mrnIpabX8xwMV8ZuGng+XmqcPFsjAzpYG1TgmOkpv/fzt7NsoaL/KCp33EjzKyC/Tv2u9
	DQyOZhJBxDkU7JAS77J/mprf5ollU4ZFMhpz+BjFtUSskhAVoLvOkCuRyBkFq6x4W6HqBB
	bs+P9/0NAUl6ZMLxJr5gR/5nYs8u7o8=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4801ea9bafdso20301485e9.3
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 09:50:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770054617; cv=none;
        d=google.com; s=arc-20240605;
        b=Lm+9N6hKgf3taD4S7S4G1LTisi6KxNMHEAPRj6oDxjVygC9aZ7s4gxLQO76eLdoaVv
         vKAp3dvrIXuYJzo5nLAtC68Y/qiKkAkqgC2NfnghZvGSORCxuCoYEdxIzHLLQGbj8pkG
         sqUuso0SOsd9PF83KQi+dCps9/gnkPwOtZWaSRArlMQN2ZV69/dvS0fQRasKy8KD/wwd
         smjr1MIYQgSRyaMABDVsthkwtttK5hs4lHLiP2FpN5ONw1V/FnO9ivb5avxNqTdQb2i+
         Q9ZVyLsj2R1KiqAlz23ib6c2dy9vK0eQ2jg0Jy3xM/vsL07nYoaAdXorT3VEIX5pGhlg
         HGDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SqHEa2lIJ8aAbOSZMjCmc3C/32OqZQFOZt8cIZMm4X0=;
        fh=E+M/FZqN875+mMM+QcjcVLYmCjVFMMtcPyta/Vo9O9A=;
        b=JHkNeTHEdFxTKZIbkkLnAFyYL8VZ8mGF05KfuFzptn/SSYkxo6kv5cd6cYrjt5H32h
         vURtYvpCjX/bCsnH/pQtv3w8M7tfiP4bkP4Ffwy0oRTKy/a6PMrkPqDdB9mn/+aqEJjN
         HD4Cqt2NuN8y3ZptQ81qp/0UtoEMENwHJJ3XRTvREo9ujWDnCaSjqkjZF7U45jBBXkPt
         74tzX1e4wEuIJ3peK5ceiSzCsGm2ZsfSrKpMAEmeGMld/BXgXPw2Vh+H9jTjrTYscKx8
         Z83OOFBY6DJ0ayM050fzxRwU/Psb6QA+styiYOpUKFTCP5rOG6SycReZDXq20XSYWEzS
         iKeg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770054617; x=1770659417; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqHEa2lIJ8aAbOSZMjCmc3C/32OqZQFOZt8cIZMm4X0=;
        b=WUBIuzE0f4KRJVsXu6hO8d1CG9nLeIhTSzHpgiQzAxaScTUtU3YT4nlxUpth6AVMWv
         m/8kXxSBLjo1KMKM3J3qAgba4H22jX/cjPq0So+F/BwpUWQDHgwxf5ttIWXO2b+b430G
         aXURzXUlKA+jqmoD6irrmkzLfiCUnCogfhab27HHr7LquuYe3S+waTdoKBn1ILoZ8j/p
         Q3GFMPV1JJiSlsbWS3lLirGvHsPF82x2xiGiH/FWyFW83OwXulBT01YOLh4P1k/Udx/f
         DrE31P+UFJ9AMl9kIKhl1EE3YJrybmvcVNlc9RsXQGLDcgtwtjIAVPUmauvue+5BiDvW
         Hypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770054617; x=1770659417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SqHEa2lIJ8aAbOSZMjCmc3C/32OqZQFOZt8cIZMm4X0=;
        b=R8XxxGfLJuORwRFKe2O061O6rE9OhXQn4udHtc0s/2esjOyZMukIUkH19GxObOTGPm
         QNBTKA4ps+co07Jer1vR+PVnsdo3z7jGgh7NIKy5HzNjWRkm9ujt6ZAV+m3vqhC3F4Uz
         hq1VTwbBt6FAEGHuxBWrpEZprMVdFqN1w9raGTXo7LLRSMhUBrw33QYrutaRNmHwSxky
         gDC91gVq213JlarsiK1KCpgXFe+4pUvi3+51HFV/O3sOjEEgCQr1N01xoy9PuV3G4TeA
         MxkcFf28THfuhQHjC44rVNBkd3ajuh9t9s+sTIDmZE4xy1/OGMuGKpTNIqxwYhz/X/bA
         qDyg==
X-Forwarded-Encrypted: i=1; AJvYcCXJ9ky3J9iLiuuYky1JRBHY5ypI0C5BoQ/v4uGGtSHJXe8buD+1sxLiYQv/MlnO4yx/MAcZnPbf2g==@kvack.org
X-Gm-Message-State: AOJu0Yz/UacxLHopnvSOuG6OMyCKQdXvx3VoDsmrSMI2MV5llEuMtkYv
	4x7IZFQoznDSNMipXDPR5y7Sd3M/TCjqhQx+Q+pkPRapwih9/zK59aJxLNLVxIQ81fQ80rBorKn
	G5elGpn9o1FgJA8JJm3Gz57Ay8xF4byI=
X-Gm-Gg: AZuq6aK+FD3G+CdIlWRNWn77r+b6/QuwNHyvFYuMN97oZQyWJyN81kLhCcm5fibIMpL
	+zi8tBtivU7KgJATBWO1BRA/79Enc1uqn8xem1Rws+noL+dN9x5Nlz0zd8m5x0SrfTy2v1XPfiS
	DgUJS8T8V32C8vHMSvnGv/PAJxaZ32fbyp8upWy70iUb8sUg/HwU+K1Qvigs/PFMBWLrnEBErXf
	UMkgdldgSQPN8mURLeVvlKkvcLnZHhBQrvZmBavnDLyWCGZ5hxvpEokMgxxpV2FdjA0hqHhsAtd
	XyO7WKKoa+08UvtNE++Zas+F7LKmO2G99V029x5kKx47TL4CV6XIkfTgZiu6LD0eWdMhRSZQ
X-Received: by 2002:a05:600c:628d:b0:480:1c75:407c with SMTP id
 5b1f17b1804b1-482db4577f3mr151208365e9.2.1770054616976; Mon, 02 Feb 2026
 09:50:16 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <aXh_LpTzDhvv20uB@tiehlicka> <7ia44io6kbwj.fsf@castle.c.googlers.com>
 <aXnDdkYmtipGwSjK@tiehlicka> <CAADnVQ+ghTc5FtJCjm4ya3y3xVpSuJe-7ctdT-thowqWguc1pA@mail.gmail.com>
 <aYAZT-ZZSKdiChfd@google.com>
In-Reply-To: <aYAZT-ZZSKdiChfd@google.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 2 Feb 2026 09:50:05 -0800
X-Gm-Features: AZwV_QgWPO6tVqI8Q3ClAr2Pk2pa3uETsu08TgeuX6MtqSwq_qFHAQc7YZ591MI
Message-ID: <CAADnVQL3+huSAwoYRexoSDaLRK+nEsY6UUnVSmhk_sGYUYsO7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/17] mm: BPF OOM
To: Matt Bobrowski <mattbobrowski@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, bpf <bpf@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Josh Don <joshdon@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D853040006
X-Stat-Signature: qtakkkokq9aayhxpi6a859ok56ggy5x3
X-Rspam-User: 
X-HE-Tag: 1770054618-645979
X-HE-Meta: U2FsdGVkX18lg4RWC2a9jpOuhEdBlA6vXbED2akrnMEZ4MAIs0MLZPvXT7C94I43jfphCpOh2wNxlyDZ+WLdII64F4c/Nu1sXXb2MzVJ4LION1B2P15SJfIQleHk0StSB1M1QO6nFtDDM/lsPUT3YbYhZcN1RFB1tbttedou8YuLHbj8O9KulPznwSl/y6177aUW7HIWfIZ4jCp/aJQcWcSVdSO60Ai88Bs3c7dhG/gJf+a9xJJ0xbJxMN7Mf2y8tXVWFsXlEIJAqercFTTA2f2V1WVBR5WeA/S1YKCU5tdNzBBqclKgksTmNlKePGE38eZ5olnRZMIqhN1ohR0KjMNxoltHlReu2nqegAmjfQkRMuVnmP2Tq0FYojew2aBPUMfGHrkx4hmDFLNYWmX2B7ztpeP9XPDfnttWhPUlylVmmMBNWAP8fmEVwYdDFGuJQf+7iGvITzNaHtqWF9Yf+XPNk97/L9qhYihGtUqrR+L8HaLW1XcPAYNuakyxD1en+jUaqRY6bG1rP/FVeKTaLqcRmVCxN38BglkBHnJKn10M7Wy831kJmGGSbIpwOyFr8r3FMkKdaTPWbW1sAyolCxLBz2jxE62FbNV7VU8kuUzbCQFRDa2aGSe1DCaXAGkSg14fyiB3YJIFFHmQLdecK5bbVEnGVyAr/fIQRqZUpttthIiM1M2HojmPiK7Vb01mNjpiFbxnNe57xGFy75bMbVcGz9yYcIpg8MOuwbbwT7b4hzeb8QBY7/JY68AhMI9nfaxu6nnO5/bR0IEGTNNN7L+3sUmS9deP2eJMXb++Tvomgx3mCQqZDDiSJRnn1fd6dkQCZ0JiOQWKQ9e1omvELk3PSARsib6G89OzMsvDPF1NHGaPFGiA6C1ajMm9F5o/EjLYtizFiX1sc7g1blw9YB6Ww4dYoFu3eRHDVi/aMOddtAqBdYjwHrSvCzt4yD1bGx6wmLA5clslWVDcpXE
 GnnWnDqr
 xMTCEDumqOMn/mFtD03GbviP0gApLc6LSzEuprB1n4RGoTBcGa9mdd2iRc4uDyx1s51XTeWqPsc1hhcboOqPikeNwfnH41IQlcyB41QkNMk/MlHezC1YIYGnFIO/aIS+hRDfg1I7rmr4s3SMAUDdypp7HdWIiEA6+VQPl7AEWD8QcopsvaXYZOv9mMpDw9CvzxFr3/Jh3H149fTZHuLJWxjKmWuAu6HOgi4s5lP9jNMqF+wWmiclFB5+ZmBqQvx7DTEt14Q0ekzE+ATX+qmZ+PY8XSVmkaqM9DwAaPc4tGsoPGQrGqAZUJaVnY30zpXKdzyTFM2hKFCWFXAgZnzzaIkHe+cVVbsklvr+QcQJkrnwA310Ka6g2AwCD8gelhEwkuQR5HILlgCKicIDma7f8/RiKs0849DrLnQktUSy+cZehI4SQQ4W/UCkhwfS7+pHWTlrgSD82aXouBfwEXgeCgBLx1zy5GtYt1FTNFa0rRMIVd4PiFCxQ+F5g6gg21PG9Kso0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 1, 2026 at 7:26=E2=80=AFPM Matt Bobrowski <mattbobrowski@google=
.com> wrote:
>
> On Wed, Jan 28, 2026 at 08:59:34AM -0800, Alexei Starovoitov wrote:
> > On Wed, Jan 28, 2026 at 12:06=E2=80=AFAM Michal Hocko <mhocko@suse.com>=
 wrote:
> > >
> > >
> > > > Another viable idea (also suggested by Andrew Morton) is to develop
> > > > a production ready memcg-aware OOM killer in BPF, put the source co=
de
> > > > into the kernel tree and make it loadable by default (obviously und=
er a
> > > > config option). Myself or one of my colleagues will try to explore =
it a
> > > > bit later: the tricky part is this by-default loading because there=
 are
> > > > no existing precedents.
> > >
> > > It certainly makes sense to have trusted implementation of a commonly
> > > requested oom policy that we couldn't implement due to specific natur=
e
> > > that doesn't really apply to many users. And have that in the tree. I=
 am
> > > not thrilled about auto-loading because this could be easily done by =
a
> > > simple tooling.
> >
> > Production ready bpf-oom program(s) must be part of this set.
> > We've seen enough attempts to add bpf st_ops in various parts of
> > the kernel without providing realistic bpf progs that will drive
> > those hooks. It's great to have flexibility and people need
> > to have a freedom to develop their own bpf-oom policy, but
> > the author of the patch set who's advocating for the new
> > bpf hooks must provide their real production progs and
> > share their real use case with the community.
> > It's not cool to hide it.
> > In that sense enabling auto-loading without requiring an end user
> > to install the toolchain and build bpf programs/rust/whatnot
> > is necessary too.
> > bpf-oom can be a self contained part of vmlinux binary.
> > We already have a mechanism to do that.
> > This way the end user doesn't need to be a bpf expert, doesn't need
> > to install clang, build the tools, etc.
> > They can just enable fancy new bpf-oom policy and see whether
> > it's helping their apps or not while knowing nothing about bpf.
>
> For the auto-loading capability you speak of here, I'm currently
> interpreting it as being some form of conceptually similar extension
> to the BPF preload functionality. Have I understood this correctly? If
> so, I feel as though something like this would be a completely
> independent stream of work, orthogonal to this BPF OOM feature, right?
> Or, is that you'd like this new auto-loading capability completed as a
> hard prerequisite before pulling in the BPF OOM feature?

It's not a hard prerequisite, but it has to be thought through.
bpf side is ready today. bpf preload is an example of it.
The oom side needs to design an interface to do it.
sysctl to enable builtin bpf-oom policy is probably too rigid.
Maybe a file in cgroupfs? Writing a name of bpf-oom policy would
trigger load and attach to that cgroup.
Or you can plug it exactly like bpf preload:
when bpffs is mounted all builtin bpf progs get loaded and create
".debug" files in bpffs.

I recall we discussed an ability to create files in bpffs from
tracepoints. This way bpffs can replicate cgroupfs directory
structure without user space involvement. New cgroup -> new directory
in cgroupfs -> tracepoint -> bpf prog -> new directory in bpffs
-> create "enable_bpf_oom.debug" file in there.
Writing to that file we trigger bpf prog that will attach bpf-oom
prog to that cgroup.
Could be any combination of the above or something else,
but needs to be designed and agreed upon.
Otherwise, I'm afraid, we will have bpf-oom progs in selftests
and users who want to experiment with it would need kernel source
code, clang, etc to try it. We need to lower the barrier to use it.

