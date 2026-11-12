Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5617606A883
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oUjcnM5G
Received: by kanga.kvack.org (Postfix)
	id CF6156B05B8; Thu, 12 Nov 2026 10:51:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6D96B05B9; Thu, 12 Nov 2026 10:51:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE3D96B05BA; Thu, 12 Nov 2026 10:51:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A28C86B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:51:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A1D3405F1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:51:28 +0000 (UTC)
X-FDA: 85426906656.22.66F3AC7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 623AA1C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:51:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oUjcnM5G;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794498686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxBkeTu2DJirZGWSp/mREpz7BgJGoSDfzOYmt9Hxv20=;
	b=m+sbwoIbfKj0y+1mSWmR51iW+vkCPDJN9Pn2t+JDmD/gUs7/M4//RytJKPaE6zOCn16Von
	m2GTcAE3RsqF4NP5C7MXBLnwvwxYylts/DBFAlBEDtnOGPI4y1zor13brE24/TFZyN7KUF
	Yo56hemfa3wjKwsB16Eq9qlcgCvwxN4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794498686;
	b=m9gswqjB+hQVWv/t48KGtVSM5O1A39uhL4RfdKd+qWynDqTcYxDOBZd5IZ/4sQonV+pm3w
	Nb3Kg3YBo6BfRZmGzXNu3b3FvUxzoj1TcVbFUtbyrbqRhNByp/kQEeCkF+RSPk4Mwq5Hrp
	Cv6T9iV54DjF6E24IjOL7ULxAdEc7mY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oUjcnM5G;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48F331516;
	Thu, 12 Nov 2026 07:51:22 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0CCA13F632;
	Thu, 12 Nov 2026 07:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794498685; bh=jPK6Mju/7uxku40iuWsPgD5FdGQZ3PgDxQ5h5XG1PXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oUjcnM5Gf8YQG1taf3fYwINVsbWZUaLEgU5uqHHesHdt6Vd/4eFvFI4mAzQxS06Hz
	 KycnaOiVhow+nOf7GwJ1GPHykbRwuG4HjEfy8ghNtN8Z+/wrW+iBViJ3EjENebROeV
	 ykKfAeFA8BzZZnIqn16AxxVBR8Prp2xtY2VvWfLQ=
Date: Thu, 12 Nov 2026 15:51:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, vlad.wing@gmail.com, harry@kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm: kmemleak: drop kmemleak_lock in scan_block() when it
 is contended
