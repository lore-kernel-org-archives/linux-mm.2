Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A3CE9462F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 03:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031766B0005; Mon,  9 Feb 2026 22:06:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21376B0093; Mon,  9 Feb 2026 22:06:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20596B0095; Mon,  9 Feb 2026 22:06:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D07386B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:06:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7695EB890E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:06:26 +0000 (UTC)
X-FDA: 84427058772.11.EC45E2B
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8CC2718000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:06:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HVIIVM31;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770692784; a=rsa-sha256;
	cv=pass;
	b=E2YOzCtMhpBWfxnlgp6D0Ps9hut0uMyI4sNZsZncdFY5mr+bvalguuar2JOmXOhKQmrX9I
	sM2iIwxV4u0FDIBgkjRfZ62soOo00s8wvVTLDOjkaXJgT1bL6RicfMh0gY/5twQTX0QB2F
	tQEk+ahSHHk+tYJNKHX0TewnU/IFk2g=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HVIIVM31;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770692784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zs2JbvSIqeHpuWlBVpOIszGZrAjqw0xVXh8hmXatvrY=;
	b=y95wgCE0bPbhSXiRMnZLPjEc5FPyLIe8Vshs3HTYa1V9Lm5DXrQ/UtqbbdHipvK+S8YLi/
	QHLjw4RCFFm7quGcN33ULQd0CDpWi607t70YnZ6TTGahZ1/gGi5JStF4MPP2XkPcS0JuaL
	3ELPCXf8CF97mIdloCReMKWGz67dIFM=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5036d7d14easo45308861cf.1
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 19:06:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770692783; cv=none;
        d=google.com; s=arc-20240605;
        b=RZpDbb8eceawju40o4QyztPKdtzoupX+4RVNnXjUwgwWzqpJAUwi6ghn5ffYQtay+d
         hTiKCfMe5LQtKBvY8mw1DDCu9jXE2jAwc5LcJps4Bzos/s+ZAwBpE2Qwym6sqxhhVYSB
         lOzBVdyJuoOgXCghdeGykiB9ceyCKxO1dDD+c3kWahwZLEYlyUwMCpkgnYvCkEWq36C6
         RAII4rrHkUpY3mnhWa12L7oT/5WoUVjBNXdbdOmgp3BdixwHvR4mTMnv3YQyJS+Z3eGM
         DbKUaBdOIFB3/YuPvwOEl88oly75mm7N7/RVOTCPx83vB2Yx+SpjKRRNyYmpXb2PpemK
         RKmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zs2JbvSIqeHpuWlBVpOIszGZrAjqw0xVXh8hmXatvrY=;
        fh=Ct3L8nwAunmHoyi75lSbPiMMpHbUjjgjV3l6AFF3Fw4=;
        b=hY6pY6H/ob1BPpvnuoRvgLAxvy/e4Bu+55zJD9jo49ZohBLKBntOoeAbGxzF7E0GFY
         YbCVookjxkrfe/WBFkkPUrUW1AFgnyaTddO5HTKGxrjHrjNaoHT/siu0C4hA4ccUz1/m
         PxdXgDyrJjuba5OFJRA299UsuWDFzeJApfWl24wZdTdHMl8b9sgXtXgb8r+FNJLHVxAV
         zuL07sj6d7SnyMeH/WZ7xXjUXXEL3idEQHbVfsy7qof8RPQLv+jnsCNReadlOwgGxn0K
         yB4DKr7C3VkP5M6efLgi4HiBsRtJ0kbg1wJs3LD1alMLuntNVIpDkRBfsZwX7He9CaEI
         b40Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770692783; x=1771297583; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zs2JbvSIqeHpuWlBVpOIszGZrAjqw0xVXh8hmXatvrY=;
        b=HVIIVM31f7ELRyBM6tO3hfI2vnEK2FOMhjS+/0jBuiuFixVnjrVoMj55Plz0MxF0GR
         h9FFv7dlJKJPQYsn56uSJQ1Kk6nQoijUX0+9AEzZOzAlcGmOT1XvLRgyvqGIMy5iOF0y
         c8T8GpvUdZUQCvOziw5VcIW96x4x3E1g8znK+NwG/aIqAiLUZiO9A/YfZoNmOoJMBh27
         /w6JLBEZxJnBBMdMYjzVppHc2xFV/cAcH2nV7WzgStx7w+uCDi+yfHMhXzKOzYFMX+3c
         2Z3zNr7+M7XX0DLUtdAbl2OPVi5jDsf/1ejEwZE/Bw0cuh9/x7A6rcuQp0cska/ubNe6
         oZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770692783; x=1771297583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zs2JbvSIqeHpuWlBVpOIszGZrAjqw0xVXh8hmXatvrY=;
        b=cascs/iByCBwGDISMykXaqI9y9O9HzvbjwpLBJXLK9bByV+lLoHN+69Co0ys25/hs8
         ItarvbIdwLm6aR22foa9ChsiFcNeYAOLDNDiZhV0DRDQAl8GXODC2p/CDIZSPudZ/iqV
         4HDVSlNadNhhP7EN2n668GGHHFqMNayGKguIBSc9DKK9OTJ+LcW8dugkIpsVqrHdtdX0
         NINA+uHDTgnM+IVHN4JJ10RWD7TCTIA6X8j83eqJBYoZzTMu1ExIAYjbsrzy2wCtXmCr
         E88CaGZfutWh7mqHphG6in6ci2XeL7hll5FoqwROcWB/bz6GwA2HEj9t4MtUyUMeOlHu
         tuew==
