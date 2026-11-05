Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC10606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UhsJopj7
Received: by kanga.kvack.org (Postfix)
	id A66936B05B0; Thu,  5 Nov 2026 09:10:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17646B05B1; Thu,  5 Nov 2026 09:10:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92DC16B05BA; Thu,  5 Nov 2026 09:10:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 732D06B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:10:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6AA081A0A8B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:10:10 +0000 (UTC)
X-FDA: 85401249780.30.B78E741
Received: from mta0.migadu.com (out-38.mta0.migadu.com [91.218.175.38])
	by imf16.hostedemail.com (Postfix) with ESMTP id 36AC718000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:10:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UhsJopj7;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793887808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXYKCnFMOcWT/GHOYQM/Rfu/7o9VqnHXStFCMJH6+uU=;
	b=78pkxWL7/pnOTwwhqjgwQSwYXIjiSAZJCAMSSiM6pt8eSZcptRuEmQHiYK/wMZQq9fXRZa
	GpBujBgHvlsPl7v4k1NX+XYZAxi8V/jjd5asFMtK0fp6gorrIfoaAdrwbGZvgnY/T9dVUg
	EXAIeEYeYQc3OOgTwf0xc8NCjENhXr0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793887808;
	b=APNQtcE6eFV8RTXYWC0XTK1TrnJFt64ns+35my2WKGFfT2EJAwB1hWCkj9vwOy9AWCoNar
	5ruObfRtQnKYV/tHX0T5zCtFx7W7eAH5onguDxuHI6URJcfXzB5f/VMbN6XEPPiRn6U9ie
	X5UvmKVitVRzwtexljlaslSBfPhlRe4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UhsJopj7;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rXYKCnFMOcWT/GHOYQM/Rfu/7o9VqnHXStFCMJH6+uU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793887806; v=1; x=1794492606;
 b=UhsJopj7eHfVHFq050D9+MxCSJ5dHBhv8RJ2yrFPYzZTJmr+fFjQwFUL4NIeyiehkWQbe6du
 OwMc6YjYlYxGapwGW6wa+IIA9cAAL3q2QEymLQesF7UnpiBLFL31BY1Z2zzcJ+2U4mahw4VDRVk
 qasCYPCXLuwXvbxG4cxAdrNc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id dd249d3f7c375ee6;
	Thu, 05 Nov 2026 14:10:05 +0000
