Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8792CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 22:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227486B0005; Fri, 15 May 2026 18:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B11C6B008A; Fri, 15 May 2026 18:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079086B008C; Fri, 15 May 2026 18:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7E796B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:01:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95FEF1C050C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:01:09 +0000 (UTC)
X-FDA: 84771025458.12.889C001
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB8752000F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:01:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VnxyRqbT;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778882467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Da1KZpOjYE8D68IakmHMLRFYpruCGLnO4oj2vfewy4A=;
	b=wlYf7fzS5uMIw4qgMzcUdgVmLaVRHCfjF9HhOhFSNc9hAZpY0GKWl8zuDxoixcVEQDte5x
	wRy+MaPbdtwJomq3ZD3VF/xV5vJhOGGMYtYati57sEHvbtS7loOI2BXpoa4fXAuVdDx0Xl
	NcAgRYs7yw/XJ118qkT+cveS+cUnZu0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VnxyRqbT;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778882467; a=rsa-sha256;
	cv=none;
	b=cTXnXTDmmk9KHFeyIRVIp9Em4meG0steGW9MsejaDjZQvYBbydNB/Ist5J43WxihxNDQ3a
	CxDe2nI/RQDlRjMLkZtrbE7GYeqUW81aPnJ31uIwfj8ANY4EWBHqkwovAc9ayFCJBOtKum
	9fGI+NJHnKa78RjXkCoaz0KAFkhsCbk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17E12601E4
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1019C2BCB7
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778882466;
	bh=8FzUPImWV18kvph4lTxQrEFg0N5DGTFbvVX3bryYp3g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VnxyRqbTDYx6GgcrEkNlGe2hGiAg4yRf75lATHoVW0PpFzHCCZ+JgXUyuTTzFzYbZ
	 nNFOXRco11MWvh1JDJOczfjW/o82VAln7pHQl4C82nUu1ViOis3SosrtDwHSbeQ5h2
	 7hh5YIRfWUUE01drL01kz1ymKoCuIOuYafR/+moxrWHGCFsIPM/YwkCOoOMPR2BW2F
	 sEFBWfkOLqEDVYWBgUv069lwh+x4UOBR3ulzyYJOKkob68jjmMKdwTenYe8GkABinC
	 7xFMM9GSsMSLs+ZAmcpTxsTv3F41hHwR75Z87TBgh2LyaBVb9TXRTx2e7ts+Cg9SFX
	 aQUiJr4F/vybw==
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6579254f996so476091d50.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 15:01:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/CI5wIoqhofplP+oHAQzyGoAZc9kWRwxIeIrdC/jqeJshpWTFRGMu4Cpk24UPk2LAvR7HgSPdgxg==@kvack.org
X-Gm-Message-State: AOJu0Yw/unUwW9Hg4E/6IoT5cLn6UnGGRUAIbaNbS2grHU6562y42OLd
	bg7UerKXmloTv8KyWt08dMbXs7bX+2m5du9Bvy2IGlo9d2OZ8ajXNMSZVOH9Q6Cnw+/+BBC7rD8
	bEnYk6fTvdhfna6bSuAzG3/bZey5HUA0DoX3xt2JmSQ==
X-Received: by 2002:a53:accd:0:20b0:654:468c:7dd5 with SMTP id
 956f58d0204a3-65e2280d9e5mr5432439d50.33.1778882465457; Fri, 15 May 2026
 15:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-11-hch@lst.de>
