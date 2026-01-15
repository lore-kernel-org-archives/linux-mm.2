Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D828D41149
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33ED36B0093; Thu, 15 Jan 2026 04:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EC4F6B00B8; Thu, 15 Jan 2026 04:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3F26B00BD; Thu, 15 Jan 2026 04:39:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AE2F6B0093
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:39:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1E83160266
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:39:06 +0000 (UTC)
X-FDA: 84333699492.12.FC037D1
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id EB50D1A0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:39:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cRsnSkH3;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768469945; a=rsa-sha256;
	cv=none;
	b=gY1V4E3GfrXXaF0Txx+oDPbv2HfKySqx76gqMXFyPbV/gKWrqA1jWnQ5Ow5CPLGbZUide0
	sVEOjl2SgLdY0/mjsHZZil/hAktEDq2lH2rsZQ51inaADUgtc8Hv68HsymADbvBaHf+ESk
	qSLcAz6phQES+51jxCcJuSNi5ltjk3k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cRsnSkH3;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768469945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVVqGZ3l+eUoAxt/83SPf9RM0AnIYY+mCB+ElcBndDc=;
	b=37SwgcuLhxnWRqYZnFkzGD25s56h4dHDpme+zwJovDFweANuS4RIckeEGdEKk+c46oLYLz
	HiU3G9iw+0Z24tDh0qcw1L2hVoNXudJBVNf+TaU26OCHu9HWLYnQ07VTSonDgtuAb0Iezi
	vuYWarm07aJj5PvHE12jQpYbIGBhQl4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768469942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YVVqGZ3l+eUoAxt/83SPf9RM0AnIYY+mCB+ElcBndDc=;
	b=cRsnSkH3HNWFooNCu45BiRhggR8i4eFVIEtaDBZS6rcUGpU4CX2VzbdCKKVVXZEpZefbox
	1JDlPRjWkLPi/F4f3TbeE+mpwORW/695MiDjigp5P+ylTc7GZzfzqC+FKH1TT+SLK3VK8I
	8wdyRK+A0I4ZOEoETVWvkMjzjg4EN0c=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	arnd@arndb.de,
	bcm-kernel-feedback-list@broadcom.com,
	christophe.leroy@csgroup.eu,
	corbet@lwn.net,
	eperezma@redhat.com,
	gregkh@linuxfoundation.org,
	jasowang@redhat.com,
	jerrin.shaji-george@broadcom.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	lorenzo.stoakes@oracle.com,
	maddy@linux.ibm.com,
	mhocko@suse.com,
	mpe@ellerman.id.au,
	mst@redhat.com,
	npiggin@gmail.com,
	osalvador@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com,
	ziy@nvidia.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 23/23] MAINTAINERS: move memory balloon infrastructure to "MEMORY MANAGEMENT - BALLOON"
