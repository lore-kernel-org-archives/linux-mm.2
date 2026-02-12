Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30045EEA86E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 23:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709926B0005; Thu, 12 Feb 2026 18:57:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7866B0089; Thu, 12 Feb 2026 18:57:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EDB06B008A; Thu, 12 Feb 2026 18:57:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3336B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:57:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF09DC1658
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 23:57:30 +0000 (UTC)
X-FDA: 84437469060.03.B8064A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4A592120006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 23:57:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J8dUK+eV;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770940649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3FfjOYubxB0B5WuQhWA8OUAeyV+Di2BUs4kS1n/7vY=;
	b=QXc5WQWgo0CF/txLoJlHtahf4o9xV1JcF07F2I6Jx4NYMWeaYsenxl25Fyg0fE5vkEA1CL
	sPjnOYYa2VuZO5zmEpDzKr9P7Jh/fDOv8kLj/moLZZOKLHnHEI7wFQSthB0jtK7vL6Soo+
	8rihINt48dywrW9J4rAkAyn/AudJI0Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J8dUK+eV;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770940649; a=rsa-sha256;
	cv=none;
	b=D6z+Wi8nzxGIdR/+zBeMEJeiSziItgfeVvYhbTEJXr0i66p+q5dbqOYUKtvg8nIIPbfwgw
	k8+/tbPJddEm6VlReJeNmA0/egMbXSelNHuANw1065lQOPS5v9vhwpZTrQK6BRZ4gZ/+uX
	DZzn9ebU+MfIIp84P/BlVsFBGZO7yV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B1F260018;
	Thu, 12 Feb 2026 23:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1A2C4CEF7;
	Thu, 12 Feb 2026 23:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770940648;
	bh=qH3sZOAXgsUDZ09GEG/CPzjzapOeWhbOfDETc9hIRVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J8dUK+eVatdS5vpKnijzt3yXjpo4a1kisPNMV6Nj89YrPja2m61ACXdWvBHURZEaD
	 BEfYrXT9BR7U1+yaiyVHk4YUOEC0x0h9Qq+md7gpf7By5/rHIhpCQYwTEdS0WZRVHe
	 G9w9+g6xy85JEtNj9JkmpDEyBJlI0gXfU864RlU8t2GcqBezA9IiC83UG8w8rau1by
	 OKGS7m4nBKOcLRflfVy8bS5n+CsDQKjB4VIyokrnxFHkBBnKbuHyC7sRSLjcU1Nzzq
	 uh+MGPtj5UN4kwaQuj8ggpZf+UTg3tHTHMOHQIg2YEF9p/Lc/vwFz0CUpI+GLYYAHq
	 0LuO6W5jzs+8A==
Date: Thu, 12 Feb 2026 15:57:27 -0800
From: Kees Cook <kees@kernel.org>
To: Andrei Vagin <avagin@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, criu@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Koutny <mkoutny@suse.com>
Subject: Re: [PATCH 4/4] selftests/exec: add test for HWCAP inheritance
Message-ID: <202602121557.5C1249F@keescook>
References: <20260209190605.1564597-1-avagin@google.com>
 <20260209190605.1564597-5-avagin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209190605.1564597-5-avagin@google.com>
X-Stat-Signature: roksjc9ny6jiuura84w4farji67pqey1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A592120006
X-HE-Tag: 1770940649-223679
X-HE-Meta: U2FsdGVkX1/lsM9d593yLFB+Ax3IuVcKSxtGW07E2QfKgi/c+jnOneXbLqsyeu8gj500pd3KHyay75erfitWdQAEmW4QRX2/JnQlIe5ALxJvnb7ESIUnYRC33txMj5G3z44Y8Ai7oA05FkwULZpQOyWhxg2/fes3yGaz1u8mJf8vcqiiHfn4dHMiBQRh4xVnD25Lwgu3nbmD11R4TimuVtwMmEe4SXmqHTWlAh57CRUP1axz/y7E9wRxrD0S3+tfySP39ktCuVPBLOD6IIwxjd16t/t4PlNajrfyl4ZCfNTDod9ZqTUR6wMZ3GI5HONJh0HNRDuD9eTRlCQDgle+X2s/m9fa3xiPrD28IO0bkO8WZZSBoGpUpXXMcCIlcuBkeFl/XnRgw69dMI8W9FCKbzseWKzG/jXvuAAoKvCekJ5337g9+0GUbwUkMzN3ss73/ZUGyFb3FG8aXnaszTm6VjgOiesG/l/f5v3mNwv5HuUaZ8m9FvTmSCtZNJZcZwu3ctOd/8V+fwcpE/41ZFsgBXJsipCfxnxBmRGZwIibfiKit2FT955UST/0xrqeE2UQQoaZ/l4Eb3/igqskzB3AhBOVC3oMr+mFG2j3DMjCdOLfvc5D/DzrSSqkT0YjT2YR0/iYastPCyrxwinPAPZdS8l+DqH4XLD9bDMCooAE7/2aziWfl1BNv4/r8xjQoKKWgErYpV1eaXoXK3hIi6E5VDCigO+Uob0qaOfCqAgjImx+e0x3FEU0kbCtVaSlMGHwfNky871qt8Roy3xj32XynkLVu/re28dcns2da3CRRH1Io9wc6EnoTy/mc9odlu/Hb/Imf8mLsq5B+qaz+klJmuDdeqd6mXB69THNCE7ozor2qX+10+Fh5Y4YfaceJum3NRyT0TcSY2bBfKbWL3b4pvEz1nJ/7wE/rIF3m1sNV6qzpUBS9majUaK7gYl/xmzKHVnkckYDWbDl0LwTatj
 xZtYcj4Q
 GJTxCqtfNH+x1yKL42CM3PSvKJ7SDmYznTY/7G0ng8ecrduc2c4lEo+DriZD7Ell4lXuEzzDGpu1tMOkm6J0lcUXAs0Bnb4BDZCQkXNur0jN1ngysej3obx7z5r0KJxzReCS5OwEjJr+EQwNe6pvYT0H1L0+TQuxu30a2MRqe9zDZauBRAtaUuFxWXdrvrTvpTqNOjrI1QIueHYNrqsICJSNHcb8heK59rwEQzcrdJZVK+Q+Ur0eDhZlvtqcnK6ZnN1MXIaF4jHZfmX7vC7GGvDtT+VGzqFbySYkoit0hA50Zd+38K9rh9/3I9TQ+8RXjipEcl4SptW5Ax24=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 07:06:05PM +0000, Andrei Vagin wrote:
> Verify that HWCAPs are correctly inherited/preserved across execve() when
> modified via prctl(PR_SET_MM_AUXV).
> 
> The test performs the following steps:
> * reads the current AUXV using prctl(PR_GET_AUXV);
> * finds an HWCAP entry and toggles its most significant bit;
> * replaces the AUXV of the current process with the modified one using
>   prctl(PR_SET_MM, PR_SET_MM_AUXV);
> * executes itself to verify that the new program sees the modified HWCAP
>   value.
> 
> Signed-off-by: Andrei Vagin <avagin@google.com>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook

