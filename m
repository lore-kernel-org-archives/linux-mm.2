Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CEC0CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE146B00B1; Wed,  3 Jun 2026 14:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5D46B00B3; Wed,  3 Jun 2026 14:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB176B00B5; Wed,  3 Jun 2026 14:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCE96B00B1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:14:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3EEB1C10BF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:14:44 +0000 (UTC)
X-FDA: 84839402088.24.02CF3E7
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id D586B40010
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:14:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I6QiMrbP;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780510482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWVsqrCr+/hgZzs1LZgrRbIPF4JwXDGlPOi2Fa4T98E=;
	b=fKmzC/wTxaXLNF+9D9cUMBzUztl8IXNLA6GZxjpPVLrmRxRtNu8Qpog5+l8VFAH4+mAjXF
	hbY2Hx9T6uhOoQt7f5KmH1iWyQAODrkDN1mJU12ibtm0eJ0Skr2RJ2XBE1X+qhmP0WDKR/
	2ovfksWbm4mA570m6DvIdFYW4n7VZEg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I6QiMrbP;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780510482;
	b=GxzzLUjPVGEFVnKQ0V0ykyZYfJ5ozgReXwbUT/gh4+PCfSO/Xtx5VcwsTomNEhNCalCu3T
	qLMet+JTFS5FNDxF+U1+Clyann5bKSYWzgRbznQEem235l7uv2N4jMjcD8WlnpFmZAfyXN
	0uUwrJX+lZkaFNU6Hei+QEpHacZNQTk=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45eedcdaeaaso4787303f8f.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:14:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780510481; cv=none;
        d=google.com; s=arc-20240605;
        b=IWTR6TlZR2uCjnPzIn05axL889W+wECd+lvTE1GBSJ7I3X9k85hwMVg4BeEIoDdm0c
         XxcCO8vN+chHEaeLZz6s+Om5f9M5ZYPMipS/wzqpTY9gmnY6J34bzm9NFCFJnKBbRpxe
         Jxztzqqy769ocUIKterxAF24eCUZ0/6vDJatXN/RphpiCBbuTGFJFnHKQ11E4oQZjG58
         CqT78gPQWQqXhfm0gg9Q5dgdy8wFn12pHiJ884dA9QTT+K0dbeymyZ5fdpJfJ2SwPrzC
         pr5K59e0msWXd0LIhzaxn4EngT7FElKHHKQ3IflrBlrUuhH+LyOd3MUUoCekAWSfGPyt
         FdEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CWVsqrCr+/hgZzs1LZgrRbIPF4JwXDGlPOi2Fa4T98E=;
        fh=yqM5CRMRBH7JUZ/OM5eyOHepp3A9inEfuqksty4VgcQ=;
        b=ISg9brXNJHnqNaL+dTaFMdtdghWhBrIzPcqLnRwAFHjcS+HR6wN4shjuP99ottiUD/
         MNwjueoM5SIVpZYRqDDNl01g4kqXU3X5kYIGJXlZDRa4UAUCqTVMX+b+ia81CCvKifgi
         6zkRivPy7IVFj7dwGmxjb1PF3mW4Kun3EUESUUDc0dzLQ/3xbYixylNgUwESr7tqDdS5
         jTEWLywgGG0ySLMsBts+wsmq/FR+jLN6/GAOjr4sf6BkShAOrVqIzu5jE2QvRZcbUje1
         oJiWWxeUYyjTa3vx2QqaM8bI1D6UseG3jKiGykBgIAvyIwSeWTZNMUUef2ztbIznjh9x
         rPtg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780510481; x=1781115281; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWVsqrCr+/hgZzs1LZgrRbIPF4JwXDGlPOi2Fa4T98E=;
        b=I6QiMrbP4aai+WZN3HbYWbX/KZrPxTuUxtuVf97IrNBQNqUWmEKanOmEWKHADBIc53
         eL4ti5ibe1H5+2AaZicZ4yY1XyW5ptCsI8m1KWa4Ki0uDcyXNLxf/dxOpAF/YGj0aRgc
         k9cTIGpBh8FhfRAO5h2baDpKxNdoUTn1jEMYjiVO9nkZxlfBfQKBMFIVNPpRRgJNiUPa
         nPZJGimh3xLn3iY4cY1MPQHEtoyZDqo1YbV4uceoEQlOh+P49lLKJLJC3lGASbp6iple
         bKO4pTQfQhX8k3Ir3Fl76MkfbPHX9RFj3ly+SW9k6arfMa4ho2Z58ulipiZ0YqCMFDo8
         RBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780510481; x=1781115281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CWVsqrCr+/hgZzs1LZgrRbIPF4JwXDGlPOi2Fa4T98E=;
        b=K9w65eY4Z/4R50dGfNv7Y077CE3ppv+WM8675gzS/Nm8znWUVokgvGxVm557GqrsYz
         vzd1nYKX8OHsDMhEAl9ND5TFyVv53bNKvS1/oIMR3bmMPxfbg6yGHpH96wCVa8rW1mzx
         tvwlj95C+hNPE3HPnTyOFJd49NCWXCxmqTtDao9NJw5avdc8bRTMzw1HYcOynFHRVvDx
         W3jfdgGHa728X+dI3HtimgYRxM75gbCvSMdNu2x+/dsZ0zWg+SvgzpLQT/mCGqE7vnf6
         TH1W73EjX8LKnNZRa4oOIaDTZmDVgxMnLH14ZmoiRN85YbLmJtSC6x65w4kVzX9By7Bc
         lZTA==
