Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC7F606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 02:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=i0O0rP6L
Received: by kanga.kvack.org (Postfix)
	id 1BF9B6B05B2; Wed,  4 Nov 2026 21:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171926B05B3; Wed,  4 Nov 2026 21:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088E06B05B4; Wed,  4 Nov 2026 21:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEABD6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:28:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E888C1A08DE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:28:36 +0000 (UTC)
X-FDA: 85399481832.01.7C663FF
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id F27BD40004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:28:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=i0O0rP6L;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793845715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgPn1TU8Qzde4rDA9hSBS0Cx8PK07vtzri2WT/d9DTk=;
	b=1qc3Z/6S2VA3FfoWTQXMO6H6BcdM+yDElIUWxnqjFEWhToOO+zqNh9+K5lqscV4hGeGcgQ
	Iwj5svvEyIo1NkmsGpFjtQIoluWPmYbd75n2lkna2qEMua1gA2+Tky7pzaj/9DRgwZtpNv
	NBj5HNXP+cuC60ejydGZEFVSYAE1CwI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793845715;
	b=3DIVOUuaxI639L1WNSyUMnmo51xwljE2NLtTOAVqyevqSz4iRfN9GL2Pg/8esMwgSBma7k
	/dyODi9GT1fHIqqDKprlZNwg3FgNmWdcR1n34PLC8bAc1nXtKrjG6r9/9JZIv8k6Fxrmjz
	627Fv/wPYtaaDasgV9h41q/l1Ol1SYY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=i0O0rP6L;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5eaabf28c06so1010017e0c.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 18:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793845714; x=1794450514; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qgPn1TU8Qzde4rDA9hSBS0Cx8PK07vtzri2WT/d9DTk=;
        b=i0O0rP6LwYpukiBwB/VF/RQKkvTrDG8Ax14dAtJFLR0Ao+PyuvnCjqDExhvTrjVAF8
         2CYk8XMdVCRZa5iHwyjTY6NpJupVnMMrPImwIvFNADfFLoYoqACE5/Y0yORmmTX+fNI3
         GVHzTSRHw1rBfPmdTJR6Ey3qlOEBHQskWJlm/NTxD5TPb7SiXUrC7nT1DLHdhTzJcQ2v
         B6OoVYrDUY5RuNkW2piT3wNZbKRe+M08ooxZQLCHan4uSBiTp9tdQlXsuJU6tb7/jFpm
         kYKm7AaGc33Y7VuAVjhny9yeSvKkEq1HaSUyIDtoyHBZMX6rwddJjEl74SEPqRb2s8az
         5aag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793845714; x=1794450514;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qgPn1TU8Qzde4rDA9hSBS0Cx8PK07vtzri2WT/d9DTk=;
        b=BJw8dwefQ9E6/eDUPBKIlWDPZdf7Vfc8y+oBv4QjmqKyXVWYCo+7tOkfitwUx/bV+F
         5/fqyVRKtlzLIidz7mfydz5mt/UNLIQblytOMDtR+WbEpnh0Y5O1ZskO/3ZijcxSLJTF
         gKjXtv5AsAmlAJZUQUCVuWPx5/gcPK7IVWD7DyW0oGlPkc38MnaJkS4A7f4V5FL29vAQ
         VdHJjb7RdS7gLWCGsbhicVkKRBTR4HAD5Mk96otG7IEoIXTuxTYQDq3Rgt1obbxN/IG0
         8U73/dZrMr8yuHO6YkM9CUPCWOxGMeV+13ZasFrM4ans76P45CYqtaz62LlDNTvn4Nl7
         ZF+w==
X-Forwarded-Encrypted: i=1; AKwUvBy5j8OyBmYu8LXTyvxbvi/JnuZ/MxqfIPozLq9oaDoVPBUEbuCv6XHY0uGFFQYWBRhSZZo+jsEZjw==@kvack.org
X-Gm-Message-State: APuU4Z/uIYP/eZPslyKCwm0Mzl6kEiMWnfnG6Y+YNih/7lYWjmMZNh9P
	0oLzfEhN8Xd+wh9PkzctZ/m8gtpD6aG57pk/BU/o8jDOn+bCXx1BMyoW3hmx02l21z4=
