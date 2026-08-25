Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E96C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 00:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0A46B0095; Mon, 24 Aug 2026 20:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7F86B00A4; Mon, 24 Aug 2026 20:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7CE6B00A5; Mon, 24 Aug 2026 20:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 414456B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:23:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5CD4CC01E5
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:23:27 +0000 (UTC)
X-FDA: 85137892854.05.56138E4
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6FF8B100008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:23:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X3RJ1S2r;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787617405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q4D+JzVq7rrVWcTNgs+vhZxnGwZ9hLVGhQYwWgduIQI=;
	b=ItPdsKc5EbBA7Ac4K3qqUHZ7gh4p11gauALHEKlX1VmADQuF6JT/V1jFcTpYIwQ2YHahBp
	vCh00UDsbyYgr41B8nGdcHP7BpctMR45kd2zeuAok6IGpmFtc2kxRXTsof32JjVd0yz3Jp
	I/sWcFw+qb+wtV5Ll+O7p/UFBa7UsP8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X3RJ1S2r;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787617405;
	b=hsxK4Red5RV1oCXS2YSFRGrdMrtjWx1UAM00VtkzhCLzl+oQ8eoij901sDeiowLk1hx9yv
	uM1z0JndxJIGkSvAeXOCdaOOYWObVtrBf/W66RDhrgHkl+9MsNOykaXGYt6dcrYfVySwI6
	XkzBuwN/3yoTXZvhWADHKZn6iGS9jFk=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49557167508so17974245e9.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:23:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787617404; cv=none;
        d=google.com; s=arc-20260327;
        b=RDO8iE9+Jlxk9FgtZcKVQpP3ErjHMwwc8e2nAvxPJwTqilztvZ/SGqH4e+wjPfxbTl
         TVkL+1tQvVuglmqDSbLEUyW7BsACJMSrIRAT2VDOThe0rIxWi9IOmVpNIyYmbQ7LAQwm
         bi5jbUssANjTgcA8MzjhDS1mTW0mOTU9w1V/fRDmBS51kse1dxA03m6krpoohvLlcmTk
         /bJDSOWzskbaStWhP7XNiYD++eei4pQRUL5LRWc+sQWcOj656dI2yr6asWnFi4dqHmTr
         5TpRGWzOYxUhyQGX9VjOo5DKqKzLqQLv4pR4UY79u8XJRqgwCUbwoLYK2FFYlLYziTJc
         D44w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q4D+JzVq7rrVWcTNgs+vhZxnGwZ9hLVGhQYwWgduIQI=;
        fh=YpRw/R1IpAivev3NqQgomBCdAGi8N5s/6dijfWQ33mo=;
        b=e5/L9AhjcFIjuRG6SGiwI2I5MjqGcIRbXhNIEnDq29HWbDu7FTQijR6KVmYPMs+opo
         UihmTtb4itcd6eBBnXsAm45ML1BxOsEfypSF5Q28L5x8ZbF2aNZ/gaYc75ces22IXLpR
         hdjsmwLlD3l/Pq8yy0HbmbLGK218qhbbG373Dva9+KgP4IZWaRLasdofCb+Z8r9G6/Bj
         b4LWLkub6eZQNThSaf37Y4sMUrxpbA64H9HFOa6bnnZ+6TTFB4qv6A8+yEh2vw75wWMz
         ebU23C1bkNTrvF4ZFRxTyB9IHkNptBREOewR1msU8b72OSxEUMPEkknIpaPi571DAir2
         do5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787617404; x=1788222204; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q4D+JzVq7rrVWcTNgs+vhZxnGwZ9hLVGhQYwWgduIQI=;
        b=X3RJ1S2r6NLRXnsbTirI/L0E6KkejICoTpysKkTdh3EqmlOZDHIVkTIT1KGpFW17XW
         4/YyYk7tNmxo6KcSFLeoK1ByR2X24oSWCzDLGAMHZFny8bR5ePTwf3e/Jkg4Xe1sUrr7
         8bd3QzpuNbyhm8b3kX5Pf+Eavn/90PJVvp04KUMbvrtq6wH5M5kTBX2K2p2fzTyLFRE+
         BYtX1DflWgH7qt03O8GaRriyV8IL0yeMlWsqiNDSc+n+6GZEV5VIdiLAIkXx4LaJzKGZ
         Mu8NzYeknWH9KjgLkVMPfbCNUkZbr9SN2NelOzGxyZV8IlKpZEGXTDpRt9lGL0DxouPu
         Ezvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787617404; x=1788222204;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q4D+JzVq7rrVWcTNgs+vhZxnGwZ9hLVGhQYwWgduIQI=;
        b=P1PE9xVtwRoBDZ1SdZqUaXThNw3oIujSGk8mqGGe84qmOBHG07GcdvdqIvMBKbm+I2
         W/dzmyq1HqP/+Q1qgT722B1YcE/xD+ukfany+Xs9pVJ7A1PucKUSZ390fdPoRNDsLTgd
         IJhMQdXHUdTJcfKF6fIFQMuixvbhdC7YQyq2/L9WKrO6nVRpPaIscgfZZSlwb2IHTUO5
         n2pv6+CPJ++xduhrWSwafWBcaV66j03weXKWz6wG6Q7t8zWpeRPbxzE4MUwb3rtPMI9+
         iqz8hqnGBudlG0U0YlCru5iMTN5uhhMgxMlPLQiOSaOhH0e62sjcWx2qdWUBnAi7wt5A
         1h2w==
