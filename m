Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0631E67810
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 19:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A256B0088; Mon, 22 Dec 2025 14:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7BA6B0089; Mon, 22 Dec 2025 14:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAAB6B008A; Mon, 22 Dec 2025 14:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F23F26B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:15:34 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4CEB160347
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:15:34 +0000 (UTC)
X-FDA: 84248060988.18.AA467BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E8A18C0007
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:15:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CaW6hLls;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766430933; a=rsa-sha256;
	cv=none;
	b=Lsl827OcCl18b8cVKTkzNAOd1nqzTXQZ1OwPVI/k9D2B7QVqmfs/vgEaF0ShgkhIf97zJi
	yK2pOGLF5q6lBdXSMFJ9A0J4Nw1O9BVNeP75HEI76qTa7ucNIPqd6liKqcwye0U/cqQe4u
	wOOLn++scd7R0kFoJ7YCtLHN00z+z4w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CaW6hLls;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766430933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8z2vRqNsWUXajhMi60nTt2nAfjbGnbvIaw3si/YqlA=;
	b=x8hANLSylfmkLdFSwgx0DUKxcL0nlu4fKToDgdiSBuaHQtzC0qIWVrmSh3Sf7FrOLcOtx2
	oK2DddYogDl+5LlfKES2zprfadwbqQPwgqvTp6oI3JOM89wPmBNCJmO5pm/YAZt9K7VvCg
	C6lDc+8BgtYVNP5As+NSfFQLU60rk5Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C906A40497;
	Mon, 22 Dec 2025 19:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5966CC4CEF1;
	Mon, 22 Dec 2025 19:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766430931;
	bh=ZRlCmMLr4Nbla5Ea1HsL7EGP9Zb5RozaswG2lrCEFmQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CaW6hLlsgJSiN6lRCXIeAo3h2E/EWeCOVZqZER8LumIarNglhFPCl8ezChq+pHfJ3
	 F5T401ixji8FJV3WCU9lhy0dqpkBxPUU6PD6YojWnjVxqxzKD8tGlukAqQho/cjU8N
	 4yJigNRMkRlzEimnWG8J+nRFQVtbeSHgTWcorERg=
Date: Mon, 22 Dec 2025 11:15:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiu Jianfeng <xiujianfeng@huaweicloud.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mm/hugetlb_cgroup: fix -Wformat-truncation
 warning
