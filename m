Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 682CFC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387516B0088; Fri, 31 Jul 2026 11:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338166B008A; Fri, 31 Jul 2026 11:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2289D6B008C; Fri, 31 Jul 2026 11:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF3EB6B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:32:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 733921203A2
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:32:51 +0000 (UTC)
X-FDA: 85049464542.29.93C9AAB
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 877E840009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:32:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=StdbXDVG;
	spf=pass (imf04.hostedemail.com: domain of jyescas@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785511969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Og28EJal2HRdpRixIOxym8Yv6FToPTm6F0XbRorTPdM=;
	b=ae0mbAe7Rbqme+qYCg4UMzvQPml7UWJdv2nFIqMrt+X3HjVKzNWj8mOd/e30r8OIUjpMBD
	jR7I/ViiqYt6eHIrbytBGwD88Czfv9uQDEjvK6D25eIO7o/pWucm2hMxukLROz9kxhC9v1
	oQTn/cSqa/PtcEQe0B/rLMm0n0aiRhM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785511969;
	b=HcZsXmCGNNdSRboh+wyN7VIThExx3OxN39WGFxKTmZ1ep4bdAupzLgnYYuXnqYu2YltfuT
	QDThWNilDQSwpmoX+CIDWGEn/X1684DMSnTC1XN0AD65cQ4iEhq+eFSIZn30VEGPzeV8vG
	FYWCikBGG1CcYxM/f/zIpDZyEzGwXHQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=StdbXDVG;
	spf=pass (imf04.hostedemail.com: domain of jyescas@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso10279e87.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:32:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785511968; cv=none;
        d=google.com; s=arc-20260327;
        b=oOXQKq88WcculANrR1hZM+raOJAkk03D+c1wh2bqAYzcfQgQT8L+CCLTbU8vvUCh5k
         1taMGUZE6OjRAVZdphe6yObcSW/8lS5NY7riZ2JSQ9snGTvmf6DoY60zdf8D/Qp9sr6o
         r9/kiB9JR2jmPlyecPsRWs3kRLn49GeWV2dP0WwJJpZG4Ojp/eaGZcahvcL9ZGM7Q0aD
         2rEolLAlAn3+vB1oVJpGP7RdLsduup0b/oQBFDPS9Fd+JN/PpBJ78k604ljiDrn5B3nE
         a1Da2oAnGspNUlwAYfKRb3nBSxT55yoVFadth6pQha+cDpFqznM4w7j+bwk6VIyV2GlM
         N3CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Og28EJal2HRdpRixIOxym8Yv6FToPTm6F0XbRorTPdM=;
        fh=tU6GV2IpKtbY9FJfXZC48AxN7daE3FcOKlbrjJaRLt0=;
        b=OLlIloI7nUowtQ11dRAVgGSsiBK0CklrxNFXSw4TZj3gEGk+UGYxedzISyIwfAPjiQ
         x1CR/qvY1JdItHgNVKTExvK3W3r+fsA8Iv16Vl2ZrcD91ykO2evDWAxWY8ct3ekMEIMt
         /zrP/r/6FBCLaeJ7OXBELZ7ew3PT8cos/gAj0cxhgrZNrxpDNCg4DSoI6d7EnJcPgk8N
         lKOZVEW8PosJfL8MVorDEebiRcdqpxVYquCFOrP7obvlo/loaHXIFcGymvtL1+YrHXB9
         uh3RYKX8OBajTeM15MjN9r3sSHvGvBXlf9Gprg+q9+u0rhGoc0ggVwVNnL4V7I84CP0S
         T/Dg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785511968; x=1786116768; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Og28EJal2HRdpRixIOxym8Yv6FToPTm6F0XbRorTPdM=;
        b=StdbXDVG6lYHpexXQgq4qNcelpxi259IMD7rk2apXvr6zxalP1b47LapLylQ+k4wm6
         e2zNJXxc77I8VDg1+fLsLoXXNrmXGKrtmIViLz4iyhMWAiMdo85XjpZIChJby5woAfOr
         ziiUE3GhzYB3JHaO9G9CvUM2t2n2/U/0LcxC8x+uOeKu06U12eMazAi78j2841v4lqGM
         P7g84PkxfRUxaZD+hi2IYrPcGXNqegCoQEKq5VgFNnT62qT7jrGn+IbsHodhpIgXSuGw
         Eu/Jx6f0DhTWzaUVhPAQKloDSbPQuxIxKdCWZFIFlPY6teiLm/oiSL3x4Oy5UonHQ4dh
         BR8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785511968; x=1786116768;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Og28EJal2HRdpRixIOxym8Yv6FToPTm6F0XbRorTPdM=;
        b=Rgs4uSO4ORtgl0ieFXHnvCYXZk/qETWKBqYWX1iWSDjLCTVitdFAggGf5GHHKEC543
         5VR6s+2fNNb8SR1juJKO6uRbDU7dM6JpoX88Vns5uv8GFzuk1H31Vma+0QQOnlCl9XyB
         eRQKv+KBK9bEie7EcwwOaiv9+HOacs5QEr20Wp7XHh6ABovi8vYRGOI5wGR34n0zfUN+
         PQ5Loa46qkdU+YCTUEQVsDMUhMUnQkT/Ajtp5yM6lXvH/7hGX70QbvYQtssbiuhGfAEk
         pKJuavpKz5H+rxXS+XE6PRGEa6/ahJVQsIVcmxMjN94ABJNgiW0xoAh6gOkaJiS87ctu
         b/wA==
X-Forwarded-Encrypted: i=1; AHgh+RqndNbxqB0/iGRwV4mZ43CePET0+vjhnE8veTEuey34biaVOXV8TMaN4/4f8Z90Ud+CljQ1vXlkgg==@kvack.org
X-Gm-Message-State: AOJu0YzeMcVe2gsaJZrTOSnC0VYZfsk/dbqcdt2LyxCHjn+6XTT3Eh/k
	HO7gS8MbaIgQqjdTTUN6XWvXXw9UA9t5ORdNqe3oxNbLgzK1DfbMR2bjziiVvw9zpp6S4mIfL/3
	0S6hzMctkKsgC2GgeUy4w2ZQPgeLuQenjj3bz5idH
X-Gm-Gg: AR+sD10xLhmhCD5+pYMFBpOBiBArYE12z3D7g8igsRgzojzH1qtIQZRQhXrG4fBLj3K
	l+iJbGiSSnZEda7rZ5D/Jc8ddsgIQO3qmqSCVlEJS8WacIc8SS1+JsnqUsKNk1TJguQg7+pu90n
	eU7qhwRaSf5/9yCHKydqIqY+iypIOlwKJdT366va9o7fhBvsmHRrmiWSkYIymW/XZpYHsjyW2k3
	XF9OXK6EdTjHWVNZYmHTcyKQJhvS/CgUUBbfZN1ok4Nc9i+Qr29Pk7GcHzRxcv3nmwaBqtruWhZ
	T9V7wdMnuX69f/8wZtBTN6Mxqxqx9Mhf7HVOcplgcN3UdjVcDbGZOmCO2RIeEW2aSIw3Bf0ogvU
	iqAyUKs90LY+qQg==
X-Received: by 2002:a05:6512:39d1:b0:5ae:b918:79d5 with SMTP id
 2adb3069b0e04-5b2e1fc8fc4mr126235e87.2.1785511967252; Fri, 31 Jul 2026
 08:32:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com> <97605949-82c5-49e0-84b6-b42e8078b55d@kernel.org>
 <CAJDx_rjNhiS+J9eDkQxPF6B=jJ-Evr-M7NNeS_QcG7XWNDoEYQ@mail.gmail.com> <amsCEe5qDn7CPWvF@lucifer>
In-Reply-To: <amsCEe5qDn7CPWvF@lucifer>
From: Juan Yescas <jyescas@google.com>
Date: Fri, 31 Jul 2026 08:32:35 -0700
X-Gm-Features: AUfX_my8G6uF-Wsdft4vIJWS8Kd-ZEk-4ccuTHIHTPpPcTWuMiU5H_NuvVaIHI4
Message-ID: <CAJDx_rih=0qWpfsnOQYbEwgG1OgPEK23MacTUsJndjiNLV+CGg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] Page Alloc Hogger
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 877E840009
X-Stat-Signature: 5ox1fsx9rf55ey68btbkmw6xk5z37416
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785511969-584190
X-HE-Meta: U2FsdGVkX18z4eJ77JVjjxCpTpXtRrCVCEvEaWMNQIv8dqp7xDDP3oLvgXDK27fxU2XzJoxgtf6cmIe0RQ6jYTAFHs+abFnKdNsXDygxbz+/Y5QCDRsti05SDknX8OxTwrft0SKvR8GRa0V9/rdoLdJ5MqhL1Wdf3mqD13/nYuJ9c0VhV/t2vp3Iz5GKe6Q3bxllNafbl2WkVL2DLDt2UI94OyN71uNEsrtcvCrTCFYW8IoxFw8hcOOmjxTPqy9zAu7C3c3lmt8b/PAIrX34ctpHTFUCar2NAlkbRIjXuJyIEFUdb28YDvGClJponLRNEQcdcSntJKNbYvDLVyB6PG+jj2ThtDt7+RLHGzE0UIKRXM4B1JDyCSyJVFNEOYjUXsrCFCGNR87Ld+7URpuwadmSaLdTa9Uf7vBWa8tH7vpSPSJmo/H0HKSsKWf1bozjMicqD6Md4O6oBuK5AIgMb/Oow4e+AFED6hBRNv6W66vvwYebQTiLlaVlRbPGcfuzXTB3PK3RVPkGsnAzl2waKkZ3bpQXmFXLzaX4+DQWlBQ1nz7sP6jFZL0rKs1l2zgXlqi5Bj+wzWj5Tdq8OUrF/JpaFFZyT/GlWmQahvPXGsbDUYm5NOwgDUc2Rd45VoiSx8q7Ds5139REK6upFEXYegTucvrnOaybH93PqTaj6XL0SDfR9CCJfgbFHylHjjPnODbGJn/s3+zFHWoLhH5nw0Fe4SQo3PXWgOp2QlKmW8B9xPOClMf6Mu8ZS4FQ6HNNWxiG1lX3VEUGYKxXyDW/B+CUnMFg42GBnteelGgojJvJDYrB6dxvL9fquIrtGwdfVBZDrOFQ1KgvrxXUuxC1uNly++4UDm8LmuFMkKAoqfHkc4XbVOoE1muyHh4G+UepS0O0m4+tM4X1nP8sLnJhVH8fj+G3OCVeZWY/esI51vjiovUi3OzThdcjCrgpdWXD6HDWuhdY3o4sEPcBd2W
 nl0k2RWO
 vQMvHrybYRns5ZEsnJtrGBSW2VemDIl+kRgVVJMba9zQklZasJBHO0Pe2zMLGjmFA5Fkwbs7+zBR9Xj5Mu1WZ2sn2xHcaK+iBSa4IWh9+0M92ztLiW+MtRyAtbA7+4uljo3uzw7CRiXBHm62LvEzZPIuqlBW+Z2NKMi0H+nna+/e3Jr45TcsKXJoRQZiqRkNa8eT8pbPL+ILtiu3xoOtD0ijynQyemjNkXs5UPI6mHgJ3HQPOBiaY/SFarD7L4qzw/C/2Sd69G0TyjbOyynupyHd0HArG/lprjCdjHBnEUK9YI/Y2IMsOsXX4M25inJ/6tDBJQJRidbAUml8HHmJl5tAUYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 12:51=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Tue, Jul 28, 2026 at 05:36:03PM -0700, Juan Yescas wrote:
> > On Tue, Jul 28, 2026 at 12:29=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 7/23/26 09:47, Juan Yescas wrote:
> > > > This patch series introduces the Page Alloc Hogger. The Page Alloc =
Hogger
> > > > allows you to allocate memory pages from specific nodes, zones, mig=
ration
> > > > types, and orders directly via debugfs. This provides key benefits =
for
> > > > testing and debugging:
> > >
> > > Would it be feasible to carry this as an OOT debugging module? Would =
a lot of
> > > symbols be missing to achieve that?
> > >
> >
> > Thanks David for the comment.
> >
> > The only symbol that would be needed to have this module as OOT is
> > "migratetype_names".
>
> I mean you could hardcode these and be pretty safe :) I don't we're going
> to add any time soon and if we did you'd probably need to change the modu=
le
> code anyway?

Thanks Lorenzo, I agree, the names can be hardcoded.

> I feel this debug module should be a noop in core.

What would be the main concern here?

The reason I wrote this module is because my team and system teams who
work in memory,
have programs to alloc/free memory to debug memory issues. These
programs are not shared and
depending on the memory issue, developers customize their programs. If we w=
ant
to allocate memory that is not MOVABLE, we need to write custom kernel
drivers for that. This code
is reinvented constantly by developers.

With this self contained module, we can allocate any valid memory from
any node/zone/order/migrate type
without needing custom programs or drivers.

Greetings
Juan

> Cheers, Lorenzo

