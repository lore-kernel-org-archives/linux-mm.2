Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0474AC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3316B00AA; Mon, 20 Jul 2026 11:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B542A6B00AB; Mon, 20 Jul 2026 11:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91616B00AC; Mon, 20 Jul 2026 11:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1666B00AA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:40:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08E82A0213
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:40:14 +0000 (UTC)
X-FDA: 85009566348.17.FDA7ADB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6A7164000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:40:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhRzioJ3;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784562012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZcL0NS9UpRaSCtUj7Rad5Ll15ZwncTALu4PwSS61ks=;
	b=uERdXS6AI2Y2z2cAoASzwieGzExh7bzFjqX1sfdmuh3EWrm/SqDAk9wpZ6cEC5/pbXEiDH
	LK6XSiJ8+Ev5bxQ71PpbIAlZDocttxkmXFxVBPer7XXm9ZaXlOiBbSV7HxfTTh9S7b3ZYq
	K2x1uE/hEpgP0XxqHckydMNmCm6rp44=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784562012;
	b=KYW7bv2AxPJR71Y+F7y2qlLzQKFI+wNc9/KxjethMYs8EURnDY2MjxLujXqL5GctkmHujL
	1To1n/52a2tYSJi+lm/hnWvviaW1ZLSqDobhWLWhZsoJGxUtaS2yAP74RHwpergO3MlBMV
	HxGV0a2M/SPV82iIWFDHHwc1LIcys5I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhRzioJ3;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95DBC44033;
	Mon, 20 Jul 2026 15:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110041F00A3A;
	Mon, 20 Jul 2026 15:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784562011;
	bh=nZcL0NS9UpRaSCtUj7Rad5Ll15ZwncTALu4PwSS61ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AhRzioJ3AvZdj57ZXtxcMS5TWOIf5mfSLiqb/67iqOEuXyC6f26btHfgKs9XzC+md
	 Ho3YMKgvb7AvtURE70XzahSq0oa4tePUOpHsy8JQMTJFw3NJZ+B56+N9msQrTk8t21
	 XzDIxPVom5N3NfQsy1gFa/066CEc7yyVdPLEqVr9CjKDEqcKRQ+PeIDFTo857H/d2T
	 tN9F8rZvBh++bfiZU+mkMOexdvmc4eHYXSHuCWVhgUr38qiXGaQLhLEVWiB4brBJ4J
	 rI7bxUI6oByu0GRZ5OJQBOkVpQhfPNsm1aI2LLdsoBctL2/86uRxDLECVLo6OP1405
	 BEXJP6ArM/lsg==
Date: Mon, 20 Jul 2026 16:39:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm/khugepaged: separate out windy folio logic from
 collapse_file
Message-ID: <al5BLXCh-k7xx8b2@lucifer>
References: <20260720142913.846902-1-pfalcato@suse.de>
 <20260720142913.846902-2-pfalcato@suse.de>
 <178456193510.466529.13761189910586879195.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178456193510.466529.13761189910586879195.b4-review@b4>
X-Stat-Signature: ui5yrroccwrq58d5x9doqwzof4g6dyj1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A7164000B
X-HE-Tag: 1784562012-445936
X-HE-Meta: U2FsdGVkX1/OuPuawbB2qWHQoUFu0SkC2PuTEx7N5GlLIXxl3QfYcy1PjzAp+kTdkpVfdL0vcuTpTEzI3gkNbqnE3xcQtq3sDBmzxgYM5uthSrigBGt3Qc4bEZoA8BBLkSlp1B2klw8gjKEMJO96SHjzs1mUyqj/XvQ4LLIf1WKMHidAOF39Mat+jvoQiF1MtMMCsqFrD/NB1tL/KZ9UPCP0nY0REu1OOLewoQVakXDw+BEdbEFr4Pquq/B8XPNeQM0J+ciJZxUebcxzmYVWJSZMFc7ZQPo5nNYzMyrRtzF+flqwLXoxXRgDHE+lx+26q+ZGBXOT5tMGPR1K++KLxeMWapMS/42WQj7hO+nAdr9HN396onG34/reBT4DFbTfhzPHT29Oamqn9HXpK7oRKvDNU1h6ZDnmaDMmfwkIwUq5yH9KCERsWQV1jIYhUWQE5LgQk5AE6muZ3VVZ15wjdZKc4OQQZMJEmDMdTGUWq1k218Tf8DaJTenbkrdVvmyTMOJ9ew7oiWkkL/cdDisqv94WYaHru/yZl84QQWtH3mM8lnIJhiusF49onFkYu+Sb/hwX9AlQPbHLDWjQpUSCtD68WZQG1O1PlXqAkdZ6+JBMI0fsiJCbM3A5P2DmHMysGT4gQSl73eTFOYJUuyREAE4OQ91amxnRy6agQVzr71tvA3C7eQN7fK9b39dxVaUeQS/cBgDncdhmzyOftU3twxAvchDUUDLo3kEwj04SQ9S8ikT66BZfVM0yxD1aJhLK05rwPYROUc9us9J3DQ8kjDIfPCQCeHTLJYQ92VQXL18aMUeVJsIczVLWBIvO4PF37FxB1hqx644kl1phqc9wxfTAvvE3qQL4cE8pK2NwS/kdMcTVGWwhvDbkYOOvF3jIj6tCYQ9O+nzskq5Jv8Y9LC74gXmu3sq12MuZqiOXCqdWqqBw33uaU1anDq69cF+NSI4k9kSRlJ6Be6ICToE
 pr6faSyu
 +c2XUZbbfl+wK371/Cvd2I4E1xdxsblZs5x6ottpEu3r2+tOXUdaznua8Ie7M5n9D3Pc5BNnriuSf5hCqwfucrZijCo726ZZL51HbXwMBzDzJsKHrne9VZchNsVj2k5lFE/0IZlQExpZ17uTJHNvNLw0qzcVmNYzAhd2PD2UZmI1kxOO0S9ikLm4WyByuMyLx5WaqizofT8L8pbuxPM2wEOzfk6RCjRNyAyzqjMI1f7vwkDJRtVg8xxeryVZsWqN0evymqbBBwVz0PMldgRVapQ7o6Y4/FCuVyvmKujT02AIeNFw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:38:55PM +0100, Lorenzo Stoakes (ARM) wrote:
> NIT: This is 101 chars,
>
> NIT: This is 101 chars,

(Please forgive this, b4 review converted my nits into tags and I couldn't undo
it so just sent it :P)

Cheers, Lorenzo

