Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8406606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 11:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mlYJTTM6
Received: by kanga.kvack.org (Postfix)
	id 149036B05B0; Sat,  7 Nov 2026 06:21:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB186B05B1; Sat,  7 Nov 2026 06:21:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F3B6B05B2; Sat,  7 Nov 2026 06:21:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1A4F6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:21:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66AA9C0301
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:21:34 +0000 (UTC)
X-FDA: 85408082508.10.D11A726
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C4703180005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:21:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mlYJTTM6;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794050492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3pB3AGO9dEv86sJAhd4wOp/MO0lhLnyuc09qYLY7Pk=;
	b=zfoPry51+5hVCFRUElaK4NTOpQgPLs6RierbYypeS7jrMICSZ0gvmhIoR1BLeFZlUeY06t
	4xSix9cMi6gnyPzekJGklEzJN/xCiT3gIqGKBnT397wnrHDevtj3cNse9m+s7F2zIwebSy
	FXvKCtqX5F+jza3Aj9eU/DpruWYw/3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794050492;
	b=jMYHHBGMRy48z+RHF//eGXs/W4nBL7ZHaFqIHG8uKqHRP6gGcNZeAhgx7E6+LZHQsLtr4q
	LHj8sDeVS3tDPAqZnY40LP503gi6z31inW+yNpQwnKOv9j17z+jdE0OCB2/HIh4BC1KX/A
	PNuunEdSIcHs03ZaqGk5bGMCPKNYKJ0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mlYJTTM6;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0813D42A5E;
	Sat,  7 Nov 2026 11:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEA91F0089F;
	Sat,  7 Nov 2026 11:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794050491;
	bh=V3pB3AGO9dEv86sJAhd4wOp/MO0lhLnyuc09qYLY7Pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mlYJTTM6Xw2nBKlP+gXO2Hp2D+XyOgUpRQ6JiRXPPT+RbcytXScqI26d8Bzek+5A8
	 bw5nI3gO2ndoS2lvagBOTCcgj5W27ibYNIZYaWV4GSeX9jPuodmnxXeKmJjCaKJwqb
	 RWHmzDoyxFvi5REzuO9oQ6peV+04CAWtfs9B2nCFMyY6s1zctV7eVZRDsUllC8tBx/
	 eJ7JiZ/V7Ezbm9bCaFQyYE08y7q9S0iGDqxI9MAF3T2JtutWBKTr+FkZ3wtB9Rfzq2
	 BxWFRYFFGBD7rNpuSk9AJVgCIqRjx656y0FTSfzQgit3WFZbxWTPERrsNvDMsRHVqC
	 Pg7wKFuoecNEg==
