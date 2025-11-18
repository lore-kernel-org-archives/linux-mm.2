Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 367A6CEE347
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D6806B0092; Tue, 18 Nov 2025 13:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887096B0098; Tue, 18 Nov 2025 13:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74EFE6B0099; Tue, 18 Nov 2025 13:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61B4B6B0092
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:18:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C02586213
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:18:00 +0000 (UTC)
X-FDA: 84124536720.20.F5E6EB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 54DCB80012
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:17:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MrGIWm9L;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763489878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGjVePNx6NWAW+2forpXkshqwgF5+/oxUYTEXmpULJM=;
	b=VNKk7qZmyBnwUh7wzum/vnPnWdjrLcbM1vMKmnEfBpAHvj/1Q3V3yocDu3ayTGUzBLUAQ4
	qessDJoqmc3LsLugK8Cdcfvkr6sf/CXgqi0YaBgnZNDZtw0dFgOrjs73tPX65+pPXYeEh3
	94Yq7Q4q7gPjRD180hjpkTWKCH4qMfw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MrGIWm9L;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763489878; a=rsa-sha256;
	cv=none;
	b=02V09qu5P1ZtJe8HAbkDEgAoxPQCKK6PGdugAlkYgdqf3/sEv5DUgC511oWBvp72aexxdI
	xe4oCoJ2RxQdUqKNjJMxc/UUE8ZT91y4jLeMo5rJU4D+yhfkbT9fnBBCWNREMCOR1gL0jU
	lzdLhEIkuD9J630a/K5IzGjCQL0jWlc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E526043300;
	Tue, 18 Nov 2025 18:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F00C4CEFB;
	Tue, 18 Nov 2025 18:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763489876;
	bh=MuaIcliWFm+wXQbyLOy+ePW5Z5hGnw7S19zVdOoRU9Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=MrGIWm9LWqZsfMs7ulgLTqd+vSnlbOrkGvCLSVQRDuELbIodah+F4M3f3FTCxDsYn
	 ubnteG6atXRRKp8sze6lQ6WYH+8u9RRxKmACuQIsUF/fNgOgsfrvg6HbHIadYL33zl
	 toHmEIuMukisjBAK6rWuEqeWX+hlpLLONOpACy4sSOUgXkzAModu7TG7oFE4qTZkaD
	 QjNS5JBnayMhMagSvhPUUG5/NOt4b0LbXnn8v67kdCBH+QUpOE0zhUWa2zlaT7cUHq
	 JvgpcxfLJiIEoAkXjzZaCmSMloZQu8GTaTAAgOXhJgT4nRevn5hDsdQFhJgF1pvmif
	 wFptWQwi5kylw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  David Matlack
 <dmatlack@google.com>,  jasonmiu@google.com,  graf@amazon.com,
  rppt@kernel.org,  rientjes@google.com,  corbet@lwn.net,
  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
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
Subject: Re: [PATCH v6 06/20] liveupdate: luo_file: implement file systems
 callbacks
In-Reply-To: <CA+CK2bAqisSdZ7gSBd7=hGd1VbLHX5WXfBazR=rO8BOVCRx3pg@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 18 Nov 2025 12:58:20 -0500")
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
	<20251115233409.768044-7-pasha.tatashin@soleen.com>
	<aRyvG308oNRVzuN7@google.com> <mafs05xb744pb.fsf@kernel.org>
	<CA+CK2bAqisSdZ7gSBd7=hGd1VbLHX5WXfBazR=rO8BOVCRx3pg@mail.gmail.com>
