Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F9DF506D9
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169636B02C0; Mon, 16 Mar 2026 10:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1148B6B02C2; Mon, 16 Mar 2026 10:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0160A6B02C3; Mon, 16 Mar 2026 10:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF2A46B02C0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:45:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A3A01B7145
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:45:10 +0000 (UTC)
X-FDA: 84552198780.15.6A95792
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id ACC3518001C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:45:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m98+rPVN;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773672308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pReGV7Ut9I0Ia1hsNDi3iX5iWo5yNsuwGzcwhPtpyVs=;
	b=HRUmLB22lJb7YxZGJT+Fne17NVmAkaxD7oKzfVjTb9vleGZPHTyNmreNsyw6oPiG/YCGPm
	RTT9bFjCFDJCoYkxqnvT+IK2kwDnmfdB7RigPtAUAp9ZCD7wwJWAdGcqrFzvnV/MP5Plyn
	VNJkgd1CHYvKwPAQ6C66XfXrGAXlPEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773672308; a=rsa-sha256;
	cv=none;
	b=jx/QLpUHP4i7zZjR3kO1ATsKxHiJgBY2aWyUG8hmszxn3AMVSFnTkc+rM6EUCzcYqa2Vq1
	XtoRIi6TkQt94PThjv1csW5v5oLKf6VNl67LPBn5ZGQ25L9rXvND97toGnkcIw2RJHSGSH
	vJPQtaFcDTHG++Ghfj1lTn6ezC+npEY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m98+rPVN;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 198F860097;
	Mon, 16 Mar 2026 14:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D42C19421;
	Mon, 16 Mar 2026 14:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773672307;
	bh=On303YtFpKBMUZ4MRvTB68bR7sjIVS6WfsRTgzfhCsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m98+rPVNWPyA4LsxuXpx05R0957zElnKEOCzSZ9hI+vDsIC1nRBb29YuOy0892pXl
	 tX88Qfei/mdYNhf3xUuvWSapuU++AGrnIQ32aZ10gMMhU8+VU4sXV6OzWMJUpJsAdP
	 Kz7hRQKW6tmDczIkeswb4DM3kiW0+LPnAvI/LwU5Qcj/UPw4IyZsP7Shnxp53FFuhA
	 8iufgBBsVY0x17OAQWgatGGok2a7VOjn8giT0UOU6BZBKK3Toq6luGPrRq2JYzRYtP
	 kCVfMQjAtAKU2uNxwAkRb7XzBY1fJpSMwJFqAiw5KElqwWWurLkIz1jzfsP2vU4tgv
	 v3ZeUF4lEbs4A==
Date: Mon, 16 Mar 2026 14:44:58 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	oe-kbuild-all@lists.linux.dev, Linux Memory Management List <linux-mm@kvack.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 01/15] mm: various small mmap_prepare cleanups
Message-ID: <9242b643-da61-4891-801e-6d2092bc68c7@lucifer.local>
References: <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
 <202603130825.eFqVjdWW-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202603130825.eFqVjdWW-lkp@intel.com>
