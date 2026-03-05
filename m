Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FEE4F47CB0
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 19:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7CD6B0005; Thu,  5 Mar 2026 14:07:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8EC96B0089; Thu,  5 Mar 2026 14:07:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A466B008A; Thu,  5 Mar 2026 14:07:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 930316B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:07:55 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA178139DE2
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:07:54 +0000 (UTC)
X-FDA: 84512944068.03.93E3DE7
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 076DC100003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:07:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=R2i4tM2w;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772737673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p27mVjaEjAdBEF5GkfeH8SlV1G/ydclOHv0CwSzCIGU=;
	b=Rm/UP1BMJyg+0zJY1HVl8wU+x38aWtljGDv2bfJT4flLcF7ehoRKf3jSV3iJQJZpu9A0rT
	b1vTDedElMZavfCQZNvx8Qhu6hEbkw++JOZDRNiQ3OwIGm8FkmqKH+M4lSU5fAm14JGSjx
	bGQCD9lY65dyl+jFfvhPARQ0ssOn/k8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=R2i4tM2w;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772737673; a=rsa-sha256;
	cv=none;
	b=a30vUwn1nKm48+mDRtTMvfl29c2VTjPI5pNbfBYBY2BU95NMH5gIYOoYlIVkGCpGTIMGIK
	g2lAHUVCIwXCDWSB19vz1ql3bjiWF1SiuiCcmpqKP/GpFnUd25Rrbp1/N9djjYCUCiT/15
	3toM/GOD1obSzSogP/X1N6SiL2f3zEI=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-506251815a3so74578541cf.0
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 11:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772737672; x=1773342472; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p27mVjaEjAdBEF5GkfeH8SlV1G/ydclOHv0CwSzCIGU=;
        b=R2i4tM2wmV+teNGlXhVyv1Uxpk4AI/EtzSvCeo+7Tko8wjuzDiHcOGoxZaUis3I8Y2
         iy5hC84S98+kAqzvoQy2czVSd1v0LY8jN0UxpE52UiJlG0lFsh7PPkP4W+pKgx7HMcHx
         VW4XCrYfneuGpbzcpzgYjsg/5kEHOXOK6VWAjW7ybnSQX2V9almjLUQlRectm9xM6ERd
         sJvTnCfsoidctDKrYCM2YCzv9zasarcwq/4W7YAAd+8DtJkNRuSVUpg9kgoijJQr4oRT
         VAiF0InLQLXZuQpYf6BzQDTW1BDH9ckPB1BBLbTuA5FxT4M4mJXSdP/s1ZnTFE7jQmzc
         eyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772737672; x=1773342472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p27mVjaEjAdBEF5GkfeH8SlV1G/ydclOHv0CwSzCIGU=;
        b=WX+R454XzBQr68o/OFfEI3JkwoZiRGSanAUou2R70umU9LocYWeRtZOSEtMr3g59qv
         mcuGvrwe0xvX4jEt2m64SNhpItCwcUg24F33OEaurob88IEIhqVyjORClZ+LR8yhziHJ
         oEvemgLB3v428z+k0pPmWCL1wPICf+tTkxrcNdYq8fGCyNk/p506wqVLU7gImXbB/3DA
         6XtVi+TAzWcqVXCkU+tvOJz+ZSQYg1aTdehUnrohC1TfAW92SNwe0Dl1IDEXCJi43MS3
         17FzV8iHvJ3KBBwbPEK8H/hskkWxooWY2iTMd20aGVV6SNcdKUOtaRaBDM7yokmJItrm
         6O9w==
X-Forwarded-Encrypted: i=1; AJvYcCU8vYKULoWJ2JUINX5eQzF0iB2dbS18aaSbIxdk9iojDmASwYPmuXJyUJbaDXEzrOIRDmVJ0XYfNA==@kvack.org
X-Gm-Message-State: AOJu0YwSqyMocBilXXRaxva4uJAL4dgiO9Y4WvW+ouZdp5tPSTfi8ycz
	H9BYK2hwqtMmRLmLJHpi5jeu8yP3ocmIvsCSej5SR8ykP3kW7NcVqyE+QJO7UyInzXc=
X-Gm-Gg: ATEYQzwhL4bQlHAIPjGV8MYl5Ur77wpALr9y4DvNc4F/zFnRlF4QHw+age8M/66xjA6
	VH5JyMHUuL/rKZM99/f+kOAu0tt0AHrb8kxC9Mo5Eu7NR0xvX920QspP1s3CgLTRGG8LNNUKMj9
	blaMRVUIfPKauJXzrmHexuuvS+IDL0OUbYJRHsRKofl8ax6dmlJbBVOAAleZ/64dYlj3xNOFtG2
	GiGFJ3sbVXyslOSm1g+mDYVTHRXEC+lM/LvXTMY35Z2ffJtUGgJDX8ozdSaIbmfX+hAfwtuEc1h
	92+dK7GMx9/2uGmz07N7arlOHeNXeLbm6qx8jd/3w/LAGo+gOwK6aaXga6V4UdzNSqo/xOffpz/
	4j8XXdTbtGiCF7iwo3dE9wXxGV9wMVO+QQCaZCgm9n9g6oCjUXbo5gKELNYRffOu5z5QOhEGbVX
	JEFHyZjmEy41GlVYcjrOkJ/j7noWL+PZrVxwVWd7dWFvG/8/WrckW9knYb0/TsBR6f0yEilS9bR
	4yuqvCX
