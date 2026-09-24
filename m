Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61C50C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51526B0092; Thu, 24 Sep 2026 16:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2A0F6B0093; Thu, 24 Sep 2026 16:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3EBC6B0095; Thu, 24 Sep 2026 16:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71C6B6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:39:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E53F91A04B1
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:39:22 +0000 (UTC)
X-FDA: 85249820964.01.3D98F94
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf23.hostedemail.com (Postfix) with ESMTP id 28774140006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:39:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SLN7iy80;
	spf=pass (imf23.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790282361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iop1aYcOw6anN1InXwODk9bRtXPmRstr8biAWMMaEEg=;
	b=Pt6TLaGUMUsH0eGAByavGHJfnSs+/Ad6Rv4tWT+k3OzZtKEyhw949t4V8YmF5ojZXtzEQ3
	lE1cOaHaCWRUzLajMQfa2l6k8sKu/5sbKvO8GBlzIXRYNEI7VYhFbAar3MeHbwnPu9Sku0
	HE6BXHz7pvKOoMBppXZdyYm6xFb7I0s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SLN7iy80;
	spf=pass (imf23.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790282361;
	b=2aDHjKKjW3vO43yluHkuscSfJqDPe4x85iQXbtwB0x/P/iVtZlf0U096mejQuPg6+x7bAJ
	BaEI4ZvzEAkr6nzWa0Q+R1ASqfY5jKf8106LFkfODABIEqGpNmo3T4Dxg/QZ45dbgnj8K2
	4mXQb2yZbQ2KYgxjaT3Julsod993HT4=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843f22dc83so156595f8f.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790282360; x=1790887160; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iop1aYcOw6anN1InXwODk9bRtXPmRstr8biAWMMaEEg=;
        b=SLN7iy803AaKonkJOgqjfV/72z5MwK/dJWZKo7wlh3/o1Kp9PgUaS3fvsCNQc6aYEF
         lohdDRAu9ioS45uETO6coLNOH8UmANUf28L1I1uFyHkGEety5bcs/wz/5H/pX3ARs0iF
         kaAF87LPkqRHp6GMej0lx+Uejj3MjigHlEwQvbXXprTlo9IgwWzqQA05i2P8ojB18bTH
         DszHBvB8s3u9njVe5xsRP1k1EK0wDH2qTrWEsNRQvPNw9AGqaBvD1k3WlO0m3riIE8Nn
         TQsQ0hDIYbgi5abNwW/gGCiz9tqnY4S0iRNNAD9+W00L6JpRzzqdhGSDyW+ru+omkXlu
         XdCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790282360; x=1790887160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iop1aYcOw6anN1InXwODk9bRtXPmRstr8biAWMMaEEg=;
        b=cbq3Ni27V5bI0TyXAeYO3rO06BQuv4yuyDS+xJ2zJrhsun+cPYr/MhDCuhb0eOyd8H
         WE0dktHK1PHw5tXRLm79kTSLuPa8RdoSv49XsppAo5Rw9yCM7LQAM5h/bS67QAHsDf55
         USiXJDc7moBKyYXvROF3crGR/gLwPrvQ8pU1OcP7M9ILl0ObowEj1Ba0nMEjaahUQ2Oh
         9yWYBK4AWgONvXvrKKNrT+LXeGH4vh3JPXAOizmWFKGP7lFd/elT62Ja7aJNWuO60rbK
         ZH3yvO0y76kapyixNWigrVEGCmoQu2cxWeH3tilEjVTyV++UuHWB3OaxRaTrhojj+Er+
         hh4w==
X-Forwarded-Encrypted: i=1; AKwUvBxhMfYWPKiWBd86U7UQ/LQEEomyJv71b7hzB51mo5L4xCq3VwZOgJOh3ZSJl889h/kXLlJsNAST5w==@kvack.org
X-Gm-Message-State: AFuF++nodsUH5Z1kTZ1pIa1NT6rrT4/SCEpNOG68GWAYVTumh4YfAPjO
	vbJNb+Q3CkaJGi44ClxH+X91L1qr7Rwo0MR4AkF1gvwzjoltNh9p71vz
X-Gm-Gg: AYBFou3AFxFX0prMw5EJ2EECY0C0z29S+qxOdBFaq1pXYokdoQT3yfO2J8uldzddtRM
	t45C1j5fUNk0IAD2W8/wx+8BUGHIf2xEZ6+6bUcZ+FE/tSS+MlULp37B4B/nFy1wBBOEv7QMbHN
	lIrmQNUFpwxYbsppkEnPvp4S31/8+0FtxUGsUPtYRkXN0q5ag49AddrK2XDOYOUKBb5NRgTQAok
	ZmBMELovlc009BOuwaXypSDbX8TdaLt9lDwfbmQv/bRV6EBc+pkMmmBvhD2Q7d4t5ybvQzIjijb
	vc0NT8n2Qduto//Q8VJXxGGq3ZsJykwIHThRkc9yEpBkxH6JUO6jG7DKLXKe3rDlgDLkVXQJI8I
	iPY3GGMBdzcWymZZ+GDh5pNyOXTYBeczXCzUx9KMHY1DICp8FxkehI1/3hF+U7bSN01i0SCi3Di
	4YgB0TRLzwDXM+Ny8cEt1bxNJ2UT/dDjsZnIKSzB3Sm/Piq1wUJPL98CbymqAnWmiSW+J8qgxn9
	0iQe5lGSVVRKOLZYcH1LsIP4/alJh/qf7LLccpe9BiihHohadEFP7WK/t7A9+6/w3YX5ljTYpaD
	BkHqEQ==
X-Received: by 2002:a05:6000:703:b0:486:fb08:2353 with SMTP id ffacd0b85a97d-48872abc9e4mr6181199f8f.31.1790282359492;
        Thu, 24 Sep 2026 13:39:19 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a30b9aesm1408491f8f.5.2026.09.24.13.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 13:39:18 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Toshi Kani <toshi.kani@hpe.com>,
	linux-mm@kvack.org,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/mm: Drop the page allocation from pud_free_pmd_page()
Date: Fri, 25 Sep 2026 01:39:15 +0500
Message-ID: <20260924203915.189167-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <d8b502f7-a552-4600-b348-614d1d62afa5@intel.com>
References: <d8b502f7-a552-4600-b348-614d1d62afa5@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28774140006
X-Rspam-User: 
X-Stat-Signature: ezfj3k4jcabzu816cdbb4xng6qd6mhrc
X-HE-Tag: 1790282361-802723
X-HE-Meta: U2FsdGVkX18TzNvgH/eDHJKpnjgu+eS54vdRsgYhLXnfuvrqYv7+8bchZMX1fzItluc0aKOIk9FClzdOL90FZMk4pVbCPkmR7iPYeClsCqX2K9jk4CKUx7AC0H62TPvV1XfxCw+SkGlVQdLQcbdkpcyN5N79gCS9UrFPpPoUjY85TmPQXaxwt6SNQnm/6hBY9aIRKBrs/+Ftv9LGEFnPU6QSR6RdELs//X4nqRs18bEPzskccWC5KyZltvOp9AMUFqrTuR1Z4NX0EQ+PkgqZHC1uoI7WU+anLAfpw6YzP0qoQ6WsbzXPBVzSuTEyglAfLL8TC+9XAKUl7OxrKX8iMP3kEX9aUExZtRfZqVsp6ucoWmTFHjGrDiMPDJ/vYRR+xdQPsqXQQd5Uf49I7jqXmZjDohX087S0lAyYM9IweGh/zGuoizd28cUiCIQRz0M36dsbnAm4xqtEW9o7MIq4BLSquG+mBVQLQdP5QiL9L28k7HJMaBEasQPW0WDMnGsRQfVyIhLcfMkmP4CBhOuRbWLcjsLq6en+voPWRYpxGGZL11MNcg5hdA9+o0f4Qq0M9Pbbp/7sfxRPZEEs8CnnUmT5pdfUk400a9+6aFHbYOPHickFsjk2+V1svekBi07V5hkhHloBLyi6ysFo84OyhxtbLxvbUg6vwULBQbvf234MxPbrFZMjvj3Eu5slM+aboylLxDUivy5yUJaFHEagex4WK+2ToFuHE+eVjkBVx3SI9qNCiA2a9EbTnHjYgE1H1nO7e1uo5oMlOoG4ez3nlLX3YYoaPTSstMuJIV4OjUyK5oM9ra1kbDmHGupvAZAFLhPYL0SBCpm4MQaBtko/YoSfAKvUMRkJZ0WEzTmi461+dhiOd87bWbcHvMLS77IMu+oGq0w1IPCIqiCDno801hfKHBpVgWsNXeGYGFsKDFQR3OJ35GONRx6G+qL6JsBBXO8A5U7YR2SuEuoOvKz
 VULxIPcG
 4PxLNTEO2KgJvIWCEK6+6vilHetrvjeTotrAVbvxhgljgf58Ze57UKVOFH0YJzuBHwWj1RdoRNlGU7AHjs1wFGdgLkdyhWuAO/UAawJ15phtfhsM19cugRsVCBzwOTJJf/LaFwerqlAZ6h6jmmNTE+44sqiQT888gLD+ndVCmlCz600JxTz8jV7BDMgwzY4+ipyGCW/Djw0LtW53t9ySzDdGco+ZkpcyoI/Z8ZHnIiOY0jbg1yZMO+EDSqTh2exw3e4oZQFugx1NMNs6ZbSpshH2xH56NvcDlJ2TXLdD+b8/tGzz1c52K3lN1UXml8gomvZlRdm5sqnDkLzlb0WKLgGM8l/7U8DAyJUbMJlnFWdTlJMAgbMo2G3DgSMvkgo584dHw9Uk0vVKxh0jKl3nQICZUcoQfBGoRWkViICHDOE4ueCkNgMJe6Iyk3+kKJCumSfmmFykSNc70ph/SsRkiV876XSxdidjZx1bHbqNnKFG6QLczAJWR0rMfT/wtXTnraEL9HAe9Q0uE8OhvUTClb6jTOCGye2oxu6p6mN/awD3spY0ybqN1f3+VrrkcqHMkhHj6GXWMhG3tnF9omSyZ8MNe7RSmV/QB7n/HD6JrXeI+7xXm5HywR2Un8a1NucoXIq3v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 10:21, Dave Hansen wrote:
> OK, I've got a version of Mikhail's fix with a changelog and comments
> I've munged a bit:
>
>> https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=pmdfree
>
> Does that look OK to everyone?

Looks good to me, thanks.  The code is v2 with your comments and the
declarations reordered, so the testing done for v2 still applies.

Two small things, both optional:

 - "The new mmap_read_lock() is held over a GFP_KERNEL allocation":
   the lock held over the allocation is the same init_mm lock, but
   taken in vmap_try_huge_pud(), not the new one in CPA.  Maybe "The
   huge vmap code holds the same lock over a GFP_KERNEL allocation,
   which is a no-no now that reclaim can take it."

 - The kernel-doc lost its "Return:" line while the function still
   returns int, so kernel-doc -Wreturn will complain about it.

