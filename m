Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA583C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 12:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8AD6B0095; Thu, 17 Sep 2026 08:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9CD6B0096; Thu, 17 Sep 2026 08:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398C16B0098; Thu, 17 Sep 2026 08:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09CCE6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:29:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 460E6A02DF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:29:43 +0000 (UTC)
X-FDA: 85223185446.06.0516F18
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5B6EEC000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:29:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NC9bDN2L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789648181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dtz+Uqi8FvhezfQGwgUreP+CufNocr9p+NqbDN0Xcok=;
	b=IDUDvLNf8osJIt/2V7D+45Kte2yEPSSlK+iGKnimXL0BXSys5vYyV0x9pkTTEWH0hwlNOj
	tencZ9cUpX84RcbYbF83swl2Vx+5lENuz6wjj55os9uVjnd1snj/f9HxMi81XWQHgtYU9o
	TbYU9k/LUz4dpY6GZeFnyxe8obn4jv0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789648181;
	b=F/VdiRRL/93hsJtt+2JG3X+P0FyR1GSOhkvxQMXwOWwQjJssZN8e9HQz9H7UEmjxxMILRC
	tJyJkkfcj1rJ8GtopdEhFVpTQhthi2Fs3qkfRhCa3AYQ8BMXx9seAkB8zMMr65lbCpCjXA
	pVVLolksgfErXcy5NC0BFAVviY0eLSw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NC9bDN2L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd5462b69so4683615e9.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789648180; x=1790252980; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Dtz+Uqi8FvhezfQGwgUreP+CufNocr9p+NqbDN0Xcok=;
        b=NC9bDN2LrAh9EpHxe/iXiLUWI1ElK/a1TRkXg/mCjZl6vdUOX5x8e9zKTbROBBiihw
         kvMGCvGhwYiARkUQjnFMjqdWHZCfYgHRrCYpsAcn2jGtbjuWJbiTQ9soNN+aYHDWd9ql
         WXS+bRX0X79J0AC3ona0FaPXwb7aGLh8LDojBUR3HAdsWzkqCYTQIvEcbU3dKwRaohr3
         a7BECGBRU5A6z7hW1NdIOuYY536HWPCFHEMClcALBv/o2A4jcMHeZxY2z5aYAKVL4loB
         yqC4d6XJJLghtecaWE2Ub5G/knfRP/VrxBx2K0uP5QkbKhsfpTdJkhkDmxHYiEB5FsHZ
         S9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789648180; x=1790252980;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dtz+Uqi8FvhezfQGwgUreP+CufNocr9p+NqbDN0Xcok=;
        b=nmRxGp35YJrbIMtB2nR2AU69BiI91e8O8hWrVdRvLH7i0rTYg78vA6612ovz6rcae3
         XafZar6g+TEfVSj0FmivBFka6eQb0/WfMJpvje5MPXEE4NNu53j1c1DxOk9jwE3UlYNy
         hG0ZPx/NQ3qZgNVPyymsn7gjtSuX1IGKSww60AN2m5Gql1+hzWzc3QgCGBXrp2ZZXdfy
         Btp2mCnPBYsUDZXgCYZ9koIqL0Gw1Kj9LXY3pod2anRPlLQcTKEg0qPQ6FuYZTBAoF/7
         Q3eDJg7VBbyRKdDmRYpWiP6/Wa7KEBFaO7RbbElbDdUzWaOfTQcE1eztpF5EYJO3AG7m
         KwzA==
X-Forwarded-Encrypted: i=1; AKwUvBw/N5jzMxOw3UCjbo4gCRw8jZTvzLIfwB5uixDalrcCrfBVo4OzV1rKz9M3ez7paMMCt1eQdhHbgg==@kvack.org
X-Gm-Message-State: AFuF++mL7GaeP4I1p1ELs4p3mtp51Aqn5P/76FD+XEDdQ9iNa5gUhOgv
	ql9x3BSYbLXoBDfHYYlzz2Kg3Du7niQSyTK4P0eZckwtSuIanc9JqEUc
