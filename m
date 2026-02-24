Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C7CEFB813
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 07:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB366B0089; Tue, 24 Feb 2026 02:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F376B008A; Tue, 24 Feb 2026 02:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D105A6B008C; Tue, 24 Feb 2026 02:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD06C6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:07:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5304213ADD7
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:07:23 +0000 (UTC)
X-FDA: 84478469166.28.E64CAD9
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62160100005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:07:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FFC0E7js;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771916841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqGX/Cq8umoPBz+F1BKX6k6qumy4Ad4FezOMX/EDs1Q=;
	b=TjJUxdfsk6uA8oly95etHOCwwRq/NA/nS+3NIdIhI+IGgjbqziOBSMndLnJ00cm2LAi+8Y
	c1WtZcLNy28ow1bK2FGj7MDudl2mQNSXVsRcnHONuqR+ok/HQYVsPVPvGDobtOmGjhV4gg
	s6TPbFepDmb/ntNhmlQ/Bd2c/Hvpu8g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771916841; a=rsa-sha256;
	cv=pass;
	b=qAodPxZ8BGuliAZ4OvoBsZ4FCFSSp3B6GurxsN0v24YoQa6RJuXqsM1/BTLaJN4SoksYTj
	pWyb1uY8YwNknXLPCoI9Co8J5oP5LRQPyvZ+fjutCjR8v2opStI21nKGaqrx8J2+RK+LLu
	f8i93fzcM3LvaeSbOdZzcp7frsj8zgc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FFC0E7js;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5033b64256dso382931cf.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:07:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771916840; cv=none;
        d=google.com; s=arc-20240605;
        b=TblNh6xQW3qP22PjGF0GrLzFrCI29xXJy5oNiQ7waGJD5yx+FL40wLz27FbR9gTBLL
         i+ok8GJpESsOSevNVNJjkJrx7h25Yd7ifgN2JvKeJT/1v0vBUQ+3LvfZRloxLXzVQHQ9
         xQw6V//GjpAwLB11IDBlbe5TqO5pxOhIBdnggLKcmtPKVLzTxxlOPoL7lLWvixMVFhJm
         Gg3VN2Zp8jajOVVQfj9adBjpECRPYHPsGTy5mNYwheNnGjE+bIw2NZT/6r7eSTaEiD8M
         wAhbim82tgUdC6dUPNrWdmpV2fAt9J+QJeD8jm7PRR3NtfLkRUQQP84UULzKBEBUawHJ
         L2hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wqGX/Cq8umoPBz+F1BKX6k6qumy4Ad4FezOMX/EDs1Q=;
        fh=F66U76nYK1Apekgmv+Sn3oIGZsiqAyMTNRWGYP5sx38=;
        b=WUj1o6YUUI+SM9unyUV6auiw6Sae3uxaR9pASl2Nt6OLf7oNa3Ni8CMn3S+EaLGtl1
         jWXNYQHkl13f22u8u/wH5ueXZduFMiawmbW6fKRrcF43l8esT32VNt0TxUrj4lFjaF2o
         uzVsBbDJlu6KtaQ+0+hoqoleQeUSIUYqcHK6UZWjMp67zH6Rv9YQQEih44NQdPgXoEvZ
         JHCC3+9AFrGKVVA00yStZ7JKUSw+eRZFDb4Y7/cpALQ/U67G5cklSRU1JFcW0WK+yguo
         4hitVnpIPbPeIkxWGUpKaZHYKKRGarz1zqsd+w7lyDJI0y4k9uHn/hs0d3/bY/JAlFh8
         xrGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771916840; x=1772521640; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wqGX/Cq8umoPBz+F1BKX6k6qumy4Ad4FezOMX/EDs1Q=;
        b=FFC0E7jsINcEPySufjhdcX9dn/gOliHc7Cx8hq+J9ahbqOrSFZp73mlNxqaq7KuMr5
         bq65uVvsffshE09ZLbEL52Wdo3Jf9f/FLLEDKaxQbHOnKywAuqWJHeeeDl0rN9ht8xZ9
         yVKEKAUZJdkAF1GG7GGSmbe9UZe0HuyiQ98PrGQIQ0TPzqzfOg2N8EwBy++BP5iv+2Z6
         bQHV092RoFDeeaTKuMnIiDnJviXE5Zr85MIenN5NRmDAC2RpWSN0ogyl/P/7vyNdKz32
         lMtcMOxoj+jWdV8GIuqMa535xZ1Iasy2INcdpz+RAQ63CQhwv+Uck8TfTxDdEgYO39rO
         akig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771916840; x=1772521640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wqGX/Cq8umoPBz+F1BKX6k6qumy4Ad4FezOMX/EDs1Q=;
        b=fdWVSo4aHtHw/EKtjE0SUTg6HFXeNNia4lt7GbJph2PnKeJL5P4eONcpNDSkIjpZam
         izULcVeq52/aI6POueWrZ0tuUhkxrMhmXnjeS1SvXAJlOWkx35SKlYvPkZCY7DzYDcsu
         26AfPr0kA+HRXYIDucuhesVDv4pAUMVF3kPE0dw8GrXgxiZX8MN156Si9smdStllBXmQ
         dmSl3ICvU734u9vHab9Vx808z0AgQ0+B0LqB/s8+UC6+TRWHMwwb8ssMAJrS724ZpURQ
         DTTmpcmBMgcxYgLEDL6G1mVeiCnmSUrcnSz2zyWgwTAzdN3nehNzbkGBmuP5UYVgO2+D
         ujzw==
