Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578B0CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4FD08E0013; Tue, 23 Sep 2025 04:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27078E0001; Tue, 23 Sep 2025 04:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64058E0013; Tue, 23 Sep 2025 04:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95F3C8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:11:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 484D7C0832
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:11:02 +0000 (UTC)
X-FDA: 83919794364.15.E8D802A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8BC1A40002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:11:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=oPlBAEyN;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758615060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=te/G0STKsRf+JUAJrOuyiaVBizy+3KQ+LNdEyrQfriQ=;
	b=wEuwOVZWzdnURytcCJK8aMiogaQkXEwbA0JQHys0KWSoeckemdbPfH3EquZdzWQjoCWqa2
	CRgd4X9CGDzaip6DBjVnjqIq+1pAzbFSv7xtN0xceQXyywRklMOadvTtY4oiM6Y7t2Wj7y
	CowYjjHOkaLcZ6eXA5CyAQkddKuZE6Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=oPlBAEyN;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758615060; a=rsa-sha256;
	cv=none;
	b=OLi5Nw7zkbX4HcJXHDnNmGNFDh+RsEnfcJneGA7vo3VCf9oK/wYSG7X3lS7sgQBLx1HYYn
	VRwKjjpVLgZ7N575+wtOso4WCt/io9VxmdMgH3vBjj/hDk5nfULVNrigw1+l25S3bHcDeC
	K2B3IfbbqzoTJ7No8pxIP0Oat+jHbxI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FCAF432CE;
	Tue, 23 Sep 2025 08:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BC2C4CEF5;
	Tue, 23 Sep 2025 08:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758615059;
	bh=G0FiE47jVMNmpHliwL+OFzsubcfkWiZQF2cHX5bGqrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oPlBAEyNSLE1mtMEit6tAgK95hSg/hQTQW8/itpwYbFtcgCyVxu4reyy4ldr1c/IK
	 ZQusSk+EIFC0Q9C0waJXT6N/Edur7zGGkpqtktnCK/BVRYXqGUZC9z7F1hnhPo9c1P
	 jIKc+xsaDiUXbddhTssHmndVtd4oud76X/HX5OfI=
Date: Tue, 23 Sep 2025 10:10:54 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, borntraeger@linux.ibm.com
Subject: Re: [PATCH 18/39] convert debugfs
Message-ID: <2025092344-bloated-twister-682d@gregkh>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
 <20250920074759.3564072-18-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250920074759.3564072-18-viro@zeniv.linux.org.uk>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8BC1A40002
X-Stat-Signature: t8fq5kosinzdj5nc7fhwp8rixigte39u
X-HE-Tag: 1758615060-64313
X-HE-Meta: U2FsdGVkX1+GjOqL+dHCml50ItKEKNELAloOjXzZWs5uj3RY11t8Ie32IzP3k0w4gURk1gyEMYckCG69Mzrvptwrknn6UTSDwP3a01vKg94KZeggb8E9lHsfTJreDjdN5sC6S7r5ZOEa7B8zok1Og0KGTuCGNOBwUAttszRlBaVdXpYppurRm9OLwb7sKYxbx+G1ue2S3j9mwfy+MYzgFaTU99GR5l00+DClbDidD7V4ih88FLdH0vNSxuVdBEl+GXlleEu/wzT6BJXRbyEiOnTzAHlE93X5U5khtSRq/1V83kBotKbATpsJTZO5WT2LqfGB1dc9lf6nwOeMd7/m/H3kfsFbuxUXpxBhFUbBjt6js0IMfKNtLpTdKGiRDdxxx4hrxh90s3Qy3Ex41oy8jMV4nukhorDEmDieJd4j/+33cCDo4FOGdeIsZ9CYSWaX0eiG9nZxq5doLIEf0S4OpvS/yhYQBEDaj1US2bh4NaMu8dxx1mMsjvQmLi5AfWIIq80r32WF+QUQfFSSqliz6+JlnkSj2TqK/OSGH3wrIa283px/GC4DJC/yD7nICP9CvwsqYrY6dguTfLp+gXZ5jkjR4o9ZlwyMav8dqgns/uhyy50b9pegczPhItk0c9ZRJRBzsuHtm+wx30Q+so/B7VCyLSf6rcrG4ILXPimmhgxBl74KeSOGQ6UsWOfUIqX1LSpx691C7KTZDiTQ4JpGAeK50I5ftqD4CfQzjr3q/eO/Hc1E8w2nMM4Sh3HSctmDIe2Am/dpbLGzN9d2y3EKwJFyk7hqQr8Hxv1AFiECv4Bq0u3Tq19QOAoLshT8KIn1ZV6/W3mN0cUeXYybXleurhsvMz21gdcGW5ZDKJCkj4Srd8Kptd5L4q492H43w1oBATZL4zWmLsZDYUbZr2qV7wYJe2rtOTsGUYHGPH2uXw+zQzvIfcz30SscMdr00On4BFYmMUAiR0rASAQ+C2C
 ZDJsHcG7
 l9Hnn/wh42HSlDhy0FDf01BXWdMfzqhzMsayr/W4LvJRAg2zChzaWCDwgXISTN1Zs1eaujRkzUzO4lkBz2R3B8myDufeDLQTiM/el4zBB+61BGLEAAixNKiKn7+zHN4Axgi2Db47LYOCkh8/xzrFW8lWZ+CkoMVPivOwHA5d8rRBp2ZRJXABzlyvg2XYsorl1c/EZwVF3LOrGKbCQdYFipr9EkGgcuSCSmQRCutRo+iaEsjfWW3BGWs89D4YgS//P4gIs2k3h5GzQVv34t1K3s/WALbH3t5KR52wcqrfMU6qX5KPVi6K/SjnKRMEA/h4u1cOTklElrseJzQkJ8VAMnUb8ddDs2qV0r2seVVA8KEnrBaq2bUM86Si/ORL6fDF1JqFWVxLV2aaT+APk1iorHef/DzOGaHjtoD0DavHz/age1MXkpoc1XAiyiQfiQhVs/VdF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 08:47:37AM +0100, Al Viro wrote:
> similar to tracefs - simulation of normal codepath for creation,
> simple_recursive_removal() for removal.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/debugfs/inode.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

