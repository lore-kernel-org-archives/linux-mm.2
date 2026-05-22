Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72003CD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 00:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7847E6B0093; Thu, 21 May 2026 20:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734816B0096; Thu, 21 May 2026 20:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 672AF6B0098; Thu, 21 May 2026 20:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50A4E6B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:21:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE59AA08FD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:21:00 +0000 (UTC)
X-FDA: 84793150680.29.09A50D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4AC16120009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:20:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CjI8OyAV;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779409259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wKYhqBQiNpl8qqcciw78N7sdimauckDPVkF4bTCFGs=;
	b=5pYOvLd9Yn1+TVPtIGYgWjGXyDgGgyuSi5+xIYAzPateL/EKLAp2QskM9GPf4zQ6Wi8vV0
	NDW8fhL7/aS2JHVaNHBde5Uhrx8astMz2Rjuqx4shpaF07o7Kwxk4f7mQnII7uLUnADktw
	6xhenB26JOm7q0+Tfrgu4+ngI2ef5vU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779409259; a=rsa-sha256;
	cv=none;
	b=Iln5gvXf2Tz6MvEXx64VR3M/2Bip+6TVxonUTPvxfL1g/Ym7Ol2ibqgWGtWeSFBYKZx+RN
	KBjApDjnfX0UZUkZ5epMyAxWkblRDolFw2Om5T3uuX8J6Xz98ycAZJqEm9KMUPWoB/jGCO
	6q0bsOlz0fpyzam3MWq9Xu9lpSrDyBw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CjI8OyAV;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B74DE60136;
	Fri, 22 May 2026 00:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B3A1F00A3D;
	Fri, 22 May 2026 00:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779409258;
	bh=4wKYhqBQiNpl8qqcciw78N7sdimauckDPVkF4bTCFGs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CjI8OyAVzzymNgKcOg/KwCn+a42O0hv6lbWiXw9TZ9HbM2klkuCfTedUBHOF9/36w
	 JE9KhN7RooBT2Pd3nq3CRpijg2ZdoZo5Q7N9WQOdU6dYgMpRmV7UWNk0RiRZ3MjxXF
	 X+AFZgsm7uLBqfKaLmwdEN7U9sWzFJKOi+6gwuKI=
Date: Thu, 21 May 2026 17:20:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
Message-Id: <20260521172057.84537783b60ff9cd0abadf76@linux-foundation.org>
In-Reply-To: <20260520075641.1931080-1-zhen.ni@easystack.cn>
References: <20260520075641.1931080-1-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AC16120009
X-Stat-Signature: youim4i8x5hp6isyb9x86iaxahhguhcu
X-Rspamd-Server: rspam06
X-HE-Tag: 1779409259-971750
X-HE-Meta: U2FsdGVkX19kwoGBiunu2ov/5yobbllmQ3guF35WvlJT+lBpaXIpcm1slVUeUs5ETBe9gPqihKsKcaaAEW84xJcbd2SMwwFhXgKikdAjoI2npA5mSDNFyx0VWd8Is83ZJ+VMpBRrdVl9uuVRja2/C0Ih9OL9ELmDgottjFMzFjAILwJGPyzaEwcBj6wa5v8DKKWthv5NXsrqrQ9lH4NZnTtXkp1sMYzcaBLcfB1mWzUDN4+93LNtrZRpjAgXEw006fFITeysO4ulBD+KovO561sStWqfxKtBYd6tIX5Rv7zBLIyrHDjWPJmZGqruPT5dqX+xHNrALVBBVXTIz4kI2Fru+KKkscQglEaj2z8PPwfUU5yD2BsJWEjqLoutpjUJ+ziJF1tWDLcU77W1HWWdMpdqcvVnGLM9wsAXJAh0S8ggkUWBmLm7OdpAWT6neIfcmsJPPnOvYn9m0D+IyGJ9IwqBFogjXwNAZUaxLV0JD5HfrcZR1QM2U1shSiEUwkgShtvICS2RKy5u4LP/LnMHx1fgkn9ymthDgc4m+XkY08bIxxdI9G0aOz2QnnM0GmgZqOsi4qWDLC1hz8TZow5F05aPDNt2xSftqGxVZyavxtR8nIWT8uQ9DRA8ueryzCvgLGzJuOvpLT3fUW3oHBjHDH+yyZo7ONHVINVcQR8hgDV1V18IassHc/eI+eeuv6mI0XXSbDVlDTHD9ldVhHj7/7n7Q8unFhD9RfK3trT3S/DKfaHARoq2kUeozqQ5ZqmcJTHmptwnCR/4sNzMQM+FekFpQ5zLme/Y0DUSkVKX5rCa0hGPcIO72O83wCbvVjSeq5o2tOKAld51b9A77yXgnKqiTy9f6IDwLn8dYRjoo2bqtMBNh6q2w2fl7OKRo2PPWhB2VkD0pyamKiI8oW7eLqjpSxfAIOoJfuNbkqru/R6C97Hqil+NhfawGwJCECyzWBkW/6E6zKQFJ7+Yb8d
 7oDZo0A7
 rkn7cDt/JTmb2/ZIydEa+SntJ5Q7NlboQjzAA/+bON/+wiF42DzIuvOoBkqyCYf4PA6e13NL2vG6u4dvd3B9k8upbCFzMkXD9cAKDQpVcqvEhaQzK6ynJOTU3JqF9jAW2BDSQjCHYw9oe15OSdZKzX7jGruMIHkSVuADHc6otIAOKZ6CTFrVFP2hohWNoKDy1P0lhsU69KFvoOSdnJLDASqV1V0eHNzKW5RyHm2Vb0bE807w2DLuRw+SIZVK3PoBOicGppdpEDC032XxjDQtCzAinIRIuedU2wrsfoy+6SHhBEh8bTMqYf2aLCpe3+INOXEJgpW4hns4F8hF7+SqdyvmR1mxgNIr/2QvB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 15:56:37 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> This patch series introduces per-file-descriptor filtering capabilities to the
> page_owner feature.

Thanks.  AI review appears to have found a bunch of new things to
complain about.  Can you please check?

	https://sashiko.dev/#/patchset/20260515091942.1535677-1-zhen.ni@easystack.cn

I'm interested in learning how much of this is accurate, and how useful
you're finding that review to be?


