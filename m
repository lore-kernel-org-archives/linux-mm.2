Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7869F3381B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D26C6B0088; Tue, 17 Mar 2026 05:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9E76B008A; Tue, 17 Mar 2026 05:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198FC6B008C; Tue, 17 Mar 2026 05:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04E106B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:21:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1E03B9ACE
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:21:15 +0000 (UTC)
X-FDA: 84555011310.20.534139F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 11C5A180006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:21:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9X4BeG7;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773739274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=on1j7ajslSvkhF12FVkimd/+fmAoZyw97sduxWVTAos=;
	b=jmUEi0qaXIeJDNeTN2fgFodJp447sFCCJB4qnsP6LyYy42gMIm9N+0E5m8ipF2Wvn8H7DW
	oU15s5l+5rr5Hmu4C4Wytnu2AEbvsgQ3XbedoLoHYdM5vnuJEQxijf1RlH2uEf2wnSPtUM
	RO47d5cdhNCARsDX8h9KPZwJg2DLylY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9X4BeG7;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773739274; a=rsa-sha256;
	cv=none;
	b=8HpYWQ0OUNzavbguePhb//Te/Ba7zdZtckyJ2NxeqCT8q+XS3y3f9UKaNpSIioHv5qhy5i
	rgDbN5hKITxNeeO1RJsto8qwGIO8lglDaWNw6eoA2v319hLpVXK4FeuUyLTr+Qm1Y15VPo
	lalKY4X2ZTB5uYKRJUtGJk8Lqi/gsb4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A9FE61336;
	Tue, 17 Mar 2026 09:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CC1C4CEF7;
	Tue, 17 Mar 2026 09:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773739273;
	bh=Nb+z3ERNb4mYPAq2w04pUMsia9eivhsePXExpNPqpUM=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=i9X4BeG7QM21TD20y696jUkaoliMwB0q+MPMMT5ynyvu5uGDczI20fqrVZbtqmE6X
	 /KLl0SyQf0BGfLKKR/X9R7/rTJZzenAjoXQZxBTfZAw8jkWtyQK0b8pQkOPHF+Pc0V
	 Fy6M+EQ53U5oYELoqLbNMfKhMqtPBRu/xfpV2dmjr5Mv69WjICprlWau08ueZuigkv
	 o5fQEBGXoIC/LwzsmaQHk8ss13KwaijqZrrZN9OmGMGShA7oD2f0kX3dPxuMkbivIm
	 DGkDNc4Ne3sJUY6lJWVFw4x47Gf1v/3UvXhD0ZfLX+8Wf08f9b4g5FBH4iofUmOhfR
	 hwWlmUUoz82vw==
Message-ID: <aab8aebb-9703-4b6d-8ac6-e4811e972898@kernel.org>
Date: Tue, 17 Mar 2026 10:21:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>,
 changfengnan <changfengnan@bytedance.com>
Cc: Dave Chinner <david@fromorbit.com>, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>, guzebing <guzebing1612@gmail.com>,
 brauner@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 guzebing@bytedance.com, syzbot@syzkaller.appspotmail.com, linux-mm@kvack.org
References: <20260115021108.1913695-1-guzebing1612@gmail.com>
 <aWh06YoiJrR3-J-X@dread.disaster.area>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
 <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com>
 <abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.b89f1572.8ddd.443e.a91a.9f6964f1a150@bytedance.com>
 <abkbE_zh79iCd5zs@infradead.org>
