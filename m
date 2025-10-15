Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D851DCCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281408E0045; Wed, 15 Oct 2025 11:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2586A8E0005; Wed, 15 Oct 2025 11:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1487E8E0045; Wed, 15 Oct 2025 11:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F194F8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BCFB1401DE
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:14:18 +0000 (UTC)
X-FDA: 84000694596.08.70C39C6
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf05.hostedemail.com (Postfix) with ESMTP id B10EA100010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:14:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=XN7dLolz;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf05.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760541257; a=rsa-sha256;
	cv=none;
	b=SQFQiTlaW/XiOh6xcX4BmcrLFu7CPzpVp/dRle9yxfKMhJJbciln+TW7lm5VaJ8bIC72Iw
	idckv8NYozTGIP6OY62u3NWreJ4NSTgqp0dWsYBwMtL0E+hkUk7pD4057Qpz3qKgKe7ann
	8UOv2gzehMGvTX736B132Avp7fgmz0I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=XN7dLolz;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf05.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760541257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8PdHQt80eigPDJZ5EBlPY1pQSNfCt+AMOYaxY9njWE=;
	b=J+Q7MrD+6fQ78iD8cE56pE11t67vTFWSQXJOSdq6ti32g/KEtKFA4ssjPfubcF/Y0wdsYg
	QKLEcuAc7gVPFmbQgSSZ3R81SeXD0mo9cofl17V2i+EpvKeKt0GXTdnDW26KhmKaRU1erG
	4FJkT59azb/C/tLLEJiaZi2+WPBKDqs=
Received: from trampoline.thunk.org (pool-173-48-113-184.bstnma.fios.verizon.net [173.48.113.184])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 59FFDrk7013069
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 11:13:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1760541238; bh=/8PdHQt80eigPDJZ5EBlPY1pQSNfCt+AMOYaxY9njWE=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=XN7dLolzgmYMYPpg8AxvRudqr3f2lce7C+Lv57v8XFtyyzlXrX7+KqVp6ejSQE3RC
	 ItRezbFf35T3vLyabBS1b1RnKyfAkCkctiBzJpcx7TohOH3kQW8Eo3y+47ULuV6Knu
	 YmjH2S0GJSWQxBMu6lVG8Fx46llx0flAfVn+rL/kFu30B6RkudQELJTvTpZK6wOM4/
	 KO0/7nE8zzghZW2boAGMIj+3WvG/wL7QI6DEGGzv847giX4dLRRnRN2gR/mOgzVG+3
	 K3tzDOKYkPSx5IqSvFe7ajOMWyD0OB9LjZdGlju1aN2FRUCp/rR3iFJhfmWUDhsg2U
	 nASEg5ZKrF1kg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 97EBD2E00D9; Wed, 15 Oct 2025 11:13:53 -0400 (EDT)
Date: Wed, 15 Oct 2025 11:13:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Carlos Maiolino <cem@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
        dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <20251015151353.GA786497@mit.edu>
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015062728.60104-3-hch@lst.de>
X-Stat-Signature: yt8izxtmgj3jtqia1nb8htgm7amor9qa
X-Rspamd-Queue-Id: B10EA100010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760541256-573869
X-HE-Meta: U2FsdGVkX1/WUhfE7xAm5mGqlvcrKFuLua5VfbwNV9W0TGQtY/2ZRMPTfRCmO87XhgbNw5Y5KEN1f/BMuplyWnQrgqsWzcZigBt5QEU2hwUInsgv3QoRvdhmItoZYkSvGuEAW1seW2f4IbBA/5/6EnO9Jm6jf4MStU359WihKRuokd81wJTG4aRO4QOuPeuAGVbUj1Y0QN79eQBMlGeP7i0VR3trNaAFsIy5a2wRUexV32/0SZ2J/Py0TXwWMnWnKAqUZVb1jL2fZnMJQoVVwJ6VGkN8ij0eZlk5ZWkQb1EfLuxjj0pnhN2X9LbPlYHodjluGvbjhVu51EZK9uZjSxVL+VDgWddo9EE7u1S/hJ66P/rlyM4h6CwTsomQxkB1CvNZiUHns0Iqm7bbpXwQyw94PPBnIPLRnETl/PVqxQIXYvqnAgySN3ovyIgfdVw6fCdOk2z1kvLw9RrJ4p4D4oos94RWU0Zt0SfTs7UMa2eDJTKAszG3kbr9QasSxbLlyAxS0m3JfZ7YP7J8x9PWNGV55EXK+kNkcj8IrMymdt5HopVs+tqGRGLysI833kPgzdeObRrw7SnQVUuVyAp4uNSvhAwfUqJXW6VLda3wncgE7wCqVlsSkppPfcFJos8jDNb0jTWalecB2SH/3KO+mdXgeguJXWLRZre/TjsvjZjniGK541lcbrTiIPRTGos16GXqqLyWoSNB4MCc8+Ch4gC9e09jA1TWIV8Wbv5Tu+AQi6KwLS9LuTEhN7c0VxJpyNiXmq65NVHANQ8uMYrPqdFkTL+H8rf66pCeWAe69YJZh3CEd/WtoqZ7QToJ4rfGiCqGO3DriVWvxHNLiznZ/pNeQzRofNJgUf1/sPmWQwF1yGuOqQzPtrDJ0xd0Gtm0/a4NHjlq7IzElptjL0/9oM5z0WeaiEgA1nf+YH/GhWlEJM5gx0aC8vLD3+0kI7rvuODxmFp5CikA+vaeWie
 OYF1ug+y
 Dv/b9eGKU2phdT6K7v9C5zG4kIwnRpwsS6BtC6aJonaDIlLHwq6otMDWhEtdnrfZYdxYwK6J2NxcCgtmVpHs7q2xYEKCyHhQnwRoLeIFuPkKxuCmUQa1DMuMkmr/LsGFk6I+qRLUsqyXWg+1jUwchIg6hkYNak2KRQpuoIV6b+17FNNDNI+bn9OkAs0/l2J5ACic0rku9gOXMJKHf6ddKNbZJKZxBYSU034yosgW41H4r7or7hzxaj5E1yWnKkSrPud8ORT13KnIYGKk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 03:27:15PM +0900, Christoph Hellwig wrote:
> The relatively low minimal writeback size of 4MiB leads means that
> written back inodes on rotational media are switched a lot.  Besides
> introducing additional seeks, this also can lead to extreme file
> fragmentation on zoned devices when a lot of files are cached relative
> to the available writeback bandwidth.
> 
> Add a superblock field that allows the file system to override the
> default size.

I wonder if we should bump the default; and if the concern is that
might be problematic for super slow devices (e.g., cheap USB thumb
drives), perhaps we can measure the time needed to complete the
writeback, and then dynamically adjust the value based on the apparent
write bandwidth?

We could have each file system implement something like this, but
maybe there should be a way to do this in fs generic code?

	      	    	      	       - Ted

