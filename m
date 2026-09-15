Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0953C88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E86A66B0088; Mon, 14 Sep 2026 22:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38466B0092; Mon, 14 Sep 2026 22:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D9B6B0095; Mon, 14 Sep 2026 22:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA72B6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:55:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 414BD402F2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:55:40 +0000 (UTC)
X-FDA: 85214481240.11.E32E891
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6BA49C0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:55:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MKwlGCUG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MKwlGCUG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789440938;
	b=Rh69S7BvuUUkEcFp892jWkKmahGkozQ5sUuSgvfRwkwTC2XUA9BECnYsUqMzkSwV/fEi1r
	5eiJA3csM+0mU+UxiUta9EQz1QcylDCmAZgCqGivwxAV8hm0ohsuPXDsjf3mICPxykQFrJ
	sfIYcMeu74S1HMKlh6tLFeSq6MameDQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789440938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rONIJ4rFKQNYtEnPGvXxCw20wCu4aJ48o2Acfvenuc=;
	b=G2LwhJehrQsXaV6u4h+Vzvro1PsEuYXvi6VvmTaxeGpJDTPem4OTVR5nbWCO+6FAnogkgj
	gS70GaUXLYetSyzRVvRrMpEResVXOxw1ermUUYVIf67hejju/ydi3+xoPMXnJGG3AuYX4x
	JOVS/G55G8hUCJVusRvdsf4+7TBkStM=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db18fe459dso13989605ad.3
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789440937; x=1790045737; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4rONIJ4rFKQNYtEnPGvXxCw20wCu4aJ48o2Acfvenuc=;
        b=MKwlGCUGE2czcIHGUUBl6qR4oxmrUkY1dmunQ/qthTD8XJqfhhMl1iD2YQGS47PhrG
         I+1d/O38XESUUs+B1CchbmeV8O+uotVSzvGs3s0ihw8XkfgNJJvB5lZOHWg/d5ZvJ8Jf
         0rBa2rxUMaD0tkDi12fyspVbvFWoSCziLXjIdSOVtk3FSaEeSYGV8Df7joTksKqHhaTg
         BPFVotnhniFN5NEhJLXFfbuwaIgvHCaSnE7js0Jx30zOaxwu4DwXoBqVK9xkIr4d0+Aj
         cKoQUqoZ0dzYei0dJv8/58s3dJAbHleKo0JIyGA6IrdDdkVDnYIrsSGV7UM/LWvKIUpI
         mfig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789440937; x=1790045737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4rONIJ4rFKQNYtEnPGvXxCw20wCu4aJ48o2Acfvenuc=;
        b=lRC1Jm1a1Y/0Hxing36aLYO/3OQ90SU7cezYnLUXYYgayd0D16GHwhJKECQ06cRjCo
         WLMcmIegAip8QKQXquV+EnZUwPeJABnkHMLHjYIM8jUG1P5xEexTXzFUDo8kfP56rJqR
         v8YHtets7ED0MDcZWTm8+VFUFup0pULOuLECVJORddh4/d+SzNhcqH8CJW4faUwbCg0e
         aRLCUS+d/cB8ookQPHRBpjt/MxZD4eFEPD7OdKVUBbCbZAXvZgN6dYXZsSLoTDsvezKx
         yZ0g9Zx3zr08L+QXYouoEFrIZSm6dcljFb0uBBmALaPMLHnWFSy0Ov6TUp9VmnCojWfb
         B2rQ==
X-Forwarded-Encrypted: i=1; AKwUvBwHu9XZQfPKW8E2T+rjUcjgX72aY54d/pCMWOJWMqNpRMoRZpsVVzXIhBw6XHzRAky//FyhT/Kvng==@kvack.org
X-Gm-Message-State: AFuF++kIdclcu6z6sseta3TQqII1PiHPuVSJa6H1OOiMItgNbcnI/skD
	kDe93SYoryiihY2CFcMULELBwBTpH4+AtVnQgBBnKwSPgrheTnr8he4u
