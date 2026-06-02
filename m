Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545D3CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 22:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44AB6B0088; Tue,  2 Jun 2026 18:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1C236B008A; Tue,  2 Jun 2026 18:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959186B008C; Tue,  2 Jun 2026 18:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 859A86B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:27:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3480B1C0531
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:27:34 +0000 (UTC)
X-FDA: 84836410428.21.7AC54D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2FA89160007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:27:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYuCyZFu;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780439252;
	b=5Oq6ZUjngijc1YatWideXQwyIMmUNSo9IDZ3PO8dULXP7vkVNfKNU1F2HW7wEaZ0fO2q/K
	WlYcQZvUOoVi6MTzey9XtQtOI4FJdJFvAUbdmL5hfF1R3303aQXPTQ3ZzEBLt7tewzEqAQ
	1l7rFJwrU/Fhwnioe+AUAg+EwpbxaZs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYuCyZFu;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780439252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPiUnyCYQyu+QmrL66bVqUiAaYmsJXs+ruL81nIq63U=;
	b=BdwF/cSsLAFZ9ceVLMjLAN1MilmebOdB78Er6ljCr3JEZE2iv00rv3cQE+h7hmqigjjrrj
	dvYQnxz5eWTRjdUHEP/njRxAEkBNtJh3Q7rNseWJQyQcf481DghQSTPjHzsSHLi6tYwuUT
	XLdMvWTwy9+ReYSZMpjjr0tIHHJaymc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59E2544634
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0F21F00898
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780439251;
	bh=IPiUnyCYQyu+QmrL66bVqUiAaYmsJXs+ruL81nIq63U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BYuCyZFu4VrF0CEJSFaJM/ABaX2nQQVoc1FH+40z4ue4ec4N7KgRk10owK85AKvSh
	 mwVfwpZRZt8pP6Xl/wEkonX0YxFAdYKfVuQ4FkfXhwDMLvDfUOJCtKzz8lQVCAV6hc
	 JknjQy1W1+C3L/c0dxnrPNQVcC5Zm3S0Gcv8JYIWEiaNJszr8kvdZlM7DauUlcvtBt
	 m4QEDmschH2RCmh3+OlaflVFFNtod3fufPXivuCnSUu0C8tdxWdVcflDvOQT0GVt+H
	 TPxvWUGEM4GjXE0U0N8qTBl/HAYqgPMRyBC78LuIoyqDFMhU9ywUMVITNLKlpmjrue
	 F3xnhnmiLgkbQ==
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-59cd803792aso2580883e0c.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 15:27:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+SSo47SPgVhtFi4cz3KbjWR/49D1jBCLqaeVb0n8tINjt6k27LRcxG4nG9ixj4XwrumEqvzAONSA==@kvack.org
X-Gm-Message-State: AOJu0Yyud1KKaC5P+FC1KNA1Sqa0aER8gERqVIDHq6xXThGtUuuKMXQT
	6pRXtilVDoKn7e1qWQ4EogZFcIug/6vhCw+nUR2rVB6QxMl+F9QSefhBcU6MGVPeFl05G41HSLP
	lR1Aw4bvDiYa5lzO78+YgPyXFMYYY0kI=
X-Received: by 2002:a05:6102:4191:b0:631:b365:40f6 with SMTP id
 ada2fe7eead31-6ec733deaadmr286422137.23.1780439249968; Tue, 02 Jun 2026
 15:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260527110147.17815-1-tao.wangtao@honor.com> <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com> <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com> <ahlzj--3Gm5pD9ge@lucifer>
 <a90bcb0fa3a044588350e92a78258a09@honor.com> <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
 <1fb6a226-2899-497c-abbb-eb49c3a2f306@kernel.org>
In-Reply-To: <1fb6a226-2899-497c-abbb-eb49c3a2f306@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 3 Jun 2026 06:27:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zyO4bWmjBEjeqdbDo_hgEyEQuSD6ZH59=mG9BdwirfNw@mail.gmail.com>
X-Gm-Features: AVHnY4KyJyCedUIUa_arn7DimqNML6DLaItJ5RHt47reA6vuXBGcpLeyeVYr68w
Message-ID: <CAGsJ_4zyO4bWmjBEjeqdbDo_hgEyEQuSD6ZH59=mG9BdwirfNw@mail.gmail.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma creation
To: Harry Yoo <harry@kernel.org>
Cc: wangtao <tao.wangtao@honor.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>, 
	"riel@surriel.com" <riel@surriel.com>, "jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>, 
	wangzicheng <wangzicheng@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2FA89160007
