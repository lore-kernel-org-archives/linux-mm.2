Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED571C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 23:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9786B0088; Fri, 25 Sep 2026 19:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A416B008A; Fri, 25 Sep 2026 19:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A066B008C; Fri, 25 Sep 2026 19:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2896B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:47:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCE56406B3
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 23:47:22 +0000 (UTC)
X-FDA: 85253923524.12.DC2A7B8
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf17.hostedemail.com (Postfix) with ESMTP id EFE0740007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 23:47:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SlyN/wEh";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790380041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qIluyRCU98I9Sdr/F/z+kOctZKsX4pt6+dPY035uhLg=;
	b=Vm9jrCgEiRsCUCOipDBXKohPBRUC5w4MMM85E5OcgktCImJ0NpzIGaf6Z6v663lB1Gbg6+
	wGWoeGPiwoNkMDdOGG+k4A4Rs61WlePQRT7nhEv1RNGtZJetOuTJh49meWOxqaBxUKrheS
	QcyjzowOmGhD+PUnG0/cxB3l+5xYu2Y=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SlyN/wEh";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790380041;
	b=YWb6x6gX3BbfaOAqeDq/RzJDj1Xlrg6f92YC//lzLKRLIgHsqEBF9+eJGWxK4Dl5TeRGZU
	/ZGGuwMEiPcyatxRVmplMVQVQer/L1Np6h1TCPSeS5Lv38RTJXrQatTTf3aTIkw1QFBC2M
	xTBDx4vwomP2A3IYzogk46aBq6HMP0Q=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48439feca17so1005493f8f.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:47:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790380039; cv=none;
        d=google.com; s=arc-20260327;
        b=b6RvP+ECCpMPd1VR2BPylzdWVGyHmiRg/T1agdHkX4kyUC37G5Rtbj4rszqmcTw4yM
         zF14l6YdGJNRJSrfEecFU2m01oj0ZWzEi2GVnfqwCMgP96QDiQwd4TOY3yOVUcTVtwAU
         9Qo80mm7jUVaXATW/xFC6844Q4eZIOCOcViPDvqTyLnEeGBKl5sc6/jERfjaNwvGyaZJ
         qUiKHGzkYv74JH0nnB0li4i5MppddNL3FkCqx5ZvJk6qfTkPymPlJqpbb7u1UQUs2sgO
         kCRrwoz2kpeIzwSapmqm9TtsjZcuZ/Ze6QBUoNiaaJkrFZMB0NzvwgKvjEvmTMuwxRCh
         kbjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qIluyRCU98I9Sdr/F/z+kOctZKsX4pt6+dPY035uhLg=;
        fh=qS+Er+WkgFOy2wjXarWYjWdmmhjWFU6NeT+IMA4r/z4=;
        b=dzxhwhHSN1d0Zsg7VoGQLf0Pz7Zvj2GN0EPln8u2micGKd2beA/7lXPrRsz0GdcOuh
         oj3nXjbrb24qAy/f7XIjWRUXuVwme1CeJz13le4UEqf872rcfTBve+InCwymAjFWIyDh
         ju6qFGxPVVwoZScqxjFgnFFkKal4IJxfaVpCvHX2ayu7HCkEmloE52SiWOa+64eIYBSf
         6EikvwqRyspJxrZnLCHQTGH21K/kD7SWlB7271j02STYmVfGRasqYNrq+zU4hg3O/q9d
         sby8aRopBC3JIhEQS/utunLyTUI3f0AqEChxjSaPVwQDxjLgWx68xwTI2PCvoiY+4jlM
         mh5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790380039; x=1790984839; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qIluyRCU98I9Sdr/F/z+kOctZKsX4pt6+dPY035uhLg=;
        b=SlyN/wEhXnqxeyVmQ8xzBngJcKWD+IXswAij3TI558NYFla0JyGR2JVTZYoIix77PX
         Iyr7a7+GMAPrNYASNSbCg8vWPXhszXTGeN0OI8/v2rfwp5mU6yvhoFBVrhivYw0TQMzB
         XbjtTPhmFPLmWl6Sp0fFJmQUIoESrYK+/kfYVWK20jwI3GiDAm0MSr6rqIyIW4/yImpU
         XqMqFhl+ahpycNvVAbXMKOFkYGNyS9JfY5PYzwxxNz1BYQwdniiz2UQlVCPj4Iz++fJL
         dC26Z7Jyc1NlWyOmgTqeNzwnKJyGtRSXoZ1LKbc0dpCS3pJ1Cb6XLksbwV5Gg/gCVqEv
         CXDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790380039; x=1790984839;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qIluyRCU98I9Sdr/F/z+kOctZKsX4pt6+dPY035uhLg=;
        b=k+aa7ricQ6JO7NDTunFeUX/1o7ZDKiJtUQeI4SH3GJbQSoeaZBQ2GZ48ih89HqTOyV
         6k3JzeGv7dZae2h2b9wyg8ZpIp2nNBZWZxjITOEpsOhnM59LKiYd2e2LTTZt7kAQbuhS
         +XOb+lkVwtybU2m7PmCjl3edJGCzbtBbQ36aoJ7dx8yfWvLv5/Td2kMXUeFQyqpkqA9Z
         euJe1TMkShGdnQxDzw63z7WN/JTC3Ehodi+UioAmtmOQPx3KPTDgEgS1MGBhgYEMCZmd
         b7IUw3XCUmyEB179Mx/DwtzRf/ZgrRBSwJ/3zN4QJ7yvW/NOyHYew5McBg60ulCSYrpu
         /hgw==
