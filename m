Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E2BA1112274
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 02:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCAD86B0088; Wed,  1 Apr 2026 22:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2456B0089; Wed,  1 Apr 2026 22:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF396B008A; Wed,  1 Apr 2026 22:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8EC06B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:54:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51112160169
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:54:08 +0000 (UTC)
X-FDA: 84612096576.18.8C16274
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf24.hostedemail.com (Postfix) with ESMTP id E1CBD180003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:54:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=iOW9d5Fq;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf24.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775098446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2chHKO41l61BaF4CaVmJKRvMWpCckYE9lhrVztlILW8=;
	b=K67Ng6JVIBg8o218yYsKxrXPgAnVUhyeHT+g7p82R2AznrhbvA6P4g5LBn/6TZMdFsAJ9Y
	icdQJ2lxzGS0jn1vFJobKc2oLqMMpGY3Zo6O8juneCVM0S5aKKV0+ptSaQwyfnuA21s7HC
	MklC29wTtZtQncCK5DMBNd4VJfM+2oA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775098446; a=rsa-sha256;
	cv=pass;
	b=xEjOgHQlNcBTouUWGV3+yD3LpTzf0jl1Rh/dC4bHd/6bKR3Q35+E6AJmby2ddHa8Qm0jSI
	oWRKapNwzF4Gi7G8WzBZ8e14Yd+PfQ4x6d1z4mVEqwSy9VLQ0FD31BNK985lwqchTW3SQN
	5GjAeg0/6yKWY9CdHUtnZhpTg5zMdiU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=iOW9d5Fq;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf24.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1775098428; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=NwyOwYHYF+ovVE/0l1pvR2adoXjoLc8gNdcy18b4kvcNutNZNA379WE5MzjM+VHWHu781n0Y6pmeaZjxZNak3wPCdYglYtGuVisSLdOM0Kd9QtAABd0PjQNc8RJxpKJdAJTFjQa600LwKBQKirlQS7YLkGTb74s1WzA90q5zwp0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1775098428; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=2chHKO41l61BaF4CaVmJKRvMWpCckYE9lhrVztlILW8=; 
	b=IhdkbiFPhcCRub5cayeQwS8u1tfnrpQmsFXvJFcoaZyPxk7Dn1EbTM3pwg27vgMDyMtDSq3VwhZ6Pboy1XZjhMXFHh9OHc0S7xYB73poJROlMa9KzM1VrM0mDc/t2n81Pdk1dusMzt3CTIoWZ9LCQNsDH9Z9I4HBzmAJDV9+Dyk=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775098428;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=2chHKO41l61BaF4CaVmJKRvMWpCckYE9lhrVztlILW8=;
	b=iOW9d5FqlMGgTSaUTOgo8E7lpVIZ564tvu0ZYzIwm0NbXxVGnq2gQyglw1O/v6dJ
	JhTB8wokoYrK6WBNWXZ3grOVeou6bkZqfqaGwFB8trzU28KFN7PavTOR5E96odiO7qH
	PrjDBS4TcwrZF2vcCBfCv0ABA0l6Qc1G+xKiTeiQ=
Received: by mx.zoho.in with SMTPS id 1775098426451998.3824273067871;
	Thu, 2 Apr 2026 08:23:46 +0530 (IST)
Message-ID: <31bb8a8e-2ca0-486b-888a-328e9b748ac4@zohomail.in>
Date: Thu, 2 Apr 2026 08:23:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/4] mm/vmalloc: free unused pages on vrealloc() shrink
From: Shivam Kalra <shivamkalra98@zohomail.in>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
References: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
 <20260401-vmalloc-shrink-v9-3-bf58dfb997d8@zohomail.in>
 <ac2L2VNExpp8t7oF@google.com>
 <7bc4bba9-24ed-4a69-b9bd-d45d647f48b7@zohomail.in>
