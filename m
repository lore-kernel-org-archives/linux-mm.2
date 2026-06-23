Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65AABCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2190D6B008C; Tue, 23 Jun 2026 06:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0476B0092; Tue, 23 Jun 2026 06:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E14F6B0093; Tue, 23 Jun 2026 06:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D113D6B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:08:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 287A540461
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:08:40 +0000 (UTC)
X-FDA: 84910753200.10.96B938A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D31F14000C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:08:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hL8dPLl2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782209318;
	b=Loic4MWsPBGqaYwoFffjKLKG26hSre43848nv2Av5W8NZbU3a1mUhqp2IjvDtkXgZmcDel
	br5EDnbQNxVxnsiziqZLZRU19JbairZClNDxjC/ReIBLz2MC56u8yVVbUg3wcrsbJr2a4k
	X0ij/xDiW93OQSsW5cdpIZNWA8u7LMo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782209318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EarkyJBnDqnFqSO5fYETAhufrAjwPx1wYCTrBDOh/fE=;
	b=qVlNhg6tW69AbYhSmQ5XbXCuJYM1aQ3iWPTQTXLWgmWvgbQWseloPmhm+o4637Atjbew0y
	l2Hf3JHPdBCFRGljE974iLv34zAxGFzTtdONGkxxzV4vkduGnAj/v4rC25mBdKnVSpvaPF
	zXqTkARHZRNfzgVy1991Pjl/SlkQOkE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hL8dPLl2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2117D601F5;
	Tue, 23 Jun 2026 10:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600C91F000E9;
	Tue, 23 Jun 2026 10:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782209317;
	bh=EarkyJBnDqnFqSO5fYETAhufrAjwPx1wYCTrBDOh/fE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hL8dPLl2eSFhMWTGjZ58D9t0L2fZD36v4cEpXmeX2vod1MEQmC7X8hrlRv0Smn/Oh
	 YJ7IK/mRmly7OCs+bJIQSS1HPFID+F5LJKbQ57m5dt9ZW/5NpNSQ4l5Szb1LSn6qw5
	 YJ52BgdHnrD+fKe5ZH37Gme6yEIj9PavF2ydwXFd0OFfGu2ButLzrPmFj4HvfJwAGc
	 +uIn++yZEfbNM7UC6FYTz0/U+AppBVDLh1hVwEbomtV/AcBx5HQv5xbOo5VmijMA/w
	 esMRBseeCQGVHTI+etOiDQSP2BFqrZQvKu5yfamQovWe5a3Fv8l+ocBeSVVf7lzxuf
	 AJj63/YCOy+ow==
Date: Tue, 23 Jun 2026 13:08:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: tarunsahu@google.com
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>, Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH v4 2/2] luo: Update serialized data to use KHOSER_PTR
Message-ID: <ajpbHkuWiGQrUec8@kernel.org>
References: <20260622225736.2961438-1-tarunsahu@google.com>
 <20260622225736.2961438-3-tarunsahu@google.com>
 <178220761164.162773.6384380547612711985.b4-review@b4>
 <9huzpl1h37hj.fsf@tarunix.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9huzpl1h37hj.fsf@tarunix.c.googlers.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8D31F14000C
X-Rspam-User: 
X-Stat-Signature: burgph1wc4c7wx1i4k1436qosf1zzc71
X-HE-Tag: 1782209318-54349
X-HE-Meta: U2FsdGVkX19m1HATnZtaJEP04rXqiqYp1NEc/MqPwCwIw0A017VerBEtsfoPHLBciErUaGZBT2FAmbm2Pwr3TqveOBz+dE0X9KALsql+3LdNDRrYZTUCAyL5AE7tsJZBYmvIGQ+lANd4i/V2Y2PQ1hwnAmcJvZnzt8VqViR+08DxZUAPtL9MHVUJD8jNI7rA9g5H0TaIi2CZ3iqiAQMgRu17DUYloWmkGuxVPRNGWZy9o6QcVSJpD5hk6AUmyIgq3bQZcqxamkZXh4wUdtA6ACnCRwb+iyCPI3Sra8iQOXLrSENqX/ptmaEAW6ii6WHSD3nFb2V/toEsZGtEK/roDepVwCXJaCSJRS4ud9paA0/szOBqZvjGte9BQBgdQOk98rIZJj1oGZ/CPaGl3iiqDwcGHuNX4sxIFwQdHTNdwLa80BITWsw9Tk9GqHmYKrPKQYOqL30EGcNcfgVgbIkTY8LmuzaRZQk1sXKU8gFQnClxuEF57VzpZ0rZDAmpooy4rp5vYefFw3YEvlbBQ7YDb8aq1NBskahrFE/ZqUs5XL7dHt6j6qiUkaektcZMl8099SNiEdAK9lKiz7NZV3NQXDPhzlmo7tmw+x6RXOkOCdheC8gKRyEpIabVRvIUWlNi3IMGLAUmvsrKlu5XkHy/20zz0qQU7waxwP+p8CiHf+95yFGfenGm9mFKH5oM0wROo6qZy+i1NblueE80Pcw76uH6nmHuarzpl1vRNUIeXDKqwaeyUnBH0jYNFGFQV5jVzO1/+YAMAbXjJdbF9+KdBfKmATufQe9C98kqC2FL/TBPz8rJE8u1/hAIGl0+L1bCnOE7NXBxHgPS/JfsCdY5soB8exom1ZciEUtkBwCkffnK6jMUt3ZtuPIJpx6lsIyaWu7zJKkBHPzooZtL0HW6fXsHKeQQs+HooHa1Uk0NEAvqCJ1ocbuDw8a0IYEWHC4ehC1yqn3ORkRYoszlBBs
 7Hlfm5ML
 II005E+szoN3R3keeiBQiBp02+HxC5PDH16EeO/WOEkVxdI0NdOQuN5Zq32aEIaMFhgGRx2wb970m5Yiu1je4+fM/eW9VAXh6zmZHrSdCFnIhIzM9hxQlCQ8yOLJqCisbATHZAVOU52tm98lhsrENuKZq/JAiWf0aLhK3M4QH1cKmkzaw5VnULlJ/ZpsUIJ7cDx8cPKN5UgMVgleTn/4S5uhKYELDcntVSb5XjNDqrZSc+E+ftm8pJe44sUbiFY8RcJ+7kCveYUKbIe4y/WWXjIWNRtEvNPb97hzjKnoxjCsizx3Qob6o+MaDf5XS79Ibc3uoQJ8yho8L5WL7qi4nTtcnseuEdas0pwoF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 09:56:40AM +0000, tarunsahu@google.com wrote:
> Mike Rapoport <rppt@kernel.org> writes:
> 
> > On Mon, 22 Jun 2026 22:57:36 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
> >> Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
> >> This series also takes care of resolving the bug with memfd of using
> >> phys_to_virt before checking the args->serialized_data value.
> >
> > For easier backporting the memfd fix should be a standalone commit that
> > comes first in the series.
> >
> > Other than that
> 
> It will break compilation for individual patch. For example, memfd_luo
> changes are hard coded dependent on the args->serialized_data
> conversion to KHOSER_PTR?
> 
> Maybe I did not understand, Could you please explain what you mean?

Sorry I wasn't clear. 
If people think it's important to have the memfd_luo fix in 7.1, the fix
should be the first patch in the series and shouldn't use KHOSER pointers.
 
> >
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >
> > -- 
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.

