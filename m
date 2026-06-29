Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 865D0C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B99A6B011C; Mon, 29 Jun 2026 12:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791FF6B011F; Mon, 29 Jun 2026 12:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0316B012A; Mon, 29 Jun 2026 12:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43A676B011C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:47:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DC3CC05D7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:47:26 +0000 (UTC)
X-FDA: 84933530892.05.4804956
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E16631C0004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:47:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QGYhfnZ4;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751645;
	b=lnjIfFY8KBG+apW4TELJ71XSDclHeBzFekLtIaa6LT9JaT40C630rx1bCZ1aFW2yhSR5mu
	3l7Amd3ndLP+nCpCpmZmgDNdosIfTgmLSikP5Tyj6NnZog9ChSMIRRNpGbfHPKnGRXlgI/
	iMNI2QfHCWwqDd0FdjBxM9oLZXtmdH4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fP/oVE9eT26peo2ialtxXs2L/sAlCJhCyJZbMq0zD5I=;
	b=CcWLWXUWXmO+odhq19yzBWI36FGpWUf5XmBDnKd8sxDyEhoUUuEXARZhvC9/ARlGkW0v5w
	oGu4Hpacil2VbA/nPWrD8tFfsQPlZ16qpyUo8VY5AkaoL+h6gbxxe3J29yalyjjZsQAIJJ
	ju3YFRGH+qyjKa1ZS912DmeSSYkVMno=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QGYhfnZ4;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BB4E60123;
	Mon, 29 Jun 2026 16:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CEF1F000E9;
	Mon, 29 Jun 2026 16:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782751644;
	bh=fP/oVE9eT26peo2ialtxXs2L/sAlCJhCyJZbMq0zD5I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QGYhfnZ4ueQS79i38OpZt6lJErmX9OSrWULYrn/MP/YlgxuQz7QdVwISHgm6P4s+B
	 P6iPrYkLREZDe879OdYZtNZg9B6uqtgzGvUai9aHKSUEfeH5DMUB3C2YMfaCP88Vl1
	 jd4/7LByyLSEb79RHki+CefebvnunCIbDtD3XJcM=
Date: Mon, 29 Jun 2026 09:47:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Wenchao Hao <haowenchao@xiaomi.com>, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Nhat Pham
 <nphamcs@gmail.com>
Subject: Re: [akpm-mm:mm-new 107/142] mm/zsmalloc.c:800:21: warning:
 'obj_to_class_idx' defined but not used
