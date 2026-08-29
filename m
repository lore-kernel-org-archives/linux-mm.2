Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A34BC61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E0F6B0088; Fri, 28 Aug 2026 21:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6AD6B008A; Fri, 28 Aug 2026 21:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3138C6B0092; Fri, 28 Aug 2026 21:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12B416B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:38:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F909A3AA7
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:38:05 +0000 (UTC)
X-FDA: 85152596130.25.FAF08F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D795440005
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:38:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1ooxQzN1;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787967484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJ9sY7xCOOkZU7fkNPcRup0wxQveVJYgj0rNuabJsg8=;
	b=KktaHxxZjq/EbYSXdUFw+4HSTuokt45R2czMzeIUrBlYid5leFytV+MQ3lmZrY4AZ+hzk2
	+BfBTMaG04CxyWN1KoeJjDBkPTmea76mGV3Qw/02tT+YsGhcVDrH5O4FlUXfP654J9wYe+
	9y6hkoQb3l6UN/P+SDSsVAEd1EuYyZE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1ooxQzN1;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787967484;
	b=296hTeFk9jRFaqJjpjtsIAt87mkxIMZvS4Mn7uchdxlnMeCvs/SyPPhm0fKINnxFADNA1G
	Ke0sdL2PkNbFLdGpAC1vqPQp4/1SpFSGOFFor8eKuq31D3hPLcax/qcg2wol97LX85e5yK
	YmtQoYO2zyescYGgpfimeNKXc09VWQI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EADAC412A0;
	Sat, 29 Aug 2026 01:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A55E1F000E9;
	Sat, 29 Aug 2026 01:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787967482;
	bh=EJ9sY7xCOOkZU7fkNPcRup0wxQveVJYgj0rNuabJsg8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1ooxQzN1/Iis7wo4qiD0UQM20Iq0wgdIB/2Da6G96vQezHcr2GL1PY8otynXf4F/m
	 Zoyo5eezro3XDif4O45Ll5elF47hRGsxQTfydbJr6YHQenjtHLrTy/RFznmw/1il2u
	 jrr67O1j2x2g829K+t8kiKwhd/QkYrxyzlzEmTIs=
Date: Fri, 28 Aug 2026 18:38:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, liam@infradead.org, Nico Pache
 <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Usama Arif
 <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com,
 hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: Don't install PMDs in
 uffd-minor-registered VMAs
Message-Id: <20260828183801.04fd2d2a6af837cb45b60e0f@linux-foundation.org>
In-Reply-To: <CADrL8HV0nUDjr432S8AdTZ_HO8fACrFSCu8cS49vR4XJQa39zg@mail.gmail.com>
References: <20260828222640.1638457-1-jthoughton@google.com>
	<20260828173302.29778f1bf802a1db932778ad@linux-foundation.org>
	<CADrL8HVzfEXgE9OQfULhe6wh1kMMOALsYuCNOUkgBqtzk_LUVg@mail.gmail.com>
	<CADrL8HV0nUDjr432S8AdTZ_HO8fACrFSCu8cS49vR4XJQa39zg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rtzib9ndymtqq4tfqkc1cafi3w1awn9k
