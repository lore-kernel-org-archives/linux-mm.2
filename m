Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5671ECD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA8D6B00AC; Fri, 12 Jun 2026 00:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2636B00AE; Fri, 12 Jun 2026 00:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FEE76B00AF; Fri, 12 Jun 2026 00:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8171B6B00AC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:54:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 432DC4087D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:54:23 +0000 (UTC)
X-FDA: 84870044406.16.30D6BC8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id CF94D1C0007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:54:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qut1p4kO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781240061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ak41LSJW9MpSew5QO6CgWjqhI0vYzTvnZXAjs8LelSc=;
	b=HXzaTd5HnXM2gD+AAMPbw7MCX3d+8zOe3+MQUa97fIv8YLOaTVcChEULadqsQWP66VNYkP
	YfqFNfLBqH45SPfZ1nJ74Hl5oNZLynEqApWsvuTOBBldtnCLddLIUQS2UGEERES1L8NN0w
	KSPDa2c3lfBRM3NMIa36cY0xmsHpJF8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qut1p4kO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781240061;
	b=iN/S12bpHxjcOYNntFqubd+IwTJYWwnEzhB4EWOxuDD7X3Hmb7V5Ayg3UobLYgmHiEc5G9
	2LLphPHxsuCgs3e5kNRrnk4x736uNunjXhA5sCz4rVl3qgMgGhx2xop5hvEbk74otw2lKM
	LRJAB1bvkVmaU5j1/igalIDaqIKki2A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Ak41LSJW9MpSew5QO6CgWjqhI0vYzTvnZXAjs8LelSc=; b=qut1p4kOHmkFpq1us+pZAKAJNn
	VHva16KxALkYzQ470Zy3oPzZmu3fzRUX9HgH+P6b6gqYCDtpo43voWn5m1Onqe5u0fQVlqBAQWjbn
	lRe3uXgla18xDLx4fBmJe8iiJKjWCBmGUFOlMrvUVHFkoib0Qo5NPhE7mdZCBeAefMtlnVP47uVIa
	q9iAR9vQuFSoHA0I57kQlLWyx7zRjJLNRN8WMQRnzrz55Wr2AjgTz28nEBRW7IAD18UTDYarrrQOK
	plQZ+58vSnkCqX80uJvt1LhsuEgeYNokZvHbLvy6K2xNXYUAZI3CGIRmF9z2ghR/r6bO8PzrSa8uO
	BWo5jL7A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXtu8-000000038zY-2FLR;
	Fri, 12 Jun 2026 04:54:04 +0000
Date: Fri, 12 Jun 2026 05:54:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, jaegeuk@kernel.org, Chao Yu <chao@kernel.org>,
	"jyescas@google.com" <jyescas@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com,
	xiuhong.wang@unisoc.com, hao_hao.wang@unisoc.com
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
Message-ID: <aiuQ7KiK7Nfqq3LV@casper.infradead.org>
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org>
 <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
 <CAGWkznFQH65gJO=xvxZLoDGWLu7YTCnSyfoy7JdLKV5eY8qLzg@mail.gmail.com>
 <2F9A72CC-772C-4691-9F18-77306EADC6CB@nvidia.com>
 <CAGWkznEGt1eRmiTLsU6DAJBmmbUG4ZY4HE5Cx=Oy0yznqGb0UA@mail.gmail.com>
 <A7D51FCA-7D88-449B-9113-7741BA2D659B@nvidia.com>
 <CAGWkznHyxMNX3=A8ApCuY20As4NJpF_dCTaY_5+STVSv3RjsBw@mail.gmail.com>
 <aiuAr0kYDcc-AoVg@casper.infradead.org>
 <CAGWkznHMm=Fu_LQ3ZrJ4-ZoW-bwu0N4_i_YfnO5x1AbmP2pPOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGWkznHMm=Fu_LQ3ZrJ4-ZoW-bwu0N4_i_YfnO5x1AbmP2pPOg@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CF94D1C0007
