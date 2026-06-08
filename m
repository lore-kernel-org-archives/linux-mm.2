Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF13CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E136B0093; Mon,  8 Jun 2026 08:02:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004DB6B0095; Mon,  8 Jun 2026 08:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D946B0096; Mon,  8 Jun 2026 08:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D69F46B0093
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:02:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D53D93A53
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:02:09 +0000 (UTC)
X-FDA: 84856607178.12.F812B3A
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 576EF18001C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:02:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="EVXy/le3";
	spf=pass (imf06.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780920127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJaMwlHdD5ukSuw9Ddmz9W921lhUeR/xfWp0HtFNkEA=;
	b=VK4rbrp2c7rjw15HjZSHuHAWHZRc/9QJCwrCvecqiXglJ178V3SGQFQZWjB4RkRrzewjXH
	YJ+QOx1hhAq19OziPuGHKrnoW2QcUQs9pD5dZ1BOuGuKHH4YPVyKFiit8ln/KwgMwCgRt2
	t1Z2SnkM57HcbBoqamTUex5nY97eeCg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780920127;
	b=KhlZRWw4oT369XjLqldBhBJsSZWpp2Zv/ouzsg98mU0MXw4wBQ9m9uQt8IlA8Z+OY3UQxD
	pFZTC4uhcv6As2B9lE9KoSDEWC8K8MRxdmaKRp5OghGgKu9eNg4L/1ESeAugeCaoLEua7I
	8Kl3mVBztIBEd1+cENPfjEYXVPYiEAM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="EVXy/le3";
	spf=pass (imf06.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2bf22c18ad3so374315ad.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 05:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780920126; x=1781524926; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tJaMwlHdD5ukSuw9Ddmz9W921lhUeR/xfWp0HtFNkEA=;
        b=EVXy/le32pTaVqDlJGQ95R5/be/3LNALz6l0jq7OUkqfyoLZVrjGiHOrsHaIGp89AH
         3geFvuDLSGU/yjhmvqougg1W5HeXjTbb1TuxAyfhQlwq1pvNfuMeWjxbWCKVBvdqKNnP
         RpAqq0XlhItNuO6qXED8eblkSEL0AQlLFZsVoxFtuWIx6P5bv65NvbVFsT6Ik4aQjIA9
         geMeg0o8qPGxGaiHh30T+P/SBeWY6FYBszW2tkgXERxKp8KV3eEPVa/HFPZ8d4icKsDl
         RSyTjqwiEw39GTo0yK3MSrr/woyqKIpMFSbHc0I63UuSLclTjf2Bo4yKGc/X9jvStj82
         aq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780920126; x=1781524926;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tJaMwlHdD5ukSuw9Ddmz9W921lhUeR/xfWp0HtFNkEA=;
        b=AJXYE2sRt8plGBrreB3g8vl3ZsrUp34Um34YmXHDtE0FKPzpv3GmSS7xIA3ZdpjEqe
         uUbBOl0KG2dZAIHPwKB6XKAnmXmVzOXpSvychWgFiyCtlNp02MxVc2xcGWZvxa4WaxGv
         0/p4/OisSzcmhkJyJGmuz3vFClP4Ovhvsp0Z2xQP9cOIUyNfUaT+s7zV3ce/c0+Xqt8i
         D5y2QVjSTiX349J7cg+0WnVWs3eLOcVnxowHByEzOy8BxXP7oWoJBxm2Xd+uQ5WRQvXa
         sxCvMPvO48RHsk9C+4Wn0MGTJCdlp97GqPbispZmIn/Dje4NETyFpzj211G7sGXpMRO5
         t/8g==
X-Forwarded-Encrypted: i=1; AFNElJ8N5uUTuP0Rn7GM56m3Gdy5n+B//wSASTEIhmsBGxLPrvvV0Z7SE8gJypcsLDZzdQY6s6vNCelRMA==@kvack.org
X-Gm-Message-State: AOJu0YwPlPKWWEKVuGupQKzHNaP9lubE/vQS2PKsv8pdG2ns2Dv/3nvq
	KB2QtQ0lYdDvMnGP2rQ/vGll4mpYv9ouIXPNCS8adNRyWdooGRiHF1wtJKG5z4Ls7A==
X-Gm-Gg: Acq92OFX9hVLckOkmJ5PY0HvTKtj9/uWzaga1aqync9PuIV2n8A1atyFEIruhpEN61L
	mH4jG18lpBaPBMPSxpYsS43eIaji2YQh6CJTtzG0CDRfKZ9kQWuSX0P5+ceyInoXgO4HvWjQwUg
	rygj0gnD/c2fq54aEQ8tEiE3nnMzM0v7noVpmLenEnwTzAzVf1aSx2dH6R3CjuSFfkEusAwE4BO
	rdTGPvn4SbFEW8t8ScqJdmsj/fBXey7Q3tfV1hUMUqZR1iKpms9hJlPmAnd+3va8RnLvD1YVFZj
	DNb3XqGNjDFc5Y/s7tI6jrbd1mNY/PiKbdChYGVwYuat++Ebu0oS9itYHZIahfEwbDA6IxmP8NE
	F5/S5JrV9QgEE5xQ1+lEYBG1FztccIr/Zm03P4TZYQH8pa069Il7QtpsOHK4KRZeC60uWRBNX4Y
	Gwrok3fzeFmvXqRtCckIp816olse3KoQSYxXAni2n0jsulmt3qDWDYKeWS6HYtDPAUSR0ujBUTp
	3sz5PWAlA==
X-Received: by 2002:a17:903:ac6:b0:2b0:aee4:afe7 with SMTP id d9443c01a7336-2c1eb1dbf25mr5272565ad.10.1780920124143;
        Mon, 08 Jun 2026 05:02:04 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f85de1sm180971895ad.20.2026.06.08.05.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 05:02:03 -0700 (PDT)
Date: Mon, 8 Jun 2026 12:01:55 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 12/12] Documentation: PCI: Add documentation for Live
 Update
Message-ID: <aiavM2JWPds-mEfD@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-13-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-13-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 576EF18001C
X-Stat-Signature: gjuc7dmcksfxphsce7c3inafhx15hxj1
X-HE-Tag: 1780920127-264946
X-HE-Meta: U2FsdGVkX18FcldqkosqhrFjF/5EiU9dyyJoGiUPbBms2Eybz3OUdBB6QJ1xADQwe/UHSHQdGih0RswfzvNySsdiqJMo+7ij+ct1rq6BbWAdF8IQwGye7XJ+Scb8PDvG0MvdvYjGk7YO6gC34o6dix9UHEtEOhI9zUDc50cXIMijcuK0H8wX/H6UQEkiVpqYH+d+cRYeImgd5kTpCPN5CAgNIK0Ixsni8ncP+jp67nMVjY+In27Zv72j6tFjnmjRMLVMiR6Li99RGtP96HfmIHwjPDXxeu/yuhDrzql8cLZF8OpHfrID+BVpNNEhQOQzIeIkpwu3y/eJwVoKdk+TAxjSQt3ey2uInZUgMYhTImhsQ7csH21EfQk2SfGHeRqGfdjMTbIffn0MRYzhn6/HNjqreVNSqliEvVrKs1eWKY8XT8XZg5XJP++WXEM7/bXT3AUPBtAQRXYi6H7pQjC/lh/xhFNJxsZxrVWRleTBJrJThpepWe/5tTX7Md3SXij7PcdgaQsan07tK6nsxP90o97sudSTCZ+0mUvwnzvMVk6Al8N7E7MsShOGHsjzb+dCpAoFLCD3KBYpk+ktnxLX6Sl1ZzoiwSXV3yWevK+g9KGkrMOhy6oPdVOzRDZaztWG5u99vyVtyAgr9Rl7tDzrydHL+PKUGjvHIdmdsjkcQaZg5P3hHfdpglUjWvO7tR0dsbSoXnD27p9DIaLgMrzDeOiEfyoL+iW/OvqLMoRUSK6FVE3QF9puasKDWQL4+iXCjacnHjjjvxm5keyQVgJ9UpdkyVphd+kmLv5GaHdapVU7ZMMTQMwqaDll37Hnk9RwwT9U6dDMPQdGiRe31kQl/r1gCu4ZBHMp/YTn8mYvid7Ff0nII/04tyq1fRfe0IQbU1/9z4H1lCZHVq6LiR/I0jFqesQ7VV38SZjTvpLFi+iU9Z0wjp0T2AI/U3h5JQQSqWuaVdBJdkFt87OnZW2
 kRxXgljF
 tzRPvdm1emLONxv0PjSnRFUJ8DmhAgZuTtnRBqtm6JzS+3KdLP6FXkGxth144nBUNdP4a6Y7m48/2nnynQ27kKClJA6Usx3KY6pAAca6Q7zWHjQ/QSG4P5QwMCzYynr/OGc1kwDerz2P9c3Pw+rRJhmIN1OX3Tn7leH+im0TJEkBp13QJD0MtSC+EsfWaDndM/FhAI8vZW4pE44AusCNjyo+I6URFKC9laXHN6bbfWUjVPZT2fhbeZDpw4XZqV4StL8uxSkk3Zo2fiHHbeoDKdURN1KWIBejjOoLWo8f9eSdfVCtYijpld7UADJTHe6X4tcJ59DtNSqRHkd4qISRKUdt00rpV8Ep2ZOPp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:10PM +0000, David Matlack wrote:
> Add documentation files for the PCI subsystem's participation in Live
> Update.
> 
> These documentation files are generated from the kernel-doc comments
> in the PCI Live Update source code. They describe the File-Lifecycle
> Bound (FLB) API, the device tracking API, and the specific policies
> applied to preserved devices (such as bus number inheritance and bus
> mastering preservation).
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  Documentation/PCI/index.rst           |  1 +
>  Documentation/PCI/liveupdate.rst      | 29 +++++++++++++++++++++++++++
>  Documentation/core-api/liveupdate.rst |  1 +
>  MAINTAINERS                           |  1 +
>  4 files changed, 32 insertions(+)

The kernel-doc directives seem to be wired up properly, along with 
formatting/indentation while keeping MAINTAINERS in sync in the same go.

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

