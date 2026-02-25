Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 331E9FD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715AE6B0005; Wed, 25 Feb 2026 11:39:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6993B6B0089; Wed, 25 Feb 2026 11:39:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57ACB6B008A; Wed, 25 Feb 2026 11:39:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41F386B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:39:31 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 037931C785
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:39:30 +0000 (UTC)
X-FDA: 84483539742.06.77F3AF9
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 03AA3180013
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:39:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ZhWe/z4O";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772037569; a=rsa-sha256;
	cv=pass;
	b=1b37/FjeTmP59w1ny3JKiXf7d9dA4GS/BrDVSydWQd9qmf23i4hpgESamuMWqLz0Ka54Bw
	08MXgp2CY1ZIhJ4YUCF5Y1wvpRqETC7cwqP5ljUDzjCFJMCkPMSQxFCZwW0pXG8WLStmbW
	4gw0XmGOTTJTz/fcocWAwLyLA8k5VA0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ZhWe/z4O";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4W+mID6rGcwwYv2MZsQaafxA3kclLpdCcSftlv9Bd4A=;
	b=LvraKKxp5MwF1qDNVyRMZ+5pUfGCJuqUvtbog5O/p62xV3+6l/ph57TpFYyWO8T/AjX6E9
	Icuiv2WnT4vSQdHZUK3QYNeO9SfB5or72wuEfkYpC4n/GNkmdHlbhM9c5jKDUq0mBz457V
	dan8A+gYpxk5xCvCyBX9eGjg8BZhQQw=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5069a785ed2so757301cf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:39:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772037568; cv=none;
        d=google.com; s=arc-20240605;
        b=TCoBcjS2cgJ57a6FjEN8/6vmD3OfLoqKfF/mzKA65644x47VS7KPgmw82f6GS404VJ
         zGkjn2gbLk6EFnuGTslbqYa6KFTFSTKOQzkqy/i4LSZtwBhGLVSieh6Y8seX0DGNWvDL
         0mv/Xe38aM6OFS8GeJqN84uYYIHplPIwxRBlgzsDlyjoWP/VR1g2k6K3R7UgjbIa8x0j
         4O8QkeNLCVcPeFGjXa+NMHfoty9lqLXRdU4EqrfNAP4I+GyoKuhuK0SmxyKAtDOQvbyF
         sJ9pp9Hx7msRCi3z0iDKCRFG9Iy8ZKP7ymlDhX6ZFobJ78Grkuwuc9aY6eBeXW4ygctc
         O/Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4W+mID6rGcwwYv2MZsQaafxA3kclLpdCcSftlv9Bd4A=;
        fh=bd+GeNr7WrYtW+fAjjXwz6STxspTo5YQRFfmdrr1ONU=;
        b=CMA93Tr+b48ai3BGZ5/nxRfhWKn+mvf4mzR5T/sA5SwjpzFSbldkriW9luFXV9PbUM
         egBbH4sjM4qh7XPagl0E5wjISvs+5yv2lE4OQERJzrrDU86AstIbaNeV8OM+5eS0Lh64
         55GmkdZo0ips/OhnezS2XEgULX3zdHt+VTOQj8Pb/1H4qTr9Y9uNXZQ+ByFVTd9hDw6z
         amA4iwysIl6uisTazR76cNHN+ZHdkasUGCrNE3C4ND0slIL95TcAlB+5qHvJs1cgzpLP
         ZqmVV/qxXErrHQex1F8HdqrbxkLPVjTZ1QzitT5HFvlWONmCyHGdThe8mdLrwFqo7zaY
         cIKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037568; x=1772642368; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4W+mID6rGcwwYv2MZsQaafxA3kclLpdCcSftlv9Bd4A=;
        b=ZhWe/z4OiNAZTGJ+qd4KCmag4X0LUYYqN4E2TIHdNPOFcv5AtnyD8RxUyFLg4wNoEZ
         l8GTZJPSnfYkCPU7kxEAEEatLdvzzwJoNCUGkpWTz9K/2kL4ORstJx4A/sDxbHZxUqAl
         6DTXLXFDE8A9jNzrY3lT3Re2teKL5Gzad8zJful7FBgZzvMrBd5KOvwostYanLFZW/Gw
         9y2ouGshDY+QznfWf/s2gW5+a1pYPaAOWXd+w+qfwksHo4fwh2S5SD0PJOQUH1MAJbY2
         acyhXob4afzEl0Td0RWG8gx0zdDztZQplVVZHLZUTrK6B6hUdVK89nRgAJ263qW793LK
         9Efw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037568; x=1772642368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4W+mID6rGcwwYv2MZsQaafxA3kclLpdCcSftlv9Bd4A=;
        b=jCUfzGbsFTWuhWwV2s5j/0z105ztGpy0yhumJ1jndZdjSEkQt4akUrpo/TUQpUV6u1
         yX+dqvzOlgU6PH1KUcMpDAT7ArFGiKwDZAwp1eNagB/HiNitwehulwuD6kG3YOkKpaIx
         QmJEjwhnx9idI3xwbHgcr+ZC7GDqIQTmkCSgU9PERCcYOM6Y701H9i1XRnTqo/piKqn3
         +jsJIvehsUGFjjkWlVMF3dQC4xwuT/Bx56XXSfoXDpNSD0QPXOAo6sjKs71wbbzWie+C
         bAGl4BilHDKL4XKQuvYFJVcGwC8PTq+a3Z2TF/6jpP5k7Bvi9XdedCDCe9Eo6QMnmT2i
         yjyg==