X-Forwarded-Encrypted: i=1; AJvYcCUppJG/6IPRfYqM/ZmOAGgtoSA2QmLMXIJyEE0Bv0IzocC8vIpROKaE2VuPBFkuxDki6RbVQxypng==@kvack.org
X-Gm-Message-State: AOJu0Yx9vScLPVMcgY/kygv37aPofrzpAT60Bj8LMY+8DToi8NYX5CBU
	SnSqJ2aOyeEieq4TwmPV/LSxVVfNCupmL+OyCuFq2nYRy25NGoouX+eaR1scc/bGIgI/vbpqYhe
	Eug8eoFQHzu48czlQYXYd+Sunt1Jev/v90+sh+WFb
X-Gm-Gg: AZuq6aLuiNQvl7Be5RATqgRNIR1mN7FPlCITbkIfpaBX3cAZopbNGDT1pGA5MTpRWD9
	3aHxdC5vw65UzmnFeKn74nRvBID23eInAB/ZFXwd613xJS/v3paxFTncP+cLcNYkztI17eoIMOr
	+8PZFpO05ziIZVgqSQ/z6IK8vnHAa2LbDnp/eBcG6s0lXlCR1WltFP3Az+pCywCI8+Ms69cwh2R
	F+QWNtNM6cajv/JwOOfhZnZbPzEY32vFhRj0YLImS0jsW4cmUYD7WCeJIrS+9AHMDDpkqdIYLZA
	BNM65g==
X-Received: by 2002:a05:622a:10a:b0:4ff:bf96:db86 with SMTP id
 d75a77b69052e-5072ca1b46dmr6335021cf.16.1771916840013; Mon, 23 Feb 2026
 23:07:20 -0800 (PST)
MIME-Version: 1.0
References: <20260223155128.3849-1-00107082@163.com> <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
 <37bbaa9.1831.19c8d7a2cac.Coremail.00107082@163.com>
