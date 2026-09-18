Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B95CC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578A26B008C; Fri, 18 Sep 2026 12:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529AF6B0093; Fri, 18 Sep 2026 12:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418796B0095; Fri, 18 Sep 2026 12:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD9C6B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:21:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C533CA0179
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:21:43 +0000 (UTC)
X-FDA: 85227398886.27.048C4E5
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf15.hostedemail.com (Postfix) with ESMTP id B177BA0006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:21:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QHRSPWuW;
	spf=pass (imf15.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789748501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0idDGjqorNV8cxfogOvoluFO0wsP95B4F+1LnnDxZI=;
	b=eScg4pSLCDdDCH3lTfHye0B8aG0MKuiICtZHsF2pealG7hUslydNZd8RgD8m3W1rj7jUuv
	nRwJFk1eQJ35pxzlXYU8LOzqqyyMN38kGp2DFRx5CruexoMptJyPR54r0/VaIa1mI2QXn9
	rjj6/whiEMNUY8ak6TbMoTP+KUkvi2o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789748501;
	b=bKIzyKRol7UAQa5ek7xo08lQz8ZeJvOi0J68mGv3WvtB2wNbFpFPwvgqdRkGMGnOc0ZN0b
	giuMFO5FD0hLv41uPUjEQa3Tt+7XPgnALb9AxO5hpcHP0FMRg1ClrHrQrqaoQPJXDfI5Pk
	FONSSn5EVB7lV5I4+QtztVq2LcYNFzo=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QHRSPWuW;
	spf=pass (imf15.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-912355b1bf6so3495996d6.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:21:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789748501; cv=none;
        d=google.com; s=arc-20260327;
        b=FMLxFdzC0sDB6432x+hvPCldNJyWhLafRPF0l96s9WyDwkFSnTF7tb2QbHQMFLaxTq
         FgBVroC8crZ+6/jkIMrMBZkT0nelKb0bt7ApIPijLF+Xl27YkuSTU9XASQD2rwi+ruu1
         BixanlLX+1R5FlPQo0PvFxrFjL9CkxDqM1aBTd/5fFFx6dX8k2Cljp4MogqBVBybf1iw
         /h4fzaMCf2jfPhqgokxyl44SMfQPBfDD40Ea8s9NhNwliF+Sdc1B2gq4L/g0Fi2CnOwc
         KobowqBlq/5tTCimF/RHZygqkI/TcY5s7x055NOv6l0ugfX6TxpJqalwDSjhYqlfEYb4
         6dfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=k0idDGjqorNV8cxfogOvoluFO0wsP95B4F+1LnnDxZI=;
        fh=AI4C7LaV2TnezAk61DGdF/c9jm0djNyTds3SVaXipAE=;
        b=ol3OCz4ZCGJ2PPAAEHISYL+hILcExJ8U2S4nQFX9e032dS4BvYUttkfesM4T3FVci+
         fuGI6ytvXgjJEX9nsfQFexGlTc1sJxgFP8d448HB+Uq6lDfpYch/QEq4UIXzDf/698/M
         CeMD4UF2WKUdk+jYrJ2kWSiO9XxdZZ5fg9FwKCo/b2ovKoRs2DwMIGVzuOGyVoRY4cfa
         t70ryS27L0bxUbDZ4eSFj7eD5ireIePN6O/AzANBZx/rC9/ta1IUuuRhjlO8h7PCXh0g
         mQqfdcvVaNRtnImS/OR0hl1kyUnbn/pNoqXFpTPRc1WPpbDR64th3ZC0ZWGdsJn5TNTd
         H2Sg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789748501; x=1790353301; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k0idDGjqorNV8cxfogOvoluFO0wsP95B4F+1LnnDxZI=;
        b=QHRSPWuWI7g4Jq48AtFifPJBfuIFQn79N4IGah18Q/A/CkBFEJDjPOHfXOn3EjYeqF
         9a1Fl+Nhfj8y/B69Ef+RPtLPPRO8JFT3lkS7TFp05aNrg+Jjb80x/lWSOUGl9C1SYL3b
         5VGRv9beTLchXdq7z+LaiQiXv4cD8Dnt0xTl7CX/nzvvHZujNUgpE3wQVSMk/s+deMXp
         YCqw4kffPN10IgC949tAbfN9eBjCPcp+bYVkT6CjhLflqH+RSw9f0zIPVzJkLb6kQ0Iz
         elH5WAbY5RgKxJewAW3h8s96316Dkkuxq8n1P4YUqPa/mq3iZIqgAMJ8fX+jc3grQ8yL
         Xwvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789748501; x=1790353301;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k0idDGjqorNV8cxfogOvoluFO0wsP95B4F+1LnnDxZI=;
        b=gnDVlD2VP3U3CzZUBT6MjEK27xKf3gguV6nxyyTNhxYfBRYW46xJvEXpBhx7JK2JFL
         ukDHnVwOsDxbobdEcIMCgsh3trXXJQV37sfFNkdR4oJCA6j8Wr9T7XHIl8/v3yHJMKpW
         OHeRg8crlOJ3m8LOttFDLZnx/U/B+OarfOoICiVcpbjKLNR2YDGck8ANlxQJp0H3KOkT
         UYnT3ZiJcLZYMnuKd2d5LB0Su/xSvMFq8joy1d1ByV1W9FLExKIzWqr+RLi1WHQnxZw2
         JFD60inddHj7kwEA3C3mMPLIYYE8zhu+Cssb5GN6DENQuvJ+pdGxzR9ZICUbmB2bdRYP
         qiwQ==
X-Forwarded-Encrypted: i=1; AKwUvBx3CUHwiRdft446gCRScXSdQM6tIGi+mktdNmKfAoKDOyow1Yxp6oyg5pwY1w0Y0t9TK5iUps8VPQ==@kvack.org
X-Gm-Message-State: AFuF++nTGWcubuP4DYYns0y6ZqKl57XMgnvCinS5riovdANJVvIklJQw
	G8VzW7vH5n4R93ftc2Cej5Bw5p/e1Y04S8kEIF/s+/RqngWHDGWstTqCoIfuc50kI5gxiHirfcb
	VtbmRzmYUbMt8RhqG2O6526kk/+JTbr428rmSFEd0
X-Gm-Gg: AYBFou0IJOJ8mWGY9ILsIRsjPw3RIsVSb8W5zwVpX98gu6oSzY/38q77ehNAZxnIP7w
	Q9+NG0OpotOw/UVF8Xeh7FRkJWRgLTk9Tc2XjHolcewCBHSZJiSgTBrfoi/VpPSFGCooKS+bW48
	PSlObvIm1nrdXOsqFaxy+sbz7kDsL6N/+j+xSuvWXLVfz03slzs1fvvup6y66D4AW0aEqeOJKcF
	siDtgFnwwmGXEJh2rRHC5ruZlAhLPt9eP3F2XOL+D9o+gr2nBaKC2PjVOmfvhWlyHW902mNm4c9
	Va+rLvUsBJJ8X12cTYgyuU4hvfMXpOCHFRJ4cj4M5UWnVYBrKpR+simGkg8QDK35OmYuTs5NRQ0
	rgxQRFL+qKK7fiE8VxfIA8S+/Y15ANbWA9aZnhP4KLNo=
X-Received: by 2002:ad4:5421:0:b0:912:3b29:6580 with SMTP id
 6a1803df08f44-91254e64effmr32593386d6.7.1789748498548; Fri, 18 Sep 2026
 09:21:38 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 18 Sep 2026 09:21:37 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 18 Sep 2026 09:21:37 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <e4bcc676-34d3-45ed-9eda-51c9a60e977f@arm.com>
References: <b91dbfae-20f1-4b9f-a25b-4397afae80f9@kernel.org>
 <16ffff40-4ef0-4312-a700-348603f05c0c@kernel.org> <CAEvNRgGW_VHmT82q+bUqHh_5G2Z9sUF1jJOTiVN4Z8_cA9A50g@mail.gmail.com>
 <e4bcc676-34d3-45ed-9eda-51c9a60e977f@arm.com>
MIME-Version: 1.0
Date: Fri, 18 Sep 2026 09:21:37 -0700
X-Gm-Features: AcwNN1VzIl6ghPHchCrZF-oxqNdlGOgQjEVdlVOzWvyHTDDXwsaSi3qVUbQZQCE
Message-ID: <CAEvNRgFAL6qtSiJpQuga_TxWBr2pK=9LoiON+ZARMp0xFA8rPA@mail.gmail.com>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-09-17
To: Suzuki K Poulose <suzuki.poulose@arm.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	KVM <kvm@vger.kernel.org>
Cc: amit@infradead.org, aneeshkumar.kizhakeveetil@arm.com, 
	ashish.kalra@amd.com, dwmw2@infradead.org, eberman@quicinc.com, 
	fvdl@google.com, gshan@redhat.com, jackmanb@google.com, jackyli@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, kas@kernel.org, 
	kevinloughlin@google.com, liruxin@google.com, michael.day@amd.com, 
	michael.roth@amd.com, mike.rapoport@gmail.com, mvaralar@redhat.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, patrick.roy@linux.dev, 
	Peter Xu <peterx@redhat.com>, pheragu@quicinc.com, pkondeti@qti.qualcomm.com, 
	prty@google.com, psalian@google.com, qinkun@google.com, seanjc@google.com, 
	shan.gavin@gmail.com, shivankg@amd.com, sidtelang@google.com, 
	tabba@google.com, tatashin@google.com, vannapurve@google.com, vbabka@suse.com, 
	wyihan@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kqerhf5kpop3k4gbsxbw7h17empo6bq6
X-Rspamd-Queue-Id: B177BA0006
X-HE-Tag: 1789748501-423601
X-HE-Meta: U2FsdGVkX1+vTtAUdMC9hvyNiRoTxBQgnj5jTa+YGtjzuCzTHWyu7NX344CF/0MQ7KRyU+uuOTAGXIoQ8e13799CGqN0lhMlobPqFBiISCvH8h7a20SB7c3om8BIjzxvTQ2zodp9WyAC3cLvpV4h++tzN4ILh8iBTXZoWW1zkeumuKuLD6d4sfLuGW9a62q05ak/nigfo5+3w1HwX/ITUgbNpqR+tMY6qevXGiGzdjsAn9UHWP52ps4ktAz9e4IzdvpHHh/kmtRJAjY6hzXFdHj3QMbDzBp1R6f9Ave7G7ZIHg8jF2kuL28WlsJbiCHochJ16rqWBzM1S7786SYXr0FIHbsLykosAuxzaACAfBeLkS+IHFhxlzS5FQnuxzaQB1lZ4WtGiMPvupM0+uWwPkxhXXuc4xwyLi4Vzr0pDcx5d8gpTxuWXyv1RsoP4zQMHDE7UNIku7TMUtfYUyDcJDjdIr0xJKfmsRfHUa1ltqDmJYYfFHGf8H5EbOGV73ZYauczw43QKrgOrPrayfl7XcvZMqoXe7KUmWivkiOmE6Pdm1cd6FiBBvVs5zpl2V6qjKFZ39meAJi8RO/0GJL1iC8huX3qPiPhbBC0Ada/DwcFTMuauw0B+qXFHijfKW6QQPz6yEGNzn0tSts4JV6RqSmQuNFHd+Rb/4yKbbYrO7Z3UJZFRwx0e+Tg/p/Fx/bjsxh8V1IhFlXHW+IXGZJfKvSvnOEqrIhUcd5XbQsSM2Zs1ADFxHuBUsPxzHXn6bPfK0cRDX0OVjI9/TSiJBdUYyXLpuW4g89dlrUVTr0R8FbdchTiPWAyB7xGhj+zfhV2QLCoS+UsBdMYiNfoCQVjJvBdUgGmCtKk4lRP7ln1NESs1c4k9wH4qC2KHcwmP4U6EF9BNdR5e7sOEqG10gvSkrGcxa5uzWi3HgJKi6ua928KZqebQxDtGdruhJ//5GCKbvahyKk3qSycPNZ76AK
 pnKpC+9J
 31/eWSGK6MPlyh64vUmy2Gk25bYHqhcHq+/iR0NO+BIiu0E9uvazRC5ob8D14LqrUTfFULsb1tTx6dnpDCDMlniXA+KWqWRUfw5UPEpMTsJCtdeTt36UAYjhAXWnIKPnckpFjUBchRqbREv11Vai072rrNAtRQ5i1BxBU5JwfT5hTZpPSpFvpRm1AfkBLGfSpDnZIGgkm0B1A4eyaSiXrzpS3RVgODJp/r/swSnaf99JCBzgV9Co7mEYS7tv+rUcERaPfl+xpKIkKu/YtjQjD8xLVCTEkXOeWF50hpwi3ZBTKbDLgxD0SOy/OK48azdaP1ZF7vEdIhBrawhhkLoSG4KFKequZK4GAplnL8gE73qVPuB2pawwI7FJhBo8s9b+W4XH5btyQSkRrR1cNDlgaVVlaDoK1LgnLHUAiPjpC3kOEikzBw6H8yJ24RitrpNLgTCdaVAUdqvG1+PLeFycVkZ3nFXKcRYt8VM/ZS5yitKUruJl5HIvy3O6g19zUl4BYEaer1Ob/0ADvU6Y0OqVU/yAX1bkFDmN31s//kTgb8sU3xLOi8/cAindUPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

>
> [...snip...]
>
>>
>> RMI_RTT_SET_RIPAS() is actually saying "host permits the conversion from
>> base to top", it's not telling the RMM what to set it to, this is also
>> different from SNP.
>
> As mentioned above, host knows the requested "RIPAS" from VCPU exit.
> RMM knows the "RIPAS" from the VCPU object.
>
> Now: Privates vs Shared is translated to RIPAS_RAM vs RIPAS_EMPTY
> in the CCA (well, roughly)
>
> RIPAS_RAM implies, the GPA can be mapped into the private address
> space of the Realm and it is integrity protected. Host cannot
> replace the GPA with another content (it can unmap and DESTROY
> the GPA mapping. But unless the Realm consents to replace the
> GPA, again via SET_RIPAS request).
>
>
>>
>> Interestingly RMI_RTT_SET_RIPAS() also errors out if the current
>> shared/private state is different from the one tracked in the vCPU
>> object in the RMM? Did I get that right? I'm looking at the base_align
>
> Correct.
>
>> Failure condition, where it says ripas_pre != rec.ripas_value.
>
> Please note that, in such cases, RMM needs a deeper page table level
> and the error is RMI_ERROR_RTT, indicating to the host that:
> Look I need a deeper level table to satisfy the request.
>
> e.g., base = 4K, but walk.level = 2, and ripas_pre="private"
>
> i.e. the requested base is mapped at L2 as block with "private" ripas.
> If you want to convert the "base" to shared, it needs L3 table. The host
> would follow up with RMI_RTT_CREATE and then retry the request.
>
>
>> If two vCPUs race to convert the same range to shared, both vCPUs would
>> have rec.ripas_value = private. The first conversion would be fine, but
>
> nit: rec.ripas_value = empty (shared)
>

Sorry that was a bad mixture of pseudocode and constants on my part.

>> the second one woul see ripas_pre = shared but rec.ripas_value = private
>> and would definitely get an error?
>
> rec.ripas_value == empty (shared) as per the guest request. And the RMM
> will find the state is already "shared" and would confirm the success
> back to host.
>

Oh yes, my bad.

base_align says (rephrased)

  if (!AddrIsRttLevelAligned(base, walk.level) &&
      ripas_pre != rec.ripas_value)
          return RMI_ERROR_RTT

Is the alignment check to do with another vCPU splitting the record in
the table?

Why compare ripas_pre and rec.ripas_value when the level is not aligned?

>
>>
>> And there's no "accept" step in the guest after conversions, which makes
>> it different from TDX and SNP.
>
> Correct, the guest "permitted" the GPA to be made private with unknown
> contents anyway. RMM guarantees that the "data" is scrubbed when the
> GPA is made valid. The advantage with this approach is, once the
> Guest sets the RIPAS_RAM, the host can lazily donate pages at
> fault time
>
>>
>> Difficulty in using current gmem hooks that SNP uses:
>>
>> * .gmem_make_shared() called from conversions doesn't have the vCPU
>>    context, finding the right vCPU context is expensive.
>>      * Sean, don't we already iterate vCPUs to find VMSA pages to kick
>>        the right vCPUs?
>
> We could keep a list of VCPUs with pending set-ripas request for e.g.
> Or before the vCPU enter, we check the state of the region and
> do the sync with RMM.
>
>> * .gmem_make_private at fault time is too late
>>      * At the next vCPU enter, the RMM would already read it's state to
>>        report success/failure, and there's no fault in-between for the
>>        .gmem_make_private to happen.
>>
>> At the call Sean suggested mirroring the RMM's tracking in KVM, but that
>> sounds quite arch-specific and it's like doing arch-specific validation
>> within KVM.
>
> Suzuki
>
>
>>
>> p.s. Fuad, for pKVM you also mentioned that you'll need to check if the
>> guest had requested for conversion first? This might be the same/similar
>> problem.

