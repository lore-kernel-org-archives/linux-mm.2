Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F7ACA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 19:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5573C8E0008; Wed,  3 Sep 2025 15:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507268E0001; Wed,  3 Sep 2025 15:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6458E0008; Wed,  3 Sep 2025 15:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5E78E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:39:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0EF111ABFF
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:39:52 +0000 (UTC)
X-FDA: 83848954224.06.8255F96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3565D10000F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:39:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gz6uxsup;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756928391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2XtVNWlD8/1LKsJh8aenB3yYUReSpL5uxIpoX8Osp8=;
	b=AjfO7rp9VA+ZmI3cNFfI1pUAWuoP7t1/w+l6+8KISjc2qMuP+7pW8P553ZcyLSEt+Jo7TB
	LPfmzGfLvB2JZFTSz8uEHlw8tUk3QnAuN6TvYTb78un67MDZFZ4B3dsDz/IP9Y5YjpClJQ
	zICq9aUCw6X9iGgYlnsg7WEv0y55Ydw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gz6uxsup;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756928391; a=rsa-sha256;
	cv=none;
	b=1GXCuGVFGk7GMbkZQRv96IZAeC6/fP7m++/eNNL2/AFA7Kw9qG1PDgyUZC43RfvItFAA/z
	VTkGwFLDiOdPqDFyUtHIjqxXb6qpNCipftquT6EFdIE/Ggmjn4mm9PKPkDoiHezBla5J+G
	Iae1dNXjOSesgFIIlrMAoPzz62NNrd4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13D4B601A9;
	Wed,  3 Sep 2025 19:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6955FC4CEE7;
	Wed,  3 Sep 2025 19:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756928389;
	bh=Pu+vu6g6LwE10wMxZrFW5TxKz0JITY2Crb4lMaPJ9SY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gz6uxsup5NvrDysGKeMXZ44qZPYIGuzbclLbViCOP9MmigNiunGxpJvcdJnlmXqRe
	 AvBU8YwMwhCvjlAHFoATnl84QP8uDsa4o5/G2NhtFJzt0BCNE56oil5QKBjz4Ql5N2
	 E4pDBHs9enBiGj/gq1J1rHF0uh+0ZcV/MMTT9d7aeTnt/+LPqShw6YKXuL29ocn3HW
	 4sg84FuqSg5Ty/PGCMeMCWkcmYiZ/KRSXV/BOVZAtgkck9rDjLsJvr4kGeQuvmgGwP
	 eDgZRyMDXPjrWqCYLL5Ybug/VIq8TSxZb2Pyz8B5bRFd7JLQ4veEthmtrikmpPB4mw
	 QmDw761qL8u6w==
Date: Wed, 3 Sep 2025 22:39:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <aLiZbb_F5R2x9-y2@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250826162019.GD2130239@nvidia.com>
 <aLXIcUwt0HVzRpYW@kernel.org>
 <mafs0ldmyw1hp.fsf@kernel.org>
 <aLbYk30V2EEJJtAf@kernel.org>
 <mafs0qzwnvcwk.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0qzwnvcwk.fsf@kernel.org>
