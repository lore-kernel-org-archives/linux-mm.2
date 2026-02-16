Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 454E5E81A3D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A0A6B0005; Mon, 16 Feb 2026 10:52:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837856B0088; Mon, 16 Feb 2026 10:52:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742EB6B0089; Mon, 16 Feb 2026 10:52:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4376B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:52:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E651213C22D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:52:43 +0000 (UTC)
X-FDA: 84450762606.24.ABA21DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 399441A0014
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:52:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="zlU1o7m/";
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771257162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sk+LMzKuKKUl2mh8/HmXq0JRonu+PfeCnD7cicY+ffY=;
	b=g2X/A/OTEsOHKBAWdBF+RGPhxEIG+wRZkweEnEDbK0O2g+vI5wMP+uPHK44XrXUKfwKuHk
	tA0JXwF8JIwMJRLZQDyChpMrzdi4GeHqRal2o+GgEIDtFPzFMSid/t4k+5FrN2EB1Q3N9T
	XouTt/H1gTYju0HN5W6aEVLyTqQep/w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="zlU1o7m/";
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771257162; a=rsa-sha256;
	cv=none;
	b=F1G4Tm7Cc2IQzBdkng+fTVaIS0hJtVDE4MbFRbnwdV3E/13oAk/q/Fg3QmQGT6mS0JWQc8
	Or+SxVjYMMkYAuhVfSYoCNUc0r/+Woa/4ZZHjZgu4sB35MKn8bgeiGg6dZ4iP81LCPFHMg
	m7JdnYmFZqwf8t9q2NIVKjE7YNJYIgY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1960042157;
	Mon, 16 Feb 2026 15:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FADAC116C6;
	Mon, 16 Feb 2026 15:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771257161;
	bh=SpbM4tb01sW+yxj28CeMnTfRceSTmV4rtWURimYqVGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zlU1o7m/znn2lSnh8MTjRqRBK+DHHLT9wXb80dh7xfFbpKpDXbeb6TOWcO2DHZ/3K
	 IaaHlFJIaG2XWSeoYZRSohwqnk4huEZNc3KHK8hrRYO0GHJmQBIOd5laUOngcUyeox
	 V9Qjic/7NpwxPVr21WX6TnBZyYBbf5kE08GNNMp4=
Date: Mon, 16 Feb 2026 16:52:38 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
Cc: "sj@kernel.org" <sj@kernel.org>,
	"security@kernel.org" <security@kernel.org>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] mm/damon/core: dangling walk_control pointer in
 damos_walk() on inactive context
Message-ID: <2026021646-sandbox-duchess-5b7b@gregkh>
References: <CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com>
X-Stat-Signature: nq1tdda15fetkdhyiy5fqrkc99ywrjki
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 399441A0014
X-HE-Tag: 1771257162-457526
X-HE-Meta: U2FsdGVkX19WhFtiQr8DnknTuR1w/GfJO0CIzGh4E1j1oCmcW82xn9bRdugFqIeaRhzu8NxFMfutSTTN6EKF2j0At893gdWjv/U0BAY8oB5/4o/gAadQdhcUsF6u34jy4/P7Qa5jJNhYNdDemywxHbwXVmjc91AeWF4NvMGboLk8/PQiHfRAyZlxpnuFu8G4m24KDLJX3rASm+HUkNH0D58EaY5pNaYtUPO2jUimDC+c+eSKs6RV3w8OV2XG2Kig2fZwzvNEZAr8hWSXGpwnzc3cMWWyzqCESUaBAPijwIj8TKecCKxNj2QWd+uHCriZe2a8FWI/XoztQs0UBXgJHOUrBQw7kIGFKSPb2TX0tJJzu7sjh7urX9O7ikGd7jYACed5YaTeXJYQxrgEwfAkFtMa1zule/IFz2bBSH1K9jCOpmv9WciF6Fw4l8Bx0/nLe0/FwYRrXZy+KwGnhyMYjXjjHmdoG1LMoQeGY6ZtfmBsw02bKHkgBtw0tqISUcMfDMLzlTevNRpdIfuWtC/hM6hdFDGlOlUIR+PBVVtk3pTWn6yphnlLwmZwalyAKrNy04N8z0eSdGM9xdGN92HkfznSlqUv6f0GfdXQ7h9/sWed5db/Y7d9vU6BsrfWpbN/Da8oCJmoeRaoeWDBsbaZAUrUzi37almZNz1O9+qD//SZ3fXury/CKujukITVBUaqaq8Z9NvmX73BAQrl35IfBcGS2OvCOSqVpkoV7vsutyLwm0gOyNyJeCvRLb2XxYAeDqWDJg2fqbbJr36DVCg29018qOMKkpWUgLWjFJqkHJN5EKzX785MGMkBdjTEf+BY+/q2ZQh07qYTee5tC2bLv9sMY86gvnR4CaNTIpt8aIY8M4vaSwmEKmvwuNbSgxl7AUNsWLFXA1HroD5LNVb1m03R5ejnvvZvT2mEvxHgMp+DeIVOctSFCPdR/YroUiVtYUnQ/qOLyfLXOyVXj72
 Fik2/a0w
 OowqX6if5G3Y9KfB3scA1UIAuCeJfY/+i4fm7GAqHUFREhOyOLXgni1S3iOPh2FWT111nScdwepSCFaPkl+okn+c/D19IxSE35n5xkryCViHqVuyizZW0Mi7K902B/Mkqwa/UX2I1AEgq3kTzCUJVF4Qe9+4GC1c14mTRXjPPKdyi0B1X4Kn4xB6Ut712JpVZ0rdpmXr/gwAGQ5y4P6mwjFCLdtTMI3Ua1thKRnhPIXIomLCrCzY8QMKHY5MW9T5Guduex8B54MtkznKzHQwq08z4ad6g4zQkgF2ZwsnjTFidmqHLOrqNH5DNU2/Y0Tyn3Gj7laImZkVQys52bEdi/oNuewIs/1SHj32KGqE4yOH3XUtHnXiKt2V8J27rFgDXU8fV8HxLZ3lsDhHBEAYctnJ6+A1y2BTEa/KhF8iWFewjdpaehNKqiiDbXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 03:34:44PM +0000, Raul Pazemecxas De Andrade wrote:
> Root cause
> ----------
> 
> Commit bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
> introduced this function without cleanup on the -EINVAL error path.
> 
> The sibling function damon_call() had the exact same bug and was
> fixed in f9132fbc2e83 by adding damon_call_handle_inactive_ctx()
> which removes the control object when the context is inactive.
> damos_walk() has no equivalent cleanup.

Can you submit a patch to resolve this to get credit for fixing the bug?

thanks,

greg k-h

