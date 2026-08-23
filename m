Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C533C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 21:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71DD6B0095; Sun, 23 Aug 2026 17:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22556B009B; Sun, 23 Aug 2026 17:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39356B009D; Sun, 23 Aug 2026 17:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2F616B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 17:03:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09C6CC0372
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:03:44 +0000 (UTC)
X-FDA: 85133760768.05.99330DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3553B140004
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:03:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9QtHd0p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787519022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+VburK+odB1fDWkH6iEpBg9w1/FoznuDupdWAo3Jbw=;
	b=PhbbqaORSM+AqS7PJTdgW7JTVnMgiCXjFL/NBnthltB3DvamX6yOYAOr14nKJKnHGXlw36
	16YQrHwim5tIMFz8VTvEQln7jt8wbuZNeIWyEdOK64kfw6bac4a8iB8ma7DWV7JoTRFcYm
	Fa5Pr+Dv5GHGXqi6Wc5+VwbvmOMTWD4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9QtHd0p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787519022;
	b=iW0T+NOgQjqNQiv/GKkKRqyZbumnB1Rp8zBugNM2oqRklGbOmH/OWDeZ3Sh6UM/j9CQpe3
	o5CI8OIpEHAdz6NEacSa/DueB8etAkKUWMHQZ0uGms/DJ9g9luFPxvdEjpa2QnzNMgQvv1
	ugxUeajDso/bQ8BHsML4qCVuYn+sQOM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED83E4400A
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8628D1F0155A
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787519020;
	bh=l+VburK+odB1fDWkH6iEpBg9w1/FoznuDupdWAo3Jbw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=E9QtHd0p+fltr5arHLX5fTNkVwWPawEqcTKAs1KLMWUCRUwtChKXfZMA0iiAHUVpi
	 gn/qucP21Lkp6VpBerhy6YEL6n2HgRGceySEp4viZqaaqv6Rr7rAuJse2kipHanMd6
	 3wZaZG/sYdOds5tyxxx6lPEdXtFTLVYnpGe+yzKQOZCGJd/en06tmYGfiJgyHacn5d
	 MMV6DUxFyWLa7Pk8pwLldiWx8xz9DVxwMrX4rksVFU5l+6wNeDypBcdE06XOryjin+
	 YrpB87nr80p/g4/WkK3gJrhAqFy2X9AMHPFtFqdtLXTAzmQkLa/IYL1FcsmOjbWDhS
	 evqUJ6Jni6c6A==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92f0b5ed131so232657185a.3
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:03:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqWaCwdYiKUEhWzmXbAaRd8jedjhcWNiMuG/lqE5sIH38B6AUct4ZcvuNWzzP5rFCMZfi31E1i5iA==@kvack.org
X-Gm-Message-State: AFuF++mPozSH2LpR8pXpXhvPtxLXKCDp9dKRwUhrbKz6evxTx6u5Rhcb
	1aFb/j+P4OJpYZfeDTDIGWtbjs1MfF+FFkEc5U6U1L3TufOvFCBtS+zyZ3ylGArlK5xQPsbXO31
	VkVXijs+wXwvSl83/ux40Amsfgi5znWs=
