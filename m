Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F035CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 12:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32EA90006A; Wed, 13 Aug 2025 08:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0AD2900044; Wed, 13 Aug 2025 08:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A209690006A; Wed, 13 Aug 2025 08:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1B7900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:44:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 330095886E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:44:16 +0000 (UTC)
X-FDA: 83771702112.19.4A9DD51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3008C000D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:44:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gYls+iQY;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755089054; a=rsa-sha256;
	cv=none;
	b=WWoozy14S5eKmb+h11dizlVRUKy4XP+M9hCUr5JguMHEUkg6L/hWNn1PA2YkrWg0f99qQE
	ysbtHHL2IvjmkVlEsxQxZFzPlqqv2zB3YPXzDKOpdb4YfjmqdaOU8qjILg/ZDd4hFaKR4z
	n/VWb7Z9vBBKduD5bTsJeHu8/AmAC4Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gYls+iQY;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755089054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s25L18hi2O70MpXSnkBHqr0mgWoo8RG3piUOKoazP2k=;
	b=X11egDidkznkC+jvDC17OVqtBfy8Kt4HvOOX4GMjubnoqmp3ZgmqJSOZJXaAyP1XEeXXQe
	T1IvymXU06NE80Wn613Nzif/ttiyIGCyMoIyheoeKHma0vv3xpVV85eeIcCHSl/JgY1ewc
	xKnd/iASLyJBbmmRIR7dwrxR77BhZlM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF038601E3;
	Wed, 13 Aug 2025 12:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A6DC4CEEB;
	Wed, 13 Aug 2025 12:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755089053;
	bh=DDRdKzPeZcrqxhyOyBHNrCzLGb9zvR9HWqXptkScBTI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gYls+iQY+eTb+KNGGeRqRwXWo8twVx/emg3S4y0UYygbM5zO9NqHkKOoMf8oqlqlP
	 i5BoF7JCGyiO+dNBV43VNf06FoblMmDnfeIMsiezUIzZfEQos0MK5yNU6enaGQAXPc
	 tCsL8SK1kvYsw8aimFXHiMMAwSGXX7LDT6+1+LkNShDaUxJ3nYokKDBO3d9YFW2t7o
	 c9QlpPdguBGmx0nGMIzgIleVjk+S5361TxR74ppc2b/6EXawl7CJnZvFXZFEEbfHCx
	 gh4FPANJ/YJ8GX/Ep0bKAQ87CTUUl2M23ZDqJXJIS3hCTlslAYG8KhB50nLC1O2H22
	 coJJM4BNYO67w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  changyuanl@google.com,  rppt@kernel.org,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  jrhilke@google.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
