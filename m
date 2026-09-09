Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6574CC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CD76B008A; Wed,  9 Sep 2026 12:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7166B0092; Wed,  9 Sep 2026 12:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47EBD6B0095; Wed,  9 Sep 2026 12:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F08AF6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:32:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7DFD91602B1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:32:11 +0000 (UTC)
X-FDA: 85194766062.04.5A466D4
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5DDE212000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:32:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=cZ6NXMpo;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	spf=pass (imf29.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.214.176 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788971529;
	b=bfCTkc80cxhg+n9v0jx7wC/QbkbYN0BCzYucvDqZZEk50GM0EFfx6qh3niyPqJZJSzBGs0
	yFCB/NHuKiJOSP8y6ZjbpAMI8PZyRb/6xy+v6F2MFOYWZCJiS1LfnrnLPSFr1jRli1fzDw
	e3Mn/GfoQuU5VvS+rLn3pFG1ECbkFjc=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=cZ6NXMpo;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	spf=pass (imf29.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.214.176 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788971529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbwUECXSGtpoNpkapF0wkYICgxlHh/DhMmXXNw+XPjo=;
	b=Nr48nIiejKI4rK7HltoJCgQ0XdeFrrId+tIc0yZjAiv1WHM/a9VAP9wgA8JztxEW73Wegi
	GFpYeJA8bqzhCsvvWHcIwTu1K3olfG/mHo6TeN8MohIR0i2BNnikVfYIvjSHSmJmJOl9fG
	EwQQ30QhppnrajOIZ9BoEWV4wGWUZsI=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d58efc7356so78233135ad.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 09:32:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788971528; cv=none;
        d=google.com; s=arc-20260327;
        b=k6/Eh/Sv3a7flzJZe0FYogq9s4d9+UefxIDoXoTtiIhyzIqe6zjZMUjLr1O0drsX19
         RX6XY/YkiDAzJ+KiQeIzTGwQNHGGzcrWewfukCu8sK6o4xUkDH3X96RMm4OiNkY1FalR
         rWGJco3UPyVUMWaj1kaAlyYdE1jHf83Yo4bJ1DYiyr8NDvuP1lpO7PAa6XdYdecnplLN
         WyRK5Irm/9vIK1K6RWXtvzcQSMbCM3kQ4uD04zHIiinbPG/Egk2VpNyXhmR37RjEpdQc
         0ldRAjJAhmdio0dhZlX0J4NK4jO07DQeYWudQFPh1NCMV0AYNUQc+9rVQUwJvHdaJWT4
         wf/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LbwUECXSGtpoNpkapF0wkYICgxlHh/DhMmXXNw+XPjo=;
        fh=s1IWj3oZf8h8l8mLjqU+5pMAu0mBLksGZbRwO+vkTn0=;
        b=LfAJcv48aoQ3QgJIK7caXR1BEJ7Q9S5qtT3f3tgqeez/zWXJQjfs2oe/caolbPs8Kg
         2l+2lf2mqxWODxAzG8gdUNWc1ROIWADyA3/OSwwQaL4tde+K/QhzIJyXufSSrO4SgXXh
         BIVMROpBzgjdO6FbPk+UpRNX32H956VZN9C6ZqSCiT7YW8Zm8kDBXsC7pxK8v9pp3G1z
         o8YHuWuZ5FisWtifEVYqDtByNrhKmeMihwEGI4VeeKZZHNK52doUNEIG8MSQ1+41ilDi
         Y90nly36DvWRLWBAVLTL4lQDcPw3zP9dk/7rADqvkBTVR3IB2sM/I/q0VcoWtKJDVoBP
         Z/Ew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1788971528; x=1789576328; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LbwUECXSGtpoNpkapF0wkYICgxlHh/DhMmXXNw+XPjo=;
        b=cZ6NXMpopQ02mB9QfC8z6IdQmZrwnmgYMvfNMc2wrrPhp/f8r8gGpaiT8++F8eefQD
         Q02UcbH2JE4bFFk71NZKWH7i5hEd/ZQQgkKqqrwnOSfHnfwe0hBQp3lcxRmMo5MoU6QE
         SvnObWadlCvPkeLWZ09QxHz08eIqcw5UuNfud+pxc5gEwSa8aUtRha3o0iHH6EvCWOCg
         zi6CmVSVbXEZXDIKvUY/B3Zc1GisKUjB49tX4uCQpZ+2WE7X3Fx7ni7Qja9v7v/j/jyO
         76Vj0zTRrdglM/6r+0ORTVhM41rnAfSTUPsa4+id71mKNtPlYD/7JaGShOvzcourp5NP
         ZmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788971528; x=1789576328;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LbwUECXSGtpoNpkapF0wkYICgxlHh/DhMmXXNw+XPjo=;
        b=kFJmCQnRkvWrWkXZojrU0SHMvaSadkDa1sebsPZOt1HsL5ka4s8X/TvD4ex4SD5Lqy
         K/vvJpXm59Ii91V2vbWERdjHsNHGUt2F5u5D359DU0qsUUrYNyDAV4D9re+fnX21sVgp
         AUItSULVxoKDPzXiJxvx1Mg0XIx7QR7yFopgfyibdfTPxXIMWIfnAbU4/aPPoz7X2rTJ
         diaSEGOW/kL59dFQ/U14ellhta+C93lPMCb48ove/ZrgNQyeUPUP/T3nnNgNqfVqpY/F
         /K2NDU2La7I1IO+7+rA7hY5LF7NbCFCC3x/KMG9V+iJOt+W2Taf+/5w7h77XaUWFvymj
         FuaA==
X-Forwarded-Encrypted: i=1; AKwUvBy5atueDJMPn24VpG8ej0y0aj58jIU+nSa4aycElh9lzT4KAv5Bg2RYzImfMl4kLtsvM1YYEufLkw==@kvack.org
X-Gm-Message-State: AFuF++l3yA3y1gR4Pvk+iKQvhA5gcOJgHp9R7ey595viicC9yAoFqlof
	F8V+Ko8/7f4yBJdwrX5E8szuxW6SSwmOp3qoeHDhsNdFzmWYPsKMA4RfYVYcLBde+0dRUYjmPD7
	Yw86CHI8+Tpvk3+aTOJWFFJ8nGS7vTU81jCrA3ydF
X-Gm-Gg: AYBFou0nINxKUN1PXiak97iJFv0AE51+5zAPL5hK0buBVLr3fI6f5QHYbGKQ/e7lkHT
	2X8C+0tE4ugt0qkH7UdSyCWOLfE6+OvfyzyELCQ7XP2CRFK/uE4OCF7l5XQ88gWEUarDtnAb2Jt
	0y3VNURZkkmSslff1rKxMdHez7Y2E5EpnpRPI3T8j1KzzHJsKhtXU5ndBMbJwczwVTeaLtCA2/Y
	RP1I2COzIflJUS+fgf+5q4E+KYXIfN6UFgDO1xDAYAp+kT2sgX3IJlTzb+8041t0NxVKu/DaOcb
	W6ohJnz7bhVBfhn7DNqZiiDRu0gzqI+Up2SDKvlgOVZDUYGDebycNoj3GLUVL4+mQApH/g5YxEc
	eybtuexdfBcRcrSIyeHWpREDnGC6FYKTVD6ucJs6jyg==
X-Received: by 2002:a17:903:26d0:b0:2db:5c0a:f18c with SMTP id
 d9443c01a7336-2db5c0b15fdmr270389895ad.6.1788971526736; Wed, 09 Sep 2026
 09:32:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260829023251.474083-1-shakeel.butt@linux.dev> <20260901164741.GJ3004@cmpxchg.org>
In-Reply-To: <20260901164741.GJ3004@cmpxchg.org>
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Wed, 9 Sep 2026 09:31:55 -0700
X-Gm-Features: AcwNN1Xftn-5NEwC_biLDSz968e7PXUVQrICe5nQwJT8vOgIGskFQo4c9Lq4Bc8
Message-ID: <CA+0ovCgpQCaSH+_z+akR4ydhQBd+GSXNoP9mnngszj0Kt5pbow@mail.gmail.com>
Subject: Re: [PATCH] memcg: avoid charging the root memcg from obj_cgroup_charge_pages()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Meta kernel team <kernel-team@meta.com>
Content-Type: multipart/mixed; boundary="0000000000005e66a2065b0f6426"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5DDE212000E
X-Stat-Signature: de88wjkaz867d7ej7w9qzm8fyzsg1xtc
X-HE-Tag: 1788971529-576125
X-HE-Meta: U2FsdGVkX1/f77Rx3P+go6Yc0XkbgD6pMNCc85ZFl7VdocVBr8wpfQ8bOobY74N/exSR4CrgQZpnlY0gWS87IcL8bFnoKZWJa65MX0xA4X6VbdZZuMs2jUhNR5CRKV/sr9EHxFwBMKqho2s4KAZXFTrW+KokutHRC7A+LHm8IBMGOxT6T03KebkxTzKjFRH9bejOv9XoW1hxam6UsUnJGqPaFdCjNj7hG3W6FO0SKjfpDrRVVnu+0wjwhEu0+GkCRL4LqNqS884MCYOm4PvYTUzpgbReu5c27Xz3HAJd2ghGMUwKEyqXFuwpvgFvbzOnYKkgEgJB3Gz+Ye0BVQ4z0nzk/EbBwqMgEAq8O/LmT4XPPQA+FHsTtQWcUMYw/3k6i++wBx0fCrBygvGpZoQLvUHt/FffQloZJHf9fA61KJZV9F2irjrfY0Jc/jEopsBIrO0f1czqPP3uTWRVuyw3s2uuuowb8ftezTdNXlIIfNkNnX/YwGGzFWOhc3yXfin81glLHrGxs/0u63LSigM1pzJRes2VkN9Qxfd4/C8Vr4JKUCFkV7516DTZsQf/mj0R80tnfKZVj/zXRZHAIW16zSkZAbgVg6Aj0YHQES3uNAn1kwov3qpHrLs655A9UuCfoEag3g69SlJcztN0e8fyR6H4jrEB/IrCO7Zo3AMnIz/6AvtfR/G3R5kWDRD03R/QoIyCDrfjDziZWw8FbDDCzftvFpGtNxSL70dYAzGN5WrjjGPMckKGdVPGvstb2PgeGFaOVlTAFwkAjqZsOIuAJc0J22ujUZC4xPh4xb/lt36wkzvkhW8gYyMMyyR2mYT3Xu1+OjD35rZ0kAbDzHJ1Oh68bof96Ci+0vTSnTC1BdhdfPx6kKC4j8hoTDcMU574g5NuRGjv6GLEtUcrCcImKc0tafi7z9D9CFByozyWP9pk7B5a0GkM0UqOdQ4CxQD2R5iW07j/hzJo1ZRc3PW
 83EJ+S8q
 OKyB+lnzJ3BB3g2dRJE9K0nv5+XXhD1SH2tfnKL5lp06pE9uet0SjUercWiSIk1ktXs1smevQGS8ZZOkZZIk2s46sPNTyoNT/Wq1rqWsuvWj6a2QvcMxhnlpp7sYWcHmzR7/7seLPdEsEpbAT0vBavYEKVziLP93tVGsg0672gxU6x4Tll/L2r6424qFHjx15sc62rUhFD0vgFULvrVFhxH0lrO1l4dB0u0YdFE3u8V5lTIuhtLIKfMEv8f87zJrIB9p6k2i96AwVdvsfExoy/E3yTh11fEfsszEiwS4H3JupW02SpMQUT4HwhhO/IVivWkwnhbr0Ka0BOSMbS9EpP+QgAjGKFRqJ8FQItIxS2p/LVUlkLRdDw40CVKyU7F6mi84q5Vr76w+xYBQcmQ2cqO8a0WQu1rK7M9lbyX+GUUE3FH0Eg+vmHQrgpjVMkL16Bsj2kEBFNNZcq3ZUlOx1QCPMmHUHCh153hVOlCkqdF+YBAxBtgzznOJcO8PQdHYe+MnjNKOiQI3z9sRthRBpsnwjE2obHsi62XFKIq9jxxJ10g4XJIbOIjTPq9+3NxMdX4Dz7/6twTVjb7i412ws6Aiffdwm9Rm8Irp4faxkm2ZkLeKuwRWn6F1yiJTNN7ezFZRA4w34O+gIG3lrE31tT2yxbabX8zBMSE+mLOrxemHGpnhBGuIQ+noFN4WZOzJLTtFmvGdFGE9BaF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000005e66a2065b0f6426
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The patched kernel (this patch on 28924df2a08f) no longer panics on
the attached reproducer.


On Tue, Sep 1, 2026 at 9:47=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
>
> On Fri, Aug 28, 2026 at 07:32:51PM -0700, Shakeel Butt wrote:
> > obj_cgroup_charge_pages() resolves the objcg to its memcg and calls
> > try_charge_memcg(), which does not short circuit the root memcg.  That
> > memcg can be the root memcg: obj_cgroup_is_root() reflects the memcg th=
e
> > objcg was created for and is never updated, while memcg_reparent_objcgs=
()
> > does redirect objcg->memcg to the parent on rmdir.  An objcg of a dying
> > child of root therefore passes every obj_cgroup_is_root() filter but
> > resolves to the root memcg.
> >
> > Folios keep the objcg they were charged with, so this is easy to reach
> > through zswap: allocate anon memory in a cgroup, move the task out,
> > remove the cgroup, then write to the root cgroup's memory.reclaim.  The
> > reclaimed folios are charged through the reparented objcg and end up in
> > refill_stock() with the root memcg:
> >
> >   WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940
> >    refill_stock+0x644/0x940
> >    try_charge_memcg+0x12d6/0x1570
> >    __obj_cgroup_charge+0x35/0xf0
> >    obj_cgroup_charge+0x1de/0x210
> >    obj_cgroup_charge_zswap+0x83/0x270
> >    zswap_store+0x1620/0x2000
> >    swap_writeout+0x94c/0x14c0
> >    shrink_folio_list+0x3388/0x52b0
> >    [...]
> >    try_to_free_mem_cgroup_pages+0x30d/0x830
> >    user_proactive_reclaim+0x504/0x840
> >    memory_reclaim+0x1f/0x30
> >
> > Beyond the warning, the charge is asymmetric: obj_cgroup_uncharge_pages=
()
> > skips refill_stock() for the root memcg, so the root's page counter gro=
ws
> > and is never uncharged.  It is not user visible, since memory.current i=
s
> > not exposed on the root, but it is a leak.
> >
> > Use try_charge(), which returns early for the root memcg, restoring the
> > symmetry with obj_cgroup_uncharge_pages().
> >
> > The above sequence was scripted into a standalone reproducer (zswap on,
> > swap on a virtio disk, 512MB of anon memory faulted in inside a child o=
f
> > the root cgroup, the task then migrated to the root cgroup, the child
> > removed, followed by "echo 600M swappiness=3Dmax > memory.reclaim" on t=
he
> > root) and run in a CONFIG_DEBUG_VM=3Dy VM.  It reproduces the splat on =
the
> > first zswap store of a reparented folio, with the same call chain as th=
e
> > report.  With this patch applied the splat is gone while the zswap stor=
e
> > count over the run is unchanged, so the same path is still exercised.
> > cgroup selftests test_zswap, test_kmem and test_memcontrol show no new
> > failures.
> >
> > Fixes: 20d6c1725228 ("memcg: avoid refill_stock for root memcg")
> > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > Closes: https://lore.kernel.org/all/CA+0ovCgWzUMK+nNbbtH7eV65Ca=3DfDN4O=
zu7iASgryjvv8Tk8zQ@mail.gmail.com/
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

--0000000000005e66a2065b0f6426
Content-Type: text/x-c-code; charset="US-ASCII"; name="reproducer.c"
Content-Disposition: attachment; filename="reproducer.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mtubfcki0>
X-Attachment-Id: f_mtubfcki0

LyoKICogUmVwcm9kdWNlciBmb3IgMTQ1LW1lbWNnLXZtX3dhcm4tcmVmaWxsX3N0b2NrLXJvb3Qt
Y2dyb3VwCiAqLwojZGVmaW5lIF9HTlVfU09VUkNFCiNpbmNsdWRlIDxlcnJuby5oPgojaW5jbHVk
ZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHNpZ25hbC5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1
ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgoj
aW5jbHVkZSA8c3lzL3N0YXQuaD4KI2luY2x1ZGUgPHN5cy9zeXNjYWxsLmg+CiNpbmNsdWRlIDxz
eXMvd2FpdC5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CgojZGVmaW5lIENHUk9VUF9ST09UICIvc3lz
L2ZzL2Nncm91cCIKI2RlZmluZSBWSUNUSU1fQ0dST1VQIENHUk9VUF9ST09UICIvdmljdGltIgoj
ZGVmaW5lIFNXQVBGSUxFICAiL3N3YXBmaWxlLjE0NSIKI2RlZmluZSBTV0FQX1NJWkUgKDUxMlVM
TCA8PCAyMCkKI2RlZmluZSBBTk9OX1NJWkUgKDQwMFVMTCA8PCAyMCkKCnN0YXRpYyBpbnQgd3Jp
dGVfZmlsZShjb25zdCBjaGFyICpwYXRoLCBjb25zdCBjaGFyICp2YWx1ZSkKewoJaW50IGZkID0g
b3BlbihwYXRoLCBPX1dST05MWSk7CglpbnQgcmM7CgoJaWYgKGZkIDwgMCkgewoJCXByaW50Zigi
b3BlbiAlczogJXNcbiIsIHBhdGgsIHN0cmVycm9yKGVycm5vKSk7CgkJcmV0dXJuIC0xOwoJfQoJ
cmMgPSB3cml0ZShmZCwgdmFsdWUsIHN0cmxlbih2YWx1ZSkpOwoJaWYgKHJjIDwgMCkKCQlwcmlu
dGYoIndyaXRlICVzIDwtICVzOiAlc1xuIiwgcGF0aCwgdmFsdWUsIHN0cmVycm9yKGVycm5vKSk7
CgljbG9zZShmZCk7CglyZXR1cm4gcmMgPCAwID8gLTEgOiAwOwp9CgovKiBzd2Fwb24oKSByZWZ1
c2VzIGEgc3BhcnNlIGZpbGUsIHNvIHRoZSBhcmVhIGlzIHdyaXR0ZW4gb3V0IGluIGZ1bGwgKi8K
c3RhdGljIGludCBzZXR1cF9zd2FwZmlsZSh2b2lkKQp7Cgl1bnNpZ25lZCBsb25nIHBhZ2Vfc2l6
ZSA9IDQwOTY7Cgl1bnNpZ25lZCBjaGFyICpoZWFkZXIgPSBjYWxsb2MoMSwgcGFnZV9zaXplKTsK
CXVuc2lnbmVkIGNoYXIgKnplcm9zID0gY2FsbG9jKDEsIDEgPDwgMjApOwoJdW5zaWduZWQgbG9u
ZyBsb25nIG9mZjsKCWludCBmZCA9IG9wZW4oU1dBUEZJTEUsIE9fUkRXUiB8IE9fQ1JFQVQgfCBP
X1RSVU5DLCAwNjAwKTsKCglpZiAoZmQgPCAwKQoJCXJldHVybiAtMTsKCWZvciAob2ZmID0gMDsg
b2ZmIDwgU1dBUF9TSVpFOyBvZmYgKz0gKDEgPDwgMjApKQoJCWlmICh3cml0ZShmZCwgemVyb3Ms
IDEgPDwgMjApICE9ICgxIDw8IDIwKSkKCQkJcmV0dXJuIC0xOwoKCS8qIHN0cnVjdCBzd2FwX2hl
YWRlcjogMTAyNCBib290Yml0cywgdGhlbiB2ZXJzaW9uL2xhc3RfcGFnZS9ucl9iYWRwYWdlcywK
CSAqIGFuZCB0aGUgIlNXQVBTUEFDRTIiIG1hZ2ljIGluIHRoZSBsYXN0IDEwIGJ5dGVzIG9mIHRo
ZSBmaXJzdCBwYWdlICovCgkqKHVuc2lnbmVkIGludCAqKShoZWFkZXIgKyAxMDI0KSA9IDE7Cgkq
KHVuc2lnbmVkIGludCAqKShoZWFkZXIgKyAxMDI4KSA9IChTV0FQX1NJWkUgLyBwYWdlX3NpemUp
IC0gMTsKCW1lbWNweShoZWFkZXIgKyBwYWdlX3NpemUgLSAxMCwgIlNXQVBTUEFDRTIiLCAxMCk7
CglpZiAocHdyaXRlKGZkLCBoZWFkZXIsIHBhZ2Vfc2l6ZSwgMCkgIT0gKHNzaXplX3QpcGFnZV9z
aXplKQoJCXJldHVybiAtMTsKCWZzeW5jKGZkKTsKCWNsb3NlKGZkKTsKCXJldHVybiBzeXNjYWxs
KFNZU19zd2Fwb24sIFNXQVBGSUxFLCAwKTsKfQoKaW50IG1haW4odm9pZCkKewoJY2hhciBwaWRf
c3RyWzMyXTsKCWludCBjaGFyZ2VkX3BpcGVbMl0sIHBsYWNlZF9waXBlWzJdOwoJcGlkX3QgY2hp
bGQ7CgljaGFyIHN5bmNfYnl0ZTsKCglzZXR2YnVmKHN0ZG91dCwgTlVMTCwgX0lPTkJGLCAwKTsK
CgkvKiB6c3dhcCBtdXN0IGJlIG9uLCBvciBub3RoaW5nIGlzIGNoYXJnZWQgdG8gdGhlIG9iamNn
IGF0IGFsbCAqLwoJd3JpdGVfZmlsZSgiL3N5cy9tb2R1bGUvenN3YXAvcGFyYW1ldGVycy9lbmFi
bGVkIiwgIlkiKTsKCWlmIChzZXR1cF9zd2FwZmlsZSgpIDwgMCkgewoJCXByaW50Zigic3dhcG9u
OiAlc1xuIiwgc3RyZXJyb3IoZXJybm8pKTsKCQlyZXR1cm4gMTsKCX0KCXdyaXRlX2ZpbGUoQ0dS
T1VQX1JPT1QgIi9jZ3JvdXAuc3VidHJlZV9jb250cm9sIiwgIittZW1vcnkiKTsKCWlmIChta2Rp
cihWSUNUSU1fQ0dST1VQLCAwNzU1KSA8IDAgJiYgZXJybm8gIT0gRUVYSVNUKSB7CgkJcHJpbnRm
KCJta2RpciAlczogJXNcbiIsIFZJQ1RJTV9DR1JPVVAsIHN0cmVycm9yKGVycm5vKSk7CgkJcmV0
dXJuIDE7Cgl9CgoJcGlwZShjaGFyZ2VkX3BpcGUpOwoJcGlwZShwbGFjZWRfcGlwZSk7CgoJY2hp
bGQgPSBmb3JrKCk7CglpZiAoY2hpbGQgPT0gMCkgewoJCWNoYXIgKmFub247CgkJdW5zaWduZWQg
bG9uZyBsb25nIGk7CgoJCWNsb3NlKGNoYXJnZWRfcGlwZVswXSk7CgkJY2xvc2UocGxhY2VkX3Bp
cGVbMV0pOwoJCXJlYWQocGxhY2VkX3BpcGVbMF0sICZzeW5jX2J5dGUsIDEpOwoKCQlhbm9uID0g
bW1hcChOVUxMLCBBTk9OX1NJWkUsIFBST1RfUkVBRCB8IFBST1RfV1JJVEUsCgkJCSAgICBNQVBf
UFJJVkFURSB8IE1BUF9BTk9OWU1PVVMsIC0xLCAwKTsKCQlpZiAoYW5vbiA9PSBNQVBfRkFJTEVE
KQoJCQlfZXhpdCgxKTsKCQkvKiBjb21wcmVzc2libGU6IHpzd2FwIG9ubHkgY2hhcmdlcyB3aGF0
IGl0IGFjdHVhbGx5IHN0b3JlcyAqLwoJCWZvciAoaSA9IDA7IGkgPCBBTk9OX1NJWkU7IGkgKz0g
NDA5NikgewoJCQltZW1zZXQoYW5vbiArIGksIDB4NDEgKyAoaSAlIDcpLCA0MDk2KTsKCQkJKih1
bnNpZ25lZCBsb25nICopKGFub24gKyBpKSA9IGk7CgkJfQoJCXdyaXRlKGNoYXJnZWRfcGlwZVsx
XSwgIngiLCAxKTsKCQlwYXVzZSgpOwkJLyoga2VlcCB0aGUgZm9saW9zIGNoYXJnZWQgKi8KCQlf
ZXhpdCgwKTsKCX0KCWNsb3NlKGNoYXJnZWRfcGlwZVsxXSk7CgljbG9zZShwbGFjZWRfcGlwZVsw
XSk7CgoJc25wcmludGYocGlkX3N0ciwgc2l6ZW9mKHBpZF9zdHIpLCAiJWQiLCBjaGlsZCk7Cgl3
cml0ZV9maWxlKFZJQ1RJTV9DR1JPVVAgIi9jZ3JvdXAucHJvY3MiLCBwaWRfc3RyKTsKCXdyaXRl
KHBsYWNlZF9waXBlWzFdLCAieCIsIDEpOwoJcmVhZChjaGFyZ2VkX3BpcGVbMF0sICZzeW5jX2J5
dGUsIDEpOwoKCS8qIGNncm91cCB2MiBkb2VzIG5vdCByZWNoYXJnZSBvbiBtaWdyYXRpb24sIHNv
IHRoZSBmb2xpb3Mga2VlcAoJICogcG9pbnRpbmcgYXQgdmljdGltJ3Mgb2JqY2cgYWZ0ZXIgdGhl
IG93bmVyIGxlYXZlcyAqLwoJd3JpdGVfZmlsZShDR1JPVVBfUk9PVCAiL2Nncm91cC5wcm9jcyIs
IHBpZF9zdHIpOwoKCS8qIHJtZGlyIHJlcGFyZW50cyB0aGF0IG9iamNnIHRvIHRoZSBST09UIG1l
bWNnIHdoaWxlIGxlYXZpbmcKCSAqIG9iamNnLT5pc19yb290IGZhbHNlLCB3aGljaCBpcyB3aGF0
IGRlZmVhdHMgdGhlCgkgKiBvYmpfY2dyb3VwX2lzX3Jvb3QoKSBndWFyZCBpbiBvYmpfY2dyb3Vw
X2NoYXJnZV96c3dhcCgpICovCglpZiAocm1kaXIoVklDVElNX0NHUk9VUCkgPCAwKQoJCXByaW50
Zigicm1kaXIgJXM6ICVzXG4iLCBWSUNUSU1fQ0dST1VQLCBzdHJlcnJvcihlcnJubykpOwoKCS8q
IHJlY2xhaW0gb24gdGhlIFJPT1Q6IHRoZSB6c3dhcCBjaGFyZ2UgbGFuZHMgb24gcm9vdF9tZW1f
Y2dyb3VwIGFuZAoJICogcmVmaWxsX3N0b2NrKCkgdHJpcHMgVk1fV0FSTl9PTl9PTkNFKG1lbV9j
Z3JvdXBfaXNfcm9vdChtZW1jZykpICovCgl3cml0ZV9maWxlKENHUk9VUF9ST09UICIvbWVtb3J5
LnJlY2xhaW0iLCAiMUciKTsKCglraWxsKGNoaWxkLCBTSUdLSUxMKTsKCXdhaXRwaWQoY2hpbGQs
IE5VTEwsIDApOwoJcmV0dXJuIDA7Cn0K
--0000000000005e66a2065b0f6426--

