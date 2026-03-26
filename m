Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96102106F2E3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3FA66B0005; Thu, 26 Mar 2026 03:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA196B0088; Thu, 26 Mar 2026 03:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF676B0089; Thu, 26 Mar 2026 03:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF7B56B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:49:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 589921A034B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:49:39 +0000 (UTC)
X-FDA: 84587439678.25.0E30ED1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A0DDB10000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:49:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hkTsvYfa;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774511377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=os4SMq+t/yEmQd1VytqM6n0aFF5yg6JsE2YvfRNIhJc=;
	b=HZipFHFOoAM8bgH7dFoQGTbYLwh9U2MMqYjyA0Om9oJ2BVrviT6Q0bvRoWeO2SoLrOSK4y
	xy5v6bmNdLFwygH6yR/Igzgx0M1Dr61gKjUJv8fj0K+/U8W6qBzy1yz42SBuzXQq+UGUZL
	ADeo5wYh9LNrHzMryaVXS2mnYlx8WLM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hkTsvYfa;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774511377; a=rsa-sha256;
	cv=none;
	b=gflCB9F8c4IpFcIm3YlZkiP1WAvfcifL5ShJXRAL+o7kUc5Vr9FW7JvzxruvQImsCUM+CI
	HwaqXiLwqlzMoVApyxvj689ReQVf8vod9/YQpozOxa5WxlZYiRj4S7mq6+lbTZ4A7pbwIa
	XgAc2iMaaGl36V1wPgrNPuyITZck168=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6793A40DFF;
	Thu, 26 Mar 2026 07:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D514EC116C6;
	Thu, 26 Mar 2026 07:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774511376;
	bh=8nDB0oIo9sqP+FijthFROT29NVoG3BUWxTpP48hvkek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hkTsvYfajtcOeDkmzxVnXZPB2gMnKtbblkzQU25KKyYfVjxKrAmcnsG2HvW2Pyp2Z
	 QhZq5DD9vHAfMR9eyxPw4NLTwavh+FCHeFujDF0XTGOtBAk0PhYcT7fqw/9+q1qjoS
	 SCPPd5SW7YD44nCxsNiBPVAIOGAvoA+1D3vTYlRlra0VnQmZYizJY9QJkKHTKjIJRa
	 w8kjOcDpASnJgwOagDdLyiYQgt8xlzdMswfysdAJuaaxs8+Bw+gUZixqOlU5FhBQVP
	 fo1VKlx4D/y06nZZ3Zb7ayFbYUaWeUGZwdTUhCWNSkviEAOWSyF/Z7e/eOsU70HLhl
	 qAEfB0rFMIlFQ==
Date: Thu, 26 Mar 2026 16:49:34 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
	mkoutny@suse.com, akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 2/3] mm: memcontrol: correct the parameter type of
 __mod_memcg{_lruvec}_state()
Message-ID: <acTlDgSt_MFIadDO@hyeyoo>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
 <acM93qmvDFofjWdM@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acM93qmvDFofjWdM@hyeyoo>
X-Rspamd-Queue-Id: A0DDB10000A
X-Stat-Signature: 46frmz6xnump1jgwh18f16p666uk9q4p
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774511377-999428
X-HE-Meta: U2FsdGVkX19SphObnUXa9WRosbX+0hCESvlkQ9qan1ehYP2FN6GbbiL4Gi8TXVsUzcWGM1fZAINoMpsZaVwMb7XtOZf8UlFmwtj24l/W67i+qb2//0OpK0c7Os5dYyzSNpivNiCPovx5Fv5JM/HNlsH65xxRu9MkP1wW/7zeOOnn3A19/+VpoRgK6C/qaPOm4OV9UUMmFwOzIeKlD9UGSe7djmOm/Gnt69tDPVinAgiamIs+YNP1oMvZ1TQZT6dZu8K+92e7VSPPYSkcurn0sbocv0RKPSDAtI+FDALbr4lZC0NsET4r5CRmS4toszL2MHnwiZZS3w8MLBIBG8FTKs00EO7AEnauK+C3cV+TbTtc9a3qDOBq/nWQYgrQiPGKgonjLmwaaNjK1iof1Z1H/GhTadxwa5vpH+2N0usJdHAAdSAZi8W9eHSljv2XQsWoIKlSRhZiuz+GtCew3rShdOBUwi/lJaAD12mOiXYWX8tfwb3LUBBHTH72Vm632BonF0nlxMCgvZlGl68jbNq1bIbRtnzwn44fdtI30knR/mdWLIPR+l6wC68gOGDgpVo79ai59VlgU9I0IJTEsQARgFtCP1eg014fXQFdu0BijXydAfVxqVo+OgUlM8Sx25pk+NiTbrFcAMKNcOUt0fAWodMzM9qn9aGYi/q1CD43AI33eBSUVahoFYmQQToeSCGNoGEIuZylmSCtieTqmejYbcF6J91qwadOoKrZqTdXST0Xh742VCjxVGKqM7QRvcC4iy8gyFW/a72+nMkflvt1HURowe+54vfrAfKIY1Lq7uXZQvyNsnTu/VBi8zWQV/mVMeuXyQftNrcvsd/0nyZntUclcucuGKsgQsq9nkjS8eG6jqYx2T9IvCOGfdS4rx5E16wrrL4ANJcYv330wwnBUqlgfgiFvH2sV+EZjUTJ07LYh93tc1zUiWVqj6DXPdzq4vQIvXcHNpcfp5tifp1
 qgo6ERUn
 dYEu0DZg64ePaNeQ93OuoaNWBji9+ZvlQ/gvclacNAPCDWT4wPYVNvwFEZ5WJC8D02wXietGSmkAXKqKVmb6TUsspYDNiUuFlkE7yTojCqswLDHDbeus/AOyBqeVi+/HJUys/PtN5kPM9+ZH9x6+cziKWkUEZ2AwI6Hcy4q2dK+9dgr6tmqthH6DI2aoBF2JIOjR1ZH2ktyu3e+uKtadclf3wB4d4/TOqiYsvmaHavazxq8BfdLox3AKNjGOTiZPJKSJ0WIkljomyaLcvttL947eyLcT0x+OYnpmEFDpYgZyeKa5DNgCkvhYnga0QIYZNzSHWsvCHuoUOla9V13QL3sc/ks9SElCkUL8DXkheRZnfEYibtOmNiDUxl62i+afRr8W0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 10:43:58AM +0900, Harry Yoo (Oracle) wrote:
