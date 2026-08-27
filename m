Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41BDFC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0EA6B008C; Thu, 27 Aug 2026 05:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A19D6B0092; Thu, 27 Aug 2026 05:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B80D6B009B; Thu, 27 Aug 2026 05:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC6C86B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:05:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 609F5A034E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:05:53 +0000 (UTC)
X-FDA: 85146466986.12.02FD066
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 86DEF40009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:05:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FfxLcfpG;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787821551;
	b=fRSjm+Hkci5ByZ2KFEaZ7H5WKfVJLOm5kWZ7x3gYjw3+ja6KyRxTk0iF/Y9yW+ZErOTWX0
	v2AHgRUrTLN1oC1XmU/5WiPp4L74kjQaP+V2CWScWKGd7oCoAgnEIYZBzN18PVYGpx4Yl8
	oQ2KHcgKZGxsfmt/2h+7B0LLJ7ofxB0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FfxLcfpG;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787821551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERqZwpmM+7KKJYkn/0GThKweWRknia+cwxXgwxceimI=;
	b=IeX+rhda/kg0h/xkUug2ruUmqoUD8OwFi2UQ9F1xtyQfaNuUZ/KY89jTcR9QFQadKTrLvh
	Tya12ZkjtHsVET3ZjbjciVZlkjEWEzII99E9yH3EmjwLrMaFqiWhg9/AAorh0KfbQ/omsk
	HtPUw0JTFNht0704xBwoMy3SMo2cw5U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3ADC43EDB
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6DD1F0155F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787821550;
	bh=ERqZwpmM+7KKJYkn/0GThKweWRknia+cwxXgwxceimI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FfxLcfpG+g1v0k0aCEG/dXXtqsMxBIRJeMETT1ABjvDUZzZHK8uoYZm2QPv6QbquB
	 gASezAkL/AELbGlyGfKoYnOq0HJZUUXkCq9btswi97TQQhOiHuDk0mmd7Jz4XLmojf
	 MaANQNtZRV+ppW1797vd2iXjNkqRJ44v3tw3KKP2LOoZcewU0rUYpNLd+jjtxL+C2l
	 juo333wfXC7jdCXnLLyZMKuJgLqNCpmSYtLLvX+/TrMB9Cr96WanW5jhYbkfUEBm1N
	 5HXBMtIE5xGZH5lvgkPqqns0sxaAZPoyU4Fci9PH3GJL2XI8BefWutf6WrpOrV6R4J
	 v3emlLmscI3SQ==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92f0b5ed131so167268285a.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:05:50 -0700 (PDT)
X-Gm-Message-State: AFuF++nkIUFl2SjR+8tnsIEby8ZPPGmYsxgpI8kXXEggP6rlHEPa6xQO
	icHoQnEvxF3N99BdJZI7BxhF6mJJUBNh+rJj6qXQeC+oiXd9zKmvU+IfCJ9o7rsm/xRGmM4Z7EA
	ugIa6S5Jfz4RzQICqgpQJ40IuX7OJwWQ=
X-Received: by 2002:a05:620a:29d2:b0:937:7836:14ff with SMTP id
 af79cd13be357-937804b39dbmr1193610085a.33.1787821549793; Thu, 27 Aug 2026
 02:05:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com> <20260821-swap-thp-cleanup-v3-3-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-3-9b43f5163238@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 27 Aug 2026 17:05:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xuN8gKVscCY4as3HLFKZV5+AGWF9nLaq93F_d89xL3qA@mail.gmail.com>
