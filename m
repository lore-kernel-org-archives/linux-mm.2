Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D83B2CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 04:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC5F28001C; Thu, 18 Sep 2025 00:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC33D8E0093; Thu, 18 Sep 2025 00:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D001828001C; Thu, 18 Sep 2025 00:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF8928E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:22:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 607E5BB36E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:22:50 +0000 (UTC)
X-FDA: 83901075300.05.0688F0A
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id EE440C0009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:22:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=j7Eby5uJ;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758169368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5pp/oS3nVAP+usoANTjckqknf/ZBESQ3tB7xPv6m/A=;
	b=6dPrqSQRUSIyxIR/uojLQtEbjvXsqo2uAM1T20A2a1G7Y3rvBRSf/Rwzb1UGh/80Ty7YIW
	0+neG1OJtQo9TUL5e9xHSsZIIr6GyEONLei0p9yvV4WUNwyTQ1xgw2ss3i3HBIpbYjVaso
	pZM/r12x52d31SvqYjwicj/sO9n3Zrc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=j7Eby5uJ;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758169368; a=rsa-sha256;
	cv=none;
	b=Jl/EqBcsShiPrnWBv+vduvN3bv6iWNJAkUSt+ltj4ajE4zKBySlxC5p/Tbxbx4j+3DpUAk
	2XBbD/qahfOEdtdQQcOWxSJHnmIn/vM9LFqRKQJHkyISX2wI5mKMpK0aemhiUDWTZXcZu8
	zG9zHoHtCLYw4ZNnRqjsED45M527diM=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-62ef0cd926dso167637d50.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758169367; x=1758774167; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m5pp/oS3nVAP+usoANTjckqknf/ZBESQ3tB7xPv6m/A=;
        b=j7Eby5uJxAMMU8YxW315dODm3B9jbUICxkaofNyX8eM+xoig4U8BPrZK3k3blYY2Jq
         JnN9B35Unvm3M8n9i/I850VIs7Uk3Ykd0Xy+xat0no2gLqnDizvUZvqVCSIKMxNeCOp3
         1ALISW8k+yI8+VkrHN37+K8IpzG31Ogor64lNcV6HD9hDG5OpQBtmDOAphDCeXJ6qXaG
         IkEV3c2t210UB8ZuKoGyd8wJU0nNY29oJ9FnLJ7X5KjcXBvZXZpviNhLjeSNy25x8PSH
         1fPukBpbK8RwINuce3piZpKhbem+DIy2GWven7kmXdJeTSKoRjPiU+Rw0I4bkmw8Tzuy
         lgmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758169367; x=1758774167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m5pp/oS3nVAP+usoANTjckqknf/ZBESQ3tB7xPv6m/A=;
        b=P8YabYxTs/Iq0rMMoiXzvuO8ODajqEeqVuK3hiI4kTWl5uJh+MZJUpwjt5A3ddvBIn
         NEKfCSvHLP0RA41DoMDh5sc7Oqi5hboRXksYB1BlCVLfYl0xPcyGs4343iZ3dr3RycM7
         ascOhNyl+uY+oV8g20u1zXGro37K5e3vXBMQhIbO9j0wsEMy8vppw5LxWZurK3skXp/Z
         zrB4Xh6u/GeNg+0yNqfWzIJTwoWQeUG36qKmrefPAe6fZtcpYZJXXKhHnO1ATWcU7xiT
         wkKEzYi8wvGu3FOoJMdXTz8nY23mC8+Gi7XuxMlz3ag7WM4nAFRS7Pu/7t+65zeH1PUK
         H54g==
X-Forwarded-Encrypted: i=1; AJvYcCUxsQaekP/w84kUZYhnZsFjxdF70tvvKzNEOl4wN/K1MA7QqaJ4ZiHHvjOFNhcVCvwuRovNVjv6Og==@kvack.org
X-Gm-Message-State: AOJu0YwQFth2yKLCh2Skj25xGJDybks9F7qm5hU0jTBXzigYJiBldjtF
	ymQji8WzmCFq46bsZL5nozYD+93CujIBNrbaxH0rZnQm6MI/O1dHUqUgVIQgEL1xsFQtcxqdpIG
	KEgXvTeNp3OK93/EBRNGuYsjKdUr6tB7m8WZFOEGEOA==
X-Gm-Gg: ASbGncstZ/lNIyqILpVWfWJTMKoQZrGQTMNjH4yh0yR4PjmJdjbm33zv5uYBscgEF7F
	DEpTVZaIM9l1u1QjcwmH4Zm/iWQu2li8khKVKDTSJVq4jJ8k3asZIiuPJP9uoQ2IEnD3vaeRL3v
	Vkd35nIw+TeHEBkWd6Sid+lOyNGjI4QyZN2omVfMrkq2tG8Ki3ePKOy6NkmDRtv1yJPmYu0Bm6x
	/oXj/IrUWXWNbmyJZWOBxh4W2ZWLTmHUBQ4pgh2+R/Npg==
