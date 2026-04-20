Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F4A0F36C26
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 06:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95946B00F8; Mon, 20 Apr 2026 02:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47266B00F9; Mon, 20 Apr 2026 02:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C416B00FA; Mon, 20 Apr 2026 02:42:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A68A86B00F8
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:42:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4EEE8BB9A9
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:42:55 +0000 (UTC)
X-FDA: 84677991510.13.CCBEDE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BAF4A18000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:42:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kIEDycGX;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776667373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KaV1/prU4z11uEzJzfnNIiVbut+p73qXQYIX90S8UOU=;
	b=3Wi1CW6oUd0EwKu0tL0zxvGHU1RbueGFpvyZmnEqcCfdrky6MVdrh8BzOzraqNWzzA0Ms1
	08igAm8ppww+NAl5PPJkAVP9MUogKaArBB6GRLrwkeLGvm+gJbAK8hv01s6jrjzuWnAUy+
	UPp82Wh0aZ8yR6IVzCEhzDm/3zfs+F8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776667373; a=rsa-sha256;
	cv=none;
	b=AHaYjhmo4lCWEZebSybD8LA5c/JEsAqt0LjwhwU19ArhNxQItuMwbpDZ2FwgTENfD+SUvT
	RCsIdd+BWqKW/tisT0pm1yEYlGjUU7B6idlAKw8RbWa5TjUVpgxOGahcmlKrHYY1TJUMAW
	FfC58fyri29QzcackZBFlCxyrYnLV6I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kIEDycGX;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C5CDD60055;
	Mon, 20 Apr 2026 06:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59964C19425;
	Mon, 20 Apr 2026 06:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667372;
	bh=/8oTGofPNIwnGZ/hP8RSwOl+oZ+p6L7gCu2+01kkP70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kIEDycGXtVBILbo3ZrjYk+ZzVYGUiLxlF+JHSDWmqeSlgLHZDSzvNmHDxVNAHbMSI
	 0w1xXf6viXXHoYY7jqbYOQcqHKXr6YuFz6YVjbiL/1L6fDcKTIbD1jgXYvBN8q/ZOi
	 KIODX3tHeiAQQX7nc4YkMvN+PZqz0iPfjrzJXMyYf3Ax42GEeTsWwpN1FJGte1lOHN
	 UBeOWNFubwZBZPrEVjwcnrgwth61Dq2u+74E4Pt1iEGpKU2QyQuhjN4/Tyja3Me/Yc
	 NNMgU1ltrUcLfDUssrpXwMjUXkMk+FRQc/m/rsR9vqVHJziuPTWmyi1vxG1dP70Qx4
	 H7hgUphnx8NhQ==
Date: Mon, 20 Apr 2026 09:42:42 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Nick Huang <sef1548@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab
 documentation
Message-ID: <aeXK4tjGFUgKDf5-@kernel.org>
References: <20260418000635.17499-1-sef1548@gmail.com>
 <aeNGbNyPxJssnkbO@lucifer>
 <aeOuCH8ydw_yzdXZ@casper.infradead.org>
 <c113f667-f897-42cc-a0e5-b8a0bbd91be3@kernel.org>
 <aeTTw4gziJigaNbU@lucifer>
 <CABZAGRHXtjzGJrgR1NAmVHFMP9eL5zZr3DaTAtAvywv_1sOHdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABZAGRHXtjzGJrgR1NAmVHFMP9eL5zZr3DaTAtAvywv_1sOHdw@mail.gmail.com>
