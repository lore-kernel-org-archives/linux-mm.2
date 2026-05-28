Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F30CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7871F6B0092; Thu, 28 May 2026 05:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F6B6B0093; Thu, 28 May 2026 05:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674B26B0096; Thu, 28 May 2026 05:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5618C6B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:36:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F306EC27FC
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:36:46 +0000 (UTC)
X-FDA: 84816324012.13.9EE9739
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id E1CEF40008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:36:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P3IMthxj;
	spf=pass (imf07.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779961005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okJAHKr2FRoEu7Zvqgqg5rnovsf6ah+xiiUgmbVNkGk=;
	b=EvB15m8aIyhzr+lc6ghhZ5KBrymi0P0fHGDOqbLD5E+C8mQ1gjG1SworItBG1dvXjPifdU
	6wvEpo54xJC5Yu3+xRksV0DMrNNise1Szt+PmsjfJpVko7oqKspBPl+scy0hnIxgLTIwwe
	nhkvZEjz2budn2cGCmLcQ+gkY9j2JUI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P3IMthxj;
	spf=pass (imf07.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779961005; a=rsa-sha256;
	cv=pass;
	b=1/YIkcJ/dll+AIMukdrIBrbxGvbbwjwuCblXc9vhpbO2lM1shcm2yF7u/M5MTOgQJhDgCr
	yosjyZP8YttW38AzJ3D+magkmObviXZSc7K9gFSbN6xkRuA6iXJ12/diIwm58BjKLBYEvj
	4EVDpISNEH/xUQ1eevSxGcy02C7TDcU=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39397d637e6so16272381fa.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 02:36:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779961003; cv=none;
        d=google.com; s=arc-20240605;
        b=YrGg3bE/ifpAKP5yBh9BKCnZ5Oe4x9ywnmGBO1Jx5Z82vg7HlaUFlsfZzVR3rW4MFp
         Y1i0OE0Svyd6h+QY09Qyd7NRc9B624dsvPkWw2QpoPP/oi9zYTxsTmZFG7i5txVvdZK/
         zcUsgE2cghYFORU4MgOviyV0enf1a/eqWIQwijX0rzfh2a+4YWJMOUTh89M2Px2mhEp6
         Nm6b+9E/K1BR9TfmHkRxAHKksajNWXmdsTNX7T3TVW6rnGtMBTPyFpFbkvxDMAo66AAU
         q8CNgQcxVxFydjTYUI3jW2hjMPlVfhvrFYpAtdbXssIFCfiusAXTw4qzIlg4L5VWLv4u
         3Mng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=okJAHKr2FRoEu7Zvqgqg5rnovsf6ah+xiiUgmbVNkGk=;
        fh=Pg/Sbg8G9FcG5RR1FxUdTFZuD68A6nVphXyjtbN+ww4=;
        b=LBfaCS1Lf+GTfHRQXacRE8bX50cLno7R+o5koh8bdNYsZ/HPMPU9tGaqrogcCvdD93
         EHGQfUfI95umwfH3uf7ZLWw+OIYVu1e9GbpzgAKS2GPKt1ZXdzoFpxUz7ANFzMPV3CLD
         lVMR1f9kZyD947n3hPzdEoJuuoDR/WtW12R12j9B7Ljp350+R50WTr8tzuzxyMei0HXV
         Q+iksIV4rG8bXzLnqE3IXIi7MvkDA9hgGiFYsjm4h4yfbJz+Dg9q3JPYSjJ+6eHNvWa4
         NFL1RW+jRYGNukds3dExUPGb/1NSR/aMb9wclv9tRoPoHGy2tyvFiPgsnYqxLlIu1Bmw
         Z47g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779961003; x=1780565803; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okJAHKr2FRoEu7Zvqgqg5rnovsf6ah+xiiUgmbVNkGk=;
        b=P3IMthxjAFckGyk78IvG14m/WDro7hmKd9z/rIkW3dhSqzCaMx6vY8gMZ2G8do6uK9
         t3kESBjesgma1aFWY9V0Yx2QHjAOE8k59tCwx8bImEgd//FTuhUOBnlsdYmi8oEsec5o
         yAshbbGEOHRWZrYaSeyovcC6BqztwKtDAEWlb4j4rZ7zizxwSl4/GpZZLk1VTnuqqqu8
         V+ZrwbGDX9HknpOpdsEiyC6XGeQWJSNyvxmElL0F/PdSbdZ0SZ/i6rwN82lyKQEtNgfC
         IK4IBbzMQcscP7/DHBZXpvN4ZOueXf3PivCiOUSWLqrIVi15s7UqXqMdsPruItYS6Rhs
         USLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779961003; x=1780565803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=okJAHKr2FRoEu7Zvqgqg5rnovsf6ah+xiiUgmbVNkGk=;
        b=R/vgF7GAKSWurmxCIvjQ4sMG0wBveRNzb2+cro2/lkDZhv1+0WTT8eqeUu0Ut5J4cv
         inMAmHosnChBa/IsTUuoRAkSjO/2OS1stwejx/RMYfyJLSdZp1/hCsMrK/7SDcXm7edw
         UdD3An77sxbZ5K6wPITmnZlbv9AXf4DnmtL/LTGfZzMOSbPIqZcdFeP4LwYXKu+Dq0VA
         ws8vikhpMlLEP62LYj1Keb5+C3W08TXTWA96HL9SLkJwbd1QRbKkL3rbwobR3Ks0wyTG
         XkrF2HC8I6RAF3gxvPsqnEOMgyH0CXoHPIMNi9WTq5lSzQ6gBwIRsVEPqM3sKZZCvVWx
         yQsg==
X-Forwarded-Encrypted: i=1; AFNElJ8rWFT9LbFmSl9IobC8dsDcsHpbu8qSEFfHksIXNM1sCJAASqttJLR1qLCnyacOLCVtEFeEmnJ0QQ==@kvack.org
X-Gm-Message-State: AOJu0YxrBsWFzncDYOv7js7XXaSOd8A3iZqAbUSnDufP2pXlRftu/c1K
	SU5iiwcfKdOKZSTP0jlPWbjCXrxy5oSLmEzBHLUTWCBQbY4rd97WWLwCHJauBlGJalUvsJctPCF
	mjNZeDmSANle9PBdPgn+St5uJ6hbF5Qk=
X-Gm-Gg: Acq92OHwZqVN3MVUtGEclw6mIEbK5hmgj0n1SK64x92igH7zbQBXfF/Ey+WFwiAI9Sn
	xMzgnwXyPGkFNp0Wpt98q55GCpnHqltYLSfFm5n78+xL3FkYAIVQzHa+81zt6Yts/NvR/l31oLl
	gjwHaGlJEt3Hv0jNzxrVfuKp1/Xe1jbxZ8tbaF+4B5VyvhA3VPxVvX1v+GnjIfFclmwil9WGaty
	/5rxMc4y38hT81F6i2ilsXBXB6DbKkUpk+xA/3S65inO2nXy+uHNzqH5qhW1LSHqJZthE3u1Qvs
	35h21a46viVmXXxwLCkpXIUVxFrGcw==
X-Received: by 2002:a05:651c:1073:b0:393:a31a:ab30 with SMTP id
 38308e7fff4ca-3963a90ec06mr2931781fa.0.1779961002622; Thu, 28 May 2026
 02:36:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260527085622.1298437-1-zhaoyang.huang@unisoc.com> <CAGsJ_4zVu=XooHPzOVtNRV8iV0CEKM0rBwqUBBxfoxiZS-g4-g@mail.gmail.com>
In-Reply-To: <CAGsJ_4zVu=XooHPzOVtNRV8iV0CEKM0rBwqUBBxfoxiZS-g4-g@mail.gmail.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 28 May 2026 17:36:29 +0800
X-Gm-Features: AVHnY4LFpA-tRWvhZS8vTWzBTMM2MDik_pb4I_EbYXeQWRhTu-IirDcbtzqEWVk
Message-ID: <CAGWkznGmDtr9-PaH2+2kbrpe-YZ7w70HpzyH2fzE5u-3MZ+ouQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: improve positive_ctrl_err for low refault samples
To: Barry Song <baohua@kernel.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eqmztqxk7c4eiakstpjzx35gn318tqt7
X-Rspamd-Queue-Id: E1CEF40008
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779961004-876787
X-HE-Meta: U2FsdGVkX19pl4J5UwKpJtO3x6LJpscWpa+JpCuiA0YFB3jL7owinLST/r6yINZ/5pDvmAPIswtoZwrhtFi6eOO/PY2NuCBD4B5mRLLZR5Sc2+/g8gn3KPolGBKGM/Vtxzktm5/+MTDsZRfGFHdxTQg3rAt4IYmy616vEXqARGa4DsGqJEQ+k+4mr3dOU6lUsQXeKuGc1DFvdij8BDoT3A49ugboheWYY3M+5xPpxYG6nE+74eym//WVeBj1n5uzyHzMD6sVcny+FFvCeEY4wXqpYh1r0uLc1Zn4EB0mKpajGNolm5NrIjztP+wXWhlu1wMEnUlvL1W13Lu2SdhxNfTJ3xT4bIJ/93d667a3o0Tv9537Qz6tuxiFzEMnqW/B2uDW7NCvBG6arrW92O45Hu+arYA4sShWF4LummySy8NUpA4fWUeidbXhXroPiNHmia0ADkI1ELJj/QtWx3cEvyWai8HXaCjjrEB4s5ZzmLs5PfZXeyXveypyiY/qVvTCgGyZb97UhkQDj6PGHKMoKLWfbxb2Azp2QO8oM6UzsOMxE2BUfpXsaWpgTn/JgrivZ95+l8Y7vtj0FUE+uTnclOg2nE4Jvw3obA79xgrLz1yNMA1IiiKWMEE+sjQCSdcAarJO7ej/D8WeYctItTs0mwS6toeWLHy/Fm2zGxjMpvjbJYwtC1MlpR52wtiAGGZxcUuEOPryrWkvPedrcAzrwKQBTGalgu3vsqK0Ho6HIxishVSXlMbwMVrAy4S5zLnMdKBIAjb7JpmBelkdj/oKj912KTrlZrWFs8NzboErOyRBc5tBnwtqo3BYLxTcIaEHkfxiMAm1/g4G+UUnY4edd5WB3oD1yyPA4O9SbHum4pm03Ba81NjSSLvwa/7qQumwPYe3S1i6nGSFK0HWHnplWl+2Zs7nhjqrQrC6QBS5EyIb93+eepqHX/balzaZQ2ojov9qRtxYnObTiPslzVw
 mgTvTqec
 3C0JNE2BeSNZsr1HDn5TxnyTnsPNdq7nQD600DHKdQICyCC15Qfjn0iixH+f0iWAAJbygAabxM9ZtTQslYWqK9v9AXggQcCYsvvZmjHIktUaWOTN3i77dPq2BauE1tmIKakjo2X4deUlq847L5HVMlpLsHmowa0UpBIoVRYrKTdUrVZuC6uZnarDnVo5AAGWQRCdyheHThS+R/bzzJAKQaRqH93GkblZF9sTfJ3CnrrKCpvvs5YQkxm3KfHcXuEaTaqPGO0v0MV9o6ZOOS82UQvVDhtR0WDKeZNHzKYeukoUfc9UMlb3PHwGEzfpzP4E731Ztz+E5/s3O3Km+fR+WBdFR7VJHr9ymwCryOAUb6DOREusiS+qVQEiS+cKFpLnS/EB/+sjn4bOcnacL7meVvIfB0At2AEdYkBqLov9qa08edc1EWuZd73drtTZpRSGZTosvxZTgotzqB6lPORQnCiMd3a76/jrmK2v0UfNK4f4p8EUaQkh3LlECd3n/icyJ3kRnCGVIMjEf3OVWuDYbu42pww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 5:15=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, May 27, 2026 at 4:57=E2=80=AFPM zhaoyang.huang
> <zhaoyang.huang@unisoc.com> wrote:
> >
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > The memory.stat under per-pid memcg & MGLRU[1] observed in android
> > system which means current type selection by judging the refault rate
> > almost failed since file page's refault count remains 0 which will
> > shortcut to file by 'pv->refaulted < MIN_LRU_BATCH'. The reason could b=
e
> > both of small lruvec size and bypass of the file refault count when it
> > refaulted in another memcg.
> > Refine the MGLRU PID comparison when lruvecs lack enough refault
> > statistics, using gain-aware fallbacks which is simply respect the
> > swappiness and historical integral value without affecting the usual
> > refault-rate path under sustained reclaim pressure.
> >
> > [1]
> > /sys/fs/cgroup/apps/uid_10123/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1123 steal_direct=3D32=
 pgactive=3D58
> > /sys/fs/cgroup/apps/uid_10136/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2491 steal_direct=3D64=
 pgactive=3D48
> > /sys/fs/cgroup/apps/uid_10237/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1355 steal_direct=3D0 =
pgactive=3D1
> > /sys/fs/cgroup/system/uid_1002/memory.stat: refault_anon=3D3 active_ano=
n=3D1 refault_file=3D0 active_file=3D0 steal_kswapd=3D1162 steal_direct=3D4=
 pgactive=3D3987
> > /sys/fs/cgroup/system/uid_1027/memory.stat: refault_anon=3D1 active_ano=
n=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1157 steal_direct=3D1=
4 pgactive=3D1517
> > /sys/fs/cgroup/system/uid_1037/memory.stat: refault_anon=3D0 active_ano=
n=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1461 steal_direct=3D0=
 pgactive=3D247
> > /sys/fs/cgroup/system/uid_1046/pid_1251/memory.stat: refault_anon=3D0 a=
ctive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1643 steal_d=
irect=3D18 pgactive=3D2914
> > /sys/fs/cgroup/system/uid_1047/pid_724/memory.stat: refault_anon=3D0 ac=
tive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D8924 steal_di=
rect=3D449 pgactive=3D3753
> > /sys/fs/cgroup/system/uid_1047/pid_789/memory.stat: refault_anon=3D0 ac=
tive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D3864 steal_di=
rect=3D157 pgactive=3D3062
> > /sys/fs/cgroup/apps/uid_10090/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1285 steal_direct=3D32=
 pgactive=3D36
> > /sys/fs/cgroup/apps/uid_10123/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1126 steal_direct=3D32=
 pgactive=3D70
> > /sys/fs/cgroup/apps/uid_10136/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2474 steal_direct=3D69=
 pgactive=3D52
> > /sys/fs/cgroup/apps/uid_10175/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D3264 steal_direct=3D10=
 pgactive=3D861
> > /sys/fs/cgroup/apps/uid_10211/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1447 steal_direct=3D32=
 pgactive=3D21
> > /sys/fs/cgroup/apps/uid_10237/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1354 steal_direct=3D0 =
pgactive=3D2
> > /sys/fs/cgroup/system/uid_1000/pid_471/memory.stat: refault_anon=3D0 ac=
tive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1296 steal_di=
rect=3D4 pgactive=3D65
> > /sys/fs/cgroup/system/uid_1002/memory.stat: refault_anon=3D18 active_an=
on=3D3 refault_file=3D0 active_file=3D0 steal_kswapd=3D1286 steal_direct=3D=
4 pgactive=3D3979
> > /sys/fs/cgroup/system/uid_1037/memory.stat: refault_anon=3D0 active_ano=
n=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1462 steal_direct=3D0=
 pgactive=3D246
> > /sys/fs/cgroup/system/uid_1041/memory.stat: refault_anon=3D17 active_an=
on=3D5 refault_file=3D0 active_file=3D0 steal_kswapd=3D4429 steal_direct=3D=
30 pgactive=3D5239
> > /sys/fs/cgroup/system/uid_1041/pid_820/memory.stat: refault_anon=3D12 a=
ctive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2441 steal_d=
irect=3D17 pgactive=3D2034
> > /sys/fs/cgroup/system/uid_1041/pid_839/memory.stat: refault_anon=3D5 ac=
tive_anon=3D5 refault_file=3D0 active_file=3D0 steal_kswapd=3D1357 steal_di=
rect=3D10 pgactive=3D2055
> > /sys/fs/cgroup/system/uid_1047/pid_1166/memory.stat: refault_anon=3D0 a=
ctive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1577 steal_d=
irect=3D70 pgactive=3D1130
> > /sys/fs/cgroup/system/uid_1047/pid_732/memory.stat: refault_anon=3D0 ac=
tive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D7661 steal_di=
rect=3D115 pgactive=3D3681
> > /sys/fs/cgroup/system/uid_1047/pid_799/memory.stat: refault_anon=3D0 ac=
tive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2847 steal_di=
rect=3D62 pgactive=3D3573
> > /sys/fs/cgroup/apps/uid_10129/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1153 steal_direct=3D18=
 pgactive=3D42
> > /sys/fs/cgroup/apps/uid_10136/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2336 steal_direct=3D21=
0 pgactive=3D49
> > /sys/fs/cgroup/apps/uid_10165/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1491 steal_direct=3D43=
 pgactive=3D525
> > /sys/fs/cgroup/apps/uid_10175/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2229 steal_direct=3D10=
8 pgactive=3D863
> > /sys/fs/cgroup/apps/uid_10211/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1299 steal_direct=3D16=
3 pgactive=3D23
> > /sys/fs/cgroup/apps/uid_10237/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1323 steal_direct=3D32=
 pgactive=3D2
> > /sys/fs/cgroup/system/uid_0/pid_1203/memory.stat: refault_anon=3D0 acti=
ve_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2927 steal_dire=
ct=3D12 pgactive=3D252
> > /sys/fs/cgroup/system/uid_1037/memory.stat: refault_anon=3D0 active_ano=
n=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1359 steal_direct=3D3=
4 pgactive=3D253
> > /sys/fs/cgroup/system/uid_1047/memory.stat: refault_anon=3D0 active_ano=
n=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D4269 steal_direct=3D5=
5 pgactive=3D6308
> > /sys/fs/cgroup/system/uid_1047/pid_721/memory.stat: refault_anon=3D0 ac=
tive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2745 steal_di=
rect=3D44 pgactive=3D2761
>
> Yes.
>
> I agree that the current positive_ctrl_err() has some issues
> that could be improved. But could you describe the user-visible
> behavior affected by your patch? For example, does it improve
> swappiness behavior? Does it eliminate the over-protection of
> anon memory?
This RFC mainly aims at Sashiko's comment. The main concerned static
value within /proc/meminfo changed as below while the ratio of
pgscan_file/pgscan_anon during monkey test has no change

before:
Active(anon):     759900 kB
Inactive(anon):   202540 kB
SwapTotal:       6291452 kB
SwapFree:        6116352 kB

after:
Active(anon):     360536 kB
Inactive(anon):   308368 kB
SwapTotal:       6291452 kB
SwapFree:        5866340 kB

>
> >
> > Assisted-by: Cursor:GPT-5.x
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > ---
> >  mm/vmscan.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 52 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index bd1b1aa12581..5fecfaa392d8 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3179,14 +3179,62 @@ static void reset_ctrl_pos(struct lruvec *lruve=
c, int type, bool carryover)
> >         }
> >  }
> >
> > +/*
> > + * positive_ctrl_err() - return true if SP is hotter than PV
> > + *
> > + * Drives MGLRU type and tier selection in get_type_to_scan() and
> > + * get_tier_idx(). A true return means the setpoint is hotter than the=
 process
> > + * variable and reclaim should favor the other type or a higher tier.
> > + *
> > + * With reliable refault statistics on both sides, compare refault rat=
es. That
> > + * path dominates on large lruvecs under sustained memory pressure, in=
cluding
> > + * the node-level lruvec when memcg is disabled.
> > + *
> > + * Small memcg leaf lruvecs often lack reliable refault statistics: fe=
w pages,
> > + * infrequent reclaim, and counters reset on generation advance. Treat=
ing a
> > + * low PV refault count as unconditional evidence that SP is hotter ig=
nores
> > + * swappiness and tier gain and confuses "no samples yet" with "cold".=
 Using
> > + * the rate comparison when only SP lacks samples skews the ratio. The
> > + * low-sample paths below apply gain-aware fallbacks and apply default=
ing to SP
> > + * is hotter when neither side has eviction history.
> > + */
>
> I assume the new algorithm and the above comment were generated
> by AI. Could you rephrase them in more human-understandable
> language?
The code is originally by myself and updated by AI. The main idea is
ignoring the PID things(refault rate) when no enoufh refault count
generated.
>
> >  static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv=
)
> >  {
> > +       unsigned long pv_ref =3D pv->refaulted;
> > +       /* Used by the rate comparison (SP only) and the total fallback=
 (both). */
> > +       unsigned long sp_total =3D sp->total + MIN_LRU_BATCH;
> > +       unsigned long pv_total =3D pv->total + MIN_LRU_BATCH;
> > +
> > +       /* Both sides: compare refault rates. */
> > +       if (sp->refaulted >=3D MIN_LRU_BATCH && pv->refaulted >=3D MIN_=
LRU_BATCH)
> > +               goto compare_rates;
> > +
> > +       /*
> > +        * SP only: PV refault count is not statistically meaningful; t=
reat PV
> > +        * refaults as zero and use the rate comparison (yields SP hott=
er).
> > +        */
> > +       if (sp->refaulted >=3D MIN_LRU_BATCH) {
> > +               pv_ref =3D 0;
> > +               goto compare_rates;
> > +       }
> > +
> > +       /* PV only: trust PV refault signal; SP is not hotter. */
> > +       if (pv->refaulted >=3D MIN_LRU_BATCH)
> > +               return false;
> > +
> > +       /* Neither side has eviction history, pv is colder */
> > +       if (!sp->total && !pv->total)
> > +               return true;
> > +
> > +       /* Neither side has enough refaults: compare gain-weighted tota=
ls. */
> > +       return sp->gain * pv_total <=3D pv->gain * sp_total;
> > +
> > +compare_rates:
> >         /*
> > -        * Return true if the PV has a limited number of refaults or a =
lower
> > -        * refaulted/total than the SP.
> > +        * Rate comparison with margin on SP total and refault only; PV=
 total is
> > +        * not padded so a meaningful PV refault rate is preserved when=
 sampled.
> >          */
> > -       return pv->refaulted < MIN_LRU_BATCH ||
> > -              pv->refaulted * (sp->total + MIN_LRU_BATCH) * sp->gain <=
=3D
> > +       return pv_ref * sp_total * sp->gain <=3D
> >                (sp->refaulted + 1) * pv->total * pv->gain;
> >  }
> >
> > --
> > 2.25.1
> >
> >