X-Gm-Gg: AYBFou3pXdg+tfqAhdh3eD/EALJLryXXyttaDr2BB+e8t+4oVL9FQv62QdqLnPQCzgp
	UXkwCNdn1zI+nSjmI4b6aUnYS4rCs8l822vmI9F6dHo1UeRzBZL+66W7knm+h0VlpIwhPBPpTkb
	MbTVXF6ac3KNbi2MhVKEP9jz1ij8MWEoSrreLqnfElUn0e8OOVP8n9XDc/d1jbLmz/Yhb2KjVVF
	lL7I8HawC79MSa8ahOOyjXEaU92lTZioPGfcMe1jrUGE29L3MBaA7jHKu2dJJ/PfplbUo9ciEoM
	NdotrFAOdvbwJGHUpmUX/MwPKxuQdbmUof+cIabCJm3pwBLxn7n136jhdGoxyEI9LW+GAPMk0U9
	kL19OTgYLJXBgRhX6JdH47l4OD7XDkbknnzIEXkfLuzI5D00d7mFg4B2YL+voronAwP74U8ANh3
	tK4qTRxnr85KolqwL6Y9aUkJiF1Z8IPsVaH1J74Yuml790Kz403GPQZQobtBtfNpsPLAWaq4DDi
	rcckwOjEpaE7hOLFzSzqVcNpcNMTTIFoet8hhsx
X-Received: by 2002:a17:903:1ac6:b0:2da:e634:370e with SMTP id d9443c01a7336-2dd6c6eb5f4mr114307505ad.14.1789440937165;
        Mon, 14 Sep 2026 19:55:37 -0700 (PDT)
