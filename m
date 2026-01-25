Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55097E63CA0
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 11:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272D56B0005; Sun, 25 Jan 2026 06:32:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220206B0088; Sun, 25 Jan 2026 06:32:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C006B0089; Sun, 25 Jan 2026 06:32:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 009446B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 06:32:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 994BD591AC
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 11:32:39 +0000 (UTC)
X-FDA: 84370273638.13.1AED1CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D51011C0007
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 11:32:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=msLpPpb3;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769340758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMowTRC9OtnPDS2ZtFYbgFHKwlbH5JZ3LWx5m6VSM5Y=;
	b=D93JFkxb/7kwILSp4S4tl12cMmFHuiCeFTQAVBI4+Ju+NYBAU6Acs7ND/F38Q4X68RajkT
	XNIy/HtCflH0YgVTZv6BRRmAZT5emMEW+x3g22K8pEVGJvxaHpRXZXo8ftzwKzTtFtNw2S
	JtWMryxQwq0ATNDRyMl52JrXv5H5qZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769340758; a=rsa-sha256;
	cv=none;
	b=O4VYnEfDsgrmyJIQYiSTYCbYonrmqWt3HegCkHcmyJxcy8phT3PZdjz7g4Yq13EixEj4Sy
	lhcsyJqlyrupHvS6HA1SYo9OgzEGVTx8iACT6BwEazKM2QnAiM0775jWcAcC/29KgFoGhw
	t7XuFFT/vTFItN9VZPBNkcVmCdRxhPk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=msLpPpb3;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60DD743BF9;
	Sun, 25 Jan 2026 11:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4098C4CEF1;
	Sun, 25 Jan 2026 11:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769340756;
	bh=DALCkrQPWtk9H7+d/aGiJ42oNVLwpdqVy+SfoWTK9Q4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=msLpPpb3AN7Nz6lgCEhTvDNv/wrAShMlG+UIDVdsOhpcdvF74+u6CfBG4Alz7jxOq
	 6GGi/65QVo6nZ3ItWks6RPBBrbPZinQD/2QRGVN2uq+BqQrSv0c7kOb7USX3EgsH3q
	 RNxLYVhwS5hoEL8qsYz1fQVil40SPdL01h1+hNbXAV3IvYhZkGJee5UcMfnM4bZy39
	 amJJc4dbvXNA5DK/U/HzvdBdwP0mjN/GIo+rmApMtxOQjixkFXgQxXFLmtcrAydotc
	 kLX9L21y29tNDLCT5b4FyGT7UyEleZzk0XFK09d635WSoVe56bXmhRXAam5GhWkqGL
	 YIfzVqZMI9LYA==
Date: Sun, 25 Jan 2026 13:32:27 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com,
	riel@surriel.com, kernel-team@meta.com,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4] kho: kexec-metadata: track previous kernel chain
Message-ID: <aXX_SxpI8Tuh6Q3V@kernel.org>
References: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
 <aXICriRKbYB5f3li@kernel.org>
 <aXILzST3NxyYXW1m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXILzST3NxyYXW1m@gmail.com>
X-Rspamd-Queue-Id: D51011C0007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: d4b9zsra8ydbx3msz5caainttn8hinkk
X-HE-Tag: 1769340757-69253
X-HE-Meta: U2FsdGVkX1+vdsgUbsi4p52vHtcJ8nK3wYaV9SJfZalR1CW/YB1iB/KY9FXj4rtTMMhUKttFs3ixe4D8Jw9WFfQhFc4BA9UfEJjMfB1wd+mTZs/gp9QfMwjQvOjWg9SLJlKf6kL7rJ5zIlTe3V0Ui6hMD1nGsQbERTbcPZZ3elvM1I81ICzwBMKjLedHIsXzYdFJ5Hx51C2ikpYli+AKjKpkbI9/TVu0yFeyJzJA1yAMELlmfHeU1LO9ThyWKXqjEPJTXJmjBM+i8e+lOrXxvV1/aSkyMjQ7gwxxRAnkBUVEltX3NNh7uhY+ZVSP81WQzWkKlw66xick/03PYthCJ+qNMt9a796GJqXOjvE8P5AJvg3tmVlfVqRKHGhgsylg0qtFKNacLQS1QCXK4gFSYp77UdYhepxYXvuR5kOj80vHuXxBNZp+nCQTPczbzWSVAIKXpy0Hsb4SXMNPHQkU+kbftv3CF7fH9vcIP2VegA/2TWbhXd5tvfxAcVT5jnwy/ZTQYeGrnoZCHmhKYf7yABxc+yTgJZQm2OqcHqao/gv3BBm+K9vgWJnkShob6CojYv7g3T/GAIeKXDQ/gybM0LdLgKVM8dQUY+jFqtpYZlYAyX6jedRPNx582gNqh2vb/N+T3ClG3qoEAKbJTryxsQAVDsmC95rDrkLWvlRi2nNKo7jNVtrJ8umlo7N7Q829EFOFIFlhN9yZE+9sWy54NnB36q3KouND9rO+uesk3xgJwEHn4a99ie1iJnPbxzB7CcY8ux82PnCH5s2n9mEv2eJmZGa95E2F6JrHaEh4uktrWLaeEzy+Y2KMEUw96HV4sHG13mt1k7cwOghfJvn9dPAGm6cVRONCrPvV2SBpPpKmCOT/HgU+3Kr+gPQV2NYgQ+MgxHS2jQ94CKqn3qApcuJRPrfvT38qFmSHJF5XhnP7I/3O8lbggMt2Zr/R+OpW0QYPRStM+M206Aqt6HH
 J0haONP1
 6dIeZzFKQlPmev/V3VEpwjc0oYk/P7bJfnoLbOU7dvEU0vuo2FeoF73YYxP09I67yvbv9koYKbm15wzOs/Be/9f3G1NeoU/eYolUxWa6KgM/Gv/qK+dwmwaHJ1ztxymKcQMgkQ/kkQHWCQtljPmmqfYRj07QcHz2nd4lfndIac4Q+BAbY6rjxOtONfznRXIdILslNNB84z57PSXgDUxQJwUZAggVZvKpF3x3nuYwqBlUtoLTmyh9CgNctiIZjSQe7FsqrqUG7lRgl5a3UZnkqUMSUQV+Jv9EHLliXIpcC+Y5w1nI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:04:55AM -0800, Breno Leitao wrote:
