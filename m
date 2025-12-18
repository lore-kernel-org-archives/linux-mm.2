Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47673D6ACCE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC11E6B0088; Thu, 18 Dec 2025 04:11:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95306B0089; Thu, 18 Dec 2025 04:11:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1E36B008A; Thu, 18 Dec 2025 04:11:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF6B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:11:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F050140E1E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:11:09 +0000 (UTC)
X-FDA: 84232022658.04.8F13FC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7ED84100006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:11:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OmNczh+k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766049067; a=rsa-sha256;
	cv=none;
	b=43jgzA9ZUyaADCM0zVcZYcQojngD15uU8FG3IbowJrgCZw4+FTHFDJ4NYDEqgsPEEF9VNc
	grphHuPTqfZIxm//Fk76ySO9FXywfCHyHT7mEXrhwpjOUhoXUroSJdDmJxCbeMmqbjrPue
	q3C9n3EqKXUfPy9/rQ8nDmIqPRs4zU8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OmNczh+k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766049067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48i2oJ1ZUdK0wTvO01NlnWTH9BWMf0RcHPVgaGdi0PM=;
	b=NGqZuyVzlYwDWbSmvwUnceW7rrHsyYrF5v5S1NUOPK9j0gaVqpW36GDBrk6eSIVICggVGA
	oQCnOFdcpSgEp1KBkOfydnpCQH5xwf46FgFMZaR4cAmBeoKGT+Vm4f5OliVZp8+hpps47p
	GYafZ7hGTgqqZEG15hSxj83ZinsKISk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 595324381E;
	Thu, 18 Dec 2025 09:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB33CC4CEFB;
	Thu, 18 Dec 2025 09:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766049066;
	bh=m6maDrxugfkeNLKycZHBYmyqUqhUOYOT2Iqymt3Cj9U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OmNczh+k7Da92qoJ93NeWV1genL1oEJUEO12ITMlEoc1P+3ATqHCpBDJh2vKz4MYz
	 JcrDdPzFzXoY5Hz3kj7oWEHWUO7d0VeOP8e/QcS58ouVcLE+0Xi1e2hK1ZqZMnsplR
	 GwY0F/lrXnCBOuc5KdGOwPHXT+Yn8AAmbBWiZUd0OA7Y46stI+X4ZBaNKNTi31AFbB
	 CtUc0ae39TdcjcQVz9aZnRy1nl/fOFnPOvfI0RFfaah2LgxnK5rR4zMDTa9tHhFAek
	 IrxkC33jw4gIJnQ2uLNOSgrc3PUEjl+ut8o2x3KqAla6AlXhT6xVacsxzWj73LYMMf
	 nzyJEqvkh6BYg==
Message-ID: <2e153b06-e541-41de-9b5d-7869dc2aba72@kernel.org>
Date: Thu, 18 Dec 2025 10:10:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/28] mm: thp: prevent memory cgroup release in
 folio_split_queue_lock{_irqsave}()
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4cb81ea06298a3b41873b7086bfc68f64b2ba8be.1765956025.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <4cb81ea06298a3b41873b7086bfc68f64b2ba8be.1765956025.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7ED84100006
X-Stat-Signature: wu1a3q4nz4er1c665c8heskntdbo4uwr
X-Rspam-User: 
X-HE-Tag: 1766049067-80435
X-HE-Meta: U2FsdGVkX18ffPKLQsBH+DYJ8KzQdPLGWABVL3O9ocqS5NpHpX4xL92Zh1BBkLU0O2KOeID1LYT+xTu41Js+Uxg+DMFHSst0hqRsKQhz8QHTF5F7eqvx9fDveDOorMq9z4oFpHFZ5bKUByKlSsb5WhpWvKFYHvfOGWeh2VrYbmR5BqdU9JnZ7Ha5zdNmslbrdG+ERRUwuPxfo1cTtThM4Kaq9A1PthK22yEbl03soHu6h5xTwDjtDoPmJ+xa/B15HsfJHSG89jqAYmFoKJcxBQXE9fi40SUX4cIzHGhxI7HEUc6T3jrpqXG6MB9WgvEp0L723FztDNgbiqsY7IQmGom1x1mIDJfQozbXU/I1e4fXUwuRNNHPZGu/5X/Si324joXoB5dy/jWKnns4d7eOnR847qp06VEQ6fXfGt1aRFtZZlqj3d66uY3mFHt8DgPpgZceT4GJAuKF5Y39VLBtxA3P6D7nUjIcsMidvfCXgvmRkbRV1JjMt64TEw2PRj2tSw9ZVCcows1yROBo+G9c6GWiryX3+/8ND2iy77cnc84fzRb8CES5RuU2Koegk6xl6YpFsEgJVZWl4f3KqPBxmklUGl4DF98ThS1yQsIXoI092M6oeOdUZdvRLsgDDCGLuAT2btkOwQ9DM/2/H9DdqQfhRTiOtzdGb6Yl/ByCIFH18y7hm3Sy7zvuy/ETUgVRjeS934UNeQi77QVacci5tY40wDV6wjCYhxCmCKeZJycomEbPxeKGf9YiqCz+uIkYFPgPsBhZW+1+/B+RPRS0YQlRn/OEuiA7W4yISAqlx9mje4Fx1xudgg1IAdQT9HAQvpuFZ71jWyzlOJtbKbr833xPDspzfwMbHUJgR9I/TthqYqZ/wim6k9xU8ZTcW4Rqwf/KjamVR/LVpY+gz/REU6RRROGMT8VGy71JviTj9Hp+PQxcyFCiQ9APRleMv8e6LFjsoNkQOgzWYzj0rZU
 l52ePWqS
 X8iD4oSGIefcClnbqAMUYy7aylk/mcKc51PPv0ksA8+d55u1a7+//m7DvALSzsfX6NPvuQkQ+ihEsj53r0CArkU3Izh20IR4mjiqenK9p+ORetMqetn8iTUTw8TtTiQlAk9HueHSIymsrv3EYszV3N7BxtOoAhZhzbXBfRo0nhan8q0R/URO3zP+KwqDThNtkYuP00HQltpAlM2xwedQ1Z8MrvWcBKRNcYNrE55VSVpbacviGsjT/nrZhP2RKxg3lNj/I4ryxCvLhBrxuTw1559KGj4hpzcRXsm7mgdTGU+YCVeZTGiYMHEBwjaQZ8PkOqCePLe2XqUVnzlWffdTNk1ncxbAU9fvdWpgJO/HZ9f/pCajAPTsMnB1f1UGat9GK7fURTOf9T0dC8VciTtj3wDtDsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 08:27, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding memory
> cgroup. To ensure safety, it will only be appropriate to hold the rcu read
> lock or acquire a reference to the memory cgroup returned by
> folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard against
> the release of the memory cgroup in folio_split_queue_lock{_irqsave}().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

