Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3683D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 12:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290A66B0088; Mon, 29 Dec 2025 07:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247856B0089; Mon, 29 Dec 2025 07:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174446B008A; Mon, 29 Dec 2025 07:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 048F86B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 07:32:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B18971A6536
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 12:32:26 +0000 (UTC)
X-FDA: 84272446692.03.16346FF
Received: from sg-1-102.ptr.blmpb.com (sg-1-102.ptr.blmpb.com [118.26.132.102])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2745CA000F
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 12:32:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WuZqxcWs;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767011544; a=rsa-sha256;
	cv=none;
	b=sfsiufKfJcwIQRE1JyWMSlPz0E+15thr3Szue9MWAof62XZ+qwOZKfN+fzZAbR2OuSsTQ6
	mv1i9Wrm7ZNm+mFpXkskRL/OFslxr3t/iNQ+MM2CJXdwqZQKpe0BN//dRwfvfBHYPBsPWL
	/QJhZyv/2/c5yUel4tEuMr8RvmRAbQU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WuZqxcWs;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767011544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4ciCLYxJpkt0+6+Q4lY4Pw69hjdYqXiZ08i183ZErc=;
	b=baCW2rzH3UP99tuCUW4fx5KKBypVwSTfD9XhJHw2Gd4X21trKS5i3fpVGP/VSSmGYRdNTP
	xm9nfBg5NUtGRz+b7sVTNyhf1WN36nGm8o8nCkhGmQFoOuYsYiHfLszUwSQb+vtFLNFFCj
	svm1f6R2vHFyfB6+hXW4h0+Gea3ZIT8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767011537; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=M4ciCLYxJpkt0+6+Q4lY4Pw69hjdYqXiZ08i183ZErc=;
 b=WuZqxcWsXgpmxVtQHA088Bbz9tDw7fu1cwxx+6AuU0koAN/FROHqKZKFgX62gJvwmkQkfL
 R3nTzNO6EL9dTTTcQQpioMxQj2cY8ykg+l+hK4Ehy1TARtSNJ5FmLaUXBFcyzIYFmLkXty
 CKPH9oaa1kqsIzE1FZ7gtGhU1DlPds4ZZN2GJzcmFcOZrpN0Ji8rmjQ6WX5UjMiGS68RQy
 o1zHuvsn/SKBchhrqI+h0suUvthX53vcqQSmbH86Z5ln93lmXCFzhZ0pw3Tczq9C1Yqgv/
 eiRKfK/0BW+u4rHZOahbGjLq+shnclkK26oRmXlnXogFEu2mo1tP9t9g5T7S5w==