X-Gm-Gg: AYBFou0DxNFs4wZPzWNMimc1yuhsU52WFdyfIoksKXuKcQ+JjlHMotJM4NIfaDP9X52
	20kuiRp/YzFiIhkkle2pzH4ULiYMFdFSh0VRgMhgCcDwer6uAxY8xOl3xcEAhhl0n2BXPzaMebJ
	XuDKad08qlE1CIug/JaYQ26KPu+X7Y/GwWUG3KC4aPb4JiGvnfWDx3jMYYOCIjr175RWQS6TpCf
	ome3jnH+bkJshrG9OGZSzJlIsm8HeCRd+fyCfjolJIB1esE1sLWq1luMRQoXdltpfGkjdpNrlD9
	53H8ObXUXhs4A7o9VCUv8/f8oPB4oOQzKoSgbzcgOPoF3HrZD8jLNiqrarXn8UkV3c88XA/o6Ds
	MgS4ov6NjMu4vvLqpotPczbi5FBlQ5b4QOG4TQlDd9KNZnH8GJzBwPRTu2+KOT/M6r3TFxfQaEF
	HgZfju6j3irQVruYNnIG2CX1d7nJgWL6f5zhXqmHlydBybOumOyRbTzk+czkdreiE1+nMkpUTxp
	NvSvn9wF1aI69VyGNU8/Bn81YLNymCbaaWe
X-Received: by 2002:a7b:c35a:0:b0:49f:bcb7:8e9 with SMTP id 5b1f17b1804b1-49fbcb70a1bmr64001725e9.9.1789648179633;
        Thu, 17 Sep 2026 05:29:39 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd1ce79csm82621135e9.0.2026.09.17.05.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 05:29:39 -0700 (PDT)
Date: Thu, 17 Sep 2026 13:29:37 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linuxppc-dev@lists.ozlabs.org,
 linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-media@vger.kernel.org, wine-devel@list.winehq.org,
 linux-xfs@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org,
 linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] file: make struct fd_prepare const and kill its err
 field
Message-ID: <20260917132937.5a15904e@pumpkin>
In-Reply-To: <20260917-work-file-fd_prepare-v1-4-b87534ca49f3@kernel.org>
References: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
	<20260917-work-file-fd_prepare-v1-4-b87534ca49f3@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5B6EEC000B
