Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF037103A9BD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534176B0093; Wed, 25 Mar 2026 10:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50BD06B0095; Wed, 25 Mar 2026 10:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421F16B0096; Wed, 25 Mar 2026 10:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FEA76B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:13:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD1388C74D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:13:22 +0000 (UTC)
X-FDA: 84584777844.19.6AC0EA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CF87D80011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:13:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=THeeRJa+;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1F+7Gw+G/hP5z5nt7152wgtEV1xSsKN3O2mDCBx1HUw=;
	b=R6zGxOrCxpP597wgtaY8TrKpWoleVLwpyP9RkBO3krM9aWsRuqcvKzN+Yze3e0QcZQtNID
	tqlEZiEwNKYHaJ68O4DBhPhykPd8EvEPYY434n4Ua8QEun3XzP5gR/cj+jvC1fPCLMbAXI
	VjL4Uq4SUuUyVZiW/m9NdkFGlyZgzPI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=THeeRJa+;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448001; a=rsa-sha256;
	cv=none;
	b=I06Q2SH0VnEhWeDDuzICp1qAhjod2hEICHfvN59wTXAGW1XmniG0r4Uwx1rZZ33moY+4CV
	+JmVRriCEueCe3Ad4wFvchC3sB7odbxFh/nPCJLb8oxcrJRm7Xs6HP4+KBPWXpzb3awlch
	Pyg5HSjntJI3/uzcHfPyTIYTeYVCADA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C103043D70;
	Wed, 25 Mar 2026 14:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2230C116C6;
	Wed, 25 Mar 2026 14:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774447999;
	bh=O4KR79NA3w5wXHTjCgl3Y/eCUkwrrxsmxAb2QYX2GZc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=THeeRJa+fvQrbUlWi1AzdB4xesJwfM/iMX3IW08X/F2tnmO2Sq9kSk/X2JbnvBwo+
	 iPnryERXRmcoJKHw/RDO7vBm9UnM6P4u2a/TcWW6nfb0TUYORcveAXebJPr293zK4g
	 +Ias1QKlEaBi/7zTZtA8JdEJ1rJD+alcOdsXxMvOub3PzN5vN6Q+XGM1CXkMhPMjr2
	 Csb2YPWXjwzAvXrWoN0WUbuDkR+1/J4hY4VMkUm1BHPU75vVOYy14wxbfq7tTP5S66
	 vlraXxz0FCKhIq2kJIQumHP3qwlqv9CrN5md/W0QopKDjxp/BTGH75Ssk1SU3JAold
	 B+q4e2Bddgs5Q==