X-Forwarded-Encrypted: i=1; AKwUvBwKfxzl2bpKkpEJrpX9XoizfgM/QtLQAOGG4LWOoIKljQgOmIV9N1IZQ990efzDtC2Iv4KTxStdOg==@kvack.org
X-Gm-Message-State: AFuF++mlPUOAdN/xI/7IkPMjSZjQUHZVfUBZiqzxY9md0pg3U3qZklQd
	azB1QjlZeh0wn09Kxjp/jxWuDQA9yh39+s/UbFIom233V0gbTue4/aTCQZUwjWRPQLK8SQiAfnq
	F78y+rV8eMgHeWhJtUCSWr1NFuP+FQ8U=
X-Gm-Gg: AYBFou3SQ8nowKW7w4ITGigmO1aGgPoHFboaXAUpnHZUT83JRTPRwkxATEw0n7n1mky
	I7COmgojA1UqWI6DV/UlQCYEHfsjHnU81/+XVtaWtMbZwbWb4uHbRi6Wsq2Ba5MVYo0I0Kkktxk
	YtKVuIJIbeN7D/JAEWTfRB3IybMfTlaBkhnv4Bglhliw8xHBgOzwzjPOYoTociSdN0eof7Q+1bQ
	opSyaUwH7HGz1YzTZKFRDyj4xui1quat+zM9EKlcPWqW6+OQ32US+P0mAlswI96pGgwyMrGyOYd
	l0ogT/VhY0bdnTtpo7rkLdhUqe2G/YI+SDDfn13SeBtU3JESpDUEmDy8iMuAiLMDgwdh+aoaGPA
	ZAuB29gkUZpzf/T6ikkD4APDIc7gJuOfkkYWESw==
X-Received: by 2002:a05:600c:1d29:b0:49d:797:83bf with SMTP id
 5b1f17b1804b1-49fe66f3c7cmr143376745e9.21.1790380039073; Fri, 25 Sep 2026
 16:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
 <20260920162014.4479-1-lance.yang@linux.dev> <e22eb6f7-7eb4-4f50-af2b-13a2e3952cac@kernel.org>
 <CAJnrk1Zk_4awd5OfbvsCLts1YPsB6JjjOF2hiSmg-wAp+_KUDw@mail.gmail.com> <00d07f4a-f679-486f-9413-6917b5213854@kernel.org>
