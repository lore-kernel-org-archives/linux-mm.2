Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A1B9106F30C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CEE16B0089; Thu, 26 Mar 2026 05:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47EE86B008C; Thu, 26 Mar 2026 05:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3959E6B0092; Thu, 26 Mar 2026 05:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3476B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:04:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCBC4BA648
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:04:30 +0000 (UTC)
X-FDA: 84587628300.02.7ACEC52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1E67CA0007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:04:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l6tDDIjp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774515869; a=rsa-sha256;
	cv=none;
	b=thQXnHiNDgGCmctleuH8UQJyIQ25/wK6JO2t97PuM+1/kvWVCkH4d7y0TETg5s5IwOo3ZW
	qiouJQvsexEUgJcXk4q+OeFMjI4XdWRk8/q465aCPhyisnx4Uc+Kere04QM5nOOI3kh62k
	Njr4ezlu/x3BlWK1zAOV8HGmJIfH1Nc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l6tDDIjp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774515869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+a0MdJ5kc+iVHRJq8D6JhDoKFf7QcTNCH2TvmijekY=;
	b=EcFh1RO6Cf301cYbF5zsRr/1kEty71seWPtl1ST7kqdjZVxuaOSoTjLHjasIJH7+KPjgRb
	dbhLGyV+zyrLLkDJN3tD737LvAiFWVX5+wUyMPPHBWEJmp//dlP0/XtXbWCE3R1dsNbSHJ
	V2kACjmgdEagJXmXptvGksrz/mmRvh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED3B343CF1;
	Thu, 26 Mar 2026 09:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC30C116C6;
	Thu, 26 Mar 2026 09:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774515867;
	bh=iYLe7tMvWLZ8XmOqZgsqZUuDbTn6c4gDSEIS+FTWtfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l6tDDIjppwo5iydJp05VoVjwZRJCeS0u5deC7cL3xssqdQ1abiZJ1cLIZfAwJvBCB
	 E/8UsrVorkMtvAUmUDcbNaMFdwlhEwaa45Mv+qqh3VPSX2NmLKynBBXqeiOhaVdrZv
	 BNlYhzHnP+GbVcVnoFcrJfQxqpM/RrBqpBe3GFx6qhenQmEnKUvcKcNlw0F9ml3vhv
	 SBfi54HyjPFuH/HudwRZolrq0Z7VA/bXYdejOsCLtCG86As0ZknckLDGan5umB/OUm
	 XMC06bGIvyNIvku+ex3Ii8wJqpZ3B7/QtBVLk0rCY4mhFWI7wdtjf2rdmQldpjjiLN
	 VQw1jbLNwTRSQ==
Date: Thu, 26 Mar 2026 11:04:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, skhawaja@google.com
Subject: Re: [PATCH v3 1/2] liveupdate: prevent double management of files
Message-ID: <acT2lYJKdyXXzNPZ@kernel.org>
References: <20260325182026.467307-1-pasha.tatashin@soleen.com>
 <20260325182026.467307-2-pasha.tatashin@soleen.com>
 <2vxzikajacgc.fsf@kernel.org>
 <CALzav=eybgJwMQEtvSi2bUv8u7cic6d45r4wFZdZiKFFrrLJfQ@mail.gmail.com>
 <CA+CK2bBpa8ZnxPdsPCRCAiPeHUbqQ3TNjHTGU2eN_BGqqX2Y1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bBpa8ZnxPdsPCRCAiPeHUbqQ3TNjHTGU2eN_BGqqX2Y1Q@mail.gmail.com>
