Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF1A606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ib1q3vLs
Received: by kanga.kvack.org (Postfix)
	id 8B5866B05F0; Thu, 12 Nov 2026 17:50:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866AF6B0602; Thu, 12 Nov 2026 17:50:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C796B0603; Thu, 12 Nov 2026 17:50:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42A426B05F0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:50:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5106881EBC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:50:40 +0000 (UTC)
X-FDA: 85427963040.05.C2AF530
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 83DC380002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:50:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ib1q3vLs;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794523838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0TqqnxQNVR9PGz0qsU/cytTwrDEZUDTjkuJZAfCjgjk=;
	b=I0Jo05Kf35Z+dDI+f1QLXctLSwLPaK0CSZdeSQ+pzw3mQO0xDkPTQS/HjSZOGvTKUT9CTH
	knMYsEXUMh9DgYO4ZcAYmBcijonxTggqAWuE+jP/wuZqoZ+snrXn3L4k1SOBD3nEF1koRw
	4NO0FPCHbkfQCSiXoAW8q626153ogqs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ib1q3vLs;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794523838;
	b=OvJkdtsjOsrQ8ZZtcA+kyIVZfFmEVQizMbhPQpZEcHtDjwLxBGjppZK5WH0CMhqqK4ppLV
	so3pKeF4TGzxsF/Frts/vb6Qb2jFbsxWHwdIDXAoAO5QvkYx9qASvm6GpL+1fo3TXGk1Pc
	mFqM6DMhjNqwlTD4uln4nvSjA2CX+d4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E394A6248B;
	Thu, 12 Nov 2026 22:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0321F000C4;
	Thu, 12 Nov 2026 22:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794523837;
	bh=0TqqnxQNVR9PGz0qsU/cytTwrDEZUDTjkuJZAfCjgjk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ib1q3vLs3nrjWX3UOR0N6gf6I7Izk3R5STAMgmrEseBFZ2+/2ZtaLtD/xHRZV48+g
	 gdu2jbJ8rJ/E34iojbyi7lQ7kFgGmF1BapDESUJnU73YEDTFck/8O2UKwr2aOQ+6xK
	 RkXUOhwUwQIlfXlLqJw9puz+w0Be+j12bJXOqOak=
Date: Thu, 12 Nov 2026 14:50:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: =?ISO-8859-1?Q?J=E9r=E9my?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>, David
 Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau
 <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond
 i_size
