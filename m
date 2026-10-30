Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9566F606A321
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=CNh8Hsdf
Received: by kanga.kvack.org (Postfix)
	id 8DC436B05C6; Fri, 30 Oct 2026 10:46:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866D96B05C7; Fri, 30 Oct 2026 10:46:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7078D6B05C8; Fri, 30 Oct 2026 10:46:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 420CF6B05C6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:46:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADF2F806C0
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:46:17 +0000 (UTC)
X-FDA: 85379567994.17.8E03959
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id BDEDDA000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:46:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=CNh8Hsdf;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RclavrmKYR8zYBwA6iFW+yoiLf2sni8q7Y+lTpJV7rY=;
	b=1/4j/12Obr1F1WcPS+kPTg383nQzCikF/ajJL4hRWngX8Uyda73g1fY5yDDQjTEILAxfl7
	y6W0SqK0Q5CL2bxTeI7gjidczeaHmikqriQHppZc+WBUriwQTELPlloPURfQmbLytT38Bc
	rBhpuz8WOXFs0r6JItTeBv9ogkThyTQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=CNh8Hsdf;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371575;
	b=TERE+9JbN2fmf/RvnCWfnW8R216xRLa7i77n8qHqhB4mH18HTldQQbKGRJ7hTzoM8Js6BI
	TCOO7a4Iy7QYfTboTWp+G7diavhI84JZiiDvxuLa70oWD5U84ooNlsWFdmIzAU4gpfaXVn
	RqIcRSwoPH8aB7cj/ivFOZ3BtkwzGig=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f3c8958d5so89991185a.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371575; x=1793976375; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RclavrmKYR8zYBwA6iFW+yoiLf2sni8q7Y+lTpJV7rY=;
        b=CNh8HsdfmQFzrGGR9MDCFhJBP4AGYDT7H7HoquWeUNmQs+OgbrxtSa0j0fkYIoQttl
         R8mNvqrxGHjWmhRzqfNCHxlPvtzLX2GXHRe1+6f2IGlc4X67EGNKuphXzRbVJWvA7HV2
         wKXYD0nJOK28Ee5/OyAynqWIVfexSFT38sZS36pnpTLiC5VMW3U4QsYbu5l4hWjUQfqy
         mOUNgUEHGWn44Yfd0/4kCMfhvSb+bTCfkB5HUtqvyNis64+KUacPEiY2leGzbdw67maA
         mnKpMhnzZEaywHHgZBYqwPswmcL3iUYINbxRmJsPpEd4ixgjvaohB2fciGteibaAFZT8
         7+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371575; x=1793976375;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RclavrmKYR8zYBwA6iFW+yoiLf2sni8q7Y+lTpJV7rY=;
        b=Ov44iWfOMbCSRn9dDM2ur4nlY6WSSlPfEe64pYLbr3NMCTDtIdPukzB+NOtJZNygvZ
         yM+uKxjRHYAWnPWvcm1cHbkpa3xa//R5D2hjHURCZeGcVVZZOI3DZjg9TiDXDVNlsucr
         FjLBdTtVVbG1F7QeDpwCzm4VQxwTzNxYW3JT3VRxBeDIYsorhkPKCrwvn8xecsYxvKSA
         aTGoa9CyoSkbKUUdsbmAjDmFA/7BnJA29IGNE3jSxukf3xcfl7neRmV34ixKXFVNEOSr
         pXcxgA+M/UFvDg9Psj5Arl3IuRAR50SlLOmOhbmN9YP+A1FjBVDZTlxdNgFQuMRb4Yq9
         aM6Q==
X-Gm-Message-State: AFq9FYL4E2l8bNrWF+Jnf3GVp+csdnqksmi8IFOh7PeuM0WO9QglZQ/A
	xbb4N/srbsobh+5dQZ6zbZp93RZX073co+O9z+mjPGxYpNFSWUU8uGJHVCtPuyu4BbtlvGHEKw7
	Izlp5n6U=
