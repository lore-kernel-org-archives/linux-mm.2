Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B092BCCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 01:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F888E0006; Tue, 21 Oct 2025 21:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1073C8E0002; Tue, 21 Oct 2025 21:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043B78E0006; Tue, 21 Oct 2025 21:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA1988E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:50:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5DF8C061A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:50:51 +0000 (UTC)
X-FDA: 84024071502.25.73E2061
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 104FBC000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:50:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hsa0ngDZ;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761097850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2YSkXI+OfZc/rUVZMgAjDyCApxB0TmfMshFVIywCEk=;
	b=RFNK5QfjKxup8n+Fqp11Zri8Y9ZXuVwgnTj/eqjr2fUk/c6s8WMC9skktM/dS8BLDabKdu
	RkP2PT+gg5i0ab5b6ccji1RT78uJR9roR46FlIny0zW2XxQgPLJiJlk+eN7GEFuMfuUPjz
	iV+92kti4O/ypMv+EnQ2uFPzDTCalcA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hsa0ngDZ;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761097850; a=rsa-sha256;
	cv=none;
	b=cPd9/74FY7y1pE4ox/qN3Xh7V4DC/K2IgMeWQfF/NP/OS9x/Ac3d7xEAcLJuRTN2p3cK1A
	qj7bJ6F1rYAxVeQh25+noBdP0ke3Ja0ks6kLx1R8XD5rcoGv8AdUJZXy7Ab7+EL8f/Krtu
	+FUU9Siv0tp5BAVGVb7cYOiRT7/HVww=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACB22452FB;
	Wed, 22 Oct 2025 01:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C96EC4CEF1;
	Wed, 22 Oct 2025 01:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761097848;
	bh=dKGKS0+JDysg3kqdM4BzmAJuhCTKIrjASlQXxIPuPgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hsa0ngDZKR4G0GcHfwCihv/cvOshIPc1efe1v6DFLnoteAo2esfEIK/YkSkbkpFF8
	 GCNwoqfUmiGrvdoin4oVw6tWjokEcEKzxJ3zm/6DiWdUMb28CK3OL8eJ3eaHsASFAh
	 5yriqTHiDhtLewSV4pHBf1LTH5IvNEO+LpHbMcaTvXg/AJJlBZfWnLRVJbUxWDkB3b
	 w9ChPzxpqEHRBOPVyqTd1FLe2c0m4NcUxIK9Xd2RxLeYaqKsGeMIZJp1xkHnxbbzAm
	 cX9n1Fd2o2/FpQt9F/9ofa7GYHx3EO7HVeb8UOZ9pRbuz+NgnIVnSJY3KBQzY1jymt
	 dGM+seC2uY1cA==
From: SeongJae Park <sj@kernel.org>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-new v2] mm/khugepaged: Factor out common logic in [scan,alloc]_sleep_millisecs_store()
Date: Tue, 21 Oct 2025 18:50:45 -0700
Message-ID: <20251022015045.129146-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021134431.26488-1-leon.hwang@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 104FBC000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: txwtgd6yjhzwtig4pfhkh1i3nnyubitu
X-HE-Tag: 1761097849-201494
X-HE-Meta: U2FsdGVkX19XCF3cnw92bujUz4QnWU0XXIeXswj+D28wMDIkX/dalJK5Jm/d83/WkkQszY0dpP75fapMmCdzQRQZSaRj5SCoML9NNge4tXiVAa90P2Oak6zGhSoeWBk3PDMYSyU9GUjVHJvvpMeEZpD7AIdm3wBT7X9INJeZ7zldTR+qR18g7n+hEYBKKxUZRYzu2Me3OFtU88qVzcgBOYglNMzwOtBLml7EKXDLNEDpWprDBbUUA9wyifmK/BXuItz0Udn9bmQm/J4cYvivo6HZi+PaKCee02kZisKE2/SUfHZEUqf7pbr5JqDUdrY2+7ysma/j2ZgkM1UZQIRvObfOnN/sWQbOW379Oc6ISACkPOXE6yMy9kJKAoF/KKFJiKHO4+ABaNxzExgpgOjGRaHxFxXmq7guIdWkkZn6sbQvtW70H6pTCKibZZxYIuRTRb+Uaz+XE5rQKSOUJkmT3ul71LvSWZEY1dMTEdZWcTTun0vbPkK3v+YgyDR/kj8ZfOfJsIWZuDwoxcp4Zq+5BtkDvLOcuyycIl8kx4Xo8jeDUrs0124aeTH3bvYg4JwCzQWmBsYw8HpiJh02Kj23o5SwvJ5lQAcpmOCXo13tQOfqhQXRsR8CJAdkYPJV8lY3W4ffj++gqMQpqdQEJGvrXXTqCusdabpbeu6iPUKf46WPE+KGb3Tal3/D8HX5Z+FORwCemOHJqL4L2SJ+EKnaSx52Be1dkC2Xoco40vA0VlPIS/APLrAit6grvI0wot3Htr6uoDkz37fU0r23ZnuC5MSD1giE+QT5IFRN6mVBgAjMODxrzq8EKLp4q8LMfrmofa1P9RpgyD2T1JUHYg2H9FtbqGMNsFmz+Re3XPRmCRus4Wn4lcPuAmavMLszu3gZ9yzMCpuUbx/L6BaUHZilbiYRxovwahAP8e/rtZc1v1vZgnaQhMYfc800b9FlXv5lOlfpWmKhFS7DUd45940
 xHj7sc1k
 ioavMacF4zvb/aBu5ky5NbO7KH0MHb22HeHaOHMoYyH0J6t8xINwxalxCeX5lrUw9TwKyqG55579gqf0BcnJR5rpvgTSqnsijJuP+el6jmR4Tb+mXmejweywaEw38qsvxBnPoPlh3bnPnrjrAXcKPQts1elsoIHE76MgzxZd3PfLGtUU19UksDnDauV90Vflg2hyw+qGk3kA3xE5lZT+HPsPQxCam+qgWkvxiPDZuM6WYzL7LJrvdpVfG2Dx68YPtsG9eL0bItw3V+uZYnXm3/1/GlGEBBZNnQCkdClbYFQ6ZuXk87TgZSbed7KlPD246G/BpcAvt+GQIJcs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 21:44:31 +0800 Leon Hwang <leon.hwang@linux.dev> wrote:

> Both scan_sleep_millisecs_store() and alloc_sleep_millisecs_store()
> perform the same operations: parse the input value, update their
> respective sleep interval, reset khugepaged_sleep_expire, and wake up
> the khugepaged thread.
> 
> Factor out this duplicated logic into a helper function
> __sleep_millisecs_store(), and simplify both store functions.
> 
> No functional change intended.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