Message-ID: <avXgd-aE8QazfR1G@arm.com>
References: <20261112-kmemleak-scan-lock-break-v1-1-95808108d03c@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-kmemleak-scan-lock-break-v1-1-95808108d03c@debian.org>
X-Stat-Signature: 134b9587au83fzbbfhm9fmj6rhkzw9fk
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 623AA1C0004
X-HE-Tag: 1794498686-333041
X-HE-Meta: U2FsdGVkX19/tZqDWPFYRFkg/6daUAByLHJj5YGzybmjEWiEZvYk1GuQf3yvQsCbuDctQFXnulru3qiUPUj8VVxnsRNe8DJz4HI1+4MNfeZkLN1GplWCpALieel4W3jW6dgueEfVY16RlF//NZas1tYnB+SEgF6oIYqe4iMHVqwGsISsw6JxHzkPy+zxTj0hBlSloENljeKtr8L4gtoFbGu4ZsclcVHMOQ282OtkRYvvOdnLHJWQQLTEQ+UXgQW7jMOtuR7p87s9Evs6UvaACY5rmP8QX2UYwjgZCxrntEM/YEpnJu2qOhfpk/EcFABkZlOP+hA4X7yOTJJV2G0E6Uakjm23cDXYNlkks+iDNzcePJw1DEc5u8Yqs0gRbO/322aB9gHspkojTftVP8JIB1pgp6ylxfahBacPI8KqfRzvbK5S/lYHSOnjobWaykfLQt8nbP659z6OXRtePIDOXIp/pkgV1+I7dL+kvoiXYPMMzBqj/P7hpH53KWQNhwpAx2HgoqsQ3QLHCnGuQfgvGufS70oCxlWrjihGKEjTdd7+JtX0VNPcm0muhf11r44at2ECvvpAsrCsESUY8WQMIs3AZDsW666hOlTzFC1F7mYVoNZIS7dGwGS689eR13SwDJ/fKnpQ/2IrsC0nuVsMMLeOBHE5VXBA/eIZo2TZOF5rcqgcZ4CsEuAEP1sOZ0tAQDA1045r4fTmoqA3YONf/9G3Lk45jgF5l16NYTrWk0kYV3TNpQgPHRuzCAvsoQx/44ALyzU1o8caCk04a1WOX5L29CcZj0jux16vF1HsLJwTmgIgyB6TH1WWug0Xaby8ccLhDIaE6VkUuEQ16g3AGxEuAk8beTkO+YapMoOZzbExnvl4BzcU2v3idnqNJCv3kkiRA5aZDSVISlf9x6RhhLAfSWZaqAPeyQyK9tm1JeX/rIS1VsA6vmRbNVbNm0aVSIbrb8Z5E8batwJSNVa
 depZcA3p
 hjGEPlT6h+dF4oUJQ3jNYOKuuM+nUx33/+KaCoCc8G5Bgl734iTjua4hGwwx52QhfwmrAbWW2Q+OAK0sxiEtGizcaj3pbyCz9aANt/J4Q26BgoqXIeKh1YxCB34LpyASJ5dbAQT2BH19Wi23sWejIUHRtR/qWJciC6sW459hzm0JUq/cLUESvkDnyAZMBqNCuxbzKIRhNxx6vQKR2EbVfNo+3in/IQ46Luwc4UKbCf9zF4BbZypI7Oj8uP8gSg69tmsNN4Z8aA3YYxPwC4QWvbaicyFS9Txb2DWDz+Q2Y65KL3e/nxAH/jsmjPDeUlUfHhFA/q+fc4POcbSHknYYXtDIdMVvusipGONnOeJ0vfOV9DcOQlG9VJ2Nueotr5zsjLQO7iJNQs8fsDrSTeu3bBuJpyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 03:48:01AM -0800, Breno Leitao wrote:
> kernel_lock is a damn hot lock, used on allocations, free, NET_RX, etc.

Nit: s/kernel_lock/kmemleak_lock/

> It is also used on the scan, so, while scanning, most of the system is
> mostly waiting for the lock.
> 
> On meta fleet, this is, by far, the most contented lock. This is not
> a big deal, because very few hosts run with kmemleak enabled, but,
> I think we can do better here.
> 
> scan_block() takes kmemleak_lock once per block and keeps it, with
> interrupts disabled, for up to MAX_SCAN_SIZE bytes: 512 words, each
> needing up to two object tree lookups. Every allocation and free in the
> system needs the same lock to insert or remove its object, so each of
> them can wait for a whole block.
> 
> Keep taking the lock once per block, but in auto scan mode, check every
> 64 words whether anybody is waiting for it and, if so, breathe (aka
> release it and take it again so that the waiters go first)
> 
> Releasing the lock is seems safe because it only keeps the object trees

Nit: s/is//

> stable during each lookup, and scan_block() does not use an object found
> under it past the word being processed.
> 
> Tested in an arm64 KVM guest with 48 vCPUs, KASAN and lockdep, running
> stress-ng sock, fork and dentry workers on 8 CPUs during five scans.
> The kmemleak_lock wait times of the other CPUs, from the lock_contended
> and lock_acquired tracepoints:
> 
>                    average     p99     p99.9
>   no scan            3.7us    <16us    <32us
>   scan, before      15.8us   <256us   <512us
>   scan, after       11.7us    <64us   <256us
> 
> The cost is a slower scan, as the scanner now queues behind the
> waiters: the five scans took 179s instead of 118s.
> 
> This patch does not change interactive users (echo scan > kmemleak in
> debugfs), given current != scan_thread, and scan_breathe() will not be
> called.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

I looked in the past of getting rid of kmemleak_lock on the scanning
path but I couldn't find an RCU variant of rbtree that guarantees it
won't miss lookups.

-- 
Catalin

