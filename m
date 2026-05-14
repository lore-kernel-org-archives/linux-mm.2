Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CC4CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 16:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EEB26B0005; Thu, 14 May 2026 12:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7BE6B0088; Thu, 14 May 2026 12:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08EBD6B008A; Thu, 14 May 2026 12:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED50E6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:45:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4B90140624
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:45:25 +0000 (UTC)
X-FDA: 84766601010.02.814A8B1
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E0B01A000C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:45:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RV6rcbcB;
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778777123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=os0eHsZVJX0chVl1RmCC7RjaweXl8YpOUWjuIOShXWI=;
	b=hv7lUJ/Lqmjed2/7OuiFbDYL+/eYqTY6XJHZXqwSeAYCtfEsuyCI9Dpe8ejthnaviBANhn
	ZaOjGGgmfDclR9G+ZGN/7II9DDRcVfq5wwsYzv/qmpGlizRrpWe6WDvfrbCdPl1RjFrnoc
	zdlvt0EHLRyECBQgaHphZywwVJib0Xk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778777123; a=rsa-sha256;
	cv=pass;
	b=wct9Ijxu6x+6JPh9sSNj+cET1FVomFM4yhgg1m/gXUb5cFmOF9x1KvceqrARu4zGWHgqnY
	LUiTrj+Uqqzuid35Xs2+yupC6iqCCpza75TwLD3v6hsrB9JxZPaj6RH1s6caGZdjPjg4/N
	piJTGLh7Bp0D+4bFqCOKCaHUrxWKvlo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RV6rcbcB;
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-56a8e0ea02aso7290763e0c.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 09:45:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778777122; cv=none;
        d=google.com; s=arc-20240605;
        b=buOsjArCw0PbOs3FUScoVNKM1kgrVvILtrh7hqZqiA+m/6uockHvEMEgSpOdB9Giv6
         Inqtr+MJ9yJbqG9lkZU6Gj8M4uL0cxdCecbYdUfsdDzU43chu9pz1wmNoALtcdi2rqM9
         t+4lj5iNBMEofcdT10dXsL1pRJ9NVC5MMoVGHp7dzVRmi5r8ZF47JcqdVaV5VmHlbby/
         zr8q4WItYJ8ROsoxdnFVrqVZduchwKWCkmFBzUQTvOpi5KT3t6YCMUAGDMzAV33tWQnT
         9E/hx0d3AwNUc44Q5f3wXCMLR8G+yxz+FwIZeYzPFW5W5IpaMAWLrTy00kq6fm6gg6xW
         Kpag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=os0eHsZVJX0chVl1RmCC7RjaweXl8YpOUWjuIOShXWI=;
        fh=AAyHSuV2PCQH2t58iy0VVR30j/UY1zm0PgFHTLwVQbA=;
        b=MfnyYqDET5/V48I57AvTZEzRfbxw61lZ+Fhn6q3zQRNh559sljAunS1qynSoCxkc7M
         L2/ouc8Qw2hNwtGLLf70BNqvd0WJzDERiZaNp6/Cmis+wVk/KMXDicwYmuMb2TVkFApk
         2XyBCcwEwXRHgcodLhdSx5eYGDAq5dgMI12c2DEE34Uj3CnV0HmGfHXMoVtcUTfWPUux
         4xkhj+qLT78Ve4oE9wV3JAHYvpy+ygGaFzWkLOtagwO6S+ZiPHUzE7T+nCcBO8uCiso2
         HPDGNWaow9GUnIeRRvyYn7VCz+sJpVinN+NF5DWan6eaPSVP7OrjixhPITfJtNAeG0ZZ
         XI4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778777122; x=1779381922; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=os0eHsZVJX0chVl1RmCC7RjaweXl8YpOUWjuIOShXWI=;
        b=RV6rcbcBZQiDPrB5QOfN5FHboqzApf/sJaExq7IFnMz0QfPeTqzb6LA4OiDydvu8vU
         sW5aNP2LDduzpPkDUw+IPF1BluvC0YiTHMZzUHj6fyzIe6rUnO7hXQSV7iwNg9yVFlGZ
         JZywHBHAj7OeVa/0MH/IGDYGcaiZJjYSmUbeIBfvBqRF9BkLaInqIa4xHYNNCktXOKhX
         WWP2AraYE1VfplecohzkWK9PIzXsWCxB+tUm0qLNTlreZ1WUjujIHJC7g+KSz+W2/tn0
         Ayaa3ZhKyVLakSdClxni4WtbmLttAo5UAuvVwn02oV0wnxCRqLhhp22ml4w2aU4pQ/ww
         jiHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778777122; x=1779381922;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=os0eHsZVJX0chVl1RmCC7RjaweXl8YpOUWjuIOShXWI=;
        b=rAoCP6m6dfhWOEaKzqOUic9g8RCszMn0BXWEeXivdCDQW1QTi9C86iZilGwDK54LdI
         7NxGH6HWXjy1lS9vOP8lV1mBKp/i8BefZtTYXTd5belMwpwS0dYf6typPE1M8siZONpi
         XI58GieqJc09WsFF2zuApNc4eaYnXl/EOAM1gfZrMjOCyCa/fCuBXiAXDhdX8AAz907R
         rBnJbLk5lc81wXTQ66/meQ88JFv4tlyz5V6SaiAY73aTPBbk1i2C1Fgo6a7VYON6VQ5i
         xPAFEqGQZx+MRQVr2UOotqC+gwTbSC/hrrhdJXARjLCl5L7rNbWZ5cAhLjJ6uvxAatj9
         CfZA==