Message-ID: <92042416-251e-43bf-b5a7-cfa9c826d020@kernel.org>
Date: Wed, 25 Mar 2026 15:13:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 19/21] uio: replace deprecated mmap hook with
 mmap_prepare in uio_info
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <157583e4477705b496896c7acd4ac88a937b8fa6.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <157583e4477705b496896c7acd4ac88a937b8fa6.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CF87D80011
X-Stat-Signature: 9bxf199sctfgh3dw9cjjjb6u5a35ehzt
X-Rspamd-Server: rspam06
X-HE-Tag: 1774448000-855
X-HE-Meta: U2FsdGVkX188tXvSYTY125bFgwMzfj8k+GC9W6cVC0Nor0KVqxVDfhcGYNOzAZSzk7/uXjBJTsAaxF13AvDFpen6NcDPrVMrfNAmLCvW9LoEKBVEPsrE1ypehS4eQUYiFmpgaf/TcQ+5Nvc5oVYsugR8iFmXU+SEfmMvoL7+hpItlWUuvhErdb8lZbt7W3MjZcKCUjA1DwSVPyQ0mwy0le9fo2oDPMMHLqidx4dpPEVu9eoQydUbcPNNxvecNaGYSd7G4gUfUjsssz8twdpnXnQqm1llY9RnqANghEgtEWM0gkUpYpsWOIbvmBfHa2x+G8c69h3c2lLyozyYjdeZh1xgYb2rhhsQJdq1FBMOOs3mcpgXdPa240TmnD9d+Q1elU6GAFdnuqIAXesR1KbWf61doKvzFSCQWc7DLvmN7PjC8KLE05CHzZ6KVD6wQAjJBrYVGhUkPGif1XNYbr/537f8IgdR+e/r3vrRV3D8aYgchERgHbj+M3b0sYpl0f8CcZBMcgvvSDdtULfEqw2cLelyGX2ziqv+DEx11ITrfSX8qbQ5BhHgZp5/gAkYZ8OJzJ4cVWHG/r5XYK1jDy5Em98DRJfHPzsL0yy2tk8LdP5SlWx//PxA5bvHH6Q9zcImVyCFaBUVDRMbDbfzSMWX4ckOG5SPplhPY+WlAVM1qd7P7cjmf84pGP9r+Hujbx2DTjdSUFxUdj6s3/3OzjoZlnW+SiZ+mz2CWmLZR8+k7VcnTO9DfXAGHU/4TSKpEE2+OOBMoYoyoGhAfzVW/k/fdZwd5og4MDjSIKzAHno6geIKZtWHbuoMEJ1zYIbcmNmHRXGNcvKthWGfdMz65UWJXLM1sbHYeBXSC4YN4mKiu0UrXUF5XIAmNYFJ4nl9U0XMh645OXopaGSYHf5oAji50B1ziTnM1eJethuhh25V0U4ZEA1a6bkx8dSaS2nFUetIFrC8bPgktcGyTx507gO
 rfOEoxos
 M9I1hQ8J/BcfXYFgD7RHwenUxt3wQSE9Lpo4gpkxpGCegnp2bNrcCfFvBltzTHFh5DkVfIEIOZQ+19B2hob20/VqaisvjwY502SqejdrMQv05lmXdPxEyhUm4z5HvQVE8d8uMXfVBYwWFg6C0hYTy4BCZc5ayOPuwYQSs0KWcnzgR4oCY/X1kdUnJ7MgePikbUCd+m1RT0Fi2droXET9FX7CkAHx1rWtNpuvwyCtb2NYu9eWidBOwtnrb7qds5asrPjpX0lBpyby8fBjF3Pfc0zHacoX+TPND7+lBHmmpUvUzEel8zs2Mbm/7Iwz6WShEjkUM3AygtCq1VsUzFOV0AjWuitOZ8lLUeylxUHHiuoGZVasUTefrUk337cTh+O+6v7+Hsa+5sAcnmqOLWjsjrhSnKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> The f_op->mmap interface is deprecated, so update uio_info to use its
> successor, mmap_prepare.
> 
> Therefore, replace the uio_info->mmap hook with a new
> uio_info->mmap_prepare hook, and update its one user, target_core_user,
> to both specify this new mmap_prepare hook and also to use the new
> vm_ops->mapped() hook to continue to maintain a correct udev->kref
> refcount.
> 
> Then update uio_mmap() to utilise the mmap_prepare compatibility layer to
> invoke this callback from the uio mmap invocation.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  drivers/target/target_core_user.c | 26 ++++++++++++++++++--------
>  drivers/uio/uio.c                 | 10 ++++++++--
>  include/linux/uio_driver.h        |  4 ++--
>  3 files changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index af95531ddd35..edc2afd5f4ee 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1860,6 +1860,17 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>  	return NULL;
>  }
>  
> +static int tcmu_vma_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> +			   const struct file *file, void **vm_private_data)
> +{
> +	struct tcmu_dev *udev = *vm_private_data;
> +
> +	pr_debug("vma_mapped\n");

This looked like testing leftover at first, but it matches
tcmu_vma_open()/close() (in case anyone else wonders).

> +
> +	kref_get(&udev->kref);
> +	return 0;
> +}
> +