X-Forwarded-Encrypted: i=1; AHgh+RruQHjiDTIXz2XMXt0ctBxHIq3joCS2v3WofBYwDtAdcuIooz9xq1/cbKqked+DTQzbtKb4usE5Gg==@kvack.org
X-Gm-Message-State: AFuF++mkmgejPME+W+eaBV1uBlwTi/TsJjEH2Hk0Nhx52aOHxpbasujU
	q2Tpb3hEkxFv+VXLpNrjzimFTX4fM+FFeZkh0/oLojcedx0aJfwir6SJivFz+TXZ3EGARcJjcYk
	v5ijqZ4ZiXhyeassq+mbrmwxd2T7bizQ=
X-Gm-Gg: AR+sD12MGx0MlOdPyS26X9ihcB4aMk4/Nr4CDd1sYCb24eKI3vxBwQcfTctDW4KoHy9
	7iF9GwsntiP1m7L33qMcAzmfUQpCpUKxnJEO/G8ruPPT6g0RfjSbkKXeCfj8NaGgtoZ+3uZcBdR
	9iV1wi8EhtGwXCotycs6JD4ZUHQs8mXBoEYIoqI/BPf8qeZAiLJadE5Dd8OAtWlyEqzi4ksxiTo
	lvjh+5fX0x81MVwBbm1J+tzi4oeT+0EBwTuAAbcRjldaRFXMVuq9WvT0x0wJmbsA8p4EuvSoMhn
	PNW3x5GeHRke21megOvqiyDujeIqHzLg63e5HJe2NvpTbCpKk1yYeYtZNBObrEMKWHcpYRDGmus
	ErCoyO3+XYepCqGGfim/FL9KYGqLYbG2x9LQ2+Q==
X-Received: by 2002:a05:600c:b86:b0:499:8156:cd3f with SMTP id
 5b1f17b1804b1-499b8301913mr299612535e9.8.1787617403993; Mon, 24 Aug 2026
 17:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn> <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
 <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
 <aoiQPrudvYZ76ZSD@cmpxchg.org> <CAO9r8zM+w-wb44G+GXev+eHVEOty5GNcmRkui4PxgeF=Hqv_DQ@mail.gmail.com>
 <CAJnrk1bOdTE+YQRQqzfKUkOGR67a28t3p1r1zeBNzwz9xHEYdw@mail.gmail.com> <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com>
In-Reply-To: <CAO9r8zNQzqwVeOoZr71juX3xV06LUTntBp+7bmGdwK_s6FoT6w@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 24 Aug 2026 17:23:12 -0700
X-Gm-Features: AcwNN1XMPf-DlGUepZHoJG1Jp04G9mgCU5EYS_1mSHsNifKV_m10Rr4sNDM_8KE
Message-ID: <CAJnrk1YgM0h48v1wpORLtD2Z4ypv7oU-ptokjoNBp7p-Bs2YsA@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>, 
	Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FF8B100008
