Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D60CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 18:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99AF16B0088; Wed, 17 Jun 2026 14:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E0C6B008C; Wed, 17 Jun 2026 14:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 834196B0092; Wed, 17 Jun 2026 14:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C84D6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:57:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CDA9214056C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:57:42 +0000 (UTC)
X-FDA: 84890313564.18.C43C018
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 397C0C0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:57:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXryMjMk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781722661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuHmxF3Q3Im7lyehrUggcluXuhikWRgzOx5fgePtduM=;
	b=ihf1aJL7m7dDG0kV+oCP3FP1KkRHA6vWsMlVtN+Csm4fAiQzkGry2JHVmSP1j8v0PII9dn
	iI0+AQrISu5BKgkWM8zTAwRM1v1hhEoXV4zH3ZhrnTZn7e5URctTf6+QcZi5DD7UI4pUP8
	F4Vw2OUbRBA7nD4V/RO75ScMSPMtwhQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXryMjMk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781722661;
	b=bprYzkMBO2uqzUJU1ajO2EICyRBlxcRHLs6X7IhVgBnQHYfA37rKPMw4u0aJ+U/skpEA6z
	O1ETMljBkIrAk1PEaen6dSupzMUtqGhHNJI8iFZRc4/pp+E7ri9+KMUKNG5Q9TvOss3Kkx
	vJbXA8rgJesmsihvPCRU/aM6KJfWxB0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD4A460052;
	Wed, 17 Jun 2026 18:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7891F00A3A;
	Wed, 17 Jun 2026 18:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781722660;
	bh=MuHmxF3Q3Im7lyehrUggcluXuhikWRgzOx5fgePtduM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fXryMjMk/Xq0WcxFi0hr2UMx4uUqPl2Mf+U9u1XOSgK97gCt9F2Qm2zCSpchld2X1
	 vfC2fdVvpzjCo3Z9nE+pNnZI9XoAGHR5qfhtC4Q2v4OBXjWdQ8gaqUoL9eCDuxcXER
	 xedFJeKWCkOW7+5sRRdytlXq/QqYQhGgJqFmrYNyT0nllTv/ZUNuiDlzC2prcNqvb/
	 8dz/HpV3EQ9T90n+zh5IiZ8qKomMPZAeeA3UGDdcVlp+Ywim0K6W0R150Qcj3fGN1q
	 Ej1mYOlwedKVnNOTm2EjbjCH4U3hB27BjqzilFy1KDmqWYsrIOR9dZAuJzC25K8GFG
	 o3Ys2n/hyo46Q==
Date: Wed, 17 Jun 2026 21:57:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>,
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH v2 0/3] kho: Add support for kunit mocking KHO restore API
Message-ID: <ajLuHq-FJxrIzr51@kernel.org>
References: <20260521193202.746810-1-skhawaja@google.com>
 <ah0t9Ss_S-5iOM59@kernel.org>
 <ajGOIOqBY1pazq5g@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajGOIOqBY1pazq5g@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 397C0C0005
