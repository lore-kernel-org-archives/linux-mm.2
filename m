Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3B7606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 12:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kQUCoZgo
Received: by kanga.kvack.org (Postfix)
	id 5DCC56B05B1; Sun, 15 Nov 2026 07:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DC76B05B2; Sun, 15 Nov 2026 07:43:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D066B05B3; Sun, 15 Nov 2026 07:43:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 267ED6B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:43:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19691120542
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:43:49 +0000 (UTC)
X-FDA: 85437320178.01.D530EA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 75B8E180007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:43:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQUCoZgo;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794746627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ItLIVfR1UvySuEEyBIwhJcSgZBhLRZU0DncWL/OBsMk=;
	b=abmo7SdwWMd0Az5pb4b8K0NOzvVQazkaPy727I1aywMGWh9A02zMqiOtl/0n+PF25F+Uus
	bOthNn9rq7E5LMhvUQHB9PiZNRqd19nYDAokyvZjZ0bcfLfK1ak9zYbluRSJlvd5iyUFuY
	cSY+MNqvcohP6orfGPMmIXVTghWRFJM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794746627;
	b=wMARlJUzKNyPVofMr7mNUiPPxp3BQfNsh74b9JZLgwGnspoAbR+Ns9lntX0YO2N0GBqxhH
	MFTIu8h/4bwjgtKcQzY05UmQlEFPf1xmCU0KGXaTzGOwtMMoT0Fn0T0P9HkB2DdCP4MxAJ
	2jXxNA4MD4YkBDQNdeVNYlMyHxVZlgQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQUCoZgo;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 02EA960D9D;
	Sun, 15 Nov 2026 12:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E391F000C4;
	Sun, 15 Nov 2026 12:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794746626;
	bh=ItLIVfR1UvySuEEyBIwhJcSgZBhLRZU0DncWL/OBsMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kQUCoZgoZYY0fcgF/LYN5sg/FhigfV0RmeA/86U/4sCjPuPGBE7pd/oHPIVJVMHeI
	 2IlWDFrE2uywqCCL3Jj4I0gGH96okLxf/UhYvS5kk81lBsUXiLT0XG4bnC3fmIIbQT
	 FAXlrPGLPbzjzk/slqBIXIi2bdAAItZxNHxkbUNb2Djd2SOHBSqePSUK+11mTmke2o
	 pFbiltFhIDDUt2GyBFurnDfb1H58W6ugxVtf1bPJT4VmYgHVtu2+LnWlCcDTfojdcw
	 G5zEG77A/QC/3H4C0a3ofuIthVL6eskpAnW0W6WqaYJziKQzUOtpAXQO19MXd54q0C
	 fv05uW8CCyplA==
Date: Sun, 15 Nov 2026 12:43:34 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 08/13] mm/migrate_device: fix ksmd oops on a migrated
 KSM page
Message-ID: <avmojuNNO_ZRKL1P@gremlin>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-8-50a2ed382b61@kernel.org>
 <20261114115657.f63de4714929f7af@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114115657.f63de4714929f7af@chrisdown.name>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: hb41cxdtaeqfi1e7gjqx8x51sz9kfyea
X-Rspamd-Queue-Id: 75B8E180007
X-Rspam-User: 
X-HE-Tag: 1794746627-553961
X-HE-Meta: U2FsdGVkX18lkYq+5CAdXmux6JLIURjYcJNrQoi4ugLThebkbw74w2Hp+pJp+Ue03lRDG9aTmWQRRPcgDT2oEsRhJrZmBwMfvnmfO/wW7vd0N7Pi2XPW6MxfAqxm2A+zpeShewJTB4Rta4Fj9+Jj29/pEtI7TfkFe4RIXEm3zDXYpE+E5exMSL/zvYqlTGoOL3jLCk2/7I5+3DGEX0gYXKdKM/Ba70ZJnX2xdjjdwQXbuWBCxJCBrFlSugH1T0RPMZRNgk1jKGPQpTaGrBajAVUj886iTuLSV66nRuH5l8yIrEv3SHSwfRfk/s5Gy0hK+vXkTZBYeLdEiUt6hcOrQlwQVYQQ/+QwriPdclV35L8qdKOfkooazY5q40E+3W2Hv1cFcd+MDqc6IfxcF5TNrBDH5T0KGuQIpPxZUtFl995+e/6dygwIfvCqoJc2OkeUMcxd8BgFv8fd/MUP+hq7K/RlI2ENFnb6EwDWyvj0zVSLTyRneUBlaJXPaLMeHMPoMx4QQLcIJyFiKQM6Z1QH8qw8ziDICqA7HW7DAZ+bm/KAjYPCzPU0hD3SlAKm9V+G8NyeiXCxzYa9fpFEBhiKMtenxtF84fzfkoM+nv2QjJ5NJ5u0Z7xCIhxLoxN2UwEkBW4tM+F0aMcDWi9ATEPjC+7HPGAa/0MG2ofwgM4eu4jIr7i1dL6dQ+sUfMvRO6VGWSxdDy3g0THR8owiWCwHw9L7MPdmkrQimEJqo1Hn5dPKKHdwIT5kkwPaDzGdct7daL8M9LvMAk5k8dIQZcq6ksZNh956fJ25zUo/nu6gGS9gFTKduZaTkgLBPobZSql2DSRmhqZR+4jCCgdg7vgTPQ/tQ0WNg0zF/lba6tW8fm4OleOK6akCYii/YPg2DxqvRfXBJRmBc9C+Xh1m8xsIznogkDa9ZcIGmNG7U1G23EpUtdjecjx7akE4BW36aZgUdtMA3kNGyoFMmF9PUWW
 8ZPXO1GL
 IyU+5ldwk7mteQ5KNXv5Z1HtYmRIUpCPuHiOwJax8tJzC3CF8UvePvrQWNhTmJ7RCQoBa95bcoa/rNnb/OUAV5gd5QIW+t5w5V4SodSMmq5JlSI2NCkMdYoaD2/MoF94yiBJLt+anSgCJwTW3gT+CttGhwMuizaW4TbYCcLZqKXKhbEtjlvnJpbKkIGNw2lLBvAvcLjOv4jmahf4AspssJi0iz8HsYDlNT9v1UISzA+A3O1nrgv+W6xa2740YxkjRBadMPpLfwpzmvwFlgDt3TwRw5XXrFzEcRcUzxtF62xINstlyPa89qMpmh4+mBYVWq1QY1PNd6ZiPdkf+l38XxBvkYFoAOAuvSY28soLYRB37r/2OH2RUg0tOPY3J674dKW5xKCuPb2B+2L0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 11:56:57AM -0800, Chris Down wrote:
> Hi Lorenzo,
>
> Lorenzo Stoakes (ARM) writes:
> > [ ljs: tweak commit message, comment, also refuse device coherent ]
>
> Alistair's Reviewed-by on v1 came with the argument that KSM pages should
> still be able to go to device coherent memory [1], which is the opposite of
> what this does now, so it's probably worth checking that he's happy for it
> to be carried over. Going by what ksmd does with zone device pages, the
> change itself looks right to me.

Given the endless waves of AI fixes I think giving a little slack is fair
on details :)

But, yes, that was a mistake so - apologies Alistair, let me know if that's
OK.

>
> I've tested the device private case. Without this the process hangs the
> next time it touches one of the pages, and with it the migration is
> refused and the pages stay merged.
>
> [1] https://lore.kernel.org/r/avTu3LmscsttRVRp@nvdebian.thelocal
>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

--
Cheers, Lorenzo

