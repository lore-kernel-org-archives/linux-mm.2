Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE365CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA1F6B0092; Fri, 22 May 2026 18:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB476B0093; Fri, 22 May 2026 18:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBFF46B0095; Fri, 22 May 2026 18:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC5B16B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:41:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 610C71A0764
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:41:40 +0000 (UTC)
X-FDA: 84796529160.21.59C0C36
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 87C0EA0004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:41:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=fzGRFuDb;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf25.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779489698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKk+R/Gk87+i0eU1luqUgLxjRP4P7rgGxNJYbCK1vPs=;
	b=yiu+7xJDiiqOtKXwONOyyiJ/8oGy137mi1ELAkD9RsUI9doTjjKAqFd/rBWFhYkvA+SBWU
	FGSi/KMId5Au5anR/aAE5pPU8OFtdYqL1sLX94rXpbB+x9GlBi/Ce9uJihBR9pSIcWCpwF
	qOUF1p27v90pICUOkriOYdqQEtGlrRs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=fzGRFuDb;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf25.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779489698; a=rsa-sha256;
	cv=none;
	b=l9K5XvIBrd/zwZ6wWvEcIqsxHtxbguavzMzgcw/nHaYLmusf0qDO4kHWNTn/cVFdx/c9oQ
	sk8Dtz9usT6z2S3cgZxQlTt2ZaQLJaX6b4FsjXIXci0m321hiWit2nfPdLHIyhxxOGZbBS
	wAeDOIK6qovp7gI22v0xq4vfTpEV0IY=
Received: from macsyma.thunk.org (pool-173-48-115-85.bstnma.fios.verizon.net [173.48.115.85])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 64MMf9rW014755
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 18:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1779489673; bh=mKk+R/Gk87+i0eU1luqUgLxjRP4P7rgGxNJYbCK1vPs=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=fzGRFuDbzkUMu0uEQK2H4c1RfcgnLM3RfKHwG4javJ75OC9qF6AhAaDCLYfTMwPlz
	 of/InxBIn2Z19QZdFO9Lfn35k3wShr53V1AkPLqBH3y926x31L8yIiX5Ft+VhXuzZj
	 u6QWzugSykkNUHT2ZVgG3qguLUAzpDtoZQDbXZTjVM2bX8O4fdSlNwy/eEePJkgPbH
	 xkPsLmfmndIESLSSXVVw5gUV1IIehEFz4Ze8ZLr5XDmXaN6ar/CferRPBKhzJ1xyA5
	 xOcBMHr5C2Y9tZn++wyEJ2rpZjhv/cRPVTE2PhDddfmQdZgYpBQseZeb0sjiF8InMO
	 Oiul1xSVQJQJA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id DB24469EAC01; Fri, 22 May 2026 18:41:08 -0400 (EDT)
Date: Fri, 22 May 2026 18:41:08 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Akilesh Kailash <akailash@google.com>,
        Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <20260522224108.GA18663@macsyma-wired.lan>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahCNmWbcd_2lAJyk@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 87C0EA0004
