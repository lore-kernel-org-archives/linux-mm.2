Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB73CFD352
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41CDD6B0029; Mon, 24 Nov 2025 14:52:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F49B6B00A8; Mon, 24 Nov 2025 14:52:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331D46B0062; Mon, 24 Nov 2025 14:52:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 208676B00A8
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:52:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4647BA10C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:52:04 +0000 (UTC)
X-FDA: 84146546568.09.441135B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id B1BB3100002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:52:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a5LY26iG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764013923; a=rsa-sha256;
	cv=none;
	b=dgvldbK4VyFRZNmi7KxUMrTTZ5Nr32c5sV3svwl/pjIwU6DNbG8stJ54OKQG6gBRh+4XFY
	IVXYG78RPRItF5j+f0QkO+qFFwxu4DpdxJb2VWtdFVd6gqadwkkO1vEXsVjCc5sHnBhptk
	8L91/i/WNaCarxxTecYtw+PMrupTZ6U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a5LY26iG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764013923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57MP1DopHTQAggif2CcNJ9umqlpooR5GfWP71F0mvdU=;
	b=uHTVaAL/PYdvdZmN6KQZqSNS20+LwrgniEvavQbeEH7bgZ5fxskLBCoM23OMwYBwX7Nevd
	hl1Enr39Uzbt2yrKF7mofnl4NmpZPTfQsIoPymDQpDJfA1oc54PeYwSenaWyfZGX0A6Zi6
	hxuyQ6G9Cldr2UEQMW2Td8iSGLBG6Mc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764013921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=57MP1DopHTQAggif2CcNJ9umqlpooR5GfWP71F0mvdU=;
	b=a5LY26iGWN5G2pChfF0u4KKTGeOiH4oLR5V15ljywutINHSpYhAutg45vSga6ectwhyypT
	RnGpshRbIe+2WFUZbZR+mb6cqhlwULVko+wj5kZhuu0kJtII/r5GbLe9VT7jfhZvHnXJly
	fO6Ij72eMMfQgjeXOLGT47N8bJCjWog=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-uL-TaeAMNeaDna5HDm89iw-1; Mon,
 24 Nov 2025 14:51:35 -0500
X-MC-Unique: uL-TaeAMNeaDna5HDm89iw-1
X-Mimecast-MFC-AGG-ID: uL-TaeAMNeaDna5HDm89iw_1764013886
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CE861800447;
	Mon, 24 Nov 2025 19:51:25 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8EDD918004D8;
	Mon, 24 Nov 2025 19:51:18 +0000 (UTC)
Date: Mon, 24 Nov 2025 20:51:16 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Askar Safin <safinaskar@gmail.com>
cc: Dell.Client.Kernel@dell.com, agk@redhat.com, brauner@kernel.org, 
    dm-devel@lists.linux.dev, ebiggers@kernel.org, kix@kix.es, 
    linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
    linux-crypto@vger.kernel.org, linux-lvm@lists.linux.dev, 
    linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-raid@vger.kernel.org, 
    lvm-devel@lists.linux.dev, milan@mazyland.cz, msnitzer@redhat.com, 
    mzxreary@0pointer.de, nphamcs@gmail.com, pavel@ucw.cz, rafael@kernel.org, 
    ryncsn@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] pm-hibernate: flush disk cache when suspending
