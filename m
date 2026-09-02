Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15387C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECFB36B009D; Wed,  2 Sep 2026 13:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6CF6B009F; Wed,  2 Sep 2026 13:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE57C6B00A1; Wed,  2 Sep 2026 13:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD64E6B009D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:24:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C99B01A02E3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:24:39 +0000 (UTC)
X-FDA: 85169496678.22.74DE5E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2BED7160006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:24:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXiOsd0I;
	spf=pass (imf08.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788369878;
	b=rSwb2MBFZcizDKFTrd3Vf5AHMYY1GU+wGbaec1lebVe10oC8G4Jps1NjnWthkIHW3qWUV1
	lYaRyqq28EARpORlA0zmjGw8AkFCtAVFcBNSLuyb1xFBRcqmzovg9kipoDZhOz0PTfrtHO
	ZVaaJ4YOw6l0uvD37BlOeSNSkOCM8xI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXiOsd0I;
	spf=pass (imf08.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788369878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3/1naZ1RhLgUWY856SAbE6LeQ8PQwzS4dxBvl1l3nM=;
	b=1lVZlg3Ur3c109MPhelCZ6qpTo5aJYATcr02vjgZsFGTqzbP/0b22DPSX2LVEluOVb7K9q
	dl6pZWFMdrhruXzdR68YOocoSRSVEUQafsootoWmxVxfD4DZodZV7/IpSI1eHZL6IuBJLW
	uD4KEnr2XmoxywzgwYUQUdYGUNuAuLQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BF7E40273;
	Wed,  2 Sep 2026 17:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1164D1F000E9;
	Wed,  2 Sep 2026 17:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788369877;
	bh=l3/1naZ1RhLgUWY856SAbE6LeQ8PQwzS4dxBvl1l3nM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DXiOsd0IOwaWcqNMcESpWf4hFCXAp8Wnr0mmhtnowdnpJUppd8Az9ulZWwyJ2Uu4R
	 wkSOKrsgXyrCbsZ4Ej8dCHAUO3I/4HPgFL476eGN0P/8NbBkNtGVWoaVvzxq629JSE
	 MNyjdmuBfdWD9tp2ye9BdSsE7IZfLQ6ow1ntz6mprCCXuVX0AkCxGb50BYmQW7oBbd
	 MPaDcJNFaSVqAkwRbQfma7hfoYES0jZcC+6XyiyrsPbnOzs3CpqliBh6dejcYwxVGB
	 pQAl1sebDUlr62/dzSyXwzrWVKPVJmhKguUHvxr/r+W7Qs+BOd/D226mZ36jtpIbUb
	 BuzrSWHmpSLjQ==
Date: Wed, 2 Sep 2026 12:24:36 -0500
From: Rob Herring <robh@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org,
	akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, mark.rutland@arm.com, sumit.garg@kernel.org,
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org,
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 02/10] of: reserved_mem: Introduce "ll-map" property
Message-ID: <20260902172436.GB1440252-robh@kernel.org>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-3-vdonnefort@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902104712.2399797-3-vdonnefort@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2BED7160006
X-Stat-Signature: xuw8xfdtphsjcek54mdxggejw367ayje
X-Rspam-User: 
X-HE-Tag: 1788369878-89348
X-HE-Meta: U2FsdGVkX18h9D2EBonfGp4P6XvxwMjbOA2bacs1uYfxhjhQZtfn2BdzzfcX1tt3QpHsReI9Ga7KXA6hXTQL3leHhKKS1rxMBe08YKZXmpaE8QgRWnVHUTfch28NHhlmvMVTAdfFJ+7WGKZ8KYla5zHHrJ/FMUFSJxD8tpZwmzpk/L4iCg02rJLP/TIImAKGjSNSKnM25pBkRJl29yaF4Gs9HjqVM11JUE9FrjtSwT+AICGaVA9pIt9ifRp6G+wN2sYJhl+NdMb+6hGVR5Isl1r5tWpjRqtAAaqC9sotwjVQ65g3Scjr5l1+LYmpC7v7e20ugf9sqw39HfwLniYNyLINDCNCV928PXdB0bgdgbcIVRCb0hi2rLEu2Mud/+hzz+7vXJYOIH+OHMe85F8M4V6AqWTUsxOVGhMv8aE4wbSN5q13TXvxEIlIwXpbHLOhskm0D5/uUDNixYU+lmwu797yGfpcNlxG5nA3aHE/1g8gYYBjr0TPZJme1ATP1Kbnfh74IVuRO1C1hT2/2FUS//lwSrhiUzh+ULyAjnq+rqbmkp9ANrFDZBpxJZBZqHQF2QaQparyMozANk/HAjNrOfPYZ8AOZnTpvBKS6MX/MQELqhPtWylkO+OODHQpGLTEwyQcXioYwnMlxnj+tC3Rt2yaUr379+KFY74pKq0FelI4jIc4qcRa49V2wzn50tQN7nMODe18o/2kZJKMy6y/c4ftFVQDw63kPKM9c7XW4RVlAkNpw4dBR22A+X5VrYiOEszu4VsG9NtLA8/ewxXdfgvTvr7syva3LjnEgTBa2xFl2kThm6A+SokJj9Mw5kVVXFKgr8mNRgwRJZnlpSq92Yw8r1ZCWdPsuIl/Yb4WjsJ1RXueBd/3wxdGj8Qo9MRoLxYhIn7k3wY9hrMpY8aathVLMky1Ne/5Hw3DCaXmcrEoxSBZbiDRlvxInv4hkU2FjZDpLT0S+g0r/K9SVVk
 RoZFk/+G
 hELkPUcu6Ugt1K6OMcFvLlLx/tzE0oVU/KkKxd1rKbX1Jln5KfIkwYKIRJbhpMaOhhL7LfSoYeVpVWZVozMxpvUP8pRy0+q6+N4YQ8whGUfo6dZr2fiGE9IQpaooijY+1USCnF2bDYzP23XTSSc/oHdcgViWDDiZLvMWNMPKT/q2JKXA5QXGy9I0RDXAt0hxhANT7Q0B9dCVorHn2l+3rUDhEwvdVZlj1ndfJ94FupCbog1t8joCPJ9ee4K2ki8F06ktuPpK/H2oEf2zEi2kcVbuX0eF/ZtQvfFt4/Yr+XEIGu9k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 11:47:04AM +0100, Vincent Donnefort wrote:
> Keeping last-level mappings is interesting on some architectures as it
> allows mapping/unmapping pages from the kernel direct map without the
> risk of splitting blocks which, under the break-before-make rule, may
> trigger page-faults the kernel can't handle.
> 
> Add an "ll-map" property for reserved-memory regions. When set, it
> splits the underlying memblock and sets the MEMBLOCK_LLMAP flag.

Where is this documented? Any DT property must have a schema.

Though I'm not thrilled about more flag properties. Handling all the 
combinations of properties has proven to be painful. Can this be implied 
from the compatible string instead?

Rob