X-Forwarded-Encrypted: i=1; AJvYcCUJiWBb9iddAeIwNVyAfB+WuUSBM8E6mWpj7CEcQviw7awxUUYeoMDUQ7EX90HR3yHEwm2Yk5NqoQ==@kvack.org
X-Gm-Message-State: AOJu0YzEpMY5is5iPijpgXKtLDNTLCu4/mewfHiFz0a1dEcnJjJQkIST
	lANLe15gYfjOInkOruPRqnHQ5L/Qu8EnG+CEqW6YpWNczNVutiKZs0BwiLYbYYEg3k73mzMeO79
	uaMkmVZw+mpJIY/1iENsfmEv3f5e6nfWyISySD6HA
X-Gm-Gg: ATEYQzysh+4B8Jbrc3KgpOrOb+xfNEs6UmgHs/MRyDsX3p0lMNsky58FMPmake7af1v
	dd0suIBgmjt0U1vCwuecYPwaDRqTIl6MTCUs1KJEGXMayzLeNewNjPjV4wgtghPe4kvVhanIRoj
	NhXCpC5PG1JZZtAcQVlaSi/beWAX7uMn1bIy58hNraDn83puFDPikexkRzSjgs3ghug26aRrE8X
	ew3NlTvC5W6hWuY723J8D8T8FWoGxP0CSG1CSc1ZjotiApPQN8kXyXtbcP1US5J4yscKJkjSeYN
	MZ1fzSqSkfDMtpkSEpAkkoUUnbNghvj9nNQ4CQ==
X-Received: by 2002:ac8:5903:0:b0:505:e719:3b49 with SMTP id
 d75a77b69052e-5073a331544mr11843271cf.11.1772037567401; Wed, 25 Feb 2026
 08:39:27 -0800 (PST)
MIME-Version: 1.0
References: <20260224221132.1702713-1-surenb@google.com> <aZ5dxxgIb7MfuRVW@hyeyoo>
 <CAJuCfpE6XVE4BswKbPPx_bz7pUy=zSQrm7njmKhZ=ryq12fNQw@mail.gmail.com>