X-Received: by 2002:a05:620a:2b9b:b0:926:e8e6:3c34 with SMTP id
 af79cd13be357-937468e5f9bmr1413488785a.21.1787519019891; Sun, 23 Aug 2026
 14:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org> <20260823-uffd-vm-flags-v1-v1-2-3086981b33cf@kernel.org>
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-2-3086981b33cf@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 24 Aug 2026 05:03:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wTYD+SQfrhd83MdH9CmFwtMCVK_13Kbx2VP+P2+v2i6Q@mail.gmail.com>
X-Gm-Features: AcwNN1VeEGSCIXP72wWznE6JoVbvI0HglB0VO6c9ZJfUFoVn2XxY-KxYYtB6Q3Y
Message-ID: <CAGsJ_4wTYD+SQfrhd83MdH9CmFwtMCVK_13Kbx2VP+P2+v2i6Q@mail.gmail.com>
Subject: Re: [PATCH 2/6] userfaultfd: constify VMA parameter of
 userfaultfd_*() helpers
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>, 
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3553B140004
X-Rspamd-Server: rspam07
X-Stat-Signature: r99z6iep5wrb3q4ohewr5xt4mty6ru3h
X-HE-Tag: 1787519022-456307
X-HE-Meta: U2FsdGVkX1/eTuyFAc8aYYF26it2y9it5FgXTANspxIK/cZGoeAfWVa6lTBp1U1AkYBWB9ysteVdlkPzT4Gyz/6MXfXswLicVkj7E6DBwA2xdcdWpTVkvzwaInGsyFLdCvK40vgKbpH8vlT6EflfuMtQ4UYK1y1GtV+GFxjSoYvE1xYIY9t7HHkv7TfMaf9OVqoGQITMmfz5MdOPFgndlrtw+3vuK2cQsFpAErUyILE4m0YLIXamNWJLCCynNrs5B7zaImv1eeQnsrINpVNcEypAeJMQKlwKtKZgAVxQBWOsDr9pzgqqsuozGvx7HuoazTo7/zQfMF4OZNaC8ghM8FdA6qo0jtKRAAq9JpGXVhA2w03Ds47AOEyOTXSrKAmMC+bSRQA2lbrJHOwf4QFN9T6sLBYlIgI2ck3RQ1X0h/U50JnnyQG17waFQV6/F6Depu4+ecWZ9s44LXPKkjexgdj/YlMMeBk+8SdfuXyMvBEJj61DpgaGw6Ur3iRpVP17ZuNO50tEJFXHfxswuz9ea3kvheS8Xe2UwYBFbMFeGMOrhv/+lR3tYzgIC2y6bsa5qUtxyHMrH4v1ZXBptg21HH8eX94L0dx5QIaig+D+S5meI7TUdNkogX2IuaLc4+ZjJzAAR8RIEtCucWzzuYsf/h1NYMYMrLvm/HHOpid+LqHesP0l+bE9XzxGwxDmjJWF/aC3Y0zHInZdYptW3XdfB3pz1PlRcE5jhG+0R4tuP2jccomxDJptsiYz2WrlAEvNCLeur2haNUXVk++ndlek3wBYafTVQgzdTUj/oMkPa03PgkEoOeVVpHvm/x/UKo1Sf5G6gd2q5c4wwdgqye2jF/HPeYDGabuEs/S40zRm1E81cqe9A2z4CCER/lTec8wH8+LUij9TpO+QoK/LfZh++BEJbO106piVbVfVhVsgSPTMxct38SXjo4tkwNze/z6ISbBZyG4knnE9OaRMvJg
 1IZpdM0O
 e6u+HVc2gDWEi15UWoXoN/zNCJ4BqSR5eTGm7UMBcGy0dXw5h5OShM41waIQAOLaSfMADja7Le/0mYe1ID8bF2xEEbXtW78lenDbHFS03wD+lcczHgSNwiJ362dTBCxgeMTozmt9QhF1h2SpcWZmSWNBzBSJ2Tu5Q2c15sV3Er1xOV6iTDARPJTglRTBK4zXu+NG0TSu2uHWKRaYjqHoR0MOosGE3JuWdT0W1D9nrDdJTHOPa/FT45ZwDsPAHD0krg/Kxd9wa/d32wnkbF0VHGWCwPNFCjtckEsxWRMqNQGPf2N0KbHCz/9mCxSsU2UTQUmwGkUOJT/VrfRnbmq1U2k+vIwkR+oMcUv/S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 8:18=E2=80=AFPM Mike Rapoport (Microsoft)
<rppt@kernel.org> wrote:
>
> userfaultfd_{missing,wp,minor,rwp}() and userfaultfd_protected() only
> read the VMA.
>
> Make their vma parameter const.
>
> No functional change.
>
> Assisted-by: copilot:claude-opus-5
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

LGTM, thanks!

Reviewed-by: Barry Song <baohua@kernel.org>

