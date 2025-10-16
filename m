Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE5ECCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 21:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4C68E0021; Thu, 16 Oct 2025 17:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4656F8E0002; Thu, 16 Oct 2025 17:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37BCD8E0021; Thu, 16 Oct 2025 17:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 294408E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:07:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B75E3160426
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:07:38 +0000 (UTC)
X-FDA: 84005213796.08.2C4DAB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C6A43A000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:07:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K7VK4UUz;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760648856; a=rsa-sha256;
	cv=none;
	b=jOh3Beqov0bijkGB3IA7sBGY+r89tC8r+xHSJnly3M7JIt/CIkT59LKW+v6uyVkkwYZ+h4
	ep2/bGbhYlICZu2RnxsLahoxHjswN+0pF9Ez4Y3Dszf5VuBucs6+yIjLUm+iErpbkw5KOl
	xW0wWFyFXB2Sinarw8VC3mPM8glbYts=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K7VK4UUz;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760648856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJ2+D93qponrkvjXZXNgTmgCmQdEyU5MGdg8xveMlME=;
	b=dvyKkgKF+GBD5C5OxO/ce1uMX84fWYAD0Z2f73s3uS5CDfYq+C0mkzANGyZqMq/as0I87B
	ncgm4RVElXDg6Zyw4+FsPkjokP92p8YWyY7MrfIGfEMPhSwt2oy8KSEoLu47wN01g5d6c1
	5JNAHK/SrP7BzcGhLqA5le+CawlJUp4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A525601A3;
	Thu, 16 Oct 2025 21:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBC6C4CEF1;
	Thu, 16 Oct 2025 21:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760648855;
	bh=qDT0KpgNjvnYSFEGuNHvVnzxlTGK5dEK3a6ypkudwFw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=K7VK4UUzlBeno/ZXpjhVi7RxZgfZl5QaIUeY1jFwAMEbdr8lDVRJHtatM2AjUiMJ1
	 p97wvvgOwVmto4SINkte2R0PzAaomFcle8VBJ5P8L0URKA2ABvRxOTwWpGLuxY3vHX
	 w4jzmEDGoKR9DY5OGfii55hgCg07wkP1RssNBoLc=
Date: Thu, 16 Oct 2025 14:07:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>,
 craftfever <craftfever@airmail.cc>, Chengming Zhou
 <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
Message-Id: <20251016140735.d7d4c282f0fbf22954a4b4ee@linux-foundation.org>
In-Reply-To: <20251016012236.4189-1-pedrodemargomes@gmail.com>
References: <20251016012236.4189-1-pedrodemargomes@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fo1bcarp8ujxgaphwm9oarrxym8r51bf
X-Rspamd-Queue-Id: C6A43A000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1760648856-578326
X-HE-Meta: U2FsdGVkX18ZLX4J6PMYv7gB6+ZpPpZBhz9IfAYrU8xZWgCwZStp5AeeMkgbUZxYV5X6QbEqHTTWeaf8pWKyIB1KPTUfy4RUxEOohetVg+0sIdoWvRUG2EnovmbD+Of6537e4JB0crdWvEFWGBLdi7NjX+UBDSAYtJLh1NLum7oQ87M1UYoPyKtKIrUqLgUOwf59eTM6S4p79gDkhkI2Mt8anFn7CR+xddrc0SdOn894v96ojq3bfmEI3ZQIrt9r/pUTU/+gNmpJE6v2k5DVuU5zsG+/ofO+EJxuOD2enLL3ylKQ7KN81RBT+1djj6bE1sSe/5/pCPFK/KnXpZKJVlxOG9vVD52i6Q3d+Rs9h8gPMQ8Tz5MnzzuCYn5W66zCsFEhU0oIR+w3zjpEsQBoxUSGXsYI6shsSlIJJ0uQ2gJXqYznrJ3o3OpPuOfoi+JTVrYGqJfpw2Zd+pUSZor5UauLX+VW9o/ydeFz+iWN+OY5k05xbxuuRgTQji1L21kQGqiDxMpT69vZ67GA888GmUsQ86sZn61qXDqXWhChiYk6lMN43+yjGl8xWIuP20t4nRWkg7E5zPsiqUBtHPzFCY5CwQwNBsdWPzOz0+jRVQDzx5pVlixREISNTELsEDSQoYzMampgPrlelIh4YErf7gawd+uk6vQy4ttu76b71rFXCeJ7frOuFfbUM8B62OpYvuZcJlmE97dgU+XNVX2njgf3Bq8u/qbXsNTbJlWvakJELSAk0U9XGqydcdUDbmYQtMDIURIdlQG92GNFe+urTZ/v9St/0LX/A+Bed0CIhxz8ppA6otrh+AoJzwQtZOJIp71zYpgBSod4Tsu8JWHzT7ufU3dLEnGuQrZlfHDL1uyEQIT1vM2HZgGwzUnKz1Oxcr5Mj/IdCGApsnysSyDUWwwYHvYMjkqdS2sH9xhMffS8MbMA/xG1MP2oERxXIpwwQtxjOYbLdZ+/PXGZ7M9
 adZbOxtE
 0lyjdQAry0YPWXqB3ib3pL8tdZ0tPgjGQ/4pLHdp0YSfiIVdUjZRyymnFMIEZbZc3H9sGNlAPdbZ5Vq/ldqlc8GpNKDUmq5Ozzq2dRcKt27AT+u5Rd/w8CFe1dmZpwaesD9/r0SCVHqwifKpLh0EbQ+ztdrm4VgZIvRkxjQYNUKLC0Sc0Ya2SPJORlHYmjNmwrfM/72mcfbK8QDu8Qp/9Bj9jM6aBV+Xme0qya2czKplZmCiO3j3NF6tT0E4A462y9Z6hrRwJJJBtMWCofmY2A0qyxJCMaT+nueEgqZgRq2nXh/iDGmReXY+QSmn9gTNhIxTKAWDzi1vWE1cqn4ud/7V9v2g7Z2tqAdKuBkx11iuroAM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Oct 2025 22:22:36 -0300 Pedro Demarchi Gomes <pedrodemargomes@gmail.com> wrote:

> Currently, scan_get_next_rmap_item() walks every page address in a VMA
> to locate mergeable pages. This becomes highly inefficient when scanning
> large virtual memory areas that contain mostly unmapped regions.
> 
> This patch replaces the per-address lookup with a range walk using
> walk_page_range(). The range walker allows KSM to skip over entire
> unmapped holes in a VMA, avoiding unnecessary lookups.
> This problem was previously discussed in [1].
> 
> ...
>
> Reported-by: craftfever <craftfever@airmail.cc>
> Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>

Is Fixes: b1d3e9bbccb4 ("mm/ksm: convert scan_get_next_rmap_item() from
follow_page() to folio_walk") appropriate?  

The problem which is being addressed seems pretty serious.  What do
people think about proposing a -stable backport of this fix?

It would be better if this changelog were to describe the user-visible
effects of the problem.  A copy-n-paste from
https://bugzilla.kernel.org/show_bug.cgi?id=220599 would suffice.

