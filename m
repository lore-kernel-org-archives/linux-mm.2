Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF90C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368DA6B00F0; Tue,  4 Aug 2026 10:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318F26B00F3; Tue,  4 Aug 2026 10:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231AE6B00F4; Tue,  4 Aug 2026 10:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0000A6B00F0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:33:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8840E801B3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:33:43 +0000 (UTC)
X-FDA: 85063830726.29.5AE1327
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B5569120013
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:33:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+GRNG6D;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z25blQOuYF9jGlFI+RLfaNTy5Rh0Uq97u6eq7NUTIQY=;
	b=lLla0Co0HzwmBj12QaFZxVM0jWfGwhnngfHFdgzXXjese49dEF8xz8sgQieVLMAZr9IzaJ
	qZuesaACouKRh5SPzNsCP0vHOJND0uGFZw2cAT19T4UL2/dPG+HQuY2/YvroWkVwEVkfps
	5/3wsHDwlog0wjrvfpUvyuglGttF4AM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+GRNG6D;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854021;
	b=zS5X2JVf7bf1F0TmiW2JIQJ9OB4yqTvVysAlJQr6mQaIxEs8+nxALOLk+wS0cOG9JQd86o
	tVWw7NaqE8jX9ji7UoGY5Kmq8rE+TDtEcR5XtUPNDIMZmPgqpaYWmRCU+JYl6Mn/r6q36u
	PlEd7XwphoDRWcnifhdbizbT9NUlkzg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC57F413A5;
	Tue,  4 Aug 2026 14:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB4E1F000E9;
	Tue,  4 Aug 2026 14:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785854020;
	bh=z25blQOuYF9jGlFI+RLfaNTy5Rh0Uq97u6eq7NUTIQY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d+GRNG6DDhHNGtZ8fM9wEv5gaCdrxZmgQgJ68H+PL4UkPJYkWahp2hHeXqj+J0fF0
	 Tm2WIs4m6X3bfJ+MKgk3lWTwaw8uYTRVwEK+lHcBiXoBkGZalooD3m2acLjeuyC/o2
	 i5r4c3yYgN9GucSw0HQLvwwRUSmN2oEp6H1EYfdT2p9C6NfKFy9On5TQpdkv5drP3u
	 HfZrsqudqDs/SB8jlE0+LF91YOesfNou8D93lVY0jl+q/w2CdsbgeK0h2IZuLBlnlZ
	 62bLZRpIS29z2XIKOx2H/US7L1eb+4QDFolYiBjvnzLUzrUemeDpotTfprevLpbEg3
	 pGcPMHZg9d9Uw==
Message-ID: <de96dcdb-f981-467c-b95b-262f70f95d23@kernel.org>
Date: Tue, 4 Aug 2026 16:33:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
Content-Language: en-US
To: Joel Granados <joel.granados@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Jianlin Shi <shijianlin11@foxmail.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, ziy@nvidia.com, linux-kernel@vger.kernel.org
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
 <tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com>
 <20260801114434.232c97a74d9616c43aac2456@linux-foundation.org>
 <f983f6ca-7d45-4316-94bb-8b4d0fd58079@kernel.org>
 <k53aljpl7v7naqs5fj4i4po6tu4grkzu5nui4h37orwt6v7bqo@sw4frf2ystmi>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <k53aljpl7v7naqs5fj4i4po6tu4grkzu5nui4h37orwt6v7bqo@sw4frf2ystmi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B5569120013
