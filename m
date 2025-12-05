Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75AC8D2E009
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 06:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEDD26B00C7; Fri,  5 Dec 2025 01:50:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9E326B00C8; Fri,  5 Dec 2025 01:50:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E186B00C9; Fri,  5 Dec 2025 01:50:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82CF56B00C7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 01:50:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C5511A04E2
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 06:50:23 +0000 (UTC)
X-FDA: 84184493526.21.66C731F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 770D640004
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 06:50:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N0/gasT4";
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764917421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoFU+G3ETpikbd4tlQOFE+VGY07S6NOxc28n31sv80k=;
	b=zbIS7crmSdsMzcFIxm4tWRn/hn+89rK8eKDvgLEAJGbxIePI/AqW1e4qt0B3dEcphBKOwM
	TFNfPEcltum1G2hphYoVcTBgdpZPgtyvRZIPrEu0t2hfeWDF/GNyx+P//8vLt42QW/vJuB
	Kpit3H9N0l1i/B5y56wsrh9qXyEZP4w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764917421; a=rsa-sha256;
	cv=none;
	b=a3F4tpRWLQTperQ/txhNJ+t7eQ5KDGA5l8YRh1WncuynCMYCqDWtt4OKZITbQmDtnTccSJ
	qaj6hZLNc9gAZ5QlyAUXzadw1SmOowPgHTF8cj1nwgLU2NP0y8p77RmL/yy3rZzXAiIbH0
	NXaGysEQinzfZkUkaAu/SowFRmdNAW8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N0/gasT4";
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E480D60010;
	Fri,  5 Dec 2025 06:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C914AC4CEF1;
	Fri,  5 Dec 2025 06:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764917420;
	bh=S12eGI1G5jc9G6bd6xh6G1FfM4cBPXqRWNEFnudR6ag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N0/gasT4PM94cnt9hTymN+xKW2QeSvwLLZJ+lE1/Q6hr2fQ1OazfISnRCo4/WOuyh
	 MgyJFyIZgY+gzz8hFHtCCbaJepb+I9pMlhqzu3zHh822yhpeHs6kCKgFVtDoPbymYL
	 iAo6lYItJpG2A1jOh8mvNzOpKq9WTPoA1EOgyORSmTc681MtFcGl8XLSetO8blOBxi
	 sDdB5/7KsrFA91H0al7RIsXNsLy0JlJnvajYvURGv2EYGBjw9bvzRaXYAthdEkzz2y
	 npWyCqJ/BTEJCdXcvFNpWOrREg9HxWoPKpjBXS3YIEzHxlM7kzJ1VipPGKkBPSi8gz
	 Ny3McT+zL/YAw==
Date: Fri, 5 Dec 2025 08:50:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	akpm@linux-foundation.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
	npiggin@gmail.com, christophe.leroy@csgroup.eu,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, masahiroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
Message-ID: <aTKAo7JgBX0X_pBl@kernel.org>
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
 <51d8549e-b084-498e-84c0-76fd3de116cb@kernel.org>
 <317deba2-e560-44ed-a9f7-3c6fdc446b6d@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <317deba2-e560-44ed-a9f7-3c6fdc446b6d@linuxfoundation.org>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 770D640004