X-Gm-Gg: AYBFou2hLRvjQpc2Pr2CZgbW4hI7v207RgcGVKXv57tG9c3VQifu2zAKdriI5EHCmqY
	GgIVgGU5Ap8O/XufoUSlnlFf58gkKQ58Dhdo4pbVacEzn9kTvsmE7yDa1iFcEERBk9CZ3ZsVql7
	J9R8517DCXRqd7+qBG4Q7YUpq3U7QpNdQN2+WaUadBKW/YRM+dpgVWC/PDt+d+WHzvMc//VvC82
	iQzZXJyfZYTLeqmW27+KpRIJdGwEPfO6zS1UDp6W3KmKmh+iPkBgEfkoCmiP1N7l+poIG8d/xX/
	HFQjLvL3Z5gLkVdqdNutpXSw1MYAieb6/CbQAZG1c+r8fEWV6FalaGbkZraQlVj9n72wAM6Cm+z
	SL2F80jV+wXC0lg+ksAL6dgEGsYGZGJk+BOvirJX0GnsGOkgN96qsrEUM/9bFg7ErgNiuFwLfc4
	Q5CfGPm5Da1exq0fE3Nu/qGKsb6lXXck5TwXvs1NJPsNzAlbDsucG4iM9PMtl4d8pnD2OUabdyv
	bJX80WKcbV6mCnHPgac0HTht0eUUcvC5GGumWqFOJbrJ+uVbPEb4TvOaoa+uhKSOAfjtkK6569r
	FKUshY/9Ht/dpLFzu/u1uWjyuSMTvTsMWw9rLTfDcKeHr5ETYKxGfugi8+hn/MfUu25xAu8oLDY
	WJfZD5M2Q+rMukrUx4x45pTh4vYZ+vWu5k6EB9RJlnnwf
X-Received: by 2002:a05:6122:1c8b:b0:5ea:c98d:768 with SMTP id 71dfb90a1353d-5ec6871c27bmr7768958e0c.6.1793845714044;
        Wed, 04 Nov 2026 18:28:34 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8dbb17bsm3170924e0c.11.2026.11.04.18.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 18:28:33 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] memblock: don't allocate new reserve_mem regions on
 a KHO boot
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
 Changyuan Lyu <changyuanl@google.com>, Alexander Graf <graf@amazon.com>, 
 Tony Luck <tony.luck@intel.com>, 
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org
In-Reply-To: <20261104204235.9066-1-azpijr@gmail.com>
References: <20261104204235.9066-1-azpijr@gmail.com>
Date: Wed, 04 Nov 2026 21:28:28 -0500
Message-Id: <179384570854.2089669.6686464803021518602.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=550;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=lzEbddKUD5GuDcxbx6NPlhQyO90bGHNaEl0mNdN224M=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq6+nQbIa4wl9/OA85TgIcp6GUjRJ97N7P3RS65
 w/dH+wLy06JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCauvp0AAKCRC7dyhM23N6
 3r6cD/4i+eGggrI9gSbQoKNbHehmvZ3DGILZLB/nlShN88F1/s3BSkAExC6VVWEMcC3UB2prAMe
 1qmdaaZsjv2/Uvifq86Kv9CWUVWlkHnoyJWKozJ7iEKfgbYRb9O6MVVGqZvt6gcDBGLapVOQORL
 N2BYhTtYvIj9j6N8vOfDgQSWnqCaU3LdOzeeMplOf3k0nRefNd4DRINPicEkKSvuJt6kgxlx5nw
 RBg/eYb1k2ki3/fW0/aQqPsWnF8xdmBf+sIDShF8msbkLqOGRC/Pbpl1ys/JZIQ2EFGm7xERkEJ
 SsFlo0Ul3MF/AKLUNZLeVwQguvXQzHFjoGV6XcEyKnkbyU82ZjGVzXVjsUxUtUTGwxgp0bGAOwE
 rMur4xHR1Un1klVmeUB7SP3LdXyUmPfNaltPEaBRVTTjoYBqi8kOlVT+quLTa8jeil3KQNhYCa4
 u1tTYYUFrP1KBfugXgtvFDpHpS0VdGexNS7KJd2Taq4bRde18lsMUvluxoPd2CjsEdxffVnwR2F
 V+aLewuq2DY7Tq/2il3FeVW2Ki4X4JCYddH9lK9F/upkQWS/TMzWhm6p9tIzT4pRlUScGIq2JHi
 +FQwVCuO7RxpxBnAZMUlg/S83bjlOVBPGxkmYFqM4Rlux4v6iJzz1MnWMt2Zbzz7+naB2qeTeaU
 JOlIW4F4aF9s9Fg==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F27BD40004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: prgfw8diewwkof3igk64o5jhwsco9if9
