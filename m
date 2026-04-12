Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2947E937E4
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 14:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2DA06B0089; Sun, 12 Apr 2026 10:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE836B008A; Sun, 12 Apr 2026 10:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4276B0092; Sun, 12 Apr 2026 10:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80CC66B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 10:44:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 115991B8CC4
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 14:44:41 +0000 (UTC)
X-FDA: 84650175162.27.DBA67C2
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8CF8AA000B
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 14:44:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XuqQDI7/";
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XuqQDI7/";
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776005079; a=rsa-sha256;
	cv=none;
	b=dah+wcDwhejQ7LuDdlUW5Ved5dq+JC3+aHmj1sfZ6+6WeACaTkWQthoiSvRwLYghc1TEAS
	8kg3qC+7VM3qr2u4eYl7N/EgP6xe3Bl3bnZu/dZQzOOOLP9V/tlngkxhts+BU5I95ONwZy
	7P6vdTdR2FeU4a4EpDkCmNabTWVWBaY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776005079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SP4JZFK73O/7PhceItvmGe+PqzKRPh4wfXvdJo0/N2Y=;
	b=pnu4LmiwyCt7V8KfrIwFqiXfVuC/4BMdSZ1q0Wxer+33AKLYFR3ybCVaYeaSuXFLCQcHHs
	c9gOoFBk8VV3+hrCeoaecvH3cwWfeWue3OWamGiGn3lKKYTXXFmoX7XaSQWHwIalenaN7z
	UaU9qCClan2ufAaZ78b7Zn4ff8qisbs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776005073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SP4JZFK73O/7PhceItvmGe+PqzKRPh4wfXvdJo0/N2Y=;
	b=XuqQDI7/IsFfda8a9LJm8tGIt0dZJ9fx8WKi8J7HtasTDIglBYICB+kHKJj14o91tx4QJw
	z4Qk+N9rTaWYrWTxEcWG/AZTpQ1hB8FexfTLUW84bsS/wkYW2bAXs4ngAyTKBTNcgBc9p3
	cCgi70F0SwIRxfoo28Lt8uwe/hf3+/Q=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 08/10] mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
Date: Sun, 12 Apr 2026 22:44:02 +0800
Message-Id: <20260412144402.52156-1-lance.yang@linux.dev>
In-Reply-To: <9432a2398caef7261ca44355fb7b786bb20bc15e.1775679721.git.luizcap@redhat.com>
References: <9432a2398caef7261ca44355fb7b786bb20bc15e.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8CF8AA000B
X-Stat-Signature: qjo736fycxfdzxnua4desq63ynb377jc
X-Rspam-User: 
X-HE-Tag: 1776005077-793500
X-HE-Meta: U2FsdGVkX19XDfMTaKF4K+iUB1belhF2qALvzxPMFroxSEIdja+lwgvQxNIrEwsWri7kREIl6JpEThLabZcXIolfr04gEwVRB0feFadmmGaDxNfvZWQ0cXKpLWP0Mu3qZQLq3NoIV41inyb2RqGrgRPh5snPSbIEt/dCk+X3cPIzUb+0Ougb4bpnlQDtaL3VFFw6+RXCdk6cIPD5yj2OjLl3HsJnlfWMC2tReAX/p5ZgbtWsS9ydbG3SQdqSehHmNRw98JePm4DzGB20Zmteb4AU9RF0eJ15SanZPOTOzP0W0Hx81YePe11qm/QACThTTfJunsfa8BkpkYy2ZEtQfv9b05ukUgA7LB2WeJ0qtDdvZ6sIRWGdu/hlCURFwpg3GEsEh3p1ViwqwY3hVL1BdY3gbno51x8dRMi7bSjHMx7nZGHkpvs96P5o1DhMPtk913wFbBb/cAWDgGUG0KbF0lZaGLaXZd7otyAXmolHoqb/1+5DygGY703dxxJEU195wR7/aeX4ZiKU1vNe6nhgjvZsZ38LvFVhKgafjxWOWr4Tu/80fgaNkat8z0Knhnyb1SxQvf8cUxPuB5vlA3bWbeofrG0V1Y4URMjSyaqQHT9YvW/5NGf3pseipcYX+fcn0wEY5Rl6Bqjq6ZqZpsdl0w3ubR3IKsfOkxSd7Mw/ZKpYXC/vmpMcIj2mDfikFXx1NRvsuNqhC10NMlONE5pOA6KlK+938dy+2ASDHmusnZKGVOX6M0Modj9OSdK9mxUm/bBcDN41RQpSZJrQ38VJ3jiyDWIlVYnqHjSU+JHIOPnLzTPrQiDacX9QSEp6Ckflb61pDw6QDCmZ5+PjT2O/K5ONooEA5RhvoOwCplLn33ma/s802wPV2pltJ+Zlbc3l/ruf1mI/XeKbG+ZLKv+KdEG6OPMerSk/sW35R/F+OS956a5ciQ2gYVvw8BD1Kq6DXASU7oeewk2T56PxQEU
 hEHEF8C4
 1bOAzdRPolBZ50MPaJSAm8k5UkWnJ4FW+mDp9eiDj4OPhqqR8xzwfn4cmSfi20NR7dgQ4i8IlnObhINq+LZ9mR/kUZ9QYHQ7tD6PC63JxFNbMYiU84Q/o7Hni7bABj/mLtfrp4yA9aU35HjqiE7nqCEQxjwX0sSDxmplmvZIg7CILeWaS2F8m0u9j4qxWME9LxH5/Pbg+a+H/7UfyAQBajtLQenTTu5HUz5/Scg1nOgr8VWb/zNhcRLZM2U96nhxNKOOR6GfJY1vbeQ5nB+GXu1d4Dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 08, 2026 at 04:23:03PM -0400, Luiz Capitulino wrote:
>Despite its name, thp_disabled_by_hw() just checks whether the
>architecture supports PMD-sized pages. It returns true when
>TRANSPARENT_HUGEPAGE_UNSUPPORTED is set in transparent_hugepage_flags,
>this only occurs if the architecture implements arch_has_pmd_leaves()
>and that function returns false.
>
>Since pgtable_has_pmd_leaves() provides the same semantics, use it
>instead.
>
>Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>---

Nice cleanup, thanks!
Reviewed-by: Lance Yang <lance.yang@linux.dev>

