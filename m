Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33188C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 22:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11BB6B008C; Mon, 10 Aug 2026 18:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE85B6B0092; Mon, 10 Aug 2026 18:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01D56B0093; Mon, 10 Aug 2026 18:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 786F96B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:28:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8698802AE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:28:02 +0000 (UTC)
X-FDA: 85086798804.20.D09B09D
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id CB709120003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:28:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DoWrKncm;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786400880;
	b=ZLYpi/ITq3CuwYK40kLukUvWJ+NO+ASPU0sgckjvPmi+vBcxCdgpF9ej/k+sXVP7VMVzJT
	xr2vzmQgBSUtINjGP3w8bNHtuK8KQjAGqMG1RSUFsgSdGuo2CQD1HdWatPssqQWjF1MI1C
	/6o6UJ8IqJuVKmvB9PiZqSW4N6/+o4U=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DoWrKncm;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786400880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tG00cln/EZfmDZKyIkZr1KbYylCCT00dXhW/ufTCbgc=;
	b=nz1rrWQpHxaxab3za27ph/ff75Jep0F+t7YSGyxAiijraHXkLkDO42iQz4rKPjLMeJuaFI
	lwsVy7wBZ1Aqx8KFx/EbxJh4N9Uhw+33lxKjVoA9uP49OhXa8QVPmMGaUWGiCrx6mWjHkg
	sO6rCt0zA8i+EXvQnR4chm+StkGyXAg=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4954a32cf1eso10385065e9.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:28:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786400879; cv=none;
        d=google.com; s=arc-20260327;
        b=FblMRL0d0s0Hzh7wxAdh8TB0n2liiC3v6mNs7P5gDjhyYaEQcym2ZQMPL/w6deKY1r
         BzE6WfWwbABka2isy7Z7CKn0mVIDGiLd8vMf92h3xzC5xOBOSdIhSkrOC5CU3RdkAUlx
         Ys6bjS9JREw5l8I6HwptwxAazP13ZvgILhm2AowY1sNVr2QMQf8yDZ82wi8SNeM8lcFP
         2nF+UhdFoQlXX99tGnZnNIbY4CnTY/j1Y/IZ2oKdzSCowuCgNL8hSrxbGY2lnzMS13wq
         dZ6J6qHbq0nsIOK74fyNiQaZZD8eN9zuRfzh2NratjAOFn54xNLJAwtpyv1X9nL3Q+IN
         zagw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tG00cln/EZfmDZKyIkZr1KbYylCCT00dXhW/ufTCbgc=;
        fh=urIMgpUNuBihYN1uZgtABZmjcHZFHNuW4iM6d+DGlEs=;
        b=qtVM/7xAdEkc4NRyKUZ5UHpTJK22BdiPyh16NczOjRFlnoG1dXKxAjsYcUCYoC8v+h
         qj3ZPnGT2ydE+b+BdVDhh24yA/I1xk1hhMO3FQCQbGTmfm67xq4T/vE2mlifwcKmC8uf
         7azSvurbwv3gIoIfrCxXvOQTfNJZtm4a6Niz2cYd8Hnn68Mi2u5ZJ+tS6th43A6/tc4G
         fFMe4Pw8UejSCVgIFN8ZG7C3T2ukvv+bJN39A5mbwHkIwtzm7fM4YCYzcPEYue8kHPwc
         VcbpUCxVpsKd2eVJCPASXCuq4xqpsSQWP2EiwN5/SEGNU9TgL3j1DUK7wAV4zYLGpvvh
         5GTg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786400879; x=1787005679; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tG00cln/EZfmDZKyIkZr1KbYylCCT00dXhW/ufTCbgc=;
        b=DoWrKncmzNXUCToX/1wQcrZIxFqY8M1HRWWVTM17Egd2e2RD7So/+tKHSgSVlyrvU4
         XdVuwYL/adTTLY0XdrrFk2bxo4MzHwacsuyOvmK6+sGRqrGCCd9KROZHoKFkfjrVWtuv
         9qGyzKI6Ka3THtldn303rL8gla7uN3TvJqshbwKr6gEiZ+fxntU+wwq6jd+/SRJc88ut
         TGwji5Jnp03YKUUpzLXEcy7vooBspPK4DHSAjA4eYb9WbV3NWmiqmBpLPXt27rinXuWV
         dtXRvi/NxtN8txo4arQKu40chu9Ec2+21d3T/nmr2sZS68fjG5yEjak60Sc9HHDjjhej
         B1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786400879; x=1787005679;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tG00cln/EZfmDZKyIkZr1KbYylCCT00dXhW/ufTCbgc=;
        b=bJkkWBlV0tqQFC+tHvkdIdaz1W+8/CycI+j0lMx+EjNESHD6RA7ut+LEKzDdLuKzmt
         vSvM1glDe/F7cvGAGEOTKapT/lpdO+/33SIkXLAOtrhOP5NL6VU+9Qww9YWnz3rhM+7I
         sXmzeFfRPore8KAZ0FFQjhPVX0w7hrTS/X03nGdVmejL0BHKUeEiMXq/4VlG+6S4OTEC
         C8pYmYqpAY47r3pfpS2nYqcHUrvzPINv1B8NRmqN8ura6BTVRfzrb9R6eHguIzfMFXsf
         iO9kU+TnU2HLj9KGHgOSDu9DOeULaZRbqc0rYg2xIAAOkr20UN0S8uIh3Bz81PUlrN5U
         DiBw==