X-Gm-Gg: AYBFou3y07n/Grs+664NxupnaKPkmoJR962V2WcW3j6IFKW/2R8HnYpOsuYCydrgc3p
	NRhL+TXSpXZGbLDrbLCyx2YF7JlH8tpzmMnl+C9CH3cT3aIMEcprhfflUpt9fqVGUmgOk6HfEy+
	pBB9aFCOUI+IQKawNtiZuDCufM50sFB44buA5XgdFdtaHdpDoxqAZULra6h7mdczd3CVKA7QGBR
	oFJoEWRMQFCR0bwX3kzI02G93VsAopiXNesOdaKOGqT4An8Cn62p/57K1DUzcuOE7OTPZ2NapKa
	nqvqhfx82ErW27jGrZVWgIdiTHGWeu1AfLLp7eZkDs+HCYwUgZep7WootqGuSyONKwgRWANAjKU
	aZ9PLmPWw3tnH9EMHX8RKpsr5I0MtClxpvP2YkOjc/Sj5jyJ06F7AxbeUuMCqrSPALyFh58+JUX
	avgNmwpPq6RJUV8cocY3THREdRNbFjBePD8x3SLp0YAKhID2bhRO4CKyDrA9wOtgGZa20qKQz/l
	j91QVaA1NaHmlmBo/cqCgbCIQQO3PZyuayxsEgJekdkdD8tYSeg/JmtMjjzfpgxpFniIzwfswDK
	gZG4sx/V8qoshvLJHKtZh+09LThHsEujjw+PN1KVaUFcyA==
X-Received: by 2002:a05:620a:2989:b0:939:de48:e41f with SMTP id af79cd13be357-9442167723amr446697085a.31.1793371574905;
        Fri, 30 Oct 2026 07:46:14 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.249])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-944252e5492sm158644085a.1.2026.10.30.07.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:46:14 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 30 Oct 2026 14:46:04 +0000
Subject: [PATCH 1/2] binfmt_elf: fail the exec if the image can't be
 trimmed
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-b4-binfmt-elf-trim-v1-1-dbd8683bccf9@toxicpanda.com>
References: <20261030-b4-binfmt-elf-trim-v1-0-dbd8683bccf9@toxicpanda.com>
In-Reply-To: <20261030-b4-binfmt-elf-trim-v1-0-dbd8683bccf9@toxicpanda.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371570; l=1902;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=mcWigSZ31aOPfjIvV2ZnPXU0SXI61cAyYzcWE50Squo=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QBpJcKYFs7IlTwoxGS5PBOmkhtM0PT5KngLR7zx8sX79DnQwktQo+kY6Uvnt8SOiw21Q2Qpyf6p
 sF8oWWcAvQwM=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BDEDDA000C
