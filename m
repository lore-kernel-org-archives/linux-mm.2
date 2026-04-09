Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56DECE9DE60
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E586B0088; Thu,  9 Apr 2026 04:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F4E6B008A; Thu,  9 Apr 2026 04:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324B66B008C; Thu,  9 Apr 2026 04:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 20BAE6B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:36:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4784413B6E3
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:36:32 +0000 (UTC)
X-FDA: 84638361024.14.B736DB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A897D40010
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:36:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U32qiGaf;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775723790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMkv+mgCgcR9rRmK7GcFhCNd85ZDpJdYYggBPjgGx78=;
	b=WwE62Hre5q9FpmKsOcJRtbJcA5XZq96T8WFXGoxu2H3fRHdDJ+isl/FwYIUhX8WR6RcGcd
	OtagnYOFPhEJS9XjqHIoxkG4M9DbjZ1s7Zgk4IgN/v6r7AlEVnRzU4sjfrAGGf7QIEaw1A
	M09aziD9AUA1yayM9ksKqKrpPVKXt6s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U32qiGaf;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775723790; a=rsa-sha256;
	cv=none;
	b=l08BT5SOK9b/Nk2LqwkPyrXaVZrUDDiMZJx5W8IZAi4l+zsqTdJov1i7uu18q4fWgteDeB
	bnKN3EBsfa38WfOJ/MbY22g7gWEe3eMC4xuDR+yk0MpFwrXLtmes/hqhltyU3Lncw51zVw
	rwgjmNkN+AnNVo+NkeGDnKvQSOtq8M8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 20089600AD;
	Thu,  9 Apr 2026 08:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC9BC4CEF7;
	Thu,  9 Apr 2026 08:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775723789;
	bh=jMkv+mgCgcR9rRmK7GcFhCNd85ZDpJdYYggBPjgGx78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U32qiGafV0CDdRkJTCFoIhQD8V2gB3CvOoRNIBiaHw8zhNYGu7/+Ldgu7bPiEGUmS
	 ROSXqs64WcqXXJXncQFUDu8+gfpIGinDwbl3wdsCl02Gg5fvjOzz8NnY74Y3GJt5rF
	 YGOyTE/niqquA9dWPhugXTeehe/wo/lu2XOoJZp2p1KPG3mPRh7CyOotqOSiScZ5ye
	 yC4ZzR8IyEtq14/49eWtpfD7ojNgvA1VNpu4Agr3+RwLyEsCVIKnGL9fsHn3C2Wvig
	 ausVLSgKPG9245zUhPrsExJzmM+cVXi4yynUWl27B2jtYViAKRod9s5lqU6SxgjLf0
	 ao5aMjgPJ7Xng==
Date: Thu, 9 Apr 2026 09:36:24 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: luizcap@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	david@kernel.org, baolin.wang@linux.alibaba.com, ryan.roberts@arm.com, 
	akpm@linux-foundation.org, ziy@nvidia.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	dev.jain@arm.com
Subject: Re: [PATCH v3 00/10] mm: thp: always enable mTHP support
Message-ID: <addkaoz2kvfBZkhM@lucifer>
References: <cover.1775679721.git.luizcap@redhat.com>
 <20260409082936.50302-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409082936.50302-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: A897D40010
X-Stat-Signature: a5y88c4hsqi61ufiwt9u3do75qju4n9j
X-Rspamd-Server: rspam06
X-HE-Tag: 1775723790-48254
X-HE-Meta: U2FsdGVkX19M1+2QuGs5GnZ3SuG7G6dLVwAj0C/245M01beFz+oDkNd4Ej+8sgFbEB6SK4Vvb0HEN3V7VS9z5aVRS07mxhxCRDlgwp+MiGGKDp/+PDqq3fsNDgk2bhoTtNezF6IDm2H6b5XXQqdsR7VTu4RTKY7ucqaRyYSZEqgcnerZT4mCep3ywyie90ny5czYf/MSumaHlLx6wua6vb3yjfzMQPaIDW4xo1pqv/U0FLikLVrkuOpDO61ji5oIvqP8sfIEztfalSW7IucSrXRsPWjD+ZHaq5xdt+KgMEaM4HwbqsCgZoUWWVcssqqwk/TOGQyIWmeApge3svmL3gzRHaHVsA3obXbNx2aQPlWsZ0RQQ839FPr9xajmRR9pLHSwTVjDXrRbOkz7TlT8mt7RE8bwIAO6GWTsGeDSDoJqufpnFcBxL3XNo3peVHX9h8eBRvUpJESGQnAhAykzhIigAFM6jrAVx3llaFUtByyHo+X3Tl2ABZgXvw1c3dIN6E0BTwTxOXH+DbcNkG8dp2IAEXUCsES0YM+1KBILIrNhoI6C9SevhQGmT8FSbtwbXDYKhi5iY+b+AuyT5ZRa/q60boN2FGW+uA/mIeK9ECwbfkjupyrXAhc8sCkTT02FgD5Bw2BLXtjj5HA/KOHxAt2Qw6atOTvEKsNTunlnkT1dpfMEDqS3pWC+RJD4Yg6sqcrJvnjdykFAay7xhC1Qo2+xLBG1pRpDVzHzer0PE3XtOBjMQE/k2eh10KvQzYQ/t9nJJtPME18W4yvgUHBqLuI4GEwhw4xmJl18AVHpT1pael3j3bcIU00Ghkyv2Ja/6SbgAGEE2dDYExC8aFM5RqrIjICLCrdoRd29kQGczGnvadi12kh4gNTdGjlFGJBghTMhG9Puj+P/Qo6aoxfTI1VHtmdiXJGxHB9LDBNNyOXwF8cc8NIRE2ikVNQArzlifJVDkiLffDIF+x+k26t
 zFbfAPBi
 dP9DlEasWZEFZiTz5LiBht7cZAzWDGusIiFRXjG6S6YUOTiuXcxCZKnvkNU6JAfPi2iMpq+Lvcszv1VF5W/SjXPhDmj7RY90KstbxzFcAUx9wCb+DIa0/i/1+Q7Uo1DSAVzvrLIsRoiDo1cQYn6s+Y+4AFLVBWV2FkkgLDuLPR4V/yGMQa77rP60oejzVmdpRiL0F25Prn3nV4OUGxhOI2JlciOZtPbeaByZ5f8Xb8b9GH9nXo4T3EZ5f4yCPC/2A4vTfoJo6qwCLfxvxvOELEQUZQB6JsxQ/RHcFwEVGwxePnTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 04:29:36PM +0800, Lance Yang wrote:
> +Cc THP
>
> Some folks seem to be missing from CC for this series. Please run
> scripts/get_maintainer.pl; it's your friend :)

Please also use ljs@kernel.org for me, I'm now ignoring mails that are sent to
my old address, so you won't get replies if you send it to the wrong one :)

(My upstream bandwidth is dramatically reduced and I can't justify checking both
places.)

I will try to take a look at this when I get time, but really this is something
to queue up for next cycle clearly at this point!

I really do appreciate work that pays down technical debt however, so just to
be clear, I'm glad you're doing that :>)

Cheers, Lorenzo