X-Google-Smtp-Source: AGHT+IH1+pFBZYesJAGB/eDlyPRl1lwhllXbWPu8DzgLWXG1lUHj/S0Zkn6lerF5ywoX/cS1ZFItEI0As+9HXKQT3ss=
X-Received: by 2002:a05:690e:d48:b0:629:ec90:c456 with SMTP id
 956f58d0204a3-633b06a5a8cmr2982235d50.23.1758169366517; Wed, 17 Sep 2025
 21:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250917212959.355656-1-sunjunchao@bytedance.com>
 <20250917152155.5a8ddb3e4ff813289ea0b4c9@linux-foundation.org>
 <CAHSKhtdt9n-K6KGXTwofpRPo-pH0-YoKFLtEe3Z4CszmNL0rCg@mail.gmail.com> <20250917202606.4fac2c6852abc5ba8894f8ee@linux-foundation.org>
In-Reply-To: <20250917202606.4fac2c6852abc5ba8894f8ee@linux-foundation.org>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Thu, 18 Sep 2025 12:22:35 +0800
X-Gm-Features: AS18NWBGJrlfGJ_PCm5TEC9HMRnBe4IoEXTWlHp5_aRNtYzwBhtuIlMrUElbbfc
Message-ID: <CAHSKhtdPGuMW0jRRgARGt+ZdnC02v9O11=ofsgRmnZny3c5aaw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v6] memcg: Don't wait writeback completion
 when release memcg.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, tj@kernel.org, 
	muchun.song@linux.dev, venkat88@linux.ibm.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	Lance Yang <lance.yang@linux.dev>, Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE440C0009
X-Stat-Signature: s7zsewy8gqhq1akurqpyueeoou9979u8
X-HE-Tag: 1758169367-780439
X-HE-Meta: U2FsdGVkX1/N3POArOCp8j3t8uba1XPQNIic8EfaMJvAk8QyzK+j0TPYLDicWebMTgLpxe3aYMeuUfXYas8zaspb+qMcJ+yiHQ8RBVzPagXvjX3IRdYC4eCFfglzPpyhHC1oB318RGxIMWWhi0iRD688vtBeewARYC/I0T/5b5U5lBHlBGdrt7B57dcoWAEGmZ381rpDfE7C3hG+kaTa+j1+Zn+MwOh554BOmMVpQ9sNe7ibq120ngWVQf4TdykUbnLKHE2TFyzpxPiFPmAYx0VNtgvht/ucV/NbDjdxYNtxx7JImdngFOtRxKmHT3cXuvB2qsPeBFh9q4dgIqd0A1vi64KRhA8mbNnwhGsIM+n9cBrxm4EG0iTCGg3ZokT1TEpw+vlGSE23PN9Cu4NOel2GCvwR59wpUWGLzXv6n6soTJpD4D1uWQ4iT2pgBvILGOPZa3nVeftt4+vCUV0yGbPt/EU2KxO4j1QThNrh04q175Jtoy0uMHOrHeUkuWnP33MWlTIr4K6j8DmuNRpIqglTze0SBsMEktvm92Bu1xY3/j6EgNKH5FCfjhVr9BOZz5f7T3o8+xR0mAlhb0j1woEyCmlZ+5yGrJbtr9zGI4pzv+RzJpj/1vCPAT0r28dvp2BdaSilb6jkd/ZaO2SZGBii3Orh3cFwANcLrFFyXIeujHqoDn+YZB/Bis9CfwLr+4GBCwqHedVCcLzfFLnI3iJ+o7H5nC83tyeSF+1zhHj1HNufCIwBzQAvWufC9XLQc1GHcc1arVOfxHpyvfutp/lP2liB2o/nPCektOac+qVrJDxwzr46XBV+x+8x8j0ohdpiYcWWsNCfeZytcXGrwSRbmPchY7XCbifHAsmAdtBp4FwPHGAuw26jlztM0rYrztxLkNXWvMSH1eBgiqPQF8w85czArvTJmXuMKRsV9nm0gFJiAVvvTP/7mXmVE4RDRzefKwun9YdSYJ6t3sj
 XSjv25lj
 3iA4OGFSp6ANaGYYWDsmY3ckZ8/U5M7UYDBa6wpJHwPHbCdass6rbJBgBX8dg6GAVqT0bYclopFJ1mzlUsVdQz6c08L+RdHi/alv4KcdSKsHWJHfhoJMRhrN27eVeKlw1GP30k0LfZxS9A7pzVMpG9Wneu9Sq4skbRXKwB1GHo9GNJqGL4V6VB0gRVPvyuDzxRFTps/9ZPcix9bSaOc401AlD8PM3A6QsYqgD5WIm38mX3Hm1TP8THctdrG78FSiQzu1MgyGSmPSI3qw1eqOt0KCCyfWjuqPL970F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Sep 18, 2025 at 11:26=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Thu, 18 Sep 2025 11:03:18 +0800 Julian Sun <sunjunchao@bytedance.com> =