X-Rspamd-Server: rspam07
X-Stat-Signature: 1euq9xq1urtrze979ysr6ho6engxwo3o
X-HE-Tag: 1787617405-620103
X-HE-Meta: U2FsdGVkX18c3azmV887JCPxCSgIsode2txBXaVX8/4u3laEXCav/84SkpixhSd3PxyNxTcwRtyictN5gmzDmP5YJd/AD/JazDTik445lvpE7hhQEK4rGXSWlfSA11s8ncMs4Qb8eo2KcTvrOOVtZkgxU2RMHc7Yrlsnyy6hnoxIMoo7YeuUkE74uePBYtV/vKboZXe//OvcdC+VGYkqpbNyoZ6PDUglYueOxMJXA1hcHXuPicPX8Q8b45/nF52vFOkKPHDRS3iv64VmrkwfokytlfIJQUr2N4vUy6qy5SH1hhxI3C2BYfewKYJBR8PtpuQR8Q6CAqvB733df6tVMEEO1eIFy2pXXfGQOYnhjmi2gLfMngcPCZdcuCHoy9/FpLn9KIQe3D8dg4JjbfGJMjm3X3tTsothh1Pydt7UtHNkLZHJnQPyiqnFabRehMJCznCOZQ5oSLnzZUONOTyT7j+g/0ovlV171PG107elEdtInWCrMjbuan65QcEcljAQReIIHh459Aeg6jMSAck3yYMqeXUPc1pvMsIInlr/EhEUmQtQp41BqG+zcxpQhnYhKlW0lnh6RoYZf1XVTdy6IeCxOGDJd4Oln8mEmqoOiRWJR5HMCcx9orXI0fakoHDneZWkKNCit151LLsXKk5cwIDruoj+OMtm3NPH8xpMRHt3aIqw0tczVhPHKQrNzkiUG7vLSuf+PBd1uXtsrW/3pA6GxUFLTvIWIhgidgT69js+9jAQ20ej9MTrm03heUmWJGOh4ud+DvqJU7PivotLaxXZrFcKXs63CGt26jLFDVri4WTVg+G75JhkTEuo6f3b7PM3nuhE68KEgqEdLgMMuUYGLde47uw2lpYdWZIw35HsYor7qWRmT31F9tqAfOjZpxmR0NAQvjV9HRZce9bVBxKZPc8wxjTeoPC2zNf+wmX5i9TEl4Mwt8sGrC31gk3WClmAI43nyaQGztS4TGn
 GGzDrM+G
 lubHGNhnmITQDeBApecQM1smm5VxCcKaJ5p73huxYIIPkZ8VSs38Vdn4RANKwJXQog2fjEuHclwA85arrVu+GKZJ8ufyJqayoqaSDRaWEADSKj29s83IO8ZMAuecD74CCrL7kmthr0c7SFBRyeKtKnlofnL/ZEmqgznKgc/px3ydeU5/jbO774wUmhTtpSUBkN1ljsH0xqkgxV8xNaCXRcu/D5uho3rn6HaaRhZzb0GIKGXYMLczOrLFosxAXxXXiFO9Q/WXip/xwvfSxWxBB3DHdht/8ZNTi3dcKkCzOWmqgor0ub1/4MeqCi7qM2ZJUDB4AK1/8oMoqchvNb+JdoJG6V1VKbOxKZx9aRbViiQ22tND2FKzEP5Qqoz4tnOKs1KtMrDTQ+JodxQYF9D/jhm6/ImwU1fUms4YkQ8DtGlkWmjkqNTn9m4n5zoX0RlMPYvP9iCzBKrIg6A+fiwRoZBi/wQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 2:16=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > > For this zswap stat, I ran some benchmarks comparing 4 approaches
> > > > > (switchable behind a runtime knob [1]):
> > > > > a) rstat + forced flush       (baseline aka what the tree does to=
day)
> > > > > b) rstat + ratelimited         (Song's proposal)
> > > > > c) hierarchical per-CPU   (Yosry's idea from [2])
> > > > > d) page counters              (following what all the other memcg=
 limits do)
> > >
> > > Thanks for trying this. I actually thought about page counters but
> > > quickly dismissed it because zswap needs sub-page charging. I see you
> > > are using the page counters here as byte counters tho :)
> > >
> > > It's probably fine, I think the risk of overflow is low (at least on =
64-bit).
> > >
> > > > >
> > > > > For the setup, the benchmark creates a cgroup chain at depth X wi=
th
> > > > > memory.max set to 1G on the leaf and memory.zswap.max set to 512M=
 on
