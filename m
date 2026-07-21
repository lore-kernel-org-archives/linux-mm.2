Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99F9BC44520
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 00:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33CA6B008A; Mon, 20 Jul 2026 20:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3606B008C; Mon, 20 Jul 2026 20:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA5C6B0092; Mon, 20 Jul 2026 20:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A23456B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:37:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1EABCA038B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:37:11 +0000 (UTC)
X-FDA: 85010919462.16.48FA1B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 59101140009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:37:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="eXP/KIsg";
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784594229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1C0EuWr3F1b93P4Qgb1emQClLky/+draKUJtiAP9rE8=;
	b=IZKyVseDKTGOZb7UNvGqRByiy6AgsfRPXQ6mmDRc6HYE3kAYBpA+/mtmOyRGueXWaRRd5/
	zNBjD3UKjuvkC0jFc0xPMQCq3wFdmS6oB+J4e1woq5T0qBftOCOpmkhXVk0RemJLurSkMt
	h606FFzUa6qM+iquoJyqRnb7JVaQfEw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784594229;
	b=ny42Ypgzd1yegW25yX+qtAGuaSkpBfge/Ledp/XP0UXQaUmS2iSqkDe6A0mmcm3Qff0Aou
	3ElhMlX5BSVLJ5MZ17LwNtJlhmGTh0MUNG4bWF6eoWizzM+VRw7EdVyoaLh2iI6MUWDJKE
	60LVR3GgBA/yPWvcGUuKRvng6+fXYWc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="eXP/KIsg";
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49CE760A7A;
	Tue, 21 Jul 2026 00:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F411F000E9;
	Tue, 21 Jul 2026 00:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784594228;
	bh=1C0EuWr3F1b93P4Qgb1emQClLky/+draKUJtiAP9rE8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eXP/KIsgTNcGZG0ecWCx3qAESwU7i+fLE7XKgVUEgbSP+W+DC2HhunSfR49qqOWJr
	 V5AexzcVOPYOeQSWnOLP7ca3aWQWqOmqdaGgqnTFOaebIlWZktdtM3dpfGrhHqVbDz
	 7xFATrfM5HCA7nK5/Bl350jRrMlXP2AdS4mTdMFE=
Date: Mon, 20 Jul 2026 17:37:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sourav Panda <souravpanda@google.com>
Cc: Muchun Song <muchun.song@linux.dev>, osalvador@suse.de,
 david@kernel.org, fvdl@google.com, gthelen@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>
Subject: Re: [PATCH v3] mm/hugetlb: Fix null nodemask in
 alloc_fresh_hugetlb_folio
Message-Id: <20260720173707.47616938378bc26a41650b6a@linux-foundation.org>
In-Reply-To: <CANruzcTi8+37K=YQwpZ51MxzDUKiX-gF6BdFMXax=ozzZw86eg@mail.gmail.com>
References: <20260705175119.440599-1-souravpanda@google.com>
	<B8DC1E3C-24B1-4608-86B1-5F12B2FF4DBE@linux.dev>
	<CANruzcTi8+37K=YQwpZ51MxzDUKiX-gF6BdFMXax=ozzZw86eg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9ot61ndwth1uwscei7jb1krwhx9756ek
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59101140009
X-HE-Tag: 1784594229-778525
X-HE-Meta: U2FsdGVkX18b7AhYPi57gUw3vI8y7ULNc0YGMhL0t5tmyNQqq5n5K7ck/cfdCxmCvuU5c37lpTDwugxVtduqGdu1BCdbc7Ew5phTnfE/YR7Ku89Uz6t43mku9tGIBKPposdSMcBMmk9eFEMriAy43b+5rjs190ue8zuq8Zfdhj5eCDjbinK3zJdkuRs86iQ+g0JcRg4XOpwIUKZim4F6B3SzwvnSF+qvMcxhvL/CIdCYb3g9u2cstt5VmZaQvOUdSoYOHFvp5ote8XnGTyBI2A3za013gKCRUUlDbbwhYDLRVBQBprzxw3akaZSCNgpmEp8o1pNNXOsSAke1mBu358I/r1R9TIAPD8uYqXhhdtvDTD4+lWW6ugzHXbKXS34RramaxLcNGCXYKKBIun4iwbf6rRRO0RvfimAkcNeEGzvpFDnsQK2sd0Bl6WQ4GB35tZ0W2lFNBHg5K1DxyTK8nxl1FbvYykv2HTWGiVRpYl4Cqb9X4fu4OtKtSfudrL1YiNNlPWz7s7WgvCAWOMUu9gbTgJl/opO+NengbZpNDw1FqzvLFFHQvRVonJbw0zBiL+FIWlg70a6XmbTAacToJRbDAhK19NuSe7FPajl+MBDIuZvKeKVSyi3YnRTidIoZY/+W/DpPNDWkR4sKfquRXt5F+krnHuoQatGX/dtppIoRlLMqOkW8oJs6fKHFswRCyK84/Vr5zGSkPDSGtTPWBfVgNleaDjOZTVi7xk2WBn85f3ZetwrlqC8zVjut2VrsARgnNjh31nXgehVgxaxCi0ZWU1muLkuF31OR9duuX1cDlModO9p+nVPa53XFVCCx7z/QOJ82bt76GLWFuTHjEXYGninix+p/3F4x6dQ9p1NkkQdaldGCwiXDqxYEvov39l1TPrujrExL4KqXRhvR4qtTLAcVlB0wC2o2RsppGMvJ9aTiYlgtV9AtFGetkzeKOEjGRlb72zU/D18ss7L
 4ZwI5jVe
 c6tNscF187ofnxMC+YPg9aekYf72yaTZ1HFvIlDpLk1ZPj7uUGg+LHUDT/c2PbsvStICCkkaR1eB8X/dj6jZqhK2GOyCfxmhhoi4pxanb5pzKh04jMX1nU6/E7rHMsFAFFPv6jr5AT1FEDZYLuWDJbCjgIJNqf1+0a4qu9OorENSAPm4Goq3fKz1g9MNxli7eccIbpmN2rhp4RWfe2m4Cxt0vPu7QASIm+RcJ6rj/z7WR19IHoAI2yyrSH+Vhlwd72Vg2cQJ7+xmSClv5anhTNQHCmIX2P7D6Q5P8ICouWJcc5mk94IAiOvOiGjsD2MLEhJET
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 5 Jul 2026 23:55:31 -0700 Sourav Panda <souravpanda@google.com> wrote:

> > - Option 1: Fix it directly within alloc_gigantic_frozen_folio().
> >   This would centrally cover both of its underlying allocation paths:
> >   hugetlb_cma_alloc_frozen_folio() and alloc_contig_frozen_pages().
> >
> > - Option 2: Fix hugetlb_cma_alloc_frozen_folio() and alloc_contig_frozen_pages()
> >   separately. The rationale here is that since the buddy allocator
> >   already handles this case internally, and alloc_contig_frozen_pages()
> >   is also a low-level allocator, it would be better to keep their behaviors
> >   consistent.
> >
> > Both approaches are viable from my perspective. I'm CCing more MM maintainers
> > and reviewers to gather your insights and decide on the best path forward.
> >
> > Muchun,
> > Thanks.
> 
> Gotcha! Thanks Andrew and Muchun!
> 
> I shall wait for the decision and then send the subsequent version :)

15 days: no decision shall be forthcoming.

Please code up whatever you consider best then send it out.  This will
trigger a great outpouring of decisions ;)


