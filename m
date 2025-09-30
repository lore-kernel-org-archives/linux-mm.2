Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F288CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 09:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21D6B8E0006; Tue, 30 Sep 2025 05:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD978E0002; Tue, 30 Sep 2025 05:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD378E0006; Tue, 30 Sep 2025 05:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E86A78E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:21:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A178311A9A3
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:21:07 +0000 (UTC)
X-FDA: 83945372574.10.3C46460
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id C118BA0011
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:21:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dCBfiAUY;
	spf=pass (imf25.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759224065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lQSfvfcTNySF441awH7y9u1KuhzkH5FEbQXswdQdkk=;
	b=r2f55KPu/eFIAfqUmYgghiooPp7cujFtvgH3p4INAA8BNmyPrBDyyaZBhUwFHo1suZ3tvO
	WnwcWRbJypYojXAV2PzNkSy3i0MTexDxMfUvsvhIaNIaRwr8PpN4BzHm+hME8pt0GWl5lQ
	Hbhic9/a7iv30MRGkqCOYIH3ldqL7dc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759224065; a=rsa-sha256;
	cv=none;
	b=70BKYknqKPQxiUTuRiXwVNm6detwLwVn4JQ+z/p3WKJNRMYW+YmsS+6w7U+9U82ucNWxbZ
	AERqeM1f/DMbX1RufU/q4P023nf4ra2HymBsimJFfjSUF7Un31zC4W5pYyWERr6RghVByp
	vuww46krO0/hR1UeStIV/maczdhiJ40=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dCBfiAUY;
	spf=pass (imf25.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759224065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9lQSfvfcTNySF441awH7y9u1KuhzkH5FEbQXswdQdkk=;
	b=dCBfiAUYXD3DPX1TFJ4iyuh/Brv9gFFFXKSyD3N75oER7cdyq3DLG8s+9J/LytHsyaoQZg
	M1IfeNhTJJjX/gdISdPcZsA2GrMgNlyl7bBZAx6lY7XCBfq3dyi9SKYgupD2ATr158vCB1
	nFvIfH7qUjvFer17Qkd8493ZP+PUliU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-90-34emJvPvN3m5oBvcOsfJzQ-1; Tue,
 30 Sep 2025 05:20:58 -0400
X-MC-Unique: 34emJvPvN3m5oBvcOsfJzQ-1
X-Mimecast-MFC-AGG-ID: 34emJvPvN3m5oBvcOsfJzQ_1759224053
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B5A218004D8;
	Tue, 30 Sep 2025 09:20:52 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (unknown [10.44.33.56])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 051C1180035E;
	Tue, 30 Sep 2025 09:20:34 +0000 (UTC)
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
In-Reply-To: <aNcAela5tln5KTUI@debug.ba.rivosinc.com> (Deepak Gupta's message
	of "Fri, 26 Sep 2025 14:07:06 -0700")
References: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
	<20250926192919.349578-1-cmirabil@redhat.com>
	<aNbwNN_st4bxwdwx@debug.ba.rivosinc.com>
	<CABe3_aE4+06Um2x3e1D=M6Z1uX4wX8OjdcT48FueXRp+=KD=-w@mail.gmail.com>
	<aNcAela5tln5KTUI@debug.ba.rivosinc.com>
Date: Tue, 30 Sep 2025 11:20:32 +0200
Message-ID: <lhu3484i9en.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C118BA0011
X-Stat-Signature: 7yi8ced1sys3nkg58iz657qxteztk1w6
X-Rspam-User: 
X-HE-Tag: 1759224065-290390
X-HE-Meta: U2FsdGVkX19CdntTzPj3E4G8Q9A1/ukLkx3uuxa4MkFptEhTr5QenWpgwk++TNwDMQZTOzwItaoachs9Ik+k2F9/fuvyIqFbbHpI5a4ZouT7SMyJXUj/Ta1XRL92pgxnG7Dj3TO+eVchZQbths+P1+yYmRQdkNcU+8/+IQfeOVpr9D/S/8/SSgXyVSW/HxbPqUAdelVAo6CWs1M63k17utd/VhMmYbUYz8Y6jxfr8eoHbqWIimK60XnhM7QuEmmiKcbcpKsgZjqL8hiAC7JU4u1PDt2w0CXDzlh3Oor/pBq/ATiweUZlLD7gehrogiLhdZjTMVz5/Q/S5LvLeM48y+8tm1swtWlnHAcsAq1y7mJnC6l/fFVhGju/8+EJ0QmT8p0bhB4naagpKNKkpUicNdvjifCeAYcszjbDiYT2otTxWxr+C/Z02jae7pswGIp8hujdf1Mhfx5RBV7ycmTSaartxO7r6SD2zAMycirJOzXMXu8JyqHIt4EJq8TfBtM0Mykw4V9XPcdg8e4ytwakXwI4nwGUwm9PCjErqO/Z9qdMblqWGfXvBHvol2ufAhBNXDG4I476j9TSdnSe8OLg9gs+r/UqgIB2Q5Jhk1F1ngInQLJnUsFULqijnKvUqC0Ayazhv150ucHyxs+diMuUqaLWLF40ooQew9p9Fm0lrAKhHe2ChXZZfNAkkq9XA1BPpv2KHD9UH+rlEjo8JxDjY/l/xFOBLRDT43uUuzQtv+MwXXAE3tbtuSHano4Rv3w2updmaSOv69Z5rJFDEqT7KDfhpz+gQhHjaTmKOMD8qlg+uaaN2vQUTxE9eQkYN/ppkzYMR0+Px1CR1cODiMM5AiQm/xreAtSqgLLwL+62HBsq8fb0MvKm/Txv1/6ZQxxa92B/o8EfrcfakHzZdrBVy5Ao0TK8pQfbhkQmkjuwlqX0itDEGWvONC0DHyoVvcxpE/xqR1/zBLanSEwicaT
 OaxMmTmf
 OF92PYpcX1NJRF9oltIYdPKEE/6N6J3RFsxRhX+SUq611KuNEFysaG5qZstVgoGlQQ/exgOl2SUJ4YLboTp+G0h1yBkffWEyLeIFZfT/mRl3Z+J0KZyan1TK0KOh/5mml0LytYaew9tlZy6L/NMrPHFoJ1WhQbCeCMj4zHfNlwieqHqbETna7b/tCUQaby7/ojdKOkjLS1gTkxe0JdNJKlHAcWaaBe2K7mwNSY4M5Ft8AJ1GUT8PwxtIAVfW9fZkif0Ztd4zNO1RzuGsyfcqubWx4xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Deepak Gupta:

> In case of shadow stack, it similar situation. If enabled compiler
> decides to insert sspush and sspopchk. They necessarily won't be
> prologue or epilogue but somewhere in function body as deemed fit by
> compiler, thus increasing the complexity of runtime patching.
>
> More so, here are wishing for kernel to do this patching for usermode
> vDSO when there is no guarantee of such of rest of usermode (which if
> was compiled with shadow stack would have faulted before vDSO's
> sspush/sspopchk if ran on pre-zimop hardware)

I think this capability is desirable so that you can use a distribution
kernel during CFI userspace bringup.

Thanks,
Florian