> > > > > every level, and spins up 20 processes there that each allocate 1=
00
> > > > > MiB, fault it in, and touch every page four more times. With that=
 2000
> > > > > MiB against the 1 GiB memory.max, it triggers reclaim continuousl=
y and
> > > > > makes the swap traffic go through zswap. The machine I ran this o=
n had
> > > > > 80 CPUs.
> > > > >
> > > > > I also ran it with no memory.zswap.max set (ie no reads triggered=
,
> > > > > only update path runs) - as I understand it, this is the configur=
ation
> > > > > that is more often used in practice.
> > > > >
> > > > > These are the results I saw:
> > > > >
> > > > > kernel cpu time (in ns) per zswap store, zswap.max set
> > > > >                       a)                     b)            c)    =
            d)
> > > > > depth 1        567,116          35,604     35,841     34,995
> > > > > depth 2      1,082,007          35,507     37,803     36,209
> > > > > depth 4      2,153,329          37,591     40,117     39,893
> > > > > depth 8      4,211,692          34,963     41,070     44,211
> > > > > depth 32    15,728,220       53,575     94,685     65,946
> > > > >
> > > > > kernel cpu time (in ns) per zswap store, no zswap.max (update pat=
h only):
> > > > >                         a)                  b)              c)   =
         d)
