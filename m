Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88990CD6E60
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 23:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74986B0005; Wed,  3 Jun 2026 19:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25BE6B0088; Wed,  3 Jun 2026 19:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14D56B008A; Wed,  3 Jun 2026 19:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2016B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:57:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F44C1A017D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:57:27 +0000 (UTC)
X-FDA: 84840265734.25.3523EB3
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 23F0E40004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:57:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UiiRd4NE;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780531045;
	b=iPY4p6wE1rzK4/xlR3jIHrikYU2LlSq4811NNnX690bx7uiWFvztmB/oAnrqVhOsxUWqYb
	mS4cGCiV+1Hb3erW74QZy1lCjU1Jy90nucxC6wsHNfAY6dhAihn4UgUPoojWrsofV4DRo8
	kaQ2Y6vgqw1I0F1hJA3Vk4yRt4CZxJ0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UiiRd4NE;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780531045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mNur1Fonoy8Eha+exfChjghnGVF1uWKh6Gmh7Ox8d4A=;
	b=M5omdGV1vZOYrI+7i/+3zG+Zq03q1Mh2djpCSVoEQqcNdESYeV0mTd/iWmoZz1gctwJWt0
	k1F13mjTEpgw5f1NsVT0SvZwwSjI6bCsu7YwGL++UfhpKE5gZ0O+/LF70Wu2fLaTr5jmhP
	GKTyWe3Y4A+3RMpCDyTzFZMj+Vpe7lg=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51765331535so124821cf.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 16:57:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780531044; cv=none;
        d=google.com; s=arc-20240605;
        b=U93H/eNppc6+MSTpzrHZV+R9UPGnEKsDY09u4WJTrTZUUS/llq8Ae3qDoDLdhRNPkm
         0O97xj23LRxlUjMOsgOIv5rzgbicwq4K17AWtuSVbSdCYNyVSGixWDgCXEIfSXGT8EzN
         3XocP/X9ZSGbCUbd5DNEsQR24SAB7AMoS/GwG5/rK7qybmT8AxllmtP8MLVx5WbY1S5b
         WAP1GAr/YbBz6HOQYEs4Anrmn20psRnItaeohqhEUOPOwk9kQJcEQgUjIMjJayJHI+LV
         P5w2FtFcHlK3mEy7AJzFTY8CdI5JUfoasGghGY8PKgC31ddL8hFkOH0EZz8BEcRdu1/E
         0PCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mNur1Fonoy8Eha+exfChjghnGVF1uWKh6Gmh7Ox8d4A=;
        fh=3DWszfi9FubAXdE2kjBrE5Rm1UB5YwGzpfxZtuchYPU=;
        b=hTFNAdZcV6WxTvJ5FcQsnhzQ0E/jaVGzEHSc26Rr2vrNKdt1IEzqDCduEu2hN5qZbT
         dro6kUVzfGTY/vMl8Knq+cYxd68SZfJjFByW3qEXS9FpZ0E2BQDf6cyCawE9K1Y9/WRo
         A6dIUNEuJIFQ3faE9Tf0tFKufBib0RFFA0WnxB23+V52lE3p21D0yu6IHBYOBI9ZPfyV
         6G3fY9nBnQuwala0orYYdzHxgQzm7l+FKKju1qdZ+nkKHeSHMBwVd6GAI5YNRHHDkgah
         3Cs1fAWlFTPMUkkFQv/VAwVOiqWWhx5F9lgccWXEKo8jACYcgqQwRUstpFUF/A8E6OLE
         zNdQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780531044; x=1781135844; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNur1Fonoy8Eha+exfChjghnGVF1uWKh6Gmh7Ox8d4A=;
        b=UiiRd4NELeggvBxrGxvkbhnWb9gzza1CbDj0OYjHCJOyEFOOAqBLNdEetaDgFJM+be
         VaGLejcjFJAdve28Otu0DRqFx2G4c7YQdQY/WQXb1Cbrq2SmGnjdiWd9ccO53z4rEOgT
         VsK/pru80z2+QCbHPJFXSF5Q28cftEdWncEv2QaVDoSU7Tn9IlCloYAU0lIxbP2h9moY
         GmGLDWzbMMa8usOBFx9CE98KaD7Prx0SXDwJ2q9R7Z/PZDlWp3m7VLoXxbAOuAXAhy2J
         pAeNh1fqODygaSAxQZjItG5DtwM1dIrbXEUYL85tgj6lpimD4/VCUULHESj2YbgBSJrD
         AufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780531044; x=1781135844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mNur1Fonoy8Eha+exfChjghnGVF1uWKh6Gmh7Ox8d4A=;
        b=nYAGm2lp0IFqOr2/zNimkZaeuvqg09l7weGk2LmpwGkyAZOztip2Mray/9oWF/ZI08
         DssvlR0+kZMpRhip3yuLYx7q4gNzVKmssGhWlV3lgiYyTx4oAUvS7CLnL49wP3YSqQZ7
         f6OVGgGxmFr0UwWsXWVloxlW193ysjRoy/cG1wlO81P4QbJJbJPPaOY/PPTqzh6EMTh/
         M9q2ebOoIGVYdoi3WH0RwyCdCpa6B7Jb8MEY98W+GUEfnFa7C1DfECyptp+R6ONOsY02
         jJLmVR27CUGxZM21KffFtwf3EGxaKQR8Rx7S0N5kCb67pdtAcbOf0g4VzM8itF67e5Uh
         cpww==
X-Forwarded-Encrypted: i=1; AFNElJ9SDztpcfhsvKVJvSkFoXQg6v5EkFdS5Qp8NFyekzuTaHYdBvYTBo44NX1xatuo2Sre+c9LEdTwbQ==@kvack.org
X-Gm-Message-State: AOJu0YwcGoBlsOBAp3NTlB+UfLY5FN6GYHu0sfJnwpyTIzmKaB2dk3QG
	W4Pd2tXJ59xao8FsEYQRxms9tcDEhSIQvcCg6rvdROLdvy6rPcIoVliUCW+iseS0SJRg82nWdIm
	w4KAkIjpLVL9D9blqiQoQrVH1/VS+lbcXdr+8ONIW
X-Gm-Gg: Acq92OG+rHZUxHGPEBPXZh/BQ7hol6F5BWitkIj5irxflWoeK7JAW/1/Xp39NH2rC9e
	iiJK9wQwZrsqkpZhEOVEqtVBVVXT/1CPgNeawTjX2o+4a+hSYZtrQX4HV2qAfnjBDK1lsti37jF
	GdnYCQQmr30cIrdG4yMJVimqrja2DUpmX7gIdXTelxdIBuOZ320Mzfxe7Z3BTKtVCx/Sbt96lTD
	IopWi4CEfCalH9dVfqjMQCZWhKLdD9Lpdq14j8MJiccWTK455U/yTacdrC1XFSfDkq6bhI9JxMr
	/F9KiCYYBkBp8pkO
X-Received: by 2002:ac8:4651:0:b0:516:4f62:85ed with SMTP id
 d75a77b69052e-51787a79f2dmr3993231cf.18.1780531043458; Wed, 03 Jun 2026
 16:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260426062718.1238437-1-surenb@google.com> <a27344e1-6f0c-4686-99ac-fc2cfcc5bb06@kernel.org>
 <CAJuCfpG3xZhL94E=yR1KsWs6fVwcdoAECoOaV3UOeB10TXmOeg@mail.gmail.com>
 <0ce6071b-0c99-4119-9ab4-a2d9c00b99a8@kernel.org> <CAJuCfpHPs54_hc_U9DCxtv=xikKHJMtqCEDN_4Y5aDqKhoBDnA@mail.gmail.com>
 <20260526184944.18c28d6980fd29ff12fbbe22@linux-foundation.org> <ahhdeYDAY7BvqxYU@lucifer>