Message-Id: <20251229123153.7578-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+2695274cf+5210e0+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <fmuw35nyxafum22ni7ozhybjaarf77baqq774czok4k6y6eqqb@4oabqflx7ryz>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <fvdl@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <muchun.song@linux.dev>, <osalvador@suse.de>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH 0/8] Introduce a huge-page pre-zeroing mechanism
References: <fmuw35nyxafum22ni7ozhybjaarf77baqq774czok4k6y6eqqb@4oabqflx7ryz>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <mjguzik@gmail.com>
Date: Mon, 29 Dec 2025 20:31:53 +0800
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2745CA000F
X-Stat-Signature: cm4433oyibokw496krbpwhdfzfzd8f79
X-HE-Tag: 1767011543-805409
X-HE-Meta: U2FsdGVkX18FFZgJGXTfFL5+Wz3ckBHNIAd1YRchnIT+/2vfcrUrVBjn6j4GuDoU62MmVsGqQfAZ4IQjt8zr0xNzgAcax1vOsrhhIUl8Sb3q9oGgQPFtJyUr7SMYBJPEewSxYNFYgeTi3muHlVaxOQ7Y42PQz4CnzXPRBk2z/sJZj0Gy9fUqyOq602OuJ9ewxtnSds4FpSvSUh5bMAhS9f66mY+tRlMkBzaUTJtBhubH7BKAOO+i2+VAM8370OhQ7ksWceMuwmVWqTmAjueQUjYaNvNsVaNYce8VUe1h0Ive36SghWxFom/Fj+bhq5oPS3aXHtpn9pzbMNnOKRVTMfPNxA1KmxpgJCgAFzSXlSwKF8qxHpXxxpgCnfUEkebbCRU47g3vxQiAjZHWgg2KhSY/WArK7xdgVRDWqomrjhiGmQ4Piz6wDHGo2XxcYDsxIyH0ehpzl852V5rUc0seDGN2Hjf0j4F6/7U8zIkOEG0+GfmXNv72+S/TvccXomoq70omn0c50gD6tszs8GjKWjTWoWWc9VKIlmcRHJlOFX+5QUHHR6jGqxvUEPFKztEI+UzROzmebD8Z4FvIaqm9mJSW5QYWhFHIphRU8KepxQFwZlYJpRcbrQdkSbD+kpzUVKmpS5jevuBTG+AG+ZNGSpCO/SSFutCeKxlCRedQo3VQZUUXxauYm53RfhrHg0Eslh5q6EsSu3xop427HAcs1tRETgSlBicbmqSWcgccY3aMkr1Ono1f8nqPrIDQtmn1BB6RiLkY4vUn75jMXZYG951BzN3/DSFQ0UjKWfm/PWb5ClKd7VR3HE98uGNsdyim9Rh2z4VKmDORHtdBKnLVZc+cowwq5aYqi+HKF0Dy4MVTLLr5ZX3z40GZqLIrnblCzyCraX9Gy92aWZ2IMDW5jqwx8Mz5KYzluMGlnAIZfWhYBuO5HodpR8YcxXV4Np7AUwPsCe3C2bS3YWZ/6tz
 bheCb9ot
 +MYIgBfazY3pS6MDzaMKzAl38lYsEEMPfw+e9eXeRUsJsdHa7kf3ZiZbEhnBWFRhtG0bFYlghrwGdGnj3UIjf6hFvVyEi1No+HKNr1jNJmvpdRzZVdsUNkUQHzcYRjJGNxJcNs/JU1rfamSA8FYRH+twBXa3RPcXEq+iKP0EVQsPQuPkqPAaJR/P4ZIaxVYe0XoQlvbRRmnwNRMsNPSHrCXku6GZyrEinWnywowOrp6SN+AF+sWwPgFPBE/Eid6U3LaQU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Dec 2025 08:21:16 +0100, mjguzik@gmail.com wrote:

> In the name of "provide tools, not policy" making userspace call the
> shots is the right approach, which I advocated for in the original
> thread.

Thank you for your endorsement!

> I do have concerns about the specific interface as I think it is a
> little too limited.
> 
> Suppose vastly different deployments with different needs. For example
> one may want to keep at least n pages ready to use, RAM permitting.
> 
> At the same time it perhaps would like to balance CPU usage vs other
> tasks, so for example it would control parallelism based on observed
> churn rate.
> 
> So a toolset I would consider viable would need to provide an extensible
> interface to future-proof it.
> 
> As for an immediate need not met with the current patchset, there is no
> configurable threshold for free zeroed page count to generate a wake up.
> 
> I suspect a bunch of ioctls would be needed here.
> 
> I don't know if sysfs is viable at all for this. Worst case a device (or
> a set of per-node devices) can be created with the same goal.

In my view, the present kernel framework does not allow an ioctl
interface to be placed under the per-node huge-page directories.

The functionality you describe appears to align closely with that
offered by the cgroup.event_control interface in the memory
controller.

We could therefore introduce a new event_control file for huge-page
events, following the same pattern. Given that all huge-page
attributes already live in sysfs, such an addition would keep the
interface consistent and avoid the extra indirection of a new
/dev/hugepagectl file.

Thanks,
Zhe

