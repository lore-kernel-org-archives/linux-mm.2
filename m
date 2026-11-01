Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD9F606A32C
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XNaEpYYy
Received: by kanga.kvack.org (Postfix)
	id 515716B05B3; Sun,  1 Nov 2026 13:27:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F736B05B4; Sun,  1 Nov 2026 13:27:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 367156B05B5; Sun,  1 Nov 2026 13:27:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFD776B05B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:27:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B280160A6E
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:27:12 +0000 (UTC)
X-FDA: 85387382304.24.B604508
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id A87FFA0003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:27:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XNaEpYYy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of zhangxp1998@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=zhangxp1998@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793557630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUU1nGwWnmMrHXGJh08o6CeAPeT6DZPgaa4XD+hq+Ac=;
	b=VksClLsyb1ZrLCoUD890c1Meioc4CAKj0q5O0Ay203dlC9iAGqW9xN2lgGZloIQDAp2IPb
	ARd9njPdqPNh58HyhfIof9DayXKfvLzPz73zrM0pO2nS3pKK1XCasH/IjkOS76Qaga6t6V
	5aPnoR4x+uKMtm3DJatbMcN8B3hDSEc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XNaEpYYy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of zhangxp1998@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=zhangxp1998@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793557630;
	b=3dnUoYRyZ2wRGUJTTXt2z3HXjjanqeCmVMT3B0MtwnenR1XIKOpc5BOx+CRTjBiNKD/NQE
	SvB2gZVYTZbiHIPiSx3f6IbAiVo4o2UrF4IcmgP/w7Ma/bW4np+ByZVb2A7eadpClOv+1c
	/2qhqrvfBdC0+eyzCal232aBvxjN/Zo=
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-35b2c599f43so3269590eec.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 10:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793557629; x=1794162429; darn=kvack.org;
        h=content-type:mime-version:references:in-reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aUU1nGwWnmMrHXGJh08o6CeAPeT6DZPgaa4XD+hq+Ac=;
        b=XNaEpYYyjmNqRUQ4yr9Omzt9iRdFsnLwbzrFOrNN74Z9B1kEYSCX5bFtzRFkbsBhOG
         cGVmdokbODmWpPOCrlAB8QSgUt5Kfev+pWYNMFAVaQCjRO5PXuKIIU1N0zjPriE98mg0
         PA6/Gig36Mff8qIW3xNUviNsvZhmWTYIULVD52NawFds69whWtAkpOJ3AO9GdoJYXUMS
         kIfYpY4myaAAra0DRgvIY8ZRkGXoZ61XDP9msu7wDUKHGLBZkLKYGijNSN1GmZlBGLU8
         LgMy/LktKWauRxLOEop0K1HzT01U+4k609cnVSqGgOZh6+j65j/sqYd03tPrz1w9lnx1
         t67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793557629; x=1794162429;
        h=content-type:mime-version:references:in-reply-to:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aUU1nGwWnmMrHXGJh08o6CeAPeT6DZPgaa4XD+hq+Ac=;
        b=COq44dcEF6neHUuISc32AvP8QtLhOh9ch62PnB/QXZvbJdFU16mjRo7QWP2fxPgnRB
         k/GHaFrxaKRh4kdInwV/w2vyqfpTclRCUVHaKQWs5vD1l81GQTFPR4vSp375h1JIwMvF
         q9PcqLncCMMhPeD4l2HFpd5586hHOVdseqXoVgjmm/pFQcDVzPKLt/nm6AeGv2UpbGTF
         7FPXBEPPYEJEOavUni0SJ3hRz/y++oTS8or7xVjI2dwWsQMV3aHAakoDZ1vcZxEAiXZo
         op934rNDijOF6YfeTHHusKa4gZRQBRCgjKHGRhDngKMxNMttUpK6tvfLsxMOoR+s/LNG
         iHjA==
X-Forwarded-Encrypted: i=1; AKwUvBwYf/EzH9TG5+IPICjiZwCxYOC/gdepCxNDpWT7zqJz/nVXJFOdSvsS9gXJrbvEOrfc2KshuYg6Yw==@kvack.org
X-Gm-Message-State: APuU4Z/B/3ulkla42qfuol4bCl+F+6QLjlhjvRqKMB+mvhhZ47I58sWr
	6aXlDuhhKwWIU+FDUrIFPcrkzVlPO9bdlRmRjAmElApNw/pjiuxhKI4h
