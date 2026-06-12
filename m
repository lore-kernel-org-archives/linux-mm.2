Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A4FCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 17:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D684E6B0098; Fri, 12 Jun 2026 13:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19626B0099; Fri, 12 Jun 2026 13:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56DD6B009D; Fri, 12 Jun 2026 13:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B31F86B0098
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:03:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 458AFA01C3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:03:44 +0000 (UTC)
X-FDA: 84871882368.06.6F5B4E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C8F020018
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:03:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=itH55TE3;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781283822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwPb00goa9neMhnO3uK2pLz1hA0oe5oy8FoictjDQao=;
	b=B6wDkQ8Qmcytv5T78ixeDLRB6/AuaXcNR1h8sigPiOnWpGdIhddaG5lWWB8DcGz2jQLlAQ
	+Xdmh/U4aWt0Ebng9/JZF01QQGH0X5B7dfzaZKOaa7NTPT3CFuOPcFaWjVU+oZCcDNmsPx
	5frzEw9/OjmBaFutCKjOM0ruke5ePcI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=itH55TE3;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781283822;
	b=SUWXayKuuD8GYciNiaw76tavNT0GQqxFZ3P5m1obKMQFmcz9JsAcPmCWHd9f8HUDoPErsp
	LrWaIzAqvucfCgfgWrgueq6H9vF9Hh7VT4Fr+KYRqdwX0OWJ+xVUEGXjfGjEgtikHkEDrj
	GV8gZ8HDYxkWembJCbdqSfKIGkxtcik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1C54601E1;
	Fri, 12 Jun 2026 17:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C16D1F000E9;
	Fri, 12 Jun 2026 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781283821;
	bh=cwPb00goa9neMhnO3uK2pLz1hA0oe5oy8FoictjDQao=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=itH55TE31Vw9PM1BjU2oosGYS40FegVM1Q8hy1iOodrFz0/baAP75jQaixwzd49Mn
	 9Q6twOCs9iJePz4HwIOqKdefPFGIX4RbG1gV7hna9jCbfMoh88KnIbgwEtiNJ1qbkf
	 b0nZlLaXtQaLjoaCi6q9VqEcSgYJhO8sOFO+fAl4=
Date: Fri, 12 Jun 2026 10:03:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shardul Deshpande <iamsharduld@gmail.com>
Cc: SeongJae Park <sj@kernel.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Docs/mm/damon/design: fix a typo in the Address Unit
 section
Message-Id: <20260612100340.1243b191c643f288e1ce211c@linux-foundation.org>
In-Reply-To: <20260612154054.720363-1-iamsharduld@gmail.com>
References: <20260612154054.720363-1-iamsharduld@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7C8F020018
X-Stat-Signature: oje53kbagb4zohnqf9rnn93j7wjesf4y
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781283822-325909
X-HE-Meta: U2FsdGVkX18AG228QIpavzQg75Ls57rtKVJAtQ/ox8sDQkVjA43DZnN4oYyrY/T/5hP9+iTs3KKvEZZVZZL6zZgUh7v7kgtnhwHI3CH31uIIjORwwjQioo87XYpPbAne6r3GYo82rHGLm/1oczj0Q+ex9gBMwSlJsPWYYg4k5d+6wMA9yTiCfeAdrViqmCYAwg0swzOOlqK9WYjdJchHU9AeEXIcR3oARSKGlnh5husKesambtvYkNnPpdkN7f+QPALP521tcHwY9J90lB8cfT9SUoQDIiXWAYmB422oys2HB5IcwkcqrhkFvOY7PBl1uBsR9MdJu6Kazu1loWebpm/TNZwHdLPBmz/+d7PcTkIBo0NlAJ4z0oEsRXQs/T2oOb4s5jdY1awokrQEOOGd/J6MkzHaeEiVP120/GMXi0TtuHbIk6euztCjVHpj/237fLkSmHcOT4oo+jltHk9sdjveKj/nizx6LZfPsiZD/oDUEL/FMRQW7GjMiBjc51ab11LFeDA+8YMxQhuvETg3oEwHVl/CywO/VL/BGnulxbqEPNRO55acqREs2dPoAHDnembode9R9tnE3yUvReCOGqs2kIhYbAax+dWI7GblR5xjnPCDkKhIjuPqoct9bg//3mucHEPJWeq2OrsFqHfhhsbjZJchjGNFrUPilw4b3yGNb2tisyYHA+yLJH91pwu1ADUgYszV0OwxLHAHQQDtC7ZathWxsusdEy+iF4uypVE1VcvvbQBwE+s1lKZruxf0q6iYNeE5Vpi4Djlkb40imhTGJiN8yTUITpMmtV8XGyDRJVnbeSPQTo+qHGQFJbslFc5kwWS/SaJ+RNbGUWuArYoyrU8Wm2z6JxI8bwn7ElmAY6yXrUtjqylWlmetC7CCRSSs5QeYVm8dLZ1SkXG8BN4mGiVf6tvpePoQ2fxD/RfvV13UlsOuSyc0MhBKm+GuY6dq6WB4Zd3jqIlvzgk
 mX8McpD8
 GehQmXY3hD2KcJX7v0BqLDAb/tvO7tqZf+3YsyalUUUJhObRjbphu5MvCnVO/5CpRKApbroPrbkUNuxZepoYax1xx3ZytnRoLriG519r+Jw4+QGIdZ5QUxqZDXakPyu+Qip+BBCyPNozWHXSv5u/+8/cS/OIgD9st/3bJPXA7NiC/Sqfpa2U97AJbwrKenl0oxA17mrvShtQeAItn+G80yyBs3jNmtwAd/V3pqpDrXFBRGgwEK6PbA3y5qJcWAkNrOxTyS1yCIMSs3Lr1in5rP+fJcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 21:10:54 +0530 Shardul Deshpande <iamsharduld@gmail.com> wrote:

> The "Address Unit" section misspelled the C type that the DAMON core
> layer uses for monitoring target address ranges.  Correct it to read
> "unsigned long".
> 
> ...
>
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -140,7 +140,7 @@ as Idle page tracking does.
>  Address Unit
>  ------------
>  
> -DAMON core layer uses ``unsinged long`` type for monitoring target address
> +DAMON core layer uses ``unsigned long`` type for monitoring target address
>  ranges.  In some cases, the address space for a given operations set could be
>  too large to be handled with the type.  ARM (32-bit) with large physical
>  address extension is an example.  For such cases, a per-operations set

Well we don't want our longs to be singed.

`grep -ri singed .' shows quite a few typos.  "assinged" is popular. 
Perhaps you could prepare a patch which fixes them all and adds
"assinged" to scripts/spelling.txt?

