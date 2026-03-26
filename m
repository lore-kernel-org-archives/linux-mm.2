Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B2DE10A88FF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6DF6B0088; Thu, 26 Mar 2026 14:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7875A6B0089; Thu, 26 Mar 2026 14:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69C966B008A; Thu, 26 Mar 2026 14:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57BD96B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:34:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1F655D8D0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:34:11 +0000 (UTC)
X-FDA: 84589063902.27.1F5AE9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 46F16C000D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:34:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vMFyyHhw;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774550050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKxMcUILKrcA41tExDgHW7ilkZ2Ux1oLQWlph3sXKZE=;
	b=37NWkfL/ebG01qndt8LIlJNUSPC0ymQYAWFFBWxZTN+vA9wALyA/CjLSkoZQNeo2HZrvGt
	hWZQbmeGAztCEZ4Vut1MMiX8CEpa3AL4CdYBIE1H7W2x/46rBrvkBUbCd8CEMu7JRmEb2K
	XrmlUTHrJ3snC5PImIN06G9lvtBpNvY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774550050; a=rsa-sha256;
	cv=none;
	b=dWF18DW0gDcVCreTP2GPLqm62BKDS7S+62TbLufPKEbPnLZZLEiOoE7giJWQVX0DU/0Udt
	yGf6nk+k8VTxInoVE0bYVpwigvPQX+Xw+Fy+j3IqWw8hALskUlXwDigJqKR5G/zIr3mkzR
	f2JRKJVDKfjwg/kyPUhko6GUGFH37ZU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vMFyyHhw;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9699360054;
	Thu, 26 Mar 2026 18:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9A8C116C6;
	Thu, 26 Mar 2026 18:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774550049;
	bh=iKxMcUILKrcA41tExDgHW7ilkZ2Ux1oLQWlph3sXKZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vMFyyHhwfuhV/t58V4SonKbUNr9vfN/ZVsId7D0+N+dAl+XkcTz7TfkAhjijHY5sa
	 3TcwVx8KTtIUsp2dHslBjevpXhVI/0F77MOmkq/MuhiJrIA+FrImOCXlcv3KYh+TLU
	 VIyzDHMqW2B/wNUMPzdOEtZ4R/n5QdljHnkh6X5NEsGL5dxSv82nk9/1pVzbOi3mz1
	 KvGa/MbDKepdeWVxHZBqBYBNdB4mPiP+eKWPOjoeTAKkaKUdhU2ksU9dZtH2HMQvKA
	 jP2S4wQfwaflYFLZl5k/jHlg1tFouZ0lgebV/uAEXh1Cd+6mumiydJyqo3hAugTpXC
	 4yKXShtnKHubA==
Date: Thu, 26 Mar 2026 18:33:57 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, 
	rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, 
	maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v5 0/6] Use killable vma write locking in most places
Message-ID: <98a33605-9419-4bc7-8b40-ea47fd598df4@lucifer.local>
References: <20260326080836.695207-1-surenb@google.com>
 <44216135-ce6e-4c06-acf9-af09e224ddd8@lucifer.local>
 <CAJuCfpG_xa5nxSRrvu4TnwhCrmocPkHpWEQbE_yeyN3L69Y6tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpG_xa5nxSRrvu4TnwhCrmocPkHpWEQbE_yeyN3L69Y6tQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: rxhc4u1nhzh6wkq5ytqj7iwg5oydny35
