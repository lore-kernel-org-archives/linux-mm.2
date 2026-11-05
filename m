Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C62B606A332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hLWHo9b7
Received: by kanga.kvack.org (Postfix)
	id 9A65C6B05B3; Thu,  5 Nov 2026 07:49:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9308E6B05B6; Thu,  5 Nov 2026 07:49:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3F86B05B7; Thu,  5 Nov 2026 07:49:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE6F6B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:49:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F8C4809D0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:49:29 +0000 (UTC)
X-FDA: 85401046458.13.C27638B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 469B340007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:49:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLWHo9b7;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793882967;
	b=xtA0+fN8yOYM8su+aje/r3h6/zmxOHz8jHqDyskcB3ZcQRco4PD07VwVKCpl9MU36M6td8
	3vy1OG439l+vAz7haBa4bnOHYt8bUmsahXkIn5iNq+wp3MgvXJ7LPJvW9oXnBsxEy5wGLs
	Mj3caMIlWhbVo0QtIQa/TTQP5hT5LZs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLWHo9b7;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793882967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jm/wpw0aBzb0o0AOc3jfnmw4DQX6HAAVWZR9EuNYLsE=;
	b=k5+bwDA2BOlY4+EPU/XEZHxEyPWfLjBl445xJ9Z6YsNCQCKztWY7+v/nZ8LF0CuG1eBMQu
	igbmY7sHVP7O5TNFX2Hl2YyJO0DY2wiuakC/nU8sreybtUj4ZGlj0VYDmmlGPJK5omGxN+
	qVZTk5PGMWa6hoV/URXAsREksJjeHrI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5A1260267;
	Thu,  5 Nov 2026 12:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7799E1F000C1;
	Thu,  5 Nov 2026 12:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882966;
	bh=jm/wpw0aBzb0o0AOc3jfnmw4DQX6HAAVWZR9EuNYLsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hLWHo9b7hGosYSZW7trOle1t4JGK+lOuRPHSSG2ne8QkE8RxORZgz/3ScR/mCd2NY
	 h4x0RAkm3nAKpJimuuuZNFst2I0wlcVKPd9C3H8o1ZlG88z0q32xfuIRl09+T0hymM
	 02iY45Rq4Iz9PPnlIJQdwDBnQiAqnoGCt2Q9E4My7WZ+jOZgXT6sVvUBPcnCgA3QkO
	 R63JJQQ4ALhdm4ZoSLQ+trtZJKWSmaG3b+ELBuyu7Fskp8LXuzheAoK5YOhjbl2OZF
	 rQ1FK5kT9Ia2+DOVQKMDOaF5dIo90ieLAZjIb1NU/BVZmxs/9LNOkGjNHAEIzv9rVv
	 3ZWIE3NaexvvQ==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.ams.internal (Postfix) with ESMTP id 875C5198003A;
	Thu,  5 Nov 2026 07:49:22 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 05 Nov 2026 07:49:24 -0500
X-ME-Sender: <xms:UnvsahYHfhfuowuo7CsP8DI_Mq629tzha1V6duSqF3d2rOoPSMOv2A>
    <xme:Unvsapt5IHWqJRc9M1sDyX7maYF_aTnvkF3rMU-NZSWrWQAwToH4sJh1chBA8zN9S
    vs5PWUD70Qqfv5gbjKLksaFf6psAS_xzlGAl-EQFYJgCyqCRlGupGA>
X-ME-Received: <xmr:UnvsaokNKCzaNhhvvjKtVP_uXeFX2Ktxdm7UD05Mw8QsKXMyVPjJI11dUpQ>
X-ME-Proxy-Cause: dmFkZTEW4JllTt5Idft6CjxHmeLyHBmFga2y1IuhusNWLkk+RuUzgi27fIRUkj6zehD73Z
    qXCwJB+LL25tnZ7MVvsM1jJdiEBmACdZ24JuSELrb7onelR59Gex48EX9ZAQtwkYfzKv6O
    uaYpMi0+N/MMtqlBvS8vtGqvcrtbxioqnmLvVVrtYt7ftIUJbtV5gX1DIVLeAqEZt1hxdV
    1+ToEn+FZOdUeh1da2rslwkQZ+AzZG7c40X/kdHTPxPibTU64dnYA36koXg0Tlz8Wztmyv
    SwnwNjIN0SiiiHU6wxG2euwX+lZfIbFsB8NG0sjX2VL9xr9B8DML+aHpZRMo5jzBfq1zPR
    ktSIxz93afPY52xXAJMQtDa6ryeGSkd99uQQ6HftCDK/5lq4A4EXG6248hlloaD1dqQXli
    ZfBqDxP6dPOx+dZRQ5Ewmf0owbcmym2T/DPtrd1oHh+5f0JrozQg5Z3q1nnwt2feob/tEk
    u4jNZriHcMDhzf+vukSoUlT4TCc8bTEwt3z1Ad0c8X1v6VONQOnV2MwVoZxOFNxVbqAT1s
    uTKzMC5Z5cFTuo+YI/c5cGoRfBKchT5UlKqB4cs8vwCsJf5yvPg+fHKtjE73dCphA+JD6X
    4lrlpVaOJ6xaw9/S6Ce8EuGV+CFGCBHfLl4DzEOInSySvMg3qWI/C/CplHqA
