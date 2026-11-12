Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4C7606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ig67/Q5U
Received: by kanga.kvack.org (Postfix)
	id A2D086B05BB; Thu, 12 Nov 2026 04:28:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04BB6B05BC; Thu, 12 Nov 2026 04:28:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC726B05BD; Thu, 12 Nov 2026 04:28:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB616B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:28:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57309A051F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:28:32 +0000 (UTC)
X-FDA: 85425941664.26.E99B567
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 89C2BC0002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:28:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ig67/Q5U";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794475710;
	b=oATOepP5Zxn5fZ6fLvqiM6feBikPfNfGAuXepOfR0TtZOQPRCJ/E5dCjijTkt9hQTlwZd/
	2vj1JobeYm07vIOAC7618148ECB90oP63Tx1JsgHzQuaF3REHM2kElEa87CFKo4q+9gVW6
	i1CUENNl0m7VRHodoIKmevk09j4hEhI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ig67/Q5U";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794475710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhziwyxwKo5hta1/ka+DLwPNn82EMgx5i212ZpmjGxc=;
	b=s3sLERTFDsuV1dM7lFhcth408bKGplBgKbVUPHp8SJbpp2dXEGNk/ESfrS8foynWtGVtK7
	lHET5ODsTauDMJyVZV/bzTz9jrkR+mv9ZmxPbgUhTkMkbY6hwBtZLxy6SLZycZJNvafz7c
	dtGWQLI0W3gMrobeSSWo2bxP0+P664o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EFFBC4006C;
	Thu, 12 Nov 2026 09:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3221F00A05;
	Thu, 12 Nov 2026 09:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794475708;
	bh=qhziwyxwKo5hta1/ka+DLwPNn82EMgx5i212ZpmjGxc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ig67/Q5UyR7u+l7reMcBd+/6d+1hZBrZuflvI8fVlnKGwRPGSovuLhYFlD2XwshDx
	 k4tWIwIpZxgVS+CnHDuNFmwz2y0IQR3KTMb/WgVe+IP5VJD50E8CqJuLwUg4OFGy7J
	 /TdABenpbG+NFE26X1Tm6gzyn6qutTdeFFLriGI/xhqj9QTek90gHYvZIWgj/2lFXG
	 2LildKJmwvPv8iFpkgWQS+ehmyT34Fvl+PtVOquGQFCrgIzpmgEXqq5UL/M8eqPCDe
	 GBAG5HSArBfaL5Jmk6mQ/h0lgMQxHl0tiz5Vcr7wEwYGUgZ9RYFsQdEK4W/u5oxatR
	 EKcCPEcC8JG7g==
Message-ID: <4d6a3d68-3fc7-446e-9f59-f61d7475e22e@kernel.org>
Date: Thu, 12 Nov 2026 10:28:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
To: Arnd Bergmann <arnd@arndb.de>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, "Kirill A. Shutemov"
 <kas@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Miklos Szeredi <miklos@szeredi.hu>, Amit Shah <amit@kernel.org>,
 Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Bernd Schubert <bschubert@ddn.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Malin Jonsson <malin.jonsson@est.tech>, Richard Weinberger <richard@nod.at>,
 Geert Uytterhoeven <geert+renesas@glider.be>, Nishanth Menon <nm@ti.com>,
 Frank Li <frank.li@nxp.com>
References: <20261110145241.536019-1-kas@kernel.org>
 <20261110145241.536019-2-kas@kernel.org>
 <avNuQqLf9CG9dSsE@casper.infradead.org>
 <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
 <20261111-thunfisch-wirbt-waldrand-822275b2d3b1@brauner>
 <CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com>
 <20261111-stumpf-montag-miterleben-c4e2feac8090@brauner>
 <CAHk-=wjGXBnme-N+HvbzHH40ftb7Suc=kZVT5cuintQWyMHJ7Q@mail.gmail.com>
 <e94bdf7c-eae6-4f64-bf93-0aeedca1a22e@app.fastmail.com>
 <32ad880e-5946-4703-9c6f-43ff59da39af@kernel.org>
 <3eb60948-8fc9-4682-87c2-c113e54e7d4e@app.fastmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3eb60948-8fc9-4682-87c2-c113e54e7d4e@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: eu8bhpmrfmshbah7b6bu7kpujuasweu3
