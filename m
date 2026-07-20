Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D718AC44521
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B079F6B008A; Mon, 20 Jul 2026 03:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8016B0092; Mon, 20 Jul 2026 03:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0C96B0093; Mon, 20 Jul 2026 03:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDB56B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:38:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEF761607A9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:38:29 +0000 (UTC)
X-FDA: 85008352338.21.CE114EF
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3D8F740004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:38:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784533107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zAbM59O49KPwH5XY0wgpFpo13rGjPB0VS2W1ZbFZy2Y=;
	b=R3E/IgmwtfOuuIYqbFMWTp/EyrYS/vQ2ctVAEzlZlGRfDaUp9KPBcf7tP485g+URwzSu53
	Yq95jzXB/Kxo3cMho3kQnKNqIuRgNub9MH0zmOcadwbn6fK+4W45ZM5wSQkjBrmmi39BP+
	+Cl/n70/6zhgwIh/XXuQtyXCXVx1agw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784533107;
	b=UjVUZJdtx9/dRYAGn6N+SkStNuOKtX4n3/Lx4JPdlzmVjHNzl30ZA0h5HShU2z6293qe9S
	5UTH+AbgzEo3Ls5sc84kZhh1rXCBUiveF5e4QsH8JD1+FIGlJl4tGqM0uISlrAOofR2UGa
	s2eX3eVyfqHNbAFDZuwgBOHd1orzXQY=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4h3XSG5Xwwz7VD94;
	Mon, 20 Jul 2026 15:38:22 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 66K7cEmj047214;
	Mon, 20 Jul 2026 15:38:14 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 20 Jul 2026 15:38:16 +0800 (CST)
X-Zmail-TransId: 2afb6a5dd0685f6-f3887
X-Mailer: Zmail v1.0
Message-ID: <20260720153816171RRd991pToocX8jt6806EG@zte.com.cn>
In-Reply-To: <al3KlYMbmeR6iDX8@lucifer>
References: 20260717-b4-scalable-cow-virt-pgoff-v1-1-cf24910ef094@kernel.org,202607191155425057lNrNOYTi44E_jmidmtkn@zte.com.cn,al3KlYMbmeR6iDX8@lucifer
Date: Mon, 20 Jul 2026 15:38:16 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <ljs@kernel.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
        <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
        <mhocko@suse.com>, <jannh@google.com>, <pfalcato@suse.de>,
        <willy@infradead.org>, <jack@suse.cz>, <linmiaohe@huawei.com>,
        <nao.horiguchi@gmail.com>, <riel@surriel.com>, <harry@kernel.org>,
        <lance.yang@linux.dev>, <kees@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <baohua@kernel.org>,
        <usama.arif@linux.dev>, <matthew.brost@intel.com>,
        <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
        <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
        <apopple@nvidia.com>, <peterx@redhat.com>, <chengming.zhou@linux.dev>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAwMS8xNV0gbW0vdm1hOiBpbnRyb2R1Y2UgVk1BIHZpcnR1YWwgcGFnZSBvZmZzZXQgZmllbGQgYW5kIGFkZCBoZWxwZXJz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66K7cEmj047214
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 20 Jul 2026 15:38:22 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5DD06E.001/4h3XSG5Xwwz7VD94
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3D8F740004
X-Stat-Signature: 7kph4ankwgj8qs7uz6e7jyfopeitrk64
X-HE-Tag: 1784533107-464440
X-HE-Meta: U2FsdGVkX1+wsj9ZGgQ2GSe+pQhODcJoVpalyS19ni7VO9guRev7L+kwzTIJCTX8G/yPf1mo7sbSlAqXVC7DALJEjHs2HYe6XStaARPTSIz4WHvhxh2ztY9DpijBelXQbCKy0gMHt7lJ3/d513PyG/8I1GUiqb47rVGy9QCSjsZAqs/1Fo0jH1GExezCJiDS91nOOZEIXasRs5PND/0HtY00DeP6jifzAevW9JxiISkBCl1f3LTrGi982Lgk/uQjwxWblokptwgymF7n+GAY9dCWSar2iQH9ezITs4oJaA17A3L6ioL/gwfeDqaucX97bcd0ooz1ctoNbK68qUTWJ1dfPReUp1SrmpPrxpvxnvhbXjdDM/BZslK2IIk2yjPkmb79kd7sq0zvSPb4/8iE/ybUeNHceF+hSqzXsP77/js1xQtRAsiezWfQxH3UrYnSIcGfXJl0RLPpOr2yd6OKG+Jnwf1PYf8UHx4/62HMJO1BfKM898VuSSTuIfcghSSvhe8fZS6iNaB2Zjlb6iQfb2HRWiOM/B5dGmmDI218GifRJSQOlv3rauaL2DDmQKI9iwUJJM2cXpHT4o4uwor83WHwgtChqX7nq+rC1OCd+1Sz1+mJJYHJ06ZjTDG9AiAMc+7KHrMgitQfGe0+yZMWy//QHUnpRSZeUAjo5N6MLD/TNoTQIJFT/mbywaPwQ6SWkcVklyRCReosSJEuYWhBn58re8Jv8Z6WaMQcQGaiRKBGghToJ4BZP9gy3T4v6UQY9p3p0Jpop4pNCFhucaySxt7gY+JhArUiquAhZYs3dJ8Z0777CV7lFT2MLMn6Tb4EYBhVS+q/AZoiWxmHF125pP0aH1S61LiLU3ExNkDjBzUfF0xeQoarmIbVIUva60Ii0G5m4MjYzJw//VOn0u9klQz9YHf0e64I0RIIF5f0oISrZPVjZeiqLjQD6tI0OmcU2caUPiaT0oCoRbb+9OS
 jaLvvlE3
 C/txc4HIerr+DWbWOwTuQz/N8JH2ExdPElE7Wr0P7ML/K6oWGFFSkon95l3rLPNWt3UCrx6sMktLj03xxXMSnLk8xoixKgApjlPtNcqjC1WzPKl8RoxPiTd5/NO2IuIDglIzPfBDOqszTdq2vAShpmTYiNZbMYGYrzgccmFd0SzuOguRNygFcMsrp11uKXzH4h7zXcvZY+MyX7NFBMV2KoCBWLQMkdcjnjaooz6W41C9D+PU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > This patch establishes fields within the vm_area_struct type to store the
