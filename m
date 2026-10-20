Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EF0606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 06:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XsS11IGk
Received: by kanga.kvack.org (Postfix)
	id 757B26B0413; Tue, 20 Oct 2026 02:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708FC6B0414; Tue, 20 Oct 2026 02:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7476B0415; Tue, 20 Oct 2026 02:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 372EC6B0413
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:46:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFACCA0921
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:46:46 +0000 (UTC)
X-FDA: 85342071612.30.C66C5D0
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id D7E3340008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:46:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XsS11IGk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792478804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gp9kC/jyVCXmnkxT8i7jFkbo//t/pF13KkkUzx3tMqA=;
	b=oxyyBgRG22/Le2X8Ac+5RclZwLBEgX4yQ/GPn4y+nSqArc2Ej8LRC9nt4ce9JlD/fxdMbI
	C9XTDq/owz9KkEIU6fIDiRq3exJdoMtyMygJFQUz0xDQmkSgX/RdUdlQH1JLkcvdtlwLXv
	FeAXLsboYcqWj30YbW4rOZcAKy621ig=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XsS11IGk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792478804;
	b=IfuPvYJ58Hq0L56AnL/+pv34sM91Y+0kYFvHMKbVG2qdiM6DsVd0+/UbxHsnwHo4DRzjmj
	O8/IQoN9wM0eBxtylhHWX6hK7LE9fHQwF5IPscUWV0nCBr88XR/1jDLkP7a0mEG3oTqVXu
	DyDEHDHrXhv9HU+GWRnrzgbK1Dx0oYg=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1e477fe16so13342215e9.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:46:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792478803; cv=none;
        d=google.com; s=arc-20260327;
        b=D1oa/vuKJM1uDZtpLCT7N9exDMuMD5uuuC354f40VvLWJP2Giv/6j/hDREodC3aKK9
         7AS8LXQrOpxgLxx8AejePe90SZ5cQQbnEAR/UXyp3UxdawPBGmYaIQ8935Qt+Gc3NyZs
         j3TPJ+YM/pvV4Vgk3f8ucFdVeT3kcr9gjUqBtJisZjrSuYnNpTEoCZSJ7paj0wDrKt2R
         i1QK59B1RUdvYgQl6lNVDDPXE8SU+1HevgSvIrJp959JSm729hyruLV1wsb28uT3nerp
         ajM1Yr4r9YBfWomLlYBVReAXWfQcWQ2guazRw5mElXmmLnEakyce/N5JlkqR47OnPwgV
         xogg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gp9kC/jyVCXmnkxT8i7jFkbo//t/pF13KkkUzx3tMqA=;
        fh=Yr/g9nMa/8DRuhatMPY+NuvvMeMKkq+hCPH0f9/j/80=;
        b=PKJ0a+NnA53cGfNupDzL99eCgYwmy7JzTNJKj9HWWVfMp97IocxnLscO8YtvYB/0lC
         NaLCL0HJvGpJ+hCJXkySv5YYHtkU/tpBoHJy+ovuLtjVmwCmMnzJsH+S43AKopmjhuTC
         XvovlZT14Kiw0uwApJw4/kmb4u6H94hmNG4WftdROoSQjTS7UhLZc6MgR2eBquWaJ08N
         ridG2GWaBXaWBk33s+Hvd2AeQEIaeQRXlL0JRsiqirSzsTItyEWg9QejgsI1pCvW83D/
         rHwNl9rcIE2VtZuHWxwJlPWKVTm6AossKFa69j1TB2qrlSCIjsTNNtp/X1BZGXdcz1fu
         OPkA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792478803; x=1793083603; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gp9kC/jyVCXmnkxT8i7jFkbo//t/pF13KkkUzx3tMqA=;
        b=XsS11IGkRE75qVVvtBP1gQRDlxOWalTbTLLX0cqKg3SLfy9nLOprIXJoHRshdN52CJ
         1a4IP3o503T/5mbllnWhsHIGPH5YRg3LS6KNbCvYjowGRYtBqajqryitr+3QJr6egLiR
         pq0oQLj26ivnSf8b3M0lj86+SyuocwE5x42GZEtO3uZnCTSZFrqH6x7s/RtLG/TzrhgT
         L87XuwQCpLgumzv+7ECFOiDESMSxQye7lcQSP1A61DmOVa720hy8y8QJSI1BioLoD9vf
         s3tbd+5CPolnlp8ryGcM1dwlwzGAwd8tJVix8/+5IBC1wdriR1Hjso86V4IluQClCKfJ
         Zbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792478803; x=1793083603;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gp9kC/jyVCXmnkxT8i7jFkbo//t/pF13KkkUzx3tMqA=;
        b=Kl8dXYMKznb0TgYIbtaGp+fSe2BBPU8jrJbHF70HOD+hQXTLc8uvlEKTLSwqAnYdAP
         7Z2OaqzGFg2GyP8B3UHf/aL2qMdanIUmpazTBFU+YogySLepPtBCehVGJEd4fEauipXs
         HFsyzp69mDXnqC3vFgVC2xFYMV1yt2+/D3Jxs3HsxF63YtvJmmunYzEKQPwQ6+st4wXz
         Q6koQIow8pLXGqLONa9aq8S3H6wqvG3vNvzz59ivBcs4EqDRNjBYzcD7gdUixwqZrCJo
         OksvZd6gk7+Z8VC35RdF1zrBi7SVtVgbkE+BO2PpTtGW66B2UWK8QkFtJe1j0TVYCiEp
         qfNg==
