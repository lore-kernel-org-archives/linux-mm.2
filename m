Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD53C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A7C6B0092; Thu, 10 Sep 2026 07:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD36C6B009E; Thu, 10 Sep 2026 07:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B176B009F; Thu, 10 Sep 2026 07:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86C5A6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:30:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C6101404BD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:30:14 +0000 (UTC)
X-FDA: 85197633948.17.7EB70A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 663541C0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:30:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d7aVNPj5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789039812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmh1GKz1N11M+N8xmDUZhkm9CqjUcOyixUe/5x259k4=;
	b=RvDpufcchDGYNpWQXrU6URGosIHyYOVOgiKm5m2dfs8TkPBEfnsWXrx45y+e9E9A5pcJ4H
	80Xp+ppnOzT5VYk5lqy95eOiq9pOEctI+sbigAiTJYnWwCymph1p0mncOnJIoJ4VGZXwbJ
	DqcrtRTj5vzDNtAmgdImWmGJy3ahna0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789039812;
	b=EonVI82kq6ClFFHUhA0Rj2ZBuDLIqEEe3wN0D/EgF9P+tsjd9USw/gAUPld4L09Nq4wJPH
	Yo8cADVeo0m5aC21yFm5mJPnUQ1qc1fvx3egYFvnDl6DCpsOei9ZMwiL6kFX+CZVP1gnb+
	gAQcZQrolfIZTML4TuhXjwjJa5SIvMI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d7aVNPj5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F939600C8;
	Thu, 10 Sep 2026 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225031F000FF;
	Thu, 10 Sep 2026 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039811;
	bh=vmh1GKz1N11M+N8xmDUZhkm9CqjUcOyixUe/5x259k4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d7aVNPj5I4IEFe1KJKsAvmQcC3+y06BptG1oBLhAOq9y20CRIwdceap4yWL+m1S//
	 R46hgMinxVOwvajxh0odbLxPoUdIfa58DOTFbDodhDUfbfPpFPVNI9Rr5khsA+SRw2
	 JFvbFIiuLHc7l+K6kj5aiMCUs/rpn/y3BhHxwdtInWTOBnoZ8EnO4hb/0UBJK/VVaT
	 TvrreBW2VpKUJVDOihSi/PV5MIwpGuj9B1M3YZKlGDj/t/AO0xuJ1XBfYq2gNoW5bI
	 /WgP8CAGLtb9kZfMDYMfzwXa88epd5AL4WN3hKmaqalWZF7H0NDGIE7Y0kc4uO7H9O
	 B4IjvUUQnt0Jg==
Message-ID: <9b67424d-70e5-442b-9ec7-22b1d3db12f4@kernel.org>
Date: Thu, 10 Sep 2026 13:30:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, pbonzini@redhat.com,
 seanjc@google.com, akpm@linux-foundation.org, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 shuah@kernel.org
References: <20260902194657.79075-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260902194657.79075-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 663541C0004
X-Stat-Signature: 7xrtemwyspmw8hqpkstacxtdojdexn3d
X-HE-Tag: 1789039812-453926
X-HE-Meta: U2FsdGVkX18b5CF0mlNeX0qpfnjANF6dqWVK6CG+lapU+roSYCc/EYQcRincUWr4SJqKcKb3xgtN/x7K8s3VHgFAt3QlZxGx68UIk8S99fgHT0PIMoRFs0kgWETAJ7TdzWkz8bQFpGVIBmY31hHvOr3dFX2hAEy2CgV0S59xh8Kb/sAtpdYYPqDNG4zVCpCItla+WRJS6ntEi85rJVWrhc+aoCVqJEBBNwmJ0VlKmkh+Et1t6N5VkL3qEtI56eVDN+lpUK7IqDutfJ8lDPVY/+XiakkF7kWP+ZR8CeOb1PcdvrbYSFgkTBSGmeiK6Hvoa/QPoXC2fZ89yu1iiOsx3isK0TYqwghu8VY1KHWu3rrfU2yw4n2i2TavGJ19wljvxXBUpkwpO06CXF5O9CgKncc2f2De0OS13j/v1BzajZDmrH0knXpqfLudk13Tb6c35lZ9Gn4WyKLDUNSXLTo6kdx9caSeMNKE9f9opONRpZZlcIVgOJcz4lcIezA5cl8bttC7tJFjQkeBQwHSJJpOzY6RQKxY3tJyO+LcZnr7SArM1ASa6B6wJcY17Mc/YszWUBTZwU89CGjJsxIoi5CXJTf+Vxqk+aQmwJO6R4itIyZBMxJVMJw4+JFID+hTb16aI5F8pHu2w37vZ6rulN3rZKCKraDCfDhiQmzobdIADyE0rwjnLdEuiwSxacZKIZ1c096MBkggGRMmENwJyX5AuQ3sJ8CWnh4UtPHwk3gb85rvG5TKrHnrhtMT3mkedz/DAZz/F1IGtA66HLlVMl04GSOexd6X+VdBhonwpE58iAG2/MtwrIU+U8FeF+/4ErFMrOneVkm6PvpULZ6/9MWzrV8/HcI1X6OPAa/EJLOiQHncbfHErw2bVm02PaQi/CDztoQ4Vig0pDEJ49IMQSlqY8pDPiqr8fsKwTajDsvFWbZtEn+5dTMYDH4mO9OMZCnSQZkrHY1wzheVc2F78ny
 ZT6JlMZ0
 bSYT6aKF3EmH6hBYxLXEiPBZM4Oly6zGyRb4UH0Dyud59p3dm+97ETEp5yc8g5t8UY7EP9jvE/OYNKSWPQdlCTnOM3R6KILvcARTuaP5p8riTsrHhFX6fiT4p/UxzYx7LZhkufaEvsLkLOqNZpqvsk9iGwkl/aEbaX/pIrdbcP8gP0CTcb6rbEy9W7u2iAq3z2wYswYUFj5DFux2vd5a25uOY+cNJytf5Lc1/VHEts/1AHPq7yfmfy487fBIvzl+49fR6r40k8mv4q39oBowUUaztm3zT3yzE2a7i7r+ys7G+xEtRUA5fw3YD5p6VKmF+F2ZsPMtAUdkTLI98BLGpAaE54WgSb0MDC/63iLu6Mj+kK5rKwFDazTPFrq4PjaCqfKhy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 21:46, Gregory Price wrote:
> guest_memfd allocates its folios through a per-inode shared mempolicy.
> 
> Today that policy can only be set after the fact, with mbind() on a host
> mmap of the fd. That requires the fd to be mappable, and it cannot reach
> folios that are only ever guest-faulted. Neither holds for a
> non-mappable (confidential) guest_memfd.

That looks like an investment into a mechanism we will soon consider legacy, so
I am not convinced this is the right approach?


-- 
Cheers,

David

