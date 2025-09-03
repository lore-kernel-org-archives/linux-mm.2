Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90343CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 20:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03028E0008; Wed,  3 Sep 2025 16:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBAC28E0001; Wed,  3 Sep 2025 16:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC95C8E0008; Wed,  3 Sep 2025 16:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A6EE18E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:02:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4EDDD1A0873
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:02:13 +0000 (UTC)
X-FDA: 83849010546.09.DA9426E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DC0DA180015
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:02:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hlmrm62D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756929731; a=rsa-sha256;
	cv=none;
	b=0gySeeflAxg+uSZg0+tPWL8KOXXaHz6BlZ9xz5xtu6XML6KTHTvvh5moGtceMmi0hFi00p
	70MrLZEryuyTt7TPrHG8PQ8NkA9Ux6Eaei6SBqtqLeuAtfT/ZUG0tUhfjp5orcqiF+1+Fj
	mvPSfBrBGHKcgLo7MBBWsKbBpAC2y4s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hlmrm62D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756929731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzmBV4yzCOsz4Dzv0UkbC45GrPiDQWSxooxBBUDK99Y=;
	b=IBOycx2EFTloXvXBoag4Qa+7Ntqgjk7K4iSEfbmNh/Un24J/yjjZefYxnvOdKCVkN1sL0l
	TGkJgP0P2udjVFOUqM7rZCL3wvaXIN2rXG1+nzaRXODxpmQIGHe0/IFlPROO3M0WnQXD2h
	MsbUotNmFbNmwZdJ7dQeTDyYjlzA5ZE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43309601BA;
	Wed,  3 Sep 2025 20:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C02C4CEE7;
	Wed,  3 Sep 2025 20:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756929731;
	bh=vxIovzy/iAeQqbzPhYJg0AFSyB2BO7DsqIFM+fM972g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hlmrm62Dm7Kb10KfPCz2NQ3cJGKSLS6Uw2ZLxVRDQVXNI7T6s1VuqmrHMgDMZDp1C
	 ReSntuXtFj8H5TXg2208lA6XNAVjer5xvJtTVDS8Xae2EaR98CKufAJVPa/2hUOHmX
	 1pZYnEFsaR+skYOLDghdMCZOggwOnK2VERCuduhLXvn6N6UCx7Ln46H36H8eXO+Vqg
	 k+vHn0YUSyQzyVU/9cnxqx+uHhTIySua5sMcOJLShXabwOEYG99fjun47GaQW+KhqE
	 qy4+DFgvtZDQ4G/4QjaIfWSbEqXQp6jSKdzYqm0ecUVPiIc8mp5UHUItsDRX4wILR9
	 bR4OVqUgVkclQ==
Date: Wed, 3 Sep 2025 13:02:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
	brauner@kernel.org, willy@infradead.org, jack@suse.cz,
	hch@infradead.org, jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 01/12] mm: pass number of pages to
 __folio_start_writeback()
Message-ID: <20250903200210.GJ1587915@frogsfrogsfrogs>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-2-joannelkoong@gmail.com>
 <e130c95a-103c-40ba-95d9-2da4303ed2fd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e130c95a-103c-40ba-95d9-2da4303ed2fd@redhat.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DC0DA180015
X-Stat-Signature: q6kxj7kijurxak4csnfo1qny3rme946o
X-HE-Tag: 1756929731-697587
X-HE-Meta: U2FsdGVkX18mp3RcNAAGTU893MfYeh3xgzo0cOnN0QVSNChWwa/D876V23QEuzLHfkxeU+ioStQO8EYDX84HSqrcofea15V1CFGJLNU3MqMrv/P3KTVdci2EHEk1xBQVHO0ce/ozIZfoVDZGl6Ddb+SJ+y1dueKlkW3ypxyE6O/UKrkD1bJLXRQctciKQDjDOjD5kZODYKwIyxU4gd7r35dZibRSWbONe2UXyMYb69b/UkrFCYifH7lZThYw8ctjhnUKl+aJ0CI/HEegUlAIC/oB/06YfPAkQTtmh0ToKJNhwyevVHe/7Ydj8LGR6AKt5Tk5BoBAnXTxsqZO813GZ8vnrODEw3FEqPowlavaTaKcwqEqbO0Y/fvmA2AGxkHLjbUtZHMvW9NJQcE2+MHH//mamzk4xRSh4NuMfhCGNqFv7yKfNSQoSELHpU/x5B7C170x5lQ178YE4U5s4baemLGxbm6K7C4YZEC+7z1ExLaw2a8lqalBDG4WhWbbw4Jtdzr4IS7t6wFUB/MXgADY7y07dp1thh69CR6ybeHgZTMDFZzinErq9qcwi2SX3wezwFUdHl5SmBHGqaUz5177cfWIJ2CF0Z270uhIE6tJ1DEuhqG7mPxuSbl2uaA9V+AE0y3XfRyjLL/Xuj1vwQKMdEFqwFU5Y01cLhE4vmfwrCDCMn8ohgilYAHZcl0+Z44jcofBLXuHs3vfnili4/MdGQh/uocQyHArH7Zp6MxvGXG4l7TF7oTGZzYviFW2Yo3yThALyP02ZHKPI+N/RtHfYDrppKvK4dxZEpdAnDiVnOsNFS679WhoPloSbX4RgiubwgzCgBa+ykRbfAZHz7M53b9CIlPyt6TZrU1QyRuMoFYVDdYqn2Vv5v4auSi1oKQX2NJWBFqu2WgHI9aHpLFaUPoTPo7FStj7u1vPVMjH+DgvsGVzDiOf44jyaip6kogRdAgEOl+r7KWWaSMpF56
 SvB3uGwm
 JpdF2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 01:48:41PM +0200, David Hildenbrand wrote:
> On 30.08.25 01:39, Joanne Koong wrote:
> > Add an additional arg to __folio_start_writeback() that takes in the
> > number of pages to write back.
> 
> Usually we pass something like page+nr_pages so we know the actual range. I
> assume here this is not required, because we only care about using the
> #pages for accounting purposes, right?

I think all the "nr_pages" here are actually the number of dirty pages
in the folio, right?  Or so I gather since later patches have iomap
walking bitmaps to find all the set/clear bits.  Perhaps that parameter
ought to be called nr_dirty(_pages)?

--D

> -- 
> Cheers
> 
> David / dhildenb
> 
> 

