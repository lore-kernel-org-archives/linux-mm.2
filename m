Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5A36FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 22:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3FE16B0088; Sat, 25 Apr 2026 18:06:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E187B6B008A; Sat, 25 Apr 2026 18:06:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54B16B008C; Sat, 25 Apr 2026 18:06:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5E666B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 18:06:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57DAC1603AA
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 22:06:17 +0000 (UTC)
X-FDA: 84698462394.17.E6927D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C1EB4160003
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 22:06:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X71ZYRkU;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777154775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUo6O5qEA3BGtVqNaq9x5CH6kHZbKNLxRp9gPSgfj64=;
	b=kgbpqPyQlyLDV0lLZV5gVpMvCxcirN/vkmsocLhqz6l2dQxxus/QOgGl+YN360h9R0dqvf
	s9QuzLLVpr/UWphCBs/29wJwl5MliP6NO410KlKdBiE2qvhc7wiq0P9bPtf4vNl/vu+g+K
	dm3YU+FARaKPshyWnaS3NJFlfJW7IWY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777154775; a=rsa-sha256;
	cv=none;
	b=SOQMGPW2FMNk5m7+70l1aCcx9qnGvbLtpGhXGpUULBjp/1L+lw6X+BEuK+ExIqQ1wVs/f0
	6HMQ+cvE2jMheAKGsgIHnky5BxXd32kX/DSl526UdUJILHsiJvv7KQhlbL7EBSejHYOETV
	2WkwIlpUojt7s4UJOJ5GNDJmmIuwA1E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X71ZYRkU;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BBE8C600AE;
	Sat, 25 Apr 2026 22:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD45C2BCB0;
	Sat, 25 Apr 2026 22:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777154774;
	bh=JmdZeHb+QkjT2bTecCzSWXS+NDAQS1axJxUikbfjX5E=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=X71ZYRkUooK2QqiiRZwySFYsaMow+deyEDAryCidXeWa9PgkyvUgzYm9S5ErazUw9
	 gcQE6cyLQZMkLso7SUwEcmR6LXogQmN9e0CHQI30/Dj7c0kd4TYfvwGmqN3ehQPzjn
	 HvFw87ovDcooQiHikqH74uAiHUsXwdssPwhYk8c4=
Date: Sat, 25 Apr 2026 15:06:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason
 <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v4 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Message-Id: <20260425150613.95532603a9a9404c7638f65c@linux-foundation.org>
In-Reply-To: <20260425150131.c4b3703b65e6de0fd3893d48@linux-foundation.org>
References: <20260424024915.28758-1-ziy@nvidia.com>
	<20260424024915.28758-2-ziy@nvidia.com>
	<20260425150131.c4b3703b65e6de0fd3893d48@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C1EB4160003
X-Rspam-User: 
X-Stat-Signature: zs65fzmt57n1hf4mg3gz8cifopo6jpu6
X-HE-Tag: 1777154775-672401
X-HE-Meta: U2FsdGVkX1+egv/JHv9Eyb0ZvSo+cQwJfziUokHBjuXeWPdU75weiZZJ+rLwpGkqQuC0TPSA+SCWUaPERbjIeZ4qNIwrmcUZcEvBOneGKp9p6RCRfE9vyt+JlHUU2yzCFyKR2WEh/O0eVapdyHdWFmiQdW3v7HcoeA5SeCK7F2KGsL7zSwxELRB0SoWv9W9C1aSOWEJaTRyQk+OqhiNUQ6MV7QTRexhWar5EUUnMzzqimIr6Y3GoLSUmPULqNhXaMxb+GH7CgqRpfipRy6VyACnjkrJj9hOHdyS9gtk+vyrFRfPzRzMBDCEKnW0HeQhCUt7mBybtptVG9h8IR4mVkX/8z1uiKISiDxq2N9BheICNDsMkc6s0R02CDyePfxfWM044FeisulwY46SseteN7w6Tc9ehoPUuXyT46ngIPLXH4gwuWXVrUzDaTYXWmGwhBbvLbRc/zrDtEbHr8cxRZRH0vba6a7S0uNhQCmlh7+vgDpVkIZTl4QYJ51cs6n5rqnYL/L1DqiowhRaw3Sof2ojPi8KYLtZtnxXtkzThvlig3s0GUjIJixxFHmP26uBtK02AI/uPOmuTQSSybgJrcUT/ZqYMxQ896YWGWK6BLQiEmHIY7mztUB0+6w8MsA+jWTP7Tw7AGBvclRKv/a5BhPfY2yoASvaO6Snn5zRRzs3E9faOWqYK3uKHzsWU9zmaxxDAqgNLiMIPnAcDSG07Dk6GMdQCZLtRmByarziNUW/nARfPJ3VirFON4IzcvaK9Ocv6NEq4h6/rNdSYyWT5Fc+rZVzpPD+I9KTHYFAolRoqjaF3+c2niGeRa0Cfg2ppIBtop98PvOccKjqi8kQIsOIHEl+r77PMd9mktlf1ZSGg9LhjCO/w0qjzpX5bft8MJC79el037g/ork3k8SZjQNuQlkCGAFENFMRQZvvvzd2hczvm1dlWSHad7hsr51mfGAKgIYsJY1h+iNGkd1D
 Idz7KE1/
 cV/KHmtSsbtknItgzrpTYeGHm7KzMVVf+WWAuYic9yML/bqZHzLuOlYjpADPzSz2h+cYPR8yvEcXSVTxrptncd4OPXNmmGhHaPgwhNUpI3Gf721E1pnC2tNtq7NUgZKGQviasAsjPcTlnYvUD8DcjfQKVR3Vz0RI6l/+hJ6hzJ7ustKXN+2KoWCKKMG/PJLUucsZno7HrZlr0MESz0+EEOoG3Q5XR9oaAavjvioVwNwpL8R0imCBN1ercQgoXYZM3r/e6A4RGqyHSFR9kg9PH8ZRQ/CjIvrE0zV3td0rljDH6nrKCu1Vc2zaEfpQW7qpLwzyx8A7AzvGEFLMTHmRTfx9YJak3vkfrnNXrzQP9J3JYbJd3mSFX0ac1WfzGk+reba5pCVM93oMSKImF0zuzFFgdRZRzI9PP1WVwuiCB302KN3IIHc7+9G4lNs6svwjXLsXGM0QrSQszOwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Apr 2026 15:01:31 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> I added the below.

Nope, still doesn't work.  I guess 32-bit arm doesn't have a PMD_SHIFT.

The series has a few todo notes:

https://lore.kernel.org/f416ea70-fb70-434f-8807-6638c9787b57@kernel.org
https://sashiko.dev/#/patchset/20260413192030.3275825-1-ziy%40nvidia.com
https://lore.kernel.org/DDB6CEDD-116D-48C1-B558-D64CA2F58F55@nvidia.com
https://lore.kernel.org/896b3956-3cdc-48b5-a0a0-a3ec35aefa07@kernel.org

so I'll drop this version.

