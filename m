Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 281C6C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDB86B0093; Tue, 15 Sep 2026 22:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6236B0095; Tue, 15 Sep 2026 22:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F756B0096; Tue, 15 Sep 2026 22:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBFAA6B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:21:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 448DC1405DD
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:21:45 +0000 (UTC)
X-FDA: 85218024570.05.50A94EB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 49D341C0006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:21:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JoXbFyMV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789525303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PDqoq+zdboGZz+ZtWzehFvO/uG7ox3OUn57jhvPSSU=;
	b=ImAC4ZDaMNYgIcg0vHY+tGngnmJObbvSFlSdT22HJjfkaY1aBbuB0z6tTOdP7IbBqS9QlB
	nQ9u9HQfzdDV4gVWQcbGMOLagt5qYk7BEm7AcxIzi0DIXcG+pBnTsQODx90xLxKNx+/YMt
	zt1uFnC9W2OnNzGCbnapuloN3Hbc1m4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789525303;
	b=hbpvAzLPh28T61LJ1cpNT4H00IpoWmckwD+dtRrP6sgVwPhjlA39PL9esBrt/XPO5666dz
	Ap1fYIzr2HuodiQlVpb08XJIbfnjStiVZCdyZxaAwfY9uHz+U3xojHBO2hsyf1TUwJhYR7
	+FYodREeWk4J+SehbRDqosUreMuOQ9M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JoXbFyMV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 877521516;
	Tue, 15 Sep 2026 19:21:38 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E8F33F882;
	Tue, 15 Sep 2026 19:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789525302; bh=S4w36axQ/SJ69u2USTyQfVcFaYAkRYJZPUbJ4PAI6Oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JoXbFyMVWWZjqZk7Hc5TRbF/vgpn9cjNNGutfJNMW8RhND0pNpA5AXidlK9Ldvtsa
	 TWTQ+aTujtaCejCqatN/QhAotVYLBDh5r4kqL5fLeY+perXuNG1cI8QD+Ep0/zP7o5
	 E/bEJGq1a8cTncs9O48EsuAoacSHe0uhQShjZ2Z0=
Date: Wed, 16 Sep 2026 03:21:36 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH 0/2] kselftest: mm: fix intermittent failure khugepaged
 test
Message-ID: <aqn9MBPcN4nctCBI@e129823.arm.com>
References: <20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com>
 <20260915181519.648c2962143b761cf02efd17@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915181519.648c2962143b761cf02efd17@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 49D341C0006
X-Stat-Signature: wqoe54djagibenn4ay5gk3amz7csrdkb
X-HE-Tag: 1789525303-990733
X-HE-Meta: U2FsdGVkX187d/jkWI+OrVRnfF6jVH+cUXexVZzIYUlwosUNdRkkIWb2kQkH+oinzRDXDE94K2cRGhOCb2g9nATwMf2yMZXM1NXj2Zqh7u8EXyOaTDjRzaCbPu6QfJatFrNqgOgmWpQP72P9D1GOjPvQspilMYuHLVdb8UZGI146wdE/O2UOF86Jx/6Ix4hHACbRYNq4vYQz0hOakVu8L0rQfKwGlkt0Mn4YRv7rasfLdMH5BFjqbrqvFbRkZ8/CgSQiU6mTZhroa0y5sFCpgP7dUzmOIYR0JGkUsfk6NwnwfsGR0mgc0JeLjhsiZux44ka2rOYQd5QUY0vaNTkP/c6Q6gRfe9idA3H97JLcaYF20/PI7/EDt57XW1sonbrqU+2oNx2GMxcAvnpZVCbcl+cZvNuuWrrzE9hiMqeI1Urg3NMsTMQpNmaYvAK2kVd6b1/xkETlF1YLxOY1eTAFP9L1/wk6ckkSsq89TVhyq/l7FqRVAGLzdiCkQ6t/ined1EnTlM+xs1N2WI/y8tDhRG/+ZT8KodUcHf0WfOiwbzM7RW7aLA7ZOYLe0vVWbXe7TH+q8N5IeqSWzCZQJr/QrzQGB215gmp52B6R2kbM2QQKhQxVXh3KDbIrcvFWlCpvB758xu+aFa49zpYJTBzO6AuN24l1zkcwoJLc8bBrZ6aBDIxD8ZRvxRUsQtFYkJYg9EuotbKL4lpXGKufkDwuoDyx+LAYdcmuScgOjZEOEDnM5Iv1miEFEt1XDFwcX4jNq4n42tReS/JrPunAnF2cCfu4fawuIrHxdQ/sE4suUQXPVy78rzoePOpygkX0vNrEYRayxkMb/As3lYEaPs8wAIZ30yQTbh90NU/DRndz52s38KDDWs0vIAgcpAyynpuv+ZRd6O+EdWHf6eJq2OJAvUVEfO/W3x7ySqpWyahlYJDe7wm5yp+37trLFTu0rmsZQ4T7QGsqmowQNSNu5fu
 5wxhXQJ0
 JqOgYmBwnEFngH08G3pqdEfvieKZhS6B46/fOLuzVzskfJQ11J64YLsZxFPsUItDRdnmFi5K+7uitWtJFa4BJUHpJysCk+JQ2GsH/UoX1+IKBmQBlqZUm9cT4TAHLxlq8j+RchqqsAVeVlqZoVVAY4uAhv51qrA1DT6Q2Pz6MrE49VzrBVy8NTwJA13X3AL8kq9Q3ZBH189+XFD56BICFA+hDaosZH+xD+Zox+OR+SWpmlhizKhKMqlMLjxYfmoBhcvF6OX48ulm6DipaGwA9BF97Jthr+DKfRkLx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Tue, 15 Sep 2026 10:21:35 +0100 Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> 
> > There are intermittent failures in collapse_max_ptes_swap() and
> > collapse_max_ptes_shared() when using the khugepaged_context:
> > 
> >   # Run test: collapse_max_ptes_shared (khugepaged:anon)
> >   # Allocate huge page... OK
> >   # Share huge page over fork()... OK
> >   # Trigger CoW on page 1023 of 2048... OK
> >   # Maybe collapse with max_ptes_shared exceeded.... OK
> >   # Trigger CoW on page 1024 of 2048... Fail
> >   Bail out! Unexpected huge page
> >   # Planned tests != run tests (26 != 23)
> >   # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> >   # Run test: collapse_max_ptes_swap (khugepaged:anon)
> >   # Swapout 257 of 2048 pages... OK
> >   # Maybe collapse with max_ptes_swap exceeded.... OK
> >   # Swapout 256 of 2048 pages... OK
> >   Bail out! Unexpected huge page
> >   # Planned tests != run tests (26 != 17)
> >   # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> > This happens because khugepaged may collapse the pages before wait_for_scan()
> > is called, causing a sanity check that expects uncollapsed pages to fail.
> 
> Is this something we should be testing for?  If I'm understanding
> correctly, success/failure is dependent on timing vargaries inside the
> kernel and that isn't something we can reliably test for.
> 
> IOW, should we say "bad idea" and just delete this test case?

If the test environment can be set up to control those timing vagaries,
I believe in that such cases are meaningful for verifying the expected
behavior.

This patch sets up the conditions needed to make the result reliable,
so I don't think this test case should be dismissed as a bad idea or
deleted as inherently unreliable.

-- 
Sincerely,
Yeoreum Yun

