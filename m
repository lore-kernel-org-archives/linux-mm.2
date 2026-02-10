Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3F6FEA3F00
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 05:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6236B0005; Tue, 10 Feb 2026 00:22:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADDA6B0088; Tue, 10 Feb 2026 00:22:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC006B0089; Tue, 10 Feb 2026 00:22:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F153E6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 00:22:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E15D1C1E6
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:22:02 +0000 (UTC)
X-FDA: 84427400484.16.8EDF7A1
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf16.hostedemail.com (Postfix) with ESMTP id 77944180004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:22:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm3 header.b=A1ABKV4n;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=rZpkH6x+;
	spf=pass (imf16.hostedemail.com: domain of greg@kroah.com designates 202.12.124.158 as permitted sender) smtp.mailfrom=greg@kroah.com;
	dmarc=pass (policy=none) header.from=kroah.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770700920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmSZWeAvIs2E2OOaIEyt1H2r3sCAT/z+1lGe1+pXOnw=;
	b=NO4u75+GFAPeVglEVG6EicHdnrx0tL4m2+lPKRUu/8T9kf/y3ThYlPe2LVGoD1JcNltZwC
	2wd5YXtWbP/wmbQe7hSCl7EXteldfBSOOSxnPc6kRxRRCRRWcJzx6HPIFl2EFSe9/kFdgO
	y7xzrbS+H3RmJtXpG9Iw3QjjqrAuyL0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm3 header.b=A1ABKV4n;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=rZpkH6x+;
	spf=pass (imf16.hostedemail.com: domain of greg@kroah.com designates 202.12.124.158 as permitted sender) smtp.mailfrom=greg@kroah.com;
	dmarc=pass (policy=none) header.from=kroah.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770700920; a=rsa-sha256;
	cv=none;
	b=4JCy2cFyc7AXbS/xTNW3vPqPL2LOrPrZGpxbXKyx9tnDJUqPRoOWcZ1YYPuEVZ97Wgi4jY
	dpuVYl5uqQ8sJEzxwHHAcPxInNIEYARIX4edYekieLz4BUM5ALeU9Uyu/fPpQG9C9HyG5E
	zncMnCdT1YWV5fhO5eBdqTmLUJaaptQ=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3AD737A01D1;
	Tue, 10 Feb 2026 00:21:59 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 10 Feb 2026 00:21:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1770700918; x=1770787318; bh=PmSZWeAvIs
	2E2OOaIEyt1H2r3sCAT/z+1lGe1+pXOnw=; b=A1ABKV4niBOGnYpA9wf+Tt785q
	XZbOSspq5Rf7UF/q+EGciU4u0FGIOfIJOpuyiB7wIW/5TE2bFmHlu6UKflj3bH90
	YeCCCbqQvhnPjETxZqa1pbqy/Polc9hm2e+0BU7j+H9akSkUY3BSKDwPnZ6Qd+3v
	FJ0vw4fAXKO9ZZGex8ppK1Aih07kdOmKlSx1Or3iFkp3Wvrdo6vAH109a7mQjXWk
	DDlqJub9gu2ENWPRM8QsgHNhCcLg2cesne3KrqRG0vgiUsQnPdsj5emWPOTKVWWA
	P6dv79r0YbZpXzckuaQdSuZXiTbBS0kQi8fP6wtYqxwWJcJzUnS0s3nByPiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1770700918; x=1770787318; bh=PmSZWeAvIs2E2OOaIEyt1H2r3sCAT/z+1lG
	e1+pXOnw=; b=rZpkH6x+TY2clXW66EjZ7y8pMJZ0it70GuEa/yv76Fwx5XEGkR5
	75iuUBJyP4osmsxGESdvMixsunZ+YsxhBGTPW881mN5+EOEglNm/LuxNPpYKvdmc
	fmEc/UTO9eeWRiibPFlBaihX65vC3+MtPqOyFipojXzQRRqO/KjEk2Gir3ECKCx8
	ThFBS98s61vzlZnJqqwtF9MnrwCkZiirr1yCOe5yjLV+G/r9tavH2RI+rfVXyQjm
	rjJuYg8WzaEf+x19RlPrDTR8JMy8DIr3JmtOGWcKxfOMb4OWZuDNH2cTjeV1gPmy
	EosbxXKmqJRiGRVC9yHo1DdYV2wBudSOC4Q==
