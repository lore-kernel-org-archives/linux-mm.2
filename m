Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2EA5CDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58CD6B0092; Wed, 24 Jun 2026 21:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30666B0096; Wed, 24 Jun 2026 21:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47B06B0098; Wed, 24 Jun 2026 21:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A15E06B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:49:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B25340550
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:49:00 +0000 (UTC)
X-FDA: 84916751640.15.CD35FEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6E98FC0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:48:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Gt/rYUi4";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782352138;
	b=wV56ErEJhTXLdMqbbgjsWy8ORhSIZ0/aLXm/M1OUmEmrMlLdY15WBKPBM30y5YwRMJ5GMS
	spoFO1Zh3mhZU7BUq2TL1sSRsSjBOtykjHcnwxyT9np1lYaKggVcVPJmk0ON7colFfQeKT
	2l+gh6F8Htprc1WUGvxm73oO/hJoHZM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782352138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eaw6Jpmx0iTU5ok6S+y/E1c+JF1d6MfBmwaE/SiApvc=;
	b=emugKAFmWFPvEGpKmYOVRwpV/q98rHNXugMIjXAL1i0pfBBL53UMfk5lJf3QiGdWuUaBZR
	LP6Zp4a9f4LhDiQFWEDNLXZRiGCVLULWEtJeAb2ibaj125ZtyVL1x2WzByeR3P1gO6pra+
	mQlZhGWNwjrhOWrMTpOYc8Xt+RWWYIU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Gt/rYUi4";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE15A60018;
	Thu, 25 Jun 2026 01:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341791F000E9;
	Thu, 25 Jun 2026 01:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782352137;
	bh=eaw6Jpmx0iTU5ok6S+y/E1c+JF1d6MfBmwaE/SiApvc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Gt/rYUi41/ADyWCLCH4RZTz2Ti7dZJUzkYluG5rszO4nG6IxcZjxK2wKI3kqxG6bI
	 GgAT+8MZrvfl4Pij8t1OxC4ZJBh8i4PVRHAP6gq6L4v1PA/IDnArn4yiQq+osnsS0G
	 oEZbQlAaUOTzkuxuQ2d8MMzixnFV234reFgxciSg=
Date: Wed, 24 Jun 2026 18:48:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jakov Novak <jakovnovak30@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vlastimil Babka
 <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Hao Li
 <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes
 <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 linux-kernel-mentees@lists.linux.dev, Shuah Khan
 <skhan@linuxfoundation.org>
Subject: Re: [PATCH] Docs/mm: fix documentation warning for GFP parameter in
 kmalloc_obj, kmalloc_objs and kmalloc_flex
Message-Id: <20260624184856.55fe055b85e17ed2c6572182@linux-foundation.org>
In-Reply-To: <20260619113622.11712-1-jakovnovak30@gmail.com>
References: <20260619113622.11712-1-jakovnovak30@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6E98FC0002
X-Stat-Signature: 5rpuynhbo3s77dydozhrymsjiqg55mgo
X-HE-Tag: 1782352138-721519
X-HE-Meta: U2FsdGVkX19OZFpFKqRIF4Mvl0RD9a3WinlW3fiCadxz2hVyHb13yajd5nII5+jwk2GjbYlN45Gf/zxWjoZs+mwq70/UyhB0Ckb+iFlVWEF84K9oJPpbyjMiRWf2UI94bqu3O+7OHVe6ZBxM1JuRERpEthdbk7n7XaWLy86u5i/ANBkzhWsjZXxOTKQ8+824r5334pFZJwRG5LPp+Iob60UqF6Ec30wHS1UXzpItXpsnobXd+ZuqzlSKjswoZpGIAFHe7LZMFWq+Z+hO2eL1raHlBalTryHxbAPN6Z1H96iJ/oKQwX7nIqgzMsKVHgBzLXzAKI3+/o4c3keagTyqYFvyksilhmZeqrNlEvkAId7A9lf2azhup04WrQ2db9JkQlajXWSUBzW9P4bIDIaoU2u68GP3z849lNPbAX9gGTFwSO5d/zM7WSK3CZk80FM+5ei+Ef7t8X9LhcZoQJ2hw/rUcLE4h0JR21/U2FTrJ0Ht+4VqJRmt72DNxfOc9fAFZwtKaQCWTNYqANqZgR3U2EAxNq1ijsmb+hvDrHYiOIjyefZ5pyFYJ6kAZcZz1aKg+3mklW2BI7TuI3d36ejjzHRTmy3gs01E2sv32/A0gXswpB0oUrF4gQIgFVK5eyWZfWZc7Vp9D/F9f0GnCdJZaK+ZiMpw4Fb/41Y0P4W4pQF18lYG/2+KVxT71KYH7yEUdOU8T50yBVgKFArRSH2KxvXGZl7mTUjQ9A881CnpvptxgV3R2oORtxAZqWWjfas26XHz+3VzGtGaDVjBJuerRmMQm4HDFnHpZElQpPzC95uDC/PwDp+GOdGevcGp5kxPcm2EG5LagUJpwM6s+laix8zts2hk74pYQEq8nuDzmqXBqO7kddBByj5pU9QvpyxCmu3+5/2r5c0KPEB/bYH61a40sHL2uaVaqq7msG4qDOz3qGveI9nzm/3TwLp9AM7N3Loj0E/c+bLPccXcpJj
 TmIAEwju
 shuR4aNhP6SM9nokWT2gpr2ZFyH1o/lGgym4IHL+Uh5MW/PhqeYB2bkZzMkGqlvBqK931qXknoS34w1AfAKCdJSLqIDAdAtwOYRKDU9MkY3tEHei7EXwgHZSRMAnxHVMpxoA2Qgaf4vKtOomA/4lTiesT6zpmQbriMfmeuOL4EdZs+WJy6QuKs7fZC9XpcF416gJeFzGY5rkbZH2/rS8FaY2O4vd1RID40Y7KtkZExzXtR06iFqphCpm5VKJ96gC3sRv61BV/Rz8zs5pFMip1D9jG7byk8Y01KyNxsRNGYAsyRW7M3qVwWfyrO1e78mtc/uMC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 13:36:22 +0200 Jakov Novak <jakovnovak30@gmail.com> wrote:

> Subject: [PATCH] Docs/mm: fix documentation warning for GFP parameter in kmalloc_obj, kmalloc_objs and kmalloc_flex

Thanks.

"mm/slab: ..." would be a better subject.

> Date: Fri, 19 Jun 2026 13:36:22 +0200
> X-Mailer: git-send-email 2.54.0
> 
> Compiling the documentation currently gives the errors:
> 
> WARNING: ./include/linux/slab.h:1100 Excess function parameter 'GFP' description in 'kmalloc_obj'
> WARNING: ./include/linux/slab.h:1112 Excess function parameter 'GFP' description in 'kmalloc_objs'
> WARNING: ./include/linux/slab.h:1127 Excess function parameter 'GFP' description in 'kmalloc_flex'
> WARNING: ./include/linux/slab.h:1100 Excess function parameter 'GFP' description in 'kmalloc_obj'
> WARNING: ./include/linux/slab.h:1112 Excess function parameter 'GFP' description in 'kmalloc_objs'
> WARNING: ./include/linux/slab.h:1127 Excess function parameter 'GFP' description in 'kmalloc_flex'
> 
> This effectively omits the GFP parameter from the current kernel
> documentation. This patch marks the "..." parameter with the previous
> description of the GFP parameter along with an "optional" tag in
> parantheses.

"parentheses".

I'll assume that Vlastimil will be processing this patch.

