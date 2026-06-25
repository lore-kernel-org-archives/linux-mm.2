Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E16CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6C36B0088; Thu, 25 Jun 2026 00:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E266B008A; Thu, 25 Jun 2026 00:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E356B0092; Thu, 25 Jun 2026 00:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4536B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:59:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE2DF1C5FD2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:59:47 +0000 (UTC)
X-FDA: 84917232414.11.DAAAE1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id F39F0A0004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:59:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Fs1Rrmwl;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782363586;
	b=xAgD8olVgJ5+RrrRlWrf816U2duDrmEuXtgtHUV4/XDz0Z3uiHU8CuQW5zbxNTDQeG02BI
	dpfvtIYejfIQDLxlglj91gTnHKycU5Gpx6McZCGc6rICUdt3d7Q+95Qr25Mv48ybomgyH/
	kqPCAua+0P7MA3Qqx45lHg+1tSxBRtg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782363586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTky6QwBgqRfHryRXAJQzaU1/mYoPwfIJItzcOe6/ic=;
	b=ggV4pj3p4mYGb2wXB82w1ez5xMLRRdH9RAG36h/RnuSxZOiEpXPotXR7bYCD7I7oo+QVYq
	SlnbgoTxn3vZWCXOj6OLyOThfGJAjAMQ11pmhSIL9VhS2kFoF3ftxVhU2xDMQ95rbqiAOZ
	XJnKjXp2XUrDR16HLVJ1Wk3TdnIxEQM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Fs1Rrmwl;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B90F6440E8;
	Thu, 25 Jun 2026 04:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234681F000E9;
	Thu, 25 Jun 2026 04:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782363584;
	bh=aTky6QwBgqRfHryRXAJQzaU1/mYoPwfIJItzcOe6/ic=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Fs1RrmwlPbBS3gpwqsyazcSBwdPzxTBTWMTSlRw2AQQGjs8Jd8T6YoR6wrPbvIES0
	 RscXu1K5LwfZmRdLb63g5MigtkSccVQYd97/yVzwm44bXbbv1mKwoNBEYiM8YLaXpX
	 5BVEXh048xpL4e0Blhy6r2VyreWqVFZYqHHNK6zk=
Date: Wed, 24 Jun 2026 21:59:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
Message-Id: <20260624215943.332f1bdcc99a3b85b7df0822@linux-foundation.org>
In-Reply-To: <20260625034629.nmgdwl2c4luwod77@master>
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
	<20260624131457.ac81fbac373f78aa80a516e3@linux-foundation.org>
	<20260625034629.nmgdwl2c4luwod77@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wunkwjhixc3d1fa6599nqyg9simccuse
X-Rspamd-Queue-Id: F39F0A0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782363585-851412
X-HE-Meta: U2FsdGVkX1/hT6bI2EDTNgzbklh0m0GXKGg6UNC4swDAZjYVrU7awf5M0nGWSKfrEEz3EV0XTylGM4kFiDgsA5k5l+jky9qDsq071zREHokCvEpZEK+4qUpe8iaBPiPGxTQFTRWAiqSoER/kdu4T0Rxq6NCwzFTeunP+r6gWdi7sgxQEbr4XcrU51uF1LmPAYaIIgx/XxlGTt6MU6fd5oP870eYbp0S+LvbpBupYVSYyG1ikc4p+wwKmJFFKrkv/OYrgcsNoyap0O0ATrQON3Ug+KkrqXH36rqWFUJmgICCN/Dwj0XJK7ULKCU9vdO8xEVMKTkjcvtuargwCAaR2A7SMzQuMvgDc5kfdxOb2jKmGhxygsDxVGdK6qWLUUJoPUDdx9h1GwOKrJkDVtYwbNcKwTpOl8TOxof4oXbmSyFlKkbU9eH1oIVg5jLWFvYVt0Yb+GTr+KGOzC65dV2O/hjVwpUhCUEjDliTePChsMy9AJoJJsSQm+TSM8D0okgJbf/VUzZtUH2Jjs50HvmG0u51XF+s1JNM/rnUMOJrV5L5v9vdKVayHncz0pyZ5hqBfXUMyaXoK238qJyMjUG4+F8PtCNoBPOUWFR1XBFd6NBLJFbnG7z/i4olXxJH3FegOuo8822tntPtYHPdbyAn+gNKOIi6ORE8KzQLTgmqV45/QeQj22kYqehNXD6zOtHRYcJ5OId1k+YnJhAo2NXc7v1o0athG6/13EQq4OC0T25oQshSSaJ42KAl725v1iyGhzJkn5RCMUD9Hw4S+V2wy1Wq+wk4w8gp+V3gUj0bPEAwW5Y7NS/1HTSqIByrB8/XvJs8Z3bWwfZGKBUQoZc35Y7mWb93bdb60Qak9By8eU5shH1nSzu9x8QhacXWoqB6EiedqU5ATugTtrMNcYSOw87XDKByE1MNwBcfjK5pfUsq6m7XvYUrri5u2VnI9wlTHjjd+AIqG2pyM1MURbk2
 cqoQQa78
 w3VXPt7M+CMbGfui+OnTpepVH3xjBilRsPJdqzIWUgOomtaFt6N+1TJDhc87+4OVCrTl/ofa0s42lphjrgpSEf8gYK5uteHClUvD1TiGhXkrCwZfsDDs2wI/aJdzpWp8tA3YJLhzClwd++5VnHp8l5bgNAeS8YL33nqfbbGzKkJcmFCBdgukp6nm1+mwE6PEifp3jGgAuYQs+s8gvjSdZJQ6K6lYegrSCwS2Ppt3oE+x+3Ypp2JfHEWRENEPdXnQWSm48xho7mdv6IDH2J7KCQ/YYYz9q8kudQLrNl9XIcbw2Q0+hkBU+0zEIYA7sy8dOvTUD7ksCa1nvRMnMQChdAVSLfwLG+lABuomaPpTeuctc9E4NXCTcY3wNy9omlQkvjEXNEc90t12i8+bBPpx0ohbcoSnoETXuyJUdFGy06NrVHDQou094LiPn3zWIpPiLRp4P7++6VAViG223igNebENW4mKj2DmGBziRTGLFcaTMyMUWYsOZ0EGiKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 03:46:29 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> >Sashiko had an off-topic complaint about the surrounding code:
> >	https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/
> 
> I see this robot reply, but not see the Sashiko comment.
> 
> How can I view Sashiko's commnet?

oop sorry.

You can go to https://sashiko.dev/ and search for the email subject. 

Or append your Message-ID to "https://sashiko.dev/#/patchset":

	https://sashiko.dev/#/patchset/20260624082359.2869-1-richard.weiyang@gmail.com