X-Stat-Signature: fopj7nxbg5gq3bwf4si6s8i49jkkyp68
X-Rspam-User: 
X-HE-Tag: 1779489698-169120
X-HE-Meta: U2FsdGVkX18f5P7iYIebjSK+wRPORJaWGltPfu8Y73KYVOOb2/mVVPb8q304yiP7PGGrVYk9smuJoiAsI5Q2gpHJg0aT8CfAapCj3AJUck924xAwIkKk6LPKLbu7G0habSofybGoGhRurdbXjFqYHsdc1zoFVZmMkegpJgGM+l86giLt9eNSl3cdSMk5hENdgMTx6jABmV8iEMzdevHFwDe5yBTUjsfd4u5qbIjI2cBIDO+vZR7QlTiMwe8HCMwT8zM9qThcwJXh9GsHy7zM/zza6GIQbtKQaWRjGwNOvjX5yCUk1QlOyxmz98Fyic3nhZuIaQ8mJ0FA6NQMHkXrDmE3+3zUOlJNajFfJrsX0HYMnzFeOshQz7Gn6OP7CmRNK1wYbYK63oeYXiAy1vHrLCYTVorSXEo6jR6rEupAhPHDXznERJDZ2ymJD6cgo6UiX7MAE3H+sqRaSITfeRCiy9e9Od1rz+TySxHDLYvDVcmv7a/zB4tRhnUwiNVbUFPiTVRQG22PS4eyy7YyN0EZdcmTSfqsfGNFla3jFEK+szbUTH1+mS2acQF9SAfl6+Gx6K45vKJJ8x++pdk2ALhhAWIagPxMCaaKYvOVZxjyv5GPkm+A0QjGy+VzV0ckmFbdVuyzf8CCj6dGo8Bvwj75vmAUOE865uPR4MGsrBMjTWhF+PdyvCcIMvsYQjLyMrqR/dpUX50fq5qvRL/fM9X3bm5s4eotJT8Gq0kbHVfcA9j2KGGOtXrawuCzND5zpb8xp0JfLJ5gzwrrPIKZgEOy9HujPxI3JHl8b821hpNWZhRaTqmUJPHEiBfPLlPivCT5d91jeRacjnrVNqVSt6tgicmcKu+wEMmBsZCqdiYtmhamZQlJrZWCslMbpVUu0x5y+gGy0dQk3YMyQ7MRYwzbQLT/h7p/qPvh1fUN29IFsW8b01LKzd1MVQpnaSp14mIX36DnXCtomZK5rr3KsNk
 cfhb18G7
 hCFCIV9KnmURXN6JGuo28Ra2WPKRu24zchPlm+0NkBhLdkOXobiWsg07RxzKTyRLu/vdNo3tIS3VyLQLMLEsfNCfWM/oPF9RRYj8Mw2FoBeLSDP7g38zrPRJ7oMH2QNjsrhmLAtaDXf4/mh0KB+0rkVqAMKsc4sU3a8Bj1qjy8wS0xwlIgKhqymJoy5Yj+lJPRlQpvKRopmtRsDtUe9BsFVulylTUo7xmtpzp6bFnBLjJasagjqUq/Qpqgq0PPoVD0SmlOYvtd2CnUjD7Xab5ojRvHuEKRphium4VDotjkmUFuVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 05:08:41PM +0000, Jaegeuk Kim wrote:
> 
> Thank you for the explanation. It seems I made a wrong assumption on the
> usage of "user." prefix where each filesystem can support in different
> ways.

The "user." prefix is used by all userspace applications that wish to
store extended attributes.  For example, user.mime_type,
user.xdg.origin_url, user.charset, user.appache_handler, etc

For more information, see:

    https://www.freedesktop.org/wiki/CommonExtendedAttribute
    https://wiki.archlinux.org/title/Extended_attributes

I certainly assumed this was common knowledge across all file system
maintainers, but this was apparently not true in your case.  I don't
know how this could be the case given that f2fs implements extended
attributes, and I would have thought you would have known that when
testing that feature.

> I shared some motivation when replying to Darrick's feedback [1], but yes,
> it was not enough for all heads-up. The problem started that some speicific
> application needs as many high-order pages as possible mostly for reads. So,
> I thought we can turn on large folio on the specific files per hints. One way
> for the hints was using immutable bit, but it turned out it's very hard to
> manage disabling the bit whenever deleting the files. Along with limited
> ioctl() and requiring inode eviction to manage large folio activation, I had
> to implement this path.
> 
> [1] https://lore.kernel.org/lkml/aeA5C8byIpXWla7f@google.com/

Actually, you still haven't explained your use case, at least, not
well enough for me to understand what you are trying to do.

So an application wants a particular file to use as many high-order
pages as possible.  Why?  What sort of guarantees do you need to
provide?  What happens if they can't be provided?  What happens if a
possibly malicious, or at least gready, application uses this
interface to grab a lot of high-order pages?

From your patch:

1. setxattr(file, "user.fadvise", &value, sizeof(unsigned int), 0)
 -> register the inode number for large folio
2. chmod(0400, file)
 -> make Read-Only
3. open()
 -> f2fs_iget() with large folio
4. open(WRITE), mkwrite on mmap, chmod(WRITE)
 -> return error
5. iput() and open()
 -> goto #3
6. unlink
 -> deregister the inode number

Why should making the file read-only matter?  And when you say
"derigster the inode number", why should this be related to deleting
the inode?

This is an interface which seems to be very specific to your use case.
What if those requirements change over time?  What if you want pull in
a file without making it be read-only?  And what if you want to
release the large-order pages without deleting the file?

						- Ted

