Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D61F0FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 19:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD286B0005; Sun, 26 Apr 2026 15:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE0A6B008A; Sun, 26 Apr 2026 15:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3BA6B008C; Sun, 26 Apr 2026 15:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0CEA6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 15:59:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9F721A0659
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:59:45 +0000 (UTC)
X-FDA: 84701772330.28.BCFD288
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1279FC0007
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:59:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="lZ8ZnK/Y";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777233584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mp1GgHM7NOITjsqzk7THXOo3PfgMKRrhDwfaIZYvzyk=;
	b=YBBja7Dd0RFXnACzS1xeNLg/0OnrjW8LSneW9U0XWV18maaJLGoGTXmLDuGMqrdES12ENX
	vKaP7Mwp2wbJ3gSBbtPAhaBdznKE1mT8ZAC+SdOnA+QM21ZwHcT6qP8BFLmOBbn+/o5Lp+
	AzdjySuyg+kEVcq0IrfRgUQ2+Soo4VU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="lZ8ZnK/Y";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777233584; a=rsa-sha256;
	cv=none;
	b=tht9uZEUxwgxAt0VgiivBD/U2/J9ARBmWOCuHETAtg5V5oZKiPW6JYkcKw7IDy+41n606J
	Viv5YeJtx0u66IQURRPTdSlKt5ZGS1nTRuYL6SBZZPsTos2W7IoLgyCgWMLOdwycMRlgwe
	6g+1Xlv0yMPCUzutZfTN0G4xIDiE790=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AB8244353;
	Sun, 26 Apr 2026 19:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A566C2BCAF;
	Sun, 26 Apr 2026 19:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777233582;
	bh=sQS9ECYqFOsLOgzaV8hLZaILKmDan1UEbRlzXl0ooNw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lZ8ZnK/Y14ogo/bQCAeGfOtg3ocivHsmkLuiUhPVCqMIarhhSFoMpeINgMrMFyNZB
	 r7g2c7ISOz2x/JUikftn8t2e8vw7ceqpL6UnCWbvRqAnxKf2S0SGjhNmAOFZ3wi3yZ
	 WzcGinpVqsoCQ6Ldq7MwMOSQ7R8iLn8Vqdi27H/E=
Date: Sun, 26 Apr 2026 12:59:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org,
 pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com,
 richard.weiyang@gmail.com, reddybalavignesh9979@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/3] use vma locks for proc/pid/{smaps|numa_maps}
 reads
Message-Id: <20260426125941.9921d585e2c5033e68ddb9a1@linux-foundation.org>
In-Reply-To: <20260426062718.1238437-1-surenb@google.com>
References: <20260426062718.1238437-1-surenb@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5kknzygop3wdgoye5cxaax345j8suerx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1279FC0007
X-Rspam-User: 
X-HE-Tag: 1777233583-806462
X-HE-Meta: U2FsdGVkX19kpR16Om0GXFvNASJgUC/m8R7lc0jMc1qdArIpd7ypI3jQuFqIl782FrZ9QxTXg4AI5+VHUgnDqSULFN5rcVZdcdDblGaeZUjnK7MzFFNjm6TN+5Oje9shbCOzCECIZ0w7y0/2S8ZG9GYnMApDawXsWauHqgRRTJXp5mhpfpUOjQwzKMRBxczRJt+7xQYjroi5lndlPQFNiYy2lJr1yrpiEdWlzY50w1gXyDlTPlhvCfn1xo8AT6d7z+ZzCclA2mj7lP7rNvlndtUprGsKp8QyPMbhy3dNKVtRqsOJJ/XXHbnMdBPPX2jAQiGTWZfXSa/I/UKZWobVrJL53wvhcXhEv99u/hnTcDhyK7OFw6PheoxE83dQ7che/9uv/KHBw+FTIQVhPBJrxShKXhrKcZWPaHFUU4Pp6NnBLkVJvF3/XtpuAtjbZlLATyB6LlW0aB7Y5kwUC4sg3H3oPyXVS/9UgO4NxE5hmAVeWPkROD3H/cW4KlROdi9K9TNKgjvTy5Z68UDhGkjNTn1KmaH74V7HPonyJHxDMryQFQJAZJ7mZOOQFdA06yCz8Om3mcvP3BHI0w0m8RDN+JvhjyE60WRdlSwZaeLpeST/73Kt04rBdp/bt9ajLdgQRnRlcNU7VjKBvtX1ZdS2XyNdpyPaEL86Ck5w+UL269zQaK78PfGEJO7JzV8VxQ2bD7tFLDrujRA+B9LrOGyvekZ/YQRFWPHg0f/eqaRJBh8MCN++HUleXiAq5P4BZ8Sjr1T1hypJXBja4xomfdro0G0LH1r413pIV2qdtv6Dv2TF/fevUzDEmKMeE+2A8arTML9+4Fy+x9ogQWNHnb6eD1YvELDIYjAZkJhObPr5KQQlzUWWnL/EkdWB4XNm/OnVPkAN76ypwYPd86K5TPbqLNFX/vOTe8i4FAx+eSm35e3895MsHTd/wP2nco5ZBZsM2KNu6OYtpHHJ3CQN8Wh
 Tbb7Dkpo
 zRs+SlK81qpcoiacze6s+PorqS1gpbkMTogRQw13OZH8hS9Mbq1nRsvSc4m7ABrykeJDU0xfqAU+B8ClcZxcZAwbrsARwGDOhpIDL11wfF9Y3P98aWKHN60UBGKLJgmNxmMeNlJnNYNN0cD3FKU0VA9D8fUIp0ysPxWHw/e9wGSrx6Ji1cIHbKhSlIt+FWbkzMTbMeFnmYsKqe4o+3lpf+WkcBdDzE0LtlhW+WaEt6HLD8OMVVujl4UdJNZvrDAGA8ynA+SNJdlZjd5UG8mXNDkBPe33LILsJx/SYEpuyTUtG2F+QoBy+Tgc5jWZ7QLeMRluFtvKWfGARqdSmzTwKNzYoEgcOu67/vYJ1r7RmHXxXUeCFvpkQD9+Kw4HZ6ZYG3SSsorUeEJwfsErU4F7qGA9SxuW7ZNuc1ovOI0ct6yBu0YvzavqeDmqHLHc5yU5F7PFQ7Sy3LeoTOTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Apr 2026 23:27:15 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> Use per-vma locks when reading /proc/pid/smaps and /proc/pid/numa_maps
> similar to /proc/pid/maps to reduce contention on central mmap_lock.

Was the benefit measured/measurable?

Sashiko doesn't like your strchr():
	https://sashiko.dev/#/patchset/20260426062718.1238437-1-surenb@google.com

