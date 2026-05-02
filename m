Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E09CD3424
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 09:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696726B0005; Sat,  2 May 2026 05:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6476C6B008A; Sat,  2 May 2026 05:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536F36B008C; Sat,  2 May 2026 05:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DCF8B6B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 05:38:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 354328BFC6
	for <linux-mm@kvack.org>; Sat,  2 May 2026 08:20:20 +0000 (UTC)
X-FDA: 84721782600.20.726CF51
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6006D100006
	for <linux-mm@kvack.org>; Sat,  2 May 2026 08:20:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oegYXA+A;
	spf=pass (imf05.hostedemail.com: domain of anindyaandy1904@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=anindyaandy1904@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777710018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=50dXfXimWHbetqvq7vRItsuMNkkrpdQRd21eS5H1Q5s=;
	b=nPLLlg+gI39ocK1ELpZK0P2q6yWZCPqBS8A98rZtO+h/teSAgui6hVMmS32Rfl9Irbz5uG
	KjgvgNrKNCRq/qFSvMAfDo1N6rlHUjqPmANHvaRuak8yiyPxIgwfOpITueRD9RsJM0Tc5U
	qpVTuIBKi5b2gZPtb4zPVECWRsNG7Bw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777710018; a=rsa-sha256;
	cv=pass;
	b=YvBzM4q0rqrn52mkRpEq2QDR/YlvRrr/nAzLhUL3uhvrS1D1aVGJQaCjGfJ2e0yTI/v0t+
	IHUt88ggQnnBtvJpLtB/AvDqoYTbspWz7E9GkdfkFGc062yNX5XlbZeDCHyxU71NKHSzpV
	rtpNYUTT10HciWsdq0m+jW8T/xLP6fY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oegYXA+A;
	spf=pass (imf05.hostedemail.com: domain of anindyaandy1904@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=anindyaandy1904@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d4c383f2fcso2504846a34.0
        for <linux-mm@kvack.org>; Sat, 02 May 2026 01:20:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777710017; cv=none;
        d=google.com; s=arc-20240605;
        b=gXvPdIbi9nOZiwGGP1dRYB5OBUpmXJcgulemN37CjSFBjvl8Llm/7MVmp7LmZwsXFy
         w9WJD4wYmRCo2tvS11qcBY0F0JbhWHANxiuNEAEoF5lYM7htrQeKzQ2LjxgGxRINbyGF
         9yOJyRnn4IX4WkSG8Igj3Z6roWJ2Kb+jR8QG/QZao5nYeDpGgEcMSbbjCrw7/dOngDZS
         gUAV6kkAbDZh9m2ZVErGi3C+GvYPV+zTVmBEqylM71bfiHz84gDtUxJpFt1w3oozybz+
         4urJMYNQozOlRNKkHeop6Ya1bhGblPGOs0Oljkg1aIixeRAmdolIVYdu7oXbjuZ128Lu
         0uWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=50dXfXimWHbetqvq7vRItsuMNkkrpdQRd21eS5H1Q5s=;
        fh=FkFGEIFpKtMUJ2m/ei7/ct1LYVSuDncVlqUOZs/eEXg=;
        b=WQPNGGxmgUTPXEqGEuA9DfPC+IzmvfzPDOSkCR0FRmagnIkOwoYsU8YVFpihVF5R9k
         e+BYyuCsGiLqwzCv2tNBBfRh+EuqX0Muxm2cDreABFPYO2fALmbNz5hTe0RsOasBDRBM
         K+M9sUb9syNmjVhDtovwMVOAX45iblB6GiXOmYLcejsyDdWIIHC1GfE1IL+Y4+KhvRxK
         OvAbZ92A7yYQ0k8XXkLtvV7WQXQMcCn3Kbhik/d7ELArLa7j3W/WnpUiiqhF2XkyfLPS
         GcHwe8cf0WVlqjQ+B/ZW03j2C946QZYvkvldZAanE2CCf7PNkhhil7ajIO2eJmoIc/X7
         u6Gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777710017; x=1778314817; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=50dXfXimWHbetqvq7vRItsuMNkkrpdQRd21eS5H1Q5s=;
        b=oegYXA+Agji2McJPVpj/VkmNB5r7qy2LtY9yq00m/up28BAn2GcIjMBBlSFUd+Pj8D
         h7l9hlimlqkdfZP9GwqctRhXGdX8UR2e+uYwHL3yjppO7d+/3BaUoO24RGPnoE3imjmA
         tpXqAoQ7gsK041iy8SI14Ex7hhxjxQkiqpJcuMu8oq986vD1QHGnpSQ3n1rV8KGCmgRn
         797UPVwwtQxnXLLX3BUU/T5IMJPVAXSbLybdWQEGSIlQZyfwN7DQDE83P5tjeXP4SYgU
         sAJfGTXf1n043I0Y0yyqGvSUcJhRgaN9fsD4Ccgwps+/qsBW8foSmIrs9S5xkOoNp79c
         GE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777710017; x=1778314817;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=50dXfXimWHbetqvq7vRItsuMNkkrpdQRd21eS5H1Q5s=;
        b=Anc2D/zHonoHO8BApWpX23jpCxJxTC91ErpQXxtMq0avyiVPEyvOglOooWuok3ACjF
         0di9fjn2c92UZXQ2JTlL31CSChKBJqv43d1IjNg5vhhdWA6JQob/I8VCKUUkOFT2AebV
         S0Ytsg8wngmaBJvtgg0eevzrqsNavd0M9xZtr+AiMo79ZMNLoP1IJChf3waUfL48/vJR
         lwxoj1hyn2W4iIptkfQPU3FiM67wg15LoUe4DnTM0yHtoQYDVgTj07mwG0wG5qz453CU
         WJ/ymlg+5ztQ+q6cKVgWoVGqpstadafcvCzPZS9UrvZidKO4xdX9508G4VixnllhKZh3
         oQ/A==
X-Forwarded-Encrypted: i=1; AFNElJ9/88cyR9McOnCcQneoRtzFSixrpxkqaFDnMD66huRXEKe84+poMzNEQgMLde+F23Sxi/Eotfrw6Q==@kvack.org
X-Gm-Message-State: AOJu0YxFWRZw5ci1II0O8ZHg/7MyGMIl/C4zLRKCaGlr3q94se7bHQQw
	m9y64LN+/2p5rvPD3UoC8eWFbpdfkVvHFGf4vQIMefUwKMipydG3rzCM+pu+aWBOCFi7nXfEDn4
	ihAIkzEoDW2Vo+XTyB7MGNuOrOtkHwTo=
X-Gm-Gg: AeBDiesfjowX1nmqRxid6Dnkqvl6Jgjo1wKp2WCizD8urkbXIKtLSAuw7V25P7O8lvj
	FG3KeJ/bvr34+V79gL0+5TOiD/m1jsiyzia7fd0V31/KQD9x18UG6nq1oQiUZs6ghCwlw6UaU+u
	ie0JUplLJU3HuiA9jNvT8Z6sK9moZs8Q5MBO+cp0LaDTNW4+SOUsgw8qIRBmf3h8tot5iuJCRKe
	OlEX4NHfr6Z0deHbHLp4GhphNm+NSkxOG3Gh+PZBs9X7U90pWDGStbRhg7pPrZYB5S6wjOvCuHo
	2SNClkqVrMRpqkJUWi5z
X-Received: by 2002:a05:6830:3881:b0:7dc:c926:4f87 with SMTP id
 46e09a7af769-7dee1395cafmr1496446a34.16.1777710017264; Sat, 02 May 2026
 01:20:17 -0700 (PDT)
MIME-Version: 1.0
From: Anindya Roy <anindyaandy1904@gmail.com>
Date: Sat, 2 May 2026 13:50:02 +0530
X-Gm-Features: AVHnY4LlGN_3G_972Pmk5Icb_RwHQMiOwSvL8BPoLicdxxyrhBroCjrU177o-nI
Message-ID: <CAMyZbw_ppC7F98+5huwmGjz03UGv8L8MoU9zL2_YYDU=fA3Qxw@mail.gmail.com>
Subject: [SECURITY] mm/userfaultfd: cross-inode page cache injection via mfill_copy_folio_retry()
To: akpm@linux-foundation.org, rppt@kernel.org, david@kernel.org
Cc: ljs@kernel.org, security@kernel.org, linux-mm@kvack.org, 
	lokeshgidra@google.com
Content-Type: multipart/alternative; boundary="00000000000017bf8a0650d15e71"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6006D100006
X-Rspam-User: 
X-Stat-Signature: 91o3gu1j469rr3wr1z4o4cfubkp8w9nk
X-HE-Tag: 1777710018-683394
X-HE-Meta: U2FsdGVkX19sJjhbqPwLF8yZTPLuYW/kxvmpNuusoSW9o7uTsmSm4PpS0S1NHDiEieBXAK0I0K4ZEvpfdkw1Ru6rVosYdu4JHVWkfs8zF7ISgjKEH74KJdQkCt4uawvFEHgEUgKsR2DSWVD51Am/jrwl7RwnWjLRz4Ix50xIKjYmVNNWAS8S48tS5EGO2lbW0DAY1OF9I/07oJpg0wuEqjFD1skl1pQxSnZqGVeLvhFpYWYHnHbHEzvP6eD7jMqi3/VrehHBTFPduMAMKcT/e+PcMjEqTkhZ/NAGOc696v5HRWJa8dfPYEyatBVDCpKpmmQdAcYys6aQkTsEBxn45r/UVUJFQDHredpt/hXJPntuvSq5mrbwZdauT8mT+qh4fIt2PfAthMsfVVUmBH5prJk880ne3QpkatzsHO7zm6mOEcHUg3sB0Jv9kc8MNn3pUw2p+XzvAvs1dVN+WYCi1XibaPV28Vpgge7y8p5IfioMCkqIzwMRlKLJSCYEJO3jHxfQK+Ya9Whb+owJb/1ILQdtw+sDyewm0gTZYjNm+uAhxRjcPHevvSo3tl0ZPNSjmqrdVAb1jhi/big78txTyaZwi/05LbFLjywfmhfDGG+gYN2nxlOFYpknoF+4p+GMdA0GnrecMOf8daCaVUMBsQ343nqUy1xdpSiJY/P3Uhh1rHBSY/2z92U34nymDXjo5PjvHDAVC8Gmuy2FQIqS9gQF0wKN3upCJT3bh1IozbtrV4odnTwDUAhTF9l1J5OO5ikBYMeLxFX7a7BFtL5uyziTCeY9wL3IlG11PZEI3WSl/WRSzJShfkhHc/MOLzp7D710Rn37YeOVSISo5F25yFL8hGNtD2P686Lj/0oYQJoLcNuRsq4nt/tnMF9eyvtGAyKGLpOJsErfytnZZLDiG8Prcz8fw3bTNFyIxLBB2U8RYQK9N419WM4Mv5VKgKzYA3ym4n5ITXIoti7+Rsy
 Ne5OsqCX
 keD/OPPDuIRUCcbx8Ez72ThU8g9DCLdigCvUnK6+qrEArFT9Iyy3frtfLOoQeb8vG3gqr9C2ZuXoMRuaNew2S//2PHPm1MO+ZcbJ9On6SdLCYMt+c5RIB7niKvY7cUza8IVbAs9b7PtkYW8J/3oaKK5GVGrAveE/lIvQATGqPh9Vpkh2RwIYG1Omx7BKtxDGHKosEEiHz7i613shq0MGflyuJmpGXXYg6K8UROAqjisRgri9H29zIUnbwtc/o3ngUh4kjneGLbKojs2n8r5Vbuox3vVYtfWG0InRmPaPg+eSOqMsg95QH2ZYe2Zx/O61fYc7cbz8Xz6LveSuwYClUt2crTHaGBfeJnfTbMT0BLSSmi6JRgxL7+lJ1NXwy/N4cOC2JIMkySOMuGn2vzy9JswtKgoNejL4+suQFgu591zNMISifCk6lpDikeTTj0Wy/fvV/0B67O4dtTwKV5pS3PXpMfymXRRCh/1k+aljy5KWp+U2xSSS5NhKJBkisuQyNkad9vl8jP3UIeG8iQmngWVsIkxJbhjnJ34KXGmTp8BPZx4qvs8kee1TxIBCjujSksA352bCGrzbicHt1AHiL3TBUWdIcJ/0qqwPP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000017bf8a0650d15e71
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I would like to report a vulnerability in the Linux kernel userfaultfd
implementation that allows cross-inode page cache injection due to VMA
replacement during the UFFDIO_COPY retry path.

*Summary:*

A local unprivileged attacker can inject controlled data into the page
cache of a different shmem/memfd/tmpfs inode than originally targeted.

This occurs because mfill_copy_folio_retry() drops all locks, allowing the
destination VMA to be replaced, but does not verify that the underlying
file (vm_file) remains the same when execution resumes.

As a result, a folio allocated for one inode can be inserted into another
inode=E2=80=99s page cache.

*Affected component:*

File: mm/userfaultfd.c
Function: mfill_copy_folio_retry()

*Affected versions:*

Introduced by: f5f035a72423
Incomplete fix: 292411fda25b
Tested on:
- Ubuntu 6.17.0-23-generic (x86_64)
- Debian 6.1.159-1

The issue appears present in the current mainline at the time of testing.

*Root cause:*

During UFFDIO_COPY:

   1. A folio is allocated based on the original VMA (inode A)
   2. mfill_copy_folio_retry() drops all locks
   3. While locks are dropped, another thread replaces the VMA using
   mmap(MAP_FIXED) with a different file (inode B)
   4. After re-acquiring the VMA, no validation ensures that vm_file is
   unchanged
   5. The previously allocated folio is inserted into inode B=E2=80=99s pag=
e cache

The existing fix (292411fda25b) compares vma_uffd_ops(), which is
insufficient because different shmem mappings share the same ops pointer.

*Impact:*

This provides a deterministic primitive:

   - Arbitrary page cache write into shmem/tmpfs files
   - Full control over contents (PAGE_SIZE per injection)
   - No timing race required
   - Works as an unprivileged user (userfaultfd or via user namespace)

Security implications include:

   - Container escape via shared tmpfs (e.g. /dev/shm) in misconfigured
   environments
   - Bypass of memfd seals (F_SEAL_WRITE not enforced in this path)
   - Corruption of shared memory used by privileged processes
   - Enabling privilege escalation chains

*Reproduction:*

The issue is deterministic and can be reproduced as follows:

   1. Map a shmem/memfd file (fd_A) and register userfaultfd
   2. Trigger UFFDIO_COPY with a faulting source buffer
   3. During retry, replace the destination VMA with a mapping of a
   different file (fd_B)
   4. Resume execution and observe injected data in fd_B=E2=80=99s page cac=
he

*Proposed fix:*

Validate that the VMA still maps the same file after retry:

if (state->vma->vm_file !=3D orig_file)
return -EAGAIN;

Additionally, shmem_mfill_filemap_add() should enforce memfd seals (e.g.
reject when F_SEAL_WRITE or F_SEAL_FUTURE_WRITE is set).

*Notes:*

   - The issue is deterministic and reproducible in a single attempt
   - No timing race is required
   - It breaks isolation between independent shmem inodes

For demonstration, I can provide a proof-of-concept that shows one possible
exploitation path: a privileged process reading commands from a /dev/shm
file can be influenced via injected page cache contents, leading to
unintended command execution.

This demonstrates exploitability, but is not required to trigger the
underlying vulnerability.

Please let me know if further details are needed.

Best regards,
Andy
https://github.com/theteatoast

--00000000000017bf8a0650d15e71
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p>Hello,</p><p>I would like to report a vulnerability in =
the Linux kernel userfaultfd implementation that allows cross-inode page ca=
che injection due to VMA replacement during the UFFDIO_COPY retry path.</p>=
<p><b>Summary:</b></p><p>A local unprivileged attacker can inject controlle=
d data into the page cache of a different shmem/memfd/tmpfs inode than orig=
inally targeted.</p><p>This occurs because mfill_copy_folio_retry() drops a=
ll locks, allowing the destination VMA to be replaced, but does not verify =
that the underlying file (vm_file) remains the same when execution resumes.=
</p><p>As a result, a folio allocated for one inode can be inserted into an=
other inode=E2=80=99s page cache.</p><p><b>Affected component:</b></p><p>Fi=
le: mm/userfaultfd.c<br>
Function: mfill_copy_folio_retry()</p><p><b>Affected versions:</b></p><p>In=
troduced by: f5f035a72423<br>
Incomplete fix: 292411fda25b<br>
Tested on:<br>
- Ubuntu 6.17.0-23-generic (x86_64)<br>
- Debian 6.1.159-1</p><p>The issue appears present in the current mainline =
at the time of testing.</p><p><b>Root cause:</b></p><p>During UFFDIO_COPY:<=
/p><ol>
<li>
A folio is allocated based on the original VMA (inode A)
</li>
<li>
mfill_copy_folio_retry() drops all locks
</li>
<li>
While locks are dropped, another thread replaces the VMA using mmap(MAP_FIX=
ED) with a different file (inode B)
</li>
<li>
After re-acquiring the VMA, no validation ensures that vm_file is unchanged
</li>
<li>
The previously allocated folio is inserted into inode B=E2=80=99s page cach=
e
</li>
</ol><p>The existing fix (292411fda25b) compares vma_uffd_ops(), which is i=
nsufficient because different shmem mappings share the same ops pointer.</p=
><p><b>Impact:</b></p><p>This provides a deterministic primitive:</p><ul>
<li>
Arbitrary page cache write into shmem/tmpfs files
</li>
<li>
Full control over contents (PAGE_SIZE per injection)
</li>
<li>
No timing race required
</li>
<li>
Works as an unprivileged user (userfaultfd or via user namespace)
</li>
</ul><p>Security implications include:</p><ul>
<li>
Container escape via shared tmpfs (e.g. /dev/shm) in misconfigured environm=
ents
</li>
<li>
Bypass of memfd seals (F_SEAL_WRITE not enforced in this path)
</li>
<li>
Corruption of shared memory used by privileged processes
</li>
<li>
Enabling privilege escalation chains</li></ul><p><b>Reproduction:</b></p><p=
>The issue is deterministic and can be reproduced as follows:</p><ol>
<li>
Map a shmem/memfd file (fd_A) and register userfaultfd
</li>
<li>
Trigger UFFDIO_COPY with a faulting source buffer
</li>
<li>
During retry, replace the destination VMA with a mapping of a different fil=
e (fd_B)
</li>
<li>
Resume execution and observe injected data in fd_B=E2=80=99s page cache</li=
></ol><p><b>Proposed fix:</b></p><p>Validate that the VMA still maps the sa=
me file after retry:</p><p>if (state-&gt;vma-&gt;vm_file !=3D orig_file)<br=
>
return -EAGAIN;</p><p>Additionally, shmem_mfill_filemap_add() should enforc=
e memfd seals (e.g. reject when F_SEAL_WRITE or F_SEAL_FUTURE_WRITE is set)=
.<br></p><p><b>Notes:</b></p><ul>
<li>
The issue is deterministic and reproducible in a single attempt
</li>
<li>
No timing race is required
</li>
<li>
It breaks isolation between independent shmem inodes<br></li>
</ul><p>For demonstration, I can provide a proof-of-concept that shows one =
possible exploitation path: a privileged process reading commands from a /d=
ev/shm file can be influenced via injected page cache contents, leading to =
unintended command execution.<br><br>This demonstrates exploitability, but =
is not required to trigger the underlying vulnerability.<br><br>Please let =
me know if further details are needed.<br><br></p><p class=3D"gmail-isSelec=
tedEnd">































</p><p>Best regards,<br>
Andy<br>
<a rel=3D"noopener" class=3D"gmail-decorated-link" href=3D"https://github.c=
om/theteatoast">https://github.com/theteatoast</a></p><img width=3D"0" heig=
ht=3D"0" class=3D"mailtrack-img" alt=3D"" style=3D"display:flex" src=3D"htt=
ps://mailtrack.io/trace/mail/e76ee8a013b1b00046a6b00d194ddc228d9003f7.png?u=
=3D12810248"></div>

--00000000000017bf8a0650d15e71--

