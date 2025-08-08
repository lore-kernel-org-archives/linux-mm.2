Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C760C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 11:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDC586B008A; Fri,  8 Aug 2025 07:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8CEA6B0093; Fri,  8 Aug 2025 07:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B5C6B0095; Fri,  8 Aug 2025 07:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B478E6B008A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:52:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 357A7C0173
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:52:26 +0000 (UTC)
X-FDA: 83753427492.11.C346E19
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf05.hostedemail.com (Postfix) with ESMTP id 83EDD100007
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:52:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uDdmB93f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754653944; a=rsa-sha256;
	cv=none;
	b=U3yAejZXLxaV3sNDusN0g37zA5MttgKPtOvjT2e+TcnJgK0DUA9HMfhaOI3jhGKXhaF3D0
	bONLuxBm1y79hD8p8C2KFC3A3mR1GTkpdVrNOgVICDRoBDLdq1F5RYtKc3NELw4A6FyLvz
	QHogo3fA9ADXMWyrnurr/fs3jidMYBo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uDdmB93f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754653944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBdlpDsAkSWvsei54rW4wPxCSN8BiNce+USg5ploIqQ=;
	b=26i2ED5SvUHobPH3wvv4SkuYbDPD9FqZcE0sJrFudHU8TKD+jGp55dAf66A3/JC0vUDw3P
	Y34tTMjmo5ljX7SFA/oFiy9Zpb6nmuKCY9RU1659RZ7q2Dd3zA34QnjA94EteXGjoQoL8E
	PWhLYDGdQE3JaWjPZvohgIam+JzyDPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 80D8E5C56CB;
	Fri,  8 Aug 2025 11:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0977FC4CEF1;
	Fri,  8 Aug 2025 11:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754653943;
	bh=xSEzUb8y2xqXpVXNL7u1aJemA6z6EHDR87sROVoHVGk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uDdmB93f9xXYQw7pkccVTAZrASxgjPMDhOD4dK5a+xhpb/pMvvaduoXy2UTuDD4PR
	 bXX5SxJeAHbarWlsYjOOfSdbQsa2Kg4b0aEtjXzZJNmW2ocmkCY33jH3ChlAGzHSSu
	 U/cwCh0SZq0ZwcXNcEV5xM4/tMPsJRedE7liIKTRhR/8w4H2s7U0ZiG8y/hSAnn4W2
	 wAFDEllgM2zeloAVeBdqRvUewuE/hXeMPpG7vhtP0DsUJ+1d8jB4ago0TZ7Q/GJp2u
	 QgK18psr/pv4vsQbytQEYh4lAbzARwwolw9f5yGC6h89p1AtmQ0dGtKbWQb2WXd097
	 +/moD7XmsFvkg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  jasonmiu@google.com,
  graf@amazon.com,  changyuanl@google.com,  rppt@kernel.org,
  dmatlack@google.com,  rientjes@google.com,  corbet@lwn.net,
  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
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
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 01/30] kho: init new_physxa->phys_bits to fix lockdep
In-Reply-To: <mafs0o6sqavkx.fsf@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-2-pasha.tatashin@soleen.com>
	<mafs0o6sqavkx.fsf@kernel.org>