X-Mizu-Trace-ID: dd249d3f7c375ee6
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 0/4] mm: Enforce read-only shared vmemmap tail mappings
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <0851db25-fef3-4f96-8d37-81ad5c51d6c8@kernel.org>
Date: Thu, 5 Nov 2026 22:09:33 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6492A4DD-B00E-40EA-85D6-93183E8D3ADC@linux.dev>
References: <20261019090830.1917657-1-songmuchun@bytedance.com>
 <0851db25-fef3-4f96-8d37-81ad5c51d6c8@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 36AC718000E
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1cyf7gyx8am7oacys7q3q1fisayd67hh
X-Rspam-User: 
X-HE-Tag: 1793887807-209252
X-HE-Meta: U2FsdGVkX19S//97Nc/IkhG5LPwVcRlLaAIjqSI+emMlj237SkNJhPPqUFY5ZITqM9qdeWBc6o75LwCefs1YTY1uko88qsAjyjAYqph6OnR8vf3KrjlEwECakg4bzY9VhBGTJWfI2a2tzCGq2HslJaqSgAbaJY9I+gHJVvkZfS4GzjJtyZSjWgOQvbj3Oxkw3tKlV54V/wUVoYQ4NpL3l3zw0mHnB7Yoy5tLiH2D1Fw0t8ikz50drxImaXiTw/oveIFID/kEiPVkO15A6BlFXKsouAfZnUh4IE2UpbEKsAix6PfdfBtyj26Wuvd3tf2J1/htku3VsDbfQol2a++Yo7cPo3C9b/Sa7j1Z5KZiMmXUxZZvj0Y6mn60em0WWQUKlzLYyWJ+DYkR/rdSmcGkaPbRWkdRFE5HnTBvHGkpqO/WuqFaTG41NQuCzf8hxKjQfBnf28SvTB7Sfo1OR4yH0GjkPj3RB2xpGZPzXDKZJ7kr2N0xKuPpVmS/u5/UW+/531DKOdsTRMs9NTlX9+Q84WHkkmITWavuHj41jG7nzh7CPnbwehB5PHGcaWUHAZT6Fz9vx8j8ZMC1L6XNN6l6EULAtqJ7yB46AOZsIWGkY5diCNA1JHuDTUwgDsg3Uc8uT4UeWSzEjxdYB8wc3o3NCTiFwYPCIkdGz7e0gquK4svYDjV/kMpJsDtBaACps+p6x7SLbC3fHUaDAuL2iPv2N2bJHOfvr7Riu8EIurlewGZNASsQDx/c5PXIDNBndbB3W9DGvVgfqiUnzHdtBtU3IFUyGn7+9465hHWPGWdYwKFkn+qBW6Ta4G2lg74U8cKLbsyhI/Orm/xjl5NIOTGHDSkcRv+m9K4c0J8ffza2FiphGDZS/cDx+AZr/I19kXrlduKz69+QYWjrGpYqeuTJS+7MTgOLXT4TUHOn05VIHarSrmJjmlKoRxuCp2pAoNIPfSQQClCxKX56noJZJrh
 C/semcn5
 4murlhGcp7wufQhnV35YJVHrcnzW2MCE0Uk6r1H3gcpGqoqZSJXc7W0GI8jpOXkziCcbSqw+rHeVQwGPE3APBZE3HavZWCvnl/F9H+IjyH22YJeRC7AtTxlskCGZqZplUhwwkhvgZthFVOrRdr+U7JNXyAJUxE81gVMrTrrBhvFJMvJ59z8KXUfd8h6InDLlCnnMXv/HNxtuOW3zPgei2q3B/z0tYX2bIyVl06FVSdQrpymKoTcB3MztJ57abbfO6btkbnAhjwqKSwJN69aVzHnDUnuq2mrsN6o2WKgMtgGhOtZqwPu29m/RXHrCHUXhLlRQeg+8WIjswHlRkbCyKbUvcrpzNj2g4cCenPI1t6msiwk8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

> On Nov 5, 2026, at 18:33, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 10/19/26 11:08, Muchun Song wrote:
>> This series is split out from the earlier, larger series "mm: =
Generalize
>> HVO for HugeTLB and device DAX" [1]. While the parent series =
generalizes
>> vmemmap optimization across HugeTLB and device DAX, this subset =
addresses
>> a single, self-contained step: mapping shared vmemmap tail pages =
read-only
>> at population time.
>>=20
>> After the previous HugeTLB and device DAX conversions, both can =
install
>> optimized shared-tail mappings during vmemmap population. These =
mappings
>> should be read-only because each shared tail vmemmap page backs =
metadata
>> for many tail pages. HugeTLB applies this protection in a later,
>> subsystem-specific pass, but device DAX currently lacks it.
>>=20
>> This series moves the protection into the generic sparse-vmemmap and
>> powerpc radix population paths. This protects device DAX mappings and
>> makes the HugeTLB-specific vmemmap_wrprotect_hvo() pass redundant. =
With
>> that pass gone, the bootmem-only optimization wrapper has no distinct
>> work and is removed as well.
>>=20
>> This is intended to be the fifth smaller step toward the broader HVO
>> generalization. The remaining HVO naming and enablement consolidation =
is
>> left for follow-up series.
>=20
> I assume this patch series is no longer applicable after we remove the =
RO
> protection for HVO.
>=20
> Or am I missing something? :)

Not quite :) The runtime RO part yes, but the vmemmap population path is
a different story =E2=80=94 struct page isn't initialized there, so =
there are no
concurrent accessors and setting RO is safe.

So we can keep it and enjoy the protection RO gives us: if something =
goes
wrong, we catch it right at the first scene. So I think this series is =
still
needed.

Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David