X-Stat-Signature: oha8eqnzpqhufpttkqhpidi7cehmokum
X-Rspam-User: 
X-Rspamd-Queue-Id: 3565D10000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1756928391-706534
X-HE-Meta: U2FsdGVkX18L8P2gU6L6TZ0jX91tr0iPto8ag8HVAddw8yTs5RfxScf2txBeKwVZmHrmT0JIo/ftKSrGr1E9QXhq07BdPcRLvT6RLtXPlWxeeWhqTX2kcmwi9r73EB5u/TPNsXOwvyu2C7dOl0nRVfoJ21LCtk8SFI3MqypHk5ao2ds5KA2jrYl4uPXhPcBwm+V76KFHZP1RpFxEI+w3aSp9Uj2TOoTVP+r+xlSP/nnFw8tk6qGJYTDc7T2rG5bSHKRnrRf/2kChMvkV8Ve0wkm98whJUTEOLshchNnztAJTiIg0i3rXjc0sxItof5FgSh0RrIZXjTdr8ZS9xnfVXVA++s95fMzpKOEhuDvNbvAF+7xDApTMpwpB/0KS4C4tnlTt0Shylurrb91DyRgPo/eNWjxbq8fkLI9XAcTSRgnTRsMt76lPCYQSBmmXx4UBBUx1jqUOR9miGRRJwxBH3Cazn/k5sPl5ak0e39IhulYGkKcZD2CL6fG3uP70toWvp7vGh0RlCzl2rmBzEJL0sydUOfzdIWahZsT/h3T3TCXBybvpvEyAAf3SgSX3MDlyEnFxyI1Ly4C8rmJXXumNdweu5rh001cNEiskBbjmUr+z4ST15JJDK9WrTZuz1UJa+YkcLKg7YluN0xQhfAZrpegKMqyB90MgtdbERIauVHS4dQYskg8/VygX1b1q8nwYlc+dGJ/Nn0NakZdshKL5AGR8xPuHDj30uXpetchZlJANQy1o7l7SyVlfZw+ttU8vMm5vvpI5bCS++iW6yYx+hPoOkO7vlsmhw33GSrKKxF8oyKN7dXJbKAHS0HpStvWxHlDye7Kqrj3MIoh+801VHkYB5jAqrBPh26Z0IY2E5IfTDHCweemqlVam+EXXcblh8boLXR6YQ8D8JAH7AcszXWDOJXCHkiCJ/t7qMBzKsXtdneESP4T0rFOUcruCbM0QB7aEA1KxBQLN3pwgzwR
 hL5uzZN2
 Banv/hSpLDoLyXY+Q36PEKRiZZxssmHqTVkONkhqCBtYfkHwMyzK9iKe5qyUBV3Q+4x7zkAMj4JURHweLRis36mCjR8jebYSEDxWLTo3Ml9S6ku20S/Dezv/5kBTj0atkSrwThawwtTsK/SQ9jUi6HBz9J5Vynb1Eo4PDEn89OAeT503Mjtv7qDQiH6xpfMZUGeJ0NOdmYA17HJbyXLMJxuLRrZRTqq0e5Txjg1/asul0O2201FBfXl9ccfuH7bzk4sc947se6IK5U06kSmIMo//QozEz9Y/pyCk1hi/Nzft0nuTRrYdCi0Zov3ugE4z6K44A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratyush,

On Wed, Sep 03, 2025 at 04:17:15PM +0200, Pratyush Yadav wrote:
> On Tue, Sep 02 2025, Mike Rapoport wrote:
> >
> > As for porting kho_preserve_vmalloc() to kho_array, I also feel that it
> > would just make kho_preserve_vmalloc() more complex and I'd rather simplify
> > it even more, e.g. with preallocating all the pages that preserve indices
> > in advance.
> 
> I think there are two parts here. One is the data format of the KHO
> array and the other is the way to build it. I think the format is quite
> simple and versatile, and we can have many strategies of building it.
> 
> For example, if you are only concerned with pre-allocating data, I can
> very well add a way to initialize the KHO array with with a fixed size
> up front.

I wasn't concerned with preallocation vs allocating a page at a time, I
though with preallocation the vmalloc code will become even simpler, but
it's not :)
 
> Beyond that, I think KHO array will actually make kho_preserve_vmalloc()
> simpler since it won't have to deal with the linked list traversal
> logic. It can just do ka_for_each() and just get all the pages.
>
> We can also convert the preservation bitmaps to use it so the linked list
> logic is in one place, and others just build on top of it.

I disagree. The boilerplate to initialize and iterate the kho_array will
not make neither vmalloc nor bitmaps preservation simpler IMO.

And for bitmaps Pasha and Jason M. are anyway working on a different data
structure already, so if their proposal moves forward converting bitmap
preservation to anything would be a wasted effort.

> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