X-Stat-Signature: o9a9t5uadhzsgurfpa7k95sgu1beon97
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785854021-13372
X-HE-Meta: U2FsdGVkX1/UqkTKtQ6b6tqwtKFGko0z07o3wOStwX+/gNkMBSmOdtp5m1WOGcI8wURnVzQkrGFDOQd8t54XC2p3jCei3HJ8aAJYSglv56WEZE1hJc2yurmH31Dl+Xl0YCkc6ebaXcb8sXhbwkwvhJO16zskfPCXwmCnOfjLU1ADlG55MY2MaSHz1+TgUBjtwWyRPmJzpSkNLuqty8eY7JrVm9tYdpP5z6Ofp1r+SluXywl24G8xnEaiN2M9ySE2mqEU+7sWjrUOtRzFNkkyI1LloL9QmD/pWq07kvL03V/UssKT8gqW8CbWSn+Ve6AkweCu0aJarZnbnFTbZFiGF5y8RPtCrkYK6kPlPF/PMQqn4nJjfvi6rL7wENPrDrvuavzzNVSH7v/s56hTTnf/TfVRfXh1dUlFw00GDDjTKQCof6FbM9N2eUggGUv/w4vNh3+cOufZso8zwMEYA4MeAcP4IpvID2GMDi1I3IFNMtc5B/pdwzczoVnUqpOV72YeKev/+Si45/nuXG2+c32xD1EtYx6gTTg4CSy7QGIwH7wbYw8nSuMz8c+4ivCP4tGLBDHY9sn8yYeuxU37DcJpjwoKgiTia9R0ZxFPNXvHMClrPs1zbuF99vxhKGMoplIc4I+A840FxzY0D/GmuPW1ex+MjzPSTqMsFGnF8BHv074jp7idsuIIXDbwqKq+HzY/TChzBIKlKR+olzMmcWC4kL4FDzudH5fyrBhoj1txDqFjtc1egKD+iT8BBuoT9IbVkxpQs693KRvPz6b6ud31wJt72ZjFgxV5L7XMBkBX3cLNvxHAZr0yRG0SfL31yRGT5Y7VQgRyL0fGsJjOqU3HBqGc524QU767U1UCTml8q8lTWxbvoiWkHlM0cA3xbKwAz8MauRbEMTwhUuYVewPXbF2765+4vgRU42PbQsYyViP5fZ+Ry8wjACtUEvf6apqULk5lOKmEMjiA4lCa5fH
 Gs4bKe0V
 zGAHP9qwcydFFMuEZUbIZn4oldFbOip3Ag7LNrf8dnyaK0ZmRtsOB+FNJMqtEli9bftNhCvkMiVJ0yeCrsovp1fS+d/klESFCxZejPo5Ow/LxKUwj4pf0lPOlUL8moaxr1P3qlblDFGSE5Nu7FewEgYHzjFrnvi7P0fyNpJxSrhB0waVxodcsaRcqCMMzDyLsuBMFZka1b38Ue+fiIyvH98vXIZ0266y2woz82pACkoI+FD5AMLsqj40K6C+w1FKWxXpck2wfnh335AQbd0DjIcnhFV3MZgAEXhE2yXPITJz5+QQ2b03aIcHhh2qghEhdsXGcxPHkYuc4pb/F4eQwNVVCX0C6vu0pBzfXVacIbQRiJJl0EeT66C9Eny2uXaOXV6dh2eYw4A8wVX7oVanS2RLjzItFMMpxXJp00VOhjOJASb1ogtIu7KBCODRkBEtDBZKk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 14:20, Joel Granados wrote:
> On Mon, Aug 03, 2026 at 10:27:46AM +0200, Vlastimil Babka (SUSE) wrote:
>> +Cc: sysctl maintainers
>> 
>> On 8/1/26 20:44, Andrew Morton wrote:
>> > On Sat,  1 Aug 2026 23:11:25 +0800 Jianlin Shi <shijianlin11@foxmail.com> wrote:
>> > 
>> >> lowmem_reserve_ratio_sysctl_handler() ignores the return value of
>> >> proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
>> >> even for read operations.
>> >> 
>> >> Fix two issues:
>> >> 
>> >> 1. Propagate errors from proc_dointvec_minmax() instead of always
>> >>    returning success.  For example, writing non-integer garbage to the
>> >>    sysctl now returns an error instead of silently succeeding with
>> >>    unchanged values.
>> > 
>> > AI review suggest that this caused a new problem:
>> > 
>> > 	https://sashiko.dev/#/patchset/tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com
>> > 
>> > Not sure what to do here.  Perhaps pass proc_dointvec_minmax() a
>> > temporary then copy that into sysctl_lowmem_reserve_ratio if all
>> > proc_dointvec_minmax() returns "OK".
>> 
>> Seeing the v4 [1] it seems easier to keep the current fixup code until
>> proc_dointvec_minmax() is fixed.
> 
> 1. V3 -vs- V4:
>   I would prefer V4 as it actually prevents the partial write of the
>   vector in case of an error & returns that error back to user space.
>   Whereas V3 returns the error back to user space but keeps the partial
>   write.
> 
> That patterns of using a temp ctltable entry is seldom used but not
> unheard of.
> 
>> 
>> > But really this is a flaw in proc_dointvec_minmax() isn't it?  It
>> > shouldn't update the table data until all the data has been validated.
>> 
>> I agree. What do the maintainers think?
> 
> I agree. The arrays being changed are not too big so we can easily have
> a staging variable that that gets written when all validations are done.
> The only "con" that I see for this solution is for when these
> proc_handlers get used with temp variables; in these cases we will be
> staging an already staging variable.

Maybe have a variant of the function e.g. proc_dointvec_minmax() that takes
an extra parameter pointing to the staging array? That way the caller can
allocate it on stack according to its needs (like v4 does) but there's no
fiddling with a temp ctltable entry. That way the core code doesn't need a
staging variable big enough for everyone, and users can be converted to the
new variant, and there's not double staging at any point.

> I have added this to my Todos
> 
> Best
> 