X-Rspam-User: 
X-Stat-Signature: 89qo53zqqeuouqdtpsmsx3jwi6fftbeq
X-HE-Tag: 1780439252-904618
X-HE-Meta: U2FsdGVkX1/XtfV5kX0f8Ex54nFx/kniZinwU4rzLsHZh/sU61LvHYNQyl8amjbe8oMkucDTUinEC6zQfWFlR0AqupSu3lqViPrrOH2B2+MTG3Cygo08T7+/N1mjDZ5FIhVyOWtiwhcf105KHwNblbbSZ310j1wI+rs9GPMr48GKj27kTqsLNb1xraB7ORouG0Zrrp831k0v8Lf+NeS1SbCKkdZY2jSPE8QyDaTOz0wU74Rdpipf9XulwHtjppQJcZ7JbZfoYmCfGALeXilBGG6a9PLHIo4dO0NISlpm3HGjxWhnqWZjKHcb61cypYmApbwRgNdtNNHmWLV1ySU/952G0pMHif+ac8dKK8UfjrdWYabBzbQaFnsrreD6kavxJs1LcGQxfCvOP3Vr9DCYL6PWJa4kevVp3s8ktUDrC6q2DifXoUm8kok2QZZH5UXt24lPDIM6psuX943dmYt5TmUnS+iHvXrk5P5J+TSWLWPAAwy/u6R2Ctj5OyVMjdFiXBB1w//9XTLjLsV1u0Qc9T+BGa4XT258ETLC7xtER1tmlmdwD7tCmfS6T4Z3Yo3MSEkUC7Z+1sRYp88GUqgCbg6uJB1/P9Yr3cUM8Dte8bNsXBXHgLbJ0TXF8vo3p9Evob1w6skQL52gQMn3fLemimmyrniUKf5Y5YSCnesP6mlCdK3zJE5qKynKZM6eNctdvjRfb+ztn+QsX+g9NrzhrXFzb/7FyatTTfmREB3O+rbAAEPw3CmkGZbll6X8eYRdnijqAqh/EmbCjzbhUiabQ34jRTAdM7QdmXCBeV5tPUY1NgWF8zT7ndspXtkozX8A4ZFAa4lYIG9gUTPtMy60M5DbfLHCCVWfP/bgKt8zKNyfBTSlu5Q5dIgvd1oYaETAI11BdTCUmQg8eMc9tpfAM3BNyF21fF/IuowQaDc2GTVTkrtdoRa3xfhDWo/+eFzplT44XetxKyLRZUbzP32
 /BYXRQLE
 PQ+1ESXkAnHszlEfFPkWUSK9b8SX/LlKCUCxqaPFE0dHzKq8HgDUOCqjLvNSHeVSXNjtO/fuzSk9CgSRXgOR2VoPwcalDzMVe73T4GmRDmbjRQRtH440AV/iszte+XlAFyqI5xVdxi/SmeWAiZVh77H6RILVOhcbHbaSzqAv+PLNtUddMiIfqiOJ9O7uBQOedgG8hkfC2+CYgk74rHNCGltyjo1eZl4HD93gWyqATjMtrSJgeUuuH3ptnShzlFlxDhbr8FoqdHFgZhl67UfpJCDBVmRBdJjpIUOR4W7Rm8ZU4/1xn8mPDRpohFmHuLr6M9CnXJomGbRiwSTMQVSKkVoZJegmZqOBB3DNgRtQURamQTX/RUaj/Hd1rd/UDlbo3oULJfYaCdKCV4Nzofb1O4g2E9G1FSRoE6UlYTXAZZOIhUjdiIh6WG0LbEst97oKjBfAXYdVPW0GkgEMtRATBrkjYG5IQgBPoJ6Dqev5Luj+ncZmuoAfkZou22P1JhMLvTYeelxqtZQe3yrNpH29018TpWa4TDAFgsuxc5xXOt0Gi0Gr7SBlZvNUGWLyRzWKpV2yoX+a16VdJNRlDk0VpDNO4cyGUg70LZuovcd6x+VE7aMzCptzS5+JZqzd1Eh08AQCl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 3:57=E2=80=AFAM Harry Yoo <harry@kernel.org> wrote:
