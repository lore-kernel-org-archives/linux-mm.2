Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31230CA5FA5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0FA6B0088; Thu,  1 Oct 2026 04:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488076B008A; Thu,  1 Oct 2026 04:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C45D6B0098; Thu,  1 Oct 2026 04:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1FA6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:05:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22218160346
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:05:46 +0000 (UTC)
X-FDA: 85273323492.13.9FE122F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 92D9A40005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:05:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y9/IDkVg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790841944;
	b=m61qFYqbRnspy4HPaexhwNP7YLFMQIlHlNC/2J8md88C3TWkZVjDCTTbd7leOZtehK1j9u
	8P7BmmrGetPvN0Cm+pZf1Qouldsx//jdyLzCFtDQywsawrbDl2fbdaDtZuayfNrlEKiJx/
	sy75Z/yu63BgUqfx7FCUSjG3dMnbC/E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y9/IDkVg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790841944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGdqsABiHifezL69EQkKgockADvH39dMNn1MkutZUlU=;
	b=w8fV0nBZxsl51FQ/AsGzrbLdGbKtPhvRIdqwy074RgAh1YH9CvjUR4ySjmKKKDhZMlfcx2
	Tq2Be0O0ia9PoTf0MT/1zDJe26Ijph91NY9Ossmm1H/9ojQwHE56NVclopj1HrJElf7DWR
	wHurcMFAAb4gfpJcEuIPSS8za34xtcI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43ABD6022B;
	Thu,  1 Oct 2026 08:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55FF1F000FF;
	Thu,  1 Oct 2026 08:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790841943;
	bh=PGdqsABiHifezL69EQkKgockADvH39dMNn1MkutZUlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y9/IDkVgxh7FvYe+24kJvQV30H1sGhInXRDF37M7Id1szihp3UUzg2Af7pGxKy8v+
	 HmqWMx+3VUhxt+M8xLrTB40t4tZOecSJ/CaSmxnieoT7VolyewNLt36gBG9IMPiZ8a
	 mkhs1P/pZspYG/O/U4w+wDrWInsNWatn1RcmcGnPWhxZJ5Neq+4v8gP4WaUaOUePha
	 RZFHQOmfYZJbi86cAgWcKB8u+Uu7qiIOnXuQofDqZpqlLxImrb6zRoNfLtellzvYqB
	 zyCvJiiVIP7XGhSDZz38TriJrMytpfoiRvcpBMuBNxKw2ePPxoDwJfGLmodU6eVr41
	 6L6Ni9RdVgNog==
Date: Thu, 1 Oct 2026 09:05:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, stable@vger.kernel.org, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH v2 0/2] mm/mremap: fix two issues with MREMAP_DONTUNMAP
Message-ID: <ar4T2vmGD1vZfAaI@gremlin>
References: <20260930-fix-dontunmap-partial-self-merge-v2-0-f388985a0f0a@kernel.org>
 <20260930152139.e8fc193b9c2880b625fda814@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930152139.e8fc193b9c2880b625fda814@linux-foundation.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 3zobthrb7rxnxwzi4rcujy8if1bb1xch
X-Rspam-User: 
X-Rspamd-Queue-Id: 92D9A40005
X-HE-Tag: 1790841944-592058
X-HE-Meta: U2FsdGVkX1/GHtxVQIYcmmelqyuQiBBJTpRtqRko9wGkqcMRUJjJUNQzRiEX2IGviMsuXEE+6Bk1sKZ0oww2m8o3L4TSsBd6nHCU46UrwvtxkCqQkTOofmBpr/6NFvdXJzTpUVaB4twrXMUfnssBhlA0t6Pm+YdAZtp0iUN7v8ZCDy263l9dkxT9OTOsEPpUd9IhpOdIndbe2VnFVaJ/SCDFZ5CCi94Y7YO/O+idTNUVC6VD7Pdjl+aOOYk3KRrthprklxb4cPXPTi3xZqt1JypvMBdwaW5RguMAq/6aDymye/my8L5WnpAejmBsBT9OzIjZY4qBo3RGFShSoHBlN6BTzzFMLDkqCq85exy8Nj4SiCh7M0uf2OWe9JCnoa/hKm0FIwLOdSlWuUe/mm/zhdEiAcqI6SiWWTve0Js+BRt3oeTx8wh90V6ZPuHC797af3Jit+P3gJPwgB/8wImyrv/OMmAiueXEMkATM8YmvUaT5Cyc3st1slO0shqowELjquXgh5MmtACO5HSOk9lOdXfQP+a8qLy5O0sb4AeN9q8zNKvDa0I6Lp3j5xwlE7SNeMzmY4oyrOCQR+Ga5qlotecMYzSvdMbw95p8pL4ZRCgrOSg+0m6XeWFGLzGNOifDs5spC/+L6kXOw61hNcU5MTAnGwyaKyJfi29zWwRjRIQeSOzSf8JMgDKm1rdGveELhXM8c5hmL1TlqFuUxH9MfTRrh0OOxIiV/sTx+LAsxS8DVtdR37emE57aQpXtSU+6MZ/x5WQbT/6g+FBb63eor7xjVwQvJzKzBtld4AqduNg2GQjc++vnBayVll/y5deES+g0Fo4v4Y593/m+DXEPRkO7SrUPFYN8ZmFQiU5HHi+eKyDDKG1ezzceuvv8KCDqXlxfuYrzi7OjNM7HLnMRm0geKXbGq4q2x4INUvlc55xBej0kIRiIYq51loePDtE35R1QFI2SnYFf4/mvKdM
 uqQ+kCMz
 7Dkauvc7f4aoHGigkqJ4hdXjBd6U5XBokBpTpw6Uo3v8n0xtdmFzVwySheZNZBrgdeCmKIoDLMI3fK4c+udfEP/KoPKKdJ4kxP/53I3B+npuYbYXO2c3vNvKRPoeuJnNqKWNtSBoYl70f2rfyK/ZqxMJKK9Dutq1LXajU2mAOaC+R2JwZVuS0eytBKY93vZf4UImlxBUNZjb8qYI53IoIvGDJaA5WaF0EYDZPyniyCpzbmkEhGRvvsBm5e+A2k+G/zw/XdqJbnjDCtwci+DRi8dGjyU1qZSHKEgqCNOMyG7g11uI24nWEk/J8xY4dWQl29K87sTRbA3Td+rIQsPCppKZnJGVkDloYDhY0Otzr0Qp+Fq7k2PfBvuPCpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 03:21:39PM -0700, Andrew Morton wrote:
> On Wed, 30 Sep 2026 19:47:08 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> > v2:
> > * Added tags (thanks everybody!)
> > * Updated 2/2 to avoid splitting the VMA if the VMA was not mlock()'d. It
> >   is only meaningful and necessary to perform the split in this case. This
> >   also fixes the proc_maps_race selftests that broke, as reported by
> >   Anirudh.
>
> Here's how v2 altered mm.git's mm-hotfixes-unstable branch.  Quite a
> large change - are you sure that retaining the tags was appropriate?

It's not a large change conceptually.

The dontunmap_complete() delta is just reverting it to what it was before.

The rest of it is literally just checking for VMA_LOCKED_BIT to avoid an
unnecessary split.

So yeah I think fine to retain tags.

--
Cheers, Lorenzo

