Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05045C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A396B008C; Wed,  8 Jul 2026 10:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9BE6B0092; Wed,  8 Jul 2026 10:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828326B0093; Wed,  8 Jul 2026 10:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1B66B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:34:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDD6F1C126E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:34:56 +0000 (UTC)
X-FDA: 84965856192.09.FA15EC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5ADB7C0007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:34:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D36FJEsc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783521295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KR0z1qH6uK2oh0e9bS/ZqKqDovpkPToLeSanSQYH2IE=;
	b=qUb+29tfJ36LDYjKETw5CLEaYKCGGgjzT3TYbH9ymelvE4EI/B0/BmvRzhB54FgbMVV5dN
	Hsy8e6sk7m5CGgUJZP6kJ6UcdSXwRWEhBX36Em3Ywdd04XTFemhcJy2zdYBRjiQ9xkQdEb
	z5fDCdZG8Jhi8z8W3arIubtpAmgaZxo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D36FJEsc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783521295;
	b=l+sHknakKmVxw9qPKzbWY1gJYsS2o9pgrPTDsaTVdqDIKLwskCS4PXIFLcN8nMltJcC/OF
	5BYuirOY2GQbZwaMpRuJnalpy/w54TloUKRBy69HdqN7Jly0fz3pxpIZp710LZlTJLUvMJ
	Re/M5oiB+4eiLqefErJSxBvI1LtfgCE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A177D40F33;
	Wed,  8 Jul 2026 14:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F961F000E9;
	Wed,  8 Jul 2026 14:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783521294;
	bh=KR0z1qH6uK2oh0e9bS/ZqKqDovpkPToLeSanSQYH2IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D36FJEscYmwxWht1HE9CF14nZTTYEi7G76T8i0AqN+AdfbT+bSDXolYjL088bcG/r
	 oruvn1N9Soq5DY9dVQAxjWcJBmwS4BE2uRmlcBTC+qBAlEe8pmhabLZ5cp0Tw4mxQX
	 wZlt3y+DPEN1t2J53gCqSPnkDWf02Lhfm4vN6oeiSnLRyP/Uh3BWpF5YPJba1GgVxZ
	 jokGygMlT8dEdj/NruiEKm06Cvq9bW9v0bNBgLoyZR9RNqARu33CtGpOje6HZL4FM7
	 5UP61kR4I7tv+exyE5XYcJoxzPLL1Ul5+G+u6l5gVpidZUc4yHRs7UO3THliDK9TyD
	 r5ICDLTWIhf7g==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] mm/damon: update probe hits for runtime parameter commits
Date: Wed,  8 Jul 2026 07:34:40 -0700
Message-ID: <20260708143441.124565-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708135359.122587-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5ADB7C0007
X-Stat-Signature: 8brjimwns11ujnsyijci6fkgbqqmsxyt
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783521295-111988
X-HE-Meta: U2FsdGVkX1/GfEDRETKs7Him684RJlAjBbDnBJmAKKkzsbIu1Bw57ohMtW3uyEJLaWidcJlWl+i8Itkp3HU67LUxRkC65Jqp9ORPUyoPbcnty7hyTn+dhQzB8RfwxSibh2RurGfD6dboWVTn12GtWFZLcjPs3wwrTIQs4jJ4jottw1O7r98I2AtAtFk6RxjTLlF7iXbuERS5hUVmrwykXmriFRDwp8H4o7mk0WZj5blEBJkYpZNcBW+GLclk5zKpn1fRZomEfPLvpQyJaYA2gvyZSkkJolr4zhDWZL4IYGo0PsjYNXB5zWjP2WBJPUf9plPTLZA24G454j2kT1WS2TxBoyUeVrwy3hbKmhcilmknLKw9pHr6npl86yiZsJ0gdjyEocOgBrJ6GtljRmpNltxzxhwq27pYRqj4PfFquDu63L8e/sCou7HYMYGiwrxY/cvOsNC7yFiYSeWr8u/ob2AHd36RiNyMaTaksur472w9JMs0nYZBQMDSzfk8gD4VmJ3/DLzt9zlgaMKY4NE9tuKaM8AGHWb4R4TH1ahuPZBJ439h1FNQc63YP0kuAnyP5QTWNLF1jORgAwyuwnP12/O2pUpccZcaBEfxk5uJxlthzc4kL+Q5nlyn+pdwXRo8cTKHh+3ZJCwuje+e01k+Xtp0KlQxIBon5hv6mVOflKqXTUPJvOIRFMXM/5wBg1rF/IhYOmoKDoCjXOyLZA75apIoHtprR96geNX3bgSDykC2tAD/0Vo/oUGgDuJvfPYTlCyBODBLiVeYYEX26u+hZYXbi9SmBgv6Z8toFOh8ywyFdjE+K4+S2DKAiHK0LEYHcEJngOc8e7oDX7Os20MHiexIwHC2UpkOM6YA5aRsbG3IjV8JvzZ8H+d4wYr1QxTQVJkoiNlOix5pyD+DWCLkaKX5S674j2x828B/YUnuvRquzp7ZX1E0F+0yPkFv9SwD5cTCNv73m1J4cg7OsDh
 UOweAvLk
 FEeGuduTnSaVV0/a23lbpLGGhM44V8+2xqHw+3YDj5n1MJ+FTd8f35teDOjy+gzcWStUwZIAPDnaat8Mr9Td3tWu206bJDKGXdTjWLs9qenmRQXQFv2OSZXcp93RNSQ069xnEPbDFifhhUIXAhXWxKzKQ34QYSwN+lYlYVce259goN1o+oqU2CAVsSIQ0aDcblgzR94xA/uWDSPCVIW2M/JcsWoL8/1KjrD+OgfeiV6ytfNrdtUTEAVah5WpGAL1LmhTydBlTldsgQS81UknLHapW8CjlFsHDcZuF+EEe+Fw9q1hBwfheLvmyZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 06:53:50 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON users can update DAMON parameters such as sampling and aggregation
> intervals at runtime.  For such changes, monitoring results that depend
> on the intervals should be properly updated for better accuracy.  For
> example, the access frequency counter (nr_accesses) is updated.  The
> data attribute monitoring counter (probe_hits) is not being updated,
> though.  Do the updates for new parameters.

Sashiko found no blocker but a wrong function name [1] on the commit message of
patch 1.  In short, need s/nr_samples_per_aggr/max_nr_accesses/ for the commit
message.  Please read my reply [1] for more detail.

Andrew, as it is a relatively small change on commit message, could you make
the fix when you pick the patch up?  If you prefer v2, please feel free to let
me know.

[1] https://lore.kerrnel.org/20260708143130.124419-1-sj@kernel.org


Thanks,
SJ

[...]