>
>
>
> On 6/2/26 11:15 AM, Barry Song wrote:
> > On Mon, Jun 1, 2026 at 9:46=E2=80=AFAM wangtao <tao.wangtao@honor.com> =
wrote:
> > [...]
> >>
> >> You said discussion was welcome, yet when someone offered even a
> >> small comment, you refused to continue the discussion.
> >>
> >> If I had known you would be this inconsistent, I would not have
> >> replied to you in the first place.
> >>
> >> This will be my last reply to you. I will not respond again.
> >
> > Hi Tao,
> >
> > Please don't walk away from the linux-mm community. I read your
> > patchset and found it quite valuable. It not only reduces memory
> > overhead, but also eliminates rmap costs for exclusive folios.
> >
> > Since I'm not very confident discussing technical topics in English,
> > I wrote a blog post in Chinese about your patchset:
> >
> > https://mp.weixin.qq.com/s/k00tzhTl8HbL3k4G6ev4SA
> The cover letter and commit messages should have been elaborated to a
> much greater degree instead of making people guess the design and intent
> from the code.

Indeed. The cover letter does not clearly tell the story, and yesterday
I needed quite some time to understand what the patchset
was trying to achieve.

>
> > I have to admit that I found the implementation quite complex and
> > in need of significant improvement.
>
> > However, I think the underlying> idea is very interesting and worth
> exploring further.
>
> No. What it is trying to achieve is ambitious, but the idea itself is
> not worth exploring further as-is unless the correctness and complexity
> concerns are addressed.

Can we give Tao more time to address the concerns and explain
the correctness of the approach?

That said, I don't think the patchset is entirely without merit.
The idea that caught my attention is whether knowing that a
process is guaranteed to be a leaf process could allow us to
simplify parts of the rmap machinery and reduce some of the
associated overhead.

Assuming that a fork server (e.g. systemd or zygote) is preferable
to having each application perform its own fork(), Linux already
largely relies on fork servers in practice. Matthew also pointed
out that calling fork() in multithreaded applications is a
terrible idea [1]. This may suggest that, in general, processes
outside of a fork-server model should avoid using fork().

If we were to introduce an API such as prctl(PR_SET_NOFORK) or
something similar, could we eliminate a significant portion of
the rmap-related overhead for such leaf processes, while still
avoiding the complexity of the lazy allocation scheme proposed
by Tao?

I assume that the vast majority of processes in a real system
are leaf processes?

It also seems somewhat unusual that a few Android applications
invoke fork() directly in a multithreaded context, while most
use the zygote to create multiple processes for an app. Perhaps
the Android framework should discourage this pattern entirely,
and require applications to create child processes via the zygote?

If, in real-world systems, more than 95% of processes are leaf
processes, could that imply that the rmap design might be
reconsidered for a different optimization path?

[1] https://marc.info/?l=3Dlinuxppc-embedded&m=3D177912107460825&w=3D2

>
> > I'm looking forward to seeing a v2 RFC with a cleaner and simpler
> > implementation while preserving the core concept.
>
> I'm afraid this encouragement would mislead us in the wrong direction,
> where all of us end up wasting time.
>
> There isn't much point in posting v2 without addressing fundamental
> questions about the design.

I suggested a v2 because the current patchset does not clearly
state what it is trying to achieve. A revised version might help
clarify the intent and make it easier to understand. Even if the
overall complexity (such as lazy allocation) makes it hard to
move forward, we may still be able to learn from it and gain
some useful inspiration.

>
> > Regardless of whether it ultimately gets merged, I hope the discussion
> > can continue.
>
> Regarding the "improving the reverse mapping subsystem" topic, a more
> constructive direction would be to carefully revisit the design
> decisions and discuss what we can do about them (that's exactly what
> Lorenzo has been doing).

I have no doubt at all about Lorenzo=E2=80=99s expertise in rmap and many
other mm areas. That is well understood and widely recognized.

I just think that hearing more perspectives could help us gain
additional insight and inspiration.

>
> But that's not the first thing I would recommend to a relatively new
> contributor given that it's really complicated and even the people who
> have designed and reworked the reverse mapping subsystem over the past
> 20+ years haven't come up with a fundamentally better design.
>
> Reverse mapping is a frustratingly complicated subsystem. Without
> carefully revisiting the current design, there is not much hope of
> improving things at the design level, even slightly.
>
> What I would recommend to new people instead is:
>
> 1) starting by reviewing other people's work, so that you have enough
> time to learn the historical context and subtleties of the subsystem
> without making intrusive changes (which also keeps in touch with the
> community), and
>
> 2) making progress on smaller tasks with less intrusive changes, to
> gradually build trust and be able to do more valuable work.
>

Yes, that is a good approach for new contributors.

> Unfortunately, looking at how this thread went, I see that the author is
> now in a worse position than an entirely new contributor.
>
> --
> Cheers,
> Harry / Hyeonggon

Thanks
Barry

