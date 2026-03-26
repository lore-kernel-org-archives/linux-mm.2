Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68209109E530
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 00:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B151D6B0089; Wed, 25 Mar 2026 20:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC64E6B008C; Wed, 25 Mar 2026 20:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DBF26B0092; Wed, 25 Mar 2026 20:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD506B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:28:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D1621B9045
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:28:25 +0000 (UTC)
X-FDA: 84586327770.17.2510AE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B1D2B12000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:28:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="RC0dW/1l";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="RC0dW/1l";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774484903; a=rsa-sha256;
	cv=none;
	b=SZ7Ss+zGc87vHS/Lv0MHtaksPrWqAHfhRRJRdmlxdqFO5xQVmoSzcpciCGjThkGhqUbx0J
	2YC013YIwEMpf1Ym2ByFrHsKDZy5hVrkO/1derLNryJXOWlX6IA7byyekBmVdQBPs7owX4
	uAQ0YnM3WVvNsYIxCiNwjOesU+dVuBA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774484903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CH5ZozcUWQ6lq8A1NVyqYm/jbMnbClOkF4kahXsoU9I=;
	b=0pJcDE4juWF8OkWsJlMBOyrVvXJ40U1QusBq58UHDzIBsHRTy0tgy4u2ONCFn1ILspoCkp
	qZ/1OoQyDvYrsHtVgpVLOhNRRT1NnOHRVpimdy8AMLe+Ai6UZOHY9oZkCp0ID8xYoGDqPZ
	tbx6+R/qz5scRfsJSHBz1bN1FSpnXNI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE9C160053;
	Thu, 26 Mar 2026 00:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12576C4CEF7;
	Thu, 26 Mar 2026 00:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774484902;
	bh=w/b8eyEOh/mk1W3dBx5+GgWy18Ixkyxc+RfaUwy7zlg=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=RC0dW/1lAhJ+jsD6juY3kSZgjXnUdGcAuLneGLOX4lepKrAIjVqL9AWTGUnpjG+5v
	 4OMN9fMsnC3uuqWG/ALz8kW/ln2EyMAbiWATu2v9u6/6sZyAoavgaI2hhLAy4YsbAq
	 /CorONRKp3kt22ef4Sf1mH8PKy8aVgMdvqLzIjng=
Date: Wed, 25 Mar 2026 17:28:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qi Zheng
 <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 0/4] fix unexpected type conversions and potential
 overflows
Message-Id: <20260325172820.95a0ecda646c6c06dfc97ee0@linux-foundation.org>
In-Reply-To: <20260325165716.5d63522ba825f25a63e74e3e@linux-foundation.org>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
	<20260325165716.5d63522ba825f25a63e74e3e@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B1D2B12000F
X-Stat-Signature: bb5yehpripwhx156hiyinoi1b77agprm
X-Rspam-User: 
X-HE-Tag: 1774484903-45452
X-HE-Meta: U2FsdGVkX19tM5gojbFUssLVzQsd/NInd7p+l7IAVmc8EBQPgP/ziJ9gUjH9KJIKz8RJhn3qSf8FxB3bVvyeIsrmYe1WNliSRDUKiAQfiDEPaRspSLpwTegNajkqOY49tRE2Y5kOUWFfN7HFNrFjk24hBuBRHg6WQuGDxwj9jYdBKBK7XouPCcoMMILCR+bAnlNRZFdEN8xTja4kfrX7i0qPSb3bwpdWwnciYiIq0nvPLNtYpFzY351ytg0bYEuNlf83De6WgQLe+mFEcciVYqIZGyDTXhn1Hybpn0TVaD62sl2apDipj37zX94n7+worDagC9pEGCp9lyVZo49/4QSe2MM0Z8HXKzrJjE1SXRx/BcolVEDVeoFuE/FD2fqoLaTA2BYuvSS+NxWizSbvPAXvWtOVrshaYqLgHmMVMPzJ0F4vsOT6A/CEleVrGoXc9u4cQ4ZxB+NkOc9TxHr7/juOQw5rH0simD6RbkFMX+p7R6e9Z4SJQ1xiGF0MND8IyEcTEuDtOJ7NaMV4AJcmtrRLlPysoZX8XiLX9KV1SdShi12G7lu7OJ9GKURRsZNNGizp3ZzRzJg3byM4wJiddR8w3vo6Qr9g2WmmjWN5H1vMfBMnlb0OeyobSKjbsnfvFCGWT+Nq7vjF1CA1eTXdbMknIcUYvWVjAcOQUCsBtRVhaweTLWpMYf/ohkhzztHb9YrlJ9IpfucttdZ/ZDotj0PHE0uSGLPYZvCEnFAPIjhZ13WORRDfGUFu8hoO4m7lNda/bn/eEj/1Pt4xulsAi1WBZX5Y6fByAAEO+RKhwo8KqxPfAcK204j6BfP7bgTxdLdVyUH5kG52iMXYVRzchAmSrI/Q70aPtZ/iKZdk2/mLhdXzDLF3aWzkvvowdQmGoIx+THSElj0IK8Zy4CpbQLhjgm+RzkuWUFbv8C1MiXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 16:57:16 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> I'm inclined to mark this "don't care".  But if we decide to backport
> [2/4] ("to prevent potential overflow issues") then we might have a
> problem.
> 
> Also, if some downstream person decides to backport [2/4] into their
> kernel without [4/4] then they'll have a bad day.
> 
> So perhaps this issue should be addressed within [2/4]?

Actually I can trivially do this locally if you like - just turn [4/4]
into a -fix patch against [2/4], squash them together later on.

Please lmk if you'd like me to do that.

