Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74226C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 16:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3696B0150; Wed, 12 Aug 2026 12:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B0E6B0158; Wed, 12 Aug 2026 12:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC006B015D; Wed, 12 Aug 2026 12:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBACE6B0150
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:34:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FF501203F7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:34:21 +0000 (UTC)
X-FDA: 85093165122.05.811DC23
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id D3CF120002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:34:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=uI0GhfJH;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786552459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CFyIx9mpxXeWIAIMoJaCt75DGlqZhikdj+q2raJ6pY=;
	b=GdqOPdCBb5aRjXGNKjeO1HK/bzTGxi9yxunVoTmKvGWPpVxHSJRhDoMgOO3kYMssJkYas4
	NhgaOKtyrVJDYMRcqLhhIKKMDka9xc0dhhWx0ceV9OyZ/buf1hgAqF44TtuEFschqPpAHh
	e0LgFQ64/SCbQ4JErE6bH3htoRmCPk8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=uI0GhfJH;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786552459;
	b=j0UpPifiMfNyoeU3JD0tNxtIFBGzZxTvv5kf5yLUJVteHT/MAW9y4lS0WQhe+Uo5kqKSTH
	/HOFfouBfkIhwoqxApVXYgdOE2pDf+H2uReO1rofGOUwvrBB77iIDuTW5ZJx4UhhlB/9fe
	8i7aJmwNGk+SBQuVELjbmgQ8YxIcWz0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/CFyIx9mpxXeWIAIMoJaCt75DGlqZhikdj+q2raJ6pY=; b=uI0GhfJHxfn4UH3T2iCDPOSYCl
	YR8rZmHQG6eEuAbbwvFElbXkjxYBl3B+oL/pSB1fhi8BpxttSzoUgxfZp/W8YXFjvHULd5qYaxPyp
	QDKMlQGl9Yf8CBkaRhLxeCtty7C0lvyE2X2v1Lr+0sOlolSSIKyW/hkoERsiGZX8bqdF5d0dBJHZc
	0DidMk5vrDTxGDmhwmenmE9o5k7Z/gOkIuhMb0galEHlqKHobTgPuhCD68VZ3A1pD9d4Yhrzm+Qwt
	gVfyQcqImVjxBgNEj2RXHd/2MV/JNI3InomwG0bZ89xxs+1C4Eb1Vb6tsbybRZeBzA5p0FUKOS98x
	9OUjsDJA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wuBuA-004TS4-2m;
	Wed, 12 Aug 2026 16:34:15 +0000
Date: Wed, 12 Aug 2026 09:34:10 -0700
From: Breno Leitao <leitao@debian.org>
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, shuah@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: emit KTAP output from ksft_kmemleak_dedup
Message-ID: <anygdcwTAr1MOfkU@gmail.com>
References: <20260812132142.582390-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812132142.582390-1-husong@kylinos.cn>
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3CF120002
X-Stat-Signature: y3iqys6o4khsrdkoxi133dax4sri7f46
X-Rspam-User: 
X-HE-Tag: 1786552459-859637
X-HE-Meta: U2FsdGVkX1+AYQVTYnB7eh0jfo9lU7BWVHkF2YmqlYwrU6TaYMvJO9O4RsCs9SnlFplXOAM7OTivwox7kWAZqxT53Oh+CEE4Lqgv6wHHdhoPKYYwd2LYRNNZ4DUiMv5i/rtaNPxTL1Y6Vo+FjPk5HbeD6yNn+deDkfzbhs0AiR4czS/IFua6Onp8RRKlldcB3QfSWqrXt9fhRw4SVO/KxNw+q83ygwqbE7wtSxHrgwbp9dghW28+UzE0Y/1zMxceAgjD3Na1Gby+zSttM09tCPT+wV0fx0XYO61vZ4UMcL0vnLdohdI1B9sQQoms1/Mm9E+XUi6biRopsIJG2AJqdML0xnSEfndPfYlNCyV9ZruvaCO3iyxoy81fSWSzib6NlEbEo0AZ22X4ObK4enjsvZO3qZ+upe67fsrB9Vef6TCQFGbh/UQfhgL7J62Dm0bICNpQRvCTZh28OQUAhG3eu6B1sRMm6Rj3r03FNAkK5VfDS5LiYFsHX2QNAKPaJxD0Q7Jmp760Sk3E5A7Vz6vmejejDt3bmd3OaiegxN7ByuFsvXzmBZlY2fXQsjfvhnm4+EL2ZlvaQnRGRRuOlvc9/YqO7Bl9f/7IZgDYnvz0wDYetNlzlDg5NDz6Y/8IAhdBrc9VlEDH2k2uVVabAxcncK5ceUCLVv713/BIcCPeDDN0sXn2klGYutkrx1cnDdxZgC5bNWN1LfWz2f931Kd3wr5Carxk6/aP87+egkPh2dx3s7OI/sQ2a5NfBHyt0fj5om1ewXASBMdwm+HM9xkq7DFCdEjqgpPLzszdDCmDnadc+o88tm+dQN/6Kg65knhhuc7CX07WggYuCYy7HSJXvp2YU44w9X4QVvnbyyA7CksWR8kzmeNLA7Bk9is0sEcS5zmen3kISlyVl44x2rHA3W0tNo2IHhc4uCKv4eB4owB4aVrp1GfFDnj1ukbucK+EeNEZTctMlIi/GAwqhxg
 rKMUZa1M
 p/tAlrradQGlylWmLGZz2368kUYsLC4wA5BfK8S4QJ5W7NcIHeLzGmDQ6jA95asiUTAJnmY5ZzAmY3ipeH/DbuoczXFpXZ6l6+ME7k3jEq1BIePBCNWnTh1XPvSvenGZqBzdz7ffJV1/Bzer14kGVT5UORV1ik0tn+rttlzrqRlftTwzMUlXTY9/zZw4iLDj2rNZv1yr2qSTOPwQx0t8+Cf0C66WEXRz2HgLKsD+XokwpxB/SzNF3leZHwtfazNxN6QlFqcdVZkabXqssBZDFxihUXfr+kZS4Sv8V+LJsU3gkvjJkIKz9oZoXsEBSp91+7j+P1AWsRj0rUU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 09:21:41PM +0800, Song Hu wrote:
> ksft_kmemleak_dedup.sh reports its result with raw "SKIP:"/"FAIL":"PASS:"
> echoes and bare exit codes instead of KTAP, so parse_kselftest.py cannot
> read it.  Convert it to the ktap_helpers.sh API, like its sibling
> ksft_kmemleak_confirm.sh.
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>

Reviewed-by: Breno Leitao <leitao@debian.org>

Thanks for the patch!
--breno


