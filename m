Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA214CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426316B008A; Fri,  5 Jun 2026 07:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D63E6B008C; Fri,  5 Jun 2026 07:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C56C6B0092; Fri,  5 Jun 2026 07:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16D756B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:35:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE12FC3436
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:35:48 +0000 (UTC)
X-FDA: 84845654376.22.4A68181
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E4AE4000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:35:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SK3RXkPY;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780659347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7BVss6j6kOZoY1G1bBrjCYbl0PQn+LeN+QUqhUy2Gk=;
	b=syOiUPT+vW00CiXEC94qmIgPS73V8oUXQYuHqK++IkoNDq5dJetF581smFs7/opmCt7MtQ
	iwm9GUJoGK46Vqe7GcFOUJasSgh/5w4xm8NoWOhL0qPS8cC33DWDGkQ5VZ5S8riUC7bfQl
	Yd55wfat9RfpPP2QG2KnPlOmubYbLxI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SK3RXkPY;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780659347;
	b=RTMFpUuga+OQ21wSKYOvGkeAuXtv9QqHSVq2qOWJmQi46OIlTj1ZGAwzqeQe/Mh3Atq8J0
	4DO6q8jYP3k5XnqmODX/91vHGp3FsKYfPtQEtP3XQwW4WHs2mVx+USTtZvnlDbJsL9wWpN
	f9YM6RamZbKERAZRjCnuLZgzP6dowsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94C73601DD;
	Fri,  5 Jun 2026 11:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA411F00893;
	Fri,  5 Jun 2026 11:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780659346;
	bh=f7BVss6j6kOZoY1G1bBrjCYbl0PQn+LeN+QUqhUy2Gk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SK3RXkPY5ggBTCPPqN/gLZ6rjYe5Rq77NsYv80iGvYDVemRt2XMxKXlvlJ8fpHMcy
	 loaWPJdEDu5dp63vdK3smDwIJ+GaOYH3MWlJvzqvAddah10I8ernY086EiSZiiXm0l
	 IMoYvNZ/mCkVA7JYKHupElVmqsIK6FsBjZxf4Bub73gzNUTgJjKslKbar3Z7kbMIM/
	 G+SFARLHUqtHEuXbidpNtE5vPwWb0YlxUx8PKF+jeb7OFT+v+dS0C+ntRMpw7Z0sZl
	 HdcpsHQeKVeT6NWotvWbyLNs7GDqqJr1hsVyAc3Jtf4Due0rEJXeRv/KQe42AHcH/A
	 NTehpmFHN237g==
Message-ID: <a5c26cde-e23e-488c-ba3b-cf8bc9be76da@kernel.org>
Date: Fri, 5 Jun 2026 13:35:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] mm: memory_failure: Generalize extra_pins handling
 to all MF_DELAYED cases
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
 vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
 tabba@google.com, dave.hansen@linux.intel.com
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-4-a5bc7db5a9b2@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-4-a5bc7db5a9b2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1E4AE4000A
X-Stat-Signature: hb3jhm5f9bq3hiw4owtrzfcr3axopo4q
X-Rspam-User: 
X-HE-Tag: 1780659346-698933
X-HE-Meta: U2FsdGVkX18pZhK1ibHtH0zkAQr/wZbPNP/8LrOMLkDK89E0ZWhYd+59Do4icqCb2Au8A0EN6zLcdTTW0s5uyErBAiJKjwz1KkZoP7q8dqIvyFwPK/x3E+MsKHfFkYRTdHvv+OqupaOiIddr1mhw6Tz84cGOfCYUluOsmlcWU9NtZRs6Nb0mPwiKC25lGyqwk1tYUosthYy3H3cpLcbPN4KOI1qDcKQVfFdYKnFLmKLSP9P/XgUx1nrZA5kG32af9Uk8r2Ub2s5S5t0teUJLme4Z3Cbxvrils3i5KMFscak/IiHlN4/JpNahWVDKXJM4CbYKZG/YrVbsPKqNp7YhDga1CgAonnUGYFbC5ZPyF4HSanfC7hw1b1qZIqmo45giZjDDsC78eDRI/W8vor3Npnf3ReSKsL4XCS2j6Rmh26N8Z/CFyAcfZGcwSuV3ZeSj35OugsdNRx+972n3Wia/BnrC2dYFEfZUZMrwL8aUjPvcO0jORyVwTXyit0wxIcxBOgh5NlRb2mEoY4sxlyFxycP7G/+a+n/tCDakMAsYSKFa/DA/tzDfJ41stmgXC/031eK+lG0q3Tms4R3xJKB4CK3QgXZBJvEZUpdXBFwysF8fslKMqMWPFykiJtRd2pjjp3mysE+1IwwGKUM19gTHxi5KYWW9bUCFgYr1QsC8Gti0DB6wlTVjn24Ava1Fgje/OND0gE7W/5nhUODAGOwAswoKCSLGgx+r8AJdB6p9ENMU9nxqmwsgMTnUSvXTq4qc8F6oNLLj1eoItEmrUasdCh3FpCDPGtMnmJZaoEHGQJZXiUk5YbFUy0MrbAk6/RpW223zkQD8MkIJVHw256OdUWSlKg0MfMa+h6D9jG8DN8WMye/omk4AWfa6wmLMU4DyHIKcp3Y8waYbbsNXANbHLksovw9HpwqE8Sv4Yv2LH+mpxOtmv1ux7g2W4rGv4Th7qB6PN3kfzPaShzmEmic
 P5CfyU8K
 1SVSAZaNEBlMLDi0hJ3iyfSOHCIWcv9essSGXJQWq/BJl+qVmjdfdYy1G5SIyjKySC2edQoZob/s3t2+s5VIo7KUe82ZmxP27kDUt9y/Z6wYE+Vt3v5iJPgKG4mxt1Lz3LR6fBtglTO5bjEzm4VdJMb/V8hOtAwJ5c+SqzY8vrtWrZaSjSy59B6qyoh/yIqpBka/kjdSuj+RRQqwWMWlGlLZUBbfFYfEv10psOLoIB9pwzUMyEoKMcZxMQIJHOAtfIVkd6ScNrA1ScZJCOWVQjd09B532Tcs6rTn8HbvIUEHmMudr9VwJycJrQHTkjBWRmdUZ3HNTwwDgn8j9e0XII6YoE9cfVwtyLOr5AtFq1yMDZnQy7u4+j4uSfWIzBvsYERAYtPEM8W3rrT8GvZeybPRssBNnWvch6u+yV5UzAtkDRD1Ny6ZcClU4ss7fk2/bDdQgCmlsB5qMZ62qoAdC+M1o+4YbftwMLt/H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 23:55, Lisa Wang wrote:
> Generalize extra_pins handling to all MF_DELAYED cases not only
> shmem_mapping.
> 
> If MF_DELAYED is returned, the filemap continues to hold refcounts on the
> folio. Hence, take that into account when checking for extra refcounts.
> 
> As clarified in an earlier patch, a return value of MF_DELAYED implies that
> the page still has elevated refcounts. Hence, set extra_pins to true if the
> return value is MF_DELAYED. This is aligned with the implementation in
> me_swapcache_dirty(), where, if a folio is still in the swap cache, ret is
> set to MF_DELAYED and extra_pins is set to true.
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

