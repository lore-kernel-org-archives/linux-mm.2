Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DCDCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A886B00DB; Wed, 20 Aug 2025 01:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2A16B00DC; Wed, 20 Aug 2025 01:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807E68E0011; Wed, 20 Aug 2025 01:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6126B00DB
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:23:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18EC4137E61
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:23:15 +0000 (UTC)
X-FDA: 83795992350.26.34A6C1A
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf07.hostedemail.com (Postfix) with ESMTP id F2E4640003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:23:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=Io7mAX+1;
	spf=pass (imf07.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755667393; a=rsa-sha256;
	cv=none;
	b=tJzSjZF7B8opB97DHSyXH/7omBw0+ls566a2HUAc2DJ6wlZtAB+N3WDBG4/qEcQky4nXEp
	R3zipPyqAg9OPZfYUNXmp4rM28pZYP25mz1GmMwDWkdgcOaWJW3eOVvciavtC2BHRD7KBg
	c5mGTMv9KJrzy/csECtEQ+Qul6Hm0c8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=Io7mAX+1;
	spf=pass (imf07.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755667393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+SOVI9UtvZRb0bUVQn1FdWo9HOAHuaqFSeTJHOfcfI=;
	b=l8JILK5FArVDkVXEPvPzY1iirjvVI+tLsX+fWmRyHNpGXnyvz14h74dFaehXtESz0OB0ED
	sresx8PMHu23Yy0X3yfFlt0RVwgLJypdvLJgnMMaZEkY90ynwpvaeA2Qoo2y/qUyGHoK4f
	YrlsPi5I4j3aCI4wc+yiFKkcuV7Xoas=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=z+SOVI9UtvZRb0bUVQn1FdWo9HOAHuaqFSeTJHOfcfI=; b=Io7mAX+1reTKtZ+two6iAc7Lgi
	xzlJzGFOPtLMQH3YDf0brG9TzwGncuymfFgIIfQ+SXFrdmk8/uN5gbuojTWMVl8SwZjq3GPldQjnr
	gDG/GSs3YPLhLVUDGo1nVPscPoDadjmnuJE0g+iRUrG5j+Kys5qrFoDFKS+jyPfiZ2ANoXlBsmEJI
	Rjq8b8XSLv7fmlWWV0fXxqlaOZhxQq0IGGy2Dn1Wk4K9H7RFpuDcCY/5ZMcazGJ21/yODhRWbdM6e
	KSicES0zw3khxF2cKXICxfbD2D2faGxWFVyT9X8EsEn7uSwBlakeQPOyI7kHm1IsqbZok7CLf0Phf
	6nS6cfqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uob2D-00FiBO-2w;
	Wed, 20 Aug 2025 13:22:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 20 Aug 2025 13:22:50 +0800
Date: Wed, 20 Aug 2025 13:22:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chris Li <chrisl@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>, SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
Message-ID: <aKVbqi6wd3Spz-TM@gondor.apana.org.au>
References: <20250819193404.46680-1-sj@kernel.org>
 <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
 <aKUi7hvcaK0h0oMg@gondor.apana.org.au>
 <CAGsJ_4z6YvQULrEmNjFjLNrJ4RK6w0+d9uF2-7v06gOYirrYRw@mail.gmail.com>
 <CAF8kJuNJ8s2D9NBdXDQ4vpBP0a-5k7r_=DdFuJJ95nMKmm6LBg@mail.gmail.com>
 <aKVYyGWiWRYgxfE-@gondor.apana.org.au>
 <CAF8kJuPPsLzWu8+xm2A_UPHMBhb7OTjJNErM1Kp3hPmvHXNDUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8kJuPPsLzWu8+xm2A_UPHMBhb7OTjJNErM1Kp3hPmvHXNDUQ@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F2E4640003
X-Stat-Signature: 1umo4gt5dp44akh9rmj4f1r9wb6panny
X-Rspam-User: 
X-HE-Tag: 1755667392-582076
X-HE-Meta: U2FsdGVkX18wXAJ4DVpaNrQS5VoU5ynAQu3mHCZ4TDSXI10pWDRR62I43xOFbcb/IPU2tWKwqbJ7ma+1iusnk72qi7zsHNOz1bCipkwjR5BeO0u7Lm/s4lLlEnuLvnJNtU8jFbYMIvifJInUQfvu04EFJxk06JsCAbhvU6LONQ75JBXqFH5P+LjYcPCUMsWE11WViOhg0gd5G0YD40JJ17vFz3cRNILeQXxaREqjfwItUZXeRACDV+ER8Cq90jZq0XUuWhxmbv/SnjSfrAt7R123jUS5h8Zs7Rzs/GnOYszU4MUHXN6b3XwO78X/pYLoWP0XsBNqivO8MAt4Sd8kD0MWHkTvpp2KxP2gkBP37ll4I/PcH9fdKRzYUuZjSKWvudgUqm8+AWEuYS/5jTBt7LPwHfFLgg9oYsusoGGynjkLGwR1vtE/+8FEQMWVYDkBj3g08Fr6o1q1U8jqxd7U6j/0RzxTsc/8d0JPjTqaIO7OhMdImh07b4KkjbL7AJjBzS0I+HFo5oRcdjeZj05+uMoRh346pXPaHQjCCEoMBj2Q/gnA/egTf9QA+AgJyyyhTI/0BEr1UhCDQp89jfC+XOOhQhz6tDeXuQKeaTQWkHwwFIdeLi+tS9TVipAL7PGR4F8LMlxlezPEvbrzZyptZYUp2jEy6FqkzgGiJxKxcUjTTzQP8lJe4gXRAxpG88EN+Yk+Cw8dVQdMtjVpt6M4Zu+JN4Fe3+SyM98L4+UQLWW09buXja6qFO9/Zw2hOils5zylPVgAV9RydKwdIfWsxj2a+3PoLGuPFv1dz6yidrUQQjPsJnPAgdYetdO98PAcidjL1HsQkIGAp5qdQEm4diVl9hE10AluKm4qE2//1sk/ilIrnuN4KrSguRFtO4VBjOZRetKAj7Cp7dVa2rw2oOftB989uP/5QXUJ6N0PCLbw/P3Gt1AKvHC+PTyUYFG16LwJlUKXoPBMs4FUu4C
 iIVBmBUa
 um7fCvOzGr3D1z4EH0fwdOi0fGOThCbxARnSA9VxVZDUciOEw9PmjduqDmKcJvXi0ZdLcfeVRs6JQ0F/xhVmXAr+alGB/DtZeoWofe+cGrPcMMUacsJSzBr9qx//xFflAe7YxlIeSJoOUcQkPpmYK9z4FxSwXwMo15MwjYq5YY+2oDE2VhFZ+S5Umij5H+S1uLkK7Xn7TjreJsIErr+i8ac6opFs1oDzj22whZ9ky3XmNJK2WuHQ6AAKR/mBZ+cVF5yTHhBL9JyiDwFJ+DDpcg8zgMRRXAjZjlZuDgWV1q/rp9e9ZQIohHKpKAvGaFftUZ7GD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 10:20:45PM -0700, Chris Li wrote:
>
> In that case it is fair game for the caller to check for the error
> other than -ENOSPC. If the return value is -EINPROGRESS during
> synchronous crypto compression, it is a bug. We are not encouraged to
> use WARN_ON, then having an error count to check that something truly
> unlikely but possible to happen is better than folding it into
> incompressible and pretend the error never happened. At least we can
> know such an error case happened.

Sure warning on -EINPROGRESS is fine.  But every other non-zero
return value should be treated as incompressible.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

