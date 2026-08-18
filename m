Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB5CFC5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 05:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF9C6B0150; Tue, 18 Aug 2026 01:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C79A6B0151; Tue, 18 Aug 2026 01:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742F16B0152; Tue, 18 Aug 2026 01:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0E36B0150
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:38:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3D2680A9A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:39 +0000 (UTC)
X-FDA: 85113285558.08.6B2CAEC
Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	by imf31.hostedemail.com (Postfix) with ESMTP id ABBC920004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XW06ohtZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787031518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lr+lR4+IO3r0vpe8umZ7mEEDDFGJCtdsk10I1pkYKWU=;
	b=i52rdoeWtxpmeC3gPlp7yQopzQBwXEP+2DlDjxTWWKkmvdFg8zcUVpwwPzs2DzDxhoB8Ek
	KqPalDcpV3EW14tLCMO2mVtjXymkiIgXppQEk0jrNjBSywqg0DtwemxkLiIRSG6XAE0pFQ
	+G39IAmG11Pcl/eIw6ECPXNHou0ZGrE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XW06ohtZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787031518;
	b=hdOgrH0R5wcc0Hq+5K/P+8r78YGQz6wB8wjBvuF+Ru5NUX/Jfjol4fTtn/+nFMUm7Sh2sN
	7EhiLzc0faGyM1H66x+CG9LclqDMK1QNoW1EEqX5ZYAy/7rgOO7vK3vn+M5XxZWW4okFo3
	AGi3ye21gWGVSf4U6JswyuwX8jIrzpE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lr+lR4+IO3r0vpe8umZ7mEEDDFGJCtdsk10I1pkYKWU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787031516; v=1; x=1787636316;
 b=XW06ohtZY9wtYK8rcYukeP+kccgqnUHlbj+EA5IwyEXO7osJEmTOPwm6+zk6XDDTCmw8p3RD
 0qAPDUbIXWf6m10OBaoPZN9Mlvzw7ruc6Oal2gK2bXLM1Gj6AIirHbbb6h/LDqSryk3RyGZsOeV
 IMrtrKMvGWldHbkWEDul+mMA=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 591b174a047f5b98;
	Tue, 18 Aug 2026 05:38:26 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: hongfu.li@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lihongfu@kylinos.cn,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] selftests/mm: khugepaged: consolidate error exits via kselftest helpers
Date: Tue, 18 Aug 2026 13:38:16 +0800
Message-Id: <20260818053816.27502-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260817061955.45454-1-hongfu.li@linux.dev>
References: <20260817061955.45454-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ABBC920004
X-Rspamd-Server: rspam07
X-Stat-Signature: 15hcowa155da1zsguiazond8oxhdudce
X-HE-Tag: 1787031517-790661
X-HE-Meta: U2FsdGVkX1/T4fY/4pCFenZBd6z2fE2A3FoOiAnIQlClBEWD9/nEExH8931pAtSViiA/+DLBHdIxDcm3kP+Xqw8nTxmXgsTg0sG73Nebz+z4nvVZX//nbYO0+4Z5xSX/CjLdHy2lzsHA3F7gA8OobJ4oyxnWzkOEo84NsSZV7NnZ3Kr49UX6lc5lPKhTKv8wk7C9D4q/c8oETUwP76YofIS/6/m4unofpdj69RZegBG8hWFoqcmqLM6cJhsTMdRhPQlxYWXdLUW2xw8W3BsC3bdpqMkgZzdsTMMWMjReYVZM0It82yGvCqYrEead3inMDzoSPU2Y1Apq7R9/uczNlGDLjG/ulvhbmlS3sQSjHv/jDGtISt5UzagHwkGuIFDamnq7C4MNCAVxJ2faSg3igjcD0UMNmrDrAiwiOCYZDrEs5+v2Jpee/OD4oPMrvylWUtW7Qq8GdtLBsVzEQYw060o20Aw2Tw6Rhd9PBCftRttSa7XjeaPS4Vg/x9WIYPIQ0SXISxKLzPHyho6HmNafcYy+wDLy+MBW4j2wCzGi8ClpDtck8lE67841Vv8aR06/sebSVhGYM/XOWFMiH1GHNQl3RUyDDSURviDwpdF0wvemOSgFPc2CnIOSNe97rh7wMijroOu1aPwN8M5AVQHbs57FT9mO4Wth4krIXtwxaIe8kACSwhOl+WMaF5sXhuXYmu3bYQaTdW0Ek2oKnqRHhZ+K4t5iyFY45H7z19aR0IMSD/xRSI3Jxy2EwHhowp9C9UPiAgQyOGl2u96I0NFnXls9lHomiN1ZEB37qKDEyyZvubR9ee3gi74KaZZgMGySyPKzFcRy4uekWZetIwnLD+YIkc8KeARNqgcvUl/yyq4eU+56Mo/hoYZeUQiUwf4kv+r5uNNz4yNkC3YuHzbQuSTm03cBM5WJkB6NdtbDA4uvT73+SaL8WVCXi/RfUCO2uhOoW+Z2ZDmTaC4drUo
 zL6NMlAW
 lSkFHSxIfAQfn1KtUlUqvLq2jbqqCwHKLmPe2PR2d17Ovj5wIaUkakEkkUG+7/11BxOwiUnMAMN3nMfBkwL0w11lzSGfuXxLhQ6dLc46Sxl5abTsWOYK5YgIo+lcvE9ABqrLZF4jI6fWEuBsa6ZRvDbHTrgosOIns0y6E/+41E+YALarp38ywoaOTkNRP3er5xxrbL4c2gdmRkonmoydNTofprsqo6lAZAaZdYE3qBzHSUtWKKK4CrjDraCx+LH+y8ZMxMUkszHxNRX1FzpbmlRA6vrS0JHE2NdOP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Aug 17, 2026 at 02:19:55PM +0800, Hongfu Li wrote:
>From: Hongfu Li <lihongfu@kylinos.cn>
>
>Replace the perror()+exit(EXIT_FAILURE) pattern with
>ksft_exit_fail_perror() so failures are reported through the
>kselftest framework, consistent with the rest of the file.
>
>Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

