Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9DF606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RhNUG8v3
Received: by kanga.kvack.org (Postfix)
	id D3EE86B05B0; Fri,  6 Nov 2026 10:39:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFDB6B05B8; Fri,  6 Nov 2026 10:39:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06266B05BA; Fri,  6 Nov 2026 10:39:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 953456B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:39:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 105FF40E31
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:39:12 +0000 (UTC)
X-FDA: 85405102944.01.F742B73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 640DC140003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:39:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RhNUG8v3;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793979550;
	b=M6Hm3aSj6ZJF7OrEGO64YQEk2ZiY0VLXiY/0MeW5UqV3EFCurmLDywUAY9bvN21S8r+rCn
	rqCW95Jb1hU5EtzfW6hp5+x6KOE1374Pfcd3QQzFyYjar033ho6qB9OI3Vh3NCFbLlotdS
	FQdJA0jzDYjigOVaZc7JWrKkQp69xv0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RhNUG8v3;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793979550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=343eayTvifkkMlrwy/xdVN6F48t4446WEUYad6Mst4M=;
	b=r7AMxTi+aanEr4wB6CPCYeqko43ob1AlF76qj3GFcMkfW/YjbikyuEcSFbc6eDBUWrOHnN
	r2z2dM5ebuchS9LOENnCx20/POCRL2BiFZ4PLNDZJU6fjcvKPU8vUbKkl/XpVjISzbzhKx
	6Y8SsQm3zOD75ZHuCA4mMN0vZw4bcSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D82C040D5E;
	Fri,  6 Nov 2026 15:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A10E1F008A5;
	Fri,  6 Nov 2026 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793979548;
	bh=343eayTvifkkMlrwy/xdVN6F48t4446WEUYad6Mst4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RhNUG8v3jLxEuKfkjzjh2O3hzkT/GXHoHwjFXad+jlqrHMmoroWCSEGOJ0whXTbw2
	 xSujptrJUOFXO6gYslpAoW99b5HL12/fyBJuJOuhsieu3ICH/oxVleEoAIkh7RcG6U
	 SIwdwG+dP6IuacVdo+ipywY41G0+dKBsxkxgOtACZ7bUEtTcEo4MTSd+nd3GadPzyU
	 bAeFw2ZOH3g8/lu99jX2UxMQ9VF/cEMNnaOpzFIGQfKnsGek3+2LNwGgETaY9PfRiY
	 DwG+UpF2w89nS7IKxvChsEE0SCP5nqnZ8YrJWZEf4Pf3/iugNsee2VmRdh2bUVHvqT
	 DatnXZ2gE5+og==
Date: Fri, 6 Nov 2026 15:39:02 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <au30N0kjlIRfxMTx@gremlin>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <au3CUJO9zBMHLx-B@gremlin>
 <798cd192-9ec2-4f37-9cba-44db275a269c@gmail.com>
 <au3xEVu-SGXZYfyi@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au3xEVu-SGXZYfyi@gremlin>
X-Stat-Signature: hkutzyy1eoedq1k8gpedtw7qtd4joa1y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 640DC140003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793979550-484044
X-HE-Meta: U2FsdGVkX1+JUZARgbjC1r9NQ6aiWi1J8e9bZqgv+2kYDl9ncxaRT7RumkhtWOHczI9cq0qq7v2gJnltAlCCefc8uqSf0KQjq/zwRU0Kg6b6K+wQc3mjipgBX0hk1omeHFrXa54KATct8w0GeS7s6TmtZNrtetl4wlXUfBRX7vtXqa5h38+xDSnQ4uk19BpgPVfTk6ZBrY5pPWdzWIR+izhcEpJ18DOu8/fZWCqeLj5tAvwyUDfxnEc0tZjoWrxlIPycjkDJ8bFb3gjiQBrQwA/utdsIDbhuOBbVFiZe9kr5BMKeVaSX8DsLnimn0DQPuVfCdBPaVBt5XLlqyosAssU74rNoV9V2/fvd4hUFxS9nrTRJOGh2z9P3ljcbel7/Q8jYNopVdvAef0bO5x7YtQPkmzPoSLv8LIXUbOMjVqKR0Tdo3s0eqnoBFRgxKB0SfwAQRcNTDhnHM1erpZs2vgKUNsXVuHlaWD0Q9ZA5ie8n9hAabb0fQT6ItNPjS6TzkfD7Q2+4eN0qAuNZP1fgPIEm5rlNcC157OsveIM/RYSYvihV98/rYyU3Y5hASVDEn00QQ1PvuPL45ezxopNPmv/a5FNkwtfoyC0KtpUMisDHftO9JrOCQH8sUgfnXSNPiwdHh8J4iN7IXDTR00MDn70wQBUea33UDNVKq4fRobHxeI0e+seA7hahVOe0LPExoUexrpnng6h7SB9uF66QXV50rJCm56KHzFq6HO4xN7nHCcmcX9omk6+tKaM4W1mkB5FHrYKwN9lOBHbDAy7jdOOnA0k+qEo/c9MnyHTbpFs9mqk4mPNlnHGfCgAMXaFFtaWsc6oEnnBlhrMChAe1fQpw+Cq74EWBB7N7WAjLdLDnNa6nxl/kIUNp6m0Qn6J88U9y1XA8RE0thVdv7/cXHe+iq6Mzr8DFK997cQIC3CLkTC47pHFEl5Wh7dElIrxrTF9KfV3oTJ4ldFKLv7U
 fAUK9sJm
 hOBJBDKs5UM0T7LUDcAiHvUdHLcCGlU47lyjk3HvaS4KW2IGQ7xYLq5AoxnuwQ7aC4q3mLYtcrrfts68I86Ozd52k6tEDnk0/QstsIftB9tXg3dvl4aNIhEUFRIziQ9xiPpuKVBQ/c1+xUXg1Zz6eTkJNZPk/inutXTA8VHZvI7NCco5YO+b0RJk+QJZ7Eu2TDv9x1Nz4eqbQRJ0LujQYIxpJCTxtqQ3dqnd7LyW7EmAY4UiAvhwHWURBz539gNOoTM0y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 03:24:20PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 06, 2026 at 09:26:01PM +0800, Vernon Yang wrote:
> > On Fri, Nov 06, 2026 at 12:07:53PM +0000, Lorenzo Stoakes (ARM) wrote:
> > > On reflection, I think this would be better implemented as something like:
> > >
> > > static void collapse_scan_mm_slot(unsigned int progress_max, ...)
> > > {
> > > 	unsigned int long lock_start = jiffies;
> > > 	...
> > >   	for_each_vma(vmi, vma) {
> > > 		...
> > >                 if (time_after(jiffies, lock_start) && mmap_lock_is_contended(mm)) {
> > >                         mmap_read_unlock(mm);
> > >                         cond_resched();
> > >                         mmap_read_lock(mm);
> > >                         lock_start = jiffies;
> > >                         vma_iter_set(&vmi, mm_slot->address);
> > >                         continue;
> > >                 }
> > > 	}
> > > }
> > >
> > > Which avoids magic numbers, and means if we hold the lock for 1-10ms (depending
> > > on HZ), which is a long time in the kernel to hold a lock, AND the lock is
> > > contended, we drop/reacquire.
> >
> > Looks good to me. Is the test result of this solution the same as the
> > current one?
>
> Thanks! I will update the commit to reflect the changes.

Hmm, actually the poor granularity of jiffies makes things measurably worse.

I think I have to just use a fixed constant still, and explain how it was
derived.

--
Cheers, Lorenzo

