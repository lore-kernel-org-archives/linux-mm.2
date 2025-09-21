Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66200CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 01:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F578E0002; Sat, 20 Sep 2025 21:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FFF38E0001; Sat, 20 Sep 2025 21:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3153F8E0002; Sat, 20 Sep 2025 21:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3788E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 21:47:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E207160248
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 01:47:40 +0000 (UTC)
X-FDA: 83911570680.01.00FD95D
Received: from r3-18.sinamail.sina.com.cn (r3-18.sinamail.sina.com.cn [202.108.3.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6BDC9120003
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 01:47:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=QhK8JsYv;
	spf=pass (imf29.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758419258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeZHzicfmw3ew6bAKKgtPcL7f278bIXpwpqKyaudnJY=;
	b=WuV0RP+nAVkhD+B58OFi/Z8I2l/HJ//1kSJZr5mt9koWxvNHb/s4KWFCvsoglRiSY3VFBs
	hEvpQalwF/4TQ1q2uFCJZ9HtRoLh9RWvkBvlofsosOjs0LnKgbYEunr+VpszDtRS4/19Sk
	rg7axDOa/UprBJ3PT5ZXpOikjeHQ2pE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=QhK8JsYv;
	spf=pass (imf29.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758419258; a=rsa-sha256;
	cv=none;
	b=bxrc4exJdjbcp6mAACHcmbdsnnf6JrCBzwDSPOpoSPX01TU4qT95rF1TOWgoLllkO4s0Xb
	lU63NtCRWnwAlOF1TVuIxKKB/027Aa6GJWqXlxorwAhVkYUe2qu++ytrG2fwEuRIbkdbGJ
	Q74PgcuqLUTQl9Ba7NZh/Q1PE7VRKas=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1758419257;
	bh=jeZHzicfmw3ew6bAKKgtPcL7f278bIXpwpqKyaudnJY=;
	h=From:Subject:Date:Message-ID;
	b=QhK8JsYv6X3W0YF9IrL9fvYPsBUUaXqmNRsB1nbv7bGS6sKq8GExCZef4veX4Ls/2
	 +kmwbNjsbmA1KZV6MPmyXbL8r3WuSpC6OlSJrz8QeZoZKUzbHezbmtKiKvBx+V2vR/
	 R7B05Ib3fpXW8La4hxnfkUwAmV2Cxbua26uYpeI8=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.32) with ESMTP
	id 68CF593300004ADD; Sun, 21 Sep 2025 09:47:32 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 8160464456877
X-SMAIL-UIID: 3064C4316E1D4931B3261C34DB6AA6A4-20250921-094732-1
From: Hillf Danton <hdanton@sina.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
Date: Sun, 21 Sep 2025 09:47:20 +0800
Message-ID: <20250921014721.7323-1-hdanton@sina.com>
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6BDC9120003
X-Rspamd-Server: rspam05
X-Stat-Signature: dtwfbje3sxbp9tn7fobj5ht1tohods9k
X-Rspam-User: 
X-HE-Tag: 1758419257-219621
X-HE-Meta: U2FsdGVkX19p3vpE9ZAFoZC9JAN83ONEbBlk/YdQXg0IpEYQFaCgoxYziIXn+MefNww+H7htQd2Bg1quCnsNgf2gNKF5OILQKlbJi+MBZo3JUg3W/anBsdPGzJ8jHeyZ0JRtECh1ZVl2KyojyxmALRtztkIhwvhqxliVeQYpDCCirFz9fSvCyOsSVcS4eRLJLNZeF1Iopc1dB7u/y1p5pRJQztcdN2vpDHpVMfqpw2mKFjxlpy6VTk3ZsU92AefE8xJuyyTDVz1ryMgsckDmnEw0THcQdCPZq9AfFipOaD9vZ5TwXEMF9qn1y3XQUQuvEqdwSBtZ0BPKMiR/5MJsyyeCo/6I3U55JlZiYtweq72rDCTExooo3cnl54nLDSQ63485DhIRPyvDOBOG2prG88SOHmMEIQaxcH7epW+O9GwX4TNJO5e8Rhy6lYW0JwaeOvgnpw0KV9O/AjA8M1koMWHHXJ4FKQRhQ/r0DVn8GLEoSvwP5ygnP2ODBmSY0Hjd93U70rana7xs3Gl/NoznKaQL7WICTDX17m2NRZs6XKiYgLid7G01hmMsgrwXd5EuqOQsvQgb43RR0dbt5+K+rT4jVDXSu1Qo5uQHl+9nW0GfE5HE9G7nmTAgYWE+BbPZKIlmACMFqwa1Rxo0qulezwvnKSlPfO6FYzB4E0Op6/ent40pKJI1XrVMypDRQmq4sMVKKDw9fyRjpDOZ4HHn0APMe8Kx8XJsg8wFLFYhxqEbWBJG6VBaiX/nWjJRXNtV2ZzfiF4rJhZi1djJU6csX8r90FMMvCuN8wZ1eVD+nH9T3b76jX8IEndwGyuQQqvRwt9y2uXCSxiw4Si+1yi3Q7OkmyyaEi7s4cE6fhJ6RO48SAtC6g7R9YMvX7tqjHleWI3nfeVgHxrGHQQqVGL+1LFJDywHKKTWpPnbK4BHNHVF8ml6RdRA8lkAjExAKFXkna/tMahqj9GaVoBnr3a
 3qvDULDq
 BHm9VuPO1qtRuU9Cx9jqmGZ+WyIqe1Rtv3GfH9JBWu5LtV6v+VnJFUTYaAZfoaXBcLWkFzytDGvO+//RwAK2Uudd8g0xsnXcvwmAJvf4Cvu05Mpf3wmmzc/QCOJaCTdQy1zeSTqVaeMBDK4UISGTYEo2CgpNlXjRoUhn8FWjAj4Ee7WcePUho6Av2pP0Xj5leGwal/cRA2swybVYsyIquauAH4ilYBbMDhsfSlmXnha4RlRq5x05nC49WitW79+65j6UEWQFuOCmq8YaleFWct951PevxNMdC9uP5jm/7Jc1a8AGJUBaJQ+Q0wuNuc2EHLmh48jJYVJ23KDcBpBxCiFyueVQiz8q1/aCXurFGD7apc44np7WM5nHGVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sep 2025 15:25:59 -0700 Cong Wang wrote:
> This patch series introduces multikernel architecture support, enabling
> multiple independent kernel instances to coexist and communicate on a
> single physical machine. Each kernel instance can run on dedicated CPU
> cores while sharing the underlying hardware resources.
> 
> The multikernel architecture provides several key benefits:
> - Improved fault isolation between different workloads
> - Enhanced security through kernel-level separation
> - Better resource utilization than traditional VM (KVM, Xen etc.)
> - Potential zero-down kernel update with KHO (Kernel Hand Over)
>
Could you illustrate a couple of use cases to help understand your idea?

