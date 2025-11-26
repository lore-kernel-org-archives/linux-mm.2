Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B65D11196
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 20:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610006B0007; Wed, 26 Nov 2025 15:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1386B000D; Wed, 26 Nov 2025 15:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AFDD6B000E; Wed, 26 Nov 2025 15:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35EDE6B0007
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:02:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7D86C0798
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:02:30 +0000 (UTC)
X-FDA: 84153830460.05.BFE81F8
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id DA786120022
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:02:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=LZmCZ9Gq;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764187349;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4aSs3i8MxSsH9LQQdFXRZ1BuzBNVqWnsabFj67iIHM=;
	b=Wtz/IkECl6AfKXho6Vv6Gb34Eo8/HOIc78tfPB6FcAIqfMzVqNHEhKtg27LU3ws7ZlIBt3
	/6eYitBEK2NslbNGbvd7xqlmVo4mQucSJiSU4M3hH+obDTPgE2aw0ltiS+tX4RoCz9PBi9
	RzhbzyDQtzgthMxtZfWdJhdAtM1faFs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=LZmCZ9Gq;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764187349; a=rsa-sha256;
	cv=none;
	b=C7n0hzOmg97ps/MFonSdDwnGTo+kOHFatT9gMRJmRo7YA5h4d8XzhQlpT0mCchmmj/q/oa
	pvQLHmg40A9W3ea2S+coUJuIRbkkVk0PMB+ReU+8seXOzLTqoSqI5SCNRQDavOKlT6tkZX
	QNVX+Cc/ayEyUVU6TuKpc4dJWJ1p63c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=o4aSs3i8MxSsH9LQQdFXRZ1BuzBNVqWnsabFj67iIHM=; b=LZmCZ9GqC2htrAE0BVjhaPqHbm
	INkERVhSMY1db6iQJ4Ngu9AKIvVQpb9JE8xz31dPizJduLq671DX531BBB+KJV1Sjyi/sey8w80IQ
	YOooCFH/lLeUp17ag+6xUA8yKj8RZDwMFNUSsjcs8VJMcvgbypRlKTy66U0t99XSc8VTR1NQehinX
	SKIa6txZRdmeT3ZKSTGrp4Wk3OXxlT1Stsz9j2rwT5sTQN4R4aAYzSJbTvsx88Wgb9TMv6xbiMhs5
	v6200KJYAwWcQ8YmK66v/BuAUrigq0ReBXRDD+8ti0UsNN07jiln45kL/AfUkfpouHzXAAC6n4Y5x
	st2zoTKw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vOLiX-00000001VKP-2ggS;
	Wed, 26 Nov 2025 20:02:21 +0000
Date: Wed, 26 Nov 2025 20:02:21 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, brauner@kernel.org, jack@suse.cz,
	will@kernel.org, nico@fluxnic.net, akpm@linux-foundation.org,
	hch@lst.de, jack@suse.com, wozizhi@huaweicloud.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	lilinjie8@huawei.com, liaohua4@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad()
 with rcu read lock held
Message-ID: <20251126200221.GE3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126101952.174467-1-xieyuanbin1@huawei.com>
 <20251126181031.GA3538@ZenIV>
 <20251126184820.GB3538@ZenIV>
 <aSdPYYqPD5V7Yeh6@shell.armlinux.org.uk>
 <20251126192640.GD3538@ZenIV>
 <aSdaWjgqP4IVivlN@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSdaWjgqP4IVivlN@shell.armlinux.org.uk>
