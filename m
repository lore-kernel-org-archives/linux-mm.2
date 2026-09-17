Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04BA3C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 18:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830106B008A; Thu, 17 Sep 2026 14:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0146B008C; Thu, 17 Sep 2026 14:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8AA6B0092; Thu, 17 Sep 2026 14:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 378726B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:41:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2D22120459
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:41:18 +0000 (UTC)
X-FDA: 85224121836.10.93BAF03
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf06.hostedemail.com (Postfix) with ESMTP id AD1C018000D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:41:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oY4E70JV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.234 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789670476;
	b=ksYPMU7jKM2HD7w7GwfQ14t11S8DqjSpK+A9yWVTyukN6kSRHJx3J8kraKhrfr/WOgDwWe
	MVGjwypEANb2+fLIzxWj3xFeMptU8QzeQV2HcMFWn5ZMKvOiWde1/kqYE1cXDwHfcl90Yl
	Pr7cnYVD05K5Dd4T+T7c3cID4uVsZic=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oY4E70JV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.234 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789670476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELY/Vg+05/1vgJL6X13+cNWxT0fSTrqi1KeBJiACBOk=;
	b=imnUjze7Pf5YXb/LLyRH5dnIX8+z9l5etzHoLAE6WsUUsI35YMjwPRM9lyzdTaUqb9SAL3
	pG1fOtaSs6Bg/dCZQF46P1MVGRUXfpqf9SfBnX8LcG4jx80kH5/fILT9x7JfGaHAlMQTmC
	T7kZJmEPHxCwoD+88dYyF264ZBeatyo=
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-530fa0716f6so13507151cf.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:41:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789670476; cv=none;
        d=google.com; s=arc-20260327;
        b=HMF/PbAzABK0Wjq8AqHGmJ5yDKHHN0qRCZHrftdGzg4qth8r+51hNJRGnz8MFFtdiJ
         nS/DpAYnwn4b75ue/45zWyjZW0Xc5imCNwppvHJQgkTJGMQRVdY2Jehu0ZVlo26DM45/
         t1J+frXO1RCyjSa6nc0I/guTW16mx0R39XnSyh+PZ7q22l9iXILrHqXgRsh/+BD0B40f
         kD6DtQnLiHhUZLwhf1w9wZ4AEA6X9Sh8laZCUIQ2Okm5xGi+KysPh7zxVWqGGj3sWuoY
         q+xQJ5J8dPcnPzP0LHAGc+RuCIZUcKBbEhtHMjDVkZUkwMEVQs7tuYaZnH3pXbgbbynH
         4PLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ELY/Vg+05/1vgJL6X13+cNWxT0fSTrqi1KeBJiACBOk=;
        fh=ZPsqfq+Gy/Axk0+sheUKTyZORcWMPljWegL+kTHevrc=;
        b=V91DGwGsxmXMMXIrTdmEBFy80u51EfZkg/IbanyrAR+xhgl0pPG9z2JwuG5Xw1MUio
         lHzheZuYOvTLjutdXMK0HdBBqL/srUF3JRq86bakTDZNBzDCfiDBLo64kywWvtTJzthm
         TajR68zBktLLml1fIM0Fc8ewJu7RuqfB2fFjSUUWNXm5u/v4hw5Y3eaVVdjIImI1UN2W
         mr9O2Dd3Qo6wFGCJe6b34UQj4kweJaYIgpO6dzDABdMHLQ09H6E4ag04aKY9gTI9kvLr
         oSQ/Dqwfhzp6UtoXhG5tWOadP1AgJYPzEDg+HGs4X0Mf28NFLcD9NbeUUt+0hIZppZkC
         zYHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789670476; x=1790275276; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ELY/Vg+05/1vgJL6X13+cNWxT0fSTrqi1KeBJiACBOk=;
        b=oY4E70JVl2TzGi+iXA2u+0npxlHTTHm8J1AHwEr04AmSO1o+Cu9IzBBb5aREUYBADr
         OM6oNUlIiN2EM9Ti/usga69CeRMJ/4wBx7r7icEMjUu5iA94YT4Xq/wS7VHYj2Mtc3qw
         MBb5Y/Fw6vcjOm5nMknh226PzH0FEFm0z1LLvaDYflBvgmivLsgPbzU9N1zIrGKVJRp8
         s5KDyGFARTiis4pkzblNSBhaf2tWXytSpKKyiL+E2ufUP07mE6NgDzeAAgdn/0HYmDYL
         5huTHgzWxwLQUU5ZiOKZlIa9T2iXUqWu1h/z9S7KeE4n8LFqy5OIUl3bYHekK6L4KY8y
         G5SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789670476; x=1790275276;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ELY/Vg+05/1vgJL6X13+cNWxT0fSTrqi1KeBJiACBOk=;
        b=kaA9e4bnRB1fdX64PA+VEx3AxTH0j6Q+cKZRDfGDARlc5wnAd8h7MEWmnjPKUg6O/p
         QA+rJw1pOR16XlBfYjCXA95TIpeO+2Y+7XO2D2jVcTXRFzAX/TW08zKL7NS+8uZiYcLy
         HISaMpFa9l45sVp5ju0VC9OTRnkmRE7NCdCtVLNM78/J3232qOEWGBQ2eYbXyJCJ6Kgq
         12ZnLTLc5EQ7qyaU/TCvgR4ODjk1tsLY6NQ4duJ1YNeAB1cQEvR0xbOOWJ0Udj3JGBrB
         efWDBGWGf136hX+DPLg4fgVy4FS5xH2WafjPRCk6f33NzbfPQT4GYtiApP1CsE57RpTI
         cAlw==
