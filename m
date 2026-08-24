Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D430BC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 18:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D186B0095; Mon, 24 Aug 2026 14:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6DA6B0096; Mon, 24 Aug 2026 14:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E506B0099; Mon, 24 Aug 2026 14:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CEDC6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:20:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC4311C08C0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:20:09 +0000 (UTC)
X-FDA: 85136977338.20.8862FD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 37BC0C0008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:20:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="VVZ64v/a";
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787595608;
	b=qi8VGxZz7Ke/vLWGYDnrb9C0NvV7ZD1tGr+KbddYzch8d3G3mx61neEr3RcGR8qrmnkvcf
	CLR7jbL3kb3U1M7c50p1hJ4JSVjPzOmqxtanvQllLh8ZNAwvxwjh7cxT023cl2QwQRehK+
	BL7cWYJTbw0WYAsuQ8hE+TEFRZzCWCg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="VVZ64v/a";
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787595608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9vG0Y7mVhQecHl6eJllLIfmCJ9uIwopYVEZSC9phFc=;
	b=ZAqdaNt6ifGEi3L7y1q7uKVSwEDCgAxvBjgGgAM18BKZm8vjpIXEpL0uJR5sFeCsQCUZDr
	L9g68BeTLQobsPAkJV/XE3yzLub1PVhEP6iDnMIgeqSBYu25gmevKeCVasb7G4zCz9NplS
	ioTGfTpc/kpTeTWjBlz2V0W/cJfat8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6232660120;
	Mon, 24 Aug 2026 18:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4C61F000E9;
	Mon, 24 Aug 2026 18:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787595607;
	bh=d9vG0Y7mVhQecHl6eJllLIfmCJ9uIwopYVEZSC9phFc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VVZ64v/agVHINM1ozDQT0CA1zHGvcVogxWNYlkiMraLmMUQ7cUmdIm+ROAzgabF3b
	 2/KF2/nNv4jM0vrotyW1o3yVBnC6uid7j/kfqRQhOoAA6Bl8o8GHryLslUZ5OtxIW2
	 0jv1Cchrp/nhI+uNkibMC51b/J1Ym+S+O33Ei8yk=
Date: Mon, 24 Aug 2026 11:20:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle Meyer <kyle.meyer@hpe.com>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>, Liam.Howlett@oracle.com,
 bp@alien8.de, corbet@lwn.net, david@redhat.com, hannes@cmpxchg.org,
 jack@suse.cz, jane.chu@oracle.com, jiaqiyan@google.com,
 joel.granados@kernel.org, laoar.shao@gmail.com, linmiaohe@huawei.com,
 linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mclapinski@google.com,
 mhocko@suse.com, nao.horiguchi@gmail.com, osalvador@suse.de,
 rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
 shawn.fan@intel.com, shuah@kernel.org, surenb@google.com,
 tony.luck@intel.com, vbabka@suse.cz
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline
 for HugeTLB pages
Message-Id: <20260824112005.856732bac3094b62a430d17c@linux-foundation.org>
In-Reply-To: <aoyFK92azAlDAPuF@hpe.com>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
	<0d2fc2ab-333e-42a1-88a1-6bb85538cbb0@linux.alibaba.com>
	<aoyFK92azAlDAPuF@hpe.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 37BC0C0008