Received: from localhost.localdomain (vmi2317699.contaboserver.net. [85.239.239.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2ceb7720sm57859485ad.37.2026.09.14.19.55.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 19:55:36 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>,
	sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: Re: [RFC PATCH v2 0/9] mm/damon: hardware-sampled access reports
Date: Tue, 15 Sep 2026 10:54:51 +0800
Message-ID: <20260915025514.2434-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910171623.6638-1-ravis.opensrc@gmail.com>
References: <20260910171623.6638-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BA49C0002
X-Stat-Signature: 616yemaz35wq78qyjhwaqgpcyshdrmi7
X-Rspamd-Server: rspam01
X-HE-Tag: 1789440938-911080
X-HE-Meta: U2FsdGVkX1+V40V0K14jEoiq6HvZ/YtQfGj8ZFQppqcUdwa25WpCUaabHdr5VuW7qCVK5/Ws5gSaHb14jfCJLxSSu2HqWoJq2Xxi9WIp1CPEGRXTGr/5a4FNS0sofJwIomjfHrI8iY44+A74A46YodBGsPvCXkZi+U0I+eMDeqKU5OHs01C7yRvS1qdz65/YftoB8j8WjddXks5WDJ5A4ShM1tXIcUnRtHO+YKr+9Y6TM3kreZKKNj8pvZCfBaompDayFvBRAbiesMW2sFBbMCiCPhIG5hdW4vnK2OlRUMNqDAICSBFT04xCnfQQBkqGlb+NsSGWgbuf8ZWwJnbAKXHPlTLv6FZF6huZ7vKLFuq34tOXJ1NKosQEDdfBeBFtUv+hBIpzve9qCF/H/x5GWF99v3RO51KV7VAtVn+HeWdae6H3KjbjmamRz8AAn1Sj8fN0sG1zJnkkgZqCUPDAkL3EJ0tw1a5TYtoDoLbpy/zXLPF9QZpnH2Hhb7nyBvh6CBrtFfTHjfVQWeatYloNrzlT3JcAsMXGL9SgD/EIv1eiMzptPDOcjGSezXB0iIeOE2f3P/XatQESLZxGfaa3MNtv3LJs3nKSIeckFS18ARQ+KNEjbgpbWrKi986DULJsoEaZnRvCML+dp7Btfv98o9guG1MF12aTJhLsfiBkX692thVbqWiBodQPkyGSl4Gtu0nz8Jt0Wc0PZHWAq8s+k5gFyc4M4KrTNIX1/jUrE35xIdvpTzAF43WBTlIoPVQqZtwB2pIZP/C4gksw1+q+LJ/jHa3IXP26sfd5tP2uqLZyWCwVtZ6vxZltvgPjebvY8IyPwLxWl+rsl3Rw2CQHbrXTi2SgWqXG9pa2tmodHBqA7MJ3JTlzsVAtWRK72sykSW0d97YxE2j2gpc4cGgIUW91Dp0u2CMyRqQxQplRyuDpPmcawE47hjfCYbMupdGNI8BWhT9M5ZT0GWg4o0t
 ElunYWKW
 QXu141gb6KVZFKe9QiTvK+kZio4DAFLUKaf6I/dMTWAaEsgFHnD9lzbu+5jBUMw1A3WruxOBun00kIH/sYCYeqzli1XI63HH0KRmpva8ngBFNadjBkcfj2M56cV+gv0jSYCykHfy3PLzd2BBt9U3gf7MlqpijGuz1ixlLYaXOmhZl/8bKPcFpKb7ZDY0Twbn76c+OK9G5kJbA4jA8ypYTvH8ZKRdA60nj1kjIhN6fnUyn+T11dH9XwIP1x0mJxuAObjJDQ8JhBESIji4vAeD3VkesVBDWrOaZhOJYNgbcMrvF5N88mxvbeSbh9V1Sy0dGl8ztdz2Cf63ZECxS+iSIHo34almxlBupiDtp7M6k4LvckHIkgl266vBjNZ8hyzP78wIyg9t4BJDhsu3dxbuUOysBiDzdeKJajMkMBdJiFCJfgfTb/YwJWsfneYYuRGIovtHYnKEYTQnLleHUy3FVnPufgrZ9aEs1sTWQKxVAxgalfb8StQY39JcErHhsEkctwU77
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>

Hi Ravi and SJ,

Thank you for sharing this work.  The report path looks potentially useful
for a DAMON observation-granularity problem that we are investigating.

The scenario originated from an issue reported by SXF, and we are planning to
share and discuss it at LPC.  We have now reproduced the underlying observation
difference on both a local PC and an x86 server.  The server run below is our
larger, controlled reproduction.

Our test monitors a QEMU process whose guest memory is backed by a shared
tmpfs file.  The guest repeatedly writes one 4 KiB page in every 2 MiB range
of a resident 48 GiB data set.  The unique 4 KiB spatial coverage of one sweep
is about 96 MiB, or 0.195% of that data set.

Using vaddr DAMON with a 500 ms sampling interval, 20 second aggregation
interval, and 500--2000 regions, two opposite-order runs reported a mean hot
ratio of 1.751% without shmem PMD mappings and 75.836% with them.  A control
that writes the full 2 MiB ranges reported 75.366% with PMD mappings.  Hence,
in this workload the current observation does not distinguish spatially sparse
4 KiB activity from dense activity once the large mappings are present.

We are testing existing DAMON strategy mitigations first.  As a next step, we
plan to replay recorded access addresses through the report/probe decision
path, independently of a live PMU, and check whether DAMOS can distinguish the
sparse and dense cases.  In that experiment, raw report frequency and unique
4 KiB spatial coverage will remain separate quantities; lack of reports will
remain unknown when source coverage or loss is insufficient.

If the report evidence makes the decision reliable, the response we want to
evaluate is an internal, bounded PMD mapping demotion (splitting the mapping
while retaining the underlying THP folio), rather than exposing physical folio
split as a DAMOS action.  We will first keep the response stat-only and archive
the would-act ranges.  After the replay result is repeatable, we can replace
the replay producer with an appropriate hardware source and share the results.

This seems like a useful consumer experiment for the report interface, even if
the vaddr and optimized transport parts belong to the later phase.  Please let
us know if this direction conflicts with the intended report semantics.

We will share the strategy, replay, and mapping-decision results once they are
repeatable.  We are also reviewing and testing this series, and will follow up
with the appropriate tag(s) for the exact revision if that work justifies them.

Thanks,
Lian

On Thu, 10 Sep 2026 10:16:14 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> This series lets DAMON take its access information from a hardware sampler
> instead of from a page-table scan, and lets a scheme's score be weighted by what
> that sampler reported.

Sent using hkml (https://github.com/sjp38/hackermail)

