Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C8DCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 22:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B535B6B0005; Fri, 15 May 2026 18:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B050B6B008A; Fri, 15 May 2026 18:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A1C6B008C; Fri, 15 May 2026 18:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90EC56B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:30:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B8571A025D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:30:12 +0000 (UTC)
X-FDA: 84771098664.15.389E96F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 48F5D14000F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:30:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lH/oYski";
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778884210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1naeqAFqERRgX/gD+rpZA/fNmVhQ5XU4ecUjA+j4urM=;
	b=b6alB3tGA0SBcIMd3dG8TWNqIZno7PUz00Lg3yWJKPgAqpIqAL6LhRxDoL3bnqqBWE1g/j
	rsKr07FiVy+JEY85qpbGPzyNcXPaAsVyyj9aOyQUigxHkB5RWFaOVh/TyfQdBhUYFd/4JQ
	8WYX7Oq2wV5q/9xAoW4h3gLJREyGnss=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lH/oYski";
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778884210; a=rsa-sha256;
	cv=none;
	b=4sKixWC+d1aYF2HnwAtbsk7IGFpe93fiPcrThpo+B3UCS7jfqH720mW/ascDU3xVaOxRYa
	EaY3bJlgeFGmzIif+5A6vS/Si312S+PUuiPUWz7Uye4TQzTejX5e399KFGbOHZhJ4cq3RP
	eyAJgyg5xaBmMLfWK60//KX8H0VF3nc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A62F601DD
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E373C2BCF5
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778884209;
	bh=ReQtRGN6YCVCM+VLe1SVEp6J++lmzI2ST6cnJuKfsNY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lH/oYskikR0guEnFauK05dvIZ7FFOdsB402hk52KOZzyV4nYLxbRzejKFJOnc1Dth
	 w/5a5hUpZX+oSd+Q7yvURYG2zTINRb2MaS+LZjeCmGUjICZ/jn41oeyAjtN/eefh4m
	 Gt4NMS00if6iGXKVc9tppTzWUMHkK3RPxT58jLkMU8/T1ASXOwE8so7tlvXLAaBl/B
	 9DnHctfZhu72zNDQ8m5IAFpkxcvxLY58P7S8dOJtzvI3UOq81+eSU/SsYxM7lBsRUi
	 Dx5Tw2rmxDu7dfR6lZgdkJxU1Gv4Ud0Qej1pnvyneAGj+HUQxL/QfeWwtpw7osF6O6
	 acPlePHI9qEeg==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-651bf695701so686754d50.2
        for <linux-mm@kvack.org>; Fri, 15 May 2026 15:30:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8cWExpHtpHX61YFTYHYDas5ikY68/SOZWfjwzgUn+0vSjlKRyOq1dwhA0LKp59ybbmzmvNmOsSQQ==@kvack.org
X-Gm-Message-State: AOJu0YyexylXpGUdpFC0XIFEqBwsDBa+OpCYhVSANmOq62zGFVBrsUSz
	rjvPdXFYTKPYwxfjSVb1UhCsG9whYYAkEECNU99VwHYNt8YW22wsxsw35A+9Bbc9nSS9FH1SvPx
	bhd9KX+kG90u1QWeewYzlq9RyWiGsfptiMYmyApt4kw==
X-Received: by 2002:a05:690e:480f:b0:64e:597a:f5c2 with SMTP id
 956f58d0204a3-65e2289a39cmr4822587d50.65.1778884208163; Fri, 15 May 2026
 15:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-3-hch@lst.de>
