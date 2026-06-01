Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7517FCD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 04:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0456B024D; Mon,  1 Jun 2026 00:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7606B024F; Mon,  1 Jun 2026 00:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4846B0250; Mon,  1 Jun 2026 00:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF9CF6B024D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:00:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2ACA71204C6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:00:36 +0000 (UTC)
X-FDA: 84829992072.23.A185944
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf11.hostedemail.com (Postfix) with ESMTP id E9FC540010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:00:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780286434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uwsf0BZgrkqXpmlkq67Gxq6zX208bf2tVwUWPjjaJGA=;
	b=QTMlm+O98nxg4YWPgz82Q2GItGDAoDEK5o6FsQss3shCj+jfYTghPZp3mhPVe/CttrhJD4
	Ig1O/H5DW4MmjgjOqvXgkAmAK8KW5up0qryRYznhPNKFmf9+BSWPTK32JmYsjSWWUUuM8f
	hOO9eZ9CgX7nbHk1nBspblgmfNY1RUQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780286434; a=rsa-sha256;
	cv=none;
	b=Da2URldyK2CZupxAyMuhVrvsFX2AqRMnUZzCtbPvdHw6bIIKJZ8QizqtrZUfkTwYXoSMKY
	2RLFbxkfUgLOiD9RHwHqos1ps44otTPRRF3n+QXLL3bIL0PXiYcvd3btVEAJjJtrE9A3UH
	vpUDtoCplM65oht2L+K4EIecersSsAs=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 1 Jun 2026 13:00:32 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 1 Jun 2026 13:00:31 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v7 0/4] mm: swap: introduce swap tier infrastructure
Message-ID: <ah0D3x/586U9GKkL@yjaykim-PowerEdge-T330>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
 <20260527133651.2ce806fa542a82eca5ff66d6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527133651.2ce806fa542a82eca5ff66d6@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: b9e8oo7fm9yujewkzahfq7k7f3emegjs
X-Rspam-User: 
X-Rspamd-Queue-Id: E9FC540010
X-HE-Tag: 1780286433-280590
X-HE-Meta: U2FsdGVkX1+yyHPgSjyYIgx2VrRtHY82y/SunIGLM4fr/MW/NvT2RIxZAHiUFSbST+jeu4xMlmmnHY7KVKqWt7ABw14saGVgwwD3FaiaJTfbgRyaeyUaamUYwnIpS1AFU1TrmystsYun1DOugpn/aGREMZGJjXYQ/JWZVRcGFPdAnX3PfGOcEKaCAAczNr2YF2tbhnawBKxx2dSpbVsYltVg8/H+mgg6Hfvc5z2wVjuwGEwRDl8AyoCLS5mAcEkT8H7neYp+4DQW2QqX8blQy5IR0Qr0BtrxQDpnFtyZeE6AAZfoC9wvTla4edtqUw+mlsxlQanVDacjFFoMlkY+cSYmUKg8b6UX7ac9n6wJQbW0jiavAmrAbbxFTI7bfKgdKlaO8MGMOr1BI2oaVV5Z8B9xOXs7XWoVa17FrCQ+dqmcqzXZdZAuysCEYnpu8m4Gt7yqcW+QNavD3mazmYjWa726hsdf3cm9BtxZOAWhrYh3K4NZ1wsrR0+8JL4bL8Xgd6Xzvx1fBGZDyiI9Hab9DjwW6Lauz7I75d6OupLnWqN1BN6kWWw8H/WaB9dAfDdLnNIw5bse1aIkIEckyLwddH3vtY0xjs2ocPa0kkMPv/v8idMX86y8LMD97n8CAVEGVXAFyTSPEjBqszUOS/P4Wm9Fp3hmVoEx1o/TTKqdHO6rEItjgMnF05BgxA83uRPsrOJNWJHy6HDICqjTqsBMSXvQRqB/2OmC+Zdz2M8qAg5RUmlnUnGMIFMoH/p7acPpzthOlPDIAJbVrB1qk76bAvUXiUShyxraR03MDKHzDCe90Xkb2Pps/oZOr2ZLxA0Xgr8MuZUzOJDWb2YAqP7/9ElYnNMtlV0FZDyuQ0DM/pq0YcIAWOCIH45p0nKeDptn9WtN3Ml4+IqQssGAwlcKXoCvshGWuyZrecZ42idFHVhy1vkDiLKpMHVWdoAYgDW4AJK9wOSlZ+LgNKvs55F
 rfKwHekV
 jcw4eov+d8aWXW8nCz5RkCpwHzblNj+YWok3STAcsCTXF9AZBN/h319G10blUOMbqMm3usJGXAx5743dceT6qoZn+eaTUhAbTMpnB6tEZoQbw453jAtLuKfKNU3+bAzQq6L0HQa/XtugQN1Rd7S/gWlUx21ugz2F4Yg6OAtwE4M/zwHyKJrre9NMsPVBQ46Q8XvXVtDFpFYflMnzg9ILftP50vu751IhmAB98ZRX7+xD/6KKo6dEnqR7b+mVIxQdzH8pSKNXesr3u4cY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 01:36:51PM -0700, Andrew Morton wrote:
> On Wed, 27 May 2026 15:22:43 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > This is v7 of the swap tier series addressing review feedback.
> > The cover letter has been simplified.
> 
> One question from Sashiko.   Minor, but easy to address.
> 	https://sashiko.dev/#/patchset/20260527062247.3440692-1-youngjun.park@lge.com

Thanks, Andrew. That is a valid concern and definitely needs to be fixed.
I will address it in the next version.

> I'm reluctant to add a new feature patchset at this time - we have a lot
> already and we're at -rc5.   What do others think?

I will wait to hear others' thoughts on this.

Thanks,
Youngjun Park

