Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC6ACD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2866B0005; Wed, 27 May 2026 16:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05ADC6B0088; Wed, 27 May 2026 16:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB30C6B008A; Wed, 27 May 2026 16:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D69816B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:36:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 435EB140414
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:36:55 +0000 (UTC)
X-FDA: 84814358790.28.8EE6DAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8C10E40008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:36:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uO0kMIEC;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zoqeZwG3y/DBbZTflYJmnprqIV3duVrLDa/AW8PkbO8=;
	b=yOaS//cHtVOR6zFjd8K0VmDUuaMTkmy8GRl2HAwZo9m3kCOZJW68yEkste4jo0BoyqW6p8
	/UsvBiJhjnIpWSOi3GPj+N15CDcsHyAcBf6Wc9zL9jbNgvrkm8g1T+9DLX6/AP5MqpvVip
	JKj68McRWxeZpLhImfcOEv2867YXVig=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uO0kMIEC;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914213; a=rsa-sha256;
	cv=none;
	b=m+NqsN1iWTqrW+Clg6b5MX5vYYWvLq8TKRcgYfbkHB/fbRvCxZVw52bIhRLhpIW4OD8gIl
	QAFw256AJtVfhCNBOlTq8FZc4RGnFCA4qgLLAn7kGNH2ars0y1GA4e4F19Xex95NnTJZGR
	ILhlEEemA8zMc77iE7us7xRx+eWkGjo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA34F605CA;
	Wed, 27 May 2026 20:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41091F000E9;
	Wed, 27 May 2026 20:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779914212;
	bh=zoqeZwG3y/DBbZTflYJmnprqIV3duVrLDa/AW8PkbO8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uO0kMIECI+ZA9S927s3ybqIf4C88FRCgd72kPKcPaZoajjn9zvOEn3ySaNm+LtO6q
	 fvAQQYcklDxHuiAL+BcXbr8jVHUg3oZz8TJJL4p9sRE0SVVRjoWB+jXBaPSILloafl
	 WpntFOChULwcpyxhpmx18DOfzp5atrrnU3pruI3E=
Date: Wed, 27 May 2026 13:36:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com,
 taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
 baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v7 0/4] mm: swap: introduce swap tier infrastructure
Message-Id: <20260527133651.2ce806fa542a82eca5ff66d6@linux-foundation.org>
In-Reply-To: <20260527062247.3440692-1-youngjun.park@lge.com>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C10E40008
X-Stat-Signature: zia6n4ruf3ktw95fhf7zpf4bgk9i3bfc
X-HE-Tag: 1779914213-659464
X-HE-Meta: U2FsdGVkX19TIg8U1mrvzVwKQF/am1la4T7k/GFy8wTvxE3MOSfUHw+yD4Wf3br3momhRJA+xMu0V6dmTmuykGWMkU9Rf3rChSj3yUNFUWVOC1lVsWMfsGAz9kpHBHmUA38TPfmeW7gr74c0GiTxpZ4MpurUZrcWGu5dPKiDNF9BTbb1FouXyv9aCzQP2BWq7MeEk5H3AQEaIYOrTBCcCIRGJrPbsiKrFn0nzBCC2ennOKh8rrlLfPKIUveKHspSgvI8I87esospjXHIV4eqysRUrXuwVE0DeEXNlPZIMFQ7Scy9lAXlVu4jeRyEH6yeq9ILMCv5ztS87Aiul8VlNV17IU90BtAgC9m+KLVtvj443bUS9iRYvrYLTTTjL5LAu043fb0OJJlGbw3Plu90JktxUrOJz9VEEQdrFxrHpoawYSgj2cNlnz0iGBPUQKZUIUdlGUD36oYPTKkDY/3c1szAAqy8iV0cb/FyjCyaQ5SWVrHnzn4YSnwWAo28gcn0wdXfe3Iq+ov1JuOWlCk0hEK7Rn/hI4o1B9BQbg/Ss6M6yRzcYa7eEg8WT2PBKHrtr0J2dA3WsTd84l+jsU4uvPVmAzpo+5718rOGQ67I3JdBrezRp17kiE0tntXITfvjXju+899YttIEBNYRk7DixJd9CiuHKKj/T5SBJE8Ll23GB+ZDfzAK9pI+x9XTxMZaKF2Xh+aYlCSFxk6wr7+7N5dsmd7VAVQ7Ry/gW/QrJVABfrB6inKgqdJ1+LidEbWv8dDQHQ3RyM3kNQ1Vo+52BAKSoJL7p6g5cQyvUjfrhMjQj166TQcMJ5vY+VQMwyWaY84tCQM2TjqxLqRBe/HXKW3F9CZAR/ZqY0eJUYLZL1vmDD1cHX4PclnGBYXCbv1XfYzdICoyAn0J7e7tHQxKBu60CsaKmeS7sIGAaQmfZGXAZgNZwhT53gjeMhNJFqv9GNCWdsRtoL5uvjNwjNi
 MLh3hVw4
 X1DPkHTom/CtluL/j2GLX+kixUWeg3tGSHkCfnsLP/Xt29+ysfBH1j8Ui9IAaYLlQ1lVDhhnvtso92wSMgdXjZY84b0yIuZymrXtdOR16j+hOl8JMWfNDZYlS1RvDRkwqWexehtpgE32PlwI6+tQmXyIkohDwB7Z64UhrQl+kv8he0XYnVKNOV+hppTJOJmX/mbbEfOgHU+zYqcXOczJOxbhKXpOzs5OOCi9zmEZZ9zNhhCTT63IfRYk1I4FnKSA7kYWYbzay04VJcpp93MsL7ma+WQVO57DVxPamhRwE3DHE8gD3ZLecI7O7DvAYG4d3UbqVHOiMxnJi/mY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 15:22:43 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> This is v7 of the swap tier series addressing review feedback.
> The cover letter has been simplified.

One question from Sashiko.   Minor, but easy to address.
	https://sashiko.dev/#/patchset/20260527062247.3440692-1-youngjun.park@lge.com

I'm reluctant to add a new feature patchset at this time - we have a lot
already and we're at -rc5.   What do others think?