> > > virtual page offset of VMAs.
> > >
> > > The virtual page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT if
> > > they are unfaulted or were not remapped, otherwise it is equal to this
> > > value at the point of first fault.
> > >
> > > Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
> > > file-backed VMAs are tracked by their file offset. By adding virtual offset
> > > as a property of VMAs, we can now track them by their virtual page offset
> > > instead.
> > >
> > > By tracking this, we provide the means by which to eliminate this
> > > inconsistency, and more importantly lay the foundations for future work for
> > > the scalable CoW anonymous rmap rework.
> > >
> > > This patch simply adds the fields and some simple helpers. Subsequent
> > > patches will update mm code to make use of these fields correctly.
> > >
> > > The fields chosen are packed in the VMA such that, for 64-bit kernel
> > > builds, no additional space is taken up.
> >
> > It is not necessarily true that no additional memory will be consumed, as it
> > depends on whether the baseline kernel has CONFIG_PER_VMA_LOCK enabled.
> 
> We are moving to this being permanently enabled.
> 
> > Moreover, in the future evolution of mm, maintaining this benefit would
> > require that the layout of struct vm_area_struct before __vm_virt_pgoff_lo
> > remains unchanged, which seems impractical.
> 
> It isn't, we are very careful with this struct.

Ok, That will be nice.

> 
> >
> > My personal suggestion is: maybe we could simply add an unsigned long field,
> > say vm_virt_pgoff, without worrying about the increased memory footprint for
> > now. Additionally, it would be helpful to add some comments clarifying the
> > difference between this new field and the existing vm_pgoff, to aid understanding.
> 
> Nope that'd add 64 bytes per VMA for a typical usage which can add up to a lot.

Okay, but I hope at least we could be a bit more verbose in the comments, because
__vm_virt_pgoff_lo and __vm_virt_pgoff_hi are located somewhat far apart from each
other, which might cause considerable confusion for others seeing these two
variables for the first time, and clarify difference between this new field and the
existing vm_pgoff, to aid understanding.

Thanks.

