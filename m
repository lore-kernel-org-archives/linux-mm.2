Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32784C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416396B0092; Thu, 10 Sep 2026 06:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BF216B0098; Thu, 10 Sep 2026 06:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4F06B0099; Thu, 10 Sep 2026 06:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0171C6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:58:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52E2EA4DFA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:58:52 +0000 (UTC)
X-FDA: 85197554904.14.814115B
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4E09540005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:58:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M UOd0JG";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=xsdlfMfD;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789037930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rq8+VZe9m3+SZ5mDhMiptVPE8GsBUkNqnozCNT2sD4=;
	b=WQ/51Ve2Quh05HM4tXNjUhOBo+eV3q+4YQyGAvcMKx/eXOY7kzMjTwxqXO1YE3RLnRYMos
	apqCShKcTiaIvRLZW+gAMhnunzILhdtt/HrO0rOTAsc7iXABGA6vV6NUj0NkmfF2IKzzrf
	W7pYT6ijgrqWg8vCk78owI+oF1nOUK8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789037930;
	b=JvtUrW/Ai3IybL1Io/EIAsclsxmCsCdsktQ6QAFdH8O19P+5r1lEapZtDiFo5A9PA1t+Rv
	DUIHx6sH9hhzDaOuKQJW+6vMsoPmWUV6EUrpBvqp5Eoi13S9XTNtDjxBLc6kSfDwrlkTls
	uH59tkITH5Qv9bOoDcD+MK2oCbn3aOc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M UOd0JG";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=xsdlfMfD;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id C98E91380361;
	Thu, 10 Sep 2026 06:58:49 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 10 Sep 2026 06:58:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789037929; x=
	1789045129; bh=8rq8+VZe9m3+SZ5mDhMiptVPE8GsBUkNqnozCNT2sD4=; b=M
	UOd0JGzsof6Tw/f3fKG+9RvFHBo+3ZltjPzRALwV7VMqGVk3VEi67+RwTsR1eSuL
	pR4ZkGCyPKi/fFrm+188fbknixnrQCMn7UFr/zf9ck3WAbibLb57gI0ToSyadSrG
	+ND+0v5dZvg6xG+8Ih6qlgbKlpZwnpw5lAh4hrWgTY+xnbUEDcvQf6BvayKxsyNx
	03ke9OQkhSihmesz8g3W+xhry5ggnBOyHeoUjta9Y6VvW2lyE5qz/yRJaayBwQ8P
	UmnqAe8WVHcg/kj5G/5609iq/mXgUDkt3HFV/xgAL9xf508wnXl+RrowI55kthVx
	WjO7DfPj6Zj8MalZ+kYew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789037929; x=1789045129; bh=8rq8+VZe9m3+SZ5mDhMiptVPE8GsBUkNqno
	zCNT2sD4=; b=xsdlfMfD0LeTIuhdM9cMVGT6gzkW/kR6lP78adODWBI1/nxW1pl
	E6bRGv4i1R5lUHw204tlLh1Q0iPLitDaiYqNdAFcIwPfvAX82GVbwG23nE+EuM/l
	I3w+HzWwq6d7650tbGAh16tOx0BpDETwrbyuf/teCS/J3hEuMC7HngtLAVAFp+gb
	QCyGVKk9iYBDJ2VnwF8l1aPE5r8sHOQQzDP9NBbwez5bsJ5Czshz3ZKlUUfR6Z0+
	md7M+3W6nQScB9U1nHcP1fYwMPZkH+HvjcC3Wv42WF+jxYhU4b0y97hbBnPdM7P+
	owOBSlMaTo7OIaCHr4Qix/6IL5Gr74Yl+ww==
X-ME-Sender: <xms:aY2ialLvl_WCc7qdPqTqmj5eBTFxLCmXxSoABmL8Aoaz-0TBF99LWw>
    <xme:aY2iah2elLMUfJxA5VCBgApIWBWErk4KmLrga9H3OgS0nNPSpelQzh3_6wNwLWVEX
    XhU_LARc8u2d_iXAvy43hObRo_HuLeERpNBqKusEaPRlbtyn71cvbA2>
