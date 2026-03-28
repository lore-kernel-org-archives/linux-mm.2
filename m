Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 487BC10F3DE5
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736DF6B0095; Sat, 28 Mar 2026 13:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7A26B0096; Sat, 28 Mar 2026 13:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624CE6B0098; Sat, 28 Mar 2026 13:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52E396B0095
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:48:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EB87C0618
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:48:56 +0000 (UTC)
X-FDA: 84596207472.09.0E91F2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D886C0004
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:48:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CSnA9ZUk;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774720134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/lt3q16cpnfd1l4gOduXb9wBJxh+BR6A4O64lMuOLk=;
	b=D7OTvuStXAVZPZy16SscegNpX6c5jMnPDlYykWGR/DKWGWA5dFlFyiPigzSaYaPENI9b7z
	W666bcPY+Ws6EmAPK88fUVPYkZseqFQzxcpVVfy+EDwUhnNjbspokJlFPi/FE2fiaTlL5N
	v5ao+pBtDE6qRf/lpHparq8lyztR/eA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CSnA9ZUk;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774720134; a=rsa-sha256;
	cv=none;
	b=QW9noMXr/2nXhetuKAffeAYBDNV5vFP7yLF1FJ8RF4C0qL7VlX23bkS3csNyhg78UAg0u0
	Zt89CN5FCA9EEaaXa1ZT+4EHOA8abmO90hwzE6W5NWkx7r0F2MLA4Ub8aROGRNfeideo8W
	4YLpssaS6Lrq21IRUFFkFC1WR3tYe7M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06AEA60018;
	Sat, 28 Mar 2026 17:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C1CC4CEF7;
	Sat, 28 Mar 2026 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774720133;
	bh=Sg6x97ANd8tIFA08/jJ7hgyZ6IOOblhEz9ehxsJhHE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSnA9ZUkXUKgtI3r1nzkCgxnw3E+Ro571tGR8EixYrLYzvCdHdVOhSDusXh0Qwl8N
	 o9peR2Fib9N7nsvBHy9XjVrzsQOBkbSoK0hPExVvWMR36AzLy/F7hxfKRItBe4om5w
	 D0wr8BgX7DJcDwmENuxCtrZOdpdxw9deOOTykhvYA0o06mnA8Wj5m8lcNvWG5Gn7D2
	 aEsEYvhFcGmQvriiHQeW6oxRpXJTf3TTqO6icqJCdzSpz4SyJWvLJPdikz5WXHOczt
	 zzsNO/T+hQBePKxLMs0xHrnvmLngBxNEZdp6XKwhERI6mnoWrCLMUbay7uvDEBQ5qx
	 oNeXUHXD49PmQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: Re: (sashiko review) [RFC PATCH 1/2] Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
