Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37BDC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE6976B0098; Thu, 10 Sep 2026 06:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE9D6B0099; Thu, 10 Sep 2026 06:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB546B009D; Thu, 10 Sep 2026 06:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4F26B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:25:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CDC6180454
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:25:04 +0000 (UTC)
X-FDA: 85197469728.30.1F68C13
Received: from mail-qk2-f1.google.com (mail-qk2-f1.google.com [74.125.230.193])
	by imf20.hostedemail.com (Postfix) with ESMTP id D5A7E1C0007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:25:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F9Xd3kNR;
	spf=pass (imf20.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.193 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789035902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDOMwEFmq4ys9LsFhX+YbJ4h+PB/dTq06lEyj7W61bw=;
	b=qjlqJ0H66cYc8v6W6DwC7AYTtgmBUxTL41dSGKGn/Pc4l3/ppdC/95Hszt3HZrla2MmSyA
	cDSRXMLD5KARleUNyd9uaawd6zkl1TqUN6pDYGYuAElrTScGerNIgUTn0KCFQ+gkoFNdlt
	6mQuhHGUwf6FnkrZmDbTg1lvbwpnZSg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789035902;
	b=iBhL79xc6mUy6kF7ThhhKwXRSd26kPc3z9g8edyX9L+scdEjULT3c+YiQ0b1L7+nplm+cB
	Z0sVMDkIFtdHySvgatOiMMudiP17yi8P8mMSZRcbr+1n2xHgZsn5PKWEeF8L4CyQ98hT43
	e94CiZf62q9SNB4Q1jHZhZQpxHED460=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F9Xd3kNR;
	spf=pass (imf20.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.193 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f1.google.com with SMTP id d75a77b69052e-53096696963so21073821cf.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:25:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789035902; cv=none;
        d=google.com; s=arc-20260327;
        b=KEW6x2GWtvfIurqBNJ8RKmW0MOsUXLSUyIq0SZYQjgYwO3H2XW1TseT4XPmjBaR0IR
         7mbhT6VoGZmUcuzKVSLMtA3pW5DThnRQizz/gYGrAmWaCTvtktNVJDqPPyMiJm4vJcP6
         WdMm2OjagQuTIZMkRgiNPV7Sfbs2bV/4rZBdUZLFsW2PM7hbhF4TWGFMMLouWLcwxwzK
         X+tq3acLQyVbtk+nhgnUu759v8teJQrTwX4ca5JdFbaI/LSFZQTA9XiyJSXAxiByAHab
         qdXSjxD8mZRq8De01pHrrruCd57MivdSeseed/gwPqFuAeYHBftsYliIejM2YMMDUdBV
         nOKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=nDOMwEFmq4ys9LsFhX+YbJ4h+PB/dTq06lEyj7W61bw=;
        fh=3G1Gn87MJiV+uJ+X5p9mX9j9Lq0vfnr34oPw8x9sw+8=;
        b=NQHjQAz2kjxIJCLpuCCyIpkVifd7QIvKHeOvBGPI76MrcG4w689GDFVQe3RP3eajch
         pYEghopyOdMqcNn1BxzYA6slBesYTaKK2jJRsAtfg4VwwfgwYgUgQovkzqnLxUuta0oa
         bsZhBRe50G0FRxWTJSXtyJbXXeqYJm5kMBTxh506M4SoTM9eLuBEdQ6zb8/rnUYSo/ci
         RS3E8TNIwN0axAnjidN5vnv82NUBoDIf2NukOwP6BtbYgNGyZMQoGwtL3AIdmSHX1VxD
         YdNvNGaq1BY+mwSOtYwce7Zu0RaglWBbbYlrBO3nL3yVYdEfwegyYqNtV3DZZpmlKGck
         9/xA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789035902; x=1789640702; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nDOMwEFmq4ys9LsFhX+YbJ4h+PB/dTq06lEyj7W61bw=;
        b=F9Xd3kNRIR9YqqyhvL3iSwjUzGCw5sxfy5kGdqKPNjgKgLun7p+JD1Ezhg6Ew+FIlI
         5VuJl3FEvmg72k0jUM2L4M1Lu3a7bcBaothiaq+J/hANwgrWCHk2jSwTR9ITNgn1mW5Z
         ZchJZACFa10b8CJYXkLJGfnHB4yNaACyAmBmX2iOnE1sU8VRCVUN4ttc/ycVL/50q/MG
         x5s9VXOmjU2gYhE+wwuNhJeoLJ90b984blKid2TJRdSutumfrdcD3jXXdiQ8fQM8Lv95
         tD9tA2Bop4sJrtW4wn5F3WMqZb8d4jByRTrVBdCM9vl9DV5UHWbxTo6uHguN1lqWVWQd
         dcvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789035902; x=1789640702;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nDOMwEFmq4ys9LsFhX+YbJ4h+PB/dTq06lEyj7W61bw=;
        b=DEKc9i3ix5bffjdByohBPKpO49SIv24XtvzWIBjEC2uuJlIqm2wyFhBjValE0XPMqu
         XJba3N/qgv+zkBKsLiNS6BiNUestLEmzT7a4ksxBnCynEiXJT2AC+YtqLHKnp4Jf8Tcc
         CtwvtR0y0JxnXYwUfKRUAVxKq4/mmEC9jsYxoU6t6qKTO7JxqEv1AG0OhX7kSSLQMnuX
         NI3YMXJDIlutojLSFc7l60Tr7BW+5W4qzAhrzh7EQ11AHsR9dal3GFtnIjJeiQnTxwFj
         PelS+wiIDkgtqtbf82jKuEyqKPtlbZEt1qTEJdKnEh79KEHm3yxKZKQ9pjkg/XmH1i1M
         o1fQ==
X-Forwarded-Encrypted: i=1; AKwUvByqynvlZIxkYepvGGfEP72OBCIv7nfXcSpiZwcR8GAqm+Vfo5LrbfY1QC3X5tS7Xk8G2kcyxWxl0A==@kvack.org
X-Gm-Message-State: AFuF++kSLHmBBI72VT6UZu6fozaBFSZBGsWohVNZIvXUKEkdDdJA2QmI
	Cv12e/dlgMbBUs6OCGvFDTlnNuzWeJq2hwLHlWwKm1fhQUE0FF7f8/EecIhQkEjuv/d53hc0sst
	SF7d/hQZkHW3M9QqwgWEboD4BFwbBfM4=
X-Gm-Gg: AYBFou1yfXh978nUKf+LXXlr2CrGRO4TahKfFdXI2Mtv7589S5G+OHe4mooygus/JH6
	jBY4GgcgthW5yvx/p/ZfhI96IzpAUyn/qZHZNX3htMga5+P+ZPVaF/ohws7C80PAFRtsO+JnMeZ
	AUJ3NZ0BUveyknWwUXMovxjPRv5+L4zrWO3dea+TMD+EDtDP1uyvJsSM08ZbRONaWJs4aRmC3NJ
	SnQXTO9B68wS6yJxnUBuC0Lhe3j13nYUUm4kwS1Pfib4p2azHaAGQTV8o7XXOZ0nB1K5KFHWeCg
	yLeKuPbhbBFG/Xy7zez0EPcwnt19QH34QG9QuNTjemwsfJPQje8cKQ==
X-Received: by 2002:a05:6214:c6c:b0:90e:978e:1c5 with SMTP id
 6a1803df08f44-910d0cd306dmr100407746d6.16.1789035902071; Thu, 10 Sep 2026
 03:25:02 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 10 Sep 2026 03:25:00 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 10 Sep 2026 03:25:00 -0700
MIME-Version: 1.0
From: Tianyi Chen <diannaaav@gmail.com>
In-Reply-To: <17f49997-2bca-4e1e-8d58-bc95e25b9a23@kernel.org>
References: <CACGbirTvSoSeNSpMCBiifTdRKKDsKbgk7nfvh=09fHw2b0M4Ew@mail.gmail.com>
 <CACGbirSjNMD1mijDWRp4gLcw-6dJsErrF_jgjwr3nO-geBb1Sw@mail.gmail.com> <17f49997-2bca-4e1e-8d58-bc95e25b9a23@kernel.org>
Date: Thu, 10 Sep 2026 03:25:00 -0700
X-Gm-Features: AcwNN1U1KzJJqcIpSm1ihT2K_s37DAftiuJeICzH9uiCZ0P912OBUId5Syhekfg
Message-ID: <CACGbirSm=AZtAVwJAZRZt0JAGGUGVOCUQVqu-EcEiiGC-=+vJA@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 1/2] selftests/mm: Reject invalid test
 selections before running tests
To: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joel Savitz <jsavitz@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hnswkdj8chtb4xuby3bxa4ke7p8gp4fc
X-Rspam-User: 
X-Rspamd-Queue-Id: D5A7E1C0007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789035902-779842
X-HE-Meta: U2FsdGVkX1+oQiOmWzP0LUlNwFNerwBW6nxsWBhjKWuBQxayI+6uEqFIWJHtnDXbKjnNmbYYkmFjBmbCmJGsxQmi6Q1uL3BWj9k6eJtWZj/cdNMCMDUXhbaFr3arAjR5beMsDDLhkm7d6t2an4ilChExXnrtt8v28mcz934xerNHetLUDN8LzjsjxzfHsWtvuJAopJY4xM7z39v13JfFnWWfMLD2mteOrXv5OVD3nkiGfMoPFEaD13H6PNYzlron/CBgM/Ey8vExrxN6H/QuLxFRTxLfKriOeKQIkzJx72KCXvIOfd92eWLskJ5JJQaBpLkqWgf1sqCXlokurhAck31O8jn06wEivqk/wofbdhJFK+QZwhWW+kl68SR3r/6oHpyEi1jDUvDoG6hxf9BSkF54r3Jy6WRIdK6nK6mhnVCHqMczbGEB0yrWreLAOqeYFoohrl4fL+1x6fVQMWwQQtjttIteVH1i8AtoFl//0lKIZ11JurwwDBtegGey2VBgT0LlJQle0G5qHdzuqs8+S73dDZiz1Ed4VYQEpJLA/5T2DR1qNh427BB2rcqaZpjU/bu/h7uXhCDxMUbk6vq509WyDQN/fXCHr5xzWi+jGeVlPZu+SDL8SJqTykAKPuetfKQMLHrTC4r+XEospJ1PsV6ZOH7JEBe1SLLNAP/9sgvhF5MaRxr5DSWkvaxXOjtGlR5eFiUoluxquCIdsOozm+ynTh0cHY2pdm8x99kOfo2njIht+fDPs8T29Qpw6iCu7i+yS7qTUPeTfCXK8btCga6R+BCSLKdoVtZB4TP7LriMTTv9NSHuIf7PZ02wr5idjYjI8YiaQF9EOe8Udv3coIUexZ1+ctLFNaQ4A/PHNRYYeRWM39RoZCW1LKirdOhsSxTx72MDW6xr1D6jYosPZEZSZ1cNpppNV2xpzEIrPNT1FWND2CBmfW/gfywItgFqlwDOKAnNKwzrgpLmWie
 9Qw0mOov
 A3EGtbBqbACvU7xdnXWarae3HAq7CEPtcvh1yM/QlO24sMANjFUWvbiHYZ4cjMNJsb7gV7TfcLYzrR877U6zIchGu4XE997No1tA2hI+XjqemyrbbqNdEWc54f8c2sOOAqhbPf6Zg9rlzs2mwVFPiThFmiMlAhxEbn8v1dbmCvoySw2nKAy6BBE0yp7S5AhoAyLQe/AmuSjjjGkG3T6Uql4InR85899qM5lFXYwndA5VFQhp6pSzIxxZWy6BF8DYs6rhlL/qJ3WLutMS0Wc8bYTQhCZ67S5o+P3ibWBZqywhOPALwZWJgfxBypS10QKZ3ZnEII8RIP6tZGIZy3kGmlOFJ0pfdo3592QiLhAsDbnwqe04EFP54HhfEVPJliciw6/5tXeFFKgZj2B/KqwX94zWZot6vrQ/gHb0UsKlqn+pWUT25Cvhg5j622Ug5Bi7qZDOXksPS8BACFj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

> How did you send out the previous revision? Through b4 or git send-mail?

The v3 sent from hi@tychen.cc on September 8 used git send-email via
SpaceMail SMTP. The inline Gmail resend on September 9 used Codex's
Gmail connector. The patches were generated with git format-patch.

The Gmail Sent copy was intact, but the copy received outside Gmail
had wrapped diff headers and altered whitespace. The attachments were
a workaround for that sending path. I agree they are inconvenient for
review.

Thanks,
Tianyi

