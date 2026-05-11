Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C871ECD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0144C6B00B0; Mon, 11 May 2026 07:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2DD66B00B3; Mon, 11 May 2026 07:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6B026B00B7; Mon, 11 May 2026 07:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D45EF6B00B0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:25:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83F2C8D7CD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:25:22 +0000 (UTC)
X-FDA: 84754908084.17.BA16CC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C6F84100011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:25:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O3p0WQEI;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778498720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NcaGl+cKxLfxq35jEE3ZPlisVFb7JhDrNTimUB7tPNg=;
	b=4O6FtMWQdfA13GZH9sdgLUm/v9oYb4pO2iDSJlRueAMN7TLwaIXbJ/3OVqn/hC0+igu/yd
	Q4v20KbzWJPxnt/Thf4FfE9fEEEB6uVuB7nB4EXtBq77TUNfrjFwtdiHJEVBqdBA1vj5JI
	oD/gL3N//xEeyIE2K4sc27lK2ZZVM0w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O3p0WQEI;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778498720; a=rsa-sha256;
	cv=none;
	b=XMYSxwxD/WxT1DtpTJl0bJtkuAe/CvTVRvIC2MAdQY9P41SYMRofra7aTptSloo+Kpm2ZD
	Ru+yihGpC1jTs0mmwUNDRQunwdlOSi/hjZSLz9IOntvn5lSF2ZIEd4gVsE6Ch9bOOZ4oCr
	+JOYxHqMUSdgVqkaIB1AmLWM07UzR0Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 861FD40974;
	Mon, 11 May 2026 11:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28352C2BCB0;
	Mon, 11 May 2026 11:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778498719;
	bh=Q8rVNnwf4dEP5Fda05JLilhu6EDnhwbUwJkDwg0YZQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O3p0WQEIUGSnM4o9AHaajsmMzyXtje/e+dTwxse4bN5LQdDVpnlXIeYjt/qk6Lhuk
	 ziW02G6yvHytQux0Qfk06MJ8uEI1YmngtL9f5qbw+uGzMEwRAv6xhBlZ4TUBm8EGFY
	 qkkMNMviYPPgQJ3GYrkYaUwaNZKRlWm+eDt4NsnynJ3GAFqnpN8JSrKTuBx6CmwmeK
	 vrMmJAURMYrBZM0Vbfg9m/bIiw0cvsjkeUHXKKSddgpAq7xT4zID50tyImZj9oEsVj
	 ZfoghU3I4SIRxfJ0YXqk/x2VKBsv9pDA9F0XnpgmNRloxfe5GFJFT+MBpQRXcah/m3
	 YqcJ/4T8EmBfA==
Date: Mon, 11 May 2026 12:25:12 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, ast@kernel.org, 
	daniel@iogearbox.net, surenb@google.com, tz2294@columbia.edu, baohua@kernel.org, 
	lance.yang@linux.dev, dev.jain@arm.com, laoar.shao@gmail.com, 
	gutierrez.asier@huawei-partners.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	bpf@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v2 3/4] mm: introduce bpf_mthp_ops struct ops
Message-ID: <agG8e1U-fNbtIOoF@lucifer>
References: <20260508150055.680136-1-vernon2gm@gmail.com>
 <20260508150055.680136-4-vernon2gm@gmail.com>
 <5987cdee-9174-44fb-8e2b-41e6ad969612@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5987cdee-9174-44fb-8e2b-41e6ad969612@kernel.org>
