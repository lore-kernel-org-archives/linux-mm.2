Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 354A3D6CFA9
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 21:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4586B035D; Thu, 22 Jan 2026 16:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF066B035E; Thu, 22 Jan 2026 16:41:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78FFD6B035F; Thu, 22 Jan 2026 16:41:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 652AE6B035D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:41:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D692BFEDC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:41:19 +0000 (UTC)
X-FDA: 84360921078.27.75BDC16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7105914000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:41:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nbhvWI6F;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769118077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpYFVQ+VNJG8H/bYcBfO1oxUpkQ5dAYJneF97kYBjLE=;
	b=ViyorfdC5/cDg+5xZR7CnKn06gAD/eMjQF7HZ9DJ6vFTB7YdtPh7GwxhHLuLXTeen9KXa/
	H7zgVD1tYqcex0MeBh6BnWpQ0fuCLj+7qsSlWtx/OZXOidXSACWz6HUWpyABwiN7HmsSSJ
	mcPf98g1PEEKyWrYRBTQqwyw5tHwmQs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769118077; a=rsa-sha256;
	cv=none;
	b=CPh8hfqZ0ihdJeJeLe7yoGeeKgAMJ4z63oywKjUjcCFV6Bn0HoX0ECdwUVmm6UbPjwB3gq
	DFofUi04IaL6mJwz8ifpZVdNxqhKIEHjONBW2YHglaD/qpzU2QcNWr860cDXQeldfGvk7J
	+U1q4QNO2QENyZ/3OKosAxRvnfsBmwE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nbhvWI6F;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD66160018;
	Thu, 22 Jan 2026 21:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482E1C116C6;
	Thu, 22 Jan 2026 21:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769118076;
	bh=o3gdWNkDSd9Vm/DMgr4/ykIAOvt43+NsJA/Imw15e/A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nbhvWI6FsmrV2v6DkoSqN8213V2yIRhOd6eP75LypoUaN54UBoDiDxVp1akq7FG3f
	 CVLIelPV0CkF4x7Juc3HDczRCXMl0AOZY4EUYaiK0pNhQfi7cbwzUhOkV6AnNppJ9U
	 SqiE6hXL+nm2nlnc5o4hmp73evXdLpeOeMX2qi64=
Date: Thu, 22 Jan 2026 13:41:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Matthew Brost
 <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>, Jason Gunthorpe
 <jgg@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Alistair Popple
 <apopple@nvidia.com>, Francois Dugast <francois.dugast@intel.com>,
 intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, adhavan
 Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Felix Kuehling <Felix.Kuehling@amd.com>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
 <dakr@kernel.org>, David Hildenbrand <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-Id: <20260122134114.a04ddf4c34a4b926d057032f@linux-foundation.org>
In-Reply-To: <626c34fc-34df-4629-baf3-fbebc9abafbb@nvidia.com>
References: <eb94d115-18a6-455b-b020-f18f372e283a@nvidia.com>
	<aWsdv6dX2RgqajFQ@lstrano-desk.jf.intel.com>
	<4k72r4n5poss2glrof5fsapczkpcrnpokposeikw5wjvtodbto@wpqsxoxzpvy6>
	<20260119142019.GG1134360@nvidia.com>
	<96926697-070C-45DE-AD26-559652625859@nvidia.com>
	<20260119203551.GQ1134360@nvidia.com>
	<ef6ef1e2-25f1-4f1b-a8d4-98c0d7b4ad0c@nvidia.com>
	<EE2956E3-CCEA-4EF9-A1A4-A483245091FC@nvidia.com>
	<20260120135340.GA1134360@nvidia.com>
	<F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com>
	<aXHPkQfwhMHU/oP6@lstrano-desk.jf.intel.com>
	<9077ab5b-f2c8-4c8d-8441-631e7c2cf384@suse.cz>
	<626c34fc-34df-4629-baf3-fbebc9abafbb@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7105914000A
