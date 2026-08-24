Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F41FC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865316B0096; Mon, 24 Aug 2026 03:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814426B0099; Mon, 24 Aug 2026 03:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7531A6B009B; Mon, 24 Aug 2026 03:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1006B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:59:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0E0F120452
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:30 +0000 (UTC)
X-FDA: 85135413300.01.B2FCB61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2275B180008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iSpgq0T9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787558369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXUmGFOCOiethoBewYZqUVfBZTm7jKCobaLxI20OCYc=;
	b=ZrlgwxbKK6pR6Jkiq1HXUd9r+Oet+PCBfdDve5s1zIMUNUrjHZXHocS1z7WfQW5FcQE351
	spzCyuacrKxu/V6WhWjob9nJD6C9jIr99CcGFaNYN0r530vvjXnnlspMINx/50sfpyBirc
	5Rug0D7ria40T9gM346l1G0/O6Zatqg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iSpgq0T9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787558369;
	b=5Hq5aRmBu1QsIeXWPlYADv/woLil6EKj6hjRY5xs83Q2k0jbn/V7FNPtW8O+35OqzgvNa+
	w6gUgzyI8+M5tHZ3RSAlRWmI5CeLMXvYO7yCycdv2y9xv0n8TY9nwHmlCKQDqBATmHfscF
	vsyzHKf73XLbJpjhiwfns3Yn2ZoinKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A37943CE8;
	Mon, 24 Aug 2026 07:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0D61F000E9;
	Mon, 24 Aug 2026 07:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787558368;
	bh=BXUmGFOCOiethoBewYZqUVfBZTm7jKCobaLxI20OCYc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=iSpgq0T9NjPPpMbN4wVLt8+PTdvKsvoJ2zylkvKvJWSGJ1DYaCY548bzZbcG9udx4
	 2Rkrr9KPPtgQ/c9SpqUDSc42Yrk5z1xUCU+x/wMd+2SHHghXj7M4LfpuZ+6U5c8UuK
	 oLPX86J1834eJ1AHu1sbLYXve8LJUQaFWlAKTKPvm9L3aw1wj0ADUxbc/sMkbMe0Cb
	 0iFM8PQUTZolv7g+qBMQYZPl7Gwuk5eGbCAj+J6TFalMoxGhhvY/wZWJT06QRb0M0x
	 F5en1Deh1osBQ+BgUSUqkV2E3cFCY3YmbjuYAMaUnH6hObqsPbOpGD/nOpUH5AA78t
	 Pdb17IBJPDa5Q==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 3/6] tools/lib/mm: move hugepage_settings out of
 selftests
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260813181230.483746-4-sarthak.sharma@arm.com>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-4-sarthak.sharma@arm.com>
Date: Mon, 24 Aug 2026 10:59:05 +0300
Message-Id: <178755834510.3606540.10873606384542050383.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: h1ny6ztse3dwnud6uhgrxdxzj9kcgwr6
X-Rspamd-Queue-Id: 2275B180008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787558369-332841
X-HE-Meta: U2FsdGVkX18LBApZwHLfx+Uwy7iK9podxPfZxektaVu108HCUpwlIQU01xkzoBQeVQzAEGhkYQzu/PkfYkMB68ttRveMfPF0E90fMgIpAeQVVQbIaBWmr3/lDLhwTWcfwwB38cmDQlAs2oDlcJN7gRmLEZZVgSQj1bXOdwqy8cA0y0GWBnZhNDalCRxYOa0gKBSDsp8BreDoozBUUs78FXIGZCSwE5TnqnaoIXH6T+qSf6HfaobV1yMAwrVUH5wK4PUTOLwsYMj8Bk8rthcfjeP0fTaZp64qv1IVz8j8rZIIsYP/0/d0TEVqo4z9cxiUpOHfD3wseLHss4BQ6vDd7jfLqheE8DHBCYyIM3nPo5pLz2vBcjV3C9KgHD91xWUuyD193VjWRhL5gNk+pjJKYHxNeA/xvhbKeRn8zw7/xa9insCgxoUyzc76R2G8+3NGILnTHxzHQtmcM06qGmASULXyuy1zZPZpeOeX0O2aZ0Nhy5MgRpUa96zawVY4Lig0+0IuArmAYEzzjbi34rr9vUfdrxSKEctGvFFEPaCzg8hXgq/jlBt5hisYqMq1tYFeyWk0jwjeP8egMKblrgkueq0ncXo4SUzs316YnkmdZgiZH3I9AECkN3N/uToN6FDi3BK5ebpyVpRslE54wrM0aCiTSxsSO7WuvN2/NGYQYGYWex1+kfErrDsDCl2SVk51uL9kunKhWs13DO60P4wPFOALyBg/U1fHDpjtAuubCPEEZAf/gy39OD5WShBD9Swp+WgR/dpqUuyOflPNu5tgyf1kE/lISXJS9lYB3A+d7F6/KbCIDtCc/+CkgMias5KPPU/IKAPSu2cUWhWzeos81qLR0LsiTP09giIqeYPGt8Ot2WkQEREMi26rt7C6PMTOknmu0+BzLGHYawt6cjSZAKS5dY5FV4zgauuNx3Z9dDSE9XsMHs4RRDkLd1ZAHb1kubGlErz+40orFVeOKxx
 ZqhycSv4
 dMAJnZjxn2I5GyUNOuwGGnnOzc7oJByx7rpKExM9ZUGn6Ay6L6OsfEjUUf0bEAcwRwqGC8tGHRjLXLCJ5Vu9QJsCsmvFGDV2G7O+bBlJ+XN/BJrUEHHayX2EDhtxO7dP6NoocxkG4Vygo/ASlrVXKjbuYXY5ReEAiJfOOkgkM/QNIH+cJPHTqHM2XVNc3ZVMOmOOnogQRay8cuPSH1FSqo9RvsmPWSdaoDebSPKuemyvyDXec6cOYQeWO4pJPKswW2s5UrGkdHIObpNvwtGtisNwiMtVv0ehZEE/nkB/ANGomKOC3Wk0hKpLtXJU7tmbns1nhFoR39ZCysSzQ4XE9gLlKNakx29jefZQ1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 23:42:27 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:
> Move hugepage_settings.[ch] from tools/testing/selftests/mm/ to
> tools/lib/mm/ so the THP and HugeTLB helpers can be shared more easily
> between selftests and other tools.
> 
> Keep the helpers exposed to mm selftests through vm_util.h where possible,
> and use direct <mm/hugepage_settings.h> includes for files that do not
> include vm_util.h. Adjust the selftests/mm build to compile the moved
> implementation from its new location.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


