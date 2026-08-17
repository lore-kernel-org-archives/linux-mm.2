Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A106C5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830B46B009F; Mon, 17 Aug 2026 03:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8076C6B00A4; Mon, 17 Aug 2026 03:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CFE6B00AC; Mon, 17 Aug 2026 03:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FEDC6B009F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:48:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB48040660
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:48:53 +0000 (UTC)
X-FDA: 85109984946.10.11952C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 312E240007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:48:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B16+gD/h";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786952932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0gv21sh9XLRNZ9Jrxv7t4il9hC4kodx+sB469t0bwq8=;
	b=kqo7uhYHEFYGEWm6qPSLzttWEuQUkaYV2gOyemLW+1WfS6p4QQthAkz/eU3BCmARVRx5HG
	LN6yLp18IOaoYg/Ob00IKE1tzSnDXUTGjSJhgP04KMAxQF8rh66K5tQTiOFyy8VAdr+T8+
	/WwtzM+31k0zkHnOla6dEtWwJb4zcSc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B16+gD/h";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786952932;
	b=EeZ3TU0iuWdSK1nGJnw6vh/hzKU+lf3aOoxhp0lyXaGf9W1u8OCDVO8g7fjlN8NeB2Wjw9
	UxdFmlRVbezR1gNz0QQ5LUdWtr0017hg6Sru0tOZrD3atDFXTfPsgamez2cH26QiN5nJjR
	nuaNF8gLJl6n2qK0gft/D/XRa6UbGRY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B20AC403ED;
	Mon, 17 Aug 2026 07:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADF31F000E9;
	Mon, 17 Aug 2026 07:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786952930;
	bh=0gv21sh9XLRNZ9Jrxv7t4il9hC4kodx+sB469t0bwq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B16+gD/hF6e5hh9HS8Dt+1I3LlFX1KTKz5g3EqC9w4AsxdPeJ3+3uD1DcVzdGVluJ
	 yB+PIorCeGjMXdXpuXKWcNKLp9S9OkT6euA30ktmo5dlw5fg9nFjkBHIW0VZXGfpjC
	 4mQtZzVGVGi15Vxi23hLYR+UczR8ZPyKVGu2FgCMajs4e9F2OVOS6uR9FiyVQx2fTq
	 y8C39kjP3ocaLrbGnHO3DAZeCPs6oP8asFJQz1r8/SwM0RKqQB+6jl9V4wFzEkWk0S
	 h/tcWpX6WnaY1X1ofmgb9/D9Ghx5OKDTn/b5t4k0LJ0vfre+RfonhfkaLfFY/9nrht
	 cRu94YkT2wxIA==
Date: Mon, 17 Aug 2026 08:48:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Eric Kim <seohyun.kim@outlook.kr>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v4] mm/rmap: synchronize lock and unlock target in
 anon_vma_clone
Message-ID: <aoK8o0zmbKcDVDD9@lucifer>
References: <OS7PR01MB13914C76BD66EFB5AE2BC8F6C96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
 <aoK7Ko9O8cGz2iTF@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoK7Ko9O8cGz2iTF@lucifer>
X-Stat-Signature: eugdiug3hzdqrzho5ue4ejgi7p6focfm
X-Rspamd-Queue-Id: 312E240007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786952932-908157
X-HE-Meta: U2FsdGVkX19Vo2vZmujagNK5bqnNmOplqMabIWA44sTqNhXOIWH0vL2N21MMT2eVeDld3clzlzsVJyRX221cDSvt0TSflokCMLJhXC6jPjiku5v3+khHySgtYTRfwOTzjaM576F5NWDTpwW+ZvGgf3PIp3aXsJ97IUsZnfnB9JRNdRCdcZO+uDP02cXXXfhVON1UEvfdLDWnKp/KcQxkg5bPOjEnDgDcwDpRwFONXRM/1Mo8RDKveEwXNvGwk/P/BFqPNN0+uJokICwCDSb9dDe2pM8BdtjDkf9lxh5Bkc+EBgN2/VMLnSeAwTrPOhDTn94GH+ZuGVpfjbGp6tD9Kfy2nfdsEYljvOwQlzKOIpLQHq5pVx/+H1C7fFBkmwh0lyc1qK2BBXgVpy+RTx4hc+eJSzyd4w0x9SLmqG0Z3dfMqfrabadJAmfI9zop2tDoKQX7a+tfYFBi1OZQuOR58d9d16qounJfXw47bwsQJsgWMvvqqHMrP+UgPbXZqYkH+KAVFq9mPCI8NCLzRA5qLYH9qdI21HYb5vsQez89Z7M4LuhYFp+Uic8WTn9PtPyjpW+85RFjdibQwMOaguo2VDuJuLqqzMz/u+xaH8D3Pk/XH9oiXZmFh+ok6VM3GRm3LgDFcd6X7ROOkgeczQMbPLK2Olx3JAck6bsipNMwZWYBg8Exikv7dqRTS3gG4eLOll0W/l6kjaWVprr9+VC/4BLGnTmnHwDjKUp42y9NtGw4CfG2GtTv9MRoDeLeo5FBUzeMbsBzoNyl208Epkp3iuUYIggNAsiMVnrydHI8+QtBubsi5ql4AQtvwEZEGlTM12aiOoZmQ5f4SEWHgJMtzCO43wcMM5EKOa0J3K9dzBRlmO4LYqlsNQx6SZO0y9CBWVX6csKG1VgFCqA6c0v469sh0SwaQCHaidOHuU3ncgSxtPOnw14G1Pkwl6ItbYW+9Avb9Inv9LHxMktEd+P
 eDg5nanR
 eAKwdnR9CyKm2En+xmtsDGcip3CsIb2XC+z61176hE5hKZ6L4xMRIh5M8ODcG1w6V6cXLOm0ET0w+s277M1iLNABtNIdsNqLGmLs2etYeKIZqe3msImoMA097ggLqgiwMq1u307S7QobTHXF6T7mENjW6ErXvr+/ni3ZsPKBCw4jUr3HOUF2Q4L0MseawIZskhGs+5z4OOOa5BYytLciZvBmQiT7xSPB30EyGbzM5wkRfN0Cn9yQEtAzzU31n70Zx6aELNZVv9FLtseVOiAo6yMr2aVUBYLLqIQGvSpJKD/aQ32s3Qv76cV43GiCHnlb29vW98NohrWFuI0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 08:43:30AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 17, 2026 at 02:25:11PM +0900, Eric Kim wrote:
> > ---
> > v2:
> > - Clarify the commit message to explain that src->anon_vma and
> >   active_anon_vma refer to the same anon_vma.
> > v3:
> > - Carry over review tags from v2.
> > v4:
> > - Clarify ctive_anon_vma and src->anon_vma refer to the same
> >   anon_vma.
>
> Extremely petty nit - and you don't have to do anything this is just for the
> future:
>
> - Prefer a reverse order, so latest revision at the top.
> - Nice to have lore links to previous revisions.

Oh and also - nice to attribute the changes to the person who requested them,
e.g. 'Clarify xxx as per Barry Song', etc. thanks! :)

--
Cheers, Lorenzo

