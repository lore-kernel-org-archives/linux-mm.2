Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D696ACD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 00:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D21A96B0005; Wed, 20 May 2026 20:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAACD6B0088; Wed, 20 May 2026 20:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99B96B008A; Wed, 20 May 2026 20:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5B696B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:49:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 390C01204A0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:49:28 +0000 (UTC)
X-FDA: 84789593616.28.DC747FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 946D1160009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:49:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kJNU28/g";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779324566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKo1aP0/SKSLwZJzYxUUuw1WaMCrB0NW5OiyxLWZ3zA=;
	b=Pfs+aBYkmrw7ypDoO879ZmJ1iDylRukG1X1V6VKWn2eFrd0c6Mc/WzmADhXIpDF1ZUsAjb
	h89LiyCQTVpcMTqcatSMx3qYrLfo7DVrvXvK/l5UZUYfgXccCSM2t7ouq8zmhUIcSScd4A
	kgDwlGYhZnocrb1+A9S0zhfv+dG94ns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779324566; a=rsa-sha256;
	cv=none;
	b=I8nXFkXMy0Tm5BV0CXivSD2SmGGvh9DotuxcSMQF4J9Uxlbb9TKVRAT6XkljxlsV3vKK0Z
	fhWXz62BVxXL6LOSdJuExrpmPknf+XL7wbX62KPC2CiGbu7a3UkU5pb2a6i9aZAnler53r
	gpYBW/ajVjHbeGXgTCnGHWeql2lWsWQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kJNU28/g";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BCFA405AF;
	Thu, 21 May 2026 00:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279631F000E9;
	Thu, 21 May 2026 00:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779324565;
	bh=KKo1aP0/SKSLwZJzYxUUuw1WaMCrB0NW5OiyxLWZ3zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJNU28/gJtiaRbltyxshjoVgo0C4aGpGSML4BCYjRSvwHeu2htfow7DljhONdgvsL
	 ebXc9MJk6xUunU9zYuY6oXatyHTVKc0guNAI+pWh24bj6n6Z3SiRIsjGk7HUlbhZva
	 e43RGZpcH3cSHlQPYNJyF24pw5Y38SgPhsOyiJYAzOzWkTjzRuVUN70rdLhU9zxlHk
	 sfOGrdLA8ii6jlNcxuodnQbDuxty653WGIYVTGbU4nNbcBvCllHqberOWv/ejV7SfN
	 lodFJ9jeT9bkOfefvzHOziT/ez863XRAqk6Z7bZkeuWmPSNfX7J9y09XeGyfiKzZIL
	 xj6EZAbI6PwXA==
From: SeongJae Park <sj@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] init: do_mounts: use kmalloc() for allocations of temporary buffers
Date: Wed, 20 May 2026 17:49:21 -0700
Message-ID: <20260521004921.84647-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520-init-v1-1-aaf2ebac5ad9@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 946D1160009
X-Stat-Signature: htb9oqmyyimfjzh5u6g64ysd9spwstht
X-Rspamd-Server: rspam06
X-HE-Tag: 1779324566-977002
X-HE-Meta: U2FsdGVkX1/Y/mr29hsXroPGTxFuzG3gEdFy3guvFQnlo3ypc0aCCOLmoMKaZwZ6AMNvnDa84rNtj49U71qRXdi4JnWkiOEUM3FybciOlTtaWoPyRAmNgH/sCF/MOUQJl1RRQnqIwl/epFDxikDhtpc5Lm21kCmArOzZkGjV9eWkd2yjvVC8qPm0FwtvdIkgjaBfCMFqT7yYVLFnzye0sPcUDDQOF8xjq9DcWriHfkSFfUMJwBhS4YGT41upi2ezoaZE2EE2eZVl1aQEMbjFRO6GMpIW5mfpzOS7TP3vGqHSHDRZGAA+Yms3DtvE4rXDSMtxcXqRfCoMt1PbWK3WTFIxkuETyGWS0e/udW6pjy1NpOwZh3rhBtbTXQcQSK7fB21E5ZZ1k9SvwlO4eCe3Bwdxx9BiT4128cb6EkMskdatUZuVlucDXp5LTIOsyhLzlXzEewwkKehriivRYw1354uI3IbbRDYXJtN4AQb91LoRNm52n+MVtcWYYoZtsFLMqob7xqqekehOw3M2Hfgmt+spnAmPEHbQ8bJiWQZwAj/H7Ole68cDm+uo+2PaMHlTLLVkjC/AUFQkVTJ03aL4KHSGpcLeTBcv/JR0Kmm4BVnrHZeOkFa5+eb/Z2zAOt9GV4TuBYDm+HiKFOGimj0+Qk7Eb9xvovmPKXXKOBIKNNASQcRZ5OxomyoyftHYqHKrEPLGYpzjnctCaL53/2KsXnr/OD3v0bj2FpZHvW8JckfF+LOzLGvPXX1oHPoOtyfZ5Q99mbHZqFywyxsDSQZq5b3gExsIDGVkbq/NsNwgoM03KUlt2oFFN8xt1xagDZxnTChM9ErdgPF3aHh+oObGRrZN7o1XMkpTBtYjvAon1PRgCzUu9YA3EP8a2tbLgAYnnBLpFku5biI+0gYT8ZUyAZQ2pv7mYYQEMNZDyL6SPcsb4rR3aq8EUKbnhq6SsMy/0r5adh//XszCEA3jtJV
 qAEIU3Bs
 uwARDOh30n3qT1JsvKbES+SILFYpTQm4tVgQ6ehqiyVdLIafJrh3wj5YvLdcO+sSTN/1aLSMtkbUZO3v4JCzFUwpz/GNxy4JBNMiMUkmM5zKvsxJH+9OuG+ooXAQvvGstWKNcTI2KlPHDAct0YPMuqKbHE7DLC3ml3kDchg+6MAOx7k515NxSCqvcxns0eKjD1XWrJFbTrfGJlS/EAaZR1vrjQJHdV7GKjVqQnzitntAxTTabet6TexSl75zxb8+j0yUQhTACcyOC0W9PI5f/WAaP6Cy1fDxipjFiyybmO2eVISA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 11:16:51 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> Several places in init/do_mounts.c allocate temporary buffers for
> filesystem names or options using __get_free_page() or alloc_page().
> 
> Usage of alloc_page() APIs is not required there and only creates
> unnecessary noise with castings or conversion from struct page to void *.
> 
> kmalloc() is a better API for these uses and it also provides better
> scalability and more debugging possibilities.
> 
> Replace use of __get_free_page() and alloc_page() with kmalloc().

Makes sense.  I once wondered if kmalloc_objs() fits here, but kmalloc() also
looks good to me.

> 
> While on it, add a check for -ENOMEM condition in mount_root_generic().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

