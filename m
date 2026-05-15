Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ADC5CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 22:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46CD66B0005; Fri, 15 May 2026 18:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41DF66B008A; Fri, 15 May 2026 18:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333666B008C; Fri, 15 May 2026 18:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22E336B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:24:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBB601A0212
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:24:31 +0000 (UTC)
X-FDA: 84771084342.10.EE36686
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E51E5A0002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:24:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I75LpWDr;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778883870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Et6+E/4u8tPTTTpLDHIBdHbpFsEpY+ts+wzQVI+pdX4=;
	b=nQ4kswSTe8ouDzcEf3k3CVwwmGeC500eqFV8x+e1ZVmpf4z+1OQMETMwf0BOg3vccLRRAr
	S6IA6HXIYjr7ZxVbIeXcPhfuHsQhsX7kN+EiIgfMQLvpfkbFc52ra4Oj8cRLPK+3Yy4n4f
	O4YedY9ILN8e6H29nMav6eQSNANNz7A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I75LpWDr;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778883870; a=rsa-sha256;
	cv=none;
	b=2b1gHmVkjs4UKj04pSp+89PD1QgFSCdf7M4QmCi0aF99jugAeJ1PaHgVOkIuVJ6LplQBst
	AWIOLFC66YxjuS/yeg61RsWuSkMQxaANs+A1vL9wPbCEVcuoYPCehY2YqtqRmwy8VKeEZV
	pUV0GJoyuk1KBdrgSU/RHs7mzVB0/cU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2184445D9
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D707BC4AF09
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778883868;
	bh=CQjBHE398jfmQc9Nk7uTNv+8vscqO8uzAxJfVr6TjOw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=I75LpWDrE4HspM1Nom8QNNiBxvvPPC1Z/wA25yBCJ/4enl3WTmrgj8AZMjhk2O/xG
	 yshsfHF9WvD9zWHVLpX9AeHo3Ri3ddj1aGewMbBUU8ZueR0ecjlr9Q0zOirV60mTuL
	 Blg8dz0+peaFU83cqwIw+GtehBIoilyr1JVfpLfi/1DhIwPgar4tiP57UNiR2Z6RXb
	 jJG0DtJ2+JgFoQLnfeXEZOoydPFpzXHXPWSjEyaxuisnvQztS1Uw/mSHrNECrgkznS
	 jVFyqqaY/Np9buMNHRC3bZWYDATHC2YK2s+ERM+sBFNsc5fqz/AcPMBEuFWjFE7Hyy
	 AhPRursx/3ldg==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-65c24be9e4bso654638d50.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 15:24:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+1TiSOuKFUxk8qUeFQbsfnh8MkTeqzDmidBFdZ8bhOiGutVh+HWceBVOfxEOXJ89Ac4fE0yaEw/A==@kvack.org
X-Gm-Message-State: AOJu0YyGAh8yOLiV4vQR+OlS8mrX3+yJx6bsYNI5Fdq6b/dmdtDsbbTS
	Ol4qb3fyvoCkGVtoUZsIVNYioESXZi0p5O5PPpQG9KT2twnIAW/xpuslvmHsCQheLg360soThe8
	za9Pqu3pusQc5HXK+WgXVfkvBaEF8dWH1vigjmTJ9lg==
X-Received: by 2002:a05:690c:c504:b0:7b8:926e:3ef4 with SMTP id
 00721157ae682-7c9599a3c98mr72668207b3.17.1778883868040; Fri, 15 May 2026
 15:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-4-hch@lst.de>
