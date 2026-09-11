Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC3BCC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24076B0092; Fri, 11 Sep 2026 11:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA5C6B0095; Fri, 11 Sep 2026 11:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A106F6B0096; Fri, 11 Sep 2026 11:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8094D6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:11:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 695C3140256
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:11:25 +0000 (UTC)
X-FDA: 85201820130.13.2BCF710
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 969B44000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:11:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjk+54J5;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789139483;
	b=Nzin9QuVHFQrBXFT55oC9pCtQqUAhlKM6Y+0C/umNOjoMD86lsq/Pj/ypebJqqtvBFgAoU
	GEC+7RiFb6qrazniOkKUrPOU2ZIHMXy0quNkixOiRgW90k2f042RvsYA5BiwX/6seK+J86
	7v+exoALb8+1A1ey088SuDzi1hcqiDQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjk+54J5;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789139483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iu2JRtfBKdw5UgsTdTbkx1XDQxV98TajGeovQN2VTCg=;
	b=LtZN1TF+Y1B0wkMmQJHxC0zyw++bbMzS844Ogmi2MYWHIqpkZXTJTI/nOLsBXfBEhDBDm2
	GDeSxPclLrjIeig1k/GmfWELiY3fHRDu5jHIv8MNk6Y4ozG/WvbTJf4c67FKoNVJ/Js/ZZ
	ZlRVXFVuF/5eyBoCmXKjs7rQuOncOBU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F0E54350E;
	Fri, 11 Sep 2026 15:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6A81F000FF;
	Fri, 11 Sep 2026 15:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789139482;
	bh=iu2JRtfBKdw5UgsTdTbkx1XDQxV98TajGeovQN2VTCg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mjk+54J5E11AK3BFX4w4nNZOxHjiM64TNIKniajxes2e3pgfcqwMrSkU84pm3BHGh
	 wZFXNRQva8aVjdC1fBCT0RwQIFXNhULvDiyNmfO+MIU0bcmyZWDoFqIJ8hFh/pE7Qo
	 nTLsdGnbeqAROANpRP9aduKIbkejO1OOS3fi5Qvx43gaHaXRGMvMUCChyN6zcXLMap
	 +aCvj9fE9dOHQUKP27oV4srfYDeUi92KNImyzbgpRqvM7f8XC1FM1YH4VG77RcuHYd
	 hMITmvtrH5RxkU84V8Z1MJR1pZ7X5k/18GEZEnYxJkr8CzrfwpiYFxOAmmLJykMMUB
	 hcFOnzqivZj9A==
Message-ID: <9e902c8e-c825-45ee-89a1-85923453e43d@kernel.org>
Date: Fri, 11 Sep 2026 17:11:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 0/12] mm: use per-VMA lock in __access_remote_vm
 for improved monitoring reliability
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>
References: <20260724222934.1463812-1-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 969B44000A
X-Stat-Signature: dcbtgtwam13cf49n1cnxhhfe7sxitz6d
X-Rspam-User: 
X-HE-Tag: 1789139483-653332
X-HE-Meta: U2FsdGVkX1+UTcFw7adFl6JqjgfZ23IqwZIxA6xzl6dRHCG5CkIhSqPd4hmMrgUla10GtVXnovbB4k+5LCivgDy6GHRc4UQar+kcMK7FQupcCWzG+f7ZQLidrDx6IYn6T3OShFSruE66YgjZDrXdDbZdPqx3LYnhJ4hGcsX+ZnppUEW43tex7i3r8h60xgnYBjOmCPJUfovt4ESBoKMb3NquVd98i2MNArjhULZj9rm4jCcAntyNnh53HAhBTW8CuOSV3XeagrV9/VdbM5FhMLcf29WEkdkYv9na1lDbo0Dz5DinPwXfw1BSKJyMbDYzU7AbHqlX4evEbiDTced9SHRNikuC5ZqtsLlP3Wn4qX2QrBghQ4esyJTAvzYSCLiiKbsPoBS8abIQKPLK8oVfxo7IOXYSoB30/RJkRCYJUky3UNZfXxdcAZygGYE6SxJsORJFqJCZuZAuNgMW5ZvOZA/pYSz8AGc0Tn18k+EB48o0yIbh/P62D7okzrpTNiH0I/g9oPBrS2h8CbHWTmVjvnXLMNb8VNS7TPTK9RCspYqF71ztFtKWa4WZSiruT57/tz710BoyqTveEc3e2vmPp3tkbmQdHlQCeZcChz872Oab1tdrIvth7JlXjP6NRbJ/yofSIiqrYSjOEaPZT0/YD7aHw157yJhRsosvzxIYcVBi9rbIdtBwq/zoGn3n8QJ4KYrkp5X5S7mjcojamUeBjy4WYEbKOJKxxczSQAupOHK1ioKlmcISZtU4xiPLM7tQGGcLcBfP9d4TpQSb0xoUDTAEPEC17S+DCDUoXX9HdjsGNo/pjyxjxD7VkZUQeH/v4mV+eiO1SRIQHR5Td4nUypVKef5N6egdeSgXQmHOMmkaobDYJss2d3tVGh0Ky2ijDQyS3/Ivf9gbcPAhMkXhoXOQ1wOIUJ10HFFEZzSCPVPC0DaFO/L1/eWW5HfZFtqJ3HYWAUlLD+n7Kehpw7E
 kvCSP6UJ
 34NuwB1hLZv87f1qxlsugyQhiC2h5Da7JR4ofvHvPlbqaFtjDG1QTeRo91lFelTqULkbSNqX42/1atpq6VcGqvV4ivxGGcRq+kSDLu7j3YwF7Ix3GTAKsYsyLSos/N8/DfpTbdvUKQvuBTJB9PnO++ozCkr5mxcr8/erm5wewQNserpGXE+xwaPRVdwHBi+sZEQt2duUBmFOgj4kDFtwVOQXLSV9CvzPRYeOTpYXiW4bwFtoljTgkoLgReNcRt6VZSFx762L1mV61zi51UI2SjhDBpGgHfY+J4Zt/721+0AbHhrGD9CqpBIpfbZJVXSgyWcWX9DMYAxFnb+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/26 00:29, Rik van Riel wrote:
> __access_remote_vm() holds mmap_read_lock() for the whole transfer. On
> large machines, with large multi-threaded applications, the mmap_lock
> is often contended, leading to things like reads of /proc/PID/cmdline
> stalling.
> 
> This results in system monitoring tools getting stuck, right when
> system information would be the most helpful.

Rik, what's the status of this, and which series do you consider more relevant:
the pure per-VMA lock change or the pure page-table walking + folio batching?

I'd assume the page-table walking would result in more speedup and the per-VMA
in mostly less contention. So likely we'd want the page-table walking
optimization first.

-- 
Cheers,

David