X-Rspamd-Queue-Id: 89C2BC0002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794475710-570903
X-HE-Meta: U2FsdGVkX1/F6UmwVg/mpPA631OnIjH0AreXDd1FHSrvoJ9RCvnasxLRrDitSikxdfQAL2UZ2LC+HZ3ZiUceLZboR07m46pJtnsS8dAYL1fpwruuQX6AK4NxRk1eLENu1OOC/e7Gy/wi6hA0nDYDbdOFY6iWYGU2hLmmf5anRvmYrrZw5EvgM5BEDjaqdMf7adQ2UXhsLrgQvVu+W4zhAmxy8KA3y7UfFodp7mDeKtZTekZkSYtLLu1qVhmrunQFAMgbExOojHHp2SxfzIv06R3Ure6SlVdud3dzJHqytwKXxNB0Kw+VowMs6uR4taK96lkBzy0XUnjPor46FnJmu1cUFwZNZ6VGME88d/1HbpiWKt5wbpvSbx1dOclnpDmFkrCQnwMiy3cUpNoE4F8Ya6Jhs3wE5ujCcE0dwN4V0wbyc0bdGvbtKRk8Yeu0A0MO1QyJ5lt7cXL6WEGERoPBdee2irWPz+liiCVVekbjAWcrI78dR73gqi7GQRDUg3dDq9nS1jAjnR6zaf3MeoBf9NzmZJtmu7xMq1A6BrjewSay/9G5oATd9XUiYjrmuWr79A95+LPn2B6N0v7uzn5fTjBezdZRsIhXMrxzfyu5mY2XuTUEVlL4tH5Kb8v2Gmqlb7BdKo+1CUqjMgNhXR/vlb11xa2pbwWpgVuaIV6Plej47YKIWxQDapvkChO+/uy1+j4my+i7ghs9zBMEfuUDG07HNp+cdHPP+hjGoBg7wG5mHH6QB7EshUBHSXhYAm/mNdZIAMWnJjMsAQqIHlX6ZzP8wYrZtL2kE2WHUAT4rh7ojuggnDHcXylN12ZBEcSlNHNCBKpTUsaJilHV0WC52VwWq0h/0z8qd11yr9QNQicdaRhKVLqxDgMq5YTHSov2Agq/xcKpiJkoOMcYAyyuKNI6lM9nOZqCrYvyPDPIVKMWgOyzrU84A26RcLWUamyjah5ZnxxvXkchqgBadLu
 WUTQ0Tbq
 GwSl2HJHJYjOdVhyf84y8qz747R+DRi0kPo6V7fr42r1TiUJ5scp+xIMG/D0Rja6ST5xNeAKhEbl0n79Ze1XyzlV61h5yIBb78sr4PXciH6D4jORN0MJAxJMr3dLZqpEFPMK9D/dQMVM+lqZN790upieAudHWHmZwz93QD7zoiTen+67oh+4qRnrm5NQi7vYvL9NkBLaeE8g9ZQPZCqhp6j1lWXIYeN9I5IIJ5WQKim2sGGBiZ0fLlOu5Aeg52MTaN7WXhDLw7FRBJkNSPTO4G9Vwqn1okBobU4rfjJbDK7G2yqDrmRcyzcS1zilaM+U0x6PimKcKqTgCyDcnpupt/LeIc3wQqA8N5kxVY4btb54r54DNsq5WHXlaO74PbiXqklyNR+mMJd4UBhh3MK7ZJNeUrIYfgsQIoYrk8jTzpdfgNIv+vjoDqaOet0jwI8U7fCT+a7cQZOBzD3H4HhpR7ACREb0yDp0timVUU5XUkrnsn/1Xf1atpPqrZ+zHYCBYjHUp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 10:25, Arnd Bergmann wrote:
> On Thu, Nov 12, 2026, at 10:09, David Hildenbrand (Arm) wrote:
>> On 11/12/26 09:55, Arnd Bergmann wrote:
>>>
>>> I tried to push for what I thought was an aggressive timeline
>>> last year, but that would still keep the Arm bits for a couple more
>>> LTS releases and only gradually reduce the scope of highmem in the
>>> meantime, removing support from architectures, file systems, and
>>> drivers where possible. See https://lwn.net/Articles/1051010/
>>> for a summary of my talk in Tokyo, including the slides and
>>> a link to the video for anyone wanting more details.
>>>
>>> I also prepared a number of patches towards this, but have so
>>> far not been great at following up to get them merged, sorry
>>> about that.
>>
>> I think we can already start at removing CONFIG_HIGHPTE now, right?
> 
> Yes, I think my patch from two years ago still applies, see
> 
> https://lore.kernel.org/all/20241210160556.2341497-4-arnd@kernel.org/
> https://lore.kernel.org/all/20241210160556.2341497-5-arnd@kernel.org/
> 
> If not, I can send you an updated version.

yes, please, that also brings it up to reviewer's attention :)

-- 
Cheers,

David

