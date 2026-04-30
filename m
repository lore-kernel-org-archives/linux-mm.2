Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32963CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274856B0092; Thu, 30 Apr 2026 12:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2252D6B0093; Thu, 30 Apr 2026 12:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BD66B0095; Thu, 30 Apr 2026 12:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 043BA6B0092
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:07:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 444E11C2573
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:55:24 +0000 (UTC)
X-FDA: 84715520568.12.DAAC734
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 68C9F1C000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:55:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IaNPcTuZ;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777560922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8wT6YvDj2Ot8imuqP6JcQPDwIUMpuBl9r3FSSQNh+Y=;
	b=tOSqbNYjCZRR4wk7YaDBS0K0NqmJc9LQE+u++7noRes8jxKSi1mIuGFMxTk/OYUX7Lu9Oe
	1No5x3Ht9nBx049Urdrp9dPa7EhLGyWnyUuBGQ9slbM5h/lz8P0IA4YWddg+ZG+j1IHli5
	kAmSRhWGerIaB539xr7sEsYKCgzGUfQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IaNPcTuZ;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777560922; a=rsa-sha256;
	cv=none;
	b=5sm0L/R3ior+SD0zBAAgRNdFPlqGgSInoWuKae0XBmgy6vKUYh4sOqIrrTsRwjT+KedaGm
	oUQxbStla6gFU86sEwvTmGpMJIGD3/3ZDKN2RZZ28pD6fs7D7PD3wrlO+Kbukc/gmGZk3Z
	eTRwF7tLPfMf5Syxw3Xn6BtAoxL0sus=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B3E040693;
	Thu, 30 Apr 2026 14:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7973C2BCB3;
	Thu, 30 Apr 2026 14:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777560921;
	bh=LYmcweuukRQSiowb4Wlkm+2NNgyqTmW4tC+OVlEEIrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IaNPcTuZw7TviLU9kqCN04Z0RsJFwDtuEt3pWjHMe/ci53A6HJEgeqthZsBzvCBOd
	 WDHIyd3xbb/8CwxrmUxDRiOSWeBcOyD+9mO6sV6v8BVdfIET6ZP/rWwerc0LLyLM7l
	 pU8RRSDeQJvoGM5ZpZ20fxZxCRk4PoStUDVEGEGWu5MacJGwk862NOHr7kEGwupd6b
	 W7MUMm8hVfY1I4c9KNzpy4DqExjWrqND91EsmSzgeTR7+k/jCScHo13bK+Pc1uCpJX
	 wLMS7kh/wpyYYcoC4XS/NB+kAyQi+DfbZ1Y7D3PfTO8mtlPXzqS9du1ADeB1FMog9u
	 5RWDOv0pDnKNg==
Date: Thu, 30 Apr 2026 16:55:10 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] userfaultfd: merge fs/userfaultfd.c into
 mm/userfaultfd.c
Message-ID: <afNtTgHny2HC1kLP@kernel.org>
References: <20260430113512.115938-1-rppt@kernel.org>
 <d5f17a01-4504-4a7b-b58d-c183cedc37f1@kernel.org>
 <b31e1b5e-511b-4213-a8f8-d9721959d709@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b31e1b5e-511b-4213-a8f8-d9721959d709@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 68C9F1C000A
X-Stat-Signature: rehq9akzohok19idau11ccd9fh3931c3
X-HE-Tag: 1777560922-329467
X-HE-Meta: U2FsdGVkX1+LF2M1PWho1x7mTIo8jtxSSBOYkYo+eUMg3MkZEEF8gpUCTqVrj3HuIZ8e0bI/Mco+ynOaN7HADOCVTYEljk5kKHEJZYhlUjQYzi2gEV6LdPXP5bVHuVBwk5d1AS1SByYj0LHRwvcxFKmJGM6XCxd3Y9FmODocZhlUzsQlUBnI0xrlDAIYg1FNGmx3lmm7uniigFMXMJaMgl+N+OpozR03UfFIOtUp0jWkCGMh4dqZWxDo8WB/HIj3LUiOI6rpUkilYDbk3OUrwl8zQbqQqLG25yJ/I0inWlGWaneRf7DsfKaLpm+turBvA+F8wbRYpbQiOLAQh7qhkJDKyYk/LoY37Te53NPArfgumj4b/7/HPfi9LjAEj6q9HHIIo156sIGWEPZ4kGRcAXB+ARfFUmtUgIC1f3jmC5/jDAUfdBahQFEq8LGuGTfEEuXLC0h8MTDnG25MahGREXZnKvNelvsHIKvCKKDrieTxISswzkguLO6cwvKQI64DDlp4OhF+AqyqlRJTkNbIMzMyWUeNyMOOHlnnSd08Okd3v7qjK2zsAN69JGQOocyr0tb2HrLMDcujWXL4Cn3Sr0M388ri8clj4FGIFZ+cMw0T3LKUB30CbiGSEs6Zyis7G1qbSaroWCvgzwDpAlkEXjc+CQ0rHKvWy5o+cJ0OS7n0cP70mtILGkfcunI6HbNASJ5IEk7A3+vsvX1yTy/1KQ4V9OEBxcY2yxDY1dGjd4wWfRZ3YVmKzsOcsbafdzAz2ttjiGcqnq7ewQo5qVScV66rdGV6TKsY3/6+U8sFT1EV7+XhlYP5B4UUw5hCWER4IyEdSJx704XsX3UeIADYJeuxeSUxsNDeAHytOElqytjc/GEyRfx07Q2ZNOtv2NJXUR3pFL9F8nS/XzeJoM3+GqPzzKWbse+wOKxxfNgmlNUWfJE6MDNwi976kritARD9JI65mI6lGOXns9ijlyz
 hSOT02gw
 RQgsdtpZgsXJKodJMiFEjNtHCc91sVVKiz0Hm2BL1ENs5EG2UzyuKbGF9G+FVJ8osl3vecvCUNV+/QAkB5e7xIpyEFt5a7wOR9+TKXa7fJ9zRUgxer+LKfiWi0kiBUQoaM4MXaAvbhsgJ1K9ukdrKppGGZwKYvP/yOHoeUazGB0SZRn5+LfF25QymYkcEB5Humh7CnVsh6f9E8pdRS6ZKSLqFVCOXIYmTf20MsKAadhkyC9LymKsw7uPu6POziVNyF0VvdmGGcGv1rZtCHzYgspmEsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 04:23:08PM +0200, David Hildenbrand (Arm) wrote:
> On 4/30/26 13:38, David Hildenbrand (Arm) wrote:
> > On 4/30/26 13:35, Mike Rapoport wrote:
> >> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >>
> >> Hi,
> >>
> >> These patches merge fs/userfaultfd.c into mm/userfaultfd.c and make
> >> functions used only inside mm/userfaultfd.c static.
> > 
> > Yeah, makes sense to me!
> > 
> 
> Thinking about this, is it reasonable that the kconfig stuff stays in fs/ ?

Nope, missed that.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