X-Forwarded-Encrypted: i=1; AFNElJ/Wt/cPJh3G52f6WYN6RM6KNdG7OFV1Um7YrIn0X682QxArgzoubq4hE8xrjm/t4VTuAPch1ed1vw==@kvack.org
X-Gm-Message-State: AOJu0Yz0M9LNFGuhCfBGZ60vENjt5AVhP1NdMjMCZ5yhtNmGZpr0mVpJ
	mcANf5uYDxTMcHCdB3PL33QCqvT0LR4MFmSeHAHJ6myrSqefWnAessfHP5RkWb+oV9aBqKwfA8/
	mZfHjgb1lAvOl3NHxlRgQG1Nep4pVUcg=
X-Gm-Gg: Acq92OFn++FsFSmAnhtUFztszvnKu8x3tJdUvHvpUiW3SROlbuZTkhKuilt/KJvPTxy
	HVj5i4bhw5cWLj8KDMFAd/xTXpSEKyhKZumcli6U3bDZ/uoFSccLBrGihOEBStlts10qofIrOPv
	moKCIRR4uucBvAaKpc0j3uVt8u+OIuGk2C8Y9FM3iqs2cNeE6R128kNmoHq2v8QgIxkAVeaxfPE
	biCiil8HWVK+m7kWPPATMvMOtBv9/W21nfgqDEXc0o8jrk70/hT6hqiAl2ogFzMTrToqBC/zSEV
	YWrFYinBjCsZk5neHzfT7/YDTYbSunnY14k7AzeHrotDuFixCw==
X-Received: by 2002:a5d:4989:0:b0:45d:41e0:467b with SMTP id
 ffacd0b85a97d-4602178af87mr5170086f8f.3.1780510481099; Wed, 03 Jun 2026
 11:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com> <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com>
In-Reply-To: <aiBqzOtEv5iAC_qC@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 3 Jun 2026 11:14:29 -0700
X-Gm-Features: AVHnY4KZKWD3d0SaeD3tNM3fVPW6StZjCUd8WFWR-F3KM2I_lnoM-TIgG8bLJbk
Message-ID: <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	akpm@linux-foundation.org, tj@kernel.org, shakeel.butt@linux.dev, 
	mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: y1bnryd57nc1a9s4syasaag7m69g1eu7
X-Rspamd-Queue-Id: D586B40010
X-HE-Tag: 1780510482-823757
X-HE-Meta: U2FsdGVkX19YJOuVmqZbpJu3CN5EGNRF2I65i3o+D7rkEQQC66QQNZDLzMjqvNGDKIi12d2yrVRv9juRfTgNBJKINUhMtGzp7PJjHPhkbP3+LlUpk5hM3czYnIdqTsuPoa2lfCVP4AOOxkG7FgMMIIUjh67TavTWGpq/6xd7Un63AnyKjFiVUJr97dWzwDMrHCd5FxfXe2w2iQ9SI53VqVmNAOs3HuhQOMhRRxDF5xiInbr6F5NEK/ESIJ6U8Y0EOWlNYKkfCMuDvO0MFejIGjhyxk5s0oqbIZHOk6fg4KraQVCFsK3X8lJJmv5BpGXyhvN7wLmRUUG0UhhGI8srP/J6tR5iXkccZCfVnRA+XhChK3Kbgm3fONaVPU4Q13YiyQ0HTbIY/bWWfuLpRV75q0uISAQ5+dYnd5TjJT6wjLXG21jlnLXf0Z7gm3XFcgIOZXFbeH0griEg0XPmQaUya6ZRoV2pLENj/xJGB3rAGBTyRC3aB0BTcQiKHRRGxyBZwNDrjAwOlTkqf2MXY4T87vxmsSmifAzZCs32GNOPg+VFX4XMQnboSN5o5sQuF4FWs28+zIsksHFrBUtVs048vAc1nJ6ZM/S7hYFAvgrEAhTbWP+FBgbZd4O9EvMlLvrgZ0FGTHp88gK+kFr/aoz/Rw0Wx6K940NvwVBacjFXGHMFk4XuBzuB009hHaavNrCDIgtJ/4Xj4MZzSvRzqWKLidoIBIN3R16HhbmFJYF/4s9offVG2cLOiyRmG/IVexLnV1oKbbJ20Al+S5qPFPd98yKeDOTLT5ReYsYgDwJLQKgthTHWj5Horh7+2VnidsEfxCI/W2dlB2hRZWtP6edg78UMnN9m/UpX1JlTuxyXTCQF3QBA18rceWgc5Sv9wPYdUWfOF9kmZ9v/1E4h5k5W+Sj00YA36wFVTaf6zPV3sgm1wQOCFayQRllWIsyuzhtCAZz/X9llwq9mN33+YP3
 CbDzIjsN
 5VyfArtMlDPwOMCUn54aUdyknEK6Nw6y5x3i98EzKIMRUbXau8sFpSyIY65pzXA3DX1/Od8sGb+A9H3FEG0KF2M1hEPe1X+c1Ge3lJS9gxJ67eZPM5dg+AIdDxipojAjv9cpmOj89ORahoNKRaF9JZRjMW4NvkJwRtz+s4frHR0WAsmF4pG/MDrP9UAbpkl0HM94/CWxavPCADp6Rs4Qz+TF93GVHHHroimRhdqKUrnq9JC9S/PNw2xLrtxaRlOJ2iF48kujY5erHh4H083dclpn0+AI9626zl5/VVd0rxFFppIUS39fnEtTDhYqOyUssWvrTfUuuQhHh3AEvGuxzmpDAqawHVLT2Qw7TmdhYyVYnK2JrQvmDnBcG0Izu/TrNqJ06rnQHkrCb4TNeWW5p9OFjV6lgBcFuYvuBu8SXHd32JBXWv8st+T6UFINPNZgc2ZP8YN7iHb6pGFbsDJfK8iQbzSOORayNPI3Ldw8Re9iuICEA9zHF5cG3fe+jWiq4Sh/UaYYUIMPHUuoNKjHyR2vxg725s6yiYvzPhVreqH6l/rZv/DmeM5wQQzRw3TTRl/cYbVByE8FVBAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 10:58=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Wed, Jun 03, 2026 at 07:22:36PM +0800, Hao Jia wrote:
