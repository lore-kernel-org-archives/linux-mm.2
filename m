Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1595606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cZcfx0qV
Received: by kanga.kvack.org (Postfix)
	id D3BE46B05DE; Tue, 10 Nov 2026 00:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13816B05E0; Tue, 10 Nov 2026 00:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26FC6B05DE; Tue, 10 Nov 2026 00:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AAFA6B05DE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:03:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 342001404F8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:03:35 +0000 (UTC)
X-FDA: 85418016390.06.37307A2
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id E956140009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:03:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cZcfx0qV;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794287013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgTYq8Z+zb/9G+ukAwbTsP6zjarbUmQuFNjBPBC3j9g=;
	b=yoj01D10WrMJe5MORX3/wQvI078papjCOEYIHwzzPLbVXy05azPNOg5tjqbiyrh1L09D8P
	bKKw19g8PQCB2GlAVdHxGcBdsKdKhiT3u2TzWbyxsXPmE2mZjyyZN+X9qvi9/44g4N0fgH
	/YFSkoXq/kX5gp96JW1Nowi28Dq0jAs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794287013;
	b=XWNMBdRNqoFVtpE90tOZHs3nDJMTV7aU9JYTrNmzfDddjhtgZHTRFqsSqG15qSI7upSEDF
	FXVvnSL9MVxwt4CI4kcwUNxN40cIo9kPzbbLHe0yxkrw8ufwHHTrsuuUANIQ27S2BxQXm7
	93i6dVcOv918CYaJgQem0uGatHfHInI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cZcfx0qV;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sgTYq8Z+zb/9G+ukAwbTsP6zjarbUmQuFNjBPBC3j9g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794287009; v=1; x=1794891809;
 b=cZcfx0qV+dEpYe5WAWec+0Thjmeu1uV8oS+V7CwBHB4AtgUChUF3rz6lKiYVoSLBYxPlCar8
 3EWvGHiIr85WGyV8BIp+vwsKz1t4oarkSXh8yT8MTeEMwZtibquZbVKJjUKrJ8xK0YlXnuAHkC4
 HGy1b1iOnTl5iarO6BKfOl1A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 77ffe16c7a4271bf;
	Tue, 10 Nov 2026 05:03:29 +0000
X-Mizu-Trace-ID: 77ffe16c7a4271bf
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	lance.yang@linux.dev,
	ridong.chen@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU) update
Date: Tue, 10 Nov 2026 13:03:23 +0800
Message-ID: <20261110050323.88803-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
References: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: uxr7araexuesgr7ck13bihu7416ndmyg
X-Rspamd-Queue-Id: E956140009
X-Rspam-User: 
X-HE-Tag: 1794287012-225741
X-HE-Meta: U2FsdGVkX192CCkXo9rCMl0ISzHX/BeDN8bfEnygWela/dcRXZ4kaky+FUnOdUYmjCnAf0B/t474LIZZPa7HgDG8+EXV/lNpX5bxWV9hheUfJ4zN9trwMkNTbNNJqAyBpCsgOKlY50vvAtaPlQiZ7ELTh0W9CQFV/XJ9il4hbFEHD04W2ZxbqBgSPbVbAEHkx9PahLAFKiOs9e3utVirIZ4Cpl4qBH4Ytt4GLqc9bi/HcX+lDIZM4zvaVLIvatgbeW40nzzofPcnsyDjePPLGZh6+hoy+4ftGjguQ964vvjqhfJt7ehMcXKbb7kHq+mRVM7VREj6AHcwgstph1iQU2qA3eJi7YJsqSbktSWEYsiC4XKxWXNjFi8mGIaHxhvCBZHFvWVFwqQSGqbklKf3YM4AXNXwOTQRxqt3hL+1LfZSmrgVAvCpgB9aaOglbj72vXfXQXoDV7KGwRwAJw+RqkBAAaJpfv4We0nY84olL2T/2D8CJvrUgdmONk3QK6Ohq1lqpLmoNE7bIeY77tvTJhRdsnckkeHK2+lVvz8es60nmPhcelivjrB75N+pL51FEAOHwm0z56yE2T8NNhUIS9UP/LB0YZTxmxR23HpqTzRwzOsa6n38gvGrXBWqmjGdcgdw5c957lLJQ8jfjeGKTuQpwIcjdiBMDFTTZQkjpdum//rTSOqnyw10B713tqlB+UNQJ0CjkgOeB1MAFHcmkNi9lY0Dzdvp8Bd+D1SwPnU4lXxoT2aKqCjUEOsrwdq70TAbno51lPo5wAcH5ISBsS/RH1Y8okPl0mxowmLwC7ImyU4+51cLDZZ/flNVuobipChhexE9BY+dS6ng5OCQUdhKUMLY9v01hbdDrDIiS4DKwgGyWkpFGFND3m8j4GSxQNF/Y1cN/cId4k6QI6ZB8KQOwCpT5C2nTcKLMaWc+FcGPIWgABbu2+VUV/IQhFQ+b0JiktXz1kt6fCx0nhM
 syeTaUNH
 xSYDTMlS68yXiu5txdJxUAf+DEBydqvMj1nFuLmakCU3Y6bWCPnO6gOE0b6z3O/5ENioXIhrgCz2D8G1pZmEZjRxZOj6VuUXJW3Z5WofD0c76wTMPQMpX4TIxKhw5AgsBporNqnqL0Hj0QCuWTe1JBwVBaH629/E0tsgMUP6y1Cf0HCUNRwuEqizx8gl5BWkrzkik2FdcH9hr6T5g4nPiYB/CnQeyA3l7q07YDJwOMlWsQOGfsqBPbvT+ypb1cdarB0AZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Mon, Nov 09, 2026 at 07:31:53PM +0100, David Hildenbrand (Arm) wrote:
>MGLRU is currently the only MM component without a dedicated component
>maintainer. Fortunately, Kairui and Barry have been actively
>contributing to MGLRU and have volunteered to take on more responsibility
>by officially taking care of it.
>
>Given that Kairui is already an established MM component maintainer in
>a related MM component (SWAP), add him as an MGLRU maintainer right away.
>
>For Barry, the idea is to transition him towards a component maintainer
>role over the coming months, starting by moving him to the top of the
>reviewer list.
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