Date: Tue, 18 Nov 2025 19:17:42 +0100
Message-ID: <mafs01plv433t.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 54DCB80012
X-Stat-Signature: 3cxhieotrrtdahomo76rg3gjtjh7ho7r
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763489878-97440
X-HE-Meta: U2FsdGVkX18eTQLq361SHP/ifwAZLdlYIkZl4cGkQbSbu9uis5YkG+OzLE3/1TRb1dVF/Rj3vZIbIg5EqIgC+xTGDLZr3+sMo9UVamu+zh+BDqE43QoAtWRb+5A5oY7i7mVMER/dPO3nkuRNhOtjsP5m9WTWrIJ1kt6r52NpT81FB5FVW8G2is5IsjiccOYjgkmNlM7SA/5snNK707yF5QeMgtKYHMZJLY23NwuBO0A9PWbOCoMWtNdrjM8QUi1XoEBvZqBX4B8Xj8iLKL8mdZFJRmH/057l03jzOsGzgAqKdCmWtvDe7g79NlLLwGWPF8KES95d2ofxbrPhnxyjt08Kruy3hEE+VG0RWSOgTY6SDDhlGRRMD38mwMzYCv5UHAMhPVVHfgivCjNXuIyN3N5JpW8tMc8BCs4sQbAD+O/CM7KdrMFsuaKOQdNM39KQgFC790Oz5P3cdLhzFrZfpPxXzKK8TrhiMD9o1lFMCKYQmlsDay95Vzd/nYukNZV/9sgD9Gkn8M1UixI2GRW68TOcEjw+DVSQilQAwGqftQGrglGG0xFabTwup4oef+tHfE4WiIpp+zWNYPYaxS47VCdRqInIQK9gA52qniKb11Q8Go/pzlgksKHel9T74rdTeja18PyuPwKhYozPfGDzSqV3QfLsbfiRRTIlSzBFi+URqY3cgerG4IDiofVUxuWlLUPzqGBJVbRUglUuIZeAGwNgrP42vSWqrrr51migPD+3vFhskyG0uUWkvTbLN8/kpUxZ1JdnajQwIQ/bBe7VNmBAjPfBp+2RY36XPUKQwj7EouwrZgUG8dQpToWApK145CQ3B8/WUNIRMDeV2NRcdpn9yzitX+tKbASrLWubIxzO3Aq4Rz+TMMCT9crIHy0sV3/r6drxrkWEOjvMqrSLhpob3gRrRBzs4sbar27RX7+OEd1khq2E84SzFVcAAp88VOaarXnmZZHyu6JNVWM
 KMrzrZuB
 QKNK1XnIxr1nrCa6osbrRU2PfWE2yFsvE5OD5Eq0i5QnT7yR/d/jMdtzKuLYMlL2ls48Q1kcSWSj+4G76hSXyW+1agsliwq77JdpurUyt8nniM8SX9qcP2kAgkz1mg/n1qJxn0AEoX63d7ANov7guJxMru/zPw3v/EfFjFAOw5TgwWGR5P0dM7rwloWtyAPfRi8F494/kzjfeJ+H/JU/7HNJekYzXuZYeWLZ0Bsyz/loHQan6QInliHkM/oITR8fwkaQwfSP5bYO8vJr9mWetrpRlIghmLVhCoYatOLWZuclc+aTUwK57ZcTlgc+Fy0o24drihQLIeDhIwLwCZ9WgzGc62wYJwFjqR8j0D4VGxwl4nq9jMPl+tFG5YD5ISS6rXGhPgZyyoa9DVYmTdZ8guTrf3chlrSyzwsyKNJ0X8IUNOe8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18 2025, Pasha Tatashin wrote:

> On Tue, Nov 18, 2025 at 12:43=E2=80=AFPM Pratyush Yadav <pratyush@kernel.=
org> wrote:
>>
>> On Tue, Nov 18 2025, David Matlack wrote:
>>
>> > On 2025-11-15 06:33 PM, Pasha Tatashin wrote:
>> >> This patch implements the core mechanism for managing preserved
>> >> files throughout the live update lifecycle. It provides the logic to
>> >> invoke the file handler callbacks (preserve, unpreserve, freeze,
>> >> unfreeze, retrieve, and finish) at the appropriate stages.
>> >>
>> >> During the reboot phase, luo_file_freeze() serializes the final
>> >> metadata for each file (handler compatible string, token, and data
>> >> handle) into a memory region preserved by KHO. In the new kernel,
>> >> luo_file_deserialize() reconstructs the in-memory file list from this
>> >> data, preparing the session for retrieval.
>> >>
>> >> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> >
>> >> +int liveupdate_register_file_handler(struct liveupdate_file_handler =
*h);
>> >
>> > Should there be a way to unregister a file handler?
>> >
>> > If VFIO is built as module then I think it  would need to be able to
>> > unregister its file handler when the module is unloaded to avoid leaki=
ng
>> > pointers to its text in LUO.
>
> I actually had full unregister functionality in v4 and earlier, but I
> dropped it from this series to minimize the footprint and get the core
> infrastructure landed first.
>
> For now, safety is guaranteed because
> liveupdate_register_file_handler() and liveupdate_register_flb() take
> a module reference. This effectively pins any module that registers
> with LUO, meaning those driver modules cannot be unloaded or upgraded
> dynamically, they can only be updated via Live Update or full reboot.

What if liveupdate_register_flb() fails? It would need to unregister its
file handler too, since the file handler can't really work without its
FLB. Shouldn't happen in practice, but still LUO clients need a way to
handle this failure.

[...]

--=20
Regards,
Pratyush Yadav

