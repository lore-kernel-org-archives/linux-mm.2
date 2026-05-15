Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B4BFCD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 22:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB1B96B008C; Fri, 15 May 2026 18:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62426B0092; Fri, 15 May 2026 18:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78606B0093; Fri, 15 May 2026 18:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3676B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:15:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CF63120232
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:15:05 +0000 (UTC)
X-FDA: 84771060570.14.0790B82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 68A79100017
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:15:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jxh1uapp;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778883303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBov2HinV/dwF9IJ2Ido+SSIYnzOEQz6Xz/xjaqgFls=;
	b=TemL3KgzZB4mM3cTdWWqkygzKaefosXmuAZeLeqJH/tVLrCmmok94f2pu7LV5RtNZ4Oyf+
	Po8w9bTqhUQ6xqLGSuK7tbG3H1QKicVoRMhs7aMllbRBTbq/uMff2be+7y9By0+3qPlPT7
	bYtEBvI0ao2u1hUuT9h//VXzH0MKaBc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jxh1uapp;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778883303; a=rsa-sha256;
	cv=none;
	b=y4QHd9XtqrW7ygU8enxt/UQU0tfp7CIDrdYIoDcQG9A5vXEdXqs2goN4Lpn/LtbIDTPKaN
	UF+UhlLbNJxt1VRXaNgmjNjCmmPQuUlRUPhhTpp8q/Af8yourh/KXkLA5eVs/kDu56MTWN
	r6H7Wo/FQFHlMEwlLI9ObQuTiBhRrZ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4534C4046F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BB9C2BCB7
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778883302;
	bh=HEI3NInBIsei/EoRNgiy0qpwrOV6JThvbMsnk7Bz8SQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Jxh1uappRE+fFuV27sWkHNzCj5+d2aVT1j65RMydPiA3+qfe9fqYBuFzc0ZIj/Fpu
	 cFQRaQJoY/iHrKXBJdS2wsRk5rq1xzOyNcs7yejiWh8W6RgAaWEhBqEdZJpxTPy77M
	 JRYi4PNnn2wtzhR/wyqz4rMdmJR+bxiI2vRMwsQLdaCDEgehFvJoO/bHVv0iHuTfP4
	 wfuarXy7ruNKoiYul90mjrrYps4vYn1HEB9yDrtHODVNDLOu+Ppdbyoz4u0hRfUsC2
	 37C28MIvN0l8wESpsUfo9irFJWsoyatkAK0iZULeakWTs0Pc88eJ2PNYyU/VJuXeeM
	 L/xniqqnaAmhQ==
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-65c7a459105so535826d50.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 15:15:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/lGPskI64cILokaBws9KnbRjkq7AnDo/UF501gifIl5Knwglho0nmll2ynPgLvSQgwLdePNNVI/w==@kvack.org
X-Gm-Message-State: AOJu0YzXHnKxfOEqOH1oBGWhXq0j97L+4AuZXVC9f+UX9nBU6c3V/uq2
	eTLeWIE3/yYNNCIWbRA8Cu/0EwnAf/cDufNbthcQFgaX7Bx3Z1gz72EVQ63NkZFOfKSGz+BZxHJ
	/vsbfxsvBZQ38fD/4fVka6EIFxa/IueJ89jCX5TpSqQ==
X-Received: by 2002:a05:690e:b46:b0:654:3fca:3515 with SMTP id
 956f58d0204a3-65e0b21fe50mr8034402d50.30.1778883300972; Fri, 15 May 2026
 15:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-7-hch@lst.de>
