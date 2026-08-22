Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA88C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 16:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387706B0095; Sat, 22 Aug 2026 12:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339506B009B; Sat, 22 Aug 2026 12:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227D56B009D; Sat, 22 Aug 2026 12:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F19636B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 12:50:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F68B1A0159
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 16:50:39 +0000 (UTC)
X-FDA: 85129494198.30.98F9776
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0410480002
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 16:50:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of whitebox@nefkom.net designates 212.18.0.9 as permitted sender) smtp.mailfrom=whitebox@nefkom.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787417437;
	b=bxef1jh5Iu2Y6lPx0X76L/An9NmLKVJCrur7geQ3HVrHB/dREXBAat1SEeXknd8/fCquO+
	F/6AJzSi2x8dh9s4VJE7Vqrtc5w8LNf3mh+bYsH67Cva/gvNQmI6FfFGnvLKDsV0Jkh95b
	DKzR5eC7y8pI6//fblFFe3dCXlzn3S0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of whitebox@nefkom.net designates 212.18.0.9 as permitted sender) smtp.mailfrom=whitebox@nefkom.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787417437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XNKqe4B/drntFpqC9zQm1IIunGsYcnQzk8g9/XwlYvE=;
	b=RJ88+w8nNgdq/LmoRjzCE55OXUth/GgEhQU16N17eUl73vOrpYrZYMk40xEi7Ksy988/Qc
	90cRaagzzDPkgQ70mJcqKEpWEiVhFZP5AFXnOUYEMrfvtJWP5tjZM70x7W+kPYq3r93IGo
	ejeDDzV1ZLxpKMiTv73SDNOsw/ddhg8=
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mail-out.m-online.net (Postfix) with ESMTP id 4hS38C1WYJz1r6RW;
	Sat, 22 Aug 2026 18:50:35 +0200 (CEST)
Received: from frontend03.mail.m-online.net (unknown [192.168.6.182])
	by mail-out.m-online.net (Postfix) with ESMTP id 4hS384666fz1r6R5;
	Sat, 22 Aug 2026 18:50:28 +0200 (CEST)
Received: from localhost (dynscan3.mnet-online.de [192.168.6.87])
	by mail.m-online.net (Postfix) with ESMTP id 4hS3841brWz1qqlZ;
	Sat, 22 Aug 2026 18:50:28 +0200 (CEST)
X-Virus-Scanned: amavis at mnet-online.de
Received: from mail.mnet-online.de ([192.168.6.182])
 by localhost (dynscan3.mail.m-online.net [192.168.6.87]) (amavis, port 10024)
 with ESMTP id rZELxZgBWMic; Sat, 22 Aug 2026 18:50:23 +0200 (CEST)
X-Auth-Info: OL3cYjbU1r+qfm2QpDKq9gsFcdK7pEagtpeOPHg4Dj+AVcv3aYERNAi5TjJCOgP7
Received: from igel.home (aftr-62-216-202-215.dynamic.mnet-online.de [62.216.202.215])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.mnet-online.de (Postfix) with ESMTPSA;
	Sat, 22 Aug 2026 18:50:22 +0200 (CEST)
Received: by igel.home (Postfix, from userid 1000)
	id 349732C0AF8; Sat, 22 Aug 2026 18:50:22 +0200 (CEST)
From: Andreas Schwab <schwab@linux-m68k.org>
To: Deepak Gupta <debug@rivosinc.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,  Deepak Gupta via B4 Relay
 <devnull+debug.rivosinc.com@kernel.org>,  Thomas Gleixner
 <tglx@linutronix.de>,  Ingo Molnar <mingo@redhat.com>,  Borislav Petkov
 <bp@alien8.de>,  Dave Hansen <dave.hansen@linux.intel.com>,
  x86@kernel.org,  "H. Peter Anvin" <hpa@zytor.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>,
  Vlastimil Babka <vbabka@suse.cz>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  Paul Walmsley <paul.walmsley@sifive.com>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Conor Dooley <conor@kernel.org>,  Rob Herring <robh@kernel.org>,
  Krzysztof Kozlowski <krzk+dt@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,
  Christian Brauner <brauner@kernel.org>,  Peter Zijlstra
 <peterz@infradead.org>,  Oleg Nesterov <oleg@redhat.com>,  Kees Cook
 <kees@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <shuah@kernel.org>,  Jann Horn <jannh@google.com>,  Conor Dooley
 <conor+dt@kernel.org>,  Miguel Ojeda <ojeda@kernel.org>,  Alex Gaynor
 <alex.gaynor@gmail.com>,  Boqun Feng <boqun.feng@gmail.com>,  Gary Guo
 <gary@garyguo.net>,  =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,  Andreas
 Hindborg <a.hindborg@kernel.org>,  Alice Ryhl <aliceryhl@google.com>,
  Trevor Gross <tmgross@umich.edu>,  Benno Lossin <lossin@kernel.org>,
  linux-kernel@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-mm@kvack.org,  linux-riscv@lists.infradead.org,
  devicetree@vger.kernel.org,  linux-arch@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  alistair.francis@wdc.com,  richard.henderson@linaro.org,
  jim.shu@sifive.com,  andybnac@gmail.com,  kito.cheng@sifive.com,
  charlie@rivosinc.com,  atishp@rivosinc.com,  evan@rivosinc.com,
  cleger@rivosinc.com,  alexghiti@rivosinc.com,  samitolvanen@google.com,
  broonie@kernel.org,  rick.p.edgecombe@intel.com,
  rust-for-linux@vger.kernel.org,  Zong Li <zong.li@sifive.com>
