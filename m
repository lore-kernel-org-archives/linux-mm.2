Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4FCF8A176
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 13:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96CD36B0005; Thu, 16 Apr 2026 09:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E476B0089; Thu, 16 Apr 2026 09:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CD36B008A; Thu, 16 Apr 2026 09:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2E46B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:27:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 940C11A08CA
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:27:25 +0000 (UTC)
X-FDA: 84664495650.28.BF05073
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A58B980002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:27:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NXDzxqC0;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776346043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTuTruzGdYx0pfLDvhNMyl4JeCuWAkcMOkgF5X7HAeg=;
	b=Aa3I5oBgNZ+z69sA9n8bEVzIRSlYv3nao6xHU2MIumGyvO837npVNGrtx4OwkCXnMoJKVJ
	tIyV97Pjkt4vptLONQSFPl/jl5wLJuWy5H4RGxDhOtZ6SKUqhchZZat0CFdbCYveSOBp6U
	jRr3wC4eIBvD7waaQkM6XzBWax/Em0c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NXDzxqC0;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776346043; a=rsa-sha256;
	cv=none;
	b=Rq9YJmEnfS5+OVo3HXFErRz7KRAQGW4pIIzy//KJRZ0VrVLKxUD1Tl0gnYndXCqOS6Z5kt
	AMOCHBSUMo6P+kaq1iooaUSgGa9p2qD04PS8e96y+bXWlTq942JQerIUj/ICPQVUypAY5k
	91iCBku0ZDSjPijF/nFPe8RatZXTIGA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A12356012B;
	Thu, 16 Apr 2026 13:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8351FC2BCAF;
	Thu, 16 Apr 2026 13:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776346042;
	bh=U0wkkhyzba+VOCKmZclFLbF+sxUF9Ywi5JITEPUwc7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NXDzxqC0hW0ThnadfmrPp7viAciYVTS7DtQhOWv7D4kcjgU8G/0DcZQkZMjdLmZAb
	 ZtUsukwaXohNXgthC37FkuLlmRrq6mgaN9y/hm/H9bV7Iorzq93J4P3oi7KFk3iA+d
	 61Du4q0jCHJgWtAwG5JR/cxKxqb56iTljqQfTiwou+No/c2ziU/ZY1M6pcRv+iAv6P
	 hnlJAolJjEYZF8MAtJwWk75fnQ9fomG25I7xHuzZWo9ITBcjIF7umRsr3jErbNqGte
	 1gcIhVzXyV59qrdLc/dQNwuy1dTdKa5cE7MW2jgwVj79HOVGm324Ok+n7+16Zy6ebY
	 rf+ez3RsEmUOg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 85D3FF40068;
	Thu, 16 Apr 2026 09:27:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 16 Apr 2026 09:27:20 -0400
X-ME-Sender: <xms:uOPgaSk_pM6BuGhHptX9-amFXqT0UE2TM2wzA7HHgiENOXqea5Zmew>
    <xme:uOPgadL-UqmGJ7BML7mME_r8-DxdWdy-GcSfr7AcUImmFz2ZAbB-p1Kr2eeewnuq_
    mzFtP4FTTqgSs3OlwKW2qxIGfGEAhdX0NCIBCfcYUCOhBse5YxyQbc>
X-ME-Received: <xmr:uOPgaccZcaWcEty1RZiELLMnLg0zpNfLCHITOax68C9SLv8VAEJJcHzOZapXiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegjeduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeuieejieffkeehfeffffdtkeelfeelhefhfefhudehjeehvdffleeuvddufefgkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuhhsrghmrgdrrghrihhfsehlihhnuhigrdguvghvpdhrtghpthhtoheprghkphhmse
    hlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehpvghtvghrgies
    rhgvughhrghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhhpphhtsehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgr
    mhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:uOPgaZxt_HEBPxXdhHDBAeAtykf6aHcXL77XFB7L1kzKKuRgr8KhOg>
    <xmx:uOPgaUwdlNspXNQ2md4kX5WpB6oTKsYqkzxB6thSi84_GXxB2wXFlQ>
    <xmx:uOPgaaUER8pEqvOLKPlSpRxZjlGB5oVBs5W0IxVz9Hkw6UIM3IrlGg>
    <xmx:uOPgaUc-WsUOcgNf8whhteEVnf0B1htZu4McDmu0SLGH0dpVWJVSCw>
    <xmx:uOPgaXfCqcIf0Fbi7qdwViNxE3Nt7ki312s5joURJKDR8U_3R_9WwV3j>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Apr 2026 09:27:19 -0400 (EDT)