Date: Thu, 15 Jan 2026 17:38:27 +0800
Message-ID: <20260115093827.12557-1-lance.yang@linux.dev>
In-Reply-To: <20260115092015.3928975-24-david@kernel.org>
References: <20260115092015.3928975-24-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7kwc5kpqxik1pc8ut31n5g7asq8tzofx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EB50D1A0008
X-Rspam-User: 
X-HE-Tag: 1768469944-281722
X-HE-Meta: U2FsdGVkX19T2MPOIkE6DPJKo4QkQZaHTQF/fXSfcXpieNAWdvnaqeDGYSERsy/C+Z2WnQvdhLGG7Ci+xJk/WUpLSnNpdDQ01+fyuuIhAkZTaVllTdUkyGi7JEnkgzm8kO/7AJnmtVNi2LKzvDHCO7Jjdudes5i9NkkbNic8b0oDk+/Ugm57DtLIgRfOZB9VEtq6+iB3N+CtGWGy+1NSeaTte1cd20KUigA6vCI/Th9079OZY7JGd8tpMpEZOgSCvB0LPUQm4zUY97rl+ynqMDID/I62rQFkBudaQJcPcBCssmqiUwimPbCbx7HROr+II6k5lhdcdO4La2572fLWAEyz/WBLVZiRxke4t7y7PU9yIZa4Y6j+6NWj8rotTuRO09MfxMZ9fTrRjW1A7rXAqEuwq1I4SZcJdZmp/OAUEYEJiUedS73+YTpcvtNw1Ibb7e/IP9wWga6hsh36jclaJFcmgqTQ3cUSJJg/8DmHoGNnD5FhEUVXaVl8+EZwtP9xBLg7qSJO9XGbrGkXiK78f0hnAqy07/6t1qz2YnEqxNKdtIdr23z+TEIndrWC7xiDlQKKwabj1U6Z0lYp5S+1VmrK2rmwfhSdY7MAksYUwaMnUjxDDv7SDgIJeOOsG+LRh9BQFPvFPbZBmjDsPverIJ9OSs6itpoe20yoSOff3yCf0iBk52CB5fggo1w6wtEYlB743UdOb5ZIJPsSPZjzMzO+lnYiKou5l9csxn3J7XC1wV58wScf6UK40fxi9qkZ4I/s+1Tp+kLqKdUbZNAodm5C/gFLItr3Vw7xJqUfjdHNBJu4IUitSgx9hFFNas/EDHC3UtdXYqeFXa1R4yb+qXUqgUxVzTIfjY546DHbrx/0SaIt/ER6DMRc7KA21SaQidxjNhobx6JnV89fT4WW4Gz1ZqquZOOVIoFHA5UsS2dQyR60ujsMfet9WgVmOmavsC8+UW+nJeOELil+Mr5
 K2LHiqWK
 yEgMQy5k/rdZqJfGSHciSbJja1ZS4msNozejbiRp6gXAai5rGjLUCE7dlVckVY409Eh+Te8hn5QPgXDfqIy+omlZy0cgZcVZ5kfYUfbx9ZyumDPUrMUOGE55ec7IAXnVHYuAFGqc+MIjashmWxoWPJYKrznIPS0q0wBJhyDCIpAluwUEfLQaRBw/Vf/lV3E0t3oR8wHufEnawlt2gI3XUxodmIU4efiSB73hCcDrlJOX3+kco3Jr8//8WxhoH6nLH9106GbZB6QnGn0nilZX2ty70wkbU35t6F+2y7w+hwSAM+QNoZFMsy64E+5V9APgcdww2VTomMyk9Q8oSWBqomrKDcrtYKeNKXE2oU0IGOynp7lbvquWMVaRaFbeZf3SDU5Bf32RgS0MkFvNR3xjA7S72TX+dRvQtIo7bjcp/xgledFk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, 15 Jan 2026 10:20:13 +0100, David Hildenbrand (Red Hat) wrote:
> Nowadays, there is nothing virtio-balloon specific anymore about these
> files, the basic infrastructure is used by multiple memory balloon
> drivers.
> 
> For now we'll route it through Andrew's tree, maybe in some future it
> makes sense to route this through a separate tree.
> 
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>  MAINTAINERS | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index de8f89ca1149f..b974f8c1c2225 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16454,6 +16454,16 @@ T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
>  F:	mm/
>  F:	tools/mm/
>  
> +MEMORY MANAGEMENT - BALLOON
> +M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	David Hildenbrand <david@redhat.com>

Should it be david@kernel.org instead?

> +L:	linux-mm@kvack.org
> +S:	Maintained
> +W:	http://www.linux-mm.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	include/linux/balloon.h
> +F:	mm/balloon.c
> +
>  MEMORY MANAGEMENT - CORE
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
> @@ -27536,9 +27546,7 @@ M:	David Hildenbrand <david@kernel.org>
>  L:	virtualization@lists.linux.dev
>  S:	Maintained
>  F:	drivers/virtio/virtio_balloon.c
> -F:	include/linux/balloon.h
>  F:	include/uapi/linux/virtio_balloon.h
> -F:	mm/balloon.c
>  
>  VIRTIO BLOCK AND SCSI DRIVERS
>  M:	"Michael S. Tsirkin" <mst@redhat.com>

