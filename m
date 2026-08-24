Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 922ECC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FD8C6B0092; Mon, 24 Aug 2026 13:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4EC6B0095; Mon, 24 Aug 2026 13:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB266B0096; Mon, 24 Aug 2026 13:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 601FD6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:00:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD7851401D6
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:00:14 +0000 (UTC)
X-FDA: 85136775948.12.C25CB91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 38DE7C0012
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:00:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJ9OvYKh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787590813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nct0GfFThXU+uRAh3/FXFDpq9aYkue9rlgNBVH3JitQ=;
	b=KwX7K2mhbudQIr+tLGn5tNA9B2k2+maEfMqhR4THFoTCw+wewNx51sAc4YWEdt+niPBIoP
	908jSWMWDx7GZxHUVf0Z4kDvpg0AC32S1nJc4WpaJpql5igHg8160tHd73OkLbJuoy6wve
	Xt3dRag1qTs8tfHJokXMvIOvzUxzbhc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJ9OvYKh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787590813;
	b=ANIP5uVLaXigyAx0khKJdBfgB3pRnqt53mV2w2pSpt3HsipyTzGz8j0v14NPI2UE0AS/2A
	yRnNA3BgryemnsnLwjqLS6z8SvdhQm9XdcfmM4nrA3c8H5KodbNbl7MLyd8d1SKJ4E+SY1
	wKYMwWq4aeOfAcDIJXs6223Cx04wsKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA3DB6013A;
	Mon, 24 Aug 2026 17:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771851F000E9;
	Mon, 24 Aug 2026 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787590811;
	bh=nct0GfFThXU+uRAh3/FXFDpq9aYkue9rlgNBVH3JitQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gJ9OvYKhhQq27htNgGOlt/P3H6X3YfPsxzL1b0quFovndKNySknU9vErizFoTX35D
	 UavqVf5YhxWwSYt+4xbQeWMObpe3fgx8RQX6/0luwvoOS8iK8/zkSNQR4139rvqSgn
	 L6VUwC/lcizYu+L0Hy4M/ZJta3h5hXKYZ5M/Iov83m84a2bcfW2ckhVXfj/xQx/QDF
	 u89w8ZEOyYZGcXQhbofr78vKqpZrPE1e9OPogOnZxnNyIRxfJKm85NVP4OFCzsAKwV
	 cCesI1wh9DSON+jHCRkNA3sKSk0vPLZOvlpP1N2TCJwNl+Gt3Myrm09ZjRm5JbrywH
	 BiOJPA9+kyPbg==
Date: Mon, 24 Aug 2026 18:00:04 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, nico.pache@linux.dev, baolin.wang@linux.alibaba.com, 
	baohua@kernel.org, dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
	liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, 
	ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aox36P0DMLqYD7py@gremlin>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer>
 <aoLkMUtmzRVuv2Hx@thinkstation>
 <aoQ77EcD3M2kjeya@lucifer>
 <0153303d-f9d6-45ea-a276-fbf2e5625ef9@kernel.org>
 <aoXn1B7cPnPq7uxd@thinkstation>
 <aoxRs0mjyQnpO-IT@gremlin>
 <aoxcN7jrfbK_Ac8V@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoxcN7jrfbK_Ac8V@thinkstation>
X-Rspam-User: 
X-Stat-Signature: fqfs3mkjz6nkbx388n1qgpbpok8ndmsg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38DE7C0012
X-HE-Tag: 1787590813-310128
X-HE-Meta: U2FsdGVkX1+WBmlYW2t1n0fVXv91/KNQP8utaHfcL7a7Q7RsbN3/jGJPRSRqdAn3btCVTW1l2GRMKHNp4SZfdF7DMkq+u8+V+7vUvDuYTSmcnx0V3SgaJFSXRsnBtDo6MK2Re6H2kO7olWpMZV4joa2x+yNdl5ieNHzq0Y3zeHX8Oev/IirJlEFe7ZdHgU9RkHfBhurXIn7N7sOgbdkDIccJfOIBaQddbmq2/qJZKBjdkGxt+mrqv+PPCTvjWfCiX/8yczMwz8SpKAJrtVnhzfHWFXnqPR67kxa7NE9t9Jow1kbQFYCeo6nhvExZWF3brGM9eSvaE3ZaKOvtGGuco1xfD5ksgGymX7GN49plb2vT39xGt+8PAK8YKucbQU7NikV93q6UFyQCGsra1BJkQY76L4DcJaq05JgwSfy5yGz1L19Mr36ANvogvzou4B5i7S7OotTOFpVjgYG+y/xNAx/xthlCr1Aufbkqm4lqzhdeAq4bBxS4kodg1tJikoLKmoejKJBUQE5ZDLlQot2zHxJo/k8acaBvQ5sPzN/bTsdBQtC7Os772JTVLexICqWBi8miZ5JiYAU9R2XbtPG3yWnQ5YpuZ+xVNf1YCNqMMsqou9xP6gQoAxj81BLmpY9DdvmiFhnIr3UPmoQ3RauO2uGBFfJ8sXayyw1QgY/idyfZ23CuT9ekD3j1OLL2WAlaNeomZbIERNC4HyssnmrTl5rAFHUn4V6xDXERZhfeiHn2LWe31N35q5Pk/H/8/1SscQnM+Qw4ZcqFGAAVRkqdxHQ+3yRKVXskUsjSqJ3sc10Gy8Qt8ZQYwRofjhsPHHS4Tga4M+iYJpnh4O7mYiu6ZpRvLpNXkOYK1Qp5U+lFUPZSJzwZMYcEWpwTUhyBIsjIYg8ZifqduJ/Y3GcsDISpDZQAOCgM3/g1gTk+egm4PlC5D4mfwk91njPXsholW9KY+2c7EkVB3dALS0kjjzy
 Ewij10DJ
 j7lKS/2YohTaK1Wrpez71tiIelHS3gZx8lhX9WJAMcu7d9VcdL0jqVI39MyJVhcY1hbwCIMGvEZFnIGjzL7vwLoTjfWWXd7eyiJzu2CSXUyijURI5tHZ+Re0S/MCVyRxJa4t6Z6X/gJvcI+JIQ3Y06lTNEHIAwUCQogxyN2loQzYL2jr27NtM1PVmPdWLmUaqt+oKlTMQxEcsRrJH+2Uz6B0zi/erUQFhAnkQIQEUkF4qioFo6VPn32LkJrY91/L3559Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 03:59:50PM +0100, Kiryl Shutsemau wrote:
> On Mon, Aug 24, 2026 at 03:22:02PM +0100, Lorenzo Stoakes (ARM) wrote:
> > This whole reply seems AI-generated...
>
> It is not.
>
> I heard David's feedback. Will adjust accordingly.
>
> >
> > You replying only to David twice in this sub-thread which isn't exactly giving
> > me warm fuzzy feelings about the working-around-me concerns I raised here.
> >
> > So simple feedback - send a relatively small, no-functional-change series that
> > improves THP code and lays foundations for future changes. After the merge
> > window.
> >
> > Can you explicitly ack this please?
>
> Ack.

Just to follow up - Kiryl and I spoke directly (much better medium than text :)
and it's clear  that there's just been some miscommunication here.

So - in general all's good and we are it seems in violent _agreement_ about
moving forwards (split out to reasonable foundational series that build upon one
another -> eventual switch on).

Let peace reign :)

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