X-ME-Received: <xmr:aY2iaozHCBSpgemmONXPJlY9FJ4wb3IRR1xdPkqDA-OTePbYja-XRIi2nuU>
X-ME-Proxy-Cause: dmFkZTExGDeRAc2ZQvQEVOZg05RC7pzdHKVkkxCU4OVzC6eJ1yiq+dkvuNpph491rCSg99
    ItVtML130B8ODTdy76InRXCLDNaNNaTXWNKl71VlGzapLT/PKpaq/yp6tPxANkNdjNuqob
    hUhC5q+z3VJokLVhtdnNzOHq8HB3Gu5Ki3O9wHHpqx6QnVCJ6Mwr6zY1sfs6ioIkhduQB2
    cjK46H5gyRhde+ukXeSmJg7XmiDbNE8++i8Ylsv0wnJwn5W1L9sKPmXxdBB0BYsnvUNs5B
    4qHkIOL9/2e667KRTruDA/HZANASE9ZIxHm48xWT6Jg9ai0h943Ghn3IVLvfn13XDvCjWC
    0hRqvm9u9adAy2D+4EpHVZM6yuOMWdhRnjzsZB5kJ0ADlfX1onAmme1T8y2P+48HIFQchS
    qEjN4eKKs1AF9A4mhjZaVwcsTcCBKxlFqQAbHzVDbf8DzIoi+Jtk/TxXjO/+flg86voCiX
    dhNKLOMU9XjrndOsqW7MLO4WJzp3yIWBo+yobvdolW0KAaHb5GIbWwJb26nfk816/+Y0ei
    YILLwinyWechbH064xPUfH9j0eIvLki5zXBc7OicF8o1iEyzSjhXmeI06hKwf9XUhhNHoR
    yrw/i5fQ96gbg1R3fsb/+xsQTKZDCuda0G9Whk5F232tiBT0k01IIP3DDOaw
X-ME-Proxy: <xmx:aY2iamaQ5SqHK0oPst2FfYuUfBxWK7qgt3xX8kecxTwzAyPmv5NSZg>
    <xmx:aY2iavWo1CeHlbBOgBInrtMf8TRHcyZuwHyDue4Wl5HWyca1GH937A>
    <xmx:aY2iaqoZeUR2u2AenOo45yZHgdJREwfk2QxxYul2TFigf3LwPECzng>
    <xmx:aY2iapfNcvy3O7uYvLQGZG4cubkpnBqK3r9VnKQXzTNF79KocFpHjw>
    <xmx:aY2iarJo2Z9jMZyZWMLKPrpfakzi7KOERrmJpOzS78IY3DY6u0dZhjCN>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 06:58:48 -0400 (EDT)
Date: Thu, 10 Sep 2026 11:58:47 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev, nico.pache@linux.dev, 
	ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, agordeev@linux.ibm.com, 
	jgg@ziepe.ca, leon@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 12/19] selftests/mm: parameterize the mixed-source
 collapse case by source order
Message-ID: <aqKNHUI9tuv34Cqy@thinkstation>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-13-kirill@shutemov.name>
 <4aeaa283-a417-45a9-9298-8123192dc707@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aeaa283-a417-45a9-9298-8123192dc707@linux.alibaba.com>