In-Reply-To: <20260512053625.2950900-11-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:00:54 -0700
X-Gmail-Original-Message-ID: <CACePvbXY5sdG=JXV2TE65NAWaEQ975wHhcGGzuFg5mRECkwy+Q@mail.gmail.com>
X-Gm-Features: AVHnY4LoQkrm9-GqAeD5m6WwSsE12ARR5KdnPZLUwdKcGhFx_HvxcMbpEFa8lE4
Message-ID: <CACePvbXY5sdG=JXV2TE65NAWaEQ975wHhcGGzuFg5mRECkwy+Q@mail.gmail.com>
Subject: Re: [PATCH 10/12] swap: add a swap_activate_fs_ops helper
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
X-Rspam-User: 
X-Rspamd-Queue-Id: AB8752000F
X-Rspamd-Server: rspam06
X-Stat-Signature: mss5pkykxrn1zw7zg3cmm4efaawok7s6
X-HE-Tag: 1778882467-866507
X-HE-Meta: U2FsdGVkX19Wiv08nnjc228liwIRLXTRjFSXgrwQaKl0ulXNbnKvE0F/3QqrbXYht9H6BRFCOMBYhpIBKUHyRvgESjutUF7ZQ6wtKfMzvW9KpRpY9cHOnof+eCT2iOo//IPXrHdRhtlp48vGsAUtcOltTfy6WivBPCS9g+sZ3HRKCewcuPX/XdODVzJBNGj01FcVVxxzK2GHfgiWU4QynRRSl3nIO9Wjpa1cMwwHA207N0psrNzMTFF0zJBpGtB3RZP9Sa0Ucp3c/YwnO2fDp2u6pCW/DHEv5aJTumAFumCe7trMqJiXOO+4jNY4WoYOGOXhn2vgJcCrJqTqOHKUyWWJrKukShza6+NJusklo0Hu2Cedi+ajNsjCRVN7L1rceWPpIruaONIWZSqQQUw+QacsuJZvrSdXd7CuWLmQ0qMt5gehz7HEjzUt2Wu6q6qMTpR4kJv4/wVHqHzZapUsDmAWwmn9RsOymYIIP+v+ZMG+q6QoB0b1Ps7o9tmIv5BrSNWDbrctjApQoYodBRUJosAEFXOHLQT13ABgY5uxA7E7/2PSLQRsi5pPsQIEC55C1wY6PCOnofX5k0HfDpmg2gzZDFkdX1WHNYXRTrZ+H0NFHXZithehzix3aT7iOktO8EvvTwZrLq0Rcc0jXZai4xT6nWUNIm72rYt0oWpaGvh5hDTGISDfbGB0CFo7VHhT4IrRKffnfwRF/ZGyfpZMNrj3N3t3KFOOJ+hb0XLBe6NO7u2MIRjlE/nBfOn/8B7Ku2AIJgHn7bfwbADgxVeYCPQiFWBRpDwknp2LSyhVD0ya0TEUzm1zm9kdSTzezR9CcK3KuJjhNxoJ4lKsm0Uh2U4NSWxsbKVcgS1BO9NPnKAQ9DTTxXin9BH7PMQUIEwwYOd6zfJtoCk3RvuGnPNmATr+B8tmYmjJAH81VvqWttNXtCuO0PyFhB5Rn9PxDxzVI6UzEjSMZ6AD/9PhOxx
 w5p/3D0D
 y272xNl1HGPyIBTdafT1c8JEOPueuD5cd0FUVkdy5GKbsWK2mJ4TVmvhCewwGVZan6LnY2fBEMWsFIlc7LW8E0nSeImctBQEkWfWhFR4HU76JuNdl2jas9Is6nMk1r3kCfk1TVao4S5XeQ6KRHdfNQZyV2JN5buleIhkexC7EFa6sbSTnyDjVnBubsN7n37FpAHpJWW0ST9M3UBmc/3UkTFJL73D0+SxWBwPGGoVPjRNSdlAQs1etoSoVJqKyLgsn4kMj0E66H7SVqDUMPP6105tJgVSjJX7rIsZm0bam+5XfL+fsagxXNd4TdFGH+P0MBQHcFg15Dp10eAkLNWF7A/0tV22xCNlg8w9txtUDofpgU1bzHp9Ic1joK3pIasLzvBaCfemen99LrvLojPf1bSnWtpiCRPwQf+GFnC3y0I/DEOtKL4WKbI64Sb0vWo2qFaOF3elaihZlpCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:37=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Add a helper abstracting away the low-level details of enabling
> fs_ops-based swapping.  This prepares for taking swap_info_struct
> private.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

