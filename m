Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7029C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 07:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A159C6B0092; Wed, 16 Sep 2026 03:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5426B0093; Wed, 16 Sep 2026 03:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D44D6B0096; Wed, 16 Sep 2026 03:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 697926B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:25:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8F6BC063E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:25:40 +0000 (UTC)
X-FDA: 85218790440.21.25704CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 43DFB180006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:25:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aPllAhP/";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789543539;
	b=SdYAwQganjwOEBaQFQJI5v8cOgQM/fG85zVBAxkW0nGpRM+98NVl/mgTNNnkdR6isScKcY
	uS5TZNl/Mgh3l3nV+P2+ehCVu01egoeufj3v6AnmYctTXiR1/7P2GYFUeClWax3B+M73tt
	UwCAzd8QJ2iertw8A9WHDlmeFZk5B1c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aPllAhP/";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789543539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTAbzpbd689UtjWc7ueN/qun11QEBcpbtvPP6kcJl3A=;
	b=J/YiunWDeJbYA/7zpk0DJ7eT9SHvnTt39JVAQ4XHUWcRvthBPJwtkKyEbozhMJ6j1CjNz6
	nkVgjVsuLDJc8JO+jj3QxlsEuY/Bx+XO09gHErA06JF+G3GRgrXXqjKpC3gTu0b5WCibDT
	Kn2PfmVYLM4Q9sRzv4/S9LyTeUARzOk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0856C6020C;
	Wed, 16 Sep 2026 07:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4042C1F000FF;
	Wed, 16 Sep 2026 07:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789543537;
	bh=OTAbzpbd689UtjWc7ueN/qun11QEBcpbtvPP6kcJl3A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aPllAhP/D260wKxa1eciVF4i58bkw1K3RnRin3bsjAe6M+xJNytQAyh7itdX0YOK/
	 bgCT4pwsqEJx0iuzAk/B1k9JChuKeZsVglHn2Z/6H1qE9Ly1KgZBcQyFObCzB5+38j
	 x1h51re/UC3f6kHfe4FLPyeT3bsmQVjb/MLTXinlPt74rVQh+489dHUkUzzAgOnQfM
	 pUv4O1Ig1W+n1CXnaFBmvFvYDnrRjm8DVU1PxCgiVwwziGjclOS1HVRdS0PTXd2aQK
	 JgYIbWTxpnGfF1yB1xkEdCX8lIBjudQaiTRv3mPSs+QGyB5d4oLjGJ0ZXCtrmrNcXc
	 9Wvvqwx8lWjDg==
Message-ID: <1018bcc2-fa80-4e88-a845-d8c4bb59b2e4@kernel.org>
Date: Wed, 16 Sep 2026 09:25:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: skip khugepaged file tests if mkfs.xfs
 is unavailable
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>, akpm@linux-foundation.org,
 shuah@kernel.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20260912202903.16157-1-jaeyeon.lee.dev@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260912202903.16157-1-jaeyeon.lee.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 43DFB180006
X-Stat-Signature: dmmcydom4jtd4aomrbbkgzgcnyywi4en
X-Rspam-User: 
X-HE-Tag: 1789543539-671873
X-HE-Meta: U2FsdGVkX1+ybHAGmF+xnl5IzHst7FNNTs2CNL2Sqc8O/i7jsGv0Etf2SNuPrZ5cInQZK2jx0NiS3NnNJgodI851f7sEmsKf1Lfh1F9N1V1qHkCYe8gaXFI4ymLkRFioofwwbbj9QHvDLQZh1YI/w5saisOVozt5o1SMzrcbDzKhrFX80ln7x+TdqMgSBydVurIxE04Q2VievgVkKsZSI+uKCb+BvB6qNHZi8Jqxr+CEygr6k+FxVUs0CwuEnI3uButS0WrGXGAY8UTJmhiz65Zhx6pUEOmRQUb3Lqc32EuWsW6NMaH3TBF0avHYOzgES3Yjo4Svqo+7Ym47WC6bqdjJwGu8hQLsgBt7BR0w5ukrVMmVI3wGVQe1pXdRcw7/0kWXT3X6Kpq/YBHS635VwfK9wmZwaxsiUqnnSvH7u1014NLrKZXUxAoLRV9VP712nswpONcU/6U6eTqplGAkHagu0G4hhAcuzaXMVwm/FCbVONRmvg8q5rVFj9HTKsxXLgGCNJbTCYWRvmbYGRx1VA6k2WLuXettqL8f5w0RycydbnnQwt1ryw83ZYAHUqbzYfDkgPbfZXQRATXJrRCewlYEsPWaRnQmJnYgwYOjVFTFSgn13srBrxioYIIGTTvDNgJEoaatTC2eL59FSINi95dZCPVN3juAsOJiiMV6XfPct1hpoBbXvMddovJK3wFANPt0Qnj1p24FZtCmSIRaS5Sk0ixjU0Y+/MXWViILFT0kg2nI3O2Db8m1xBSQQ4rxpbaOaT0URkY6cT8+O+QhE5JQ5tEMPz5NoMxlLWxGj/KbaiBHwy0APNGx17r6U07SZt/bEZZP3UA/gu2dzbTqBc50YdhQijJXWveoQNFGoadeWRB8yUac4gPg6ZbH4tWVvocRp4f1YHIs+gzzXS1vgQwJw0i6gExlNcVm5kr7Lc6EFwqrt1MwzV8IspliQFRKm5VP8BHDCTceutW8KZR
 sUBMKy+0
 zcgZoA1G+Bh/laZmtcvEWXSlQYZP984jxsEXfuy648OdGKPXEPUoX/EiYIIzQ9iQl5R2tefLqQQaN4bq6IDm1vIq0UB4bwSw2Y5qjItwogpqgHLTRF/OvWKWq66JWRQGVFxDWlsZVBiV0QyXqhr978S/8RfV5Ik0JWciIuy25INzpE4Qv2g+LtFCHNo+bjhIAKP8LTpxJD96wFo3THX+zv86ZvOOdXoz2ozMzE22NF3xpEaDpB7himvzjelw7oqgDkx/Ld4+UGf5HA5bhPYtmQh8jDV+4SRu9yDEANhU3nuLDFzAnOwPqNOL3XXl6JeSkBGJ+cx1nOVucT5AA4iEEjLqxngRINnpvuBK1xGsstjqknY9BzpiwPehkcYRYWEYhWjYbgD2+atLXUAZaGpypvY5MwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/26 22:29, Jaeyeon Lee wrote:
> The XFS setup for ./khugepaged all:file checks that the kernel supports
> XFS but not that mkfs.xfs is installed. When CONFIG_XFS_FS=y and
> xfsprogs is missing, mkfs.xfs and mount both fail, but
> SPLIT_HUGE_PAGE_TEST_XFS_PATH is assigned from mktemp -d and stays set.
> The test then runs against plain tmpfs and six subtests fail.
> 
> The script already has a skip path for this test, but it never runs
> because the path variable is always set. Assign
> SPLIT_HUGE_PAGE_TEST_XFS_PATH only once mkfs.xfs and mount have both
> succeeded, and remove the image and directory otherwise.
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Assisted-by: LLM
> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

