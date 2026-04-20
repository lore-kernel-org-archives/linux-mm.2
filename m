Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A278EF5A8CA
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 23:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01E616B0088; Mon, 20 Apr 2026 19:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11166B0089; Mon, 20 Apr 2026 19:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFFEF6B008A; Mon, 20 Apr 2026 19:46:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFA496B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:46:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 741ED13B5E7
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:46:06 +0000 (UTC)
X-FDA: 84680569932.16.15B35E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id BACA8C0007
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:46:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JDnt4ExQ;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776728764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dbm2yvpmAyPeL9b3gTWy0w8ElMKB3phoD4yVZ/09Jpo=;
	b=Kq36ugYpk2t05qGe/xD3e4vTldQCTsfc75qeIgLmIfUGmYhT0nYZ9Dl1oTkDvMnOhDF6zf
	eqdt2IGDf46zEZAEkQdNjuhQnr9wiw1jSKoqS75epCBg9uuFfcvRGtjwohbmoNTPPRM4rX
	+iTG7RK7oc9WinKGZ5FYBzUueaCkrOY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776728764; a=rsa-sha256;
	cv=none;
	b=v0QZiV8m6PHxC301FD+ckIRK95Cbh0oGTkYtjUk1N/jPBp8Sy10FGLQoFk5LVlpfI9HQEK
	xOnWKFZSz4zYGt/+w+6FRV6hXHXNqBZe1kT9f3VI418Y3h0f3HLY5UHnlaKgSihxlM5PBX
	nmc1jz1cE9RPYkEOaVGQoJ3L96Hgq+4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JDnt4ExQ;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 96E2643655;
	Mon, 20 Apr 2026 23:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2ACC19425;
	Mon, 20 Apr 2026 23:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776728763;
	bh=QcHKNAPKMgZJbCP4QyTrKg7c61pwrQPCwenA+42Ta6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDnt4ExQQOZS+94twVkPx7zfcYRrYwsWg4Vo4iE5sCT7orDhUZAeNaPHqG6rMAt8e
	 uYnak1ro/G45k/b+8oXoXbqgniVeWWFieWtwPOgzLaMxKSzCmaQY941OL7NmqJcIW6
	 NV+J7efXb0/C/IFIKVuvA8Ky70BwtzKOMtUKnru9iYCVlsDOqk0HwqfLL03QB4N57m
	 arRM12346V2H2PzjuE9P/46dbFVud87C3TDjWwcxQTeCUtz0RzB7qttKRuqpvN2q9s
	 4LbiDCRU5mZAA9YE7n492/UWO9ZK3b9fHtZ8GyPJisFPHlbicNmufaKki7cYojgfGa
	 oLUi0CvLcMwdA==
From: SeongJae Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	linux-doc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Harry Yoo <harry@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: clarify that we are not looking for LLM generated content
Date: Mon, 20 Apr 2026 16:45:53 -0700
Message-ID: <20260420234554.66290-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yq5hyrxuguz1emsghdtqokkgxusnht3n
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BACA8C0007
X-Rspam-User: 
X-HE-Tag: 1776728764-240631
X-HE-Meta: U2FsdGVkX1/sB1JEAmo8a3tqNA417bNzPo11Hssa86twgKBDqCQCXqmTfAQsGw472g+K10CuB3QkWvqefVXmUE3zvaOHX5fxSqrWsMeEoZHnQ532juaJUofD4ubmkQd5/mfZE5SCBqe+27j9iHWNlwpv2WIyDpFWbqpt7L/YWV1aSfuUA+KcBRCxtvwsyMRUXp5+Rmd0uoNmtFhePGB0JshioZQ2d9T5rLOHCw0a5y2FpGO9AvQBuu72poFrON2uaRPjiVXDi1slUaL7fYJGnBmJ9Xq4qwPGnXFHYPs1OkcsVbaXEjJCA5OY39eu+wwtRyqmxfMJt0XkeEMkBy0byvO1Z524SjnRYx7X0fM7QWsESKT7kJiVrISrUSgd46ZvHGB2CGOalnKxaumM++ER+JEJyl/rnQCNntnatCyF4S55chqoA9lyn3m+MBlTw1Hpc4WXpXyv9g3pUCD+wJsNcK1kF4rwe1kc+k288L2G118SDCAwRO1cM+U6vEya+GrUfBY9zTf/sUUnCLlJNYcqmyENqEHP2hVAW4FtcaQWFTvJF6HaSTZYC+hU/TFm5yAkWN1sdkciSSrTN8aT8L+v/lhwdHx7MFO22B7uV5rkucUaZNK5pw9mB/nEgt+6LpWFNnV66EFzkds+iKnunzl8BeEHlyNS2JLWRG+Y8Q3GpV8oKkkMOYS1f5sq44a+jruFAvD2NQ0Aoab3s5ACBVbOT8eYCqFo0ZVbLc9w8FjtLBpk6j1EcG5RWX6498cW9t4Nb5e4xQJHIIl2fuZ2jKChHjN4WHulQMg/ZzRCxHq/D3D5p2YAAy3W1reGK/Q/dzQHctUaNX79uu0Rzeq/8W0MUz2b1eUwxOrIT+vkLtji8LQSFsFivg1qtxzFQMziMYzjoiEtguZAcAbDYi8uSk32jplfUEj1sJOiTr8jQlSQFHfNHckOpNBamnLoFIhEYFZHTiqLtuSEiN6oEBYotcw
 foYpimf4
 rxiaG0SCyD02jZzVusUH7ptuiZxoZFGGZN2Up0qzOHfGB3Msr+kFQ8Kj91VOLGh+WE5XnwplhNYt4SQjyJNS25mOck178gcwa28Iz5VL0N9l9vxo/ArKkObAVhauRu8sZ6Iuxi4/D75F+nWP4P0Xer6P/CEqGJppgGIkbRC3DgT07mAW7VKKECZkmxZwgLfoAp+Ad3w9R+dl2LJlRGpgQiH8eXrB6bBkRMm2Nsr8LQ1ahyTyA0PCOneJE0vqMBSzEqSX5wlye+MUPDmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Apr 2026 23:03:16 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Let's make it clear that we are not looking for LLM generated content
> from contributors not familiar with the details of MM, as it shifts the
> real work onto reviewers.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

