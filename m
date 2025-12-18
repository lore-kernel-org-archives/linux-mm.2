Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB1FD68BE3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6086B0088; Thu, 18 Dec 2025 02:12:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A106B0089; Thu, 18 Dec 2025 02:12:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4665C6B008A; Thu, 18 Dec 2025 02:12:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 311B06B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:12:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7B975D396
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:12:05 +0000 (UTC)
X-FDA: 84231722610.25.6351EBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0675D4000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:12:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=palhzTLb;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766041924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3D+di1Je3qZR4iyk0R8DRY9gL0g1/35US7wKZl3x6Yw=;
	b=b1Q6vVTdkEyxHdOz3mqEw6mjtvt1/tgVYDSSJTm9XNJoweObUB72BQTy7/XI1dietkTp2C
	SJsT81opUV5HoiAYS+YVkXOoiYkuZhJrYxpFKBuZLNI0FNEodDAJUjLgRWvrXMhQz1TE74
	6TdRe3e7kpLcUibCMzBHDaKrIgEWNfM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=palhzTLb;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766041924; a=rsa-sha256;
	cv=none;
	b=dA/PRld93Gn3wwu0YV9wA5wyJvWi+u/lsAu5Qoq9qoOlvmYrJYlqJy/EWNJXmCzZ7oorNh
	PLGXW+GbpQ6Utyqq2c/Tmo57MbIlpwv1Ct2lHCUFPQV+2c0cf1MMy9inflKiSvv4y0hC9W
	bZNqopcU7q47OV4Fz3TTlYnR0pcn8ss=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 65806600AC;
	Thu, 18 Dec 2025 07:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FF7C4CEFB;
	Thu, 18 Dec 2025 07:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766041923;
	bh=eaV6vluudAHtjLWNiyDXoFoLoPIaqPnfRwyUT1oVBzM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=palhzTLbgkFchjBj9NEm1y2UtB0vAj0Hdms0FFq3DYfMHhUwPvJpGc49F3seDo5jI
	 HGEerhaXjRKQXirYAfDJZB1jX3ePhSrvz6du2TXwQ1Ex49uJlLxDA3aEga9EywZQJh
	 nqk9lfrAqq5Qs4ysO+fJo8SeQYcRKogEPym/5daOvz9djuY+sFP0a/eO+ZteA0f3F9
	 onsr+AVGePwjszqbf4KBqff+FPTFH+g6gFWUmmXRbkqjDUJKFcfWHt+bLiQ8z5cuWt
	 /iCg+cVTScTsTPOTLvYh3fySS4ukio5UHuU+yyPPEaXG9G4jcjKUdiNeC09xRMw34I
	 eP2sdxGzRVI4Q==
Message-ID: <6559e53d-e940-4989-8bd2-de9a6cf9f62e@kernel.org>
Date: Thu, 18 Dec 2025 08:11:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 1/8] treewide: provide a generic clear_user_page()
 variant
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-2-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215204922.475324-2-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0675D4000C
X-Stat-Signature: x1pnmqsassaz8k6ojaosq9fpiwfnux57
X-HE-Tag: 1766041923-831140
X-HE-Meta: U2FsdGVkX19UxpVWIQs7VHEBSQs6cnm1L1X7P+/32HyTiJt+lzuPHe47d5VLkUX3JwFvaI/r/J8XPkIRgCP4mfTbI6v5mgv2Ju299mMqs352nXYrogmkouNiMDGS1iWjkpf3UYKrhSPoFzaO3jpYNBoKkjRgjmsOydizysgwrj7oNWPr5GKWJi4au/TwamgYCbyxTkz/f+sMnD/6xJzObbwtEnajfLv90zPawxkn1PpR36QDUI78cTcN3v4A79CHGrpGesJvGstJcJu45PqRfx4Y7hpR/D7iivSqsmKoFSe14ydo0fEra15g9aqkCdggiVVq5v6WHHrtzBqqe7meEjfRtFqiogygGG3FqX3pUH/4aRQoex5IhC7Iv7Q7xvFPoPoUWOWMYkHsYgSzSq6WuZcZyOtslCIO9ueYjNpa0sBA8ZAJ2iZxO1XWrxwCjMR4bfkdMT3uD+z2pfIWY3G8jXkmajXFIzitJPVQe4aD4ex7ASd8ufxf/i9os2VYO0oFUbNEvm3XeBPuXcoxDP49+/VQq4hXfpQ0G0EpmNA7rO5bQmVsamttMeQ81i1ZDlMgKY1gt/iG7dTJPj8adm+yPbFpUolgTve3MpgSaYxrepNUthHHxtda+G7KB88y2siRpj6n47GOQzIaAIgYv4uS/9WvLzQ4g45xUXjgAVErDayrRZ4cYIo/eH1B3zbEE1g2lINiKeKAQ3j54ZQGxUucjuj7Ef4d6UTnQsGrxRwzhRICvhabNuh0ZX1p+TX+XNogX2CK5jJ85he/yrDVw/+zQmjYYR87vYwOJe6RP9qdSJnVdiD3QgBlEcV8eZmr1ABIrDrwlOQP7TSrWb/lzu+YU3RDabWgcmW8doyrC3CaLNwFIGv0DX3HzM97B7EI9jusBUqNc5LZ6YjCN+WRGfMdfRBA5g0n23EBKDH3j6vSaAqhg3y/1bbGVNgyVnHLQzg88mzMx98OAWjT50Gg1EC
 pzuJwfdA
 xE8O/PuEveLv3FXzZgcnuOUL60zqNWAVSpI7ZJpX9uIA4yP+DN04damZzgdmRiwBmyKheqtxf+5pd39Md+/0e+njZjcWfgsG9XzoEJqhclndh2P2bbjftZnbAMx1Hl17rnykY413Ht6rMvYD9M9ELAmfdoIXvmXRZa/x0MiDF0JzUzqb++USneU7WBAOymocLisHKlnP6jRMXTYEY8/4lHCzgTi9aGHqDM+N6/yHPO+1oh3mWJpmMhcEVHg4gkFJPTOndeAhj8kvQ9s3s5fQULX0gmgDrdeF9MFMK1oOuCPrxLH/3t4kKHvG8CarXPUGCz5QtuDn2xiPGApjVzt/W/xcWRqCU2OqLuO/8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 21:49, Ankur Arora wrote:
> From: David Hildenbrand <david@redhat.com>
> 
> Let's drop all variants that effectively map to clear_page() and
> provide it in a generic variant instead.
> 
> We'll use the macro clear_user_page to indicate whether an architecture
> provides it's own variant. Maybe at some point these should be CONFIG_
> options.

Can we drop the second sentence?

> 
> Also, clear_user_page() is only called from the generic variant of
> clear_user_highpage(), so define it only if the architecture does
> not provide a clear_user_highpage(). And, for simplicity define it
> in linux/highmem.h.
> 
> Note that for parisc, clear_page() and clear_user_page() map to
> clear_page_asm(), so we can just get rid of the custom clear_user_page()
> implementation. There is a clear_user_page_asm() function on parisc,
> that seems to be unused. Not sure what's up with that.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

You should likely now add

Co-developed-by: Ankur Arora <ankur.a.arora@oracle.com>

above your SB :)

> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>

Skimmed over it and nothing jumped at me.

-- 
Cheers

David

