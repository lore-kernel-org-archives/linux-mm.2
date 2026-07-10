Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01305C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 01:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 895286B0092; Thu,  9 Jul 2026 21:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846BB6B0093; Thu,  9 Jul 2026 21:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737D96B0095; Thu,  9 Jul 2026 21:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C41B6B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:53:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE09A1A0322
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:53:23 +0000 (UTC)
X-FDA: 84971194686.24.43FD80A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA30820004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:53:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1b02jHio;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783648402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5WePhdn0vM41AQZAytpqz+CRuhLkoEsVRrLRpGTVLs=;
	b=tBDEClH3wJZVEPOaiEI8Ux6zSbp01ZcETe6pZ/ZynpRA2jJnMG4CTdPf2kTewMbk1Jnsx4
	+Sd0ng56kwnU7aLfY9SwF66C64OQUzugAhYfbntc395ZvBylW7fK3KgZNzo7uwRURRiPq/
	JI4GtuFdOWi9xAzPl1ldtZP5+HC4p5w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1b02jHio;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783648402;
	b=fL3c/Sk4Vusla1OKNYQazMD46ggyedDinwT1l59jlrogsvNKu86/9G0iKhG2OFRI/TvvZG
	MjJiMKy1zyXLfeXjjwvmON3dCQK8ui1ce92MRxGCPk3P9qQqvUhUCg1hTfbOoACQJ5CBYe
	sV4Wg28c1KT/BuORgqkaDcFy2zl9nPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D0C36001A;
	Fri, 10 Jul 2026 01:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9CB1F000E9;
	Fri, 10 Jul 2026 01:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783648400;
	bh=V5WePhdn0vM41AQZAytpqz+CRuhLkoEsVRrLRpGTVLs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1b02jHioGv7QDp+jI0I5SMN7EUOkmf64ry1tpnm7kjslq1G5+6Gz1TDKTYLrC6j4T
	 MeIbQIL5Z5sRxDPbsmux03xqN4aybxaWzK47JWq6JiSmGh/7JvD3n1GSm48O6Duzfm
	 LAjyMiPqsIXOMpgUMlUhHRz4Dux9GpLIgLuMYxHg=
Date: Thu, 9 Jul 2026 18:53:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Ritesh
 Harjani <ritesh.list@gmail.com>, David Hildenbrand <david@kernel.org>, Zi
 Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain
 <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Miaohe Lin <linmiaohe@huawei.com>, Venkat Rao Bagalkote
 <venkat88@linux.ibm.com>
Subject: Re: [PATCH v3 0/3] selftests/mm: avoid false failures in hugetlb
 and KSM tests
Message-Id: <20260709185319.cbf0c39dd47ee3853d212b7b@linux-foundation.org>
In-Reply-To: <cover.1783446924.git.sayalip@linux.ibm.com>
References: <cover.1783446924.git.sayalip@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA30820004
X-Stat-Signature: he9o4yscqqcnp4aoabbxxo9wtqnycysn
X-Rspam-User: 
X-HE-Tag: 1783648401-94078
X-HE-Meta: U2FsdGVkX19JHj6xCXtSdGIvZBiGI2F4wh1GB+I592cvzewJJftCMscfLk76NSLxDUccC5Y4EbR6TXPYNSjc1brt8rUV3vHC66erpYydlTUnfZgkPYaDjnCicFltpa+p/uJ2ElHoMTSvV5KGPQg+zuaSa2tWF5uZ7wuCvie2y5h7QSiCy63zCaMv7EmkUP88PQ0f96lIbJgKPda35oMSz4rTnJrMwfyEnQiPSQV/1N/If/UzHbL6vvcWYvBkkFF1Z9rdl8sctc3oSv9ZCMeOip80CiS9eRyb6iNvbwsAJ7kkGw5r6ffdKQ+x3azSNIIvEwmlu6R0sgtb3+SqstftBMZMUXR0u+/Ow6twYrj4yrGo8NR89Gd2fwi7zKDxYvpRpVZJr8nq6J5X82DdkxyUOmQOmZRUqKa/9sixSce+74x5IMsnSTRCcSq057YJHlwSoL2NpP+LuEcRbfqbTxgMOwKi6ADSlHjVsaDnzIaOI/78h60H04wED0GURRcMM3GPGKTynnUFO2N+A7i1DeTCTk+7379T5MOoNKgECi0JAIhjNgTrQJL7Npi/tzBzV7PYTu7NOKgTes+WhoSsljrTBAGnFu4aijqwPZltYZYq9darqlbW0PMKCmpa9dmfx0MsQ5CFXflIADnfnjebIS49feyUwEOJZBthXRkn3bRAo2YA7XceCvSWHdcBbDYh7hxOlOdbEOglg5x34urpDfrx8SUJtOslXJVM5CcF4IVNtjv9E9ROqPpHxbRLp3DHjMIIh9TS2swW+OOg6CPYaf4ux3lkv5AmTUUBLxW0646LlhOGvgZ7vgwUlZv9uCCzESwI5F/HDReGfny+pqz1yBt0dJBy4itKODKxp0pNIAguk+VjdOaGx36Om7dbaHOQwGwH2u5sy5qMi/n+URYhXH4+KAhyL1L2M5I7Qh9zVblKfsYynHPdXGLbDWZHir8XkEqR+KR7WhjX6Iu+UKmi2jD
 U001rVgj
 jikhi8EksYcu6f5UBWX7IOf8KVMmFAaMp8/t5xrdKGG3GESc+GYBHMYNwA7RK/K9rHPalANkOtACltQC3MG3xvXigW7wH3d8pR5oV5W335Oan/ekeeY0fqVtEOBc6JrAHuwAJna/XVP85lePnrJMMulQVlmDbzStlOdNpfNxKRZ9CXRiHkX+kS9wRaFkmUTCEQh1Y5wrM72eXwnagMTN/L1b7+uXwsu11ngQtCqDZUOEnSfRkoYf2YPBZjU/sYv2CT6ZF3iSJz9j+Re/QtRew+kyiT8EALGP4B6FBLmBjLiEnIg9XBfznOQASRGzHtKnSwrS9xlTBM47ycOMrVkEf7f2BkkvkeBEDt1D2LrPkcfgykAgX1XSnoOHBlDJCfrtEet/QrHurtQvP8yJOvLIzOSmqHvnvl8fi51p1CqE5AB0Mn2bw4fN+WOZOTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 12:29:04 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> This series fixes issues in the hugetlb and KSM MM selftest categories
> that can report failures when the prerequisites for the tests are not
> satisfied.

Thanks.  AI review asked one question:
	https://sashiko.dev/#/patchset/cover.1783446924.git.sayalip@linux.ibm.com

