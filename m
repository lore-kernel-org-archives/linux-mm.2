Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71216CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 00:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B696B0096; Thu, 21 May 2026 20:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5216B0098; Thu, 21 May 2026 20:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2F86B0099; Thu, 21 May 2026 20:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76ECD6B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:14:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1F1840723
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:14:57 +0000 (UTC)
X-FDA: 84793135434.03.EFE5391
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C35B1C0007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:14:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PpUMZHIp;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779408896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E58V6pPlsJLWcNEF4SeWKytMRUR3ac3u30rtpH9EvgM=;
	b=asoQ1qjdRkDy9bIZr/+gwcHaxNbh5VzhOJN9GGOv7p75/CcvWqojXVI8YijW7heBIa3bX1
	NYFAi+pWUMgnKlDsrDpddGRM3lc6aCBFVhYjGaooNh5UL8YPURRR3b+Kaqw1K/ZCi8LJq4
	e0xAsdDiSXhP9gMFlGZIAb+3V040HWU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PpUMZHIp;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779408896; a=rsa-sha256;
	cv=none;
	b=ZlHXdEojBLW1CYae7FxtITQSNxVgWNad1xIbb+RPuQgAZI0gBuJNWq3HC0wwgLiWSblePg
	eBwsDJsYdbNWGmDKvQmT7aGssyKgmJg6KGf+ea0Ce19B+TBU9D1pAo4DwBrjX5W8x2vzeu
	LWu7Cm0aRGctW4mvs//1Qyrhs2HUJz0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C07C360122;
	Fri, 22 May 2026 00:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77CB1F000E9;
	Fri, 22 May 2026 00:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779408895;
	bh=E58V6pPlsJLWcNEF4SeWKytMRUR3ac3u30rtpH9EvgM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PpUMZHIp4iHxmimKHo6fhve6bJMUqOFPIGWZw6k30OUBljIH2D2Yo6K9StgdreHBS
	 +uGCZ2QmP04gZdn98kAx9CQE4qM8gBgORSWlBASmtZDHJPfveUiwq4I0rIVTNdUVF+
	 Ev5hUkweZqg+0w3EB4oZZdsQuo+O3vYtgbfV+c9Q=
Date: Thu, 21 May 2026 17:14:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan
 <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v1 0/5] mm/shmem: optimize read with reduced xarray
 lookups and folio batching
