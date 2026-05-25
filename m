Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44DCFCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D2E6B008A; Mon, 25 May 2026 12:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A652C6B008C; Mon, 25 May 2026 12:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A2216B0093; Mon, 25 May 2026 12:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 865676B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:51:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27EFBC0594
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:51:12 +0000 (UTC)
X-FDA: 84806532384.21.B7DBF19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7D6C8100011
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:51:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QNvlsXGN;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779727870; a=rsa-sha256;
	cv=none;
	b=rDGFAhh8v/Ar7QO2DCXvU2gp6LkKab5YenqE5OGT/tWUbo/4wrUIsDbw5cjSkgJ3mZJyie
	g8rV/gXUJ+IT0MEpi5n6GFLXvv1laS3iWk91LVUQjlpUowxDmnJ+5/3gJya/9qAANzs7ef
	WgQ/4C+KKK+kogg1M9AmIdM8xixtLtA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QNvlsXGN;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779727870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGRd8m08iAzM3f86tiDF6ZjDlkBX7e5O1+6jLpCVw3s=;
	b=16gTIwk9m2KB8OoCigisr1/6zDAXutbK/BVpa0w5lyYrVVmlluSbK6qOSKHbPpXpMBWJUN
	VTyK48/TQiZzyUaZe0biDdLCUhzxKXOUUO+WzNbZMdOb9aac8mDfDB20OK1CNa8S5smJ1P
	vhGYE77HwFa9u91fCbBDbYDTRMj9a2o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B51A7400B5;
	Mon, 25 May 2026 16:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407081F000E9;
	Mon, 25 May 2026 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779727869;
	bh=RGRd8m08iAzM3f86tiDF6ZjDlkBX7e5O1+6jLpCVw3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNvlsXGNa81D0EBa1qX7xZDUp+8/Ls6apCzLG273YuQJBT9NwFVlzp44FTRpZ47IO
	 KyGf8GnSHjmxGy9u6qJFjRTbYGsCgC7vV5tdozfMWsEOqZ40mYL83QX4UgHCCtYbrd
	 0YDVRvAANttHskBTchc12Hpl5NCqv9eOy0nXqu2fP+4RkMgP2fffBXcDCfo6AJ0gpB
	 evKwHIABPPPl+k/lj6qMDI3NwkXRXxwzm3MTbCBHKXqGJp01+N9A5baqqiHSjI1DO2
	 8FfVh/gf4vettLoGTDX84TAgX4kOdLv00jVH3PUcqnTvMpd9ZXCzAi+3ETfteItaAm
	 AErM/NjqC3Unw==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Mon, 25 May 2026 09:51:00 -0700
Message-ID: <20260525165100.9016-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <fd55452e-8c4c-4983-a403-bd1ab7ac73f6@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7D6C8100011
X-Stat-Signature: mzfgqwsdy4nio87ua3snxg661sc3e7an
X-HE-Tag: 1779727870-827710
X-HE-Meta: U2FsdGVkX1/VAOCBkp4yAxr0RfO9cu0/oKot8sYbgih7zVOp89ZNJsXFgl6wDhINPtoVaarh4ntXymVvr5ohkCW0aVOK+jtjawMMxJB6xNrJW5dQj8YlIt6Rr3O711NZj5I2bh30f3so6MVzkQuSk+sTrNR6gsn2gfZ6mTStnjF33zGcxypZCUgUZBud/0A/7rBCDVAm+GOfQKBFdcYnWMvUgXaKQU9BL+jvP3BZjM7yV5xEX2qUqr5+aNEErBG22g+TTOqO/K6IsAKzG8RaChgghvSB+hhGVDwoNugHMUD1oZBpJ+ZVXn4r8W8lSn3D8JbeIhz1FKjycLfyWQSNoiAH3MP6w4CXw0oj6//ov5bWtBgRokW8dLhhBTSwGP7c2Jal8m1gqk8erRnW5B/hudeSzr7+0cKsYZ+Zb0YMWJoPbJvmHED6TwglkDwN+MSVqC7f3oKhfIgfl8uPNfzF9ISDq+GXfyg5cep5UxQNQqCcLZ/0YeYyR20u/NcsinPUsETyq1bn7L3yZvxG/nYPjiunIg1dHy/gObIEZ73JRgSxebsLYAROk+1JZ7ipfL5i5WijLXxsCpDrQoEF/CCpE9mnKJ6GrUThMIZhTeXCFpHewej8RHeyuKGkWpNAsKVUIImLLDTA6f0bNwLs5N9YDv6Nf8O1wy78Qd4954xs1syjZe8qfDNWvmeV2OQJY+jF3Wd/tY/B5bTqxQdK/KrEoesa5XXw/Ce88g00rluEYWs68YD6EhxbrHljbdhZhpY3Bqtay5ZpJaaDyH9irJB06LWu0jZPtex3TQGRdSE1UlnBbNH1T9tdy+37acE+avxiF5ohUjNrXAyoefQnCGQ0WnQmjHB7sEWIT+jXi4Q1+anWZmt2WG1TdEkGrYvvhHnFJ69CyPdsjDz/r0HVShV4xzfNKNEK6/V5hTuHA5CwuJV2Bt5Es96m3SOrHXMMrwKdK09cJ0wXdBzjNTOGLJ+
 IFY0JHjG
 vhc7jCGxS1vJ3PW5I7Fe0OzA0gxIqapQGHqc79dh87f6rYDOSTIukeW/VySxv+oILpwSqZKkwylJK/O7mgDDKJ7LFBQGvMZrKhQeXTF0EizlCWbgErrceltFWwdkaubFRAOdojoqUq9wL8Gvdgp2yV3p8BPXmvWD/89f+CKbRZyM1myDuJfGswdOgAthLBMJgErGL/hObpeEomNvbS6TL5/G3SXyj0R89iJDCCA1NROincgfdHM3r7X4LZIlxfkoQ9cGVWa+OK/RbdkRYta8H2h8I2+fxH0gCiHCTMXbMSzzbbtI79rM1EYNtfUqs1cdjFi34oOqBClu6egnkp+8av4bhfc3pG4/wtfbg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 18:04:25 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 5/23/2026 8:27 PM, SeongJae Park wrote:
> > On Fri, 22 May 2026 14:55:16 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> Introduce DAMOS_QUOTA_HUGEPAGE auto tuning Add a new DAMOS quota goal
> > 
> > I'd suggest to rename it to DAMOS_QUOTA_HUGEPAGE_BP for consistency.
> > 
> > Also, you missed the ending period after 'tuning'.
> > 
> >> metric to measure the amount of huge page consumption to total
> >> anonymous memory consumption ratio.
> > 
> > Why against anonymous memory only?
> Well, that was my first approach. All the projects that I have done
> recently were related to anonymous memory. I'll test it with total
> THP user vs total memory consumption and see if everything works
> in the same way.

Makes sense, looking forward to the test result!

[...]


Thanks,
SJ

