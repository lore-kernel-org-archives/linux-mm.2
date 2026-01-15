Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D46D3CCAF
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 05:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1FB76B0089; Thu, 15 Jan 2026 00:59:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F014D6B008A; Thu, 15 Jan 2026 00:59:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF63C6B008C; Thu, 15 Jan 2026 00:59:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF7946B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:59:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E69BF1601C0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:59:21 +0000 (UTC)
X-FDA: 84333145722.10.4D39C68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5C373A0003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:59:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AGoi7q8K;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768456760; a=rsa-sha256;
	cv=none;
	b=2e/LYBnHdi+a2nd+F2Cadtq/AnTsefKmpF3eCNP/pEx3SqpRPelgpWqz4wzW/arySn/7gU
	u4Sr8OgkCfUaliM+aUXpIT5rH12lmeiLR9n4d/VcQeAYEcSGFc6bSD2MX0CyOTk8T2w1c3
	txJ/sC6WddDKrSN9QJH6d2wTFUezYqY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AGoi7q8K;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768456760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPeOBbGjUgU8hI2afV6Psuceb47dGgERhJjhIDKJa+E=;
	b=uOPhgOkz1Cxs1yXIWnkCShdCyuIjh7Vk9bCLyVHmH+RWXsHBmqgpezijnhcYOLP1zZXoNr
	9cVAuP08CTNovWRGPySROOagFS3FrkmyruDpgn9e8TPw9xaAwzfuUJKBOF/TwIv3v2nJ+X
	FiU9hNTHbLm4+z4iJznOOmvtsG4OHxQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 005BD40790;
	Thu, 15 Jan 2026 05:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA83C116D0;
	Thu, 15 Jan 2026 05:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768456758;
	bh=WaB1WfcSyPRy13gJone2ay7mYx/vRaB7yTVcyMuNWD0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AGoi7q8K05EyGTE0Hdv5rTXzye2UijvczBaSBIK5VLU/5fA47DnK09MaTwimMwonz
	 4EC4iUpaoSchwE6AceY8N7D9sUEtMLD+noQaqZ/lyqcenW95Y6slunLW0vEGC/B54b
	 K/+k2KHaucsaCGfgumma9d+s8LdgXkUj2RdbQ9Mo=
Date: Wed, 14 Jan 2026 21:59:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 00/30] Eliminate Dying Memory Cgroup
Message-Id: <20260114215917.8eee7b9fa4da37305b74d6f2@linux-foundation.org>
In-Reply-To: <98819615-5001-45f6-8e63-c4220a242257@linux.dev>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
	<20260114095839.eabf8106e97bf3bcf0917341@linux-foundation.org>
	<98819615-5001-45f6-8e63-c4220a242257@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: eocpp3crbqexiqzuwox8juba7a3i9nnh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5C373A0003
X-HE-Tag: 1768456760-965070
X-HE-Meta: U2FsdGVkX1+ucKz27MXYMEU6stI9q51uSVn80cu8e+PGVAHKbDGLs33fF5ZSKwlGK9PYW9zuZ/KEVQUaoYDOOOvWwcIMuXITUX8FPicJ7K8VZeTw9Oy4fNNVCSr1WP9P5XtS/oJc/tSut/u5UgIlsCpDSP//vXx+ghQoRyOe/ibhsC58T5g/YyMDmB/iQi9XhdBraQgA+HFBeRnkE7z6vCoSYld6D75zQTB9GBxn5ox1ZGSqtfGDM4+6JeFn5L3i8PmtAcWe6ClMS+YGh/Ekzb5IS69cc3EIDpgXLn55n/Bybw+vGKs6w8cNuKrWApXRgwfOfCCpB/J2bY/JuV3xc/QYDe8WzmxdYF/iczfbwevLnl9ih9IF9DSNmT00tQztJ+mO29ZuV+FYvN8sQX3Cq8lFTXIF0bQAYzX1BdMYunQxztc84aAvYnzNsseaLh2KUJ+n5RCqSTJRDuwvXa05uFLa9zw7fkQomPlG4SyM+/PDDr0PcjEHd8jqB/KwEjq21qJDhIRNybE2/cBANNoPh/QNehpQl4tFLsXod+/h5ARzsHMBSUnlWs7Wmc9bUiOzFiS76CyczaaawteUxCmEA/J3kzYbWSDswjFuuU0KFCZho4QfAv1Fp4Y7HzQkvnfphvRZBWmYumMjmi8iVYu9BZf5Jtw7QP5S+z3bwFv87PuUXMfYl2aw+1Kavl6h3WID+BgCBwLJAD2ti4BZ2IG3Uj6sydLfT5kh2/IAmMsM54aCE4Zy4FTeGBONCwwnycZHCtCGEVzFDBjyr93Pl+uxp0zXBDs0Y6q0El0A/W4d/rV+ukIQCdNKJbsz3CkGj4R0GLYynDA8mxpFY876/kbnhm0Eseyp2e72Y5nxVT6xB+WGoCXP+/hozc2Z43qzwPDALtk9rl7XOkRSXwAZEh++sPr3duPgYYMDZpchunrpma0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 11:52:04 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> 
> 
> On 1/15/26 1:58 AM, Andrew Morton wrote:
> > On Wed, 14 Jan 2026 19:26:43 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> > 
> >> This patchset is intended to transfer the LRU pages to the object cgroup
> >> without holding a reference to the original memory cgroup in order to
> >> address the issue of the dying memory cgroup.
> > 
> > Thanks.  I'll add this to mm.git for testing.  A patchset of this
> > magnitude at -rc5 is a little ambitious, but Linus is giving us an rc8
> > so let's see.
> > 
> > I'll suppress the usual added-to-mm email spray.
> 
> Hi Andrew,
> 
> The issue reported by syzbot needs to be addressed. If you want to test
> this patchset, would you like me to provide a fix patch, or would you
> prefer me to update to v4?

A fix would be preferred if that's reasonable - it's a lot of patches
be resending!

