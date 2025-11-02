Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB03CCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 08:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83238E0009; Sun,  2 Nov 2025 03:28:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35148E0002; Sun,  2 Nov 2025 03:28:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72C08E0009; Sun,  2 Nov 2025 03:28:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4D038E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 03:28:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74A0E891E6
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:28:12 +0000 (UTC)
X-FDA: 84064989624.16.90C3527
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf10.hostedemail.com (Postfix) with ESMTP id DD8F3C0003
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:28:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762072090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WqyyDGUVxajh6m9vyZRhbE7aqxtkRD6wU5zCuGp4/4s=;
	b=m48bB+XGbaf6OkBS2mvX4WFXhARoLCwb3gSRrlv+axVSmD+nrfIDW8usYLdvkrm6d7X6pV
	vwSk8BExz4yanHzh4INi5244oj1NEyZflm+swPawSJqFsaFnSgtqnHxQ04Ot2CdCYoF+jE
	xuTRUrw9lBrwys2J/uF2sewmKT/PS70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762072090; a=rsa-sha256;
	cv=none;
	b=7tu8WRtaT2VQu87LllP1sCn/YPNuuygcqjFLB1blqLDSVYPSKt3fMJXRiCiz5PfOWuWo7/
	02dW9qy1heS64hgmtZ9gLwBRavGtpQ2BnZslKsbPgwvjcuW2cpC6Rj2m9lST1AP2ODIn+1
	mA3yjgArKRCYMfS63z9He+rTA2e/gl0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 2 Nov 2025 17:28:07 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 2 Nov 2025 17:28:07 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>
Subject: Re: [PATCH] mm: swap: remove duplicate nr_swap_pages decrement in
 get_swap_page_of_type()
Message-ID: <aQcWF/dP+wnkRVkc@yjaykim-PowerEdge-T330>
References: <20251101134158.69908-1-youngjun.park@lge.com>
 <CAGsJ_4xJnVC-0zccgnB9NZUU15_oO=eqn1wrh8REkqdGjjsJVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xJnVC-0zccgnB9NZUU15_oO=eqn1wrh8REkqdGjjsJVw@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: ojxztnmiazmko5fhyxmh59efzfsbrh3r
X-Rspam-User: 
X-Rspamd-Queue-Id: DD8F3C0003
X-HE-Tag: 1762072089-551107
X-HE-Meta: U2FsdGVkX18SIB6uyDleNhR9WxdynYVl6gz2Cpt84lZTQvehhAgxCgH1zZy03UblBrPUF8/kOTP/R+tPdG/kIDLxetm+VxFt00oo/3C2cktLJSc9lQMljkNPk5nh4LKZOkl4IMGYVd8LVOjXWbx5GKm9yo0Q3rGkOkUIfprUhyhYp/OBY3TwjGt8rZOLZoTutCF+ytqK+9zB5NAHPuiEujvIGpAUm07BQFEte7N0DrUWcpmSzMaxuwpxiyv/Ss8BxShPvrMC0aIqy0MRNvgQ2/eQjMsQ8JBmxsJq4ZSmlFreH2exloKlH5tFk3rQvbsOAjj2/A8u2awh9sJjez/ezAEL6H4g5weVMmw2Z1WazxRoUZzBBlU7tPUUyEIXh16GDqw9LNGWMRWkezqVlLVLn3CePBymg1rVTTljqdOtK7VMecU5xKzu0CL6ma4sMjjPo0nKKiXWtRQPfX/hjf2LRZ+gmL/wG/MVhkgSj+ekUF4Uk5AJ3jwXekJzXOf4G3swQaEiPdpuTttD3dA3SCpOgRv4XRighRrg1q0KcveGRqgIYIC97G5TVgk6sthaKQZIwEAuJDDT5NJjKrvQgajaX/UFTPqzOgkJC9aae2JLufxOc/RFS4TuWOzWPy2JxjEUE0Rp8KgXXJS82IM+S1OkE2IdX37yuaZ82dCMz1sfua2Cz4E8jLHcyEJaAgtAsl2dLmpChJXUu/+pBTrssNvePDBcQRpCllZ7Zyp/Z0Tu/KhcgkhQoMgT5Z9DfYlybBo+xUVSTw3twX7StdO7PfvqBZhfXgyL+2ECs1ixHTlbDqS1DVQJjsdkfqE2VZVRLSSirlnwPLY1hjg/LjwrhYi/Xm8Ft2IhtsnthheKQa52kFxWLKDTG2dOsVJr3pQ/eo2wbnkYpZRU7He30O0oL9WjrRrJmQA8h6osKNWU5mpT3RTCk69rkzMoJlFC/OzU7uyqASP9J8LDb4Tkc3xsEed
 dyB5KxDN
 Er7r85cLiyVkbVFtibfmkraVM2PbkjXXkQ1U36yHGZAKDtiWngWx33fbpIuNbqqnGsWAeyb8XR3ywWqYlz9QMS25SOVfsyW1wFX43fnc+xYbg4mVWJYFjG9d4lPhf/MqfSU2/hrZhrvokt0So9MSHvQQmKDN43szKRr7PMZa7Sl4F0xNlNKSrmueByKuUxnARPKc+tTDLpuVlTdlEkcL5+E1ruWuf8Gnrl/duoLNTxFh78XFUfY5q+7rm8H7rYJN0VtTsTxn+gnIhDZVckkfdPI4ovpiah7fxk/17+iOMs8qqM24tyFHGgvH16N0lRplQFBSQe5GE84RRhs8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 02, 2025 at 04:55:46AM +0800, Barry Song wrote:
> On Sat, Nov 1, 2025 at 9:42 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > After commit 4f78252da887, nr_swap_pages is decremented in
> > swap_range_alloc(). Since cluster_alloc_swap_entry() calls
> > swap_range_alloc() internally, the decrement in get_swap_page_of_type()
> > causes double-decrementing.
> >
> > Remove the duplicate decrement.
> >
> > Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()")
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> 
> As Chris mentioned, we need to add Cc: stable@vger.kernel.org.

Okay I add on my v2 patch as Chris mentioned.

> Otherwise,
> Reviewed-by: Barry Song <baohua@kernel.org>
>
Thank you for the review.

Best regards,
Youngjun Park 

