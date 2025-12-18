Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15BB3D6ACF5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1C66B0088; Thu, 18 Dec 2025 08:17:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685606B0089; Thu, 18 Dec 2025 08:17:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C97D6B008A; Thu, 18 Dec 2025 08:17:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 459A96B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:17:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C21113862C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:17:57 +0000 (UTC)
X-FDA: 84232644594.13.530DCC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3DB114000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:17:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X6CJ2Dol;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766063875; a=rsa-sha256;
	cv=none;
	b=KJcxitui9fEMTmyQE+E31MJd2d2jQ/hCI6/z4TgCRfCUuqRfAMf2lhrAbLzOpJmO6i8J05
	TGiD6xAk97iuT7zlPYmIXK1pN1QWhftmL5uMTezBig7Qg1BiwkWiC+LEuF3Uu+x7ZyLYCA
	Xnszq65mB7eqPUDDfBKMM0h2FTeiDi0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X6CJ2Dol;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766063875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E67fGDCBzx9uy4pFH+4mRNamoM7TPirZS4XHX7edAzI=;
	b=44Sh+LNknVlFonqtBrTQRFgvL18Zvr9QMBIaI5Atp4od9cKoCuThvIhHBb7LJEA1HzmY0V
	mVWwKvZ0uPkvdIDuya941vyhwO89i2KWF18OXYQEiCryxh6BtDMCsw283L4Q8/X2ueyMdE
	DVW16qxPKdY44jp71O1pYQe7IRiqvxE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D2154423B;
	Thu, 18 Dec 2025 13:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9350FC116C6;
	Thu, 18 Dec 2025 13:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766063874;
	bh=4VWyNDc7jkUhFCG28e/nJjTfP2bqEFkzHBtDEtmEzi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X6CJ2DolkyOCrETzfXDQBKmayYQWHkhuiWBCF1i53hHX/QHK7i/JFcq/sBxsfwiil
	 j0qOV3XgnIFtCKdY0watZKSlPdwl+wS/ScPfDje5dGkQ80b+x+YKEn700nz1pvdecO
	 Nb8V/wacRMDjfV5TL54Jmy7VSmNs6GPIW0uYq4p/KoSFkPNKgebVDr2kO/3PZPZBmN
	 H7ELFEWy1a8oMZQGE+5aGIkZhZp/0lZyWod1+yXYdVFr6uApMblgMLs79SWmbLdaf+
	 cO0As7Kg40ramCm5m6iRVSCyAlVyLztL2Wj+FnwSdOy2/hS2F31d5p1FnjZl4TLrn6
	 4WfhCno5t/qzQ==
Date: Thu, 18 Dec 2025 15:17:44 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tao pilgrim <pilgrimtao@gmail.com>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, kevin.brodsky@arm.com, dave.hansen@linux.intel.com,
	ziy@nvidia.com, chengkaitao@kylinos.cn, willy@infradead.org,
	zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
Message-ID: <aUP--JzrvOm1-Q2P@kernel.org>
References: <20251217120858.18713-1-pilgrimtao@gmail.com>
 <aUPiFbuaglcjqiB1@kernel.org>
 <CAAWJmAaxtKY50BEm3N8V1QTwpyCgQLfLFarrVfPVVpXg9ftmcw@mail.gmail.com>
 <aUPvecgVj8XXBcw5@kernel.org>
 <CAAWJmAa44SF=dj+FTiXn0aZwLLGbSTAieb8Cy73RE0sGAkAYLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAWJmAa44SF=dj+FTiXn0aZwLLGbSTAieb8Cy73RE0sGAkAYLQ@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3DB114000B
