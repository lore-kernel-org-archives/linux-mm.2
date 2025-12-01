Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B33A0D116E2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 03:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE3C6B000A; Sun, 30 Nov 2025 22:56:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88EA96B000C; Sun, 30 Nov 2025 22:56:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB606B000E; Sun, 30 Nov 2025 22:56:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BA416B000A
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 22:56:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EFA2613C429
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:56:34 +0000 (UTC)
X-FDA: 84169540308.01.17C8D70
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0CEA0A000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:56:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AbUtKPS+;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764561393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qB+a+p4MqPixn1RqoqUzTdFtWB/99ITR4DTLW8S81nM=;
	b=LHhJ8ycYviIoUdmNMYHFrZ2B/RwPVKLy/t7wL4ZyeuFP9GDM6ELScWsvDllfICoLgDvsq+
	qx10loh6S8bNHSLjNQiJ8wS3beknx8ZtnhZv/lq1B1qpGOY3xjpJuM7ry/v7pW35+/xAaT
	cxmgy6DjhLlv+sSrUJ9UwUFWWN8gQJs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764561393; a=rsa-sha256;
	cv=none;
	b=ml6lsPuUn47pT7w0KU9AHIouI9TCDLSUiLpoc+0QKt2cEJPFwEcj+1oJJu5LzUzonpA3Yy
	3ka/PzCUbPIQzZFwkMdNmNh3d0nHQBdCqI+/8BgUzeejue2uXSAQp0M1yug9XM3y3Pv8WZ
	sO2H+1W3NstyI+38pMEgNLgpr4kxHDI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AbUtKPS+;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29808a9a96aso41596815ad.1
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 19:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764561392; x=1765166192; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qB+a+p4MqPixn1RqoqUzTdFtWB/99ITR4DTLW8S81nM=;
        b=AbUtKPS+Juah6WUSBAN1IwnT51gXhlAv2TThJZnfucIKIcFuNJj/Pw4NGNAeLVG491
         Ty5rmMyge4PvsVd7ts1/XoZ1K0YUr44klQT29S+EgULOWHe4/NLiJyr6zYS3m+NEzU8p
         bzWqMWU8q3u3RhY2wpLyNAlrXZWkigrsnn468=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764561392; x=1765166192;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qB+a+p4MqPixn1RqoqUzTdFtWB/99ITR4DTLW8S81nM=;
        b=aOXQ9k3mTgf64AaxUHebE1d/DJbfF9uykD8gIZ5NkfR25GjYFbC/swysXHNw8CKLMb
         VSjzhgjRckGywwXdEyqsU9C0qo8btHoJwQq176CmHDxy/BbTCu32idGzcO/RgiMmVlAg
         TLOSarNO/muZDWFMl+RfVCdkKPECMyNM4EO1L1F5WSANpEeks+P14Bz1oFKUDRQ5LULS
         qocRw4cZZTknap/XxtCrD47oIgrZMrtohApdylOwYZxt9F5D7q7QJUpDWRZNY1OzKl7G
         Y+zxiDu604cHKRuaAe8JtIwYqaJppwrW4ty/su7SwecbEgUPo/mRCNX2WQ4kSbKVcjjM
         DteA==
X-Forwarded-Encrypted: i=1; AJvYcCVFt/UvyJKNhKZHAQDc+DeOnieGqgAcqsycBiHrH/ET28HQFm4cQk2QLAgcGxvXY/VSS+/UvMHKBg==@kvack.org
X-Gm-Message-State: AOJu0YwaIDEOgGHeEja0sfWgN+ZLpx8HszSILixBfWHuN87/OGUvEchV
	yIhjk6chzgZC8Ex3SG5E+cKmbFtwP7oFWL7x7oMEG8FQCcvATWuoPuwLncfvILNQMQ==
X-Gm-Gg: ASbGncsSJ97UmHjqHiAvBVFPXGovra09+TE7HvimW62hM4U7XkLJqVcIFnJ+3ArgzEc
	uhFR1Bk1C+zNBdXcOctJTV3ybvuSPIj8NOfWzJ9FGWKH4hReYjxtMBInjSOD2IS9Gsy/8/A21Vo
	jIyjwlSQl5fOsc8pRZSrs1LNALQs8pIkySy8o3M4YCcQ2ti2kv2A63PsaC0nrR5Xj/pYcLeZlKp
	ftIME2aTI7Y/yFilhKwUEMsZuLhYK/G3nb89NFE3OakRGqoi54MIvNy7qYrW5h/gFxhepW4zoix
	DaRRcALvWdPifyAQpnfFzdlGE2yNjuLEEFvo89IGAG7zEoRo+LvIj743O6sRuiaukg0j/+MnUHN
	00AZV2pLrMc4m0MbvNRQDlf1rZ7bHjEOamGDzHFIAZMEJtVrd+5HZqyDqioobJXUKml1ax/JxKa
	/KOrB1vXY5BdpKnwBgQPT4C8zsmGHnFbOEeTkJaN4rlnYln2RttQk=
X-Google-Smtp-Source: AGHT+IGKqD632RpKl5VzEYBMQpnYan4XzgzGuzvbee48YOC0K/yn1Egh3tF2peeJh4TbkCddTQ/sWA==
X-Received: by 2002:a17:902:ef07:b0:294:cc1d:e2b6 with SMTP id d9443c01a7336-29b6bf9c727mr383590675ad.59.1764561391784;
        Sun, 30 Nov 2025 19:56:31 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb450cfsm106014465ad.74.2025.11.30.19.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 19:56:31 -0800 (PST)