X-Forwarded-Encrypted: i=1; AKwUvBxQEJ3KDOVtRq5bZNdOEQysaTNQT23w8CP1Ns+HfcScdUCV2KgoMWp+16liXlZSbU9mRExYs/eHvA==@kvack.org
X-Gm-Message-State: AFuF++mgOZShKis/WSU06y8MyQ4LE9M4uP87Os0NpFI/VypLF3HyWoLm
	4U5TjXKdhlodByy6XYXMEIiWVAoXMFqcLFjYw3J+4ElFihrEl75FMJYfE85Vx2U+cXP/5sYqreW
	xDOjlDptwrDhGFC0LbCbIQU2fMqZHSVkREqSXtCjyPbW6nUIaMs++sBZS
X-Gm-Gg: AYBFou2bg6KjP7AJ+c7Lh0+kLaPdNYeoYECRlfruFipkBQGtgl2hPbRIiOCExv3e2U2
	Eua8JL1AH/DEU3o2ASRHruhAaQpgLke4uApA+d10xo2LURc0QaS32jmM0z2hAMJG9sV+ZYrClrf
	Eml9t5OpdbOQb7CHBsimwxcGSTIvDw1UMd2PZBRCU2wf4hsFORxXDMh6NZZ9PkShcoJNLFr+Azz
	zaaP0N7qW2Pdw1Ytw6DXp0ZJVEHnLkPKP6vQxYb8psdx2Hc4RgiAhVX0Mk1UWx6/ogwdgWquyEf
	c9roIGiD4pZQCW/WwIEBcDtTZpSOJOnKHt7d8jK7e7Uf+W2PVnsoh8kteFqELvQ2zHYcncJnSmD
	1h5r+irKlJfZjGrpVPlCPN7nrYpJdx4V0AdmGvsFEO6ireOCaLg0P
X-Received: by 2002:a05:622a:6090:b0:530:b2e2:903c with SMTP id
 d75a77b69052e-5329e3d0db2mr1678821cf.60.1789670475157; Thu, 17 Sep 2026
 11:41:15 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Sep 2026 11:41:14 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Sep 2026 11:41:14 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <16ffff40-4ef0-4312-a700-348603f05c0c@kernel.org>
References: <b91dbfae-20f1-4b9f-a25b-4397afae80f9@kernel.org> <16ffff40-4ef0-4312-a700-348603f05c0c@kernel.org>
MIME-Version: 1.0
Date: Thu, 17 Sep 2026 11:41:14 -0700
X-Gm-Features: AcwNN1VH2wWa1-by0xZw2bG7z5QRI7gmGmYcIKbpxNe1NiOi-7X0KO0Bg2xGucg
Message-ID: <CAEvNRgGW_VHmT82q+bUqHh_5G2Z9sUF1jJOTiVN4Z8_cA9A50g@mail.gmail.com>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-09-17
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
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
	suzuki.poulose@arm.com, tabba@google.com, tatashin@google.com, 
	vannapurve@google.com, vbabka@suse.com, wyihan@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD1C018000D