X-Stat-Signature: stdwicztm7y9cenppf56ai6i9wcjihwz
X-HE-Tag: 1789648181-168695
X-HE-Meta: U2FsdGVkX1/J43f1fVQTrlJmQIr1uTwTtzPFE2kMFtawMxe233GXa0gcrqjsZ1mf7cBkcqAVcyvL35bsXK4zSFIyUNV62sbbdUXeWgOhdd2Z9YjF+Sy00m3MBi1wbRDjZgMvWrF3iK/u2qvkx4RvXDIzp2rsSyPy9e04392LC88Sn607+phbyBq/gvzeZ0CWEWPOsIvO1c2vrwriZtcNEdxJblZ2IoOIRwraFxrJKusibJkAthDsj9QfN3J9b2LBSgl9nR2R43DYGmtbBVbgSeSaKas/EZerXrk5qtQfvQZ33Bz2W6mif2U0FthFDNVjL6C8kfSiUH1EhAO9exIaFpbksjb0BZYudwggmG2tqo2nrKQaioiZ9582pPMNsV4DNtHQXbCt6u1NmRezi8eZbe54OZ65wzrzenP1alhD2PsgpiRgesA2taSH/UzXHA48Bcs8Y0OKhfD+mIGIBlrvsnZBeTzbvl40uD971P11mr3EdJenlExba3yENGeveG7HreSOYuQDDcMnnWAS7pJ+mrHiZuWUkRyDQAdYXoFHeL1+Lu/C0/LA8J52oJwVUDtIYS+ebnkvOQY03dMXhVC/Gb2ZEZei+pPVL6VtfmFoW5oAyO/irDCtFxEe+CQfsAMf6o2WWBYqN0PfXeMWPi0qD3G1nf7rw2ksThGciqeUdRXx0z6+tcoWQdP+jtvP+o+iGaXbAeWp0S+VH8ApdW5eEyEK1BYvBKrjOBcQqbXPVfUFrPKpFXv3BkBSsabSpoM8PR6cL8hDEwAGQrE7bckBvpIlq2PFjdl3zZiy4fA0kO8tEL+4ol1lRetvdSa4ZsnPQr6OHEusndw0quEJXMgNzRzWtdwyZmwOu6laxy8/6P0W5NdM+kROiFLqz+3BJciPT3iCqd1W36osM3QH1CXsfEMpHCbsJ9ZDVHIdHA4EvdVcP/udOg49sTmAQ5APoeMTd/aQwtMWGavlbIDVxJW
 VD3R19NS
 ub2fOHo9rlLy+HMXnKA7lgDMj4CmpkrgMmaNAHnQJzZ2vSzP0Etried584XBZr8ZP0SRCp9S27FxmULIELhnt35VPZ/s7bgF8nDHFBrIJN4vI9ar6sYS0FOBZTSR6ADGtT86WtbL8/y5x5ypZHt37RzpooDE2LeuuRlWsWmHbJO2hIE81QnYIkh6UWucHSFsxPbJBhbhRR9kcmlr97HRMPc2/vb5/o4UmTQcgkhQDOQFVtACift3XD8THkmTadv7LmVhpgoney6ip9wnxjTWh3MOdNkUvxDEvB6LNl84NoY26aCZ4fp5g8+Xo4y7fY/A5NJpnCs9J41YGG6y/13VhYOZfD6Z4L97Pl2H7R3SylICjeRhvU+QuL5PbOl64uJL98iA2C+0ib/DJDuR/q/dHxW56oETZBDiVdhz9xjYoH8XZuaBxWWHfKTkanysMKivFwipeNh5p1OjFP7eOQPNpjHPkXxNO75IEqPxR488MOEVKI1VVOxFthZU1fOp/4uZiM9pJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 11:09:45 +0200
Christian Brauner <brauner@kernel.org> wrote:

> FD_PREPARE() releases the fd as soon as the file expression fails. The
> fd either holds the descriptor or the error. The separate field is
> redundant. Make fd and file plain members and struct fd_prepare simpler.
> 
> Callers of FD_PREPARE() get a const pointer to the guard. Simplify all
> users as they can now easily access the trivial struct.
> 
...
> @@ -191,35 +175,39 @@ static __always_inline struct fd_prepare __fd_prepare(int fd, struct file *file)
>   * was allocated. If fd_publish() was called the fd and file are
>   * published and cleanup becomes a nop.
>   *
> - * @_fdf: name of struct fd_prepare variable to define
> + * @_fdf: name of the const struct fd_prepare pointer to define
>   * @_fd_flags: flags for get_unused_fd_flags()
>   * @_file_owned: struct file to take ownership of (can be expression)
>   */
> -#define FD_PREPARE(_fdf, _fd_flags, _file_owned)			\
> -	struct fd_prepare _fdf __cleanup(__fd_prepare_cleanup) = ({	\
> +#define __FD_PREPARE(_guard, _fdf, _fd_flags, _file_owned)		\
> +	struct fd_prepare _guard __cleanup(__fd_prepare_cleanup) = ({	\
>  		int __fd = get_unused_fd_flags(_fd_flags);		\
>  		__fd_prepare(__fd, __fd < 0 ? NULL : (_file_owned));	\
> -	})
> +	});								\
> +	const struct fd_prepare *const _fdf = &_guard

Since the struct is only written by its initialiser, can't it just
be 'const' ?

David

