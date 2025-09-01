Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 193AECA1005
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 21:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6021A8E0008; Mon,  1 Sep 2025 17:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9216B0008; Mon,  1 Sep 2025 17:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516188E0008; Mon,  1 Sep 2025 17:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 418B86B0005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 17:10:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD9B21DF20E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 21:10:43 +0000 (UTC)
X-FDA: 83841925566.12.964DAFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E985F40009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 21:10:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBWQ9QCP;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756761042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aj7jk6/4oeEo9ZStPm7WvMlGJlnzqQdxI6UIN11IhYs=;
	b=eZYA//C6BbcjgmFSW4/lh6i8wtcx6K+qU+80CS9tDz9F+Z0J6GiSIF2H5M93POo7kQwIST
	oe1T+tkh1i8Tufe/vUTPepBypgAg9omUWPV4apHVjnZdVzE1Ql9VArvuU1jpRe0UXbWQnu
	TZbyusVLo8sr/rlznIW42/0K4Brwrj8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBWQ9QCP;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756761042; a=rsa-sha256;
	cv=none;
	b=MOIMDb4mj8vPcRiS80ZAPY7y+KKRk1s5nuLf663nL7G6mQW/zBHGffapR36hqq8QDk0tJo
	O9/lVnGVcJfZanyGsU1xwPngvhw1FpvX1C5VOd0tp0FqTH9BCk4m9Qcxh4yjRavhOoq1jr
	I+nWprDpApTd960YB4c1qF1/L6eQZWc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BCCD451BB
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 21:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52707C113CF
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 21:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756761040;
	bh=Aj7jk6/4oeEo9ZStPm7WvMlGJlnzqQdxI6UIN11IhYs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TBWQ9QCPZ+maZ2b5FHh2AWFgWmCrlbelbWiunk2PfRO6R7ZKuvyfRr94BGLJCnbH+
	 XEM4yNlDiwp6iwdVCmrQKzvgQYv4CXzDNuJjT/kVKDkNyxOmIAFlAHWMOQ3vS6FwEI
	 JoAqrcwAg229pTOKiHhkxP5aFYpqYlYY9WIgXyFztmZoexHR2Y9S1Yud62dcwW090g
	 jTAZUJvoTc/htvaFc8FE9WZ4gnZ8Kp75s3ehTKPdlsHd3WMCIcfHvZWz/lYpVYCRZx
	 WP+Ftk6hmwdURoLRTmGf1TYNyU1IxoRl4lkqvFy4VmVMVdz2Z3bAGTzIS9hELQl78n
	 wXLrRxKgtqWcA==
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e96fbf400c0so5174247276.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 14:10:40 -0700 (PDT)
X-Gm-Message-State: AOJu0Yyl90JsyLpBbauA0LIkN195VXDq2V7tt5m2CMEM+pO+A+y1wr5L
	ey2OkiEOh/2dHjtXbQRZ7U59E4rfv7BRIys3A4lCveKhoFKiblfbc9ZqF//ABI0CoXEJvR9Awb7
	ek5SixIw68ba/QM0nQUbaH2D5OMQK68952k7n/xcLKA==
X-Google-Smtp-Source: AGHT+IHa5GjFdHauSGeoAUuVa/rafYkP1Narry2RQd4f2CEtiAiD/CBeD5rg3Uep+9glwYbmx/jESTP93gIEzOR5Vrk=
X-Received: by 2002:a05:690c:f90:b0:720:130:eb0b with SMTP id
 00721157ae682-72273be179dmr125183747b3.10.1756761039556; Mon, 01 Sep 2025
 14:10:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
 <CAF8kJuO0efOE-os=qi=i5jT1YWxspHYc=Ti1KN=uKgyFpWTRbA@mail.gmail.com>
 <CAMgjq7AkUc7hKrEL8cQ7jJTeXYBq7WqM55uQ_SZNNY8vJ7+ODQ@mail.gmail.com>
 <CACePvbWnsrGxUv15R4kMpc10wsBE2Bc-rapGyBYjekrqFJgJbw@mail.gmail.com> <CAMgjq7AT79NfcKtsfgOi6LQJViXOz-Xs5LOUmOiJYJS-DwQg=A@mail.gmail.com>
