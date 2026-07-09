Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 758E5C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C4D6B0088; Thu,  9 Jul 2026 03:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673BF6B008A; Thu,  9 Jul 2026 03:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3786B008C; Thu,  9 Jul 2026 03:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33EB06B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:55:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B09A040458
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:55:36 +0000 (UTC)
X-FDA: 84968478672.10.7278ADB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1E8FD40002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:55:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUpGjVAZ;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783583735;
	b=o0w0SvpeBqg97x8PhY7Dv5icX9W1a+r0mdPnc+SUDTEszUdcUQmZjnUtx/E3ubyy7tLgYV
	ZPFIWithyAfimeOydeS3hs/D7zVZqOM8lYMct/msHpqTHsFhmNij0a8ztScHL8EdETSLwA
	N64wnI7ALPLoqiF/4Z3QxBROCO3mljM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUpGjVAZ;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783583735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQr5EKbGqBU7SqYZBqewZ3ATW9dV1SlKrbwDR2ZWZwM=;
	b=hbekDS0CkNSSV4fDdVLkOVySFIK5jSsO8rE9VZwAg2+2FVSjTQNlYPC+18GrVdS9q0Dkxb
	nNiylZlDACmK2PXe0536HQ13Qs+I+xur+QsCKggACKLBZeb8z+S7ZcdW+WheQbMR1FZfQe
	eR8NiTJQDw4vH8Aq7DKzc9XvWJJ+cfI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CB904164A;
	Thu,  9 Jul 2026 07:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71671F000E9;
	Thu,  9 Jul 2026 07:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783583733;
	bh=tQr5EKbGqBU7SqYZBqewZ3ATW9dV1SlKrbwDR2ZWZwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LUpGjVAZo1MO8zeFG/Z6IYMu8YuW/ginCOWmKNGImLm8Th2LIGmXx6RrDftL6sNdu
	 heJCOhuSXdsPtomgakgVce2LevH8ufk3xANbNhHpGuf1/ybU9ylp2NI+3asTfFxM6C
	 H9H8AD8K8TEPLuvIMgq6zFHJeExBWdk8x8E+15P1WCf//qeh+zG5Lg98l8N72htt7t
	 EKzpKupmZll1CQ06ykYOpbFtZBEf/WI28jojp0pZsFRsC9Fk8d9PyAJXlTLTVEbtAk
	 42+7lyc/DoSwrbcMOHXW1A0VKmMXPaEi3t4d/qSvmkKMq81NeXdRrIAo1LtN/r/Pdx
	 aMZUvqrnvCGKA==
Date: Thu, 9 Jul 2026 10:55:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, peterx@redhat.com,
	david@kernel.org, ljs@kernel.org, surenb@google.com,
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com,
	corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com,
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com,
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com, kas@kernel.org
Subject: Re: [PATCH v10 14/15] selftests/mm: add userfaultfd RWP tests
Message-ID: <ak9T7boe4-5YAsFX@kernel.org>
References: <20260708111417.173443-1-kirill@shutemov.name>
 <20260708111417.173443-15-kirill@shutemov.name>
 <20260708225758.0c8bcf16598f82d84ea7f71f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260708225758.0c8bcf16598f82d84ea7f71f@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E8FD40002
X-Stat-Signature: fjdsj1otgjjbpmm76ghqzswstcxa4agx
X-HE-Tag: 1783583734-256981
X-HE-Meta: U2FsdGVkX18XVq7HUpzB/S8dCKSn15FMLNJdI2Lpd0UwMKOvNRljKwEQtmwKfr6vE8tVAEk0XGWBYBCiYaBwi6eGxOrJ/oDQvbhJrPAfb5GPf4cb/1YhItcOZtVtdbcTlvpgws8EsJlu1HRiK4VcndHsE51wzzVHeCyVRE0LsKjWsyc6ZDGikli6PqbQX6EBIAzvfiq00VArCEdvMaSLmi5CSzXgQfK6/jGFZg3/CentxrEZz9wxsz3IIn3DD8sPr73e7nagjSp5gbmGiwGVJovZnt+fpgnR9/Mafj/+fgVTqRquctoFC1FKbZmJqQ0lEcc/xqVq6/zzTB59ddfiv4C0u3Ogq1u6zeOUtLrH3Icpr/g6ablKBZijVeMVcztQwhM9U8ssqPDBph8/vKkTKAg8oQ1hcXA20tK/xpwQrnAJHJltCZMgBoMSvicMdMn6GBZMsHUcwf1N4cgqMtQb217WzdSLk5diTLGXqxHgK1zfTVrsMeylJRovwpRXz+WLr5mWndX1y72lgmftPPMhqFyBQVGrVujEc8BH2xzsnDPtyt/pbUEr1fu74+z9rI775iJ1t84J0Hyeh2TcztYPnZYEHOgKW6kOYbNaBxTQDLrEDRLL9RtBwn+cKOhZg+4aIER0nUSitNdMWcV5obxROGXOWBnS441bpzcnnAmBfhpo5QM39Aj7VFMtS+Ids1Sv5PNz/bEp3M6Y/M6I2qjg/B3hmpoDu5wWDF9uP75gMFqlE5uyHdz85pUd81Li5HFvVsTopX4vJe8bT3vr+siHxsCBLl2wkinU883tbfN77FfIYVAneuNQ7wM/xLgQk7K915ge/Belk7Uv0h0+pwNpSWuZGIy2R0VnBXF4SWUL45XXNNNL07xs76aW6YoW5kAip/Zagc5FhWMPQ9qjeRqnRfkwxxC0jZDURnc0LdPbpysrU0HNoIJ3NmPjpd/BQFjEyPzIitQyeTOv/lzW0jM
 ZbqxAOg1
 u7n7QG6hJaf78s8Q/BN3yGSd4Ymde4SmxxG9iigTbXS3QsDW12n1cX3sfhG0UDfmqKO3mHMlXsP+7ck3GKllgC2QKhZ1p8jH99g+HEd1drC5IYf0IjZZu1YRORxkd5WIhra9S4wGHbHI5y1P9iZ3tqUggjVuQlMAtQe5Q1JQ8Ng75bYEqi/snnjB7v2kmEr2o0Wmtg5zSnzNxIuFTEdoFPeEotdULZNugqQNb1WgBs4JdoWRBACleE3P7BJgmgMi+XKmXnktPn/AG1IL8wsgleBMMYYJLb8HI2uEIdlXWFwFgXG2ZO0YQk/nnPy84DuDODE762V3gJLr20EUBncU0wMTFMJjzaoP0T6DG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 10:57:58PM -0700, Andrew Morton wrote:
> On Wed,  8 Jul 2026 12:14:15 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > Coverage for UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT:
> 
> I'm getting selftests build errors:
> 
> uffd-unit-tests.c: In function ‘uffd_register_rwp’:
> uffd-unit-tests.c:624:25: error: ‘UFFDIO_REGISTER_MODE_RWP’ undeclared (first use in this function); did you mean ‘UFFDIO_REGISTER_MODE_WP’?
>   624 |                 .mode = UFFDIO_REGISTER_MODE_RWP,
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~
>       |                         UFFDIO_REGISTER_MODE_WP
> uffd-unit-tests.c:624:25: note: each undeclared identifier is reported only once
> 
> <etc>
> 
> Seems that tools/include/uapi/linux/userfaultfd.h needs updates from
> include/uapi/linux/userfaultfd.h?

Hmm, I wonder if it should be there at all :/

I thought userfaultfd.h is brought into selftests by make install_headers
  
> I'll disable this patch for now.

-- 
Sincerely yours,
Mike.

