Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70233CD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 22:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FAC16B0005; Sun, 17 May 2026 18:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB7A6B0088; Sun, 17 May 2026 18:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1516B008C; Sun, 17 May 2026 18:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0566B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:59:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5D081C19FB
	for <linux-mm@kvack.org>; Sun, 17 May 2026 22:59:39 +0000 (UTC)
X-FDA: 84778430478.24.CE4C2CB
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf28.hostedemail.com (Postfix) with ESMTP id C4D84C0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 22:59:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=Q5WpEWpK;
	spf=pass (imf28.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779058777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9EkGKNtM4PbKfFyx8enMRVIxgBjTt2ex88ZWC1kPpaU=;
	b=rBbUkEKiBDgb28M4Eh2lHbCzsAmx9VCxYQHKJNLsE70PUHEr6etjhy8pf31IYOl4OI0ie7
	08uoY3uCNf6wkUsszjqsMypfBCRidLZW7bzP4wChAUm2KdiTF9r1IPfjQ2kZPwx+NxOPaO
	/JKogD6Ve2gEOxAOBCProHcC5OUcQY8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=Q5WpEWpK;
	spf=pass (imf28.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779058777; a=rsa-sha256;
	cv=pass;
	b=jhPuXemujLMvhiBQDioEWl7nd3K7T+HclH1VJBoltjOyqW4Pf5FwYp/IY58nHOkJk1CWou
	9xiC1JcyZTEGBRmSdawMENsMabU3WrExurPMZpqFLPS66p7fmIXN318uUhaa7OxEuK9gcw
	QJv3d7bHLgFDDQxHEiRYsY/k6jcW9DU=
ARC-Seal: i=1; a=rsa-sha256; t=1779058755; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=Evez8OK3dCpZWc5Qx5SCvjGNd8G+DGq1zQC2eo6Z9hxOX77jcV5as+44OQ/MfE8+Rn4TAjFurTmHscbWAbwE9jTgvXklEcLs+HIy7u7hpZRyNxCjAim6KrpWS7vyY71UFnM1WsVDBOKjzfUUyTcgGa3TSznMdwb5wxiC6q4Yexk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1779058755; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=9EkGKNtM4PbKfFyx8enMRVIxgBjTt2ex88ZWC1kPpaU=; 
	b=O3m8J2SqonHpBI8wVfFNKh+BiWqiga+ob89P/DxBjrwjE99pMOYCxaIydDhfVqrWFHw1FaRXGFmbDdcd63foMkA8NYWYXnipUsSGsa0MBMQVYLSIIpnneFKNK2dS7InEmbWXVXluE7e4mxSAar53/jPhNwOLyqjUMuhy52+iTnI=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779058755;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=9EkGKNtM4PbKfFyx8enMRVIxgBjTt2ex88ZWC1kPpaU=;
	b=Q5WpEWpKIxob/1oggvfUHJLBnMC3owxAPFGmSJG5XLPgYW1mzwG3TpHK/7QctaM8
	7TYdpDOrWHDTK6PwObg8FtMsvLpclVUSp5BkZStGDFr8c1Ir0urEBEwULA1PUXxgZX2
	4N8UkppvzKcB8bZxY6awCYorMKUh1+OUgFgmIqHU=
Received: by mx.zoho.in with SMTPS id 1779058752458179.75815746048988;
	Mon, 18 May 2026 04:29:12 +0530 (IST)
Message-ID: <8d678cb6-9f96-47b8-a25a-b3a969976630@zohomail.in>
Date: Mon, 18 May 2026 04:29:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 0/5] mm/vmalloc: free unused pages on vrealloc()
 shrink
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
 <20260512150109.1a7939bb15f3d48ad866c540@linux-foundation.org>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <20260512150109.1a7939bb15f3d48ad866c540@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4D84C0005
X-Rspam-User: 
X-Stat-Signature: gwsrutewi7udi53t6be3geg538ez1m85
X-HE-Tag: 1779058776-779052
X-HE-Meta: U2FsdGVkX18iehBPrxxRl+RrLiDH/MEwu6jRErb8vTWc1cm9Th36liTfQltd8UJts8LlWwPImDD4sJDF0DNRRh3nBciS9UWLxTcnX6cBco+mDxlmU3c7H04s7ZZiCjAxrH/Rrru8LpknrfX4pHV4A7GZK48CxpqY4LTS4g8mo6fbNXwRWvAh0gTxZSu11f66mybaRPNcyaS8C5nSO1EilOb6x4kdRvPq6Syfjo/Bf4kc7MoDG+88Oli4rs6xeQPiAxtD4+qOO8NmIGqyVWg6ISBOyxPeNBOnkNeehTJAu+i+HWA0Ovwj6AUr/f9nglutT28SQPV28mUJ+E81VHJc7oeX3oC2vmyCxtizg4eyAmNf07pe1ktipDQN/A64lsDX4jFuLtxnzU1Okdz3xpdtFxR4Y8B9kQ/CqNlEP5ZdDemHaBhuv3F5atVOMUCNAcR35fdanx6D8uqddW5GIBrfoUvwtRXRv6J6CJhhlOjEb3xAyJToXpSeFrumpNCBXI/jNhXsVNnQn9HPlieLOATXHkV+pTuLWraqNXIolr4vpUrymBEP4fpVkOQcoLEMGjJ3dlYAXjkIJOQ0T4plo4HrXwCfQXptS+GP3gPtluTWp5urUpnWa6DNuwUZFYz/Q6HFw0cIxBQgxtmFdd3jHW+YpFxyRVInHLcP5cOlpjbF4RR/NkgrG5SYWHOXS+ejso+qdRZGTmxykSEgPnElee/Wu2OGx3OJq0zE3P142g6CkTmaE9cpMuYRi9ExBgy5bLdMTQG2htq4E2mceP8CQ8DotKCKRhl5YdwvnUS+AnohARey5/Nejx4UM++n35vjWLavP1l0Han6TOE7X2wZr/sk6cR7dpQ+Z+aCLtA1CG97tyH9lP5dhfUVRQgbld481yhP0rJqftdtbxFuX8Q1F8tjJDw8EOY1T3griJxrowf5cbmrfn8PWiEF/D+8gXInEkZtH47xvmSyiHGZl3qYEya
 JvM4J6f4
 o9NGutYjy655npo/A9pr1HOlcltv/PBZQVAxQDgs/Bf26cUGjYDHE9G/HuCc+V0io97hqsLlujcLtL2teb4EiR+1Kd3zkT+zlD36SAbqnjodOGTz/CDHfG9TIGNK6zMn0nXyjFsttZl1m/UntVfLTl2cpCKS+GdceWpjM2d8UkeqLeCsisIGVZimi7ANAuziwDyf1TcLBqX7h9S8gfCj916zQ6MXqqpDgkx+B/g4q0qM3JqWh2eeXsSq7TSiLf+/wyVlcw0riwsx5Or6Q7zApYMLp8Q4OKofLwAO0UuzKkIUkif8u+vwdZ434AxQziLfrJp0geS1381PN126Sub5luUX8Nd0Gi9rNNANp5JBAZLfrHX+jJFtMAmOjtWoXyY4o+Mm1wFc0pheeKMxwKVts6fai/KeT1xzLF5CyQnHLjCG3oFocPvjoOG8kZla46tMi8StjjDrNa55lnp2ZuXJx0YLy2iwuXLNkBUT3bgAA85Cs/fTkdhOlqjo5LyxV6A3J3UQGSNE1bOksPR2hujJpZQiFDuOWqQ0SzO4leXm4c45LcpM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/05/26 03:31, Andrew Morton wrote:
> On Mon, 11 May 2026 13:47:28 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
> 
>> This series implements the TODO in vrealloc() to unmap and free unused
>> pages when shrinking across a page boundary.
> 
> Thanks.  AI review asked a few questions.  Does anything here look
> legitimate?
> 
> 	https://sashiko.dev/#/patchset/20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in

Thanks for flagging this. I went through the Sashiko review, and,
one of the findings is legitimate and needs a fix.

1) Patch 3 - vmap() mappings with nr_pages == 0 (LEGITIMATE)
This is correct. For vmap() areas created without VM_MAP_PUT_PAGES,
nr_pages is never set and stays 0 (vm_struct is kzalloc'd). With the
current patch, vread_iter() would compute size = 0 for these areas,
skip them entirely, and zero-fill the region in /proc/kcore.

Ulad, this is the approach you suggested during v10 review [1]; we
both checked whether nr_pages could be 0 and concluded it couldn't,
but we only considered the VM_ALLOC (vmalloc) path. vmap() areas also
have vm != NULL but never set nr_pages unless VM_MAP_PUT_PAGES is
passed, which most callers don't use.

Since vrealloc() only operates on VM_ALLOC areas, I think we can
scope the nr_pages path to just that:
	if (vm)
		/*
		 * For VM_ALLOC areas, use nr_pages rather than
		 * get_vm_area_size() because vrealloc() may shrink
		 * the mapping without updating area->size. Other
		 * mapping types (vmap, ioremap) don't set nr_pages.
		 */
		size = (vm->flags & VM_ALLOC) ?
			(vm->nr_pages << PAGE_SHIFT) :
			get_vm_area_size(vm);
	else
		size = va_size(va);
Ulad, does this approach look right to you, or would you prefer to
initialize nr_pages unconditionally in vmap() instead?

[1] https://lore.kernel.org/lkml/aeYBYqPSEJRC8mjh@milan/

