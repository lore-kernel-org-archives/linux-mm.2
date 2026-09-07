Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8C88C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46BE6B008C; Mon,  7 Sep 2026 10:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F576B0099; Mon,  7 Sep 2026 10:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C846B00A1; Mon,  7 Sep 2026 10:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 95BCD6B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:08:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29C80A019C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:08:19 +0000 (UTC)
X-FDA: 85187145918.16.FD82193
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9714D20011
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:08:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haoLa08h;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788790097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sr+QCo6xQfPXgTOYYqw51EOYZ9lBSMZUZXOTHvbB0K8=;
	b=b8iSnMBTgI9dCHQqoYNRbKx0lSLzRnFo+lq98reY9Pz43ux7JNcV4RCJJpy2KxAvbdZ9HY
	IzBI3WEXtSSSInp3gcuhtyPmAnBfOPy63LE+PIzNAKAMpS/dqJlujstu2QmDa6JmR6JtO2
	IzqN+yIe5YgdibAfQMuzgZGdHOdhpWI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788790097;
	b=RWfzNgakipKhgW55yynp5dLbyIljJqsHI0CYuUpDJ/eFP0JJzhVyM7FGmNDisDFVajNIze
	LTcM13f5SYCwk1BKqe9hgjuljIW83RVgEWcxrODDLmeOaRW+fyDTkzMI9BH3+AP1AW4NwP
	+vAiuSj9IBngeafHv6NGBvH9CtK1HS0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haoLa08h;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D47F601F9;
	Mon,  7 Sep 2026 14:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538431F00A3A;
	Mon,  7 Sep 2026 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788790096;
	bh=sr+QCo6xQfPXgTOYYqw51EOYZ9lBSMZUZXOTHvbB0K8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=haoLa08happTKU0G+mwZmJ7e2zLqMXgmLLUYGwLe8QtCs/8rKatRIntZSZEPGeMvm
	 ijISDt+qEL98Z+wDxJCetyAx+Ork/d2fDcc1LhG6HDOv0eyR5iQ4IOfdrfyn4284kB
	 pZrTbEfNoRr2sdFJ4oeglkhWSAIjA8KZ5JZinI4qg4DJ7dmDN5t05MKKsHnh738rEC
	 n77KBxq13Wp8PaKgb1w2YwnM3zlPITTFXNFN92tmfXlIg4/U2fB99MAASYFlYFA5bp
	 xQF3upyDcsWkSJSlX+dGB5XuC0jjb3CZsd61Q7zF0elIIHUyiuET/Iy7emZoWoe02t
	 nOhGbTja7PbIw==
Date: Mon, 7 Sep 2026 15:08:10 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove PageWriteback
Message-ID: <ap7FKO_9BdNymgsn@gremlin>
References: <20260905-remove-pagewriteback-v1-1-06f41c00db03@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905-remove-pagewriteback-v1-1-06f41c00db03@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9714D20011
X-Stat-Signature: kijexnydw5g1pmqy3z8on1wbo9b9p7yd
X-HE-Tag: 1788790097-191051
X-HE-Meta: U2FsdGVkX1+RCX9ZPHvBSAD/S5PQwz5arCYfJCPaCzYKA8rf4wf9hpBLmBt64R5HobM4sKAX+nmSwR+4NWi8EaV8341iGhDWuAC68o6h+UXwMdiDOVuHViLITTw5TQUv9iNYJ15zzwnI2F9ityydw7gxXXhBpoGPAPRekSmv1p/V97Zl1lsPkzw2K2+Uxe02YiW5xkXYtiT8ikd7r34wm5vcFycs5PR9LcLwttUK3IvWJDMtgh04T6z0eusziyoVR0i8I9ESjH1w8hMYqXBRGqvg/18eNzJlklqZBNQiEcxJZE+vnFEPPPIU52UneHFGv7bKAB7ukjmQITnwPIbFvWYWfUYXSHzpA277VA294raXTKoS5g3ydvhkd2ht7uTKUkE2NQKPqQZGFja5hPuyeSUIUPmLAybWZopKVoIucJ4DHlahVW6JV6uFWJvLtU8J3QCpnMQRcZo6DZeU2OojizPZOjusplmq9/wpTrsbds7frI74vSi+vyJTPaTDkv1NXMXckaYUqDhXMGJkGqWzF/XsBnQkdfU1wj1JV89JAZwNPR5Tj4L0n30SnsuXDZlj3uqA+ZGrX4Q35yDkmvXV1i5c3GcPfZpk17EMf+0AYn4Q9o64v7VviQhl483m9XpRfQr5KtRGGDdYZcuwfjYV7ifNxvBnhd3CyvY7khcUgDWofNmNNXOuFWTX9xKxDvYCQ90N7xXanx/MVvAMErYG9s9LJOiQshSTexCVsP0ZdcVpyOLxzDo+tZo+jeZY0FS8+qfMY9xney3Lz739tnlLe0OwlJcGcyNlD2wOOCTO6BADBBKH2oe0GJL5LsBOKsKXwDMCYxqHN+DHLz18IZD8nsqiTtQCWmecxd+Q9YkFlSq58Z91kbrPkWYNPs/gnWy+ffySElsAUvRHdOsxofGyqNFnuy+VIwlUE9p3hvhSmPs5slod6R9jtnLdTkS40rXBV3qQuBhvF1B5aB05Hf2
 aVd8p6Fx
 8h/jbeOR3rX5nVQHk9ofB8+ELAI0+11xVupgK7A93wpcyfgdpbuOSB/aXGJUoh74ZZB3bwwS4Sspjpy24jYV2DAuHx8Yl+jyLjm1apAKVbBG/lyxnaZUhv8hYw+nxRE4dKAtjd7sA9W5WJut9/+Fz+M3kQmhZaAq8a9S+Tf17LDN6CXaP7hY+NLddFSh8CBAoAIYbdE2isETLJJKrHfFPw4+SrKTMeykwhTOvRgmLRfyIvGltrJU0wrFVgEw/oIJtfKJSy8nEOFXa6MDQ7xoPjuAxqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 03:08:30PM -0400, Tal Zussman wrote:
> The last caller of PageWriteback() was removed in commit f75987e543c2
> ("libceph: remove pinning assertion in ceph_msg_data_iter_next()").
> This flag is now only used on folios, so we can remove all the page
> accessors. folio_test_clear_writeback() is not used, so don't add
> FOLIO_TEST_CLEAR_FLAG() for it.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Nice! LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/page-flags.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 3dc79c0c5adf..86dd0470da11 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -588,8 +588,8 @@ FOLIO_FLAG(owner_2, FOLIO_HEAD_PAGE)
>   * Only test-and-set exist for PG_writeback.  The unconditional operators are
>   * risky: they bypass page accounting.
>   */
> -TESTPAGEFLAG(Writeback, writeback, PF_NO_TAIL)
> -	TESTSCFLAG(Writeback, writeback, PF_NO_TAIL)
> +FOLIO_TEST_FLAG(writeback, FOLIO_HEAD_PAGE)
> +	FOLIO_TEST_SET_FLAG(writeback, FOLIO_HEAD_PAGE)
>  FOLIO_FLAG(mappedtodisk, FOLIO_HEAD_PAGE)
>
>  /* PG_readahead is only used for reads; PG_reclaim is only for writes */
>
> ---
> base-commit: b733fe31e781ed45c56d2ec561dbb61a903693c8
> change-id: 20260904-remove-pagewriteback-69d2aa5b3ee9
>
> Best regards,
> --
> Tal Zussman <tz2294@columbia.edu>
>

--
Cheers, Lorenzo

