Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC30606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 03:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LS2Acadh
Received: by kanga.kvack.org (Postfix)
	id E8FF96B05B1; Wed,  4 Nov 2026 22:27:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41636B05B2; Wed,  4 Nov 2026 22:27:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32836B05B3; Wed,  4 Nov 2026 22:27:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9A406B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:27:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DEAE1608D9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:27:38 +0000 (UTC)
X-FDA: 85399630596.29.05BF3D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48FD4A0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:27:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LS2Acadh;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793849256;
	b=77/nzXHGL0CT1zVaLxbq0MxezOfr9h1y1jTv/g5EtAtTIIozp0LlnUhsWWECaH0KfL49KD
	8EueEy03A+gbOlrO4kzaIQpKm4X4khZWq7jmhlR37jNyC/LNTTwfNim74zr6Ei3pU3CceY
	kBpUI0OQYMGYztt+3/Q4Ocp//5csHd0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LS2Acadh;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793849256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQ6/Ur2Ztz2O4rfLqNBWUInfKhM6NZjd2sT9yss+u2o=;
	b=XVLKyhnErQj/GuBUdRmImk7YDzc8Ge4JtuAqa4z9WkvoSkkQN2Y21tUw2zVM1dI2wZ+jyY
	6enD/NBaGYFL30Wc+1qRK+lbHR9Vs0Fl6hotPcJ9DtbNacfQQbdEd+v+27V4vbUpWEcnDn
	R7g0D5JScMmHyLNT6C633uo31ombqQ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F8C144002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6346C1F00A1A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793849255;
	bh=sQ6/Ur2Ztz2O4rfLqNBWUInfKhM6NZjd2sT9yss+u2o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LS2Acadhfn6hILfUYvGpBCTyIieYrD3AfljjQxecq9MGEO/g9587tREmY610EqRZh
	 f3MjYArLqMObvwkjPrffT4bvGlCb4+d6m80VoFa+swj7iSL4kBMMFtBL3qgNvR8UTr
	 WzqZBRa+4ALDRt8OH8NmVg1tpMJrw/BtqX7n7zaGGfdbND7LFGW8r78ydUeUPl1Wlp
	 2aLn8l1vTTToKo25H+ahV2wZsCNl96bpfOA0ctDJKBLIJhZtahH60IP/Xa+Y0HjuFR
	 RK+18CUJnyeCqJmToce59XfPJ7bCg03Oe1oXcUXEbe65hPEyMfroE/yhhrDbWT8M7y
	 St7cXpw+ak1OQ==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93e6eb77f0bso152020585a.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 19:27:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxn7N+WvU0eyEA172w71noKq202Iny9hFqSyVCPuTWaQuQA913eRI7D/Ua4X681FNbi/LiFUj+Vlw==@kvack.org
X-Gm-Message-State: APuU4Z/BGamBXGMrMvnGg31PPXJo3Yitjeuua8lNnLQxWy67Z8bAjTVE
	UFfdqsC5YSf7lP8RiV+/PCODuYL9VAfDFPNsLM7TdEl+655oevPKSohW/AjNFr0dh8ZhfW5JOkI
	Q4oVy7yLOcFfEUziZhZMr4UxAi7W5RRI=
X-Received: by 2002:a05:620a:29c1:b0:93c:6028:6d2b with SMTP id
 af79cd13be357-9442175b5b4mr3214199585a.43.1793849254703; Wed, 04 Nov 2026
 19:27:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <sashiko-outbox-175822@kernel.org> <20261018064458.86435-1-baohua@kernel.org>
 <CAGsJ_4zY5PrYgbFvY96R+52Tftp_eVrMkSbf_-2b3Tw0r6FgBw@mail.gmail.com> <auviWipVDTh_yk_T@KASONG-MC4>
In-Reply-To: <auviWipVDTh_yk_T@KASONG-MC4>
From: Barry Song <baohua@kernel.org>
Date: Thu, 5 Nov 2026 11:27:23 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yb2r2qjYjBLtYpVbQ99Nypp4rg0EuKmdkyFc8C9Tx-Nw@mail.gmail.com>
X-Gm-Features: AclHuK_LbbaHd7aSE3_-R1r36AiQG3L9nbe4GRiAsaOyf-W8t89lVdgv6ScOCG8
Message-ID: <CAGsJ_4yb2r2qjYjBLtYpVbQ99Nypp4rg0EuKmdkyFc8C9Tx-Nw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix using folio_mark_accessed to replace folio_set_active
To: Kairui Song <ryncsn@gmail.com>
Cc: ehab.ababneh@intel.com, sashiko-bot@kernel.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	kasong@tencent.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	qi.zheng@linux.dev, sashiko-reviews@lists.linux.dev, shakeel.butt@linux.dev, 
	weixugc@google.com, yuanchu@google.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48FD4A0002
