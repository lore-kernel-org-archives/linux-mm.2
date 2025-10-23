Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2995CCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 20:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746168E000A; Thu, 23 Oct 2025 16:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71DA38E0002; Thu, 23 Oct 2025 16:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C778E000A; Thu, 23 Oct 2025 16:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50B818E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:02:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC91E1A0C60
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:02:36 +0000 (UTC)
X-FDA: 84030451512.29.572FCEA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60B87180006
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:02:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E2XGvs29;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761249754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4TTOO2cgFz3W+ccXXdCSitozQat0wJ24BVv7Ue1CUk=;
	b=ectfknZwfptL0U8wO0hX/eHUXW2lObyonaUvAYY9HNhqA2tLND+F0jVMW8GI6UVrx1EUmz
	y3L4IYak3V0/vYsKeAwf+kuRV2uklZARjO5ZESksMPLNyqAhWzDh0aGCwFChoDinBz3c0e
	k2Z/SFUKtyXh8cEkre2N32PXhJJbAWY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E2XGvs29;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761249754; a=rsa-sha256;
	cv=none;
	b=klc4lZmMXadt0GVRIHmUsDXwS6M5mTaXncVhuyGqNNjD3GeBN4JrntHC3ky/+/ZtL1E0CP
	AG5H0xLTC+3uyt1ueo/MtiiUFSuJGbkfFadhEm3/hKCTWfuM2CDWh9HjrGrZyAiBw9Pa1S
	BSSyFOxqhoZjbpD93pPCollkzQNeRi8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761249753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=y4TTOO2cgFz3W+ccXXdCSitozQat0wJ24BVv7Ue1CUk=;
	b=E2XGvs2959tlE5Irc7FxY3Kz5vPem/jgKlW0/qAtNOKQNCR7NELGDJD5+ix/sm5Wg5mvwn
	13+Lmht31QdnUsafjOImbOL+Z8hv2Zvt00e8tq4dx4AEGR+SaT0QBgKqVQyxly/I26eep4
	z+ae2Ga4vUDp3pIdJ69F8W7oxv7Tzdk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-Jdtjt24JOX2JXDYko0WN5A-1; Thu, 23 Oct 2025 16:02:32 -0400
X-MC-Unique: Jdtjt24JOX2JXDYko0WN5A-1
X-Mimecast-MFC-AGG-ID: Jdtjt24JOX2JXDYko0WN5A_1761249751
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471168953bdso14435815e9.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:02:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761249751; x=1761854551;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y4TTOO2cgFz3W+ccXXdCSitozQat0wJ24BVv7Ue1CUk=;
        b=Q6tL7oOPIBftIQtxDtitzW3Wlebdr2JEJMpxVOy8u/uz2EsWIWBNN4qx7qf8tgiTw6
         ozKMujFYzHhYsCwcZTuoEhjshWsM4gfNuMN5VcQyykmKzwoFFEJ9P67yAj84TJ2gnhIN
         AZyJx0YMgD6S3wWMoKtFn8+VQoEI6RAS/cwWJIQawGevg31n1bs2eC3EEWXP2J+IDUuj
         PhnegewtyhZkyt0SL3MRVQnBI2vX8nedHLJefNq9aQ74TIGjK+wovlLrIkISo39dG/tT
         c1B18JUduS53PXZdSMfw9cRXBMC37wcL863bA+JRNGccLB9Nk5nusKaQO3Q2dcTT9Sy4
         Qj3w==
X-Forwarded-Encrypted: i=1; AJvYcCXt53TMkxhebt0oJMg3TXNXe/CkAKtE3ut95VWSL4omM12oCudomA9JI8eobWUrHb1u71BwnpcdTg==@kvack.org
X-Gm-Message-State: AOJu0YzGD2Wm4uo7rSMQZkILkKb54mI1MJp57j0I7i17tcu9BTyGwP5t
	biZgC/0rTeR9mNE9+ZBgPwlHcO4AQadjQRU8iJ83dLtkt3rfSHcpmP4CuCBLmHMXrD1YPcrpJwN
	o8R7nZkWmLQn2eSGLaB+M8ni2EtLZI8qoR/JW8RZDZYEX3En4IIsY
X-Gm-Gg: ASbGncsqaAG4b5a6py9r6ruj+EDb6G9aTB5/Fkfye6lpdNd+5+q4lLK5wK1NEbBOuy8
	JQd97HKclVykzfz8iQJCCOqM2ZDeOtCpUXoxDpUnN3K8o3pC/TDaiaJMx3scpYDln5Hve8r/2LO
	jRLDp0uGjETLk3Jyx5k4duDIZ461c7ZjC2Em5tnDc1tI2mbRPNCjDzcQ5xy5aPP/YgqhfVVYT7I
	p9uiSObKWNKe924gmRFDvMiUVNHCJgCB4fWfjB3WaG1llYQBTCl/oN8ZTSli2dR5e57yaGopmBC
	r+DaacOMHSjBKh5mV9OeEaBvGFGv3SCQSIhHByP2R66C9nqkEFXy1cqbrM3iWxPEy10k4+yRKnr
	vgO1kOU/LCLzMoRhQEL8Q7tLWzfT1FpY8PTGRYR6ch9gSdw/Dv5iYPKsInF5pELritVpPSZQ0mZ
	bYLLE0+wJO3cSL9h8QnSAQQLACC8U=