In-Reply-To: <CA+CK2bAP-PWkYtZbw8ofhTgDaW3qoQkNob30wWSjidxEUTV4pg@mail.gmail.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<CA+CK2bAP-PWkYtZbw8ofhTgDaW3qoQkNob30wWSjidxEUTV4pg@mail.gmail.com>
Date: Wed, 13 Aug 2025 14:44:03 +0200
Message-ID: <mafs0o6sjwfvw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3008C000D
X-Stat-Signature: pe1aj4wwr5eg8at71w97c9coyj85a6z8
X-Rspam-User: 
X-HE-Tag: 1755089054-726439
X-HE-Meta: U2FsdGVkX19DXrNtUXoF6ZTyeQw5Bhk4XSzUp7Izhxqoh4Ltg/32e1FJ8Az5ByoOIb8RMqjVgdtE5Yu1nos8+XY3A0IhwnD/fWfTNqy28V2Rgz0+BeFLRHeaIDPIuD4FhT4VANY9AR9K4tNEAYiDnRQ+SZKggXCVP4a4dspIcF5urDTLjZOhu4evBjTaRmWYRzcbdo5xUUt/eeF5ECW5DKmlt2OTJh5cVpqUaqa8rVMaQldIRLdx2kD4Qp1GslMqPqiC5PMSMcxaTayoxBVmKPrIbFtTRS3i6Rl4LjLfO+V9rCI3Zz9pjsgsBeaV/4i1ehRMKa4/TpdDPgJaHsaBBrHcZmqWpRe1GVIC1rBZFiUjzXsVerJDUA98PzMkWoE93H8m37PyBxPzyOwpPt+uJOfgeuxXtUYdkiEGYC5cZtE1G7zTx6ej2lXPuwgRuVHmbnSuFSZzEf7nYqgVHlOhP3BX6LVJE/ZIYE1VqE4Lpck3TgJr7sL1jMIV3fU+OlYpQIUUUllw7GYu0m4R1tQX9hc9MUnSZI5G92UtnK4ell2YehG16aohra08hHDvy10RGA7RRQLssYNwGJOZAz32tQwm0FCdea3xh/+o4IMtvgdJmE/acFDltVnQdtbw9FRdMeVs0XXw9SukrQLzdWQ7XW6mAQf1kgm66CviB+dO2Ppd+gUke06KaOPEFy2jP0ILUoEdlSik6DWMnzSYdTyP2QaB6AJ7ilgYKsaOis6POy81lUbQC3xwdTO0W3j8ZLfryyKojMA7eWB1CikVFFEh4qAC3+zL5hnrJQZ/CI79FJnW1Mf673doTFsTrnrn//Z8SjpJG97/1SyJH9uBkbUz/dolL4+7eqATmsoexpg367XMn+Mgz53bs1kr9lj8+RFaLCldrnz94dTpbh+oCel+TV4F62LPdesOuqsK7nAXVvsfejufIj81/NOA121Rx4Hm3e/ACPOg5rUbq1PtLA9
 voul6MgA
 xSZIkn2FYkX1gDHXsbdCChv55Q8dJB5ho4Q369Ix9swI5J3js2RO2CtPgI9+sy3enO5wZ5cJFZDUGmWOCc0E8fbBsVDnTRP8xowZCkMfFkHGlSSS6ZnvEERBhT4QpxK4r/Vz6vzo6p+iYiuGbzC8GdsO/HAxFjS/fMyQgAEtBqnPfRIkqdyW6gLPrT7WmZoLVe5Eb+Y3Rsk0c/1loOvY1p37yycmSYua+/KN7Zupv7Izz34Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08 2025, Pasha Tatashin wrote:

>> +static int memfd_luo_preserve_folios(struct memfd_luo_preserved_folio *pfolios,
>> +                                    struct folio **folios,
>> +                                    unsigned int nr_folios)
>> +{
>> +       unsigned int i;
>
> Should be 'long i'
>
> Otherwise in err_unpreserve we get into an infinite loop. Thank you
> Josh Hilke for noticing this.

Good catch! Will fix.
>
>> +       int err;
>> +
>> +       for (i = 0; i < nr_folios; i++) {
>> +               struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
>> +               struct folio *folio = folios[i];
>> +               unsigned int flags = 0;
>> +               unsigned long pfn;
>> +
>> +               err = kho_preserve_folio(folio);
>> +               if (err)
>> +                       goto err_unpreserve;
>> +
>> +               pfn = folio_pfn(folio);
>> +               if (folio_test_dirty(folio))
>> +                       flags |= PRESERVED_FLAG_DIRTY;
>> +               if (folio_test_uptodate(folio))
>> +                       flags |= PRESERVED_FLAG_UPTODATE;
>> +
>> +               pfolio->foliodesc = PRESERVED_FOLIO_MKDESC(pfn, flags);
>> +               pfolio->index = folio->index;
>> +       }
>> +
>> +       return 0;
>> +
>> +err_unpreserve:
>> +       i--;
>> +       for (; i >= 0; i--)
>> +               WARN_ON_ONCE(kho_unpreserve_folio(folios[i]));
>> +       return err;
>> +}
>> +

-- 
Regards,
Pratyush Yadav

