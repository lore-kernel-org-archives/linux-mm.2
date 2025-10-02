Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90547CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 11:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7CB58E000C; Thu,  2 Oct 2025 07:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E540F8E0002; Thu,  2 Oct 2025 07:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90BE8E000C; Thu,  2 Oct 2025 07:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C53C78E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:46:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79AC71DFC87
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:46:24 +0000 (UTC)
X-FDA: 83952996288.04.11B9EA1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id A8B88C0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:46:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mi3cRH7p;
	spf=pass (imf10.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759405582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAW7j/GiCX4Ldk1pbIGoe/EzygOj7TZ3MCMZKOX1tCA=;
	b=5Byudf4Lt6pJK+ELouxhKFXIpSJLnq+ts3eGvly5u0UUrUIlVH+9qmfF8gCHYVfkwCVkA3
	1rHGAmOpNuPxhbgE4LgP41EF/BHPuoXvqlLhIjIK70loTeHVEqtSOgpWTPffDj+2k4j5Uu
	yH2Tl5jAwrOmXP+gTCorRtptFxEihDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759405582; a=rsa-sha256;
	cv=none;
	b=XW+YdZ1R1PzPDm5ZvKzHAXhvT1n/dMdMH4SvSdrQB0Z3D1zeK9Uwq0taGFWA/WP6wrrThk
	t7IN8EH7/vvEYkTqePXa7E1LDYK6hRXsynsbtvItuv9xcbjkYdyj/Bxy+SguvvzyGFK2fq
	KG1f9kIhn6y1KyAlJc+6uHldjAucjlM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mi3cRH7p;
	spf=pass (imf10.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759405582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XAW7j/GiCX4Ldk1pbIGoe/EzygOj7TZ3MCMZKOX1tCA=;
	b=Mi3cRH7p6RrneizPkFD1UUmcP/8kW52kP1B1H+shuql/CWQyWO5psnvDED/c329CB7H2Sa
	aIcNpLSCzXvwIWZFQ0c0VpY75Q81h40OXqZXtgNKULr9S0yaAEOQ9EdamXKLkY2XNJvGZk
	EgGR8iqbrvKMQJHqkC75iiRwxVEYktg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-0ElKgZKKMTaiTW8-y-6wyw-1; Thu,
 02 Oct 2025 07:46:17 -0400
X-MC-Unique: 0ElKgZKKMTaiTW8-y-6wyw-1
X-Mimecast-MFC-AGG-ID: 0ElKgZKKMTaiTW8-y-6wyw_1759405572
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 494BD1956095;
	Thu,  2 Oct 2025 11:46:10 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (unknown [10.44.32.225])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83FCA300018D;
	Thu,  2 Oct 2025 11:45:51 +0000 (UTC)
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
In-Reply-To: <aNxsWYYnj22G5xuX@debug.ba.rivosinc.com> (Deepak Gupta's message
	of "Tue, 30 Sep 2025 16:48:41 -0700")
References: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
	<20250926192919.349578-1-cmirabil@redhat.com>
	<aNbwNN_st4bxwdwx@debug.ba.rivosinc.com>
	<CABe3_aE4+06Um2x3e1D=M6Z1uX4wX8OjdcT48FueXRp+=KD=-w@mail.gmail.com>
	<aNcAela5tln5KTUI@debug.ba.rivosinc.com>
	<lhu3484i9en.fsf@oldenburg.str.redhat.com>
	<aNxsWYYnj22G5xuX@debug.ba.rivosinc.com>
Date: Thu, 02 Oct 2025 13:45:48 +0200
Message-ID: <lhuwm5dh6hf.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: A8B88C0002
X-Stat-Signature: dff5mtxu1fgjo8eaiseo9nxm71tfhsdy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759405582-989479
X-HE-Meta: U2FsdGVkX18BZVNN5/H5NRifUqofq5mIA2sU10k0cihe/16+Uqa0Kh4lNx+Ts/YAXFckHIQx4MEy1DjhHoKmM+jl3tFiv6v/BmtrUVPqpkGR0vmR/quCbxGBxl/UN/v43qjKTtZ97Tw2wmsWegYzLmUIIKxKncbMAqp3Lx+ZnXThdreCJTWPxMvHvSoNx5GGPp5M83WhU7sw696x7sIV1dmYzeAuhUcbil+770yKxTi2qtvPm4ix+Y77y4whgyJDw2E15MyoTtWLqfcLVVZ5Q1ZV/v4u93jANW52bVR3pclIC4blF5n9j9zItFjp1ArSEFWln2QdqlKvHGPrDBbe6/ErgFtVYKr79AyS3CFGwqswnEuJkHvqy08wME6w/2f7TNNlxniyYpWvxvLkbtyiJVIGf4cPzt+YS8xT11H7OAM46pwFQMAlfmNemNHda38GBXSFxny7r3ARJYBMk36Cq6xOnivJmWZD5hZ198nnipzkBpiVCVxlA+h3Bn5pcfe3zAgrbwuMAtM8i3EZfI5w8LB5CRUhmKX/+eMGVKZZrYfqQ/sYn40V/i8cXO9O4qrd3n1OZ2UlcjxXcY6128gr3nSr50K/DREONzGs1E2tSfP0LaQn3NfqUINcbfiFacDRuDLqCgUWbombEgR0HuaWYE/fN+XSLl38KW8858RzA6T4exDoZavFBT1Zcf5GdVjjfh/b2CADCb4W2O7fbn1dV+1S/1JXlBatLeHyEBBnxY77teLQnhO3hNznTskfHRufe+9vBZvK3KC62lekJtd+GDyPW31ouYq/mVk4HR6FR1fqDfA6rSL5EHPxc9r9MNRkb75MYTz3g44UWscqqxemNSh7bTnTcxYqtRuM/GWl5bRQQU2WckRrniGFwhFispuVzbb6gW9SX5SXbDMBCjRnmXI2DlSYZCT1O6dwmFzznZOajPmsYooscSWQoq3cAqFlnUy8kkbCJSf3w05A0iw
 PdcuP2px
 nx9U/KUH/M59bYvcEmvzyIzaesaxHVd8uGPY5B6Je/QdmeV1lLyeWvrJOj21V9eWFdQwOjAbXNSgqMUlOUN5Gdtmm/vKkQc8xAXwwK4yDM6+sMSG1I2FYcCfpd9gTY+cWwDgpxyMT7QP1oiE9gB8pvxXl3zk1rhks5aEMKwTsR4L1gmolX18Cq+mR99xgfgSWQdBX35ynKcHsOE2ka49p1qLnWgT1D9DDNGseECVLYeL8uTZf83ejcVcH5++nU0ypmhMsdm0dFj+DsXlogNVRqFL+4qvqEd04gODOYlYMkeBb++THQl2/UGimkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Deepak Gupta:

> On Tue, Sep 30, 2025 at 11:20:32AM +0200, Florian Weimer wrote:
>>* Deepak Gupta:
>>
>>> In case of shadow stack, it similar situation. If enabled compiler
>>> decides to insert sspush and sspopchk. They necessarily won't be
>>> prologue or epilogue but somewhere in function body as deemed fit by
>>> compiler, thus increasing the complexity of runtime patching.
>>>
>>> More so, here are wishing for kernel to do this patching for usermode
>>> vDSO when there is no guarantee of such of rest of usermode (which if
>>> was compiled with shadow stack would have faulted before vDSO's
>>> sspush/sspopchk if ran on pre-zimop hardware)
>>
>>I think this capability is desirable so that you can use a distribution
>>kernel during CFI userspace bringup.
>
> I didn't get it, can you elaborate more.
>
> Why having kernel carry two vDSO (one with shadow stack and one without) would
> be required to for CFI userspace bringup?
>
> If Distro is compiling for RVA23 CONFIG_RISCV_USERCFI has to be selected yes,
> kernel can have vDSO with shadow stack. Distro can light this option only when
> its compiling entire distro for RVA23.

I think it boils down to whether you want CFI bringup contributions from
people who do not want to or cannot build their own custom RVA23
kernels.

Another use case would be running container images with CFI on a
distribution kernel which supports pre-RVA23 hardware.

Thanks,
Florian


