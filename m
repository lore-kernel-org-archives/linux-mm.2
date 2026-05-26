Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91821CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6A406B0005; Mon, 25 May 2026 22:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BC76B008A; Mon, 25 May 2026 22:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B319C6B008C; Mon, 25 May 2026 22:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A28DD6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:02:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57EB21A0249
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:02:33 +0000 (UTC)
X-FDA: 84807921786.23.0E2C446
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf06.hostedemail.com (Postfix) with ESMTP id 82BBD18000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:02:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VleIy6jc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779760951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2l47BrYScQshlVVpnfejRoIHDV7lZjQV6i+sxvNhsb4=;
	b=waaE35RpQATtAUlDfyemcBDOmZgoadeMpmSGoHjE7UU2DH4b1rWrpN2YnnRnH8A+jh/kzx
	pYmOP/6xl154/7UhP6LMmJe1fa0WZqH73p/xiHs/YwYMGetctAQLSkkXUoa9EAA4QOQ5g0
	YU+tEPtvMJBREyUM0vVq7pnYR4kNOc4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VleIy6jc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779760951; a=rsa-sha256;
	cv=none;
	b=xfPDNn+tpTvpDuNcKYp5TcX5a7zbU6vhr+dOOt8c8iyrexou6pW/Tn+9RHBLg61CqBp7sR
	QGxT2roTo5KQcRQiahEILcBxGqFPYtBEYsHXaWypmsMXH+Em+wQe6uV91az+TXCy7wAYXJ
	+jO4f4booEntvfVloGHYBX0JVSxO0DY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779760947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2l47BrYScQshlVVpnfejRoIHDV7lZjQV6i+sxvNhsb4=;
	b=VleIy6jcOIoP//PzdyTCaRBCUqgKHI1OHcJmPwHohQck4caGTynRXes3PiXueQHwzOpcCM
	IDqKxzFK00oHWhpMek8it8Ea8azPClVinHQ8W7Xz2qzzBUcefDixHbTXBgAa6Vp+82QUby
	u9mG6VYrlxcjS2MCK9SWAEYYI2LUOjM=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb_vmemmap: fix incorrect vmemmap restore in
 rollback
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260525144948.15e51eb81151e498cc2af999@linux-foundation.org>
Date: Tue, 26 May 2026 10:01:30 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FB43864F-28ED-417F-98AD-D6726FBB067F@linux.dev>
References: <20260525025213.2229628-1-songmuchun@bytedance.com>
 <20260525144948.15e51eb81151e498cc2af999@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 82BBD18000A
X-Stat-Signature: d3dy6k4nnu1wu7ohdx8mbtpmwq6yrdys
X-Rspam-User: 
X-HE-Tag: 1779760951-126710
X-HE-Meta: U2FsdGVkX1+ctbIcGe8OV5oGLi2lSk3vfZy1YQ/2DZ72fZExJTYO+bDpbbk4E1g8ZPzxvcOmn1gUxi/fc1ol9kS4pUU+BrXvPIs3x5W6yfaH2r/LUS8FIxvjDnms22QUgVr/L9qVJqaV8olg6/z5rGmrV2lgotlxs4DhKc8XCEz9k0hQZjY9dHuQhguqnRK1U+8sMVa4x7M51qahtwof15h8UtsAZMauZZPVJKPf1omMisACN7ohaQmUBZv6jlBVRjVem8ZB5BtUTPwgclD5/PCT14VT9UThFXEtPhGWo4QfvUXXv7I7B641av5RD5KlVAa8WGLj0xyy1Giirqr6bhreFwxODujLG+V/eha5NoT9wtKNXLZNaleKHPS1wTMSqwFSK5UzZHg+rqPKt6Sv9l95YXJKX1HichmWKHeRoAjljVNDzMpyCFKHPGa8zXGbxEv8eKS+r84s3ia4brfG26GZaIErDZSepTTItTuAcx2kfN66T9DLvdOUScYzZKM2hwyz48hvxUuc2k0jh91/VYn0Ik53qbNSlt9JgeRKU5bdDYLlm73jE5N8RjZEorjlnyitAeWs9KeLw3X+pcDn53qBOFTktRlNTYbdad+mdG+w/yQPZa66yeGsfgdMLMdT1/X9O+rjDdjmYpHV80xA7ID4CSw3piFPoICzCF3ItREtbHBdNsB+7bD3bzD/JQi2IaOXf/mAjS4qp6McubDv+Lva6aQKEKwZPpPftWIVKK+9FnUvjvCDTa+4pZnJYDU2o1aYTkxQQnMUZrW/yvKw4I1kBCd9LEUtEPT0rQ6DDGwyWcDivTL4uXxxXvHkBz7AqL1h7KCdGAIZzlLlNiRpO2OlrrBN4rIoPTO7ci3F2ly0PTAZJdx146oGMpT+qF25IkvLx2EDZpc/YckYUBx3+9XrtLXZTi5ofqW8EnM6TtH9ojY8t/fKc7/rhYpORXBttrngzcoGuRZexDZIIt0
 tgqulqGo
 yh3xdgXiQRuKeQTaZemiGtW4AoSVlzBlpLI4mpY1NlEbRrahXChwOTRyXoyDWBx64vhhN9ZLrHfGQSN39WhcWR93mCU0kBfguQhaldZVwdXdgSDGO19kN5rRtGDHO1jwzGBu7NmUYW6xkXjnUxHCtuA1nLvNGy8QGqXatj7py55cZmsvN8DM0qN+Na6lDrcG5qqBtg/LxOk63Jq3Dqiu5TKE6bOE69FYWYiRMVdx+kHQx1Qy79yQ4Sn3Ieq2pUbvuzUR5NIvoRLMKDvBpiCVKTmOgbUbOhz06VLV5I6XGsfQPNUawaaAEESW7bLhgHlVTwrDFYcwxqnrLXo1JCViwsjWG1GEx+UCmhmGyJv6Fkdm4ffsPeg2t+aoAgbOHOYq1vy3KU1/buXyjmOMmVDtCBDfBAso+Ny0wRaHwnR4NgLuLp/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 26, 2026, at 05:49, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Mon, 25 May 2026 10:52:13 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
>> vmemmap_restore_pte() rebuilds restored vmemmap pages from a
>> tail-page template derived from compound_head(). This is wrong when =
the
>> current PTE already maps a page whose contents are not tail-page
>> metadata.
>>=20
>> In the rollback path of vmemmap_remap_free(), the first restored PTE =
is
>> backed by vmemmap_head and contains head-page metadata. =
Reconstructing
>> that page from a tail-page template overwrites the head-page state =
and
>> corrupts the restored vmemmap page.
>>=20
>> Fix this by copying the full page from the page currently mapped by =
the
>> PTE. Also pass vmemmap_tail to the rollback walk so only PTEs backed =
by
>> the shared tail page are restored, while the head PTE remains mapped =
to
>> vmemmap_head. Add VM_WARN_ON_ONCE() checks for unexpected cases.
>=20
> Queued in mm-hotfixes, thanks.
>=20
>> Fixes: c0b495b91a47 ("mm/hugetlb: refactor code around vmemmap_walk")
>=20
> A "refactoring" patch caused a regression?  Ouch.

Yes.

>=20
> This patch caused Sashiko to identify a possible pre-existing mem
> hotplug race:
> =
https://sashiko.dev/#/patchset/20260525025213.2229628-1-songmuchun@bytedan=
ce.com

I think it is a false positive since hugetlb pages cannot be freed to
buddy allocator, we cannot race with memory hot remove.

Muchun,
Thanks.


