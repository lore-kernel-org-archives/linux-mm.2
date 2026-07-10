Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40141C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 02:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0D56B0005; Thu,  9 Jul 2026 22:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288A26B0088; Thu,  9 Jul 2026 22:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6716B008A; Thu,  9 Jul 2026 22:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF8926B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:00:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 86EFF12034D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:00:12 +0000 (UTC)
X-FDA: 84971211864.13.0E3329A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0450340002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:00:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mp80hfLZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783648811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQR/fpTAp3uFk/SAvTzxTjMYm0emoVldxDMGrSK5aOA=;
	b=Hui8A5j6kun4UGnkXZl0lDhuSZ7jpaRTRPC9JR9LRpNLf+eBA54BBsk62DEaZtI3lI7xvS
	5SvpLfCW1aK6jFF8LdljJcvvynQBHLgP1CABefcPUVcTl5bumSA9DuAV3thCz5Zz+Ie72a
	MjUJ0gLt/mcbz2i/2EkMJD4ENdqt7Bg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mp80hfLZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783648811;
	b=z65LVwV5Bq9IlnycjhqaoDSuDF7ReVH1IasqmB4uYY3x7quGJjNGSQkhycQhbvY6nLtf4B
	L0RgxVz+j6+U/2+oqtD6kLpHQfcKVqe+sDwV5aCr6OGRVwHF0qXa9bjQjCERmLXemd4pO5
	RDLV66aUNHN5tvFOSeSq+MBEntHspH8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EC4E6001A;
	Fri, 10 Jul 2026 02:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDF81F000E9;
	Fri, 10 Jul 2026 02:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783648810;
	bh=JQR/fpTAp3uFk/SAvTzxTjMYm0emoVldxDMGrSK5aOA=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=mp80hfLZiUhiVHFAjrFWCTiaw0XyEZAS6YGFXDz7KSeyINOaCRED4vOMALf4T2QMF
	 QW+/b8bH25XrqSs8A7eBiT2FDLbD/XFw4UbhOAJkL6fEIv5Tk+TCS6X2AC/Onags0L
	 e5IQB/CzBO7dv71AS1f6IshsFzhvVBLEfKZmpap7nJ3YE86jA+be2qASHacR6xjMTX
	 VtvR2QTAcYML5ZfHztuqQHaXww+ZucmPUTWcqe7/ftgvvOEnJozLDC+ROoPZid1Ga4
	 wDm6+CiOnswBzHvNj0lnMsrQrLWqQucl2KX3l7RhrUSmL2mnKrF1WoESKMGA2fmpLc
	 s5wTGo/GNTy4w==
Date: Thu, 9 Jul 2026 20:00:08 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Vivian Wang <wangruikang@iscas.ac.cn>, Paul Walmsley <pjw@kernel.org>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, 
    David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
    "Liam R. Howlett" <liam@infradead.org>, 
    Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH v4] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
In-Reply-To: <20260630223332.534218a41b2f574de327e4db@linux-foundation.org>
Message-ID: <b7ab255d-8d0a-24f7-2953-4f5decf11432@kernel.org>
References: <20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn> <20260630211100.5c8f09c607595fbb5bca0a74@linux-foundation.org> <cd8cd425-7615-49a2-b26e-81a9aff0af28@iscas.ac.cn>
 <20260630223332.534218a41b2f574de327e4db@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1875493869-1783648810=:300523"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0450340002