In-Reply-To: <ahhdeYDAY7BvqxYU@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 3 Jun 2026 16:57:12 -0700
X-Gm-Features: AVHnY4LIv-CCSzubXeLRacENeIWLGZDTxSTnCRRjCibVInHfLzdXyTHGiqn3Ug0
Message-ID: <CAJuCfpHqNJWVt2DUB_yi0Yj7Y=bB1xV4qYeAKM2RZZMW6xBFKw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] use vma locks for proc/pid/{smaps|numa_maps} reads
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>, liam@infradead.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, 
	richard.weiyang@gmail.com, reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 23F0E40004
X-Rspam-User: 
X-Stat-Signature: bn9gm7s545wfghtf5qx8yjj6emhkbh4j
X-HE-Tag: 1780531044-938355
X-HE-Meta: U2FsdGVkX1+OgtaKzQYxGm+BHcLfpLDQB4BnelcoVyU8vIWVMDFAdHKEuy3J3cJUhj7Qn3I8cjo/8alXPaeaoqdQDg/q4wXrqR8x+rfnYAWIVbl/qCeECkvSn5cNAQJsOCaEHyEJngsJXth0GH+k+Q7yb9ppzk8l/PnlhJGfbB2p0beh6eBQPu3agL8ffVYW+B2r2hwsRr6nu0POGltIl3U7GHbLCTBjWvUVirHt/igirNEh/Q5BcEb/dvihNgz6FGZXLZbZw3p39ZMp/43XHJxIlrllepWdWDT2RW61SAoIyZXZc5wk25vuekR7y1/FtLjyA1Jh05FKGokaiG88JeYMLDfRtE3nfGFQHNKNFfDZd1vmQGRE82esWOZzr8N5Jyanhkt8swl6scxuB8JuBC8HdvTJCdJzBGYmxrOQqTrrWDBp/wXSiZR0I/CHLbOzMj+PUjG7bOJXsnDn6hdlxwGtXbPxOBkF0p7Td1Inxksj35R7TysMqk6WXtazgHD7CuOs4GC+pBXjhQfB6GlzncaQ9kQAW2NAy4RiyQzkB9lfwoZv43btSz8oiHGL4NAceOWIDvYf9ZLqmvYreBNgbvaeDDa5Ct7MEFEdrg//a72QBas7PTkKDMCiuZ5NHkap7ywSWu/+FQYRqXXAKc9p2qsyWwzoPWe1fVCk+DLa8q4Azhu5miBHP8t6nHgn4Elmy9mxTD84E+NePLToctNofktJOBbCE2yeWLQLl+/5tiErzvt1iyPLbYL9LME46LCspO4ZSS7MOrLKnmVJ+abwf90A7I4h+d796MGBtsG8PaZaO2sbPwEPFVYEWvInbVYI1e+XClC+hxJLNzYtWj9jYjNuylykynOAknsXDbET8Omao7GKjsTEkHQgLWjSuzK3NGYvdsKvRfI8TJUq2RAcLyYDmMADXE8eTEDKHG3Lfs3EgL3wGfAOra3XwGBUkSxPCsECokwlKfzPGsJmArD
 WIa+gwUw
 42kgp909+T/FWWI3t2cB7qEgSCYMJQHBQJWB+U7jjm5CK/KavTHIAcUdOrewFUQ7tix7QJ1doP4SZVyd3mQGCcYNDaIv8Umb4Qm14tVjcphX9E6R7D6kQHH8v+LmPs3QduJu7ejHU7XeuSVwJoeMqEvulg7asH0PmNV3qgk2A/iigNcIWRaqnO+6MLLG2dgjfywD/i43yMXNbc5Z8d5YLRqrurn01rc9UVEI1+5fVWPsFVKlrQ7Si8VQG3ypfdtgpoKZyknFrU2FO0Cyeb3AAOKjOKQm8Mx/0y2zpir7vFJqd+QDasylWUzu4VbpGDDax4tPtO1aUPxnn6UobNv/jasNCa0M2xDeB/9OVHLd45lV3emdA+zG6NPFj+GbYhOEgPSBf/Dt3bf05kk85ZxmIJJBSnf234K6cS566atjgv/DRA/8g5j2YGAnR2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 8:37=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Tue, May 26, 2026 at 06:49:44PM -0700, Andrew Morton wrote:
> > On Thu, 21 May 2026 08:16:01 -0700 Suren Baghdasaryan <surenb@google.co=
m> wrote:
> >
> > > > > It might be but the point of this patchset (and the previous one =
that
> > > > > made a similar change for /proc/pid/maps) is to reduce mmap_lock
> > > > > contention, not to speed up the read operation, which is not a
> > > > > performance critical part.
> > > >
> > > > Well, this interface has been around .. forever, so if there is a n=
oticeable
> > > > change in performance it should be called out.
> > >
> > > Sorry, I missed your reply. I'll see if I can adopt Paul's test for
> > > /proc/pid/maps [1] for benchmarking smaps but I would expect similar
> > > results as was reported in [2].
> >
> > How's it coming along ;)
> >
> > > [1] https://github.com/paulmckrcu/proc-mmap_sem-test
> > > [2] https://lore.kernel.org/all/20250719182854.3166724-1-surenb@googl=
e.com/
> >
> > I've moved this series to the tail of mm-unstable to permit more time.
>
> Well I'm not sure it's _vital_ to get stats for this, it's pretty much an
> extension of existing VMA lock work in /proc/$pid/maps -> smaps, and the
> logic is sound.
>
> There's no reason to believe there will be anything other than a reductio=
n
> in lock contention here at least under whichever workloads happen to hamm=
er
> smaps, but doesn't feel like there's a downside!

Just finished running Paul's test. I ran a smaller number of
iterations (20 instead of 100) because it takes lots of time but
results are quite convincing.
In the baseline, all runs had maximum latencies exceeding 9.7
milliseconds. In contrast, the patched version has maximum latencies
in the range of 1.8-3.2 milliseconds.
Median performance of the baseline is at 1.135 milliseconds and patch
series at 7 microseconds.

Baseline
./run-proc-vs-map.sh --nsamples 20 --rawdata -- --busyduration 2
    1.135     1.078     9.737
    1.135     1.086     9.834
    1.135     1.090     9.890
    1.135     1.091     9.892
    1.135     1.111     9.894
    1.135     1.119     9.896
    1.135     1.120     9.918
    1.135     1.123     9.927
    1.135     1.130     9.937
    1.135     1.132     9.940
    1.135     1.138     9.942
    1.135     1.140     9.944
    1.135     1.141     9.952
    1.135     1.148     9.952
    1.135     1.153     9.958
    1.135     1.153     9.967
    1.135     1.167     9.974
    1.135     1.168     9.975
    1.135     1.173     9.982
    1.135     1.199    10.014

Patched
./run-proc-vs-map.sh --nsamples 20 --rawdata -- --busyduration 2
    0.007     0.006     1.862
    0.007     0.006     1.937
    0.007     0.006     1.947
    0.007     0.007     1.956
    0.007     0.007     1.956
    0.007     0.007     1.998
    0.007     0.007     2.020
    0.007     0.007     2.027
    0.007     0.007     2.085
    0.007     0.007     2.100
    0.007     0.007     2.115
    0.007     0.007     2.233
    0.007     0.007     2.304
    0.007     0.007     2.325
    0.007     0.007     2.327
    0.007     0.007     2.427
    0.007     0.007     2.489
    0.007     0.007     2.500
    0.007     0.007     3.123
    0.007     0.007     3.151


>
> Cheers, Lorenzo