In-Reply-To: <20251122224748.3724202-1-safinaskar@gmail.com>
Message-ID: <4085e0de-30f5-870c-ff82-5a293fe8ac73@redhat.com>
References: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com> <20251122224748.3724202-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: B1BB3100002
X-Rspamd-Server: rspam07
X-Stat-Signature: 7jcku66n7xhbw39ksgr9mm4y146oktgz
X-Rspam-User: 
X-HE-Tag: 1764013922-135591
X-HE-Meta: U2FsdGVkX19DYwb5T32G97RCVxuyxMAm34TW0Vtyheri6RHDKAACs0RfRhS/WNitMS8oZtV6Gr21koUsWDpaTxiyB7AsO/Iezuay2Mv5HT+WTSOGHO7TguPdTOCSvU2Jb2s2HoVj8pe5BXY2dmN5SPSHrZYQK0SP6FkMKHT90vUY3aNmci+pKSt7LYJgDafJER26utYgY9PyM5X+5n9AS+UTketNPr5KDBYep8KcuJziuGpQ52+T/yo4iONO5AcILLk4qiATeOOKu29sJxTzbjoI0kXcr/IiivuwNTypTHtD7Zl6op2KwKTumBih2DqCQzlh5qY2phXd2hJia5sz3WRKZD5wBpwyL+CyTmxNWwk7cZnjVn4EevjPPdG2fdy3W0oC903sw4bSuX8ukhE+HP4NqVf9MP52vMVoKdQ8vHUqANr6etRnEZF5nOOtMsRKwPNp9bS9uF7xTCT/JMN+SrGBkqcxW7bbU8ZMqTPdxdrqLSwtmLecJKxKzKXuCRb8ujkrQJvOsuELOKw4FJNOO2LIe6xEOspkFisbxgYnJLL2vsqkUBXNbgaoAg6jU9Fotln6W2bz9jnV1gAimxGPNy5aubCc46ez4NvXke6yd6ZuHw347M/8EhOpuFWNTr8+NkS7gNEhKyBnIqW4SbQktrEd+IXX+9p4afzNeosNHh4W6qf7nVJSZDAbP93eTVpGyCrGZoibk5yLUQAduhTEhJOKpBo+WvYwoXDPIscCuGjC/j8B5QxTg3IWtDcrwDaKiJp4ByD1Weouh8Ss5jJ1XOASicQQIQGkHbNIgKM59Az1hadhIHg19Fg328oEFvycXzn3QtR6C29L/SVrqNgBk2d3+AudEj4Y6s+stRmlKXbaC1Cd8XvJRnSu7x7C+eiQIUVJ9JO9QzF+YjOOF97Vlhhox/kr8GSLw9tt6taHgYGn2oTeV2xi1vbUYNSIFepv+zkYW98Im9YJXVg9oin
 aopf+kJQ
 wGs0iyKxv220dIoQRPujcpXJCZUNXAv7t91gBvUyEwzg00UOm/fMYr6RpqKWOhv2VdBDeOPFMSHzt0N4LVo/EN0lbXZGdIkDZ4NZ1vPpnB0w/Kdv/Rk1+q7PKYpQ2gtEtM8dobgXmiIastZsKYp+6sPQ2iWKzlHriKuMVQxcOI19RY17Ybq7gt2TfBfkhOGEbmGdj84s+zqQKx5uBi9QyqWJjg5efmiNZanzUhawGuCcvJY6fidCPyzRsO/KqogJU9uix3ojp7rHGMooRWgUtaPHcBgTLombi8qoRr5WhdDp25x1qy2/nAbCauiEbRF1O2ZfHdKHG5e21WrMgzBo9Pm0mTzQ8DLurCf84i2WlqB9Xxto63IKM6LxjnVbQgXckSBGT82qfhuHPnP/crCl3tR2QeQ8IPX1Le7lep+2K+8DCqlg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Sun, 23 Nov 2025, Askar Safin wrote:

> Mikulas Patocka <mpatocka@redhat.com>:
> > [PATCH 1/2] pm-hibernate: flush disk cache when suspending
> > 
> > There was reported failure that suspend doesn't work with dm-integrity.
> > The reason for the failure is that the suspend code doesn't issue the
> > FLUSH bio - the data still sits in the dm-integrity cache and they are
> > lost when poweroff happens.
> 
> I tested this patchset (in Qemu). It works.
> 
> Here is script I used for testing:
> 
> https://zerobin.net/?66669be7d2404586#xWufhCq7zCoOk3LJcJCj7W4k3vYT3U4vhGutTN3p8m0=
> 
> Here are logs:
> 
> https://zerobin.net/?5d4a2abbad751890#WMcQl4FAZC9KqcAuJU3TSVr7wuVnPFwI7dlinA9QHOo=
> 
> Tested-By: Askar Safin <safinaskar@gmail.com>
> 
> There was no any reason to wait for me. You could easily test using script above.
> 
> Also: Linux shows this scary message when booting in Qemu:
> 
> [    0.512581] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> So, FUA is not supported? Does it mean that this patch is wrong, and works purely
> by chance?

If FUA is not supported by a disk, the kernel would send a flush request 
after the write request with the FUA flag. There's no problem with that - 
the cache will be flushed correctly.

Mikulas

> -- 
> Askar Safin
> 