X-Rspamd-Queue-Id: BAF4A18000F
X-Rspamd-Server: rspam07
X-Stat-Signature: zduacx8k4mtfhnfkohkw6jzjcizdz373
X-Rspam-User: 
X-HE-Tag: 1776667373-867358
X-HE-Meta: U2FsdGVkX18k4KlG1E0e35NxJlwGLZP9Q7WUqZGseQza2NvLPZWjrIkNUXWos004jdxv2NWaml3LvxZf2Dtjqe9vLePuwVt/Z9TokEtJSn1gZJ3ATc+KZ7RJVpJqv7IlYGE6Ex5DmeONNpjHO4XzSP4QWUlm6wG2uOYyRyZ1nJd6Uzyo6xjZ1TMwb3RXdEJSpM3Ldesvj+vm/aHFVpF1TRlDFScCrQVVKIGA9cgXlqKbTdjHMsIpshG4InqmmyQN5HDOOFE13Cb84WWqS6MX/lzphCkrq1nbR0su0MZ3i8Wy6LXEGLnp50t4UU9JVsv6dWOmfBrFljx7CRLCyvDvs5C/i4Wu7CQRKVsqZpZWan4OZ0w1U4GoRW4xacX8feUNc8UXxVu5FiIYlLJnSzifiKR9WPBluxnDQvfqNv0swkFQA0eSVZuK9awXxYAb9YQjU63Wnn4LsuItikXbe2e8FyvSMMZrawcjDCHoaaZG5qkSTgJbMhFAA09oHxJ8xL9ZU4ewS9cOvclHSfpme3cZiJscL7bC4F7YZPRtyIO30QeXlJ4MpV17wBAndSmLSWbLzTBnm0Qu70pyDWLwbmft7V8ZjIMXc311cM750jvP37vxsMMRGoDT/l+1GOhC2vmeToYZ11iQDeVRfK69uss/KXCwabrgkzU14aWvlvqIAsVR+Yk6CqlDMaoj8uijwMZepn5h7AfJF68GT6OvwijauSB+ezS0yvD3rpfeX2ovANW0j575Br6i8y5BkrGUj9UhTbriXgBK3JtCpXryxhAXkSKBq6KINrUKqgAjgKTwAm4fQqylBiwXTPfawhbKg7HtV2gL2WqLWGQZwtWe5SiGAhhNX6cqWoMV0g1tFWZrlmNXDcsMqfKPJ8zYoBQ3oBeIYyZdTg6xm3Uf639vgHOpmxszv7Ye+q/QO/uJm/q7sG65srrP4sf84kxusmEMSGgo099sEIyFAif3LZVOdEw
 5YYUxgXf
 cUBmv4Oid7OIcltRqfQf/n0yJXxYACMlqlVgt8PI3efB9YpHDuOnthCNvScW6lRZ4qwxX8xfIE7lp++XqBQR2ceNKPeUzdqk01SXIWQzVWvNPFe1baoAJIrGXQrqwybH71quVeY1TdLuNfbNJQa6u5icDdcJZIkLcuPNwvGgUxQbhP1fTL8DOFibH42cL62U+gNhdbNjnfG4i09Rn7hg28DOt3WXEnKWCjSn3q5pgSZGS7h7KXqRwJrHvpcuDba3mtBq8xAN0R5GHKRs45kghepqhP+uvN6bIdXAYGQoIghnQbT5QzZw8Z8RCdpRo0PswCuv9bOIBYvUgxV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nick,

On Mon, Apr 20, 2026 at 12:52:25PM +0800, Nick Huang wrote:
> 
> I am really sorry for causing trouble for everyone. I would like to
> ask which aspect of mine was disrespectful, so that I can be more
> careful next time.

Maintainers time is valuable and sending LLM generated patch completely
without understanding what it is about is disrespect for maintainers wasted
time.
 
> If I want to make this kind of change, should I send an [RFC patch] to
> ask for everyone's opinion?

If you want to make that kind of change, you should start with researching
and understanding yourself what the code is doing, double check the LLM
output and verify it and not just take an LLM slop and send it.
 
> Sorry, I really am not very clear about the process.

Start with reading kernel process documentation:
https://docs.kernel.org/process/development-process.html

> -- 
> Regards,
> Nick Huang

-- 
Sincerely yours,
Mike.