X-Gm-Message-State: AOJu0YySU4tZjPS56H/sZ5SOslxW9y0OuCbYKqrxSHNkF7X8BgGRSKb+
	YOLYe9VMcHo7tdJeDhDvaqYhVj00Gh8cqfMN8HQwPJBNvCg9rXvy+n1VUHJ1iI7vGaicYIDNxbD
	LEHlk4aiM8xsSbQ76m3GqAcwj09zZYK4=
X-Gm-Gg: AZuq6aKTQQLlqwnHymMdw4GaUdRohwFcVx3iUNnAdv93Il/mxgNs3vVpVg/gV9UInWw
	+hPaQURlM3QQQPySgMoIG2GdLEtagqJnvDoabkLsfg2Mf03LSzAfW2fpI++sV1o6xzxWTzQyhbd
	mIBCxaDkfG2iU2MJB2zv5Owlsi0ABN2U7iilOlxns2fL2YuDVReJHDSxULZrRa7UAeeF9aUBQ2n
	KKZS/+azltmCzszS9NMB+gJxl2o+AaWIPMzeRz4ywPXJQX6hp8nFx5oD6MaBD3yuikuOuCKlvTh
	2TIGyQ==
X-Received: by 2002:ac8:5e4f:0:b0:4ff:c5f7:ece1 with SMTP id
 d75a77b69052e-506399957bbmr161017941cf.68.1770692783468; Mon, 09 Feb 2026
 19:06:23 -0800 (PST)
MIME-Version: 1.0
References: <47d21a6821c4b2d085f7b97bcdaa205bfcb0e0ad.camel@ibm.com>
 <CAGsJ_4wgG6-FvDbLw4De0r_vPO1fTH_69A2VyntabmS6H5ZM8Q@mail.gmail.com> <83e395c84c9bfa52f1abccf12ff6d39547d6bede.camel@ibm.com>
In-Reply-To: <83e395c84c9bfa52f1abccf12ff6d39547d6bede.camel@ibm.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 10 Feb 2026 11:06:12 +0800
X-Gm-Features: AZwV_QhTXOQjAfDYIo7_EqjytxWr7_a25J4WmOIDz0_JDW-Suw5MsajhD5JzpZg
Message-ID: <CAGsJ_4wymvTimJrKoq1=PRmX6BMwKp9pRH62cQ_a06Avms-0XQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Machine Learning (ML) library in Linux kernel
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8CC2718000C
X-Stat-Signature: xwi4p4qotig6aehmuspm7zuyo7odux4d
X-HE-Tag: 1770692784-643857
X-HE-Meta: U2FsdGVkX1/3zjnsVErZ6UJhsI1dHA2QPEIBmk7//+gtfwf4YuS7eR09GQ38N2O8VqNOU6WIKR8V1S/LJSFo/iB5SqptsRRFSq6ktpqzI3AYXCY1Xpm8Dnez+Qxo6fJOtoeWUaMdXKZ4XdnujdAUYg3QHJYwDjlJq21vp2K/dxk+G6ZnXHNkR+LRZXQDD5iLtEw0BcRPC6mx7Bx7TipLSa7EvjwaUACV2NUUxY0szydDGTEYk+8oabc9l8puxGzN++CVX/YYDbjRj6qMuH++Vjtu4L01nT8njOnpsyCoi1pE9/H52qEgn0c9gjaLKtED0avKUw9Yb0I9lZj+z8kO4SbIb1srjUQzD757qy3xuiEHC4bFOvyaFAf9SO1VA1M6vQM2wEEVna3+/4w3iD5mpkJxV/UDllgZt4jsHrNB3oiOe7N2BMJgFfHGKH4/LO7pRiCgYwOHyNvCfwqdT3QjLu6KZ4NieSw+Ofpl6pmeDozufAC9EWJNimRZbneZ3vgyiDOmunLG53Ad7OXNLsuxWDRrlOyElI5DQRYx5mvZ/GhmmGH4FgbeolZ7tnInBiu/I13NwgQPLMtCq7wIqc8fqgacBg8FBxWdcfOYKwuVW1uhD9+LmEaEJkvPcyfe5kZDE9aE7dlKIJa+bFXDQgwAgyGqkA1YyrKZrwaFPIUVT+auwJaXc2pDE0sObv3IA+ijyApKTj1E2bcB1T61+wZ4aPxk1QxmkjJ8Es+zX4EX/xWrqkZ/15FkCQTdfOlGxoBWcepq6wxR4C+w1EsCiPKggfXP0WWWhbc5uWh5B+sHC7/eSV1tgqCetxrp3zJeINRS7K8tlGnSitlm1TUPE7LoD2v7xDyl0aJ9x6yu0sbtZmRPLD2xilzHYT5rSkdSlSmjJw+SdZB6RvGofZZMnwUF+o1ogCqQiqWicUHbwRndA07ZsxNJCDmA4DivcpttQ+y/QztWMw+wdTn3lW5JauU
 0Z1VE3wN
 Cg3rewxi8S4xBauAA40HwQsGXJrodE1cuJcZTPxj/Qa+gA20MEC8lYkFICKvfqXza3GroY1x0HXgm5SBgBKWYTZjYJTCLAsYB8e85cvyH23gt+kGICmveuWUuxFeCO6YTTHHBQxqYxyJBtdB1hDYmA+DbJEuPH46Y7okVqHNHXrVIlHtb7yRz5zyX6X5DGgViKmzNbD+dHHCZmcRNvhNsQEKhFqRU8a4+Rivud12EeOaVbp3jtaI3Mz8T1XYMnOGoKlNTldWv0QVGuhvtGO/qhGsmoLI9aKrrvph2N2GJL3vBgDcOAIziluvaNKAOExYOiHzOVb37+PcgHmW2DGu4ZleB+z5Y0sNWovUNnWOgLNJwahdiSI65OF1LXkkEBe7YOiu0vjZY9CF4anfhQDIIqVKaFXpKEhh9C5V2+/5UiQc0Lmo9sUwxYyRSChswRAGOFR4YgDBk+EmzZPxmEKW+fnbLWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 6:07=E2=80=AFAM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> Hi Barry,
