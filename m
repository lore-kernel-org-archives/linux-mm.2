Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A6F8E8304A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 04:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5860A6B0005; Mon,  2 Feb 2026 23:18:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53CAC6B0088; Mon,  2 Feb 2026 23:18:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466296B0089; Mon,  2 Feb 2026 23:18:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 341586B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 23:18:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7FCF586D4
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 04:18:58 +0000 (UTC)
X-FDA: 84401839956.19.C868C85
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id C26DE100005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 04:18:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WCMqgmbW;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770092337; a=rsa-sha256;
	cv=none;
	b=dfLea9RBiuvvHQ7lw2ZcJtWjHl/oP3iR/Cb7wkb8XzXMqOM2YZjAsHcGHtCKMRXeGzBvMn
	/tR0GY5x0VS9iGPxI+44qyfMwBzjeIZkLDEKR1QwJOrlTC7Rn9XovVVCu4g5bjd9daQht+
	FDazSo5sI2VBIBX8e8bwQOnhWh26Ux0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WCMqgmbW;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770092337;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j1EC3qmx1utMyRmMhZAixXk0veYGDBA20z6LB+wdtE4=;
	b=ilENowQ+AaHeolZy+Aj6tMXJQiPuUPZhPb+avKgbnb9RUEVet5ooJlOt/7B+wUpRZ7+dpw
	4+0P7WD/IHVOFrsGAEZ64NjwIghqCpG5J0H22yRp5kStm3t1Q8a42R61f+cvQDRBWNpaXL
	O8kxQF60nW2/6BhBGhX+3wz3SlThtvY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j1EC3qmx1utMyRmMhZAixXk0veYGDBA20z6LB+wdtE4=; b=WCMqgmbWqBWHiuofigjqa/ucVy
	ICoza4SxJDvdD4jHCsxn1SlzA2Ffir47CN3Nt52ORO7RiNenS2oGFwjHn2icg43T1p8/t2j2SYexR
	7NJxdDz1D982a6S6lkbg1PgJEBmGw1j4h8+tkp5KPsZ5utK5f1XKgYBIc6IzgDxrx2oRSyM2Tn0/k
	SZgl1PVIJQA982nsBr9/eIfEVm/R/U5y30DCKvDdnnqe3laT5b5F3ZJkCEm40rcQboVKPfydeKbfz
	5Kfp+Yhx7/0ebFJ/OI/byBgJNpc6UtwOwgtkT4r+OtRJ3jS1dQid3cxImNr9vDgD5Ji7PnezXZvpU
	zNvBO7kQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vn7uG-0000000EktT-1dlK;
	Tue, 03 Feb 2026 04:20:52 +0000
Date: Tue, 3 Feb 2026 04:20:52 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	hughd@google.com, linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] symlink length caching
Message-ID: <20260203042052.GE3183987@ZenIV>
References: <20241120112037.822078-1-mjguzik@gmail.com>
 <20241121-blatt-akkubetrieben-ad5d655d184a@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121-blatt-akkubetrieben-ad5d655d184a@brauner>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C26DE100005
X-Stat-Signature: dam7bui4675zeiaaxno9nzocsghsud69
X-HE-Tag: 1770092336-276501
X-HE-Meta: U2FsdGVkX1/Nri4zStoLAlYq2/rxHekw8Jw9DwCwPXtLOdZmoxC8E95fVffAxrRgmhLu002hxiJrJY2hBEbkn40j3Ws4wZ8UFJFRq3bq+tiKBx0BBufXkDrctlq6mzZKdO/T4BDiAepeiI/R1BTUm0jdT+HVkjzEthk7hWWr0SsjEAhbFZ8EIg/VrRzX2RxFbtvEmjaSUONYWdA1Wuc6rdcfK1xlWIUETKDRtuXqvSaNvNxAswulMRpyRCMqDA/wb/m7EecnU3l34Sl/PJLGC/c2voDY/J+ZQKtEBhd+Uf0pUXSWRjby+6BRsXOmQ+YvfiWpLOM2ALcACSoAiYaVeahjuptvsc3jWFrMyPb1L5+t5XeUB07lJTnnSTHQcxrN2bkNMqZJXnVsoMxazFcvNxBbxYXPKY+rhtsDohEhApEYLqwIbIXxbl3LAe9c01X1ekrPkzVH69CngPEkfCfb4/cnMu2HqTbswD8cVv4SJFcnEEt4Z5sKSGGy6AzPUFjLXx5o51bojIJX4m3uL7fHOR2y20uAgFkRcidUe9VClrw8VyjHoWPacQFrUT/3g5LddVPYzzCHxCXYexFu24/566jrtQAlDoKMZ1UUfh/xZAK2ZRT0G48e+khLgGIhwjEv46FfisaEr28HKvpEB2cDFNqbbGgvNqHxoSCyeBMyS8KFobsiauvETtHISer8wjNUhxJyivLOCM6TZeJCIE5EJCEqDxVWXm3HWH5G250REfl+afZLJYAntLBxShGUes6S31lcJKcPd6vbb4vUqAAwHYCmO6k9s+hjVIHkr7Zn59bucILsyjcr66SvxSyiydlGZ9nH/esSqFWN8GPspd9Nawsmr4Op9qE8ukR6E3UKnSXGdys57oLGgk0LIP6qFOqA7m4twhi/+WdjpLI07c4CZ4gsZV4NNYTkYqyVkab074Z3R+sHZYjCUJSycN27i1ObUMjKkpFoMRlZpycq+cA
 CHW54JZb
 xMOkReWx8pRB11FNc5FU3F7R0AgHdMWPAsD1uKP1CPI1xS8kLekYZ20MwEjhFMY1i3gxtZVx3mtJsjsa1YO7CE4q3mO0PtOH2OgBBaGRKhPcrrHor2YCg744A5oucq+HWMT+Rw6Hvb5w4NEehUI/WxDh5F+e03Tk7ByQ1leOF40U8uJbF8VYYz1859G//BgfxNytCkfRMs+6iD1vKRLyvcJZxu1+FwwUoHEAKxa1ucMrXKgDYJ4uoHrMKEwuiA/rWj3mMJ+zUveDs1GW3Rnvz32bswdreHwyVEhmUNm4Zcd06Q4Gm3ks+GGG23sRwzRTlZVRyyBMvsxX4yDTLb75Ugv5R0+qNxq222eUCq+C0eyVVnFeWTluegGQVdDnk0rddBtSWLRU1Hwgeo/YS9M5Z+o+3VlwZEe7yrIKlV1X4RhGZZ3rb9yzSXHmtAooudGehyIaniDGx6G4hsVM7xEMa7+j2dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 21, 2024 at 01:34:44PM +0100, Christian Brauner wrote:

> [1/3] vfs: support caching symlink lengths in inodes
>       https://git.kernel.org/vfs/vfs/c/5cbb3c7e0051
> [2/3] ext4: use inode_set_cached_link()
>       https://git.kernel.org/vfs/vfs/c/740456f67017
> [3/3] tmpfs: use inode_set_cached_link()
>       https://git.kernel.org/vfs/vfs/c/30071e02c163

_Very_ belated note: that needs D/f/porting.rst chunk that would cover
readlink_copy() calling conventions change.

