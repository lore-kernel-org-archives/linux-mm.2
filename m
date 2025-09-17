Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4191CCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916278E0083; Wed, 17 Sep 2025 17:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EDC98E006B; Wed, 17 Sep 2025 17:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82AEF8E0083; Wed, 17 Sep 2025 17:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74AAF8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:48:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E84613B707
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:48:49 +0000 (UTC)
X-FDA: 83900082378.21.6C6DB22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5BDF9A0004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:48:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S3VrwZvu;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758145727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5Gv/GKMemcNwy4qxnyLDJBEI6aa9LmcrA//nexFz7o=;
	b=0riDBadheZ/oUPH5YAlq6GmdOVvV7npJERe4IVd/R4/Do8OnBp6h5zAHTfEAUxQYxx1PLO
	3hjzUMz2IesGUtmXd0Wspl+mxwTFAGdBBst0jyTNMGQw5e57dTDPpex4J6Q3n/xJnseKWb
	b7Md+4eY/gbnJ/y828fdS3JQqT41oLY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S3VrwZvu;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758145727; a=rsa-sha256;
	cv=none;
	b=lEJnA2sedRfgG0L3j7Nl+QdN/xSrnNIU3Aeoq+ezzVxTKx6mR8LTmOg+jj02O9PosNRUpm
	n1GEFQKnLoQfLLZAUjGlYDnOuJuR5MQpXOsxpyzu0/t57skqsFyBdUi0Id0V95E0+srS94
	MWerdlEcEjAHXGf8hSvNJXqkUV2K40w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F5A860055;
	Wed, 17 Sep 2025 21:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F57C4CEE7;
	Wed, 17 Sep 2025 21:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758145726;
	bh=4JnhbEe5JE89mQvE/RjARCCmQh4RoVQ/5hH2rSV0bYw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S3VrwZvuIUoHe0nbHYZad41XZdFdWZ7NJEddMUeLeK92tsiIAyP6/3CQyOXHBPvCR
	 aDr3TuwL7uUf1R4BxaslOy0FDHegR+bJ4h6PUghpg1M0T8tPa8OSvC/SaMd64FPrLY
	 DJIRVjSYqSaJq4mSkAyAt7A+LaledwS2ZtD1AXlk=
Date: Wed, 17 Sep 2025 14:48:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Chris Mason <clm@meta.com>, David Hildenbrand <david@redhat.com>, Oscar
 Salvador <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Rafael J . Wysocki"
 <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Alison Schofield
 <alison.schofield@intel.com>, Yury Norov <yury.norov@gmail.com>, Dave Jiang
 <dave.jiang@intel.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2] drivers/base/node: Handle error properly in
 register_one_node()
Message-Id: <20250917144844.e8d9b9593aac9f3a4b52a0cb@linux-foundation.org>
In-Reply-To: <676712d1-7b4f-4614-bd82-5b0c43881865@linux.ibm.com>
References: <20250917134604.2149316-1-clm@meta.com>
	<676712d1-7b4f-4614-bd82-5b0c43881865@linux.ibm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5BDF9A0004
X-Rspamd-Server: rspam05
X-Stat-Signature: yjpgxx81qob5sfg5mqywm565myhnmzx6
X-Rspam-User: 
X-HE-Tag: 1758145727-97000
X-HE-Meta: U2FsdGVkX18sML3nNvwyN/Dc0AKkt6h1EihQPJHi5/eWKYC78UfXj93NGG+0pI6fNqH36zg/e498ZD8b8BbWalS0fTtv3mp4OfEMf5Pt+hQszAngoW2daNm3M/yZ8oWefdDy84kVfQiKuSu38RXjLPnjGxfdtkppDUhe2YgZa6Ls1R8fM35/barqf9DzGvnWgTBnesIUGpJmjEsJIcZDlm+NrNshQkL5kvP/9TBWvGljBaeMMiSTn9nbsHiomo2b4nFq+pbtG+FxGGkIqmGk8PQKOTQKyqDSjf3xA6iYXCvkiAOimm0wxgxFAQNauh7dfz0LUkZDHH64hQFRiOR7sxWLrW+r9bhfzkfYq1CE2X/S5jnmRDe40W9j6tYx8S9LBOkPhU7lSoD+00UnHHAClp9DJMvCfJ0li5wrDiw+C9f285nTMnRN7owh1DnopBPj4JPbVfA67I1O6uvbGo3nPvCT4tgmdMeJeJ2Ri/la2L1gN4g7YY1jVUOChWoW+ZlBtKga4B5aeUMBcjj0afOLsbgAOYk6V1lAoU0uMb/MS51xyIbFcRbN2WCYHTRpi5hb/U3EIscUacgem9FSdRq77VZ72p0GJbxlDH8GztHXe33SlktTppv89SXnybiZeFiNlzEVYwDLIci/FxDs3ztdIkiN7hNqQ+a+3HuhM17nzTKbrwHaX2/gXNVh4jEzzd39r9kni3zHgShimgb5j3WN4dBWO6sG0Z0DwCkM6pE19EMdvIfOA32SGDQ82RtrLjkTdunyx1xOjn3i6DPVqB9GCCEh8ylkMfsb988rwf+iS2I6qyCzOgoSzlnNBytKL2+Y51CnSMqIIb3UC94EQaSCWkxLtloNb6dt8rpfsD6SpNDZlKREE/dE7HHJcy2qFLCFPcIeZjOVuKse+zQO1GkTM6Kcv+TysM08SYr4GobnkBsDpTqs5JWlD64hc++2GDb9kII94htmKtrpytZ+h8G
 4SHLOH3H
 YOlg25StHL0H98eZOyBu2a8Z8diIfNBnfMW3LENduNCjFRVk+vVe+LasAyRKLNaVOF4EiiF8GA/ejTPDYC5dlBvP+SI9B9deTqzdMzlIcsKzVwazFTGeu12Vv4Od56n7OnEyV5Pj65Gz9gooUNS/Iyk+I5VJsfpCtKsUcRzNVZ8XTi0HZJXUv2Ia+3yPaqdV+Hk4F+ki6aXBtfg+lk27S5h0t7WBGeG2Vz1g8NF0ZJU1mySVvKpvccnWgCNgszvkGcJN6zho8bJ2zwj1GnRfIosX37+qUFEiC6TOLFnjLG9DO+JW+k8cJdEJH/+FQoNSB2+g6VI5n8SseJGvQaZOiOQqiqeCoeuP9Lzk6a4wp8xThDXplcZMTyWf7Pe+kZyqKH40GO4EZ0/FJzHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Sep 2025 20:25:48 +0530 Donet Tom <donettom@linux.ibm.com> wrote:

> > Can this cause a double-free? Looking at register_node(), when
> > device_register() fails, it calls put_device(&node->dev). The put_device()
> > call triggers node_device_release() which does kfree(to_node(dev)), freeing
> > the entire node structure. So when register_node() returns an error, the
> > node memory is already freed, but this code calls kfree(node) again on the
> > same memory.
> >
> > The call chain is: register_node()->device_register() fails->
> > put_device()->node_device_release()->kfree(to_node(dev)).
> 
> 
> Thank you for pointing this out. I will address it and send a v3.

This patch is now in mm.git's non-rebasing mm-stable branch, so no
replacements, please.

A standalone patch with 

	Fixes: 786eb990cfb7 ("drivers/base/node: handle error properly in register_one_node()")

is the way to go.


