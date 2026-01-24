Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F63BD778BF
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 03:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC916B0581; Fri, 23 Jan 2026 22:02:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4436B0582; Fri, 23 Jan 2026 22:02:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22456B0583; Fri, 23 Jan 2026 22:02:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E25516B0581
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 22:02:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EEF61A013C
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 03:02:17 +0000 (UTC)
X-FDA: 84365358714.23.D010DEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79B271A0004
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 03:02:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gYwABHSr;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769223735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCp112+lnCwVkJUBY1mRLlZ8On1ZcmhaNkBBN4DXWx8=;
	b=q+0+Xeh5hYmOHk/2AAse+6ZE1Ps6HUgAP1I0fZ8zA/QrgT6BbEflWur1O4MA9svuEE1IWU
	HrYqoALwev9e+wltjWeuermeg7Uw53n8IpISv9iRlmPswQBHI9BraFsWpNf3bogUlKvWPq
	ZE53Itw9rHea/o/81gJB+TIq5jq1BW0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gYwABHSr;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769223735; a=rsa-sha256;
	cv=none;
	b=MXwzbvbBmMGCiBCOEtYeq2NMMZPodUOWYCr19QS7obDjZib30UaAW2d7JbMzpoWJaxpWmC
	8WPczCCTd3IUAu7TsXKjtjYFCW47UiJVno5pRHyQ4bbxYkOKFMQiF+oBngfxOLeZIyqk+V
	B1TjNroc+pQfbhxMRhWIVbHWr9sZI8A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C91960053;
	Sat, 24 Jan 2026 03:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3930C4CEF1;
	Sat, 24 Jan 2026 03:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769223734;
	bh=ECIz6G7sqHtGF3FvPa2g4fUPkCAoXuc7uzfPsdhRNgY=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=gYwABHSr92F0aEqCkIsLGo/vshlKkGtNkCA+nhVyuHMcBHaHcjryZZaWuajd3gqlT
	 9OQvv94COUuv1NtiX+xU1Oz6baBy4OD0VFR0/bOx2QRvB/70FQTHZ9Ymgj7+/7dbRG
	 RED6sBmsmrdNK+NCt+hMNCfVIQXQohq9TciHaNmo=
Date: Fri, 23 Jan 2026 19:02:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Garg, Shivank" <shivankg@amd.com>, Dev Jain <dev.jain@arm.com>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>, Anshuman Khandual
 <anshuman.khandual@arm.com>
Subject: Re: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control
 static
Message-Id: <20260123190213.7f90fcbc6706d9ad57d2c974@linux-foundation.org>
In-Reply-To: <20260123172142.4bcdee865bc768d5c70b6a50@linux-foundation.org>
References: <20260118192253.9263-4-shivankg@amd.com>
	<20260118192253.9263-14-shivankg@amd.com>
	<6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com>
	<afc56f8f-0c22-4bac-a99b-b46df346334d@arm.com>
	<ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com>
	<20260123172142.4bcdee865bc768d5c70b6a50@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: whuxctzsjm7r49x1yxyaeba1osf4krza
X-Rspamd-Queue-Id: 79B271A0004
X-Rspam-User: 
X-HE-Tag: 1769223735-242551
X-HE-Meta: U2FsdGVkX1//iciKBYE/EiMOoHFVwxAFzT81H8M/Au4iMirdRDETCYJTxZiPzFwLup8ZbOJAM/DZAnLyL1Sn6P4N81nqF+JNRjlKnfmqafa7DAoBFISw0oYxvibpQnihQVdU5q+Ioqcgm9X/Nd/Q4lX93v5WWj1+GDKn84DLhjwOeZLBuW7xMvbPHgqP7pOUPUXxKmZKcU7CKrHXxyau8DjGXxQlprjLi6ic+K6NLnat2f8XuMg2QXj3RlsbQLZIWGVml39QCtx0aNRHRcI9A4mb6Hd/ge45Bl4dpD6mxc4TdAQt8y8YMoIz1Ov1gT1JNiB7KSP40NLCqqp42kXIO7p4fJuzHX5/HisgQ4Qd+dF3IMzpHDMLY1f1y6yHwKDUOVUqdo6ZDyoeqc/XzcgAnQ6fPXyHv4NJ+rEbQnjUaopWknhoDwErPZNMdaugke04YwO5XzI2ALJhyfHCwBJqe36mVsM9VD507j1NU0mjKdSKZdPgZgt/CqGwNJyvedlqRbid72WgSFvjtZpoL8JzU5TiEu6ziKjPbAvBpa5Rb6lukdPdl9LTYIReGWHjSex0A4LUDxrJBnzNiaPUO5Bc/wM6kR2f1+HcrlhWFibvHGv9HR0zG9g7BisZtB/XJ3jihAGy+xV2LvbsBz+pDipG+YB6/LEENA3aWuudcPMWXL6kA5E3VFNn8rSN2Cg4BefMTZf7OkhVOqSYX63No5hPqNmTliZGADMCWIq/fGhNvGGMFigEaIDRs1+XXgMAz7IxovJKvLepkAMQkC3hid0gA53RNJre91+NbsQ18l7u1DPztVSw67BI+tk0h6LejS20QqxH5Jk4UBtQMVDPKfQzs3HrGmqRVizj+ea8X833IpkOdBH4Dx5WIllqQVVuF4mGHjJ6MZ++r4pivuDEBZlxUTIQ5l2O+V2ysSxVP/FymHNqNrXTdReA9AYgqRmH7beL7pdmhmQ4gxYzxiVN5dR
 WyPub2Tr
 vVD4F9eInAZTj24oYss3jc/mvaDD2PNH9cIwLPGWXsahBm9gYPBaPyt9yhYayAEco/VvO0Zqmd8xwKEVgajbtQxoohH6c3bqyPK4/oMtrmtayE/qViJYUQ+8aE+Bf4eeqri7RQcKjPhHvPishAximhbfYAhOoJWOUL+1eInvjoRBpgAcmabipp/u95S3B/A01HCTerABcWYsG/RaHToFqRdRGT74bdIWq49dRifteku2k5E5GWaLBtpqddRw8+dckc4hF9j1U16PqjUdnvwx7Ck2Pl2maGRuIA2Lh4Fo71ftvRqvHT3kBHm2Fit7osDMs0JPOzhSewmr/ekKZympfc+JCULABDDvHf6qJwjQDp1yAmncNZpTcanuBt9gFj2ec7/8zXvDE5VzoObg6Ay5FP5VEAG/kWLcQtfgZU5MgASdnD8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 23 Jan 2026 17:21:42 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> lol, OK, I droppped $Subject and did this:
> 
> --- a/mm/khugepaged.c~mm-khugepaged-make-khugepaged_collapse_control-a-local
> +++ a/mm/khugepaged.c
> @@ -827,10 +827,6 @@ static void khugepaged_alloc_sleep(void)
>  	remove_wait_queue(&khugepaged_wait, &wait);
>  }
>  
> -struct collapse_control khugepaged_collapse_control = {
> -	.is_khugepaged = true,
> -};
> -
>  static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
>  {
>  	int i;
> @@ -2618,13 +2614,16 @@ static void khugepaged_wait_work(void)
>  
>  static int khugepaged(void *none)
>  {
> +	struct collapse_control cc = {
> +		.is_khugepaged = true,
> +	};

nope, that thing's really big!

mm/khugepaged.c: In function 'khugepaged':
mm/khugepaged.c:2637:1: error: the frame size of 4696 bytes is larger than 2048 

We could kzalloc() it but I think I'll just restore the make-it-static
patch.  Someone please add to the todo list?

