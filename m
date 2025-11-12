Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86923CD4853
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 22:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0348E0008; Wed, 12 Nov 2025 17:22:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90BE8E0006; Wed, 12 Nov 2025 17:22:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3508E0008; Wed, 12 Nov 2025 17:22:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB3E68E0006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:22:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B72CBAC5D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 22:22:17 +0000 (UTC)
X-FDA: 84103379514.16.57D1144
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8B0C440012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 22:22:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=scZ7fIIA;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762986135; a=rsa-sha256;
	cv=none;
	b=RBDjmN9aEXr58KfYpp+aAdK5dVqor83qu2Tw1JLKtTSw8HwBGiTRWHl7kiLC3iv58YvReP
	KkBhKObO6s+ueVL63P8VTOprV+hL1PDo5P2PRQ66B0AQHKYezyUUrZ/2DIvPpjz+D5Z8st
	O56LlKiymCXJz9F0HEdMdv0xhtaR+BQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=scZ7fIIA;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762986135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6WfSIu5U0ClFmQ074BERJXW7/QpLIgN/XHOLt38Ak4=;
	b=mhWIUbPRcuOF/BehvtlfZaqWWB5ZerZQR7LXngekajAtGy/biJOGhCQzasLWaD7VeNDz0/
	SXVQS4r0tQ8SDwNnOIjphdxrX43TE38YYWp8Ob4wKL3PqmkavWP2Z+PGMtuJvsquq6Xgiw
	L7m2ewI7HL7PPFa/+l0X8HbAsfHJxQQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C4FB43C1F;
	Wed, 12 Nov 2025 22:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D1FC4CEF1;
	Wed, 12 Nov 2025 22:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762986134;
	bh=Xnq1zlhUzQlq4w7pNhD9+285Oip5KNSnZLZFH1CTK7A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=scZ7fIIAjmpG3n3F9Q5lLUk8HbQXHeXjOTMhm7EB1qihhQhQZ2psy2l53qUs1yeeC
	 HmsQQGjCw9+09migWcXEzPLTShaS2/ATeGIkPJFwZSUpg6VbeZhvlYhb9lD0wbSDE7
	 G5c1uJGoMLmLbPNsWkAs5qP8EX7OvZJ5nxzjk9rQ=
Date: Wed, 12 Nov 2025 14:22:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/4] make vmalloc gfp flags usage more apparent
Message-Id: <20251112142213.bc01a3abe37de98f9d40e392@linux-foundation.org>
In-Reply-To: <20251112185834.32487-1-vishal.moola@gmail.com>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8B0C440012
X-Stat-Signature: eeaqhp58maobred4h9hazfefb4fx4a7g
X-Rspam-User: 
X-HE-Tag: 1762986135-921600
X-HE-Meta: U2FsdGVkX1/pk5pJyItl/6c5Vozcgiv7NAUQs95WpPltLbTHU0K+va/xTGnrUBcPTwKgYuHswmKPpwZ1PfZEKNCTHIIWX3k4i1Kn70saADQKBiDR3tiw9cUT0NupmdYknpbollMCUMuEds/lEmBlvYQQ0pY0AzlVwhp59vHSDmXiw2ReKGp2tfF07aszE7iCuHRieQnU6/kXQZkO2DRHa4n9TGgNVLroqFa8yToF6rzWPAiYJBdfdanQdRe65W4H7OKYnz1SMtFT1d1vzBiGcaP3o5ERaPytwBU8n+jYXhkYX2LgCtVkY6Edrv9IBjZsXgUWQO1YCCVnEsoZM44FQeju9RrKj3OWoXeP8UgcOsSBhGuWsH2M1vM7ePOUpDYiHXplSI5QI8CzZbkaqzFKKr+Vgzhsc1FkQ316d9Iv/5fAwlqbWamamEEmrf4NXYWnrSqmwZjWCRHz8KJ61F5gdeqyhKTZ7PyOM8Lalk+r7HnNgmZRAXQ8bEAfo9gb2fL8NSoG03vqMxEzrA1dtimDOU1PJfo1SmOpvoj93sT6xXK9zGEDrXfAPDDnnMCtkoa6iejOFboFYGFQHM+P4gFymkRg3nU6ESk+Ab0JrHbJIWCTZNvZ/z0MMSfnz0Vh0t0y+sztUlkWr5SeBXw3uJ46f6jksmxKQjmZdW6/pKIWQfV5AKAA8MqXzRIbbs9ageyDdHCT1jP4gcCsngSO0AB2GgtV1FDaSK8tIEDRdQyZOm56XQldWy0QRixmdfgdJYaUBlQ5DkT5WtCsydlYiqepym4DUaN/3VGbN03wKKzwWnnPGc/Hr6aN6zBN/8hw29QG6h8AOpTV5oVIvysbNmy2rOUTkA2p5zG3XpsnZQHX/AbERqlT1IWzCpfnO6IttIT6B5AUPEwJInA3GLReNzte3jorWOEzhq3Fa7qDuWa1QI9oB4vCWdsgBF1NF9PBqops19PrgB4CJcMl2btho6N
 z+fN24q/
 X+X0yXNocC7jcLgflJ0keWRpCsaujyfI84fZ0gwew/LEHkC4fNUF2gCtMA0wbG/peA5nLw/yMJ6B8Jdh92iwwnLFcs5WQ2rzBZosk3cSu9aq941BBcpqiTuyFFCkW0Rdwo2U4xhDNoe/VzYO7NvQvObmGXXqRrj+PhLhVi38GiNPZsX5z84OCWqBa0Wd1yDPgedQg0QGOiXGc/iKnsrU2eBrSlBs8et7JpXyePi8nCj+IOndS6sxSm8o3YYY2aWW1oPHgzfIzaqcOZuN4t4ChgNzTJF9Ylrg9de2WzJWhs9u91LveTrgjJV2hDM42dFSCYuDYL00LldzMTG82lZlrjYFVLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025 10:58:29 -0800 "Vishal Moola (Oracle)" <vishal.moola@gmail.com> wrote:

> v2:
>   - Add __GFP_HARDWALL[3] for bpf and drm users.
>   - cc BPF mailing list

v1->v2 diff:

--- a/mm/vmalloc.c~b
+++ a/mm/vmalloc.c
@@ -3922,10 +3922,12 @@ fail:
 /*
  * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
  * This gfp lists all flags currently passed through vmalloc. Currently,
- * __GFP_ZERO is used by BFP and __GFP_NORETRY is used by percpu.
+ * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
+ * and BPF also use GFP_USER, which is GFP_KERNEL | __GFP_HARDWALL.
  */
 #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
-				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY)
+				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				__GFP_HARDWALL)
 
 static gfp_t vmalloc_fix_flags(gfp_t flags)
 {
_


