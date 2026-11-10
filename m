Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FCA60A380A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u1+vQ+IH
Received: by kanga.kvack.org (Postfix)
	id C2D1B6B05B3; Mon,  9 Nov 2026 20:22:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05C56B05B4; Mon,  9 Nov 2026 20:22:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B451B6B05B5; Mon,  9 Nov 2026 20:22:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6EA6B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:22:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1414340852
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:22:52 +0000 (UTC)
X-FDA: 85417460184.19.943013D
Received: from mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id DC7A51A0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:22:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u1+vQ+IH;
	spf=pass (imf19.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.5 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794273770;
	b=If/PpHb78i4X7kDvx7hOA60yKq7KhfO3JmCK9jM8ycJdxo2Glccvxx01/1Jz5j72iuc0mU
	r+NaQ7rEJUItvjEtcBcnppnvICvvt54uh8AI7ixIasLc4QwWamgTzMrDXSyfsj2nWjWCnZ
	bc+7LIIdteuqu2SphY81Uf/8oCZTYOI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u1+vQ+IH;
	spf=pass (imf19.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.5 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794273770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=D+N2QRZvzfe+CFAvIEo6YK7+9V99UHaC8NPIhonyKWI=;
	b=7/tg0BvgJ20TWLUImiGswSCDKN4E45WFinisr54+EWbLdG9lOitzLR9VZf/lb92QWWAzFQ
	aurbTWnYZj/w6heWMYhZRxM0wTukh9mGk4enJZIa+1dA361wIhXNxHMZ/g2pJcI8oO6Vau
	3gmvCGDN2oS9arF0/V93fjn1Hst9O+8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aonwTnaVCS6JFQJm6qDOQX7pACUW5lsxK/707tA3EJM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794273768; v=1; x=1794878568;
 b=u1+vQ+IH3bB2gezV08+6cO0uTX02FrG5KALC3OLqIChFlm8vuk21aDXD+6oeTBssKnxOW+i+
 qjAAhymLdXgIkC5wBC6nlSHSmDRWMakSPkb9JFUpSBqCRy0ybrqgdpdos6hjbN1gUkKybsZ0UvR
 jQdHrphNv/s7dyerw+L1geAY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5640507009fcdc41;
	Tue, 10 Nov 2026 01:22:47 +0000
X-Mizu-Trace-ID: 5640507009fcdc41
X-Migadu-Flow: FLOW_OUT
From: Vineet Gupta <vineet.gupta@linux.dev>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	peterz@infradead.org,
	mingo@redhat.com,
	will@kernel.org,
	boqun@kernel.org
Cc: longman@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	ast@kernel.org,
	andrii@kernel.org,
	daniel@iogearbox.net,
	acme@kernel.org,
	yonghong.song@linux.dev,
	eddyz87@gmail.com,
	martin.lau@linux.dev,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	llvm@lists.linux.dev,
	Vineet Gupta <vineet.gupta@linux.dev>
Subject: [RFC PATCH 0/2] percpu, local_lock: drop btf_type_tag where no compiler records it
Date: Mon,  9 Nov 2026 17:22:33 -0800
Message-ID: <20261110012235.1024461-1-vineet.gupta@linux.dev>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DC7A51A0005
X-Stat-Signature: bsm96m7mk3b7n6qpt4gyi8cyn68t7m9g
X-Rspam-User: 
X-HE-Tag: 1794273769-705153
X-HE-Meta: U2FsdGVkX18gsbCMCgDjyDyZTXaFiKgkYM4PnVXyPuqY2sVjRocAhNsHEmU8Pq7PULNF24umMMt61haqcbttXaldrX0OsU7rKPwyCsiRp3g9Cdv0hAh511ErD4l6m3FVQjX68O75VAKDcuUFTnDY5J+99hYZZ6EX4VOMtBSgzyBYgH2+K12EsEHLwFsTOGZPElS61bC9U9mtAnNXjvv/DtO3jFZJ5IR5hUQu9hTCheBp8hknH49Zxt50xYJUl11f92GHxjHUNX5aiTiXrM0m9/LX8aqog77h/oDYNImzmFKegryxu3RC1FuwlvZyzOhjzkjjXdmvqwKHtnx03yjv4/gxOalLnVQJR8XURG15eFl6nAEr02DPtE8E1slRgg+xKBnuy3jXHP+SPCsvM9P22C1aHTuCqT9yY0r+PPB5T1XK2Bi9ETpwp7UrxwwbVbMo7oOD4l7fjpDm8VmeJQwLod7nQpcZVyTU+zwagdWQ0N5crLL/Qn7hSqCKKYh7J1rpwKdp9RrED0ORiKxvGpi7HjhOF1H3eJPRVZLSoMD5EUzW8NNIlynB/cuc9N4pyRLHgbihSE0tOBxLpQ9ShdBjUdBhjKUwOtD5Rv4SAVA4cfx15l0kun3Nk4J0x8hd1Afpd/R9+Im2VfB68dalcvGzLixK9g2FxUp+Z9XtaGnlC0aAeg9X0hdSOPvf+L3eG+QuOeQmkPqBiEVP3I5HIzM5xAAghNQJJhUUJvbk42lguTroPOqQZhIQbP3SMGvUltYrhloq9T6HM6425H2500iVke+4fWf1iwEoSNctcV9z+nK4akhKiIcKZ4YsFTwSie1XyX1RaDcttZJu+o5LnXG8fku3f4jxL96FEHyz9j7+0SZEjPCpoVXCcV2AXNx/i3oY0a2HLsEFSWZvi6l80X8c7/kOswdEgeXX3BPDTR+/OxDovrOgCbDFyP6thnbeevfkWOdaO28/g5uSyReA9A3
 Tw/Qg++h
 8cGfinMIys0rHXnYxKp0zT246q1jbEvRg5eT/POw27D0N0uOLMpB/efu7ESLG+LUxNga5M/g8NuM8G+McBekRUJUxV5zaX1LPJURL0eBjLUa4sIzo/KSN5U8UxrZuARWA01U0gRGEfFzax+TBZ45kQwEVyyailVquUy/01lxB5gI9yTZ1YQugG5QtyupnUctXfoBrMNmgBmDe1jxfvODOryBbBUf4tAwCMDmFQAx64HaSPMeYEdfo30j1OKG/W8u2alE+pu81k1NSKB0/In04aeSKsRNONgsDQqZv3abzSNGWNATfnG3LTo+MfzC0kCPfU9vncBNiwydHyuVI6uSumYCz3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Currently PAHOLE_HAS_BTF_TAG is gated on CC_IS_CLANG and the goal is
to allow CC_IS_GCC. There are GCC fixes (PR128479, PR125991) in the
making [1] but despite all of them an x86 defconfig still emits ~40k
instances of spew like:

  arch/x86/include/asm/processor.h:232:36: warning: ignoring attributes
  applied to 'struct cpuinfo_x86' after definition [-Wattributes]

where one is enough to break a -Werror build.

Making GCC stop warning here was proposed as PR128480 and rejected:
the suggested answer was -Wno-attributes, which the kernel would not
accept just to suppress this noise.

And even if warnings were to be ignored, the build would still fail
with 33 hard errors from a separate GCC bug, PR128477,

  include/linux/percpu-defs.h:216:45: error: initialization from
  pointer to non-enclosed address space

These come from the same tag on the same declarations, so this series
removes them too.

The root cause is where the tag is applied. BTF_TYPE_TAG(percpu)
records that a pointer points to per-cpu memory, but two places apply
it where the thing qualified is an aggregate, which no compiler can
tag (GCC or clang): every variant of an aggregate shares one DIE,
so there is nowhere to put it.

  - __PCPU_ATTRS(), so DECLARE_PER_CPU() and DEFINE_PER_CPU() put the tag
    on the per-cpu variable's own type;
  - the type argument of DEFINE_LOCK_GUARD_1() in local_lock.h, which
    cleanup.h turns into "typedef _type lock_<name>_t".

Nothing reads a tag in either position. The verifier matches "percpu" in
btf_ctx_access() and in the member walk in btf_struct_walk(), and both
check btf_type_is_ptr() first, so it only ever sees the tag on a pointer.

The aggregate case is the only one that warns. Where the per-cpu variable
is a pointer there is no diagnostic, but the record is wrong: GCC puts
the tag on the pointee, so

  static DEFINE_PER_CPU(struct bpf_hrtimer *, hrtimer_running);

comes out saying hrtimer_running is an ordinary pointer to per-cpu
memory, when in truth it lives in per-cpu memory and points at ordinary
memory. clang records no tag there at all.

The following two patches address this:

 - 1/2 provides a new variant of __percpu, __percpu_var which elides
   the btf tag. Switches __PCPU_ATTRS to use it.
 - 2/2: Applies __percpu_var in local_lock code.

Binary impact, x86 defconfig built with clang: patch 1 drops 280 BTF types
(140 TYPE_TAG and the 140 pointers carrying them, none referenced) and 3360
bytes of .BTF, with .text unchanged. Patch 2 changes nothing at all.

[1] https://inbox.sourceware.org/gcc-patches/20261109213600.772524-1-vineet.gupta@linux.dev/

Vineet Gupta (2):
  percpu: do not put btf_type_tag on per-cpu variable declarations
  local_lock: do not put btf_type_tag on the lock guard type

 include/linux/compiler_types.h | 8 ++++++++
 include/linux/local_lock.h     | 8 ++++----
 include/linux/percpu-defs.h    | 2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

-- 
2.53.0-Meta


