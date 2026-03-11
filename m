Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A80FD88D8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 01:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE4756B0088; Tue, 10 Mar 2026 21:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67D66B0089; Tue, 10 Mar 2026 21:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69B36B008A; Tue, 10 Mar 2026 21:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A10816B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:39:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FBDB595CA
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:39:45 +0000 (UTC)
X-FDA: 84532075530.13.4A050C4
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf13.hostedemail.com (Postfix) with ESMTP id E9F4D20005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:39:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=W9VI3k9Q;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773193183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rlL3rMH7IAqCMlpwtM16c9Atr/f+hEaClH0Myc424I=;
	b=qWtfqBl0NI1pHvoscnjoLceWAyC5E4g4XNTCdtW+VSFX+XWWiBy8ojPAr4y52NBo4/70C9
	+I287BXkQ8Xgsuvm7l0NFNwdvH/yCoasoeGqMR50F3rdmnIKLxmKo8kSWKTzdwLT36/XKX
	oYIcg2HqfloO7iIW6GFI4bLIWAvNnJk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773193183; a=rsa-sha256;
	cv=none;
	b=ify5Qe82nFb9si3vhcgm6TwPO57rIlZksxOBvQ8SDZEOm3BjlBPEx+M/q4f2jh8Yixk40a
	Lah+56biDusFxYfhXPEQe9i3nQLrr0JcnsFyyPSwbaTxRmYZQzql3rou7YB/lxhfOvHDyV
	B2ufjRnM8Xvz0EtywqXMJ01RK9quPvE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=W9VI3k9Q;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773193178; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6rlL3rMH7IAqCMlpwtM16c9Atr/f+hEaClH0Myc424I=;
	b=W9VI3k9Qy3hGWkmkk/XIJjMUMhn5mSr3cM2KiypI5P10oChDRpKsaNEzurNi6xbZuf1UjcWzNFgC7O7tHYyZ9XAFOlIW1p4ZaN7mwa6zQ1FWsnXRYD+ThnmEuTmrvZs0r1eLBkcQzRMMAWA1baKiS97QC4VQl3LQXtr2mohoXes=
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-hr21m_1773193177 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Mar 2026 09:39:37 +0800
Message-ID: <5f3f7b93-5e22-47a9-82b7-dd961a80f532@linux.alibaba.com>
Date: Wed, 11 Mar 2026 09:39:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
 <20260310-thp_logs-v5-3-686099175bf6@debian.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260310-thp_logs-v5-3-686099175bf6@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ktu4dd9jem9bs4qphhpud74xmwh5gxkr
X-Rspamd-Queue-Id: E9F4D20005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773193181-953731
X-HE-Meta: U2FsdGVkX1/w88MBK4vex2z7e5Rlnw68T6FY/5AxHsG4Y2nUmi7XV0C0q4kKAylQdkE02MyBsdHHyM1NFuf72Uuvwp/PXZ7zjSZcG33wWMMtM1A+dYHIgzw8h+lqqlr3DQzD09jOSDaDtNzyYw86c1rcaxYRlVk9YbeWcBKQ5RIwt2lk1sDuYTPFB4wClY9dh25tconOYYA5IxRVR9wdrshpqUYspty18EiFsMvLEXCHhvx36p7lgmoVdWI17Lip97adSzjQdSAvTkX22vY6bIIm0fafadzg0fCDmhR7LOxEJiGRmy6tTXQEoVRqEe5iZP+gdKgC3bGMVRhl33wKeqs2O8fSlN6BMqtxojJEtnlH82aCet1A98lDUM67zVQMLmLfxxYLAe5Gyd0w3i+jgpAotfw6Vp2h4uRCJbXb7AS3VCn18hws488e7T2li4dqgAio53wMcbnpcXf6bGV0bbUSRF7zpHwKS37PKY+Spn4wws1oKyDpu6WZC7uMQJDhklYYC/589ZwdDBlMOR4hB4lRKnV6VxITe11F1+obfcq7ngX5FFbTXNSDeCOy3ecj91jI8UpvWLn14n3+8UO5PylPrv0+ASyMRi3Vl9HP6JeRhtAFxrHRQBkBnH2hs5rjBVposi1AHhgzGsUrJ9r+ivPvOl1l2WybQJhL2v12I3BPOLG+SBlmY+xyssSJRUwIzoT5No28yJV/Nw6MAl14T7J31D5GbwGS+YV3Jn4i0gPTsW70b865N7Bphat81X79SyAT0XW2jFCFROYYKfqYAihMMrF98eZwB6sjS52dDxMJeQdFFiO/kZBkv5hnitJ69Y42jsComeRZq1a4D7qYhAWaBYxgk9BL721KRrfxkR1VU0ZmGZPYPmTMYc+1l5ZEA4DSy4rz3cNtR8q9Ro+iNczlwPukHWdnjlGU2Rh8ygqTYkIMbHEGCoOo6071P6NpyjG2Z5c4z/cU+bsuefa
 OxAeuBHY
 1I4aJl2DKxoSGW88NtbybPqdY9o63Lw1G6u/7MOQRz+MKWR5MFVHGjr42jX78oljjRwF2oV5ICD+skjpuDJsRlW1B1s02vKrl4bugPNxHn05q+MEXFhTXXGczI3jGI5/ks86AwQPtuEl1MUN1EuQnyuSVIFacHAeLqSgeueqrOcWLR+sxcWr2hZpuTD0rqv1StsiL4JZLO5tWDsQydKo1ANqy1hDhflOv+qKiLbHktnGOBFmDKHGmibOXQjtYKkxs5BDY+c+zOm47hV/6R3RICvYCmXtI2RHNo7cJi+RXf0DTN//8PLuTsrI5dNsGqIz8EjMFi0HBYpAP0YWYOaV9lt037bFhc9DOAY/Cg7kATbV0lI4vWdrU8X4p+BlUK+5VmrDGnlGWW6lAKLb9McUTnI9Zo4hR7noIDm//mBnrxG1htbI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/11/26 1:57 AM, Breno Leitao wrote:
> Refactor enabled_store() to use a new change_enabled() helper.
> Introduce a separate enum global_enabled_mode and
> global_enabled_mode_strings[], mirroring the anon_enabled_mode
> pattern from the previous commit.
> 
> A separate enum is necessary because the global THP setting does
> not support "inherit", only "always", "madvise", and "never".
> Reusing anon_enabled_mode would leave a NULL gap in the string
> array, causing sysfs_match_string() to stop early and fail to
> match entries after the gap.
> 
> The helper uses the same loop pattern as set_anon_enabled_mode(),
> iterating over an array of flag bit positions and using
> __test_and_set_bit()/__test_and_clear_bit() to track whether the state
> actually changed.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

