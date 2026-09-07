Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82684C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F1A56B0098; Mon,  7 Sep 2026 12:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA326B0099; Mon,  7 Sep 2026 12:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 907526B009B; Mon,  7 Sep 2026 12:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73D476B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:29:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 069BA1C07EA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:29:14 +0000 (UTC)
X-FDA: 85187501028.24.83B10F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 68AF540011
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:29:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AA9jvqee;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788798552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Mi0KexjACT8EM1oYAJ+w+kZqAp8kzJ2mApTUd50940=;
	b=Vxrxt9D/WZUgxIgw8Wn8kudE6x2AhjNnB5e8m7uLm0VQduJNuza3VdjlmgNRhHAnPp6Pdw
	xBbFi9CqLgZdDQnAdqDFFtOdVL/V7IBrwPoRh68gBHnjX3CDD2vCaKbHyoDLTRUzoRJwqa
	vKdn2szWvyVLdksfg1Vyd0H+QFq91YU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788798552;
	b=YoA68G3tL1J+A7fWnA9DCcCN5aKSiE7gIEQBFaQakkVMdADnWxCn0INWTOtYm8Ai7DRM3l
	T+UpO+HU8AFFIhvNdJCqDPRJFfSnygSxE+zMywhHB8KVNb4TxcT5eAjWsi2NGcDXSiGPnz
	vy0K/6k6UFkSvbEPP6COU45R+95vp4s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AA9jvqee;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88FAF40541;
	Mon,  7 Sep 2026 16:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F52A1F00A3D;
	Mon,  7 Sep 2026 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788798551;
	bh=6Mi0KexjACT8EM1oYAJ+w+kZqAp8kzJ2mApTUd50940=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AA9jvqeelrtgtADkk5mv9JMok2q4G/kVWhwLejDCvh7k6Bjosp16ast2eQbe8z3wZ
	 32Jq8QsukZsY6MQEnZXPOrmXS1S6Gz4mRLAd0yCXI322sqt7HacOuSQEuoQ9Cby0q4
	 Dmt6Z3Mr4zOK4ejpTbMgDIjkWmh9oM7y22gbIwFDLlAfoz3qjh46jLWvdQFuLC3sWG
	 pI68lEya2SWOP9mM3qUldcXe9u+fiVXEre9AsJ0BDUIni2CL+AUGL18eQkIlyqkmAy
	 GB49tJWtBs46+5TjG9ft7p1HGBBc0FzrEnhdIGPOMYzsSuOPma6Dy9P8sz0/ko/HuM
	 Jn0ywdYBjHvUg==
Date: Mon, 7 Sep 2026 17:29:04 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: implement file_is_dev_zero() to uniquely
 identify /dev/zero
Message-ID: <ap7mL02N2lPZuqB5@gremlin>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
 <20260902-map-private-dev-zero-v1-2-a578c730cec7@kernel.org>
 <292b27a7-94d1-4a2e-8346-a53e80fd2ed0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <292b27a7-94d1-4a2e-8346-a53e80fd2ed0@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 68AF540011
X-Stat-Signature: qgjmducjg7yda8h44s587e3xst5motij
X-HE-Tag: 1788798552-877011
X-HE-Meta: U2FsdGVkX1/kA4I3M1Ui9dgDM6uMFLPMj4lcgBzXahHPllUXS3FunxheKphvqH8ZHG6zahKTWZS5v9VPlpraqp5p4vwDyxOjR3t/TN3Uvn/Hqxi3ca7w1zI3+gxe39eheW1wxq/vOPtyo0AR4DJWVz++24GbJH7CPsvK7XjpyYRjyHsKw6PEaxw86KAqdbMCTs1KtgIflIqbHPs90c/vDyXbiZ4uiyF9uGCOCmrTPp9nLXymNNim2JZaHqGYRTIA9ybrdZ9BVaUEU2tS+H5jpKwYz71WjMCcTjG4No4k3CQt0YjnQdxCPfaeh9b837JckR8Sdpu4UzYkfh0ZbyQ+TQAyIJXnM6BqiYAyNkRdk31gGSIza3+Xz19eVs5S7ux4ds0BhyM1Nr62oGGthfw7FSSqmBbkruzvjLYjNvgAGbB8jD0gwEjFwWStfAiZYdoV287i9h1sFDYSFq6MaPkroNPw0S1cDhEEIZAll3PfXZDoxL9iEmoyM6smXO0q169pL4/F7qeyzMe0OZL1cHb/CGYf33LWCRbg+nZdzFdpONxyMtzneKUQbSNCGbl+ioqLk1/tKzyXGedPbB1f3OrNUuc+fa67YhKlape63WuIdIy9yMax7EuknBsgnkyBYv9QzrTIdYC00Ta4A8gkT1DxBTYTfGUikNcGL+Wp3vdklXAQoV9unmYu8eobutPhnJJWPBQOiy/8GN+d7p19tcahzTONo6qVbTJDiHhMBDbBteBxiSQKPSeLz4hkmVlb1xd9NCZ8s6j9D/2iKYrb1h2z608Aj7mh/udvQbhefbu6k9WrqYqlBVjic0aIKY5E08OJ7sHr6rXPCExTtCmttK6/fv7GcKvERCMD45ZrC4XNmdEWz70dDSikCvJAywUE5d/CrucJvRSroTDVy29gf9h3KDfrhF4K8rkkMIH7zb9gsFfHhE+lLJ/xR3n0atfVcXWlRN8UMLHwLE1oXK0JBu7
 VVnB6ani
 DWUlSM+CDl1OAfx053lPCQczz64e8aw1svjtWCfw3POugXxnEEuwD19kWZSW6BLBOSih2v4wRgh4WFR7/BagHvPaZniXlP4uExQ9gTqnJUSQncm90k+r4hELf+qHFCrRY6H9NgMzlXkRzoo+5aBnYWaRQiTLVpMu1srUxqTa1kIqxMfA+v27jjpHDoV/MrKyL5wRSAnDHUsjC7/nTP2fAbfIRmFHNmVtH/SrXNivc44D3fVxpRT5HlJTZ4AqsVFlAQ7X4G1T0XxaXFumjeeb8pJ3PsK/MxvWZTpEPSZLsTxROQol7u3KWlB5Uk7VetR1JPTCs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 06:21:27PM +0200, David Hildenbrand (Arm) wrote:
> On 9/2/26 20:00, Lorenzo Stoakes (ARM) wrote:
> > To lay the foundation for a future change that converts
> > MAP_PRIVATE-/dev/zero mappings to be truly anonymous, add the ability to
> > uniquely identify these mappings.
> >
> > With the memory character device now part of mm/ this is trivially
> > achievable through a file_is_dev_zero() predicate that simply tests that
> > the file operation hooks are zero_fops.
> >
> > Also update userland VMA tests to expose file_is_dev_zero() and provide
> > a stub zero_fops for testing.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
>
> yes!
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

I thought you might like these ;)

Thanks for pushing back last cycle, this is MUCH better. Struck me that
actually that it's trivial + requires no fugliness the second we have it
mm/.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

