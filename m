Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 849DFC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 17:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035286B00AE; Tue, 30 Jun 2026 13:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00CD96B00BB; Tue, 30 Jun 2026 13:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8C5A6B00BC; Tue, 30 Jun 2026 13:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C324E6B00AE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:57:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B4D940608
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:57:10 +0000 (UTC)
X-FDA: 84937335420.24.4958E79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D0C04000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:57:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T5+VtVYo;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782842228;
	b=oYvwzmVUokJicRmaY7N6y78Ptzo8kZqouCOz7gFML2h0bprAjN5N1h/lHWEU/53sSbLNC0
	kHIZ1HrhBlRq3OvaLxftvURzc6KzfWXJ6JYoLSJW4dj2NW6O+WIkzHBNGJ4wAO1XwSG+yP
	jZ5UMgu9u0Ycxgd1dFr0UI7ZACl7nng=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782842228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeLcavi7+C47UiyNVjxiH3+XvcthVRlneDG4R02Z5UU=;
	b=B9qtg1aWEo89gvK1zy/G32KVVkVnWHocaMSTryP1tyeI1yaMa3GpbIADUTQIbYXU6jOHP9
	q4IKOhIHg5SxRNLohUX1ItOa5eT7T7Ov2IDhMV+DMXw4Q5uHeEpLnxzx6R1zaIIFxoj9+h
	Shg2vU8LhUuIfEg330zChnXna10vCV8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T5+VtVYo;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED2C4600BB;
	Tue, 30 Jun 2026 17:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113EC1F000E9;
	Tue, 30 Jun 2026 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782842227;
	bh=IeLcavi7+C47UiyNVjxiH3+XvcthVRlneDG4R02Z5UU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=T5+VtVYoHgNKPKYInKQGaNlTZqH30N+6nGAnDXzg+udBxvZMp0T3c1pgTB+jLrDQA
	 /MhtPSoxrAoYrs8XDhmAPOZRE8E+d2bg6pTHhHry4MakeJOVTvqbFPAzndAkFq/UX8
	 eZBwydAcUX2DkQyXXBuqwdrLUI/uzsj/2sxZlZ5wCaX55LyT/yzQsxDHYWAI76ZDKb
	 5IYmq50jjECPLovS3ny6Xnsl0AAZXTb3zvNharrhuJu2KNs7sRywaaws17Pnu22lnO
	 ik8OunmXxDb0rMjrzoFBWFrc/Q2aGmXZGRTqYojAUPVVKc3PxNETmfMoLrd7sKVtcN
	 61SteYKIa2upg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v8 0/5] selftests/mm: refactor pkey helpers and fix
 mmap error handling
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
 mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 keith.lucas@oracle.com, kevin.brodsky@arm.com, maddy@linux.ibm.com, 
 usama.anjum@collabora.com, yury.khrustalev@arm.com, jhubbard@nvidia.com, 
 joey.gouly@arm.com, zwisler@google.com, hongfu.li@linux.dev
In-Reply-To: <20260630073235.3802271-1-lihongfu@kylinos.cn>
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
Date: Tue, 30 Jun 2026 20:56:59 +0300
Message-Id: <178284221941.1178528.16877203101562630238.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: 5ykokrwmk3owg5pcet3tz8pebo7bd3zm
X-Rspamd-Queue-Id: 8D0C04000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782842228-369323
X-HE-Meta: U2FsdGVkX18I073Y2sMVThSWx8WtNiIQD8oOPlLf4s4v9es35oQIlqouFYxb9gL65P+xzC5jRmH8btYxV/lqpB+uJN9FDO65h6CBAK60GkvGp0nO3x7AbyhD6Bgs38dDIvgyjJeiWxvzTEGRmgdt0Vj+gVmZNQ3puDSkKavsOPFdGcHkppiGYlOxddc16+3HpJ37j6Ae4TlvSWiuvqB83+GFl9aPHMLTQneXjuVqbmIHqmzTVXoVyIDRQXGvgb9+dwbzJZBqBAyplhstykMjqbYZN0iUp9Fo7eMMfyFPf1GErvjBKv/0Y0FtZL7EFvJUN8AS5ceBnLakj0pUOh9yaXD8Cu4EEeBnk9Wc0oinOrPFyPnGfcDi8qex7GT5rDn/tCnIwPej8Hq6inLZ7nFtXAHdyFgQSvtNpLq/pfgA70oiw6jWqme2NGPQHRXUmlZ2gzj2SIF/1ibzCrF2SRQGPiNg6y0PQjBY2K6X475PHMWVVqRo/72rCgl/msbfIa9xeJtk52SbgaYk1emqCJwfpZoa+0VrymNbWKQNbKVBzPuRQ12f63+jsss5CiE9UEnDNkvQDhyijruaWnh/8zlMTwsgLtuKTCEIrGWUlmUh0PaWoOCKh9Wqye4hFDrYJozDlaU7DqYSkGCPQ9DM7ImpKwcPSNhd/OGPznDzRfW+P9YWFqPm0Ks7lh5TDb315PASzCygiFfvBmNAoxyH8lfByArpz8ZtUpKlqnmBWfMgsH8tYVdmxEqUa/VjhbFW9NwjHrbA/2cOsnMyiJwiZMM18qLGZO1UJGJpdxWmhRVpJlVTyGt9zwpzsGgu+5JD04HBtSSo3+DvUCasNJVmGEih70WX+U49mLzzOPkIYFcUMlglOoDgoxGIZmxnhyYk99fri6Mwv7LohTSSpKFXQW5Tb+fBDiK/D67lx6bMBN0+r4i5Cvn40ulF2uzVBfTSKxvVj9foDrogEqPg+FPz034
 jT8iA4rs
 s9P+sBNkOyChEo7J+kWitT15VPgC5junuxwSidFiiS3P/7yeFk+ZSbTfo3XxY68BRsRQJVlm8XdJ8k2uBTc2JkkQPEPi/Z07sAafxbqy/D+MBw1AtQRNHENgYe9rt3oivjlHWCcxzVOqAhnaS9fhF+x4mdPU8OMGxSGlENqZh4cJ95RnYakZro509McFP7k2DPqAEA8jcMP6kij7pXM9ObW+bieV8Dgsq71/a71rmVcQr943K1ehRoxT7gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 15:32:30 +0800, Hongfu Li <lihongfu@kylinos.cn> wrote:
> selftests/mm: refactor pkey helpers and fix mmap error handling
> 
> The main changes in this series are to refactor shared tracing and assertion
> helpers into a common file, unify both pkey selftests on pkey_assert() and
> per-test tracing for consistent diagnostics, and add missing mmap() return
> checks with MAP_FAILED used throughout for readability and consistency.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


