Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B20E0C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 11:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3066B0095; Thu, 20 Aug 2026 07:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7A536B009F; Thu, 20 Aug 2026 07:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B934C6B00A0; Thu, 20 Aug 2026 07:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 925EE6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:11:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D2351C1B47
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:11:23 +0000 (UTC)
X-FDA: 85121381646.15.4981511
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf26.hostedemail.com (Postfix) with ESMTP id 90DA214000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:11:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="K U1+i7z";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=PagUZJvm;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787224280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9xsCX0WBUUnfBOKB0w7/8Sors9fi6e3DmVtM4E2/4M=;
	b=udy6np14J7qtgJEJQMeNlC8NxKonbgETBQjVSgNgdb4bzWSoDte5nwhWH8MuFbdSf3D+IW
	ZmH4VCMOqZlyr34yISJoBkK6T52BCw2iuPhlI2GXUgHSSBXPVimkh7dw1ZX2q4Wfr2DVky
	iNzO9oHd/Ul0JnUb8ToCH3UcxRM9BWM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="K U1+i7z";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=PagUZJvm;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787224280;
	b=3aruScm/lTAeEm4SSSU5r4FLvVgXXKe4MLW592CXxum5c5D8l1+tezBLrG/fw0QUV+3pnV
	Y0w6+JjS1Bj49J8Fq2mBMWc4UeChg/KDhHsam954DFmzLqEIOnLb9IakHXLXyt365Dyrom
	Zlm8Y1cIzUWAcVXEdSle5Lom+XS19Nc=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 701571300542;
	Thu, 20 Aug 2026 07:11:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 20 Aug 2026 07:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787224278; x=
	1787231478; bh=g9xsCX0WBUUnfBOKB0w7/8Sors9fi6e3DmVtM4E2/4M=; b=K
	U1+i7z47jS/fBLaFTfoj6mmFdxh6iUw05H+jTqBZiQF5VD4GNTURHHD3Nsl3AkNf
	q440lJTbNRyuHU70y+RTw/qwLg5QgQMHPOoY/YvYj12IhydCO98I1j9JUHshw+f1
	FkwJSWWoZPKmbZOt3r3+2kdfxcNLPndbGwIpnOxfnZaOZyD/Iiptnx1f9/tY4bTC
	K4JyAVplLEZ/dzLgQ9p+iJh8PF61P63//nMc6Yex0dW/J2L9shCsDDdzSdcwQu6o
	VeppE28WnaHc/Q0tliWFkq5EVCcaiRlLYWP4Ka0roDg/h2eYZ3jCI/aMtPBdBb2a
	RAIpRNXn0XXRz57GM4gFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787224278; x=1787231478; bh=g9xsCX0WBUUnfBOKB0w7/8Sors9fi6e3DmV
	tM4E2/4M=; b=PagUZJvmqFmQep9zijjZCNDOkk2VTJM6cXWjSMGUp70gTevh8wI
	GB8PSELsZV52BP+N+2MiA1+CrSaBHjmSIp9FoJhIfDvfaNCWCXQjrmVO4SDNdDlv
	C5cxPXf8yUsQkFECN+CSS+/mN/RIfaxYNG/pVO5zPBXfTGnECOg16q9XnQ8i4me1
	uu6ZOwuV5MVQYEs5ASUXCeBCiSeabZpGbXYv15iiVUzmdanVvJ2P6kVDS3WngoU+
	/TBPIFKL83avXU5pC9goRqM/Wtgj4Hgy3tYRvtzh8Y6wxaxasQRXXpjeMAikscY+
	CSQp4LpVHUWY67gM+Ulw2nTy9qNQFsMxhdA==
X-ME-Sender: <xms:1eCGav41xO4Sr31Im6zqFiGb8CPE8fPWFzAt-JWQoVXuFUDjGCQZug>
    <xme:1eCGalWpRxsb-fgWxZgOrusBw7BbpycYwxJzCN7TmkBqM0qWEZxNNTs6uFP3LjUIV
    -BfEqx12170xLjX8fL8ohxJVjokCVRx7TXOP9EGSCygI9LNiRN55eFY>