X-Forwarded-Encrypted: i=1; AFNElJ+ouRfXazpwcwTN+L25UsQV/nJm3pSNpN8QM1RRG8lpU8Ru34W0t1NJZz+5OoLosuG+ri6IN9iSFg==@kvack.org
X-Gm-Message-State: AOJu0YxWnrXFDdaDWlhm9VaAv2Xe7cE4qUoSpMKdz3vVXqTn9+UOu4Vw
	Q94AeKFbtf4sXlMwU/tCu795yET6RkIvic9mtp6Je8BQOyJ7zuahevfTZpuBbjG8DFMZhKs/G6B
	Og3xKj1afs5q2HKPzApXDsO0Q9hfxjI+Dcb4eyNCE
X-Gm-Gg: Acq92OFsFgaNs6G7j89yqM1jth5D7GuG1zdlu+XwA/HBJ8R/IYUqy6rwoKcvOHVyElu
	9KVUqqaFzIHo3a8hc//pTQzTFdzu7ZG/GqpvQtfZx5xNee72sv9FILnPyYfSt01movXGwFZI9ye
	Rffdm4l4WABoiywZ0JX6s2HLR2XuBKYJn5mULqokV97mH5kyFavUNXf3q2qHDl89QU8iM13gYHi
	baDcl/X92Lke0rtJrT1cEwU+Pf3oxHt8rE6O12ozPL7uFTwGJb6Q9SDezlgOmHmmEUk22xpXGEh
	A3UtQe+N5bYfkaWvnFEQBJRVV2bPUlLJb+RKcBdSS00i3SZLHPcrteaKj/egTH10v3gLug6E61T
	H9gyq
X-Received: by 2002:a05:6122:1814:b0:575:178f:62d2 with SMTP id
 71dfb90a1353d-5760c092d3cmr165926e0c.14.1778777121451; Thu, 14 May 2026
 09:45:21 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 14 May 2026 09:45:20 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 14 May 2026 09:45:19 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260508081812.12345-1-itazur@amazon.com>
References: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com>
 <20260508081812.12345-1-itazur@amazon.com>
MIME-Version: 1.0
Date: Thu, 14 May 2026 09:45:19 -0700
X-Gm-Features: AVHnY4JqumP2VJstFZ-DobQ0sDmpWwtOhYCl663Ih2m9TKxeTUM0glktONR3Yps
Message-ID: <CAEvNRgG07EMrx-SpMaO3gHmdGVwOb75XNy7_RARBo0chidn7Yg@mail.gmail.com>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
To: Takahiro Itazuri <itazur@amazon.com>, fvdl@google.com, seanjc@google.com, ljs@kernel.org
Cc: Liam.Howlett@oracle.com, agordeev@linux.ibm.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, alex@ghiti.fr, andrii@kernel.org, 
	aou@eecs.berkeley.edu, ast@kernel.org, baolu.lu@linux.intel.com, 
	borntraeger@linux.ibm.com, bp@alien8.de, bpf@vger.kernel.org, 
	catalin.marinas@arm.com, chenhuacai@kernel.org, corbet@lwn.net, 
	coxu@redhat.com, daniel@iogearbox.net, dave.hansen@linux.intel.com, 
	david@kernel.org, derekmn@amazon.com, dev.jain@arm.com, eddyz87@gmail.com, 
	gerald.schaefer@linux.ibm.com, gor@linux.ibm.com, haoluo@google.com, 
	hca@linux.ibm.com, hpa@zytor.com, itazur@amazon.co.uk, jackabt@amazon.co.uk, 
	jackmanb@google.com, jannh@google.com, jgg@ziepe.ca, jgross@suse.com, 
	jhubbard@nvidia.com, jiayuan.chen@shopee.com, jmattson@google.com, 
	joey.gouly@arm.com, john.fastabend@gmail.com, jolsa@kernel.org, 
	jthoughton@google.com, kalyazin@amazon.co.uk, kas@kernel.org, 
	kernel@xen0n.name, kpsingh@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, lenb@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, loongarch@lists.linux.dev, 
	lorenzo.stoakes@oracle.com, luto@kernel.org, maobibo@loongson.cn, 
	martin.lau@linux.dev, maz@kernel.org, mhocko@suse.com, mingo@redhat.com, 
	mlevitsk@redhat.com, nikita.kalyazin@linux.dev, oupton@kernel.org, 
	palmer@dabbelt.com, patrick.roy@linux.dev, pavel@kernel.org, 
	pbonzini@redhat.com, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, pjw@kernel.org, prsampat@amd.com, rafael@kernel.org, 
	riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, sdf@fomichev.me, 
	shijie@os.amperecomputing.com, skhan@linuxfoundation.org, song@kernel.org, 
	surenb@google.com, suzuki.poulose@arm.com, svens@linux.ibm.com, 
	tabba@google.com, tglx@kernel.org, thuth@redhat.com, urezki@gmail.com, 
	vannapurve@google.com, vbabka@kernel.org, will@kernel.org, 
	willy@infradead.org, wu.fei9@sanechips.com.cn, x86@kernel.org, 
	yang@os.amperecomputing.com, yangyicong@hisilicon.com, 
	yonghong.song@linux.dev, yosry@kernel.org, yu-cheng.yu@intel.com, 
	yuzenghui@huawei.com, zhengqi.arch@bytedance.com, zulinx86@gmai.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8E0B01A000C
