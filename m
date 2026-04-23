Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A5CFDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF0E6B0092; Thu, 23 Apr 2026 19:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A53F6B0095; Thu, 23 Apr 2026 19:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5946B0096; Thu, 23 Apr 2026 19:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4046B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:54:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0652716062A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:54:08 +0000 (UTC)
X-FDA: 84691476576.17.D744048
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0658240005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:54:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KYJoSZa2;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776988446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41kCy9aqetqrPOFn3dVNTz9RU+5JBUz4E8GZ8ytiCDM=;
	b=oyy3osTvCP62vuAreoTmX5sTpnj2tbWOPNrL6vwRF+3Vnsqm+3KQFhftQVEPDud+RAK8L7
	cLesKjB4b2eTGmqmqTWhWpzKu7WNmh+nKodIzm8n4Z5tXzzCTTZgDwfSpKz1Hcx+OtbcVr
	CKlGs1nde0KXxMZ2GMCPJdjVAXVPhHU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KYJoSZa2;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776988446; a=rsa-sha256;
	cv=none;
	b=k7aHvnU4D2aeQq5+azMJPNxTBuw5QYfHKhJ38Mv0nlquKcBBDDb7wE67JwfvUk+sKw2fvz
	GPIxcAeZe2f+nu9rM5TnDjv+Z5rG7g+QvsAWT4/BGnqhQPyF37mvJlwBCppR8xIRmIr+HN
	xjXjCPaBzQX61+aoyKbP7EZ5wF0+0SE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 150D844735
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFFBC2BCAF
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776988445;
	bh=eaI/fkeZ7CEP60jWHk7uYSamh66RG7fuHVjUkL8k/Us=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KYJoSZa2YpT20MQISsfFyjCgOvrfnNeNvaCFpNPPSpkh0yRASlIbV+B8CF1gJfX9P
	 s/QID9OI1VYC1iPjADnsCTfiyY+GcGZbnXbDWSpnMqGpzTBl7yt7Eow8eALLogdGiZ
	 d53jQ+4qKYdPZa6uEuSo1D2fxNXpohIsejiaCMZgCqDcUqUeTHWlI8YaTV7bvN1/rX
	 y0Rc4lEw4chJae1t2nfekqqVfaOB473Bxf63FOQ/Igmift13YImiNJQ7dQ2YFTdztW
	 AuOhPxH0yNMN9LGz+kRhbRIotr9aUtnW28JDJqZRT079rwAYw+awU+l0AuiAPtOxwQ
	 4wJGmSof8F2Gw==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cb40149037so743951785a.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:54:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8633+2RMAbZ8SEhuAr8FTFRorGPJiuShZlB96Sjc1tzDWxs1okgJh1zwA5aiX/EJQysh07q3vqrA==@kvack.org
X-Gm-Message-State: AOJu0YzNda6EcAKBqMQnFdBH88Cm4FC7bch97MYB0xF/mqU0rqgGU/ch
	FoTFEBLqB5ommhQnQS/JaEyyoyDqv6WdidDto2S1O4x2Lqyp187iN9tvRk8FXhqvsE6HlBk53K1
	jNLV5X1J78A1HjJhjJVCF7qKhbAq9q2E=
X-Received: by 2002:a05:620a:4450:b0:8ee:42cc:4d9c with SMTP id
 af79cd13be357-8ee42dbae47mr2045520485a.39.1776988443860; Thu, 23 Apr 2026
 16:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260423164307.29805-1-jp.kobryn@linux.dev> <CAGsJ_4ygEvptQy662tTiPm-k+E4cbfvUKGGg3w7NaaALO-F4ig@mail.gmail.com>
 <aequK2ZM3O_7NM1M@linux.dev>
In-Reply-To: <aequK2ZM3O_7NM1M@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 24 Apr 2026 07:53:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xy+kGktiePL28DP3PAcVsdnz8Noann2UGhD=EV+3xjqA@mail.gmail.com>
X-Gm-Features: AQROBzAomkdNogOnDwaIqAtlHH1jWpS7cQJBT6mHpaugT3hAq8Bhk_VmFD-lRN8
Message-ID: <CAGsJ_4xy+kGktiePL28DP3PAcVsdnz8Noann2UGhD=EV+3xjqA@mail.gmail.com>
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add drain
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	vbabka@kernel.org, mhocko@suse.com, willy@infradead.org, hannes@cmpxchg.org, 
	riel@surriel.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tq3sfgaawa8r6zegnn4gupri4oj1i8uc