X-Rspam-User: 
X-Stat-Signature: zp3ucsdaa3w8fgx5ea4zspycpsxy7ao6
X-Rspamd-Queue-Id: ACC3518001C
X-Rspamd-Server: rspam03
X-HE-Tag: 1773672308-671544
X-HE-Meta: U2FsdGVkX1+/a+iPPNWhn/8qeXfz50AS+hSTd56G2uiuwTWjOf+P20Rb3OQVGIDbcKGp6D1YzGn7P1meHCxDq3sBBGFdsjKfQPqAXV0XovkpmodW3SmpmdOdvbqjPlZ4fWPjJkH/VgqX8pF4k6rHGDK20cj+nG5j6jpGWas98hZwnWD6yB/9ksZcI1MucHcyM6/srwBNPqRnDQUmaQXZeNf1PB1hBlz54TUMCp2dQGHzrH9FOW/0PxuHjvEh8VX1Lxj+V3IEthii7RyowIu3LSw1Q9PCGcE6Rfsz9OjzzGtIoKHTtMlHv9/WsoRRAdzGdbdjFXeCSsipFDpi0vJv8Aoo24sA/sUJrwH9s5hNnQv1SDxlc//5SWJgJpxSeHztmcma7el3A4TQjUFqfkR6m+IaQz9uiVXqgWGkbSD/O0eStwIDqEvDWWx38KABCEzlHnCec+JFZAm/pQbhNcJ/Fxd5KoGC5Z9xM6i3HEv18Nt4DJLudraC10zvMDkOXLnSOY6u0CV2jKuNlUvdtaT9CGk/TMp7xnviroJsKxPIdauYYwm4q9+YIM/0aombegTNZKEtUzPUJHTpOTyHopwnjDeyZZ1MzwOO6G2Cn99O7CE+u1CsWNSyE07PJUEYlT3zaKi/AIlj+vlmccYs2OBEjTOb2Y8+ccb4JSWzB6yagLJXmDsJf6RK9xP90my67VVAyfptUGZlIjXUhY2gU8k1kEIzPQ+WviJn5cRo8zxlPfgPSS7Jq3MP78pHYaEGXzsrgCgjaGqEthpjmGoYCLz37lvG3XQUHGvgNgFCFujx8tsgGDoAHk+hTjs8uMzW0eWuLX0P6gp/UIIsQ1sClQtxiLnOMkcU96TXEKqG0fkUsiUlYFsrWdDdzUhR/tc3LRnc3bE3MWkuMpuwcXICJgSAsn6DuVyyt40Tc53xWZqqqkzsIoZDECxUaebfI43c9k5uZQK/HewPo4EblwmmroW
 3Har/kGG
 eLU7RhnUrh15L2s+PYtbguPPIuclgsgtLv8pjLygfcPpZN1GC+GYa8PR9D0Efk8u7B/nGOHDDL9oqEBsGL9PWDbjDE3WitgNHedCnJ+gJO+mNXocTN3Y/2X/FZA7UCqe9dN1ARJBvlKlnUMSPCbNC11WYGD51Vy9l0u+Nohxo4sqXhTtXccfEXWkOlESLnFfyPEpcMlLq8Rhnwj61DIOLchK8GfWB7kwFuQfklA4P8sFh29VIkcnzhy83awjeYLxM1JmyUqymTU3fyBYwrQ4tupnyQUXrjxAQxq/aFfKNf4aU4Wbhtr/uH8nc7x2Rbv9kPpXEYK6GdtlBpGB5qYNT0BFSJDE1wun0Zc1qsegWuWe/AO7Eo92kORKbRobQqERwEXUD4eiEyQ9wUmRsqw75cnlS02KmYyQkx0/JyZXlJy1R7ce7te8ZdV5ZIcZBb2pB19ywBbwofcraGMycXmjss0y3PEMNvlBq5WTkN82wO0VfM2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 09:00:33AM +0100, kernel test robot wrote:
> Hi Lorenzo,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on next-20260311]
> [cannot apply to akpm-mm/mm-everything char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus brauner-vfs/vfs.all linus/master v7.0-rc3 v7.0-rc2 v7.0-rc1 v6.16-rc1]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes-Oracle/mm-various-small-mmap_prepare-cleanups/20260313-113314
> base:   next-20260311
> patch link:    https://lore.kernel.org/r/56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs%40kernel.org
> patch subject: [PATCH 01/15] mm: various small mmap_prepare cleanups
> config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260313/202603130825.eFqVjdWW-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260313/202603130825.eFqVjdWW-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603130825.eFqVjdWW-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    mm/util.c: In function 'mmap_action_prepare':
> >> mm/util.c:1360:1: warning: control reaches end of non-void function [-Wreturn-type]
>     1360 | }
>          | ^

Ack yeah, seems compilers vary in how they handle this :) will fix on respin.

>
>
> vim +1360 mm/util.c
>
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1338
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1339  #ifdef CONFIG_MMU
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1340  /**
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1341   * mmap_action_prepare - Perform preparatory setup for an VMA descriptor
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1342   * action which need to be performed.
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1343   * @desc: The VMA descriptor to prepare for @action.
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1344   * @action: The action to perform.
> 732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1345)  *
> 732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1346)  * Returns: 0 on success, otherwise error.
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1347   */
> 732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1348) int mmap_action_prepare(struct vm_area_desc *desc,
> 732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1349) 			struct mmap_action *action)
> 732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1350)
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1351  {
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1352  	switch (action->type) {
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1353  	case MMAP_NOTHING:
> 732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1354) 		return 0;
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1355  	case MMAP_REMAP_PFN:
> 732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1356) 		return remap_pfn_range_prepare(desc, action);
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1357  	case MMAP_IO_REMAP_PFN:
> 732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1358) 		return io_remap_pfn_range_prepare(desc, action);
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1359  	}
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20 @1360  }
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1361  EXPORT_SYMBOL(mmap_action_prepare);
> ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1362
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

