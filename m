Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B52EACDC19A
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2515F6B008A; Tue,  6 Jan 2026 08:14:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2295B6B0093; Tue,  6 Jan 2026 08:14:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135956B0095; Tue,  6 Jan 2026 08:14:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03DCE6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:14:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9A6E13B43A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:14:09 +0000 (UTC)
X-FDA: 84301582218.06.2C768F6
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7F66B40002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:14:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=FwGOgF8X;
	spf=pass (imf07.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.219.50 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767705247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKoNVgafDUk8SCtl+9edMLUBCEIskB7+sjp4jDlq9us=;
	b=UVLdKj1dgtYH3dx4yqUZ1zH2lRfCRLNHNLRE6/wnkFmUpLmkNn0CbNzTJ67X9ZQiEBME/K
	FGBxdu3JJJV9IKvPjbL4XJgDlIQ8Rk32ir3lE24sUr4iygD3hyJYtPXHkpQ/8mA5mlvMe7
	k0rJCOMUOSu7ScSVP7zSQqOK7RmPDBs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=FwGOgF8X;
	spf=pass (imf07.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.219.50 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767705247; a=rsa-sha256;
	cv=none;
	b=yLipdg2btKYs7WIl5A/kU+sQ4JQ16gRVhI0UsfS8CeHjqrxTfSaU21cOJdVhvDQ4ftjcRF
	KiUeguQKln3HUiTVRrAPpzy2vCB91zyej29Wto9RQjz5M958mzX1dvCIF1FFmagd4tQgC3
	qwZN1VVSdhR3PsI9eYGuaj1TKMmDy8Y=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-88a2d21427dso8884446d6.3
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 05:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1767705246; x=1768310046; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OKoNVgafDUk8SCtl+9edMLUBCEIskB7+sjp4jDlq9us=;
        b=FwGOgF8XWG3qgVzedfBlcVoOBzTCwqdw8r4mYP90q8g0kJNFOjZGzdnyGz3AvYQ782
         9CbevbipnRsibNFntEOJbc4UGbObw4C4EYiNl/WUCFBgKIjJQ88xJs+pU9Q5pZn57i5B
         C63IM/vh49z/7cb80m3nHAarovRMBmzd1Nn+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767705246; x=1768310046;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OKoNVgafDUk8SCtl+9edMLUBCEIskB7+sjp4jDlq9us=;
        b=aS4KQH6r1PDgQF5atGDer+ADq7R0xX4MDlaRzx89gARjvGRgGv8vMdcQIgvgdVvxp1
         7YX6b307HqnxUBNyaZgDMTFAVloUF8KoWE9yFUg/NChuw8YXwgpS32OP0KYmryFihhmL
         pNZks9QHJpZMkr8iAFKxn8+m93LuibV3itk6RcHDJdwR9BU2tdOpphKOOJmrQrz/vtuV
         fXGgbF8PNHHh3QR6+4PVCpBdF6ZYTQ4Eg+vMak1TznerG7SqcGc0bk1bqMX0ILai3AQt
         KAc0Phmnz2lxWAFErxpBiJVvUgmfx56U0MNWtTKhVfL0T9qz3dyUntWBNR/JwzxDBf+L
         uP4g==
X-Forwarded-Encrypted: i=1; AJvYcCXaGZv+M2ELnq7Wclqj9VUUZAPca83fURRLiStX1p3RTnl4psAxBlfvbK9GoblCTxBiA22ae80vuw==@kvack.org
X-Gm-Message-State: AOJu0YwHhxS39aBXQj3pYaZl1bPbnIRkRHch+ay6r0AfDLm8qmiALt3g
	Gj2fdZuwTONBi18oJnRaVn3yOzmLhbQiXLe99gMc0VY9E6sTnWpL6r+IYHOk6gxIgSsXzZonGQ2
	XAvvwEULCag8jCXyyrXv7V7JGnT/cZm/O92jlVmm8eQ==
X-Gm-Gg: AY/fxX6ke1YshTnq2f0vCWqmgnsWgamfKprL+3vcu8bz5uY6Hr+ycAbv+hewJ6EkGpR
	MDB4Ut6dzSaT32gU/74yPVQRpFNLeVgyLvMBtLkiIvOS4otCClMYRuXfp0P96D1Y7CrI0d/wntY
	yKFQcao0DAnqU5wl1UDsqkWKnPOFVYHXm61AffF0HHYiDT1K+1v2I6d3sgad5XUKfi54SdD4YFR
	PEhxTSQD0V6+q4mHQp0KvXS7kylqYRuVoCT1PHdK+t6+KQzQdWIlZ2umZ8kg/JIQ2cDsg==
X-Google-Smtp-Source: AGHT+IHW76vCaJhXrXtTlnreXmPXnBIYSekopXMOxH3fFuu6sJOI0CsMQDsWF0DT/SavMiCaskutPoC4R4PdrvU0vSc=
X-Received: by 2002:a05:6214:5786:b0:890:587b:207c with SMTP id
 6a1803df08f44-89075e43bfbmr38843306d6.12.1767705246435; Tue, 06 Jan 2026
 05:14:06 -0800 (PST)
MIME-Version: 1.0
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com> <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
 <616c2e51-ff69-4ef9-9637-41f3ff8691dd@kernel.org>
In-Reply-To: <616c2e51-ff69-4ef9-9637-41f3ff8691dd@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 6 Jan 2026 14:13:55 +0100
X-Gm-Features: AQt7F2pvvv_dgMF5DVe6cpYkBdBWgiQKoSy1bex9EciACOPG1MjR_kzstwfJ66w
Message-ID: <CAJfpeguBuHBGUq45bOFvypsyd8XXekLKycRBGO1eeqLxz3L0eA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, 
	carnil@debian.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7F66B40002
X-Stat-Signature: wm73pwh5ykmnxiwyib54aw7bdr7th31o
X-HE-Tag: 1767705247-413634
X-HE-Meta: U2FsdGVkX1/FigE18AbpOBT3pdccZh4bA5qkz3vcF3/rcpwGe6cVVmm4g/u0SmNFLFkkqwfk3TDaoZD9zqLCQotIlfbwtDw/Og1gkXSivMFI6Xl43yjLUDQMGhAP3jldgz9YtLfO+DlINhXj6+zMjqzuQZVT9J1eXHbt7TiyUlCjyyCtJ2X+sA5kLX1wLkQDOXn6/eSx1x7CF7CPIt7DfyGomQrfmLX3l1WXkAwnWXZPg5P6kGhVVxkls/K/teNe3Cl5EHreDaJDLtAJx7qQtVlvvOvmmKYb7bcJdSZ6x6uCBZbmuyQAnrnGzBE+8zfDAT0aXqASVtNgtJ0BhRbsvDtsEMydbMnE40ym8Io3NahG1otKlVGy+iOta9nBYonyzuzp5I4Wn5QuusVYil1qrVAon0ddxKojQuG5JA9uCM9opJ30jnvT1B05mdutwF5lbP5XyS8DfrvsUNKe4LhV+9WzmRtw06b/gS4mnhr2xNwv7P6Bh1GN2FIFGK9fv7WFkObFRfUPbAohOvH+aQEiw6j/FRYbyrsW/USH18Lkw84/b/rVAPOpWizfG0C5CCBawTaQc32bHL7NqY6w08bJKSnCskrbbpwQ7L/LXB/hf2hTvdSD6GLiwxUFNzB5EMNxLfn0oE50yrmc5T7HVo31SX2gYi6L2x1pbl7cMFp6UoP2mMMWBXTwkNono/zbCFTASumMysFtY1H5rnzVjznOb7X5pgNMcs2sUEuQSlfG1THXxFPdojgeD71TJdgfMifO1Xbo+ZsbZiUw/0MnGfwYLz19SUZmVAKxXntXuOCpyvtp+rtLEGIx/Huygs4XVZE1b9BV0ZzqbtDR2hf63ysJum1YtKjoxT9qOVVv47cvzx1sEQocpEeOetBGP4ORYCNmU0RQuOk0VUzch7PsN5GFKAhG6fDoU66kxSfjWZUF5wE9XPQ8gFpyWWf/KzUomRCPKpD/JYtSPbf9GhVN+bR
 xQSnf179
 3M0heZ5JMMgD5Cr+Tmf4ausrtYB2q7JeU7uN7v6BDcakWLbOYyi8wWJ/9mD/Z6cuz8aDOgEVPPo0FkI/NpI14Y5UAo0LjxKOPj20IJG7As1NXGqwiJBWKnueRc7lijzOFetQHrJV0+ANPmdR6qrLVtucptjJIcgf8hZvXSg2IDdHJpoWsDpU95S0+52f1JHAWjHeCgeKmR6W8VVrTn2eFmD+0TQ7Goz1NMeyw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 at 11:05, David Hildenbrand (Red Hat)
<david@kernel.org> wrote:

> > So I understand your patch fixes the regression with suspend blocking but I
> > don't have a high confidence we are not just starting a whack-a-mole game

Joanne did a thorough analysis, so I still have hope.  Missing a case
in such a complex thing is not unexpected.

> Yes, I think so, and I think it is [1] not even only limited to
> writeback [2].

You are referring to DoS against compaction?

It is a much more benign issue, since compaction will just skip locked
pages, AFAIU (wasn't always so:
https://lore.kernel.org/all/1288817005.4235.11393.camel@nimitz/).

Not saying it shouldn't be fixed, but it should be a separate discussion.

> To handle the bigger picture (I raised another problematic instance in
> [4]): I don't know how to handle that without properly fixing fuse. Fuse
> folks should really invest some time to solve this problem for good.

Fixing it generically in fuse would necessarily involve bringing back
some sort of temp buffer.  The performance penalty could be minimized,
but complexity is what really hurts.

Maybe doing whack-a-mole results in less mess overall :-/

> As a big temporary kernel hack, we could add a
> AS_ANY_WAITING_UTTERLY_BROKEN and simply refuse to wait for writeback
> directly inside folio_wait_writeback() -- not arbitrarily skipping it in
> callers -- and possibly other places (readahead, not sure). That would
> restore the old behavior.

No it wouldn't, since the old code had surrogate methods for waiting
on outstanding writes, which were called on fsync, etc.

Thanks,
Miklos

