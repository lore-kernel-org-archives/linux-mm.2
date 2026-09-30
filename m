Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D678CA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 15:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8356B0088; Wed, 30 Sep 2026 11:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232196B008A; Wed, 30 Sep 2026 11:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120BC6B0092; Wed, 30 Sep 2026 11:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1FF56B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:43:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6EC9E12011F
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:43:21 +0000 (UTC)
X-FDA: 85270847802.29.B499641
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CDA774000B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:43:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HynggV0O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790782999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsK5FODFHiWcJT9sigPvRg3BRnqFfkTLRzG7haLebAk=;
	b=KM6ql5caVU3+tu1oUNIxu45gG3OVfXPq9z2AyaIybY5HW8ucuPJNhiDkB60j1J+QG/DfHX
	cthlUdu8lyyrkz70TTPI33mAyujM8tvY9ywC6zrAma9c6sdBNn2JYi+0FyZvqLPczHRJto
	Zg2y4vpF0phHx5lYsMrxdJlVId5L36Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HynggV0O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790782999;
	b=Y1I47lhVv0JZFpI06ycpMHGQzjG7VbeE6ToSs0o/d+b0KAeCPLXKlKchNmOJVysXgIGNVY
	tOni9qsv5hNs2oX1oJOstuNdjGhHU4RDSFzJBouCeHDBmgMPDYNiwvwnArJ4Oh27aWpC2U
	nrD6pZDGx4kOz2WtB9q32VtGssdGoX8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26BEC601DE;
	Wed, 30 Sep 2026 15:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785D71F000FF;
	Wed, 30 Sep 2026 15:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790782998;
	bh=SsK5FODFHiWcJT9sigPvRg3BRnqFfkTLRzG7haLebAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HynggV0OlK5OMJTerhRL2PbQvJ7glPgIzXslMxgR+4LGyqLHaaq+azuzN08qqg8Jt
	 iwv8XlNRyutecVHp6xk5uXnEie/c/8qjtfELhhIBgE14G27hxuhRVvBPTM9Es39JMH
	 WXtleGTz3qGOHHv/TRvJb4HH4fO5BcyekTzxyeUojLZ6GwsGf4S7diN8IfkXR2jy3Z
	 HHjEFL923B9+ZZ63VPrkPELm/fGD5jUEQDrvYIjw5/xRyQFvJnKnwEMZR3t1mYAORn
	 DKJGXUAzjdUkLrukd5WDdWn9RB8awVqYzkYPnYTFrtpWAWg8IWLGo6O4pDixonHrqF
	 Cqc29YIaR1KSg==
Date: Wed, 30 Sep 2026 16:43:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: =?utf-8?B?5aSp54u8?= <rockeet@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file
 mappings
Message-ID: <ar0r3QnZWzHdJt6Q@gremlin>
References: <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org>
 <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org>
 <art8EKRKMdwSDCkr@gremlin>
 <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
 <arz0auULA33fqoWu@gremlin>
 <arz8Plu6J4YOTi0a@gremlin>
 <CAAE3jtcanTUrV3xfofwrvYGCFe5o=Vn7gS66bDzuxzeGg6c5=Q@mail.gmail.com>
 <CAAE3jtdHi7aSsJ62TpEjkxvwA-3TBLvr5i1ohCNg2aupND+_XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAE3jtdHi7aSsJ62TpEjkxvwA-3TBLvr5i1ohCNg2aupND+_XQ@mail.gmail.com>
X-Rspamd-Queue-Id: CDA774000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: kny47a9bdx1hm6mthiuwqcje7td41cdk
X-HE-Tag: 1790782999-149639
X-HE-Meta: U2FsdGVkX1+JI5CxNMHsTsW6GrEy0ve2DVV7xPb6wnLkcUO5Oa7A5kx9Vx1TwXQHKhz0o9MCcH0TpSjDdbeJkUNC8Czq183HpqkCR0ta+kf38zxlzc6SlZ9yqY6AAjsTxJkQwhpC46T7vXxdWp1dwYa2guRnQ57R7Obc7O9glS2l9ALioZceFErbvYqzv2qFwJ54JkTTTvDXjpkQR+K8qglnNwtt2gtO/306FqdwU1JDHejTM8gDK1YFdusvCUKVfqSldBL7Jy4dQ4iLgsZP7/A0qu0QkXdNa98N4eoJvl6DniY4W9ku90zVUrHkZtfnIjUwLK8hQhqP3wWYjVymvUzxc8C9dH+281c76S41f0+HwFaNQuC8B2044UsEj5rIcxiU4hHSAk1/CmgLwU7vqVENB6ZQZ72lVtPBHQ1NqhM20IodfKwaQtkoJpGEDGEYJZHa7S8nl/1ole76HieD6AqvUyrvuvo/EWgTJ4OcQsIhoYhjssitBEsZn4a3rAeEpzGuKA7uf7aHLhspIZQ/oEAIgRklF0kgqw5qivftKBN0qFGLmBwQWY79D1HTPMaPMqWPphBiKRwp1rsf56WCjReo4wy7n6tV/zOnznaMaPfXedWy1Xct7+64BU0T1V2qL4DhQxbKyl/sxI4lMtj0RzkmF6JLjCb/5yWDSDLgouOsSnAuq0u99ZhiW5BY1J9wvkzNUYJ43XNOXgzNrC9q+3kzhvR0BDoZzfhpgfrnzlGeaFwSLZvoFIoPqV2NS5X13//g7pxVhAjyAQ+Sog/DHpYxWbh9WfLIGzdUICdSZXGzNrmw0nx1qOH7PVPemgE+6ZwWnsv+IrrLw5xax/9JRhuMbjDHrU3JwCJaH0lTx28Z9fhoX5NXaKIkpCFtWG/rVQiVwOnEyYWpEtneBXVb1f0Kb0XyLz9MoywIvz+M1z2UPnKiECqShVdEwkDw2v3xAHRuNbXFkhFis5YHczS
 ofDavh6a
 mLNeQ/GPFdS1EgtJAvTEv9QkMbfHatmlnqECX4qHe5WLGV7GKGTN01sbs9uzS+NFsqQWMz4VKyaI4Sc0jFnWXy3a2m8Hi4iJmuCaoczn7xdZVWLWIP9YFtO51k7qA3Fd2cCFkCQTSnuVLgVwmaXkx2Ktvc534AYZHt7r9Ki+C81caqJCXhkWaIxOlKh9d8NWNCKbAGmxa5Ep7OhEIa1A1Zz1oVCd0laDm/q+xL6SBnXRVOyGh8G/r98Wx48mxvU55LMOVlt9O58Gh/91cqZPitUkIx9UOgQFakUuspIx1ALvYdjo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 11:29:09PM +0800, 天狼 wrote:
> Hi David, Lorenzo,
...
> Per-file deferred writeback would require minimal kernel changes and pose
> a very low risk, while offering enormous benefits.

I'm afraid the opposite is true.

The proposed expiry hint does nothing as soon as you hit the dirty background
threshold and in any case violates kernel writeback as explained.

And nothing you've proposed here is upstreamable.

A locked down simple process handing out memfds (as explained in detail in
other mail) or a named tmpfs file survives process crash perfectly fine and is
the correct shape of the solution.

This is what you should pursue.

--
Cheers, Lorenzo

