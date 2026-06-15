Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E56BCD98CE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 06:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3D916B0005; Mon, 15 Jun 2026 02:25:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7556B008A; Mon, 15 Jun 2026 02:25:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F216B008C; Mon, 15 Jun 2026 02:25:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9409D6B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:25:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4103A1C444C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:25:18 +0000 (UTC)
X-FDA: 84881159916.11.7C6F73E
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4290A140003
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:25:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=packett.cool header.s=key1 header.b=ircNaqFJ;
	dmarc=pass (policy=quarantine) header.from=packett.cool;
	spf=pass (imf09.hostedemail.com: domain of val@packett.cool designates 91.218.175.179 as permitted sender) smtp.mailfrom=val@packett.cool
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781504716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIagr78v8+wu8I0zN50DJ/gAtpHtsl0YE4lvqsZn4bE=;
	b=dMMV56FmuW21HiIxlwRnOYZqTNB6lT6FMoSmbMpZIZuq9Nzwj/bDYGPfFbq7kzEQjR2tUY
	XNckFXjGdGBJ7GlZCTsfzkJMFEdhkUQZdUWnu9OJ/NgMw2t5hYf3T/uzjuayoBS9P69re0
	GMMradHGeyZ+/f+KLFalqCPdE9hiCyw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=packett.cool header.s=key1 header.b=ircNaqFJ;
	dmarc=pass (policy=quarantine) header.from=packett.cool;
	spf=pass (imf09.hostedemail.com: domain of val@packett.cool designates 91.218.175.179 as permitted sender) smtp.mailfrom=val@packett.cool
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781504716;
	b=6sg3+bLP/vjApGyI5KVmA8I8oRzVA0AvyN7REDjH2oiEfyQZgq3xa7ey75H1cnH2fIQgJb
	06fZye62pT3DNcGutqjoUDwwIlMGxiPcTSW5Mz95EykrJ15qdXWFH50vBfTUGU0i8iDqd9
	3joEoJH7MWGsNy5OBES+cPbXjrM0jr8=
Message-ID: <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=packett.cool;
	s=key1; t=1781504714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dIagr78v8+wu8I0zN50DJ/gAtpHtsl0YE4lvqsZn4bE=;
	b=ircNaqFJIqIbLoIQAsKyoXo4rpXEoQiRy6zyFmI9hK3HrAfkw05xW4pZqyr/gEPP8FmgQe
	YCMXXOF0Ojr6Ke64K6mJnYe9JlDM5n9QaPTquf4RxnS2VJebzilW8irZlVAq2ZBbu8tU3H
	Ym5nnlp7yvHYcIa6UVoQguJIN6I828BXaZ6Oa3MyWDm++G633gd71/V0K0NJtv18Wf3rcc
	TGhtZ7HAjNfT3f/melWV8TK5yeAV4SGF18G26grrndY/UhwmBAr77wIkgpV/3r4qCrE+rr
	yyIzP94mT15QER7XOLBnD39ifvW2hpCx+GHe19vIvRAPUfC7zO4rmCN5XEqkKQ==
Date: Mon, 15 Jun 2026 03:25:04 -0300
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Al Viro <viro@zeniv.linux.org.uk>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, Askar Safin
 <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-api@vger.kernel.org, netdev@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 Steven Rostedt <rostedt@goodmis.org>, Joanne Koong <joannelkoong@gmail.com>,
 fuse-devel <fuse-devel@lists.linux.dev>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Val Packett <val@packett.cool>
