Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 883A9C98328
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 03:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DB676B0088; Sun, 27 Sep 2026 23:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C596B008A; Sun, 27 Sep 2026 23:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3542F6B008C; Sun, 27 Sep 2026 23:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0545D6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:24:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80F3DA73A8
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:24:00 +0000 (UTC)
X-FDA: 85261727040.11.19235FC
Received: from mail-yx2-f40.google.com (mail-yx2-f40.google.com [74.125.224.168])
	by imf25.hostedemail.com (Postfix) with ESMTP id 925D8A0007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:23:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SMso9FP6;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.168 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790565838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1IQEqIjCBwZZIxvdliQr/avoVNu2GRtPs5ChSnYCfg=;
	b=KbSQZlFQXNacuzQEBVB2MufO/4aRxW1WvWwEVnZvp8zN9+i8EvDMrFcqAtf6dhoaHTauID
	oIizpmjVfMiruF/yBq4EMmtdGFpaSXq6QeX66E/xlfOCv1jx0K5LU7rAgbCSTLsJwUH1yM
	5QtzYAMoz7DyevGAnIC0K+gohdk1J8w=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790565838;
	b=F5Ad06tXy/KDSlh9OU3Byw0yL1KrJCdlzEUm2BtDVb223TcMW6fum3j0a5xlMJ0zcrUTe6
	jJpdFcBfpaJX5gAUr6XOr+spjOfyvzFiC1DXqtHuxp76bVffmdE/V0eTCXmeL7QNCAq0Wc
	zqJPqIAE8eSs0w3Pf6lByKdDEFcVRzA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SMso9FP6;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.168 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx2-f40.google.com with SMTP id 00721157ae682-8a87fe69060so15798057b3.3
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 20:23:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790565837; cv=none;
        d=google.com; s=arc-20260327;
        b=nwadgOy4Fo62MI7/INGO8nw/ZTEXwwJ+NphFNkEz+jx59WYzbnVnTvzPEK39BVDzXz
         QinIGvNOy3XsV/MQC+/LtvQ+zGW4U+xZq0bJEzrtOdjgj/YLDk8RkxEvgaMtQdUXRls3
         Nyezu19KUqxXRirWN7Cwq2DXI2LSupy3W1TGXFIv7Hd4/nTu5cEeOQYnTnOBKW7sfS6S
         ZguV6VqdYWPl6fpOqbm0MyYQA7im4FpufZbFVYdTrXzqybj+F43H3zGZFTKwAalvxtbS
         e/ntGxrwBnWrUoRjkvbdBI0dfdGBdI8BFc8uMWZm/7JyUwgN9QUfAWniGtYPxM+PLcX8
         zAgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t1IQEqIjCBwZZIxvdliQr/avoVNu2GRtPs5ChSnYCfg=;
        fh=dSpQiI+wKK/qWIxwP7t+xiaQ89Fu5ZySYQYXZgXnzQU=;
        b=MFKiajyTj1gucVChyN/EbVJWnQLVTN/lRewNRVvqBmKNVeEh7BkylZPzRXwNOol4ax
         z6ApPtG/9GxZFgLiukhxUWSVOdGbCfHDqA/b3KH0dvjkbraMt7jON0teAvUULVhbnI1H
         IVjAY+9hxpxRsFOKFe8E4aZaGAM05W/6BlJCsAwr5KAyeKMBmtWozvpddX1mB34e/jOj
         CFh/fQn9L0BDSkw9+24GjyUOnTOkUlvrtvD3/zLF1pR+hKHwDQnUFKYVGz66WgCE3ibe
         JdNQYxzeHKdKrgGRlyBuBgnWHLCaKAuirUY2MVD4hvG8CSBxiFub5V5UNaFHCXnxX90d
         le/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790565837; x=1791170637; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t1IQEqIjCBwZZIxvdliQr/avoVNu2GRtPs5ChSnYCfg=;
        b=SMso9FP6K722Lyp69IQSdo9Q/Cocgi22u6vgcRaZaL2McJMhDrQY6SSrS/wNGTtKKE
         y+2ISX5moXjZl0LdyFHMa7kt11sieb/mjXTvm7OQYoZUC8EEgcm+X+oww5Bc+Inblxaz
         HSn1MePYFxhsbmWy7/WaOUDwdTA88EviWB9XNEGX/LXFICIabsdfd6R4uUQE7rBhIchJ
         lmZY7iwB5NENFEsxjAmBPiezdbtsY8uO8WRaQUJmeqo6euM24ybSHme7tagIgHo4QPfu
         ZUFB/yQiaEteHM66vzqN+2D3DIHFLGmUa5j45GteGPFP5BM/P9FYJ/Onveyf/vfSpuXR
         aH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790565837; x=1791170637;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t1IQEqIjCBwZZIxvdliQr/avoVNu2GRtPs5ChSnYCfg=;
        b=Me0yvkZ1U/8kQEZM5UKFvNWp98IlsTogQq+pFk6hTJbrPODFRM+uAHubkMV3zA93iU
         hYQC+aoRkjZzJnhjMT/2JVEihgGC1O0aozxqoXdL6ra9iO2ZFrgvKYXW79TCJ8/baH/7
         E0qXowx3jVWH5WwyRC4IK3geTjlbHc23x0sMPmQIW/1W+bk22Q7Lh98QJBjn67c57KDS
         rLxNwrZOpf74ekcaShQXIGlDJI3C2uzLKCwViYeQNMU6JZle1eQJD2NTJYUbe823oESo
         Q5RsyWzSnF/v9noy9jG/OTr/B4UQ5SbexnqdHwxudljTl29j/bv58hfRoMJypnUCq92y
         qE5Q==