Date: Sat, 7 Nov 2026 13:21:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Frank van der Linden <fvdl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ivy Lopez <skunkolee@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/cma: simplify cma_declare_contiguous_multi()
Message-ID: <au8JtLx7T0r9ihPP@kernel.org>
References: <20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org>
 <CAPTztWYzN1mkADOAJ3bskqpsv9c7qXNSMUdj_Ovg-aDQJDDmow@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPTztWYzN1mkADOAJ3bskqpsv9c7qXNSMUdj_Ovg-aDQJDDmow@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: ux31i494wnruzs9thicoyz1rrxkafyan
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C4703180005
X-Rspam-User: 
X-HE-Tag: 1794050492-544283
X-HE-Meta: U2FsdGVkX19Gg127Vsr83O67ygScBTaa6BsAAiG+v6eqBZ4GWzZTsYPkAGllvDvYWmfNsN3ZF+7JqvpT5tKdTb61S8/rjHHRXLRA3l0xTS7ljmqwXdpfwPK8mtNct4Ewwylv96gyCWqzA+IB21mGj+B6hCIZR3mYbsTE81t+vX+lW+AccMxxp7h86JVtKF5BGtk7FX3X+u1KlGbMcp91vt9xdDlukjWitH1CSfcNAs0D2IVawIVQKM0yBZrxbfdOpA1WQ/6HPQjB24niTNF0X3G721t+61PhWgr7L28KpuBqCjWieLYTxY+MBpDJwry3x0vY7pQ5K01IvZWA4HdnaW869Nyo65F0xGc5UIgPPYeujZD+hFI++HSNklpwJn+RngpXME6a0HurJyNVWhKJosAl5aB/eI4ZyEQb1BDP7ajVyruCnzr0v2kJZ/4Ng4qnFYNyg3VJKq8+Yj8XEgaL7qW6fXUPrBqcu7SJ+bYDbX4om019DAFRp/V4kChURbatzriCGdmy4OMcT2dUt8yUVEvjDVyH+wag4nmdzSsF6Lx5fb5xWPZinTlwK9cXa8FL9YXDfLxNwzQSuIERCbOs4sxAAFNcZVngIqSTFwsx4JtZAyY2jbzsJfGC/fR1YhLWwf2EQ4vs+zwZSBrZmipp8zERElvCKD1pDeRk9tRHjaJi05oPKb6FGhQlSSoz35UnwXO6PiiCextmvhRTnseLWkb+m4duH+Z2sK9fEIGK5DSKCqE7HcdKyPywcZaf4B2CLJ4HsSxv+xCDQKYcj8VoF1PZvjpov5zNLQOiXf/nQ6Y9O/oAKQe7qqRc+gf4deb26hh/Phdpf1oHgeNjFy7E2/BnZJ7XPlzILy1VUTUyOYTTlNEtH9mZiQs8U8gACA5Zsvro4R02Hc1/ve8OJkY/xQf1FsKSDBplbHT1KWtn+gmrTs3ipj+obUAscci3a7T40tRm8zIYARKkDsVG3mv
 L6K66RNU
 3+ft+s/LaHkGqld1GM0setuM/x/0qVQSXE8xdpEmZ69LrKB2U/f5+baRhoL00danHFheD1bVxLg4UCDhreMGo2l3DYMqla4GDbxmJErxs6GHWMsO05LBYTjDszQKg/S5vzDgNSX1xDXN/dtScw/mEfw2ds2XKLxAeJ2OFNDpUBVufJ4MRcEjhzOekSLIJIIxnQV7bDmZXE3FGXo2W9+M4TVNzjA1jem/tm1T/oSA1zoP4UJ2vk9yzNOQnCVfW+bnJ6MCJkxoqFfJJhl7B3L39GFBONuSTTKwONMq3J7Z5yFaA8hFYadmMS33y2IKzRrATf40qY0/4DD5UCJDSVpWCPazjLhkul9z0TWwG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 02:30:38PM -0800, Frank van der Linden wrote:
> On Fri, Nov 6, 2026 at 4:56 AM Mike Rapoport (Microsoft)
> <rppt@kernel.org> wrote:
> >
> > When cma_declare_contiguous_multi() cannot allocate a CMA area as a
> > single range, it falls back to collecting a list of up to CMA_MAX_RANGES
> > largest free ranges above 4G, reserves them in memblock and adds them to
> > cma->ranges.
> >
> > Replace the current code with a loop that finds the largest free range
> > above 4G, reserves as much of it as needed and repeats until the entire
> > area is reserved or CMA_MAX_RANGES ranges are used.
> >
> > After successful alocation sort the cma->ranges by their base address.
> >
> > The new code scans free memory once for every range rather than once
> > for all ranges, so it is slightly slower, but it is way simpler and more
> > robust.
> 
> Thanks for cleaning this up. You're right, what I did with the list
> sorting was too much, and it contained some bugs too.
> 
> Just one remark here: I don't think you need to sort the ranges by
> base address at the end, I am not aware of anything relying on the CMA
> ranges being sorted. The sorting was just there to mimic bottom-up
> memblock allocations while acquiring the ranges, but the eventual
> result doesn't need to be sorted. I'm not aware of any CMA code that
> relies on this.

The bottom-up was added by the commit df2ff39e78da7 ("mm: cma: allocate cma
areas bottom-up")

	"... to guarantee that the compaction is moving pages out of the
	cma area and not into it".

I think sorting an array of up to 8 entries is not too costly to keep it
that way.
 
> - Frank
> 

-- 
Sincerely yours,
Mike.