X-ME-Received: <xmr:1eCGan4NZHwQx_gMpmQaQAeBEfjA6FnShBBwBT3ZKH9EOY7qh-6mi84o-3g>
X-ME-Proxy-Cause: dmFkZTE0kLAPelY3PhKKgfOZReZlwUXCE2P+0W3Lsq0wn1U8jgUAUWTZGyhI7tcRZnVTCb
    PshjWZOgj5Oe8lG1fycLvPkM2WPvj3VvahId3o3ZrQfFqXv1hczkf19HxS/ojoQQHQMG4E
    Td+uhh0fXapAah0ml84fpRB7tzK8Yw3eEnpDiyM09M80hT7656Wy1r8DPVWW5UkwozcDgc
    veEgvxmSeLwe1C1/u6343GWpJWQcEESNTABMaj282WuViN7jYhRdvbjsZz6StVtV5sUpMo
    5rWloeYRfSADBeGXkVLM+Kh/s+R0/bZngF+2STWRGn791FSVF1pf1ChlwkUilcOAiDxntZ
    dxRzYJBEyyPadtn4QGMYxkODvUaEP9m6+Ecx0DINgUHxNK0Hhnacv6+Dz0MHehkbu39EVv
    Zy9q4iPh0OAK5uFaGrzt4one4rabz38n2w1H2Cggve/3mOswlytYQCbdIdU64fiyBBAJvH
    e0ioudfoJz65Rf6nSruDUGIce598LTvLwTJS1EcoTnUPXLRvVAoejecmJqFTmc+SAOLcu4
    ipx+Nv7CcBi1uUzY6hjAZNdd+K5sAGPBh+uaSHgC+TjYE/snlo5SsVZWLZKjZOpbQitDhb
    C+HLQ/XTGjJbkQRtYtnwLnpDeChP/3qcB9DG8JvHh5AzDUYACf/rzJnr+h/A
X-ME-Proxy: <xmx:1eCGagIajLtMjAqLMf2TclkZP1geG1bLcWCE8vDugh2Fra-luva1rg>
    <xmx:1eCGaihLbHlYtrTex95q2LSogmkbsSdStbhIHiG9tCjdGRTNZbecqw>
    <xmx:1eCGaiIrDcCoQY4Bxe06GEatnevG7gW7nHu2ENb143y2hsKvegh_XQ>
    <xmx:1eCGavH7MdRTj1hgvXaLbmlT9vQFZiclztw7QqjIHo1ho8dKIkht-A>
    <xmx:1uCGaqVWpfH-32-MnAdGOVOn4Jg0MNG2WMsYrvrUzzR0lwx5d3TjZWMk>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Aug 2026 07:11:16 -0400 (EDT)
Date: Thu, 20 Aug 2026 12:11:15 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jannh@google.com, willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 03/57] mm/collapse: add collapse.h for the shared
 collapse state
Message-ID: <aobglSY5L1KoIqxF@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-4-kirill@shutemov.name>
 <3113ac8b-c1ce-4577-9e93-449b70818918@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3113ac8b-c1ce-4577-9e93-449b70818918@kernel.org>