> On Tue, Mar 24, 2026 at 07:31:28PM +0800, Qi Zheng wrote:
> > @@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
> >   * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
> >   * up non-zero sub-page updates to 1 page as zero page updates are ignored.
> >   */
> > -static int memcg_state_val_in_pages(int idx, int val)
> > +static long memcg_state_val_in_pages(int idx, long val)
> >  {
> >  	int unit = memcg_page_state_unit(idx);
> 
> Sashiko AI made an interesting argument [1] that this could lead to
> incorrectly returning a very large positive number. Let me verify that.
> 
> [1] https://sashiko.dev/#/patchset/cover.1774342371.git.zhengqi.arch%40bytedance.com
> 
> Sashiko wrote:
> > Does this change inadvertently break the handling of negative byte-sized
> > updates?
> > Looking at the rest of the function:
> > 	if (!val || unit == PAGE_SIZE)
> > 		return val;
> > 	else
> > 		return max(val * unit / PAGE_SIZE, 1UL);
> 
> > PAGE_SIZE is defined as an unsigned long.
> 
> Right, it's defined as 1UL << PAGE_SHIFT.
> 
> > When val is negative, such as during uncharging of byte-sized stats like
> > MEMCG_ZSWAP_B, the expression val * unit is a negative long.
> 
> Right.
> 
> > Dividing a signed long by an unsigned long causes the signed long to be
> > promoted to unsigned before division,
> 
> Right.
> 
> > resulting in a massive positive
> > number instead of a small negative one.
> 
> Let's look at an example (assuming unit is 1).
> 
> val = val * unit = -16384 (-16 KiB)
> val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
> max(0x3FFFFFFFFFFFFF, 1UL) = 0x3FFFFFFFFFF
> 
> Yeah, that's a massive positive number.
> 
> Hmm but how did it work when it was int?

Oops, I was about to say... "Oh, doesn't patch 4/4 in v2 need to have
Fixes: 7bd5bc3ce963 ("mm: memcg: normalize the value passed into memcg_rstat_updated()")
???"

but then I realized that I made a silly mistake here.

> val = val * unit = -16384 (-16KiB)
> val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF

Err, I should have divided it by 0x1000, not 0x4096.

val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / 0x1000 = 0xFFFFFFFFFFFFC
max(val * unit / PAGE_SIZE, 1UL) = 0xFFFFFFFFFFFFC
(int)0xFFFFFFFFFFFFC = -4.

> max(val * unit / PAGE_SIZE, 1UL) = 0x3FFFFFFFFFFFFF
> (int)0x3FFFFFFFFFFFFF = 0xFFFFFFFF = (-1)
> 
> That's incorrect. It should have been -4?

So that was correct.

The existing logic produces an accurate number (intended or not) as it
is right-shifted to only PAGE_SHIFT bits and truncated to int.

The existing logic is fine, it'll only be a problem when it's not
truncated to int.

> > Before this change, the function returned an int, which implicitly truncated
> > the massive unsigned 64-bit result to a 32-bit int, accidentally yielding the
> > correct negative arithmetic value.
> 
> So... "accidentally yielding the correct negative arithemetic value"
> is wrong.

I was wrong, not sashiko!

> Sounds like it's been subtly broken even before this patch and nobody
> noticed.

No, it's not.

-- 
Cheers,
Harry / Hyeonggon

