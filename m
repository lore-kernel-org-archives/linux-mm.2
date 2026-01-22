Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213D6D3EE77
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2644E6B0249; Thu, 22 Jan 2026 10:31:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214E56B024A; Thu, 22 Jan 2026 10:31:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E806B024B; Thu, 22 Jan 2026 10:31:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 016356B0249
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:31:33 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A19EF13AA02
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:31:33 +0000 (UTC)
X-FDA: 84359989266.26.4CCA18A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 83FFB1A000E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:31:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L7XP7F31;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769095891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUCjI+CtzxnoxJaEVPmLhoENbRQdUcL5/NtzvXoJq34=;
	b=XT+JHil6I1osNmwEPBMT7NEkItZUbykcZ+0OZOy7QWwX8ZkCe9KZKLrxYWIKBbMasc2U+M
	2QFciZl/ZqI+caCGwC+Zd2xpLqEYw1MpxRUxJ9GVfvGjqVo76Mc6y/kYzHBUzIDfi8znXx
	SMGo1lIx+ydj92JR1KZYy+c503mLIDw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L7XP7F31;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769095891; a=rsa-sha256;
	cv=none;
	b=Lpq0RNBk859VFah8657WZSEihgtKrfVNIYGrvXTl+h6eJ7H/8Kg9Tl5/qNvcSvQKKXCr+V
	Iyrm8OckW4OdfJaZ/LzRxNR7GXpQs5NwdBCIR0Uh164Qe1u6jVe6hsm//mZhdEV1y9UNrk
	itRGemJ8j63ypT1WWszAr+0tDv/NYNM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46B5541567;
	Thu, 22 Jan 2026 15:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBBAC116C6;
	Thu, 22 Jan 2026 15:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769095890;
	bh=QApDiBpGYcNk+c8GLuqpRlMuKY8TBhtdmMPGwIfToKI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=L7XP7F31mZRjMY5qsErAhs0bJz0KvUoFCCXwoIXXL/D4FOsSg0+If3e3sc5i69ORn
	 ZkRVjLMzZtwjNJ1o8oVPRTZNu5wjsURMVcN1yGQF9Pl9sNh1rWSmaTy4vA46W4DypR
	 ff86NSUzVRmuZUCmNFjp1NSuaXcdFMywAmyXV2tY=
Date: Thu, 22 Jan 2026 07:31:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: memfd_luo hotfixes
Message-Id: <20260122073129.6fc316b1b11ebcfd8273629a@linux-foundation.org>
In-Reply-To: <20260122151842.4069702-1-pratyush@kernel.org>
References: <20260122151842.4069702-1-pratyush@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rrwjd5asq5ajabe7eb8g3dcgz148rsxu
X-Rspamd-Queue-Id: 83FFB1A000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769095891-59479
X-HE-Meta: U2FsdGVkX18/6e0iuLh3jJzHK46bw41+j5tCfZMiA3cVtxWS+8De3ZY5kdqTmgOKU/du6KIvR8ZnieTSgSrFNdIjEGwkZaNMs//4UX3WPWaBVlPFRvxKn6ziy1KLvf7ir4FwjhTpGBvh47iUmgdFgHah2Tjsoe/yqDdwDcrw3Ywfyo53bEtYoHfSaTdEtrvnJCbCYBshJ/o/2aZQIKrZt27ajhChiHhAJ7s5QTG1H5M2pa1SLv4TwYP5b/MptEratL/MC6VvrMsePlPG9kyohMtReWM1rEe/eybM+ore7hNCuvrdw/7jYKmkGlURgBzruFUeuzPPM3JkQrTahYXKVJZXwno1BkwKjmtHtY936ZaBf9gpc3c1SJBdhqT32NHzFe+envwmYDXNCgFbiJ6soVGjeYakXQQwggYQgSLg6XnOcSL/R/mF9HGxHvT2AYKXGtHcRcawY2tZSt0p2/t8IMaDyahSjrffRK1CpynIkgpxpB2QKYQ+yFyWgQfykk4sFjqJN9GF/YoJ5Jrrfq0I0gSTm+qlq0PI+oxMsTTI/HLqCNq27bUsG0Gwd/GkFqz34cu8xJhCHzJdzp4uUQ2TBUMiVVPPJqMCddOo1yv7iUVxti+5SSGmQ+K5Vy+WFJ/r6FGcAAXHHlxJXTK1BxsaqJQiK8ldpVXQZdJjyDLm/REhjajk3WMvEJ83tcyzDKiUU+MJxAQml5HUvdNbAEHCLM3FgSamzfQU32t8Jum9fKFg4DJ6Ecu41JkTrKVif0x64prlDsQKHiGHNVrMqaXVHN4FsctSmZrI8uD70Jc3YVHh046WW0kfICmRI5rgMt4NxDJM04H282i19Dmxiisq8A9t5f0U88RCBOBa4l2HbcWbYjaIzH5hMj4fFvVenBjbltnLGO80NbY7KDq+R4DT7LNvmW+h4Ouh3A8fT05xxhoE/yzNUdbg0DgrKPHtrHHJ2P3esbzn0m/Gl5EZHt2
 J0I6zq6V
 UjvNVCZ6ZXJpVJBr3SfXjqvQ6dZjj9Q/1i8HKZy8cY0jRMM07EN5FQcF6H096HWGHuGvlVq6FmTt7AUr0R78W9Wmi+IPwcfa2yKH75jJbRlcuY0zoX9ObjLwHU908Rk4y1v6dKnVwYs5dIo+ghNG2mTjA0GECGjBxVaGU8I5n2pTjXpIHVsEirB8C/I5T3T+VTCJtLXvh+ZB9G4gSFFKNwLR6u5kXKDSaI4s8ousZn3yVm67sl5x0HGRekUg1Ik14CZBOY78kYozRQ3pvElO0/h8wPZ+GGjPG3qRBYCcv028MEajBTiuhX1p+3M8COQ0eVyVU+0aJMb8y0KiGCLYZsf+6OA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 16:18:38 +0100 Pratyush Yadav <pratyush@kernel.org> wrote:

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Hi,
> 
> This series contains a couple of fixes for memfd preservation using LUO.

Good stuff.

> Andrew, it would be great if we can land these in v6.19, especially
> patches 1 and 2 since they fix a usability and a security problem. Patch
> 3 can wait, but then it is pretty simple too.

Absolutely.  Patches which fix material which was added in the current
cycle get the red carpet treatment.