X-Rspam-User: 
X-Stat-Signature: zxseqjegyqadwyrhbjhufiy75be3rfff
X-HE-Tag: 1778777123-576485
X-HE-Meta: U2FsdGVkX19BzSE8aqSCT6ztwmwURznA4xdhBubuMHcYYRKb28yIWjqZTDt5tPlfgGlQQcVTi+GueBkygSmYti+CTsoqwXEHrwJZRRhq4sK8c2xYz/g5CQ7EZ/PwF8UGUdw0yhF4VXFyUExjqHghDnxTdgnrrTmAkvbgJCDD4vIcA55jUR5WCdWBDy/ScFgGMNXyqlN8A01sAUQ89i16n4EF+dzdSV/+rZlgrqzz0ABtHSEiEhyTIVmLQ0m9XWhL4lBhU1I4QZXbZpQ+/D3WgxpIhou0r3k7Q2dMJ7Fcil32hQsrJjYWt0HvXSDzJr7/m9a1gw6baPdJAdKW56VSMdh5ZdvFqRFPhveji9AXGV6MAjSEjfdxb+is2lvZPkzM+CNmSB6pP8KiyFbcT+/fWObjPXlA1N3/ru/uTbg6vHuo3SdTLgaYVb++wGwikYx0Rtk+jOC/YmDPsykWSao9gTcI4esU/vzjaDz1VW7zoUlg9C167ogE01Qe3GzkJFz/ABE+kCnhYSeIEdK1MbWoNGodWrMZwV4ngGeGyOCQY/HF6047SIyAMUtIyrWXbedD0tTGpqnWEGr7gFaZ0gd7RBpAFLYF85ITqdi5+5OyOuJLGHFPy51sf4nC1e/YwileOwl8s2O1391YKEd2tDZVHTF21vySD35ieIu49PO/rPkat9pZHLfRI1cAn8cPK4S1FkHHG0ZiMqByVPV9L9lus/eyd1hNWfrJCY+gfUb65a8a7Wq6wZtQK8DMSyf6PO/zO1Svzjil6bFhFwiDDGQX1hJRAEchQwS/zlq0VO4yFuPQpWLci+tAcCDvVvA4IZDWiOY1lI3py6i5YSNRhaKALGLaoLP1CdvGyIygElVVQzIzFlHNS3G4y6mZQJHkyNZCyyj+EsujBo8IcxPWaHXvigz7EfpLxRqEPQpDcxV7D8fhAI2NaFseTWMwEM8rhr7GDC4VfGMCixNIM7G1l52
 55g73gKw
 BvVD58/RH0b1WH+++Mzs64fK2ALs9DRNQXfXD658NpTtavetf6F9hKxX9lZVbEC9zVlYVDoIwSnFolfKiIQaoW3duOEP56JF3FfjFrm/egDV/hbuX/0Z0XvZOU0IVPXuWzrMtNRL26JGxz58DelvkOCV1RsZp42YOmr6WJH4VpKSiQ25zbSFRatQOE8y4MeBgV/J3CptXCMuuebLIHg5ECW627sDWMWnV8ujR3zRrE3P6nfeXZKkIKCOteVsvOLdj73WwFmHim0PDPXmOucbCPB1kzANid4macGXqnKH7yg61qp0JCJY90rfWGxxCSubh/YpOohxomGJSiGXxZM1cYLY9nk2iVB2kb7t6OSzaUZ99MenCUunAYNafbRTshfiRDLKIyPnFuu/RMSJUYH+UzBOXnRRlO9qkYrI3w99++ug5tkVOyOxbEVGDtvXT0M2AWGihcmU0SAcnf9cuzpAICYqVpU+D/05Q6mG0T7MlxW82wfs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Takahiro Itazuri <itazur@amazon.com> writes:

