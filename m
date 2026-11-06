Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48806606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gyQX4xrL
Received: by kanga.kvack.org (Postfix)
	id 5CDEF6B05B1; Fri,  6 Nov 2026 09:20:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A5776B05B7; Fri,  6 Nov 2026 09:20:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB886B05C3; Fri,  6 Nov 2026 09:20:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3E616B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:20:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67EBEA0D26
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:20:52 +0000 (UTC)
X-FDA: 85404905544.13.704FF61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D407640009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:20:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gyQX4xrL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BGm6++pKtOncS4lRKnJP40WFpWtCJnoqlazLALAmUQ=;
	b=YGGxUfZ4XOQOuw1TJO3E/TtuZkF4hT3i6wu1XvU5eshkpPw6kBcjLLDH6u4WNIXEHwqf9i
	8LK6ghVG+JBoloS4kvC86XvgBVP/OgXAMGWI7X24JrkcIaLG8FKz02Afw2Kv61aWZP4L+r
	mMttiNy9vpa9JJhpDaZRW8nVuxNxEtc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gyQX4xrL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974850;
	b=0Y5ong+3YWxOWZD58VnrDLLc8udsTzYvrpTk/H93QoP1B/KzImBoz+Pz4hFCGbyEOPyKwI
	C960+YUihlIzmEttcdMtIalDpGGSVx5e2OzlLpIQOICezL/IS1OFjM4zPMhGT5yh+o9817
	LZR1Wvnsiopn1jSefXGpe7xV1vnuj8Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FBD6602D4;
	Fri,  6 Nov 2026 14:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212391F0089F;
	Fri,  6 Nov 2026 14:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974850;
	bh=3BGm6++pKtOncS4lRKnJP40WFpWtCJnoqlazLALAmUQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gyQX4xrLrx1BFfFkKUZiu5XvGClGl9PbeRhj0kyNOSTxMLNyElhN6ErH+KHOL2n4r
	 BnkL587QN1a+6hBSF3cSgTzMR/sZ9xpPH6aorLKPvcO/nm/M60cQhz6fzdrag4gGFE
	 LQRH1tLBNlwv4RFQ6dElUrV2xanXCvtgwrfHJaWzZu/nFdnND+k8WE3H38bKL5Dczz
	 jLnriyrw/uSRafnQN8JItgZR9AQPLLiX9qhd+c6N0S7jB2sJKZvr/iWgZCLdRHEi0S
	 I71Ra4+finmIVHXOLTmF2NXyTNBYc6bLqwzm0sC5Gaz6IXN0bJUIStZvJ3mb5W6CSR
	 GGSOTjrfYdTLw==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,  Alexander Graf
 <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Baolin
 Wang <baolin.wang@linux.alibaba.com>,  Christian Brauner
 <brauner@kernel.org>,  David Hildenbrand <david@kernel.org>,  Hugh Dickins
 <hughd@google.com>,  Jonathan Corbet <corbet@lwn.net>,  "Liam R. Howlett"
 <liam@infradead.org>,  Lorenzo Stoakes <ljs@kernel.org>,  Michal Hocko
 <mhocko@suse.com>,  Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 07/10] mm/shmem_luo: Retrieve tmpfs files onto a
 tmpfs mount chosen by userspace
