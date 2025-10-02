Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C6BCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 12:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A51E8E0003; Thu,  2 Oct 2025 08:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D0C8E0002; Thu,  2 Oct 2025 08:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892D68E0003; Thu,  2 Oct 2025 08:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 752AC8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:38:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27A1D1DFE0D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:38:21 +0000 (UTC)
X-FDA: 83953127202.12.377CB33
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0FE5F1C0012
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:38:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PIn+U7b6;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759408699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qR3Ey6vKyhfGp2gYqhiOz6K7dp4eh4V/CTjq5hLtNkE=;
	b=UKkIz1FPEA99vIY1nyM3vrAA+IcDS6RolqxiZN3VUXFbdb4lK/LsgRWYn1AzXnHMWpVCxx
	XsI2xKSvtJ2IUpDDIQKr9PqFuMdfcrPZ56/JobPTT0A2A+kHh8EZBeyvnbuqZAIkb4f5/h
	pm8M0QeQF1kVjQST4SMXppO1GaW2+WQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759408699; a=rsa-sha256;
	cv=none;
	b=f7hPalJquyzXNZpFJMAyyVjDJLWQbnTkBECP2i64hS4jiYayA10gPK8Aybrziqtaf12Gtv
	iMsNk9l12r7LT6XI28J99TlEN8Bw1Sz/cc6BhIVgb7eI3c0mlSMPFszN2GRm9MNQBW2oMp
	E6emJ5dy0OMrUFbXFz5yABrM+b4Dugs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PIn+U7b6;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759408698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qR3Ey6vKyhfGp2gYqhiOz6K7dp4eh4V/CTjq5hLtNkE=;
	b=PIn+U7b66Y9A7KGONl0xJe6fYsgiGCGZXk5969SoMj9sGH7Gh4c49VkBkw037ORGRX703d
	IIo9b2sSzCl+0dqmiHxtw6OeR6q4o10qEeaTm1Ux0Ja/F3uF+affCFFlGgavPDAb/XQ/ej
	9rovCbR7KJtMnIfrkLxJ44IZL8QmUo4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-xFab0D_bOfSIV2_j4PNYDA-1; Thu,
 02 Oct 2025 08:38:17 -0400
X-MC-Unique: xFab0D_bOfSIV2_j4PNYDA-1
X-Mimecast-MFC-AGG-ID: xFab0D_bOfSIV2_j4PNYDA_1759408695
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B9831955DDD;
	Thu,  2 Oct 2025 12:38:15 +0000 (UTC)
Received: from localhost (unknown [10.72.112.47])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 695AB300018D;
	Thu,  2 Oct 2025 12:38:12 +0000 (UTC)
Date: Thu, 2 Oct 2025 20:38:08 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	youngjun.park@lge.com, aaron.lu@intel.com, baohua@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v3 1/2] mm/swap: do not choose swap device according to
 numa node