Subject: Re: [PATCH v23 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ
 | VM_WRITE
In-Reply-To: <CAKC1njRapOxS6ibQdCuES1E3aAjsA+yGz4yZ1xJAZHU2vkAm_A@mail.gmail.com>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
	<20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
	<87jyslndo4.fsf@igel.home>
	<CAKC1njS=AHu6uHrH4ae8VxcdEbhgiPXYCAoN3F_mnppBd3SwOA@mail.gmail.com>
	<875x44o9hj.fsf@igel.home>
	<CAKC1njSn_rtCj8ii876PNQTk0nsCTfWsb4DzdymufHVthh1Rkg@mail.gmail.com>
	<871peqgp9v.fsf@igel.home>
	<CAKC1njR+dTdvp+BmLGPtgd8dufiUwBtkQ9a-qinELT_Fmi13sQ@mail.gmail.com>
	<87wlwif04z.fsf@igel.home>
	<87tsrli6lt.fsf@email.froward.int.ebiederm.org>
	<CAKC1njRapOxS6ibQdCuES1E3aAjsA+yGz4yZ1xJAZHU2vkAm_A@mail.gmail.com>
Date: Sat, 22 Aug 2026 18:50:22 +0200
Message-ID: <878q5y6qwh.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 0410480002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ru6yap75iz8zswujw9wrub8xydc5q5eh
X-HE-Tag: 1787417436-634536
X-HE-Meta: U2FsdGVkX1/S90uW4vOcFCMy+yAxGXS1moppOeg3iiRzxad+W2emycNKBUcTzOycOr7uPvSAe0rXRW83x6jqfQ4lsUXMVtG2gYo0Vi2Yezchm9iyedGzTscNDDLW9G4QyILH0seGxsUN+sOyBPkOuJXpvGcMSO+Z7+zdq5B+0FGg9a2Vmm48is7AojWuRYnc7iNNHrhrFm6eg6/tax9pt2h8xQ9ePIzxsjXxbK8pg9JP2fnWOh3dhmZCX80B3rt+vc65J922eGBwa354OeV4cLnRpjKPdzKRopqo94WKKdVyaYW+0Hoh5VtcHSKhQI9QYRi8pgz+hEY1v739g/vD9eNvfoQKgNjW8FkWQeAC73Cnr3A0Ueahb2SJts5T+f+phKVpyGaHLTsZ84Sifu9KwnzZLBQn2JNfCMGWMcTwmslMfGybJ7Y99mQ60sN6jj+utvZkYvkudkpw+dCWYk3NLEhy8Nn7I8wgM8ETSYFilOdfuqS8OqgHRDkF3VBX8oFYYpJLxryAUT3zq6hIo3gbwjbMJ+h+v1BRxSD4/+btIjjX1AZ2aOUYOsTqZuQNCIUPTlFUKdL7yrREhib4UunZCtKE8iw7SzIhrwKkqxGDYVG7YOlLmXSR0L/XjaTJGcOYR9BBOKfUv6dsR85WnvnXBxeSH4IvZiQWRwdeQ2BKLW0PxC4abXxdOC81DeIsLljgniepN8Gtj2QKGd4hBBtfQ32TO6/pvUuU0HKUDSgz/ruLc7EFh6BxVHgpTKw1rLhz3OOCSl8liCUV2wg5Y9XlcBPcVDgyLV0ax/2uzhFoUzGiV3pyjL4ehWbDfQfdsfHtZoaqBVGwPyNMvPARdQefuVLzVyfbfI5OUYYSwr3BxZZZZUawzaAnkqWGwI+BCj3brOfhHEIgs3xpV/e9IwG2uGlqXUGCrWngJygRYC8ysUVEJPTGPmIUHtm/LkQWEigj3SlLP4YUJ3wuQfAxawf
 XojXQj4N
 wbcuXAFYwk1XP1yiXR5UHuaeEn6yy6ll4UQDou44jDYaY+dy4RVyRrqMoV0OfXEodXWXDeY9eWXTJ/NAxjvQpypPs021ap9YAYw+iwB4RpQkKw/SDwvHs8709e++nAgjz4u9vteUqJxANMkzXqQK5LtHkkXxtw1XRr5dvMhF3HkB8jvzwQE2E6jrmFH02jpbvbuAhlOjS2L524927WqGlXOlcHSShS03H2z2ohJovUm7+lnzxLfxe/aLqlIHJWWoJRPE5FRrPIFrXjOXUvzK9a5np2mXF2m3RO8IKx4/y5KUkFN5AALq2HcbyQAvSi5qGNvY2zAadZSI8UaSNTeKb5BhXIp7+dl5N2phJkuwOVzy+cK3aM3cPnpOcMPZqLBhOppQOOHa1Ix5PfyEYMjabOds8N4vz2pM4yOIOkeZHqhfAdDqLdMylNdEGhmXtYJEdpkMGOVz13SVIAgbfDQQZ6YYjWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Jun 02 2026, Deepak Gupta wrote:

> I'll send a patch. Thanks.

Any news?  It's still broken in 7.2.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."

