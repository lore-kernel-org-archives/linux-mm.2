Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F627C5B567
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE126B0092; Mon, 10 Aug 2026 14:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F4F6B0093; Mon, 10 Aug 2026 14:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E426B0095; Mon, 10 Aug 2026 14:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12E506B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:57:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90811160263
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:57:04 +0000 (UTC)
X-FDA: 85086267168.19.9558438
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E98A8A0017
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:57:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGjCopdH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of wei.liu@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=wei.liu@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786388223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DgHH11rbBugxycgVfllDqGnSiJw+pTYpQUpXBdKD4ec=;
	b=8otGcAwLid7yRFC5XCDUS2ffM5nk/2Sz56mbbQKa8UVZD0O0RevAmIhK5MhLMctpolpIC0
	IxGBXRq5IThdTQrVQ1XTofd9dvfE0TEMuplTd7ufL7hk+u3Ve2XZFYa/HLWanmkHVIoDMH
	zyWQmjFG2QvZtXRdVCIwX5jY6DpsVTc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGjCopdH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of wei.liu@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=wei.liu@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786388223;
	b=dTRACpNOBqk6wx/8LVG0hvxZdPhyhVWyIQQwfhknJyg7cgeyoKZ2DH/OgYE21oM1PBaKad
	Vu6DDk1T19sIEt0vhEa/LsjwzlapVSK9hFC5aJaQF0GTD3bamkOcEiRggbPlE1+vhsftgr
	xE4d6xvUQPBOOqpJnmHzZ8kFXWqr0y4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C2F6600AD;
	Mon, 10 Aug 2026 18:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937911F000E9;
	Mon, 10 Aug 2026 18:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786388222;
	bh=DgHH11rbBugxycgVfllDqGnSiJw+pTYpQUpXBdKD4ec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dGjCopdH5Dh+u5udlFJdn6uvtThWYmJaM5Eb2jrmqTmlPXe5UlQ0CRphwRoBIJAm6
	 F0kU/FDdk2naDL4p3srV/lxFnEfrV9izlK0/eVoMoRzHM6zEAlb9GpeWNPiLSHMibY
	 7/DPwPPVatxqKpZv+TfYsfmRCGlQLyQIHN6gqgSCuosDQKnkX7zFjgBI0zLwi3MUEy
	 whMrR+qxXWlWfsydnEdMuQYTG3VOiaRpdN8MxbYzSZLGHi/ErGFwHRXNVMMZH+h3LY
	 9bzRCWjMFzLk9BevIJ+7lY7vmKa9eVcOTLJ3LnT1A3hINcRRz11t4KUr+PC1fbqo0Y
	 U7y9rB8HQKU5A==
Date: Mon, 10 Aug 2026 11:57:00 -0700
From: Wei Liu <wei.liu@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Liu <wei.liu@kernel.org>,
	Stanislav Kinsburskii <skinsburskii@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>,
	Oded Gabbay <ogabbay@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-hyperv@vger.kernel.org,
	dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v11 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-ID: <20260810185700.GD2496954@liuwe-devbox-debian-v2.local>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
 <20260723142242.5d3f87208d47819d873ae458@linux-foundation.org>
 <20260731211728.GA3243658@liuwe-devbox-debian-v2.local>
 <20260731143733.6f74ec9b9023f898c3c260e1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731143733.6f74ec9b9023f898c3c260e1@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 4rgthgrq5csaqyu7h114nm4cn1ayb5o9
X-Rspamd-Queue-Id: E98A8A0017
X-HE-Tag: 1786388222-721497
X-HE-Meta: U2FsdGVkX1/RhVlalA7ZZyfefsVZGTERpuGnrmklULmJ5l5YqEelIIdylmq0nxU2Xj5PabiuYhi1jnCuOmenRukt6ZasfulhjHTcyjLboqPO0iKnOAfQnLf+iZ4xZ9APi8hfBGBBEh9FK69pllje0UfbpedwmE+pHT5tI6MDnlgP6RHt+L4483YRjYw4pMh3JY1BY0it18oSLkrmfF0hI7OQhvLtFoVeIctGO6IZsMll+LkK20969g4TIVgpoPcczOm2Ukw/IHSWPfqHiLdF/9USa/5douOjdfFIWFhVplLE05hdvYI/L8OgVokBRhklRoW5efnKy+d++vggz4v+lrP4KyGnE5Mw7LmqDKQASdVLX6DJ8NnMsxrEpaoRjXco4ULyh6EkCkI8sEYRMgshF5hS3yhHzfO8O1JxRN7hBfJu2fv/5SSalSiUy41EOiGqKeafElqgprU4y8QeuFsvg0kWEpcQ7UZCQsbeoJ4F0Ifw/VxQjn05Qhk4A0ztpXBxdKchcbLPqnfkI1itaDamyT8d3eZSz+/e/HAP5jOuDwE4ww2Nkn023b+qsd9oDYnpK9+bPip2PXINmzngNfSa9PCHjSGvSog4hv628yUKrgS/wwxbODMYFcglaQatfG2rKU2L6DvdbcPQE7yc9dC5rx2eFGQLVhKQCGySKa/FE0CQiQ5s8kGiQdrEXapsN8/hELx+nJ/FcCHTgYA8SovzTMeYwPcfLjGTDFSYT9nWVU5kIErw8nHx3S0cOu2mVwvKHfG8NlMriAi7CiEYx1ifxZHuiZ9dTCD2ouArrbo7DtbsmKtkV636Nt7TDVw+kfctYX1vZPGHS66nMkES21s1tqJoM/h2GzOApg0Pf9ec8Ossnk6x1f20cSYTzQS5eoy96oqpt1+EOQKxTndNcEdvEJxxc9pHCOOk/+ni0vgMgjtTvl03pxnA4SmNYgZ7Jg+C4q9M1aw99IMrZYnNxFd
 tis803J4
 YgWaTgRTXctm4SNjk8v9olMoXUnCEPJ8T6cMRfqD43+sbVVSk1JktXRNwGlC/2mDfAWqQ9n1oa3+kh+Unoa/SM2jhk2FpNfdFidWEnxF1FE4X+sRROypzPbhv4L7cTMEV/Qmq9+gdpOpgfQ8tRWQE3aTGxhGqf5PsMukL2jsmGzUaHIXQrfTXkTtSSRqLY2IcXakQb4JS2b8Va3ObcLvWPSkFA+H1vLwphzCPVSRlrPHbCDQFTHS8aIa1Exe/Bsn0Mbvq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 02:37:33PM -0700, Andrew Morton wrote:
> On Fri, 31 Jul 2026 14:17:28 -0700 Wei Liu <wei.liu@kernel.org> wrote:
> 
> > On Thu, Jul 23, 2026 at 02:22:42PM -0700, Andrew Morton wrote:
> > > On Thu, 23 Jul 2026 10:36:32 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > > 
> > > > This series extends the HMM framework to support userfaultfd-backed memory
> > > > by allowing the mmap read lock to be dropped during hmm_range_fault().
> > > > 
> > > 
> > > Thanks, I've updated mm.git to this version.
> > 
> > Hi Andrew,
> > 
> > I see this series in linux-next now.
> > 
> > I'm curious to know if these patches are going to make 7.3.
> 
> Probably.  The series is incompletely reviewed at this time.  Perhaps
> you can assist with this?

Fair point. I'm not an MM expert but I will try.

Wei

> 
> > We have some work that's dependent on this so would like to plan
> > accordingly.
> > 
> > Thank you Stanislav for continue pushing this.

