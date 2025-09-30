Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9326ACCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 11:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33D48E0005; Tue, 30 Sep 2025 07:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10E18E0002; Tue, 30 Sep 2025 07:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C210E8E0005; Tue, 30 Sep 2025 07:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB9008E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:16:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5725813B72E
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:16:08 +0000 (UTC)
X-FDA: 83945662416.22.BA3B058
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9382E20010
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:16:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AyyYubM0;
	spf=pass (imf13.hostedemail.com: domain of fweimer@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759230966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZEOnnvfg2VP9jFylWLMcLAcGpm2F4oh7aBv+d9st9Ec=;
	b=64wq4xbjSr7EElLMukjAQkVlXJwWJNVIooiWWEKUj5pDsY6gt3QBCXtR03W6rHQXrPRPqe
	cIi+4NdviaHhPBRyeYKUSXXXQ9jzuLJ/gaumMDVVx307fyIj1eVOif5YZR406L5ZWJ0xG7
	NGkB/jRVw3LcygTnNX0NPQVe+9oaTfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759230966; a=rsa-sha256;
	cv=none;
	b=kPks7ID2iUoZ6uAH2ZgrWXOndmsCJL6gJpwt8Jj6gIjbqThSUdWewXt7izSV4doLddzXgp
	uutc+dxOSaF3Q0SgwxLAeaJ/NBfKY6Nr60LAlayDY2xC5eDuTMoRHFp2mMSZQbLtosPY/Q
	Y9LOYu3/YtsTuoTh7E3SyfittW1+I+w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AyyYubM0;
	spf=pass (imf13.hostedemail.com: domain of fweimer@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759230965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEOnnvfg2VP9jFylWLMcLAcGpm2F4oh7aBv+d9st9Ec=;
	b=AyyYubM0ZzPlEtrocgoah2Kq7pCp3lBdF39hU2gmcdC3bHaHqKdxGJsaiQdn+Tcr6xHBM2
	Hs1svg14XyLOvoeDAB676kKcEa04jVhVRcZ2qnRr85MZs9ktYkY/cOnqKGYO1WJLcU1Mum
	xxA2dAClEBLfc1Dt0f0R9VsR/lGZBis=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-rJUdj_0aOK-QG4zQjk5sLg-1; Tue,
 30 Sep 2025 07:16:02 -0400
X-MC-Unique: rJUdj_0aOK-QG4zQjk5sLg-1
X-Mimecast-MFC-AGG-ID: rJUdj_0aOK-QG4zQjk5sLg_1759230956
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EDB9195609E;
	Tue, 30 Sep 2025 11:15:55 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (unknown [10.44.33.56])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 018161800447;
	Tue, 30 Sep 2025 11:15:34 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Deepak Gupta <debug@rivosinc.com>
Cc: Paul Walmsley <pjw@kernel.org>,  Thomas Gleixner <tglx@linutronix.de>,
  Ingo Molnar <mingo@redhat.com>,  Borislav Petkov <bp@alien8.de>,  Dave
 Hansen <dave.hansen@linux.intel.com>,  x86@kernel.org,  "H. Peter Anvin"
 <hpa@zytor.com>,  Andrew Morton <akpm@linux-foundation.org>,  "Liam R.
 Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,
  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  Paul Walmsley
 <paul.walmsley@sifive.com>,  Palmer Dabbelt <palmer@dabbelt.com>,  Albert
 Ou <aou@eecs.berkeley.edu>,  Conor Dooley <conor@kernel.org>,  Rob Herring
 <robh@kernel.org>,  Krzysztof Kozlowski <krzk+dt@kernel.org>,  Arnd
 Bergmann <arnd@arndb.de>,  Christian Brauner <brauner@kernel.org>,  Peter
 Zijlstra <peterz@infradead.org>,  Oleg Nesterov <oleg@redhat.com>,  Eric
 Biederman <ebiederm@xmission.com>,  Kees Cook <kees@kernel.org>,  Jonathan
 Corbet <corbet@lwn.net>,  Shuah Khan <shuah@kernel.org>,  Jann Horn
 <jannh@google.com>,  Conor Dooley <conor+dt@kernel.org>,  Miguel Ojeda
 <ojeda@kernel.org>,  Alex Gaynor <alex.gaynor@gmail.com>,  Boqun Feng
 <boqun.feng@gmail.com>,  Gary Guo <gary@garyguo.net>,  =?utf-8?Q?Bj=C3=B6?=
 =?utf-8?Q?rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,  Andreas Hindborg <a.hindborg@kernel.org>,
  Alice Ryhl <aliceryhl@google.com>,  Trevor Gross <tmgross@umich.edu>,
  Benno Lossin <lossin@kernel.org>,  linux-kernel@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  linux-mm@kvack.org,
  linux-riscv@lists.infradead.org,  devicetree@vger.kernel.org,
  linux-arch@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  alistair.francis@wdc.com,
  richard.henderson@linaro.org,  jim.shu@sifive.com,  Andy Chiu
 <andybnac@gmail.com>,  kito.cheng@sifive.com,  charlie@rivosinc.com,
  atishp@rivosinc.com,  evan@rivosinc.com,  cleger@rivosinc.com,
  alexghiti@rivosinc.com,  samitolvanen@google.com,  broonie@kernel.org,
  rick.p.edgecombe@intel.com,  rust-for-linux@vger.kernel.org,  Zong Li
 <zong.li@sifive.com>,  David Hildenbrand <david@redhat.com>,  Heinrich
 Schuchardt <heinrich.schuchardt@canonical.com>,  bharrington@redhat.com,
  Aurelien Jarno <aurel32@debian.org>, bergner@tenstorrent.com,
 jeffreyalaw@gmail.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
In-Reply-To: <aNQ7D6_ZYMhCdkmL@debug.ba.rivosinc.com> (Deepak Gupta's message
	of "Wed, 24 Sep 2025 11:40:15 -0700")
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
	<f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
	<aNQ7D6_ZYMhCdkmL@debug.ba.rivosinc.com>
Date: Tue, 30 Sep 2025 13:15:32 +0200
Message-ID: <lhuldlwgpij.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tzcDnRyXj43uxE8_LTukZSeLBEwLSEo1UNL4YvuGPYk_1759230956
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Stat-Signature: pu5o8iyi7h51mku6zqwxies6bp56oboc
X-Rspam-User: 
X-Rspamd-Queue-Id: 9382E20010
X-Rspamd-Server: rspam10
X-HE-Tag: 1759230966-999483
X-HE-Meta: U2FsdGVkX1/yF/RC9U04KluU1PoLFCHLTAI4lxChn46ZOPioOOM0pnGvcef6kiqAHuJ40h2fED2+0NPurbMCUeaQveeedWyXQ8JjccIVcloi9rq5z1t9tqD1u5O8Odah3Bu4DFjFf3FcaA3qezP1hLl01tFZhn9RElFB1PcVnP7Ww3/daAuHcSjUEkARQ2azd6TwYrA/c/pSoV9VjJ+42rMgOlwVQzYC1gO3DeQmQw8YMY47O4yeCOphYLvyeOLvB1T/vuYY6LVCt3y1NCQf8FdGJwYLLWuWMpsDlj8u0Vx27AYPDFBGoLNvUHk7ixsimqIng+e2/5RSX375sHYrlj4oxVfTj0OXIFTCmlMBPt2BP+xIgT5JekmoRIfoz1BDG7ZlD77Lwgsyt1b/IZP3rTYtKl8iwkHV3GNT9ddIIPyIv8m6Wi1lFpk/6EtD1GSz2M6qHilrGbN7oNF/VQiIUCK/mwXPuQETuTIQsglSEySKLJvE3CNtL9U5fGchyNdoMt466gvGgcwn0Piy3uLjZ2JIistYuIdkGyBnA7sfQaxjKH16XKFBab5KyGgWWWunHy8n75rGqkYNvFHSasllFRb6/0XmqE1d8Lr9jM0dncp8Baw4S/AGfkdvaBypjJDDXkEfuKOX4hV9LNM55TZnWXjk1UVuhwmSLE/crv4hf8oy++MNUj3bk5uj7i9YclqB+9iyuP33lsoHTfKGVNl/BtOg8ibW9VXMflTPAKTdUULUA9BeYnOp3OZx/+t5X071GcneYj+6QVwkA8mhaT2y+sxTvxRdHWwJcdy6xjILwktjsmFz3aMfSzgBKPloiw40isA+c6rj8F6/aPL70WmQQrn/0IV4KKNrMT+FmkXVH+rudzGrnzJLmkESe23v/cXXJNnu3P78Mhk8a0DzJewEzcmgNI6cPOP29G3u4CqdSEZofITofSfa1nJHmWSdknVE8uRyf+3sjJqL1mJ2luf
 ZM/oyPV3
 Z/2Xb34UzokU9/sPqXscwCXoMCAJJdsxRe4v4jR5YM4Y2+B7lNZ25F1DwfTaWw4ZB0l8q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Deepak Gupta:

> Any distro who is shipping userspace (which all of them are) along
> with kernel will not be shipping two different userspaces (one with
> shadow stack and one without them). If distro are shipping two
> different userspaces, then they might as well ship two different
> kernels. Tagging some distro folks here to get their take on shipping
> different userspace depending on whether hardware is RVA23 or
> not. @Heinrich, @Florian, @redbeard and @Aurelien.
>
> Major distro's have already drawn a distinction here that they will drop
> support for hardware which isn't RVA23 for the sake of keeping binary
> distribution simple.

The following are just my personal thoughts.

For commercial distributions, I just don't see how things work out if
you have hardware that costs less than (say) $30 over its lifetime, and
you want LTS support for 10+ years.  The existing distribution business
models aren't really compatible with such low per-node costs.  So it
makes absolute sense for distributions to target more powerful cores,
and therefore require RVA23.  Nobody is suggesting that mainstream
distributions should target soft-float, either.

For community distributions, it is a much tougher call.  Obsoleting
virtually all existing hardware sends a terrible signal to early
supporters of the architecture.  But given how limited the RISC-V
baseline ISA is, I'm not sure if there is much of a choice here.  Maybe
it's possible to soften the blow by committing to (say) two more years
of baseline ISA support, and then making the switch, assuming that RVA23
hardware for local installation is widely available by then.

However, my real worry is that in the not-too-distant future, another
ISA transition will be required after RVA23.  This is not entirely
hypothetical because RVA23 is still an ISA designed mostly for C (at
least in the scalar space, I don't know much about the vector side).
Other architectures carry forward support for efficient overflow
checking (as required by Ada and some other now less-popular languages,
and as needed for efficiently implementing fixnums with arbitrary
precision fallback).  Considering current industry trends, it is not
inconceivable that these ISA features become important again in the near
term.

You can see the effect of native overflow checking support if you look
at Ada code examples with integer arithmetic.  For example, this:

function Fib (N: Integer) return Integer is
begin
   if N <= 1 then
      return N;
   else
      return Fib (N - 1) + Fib (N - 2);
   end if;
end;

produces about 370 RISC-V instructions with -gnato, compared to 218
instructions with -gnato0 and overflow checking disabled (using GCC
trunk).  For GCC 15, the respective instruction counts are 301 and 258
for x86-64, and 288 and 244 for AArch64.  RVA23 reduces the instruction
count with overflow checking to 353.  A further reduction should be
possible once GCC starts using xnor in its overflow checks, but I expect
that the overhead from overflow checking will remain high.

Thanks,
Florian