X-Stat-Signature: 3kbsuqzxw8k3ykiwpq4sg7robyj95a4m
X-HE-Tag: 1781722661-791397
X-HE-Meta: U2FsdGVkX18ZvdYAsu9V7ZXJlqtQdBLTSPGO/ZJ0vy6nMXZ5NPhB2JipbuEk71zcPJg3SYSwrr5N1prpEYNU4aK5OjYeOCsrq2vPJnypwClUN2NsHTfOF2n6pfKabn9uaTOSk3YOplvpG8NkF4ZUywZKHZRqRVDTkJR1fmAqxR4hJ11aqcPI5pWJNGZYaxfJTqo5TE+4TZD8PqYMvpbGmgW9IAWKHA3mtbKtPXKYPm6S8xCSg8+Rp+v9ZqmoQ+MErPWIf4+IFaFsiqIoSFfoBUY/tx90pE3Kuk+M4HDgX5v99C4O7JRHM++zl4emB/9jo5FWtw/vpGGeAmmYsqVNE+R+6uiidD0jpM8Xpe22vPVw48RqKQntCNtPfrijeYO46cQeCeRWrpMxJMm/PpFcJPTqAhLrNnJ96lV7CRv5IuL4MUO2Ym+orduRwhZdBBHFGmwXGyLe+tSPQhhzsgNWu5+ayFiz98oYhpMtFoI4TllJtnhEGz3GcO2K8NQYKCbjaxtL2QNoM0GCk4MjXsnsBc2QWyGKovWVKLf7nEmEODVEoa/0kGIcZPbTNR+lujyhEc2AHalOaQUrdegUfwpMVoGavvnvwQQHbfztMItv22pyueps6W3aT3bs0lUCNgn+/lcvsidEEi4LgfoLsBRDpFxwXDQveqUpg6azS8wGla2NOSKT+qL/Ke9VMOegypR7Qn+Y+7dNpINMdmhucCCLFhAQhLzAZ2b7E9Q6ZMPraLOTTKyjGRi0BDmb+vskedH6sUF7Abo/R68FFpX+eEN1a3QTYouMiXkkqVIQaGSiWUArsx0TY9Xn78nVtxGlIRA6MKXiJqxPVkHfM9Aj4RWMRp5B7gU+6NdnQvPIsSZJPlTVg3v/VghaLcIvChUB4TZwXA8FWDDDSV45drNcsMAjhHIftjffkmcuYtuIniSvPIWOei3ox5zmiCCuIi97dBKuA1iqvvQik5qmHzqK+AX
 s7tSa17f
 3QS2Z/e/TRMs6yxN4xCfyoeoqxYHq4xWeJvEUAvFkHXrF60G8ylW6vMFV6uaoxuatTX9OMX3YUSjJGzPOvzWpf3SGnZQorkAEAIwlrc1eLS5RJRoOTnCy/3qJsSkATUDxsxLziVuiVhKUoGj8MhuEPHwzc7Rl++VKzxhQusHRYFYOW20zt6PaILW0iN/3vqO5MqjPb6u7e4jO5aa2K4SCLrMssaRyRaUT815+didaXchJzmYp6+tlLhxVD/E1NeYH3DTi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sami,

On Tue, Jun 16, 2026 at 07:15:03PM +0000, Samiullah Khawaja wrote:
> On Mon, Jun 01, 2026 at 10:00:05AM +0300, Mike Rapoport wrote:
> > Hi Samiullah,
> > 
> > On Thu, May 21, 2026 at 07:31:59PM +0000, Samiullah Khawaja wrote:
> > > To write kunit tests for preservation and restoration of liveupdate
> > > state in various subsystems without triggering the actual kexec, the KHO
> > > restore API needs to be mocked by the test writer. The mocking is done
> > > to allow testing of the individual components or functions in isolation.
> > > 
> > > The patch series adds the following to support kunit testing when using the KHO
> > > API:
> > > 
> > > - Add static stub hooks to mock the KHO restore API so the restore path
> > >   can be tested without triggering kexec.
> > > - Add helper function that can be used by the test writer to check if
> > >   memory is preserved in KHO tree.
> > > 
> > > Finally, it adds a KUnit test for the KHO API that verifies the allocation of
> > > preserved memory, and the preservation/restoration of pages and folios.
> > 
> > I looked at the tests for preservation and apparently they don't add
> > coverage beyond the existing KHO selftest. How hard and/or intrusive would
> > be adding tests for example for error paths?
> > 
> > Do you have an example of a kunit test for another subsystem that would
> > benefit from mocking of KHO APIs?
> 
> I think intrusive tests to get more coverage for KHO would probably not
> use the stubs added in this series, as these are meant to mock the KHO
> restore API itself.
> 
> My motivation was to allow downstream users of KHO to test their own
> preservation logic (making sure their ABI doesn't have bugs). LUO or the
> recently added KHO linked-block can probably be a start?
> 
> The KHO kunit test added here is just a minimum example of how to use the
> stubs, which is why it doesn't provide much extra coverage.
> 
> I am perfectly happy to drop this patch for now. We can get this in
> later when we have kunit tests for KHO users. WDYT?

I wouldn't want to merge this upstream before the actual users appear, but
we can apply this to a branch in the liveupdate tree and keep it there so
that subsystems that plan to use these stubs could base their work on that
branch.

Let's revisit this after -rc1 is out.

> Thanks,
> Sami

-- 
Sincerely yours,
Mike.

