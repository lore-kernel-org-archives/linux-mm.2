Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9D71D2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 07:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BED96B0005; Sun,  7 Dec 2025 02:21:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048F06B0006; Sun,  7 Dec 2025 02:21:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53876B0008; Sun,  7 Dec 2025 02:21:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D08FE6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 02:21:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33917140741
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:21:17 +0000 (UTC)
X-FDA: 84191828994.30.5A82ED1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id A943E100008
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:21:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sJZofoSr;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765092074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWoN0zrPs1ktRzfHfM53EvlXPHcMovoLY3RGcDQFkfI=;
	b=NfZpyADrjjzuY6ple8C4G5AzWvwRBk0V5tigri9vOid16XaEfZOL4Vih+2rhmS2ktY3C8C
	dO8HUfCNfm974ueFAz/rkzsoTmktC9a1xVQ6DdnJ0K8gh9roG57UN3YSnJ2PpO1ZDMcohD
	AImA+IzXotukQnbYgYp3z0EF7NitUCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765092074; a=rsa-sha256;
	cv=none;
	b=e4Ad1BDxCxE4X4lcJ1W5ure7OsNnqotoFN8pZjlFuSTrjsVPAwXNeMUJzq0mOG1xYUqvsG
	BjpigAT0dQ8Rhi5FeZ08hgw01jgUA4i2AEZvl4hyzRygAMJfLbXgAwSIlMGOs+xG/hxKCE
	v+PyXWT09/1VtpSm5q0MYGzclMmh7IQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sJZofoSr;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tWoN0zrPs1ktRzfHfM53EvlXPHcMovoLY3RGcDQFkfI=; b=sJZofoSribCmp/scm0scD4WLrr
	p6mLCGcSnklc8oQVxqNrgQWabR6t/7yXbDm3Qk1eBvvUnYNaIDS6Q8v/ndRFJImYUJup0piyjDp6q
	8cTT82MocP2FErjlO56hWOO7mpJr8lrCuYOx9rMYm+ZagYejAUIQs2FoCfc1wtyjiW7YNnFsxixHa
	aiUckb7TAvfCTW5I2kCRVsA8vvkT2mvjZptn4bF03tK+7TpmJK01xqgrUcWxq5uI6uKNJfUSfZIe6
	fnaNzzo8vP4JWF8njpXDu7LGVG++Qnqdq3FAckQ8gZiQPSVaY4t60JTyh/JYMbrQ+uyUMlv6Etirq
	Cdm8xsPQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vS94v-00000008990-3uRg;
	Sun, 07 Dec 2025 07:21:10 +0000
Date: Sun, 7 Dec 2025 07:21:09 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: oleg@redhat.com, brauner@kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/2] pid: only take pidmap_lock once on alloc
Message-ID: <aTUq5bRdPNpup8GQ@casper.infradead.org>
References: <20251206131955.780557-1-mjguzik@gmail.com>
 <20251206131955.780557-3-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206131955.780557-3-mjguzik@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A943E100008
X-Stat-Signature: yw3gtbwm3fwo6s5a359bi7ceychx8h3n
X-Rspam-User: 
X-HE-Tag: 1765092073-19437
X-HE-Meta: U2FsdGVkX19Tvk7w5DkCHBPZw8pUp9B9pmNXZNwtMpmTJy6kFD6A8u4Ea8VsVkFQgRRG3Z3e0HFyimzd6QWVVCHB7lqY13m15HjdkwEfCq8syfu0nEuJzobQauy80YTbyX9skLwo0byUJacoR+Q3xR1gudrn7Ct/UNhhHzQasNdapP5liS3bAqTjWyZwBfGbh8MWU7Jsrh1hoHZ0A3HU7pgmawqaIR42KIS7W3kFki4mW/kjNl8mz8+22V1R7l9iJQnHX2zWtx4G7SsvqEl/f7VYsHI3CBoKt3Y3vWRjAoyxdxsJAsK7wtyF0/ykg2GtMqwgUVNnJlPn41gnrCEYQ6MbUg3iJRPQh/ED/pg81W6vsHQIR6KKaNMJmv6c3AgLdyyMRJPDJDVJdXPTAKAS1jQ7gbpe8EWLp6czI5ow+jUwQi/YykjomQXrDb4PB08962YwF72tDsTkSmSjT0PD+H7iJD/pcymzkwhTZXkyapwmLAB08iADva6Su6bqO7YyIH6xfj8fNZaCewlAFayOODy63B5W441l5xfcPd1GrwqhEV3Mgt55rWW6R4054B+TId9JuCAVq4mDgijqrnqCTMeChx8h0001Np8f4qHTlXoRX8P5ezii2ok8DqFsgv0c9jUxN9REV+ELySGZuUWfA7uIYnHDZRvSnk929yRrlj9bDqF+HuoT1UO91VEtKn4pFTxDvJOEFBWuYvYBLNWnztQramOeXmzpC6jNbgYoQwVKNy9lKznmj2+mlSFLaHZmYvob/LoDB8bthE1m0E8tzoNXvbV/iXz3lUVD9YWN0e5GQNn69TNMGCSo6sZYSdZyR5gz3axPTnRPif65vG79QQKIyNOlKafXUUhfw+RwOVHK9fPTdcuY2D1pzrlsid66UKwWEsa+jMa+2cMUn4mjcBy23mlp/WHE5YlU3aOxuhrv+WakmcdNtxN4KP1SDprnt6Oc77NcmrPFUGOvJKZ
 QQPlf+/d
 EfA0mz/g5nwyIndvnvCU/+UyMLFc+oXj7jcCbkIbfhW7w0NeBjgQxRexjeyn38tinp08Y8UIPp8OtNhy4KfTRrZakzGt3Gl9m2O8XDz6+0I85QrW7Xdn3jvTmKj1HNUnyrZCO2tbPMIeqU+JSJ/mv1Wfk48Z9MZEUJGE9zuuCSYOS9FtCw+/WtY5DpGigyjxby2gWHaPWMKRD1mKMvC34D2LLa4qNYPlKDylt0oDiS8X6Jyd56lS15gEhOsj9fDu3Si9iCuMHP/1m8UOdcaJTkwkqMRE9x/Wq2QwWTvoMjY1febw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 06, 2025 at 02:19:55PM +0100, Mateusz Guzik wrote:
> -	if (!pid)
> +	if (unlikely(!pid))

Does this change anything?  I was under the impression that gcc already
treats !p as unlikely.

