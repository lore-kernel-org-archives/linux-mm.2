Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D50FC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 05:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F2A6B0092; Fri, 18 Sep 2026 01:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF066B0093; Fri, 18 Sep 2026 01:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE3E6B0095; Fri, 18 Sep 2026 01:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 165786B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:33:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85B16A5E8A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:33:20 +0000 (UTC)
X-FDA: 85225764960.22.CA7BF14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9C687140009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:33:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=STYojl8L;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789709598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrqgHKZBnXQS3LTmL5rUHDGXosNV/i35MDQkSDwdDWI=;
	b=5fOZV8Kgl4kXskTzhZhytVu8ddRyOIPKJ3UpDJo153hZ9gtwhbPyNzfrqv9+9aFCmMP3S7
	NvBIgVDsL81pe/H07KIu1iEgHzUZ/tBkv5aXDmnwSBVy74sdGAtrG0aK2h51vr5Cb01oIK
	26jfG9qvoEmxxDpfVnHFxCyzfx82Wyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789709598;
	b=xsas7wsmWVqTj8+jl3hKh0R/BEYvIUXyI93ogoyIGhFlpJ2ou94X6YBgno+Dmzx7F6KcCJ
	3EEm0R2YRzFIs1yKzqW6JJf2ckA6AfBtKz6E9as03Lro5uU4PIo/ZDSOFG7vuH0q+UMWXN
	/wbYu9lJjJxGu/kCB+rTftlIXGQt7TU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=STYojl8L;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3E9143B89
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14831F0089E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789709597;
	bh=MrqgHKZBnXQS3LTmL5rUHDGXosNV/i35MDQkSDwdDWI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=STYojl8LLgSZ7rBrlPv5o0I6UROlGvodjFfimLAr//VC2GdJ/rpCRn/yUuNi/NW8h
	 WWyDq0DQzXbXKBd+xO1mscTIEDIQBKbJpx+YZ4xEac7Cs6afGKTUh5loXxO7eGghhU
	 mdN6rNBV0SCuQoELdk9V3LQ+jIIZX5UYSV+/XGmAzLnnzVPgTjxO3IouIDb2Wdcc6o
	 xU3+tQSuiaVWElT+RdKGP1PFpzB5jGxnVldVfRbLwMdl1OaPHXeupIvZzAqwnf+HlI
	 H+ZRs8Y4r1D9zORVktnUOQeS++cxqbbEQWpaIEnPIglBGM/hBAPeB8va+RyspmGigH
	 liT8ztP1u99IA==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109fafddso25154685a.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:33:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz+cygV6tu5z/hfEIzRN+Vl/3VwB1bbDJ0qFSjFX+SfWjpxThZXtSM7ddR1YoSssSLLEa9HtB2fXQ==@kvack.org
X-Gm-Message-State: AFuF++mWcmEWXj0KwwJigcLbJrwINGLE1q5FxwH+fxS6Mmo7+Vs6nNu5
	5h/rr527aM6oL+zSLP6GjHN5vJKIUrPV0f1Z8wDMg5CHb8zRibWFR5OX5VVCibCbcXgqd0ltoFV
	fPw8Tu3dhJw3R2nhu8h3Q0FsYMpVed58=
X-Received: by 2002:a05:620a:7114:b0:93b:d7b0:c96d with SMTP id
 af79cd13be357-93bdca1fbd8mr175287085a.78.1789709597052; Thu, 17 Sep 2026
 22:33:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com> <e4d6918e2e420a2378e8f8c502ccfbad2a7bc2d1.1789701677.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <e4d6918e2e420a2378e8f8c502ccfbad2a7bc2d1.1789701677.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 18 Sep 2026 13:33:05 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yLMG22e+ugYbzCy9nsFcYbMAgD6Yy2JnvSmGkeByqkNQ@mail.gmail.com>
X-Gm-Features: AcwNN1VcNOsKJhYjJrG4_QwdawIGy_yHrffsBL1ZX4iaZwpmnTo8DG5_7w7tqZE
Message-ID: <CAGsJ_4yLMG22e+ugYbzCy9nsFcYbMAgD6Yy2JnvSmGkeByqkNQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] mm: khugepaged: drop the hugepage_madvise()
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, david@kernel.org, 
	ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: aprpa1woroukepqqz95of1kiys66xh39
