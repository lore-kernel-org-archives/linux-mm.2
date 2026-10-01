Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A241CA5FCF
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 18:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76476B0088; Thu,  1 Oct 2026 14:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27716B008A; Thu,  1 Oct 2026 14:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916266B008C; Thu,  1 Oct 2026 14:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB3A6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:10:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE5301C32E0
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:10:09 +0000 (UTC)
X-FDA: 85274846538.30.D62680D
Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id DA1861C0003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:10:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=itlKdb7C;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790878207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4I2Vz+ergA4RSskvAHqukolmbBD3+Bn9X7EL+PvL96M=;
	b=sfCPrEvnyiB8oT7GIIPgz2lOCyi71Zl0KOcyoWi71YOmWgU1u1Eq4I5ytVHmf/+khBF6+/
	3QG5qKX6ksqPc1qtMLf4q+QGjmwcFvnFG82nhKI/fajJ52kJbKBrr57oU3SsrlOrwAtX4g
	DPOGfdbniQOvkngLbtBBo1RRO+wdc7Y=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=itlKdb7C;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790878207;
	b=xKUS+znjwFHwJDB7jopdsgencsS4vvYfCuCI2+mfGqO3y8iGdXHdzWE8J2n1xRCvlG637R
	uGMuJlazhvSrXIiSvUKONQufhnPZDRLygQC1++zY1ldOFpMVoVlIB7WEueWS10K4jt066R
	j16YrQ8nH3imDf1b+Kx90YOpO2F7bOY=
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2a8b9acbc6so1060925966b.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 11:10:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790878206; cv=none;
        d=google.com; s=arc-20260327;
        b=LHgxLdRkG7nrjaAT/OHFKCxjsbhtgj7sjgcHqxz2OTMGbAHqylhrulSAjJUBoCfMxu
         gHB94FgDoLfaoHbu5EBEBRAhE0IYlpFymJzqeYkMDWBzNSzKZuQMsZbDZy0W7N62y88z
         6SX2vmP4xF2p5/JJ8BXApP3TWUd+/pPkOBAp3pqCtNHqmHc6S1PdsUjPfQkJbkSEoYlC
         ztYbOlfPbxxCOyrv2UcU/4vppKIbfhIjvqk/uWzOeTKr5cYocbOCZHWQ+4xVV+b4eETE
         xC7o63BMZq9RM/EBAKcnDq98Yfhd7rA7Jkf3J+D190U0hzs4zI2YVQP5Hu7gmuhh6BDp
         Ruug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4I2Vz+ergA4RSskvAHqukolmbBD3+Bn9X7EL+PvL96M=;
        fh=GfE21J4UFF2rDvsFkdcXULoy5G1tsa7U3doe2O3W3SI=;
        b=kcbpHUgHMid2K1Olrdqed5ZHGKI1FnTn/dP9THyoJGE0qa4UL2Xhetcc83SZI7ksJW
         ryQUykhGFeef43dkDvFO2Nt8PgGaxlAobLebYwy12g2mlEBAlnJfGlNFOe8C+qJo1EyT
         RTEo7JPKhhYfJ8JfywqoexAw+Z7sEtHmC+1A4w3k+se3nkfTXvAopzDSH+ZmIql6LuO9
         S7X6a1c5nS/wVCj32ux2aq7eMZ1G7MUeZnWp3zg0D+RBYjUcoOuWIzOpxaXhIQ02I4Au
         ofRqVnmJf/oco68zlBxAbdziRa/otpQ1+Wx9FLEg2D2kPquoYl03iEB+2fjb2mgSKxKz
         hMpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790878206; x=1791483006; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4I2Vz+ergA4RSskvAHqukolmbBD3+Bn9X7EL+PvL96M=;
        b=itlKdb7CqYaZzSHNatExmRBsvHhTelY3dK8Xndr6TjnLCceEHN9jxDkdvOYi4JtwE0
         4U3RUVwmGMGn4r2MFgvahXOCW3I3A82QCCzQ5nvWp/uergTDhu0EuWfpHyatQwyDitqK
         iDn7STcVQsHY62mb31VlKkETTCYQr5iJ1+wQL9AytfciPhY1mWtw3TEX6zoFKNqJ1LcU
         bTKfxS2em2rkYmpWrv470xhg/QRK+AiaqKEA1YG1fei6M4/aDxkG3B5oSomXlasSl7V2
         heIavX5dmOiLB74VcWNiuG/kGXcBsTyxn0pLpsJUBTmDI45vpshzkf4rNIXjcxccj6GX
         2xYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790878206; x=1791483006;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4I2Vz+ergA4RSskvAHqukolmbBD3+Bn9X7EL+PvL96M=;
        b=TQ1DREMZmncK7pVavXLcXeelJzTAJAwVLFox0DcVU1CyIARhEqG1TXI9sB7jIPaF1a
         ioABAEjyDHZNWx/EAVsYuIUImjcnF5AAVLnTS0U8wnn8tWSaxN+L43odQ7EqFWt1+OnC
         6VX0fPv2EnCdG+H4qE+ujzeN2+wCXfuxPkL01qZicIIgNtfXGH0Ntm5VcTqu1Q3ZSMpW
         5z7e0DZO1bl5aKTsB0zttNNH+5M0+tp31Jpxs4i/9vHG5BwaSO8w7k8jidJ3YAwC/8rP
         JnYb+KXU7jTSC74XmAZ31pEOAQRUfGYijRUUUEI2wK3KrHrE41HV8XOcX9M0Iv6uwrQg
         VIEg==