X-Stat-Signature: zfh57h37aibtwatzapks44a9qwmr4oqc
X-Rspam-User: 
X-HE-Tag: 1766063875-211293
X-HE-Meta: U2FsdGVkX1/sQCh1BmLS5a3X6X3/VO9vQPnXnAyr8aVIPiJSOe7/J+NVDUkCKIHmYJYoIzoqEq5W0qaCIjjBEiXY24Pr0pEM4LT3nxs5QE80VQnq/Il7eTvZAVjVIi24D0axurnrT8v1YkxG1YGyaDUukIWPMBQ8EIZF77uVtfI9q49G9qB5ZSFC6sRdQNuDEK4ecaSBTFSiMShCfGfKbs9FasV9HERlCPyu5YIlNK3j85qi86i3mQR+1b3rSdnvnsjYNEHcPBiJVFJgLThl7AuD/Jr/UaZoFZz0tdRtYPnyQn8u3SJgqLntNBeyIdkSFRuWCl4kh4+3nxv30m1Bq1T7mYVcl2uqaTZ47BoSHCAoQavDKuMYLqEGU8n/Bq3Gx+v/2Iim6Jc3DlbvgsXHbm08y3iHnz8Hvg+Gqx7IZlwZL8m1mZy5lSt30cH4w98C2CbyBqwbG0EtmYZJnLHRN0tIbgi3oJvjz0lT4q/5SO+vwFQ5Kcmk2fP6yXlfF/ligebpFRfydm6WSn8nI1f9D4kkC73epQiSg6XJ1meWqRvfZpwBAzS9YJA6Y7w1n/J1TkqCSW9b88huo09zf/AhtA0SnT6oYsG4ZGPwTToASZvwEju6LwqvseoBIMSy//D9cpmGSHGtOdEm37X8y5Yo1H7BdBbg0sUWTxxBPqQxwMo8I7qyrwjLE3qXJQJRsUdBHLWLSNKY98DclsjLXowfQqbTNvEronS6GC1lhcuwAV0CqrFbtlCLOzSCW9L2ZRQ7nLOV9yUFABSQX/6lJ3Eel+SEzkkWHANeNa/onJ+utrhRNcdF8NaeD+hxeOEbVjYumi+f3SiE4PSTPpkEVPw+vQ2dauX4besdKPZ6traRvQ3X1Zyj1xk+Kf2eyJRSFHJqqzaPQbAqHF7uiTDMGF/7lnpaiIzH4FRfSEN5A+YLASpbYFD4QIT+ShWWR+wTnuf+ZN6Xy8SsdQGIR3AoIVp
 WHFznbbk
 9gd95bqOOkE8FYXbxXWV25hB04v2iAbZsAlrkp3/0uGL4Eqc+8kuQN6MFVS6HZfD/Viqq3dlxCqLvQwLwcdDttc8CzhyMX0MsNJ4Cwu7DIO29pkGVlo8Bl41g09DHBzGF/vHLwz/wh0stzNI4lZba0XJQjVXORh6JLPVHmgNxrS4ElYwq9S1o9UdXFDr9IOXVko4jgBS+Jt5XOqf9zzBnRfh03EMYRbRYelt8hSgCnjm7t7AXwbziqbSN4uOsyck5/y4WzQ6S31yoA7NhjK/Y64wQe+Q6UMJge78OEAfyY3SJ3WG22+Y0M7cwowmx27Lac59Twki4qAWTeGf9V6wQEvu4Y5MDEOg+/Xo9+qVk5XI7IWL5FT2B2XTIn47dSUAQS2mAGOs0lFPjG0o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 08:29:27PM +0800, Tao pilgrim wrote:
> On Thu, Dec 18, 2025 at 8:11 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Thu, Dec 18, 2025 at 07:45:52PM +0800, Tao pilgrim wrote:
> > > On Thu, Dec 18, 2025 at 7:14 PM Mike Rapoport <rppt@kernel.org> wrote:
> > > >
> > > > On Wed, Dec 17, 2025 at 08:08:58PM +0800, chengkaitao wrote:
> > > > > From: Chengkaitao <chengkaitao@kylinos.cn>
> > > > >
> > > > > 1. Added the vmemmap_false_pmd function to accommodate architectures
> > > > > that do not support basepages.
> > > > > 2. In the SPARC architecture, reimplemented vmemmap_populate using
> > > > > vmemmap_populate_hugepages.
> > > >
> > > > What problem this patch is trying to solve?
> > >
> > > Following the pattern established by other architectures, vmemmap_populate
> > > is reimplemented using vmemmap_populate_hugepages in the SPARC architecture,
> > > which fulfills the intended purpose of vmemmap_populate_hugepages.
> >
> > But what's wrong with the current sparc::vmemmap_populate()?
> 
> The current implementation of sparc::vmemmap_populate() is correct
> and functional.
> 
> However, I believe that generalizing vmemmap_populate_hugepages()
> still results in certain architectures requiring special-case handling
> branches, which is contrary to our goal of a unified implementation.
> 
> Another benefit is that it allows us to eliminate the external
> declarations of vmemmap_p?d_populate functions and convert
> them to static functions.

If the goals are to provide a unified implementation and eliminate the
external declarations of vmemmap_p?d_populate() functions, I'd suggest to
send all this a single series rather than a single patch that updates sparc
implementation.

Regarding the ability of sparc to fallback to vmemmap_populate_basepages(),
it does not seem to me that this is an architectural limitation. sparc uses
base pages in the kernel page tables, so it should be able to use them in
vmemmap as well.
 
> > > The functional logic remains unchanged.
> > >
> > > > > Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> > > > > ---
> 
> -- 
> Yours,
> Kaitao Cheng

-- 
Sincerely yours,
Mike.