Date: Mon, 1 Dec 2025 12:56:25 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Richard Chang <richardycc@google.com>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>
Subject: Re: [PATCH 1/2] zram: introduce compressed data writeback
Message-ID: <hgk3zp5hwlcxo6ufiqasvte3hoksy2wb2kta3fime5rprq4org@xaprrqdabvgh>
References: <20251128170442.2988502-1-senozhatsky@chromium.org>
 <20251128170442.2988502-2-senozhatsky@chromium.org>
 <CAGsJ_4yUAw_tzX7z8iizToMB8SDJPNOhFRZNXva_ae46q5vRwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yUAw_tzX7z8iizToMB8SDJPNOhFRZNXva_ae46q5vRwg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0CEA0A000A
X-Stat-Signature: geobhu5mewxxq6nid6g4f3jif9p6xyqk
X-HE-Tag: 1764561392-572078
X-HE-Meta: U2FsdGVkX1+u2ilKr66Xv77mW6PzZS3pVMk4OyLDcAf1I1CjKUQ9R/U9pygrbTFWKxJOyFRI7mlscCuiUtvdojzBqi8FfTWFE9EKz6FKp0BtfkQQe13PSzNzej8X8FlTIw7ai0Hur8mTy8iBoVRu+0RREXlHjvO+LecY74bl0Z0ZOjNM7HqvGQWXatHRb0APdADrVm0PrL/hInfXAD4dT+zFtCzPUeXz/n9IkXH18mos31RUMh7wzYNYVf5bMK1nuHsjQVI3VIlbcvd81n2WB21ea2164F/itdJ74y2NgOYN0JJnV0l7bABJeSm/yv+X2k1b47QDEUuQU/LH8mDRTDjt9GX7x98/00YbA/4OHjlfZea9CJyHsdQWXaptNZYM37I37pCGGl+WAWpli2fx2sBDAgE5DkDe7fudG0xvXV6GvMjNoj0oEiqJ05fWZfeWrKvXLkPTG6VnfEvggIPQLvTrFKcQ0voTwSHWZGApYKM3IovvMzoMmErF2JydQKLvex/Sp88BNwOH1x8m58JNpNuL5GOu7V9MyclaPVxrJGTX7LIcrh9sDu1wZjmXUdXM3KqeWBxibdkJ6mUnjvHdAGgCT3rA0wvq5Lyu90A/Ie9Nn2RYfLhpz1STNvJF2z3jDg9Nx52B4ZJirE5UoiIf+mU1IulyKpmlNibTCKGEeSgJ9cx97tZgQOmUAA5C6Ubjqxa3Mg1RAhSZe4wJ8HEttVUI2fv5rhxK7vNXx7+ff30uaKNGwN5KHoZY5UN7l6dueGP143A04g9JFza9sLIrmsjFwqLRQWMJAzcLx/B43KH354FuhWjzfspi2foFHn15NYRwUFjGQU2a6d6qTrK0VsqbnPbpP4oXaNR0hYdQDZO7u4se55QHVyTZPnuWS8hLlFYFeyYmPrpFysHaxEW/DBquDiF1Qw19Zl8KNvNpGvhxN0wLdf3havn6u7Q+VbZ2KftLO0LnelA0mTpZf9t
 cJIUCDS4
 KQAU4pnitxg35q+tx4uIbcs8n0N+M0wuXcjjTjIc4BiQvbDeujchs8pzaX1oUoX/lUossqXZlsTDHG5a1q2MhL1aZMUVcESjvpyIVhyG4lS6hCzsCUDv2rFcOZKQfiWvcCjr1CFRUg2yfyOdFm4yynjpOZU7DkMiCpLMwH5dVF+Si3sMjlyfB9dPemSAF5qJYrsd/LW6I9FDwOQJ3MewkKGNPdjRTb040KKwp4/HFfCdhR2HWQFDM9ybWe3TqAz1ZJzFaq26bAhYUfRCTDlx+RmQRupvvnYv8haVVN26eGvIcG6+/rDZy1uWNIh8fY2WrjV9FApY/wPXsZ41Umzp2X/ogcuRQj/PcFFq9JUx0egSEB23HjVvFdMhBrDpbwiRY79AwjWLYClyftUs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On (25/11/29 17:55), Barry Song wrote:
> On Sat, Nov 29, 2025 at 1:06 AM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> >
> > From: Richard Chang <richardycc@google.com>
> >
> 
> Hi Richard, Sergey,
> 
> Thanks a lot for developing this. For years, people have been looking for
> compressed data writeback to reduce I/O, such as compacting multiple compressed
> blocks into a single page on block devices. I guess this patchset hasn’t reached
> that point yet, right?

Right.

> > zram stores all written back slots raw, which implies that
> > during writeback zram first has to decompress slots (except
> > for ZRAM_HUGE slots, which are raw already).  The problem
> > with this approach is that not every written back page gets
> > read back (either via read() or via page-fault), which means
> > that zram basically wastes CPU cycles and battery decompressing
> > such slots.  This changes with introduction of decompression
> 
> If a page is swapped out and never read again, does that actually indicate
> a memory leak in userspace?

No, it just means that there is no page-fault on that page.  E.g. we
swapped out an unused browser tab and never come back to it within the
session: e.g. user closed the tab/app, or logged out of session, or
rebooted the device, or simply powered off (desktop/laptop).

