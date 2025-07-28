Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB86C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 19:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412046B0092; Mon, 28 Jul 2025 15:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E9736B0093; Mon, 28 Jul 2025 15:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFC16B0095; Mon, 28 Jul 2025 15:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8E86B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:11:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94B32C02B6
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:11:43 +0000 (UTC)
X-FDA: 83714617686.26.4DD96AA
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 807E41A0007
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:11:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dAR1Sfwo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753729901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5ujbbHitHl5dgm3mEjwmrXtoJQpOR5znmBhpKBJQ4I=;
	b=reDGDUilXpGBRAalLnPGVA2qGkB8XZrKBh09DccTQfQzO9xDUVj1U/IMcF6eylFjOr2mbm
	+Bdk21IAkxtEvWscDqFbWE6BVgTBET3SXUYSaKCJ9bfC4c+yR8/NzlZzCNPUU06Ziu+Bms
	tqlwCJKkRTuQGTTacHj2SIn2cycrWak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753729901; a=rsa-sha256;
	cv=none;
	b=HMP3/WMX9ukKvOKVrR7cPEbQ/+z7KwCFEOLykBbhDhJMDBVLDT3m1sCltCvM7Wkr+5WHHL
	xfyrOIWfnZI5xl/Qk67BbUB0QSEAl6Rp8Wd63fd7YcVIzKnwA3q25QPAUMSMAKRPF5O0uh
	ETooxL1O5lkJfSp4GfuzF7Mf8AizNe8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dAR1Sfwo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4563cfac2d2so50662025e9.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753729900; x=1754334700; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+5ujbbHitHl5dgm3mEjwmrXtoJQpOR5znmBhpKBJQ4I=;
        b=dAR1Sfwo4KBf69vrpIph8cxkGKuuOnHH/dPN4i/HxeibG0S9Xi85dpYP8S5AYJ6ZEr
         uPwnJnFT7NBhntsKMkhmrVFh7xC8/9lMS15wVgY1Fv57lVDdd6UoTYVdGzvvrVBTGJos
         XgzuNAhi6QH0t/yJ/iyrscfn2JpuRtweIXn1ePfVzp+vZXnC1NCqFueXdX2Jgt0PTjYW
         AQ2ScQM4/h5xhd4YyPPEpYJHT4vbk296iOz3AVy6Kzpf1WtEZvJyGWygohzH45Z0QjFU
         XAQQU5Rj/+W51sKwSOViWzZGRgarK7ALwxuFhIyoYOlQrViZDJ9EI4weJbCWW8UopQ3A
         sp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753729900; x=1754334700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+5ujbbHitHl5dgm3mEjwmrXtoJQpOR5znmBhpKBJQ4I=;
        b=lw5kjGZ30695sFrvZdjANkUMv3ZQhXo7U6+CN0YW69fk6Nf10Uqj2oafUlwI5Ne3J+
         h8y2pd/S/6tplXe8+cWFvBL3JYnhjzCde7MWBCM20vHTEkOiQdaK24QTsAV7aW14h6LO
         ZEDNRW13DOeKW966VpFgQmqWi0R+dCCrj/F+eZkkeSJTZuoJBKsBI3MILcTg4nVSpvPb
         Af4rklSIcRH/GIWkBh+xRyAoSLhBais7P9vp4OusqKLRLbGjju02mu4RZroS93zWD+Ms
         ewayQPBFKUQR9OmFdQFNrERahrGPDdFaBqbdmquXbl7Ht082F0yYSODaGYdE/bPxhBVV
         cKbg==
X-Forwarded-Encrypted: i=1; AJvYcCVCG0qqiLOZCiLQJFzH+m3goqVix67yk70u6VqdT/9AMql3Q/Dn7QwS+HckZVJkoEWwJHLpxM90UA==@kvack.org
X-Gm-Message-State: AOJu0YzaO0gberE5v9fO9YRczFQKkyN8U2vW5MsQc/UdUEDL8L3Mgp/0
	3sGdl9JdkDZrj/+0xLlc2Zw/E1UvWj6FiFmsWxnK+F2m4HwvNIZfg91x