In-Reply-To: <CAMgjq7AT79NfcKtsfgOi6LQJViXOz-Xs5LOUmOiJYJS-DwQg=A@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 1 Sep 2025 14:10:28 -0700
X-Gmail-Original-Message-ID: <CACePvbW9J5_8uLi46r+wm8cHfZPdp6oui3oP7u2hLOEgJXRrTQ@mail.gmail.com>
X-Gm-Features: Ac12FXwitpUktG-d3BA20Y76Po2OE-S4dB_W14mBspRG9ZlRPf99xqxJUTjxkJ0
Message-ID: <CACePvbW9J5_8uLi46r+wm8cHfZPdp6oui3oP7u2hLOEgJXRrTQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E985F40009
X-Stat-Signature: bdhyc4u9je6rx6edaoa3frnnmqk591io
X-Rspam-User: 
X-HE-Tag: 1756761041-239597
X-HE-Meta: U2FsdGVkX19a7wWSY9nmoxeoxMkZP/7OGKsYkm+OJiWevhSjXfAU0RmhwYdY/FUiJp6m28dT1eVn1rWDqlEf0+FsQKCPU6hMvq+QPYZMX6BjA8Q9FUT5mL2cKf7iguFBxy3TjmSTlVN6BaraSSCVzH4un0avNaCOsTr0JLaG3nPVHAAgnp6DRFcgi30NTXP+cT5oSjT66hCUMYZUJqHmIHWb+H+n2efLY9kKnOEsMKONvIKyKxS93RH/bi3Y+pGTPj+IP3Oc4CAtUsmH6nCAQLDLYgbWJF03kwS7Qcre7IQ/YTvRCP9d8WJaeb430kel0lj3pYgquQkpiHuJGWOdY44veYzOUejC4iZSz7rFMcc1t83myOvglUpMuhuSXzWgVaMFnAsSEnMcZLQuCwD89BUFBMN89NXnXCaQpK26uXU54qxUsq6Od1xxxyM3iMsSUfU0RKuREl0t0FJbfsm6P64F+7eEq8pjDRF6gFlskhd8jSyQOz83wMTqL503mm1xZ6xLiIuWgTNg4PLpTtvtJ+R5hy03+gEowQWIUH3UGLVUhNlB2pE/K+j38X1iVyn5r9LlrXMIrN98Q7vDa93gMguCWmcGpMmB3TVs6qKDufeyr6VVYff42LJ18TYNzu1YFLDQL8NhvJQp+KqbNW3QYsw4gWs6sUgJ647+vfWfBnqS/dGOJkZTNfoeNtzmSrLN8lNOK1fMdt+Jk/NZAXzsli0NqmJdGpZYNfMi93ac4H4BOogK3r2k3MqDToIrVTZd6sn1CAswieDtKwjNaSALeIhPKs/djuKoZKH7HbTr53EpfgKcaxCm80C88oTx43zkQqw+UP4NUGb7FFO4GbCwkU5iBDITB/jk01pLYYwiEiThTUAF1ljm11yu6Uifbgqny9bDD6eKa9yVlspNMo22olbli0i3Vy9CU9/qK/dkue3Fh4cboqmOEmOVIqWIK5Q+Y3/cCrLh44ES3aflzVm
 Uo8skRl/
 FMtahUD2jQ+7dmaYZy+KmwkFteVQd/RNJsxFgiTP5QzxS3O8n7dFfg9IZOxK957agSRPD+ABxtxohkq7FSa823JxjwcehYHX6Ra1SNIRTgiHobj+9/Vlrp7MQhXuckAZGZm+J0l6c8F1zYhSFtC2zdb/eW3JNU1AFT6O49pCUlBUHhCibg8QS1x2M/tJKWxjvg7SjCAoSrAyO9ZsTzhNwSLF9oCj+avDG3gYWakYMAyDBtZVqn30KgIAS+X7q4LF7ZVLmLGtaqBGMRfshKWihgEseXFolQ9bVdXdGUo6Flz6R3X57aPD0M7Ei7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 11:18=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
> > So the missing readahead stats update behavior is the correct and
> > better behavior. I suggest you spit that out as a separate patch with
> > appropriate comments about it too. It is also easier to bisect the
> > commit if that kind of the subtle change which is considered safe
> > turns out causing a problem. Causing problem not happen very often but
> > it does happen before.
> >
>
> Hmm, after a second thought, maybe we should keep it as it is for now.
>
> I just realized moving the swap_update_readahead after folio_lock is
> more than just ensuring the folio is still valid. It will also cause
> every swapin to do a readahead update. Previously, only cache hit
> swapin will do a swap readahead update.
>
> I did some tests, and didn't see any measurable performance difference
> between putting it before / after the folio_lock. But changing it for
> no good reason seems not a good idea after all.
>
> So I think I'll keep it before the folio_lock. There is no evidence of
> which strategy is better, just keep the current behaviour.
>
> Calling swap_update_readahead even if the swap cache folio
> is already invalidated is not really harmful, the only thing it does
> that may effect the folio is the folio_test_clear_readahead call in
> it, and we have been doing for years with no problem. Calling
> swap_update_readahead for every folio might not be a good idea.

Thanks for the update. That is what I originally felt as well. It
caught me by surprise by this detour code path. I need to spend extra
time for the detour. I don't see it necessary to contribute to the
phase I goal of merging the swap table.

We can still add it later as a separate patch if we want.

Chris

