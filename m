Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E62C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 21:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6786B0095; Thu, 20 Aug 2026 17:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7DF66B009B; Thu, 20 Aug 2026 17:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93EB6B009D; Thu, 20 Aug 2026 17:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD2376B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 17:23:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12D43A02FE
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:23:11 +0000 (UTC)
X-FDA: 85122923382.08.1809F0A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1B40CC0007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:23:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qHGd71/0";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787260989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRUROzXzUXFAIP8L+ka6buRdb8jk6cxYkB7l7ux6K8w=;
	b=w1hiYdMYaZ3jZtgFqaH6ii5G0kpT87XphvhCSk1ZbvMMr1dR2hqcJtZz1VMYjJobcuZKFm
	M9O9vCvW6Rsc3xsz1eXTqHo26IA5EwZZrpm7zT4mMib7EpmqxCglHocsL8eAhLqbYOlVQy
	xi+Ih8rHNPzSvXyoDfM7E5krqGiwUUM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qHGd71/0";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787260989;
	b=FhL0JLAFM9pNkGYNJwJijUA4MKTSlHM02smCItmnlV0TQ7nz/GBf6N1ACFaUx5iraIVST0
	11UnBw3+YMO5eormdqLOgcN5RXokW85lqN7Rqh87E84nDlxdJL8huYX/LGw7mT+BBECUMd
	R4MQZzgxaje8LidF0A87ozDSQFveV5g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E89A202C;
	Thu, 20 Aug 2026 14:23:04 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 39DBD3F763;
	Thu, 20 Aug 2026 14:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787260987; bh=suIRGLK9zEzPugE1h3fPIzwIn2in+SuuPimSmklEYQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qHGd71/05DlnAVZrrc4T/ToiIylUz2k/N1KUa+bkDPw318XP8l2uVp/ZosZEa4LJb
	 WM9LnJsFO1ytcBlWxTitjK99zW23zSMw/U9LftApwtiyCDt6jeXba+0EVX+44cE4Le
	 vJ6yXr+9e28Txsix69iUN0wszHjjM/46m+5WkfDI=
Date: Thu, 20 Aug 2026 22:23:02 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kselftest: mm: prevent random failure of huge page
 split for khugepaged
Message-ID: <aodwNr_zgOn55z3W@e129823.arm.com>
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-1-ab430c58c7cf@arm.com>
 <DKU173CETFYO.1RJA1CSOC5S99@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKU173CETFYO.1RJA1CSOC5S99@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: jzed4kcsm3kjyq3sxeqnpuzwkk8rgasr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B40CC0007
X-HE-Tag: 1787260988-466197
X-HE-Meta: U2FsdGVkX18QNMKWTjSSMdBt9erqmH4faSIeYKhStRYB+yECNiP5wMtg4Y+hxTZrpL0auV3fHStnVVqfDM51UnBte9diTXat9uUBYFGpAdKGLTJUQPmK0UoE0adUIpSIiqjS6O7ZSbHWtY0nbQkUPK8yRv/Pf6EnTcpqWCI8Uvxnv8vY6iha3hlahf5EAB/TGfODwLegqaGHU93ijyVu6DbEbxGhcWd0L6oN+goNG1+a/wp/jooTxwg+nE94++EJ480MQ8q30ac5Qt+I404Y7acqzyHnBlAQREiGqLY+qW/2/LqX32njpi/zhD1dlOf7b/8l9d5Q9A0G6W+plk6YSUAD24iu4XX9F/TtLo4scSL28EvyGNR0HAez7Zm5KdP8fXTP2O7vNCXx+Tdif6iVLzyrM5qAak5LoGAcDLteE5/GJyQ6IDtCh2QJG7pMKvWb9zMvTO6gqYFl36/fj84Rnks1SO9KCkqjlJy6YafKvNGlTm33LMO1AcggjRij6jIbMoKxtMm4xirPj/3F5sUmt2bxM/E0R823Hf6YesUQOkaYbY1KK20Amq35qPxjqW4mYtuDYCTSbQ+cBpTiIm6c8gblCDBl7ryHWInWGBGZ6ZiW9pixIBkmZ+00a/ixJ+4f0+VtrIFxQaSaNfkN66KSXtfYTN81W/6S2CZBaVpeN1nwWJl5lHG6ucRMtPWvABa8ij3GbzYGtMAgRwVinrX4N1Q7WSMqCklbgFIdeUThpSOJJDIr/UTVLXDMi0LbZ/S/AvfZc9VkBzUKs2CHllAQkuoIJ/eK2lndbpDF/nVMIzudImZEPbZL98Oq971xVteDng6GvbOVWYeV7eYNo2UM8y9zXThi2NQwcTdk/9aQCyzfqFfWDJFF2TsGbC22eAp/al7ZKBkgAE0dy77svUOmWxQcc1TaGHLotcwfKJMKAmtbhlSjakCJv6hByV9GsSHb/gKMA0n2iTvZ7ttizIv
 0SJs9HP/
 AwMWstqbZGeGxtH/QX9o8GjZoJg/e3xT8gLxdzB46jKSKfbLa0sgYqcQoz9Ye2gs+9ntkCqW0xU50wVzhq0DTy5B6ce9/1xzqeiScs/0pUFQ1zm+12Kw4HeiJTd0le+ce4YY8Yh/gSlqA+lvlOgxNiPL00l9CcJF/1YuwdjGGFM9S72OMucwGYaaaJl41hfsG/rh/tjYQIO/frigac+X1F2GCKHvDu9LHglZo7DODps61Alw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 03:51:34PM -0400, Zi Yan wrote:
> On Thu Aug 20, 2026 at 3:40 PM EDT, Yeoreum Yun wrote:
> > There're some random failure for split_huge_page_test when khugepaged
> > collapses pages into pmd again which had split by the test.
> >
> > Prevent the khugepaged's collapses for split page by setting the
> > mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
> 
> Why not disable khugepaged using APIs from hugepage_setting.h?

Well, this also works with hugepage_save_settings() and write the
khugepaged/scan_sleep_millisecs with the maximum integer.

I don't have a strong opinion but since it seems more hackish way to
change scan_sllep_millisecs, I use madvise() with MADV_NOHUGEPATE.

Would it be better to change using APIs in hugepage_setting,h?

-- 
Sincerely,
Yeoreum Yun