In-Reply-To: <00d07f4a-f679-486f-9413-6917b5213854@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 25 Sep 2026 16:47:07 -0700
X-Gm-Features: AclHuK80nzYPo3L8D4JYoY7caSyVEbjQCvpntZXih-Vf40CJja-17fp5PIqHV50
Message-ID: <CAJnrk1bD+4tndrOWuSENvEb7ody47HL2aNv2n+RzUqDE8mpkrQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, ljs@kernel.org, 
	usama.arif@linux.dev, hannes@cmpxchg.org, baohua@kernel.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, willy@infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uuf7wamxcwzxubnqpxdx53tbcmtug4py
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EFE0740007
X-HE-Tag: 1790380040-625911
X-HE-Meta: U2FsdGVkX1+42Mkoit60k4v30rx8uFw272NJrzs8dwDbJsp02MjfkB49ELGLwRJQhms5rli9gVdKKn8DoQQ4c3TZ135e+h/LAhMWhdvs0VCzTpZk4dnUPfhNhDzI7WUu0bjwiHkdQusgZvrKCdp6PLm6ByP1kBMz7YIb+iXr6HM8fTMDhAiJYQY1DMOJ2v+bYiZ0r6BO087kv8DQvxOtb502LJEHjvU2UR6rxs9EFdZg1UGblY/8yQNKe6x7LL5qa0yY/Wf4YBTP0BKSD54b3eeIwE+YJbIsD8eHOcScvmKvt+f4fPrAXRhUnTQMBLo8YSu5du0+UuD2VizE56vahr5+LsbBwqttLMXRr5FwpRQbS4zdNCb9xTr1oq5ZK9X/pUpILQ7mu8uA9wJxMPr7laFWvYL5VpWXM5jFWBBuaN+THL0fdTJgFgcpRiwIw5BpzHq4lpjceWsnwNiMHd4PtfO7lO/CSNYkFmjyZ+jCNIqaCZEfqzHXxA+eQ0PikdA0qSs3Pe3wWkEEJnUcUp6XX7H/+chW/fuOChYJPJMZslXCMHQXMGBfLa+L5j08eJO7dKBSBiox7IWSifhN9bdfFyROBV2kuvi5e0kc6/qWIBRBn4NxPUoWCyBZflL4Pm+doqqssgmJqMfuZNnr3psg3KeN19YDpc7QjgjhJk5rmejoKwF0xRZjPoxw0xj5exGt2LpTu3yszmFkIIvtQlXUQ0+Pe+fbHMw+hhvr6OhI2zL68Bu/te0UyOEqawy5AUAjJFmMTalW3GPhtGMnrz3H6kAtysAJBgDAbRWYIEQibrAP+c5GFu6KxEHsOVfiWfQVJrXi0CuNwMmsodYkPHytcJiAAgC6vs+/Eq+CdwrdmdmYYbEepaxP7qI1fAzzTHr76crLNDe3ioRsF+IqttghV0Zdc26Ptr0lDUPFh+2c89hU3t5Xw5blz8ncZySAyafFPqc93IzetWR3sq+jjXj
 KPBsSRdF
 TKoaiJzZ7lhKTfFphZyVkpdbOJOGDCPiishViM7eHMS9OCd6dAXe4j7ICp9e3UV+6LS5iG8oFNTNkoMThNtTB8HP33yUt86IXon6zPCxNwq7ZDFfbKMOunVY5FibKJbrN2GJDzm1iOfqmEcsJS3Pf8qQ3Pt6hF/B5sGn+QRYEI+18MYrlXndm+sDITrvXQO56/NPGHnGVv3caCTn08g80qNR6le9csztvSrFrgUQBQSz8xMtjIHw7/AKHw9w7sCACEdJU3Jyh+h9SsOXbru/YPROcTMdxcq2zm+jAAHjPQCRiVju5FEqRPDVZDmLkLRn/Mpj+BkUVoQ01mM94kE+D9cSpC8n96dJ3cBAdXMuR0RaYAmG2eT9xmRgXx6I2QikVs8xfkBPHMTfyQh7abJnK/NSkdXhoJnIlK4eT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 2:44=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/23/26 02:44, Joanne Koong wrote:
> > On Mon, Sep 21, 2026 at 3:12=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/20/26 18:20, Lance Yang wrote:
> >>>
> >>
> >> "David objected to the scaling", not quite. The tricky bit is the scal=
ing when
> >> collapsing (creep).
> >>
> >> When freeing, I'd assume scaling should be alright.
> >
> > Ah, apologies for misinterpreting your comment.
> >
> >>
> >>>
> >>> Em ... I'm not sure max_ptes_none should also become the mTHP underus=
ed
> >>> threshold ...
> >>>
> >>> Say we're on arm64 with 64K pages and set it to 16. Khugepaged PMD
> >>> collapse uses 16, while mTHP collapse turns the same value into 0. Wi=
th
> >>> this series, an order-5 (2 MiB) mTHP enters the deferred split queue
> >>> because it has 32 pages, and is considered underused once more than 1=
6
> >>> pages are zero-filled. So the same knob means 16, 0, and 16 depending=
 on
> >>> where it is used ... That's a bit odd ... no?
> >>
> >> I very much prefer scaling over using absolute numbers as proposed her=
e.
> >>
> >
> > With scaling, I don't see a way of avoiding having to queue every
> > anonymous folio of order >=3D2 to the deferred split list at fault time
> > in the non-default max_ptes_none case, since any folio can now
> > potentially qualify as underused.
>
> Exactly.
>
> I was primarily arguing that I don't want this overhead for the majority =
of
> Linux installations out there that ship with
>
> $ cat /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
> 511
>
> IOW: we add them (PMD THP folios today!) to the deferred list for
> uuderused-scanning but never actually scan them because of:
>
>         if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
>                 return false;

Ah, I missed this nuance in your v1 reply - I thought it was objecting
to the queueing overhead for the non-default max_ptes_none case as
well. Patch 2 in this series does what you mentioned above and it
automatically applies to PMD THPs too. I'll add your Suggested-by: tag
to this in v3.

>
> Now, what you are saying is we might want less overhead for installations=
 that