Message-Id: <20260629094723.806b3136a936b7b061c3b361@linux-foundation.org>
In-Reply-To: <202606291933.Cw5TBs54-lkp@intel.com>
References: <202606291933.Cw5TBs54-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ue4wts5ij8n35ekgitk856bsok1z8mxd
X-Rspam-User: 
X-Rspamd-Queue-Id: E16631C0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782751644-337576
X-HE-Meta: U2FsdGVkX18zdCLpTn2LCq9nxah3nS6NbSuxAvH2DaZw0MHMs7YPnYAP5VF/Bpce1VA2vofUWWx/4n/QH2ljxVT7QaelZpIN96NKEDHsDGY24Dahpc0M6/HDYT26aPkBBpFU91i6ywx7PU2uGD8V9xD3RC5z4FcbXhnyVDs7Br/lR/99YavzzSzdef/xkF9pTdqFl+sqImpMB4qQum7dcHS3S4e0P8XBSY/oiIN/xk3fnNqBigv/L62nCYuxnG+ZnggGOjx4oFgiPGTexvSQtBuRJ5ZrFgWpMdH8awOxVXencAWJ6448hpYpEULQ6n6P7RExjkD8Obu9SoIi8vD2kfpThYf0BdmY4R8cyuobF6MYg1pipleas3c8KCUegoHALIYzv6OsJgb9AeZPkQFICx5SxsOWSlMMsYILI4UexWz08KchLDWza3fuVRlBc8yBQXrp0l0tBuzMS2/uhNaK99nOWLpvnGs+lol6ByEwKXlosIHZ+lB2G7EsoyJtwxaId0qnef+rvOh55EaY11DeDTWroxiYskApN343MjPYHmTwJ4NqHeQA2kwpDI9kcxlOx6VC9GRFQluPPf1yOZ7StdxIxa8Od3j1Rd8c1+sy8024n2QE326bsgqQgFegiNuCoSBzJ2+OwPeI8FydSxwwsNiVc00I8lJQnQ5i1A1dOYKQvGWqcOWQwpGIjpLiyNr8nCGgEeg39IG84cABPTd1aHLq9rJtkUFh9IRGv6aVHAQQAeHVYSGcbBqecJsUqM05xlg+QNGlq0Zk32A79yY8hgwZ7WR+dqXvXuucNF4n1dDxkA7u/u85ts58/ag3OgXar3c9/pe6CzRU780ukqWEo5fXt3w66Fn7icZvZZ4kEfKO1wRLLoGw3Bg1+H85bPpXHwdyoK86xbjAgXYHq1CW6d+2OfxQZ7jREqUNVDcTvV7OotYK+fNG2wT/JWONJfpUJ05RyDeG9UHQ3I6xE5E
 krithmL5
 g9EZSuYvEP5gO6gY9ik1/1rZ39bM3PnHnGqwCgmcvXLxQetk6UXFv+kZ7dAG6+gXlFVaLlJc8/4FA2n4YWgeGHMRHql1OPo9ip1cN8xLzv6IpOtg3xK9UYSKwu55QPXCLoXEwRQAlRPNJx+s01zz/MUxOOSfWkmkdgCvRA4eGOQw7Q7zb1cNMRgFFd+IBGcCk9k8J95hiy/ZeUva7p1HXXMXoYCvcRSXsiebFEExQVeyG3ZE0saQ/v5DQvsq42xMb/FnU9ipIEOTUV11uWPwW5strV+WgC32O+EhBIe1sk6q66oRuI9G5RMCreKuqhWceta0IzMEfHtOtyHuWVfWQ4R0jY1EjzPr9/410/QCas84Z6gJs607edzxJZ1cBjM2rqyCePNjXmh+UHU+g926BZYp7nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 19:18:51 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   88cefc306c43b58d9bb65c9e96e284306710d961
> commit: b3a8a00229ce2b0367afff075a00d53b92e1234a [107/142] mm/zsmalloc: encode class index in obj value for lockless class lookup
> config: csky-randconfig-001-20260629 (https://download.01.org/0day-ci/archive/20260629/202606291933.Cw5TBs54-lkp@intel.com/config)
> compiler: csky-linux-gcc (GCC) 10.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260629/202606291933.Cw5TBs54-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/zsmalloc.c:800:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]
>      800 | static unsigned int obj_to_class_idx(unsigned long obj)
>          |                     ^~~~~~~~~~~~~~~~

Thanks.  How does this look?

- fix obj_to_class_idx() defined but not used
- remove duplicated #ifdef CONFIG_COMPACTION

 mm/zsmalloc.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix
+++ a/mm/zsmalloc.c
@@ -796,12 +796,6 @@ static void obj_to_zpdesc(unsigned long
 	*zpdesc = pfn_zpdesc(obj >> ZS_OBJ_PFN_SHIFT);
 }
 
-/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
-static unsigned int obj_to_class_idx(unsigned long obj)
-{
-	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
-}
-
 /**
  * location_to_obj - encode (<zpdesc>, <obj_idx>, <class_idx>) into obj value
  * @zpdesc: zpdesc object resides in zspage
@@ -1719,9 +1713,12 @@ static void lock_zspage(struct zspage *z
 	}
 	zspage_read_unlock(zspage);
 }
-#endif /* CONFIG_COMPACTION */
 
-#ifdef CONFIG_COMPACTION
+/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
+static unsigned int obj_to_class_idx(unsigned long obj)
+{
+	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
+}
 
 static void replace_sub_page(struct size_class *class, struct zspage *zspage,
 				struct zpdesc *newzpdesc, struct zpdesc *oldzpdesc)
_


