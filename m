Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27AF1D6B086
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 16:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C7A6B0088; Thu, 29 Jan 2026 11:14:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526FA6B008A; Thu, 29 Jan 2026 11:14:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432ED6B008C; Thu, 29 Jan 2026 11:14:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 304E96B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:14:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69E001BC83
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:14:01 +0000 (UTC)
X-FDA: 84385497882.19.300E12E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AA4CD100007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:13:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRPlLdn+;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769703239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5GeqY1juZx6peJ0RBfJB14cgHFI8J5YlMRjKhV9azU=;
	b=Bc1/nHH1zoNRL17E7Xkvx4wupw9mRuCqr/JcelMuhhrrSpDQODfmj+DLWvpQhOz2Xcqc1L
	WtRTuV47lSwGcwMSh9StffGuENFEhAXDAOL6+TaD0WpSglag/mzHswtGe3MHI+3Zq289cy
	tjVaZJGTjKXOYaGa8uZwiZQO3I4k5so=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lRPlLdn+;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769703239; a=rsa-sha256;
	cv=none;
	b=Zni3t8EasrSHRJ2fA4WmXSYeb2qldBbIrTF5cTmm4Z95V9SwFyIpAsBZhmIDUHygxyKwb2
	Xcg1/lPlNLXJdF8sfG9Y+GlmdTCBS0U4smE0mZnKxlkQ08+MV2JQVR9SvfIlTwospVOIVS
	lKFQVKn/lzet+PLez2DxH/UItjxyekc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 826FC418D1;
	Thu, 29 Jan 2026 16:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74017C4CEF7;
	Thu, 29 Jan 2026 16:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769703238;
	bh=La9o6W4y0vVBdcH6KlN6XyFOKCu8acKZkPR8qhv2+vE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lRPlLdn++Td8jmuOq6JleUntXrH91GO4yrJZdWSzMPTDmpPBJ6nv76jPziMi9ovQp
	 bIn02G/pVE0WSFFQmfs4D1nBRF7jyfqdm7ehToSqEm91VEq0IutGkhv3z1n9RPuTNq
	 07q0cp4WRe74VrHEBVTpBegZIA/HFkpII9yOkSQrViRSZbri6Umnol8B8tzJ6/hFgD
	 ooc+izjKn0i5pxc9MlAcI6lh8Xbnz+ypRl6Awzf5VWArZUfWKLIV4l64hYaquEYURB
	 CwO2X2rA1nCqjH75mPKQtKLqEM/8oUvJbHJY7TUdsRFkbGTVS3GiTVhk7thEdz6std
	 VQBPs3W7lUXTA==
Date: Thu, 29 Jan 2026 17:13:52 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	lwn@lwn.net
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
Message-ID: <20260129-beidseitig-unwohl-9ae543e9f9f5@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
 <20260119-bagger-desaster-e11c27458c49@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260119-bagger-desaster-e11c27458c49@brauner>
X-Stat-Signature: 551oncm7pjude86wmh1cqmuhtn7bu3on
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA4CD100007
X-HE-Tag: 1769703239-223847
X-HE-Meta: U2FsdGVkX18liFKQq8TUG3UqxRv8TOJjf3HbM3KwjO19O/TXqoUk7jrjyeve9Z/6zS1rTAFUVahGpErOrhhrUYN8CI8lbjU4F85t/5zZAYgkeWdBs7urtG4B35UBE7+1uKsRub1HenfaP9fwqtR4giY3WgUe8J4DMsviBi3JR7QJ79hmrOAVLaxKqEEbf8637fe754s8llzbQr4BAS/h2YoU7ePVD1IubQ0ri1iG/h9Rg/PBiRjAhStJH89/TAUKOXfnMVZ/WJzd1NwF8wRrAO6MJOvJPcQAKbhJUV0L4i0FmefaIoHahnFPGDxLeBHh9D/PLjvfAnmxCBD3lrVRPhiYxtvDNBOGfpRHJdzE7hxxvDQ39Fei6+25OAoiwTVUpmYF9ugkWE9hju6f1Uk4sDYMVc6yPyiROnOav+n2uY/qz7jUk64dcU3o/3KIttltgywncAWdIMEnHrSAj3cr5ZOWV/vPZ6CVp5neOgSaOkmwKpx+Rbloz10915rVhty+jmU9Yu1hJQ7O28yGClzJfsXpskiZvkCpaiGeW8y5sktQ3iqmal+OjHNEIVZxuohPx1/BKnqySgZsbpu4Xa7FaxSHWVFObnlJWqOOI0pXZhnibzaHKZHHraBCoUEyGxiWcNTiLQSr5pIRhy02vPuLKWwd3nhfeYBjPDLPqXQe3PVy2kXTD0ntDuIctL/ZDsidhccTWUYwm3qNlrXiJjKOn6VDvCV5Y71k5m7oZn4wSFZ7kMO5NrGnMRl8h+zzH6iyhJ7Q0YTxWFtT11G2PmvEBBL08+Uau9Dwbm+zdd2qb1MdC+CKfUqUnBEFhFhC8W4u2QYCmYzzeqSSBr/80q+tBMFOXRy6o/7REODcYr5SNEfw+yFgHN6ORYQIcEoGPCdW84LRBV8cfCWg+C1RiPiDA/yWYUBmeF69lbzLk9ORQUgRfXNknx/ind7f9BVnP9wWT5twSrlkLimUXceYGw6
 6Lw78QUW
 IqH+wldIVKPjz8MoGXKOQyiB25KQ+lvipcycUTH3xCR+R8FLWo4h4bGYOBlmTXdjUWfA4e/Y173CA1Bb8ghYJdAeFaCpO6tfo60nspng0XjTDM8XdNLETObcohoXDiKsa33Z8N9f50UrklJ8h6Qx5/4NtHzuNLnn1pFrELrdHt8F76zr5cPNEdCvkLXmdP3oOig55VcDgf4+PCLQY3GUJlo2gelvZT6P8pImljdRWp2F4Fgs77Sk13q/n6q3Ip5oV2fpxw7UvizqzhPn0cx8QdyFFNWf8yyI0itIZ0ktfi5htPnxcK5e2qudeffnmYDlXfUU0APTYORl8s9Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 03:26:39PM +0100, Christian Brauner wrote:
> > (1) Fill out the following Google form to request attendance and
> >     suggest any topics for discussion:
> > 
> >           https://forms.gle/hUgiEksr8CA1migCA
> > 
> >     If advance notice is required for visa applications, please point
> >     that out in your proposal or request to attend, and submit the topic
> >     as soon as possible.

This is another reminder to put in your invitation request!

What are you waiting for? The weather in Croatia in May is nice. What
could be better than soaking up some sun through the meeting room window
while someone's asking you to make your locking more complicated, grow
your data structure by just a few bytes, or to add some more spaghetti
to that code?

Please also don't forget to pester^wask^wremind your respective
organizations to sponsor LSF/MM/BPF 2026! Bring it up as much as you
bring up that patch on-list that didn't get accepted but would've made
everything so much better.

Thanks!
Christian

