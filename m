Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1135BEA8112
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED946B0005; Tue, 10 Feb 2026 08:10:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B9B6B0088; Tue, 10 Feb 2026 08:10:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7CD6B0089; Tue, 10 Feb 2026 08:10:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2566B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:10:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A94D14017C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:10:51 +0000 (UTC)
X-FDA: 84428581902.08.E911DAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 16EE94000D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:10:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YAK2dF3e;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770729050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0h9spvQPsXRmFyX7NfVe0MGvBvIuwiJh1xd+Oy7s8A=;
	b=beV+8TaWEiN+MMnUTeop1L1KF06Snyql7CU7hqfO/WbzBDjqFM6EKWa1fZcCtu8cep6xKP
	q2l0ctzD8d6yMsLI75jOo56CVlmCrjjdJQbrtycp57nBMwyAUmx5KniGtlcUTCQaUCF11j
	Jif3n0oK2LrmkHV0ugVpoVGHq2T//gk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YAK2dF3e;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770729050; a=rsa-sha256;
	cv=none;
	b=bB2zfYEtJpdGdEVRXuPSeUh1SBIKlBa1stE6OF4zgcgogD0+chTjSdSeeLMI/0J4nGbSk6
	H9oAU08PWVGEXZj3BcomVckX85bC03AI3pzz3psfuPHkF1F8lnBx84VKDHtMEY44sESA7q
	Kk52IqdeTAPpYTygVAn5YwD1XejHwh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D5BD60127;
	Tue, 10 Feb 2026 13:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F91C19423;
	Tue, 10 Feb 2026 13:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770729049;
	bh=y/HJEMaa/rbv0tW6eu8usmweDN19KKP/8uDNCBZhhIk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YAK2dF3e6lqB6pnmA+92RZmQ0JxS3hdmtrlWH7Jz+RnEUeWsrg3LJAlPHl0GcrSPf
	 my0Bd3/hU8KVKgVRr8mk3XkU42cjfs7f/8ciBFxBoxeDYXWLAx+2bZTTkPsx1P55d9
	 YYVWLtMai04SQzbJBBrCHbgEJdcL0PR7Ck7B5H8f6ihl46obqnBWV9l5W14fWQObk1
	 0NSh4d6EpTsapeDSGqPVuBK+9SyLfyNrJaKSFL1sQYnkH/LsvWUeEayowKhUorndES
	 JEdDncgOcjnhgUgHsZ+cA+TMccqh1vJqyUBBoV78whC6k2Gu9R5OqwcJzOheqBow8c
	 CWN/XFgXUw8yQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Hugh Dickins <hughd@google.com>,  Baolin
 Wang <baolin.wang@linux.alibaba.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Samiullah Khawaja <skhawaja@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memfd_luo: preserve file seals
In-Reply-To: <20260126183115.GU1134360@nvidia.com> (Jason Gunthorpe's message
	of "Mon, 26 Jan 2026 14:31:15 -0400")
References: <20260123095854.535058-1-pratyush@kernel.org>
	<20260123095854.535058-3-pratyush@kernel.org>
	<aXYGkb-QtYNaWYw4@kernel.org> <20260126183115.GU1134360@nvidia.com>
