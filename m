Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C72F410775FC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 17:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A436B02CE; Wed, 18 Mar 2026 13:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371FD6B02D0; Wed, 18 Mar 2026 13:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AFD16B02D1; Wed, 18 Mar 2026 13:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8F96B02CE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:58:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A761FC2BF7
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:58:00 +0000 (UTC)
X-FDA: 84559942320.03.FB3E70F
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id D2AACC0004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:57:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wmSn38Wc;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773856679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6L0oGl6DvW6Y4v+MwLJVYT/n4crirqke5Iu0Ea7w6kU=;
	b=sXPmCqgJQmIpOctQSlxhgsWxx5ANjtrQMMztQY3aGJMHXmeu13vzFttLZ5ylQgk9XDDYe/
	eQeWxiIq9k4yMikUKAHZiCcu6sIIb2NyLN+98u0izLF37blmAkPGyxp7Q9e4vbMTkK5liJ
	gimgDED5wRX7UIs4iI2jdHIpDxziDMg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wmSn38Wc;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773856679; a=rsa-sha256;
	cv=none;
	b=RnEOcHc+sHYYNMm+iXialqY70UQH0yWtQE7a+1IWvpjr/GXeHTCET0kT0SXK0Y6QBGdmJs
	JRAJabG2UEZFjbWWU+NvYeNPyC4wfmIyVnzSX06sa/npuSO8AxdMxt269+207Y8QOjD1dI
	LQt2squQmIcZiKe8tQsPYeUfEvS7EFc=
Date: Wed, 18 Mar 2026 10:57:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773856676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6L0oGl6DvW6Y4v+MwLJVYT/n4crirqke5Iu0Ea7w6kU=;
	b=wmSn38Wcair8acCWtYsAZFwEjs7rralOYX8oELhjJFdOSEwgKudBL/ZL9GiG8/sKscEkwY
	C8hoggO/7VgnVPU39NOopdy6jSN0gCo7rHD4pIOkr5gqvX29UGlCrgqKCJxgAkQbPaUW1u
	nAjfmNEc+XphZcZr0H26eES6PdFLqis=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] mm: list_lru: deduplicate unlock_list_lru()
Message-ID: <abrngHPFD_6kHEP6@linux.dev>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-3-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312205321.638053-3-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D2AACC0004
X-Rspamd-Server: rspam07
X-Stat-Signature: e15cybsyifwr4e99aot3xd5a8mirfyf4
X-Rspam-User: 
X-HE-Tag: 1773856678-85112
X-HE-Meta: U2FsdGVkX18M7jYpYxOMeUdnJpkxsagggbglAbY97R47pjkR9ylF81xCfyLdo6Yq+4nawKPCiV6Pk9xB+K7JSuk75PdoyRe026n0gUDFikm6Xq+UGEtm8Nn80THFFLBUJEc19ZmVkjpkq6tQkfhth/gVjInmX6jqxN02CDJM4/Efwv8TsYJ51H9SuhhlrY1iMoakgEgJ1Ru9Aqc7CRFkrUY6tjdzX7o1/0qjDVYRcTvYvLTJEQelFKlgtJ4m69HHP/I5Lix7jWcJJ1d4x0ccqCYvBcFEeE/og5y+jrkbvMUxrfj38C9IlCct7YXzW0BzZ90q50JXN/R9SeI40dmc9uuPm1oTCQsTZ3IiW+JSnSB+6zBkseq0oU3oAs0Brs2BTkdzkXpogisGt+UXVeXApE3G/i+WC1FS4+XQ+g2MZ7Jq7jov+vl/J3pWTb1oujYCQjfvUIP4An6Oi9BQ1t60f72RrFl/ezUT62rDM8AiPLnZFq9p4/uxKcNgtd0RmvoKRglhTLk3+sHMv12DvxYcGX3j/FYnFAP7eG0U/rA9t78ZU/uBYyo0k/+xZYsKj5oU8yHj1mo818xfhiSfM4EWXhvI/EevSykP5RCWMDjGaf2Zrt0I+ZLaD/oDZfkqb05maMmpQxrkunC6uajefjdQpjEElyOM/2wbTRWS0brnclnu8b0yGc//YEFZLLn8/ZhGqZ3mh5ZK2KUDMYueHY/PyN5O3ZLvrSPAXUVeGgj8N77wepAReRX1x5CDTQzha/YvoTbrATdkEHCu2FTmVzyTeDV1RdsmfXelS202wVqgCD3evgDWi8W/zfncheI3IyAanB7XnMg5hjyGkW/kxK2f4kMkHhi3RvRIrpuCmPFDhgY0PezAyW2PpZPpUPH79u3XzwuW0V5ZnD9Pda20usPVp9NEzde7iFCLE3j9OKl6JkycW9ivIdrBPKG4psraSelFCfMiY7TTjCluTj8Bz9O
 dpZOtrpO
 Ht1iZdl3TPTnD0v4OCRKB47BYpBAHZYND0Zq4TzyWAkSqvwnJRfu2KrLhx7QKGdAu6layDysMWVRxnvZd+3NMjxZrOhjwm9K7npLcWZR5xdt/IBxRGq+t9kAGBPe4KIox7dzUJqdbzis8aSbzVQezvLXZDnG1i17FsRU/ABA0RiPVex+3lUW19jo4XLsn9ODiTvTBy7CYEZp6PyoTOgfBhyzJuZBDT4nNqMdzQ8PwvSrgvXpiBgf/jQ45+xawIHvMu1ouIv8vUBMTwzEYCRLTWXr1/gtClH02XkFhcMTBhS+iCLZKBfmxpuKp7779qnQfkQge
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 04:51:50PM -0400, Johannes Weiner wrote:
> The MEMCG and !MEMCG variants are the same. lock_list_lru() has the
> same pattern when bailing. Consolidate into a common implementation.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

