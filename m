Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F791C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 17:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003526B007B; Fri, 25 Jul 2025 13:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DEA6B008C; Fri, 25 Jul 2025 13:01:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C4D6B0093; Fri, 25 Jul 2025 13:01:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE42B6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:01:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C64FC08A4
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:01:35 +0000 (UTC)
X-FDA: 83703403350.23.4281070
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7633E12001B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:01:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=ef18f6tV;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753462893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ps+zs+NSAsN+PYjwfWa7tJ1eiD1ycr9gRg61OjyMFyc=;
	b=hmj+Y7cS7nQiPODR4BNNbq6LYGnWifOJFajBcXznBzqxpfQT8yVfGZwl4kyUHeJlHwfGuJ
	d1BW9JTyurt6BBlNOd9uUQnQ6Vht8pH4YueIbBbwOf5sZAX7S0Ymv6QB3PTebk3xpG6Mvq
	+zsnGIwjN1JTSguK2tSBbgTycvYtS18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753462893; a=rsa-sha256;
	cv=none;
	b=g4sMbOKFGHeqZzJFIM3Sew5qC4AUtQQRHXefC7+TimFeybUo+axvJDP/2ClDkIKpz+RExO
	q4hDBmFd/AV4oWyTz7qeVD+uaxv0gztkdRCbva8OZDXXFyGGkAoeOV09VCi38/1ecQzG4z
	NnpAf5UwIF7zGCT5tYQrHs6Avix7hTI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=ef18f6tV;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b391ca6146eso2119004a12.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753462892; x=1754067692; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ps+zs+NSAsN+PYjwfWa7tJ1eiD1ycr9gRg61OjyMFyc=;
        b=ef18f6tV++7SqdUHfQMY9ORCHNuFTNklXtnrAU9fG12xCPbyfJTxrjIdXOvq1sr2fH
         x9KYqnHlZCbIA8vhLzMwSOFZ2ChqzoHIKjuC8q5j7wuCoryBHjDaPnlWtCqLO6+ueSjl
         69CSjuwGnVByPPXc9tewp4OXWFAtP+gqEGuM61EO/cGUCUPEvJP//9nsIa9AID3BI51Y
         RKp7QEFcoDWmB1qMMRGpC5hsGwlnuuVuZsWQ49fltr7kqgUw5woGIE2rufGNmJ4i0CPW
         cwCB3wmPBe3CoEjjCep23t2VyxyuMBNzXYXfYqbinQdzI0svCMhX05REwxfzFZqq5tf+
         e7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753462892; x=1754067692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ps+zs+NSAsN+PYjwfWa7tJ1eiD1ycr9gRg61OjyMFyc=;
        b=fTzkn0KfVQxa+1dNtwvzhM9acMyD1cxYSBT7r1R2ftJUVkx6B21z2JV576DyTRJtMn
         8bJQWAX2697mV7eIhzzNQCpRc+MeIsIkCRZMA/ERrI9UgPVUswBydgwCXSHVnkJnWB2T
         DOTFrxZpWaftdP83kPgwUIbALM6uCmy/pk86QuGgVC2osrhAQuszjIfRyliOOII8YBV+
         jbt/glgDS3DS/xpd6I6Z2ZwU7hh0FcWy6KOtFQi0qcmZYata5v/Cil3azJgwo8pNf7Fp
         SW47C4PNqrsqWuecM0h38eaPbFvU7dTyj7FS5X4eUis/PwVNdkNot6uYuV/Coa7QElQF
         5sFg==
X-Forwarded-Encrypted: i=1; AJvYcCUV8S08rqPbTcAa1OtRDs/b0fBJqeu5lhWhXRSK8lQulH2HQ6LljoaVR0KM6KpFl2sVavK2Lx8J8w==@kvack.org
X-Gm-Message-State: AOJu0YwCyEhC6pXaLodVWENlPNuVASSbuQCOENSYG6SuAQja2F7cgNmW
	IyKXhMRQOCxxur19v2DqbdU+cDQSVkytfcr+7S/DfeEPFOe62Bj+t6VfzATaqANuFoA=
X-Gm-Gg: ASbGncuzu1XC46sU8p68R4wEvKntPzYcnkIcqesRc1zH0t/iFFWWfrRVttYQyeukFHN
	aEyE6HvSaj/QQtESH4GKpH4W+zbBbYK8S3YDNxl0Ir3x++4vIE5szfH5849M5Gpy22XGoI3MsI0
	4BnWU99ciFW33cBwgyIDPcGeGnHZU+gBXcGlpE4WCOCwYyS1My+Ie8nmzBij28O/92pkpIKutga
	Z5DJmEbS5KV/GJPLCGP4pjFcumvOjEShZXaDMj0Eh3RRFl/X/G55btEVmft6vjRRR43qk0rYMzZ
	BQeYd70CySbRo3rDCvyBzY5Xye8tPhDq/V+4GeWHCq2aK8flNDxmSMtp8YTQ+1mNtW9gMQEAeKq
	1wgrgGEScCtoKCI+BZhaB/2waGvAVePwp
X-Google-Smtp-Source: AGHT+IGuTlAbK0hf8yj3kF3pYRz1gmjdG+I1foCKZPdWRPnBU4bPy84CJCnMtZUdxZdhK10DgDBerw==
X-Received: by 2002:a17:903:2b10:b0:234:f1ac:c036 with SMTP id d9443c01a7336-23fb31c4de1mr42286925ad.50.1753462892029;
        Fri, 25 Jul 2025 10:01:32 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe30bdf6sm1493345ad.37.2025.07.25.10.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 10:01:31 -0700 (PDT)