Message-ID: <aN5yMD53yzAmC6dT@localhost>
References: <20250930063311.14126-1-bhe@redhat.com>
 <20250930063311.14126-2-bhe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20250930063311.14126-2-bhe@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4UNlcttF-6t0ekvfbX4K-GE7AzhK3NHK2PribTPmjO4_1759408695
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0FE5F1C0012
X-Stat-Signature: dm1ejnrmpyf3x9y7b6h8wqho8ymbfp9o
X-Rspam-User: 
X-HE-Tag: 1759408698-432869
X-HE-Meta: U2FsdGVkX19EFHo+wmCh3srzGWiz2IjJb239OBYafTYWkBWXPPEBXrQxmYdOYfFDEIWE+ezKgcQH+S1KbCxe+sJHTJnjEY8E0hDi1esbKP6yP1MzFjwC7I7U1UNP4eeRyNqfT4f2KzLIX33UZgZY+jTxIZK0z4vEMKJy11hM4ymMwEYtytAx/DOHoNExdav1m9pqqGCt3NytqN3trAxt15nR8wfm566oU4fw1RcKxciJnAAPOYFKDlRxcjsTxjQv4zCPJJcmjfmFQaJhppL+CNI8upJo3IBUuHfR4xPJDkgUWynxiy26Sz4Rv0Q6pAB4JFuFFtjkn8BsvLjThfnEvdGQBk99Al8TjFy8sp7mKo6ai9MY24ZKJO/hd7RmXWr9ppucbo7XCZAO8HKMHrlfopI2hmcB5oC5vSCWXjBGWotmRcP08Qacly+mLmJlBuFV8OYF1orDSng2RMlVO4g6wm1wV4le3cTsg5nYsxhjOyLxkmbW7tSnNJ7pjIyWswzZnfdEtkMBavlURYQ+C+WsjTjP/bAYdAeiztlgKjZNlzd7t6njoFuzp2LLRErVU2d1/aS9Da66EzG09Tu4MAQ/g9YPsXU/jfMMdA52JdmsgEW3jkrGDcYg6KJEZYJwdhCUDzWWcXa0Wtb8n1IcyBnMa+Jfj8sjbHG2bGy381k7Yt/AIehDabUyf6kqsH6Fn3n7PLNECOIUL6vWD+dUo5CyttdrauwSylUPl8cZaHNuFAWK9Pq0hB/oOOSAMdNS8Oi1zmgCchFXT1DNd6RZYc+KIjUx/qlGU3ngBWBaz1zbvNsNZwoySZ8XPamgiDD6mZOwQQlg/coHi2QXeho45eyL5QMG2lsJJxl5vnxOcYX5AkfWZibcLxl8FKsL4IbcyO438lZh1iSK2QbQ+3+gIoKg0tNLxhI1ptLSCOsw1kAdsSfYsba3SioPZKKx1QzScGL+7M265Bba1vIKqmNyVDG
 aGbLI0Y7
 L/OfL6yEm9NaZh7B+f6IF7V2ynkpl3RNLp91xlavb9RY4tx0QnKI4Rf2QwDXn1WVnfFZ7/mohuvn5zq1XZdx9jlBQiRaTxvTqVz6Y45P43+erj4Pc1zPHORMJCGD9atoAhLZL/yD9Kv6DnNGW+L0KGDsZSeqGbF8Y94IwUubvpH34YSRAi+tZOa+JlTomued/CE9vh1h18z8bxOLq+/vFNph8BOF1fQMe4EEXgsgQ05jt86ObnKaCzvJXiU+U4mMy9PAAn5lhSJHJDIAmk4d0rziuL0leIp/8ekhtqMSvxx5GanfB3akYNC3bYwXPBrhtvDAYxLfCA4VYhOD+K37I68V/CE1JSB3lgLy/ZLVs7tiCihpqneuRj9cwWyJ2Ou/22eneTYSwGMCB8fzAWceftpPqT5s6qtJGbrL0X8ZtIbwWKC+GiFkFZImFyix9wk4eC9mgwjOXoTc8p5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/30/25 at 02:33pm, Baoquan He wrote:
> This reverts commit a2468cc9bfdf ("swap: choose swap device according
> to numa node").
> 
> After this patch, the behaviour will change back to pre-commit
> a2468cc9bfdf. Means the priority will be set from -1 then downwards by
> default, and when swapping, it will exhault swap device one by one
> according to priority from high to low. This is preparation work for
> later change.
> 
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE   USED PRIO
> /dev/zram0 partition  16G    16G   -1
> /dev/zram1 partition  16G 966.2M   -2
> /dev/zram2 partition  16G     0B   -3
> /dev/zram3 partition  16G     0B   -4
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>

Forgot Chris's for this patch:

Suggested-by: Chris Li <chrisl@kernel.org>


> ---
>  Documentation/admin-guide/mm/swap_numa.rst | 78 ----------------------
>  include/linux/swap.h                       | 11 +--
>  mm/swapfile.c                              | 76 ++++-----------------
>  3 files changed, 14 insertions(+), 151 deletions(-)
>  delete mode 100644 Documentation/admin-guide/mm/swap_numa.rst
......


