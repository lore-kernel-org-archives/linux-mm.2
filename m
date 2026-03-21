Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0CB5109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38FF96B00A1; Sat, 21 Mar 2026 14:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340B86B00AA; Sat, 21 Mar 2026 14:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256AB6B00DC; Sat, 21 Mar 2026 14:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 142B56B00A1
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:22:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6959160583
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:22:32 +0000 (UTC)
X-FDA: 84570890544.09.E3CE25A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 128B4120004
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:22:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZHnQ6lEE;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774117351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23OhZHGj6Deu2MGI1EFNHumx0nfYyAwlH/b8AJbbPp0=;
	b=3FCbbvcAlGePL+CVDK5sE5AXrbuhkNq+KMBIpX/LIWb31QIhdK2ex6a9iKtuVGnIwWJGDD
	hwoGZgh/zQ/1x69D5B30Wsx511I0r4GXAEjglwtnYkVDMvRXd1KVvZOUDgQeCZE+X7Y/Eb
	tCRC4Rm1moM9Y4lD3GJzbEfsrIVu33Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774117351; a=rsa-sha256;
	cv=none;
	b=8CrBcAsbeHyiF4EhNblKpohSrZezNWR5i2O50kSBjjOXmxjWAAjFcqEKed+qM+7TSJ+jj5
	FQDdXV/ZMj1aQpK+HIth2tIe9GB8NPD3Y5owRkgtNxOIlTUXv6XaYbpWbdLK7+ns6iyv4g
	3JtB/UkC0ftKMWnV4jvaOZFBuHxvgPY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZHnQ6lEE;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C002342A4B;
	Sat, 21 Mar 2026 18:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F66DC19421;
	Sat, 21 Mar 2026 18:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774117349;
	bh=Z5ShjZezr9g7HSBWIB7EdDeQzkiOkItYLDWdO/0hqwg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZHnQ6lEE88xOYc1iWlfVdzE5iZN8nimxIF52Ss4eTF1z+Nyp+L28Ma1fB9cqmr3uJ
	 yzQG5uqOcJBToMwnI6OwsOuyqtwCjFvOO0UEqyuFC7carzJi376cVWa4tdboRarVLo
	 ITCBnvYm+w+9Qx3q3fVDKpfDkqYqP/1uCASrkDmY=
Date: Sat, 21 Mar 2026 11:22:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, apopple@nvidia.com,
 axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org,
 chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net,
 david@kernel.org, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
 hughd@google.com, jannh@google.com, joshua.hahnjy@gmail.com,
 lance.yang@linux.dev, lenb@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mhocko@suse.com,
 muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org,
 peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de,
 rafael@kernel.org, rakie.kim@sk.com, roman.gushchin@linux.dev,
 rppt@kernel.org, ryan.roberts@arm.com, shakeel.butt@linux.dev,
 shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org,
 vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com,
 yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com,
 ziy@nvidia.com, kernel-team@meta.com, riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Message-Id: <20260321112227.bbcf113a6eae634d12695fd9@linux-foundation.org>
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 128B4120004
X-Stat-Signature: 3twit6qcxf68xxkgjmsopju6die7w6yk
X-Rspam-User: 
X-HE-Tag: 1774117350-293577
X-HE-Meta: U2FsdGVkX19LTpVD5zkO/5E7lvwAKUaVFk9IbuIpnKBj3zhg+dKDXNygs7Dm9slV2DfKUdvhzJDNP06bMG2inmPThWyWkRn4WD1jAt+w9O09CBAo+ATfKooDUXDo4IjBPNNZpOYESR7hT0ALoaIbpZvpBR4r4iyyRdGP8FknZYUv0UE7/be0mSO40dVLwlKIGhbcPzhaoIl9V1pSUq8n1inbwEocv3N1t1ZqpnLByBg90nLHPyJT0LWGwf8mV905FYEInTJTtJUs2IBXuCaLvjOE1YrMgjL+lPfjg1ij8uQ6qlMXTtXMblRQI6WvEy+LovV31Xq4XAwadzzWjMLm1mEmtTlQmbBwLEsFVpfp6jzFoptPbhRghoqpC8cTDmT3feVfs7QmRFthuhK591Tvmw/Y+D6CvsN+TpqcdpJlazVH4t61sJI7Txk4mUu+r9kl4SXEeeeeBPWRZl5yCZ8wi7zvaByWCc1XYILdefcdkE1Yein8mcryXXgtwPPK5nm+TVc+Z+NUHvdGDpy9hoZiku6/zE1OnFJgEz1HrOFO6KOBV69uMdVPCfz0KDg3btDziHuUJYwgxThX7rlp7IVSYBF0P5XHTKpg9asGyT4ZI+PjUrpqqRJgsTLIurZSSTP+BW+35UqlY0yvOHMz6ldkMuvSh6jT3w8TYtwlQ30sNIDrGmg1sYRPPBhCPUQWwhxW7lbwetQ9uKEhwD+owH0z1tEm2DXAw5mDcQIhNv5CYOUPGdYYaLD6s1hHobahKyJNN7hkSnvOikkhaD7Dz+sW9E5Xxb0SKuKd/piJCUPVgTHeVCPa/sER9lmtKHiPyHUcsYcbK6L4Z+JJbjLDcZnC6l5jacMXcJp+xx0PrJQddXlvG7xbBoOuOtGGQx+HWc0z6XLmZYf3TfUxfzlOXEsdw6yansu6TyAZ6npOL6uN+vkYK1JTp0yhzD5RAFOsL51/4fDcYyZ59NyPAMp6WvD
 sNk3Q9mY
 kllZ9boo71ZV3S/oxfKmAkR4qE4GBbq1hzoKmh/B1xEQ0MCxKg0i+3u1QWjn6IND54ovV1n5M/ysX+4Uf+3/0eAF/BKUgzbRsMedwMz1ML6n40N5D9NXi43JUcdDLNBOl1QK1aLsbQczzbEwrdgfKfvyHl4MY368fjkJcycZ4AlzGX6xPPmtMChvpcxO6sm7Sw+H+X7iJherjobXTk1W+tqkCeZB0s2ZHrmSsqxrY6KfrUzJzJ8dSMk9u23b9abOdxEgEhM/aAMF4UrXNTnxfTpoAcyRft1aXqjDFeSybEcT/43pzJ0j0atrPk9etnBh/ffmoeJ7hB5EzfBko9/dkAQUEe7A07+DCdXdt+TeEYh3MBMfFsgP24Gluzx2ozMV+N4JtxQ96hzZJ2Us53LqMgFxg+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 12:27:14 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> This patch series implements the virtual swap space idea, based on Yosry's
> proposals at LSFMMBPF 2023 (see [1], [2], [3]), as well as valuable
> inputs from Johannes Weiner. The same idea (with different
> implementation details) has been floated by Rik van Riel since at least
> 2011 (see [8]).

AI review got partway through then decided it couldn't apply patches.  So
a partial result: https://sashiko.dev/#/patchset/20260320192735.748051-1-nphamcs@gmail.com