X-Forwarded-Encrypted: i=1; AKwUvByXFFF/4s9i4nJaEwDYk9NmvG9XRsWaNQFDtHLs84T4DUTczgnO1GvVp1b+aFZEDbRUe2MbRuYuDg==@kvack.org
X-Gm-Message-State: AFq9FYKRzr39qVgXzuHMz0ay+ob7N52pLOYddf4TC0rMuephyJZAYVNQ
	tistsNbNn8IUv4QJhW6WwaG3wJsygZyMxI1doRN/1o2OvroK4L7zSVglGyouQIeHyRqDQPK+POz
	ZaOihIuKf2h9bnSwaHzb5k+kTLmp8Ffs=
X-Gm-Gg: AYBFou3TnL+5KoMLLHOekDCHTrHKY94jDTPRIutRdx0KxWXrHfpd0ywVJzU/KnHo6bU
	/kMZKDnp5J7QneZssKcwZTnmjk3BlK8j5iHS1QdZpT9rd+BvD9itKXEgLlKqIB0AoBJnSVMgZ3N
	GnjeM5drO8sbvc46YL2pPV4awRq7BUHXoglqG7GfaNJffUgyiViN0y94HpOWi79UAh56/p8cwWV
	QvrkM22jc56nFZP/Paj8rauUalWMdnTyDBrYC6p1HPzIRH6EpwTSL49JVvt0j/1xmjupBMLAg5H
	A5Gh/vwdRXjcFOtdo5jA3+8vg7ilEq/VCuckb2tpFe7ZG8vPHRiL9ytc5K+kXcSBWNDnFq/oQ6R
	Rkw3/dUVqWyn+jA==
X-Received: by 2002:a05:600c:1d05:b0:4a1:bd69:526f with SMTP id
 5b1f17b1804b1-4a1d75ab235mr196204085e9.4.1792478803164; Mon, 19 Oct 2026
 23:46:43 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-2-0f00417b41bc@gmail.com>
 <20261004091023.630362-1-kunwu.chan@gmail.com> <CALa+Y14isN3HmsY9Mgtdi3O3zxOH33uTtajSbJcxm9FO4Uon=g@mail.gmail.com>