X-Rspam-User: 
X-HE-Tag: 1793845714-54341
X-HE-Meta: U2FsdGVkX19UT/c90P6NTawuuYjdUkI5ZJpEM+rlIHlEmhtka5jLK9sKROb5t2tsIKGX9lnpeAsKKV0UtZLPIbbg4ChlPmfeLJ7IUFRCUe35kvfXwCEisKMmBHk+VGs5jsDPLx3bdGWduESONQU5I/0dAZDHNBfzKL33A1QeiDF5JcMe01IZQB+rT5Z0X0GFW561qan/Lz1HasnFnpmAbD2KlahqHvi0QqM8DDJ4DWUIgVJWEwJNkQoNrQm1ncLDDwmv42N1WiVkJIVe69N3K9eXewBoZ8zPon8b4rwll6hsOv1kzmK9NYBe7zIg6RtbLqcrBauxuONrXw2GKZdMlWFK4e4nK5toXrSArWC7H3eQNJkWoSZ9C7hDG4bSnOx2IPBfzHWzRZzHQApBi5wem9lYH22vxciqCWTK+KF1RQi7T9NK9p8jK0gD3QMAC2yRe9oGEAgY+n+JDFAxW1jqanxB1QCUxrg3inn5qkgvrXCnn6t1HIt3IuP7QdYr23NEvQ8L9/+3ODbtw0GX4pw1yRFwtJi7JZdODt1w49B0vGyk8dhpUUvyFBKzOX0/HqZVLbJdzeW2AmXWBPBWCLyVwUtBoBnaltT7aNZmAROFCy5taFjOdQBGz79dEKhP/olI/KcFPG+Zta+rXbyQBGKchEtSZ9g7T3SMVTsw1gbjU0ZH+SOuffwSwgZDNnO2X7d19BAMJihIxfF5DIOUvwVh3THd8RwHzrFehxMxXpFqb8eVAwJYHTVQPCU9QO3KH+rwDhLwQVpumUTGaOWeuZnF6l+i2UC9B5R7kUNskznA3OvFha3p854t3FRx5w8OTmE+PJLgUH4N0P8jgRfxYV991EHUlxjf+hQXDTGrP5As89tFRkkwsXBwF6tlgU3wqOoWbUJCsiGQbZ8aWiryCzHd+no/hSIx9MJ3iUgHV1spn/iyzwSZh3HpDG+efK+AV7H2o6ezgsZX1EldMlcGQxG
 ZU0PNWC8
 kkqRiv0oE8icYFblZf9lbE6S73PaBcMXjqcM9G5J7qf9KvTjqs0pwVCsg8SUJpgknd2yvtMmRvF+yOYOWdrb3NjUG11P3nYYXvaDVf3DB66IsVr9sSFNbLTz9ActbLnF/A7a7tSyJvUXqJT61pkO+BbGYIHSZn1Xzmmd/8VjY+oeYJbVPEf3LLJd0QmAavXm+ZvasPknzdb3cw0FUBdcVGuL2Sw5bU1+cLYuBDh0Yc7QTceDr4KfrjE84V3lMXdMyiUxKYCgVlmqgPBZGFQnIk4lZrS1UOVE4cJt1vEWctSmyk7/GIxBDAlZwT0edJn0dit6wMe8Tlqb4gSDRZbNqsRRbLpWu35gNLPyZgJhlTryG8dHiz3ZtVdQPN2ymTqg1WoEnnZsG8/+fjnZaKhXnAwTeGiY5RHl9nP4p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 21:42:17 +0100, Jose A. Perez de Azpillaga <azpijr@gmail.com> wrote:
> On a KHO boot, a reserve_mem region that can't be revived is allocated
> from KHO_NOPRSRV memory, which includes the bootmem the next kernel
> boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG, preserving the region
> then fails:
> 
>   WARNING: kernel/liveupdate/kexec_handover.c:1245 at kho_preserve_pages+0x168/0x180
>   failed to prepare memblock FDT for KHO: -22
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