X-Stat-Signature: mot65h8j4m4dsfn4eqx3efqxu6stf1n1
X-Rspam-User: 
X-HE-Tag: 1781240060-11430
X-HE-Meta: U2FsdGVkX1+M2nlSRxT5JgoHl7rD3mk+Guu43Aog7jnFEQ/6/H5JmoPrzu3rmKLJiWqCEEkhBqqgzceh9LrNzw/7VMd1fupnw2nq00WyXV35cTADHxyCjt81DCJvxlaUXWQ8HAgTynDZR9HCKaueoaak++G3YtZMM1iOjqF9tW/GlVj0CDwW92yOoNS0cX6pjgYZm9aSc5aajtf07o/XZTn1D039eZR5TgeO2EBQ+2r1n3HqUAwR+sDYzdqB0zOdxL7UpAj9mfZh7Iw7p4jWXREiEHZ4HQhxj0n2KBVpaDUdtfdwYIFcH/Rc5+y3XGzx/hga7Z7qKd5T1Bd9NeDVL8+0Y0SOuxtZpAsBYlECE6MSBq+48m5GBRTfb4g6q5XgaAKwiWhAzhIGEcc8HYwhmARAfVoG7SIQb+qFE/hGRiAKK0sSS1n4Id2ekcRySNZ1S8vDLqoBBk0ODk3ge5vyae8GlJaysGAeFMI59O87dcSGMUR+pcED5GM1MoFx8ewmtcOlNikVeESgwWJ/3HBIM+PsYZdsnXMDd7SYupDYlZ1E9Tct5dDOGILEXTGG+Xgwj71Rj8HEfNc8FmNe+m4IRpiOO2bJyU29IiA1kwXO0RkGDTZEUfGodVUoQNYx5c33FCwNahTsDlJOQfYaxra3Yuk0le2AknIH/T+EvIVau37NKopEPkPceKeSL64a6Q06CkB4e1iTZTbD5IRKbK5Onu5/K9QuIJ/FaQPQ58wZqeMXu9MaLiEMaelNpwQXqls9Qr1Bh+jdtdgxt/vDH/G0gh9/gdhL3ezPG2cspYTdGUApEESf95gkYtZHdI+ZPvxFdyag33hFFwrquZHhsEnL/FP9IhynD7ZLwJiII1Gq3282TQ1ee0fjDBTSnB+4jn9vSioBBNeGCLyxK11V12wIK2sak46dc0GzAIysH04Of84n+rCS+LzjKe+RGRQkpVQbvQatZSEzbCm6d3k/JWd
 N9NnFi82
 i4yWc6e5CdXn6fufFgBjYU0hwfZ+aJZbulNTnHBttQpfRtRkxC916SvqAn153hZm61DqEu5NEJ9w0v441KAscCnlwdvCjLH9c6E/Glb4vIrYNyPkzp0AF0XZcD+wZt7VB66MyfPdyCwxS1AmNU+5clm5WsGM9lpMbczuIa+6BVmoz6Ra25zdsffWurafl8rL1BY/PosuNG+dwnTASG0ENcbfFe5KKB8JsjXufHUdJlxqARQdy7htM/SuVjw6Qrm6ZQZAv/BI6IZ9gCnzFxc8Qch46/4Twg5XfDFx1cCVa17LjM3EVdunr83+0MyI70HoGaWPEm71ncbv/BATnz/afP03TH90JSUBdjs7a0VHGPWWcifpcaPjemhHy6UXacup1czrm7hXrxyIJGZy1wuwjs6MG/w09iaOmB3JaJBNnTOvrbduw7TeDPyT9kRqzq+mH4EALbrSE6gwHXzSSFYwXbIqhIkjpv5hsBk5dQDwVpTzKW1JjjaLVHnp4/jB/7JF4N1QSSTM7ry0XgRLEQLa7sIC9blmpQqs3dmYSd62ZW5lKkew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 11:59:44AM +0800, Zhaoyang Huang wrote:
> On Fri, Jun 12, 2026 at 11:44 AM Matthew Wilcox <willy@infradead.org> wrote:
> Thanks for heads up. Could you please help in checking if this is a
> real problem?
> 
> patchv2:
> https://lore.kernel.org/linux-mm/20260612023456.2424044-1-zhaoyang.huang@unisoc.com/

Since we haven't seen this problem with any other filesystem, I expect
it's something that f2fs is doing wrongly.

