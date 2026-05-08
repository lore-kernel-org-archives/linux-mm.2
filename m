Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5910ECD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76BA46B0213; Fri,  8 May 2026 13:32:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C5A6B0246; Fri,  8 May 2026 13:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631CB6B0248; Fri,  8 May 2026 13:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB136B0213
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:32:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3833C1152
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:32:24 +0000 (UTC)
X-FDA: 84744946608.22.6CA94C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 22DBC4000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:32:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cIjwvtvU;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778261543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bstb0NRxlDJKAUkWlpp2KIzcaJfbX0hbt4pMu4dTgQ4=;
	b=o0dbefnYq0rS6yPu5hthdNn6/GDebVpv3zTdV+xTpODtfkK3SyNnJFT8QJsMfxVgreUac8
	0QDH6jPU4HtUxYv+CvbriRuS8+XRmmSsjqI3PDm+p0jBsr6MvDKnkHisJPvcYUjZ0JH5fu
	YJ8ohyzqR9KCh6ZDjOYfhyfRCt7TQJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778261543; a=rsa-sha256;
	cv=none;
	b=P/toNyWMq/I6EcwGgISEw6QMaFmxokTZ0iqegoTpbVEC7W9hcWnw7TvgfkcgkcCm5cEQRA
	HAN3Q2s62eVdiLwxH0UHkKwfDQr6dC8pQaKorJxNJ7sthXB1fnknX8UQqwj55y5jFEoAjO
	pATTUPvTrWabQCH7kfOusPc4PG2lHEc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cIjwvtvU;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0013643B71;
	Fri,  8 May 2026 17:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36103C2BCB0;
	Fri,  8 May 2026 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778261541;
	bh=hVPRSg/Aw0I1iOxX29ZJQVzFj0tLkTvJRdEgtd6gtFQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cIjwvtvUImu7UJUAxjtcmuA/pRzJ7AAThBot1FXPvuxh/gq3FKF152tCWY9BcRscQ
	 IT5yOPpH7MAoFkpgf4gFE78JZcCSamL/xFz8GQl9Nw55LGdLBqwqk/VO3hvuyN0B5i
	 BaUT7wXFf6L1LOPx82+PG9GOWSD2vcRnthOL5zYQ=
Date: Fri, 8 May 2026 10:32:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: rppt@kernel.org, peterx@redhat.com, david@kernel.org, ljs@kernel.org,
 surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com,
 ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org,
 seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com,
 aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 00/14] userfaultfd: working set tracking for VM guest
 memory
Message-Id: <20260508103220.aa46427b6f4c5d0247d2afb0@linux-foundation.org>
In-Reply-To: <cover.1778254670.git.kas@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 22DBC4000B
X-Rspamd-Server: rspam04
X-Stat-Signature: jm816db4ztrhagydre8adbr1kwctdf5z
X-HE-Tag: 1778261542-968711
X-HE-Meta: U2FsdGVkX1+6dXh1m1q+rtUCdrp611ReWFG8RIvM8y2f475EvWYUVVA4I9t3LAhbFKVZG/LSImF+1Ox6rCpm097zwvuZsm2R/kVIcnCcwfz7wocMxBJhOiMVeWzcuOIWgabdGqwIkNGNztRwpy5oQs8V229vClCRJ7WxfraXPgtsOTYMG+tFiG6KKQziJXzXrvSxKx0zz3vU1tgYfducleUXPVQqcOXRMzn8PWIawGhTUTP6z8GLwGu/Eyo44hum3fTIGQb+bVKhzHCOaDDhbNVUioHdn7sOcYwWp38LWgxe28ryFOHUcVJNEXHsdZnsCL2RbpqSGvAxwiO/Sk92zyNMbNFyWm0H+ylsjv4qkaEDovPQbzCjYewGWZZtPEFbn+AtGpO72X7ZuzDXOh9QflY+hNcERbib5/yORdfK6VHmznvF8rt0yWZuYJEi/ABVQAImzAoRoc5k95MkXfKrZQAc5ZCnKsxE1Qe5mRqvEEVz2hjr4N/C4VhO4RxYwZrCzRr10A/Ie9paJJiQC6ay/ZRoGfHZDZBHBR2ycVdzWtNEGywhH/wDj37uDEAXPqMu2jf9Cch5ir1FztOi896R/CnKmZw6d4WOcD7wu0IC4PKfy/fQU+kg7XFzdp+SbUt6SaPD45VAFmPBIyfSXTB5PZovG66el7a+RKxA6/jA0+Q+5cho3+0vcQWgsAyVPP79Ghn89VPxP9pdRdO5MUBsPjqnVAAMPN8ajEPnFwYnxHIOUgQAVd8p5lloBJnvW9pIaPsBfGzftjpO+6X03LX02otlJXjUV+QZv9aALyDbi+eIlMN2Oz4TcaPPYlTSZcGJY3XMhlcj+VPoRCW4PeVaHAmThzuBWI+kfRMBQNieQOrESM2AKpyrkXKBz9cWNi9uGjJUH6FzaXTT+O+j83COJ61sgukOAjLNngM3WHL60dYmfgsPXYHtlIKZPIviQvI8srosITMV+IuEc+P9fiV
 WvSf51Co
 NG4pkalct7EIy7i4i3/Zes0Ezq2evwmDsBI3ZkY3X1fHBbzAdoZcKZE96UnwtTigF59mawvk2kadc6zsu/LfyRGEGPEPgWuF0l5mHTKvelNKncwXmWWoanDp51nBs59lFH7eJOOZA570gOUF7p0lNu1qEHgOAUPA5F0SPfvmFBM32iUMwJqFPdSrVu9niXOiwiRxeaMN+e2w0zjHSvuOSqOjn94VTZndNOW/xiqedbGkwiak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  8 May 2026 16:55:12 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

> This series adds userfaultfd support for tracking the working set of
> VM guest memory, so a VMM can identify cold pages and evict them to
> tiered or remote storage.
> 
> v1: https://lore.kernel.org/all/20260427114607.4068647-1-kas@kernel.org/

Thanks.  I'll duck v2 for now, await more review.

> Assisted-by: Claude:claude-opus-4-6

For my education, and perhaps for others: can you please explain how
you used Claude in the preparation of this series?


