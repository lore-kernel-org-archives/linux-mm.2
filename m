Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04552C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 17:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182CB6B0092; Tue,  4 Aug 2026 13:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15AA36B00A3; Tue,  4 Aug 2026 13:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074266B00A4; Tue,  4 Aug 2026 13:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB82C6B0092
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:33:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55F4780264
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:33:09 +0000 (UTC)
X-FDA: 85064282898.07.ED2DCDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B87E940011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:33:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bSW/zCu2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785864787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cTaqMzgFKB6BvCjR+/Mj8L7h7lMTWPAYSPCWM72+Ja8=;
	b=WTjggb8OKKrFkgfYOgsMUt6xhc9uE0KLP30mbiQeYoYzU9XG6mlEvqfGmhyJei1MJDsb9o
	Y0vmpizP3/l6+PNxBogYq+mnLzvs8aQonAKSGOlWToJnLUHqVa4OlNscKbDXEVOGdndBwv
	ZwOx5/xV7tqlrVJ/dWWexHyp+2jfhMI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bSW/zCu2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785864787;
	b=hrO6DOzmvyjDHJ7ZlPalCOpm4qt/o56AiiVNYxbwPUf9Zjxpgtj/t90wh1nm3ksz/DVyQb
	90S84ws67cKibHUdmIQQVGzu4zY68DQXIC/NEuh0jDGUym2+6IkPyM/AdOoFIAISH8UWZs
	RIj+3Cvrj4vvQujywFPBSWacwpKIlzk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2080406E3;
	Tue,  4 Aug 2026 17:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF54C1F000E9;
	Tue,  4 Aug 2026 17:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785864786;
	bh=cTaqMzgFKB6BvCjR+/Mj8L7h7lMTWPAYSPCWM72+Ja8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bSW/zCu2pqN1wyQJbp3qqbY97+FtE6YoCwLIy7QWHBOdR2OZssMnQJaHk84GfbWW1
	 At1hCpU4kt/XExzHY8E0cBRDNl7dhDPO6qhz5S6Ms7OnzeU17RRoh2dfRIoyJW/4YF
	 0NDu4bpq07VS85t1qupING3Z/E5e6UvDlPbRxSHIJnVLnY9rOaHMVL0frWeBdMK5tU
	 spEURThLmhVIwXZH+Hopsk3UXu05Pd5xlehD7gA5VcXRKQXhm9U4BOe6rZuhSVrzu2
	 mgKRgHY4j5sGAtT2fpEg4iw8NN9Med1DIC7q4eXUL+1ug4um38g2r53s8geo49YlK8
	 CiXmBChnkhmKw==
Date: Tue, 4 Aug 2026 18:32:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, 
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
	akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <anIhSGs70TTzymHM@lucifer>
References: <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com>
 <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
 <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
 <CAHk-=whjfRaeYsAVS9VfYO5uaSB43sT7zPOmNWR6gC8h=t60=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whjfRaeYsAVS9VfYO5uaSB43sT7zPOmNWR6gC8h=t60=g@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B87E940011
X-Stat-Signature: py449db3aj84xwu5o3x6wbij3sbks5pr
X-Rspam-User: 
X-HE-Tag: 1785864787-732335
X-HE-Meta: U2FsdGVkX19NKYWlN+UXFxFCpzYIrwBalZVnwNbGFCaeDJPokvHV4Pd9nbR/i2l43Sv+Qo89LuZCzm+09KSpqnH5VtKZtL1oAamwDXw61W/od7FmCny69LHIsaD7/qKE3K7U1M7aqqfCeUiMJsdMOL5FX+y3fo+XR2aNDwlDQQx6OK+LBggj0+xxdrOZhg50I/M4q3x/sW6tJvopLCnNjGA7RC2CGX0ZZPEKn2B363rNw5JqRy/Lu/fK21ZaMzWXH6wzl0MWJ3YnvZJq2q4zBIZ3lJmAzkSlNwX9P7ElBFbNe2YLp5QTZAI9fNQRSRGUbNsAx1ksnkeUVV47eKfD1AFGVTwjcPHHzrmXIeJDzUb531HQ+uP9jWgIdr30J/SrfMzBT8hqUO9eMfwNt9Rnuy75JiPqglXqz2gC45pKkRQpDG9CZLi5kZym5gsTu3BQcGg4o0NXCrlUGw7UcdvRCMOQNImjLKHywlpuZfdIBPJdub9eO1qbnG+L0peJ60CGqP7FLTABa+o6flVZDnqhAdu5JZv3Q5OXKtjCjWH9a10O9aRZVz6z+MZ3qTA30ugqGwNZVDJ8i/DirBUqFnSRqkwArce5dofWvy9nSq0wiGpugxOQe7Cz8XGTlLE33dAzL6j7Drzy8wC3H7gJEZnIh8+V/CfnATHSFMg+yZM4F7OIFd8B+Tsky1agB1XOs4Gt4lxwADnK0hOChDY8cy9Y1JWSFj8q+Y74qSGPESVIS17h950qfPithfJerTKQXjY3B+UT2qcJzOTR0jKTBcntc0oVSZvP6hAlA3h//Y6ZzFDBrlbuarww+WSDXfLoOyhzRrAakmbrCY2/GSZD6j03sdDtzjdlCmxbfEf+pxeXod1UYAipo0O24whGtXzaq1hNTQphoHHXpe00zhL6ZZQCh3ynf4L9kaCsO7MHwhquRIUNgiBMv3i5asMJ3Hj09wR+kMAGTUocRzgx1l72/dP
 c5lK0Tx3
 7TwO0HluPyTxCxDO6CzJgSKJ3T/Ql50cZrkEYGCktXu3sDXAY5wAHTMfUE0nNiAwQ1FvDNOqdqU5vgPJIKzWilVxbiiYODQtxW0biaPBPoYuXMM/uBTbiojVD2THmp0/nQXvq5WEfDbdUrwhwqq+KrvqHBkTDEIVtS63Lz9dtSRAT5Y41FW1aVZZueahurKVS9JpQVXdmxj+NRBKA/MFD/NZTWfew+voMVvZuzPWicSNCEE3Yw89F13aMCJqTERewjsl1Rx6TGBMpJWvsXtTLk+vcf7XWmDrLYtY0n+eZg0xrSTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 10:01:45AM -0700, Linus Torvalds wrote:
> So I'm just trying to clarify my stance - I don't hate percpu TLB
> contents per se. I hate the notion of codifying them.

I do worry that changing per-CPU data structures to support this is exactly
codifying this (and will encourage other arches to follow suit).

And I really don't think there's any way to implement this without
fundamentally changing core mm or assumptions that core mm can make.

--
Cheers, Lorenzo