X-Gm-Gg: AYBFou1UHWZlT+rLiTJCiO2szDq8Jw/1G5feklkM9E2nIJ2SdiY7xX8CI0gq87ydd0P
	O7yIl3Msq7A3QKjLnBeeaql7fV64o4ZqGTm+vvAGKiz48YgQwvO/xVwO4Ugl2WpnO5SrCGKf8eB
	YcFZ0Qp6mogeLMmV55COlNv5VJpyoisJXM5L2S6X5j1iI9sEhxBsBmHlbBVrUiUy/gpc2IsEBzC
	WQZriDi5YfIoX4gQ38ePK8gYMbu3G8OdC6hawCTJWYAseWmPqxZ4+6KNdTea7JzUMpT7n3ENusp
	5L96fFcPBE8SPv6Znk/j4oiOw6uK3hJO8X1tkYjigJVtTt8HgaUgP9z/+jOpexmFU23yNRyrJG2
	oGeElCWIz0dFWfK17RH7vB8iz2IuwWaVfS0plcdtUCVBPm43BW1ZzPuV/CUu39KEjhZiEqs0bRO
	ZgB6WkNqHB6wmeKm5xdczVlxR0JK3I8N+hO8q8uUu73V19aBxktmCCFoDODS3IMRnjP6Z6jHtgC
	FHHPizbTpYelJd3wLP/O7GEYWAkeDqPKvY2pUYnwsYR/XZSKPLiO33cAIbHqId5dya/zJzxtgsW
	ghdT77wd9DsDT1zNnalLwaU/Lk7qMLag4QQ=
X-Received: by 2002:a05:693c:69d1:b0:358:3426:d601 with SMTP id 5a478bee46e88-36a4221b3c6mr13335197eec.2.1793557629049;
        Sun, 01 Nov 2026 10:27:09 -0800 (PST)
Received: from [127.0.1.1] ([2601:647:4184:b3f0:b5a0:ac44:5583:ef02])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42952e1csm31758645eec.20.2026.11.01.10.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 10:27:08 -0800 (PST)
From: Kelvin Zhang <zhangxp1998@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 "Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Kalesh Singh <kaleshsingh@google.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: check THP exclusivity for each subpage
Date: Sun, 01 Nov 2026 10:27:03 -0800
Message-ID:
 <179355762314.2759535.4568050479263510899.pagemap-thp-repro@gmail.com>
