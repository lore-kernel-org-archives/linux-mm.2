Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB906606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f0A+0ObF
Received: by kanga.kvack.org (Postfix)
	id 0CC0A6B00EF; Wed, 11 Nov 2026 06:06:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D326B05B0; Wed, 11 Nov 2026 06:06:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED59F6B05B1; Wed, 11 Nov 2026 06:06:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0BD56B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:06:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C23EA798D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:06:24 +0000 (UTC)
X-FDA: 85422559488.29.A787920
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B712A120009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:06:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0A+0ObF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzHMhcU+vPiMdliqp2dflnrsyBQs8fZSDxc9nDiFNAU=;
	b=1U4duvq/REqJiXiYwaNF97aSJ6xgUDUUcJhcNCaYB4j7fQAizhIV74GOW/xACDFMHzZDbO
	xwSJlyttD1TFnx+vrs/Nd5KItAAsLv0uo2HgJcdAEF+tF0khV5brB8X6th3bdjz2xPj6z1
	i20H1k6pwyV6YzMt/UPHYrID93rilM8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0A+0ObF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395182;
	b=GCizELK9dYPjeZ2vjrNCb7h2NkRKqR7zgJgc9A2qolDFzXGrPBBDj6Y5GsSS2xLgwtuRIC
	Rn5SUoW6SwF852vM2OFHd32TpcKNTUZjO5xYiTbeBjW3EpsGP22JmO2h0Q1e6tcbF7Ass2
	JtuAHX5UZcErsuYKYOV3LRb1W1earmg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0A1343D4F;
	Wed, 11 Nov 2026 11:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55B01F00A05;
	Wed, 11 Nov 2026 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794395181;
	bh=NzHMhcU+vPiMdliqp2dflnrsyBQs8fZSDxc9nDiFNAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f0A+0ObFzxtqt5RTDymvHQ0Jgz3VPVvid9hhX0m4CKnMG1ey1riT3j4cfns0YlQbW
	 /fpWhX2EwvzhDHWSm0r8z9Am+FM6DXMrYUVK7TN04Z7WTtW4YJNKEeOdzBx8PJ6WGA
	 t3+GwtMKtR0FyHZ2I+ZJJJvWsY34hiefVKerffEkrM1pG7kprb3YZLwraFwi+LM60r
	 TQhv1XENZwY7v5QhP7Hpd9bFJcLmtceg6ygYkou6jI5FYm9Y4ahtIkorF7zvfaSB5G
	 0Cng8EjDiFtX2I7MTbNehaDLud9ByNW+awhQmJ7WpzZKy0PKctQbHbx9bdSYbS00E4
	 P/2wSixuXZzBA==
Date: Wed, 11 Nov 2026 12:06:11 +0100
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Amit Shah <amit@kernel.org>, 
	Jan Kara <jack@suse.cz>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Bernd Schubert <bschubert@ddn.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/4] splice: remove pipe buffer stealing
Message-ID: <20261111-betrachen-schindel-gefroren-4c01e5f9ca1d@brauner>
References: <20261110145241.536019-1-kas@kernel.org>
 <CAHk-=wgPq1g-kt_n4-crr0qs3rBNkat5OgLxLLeMjKirevRuSA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgPq1g-kt_n4-crr0qs3rBNkat5OgLxLLeMjKirevRuSA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B712A120009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3kwqztkiuff59kopb8yshra46moh94tt
X-HE-Tag: 1794395182-984133
X-HE-Meta: U2FsdGVkX1+07AzXIVBEPt7REv3oH598UgQGYZVeVcn6WgkJKEm9GCqhxhvRyCk4TCZkFjx1R+YWAYMRCrY4JMMM4HPFn65LKyxj2r/XQ4FrTS6kmdbDUgV9lT1pc1ZjhWKGeLxdBIvMwjjo6Ntr4wJqGQ59W6j7WUfZtTVnKTSv2JxL0Hem8MI00Iqw0lgVneJKlKP3U3Dz0kE8d2q00nnLql75C1qZwaPwHHyS4h6Hy27S82gaA+85ZylFeiYsAA2enVjHpofry1FMIx3VH3/PCPRuI0XVUvroRvf/TEI9Cq8UV1xUiOX/EYr6pFt0oQTih0azlvecZVQu4tC4axkVGMSTnEI5TKoNdoep5HIHl5lH8k4OA9QZwpue2y8M6EYRZ5nDH3gqFclVauVPqPjHaZrQ58qrBBtPEep9xD9/SmtlpeUrrwxqnN4E3kuRkR0CMR3gy9fYx7WsZGzlIFQ/kvxAmzNJE5SQbN5hNCW4QUyv5qqLkonUwaSvvZceB+6jpu9jFN02LtRups4mDjw4QXvqQLQ5dEyC8TkOkPnq265Cje0IU2J2ze7lcF+GCjpbhPAIFBtmi882x+w9CqueBvRVNNoE9jlSWlZFVmUdldA5EdIZYUPM+Gmnfdt5Ece4eIYyqPTCRIhrvWjlxWEOvtnXytlC5b6K9wN7akGbr6Gf8Q7PZ+raKZWwFD7hffSJ29ovepBYcPLYFGlUjYPXGa44GfszqwXsN51yepm+ocyc8LGgkYWAxXTmDU3PlUFcDM/9tqrPjggijBu3c0WlW7tcI7atb8dKYDIeSS6MK7RQPKEwwsDFGuc6sX7bWZgcW/N+09c3VE4P6IeASD2IB+7RcyfskDUwL3UXeGxISxFOiMC6/7vlo69RpG/CDmEqxQ/9a23uARnVp4hmG0W2AxHcxxAIfpu3EnXYnaWhbUiZz4Ij7cAyFeowzbNODUqqq5YxAkkn7BnKTru
 y/CQNiwp
 zT4xd7mEtzHvhgzcGwMLPqbXInaGXbuy68RkJCW2rCHMoLTUl7HiT7ORQ+SOm0orsL0XlFC810HyQjGw6imKeEh64drtn7xYXesCtzEmJ5PljDyAoW+PqemrQgQQ+HIyo6JfOy1+IaK/amPnPpPDeN9bHXNiZRnZW1XfaH0eZWOZtB3IyzlaMFwgRU9Yng5MFPzb+Zuk/5AP4DELNJA0ysB1M1MlLQmOaLn413W2vYyWxI3NIm+hnYSm+WLmPG3jlwhHTPDEDyxDnA+Si9BChg9mEeMV8aGGIoqxBMm5AJQRuYl+9VsbLh3cS/D1vQQPxwQYyQAvMyfFTByo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 07:59:47AM -0800, Linus Torvalds wrote:
> On Tue, 10 Nov 2026 at 06:52, Kiryl Shutsemau (Meta) <kas@kernel.org> wrote:
> >
> >  11 files changed, 26 insertions(+), 360 deletions(-)
> 
> Ack. Lovely. I'm considering just taking this as-is now, rather than
> delaying it. Comments?

I'll pull it into vfs.fixes and send you a pull request today.
I have more stuff anyway.

