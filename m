Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA73CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 10:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A7D8E00EC; Thu, 18 Sep 2025 06:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F27F8E0093; Thu, 18 Sep 2025 06:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FA18E00EC; Thu, 18 Sep 2025 06:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53A348E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:34:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A43F5B8F5
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:34:02 +0000 (UTC)
X-FDA: 83902010724.06.09B4437
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id AA14520009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:34:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BNruJSl8;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758191640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SP9Tkq781weXzJ71+Pgl2qUYzdvsA9gnTsj+eVn6UVU=;
	b=1oRz9F3kngqcmeywWfJ/LQAc16Xnd9zUd+PwUWGKsa3brW1ErhsRcDUATxNqVQyGj9KreV
	ZZKLyMYJeMeglmLx27JPTVLCeFT3M3MWrehlfmg+mjGv4rkHl7GY2Fco+gj91ttGURq42K
	PSaTAFQ5pZAHMsUkkpqr6yLvzTwsEFU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BNruJSl8;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758191640; a=rsa-sha256;
	cv=none;
	b=JwWTKUUBV+tNYj5ZEKv6AqpIU2OqdWgPhwmeos2RTniHSv5CcfvBZjPA6r6oXlFQB5Klfs
	H7oT3d7HpE/glqRZ6sKMaXCMxuJTzU0bPNOBFqXe0ZOZChrFQ5F/JP9OLYBh5iyeD7FmrH
	dJqqi6umoK4wJJzZ7gvTbIwB1XiGHFA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E790B60209;
	Thu, 18 Sep 2025 10:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3183C4CEEB;
	Thu, 18 Sep 2025 10:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191639;
	bh=OD7Mw5ZrocAdW5s9yeVVSt6xbyWWtkvp2zc8JMWiBZU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BNruJSl8/KBB4up6PyP7UWp7d2fZ5VU2Y7JJ1RtQGHBcbm77xK8Nfa5Lpq0oVgeZY
	 wpAOm0qMeB4ZWzHGR2SFWAEPXE1VE2c3StJdhOyfwfKSs/dSinzWr9/4pyQYgp+8Jp
	 inT9VKwXqiT20OdmMqpanrVonSLTSVvGE9c/QgevrkvFYrruo6hwR3F8j+9vkz3dvm
	 y7M/lBBSlTGAPU7sg78PK8tjzGhik4XUg5NzFqMXb9sRa4eAQMncVyvgbPhUH6sVKn
	 QQfiOzYZBOOG8LEYn0iBVCw7kH3ZFCC12NrIRjeg8RwNp56GSHhX26Xyrv235hMrBZ
	 XDSxHqb8lOjnA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Baoquan He <bhe@redhat.com>,  Changyuan Lyu
 <changyuanl@google.com>,  Chris Li <chrisl@kernel.org>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] kho: add support for preserving vmalloc allocations
In-Reply-To: <20250917174033.3810435-4-rppt@kernel.org>
References: <20250917174033.3810435-1-rppt@kernel.org>
	<20250917174033.3810435-4-rppt@kernel.org>
Date: Thu, 18 Sep 2025 12:33:56 +0200
Message-ID: <mafs01po4gicr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: r4fdpckmjxcajew1zmsojrgtgoam6z1e
X-Rspam-User: 
X-Rspamd-Queue-Id: AA14520009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758191640-589891
X-HE-Meta: U2FsdGVkX1+vbDPcu4Xmmh1TI9LkH43VM46EPa58JW5Dj/dpkHqPXF79gJFYpD0YkaDSW4piCiYkEqXlvWx7QJX8qQCXrBQ7kvf1BLEpkmTGjXflPtfW7hIHTdpnMzi17jqOdsBH5SgC6Kzb/btUctHw27U4k+ldRjlIJ+YIJyf4vUPuJZhgT7d//zUPZn7jUibBSPmlWZGNb8Ia+PhR2WZjYkE9PQBKdOjx2HgjEd0nKY/SjA8PaABbZmkUJdjL661ZC1RRU9Wp9UEWmKqpRhvHWS3OPonUoWO+H40lRBpQutOPif60XuKDf0g8B7Yvtbdhs7M63roueXgekJmY3V3w8PF3VwGxqDf7+Zn7EA269ob/CtS7BuqsmsTQaTitbvsSb5skkrPbMTa9Hzkz77n1/fWBCMfoj7fh5U6LlgpOqomhmqb1T7RRhOcI0Z+9Ezs+1k5u4cWjhYvur1CiHYljSPGVVbUDdOaAR5E07Q+Ce17qJ/rJLVuE51q32HuOPYiNokeYZ18VSTR0XIuBA6XUm6zd5l+eq00zHevNELHkWT0EAAkxs1AgJKqZ4Nlr7EU/slBnIPmNfmAVP1xPWabINzYVMBsgONc2qtoY3S8tMXGD3TNIqO4l9KXs32mGhDlHPl8iFxeQAotCh4P7ICeoJk4uIxxi3BBVSb7kSbSZTAeC3FvUmSaAwSN2ZTxXBM4+cigGjfeFunaRj0QisspH+wGTWf/kFOH8Xpjc/9VNwjkVNoVyYQ3vWtBnH1+Ti65chB8azaH7P2wVJaxA0DUhT3tWWQUmoxAZHnC0oAs21S5EyynTdtakrrEqmrxxe0c8ZU4Fb7WZCE5MsR10m6e6VnkMUWXEbKUvfm5H2YKECsDmtimC1ngKPnqMl+9cNCkNqh3Kapk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17 2025, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> A vmalloc allocation is preserved using binary structure similar to
> global KHO memory tracker. It's a linked list of pages where each page
> is an array of physical address of pages in vmalloc area.
>
> kho_preserve_vmalloc() hands out the physical address of the head page
> to the caller. This address is used as the argument to
> kho_vmalloc_restore() to restore the mapping in the vmalloc address
> space and populate it with the preserved pages.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

