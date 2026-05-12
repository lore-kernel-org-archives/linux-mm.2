Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9762CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C97A6B008C; Tue, 12 May 2026 03:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579BE6B0095; Tue, 12 May 2026 03:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7EC6B0096; Tue, 12 May 2026 03:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BB046B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:31:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD2D01203DF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:31:39 +0000 (UTC)
X-FDA: 84757947918.26.5191255
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 19F5440002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:31:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gAiB8tFX;
	spf=pass (imf04.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ita3d5CJVmYPF+eclMsnCvsqN2sPxc0IzPuSVfoqbk4=;
	b=GBE+DY/A2TJfJwYa3TjfuGS316jEKhNsaX2uPxfr4ekOERScTMTlXsGpC8n4knTtKGBJ3d
	vXYk0w6KmmMos9gOcMocvCXGF2BWyGNfxtu0TH0zDR5FkAPRWsD774XOrUv85ZeyQL/o+Q
	Oz32/D5CIdFPr9qbgCkZ08LT+9lONB0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gAiB8tFX;
	spf=pass (imf04.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571098; a=rsa-sha256;
	cv=none;
	b=P6BrYRHjjFVhYL14zDRzEcTawggAuh8BQBXLP+5YB4Xsb6sjal0wekVlJscyL0IjfmAwh2
	SUtHe8zl4gdR37GTK6PlEdqJcc5FwTxrtaBX/rn7B2mxp7RXMJVmaxebwNxT8wHjrJIz7M
	i27lyKOyCjK2RXdf6QNt6v6XpR+EJlE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D1996001A;
	Tue, 12 May 2026 07:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3FBC2BCB0;
	Tue, 12 May 2026 07:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778571097;
	bh=aowACr2p+6rSwpChoE3EadCBPCPgSF8E8psfVlXgrO8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gAiB8tFXXabdPEPYhwa+Fm9YFauBqF8VyymvDAAZmCoURFlvvPu6j0sz4KZ788AbA
	 /Gilye7p4N5y9ZjRoSrFQ6s+fsXJaBGyl0DIg6af6KSVL52pIRTR4QBciuGyf4cE11
	 H2ZLNauyCJw7sUXtWJPUlSY8C+xQSZQ+BLvRl3T6nGZyl3bJmm+w8TMzbUXKvLQq/d
	 867M4z2uhgR5hdCFZzD5aMDreoTDa9a/idDEIGy972SC8TvrPs9rAgOOqsDOp6CIPd
	 afxA9vC7uam6EfUpw1RehUPquNGm1COUq7xNl82JZuOUABbJMJoXu3JE4ABKO33E1I
	 Huh7jhSU82cPw==
Message-ID: <88cdaac7-05a9-41a7-bae4-443db26b7082@kernel.org>
Date: Tue, 12 May 2026 16:31:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/12] swap,iomap: simplify iomap_swapfile_iter
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Carlos Maiolino <cem@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-9-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19F5440002
X-Stat-Signature: 75uz4f1hoq9k3fbsonyi37oc49ed5wyc
X-HE-Tag: 1778571097-120416
X-HE-Meta: U2FsdGVkX1/UThTbzQmiRcHjY335tXecofPkRt8ytZGjV3WUq6eXhJWfVSr1oMqa3RtbbTZWWUJ9uMuwT591ChrKzCz5phvFkTdQ/8FPgza+9LERDm6RrDZrrh9mQvnE0L/1byooyPng/YVqsHgA6HJnRod8AR9c+oXaKM+3+nvHwC3ewD+aQX+dapziHfWz6apPvGA1oeJZpO//f8hp5SlcvAYDnuHXpAL4F3XEJpbgNOvSqzGowYOau7MLCB7Pw8yqzO613JCZwLJvAbaTtRjNCWlB1/hUsDsN8iTtdM81h5H5AipoEE8jxeeVBzovKMPNWwjneDPS4R8mvclYtavddcz3OPu8yktAYHPz9LxEkRLgtHyDsWxoOThvnJWtv5jPPoz0cZBsL/7UaszcWQnWO5eAwCBomMjaeRlYDu1tQTsnOBDTb9oobvyl1PX9d/AiLKTwP7airWGH+h49LzDBv4F2qfy6c8/s7MZBAV0ZYvE1wtiMeZtuicqPYH1T9qAl5YTtEFonJSuKLxpxRKpD0ObPws1oErjtq8txzhGQoNb7q1aBj7qn4mwM5/fSEfBWibRZj/IljuejcRFRr+u97FPaykpsJws2tr7SQHH1zc4rgdbJu+yHCfz/l0WGi+bQFjukvyBcLGDqdwn9tc0j5unKysSDx3W+LePSWk97OGQ2IB9xIJ7pvQ4+SeI54PZ2rq8Vrv/U894VpCTtniC1XNzmJwF1zOu3jUHh4il8cx9+OlIz/gLT66qySukeAkfWQOXeKqOjX/NKk70pcnOMAyVrZmIqXzCdfSzRATvMtSls5s3KSGi0u0LP+CLIYUGNcqLe8mcTDHnGu7bQAA9bixbIEfQM9GS3sWn+v2lW8Cn6seFhpritnqAhdUVRmXc2ptZpw/imkZBJRp6PSTwBtLrf3ztLoySYzRe8BSK8smn2yqk3Tn0SQ6NX3uzAFvyQYi1VmI1yU8ZMS0m
 VJZt9tuH
 xHGN/2VmxlAiT2B8yMv2LFPil9Hy0ZWnT5Mu3VTBJnRjQwZ7Pf7pBGa+W2rfrxj912NWbI2nkeN+qIiQ65tez3eJT4Q7mF5SmqYmb5tVWMlV0zYUPJHK82cmlQVy8IVXLahQtieUHwYceLzLajUF6yy9NG7VS8t8d1t9myP5CGhgWessDOsw7R4UNafiwC0+M7pKDP7tn/r/l4cD2tYlYNfj2wYaBvoDJgUStrBYYcJnT/UeL2J6c+xiwpt6+7ChF1YnSIGXA0iT+e1o6L0jpDuvyHhxbPeag7Q0B6X/oZK+vbf6ogdSYywnTmnZaRN46pxhf9W0ycbQED+YpEXGmlAweHLB3Eb/N76nqv8xb0yjOsYp4gT+k7hPfV238BfDJRKACljivGVH4uLTa9/jESR/XowGWgMQWFPBrl5uU0L9skrjJCmuvPL54rcYSNjBqAhyx+VOqY2H1bBA805I36OLfjtDeC/DitsyTqxay+2Ym6SzQxXk1/c9xwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> add_swap_extent already coalesces multiple extents, no need to duplicate
> that in the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

