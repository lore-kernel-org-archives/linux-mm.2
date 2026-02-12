Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7419CEE368E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 14:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF146B0089; Thu, 12 Feb 2026 09:40:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C525D6B008A; Thu, 12 Feb 2026 09:40:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34606B008C; Thu, 12 Feb 2026 09:40:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A05406B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:40:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 317ED1A01AE
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:40:37 +0000 (UTC)
X-FDA: 84436065714.07.B5E7874
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0BEE61C0010
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:40:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LN3lYR4f;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Qahlf8Li;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LN3lYR4f;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Qahlf8Li;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770907235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCS/67r+A8FLWb8UmkH97r+VgraLo3LgWSaF84flvO4=;
	b=YkJ3dqtdXGf8fHuf1WffMBiAmt2eoCvM/XB8fefQLIBphmKsyg+4DZFmQMgniMB4PVzJS6
	9j4ALRqD30hyau5UAKGR0OKzyaSYgbDlXoWX4gpG/Z3oWxZlBj0d6c1ELi/MQMVnRBUHRf
	MZp/u5uCAr/FUmuMXC8AJhadUsyJ7hc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LN3lYR4f;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Qahlf8Li;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LN3lYR4f;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Qahlf8Li;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770907235; a=rsa-sha256;
	cv=none;
	b=dr6w9q+d30snwj1rIWgioxIgM/yQrXp1M8adK/pNzKPlxJcNjhRgp9EwBDvcRKHwkw4p07
	UfuT/E8vBO/XUHZkIeN6ZmFzcBTjvLL6sYUyXXlC1ugmUR4ybjtfRlHBQS6BZefBNlYgZ5
	9gtMORoOpUx4s4Dh8cyadKLjlMOt1AI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 71C3D5BDB1;
	Thu, 12 Feb 2026 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770907233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HCS/67r+A8FLWb8UmkH97r+VgraLo3LgWSaF84flvO4=;
	b=LN3lYR4fOAQxRJ/LjBQkiekIUD/olGUgMqNKBJ/kgy6SdNy7KCSnSCd+v9qMsbELne6s34
	6PJjEYFeJXkdVdfyj8lb29kyVFJG2Z4yBSgxrA7kzBnqTeJoktWR9rFQEEr34/QsCrjQiE
	3dLwS3IZVRi0piTwIjo5cCmpbm/GsiA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770907233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HCS/67r+A8FLWb8UmkH97r+VgraLo3LgWSaF84flvO4=;
	b=Qahlf8LikZHOsotQs3kDVoB7fmtOyHv1Fn0jLF1phIoBw9aqJo0ItjLIr31nCQVnj9ALSG
	bQyVn13QCZSVpkBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770907233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HCS/67r+A8FLWb8UmkH97r+VgraLo3LgWSaF84flvO4=;
	b=LN3lYR4fOAQxRJ/LjBQkiekIUD/olGUgMqNKBJ/kgy6SdNy7KCSnSCd+v9qMsbELne6s34
	6PJjEYFeJXkdVdfyj8lb29kyVFJG2Z4yBSgxrA7kzBnqTeJoktWR9rFQEEr34/QsCrjQiE
	3dLwS3IZVRi0piTwIjo5cCmpbm/GsiA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770907233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HCS/67r+A8FLWb8UmkH97r+VgraLo3LgWSaF84flvO4=;
	b=Qahlf8LikZHOsotQs3kDVoB7fmtOyHv1Fn0jLF1phIoBw9aqJo0ItjLIr31nCQVnj9ALSG
	bQyVn13QCZSVpkBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1876A3EA62;
	Thu, 12 Feb 2026 14:40:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oKqwAl7mjWl6ewAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Feb 2026 14:40:30 +0000
Date: Thu, 12 Feb 2026 14:40:28 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, 
	shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 2/5] mm: introduce is_pmd_order helper