X-Forwarded-Encrypted: i=1; AKwUvBw+Awq1KlLGGtn/rfIjGdzDaQpyxn7okB4Lnk8q6wgHgOQAp1HSvKHH3EOLyHNHLtJqGaYpkbj/hg==@kvack.org
X-Gm-Message-State: AFq9FYJOQpCU3Nqd3bMTnD4O370B3zgktlM6qaevG1/DCZpjykahazWX
	/GgX/I8IOFbl0NfD6SyygtK4vQARXteqzbEluYPZJv1sBaoutvbdyGzhuST42HobO0M6isB5cg1
	tTPAoYvZXlnO7srBm6HNSsCGnD1hcwbI=
X-Gm-Gg: AYBFou2VZ+w9sYi9ExDbL8I050JDCeaW8S3K7Ux0Y5L+y7eZGtpcjhWUIyAdiwVocng
	BSW+gc1mVnqNg1Z31T9vMP9CBEnM2vYc4368JauBBVp0zHvxEVWPFYuY8zfUKxZP8VJto7Ys278
	zdF+56oobO+clsBA+VRzVTXKCoG55WxISa6qEknESN10g9uXoyXaVBsWM+usrgA+/KNY9CZiEkk
	lvu2iM216UOt0ZJPgmPVKq5QfupUn0MvW3mQrOxudJRc8ixXIGXvYeBCkSQFxH+OHiRqz+l3Jlw
	aT/jPzquPVN7MI9/DP8TtjjqO3l5b4SH9zhlL9jAQ3w81puvxuTtKKdezaX5QJqYlckzLpG5F1o
	VAv3IojsBjCNDVYCFnzpcMg==
X-Received: by 2002:a05:690c:c4e6:b0:8a8:4931:61b5 with SMTP id
 00721157ae682-8a84940aad1mr42888027b3.30.1790565837502; Sun, 27 Sep 2026
 20:23:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com>
 <arPyspcEFNkqfNyr@linux.dev> <CALOAHbDKRw9cPN_GxOYbp9u50cvr7PzPyoGPsSwoPDPAwBCGbA@mail.gmail.com>
 <arWJBBOdvLsOSdCt@linux.dev>