X-Received: by 2002:ac8:7f96:0:b0:502:a100:4054 with SMTP id d75a77b69052e-508db2aaedcmr88448991cf.23.1772737672031;
        Thu, 05 Mar 2026 11:07:52 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-507512559b2sm160559461cf.17.2026.03.05.11.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 11:07:51 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vyE34-000000077HO-2cQQ;
	Thu, 05 Mar 2026 15:07:50 -0400
Date: Thu, 5 Mar 2026 15:07:50 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	David Hildenbrand <david@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Huiwen He <hehuiwen@kylinos.cn>,
	Jerome Marchand <jmarchan@redhat.com>,
	Qing Wang <wangqing7171@gmail.com>,
	Shengming Hu <hu.shengming@zte.com.cn>,
	Linux-MM <linux-mm@kvack.org>,
	linux-rdma <linux-rdma@vger.kernel.org>
Subject: Re: [GIT PULL] tracing: Fixes for 7.0
Message-ID: <20260305190750.GA1687929@ziepe.ca>
References: <20260305103941.11f1b27d@gandalf.local.home>
 <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 076DC100003
X-Rspamd-Server: rspam08
X-Stat-Signature: 3tic6quh79wdxt5o8zg67ixpmhkai564
X-HE-Tag: 1772737672-85371
X-HE-Meta: U2FsdGVkX18idEeYi5puH8B0vaaEz61ZRP9DmYFj5S990iQyDDhrtpMtrpZVpqawnlGiTR3/1biRQZm2gptrRxdnH02iandBGMXNE4bQ9z256MpY5ZgJsK79lA9HuAQicZ61rW9tpbZpK+7tHZrPw4pwEbqbrnyLVyZSu7KXs8bD+FmUH9ZxH/836nwqDk8RcGmE7FR+PJsu8KdSfe0YKqDsAZEru29Ewt5w0GD4lYBeb60xJrMRZc84yXBc6w2ptA8UpppwKfNZYKMPHWvfBcs371B8fEUxvQ46ZqwQnDRRv1Om1y+yXuvUX/8w2lYsO8Wg0MFkp2ORAoN+yvC6s24bAz2iaCK6Y1RXBefD+eXXaCctf8ZBZSdUp4VqMIYj0rXCDOvDM4Y2VHLFQXmfQxKdtT6s+bv6M4yhUD8W0ptDncWy8tlzZvRLvf/0ytOHmfkkdXUGCvvCtnUp5v7KVUynXd4XnOrHCwNZJVe3xH1QSquSV1H3cM20mQyvQFzL0EvufsXId2o+J285u1oX6uEsUQcqRooczHC0bQB3C8j2pmvseGR7nQSKcKqgA9+f7x+F4MVYA5KA82MnMsSdvsJl+HWS1OlZKOuBOEc064EIf5OemY7wzEHf2wsOgtCNsMOLut5d1LuuRnKofgcbFMOS01TQA/LfseCG1u/XjNggY5fsXOfHeZNzpY/QNdHdFxt9z9bf/YdkXwRZtNa6EmlFXzVKXau6BIcj+Vt4pnzEdC+9C0oPR9Q5dfG27nSiHFIj1H264mXPE+7ygjiuThOWlfkhmb4duwE2e9BFS9U2VlW3b2xkLsI/YL1x74EmzK791p6Xi/zhJ80yEUVJfbVXwzmdeovUIM6K3mqMhz4dTNMBERCWi/o2JN8FPLyQ2Uyy1TgbZtuCqw465olzAWb5F3WFVjBiDCukr2LkNxdF9Yw4dGmUif4R8n0HnaRdf+XkOwyd/iot+A62Sjs
 NISNO3Pe
 65U5ms9mxqNxsOiDenJ+79vLhizJMeBH0eew903KKEP4iUw84rhje0M1MFZAmR10o5MpBln+LJnetKulI5kB+ulJvBmafz4NDwIhASMOiVwY68cIUHas6wbDr97MDG+IzDmEXLVIj5Tu1xkCFHHsJ+U3/+G4nE+MD8cPUEi9YcpbXGaIrZx2LNj/XX9HT/+PVgsfh5Vcta9SHblSuH2mMULoTpE4lf8SO46wxYLVLspectXnAxe3gt64pq/vNNjWrToMuh55S2oFZoZNIAyk4NM0e8gkdsn0zRSnUsUS1+G3kiH8vtzCoU6KMLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 08:44:27AM -0800, Linus Torvalds wrote:
> Now, Debian code search does show some users (libfabric, libibverbs),
> and maybe they actually want the forking behavior for other reasons
> too.

DOFORK in libibverbs is a consequence of its automatic DONTFORK, is is
explcitily there to undo a prior DONTFORK only.

This is because the library wrappers would automatically DONTFORK
regions of memory based on library usage, and then DOFORK them back to
normal after the library is done with them.

This whole path is disabled on modern kernels in favour of the fixed
fork support.

I think your point that DOFORK should only take action on previous
DONTFORK is correct.

Jason