X-Stat-Signature: romy591u5qgt7owh9mjzqg3cpzxpbhe3
X-Rspam-User: 
X-HE-Tag: 1793849256-494661
X-HE-Meta: U2FsdGVkX1+RqpbPz3NyIviFB075CcAXWm4Rzu8TEg2Jds2ZXHeGw7RuNflIvu3w3dAjc/FedJakAx/59iirvwKxjFCX3vUGX7bxzTl4xr8bkscZk5876IyhLtGP3/Nr3If+uiBODEz/6xu6g2kFo2l05so7X+dZDza/GLfrXIU1IJAI4LQq7A3Qx+06Yq90vp/QTYnrwQPaZbL6PQiQ1s9sxhvQj+PBSH7k63md2HDaPGmAk9kVjAd5nap5PYvEczJM+y9mg+Cf3NWSKTQ1GVYuwUISedI9nZQ26pkIAFTt8HgtlIRJEuAvgVV1tnaGr11sHqyuOwKOFX47qUxS+OrTzSyVhkhJfUycCw37KqxZIr1yuWa7S3o+mY9BSTfLbU5wEY4vxOQ8W7MdSG8HPDnGuSSIazth/gfxg41PYUvBibzkXrGU1EGmj7P+cZ+OzStOqBJioBj1taAnnMxlsUDQQ9x0fLHmiaeSLWk7q2GkDfnCMjKOqSD4laj6gF5IgRrRRAQ0K/Qow3FKckTI0F3n+35nWZKubHGXulezl4hR1ywvxBgR9oWwl7ONlo6F1cwnC7L/Hw0jxJDQ90fl9mgqWE0FIZqv5Ut/9BCtbYsjx6ObuNB38zt6KF/mWUJLwa6wVoSFmoFs4P3T8v9ng7jREPWkPxS0jqTaRbbO9lRbrmdArip4ioeDWTfoBCJsJX6F2gcqp9luwFfXuRvSaWLBJGje/PBJCvEIerNEXy7ze463goIXhg396uVNCQhpfB6yw6BlE3kMFFtYzvZbHS9WMhhGIictdehZxPq7gwTQ/9/xHHyaUL1eEMgLVBY0cfoWOSWNF9W8fVMMV3j8QMz54rrEWg1LejOx9M7DhKXP1ybGCrrqMVqOY71Naz//CkdShS/YuKrdHvQA3RkbB0tT4L1jbk5ZQcIfffgY86oFl160IGdylbTtmQX9AmKRtKK6uy5nGXtJlOeuDiB
 2jmykpV3
 QrSor6IxEeGw16AlzqGGi8eG3PSd0znCyn0uVBQOT8UL5/FHl4GOz2wbk9jK5bsbE71ADazAr5ZvVf9Ibks5O6qGfiEwn8bb/FgN0p62FSEY0FkCKdcR4fcg1nxc137Vp4xIeTnTKwMcvc4FhMnsYlrMLBrS3U2cHgnawF8uSIPQT3WVb4aPShdrlCOPKQ2wjNunUgzBftZiiJrbAt1qZs+rTLiG7qUiL7Usxyfe0cltK6r+VcZLS8nX0g1vrARlaFEslyxIJ+Qk/OheMTKNXsm0/aQmDvMKVXm+p+TDnr7UNitX8APCYfcrkNmRQlFOYbUqIje8ckIS3zY+SdTMyUk9VsWOz+ID1s97S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 10:00=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
[...]
> > 2. changing to > 1 for folio_lru_refs() to reduce the syscall
> > ra/non-ra interference:
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index ab69b9930893..a3a894aae10b 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -327,7 +327,7 @@ static inline unsigned long
> > lru_gen_folio_seq(const struct lruvec *lruvec,
> >                   (folio_test_dirty(folio) || folio_test_writeback(foli=
o))))
> >                 gen =3D MIN_NR_GENS;
> >         else
> > -               gen =3D MAX_NR_GENS - (folio_test_workingset(folio) ||
> > folio_test_referenced(folio));
> > +               gen =3D MAX_NR_GENS - (folio_test_workingset(folio) ||
> > folio_lru_refs(folio) > 1);
> >
> >         return max(READ_ONCE(lrugen->max_seq) - gen + 1,
> > READ_ONCE(lrugen->min_seq[type]));
> >  }
> >
> > In both cases, kernel build performance holds up. Reverting the
> > patch would regress system time from 3m40s to 4m4s.
> >
> > I believe either option would eliminate or reduce interference
> > with syscalls that use PG_referenced.
> >
> > All we need is to give in-fault folios slightly higher
> > priority through folio_mark_accessed(folio). I now realize
> > the original patch might have gone a bit too far with
> > || folio_test_referenced(folio).
> >
> > I will wait for Ehab's and Kairui's testing results on these options.
>
> Hello, Enab and Barry,
>
> I can confirm folio_lru_refs(folio) > 1 works for me, the LevelDB test
> basically aligned with pre 6cbdd9726fb5, the same for some other DB
> that had regressions.
>
> And any update from Enab?  Given the fact that Enab's regression is
> also caused by that incidental bias, perhaps we can go forward with
> this path? I'm looking forward to rebase MGLRU-FG on top of this.

Hi Kairui,

Thanks for your confirmation.

Unfortunately, things might be different for Ehab. He told
me that this might not help with his Cassandra read
workload, so I still don't quite understand what's going on
there.

I'm waiting for Ehab's scripts to reproduce the
workload. He emailed me today saying that he would
prepare them. I really appreciate Ehab's efforts.

Best,
Barry