X-Gm-Gg: ASbGncsAkRox4XQvU7fXNq3QPOx0SHvewTmdyVUQHrkR+6DJrQpjxQ4/MXkt/aoSSkY
	g0Iv8wbMt456/q9Ff/jQnQamIVEmROo9PzklLmnHKulCBDX22l560atR5sixKyQ9n4D1LC00GE+
	lZyWjneG3FYAa8KkYFzJ1ygMXSj56tWATtbR+U9C48jcwjii2AOZNLBXG6dvaNfNe2a4DnpGm24
	gspI/X5aQ7P3aNJYc/UWQVK+WhnOuSzs0AUHC3rnJj7thL6DyapHXOXb7qECvM62xgJO9dTzuQx
	atzpdrlLayZxm2kxCUimgeVQ6ZHuRIAjQuSmpqYQ2iGY/kQoPNw2EgOICXj27vIqq6bb/zU2g9r
	5NohYrplRlCg0pWgKnrXU2bFwWK9/8kDS16xI+2DOldSBZ3u5iHJUiWM5qibQxw8Ex4EvjNU=
X-Google-Smtp-Source: AGHT+IHDNjqJiK/x4ADgxh71DNy+TDjyb6189QbF5i6Zpg12xik0b+LlFg9st/wOQU9cpdMpTrOHEw==
X-Received: by 2002:a05:6000:430a:b0:3b7:892c:41e3 with SMTP id ffacd0b85a97d-3b7892c44d1mr3040258f8f.46.1753729899796;
        Mon, 28 Jul 2025 12:11:39 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587ac58045sm110653695e9.22.2025.07.28.12.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 12:11:39 -0700 (PDT)
Date: Mon, 28 Jul 2025 20:11:37 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel
 <ardb@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Xiongwei Song <xiongwei.song@windriver.com>, Xin Li
 <xin3.li@intel.com>, "Mike Rapoport (IBM)" <rppt@kernel.org>, Brijesh Singh
 <brijesh.singh@amd.com>, Michael Roth <michael.roth@amd.com>, Tony Luck
 <tony.luck@intel.com>, Alexey Kardashevskiy <aik@amd.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Jonathan Corbet
 <corbet@lwn.net>, Sohil Mehta <sohil.mehta@intel.com>, Ingo Molnar
 <mingo@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Daniel
 Sneddon <daniel.sneddon@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
 Sandipan Das <sandipan.das@amd.com>, Breno Leitao <leitao@debian.org>, Rick
 Edgecombe <rick.p.edgecombe@intel.com>, Alexei Starovoitov
 <ast@kernel.org>, Hou Tao <houtao1@huawei.com>, Juergen Gross
 <jgross@suse.com>, Vegard Nossum <vegard.nossum@oracle.com>, Kees Cook
 <kees@kernel.org>, Eric Biggers <ebiggers@google.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Luis Chamberlain <mcgrof@kernel.org>,
 Yuntao Wang <ytcoode@gmail.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Tejun Heo <tj@kernel.org>, Changbin Du <changbin.du@huawei.com>, Huang
 Shijie <shijie@os.amperecomputing.com>, Geert Uytterhoeven
 <geert+renesas@glider.be>, Namhyung Kim <namhyung@kernel.org>, Arnaldo
 Carvalho de Melo <acme@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCHv9 02/16] x86/alternatives: Disable LASS when patching
 kernel alternatives
Message-ID: <20250728201137.113d0f45@pumpkin>
In-Reply-To: <20250707080317.3791624-3-kirill.shutemov@linux.intel.com>
References: <20250707080317.3791624-1-kirill.shutemov@linux.intel.com>
	<20250707080317.3791624-3-kirill.shutemov@linux.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 15penmziigknbdj8kr5g3txbw993h7xi
