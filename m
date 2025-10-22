Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD043CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 19:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1160B8E000D; Wed, 22 Oct 2025 15:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE1F8E0003; Wed, 22 Oct 2025 15:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02AEE8E000D; Wed, 22 Oct 2025 15:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E641C8E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:52:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BBB35BBA0
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:52:39 +0000 (UTC)
X-FDA: 84026797638.06.88FB15E
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D82C8001B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:52:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=tAkUlDbN;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf02.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761162752; a=rsa-sha256;
	cv=none;
	b=WZfYd82E/9+hQWA5UFulw4RIlyWtSPG2j2QjwWev4P5b1glm4iCLHYmY8NSmdQZ1dTCXQ8
	Olu6GLdL9druLG58v+ijyvhsaqWA1zoB5MQKcQYt3xv6+iHuFWllo8Mq3VYsH5tMa0R1hK
	+G1e+gSiq+KdHyMmmXmW2uRmDNWhN6c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=tAkUlDbN;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf02.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761162752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Haa0rbzk7uFEUkoM8PNccPAjfwpK0TMmgUFI/7nPrus=;
	b=gJcFG0hA7UQBdsj5jbaZJgXEuh4ueCOBJs2xfT0w6DJyhqndqynZ5jq140A4f68CW25UHP
	hw5q3pHvVokBxkKVPUrHLEActniwPc4qSBeDiM6W1xKWWNVgJ8qK3wOTKsnwhx2uAYRJB/
	zaQtTnMzaGgTM5oRnFOPRETVxtdYIBI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1761162746;
	bh=Haa0rbzk7uFEUkoM8PNccPAjfwpK0TMmgUFI/7nPrus=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=tAkUlDbNTOnRRGLA2FGyHap564fehNknda1C5LM24NN5OumaiRHnf9szaKFZIw8bE
	 XxUA77mQ5kW1oW2tnEM88YAmQmij/B9xz7k4NN9hzCd4RJHeMKSgP8n8/MPAVVGyUG
	 jU+ausY+n4D/78g8H3qDTKvn4VmyxydnE1ge8LUs=
Received: by gentwo.org (Postfix, from userid 1003)
	id 3EDB6401E1; Wed, 22 Oct 2025 12:52:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 3CA074010E;
	Wed, 22 Oct 2025 12:52:26 -0700 (PDT)
Date: Wed, 22 Oct 2025 12:52:26 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Nico Pache <npache@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
    linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com, 
    ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
    Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
    corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
    mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, 
    baohua@kernel.org, willy@infradead.org, peterx@redhat.com, 
    wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com, 
    vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com, 
    yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com, 
    raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com, 
    tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, 
    jglisse@google.com, surenb@google.com, zokeefe@google.com, 
    hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com, 
    rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com, 
    lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com, 
    pfalcato@suse.de, Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH v12 mm-new 15/15] Documentation: mm: update the admin
 guide for mTHP collapse
In-Reply-To: <20251022183717.70829-16-npache@redhat.com>
Message-ID: <bba40f08-1b87-6b57-0e10-6e96e4d7bde6@gentwo.org>
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-16-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 5t4aqqjahj64ignubgbq9bw4y7wobkrf
X-Rspamd-Queue-Id: 2D82C8001B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761162751-358311
X-HE-Meta: U2FsdGVkX1+lZ97pR/mczhDCLsife/sVVm88GiE7S/CcGkUpJhlgv+cJEDcq7XqvdXxQ430tjOooB5f8yKVufiwbvnFHjplem3jy5q4LFoRZLun4EuXEw6sx+udkZBco474OA7v3GnTKMeyIoyfnOmfFdLLqrG1akO6MylEgSEI6pX8f1WjIcFfNR+lCZ0lcmuv7/kvcUH3yY0NgTZzHbUZXzDjwtR+OzPOhY5qr2/ReEIy8uV6VVFqYtskMoiBnieZlQFMB0bzTPkOPoFqeTeVsOR5Kjly79Smy4xnTKBU2CSLkfG5wJhoe+KiJQRobFeSYqCbg+7vDyYHrenPmIDKuG6X2rL9an6LddtZ8BzeODMbaBUycky1kX7vjh1RYCt9IKTxg0jcgiiLSv/dHzw7ltxFwwDPbZMSwsreDlYXU0O/xS1H4n0QB5HZuDKs+cJCHaTpSTkU7O27qgjxrnsdgBaM7lJSA6qepDAJpoGikMNgPGFdT2wgMGJcgRxMVQfFVFbb9ERs3fxepcqTgWfFAX1IJgugpxpmPJ8vk/5tKlCzSWacsU/2iflZr6aIzipMdytHdQrj8UcTFfZpYY/yMRFbtm4WItbi2t9PALpm/QaS4KIpob/e11PxgzYL0Yb3W/brarHiJdXD3hSH7l/7ybFTitH9BkA9hdgCYbbDkTCOClIE+mGTxQ7cXD2FbgdKcDEqOldfiUQgxqKDKm4h64y0jpcxw8s1TEQ5Hig/kViiauseY8poZE0X2/sshDfYCCRvXaybUV5GnEfOorU6PZfSZ2ng7XxOol2u616UzJvO9RTE2BwEx0Ne8DSL/eJynOeueJF4HPx/EiIyOXhmpbadWgBqPeNVEjVqQy31PTKOqs6IkJ/4235GkyUpxIAwhwAPo+XTXFdLv48PXVfRgtxuDmar1PwMfRE8cP8pCAV28HqEQS4aMV0/GnN4xzuLa55BwKx/UOPrvk2N
 n5TZslB9
 RA7OABtaeStAhD3UjEtyWi7MX/mqn6QwKUKbv8YwS/ZzuMnLYzGX0ue1Nt+WNV3l+iN58b8XGh78inoRkekrhd8iMj1kXGVkPkTbXxOgM+a2vrdIJFtmjzpqsGYvYdJKdS7M/EPkIG8c8qqK9JWiMqqZgydRm/Q8RUCWVVeTzWAS7+Q6+o8MyE+2YNkwvPx/gzpSsON7gKX6cSIy7Xp7TI9mdzbvDJ1zOPJE7DFUjby1JHm4kBOh2OUeb1gmlF7QizkbGiKINkwCj63luMXUGvwpGzEY3wcxPZXDDTo477nUgXwGcPuhVQRPW7wHnIEVCK3ELoZWU0axqn0h+Ly3eE/VdjUo0546zBhceitK2kd3htZHGJ8b71yA7XQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025, Nico Pache wrote:

> Currently, madvise_collapse only supports collapsing to PMD-sized THPs +
> and does not attempt mTHP collapses. +

madvise collapse is frequently used as far as I can tell from the THP
loads being tested. Could we support madvise collapse for mTHP?


