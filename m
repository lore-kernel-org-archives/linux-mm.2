Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2EF8CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 23:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B873E6B0088; Fri,  2 Oct 2026 19:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38896B008A; Fri,  2 Oct 2026 19:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00D66B0098; Fri,  2 Oct 2026 19:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3CA6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:22:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41985A789A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:22:19 +0000 (UTC)
X-FDA: 85279261998.01.536999F
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 11147180007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:22:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=EXiVDnvc;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790983337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FsAXnBGyVwjDcWOkRa9J6cVtdeFvnQHX1nG1U/nAVDU=;
	b=0bqHWNQqB8oaRbWWSpwX+Flxc1lSYZpAHe1AFnNM2MC8wLBJ1GaSW+po0/I6tWCW6ZE3Wo
	sWRx8TxA5UnBoWytVDs4oMBzRYeZk3bUiMPa3hhUIASlRan/+s55OoGe8mkwLuPXTSR8Pi
	IM2O5eEkQ8RXwGgyf4QykNqzvxn3rH8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790983337;
	b=Tdl7jmt6UdUuUDsaylDpqb8/xsG7fE1YipnAR99QUa3kpDPmzfu8JNOSCvsBbpvvHv+rrv
	LNOOBtp9OiKgLge/cyZS+DMuRrVitVPTr7o+AqepZ6H76CQts2feeIXsWN97wkJAtBH0wm
	w2bGmV2SplgBq2WDhvM3ycGuSDapfSo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=EXiVDnvc;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-88c72646f03so33177b3a.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 16:22:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790983336; cv=none;
        d=google.com; s=arc-20260327;
        b=HKmcUBu7KGoTc7xhWxhk1ozdHgHx6Neg82XAe42I4MEoE4pSI6bzpA8QZqm06qSA/e
         Z2LHeIAW3IA5ezpLZUIWI4718+7G2fgYqE0KC8mNAWKf7SpNOa0NdpKiPlJMv8yWyJJX
         aYVVHVTTqV5jWk5lzUq+IWmtUB9SrJ4nqxFPlsZKjEqOm/veSoW2ij2bdlGUsfKV713P
         GqIKV1Je6UrIkTU0vz+JTbiiNh2HI0SY7JX33FpUP79+VV9Sz95gatrHWPtNVBaeh0aB
         JxC3E7uARgNolzz4/6V0svrGmNnuF66nJpKGPy+h5TNFpcvmzAGYDQ+1q2C++bYGiP4P
         lGCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FsAXnBGyVwjDcWOkRa9J6cVtdeFvnQHX1nG1U/nAVDU=;
        fh=dwoCoh/zX1hoZs5I+bgZMikwRzq8RxVO2c2bC/M9CQ0=;
        b=I7LZfWLa195QeMijDJtoi0P3DMFjAHj1ArFHi4edFEz9/1kqWvS2Jq6fIDku5VdN2z
         Nhgl3BGshDRdpI4Jz9IjDPjypPoKsSyAQN6ddVJ85nNjY5vhHF3neldK0ssWtWkgCXHP
         XgUR8H9WsZR3Xd5zMKdW0KbOKmc2vwKkYT8qe9DKQduw4Uv3DZCZ139PsKh7Fo4Ydrte
         PYeCcQslTaYihgMAIyTL+ZB5l4E4vMuPvdWiyoou9CxUx3l2ql5Eomc6UC+Ut/2tuWGr
         ZHJTkX5fyN8F6O7YuHtGyavADMu/wI+FN40EtkzNCdp5RWPixNgruqwq/xe5VBBTwEaO
         1ADw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790983336; x=1791588136; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FsAXnBGyVwjDcWOkRa9J6cVtdeFvnQHX1nG1U/nAVDU=;
        b=EXiVDnvcSzsO1tsYccQM6vsC21C3a/pn010VQ2CRa8Zo0NBBavGL46EdMcgKtkey5w
         dCDV6mMao/yKA2zr3FYL4UbW0TzJ8s0pOHDYaobapV8vra2ePlPoBSvrm66OYD+AwB9D
         J/shDYdgiONBFr/qAOLIDIL7wIqUrb3bY8UCoKj+kV2uoZbgildFNtyoe919REDIvAdW
         0qhFPu2/1mLbwuautp3Df4CymMKxMg43h7QArDpDae5nOGpJN6T9+lIcpExoosszBvUs
         WmXdbDTCDnq1wMryH8BQ8/CUML7YRHVSMKxahKpFKIF2TWsTCdIrL8DvvyXVLhtyQGqc
         WvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790983336; x=1791588136;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FsAXnBGyVwjDcWOkRa9J6cVtdeFvnQHX1nG1U/nAVDU=;
        b=BIHNdo5DEWY9IVas1aK2B+WhASRMo0VT/RWJfo/lABfI5Hf8xyVpTcXOquKKhX3+T3
         iWwL8+xZyPcr4qN+NLAzuGRS+MnqJqZENfBWgAVJcLapFn7HPDrdw1BDbeGPVthBRDmg
         0nUwtpdWk6NnV0PYUOXG95X+I96mx8BkUiXvUm3gG4/Y0KXWgAVchVpuuPhP/mxUdZNt
         A7zO1MBKoKrJ37qZy4JkOz91XXrIzkf9ZDEzcdCOMap6QbgTwlnBMZJG9PlFzyM9v1kI
         3xqCLcDaL3X6wB4IYke/0DINfs+yHyWuXt26SZB72ELtE5tk5Umsd9xUm0piOxZPlBiQ
         caLw==
