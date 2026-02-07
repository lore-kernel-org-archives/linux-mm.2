Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB48EE0AE0
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 15:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5C96B008A; Sat,  7 Feb 2026 10:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72D96B0093; Sat,  7 Feb 2026 10:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A479C6B0096; Sat,  7 Feb 2026 10:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 936C56B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 10:55:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D87C8BB7D
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 15:55:21 +0000 (UTC)
X-FDA: 84418110042.28.03438FD
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3979110000F
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 15:55:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm3 header.b=X7h1bo3L;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=TnKt90u3;
	spf=pass (imf14.hostedemail.com: domain of greg@kroah.com designates 202.12.124.145 as permitted sender) smtp.mailfrom=greg@kroah.com;
	dmarc=pass (policy=none) header.from=kroah.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770479719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRj6BKNr/q9soARGeWpVLXX4DM+VgJ2PyVbqhDP5l+g=;
	b=nMxxUy1MP7QzPdqHZodrl2plKtKMRN2z5k+fNodagsThLD3jDkKgR6fzF63fDPbDRsqKVf
	M0h+x+1dSuTptwtR5TChYBKeoT8kcqqsf6SbZADlGPehrOQh0F5Uy+t7+gkIJXYTSJKjLW
	mcgRjWWwKci8AL1Y21uBd8633I4kRcA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm3 header.b=X7h1bo3L;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=TnKt90u3;
	spf=pass (imf14.hostedemail.com: domain of greg@kroah.com designates 202.12.124.145 as permitted sender) smtp.mailfrom=greg@kroah.com;
	dmarc=pass (policy=none) header.from=kroah.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770479719; a=rsa-sha256;
	cv=none;
	b=eNAyqZ4Vyvmle3ILC/cQ+TB1ma8VSPHfj9OLfpiVlhOkR0KAKJ5Q9Y1FNwghmv82nKJps/
	w9hUtMMJfxGhqYHnacd0E028KKpBS3lvTE3ft5GkM+uxv0Stew7tjr79SsZPoD+jEfhhd2
	CgEr38Lkoiu9Nyj+Oste0iLOWxnVsXI=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id 008AF1D00066;
	Sat,  7 Feb 2026 10:55:17 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Sat, 07 Feb 2026 10:55:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1770479717; x=1770566117; bh=RRj6BKNr/q
	9soARGeWpVLXX4DM+VgJ2PyVbqhDP5l+g=; b=X7h1bo3LcSWGun/j3/Wlcop+tn
	VE2WGpUOw949VG/sUBb+So84nSLxUIYFuB+AYwWIigeO6Q6JCu1MkP57fTeloJPY
	GDTtDfLK7n3gBcDrvIGzKQJzNaUo6FBCYU0NUsHmwuLdVakTtcH0e6dmIudQ42za
	+w3jbCvKq8zzOqTXQ2YBsaq+y8fxUajUZP7EV+TuvcoDheKyNzL9gLPE4u2V0AF9
	RPsIdb7XVIR3YjekRmGaZkKPx/sQgYs+ij6HCV5wgTOMKTwvywvUk8SO1JDjNI0g
	EvjXIk3fEg1iVlMLFzTMmGp6SWP/pzlIx4cQrBZomlOfXpgPOGPrcdL+Lgww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1770479717; x=1770566117; bh=RRj6BKNr/q9soARGeWpVLXX4DM+VgJ2PyVb
	qhDP5l+g=; b=TnKt90u35ifweiw4Lani8nSB9gpYr36UYkP6Cfwgym1ZFXBZYmW
	PPiqtAhAReCWWEC4fP7JfB3/A3JYm2XS1zGX8sJtcbT2o9RUuR60Xzd5iigbHfqU
	zQvHU1k1m0ErF7qKPjhm5Fhqv2W0YJ4+CMASH2J7ndLbdKoYs7oqrSho1N2ic6jP
	Z5K/Yz5fJd3X7mqoEr2tPGSmW91hzNjN2pXfNAmT0UvX0xTkp6xHXj1X0P/CRFVO
	A2zOARRp1SlXopEtqvAkL9qrg5UdrqUMj83kEwfne+oR4G7OE/cvRw9Aiwf6+uYM
	KoZm4NodOtFozqU2YU3puZP2akWgCLhcJ/g==
X-ME-Sender: <xms:ZWCHaTkVsBzVkjbXom8JRO2RJhFfVa1aC2qSzWbzN__Uo05SAjVeYg>
    <xme:ZWCHaTiLQHYavMM4STlpwRkgSzy_riHvyLz-S6Fh14y5Fnf5ey1V-qHlPQDVTj9JT
    FkpeuRqWiWzK4roHaR8HPZyj9JuPqawOMmtv_bx8ZiseoSuOA>
