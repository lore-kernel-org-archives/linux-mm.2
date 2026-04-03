Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B51FE88D6E
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 22:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2866B0088; Fri,  3 Apr 2026 18:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7534E6B0089; Fri,  3 Apr 2026 18:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669CC6B008A; Fri,  3 Apr 2026 18:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED2E6B0088
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:08:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EFCD81402F8
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 22:08:05 +0000 (UTC)
X-FDA: 84618633330.14.98FB8F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 28F7A100009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 22:08:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="yA7Q/JlB";
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775254084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=od9HI+dVkCIZVklewIzPB7g4J0bxJAXdiFresT6SoSw=;
	b=S++suTSF+iyVqV4T/xCEmUgtfXzaiCTEhBbTz2gitSCISLm8JmjeMDE2YA6UM9UPoueQM2
	6nZqaPEmxs3j/w98DIJCy42RlgjrBm+ffMOWk6+rmE8/pRv6Gvy+j5sv5kEx4NRm5qExQ+
	Bj2spESFlHV3Mo8cWq/YHEyQ4D7lLSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775254084; a=rsa-sha256;
	cv=none;
	b=SD8EyumpsuhMGyWMEU0xlbGCflWF57gxV8tuyms+Zkh6M+lUdNQlOZOUG3HowofrZ2M5L3
	zizYRtbTd6eqFNe3VqnJKAoIEFqWkfZGgAPjDdtzV0S78yTMg3q015PBeDstNTcXSIiFsU
	Jya0H8pz/nWwyBnrHoflomT+7u2g7oc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="yA7Q/JlB";
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0268A429E2;
	Fri,  3 Apr 2026 22:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983A2C4CEF7;
	Fri,  3 Apr 2026 22:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775254082;
	bh=Ypektj6k8lvVsXFRGG7d0HYTn/4Igeca1OJ5d724Q2M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yA7Q/JlBXj95SHYJSmvCID2o/jxMn6HJRv9G8mMJAMKEt2nWvvUlS9A1VT+5224d6
	 WiMzxyvQwjnCzVDPcL32QSKthHvBIpyjYLntftdO6WoeNsZiVoHtbCQ8uQ087WyfBc
	 baJkCjWIHqN/Qe2gWoLtWMHZDVgd+uBmSQ3O1tgg=
Date: Fri, 3 Apr 2026 15:08:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport
 <rppt@kernel.org>, Shuah Khan <shuah@kernel.org>, Usama Arif
 <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/6] selftests/liveupdate: add memfd tests
Message-Id: <20260403150801.f42e27896fd2da5db6ca3425@linux-foundation.org>
In-Reply-To: <20260403194014.3704180-1-pratyush@kernel.org>
References: <20260403194014.3704180-1-pratyush@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 28F7A100009
X-Stat-Signature: r4puoon1csiyz6gg8exgzwcsgit89xwu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775254083-867691
X-HE-Meta: U2FsdGVkX19K6JYSBG8zaa5jwSG0KnbP57oVC1nXuJavifTKw2hV38vKG9saHynEFmiqQfgegN+qKHP4fKf+oKdnCp+lH+Neub360+eOdJphuYwqIanM5CB5gUB/dXdQpqwqibteQxhJrYYjRjND1PwFEiR+EfDLUqAGcDhe3wqTpupJpbvRE51U+yFl8qe18xVwvtCP3lfpeewt9LxRVhOS+qnqWZ+zCvL9LfP+ajryULLZ2X7JNOEqzDTY3z9izf2ync8rwB7yg7g8ovmgNfSxjVZMG5ruiRgYeAV/50J3bmjwlNLJqHMP8VKia9GxRH+RY6PBp0L3Yr3KwdN6oFzIolhi4Q4OA+fFEP7qZ6I8BGVwOjiJ17VA42ReswJb//U5vvux7XNjnMSGaHQmEEVdwiIpUXxCHBS4Quu1SSxbRSH+yzFVJdZTC62wSUSBubDDhayy+U7vhMKmZ1qPzyyov+gBgc4CSSQGWKru750zGqEh1zaDiDe3XLRqm2imkdkRVdInxliTL2lnklgXcQURttGr/a2ni4bzy0XrBO9mBOXJ3x5wxEk6vUcb98g65urMUxvehyrXazTmAZQTrrWCo1GAZhEqEP8cImPp6D6p0bRuAEMv8pSjBVeH18Bni0JqnnSYrjOqGDRP7pyMhTJIF7HTqILiUOLtFbbX1twpgQt1XYbAodd8d8jjGSn/hofhlqWZM/3Yccn416GlnxD4NQhsoCeELr+Rl0pDvJW0yuS+gUFuh5iS8UVIzV2QGql+6aemQ/L+SYzglHK58IL7xmQeu+vsf70Zvp3C3TNqFCWRb7TY6Co6/Vtp2yHh4mrIoWzEm0dTPAaAeuZpDMiOWl8Jb0HX8Giwi40zncjoF/sVvgLwu6xKXkkAJc/B+JG9bmMHOzRmg9fL3Xm6UlQpDV3ocO0YmonymEgBNp/rMZn/jQp67CLLrE1QbxlVoqLBbCDZBMIAZOCZEMY
 iosct6VX
 xBwBj/ABR5pYF+jolF8jcePwChRMbnlkTdDJSgUGPQ5dED7KuhoN50DwM67JjBwYcz+5Hh5+JD4sIV8MlqJqoLbSVSckhRlQS0Xq2VOCFMloZl+niev1R5gjz+HX1/ZDig+DP/LH5Yzl7pp3uQTkFQVzjP0nu3th3TLvHYSJZdq5s+lNbHtRnPluY5+LNNQUD3y7dtdCGSSuh/HyOGTwhAVVOS2bGCc0gBGiY4BDVK6zGG5ZzmmQL1jn9vvxBYQzMIQS3JgJ4aLLmP0XAxaAJfgO7gb81K+fM+9PJTjjSNZtk3YPp+qtLmyCDjFKcAo1c6Ply9qdxlwVYe6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Apr 2026 19:40:06 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:

> This series adds some tests for memfd preservation across a live update.
> Currently memfd is only tested indirectly via luo_kexec_simple or
> luo_multi_session. Add a dedicated test suite for it.
> 
> Patches 1 and 2 are preparatory, adding base framework and helpers, and
> the other patches each add a test. Some of the code is taken from the
> libluo patches [0] I sent a while ago.

Look like a nice series and it comes well-reviewed.  Maybe my "we're
all full" policy-making should have a selftests escape clause...

I see that the malignant gaze of Sauron's eye fell upon your work:
	https://sashiko.dev/#/patchset/20260403194014.3704180-1-pratyush@kernel.org