X-Forwarded-Encrypted: i=1; AKwUvBy3L2vpWc3JG0IWET7zNdr/18qX7O1shfZmokxvccg6G9fb8rce0LOHFyXP0tst+oOximfzk7C5Tg==@kvack.org
X-Gm-Message-State: AFuF++lZvXDJWAEB0zf/rZoOkV4H/S/prP/Y1X6CHWRWsDQGQSJ8C3a2
	ztnIPHL/9DAMy70ccqh7ayFYbDYWRKiWnS4S2W/Ps8jVfjss69Y3/iOhPq3xrTs4I8UtujeeKEi
	jcebtujxB9XTY8+NmLoSkE0FXs+clma0=
X-Gm-Gg: AYBFou2OrVwct8FjlnWdEYS7/+9cF9pcYafnTF1enf56fY2bIcoIlXc63V+17oqpPPR
	fXCRRXnlZSFUeRHt+BJNgK4zyv3q7VM1LLhPsGBKY85cvYLKi6E4RGlj2ir6xhhjeAOyv9B2RUq
	sDxgWxjWLbHFKxcpl9+Y5UCFymmGGWR7AbwKvU3/iwBbpdyRV7lagQ89W+30Gc4bdntk1RXXDGf
	aNmddgKUKN7h8XvYzMmJFfLSm7tOm3T7ld/YqzZkYMdeFpm7U5Z+HhRRUyEXfGo1cWMP+LfFThb
	mUzawVq6679gx8S5ULgvRmrr4ooetjmTqfHRl9f5xgzAYGiI2nry7URSEE6tmpFbz4QHrAIWJAZ
	6OAvp/HJZZLpE
X-Received: by 2002:a17:907:3e93:b0:c2e:40d6:25e2 with SMTP id
 a640c23a62f3a-c2e4ade8986mr33476066b.12.1790878206125; Thu, 01 Oct 2026
 11:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <apcVhWzEwkwHYjB1@KASONG-MC4> <20260901220430.79810-1-baohua@kernel.org>
 <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
 <SJ1PR11MB6105505CAF620B23978FBEF18CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <SJ1PR11MB61057EF65B62E06E2C2049008C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yHZ5ck1hk+Lo-7aQudApm0Nx=4yssUDrRTz681PuW=tw@mail.gmail.com>
 <SJ1PR11MB610584E71CD980C9F85952F38C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAMgjq7CMd7v=kYwWGSyt2LmMep6tQcFFsdyBpwc_X+s_Km=rZQ@mail.gmail.com> <SJ1PR11MB6105221B1EC807109A380C6A8C8A2@SJ1PR11MB6105.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB6105221B1EC807109A380C6A8C8A2@SJ1PR11MB6105.namprd11.prod.outlook.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 2 Oct 2026 02:09:29 +0800
