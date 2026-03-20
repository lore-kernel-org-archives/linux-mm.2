Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB3B1093163
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741E06B041F; Thu, 19 Mar 2026 22:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F2246B0421; Thu, 19 Mar 2026 22:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9EB6B0422; Thu, 19 Mar 2026 22:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F56C6B041F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:32:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D21901601D8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:32:00 +0000 (UTC)
X-FDA: 84564866400.02.792E601
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5684CC0003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:31:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1PMqZBSL;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773973919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iic+So6cnfWSJFFQwza8kLTYzQZwe6s8Ojm0loYEaQM=;
	b=jaaQ68jlqeM/QV5SYfTHRjdTnAqqKwrbP8jYipdwcfN//P3yXv0SRL57mC5KrO66YiFOOq
	RLLY0UUR4HwnYJcwRC/YvTBWoxBQH61pXN0pYFrsFTXnWKPHYCOJ8JQtQ/0HhnDVJQdaxa
	DUc+F9uVsPFsz6r3Hj1V7fzXdY0dVqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773973919; a=rsa-sha256;
	cv=none;
	b=kd5dRenAfGgkSzfArpA8DxqnByVhApSQPOxeWhClR5YlftkMcXWEoF1cgk1MRNS8URu7ba
	liX0cnhFSGiw3sfyd2BidGE3+vk3lKCB/LKF22/fdnMDtkmVxFyV/TinMCuAvPEzgIpWfJ
	3a6spVt2pZdXbtw/6sWQSlcUnkc7V0g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1PMqZBSL;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B1AC860097;
	Fri, 20 Mar 2026 02:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC406C19424;
	Fri, 20 Mar 2026 02:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773973918;
	bh=zWbIFUL3M1hYekmZeOoT6dRXTVuvW20urs0y5iA+FYM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1PMqZBSLrP+eQgLFj2LF6Ah+EcVk6F+3MasY6U2Od4G5bTBhHptzqIdM2bQK5amdH
	 sR1fj+9hS+/8dgC6mygfrZ75rGcEd/0lYAIcOlUfqmxSleAhT5V1CMTOf3kabUKUKd
	 ed+kJmrv2aGKw5PcIo5j404MUFiIFaBC67gOhdIg=
Date: Thu, 19 Mar 2026 19:31:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
 <Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
 <surenb@google.com>, <mhocko@suse.com>, <baohua@kernel.org>,
 <ryan.roberts@arm.com>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>,
 <sunnanyong@huawei.com>
Subject: Re: [PATCH v3] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
Message-Id: <20260319193157.7cacc7b6628e94ff62541c34@linux-foundation.org>
In-Reply-To: <d9d50263-a69f-4a16-b409-caeec93c423a@huawei.com>
References: <20260319012541.4158561-1-tujinjiang@huawei.com>
	<20260319155101.f7a62c04a7bcfc838b63824c@linux-foundation.org>
	<d9d50263-a69f-4a16-b409-caeec93c423a@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5684CC0003
X-Stat-Signature: zgkdte3ubhjqzr5nqigfh79z1ppbzz95
X-Rspam-User: 
X-HE-Tag: 1773973919-335360
X-HE-Meta: U2FsdGVkX19OJoRahv0S0aUxbjtlXPu5+YvsUvGneshkGo5Ih7HbyuPj+f8Ruvjdkzco9wze4yaJtNUO5CGtOvgS3RduvadxEpgtM/pohkGQW7kn8n7yY+7mQb1f00HbmZjENtJ69XUTficTrQjia3HSaGGiPHsB9qMlDTUNoVwwPAx6qRo0wvMdqET9yk1Ux3eEtnvT1v0BSwSwb3cJo5iXlac8qc7OFvXqna2EYJwMZGRfV5TMssyBM+y3qOycgRex2VQHtSRglM70+siHV1aTV+q76clZ7OnOcw6uWxJskINAR2xoDty/HcKqQ+GcSeqz68/0p4wxHOpiFy9d30HIgbN8NPmooaOAICCiqaSuZFdC4kcI7Pcb3z08PQ4oeP6J93VF8JImkBk9IpU9FGZYz1J+cbKkOHMlBpmYv6/yfaGSPE4UPn75Ef48kdu5D0e+xsItTa0f6YBXKVmCZay8L+5+1fWvt2mJytBszNoxhH4x/SS88OpD7CwsKxAlIrCrW14lvjKkOeIiUhgh6Jnb/MxO2bojExIi4tuX/ovTmjeGzUuUWCxKXrkFJ0VCaF718G0lVXDTtwd233QE27i8Sd0R4NjlNSVn9JxK2eR57kh7a91KNfmxoSpSNPOWpNNNdawgtFPMaSkYgyMdfCV8Met4PsLXi77vvm8tE/PASwJAwqwaFCv3YlHd/BuV80ReduZSgvW89BkYVvrP5eKXJRfE+EFuf4zdVGf1ska3sPp2fJaQPcokZL+2OyNM28sf+93N1WbGfhCVx7Mjfz4URvOhuw9kBkHrNQO/oxDRFEDCu1BWkTmCJ5YTZn6xkuXI2zJjUW60icR0PsCASV9B6h8oq+bECyzqLxVF5a7UzojE4dSpj5X9NULbYyaZQ6x3NMoZdAQOc1/jHIxWYZiMrm57cVikCzLJkawNrVAfeYtHH+3mOhNhLSP2Y7WnG61bXxPUjDBpb9hur81
 zkB33nVs
 CYoBD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 09:52:42 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> >> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
> >> are visible before the tail page becomes non-compound. smp_wmb() should
> >> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
> >> result, if zap_nonpresent_ptes() accesses migration entry that stores
> >> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
> >> page before page->flags.
> > Please describe the userspace-visible runtime effects of this bug.
> 
> This issue will trigger VM_WARN_ON_ONCE() in pfn_swap_entry_folio().
> 
> This is a BUG_ON() before commit 93976a20345b ("mm: eliminate further swapops predicates"),
> which in merged in v6.19-rc1.

Great, thanks, I added cc:stable.

