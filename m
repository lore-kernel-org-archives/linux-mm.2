Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C7AC87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 16:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1958E0002; Sat,  9 Aug 2025 12:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074B28E0001; Sat,  9 Aug 2025 12:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5808E0002; Sat,  9 Aug 2025 12:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D718C8E0001
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 12:04:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 640FC115950
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 16:04:58 +0000 (UTC)
X-FDA: 83757692676.04.AF8723C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 80FAA180007
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 16:04:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ECe6DyMN;
	spf=pass (imf16.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754755496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxzZXZ9khqyL8fNdwVgMsrfFG2YXiwPF3nzkdXzjMeA=;
	b=KG/VPwQakXxrMzLYBungtFCRPzKwqd+C2gsbIe3VSDIRywgLQfekv1hKEYHlfoUN+24w69
	/oUeg44r+K83bJc7kJ/5rtkTwPfyqbvEharV2EcLCIJ2vVW6RUTtH/nQ+Gt4IZd4aX78bf
	Yc9zHYiMfg87ZAxLmZKsvtXitr5HwKU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ECe6DyMN;
	spf=pass (imf16.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754755496; a=rsa-sha256;
	cv=none;
	b=fryRQqwshNez5Q31o61xj6PnvlDJmngvUtzu/C7yOSoHBqyKM0DfmclCdf0xsM213a4tCV
	RzQa9nR/STwJakzlLBZyEBkKk5844eH+SvVNmjkfKYr+OM/w1mtA4Kz0RwuFmNKQpZ2nqo
	Ldp7bi4pP+lOfjOKi5B/JPKAZ1kMLGk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754755495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sxzZXZ9khqyL8fNdwVgMsrfFG2YXiwPF3nzkdXzjMeA=;
	b=ECe6DyMNHRths0rwDwIoLQC3NLVGuabQsUcW0M7q0qB4oWE2tLwXJ0MB/T+BC3iusidrgx
	Z1u8so+2H0IXAA00pa1BkK3jkGM+roYLyaM0HF5w6VCuAgL/xsPS9C5oW5rFvad5w2CNHH
	5RHrOSriIsKrzPllTt03vpaGEG7n7QE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-280-r5sfhV_oOkaQbFtmHfxCUw-1; Sat,
 09 Aug 2025 12:04:54 -0400
X-MC-Unique: r5sfhV_oOkaQbFtmHfxCUw-1
X-Mimecast-MFC-AGG-ID: r5sfhV_oOkaQbFtmHfxCUw_1754755491
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C11ED1800451;
	Sat,  9 Aug 2025 16:04:50 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (unknown [10.45.224.45])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62BC53001455;
	Sat,  9 Aug 2025 16:04:43 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,  Andy Lutomirski
 <luto@kernel.org>,  Peter Zijlstra <peterz@infradead.org>,
  x86@kernel.org,  Kostya Serebryany <kcc@google.com>,  Andrey Ryabinin
 <ryabinin.a.a@gmail.com>,  Andrey Konovalov <andreyknvl@gmail.com>,
  Alexander Potapenko <glider@google.com>,  Taras Madan
 <tarasmadan@google.com>,  Dmitry Vyukov <dvyukov@google.com>,  "H . J .
 Lu" <hjl.tools@gmail.com>,  Andi Kleen <ak@linux.intel.com>,  Rick
 Edgecombe <rick.p.edgecombe@intel.com>,  Bharata B Rao <bharata@amd.com>,
  Jacob Pan <jacob.jun.pan@linux.intel.com>,  Ashok Raj
 <ashok.raj@intel.com>,  Linus Torvalds <torvalds@linux-foundation.org>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Weihong Zhang
 <weihong.zhang@intel.com>
Subject: Re: [PATCHv16 13/17] selftests/x86/lam: Add mmap and SYSCALL test
 cases for linear-address masking
In-Reply-To: <20230312112612.31869-14-kirill.shutemov@linux.intel.com> (Kirill
	A. Shutemov's message of "Sun, 12 Mar 2023 14:26:08 +0300")
References: <20230312112612.31869-1-kirill.shutemov@linux.intel.com>
	<20230312112612.31869-14-kirill.shutemov@linux.intel.com>
Date: Sat, 09 Aug 2025 18:04:58 +0200
Message-ID: <lhupld4zdjp.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Queue-Id: 80FAA180007
X-Rspamd-Server: rspam06
X-Stat-Signature: jpb6fb4yjqa8ie9tipin9sj3qczf7noc
X-HE-Tag: 1754755496-496439
X-HE-Meta: U2FsdGVkX1/lvtjGQGaaAgq8//lReWj7SJRaNIaLfemcbQJaV8VvLtqr63mTK7PcdlYtrevI71Gd5gdRM/K0kFaGm4hCtKAkVT3Y1zLTnTwURTbB9AH7nsJzRPg4b4PJ6S4wgGYaeQrcNry/+ljxaU2WrX25EpU86UNDkh3+LpIufvq+UZDBTTnlBXcWs5N/Wx8fRI6DL67HTjvRVFD1Fegtc+GwEO0VEw0lI0/10Zg8WRw9mOvJdRYeTitUGqXgbHJ8VbwhsSckBpBEyhmvDpcrXI47yw/sH4UFORVNIy12XM34sl+k9e6HBljJTv6N6aWyUHN2KL6+bcNT13CLUr0/lm/hKQbSnsAEo0hliwQsYzYRPl2byouJFEZPlIHehfJMM8eLOiEiYfw0nfAZkDhnAZAxKKx4VASfgsUzYxq+pQCG75K4NgQjVBjLr880/FxmGysE4A5RiCNM4r6SHwsPjY7ByQP3sT3U0grHLJdEBFs7HY3BK88e6CVd69uWs0/7JDlA/IYsKLA1tKgp8qKIc3Ancgk/aIL20jitRTAPFWcTdYM857T0kgAOlYfHXIH1iHB/1OEaA5P0FKXlTWvfdlv9RxFn6pwLnxfHYKqWtKTjMkP6+fRSqECndO1OtwDgb3RD81gcRhgL637yC2CZ8Hz94qC+RYuotW8hDGsQz7X6N7PauiD8A0qvvhS2tNI+WHh8hlJ6o5eBnuoPaQcr76J7aJuQqH3njyleob2gbzmKDLCG+a98itKfyhzAiAf2L7MS7Bn9qVDlgHZmF/5PLYTFq0TONly/hrjEM1pSRY1yNwKUs6IVHmb+J6EgiN6hr3fKqnAdmArHrw8LCacEdDIQnStddpVBcOBHsYJewWs1httIPXbrdbrc0LuYygx/8nd0hbD50HEG9YcfZjdrQMu2+qUeGHj7y5EXI6M9QITGZrS2OGlIEECzTwajJ3GTDrGXDXHb/NC86xl
 sd7xZvZu
 fjD7zNU91Ykkk/aHfRxxkQnOL/Xxn0lSRWDSKQMkLgHvf2oQ12Ful8A6tpymQETlVOrIB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Kirill A. Shutemov:

> From: Weihong Zhang <weihong.zhang@intel.com>
>
> Add mmap and SYSCALL test cases.
>
> SYSCALL test cases:
>
>  - LAM supports set metadata in high bits 62:57 (LAM_U57) of a user
>    pointer, pass the pointer to SYSCALL, SYSCALL can dereference the
>    pointer and return correct result.

Is this test expected to pass?

I've tried to compile the Fedora kernel (6.15.9-201.fc42) with address
masking and LAM enabled, and while basic LAM support is there (the CPU
ignores the metadata bits after the arch_prctl system call), it's not
valid to use addresses with metadata in system calls:

$ ./lam_64 -t 8
not ok 1 SYSCALL: LAM_U57. syscall with metadata
ok 2 SYSCALL:[Negative] Disable LAM. Dereferencing pointer with metadata.
not ok 3 GET_USER: get_user() and pass a properly tagged user pointer.
ok 4 GET_USER:[Negative] get_user() with a kernel pointer and the top bit cleared.
ok 5 GET_USER:[Negative] get_user() with a kernel pointer and the bottom sign-extension bit cleared.
ok 6 GET_USER:[Negative] get_user() and pass a kernel pointer.
1..6
# Totals: pass:4 fail:2 xfail:0 xpass:0 skip:0 error:0

This also happens outside the test, where write (for example) returns
EFAULT if passed an address with metadata.

Thanks,
Florian


