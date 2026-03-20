Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359171098799
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5359A6B0112; Fri, 20 Mar 2026 11:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D9D6B0116; Fri, 20 Mar 2026 11:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423746B0117; Fri, 20 Mar 2026 11:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30C8A6B0112
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:22:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8B4E1D20E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:22:13 +0000 (UTC)
X-FDA: 84566807346.11.96748C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4A066C000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:22:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RmPl7NqM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774020132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzAtZyF3VNZR9kWnMtOJhhgzXMpt189RqNEVdW+eJxk=;
	b=M3fMenkFRq0VZ/yX9H3a5orVXQe3IxSCfoTaF5bJqZHg2iRjljDdECSTT170M+wjvNvL4L
	abQ8y9POaDRQuwvfhjgy5oOjzC3vR2HcsaIbYXxNBP/HUJkoIxC1sjv5/Xxyydfdzjbafh
	SROUyWPhAEn+hLHDzWAoRgt1ibXsiIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774020132; a=rsa-sha256;
	cv=none;
	b=Y4/UODKxUS1wp7nmzpRbj6+Hk7usxbl5+e6d5EUF53RXJDhtQNhUCzAwjwO5HZLVi3bk+K
	2jXwecDaEsbwaVltWbQyO6xj16WBnZsCaTXYJDVN21WWuIUz8NxviTdTJQt4AW2iIdEmTj
	AH+8cKRXSk9qHtTJgIPCg2rH9wKpv2M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RmPl7NqM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A8EEC60053
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4224AC4CEF7;
	Fri, 20 Mar 2026 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774020131;
	bh=Lhl4uGbjNhDWWUkPCE99I5Yld9BxJ5atQzzo7ZYDh7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmPl7NqMwKwM+PqkVjDPfPJ83uH8zAmoGL/nROJ00W0n4NVR3iYAy3jTFACEolNvb
	 bdtPOYOMV3jic7BQ7k6fANgCrSeWw4QYX0/styqsI7cwo0VRvyB3O8K1s9xtkIf01P
	 pdE0kTSuXUUfoP4WEgQtJZoUdIM4a8L4I1VxYEALoyM1ZLFxpEpdzWAK+gamlY+hSu
	 xm7uSwqSnTQqNTWNsijfHOXdTaRdkLgqGJWhnLh3wgy7OHA7tqtw2SGjvZkmo1ytr8
	 0XpTdSA3RkdDn+YS8xUZsSoPD/rqtlSwStQJOltyxLpeUMRkjCfOwimEqc97XsWli+
	 9Oz+N7PCRnL6A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 07/10] selftests/damon/_damon_sysfs: support pause file staging