X-Stat-Signature: 6yjpmexd9bugj5jfg33yqt5as5nagtz3
X-Rspamd-Queue-Id: C6F84100011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778498720-149261
X-HE-Meta: U2FsdGVkX1/V9P7i3VYP+I4xq+YEYslGVmiAlz4J3XQ85swMqpdr6YrXoAgegND13aNLNPjWp2jKvxMBrKth6/CQtbWniANVG1qD6j10DSUhrTZg8LMywoUZlTSyM4wSFrqst4CX14zV2+zAAbBPRMPFNJHv2W5cGZkFMfSKc0HrXjnFi+eIsLKh9KWh3Dbwx7ouN4ICtSGYF4ytl6W7jkFtnS0q9Si4szN/jjihPvWwcDFW5JoSb+eYvcsb4duZIf6yATvol7ybjX8eBNAyjwUvni870hwoyInfltjIhiA8rVxO0PNgPyHHyTDJw21ASOduCkGkepT7GIpPgxQ92nKVDlHc2zKeK/069YYB7LLFH2K9sv9jxYujcR69IfvP2ZvgzinM6YunUpC0tGf/d8inu0Yef/tLcOHlZGcBaBi/WpfLc63sjSF9PEOfkgHzAJr7cwWJMYRlRA7UQZ9rAKv+pNuUdznwBim8q53H7obCV8aboeaYkhE/7qx2Jr1pSmKDdmO3AlJO0jstr+U4mNFRYoZkMOZrNgRKpKdXBoR0BmTzQ381YRwLKRC0UfXv0cw7biIF2IzG89c5O8enLcwjaTm/Snjxj1AtZf7q0As7wlVMzMqJWs+HGKiMIgu06aO9iuRT6LS6hnczykvXmkSMWfDXMYfryVhIdRXGKjJK/ZfwiQhX78GC2nege4d73/u+apTO+ZZBz9GKXS6+/C9ve/Ii3mutqGwRwYhmRpNmX3pjqqxM/6fYBH4DtdDTlpJtTFqWhNykjNdofwQDH5R+niLhcHQjvrrs2vPIvcuHmX4av3EyOs4zgNOC+8BRrLArzSH5xE1INTIvBW6KKpCPKNHubXVBSgcpojYXyJ5Oy/Az9m4cM8q/XlaV5ajEzX2LziVRpfiUEFjvQ9QQpbl3yoAhHcz8C8dFU3/BTgOT+Yw6q4ZYz9HK1PxRKp7t8qcnYUSfSHckx4IaQoi
 mI2FGeCt
 IGExhL8FvMDFsA8m6mw+cynwcgGJq/IugMQauGe1zkyRSvkSPsE713KiGpEK/cWtCConqWThHowQzMDd9s8gc1xIheb9ZxA/1N8aRrpGnxj0T68qP1CoKfJm71iuupCW014LlrNxvzsHxZegwxt4x7AENPHuecvn04DEQOKA4rsv3GL+v5E1E37Vpj8qU9xjXgO4UDtG0e/r3avvhpj7ddF+2ZSOujSeP6p2fypWrkF58CLI+z7GRrG+bwCqyLNfcvvbnAuRaBlwt7t/dqc9cgwvvkVRFLVJZzXWFrkrDYpiIXBTsv7lTAOmQAojm8XE9ITJXu3BBwLWT2FH5s3pGKqwThYbmlRjLoxfI0q7PmvKcHj4goH69crWzKcRqLWt2p7uFPT35x5NfCsA1copPBNbw2GhzuvMqFuTz9yW8z4PampI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 10:54:58PM +0200, David Hildenbrand (Arm) wrote:
> >
> >  #include <linux/fs.h> /* only for vma_is_dax() */
> >  #include <linux/kobject.h>
> > @@ -296,6 +297,11 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
> >  				       enum tva_type type,
> >  				       unsigned long orders)
> >  {
> > +	/* The eBPF-specified orders overrides which order is selected. */
> > +	orders &= bpf_mthp_choose(vma->vm_mm, orders);
> > +	if (!orders)
> > +		return 0;
> > +
>
> There was some discussion around this in the past: where should we hook into
> (e.g., deferred shrinker?), which information should we provide to the hook
> (e.g., vma properties?).
>
> We concluded mostly to "we don't know". I know that Rik van Riel wanted to look
> into doing this properly, but seems like he got distracted :)
>
> I assume there will be a lwn.net article covering the "BPF in MM" session we had
> at LSF/MM just this week.
>
> Conclusion: ABI stability is a headake.
>
> The simplistic approach of deciding an order for the whole MM is very likely not
> what we want.

Agreed with all points!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