X-Gm-Features: AclHuK-a-3wgazn7n0gz_axw0P3SCaylrim0PItrMHLbW1XzCPxBGTrFy0VtYgs
Message-ID: <CAMgjq7AsLfzgkCodhjD=rSoeOSmNqG3E_7qt0egvy_nnDNNYfw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
To: "Ababneh, Ehab" <ehab.ababneh@intel.com>
Cc: Barry Song <baohua@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Lance Yang <lance.yang@linux.dev>, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9tstnhjdf76wi3p74mumqg7sq8kxz7wp
X-Rspamd-Queue-Id: DA1861C0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790878207-11745
X-HE-Meta: U2FsdGVkX1/xdBwg7tMRj1AOGBUo4mGlcFj9Yc7IOqcvLhk2GifcnH3wP2rMKkrVN5KDz2R9XEOV7AjdmmyNh6RW9rAqXawqhNN0CEAoSQq+C+TUcQqGNwIsDEzlbKTinB9LUBJV3wnSricbMrV0zmN3ovVYbHvk2G76xe8910QZ77wT2NloYOgM5TfiJ7ei8b/D0odtHsUaNsWYkfj7oBM0GeOsyUnX+rrjMtNJDiC1UVqeIjiDxoCkDD2Ut9bdIRuoLEiAhsRTGy32gzO3+TaMyF5MnhKflamTBzP1qN3zKCfyXwCUHjrRYH5QVthVWdPrhRbeTzvVcoQzVYFG+DzokZia8DxsuXE6DCc38iSmqCTd3xua4+EebFGRZvZg/oOMa4PFVAWW/MWG4wp5JIzBhILShmnmSyKDGLYylREnpH06UvvIUp6vP+PtscCaLjDO/n3WBDMQzI5KS9dLoxh/kUfVGxRAmn5ANhyHBGMZa1vHbl0h7gnm4n8yblrh9mhHB2Up9x2NO6LWZRHAlAF5Ahgec0M8dOg/nA+sIKImnECaix+yTncsVWFL/VtWqpREGSCK4SENurBlOLr8uv+Sk5a2GXPCelQjkhH4dEXQ/UM/Qfj8crPcL5l+b/en8WSfEdJ58WKyROOZOR8BKe0+33geQENopowKbN5smupz1OWAgKP+R119V4+kt3PxqsBFc3KBON3ejbhtjW6AYFxh9fcPxYxpcJ2yb1z/Yhfe4uztHHDuAX0mqw1lW4SkZoGsluqsu3q/0hEbilFEfi5495W8iysulCXTzkwl0sZyhJcsgAyjkJIXWAXBEYqHzqODW4HiMH3/GiJ+fNOSSeGYgKi8TCJRRgWgXIygez+vi9T+gA2MsreMr5MW268S/AZL9V6VmY2E/v8de0Z+gB/LhUJUdtYlRSFCAtor3+is2+SHhycJr6BAW5e6X72QlDjE9BeT3x1aIXLLOiJ
 xHcf5Ts7
 pJ80Rfugz49Vn6AWz+iBZvhq0ZWg5QeIg4vwbkYSoUrd8Lcc2Vune4n4zU846uRxSyg2CCyjB18oxYFBClpTt079dcibT1Eg2Q5g9hsEMZnZh+HW6lvwlLipHGLgdJk0QSl1HxyBoaOEHMW9cqNYOzw0xqDsM1rjWIBHTmKoLTXhHrl6T20mVBKsrjgTfkNo1Dnbn8XPny5aFkOjnk5RhQ8crqhI3/K4YG41prZI0qS5in1QzpH151lTfjKrDORQbR9dAS4ymotKwEXEU1H9MJ7uv7dpjI79fyvKz9yhNjH30lp9XnPJ4G7bNU5tDJbW1JOhZKAZ8iRcgiASy6UhMHfxvBk7CwwyvfTqN7VVExbdEnKRe0RhqSY23xWs/0ckq6cforQ75mBQembOJDbiHJ+MpvaXT7oxGtI9lE7KC8KfW/YysWTsmBw08gXxQIWEPYVvuUZF9TwWMp8LAFvOAHPnNW6w9X3x2SoAyfZjkB4ZCJZYFw/F638TMGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 2, 2026 at 1:21=E2=80=AFAM Ababneh, Ehab <ehab.ababneh@intel.co=