X-Forwarded-Encrypted: i=1; AKwUvBzNV71rX+lB8XjV/tcUPxTaIFK7uzBtujzNwecSvuTpZiu7WUiAqrvONOumG6UJyUbMKrAfiamA/A==@kvack.org
X-Gm-Message-State: AFuF++kFrsXOLQxWgOz5NcmORkCYFAsGz8ZZEg1W5VUHcqJ2fnceYKql
	TYuZ+qIBdwIxxGow7mwc/F1xCtsk9NOt7WQnUPB1pn74hmzv1wVTKAuBDY3yfVcsHZ3RtctoZAI
	rvkXpl/TjsJI9/BWF6RPuvgnpdoEX7rel4f7C1q7X2A==
X-Gm-Gg: AYBFou3oqKE6OZoeDOTwdJGkdt/HX04WiHUkdOlgq4y43aHaFRTCvOayYT1XC1ylkj2
	EyiG++VRPsKv9qoP9MWkfkD4KUgJSuniiyQytRnGRMfzEPclW6EWrKQqxQPBkxM+QJrxy81zfB+
	FRJfQ2sltttzaBi7s3oxUYNfCdKH+aso4yg6PUrjysQc6gJOlT7xMKgizQmNWTTpN+vR9V6lm7J
	JRiRdUpzfslygbZx9lCSpDroCatoo5B1uWh+xAhDpVW+vzNN5b1biKDf10avNMb64NAW++F8hp6
	FFXcKMU3PZMHBtE7meEsokE+PBN5TPVXyb76U9MVYZGTsU4zMICdTBA=
X-Received: by 2002:a05:6a00:b81:b0:878:3705:2515 with SMTP id
 d2e1a72fcca58-88c63d70fc2mr570434b3a.53.1790983335622; Fri, 02 Oct 2026
 16:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <aqrHjfHwyEtRIr5S@cmpxchg.org>
 <aquWKJoP5JLP8Ci7@fedora> <20260917131712.GA1344@cmpxchg.org> <7bd2b824-4c91-4378-a817-d5ce475ea84d@kernel.org>
