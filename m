Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4197AC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9E36B00A4; Mon,  7 Sep 2026 04:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1736B00A7; Mon,  7 Sep 2026 04:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7866B00A9; Mon,  7 Sep 2026 04:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCBA6B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:31:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2A24140683
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:31:18 +0000 (UTC)
X-FDA: 85186296636.23.89C1AC8
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6174940008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:31:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=v1azKhdb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNYbximMpK7VrrVyM2o6QdpnBm9Ldr/h1nfCIIWu6as=;
	b=WUDlAGNQLHud4tMmGDlvBc+hUUwhHw6N89n8pNK3775fGoU99xuwCVH+JhQgI762hNRinm
	E4zchpTLXR9YMrc9gBadVc/wDNgLOXpphetNOZeaqyzt7Tl6DtI73tcU6SThnKxAnwyK/o
	j8txgTkNBr2k8hTVFQA/HGN4RbisCT8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=v1azKhdb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769876;
	b=WE5bolzK2uzWnK2mTlmnXUPveUC2BUXt9KxzYHO9HDWGTdXsCKTkRtbQ/hxggAQheNgAQ7
	aIE5ZBVcmHwuoJzL4iL1d4J1H3jGln3jlWdBFrZhsHxLJW1bqekwviUBHVVpG+U2r8znAu
	GJ2h4A6Ony7pA/6pmO/b4ZTjllVe4dw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788769871; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sNYbximMpK7VrrVyM2o6QdpnBm9Ldr/h1nfCIIWu6as=;
	b=v1azKhdb/TQ1M4A1KUELEjHJLv9PxvRc9XHAZ9/1WYiFe0s4hrEJ370WnI/ZihU7+UOz+6T9cKlQJ6yGNdFg0gWy7PlWdbfmNfmVpSgd6KVV6iUF/OsRYy+dj4aOfgaxPqKqrSPgrwZY6mII9jUsqc3iiNB2QuuLtlka+7cBvWQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XARxh7s_1788769867;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XARxh7s_1788769867 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 16:31:08 +0800
Message-ID: <6367723f-f8e6-46c1-8c50-abe5ef68c819@linux.alibaba.com>
Date: Mon, 7 Sep 2026 16:31:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] mm/collapse: name the per-table scan reset for what
 it resets
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
 <ec3d193817dfa5d0e4fa2f31642c066ebfdd3151.1788533997.git.kas@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ec3d193817dfa5d0e4fa2f31642c066ebfdd3151.1788533997.git.kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7kycdepii3dr1gwfeejdp5ssipn3y4qw
X-Rspamd-Queue-Id: 6174940008
X-HE-Tag: 1788769873-586210
X-HE-Meta: U2FsdGVkX19pzTM3nWBTWhWTETUj5eijGbeinonZWhSp3sbXy9O+L3qiEARw/vgc9w5QhJa/pJh7X9P26LAUyFnTUTxDIhJSbmD3kNVM5ySdO2hVHc7mWGq3nvlskkHNOYRIya6q0VHnhQRZPGceuGdQvfCG+n8+RUqcPaNX/nsWOGxlhc7M4ZmGO6GuWGJZX7rOF2Wubr0QW15orqw9iLazjbDjFS0/8ym6zYUJjXpKuYF6F5fZUn7m4TnASORs224GqazsRCo5A99WA10sD/YmodDEBZJEl1ER5VcIPy6FB2T0GZ1OZRvCDqtinytsX8v7hcmSh6SuhNCLBodkSQEB9h8pzTwD8AD2Eqy2ULzFGYaOKtH/4xXx+C4RXnn6t7p4GwfozN9ZqnqaSipP/jWdZ4yDtn62sPwvI0dhsujxoqLDNwd/GquXjZAnFS4BENYb0sJXgrYNNlUzczrm38T+SD4al11AHOudw1TmJmMP9GwG4CtOufVTt7UCkORla9avCvW1VKwn2x8D07wmeYYI/XBpYJRbhnsgni2brhJLtpBisth5jxaeHE0t2Vrf++xAhFjYRNsG+XthRx1th/gD9s/FKA8FAcd15K3M3hEHLvzEyPCgByHD3y2k4UozlRomAD4kEt/z/H3zg81EuUEJTk81IuPrHHHXywdfnmkANvFAv7Tj4iQ1hsvAX9fzs/JpCwlp3w68T9Oi2rHb0rFexfvw1mSulp25/fUvjuJwVQ4rHjJDxIs91IGr3Bb0DzvTqblOncD1pMY3GtfbbgCT2Xm92lBlrk259D8mYOAbHY4IEu1Uo5oghwHsAzDgyky7Ymi4Z4fs1jD3RY+w/NyeGfF+S4o8ckEKDkczJ2cdFIojmMCJ0V61pO5zF6+V4lSAQBPRB1ALT4JUgPoPoYZO7/DzROX8MXBHoQXNksorL1XLshb0BVB9324jG6Z4L/eGR9Spc9tbNXsXGUI
 hD6to/hk
 LeaOCRK/x9l2b7gC1X0ermjr58gaWx2/w2E/noaMhJftWhLo6mn5v3gxweQOSXTYydl1AtY4z4RKREUYk4/2gNqFNWMHifUIUQTxbbGXBWeAEePBBTTzk/DEyZ+ff40UYYVFyevhvLkF2g1e2Z3E9KIy+aNZM0Btv8UUpZ22/1HRd5XYidVE4RM6ezEJoqOsUEPGxxRa5CdvOlP9MWySabMQGALO1Zn0qhdpb3OdBWhwPaOYQm3iURyk+t9j1ny6+cjb5yfGm4fZU1CMROdHkW4XRSQ6eAQlWQObPMOc/DhMEkB4WTI9MOFJ9Qc/LID6StP9PfpHaa1u3oMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 11:10 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_control_init_scan() resets what one scan accumulates: the node
> load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
> every PTE table a scan is given, not once per control, so its name points
> at the wrong thing.
> 
> Call it collapse_scan_reset().
> 
> Preparation for giving a control a real init and release, run once each
> for a whole series of scans.  Two names a word apart would then stand for
> two different jobs.
> 
> No functional change.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