X-ME-Sender: <xms:dsCKaYowjRaELRV71XXdC6uDdCpL525QsQLNWaHRVLLssbEpiLvhPA>
    <xme:dsCKabXym-yznvgpy7rI9CSAdUSDh4EYZKXNiWYYzmNzF5GL4AdoPo2XRQfJbAhGa
    7g2gKOvFohtB9RbgryWtXGkGDKkGhMpBmQol6ovEDBPqgxoPrk>
X-ME-Received: <xmr:dsCKaRHYPgnwh2yDkqAmF4FM8ENKVzL8eYHwuPMzceOmJ6uEbdPF57KLjqaEERbNyvoAVbpI07UCb709T6Bm0DcFVBgCEBnWR8UMMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduleekkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepfdhgrhgvghes
    khhrohgrhhdrtghomhdfuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtth
    gvrhhnpeehvddvueekieejgfehheelhfeufefghfdtjeetgfelvdeffffgueehfeeitefg
    leenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrh
    gvgheskhhrohgrhhdrtghomhdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehslhgrvhgrrdguuhgsvgihkhhosehisghmrdgtohhmpdhrtg
    hpthhtohepshhlrghvrgesughusggvhihkohdrtghomhdprhgtphhtthhopehlihhnuhig
    qdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlse
    hvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghl
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghpfhesvhhgvghrrdhkvg
    hrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:dsCKaaA4U_G8cEY84QDjNeMVM51VCM2JWqDgNL28vThKhYgcUeDvXw>
    <xmx:dsCKabwpRkBtH1Zq-BHsiOiM7eJ7OobKLcEiH8VYKcCZyrTO448iuQ>
    <xmx:dsCKaYf0Lhl0zIEM-29RY3Qzg-NOZ6OXQeiB-6RXQyNvLb68V7_tGA>
    <xmx:dsCKaYvvjYbeM-OISLYTqXUFZ1T2_2m99aE7fQ-LkJpUjHW6WttOkg>
    <xmx:dsCKaSV2Xrd4_QAL21HEj9ouG4vORj4YmPwE4e6sHG8f5Okt6kgu465A>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Feb 2026 00:21:58 -0500 (EST)
Date: Tue, 10 Feb 2026 06:21:56 +0100
From: "greg@kroah.com" <greg@kroah.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "slava@dubeyko.com" <slava@dubeyko.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH v1 3/4] ml-lib: Implement simple testing character
 device driver
Message-ID: <2026021045-handstand-arousal-0f74@gregkh>
References: <20260206191136.2609767-1-slava@dubeyko.com>
 <20260206191136.2609767-4-slava@dubeyko.com>
 <2026020719-thrive-domain-f0c2@gregkh>
 <d3f051c5920d4f68c00a92845e2491003b516a1f.camel@ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3f051c5920d4f68c00a92845e2491003b516a1f.camel@ibm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 77944180004
