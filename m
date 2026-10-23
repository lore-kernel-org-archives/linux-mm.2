Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B8E0606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 01:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ahj0rvYC
Received: by kanga.kvack.org (Postfix)
	id 9A5456B031A; Thu, 22 Oct 2026 21:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CF46B031B; Thu, 22 Oct 2026 21:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892FE6B031C; Thu, 22 Oct 2026 21:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 560986B031A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:50:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE46214033B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:50:01 +0000 (UTC)
X-FDA: 85352210202.29.2C563D5
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf31.hostedemail.com (Postfix) with ESMTP id 486A420008
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:50:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ahj0rvYC;
	spf=pass (imf31.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792720199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+p8cIpnt0YjLXT/3n6WuKQxFq68+6JJEn3PVDsIrB3s=;
	b=TsspJ/bmFevdJBDFZwT+ikIOal74IgblB2kqLgRAUUgg0AmWimFyUpctYeM0OXJGSamSaW
	dAZ8II6BWcls7auWokY41msFPHYdk/GzrarhgFyRA2TGLOMvDiTlgUOMe6CeLCQMfPcOlI
	7DCbPpkH6NISuxrd+aVAvOTjnKiB+r0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792720199;
	b=dQ8W5Oquj5wlZfjz1DLsSgTCtKnOgjKL2wGpHAmu6Uw6aiRKsonOkpgyxxDKrlh9aB+ekm
	XoyB1a0zx/xSEMZ8BiKCR4WuMU3jh6DZ3X/9I0+/CsWuQbX5Y2ag0LCa2nVdg4y+yBsBjn
	rEZ5rAJfFwOSIc3AZ1+r8Isgr+ajo9Q=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ahj0rvYC;
	spf=pass (imf31.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-353804b591eso742857eec.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792720198; x=1793324998; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+p8cIpnt0YjLXT/3n6WuKQxFq68+6JJEn3PVDsIrB3s=;
        b=ahj0rvYCnd7UTb3IE+vkX0xSvToBIf/DEE+aYrcwErSSKP3C/uwRHX7f0YQwi6FSfm
         O/7t2L6rkNmk35kkszOCt3sWqmnwYdACBnV786T70aSQ1z0/lIPQtewqUfHSEgt0lBJR
         u53Y4vIojd6s/iKvefh71C69qpXGqAcWprSeYZel5DTscuh5XBUUjrsxHzk6FAg0IXAN
         OAva6JISqMpBu8K7uQbjwTCdlpMz1FjjHRFTm1HK/+z6uCqJcYAr9CvCICez9WVezM+s
         yx3xj9xxRPVB0o8hr+PuMCnCwwtiZps1dnKieXRYH8HJ/v7HHyLKOVipnJ7xq1wSvwg3
         HtKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792720198; x=1793324998;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+p8cIpnt0YjLXT/3n6WuKQxFq68+6JJEn3PVDsIrB3s=;
        b=tSGr4Jhjn/O71voaXwTWWEy1wIo9Qfu//TwHsHstZhsLD6LCExmk45fmcpxsC+XBLW
         ipnn/95chdyAxYXewhfrXABxDwsEZv6NlzVdsYyVYYtDn1dqfLan10J4+6MwdUlLkKEw
         npuCR4mjsQPK6A5qprcgVgdobiyUh3kkwsTYBYK12R4FNrY2LlFpCjEjgPQ/3YVwYjS2
         mzx4aZnVbP+KYuMVJSJg09cEZMx93DTUVFO3cwc9+k5i+hg5akwU4mpmcQ8FmlIxh6QI
         zljQBVVHOSQYbD2a8L0Pq7dh3/+8GdyrYbKAzUtE+zendGpP2bs6+He/+dLHyh6PAX9h
         YWiw==
X-Forwarded-Encrypted: i=1; AKwUvBxJwVFQs3sldf7o1qvo2RyuEFzrH/UPV/Yp3SB0aB2yBRVzSjcumlJ8ayAiGJhISXlsulwE4tYi6g==@kvack.org
X-Gm-Message-State: AFq9FYIWKdB09jUg6bad9FN+rQNFN50j2agkiyZ8AEgQpxGJ4v1YEZHM
	4vXqnIscNAc59VQ0NnWK7wmFqMMgly6XvoJud2axsFhGnzioutiekr5h
X-Gm-Gg: AYBFou0PN0Be20TV0fX+RoART8KlTu4XpCtSV8OwloK+z/8f6zHskQFpBp80+1Z8NlM
	n8dCwO1H+2Uz1fFFsdmZ6N6H0hSgEiDjrQLLPSsCnYfxO+hV7KbDiUXapJTuhWQFJOH74ENJxHA
	Pc3ZhKdXZmxrbN1+HriFoRciXlXYzAeOa4eKeo+Rcvc1LwCfcci9jYNem0ir789e5JNW2Nknr5z
	bMd8JhI3nwgcyb9xLBlj3da0wNX13qEMSikKVZuj4s771qPE1SRS9ImCDRZRPensK7m6FubMrYl
	P86DbMKI8zv2XYZQnATp850dgZz71qAOEWzjAtEKeIgo1GudTNQ/1tsb8bNZblRE7DgSL7oLqSZ
	agnGJe4DXgoRsu/k8angCishZeTw5S9aB5eQkRcveEPRX7lBamkB83Mpi5Z1ZrbJWNg96B+Mlgi
	qJnpcXS4WBQiFDci16k7QzmgNlxy1sb2gXfs+qBKVyE2IKm/3JQQldmA4K+v7CmM3yOtGMPbGSn
	9LWin+6Bf/Myk5Fz+dqaH+mrzMW53nLFlCm/VDSfnPGuM4FL2k=
X-Received: by 2002:a05:7300:c00d:10b0:35f:4780:518e with SMTP id 5a478bee46e88-369d97155f0mr1233857eec.16.1792720198309;
        Thu, 22 Oct 2026 18:49:58 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369d9c0e60dsm1971091eec.2.2026.10.22.18.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 18:49:57 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH v2 0/2] word-at-a-time: let KASAN see
 load_unaligned_zeropad()
Date: Fri, 23 Oct 2026 09:49:47 +0800
Message-Id: <20261023-bug-word-at-a-time-zeropad-kasan-v2-0-be0ecfbae847@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADu92moC/5WNSw6CMBBAr0Jm7Zi2khJdeQ/DYqQDTBRK2oofw
 t2t3MDle4v3FogchCOcigUCzxLFjxnMroCmp7FjFJcZjDJWK33E66PDpw8OKSFhkoHxw8FP5PB
 GkUak1pRWldYyW8iZKXArr21xqTP3EpMP7+0465/9Iz5rVNgaTQd2lsqqOncDyX3f+AHqdV2/W
 tfq3NAAAAA=
To: Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
 Marco Elver <elver@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, Kees Cook <kees@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Qiliang Yuan <odys.yuan@gmail.com>, Peter Collingbourne <peter@pcc.me.uk>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 486A420008
X-Stat-Signature: tqifod4zap7f4qq7nuhz3r53mkwe8w4f
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792720200-104104
X-HE-Meta: U2FsdGVkX19zLgjscegbIgVPqgc98r0HgKBIMkiMVPngVql3QEBB1nxqXRUKZHE27V8vjOW886CGxOaH46WaSzA49Ev65P+o91NQt70vFbY3REH3VlT4QceRkQ2YQVx9OOtlNZ9bTum8idBrGpIma09JsFVIxqk+EDegsWu4BkAUcK+O/8fRp1+VhFcUThmXjAGMjPnvj8iBBjaDdkpwLqrjSg3O2y4rVT5F+5R2I1Rigwl7mrlSb5ozR7dzIUEkpXFh6ofzq0YCt89JI948PXiePF1SD1i57uTz0Ggup4BeKv17n5cVXDoNSUXJBhhjNn4dN9t54PPIrQQFhCHGIG7xAmQyEE1tUIxU5cs0EXwTGKZcHxrCi6Ehq5YGMRA0Rw9DOLcJ95xVLyhtFwsZmiRvtDgi7A3Yanjs24QzTOV7LdzR2jvAnUkFPq9kh3G64ZsrxdeW9OKM60FYJv5JBbRIjh4PHOVEEyq65GERdhW89eU6wdFLtLPiaFobfqybxQDicmyCl9qsQCx5S138OmAQeSc9BcBdX6Ap9SVVjNnndne1ac4yBgi2OJFGSfhfBqw3IPpNyIkvoSJoR2XRkXLAaw2bjC+/Bg+NHMsww4o+Wd4uM5lbgAW8Vch8G9F79pvRS04p6yTdzPar8SLyOce8I7NsoDLsYxM1vivc2uraF/tmyI7jd3RCz4FfBRzhGjjO1YEx0LLJPcAIj38UfpBnf2+BLCA+iEmZtlSNPq3GNk1udsFfl0317Vw8p6pfyHPSQEOX8K409ZKTGpHbyYsU/nZTflKUQ0Z3g84nyXBKMiHgY8osVe+dDTpzMaKtvXbeObxuBXufzCNTXkKNpjjJHAArTms7O8Tan2cE+IrpDs0fSYb6CwPMXZv/aTDgQMjqLdgS7T1B1MmV/OD4N/z2RsHvqMB0RcbX3Vfsv2O1D6dUgy8iMBA52x1gKu4bJQD8drDM/LidpAAS77w
 VFfkoUWy
 rwKE4RYMq4Iex9ZYmN6cPyZxnuRc9Yx1OjTt3LTQuON5cyiwp6baJky/9SUO/JkNPH9FMdSP34VtRJPPg8ZuSNpY0g72+ZIVesdQuSeFTOT1e/V1I0bMl/UkPbypVr3IVbJpZLMtxdnaHaP1B3+df/uXAHqhKErVVKpVbnrfznNpZskhyBOQR/Hnh2fSygC8pcBfrIVqHXGGZBYYR24pnp11bjr1bNPQyHDXm0XDpu2eaWBGUUXebnIZj3Y63tQQriSyKuYCeDKStJ8jovcUb2Xup5RokXd2psS2hP+P40kdVmzHU61djClX0VEVFNNogeCxoIhRcNZps7h9fr80+JGVyvsFZS4Fl1x1u1F6q8HvkPhZlr6RLLRevc5nGwZS4maAHThsZwohfCTNhyRYMrHxXLYT3yz8LqSJQp14lJY2boqkJs8bJmB9xA6HHdQgWrWT4gFisN1eICSdyn6+uHVAw8uC9SKaIrxqWf9RqJQ21t/l7nUiI46Z0D1Gtb68VhC2bo3KGKSdr06VpYxm7RpnxRCEHXOZNu/6pegcBQPNulmSsZ0mgOoUKvCenmOkwa3+P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

load_unaligned_zeropad() is inline assembly, so KASAN and KCSAN never
see the word loads that sized_strscpy(), the dcache name compare, path
name hashing and x86 csum_partial() do through it. While reviewing a
strscpy() KASAN fix, Peter Collingbourne suggested checking the first
byte inside load_unaligned_zeropad() itself, as read_word_at_a_time()
does [1].

Patch 1 adds that check on the six architectures that implement
load_unaligned_zeropad(). Patch 2 adds a KASAN KUnit case for it.

[1] https://lore.kernel.org/r/CAPQLkRhXZwozmfhNd_PEx1ihwdH1_5qthP6PANYJ_m-v9vfQTw@mail.gmail.com

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
V1 -> V2:
- Call instrument_read() instead of open-coding it (Andrey Ryabinin)
- Keep Marco Elver's Reviewed-by, as the check itself is unchanged
- Rebase onto 7be4bc52fd9e, which drops the big-endian branch of the
  arm64 header and rewrites the s390 load_unaligned_zeropad()

v1: https://lore.kernel.org/r/20261019-bug-word-at-a-time-zeropad-kasan-v1-0-f21a3ed6a477@gmail.com

---
Qiliang Yuan (2):
      word-at-a-time: check the first byte in load_unaligned_zeropad()
      kasan/test: cover load_unaligned_zeropad()

 arch/arm/include/asm/word-at-a-time.h              |  5 +++++
 arch/arm64/include/asm/word-at-a-time.h            |  4 ++++
 arch/powerpc/include/asm/word-at-a-time.h          |  4 ++++
 arch/riscv/include/asm/word-at-a-time.h            |  4 ++++
 arch/s390/include/asm/word-at-a-time.h             |  4 ++++
 arch/x86/include/asm/word-at-a-time.h              |  4 ++++
 mm/kasan/kasan_test_c.c                            | 24 ++++++++++++++++++++++
 .../powerpc/primitives/linux/instrumented.h        |  3 +++
 8 files changed, 52 insertions(+)
---
base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614
change-id: 20261019-bug-word-at-a-time-zeropad-kasan-af2460466ee6

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


