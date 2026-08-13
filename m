Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B0BC5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4545B6B0370; Wed, 12 Aug 2026 23:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDF66B0371; Wed, 12 Aug 2026 23:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD346B0372; Wed, 12 Aug 2026 23:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01EED6B0370
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:15:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E63501A02E8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:15:41 +0000 (UTC)
X-FDA: 85094781282.28.55BBF18
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id E479240004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:15:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iyBAx803;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786590940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ztxgd/JYqFNMa+5W28UF9FOvIRk8UwQbnQU61yY7A5A=;
	b=6wzumCkmLmc5efciGCYdhxOtzcJhcWWoNlpTpQLXdyUYV64Jfk81EBscPSAcf1RCeUnwUx
	iPfhuXSn/Kt+aLJ7JBE3d+SMBC1ePPX/p4+cBmGkGT036cZrQIMAkRxtUN7xYcIt/dMCVU
	azDmI0VF19M7TBac5QjxU5Eb/t/G1WY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iyBAx803;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786590940;
	b=sjfToW/c0zOqyCcUbxVTsno9oyJiGMuaQ9dTBd27WGtzSXms4CNeLWhPBSiM+HoMizjhP3
	OzQD9GBAkRnjHD55VmGoPIIrLWEdfJHLTw/+spZ/GH563s+oZh8tS5fe6aAHJyvn1kSwAo
	BxWTxmEhliBODvH9ApWm0t1/RqVZG3s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A94AA153B;
	Wed, 12 Aug 2026 20:15:34 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D75943F673;
	Wed, 12 Aug 2026 20:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786590938; bh=EPioq+6upU6QiPqKEQkAHRgMXpoHtJwKxdu3sdn4bqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iyBAx803FWI38pNmQcpii0O1xj89IwX+KybHOVmKCDSWD4HEE+k3+6RVtqqVhRSfG
	 1yWW7v4Bgvro9Kg6CcQG/tIEd0Vrlg5oUjtoGWUBsjTZIoX3i5AYGotsQzsdjY+z/i
	 yD9rJiYl8VW34NdVCPFMrH/Jnil9Fu1AYZKTVf/U=
Date: Thu, 13 Aug 2026 08:45:35 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add drivers/char/mem.c to mm misc, memory
 mapping sections
