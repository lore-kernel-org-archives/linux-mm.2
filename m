Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11284F532D0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 04:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EF786B0005; Tue, 24 Mar 2026 00:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CD576B0088; Tue, 24 Mar 2026 00:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCD96B008A; Tue, 24 Mar 2026 00:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA056B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:40:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 933828E9F3
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:40:36 +0000 (UTC)
X-FDA: 84579705672.21.4563184
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 090CE40008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:40:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L48eLu0g;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L48eLu0g;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774327235; a=rsa-sha256;
	cv=none;
	b=LNapwyrB7il+PWfmKccKTdq7wu/vYKEHjED5SQqW5v83wrPmwCdTVU3WERtEn1Q4ceTvdd
	GhuP7zSyk2OkrbnqBmnrFk0MDDqSTZKXCwfeWnTTymKMDB3iZwAwbbkUTUnrKMGod6bsVS
	jBOdz0+GIMvHZxwMP3OfW04sAbYjE5A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774327235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8mjrM3WmG+NESpPVoYjXDxTQ1lwJERl2/2s7QDtmWU=;
	b=mrOJ7nuV6B9+svl9UCSDId8nSd352z0lGFpvvFglr9zcMLxoe8UZa4JbwCpxYxy/mHgPUu
	i6oPIUUCsPE28mOw0+iMeWqrbtxGP78By6VXRQkmOhENvUYfO0tH/8THeuiKT68sK4yAb1
	ouxkTihVNR9KVevnux5tfQhpNeyHwIk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C401600AC;
	Tue, 24 Mar 2026 04:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADAFC19424;
	Tue, 24 Mar 2026 04:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774327233;
	bh=loPaoIv+zE5Iyk/V9kLFJDEN6F+Lpy7F7j8B74xqzKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L48eLu0gsNzfLk0cW3B98uy4zM9DenEhROjLupQYl9xFPWiTdiLoUSngK53UkWjyS
	 Y3B0ANxOVzenZ2y152NVmyWSE0FWD1GS/5ZYaBve8kNsU+/UTxnxKiBP+WLuoXJ8mN
	 Gzupv8u57JfHU4irjn/z6tdRQnILxm3TU1U38z8aHl9LxmA7AOkpKA3K8NvxfGq5q2
	 Azp4IbwudUo2+aKucZQyreoTFFAIb0CIXNiBV4ZRpz6z3PXt0Z7fNRm4sO2Hbdu8cI
	 eLLMOTyem2zEHLGB3OzO4GWDSr2+z8iY/sQpqFFfcEeO2Ud2x6kxrQKVNbxLg7US7W
	 SoZSWHFPVHbzg==
Date: Tue, 24 Mar 2026 13:40:31 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
	usamaarif642@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v6 30/33] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <acIVv3Pr9FWwYuwB@hyeyoo>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
 <acDxaEgnqPI-Z4be@hyeyoo>
 <2d39ea5e-fd69-4acf-8518-a504f5f7a838@linux.dev>
 <acExNWaaKdhrBH-J@hyeyoo>
 <c913ce46-bc83-4d36-b1b0-a51b12e515e9@linux.dev>
 <acINdWKdH_b5LdhH@hyeyoo>
 <138d9363-ab0c-4f5c-bedc-b326f5aaee91@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <138d9363-ab0c-4f5c-bedc-b326f5aaee91@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 090CE40008
