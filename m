Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8AC606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 05:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f4UzML0E
Received: by kanga.kvack.org (Postfix)
	id 806616B05B5; Thu, 29 Oct 2026 01:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DED86B05B6; Thu, 29 Oct 2026 01:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5976B05B7; Thu, 29 Oct 2026 01:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB2B6B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:53:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1D8D40301
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:53:25 +0000 (UTC)
X-FDA: 85374596370.30.7C7D579
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3BA7280003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:53:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f4UzML0E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793253204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uj4lN0l73poxUX+FmN14sN+KhrHh46mzInZ+w/lSNOA=;
	b=VXEATpIA77iFAcaWVdXIW3ixOp0fKbyaKP92EhatgxfQ8qN5SrXUi2dfcoiyRJEfD5nnq3
	Z2s+UmAHLIVQuMTr7SDsGJBrCnhkEdeLHwNWjOWFVu7abDushLi6AZcIjEkRIXZyx3YYwa
	2jlfD1ha8W1xhhtT9UzyOnwCd26OZ90=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f4UzML0E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793253204;
	b=Z1Hi40kGtr43jcNnKnQfpe/TjyD9zam2P6zVMXEfcQmk2u4F6fs42vgflw4hNPVXMURQ2o
	T+CQvBGdFdaKJOxGhOdv7Z6hx1O/M+ARKoNuS7OI5Q/sLv0Bgh0uTA7/HVg++GP1zB2PAz
	QSo2fE+yqQNj+2eg8qddAhQthVR1P9I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53EC8601E4;
	Thu, 29 Oct 2026 05:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE01B1F01829;
	Thu, 29 Oct 2026 05:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793253202;
	bh=uj4lN0l73poxUX+FmN14sN+KhrHh46mzInZ+w/lSNOA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=f4UzML0ErVF+LAoa1vMt9mZJRViUBFoCp4qAhid0FJ375+eCUkscN3nrQ+SxHaHIc
	 WuoEBI1IRIIMzX5ZITRFCo+KBtNHOYAKcxiWsH2bHbiIUUSzfWMG4Agl65uvlKgCUE
	 4GkmPhPZ3f1jP1zxDZKdwb0zCtl8JXPgilBKrUWyIBu+ShSYeJ2VMD1zYSKTZGZXBB
	 pxp58kmWohBUeeSTsbk4tvKWW3S8UqZj/30T4z8+6DjJsgRm8l2O4LbUYA00UHN7yZ
	 8gmiRO3pPcVPpm9q+uwqGjTkcbyU3tstmRuUbpdDyudJr9ey2cv7XmwTAY/POea5pe
	 +0f9fSCBfw89g==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Graf <graf@amazon.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Kardashevskiy <aik@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Connor Williamson <connordw@amazon.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Erdem Aktas <erdemaktas@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Fred Griffoul <fgriffo@amazon.co.uk>,
	Fred Griffoul <griffoul@gmail.com>,
	Gregory Price <gourry@gourry.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Hugh Dickins <hughd@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	James Houghton <jthoughton@google.com>,
	Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jianxiong Gao <jxgao@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	Joey Gouly <joey.gouly@arm.com>,
	John Starks <John.Starks@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Stitt <justinstitt@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Tycho Andersen <tycho@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH RFC v2 00/50] guest_memfd alternative providers
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
Date: Thu, 29 Oct 2026 11:22:59 +0530
Message-ID: <yq5ah5i5aw90.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3BA7280003
X-Stat-Signature: mf3fbcc5icc9gnp76pfohc7fdbzze5bm
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793253204-919360
X-HE-Meta: U2FsdGVkX1+X4j2FvHfGhQrklIyhTMhswApsiLRQe6MSDdc23Q9qPMuK93WWB6QPQ8DuGP7ZJEV08lE+w1f2J8xhX0fOKZ5OSWHcuKeF1iV3PlT2GERv/eX3o7iLPsWo+1gLoc7eFf/rhP9mYy0Y5DzRzPD9sOVl3iO6sVPcKIzyXengXS4PAFUFH5bZTb/Y0v4T+su0Xdiadsd4o5jxMdUcZs1H1KJQYZymIgjWGJGJBDfxqzFxnWOEr2wvvB4/IuxJHFYKIA84lYSuogrX0gl2SgaQINe8sLIvs647qQJ/2oGkkWkevf+6pnUNwlqnQrEhYmgWnQ7QCCdZJwHkL4tcpuDoi54btwB+geMf3EDxZ7vpB1+c0xBAEK+lHQIAjeRC+A6g46Vu/QCtxUDyOgTVjmcOtz9U9Q/X++GyQPsWdlaFaduzo/HPNfLMUeDtLgEls4Dd9kIZaup9wBXuWa43q6lCWUp+T1vhG8Ah9UfqtpThRbLCtFethTq7QrbULqeeh5GWe3pgLeHoaIVP7yWfz5s9UknZtQA1jt9AuiIswu3Knf9udGgMxAhWpaUbZr+7SnyVrEjrgdFYFyyU/bg3w/e7bk30mXb/y9i79chUtAXmX8ORqJRA0A+SEYuWdzga8Qu5rI39NfcSaj2V1P5f3FgLbgCSrBW1OGb8gV6KqS3FbaUSlcC2KZQc6xWLFANYK/0nR5o7FHJ1foF5fDHeJTL3kxsODXiWFmJw1iXxGoqsDCMJRGiBTcVYK8LztX43YbOil65rrpW6MYNHKvdIfOqK6xEl4vNuzCYpZGgfKOottBjXsp5MEv1ZSLGL8j/btHgs6GKTTQAQAshdX8URHEsaX1bP+Ft5wa9c1FHqGsYysxru388diONCEjMIelvUOtNWq5zPzC9tkiJ2ybg157ZgHoY4ciQnayYrb/wD7RAOgom5E4QQyENQWbZVTpU5DLbENu2C6+ufFNu
 HFeHdSCh
 6b0zx38XwKss3yx6+Vh2/Kqzac+6baPhY//cwZ8g9yUVeuRsONX7EdokHAnzAveg8rS5l5hI2JNX/Jrvb2KM5TXSrIxy6wqGTz/z45qf1A+LQVseN9oTpKv6aYEDJpgG7+Sm1Mlg8hGofnAJxrkzqHTWY+wxMRomRIekAg3ekfH6mnMuB0osDr6wtzxrgzf4njWRU/nwrnwl5bLuwlLmZsNLqnCVGJujz7tEnHGCXiSj0rUKLZizrZ/msS2nwqwLdNaGNXtpGJx2zXXeOJdlZLO7iRxKV7yOhqvBCy1OTRcUcdLatG+Foi4cPZF63S0kzcx1Xy/X/o2a+RvK90F2ckb0/iQJi/YWCovJW581Yx7QVjKgiSMD//9HRPC9noSYGjzTYw5Reb+vZPIscuSk/KJH9G4Z9j+e3iaBOfkNuRcgreCBS6DBDJlV6c+Gk0ufDwpjQ7b/UY8GlwXUfP6rXgr56tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> Here's RFC v2 of guest_memfd alternative providers, continuing from "Allow
> guest_memfd to be created using a resource (pool) fd", which I'm considering
> RFC v1.
>

 [ ... 138 lines skipped ... ] 

>
> Aneesh, thanks for your series [4], I haven't got a chance to look at it yet. I
> will before I continue this prototype for IOMMU. I want to get feedback on this
> part first.
>

I am looking at rebasing my series on top of this one.

One detail we need to finalize is memory access through resource_fd. For
a VFIO fd, I believe we want to continue allowing access through that
fd. This means allowing read/write/mmap/ioctl, with the VFIO subsystem
accessors checking whether the memory is host-accessible before
accessing private PFNs [1]. My series denies mmap through the guest_memfd
fd.

https://lore.kernel.org/all/yq5a1p9qxmqg.fsf@kernel.org


-aneesh