Date: Fri, 20 Mar 2026 08:22:03 -0700
Message-ID: <20260320152204.99275-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-8-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A066C000A
X-Stat-Signature: nn5bshfj59eurptgmbck8bjby6u6d3ew
X-Rspam-User: 
X-HE-Tag: 1774020132-868520
X-HE-Meta: U2FsdGVkX1+OuTA8FvHKTng5JrIlNeCtgbn3BxEhs91WRGkhpSlvYiulCNhomUIY5DHMRKh8QXb7z6r+x11cR6ysCKUtgHNYFzO+l1EkDtZ5/LD8b5tRrUKHX/+BPHSy7Brkz7RAkmc57n/xyQY8PCnUHIzFCCm3THAtbe5rHHiXpRXMwlD6EuFuWVAY0y5R3KW6tHoFHEIV2jY8XjKQK88BfrgWa6hymIwG7sL1jQ4fKMnvVbi8MwJklCoXOqyiWEMtMcnQ0IT5TDUB3XlUBqJQd5OAv0bQpvMORwxn2KRGBfmaH43cqwYAmfOwvURJdvHOjK0EKNXg8NkwqL6z7qREFYoWOs1OVsqzoUxxhstVB8bCnG/zQAJbGavPrLcyawHgQrm5Z0ydo9UzIOdAx+2quw1fYE3Gz9X27st8PO0NLK7F68CRCwuoBhISMuSH/uJzqZD/2ed+5FntTrIvUxEAJHwYSQ2vZ/InW5vaUAni+YYKT/OMxSLGDeMRmKmroVA3pOnkFm75BRXf1Zd0ShJzxCxJJjTOF6qVfsSiVSJXCexgAX9NsJLAiwFboAl0YxngwlcE6DdRpMmB9HT2K67eldbk8Ub8L8CPyr5gPcJB5e7c0MnwIrzoO/EOgVpxYdIJLyqI1aJ/oIWrxw22qf3hykOt++qnMLtR4PlvjldmTDBlqZcVH8BVdy6OnD2LD073SdRSE2KrGt/eyzATvllwjtMOxZvtRYJOE3PpHp5UpHMrpp6WKKu4Tik3Jp6HLgdw7Uvm6YHk/2DXo76vMgbn4OBpWjkCyN7wjOfCr9ioou092W6g5jbI5l/cge89Z+dEXkAO/wSAL+2QfcifoaO93dEYBgzKwXPXiWYkydafGxqQKr7gPkchqgKigKw4gIGcKIg47dxvudajQD+p6PizBrcq+VHmUJo80N4EQLEpHtWiaz6Tdp7NpG/r73Z9clrAgP2YQDJWu4q7Zb9
 9B0vIBlg
 KQHP88twWr2aOdd1ekNkiBuoEV0spUa5C2BOQmNtnCDExP2mAnBXt1Kzhlx41O5+fm3snbRQqdjdiS17ZB82cPfrRAdPWieWAHlq695dMEJxTrVgRAup8RBlwf6mQ4y84xODTyD8J7x8FYI8pFbMOOVn/dgq7ceSMnSTuP3MGHjfp1OCs7WpJDLQ1dmBuQ84eRF7/gfPiwR7+naR0om+88A8QaTv7TB7RBwjoCA8x1Ki8ONW5s3B8RgD8fwbn8+0doK4DV2RGgO4JaFxaZQ9/sYQBCMT2u7Ez6Md5XTiuZoargeEz2k2AFGCreEXoQFIJS0YeXDkQfLSdZGRRc4jnRxFqSPo89S97pZLVstILR66n3qK/O5CXGZN1BX2o1zSK+8DY5xKqMjS6eCFOuzhdmvAqsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 22:21:50 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON test-purpose sysfs interface control Python module, _damon_sysfs,
> is not supporting the newly added pause file.  Add the support of the
> file, for future test and use of the feature.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  tools/testing/selftests/damon/_damon_sysfs.py | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
> index 2b4df655d9fd0..120b96ecbd741 100644
> --- a/tools/testing/selftests/damon/_damon_sysfs.py
> +++ b/tools/testing/selftests/damon/_damon_sysfs.py
> @@ -604,10 +604,11 @@ class DamonCtx:
>      targets = None
>      schemes = None
>      kdamond = None
> +    pause = None
>      idx = None
>  
>      def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
> -            schemes=[]):
> +            schemes=[], pause=False):

Sashiko comment
(https://sashiko.dev/#/patchset/20260319052157.99433-8-sj@kernel.org) and my
reply.

: Since this line is being modified, could the use of mutable default
: arguments for monitoring_attrs, targets, and schemes cause unintended
: state sharing between instances?
: 
: In Python, default arguments are evaluated exactly once at function
: definition time. If multiple DamonCtx objects are instantiated without
: explicitly providing these parameters, they will share the exact same
: object instances in memory.
: 
: When the constructor later executes self.monitoring_attrs.context = self,
: it overwrites the context reference of the shared object to point to the
: newest DamonCtx instance. If multiple contexts are staged concurrently
: relying on the default arguments, earlier contexts might inadvertently
: write their sysfs files into the directory of the last created context.
: 
: Would it be better to use None for the defaults and instantiate new objects
: inside the constructor?

Good points.  Orthogonal to this patch, though.  Also, there is no such use
case of this class to my best knowledge.  I will consider such change later,
though.


Thanks,
SJ

[...]