Date: Sat, 28 Mar 2026 10:48:51 -0700
Message-ID: <20260328174852.53338-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328173446.53021-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tou175es5mhn5hxtsjebohbsctin58pa
X-Rspamd-Queue-Id: 8D886C0004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774720134-643239
X-HE-Meta: U2FsdGVkX1/vt1kQgYWxaqSqzeD1S9gszDPqauxn62UqByLydxUEWwci+AXCt1SmucP6kzCql8+0lroLKVBGZQbRLIjmmt63oYrn+JeOPh+bB9NiOPMUBX3bZCSwv4HzD/yiOL2u66jrB+xEGlgKvFSQTMxmjtIg5BB/Lnc1dwpvHvjP3tDGbmIPp1O69sIaQ0DQTwdp2yvD9zry5xSD5/Cj8dD2EbZVZmAm9F/n4srmEP9eqls+NB99hJZe0sCjVqbaA/QGkchSbChllz6iWr/pueYZzHTgeqdHktKMKy6pLXoSqaUkpUIjDnqIZdUgUI2GutAnKWS9eSd2mhRcePuzSnxTe5v8ABKu0+f5PEVGoaEQrzbiYlyfcF9iMwpM1D+nvdYWGjAkyxlR4UD+vB3OkxaQOhBPhP7Vmxkm+VGWUoh6Ml+vHl0ZwZMSRQLzS0ShyVXSYMU6xb9vebU9aa0w7gzGHe+WB+pk20SYBeSr+7n5GrqdDniioIAycUc7PwdHud5dMolBmOLNpsZhuO3+2K1J+AnY025H1VnM+/TSilQ9+e41nCKjTqU9prSkwCDr55H+b1oeu1PrvIu2gQF7YzmerxIcNiVuTHOAqJs8u8iES08Ga4gokUIkJ9HIIEfzt6o5l/WzQvxQqA/M59WTpC9U/6UcllplA3FtOSaq3/mE1POT7YUvWR9DFYCp3hJuwoiHpdxKiH6srCIX1wYm1URTJfRc6WZu34KnsJHkVGGo5xz0UKBiwP3sWXPcKTdgmDrvShhqUbuvJTIIffN3+dIC5WaMggfbk7+fx7i78nkvuTbImDUXgQK7hLroCNWbyjhA6H+gUuY5hL9jyHIg2XsKNYLh8k72nINTj0seSn0RF4DoBSFCkgEHZWN5KRHekh0TgyI2ZakJv8ZTvTF5JVZdGf6UMoB/NArmfKXi9MjBg6Zun+bG8acDPW6EPJ67BqEk1G71oPHJwnb
 ko8SS1fW
 w6wWzy0+0DMKBO9D64jyeCn4mEQsBRPZUj4f3aVq69GmM7mTD/KObighQ/mEcQm+hCWwDo594kUEQ5qCFi4Sp/SoGKaw/q8WNmd5znpgw87LDQc5sJ8f/+NhMztv4Fs+KXciVBX96ZovYn4qrtozbRVno+PHLXOnwA5CaNn/FxqL41hZloLmQnLMqB3rnyA66GbZIWvyorFbFaEkn5gptcgtuq9mkEqJhUlGoh7UunGyTCNjKkVpYkzU6XfKvc0RZGqQGkMXyVTROKceBGebPAHlUWr3IzXuIOqk0gT64oLYJ5aAlob3Nmzww7GSd6xq6C5yEbpthk2PU4QiCcASObJmxIol+osE4BTb4xQBiE5Gr6jmmcwnGXnPmp+XYMrm9bFJ1oeNzgjcxs7pLJRpE7itwXvUlOAqwHrwfBAS1dcf5IiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Mar 2026 10:34:45 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260328172415.49940-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit 8b189801fc104c5ecc412454a3d8db6a3faf27d6
> Author: SeongJae Park <sj@kernel.org>
>     
> Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
> 
> This commit adds documentation warning users not to write to module
> parameters while commit_inputs is in progress. This warning is intended to
> help users avoid a race condition that can cause undefined kernel behavior.
> 
> Link: https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org
> 
> > diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
> > --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> > +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> > @@ -71,6 +71,10 @@ of parametrs except ``enabled`` again.  Once the re-reading is done, this
> >  parameter is set as ``N``.  If invalid parameters are found while the
> >  re-reading, DAMON_RECLAIM will be disabled.
> >  
> > +Once ``Y`` is written to this parametr, the user must not write to any
> 
> This isn't a bug, but there is a typo ("parametr") in this line.

Good eye, I will fix this in the next revision.

> 
> > +parameters until reading ``commit_inputs`` again returns ``N``.  If users
> > +violate this rule, the kernel can do undefined behaviors.
> 
> Is it acceptable to document a race condition that leads to undefined
> behavior instead of fixing it?
> 
> Even if the module parameter interface is restricted to root, user space
> shouldn't be able to trigger kernel undefined behavior (which could lead to
> memory corruption or crashes) simply by writing to module parameters
> concurrently.
> 
> Should the underlying race condition in DAMON_RECLAIM be fixed with proper
> synchronization rather than relying on userspace adherence to a documentation
> warning?

Good callout.  In short, I agree for mainline kernel, but I'd argue this may be
enough for stable kernels.

That is, I was also thinking in a way similar to sashiko.  But, from the work I
realized the amount of changes for fixing those in stable-backporting-easy way
is not small.  Also, given the age of the broken commits (5.19!), I don't think
this is urgent.  And again arguably, as long as it is well documented, letting
users break kernel when they want (e.g., sysrq-trigger) is ok...?  Let me know
if other humans have different opinion, though.

But for future (mainline), surely this have to be fixed in the code.  And
Liew's patch [1] was initially started not for exactly this patch, but will fix
this together.  Cc-ing Liew.

So, I'm suggesting to add this documentation for stable kernels, and continue
helping Liew's patch for cleanly removing this awkward behavior in the mianline
and future kernels.

> 
> This isn't a bug, but the phrasing "can do undefined behaviors" is slightly
> awkward. Rephrasing to "may exhibit undefined behavior" might be more natural.

Good catch.  I will update so in the next version.

[1] https://lore.kernel.org/20260328084524.5451-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