X-Stat-Signature: tryxnq8yrgq4znerfczk6co8tsheozfn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769118077-696009
X-HE-Meta: U2FsdGVkX1+4oXU9uBGcALrw0ITG8o8XNe0IsZu3pgJYRViD3KB7FocSFDFZkGVn2MrSeH9GaNvMi0ZDAGSGdECKW1fMXptaPv9HZgcCDQ68BsA2hRImPCQXuKmsWjG51Jdg2h76PJ7YfEoyS4c0G0p1LskA2AN/V/ErEpWzqCx+0qHuBuZA1DjQ2EZuuPFFhyBtctu33tc8HF6ur/hIw2ZmFqpJquauJTlmhOtY7wHNTkJ6DlDc6WEit5a2lpn3euSW6uyOeXublDu19pg9eAJYcLye89oQDb4oq+xLLMfPNlBaRYIOg/1IYd0CKX0P8wBqW8u3PeEraTdjsMuIdGQTMG3SajcZECXqpp65duSSOgETfEUHYfbBf7ByRMmJ7Hm51eYnWS50/i0Tbc5cQT+ybULYx6JXiaq1ngbj7to4kF0YsEksqnMDX0dPw6ioFAx3p31dB2+iqnT/+ir9l84/0HJpxqn83wVbvQPXQxNp3OSv7eS+l1h1TvFVAk2aeDsUz3GN4Vvg2g0660PQSwhhzE3g+wAagf4J2m0WybKIaoqjhm5ReYpN0fUEyabv3/Av++LXAQX3DeeMNH/hHLmomFs17oaY5Vj71WcCERI+p9eRB0Bj50sG/grSSrHSjjINKsgscVdmHOcdhQa/qNhm/pUeL4ZhcMutOZXtwAj/3f8Apep8iONHyEdL1HTGV9vyuCaYXtdOq70IlWTWsemsveA2rb5Zze+lKn++NHEVMp1Y9vinTRCiTN2UoWpKzgy+GSf8UqwJbQIVQ1CTFHz472lM5jnybUXIJ0voOFtRt7BH3oqJy2feBYM/3Lk9yTugTBGkj6x7Vj58neDB+QqqBW1EUFRN1YR0YeN3NrpT3pgmMpqy2b0sAY2K07rlj+qJp4cyjQRg12+gtqAz0hkZUj8c8RxvV35rUlcTIwn9KQR7sK7JJXXkyRbl6Ipid+IDgmvbt5n3ZhizULj
 uNzxbj2y
 r9NTAnSU2zL7tlwiPiFfe4CCv3usYXe+kzEfeWkBchoOHqOfsEA3LVIrY5MIrdatQyvFKyxibnOTQOYJ02FNDA+qz12cztMS+fm81LYy4xCtjwTPLsr1cEhKWg//T7YBff4svCEJ+WQq8TnYEoGmORspSnTbVf4ZpsqAALbk4whUl392DwJcg1i+BC5pSrFG92Pg/5iQAy00uHXafyCSxJurEJTYyt5Hb/gJitTb98xJMzgdJw37DLZR/nMgQX8Eee76dKQGbwTNbdGbXF9MRXmByz0gANrjut2N75MGTTcJufGiLaTM2VFFpCKTa/y11XjlPRaZqwUtAoj2iT7uMC2uzPPPdyQkh6xtn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 20:10:44 +1100 Balbir Singh <balbirs@nvidia.com> wrote:

> >> - Intel has demonstrated that this works and is still getting blocked.
> >>
> >> - This entire thread is about a fixes patch for large device pages.
> >>   Changing prep_compound_page is completely out of scope for a fixes
> >>   patch, and honestly so is most of the rest of what’s being proposed.
> > 
> > FWIW I'm ok if this lands as a fix patch, and perceived the discussion to be
> > about how refactor things more properly afterwards, going forward.
> > 
> 
> I've said the same thing and I concur, we can use the patch as-is and
> change this to set the relevant identified fields after 6.19

So the plan is to add this patch to 6.19-rc and take another look at
patches [2-5] during next -rc cycle?

I think the plan is to take Matthew's work via the DRM tree?  But if people
want me to patchbunny this fix then please lmk.

I presently have

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>

If people wish to add to this then please do so.

I'll restore this patch into mm.git's hotfix branch (and hence
linux-next) because testing.

