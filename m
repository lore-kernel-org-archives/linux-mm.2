Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 557EECAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DDC38E0011; Tue, 23 Sep 2025 04:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5A18E0001; Tue, 23 Sep 2025 04:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC018E0011; Tue, 23 Sep 2025 04:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66A5F8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:10:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0119C088F
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:10:47 +0000 (UTC)
X-FDA: 83919793734.04.5D79D74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 366E7120003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:10:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=CUu1lvbZ;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758615046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZwGSVkJMg/pC0iQ+cr7Qd3UuY5+roZiwC+AuRSFpduI=;
	b=UJ3880Al7u5KOnqyW1f68KmjxKrf4XFoylmqydidmEQFYm2TKzMi52YZ5u/o+aUoAa22zE
	LC2mDwMt1baYTK492gC5DRrd8Tz7LtcvdvfQm9K4wQxgeDX2lsxkStG6zyh+TkzWFvSUl/
	kECBuC1KjgD1MjK7UnyPltcEnrCEaaI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=CUu1lvbZ;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758615046; a=rsa-sha256;
	cv=none;
	b=k5+A14NOkvRpZzfh60RCIj2N4ZCV2DOV8b3YxCUvaeApeffSIK/BnfGB8NLsWAEgtLcIuZ
	J8+0w3sm4dVTIP+gLT+ciXNwbkgkDt/knDOHKJEis4SuZiy/O/N2PCpHvx/PEwW9YpcJxN
	vZqN8VQDnQhhCUrp85n+eh0KphIKOMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FE0A6027C;
	Tue, 23 Sep 2025 08:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF88C4CEF5;
	Tue, 23 Sep 2025 08:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758615044;
	bh=iW3WPoagLwoxw6Vm11W1B8DLUUbl+cSm5INVhgNbxS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CUu1lvbZ9Vi1eiQbP9TyKCBWnxSO+wgYt1w5dZjQNLBYdyQNp1x8oj13nSFHO0dgh
	 sjOnfLjfTdgRefJ7Ti7MyNKmVPU7anyFQuO3d/EvN39oDlbBs+7nY2MgKdB0As76IL
	 NzTQk5WZKpQpx4s86jlO4XYnqAhAVOnyTfn93l2U=
Date: Tue, 23 Sep 2025 10:10:40 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, borntraeger@linux.ibm.com
Subject: Re: [PATCH 19/39] debugfs: remove duplicate checks in callers of
 start_creating()
Message-ID: <2025092331-magnolia-educated-cd0f@gregkh>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
 <20250920074759.3564072-19-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250920074759.3564072-19-viro@zeniv.linux.org.uk>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 366E7120003
X-Stat-Signature: j688nc5fd66jcxmg7uzbj3eue57ifcpr
X-HE-Tag: 1758615046-390458
X-HE-Meta: U2FsdGVkX19GRcXPBQ8tQPPQveOx3m4tKgwJRkKLfvoZ3pdfjY10vRtqo92UP/jqXOxJGVyrsA2DxeaNiiGewNJWf2BO1RPf3iHh2Pvj0KdbZvX7gkT/uAObLsTQNdkOriuYg4oJhLJHcE6mXjQRkEdCkK1QKq0zIX54dc/BSOqSY/g+9aQi56LCcZh9Z8NDtpli7/iQNUZfZC/iv2AYJqUqeY9n8R65hgIobnIc21Gv0pbUEjpMTpbWTBvJ3G00ZeWbxrv7LG9805UWWa0Htu5Sdyg8KwU7xG9wXJn11nSWU/AQ+OjwKljEYlCf8j47O6QhSiR3+gWxDkGBo4tQsl5Yg0CZpnRFBGgqOM4leiNbTyPfCnxCJVFUpTmSGoBvdSPRlUj9uKapqG4F0SMs6o6w66ozTs1lupCuca9hY557ZG6qHO/XnTqzZuznl7TjDqtsTxZhPSkZufDewnAClRDe+gj0R8M7GlaYyjBAxrP9YAOwVhaVpG5Zan6StL+1p19p0jK6ypi8Vx6zyGl6x72mqlJWU31jppS11XptyZC6uboEpI2ob9W9yR83K/1S+y5fvnAKvegFAcb46MZClnWHkptYYHaZl59yLABSJI9oANhcMIedayLqWI+0YXAGCJ2xO8XkeURh/MBpcsVO9PtKsPXNo9d6RIct+eBVDEuWt4HqOZD71+WuO6BPj0QtuDKbaJE14m7iBL2FT0AxDUl0klsqeDk7K2GQc/CZMudzX4pACOE5OPV3ffIbsnhyjrg0qMC2/3z52y4aAv3zJ49FesU76j1qh6ywTKCNK2FFuMx3lMdGvyOOJvRVEUWWRuzoH49UTSn/mrDfIHy6huqybOnfbOUkcVrojIK9BKsk7qNCXEDBXF4ROjk0KleBF4ky5yTPjjSaB5+HJSTibOvhi/pvg34q7KRkKPF8toZkofqE94SNh2Vxk6n8W8dnCBFVvIbKYuxCzuQdqvZ
 YGrUeUo9
 4I3zS9yumFgSmLBrWj7SVtBMyAgBwSjjKprwgV+8L7dGlOP24uQI9YiEbxJ8r1VGIFKt9hjC04Iabkt1AomnyYK79AlISsKzDba83qNI2+kg6WLjd+lPiJhmiMf1x8W4HnXylOKEzqwBdi5mArplNVRCjYz11A9PfgqWe0bgL81RsN6cY/OsCYOGEbQU9SOSu+tueOCxm4OkLYbr7HbGr68BDEooVponU5euMcG2P8Z3ZMqA5v0mFawXWPhmjQ3nYHOLOktvIaHPaU2HEVG/ccHRVTEO1J7sn9obbnqe2Hnb3x9upal3CkDdBKlzbi51puP60eeaoKGW+PYfzqXlJR31yh8KjIXZ+uLLN026Oby/h8BO09y9Od98mpCYy9BYf14eJducH86FALz22Az33rs+fGAwFAA9MJHEBPsWllIIqQGSYpG5ue812AQPiVwxZwwYxbreFAFlQ5FVTQbogx1bwGb1u4PMXRimwz9Pn9vj7Eb4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 08:47:38AM +0100, Al Viro wrote:
> we'd already verified that DEBUGFS_ALLOW_API was there in
> start_creating() - it would've failed otherwise
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/debugfs/inode.c | 15 ---------------
>  1 file changed, 15 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

