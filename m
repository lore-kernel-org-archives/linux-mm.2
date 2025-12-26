Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B052AE8FDA6
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 09:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0CF36B0088; Fri, 26 Dec 2025 04:48:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAEB6B0089; Fri, 26 Dec 2025 04:48:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6676B008A; Fri, 26 Dec 2025 04:48:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B90C56B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 04:48:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 487498C8E5
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 09:48:36 +0000 (UTC)
X-FDA: 84261147432.09.44E23AE
Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	by imf22.hostedemail.com (Postfix) with ESMTP id 75FC1C0003
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 09:48:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XxnHTnzk;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766742514; a=rsa-sha256;
	cv=none;
	b=WtuxASlQTYxVst1EZECuGvspOga3GQHl9EvvfdS48frvPEHmSkhGHrQC6G+CHTFVtEGlMW
	l+NBVzfLhAkMnl9dVX+05wmnbyZrGkKexhxKvsqhVOFktoIl1bnFSMb+cpZaPqh1+imKCI
	1TKT+DmXTAGKuUjkIgSAC0DAHJ42W+8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XxnHTnzk;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766742514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3AO83U5tFZnsjnaXnFIQ6cNSEJBUHuzzrUUDaeTRII=;
	b=Ac+vhzRcBelcrhItfEcKihQP7Jz8PAa0f6UOftAb9IwBpRzPah+4bsWcxz3z3pgGwElOqF
	V0l6UZLmMX3CWqnztPq9eCwmhpDvTFGpcv7vEkw+PEEmozHUojOv4+S5Sjem9MFrmIquOz
	yk96qJPI8BAA7ic62DhZbUt721ldMfA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766742506; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=u3AO83U5tFZnsjnaXnFIQ6cNSEJBUHuzzrUUDaeTRII=;
 b=XxnHTnzklg4S0JZKWlnQRDy98w1iZwxzduLhLwg+QTL4G9txD5A5jgjEddfqM+Ybr/YNSD
 +6yirU060Nrh9nUB3vV3Rbkul93fCl3Hc0yndr8bbIohQ1c3sV0YE7HpV9m83OGVjhqid2
 wns3OUhsXVd7+aZs1tQrqtgGOPzglTdpt778tiTRszi3Ms5Zo2xYIzghrQQJrdzmTXfMi3
 +4WeTPxJMovYMEWovoHPdFpdb5ssAm9X8ht5vPn/ewMUAK3wpOYct8QO2+AGH/oVoB8Eu/
 3Bfnb3BYRR/P165kM9I4kujXcejLdes3on/1Vn6ufybWsalB98yDuIIMHH0a/Q==
Content-Type: text/plain; charset=UTF-8
To: <raghavendra.kt@amd.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <fvdl@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <muchun.song@linux.dev>, <osalvador@suse.de>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+2694e59e8+1d3041+kvack.org+lizhe.67@bytedance.com>
Subject: Re: [PATCH 1/8] mm/hugetlb: add pre-zeroed framework
Message-Id: <20251226094810.16013-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Date: Fri, 26 Dec 2025 17:48:10 +0800
Content-Transfer-Encoding: 7bit
References: <46bf07b6-633f-43b8-8e2b-b08d437494b9@amd.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <46bf07b6-633f-43b8-8e2b-b08d437494b9@amd.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 75FC1C0003
X-Stat-Signature: fy1pzqbdecn9d3y7xiudheg1xm88hqsb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766742513-525293
X-HE-Meta: U2FsdGVkX1/ob6wrCTkPmeeON0GChtXzv4v90YUFrgeKnVs8aAAAnCtaIUb6lg8bgZ2VFy8Q+NYnSqRH64Oyk3hhD8qq/CmISjFpcZIgepUq5c5MCSXMwLyhph7UoUH4Wu8A9MYl5zkz6RzDbc57+AczJAqY9ywI1CmTWWbb2ulgzchtLlnzdWLIVvKNNp33cT3ToflBiCijqxnWEbmslhyhHu2GyLVrt/A8ZTmo1kQ8Lx5q3XMq9n6Bees4m9iNHr8R110f4wznVCWpIEDBB2byKTW18/QYe+hV0AxQCXrQ+8bceptCif3KRNzUuPCKd+tNYrbzoA9+P3DOxJnwDSQFhekjMlupkuVPi5UmLcu7OrctdzdoEzc0mxd6LHpjZ9arrgQDtP96+BDMmvwm4rU9Ukw8d/Id/V9qndUln/jpdQsZzaVpCzX/SKuKzFbBqmesLzghUOQgAhpo9ZPXYbHZuVxmQW0yEoJ9xqqubLEZzTaLzNMUEX8zoQjQV/Ns/2eEgfz0K37GeIqcK/0BfKIUUjuhUO2/GpszNF893FsQ8rb+r+HgtlNH6B+J5TQGFuI/X02jFag0sYXkh0H96wtAkN/tNzRvDaXJl75k0ep/hZoP0oYV6vZ29cVyPTfomo70npvZb6IEzxbqx23I/UTjsHP5K8+3G+1vxrNIzRsovaEEE03rsuNBNCWVNFEjUhhb1ux7MaCSG1i/7nKh5b6AK0yaEFb0ahMzvC/Rcw61XLuVMD+ca891OthWNJKD8BXv59Erlkd/vUxPwMj2l2CSH7/2o1BuT8uVeZivbfMLFV2MM/u5ENS0H6jDR191NftSh+/Kt36GQ34FmQDCft8k59dzdQiwL7lcOcgR5DIzlJRTztyglqTy/DBbkdeVOeYXYES++xMOQcVrvUXAiBKdgE0z9E0DjXzGNYpWpcoGyLnzysjZVMnlcM3rP4C4GI1AX/K3WhRBkkf8Hko
 cZwDx0/s
 FXi4XuU/jhhLNi4P/j5PqmIPPd5Fmd80fnTPoFnW77EDyduLlcAdnV6BPm80qXaWVy4xFzDXhnWpb2hxhMWI74pePJdzSRg/l/r4kXNF3bPvaeQY2wUFn576E39Qd+ss/xkCZj+mxcv3Y1xtdabzq4fxbiDW+HQqwtalFhS0ZexQhwgLJli3ycsZaBsUaIGgQlG4tPwAcEmEJ70coFS3JjPPSeFdbs+9ueblq7UFtY3PgxraaPBDM6EbKyYXJKOF2X8Uq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Dec 2025 14:54:17 +0530, raghavendra.kt@amd.com wrote:

> > +/*
> > + * Once a page has been taken off the freelist, the new page owner
> > + * must wait for the pre-zero thread to finish if it happens
> > + * to be working on this page (which should be rare).
> > + */
> > +static void hpage_wait_zeroing(struct hstate *h, struct folio *folio)
> > +{
> > +	if (!folio_test_hugetlb_zeroing(folio))
> > +		return;
> > +
> > +	spin_lock_irq(&hugetlb_lock);
> > +
> > +	wait_event_cmd(h->dqzero_wait[folio_nid(folio)],
> > +		       !folio_test_hugetlb_zeroing(folio),
> > +		       spin_unlock_irq(&hugetlb_lock),
> > +		       spin_lock_irq(&hugetlb_lock));
> > +
> > +	spin_unlock_irq(&hugetlb_lock);
> > +}
> > +
> 
> nit:
> May be simple enough chunk to introduce guard() above

Thank you for the reminder. I will address this issue in v2.

Thanks,
Zhe