X-Gm-Features: AcwNN1WwDl7OLRp5aAVjzRg2zIQwM-f8n6HU_TmeuVeGaayOsgsB-1AQGCLrSnQ
Message-ID: <CAGsJ_4xuN8gKVscCY4as3HLFKZV5+AGWF9nLaq93F_d89xL3qA@mail.gmail.com>
Subject: Re: [PATCH v3 03/18] mm/huge_memory: invert folio_ref_freeze() check
 to reduce indentation
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 86DEF40009
X-Stat-Signature: arpossg3g9hgryeo57ohryqmwjss8xtw
X-Rspam-User: 
X-HE-Tag: 1787821551-339536
X-HE-Meta: U2FsdGVkX19tsiGkcWADbV3oK1Y81yKyERnb3lIZGHMwPHD4xI0Ix8RxISV6fP4i++gz6ueEPXwKZwYx42lV3uefBJ2p31MU1+0Y3a6CoD79tQOMb/x7OCdr0KyThr9TLwZKQNWVLdQt+g5Wq4xmcpMwYQVSSVQy+X1zPlChqHCi8gyRpdLi2KzBxGMA2Rzv929IxXLVz8MEyefUcBiocmHt5tYNa0Bss7FyCCr45E4ltopA+CI1hDtIIssybO0PBKmrUViyHfGcmya5eMloKebceu53n5DtbnsEPG9FbblLEuWWuN1O4vYRfUOem9+m8rB4eA4Jf6XzeZaADdF7JljmBZAePUH0oZ9rNd7e0vQrnLu1AGUUXniC0yudsb5GyC+r6Nxw/mQAWP8lOxSLlRGEgIEqElHfDiywuB6D0uY23ZaH+TdswVI8zfd757aejckQA4L++q+2p8hVWywIfxm+bReX9Ig8oVocCqO/YhzIcYbBx8/PuuVcl99zWJbdAROWixmeagwef3L4U7ihRJJ3TLPpxWoraiffoA8xyGwrfsHJzQlrZFrz7QYqSXqqRXmVHVeH8dBLPBWRKhXNBuqw7P6ueaE012Y2IUZD3n2lP+wzxwJn0+nXg3iBlnAOKXmGc8OYvFL3UID1C9ZQJUTqcLjTe31mhB3zqzfxdQNzJAn7e6QH9h/yphkOAjivWji6mIZ652k3NBwDlG8cgg4fAPBurqFbUrRKHDOEL0Rm7xO3WIW7rPDrS8u81r7iB+xNcWSffLxf5NW2l+6f8paZ3sKhxEWOl4BVxt+LbpYPlYIGN6bhqE0MZwE0LZeeg1G8JVTx+mrFUAsGIr6ETqDKuYwW18ZoY2Q1cb3A+TO9uNYYmmW6MEvECGuuKh1p/eAR4Up5F/1d7ma0GtTXk9gIY/ExRbr7xs6Vb+5+UQjKSxiJk1ciOLtu5xOPU+Slqj+fajcputfCh+ZUXQJ
 8CEC9/J7
 wLsucb/bIjryuQpfL5m7dH+eQIe0+TpUOiMZtb3axtQg/vdO+M1r3W0F/1Ftbx0HEMfw7iLzSwLSa4kBJKzUWmwFsE0G9GLE07ZMRlzLURXBoE19iAtsZDiqiH92uRa90tVqdvhd0ZZC3T/5QQcDYmxAcKujSx1qKpMAJmKR4ocqba3Iog4IfYZB4kmtYYrYXqpwk31AMMcnrL/Dh/7lAvMN9XEv2lMqDPtEsg7mn4gm0JrgsCkhb9wS8Mbh0OQxY7dlJrH8CQRTKgKoDHFspdqkebga0pF6emmqCL8zqUy5t3JIFfmy2Pl2AeIsCuQX2xd9/o3Q8LMI8CU/QkjB7mLI5EixRYeVF6MybPH1SyKqRECu8Tdq3/nO7Kjm2Ngt3qZTqe6TkiS5mRpAVWWxQo+mjWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 2:55=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Invert the folio_ref_freeze() success check in
> __folio_freeze_and_split_unmapped() to return early on failure, which
> removes one level of indentation from the entire success path.
>
> This is a pure refactoring with no functional change.  It prepares the
> function to be split into separate helpers for anonymous and
> file-backed folios in a later patch.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Good indentation reduction.

Reviewed-by: Barry Song <baohua@kernel.org>