> modify max_ptes_none, like Meta's fleet. See below.
>
> > This drew some objections in v1,
> > particularly for the Android small folios case. I read that as ruling
> > out scaling. The objections were a) the list_lru lock contention and
>
> It was the "deferred shrinker list and lock" contention, yes.
>
> > b) the limited upside vs cost of splitting small folios.
> >
> > For a), I don't think there were any hard numbers showing this is a
> > problem. If it would be helpful to have some benchmark numbers, I'm
> > happy to run a synthetic one (patch 3 applied (which adds anon mTHP
> > folios to the deferred split list), only order-2 enabled,
> > max_ptes_none set low enough, all threads in one cgroup on one node so
> > they contend on the same lock, each thread faulting in a large private
> > anonymous mapping). I'm happy to run something else if anyone has a
> > workload they would trust more. Johannes also mentioned batching as a
> > mitigation. If the contention does turn out to be an issue, I'm happy
> > to prototype that and measure it too.
>
> Right, I raised that. Johannes thinks it could be fixed with batching. I =
was
> concerned that it would become rather ugly. We'd have to see how that cou=
ld look.

I ran Barry's microbenchmark to get a sense of the contention (more of
the details are in my previous reply to Barry [1]). With max_ptes_none
set to 0 so that everything gets queued, and toggling shrink_underused
0 vs 1 with patch 3 applied, I saw roughly a 15.8% and 11.5%
performance hit on runtime at 16k and 32k, but only 1.1% at 64k and
noisy above that.

I didn't see the cost being from contention on the deferred list's
lock though. Perf showed that it was coming from
folio_lruvec_lock_irqsave, and I think that's from the free path where
in folios_put_refs(), __page_cache_release() keeps the lruvec locked
across the whole batch, and folio_unqueue_deferred_split() gets called
from inside that loop with that lruvec lock held. I don't think
batching the enqueues would help in that case, since the cost is
coming from the unqueue side and on a path that's already batched. I
think maybe we could move the unqueue out where the lruvec lock
doesn't need to be held while the unqueueing happens, but I need to
look more into that.

>
> >
> > For b), v1 unconditionally queued every folio of order >=3D 2. v2 added
> > an optimization patch for skipping queueing entirely if max_ptes_none
> > is at its default value, which would also carry over if we went with
> > scaling. So I think with that patch added, for the objection to b), it
> > depends on what max_ptes_none Android actually runs. At the default
> > max_ptes_none, nothing would be queued at all, so a config that sees
> > no benefit from splitting small folios would pay nothing for it.
>
> I would assume everybody except some special users that fine-tune underus=
ed
> shrinker run with the default. I did some digging in the past regarding p=
ublic
> documentation about how to set the parameter, and most of them just defau=
lted to
> 511.
>
> I would be surprised if Android even knows about this parameter ;)
>
> >
> > Does that make scaling acceptable to you and Barry? If so, I'd prefer
> > that as well because if/when intermediary values are supported for
> > mTHP collapse, that support would have to be proportional, and it'd be
> > easier to reconcile the two with split also scaled. If not, then what
> > would be the suggestion for where to take v3?
> My opinion is (open for discussion :) ) that scaling is likely the better
> approach. With the following notes:
>
> (1) If we want to enable mTHP collapse with scaling as well, this needs v=
ery
> good documentation and also another thought on how to work around the pro=
blem of
> creep (e.g., refusing to collapse if creep would be possible according to=
 the
> max_ptes_non setting and warning).

Agreed. And if/when collapse gains proportional support later on,
having split already scaled means one value governing both instead of
two.

>
> (2) Systems where the underused shrinker is effectively inactive should n=
ot add
> folios to the deferred list. Including PMD THPs, which we unconditionally=
 add today.

Agreed.

>
> (3) If we want to exclude certain small folio sizes from the underused sh=
rinker
> (e.g., order-2? order-3?) it might be better to just hard-code that in th=
e
> kernel instead of giving the admin a choice it cannot possibly make easil=
y.

Based off the benchmark results in [1] and [2], I think the cutoff
needs to be at 64k where we exclude anything under that. On 4k base
pages, this is order 4, but on 64k base pages, order 4 would mean 1M,
which I think would be overly conservative. I think it makes more
sense to express it as an absolute threshold value instead of by
order. I'll try to find an arm64 machine to double-check this on.

For v3, I'll go back to the scaling approach. I'll be traveling next
week and then will be at LPC after that, so my timeline is to submit
v3 after I come back from LPC.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+te=
8G1MaU9bXs99w@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/CAGsJ_4x_Q1Ku9r6zfC-K-o87juQ9JNQ8=3DOS=
Np+UZzW3MPtZXbQ@mail.gmail.com/