In-Reply-To: <20260601173325.GH2636677@ZenIV>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: wn6uyqknbnkz9hkxemr7yqqf7pttkpc8
X-Rspamd-Queue-Id: 4290A140003
X-HE-Tag: 1781504716-647951
X-HE-Meta: U2FsdGVkX18Kq0HvGzZrXQ+a/BW8LJLnJGdL5YlcI0YyV695mF2qxWufBSJZpWu5iljHjxQtyUETSlUk1dtIk0M0RiKjjF3Q/DPtUMb7+a7MG7oQGGP1gyeJdvEQXg0orTgsuajhibVED7OVb8ng+A6wu8/hLyJw8VWZk/rXVh65us5JxLUP+dJQ99ZQoR7URlz6OAdHW1KClPpT8CZblcVZj6f+rxmSxkHShgpGrZx9NT1wLo0HKQFnQIY7VD0ef0b4lwZO+wRxrm5cihVq0iAQdJ6x6FBdrQxeTbCJWiDgqOUlMAQ0qutKW+J/arIn3V5XxkgXy6FCu2Sc2SDNBoDGgkSvPuaCco2vYsmsvwrsV3Ai3cslQ6N3Gy2SQ9LRnFwQqe/vzoJMZ9UP8ouIWG5CV4aNi1DExPPvhQunMQBgCDeDzHTnh08eHOC+Z4Dr2Wk/Wx3uNc1wSLTyfpS9w5pmzLvbC5XXKhyahr3htZjYcoq56pWUcXOGCxLjjxJwUNGRXcbRpCT6TrikwoTZOAnvQjdsWLOghz8uHvMquAjkBNl4aBQgeSpCuyyd0A+2nFl+r8BvOZ4bNBi5cYROHnp+HIM1mGVndoTxDHNHVY36NKPfOiPknXfZ7HQ2PNyfKWNeDT1fRtEjo5iv6oMuyheEBF+lEcSFwRatG2tDSy1EZ9x6cJy7Td8bMU9Tx9uCxRVHx2cNLvwVcDJzMTicTkI5nbQczQZyyz0ADUgDYfXwTcsudJqpqwxySvGuhP31+RGE1gF/D8IawrBKZQ6PngXHE8X6+J9SxpZH+XdepUMLTbkXUO3UJXZFf+nLBNgvhqmxx3PTjKA9tJbTwe5iFTLaUr5YMxV3p9w5WGNsKBP52XtGIl4mrEHLR50KHFaOXzrKSAau50s61h/RvAL6m+Eh2bKHdJ5bNtZz2zh5MJWe1CHPpkHAlRld/Rs+nTnGj/B4LgTe0ovRcUrtYlN
 nSDj5OCj
 bo4O0dxvghYUgwWmGo4B7QxCFHqd4C97nlGK8RoJDBcHnzmzNXPC4OxoW9RCei2BxFo+30XlLljUpIPVSHgEEogh8+Pb3RmnFIV9ndMDqdC0I0Sr9nz/bVigh78nqbuFUhu5m3plCDfoUj754mU/ME6RKzRGR5MQjvh+XlPM9SjfI9xrGXyg2hC4zgw/onN4/Z1JUAmVwMhNX7GUWlDaXWXM+cUcfK9KxaeY+eQwF6YC9l6nE8iWx1gbrtPw9XQHwwG95zgXqvZ6CyBSfnRLQxXcqT+PonUNufkPqoAdlsjvx80G08lAQ+DXNoS/UjZRmvGbeUFvM5ZXq9SLAZSokXSZcn797r9CHbmPQqTqXB6H3YfUhDumyJDmcpBBcI3xnYB7PKcth0cOavJ0TpMOZvtdCbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 6/1/26 2:33 PM, Al Viro wrote:
> On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
>
>> TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
>> a big simplification.
> FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> Communications between the kernel and fuse server at least used to
> seriously want that, so that would be one place to look for unhappy
> userland...

speaking of fuse_dev_splice……_write actually, this series has broken 
xdg-document-portal!

https://github.com/flatpak/xdg-desktop-portal/issues/2026

Specifically what happens is that the EINVAL is returned due to oh.len 
!= nbytes:

fuse_dev_do_write: oh.len 16400 != nbytes 15526

(where 16400 == 16384 (read len) + 16, 15526 == 15510 (file len) + 16)

After reverting the series, there is no error because oh.len 
becomes 15526 too.


Thanks,
~val


