Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D11CD343F
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 00:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45896B008C; Fri, 15 May 2026 20:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7EA6B0092; Fri, 15 May 2026 20:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0BE46B0093; Fri, 15 May 2026 20:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B38C6B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:04:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30A021C09DE
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:04:42 +0000 (UTC)
X-FDA: 84771336804.03.C15C757
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8839540010
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:04:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S+z0kN9M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778889880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2YDqdsXw1gqTyNzc/aLMeUagryfveJdeY29gs4u6WU=;
	b=u1OO9M7nHmR3eRa4HkhfadS1ydv4oWSr7MlBTnKjRWAe4B+igcC7ZFBxDbl++YcCYiS+/z
	gnn6Q7sQpzleIjs6xI3OT1qW5lk2youStr3hUgFTJ9aTQKmMpPANLrMQ3V8fCa3rOFYky7
	za31agYhHpitJsxuzh/v83PCQeUGdaU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778889880; a=rsa-sha256;
	cv=none;
	b=N026Ws8npN9cgtUpiibWDJ9Br3cFvgY7WLskuaRNUmQRbVpW4/c5OfCpgDvqKY8oYiZw9G
	7cNkRUaZ7r+KlWXUWIIRuIWK+K73Psr6AWgGTpZta2IRvbeaHUoRqKJEP39d9wYnc+p7VQ
	pCBscYuUT+cYWn7zhSrEOawj2e73ssI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S+z0kN9M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07BBF60142;
	Sat, 16 May 2026 00:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7BEC2BCB0;
	Sat, 16 May 2026 00:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778889879;
	bh=vj5P/NjZ8tYQHvsrvWgGoMNlwG0hlLKJ36+2f8l1xY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+z0kN9MA2H56bxWGyY36moSbBGEh806bGCsbkTEOR9ies+a8QYfrIARoCFGykcfG
	 bcl2b7l29jne2qqvQL3IfT1AiOERUx/s+picR2tbMIDzyNsbGoE70RbWGXSkmNUmkq
	 kkNENTC6wmmcOCVwcRTLFtXD8STa7/+NNiT46tFeBXgCHD1tJTQY18q1/vdLKk4qWC
	 Ekbs4HtPppxugDkg2AhpOX3lxtghjENG+r60elzNzV0au4K5F52JcRSW4rPgX/N23c
	 LuxXXiTaN2coOWuvOjSIwqweson3BW8kE9DrHyrEEJthHStg6C2E68ZkglnKY6b+Aa
	 nV/k3XrbRw+vA==
From: SeongJae Park <sj@kernel.org>
To: wangxuewen <18810879172@163.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <wangxuewen@kylinos.cn>
Subject: Re: [PATCH v1 3/3] tools/mm/slabinfo: remove redundant slab->partial assignment
Date: Fri, 15 May 2026 17:04:30 -0700
Message-ID: <20260516000431.136616-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515065325.4009527-4-18810879172@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8839540010
X-Rspamd-Server: rspam04
X-Stat-Signature: c8sehn71jaazqfbiu4ho3prefp66g74a
X-HE-Tag: 1778889880-794457
X-HE-Meta: U2FsdGVkX1+mQtQ95ZEnZhslElL7aDnLC43EZS1W56w5x6ldhzn9lhNbx43bLI1MymJbyVAKCLv1DrjUxKzrzh7rEKYLYjsr0JXzBYdRmTT0wOqkWp5GA2BedXIB4xsYq9TkjtVYA7TmM3wFiAv+/fFO4XTVgkMcd3KwYPwWM/ytxvmw7mN6u4wCrbSNfSMVdE8mGPHNCNj2ZKstEVYDOlsCvHVDRa3DK7hWtnFB99gWw6XuH5rPwoPKy6RezJWK4fCMciXIpI5pnd7XBgMpKmYJOdWVEi3uKHVffgW+AYAqv13uKH4C5i6JaJvpmp0GOn+7N87XLku5C7+QIyekmMF8z8vxWRJp8/S+l3XMQYNqKqJykGH/ozWQ+AAzaR2aK6U5y0HUbRNLv1DK9lOgxNxwnUA3hqnoHfAoGdtHrtP7QHIxhsvCarpj9NTWtW9k2fH5KCetjrl2wgliOl4aItr4FcPo4/WSj0EH8A3vS8YtR89SJqnmx41j/bVplZNRf+zwx1LYfr83PEwTSjDtATsvWhc8vwc9BjGq19qIeCeksDuRDV35d+oWys6l8RR2W+GfUndcgbz0j7o0lfA4Hl41ZLEFEBwwDX4NPWLxdLEHVZ8z1VkBFvGE4fnEZHjYenfAy8vJAteBn3u9uVYUoSAp5FQnoeZ4U9IcJXuV4TEgR+3BC4/NJlAzehufk0Th/zJaPtCJHr5ZNR2XkhI/a9Xv1PW3efr2kF4UTUa10IwM02cVMGgYtCYxaZfjWj9TwtEe4F/RyY86xZBi6wgvazD6mgTMhmTZmEAk0xkf1epo/m5mcC/+TG3lmeNaqtIZUTyHSNqGVzYeHs0NbOyDKurWTBK8woibnWARgZIHvuJyChvsLiQpOCbilhneciG9HCcqcA70JVhlVTIpYbbnlKxLUgIFelTPC05/lvKFQVMKvggxDy7qxhg9L6w3pBy6x6LvNOzaYn66XAGk98L
 RXcVy0Wc
 dTGC3tzJjrYrMJGU5p6PLF0YdfG3SIqx48eHGumsi/EB7YRRmJIn4vZ/whY+KRNKhY+dhdDlos6CQKOjz/OYcEXEPRhccBSdkxQ3ashVEXuhWaBY2/JW3j1YppxyQXw0nkkIRQb4v3t7Zilg3e9vxxaFq+53wrzMtnniM/+fJ0aFJroxSZTP3kwBF0sOA/8jM+yEOzfLIGQYkyRGXRSI7c2V1HuMvjBjf3nFKpfC5nGTpJsTsrQCpBrGIt/6F8agMXBHu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 14:53:25 +0800 wangxuewen <18810879172@163.com> wrote:

> slab->partial is assigned by get_obj("partial") and then immediately
> overwritten by get_obj_and_str("partial", &t). Remove the first
> redundant assignment.
> 
> Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>

The singer's email mismatches with the author's one.

Assuming that will be fixed,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