In-Reply-To: <37bbaa9.1831.19c8d7a2cac.Coremail.00107082@163.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Feb 2026 23:07:08 -0800
X-Gm-Features: AaiRm50pSRIhZaiQaKwsPZarmlJqkLnGOaw74W56Zri-xwPmiKiB_qeyEB6FjTQ
Message-ID: <CAJuCfpEsykCarj6_k5T9EeLDfsA0fFL182g1hQ+tb-7EM=izsw@mail.gmail.com>
Subject: Re: [7.0-rc1] codetag: kernel warning "alloc_tag was not set" during boot
To: David Wang <00107082@163.com>
Cc: Vlastimil Babka <vbabka@suse.com>, vbabka@suse.cz, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: pu7d7mdahpxftjzqw673g64jtkq917ez
X-Rspamd-Queue-Id: 62160100005
X-Rspam-User: 
X-HE-Tag: 1771916841-44725
X-HE-Meta: U2FsdGVkX18eqiUiAI5CHLofId3uXTcPvBVHFw+H60gb8XP+OrUPvlTDIDmxBCQ81SUSD+TLu+EgF69H0KbvGw6BKXgGv8dUntzM0eJeypolPN4RmLWn0S+yYCCbbxgC4UyCM3j+26B4ekcXkK9HqoM4CaR8piXvTxuua8G+48Jg66vSSgSGz/n6L+FpUz/rH+zsAh/OzO3PLYHExdfS3UCOVQ/o4Eyui0WAHEdDrHwP1Cmem0u7PwRneBRXSgRg0rH5rkR272DbIus5lBkknW1s1pmMS3rFy9/eHp1ChpBQeqkzFWKrrX9yppxtgf2LItsbRaFS/NfCV1Jz2YUohiMGOquCF1w7P61Q3lpbynzTf09wRBKjVYZh1L12HSNzBK+sNvf/D7cxJqthwEFH1vQ4FPSEIVhJ6tuPSFuGJcCjIi723PA9gawwO6T5IhHm0h0+eAI4axDbOa2TMd708p3XCNItd+MGI3sXo0ad3htidwZrF0QhqIwdZLdWywqokcqY3Fzo37apGheimyibptBQK7QWuH4f6aHy/2X6ei8/hzKstGailhUknIRXIJu4CdJ70Wjx2PCUe2Z56lKos08ExwHQ+P7SBJbY3Y6vIH/pVDwErM2H/DEneeuMwBsYi5+fJOMquAT0ArUfBmURuGpcNeo7yUgwlsA9yrgX3e9+9LBNpWOJ33Eu0iVZ8m639tIDoXrSl81Jshgv1AMuRQ+r2i3j5DnXB0JJaouAxTtcOj6H2ZtUCzYdG65hjZno1DqBW+zmWoJiLMqxqJiPJuOxOqBZknV3PZzVYoI3SHG/BHbGieNX0u69T4KHG5XwKoQlf8rqysvFjGfWD6TP2sCbqM1SzyNvpvThWqjrvI6SdYLrt2oM/GBszr+WKev9suVxxraTFXsGMXtsuMhcWOmOIJViXjZAmD91AMQLvNrIPdqjjj6/qlk9NNph+zehCUcVUG5crmlNeveXoaZ
 hbxi/rhy
 0pZXB4I008TewILXHixb+X6jvsgxaw3jrkKDi4MRNGcKbROXHFmYCm+Z5fZzzpe+hBU7l0vmmYleJUJTv5tj/0p/8+HuJh6SlmNTJFDkuUlxc3XNFlN2CUxwh65jZGAyRwF+rYDXtBBoeE9EgbbRpL60m6OfKqrcnNm9aUL1CM6UdKglPGsAZtGJVZrFVXRgfjBgOo8fu0tfShFwOoU4bVKmLkXpiz+YwPrAqhV9mn0j7dEH+R0HBV6QiSTF2QNeEhenemimNIrgAp5AxivVPiXUMcdTT/0POT2wcp2TBoJM172ZqzuQ1k3B6OCSN/pwcu3SA/3uAkvntGT/LzBzZC2E5teVjptFB/+UhgH3bUIh1Zed49k9OndBd2IRggd9e7Ewxr8cTIJb3sRLAHz9ZkvX+cZ4CfDrpBpg1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 6:28=E2=80=AFPM David Wang <00107082@163.com> wrote=
:
>
>
> At 2026-02-24 01:18:32, "Vlastimil Babka" <vbabka@suse.com> wrote:
> >On 2/23/26 16:51, David Wang wrote:
> >> Hi,
> >>
> >> When upgrade to 7.0.0-rc1, caught a kernel WARN during boot:
> >
> >Would this possibly help? (it probably shouldn't but let's see)
> >https://lore.kernel.org/all/20260223075809.19265-1-harry.yoo@oracle.com/
> >
>
> Hi,
> I tried this patch, but sadly, it doesn't help with the warning on my sys=
tem...

Unfortunately I can't boot far enough with your config to get that warning.

You might be able to track down which allocation does not get its tag
by first checking for current->alloc_tag=3D=3DNULL inside
__alloc_tagging_slab_alloc_hook() and dump the stack if that happens.
If there are no hits (which is probably what will happen) you can do
the same while checking for obj_exts=3D=3DNULL. I suspect that condition
will hit multiple times and one of those will likely be the cause of
this warning. I'll look into this more tomorrow if the cause is not
found by then.

>
>
>

