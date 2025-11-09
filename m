Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A8BFCCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 19:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290D28E0003; Sun,  9 Nov 2025 14:48:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241B18E0002; Sun,  9 Nov 2025 14:48:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1095B8E0003; Sun,  9 Nov 2025 14:48:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EBB988E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:47:59 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83DD31A0A33
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:47:59 +0000 (UTC)
X-FDA: 84092104278.14.386CD2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C9A89100003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:47:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F9P37uEu;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVBrgteN;
	arc=reject ("signature check failed: fail, {[1] = sig:alejandro-colomar.es:reject}");
	spf=pass (imf05.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762717677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:resent-to:
	resent-from:resent-message-id:in-reply-to:in-reply-to:references:dkim-signature;
	bh=bMsmvVMronYxCi7B9Ixi7fI8nblWlGeIuqbkTyh86sk=;
	b=JSYHh/ApBFsK5X9n9IdjFJ/1ZbgllLks3qQ/jfMY/UQGHFFWpbvVXYrOonhAfLnMZRZkNF
	6HG5o/MlNmiNkCFaCrqdjr2optWR53el928DWQHluFQiviOJazx9HBqR/PYIpUiAHWchcM
	QZ68f0As87V+xleLHNmPXGK/5+1gXV8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F9P37uEu;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVBrgteN;
	arc=reject ("signature check failed: fail, {[1] = sig:alejandro-colomar.es:reject}");
	spf=pass (imf05.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762717677; a=rsa-sha256;
	cv=fail;
	b=F/FO9Ck0S/0x2RRNhnKWmPehoa3Qj7ZTd5wpCjDArHI+hU8jfmyuFn57bkOGPQgqSCNX02
	snpFq0IysrKjQm6lbjcwL6NNWTxVnszIIbo+fxEwkQYKYk+5iGrysvhnnzqPr60Of3jb23
	lp3ql0utPZ10sxAnHdG4DRl4FpKyP9Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F20E660051
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E685AC116B1;
	Sun,  9 Nov 2025 19:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762717675;
	bh=cS76VJ/JI6iNK/srPXBxGrqz6oloKdZiWqh68DHoirI=;
	h=Resent-From:Resent-Date:Resent-To:Date:From:To:Cc:Subject:
	 In-Reply-To:From;
	b=F9P37uEutt3feu0lGpBR70dx+fOI+AUTy6HiKCmtX9Ukw3JHMFfsIGM/erQXnfKXi
	 aSwwAmAnC3aDbQuUkt8MtNmUFgh6RmKUTtlpi7uyu8YTI9Fehyjrx6xHszdsuujOLM
	 myAQb91HKwA5/oqQ2ie9MjprLXiGS3OigFQgIuxajhPRvIKcRHEczB0jtuEocA1p/4
	 S5v1brXHQbzZpNm6WO0vaA/n3QPC7lIk1GqyebtEvXPerHZ8PgwBtrOehq4UAjJWvq
	 Gtd4UV0bpRrRwoUOu9eYx3ukb0HFM74S0Z1CjjHN0/iJSzVPfvVxuW/QYTnxliMX+M
	 qI7o2c3nujFVQ==
Received: from mp2.migadu.com ([2001:41d0:303:e224::])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by ms17.migadu.com with LMTPS
	id AB38LEjvEGmF1QAAe85BDQ:P1
	(envelope-from <alx@kernel.org>)
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:12 +0100
Received: from aspmx1.migadu.com ([2001:41d0:303:e224::])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by mp2.migadu.com with LMTPS
	id AB38LEjvEGmF1QAAe85BDQ
	(envelope-from <alx@kernel.org>)
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:12 +0100
X-Envelope-To: foss@alejandro-colomar.es
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=alejandro-colomar.es; s=key1; t=1762717512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:dkim-signature;
	bh=bMsmvVMronYxCi7B9Ixi7fI8nblWlGeIuqbkTyh86sk=;
	b=f9sq7nPex3BufykDb/kx5VYOeKI1vrxtE49bCro1HTtjc8lll4+EUgbRX7zgQgeYrvvWR8
	59aD1Hev9Ten4UIywVxRlDAUxVWORiycN6PRBvYOn5gY3g5sYC78C8ddPRi/OSpL4cMZms
	HNBECeWlnL5y77wd8cUYhw8czLtllcjUUFUK3acOjdc+ERwCCX0IVAoc2EKT8xOt2Rq0iC
	QUM8eiy6i9iv83YzHocU0VjKR2C9I+tuEWPNkagvIDsOrazHAR+QIxoKQdg7rtrR0StuLV
	mt1lv8WbJd43oLtrKbrGDU6G82QVPLOq3que3PRGdr32VR4mveCOHj+8S08LuQ==
ARC-Authentication-Results: i=1;
	aspmx1.migadu.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVBrgteN;
	spf=pass (aspmx1.migadu.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=key1; d=alejandro-colomar.es; t=1762717512; a=rsa-sha256;
	cv=none;
	b=hGhJ5cejjihtXF7EYNF5YkkTI3sEVv9VKjf3STdEYDBSTi3dbRANVx2bHpi0GgI3Zjpi1s
	B1a90YEaf5eqXev4KCmcBiZ3h+b408ur1dsT0bfmSnDIwL31oJLwHCOgk8RH9kOiq+GUtz
	jcDWO1blEUVghhJrfMaGNFo+IQqmCnsPHSgF4YslY7oPAwECV2472KX9ZIYDXiobvjOw7r
	w1navkeba9gXJYiqIU1nsL6ZLniovT2UWB6QLQfSXQRSc3J1mCSyIyrR1m6rESHXyUM/9P
	bMDLLQuSHy+TSFmImsiQe8lR0msfvPPr36D8zChnvEHiNhOTFDisxKBr+Iem3w==
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aspmx1.migadu.com (Postfix) with ESMTPS id 0C190CF1F7
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:12 +0100 (CET)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8752B4340C
	for <foss@alejandro-colomar.es>; Sun,  9 Nov 2025 19:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 76092C19424; Sun,  9 Nov 2025 19:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB701C19421;
	Sun,  9 Nov 2025 19:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762717509;
	bh=cS76VJ/JI6iNK/srPXBxGrqz6oloKdZiWqh68DHoirI=;
	h=Date:From:Cc:Subject:In-Reply-To:From;
	b=VVBrgteNJ4dz+ixSe0Lpc009Zi06ZUsQKPZMcj35VGs6WiRif68EuEUNrLLm/L91Q
	 DZ8343KVkIhhdp6FVJAIeAjLQZqtrnix8X+C0PjSvqGrXe0Ure7zbvVlcOcfWN6PHS
	 wkQjHN3CTp4bR3KLNpWe2ukVE++KEiMwzCqIPfvdCnjYP+HjfxzN197D3LWLZn5QOL
	 7aJzE7clxLdo3Rzy26QO0T335Iy4MB0LHJlv3uwCa+G2K6nzO2ceAVifho0BHaCb3f
	 MSrl2fU6Z7/awfewKxk18+92MndJwQhpEIb65vJpUR9uUWS6Z7/+3dMVQGHAIK9pm7
	 71U2/mi39oBMw==
Date: Sun, 9 Nov 2025 20:45:04 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v4 0/4] Add ARRAY_END(), and use it to fix off-by-one bugs
Message-ID: <cover.1762717358.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1758806023.git.alx@kernel.org>
X-Migadu-Flow: FLOW_IN
X-Migadu-Country: SG
X-Migadu-Scanner: mx12.migadu.com
X-Migadu-Spam-Score: -3.14
X-Migadu-Queue-Id: 0C190CF1F7
X-TUID: Tz0USIahhUn9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9A89100003
X-Stat-Signature: z9m7ju3ib3s7t87m3n7981etexserewm
X-Rspam-User: 
X-HE-Tag: 1762717676-572456
X-HE-Meta: U2FsdGVkX19O1q81+4e4s13Y9PnQumci5+uXNojshihD3HU4ZH7Wl2jbf54eyVhIsxFcJR/2VHfW9pyBvFeE0dhl/6VWNotm0h8dS6EtCXC8Cofrq6Yi0xJaPfV1hhVTbmVjIZH4OVIPSUXYb1b1aYTQe5MACC0iN9ppbyh32Fm/kGKmFz26XHv430qIoyyQx8UmR2Leh+SiySOCqAsnCpQ0aUC4b6qD17QVgV8bqxyusfBsHDf2HbhM8qyBT8S3r2hbBSGzcUGX36RQ1kpB4Enp4iXPT5RAvkWxRc5xqEBTrBRx1+afp+/fNrvACoewTLamcob9rYChg2pBPXLCe2yGr2sYYBQ5ZydZZRrxmCIlJ6gH7Dde01YOFowhl01Ioq2ByZ/BRc0aJkknSEQjAz+qja4LMKEy8e0SW88MElizMfCjEjsO3E32Vv9Ma+C9kvOlYI8/NtG+gFhxF14tB8jwkwjstsZA38L6vedm72vZQ/KXqW4yqixI0shJwCPMHZtsfM8Pfvm5t4021N9yMCl8JDhsOUm+XybELXnS2/NcsKoVfcKNpvkU7XxSWx9GbhPrDWp3qiamM4hORGNFCRs9u5cnUZNY36C6NF94i+Ze2loPFURejeBUSTZDmbOijVPC4+CryXbLyWeHKBuBRmQs2MKTxb8kqq5ePL4M9DFrvn7XHTlznscCE//5qEnvChitUeB7lHjNaSIdRTfvQOI0uJVxixoYcaFMtE9mBZF/Bdg7bPVPNZBNfZhealW+t3sjBZ0YoOFwGvJPUDDEphywiYMDaW5W82zPC0v3Jg/f3tAF1aygGsC+r+Pb9qyOQCR0UJMyJ4TxXcsF+Hx2pIIOFw4sfcatmL6719TiB+dKcIyJM22PG0fkZ2bb4PHwHHS5r9rDSZnl7xsKygZcZ4ty9fcI/JZPndTeg3B6kU67ZaBbdPb2m4jpzU5Pytmo9i+2Kr/Tuq2mvVJFlIq
 uEfgNTNd
 JefbYDkCB4pIbEHvhOyxqwiQF0mqbM2DERcMZ2HLKbP25QCaLgqlC2XbV5p+MVtHZIiYlVnhoyuVl9j8anBsiIgQyV7tOyGfpMFRqxC+Q2yS1d1miLpWom946oIVQiIqc+J6gCMcFNYaMytcA67GWaUCM0/SluHKNdj6cZY3JtR/niq2IAlsxYX5tzNHGKVbVJD4GP/W7D9c/haAkr1+fy1il5D9WykCDwf5h2++M6Y9HmlPctYQEYqtRRX3oxMdtM6EwkKIFOeVfhopXeSeAH4TU+fnC/NIs4gvtErG9aLpWvN1KKjq4pIvGk/ZAZ4oc5QI25XE9L2orxiFSayjx4rsl/ouGI3hJokI0xCWd4LyE8Jvf6iPggGjuZTCQzgxjGixGvjGLIXufdaDdvGt1EaRaduTDXXf8d0pE6+p1c93gtBUciFeQZ0utPNJ8Crjd26MQ5BJchWjW/ufchNhW6sZPoryUT1NTBRGMxoI+peAJLHNtpuKhcP2BWj6/Q5Zos8Qm/YZ+eSvIhlDBynvw6of/rnGEr2/O+NpJVSn2MYC/8fk9arZmj3O0CrDh83rjYLvUN+qDUMM0rdG+yBDK/XLyvctw7NKG6XhHU06EMwNafZ2RwYmQON+sIl0tDLOjB5onIJPUodoGwwq/zZFZNwSrHRCqAPKAj+HHh7+SKjosIlRY8R+IKbMJJBgBLtLwUTpBQX6C+MNhX/bvr276ZtHIKER1xeQQ9U7jQ60KoG6ecF0YaAX9yrVTqdIWjcR8ROJbGcIRNQJKQNCj8X4yM2hZdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ARRAY_END() is a macro to calculate a pointer to one past the last
element of an array argument.  This is a very common pointer, which is
used to iterate over all elements of an array:

        for (T *p = a; p < ARRAY_END(a); p++)
                ...

Of course, this pointer should never be dereferenced.  A pointer one
past the last element of an array should not be dereferenced; it's
perfectly fine to hold such a pointer --and a good thing to do--, but
the only thing it should be used for is comparing it with other pointers
derived from the same array.

Due to how special these pointers are, it would be good to use
consistent naming.  It's common to name such a pointer 'end' --in fact,
we have many such cases in the kernel--.  C++ even standardized this
name with std::end().  Let's try naming such pointers 'end', and try
also avoid using 'end' for pointers that are not the result of
ARRAY_END().

It has been incorrectly suggested that these pointers are dangerous, and
that they should never be used, suggesting to use something like

	#define ARRAY_LAST(a)  ((a) + ARRAY_SIZE(a) - 1)

	for (T *p = a; p <= ARRAY_LAST(a); p++)
		...

This is bogus, as it doesn't scale down to arrays of 0 elements.  In the
case of an array of 0 elements, ARRAY_LAST() would underflow the
pointer, which not only it can't be dereferenced, it can't even be held
(it produces Undefined Behavior).  That would be a footgun.  Such arrays
don't exist per the ISO C standard; however, GCC supports them as an
extension (with partial support, though; GCC has a few bugs which need
to be fixed).

This patch set fixes a few places where it was intended to use the array
end (that is, one past the last element), but accidentally a pointer to
the last element was used instead, thus wasting one byte.

It also replaces other places where the array end was correctly
calculated with ARRAY_SIZE(), by using the simpler ARRAY_END().

Also, there was one drivers/ file that already defined this macro.  We
remove that definition, to not conflict with this one.

---

Hi,

v4:

-  Use 'arr' as the macro parameter, for consistency with ARRAY_SIZE().
   [Reported-by: "Maciej W. Rozycki" <macro@orcam.me.uk>]


Have a lovely night!
Alex


Alejandro Colomar (4):
  array_size.h: Add ARRAY_END()
  mm: Fix benign off-by-one bugs
  kernel: Fix off-by-one benign bugs
  mm: Use ARRAY_END() instead of open-coding it

 drivers/block/floppy.c     | 2 --
 include/linux/array_size.h | 6 ++++++
 kernel/kcsan/kcsan_test.c  | 4 ++--
 mm/kfence/kfence_test.c    | 4 ++--
 mm/kmemleak.c              | 2 +-
 mm/kmsan/kmsan_test.c      | 2 +-
 mm/memcontrol-v1.c         | 4 ++--
 7 files changed, 14 insertions(+), 10 deletions(-)

Range-diff against v3:
1:  2cb4ddff93b3 ! 1:  9f87d6208a6c array_size.h: Add ARRAY_END()
    @@ Commit message
         Cc: Michal Hocko <mhocko@suse.com>
         Cc: Linus Torvalds <torvalds@linux-foundation.org>
         Cc: Al Viro <viro@zeniv.linux.org.uk>
    +    Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
         Signed-off-by: Alejandro Colomar <alx@kernel.org>
         Message-ID: <37b1088dbd01a21d2f9d460aa510726119b3bcb0.1752193588.git.alx@kernel.org>
     
    @@ include/linux/array_size.h
      #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
      
     +/**
    -+ * ARRAY_END - get a pointer to one past the last element in array @a
    -+ * @a: array
    ++ * ARRAY_END - get a pointer to one past the last element in array @arr
    ++ * @arr: array
     + */
    -+#define ARRAY_END(a)  (&(a)[ARRAY_SIZE(a)])
    ++#define ARRAY_END(arr)  (&(arr)[ARRAY_SIZE(arr)])
     +
      #endif  /* _LINUX_ARRAY_SIZE_H */
2:  831155f02bec = 2:  ac55d92551e4 mm: Fix benign off-by-one bugs
3:  d8128f0c8b9f = 3:  ca8dec7f5bc9 kernel: Fix off-by-one benign bugs
4:  9646a1d194a5 = 4:  980c8fe8a6de mm: Use ARRAY_END() instead of open-coding it

base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
-- 
2.51.0


