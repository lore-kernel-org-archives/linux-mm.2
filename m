Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84DBA606C40C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=caGB6z+V
Received: by kanga.kvack.org (Postfix)
	id A08996B05D5; Mon,  2 Nov 2026 06:23:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E07F6B05D6; Mon,  2 Nov 2026 06:23:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91CF16B05D7; Mon,  2 Nov 2026 06:23:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF176B05D5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:23:51 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A26E1A0CBA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:51 +0000 (UTC)
X-FDA: 85389944262.09.7C617C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 73584A0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=caGB6z+V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6NfCHnVx9kytp3OhQJ7dq15Lhd2bRs4v++E+zqaDh4=;
	b=bU+R7NOanXcaqY34ZzfS3mv/ocYzbwm182P23j1vir9L/XckJTPPrqNBB99TeKVepFQvs1
	u5vz6HD4eBNCfbNi52YJM2jmVdEAoNvuWH4/IOyfsLznehxIG3HNnGK62kpUbhBqYht5v+
	6Euutc4IahyvqeU2DSxvFZJ8Vu6BtaU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=caGB6z+V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618629;
	b=rXsrIiNEA4bfefV9zcNyfd4SqMs8c7FRbpvVmz3DCWaETnZNoAv65g++3WdmKJygvta/Xs
	odulICXi8lRL/PMukvZdwNflGwLiRr4F3HGZmnOA6BnjDXCl+kC4PG9R3846zYiI7eI2bP
	BmWckT894eQBC9HOlr4iS2YQGX+YZD8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9937E40A36;
	Mon,  2 Nov 2026 11:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4149A1F00A17;
	Mon,  2 Nov 2026 11:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793618628;
	bh=n6NfCHnVx9kytp3OhQJ7dq15Lhd2bRs4v++E+zqaDh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=caGB6z+VcMlU0pEGChtAWc15s+WU9ArcVv9YatmCUi8uxOx3lVEPKgiy8v/0qiOQd
	 uuGx4N4CrPIdYuShMm3MgDqO0KfP1tOzu72sWRYLVbVZ4ZTJ+7fj2nmOwHFwCgQhCr
	 embqWcQJKQnvvi3DkQSTBfoTNJa/Rc8ziZ15Xlc7UlspvmTCzoFOUHd/paznqwBFYf
	 GlAZ3PbmZTrqASpg2gFC+V3CHnlmFOPxFZoKsGrpbgtQmhbM0O5EiV474mltPxz8wl
	 Y4UkFg70o8tuSsDAVOOdwm08fvbyXTxK/KEEXXGM1FpdMvrFN2kt4AnUTwB/+YJr0M
	 lwawhQE9bPO4g==
Date: Mon, 2 Nov 2026 11:23:43 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zhao Gongyi <zhaogongyi@bytedance.com>, akpm@linux-foundation.org, 
	xu.xin@linux.dev, chengming.zhou@linux.dev, aarcange@redhat.com, riel@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/ksm: avoid anon_vma UAF during page merging
Message-ID: <auhyO_ZZ5fFYvjOi@gremlin>
References: <20261031182256.40205-1-zhaogongyi@bytedance.com>
 <79820b33-7e74-4e12-926f-1e03987d7bda@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79820b33-7e74-4e12-926f-1e03987d7bda@kernel.org>
X-Rspamd-Queue-Id: 73584A0007
X-Stat-Signature: 6dwgequto5pakmhxwjj593k1fobmse6n
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793618629-746937
X-HE-Meta: U2FsdGVkX192CPMHKTPb5+bYziI2+bPXIbbJeUOrVBVVgaPzDeuCfW+sKGIIT30WQsLZUpGxwP3OQAwyG7H8H/1JClmyzLQySn4boH/xHRKFtUOzWnuW5CxRtrhtSYaUBmbWdgT2Es3QAnVIe24OVT/FDX2c9ukb+lJ3eZiGyVHJlGobLtwuj1NVDWy0H8tHtP3SoT8rytFlqcjFqEKemRknrUE2l72KULLpvi2losJ0eYFus6twefW3CF4t7WkeWYb8V6/2QQk1bzJtC4XFsPA1fBPvfHP1pR8rqdKkxykRirzPcy3uF00n2A4pLxGm3uyV5ycpbY/1gy4uGFoEpQByi7b2kmhSq4QsqTpknJMuGLcNTTzEk4SpccDKOvf1xEwsSSRsVMas5GGeqHP71XXuRZ5l6aoN8sRvkEb0TnZFbbHcyZGNo3EJ4S2vutGEUwvdSE3Yj0W2VPfkhMig+KnAqA2dgtWzK/bg01zWxNvzhu7UiE4+LVf9kSag5q8INsn0ZnQMQp+1xH6zkWgwHO6jjnNLIp0fUtmUGvl3blMRa5h935lXa0+3OX4iN/uqLMw3tvPLmkElFH9zRBkfsp2gWTz15CMKwAoLQoiUPHlYQu/RMrGo4T5Tw7cl1aH39w1gBX5tdBQnM1omlxEQwdRhf/vyiWPV2Fqx/xdK+/it14OSGUpfLyJN9CyHTrWZxn3vgNOS+7uJ3G/G0GlNTWX8QCBZNSO++thXGg13j1ERkdvsgRDfARcm8rhm4JQ2QwfULjy+S9YZXJgxiw77xr6zI+cKYt23lV5UEFKcD+pSOfd/V2yI46IcC8i9dGuLrf0xmkFA10OP5mDYjREUEqhyfpTX8YBtyH2HVVPx7fUN4sf+5WgLImhHB7LezxYqiwfkZaCxNxq++cAz8cgGrDk3elY+hYHhN0B3/x8ewPaEBZuTtfCs/1O/Xdm6HwrpgK2osZwNHmUVZV9XsQT
 LlQ3kWz2
 d32xn7qJYscHciXCDDLFbGO2u7QZTU7p9OAVh7VLToNvu1oqa3OU6ctPNmHubJ5spgJ1qsQFYLz2KgseqMwI5Td64kcXVSZg9cjczgochY4jARFQ080es370tOLLHYg6u5TyKE6/8z+jxkkBg760CWAJtUdZO+kuZP9iGazurxRoompRyeuOyYjPsjAfRjXIo5Ntj1IyU9Ri/wvodFnD+S1A9j1dRGrjo1lhXjFes/sVsd1YD8R5t8OgGr1Ko+SBjP51QjTklQnH/LjQT4hJMORuYLWTz4QiS9YdrU6rwt+v2cTg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 01, 2026 at 07:11:25PM +0100, David Hildenbrand (Arm) wrote:
> On 10/31/26 19:22, Zhao Gongyi wrote:
>
> Hi,
>
> thanks for the report! CCing Lorenzo.
>
> > KASAN reports a use-after-free in page_address_in_vma() while ksmd
> > merges pages. ksmd keeps a folio reference across an mmap_lock drop,
> > during which mremap() can remove its last mapping and free its
> > anon_vma. page_address_in_vma() then dereferences the stale pointer
> > from folio->mapping.

Fun fun. KSM is dropping the lock then assuming the VMA doesn't change.

I want to take a different approach to this fix so I'll take it over.

>
> Do you have a link to the report or the actual KASAN report?

Thanks, the attached report is useful.

--
Cheers, Lorenzo