>
> [...snip...]
>

Brought this topic up on the guest_memfd biweekly today!

>
> Agreed with both of you.  I'll adopt the filemap-level approach:
>
> - Move the zap/restore hooks from guest_memfd into filemap_add_folio()
>   / filemap_remove_folio().
> - Tighten AS_NO_DIRECT_MAP semantics so that, for folios in such a
>   mapping, the direct map is invalid for the entire time the folio
>   resides in the page cache.
> - Drop the per-folio KVM_GMEM_FOLIO_NO_DIRECT_MAP bookkeeping in
>   folio->private, since the existence of the folio in the mapping is
>   itself the state.
>
> On each guest memory population path,
>
> - memcpy-based population from userspace goes through the userspace
>   mapping of guest_memfd, not through the kernel direct map, so the
>   filemap-level invariant doesn't affect it.  But this is slow, which
>   is what motivated the write() syscall support.
>
> - write(): meant to speed up the userspace-memcpy case above by doing
>   the copy in the kernel.  I believe Brendan's __GFP_UNMAPPED/mermap
>   work [1] would give us a low-overhead way to get temporary kernel
>   access to an AS_NO_DIRECT_MAP.  Landing mermap may take a while, but
>   this series does not introduce the write() path, so mermap is not a
>   blocker for now.
>
> - kvm_gmem_populate(): this is a TDX/SNP-only path, and NO_DIRECT_MAP
>   is not available on those VM types =E2=80=94
>   kvm_arch_gmem_supports_no_direct_map() returns false for
>   KVM_X86_TDX_VM and KVM_X86_SNP_VM, which are its only callers
>   today.  So it doesn't interact with the filemap invariant IIUC.
>

I'm a little bit uncomfortable this statement since it seems to say TDX
and SNP aren't taken care of. Would just like to discuss (for
a line of sight to SNP and TDX support):

For non-in-place population where the source physical page is different
from the destination physical page,

+ TDX: the TDX module does the population and works with physical
  addresses, so no issue with populate? Other parts of TDX may have
  trouble though, but that can be handled later.
+ SNP: sev_gmem_post_populate() does a memcpy() after using
  kmap_local_page()

Would mermap be a drop in replacement for kmap_local_page() here? Would
guest_memfd need to force a TLB flush after mermap+memcpy?

> So, unless I'm missing any path, adopting the filemap-level approach in
> this series should be fine.
>
>
> I'd like to consult with you folks on how to proceed in advance.  In a
> separate reply on the cover letter thread [2], Lorenzo and Sean
> suggested that the mm pieces should go through the mm subsystem:
>
> On Tue, Apr 21, 2026 at 04:36:00PM +0000, Sean Christopherson wrote:
>> Yeah, when the time comes, the mm pieces definitely need to go through t=
he mm
>> tree.  Ideally, I think this would be merged in two separate parts, with=
 all mm
>> changes going through the mm tree, and then the KVM changes through the =
KVM tree
>> using a stable topic branch/tag from Andrew.
>
> I see two reasonable paths to get there, and would appreciate your
> input on which you prefer:
>
> Path A =E2=80=94 validate on KVM side first, then split:
>   - Post v13 as a single series on the KVM list, gather feedback and
>     make sure the design is acceptable to KVM reviewers.
>   - Once v13 looks good ("the time comes"), do the MM/KVM split,
>     rebase the MM part onto the appropriate MM branch, and post the
>     MM part to linux-mm to build consensus with MM maintainers.
>
> Path B =E2=80=94 split early and seek MM consensus in parallel:
>   - With the filemap rework already in place, do the MM/KVM split
>     now and post the MM part to linux-mm directly.  The KVM part follows
>     on top of a stable topic from MM.
>
> Which of the two would you rather see?  Happy to go either way.
>

Vlastimil pointed out that there's a temporary limitation now that the
mm-tree cannot do stable branches shared between trees now.

I think it depends on how quickly you plan to refresh this series, but
Path A wouldn't be blocked by the temporary limitation.

My opinion would be to go ahead with a new revision (Path A) to fully
address comments before splitting the series. Any Reviewed-bys can be
carried over to the split series anyway :)

Alternatively you could wait till conversion lands :P Either one of us
will need to do more work for conversion wrt direct map removal.

>
> [1] https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-0-28bf1bd=
54f41@google.com/
> [2] https://lore.kernel.org/all/20260506080753.14517-1-itazur@amazon.com/
>
> Takahiro

