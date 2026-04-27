Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B76FF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 23:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1D2D6B0088; Mon, 27 Apr 2026 19:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4DB6B008A; Mon, 27 Apr 2026 19:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D323E6B008C; Mon, 27 Apr 2026 19:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C06866B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:39:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BB0F160321
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:39:34 +0000 (UTC)
X-FDA: 84705955068.01.4A8C9DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B7DB94000A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:39:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BJAG5TPP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777333172; a=rsa-sha256;
	cv=none;
	b=OhGP694kWzcTfsESvrK0PMZ2WkYD9SDJWUY7w/d2Bf/1+VKz2g9qPTvn6VN004f0HjEZ19
	/Yqm9cPcHmCBG/2dOFZCcpEgQ8BnY9z0QKdJn8uyW2sFW57u8mTAY3oyWSe6GDFnK6hapB
	zj4ZV0dhizay9ZMzQ6uMMa4l3dYsmy0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BJAG5TPP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777333172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VN0Hs1g0lWB5vyOJHHC+4bZBovNQKm+hpzBdmni4IMo=;
	b=rNK1h44cgTWjpLdNOtG9Uf8N0dknZV0vmvD03HL/tRstxZJznxDxOL9ugr5i4A5ZR8TDsF
	72wOh1l////8Yqbrz3EgnkVs4MfYnHkxNb1iwYzg8ptH2/p1xPsiMqd3vjx54zG4p5SJST
	quE2sdJtI+rnjwpt7rMAYs0KdM2Jifg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CFDF60121;
	Mon, 27 Apr 2026 23:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA48C19425;
	Mon, 27 Apr 2026 23:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777333171;
	bh=Zl4RMPcd3Mruw3bjUpCvED7vUUWsDSlxRDKdrEHiNik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJAG5TPPkL4hNzaTsW+UlTD8dKhYf3YmFzUu3qYI4XfO6Eeb8u8f/9kam+xhjK4Gz
	 vwiZCBPy6dl/PL6NWYOnuMiHITcEJbJJA43QQscznMkdnL6P3D4eUDZaBl44Bj3D3/
	 khW/QfN9fKl455dtdmlROmX3g31VfX3+qo5H+n45e9QQEWK2tQM2XDeq0SUqUseMLq
	 io7ErQmwA2i/4QuFPcg6yJ3qyMxXTrDcnea/CNUb8bFN7IwQQuE5xW/o2qZq1ciE2G
	 x2CByJhldavvm69nIoAITyXdcYCeqhzAFQPXQ/3u1Dd+lRO6s75RUTr8yDAOW+xF2L
	 /eO/b4s2JFfPA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cheng-Han Wu <hank20010209@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] Docs/admin-guide/mm/damon: fix 'parametrs' typo
Date: Mon, 27 Apr 2026 16:39:27 -0700
Message-ID: <20260427233927.146488-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426231619.107231-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cxzo5pqx4dim5j7az7rap7tq9wws46qp
X-Rspam-User: 
X-Rspamd-Queue-Id: B7DB94000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1777333172-160289
X-HE-Meta: U2FsdGVkX19KzKgEI/w2oFXghul9OKTKLMq9YQwXVZQ3Lj0zaDv5ayOVFgOc2r8P9IyoyA74vmvl2N4nuyJdEcRQWcWf7epKO9HZQJ+G7JIdpLhOd0lp3QFqs4Q9YruVV5ENns7wvNpSJ5CzNFLlLRnvY8MvysuOcLoWFz0cq1TH9ocRUxypLxbBRVpGOpJ/SeG65AXHtmNTYev4/SuGLfmFCCRcZitLNvlLSk6WecLj/nlcel6uv4QxzRhr2WQN/S5gVp3u3rpOrVpFwYSfeI/UrwsUImhSqzLmxqHmymVh5r3WfbMLYCC+Lu75fr/kLeL3lUyEg66k1shiODdYp9zN3Wwcw0Bbs2xC1y0xzvrXVk4lYpKcHRUCFrRvTJWguODDTzpCzGpH4niz0ZriAQAONIFhtstrhDEm5RcK7BDkrNzrTDNNVwxssMIGjN5U63Qtmqg+kk/HmslJRB7LHdnsGiau7MOi1wJ8j4LgtauTYes3XNzF9cLHr3XPtAm0jz6nWTkKQzOa+gTPTfpSSpUmYWK8rJxm4AdVpQJmY7qsSoV9Ww8m8cc+bSn2z88Ja4KtzWn9r3VG+ECEMssfB9P0gkMMAvptffRLKxio1S00ClYYBPhoDuSAfGR6YxRgrqwLnfn8BuekPNuJT/+1N+hWMu1uuQNSeFAuH/7Uzj/d4mHVgeXvGbGGOF+NBPe1V2vrBcLVheMTSvdSOj1XlZ7D63EIy5fyw0ajiBO2r5x0aPm7gVd+gjaUCVyIVps+W13lcP5EtPN4SBHQGsMu+/fPhLt6BKka6es0KupHi7cHdVC7Ua4yvsdnwcU6W0qmMhhbuMDe0Zou/XBBR5PygMK8/u9Ll/BjDaYLJwtbk/4y/B/OK22iQ6NXKEFh1LBqpf47xaa4YV7zaZuqvaw5YsBP7yDFIkpexE/aol3OtfAh+2PaQbaAC2O4IZqPAcsuiRAH/tzXsQYm8Orlqhg
 pp/9eMSx
 PN8p97UuwwoVSGIuRiYk4WdgfbU8K+CTUT4HWHhfW15XPhbNGQ7vbx5cGCoDz7mTYlVFoyU1wLhoKabE4s8ZVn8t44toIndWA4DHOksl9/1QP4N/8ltRcKnie28pzOLOa+KJSrpAX006RXLOD90kCyq3nGHi3tORWAwanlBYMBsOqfOW/L2/jNySrLue4Dd5C2vh8XdxxG/z+EPgfba8bRSoREwWsDtwC9GCEXsXk1Q5f27LP3CZqapbNdQXeWj4ZTlMi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 16:16:15 -0700 SeongJae Park <sj@kernel.org> wrote:

> From: Cheng-Han Wu <hank20010209@gmail.com>
> 
> Fix the misspelling of "parametrs" as "parameters" in
> reclaim.rst and lru_sort.rst.
> 
> Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>

Oops, I forgot adding my Reviewed-by: tag.

Reviewed-by: SeongJae Park <sj@kernel.org>

Andrew, could you please add the above my Reviewed-by: tag?


Thanks,
SJ

[...]