In-Reply-To: <arWJBBOdvLsOSdCt@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 28 Sep 2026 11:23:19 +0800
X-Gm-Features: AclHuK_1E2YfKgYgZbd4tDw3yFNtrrBUY1yd8dRRWaf2ogOVKnaFSdEC5R5Nlks
Message-ID: <CALOAHbCAtEixXTvRaF0qtGMjNwMHtYBL1eQU6GMgduRaWPGOmg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached struct_ops
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Amery Hung <ameryhung@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 925D8A0007
X-Stat-Signature: cy1ij6a8rye6gyma513zpnfczambxp9x
X-Rspam-User: 
X-HE-Tag: 1790565838-40052
X-HE-Meta: U2FsdGVkX1/Z/JvrcGHfOldExGttPSEwfwq8K8upB+mwaI0r0ZCqIzxDe5xYFHKtZb1n24pu8s++yvWdZA0EWJFfVGV6qsTwA78z63rYnTPaWbPIBWMevuz9psopTe8ntZKpmBZS4iDhDuqQ+s/jh125EcC3zv/jEmldNsGT1vz/aXs0JClY2OZfiHQiv2A6U9ajNwTAvu7wa/sqj+IZfcXz4X6LHxzJILzGXwFVe4n/F+4gng37kx/Mo9wIOlNZgRSsxVZLq6GylE9PLpx4PzgQcZVMjXnowZog8PrA30+2m9xOpfhteVoG3nV4QZQDJF3p/udJp8iitWwjE6jHg3d4dcmDs04ZFt+p32z3PXRM6dAQWkhlGh7NMCKPlWLc5aeKNjvx5Ocqd5ZcVeTK35meMo1Y7chWcyo8sCFgWjJ7ObnN5oqjuHKjDE9iA+hIt/Bl9SiTHWa8FmC2xKrL+Gfvk5bMUGwfMLcCxa3E/CXOsjf8JnyHiDHqqKHW7tKJ2N20w4xerEJJgD1HTz0uL1o81LEsJCGJH2YohmzE+ef1UINxUPlsBQafY53Mi0VySAv4eVF5+tIqQdtQzyku7//W/wJZ1/QKSYYCFqYmR131Ku/BMgLHSPkxcRYfPOrzoeWHbYxuaDydLV026Mzv6aTaMgWqYBGZGNfZmtQi86I1HQGQy8qmcax4ctm01B/6isY6u5dvwE4tuk75DSgTqS/NIJs0yHrLnR00aBok5qUWuaJxuFHLhWNgMWYZxEkkB+YRCaQ7AvVeExz5rshpNILxiHBH0cAu3U8Ocip7Fvm1EWPRA9deVoB54gj47tg7i0sxcqljS8klUtSKaiA5YLLrvOGq6W/TcO7rUuS2H3qWTdYYjJ9XDKKVfc35HOG2+8c+vpu9uueTP3jlUpnwbcZ+qXFhbMpAHaFlCiQfUXd7Wgwg0uM8VlXBUTUmj2N8cUd8xzbZwRfdsfDVM73
 cIA4l+ps
 yPg+t4Zv8r9n9y25CRgdUs8ZkMsXlnitc4Lm3GpiC2SFLaKz9eWyKgiLUE0TWHnWeEWJw3r47+JMJUMdybfKbDzWda22/Xaw9Q3uKp5rit2YYA+8Ps8zoBru0FLv7vteXYfl0dZq1PWhqhPhJLsqdoP54WkdZRaQ4/HWQJWCYl20Xyn3gDf9MuYOERS8RJzCHhCiEooG0qMTxBtKY6Zm5VrqAEqhoO8tk0IuC0/5SaoUX5xaC6hF1IYt/6ZMgDtt64sK7PgrbZP93Ibdonal6yRg+Dg4096YCR2VQOk48CVVuRDAO8hveDcv7LcFBGF3U5ypQUSaPjVXd18y6GstG/LWHTxIXTx2H1VCyH4XZyAE/YgE0CLFhNmPWokRkWvhWFGPSQJ1seyGBNFR0UQF4u0ChmX9qi7hqrbMOZ2IEvidKv3p4aU0KPhbmMekuLBg3EWr9l3QK9k6JWgF+ewNYLCSvxrQfNCxBHngmoPJ2xoBUcBZZwmYoFtbBd9iD/ExLhW+XMYrg9T0B01a8EzKLH9c9VlrUCAsjJffwYchafcXxsVxlOxFBP/v29MahQaoWlE7G8M7Vwupqx4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 4:42=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Sep 24, 2026 at 06:01:27PM +0800, Yafang Shao wrote:
> > On Wed, Sep 23, 2026 at 11:47=E2=80=AFPM Shakeel Butt <shakeel.butt@lin=
ux.dev> wrote:
> > >
> > > Hi Yafang,
> > >
> > > On Wed, Sep 23, 2026 at 09:07:40PM +0800, Yafang Shao wrote:
> > > > On Tue, Sep 22, 2026 at 3:30=E2=80=AFAM Shakeel Butt <shakeel.butt@=
linux.dev> wrote:
> > > > >
> > > > Hello Shakeel,
> > > >
> > > > On the open question of how deferred debt eventually gets paid: wou=
ld
> > > > it make sense for the policy to also notify userspace (e.g. via
> > > > ringbuf) when it defers,
> > >
> > > I think the notification through bpf programs is already possible and=
 a bpf
> > > program deciding to bypass memory.high can already do notification vi=
a ringbuf.
> > >
> > > > and have a userspace reclaimer do the reclaim
> > > > through memory.reclaim?
> > > >
> > > > I understand one of the concerns for the async worker is CPU
> > > > accounting. If the concern is that the kworker's CPU usage is not
> > > > charged to the target cgroup, the userspace reclaimer could instead=
 be
> > > > spawned with clone3(CLONE_INTO_CGROUP) so it runs inside the target
> > > > cgroup, and both its CPU and memory usage get charged there.
> > > >
> > > > One caveat: intermediate cgroups with the no-internal-process
> > > > constraint cannot take processes, so this would only work for leaf
> > > > cgroups.
> > > >
> > > > What do you think?
> > >
> > > I think all of this is possible without additional code and with this=
 series.
> > > With AI, should be very easy to prototype it. Please take a stab and =
I will look
> > > into it as well (time permitting).
> >
> > An LLM helped me quickly implement a userspace async memcg reclaimer
> > based on your series, and it seems to work quite well.
>
> That's awesome. Please do take a look at the code and provide feedback an=
d if
> you don't mind, a tested-by tag would be awesome.

For this series, feel free to add:

Tested-by: Yafang Shao <laoar.shao@gmail.com>

One nit:

Since we might extend the cgroup-ops to other subsystems, or even to
the cgroup itself, could we define a more generic CGROUP_OPS instead
of CGROUP_MEMCG_OPS, and also rename `struct bpf_memcg_ops` to `struct
bpf_cgroup_ops`? This way, we attach to the `struct cgroup` itself
rather than to a specific subsystem.

--=20
Regards
Yafang

