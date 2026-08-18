Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3144EC5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 15:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29CC76B0786; Tue, 18 Aug 2026 11:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DF66B0787; Tue, 18 Aug 2026 11:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164236B0788; Tue, 18 Aug 2026 11:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E65A86B0786
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:32:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 726211C0DA7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:32:05 +0000 (UTC)
X-FDA: 85114781010.16.5067419
Received: from mta1.migadu.com (out-245.mta1.migadu.com [95.215.58.245])
	by imf16.hostedemail.com (Postfix) with ESMTP id 664F3180003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:32:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="NPNrWk/8";
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.245 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787067123;
	b=0usSqwjWju+JpMK0P9nRXCI5kQYORzFbOGJT34ai8rQtnfKOvYibwvbuMoZWKa71TC+9b1
	spBH+Gv7RJQzlr3ln7UT8tHDRTAroOVkW3v2qtkpbK4vjDg3WfI76QqbvMsFCbVnxevQ3A
	QJomubyN+4SDl30lZOyjo++88d0y+2I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="NPNrWk/8";
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.245 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787067123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5K5NTE+tAICMRm0ODWT/eQu1+pFWobtD6usNHaaHgYI=;
	b=tb7wJQFaWs5TJjLefr6g0u9SRwkCiuQdru/PrQmoO898qJKused0MlvQxYY3dxLwLLeQVf
	NbrmZzyTiNoWb9wO1vC8ZB5biSoFVrxI1YymJyaOlmPmaa9j4kkx9oTE50EDzOzol3RpuV
	eb9JKH0rUVW/cn/76mq195Z5bASEd+4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Kdeaan5Dwfb7aQWrsouCyJljKgsAlowShmaivBol4+s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787067121; v=1; x=1787671921;
 b=NPNrWk/85fRh9m4a3jy3aiKSxuCVGnnyOWE18aW73h4xji8TVXP4Ouee5EePfeKhXFdVL3gY
 0sKNoask6+eqbE5EIwtL6kHr5s/2oIk+N2iK5bt9bT9KvmN7j23/HwPnkFbv+m/0lnVuUWUcooT
 QL7daabjuHhEKsijXZWCZcV8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:48::)
	by smtp.migadu.com with ESMTPS id 4162ff370782c189;
	Tue, 18 Aug 2026 15:32:01 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 08:32:00 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: liuqiqi@kylinos.cn
Cc: linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory
 accounting and control
Message-ID: <aoR6jxTrIjCujq7S@linux.dev>
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
X-Rspamd-Queue-Id: 664F3180003
X-Rspam-User: 
X-Stat-Signature: ngcb9i61thut9sf3p1wozodyc1mz44eo
X-Rspamd-Server: rspam06
X-HE-Tag: 1787067123-735090
X-HE-Meta: U2FsdGVkX19kOZoe6j4wvHtsFOqbMMcD90gICnyM1623abEkXCcMCAv3PI9cohq8YpCknxKUh5PZUM2mezUJ+Lx2cDC2Arsc5wUOyapPS6tGJpZFvWjkYUO1tyqc/bGDnvhXZGgl0/RnE7YCf6+KVahAMntiQS0zFQxzHPTVDTEBsk1RnjMpw2AXs7xftx4NwN04C7InLjS4TjKJpcSNB/xuAIBr2QXFGUZP6p5qZNWsGlEcokru6yNClu68LYpA+oPkmx1nqW9RzRYE3hmR1rO/HNs/qAmTLm6VNgSuoyw8fAnF7RYKtShm5bYBxfO5VcOyG/82KtuXvmxdFWaGltjCzySTYX5ASjKwjxt21yy7Q3xhNH43cbXDh6lX38l0yIxUYwc+Jlc2bk1aonCDY/c3imk9w4XMyiQ3H6XQ8XuVw1BVLUyglKysIU4bmTKWo7DCfVR76gcakuTPqhEs99DJ4HtPd0tEX9zv3Kbx1R1Ab8govPP+4brn53D3SA1VKYiLUl3N71d39Zt6/zadUmyrCOv+0x5XZpDnmspMU0vpIWcYItSUu/ocrhw99z2NcatBj1rPQ0KZBsyPz1FyZrGDGHITF2hBV5Smzl88g0aGjVAtKgaz/mXnlUjHORPLnTYR1NhcJg1Af4m24FdNrFkulu9dGtao0o+BzBtDkGqhBsIDEoDuQm7EjOqbUV/xAHQGdNkffoiWz0Ql6G6wb1APk6Bl49wbP8URQ+QYwQm1W+SkJTTpl1Q3aXdsScMnZZoUoNLwaCFi0MtClMfruiZWSLatU+PG2HonubJd2fnkeL2RxKRHbYv67h+Nadih4qZg7W7+FdXkKD1jTLDPxNWRAhrHs4aIeTtUIxWFqz4zgDU5tFumqo7JwjbzFImSvfylMAN0M0qMhXC7kWoAnNbUpJLXjkEiBRkWxLlCOrdyTgehA7XhDihlGuZvUHHgCUcs24WJA/tNHy0MHKZ
 OfNd+dB/
 fRtvCOjHwEhjjwRq/wWGGTSnV5yn0GV7toF0mQUEv5vq7fM1bjeHgHFzsrw9H9uYhpVdf0CocZmPEO8w973JVnVDJX9XpxGZSRIT5AI/pJQxIXaPmZZ2oEOr+moxWWoerJN+nNFvXEQrn9oQ7neWjo/mzGgP8oREuEjgDYqcdsyw5GitHQ+hcpBLcYFabd01q35kYNJQ6EGyEJZR4lcYLAUp8ox/W4IV/T2gVWge6I09j18s8OzF8YRTo83/f1gjAjkpxbHeU/aTe4HLZoLjP6scLxK9TaCOw1XZRGfaWuW8jj+hYBrc4KC1S0gkKZH1ETFPo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 10:31:13AM +0800, liuqiqi@kylinos.cn wrote:
> From: Qiqi Liu <liuqiqi@kylinos.cn>
> 
[...]
> 
> This series takes a different approach from Joshua Hahn's toptier RFC [1],
> tracking a separate page_counter per (memcg, tier) for N-tier support and
> exposing writable per-tier limits under a cgroup mount option.

Please don't duplicate the effort. If you have concerns regarding Joshua's
series, comment on his series and work with him to push the work through.


