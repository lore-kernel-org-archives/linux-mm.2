Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC462CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2156B0005; Tue,  5 May 2026 08:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97BB66B00A2; Tue,  5 May 2026 08:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891F96B00A3; Tue,  5 May 2026 08:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 78FAB6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:54:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D094A404A4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:54:34 +0000 (UTC)
X-FDA: 84733360068.22.586EBAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 028B1C000F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:54:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mUWj78NJ;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777985673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vz4CGX36EEsGsxBDpjNDXedJ2PK5fPred0mFZ7McNg8=;
	b=U7D/P+K31mBKjLlWWjkxt/t4uSzDLPWQDRQchpYiIshPBBi1BklWz7EEsHf1C0j7ziSYbI
	T08RlPhXrec9caQckGpuMrtdQ2ICKOcgwOy56NOQsznyHh+CR7bJtDWpJZS1AmbPVuvNJf
	r2Mxm+EcZPSsTF1J9TsgvK+41ghsmOI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mUWj78NJ;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777985673; a=rsa-sha256;
	cv=none;
	b=pWyGtD2i35lY+5gRZifeHjP4xdWr/mTG8M+EhOaFIj1S7bbmi5yRrtuYCTIH3yn6oR18KA
	TjBFFiDHC+q5J3pox/1bMsUQDrZwuP3bssU/YdDO3dqESHMuOOkMc1Wf5BqmWZiVZONbSs
	e8I6XZWuBJyhde8Avff/aXSz0Ix1iOE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDE6F40116;
	Tue,  5 May 2026 12:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE9AC2BCC7;
	Tue,  5 May 2026 12:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777985671;
	bh=+N0bcqLoMfCKrRzjn409ABjF3VG3lutlDleguHU1gMY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mUWj78NJ6NaeKrIkzqEk78tvh91VgHNAcuHRL6eX1AgQF+YiYT1G6CPJDqLgnWXOa
	 k05SaoKl2K+N0jm9ahJm7/dmxzYsGZHI2CaRUAeYu6vCnFh/fMjgTxHgzXj4pz8IK5
	 Vsel93yCQ6y3feeyxFtZb+u+Sj8xLeU+DhxPtauTQbnB7/QiDuqLQTE1yqvKeDh18a
	 /faSDiUbzhpm7+iCNGutW4xGxgSceU2Imy8aQ6iHpXBTesq+8lfDyuCXr3aluqfs2c
	 oiSOzilb6j+zTK2tgzdYFkPNLMUK8B7RrBufGEPCjyhtpDyRJRCY1QFbAyE8dUVXuj
	 bcW655W4QvVOA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jork Loeser <jloeser@linux.microsoft.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Alexander Graf
 <graf@amazon.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador
 <osalvador@suse.de>,  David Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] kho: generalize radix tree APIs
In-Reply-To: <331da42-b255-326b-cd5-28d07a7e2cb2@linux.microsoft.com> (Jork
	Loeser's message of "Tue, 5 May 2026 04:20:14 -0700 (PDT)")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-2-pratyush@kernel.org>
	<331da42-b255-326b-cd5-28d07a7e2cb2@linux.microsoft.com>
Date: Tue, 05 May 2026 14:54:28 +0200
Message-ID: <2vxztssm10fv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 028B1C000F
X-Rspam-User: 
X-Stat-Signature: 5khhsoayi41mps4gqmjf1gc7troqyrm8
X-HE-Tag: 1777985672-827545
X-HE-Meta: U2FsdGVkX1969FoMCDcryXFJ2T/rCWxK8/SziWdZVrS6dSxf1beN70jIV53GHT/OnfZPaardWNit0CJrK4WFAcFY8mhiOOAXp+dgrJu/RwLpxBMESFegzX6/u1ejM8mDqHH3mK3BfTajXjLW4gBCV78MNssZvDpsOHAS84GC3wmwaBCRXKcNhaTswqy4spr03QcXccwA/12R2dDRCfbG+7bcPxFe8EO1t6AHJzlyq0x02uW8THG5McN2zbsURSHNuO5/lSb/s81xf9n1KsFWxONCaoB9uCDY991m1rPF8421eCV5gI92XTnGVQsKZby8YHQk5JLcP/rMCMdsgJeW4aq5XulGNJw20wVGyuar3Cn0edMXuBrWtqQDcRJr7Si73+mCkJDzZSjq2qg6i2GADZE3zgjFdJCSzPqACO0mPMZtS4xLhCH+qicSEIF6VMmCjcV0knMj3iSpF0p9ngUKoXggRwJNbBQ0mSaQjN4i1t1Wqcmw9tehKBYT881RcNyk/PAhzr65ucGhZy6dUxr2dyOEh86rJkZp2PEIrWWYxEhM9Iap1Fria8JIG/L9wsKjxMKogMHBpzcik7vwDo0XufJai+qMwnGzu4R2L4TAX+Z4RmwBUwjFrk3KiMNKBS0/bfIgeMKeV5xN2IQvOQlEn86++WxzOrqKkbayi35/WEHqCHv+rbmgoeFuRAOys5a7JZhsJCyuUE24tkXw7TDUpiFDgvGDy+M8r212bXhYOdOl4niNHtPXq9vYgFi0DUrTf/q3pt/uhz9cuc9HYXHwc0lB52bVRAzAHDOyf+XK6vJGgnBedpnGg+/HaBrn822K2gy2hjNucihqdWhrt3WpP7GLkvIyPhveWp54vGjUYBU6lJA9Te3O/xRGHyuBITHyaaoj/U6/thhevqyWxCYV+i2AEXixQAHfVhoQ2lbDWjmHovsJUMH6JdWQ5mvma2x+NPVCx9sxkRY5qtLSJmq
 5uLZoYfg
 DPy3MaFsL+8tFArZLZGUb3p543j9lX0jToKVTw0qxGakaiS2hqoTbsWYx58NWsDX5AV+QqAarmyrj8m0yfOW+ETe6xWJU5GVVNy6YMb3DwcARhpxqjHvJfwgMAy9PU5bxyvx/Ck6ESROX7sE2TPaQPaAr8O9JGhAGIOAvIxx70EyRiBl8yUjs+nxW+kXXdpYDdIbl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05 2026, Jork Loeser wrote:

> On Wed, 29 Apr 2026, Pratyush Yadav wrote:
>
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>>
>> The KHO radix tree is a data structure that can track the presence or
>> absence of an arbitrary key, with nothing inherently tied to KHO memory
>> preservation tracking. This was one of the design goals of the radix
>> tree. This was done to enable it to be re-used by other users of KHO.
>
> "Arbitrary key": Not quite the complete 64-bits, rather 64 - PAGE_SIZE, correct?

Right, 64 - PAGE_SHIFT.

>
>> + * kho_radix_add_key - Add a key to the radix tree.
>>  * @tree: The KHO radix tree.
>> + * @key: The key to add.
>>  *
>> + * This function traverses the radix tree based on the key provided. It sets the
>> + * corresponding bit in the leaf bitmap to mark the key as present. If
>> + * intermediate nodes do not exist along the path, they are allocated and added
>> + * to the tree.
>
> Consider adding a note on the key-width limitation.

I think adding a runtime check would also be a good idea here.

-- 
Regards,
Pratyush Yadav

