Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31EEBCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CE386B002F; Mon, 24 Nov 2025 09:58:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A59A6B0031; Mon, 24 Nov 2025 09:58:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E23B6B0032; Mon, 24 Nov 2025 09:58:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7546B002F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:58:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 475A988BB2
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:57:59 +0000 (UTC)
X-FDA: 84145805478.23.FE2AE37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 332C6100018
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:57:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yo98vvMZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763996277; a=rsa-sha256;
	cv=none;
	b=41g+gYbWkb5A7VEzxz7BvEqcfH0jHwOoihfq6wlIeQDKc0PzW4pu0Yz3Z1HoL7ai4mi+zL
	avXyMv7N9+yMR9XFM/T1uzqPJeEJL/ts4Dw8jfIKRjRrG561bA7f6PBYIryJcgYCjEnYqs
	ECfh5iDxNhoSyl8H6xNs6w/k5bZum7c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yo98vvMZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763996277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eI58qe2UFaD6zmpjXRLJCwUCgHMI5ElUVf6AxpDkbdE=;
	b=8PUB5X7D6dK8ahKafwIV3LbOo87E2/Zz7o1vsB2VrTt1p7koqsk2xgGIdTPnNUm5SeebfX
	dOcagwEtCtUsTSJfIS5plTWOvV4lv/7hFk8Cw1FkHcFDXQSSxxk2tUABO+kBSZ/ItjWD5I
	5gEoFQJhSg+4w2uBboTUSlTnWXPfdOE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EBD1E438D6;
	Mon, 24 Nov 2025 14:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5B8C4CEF1;
	Mon, 24 Nov 2025 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763996275;
	bh=eT4pJrflwgRPMF4ryE6lrh/N+OcL3X6tkjV48AA+6HI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Yo98vvMZm/olLPqpxnPsvRURyK/2mRNeN/gLay7rE5jE+UrJoSq3l1gTUDijol2vR
	 sTBC6XG3vdtj6VgW8PaH5OH2BDzAKQX0aG4V/3G8A8QI7mu1Z+GFyXK5+FOqp+/Zfr
	 WhvErW8+LgmXEsRBaOewO3lQEgH594+zmhorrmc1Lj3BNCSUVI8PtG/9zDSMKmMpWh
	 aGkZnmwGfxqEDUQx4p32IcugsCxlxtbiCRJHWSVA30dtIbZ/ImNdeJXs7fZ8y4b0x0
	 vJ+7C5GiMTHLP+I3Um/3AkDZvYkTgOuQWucN73eVWfujBPE0D1D1mUEHqoTBVasuVh
	 61m02b938kG6Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  rppt@kernel.org,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  linux@weissschuh.net,  linux-kernel@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-mm@kvack.org,
  gregkh@linuxfoundation.org,  tglx@linutronix.de,  mingo@redhat.com,
  bp@alien8.de,  dave.hansen@linux.intel.com,  x86@kernel.org,
  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
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
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org
Subject: Re: [PATCH v7 04/22] liveupdate: luo_session: add sessions support
In-Reply-To: <20251122222351.1059049-5-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 22 Nov 2025 17:23:31 -0500")
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
	<20251122222351.1059049-5-pasha.tatashin@soleen.com>
Date: Mon, 24 Nov 2025 15:57:45 +0100
Message-ID: <mafs0ecpnzdee.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 332C6100018
X-Stat-Signature: eo7orsrrmkmjrbsjnzffmckq39w8jgxj
X-HE-Tag: 1763996276-601051
X-HE-Meta: U2FsdGVkX1/ja50bve1qKIUJ+vl25SfOalQodb4c/lmLhsaI00oaH9/dAfx9AHoO2Roxm9qc3mGWZmReFuefwEIQiGmrs7/uvjW0S4vfVF3bpTSqm6ZhErCSn4nuHtJmycbEdmy+xitqlekeKbM7f9jgfykno2h/tT+QSdoYzmsUKTK2jvldKDSIzvGJBHlpFVdfvJUFpan4dAMHWVelZ5mOY6PttqxLxa4x2jfLtsx5zXIyknMsXdpovR7gS4fZaphGbnIPIFVFG2c0IwsM1c/9h1CBm5Y4eEPrXdJB7Rhh7PeRPBrQ+SZHjhIif9alThIGP0fud4hKRNveQDtNd5NsLzslQR9jwBMrOcv5uNavF0VdDHGrB7T5BFYM2N1oZI6O2pGyuC4l2Pppi3m37blD57cp8/mRQg4c57dcwaxyvkdwF8qtnxsBVRb6xusSJeMJXa5rDpOltNYgwwpLG3wrD0K3fh4u6hFdc0vw5TTLbIMHD3s3QlBud8V1n8T/oBFAsoo6HzVitdias7B90KUMcYxRyC418t+cojWVtL2JYZiXeRQeO6sYvvv5EDrgjgFwL6eNx7U9lX8fqYlIzJOKajyMjeKjbukJHrXGd8Ga/Ff13HUKRY22gaIIQQKmTWXmKs1wkAf4MSLgm4DibdsxQUNbKZxAVv8wFcI/e5K7D0UMznsfKbwZKdCjCZTn373KYEMyFxD410U043XFc0OiB3MCintu97MkS8ZcOWztr5r0QhKIa4pfDgAc69B0HZNQuedboA3WjARHPcgAGwX5wogtkIfkt2Vs6nd0KeFR0CB9p8NOPP6KuNI+6rKkNWKMjE2oNXex94iljyJf8IB91TYwyHPZ8ANQHrA20I0cagETdxvy+Qgtbee2zCnBPuFzjMcZRyaTLADLMgxEGlgo6fNrkpAmoZ2RVgkxHZ+hiBWT9CWpZX8SVTKoiaPfTH3nd00/Ojc8ja/5HlI
 yV+V+O4p
 x7Yy/dNi0gboLyhsoQ7mnnQmahPriXOoLdcnyZrarA2n2fH7KM9i22ky7ButEDynOIiWGSEheEP1EDrrbBQVdwwgfIkrO71A1aBjWlCOHN8U0JlKQmZf1VD59G3KCkTKPekcn/jugG0sKsAx5wu1mw6lNA/m3L8lGQWGgiQPT6joctcG7GgdoJB5mgV+3nc1kNbcW6IH2wENTeEFzwJTjT8up4jQOkPJuRdG8ERUSA8jvQkb910QPwN9Nd1WLBoD36FEG4zOkrYbF13AYp1Siv9x7bXJQpk8RLpyQYUBR9KrJLSKmlvWrRKz9h3aw+neyOYRfylSvqek2IcMPD6AfuM0lLAh96qCV1Y7752SirJ6cutZm7bPOCtz60Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22 2025, Pasha Tatashin wrote:

> Introduce concept of "Live Update Sessions" within the LUO framework.
> LUO sessions provide a mechanism to group and manage `struct file *`
> instances (representing file descriptors) that need to be preserved
> across a kexec-based live update.
>
> Each session is identified by a unique name and acts as a container
> for file objects whose state is critical to a userspace workload, such
> as a virtual machine or a high-performance database, aiming to maintain
> their functionality across a kernel transition.
>
> This groundwork establishes the framework for preserving file-backed
> state across kernel updates, with the actual file data preservation
> mechanisms to be implemented in subsequent patches.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

With Mike's comments addressed,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