X-Stat-Signature: jxatzp3zf9abgn5ek44ei86pxhce1crt
X-Rspam-User: 
X-HE-Tag: 1774327234-315493
X-HE-Meta: U2FsdGVkX1/+CK8gEimPRtAlY7pBsZEc8GvAuepe56RgZyG8lf4ZcJVacen27Jcu71ANWvNIEqy2tD50NHPCsl2hsApQanu78Vt4gCh4ySDGbp3aFfbpk7bgWhPhEvSxrFSfV6hGpBUuf/+4eIpkgV33nWNDXZPD+iVpmqk71kvfkLcJJ6E8j6on8m04/vkP1n0kNTDmtpDUi9acbGPtgdyoESUjqWip8+9tYI6QJlz2IsNslTlfgSS1x34Vuj84JYZBXwRiJAjirf64sDXmgEfLH17mkQrUioCjY3j72gZKshDuDpv/C5FIbwsiTjF8hjB9XVblcJOV7XDHK+7ySYdUiDEdDRnPV9XK9zed5FKO5dkFMmirhfzOcqDxvsHhO0KakgaVRTvnZ6QBIHlFuzQUCwWWoeLw7mJhjYjvHWpSDtR5BnDvntAsxxbTP2eSOd6KEJdJEEXpSNpOKm9SvNugaaYEwObtsOKu3TWXC/Ck0XPT7gqF0chohexpQJCmnypAOj5I+TLmIaajjmvsa74V8LA1ROZ1pbMguS1cFV14RhgyczVyrd7zZpTxEkc2JZFNsNUsiBC8mA2+/cG+sWaOq4+BYCAyLnWoLxgILlR4luWPkVtQ+OODv88JuFwV7vieF2DdX818UdyUCJcWMiRkacGg7M8QTu4rKvbmoEWPDpM6LVAzYtdpF5VsBsJFZU7M0So/XRFn1m/bhdsSHSFWmcs1aDqduNpFz6aAvFAB5Hz5RnKH34sD97L/FII5mii4pHNyiDtPasJX3UpeVhgsgmF4pn06ZX48QDfL1LMHMCq7dOEh9twqMYMrJ/qpEi2FcPiaYOpAUaR86sfLc5W8oRuHMALttVybV6LxFzs7adEYyzkz5Lq8z9jL18Hedux/vxMr/wXPlX+8CLvfZLUy5IOXPG3G0NrK+Y0REaIl3+K4LAT+jQBU1+pHnvXtTt9INccGwXr4VAqz+jC
 mGVR4VJx
 +YtpqKEUQbGy5YVwCNkMbskDlSkIwYzz3b1hRI/Ju1j0hXPmS5tHO6NtAs9CMrZafN9heblFlz5x4dZ2WVYM6wJJLcjny4DM564hsRaDf5bSlZ4bRfEy2iE60alFyKJoBO3QY6nJv2z4Ddqup+bxY2KtAg7TlGh9X4kFywrIa5QupJz8ywi8w8kDdPE4GwwcOQptah8yTnYN+kAPLEu/+CSMX0QENupmWBFh1LqxhglccDXkBH9TKsSUz6mTTi5wTD0cIR0kkQM8KGHuiqoHlQTo2WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 12:25:16PM +0800, Qi Zheng wrote:
> On 3/24/26 12:05 PM, Harry Yoo (Oracle) wrote:
> > On Tue, Mar 24, 2026 at 10:54:48AM +0800, Qi Zheng wrote:
> > > On 3/23/26 8:25 PM, Harry Yoo (Oracle) wrote:
> > > > On Mon, Mar 23, 2026 at 05:47:27PM +0800, Qi Zheng wrote:
> > >
> > > so I prefer to add a cleanup patchset to
> > > avoid interfering with the merge of this patchset.
> > 
> > but it's a little bit more than a cleanup, no?
> > 
> > I'd say without the followup, this patchset introduces a very subtle
> > (likely nobody would notice) functional regression visible on memcgs
> > with billions of pages.
> 
> Right.
> 
> > > Otherwise, sending v7 might be more appropriate.
> > I think it should be sent either as v7 or as part of v7.1-rcX.
> > (Whichever way Andrew prefers)
> 
> OK, In any case I will first send out the cleanup/fix patchset for
> everyone to review.

Sounds great, thanks!

-- 
Cheers,
Harry / Hyeonggon

