Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C679ECD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 20:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03A556B0005; Tue, 26 May 2026 16:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D886B008A; Tue, 26 May 2026 16:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42F56B008C; Tue, 26 May 2026 16:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3F996B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:24:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B4C11C01F0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:24:27 +0000 (UTC)
X-FDA: 84810698574.16.0AA9C9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 808674000B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:24:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0xuu54jv;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779827065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blBx0fuhONZ21syWWbL6cl6+9gKLYf6WL28E8AAD0MM=;
	b=7tOFNlUgjK3aefjFsNuwWj/B174cKr80pS4oKKX2ElpFXg8OewYmne91IxlzK28SlMqdWu
	KQasQ6FqsbR3VBovb4qrzjqr+dMpGVMA7hE3XNXV2lmxIKE4lKokOmT7aNkSWZ0eLgHdFK
	SWn0/ezzCQElOX5pSXKRaqaJF759VS8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779827065; a=rsa-sha256;
	cv=none;
	b=CPHm9kMoK5YB1/xs3K7/qi6m3XnVDJA6nXtAeMobhIbos6ly+IMDB4hYpdfiLTED2ggF6f
	KoXincFh3WX8YB5GE5iy5YofeZ1ZMWYvv0pCFmIxy2aZBfdKapxfmD2K7VOd6sGFBNT0Xv
	Xu3zsviLAgXND9zgPFV5XwWxqZ9L6NI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0xuu54jv;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D88C416CC;
	Tue, 26 May 2026 20:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD9F1F000E9;
	Tue, 26 May 2026 20:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779827064;
	bh=blBx0fuhONZ21syWWbL6cl6+9gKLYf6WL28E8AAD0MM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0xuu54jvYgA8mfdFp1X4447UqkKxvCl+l1IwkBWqQ7TYH97UlAXxIj2RZCsDZQvkI
	 yigpSJnXGWh7aGWXzvHAXC9noYWzeBjPae00bZ+Tf2bGnSuE6mfRdxeeRyXrxHFNIb
	 Tl0eay+AAgSO2SVj3DEm2ero1sIwOTnaOYubQTcI=
Date: Tue, 26 May 2026 13:24:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>, Byungchul Park <byungchul@sk.com>,
 David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Matthew Brost
 <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, Jann Horn
 <jannh@google.com>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: find_mm_struct: fix race between security
 checks and suid exec
Message-Id: <20260526132423.bb6a37e0ca145e0150a0356e@linux-foundation.org>
In-Reply-To: <ahWxQ3JxdR5ff2qf@redhat.com>
References: <ahWxQ3JxdR5ff2qf@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 808674000B
X-Stat-Signature: dquzfquutanf6qxzfdzhw3ymzcyz7gqi
X-Rspamd-Server: rspam06
X-HE-Tag: 1779827065-501496
X-HE-Meta: U2FsdGVkX1+4mT9v2XkgHLrRBIXCvwAMnP+ESla/9o9Isvcm9/YzNKZSGNKeZRHgBwmaxuNOEBaaYB4EWlI5TybwiZ/fifH7GziZwbViiSi7jX4dMqtMRYL6ymlnS/UqDh7/cYStwkopzne8qcmFZdwoAS7xQDSwtirsh5xmzZvf/QGRTyC6DXbghtEEYDNsTsCdsr1508erRdN9IWaljd0hmoJLtoDxVbVQXxF8mCBCBiPyCwZkYE5Uhe4KwXUNm2r5VgnVKhVEeUoFYxAE+Q9DzTNa+u0M9kkyDB6O1uI7GlSPD0bdHVT4+kXGGyvk4FX0zTPWP+rU6LzSQtHEz7UhQWObRfrMnklcyQ67u4PIinn+4fpheAc10/NLtvivWY6m+TlDlBABWgCnECC6xWAd4wS3cDlFn0J0An7PGFQ3H+gzogAlAb7mNk31V+uHquE3T2gWropApZOb+EyktqoAvwQ0TH68ZTFPla6yYcSh8B9K5QQ2hkp7tVMPg0UJiHZ68RtXmRnGoKq2626Fd1J86Uv8Rl9vUHxgggxwQsmUAgzK+lTzcuo1WRlxi5n/KCHT1aLk+eyoMetvmzWrXMwZY/Br9vg7BW1EiyMvrVuFEEJDCpRH/36HjV3usLu8sONXR4XSR2DxpL6wRB5viTlcug3O8KUprN6k/MU+LlfieibCIgas+NhoXoos9mlm2CF0s++yc8kHlqZhsjeLooXbwcug/GprjiMc0Yn03/lBvcHUBZgce0bbMszKRjgwzIL528y74g2OZ762FH+B1d3Q+y21LUW2plzX2mMxEGwa8T/84n6lnqn4zMlNlWeBVHplYsxbaWaCR+eJpyAKCt3UwvP0703ZC2g+gCiDZPkka3/YigVcaPok5v+oG2PTQCm69Mtf3sUDlO5aP+TXaNjHsYJlGWILdjhkv93tAeX/1KHJH3Pj9aYiRmtbDnbWl5AcV077qwOrIe+0xXR
 lw9jk+qt
 dXo3B1puMsQ0mQSgbT2ODQDJucGSX+1bNFcIcWBR3wzWC67XLjZF3jOXt+Sd3fDAT/5KvoFJbA3rJaw2JynZpwYljhuY16ljwZxvb1gEbBMCUl3Onbv3obZxvqZnkyjrpv8JXCdlEKuS4248RQwzhX3iSiB2X1UCHgvna/jE9cw9Zo/ly3rQV5MmLZOuCHJa60c+6ce/tFTRh7Eq1bzmaHaymShlqtVjWlByYpj4C13Sj2sppuGUZM1AL2b1sFcpp9cRBMMMC8+n9BnYl39t9Ap2UImqpFyAvZALzUiQWBcsx3EyQ9T4KhXDJcfT3tlUcm4l6DeciJt6BP/v4n2Nu8c9NVE0dEaRT64+UEfCY5FAD4gnGzFm1mW0kueJhkBmt0/ByUG0YzUYnFKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 16:42:11 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> The target task can execute a setuid binary between ptrace_may_access()
> and get_task_mm(). Protect this critical section with exec_update_lock.
> 
> I don't think cpuset_mems_allowed(task) should be called under
> exec_update_lock, but this patch just tries to add the minimal fix.
> 
> Perhaps we can later add a common helper which can be used by
> find_mm_struct() and kernel_migrate_pages().
> 

Do you think we should backport this into earlier kernels?