In-Reply-To: <20260512053625.2950900-3-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:29:57 -0700
X-Gmail-Original-Message-ID: <CACePvbUPQ=tO5feC=2-8XdBV1PgzoX+EwASU__jNiuzcGsPMPA@mail.gmail.com>
X-Gm-Features: AVHnY4KVT3GwVUdlKXUpf18PwWGpkgh1B7IPlKLHiB6TxVcw3NQNEM73-FjKVDw
Message-ID: <CACePvbUPQ=tO5feC=2-8XdBV1PgzoX+EwASU__jNiuzcGsPMPA@mail.gmail.com>
Subject: Re: [PATCH 02/12] swap: move boilerplate code into the core swap code
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
X-Rspamd-Queue-Id: 48F5D14000F
X-Rspamd-Server: rspam06
X-Stat-Signature: kypg4qgp6kt1xtxx7hjzz4zphtagoi6q
X-HE-Tag: 1778884210-911056
X-HE-Meta: U2FsdGVkX1/dSMtOw1z0Znk0GlB5hpaJpx0O5A2XtSwlXzPOMQUb6enwzL6ufNXVC2xFty0Il1SXL/PlsfEdDPoMGqtgTiu28fn/JFNjF8X+JT8kbSaPISgSfaRNwJhdKQQJyU+ppSdmRHJOgZZz+OOgm4PbjeXxxyMEy6z45ZK85ysrWR8tQRyYtyLOAeWp1NFYL+aG1bt0Ks5/n8vP50vbarmUx5NiyX5QpNz1Bd5dA2b6OMHUge8A2Fq8n+ppH5qfv2WWMA1ZvGGwXd4p8q057qMV0cCYVDYOEsfEea0LqHTKdo+2HcJnbgYdDgziVFxDxc2DHf52gSKrGJGJaFdajbkxHApaUBOduR2ojWgVUyM9D04XGBVQuBJ24mAApY5k2k931LCEv4IXNpS5XBY8zMmQ+iLkXN+lLh/bNx32+RNnvXVZ89vOYgNaRwijtCtc534Y9AhxM6VFc2UCXIlx0b+mYTxlbA4LTNdUQoUD7UtulDYEQ9Vn67CYBuigs/JOfqFPQSQQkDMps5gHTyFHlXt6Nr79V/BejB4QOVzrM67LhV19iRspMKIJABlnv0DaEdopYn53qFhoOpOya5hxt3YWbHnRMAWhZB79cBJoXnA2XuOl5H7tPUO9juPBP+BSaDuNcn+vsxe8vnBOx5bJrpq8wzMzGg9CYC5dGOa4nX4HwZ6EhCVU0pcRQqRSvgSeOfX5xR0p1kaMcqXoKbJk99sYNGuCM9ZcRejvx4UzYx+5yW/CjgufyOzLBs/yLm2/fHjERmLsXmEZwKUrWJ5PVQYBbtjjoPKxxX886uOIEvZKzekzXxRb778RnO6IokTyd2xZBDRNV/bves7GklqapviXKPOmKgvlbWgAogOeUYjjfnXDFD+gK56+vjMkosYL5LhPdgdly2zfhyFTc9GII8mpfHTlOIG/uG0S8l/t6P4xpSeTeC2jcaIU+tPmPBxmy87Bsi9NnxknywZ
 se6C+fv9
 NL1dSrZfAOgHi0eH+aciccU2UgBNOyfFMZeoVlc3VvEjg/YsAwSKhyu1z7kOaiVeUcVVgjgQX/Zak2WhFwnktkbgFUcW3kK3xjZ6cmsvxHhvjrJPYRokDK+Y+/trqyXT5vUIAi5G1ZmO7MpHGAXL1B70wX+6ieG6qAX+n4Cb9ySZlZUe5YBLp0jYem+ERBvwmdXmvGpb56GkhqSR2V0kEDlz4fp2tMnvMukUAYJe39aAWY4Q+PG1SHjCNvgoVRIzBOQmuVlZjy/xh4tplTRSURKgu8h4BC8wfcy/yKT3BIgH7n4fv4C3dqkjsZMsksmPQ6R7l6VsgbJOUWCCEC0QDFjEuzrGNVxs5yRDEqw0fCZjfLB0pxQE+yfZSmNrPnwub8pCh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:36=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Make the core swap code calculate sis->pages, nr_extents and the span,
> re-set sis->max based on it and don't require passing the current offset
> into the swap file to swap_add_extent as all that can trivially be
> calculated internally.  Also truncate the spans based on the available
> information.
>
> All this removes a lot of boilerplate code in the callers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Very nice cleanup.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

