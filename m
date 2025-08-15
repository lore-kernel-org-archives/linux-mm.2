Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C30BCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 11:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D368E01EE; Fri, 15 Aug 2025 07:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC978E01EC; Fri, 15 Aug 2025 07:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4798E01EE; Fri, 15 Aug 2025 07:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A63148E01EC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 07:19:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50B2252CF8
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:19:42 +0000 (UTC)
X-FDA: 83778746604.07.DCD10CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 86FBAA000C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:19:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755256780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aqyNw+Jm7HoH5Z0KlAgJAQwfjE1pdVnkoWxhIxI0/t0=;
	b=b2CI1uQY82pYBDaPXZMRO+vCpV0mKIsj8CYfohpflzPg7AyJqG2Udjgmm3ZNWg3EN97Sj2
	4KIt0QoYgfm4u/XKwjrnp8qf/+k0CIWGJqZdqtICvbYpTc6SZcOROse2XhgBv5B63DDyC4
	1xycZABBwShDvPeAXKxo+lKSo6EdI00=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755256780; a=rsa-sha256;
	cv=none;
	b=Y9v8hWalwAHASlWpBNrqmvWV+ASCCj+nWGdgLfPeb2bVjdwrIYW5T9woCkTCS7YsbsbgQT
	mI2blylMc/0qaOX/k1nmDEtw7I4+ZxL6ZIEqJZZafC/pedSE8v4X/y+RBd6qe/d6RS/0Ko
	Z+nZoJ8539QZQZmFWojJ/og9VnJbCgA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C5FB6116F;
	Fri, 15 Aug 2025 11:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CE9C4CEF0;
	Fri, 15 Aug 2025 11:19:34 +0000 (UTC)
Date: Fri, 15 Aug 2025 12:19:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, glider@google.com,
	Marco Elver <elver@google.com>, ryabinin.a.a@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	will@kernel.org, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] kasan/hw-tags: introduce kasan.store_only option
Message-ID: <aJ8XxLGiaVmWUCk6@arm.com>
References: <20250813175335.3980268-1-yeoreum.yun@arm.com>
 <20250813175335.3980268-2-yeoreum.yun@arm.com>
 <CA+fCnZd=EQ+5b=rBQ66LkJ3Bz2GrKHvnYk0DQLbs=o9=k0C69g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZd=EQ+5b=rBQ66LkJ3Bz2GrKHvnYk0DQLbs=o9=k0C69g@mail.gmail.com>
X-Stat-Signature: m61gewzz748o47mp8zxsufagwo4bkq4w
X-Rspam-User: 
X-Rspamd-Queue-Id: 86FBAA000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1755256780-613905
X-HE-Meta: U2FsdGVkX18lZ+U6lCI3D3t56CGNXrMofyfwkvUZ232/Xz/Twql/FLKeJcSouwOutUWxCa6YEJgQ3y4GDcZ0NCRQywlrmqM6kyfvmVENHJZUWOClqfQ2ko482m0PuoD1jU6U1oqmzB6BDvKnsaI9SQaHZOSxd6Y5i1yMSLLln/mkcQXRd6q4kwMqFY/JED+fePr/vYp8/JFxzRWGFBV+R6uf520hwIFlIbUG1vYdauWMoRdvbDORhRc4crKqDGLh2qdWopGm6u9N2XWbMsHcC+iHXjt8VUILUvVj5ZvUBlz4HPTB0hELe5C8KGPYOzEkq9NpTp5/NipI/xyTPtIPedSS27pGzi1KCF0T7EJ1Y1qN6r93Sm+ImpH/X3Q8auiplq56k4DdOVhzA9XOy7UMwJK5ndrUJ23SZ+CCR9JSUGx/si9/JtqKOqbNwS8fbRmfgdw/EH91Xm1hGuAjjQ7WuIkKupKf6bHwPwysQ88ZVdJTmxiODbddqPB5jrxHVKMkqjB7L9MiQjVDANXyDedqlVA4i1vu+E4t7T4XvDK9BU5dDDCch8xaO+j8N6higHxDUIC+sLbznBJt/2eQIZxXaWv6PVb6Asncbw51Hzx6Y9IG+Z21XLrg6BegqiTXvJiOFKzBaE69pztvN49eHnyHPB58g6a9Ue5ZpfBpdy86WQQWueGFVIWuQjbxxlrc0F7sxALcSFP9YtHqQXClAMZYEH70+An7lj/MbBCphcHFqRReni0s/H6eVAMW0QIXiUmPHImogclpNfQOKQFSkqJVuhV6cSog1FHmkMWEN5sxiIpJQ4i0K0AlME9SpbM5H6V4qP03Yo9aFp+Z99VFuwhxNyoo+rWcT31pO6jLQNxj9npOKpmVS4MIzmN5xJQpaSShYSl94lbvRm9uJsrRPA2L4c4WrtzfCd4sombrXR9KdGc6Jmp3kl0fLGBPFTMs46juUyOUqoYlRHRoNkyWKth
 uQBjV5mL
 +4zDrcYYdgKho28Lz99OjHQXWT/n6yBxyZ0wHIH5xstkNyN6rU3+XaoCIOCUgCs1j4AduUH5LINqRH6WjqREYRLl73LnnErdr+Jlx4i+iIRAhSnXZz9v3aWr/JgvjnIgK93/x5L2FSDbBwOx/eSlAX3RtLLUAjQV27iH/f4ysaa1Gj0iSLevYk8a5GLcEG/L670s7ds83Kh0cKsuDn8VvYI6QMnT5CFIVZR/dJBjwkb2LyCt5EXEPwX0UCBC8ag11065p4L12yM3PkeP5K+zxmWVXXLi6p7n2UihqvNOFNkFB9MtQOO5T5BiLr5ZXUabaEBiyk8OAh0W9VqvyO9djd4lIzIpIrigbBz2AK/bvffTvgXModm5es96S0+qda6uokuLs7KF3zYOnLZ4oPxp6bQdBSZDMOtVmjFCPAib9XuLhXc2Z2Jrs5TMP1FMzuXDLv3dSKjePl/NhjUGieyVhnZ/LeEi8yMvpFMagNT2tyfn9NVBNAfbc/s4+wD/G8xOBj4BCZlIqbvpSovykhpNpUN/7nKNCV6d1Ef6LHYvz6+Z1iY0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 07:03:35AM +0200, Andrey Konovalov wrote:
> On Wed, Aug 13, 2025 at 7:53 PM Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> > Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> > raise of tag check fault on store operation only.
> > Introcude KASAN store only mode based on this feature.
> >
> > KASAN store only mode restricts KASAN checks operation for store only and
> > omits the checks for fetch/read operation when accessing memory.
> > So it might be used not only debugging enviroment but also normal
> > enviroment to check memory safty.
> >
> > This features can be controlled with "kasan.store_only" arguments.
> > When "kasan.store_only=on", KASAN checks store only mode otherwise
> > KASAN checks all operations.
> 
> I'm thinking if we should name this "kasan.write_only" instead of
> "kasan.store_only". This would align the terms with the
> "kasan.fault=panic_on_write" parameter we already have. But then it
> would be different from "FEATURE_MTE_STORE_ONLY", which is what Arm
> documentation uses (right?).

"write_only" works for me, kasan is meant to be generic even though it
currently closely follows the arm nomenclature.

-- 
Catalin