X-Stat-Signature: 9pkshasihqg4rzep7ocqdj11xpfn5hqq
X-HE-Tag: 1789670476-971549
X-HE-Meta: U2FsdGVkX1+Id2x4yZSQza9HzPOlacp9og4LJgWV1ecn46A0FX61vpZvefF79knfjJ4eQrrDE7JA6itMbrp9ImR04Ux+hhT8wJVk6vTp4cM/kpfuxjuflZyAVjBsuJmNFgq2sZTG7tNrq18CVS04U0XTNc+ks0vcVmZNjQzx4/2apfHd1cOy6OvvKSQplXSIAmdZEjT+9CFmIndyhmsbXBe+MPYiLKppw4jh8jgmRZJaIpUHyqrsxAAn74VgH3ueqxqN3dui4AracdgOVVznJzq5tA8EqCoTFVfTsmGPeEJaXqplSEr1tHLH1UKFf90CGQbqCoX0olcO+toooT5QBjbt6EhRcz1BB1MxbUfJ/lxj8Ka8nDj3HgfC/+vNhKBFkNNCdxIb0A8PMXZF8gQzX+t4vTpZTYh5jWRacfXNBt4kCN0Djowew7iZvjTvpmv7h+hs1614TCyNSg50u95IvCacbmWmRDZ0RDmRqYKycpjzLrGDEPuZZQBibQLvBbWbNtG0j3/k3U2WkHONsjwz065GhkX1GQdmlBOxERJf8ly8rO/LQoScNYainIV+36Fexace6MPC69QZa37oHH8pZluMTENfDU3AywEcKOVttEJLfzxUo2LbTm3JTDYsoczaPTMlyIbv/XCzPngzWtoqMa0SPTuqB/+o6tPEQrPNhka0UK0l4Bm5uXvD3Mylv8HMLYspLmY7caArrWOAyKLPw/czzbv2emaZfENcyDL+M3TH7QIjO3KfQCAHd9Tky/XvmeCRFTj0fnn1u84U3I6iL9jhVJptJugZ/4WktKap/iK55j2bOqALCXvLyfNZJ+AKeTW2GK2xL99VG67wZ2jBQR2h/nWWe5Vg/ao8s91wo7HxLzFK2B72jbm5NWwesjGaZksZjE3TT5t7R8O87ntU/1rqC5cKLs/dZm9Ap+67WQCFl3UBwQJjZFikZV/vbaSmbIKAyVD22HbR7DZyv2q
 Xqp/DobU
 bSEC+bnKi9TsLqX0FRyIwoJEKc2vYGnQVBmNgD2SkQFKtTBagfWu6WL6HmYGOO3kwwz9P2FOe00YJxG2QIzP8Rwon1TkyVxCXwEJDh8Z5im/jpgHy+mw1VFkQwxMGRDE+Iy0bjvyr3Y6onYWrDVSTJg/mp76N8q8iosVmjld97WG9BDfhbQ4PBZVbDTpdioYsA2rpl5Oi8wI1xHClX/UIHd4gt3JaDCu0ijTlnhGhZqls7SpdncuhUogGoL1BclM1susveXKj3f0gVzHnaVfYa2IUvqJR7Fbeu/T9RUENfQ4tn1AUHIH9VCqU9sAVZ2KwACUvsRq9xAvYZ3PKuw3e1mZYVwrT2DEabMjrKMrG+VQsK9Vxfxnqb1dNqtJ/Z3BBdn+975YxhYjPHLc2VjtwrjWILTAvQVf9A0rgbEHTfPJyp4vsQuQYsoycNs4YYsRVZENW8Ko+NqwGNYMmTcay+IlhFeutMX2oH/Xk15wKjq9vuNh94CW2LOuUPRx2PGcjaonDLk/5DCE/CzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 9/16/26 17:11, David Hildenbrand (Arm) wrote:
>> Hi,
>>
>> Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
>> 2026-09-16 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.
>
> Sorry, tomorrow (17) of course :(
>
> --
> Cheers,
>
> David

I'd like to try and restate the conversion problem we discussed today to
understand better :)

CCA's conversion protocol is:

1. Guest tells RMM to convert a GPA range
2. RMM notes down, in a vCPU object within the RMM, the conversion range
3. On re-entering the guest, RMM tells the guest if the conversion
   progress, something like:
     + success, GPA start to GPA end was converted or
     + failed, (with some error?)
4. Guest can
     + Be happy that whatever it requested is fulfilled
     + Retry to finish the parts that wasn't yet converted or
     + Be sad that it failed and figure it out.

I looked more into it and I'm surprised that what I was thinking of as
"tell RMM to mark shared" isn't even correct.

RMI_RTT_SET_RIPAS() takes these parameters: rd (the realm), rec_ptr (the
vCPU), base (GPA start) and top (GPA after, or base + size).

RMI_RTT_SET_RIPAS doesn't even take anything about shared or private!

RMI_RTT_SET_RIPAS() is actually saying "host permits the conversion from
base to top", it's not telling the RMM what to set it to, this is also
different from SNP.

Interestingly RMI_RTT_SET_RIPAS() also errors out if the current
shared/private state is different from the one tracked in the vCPU
object in the RMM? Did I get that right? I'm looking at the base_align
Failure condition, where it says ripas_pre != rec.ripas_value.

If two vCPUs race to convert the same range to shared, both vCPUs would
have rec.ripas_value = private. The first conversion would be fine, but
the second one woul see ripas_pre = shared but rec.ripas_value = private
and would definitely get an error?

And there's no "accept" step in the guest after conversions, which makes
it different from TDX and SNP.

Difficulty in using current gmem hooks that SNP uses:

* .gmem_make_shared() called from conversions doesn't have the vCPU
  context, finding the right vCPU context is expensive.
    * Sean, don't we already iterate vCPUs to find VMSA pages to kick
      the right vCPUs?
* .gmem_make_private at fault time is too late
    * At the next vCPU enter, the RMM would already read it's state to
      report success/failure, and there's no fault in-between for the
      .gmem_make_private to happen.

At the call Sean suggested mirroring the RMM's tracking in KVM, but that
sounds quite arch-specific and it's like doing arch-specific validation
within KVM.

p.s. Fuad, for pKVM you also mentioned that you'll need to check if the
guest had requested for conversion first? This might be the same/similar
problem.

