Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 605F4C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5720D6B0098; Tue, 15 Sep 2026 10:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FCA76B0099; Tue, 15 Sep 2026 10:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3C06B009B; Tue, 15 Sep 2026 10:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24EF36B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:14:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2C09140431
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:14:37 +0000 (UTC)
X-FDA: 85216192194.19.F1B728B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F33DDC0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:14:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b1XacIHg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789481676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sR5TpNLMyVHA+F15o9ghX8CSp2I4Iqafe8l+VrXMdfs=;
	b=fgwA/Bbk2kWcJxrPy6IRoGw9VLwqxRJYkcTfTjLXfxrFvwV0inEk6Glkkj6NrLgh2QMNSp
	RyRv/sWk2Vcref1PEidcrrSQ34rXKAb5XLHFd7mZlYPjBQoWqlQHreT98K4UbbntWEW8IB
	9MXWEN2N+qRZOJ2infrSg+ZnphnNKEs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789481676;
	b=jJaqigJGqw2keHfNbHE44YVe8Ahqfk0d+S9DE3Bli/URMYzS0A3rONcihEH3AlPDte6eSI
	xxh/mOMzHtlDuSInNcLWEh98YvCuJ7yfNjPd8bFrEahyctUNoH6a/LSXsY5/2F31KTdji0
	GoYDBKQjmpBbmq/7rgCnHOuKkTHOfxw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b1XacIHg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F7B7602C3;
	Tue, 15 Sep 2026 14:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066991F000FF;
	Tue, 15 Sep 2026 14:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789481675;
	bh=sR5TpNLMyVHA+F15o9ghX8CSp2I4Iqafe8l+VrXMdfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1XacIHgY4nUO4ZXqpEqIsG3oqFId0LiJ5rDdajHox/d32oNulnuUxuP3hC20covY
	 TxwGs+MfaZwZBIbsbCMWuV4256nQO217F/xGTPcK83F3Gc7n7wFb9YJ2vk4Qo6jxwq
	 xeHWkayxtyqgLJf7wN28M70PUKpJGhPIroCCSvcdqZV7bL1aCTsD4T+fWESkZr452P
	 VQIF0gITf1//tIHrDDjxOvIcwtnYOZgxIJi8pzOvakf7yl2ZadTj/6u/Z23k95Jl7i
	 N/D/D36xBPRFLOT2c1wremPaJKcfMDA7qmUV/tS3JK+AL3aXuRzfk+X+Vf1C/bf7VY
	 yPK/fzMVWMcbQ==
From: SJ Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 3/8] mm/damon/core: return an error from damos_commit_filter_arg()
Date: Tue, 15 Sep 2026 07:14:27 -0700
Message-ID: <20260915141428.90098-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915033050.1579457-1-kunwu.chan@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F33DDC0002
X-Stat-Signature: kzjaryrowep98u6rwj7qm6fnqa6f4h9x
X-HE-Tag: 1789481675-482542
X-HE-Meta: U2FsdGVkX18mCLy+6mAkm2gatxxvW+c3lzB1k8ocqymgn7mr6eZPH4iX0dQVsDR5WnmTYF7FrMojVLFmk+qdFXMaoQ6Gl/Qu3gd8Rgsmri2KhjTjdtrS4JmtvaVlInrulHll7ZjA83jP0mxvWFBnJoSfn2JVC9Jj7L9nr7kutQ5ehs0eXEWj0yRxlgadfcQS1NkOVqXA9RGwMB6e66riHZyVKDxil6U4aTtj5AwpOwRM+W/jxfdCfQOSLEU/gJ9VgVEEm3V4JPwxHV1yU1G6aMU52TzBKLUZ2KwJYrnbRqV/6+yQBVd8/SoiEl/rfI1qNu1y7OdBEyK3uo9A9Zh3JGilwGQMT/xP5fzOfJET5U/aLyPVifIYaMl3iE+5i07tZQwrP7KvJJEAeuqn8P+DgvUU5R042LJC9Yb1bxCbkmyx0cwSaJYHktU6I5xri4tvGkY/mH7l2hHqOOAXh1Xel2+8HsgWx3NJtL1xLcAi+nN+e3NS3hTFxDBk5GTJEB2+0JS719fBbFt/FUTdvQMkdkDMIIor7XjLbbdTnpMufOrcoeIuJneG/r1EFW+LrvxOgZ4l8JNqU5WSi9PlH1UBmctOJCXU0bH6i1eXHn+fRvBWzleAckKUJupt594WcOd0rvIzU07XKpKb2WDnJ8jrKQZ/QUYLt3TnivkC/WsbFwbMW0J+SnA36QJFPdMhbBgQUBaNgVxYMOlWCEYU77rK2kDZsX1/WCQ0w0vRS66UeJfPQCInVJZja7YCuPkdqBJXzR4wfUifFBwGQeVPnbFV6I2u5dYu47bzLxY4XtlIUOd2IMkcNjS0n6OdtAwEMvO+cmfJjex8ykveS5OAfonImYHYTtHGPn+4SV+TyCIeljJ9blKgL7vPqoVr1UxV2+94LAyDyhqpab9zXXDlxZUOjLElvoXxDthr+EZzxYHr0ms7hSX8Za3+HKukIg/G1m48vEQXNts7+SFG1q8PW1W
 W4z4YTo6
 zgn1EcZtkW6qf0GoRPa0u2tKpaz6EFhVFhS8lWzvHghqOHK6MQzCCtx+0b0iY2ZY8EfqnyTN68rsaYLsx9J5hCFV33FNf0w8XtA71HUNJplgtya59xEXDZl37Qv++bBj+OvMWM8y37D4xkl5BuLcQvyWd4g6rmLvx1b68JlUAQXyokcyQ1AY5WkO21ZPu3oKG01bni2ZoyphAVNLK8b7keceqHZ8HNRz0v0POUhRINHkGrzemWg2nlfy4rR/IyIWmyD4TJY5olKmM8uuQfWGIb/PtnOX+G2FSUw5B2xHCUhqt+wymnbsi2LqIDlSzs2s2pSTcpSazPn7KoQJ7gbO3J1mpkjYR2lyu32b6eBoozgzcbaD10NurxdFGmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kunwu,

On Tue, 15 Sep 2026 11:30:49 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> On Sun, 13 Sep 2026 10:17:00 -0700 SJ Park <sj@kernel.org> wrote:
[...]
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thank you!

> 
> I'll take another look at the remaining patches.

A new version of this series is available at
https://lore.kernel.org/all/20260914142327.92510-1-sj@kernel.org/

It has no real difference to this version, but it would be better to review on
the latest version in my humble opinion.


Thanks,
SJ

[...]

