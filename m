Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69317606A336
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X6IHrBc4
Received: by kanga.kvack.org (Postfix)
	id 742676B00EF; Fri, 20 Nov 2026 12:33:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F2FA6B05B0; Fri, 20 Nov 2026 12:33:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630296B05B1; Fri, 20 Nov 2026 12:33:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 418786B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:33:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB8F514012B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:33:36 +0000 (UTC)
X-FDA: 85456194432.05.A10789F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 35FB380002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:33:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X6IHrBc4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795196015;
	b=C0GPCCECnyuliPMvOT5h6YXfRzpgzkqscrtRvLvC9AzA7S+Cc990/ld7mdk4mAmRz2cJIt
	o1kf+6OLJGlwjrtfyNYqTUaqkpfpW5+nNV5CqpUBVxRq0M7hKd0W9J1Pk4fARR9wvQdX48
	RuBbRByojJ0Oiy7kukGs3zou/ty+7HY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795196015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Arq4ZupDcmhiLMBgMCtvkojQM2xEuqkXJFom5GjrF7k=;
	b=esCw5VRiMN8PhFsx61dIn1BTNt5+MoFx4ufnAzFe7n20u+/fPZVYCPGT7py3MZJGgN+v09
	RJoWv/Y2OqiHrVMT6E46nwaLRUySL3QBmSPJicxJ9DwIRiLDvaYtIfWFN3vxeAQ1rVv7Z4
	xnXOzrWZ3b9uNhuEyC70XX1CrQn+HlA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X6IHrBc4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBB39601E1;
	Fri, 20 Nov 2026 17:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1541F000CA;
	Fri, 20 Nov 2026 17:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795196013;
	bh=Arq4ZupDcmhiLMBgMCtvkojQM2xEuqkXJFom5GjrF7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X6IHrBc4sPEWvfGtTrmXHiTVGJ8pC6ELePyhHwK2UqV7GGN32ejxyrelfCct720gJ
	 H6UiJgwngKpOcZ+h1OayvsXTWmwqGoLNj9VvXh0knCCMxbJoW6azz/VWUKaCPUXZqE
	 kcAOcw20iuqvVY0FvoswQPFDRBo7w6V9yaQo0OFvU2aPdWnZT0MhPe2hX/KNBE4ffG
	 pCismMxf43LQSGcnY/znHctajMbuUeMnT0EfKPCUAES0nZTKvAXjiG1DT5oD0li1oH
	 rJyCt/SvaBxu8V3cJlLTnMvMGYXMAwS/6fThFdkWX3H5ptbwNy3HtaNEvPRcxiVqOv
	 vFvJ7XylkykLw==
Date: Fri, 20 Nov 2026 17:33:28 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Christoph Hellwig <hch@infradead.org>, 
	Yuan-Hao Hsu <aa9736195201@gmail.com>, John Hubbard <jhubbard@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 5/8] mm/gup: break out gup_lookup_pte() helper
Message-ID: <awCD56Ncl5_Tjrl6@gremlin>
References: <20261116210127.3837898-1-riel@surriel.com>
 <20261116210127.3837898-6-riel@surriel.com>
 <avxXgTBaJkPN6XOh@gremlin>
 <89e41824f1371b5880029f264e19b5d0589ae22c.camel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89e41824f1371b5880029f264e19b5d0589ae22c.camel@surriel.com>