> Hello Mike,
> 
> On Thu, Jan 22, 2026 at 12:57:50PM +0200, Mike Rapoport wrote:
> > > +/**
> > > + * DOC: Kexec Metadata ABI
> > > + *
> > 
> > It would be nice to link it from Documentation/ as well ;-)
> 
> Ack! I am planning something as:
> 
> 	commit 90e098ca0d611b44594f08e50ba1cff3c932dd2b
> 	Author: Breno Leitao <leitao@debian.org>
> 	Date:   Thu Jan 22 03:47:23 2026 -0800
> 
> 	kho: document kexec-metadata tracking feature
> 	
> 	Add documentation for the kexec-metadata feature that tracks the
> 	previous kernel version and kexec boot count across kexec reboots.
> 	This helps diagnose bugs that only reproduce when kexecing from
> 	specific kernel versions.
> 	
> 	Suggested-by: Mike Rapoport <rppt@kernel.org>
> 	Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> 	diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
> 	index 6dc18ed4b8861..1faf2c3ba4620 100644
> 	--- a/Documentation/admin-guide/mm/kho.rst
> 	+++ b/Documentation/admin-guide/mm/kho.rst
> 	@@ -113,3 +113,42 @@ stabilized.
> 	``/sys/kernel/debug/kho/in/sub_fdts/``
> 	Similar to ``kho/out/sub_fdts/``, but contains sub FDT blobs
> 	of KHO producers passed from the old kernel.
> 	+
> 	+Kexec Metadata
> 	+==============

I'd move this section before "debugfs Interfaces", other than that LGTM.

> 	+
> 	+KHO automatically tracks metadata about the kexec chain, passing information
> 	+about the previous kernel to the next kernel. This feature helps diagnose
> 	+bugs that only reproduce when kexecing from specific kernel versions.

...

> > >  static __init int kho_init(void)
> > >  {
> > >  	const void *fdt = kho_get_fdt();
> > > @@ -1357,6 +1413,15 @@ static __init int kho_init(void)
> > >  	if (err)
> > >  		goto err_free_fdt;
> > >  
> > > +	if (fdt)
> > > +		kho_process_kexec_metadata();
> > 
> > Can't we move it into the existing if (fdt) below?
> 
> Unfortunately, that won't work due to a data dependency between the two
> functions.
> 
> kho_process_kexec_metadata() reads from the FDT subtree and populates kho_in:
> 
> Basically:
> 
> 	kho_in.kexec_count = metadata->kexec_count;
> 
> While kho_populate_kexec_metadata() increments metadata->kexec_count:
> 
>           /* kho_in.kexec_count is set to 0 on cold boot */
>           metadata->kexec_count = kho_in.kexec_count + 1;
> 
> If kho_process_kexec_metadata() is moved after kho_populate_kexec_metadata(),
> the count would always increment from 0 to 1, ignoring whatever was passed in
> the FDT.
> 
> Restructuring to call kho_in_debugfs_init() earlier also doesn't work:
> 
> 
> 	if (fdt) {
> 		kho_in_debugfs_init(&kho_in.dbg, fdt);
> 		kho_process_kexec_metadata();
> 		return 0;
> 	}
> 
> 	/* Populate kexec metadata for the possible next kexec */
> 	err = kho_populate_kexec_metadata();
> 	if (err)
>                   pr_warn("failed to initialize kexec-metadata subtree: %d\n",
>                           err);
> 
> This would return early without populating the kexec metadata for the next
> kexec, breaking the chain on KHO boots.

How about we rename kho_process_kexec_metadata() to
kho_retreive_kexec_metadata() and add kho_process_kexec_metadata() that
will first call _retrieve and then _populate? Something like

static int __init kho_process_kexec_metadata(const void *fdt)
{
	int err;

	if (fdt)
		kho_retrieve_kexec_metadata();

	/* Populate kexec metadata for the possible next kexec */
	err = kho_populate_kexec_metadata();
	if (err)
		pr_warn("failed to initialize kexec-metadata subtree: %d\n",
			err);

	return err;
}

> --breno

-- 
Sincerely yours,
Mike.