In-Reply-To: <20260512053625.2950900-7-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:14:50 -0700
X-Gmail-Original-Message-ID: <CACePvbVAWsNZ22gzuDEfLiCK3zxb18svrJ+ksuzHnR2eQOyZyA@mail.gmail.com>
X-Gm-Features: AVHnY4JHBmh6X5lXS1qOF4QpMHKR8b6gUc4PeaeujUpSr4VXuziU4ZJkvW_XRo8
Message-ID: <CACePvbVAWsNZ22gzuDEfLiCK3zxb18svrJ+ksuzHnR2eQOyZyA@mail.gmail.com>
Subject: Re: [PATCH 06/12] swap,block: move the block device swapon code into block/fops.c
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
X-Stat-Signature: ohzn1z54nei9ouihggriaarratazotue
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 68A79100017
X-Rspam-User: 
X-HE-Tag: 1778883303-19144
X-HE-Meta: U2FsdGVkX1/ZKUYkyg4eKWOxwA/UGvs5sVPlVG4uWkoeoZVr+OCHdx6Ewz4xgCzaoMpf60mbZCCRMfq8Zc2XMWhPDRSICDWy96BORddQijjrpy0N8Jo5EyklWYCOt/Oocth4jFlzywRRPR6lFo/nFn7RC1rQZG5Y97FAmek45cdO5qCuX62ypeJ9BVFgv3hy/9YI2sMZhis4pTas//+T2+DvAxg4uWcfJndI8jNue88SPastyAmt+j4Kzsy+T44AZZPG3xt2Bt6XTj72PvTy7eKqEw1RALdb9k+IRkFww39xpxKp1A+JQc5WkMkRcdX40LsmmKhdKCWAZKKOeUJv1TlnS8v5k1ai6DNe0Gjkb87UvXtFJn3QzyDzjoX6K73B1Ei5aLRog6WgjFA7Q94oPPiwdycZO2nI64bIMJtk6yxQ+D+YsVuWnynQdqvkno5SShTSwVXQCYDRKa8ryqIS78IvGvOyVY8GQM3yc2MUTf1z5YVARm3rtSShaVrafxtPP2TGjGUST99ZVQASOz6KUw2YPySsHs0FcPErKIzOJZgWgPEcZt67UYrAv/wKB1L+1ewdytKVoiGbon9MBESOgMcHsDfu3iTnaXe8c7/gLm+PEOL2EBXJiNrVwz5chgAmhFiG7m0ASAOHQrs84ohtWwhr0sY1Ico4S3P68vellQAzIr6Qnn7rjZBv1R7hLPXtpLRclMTvzstpWG8EFtKxVFFx3G8JcjCWc5iE2b7c6oV6xKKMluj6GDKKaWJp/LobK2i82h077/hOfRYlSqSUwE+kOSbqYqVZW9hJRSGNhFXpetJeei5bX5RHLPXio9C2hygwcQhDp00NlWHteUB2asyWaymxSgolYvCZDtLZXCxN6UczFg1BlXxlpi5gAiSJaOxp00l2geQ0PtPTWpFNcwnlS6L0ZSUFeE/dQyWH56uTdoKXCSQXmwQdiPIMh5Z0jmMBg8QHPrkCmB5zhVo
 YnU7/sJ4
 LX73edudwXpW3G6duMBb6YomK80eO121pd2cxB5N7TVnDk/QTm72y/ZfSmj1qNun/Y5+0HdDYWpGRLNbLZ7mCT7E7of2hkZ3LBdWB4Ox7upzLNBbi5B/7LWS8v2oTUYBzCG2EGtBMdSiYQ9c3xwtyYUWqrYJOZ2l44+hsjX6tKlobBPYCtc9RwgPxgNARmryqoc4ruVwb8k26CDnzhieLZExqxjvuyWgOdFMviVyW18IcIExAjQ1hwKCI+6LBC1z07dlXeIde928RIitZWWdkHem08fBzBx5TfI0cLO0bEn8MhCrm0dne6VYZ207jqqGFC7E5VQrFrFJROGkwdeXLFGhtA/1zZf2wa8ibKGFmc7SDPf45yRwQXqLtaiuOIjRPQIuml3WOZ9gA378yYsgx2bdL1TZfy+qosLCDwDXzjnJ0kYwavH7rbxA2u/N2TeOE5jRH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:37=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Make use of the abstractions we have.  This is a preparation for
> moving more special casing down into block/.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

