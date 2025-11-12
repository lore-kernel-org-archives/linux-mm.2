Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E38CD1297
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7517A8E001E; Wed, 12 Nov 2025 10:50:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701678E0002; Wed, 12 Nov 2025 10:50:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617BD8E001E; Wed, 12 Nov 2025 10:50:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC8C8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:50:19 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC63CBA098
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:50:18 +0000 (UTC)
X-FDA: 84102391716.28.70A79D1
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3140A1C0008
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:50:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf21.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962617; a=rsa-sha256;
	cv=none;
	b=SdWc5JedJlSB7NtJX27JsSKwTaTeC2RLKqmODZSgFK3smdsBAYimvnepfeD0+2sqFV2aqt
	nGMrrE9SA7O6tBpvvRUVCMoSfD1IiZ+aanGVDaU+uXf6xDNMqA5txRoCas69Ez2+krT23M
	2N4UuJYW7tIyyEkCyUFCwtaglskXfY0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf21.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dT2rhBg6HEDnrJN/vIUu7tfE73OJWY9khNApCH0KT/Q=;
	b=6tQlnI5q5YaD354/PbHkL1uu2cdHo4WuFSBgYVteBRJR9xHkyM2I3DNtJ1GWbkyJuvIoQy
	z+3RJxSxRXoXv4ad6+MQ2i9V/HmeSgOvJ3u9PcESKzz8sq0bC/B3iV87hL9okBjQqbS5ql
	m/2qGOXNOg1HsRikbgrvJvF2fj5TT2U=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6DA2C68AA6; Wed, 12 Nov 2025 16:50:12 +0100 (CET)
Date: Wed, 12 Nov 2025 16:50:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: mempool_alloc_bulk and various mempool improvements
Message-ID: <20251112155011.GC7209@lst.de>
References: <20251111135300.752962-1-hch@lst.de> <48e45106-f76a-421d-8f9c-645469076ad4@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48e45106-f76a-421d-8f9c-645469076ad4@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3140A1C0008
X-Stat-Signature: s3e7wjfjqr4b8j7m5t1s48thuzkdk7n1
X-HE-Tag: 1762962616-236108
X-HE-Meta: U2FsdGVkX1+yInXoLZiLOxmqUqhr+iSr24f+Mj8pyFVODk0yR5ypIh0p987SWnbflMQ8HPTFv3As1LhT0OQjoBgetbJNv3Yh85+vt9/DtitW1nEHU3WW1UxEmKElg32ahjqsUmy8zMUY7DCxNcn1sAe6V/qryHD0xCssOqbMurvaIOeOA0r4zIMCVysiJ2gmADJCsQ6bEMzwMpJafs+/Yhf3zGz2AV04cNZZZL5i8h/YfZkb0Vs3O1LdwZCQkpltdpKT73lyRWFYZXIBCGkOmJTyxPKtz614iY+iYWp/JP1kEhiGAXwT28gsdwWaWsJI5dbGhDfXCOC3N9lCs64IjJW/dZn9rsZIFEtBFMWzAx1iYYtbZEsp8qFt9IT81oijNIYRb/oHNkCaoZdME612ZYWwvKV+ahnlbuB4O/6h6tWtjB7myTFz6DYcnCE/+IYX0DPDKOkxGWsaG6PJcpcWoyFS9kf/Ha98r8Qes3QmTj4ccPBN0HyrTfS15bx/gw8hF74VuNfafAxo69F2Amu+zAV8u0C/QmwAb40WnywLc3oVIQEGzSV/V5oJXdcOtpzdKCs3omYIvIfh+mddh754d5b+5OFW8XhRLyzerLmVWP/dqoi+fkT4rSg0wK/vDFemfxCUJwCYJhW75HJG1SRtbw33R+WR+8knhNmtgaPieS8/r6JaHgASYu6sUlJgli+welTy54USp4iIXBbPkuO0ocbIYXTbsdmlS+b7lR4i8DWxknQkTxtdlRoaRqwpZ0rygRAJpvwV1tLXSL1NRangqMzxuSlPoYqbMF2fGFgUuOp5i0XWGmLsrLYJAoDfFkYZTyIq7Jn3mTaInQQLoS7occBCN9Ry8kUSRsh4TiZM0cFOr32v5MQDvV5GvklEXWebpdt/JwBNHNv/+YpBHSPXNU2rFKThyxwdZPTqcYAKz/nZ7ez039xp0vgUJ27PyIBNsztn4rqdbSk+jhlpRxx
 CCl8Cb2d
 PbmsJxGWh+1gjHd+aeYwEZo+A7BtzReGQuNSp4yIdJH0q07W/YMmoeCOSk9rv490NChk9IkLxxCKk0/kxMw6kLKxjejYeEQ9cKPVdehQZa11AjufSJBIH60KkDYum6sLkr1RmyTGvT+lZ2n856El24iwsamTtlJcMWz3R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 01:22:01PM +0100, Vlastimil Babka wrote:
> On 11/11/25 14:52, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series adds a bulk version of mempool_alloc that makes allocating
> > multiple objects deadlock safe.
> > 
> > The initial users is the blk-crypto-fallback code:
> > 
> >   https://lore.kernel.org/linux-block/20251031093517.1603379-1-hch@lst.de/
> > 
> > with which v1 was posted, but I also have a few other users in mind.
> 
> How do we handle this then once it's settled?

Good question.  I think there is enough mm material now for a merge
through an mm tree.  If we get it sorted out for this merge window just
merging it through mm even when there is no user yet would be easiest as
the blk-crypto work is probably not going to make this merge window with
additional review from Eric and I'll most like have another user for the
next merge window as well (block bounce buffering for !STABLE_WRITES
dio).  Otherwise we'll have to operate with shared branches.