> > > > > depth 1         34,787          34,062     34,930     35,630
> > > > > depth 2         34,913          35,061     36,404     36,360
> > > > > depth 4         36,422          36,809     36,922     37,483
> > > > > depth 8         42,177          34,440     36,679     40,793
> > > > > depth 32        55,309          55,321     57,671     59,190
> > > > >
> > > > > c) and d) are for the most part pretty comparable to b) without
> > > > > introducing the staleness problem of b). Between c) and d), I thi=
nk d)
> > > > > ends up outperforming c) as the # of cpus and depth gets larger.
> > >
> > > The main advantage of (c) to me is that we can probably update ~all
> > > memcg stats to use this scheme, or at least the problematic ones, it
> > > should be generic enough. Also, I have a concern about (d), see below=
.
> > >
> > > > >
> > > > > I'm seeing that all the other memory limits (eg memory.swap.max,
> > > > > memory.max, etc) are already using page counters. Is there a reas=
on
> > > > > the zswap stat can't? If not, does it make sense for the zswap st=
at to
> > > > > switch over to using page counters?
> > > >
> > > > Thanks for running these.
> > > >
> > > > I used the vmstat counter on the assumption that setting zswap.max =
is
> > > > rare and the counter is maintained anyway for memory.stat.
> > > >
> > > > But I never actually tested it. The assumption was that surely walk=
ing
> > > > ancestors on a quick if (max =3D=3D PAGE_COUNTER_MAX) continue woul=
d be
> > > > much cheaper than page counter atomics at every level. And so I'm
> > > > surprised by your results.
> >
> > I think your assumptions are correct. In that second table above (no
> > zswap.max set, only update path runs), d) has worse performance than
> > the baseline a) (except for depth=3D8, which was a noisy fluke). Rerun
> > with 20 reps, I saw similiar-ish results:
> >
> > depth       a)                       d)                       diff
> >      1  35051 +/- 116   35635 +/- 149    +584 +/- 189   (+1.7%)
> >      2  35603 +/- 142   35859 +/- 179    +256 +/- 229   (+0.7%)
> >      4  36358 +/- 115   37761 +/- 167   +1403 +/- 203   (+3.9%)
> >      8  39537 +/- 178   41225 +/- 240   +1688 +/- 299   (+4.3%)
> >    32  52181 +/- 210   59042 +/- 161   +6861 +/- 265  (+13.2%)
> >
> > I think the atomics do cost roughly what you assumed, but compared to
> > the overall latency of the zswap path, it's adding hundreds of
> > nanoseconds to a path that takes tens of microseconds.
> >
> > >
> > > +1.
> > >
> > > I previously did an experiment with per-cgroup atomics (should be the
> > > same as page counters), and it scaled more poorly than the numbers yo=
u
> > > have here. I was running tests in a VM on an AMD Turin CPU, and I
> > > think I tried 10, 20, and 50 processes, so maybe I pushed it to the
> > > limit. I remember seeing a large regression with 50 processes. I used
> > > bpftrace to measure the latency of zswap loads and zswap stores.
> > >
> > > Would you be able to also collect numbers with >20 processes and with
> >
> > Beyond 20 workers, I'm seeing that the additional workers basically
> > just queue, without improving throughput much. I don't think this
> > bottleneck is related to the accounting method used though. a), c) and
> > d) all are within 1% of each other at 40 and 80 workers, so all 3
> > approaches are bottlenecked by this.
> >
> > > zswap loads? I think latency of zswap loads is more critical because
> > > it's usually in the fault path. One other thing is, you need to be
> > > careful with zswap loads because a miss will be really fast, so they
> > > will pull the average latency down. Ideally you'd only measure zswap
> > > load hits. It would also be useful to see the latency at the tail
> > > (e.g. p90, p95, p99), as people usually care a lot about page fault
> > > latency at the tail, not just the average.
> > >
> > > Sorry if I am asking too much :)
> > >
> > > Honestly, I am not sure if >20 processes is a practical concern, but
> > > zswap load latency is.
> >
> > Ah, thanks for pointing out the zswap load path and its relation to
> > faults. These are the results I'm seeing:
> >
> > zswap_load() latency, (hits only (retval =3D=3D 0), no zswap.max set, 2=
0
> > workers on 80 cpus, 5 runs, ns):
> >                   a)              c)       d)
> >   depth 2
> >     p50        6,850      6,700    6,850
> >     p90       10,000    9,750   10,000
> >     p95       11,050   10,800   11,000
> >     p99       13,600   13,350   13,500
> >     avg       7,269    7,128    7,297
> >   depth 4
> >     p50        6,600    6,500    6,700
> >     p90        9,700    9,650    9,950
> >     p95       10,800   10,750   11,000
> >     p99       13,350   13,250   13,550
> >     avg       7,034    7,029    7,266
> >   depth 8
> >     p50        6,000    6,150    6,750
> >     p90        9,000    9,250    9,900
> >     p95       10,050   10,300   11,050
> >     p99       12,500   12,800   13,650
> >     avg       6,508    6,652    7,273
> >   depth 32
> >     p50        5,250    5,400    9,100
> >     p90        7,900    8,050   12,550
> >     p95        9,000    9,150   13,800
> >     p99       11,550   11,700   16,450
> >     avg       5,786    5,958    9,469
> >
> > For depths 2 and 4, there's no real difference for d), but depth 8+
> > shows worse performance. In Meta's fleet, hierarchies of depth 8+ are
> > common.
> >
> > >
> > > That being said, I generally prefer (c) better because it should scal=
e
> >
> > I now prefer (c) as well. I hadn't realized setting zswap.max is a
> > rare path until Johannes mentioned it, and with your mention of
> > zswap_load() sitting in the fault-critical path, I think the benchmark
> > results show a clear improvement for c) over d) at higher depths.
> >
> > I was uneasy about the cost of c)'s reads scaling linearly with the #
> > of cpus on a system (ie for_each_possible_cpu per level), but given
> > the uncommonness of the zswap.max path, I think that's the right thing
> > to trade away. Either way, it's a big improvement over the baseline a)
> > path that currently exists anyways.
> >
> > > with more concurrency/CPUs and should generalize better to other
> > > stats. But I am obviously biased :P
> >
> > I'm still investigating the writeback and vmscan cases. For writeback,
> > using (c) is more complicated since NR_FILE_DIRTY and NR_WRITEBACK are
> > node stats. I'm planning to spend time this week running benchmarks
> > for it.
> >
> > If for those cases, (c) is viable, then I'll send a patch that adds
> > (c) as general infrastructure. Otherwise, I'll send out (c) as a zswap
> > specific patch.
> >
> > Does this sound good to everyone? If there are any objections, please
> > let me know.
>
> If (c) is holding up for writeback and vmscan, I would question a more
> radical approach of tearing apart the rstat framework and using it
> across the board. That is obviously a heavier lift and more
> controversial, but if we can get away with it, I think it will
> simplify things greatly and honestly rstat has been causing a lot of
> trouble in the last few years.
>
> But this can be done incrementally too, we can start by separating out
> the problematic stats to use the new update/flushing scheme, and then
> do the larger overhaul when it holds up.
>
> Either way, thanks a lot for all the work you're doing here.

Thanks for all your guidance with this memcg stats work, Yosry! I appreciat=
e it.