X-Forwarded-Encrypted: i=1; AHgh+RpdNnQSlVI/1ad6t3JjpEasXab3/ZF9njs05UdcEoGB4ZlBoesVXbwCPHVwFNqwX/cL/pWF0a+Hpw==@kvack.org
X-Gm-Message-State: AOJu0YwxlWFPhGi74SdDOGeDj5eN4CETrB2kGhsXtMDov5uBOvM+LvmA
	RUjFZGX8nFij4Hg+dB0sltOH/7P21GDl2tzUTxduDJ0Fap7B0tW72DSx3lsSBLad+nvCBw4I/22
	buS7iPRtAvsqFadvpVcX99gB3RzEStew=
X-Gm-Gg: AR+sD13XDEtg+azUxDsgEdCmfoxSCG2eH9oegZVXhXk+i0Pt0sBDy8oQurgU9uW+DJK
	jKY6LRi857MLZjSWeDkytLGm1nXcQNRDLRPoCvnOqAwYL7/UfciCP/prqt3Vf8kZjGh/cyEdUcN
	dHPbqIdfaXPTqWYcdfhIMRb1+P0sbwPZOf3/M1YlAbX1NNF8UStBN3xbWR6LRdT8o+FV4yEMkyE
	Mph07hDCtGgmYifhADyYWgHx5qkfWCMROfrG0LxCA7IGJH95FvEAsG31kpCqpEAoIguKwRzrAPq
	o+lEnm+ou5r/noohkqH8lgaHhsW5BO8zxfMPVSY1kRqYJA/crdSC95PDMjo5xAKez9xPe3OMT7x
	Hq92waEy+fwbN
X-Received: by 2002:a05:600c:4fc3:b0:499:4892:d022 with SMTP id
 5b1f17b1804b1-4996194cf28mr264737515e9.8.1786400879152; Mon, 10 Aug 2026
 15:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <20260806184254.3790858-9-nphamcs@gmail.com>
 <anYIboHEUZb4fhHv@cmpxchg.org>