In-Reply-To: <CAJuCfpE6XVE4BswKbPPx_bz7pUy=zSQrm7njmKhZ=ryq12fNQw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 25 Feb 2026 08:39:16 -0800
X-Gm-Features: AaiRm53PNgFcb-fIUMz1g5CjCWyQyGwTNKKtI9M_diTSlgB1IwWAKE2SXmRDpuo
Message-ID: <CAJuCfpGM4-ax6XyXp4hwxbnJuBQhk1TN0XezUoO5MuQ9rLAmkA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm/slab: mark alloc tags empty for sheafs
 allocated with __GFP_NO_OBJ_EXT
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, 00107082@163.com, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cqszbokuw8i1rp6qm58mdooo8898kkyk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 03AA3180013
X-HE-Tag: 1772037568-689760
X-HE-Meta: U2FsdGVkX1+YugB6D/lzYCP+EEbe28vmnps9w4NkFnqotbob+MiAUIh9Pb/Use881yD4FdbHwwzheZNL2R2XPpSbavYUj88/KlR603ZDkm3v7c2gj34+9ekJ8BEHBrpeMmivQfEWSKpr1S638FvUFGBeRDg/Qwtp6p5G0jY2t3+TpQ3D8PLOCr5sUvtKMRzKjcYUsBkE538tHT5xNLLKeJaNygc4x4dmKop0lH5yv/Fym14+eSjgvzm5pQEKynmlEdukB0R2VuLN2DA03YeyELBD+fyIvXFAIEZk6GTYQruRBsXOcXvrEqbaer9jOg2bbX7HFeuNUi7JlG66paGzsf2xgXHkmun+CfHBpmiHlUVo0Mt6BYImlaDsH+hy7911hNgaU2AO8pRRhmPL3jXO3+mDiG4Msd40mgwMf59PcDmDNjn8v7tJ90lyc9d7DrqsS4JwmC9LCs1KnjqXKvA0gW5tNoaFxVIIyWLiWCLPZ4Mcw1b+UfHODV7RYDB+WGrqGdqGSm29WaeKlSDUZo8ifvvdS6NrrQPVnDjzv/hmoXE+g/ngnL/aVB8zpMnU3L29eicjbCnkOrvnrhgrbFscy6Z9k2Y4wp5/WVimoW4jVkGH5DX/WYtJMxRH7mGJ+YM2kBqHUOfDOLeLtTspTsOIDYwFUiFX9gul27QcamGY/lcf0BpH0BM+KzpG5y8M9V5ysZJFYtcS0Ug3MWVZ0YVwbl8Wfede/i6XXX054tEncskmoFmJwyD0wgcBNKUHyVx6oNmSZxYUNnUU6q3Aw3IJ+AD4qE4Yqg/FtG/x9l2H3uGwr/5P6ghVW70grnq01dzqRb/zx06ldt7ATfYGcmSUbKiU2/QVmADYOfgjXElBrkNOnXzZrQuOtRW7GjlHLQ7xWX+VBXx+/xMNbasBt7Nj7ew4PQlkCjXqLUCTExwI/tw5JvkKYj+CJ+LFuP+dF9WYhcDVkY911Tjdk3fyM/V
 nFdq6ikW
 3MmRZ6pnxpGOVLoJ7SyANBDTqlbEXDr6qcVJslAsiV4rHyXfqqFj1PoR21bA/7HV0zdZLYYDEGUpWf+m6aVSpUVJZioVh1hAE4fBqB48KSRIm/GebVYe9R/jhL/FjmNlVjuwfxKPPrLon4/cocW4C8tFDHwtd5RNjom5pS7srTQSz/3Xs4MIcBqc5gByGs86zjPbMxn1NsaUB4iC0LKy3VSv0/Fk387ZQtl2Cg1tHXlDNBa81qwotY9oIr34nhC0Sblhd0kyasUT6aGkfmfRnb0wqeWAYjTTJUqEO5nVvamSANIIZvFezzkHEZOU7khdaog5yoyeeVzd1hvoTsfi8ZCkpwZRETRDBkBARa9i5tHAAEaWJtF5eyLCUBUX+xYKhm92r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:04=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Feb 24, 2026 at 6:26=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> =
wrote:
> >
> > On Tue, Feb 24, 2026 at 02:11:32PM -0800, Suren Baghdasaryan wrote:
> > > alloc_empty_sheaf() allocates sheafs from SLAB_KMALLOC caches using
> >
> > nit: the plural form of sheaf is "sheaves" ;)
>
> Ack.
>
> >
> > > __GFP_NO_OBJ_EXT to avoid recursion, however it does not mark their
> > > allocation tags empty before freeing, which results in a warning when
> > > CONFIG_MEM_ALLOC_PROFILING_DEBUG is set. Fix this by marking allocati=
on
> > > tags for such allocations as empty.
> > >
> > > Reported-by: David Wang <00107082@163.com>
> > > Closes: https://lore.kernel.org/all/20260223155128.3849-1-00107082@16=
3.com/
> > > Analyzed-by: Harry Yoo <harry.yoo@oracle.com>
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > ---
> >
> > This resolves the issue on my machine.
> > and the fix looks good to me, so:
> >
> > Tested-by: Harry Yoo <harry.yoo@oracle.com>
> >
> > and
> >
> > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> >
> > By the way, perhaps it's worth adding a comment on __GFP_NO_OBJ_EXT
> > saying "you need to call mark_objexts_empty() before freeing the
> > object".
>
> Good idea. I'll post v3 with that comment and spelling fix.

I added comments and also renamed mark_objexts_empty() into
mark_obj_codetag_empty() to better reflect the functionality since
it's now used not only for objexts.
v3 is posted here:
https://lore.kernel.org/all/20260225163407.2218712-1-surenb@google.com/

> Thanks!
>
> >
> > --
> > Cheers,
> > Harry / Hyeonggon