Message-Id: <20251222111530.c285692e5872035d6ee68264@linux-foundation.org>
In-Reply-To: <20251222072359.3626182-1-xiujianfeng@huaweicloud.com>
References: <20251222072359.3626182-1-xiujianfeng@huaweicloud.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E8A18C0007
X-Stat-Signature: eqckphzsay69bxuewypu4qx6fng5md89
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766430932-264368
X-HE-Meta: U2FsdGVkX19r2JvQS5R+AxJoX12+dekGaF5vRCM9efgvtljLX71K9qVHCw+tx7aP6MiTuOrt3FPhCRkCw73DeZQq30wItVWYMwijNYEdsc8k2UjEdjSgxoLUKqH0qaEipXehxOr8Hh8fclSzg1q/K5GpAmRQ8u9j6EKLoO4K6NBU2epW0tWt5hy0LCEBpgvOjgQRPP1Bw5J4r6E7+Vyv8ojaHVhVg4vjjUI9Af8K9/u6euFPBXagoI2hcM813x0/lJnnh9aNpHSTXJmOg52U9XkReBdsIn73qzMhpUwOuZPXFPE5X7fWfJ/Q+BIOXTYodVnBosSGgeJy7kUy1x6Tw7SOYHJ0lO6mBfcVBA/Qmqlo3i1c/OoQkMZLP89N8UQGp4FceCFo4FBAwCW+2fBZGvIFgDla+eV56A5b6SYSidwCRkn2WBWqyf6c/cG+512BP7yMf+xNU80uuWIqM+8gCYBJ7AXmws9qpGRQnLuLcOFYA/9AjsKiPQiJWhaiiV5vL2psbp1ihRaJPbq1ofofO6WsCqCjd/1y3mAlMs/Ckt9tdTp+0pS0I1/jg9FEJDHltBZm9eXbvnB/jZfImeqLS3hdnZOzJ2gOKKA/T/m24yKdXtCA30ocYrtnHS8B5Ld6o9q5eyOEno8BjzhqXSyJ3q7yTPt2eETWGTT+dyoY1d0m+Mv/JMnkDYeIlTCtBI+hELbf7BAjlw9cBN6oyvEwz0lv+oeTrbF6e1whox3opssukNevrxIkzjBE9aVC1z2yGNmiHqfh4MSFHwxuDZ735+Z8GmDtn0IWuwNcnYSHFnaapujhfcNFM0soNKklD3Cy1/KmJDUNkbBlfXqIdd0gbLvB9K1YrRqPe86VE/W5+yTcN274pNMCrmF3+GZrklncdNWO/xNHfOaRClVHP9pTG0oD7ZTBw9/xuE5+e50ICqMSm39fZiuEAkfK+VDVyXl5SG02DhbNCHk8gHkJbld
 8BTV7NJ9
 o/9K7f3Ud9caFRg+nXI63sEm0TmxghA8wOJft55dbll+CNpd0N4HfVoni+FSVn8IFzWMW1qMeHF7IuaZCgFORxp7JIXyQHJsTIxZbf0cFZ6N/9PGQmagCLmO5CGLCBhkN3G0Ue5/Zq+3spHidLm9T912ijnwSTDzubt91HOeNdL3iYIJ8jEtBdjmSJbGVtaQHEle+4e0fqamAFxKvx63A4qrJuSIA+cG8Mg5ryfr0dNZ1EUdDVRFa04ir0jdtmYOXnM4Xdq+4T/RoC4Tuon9zG7D7YIyljKACtf0oxBgSAEWuFg36o9A+WaID+s4vSsLMIXtxTVfARQXD5Ow2/YNuFWazIDxDhlnNJ187BVZ3YDHrtUwW3mzFlqVXZZb9r/lhUbdzZqY5ipHGaZHSZvDwF35Wh9K9sYzilqUos3N03tXqWvYpSr4BCU18500xdjZsEIXT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 07:23:59 +0000 Xiu Jianfeng <xiujianfeng@huaweicloud.com> wrote:

> A false-positive compile warnings with -Wformat-trucation was introduced
> by commit 47179fe03588 ("mm/hugetlb_cgroup: prepare cftypes based
> on template") on arch s390. Suppress it by replacing snprintf() with
> scnprintf().

Thanks.

Let's quote that error message in the changelog and include the Fixes:.



From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/hugetlb_cgroup: fix -Wformat-truncation warning
Date: Mon, 22 Dec 2025 07:23:59 +0000

A false-positive compile warnings with -Wformat-trucation was introduced
by commit 47179fe03588 ("mm/hugetlb_cgroup: prepare cftypes based on
template") on arch s390.  Suppress it by replacing snprintf() with
scnprintf().

mm/hugetlb_cgroup.c: In function 'hugetlb_cgroup_file_init':
mm/hugetlb_cgroup.c:829:44: warning: '%s' directive output may be truncated writing up to 1623 bytes into a region of size between 32 and 63 [-Wformat-truncation=]
  829 |   snprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
      |                                            ^~

Link: https://lkml.kernel.org/r/20251222072359.3626182-1-xiujianfeng@huaweicloud.com
Fixes: 47179fe03588 ("mm/hugetlb_cgroup: prepare cftypes based on template")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512212332.9lFRbgdS-lkp@intel.com/
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-fix-wformat-truncation-warning
+++ a/mm/hugetlb_cgroup.c
@@ -822,7 +822,7 @@ hugetlb_cgroup_cfttypes_init(struct hsta
 	for (i = 0; i < tmpl_size; cft++, tmpl++, i++) {
 		*cft = *tmpl;
 		/* rebuild the name */
-		snprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
+		scnprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
 		/* rebuild the private */
 		cft->private = MEMFILE_PRIVATE(idx, tmpl->private);
 		/* rebuild the file_offset */
_