X-Rspam-User: 
X-Stat-Signature: 71ancpazc73whsw14nd4kcysjdjjpodg
X-Rspamd-Server: rspam06
X-HE-Tag: 1787595608-968610
X-HE-Meta: U2FsdGVkX18krwkfH2F6GeEo/MLDW4zxBFDiLC0Gq3BzMu3nDmXmKkJ8CfSf5RFKdSW9inyZiTqgykwEddvik5/DqBxUu/Bh/VXZgY+TQARI9qYOIolVM7w7e98OLC2etDsAMNLkoJxOVcyM19eg/UfDD/Nof91Kt1ChlNTaEGIgaUTilTuHrgqUYbKwJWV+nU4yKm2FZvd+uq2K54duALUemU8OLwRdjLZciSaZB4LhSG1jTgVGbz1bF3fOFMyiTGsVoDSWAB7Di0FN6vfommJ/xsSbjqtcuBXtGmDq1KVRPhRQhJ3CxnyTapbqVNvui1bAarOBXyaLZn+7F0k9PGeAkf8qPQ5+GguNrMuN+s5385RRq1ZjZcHm/3/9l4pyjtEJ4g4SsZUryW0L1Vl82OxO4Acqu4ZM6+Hq4PlqNqk/83z0UQU92W9WvfpUQe9CH/Tuy1d/XDU+NtH6DRNTbNl+NmTZIF1Dck4GytWUfiCD5m8YqR7qG5YZANyfX5n1PMjG6Czrq++ZjNkj31//q5hrJqE94IzjCXSh4B/mxP6i5Eh+TTomJLcMx7lprWjL56hglrdqMrW6dCq6yPzHXzdQJB3MakGp64MlXewCiNm9y0fhwf87catrMTckYlFMa+6/B81N5XnRaFfy8CtBgkA9zX0i38wd6eHKVPS58PlDCdrrRrMtZkVoYyx0Sgaz6ELsmkY5n0s/kKXa0JSrJpIl49Ase1d0LwAD7PRwSW4dh8QCBo8v2fFHqaCFFHof8N0iikbNj1yTCMbW4s4L2NaNUq4OnTSjkGyfZtLPX6MoQkL83P8aYXE1V6pfNDTCgHE2YIL+8RJihiuFRjS45CXSXyq+ICUej9XzGHoqM5n87f+OL705PbY3s2Fi3sjc0IYfltYczqLO0d4XMd63UCFmE2bh1zqA4LNAQR4pwvqu6jTbLCG7rFzrA4oDxY4YfICqMxdz14RQ09YM4ST
 sIdxLhQq
 4kQlevYN/mnBCU7JEU+Z/b1h7kzV+pPtU59j37oBg7xHLPwZWtDeLa0ZwIKbcfHunrt8++HGtV/47T9fbg+FwkWENOtnSbN3/1dXai1kVaA0m6Rnck2dDZalvmMFy3aAwYVmCNXlUatMtHNS6RpIuUFLnOSziGKan0QIUovt0jQ2EpxaNhTZFm9yRvWIG/cQPlLPMzOSEhgeyEHfnKcyTMIUUZL3/pNYJMred+ky14BVXJPHyV0lL6XwtjiQAfGzWEHPNPZgO2lx9Wm1pf48b0iV1ko5OOmHr4iGqoZm9y7icxK/wAmtCRjZ1KqtKVLKZZdtMGEoDum+FthwV4birej5AxSRsyJ+mvGTraTjSyFRoOcwhE1j7HajfJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026 12:53:47 -0500 Kyle Meyer <kyle.meyer@hpe.com> wrote:

> On Thu, Aug 20, 2026 at 11:47:11AM +0800, Shuai Xue wrote:
> > Hi Kyle,
> 
> Hi.
>  
> > Following up on this thread. The v2 patch once landed in akpm's mm
> > tree (9ae6eefa4b6b "mm/memory-failure: support disabling soft
> > offline for HugeTLB pages"), but that commit is now not reachable
> > from any branch, and mainline as of v7.3-rc1 still only has the 0/1
> > switch in /proc/sys/vm/enable_soft_offline.
> 
> Thanks for pointing this out.
> 
> Looks like this patch was added on 2025-09-16 [1] and dropped on 2025-11-11 [2].
> 
> [1] https://lore.kernel.org/all/20250916032512.AE588C4CEEB@smtp.kernel.org
> [2] https://lore.kernel.org/all/20251111231818.52A60C16AAE@smtp.kernel.org
> 
> I must have missed the second email.
> 
> I don't remember discussing a v3. Can someone please remind me what we planned
> to change or whether there was another reason it was dropped?

I interpreted the (lengthy) review discussion to mean that a new
version was to be sent out.

> > The underlying issue discussed here is still unresolved for us:
> > firmware reporting per-rank corrected error thresholds via GHES
> > triggers soft offline of huge pages, which neither addresses the
> > failing rank nor is acceptable for workloads that rely on stable
> > hugetlb physical layouts.
> > 
> > Do you still plan to send a v3, e.g. with the disable-bitmask
> > layout Anshuman suggested upthread?
> 
> I wasn't planning on sending a v3 but I'm happy to revisit if needed.

That would be best at this stage - please review the changelog to see
if additional details should be added to cover the considerations which
were discussed.


