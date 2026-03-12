Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11730106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706B16B008C; Thu, 12 Mar 2026 17:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E86F6B0092; Thu, 12 Mar 2026 17:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB166B0093; Thu, 12 Mar 2026 17:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9406B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:23:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E737058D95
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:23:21 +0000 (UTC)
X-FDA: 84538687002.08.72566F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4C879180002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:23:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EYhKsPwq;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773350600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZSrZjttw5gIUDbdiKoMciwBk/FMfdKMYI3liALwtx4=;
	b=sCBbTFyiZHqTDb9W/3DhvNsTWfpnaz+YYBGUImR/WPsV2vuw8d8C91f1XHJM73z/u3HBKc
	WMj29MYew4s4KU76jdDY9qKT/2PLiJSbR1ISZbE3L6D4vZvtUSU3ij1xm1Ci4DjRwPE8Yl
	efzREmluHEV+a1phuuhH1OvofjUCym4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EYhKsPwq;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773350600; a=rsa-sha256;
	cv=none;
	b=iPcbx8g3SVhpcPXbWObL/VA/F5PIBWrRtzMmbMpqrbn3fKn35C001n1iuarPr9NPFEuAfi
	9wIPBUkiK/dQlTcw3jFqSNv5TzW+9L/U6Zdl72JOHjJUAAaO8pNJsUZX6/Jqj66U/oxG05
	X6CPyhAnQaJXEaeaUAad0Vj79sbEsnQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3CDB60053;
	Thu, 12 Mar 2026 21:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740EDC4CEF7;
	Thu, 12 Mar 2026 21:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773350599;
	bh=HZSrZjttw5gIUDbdiKoMciwBk/FMfdKMYI3liALwtx4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EYhKsPwqoBLREVvoZGgMgVZ6fu+bk+U2fKxToofPR2Up6V9uTgSYZfuyjhIb7C3ZE
	 7oPxkujHeeUdd441hNsgqAm8c7M0uwByLtnOWXAMkXuUFJ05Rb/GBA1Y8B9jmAfc8h
	 IikXAtFu3AD5I04crV7xx4fJQZ2Bm8TZEbEULr8U=
Date: Thu, 12 Mar 2026 14:23:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Alexandre Torgue
 <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen"
 <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, Marc
 Dionne <marc.dionne@auristor.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ryan Roberts
 <ryan.roberts@arm.com>
Subject: Re: [PATCH 00/15] mm: expand mmap_prepare functionality and usage
Message-Id: <20260312142314.0f7fc516c0ebaffa6ec9fa7c@linux-foundation.org>
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C879180002
X-Rspamd-Server: rspam08
X-Stat-Signature: qb1zdyzqoaikrnirx5qrd5tw9qtjyk7z
X-HE-Tag: 1773350600-994441
X-HE-Meta: U2FsdGVkX19I2eXzRBwgM0rQrVWodtjEY09r6pfbsxPTapecxyqhZJpgySLMajAGvI4ZJuFjE/clPcgt6AjHsk2P7H111oocJqrF24FLPQPjzhuHBZUASsgZ/OfNiqxdWMPqHGJY8YdHdbN7Yv2Sr/JrNic4/0bw838Z6KJ3Eys+tqPDxgPj0qlDQwe5UJ58+4yjFliD3i5CWIxqJJBqEXC4qg7kZ6Voc8ihSpYAeTHc1oFX21MbggnqA/sm9HX09rGLB9PFb6YDv5adu6pkcDeDI6DoqYZqJTUERyDJYWp26ohexg3Ncg9nWUjnwsHvPpgnA7zq91+kaY7ZEnlJ959wgWerlaRIYtdFwCaVilnGCGPsc6+z2CqUul2fyE4fQ0wHqUjfs0I3rGuDALD9FKAfZweQWl1LjcVxpOY4IitlBv9VJAlVsOM3+sNZYoG42Pvl5RXIjKkpMBqS142RBRvWzv7fYvXyJbCENl16FfVt9rKF/yi0MBsWH7i8bR/gE+M6ZbRqSyBGSUHW9rhjq4mSaft6N9pAUyvR2BAw8j+zLPe3j9dC++PHKtDRI3CXgQfVSjoN7lFzcdGdCUI4oVoy+HIZgshJJlvARK4mtIIWTBsHo+Qv8946Pm7rdxlNScKETZ1AlErYDsZSSSMMBgMPUsyLKfHU3luel+IC1aOnZo9jK4nPEfbF/zKQAtXf1mFQWIfT7UKJOXQeGdCaOG1rzWUNlh3oDVJ83Qm7ZcdcM8VdrZVFBnn8aR2ksXr/r56+fat9CIViDuzoq1i7j49fRNgU+zqfi0tznu25fds0RU2ZV1IX2vIPaX17BfcGfSP8xDQS4EKxs0G/J5Pk+tvO+J+J7uwvP+G3k44NEJ1gk3WOlHC9L/sekdEWpkk3iGyRuGHo5HBybpPzMEAA3boiB712u5iat0d6eRVuuyxI1PmYkdy/GhndmgPT9I80DAesIwW01uzNacX4IMh
 42JSWmio
 zQzx76ZDj2LsrkMv8lGMYOLUSnrHK42+Lc02eXhjiKaz3JRNxoPUT1qvGAj91Eik6RuPqxkJjQe1rD0NFhgUXsmo5mcP4GnAAFEjSe0nJAsfqIZWfwFQQ/pvCG6ke5PGzmxMp0ZUrvAJxQUBJeVaPDPeo0b9uMs8v7rb1QqEJOVL6wE+cswdli1m/+3KrhjcDi0ML3VmBI+S/vlT7eQoLu+eyZIDg0y+f5iWz8Ri/LfmWJTvWEyV+fyP6/8OHaidJwnt9HBU8pNxyz4QN4aUXvXTq48iviZT8Af2lbMpHKKHhWtBj7gPoI7m67Bpy6P7cdij7eZ//kPNyQ0f5fC+DeWSpyV7ppWKFdmhrIYcjPJJ82cZg1OspIBxbXMzg+bNP0sCc/tE6HdiEi450KDgqH4YPvBmY+wlWHqyK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 20:27:15 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> This series expands the mmap_prepare functionality, which is intended to
> replace the deprecated f_op->mmap hook which has been the source of bugs
> and security issues for some time.

Thanks, I've added this to mm.git's mm-new branch.

