Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E749FCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DFCA8E000A; Mon, 17 Nov 2025 17:04:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7D98E0002; Mon, 17 Nov 2025 17:04:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4798E000A; Mon, 17 Nov 2025 17:04:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1EEF68E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:04:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B744312E163
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:04:28 +0000 (UTC)
X-FDA: 84121478616.18.104AE83
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id C45B2100018
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:04:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bommFxq7;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763417067;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4vYLxHITOk7FY5Vha316u1XPKmx4CmxosD+41s+PrI=;
	b=sP027HoVSpPuVtO7C0mRHmTBKm30je8DgIAWijJv+OfSD/dAydO7yh6r5auzTZ01CMeWq4
	hOQ4cWCvqBeOKQMSpks0UOThTFgENxutZWvHMfEm9uCmv/Y1JkfcB1SzkTUtcRx0UVbsoJ
	72bPCwNfvyK24kme9gHt94smHxhcjnc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763417067; a=rsa-sha256;
	cv=none;
	b=rNCYVT8BvatrQoUrGhncyBRj9+pPYbdGFV4iLcHnktmFBJn5GknQk3tTxrEBOu9nXq3jxX
	9mU4pPMZb+WodJkVxdEujaJjz0ckk45q+KiGgum7xnc7IF8xhG8F0Zq/iJb1+YoLloGLpf
	Icih7oILJU0D4E9kZhkojALr0F0+AeQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bommFxq7;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x4vYLxHITOk7FY5Vha316u1XPKmx4CmxosD+41s+PrI=; b=bommFxq7sliAeyjvLPQEoXoIVd
	pKa5o1Yb4IZq/+Xwuf716utrTFwG+e1EsNxYWcpzPTbdpHRsyC+gnwvbW2CxCuCIULA7mQDMxwK5/
	AD9OstpSMVU2Lx+nYqPNClApquHbL/pPqjnm6CSLnpit0oArJLDk/9tAqD/lIMvZ5qr2Fe2hFo0DW
	O1QvQUtGp8okxdB0iNSpx11sF0WGBhQtqqPRzaeS3gnJrqxtzofIHkzHybBV0AkLPLWQ3z6hODug1
	LIuAWXCkHx6YuL1QuzIbhbKRobQAT7Rzt9v5JNZjbJHnm8L2IAhzA7JyTKsGV5a7GQI7nzes/1y1g
	a0CeNx3Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vL7KZ-00000007Jyi-1gmT;
	Mon, 17 Nov 2025 22:04:15 +0000
Date: Mon, 17 Nov 2025 22:04:15 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: bot+bpf-ci@kernel.org, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, ihor.solodrai@linux.dev,
	Chris Mason <clm@meta.com>
Subject: Re: [functionfs] mainline UAF (was Re: [PATCH v3 36/50] functionfs:
 switch to simple_remove_by_name())
Message-ID: <20251117220415.GB2441659@ZenIV>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
 <20251113092636.GX2441659@ZenIV>
 <2025111316-cornfield-sphinx-ba89@gregkh>
 <20251114074614.GY2441659@ZenIV>
 <2025111555-spoon-backslid-8d1f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025111555-spoon-backslid-8d1f@gregkh>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C45B2100018
X-Stat-Signature: udrzpzjp78zaf6fryxqgcj1o7x8oozhb
X-HE-Tag: 1763417066-387203
X-HE-Meta: U2FsdGVkX19K2D5sevsehms647mw97gbi2NEZSB/ifiquy9dARoZceNsEf8+5bToTl3gCUTLstJCNTiJvuMjr+X1uVNfOIsYiVj/kj4S8W6WGXbzolSg5iKTgRbFO7sTdbee3GHwJB3dTjSm6AbvwdF+7HfqI0IIer1Pdy2EM7IrWoaWOgGQKhxcHiwABTt2vpu6XStmLuOH6tANqvXqJWYJOOX/SqqYmK2MggUYKJezMNcoCYUzWEirgrYQlD5HVKwoRDjMzDnYkno6j1exqAR5NolheW2IrfOetCju90TmahjJ5P4EZOLn/I03pElCaFO1zZNnvcg3JTzg26BkiVcjrEWTONGZy2w/04YECgseNd/0IAUtmWiILe7Hl0zIGQRyrUvCDSiVxSavEc7py+eSesb4Uj4bsmgo9ahXlvQg6Gz1HibA5Isi99IgrF2pd1SXhUnr/HIZUKIcRChgb5RtWn0d5eo9EPVVTZ1omdjxClqLvmm089Kg7uwylTxBt08fVfmvnJEmfqT1A9BJf8FG77WOviyV9UTLrL1B0rCzC7wFOr8a5VGMEjID6GvuaGYWoGZksq77LH042QiyCzUdddIUeddfWX2rxJqkBqHRA9QGcXzTRfv+5ZfQl2AZlWKbE8ooX93wtUXKIOMFNL2/P3D/Jl8HT5E1b8Onk5tX8qNmi/DlcUQiDOx4AjQ+THkpqTeZ5RZpEhIlhqBSFFO31Jhb28ooi5wfikX8s7ABzdQWk66pmGv/gSqSj49U9Uwam60P9hoIIvQ4Oi/j6OLjS/JC3gt+xFSu9Zp4Zd/FgkGQg89TQds2TM58A75+Uty/l4XBDhz0QYGf/W8ukLXgJOJ1Z9RF1U6xzwQzLuqSyTDj1gZBqzabvfYkexM/X+GYLOHd37glnKnY18RQhj8mVxsuuyQ7XHlGfvboTewyYl1W/QYhvjt7sh7hIG81KAXQMnPQI3nhzECREpC
 z5p44rxi
 0H3QrImUg0oDU+NZrNtSAlV0zyX7pURM3HmSetZsX1XCgj39qwt50zKGOWp54ddlScfOARFfOz4/+bFBaQoZ0mUcGxWEs5r1I1VGI2pwAtyBLxpd7E2S0y32pgkcvLWwMKASkTLudaggimUskZ09Nlym4zi/xydcCTGELD51dejIXgmCfPszsEhOPQFNR3SHDLGZ04q1dU+V3vBNX7a6DUUrng2ULG2nKDSLqTVWn8jgNcJSMte9rJHpErmW/OD1j91+j3fYzfAa/kIaaiXMK4GN5qUNHu+JbGGuqYF/hZZOtLIR8EixVSOZmkmiOWLP37/SIgEeIBYNfIoXAewAZiACpFz2j5t8Zc8Zka4MRtJUBFRHhA0aTmP9KAld5jt03KSanD77COBkEnu2Hzp9rUwyyTWaAj78xCfoJUc1hUHhY9fDJHbHYqWaXu5EkjjqR1nZJ5IRtX2UTp/P7vrLJnvg0XjRxOLPCSue1QeMomorP/M0IyC98FAGVmKnw5KlI3Tm5jUFprR+PPHcX942XYNeFJf3r+QUlQEBdCG9r8kJGf/ADKco13elAqnr1TApgr8gQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 08:21:34AM -0500, Greg Kroah-Hartman wrote:

> Ugh, messy.  But yes, this does look better, thanks for that.  Want me
> to take it through the USB tree, or will you take it through one of
> yours? (I don't remember what started this thread...)

See #work.functionfs in my tree - that patch carved up + fix for UAF
on uncancelled scheduled work.  Individual patches in followups.
If you have problems with that series, please say so.  Otherwise
I'm merging it with #work.persistence (with #36 in there updated as
posted)...