Message-Id: <20261112145036.97f74a828755d5b9178a3e3a@linux-foundation.org>
In-Reply-To: <avYBFPhB46XWAG4A@pedro-suse.tail5790ac.ts.net>
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
	<avYBFPhB46XWAG4A@pedro-suse.tail5790ac.ts.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 83DC380002
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: wf5qnt1rf3nx1jxikbnsai15kxq6p1nw
X-HE-Tag: 1794523838-720937
X-HE-Meta: U2FsdGVkX1/6I96/Aik2ONqxunwzU+fB9++W+Wpc+16lWTYdLYdQH+Ci3WSMWGpXbTuPFpefjxoP+4tWrh/N7YKAkdHx8WlBjGA2U4XAOY3jAhzytl0LLw8UfOuG8+ZSvP8+0JV3SC4Tmlcl3fmtPlLhQOfbORRly0rnLPCuGLUbecgUd9pMG2wY+GlPKF8QRZRk9dk8jAjSCUphIQk831FtKWiQ6JI6/LpKQly0jV4QRN7hzfJ2kYgxMXjWojhwKg1uCkeq0FLyvxfYcyJhyvDHlScDx69QQ7kUkGdjsckpWwvTKx5G7Mpon5WJ8mnMwAIVbIODTG3hnJmcvC/iMxGogdpWWIikPGZeYAd6Cp0ypsx6qMUVVYcw0E5XGROSPyUzoXCp4uFBrV1bIogas5ICSywVDN0h5iJfnrcd1GEH2R06FC0Ix6Jq/v5+aTmDnqz/yo6zFvQ03xOHSENiF0dSE/DKs8/uuRIee72ndBu9ocjUbox98Y8+Fi+qh8wvFy6vjma6g2mYR6twA/UzOuCl8x7F6fUIj4jcUNERg8zrWKxMS5uwoF4oNOLWoynKeR3+r0anErzrkkm+5Xi6O6yx9X9dTOSpGvu7NpNhjKa27ZPPcK5mbvtwW1+0XbYBhLRnJu+6HnYsnkUS/KajTHgByj9TSWZupdamDTMJ9+zoXnMj2Gsgqym3YuYivn1tiNISRIimPNCGEddmL6+mk/ihe5nKkOltz51fBHT7IDNZjEn6EDNoZJyIAIxdZckjGmDHrMRgbWHovxyTqSDgNKYoqmt2IvEeHgts9acixynjALGoKbl1536ji+D+9G5DU8uWhkPyGBUWslulByBZJ3+ABH6/VsaI+o174Iwp/KhJa0fNbpZdgiMLpiMUVELD4pIQTKNNsUOYKcr/9E6mDfi4DJwZjvSdNxdd/E2KjTtL2lGbFWDv+bRIZmhtv/AzDCJtIk1gKcMmmq8zLwX
 p9I+dNpu
 5NukgfQVAXzQaeegZutjcwrKD/T3WU16doBa3KO0uIUOwyGwLYSTCXWozEL8UvTfKKwUVCzAxPy00ekNmtFa3zKLaxKP+wSjextTL+4Q59gWfE37rpDKRO5EjK72U1CU7KjYlSYLG9sINDOxnDoA3MOSnR3wgUHfhC8d8CI5qvv88cfT7jTGFQgXvkE5DglpjhPs9YXnJmrCVFg76DgwHVKvmktPq1uvje4NsshMDqk/QatBgMntp1yp4zdo0WTvJJL+qsSET/QI6PpCUkPucU+D1+hBqDztk5znQH0uNhjfNk1J/FRfStoJhUYfCX7L6eIdPrwY5So66GB/1Rvylvi5Rb5TRYzShMMpiA0cPm9wXU5Wv7LVWBIJjXrOgZJOVbI7TwZLGIR4HUdpR9isjnjj742VXSVl/xXLxV41gycORr2xUlJT5VvdMQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 18:11:35 +0000 Pedro Falcato <pfalcato@suse.de> wrote:

> On Thu, Nov 12, 2026 at 02:23:35PM +0000, J=E9r=E9my Jean wrote:
> > MADV_COLLAPSE lets collapse_file() treat absent shmem pages as holes
> > filled with zeros. It does not check i_size, which allows one present
> > page to become a huge mapping that covers the whole collapse range,
> > including pages beyond EOF. This makes those pages writable. A later
> > file extension can expose their contents after F_SEAL_WRITE.
> >=20
> > Hold inode i_rwsem in read mode while collapsing shmem so i_size
> > cannot change. Reject a collapse if its page range extends past
> > i_size rounded up to PAGE_SIZE. Keep i_size_read() outside the
> > page-cache XArray lock because its 32-bit SMP reader is not IRQ
> > safe.
>=20
> I don't think this is an issue. shmem/tmpfs purposefully maps with large =
pages
> across i_size, and collapsing across i_size is a feature, not a bug.
>=20

hoo boy, this again, See
https://lore-kernel.gnuweeb.org/linux-mm/nwkpojnictbg6jicccpxyfi63ol4tmfajr=
lx24u5xxoxx7lv5f@jkw3o7j6tlfs/T/
and enjoy.

It's not good that this sequence permits non-zero data to be exposed in
areas which ftruncate() created - the ftruncate() contract says it
doesn't do that.

J=E9r=E9my , you haven't explained why this matters.  Is there some
userspace code which is encountering problems because of this?

Why did you propose cc:stable backporting?

Thanks.

