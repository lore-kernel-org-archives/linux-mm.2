Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77653D711C6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 21:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53706B0088; Thu, 18 Dec 2025 16:07:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D019A6B0089; Thu, 18 Dec 2025 16:07:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0DBF6B008A; Thu, 18 Dec 2025 16:07:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD8E36B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:07:29 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EF56135A8F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:07:29 +0000 (UTC)
X-FDA: 84233827818.29.5852EE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 83657140012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:07:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wfiMB7xm;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766092047; a=rsa-sha256;
	cv=none;
	b=zAVN05QhgiwwPRWwU1U/Jp6KoFVMjKmMiidhmxc/c2Sov4DZiB1dJvHgf9YySwyZ+WYt0P
	uh53qFkFmgNJOSkrZuiAhYCsv7FXf6dsqgUg1GQ+xDgfwgwRTD4Y07KhxyPBFuhBxwY9S0
	wfOIFoHzylO88hKe/JeVZyNOANP4oa8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wfiMB7xm;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766092047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyplZmDSFVxO8UoPzX0CqW1jw4wQSpZq37QH7r95DVQ=;
	b=mGGqw2pYxm8qyDtWheYnlOqapE8Vu2TjgmY7YY8l7EE+IhLz2hMoguK3+v9OGToOXDWx5G
	2Q2GZyP+WfqLwYgG+8HsylzJ/7r+ZfQXDL/U4i5LhKOWzTu5TIwfS70n3FQqIYpA7mQGxR
	yLqT94j+Ts7plrKS7S8IkBuF/Ka/Zmg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EDA4443F5;
	Thu, 18 Dec 2025 21:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A131AC4CEFB;
	Thu, 18 Dec 2025 21:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766092046;
	bh=czZ/4vR5yvVxsVNPYVzpm5JY4ARL2xkcDHo47mxPjZM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wfiMB7xmtRtOQexVNJka1t2G/nwRTH5NVIRGgpABK3ZzyeLNcy8xYzX0LVv5VUzuO
	 2OVwhOg4nKXGNmUlGn3YExsKzxRbufMfrxbY7VOVe0RUQuzGx0puJetjv2okTSRp65
	 dUWebdFSJeD6X3JqnyVlwkyv21aXFiCx22BWaBD8=
Date: Thu, 18 Dec 2025 13:07:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, rppt@kernel.org, dmatlack@google.com,
 skhawaja@google.com, rientjes@google.com, corbet@lwn.net, kees@kernel.org,
 davidgow@google.com, pmladek@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nicolas.frattaroli@collabora.com,
 linux-doc@vger.kernel.org, tamird@gmail.com, raemoar63@gmail.com,
 graf@amazon.com
Subject: Re: [PATCH v2 0/5] list private v2 & luo flb v9
Message-Id: <20251218130725.1b93a521c039ce121de62472@linux-foundation.org>
In-Reply-To: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
References: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 83657140012
X-Rspamd-Server: rspam10
X-Stat-Signature: 9abngseishbhtx8so4tcdih3j5wx5753
X-HE-Tag: 1766092047-747797
X-HE-Meta: U2FsdGVkX1+MJfkYpefOb5C/k/2RnRR2jf5QPKhBXYOsMVrdi/6GtkKi7SEIOIr5VYCFgarZFdF7n4EW9ThUdkQDgL1mvMRnqIJROaWmTNFkqgKNezqwrR2gBBbOMm/dih7FLRIIoDD6zXf8k6wP9++/QCoAFRROuWQ/6EKNdbfmJnJWcx3oUPopDD0jps7Dkf+TPzw1yu77dpiJ61tulsp5yMp6qavYo6IsykO9I5rloDviVtifvmUIUtmDRZXz4KrnCi7jLWQEGkfNwai2qwTrcu+Q81UzplWors3wWlWgijMexCswx486u8xbNLzltO0MlumUIYNt2xoH2EcKI3z4ZkgoDYUqx3Hfnc8+swE9p7XsmhTJotBoUt/vJXp8TAfLwReo5n9wtDEDB9xD+JMiYPgoZP2SDcIS86ZBAt/T/+arqG8E9fz3d8vK8dtvTkFKM7J5Bko4sF36+BULCK79XKw3zOrvBvTy58Sf8TV6dskSK3U9Dg2Dj+lCkri6oTSkuFX0MG5tVgF5UCazd40LWsdZGmsvUm4LpgzW5sdA8lh/cRS2Xvvpjq16Ycr7pMj3V0bhrxuw3Z5Rxcqp+VM6d2XgNeb18GbqqHGyuOeg/nlmDbl8xrsV/cohXJdMsaU8thmPT/ImCnEft+/TtdniC0FvWflENhD4//vgiokEd+iZ4DXkkTPg/y9FjPLRmd53SxFGHX67WP5crY+bVvj4AivF+hSdmkq5gmD8TyPfjLiEglIiIgn9zQNVW9fS4hkcNjEXUSrjcKCHiXtm0DuR1CYnviAno/LfDKIAfj/muxELpSv8WhDY6WKKuj43d/XBxEVyMlilP1QhVO+60Lrsq8Mp0D5jzbHU2Texy6u/IGVBSepfLsy7zR1dvd2j93+TcDI3zSfMo2gKyyMiONabjBalt3A0ZeQtBvkI99DARe2icnA1lS245j4DOaaY2JSzR1vsWmPC80AS1ol
 dh+t2lK1
 48vKporrUm2OKHAhnas7IAiKax3nxEZrzDhln5s9NJDTvctENa3cq3QZn9cz7bjb9btF8gy6fB3V6lMarL5/RPycTcgQmc2urokFJ3Uq3lljidbcSM7I+ZbEhS3MDhwkrAoiA38pRFrDWP81I5wE/19hXsLCCYltwH4r9C3ubDlPTNd+zxpY3PWjxS+rV9th4ZMn3nUSXq+7Vk+boVfFGWsNNoHrfYETnxEaLsUu12OOpRD/MRuWt1QHs4YJHvzIDGj4MazBHW5tzxIIhGWa46gYTkc6yyYNnd37/g56HdqP9T3xp094C9RdI5F7CqVTtnj6bk7kqVdeS752P5AKSbWr3pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 10:57:47 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> This series includes two separate workstreams. This is because FLB
> should be applied on top of list_private, as it uses some of its
> interfaces.
> 
> 1. List private v2 (first 3 patches) Previous version:
> https://lore.kernel.org/all/20251126185725.4164769-1-pasha.tatashin@soleen.com
> For details, please read the cover letter from the previous submission.
> 
> v2 Changelog:
> - Added a Reviewed-by from David Gow.
> 
> 2. LUO FLB v9 (last 2 patches) Previous version:
> https://lore.kernel.org/all/20251125225006.3722394-2-pasha.tatashin@soleen.com

Please, no.

This patch series is intended for the Linux kernel.  Your grandchildren
will read the above wondering "what did granddad do".  It's just lazy
for us to expect readers to have to chase down links to earlier
versions and then to figure out what changed and why we changed it,
etc, etc.

Let's give our audience a nice, self-contained and complete description
of the proposed changes which doesn't refer them to the minute details
of the ongoing development process.  A process which is utterly
uninteresting three years from now.

IOW, can we please have a complete and standalone description of *this
patchset* which doesn't refer to earlier obsolete stuff?

Thanks.

