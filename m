Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4078FCD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A387A6B0005; Mon, 15 Jun 2026 07:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1776B008A; Mon, 15 Jun 2026 07:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8891A6B008C; Mon, 15 Jun 2026 07:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 715246B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:04:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E5C31A0984
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:04:30 +0000 (UTC)
X-FDA: 84881863500.03.808812B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id F1A5E40006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:04:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ITcrxen1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781521468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hWOY7MWUjRw7SnwfLftxff6I6ZGrfupK3fRU9X3Vrg=;
	b=Olbo8uSH1pixTKyamP4C8E6rUqCqIGwQq7VPXsUTc9LNgNAVdeJdxu9QBQHi3/95PtlW0b
	+nKpeXHRKhPStH/j+L/v+3x7yWsZhpITE9WT2FJ1upWTrFEwcqk2bf9qBcZc8lEw/0V2KM
	3/aYIvhl0fjRpl4zi/9IhxwTYNqC6WY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ITcrxen1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781521468;
	b=fgBYk586Wh2Uv4txfkyIdn25vMU6St06YijeyRS2y7BnuW8TCDEELFBG9ayFDQpWYWqa4i
	dbnv81KrkuAC1FsBrovg47dKR+By6MgzATPgRLusPSdV7UfC8CQnKb1XhNVFz5SCcUITDf
	zMZON2lpi7JrwI2bvi6DLl9TwtV+8D0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4303E328D;
	Mon, 15 Jun 2026 04:04:22 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E54C13F915;
	Mon, 15 Jun 2026 04:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781521467; bh=G5bCUMpAj7XkCblIAeX+67lQJO0pVJ0HsMawKtJgxQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ITcrxen1FUILXt0yTvFGlM97RCokdSUG6KreIW5VnfKj1yUsv5nAXAUCQjVOZEyus
	 1bxtVRPtXhyGGGbSLmKSdOfzkBrck+oXlbdN9jdKXe1uibx4w6l3zzqX0H/xXyhSXE
	 z3BP5/FQv9K7Ctbm7B/qLe39ZaH6N64JsRAQb/a8=
Date: Mon, 15 Jun 2026 12:04:15 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Shivank Garg <shivankg@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Nikunj A Dadhania <nikunj@amd.com>, Ira Weiny <ira.weiny@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Nikita Kalyazin <nikita.kalyazin@linux.dev>,
	Patrick Roy <patrick.roy@linux.dev>,
	Pratik Sampat <prsampat@amd.com>,
	Ashish Kalra <Ashish.Kalra@amd.com>, linux-fsdevel@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] KVM: guest_memfd: folio migration for
 non-confidential VMs
Message-ID: <ai_aczmeH2IA6JaB@raptor>
References: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
 <ai_XK__RTXMCEcCG@raptor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai_XK__RTXMCEcCG@raptor>