X-Rspamd-Queue-Id: 0658240005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776988445-566797
X-HE-Meta: U2FsdGVkX1/ctBc/4PP2nMZW3q45BE0K/fd6P/v6i5wUqWqOiBmchd3fRf2MTp5VGcePDsGXv1wrfw5VmwUxqY1rSWVZ+tUFg4SHrBWScszldRPXKS/Bl/H1M6nkJpawqmorzeD09Ms4zugPAD41Jaro2vpLeFb7MXe95SNCAP+gD4DkM1+EaO6kC3yD6TrS7tG5TUaPHxN0JzdHp0rKLKpmw7yCEOEXynrk2K7Iq2gnqzMnuNF5Zc1Gl5/bHN9Lzbtou/WjvsWB3ssFDT1vv2QmLcwyCVaT6t4vbpRYbKnwjDlMr1xym29Ck23NIWRX3YT1LalNb79EPOjmvI1rQ0mwCeJc6W2xZQct/xmxMpioWOub+O+NwXqP4tf6ob5P7oyYxPslV4/UzZS/xv90BYNLtByLN3ELRmPhdoPzBYHIwRJIwiTs3M4IybNVUlAVFovHJbKpXJNxoPru9Ug4dwGnBEYUJVQfDtqbBFXAz25Ko+WNLZACRphfvi8K8qbNRqcHxweZT6Unq+2ANnCK7iJxUo5ndOQlwxV1Zr9UYfx2WPrnhOKS9J711JBmioMIThkd/kLSO4zsrdxB30eVOMpm6Dat9gGlUBQr2nUWWLbRwuAesAvSyGD9kCB0+h9ppFDvxzE0KS18+3zjhPuot58TBKQptM5BaxNF8eTecsJBFb9OIqcXv0RcRDMtUtpHHDJaIycBrZaQiCjrPtOY8AGe8nWhJoW7HpWJwKPZuLJWH1nHhVBHU7GwYWDnmzMfKcEv6irOwYiVx5IpcGp6Yh39GnP2++UH4ExaV/VaNVa9cervD/+6QlEI8uEGTg8Vt2jaOM3jXVauKWOfNUpGj4W8SNmFpSSjdcHuEQl8HW4Qv8O8z8vaXB68vLyoraHXg6A+sqtIK3YZiKkFntltwjWUjEGGx+QIWcMh9lNSbk+bCcJvJ7YypMruXzQac5MD+CEQ5K0b61ToRxU/wYL
 9MDTlTsL
 2E6/Mw8Ca7wJ3wWnix7rL2aSJLzPfShuHkxLq3x2/U8eq8xeeURpu/4CuynqXtSdDMxDHTJpD8t2+HtfvB9SiuFYaHMlcQdrM2Qwn5sfsEcPd10dU9CK9652i6Uudb9qtsEuUp0tq7aQkDAU+EjrvjRBoUuf41mRbc6mlRGTQrAn0zg/KFlQMousT77/17KTsAqb4Ll7+m4XbqJjwOhqRFlrDeU19lHm10QllXe5gN7vv53ysPSPmekNpiB/1AjOsnr4ZTfJjh6y1mKLGaW2vJfjU9sWVlNsbXj5LifSMO6SkJb/bvlynoeLg2GGCyYgJPiyNqxHzS2U0doCTaQdixioe8lYbKfdyHJgB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 7:46=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Apr 24, 2026 at 07:22:30AM +0800, Barry Song wrote:
> > On Fri, Apr 24, 2026 at 12:43=E2=80=AFAM JP Kobryn (Meta) <jp.kobryn@li=
nux.dev> wrote:
> > >
> > > Of all observable lruvec lock contention in our fleet, we find that ~=
24%
> > > occurs when dead folios are present in lru_add batches at drain time.=
 This
> > > is wasteful in the sense that the folio is added to the LRU just to b=
e
> > > immediately removed via folios_put_refs(), incurring two unnecessary =
lock
> > > acquisitions.
> > >
> > > Eliminate this overhead by preemptively cleaning up dead folios befor=
e they
> > > make it into the LRU. Use folio_ref_freeze() to filter folios whose o=
nly
> > > remaining refcount is the batch ref. When dead folios are found, move=
 them
> > > off the add batch and onto a temporary batch to be freed.
> > >
> > > During A/B testing on one of our prod instagram workloads (high-frequ=
ency
> > > short-lived requests), the patch intercepted almost all dead folios b=
efore
> > > they entered the LRU. Data collected using the mm_lru_insertion trace=
point
> > > shows the effectiveness of the patch:
> > >
> > > Per-host LRU add averages at 95% CPU load
> > > (60 hosts each side, 3 x 60s intervals)
> > >
> > >             dead folios/min  total folios/min   dead %
> > > unpatched:        1,297,785        19,341,986  6.7097%
> > > patched:                 14        19,039,996  0.0001%
> > >
> > > Within this workload, we save ~2.6M lock acquisitions per minute per =
host
> > > as a result.
> > >
> > > System-wide memory stats improved on the patched side also at 95% CPU=
 load:
> > >  - direct reclaim scanning reduced 7%
> > >  - allocation stalls reduced 5.2%
> > >  - compaction stalls reduced 12.3%
> > >  - page frees reduced 4.9%
> > >
> > > No regressions were observed in requests served per second or request=
 tail
> > > latency (p99). Both metrics showed directional improvement at higher =
CPU
> > > utilization (comparing 85% to 95%).
> > >
> > > Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> >
> > Hi JP,
> > I=E2=80=99m seeing a large number of "BAD page" bugs.
> > Not sure if it=E2=80=99s related, but reverting this patch
> > seems to fix the issue.
> >
> > [ 2869.365978] BUG: Bad page state in process uname  pfn:3a5417
> > [ 2869.365981] page: refcount:0 mapcount:0 mapping:0000000000000000
> > index:0x724884c20 pfn:0x3a5417
> > [ 2869.365983] flags:
> > 0x17ffffc0020908(uptodate|active|owner_2|swapbacked|node=3D0|zone=3D2|l=
astcpupid=3D0x1fffff)
>
> Hi Barry, are you using MGLRU? It seems like MGLRU set active flag in
> folio_add_lru().

Yes. If you are referring to this set_active, I think it is
incorrect, so I have fixed it here and am waiting for review:

https://lore.kernel.org/linux-mm/20260418120233.7162-1-baohua@kernel.org/

>
> JP, we need to clean active flag but let's check what else can be set bef=
ore
> folio_add_lru().

Best Regards
Barry