Date: Tue, 10 Feb 2026 14:10:45 +0100
Message-ID: <2vxzseb8u4kq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 16EE94000D
X-Rspamd-Server: rspam07
X-Stat-Signature: c6ey7orpk8usdf1x1qdbhzcrqzw4c8qb
X-HE-Tag: 1770729049-471545
X-HE-Meta: U2FsdGVkX18JFtXuybUSzreL7Qm7JVteXlgGKgd2+CSH1lUy7+qAIXaLdK3B5Aw8vzCty3xmIOJLzMg/5br8ldK6nrPlEj6T+sYoPLvbV6qlnAKHORMFFdH7W3+EbgqE5SRCzUbPs9aElUrbVG4TCJ7/uL2B5V+Z5Y1rW8ZrdvNZHC/Xvh1RQRDTCxbkIhN3HWyFnZHA+qXyO/vZYO87Cm7Os4+Uu/85OrYim25/SzITDbY5CnL/F/PoQsbEROQT2FxtIyrtMchNOZp5HgK4pdsynQ+TKR8QOhTgxevXW2SkeCgRzTovuNjFAr/9VTYCPGM94Ej2zTsxnRtrva/0XvEHa4Yw4FThqPd/89vZ5bXGNRci99Bt9jCz/2a4Mt4KougC3N+Jk0rbL98AysN+OkIi8fJr0N/ex4h4+vS7ZOcYF7CrcLwe00xnh0MUWIKDnAZ1V0qYnrGF18sc8EmV2eciuFIumyG6FeFiATLtkJC0nx+Cbty+cmDKWbtvFLtxMsy6GqDUAcKjFPRkEgfeivMk0KEam3KcZMRyALCXylpcFzCtNf1+bhMzGadeRyAwLNoZa2aZYO4fPhN/taKpMDzgZsy9aILcIZfS0Yy+xIYFsZlnVHu1c+EAkw6yvOz94xpu/19f+ua5QRx0yeAfdBxpne5c8OPD6VH8Ed2d9GxXNoZLyih5CCCEPJJIHNlSM1N+ScyAwmZ5NYMWzAEWiiC8HLlEGLaoSx7wq3DL2fR5q1YgpaYfdxLN+060XuIkN+N8DQ3F7377Wf1vjmFR0qgcw0ncpsV4lpSKXDiVUbFBq/5tngja7VNOIYWmLnIENEeX+oMEyAXggrl2t83ypTgDh4/idK0IN9uBwhVquNPY82Tukci721GFosFrdGChqcLDIcBGPy/QYm0jMDvEi4ldpcJgTwJgZ5Uy0wESWwxzLu1I6yCzP5wfLkSCvAtswFjp952a7PcCZo2AVrs
 ov7OLjkS
 TF/qDV+TXlWqrLHdEtIqet6rAqxD2yit8IXYyzuuLzC/O6ti3xJ3ZmmZfDplWCCDeT+ekmnfbwa3U5Jh1wctUDrgVTWCCCL97ECZQFAN9Ae+Qs11arrCBxW/zvKcwDK7bWBh9KN68FnfLHQl/D2KgGWlWZjTlJS01n/NedeVwjngb+GuJ9VevWL3z8jEa7bDEfqYx0Pjec9NGHOAlsr/DizU8lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Mon, Jan 26 2026, Jason Gunthorpe wrote:

> On Sun, Jan 25, 2026 at 02:03:29PM +0200, Mike Rapoport wrote:
>> > @@ -67,11 +72,13 @@ struct memfd_luo_folio_ser {
>> >  struct memfd_luo_ser {
>> >  	u64 pos;
>> >  	u64 size;
>> > +	u64 seals:8;
>> 
>> Kernel uABI defines seals as unsigned int, I think we can spare u32 for
>> them and reserve a u32 flags for other memfd flags (MFD_CLOEXEC,
>> MFD_HUGETLB etc).
>
> It is a bit worse than that, the "v2" version is only going to support
> some set of seals (probably the set defined in v6.19) and if there are
> new seals down the road then this needs a version bump.

If we are running say kernel X, then X + 1 will always support a
superset of the seals, since the seals are UAPI. So it should be able to
handle all the seals that are given to it by X. This only becomes a
problem on rollbacks. Is this what you are worried about or am I missing
something?

>
> So I'd check that only supported seals are set here:
>
>> > +     seals = memfd_get_seals(args->file);
>> > +     if (seals < 0) {
>> > +             err = seals;
>> > +             goto err_free_ser;
>> > +     }
>> > +
>> >       ser->pos = args->file->f_pos;
>> >       ser->size = i_size_read(inode);
>> > +     ser->seals = seals;
>
> ..
>
>> > @@ -444,13 +453,23 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>> >  	if (!ser)
>> >  		return -EINVAL;
>> >  
>> > -	file = memfd_alloc_file("", 0);
>> > +	/*
>> > +	 * The seals are preserved. Allow sealing here so they can be added
>> > +	 * later.
>> > +	 */
>> > +	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
>> >  	if (IS_ERR(file)) {
>> >  		pr_err("failed to setup file: %pe\n", file);
>> >  		err = PTR_ERR(file);
>> >  		goto free_ser;
>> >  	}
>> >  
>> > +	err = memfd_add_seals(file, ser->seals);
>
> Because we really don't want this to fail :\
>
> Jason

-- 
Regards,
Pratyush Yadav