X-Rspamd-Queue-Id: D795440005
X-HE-Tag: 1787967483-862816
X-HE-Meta: U2FsdGVkX197xWlC0qaEPcoPSV2YhwYRxEsTQ5mR4WGE3AlUPQ8HgsV7u1RqGXOJYTSYkoAxHfJfbe69eBPQDLKYapk4DeCl3uq9L8DaMIGCGsw/E/gvoD3oMzgiDWfCjtQP1TmOw1lkpJAg50cklnf6NfN6w36z7Wb+3NuAG3mFtGm4J8xbctGmReT0/3Qh3F0e/Ecv59DQNNVNydtv8+btkt62P8eGO2DZQcSNwg6TOCbqzv2LO9S8aCj8KQTB328zRJzkb0RZbXINjtVc4P5EmA6sNsox99XqRhp+zy1NL0RqYVao8cs6bFEcq7iJbfngySKbtAjoMh+8B53cnwDIr6xEtc7UVWpQvJOZDhkuWwNmbLWLDXdGEwnTTjKhs492o/LDGgC5fxdKIfqwovkGhCMc7GU23V7WN9dafyFpb7YMParbdbX2QCJB2N62C3fk7gkYV3n2p7I9tPRoTpU+bM2tdjUGyv0B/tMmbzY8cugQ9Lw1eUGPLL2CORt0lnazFCldmCHbXqh8XGfPyYvrpV7SxwVoxsgDRpxf8h+bNEfAfbBKGuRSxITjAYr0kYyoWTKvCHu1N/1Uxlm3yb1RPGtEA4y/xMoSzqaHB7Q/G7m+RN1lCRFNn3jCpeeFxVEZQISn2EIBMKbtyAHCATbLdYBdIIPSI73o27TolurXENwqr5ATFudY8C+f8mGfoqgIQK0CxPvWakUfktrb6rcbKW8XQRtoHpsQgDEnMk9ua2lr5HKHqhW7zatZvhNWKcvXN3HdVhQ1kxAYIVv5ZeZbxLhT+gTewIoE5WyCef/8U44UqlY82uWf8xapgZs1xbcLf7wJyHAeVQIkHLzEhpvCHwW/X/R/ioK4ew3V95+e/3yWqSt6FWREbkC1GDHVGAn74SLHPTPlt2BHpkasKxygjCWmKyhuiGAtQTiK3kf8khPTbv8yEFt84Zb5AfDf/77Wl+IX2bsm/bE4nJH
 gJttCyGo
 1mzZt6UvugfOOXsAumaQWEpGQchCpecMQhlZz+xrfnjLBSntvm4pcCP0PBL74JSfE80dJLCsxozy1+ARyL4zI0905K19v2eYOUI8EUqGjfExEaja6Vz/C689OseL9CX+cwaqujIqCrjHFGviPt/Y19XpvfhLxhgQ6+pPGu/soFX8kRXQFPRDMsGyE5QoV/Gi7qpa2sHgnBT70I/RDqxW4IcpsHdUe7TkdbSBfZnqLCN9hUVUjJdIrVye1XO8oxBFFSb5k61zUWHBtmy+a9A+/jpplr7h6TBNHkNTynnb/uAE/ghYWXbMiXnzfyolQ5I6Zh1v94LQvrdtRcxmywxZZVVQWpFRfnaMDtg6ZXdB5FloUwK6BCUjnvWthL/xUq0Lg8hso
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 18:18:11 -0700 James Houghton <jthoughton@google.com> wrote:

> On Fri, Aug 28, 2026 at 6:09 PM James Houghton <jthoughton@google.com> wrote:
> >
> > On Fri, Aug 28, 2026 at 5:33 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > > Wondering what Lance tested.  Was he able to reproduce the bug?
> >
> > I assume he just re-ran my repro, but yeah I'm not sure, heh. Lance,
> > what did you test?
> 
> Ah, just to be clear, I linked a repro on v1. Here[1] is that repro.
> Sorry, slipped my mind to also include it in the notes for this v2.
> 
> [1] https://gist.github.com/48ca/d399bf534158e80241fb4937ef1ff664

Cool thanks, I'll slap this into the changelog.

# ./a.out
TAP version 13
1..1
madvise(MADV_COLLAPSE) succeeded
ioctl(UFFDIO_CONTINUE) failed: File exists (errno=17)
not ok 1 - memfd userfaultfd MINOR continue test


We do have a ton of uffd selftesting code in there.  Adding this case
to uffd-unit-tests.c would presumably be pretty simple.  We don't
really have a policy on adding a test-case after fixing something -
it's common practice but why?  We already fixed it!