In-Reply-To: <7bd2b824-4c91-4378-a817-d5ce475ea84d@kernel.org>
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Fri, 2 Oct 2026 19:19:23 -0400
X-Gm-Features: AclHuK8UC8NSreEOLUEKK_FdvdEarH-PVwCjn4ili6mPUlYYVOoTNn0C5HH03rg
Message-ID: <CA+mpNMkmnHrpVifBWi52f82KzhZZ501izsTeRPzvRr-i0su0SQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, Chris Li <chrisl@kernel.org>, kasong@tencent.com, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Yosry Ahmed <yosry@kernel.org>, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: multipart/alternative; boundary="00000000000084c9b9065ce3cdff"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 11147180007
X-Stat-Signature: sbkdyg4ofcizz8q78zm3ksxkxyjq1mt8
X-HE-Tag: 1790983336-333487
X-HE-Meta: U2FsdGVkX1/mmYOOI+2ttIloLDPupZwvnS1jeKMaYONXviXWqFMv2+3ie0ddGovjkTqbam6lyxXI5EczO9/3CWI2AgIFFiRtTLhPMvEgtyOSqjYDuZSGHtLGThmohAsAo7Rf1VPwl/e7gR4VU7xwWSVyk5+pDXhf7jegHBuu6STSCSVW01UfeuayVOWt3i9Ls97TD52sZKMx6BV3AUkEvUfg2zNYU8hUHNWXP0lhbYOYx6Z8WiKZhaejuWCtlebEuLNtXu21bgR2khinFJ0vpkmhZ57tNL0bJGjIPCQUmmaBEU2R5a5kXYvlXU0+IEY/wR6Cn/QGE2UjJUNwvwIU+fND0xDOIuDBNjolgup3Sat+XXVgcszde5WdsYaf+7O/GCvT0mtrBOMq7FmjgrawQX9zNn8j2AWiA67HC29O0/hqEq6hOKFnAr+k4jDSqkBJxOauyEZV1dLo+Ifyfs6xRPciZmJn/JPHwRerKQdhnqzqwKofc2OIzbE0GfstCeTdHXa+3gcZe6taQH2IkTFeZT8xsRUMlFy3w9ONbCbKlkrouQgqNAhy8VeNfV8cmDKhTdIzGwPBLjRQrlmQBsChjwSSl1qrEwv2boLhSwNYehmCYBiJd9HcEBlXp8AHOsZkg4t7uL9KIJl5R6udgzOrcYWd4SHpFwMkfXuAXw1SLGL5GajuBglaIL4o/pvzKKbT4d2dunJqTY2spoLtgNCeiPS5GiL/EvtCY7G06ZANAgs2eLs/V5CX7Zv/tEUhkQ1Nn1CUI1KjLS2xhIAJdToHDCFuC5bc5Ut+EKhUJG2EpuQnKBzxzkeJVjHbPcqSS7URYrP27Meg7D9bFuQFmfsIh6anWYtq9nWpA+z1XTFTILh9nu6kQJREqw24+K2ceC+Xstt8av14YLLvXUNxcSGy5V77GiA3115VNyglwVnybpxiUVJ3GPE9o/gjnLPsrmoZV2ezUIzpz7fNBI6xpqv
 NySJ/b+i
 Lq4AOzN62MSPOp0osCsgys42ly9AkHR7RgVzr7D1DGGVZsV5vUOqcLejwxxNg+z4xpTt81Cq0nfyNELVq+0/GHPdZUzVzu8/dusDs0zbG9BOT7vGI/6ZqW6Jlhfby4Q9W6BC+6pqOeFUA5a8WcQTH5hh+HWKP/0CZDySZ0OGFc6HXQGu10qPCpYTbHGrs3IK4kANigN4QSM9gJmJ3msLdrnoFKGXhq6I5Hud8/BEG3SthmjgYQlwNqMqYMO6dOJ1fWoa7C9arfqc34jKB0zEqjJvT1i5ORk6epSkRtKllIQ8O2rURkWFOK8vH0t3koc/zRQv1sGi4FIRFpBsH/6EmydJn6N3G5S1c5Sm6MPY/P5eNScpCq5ZPE5KkaVFycgwZC9Qumr8VEaRUDCl+JYikT/MkKF4ihoFrcoOLju883JtCtg6PnsGfwoKHNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000084c9b9065ce3cdff