X-Received: by 2002:a05:600c:1f13:b0:46e:3b58:1b40 with SMTP id 5b1f17b1804b1-475d24125f6mr1089685e9.4.1761249751047;
        Thu, 23 Oct 2025 13:02:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMw+Op04CJGmhD/YPV6zz3oVUY6+u4w9wry9vJKgjouN71r54k9F5kFdt15tjjDg/5cU58MA==
X-Received: by 2002:a05:600c:1f13:b0:46e:3b58:1b40 with SMTP id 5b1f17b1804b1-475d24125f6mr1089255e9.4.1761249750674;
        Thu, 23 Oct 2025 13:02:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475caea0468sm54964965e9.8.2025.10.23.13.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 13:02:30 -0700 (PDT)
Message-ID: <8d5243ec-3edd-49a6-ab51-16643a709d84@redhat.com>
Date: Thu, 23 Oct 2025 22:02:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/13] powerpc/mm: replace batch->active with
 in_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-10-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015082727.2395128-10-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dq_unbzhLl8S96zyRSVUimuXXU6RjrWefjucAZgPhyc_1761249751
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 60B87180006
X-Stat-Signature: e6mxd8nmbgkjpadttdgx7gbcpw3ntwp5
X-Rspam-User: 
X-HE-Tag: 1761249754-993144
X-HE-Meta: U2FsdGVkX1/GBtd56sIZt5m/CWYl8aChEDp/FG4FpUYSA3Jrlh9+TI7n3U6PEiYtzXc6GLEu5OPnGTqg3n4hIOBfqY+zr4bXL7Ab1D74MnIU/iuE3x4UEufYufMkrhYzOkIkvreyDgZ698I17DLb/pVy5vEVNbrElcLMqvI4ukY3GA+dvRYV9ERqohMrg6zfgTcBI1FGcBuWwW4iryR8gS1t7jkO2eX/zvv7XmjRb5TU8PGVl8uFMc6PyTCd1ch4ssFSDjdHfIiHdbs0Bux/4gBfLdlWrF8s6F/IR17jd5Yfvt8bdHxE3gZXO+rz0b7qIkhqDwjvx4PyeKaYgL1ZFquWFbJoaxt5qZENrECEaM/MljIjBKdt5M0n/cVg2JJ5i88FbxBjJeJmjTJp4fGLJFKQdyaJiAhBlHcxQpWZqT2Twxb94ki2lTzYkmqiUuONfScask++rqIQJkF/2Gcf15CL/XIoq9gS7/N7LOhTIImFLtlr6QejzQw6uCRne/b5N//qkqkgHZaHx8Se0kuUSVAk4LaF/iRIkkSroIQhuVN0dDOLmD2jNwwFsVuEzNelEAtPUhFtSWd5toiQzllKNHCxPG/lFZvDXz3kgrx9QxuBfEtbRJ9VGhnSeiBO33a/q284F77isFINIKuDvPgcVK2XnE41x+NquFvi/kmdDerNJKB+Dj1vTBqFX8rE6zjSEo21KPGKRjDRlG7FB9vPcBsdnNltOhKv40mPZwXwnNbb7I2hdJpPLAyYzRtzysSHU0nm1igcKy2pRc+7UV3zCf5ok0Vst6GBLOLDZnbCfRKnNDLIlPi7oAcqI+AtyTzHEkkGtg8hXBObfdoju/RP2So07qx9zGg1mIoN5x0bpOaLFz/T4+KtdrJWmoauJ7+O4YBkoabcDt6HhoYaFWdK/zb1kVWg/Y+3/369o9Ozi+IOqjjk58r9dbeHuubAR/WXv/CL548IsIgx0U/zPnW
 F/9bDpHv
 qfUHeOGj9F3+cx8cqxLtJ6ye4IJTKJRQa6tLPox1+somnbaSNLBTLp/p7QKVooYkt15vKwCHYxJxFlKGQrpLbvVhfbCNVy/0MxX4x2wOIc2Ryckz524SZVrWJGwOMn++02X4n4Z5cNerbhqgABZrM67R+cKAi/fT7VXlsIYcVNRSGwEXqhZr0fL3FUHAOtSpfPR0danFjVphnbVMJ2YshBeU8pWKZt6ikdZYHW+OVwBio2CQjk8F0/XSNfmYdaiuwModohGWoHtpxnkrAmZZjzivmlHxzXhSqjDNcxRYwyeTIyGAOErKMuGvSmim1iSAHirR/dyGut8rCZqhjDjqENULv845GSBTFjLGZR07IKYsMGqNXdfExQHK9UbWNleBklS+1bAQPjUOcUn3ettVWQwK6nQEnhTJy34t5HFncMaVmVbwNm37Pa/AVzBDvdKz2WJzF64hMM5mNG3v+jWEpB7/Y5pjZ7W12GDqD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 10:27, Kevin Brodsky wrote:
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode. As a result we no longer need to track whether the per-CPU TLB
> batch struct is active - we know it is if in_lazy_mmu_mode() returns
> true.

It's worth adding that disabling preemption while enabled makes sure 
that we cannot reschedule while in lazy MMU mode, so when the per-CPU 
TLB batch structure is active.


-- 
Cheers

David / dhildenb