In-Reply-To: <auuyAseOISaOWwbO@google.com> (David Matlack's message of "Wed, 4
	Nov 2026 22:30:26 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-8-dmatlack@google.com>
	<2vxzecd0k1dg.fsf@kernel.org> <auuyAseOISaOWwbO@google.com>
Date: Fri, 06 Nov 2026 15:20:44 +0100
Message-ID: <2vxzfqxehwhv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D407640009
X-Stat-Signature: euxy71kw36buxixnsnt4nf3w83oqzx5y
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793974850-379422
X-HE-Meta: U2FsdGVkX1/DUYwJA7KmWH0Oh1Mt9/I1dUXLcXMUXVoPueZ2rISI12kirnR+vTIiaN5f7Tb9StihkkMDr2H9ejTOMnG5rHwgmU0LIJg1OxT7zGVq2Kj2IT+k9QOx9nomYOhkfanrxfpDeWV+xJFDSeoYx9KvjwOlOtMq3IVEsE1gJOIH34p8c4T7RCyirAcKqInJcdb+dfn1S4xF0tc3MaOkHCPujVQcJwsi6ertbP82J9v9p6olg8MxMvnbWLl70A0LFzitsApe9/BA8iR/aDYIuEsybl7KKHXFIT9mAApqmy9xYZH8H8Umz6EZdeok68n4sK+6WzphACBRA0IIP3h/Fe9EcqqfvLIdvYG3RvJXQVQor+ZlzTqP1Bmj8fifKxXGkzajFiMva/PiWZFHbEJdTJ3NAUdtS2nkkCw3pn4y/VgiCDYRpoOfzAZJd8SzpABDaGJlKOR1x65gMexK1enNe2qZYJ16bimSjYkwzyCiAGN7BRZUk+rFkdH2hyjI8l/Wf2wr+/EoH1o4XZHJ9I1sLbTf6MTxTPO9QnTZVmD+Fp7xQUpSUjj+Ao+DmT5NIFpvo1fyRp+DjDJrScKNt+nIqaPriOfLetQ5AA7aughMbzqJnSk1WkjKQ6QtAD29tm6RpSA904cciECq8SFGvpH+qa6uq+UEsC2GCfO1CreT+kzgJmgK+ruluRaUCB4FzUdnt9aWo5Trf3WYgio16vCMG1C64OaYspENQe0NKOa0x0qAYARKfZOkRgLqBAFMrovXHgkFyaq/Fj+Z0RoxFWrlbbTXsXLpb8wTJQMPyN0ZkhDNGwoDDbNqq22f+v0PHUthDPFdhllfPEb9jDTZ4KkZCreRV9tQOL2YfKZDmJ1Y/wK089/ThVF0yvxczIp1lu/DukY3o2mupdVjyAK1NhWZdLnfLaF2b2y3so16IdsGBnThWjdoGmtJnzlc96d226RHrNfymizarkrqArt
 yWBCPJf/
 5pASlwkHEw3BLwxlHU2NF9Qd7wU0m0S1lKKrX6jK9pAO/ugmGfXBOMVWAwm2OI0JB+eGrQ4/jPq/nLXonl/zqqyECukfS+n0BNUMqygNJXrejd74YL5VOmziXV2pkHoEZglMsgBZb6qiPwkKd7f3+c2Ia+GAYzQTYPTo1ucJF4reNGiKfP9jbUXfN6a/TbJYv7G9quEfkyskejtndv6qdHy+O576aVAKi7WzSWM3gtw918tc3iXJ/6CYKW4g7ccKL7XRK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04 2026, David Matlack wrote:

> On 2026-11-04 05:27 PM, Pratyush Yadav wrote:
>
>> > + * If @flags contains unknown flags or O_PATH, if @mode contains unknown mode
>> > + * bits, or if @dirfd is not on a tmpfs mount, the retrieve fails with -EINVAL.
>> > + * If the file can't be created, the retrieve fails with the same errors as
>> > + * open(). A retrieve that fails before the preserved contents are restored can
>> > + * be retried.
>> 
>> How is userspace supposed to tell if preserved contents were restored?
>
> Through the error code, like Pasha said on patch 3. I'll reword this in
> v4 in terms of errors instead of kernel internals: errors from checking
> the argument and creating the file, e.g. -EINVAL, -EBADF and the errors
> that open() returns, can be retried after fixing the argument. Errors
> while restoring the contents, e.g. -ENOMEM, or -ENOSPC when the contents
> don't fit on the mount, are permanent, and retrieving the token again
> returns the same error.

I wonder if we should document per-file type error codes and what they
mean. Perhaps some time in the future...

>
> Thanks for the review. I'll address the rest in v4.

-- 
Regards,
Pratyush Yadav

