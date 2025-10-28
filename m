Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD4BECCF9F1
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 04:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0646080110; Tue, 28 Oct 2025 00:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03BE0800E4; Tue, 28 Oct 2025 00:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC07180110; Tue, 28 Oct 2025 00:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA7B6800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:31:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 805CAC034D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:31:32 +0000 (UTC)
X-FDA: 84046249224.11.2F8B910
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id D953880003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:31:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=iSLxKvvt;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761625890;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6EhTcx4XVYoBHVkNibUDLjnZaviM/uEjsjdvqBMDQHg=;
	b=SUmaPh00PFYGdw8npluSV5WrPuOMyzGKWYtjDbNvvHFlbLhpdjWr/qHHEHJG15BPbgQGHA
	FJgCvJOgQJzGxwaFIy/97CgqH2oDGzzpf6c1VZjLDhJU6lJYPAsCiMsjokwSws9mput4g4
	CwACVfARdoy9c8unBm2rka7wCIRIO3A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761625891; a=rsa-sha256;
	cv=none;
	b=y+KL51S2+lvF/PPrRUwXcSdvENRpTLGRW1EQB0rFTMOJhnHhO7xhtmh1JiJdQ5yXz0V+PC
	VcnYPFwujCPmR2PqqtQAXX144g5i3U+xIGk9rOaGmHQV+6V0XHlSfgBQwsjapj7p27VOpT
	L2KYufuLQizyC1mYtcEU0qYgP3YMmBs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=iSLxKvvt;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6EhTcx4XVYoBHVkNibUDLjnZaviM/uEjsjdvqBMDQHg=; b=iSLxKvvtuhp7vyTm2gF1EkkIBc
	VueY3k/5kNwOCT60HJvudYt/pn3+nmuXN8BlmSieBlAk9P1lFjbnXfWWohkokyPBzwL6mC3YK0ypj
	sW84+IvdJ1yjbhOgc0P0eftHSrMDFpdFWkNpDO9jxNZQH/EQU+717GyU1YjNSY8UPlXoOVYqQCNUm
	L1/m2fq5epG+ZpDNUkQvsZfuwbXAFt2ERX3bKTejVx1aC8c4ns34fe3bXqhBWWrfvJuyhBA1jOWFs
	o+wjASO+eBBtE0L3jWo+tNcmc1JNpVF+OC3oqVXlZd+U3SoLopqjWLJ5T8ciF4EV4rkTBl4haONpo
	JNpPWnYA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDYaW-00000002gKs-2u1f;
	Tue, 28 Oct 2025 01:33:28 +0000
Date: Tue, 28 Oct 2025 01:33:28 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: bot+bpf-ci@kernel.org
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH v2 23/50] convert spufs
Message-ID: <20251028013328.GL2441659@ZenIV>
References: <20251028004614.393374-24-viro@zeniv.linux.org.uk>
 <022fbcc8127b3bcf15731de7956ca892619da224487161febb9ef1ed4c71597a@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <022fbcc8127b3bcf15731de7956ca892619da224487161febb9ef1ed4c71597a@mail.kernel.org>
X-Rspamd-Server: rspam01
X-Stat-Signature: 38zd1xk37kmx59jywbyooq5ietikb8a5
X-Rspam-User: 
X-Rspamd-Queue-Id: D953880003
X-HE-Tag: 1761625890-461294
X-HE-Meta: U2FsdGVkX1/qA5vswQjeygH2YWkbbDZ1Wn/g+uhVL2Iae+2K3Hw4FP9dowXKMPsc+YLlaNAa29it/olNn+h9CHqS2QI5wNZJUa166jH5Ct/X2wmK66IafUti6qqQXZaiVG7kskejpQ1kgmT+xfCTuvhZuNUkvWG+n/jVc7hlgBUiP/D2AX1q5qXpKmVQi87nGg94qZd6Gqv8Bqa2i1VpRsi5gsK0T5YyVOg8KV9yN7XUzQpXcdwRirN8+bicEXBtNXRz2BhbifD3b1560vGZO8yLsYjcE+K9qn4ClwlDgi/1sjmgf9UMah3r2LG59QJ7W4a+8xUUeWgjiNNEionY6c9C8u9FLo3/IYCy6Ycas2fkhBhip3xONxKVyXdrLxmdEBO551K9ZDvUnjXZ+4DfBqX31bd9E7o7daGm14zN9RjrJFuAWEwDq5vZptNw805CPNAHzCZXMxW/fn2fRPbs3V6zey1koHM+jYYtNi8I08TPYyAkIwlma5VT0SksV7OoD8PaO92lPRejaNnx0X6tMiE9aWsqS8PVvdQ7cYNF8srylwRejmgYwCNiW04MozYQydTLNSK5fhOrSagrN4jdxUf+pkYvGF5s3PEh655NxLAmgRYN8Z2g/CCdQPUKntz+ETo+XJTjJJdhTjDnWtc9oEmkBgQbfFiek8hhJHqkTBqp3lR3OvYarNeLj4c+cSVtXP1sVyC/kqwaZqUbVP773DcEEKss+28GFqlIrUqVitUaAXpfPhovwa/hH5P7iNIKODNMqMFH87nR5KuDyuN2KAffksiZ5Zuy1dhaERkn81WyXcDD/d1RmXwCXmhWMDh0szpQJxblmJU8ZbjdgK/pf4PXf/i5qN/LfQ3HBTQuP+AnfDGhLDk052V0HdO8XcqWk2h0jxVD8EMgQxYQL4uCrPCSbshEGddCbgP6Fvc+BFHXPd/daF4nxbcRXgZiScpr7YQ+zXwniJsvwLbXETt
 rprz9QYI
 QbrA6FYcEsPDcWKfHyKxYOTcoL97iODhixSOAFft1nMEqHa26WDONs1kcMSfC6ZWDm/RYXXUu4DYkiBaFLlPqnP7PRMpEQns6BG6WDsbbtwAu/xZOxUoIEhNLw14e370u1m8x5V8ipviLgPRYAlADoAezzLV4bU7w+8mJ9DoOdcjdhHUe/MSkIVVp9MJzOcdEoRpYQ/645h3nEQwgg648mMfv2Ai9Q1Vqgdx7WdqzqolT+bxdEmaPRaUwmOPFnZKLuemtOVpgjEWN12F1hqUAqO/OuJBRu4TTyvI3GEaMhOVg1izbw4WNH79T/9VzA3YVWYLtbpWknCNvXLbNXnmrxmQcUabIrvg81RRqzv7JzIsnrx2CVf6jvzPfVtqfMsncLYG41Lg6A4drAUFpkLY/Jsvy8AVmv9zlmavATap+uaxl9CHfl4uqjqzNh8dpxhA6JzCXHRt420UXQrRQxYUloMNM+49c/sooneSXIeADWhqVUw8+hkc2Ua/tK/PBFnaWWzaPv9k1lNdDDZ0LqjpZw4DRwlwnGvHDJY+X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 01:15:38AM +0000, bot+bpf-ci@kernel.org wrote:

> >
> > -	d_instantiate(dentry, inode);
> > -	dget(dentry);
> >  	inc_nlink(dir);
> >  	inc_nlink(d_inode(dentry));
> > +	d_make_persistent(dentry, inode);
> >  	return ret;
> 
> In spufs_mkgang(), can this call inc_nlink(d_inode(dentry)) before
> d_make_persistent() instantiates the dentry? The dentry is not
> instantiated until d_make_persistent() is called, so d_inode(dentry)
> returns NULL here.

Screwed-up editing - that should've been inc_nlink(inode), of course.
Fixed...