X-Stat-Signature: qbc9puoh41i44d53a8ssgtntxxkz4kg4
X-Rspam-User: 
X-HE-Tag: 1783648810-100214
X-HE-Meta: U2FsdGVkX19BRq/FoLVrDrEz5AD4WGym5CQ0P+pHgcYJMHNxbwWyaOcBVmkNpe3KNXy0HemCo863lTwYN6hxYaYoqtVY47uMo5UMedH/e2sK8Ss6jtI314JZcE0SpCDnmbOxjsnPgMhHwst+YH+lDTANFDizMamb1UUq8T+qcI+qIEGA5V2B8OjAfPce9hbI7eN1TdnRqTOCE/NzGNPmSRfQoxbiSQxY1/TZfXfk56x7wI3I1jJbDQlhHFpE79zKitASopVYQgmPLZd7/7thnPRwuYVF0CHwxiBy1ZUEqqs4MLldrnN59OQGdOLiUbwCwg44gQ95Rfg1CGfm9Wf7//OeyxC0RqlB8yPw9w5iVTpXb7rkSZX+9eUJOGOv2ruh+lFQSMBbJzbq219dMpE59qbFPzj3izB8YdbfkEKVkh1/mgsDw/4TsAA4Yqowb+/YnfS5EFHpHflekzH9RPWfFJTuiDnXIDE6Qqx3xo88Uwa/nCTVacLZyc99xFxTZfPN4OD5h/DwnZGzw7O7TJhDnkQoW1SeQ34LlQqkXOxx8R0WOHPX52SiXQ8JNuug3wcF6etQ7/ik5Mei37NoX9mhNna7wnuV3LLRrP1dC5UM6n/FaTjKqMkIdtDqPj+yRwYP+9hCNxpiAtdAlbakrREGUl2tc3lSMjy3QkHYUGRL6FbVWEP32ZEPjkS30ZzC5qyG9z2Yv40XBYY7aJCixtINCzuR56YHLv1bbc4ncK2J9p0gxmT8bQ281XbpeX8D45XVsHi+p85BqWVdmhUgP6Vnl4N+9hvjZhgrgPTCqQlzsk2NRFBZIIuXr2Ja4gLBluiWIFbiChvbCNbkr823jDF/o20oicwd3kjLG0OrRrwm+pwqRTZFxxAw/tHfQVwhB8apZzEzdyeg/cYp6xX/VGhb6yEdWBiYH0T1yGa7N75kfYoFt19vmT71Ry0mu47yKMsrp8OARIaiM17SdfsaorG
 eb0to/VZ
 WbhFJPa/mIlKFDRqew+ag998CerQS1/1T1zOUjymTqmeQGPUrPU/UO38CASQDN3Jg8he9+4xNny4p16suMAadCV1nxdfxHvIkfl2fJlcpr4sEK8PVIsILeh1wHn7KziQonhHDtsdT2jxSVjy/agVcS5iiXYYHqAPks+AFsgFyx/xYPP9Y8zLRU/8m7oiwFu2kvWwZ7W+KckgswEcPGlXnKl01J0bSmZB0phvjyzYusJgtg/EiDdrNciQzbH1mymCGvZzocX9N2WIPCEiRO/02CrhkS+BJ6TqL9fPC5xrfHc4Ciu8rKg698Nwi8aGNXl5R8KrUY53s2aulwoLvKj6hL0U2DBoUqd2nhITG9hHSNiAjJIkjv3wXbSsHLb1aY/0CEz6O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1875493869-1783648810=:300523
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

Hi Andrew,

On Tue, 30 Jun 2026, Andrew Morton wrote:

> On Wed, 1 Jul 2026 13:01:15 +0800 Vivian Wang <wangruikang@iscas.ac.cn> wrote:
> 
> > which made it miss:
> > 
> >     Changes in v4:
> >     - Rebase on v7.2-rc1, drop dependencies
> >     - (No code changes otherwise)
> >     - (A concurrency fix for mark_new_valid_map was sent independently)
> >       https://lore.kernel.org/linux-riscv/20260629-riscv-mm-new-valid-map-ordering-v1-1-60d8c10c6292@iscas.ac.cn/
> >       ^--- this
> 
> Cool, I grabbed that.  Same caveats: riscv maintainers, please?

I just responded to Vivian's v5.  I guess he'll probably do a v6, at which 
point, will plan to queue it for v7.2-rc here, unless you have any 
objections?

Thanks for helping out on this one,


- Paul
--8323329-1875493869-1783648810=:300523--