X-Rspam-User:
X-Stat-Signature: tf5tna3m4tj4o998x5d4m8yjxkqftkdz
X-Rspamd-Queue-Id: 35FB380002
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795196015-224117
X-HE-Meta: U2FsdGVkX1+Iwj1f2ORZ78jY30/8dT7P9HNUkbuuFXfbNYUIPMgIfMPQ/vKZkC5nn+WC64GVnH/6erwQNEDKjGx4T/4fYkmJP0YRW2aMeFhJ0eVJpwPLnFdAbps/P/QS5Kum0FBJqlSExuLiUXqS/HKv7bayWj4k1GCaOPH8SKsBTnOoWfqqK/ZggQPzNf0PGwLugUXChFij1poXrRdQJE3WYCLrz1tQ31dPejnbiprh4pU0YPRFQUuVwgsYpCv/aI+g4jc73yuC8v7uX0ai7h/aADQ36UCOEBEuAJUSWHQHRIM0bmdE1dJqB77pC45lX3MQYLGPw6AgoyeHa1tIjB6mrR3sZW7VjaNnG603e6krlowqcdaY6aH50j5fub3bMjceMNAe/d5Z2wdUvfpaD/rqoTWjyZmyxEK6hvAAucYSESCUUoekDJqz6DlXp76ijrcFw9PZEcUR6zQ7crcMhSMaBqtq4FN8R1TL8WjsLqKT2AP4ZSojWJujkP4HXnEx6EoarWeXlDZIqBok1cYcMgL9pOBbZGs3VoV2HEheaOZDZ69gVLObsLME8mePS0HlU9lC5fW0qhQm3NxCL4x/eonPwlcTAKTX9LASKm/oudNSC7NJPDQ1YqUp8/ZewsyCJQDewQRfL2owcvjpiHd8BqQ6aOIQMMkm8ZN8fzrwxYHf517FbYAREzZjRKQMUHdebgZd2l7oM3XG/5pCPwAW0o3EXP/hU0e8akO9k2pXtxbe2qvYaDd71MYXFL8wtOJWvq3xZnCYoYWOPiEM8Hr+o5dH9s2dEhtSW9eAzV2hkvF+IChQFjBp+b+ZS0LhMdLUq7PMwQCGmXGJcQybazVfdW2q+l8t2IJpquNpeL0LweVH0U3FOKi2vi/Nx2paCB3Mmcn8N1o5Mm5BoC3OPLTCUX+5VCIDCwYNKRWt7vItHlnQeVeWKPi/7pWroJPVIjCfsETVqDPEe0aoowEiB/a
 ZbxrEpgM
 0FB/3RH3A/UKiXM4eJnR9pYVwZIDTzfosA34JRaKTUsw2eYYHgVCL6qNABtBOkUzRUZqfkX+6/h7TN9bj9FzbyQ+LvnXL2diAtJeptd8pmlOdqhDynRSnPFsUoaZlzkJLm+QNf3Uo1A9F/2Jq0OEKz+f/QrxAy//idNsRSpTDwxFiI5AaUmDu8RzVUT8oertx7M2/MdAfHfWW4DVFY7emPELcs9HQ0132XCIPB5kOds08ueW9tiWoFMXIqkk+DaeBfUnvOa/qoss6dTx3rUB1H3+L8N8q8kApvYkuWK8m/V+hdgzDufPMogLrTZjVlh42aSlYkzZ6rQ5NfMv8SWIZk4AMmFYtlQqMoirlFPKM1unz0V8F4ovdnHoBvGerh6c5/wFEjtyEx8JtnH2Y4742gj1QNqjYWV45/nPQFBpTq4wSBVkQ2tbi0lAZsfgV54lsGcPhrPytgt93Lbg/N5Tl5dNG5lbZmhn17OcEnVk+OkSNZjVboaR9kVIjCRBg6A3hws/I/YlOsZQT3LyeqG9atwcPkofViGiStC+FxMqQuCEPaho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 10:04:04PM -0500, Rik van Riel wrote:
> On Tue, 2026-11-17 at 13:48 +0000, Lorenzo Stoakes (ARM) wrote:
> >
> > > +		need_no_page_table = true;
> >
> > This is set true but not used anywhere? This is dead code no? Am I
> > missing
> > something?
> >
> > Patches should be incremental but adding completely useless locals
> > incrementally
> > seems silly?
> >
> > > +	}
> > > +
> > >  	pte_unmap_unlock(ptep, ptl);
> > >  	return ret;
> >
> > I'm guessing you forgot to include the code that works with
> > need_no_page_table here?
>
> That code is in patch 7. The check isn't needed
> yet in patch 5, and it got shuffled wrong during
> some refactoring.
>
> In v6 the need_no_page_table thing will be in
> patch 7.

Right, I think I need to see it in context to judge really :) but obviously we
can't be introducing completely dead code like that, even incrementally.

>
> >
> > 'need_no_page_table' isn't a great name either. Maybe is_none or
> > something?
> >
> Maybe pte_is_none?

OK, let's see how that looks in context.

Since you've not replied to the rest of the reviews I will assume implicit 'ack,
will do's or what not on those? ;)

--
Cheers, Lorenzo

