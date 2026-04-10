Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14521F459F7
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 16:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66EF06B009E; Fri, 10 Apr 2026 12:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1B36B00A2; Fri, 10 Apr 2026 12:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50EAB6B00A3; Fri, 10 Apr 2026 12:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41FB36B009E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:01:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA45F14058C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:01:25 +0000 (UTC)
X-FDA: 84643110930.04.456CB59
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1BF24A0025
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:01:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rcC6Csud;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775836884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4dwVe4qe0qtKeUfaQd4xMTjVQrbBZaeXbt0v3OovSU=;
	b=BZZayZXedec4t5RZTglIjACaHEP9pNTcTPqw6sLg91XIGUlQI5eBEKIg5OqZbk+GKt2hDO
	ZZNzZNraOO1Z7jge55xprKm1lQV+DvW3MtZ0MTdlThjf7J7UHYbSwRgNICmW8AapNfsmfM
	vmVfrZ8xebHW+aJlBnvbk4bXl7HblhA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rcC6Csud;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775836884; a=rsa-sha256;
	cv=none;
	b=htMHTshFpxKkZrKsBoNFSnABjh0aEQbBZ1sNEpk1I1rlkDRqiIoqJaMJYH7/8f7YU0zCWM
	XqgDDLpEumpRVlB5b6Ae7UNMAz0pRTFAKfKw7giwmmUQPuABvkXyejdW/W4tXTF6gJv5SC
	kyC+rBDzuaQQUvLUWzB9iVBEtl1ppLQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775836882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4dwVe4qe0qtKeUfaQd4xMTjVQrbBZaeXbt0v3OovSU=;
	b=rcC6CsudGXViKn5XD2MGxKb2kjDU49odFdFTlBN0pTWTIpjofNeJTFEopPhR6FlK8Iqw/W
	W6a5pXobE4rMt9y/Ja3z2QgFTUcSdpH+zQqDMXCpXRC2oVrsxZUARVDNGF7GW/iTYtPhNa
	S24kImO9DnfTEp0UIxySlpwY22IirQ0=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 01/10] docs: tmpfs: remove implementation detail reference
Date: Sat, 11 Apr 2026 00:00:59 +0800
Message-Id: <20260410160059.63419-1-lance.yang@linux.dev>
In-Reply-To: <9a0bed627137a1a0055900114ac6d4abd3a9720c.1775679721.git.luizcap@redhat.com>
References: <9a0bed627137a1a0055900114ac6d4abd3a9720c.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1BF24A0025
X-Stat-Signature: zcxb4y8z33fqu8bh9fyzhkdjau1tqs93
X-Rspam-User: 
X-HE-Tag: 1775836883-946880
X-HE-Meta: U2FsdGVkX19k9TzqLFWUrMgpNl3919hcOW8kkm5T26Z0/GqxuSMkKsTd0hiBnrEteRDyEwBZ7kjzZsJ8yBGF79GKaf+tA1Z0J4zk5fA5cqY40sxY8Yjn0JziuaLZrgLiw2omuVft0powmapttfV0GlqY1qi4MM3GqTt9IrlhGXAO24osTjrctK/V9V1zZsnOrsdun0ny7QY3iVjpiMdwH7Zq8KqcjHA855zHrbvElI0KZNdfqOyYp+WwIXoncKNQtRwTF097NItYlOTmG4o7aGyBLMvfflLAhUY3xXScYwKOkp6mNvqgMmMWf4Wk2yWktrbka/bS9AGLfGWTD2fe2pGi89ujtGOC6TDwo9RkquSFba2bu1JTO/q1ZoEuMOiB38Rmj0Zcnr5mGnv2bwDt5wmK6FRMHAabvuTHTQnvJSJbaUS85uo5yZooOMrsRj7bQUEWCYOLifGvftP1SfpPp/y1MGnEhaLqFFH3d9U2k6mvQm0oA77bHNaU2H8p8WEReof8wQp9mOylzXyH3WevZiZ4kKXVj5U2Gu+HsQn8RxzJFjLF3xLxWhTaDxIJVGyOr1R+qSwijSxy6Xu/tK9PqKnGGDvIWNNTYCeOsyvRso/AivmRtvnouMVjuWB4nCcnt72+7uyZ17zMOMkWtbJ3s7+OYuRSrvhamETOdUUAiLSu/ZWf1MIUOhwIqXLN3x7VmZhVgOEZlgduOdsW0v763EBOEOEqhXYWeZaPc/m082Q/Y33YeYokW6vz46XdbajZMRv5m0+RspRRbyi4s4z0LqwR+SiWhTod7ZvkhdKDrI8UExJoOQkDPz6JJYotG4BfcCqg+PwCikmq4rIH4YWmg9JjC5LJwjVKK9aqa7xZK9ow9xFhH0bTsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 08, 2026 at 04:22:56PM -0400, Luiz Capitulino wrote:
>The tmpfs.rst doc references the has_transparent_hugepage() helper, which
>is an implementation detail in the kernel and not relevant for users
>wishing to properly configure THP support for tmpfs. Remove it.
>
>Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>---

Thanks.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