Message-Id: <20260521171454.02e35e71f999672518087037@linux-foundation.org>
In-Reply-To: <20260520101538.58745-1-chizhiling@163.com>
References: <20260520101538.58745-1-chizhiling@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bxesd77tn9ddr4e3ia79e3k8czcn5mrh
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C35B1C0007
X-Rspam-User: 
X-HE-Tag: 1779408896-534836
X-HE-Meta: U2FsdGVkX1+RUOtJG8oGUAQ63KQmiG+ofRYS+gfjMKsdTSIMsWSXrKHPOU6yxe/cUvnJCMHIFcP4qbEMsKmu2BP37COp3N5pQty1Sab0AMiIxmkD0fUzdI4DCTQzIvdlD3Bl18oFCEeoSZCpPyKtSdrzBexuH0sNdbtqOT8Cl1ygLGmqfok+JOmDg7X3wZguP+ODfbO0z43q6+oNWDZbRFT5ZkAkQV7GQ69PzQb8//4jC1lSsn0I3OXHLEImbxAJc0qqdh5lloWptin5IZTOHZmDuSL3QQxrWX3uNtbtDpLiYdZrycXZZg5rN+BUvBcT76WsNitWnf1N2oPI/oAryukmC3k8fysQgvktsgImVqcmQ6AllQ+ur6c2NPDXW1uNa5vgG9DIqnESXuajAlUBIQ34GShVVmLVT1pXzHn2UN2z+IggyAqKU7g+nyq6cMORRxBlB2S2JkfPxOeVissEXIYMgMA29eT9aUdjC3I5fUHsNIqdha7OIaZ5+RsyaW388zC3gw1rMlPCTdQaRryUs3ZAnU6VYrrYgzOxdRfvBDn7W7qROBUgJetkmHw3z3ErSEDTJkUvTqsEmWrVjMhaZX/93n8gL05I7VFpduXdcSVzxwLcSrOMb5i/Dmu9szyp8sXfPqrI+FjBh2h6pBZ4cdhzqvLIBbSB5YTXTrsLP6f1gYl5yiUjU68yb/nFAXoFRKB9LDDNrPwTMtPqOnAchs3GJKiPYrNvTtOAdOdhyIqWlbFNbz/Br8Ul3+m+YY4TOy/xolk2SRfw6F28Sb3Slk6nuC4EWS8fko/r/v07qaAMlf/0DlSoQbGmE0yIvwYvt+TNVhhD7pti/sf08XdSWOLGDpJydKD1q8gNkWuTpG8brDT5UHaePRqHp+hEBpOxhWD5pHl4aCZuaxVHwn8vLkZOxEAfzZy4bgB/h/k4g0qCmNQX035HH9TOB/345X5/IIUg50y+GQbKrdqeuMK
 SkzuSwJb
 yzTNwVSD51BWHPoS6Lo3r0kcwHN+Af0emldLNItPuyMYBPh6x66xqeX0qlsdNfyFst4C7m40/XW1u7riadj1s3RvLxFc2J033289kP62wvcCBJ2h9iEKNSZ+nG1llhJsupH9OpKNI2Zstea1cpPdKMT45JT6e3WSaaeiZ/jCbqszEe7AivWHd0mQjqx9OXqPQnJIy0Gd393g7IpoARAOIrK0bFcROxvndGWKOjA3ex3o8Bh4KNn20ZofXEqRmQdkVsvto+7A/30fasD6x0SWvZRIYk5XawkMnk0nYOuoSMoKqvnrXJfsTo80Onk/0Xb+Gf8r67ZLMGBdq7+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 18:15:33 +0800 Chi Zhiling <chizhiling@163.com> wrote:

> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> This series improves shmem read performance by implementing folio
> batching in the read path and reducing unnecessary xarray lookups.
> 

Thanks.

> Performance Results
> ===================
> 
> Testing was performed with fio sequential read workloads:
> 
>   fio --ioengine=sync --rw=read --size=1G --runtime=180
> 
> 
> ### THP Disabled - Normal Files ###
> 
> | Block Size | Baseline  | v1        | Improvement |
> | ---------- | --------- | --------- | ----------- |
> | 1M         | 11.4GiB/s | 12.7GiB/s | +11.4%      |
> | 64k        | 11.2GiB/s | 12.2GiB/s | +8.9%       |
> | 4k         | 3809MiB/s | 3838MiB/s | +0.8%       |
> 
> ### THP Disabled - Fallocated Files ###
> 
> | Block Size | Baseline  | v1        | Improvement |
> | ---------- | --------- | --------- | ----------- |
> | 1M         | 23.7GiB/s | 28.7GiB/s | +21.1%      |
> | 64k        | 22.6GiB/s | 27.0GiB/s | +19.5%      |
> | 4k         | 4668MiB/s | 4678MiB/s | +0.2%       |
> 
> ### THP Enabled - Normal Files ###
> 
> | Block Size | Baseline  | v1        | Improvement |
> | ---------- | --------- | --------- | ----------- |
> | 1M         | 13.9GiB/s | 13.9GiB/s | 0%          |
> | 64k        | 13.4GiB/s | 13.4GiB/s | 0%          |
> | 4k         | 3818MiB/s | 3836MiB/s | +0.5%       |
> 
> ### THP Enabled - Fallocated Files ###
> 
> | Block Size | Baseline  | v1        | Improvement |
> | ---------- | --------- | --------- | ----------- |
> | 1M         | 24.1GiB/s | 34.9GiB/s | +44.8%      |
> | 64k        | 22.9GiB/s | 31.3GiB/s | +36.7%      |
> | 4k         | 4721MiB/s | 4708MiB/s | -0.3%       |

That looks nice.

AI review might have found a few things:
	https://sashiko.dev/#/patchset/20260520101538.58745-1-chizhiling@163.com

I'll skip the patchset for now (unreviewed v1!).


