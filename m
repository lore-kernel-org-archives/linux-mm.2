Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5990EFD205
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9CD36B00BD; Wed, 25 Feb 2026 03:08:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A906B00BF; Wed, 25 Feb 2026 03:08:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4C926B00C0; Wed, 25 Feb 2026 03:08:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BDCD06B00BD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:08:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 596218BDD2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:08:50 +0000 (UTC)
X-FDA: 84482252820.22.78430B9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79ADAC0004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:08:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006928; a=rsa-sha256;
	cv=none;
	b=bOf+ZKQFJVURtvldsKlj9Fyh9bWh24WjUdJ5eGC0BEGInNbS0tQrJUM6flk+jxUAUq9/iL
	i3SPhEHRrrYoe4jWh2/nz9ETZ0bbCLse+25IhnPYaPv0zwafqhQHYZB6xRSmDOctqYwjRT
	DnuAX13N869d7TaLJSY1tdDNgdg4G8w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+hcGrB8f3LFV3yEVggniwkqkX4Jmt/LlWOAR6G9rqjM=;
	b=HMMzb3wCbvTSGoUQJE5R1V6Zn59pfHS+8yhwiupJerrF0pr9/d1NVMgVG7zCRvLozS9bA7
	W9xG3+bN2pOuk1/40C0aG8uJyM2rZUkLT02sRZ1xuuVlxNdUa+KzoLGF6crMy6FChAsNo9
	TQC0R8mAsSyj42ik8ab+4vh1SU76rS4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0A4A165C;
	Wed, 25 Feb 2026 00:08:40 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDAFD3F59E;
	Wed, 25 Feb 2026 00:08:43 -0800 (PST)
Date: Wed, 25 Feb 2026 08:08:41 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Deepak Gupta <debug@rivosinc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Will Deacon <will@kernel.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Jesse Huang <jesse.huang@sifive.com>,
	valentin.haudiquet@canonical.com, heinrich.schuchardt@canonical.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm: arch/shstk: Common shadow stack mapping helper
 and VM_NOHUGEPAGE
Message-ID: <aZ6uCceePh73wcMP@arm.com>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
 <aZ489QDHxEZfLydn@debug.ba.rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ489QDHxEZfLydn@debug.ba.rivosinc.com>
X-Stat-Signature: ahbjaniafpjtuiy3ntxewana5837wg47
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 79ADAC0004
X-HE-Tag: 1772006928-457005
X-HE-Meta: U2FsdGVkX1/AhOLRM6CA3TAK1hjv4HX0saeYjf9h/vK/gcJhr4rC3OB4aH0FE9fDgBvfziDnSvWubguMSVFBas6QISpl5I1K2thIqabBN12USXveNmxpkC5fzS4+Cbfs5wITLBMd8Frp9xaVk6mjVNiq4abbhLqK43aIWXdnuNppqFo7PK4l0NimCM3lVFbKWs6HiChozyhFYo1GYQ+o2dfZyj6i/ERlCk44ktMJU6imm/AzLM60X+QkjHblOcwuUI72f/ZJSqhTp1kwx0liVzYyv7Ilwxuv+a5i5XncDm41DYbqOmE1tn//ajWrXF0kXvQtsehNplW3wxcyt5V1N+Oqsmgzo38BLhb3Y04jjBq7lAV4uMjPzOHTQzX0J0O6ZoO0wveTc6ycLVCZ8CX+7kjwmvsFbHQXEubYI/byklQ/wu7TiCqqVZMzcwP0GFGEudDV92ZQryzTUR94lS5YIOGtXbCD5LLw+z2WIJw8Fce3jga3cpDP2uj77V+UXWQhor4eLpP/xNyHXrTYYPlmAF5mFJ5Lg4EBkVgv5E5WQRRZkyf9B0BPVNV65OJWnBy7QL5iSwfTYt4FVnijcT/4zn6AOj7YNO6nyleBNRaf11kvj+mPpb3SWw+r6TBwmRYOO5fc9xIVn82a9Hb11sRVHF/Hy6NpoqO6JA3jCud8AVa3T0dtKh1fCOp+HWyG13D7Ox4+jVsCcKnmUgqUzss64Z7fMfZmWbA/2Jj5HsGWSp5z2rL3+oZkIDCoGxHtC1v0JpIDyPdb75sHtq78PYjxvotBcyh9fAcMzU2w8NaoPaYGiw4nnceYSkC4RrR747vrTueIKespJch9lkEScxbzSnzzY47O8SCiSjggDh9nd5RXFFC3qg7uKfkabD+qQCIHwSag703oGbz6zNyt6GECCFw9Ka0ssmPmGvQdsyYvCgWdJUaUR9bQIgbGB6oKYEKDKTI2/LraHJc42iJnFGS
 RauBnxyS
 MV69eql/vlEz26PSAnBcWWk/5ZMv+WKcRFze8g8vwahqz4O1ffLY5RQsjuxD7wQ1vbzYQ51KXWOHnoE8G9ZsUWW7hQXBEmlsv0WiyRgTbF50Jd+H4yxch8BmONKJUVtQCnqRTPfmYT6bNFgrj2YspNI8lnz4LIKQm/9iYSnAOI2RBKv9gbTJTNLJTwtCvHU6E/Pek
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Deepak,

On Tue, Feb 24, 2026 at 04:06:13PM -0800, Deepak Gupta wrote:
> On Tue, Feb 24, 2026 at 05:57:52PM +0000, Catalin Marinas wrote:
> > arm64, riscv and x86 all implement shadow stack support and use a
> > similar pattern for mapping the user shadow stack (originally cloned
> > from x86). Extract this common pattern into a shared helper -
> > vm_mmap_shadow_stack().
[...]
> FWIW, I applied your patches on v7.0-rc1 and risc-v cfi kselftest passes
[...]
> So you can tag tested by for risc-v.

That's great, thanks!

-- 
Catalin