X-Rspamd-Queue-Id: 807E41A0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753729901-683430
X-HE-Meta: U2FsdGVkX1+bsdG6rcjtC7eYrH/DSBHhDvQoohdSLbCTegYXwBYYozTbgtsIUxn9eMsG3GypFpJCWisOYpzD12/Z/KKsgY2WR0SLzQvCnrDFvWBhEQH1+ttGrtuJhVG3zC6GVQWdZvILrqjA8aJEGVn0wsOpB0Of7KDjtD888+9TJI2CqTbqH6klfWv5lh7SfFX8Nx+KX4yAV+zO4ljwuLKearS/U1Do9yVNFHnZJWjvWUngg4RkCOXTSS5sjad9yRndvrKB9t4poXWNrRMU9x2/VUzVMDu5pWBf0DUrZRvdVTEElCUDkW9/jrJAejkF3DYK7+HepKsjvy4WT0ll04Y1GmBZ2mJZy11X9FgDzjfr3JaVpj1T6bIL4DGe3flOmtT+mCw5CyZ0Kmv9+cvsmPeJJK/xqUveZQf/dYStkTRTOmAWdHngWooUA0zi3YgsL2i2oNtOUUI8Zq3s7P6ot0HSgV36FdFeOe+HLOzpdaJ1f7tfOm+Zz74x8etjwTq0nzKnFDES/q1y1cGBsh8rxD0nxZWbIAwUsfvqr/kuW0DLD7KLe2F0Hr7X3Oiwx2/Cgzf+SErsFG2iUOd5A9U3k+cJKnjukmUDR8HbfSUD/Rr7o4vG7dyqYcwDmNiAiaYKbGlTZKBJumAjHZNmDLOl0ewaHOKLAHPQNnuT6HJI1ZldykYHwa2l30uDj44vhk0vJPSE75nEZBy5NjIguI8SCM7X0FaYougKWzSrfThY3StS5xlUDSDl/f1KwWTOrRhywWUCcjiLCYI8OD9bmgxKjmb7fsM7TFrjN6E1gw32PCFypnsvZDeNzuqrWJcuqOlzqtvSqXOEJSyt4lMLm+u7olIu75W4sJlhVHike605ST6guPJvTLUIIgCqQU1YSyyveqLYtEJgclfvx6SgHFgOdRwb3e3/YGWGk5AvSezzY+1S7LeRvh2SiSpT/zrI47cQc9nDfnJTdxMzkUJGQKR
 TuD1qbgu
 FhgwzpE9D6fGPmtnSvbDhaxX2iJLpnrMCW75NwxDuyP7PfJNOcBoo+j04FlVFun20sYE4o2OuxMDVCtxH9yScJIWaXn6iLRA9c/yzvkzGngEGo1Nx+5owV0rB3MZPSdvyHKh8ONypUHv/G0ZjdQUrS3fQcqHBz/3BBDv1fLNM8gacQSSxzwj2A0JirYNX65vJR9D4nYT4v9rcEVx1OSuYpJmMuqXTdVZcyM8zWzWpTdtN/z1PpCLdx4WxwTiwIdAQkL+L0MzBPUCI9KDJM2bHl01bRlYTss9yvxL3HQ7yLrBKcleM4oVPj8sNgXXY55+wS2bmaAyzR5/mGNrcPe7Y2HcKTJT3D9WB85HB/3N/BwHGPIMXbq02mHeJEJHv0GYvUfV+MgBQdKFOj/2mJQ/RlkiSBlobSIwdvNRRjVAaTwD1AX6/7dHMDjJ81NJnBc1njLVKmkCK4eUJHOfRbm6PizubHzfSLVybpKPOmewcKH2b6SIVm3oPXWCDt6F0S45lYnq0HD7oz4XlNPZ1/4JljV1fJtwi/mQ0pcnaHd9YS4p96tdIlchXH82vUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Jul 2025 11:03:02 +0300
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> From: Sohil Mehta <sohil.mehta@intel.com>
> 
> For patching, the kernel initializes a temporary mm area in the lower
> half of the address range. See commit 4fc19708b165 ("x86/alternatives:
> Initialize temporary mm for patching").
> 
> Disable LASS enforcement during patching to avoid triggering a #GP
> fault.
> 
> The objtool warns due to a call to a non-allowed function that exists
> outside of the stac/clac guard, or references to any function with a
> dynamic function pointer inside the guard. See the Objtool warnings
> section #9 in the document tools/objtool/Documentation/objtool.txt.
> 
> Considering that patching is usually small, replace the memcpy() and
> memset() functions in the text poking functions with their open coded
> versions.
...

Or just write a byte copy loop in C with (eg) barrier() inside it
to stop gcc converting it to memcpy().

	David

