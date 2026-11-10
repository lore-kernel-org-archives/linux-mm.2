Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F181460A3808
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ir9ZLK3P
Received: by kanga.kvack.org (Postfix)
	id 15C1B6B05B6; Tue, 10 Nov 2026 09:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D9B6B05B7; Tue, 10 Nov 2026 09:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E0A6B05B8; Tue, 10 Nov 2026 09:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D144D6B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:52:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CA26A85D7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:52:52 +0000 (UTC)
X-FDA: 85419501384.24.B140745
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DEB59180006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:52:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ir9ZLK3P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794322371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjNKU0fVTO1GwsQf4N77ndWDLlPg8PdsmZT2hfApWPE=;
	b=4ADgjwgGPixQPZpbsdwLAEHJRsCCaBxFfea+FuOysMq+xIo/GH9IeweEB8xMOxcHN5hFPN
	eogttDeLVCD1knMkj0z4flgouMMBg5QAqaRiB/b+nSf1y5cfUvw8uojKKfLtn8Gz7NlPxc
	R0XOaZIJDYRpgrrtsGp5OZLnMaYD50U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ir9ZLK3P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794322371;
	b=wOnGRk+cJBSwNgSzd+7egDcECJYPhnQ4BUO6tMKADLuuFklWpyb+8QkGRgg+O6HOByv33v
	zJekOChz3XVlUE2aYJnCMobxT8o08knqRKGT225EuqsLt9TKIqI4+MfK8BC8OiaMWF4bIJ
	6nLkHqqMjeG2Mgc0+yLnwF2HPO663pE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76FED639BD;
	Tue, 10 Nov 2026 14:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E291F0089F;
	Tue, 10 Nov 2026 14:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794322370;
	bh=KjNKU0fVTO1GwsQf4N77ndWDLlPg8PdsmZT2hfApWPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ir9ZLK3PpkfzDHwBcrLGOXj9EpS3CyRkUiWe2WwPnXWGe9MH7GhS0D6BtRe4YJbHS
	 BPWDdz6H34G8sRDEWFesNvtxhFSktyx4dL89CZlAObyY2+4zj+YpmdRZE4zYPYzlJN
	 EL7RwDR/T7DATHbxcGSS8hRjxDb316TtTTckKTKgWIK4iGZCB98im3bPBJB5r0hb7L
	 VsHPwUXFS83jzWgZtIgh/mqO7VaoEDxb5nwxXqHePDGnZbghwcb+WtWNAhpRPlFWH0
	 jGV9L3oUmue0lg5M7GyOBz+3YXmbdy++CeGlfIg/huEG/6o8pU9vyl5gl+SzYbNO0K
	 hFyUOG4XEhrfQ==
Date: Tue, 10 Nov 2026 14:52:43 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Seunghyun An <san55@wisc.edu>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Suren Baghdasaryan <surenb@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/2] mm: avoid redundant reads of the vm_refcnt cacheline
 in anonymous faults
Message-ID: <avMvlLOaByIc7SWj@gremlin>
References: <20261110000002.1834454-1-san55@wisc.edu>
 <avLxcf8KaFP_XPnM@gremlin>
 <MN2PR06MB66398F39E876279DA2CA8A52D2722@MN2PR06MB6639.namprd06.prod.outlook.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR06MB66398F39E876279DA2CA8A52D2722@MN2PR06MB6639.namprd06.prod.outlook.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DEB59180006
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: ufmj8ztb7kk8wg54c6zwwttjd7oxd3d4
X-HE-Tag: 1794322370-393344
X-HE-Meta: U2FsdGVkX19RfZ2EcM9aKLTB9xcb8cazmCvbtVIzgZD3gEdEJdohImJQYUNsvU/cdmVE3+vx/KbB1RqtywUMT285ZIUd/ajlPDW4IlbKQJafmW/GYup1+iVP7OrG5amq8mNnmEEskhKiX+0OgWlIID7+5NwUwkIrkHjkshF8ZQ/rCrSYBcYvgw6AFLyXeSQPtlr3BvMtpn7CIfEuxuhOkrN9tyk8APTdW3JT2jj0tgKJ3NVa5sD5WoiGRAiYAGItVW4cDZ6EWLenfs2cBr2ph09ANfd3bHq1bqF+8plfjvgq7paCyWAWUgFLFQroztjKxPQy5PUCWO/pyhZvxl/5gN4LK1pFCyJhiv25B13nZ8jJntzUJkAqDDsIwhnA3Y6h1qrE15238QHRqns9cXBDXu22d9rHaonUvOGNdFTmDfhUZtkpyEzIc+rOlwIQyAZ1cNNNq1XudKMIh0FXi2hcPk6k2WzDE9baIaLqb0w8pKKFy91r/Ja3job89q3e0Fv7lPmAlngVQQCK7PjtZw2qfLdphEEeFJFmpz+R+Pr/2OnBngqa15yrmws8VM5mhldwJlcmtCim1ODrxI4eezGKVQolzooWkvRcPLXm4WSSP3GIvs+W7F/LPhC56vrmBtfiWKGNjhRsghiS2whoKM4a5r2eSXM/gQj02WJSEGBnNRieurkIvrxBSqxO0uZYYN2tbBScXlu4sVjFmgk8Z59ZVtumhNGgGGY53EYrm+ooZLKaG6G1sxthkRmHXhLib9fz1vatrOHGvrHDF2Tqypmbqfq/jOtA7OCJIKtRNUHFzXLS4ep7Ss6XamK2nts3kIbD/42rLoNgYp9NiANHDF4ROlo0o5dzoJZJtvez5JU4SCeGcaExencqoMpmkXn8ANnuEigr5Osx0HD2hE9o7gqepV1eAFUWSM/WnGVeE1osvEO3iadxzC+skTd4punXjcFSe7FZgQP0WT1glE0rGEG
 PV1DJBMo
 mlblmp5mWJbABXGWFm81UfdKWHM+h8zxGJnGclR5D0Pzd8NNyNpklpl/+u6pIH2fTiBXSYEfACAl7YzxtZWVNBtRI2TSgtchzISy86nYxAJdF7qY7IhMacCF+cuQmpVTxcaEa/dQ/fYyyTmzva4nECs+B+a34jNI2+dNsy7274PQYNMpKP1W8CuXd75ZpZzYxBHhPGl8rE8lBK8kmEuOcOex1knwwp0NPxgsM4IWqwLsMUlabnsuWkUfFUYOsD8ih9/AKpUU8PQhXlCtet1cDAYw/IgoYckvzBA8cbqEBcd71q+sLIee56r1N59xtpE1ZLrIX6/4sUA0x1rkGSEhuTZiDu+iBrr4KoJ3v/rfDmT1ex+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:34:31PM +0000, Seunghyun An wrote:
> Thanks for taking this on.
>
> I should have disclosed the LLM involvement up front, and I'm sorry
> I didn't. I came across this while researching the performance of the
> anonymous fault path and worked with Claude to investigate and quantify
> it. Claude also drafted the code and changelogs.
>
> My main aim was to report the findings to the community. In hindsight,
> a plain report would have been a better way to raise it. I wanted to share
> the measured effects, especially on EPYC given the higher cross-CCD
> coherency penalty, and offer a possible way to address them.
>
> I'd be glad to collaborate on measurements for your series and any
> follow-up work in this area.

Thanks! I will cc- you on the patch, and if there is any remaining issue we can
chase that down.

And of course credit you on the patch as reporter! :)

--
Cheers, Lorenzo