X-Rspamd-Queue-Id: 9C687140009
X-HE-Tag: 1789709598-39318
X-HE-Meta: U2FsdGVkX18Bw1MWzboS3ZzB72eNAzqrnSgIk9kCf9hIX3Ik/Xs5VGLykYb3FKpIi77s6/gy0hokSQyVUZ59HcEaidEHwZUjPeByMtWPbo5g7UimyN+rwuHlpcmImF6wpavHC7jqTqW+mSKeVXm9h+HvRxx23TQz6NE1nhYVIXmDhClt2htCVwKbtkG+4cI8DOubGwA/LqXLFeUrlzPWynQnSTTGQyzHHi03BYAPRpco1d/7OAC1uzgz4NVNebMhPH2rSaQs7yBv+SsAX/RZU1prkJxfgcVg5uKb46qNlVL6q8xuABn0sMsKwq78lCa2cZ+ps8U3ao7HUQSvimZds2LoEAmiw2hEHkhCPKdiOhE39dAbwHQrFSLS8RK4A99ynlKaSvtOwX7/x7R36tKIALxnZ/NcVY5nXAFYHkiG0y2zLxF0fzjRV51bYUemjPD23vojCyzS6qePrpj2a0qsxl0YxwKnwhBvyqXFPbN1oOa0tBaKfZ4vZyNZ9RDCLfn7wU0OjWgp5bDCtQ0Uz6YYbmHADpVPphydJ05dalAYKy+KH/1ocLq1ILdV+Gitsow62l4N13sUPNECTtxOujuUgtclJqaIAxFjY6+N61G9/xcbNgnQ+TfuWwfNzB31zgvKyzsPhjxN/uhT4pmjwCD/WT4b2zDHotZT628EP242V5hR4gGG6LoUtZ5VqdCxVfzFAgsEXxEQ8ioS+NW9x/ePcl/Ex/z1VbCdPuqUCtM686i+IeGJ2vkj0MTbEkpq0CrPRvI+CpBbEpwuywXHjPlCs6Q3pI/BSMejNe4/Q7//vUE+IxunftVzsJATueChgEdUY0ic5nkvZKHtz33vxrHfyhLxQJcdM1YNvRJHM9FihWWVeUbCteZxfOsCIRwDo/PMXPeGrw/BHXctAQW02LwLY/N/hPpqZuEfNVVkmgBqGddjE8yfGjK8Cr4ZFvo0nl0Y6EXl6vshNUc3aa50wj5
 SFCDHMTQ
 V9Vg7dyTTO76vq29hq3P4KCZRh4/Kgtc4lvCV5mmY5nmrfMfXTzyJvzPZAg4wl7Lc/SOjMAWOTQIwwFIXgp+h5DJvXEelxNsGN2HjmpLqs/UIwR3q9Fz5mc6n99TQoT6WF5RfxuRFpJeNOxw6AlywxmE+W9NRh42/VeKmh9IhrDJ7GW0H6OJMB2qMMFs9+S/zLhT23cX9UyHIb+YQsFM4GeSkSxgA/97xa42Y5dIT99qf9SBB1vo60PgwbQyIxzsIbRQASeIMSGGy8mMyrcvnGFctzh39NymIPUtgoEaOoDvOvf2ewOdxHvertGJoHBMAEyFJCo6JrvuVpfxCJVuKOy4YGeAStZK/oIgME54aMIqY3CR4DpZlUJhNSZ2grUGQq5itf/YHV1g4WbUcA8hK7Ls2nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 11:58=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> After commit 2fd4e7693674 ("mm: fix incorrect vm_flags usage when checkin=
g
> allowable orders for tmpfs"), hugepage_madvise() no longer calls any
> khugepaged related functions and only updates the VMA flags. So remove th=
is
> helper and update the VMA flags directly in madvise_update_vma(), which
> simplifies the code.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

