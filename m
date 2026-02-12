Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34A9BECD6FE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 01:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9931B6B0005; Wed, 11 Feb 2026 20:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940F86B0089; Wed, 11 Feb 2026 20:51:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877726B008A; Wed, 11 Feb 2026 20:51:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7702B6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:51:13 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49F2BD6EDC
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:51:13 +0000 (UTC)
X-FDA: 84434126826.16.6AE5B4B
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 49E6610000C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:51:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=TgedmmPV;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770861071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8F2uvdcsPAY3wp1lPdGpehWiVzoRNGbiS4IzV4wokE=;
	b=p+URbZKAIsJ123ENWij0jKoOciXF5nPc6w7SK9i8RgVAkmW/A2ckAaAOZQm7Dl+7UF2qrK
	1KU/TISlhBPVfr9+/KJFfhLsoYLm/yQ1sJKgX8YQTd6jBmKclVWRaodJfhP0VJpY5ywsWx
	HKNR4MfZAZQa1igmCf51CwTPuzLcLw8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770861071; a=rsa-sha256;
	cv=none;
	b=cCgob4VxjR1AXog6vA13zky0Jn4ix7rcNoPAfFtiKVxCnteLMAZmyjI6YvFjv0t8+fnnAt
	OwqcSFLlzz7KfgwfLxsEoS6RefCN3jcYPvYumaMzNudt1b1sLPmKMCUVN0YrzuUbBszJiV
	qzHj8QpL5JHSPEL/ovFErh4wrAgp2uo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=TgedmmPV;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8217f2ad01eso6158867b3a.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770861070; x=1771465870; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+8F2uvdcsPAY3wp1lPdGpehWiVzoRNGbiS4IzV4wokE=;
        b=TgedmmPVh2DAT5aZAeoUraTcrJs1ri+rzn2f9TBK7zLPD9MEjCmrVYn5QyAPKJNgFJ
         vptl1IvF3hFBBhf9cFYYhuYHc+p8oiVaWTNJl9yNI8h7I5cMys9QBJ6TDIb2HwYoM0Ao
         Otd8DaOJiJkcbUjmMuxxNCiNFkgpxLT0nJJns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770861070; x=1771465870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+8F2uvdcsPAY3wp1lPdGpehWiVzoRNGbiS4IzV4wokE=;
        b=er4z0m27WFOSvPMWeCn3JD1oadKNvIVxT2Nn02aiN+iZtsJUvBurB+wVj5HPFeXaRF
         dY1yeUrP5z46oMDHv3FesDoIb+/1BwICv0Xz+xX94cSjSb/YtKoZMkEqn/z2KuwC5C/u
         vdpYnld/19o9JF/Z5g8pV7/Od1JvRD0AeQuaTusH1vElG9ma4mHcPnXjYIbhQwPHZ0Ze
         2CH5BfP85oDGUA9r+Xla4wSLw1yrXd/GY6kaatm9G+4RVwindkF0oQa9BLb7QMor0i2N
         Q4QK2egoRaj2Fv9N6ZoYWO8zV4CD/iwyB4EfBPG5yMobYu37oa0lPNissiGekgJw/FmK
         ytHA==
X-Forwarded-Encrypted: i=1; AJvYcCV0Cs8yi3+hIRC2Aq9b9V9mmFZ3Dub5DJbqc4zQ7bmhiZV5fEmaIL58NcuZyLMOF1LIZ5ueOS8Iqw==@kvack.org
X-Gm-Message-State: AOJu0YzIDdAnLHIn7j6NDQjjkMo8ujZigyPfp3+BOGB2X6C1Mcg6HY0A
	fLoAmIVaNSUWu5Sek9HujvTjSHnN3zzJgiCYu8C9j3tXJBnZ2RyxzMXuVcs0wyUwyA==
X-Gm-Gg: AZuq6aLudWCIgaj4R4llvMZnGfKoHJlAXB32pXf8qyT/W3d7F+qu/JybflqNPFppakg
	8s7m1aKM93+fw3R7oNCowbapFR7xPXCFEjGV382bXQy7ksswpofp9HaslxjJFoWs7EtyQdK0QVM
	8wFU1RGMxg3cAMK+A29VYOFWoVSy8/Phnn+PerP5WXFC7FCtX7QRCGZjLlrhhah1aQjjMkr0AQP
	f7cz7CdP65BaLNkHWDFlKwR0EdhXmCuuy3q/4XRg7EqnKTseK0ProysbKahD4nixNTftMkpkNxp
	DX0jkn9pmAVslfiu9fUgjkfKfFarHNS8h7o9USdq4g0+BdAN7PjKjZshU4Jmvw4N75gMMaGtRYm
	Xs2pRoVPOOHmzqK0siMLvfC82rhTAlDrC3ZL+6u+cjn9g8UQU9iZdbJOR86pnCDsQrGorxtV/rE
	yGwPdg0kR9Ls1A5TMXjMCE0it7nbI40BJ0s+sIkJMevbbykouSvR9N/DGTToO9RtDK2s3iEAMv