In-Reply-To: <abkbE_zh79iCd5zs@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 11C5A180006
X-Rspamd-Server: rspam08
X-Stat-Signature: myr85zcjqb4hy9enkkgmimq7tu64j8dq
X-HE-Tag: 1773739273-861931
X-HE-Meta: U2FsdGVkX1/YvTmgVB7VKV6YANCPiMy4NqryLM9Raed7UrLb8NYBoin1BZqO92K+hHTlysOW10MPsTnPWrmpCPsJPudDWrY+v7XoJEN9cYgqotSBQGLD5eEeI9WXFhwFLDyCV8KLAwTB4A67Olo/uhn5SaQv1psuPLURBhtg0cPQqksKN0rYFRAPjYvvho6E1jyqrVqXPds5PNhgk9tQuz9hGsMP4O6EZnPsXRF00ToBNpOBlITPzVJYFb3Zn8Jrrjv228VcrRwe6q7V4CaOvkLL+y4MC84ETwAHTS/7PbRPgHLiVkBWau4lz/4Ypfyt6YBZ1wVpPsofnd3umoR+jQXhB6YXdkuhsuaBRTrxmmvIhBsdMIDCI01rNgZDS23H/53Mu6BSIno40AJ4MlFYpstdVDB+n3NUbolTEWl1jw2h1dMLZb1Tm9aOfCh3UJVLxY2FDsvXKYGdx8X7DgSjYO9i2eorm5rIsaJKbFPvOE79mZcUICbFnPtEocIrA2eN8SWVpU50C2b20lXdehvD+6RaU0rTxYKCv7PCVAk8R1pvzKQxUTLeA0IaPlQ3EeFDDU3ANzuh6gi73j5L2cVSxt15ig1XMO72+MLPVqEcuAzU97bxEsgObGVi7XvOLLr7QQbJWEqyW+spdIKu7YYCG+kNMCOpcXsoRvbl9lKP50KZWYXcJxg2DnEueQvYzGlL2oXBElWc6Zwo3XwefGyoBq9JBI405xhz6yw/T9dzNQFjali5fqtjW9EV/RbzLU1sY2pwvEx/kbq0kebKZxHmOPtqAsFGgxUllnm/V3ixpzBfGk6GYp7tOaeRphxFLSqKeBmOYxwv7MGrbwdr7J3srFv8jxNiOIsM4CikD79NKQOhaaQeIlpXJHqYaMCbmV+XSGCuNZR1y9/w4S5y+cP/Bvk8gHJQSroa3SCPP6medxw/whzni2+x0qbWqF1xfQexE7JQjyoTiV6DWXhf3hZ
 sstGwxDB
 dhyOSY+FXb8ibYncD/x1ZUk7uOkzfSI8g0DqHDm3dA7Xc4xZ6k8+TrcWPbuZJf5d9Y0f82Z5P0t8LFZb1NWIHKEbb+F7xDxvI1/qmC82ZNjb3am50fcil5aVaTAeltQO6kGxP9axX7M7ndsL1pXTL/tpmEuxCFFYgKQL5aGfoXahVVJbEC4Ilr3FAi7DJfSXDsNsGO/i3xVXYV9NoqGIYD4XaCc2bJyRzd6uuhxRMBTjNFvn+sH3cbMik4m7aTtEji5+XWUgbAHVX53pFE+Nca1YBoJluHqn3AsBgz5OG2TLbPjnNyPGPBEFBxyPwZl1Oe5aU6T9d4ocS4GU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 10:12, Christoph Hellwig wrote:
> On Tue, Mar 17, 2026 at 04:33:24PM +0800, changfengnan wrote:
>> > IO is not my area but getting from 1.19M to 1.20M doesn't look like it's
>> > worth the custom code? (possibly from 1.17M to 1.20M it also wasn't).
>> Yes, at least for now, there’s no need for a per-CPU.
>> It might be better to replace kmalloc with a new cache, but my tests so far
>> haven’t shown any performance improvements.  I’ll look into it further.
> 
> Does using a kmem_cache help?  That should generally be a nice win
> anyway due to keeping the objects together.

I think that's exactly what "It might be better to replace kmalloc with a
new cache" meant, and apparently with no improvements.
You might want to try create it with SLAB_NO_MERGE flag so it's really a
separate cache. Custom sheaf_capacity might also achieve that effect, but in
order to have deterministic results, the flag is a sure way.

