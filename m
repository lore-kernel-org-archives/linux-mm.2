Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 618C0CAC58E
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 22:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA2B8E0009; Wed, 10 Sep 2025 18:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91398E0001; Wed, 10 Sep 2025 18:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACE408E0009; Wed, 10 Sep 2025 18:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A89E8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:19:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 716D91195D4
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:19:11 +0000 (UTC)
X-FDA: 83874757302.20.0D84F59
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf17.hostedemail.com (Postfix) with ESMTP id D100D40003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:19:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=fuYMKNDo;
	spf=pass (imf17.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757542749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Aa9N/gAUNJUcFl5vs81AFjvfM2EnJYuKN12YGysTRc=;
	b=dLcHX68hJn+OG9E30GrjQNl1vVKWuIqKuqh8hJfYLY7dp27Nd+Nx5RRX/F5+5K0smBI/1O
	HWm0ZDH2kgXut+9FIS5HqlI2E/kjiyhiwxmX0YGeQhR1MbHC+OORT3ksSvmLP2k2N0yWTw
	1DDCPNmmiO+NJ9SF2/Pm1UnzzSksMZY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=fuYMKNDo;
	spf=pass (imf17.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757542749; a=rsa-sha256;
	cv=none;
	b=NijRTk0tanmbBOHiAqOrIj6o2m3PxebM5N7gw9lkzn4x6dhy87DESar4AzEBRbrS1wTJOp
	sJuSgK5mIe+spGFMONWknpskDDdcss5psJNshI4OXuSSn3RvCxyJ6Co2qaz/QVehPq6yi/
	SarIp5GajEGXnIS1CUgNfVSVMHrYoyo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1757542748;
	bh=dxKx7njUkG/33wZuzxP3vvrXY1NPCSRhcm0uQ0K6lpE=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=fuYMKNDo/Yft2/jjYR5qBj2/shIcRD3A4S6xqBAAVohvVx9BqPXv9xw4UbmXS+1I2
	 uj7dFXMdSYKb3gW6gZ1Skp84o40JEcIFbARGbZTxtQUB6xevecVp9maFt8zDbcrh7B
	 Q16oXFpbTVtKqzgTK0o732hu+H3NWB3t/2OKdzDg=
Received: by gentwo.org (Postfix, from userid 1003)
	id 9E8874033E; Wed, 10 Sep 2025 15:19:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 9BA054033A;
	Wed, 10 Sep 2025 15:19:08 -0700 (PDT)
Date: Wed, 10 Sep 2025 15:19:08 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 01/22] slab: Remove unnecessary test from
 alloc_debug_processing()
In-Reply-To: <20250910115507.1991829-2-willy@infradead.org>
Message-ID: <364922eb-4ada-ff27-1338-26197aee5e33@gentwo.org>
References: <20250910115507.1991829-1-willy@infradead.org> <20250910115507.1991829-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D100D40003
X-Stat-Signature: 6qzg7r7p17sihsrgyzezwq1cjy5e5btu
X-HE-Tag: 1757542749-492178
X-HE-Meta: U2FsdGVkX19Bf0Db1wBnjMWakQzhjLqDrCftmg8dJXZiShwdk1jprpby0AIWXJ+/zxLz8LWvwfsz6YGq1d/G++fvVNNs//hsNTZlkVUaz14MZKC/TFOUdnKrH7PdCH2iGziK4CcVqkgWTE42kenGOHv9upf4cqqJnMfQeqcScz9Tg9gkUElGdrOIK5XixtJb1BYMrVgYYrayjxtvm4rq9zAY+3ayOHuCIEINNhi81TE2pKzg4regtkZdLrWE+UPLVNWuzjZ8mlKOcVt7Fn1y2ojXzd+BEA2QitOOm0JuujYKQp08WIAlAYnvKYlC8LguELiPufy2ISAZR5aDL9NH9G+6FGDDS5Yv38HJkunj4HoLwcfY79vPQOHu8o81ojJs7GAvyw4pwS4hG/G3QUehSC9Wjbn/jCKk+/X3qX7shwqb3nUGcnDeBZyaKSVvfxEmUhB+RsiB2LjokK0jEAyWD4K5NbhOKbXL7nUbHse0yaIGMgiJaHvv+jNJjjyUuR5bJV9M5FFtDE2iE5IXjsBLplzrtxGJZCWgtn8sBb4seLAEtm6qaHeOblmH5R64n9H5TfurM66pjf5F+rrqq6tEI1sB24ZMD0cT7LTpSJDXzfH0vaXbk2MJCY/uFkSsefNhAUHwjm3HCFVXVVw78UATd2teA2FBL033K2ZthNNcR3vHN84Oo/by3SF+krCu6cvRTJX+QJ+mar5DzNRYEOKHD2Vk4uAuG/9YQyR8Zi9kp2xrL+NvdevYuPHcVdCrVBVeERg7s/h3D/jq9WH58q96pM/4vVUZrc9LtLcD3YGhOi3/zAbd9xdDDKW8llw6FAlL98ynT0x2C2fT8TdJNCb6Mu6oYoWucO+l4z4eQvgsVJ7WHsVT1R4I3j5roDAhw00RB27ppDvDZmLJk9gc/24E+MQgAH+XtF7HhiWijHYiHm5bIWb0wFmL9RBl4U1OG5UnEz5TXjJ9pXbzruahsN2
 8Znpixwh
 I7BgidbQ/QYzWLC8v1aYFByZVGZF517d4vLQp6v2WlpQBczjfq27nScIuSi13x00PqlSEXjQ2o0E9XXJNMAPCyO0QVQbM3yeolN6PNjo1oRUUtrZZteyNK3XLgVwPfKGsdcSLPhVXwgs0QCUfUrxRciwaGIcKv+d0v/XTRhDQb74IexoJd1BCZEc+BsLCJMUFanE/cy7qZu6E6wCUNOyRBigocppFMjjHBoBmgjTT+6FTtSkW83DWKz06P7Az2WkC/2LXLsRaDLdaPBl2R2opKA5lLggBYH/6no6dzcJR1aDUrbMg6oEoZoOoNVR3u0U/c9HjXQS6IsWLGcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025, Matthew Wilcox (Oracle) wrote:

> In alloc_debug_processing() we know that the slab pointer passed in
> really is a pointer to a slab.  Both callers modify members of the slab
> data structure.  So we can remove this check.

The code modified here is the case where consistency checks on a slab
page have failed.

The pointer to the slab page could be a random pointer. Thus we should not
assume that this is a slab page and modify values of some other structure
that may have some other relevance.