X-Rspamd-Server: rspam07
X-Stat-Signature: d3dua9axgn3bbb1orgowg4kwxr6fsdyt
X-HE-Tag: 1770700920-409049
X-HE-Meta: U2FsdGVkX1+YAjK5YhMY2PN8iUugtreg2V4DggXdWmxN4NphM7RqGh63xMFd5eC2/vfdMPRhMHMUfHFY2WFSDB1b4/wHZg+BpyLtmCaGUkvPsAyn+x9+Eh8c0vfXC+4n5SFipHabhu9dvRo1Dr2dFpcGUlIKzjmoOYzYPXPB88eAuAMYOrcnGivnkE+zLc+Fa2lOSeXm4kJ7nX0fNUBuRHoZ4t4uR7TgvoFIpCEkl53lANd3A7Y3i6qNf68N3GK6zN3rxoKLs29YAFCEI2Yy5A5zNZnvDKiJZchv6Hm/HO/3NFFwTmeR0vDQ0YSsb8jCLBkYnFKZ4S1m/va8zrwjhINbj7B6ie3YHaFjD17BHVEa23c7NhdcGPmVoWDfZSJOhWNAdym6quMyjf6VPgRNqw1oW6UCuBnAj78nl5fFXsksoWyskKcVtqSF2tT1IIC32pL6IhhyirmnpFzqH4ahzY52cpTbANkn+y39zWHws0vcJAnPCyWxFkT17lJCp+YkliFdg18spBNRzhXPBBiRbVDFDSKBzZ16GdECVN0Hm8iQG3dEl+OeSqcsmO26DuR6GF1jfdBy86jaidJaq4goqKk0Pwbftz1aD5Q+H5FUmqkrANf/x1T8qdqxE3+mqHGjR8kBHDC8NIpzkCvyKCMYWqQgRosdGSJ9LE1NYyoKsWkUQQjoyV6acl4aqcGY4+jCtuv1tjqNGQRMBIttB7m8JVIBfA0LgQKVGDLxyCA200xgyK93gK+ulC8VgvC8MMWjP8qdlZpi1i5qzfCUonpkPGXsBfALJKkKNMoT5kj/2PzMoosVmG27R9HUjpGrfRMXr9LerlhYt7d7w+wm5iUJXKdsrAVoK4jKZzxACmNjjK2MGy3F1cVHUiVTpPbIF6KiKr8bGcxhPTOV6/DDQDOw6Hg5HAziqsRKsiSI6y7yiKaQUbkUApBWFYeafNdtuuBRkwFpKED6ccHExJxqDPU
 UmlfDzp6
 wdp/eyyWinOAoHERjI3AluPS6kFH8FB8KponK9HfCKeROGC7qYZWEOZn6B36RFrqEwS8pZzG8d9+vmgs+TgElZpGOnjh1PDP3HICRIV7FIIKiFseX/SSLI75Mv6LegceXvyVGfKCHBDi5X8f86XBdzWy6xpaifItySU23Lmoi6eJqDio0dGASbvWujVMqJYxU7wqwYANLYCoynhLsW5iHtG2AuKkU8T33tsBijXNoQqkgS5kp9dkCvktnAkvEdKYDtvwjv/aDzUDnp8f5p+Nepau8l9c3Cwlu3hxSpxuDPQMunN1Ux18x1jpyIVgByTuSEJplLgGJ7p+w3YuMcvldDgfCooVJFJYSFJaYLuoV9A2lM1b1xeTVIRlhbqcaKviuKSODCVjZddpTyUE61s2iCDqlgoK9BY34q+CbmfyjtGePQE4gxUfcTBN6VoaJH/vmIFXn4Zxfh4z6DBYJjzXIstmS4AvLz5FohvSN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 08:56:47PM +0000, Viacheslav Dubeyko wrote:
> On Sat, 2026-02-07 at 16:55 +0100, Greg KH wrote:
> > On Fri, Feb 06, 2026 at 11:11:35AM -0800, Viacheslav Dubeyko wrote:
> > > Implement simple testing character device driver
> > > 
> > > Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
> > 
> > It's hard to tell if this is just an early april-fools joke or not, but
> > if it's not:
> > 
> > > +### Character Device Operations
> > > +- **Open/Close**: Device can be opened and closed multiple times
> > > +- **Read**: Read data from a kernel buffer
> > > +- **Write**: Write data to a kernel buffer (1KB capacity)
> > > +- **Seek**: Support for lseek() operations
> > > +
> > > +### IOCTL Commands
> > > +- `ML_LIB_TEST_DEV_IOCRESET`: Clear the device buffer
> > > +- `ML_LIB_TEST_DEV_IOCGETSIZE`: Get current data size
> > > +- `ML_LIB_TEST_DEV_IOCSETSIZE`: Set data size
> > > +
> > > +### Sysfs Attributes
> > > +Located at `/sys/class/ml_lib_test/mllibdev`:
> > > +- `buffer_size`: Maximum buffer capacity (read-only)
> > > +- `data_size`: Current amount of data in buffer (read-only)
> > > +- `access_count`: Number of times device has been opened (read-only)
> > > +- `stats`: Comprehensive statistics (opens, reads, writes)
> > 
> > Again, this is not an acceptable use of sysfs.
> 
> Maybe, I am missing your point. Are you assuming that I am going to share huge
> pieces of data by means of sysfs? If so, then I am not going to use sysfs for
> it.

Please do not use sysfs for this at all.

> > > +	/* Allocate device number */
> > > +	ret = alloc_chrdev_region(&dev_number, 0, 1, DEVICE_NAME);
> > 
> > Don't burn a cdev for this, please use the misc device api.
> > 
> 
> It is not real-life driver. It is only testing driver with the goal to
> check/test the ML library infrastructure and to show the potential way of using
> the ML library.
> 
> As the next step, I am planning to use the ML library for two potential real-
> life use-case: (1) GC subsystem of LFS file system, (2) ML-based DAMON approach.
> 
> So, this driver is only testing engine of implementing and testing the vision of
> ML library.

We don't take code that uses apis incorrectly. Please do not use a cdev
for this type of "testing" driver, that is the incorrect thing to do and
actually makes your code more complex than it needs to.

good luck!

greg k-h