X-Received: by 2002:a05:6a00:f06:b0:81f:3d13:e07e with SMTP id d2e1a72fcca58-824b0542665mr1076667b3a.41.1770861070188;
        Wed, 11 Feb 2026 17:51:10 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:725d:f34:4b56:7316])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e816fbbsm3169880b3a.49.2026.02.11.17.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 17:51:09 -0800 (PST)
Date: Thu, 12 Feb 2026 10:51:06 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nico Pache <npache@redhat.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
Message-ID: <lrouiwimacvr5o426vbxx7ucroh4etk47abfgpopmi3qcaufkr@vaiqngpotvdr>
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <CAA1CXcA-V7FtK-QkyRHak1GBtepiFiTHFtF7g93P7mM41_2LMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA1CXcA-V7FtK-QkyRHak1GBtepiFiTHFtF7g93P7mM41_2LMw@mail.gmail.com>
X-Rspamd-Queue-Id: 49E6610000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: jjw38qzswneudpkce5chby3xnh3kocxn
X-HE-Tag: 1770861071-271141
X-HE-Meta: U2FsdGVkX18rP4Ym9JPdmg/SDKwFomd7CU72HbqrVOmsab2DakS9COOe8cHgrLE6HWvlzrmdCfynrbc1H9VNuVpl1+6wfSaGmnRCc03fLoNnDKdsQHm/QO10Sr75wS2tOF2v3AAh1dAJte0E+m+B6qwMPB7bJE88NTObwAznjvtvTsSsjbqwPP752zhbWAX+sBuwPNDjznoiREgTvn72HiBAWBfFQFTqj0fJAezo7ZXvE3Mg8wfrZNDN0RsUn7+rYVsC1ywHA/O5n/oL88JyndGpVgm6ECcuM1OPHXzDuxCupkNpTvkeKni12zHuk0kGIWIH90WtbIjzW/l8IGo9+PPmUXzxO9svGu3JpAhyXFHKTPrlER9Up+6vPZj9UxJCxelNemYXMPYC6j6ZFBrEUHfcXDkUG4iGeE2OGrJw+o29j350U8jTz5fYJyQroKOpLJTC7KvrNzOmfXILk5Ga/dQIb+hIoAA/vpDPXSMux4+kOoxdTKMIB79IpZvmi/0p39VwUj25UkDVaF8/LmUOTza/Yhru4WrboWKTWqoqbBOfAOl+F1AjQd67ARwKRqbYzXQFdF1aI/f0qWNi2jdE2tsOzQsJPEIiRTm5d8POUEHFkyyQ1sgIXs5O7/v+Q+nya19Q+z3vOVLR/cFVMu64hFwbO7xuh7hmjlUcU8IIJrrcquE1U4QTSw7u70GjvVoaDkPPMR/++NWqHaELgQW7hdfDCcSAbPLklu3ksWWknLkroi13AsZSPhNNmW6auTXw+6hBBxwe213QmpNoUmJy+kP6Fw3XmM+iOd4LWADP/nXDV+D00ikVac0WtFSTlLla3egd9Q/cwETVq5VZ/ONRSm7SF7GbFpqidDsCYvXYv+0n0+/csDhwXogd7VLyIXDr7xT58k5xZxLaH3TjR7TIS5B7KSsxl5PBQ7DhDbv2vxdIfWk3qlSfHVOI8wDMhM0ffhQ208kXAP79LBrs9r1
 7t6bHOvR
 evYSPkPdo50mg9CIFrNAHd02v+aHqcVtZhvAGCpr6Y3cFkVU/1nax3BJ7ucoPwQYbLxilwmptcqrSynHaFnyYq3p0R0Jq3HGtp32/wszPrB/0UJowc+OC7SvOzJ4k52XIBc2XOoQjahGo3VqToeBEMyX5n7ENwEyzto8yO8nwlZSlob0PqVZZ+7YQeu2ni/EV8BmkuoYkOAQ/pBtusTl+hMZsYg76EHByRZkXdEus5qjPxofQWW8YJdzbu9A+6lEM+FEltIap1XdgHBEBIJJuC+ChYW/99y0GcuoAHo1CcMB7Ec/g1CVHz1onCUY+LRuvGquhmTb/7PHPb8IVFXg/yPKQRUBIVy3UuRRaxANKL0uRxr8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/10 23:15), Nico Pache wrote:
> - We usually send "To:" the mailing lists and "CC:" to all other people.
> - Your subject contains "PATCHv2" there should be a space there
> - It would be worth noting the "HOW" in the commit message

Ack.