In-Reply-To: <da1dc033-9131-4b77-9443-a8cc82fd7e58@kernel.org>
References: <4c1b393a4b04bd94e4f1c7879ae04e1793eb0931.1793552446.git.zhangxp1998@gmail.com>
 <54617273-262f-4e17-b912-8b07113ca45c@kernel.org>
 <da1dc033-9131-4b77-9443-a8cc82fd7e58@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5072210820627741972=="
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A87FFA0003
X-Stat-Signature: 8wfp5yugfw957c37z6bfpge96bi68c8z
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793557630-726080
X-HE-Meta: U2FsdGVkX1+4aszd4dW3qoXHToj7WJTu0Jz98Uo/G+vJ8k7BgF2T1sxX37p0/NLoTgBwcOhSzFmNcLLrYeaE74IogxrrVqMM1ZjQdtSlqr2+a6lZlt1FnP5p71hWWn9xsgklFQdTrFzjkZVeBCuGqPbk34QNPuSUUFLCNYX/ZTCKT4v4wH+sYC4AeO+qjv1z0YlJGZX76Y88ljtugXjNmlF0/tAY3oQhXpGBcVmffga0pYXRmBcjYQgpeP3FumO2QK35K6+rB7FgV9A7R0QIiewXlCY3z/VOlz1iThjdxDE5gufMj5Ox8KpBSJYc7kH+Y/V0uIWNOGHrHp5xSgOuCPD7iSU43sGWEmzNMTbHy8yiWdBgyJ9ODE6OWIHPOj2T/3TpkTz69rpEDZQy1M9CgJmVHh3eFB+/CPpod46S3MxgBh4Sw+pvTnmU8fnGsdb3x10jtvTAZeta43+hdmMSAx9hc6sOUk+svaxcym/6IxpWEMcVhNr6m2Ym0MqLbs5AVpGi9bpvHz3Ht1x388sAdkaOZ9ugeSaKhzhyHnV508MjtOz9xA41qfcD/27cm505/YK2qO+ptBijYtkba+krQYjOcZc696inmnv9VlE/4zWalKTmKhyX7fvyicQ0PS5zi7E1bzSSIjGcJdGVEC/uTLC6WI4GoMHWOvI0tmzRmvn9ZsJ5znVSMh7hJ9vEA4KqvQGi5r9Ks1f56qqgAmrfcu2+ACIO3gwwE3vnb2k9kXHUCTH3vZCbdTjci5PkB+Q01kmqyaxusSR2p763+N6pktMS3n0uQau/LA5viCWLrgfYxdxqGY2CNHsntx53NJfWd5NKQTZ/1jToPYnBrnBLl738his1r5BcWlCpBTxuypeMz6w0+60h+o5iXg9nOouv5Cn7anqrBaVLGcctqgZEbJRd/T5rbUcidP5rlbkVo6qHfx98V89/mFHF4Vvs6qMAFwi6OgXMhPCZARcN4H5
 6V2Ckqhb
 GcBmnXX3dxC2FxZCxLdJDcxxZrMyshS2RYwAM4KwxUGe1JY0cH/ehD9dGugZVFlrlh2Z3X9S3lWQsVdUsj3pMFZMJQUKQT1YPyhVgZIGjHw2va9r1FzqhQMvV1JYE9CHrN4ayCpg5xzjFufrTi7dVsUHRwMl3NW5nUYDY+WEVccx4hB3LohKXSVrDGFgXSsZWzR9Tx/FJ6jq+2poHcl1YBojm9mRq0U3NA5RjGw+qXRTvNNbDJHFvUuZKrOXXONzghjR2th0LKQL6L+aC83iRxcfP6L+sppuU8Y+TP11Pz5jEgEjee+oDjNNLtFOX59CHmRKy9CC1pGMd9nIck1iWkGko457vIwUbHriq1d/ggt8vXmui+G1H+2aLmTQCYRWMCsOQcXISRRyyP5/Mg+HSW23p4HYM1NksNCC5+CFHY2ySNioGi76qRv8/gbbZvSKUwXbjO9xHViCMEU6nCg5k/7tINIKps6hjqK/X3Uh1YG3l61jYDlXTukJudA8gpHpO4FC+2sbdOYEi8ZCeqrvPsC3uNV53XgOkJKVppN6xg2aZ16Cw3ZCoVpz9BE1jlPueGZHASMkc1UtpVKNR8NdcRTLtFf6roxgq7QYGzkIJgZTtIReFJfFy/XwYMoFYCRspknv5XyKU7PtGKIfq0cgdAKH6FHDRAiOjctx4r3YsxN0nwzLJV6hJl9GekUlguTwB6qvMeNFCKuEpXuxFrr5CmDk5ZwsaJYuqLCVTxDQr7/S9YlTmj1qE81S6pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============5072210820627741972==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi David,

Thanks for the clarification.

I don't have a real application depending on precise per-subpage bit 56
values, or a production failure to report. This is a review/test-driven
report, with LLM assistance, rather than something found through a failing
workload. I followed it up with an actual old/new kernel comparison.

So I have no workload-based objection to switching to the conservative
whole-folio behavior you described. The attached kselftest-style reproducer
is just to make the current CONFIG_PAGE_MAPCOUNT=y behavior reproducible,
not to argue that exact subpage reporting must be preserved as an ABI.

The test forks with a PMD-mapped anonymous THP, then has the child unmap
one base page while the parent retains its PMD mapping. On the unpatched
kernel, unmapping subpage 0 makes the parent's bulk pagemap read report
all 512 subpages exclusive; unmapping subpage 1, 256 or 511 reports none
exclusive. With the one-line fix, only the unmapped-in-child subpage is
reported exclusive in each case. The fully private/shared controls pass
on both kernels.