X-ME-Proxy: <xmx:UnvsaiWBPrxsObXpEfarSHjcZGtPcIfjWRAQTuI4KwVlYpuTuVT4jA>
    <xmx:UnvsajnY5bhdHIG9jufPM0V3sE_xvLSab1AQ3GDusGs1dZGlzkyHiw>
    <xmx:UnvsanQNGRjIVbPM2n1URzuw1Dv5PS7K8oFUojWmDZegXctMcg26AQ>
    <xmx:UnvsavE1b5ie_x4Ez0D48lT6jS7Xz-4pnh1JAvyrcmsJuSzP25PwqA>
    <xmx:UnvsapjUNKB-WYf_Z5-t4A4Z6DmdPTQ_jrkdSpcEREnYB4Kk8P0E7FuG>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 07:49:21 -0500 (EST)
Date: Thu, 5 Nov 2026 12:49:20 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Hungyu Lin <dennylin0707@gmail.com>, willy@infradead.org, jack@suse.cz, 
	akpm@linux-foundation.org, dave.hansen@linux.intel.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] filemap: prefault writes starting beyond EOF
Message-ID: <aux4uyBHKsFo5bTd@thinkstation>
References: <20261104071002.49693-1-dennylin0707@gmail.com>
 <aux0ruR5HpMBMPI2@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aux0ruR5HpMBMPI2@pedro-suse.tail5790ac.ts.net>
X-Stat-Signature: dcxpjhpus5zh8hmwh4yuf8p7x813yiut
X-Rspamd-Queue-Id: 469B340007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793882967-503641
X-HE-Meta: U2FsdGVkX1/CmiuhX3FCWtmToLwmhNN0qzTgGCtGwXUmQ4A2kbedcH3dC0oJjd1wxfY6fUjEdVsmfdirW6CZPbd+3UZpJCSJiBUdxNcZQG+u3Nzuj/8FR1pFCgCihTzNu4ahMwuV0necPTM/Df7qyDAQOYAwghTsJYOvFQIJw0NGo4eBz1vhtAF0HvQ/+M0wrJwMzpMD/ZdUo64QPMP3fUqu6KzbCIL4BXXgyN77lDngJQ4Zim2h118q53Yqi7hE/zEC1H7XyevWesWeaXBrYRVQcmW5HXnxI3i4GKdsmkevec62xi1apvGjfJZvRndYGxi+b6X8xcCEQt1OrPnb5ixIVASCbi3KdcUfSa0Z9Hte2RmgtbxgbEK5HMATCkfHqcZY14ATeU5dIalgkHIX2mGqP5Xo/0lalrkfvDGZGCkdn1J0EzSs8NcHQIYe8DQAWmt5c/Gl3OyR4czTetdnKTMOQ34SKF2liYrUg7Tio42hY/xdJE1Qjf5HeJlmMdK9gUJf9r8L00zr+4o4XZDJj9LZi/GDUma65swop1VOk72Lj6a315gPkKrJamO2lTENqKoQEG3k8FnFHwVahA5fmUGKewZjpbV98w/NoUHXkKAOcNZ8FOJn7JCL2jpr+oX0hQavy4r27YnS4QgIk7nlGV6KSb8hdrdmo+vnjzaAWtgRM3rGEMnes/XyHlVpat51jBGBA6a/UUi2dHhpBRjN0W02mvIjH7uEeQKKYPBcloNLedezUBmOCv5HrVmS+OcdRPhDVLrgu3/enYbgGyIaSL/mxpbRzxk4gQiO+46q21rQHVJKwFXBgEdjjLQO2cLAmidV1A8wL7TJ+f/2nTy6K1JF6KQAqRxVoTNS38secz1n2JCN36u7fHSyhlzAoP3bJgGSkJaBQxH+Ol5NgVD46dXPgNWBaG4VfEdZVCxtxjZo8/cTjsLciksVR3LxnOJXkoxh7jMNeEzSe8AwoyV
 JSWthJPA
 H3uXAC8qkl0DTIScF4xrCRNhXBCSrpEr6ScNynlA197iZVOmgZeG0QvuLtRoSKnxjcBKpR0EChexw9YgkKp+U1KZ3ZdhaRQb8j+MwaDSKzr56QGeSL4SzI6r41TP4VSt3fqLIgYtWk/5zHi5T2+vVnc73xLw54BqOIqEG262fnolGxKakOEXv8uBo66h0L9WhleYzsVq3cVwAzdL95y2k3V1DRvqUJbFBK1G9cs7+XREE9i2jY8/iMD1NSG53nfGcXm4HhFBKILciiPMULW7YcMKWhe8mUO4N/hxwASQYR4PNBaL0U78iF7spCvlaekn4EOVnIDAfYGdDw9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 12:33:16PM +0000, Pedro Falcato wrote:
> On Wed, Nov 04, 2026 at 07:10:02AM +0000, Hungyu Lin wrote:
> > Since prefaulting moved to the slow write path, a buffered write can reach
> > ->write_begin() and ->write_end() before discovering that its source buffer
> > is unreadable. Several filesystems can extend i_size in these callbacks
> > even when no data was copied. For example, a one-byte pwrite() at offset
> > 4096 into an empty file can fail with EFAULT but leave a 4096-byte file.
> 
> I've been following this discussion rather passively on the other thread, so
> I'll ask my stupid question: Why is this a problem? Yes, it's a bit of
> weird behavior, but system calls are generally not expected to behave
> super sanely in the case of bad input/weird errors.

The input does not have to be bad. Write from an mmap() of a file that
another process has truncated: write() fails with EFAULT and the
destination file has grown anyway. I see it on ext4 and tmpfs. Before
665575cff098 the file was left alone

> > 
> > Prefault the source before ->write_begin() when the write position is
> > beyond EOF, and return EFAULT if no source bytes can be made readable.
> > Overwrites and appends continue to skip this prefault. Keep the existing
> > slow-path faulting for forward progress after a failed atomic copy.
> > 
> > This also leaves intentional zero-length ->write_end() calls used by
> > generic_cont_expand_simple() unchanged. As with the previous prefaulting
> > behavior, a concurrent userspace unmap can still race with the later copy.
> 
> Ok, so it's still racy? What do you do if you can't fault it in at all?
> You still get a hole?

Only if the buffer goes away between the prefault and the copy, e.g.
another thread munmap()s it mid-write. That is userspace racing with
itself, and every write had that window before 665575cff098.

> > Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
> > Reported-by: Kiryl Shutsemau <kas@kernel.org>
> > Closes: https://lore.kernel.org/linux-mm/at9xXRhD2xZhszEj@thinkstation/
> > Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> > Link: https://lore.kernel.org/all/at-XtWBQg3jv3H8Z@thinkstation/
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> > ---
> > 
> >  mm/filemap.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index b74bc1e5015c6f318333427f223b9f42061a6213..30414d55412b84f11ebe98b8eea607ee8c04eef5 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -4389,6 +4389,16 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
> >  			break;
> >  		}
> >  
> > +		/*
> > +		 * Some filesystems can extend i_size even when nothing was copied.
> > +		 * Prefault writes beyond EOF to catch unreadable source buffers.
> > +		 */
> > +		if (unlikely(pos > i_size_read(mapping->host)) &&
> > +		    fault_in_iov_iter_readable(i, bytes) == bytes) {
> 
> I say this doesn't matter, and if you pass insane inputs you get
> insane outputs.

As I mentioned above, it can happen with pretty legitimate input.

> Even more so considering this is racy, e.g races
> against munmap(), mremap(), mprotect(), memory poisoning, and other things
> like truncated memory mapped files sending out a SIGBUS (or uffd) :)
> 
> I don't think it makes to add random prefault loops in hopes this makes
> for saner semantics.

A buffer that is already unmapped, PROT_NONE, poisoned or beyond EOF of
its file fails the prefault, and the file is not touched. Only the races
in your list get through.

It is one prefault, not a loop, and only for writes that start beyond
EOF. Overwrites and appends keep the fast path.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