X-Rspamd-Queue-Id: F1A5E40006
X-Rspam-User: 
X-Stat-Signature: f6ii5bds1rhg8rir9mhh41fpz1b5d9fj
X-Rspamd-Server: rspam09
X-HE-Tag: 1781521467-312008
X-HE-Meta: U2FsdGVkX1/4dj7Apr64T6q3S8W1AoWRiyAh9reKwLJgTlD+VYMvTrFCMK/x9R8uQBFjebV5qAKefEas8n7egajGT57oFo1LdBoo+9qrzLw7jN9rvXrX8K2cxFsL/Z3wcxq3YgmA/8MDycQhm3BQ9nQhqzGYvmCRj5bzvjIAeeOyiaxwosGGAYgkDTn3ooJuBhzHtts8yrwLvdMw+qYMzdQM1dUVZNMyiR17Cpd1IuAjc4Po1zsC1IJDHQPSQCuH+E9hzr7f78s3uQj2rbB6dZLz4FCDvE9Vq6RY1oz92ynMW4Nn+fSQgymuFtg/VPW1zblQwre1+7LMREDiPg+wbQRURzIHJrL3jXybHaPR2ovuznmVBBpJuE8uYSfX22pCDPJuLIt9pROqlKIQz/BjZq3QQ6xqYqJ2kcZRrCzqjEoRx/f4AQkktcw/GO0nhaWsM1uaLSAmMvbbsl0m3U4wmpJxiaw+GYWVazm5IKh/c+u0+VWqtsV9IbRlPLIaUx69dL/mA0U+s1Al4N8O1zgCLL3LbTa8ux3bhAI/LVXvCHOTCJ7JJbVl61rUC/2ymiioXRRL4flS/UAaGzVkrf8Far1bvYE5a6lJhE6P5HS83uJYl9Ln8FjvdO9Y4AqpmsfOlyFPZxHal9UrBEq71SKhx5K2AYIFxsQNVb4AMdEFxkChZMzRMbWPc7b+cYs0lb9IYeKEdL6gK8mh1A7ZQFh6YqhVjdQMgKK+JNX91fmg8dlkEubJ876/A6+0ovJhiVv6hgv7ZH2K+lUI9HBxzLsqUaQg0UX9ETAub9HE5Y8L3nEmuXF840SVT9kml4HeNI+QRaL4LjmJRFimVzMVZLkjpCHZwyuTiSqUlngMs+hwAeoIHg+v7wp8eaymJmuSdiwuadC8d0CUh4It1rXFAWqAI5sGe/ayZ+TmhB6a0zXikCOJZFu2jLqSxAzs4nKWIxx4ZukBRQdMZVdBy1WMr+K
 r0Dj9U74
 c+OPGwHSn7QS8Q0Xm831nrKfp8lIaKxizI0GVeDfh+/Oxj+2k7eenWBNZA6qwFP4xQ/+oL0Fu7qRU/IjCQ89zBfZku1MGN6dJw7iHC2LYK+8onQByGkawgRPgsqE4PqHvg4bow9zoIyOMCS1iR7U1R9Y0InMH3m8woggoMnDIYRF7ifPwRvnti66c4t0aQIn9GZ+/KvDfIC3s8sILXFeeQPoDWphXIN2BSD5+OVAgy6JFFJtJl6c7NZpMhnVFOe5ygH92jMXU+Wyhf5DoNyyEFirGZeYtfkW4iC4d4qPYGsF4NyRWBhj74v1HMZWyl2Tf+cGSzCHHQ8HjYfzg5va4a/9D2+2K72HSwRmm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Jun 15, 2026 at 11:43:14AM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Jun 11, 2026 at 01:05:07PM +0000, Shivank Garg wrote:
> > guest_memfd folios are currently marked unmovable, so the kernel cannot
> > perform NUMA-balancing, memory compaction, etc. This is unavoidable for
> > confidential VMs (SEV-SNP, TDX), since memory is encrypted and copying it
> > needs firmware assistance. However, for non-confidential VMs (like
> > Firecracker), we can migrate the folios.
> > 
> > This series enables folio migration for non-confidential guest_memfd and
> > also lays the groundwork for migrating confidential guest_memfd later.
> > Once firmware-assisted copying support is available, those VMs can be
> > made movable, the confidential folio content can be copied separately,
> > and the destination folio marked with FOLIO_CONTENT_COPIED so
> > __migrate_folio() skips the host-side folio_mc_copy().
> 
> I always thought that one of the nice things about using guest_memfd as a
> memory backend, as opposed to host userspace mappings, is that the host
> cannot unmap VM memory because of KSM, automatic NUMA balancing, hugepage
> collapse, compaction, etc, acting on the host userspace mapping of the
> VM memory, and outside of the VMM's or KVM's control.
> 
> I think it would be useful to preserve this behaviour, even in the absence
> of confidential VMs (i.e, guest_memfd file descriptor created with
> GUEST_MEMFD_FLAG_MMAP).

Just to be clear, I was thinking that it might be useful for both
behaviours to exist (migratable and non-migratable) for non-confidential
VMs, and allow KVM or userspace to decide which they prefer for a
guest_memfd.

Thanks,
Alex

