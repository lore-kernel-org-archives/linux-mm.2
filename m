Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F25FCF8875
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79BF56B0005; Thu, 20 Nov 2025 10:56:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7734B6B00C7; Thu, 20 Nov 2025 10:56:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662AF6B000E; Thu, 20 Nov 2025 10:56:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 458E96B00C7
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:56:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E733456D4E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:56:24 +0000 (UTC)
X-FDA: 84131437488.11.807E489
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 38706C0018
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:56:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=j20qsWKK;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763654183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWw+s1u+JKSjcVDup8Ep0QD6BVAJJH/Usa3pNaN1aN0=;
	b=SqEsa6liuESvb0m1PpH479Zqcg7IgscOip0TzXFsatkbKUnzcFaRZi5wuYPaKAT/4PMVED
	+/IY46jlJe1ISL6k74d/yumkOz0KoLxRLZbCL5nWgtIeETgMdpnsnWb+/zAsMH25VCIRJJ
	OqOIA3wpzLMeUw8adrukhcnfuHxjXNI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=j20qsWKK;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763654183; a=rsa-sha256;
	cv=none;
	b=kpQq3O3RV3BICtEPX89eGmDODq8iuDJkCTDZEJhdxDmxO/PR9r6EZ6gAo2gE+pV41yV6V8
	kXBZ5CNGa14CpZeFw5XOOx2+HJYVEpPHMFxk80Thc2xGPvki/YuJcujIsekzhIdr+X2Zva
	A3oU7B9ndDEZRS4Ig7tjICQhNQlt7jM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FA1B60142;
	Thu, 20 Nov 2025 15:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AC8C4CEF1;
	Thu, 20 Nov 2025 15:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763654182;
	bh=yHAxO/XmBrSDVoEYRjxBwgefm+ZWzlUd1ZfmhZ8KS9s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=j20qsWKKVoWshSWyVABqDXVsx/ZWnoKoVukrgKGCajhXpm8P4/KLPZft+T5SUOWZx
	 af+bUltUMRSF6vb5wVJkOB8UtgA47gBv4XdtTeLeHyn47BqvgwUiL81J8FabTpTgNd
	 QI+geOhbFz7WNe6c40GtLGAfblC6ZZNkhWFgBdNM=
Date: Thu, 20 Nov 2025 07:56:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, tony.luck@intel.com, bp@alien8.de,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, will@kernel.org,
 liaohua4@huawei.com, lilinjie8@huawei.com
Subject: Re: [PATCH v3] mm/memory-failure: remove the selection of RAS
Message-Id: <20251120075621.b193e9ad997a2bfc0e588201@linux-foundation.org>
In-Reply-To: <fc7bae22-0705-475a-be89-8bb3ca12384d@kernel.org>
References: <20251119095943.67125-1-xieyuanbin1@huawei.com>
	<fc7bae22-0705-475a-be89-8bb3ca12384d@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38706C0018
X-Stat-Signature: u6h8ftdhcaig3rd9h8ew4551ku511jbb
X-Rspam-User: 
X-HE-Tag: 1763654183-862818
X-HE-Meta: U2FsdGVkX1/ZCzZBPW2lF/aM+rshV6Md9tV9tdtYXLV6O4Edf/d2UL2KDJCTUq95DQyJ8EdLtEWoQxntv6kwQVabb8HcVXBAxva9POCCsNW1/Law2ALjZuLm2Ne0PJpUnR+a6PO+u7W4AyFnPjsRioFLxHTyuFH0gmB2DqaRXALW+MwC8YF/u5Kff7bgG7SNMBMI6l/mjCpevvVsbNW0jsQdH0vliv1rhwW4JZ9w9hb5b7ElLBC5ezCAFRDeg+SfyIdcFEL95erPWgUgQv7OcDQvpIxKjm6sUcnMRD+S+ym7OUNox1ZK23oJ9qgB3Ve0pEjXSyYaItpxCBVRAWxug4WMPupdJCiTET/Ti7EW3bh7eM6urifwKgfpMxd9HWN8SMOzsKbnJ+47LImGLhP3JfO7BU6+u4PAApTu6I+213Fp10KUYnUiPqa+qmn1QbyKlv/2uO9oPWyjt+d6oflMBFzqvvwkXr44hngOIf294MNtbFbZfPp7tuKWakL510HGUtlvLi7oSviJotywhoaSp6mkHJfSuUJaXTf6AkxPG9u5aE++f5JEkOoFvIB47lQB46tjyqt8Mbqefd/qnCckOz5bHwdTMmuzOmY907oQoHMETSW5h5NGba6JM8xPl5gt/OzRigivLjLgNgt74uJEqMLcOMGEpAbuxylkRHzANOCOTa4jcsstiDxmxRlPhtmRh0qDGRPp18LhTwGntPItOltjswhnieyQMYOkVAd5Wr+qfvYsmxqZQFK94S34kR8APM+bOtGhNp/Q8cxeD6Y41ES60ZwLx93DPtJPGHSdOu14MxKmtrR/3R7iwqm3eTEi1UxVdPyejsCgXJFCbCRZsfaoj4n3f+F0cfb9KBUdTNLPE3BWQXsArJtBQeHRLAfdDPWxo/0+jRHQOoULajfOqHNT3XEH3q8agJEpiwPBgpeN/W7qG707j5iOWuxaUNFOYe95ZGn1EHj3e6VZZOh
 udr6T/+2
 tee5Dmx80h3lnbpgi+Pe/WBepsCRoJcPy0I38NY7+s/zewvlY8PFOAKfwfAPaMd00KBpoSR3UUdFzC774/VkGLHdVZAu2UCt0vrSEl/A7J4zlnoBn3Rkd0P7/ADB+yfufel7JaO9XAH0aurphe28/pbLfHJagaVLUAw4GH+TbEDNDBsj4KkoBygSTH9ecmB/uE1XUAj+flZKvmHULOETPxu9KzxNp70sTwrLRCQ1t3KZ/XL09xQ3o3wOLsTVpGLUZf9VD6550w3nfhox/CTQZmWlNwNAryLgBzHtpsmCMgLZMpbjeDFm6A7+CsXYHUiebNqK8JEWGNBZO7jtqlRrt9MHFtB/6IgGrDXa3DELmIUhWi49uihc2b/xs3/TLoDOPx2JYo8OX5piF0St0sEsxW+oP9MlAW0lGRh7k50w3olmZY1I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 14:59:54 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -11631,10 +11631,11 @@ R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
> >   L:	linux-mm@kvack.org
> >   S:	Maintained
> >   F:	include/linux/memory-failure.h
> >   F:	mm/hwpoison-inject.c
> >   F:	mm/memory-failure.c
> > +F:	include/trace/events/memory-failure.
> 
> These are ordered alphabetically, so it should be further up next to the 
> other include.

I fixed that up, thanks.