X-Stat-Signature: fkhbeu4xn67nfheogfdcztbqbixqsfgb
X-Rspamd-Queue-Id: 1E67CA0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774515868-835636
X-HE-Meta: U2FsdGVkX19wvYPqbgkovR+k23+Ms/g8e9GQ6oikR1TSiPtHXH7SzOscr8Sbe15Rzm+KAIobXt6/56b1HCXZr1SqTLcmFuhBj98g5KyQQ8pu3LDIogI6XF34wj9sob/dwEBh4tqfow8hYMovUBNiOKtKPdMXGYIVuCNaqsCYFLkeIrvFyjilRSwsp7/9UFZBOK5tW3uHjWP3q+c4LVftaN4feKTqMRTpc2Rkl+MrbkX+uF5rDhP+sFUYik7LMmIxKEwvjzXWd2cGgtt+iQBcjNDTkrLj1cp7Yj7w19zpjK6NcPpATNxFW7JsUJ4JR0jXtQn1x9hN4qMJbTpNzSWbz+OowVujBL6PYrPOthdW+TVQgzGKg2htMvEhOtAfq+4MZYQZkzj4ldsToF3o3kNS5L9nosjdQXsVIsr1CGJAA9VhtCNuPQfjeabNTuspUL3TNbtQPBQpew/wWQeWnuJEzQUalS4/EOqvQ/SUpLWduvIsXtaoUC93qRVFz+xEQixdL4i2oqubiJgAJMmqrNKYxZo0J3juIJ/QFJjul2PC/xZZew/hY29mCzjPUdoJfW6aKW3EQC4qfwPM6IZQmo/igIoJDoCC6fv+7A/9Yuc5hq5ORNb92xXcpyMqR2SpWYwAp/zIeRwzOQRyn57LRt4iEnP1CAbo/QODXbxJ/0yqDk8m6RIBV4Ph1gy0FXX5Bq73w86X0vX6vRl+k8KNTL2quOiDCF4e3PPlavcK42qZKzpKttkduoHUswNva87IYtjZ2GzmFpgTvZeUYlA1UuHWrRAL3kClppwDFvgn/jbUemuJI7dqF27Pytufl7UcfUxb5p2+q8bQc4cmqDe/e5veFx8Y9Jwf1PnR3uFOOlgwAXfPE0/XL25yM5I/46KzrmPkv5D4bwm+hCvZ3XUxwNu8L5dR9cdKw6cyvn1zDe8I0jgoBC7NDsW63W8t3P1rTdIIt8iwJXEwS+QaO5AN6cA
 frRNe8sV
 oiPVqFiisBgS/fluY/tKnKFGhT/ph1t33zhhQNsLat59s2Z7KON1qfkERVNvsi4P5LntMqXKwKa8SK1keau1K3oGEt97BGNzuEKI/MT21QSjzyki8vZy3cvBh+6xyRlpJbw781FyL/hpviYj0hddsaxfzoLkLqZz5MGcR/yyeX7D/BF/4PTdyyubzadLBO5O3JV0C+1CI+cyBdfLeyM59J22h7j30aEaCyKE5jz6SYN98gXDaDel1StSB73ha3hSE8XmHYObeRS9IKbZbbMVFTP6Re8ex4mW0XGcqpPPWIcGeYNG/hvZSbVGrD9UxVYpeJQrcRPW5A2WC+i0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:08:57PM -0400, Pasha Tatashin wrote:
> On Wed, Mar 25, 2026 at 4:34 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Wed, Mar 25, 2026 at 1:20 PM Pratyush Yadav <pratyush@kernel.org> wrote:
> >
> > > For memfd and hugetlb at least, we serialize the _inode_ not the file.
> > > The inode has the contents that we care to preserve.
> > >
> > > So if two FDs point to the same inode, this will break. You can do this
> > > by first creating a memfd and then by opening "/proc/self/fd/<fd>". Then
> > > you would be able to trigger the preservation twice, causing all sorts
> > > of problems. Same on the retrieve side.
> 
> Hm.
> 
> >
> > > So unless I am missing something, I don't think this approach will work.
> > > As much as I hate to suggest it, I think we need to move this check to
> > > each caller so they can find out the object they need to serialize and
> > > check if it already is.
> >
> > I think LUO can still enforce that the file is not preserved twice.
> > HugeTLB and memfd's preserve() functions just need to also check that
> > the associated inode has not already been preserved?
> 
> For memfd/hugetlbs the true state is in inode
> For vfio/kvm the shared anonymous inode is just a dummy wrapper, and
> the true state is in file->private_data.
> 
> I wonder if we could use the XArray to track inodes for standard
> files, but track the struct file itself for anonymous files (we would
> need a new function from FS that allows us to determine if "struct
> file" has anonymous inode or not).

Don't all files we preserve use anon inodes?

How about we extend the fh->ops with a method that will return "unique"
object? 

	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
		if (fh->ops->can_preserve(fh, file)) {
			unique_handle = fh->ops->unique_handle(fh, file);
			err = 0;
			break;
		}
	}

	xa_insert(&luo_preserved_objects, unique_handle,
		  (unsigned long)unique_handle, GFP_KERNEL);
 
> Pasha

-- 
Sincerely yours,
Mike.