Content-Type: text/plain; charset="UTF-8"

[ Sorry about the top post, on my way to Plumbers ]

Yes I still stand by this. The proposal in this shape is not compatible
with the cgroup resource control model.

And I hear you on the thread :(

On Fri, Oct 2, 2026, 16:22 David Hildenbrand (Arm) <david@kernel.org> wrote:

> On 9/17/26 15:17, Johannes Weiner wrote:
> > On Thu, Sep 17, 2026 at 03:31:23PM +0800, Baoquan He wrote:
> >> On 09/16/26 at 12:45pm, Johannes Weiner wrote:
> >>>
> >>> If the swap maintainers prefer the VM_SPARSE route, I'm happy to defer
> >>> to them on that.
> >>>
> >>> However, from the cgroup and zswap camp, two stipulations that I
> >>> reasoned out in the other thread[1]:
> >>
> >>>
> >>> 1. You must not charge compression space as swap space to the cgroup.
> >>
> >> Hmm, I don't have a stance on this. However, isn't this an issue
> >> zswap/zram have been doing? It feels like an independent issue which
> >> should be done separately?
> >
> > If you have 3 containers using compression space, and two of them have
> > writeback enabled to a shared swapfile, the memory.swap.* controls
> > need to work to manage fair access to that swapfile. They do not work
> > if compression space itself is conflated in.
> >
> > Right now zswap entries actually consume physical swapfile space, even
> > before writeback. Charging the space is correct. But the whole point
> > is to decouple compression space from physical swap space.
> >
> > This is not something that can be done later. It would be a dramatic
> > user-visible change to how the resource is categorized and managed.
> >
> >>> 2. You must make the compression space large enough to be outside the
> >>>    range where users can hit space limits before hitting memory limits.
> >>
> >> We may need a way to define 'large enough' at first.
> >
> > I've tried to lay this out in the other thread, and highlighted the
> > usability issues that result from hitting compression space limits
> > prematurely. It's kind of your call whether you want to seriously
> > engage with this or not.
> >
> > But ultimately it's your claim that a static size can be made to work,
> > so it's on you to make a convincing case.
> >
> >>>    That also means not allowing setups where this is possible.
> >>
> >> And the limit is only an optional knob. If the admin does not set it,
> >> the device grows to the full address space, so there is no space limit
> >> to hit at all. It already behaves the way you want by default. The knob
> >> is only for admins who want a ceiling, they can use it or not. I hope
> >> this would not be a problem for your use case.
>
> >
> > No, I've laid this out already as well.
> >
> > This isn't about "my" usecase. It's about designing a coherent
> > interface that works well with a large number of usecases, and other
> > pieces of kernel infrastructure commonly used in conjunction.
>
> Johannes, I read this as a NAK for now to the current approach from the
> memcg
> side, is that correct?
>
> I've tried to follow the discussion on the other thread, but it just
> exploded
> and some of the things I read there made me rather upset late on a Friday
> evening.
>
> --
> Cheers,
>
> David
>

--00000000000084c9b9065ce3cdff
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div>[ Sorry about the top post, on my way to Plumbers ]<=
div dir=3D"auto"><br></div><div dir=3D"auto">Yes I still stand by this. The=
 proposal in this shape is not compatible with the cgroup resource control =
model.</div><div dir=3D"auto"><br></div><div dir=3D"auto">And I hear you on=
 the thread :(</div><br><div class=3D"gmail_quote gmail_quote_container"><d=
iv dir=3D"ltr" class=3D"gmail_attr">On Fri, Oct 2, 2026, 16:22 David Hilden=
brand (Arm) &lt;<a href=3D"mailto:david@kernel.org">david@kernel.org</a>&gt=
; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex">On 9/17/26 15:17, Johannes=
 Weiner wrote:<br>
&gt; On Thu, Sep 17, 2026 at 03:31:23PM +0800, Baoquan He wrote:<br>
&gt;&gt; On 09/16/26 at 12:45pm, Johannes Weiner wrote:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; If the swap maintainers prefer the VM_SPARSE route, I&#39;m ha=
ppy to defer<br>
&gt;&gt;&gt; to them on that.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; However, from the cgroup and zswap camp, two stipulations that=
 I<br>
&gt;&gt;&gt; reasoned out in the other thread[1]:<br>
&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; 1. You must not charge compression space as swap space to the =
cgroup.<br>
&gt;&gt;<br>
&gt;&gt; Hmm, I don&#39;t have a stance on this. However, isn&#39;t this an=
 issue<br>
&gt;&gt; zswap/zram have been doing? It feels like an independent issue whi=
ch<br>
&gt;&gt; should be done separately?<br>
&gt; <br>
&gt; If you have 3 containers using compression space, and two of them have=
<br>
&gt; writeback enabled to a shared swapfile, the memory.swap.* controls<br>
&gt; need to work to manage fair access to that swapfile. They do not work<=
br>
&gt; if compression space itself is conflated in.<br>
&gt; <br>
&gt; Right now zswap entries actually consume physical swapfile space, even=
<br>
&gt; before writeback. Charging the space is correct. But the whole point<b=
r>
&gt; is to decouple compression space from physical swap space.<br>
&gt; <br>
&gt; This is not something that can be done later. It would be a dramatic<b=
r>
&gt; user-visible change to how the resource is categorized and managed.<br=
>
&gt; <br>
&gt;&gt;&gt; 2. You must make the compression space large enough to be outs=
ide the<br>
&gt;&gt;&gt;=C2=A0 =C2=A0 range where users can hit space limits before hit=
ting memory limits.<br>
&gt;&gt;<br>
&gt;&gt; We may need a way to define &#39;large enough&#39; at first.<br>
&gt; <br>
&gt; I&#39;ve tried to lay this out in the other thread, and highlighted th=
e<br>
&gt; usability issues that result from hitting compression space limits<br>
&gt; prematurely. It&#39;s kind of your call whether you want to seriously<=
br>
&gt; engage with this or not.<br>
&gt; <br>
&gt; But ultimately it&#39;s your claim that a static size can be made to w=
ork,<br>
&gt; so it&#39;s on you to make a convincing case.<br>
&gt; <br>
&gt;&gt;&gt;=C2=A0 =C2=A0 That also means not allowing setups where this is=
 possible.<br>
&gt;&gt;<br>
&gt;&gt; And the limit is only an optional knob. If the admin does not set =
it,<br>
&gt;&gt; the device grows to the full address space, so there is no space l=
imit<br>
&gt;&gt; to hit at all. It already behaves the way you want by default. The=
 knob<br>
&gt;&gt; is only for admins who want a ceiling, they can use it or not. I h=
ope<br>
&gt;&gt; this would not be a problem for your use case.=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 <br>
&gt; <br>
&gt; No, I&#39;ve laid this out already as well.<br>
&gt; <br>
&gt; This isn&#39;t about &quot;my&quot; usecase. It&#39;s about designing =
a coherent<br>
&gt; interface that works well with a large number of usecases, and other<b=
r>
&gt; pieces of kernel infrastructure commonly used in conjunction.<br>
<br>
Johannes, I read this as a NAK for now to the current approach from the mem=
cg<br>
side, is that correct?<br>
<br>
I&#39;ve tried to follow the discussion on the other thread, but it just ex=
ploded<br>
and some of the things I read there made me rather upset late on a Friday e=
vening.<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div></div></div>

--00000000000084c9b9065ce3cdff--

