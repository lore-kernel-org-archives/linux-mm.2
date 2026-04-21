Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8A97F327B5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 07:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C706B0088; Tue, 21 Apr 2026 03:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16A06B0089; Tue, 21 Apr 2026 03:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05586B008A; Tue, 21 Apr 2026 03:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA3216B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:38:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58B5913C185
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:38:55 +0000 (UTC)
X-FDA: 84681761430.17.AD33BE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C222CA0006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:38:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IFA1h/dz";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776757133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDZawAtyupzt04WjpFZVOHiooNEFBqqZUM/idGuBuRg=;
	b=Djiwj6ttPST1pbvBxg+FnKlnjQZZ2KFn8VpYt7gS4JUATXZBX2/6arwUVgO65C98i+4GRl
	NcXRfL/tlCw9AlxzRza95zE9fc/2VQbdq5sz7iaATcHghsSUYs6j6vuXFdjoB299YDAp0a
	qwOPEkaU54U9Uo/8jTZ5p1A+IjLdL7k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IFA1h/dz";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776757133; a=rsa-sha256;
	cv=none;
	b=WTXK7e98NnYYgaAWamDlRrcUpqIcv3yetf7A5XO2krcN3/il+MtB97yhAavWrftbQwPh9q
	UE2aHBq5uDK2dZYEgYByFt3CawkBhNMkCCbgdzCvqjITzxEjjzPRm2twPLiiyqgZJN87Yw
	lAZHAbScA+L0h/8nVYz+EXN+1Ca/cmU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26F99600AE;
	Tue, 21 Apr 2026 07:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7595C2BCB5;
	Tue, 21 Apr 2026 07:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776757132;
	bh=HOqa5XPljAtYrq4q19EOWPa+YuGMA5Hz1ufgw3AIi1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IFA1h/dzV0RBcJx4PXA4CELRa0OQGXDRkqcUCfMgQzFiTJov9bcGWulZl5O6n1KOI
	 9mdnidumTxrxDukqN4qDlLGxq2cvZfcqYp4rdKefh4Du3Nysqk2ZHru5Z7FQ6fX5Xv
	 5rcrM5hz+8r3vmKS/Lfvj0v7ZjZPIkcU6s7tj2m4FYUkGV86TkBOR2QsbIWsYdoXGa
	 ZwnjluIWkMwysyBQZPKG+ew1JLpQnJA558hJn7OHO0ZuYEZOdpImRoXEyYKcI6iUnQ
	 P73pUEEpGpJiWJf+tlgF+0N91Elrk9ImIBvffEwMuQ9oYQb5P41LTzHhWKBtKgA5po
	 H/gvzog5XQt6w==
Date: Tue, 21 Apr 2026 08:38:47 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Harry Yoo <harry@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: clarify that we are not looking for LLM
 generated content