In-Reply-To: <CALa+Y14isN3HmsY9Mgtdi3O3zxOH33uTtajSbJcxm9FO4Uon=g@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 20 Oct 2026 14:46:32 +0800
X-Gm-Features: AclHuK_-zTMbJ1JCgYu1ZQ2d8ma027-PdiCf5iSRex2YzMdvVgiIPMhM3aQsSmk
Message-ID: <CAN_Opa_LJNTL5VwjxvWfFuC1dqNa935Aqu9fEmkCJxwOx5oNKA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/9] mm/damon/core: replace the access report
 buffer with per-context rings
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, Wei Xu <weixugc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Jonathan Cameron <jic23@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D7E3340008
X-Rspam-User: 
X-Stat-Signature: njspw1en4tn3yoyt7ee3wisuphutghc8
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792478804-941891
X-HE-Meta: U2FsdGVkX1/jgcu7JBDRCvJQaHnYCGlAeXtuAwSMPgCh5nXyttZq1/JknOBnCWInsXbkb1qgniOuak+bP8WEqm5OIJUk5X7N8mGgRsiVk+N9U4jcL1bx2teULiRUwx7OkJhtCEyfEVNljxkV781ZkP7rVwWrybFmursOt1vVfkh2dIobA6zi81SNPG79vSEXsmfiP4TpkFTOEx7cZ1n9q6ugGAeWo79SV0L9cRA9WiiynuMdqFjPCBX5bhYzQiChnT9/O6CGaGdFV/0JKBiivB9u+r/9PNOKwqtIT6SzJ5GgBBSNvKo6wfWBNR3UxQDyOXGdpTVAD7cEEymMw5rqTqRmYPZ6AtUQbKbMQJwJWvmDkpTJovSzE0mY313HTSroLdT7YJWWLnfHuQAA6kpNZyehCUPMIv9cI8n3rq5hGlrvvfIUqefovyPVsyFQCty95k4pGhGS5sKOuZ/TPvUZ3QIEJhms6tniLOxoQbHFuoqE4/ONSMdFJEPfYkKBc9SPVsfwNnTt8DbzBFNLKscU5iv8GRaklLUBiLs2StEVyJxjT9AP6wGdJoIY1G9iKnpaYI1/NG9mGCqg8RQ13W9djUbIFxOMlrjcXTwMsk23UVjr5UqPq/yUeYdnuUDO5WWZ1eNpwq7PfYzZJRPQvDI0LjeMaG/hta+tcbIM9UMjaqePstQ/X+vDHVNmwV0HQSmbUd7jlE4KtaYQBdIRE5p534DKMjVXYf0CUPx/UA7KBfP/JObPNDdL/I4v9N5jt8MZe4iYnKJj0zLbgIaKtF84Jq38jTeW8L7U50bkidZ/qaQGJDhqhF3sUMq4e2TzU7zjUAeIqHZrdJKkOWnpp58j9qM5NcrLElyddsmQvnSax9CauHRbwA/BRSWXzlWk19EcRHNj+a6390eQwhH743ddO0eQx6+unwGpsq5Myg0UNe+0CdGHCHZdbtoyto6/F6WXxUBCOMOgJGzwicBGe8s
 5pJ9oORm
 /JYtbR7jQ1wnyke1LCQqvjCiWwSTeBY/4rugLRb/OooueoKvR/SkxlTFD5sskk8i1YJ2pO7rvJT81cUk3JIWZsbB/VZITuT7LJjZBxjjmfHuUmyfSdmXIsVeDVA9XzLn6b7ykPbi/y3DPHivAXXCCaC/vCWbnnRaWMt7HbOLGxU/nilSyf6g0Pp0CezQ+U0C1kJqy5Usv1h3Bt5XjHE1k3UMjZSxqDEwiCma/DKGZeN42zv5QReHJCRGAt2aj81E+3CUnp4Nm5e2frVEVfxXjnQf4mWFqt9YHGDrZ3rEKCG2ywUFKwW+Utq7vClU7JUAiOjGiX3L/VhOCIKS34hHy4e/L/ebd6o5MSKOWnTiGfmg4qZLH2nS4Yafm0r06fT10o5Pq+RdS4h21XZ9K6HJwznnQquGzNVNtggy/v9m0VcCXrtRenbNHqyPF3PRkGvs4o+uWnqigqh3pfcnXI/GWfxkjkE2UfUOBKx+AEMawvEQgCtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 5, 2026 at 5:11=E2=80=AFPM Ravi Jonnalagadda
<ravis.opensrc@gmail.com> wrote:
>
> >
> > Hi Ravi,
> >
> > I noticed that ring overflow drops reports and updates an
> > internal counter.
> >
> > Since hardware sampling is used as an access observation source,
> > could userspace get any indication that reports were lost during
> > an aggregation window?
>
> Hi Kunwu,
>
> Not in this RFC.  While developing the series, I used a developer-only
> commit that exposed these counters through debugfs, purely for my own
> testing; it was never meant for upstream, so the RFC keeps only the
> in-kernel accessors that the kunit tests use.  v4 [1] is the same in
> this respect.
>
> > Without such visibility, users cannot distinguish an aggregation
> > result affected by report loss from one collected without loss.
> > This may make it difficult to evaluate the reliability of the
> > observed access information.
>
> I agree that userspace should be able to see dropped reports.  Two
> things to note before exposing them: the counters are global per-CPU
> counters today, not per context, so a per-context interface needs
> per-context accounting first; and when perf throttles a source,
> samples are lost without any drop being counted.
>
> I see two options:
>
> a) a read-only file under the context or probe sysfs directory, once
>    the counters are per context, or
> b) the drop counts through a tracepoint, per aggregation window.
>
> Your PMU-agnostic observability series may be a natural home for (b).
> What do you think?
>

Thanks, Ravi. Are you referring to my earlier
'mm/damon/perf: observability framework for hardware-sampled access reports=
'
series [1]?
[1] https://lore.kernel.org/all/20260818061031.827057-1-kunwu.chan@linux.de=
v/

I developed this framework and shared it in case it might be useful to othe=
rs,
though I'm not sure whether it will eventually be merged.

The tracepoint option seems like a good fit for that work. I'll think
about it and share
any ideas I come up with.

Thanks,
Kunwu


> [1] https://lore.kernel.org/all/20261005-damon-perf-rfc-v3-send-2026-10-0=
3-v4-0-b03452e137f3@gmail.com/
>
> Thanks,
> Ravi

