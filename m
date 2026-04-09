Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48DE0EA3C4E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 13:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9C66B0005; Thu,  9 Apr 2026 09:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A736B0088; Thu,  9 Apr 2026 09:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480AE6B008A; Thu,  9 Apr 2026 09:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A83B6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:23:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E0B71B8456
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:23:12 +0000 (UTC)
X-FDA: 84639083424.06.7E84210
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 84ADDC0015
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:23:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gAVlBbSw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775740989; a=rsa-sha256;
	cv=none;
	b=K71U6duGSSURnv5hCFpDsBTjVjEyUHPeez+rx8eS6RAUphbyXRYQ0CCdWY/ASLpnCm9+VE
	M53UnHLeOJj0k0AqofXp884Lhu7/s82tZEeQ6oDPHM42Y3tbMZIUrex27AeX10FI0SLPZq
	ivoFmyNO0bP7NAQ2afyui4OFgZzaoDI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gAVlBbSw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775740989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XdYAYQUqkQHKX6yKOZdjekTpsk8cmhwvmdhU46i0g8E=;
	b=4SRY/LgRSrJd0jl736qZBx1IR2Fj/cBdK/kkKiJWhaxD3tuU2BvK9AdozB3jYr0hk5NxZV
	nhu9aUktR8y2fbQezukZ/1CZXirCzUK0tdsqu98MMbh/Ea+bt2G1wkDi40tUvPGEz7FDek
	TZL1BaN5Gom0vW5Vn52E9ctcnlBj6QE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C3EF40962;
	Thu,  9 Apr 2026 13:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9666C2BCB2;
	Thu,  9 Apr 2026 13:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740988;
	bh=tqL1fimNDWlyLrxDSkoymopCMl8WNimZ9u/t901NIq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gAVlBbSwQ2EhjlAwBlMNJeosfz0dD/8/v41ae3TtdzbJ4z1x3dD4yTseDt0lVJtuY
	 bPPpYhmxSCVZyjh7JC0K0y5Dw2ZboOV+3v0qtTJfhHkOkdo8tkm1dRIIKCBDhYcCpw
	 62TcG886O1nJQIEV5zQUUb2JNYXEHY8UDWiHHh0habAexbRBhLpAkYw/Yf7Fu10JrT
	 6yEawp4pnmL1Vrsjz8Iq4dX+w+XzA9pmI1rgkQ5grLt0pzA3IDL93pcxKo2fB07nfV
	 2B7unxdgFM/y+9dQ1ApQeXfmvZtOnpQkyjMNYFbiVx96jPgwg8CrxgwCTE4Ymj7s9J
	 YKfVqZs9BLKVA==
Date: Thu, 9 Apr 2026 15:23:00 +0200
From: Christian Brauner <brauner@kernel.org>
To: Anand Moon <linux.amoon@gmail.com>
Cc: David Howells <dhowells@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Peter Zijlstra <peterz@infradead.org>, 
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, Douglas Anderson <dianders@chromium.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
	Masahiro Yamada <masahiroy@kernel.org>, "open list:CERTIFICATE HANDLING" <keyrings@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Subject: Re: [PATCH v1] treewide: Fix indentation and whitespace in Kconfig
 files
Message-ID: <20260409-kontraproduktiv-sterben-034defac1e79@brauner>
References: <20260407053945.14116-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260407053945.14116-1-linux.amoon@gmail.com>
X-Rspamd-Queue-Id: 84ADDC0015
X-Stat-Signature: 5b3ahb3b7tjsaomd64ih91qt8x3i1e3f
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775740989-19276
X-HE-Meta: U2FsdGVkX19sDgcffxshi7iDH1eBCQ92S7Q7UOPXMkMmbZrEXGLjuvJ5pAQukwh4MSjbqCYFSHLOMpddUPvvsuYcaV3jufHuAJudyTHW3ztrQ08VS86/dhlnkTlhQF2ixWXdUkrzDxQpbnEPlHZOz1rxiMR4zLQHtmxv1Jpl6GDnvxX1QPy0lReQGIjsPRxg7GKFBXhxyx+KV9WyXZEihgYwCU8D6w/hr/HYWDnch9OczMPO1Mv5rWFT+H4vZOOB3EzedE2SLhwB2pSRtFpAG1PgNSpIHRuDpwb8V9eCaK8VMJeAIOWKBeZLdVlz2mnV/bkxGlcb9ovolaYcpl1byv4RnD3alaLqyfWLJx1EzGqUDPHnhCvoLxE6NnBR7lA7PKb6pz3cyY9Bu4UOf4wXHjlvoEz+jf+G2siq/9Dri+29c60j2XaszeZViqp11qQ9w/ImwpW/JfJ9VcMbTv085fSMuO9wOvZc14C3pKX0N62jGt0kUN3l5kdO5fr7ajQrmmgBcRMFbAhaJ63Ft7GJDsnjkrszteCFufWOjcYt38Sl/HWYy63dGlI7XjKMnFRw/66gHYclwdFlKLiWST5hmYwRYkRtyeKNTGcxHmLRNeCrgDg7qDconn61Cs6f1cwY/6PdGGAzuYTcmeSJh8/mt0uYlnZm3wH5BmsntXHBOH5PDw63ARDu9piruii5zUQupgqUE++emxtlixtXvEZhbkHSoVxVgeWOkwpWgy8+exSP27h4l+5hxqlwD00jB9dXEAWVdFK4sJRE4Z4NbTlmd/Ao+d8AoOH7QwfBkMYwJgxaunVHGx8MqX+TbR88pgcI9C0h8m1vlw1JZPWRD3TA03KGcbgqYyZnTH6N83Kyanx7DTe46TvDjj4YncRPNqAJf3vt45GpHqORl9p6IMpClHVkzAjUKeSIqC+74pn/BhW1SbGbijkDqV5bn2YqIK9b9BvkV3GqL6wo2GOX3qy
 LhDCmwcZ
 opuXMQRSTtrfYk91AyvMR2bf0jr5ZNkSHMCr1g+DajrKOGQgSUbAM3+UZwtyoU+vSffCOS/Sip79pw2fONrc2icVRJxsiHMf66RdXv88q2wGaTiMB6vm8M9XwgiiuEZFiQewpiXKREeIgsIf4cxCDNFDhb4EgGwLT2/aaqZDcGjhOb4EXDS3p2k2/AUTJcuZQ+dfVYBd/eVsuUbOSC0noi1e9PGcSYFMrORsT0jt+sJvW/kMMW/1zCYoFEbXYXoQin0RnQNorcGwFBPW/4zYjLsoiCxK+Mgy1NXuXwoRLLVR0sFNCEz4Lib15G3vrE+yohW2n1v9S6ht/T19iSZn6IXGCJMwsNr92dAM/PhJDWG+WGNbwqjyGYhCQ939LG7n1IzTPXgvZmSlzsmvnZ4afJTWzoZ1+iFYrk+Ny
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 11:09:34AM +0530, Anand Moon wrote:
> Clean up inconsistent indentation (mixing tabs and spaces) and remove
> extraneous whitespace in several Kconfig files across the tree.
> This is a purely cosmetic change to improve readability.
> 
> Adjust indentation from spaces to tab (+optional two spaces) as in
> coding style with command like:
> 
> $ sed -e 's/^        /\t/' -i */Kconfig
> 
> Signed-off-by: Anand Moon <linux.amoon@gmail.com>
> ---

Sure,
Reviewed-by: Christian Brauner <brauner@kernel.org>