X-Rspamd-Queue-Id: 46F16C000D
X-Rspam-User: 
X-HE-Tag: 1774550050-748423
X-HE-Meta: U2FsdGVkX19TKsttdXSU7yf55RALrW/EZz6I7HV+6g9Bq95mgXzWh9W0MDfEs7w9+GTmCPFM/TPPmYD19hK2A5GQitGWfELkskJZxEkPq6BVPEc2xIwEvpYETY065Cp7htXTdyvMDot8VrhJ8Qyg4e5+vFWJaOwQMt+TYQzgu7qUX5Agb/Usokrna7dRXkYWZNVEKmQWVkjGI1zLd6/hVm99aH7W+hnRulQmB3RYQg4QHSivX9l3QiarWJUe2RCWWSOV2ffYyNSbplxhMzsEefi64/k951ftKsCVhhApAZw3+7gEVKjzjSWJjB5vnVVbgn5XfdlSV7oDyAX1wzpF2VKunZaDgQ0Zv16sI/LXJipxjTNS83V45Cr6bLG9MS/jdISEHfqEyxeDhypcab9fnhwAUpdwjQIV58soKNPuQABR1WTmAZG1QLm77pKmutiYe5nMGEy9QEWKBj6JYe7xv1xsUZ4BfSpOqmv8GXDe/TKJQ3M7HHXY1/N68NpYzN08WeB8awnWQ+Skzjm/FaCaaIJaX7jO/emKLy5KD+XESnQJumeu7+tVmsNbHvPDLn/UOtBh3rqVqCrmtGFj6m+uW5ZtfKTMjwP69lc7ajkhaeE1nlVk5RBsL8mrCKhKta11QoU3V3ZLQPuM+WfY6khCb2QQ1BBzdA5ZcKwlkmZekWHVGRcw4cBM6waiUQe15wdSRXln/cHWWuooeH+AXXJqWk6XupPbAomVMbOZT18wcqvjq4/rAXCzcRr/w97QVwIhhjTgriJHINSzLOS4r1fHd5Iljd5xba3ZCGFkBpvTw6n76r92vyGKL/pJwhNBM6rFEl8fZm92BT+9PF+sUb3WejNIfkwQwmtfAJ6FUjzun7UxH/WnCz41lbBkU4VygskOFrC2DY4VnF8r7zIjOf67i0ehrNZvT0mqK7+d2HNsRJrkpfE2Dp227A/5jNz8t+/7Sal6O1TO28VChj2S7Lq
 gzNKhrdP
 +M3So06DBBptIvJlIMhUpWGxpv4Hm4d00UzCLYUoCE5/xU2OuJBBsrEFKmCvmpISugiPodo7qx/Xll2a+QY5jrwdUXqj497Y0o4scH1ECFh0Ieh0UpeCuMAXkJ/TsBFS6VcUMe8pkJPc+bk2QxdJsx/mo8k7gODpkKZ3rWITStiXqk75Mbj3yXsK2JRaMN5XUFmEVwQ4V6mO3ORNvzQ9Pbp5eq0gfeb3uzKr+R6urziD8Je4DIQQZdlj4/xjBnUX4yBk4HwVKhVv4xqfqZtRh4wQyfjIDhRQ92fGfUkJOCLLxzD6ETI0A9GiMwHIzztn/5n7SOvboVSx+2pQNabas+OTT74jhSrT8lJcC0W7Zf+ndzLoLoo6wK9TIvqo/DxAvomIFYnMLCedHzaqEGlsUnq0cIt1Uu89qpPqY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Roman

On Thu, Mar 26, 2026 at 11:24:35AM -0700, Suren Baghdasaryan wrote:
> On Thu, Mar 26, 2026 at 2:18 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > -cc old email
> >
> > (Gentle reminder to please send all new stuff to ljs@kernel.org - at some
> > point I'm going to set a rule to ignore kernel mail sent to the old address
> > so, if you need a response you should send to the new :)
>
> Ack, sorry about that and thanks for all the reviews, Lorenzo!
>
> I noticed Sashiko's concerns at [1] and a number of them are false
> positives but I see at least one new claim which might be legit. I'll
> check if it holds water.
>
> [1] https://sashiko.dev/#/patchset/20260326080836.695207-1-surenb%40google.com
>

Is worth letting Roman know which are valid and not, as that's useful
information for refining the prompts etc.

Cheers! Lorenzo