X-Stat-Signature: 6rmasptx1bgah6zw1j6453gcn8fw7hhh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793371575-445822
X-HE-Meta: U2FsdGVkX18Sw0Ni3CoKCJjOVjVeHbdN5x/TuWRtyuvA5zI+uXUDFqpTjS7I2lo0k5gK57eN+fm+vq1/3Tfzr/ARjuv+VBRTSYTKVrz8HAfXh9rvG+f/twePEkS2OGF8nslcmmo8+vAApVC/BOJEJ6lQB5yoCy0TZRsaQdVMHVMq2lyZUwHNCDWndBZv/LoIYkSngxSDSMwbjJ7URNERL1X7RknnjAAcL81vzP2fZKQ5A1mv5CwSaupAHSqhfdI5suYPlPShJL9NOv5uhLUcg0CHWWUQn+vpIBNi5AUmSFLPhQuBzYyLHRiAJweX47zG7prIRwGr0QLoOm2pnYV5+cN849wBHa16h1hvEfaz+nknz/Xc8MKQ78IAldfDBBvdthPKq8MmQbQEDITDrqwlgM1TOo7R1uxnpDvHz3DtWxpnrzua/B/OVo+GfES8ruZve4cX4qQcD2i3b8zdqLOhXQnVxoOPTDOQihLBEeBLsDgIJ0ceJcVHUpg1rRBEOREPjkL0r8DUu7ShajRtfKrZajglXKJaRzwTR7bl5q9cHvz2Dfe9mD2810S0wJkN2JMw1fh2SgWsr6QiaDrk4eoM8bp8RX68398OAjtlWydz46wVK+j6DC+7pnaDkpUxwuKJTtNWEmouW01FpqPnuGl2TohxCZETlf+LWhX+xRGMt+/mCjSEMURagPuaQY5grD8L7HxlcZGs+JkEOWec9TmO2XvKIIOq0cTPmU+mzfPT7WPmWvJnlFNVNVTo4lLzg5hVa82w+fcccChtwTd9L3/bP2wjSP9Gi4tKQTz/WV6RkInckjSMXnComqNrYyKQ4tz3xOw2nhoCTRmyx9q61L9ejs5Sg8Cezz0ODWkOld/+5BBz4XSD1wbcn1Q1Y4g9XsBLiWdyjo8h9x4vYmX6e3VSn61cIkCpu3JZXOvFVw5Yxb7sDhVPCSpzdi+I2LU4jyEv626TH+FQBEcuc/RZawQ
 hiWZPjOE
 QkW4dQONXVor2A0jyjzEpQDW7zUD3r/4qeNP1CIJl2LvzaKNnx7jLTOMBIek54UeMQSyXZ1Or60GtIc6O0ipAKBakpF+w1UKdUoPKlJdQ2viYCcn3a7nk7E8NWtxfngoCq7CNgoEMth4AgXe6tReMDw0k3cIzBsHUFDbzxYAC1PwMckdDUT1yTjhP5nJUXoczKLICzbrFfKqBPFGfgUVTMmINRq8B0jE0H2zriKsJiBJCKmG5ywpF2lDxRnjaWYWAGcDulMa6kzNCfzTsvtib/ERVv7w7YjnYjZupyJjTMkNiBAeM0k1GmZNOH93MQ1WwBgO0FfHm+gWEyDIYbqBDvKNt22C2dYm4qLQdOoHBDZIWKP46s592qab5dk702vARSBST
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An ELF image can be started with the holes between its segments filled by
file contents, mapped with the protection of its first segment.

elf_map() maps the first segment with the size of the whole image, to find
room for all of it, and then unmaps all but the segment itself. That unmap
splits the VMA, which can fail for lack of memory, and its result is
dropped. This was reproduced with fault injection, by failing each
allocation of an execve() of a static PIE with 2 MiB aligned segments in
turn.

Fix by returning the error of vm_munmap() from elf_map(). All callers are
past the point of no return, so the task is killed and its mm goes away as
a whole. A failed trim of the alignment probe for a static PIE was harmless
so far and fails the exec now as well, which is not worth a special case.

vm_munmap() returns -EINVAL for a length of 0, which went unnoticed so far.
Skip the call if the segment ends in the same page as the image.

Fixes: cc503c1b43e0 ("x86: PIE executable randomization")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/binfmt_elf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bf7f8f47548d..bf0d4df16ae1 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -391,8 +391,13 @@ static unsigned long elf_map(struct file *filep, unsigned long addr,
 	if (total_size) {
 		total_size = ELF_PAGEALIGN(total_size);
 		map_addr = vm_mmap(filep, addr, total_size, prot, type, off);
-		if (!BAD_ADDR(map_addr))
-			vm_munmap(map_addr+size, total_size-size);
+		if (!BAD_ADDR(map_addr) && total_size > size) {
+			int err = vm_munmap(map_addr + size, total_size - size);
+
+			/* Don't run an image that has its holes filled. */
+			if (err)
+				map_addr = err;
+		}
 	} else
 		map_addr = vm_mmap(filep, addr, size, prot, type, off);
 

-- 
2.55.0


