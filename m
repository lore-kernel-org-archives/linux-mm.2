Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7FECCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 14:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32C48E0034; Mon, 13 Oct 2025 10:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A988E0017; Mon, 13 Oct 2025 10:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20808E0034; Mon, 13 Oct 2025 10:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE4638E0017
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:30:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 478D3C04A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:30:43 +0000 (UTC)
X-FDA: 83993327166.17.71C5AF6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3A823140010
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:30:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HIRnNr9H;
	spf=pass (imf23.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760365841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTlu2d/OCa7smgTdfnf6rps6xmzbDobGt8v/NuBgfVM=;
	b=Pzz4Th0twSsfhnvkp/csMLOjFh5gw+S6uZXuUYmjjDmKr9GhKhdHiAP3V/2P5ExV1x19PC
	2Uo3ZB/uEjIL1UN5R1Fl/iz/0EHFpxXWN2v3qzB5g67FFT1tm5o2ZZc3GCDOTmeW8eNZZu
	pItir6RWYCAlkALcguREXY5bNKI0i/o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HIRnNr9H;
	spf=pass (imf23.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760365841; a=rsa-sha256;
	cv=none;
	b=A3kltrKU/gOfZzlFJ9v8JUL1Af4aupTrcOhfvkmLY9TRwFuwkejpjB3dDRuK3uUR8tWtvc
	Upy9QK+31d8g0I3nn64RYNucCFNzo8w+9tIHFC1nhs3oHd/ojG6Wr1tuO0G+HIrZ7j8l/C
	FVekXMHbwy8lmzL3kRgXu9apkYuHZYQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760365840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BTlu2d/OCa7smgTdfnf6rps6xmzbDobGt8v/NuBgfVM=;
	b=HIRnNr9HN4vk1HKut9LxvJuGhRMtzzUSIbIhjwL/0Dos8LC2SLh0AoUZoixxzjWoJqz8H7
	6RRmrZbMIr55j7J+gEJ3qhywdlvBdtNP1lmCuWozgtypzcSVNhEQuOB7V4Fp+Ao96VHVar
	BsPRvYP7hF4LaJcTm9R4BZ7moAFEMjU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-542-WHoEOy0QNoS_DHwHLaA70A-1; Mon,
 13 Oct 2025 10:30:37 -0400
X-MC-Unique: WHoEOy0QNoS_DHwHLaA70A-1
X-Mimecast-MFC-AGG-ID: WHoEOy0QNoS_DHwHLaA70A_1760365832
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AAB3019560A7;
	Mon, 13 Oct 2025 14:30:29 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (unknown [10.44.32.50])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 414E01954107;
	Mon, 13 Oct 2025 14:30:12 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Deepak Gupta <debug@rivosinc.com>
Cc: Charles Mirabile <cmirabil@redhat.com>,  pjw@kernel.org,
  Liam.Howlett@oracle.com,  a.hindborg@kernel.org,
  akpm@linux-foundation.org,  alex.gaynor@gmail.com,
  alexghiti@rivosinc.com,  aliceryhl@google.com,  alistair.francis@wdc.com,
  andybnac@gmail.com,  aou@eecs.berkeley.edu,  arnd@arndb.de,
  atishp@rivosinc.com,  bjorn3_gh@protonmail.com,  boqun.feng@gmail.com,
  bp@alien8.de,  brauner@kernel.org,  broonie@kernel.org,
  charlie@rivosinc.com,  cleger@rivosinc.com,  conor+dt@kernel.org,
  conor@kernel.org,  corbet@lwn.net,  dave.hansen@linux.intel.com,
  david@redhat.com,  devicetree@vger.kernel.org,  ebiederm@xmission.com,
  evan@rivosinc.com,  gary@garyguo.net,  hpa@zytor.com,  jannh@google.com,
  jim.shu@sifive.com,  kees@kernel.org,  kito.cheng@sifive.com,
  krzk+dt@kernel.org,  linux-arch@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  linux-riscv@lists.infradead.org,
  lorenzo.stoakes@oracle.com,  lossin@kernel.org,  mingo@redhat.com,
  ojeda@kernel.org,  oleg@redhat.com,  palmer@dabbelt.com,
  paul.walmsley@sifive.com,  peterz@infradead.org,
  richard.henderson@linaro.org,  rick.p.edgecombe@intel.com,
  robh@kernel.org,  rust-for-linux@vger.kernel.org,
  samitolvanen@google.com,  shuah@kernel.org,  tglx@linutronix.de,
  tmgross@umich.edu,  vbabka@suse.cz,  x86@kernel.org,  zong.li@sifive.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
In-Reply-To: <aN6sNFBzx8NPU3Th@debug.ba.rivosinc.com> (Deepak Gupta's message
	of "Thu, 2 Oct 2025 09:45:40 -0700")
References: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
	<20250926192919.349578-1-cmirabil@redhat.com>
	<aNbwNN_st4bxwdwx@debug.ba.rivosinc.com>
	<CABe3_aE4+06Um2x3e1D=M6Z1uX4wX8OjdcT48FueXRp+=KD=-w@mail.gmail.com>
	<aNcAela5tln5KTUI@debug.ba.rivosinc.com>
	<lhu3484i9en.fsf@oldenburg.str.redhat.com>
	<aNxsWYYnj22G5xuX@debug.ba.rivosinc.com>
	<lhuwm5dh6hf.fsf@oldenburg.str.redhat.com>
	<aN6sNFBzx8NPU3Th@debug.ba.rivosinc.com>
Date: Mon, 13 Oct 2025 16:30:09 +0200
Message-ID: <lhujz0yoowe.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A823140010
X-Stat-Signature: 19hswad8rjj7rsbbcgm58dd5irb1zi3z
X-Rspam-User: 
X-HE-Tag: 1760365841-848807
X-HE-Meta: U2FsdGVkX1+OT0Az7whZX6O6B3cjn6mvsTQnwvkKOuy/1Hb+nVFg9eF+DOPF1nipQBI6O+lsVzalp+jTbHdQ5BXF4E6WYGhfpeejJVmlC45h+mXn8h99d5MLctlvMGGe5Q/azWAj0/ppzfvIPnuF8IRhxehGOaP9ctEYbnK9ki0K77sJ5hHEEcImbFgu3SMUvhDSRATKsJRubtPxeppymH1GRxm7dmMEkKUdnpyHxzeUMw5F6LB80l7BVxnJpe3nEGc+4RkYChXxRC5J7XuPjhhQERdFWVlj1iDhVALvfagp7i7eUZIc6DoVrPjXTvzI81pix50fCJADxu8NsspQJbAIWC5Lr49886BwHRobkNv8ZCq4/uRGDDooxCV73Jz2hh6AKAIHWSsDI/or6+X0ekbxVVJOUJxURb7w7NW7nf+CywJA6kGM5S7yf5T29F4krV/8R1Ud8shzfqhaJi7G4S8De25Gxo6qr1SS9CMlW5K5nK4STMQ7sbSX8ptfSV3m/l0CQp8jaGst/1zSHfpPjPDyHGSpkb6sDiA2nxxifE1d15a79/24Ih6tdf882EXno8Di0rxnpGC7yjA5BzSjmvwfT+iAcpy+4hcpgikcn2j5d9R+fhYf92beTlzdhTF5MSRUC+lmFUgLOOp3ynmrArw2/0WC0VlaaHpNG9yKPSJsIdqcqKfsutFIu17+KKWg5TabiNRyYAcgvAg0Ima4P117MiO40a8AXdlDf580+4f7WI+lyjdQhlD46jnbdlkx/UFPxtiH6jn3nrbRp0IESfjGXqxguBXrTF8MPFilygmdNVQAIqywgOdSbrCRKphgigpsFsRNrofOHBTUPjQ1otk0SD3I9lTp/zG/W/oKhW8pMa+6FbhuAc1Qt+L+v9G734ejjQpMqS+BkDzU6aY3f8UbUYwCDJYSgLje7tIsoXVE4THFHXBNZtNsPZ1GIbEVbK8gtfaqHzuJU4aBIda
 5GnmSBjp
 m+WVBfjYOCgqxmycYG51lrdMPXDM4xQBtUne2PLxT/ymwn3DipwBcJS50uy1+LzBQxEFwH40x3QZCha66K3o8LGLS0x7M/vB7K3HgiNtjojVtUPAvh7XB+27Xyq9ZygxAeIMLlglxwpxV0r2m2PiBzc1rVs0eN9kjlB7sqxrvKLM5DnxJCLMG1kloMAI8mfIlAEx8yRis4I2MSSfOTCNq7btCnSGzChqNhqzdwZOzmfdFDi0A9/bJgxf2UTcLRz5HPfPawjjDgXx8cfoKaVq2OpqbRmNDdC+KyVFh7dPcCjPS8z3QyN+2jjtVnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Deepak Gupta:

> How will they contribute to CFI bringup without having a CFI compiled
> usersapce?

Build glibc themselves and then proceed one library at the time.

>>Another use case would be running container images with CFI on a
>>distribution kernel which supports pre-RVA23 hardware.
>
> Container image with CFI will have glibc and ld (and all other
> userspace) also compiled with shadow stack instructions in it. As soon
> as you take this container image to a pre-RVA23 hardware, you won't
> even reach vDSO. It'll break much before that, unless kernel is taking
> a trap on all sspush/sspopchk instructions in prologue/epilogue of
> functions in userspace (glibc, ld, etc)

The idea is that you can use a stock distribution kernel to run CFI
images (potentially form a different distribution or version of the
distribution).

But maybe none of this really matters.  How far out is CFI-checking
hardware?  Is it going to arrive much later than the RVA23 flag day
that people are suggesting?

Thanks,
Florian


