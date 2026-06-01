Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4833FCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 19:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FACF6B04B0; Mon,  1 Jun 2026 15:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ABEB6B04B1; Mon,  1 Jun 2026 15:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1A16B04B2; Mon,  1 Jun 2026 15:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58CFF6B04B0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:55:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 065D4140749
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:55:40 +0000 (UTC)
X-FDA: 84832398840.27.1B80EAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 611B118000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:55:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BQajPwgU;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780343738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzAAcVnBObtsD4DzRUXCCaUoF+wigWmV5eP+yceRm6Y=;
	b=hTkSlt8p9eU/Rh02my6Hq9JKkaFSHT7ip7z0QlABy76iV1cU09GAfEWVq6ed4MQm25iMhD
	m7Zj2HYImiaBofB6kn+09i0WGGl+pyPHppUEvu9TUR5YbLn9mE7d15gYQ6DkuwkqV+Qd3E
	lqPAIodnOXX9vZeA3bhVeK7YBpKwBeg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BQajPwgU;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780343738;
	b=CCmf/D0UbKmM5B36eIk++9Q867z99OP5+cdE1SnXwatF72G53L4/QuTZAZsdI440XaILEf
	Tak5mCSTLxfvTqqR7EnIH6zhGv6ZeECvPosgVj1gMMwz8wdBjv7HM6RjEfligoKBZb3bJW
	jKnz2TsuCdCThiHMz8zKrq9rSCcuOMY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C15F41742;
	Mon,  1 Jun 2026 19:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF631F00893;
	Mon,  1 Jun 2026 19:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780343737;
	bh=rzAAcVnBObtsD4DzRUXCCaUoF+wigWmV5eP+yceRm6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BQajPwgUvU6B9J4ZcgsDDOzuz5NUEl/Cdbm63kkJ0ppoFFiVpz33fqC9Y8FYW5m/v
	 sCvvIFMmJSPZOVTLFtboEUk83KdJrNEUJcjHRKVjN4dnmtzuGuIWumxncjlnvLj98X
	 0jY4mrC+QiTFrLox+sg2+t4sGY7v0rqV9IUDTsPQdrUwT84MHvC4nYTEDNrEya9RSo
	 Zon9PWYBjXAG2Ho2RqQhIwfgg1R76bU7JIPRbgXbHNdUT79zoAXielIIVMN/CHDCp4
	 GMUL7nWdvoDesnKGStsEmO+VWgqoA9uqJhT10xS1OvogwOVOvo9DFhhBo1U6FzIYCe
	 M9+J9tkesQeMQ==
Date: Mon, 1 Jun 2026 12:55:37 -0700
From: Kees Cook <kees@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Li Chen <me@linux.beauty>, Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
Message-ID: <202606011254.5FCBD65@keescook>
References: <20260528095235.2491226-1-me@linux.beauty>
 <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 611B118000A
X-Stat-Signature: 4kj3kg17xc4o11ud7mxxw3zbet7fgjdi
X-Rspam-User: 
X-HE-Tag: 1780343738-461547
X-HE-Meta: U2FsdGVkX19a7tYpzVsyaX1LhJK7ddFCTRvB5F9vqKfGylwEkhAjtTjWXofE1L2qb/TxwZCjAFcaeHhPdgw2Q/ahvkSzu1KooE8jMCZo1EStLFfc47pgfY4f6sQnFU5OPg5WSW3lmCnhwsq/Pc1TiybyLwfIdRd66bP3Tda2sIa0oz52uXmSvM5C3iDWMxUOMUEFM/eV7aITUGtol3GNek7cjszdDtKdAQIZ59aNYmCRWKju3T0BDxd73Eu6xAx4dhbSzcMDovGk0EfQJM/opyZVSiYK7Qn/G0LuanYmSgHbCafsLLVUT8AumVwZpjukBN8s4l1cCz2bi6cFo1218avffQGgEeRzd/+6dPcLtJTpcpScnqhE/KwzUSJB3BG53P+BRFg6Li4JvRA+3vtq7DgCU2WVBj9CjJfWZKO/nQ/Muqs/Yh87uPZaoGBwZwgH2++2oSJV73S0hyz1VYchkmwtbwokj9tvbmAFnJUTl6A1poJ5Z5jL3CMPgESk3WBUr3Nf3lpO/Pcp0zw0yuq/rk+eZ5BzuHCx1NCYbx2M8qQj05nMY8gYEw1tgLw0uHmxpUPItwkwJiqUxeh45QJ3FDc4QZVyyMJOcL8eCk1w9JytYd5+VsyO/LCmg/fRKVe56drLq/PS3ZEm08vIsItnvxTwLE398+ognL0nDm6SvtJbJtdv1YF7ilbOrDtMjEiltQWPcMe3nGf7wtl82o+jKZkbjaXiG/etciCKrnwAws+mXQpkOJaHOxhLgApsq76GAsrx0edlHkeUrXiQz5iYp5/03HQ9xohIi9ox0j6rJMG5DFivYWD8NAjDy9eOjgl80txVdGCqKIZxWDNZwt6eCEgn1eHlM+QVSP5+9k8Nj9rnM4QjtIDPO8AVkf/krfztZUGScDdS7yimITpBE1WbzHhF0MttFSRIK9Z8b6OQGJwEa6eTkri8MpFOOtC7w3M3lC2pBDhDx7LklsYAs1r
 PQu51ALV
 EliFlcICumzDos0A7txrdFHZ+WFUH/nfdnzSAmgtfgoVKkICiBfvK6D0AOa88jkUfkqbE1fp9ygD+0zxBh1sz9Ne5wVcdOVjoQASgAe4OKNXtcv5sljuVru1aAJxTsDwOPjc/sQ6hCGLWmJl4wxv5/+narBO5Urz9NLbI0VpieclL6aKevWoQKPvynacex57xktwmscthgN5c1Kz7W41ETpzM5b8DYzPmG1YsivFz4PRfvD5oB8C63oxkqPKmS2/qNNr9xG5xkWa9fIins5ePbzVsJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 01:02:53PM +0200, Christian Brauner wrote:
> On Thu, May 28, 2026 at 05:52:21PM +0800, Li Chen wrote:
> > Hi,
> > 
> > This is an early RFC for an idea that is probably still rough in both the
> > UAPI and implementation details. Sorry for the rough edges; I am sending
> > it now to check whether this direction is worth pursuing and to get
> > feedback on the kernel/userspace boundary.
> 
> The idea of having a builder api for exec isn't all that crazy. But it
> should simply be built on top of pidfds and thus pidfs itself instead.
> It has all the basic infrastructure in place already. Any implementation
> should also allow userspace to implement posix_spawn() on top of it.
> 
> fd = pidfd_open(0, PIDFD_EMPTY /* or better name */)
> 
> pidfd_config(fd, ...) // modeled similar to fsconfig()

FWIW, I agree this should be modelled after fsconfig and built on pidfs.
Doing so will avoid a bunch of design issues, etc.

-Kees

-- 
Kees Cook

