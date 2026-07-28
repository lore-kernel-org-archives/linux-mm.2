Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAC1C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451096B007B; Tue, 28 Jul 2026 18:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4018F6B008A; Tue, 28 Jul 2026 18:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0886B008C; Tue, 28 Jul 2026 18:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F79A6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:07:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 918B5140528
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:07:48 +0000 (UTC)
X-FDA: 85039573416.12.7523174
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id 02A9C140003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:07:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LNPOGY2E;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4Dy3XC6qV1NBDVHSm+NbhvnKY5yieX/MYpP17k22sI=;
	b=N+GmwkyBcVjSDRcEPxqQ5Icb1hX0i6wa/djAmgf3vaPcszV6JQwVXP2EQ5KgY8K7S12h6s
	6eTvPmLXVkAL3noL1CrmTPGb30zQXvjXmbGNLpJ3tMy4HpW6clS7r9aVOIt/Ui/XWYVz0o
	S0Lr8nV3O4RoL8QdgDnlkBVQd5Dospo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276467;
	b=MJrflcKpZOQVqtrC6GFXrcKwbNa55XCljIlCpByy5+lZ5Q3mJ/rHqij1Blv3Lb8Mszyw/g
	nW3Z97mPxrsLw4TgIlgJe5jyWMHeF/BBt/YR2TXf/xEfFhnPzVmyVdAL0zEemdp90xgfpP
	beX3ZXM4IiWhLzxvppJmX5q4JMH8R/w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LNPOGY2E;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W4Dy3XC6qV1NBDVHSm+NbhvnKY5yieX/MYpP17k22sI=; b=LNPOGY2EtqaZoCfhvpiM1Z9mVM
	R47JO4wkihzNcB0yiiZcpYy9lpohbIafNUZ3l2vHDkbSbGhdvC4gRNeckQrQswUlR5ccBYvJ/MT7T
	30w9YM7x5pbW+UBQvlt4cR/zgunFQN2huxclA4gwk7WAA1qFsLtwB8QpCR8TaLJyBB+5ajZAhFziX
	Em0SlWdrnF812sHKXQcLyJkjU+YE2XW9vv3Vxn5beDDTppE5uxrj+l+2aDH+ie+/J91Rt5Lx3njkl
	9XQiyF2OD4EmnrQzcvhvdz7E5Lr5JR8fjDHfhOAvdyCipuZ/5hpEGKGTd8UDF8VSPVlnpQAyDsDGC
	SKT30P5g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wopxV-007zAH-0m;
	Tue, 28 Jul 2026 22:07:33 +0000
Date: Tue, 28 Jul 2026 15:07:26 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
Message-ID: <amkn21ftNme48Vbl@gmail.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
 <ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
 <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
 <de29c5cc-3637-cd18-354d-55ceb3d60afd@huawei.com>
 <amh1nZVVaaZSGD3M@gmail.com>
 <20260728122016.30752d36c3b3c3af231efa9d@linux-foundation.org>
 <44f81bea-d64a-4f73-8665-46652a928c83@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44f81bea-d64a-4f73-8665-46652a928c83@kernel.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 02A9C140003
X-Stat-Signature: qq1xogusw8gcaqj8zr4e5cazq3osskpc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785276466-845336
X-HE-Meta: U2FsdGVkX1+tS1h1HNtXseLiePw7PJMncI7E+LnIzx00dvtOq55kQnje7X+HrZeTanhQ7eMMlGlBRwwSQWDtGQPT1Cqe9YaF0vF+RdBhwwITuMqMd4fwqbk4rx0/xcNBv78Sul/8A7J7/cKZzsZ1nqq3yuZRAzvk+1zAO0vuq/D+d/vizWbkGSWUJV4fa6jRByBeWKFkkh2DL8yOoUe1yxEs7/sDTFiK0fFpNtKppGQfp4lSxU7a9wHwJnPwJ6ZkX1cilBzQXY96Es+nmbwuSdLwk8+rHBu0fhd3w7u7Kcyek+5baU2cgBQAOEeFa3lxuSzdsYoIoc88x8ETJ2Tp7RKqnSdcfdpqO+kt8w/gbTR5cANTlDTZZqWgJ65DRl59zES917ZtLeAST91omVKAICPadkmr0b1WU9MH2n3nLPAr2kMwsrFdMfegcvu4wm1Mcbm9RRnmffYRW5ua3KrxeyPhGvYf0Bd0ndUcHXfLRqVqlMlbaTEzGx4enOzSVmGBb/MqQjV5gXn9CzJUqFNMbfmDsEwxP7eUtMB7j8A3AkWdu7IabXWOT013kDV9M/DXTzsFCaC+3ni/gAYyI6ew/KXjbmbpMWjXhnHRl5n1THUqKWEq+iXCVnfDTZ8QjhnJ9V7N9L2tDTzFJWvwCHnIyi0/STCRr9WVSSPI9MIWRZTIbIvuQEkavuJaIQ29bckYCHOwBsxA1MLZpWv9Tvk9GkurygqkPXnvpzx2mEBF3oUnEh3h8VwVCJHxVepxil7oRvKXnV3vt2qZB/H407FtX4Xu35nkAmvpgqHplecpDntMJMsdchmXL9Qlcqc2/+HY645c8sFbtoX2BCDIjSbMV6JYRDvPtEVIh6ncoZlYKrEuFlu9qoSlc4nEV21Vii5fU3MqyftJAEEM5vi0Y/hprDjuSDIguCTlqnOtgpNt/pWqUTfF13q3K8f4sXftBip/ZV24nNz0ckLDHYdLp1D
 jxtUgdWb
 9KvZvulIH/DMgMv7JPiH0H3v438DcAkSvy8Qxzmo1ujoqiMj3bMu17xtisRUHMjxqaHFYdZ1/Di23XaSYjoJnV/MV9vbXL62IKeX+Oui0fZTfwU53WG3ajFYEiSE2OCU16osZagbZYSPINAKbtb9UqBeyjPB9vyfyk2sbiXM6hR2Jcw0CQCeBGrwd2fU5pqbWzbqeYhXXedSW1zbxSlQHverc8BBxQr1EdGUXKbWu/lNRt1upHTK53WeeZs4IbtH2OwQVbM2eR119JxlQWpUK9MWKaz6C7k9IKdRUgYUUWY5U/s33YypR4n+/NywAQOPmiRpuoXdiIkwrUH66kfRb4pcFKSARi8cuDFRjrrXtH1HopJngOKPYYMbnWQLcA9d2W71EE5I3XMVGJuwIAsKrOSvEQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:21:40PM +0200, David Hildenbrand (Arm) wrote:
> On 7/28/26 21:20, Andrew Morton wrote:
> > On Tue, 28 Jul 2026 02:29:39 -0700 Breno Leitao <leitao@debian.org> wrote:
> > 
> >> On Tue, Jul 28, 2026 at 04:57:13PM +0800, Miaohe Lin wrote:
> >>>
> >>> Sure. Should I make this change or should we wait until Breno has time to do it?
> >>
> >> Apologies for the delay. This is on my TODO list, and I'll prioritize it.
> >>
> >> Just to confirm: the feature is already in mm-next without the selftest, so I
> >> only need to submit the C version of the test, correct?
> > 
> > The bash script is still there, no known issues.
> > 
> > We have the thing and tests are useful.  I'd say retain it until the
> > rewrite-in-C happens?
> 
> Nacked-by: David Hildenbrand <david@kernel.org>

I have a draft of the selftest in C already and I will give it more bake
time, and I will submit it until EOW.

Sorry for the noise,
--breno

