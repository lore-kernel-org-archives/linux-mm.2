Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE48CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 21:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 729D46B0088; Tue, 13 Oct 2026 17:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DAB66B008A; Tue, 13 Oct 2026 17:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9986B008C; Tue, 13 Oct 2026 17:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3322D6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:54:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2CB5A0256
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:54:27 +0000 (UTC)
X-FDA: 85318957374.21.43F6141
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id F27E640007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:54:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1URnK6SZ;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791928466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLbY2L194GuSxlWbJvMphR/amPsNZN4yp/IavVHxfYU=;
	b=jFG2GDkV3N5kg3ZtKMqQ+hsJ3KGTeZd2kUXwFDmBZaK3CR86d2Q2T0G5xTChB8Um/+EcqH
	59BjKuzoI2eERupvYvwBpVraTl2bWpJrWBcQC+eXKLarSmGQeX3kXzBhh2sIySYZ3aWk86
	90wlmix8XW6dFKrzWXG7E3yhpGdLzoQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1URnK6SZ;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791928466;
	b=cPz1tGSajvp5tgbYeGKExVmoGcHSrOpjaw4cuVQTC0Y/p3+YvIbYKoH8aydZ03yTK09A24
	S6dqUND6lQJB3RmEBQEHClxIQsa1h0xlscJjG/VHrNOF+xTIux7WWU4HBU6Tbelc3DLNld
	Oj86OdfofDL4hBNi5XqWYA7PsCtpjhM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82A90601DB;
	Tue, 13 Oct 2026 21:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28791F000FF;
	Tue, 13 Oct 2026 21:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791928465;
	bh=iLbY2L194GuSxlWbJvMphR/amPsNZN4yp/IavVHxfYU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1URnK6SZvCssZJpm7tqIDh/YRPM26motAbIWUINR/TKD9dTwdd+Q45eZi0OvBEUQG
	 0iZ2xyhwx+xPORnq5/GaoVnb87XlVDJR/RW0MS+TdH9yPpZMvseTNMhcKmqm9ieGIF
	 LSDvWbh1XKsM11BcXjPnbFpJgBmIyYqLD4XbHY7A=
Date: Tue, 13 Oct 2026 14:54:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph
 Lameter <cl@gentwo.org>, Suren Baghdasaryan <surenb@google.com>, Hao Ge
 <hao.ge@linux.dev>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/percpu: account full object size for percpu memory
 allocations
Message-Id: <20261013145424.341cb25ffdd488297bffd1a1@linux-foundation.org>
In-Reply-To: <20261013-fix-alloc-percpu-accounting-v1-1-03e788a1e41f@kernel.org>
References: <20261013-fix-alloc-percpu-accounting-v1-1-03e788a1e41f@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j1w1zi9masid4xqpru4hnc33j1tobyqy
X-Rspam-User: 
X-Rspamd-Queue-Id: F27E640007
X-Rspamd-Server: rspam08
X-HE-Tag: 1791928465-400565
X-HE-Meta: U2FsdGVkX1+FMpIWsBwJxVzHlOvTiM982gvBuSx9HKfMcZGtmeq+DwOzcjqr+pALCj1dgwfTaDHzybCHPMod8iCGU3lo522ygKYRQjA7F78krJEJNahiMJig13wO7eojHXcZbaPPjY2+4nryeNzExzTf6TDodlG626dgemcmSF/9jsqZLoKQ1W1KKj4Gw24vlGlhp9jvTn5YtFpk8KUWx9ZKg/Eejo0bOLdOJl6ZvtaFcYaXCVkMb3nXWx3Ia29rLGWJPRrXvnWaxBZ+oZF+L2pQ1b40jrEfvAncPhELxv703zr1Vzax4rkjhqd9YpHTOCPh/K3xdQ05hwUj2nrTGsvrWGS22M6Kiy8LnI3bYY8Xa6cVqODET3xV4+ujkNih5dMUYhjhHvObYrg1eEeX8lMUsWJLbO51gKQsA7xVewHpyN90h6/bVPJO5s+GVwt6dLaASDPDe2dE5U1Ky7sh2PgJZsTkwA4VcR3rG6gqJzvM++gkirf5wq5lRhgijaKWyTcgOcRSfl8if/x26RiWDNSof1ubTPnKLzSXzT7oCYcwCiX8KBe2Kps/JwG8iBDDQkO01BsfT6lKW1LvxNv4/QxNOsQHAZrCBjfVrQWnf/+Q6Epp3p+Wfb5vvjO7BADIHu1HrlU8X9Dgd7sa+5kijS1pR3Bi9eZRXfQQ6wbl8PcCFLbmjhSYpYXS16EnRFjittw2lHoenDHGRhJELipFEmz9jlRZ+uNKW9rCWIYQQBEldogb6q5OUFoWEbKd7vjBQaPxAuzh05w6UY2ZhDLJOijzJaEBnDh8dA7d5lRo1+t7lrhR1gfrLLc4BD+vaJ5qZLTgQmm8Hq3PkVTgJ2Y1/NF+MvsvCjJD5a2myQTUywIYpmrmsvpt7q1ZX7BPlKdDlElptswPL60nLDL5qRE4vL2H9wmIXjACRmJ3pAOzRETAmF7KEYHs347wy1BZuAwvidN0czAe6/2AX3rLaLo
 V7T0obsl
 JMEW62pyg+4MRdLBjvoD2gGFosxPBT3dP+v9TnMQsqnGeqrhw7hcZ8SQmedNxs5w7uNqtq+W5YR/edXjfhgltDUGLZ0DQ9392L1oiBnKubLWq5Dy4KAlulN1yaTH8V2+HLpMSqDIoei05gokNDZkztCk2gYpJFjkb0rUdTIgNFjS11iZPS8xy+zzFlFg20/XN9QVRZPv/CUSVChVaghOvtPNSDP+ALUSDzZMAl+tf4Tt09AG/VwnNMMeo8HRvWB14YQcG1tFLLfFf9UIwKMky1m+W5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 20:34:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:

> When memory allocation profiling is enabled, the pages backing percpu
> memory chunks are attributed to func:pcpu_alloc_pages. However, the
> accounting of individual percpu memory allocations via alloc_percpu()
> and friends record only the size of a single object rather than its
> full size across all CPUs.
> 
> As a result, it is often not straightforward to identify which kernel
> code is actually responsible for percpu memory, because the size is
> under-accounted by a factor of num_possible_cpus().
> 
> Account full object size with pcpu_obj_full_size(size) instead, which
> multiplies the object size by num_possible_cpus() and adds the objcg
> pointer overhead. This is consistent with what memcg already does for
> charging percpu allocations.
> 
> Verified with 64-CPU VM by spawning 400 processes in a memory cgroup and
> measuring mm_init()'s rss_stat counters.
> 
> Delta of kernel/fork.c:1142 func:mm_init in /proc/allocinfo:

Please make it use mm_init() rather than func:mm_init.

> 
>                   bytes   calls   per allocation
>     unpatched      6320     395         16
>     patched      418176     396       1056
> 
> 'percpu' field in memory.stat: 422400 (1056 bytes per process)
> 
> Memory allocation profiling now accounts the same amount of memory as
> what memcg charges.

Fair enough.

> Cc: stable@vger.kernel.org

Why cc:stable?