wrote:
>
> > Hi,
> > Thanks for your review and comments.
> >
> > On Thu, Sep 18, 2025 at 6:22=E2=80=AFAM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> > >
> > > On Thu, 18 Sep 2025 05:29:59 +0800 Julian Sun <sunjunchao@bytedance.c=
om> wrote:
> > >
> > > > Recently, we encountered the following hung task:
> > > >
> > > > INFO: task kworker/4:1:1334558 blocked for more than 1720 seconds.
> > > > [Wed Jul 30 17:47:45 2025] Workqueue: cgroup_destroy css_free_rwork=
_fn
> > > >
> > > > ...
> > > >
> > > > The direct cause is that memcg spends a long time waiting for dirty=
 page
> > > > writeback of foreign memcgs during release.
> > > >
> > > > The root causes are:
> > > >     a. The wb may have multiple writeback tasks, containing million=
s
> > > >        of dirty pages, as shown below:
> > > >
> > > > >>> for work in list_for_each_entry("struct wb_writeback_work", \
> > > >                                   wb.work_list.address_of_(), "list=
"):
> > > > ...     print(work.nr_pages, work.reason, hex(work))
> > > > ...
> > > > 900628  WB_REASON_FOREIGN_FLUSH 0xffff969e8d956b40
> > > > 1116521 WB_REASON_FOREIGN_FLUSH 0xffff9698332a9540
> > > >
> > > > ...
> > > >
> > >
> > > I don't think it's particularly harmful that a dedicated worker threa=
d
> > > has to wait for a long time in this fashion.  It doesn't have anythin=
g
> > > else to do (does it?) and a blocked kernel thread is cheap.
> >
> > It also delays the release of other resources and the update of
> > vmstats and vmevents statistics for the parent cgroup.
>
> This is new - such considerations weren't described in the changelog.
> How much of a problem are these things?

The cost of the release of other resources should be fine, but I'm not
very sure about the impact of delayed statistics..
>
> > But we can put
> > the wb_wait_for_completion() after the release of these resources.
>
> Can we move these actions into the writeback completion path which
> seems to be the most accurate way to do them?

IMHO, it is technically feasible but logically a little bit weird. The
wb_wait_for_completion() here is only used to wait for wb completion
of foreign dirty pages (pages that memcg and writeback ownerships
don't match) and there's no connection between foreign writeback and
release of memcg resources if I'm not missing something.  It's up to
Tejun anyway.
>
> > >
> > > > 3085016 WB_REASON_FOREIGN_FLUSH 0xffff969f0455e000
> > > > 3035712 WB_REASON_FOREIGN_FLUSH 0xffff969d9bbf4b00
> > > >
> > > >     b. The writeback might severely throttled by wbt, with a speed
> > > >        possibly less than 100kb/s, leading to a very long writeback=
 time.
> > > >
> > > > ...
> > > >
> > > >  include/linux/memcontrol.h | 14 +++++++++-
> > > >  mm/memcontrol.c            | 57 ++++++++++++++++++++++++++++++++--=
----
> > > >  2 files changed, 62 insertions(+), 9 deletions(-)
> > >
> > > Seems we're adding a bunch of tricky code to fix a non-problem which
> > > the hung-task detector undesirably reports.
> >
> > Emm.. What is the definition of 'undesirably' here?
>
> Seems the intent here is mainly to prevent the warning.  If that
> warning wasn't coming out, would we bother making these changes?  If
> no, just kill the warning.

Got it. Seems like there's no more impact other than the pesky warning.
BTW, I'm also seeing many hung task warnings when the mount/umount
syscall is waiting for the s_umount semaphore=E2=80=94while s_umount is hel=
d
by the writeback code path. I think the hung task is also undesirable,
right? Since AFAICS there's also no more impact instead of the pesky
warnings.
>
> > >
> > > Would a better fix be to simply suppress the warning?
> > >
> > > I don't think we presently have a touch_hung_task_detector() (do we?)
> > > but it's presumably pretty simple.  And maybe
> > > touch_softlockup_watchdog) should be taught to call that
> > > touch_hung_task_dectector().
> > >
> > > Another approach might be to set some flag in the task_struct
> > > instructing the hung task detector to ignore this thread.
> >
> > To me, this feels kind of like a workaround rather than a real fix.
>
> I don't see why.  It appears that the kworker's intended role is to
> wait for writeback completion then to finish things up.  Which it does
> just fine, except there's this pesky warning we get.  Therefore: kill
> the pesky warning,
>
> > And these approaches are beyond the scope of memcg,
>
> So expand the scope?  If hung-task doesn't have a way to suppress
> inappropriate warnings then add it and use it.

Sounds good and more general.
>
> > I'm not sure how
> > Tejun thinks about it since he mentioned before wanting to keep the
> > modifications inside the memcg. Given the fact we already have an
> > existing solution and code, and the scope of impact is confined to
> > memcg, I prefer to use the existing solution.
>
> mmm...  sunk cost fallacy!  Let's just opt for the best solution,
> regardless of cost.

Sure. I will try new approaches if it's fine to Tejun.
>

Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