In-Reply-To: <anYIboHEUZb4fhHv@cmpxchg.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 10 Aug 2026 15:27:46 -0700
X-Gm-Features: AUfX_mw7dY0-F9-Ej-FIs5p3N5Vk4fr4DFsdoOHN23XY9uPiTQmxJlkSPfIPaBs
Message-ID: <CAKEwX=Pcr7a1Pfu2U=JQ3fw7k_u9LbCkNZgDh6ySH=JMN3HXOA@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] mm, swap: only charge physical swap entries
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CB709120003
X-Stat-Signature: ac9i6kjeiebqcbiga7sddqsgtyw91tei
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786400880-777897
X-HE-Meta: U2FsdGVkX1/4NiSU3t+vvAIjjkpYYtrO/jEPUCXIiMk+tJ1ZrHi9dnA02gwoIgEUY6goI1huGA46a0PSvHsmIwKP9YBWeET9sgV9F7NPD/A5I0CJryWrekMAMCgnOanN3ND19P9er0HJfP0Q4Ui8K4bg3/rYWMUMUULDzQ4RxSby/NNwpc/Lx/Xd2TxMGLr6ueOQIGoaHFYaDlOLnp7U2yhXVQXL1ri5hhYW7/K6pJLLkfX34/olre2w0x2DlqHP9yF1O2nfxM99WvGqMfw1stopb1/VIRePmslEbGnuu8JRaq/XVxcJtByYn+mXGEWeeCXly8fczOfahxIlai4TBFGjSHiNlSeQAfA3Ty24z7mzUMkSgYHRrlevlsfXwf0vOlbqLKtkrCEpieRBgq1gvp3VumngxL+/onupeFIvTLqiUdii8dR5AM3sfJ3Xpo/bCjt+TDL9wL9SkDYdFHcdh5t7hnHF4JpOq5AZIKHiedbWa2r25+lEeDvOqcmk9CnYZaa5dUfd3g/5S2M9a0Vc9AutzRSdiQSA/v9ij+uQVOa9+x/WsihJbmBT5VXUcLqEqVZxTSV3Ae550JQxOl3XBf2R0JzejepXqHCdoElRI98eZnpuGp9PNBLos0qwTHadnxodOH8QUp1z/JR6rElrTmh1SLNtpAsu1oVRTzwfKFW33a9SLpDABbjbqwCg2LRH/T64eU0AjJdFoFuky/naKFbHzkQ+VMMt5Bzz1NBnBaQPh3wzarhgcEnTd6Yl0JPMv3il3rTCCvwGMueDxDeIN1Lj6EysJupxKiEwh7bkPCqDuHwAJJW557+5k1DOpUguZymmHlQAgBh3e5dOK406GfplGI62zC5CmvIGjzHx4e+glvv8+yL3IwrWOLoBDl0ZgY98SiNMFK54Is2N8nGrXJK/NW6mdvDaFmIPE2iPOnG07lip6HZ394yMXRVUb+Szz3htozZaorSF/BWZgaF
 f+bke70N
 SZndHRtdCe38XQ/Wz0N7V5va9c8OvhgLTBIaJd+khTiszAV4CkUxtXCPBnwuTLTKVSoRshfkfM/7JA6s0u3Ru2kjX7EwFuDuvrxTwfkLeVmmJAlCpnU5qZgCxyIroG+XcN+/nCKDyd6z6XrrfUR0/67DOKXPX1Fa5zWJxjrVOJLisIBwz85Xko6IsR5EFEaVgCaPVGW9Bol1/7JCOmzSYAfRjlotdzBM7GDQCpn37GPuiKx48F747ewBMhDdSNBuEnCYXvvF2idxTbHuU3faYZdyi1rBdJdRY+Up1VLjz7urjmVitn7XHFpugZdlUlr8tmh0PHu2JKCaGi9PCv8BtikYFu6DqZCnXclLvA8kb5gjjf1Cw1mamLm/kMar1pa/89R/4aeJ0vC9qpK4kuZZRdk6g7bWxzVgt88LJiDc4ZaeyGmuVM8drOwn4CIDFB0VvZ4+fB3EQAgfxsXZvTXHKx+F4s9u/4x9rTVa2FnA2eWR01tc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 7, 2026 at 9:31=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
>
> On Thu, Aug 06, 2026 at 11:42:51AM -0700, Nhat Pham wrote:
> > Charge memcg->swap when a vswap entry acquires physical backing rather
> > than when it is allocated, so memory.swap.current tracks on-disk swap
> > usage. Zswap-backed and zero-filled pages occupy no swap space but were
> > charged as though they did.
> >
> > memory.swap.current therefore no longer counts them, and a cgroup whose
> > pages all land in zswap can now reclaim anon memory with memory.swap.ma=
x
> > set to 0.
> >
> > Direct-mapped physical swap charging is unchanged.
> >
> > Signed-off-by: Nhat Pham <nphamcs@gmail.com>
>
> To head off any uncertainty about this: this is exactly what needs to
> happen in terms of cgroup semantics.
>
> memory.swap.* are about physical swap space. They track, control, and
> enforce fairness for a finite resource that is separate from memory.
>
> When a user switches on vswsap and a bunch of empty pages are stored
> inside the zeromap without consuming swapfile space, these counters
> must be 0.
>
> When a user switches on vswap to use zswap without a backing file,
> these counters must be 0.
>
> When a user switches on vswap to use zswap with writeback, only the
> pages that get written to the swapfile must be tracked and controlled
> by these counters.

I agree, and yeah I should have been clearer about the reasoning in
this patch commit message itself. I made the argument in a response to
Kairui's inquiry in the past, but forgot to include it here. My
apologies - will expand on this in the next version.

It really does not make sense to make zswap and phys swap competes for
the same limit, when they don't compete for a tangible resource (zswap
consumes memory, where as phys swap consumes storage space).

>
> A few inline comments on the implementation:

Acked. I'm trying to implement this. Will report back if something
doesn't work, but otherwise it will be in the next version.