Content-Language: en-US
In-Reply-To: <7bc4bba9-24ed-4a69-b9bd-d45d647f48b7@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: E1CBD180003
X-Stat-Signature: jzs1q5sitkfq3imjsezhw5tjkfohuy7a
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775098445-717866
X-HE-Meta: U2FsdGVkX1/6S7rE0eGUv+LenRPHJEiS0uAHfhJlQc2kWElKdZVrxObI1JSOltpmRnHCIviXW6S5jH/gn0IiFO4deq1aGlstn7+B+5TXZ4FvOIOegontUC+JSUncfkc2JRtfVuTsUZTxYwa6+VRENbP26he15pJUKzFZpDWUR3h/Gta15LLc/b95U9BKZCshI6xS0pGuwr9MSVLYEwMI0WTLUHUglIxn4pP3YJ2uiYPr2c87n3z/W8QBYtPWqDRfw0TZfNoqDI0/ySvVlnoMdA3o/31nOMA3BYJ4jKXgpx1Kqn8v1yxzpaD3juzG79vtKWLKgyZPTvX6j9n25LEPxA+L72+uscS8gLTEW03x/Gooxhzfrfxk1pQAu9KPp/rxwI8h8Dqb2zik/w/63uffppGp/TOoMkg6caYSrDeoR3Qw4I++5+RUaG4CV+jdfsM7/xR7HH84o+HMkY2jXEL4Yf7sBuqXvTSAgjbv5oSXr23gPFZLMOUVWmkEQF2z2ttYOhGSVv24WmlAlfsi5C3cdFjcrR+mprV1Ydi+R7MlwDvKqIX5rOrGZTLkc0IjnPmgCW0tesqKFGx7YTDFyR8SRlYnazGnJLT8Q4oclAN2aDqbNZCpkyKj/hd5BWtSBENiEZBGK/Oj21MeyE0dAgIM8QaW10UBSNY4g9IwE1uQ9YswtyspJn4yfueJmNe+jaairuijgENOvk0/HkhSiqm3x/MHfCUdD4EnvIPJvKAvYe39K+jzg4NHQkSvc+rbaP0zgTxSyZSKR03zz1lcE4sMVj5Gd5xskMOiYE6L2knLtqGY0NJcsBSQfsiOtB/fJq7h6PLmBxVtHCPpuJWaN+R76HCKAilTcv3UBk6ai0noYgMhQYchfTIokc4J1TCvVmnU/3YmKOJ78ejbbcfdx/kTa7Xd125bs4RBTCL1uNMXR0NXg8YRSR1IKvp/1BI98cyQHogtxYpOW6FiMkMDA5q
 718lHfwC
 Awm9jLSbnXGx13Piu8B4UtnTOPasb6QgIU9bPn6cp+EmmHDVRrJ8qMLON607MeL1h5rkQrE4CGW5a3pFx2SVpQcpXy4tIkgchn1YB78LZ6O0ki8aG7z9tcYiDYnPp28mcZl94BzSqHRHHE5TEZb5w+Uv/DM3a/WjJ/EmfGUz6S2ZCBNMILFNTeXW1FlqMKTRjfXhHeSuLAd2J6AhmLrTrHYt0bkQ8hmYONrKd0ScmMEbz4cW2FPYlzz7j8DXQtrm/6VuntbGZKVWIorLuav+SNV/b+0ZZU/XjSNrwh6W7sAfFGfunuhvIW4d4TkWpJrz51z/KyyCGh8edHx6m6AnPxDbSurxVuKc0ElR24Tx+CSrqd/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/04/26 07:31, Shivam Kalra wrote:
> On 02/04/26 02:49, Alice Ryhl wrote:
> Should we set nr_pages first? Right now, another thread may observe the
> range being unmapped but still see the old nr_pages value.

Or is this what you mean?
<snip>
struct vmap_node *vn = addr_to_node(addr);
/* Notify kmemleak of the reduced allocation size before unmapping. */
kmemleak_free_part(...);

spin_lock(&vn->busy.lock);
vm->nr_pages = new_nr_pages;
spin_unlock(&vn->busy.lock);

vunmap_range(...);
vm_area_free_pages(vm, new_nr_pages, old_nr_pages);

<snip>
If this is the case, then I agree this will be much cleaner.