In-Reply-To: <20260512053625.2950900-4-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:24:16 -0700
X-Gmail-Original-Message-ID: <CACePvbVmxUVVZLd=hUnzjRLtt3hBWRxemR_YQZCVSYYNadiAUw@mail.gmail.com>
X-Gm-Features: AVHnY4K8odfW_w5Sv5zxMaAGvoOSmdsLHmORiA0lm6BrpYzORI9rYZ53g2APvuQ
Message-ID: <CACePvbVmxUVVZLd=hUnzjRLtt3hBWRxemR_YQZCVSYYNadiAUw@mail.gmail.com>
Subject: Re: [PATCH 03/12] swap,fs: move swapfile operations to struct file_operations
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
X-Stat-Signature: xtphwfaepr7g7qwxm38ztyabg3gphdgj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E51E5A0002
X-Rspam-User: 
X-HE-Tag: 1778883869-173094
X-HE-Meta: U2FsdGVkX184INI/SMsZrHmhbr2xWZHT2tACAllATZLZwgZVjFf4O1Yo2yZdfs0zfr1dYQsMAKyGkrwVlGiBxr/GBj/0zX2v7DNP3k309kk0b6TGbkrl0uJjd/IdegcLmsf3ig7jSGDV2qgSs9oZ3G9W+8BIpi1R+B9PznGgSsBR7IecfdUmqiM8TuxAJDmMzvFqiUyCgKHyQynj7m4GSAPmZRJC/Td3BcBCU4rup5GB88Iu5/6TQB1mW6gnjgehPgmOD+Qdxki/OwbPrZUYfD7jcLtjlrvqQLleGNlO3CJaloSTGEdq6KGHcLekrM9PR22NLnMYJAvkAfBDs8ds1TaBKo7r6xFDCvDcYMsRKj3IbruWLlIyMdfxHW8CYPR7i7kUeL8s89+snI8UC3uXPSviybBnQlgvXuZ+9x6WGbToPZhQvisHrSikZ/nGph2PhXd94JL8O1w37KuaYWGTQ7d6f+5sPwN9QH1VaJsbYrvGIquptctlAsGcTacDZO4ToVZKfSXRlNys0b3pw8M/MTfPptwEa1dal3nr3YLebDAsVzp7Z14qDa9VHhcR45M1UMr9E8Bl2xNXXGxEQwncOl8EcVE38tiAh2BEyr80md8FcyOOWxOWtpPj0JSWc50aAc+Ryf1k0JDPZCAezCL1HB/1gaJQKY/mQbYKjRLzwcWeYCworvI6w6/LSiidCgSrMBpwwMhL675UmPoEbk4ObCJn9RfJ2UKVAUpQGaU6p8kW9kRiou9KTojxDNcas4+1k1gycNb0cuReQLRwPI0NvTuhoo4mLUimz9zLX2B3Pwiw+4UK/j47AzkQnL2C5n2mREEIQYB7lkjeapslrSJB5On+S1t9ONPLEQvq6Pl34bkBTBPecR/rKkQs0CaJWmLOmvT52bStSzjpTTqX/DO794jfbfIEek/rKX4km7v6hbn3OzDgnWtRaO/RpjuFr/zvpV5njlRTtNLKnqCNwGn
 u9iodB32
 Uz1hZoU/Qu40KeIzXMb5Fy2UaggDwcbtsMtBYQe6MVGxZUJD/6MFKq823Lzmk+TSbZlJX8KJbmbhLqY/RG7JQA9O1TTqMjMuKw9E95/VodAA3+oY+tPeDrUFaGm6wYEcnk0o2FH5RC+KdOQUn+5hsrkp0UVAvyel9QP0osM7NOTetDbAaQUvdqfZSnIJDYHjiqO0Nk92OAlvd7J6TUhYsu8mMMrU5/45I+vcW161r47/nPFmIPBG2jcdRN1cEtnzX0AlHpSdeigdlqD/WGmr36ZAn0u4z+BVZ9ng2jwG7O0R3rySBTxK3gg1EXK4N/hKw+1Srnd6ft9W8Jya9FkkMAA/Crku8s9998gxQKKqEi6F6Fnt3lqSrEEKkDd1WF2qwVDaoiqbuMXCQ5P3BuOl/MTeDz6W3RncNKXawP71gibLglaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:37=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> The swap operations have nothing to do with the address_space, which is
> used for pagecache operations.  Move them to struct file_operations
> instead.  This will allow moving the block device special cases into
> block/fops.c subsequently.
>
> Pass struct file first to ->swap_activate as file operations typically
> get the file or iocb as first argument and use swap_activate instead of
> swapfile_activate in all names to be consistent.
>
> Note that while the trivial iomap wrappers are moved to a new file when
> applicable to keep them local to the file operation instances, complex
> implementation are kept in their existing place.  It might be worth to
> move them in follow-on patches if the maintainers desire so.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That makes sense to me. I ack for the core swap part of the code.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

