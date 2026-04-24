Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44842FE5200
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 10:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6914F6B0005; Fri, 24 Apr 2026 06:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641616B008A; Fri, 24 Apr 2026 06:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5573A6B008C; Fri, 24 Apr 2026 06:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 41D7F6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:20:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D52A4A0742
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:20:43 +0000 (UTC)
X-FDA: 84693055566.26.9F4A093
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 22BDF14000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:20:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KBJaGO89;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777026042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7HsCofWu1Fj4KM5mfTpvHEQ8XWMsqEKDLZEW1mgiAw=;
	b=EeHW3G68wQnkpWVI//C/KGULcOL7eG7TjA43xPd/wmgF+yUAEzhkfzQg5jmfGgslXj0WGa
	kpWrjZMEMtk3JM1p1fHxVc/nrayVWHn+d1OhJGct4KgMxQyf/t1y2gdbvkyYO2vPLezhpo
	QMUf89rd70kYVrCx05i7Ljox+iS41ME=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KBJaGO89;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777026042; a=rsa-sha256;
	cv=none;
	b=RG/nc8R83zCbWQLWn8lCHooDoJfEh97fkV4q56ywSQc1Fn1ZjlcxErNI8BLEfOHT/qbRz3
	72iUHb9ozRn2V7DPObxengcaybxJE/AploAHSugu5XnMSxCHdM0aAaaxh+uaNRqiXH4sVo
	nnP3THHIw+Lqqi43aZWxDWoTkx+bhN0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 366686001A;
	Fri, 24 Apr 2026 10:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53ADBC19425;
	Fri, 24 Apr 2026 10:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777026040;
	bh=0RadErNyVmV3gi8KLyDo2YKUadazcNECWm6ket0mhpw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KBJaGO89V8KafZomOFN7DV16OlCVvzwC7VKvSQQilKTbrOJuibl2b3+ADa2f1ziq4
	 RmfX6P7YFFkox0Lnq6RqR/GLRf087p374Y7C+2E8ZHRH3MoEzmu10z+fTHqYsBl9xK
	 4834ULDinadjU00M0zGkABFZBA64qCd2z1++Z5YM=
Date: Fri, 24 Apr 2026 03:20:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Michael
 Ellerman <mpe@ellerman.id.au>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Christophe
 Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 7/7] mm/memory_hotplug: Factor out altmap freeing
 checks
Message-Id: <20260424032039.a43516455eb1ef7c7fd7867e@linux-foundation.org>
In-Reply-To: <6dd8e62b-97e3-4261-92c7-ba3a02ae6397@kernel.org>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
	<20260424025547.3806072-8-songmuchun@bytedance.com>
	<6dd8e62b-97e3-4261-92c7-ba3a02ae6397@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 22BDF14000D
X-Stat-Signature: ea9ddbjgfqyqzfcjidc4po1enjeuddr4
X-Rspam-User: 
X-HE-Tag: 1777026041-212940
X-HE-Meta: U2FsdGVkX194S80sfNFc7NIp0/EqtO+fwg4r4m9LsC+uCmODOaEQLm/FZtcuK9nrH7eZxAk8RR7cZWVpoE9NlWnIx9VzG/Xl+iWHvOSuesebJzLxdhFdTcNdQ6DDA/kJweijSv6nRQTKZukODm+jVQaFgGz7578s5gu0dDbcWNF/77Q8WK/BwGc6q9JMMon1gsGTI20tGPH5nLeK3NZZ8bVRJcKkf9utfM834q0IpALs6asauBRNVYNv9O7bdFDaqhJJKpsoIulS6Sgt9FgKQ4KB6c1ttTywxx64jqfovosD0V5IKSg2coUsjZlmjNhMj47bHdwktpG80T5Nl8qchSZSwVguH5Iy87CD5MHSswxjyvN64QXBWrAmxYGH+WrzYBsD5kegy5sInLQEIwZlrxff5aRBY5mqCIuQr08oC4EQFZ2pKoZanyJi5v5uqTNEhIbNu0+b/vcz2BhylT/nZyejs+8ZkDoTWxZpiKuDAw+rMOb+7Fo5j/N5TxbzUIydGTYpD9dD3bqOa8bkxiAtziNCzMutfd+j9GUwZfMqE864rt7QDvIyRcAPQRbg310R03MK+o5doL/XzVJmc3Pb15HyVIcRGXNuv0yTZKu7JV5/x0hRxkOQhBBnjXY/qvs0a7Zq57xpRMOIrwAivduDh0+3ymsIwk7chzfGF9HPB4nqccJbiJ8cUwDRzBTOu3FeXbxU/2AInjyO344ma2Vv3ZZHlEIYvobuQQC5Z7e4yutHDGAeihstBoJkuxBomOuT1dJsRSsTmhjS15wEX50zveVZtHhVvg1wt02KS+Gvo1b5mHPMoVJ5G2Ob/+QDpy1JDCzLYwLKwjzxHfadG0S4LoA9nsloRxgwYfPpc7FVofBKs9IzyCb8PpOavakw4s4g0jw4l/TMgVxNXaKh5nMs/IytVoA/kUJPkDZQFwWtGnQlKev8yLYNn8Cd3jRFANl4EGG78TGtyi9C52Q0nwt
 +jfUYGFf
 IalQK3fVlcSxTpjZQ1yNx+d5X1QS4zVCsE0+h6k1XGn0RV3Nl7g39gpLs7/2ZZwwLmf3NPsn+foADdqpk6cv70zFXjelzLWyNogIEiWl900tg+yH6f5pVZ1+P9UxN3ZZBOHNj0W7aStJp3g9OVj2HwzCZ0ifCgq4IZxNchr/uhFGhkzsS9JGs66wJrTfmKmxEgngcVsT7WClURLBi5UuYtJ+KWLBbnFDyV3h495u8fw4GG8evsaaz9Z4zupthY9689XaKYrPK/RrNIuw+16RbjXIMQR+R3Q+mqlC5QW2NthpjEosyRvJ8L2idzWk9uUVugU/VmEs7HykbIiDvRD/3okK7iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 09:34:43 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 4/24/26 04:55, Muchun Song wrote:
> > Use a small helper to centralize altmap freeing after verifying that all
> > vmemmap pages were released. This keeps the check consistent between the
> > normal teardown path and the memory hotplug error paths.
> > 
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> 
> Thanks!
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Andrew usually prefers sending non-fixes separately,

Patches which are destined for the current -rc cycle (and possibly
-stable) (aka "hotfixes") take a different route into mainline from
regular next-merge-window material.  They go into different branches
and they have different timing.

If a patchset has a mixture of hotfixes (upstream next week) and
regular patches (upstream mid June) then I have to pull the series
apart, stage some things into one branch and other things in another
branch, rework the cover letter etc etc.  Problems with this are:

- what goes upstream doesn't map well onto what was presented on the
  mailing list.

- the hotfixes (upstream next week) may have dependencies on the
  regular patches (upstream mid June).  This is backwards.

Much depends on the urgency of the hotfixes.

In this case, iirc, the determination is "not very urgent at all".  So
the series is OK as-is - it's all "upstream mid June".

This is still a bit suboptimal because when the -stable maintainers get
onto backporting the cc:stable patches (after mid June), they may
encounter merge/build/runtime issues due to the absence of the
non-hotfix patches from this series.

So generally, it is best for authors to have a think about these
timing/priority issues and to present the patches in a suitable fashion
- hotfixes/-stable patches in one series then non-hotfixes in a second,
later series.  This way their presentation matches what goes upstream
and we reduce the possibility of problems when the -stable maintainers
get onto backporting.