Date: Thu, 16 Apr 2026 14:27:17 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 10/12] userfaultfd: add UFFDIO_SET_MODE for runtime
 sync/async toggle
Message-ID: <aeDje8vylad8bGoj@thinkstation>
References: <20260414142354.1465950-11-kas@kernel.org>
 <20260415150900.3660575-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415150900.3660575-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A58B980002
X-Stat-Signature: r9w3wr3zdb3ojno61kd11954sayuqgaj
X-Rspam-User: 
X-HE-Tag: 1776346043-628633
X-HE-Meta: U2FsdGVkX1+MzxHdS5E8kqOWgiWt5o5byU37NFbviWBUpgRpHeOXD7SC69vVRrhIIbfjcmBha8hMUHsxVdbwwEQmJ9vNxgXq/nscuuGsXPLObD4J9kmvT7RRFgp/AT4hCtWH1MXXgHVqG6rp9B+k4J+FEDACYFnsr13enbDzo7jtA33Vda6Z30s6mCi5+lyxLhgOagPD9o7MntyPD2tvdXvyEOQhUemFVqkop2Fut4OiDKusckxeWrk0VXe+bAudBWcFSA+0BlmAEHOFthjBrQPqoRF4cA2Y0lk22CJeY47opA57lW8DSCHss123xNT3uz4RfXcuY1c3wp2J2+TKx800TqiQ2o6006FVtECjYMH2oY0Vj4Ec39sV/AxlQFjH0kDIcmh3ADOhaLsuB0ou83kUgVi2mg5ofYfjq8xXRXDktkaa/0J49Tbdqmrwiy6R31rBFsxY0ES0we2G9bXutjhsgJMr8HnH2QP/nbdOLLzwE9rj+PanJMgq6BPVpc7MLpueJjFNQfUdXSYrRtPpb7TSmEquvQjVeK4KnF+Br/wtUXWBOqw1/wXwb5ss10IPLdFIJ58r0S83Z73CFOWqKWf5avt+7xBoPdDzcg4LkkjNiM2mC5vZu1SzhUzH95gRhIAk6FEFd0aqZg3tqF8pxB0uXwIUO/tdw5lRzIbaNzXS9lhHcKR/ZOgug+kv2C/hng0YtHo9UlqiQn9c2dO8cBDuwz6FDtl9zvGyXSfvPKBcQ38DAg21TN9cMncjOsCwOM2JQqkv1idpUR1lcTNGqagIdsxrYboq1OMAWOkHPBnwpxNC5ujWvpxFljemiWR7i1Z64g3s5E0iySiP9zPUGPcThNwspPoTPeezCIFaGbujuUXxBP/3y/8+/Ka7RKOJEmnPBQXZab60Uk9dVQS2GN93KQWLxbmK8pxv2O0LbVhbV4muCWxJ1lKKQ9WF9DMqhNCHmo6PVzNjDT/sg1r
 TB5X5ujC
 CWwQuS8TKuftIiws1b5wl0eHtSjSQ1Ca786PupPIqtHgN74/XHB3avbOufdOWgNGRsisA1Q8nPDZCVydzu12Pgh2RI9NE9tAGl1JfxtfYe1NpnUZcII0Hw/p3MjIPCVZcZsiadx5g/OmjsTUjSfY6L8z0+qvp8ASZYbvMXbefQYeimvqpSzXVV1iX59Iql2WdjSlMGInmk/qj+WzCjuWheqjTigykqrQYXyrz04TGlFMlzScTCJSuO6FxqjPAgJaKrOytfYNk+sRj3URDjppxeMFlY/mQ5UuetwQC1owindHmdXUlX3poqc453AypHi+4gzSY/6GlSxDxmI3URIFV5VphGtE0fjrrLB0c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 08:08:59AM -0700, Usama Arif wrote:
> > +	/* only toggleable features are allowed */
> > +	if ((mode.enable | mode.disable) & ~UFFD_FEATURE_TOGGLEABLE)
> > +		return -EINVAL;
> 
> The commit message states "Only async features that were enabled at
> UFFDIO_API time may be toggled."  However, the code only checks that
> the requested feature is in UFFD_FEATURE_TOGGLEABLE.
> 
> Is it intentional that a user who opened a uffd without
> UFFD_FEATURE_MINOR_ASYNC can still enable it later via
> UFFDIO_SET_MODE? 

The comment is stale. Will fix.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