X-Stat-Signature: 8gs9zy53uxs8tp78p6j1bz9gszw1wd1a
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E09540005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789037930-634435
X-HE-Meta: U2FsdGVkX1/U+giQt7MkiWzXdVPv0BtfVyzDsdFXjqbKHvPVZO+vUsvFkW2QKsTtTYfAqcD92d0VqieOva+zbO15ezFJ0j40cCcBTQvFQFTThJ2LthcZHUoEkUXRgUqwiwCC2sxP4zdFTQe5SCgvz6cfXTLDBCZO530iaMxMFqrnbEGAeNUsZFcTB+KwUO+skwNko5G/N5X8me/cmVuSZNSu96IrRorRt3ZMoq9SylVEO2lMdM4WP2CPt8UyutAr/5t97+FVhd1Cs0fmSmdml+lyFR8IKkb5g9vAt0svfFK7tcFl/1CMyZl92Qx4HtvdnWH7wtO4F962/2irqfFhX0A4H2IHjq2w2X6QtS0fLNeqbSJt/AA+8pBrqZ9d27YNLJ++9lfXF0ejEZzlsq4J/+nsRGf5Hb0L6bkfWgMgkPBdxq23IKGhnBacqDNGHW+IFjtDq7FLUwfaiA6K00uYdV9q67vFvFSz8SPo5Jua3GVJOv/vuwT5SpQL9In7jgp8FWMPftCnzoobL3I2SCovRNZw4kAg8rU768YrbFRjfYIwm75FUPb5vgF2k4sI9CSZOaLSzi1IasXf0YxRKG/D1vxkdK03HVMdLaVVf77FqMWDrsOGVHQzrj9+26BkO+RTgbdl+yt7Ka8BG/A821bYxMU/FKEKJAN9RoQm5JTGXstnYEaSPgKy2pRqxXiu/9b22cZfGmH0DPmTcna77wpFszL6Pl3M3MsA7Avu1rlkDXPsWbN/q8ybuYfdxbYb7hxvdtpKig0U0tAxxp1af3atBfPpMXgJm2HFg78dLJJF1/4CRMvizlwBvKY2sDeHk6M/PAmMWJEH7kjC+x9G+rmSn8XZYYA268Sg3M7tHpWtHy9LSYsxI+rVVYWmQsTaIg2Xed15kdCnnLqQWcjgvXWymlhaTMhUnFPHw97Ci7n7A3niAucjLI8lkMqyET0COAObW4I24f4JtTX6s0KWFrr
 Dy86pIGa
 ibafEkbbzntzUDbjUL/gOSBieaOTZfrSx1pxKo3ZdA3VDsIC78Tgz2Wl2Pt8cYmAQHLWUm6ZFVBjpg7fwFRCVDQIzOwQmEWa23v5amT7Hg6OoeAh60VUfeH30EQhvzMtNs+7XD6j7BMEHORJ+nDQbf6n+69bcPUpKdKxgDKZUM0fRdiK9b7r3iLxXIRDiuYCY47Ci9lBtViWUnBsBrrsIGdE5v6y2JFSblWEe6SiEUm8YN2sls5HOybsMqyakLQuCPo1UFM5+pP32UgxOHy+uD3WoNLPhM2xMMCzMno04nHSOFNnl1cmS/RMpZbbvH0bt1KdiO64S0t0hJRW4/dpcOlrDKBn3OvYBZVaTzEQ+Bzwtz0KccUWOxEzUj4zzfHEu1ySyGaAXAlYMmGJwgWCVG4n+q+Nkh9/0W8IQhleQqZBHmskvmne/GLEOmzBEg84me4K9lcUf8dNMfMODOhtv1m0SPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 01:09:00PM +0800, Baolin Wang wrote:
> 
> 
> On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > collapse_order_mixed_sources() faults its region as order-2 folios and
> > collapses them to the -c target.  Order 2 is below the contpte size on
> > every arm64 page size, so nothing in this suite collapses a contpte-mapped
> > source on purpose.
> > 
> > Let -s name the source order alongside -c.  The case then faults at that
> > order, keeping order 2 when -s is absent, and the source order has to be a
> > supported mTHP order below the target.  The other mTHP cases are
> > unaffected: mthp_push_target_order() enables only the target order.
> > 
> > "-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
> > larger mTHP.
> 
> Make sense. But we should validate invalid parameter combinations for '-s'
> and '-c'. For example, when I set the following unreasonable parameters,
> some test cases fail, so such invalid configurations should be rejected.

Patch 14 adds that check; with the whole series applied,
"-s 7 -c 6 mthp_khugepaged:anon" stops before running anything:

  1..0 # SKIP -c 6 needs a source order below it, -s says 7

So this is a minor bisectability issue: the check should have come with
this patch rather than two later.  I will move it here if the series gets
respun.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