X-Stat-Signature: gzwrkia6zkmt7i5g4uuk13f53fr1f6xr
X-Rspamd-Queue-Id: 90DA214000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787224280-649596
X-HE-Meta: U2FsdGVkX19SRr266/bWiuLRv8W3LXnlMr4SJAeDB1W9av0UH4oNSJjYJWqQ74RAhEH7LTGqcNuwcyiPjt5DqaRoMV6F6XjtuMJxqhT//f/btR7WJl1etNT8Dg/4A+HybPWITHRenf33YmVWogJRdvkgAIs9Dq+8jE/M8V+tYWHaus3Y15HrrcNa0vEXSzIeenor8/PrvV4Zy8P7nQmkp4eQxq0jdklnBMdZY5qb0EHey3TAjmTp07pv9hnZ+pheCbK5vC8W5+jtZvTuVoCQ0FmBSQbBKN3m/ZoTXl1DacOJ5GhCA6sjoHY0H1XhbGc4hpPXcRv3M21AzGw3EnP5ot8M+3yuaDwGprhNRw23inBNR7a68CaV124c25jKNZXndWDmAGjRB5BCEPld7wQS9bBTtFoejsIeYIGqImCGp70Yi6n0WcU2MOsmZxAyi9kVlSsmkxUfI9zptf72d3+uIbkpJJ85yu74n1N0ZoEdlYPey26mOxBsTd52ataT/79Sfg4ErnZojULR/iAwH7SiBB7uEn7nFDZyFh6IXsTBHg0OURsHpbECrP2dIsZnJZ0eCX49XgEVAT48a2LfXNPA5FyQnT529K2s0xkrtSNjlgh2Z6E/cdM+whl77LVthUwbCEuxpsE44zbbW9dXht1GzluVxySJBuclNqIpWFNt43mdodRpCgqojVINsRPElmDD4cqHpuMjgUcGjUZ+X4s+of4WunZw8dVzOlf3gMYNLcxu40rpK8CHL7my2tlR5k5txzPmxSZT9/yP2dcFWKIwwQCGryhzKuJ2furtIt4ZMPLYEdo4tRyZndBOAXvKQE0uUIEfD1FLeQhOy3rgW+EB5aoUdHdpniz+CdB4oPIKrXf0K3hEnwIG3orZPH7wSmyRC8CwzG2IQilO7Rnw6LI5xyC4wgh2YXLLIM9I1Df+3tNkbBdm1tpB1zqp6arTsmnKpCEMDRZ2LakR9QGndff
 OMMQReDZ
 Sw2WsQ2JHwlNFrrIZqSFJ7Ud55+9s+TgiwN38+QLvU1rXEJFZgWUXBWMBvUZDvKRb0L2TsTvpiqJEmzk6L9wxQYrinpNUMaavaHD4b8zenTKH9tdFs+qgZfGaPzO6WeRvbuLuGwLt0hAZdsWd8jZTu3k1/zVRcYLfGTotF5XII93AGgI2Qxdt9b3D4WNyH/sjXYg1KLlHQTb8SY+S/rqpnskd7W4sqyB+BL5kP6BwKZlZjch+xdXkcikEKg87LoA7yKbkN1mh854QdE7xYo2Y4yLm6qN6YbirlvBuvsdFvPzirHfHJGRASul1Atpryyg3QDFZmwd2rAqngH40nkBsJMNkLZ0H8XYdBwADXkwdblPd3ZRp3vNmbh1WUALlM1ZSZ2Rv12QrQ0RfrXD2UzWiepdXfmPKcxbXCO65rt/lTW5VW9Dpn1gqJXqx/LV9YB/M/kHLJGAcOthp97xEYET6lRDZBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 04:19:41PM +0200, David Hildenbrand (Arm) wrote:
> On 8/17/26 00:45, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > Preparation for building the new collapse engine in its own file.  The
> > engine and khugepaged.c need to agree on what a collapse result is and
> > what state a scan carries.
> > 
> > Move enum scan_result and struct collapse_control into a new
> > mm/collapse.h.
> > 
> > No functional change intended.
> > 
> > Assisted-by: Claude-Code:claude-opus-5
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> 
> BTW, I'm wondering whether it would result in less churn (independent of the
> other changes) to
> 
> a) Rename mm/khugeapged.c to mm/collapse.c
> 
> b) Move stuff into mm/collapse.h that a new ...
> 
> c) mm/khugapegd.c will need.

I went for a clean collapse.c on purpose: the engine is new code, and a
new file keeps it readable while both mechanisms are in the tree, with 28
as a plain delete from khugepaged.c.

Your shape is less churn, though, and it keeps blame: 29-35 move about
1700 lines as add-and-delete today, and most of that would stay put, with
only the daemon -- mm_slot, the scan loop, sysfs -- extracted into a new
khugepaged.c.

If you prefer it that way, I can give it a try for v2.

The rename has to open the series, so it will collide with anything in
flight that touches khugepaged.c.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