Tested on x86-64 QEMU/KVM with 4KB base pages, 2MB PMD THPs and
CONFIG_PAGE_MAPCOUNT=y, using mm-hotfixes-unstable at 64703f0fee74 and
that same base plus this patch. Three runs of the same binary gave:

  Before: 20 PASS, 8 FAIL per run
  After:  28 PASS, 0 FAIL per run

To build, save the attachment under tools/testing/selftests/mm/ and run
from the kernel root:

  cc -O2 -Wall -Wextra tools/testing/selftests/mm/pagemap_thp_exclusive.c \
     -o /tmp/pagemap_thp_exclusive
  /tmp/pagemap_thp_exclusive

It uses the existing ../kselftest.h and skips if a 2MB PMD THP cannot be
obtained. Its expectations are deliberately limited to the current
CONFIG_PAGE_MAPCOUNT=y implementation, not the conservative variant.

Thanks,
Kelvin

--===============5072210820627741972==
Content-Type: text/x-c
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="pagemap_thp_exclusive.c"
MIME-Version: 1.0

Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKLyoKICogRGlhZ25vc3RpYyBmb3Ig
dGhlIENPTkZJR19QQUdFX01BUENPVU5UPXkgcGFnZW1hcCBQTUQgcGF0aCwgbm90IGEgZ2VuZXJp
YwogKiBiaXQtNTYgQUJJIHRlc3Q6IG90aGVyIGNvbmZpZ3VyYXRpb25zIG1heSByZXBvcnQgZm9s
aW8td2lkZSBleGNsdXNpdml0eS4KICogUmVxdWlyZXMgNEtCIGJhc2UgcGFnZXMgYW5kIDJNQiBh
bm9ueW1vdXMgUE1EIFRIUHMuCiAqCiAqIFNhdmUgdW5kZXIgdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvbW0vIGFuZCBidWlsZCBmcm9tIHRoZSBrZXJuZWwgcm9vdDoKICogY2MgLU8yIC1XYWxsIC1X
ZXh0cmEgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvbW0vcGFnZW1hcF90aHBfZXhjbHVzaXZlLmMg
XAogKiAgICAtbyAvdG1wL3BhZ2VtYXBfdGhwX2V4Y2x1c2l2ZQogKi8KI2RlZmluZSBfR05VX1NP
VVJDRQojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHNpZ25hbC5oPgojaW5jbHVkZSA8c3Rk
aW50Lmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVkZSA8c3lzL3dhaXQuaD4KI2luY2x1
ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSAiLi4va3NlbGZ0ZXN0LmgiCgojaWZuZGVmIE1BRFZfQ09M
TEFQU0UKI2RlZmluZSBNQURWX0NPTExBUFNFIDI1CiNlbmRpZgojZGVmaW5lIFBBR0VfQllURVMg
NDA5NlVMCiNkZWZpbmUgVEhQX0JZVEVTICgyVUwgKiAxMDI0ICogMTAyNCkKI2RlZmluZSBOUl9Q
QUdFUyAoVEhQX0JZVEVTIC8gUEFHRV9CWVRFUykKI2RlZmluZSBQUkVTRU5UICgxVUxMIDw8IDYz
KQojZGVmaW5lIEVYQ0xVU0lWRSAoMVVMTCA8PCA1NikKCnN0YXRpYyB2b2lkIHJlcXVpcmUoaW50
IG9rLCBjb25zdCBjaGFyICp3aGF0KQp7CglpZiAoIW9rKQoJCWtzZnRfZXhpdF9mYWlsX21zZygi
JXMgZmFpbGVkIChlcnJubz0lZClcbiIsIHdoYXQsIGVycm5vKTsKfQoKc3RhdGljIHZvaWQgbm90
aWZ5KGludCBmZCkKewoJcmVxdWlyZSh3cml0ZShmZCwgIngiLCAxKSA9PSAxLCAicGlwZSB3cml0
ZSIpOwp9CgpzdGF0aWMgdm9pZCBhd2FpdChpbnQgZmQpCnsKCWNoYXIgYzsKCglyZXF1aXJlKHJl
YWQoZmQsICZjLCAxKSA9PSAxLCAicGlwZSByZWFkIik7Cn0KCnN0YXRpYyB1bnNpZ25lZCBsb25n
IGFub25faHVnZV9ieXRlcyh2b2lkICphZGRyKQp7CglGSUxFICpmID0gZm9wZW4oIi9wcm9jL3Nl
bGYvc21hcHMiLCAiciIpOwoJdW5zaWduZWQgbG9uZyBzdGFydCwgZW5kLCBrYiA9IDA7Cglib29s
IHNlbGVjdGVkID0gZmFsc2U7CgljaGFyIGxpbmVbNTEyXTsKCglyZXF1aXJlKGYgIT0gTlVMTCwg
Im9wZW4gc21hcHMiKTsKCXdoaWxlIChmZ2V0cyhsaW5lLCBzaXplb2YobGluZSksIGYpKSB7CgkJ
aWYgKHNzY2FuZihsaW5lLCAiJWx4LSVseCIsICZzdGFydCwgJmVuZCkgPT0gMikKCQkJc2VsZWN0
ZWQgPSAodWludHB0cl90KWFkZHIgPj0gc3RhcnQgJiYgKHVpbnRwdHJfdClhZGRyIDwgZW5kOwoJ
CWlmIChzZWxlY3RlZCAmJiBzc2NhbmYobGluZSwgIkFub25IdWdlUGFnZXM6ICVsdSBrQiIsICZr
YikgPT0gMSkKCQkJYnJlYWs7Cgl9CglmY2xvc2UoZik7CglyZXR1cm4ga2IgKiAxMDI0Owp9Cgov
KiBob2xlID09IC0xOiBhbGwgc2hhcmVkOyBob2xlID09IC0yOiBhbGwgZXhjbHVzaXZlLiAqLwpz
dGF0aWMgdm9pZCBjaGVja19idWxrKGludCBmZCwgY2hhciAqYWRkciwgaW50IGhvbGUsIGNvbnN0
IGNoYXIgKmxhYmVsKQp7Cgl1aW50NjRfdCBlbnRyaWVzW05SX1BBR0VTXTsKCXVuc2lnbmVkIGlu
dCBpLCB3cm9uZyA9IDAsIGV4Y2x1c2l2ZSA9IDA7CglvZmZfdCBvZmZzZXQgPSAodWludHB0cl90
KWFkZHIgLyBQQUdFX0JZVEVTICogc2l6ZW9mKHVpbnQ2NF90KTsKCglyZXF1aXJlKHByZWFkKGZk
LCBlbnRyaWVzLCBzaXplb2YoZW50cmllcyksIG9mZnNldCkgPT0gc2l6ZW9mKGVudHJpZXMpLAoJ
CSJyZWFkIHBhZ2VtYXAiKTsKCWZvciAoaSA9IDA7IGkgPCBOUl9QQUdFUzsgaSsrKSB7CgkJYm9v
bCB3YW50ID0gaG9sZSA9PSAtMiB8fCBob2xlID09IChpbnQpaTsKCgkJZXhjbHVzaXZlICs9ICEh
KGVudHJpZXNbaV0gJiBFWENMVVNJVkUpOwoJCXdyb25nICs9ICEoZW50cmllc1tpXSAmIFBSRVNF
TlQpIHx8CgkJCSAhIShlbnRyaWVzW2ldICYgRVhDTFVTSVZFKSAhPSB3YW50OwoJfQoJa3NmdF90
ZXN0X3Jlc3VsdCghd3JvbmcsICIlczogaG9sZT0lZCBleGNsdXNpdmU9JXUvJWx1IHdyb25nPSV1
XG4iLAoJCQkgbGFiZWwsIGhvbGUsIGV4Y2x1c2l2ZSwgTlJfUEFHRVMsIHdyb25nKTsKfQoKc3Rh
dGljIHZvaWQgY2hlY2tfc2luZ2xlKGludCBmZCwgY2hhciAqYWRkciwgdW5zaWduZWQgaW50IGlu
ZGV4LCBib29sIGV4Y2x1c2l2ZSkKewoJdWludDY0X3QgZW50cnk7CglvZmZfdCBvZmZzZXQgPSAo
KHVpbnRwdHJfdClhZGRyIC8gUEFHRV9CWVRFUyArIGluZGV4KSAqIHNpemVvZihlbnRyeSk7CgoJ
cmVxdWlyZShwcmVhZChmZCwgJmVudHJ5LCBzaXplb2YoZW50cnkpLCBvZmZzZXQpID09IHNpemVv
ZihlbnRyeSksCgkJInJlYWQgc2luZ2xlIHBhZ2VtYXAgZW50cnkiKTsKCWtzZnRfdGVzdF9yZXN1
bHQoKGVudHJ5ICYgUFJFU0VOVCkgJiYgISEoZW50cnkgJiBFWENMVVNJVkUpID09IGV4Y2x1c2l2
ZSwKCQkJICJzaW5nbGUgcmVhZDogc3VicGFnZT0ldSBleHBlY3RlZCBleGNsdXNpdmU9JWRcbiIs
CgkJCSBpbmRleCwgZXhjbHVzaXZlKTsKfQoKc3RhdGljIHZvaWQgcnVuX2Nhc2UodW5zaWduZWQg
aW50IGhvbGUpCnsKCWNoYXIgKnJlc2VydmUsICphZGRyOwoJaW50IGdvWzJdLCBkb25lWzJdLCBm
ZCwgc3RhdHVzOwoJcGlkX3QgY2hpbGQ7CgoJLyogTGVhdmUgUFJPVF9OT05FIGd1YXJkcyBvbiBi
b3RoIHNpZGVzIHRvIHByZXZlbnQgVk1BIG1lcmdpbmcuICovCglyZXNlcnZlID0gbW1hcChOVUxM
LCAzICogVEhQX0JZVEVTLCBQUk9UX05PTkUsCgkJICAgICAgIE1BUF9QUklWQVRFIHwgTUFQX0FO
T05ZTU9VUywgLTEsIDApOwoJcmVxdWlyZShyZXNlcnZlICE9IE1BUF9GQUlMRUQsICJyZXNlcnZl
IGFkZHJlc3Mgc3BhY2UiKTsKCWFkZHIgPSAoY2hhciAqKSgoKHVpbnRwdHJfdClyZXNlcnZlICsg
VEhQX0JZVEVTKSAmIH4oVEhQX0JZVEVTIC0gMSkpOwoJcmVxdWlyZShtbWFwKGFkZHIsIFRIUF9C
WVRFUywgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwKCQkgICAgIE1BUF9QUklWQVRFIHwgTUFQX0FO
T05ZTU9VUyB8IE1BUF9GSVhFRCwgLTEsIDApID09IGFkZHIsCgkJIm1hcCBhbm9ueW1vdXMgbWVt
b3J5Iik7CglyZXF1aXJlKCFtYWR2aXNlKGFkZHIsIFRIUF9CWVRFUywgTUFEVl9IVUdFUEFHRSks
ICJNQURWX0hVR0VQQUdFIik7CgltZW1zZXQoYWRkciwgMHg1YSwgVEhQX0JZVEVTKTsKCWlmIChh
bm9uX2h1Z2VfYnl0ZXMoYWRkcikgIT0gVEhQX0JZVEVTKQoJCW1hZHZpc2UoYWRkciwgVEhQX0JZ
VEVTLCBNQURWX0NPTExBUFNFKTsKCWlmIChhbm9uX2h1Z2VfYnl0ZXMoYWRkcikgIT0gVEhQX0JZ
VEVTKSB7CgkJZm9yICh1bnNpZ25lZCBpbnQgaSA9IDA7IGkgPCA3OyBpKyspCgkJCWtzZnRfdGVz
dF9yZXN1bHRfc2tpcCgiaG9sZT0ldTogbm8gMk1CIFBNRCBUSFBcbiIsIGhvbGUpOwoJCW11bm1h
cChyZXNlcnZlLCAzICogVEhQX0JZVEVTKTsKCQlyZXR1cm47Cgl9CglmZCA9IG9wZW4oIi9wcm9j
L3NlbGYvcGFnZW1hcCIsIE9fUkRPTkxZKTsKCXJlcXVpcmUoZmQgPj0gMCwgIm9wZW4gcGFnZW1h
cCIpOwoJY2hlY2tfYnVsayhmZCwgYWRkciwgLTIsICJiZWZvcmUgZm9yayIpOwoJcmVxdWlyZSgh
cGlwZShnbykgJiYgIXBpcGUoZG9uZSksICJwaXBlIik7CgljaGlsZCA9IGZvcmsoKTsKCXJlcXVp
cmUoY2hpbGQgPj0gMCwgImZvcmsiKTsKCWlmICghY2hpbGQpIHsKCQljbG9zZShnb1sxXSk7CgkJ
Y2xvc2UoZG9uZVswXSk7CgkJYXdhaXQoZ29bMF0pOwoJCXJlcXVpcmUoIW11bm1hcChhZGRyICsg
aG9sZSAqIFBBR0VfQllURVMsIFBBR0VfQllURVMpLCAiY2hpbGQgbXVubWFwIik7CgkJbm90aWZ5
KGRvbmVbMV0pOwoJCWF3YWl0KGdvWzBdKTsKCQlfZXhpdCgwKTsKCX0KCWNsb3NlKGdvWzBdKTsK
CWNsb3NlKGRvbmVbMV0pOwoJY2hlY2tfYnVsayhmZCwgYWRkciwgLTEsICJhZnRlciBmb3JrLCBi
ZWZvcmUgY2hpbGQgbXVubWFwIik7Cglub3RpZnkoZ29bMV0pOwoJYXdhaXQoZG9uZVswXSk7Cglr
c2Z0X3Rlc3RfcmVzdWx0KGFub25faHVnZV9ieXRlcyhhZGRyKSA9PSBUSFBfQllURVMsCgkJCSAi
aG9sZT0ldTogcGFyZW50IHN0aWxsIFBNRCBtYXBwZWRcbiIsIGhvbGUpOwoJY2hlY2tfYnVsayhm
ZCwgYWRkciwgaG9sZSwgImFmdGVyIGNoaWxkIG11bm1hcCIpOwoJY2hlY2tfc2luZ2xlKGZkLCBh
ZGRyLCBob2xlLCB0cnVlKTsKCWNoZWNrX3NpbmdsZShmZCwgYWRkciwgaG9sZSA/IDAgOiAxLCBm
YWxzZSk7Cglub3RpZnkoZ29bMV0pOwoJcmVxdWlyZSh3YWl0cGlkKGNoaWxkLCAmc3RhdHVzLCAw
KSA9PSBjaGlsZCAmJiBXSUZFWElURUQoc3RhdHVzKSAmJgoJCSFXRVhJVFNUQVRVUyhzdGF0dXMp
LCAiY2hpbGQgZXhpdCIpOwoJY2hlY2tfYnVsayhmZCwgYWRkciwgLTIsICJhZnRlciBjaGlsZCBl
eGl0Iik7CgljbG9zZShnb1sxXSk7CgljbG9zZShkb25lWzBdKTsKCWNsb3NlKGZkKTsKCXJlcXVp
cmUoIW11bm1hcChyZXNlcnZlLCAzICogVEhQX0JZVEVTKSwgInVubWFwIHJlc2VydmF0aW9uIik7
Cn0KCmludCBtYWluKHZvaWQpCnsKCXVuc2lnbmVkIGludCBob2xlc1tdID0geyAwLCAxLCBOUl9Q
QUdFUyAvIDIsIE5SX1BBR0VTIC0gMSB9OwoKCWtzZnRfcHJpbnRfaGVhZGVyKCk7CglpZiAoc3lz
Y29uZihfU0NfUEFHRVNJWkUpICE9IFBBR0VfQllURVMpCgkJa3NmdF9leGl0X3NraXAoIlRoaXMg
cmVwcm9kdWNlciByZXF1aXJlcyA0S0IgYmFzZSBwYWdlc1xuIik7Cglrc2Z0X3ByaW50X21zZygi
UmVxdWlyZXMgQ09ORklHX1BBR0VfTUFQQ09VTlQ9eTsgbm90IGEgZ2VuZXJpYyBBQkkgdGVzdFxu
Iik7Cglrc2Z0X3NldF9wbGFuKDcgKiBBUlJBWV9TSVpFKGhvbGVzKSk7CglhbGFybSgzMCk7Cglm
b3IgKHVuc2lnbmVkIGludCBpID0gMDsgaSA8IEFSUkFZX1NJWkUoaG9sZXMpOyBpKyspCgkJcnVu
X2Nhc2UoaG9sZXNbaV0pOwoJa3NmdF9maW5pc2hlZCgpOwp9Cg==

--===============5072210820627741972==--

