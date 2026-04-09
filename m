Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4272FF31E42
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7546B008A; Thu,  9 Apr 2026 11:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7782A6B008C; Thu,  9 Apr 2026 11:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68DD96B0092; Thu,  9 Apr 2026 11:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B72D6B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:47:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E90661B8A74
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:47:19 +0000 (UTC)
X-FDA: 84639446598.14.1C6D752
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1786314000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:47:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sUATYZCA;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775749638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbfSbjGpP5lXm5FZZo5hfk4UuxdTikb0ySWEih7g+f4=;
	b=M1v4Yjdz4hEubykWBtNW4h42lXX0M/oY7Vavp4URaaKjrQdjL6DFckfdiWqktOsfJmkAmH
	x4Iya/E5bQO69o2AXhBjDIMl6uWZL/Wo+EP7r/fyuWTcMPZmgBmneXdTLNc9w8SirZqUzD
	vaBh2vtzev+X4dgfbnAZpVhuJh24Goo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sUATYZCA;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775749638; a=rsa-sha256;
	cv=none;
	b=FKEaoeosY316J+MDXdcpA0aDnWcyVxpb4vbPogDsOLK9B2eZCSbZmYuYW/HIuUfKW3UlXt
	lrPUpFrccxjlxljNPyIaKxL4ysGiKqy2pY8jscCcLuRrUYrZ17WOoAYIQkBB2lMMFQkm69
	N2kHp8w4c9DFrIr+2DjH7IFNx59ZKL0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 093CC44462;
	Thu,  9 Apr 2026 15:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DD2C116C6;
	Thu,  9 Apr 2026 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775749636;
	bh=yG9UbbMGeM+YQuacdgn4jctWS7O1LoAP55d/mSf8ZVs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sUATYZCAwQXpTSBibLbcWNOYmJIk/HMzh0aG/AqTfeZhF6N6gZe76YUcdl7DVPSn/
	 /qMswAmmQ8gRiC0lKE4J70ArQ2PQK/bs9D2uhtNbQw9IFQSlQ++zQcluEZVsiP2ATA
	 dYKa6fPrDh6kzVAprj31aGPo6jBqLMvo1zS2lKcw=
Date: Thu, 9 Apr 2026 08:47:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Christoph Lameter
 <cl@linux.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kas@kernel.org, shakeel.butt@linux.dev, usama.arif@linux.dev,
 kernel-team@meta.com
Subject: Re: [PATCH v2] mm/vmstat: fix vmstat_shepherd double-scheduling
 vmstat_update
Message-Id: <20260409084715.44d6ed4df7e092214cbefa90@linux-foundation.org>
In-Reply-To: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
References: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1uf3fw9pthezc3j7gkmtc87pq9r5s1pk
X-Rspamd-Queue-Id: 1786314000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1775749637-330727
X-HE-Meta: U2FsdGVkX18aOgu2QO4yCL26W5QPnsKxDIhAFE1FXW0Kc4XkEz5UQfhJuXRyjlJ638gRXttEb4398XFVq5aAchHkIk6vGLyubSj9z13Hrq2frWrkxPslWUaeVIOgg7ziKc9WNH0OgfRL446OO1pC64dVhS2SRuEQerEUoMFxLVzENNhEQPHaULuMoc8vIWLnB9NuOsFNk39bA2NLLAl5ROtl2aBKInTQfuxkSU3g2e5WABfrYagZfk362VWVqXEwyVf40Diws+itegoegpDpo+qgJRMlRHw8cRALZsxSHFCAoxqrsRqQBfWI9gdxjBzrw4m6OS9F+vSpD7k1DNk66iwiNWDHnSwnWVDrcxd3Vk8nSKdeZMBUU0je29xfzvz+17iqht2lvQwmHn8HrZSAMX3Gj7Pjo4aGsHatbFWnkMFMCcKW7u+othEfbrMtIsMf0fJszlE16XRAK9VcstToTqaHNWmOloQ2ln3WYHcE/7+6yvE7mHhub5ILKAnGFUGG8+FIKSHh0/O78DcXQswlu88CMG9H37Hsrc6co4ct75UniXNjxYDTtzqTDeo3lzUqXEInvADtJh6hei5LgkQ7YCTOsjbaamk7noQ//8ryWWWiEdhV/e29Rt3TmvgzAb/hcfH/7YDeuOk1xyYgqNW4U4uH/NTz/rYTGPRIi59G4rLU8RVHOGUFrjQ3KLhwsdmT0dd77LH2IsokD/7dNdSr3DFkqZoShlfiPQHA6+2Y/0TGweCVvcMvet1dSusJN9Np3ofwo1fvRCNBdtzuxNKjb+31v+h1miGv6I0VDavuT3UgmEoSwgi4KLngK2nA4jgTpcKg9CKlcjTwnFcvsoKSoN9A+bokGTZEfCgoi6jYOq/5BNxT6+cyrG8aqQodOwCQY73DVLGnnucwqbs5sex9HHdAlGohZADcYzutw8hYn9ZlmdMRB4fjzuE9x7O5qhnbMrA6ui83LvRLI/EMvM6
 14CY/Hyc
 pt2ir+EVYn07QKhPK5bvrlGnfJt1cTaB21rVpBgmWYyh8y5Rngufi0PKIPPmGZdF6bBGv4unAmMt4tDlN+rb0FmCK4rQMmHLSyZGD5T1I9XOKoFUC+JCnboF/MdR7tbY2AkcFTT1EwazkvzdvVttGdNof2kTWHkc954LwP8ir+cYh3LM0KhCLyoIx1Hmn4Jkn4neEC6EXfLnF2k4xAXta3A2bzGN3SWe64N0W86QCSzjMNncHcFc9EXd65tbt/YYAcDDt/acZ61ZeV7VVP1FTcHQY3+oo4Anji5xZ2kJTuACERvkO1Zj6wxuqc3ZTqmu6JzDF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 09 Apr 2026 05:26:36 -0700 Breno Leitao <leitao@debian.org> wrote:

> vmstat_shepherd uses delayed_work_pending() to check whether
> vmstat_update is already scheduled for a given CPU before queuing it.
> However, delayed_work_pending() only tests WORK_STRUCT_PENDING_BIT,
> which is cleared the moment a worker thread picks up the work to
> execute it.

Thanks, I tentatively added this to the 7.1-rc1 queue, to upstream ~2
weeks hence. 