X-Rspamd-Queue-Id: DA786120022
X-Rspamd-Server: rspam02
X-Stat-Signature: z15u9gdpte4kia9z41zax36bkd4k4hg3
X-Rspam-User: 
X-HE-Tag: 1764187348-701319
X-HE-Meta: U2FsdGVkX1/iRc4lwyuqeg+lmy3D8wbD9QI7AMQorcXIZwog2VFgtL2/d82NFPsHUaX+d7pNJOr2MCAjkOdK6hJJDX0pb+eaMA62IIQLunI1be/iE+3QjnysoCHiKZZqOCoVexzkqUFEw4KPLZroboMjY/v1dbVU0IHACegxSUuavjUMJ9Djqiu9YWfp3e2Ka5K3zk7OPvqiWLYFmLSu5rc5P4Lnov/wgVlcZWV4A+FF9sbuohMvXDSFjDdpxt+HJIStWKhoIKzDDC8yTrP2OLTgLtjiUA/2zENr/B53ZYxH3ciWmYVggsVecPTLKFWSMeGO3x0N5IWW1qlUCe7nDns5n0/fWHH01ktmgl5LlS9R4h1aKlKpNHOTValFDRqhyvYAy3otwl1tpZ7YmRBrKTsg1bUwRjL8MM7cCXYZDrd1IcaewYDmrGXyTUe67I6VMQp4rVrRVDnrf5TOtwpbCuUFStaq50bt/s88tX/j1ArVMixVUaZeXTljdq+BwqWuEKkycW/HzOiL2OEclUwuiyCjvcNla6XGTbHfjqlZ3QEVdzskC0ZEm4vVQsKacZOuPDS/+5y/KDPJ66SKiiaylbOgtzXE7rPTt6KRlpcFZ59zd3/YmXx9pWjr74odm56qcVI0rBhcoROd4YawXaxj77CM4X9+eV9q3F/GuhMDSEUXMdUD/1bLJV47BIa74yp6il8+1RmMQZfrccKvg9w1BjdNqDi5E9sSXzzFDydB0rJiwcJFdx2qSkaydi41riXmv0Gm0EVowHJEUFGJstIEKzNrO06+4ZAR+zcr/7YN9OUa20+jpJ+3550qz17yM78L+Dqp28GLrwgO6guBqvczLmT8xgcr1FJTGGFZ3GakwHv45rWy4aJpnGdSREYV9kqopMm/qhQrm4L/Yk1gwY+X8boAr5PVFcVq3fcwRGJygxs4Tax8a1T/8p+L7p9HK6r+q2aNPiuEuClZkZ65feo
 3GFHpc8Y
 I1262J1Iu4TVjGcehCQ5GIgLcmUwOV/NKYkTAuzF2zic6DI1hFP/ImKQYv0DiwlsI3r5IfVtaXNfK0KaDx2Gc1B9q5q67BxYABHQW5qp0LVeAFgeSOURFX13BS91IPeEZoxC+cU3ojqlxRL/dDDN3o7zYMJH1irx3FzXGXAizAPBRBakE1igwomUrb/FyNBeyb+AY8T9CvlMNoKKb5gY/bKTZGonDUj50C0wtAWlHL2dMWTjD6jy1PK0FHQFrcJZ60STQfzJQesWnYgmL855Ar8PLYH1U+giaIFizVt8ky83waaDdPG9os/Yi7Eaj8tkuMMJv1p5XcbDbCW5lIDjBRccqq6858SMtd6/BbfxWq7irQoDZ1XrnF3h3AbbYGRaQacOrGRMcywZbuI1hrzigWpPgyfepRyuCwFtdl8Dvu4NkaFkG8477HCCIUMEj6GjAFx1ZmXmpzrdDIljDC2tby0BnF6Au3OsHdxBvNQyaI0oGeWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 07:51:54PM +0000, Russell King (Oracle) wrote:

> I don't understand how that helps. Wasn't the report that the filename
> crosses a page boundary in userspace, but the following page is
> inaccessible which causes a fault to be taken (as it always would do).
> Thus, wouldn't "addr" be a userspace address (that the kernel is
> accessing) and thus be below TASK_SIZE ?
> 
> I'm also confused - if we can't take a fault and handle it while
> reading the filename from userspace, how are pages that have been
> swapped out or evicted from the page cache read back in from storage
> which invariably results in sleeping - which we can't do here because
> of the RCU context (not that I've ever understood RCU, which is why
> I've always referred those bugs to Paul.)

No, the filename is already copied in kernel space *and* it's long enough
to end right next to the end of page.  There's NUL before the end of page,
at that, with '/' a couple of bytes prior.  We attempt to save on memory
accesses, doing word-by-word fetches, starting from the beginning of
component.  We *will* detect NUL and ignore all subsequent bytes; the
problem is that the last 3 bytes of page might be '/', 'x' and '\0'.
We call load_unaligned_zeropad() on page + PAGE_SIZE - 2.  And get
a fetch that spans the end of page.

We don't care what's in the next page, if there is one mapped there
to start with.  If there's nothing mapped, we want zeroes read from
it, but all we really care about is having the bytes within *our*
page read correctly - and no oops happening, obviously.

That fault is an extremely cold case on a fairly hot path.  We don't
want to mess with disabling pagefaults, etc. - not for the sake
of that.