Message-ID: <2tveyrrlb5upsx4pak7y7o4gxx5e6lcusyj45or56xel7lpd3t@u4fhc643qsn3>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-3-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212021835.17755-3-npache@redhat.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 58izemgpfu1kbbtt3ogpjcpm7frjg4ht
X-Rspamd-Queue-Id: 0BEE61C0010
X-Rspam-User: 
X-HE-Tag: 1770907234-672962
X-HE-Meta: U2FsdGVkX1/GEIlarqtZwxQNSCzzBVavzLwGZ+nyuuO73dgUoLcEqwdMk6SY3boQjBm5GKMK4AJ8VSXGgJ0dClas0ELB8AHmI21qkmBITrKGOmbWtAn1+oyqwx3JrCtrK3w/Iv/iPyhSeHp6yY5uZzY5wyzrvdhjDZOJUIbtQdYZGIsraVViOQB286T2/O38TR8gwbZtkhYiRBS1tYaHAWaMsM3j9+TEF1HlDA8grnK9dwhNKLG0UV2LwaLmlHRZFa6UzT1KjPmqTJoSkCPNXXjhFp4NYLziBVQq2QfqcfAo26incUsNUAs6oQUdgTDLZB6chBPE7fbBnSxwtsvcQTKKwHEvDdSn8lcSxRgiwljBFD+B+Rkne9d/CD1pzSS9S3LTAe0e41XI8oNF0sIUYBSF4pmVnTGIVosREOB4vKMWZQhNeZ3A2z5jIWg6TbbG5EvHTRSwAo+V3qeGgZiqKV91vGUlT3sU73JVpKZYZ4R6r8lP9vjjf2+qIMaKBhmgNE+uaIl+L4s/3n2o07R51Bprw7N/T9a/KapRn2/vJHDB+OgzS4pf4HC8GPHbTl5SlfnyIf4ZbtZe1Y02Diw8iKKOfDKAidHdTArnunaJiuxAMOhwq8AcSgmvAmyVtyysGLR6yEKE7IbKnr32OcxsvzjhFoHYPat91QgongH34HYVO9qkvZKLC/DGc25MtSH8T/JI6NcEcltA+2WBhRMEdqlPZ+tk1qvwOdyIgmxEaccMND/s2GMVDFqVAZ4BjnuSGTqIbkppMdiBdhZKyZNhsLXfRCBX1NzR2ptbC2iTbE3e5j2pF2fxNH2Q7xOtazBWbCRnpcmOgjoB14zhFiTBeqr6IGgMP8KszW7n9P0sKElbUuXyRumzqkxJWDUxjpxV3ds+3Fxw7mKRltxKcurI/XQnBqopFmome8Qs15tWkXrbl+XvaY1rLHo4u41IYwyWUjyKEmMP+tUG2dlWu++
 B4n1T1p6
 NBk52Lr4gIkrrlJl2gxc+yBxcaUC3ZDUxGlF1BzPM2DYrqPIJpiO1amhtwMayzy5swx8WC23jFg0XnOkx40b3CO/8CsQbBNT8uAYHwjsog7eyhGdta1KUbytOapUeQ4ZoskGquDm7TRMxrBCen3OJx5INozeeSKyXahbOaB89KoNg9RAy3VbF6R8zHlRlCcLaNOLG9hiuzgg6+BPrHWXRp1PSTbDC2pQPp4B/IUV1g9rpVKkjTCQqhioZlVtjZoXS9x3lIisYixtMQStaGq0Swq/8ZG2kd7D1/A63HQEf0hu27D0ApITfKoHP53/OSKYpBKmpcGNOV/RtUzck8JfoGwEvyKYIJjLez8Q2Ql7yxXRxyNCHe1MqzEfKDGnxzHPY5fITOMwV9O4xYUkVA4+RUw3Gn1q4taVxkOUqLfKj0VynVti3pVAwuFABmgSZGss+CwF/lbgdMPd8uTI4FgyNNk4HFCOoIrcr8t8fikJXLhUQp0M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 07:18:32PM -0700, Nico Pache wrote:
> In order to add mTHP support to khugepaged, we will often be checking if a
> given order is (or is not) a PMD order. Some places in the kernel already
> use this check, so lets create a simple helper function to keep the code
> clean and readable.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> 
> arches#    pick b3ace8be204f # mm/khugepaged: rename hpage_collapse_* to collapse_*

^^Oops?

-- 
Pedro

