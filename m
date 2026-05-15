Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEA9FCD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 22:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC2F6B0005; Fri, 15 May 2026 18:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045076B008A; Fri, 15 May 2026 18:18:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E515C6B008C; Fri, 15 May 2026 18:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF1A26B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:18:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74325A0252
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:18:57 +0000 (UTC)
X-FDA: 84771070314.03.26C0626
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 681EE1A0004
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:18:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GTicYoCI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778883535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLOP4eZBjEsFOJKb2AlLdYmcbjxfM6qIcB/R7/H5A5s=;
	b=63tk/Qsn4D2gtjpwC169HUAQeXBy5TD6HuBF6P0lZzIYt+J59URNNk+tBeslSRJ4EWQuNu
	yduVql9/JqbngUEzL7mDfttYYunbNKYOFhepINTkax3Bq61MtPdZ4FCyWb4l+Mr1XwLCpV
	2OmXxPJu1oEEPmFC1XGo7Wsw9fP9arg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778883535; a=rsa-sha256;
	cv=none;
	b=czFk8DYyEbubQB+bLjYSpjwIljFT0KmBBfgt+Kp/q9lxf1aXCYdd4+9kB1x1ewLbAOgcC7
	mrmtCZ32No8PHnvuz2IfctwlTF6QkbJn11jQgirp+B/wWTaYPwf+RhyCML5IGzOy1+VhMz
	XhYF4e/O/GU/wWNVt/f2wTaH28sNTAc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GTicYoCI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2ADA6445B4
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020D7C2BCB0
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778883534;
	bh=1MhrEcqiffOJJ9gu4tKqW5/j2FFYBdwL8v/OjHOXbE8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GTicYoCI2yr2rAe/AMU6ocS3i7LeGzP+5ynLWd/haZ7OK8z5QsL08GhRu4vI6vNmU
	 /3SJUN65uYsO6Z6W57GiFhyamzuFs+17wJ2EPj9kxjsYdcXZy+4OY7C4TydzVuwIdP
	 cqcIdDzhU29K9Oe1AlyD+O5jJc4jbWA6EeBEkcwAcnD95DXjA85X87gsLYpVZ0Vl+v
	 s9ouykehmJF23xqYyIAgLfZ+jgPUx5hix68bt162AGCCbP31GBjIV+8LsNDU1NS6dl
	 g1UnI8kJdJjySSQvW8vM9rhm8ucv7sproY87J44pKcG2J+gIOgiTGJhOMkBLiDtpqr
	 b/+lLlGeQOBKw==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-65e170f1ca5so746124d50.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 15:18:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/14a0iFOvGjhRspv+yfP16MwspQzbfia1aAd2nMFdYwraOhWIpx3IdmjYZddU0MK39dALl8E1gQA==@kvack.org
X-Gm-Message-State: AOJu0YztwcW07TsBsjqAUItMho8YVRigRnzQUC4o/PbVZJ2GgHcBDIVN
	qlonu4U9gYUkNkH/1tfqADuIt+0VsWNXJYddmvEWOBtQ7+wjmZkDNNjm6tyToq+YgLEbubfxloR
	IHf0H1qe2yiIqnKbZhqTWW+M7aEdTG3WGnc9ljUzsAg==
X-Received: by 2002:a05:690e:2513:20b0:651:cd15:8c67 with SMTP id
 956f58d0204a3-65e226e2fb9mr5283044d50.15.1778883533149; Fri, 15 May 2026
 15:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-6-hch@lst.de>
