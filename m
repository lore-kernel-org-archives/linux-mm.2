Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A79C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4B286B011D; Mon, 17 Aug 2026 18:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC546B011E; Mon, 17 Aug 2026 18:44:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12666B011F; Mon, 17 Aug 2026 18:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 909766B011D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:44:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25DF2A0321
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:44:00 +0000 (UTC)
X-FDA: 85112240640.01.25E0CB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 71EC21C0007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:43:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TPOisz3A;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787006638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mv5AoSo9/V0u2RCFCjv3YwIVFM6rx0xjD7lOevDqBWs=;
	b=3yujzEVnm/b74PNow5ndFXcENeIZ6pdAsEUOCRVE1kLQznYu5/Ar5243NjIpRLDTwpXE92
	8rlLlLS/5FHTeE6YfVqQTzNJ7ONm2kWroBGxu/WqTTEWDHklHYmlI4An0fIMGL9kIXMTII
	x5v4Kwl3AR3vtNKKQCjkBUsZ5Rih07w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TPOisz3A;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787006638;
	b=QMq5oM4qIK2ahQNaxPZA6phaoWkiTiJxr1oGIFFkYnjdoRKFYuIFyL8GpSa1ZM8Apz2wc2
	qlhyg8Upg6lzsyGjZNewymevWSjQ44J6QnDgbr2hlGqor7rOns9opzvxmMKU09rTXkvQi7
	Uni6KSCUEOmdljSYIMgjPkA3Dxtv+yE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A428943F52;
	Mon, 17 Aug 2026 22:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ED81F000E9;
	Mon, 17 Aug 2026 22:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787006637;
	bh=mv5AoSo9/V0u2RCFCjv3YwIVFM6rx0xjD7lOevDqBWs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TPOisz3A30UyNq8RNZ+f9HpJtnVxF51K4jyNTwK+waTu/skKZczVEKcqy9M+SqgXL
	 5ku5F0lb8G5Fn4abRVfM0aHSqEPAUBeVc0H2cKhKiT5+GAaLmsSLweLjNz7RIQVQ47
	 DAG7o8I3CZtEa8cOmb7Q4qm2UiUCODJeMxV0dKTA=
Date: Mon, 17 Aug 2026 15:43:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: prevent uncharged mremap expansion after
 fork
Message-Id: <20260817154356.552ccde5d279f6e0a9ef0ff2@linux-foundation.org>
In-Reply-To: <20260813225328.2010303-1-4ncienth@gmail.com>
References: <20260813225328.2010303-1-4ncienth@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uosyk1emrmx8btgq3k7apuqcwwiz9wik
X-Rspamd-Queue-Id: 71EC21C0007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787006638-20107
X-HE-Meta: U2FsdGVkX19pbKdL5pm2xV2+4WzRvlIt6ESAvl3qZZtxo2uJjDLphDlbfnili0Q3Qe8b2119+SoAA4iNFIlVo4A0n1sIer2rMqO2aQ+bLRKa0/Muy4zhhz4J9bYK0quJ3saSvPU/XRrJhU4/eM2AfPKjQ5o+Xq6Q97BxKNBlSsUd4Dum83VXbxFznRUxkdFGJ1hUvvu6MQ5Wl1HGrOyeg6PyNHWTEw0O0AvXH0us/Fld/urd3BHIzu4rrc6ZkH53lSyX8OBfY3EXovUH+2oP8utWvdzSqNlUui615EcuNthP4PEkendhMxdTFlxdhq/4L/+V2CcczkTb4wkZLAKMcErr7aW0NJzG73V/GCqSiPWLOqOdsnp6QnSAlg2u3Jve1k+7aqC6pSAuxBgQREy6ONcKy1c52bTY6gfjB65R8M5elMNdcWRfMdR33/7PJqazNGE1SwmokSrsAZVlEdj5bjx9+8g9xBmOEEXpTueMtGopIBGsgDKNYY+BkCcD9h9hI4LuDeLF8A/L6K3zwYkV7ZAZUpqUOE8vXOCoD+gcB+0ARjtnvmAs2+fNCn5DvoeVASebwucidCLsBXBw0qmMAn46MMQ3h8mGptaN3NCYhnQZSHVwsccspzhjbZS3qnyTUs/0/3Za81UVMebhApQJbdTC6IWT5JTTH2kfnc85pN2vh3DVcMdaDZyB+b5AtWLKXkM50PaSGeumI1HsjMX9SueMbaBLhB/xyKv5dI6v8vYIdEER+VFuPMzZ19A6RiCrtSJCQjmCNi2sZoiYheJhcmwBuHr6KiMNt0Uyf5PfWb+Lg7AuNrdWUKEB4nr8r2Yzoa4W9dqUO0jpWBD6ljUxZVaoOnCnDNwNiL4R/mkxPA6+x7kcVaqTKmWMIlSTnVto5cK2qCGIX2DY6kW6DbK3y+Qj/tYx8N1YnNhujdic5P6hHrWvKqMVnWwyJBruk8phNsEHJIhXuGLxgRRPVB9
 Zy6CoHOa
 ILRtme0eeaPci/6Of8p7H7bsehYl9H7rqlf/vaEnE9Y2qxZ8t6rVt8Lzgf1x+hD6EY678Z909W1QSY5FQmd2WVvvXprfB39wagvT1+Sd7Elpc1Mf76Wc6rjl3pnpErhSozaQKAhSt7Z0M0fH0zr7+Y6esjS70VX8r0uxXbVZj9/ckjHlx7D52O3tNVEEH/Obywz2sd/UpmolXR2VKBcu98k3KIHJ0ERVFC82LnPKyYnQQ9ZtJtY0dBLWsO4YsJ0EYG6SX6ckI5cz4ehYY1HIq5rHuVSSQwTvzP1cK7Qe/eOLKJSeyW2UDenPNT7EI8OqAQoR3TKliHgaD2r1k4ExuaHs45cV0yripYaTmnPiJbg86B90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Aug 2026 07:53:28 +0900 Daehyeon Ko <4ncienth@gmail.com> wrote:

> Secretmem mappings are charged against RLIMIT_MEMLOCK and marked
> VM_LOCKED because their pages are unevictable and removed from the direct
> map.
> 
> dup_mmap() clears VM_LOCKED on the child copy, but mremap() uses that
> flag to decide whether an expansion needs a memlock limit check and
> accounting. An unprivileged child can therefore expand an inherited
> secretmem VMA past its limit and populate the added range.
> 
> Add a VMA open callback that marks secretmem copies without VM_LOCKED as
> VM_DONTEXPAND. dup_mmap() invokes the callback after clearing VM_LOCKED,
> while the original charged mapping retains its existing ability to grow
> within the limit.

Thanks.

> Add a selftest that verifies expansion of an inherited secretmem VMA is
> rejected.

And that's a nice touch.

> Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
> Cc: stable@vger.kernel.org

AI review might have found what appears to be a related bug in there:
	https://sashiko.dev/#/patchset/20260813225328.2010303-1-4ncienth@gmail.com

Do you think that's pertinent to your fix, or should it be addressed
separately?



