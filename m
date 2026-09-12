Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC62C79FB6
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 05:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B3276B0088; Sat, 12 Sep 2026 01:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7644C6B008C; Sat, 12 Sep 2026 01:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653646B0092; Sat, 12 Sep 2026 01:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4778B6B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:37:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FF81A4DFA
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 05:37:32 +0000 (UTC)
X-FDA: 85204002744.22.780CD2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A35F580003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 05:37:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aSyXENQu;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789191450;
	b=nfBYGmvGXZa7KWFkQ6CEUkdlrLMCEMnAm/s41h8XBeZXbRRuGFtL4Iqx5870pNiTr9fl1e
	2bRBz2Sk4zxziD+b9IpC9pcdmZ/3s1T8LRyQhmDwT08OPtRqpTWfGwIFOge14G7gHGEsyH
	aoxyNXJMN7XlB4Zk01SVtNQns1AJcNs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aSyXENQu;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789191450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYDZtPr4JDx9mQ8QLJdsvTD6GhwNFa+yZjnF1lnjOBg=;
	b=t74HPy71vg5gQQQU16iG1tczjCzMDfQ8Vlyh+kC9Rfepyga1BqEDXmQ5mZofuO3HeZjfiu
	dJcUMpDNjX3XF5Nl9XyCVITAU8jtLGFylNldFcqUa/i6uHgeDREi4GY4DUm8Fo4auDeuQO
	dQUokjDOURRObHUilaRZfSX7EszAFeI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95A6240B98;
	Sat, 12 Sep 2026 05:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC181F000FF;
	Sat, 12 Sep 2026 05:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789191449;
	bh=HYDZtPr4JDx9mQ8QLJdsvTD6GhwNFa+yZjnF1lnjOBg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aSyXENQuJfnTxDjXr1pmvzNwf4pXpivIM0rTS/Pt/0wvNDJRv8dfY29qiUN0kAJll
	 Nb0CVTedvjqG/VqpsXtDq65PM2Tn3FH7Z0Xgk0su1SLcH45twx6K3t/oC1eGmkMryj
	 mwHV4vnRZWAuLT9Y/ljCVihqO3s5Jzk1VBL66A8A=
Date: Fri, 11 Sep 2026 22:37:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [patch v3] mm: test_vmstat: add synthetic benchmark for vm
 stats
Message-Id: <20260911223728.dfceedb4135e0b758df0ddd6@linux-foundation.org>
In-Reply-To: <014ef68b-6312-bcdc-f432-34c31476fe77@google.com>
References: <014ef68b-6312-bcdc-f432-34c31476fe77@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A35F580003
X-Stat-Signature: jeatg4ramiswjcmn684rz3nuy8ay1d9g
X-HE-Tag: 1789191450-843599
X-HE-Meta: U2FsdGVkX18M9upUwhQo3Djf43se+6g5juibqEp4197YXKwpEBZSGmYKtD+0kW+F5xNCwBO7UEaa0a3SAlPbEtoAWguW/PdoWe72PHAT0WpRDsq7hcCAQ3LN77aEVb8/DOcstBDhBo7wa+w8zzU9fOK9p2sGWGHbBSxns8HuBaYTkgBHaEnHPocRvEWeBpQA4dX02q0yZQ2/pHv38qGuuVDZooQVndcnuuzEdwD/TG01pf/YI2Xh10O3rnIBEOQiAJ5X707ezh9lt8mSU769hydK5ZDxDgFdUOq7vKKRVRQKumDBguPBDla9ZEJKfvwOCoNxDl/It4sUGeCW0p9ys0ZvuETj0rOME9Po8t7LMAS3EyPfwutzFMmbm9Zht7D6QFWJlgaJMKxJmZwrhKqghdYpjTIrzvYYUKj9co9u8MEgo+aPS8EhYyePTrQDzmTwtbgptYzhrICHtSmPtbn8T8PUg6pixmcnmlHXhc40n7Bku3DCUsv8bWMrLXaWMNVDbgbvIcArM0NHq8FccmZZm1dNNpeg6RdJ2Gj4HsZ7rx+pE0j0w4d8AT/TIfX4ypS93cjxACZZWlXYxvligQLDbHscKQaaRRDKqoH7aiphVguyHuQ5krYi2N5it+279MTIWjNXljhXXn/BrxV9Wb3WQDrdiH0Q032q3K6V9M4K5K89vV7x6o4ABo3itYo6O0lbxK0Ab9Pgwxiv+LJsHkXBt8yO/+kAqzYYB1ln84vR5HkphT/PrzNvKpBYtP6kOonwVLqAl+tUzZMby9HdYQPcf1f4oMY8kezmQ9ssprqJgYsUx4XQVWGJnGbShXYC7GKsa681nmGMB+yeRqe4/+/ns+rT1ZoDPUQ5LDqDF6e6YICtKnrOzO8/W2/6FCVkT0v/o2Bp0eaVSyUGFerg1sBiYyoRMULQzBdq7T0P8soeBxtxS/vv+1KdVpS7VzCzvvx+z4dc9l56XZLjEpj/zbb
 SWd2/2ib
 qdtF8u51Z5zuck8qMckQxa+1kvaDaWIplPWNmYduuYVKRji8QQ7gvbEwLi4xTi1ro0UN4g1pleBu2/+1m6acIoZZWls93FqJi1adg9ukCzqvG+BaSjfCv2N9Q9AMcaI3Y3cLNlC6vgoF/5ip4aphp0CIYnbnhEgdUzPwENge7Dyehx6PIDigojTuV1vaI9mLS5DSx6rCh+L72W4gFez31KM4PokNo3Iq72ov2IqYbpd0lARYkYav6rBSxHw2oCCaHPMc8crjeU/Oa6JrXw4iN9TuSCbnJxrVheXxRwWGt6ce8vXExxL+btFFg+t0VbSSMJcfDWZPpBQthBFJzc1Adfnexm38U/n163FT17ravjskDFUPxzP/TiQ38KkMFSdqUIYRR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 18:08:14 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> Add a synthetic benchmark that can be used to measure performance of VM
> statistics.  This is used to analyze any improvements or regressions in
> functions that are frequently used in hot code paths.
> 
> The test is run by KUnit or doing modprobe vmstat_kunit directly.

Can you please quote some typical kernel output in the changelog?  That
will help others to review the proposed change.

Sashiko made what appear to be some good points:
	https://sashiko.dev/#/patchset/014ef68b-6312-bcdc-f432-34c31476fe77@google.com