In-Reply-To: <20260512053625.2950900-6-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:18:42 -0700
X-Gmail-Original-Message-ID: <CACePvbUpuNF9VsFUnmGpSwA9mHERG9fAxqezO=gdLzU99gpEdw@mail.gmail.com>
X-Gm-Features: AVHnY4IEAMD4CIhbQwbpq5_x4qZkKrPnDwnZZ2hkgP66BNy2UiBnbzLNgfCVsSA
Message-ID: <CACePvbUpuNF9VsFUnmGpSwA9mHERG9fAxqezO=gdLzU99gpEdw@mail.gmail.com>
Subject: Re: [PATCH 05/12] swap: cleanup setup_swap_extents
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 681EE1A0004
X-Stat-Signature: 56517wgpff98mr3fhsxwtsemoz14d8y9
X-Rspam-User: 
X-HE-Tag: 1778883535-672050
X-HE-Meta: U2FsdGVkX19TMOsnTwNvWohtbXiUcd00uxqsy0juBxIFJxKO4YIHFtIpfb0tG6FU14WApB/XR6XFGSnzU70e3SUs1m2Xx8VaEnnsBeSejvlXGsZyQzGwjj0J5jRLnAakKeRqznTddKMPTTDMspwv6/XK2vQh4dMrv0X4nRCH4Pq1HbkMqyl79B8CANUHhi64Yz4IYIwMpWwqqZhgnEY8prgB2WdTPzZbIk8X3MmmvR/i4pcig76Zvqt0u8H3Aw5vRptiE8hFu+OBgaG8R7BsifuZmxj6zTp5V6jZPFXPnMqLqU7qx3Dzyrx6YnZB0wy4bN15+Yc9Dd75MPJ66H2aUzHj7eweGSV/W03leWnyyKq5IoGdnxKcTN75C7ravJ2JY+RxY4K6d3cL3cnkLQOh6TEHOSLXWNSkyklCaUvq6kDocXmlLOu1nPVXdYyp2wUMGH6es71gL55IKhdlZdHeiEmLKRm+1JzdjV++GBX3ILUSMzUpMBl2WCpeSbn50fJifdx1XYJcYPd62fgjWpN5DsFjfHFpZ113JrPfXuMBnj25kSnDKfjv0lr1appRFVx5HpRwuiC7cRRzBDok+AZxiez26Fe3XWv7/88zO6YCrH/QzI6Q4++LCalBNAtJKos/liwfSWDc6ZK+E5ARiX6CQ4QQ3HfW7yV/owNxU2mMSSWZnl2DPQ16PHQunqJAdByLL3EG+SCzhNKsMDJEl7TaJiCxY/x5eVUlwxNsAiXLtX4i7aUEuDnRyVN2dMe5mEk4UBRZaJk4qergIkC1IDqeBwpW5LWM1Q2H+VPZa7VHc8SleiJdvgNGdKUF53sXl/GwhDDQ1qRqTZtzKFPZhcHMPlRt9ftmZ5wZFtoHtox3R71LBkGyUAmbPAtxNbN8YtugpG/VKqqmTQAPrToCWlG/V46HPtJIP4Sde1ElGOkpoAk6IP1UcabwrMs02oWWZ3BfnScNG2B4Yt27XeuALRf
 JDSyNo0/
 e+hPkS5FVF5PyO9GtpCrNXDLuJ1gxRe01y6QL+1JsUs9VD8p40pYlKcSzUrN/5KyPI1Y+58H1OpgLB1XDwbkQ2JUlvi329hdFZmfXQd4vGIF+v5t3j7tj+6iZU9NjepzD1Clby5CJKVg4ABrom5pxDbud6gIH8eel/uGc7CoyRla8s1IczuKAT6cnBMUyxXITaoLEQkg4yN4GWcu3xTWXBG9gzJH+v3/b2pGrJIb5XE0skW9VVZ/viMaDFRL7zTlBSw8BzwZU39HmCe6iC0+/hA7lmyuRYx/TbIejb/2OQplkze+cDXboGRWPGNVgELP06kXB6URbTM4MqAYJ6fLWLQTu63LXKjFKKv2wNtz4Llg+Hl9g1MFzZWcCiLYQS1WO5FglbE8zHrkasXIAhdlWvqwhpeF2nU+Xfv/6VDn9GDk9yLHYmr/z7WL7EePT1sR+IXiA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:37=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Reflow setup_swap_extents so that the flag checking is not conditional on
> a swap_activate method.  This is currently a no-op because the swapoff
> code still checks the presence of a swap_deactivate method, but it
> simplifies adding a new check, and also makes the SWP_ACTIVATED flag
> more consistent.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