Message-ID: <dv43i55pge7zamnk55y3xtvejvnipmeejkcnt5nx3lmx2gqtnt@d6yl7meezqth>
References: <20260812-add-drivers-mem-to-mm-maintainers-v1-1-6218b861f4c8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812-add-drivers-mem-to-mm-maintainers-v1-1-6218b861f4c8@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: E479240004
X-Rspamd-Server: rspam07
X-Stat-Signature: j7tfewpkam5ahjgiitn4abf5h3xpft8p
X-HE-Tag: 1786590939-713650
X-HE-Meta: U2FsdGVkX19H8+hS8SsnlBaPi3HcbkYAwmls4g5MKNO+pIzAUhU/VqPz3r95dRvySA8GZnZHxlx62IlfTjNC2RnfY8EE0bA+3Hfh+b7ASxK5CqPic/6IaB7ycEy83egVklEXLT3EiWNDeJYxKO7P81ubN7P6ApF+XxGq/rrHZcZ0+oH4bwIIfYw4OHJdqo5eI0ZgGECnEbk29rVTpTwDXkQ1q/u6hrr6bODdSeSqLsoegDYzpuVAjiFK+VnoFvhYFIJyagakTWsnn/Q/vgVyPc/3OKhsRNvmFgIcgPtbxS50SvBjnE2ajNXx1LffrHy7RcMAWMZC62CXgIEQtusrIbnt+q+1wEBp+VfrwxZSTWkDZ3f9xcVPHGXpVeIF4B2c+/xMQ/OwEqBBi1x7L2Ps+k3ZLceqNtkYABGNwz95f2YUT57/pKCTQarfhvcuvMWPWe/BbbmnQ+ql/ocxuCwmeq8EliUrrEsrfipoFM15MH/LOLL8ivl0Hv89BI5ovnthqudKPebaocq9CQop6u/CwiafPekXTs3/z+jQEWFg9Dar+kZTKjNZAcWI7q0Hj6A8NEY1BqwwNWImzBIlVJqW4zo0oVMNipDE6c2mZw48iCIUZZOrv4h3Pr3kStQ+d7L36SruoFIHoRG2W/fRYN0U1BbTbLZAyajdoeEXLTqz4PhJgqpStCLc0HROo3+gStoHLNIfghL1EmbyA5SN6LaOAA0onfvKkeFyzFRZaCGjSrsh3pPmYC2duIvG6+Wo/GGQBshViA9z7R3wwQLKNl0hOVoEGpIo3Ckd6TV8wT+Di42YZ3mAGcHlH6JbIpxNyBme1wtDyoVDNiv/7nJE+wDo+Lb/2camsYW35dLufPWouwoRV5+/DAz1ZSJ/VUpdtm1mLVfQNAh+Qnr+P0LYNMxrbEnolT56THmqnVQBfjHQzx+O62ftUM9F/Vn+FLK3LNTujvZJFtg52xo4VxwY3mv
 L/VRXaj/
 L0mlFS6tYbrqhPYgBtyJoaVq/lISJl86SgOdBE7jSN45BDoAweW7urGKUQaa+8hCiWh2EDyF/Cg+mlWbaNxvC+ZwfAmT1UhRnCZJzXTLIlSj/UpCLrO3oj5kev1R/+dnT3Z6IaHjyFsOYMzhgxXeKmrCYh481Pg5Ui+I+tT+Mk+us9bzi/i1pZu8pEAqDkWWM51QNz7ZGNOK2hsa4AMCDfnCBCW4y73hGc5pm0v9hKhBgrkAgz76eVTdLGqoOlaMJJS87c1beYdsfEP56H2esncve1XI3QAiDKAHa1xlUMX5BYhqKdmq2hPfP/2dMHoMy4v24m+Zq41KQNxXqAk43FJH/wkMWStlSnIrNWK5eByaJx2S5rdjlqmeZpNg8P7PW/BRKl6EXTNbNHh469nCRVwgfKThJ5fWlxpkH5gh/qt8Ashl5XjE1y1PUJ40/HJu1DlhV2/9LcrH9QBDCZ8iF7AE9wTWtMPWJS1yn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 08:43:31AM +0100, Lorenzo Stoakes (ARM) wrote:
> This file is a 'special' driver that implements /dev/zero and /dev/mem
> among other things.
> 
> As such it makes sense for mm to be cc'd on mails and to have some say in
> how things are changed there, so add it to the mm misc section.
> 
> Uniquely, it provides the 'old way' of obtaining an anonymous mapping -
> MAP_PRIVATE of /dev/zero - so is directly tied to memory mapping, therefore
> also add it to the memory mapping section.
> 
> scripts/get_maintainer.pl copes perfectly fine with files in multiple
> sections so everything should work correctly.
> 

LGTM

> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

FWIW

Reviewed-by: Anshuman Khandual<anshuman.khandual@arm.com>

> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8014b9f8253e..27160fbe21dc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17109,6 +17109,7 @@ F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
>  F:	Documentation/admin-guide/mm/
>  F:	Documentation/mm/
> +F:	drivers/char/mem.c
>  F:	include/linux/cma.h
>  F:	include/linux/dmapool.h
>  F:	include/linux/ioremap.h
> @@ -17311,6 +17312,7 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	drivers/char/mem.c
>  F:	include/trace/events/mmap.h
>  F:	fs/proc/task_mmu.c
>  F:	fs/proc/task_nommu.c
> 
> ---
> base-commit: f5bbbfec59b4e2fb7520a91de3df8a6174325d6a
> change-id: 20260812-add-drivers-mem-to-mm-maintainers-f3864dc8ca19
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> 

