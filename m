Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D69BC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 06:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D28A6B0092; Sat, 11 Jul 2026 02:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683936B0093; Sat, 11 Jul 2026 02:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572E76B0095; Sat, 11 Jul 2026 02:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 306246B0092
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:33:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6851BA0670
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:33:21 +0000 (UTC)
X-FDA: 84975529002.05.B783367
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D89F71C0004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:33:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPG2DeF4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783751599;
	b=bxKmJ/XPrB4Z1cyYqg20x5fc05yNAVWqnH69njOPgg87EDZ3wo17rl9CjfkWr6ckirrtOx
	zAbXoBG7SIAjsrK4BP69LF0UXdVsECXQjfMMDAAiRO7MPYxaZ9iMW/W+9ImWo7t2bab1mm
	z44VZsAubAwgwbO9jqh9dEZE+RjqR+I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPG2DeF4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783751599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IhuKekt2PQXuM2aC1ZwPWPJ0ZHIWcPpVLch8ZcQ+oPU=;
	b=vwODQ51vXIoZ26A3dvBICgneNe/TFBoEwUTyl+6bu4uPFiqB0L8c/xcNUvG2ZLxeYjkX6D
	51vJLfVxy6G1X6ka8K5hhq9ZiAZKe+o3BQ47eDxdjtRTbyc1lC3KNF6Gc8Vr1R3XCoXHHT
	9j8W9Sxb4PvTCfXjlKhenxLMVQwTc3s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 141F2600C3;
	Sat, 11 Jul 2026 06:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80AA1F000E9;
	Sat, 11 Jul 2026 06:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783751598;
	bh=IhuKekt2PQXuM2aC1ZwPWPJ0ZHIWcPpVLch8ZcQ+oPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EPG2DeF4UTCSaR61iBwMXCgHQEn643ddtwajqsHEeGX2acXFY9ki43vFQ7gy8Bl0W
	 BuXOW3LXg2kAEBfh13Hs0ZYMFR91r8JsrHpYYyQ3iVnNER02xUYKPYy+XAphOKNsC9
	 WxQoVUhR1TUlCSyiEB/VspCyJtQW/GzjedFjyCgZJPJ6Q/gQG6rVW2boHGQqSDe7fZ
	 b4ZROnX7C4o1b1i8MbQJXaxv8hBq+sorHlvvkjlhjEhEf1cNal0kos9Dmx4MMB3uPX
	 +caq0W8QPJajr44BSXmfelnlwPZUxmrKpz84RfDbyY5pbBa8+xpkhUS3UCT0amuC6h
	 49Cf5nI8dBADw==
Date: Sat, 11 Jul 2026 07:32:51 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	SJ Park <sj@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 33/33] tools/testing/vma: output compared expression
 on ASSERT_[EQ, NE]()
Message-ID: <alHjL4lT8WLrJ1uj@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-33-2a5aa403d977@kernel.org>
 <alFfopehgN0dkMzM@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFfopehgN0dkMzM@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: D89F71C0004
