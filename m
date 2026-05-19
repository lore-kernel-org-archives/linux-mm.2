Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE12CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912516B00CB; Mon, 18 May 2026 20:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2E66B00CF; Mon, 18 May 2026 20:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF626B00D0; Mon, 18 May 2026 20:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4326B00CB
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:23:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21C75160146
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:23:42 +0000 (UTC)
X-FDA: 84782271084.17.719EA99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 531EE1A0007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:23:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q27Mrny+;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779150220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DECxBiHBkvW6bmY9xCgiTM0eERRrtYoeOc+ZyOjjEzU=;
	b=0r/er368msWuhUCsY57AJ8OB+6Kljhit9eGAmu9+QFwrLeuBjyXz8awx0njSVY7k4mAQJ3
	J/p+Tuxf1bRgollTDbLt07ganmmNW+XSdBhpUkf43r8aZ7ItSqU9jaYNWTXLRpyZJogoAt
	ICEvnNsvTJvZYgpXOWtMQHxGJN2NLEw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779150220; a=rsa-sha256;
	cv=none;
	b=c4IjWAO9Zi8Spg+cdVlCWAePh7KqEJaT1WNQe+ZU5NTfjvj1SRDqTFNYvxnxidGcby8cM5
	20PqOYHsNOylLCVA5PGPIrBeHRZT4ZNIhwPBKrlH0PLYfZp+5yFWHtbWJbFtPlxHbBHcO1
	7ZATLxmXp8427UX5vNJrmksltZiwSGg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=q27Mrny+;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82D92601FC;
	Tue, 19 May 2026 00:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA87DC2BCB7;
	Tue, 19 May 2026 00:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779150219;
	bh=RgzW+qljccNKmV7qpHxfEIQFmU6SY3k9RDeiu7sQVPU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q27Mrny+wCnK7oCJ/KaKD3zpf5NGXrrBLTvkekixKFu16gTIwdN8ehCfIt9QrIN4e
	 Wlp1uT5ZhKUTSbtnQlHHhMPMyMjmTcDue+8pIWNF7gyamWIxFh3ec3dY2NQkIZMVu+
	 HAuN0zvRAw4RbEtYav6taoF32YitsSY7hjq/JmTE=
Date: Mon, 18 May 2026 17:23:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: liuqiangneo@163.com
Cc: apopple@nvidia.com, jgg@ziepe.ca, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Qiang Liu
 <liuqiang@kylinos.cn>
Subject: Re: [PATCH v2] lib/test_hmm: fix error path in
 dmirror_devmem_fault()
Message-Id: <20260518172338.bb401248b25d5a57125ee516@linux-foundation.org>
In-Reply-To: <20260515070312.130435-1-liuqiangneo@163.com>
References: <20260515070312.130435-1-liuqiangneo@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 531EE1A0007
X-Stat-Signature: awmsndzrkfhutp9n4mh96bmhaacjmqxo
X-Rspam-User: 
X-HE-Tag: 1779150220-852845
X-HE-Meta: U2FsdGVkX1+l4LPTjT4EKIUv7cL6VxsGF+m9fJR0xlsO2NjifyAeYN24rLTLu7m3CZWZ0dS3FNIcVRGfaVYxLnc1qOnnDGvV36i+CUwTZQ/jEW+6p1oKCL4YEFo6R2I6Mbuw7MyztLElRjIOo6fa8lwq4VWVPNJBfXo+Qkjxy92/7owrTCS2cnF+4LsmG6gDmCCnv+lJJtCgWnJhqw0oOkGCh8RHNkR44yl7QkwVK/Z0EJz1IggYdthCjRNAqPO5esvWD+wxLRkhQz0XZwyqV0MD5TCFOwRHs5FQBM90CmP7JlpP0knyXt1pWlFxSnKOwKgyGdi8oL3JHmJ4Idd458VFjPSlmjynmDI8Z8zN5q+rz4Pia+wvAh0cWgVzXBs07enp3pEGuq38CQwQ0Nmb9nXa+mvWWRnQW7Y/95eeRsUiLiNOj/BcunmL8T1mo4kbbEdXAePYrj1xcK3hjs9s07DVV2aSwgXHvQs6oIsgz57D2hF1XPJE1WszfU3DzJT6BC4O1d+kOI9xGvqXeEVyuRIA1kCJViMB2mDjdIp3LEuO73EhGNm1lh2V8bGtuB/iPlz7OzF5USbNYOahUoiG3VzJjhMAo63e3OP6/W454wR2tmtVrCd/q+NQxPPTUGdwImK99IgWUeX56RvW7yfDFjnNdiYUpauhkjJnFFcbUEm89ZqRgjCjFZsMouX6NnFMyX0PqXH4WpZNoglAgcT2NRzJ3IsZ+yB6Qz0pf7XXYm3gFWKXk7q91cCJkMQC3k+7Cgt1tDqebBwVSm+Q6uyOItibhmzjI8G9ItCBKR8l1ikboadSuPE7yiuz4GkcZ4L6X3WH9HZlIzD/ixi3SPZskGJwmVNDmn4/4olachG/pgcEx49U2BOBtJxsmSGwJcs8ffCxzD/uCThDQgwRQZnOHg7vgI5IbXp6z7EIeXqtqXr/A6KC/xs99eStOZSWPRNR2PTv+u71OWLvSTXU0ir
 tZsLyLhL
 PKvyiSAFd8FK6ikI4NYTMDjQ2/490Dm6k5e2LdagXNV9FfZWrBQDg4CUO8OvtgvvZ9PIFSTnG04H+zMvFV8cMxiJ3iIUYGxdIaS+Q5iomQeCnzo7nK49/kme4y3H+6ApQwy4idvSJTav2OBKc1x2CUnGjV/spw4QSJsmgu2drNWS4wb0cPByDxXKbOCKrOdWMFwtUnJLf86p6s3EzyAU+RgZ14/FEBXAR2kbUkPHFd7gYhrUkGUxqRxrXWs92EQ2RPEBkGtAPOMRsDPSLnVsXhk8wr7OhogH796YlZnoTu6CfvGzpF20uT1uhgvb+GFE+kOtTZAqxpsz/0n8WfBNk+HKLLmCBkGxR9LUj6L+KcZP5+MUt948/LECf+1EHqQj9LBUq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 15:03:11 +0800 liuqiangneo@163.com wrote:

> From: Qiang Liu <liuqiang@kylinos.cn>
> 
> Handle migrate_vma_setup() failure via goto err for unified cleanup.
> 

Thanks, I'll add this.

Note that AI review might have found some pre-existing issues in the
surrounding code:
	https://sashiko.dev/#/patchset/20260515070312.130435-1-liuqiangneo@163.com