Message-ID: <aecpRyCcT2iKgyrl@lucifer>
References: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
X-Stat-Signature: rt7w66bj36pu7cpdk318g99gr9a8i88p
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C222CA0006
X-HE-Tag: 1776757133-72354
X-HE-Meta: U2FsdGVkX18eTA/IBbjFXtt/uogT8j4p6RSfdb2uFCRNQMPfNgRYokkrNuUJrDNFknHtyQZ2zKJR+sK2MxSkIohJTxIfZSG3z2uGAY6lDGa65k7T3rORBrDuL/1rjpnHmKuOFSQmtS+1PLoLiTnvD202yv+LGfaJAt/SXHrGhQIl+hQYYqmCWTsQ3NlkCYfcasmYjhCvXQPFLafq+VS6KoqogpyG6/eiyORZbs5yX+vHOF5LZNZ5Oqj6keWl0P8NirMC2mpteIKrxbiQpO6/ICSmByfUV4i/lXullTxgH/eKfzW7gIYWXr0RG1zW+CRPJje8IJEx5Za1pGHhyzX38gK4+TMWzV69/NIKhaoNLANjofeyPQwHByTEQSTCJaX8DVua+isUFM2ZKxNkkN2bS8NpQMqhsHkq+ZfxESiSlGsbNme7H5hKNHZjZIe3X1IMx8Qo4vc1Dm0OVW1Ptdqjp74Vn+DeWW291086a8Pta/lKBiSoM9Zhv1lahY7WbhD88MSKyPoTgqEKFKHBoFYR2KoYe3QMfpF7cBweEB9VPkZHyR3buowz54F6i/qyMsTZkB4PIXxjTHYLBehLvJ3BJJqdNTyK0XTEo472GWSYGhopAns8CYD/UEYlB0UI/RiEhdKngxyrTUd/nQ7HPEF339KGKPOw6zINXqAQhj4CZwDW1kMb5UwLANok78dVra0NxLrLkOxMDojVIqpd9wunjRb4YkZuvvX2GxJs1dSS9HJ6TGRYBrlihIRpeAnpaDHKNo8unuU99taJ4gxPkdNdF2KA5sr9niFnVUJSsGyyqrk+zwLzVe2u4ISDKyjY1xeKuFIHi/UM8eeTM2gd3EgD4P18myzrxEpaR8nkdZND53rrN9EJYRJ2fQr6hkwZkk+ECox0cZWPOZCmCOnqr0Jv4rdjZxhvXuu1mZYRa8Qaa3QrUK8c92JzdDWp6heUNer3SohLDDTD7Sipfu0vaeC
 xEz8uvw+
 zkEQkck61JQXAOPNODl9WBjPGjEYP9FlkTZs5DmAcQgzg80cP2yak9cPYxtN7fB5A/sQ4w+zRzFnn0M7ObAWeSw7rDHqOh0yIGc2TLYlrwCKghuMh4L9U2UeCd/+Vf0ZFflXLRs3Nv84/5oTD3DKH1q+xw3Xi3gAdnA4+yqKw9tvS/4L8hSRoyAiDEUqnV5zHdKl13ioQhKN8TBzWDgitiMb0UeFnvo0SbQCEpXWnoX38TlGu4ITOiLSgryq4EyHfwe6ArYA8+0uH51xrzwOndG8JTmyGtXjajlPUKJ345+cVvSBy2pJRX+NdYJmKFWhW6dlAK8FvlvBzO09ydH+3r1B3rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 11:03:16PM +0200, David Hildenbrand (Arm) wrote:
> Let's make it clear that we are not looking for LLM generated content
> from contributors not familiar with the details of MM, as it shifts the
> real work onto reviewers.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM to me, I think it's important we clear this up. So:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  Documentation/mm/index.rst | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> index 7aa2a8886908..13a79f5d092c 100644
> --- a/Documentation/mm/index.rst
> +++ b/Documentation/mm/index.rst
> @@ -7,6 +7,19 @@ of Linux.  If you are looking for advice on simply allocating memory,
>  see the :ref:`memory_allocation`.  For controlling and tuning guides,
>  see the :doc:`admin guide <../admin-guide/mm/index>`.
>
> +.. note::
> +
> +  Unfortunately, parts of this guide are still incomplete or missing.
> +  While we appreciate contributions, documentation in this area is hard
> +  to get right and requires a lot of attention to detail.  New contributors
> +  should reach out to the relevant maintainers early.
> +
> +  This guide is expected to reflect reality, which requires contributors
> +  to have a detailed understanding.  Documentation generated with LLMs
> +  by contributors unfamiliar with these details shifts the real work onto
> +  reviewers, which is why such contributions will be rejected without
> +  further comment.
> +
>  .. toctree::
>     :maxdepth: 1
>
>
> ---
> base-commit: da6b5aae84beb0917ecb0c9fbc71169d145397ff
> change-id: 20260420-llmdoc-21bf5fadbd6f
>
> Best regards,
> --
> David Hildenbrand (Arm) <david@kernel.org>
>