X-Rspam-User: 
X-Stat-Signature: toagxrf8ui4b14eh55g4tgmw1irnggim
X-Rspamd-Server: rspam03
X-HE-Tag: 1783751599-753578
X-HE-Meta: U2FsdGVkX1/W7Q0PmEwykFmrfmx0S1B+7jnFlL9IeL8VPeZ1RI8Q0Q71LITPZ+di3uEISXlz4X5btL9HS8PuSv5msLIxcAMm96Wrr0ibrTc/7TaL0e8m+00Ak5OFG+UAQcsL9GfZHdND4tsOZA6U0LBwmH4CGGo/6hUyGTKQvx8tBT2c83YqBtwIeAiJP/sgLrXrXp3Gw8CwFjW1BKIdCMjZNT7AmXXPNB6kEPK4LV6nkul8YveK4aXnSQxaKQKTs6f3ymoWDX6mUOiKIj4O9nv+DELqGbffnAJXiICVkc9/JySRa4HNaZqkPn0JgIvcEoRYiqA3LNd1aADGhjNSWLkOEJLIEbHkS133ZVNIXSxNwqzpgL1imG8EtCiScpWVZxlKlFAieZG0XhKGCvK48mR3WBv0EC+uHPcKzOqBmdP1W6Ft5FnDWIoiSs6JRHCs12P89Aw28DZMqS6PwOXMKG6hLfJbe3RPDI7ofYPb7uh6bPjOU7piG4W82Vrr3JkObh0DMp2+jI7+H2IseVDqI4kJ4YT61WKvD+ua314U4I3gGowNYNOiBX7iGpOYW7R+oMvwhiu+PjmPCnbvHQKrwlLkbkpX0Xlvz2AtLWswCP47hhDkyG6+uJTLe2lkm6YVW1DQBA7Iam3x9aKPbW0+11gYhLVqrpGB6c6UCrsLVgsW/GbDbNAm8VAfCmnDQoHOJTpU6KVKbvMvnb4REqF9IaZY50gspDXisiXyTs01Qy350gdAXZUJsVDdVGquePBwwNt+KJaoPOXqEaWTDNE6Vl1d3aNZU+ZwF32CkCavf+CCii3VFp3qdAKuV7sQ8KW35SjyiSf5ePu0f98XTZqT6yeXCivZiSUM+3YznLgqdwP2HGzHNe4v4daR4lrLOWXOXSYvAdhXPHPkapWThVKHg1UukQO8QKJcED5EZwIv3jlIATocGfZvVxqNBAmcbg4xlE3JHk3Br+qZNaiPbdM
 Z/qz7Rht
 BNkvvs3vUB5o0M2C3YRhbzJiJ2O9VKr5YnWOHOtgNvlXGFR+mJ1Nyg+VLLrzRTpnWEg4O8E1x7s3Tco3vZnqbNrcOBC6nLQ8tu+ma8Xq+0MDoaCsHjtrgQsn4gVW0nXorw6vDHxM1vM9iWp3hvAorrORinclhrF5Jot4IZmcLrhwHDLv3LMx39nD/X3Q8oXRMVbtA3pYqRwkPpJ4Xe7EjfkvlSMU3JYWd9A82RLVfeS0tc6pZJr3mC9wkRUxOinCaaaqB7bOsAD05EZVD4jMXnCnxt/2x4fEsCPzSjx73hk2ijNnpJ3BcS/3+vwjiMiljArVBSHmrzKhmuBadTx3rDXlHRHhphRAmUSAK4mJnlp7gQR+oYZPk124jD8qirRyCAyKxLnylSjdZEkiJAWmVjOKweXhyqUgBCD+qjta6zwiuNcgtfsFrMvX1iSWbeqpB0+GjIBI1MAh3Icu/rxyC2up8CJ2g1U+36GhQ0hSMiViEiBAKOi2oZdsXwQbWL2InFsrotKq3FqS5Z9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 05:09:54PM -0400, Gregory Price wrote:
> On Fri, Jul 10, 2026 at 09:17:14PM +0100, Lorenzo Stoakes wrote:
> > Update the macros to output the compared values at hex for easier debugging
> > when test asserts fail.
> >
> > We have to be careful not to re-evaluate expressions as they may have
> > side-effects. So update the code to take local copies and use these for
> > both the test and the debug output.
>
> Aw you found it before i reported it :]

Claude did :) I take no credit for it :P I guess I thought the re-eval wouldn't
be an issue but obviously when it's a side-effect and the userland tests do do
that, it's very important you DON'T re-evaluate :P

Human 'meh that'll probably be fine-ish' vs. robot/Gregory laser-focused vision
doing the whole 'Sorry Dave I'm afraid I can't do that' ;)

>
> >
> > Also remove unused IS_SET() macro.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
>

Cheers, Lorenzo

