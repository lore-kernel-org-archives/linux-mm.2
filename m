Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4743FCD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 20:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852CE6B0005; Tue, 19 May 2026 16:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8038E6B0088; Tue, 19 May 2026 16:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719776B008A; Tue, 19 May 2026 16:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62AAC6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:25:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 083C2161817
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:25:26 +0000 (UTC)
X-FDA: 84785299452.03.3205AD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 48FD0140011
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:25:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="G/AhxrKq";
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779222324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDssL1JLJxE+xcjIOV/X2qrzoQDIuhvVsBuZSSJ5o50=;
	b=EPSW8nyFhdVD84Uz1Dl4gKqeVKizWe1CS3kVhNmaQE/zDJFn8pnC/OHMzDQ7+s8ZC0J9JE
	ndYtWLdtnI1O87brEcE7H6/ZuCy9U1zKFYsbq/ZhrgOdSBdGzekGu0vF4Uqxp6o96IMQbM
	xFSBjZ0NQETMS04d2LjcsFmV7hwUcuk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="G/AhxrKq";
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779222324; a=rsa-sha256;
	cv=none;
	b=5tel4Lnanr3scuz4x89gAu/JmQE941bwVx4C7BLmi9qNR7O48xloyPMEbgJi3YjqIV7TKM
	iYMKjWZOa8bVArqQV0bSH4j/tYj9WYiRwkUQ7q2MoC3FtbwBY+zEDVRzIKa5umTqhA6LWL
	M7fGQaxF8VmDxoDZSYK0h3wbvP7mbGk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE77D60233;
	Tue, 19 May 2026 20:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE741F000E9;
	Tue, 19 May 2026 20:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779222323;
	bh=VDssL1JLJxE+xcjIOV/X2qrzoQDIuhvVsBuZSSJ5o50=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=G/AhxrKqZylZHoao3naUtVqUOBVx2Z80edFedYunyMmpFrNKy1Nyw+LbcVmZziH+v
	 Ey8lX+XfkJizl377m4ouZp5vlg750X6TzVR++3cspgCIzcGUW9o2AuVxxHb4WDqqO+
	 ba75mcVuDECO/FB3DSFXGLVgujDjixASzVt+lweM=
Date: Tue, 19 May 2026 13:25:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
Cc: david@kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 djakov@kernel.org, Mike Rapoport <rppt@kernel.org>, Vishal Verma
 <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2] drivers/base/memory: set mem->altmap after
 successful device registration
Message-Id: <20260519132522.421c018b39328ebc4767dd8e@linux-foundation.org>
In-Reply-To: <20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com>
References: <20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8izh9qw6ssh4zpmawqk4dfkb7sbsa95y
X-Rspamd-Queue-Id: 48FD0140011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779222324-190437
X-HE-Meta: U2FsdGVkX19QnqgDKv2W667lwvTKHitj82DZcYcQvhsIdGbPO1SbbglpZ8vS+VRWqkj19BLTdnUzOD9xagd7OpZNLmICi12Si9PU2K+g6P81kZc8jko9Lo9GVlCEP2tAdG9bamV9TarX2YheHjuOSnzvflOZ3yVgoTYRM3JNZ1Ck7w65EJfefA5PgSlCsEbfmsY9DwVmACHKRWbPr8kvxse4PSoT1KS3UX/yAz05aJ/fzINNEuiON6aYY7Ad39sgxkVIC+LJUoPuDi3KUJ5+N8XYhRnZYv61E5fNvuvFOScZrPv5hfxM7nWntzenVLAlsWVRHxrEqjaeZKeymwGNRTAJtuLpQZ7aUHPS5soZsZdY3wlVtw3LwghcmkrD+XBGOK99jA6Jd1vqzHpjPJ20Srm7cPzQviHfhM/o78dSq57Q5Ik0T8lPRFjxNr5R8M9oO+8JJ9UZb9hekhenR5FPcOexoCTFgyIKtaqxX17VEl4PMVEZ0ae//jFo9XR2D65LZiEj5H4L0tEkpVyrCCT5O6XINx07m0PFDBSKZTi9uQ1cOfAplO+gaS6PkDaTRkoL8ukbD6sSMeduwt7z25cPtrQmQlL8zyozPqyPIXMLUNZdhxg6aN0eW0aCD8YqUoNBo8z1X6jyu2kDpAou5SYgNTUmdjN4++geTYlWqmMh2TJaSovrB1AWPTiB6BqVrOFKBbJNXOSX9ATqVnnoBf4vM1ZOMSPqho5NK7nDCnKZYWuhvcYRESQ4YW6OjI0IkY9usVNcgBiZ99r4jBU9Y+rl1jQoh7DEl7kgYTViX9KfsAj62jgcfa9wkHNBVS/GBF3c2ASp04F+pyFMjoOw0IBM269ZQHKwIcnzGnex+WvO6rgRu8QOL32MxmoNHFp4wjwt1OZTtbmYoj34QzxKwZjbnAC8jdkewMT2Kk68Hpet9AmHMPg4XuGdgoPktZXOuHAzqn7BLpZxgPQOBh3hINu
 J3NnVxTS
 ftjaKQRxz25jr9xFYGi4lyri8nlcxnmL2DUHMEMS02khACTq8dL7fystWepLgeRQnlCLtTzR7ODDYPkDJZhXh6I4TgCmpCmSVpe7m6DwCXFUdy6Ihx9mvxepA3Lgs8oQTwWPg2LZoJlzvtFUFxIE0Gu1MHoh9xBra86mJBWozAm9mvIYvhFpvPO6eWMUua02A0klJSXgYeCFr/jUcwEDkQM5+wmvhomN4GtXulL/B0ZBMJok6DK57R43wEBxb7KIlD4L80RIfHxiyeTRA8lZ10ejGSdbdnJeuajxf5Wf9qSmkWyAPvtat/DpJnq1Szv/gWCbD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 02:26:57 -0700 Georgi Djakov <georgi.djakov@oss.qualcomm.com> wrote:

> If __add_memory_block() fails at xa_store() (under memory pressure
> for example), device_unregister() is called, which eventually
> triggers memory_block_release() with mem->altmap still set, causing
> a WARN_ON(mem->altmap).

That isn't good.

> This was triggered by modifying virtio-mem
> driver.
> 
> Fix this by delaying the assignment of mem->altmap until after
> __add_memory_block() has succeeded.
> 
> Fixes: 1a8c64e11043 ("mm/memory_hotplug: embed vmem_altmap details in memory block")

Patch is nice and simple so I'll add a cc:stable to this, even though
the issue seems rather minor.

btw, AI review had no issue with your change but might have found a bug
in create_altmaps_and_memory_blocks():

	https://sashiko.dev/#/patchset/20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com