Date: Fri, 08 Aug 2025 13:52:12 +0200
Message-ID: <mafs0bjoqav4j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83EDD100007
X-Stat-Signature: 13q7ppaxz38kdi5aoijcrzi4zk193p61
X-HE-Tag: 1754653944-631526
X-HE-Meta: U2FsdGVkX1+r+SXAEPVjiqgpf4716T1V9tchlEreiOt3Xb6deRvm7VeL0gMreKbUKukFU/o8k63cIO+a+SocCk+GdbV+iBHpOSv+UdON0JrBb9fjKvm3xnMVAHfU0ab6eQHbVNvtqZgkRerZdlKguPytJob+fRWlxNZZTpDhZHqCWN9bjc8littuxLFpPwDXubHVINWlfeZDxHo6X6+QnY8V5zCbWb96kGL//dhYG47zDIERYZ6s4p8V0ZShTYq2fVqeo7MotocvXt8hQm+nKeUTL973G721ZwId79jKzSjpU5Z0o6iMFZEvcVocbwRcthA6yNG652Vz8FMUywEH1I0QINUx+mZ/lLfWOXg0nqH6mbisPEh5pMpWfv32w61UKk2q+enxmYx21xR0h/BaAd9DFYSaEupfXNasC51H8oGpDc3TBHvRBujE42cpWldZgCXLBJ8ZZy3FXWHMP1PTWliCBXDo0YLbzsdFCB8t6gOU49jjkCBSfMpVyCMfOYta190fEUIKAOrJEwd31zecyKqfuGc6+xOQW0bXWnpgj3peaabfKSgjkT1qLK7pByUH6vxcDsavc4q2y+hbEJfO3bjo4BX9PNWUcWjup+w+xcYHrORX76hrWlbyurZ3m78wyEHPdhh+Gr+vczE3cahvB4bW9os5S/oZslA8LQZhAw5OXCLqCyr8iCX0LtCDOB6mCcynC7A4Bvzt6+U1cREg2vTzSGwQNaQf+mZLHD9O0dGC7K2s9bq/QT7xJ0VqE0mb2+Pn+olDjdqfYeZNHs2l5oCGfLSi8baN8rikdxzPEcGc6pE4Bcd4Jq/pAlCcyY4+kSO0Jwpvl7ZO3bOoAdYjee/mqmKjfgjLaxkVnb9UyRrBImEDYp/OA7m9zoV7ZBHRXnYLxebjbfit0Pr8gvRMFI4lMr+/inuNWx313jdSdv5WbFGTcrSmVq0JmHZO68trUc/Hb2mVIVKGlj2Ht/q
 EkWFBGS9
 7e/obeYwf15DtBs1MebKBjqGAMF/DPQo1vZFQwWIVKAAEQ4BJnA5skktk9ROGhfw0FKzdYQwJTtfvdCyZYGbT4zkS76NT0hHWma5jMy1fP95r5n3Kxj323V4vjS3JqkH9Y62ExFrnTWqOCFyDqABIdF13pXn1NWzvzjH9II5jWnVt56g09Y0QmvEQRq6389hQ8/9jrQlhWb3iUrwY6sFFoqm5Qdz7zfKnRmvh4wkc8Qbf/5+wHj1/MMau5LGXvaOmNP8I1tFTeS/Z6h7hwwGMJf/NdFyGtdpxja+j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08 2025, Pratyush Yadav wrote:
[...]
>> @@ -144,14 +144,35 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
>>  				unsigned int order)
>>  {
>>  	struct kho_mem_phys_bits *bits;
>> -	struct kho_mem_phys *physxa;
>> +	struct kho_mem_phys *physxa, *new_physxa;
>>  	const unsigned long pfn_high = pfn >> order;
>>  
>>  	might_sleep();
>>  
>> -	physxa = xa_load_or_alloc(&track->orders, order, sizeof(*physxa));
>> -	if (IS_ERR(physxa))
>> -		return PTR_ERR(physxa);
>> +	physxa = xa_load(&track->orders, order);
>> +	if (!physxa) {
>> +		new_physxa = kzalloc(sizeof(*physxa), GFP_KERNEL);
>> +		if (!new_physxa)
>> +			return -ENOMEM;
>> +
>> +		xa_init(&new_physxa->phys_bits);
>> +		physxa = xa_cmpxchg(&track->orders, order, NULL, new_physxa,
>> +				    GFP_KERNEL);
>> +		if (xa_is_err(physxa)) {
>> +			int err = xa_err(physxa);
>> +
>> +			xa_destroy(&new_physxa->phys_bits);
>> +			kfree(new_physxa);
>> +
>> +			return err;
>> +		}
>> +		if (physxa) {
>> +			xa_destroy(&new_physxa->phys_bits);
>> +			kfree(new_physxa);
>> +		} else {
>> +			physxa = new_physxa;
>> +		}
>
> I suppose this could be simplified a bit to:
>
> 	err = xa_err(physxa);
>         if (err || physxa) {
>         	xa_destroy(&new_physxa->phys_bits);
>                 kfree(new_physxa);
>
> 		if (err)
>                 	return err;
> 	} else {
>         	physxa = new_physxa;
> 	}

My email client completely messed the whitespace up so this is a bit
unreadable. Here is what I meant:

	err = xa_err(physxa);
	if (err || physxa) {
		xa_destroy(&new_physxa->phys_bits);
		kfree(new_physxa);

		if (err)
			return err;
	} else {
		physxa = new_physxa;
	}

[...]

-- 
Regards,
Pratyush Yadav