Date: Fri, 25 Jul 2025 10:01:28 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, apatel@ventanamicro.com,
	ajones@ventanamicro.com, conor.dooley@microchip.com,
	charlie@rivosinc.com, samuel.holland@sifive.com, bjorn@rivosinc.com,
	fweimer@redhat.com, jeffreyalaw@gmail.com,
	heinrich.schuchardt@canonical.com, andrew@sifive.com,
	ved@rivosinc.com
Subject: Re: [PATCH 01/11] riscv: add landing pad for asm routines.
Message-ID: <aIO4aLLFrMVp_Yht@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-1-04b8fa44c98c@rivosinc.com>
 <20250725152745.GA1724026@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250725152745.GA1724026@google.com>
X-Rspamd-Queue-Id: 7633E12001B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 7at5afd96ibrpfz9udk9zrxci95qo7ut
X-HE-Tag: 1753462893-952042
X-HE-Meta: U2FsdGVkX18xzye44h2UZ8NdYlH+0hBshiWhWg2shgE/R/X+Wn0c1RSHJ20RDPDjnepGPbykyX0YDhAbHLRe/Adzt0kuKGt51LTRvaxOpmZNqnZ5nvBXNVjMlJIIU7YUJjM4HAZlW3OW+WRrNEon4jD/zq2T3tkmCoNh1PxWR2lDgHNSRvJz/G9Bw+rzmsifXTtwb47jF5s5W6AYcVdxt4xVZYoD9IcKcMtm3sa4AiRNVmCriAZ24gyR2PcKxqIQZ8PNTl60xY9yDBPY2EOvqcc29jxNtS8ZzqiLHQ7tFhR8o5N1PKDulQUJyroFRpY5B+aoZQv/JLGk2YRavyOSp0z5nNujjiMlQyCxfwmQjUWhgAkIIIPF0mvGJp6MNBDn8URh4F9TaHyYNcn0kEtNeR3pKTWnWY55kl7ODAjEt1Gi/VotULe+2rjRwGQpvU2U2nBZ+r6fzyRr9CPTBRF9GkMLwbLw4yOUZRjunl7YhrkC2i8bif6DMf460sGiMYWfwsOBrJBC1dfUAD9FJ3gAN3lCR6eJcgaB3uMZE1ajpt76yMOI/y2aWw3I8bLP8HWmrIuNAys+Tl59VtpIHSw2voNKgmHrKJeHA8hIt65JAxsDPnkTKmYPZpbxchTEeKUk8rAqGiwvNJhMBe6w2kBew2UNZp7uLawiUSSVXMfll+Y3U8UUeOo0ZyJ2pm1Cp819L0K0d4Z5p49uZqfpVdPBfpu+sNj905KPlowl4kIM8NdwV+P7MExPHyyEUULQs76BMbuBmr7NF4m8eOq3JMzbdCNYTF0Xg2ZnklPrYcxAV+wD9ospjhbjVnxK/g8Vyb5VAAzmE3ZqquJWmsPIt1EUpJHzp1W6VtiNkXkP1vR/nyw+lsPQeA+wtABVYCDvR5lyWwQxgBGIWpuGdaMCY/sQ/wc4lSfG/ZtX+xDJ9Esfr3LZTeJba/eTiEdoBtKhXjg6mcgnxF6ihS1FWTb/rO8
 /22ytqKE
 13F8lTMPc0T68hZQdb4AR7NDth7bxqa6DQp8FEmkCAwfcZseO1pbExRdI6NzhTNVaZ0cS4U1Uh5epSei2wX/p3mH91XTkcnuYRhmSltGLiXEfIsv+ng5rtLHpEbNU/zjhcRl6J2eq7I/LGe/9p2bGgjQHQANUt5cVN0MfsH783n0hDQhW2bPJWbWyUl6I0gVfzhaG16/R4P7Q9M4QyoLiSCM11+lmBxH28kWQYcpFjK2Bgjm0e2J0UqhW9t2PvV2VsbYWAxWC0+EFIks3DJn7bLToDJF/k91GkT08NcC6pw801p0ZiO1+LikVeXAkkTQD6tnIGP0+8Spr6TXjVDE+1g3QQ78Vk4SDwElaafQS4MMfz/kr49NC6rA8bcB50+ns2jIclUdMP01LbFIPjvTxTQy9TGUL04nB68dPGuTPa00C3jpTduuYsVw/TSRY0/Xku3fZ0IrAJrmmiUORrRagUfgqP7gZao80OhyFZMCbqzyx5ur3fI8MCynn4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 03:27:45PM +0000, Sami Tolvanen wrote:
>On Thu, Jul 24, 2025 at 04:36:54PM -0700, Deepak Gupta wrote:
>> SYM_* macros are used to define assembly routines. In this patch series,
>> re-define those macros in risc-v arch specific include file to include
>> a landing pad instruction at the beginning. This is done only when the
>> compiler flag for landing pad is enabled (i.e. __riscv_zicfilp).
>>
>> TODO: Update `lpad 0` with `lpad %lpad_hash(name)` after toolchain
>> support.
>
>I glanced through the proposed signature based landing pad labeling
>scheme, but didn't see any mentions of lpad_hash for labeling assembly
>functions. Is there more information somewhere about how this is going
>to be implemented?

Take a look here for generation of type string
https://github.com/sifive/riscv-gcc/blob/f26ae78e21e591f78802a975b68dbde9a224a192/gcc/config/riscv/riscv-func-sig.cc

For hash scheme, take a look here
https://github.com/sifive/riscv-binutils-gdb/commit/1d027fd590c8ad79eba997bcf9b979872ff38eef
`riscv_lpad_hash` function has detail about how 20bit hash is extracted.


>
>Sami