X-Stat-Signature: sg6r1sa9zs9yy1csju6xcifw3s4w6yms
X-HE-Tag: 1764917421-846080
X-HE-Meta: U2FsdGVkX19bwgRcidPM3tNGY3Di6ZyUjijz+F2D7nqmSsznYk7zz8GBqGVFXfa+0xtRzkpXGUhXFyBrgMKN3l9qcAg/4MFe9d7S4gxsmfvRw3OgB/03yu/k4bwIle1HHVVB4IwtsnbRNNl6HI3EnBq2MzwbDE7DqkeHM6jRwm7PiPFd6QPPXTQle9FHa/dcOy62dMlJJZgVUein7hzAQHwj/ts66nRd3bikheR3svt6o6BN1novl5E20vbgB6+C3gnh0HcYbjBLElwCo2grgkmqOsrDrNs/V/NxQEAg0aoHM9Z1wdBNKo1wJnQQMxWOwHpiHU/cWA/6fg7RjaB1fL5EwOJuSn9AzE1AjimTVbW71wSNhTayooq/hZrhiS2I85lanGyKoAPgcUQ0tLgWZ9Wto36uDWi5zsRgDXMv8rgLQ3O1j4jiZBz4F1Bz7PdxL179V69iZQSjBoxhZnAVqd+W5C99q6ga+qfjJHAwfe58eDkBlIJAnzttalVjrnTaJwyAoB7fl0W5zaAnBeFB6ucyMckGzBwGCgTcq76W/a7EB7TRTt3PAIJsIxny8TyQdofb4fWdmev/BMwH487EfSYVoBTICqs9b3jSng/4vhT/VNk37x7npd4L0cNgku7SYX2QwvERtuJcJ7T94WeAQYAkvKW91YBwahvZbMyxRsDuNl5ouQJJyygfyq/hxmEXjz1T/UfHTtb2b/WLkX8VJcuPYaNnbZmGHjPP9MnmVlvmBA5iTcvEs0jI8SuM5tB28ueUQxcAfG0CYJSxrfDlucr9D2h7Fir0fD43Q76rNkQzU6CWJRHZkrDhFpl2Olal1npUd9jWVq5KVTb8THi5bq2yg7RZLR9X5FUNTYod7OvSn/N4K+LzSq7JYYpMGTwEjujkpjpmwrrfJqzBKNjGlg94spZORkp4usR93jz4wrdAgwQdCirmQER+PwW85tik1Vuthtu8Eggq2QEWoI4
 6Ory/Qa2
 yDiAZqAUy+7op52o4AbxvBXCbmQUwiizlT/6wZ7LHoRlH/dwAuPJMNopHgBlP+0OZi/H2M+7mHTXD6ikN7+j//gYDXozL1Ta5vcXAUhYdhwNtO9JbOHP+hnNuOBDwksGhdAaCpYxDCOl9LcJ33Bik1fzhSXhtBVO9qaXtozaCSx3d4fFufOcFOSGYNMvRnuaYNayFxrnCGkhHXU46LioYHFbdFyJenYwdbJ6XEnQkPwJ3V9CAhFW8FbA5Voml4IHXJfGgTtMrmo2FV5nzx5c5PQw4WIfbuJIPqJ7ZahB1nfgTyFI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 04:23:36PM -0700, Shuah Khan wrote:
> On 12/4/25 15:16, David Hildenbrand (Red Hat) wrote:
> > On 12/4/25 03:33, Shuah Khan wrote:
> > > This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.
> > > 
> > > Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
> > > systems. git fetch-pack fails when cloning large repos and make hangs
> > > or errors out of Makefile.build with Error: 139.
> > 
> > Looking at the last part, "Error 139" was confirmed to be fixed in 6.18, right? At least reading [1] there I find
> > 
> > "it was issue of 6.18.0-rc6 kernel itself. After switching to default Arch Linux kernel build went without problem and I'm now on 6.18 stable kernel."
> > 
> > Did you mange to report the make issue you reported here [2] on 6.18 as well, or only pre 6.18-rc7?
> 
> The problems I saw were on rc6. See below.
> 
> Repeating what I said on the thread so we are all in the
> loop and on the same page. It took me a bit of time to
> retest on two systems.
> 
> Both my systems were running rc6 - I was stuck in a state
> where I was able to rebase to rc7 and then 6.18, but could
> never build either one.
> 
> When I suspected rc6 to be the problem, I booted rc5 and compiled 6.18
> after reverting 39231e8d6ba based on config file changes between rc5
> and rc6.
> 
> I retested on both systems on 6.18 making sure I have 5bebe8de19264
> and 39231e8d6ba in there. I cloned linux_next and built it on both.
> 
> I didn't see any problems on 6.18. Having said that, It might make
> sense to hold off on including 39231e8d6ba in 6.18 so there is more
> time to test beyond 2 rc cycles. That is for you all to decide.

I am able to reproduce both git and make issues on v6.18-rc6 with
39231e8d6ba reverted. If I apply 5bebe8de19264 on top of v6.18-rc6 the
issues do not reproduce.

The issues do not reproduce on 6.18 that has both 39231e8d6ba and
5bebe8de19264 that again confirms that 39231e8d6ba has nothing to do with
those issues.
 
> 
> thanks,
> -- Shuah

-- 
Sincerely yours,
Mike.