m> wrote:
>
> Hi Kairui,

...

> > > > > Results with MGLRU-FG:
> > > > >   Op rate:                  55.0k - 56.5k op/s

...

> > > > >   Latency 99th percentile:  6.8 - 6.9 ms
> > > > >
> > > > > For reference, here's where the other variants landed on the same=
 setup:
> > > > >
> > > > >   Regression (6cbdd9726fb5, "mm/mglru: use folio_mark_accessed to
> > > > >   replace folio_set_active"):
> > > > >       p99 ~9.2-9.5 ms, throughput ~41.8k-43.6k op/s
> > > > >
> > > > >   Revert of 6cbdd9726fb5:
> > > > >       p99 ~5.5-5.6 ms, throughput ~51.9k-53.1k op/s
> > > > >
> > > > >   My dynamic readahead-credit fix:
> > > > >       p99 ~5.8 ms, throughput ~51.9k-52.7k op/s
> > > > >
> > > > > So MGLRU-FG recovers most of the latency regression, but the
> > > > > revert and my fix still recover more of it: p99 with MGLRU-FG is
> > > > > noticeably higher than with the revert and my fix (6.8-6.9 ms vs
> > > > > ~5.5-5.8 ms), though it's still a big improvement over the
> > > > > regression's 9.2-9.5 ms
> >
> > Did you test the V2 or V1 of MGLRU-FG? V2 includes Barry's aging
> > optimization; I'm not sure if this latency is caused by aging or maybe =
some
> > other change.
> >
> > And is there any swap device you used, or is the test using the same ba=
se
> > commit? MM also changes significantly between different baselines.
>
> My setup runs Cassandra 4.1.5 on Java 11. The host has two Intel Xeon
> Platinum 8468 sockets, 96 physical CPU cores (192 logical CPUs), two
> NUMA nodes, and 440 GiB of system-visible RAM. Cassandra instances
> use CPU affinity, with memory interleaved across NUMA nodes.
>
> I run four Cassandra instances, each backed by a dedicated 3.5 TB
> NVMe drive. Each drive has a separate mount, and holds its instance=E2=80=
=99s
> data files, commit log, and saved caches.
>
> The stress workload uses a pre-populated table. Its schema, partitioning,
> replication, compaction, and compression settings, along with the stress
> profile and concurrency, are recorded because they can affect performance=
.
>
> I used more than one kernel version across my test runs. The most recent
> was Linux 7.3.0-rc5. Within each set of setups being compared, I kept the
> kernel version consistent.
>
> For the MGLRU-FG tests, I used the ryncsn/b4/mglru-fg-v1.8 branch. The
> MGLRU-FG implementation is commit 6bcf4ae70b5e; the branch tip
> is a619ab0105d9.

Thanks for the info! That v1.8 is missing recent upstream changes
indeed, so aging could be a bit slower, causing the jitter. I also
found a few other minor improvements doable, I'll also try to run some
Cassandra benchmarks too. Higher throughput and worse P99 is an
interesting effect, I think it means the LRU is doing better at
protecting the working set and maybe spending a bit more effort on
reclaim / aging, which could be optimized away. I will try to
reproduce and optimize for that as well while keep the series updated.