> >
> >
> > On 2026/5/30 09:40, Yosry Ahmed wrote:
> > > On Fri, May 29, 2026 at 12:58:09PM -0700, Nhat Pham wrote:
> > > > On Tue, May 26, 2026 at 4:46=E2=80=AFAM Hao Jia <jiahao.kernel@gmai=
l.com> wrote:
> > > > >
> > > > > From: Hao Jia <jiahao1@lixiang.com>
> > > > >
> > > > > Zswap currently writes back pages to backing swap reactively, tri=
ggered
> > > > > either by the shrinker or when the pool reaches its size limit. T=
here is
> > > > > no mechanism to control the amount of writeback for a specific me=
mory
> > > > > cgroup. However, users may want to proactively write back zswap p=
ages,
> > > > > e.g., to free up memory for other applications or to prepare for
> > > > > memory-intensive workloads.
> > > > >
> > > > > Introduce a "zswap_writeback_only" key to the memory.reclaim cgro=
up
> > > > > interface. When specified, this key bypasses standard memory recl=
aim
> > > > > and exclusively performs proactive zswap writeback up to the requ=
ested
> > > > > budget. If omitted, the default reclaim behavior remains unchange=
d.
> > > > >
> > > > > Example usage:
> > > > >    # Write back 100MB of pages from zswap to the backing swap
> > > > >    echo "100M zswap_writeback_only" > memory.reclaim
> > > >
> > > > Hmmm, so this 100MB is the pre-compression size? i.e if this 100 MB
> > > > compresses to 25 MB, then you're only freeing 25 MB?
> > > >
> > > > I'm ok-ish with this, but can you document it?
> > >
> > > That's a good point. I think pre-compressed size doesn't make sense t=
o
> > > be honest. We should care about how much memory we are actually tryin=
g
> > > to save by doing writeback here.
> > >
> > > The pre-compressed size is only useful in determining the blast radiu=
s,
> > > how many actual pages are going to have slower page faults now. But
> > > then, I don't think there's a reasonable way for userspace to decide
> > > that.
> > >
> > > I understand passing in the compressed size is tricky because we need=
 to
> > > keep track of the size of the compressed pages we end up writing back=
,
> > > but it should be doable.
> >
> > Agreed. Using pre-compressed size is probably easier to implement. IIRC=
,
> > interfaces like ZRAM writeback_limit are also calculated using the
> > pre-compressed size.
> >
> > I'll clarify this in the documentation in the next version.
> >
> > >
> > > If we really want pre-compressed size here, then yes we need to make =
it
> > > very clear, and I vote that we use a separate interface in this case
> > > because memory.reclaim having different meanings for the amount of
> > > memory written to it is extremely counter-intuitive.
> > >
> > Agree. This would indeed break the semantics of memory.reclaim. I will =
use a
> > separate interface for proactive writeback in the next version.
>
> But doesn't it make more sense to specify the compressed size, which is
> ultimately the amount of memory you actually want to reclaim.
>

I personally prefer compressed size to pre-compressed size. That's
kinda what user cares about, no?

One thing we can do is let users prescribe a compressed size, but
internally, we can multiply that by the average compression ratio.
That gives us a guesstimate of how many pages we need to reclaim, and
you can follow the rest of your implementation as is (perhaps with
short-circuit when we reach the goal with fewer pages reclaimed).