>
> On Mon, 2026-02-09 at 18:25 +0800, Barry Song wrote:
> > On Sat, Feb 7, 2026 at 3:40=E2=80=AFAM Viacheslav Dubeyko <Slava.Dubeyk=
o@ibm.com> wrote:
> > >
> > > Hello,
> > >
> > [...]
> > >
> > > The continuous learning model can be adopted during training phase.
> > > It implies that kernel subsystem can receive ML model recommendations
> > > even during training phase. ML model proxy on kernel side can estimat=
e
> > > the current kernel subsystem state, tries to apply the ML model
> > > recommendations, and estimate the efficiency of applied recommendatio=
ns.
> > > Generally speaking, ML model proxy on kernel side can consider severa=
l
> > > modes of interaction with ML model recommendations: (1) emergency mod=
e,
> > > (2) learning mode, (3) collaboration mode, (4) recommendation mode.
> > > The emergency mode is the mode when kernel subsystem is in critical s=
tate
> > > and it is required to work as efficient as possible without capabilit=
y of
> > > involving the ML model recommendations (for example, ML model
> > > recommendations are completely inadequate or load is very high).
> > > The learning mode implies that kernel subsystem can try to apply
> > > the ML model recommendations for some operations with the goal of
> > > estimation the maturity of ML model. Also, ML model proxy can degrade
> > > the mode to learning state if ML model recommendations becomes ineffi=
cient.
> > > The collaboration mode has the goal of using ML recommendations in
> > > 50% of operations with the goal of achieving mature state of ML model=
.
> > > And, finally, ML model proxy can convert kernel subsystem in recommen=
dation
> > > mode if ML model is mature enough and efficiency of applying
> > > the ML recommendations is higher than using human-made algorithms.
> >
> > Hi Slava,
> >
> > Do we have any concrete examples where an ML-based proxy,
> > together with its userspace ML agent, has demonstrated
> > measurable performance improvements over well-designed,
> > human-crafted kernel algorithms?
> >
> > Such examples could be in scheduling, filesystem I/O, or memory
> > reclamation and readahead. I think having a real, data-backed
> > example would be much more helpful for this discussion than
> > reasoning about an abstract framework without a concrete use
> > case.
> >
>
> This patchset [1] is the first step of declaring the ML library API with =
the
> goal of discussing it. As the next step, I am considering of using ML lib=
rary
> API for implementing two real-life use-cases: (1) GC subsystem of LFS fil=
e
> systems (NILFS2, F2FS, SSDFS), (2) ML-based DAMON approach. I see multipl=
e
> potential real-life use-cases of ML library. But let me start from these =
two
> ones and, then, we will able to extend the approach for other use-cases. =
The
> goal of this talk is to hear the opinion of the community and to elaborat=
e the
> proper vision of ML library architecture.

I=E2=80=99m very interested in your real-world use case.
If you have any early-stage prototype code that demonstrates the full
flow from user space to kernel space=E2=80=94including both the kernel ML p=
roxy
and the user-space ML agent (for example, for filesystem garbage
collection)=E2=80=94I=E2=80=99d be glad to take a look if you=E2=80=99re ab=
le to share it.

Thanks
Barry