X-ME-Received: <xmr:ZWCHadh5HbhpT_W2JhFlQrvz6-l1mZllvKwjMsBBZlR_IEfs4qdqm5_mKIpZCSQUd8uea8Ah-6Hc9olhoBRdEJfEibkNV2eDEhL8qQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduledugeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeen
    ucggtffrrghtthgvrhhnpeehgedvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhf
    dtueefhffgheekteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhdpnhgspghrtghpthhtohepuddvpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopehslhgrvhgrseguuhgsvgihkhhordgtohhm
    pdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthho
    pegsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhlrghvrgdrug
    husggvhihkohesihgsmhdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhes
    vhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:ZWCHaVvk6iA4gdRYE64I__QFvx0cFZyVefN7fhskTAyZs0B_ciNvEA>
    <xmx:ZWCHaVtKiEIw1bQi7bRiokGws6YemGOflh5cb8YvCOAFNi3AbE_yNg>
    <xmx:ZWCHaTqyOW09q8JjFEs2JmBqsnS5e7f8vZJPyoozqrfz_mvXto1WrQ>
    <xmx:ZWCHacKGkxCtH6ESXrZJhhDyC0NIFL2myp4Lis4r3wZ4PbrxrugVLw>
    <xmx:ZWCHadwD9im2-xdcMwOzx3l_2ClyqLYPNgF03DVstTE_WXOA9RsH9iAJ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Feb 2026 10:55:16 -0500 (EST)
Date: Sat, 7 Feb 2026 16:55:14 +0100
From: Greg KH <greg@kroah.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
	Slava.Dubeyko@ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/4] ml-lib: Implement simple testing character
 device driver
Message-ID: <2026020719-thrive-domain-f0c2@gregkh>
References: <20260206191136.2609767-1-slava@dubeyko.com>
 <20260206191136.2609767-4-slava@dubeyko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206191136.2609767-4-slava@dubeyko.com>
X-Stat-Signature: 17pxy8ut1m96hqpccb78gdxk3i41xna6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3979110000F
X-HE-Tag: 1770479719-1785
X-HE-Meta: U2FsdGVkX186ETFMNtKbsxi2qi69ShOgBwxBYSC5QBjFw7icWNxEnMOYAF8fqYrROsKfGBEIZGQ7H3lu795uxhdTOOLZHU2nea7Fo8d2FBgC3gbQQu6mSYzxPgwRPmSu3K3KfUqWybu9LPpN5774b6Lxsl6z1AydboWqyloY7fXMCD+cMDh/WkzotGZOSy1eLC7jq3eL96szo4bIlh1COxeEe9v5yg4o0KcT4YSKmcJp3NbPYKJXcoTuP9HOq02N1X3dNEfpz1F8qtLBJVx+90ntNFoI2AgpcnTPdkLivRpYY+1Ds1osgNcqTl1Hn2yq/EleJkOdlWezHNJgZu+KMzdzD9RS+VnNJ7HshbRDqmDlO+GX+lvVq6k46JLE8XlEb48GjbC0Jp7SWsNVWbB/UMovuMsGvrefbkqbV+q0xSq7DS1s/nN/uL7AoElRnG59oRFKfE+mNIhxfc2yF1JP4vQAnfZz2t7OYaxVBvDDOT31tE8VmtQdWFii5Fop3WkG+StLV19geZpT0uI7eXUWzlQd0y9mJy0Ahxf92KzfqhNEO3J6zgea5NeCSlpLFMJHTHxtkSXBEVujcMzAyahZWnrU7+0/PzieX+kIu5uAuDeSLe0rlfdm0yvtayONy72XpzDnJx9ip73zWZ6h1KGTagR/k6ET2RLKcXAynd69vVOoPVLgYgLQawTZ1RBHj/PX5JMz64XzoP7j94liq4ZAp9yJDPputtaZKRznIMkuOGmmHVizBfsQD8ZUdT8OjoQ3PI2nj7nmLHmi5TSrRchZ/NWfQzAX8dGnZvAE2oHcR0ZY1veTvIyl+PEk14+TIcFOJ6hUf10xKz/w3qJsayPQs6ogP0NiN1Cd1x9KPOjS5sKJhBOWV5W/TNBBr2OxkB54pPqOPGzdLw/KgauI+yXE1NDsTTg7orAN/ungPA/eQIXBNSiKLIea6H/PHykSeSVocvHBrVQJ4/qLI+qFh7y
 A/Km39v/
 mdjq+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:11:35AM -0800, Viacheslav Dubeyko wrote:
> Implement simple testing character device driver
> 
> Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>

It's hard to tell if this is just an early april-fools joke or not, but
if it's not:

> +### Character Device Operations
> +- **Open/Close**: Device can be opened and closed multiple times
> +- **Read**: Read data from a kernel buffer
> +- **Write**: Write data to a kernel buffer (1KB capacity)
> +- **Seek**: Support for lseek() operations
> +
> +### IOCTL Commands
> +- `ML_LIB_TEST_DEV_IOCRESET`: Clear the device buffer
> +- `ML_LIB_TEST_DEV_IOCGETSIZE`: Get current data size
> +- `ML_LIB_TEST_DEV_IOCSETSIZE`: Set data size
> +
> +### Sysfs Attributes
> +Located at `/sys/class/ml_lib_test/mllibdev`:
> +- `buffer_size`: Maximum buffer capacity (read-only)
> +- `data_size`: Current amount of data in buffer (read-only)
> +- `access_count`: Number of times device has been opened (read-only)
> +- `stats`: Comprehensive statistics (opens, reads, writes)

Again, this is not an acceptable use of sysfs.

> +	/* Allocate device number */
> +	ret = alloc_chrdev_region(&dev_number, 0, 1, DEVICE_NAME);

Don't burn a cdev for this, please use the misc device api.

good luck!

greg k-h

