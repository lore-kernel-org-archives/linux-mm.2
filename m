Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11732CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 22:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E999D8E0007; Fri,  7 Nov 2025 17:23:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49928E0006; Fri,  7 Nov 2025 17:23:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5FBD8E0007; Fri,  7 Nov 2025 17:23:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C08068E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:23:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ADFAE59E37
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:23:08 +0000 (UTC)
X-FDA: 84085237656.18.68AA80B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 19CAA2000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:23:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dT6JdUUO;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762554187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0XeJQV7Sl5wCMdacmGIOIX4A3GBQVJm3/OUwM9EVj4=;
	b=ZnFLsq+Pr5/DztAgJUE0ANYCeiRAS0IlCJLaQV4Q0mBMCAras0D7GKJuxua9l7JAyKjCOB
	FCF5Bop85x75YoOUPfEKZS8tlTdv06ABH1n20BDehi3SH1xOvijY38n03weFNMOp2qsSid
	fnR7fc/Wg7C0pPyR/uOUAjHK7yIqszs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762554187; a=rsa-sha256;
	cv=none;
	b=klU4BqfpPuA6enC6tM6S6uPOjWjP5iSHMI2sRX6ZKwm5Wpa4Om1ia5ijTtRseFxDtUjQTh
	eSid56jUt7mAkEUbsO6I1ouSWYRdKqMYZm/IVeS9NA4t+ZOScBWYDeh6ly+4wHdOlD0wbg
	tx6ekSxjVmEsQhTk8bubW+E7SUfpTtY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dT6JdUUO;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E988962BE6;
	Fri,  7 Nov 2025 22:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215AEC4CEF5;
	Fri,  7 Nov 2025 22:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762554185;
	bh=FmDzUf7SRYX26khc/FKuixQdWMPPvqBeIjyLbJIHFBs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dT6JdUUOd3RRXNCr+BF5z4qtDip1YMFAJDddH6o9kkPBlPjwM4PLsv26aW9NqWTbK
	 2j51WG4IOwihfeKZOyhnK4035ea0hYTn+L4GHaVZnsxvlrzpXFNJ8yfoua/Xaqcvph
	 6DNCvhV6w94ohERu6WaMgjwyjLaMUXAnjACmeAno=
Date: Fri, 7 Nov 2025 14:23:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: brauner@kernel.org, corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
 pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org,
 yanjun.zhu@linux.dev
Subject: Re: [PATCH v9 7/9] liveupdate: kho: move to kernel/liveupdate
Message-Id: <20251107142304.6d22289c96023fbb7e99464c@linux-foundation.org>
In-Reply-To: <20251101142325.1326536-8-pasha.tatashin@soleen.com>
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
	<20251101142325.1326536-8-pasha.tatashin@soleen.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 19CAA2000F
X-Stat-Signature: 8nhmo6y11gykksywdr14xfk3yp9uq3ag
X-Rspam-User: 
X-HE-Tag: 1762554186-892605
X-HE-Meta: U2FsdGVkX195fOcMwSLWoY02wZGzNSu0vvvv5MON3P2SXdLcTqihw0d7azgz26IUefp12x8Yp+y8Cuudp9WpflcktuFw7tqaW307Wpo1iMv13Qhk03DhuBBS3CA87GredPo8Pw8y34ytWCaRavgOp3SeSu+XkeL8ILaI3b+PITVilec2hefievFsSFGMpPQFugZVnVhxz9aylLg+Kd47kyTVHXGl0xgJb9fEgrQ1UUW6kAZIhU+ice9OXXGtmwYL2AtQu9+YpodL8FiBgsVlcFZhi1q7NdNNPUfC3V210vzrMhnaKZbM4Jbd9qG7AZBUaLOkfxBNeO+dsL46VTpBswjmvqEx0c8XBg65ipCIaKECPobZG0j/i4ZQQqITHAfi9rx29M2QW0hpyZkBS9tzldA+P5GIiHvngdRZpBW2AKhEhdn9HIS50OP5O4H9dyaw8ZrHxe1x0L2rpg1uvIby23DFsTdqpa6SIj7FPpoG8UkJcHIEcgvxUlTfj4k7hEWQa1YOYFCHyzLa9U0y7KwXl2ebq3UuRrN7M0cr3Pt1CkX74RqjCJJKNB7ZhsX/+rYYJdp2gZaEqHXvxVEQSVdQeDz041HlfuMiQcWaPbnQSdxv3Jx5c7pCJyuBaqqpXpJUVuJHMv8c1QWLRHBGFM/pPGYINsjapWFamO6Fvkg48bWDHUxU2uHuEmDQLa8UZIVrsyDgl6g5CxBmkdJwBNM8l6GZeNZIekS4YaCC/OApLmhfmsJCgHG9v/x0WrofTEMv0l63ZBGwZP8k/URzu/anrBxewvTNlIrKrdRjKqc3ftUbSiiHbjXk4kz5x0Qg7pAlsyX8/XdJdwYVUz/dD66bqWGwS4hBkVr/uBqKz71mZT8s982zo9d+yousInPWP02v4FmV9dr0Fcq2VQJE3Xp3nCv4f5ABaOJqfkuakPxx0jU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  1 Nov 2025 10:23:23 -0400 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> Move KHO to kernel/liveupdate/ in preparation of placing all Live Update
> core kernel related files to the same place.

I notice that menuconfig is a bit weird after this.

The "General setup" menu offers the "Live Update and Kexec HandOver"
menu but there's nothing in there.  If one sets
DEFERRED_STRUCT_PAGE_INIT then things look normal.

Perhaps we shouldn't be offering "Live Update and Kexec HandOver" at
all if !DEFERRED_STRUCT_PAGE_INIT.

