Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1493606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 21:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Fbwn3Tr+
Received: by kanga.kvack.org (Postfix)
	id 056686B00EF; Sun,  1 Nov 2026 16:50:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02DB96B05B1; Sun,  1 Nov 2026 16:50:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAEEC6B05B2; Sun,  1 Nov 2026 16:50:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C90856B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:50:51 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A68E1C4511
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:50:51 +0000 (UTC)
X-FDA: 85387895502.29.4F0ECD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8A18240008
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:50:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Fbwn3Tr+;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793569849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rpLIWcyWHAMoTm8HDUZRR/yftBEok5XqQa7jTiyf8Q=;
	b=Vlwdgj68QVicZ9TsaIv02vXqqli+p4dGo4sGUI+hiXdrYoN7fFcet9u0LtzIGi/bhiruWv
	mx5I4zexT4G4LQ9y1Z4Z+aEGTVMOyl1EVnZSdYM1Lxdl1yoazvpGcs9aNJwuLyv1fhw+j8
	MLwmcLVFoCsk0r/SRgA8SSLiRF8k35M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Fbwn3Tr+;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793569849;
	b=Fqvm7QuyQ40oMp1TG5ghotuy07KaeGAXaV0HiCCeCRdplMiCN3lLVdUDZ1XLpd46BgakV6
	XF+IIJNLxmgKxBDVTbXasU6ctpIt7XO1yR3rtkYFL1nZ6Rdjlib/8od7YYhvt6xUde9wOl
	VxW/LGfOmih6qw003V3c43UPcRbmJu4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2198601FF;
	Sun,  1 Nov 2026 21:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8C01F00A02;
	Sun,  1 Nov 2026 21:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793569848;
	bh=1rpLIWcyWHAMoTm8HDUZRR/yftBEok5XqQa7jTiyf8Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Fbwn3Tr+FrE2+twWvc96h6eL4CmfV+55YRhlwCU67jh+2ijXjc+sS1d6Vs72iSVnt
	 9pThhklCkVEpSZevtZfIcg1fa6R/6r51jf56V4MNhNwT1CtWLVsdiI92zpPMX2BsIT
	 tczuWds92tQZEf8i+WAhNaHBo8mIGCmU9QZMuCAM=
Date: Sun, 1 Nov 2026 13:50:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [PATCH 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
Message-Id: <20261101135047.61fc3f209b3235ed6fc96183@linux-foundation.org>
In-Reply-To: <CAKPOu+83bH2CRtiAio+1VTTQrYFF9th5XfG5wL45ujEavPS3Dg@mail.gmail.com>
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
	<20261012205447.2717801-4-max.kellermann@ionos.com>
	<a64f6a98-de70-4004-aac0-312cb05aaf92@linux.dev>
	<CAKPOu+83bH2CRtiAio+1VTTQrYFF9th5XfG5wL45ujEavPS3Dg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A18240008
X-Stat-Signature: gbhfsjieskidm33cusp3kanfk3bawy13
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793569849-539709
X-HE-Meta: U2FsdGVkX18SlTXd+3BMHECKiVk9QSkUfiyvfLkawwKMU6M0XPOGLn2WHbxbtcDvlk7Id0NDgZcGCqQucFF9I8zPkwVULM1Ds7gcRxyQt/shZC8pOKV98uDhQWSmQ7x09QxZcZpQe4OW0AMZ9cVg6CGuYBJbUq1HMNaiN+iAdzBZ3SW60UERz5bT+lT3p8ZQ/hACT5y4AOAW6YBf+4XTJnIewmzxiWuBd+84t0IUU5yvP6ZuKDIDnU9aHcNcQApRTKML1IDnoAKvOJsFt4xwIAo9wcnRxbiG0FiwdR2/wIHborfHE6bq6N5CH3W5W49ujpo4R0U6No+wjIwvl02w10IQ9NfU/WBm2ylyCQUmzPAko253o3lGXHXM4AYVO80GFZG6NEI2GdK8nmJmYBM8bTlWK8c3o9xac0NwziBvUSAAhA4oRDJ8J0zHU+++hw/ZpqXsXyCf4u1zHgvF277LcIPIJw58r2YPTISy3lE5DYpFHw4fh+IwNcusaI3QEae4hPcfhY1lBJBc/XMaiwya2prbIi/aN2BQCCYE6T0jkfN4Pg0BgsWc4839tozmP2S0CrvXEPaEWFat0lwaVGzwStUvM8foNyU2J7HI55BVxbDoBIxIUac33A6VLjsWZNDEbGxpDVYqYZVy0Ux4+Go+f3NXlYjtxbT6wkGR8ZFDxMQyK4Xv/0fG2lMD6QXJuc0LRdvnJUdw1vx2Y3nNfbwCQxruX5Zv+DtPXmqK1h8Wjn9pJfYQ9e2tAnao2xnAWsslBVvxJxKZvahmbLm7bMALDdgVAxXn9WHzREWk5tPri9bGj6+Pia54cS5lr/qHajJQ/f0rjrwNq8hRwg7nmOBfoQQFgzdWqeArsRc9BBpNgUYr5OASH9N+bRch4iI13MG3X50Fu7CSms0rbz7Kk8Ud4oHEenwdHbAOz4xweLSu/KPJzH2esJsDP2gPHrHZrILzOvDXJt+yAZOLPBWws9v
 VBMPzY7Q
 DOK305xJawm53Uba+yreXOmcM6tH+hNkk0W3iHeeXtmES9C8yKFSTjl200k1u03axHOcXLa7AhFYut1+AoRVZj+FjTKJfMH0pyKYOA9xE0tJnZQvVwMNj6YqwBHBiP4uK41lACDX6Un8FN4NoxJXmS1g7RhEEH/L2YBu5bC6UZXxm15evHXLw79sLyqJWbyNki2CO/X4XMF0sknh1HCkS1rb4wP/J6UvYxmC6sbdLyR7rpLVAUmgntZmXRjaUpdVN+4WcjzJgL+GI8foiaOcxGOoDebjI6+Mzo9CraSHBURZx8Rkvy7Yrd60sl3DLO34gjtK5ue/7pcI/6lCRBu5kmjKdCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 14 Oct 2026 05:58:28 +0200 Max Kellermann <max.kellermann@ionos.com> wrote:

> On Wed, Oct 14, 2026 at 5:31 AM Ridong Chen <ridong.chen@linux.dev> wrote:
> > I've also submitted an RFC patch that addresses this issue.
> 
> Oh, interesting!  I did not know but your patch, but it looks very
> similar to mine (but without the hlist_nulls refactoring so yours
> comes with some code duplicating the hlist_nulls header).
> 
> Too bad your RFC went nowhere, that would have saved us from a
> production incident...  Anyway, even if neither gets merged, I'll keep
> my patches on our internal kernel fork, because they do help a lot
> with our workload.

hm, this was a bit of a fail, sorry about that.

We had a fairly modest RFC-stage patch which would have addressed the
issues you've encountered in 6.18.x.  That got waylaid into more
ambitious re-engineering project which wouldn't have been backportable
and now this series which also won't be backportable.

So.  Can someone please propose a nice simple quick-fix which we can
backport into the -stable stream while we work on the larger
rearchitecting projects?

I think that might be Max's [5/5]?  Max, do you know whether that patch
alone will fix up 6.18.x, or do we also need to addressed that lengthy
spinlocked tail insertion?

If you think [5/5] is sufficient for -stable then please propose that as
a standalone cc:stable thing then we can look at the broader changes on
top.


