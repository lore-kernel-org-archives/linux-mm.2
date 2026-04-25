Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17EF6FF8864
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 04:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79A76B0005; Sat, 25 Apr 2026 00:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A696B008A; Sat, 25 Apr 2026 00:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1D66B008C; Sat, 25 Apr 2026 00:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC7556B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 00:19:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5366A120208
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 04:19:12 +0000 (UTC)
X-FDA: 84695773344.26.DD7DE90
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2F0E0140017
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 04:19:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QhOE2QZQ;
	spf=pass (imf26.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777090750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ED6LRizb0aLegQxmqSHHiWjesUTMCbbsMRIvv4Qgi/U=;
	b=PsuH6L1XhkeaOwLOjIs2YS6Jv+9uqOkeM8lStmXBuNKv86HFZzWGC+RruZE5sXd0qDJ4aX
	hPmt5n39PyEcJU9sMzSij9OLK6E95cCfcmF8YRFNkKwE1CKaW99mRYr2s8RxEGkZaVtctn
	6MYQbzmrNtwKfQV2Ie8aNbNBRheqZIo=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QhOE2QZQ;
	spf=pass (imf26.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777090750; a=rsa-sha256;
	cv=pass;
	b=KffpGrng7zCOhk6nr+0kjVv0prTgr/omhnDRztD66Q4toqiz+mEp38j+oxEeX0kKwWtc4L
	TBQHu2ffVlyqRVDb43McUkwaOUIt5/874C+1XH4uW+XOLilnMe6H3KoSxBZnfhbh3QKoKk
	hNjBpz5qOtmGV5rlX1kxY56RGfB5txA=
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-12c726f46baso10654493c88.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:19:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777090749; cv=none;
        d=google.com; s=arc-20240605;
        b=WZVDbFZthrVs3UxGOgBd+lYrDvEZVa3+cx3DCt1vUc277I7lqop66pyAx9jdTsROLY
         SOS9T7w2tzrxlPfeXb5s+Fxu5G7ZegpYm1WhHuHxIyqRo/Z63WmdN9eH1PXUhKSY5XAF
         Bd+vTGvWmvAFwFTh6iBvDByow8GzlfgNmm+qQnjMpSGZNHfx6AT5vfiVIzgp6Ua97ysp
         Q0Yz83Y17sbud6230lg+2XMlw+Uyz6g9eprPPdNoXfHDJz2Xb9F+pz5A3Hi/i1F45P9W
         9yemr13yrh+HnN+9rZa6KwBjx1Q/3Fzaix8Vzmxj2G/dWyAO0nUXZSm1p1SMyZMVUEg5
         /GaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ED6LRizb0aLegQxmqSHHiWjesUTMCbbsMRIvv4Qgi/U=;
        fh=Gec+sC231QGfuHPJ3TAJOjgxw115mvtrBL7+qrrsu0c=;
        b=RhBLOxyb6e0sPsMV8K4W43EheMg++ORYtCCWqtyicG6i/zjwEYbxiJUNiQ2OeMrDqG
         udr+l/bbrMg4XeKN2sAfLJmZnc5+c+uuT+IN8eGLlypSTzsRmqFD8JLsYf0tOrVFOArr
         dIa4jpNSgqBw2JzuB9FjFOP3vZ0ChmrKCuMje/hZgEaFwqlgC5qeE6xcyNAm6SWBPy75
         4fInIuGBwzbU2tuvce99/93rS/TKiq6I7Vi+1B5RaRld5Cm4Qz4NiV80bR6PHaxZHKJ3
         en5KIrUpbGrWBbSfkKY3Kox3j4h8fBAs2rMqzufNYYlHPjC3IgCNTu2MuiJRpRPVuvBi
         BqrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777090749; x=1777695549; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ED6LRizb0aLegQxmqSHHiWjesUTMCbbsMRIvv4Qgi/U=;
        b=QhOE2QZQQ6BWppps28Kvqr7fqueVTCdsb2A/pUmPo+0jF/r5Ml0Ig5zdpMXCgTNpje
         04FYVKPq+7i72bmfigIbLvcb24xrLTW88qESCgEeVCC0RJYdM6chU+/owZhM6m+tLJ7U
         zcn8wgtygIQXPY1nKrcefegH6H2vsrhoIeM5rUoGgaup0qTR8xOFjHkZRnkpMUx/m7NT
         QTuN3EyBnkJ73KVcpd1jRHGtDiMLOPJJTMoB2nRS+6BtSnHor0Zmoew1JfiOxRPzMWd0
         wgU/LQiwN0Oq1+yVAdwrQZ0Df/u+xb3bd7CMEZ96AteRhFH8DwiMqL2mg/bOPCpLKU5r
         NOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777090749; x=1777695549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ED6LRizb0aLegQxmqSHHiWjesUTMCbbsMRIvv4Qgi/U=;
        b=FWsZbiuJ3sqvunPmRJBJmx6XkB0IoDEw0TFA5ERQk5hvFnREvWmt+NOACeNJMmSvH+
         ukVApVYH8ElZxe4QR5jA3EsnOhJZfCfYc1Rf2KSZ9Xi6/s0u4kF3IGhPi3JKwjwdjj28
         V3Wk8mufJjxvw2N5q80Mq5ywDwU7RvWZnuh3SOR8RWiaGXhAjsZoM6TPn7w1S+Wjyzfk
         c6xeGPeAAAjSR+FHqkNzrjXpCJTUNh+I6w5qMwc7K/Hx+IkANm/vOukUzTvfOdsXPpPS
         MzpPI8hP/hDyTVku1WafViS1n2AHRHH2Aa+sZHzXFP37MW4BCu0/OzBxFXiGgFgQ+y3i
         deYQ==
X-Forwarded-Encrypted: i=1; AFNElJ+2Zz4GTnkQMHF1qIOgMPxDVKEj/+X9gq1jUV/plTEuVQqBGNAo2lWufxSD3oGi2jV6VMfDU7Rirw==@kvack.org
X-Gm-Message-State: AOJu0YzW4qm3TftJzxKMCvKWrhbOca0oiG/W/js0FBs9Q27yIp3ty8OV
	nYg7inYalJYf2PyjIEmEbQH3pGr/muz2nVTJI5utDh/MgS60tKj3nHEbxrtE/v5w6q2f6NOrtXy
	ua85uBvTVcgn3RxZjHX4AB/9bxPcpDA==
X-Gm-Gg: AeBDietxJCiVxCOZ/D5+jr4vmQ/UTvv0/90EeSNbNcslojNkU6tL5gKsaRykpA47+IQ
	221/jSwmc+EniicyVTxNM5F8h5LuoHkYuPsbymoht4ZVKaQGLF6Lk39dvD/vHI6yC5feORhRngQ
	d1yBL7SkozTzADYzWF35hUmDdPQVT5Ms6SmPnbXgbSSGe9nFGaUfzUz5UJk2ZShzdwRIxCahxir
	YBwe37ilxZMbH6n5r64jiLHWyY4FSQBImz/psn3Ax7ag0oSlTzQ2HL5e5zmhgWeLtBnifKDu+QZ
	nwbRQ6vEyG4nZdwLk/k=
X-Received: by 2002:a05:7022:2602:b0:128:d23d:81a2 with SMTP id
 a92af1059eb24-12c73f9ae5cmr17700641c88.29.1777090748581; Fri, 24 Apr 2026
 21:19:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260424203448.5040-1-ravis.opensrc@gmail.com> <20260425003942.85395-1-sj@kernel.org>
In-Reply-To: <20260425003942.85395-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Fri, 24 Apr 2026 21:18:57 -0700
X-Gm-Features: AQROBzARRfoADW7Jx4sGujVnRXtL7JrOvvV0-SJLi2_UI7JAVotqOQR2kydBN3s
Message-ID: <CALa+Y16VuXb2DfeiBiE5avpEsqGVfc6DAKZWacNsu-1hD51hMQ@mail.gmail.com>
Subject: Re: [PATCH v7] mm/damon: add node_eligible_mem_bp goal metric
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F0E0140017
X-Rspamd-Server: rspam06
X-Stat-Signature: ekby6dpcmj4hzfbqktjh7c8x9mzexasf
X-HE-Tag: 1777090749-714384
X-HE-Meta: U2FsdGVkX1+ZDmYzC7ynOybuLsth4qi4TDZanMgHVE3rSpl9C1xESAuam/1ETjsUdrAuMVTKm/imgEfIib4dNWPcYD9OtcHTkJmPR6XBhxlHBVFGhIJ4FpbBjtr6yaUv0YWZqs0ZHUqlRsU0H4Q5mA00TpPdSBGS1DSzqwTX3eNs/mPEABuvfOczVa3tAfgMpWNzJkIC64YctcXJZ5JoZ9kqZNJs+MeEys/adC+tu1XRT9pvzyLmgkz1fgw7upVTyxu/XdBheDNNrF5fCUR8Z6oJg6WfqVslnq77Qb8BSLU2VmXFVhsju9d/wp0YJwzFMA4Aak40SS1iXem5SkHmx0GRB6rJPZlNBLdIS96CpiypJsiVJEFLSkhObEhTEfd4suGC2WtcwfQNREyDpkpLtzlLurPstv5GmJ0QH7+zvEvS90yZHX4ANChcS7M2oEo4Vt41xsk9UDd3D9saP35rkRHIkCru03mSfQ6bfJcQrCi2r9Dg3RUbJmFs4SdTzGNf3kWzSDhH/3SCwt3Q8+PzJifigC0aMIhEoDiyvn1PuelaEolrm1fF6PoS1EcWM5h0L2i795rD+GJRt4s5MK2BHyw3Hl9X2z9lOJ8Rmkr0OV9RPa6v6Pk4hZw7lUh6eunuceElzJ4f2nHgPwdNr97jR2EDb1eOrlarDkws3I9B54QsKhGQb2ir22zd/6+pEvfGcKbiRos5GX8WjsLpWYpqees11ihsCPuJkoRbnoGZmMTp79GYiRCpfXzCPbDmVd3beq1ZRoCrwEQSzLqSR/37pXasfWseWpHwhC/MwGBtF/C07xEiRqJaUPkVv7TlE6wfBNzfEreL7UUrLu4OWH2MqoFwJj3pnZLwNzfgl+YCc2q9vdv39+WtHArwY0In8EAW8kWhyeVQwmM/sePH35Ld1lgKaUGeR05RU7RQcETBcV6Pi+snwCrckhmunRIHBVBXqCgc9mt7BeB8iI14MKr
 6Caclucf
 BfOsnIXY915tITaMGkOf5iqZ/h0q1GHnf9fvteD21HrFO6z5h8pOsxSTGJ5IViUt4G78E58/BJSS3cD9de4tBRaZNMUgRkQEZiJncUtvSQjisI5AJ6v2820Tk4GuwKriGxcWIOp/h9aV3Rz4ftgDqCPN5VaMkT5qZzcBZammIjXbsUGGbXm7tFzIzbF0YARnqA44egIr7gbNmDHmb9aNfSCHCxbb+39rjjVi4Nokkp1kJ58gbIaJprjiqxKuQ2UXdglPB0oj1ntu7g5qIAcatAPvwgmS3kE8WxVxQw/kp6/MXDqtsDT3Ki+I3yvwFgDbDCyAeG9BRTXdG35C1JJERCw0190OkKhCW8DZkxfSn5HTkvrO8mGZXNsvnmxRgSh//TOR+DoRUfuZqqeLEFk08saZbw2k/G04wrX4T8dU+N0k1Iewc7R9IOZbSwVwHXJc21/BF33L+cIkI3MGI3E+t2iiXNgeyXi4nw4dkybbUKpfBPUldyzC5ClbIJKrp1Q+D3FOF397fGk4pVrMV5BW6+brohLyrKAceijtbSovAAVznGKRDVgWX79C3Ox1pbxramPJYsQe4OK17rDyEI5I/QM1zZDtIkqTSFe5uX2i4GTN4RZ0sXzPtAq5W4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 5:39=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> Hello Ravi,
>
>
> This version looks good, except very trivial nits.

 Hi SJ,

  Thanks for the super quick review! Very helpful.

>
> On Fri, 24 Apr 2026 13:34:48 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > Background and Motivation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> > In heterogeneous memory systems, controlling memory distribution across
> > NUMA nodes is essential for performance optimization. This patch enable=
s
> > system-wide page distribution with target-state goals such as "maintain
> > 60% of scheme-eligible memory on DRAM" using PA-mode DAMON schemes.
> >
> > Rather than using absolute thresholds, this metric tracks the ratio of
> > memory that matches each scheme's access pattern filters on a target
> > node, enabling the quota system to automatically adjust migration
> > aggressiveness to maintain the desired distribution.
> >
> > What This Metric Measures
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> > node_eligible_mem_bp:
> >     scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000
> >
> > The metric iterates through each scheme's eligible regions and uses
> > damon_get_folio() to determine NUMA node placement of each folio.
> >
> > Two-Scheme Setup for Hot Page Distribution
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > For maintaining hot memory on DRAM (node 0) and CXL (node 1) in a 6:4
> > ratio (per SeongJae Park's suggestion):
> >
> >     PULL scheme: migrate_hot to node 0
> >       goal: node_eligible_mem_bp, nid=3D0, target=3D6000
> >       "Move hot pages to DRAM if less than 60% of hot data is in DRAM"
>
> You also set a damos filter of node type with node id 1 for this scheme, =
right?
>
> >
> >     PUSH scheme: migrate_hot to node 1
> >       goal: node_eligible_mem_bp, nid=3D1, target=3D4000
> >       "Move hot pages to CXL if less than 40% of hot data is in CXL"
>
> And you set damos filter of node type with node id 0 here, right?
>
> I think it would good to mention that here, too.
>

 Good point. I'll add a note explaining that each scheme uses DAMOS
addr filters
  to restrict the source node - PULL uses an addr filter for node 1's
address
  range, and PUSH uses an addr filter for node 0's address range.

> >
> > Each scheme independently measures its own eligible memory and adjusts
> > its quota to achieve its target ratio. The schemes work in concert
> > through DAMON's unified monitoring context, with the quota autotuner
> > balancing their relative aggressiveness.
> >
> > Implementation Details
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Key implementation considerations:
> > - Uses phys_addr_t for byte calculations to prevent overflow on 32-bit
> >   architectures with large memory configurations
> > - Includes cond_resched() per region to prevent CPU soft lockups when
> >   processing large numbers of regions
> > - Validates that ops type is DAMON_OPS_PADDR in both damon_commit_ctx()
> >   (for clear error feedback) and the metric function (defensive check)
> > - Properly handles folio alignment when region addresses fall within
> >   large folios by calculating exact overlap
>
> This is changelog from the previous version [1], right?  Let's put all
> changelog from all previous version on the commentary area [2].
>

Understood. Will move this to the commentary area and include the
full changelog history from RFC v1.

> >
> > The implementation requires CONFIG_DAMON_PADDR since damon_get_folio()
> > is only available for physical address space monitoring.
> >
> > Testing Results
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Functionally tested on a two-node heterogeneous memory system with DRAM
> > (node 0) and CXL memory (node 1). A PUSH+PULL scheme configuration usin=
g
> > migrate_hot actions was used to reach a target hot memory ratio between
> > the two tiers.
> >
> > With the TEMPORAL tuner, the system converges quickly to the target
> > distribution. The tuner drives esz to maximum when under goal and to
> > zero once the goal is met, forming a simple on/off feedback loop that
> > stabilizes at the desired ratio.
> >
> > With the CONSIST tuner, the scheme still converges but more slowly, as
> > it migrates and then throttles itself based on quota feedback. The time
> > to reach the goal varies depending on workload intensity.
> >
> > Note: This metric works with both TEMPORAL and CONSIST goal tuners.
> >
> > Suggested-by: SeongJae Park <sj@kernel.org>
> > Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> > ---
> >  include/linux/damon.h    |   3 +
> >  mm/damon/core.c          | 171 +++++++++++++++++++++++++++++++++++----
> >  mm/damon/sysfs-schemes.c |   7 ++
> >  3 files changed, 165 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/linux/damon.h b/include/linux/damon.h
> > index f2cdb7c3f5e6..986b8c902585 100644
> > --- a/include/linux/damon.h
> > +++ b/include/linux/damon.h
> > @@ -159,6 +159,8 @@ enum damos_action {
> >   * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:  MemFree ratio of a node for a cgr=
oup.
> >   * @DAMOS_QUOTA_ACTIVE_MEM_BP:               Active to total LRU memor=
y ratio.
> >   * @DAMOS_QUOTA_INACTIVE_MEM_BP:     Inactive to total LRU memory rati=
o.
> > + * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:        Scheme-eligible memory ra=
tio of a
> > + *                                   node in basis points (0-10000).
> >   * @NR_DAMOS_QUOTA_GOAL_METRICS:     Number of DAMOS quota goal metric=
s.
> >   *
> >   * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsup=
ported.
> > @@ -172,6 +174,7 @@ enum damos_quota_goal_metric {
> >       DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
> >       DAMOS_QUOTA_ACTIVE_MEM_BP,
> >       DAMOS_QUOTA_INACTIVE_MEM_BP,
> > +     DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> >       NR_DAMOS_QUOTA_GOAL_METRICS,
> >  };
> >
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 3dbbbfdeff71..4ac805205261 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -13,10 +13,14 @@
> >  #include <linux/memcontrol.h>
> >  #include <linux/mm.h>
> >  #include <linux/psi.h>
> > +#include <linux/sched.h>
> >  #include <linux/slab.h>
> >  #include <linux/string.h>
> >  #include <linux/string_choices.h>
> >
> > +/* for damon_get_folio() used by node eligible memory metrics */
> > +#include "ops-common.h"
> > +
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/damon.h>
> >
> > @@ -1326,11 +1330,25 @@ static int damon_commit_targets(
> >  int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
> >  {
> >       int err;
> > +     struct damos *scheme;
> > +     struct damos_quota_goal *goal;
> >
> >       dst->maybe_corrupted =3D true;
> >       if (!is_power_of_2(src->min_region_sz))
> >               return -EINVAL;
> >
> > +     /* node_eligible_mem_bp metric requires PADDR ops */
> > +     if (src->ops.id !=3D DAMON_OPS_PADDR) {
> > +             damon_for_each_scheme(scheme, src) {
> > +                     struct damos_quota *quota =3D &scheme->quota;
> > +
> > +                     damos_for_each_quota_goal(goal, quota) {
> > +                             if (goal->metric =3D=3D DAMOS_QUOTA_NODE_=
ELIGIBLE_MEM_BP)
>
> Let's wrap this line to keep the 80 columns limit.

Will wrap this in v8.

>
> > +                                     return -EINVAL;
> > +                     }
> > +             }
> > +     }
> > +
> >       err =3D damon_commit_schemes(dst, src);
> >       if (err)
> >               return err;
> > @@ -2287,7 +2305,112 @@ static unsigned long damos_get_node_memcg_used_=
bp(
> >               numerator =3D i.totalram - used_pages;
> >       return mult_frac(numerator, 10000, i.totalram);
> >  }
> > -#else
> > +
> > +#ifdef CONFIG_DAMON_PADDR
> > +/*
> > + * damos_calc_eligible_bytes() - Calculate raw eligible bytes per node=
.
> > + * @c:               The DAMON context.
> > + * @s:               The scheme.
> > + * @nid:     The target NUMA node id.
> > + * @total:   Output for total eligible bytes across all nodes.
> > + *
> > + * Iterates through each folio in eligible regions to accurately deter=
mine
> > + * which node the memory resides on. Returns eligible bytes on the spe=
cified
> > + * node and sets *total to the sum across all nodes.
> > + *
> > + * Note: This function requires damon_get_folio() from ops-common.c, w=
hich is
> > + * only available when CONFIG_DAMON_PADDR is enabled. It also requires=
 the
> > + * context to be using PADDR operations for meaningful results.
> > + */
> > +static phys_addr_t damos_calc_eligible_bytes(struct damon_ctx *c,
> > +             struct damos *s, int nid, phys_addr_t *total)
> > +{
> > +     struct damon_target *t;
> > +     struct damon_region *r;
> > +     phys_addr_t total_eligible =3D 0;
> > +     phys_addr_t node_eligible =3D 0;
> > +
> > +     damon_for_each_target(t, c) {
> > +             damon_for_each_region(r, t) {
> > +                     phys_addr_t addr, end_addr;
> > +
> > +                     if (!__damos_valid_target(r, s))
> > +                             continue;
> > +
> > +                     /* Convert from core address units to physical by=
tes */
> > +                     addr =3D (phys_addr_t)r->ar.start * c->addr_unit;
> > +                     end_addr =3D (phys_addr_t)r->ar.end * c->addr_uni=
t;
> > +                     while (addr < end_addr) {
> > +                             struct folio *folio;
> > +                             phys_addr_t folio_start, folio_end;
> > +                             phys_addr_t overlap_start, overlap_end;
> > +                             phys_addr_t counted;
> > +
> > +                             folio =3D damon_get_folio(PHYS_PFN(addr))=
;
> > +                             if (!folio) {
> > +                                     addr +=3D PAGE_SIZE;
>
> Sashiko found [3] this may better to be aligned.  It is trivial but I agr=
ee.
> How about using PAGE_ALIGN_DOWN(addr + PAGE_SIZE)?

Agreed, will change to PAGE_ALIGN_DOWN(addr + PAGE_SIZE) in v8.

>
> > +                                     continue;
> > +                             }
> > +
> > +                             /*
> > +                              * Calculate exact overlap between the re=
gion
> > +                              * [addr, end_addr) and the folio range.
> > +                              * The folio may start before addr if add=
r is
> > +                              * in the middle of a large folio.
> > +                              */
> > +                             folio_start =3D PFN_PHYS(folio_pfn(folio)=
);
> > +                             folio_end =3D folio_start + folio_size(fo=
lio);
> > +
> > +                             overlap_start =3D max(addr, folio_start);
> > +                             overlap_end =3D min(end_addr, folio_end);
> > +
> > +                             if (overlap_end > overlap_start) {
> > +                                     counted =3D overlap_end - overlap=
_start;
> > +                                     total_eligible +=3D counted;
> > +                                     if (folio_nid(folio) =3D=3D nid)
> > +                                             node_eligible +=3D counte=
d;
> > +                             }
> > +
> > +                             /* Advance past the entire folio */
> > +                             addr =3D folio_end;
> > +                             folio_put(folio);
> > +                     }
> > +                     cond_resched();
> > +             }
> > +     }
> > +
> > +     *total =3D total_eligible;
> > +     return node_eligible;
> > +}
> > +
> > +static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *=
c,
> > +             struct damos *s, int nid)
> > +{
> > +     phys_addr_t total_eligible =3D 0;
> > +     phys_addr_t node_eligible;
> > +
> > +     if (c->ops.id !=3D DAMON_OPS_PADDR)
> > +             return 0;
> > +
> > +     if (nid < 0 || nid >=3D MAX_NUMNODES || !node_online(nid))
> > +             return 0;
>
> Trivial nit.  I'd prefer using '!node_state(nid, N_MEMORY)' to be consist=
ent
> with the similar one in damon_migrate_pages().  But this one seems fine t=
o me.

Thanks for the suggestion. I'll keep node_online() for now as you
indicated
  it's fine, but happy to change it later, if you prefer consistency.

>
> > +
> > +     node_eligible =3D damos_calc_eligible_bytes(c, s, nid, &total_eli=
gible);
> > +
> > +     if (!total_eligible)
> > +             return 0;
> > +
> > +     return mult_frac((unsigned long)node_eligible, 10000,
> > +                     (unsigned long)total_eligible);
> > +}
> > +#else /* CONFIG_DAMON_PADDR */
> > +static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *=
c,
> > +             struct damos *s, int nid)
> > +{
> > +     return 0;
> > +}
> > +#endif /* CONFIG_DAMON_PADDR */
> > +#else /* CONFIG_NUMA */
> >  static __kernel_ulong_t damos_get_node_mem_bp(
> >               struct damos_quota_goal *goal)
> >  {
> > @@ -2299,7 +2422,13 @@ static unsigned long damos_get_node_memcg_used_b=
p(
> >  {
> >       return 0;
> >  }
> > -#endif
> > +
> > +static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *=
c,
> > +             struct damos *s, int nid)
> > +{
> > +     return 0;
> > +}
> > +#endif /* CONFIG_NUMA */
> >
> >  /*
> >   * Returns LRU-active or inactive memory to total LRU memory size rati=
o.
> > @@ -2319,7 +2448,8 @@ static unsigned int damos_get_in_active_mem_bp(bo=
ol active_ratio)
> >       return mult_frac(inactive, 10000, total);
> >  }
> >
> > -static void damos_set_quota_goal_current_value(struct damos_quota_goal=
 *goal)
> > +static void damos_set_quota_goal_current_value(struct damon_ctx *c,
> > +             struct damos *s, struct damos_quota_goal *goal)
> >  {
> >       u64 now_psi_total;
> >
> > @@ -2345,19 +2475,24 @@ static void damos_set_quota_goal_current_value(=
struct damos_quota_goal *goal)
> >               goal->current_value =3D damos_get_in_active_mem_bp(
> >                               goal->metric =3D=3D DAMOS_QUOTA_ACTIVE_ME=
M_BP);
> >               break;
> > +     case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> > +             goal->current_value =3D damos_get_node_eligible_mem_bp(c,=
 s,
> > +                             goal->nid);
> > +             break;
> >       default:
> >               break;
> >       }
> >  }
> >
> >  /* Return the highest score since it makes schemes least aggressive */
> > -static unsigned long damos_quota_score(struct damos_quota *quota)
> > +static unsigned long damos_quota_score(struct damon_ctx *c, struct dam=
os *s)
> >  {
> >       struct damos_quota_goal *goal;
> > +     struct damos_quota *quota =3D &s->quota;
> >       unsigned long highest_score =3D 0;
> >
> >       damos_for_each_quota_goal(goal, quota) {
> > -             damos_set_quota_goal_current_value(goal);
> > +             damos_set_quota_goal_current_value(c, s, goal);
> >               highest_score =3D max(highest_score,
> >                               mult_frac(goal->current_value, 10000,
> >                                       goal->target_value));
> > @@ -2366,17 +2501,19 @@ static unsigned long damos_quota_score(struct d=
amos_quota *quota)
> >       return highest_score;
> >  }
> >
> > -static void damos_goal_tune_esz_bp_consist(struct damos_quota *quota)
> > +static void damos_goal_tune_esz_bp_consist(struct damon_ctx *c, struct=
 damos *s)
>
> 80 columns limit?

I checked - `damos_goal_tune_esz_bp_consist` is exactly 80 characters,
so it's
  fine as-is. However, `damos_goal_tune_esz_bp_temporal` below is 81
  characters, so I'll wrap that one in v8.

>
> >  {
> > -     unsigned long score =3D damos_quota_score(quota);
> > +     struct damos_quota *quota =3D &s->quota;
> > +     unsigned long score =3D damos_quota_score(c, s);
> >
> >       quota->esz_bp =3D damon_feed_loop_next_input(
> >                       max(quota->esz_bp, 10000UL), score);
> >  }
> >
> > -static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
> > +static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c, struc=
t damos *s)
> >  {
> > -     unsigned long score =3D damos_quota_score(quota);
> > +     struct damos_quota *quota =3D &s->quota;
> > +     unsigned long score =3D damos_quota_score(c, s);
> >
> >       if (score >=3D 10000)
> >               quota->esz_bp =3D 0;
> > @@ -2389,9 +2526,9 @@ static void damos_goal_tune_esz_bp_temporal(struc=
t damos_quota *quota)
> >  /*
> >   * Called only if quota->ms, or quota->sz are set, or quota->goals is =
not empty
> >   */
> > -static void damos_set_effective_quota(struct damos_quota *quota,
> > -             struct damon_ctx *ctx)
> > +static void damos_set_effective_quota(struct damon_ctx *c, struct damo=
s *s)
> >  {
> > +     struct damos_quota *quota =3D &s->quota;
> >       unsigned long throughput;
> >       unsigned long esz =3D ULONG_MAX;
> >
> > @@ -2402,9 +2539,9 @@ static void damos_set_effective_quota(struct damo=
s_quota *quota,
> >
> >       if (!list_empty(&quota->goals)) {
> >               if (quota->goal_tuner =3D=3D DAMOS_QUOTA_GOAL_TUNER_CONSI=
ST)
> > -                     damos_goal_tune_esz_bp_consist(quota);
> > +                     damos_goal_tune_esz_bp_consist(c, s);
> >               else if (quota->goal_tuner =3D=3D DAMOS_QUOTA_GOAL_TUNER_=
TEMPORAL)
> > -                     damos_goal_tune_esz_bp_temporal(quota);
> > +                     damos_goal_tune_esz_bp_temporal(c, s);
> >               esz =3D quota->esz_bp / 10000;
> >       }
> >
> > @@ -2415,7 +2552,7 @@ static void damos_set_effective_quota(struct damo=
s_quota *quota,
> >               else
> >                       throughput =3D PAGE_SIZE * 1024;
> >               esz =3D min(throughput * quota->ms, esz);
> > -             esz =3D max(ctx->min_region_sz, esz);
> > +             esz =3D max(c->min_region_sz, esz);
> >       }
> >
> >       if (quota->sz && quota->sz < esz)
> > @@ -2452,7 +2589,9 @@ static void damos_adjust_quota(struct damon_ctx *=
c, struct damos *s)
> >       /* First charge window */
> >       if (!quota->total_charged_sz && !quota->charged_from) {
> >               quota->charged_from =3D jiffies;
> > -             damos_set_effective_quota(quota, c);
> > +             damos_set_effective_quota(c, s);
> > +             if (trace_damos_esz_enabled())
> > +                     damos_trace_esz(c, s, quota);
>
> damos_trace_esz() seems an unintended change?

Yes, this was unintended. Will remove it in v8.

>
> >       }
> >
> >       /* New charge window starts */
> > @@ -2467,7 +2606,7 @@ static void damos_adjust_quota(struct damon_ctx *=
c, struct damos *s)
> >               quota->charged_sz =3D 0;
> >               if (trace_damos_esz_enabled())
> >                       cached_esz =3D quota->esz;
> > -             damos_set_effective_quota(quota, c);
> > +             damos_set_effective_quota(c, s);
> >               if (trace_damos_esz_enabled() && quota->esz !=3D cached_e=
sz)
> >                       damos_trace_esz(c, s, quota);
> >       }
> > diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> > index 245d63808411..f21191d31f58 100644
> > --- a/mm/damon/sysfs-schemes.c
> > +++ b/mm/damon/sysfs-schemes.c
> > @@ -1094,6 +1094,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs=
_qgoal_metric_names[] =3D {
> >               .metric =3D DAMOS_QUOTA_INACTIVE_MEM_BP,
> >               .name =3D "inactive_mem_bp",
> >       },
> > +     {
> > +             .metric =3D DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> > +             .name =3D "node_eligible_mem_bp",
> > +     },
> >  };
> >
> >  static ssize_t target_metric_show(struct kobject *kobj,
> > @@ -2685,6 +2689,9 @@ static int damos_sysfs_add_quota_score(
> >                       }
> >                       goal->nid =3D sysfs_goal->nid;
> >                       break;
> > +             case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> > +                     goal->nid =3D sysfs_goal->nid;
> > +                     break;
> >               default:
> >                       break;
> >               }
> >
> > base-commit: 277a7fae172bb4a598e0d4144ffb2ff6207fedb3
> > --
> > 2.43.0
>
> I also reviewed Sashiko review [3] and I find no real problem except the =
addr
> alignment.
>
> So this looks good to me, except the trivial things I commented above.  C=
ould
> you please revision for the last time?

Will do. Summary of changes for v8:
  1. Mention addr filters for source-node filtering in Two-Scheme
Setup
  2. Move implementation details to commentary area with full
changelog
  3. Wrap the 80-column violation in damon_commit_ctx()
  4. Use PAGE_ALIGN_DOWN(addr + PAGE_SIZE) for alignment
  5. Wrap damos_goal_tune_esz_bp_temporal() (81 chars)
  6. Remove unintended damos_trace_esz() from first charge window

  Thanks,
  Ravi

>
> [1] https://lore.kernel.org/20260405184247.2690-1-ravis.opensrc@gmail.com
> [2] https://docs.kernel.org/process/submitting-patches.html#commentary
> [3] https://lore.kernel.org/20260424205908.CF949C2BCB8@smtp.kernel.org
>
>
> Thanks,
> SJ

