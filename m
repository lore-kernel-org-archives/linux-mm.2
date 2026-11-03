Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7911B606D83C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UNuAoS2T
Received: by kanga.kvack.org (Postfix)
	id 936E96B05B4; Tue,  3 Nov 2026 05:42:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90DF76B05B6; Tue,  3 Nov 2026 05:42:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824046B05B7; Tue,  3 Nov 2026 05:42:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58B786B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:42:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E45841A02C4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:42:40 +0000 (UTC)
X-FDA: 85393469280.15.D925A7B
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0406CC0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:42:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UNuAoS2T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793702559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jF+dmpn8iQMH78dTHJ5iTki9ohaDdksNiAWtPrpropo=;
	b=r/K3Q9RS4lRUmJ1f90mcjhA0QcuYOe97o4ZfFVagIRGLLMSYCDLdEyYsGN7sf+Wqx0vzxh
	xvflf6cCO3hxwlt8GHBH/mTORu3O0kJJOPAqaXoDEtQoRPS7FfamE6lLXsuU0RKaESxQcq
	EYBjfJKoc/IkFQaP7HkYlCLfmAF6jZE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UNuAoS2T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793702559;
	b=d3OM+T+t/PNlZXRNevfXS7wPBVvANWwNLyjAhlcP+Vesr8VXtYysJ2K8JzqXJ9rfy3MmTa
	/BYFV31pfOb9Keahb4Yd8sp8VqpV8fV4IGrDYkSKZCJStitUqftFWvXJrXzt4ELepv0Ejh
	USmW8Vq2wAJuUvlECHG5g9U4i6oI+IY=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49d05d51553so25779275e9.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793702557; x=1794307357; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jF+dmpn8iQMH78dTHJ5iTki9ohaDdksNiAWtPrpropo=;
        b=UNuAoS2TV1pnyjvjKCcsUeJ2jR2NjDXevKle5EGFSFgu02JWBp9OiIP6QEY+943AOp
         1XwQzy/iFFC7eh6vi2pqIy2HW3rlcB3+N0Bn4Rmvq7YDPYt7/ckspLJltFZTWGyIJJ1j
         mg/KNXVQWNvy8M6cLxDsQ7eYITnYkVS0aZ0Qm2cpTXWWHNefDX+fJ51IaQJxA9voeAgE
         2XB9aSyu44lQYULT1sNcbqmM2rV5xOSAd8e9bqPQSa97jXQKHCRCZBntldnMhEpLV8Bp
         BYUv1ZxjsAerb61UGYe8u+1J856NhcgoAW+vuqQfCgfVDT+HCUOXgO3c2Cbngzrfsn8I
         AByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793702557; x=1794307357;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jF+dmpn8iQMH78dTHJ5iTki9ohaDdksNiAWtPrpropo=;
        b=GNo7/WVF4GElZwFQgr76yicthJf/Uo/SunetuXKCdnvpJ7yNKE/goPyoyPWzDK4FNI
         8K1L6IgZwv/6mWjk0rxl7qrfAyXVpQmwKl4quw5BlpAf+3mtblp9Pc/5JLsEfivbk0Va
         y9PF7HOmnzir1Xk1RDssvFyyaU+0eZ6ztm4MUU5xjXOSBab+sJh57qFWC08Qeer2MgHy
         ku0vIbP9Vr+OBOvcZlhoBEHS8Iv0YnTu0MeSZwwxzCgXc4eEPWFCnlIrKMPN3jlyAm3/
         G7IJd65Qap+wrV6tvK0+dOLfoO0yRsdtT9GnL0Q5Sc2mbcArb7miIYZZHxx8cLjVr3Mg
         sd8g==
X-Forwarded-Encrypted: i=1; AKwUvBy26R/31NE/ffhpo/vGWe9HOTWr3dAYDuakrKO+Mt+xHTvsDF0Dc+2gEkF220gU7DNE4a4ELtk8zw==@kvack.org
X-Gm-Message-State: APuU4Z/5RWHLHstbEXNIp8mzZ3CEqcadK4ahn+BJ4310Gr8GRobiZ5rJ
	uqBvBQ1YIF0QKqJS+yIal0vcHGzpiRRgXwgafdhYkpixV1UL39saOYBGWxT/1j8Ses8=
X-Gm-Gg: AYBFou3MomIK0stQ1H8DxCXgQHEjwEHejKVI1upRwZVMySiA7chpgUl4XINLrBkSau3
	FA2KErO/3gkQrSfIDpfSkmf4Wn4SC5+RVspVAkrmGptOKCCRA929mSXjNv32ccxrwq9z55TrQYz
	dwl53DosMRntHWS7V9p4q3spkIRAN0Fd2bIYnl9sG48Zme1oKXt+QZoVjwX22l5N4nQYGgpz2Pd
	PQnIqBAYjZBmPoIH/eLh2T3nVrvKQI74DPfaJ4X+LM1kpyN7cM6js6SFFpGdaKNLJf1RaTQtc5R
	K2RCkeuGLkju2qAxf7wP3fBFV07jIZbpm3HMK2bkuOI4byiMwmsfZ8qo4g03QVrEx7v+QuH53MV
	M9duVPIUli9iX2cAF2O6HLJImZqSKJ+1b1A/3cw0P5bi+I0BN8zK7OLiHQZy3cSEo2eEwClKtGA
	VD9Og+l1PihXDXTtgc87bZwpy18HV/Hqk2of79GAXu2pgjrcgGR2nTLWbJt8oQkAhu8P7oL9cBV
	NTg7CIW7wdkBTHKRBTOp7Q8c9R9sFklEsCOPkD6gCUIbETD4g851Q0G9sJvAl/xMKOD5utc7V/q
	MOggf2MoDdYhWXzzxxjn7rCK1bzzOwwfTqjq3uJijphx
X-Received: by 2002:a05:600c:871a:b0:4a7:d9b1:b684 with SMTP id 5b1f17b1804b1-4ac14ec7947mr293082145e9.2.1793702557391;
        Tue, 03 Nov 2026 02:42:37 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2ab00ff3dsm94074165e9.14.2026.11.03.02.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 02:42:36 -0800 (PST)
Message-ID: <0fdec467-55b0-4354-8bd6-58874c2c20e5@gmail.com>
Date: Tue, 3 Nov 2026 11:42:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm/mremap: fix hugetlb reservation leak on partial
 move
To: Josef Bacik <josef@toxicpanda.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
 <20261102-b4-mremap-pre-split-v2-1-d281dd11ad7d@toxicpanda.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261102-b4-mremap-pre-split-v2-1-d281dd11ad7d@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0406CC0002
X-Stat-Signature: t99u8557bbcu7o4pwnhw56re557scx7o
X-Rspam-User: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793702558-526693
X-HE-Meta: U2FsdGVkX1/bQCfwm7qyM/7HrDtCosXDhaDY/5YsAG0CWwtfFskWL4JmBICe415WFLSOp0qMUmKa7fpa3CCPGT5Cb6y0gKe71g7bjttIJ7Jq72l4DVec9DRYlca1GeEmsQqgcqSrUSAUYwK/AUHhdhKi+Y9cHZRpV3XxoC42uQtq2kUw9xz+t6QS2qKVnLN6RQnDcmIouxv2k7TtkjdFERt9qQ/Yl69tfpiR/54WTjFQAm50+10kFs5OQHKFmlHfTw57vPfetMeTCnG6BszcrA7MSCLURLectVoVH3qlY8Cf7TiuU9C9t6mKkcEMsF/+LVGo+yWidfDLQ0ShWmMCNHoz4iiCoVBhHpqwCOjeMRwikcA65e9SS6W4pKq3DQFHCh2Qc3tWNXQIgsiSzDyyKhh1ItXDArtsGgkfjHnkNnUe7iUFEmZqPxCD94uPeuQGljoP8b0SuCZZFHgxTY11775Vcw7PQCeEEa7OTq0qoS/D2Nyl79qt5zekTuZRcZcDtjwwH6K1QIA5+RDqNTuYqN+BXfCmZA5jmw8HADZpV7Oo6MjBkaOOObZdY1krpZGk8RYE9V0MQNlMZ+QflmRq0yKh+cGSA2k7wsHxZf0H7tbVG9J/FtV/8I2PtBueU4owB3kNPDxtqw4lmdZ96WliwlM7l/LdMsvThOSER7BarlqGFtN/ChMKap2S+inT+bJDYNj7dtePjlktyMtF/gRtVURdPN7naizHbWuQUlcx/mzxS7upmDJzNf2/Sen/T7uUpyE9F1xv84KRUwtyvAYJVlx1VHbIT3+AkDObd1E4yajdaMn+Rshi4xopc0xdZi4edSnfT1bQGGY3UUPT1LAM9IhUQotcvcRFCrN/hW+kvWokFkC7LRdL+HPunnHVjIS3Wfi3aYLr/dlO7nx3suZxmNXEGuSETxltM1f8xD0OHlLiGDCkMFtpazLxhsMsxZ7gXjKd7u3zcrgDeJXd01x
 fis8yecS
 H0JTa/Dv24rpRny/JwaCZP2bLapJpfD3qXpE4GFzk9SL2ZhwRB8VnGiryDnm2gjXSz8pt5G4S3kcs+VzEiFYkck6xeoZYJHRNmG/nKuYY/cZv5bvCxdvR79ipPDiZ7xcUn2ycGuzbsR5oFeAk9NY3IoHB57HmSGqN1sSARBzmmZJU2Yg6+IKdRbIw1xXi5m6YhaZwCBvFlBHhPRKhHBFn3Qne61ywjS+R/0SDCO8H6cHDBSRc9Dm/M5tN7QuZGcndAXw4lZBVXEparHiDGeH+GcHMadhc9ELQIcV3G5pOTsG6yrYkSa00X6/QO+mi4zFRWsReb+hryCElsHiOSEC5jfqnUrHZVlrTTbcigGrPmieHUKadst1EsrGzUuuG5alW2MPknv4DHgsWLFWV4oUA3FoOxltJK7pj0SaDqougxmeO4GOjyzrglmDD4r+ZV54J+3cyRuolYk7ZhFq5mQA+33MDKi+00Pc87NHCcRnwwsChdb+hopa1qiTh7r4Yt3UOcHddYfMxOFAp1006JNQSf5jbgQjPTNC+tkSdW6fX/ebTWwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 12:45 AM, Josef Bacik wrote:
> Moving a part of a private hugetlb mapping with mremap() leaks the huge
> page reservations of the parts that stay. They are not returned when the
> mapping is unmapped, when the process exits or when the pool is resized.
> 
> fixup_hugetlb_reservations() takes the reservation map away from the old
> VMA while that VMA still spans its whole range, because the moved part is
> only split off by the unmap at the end of the move. hugetlb_vm_op_close()
> then finds no map in the parts that remain and returns nothing for them:
> 
>     mmap() of 4 pages, MAP_PRIVATE | MAP_HUGETLB    HugePages_Rsvd: 4
>     mremap() of the second page to a new address    HugePages_Rsvd: 4
>     munmap() of all of it                           HugePages_Rsvd: 3
> 
> The source is unmapped in this case, so the number of VMAs ends up where it
> did before and the check against sysctl_max_map_count stays as it is.
> 
> Fix by splitting a hugetlb VMA in prep_move_vma() before a part of it is
> moved, as commit 597e4b9ab48a ("mm/mremap: fix locked_vm leak by splitting
> VMA for MREMAP_DONTUNMAP") does for an mlock()'d VMA. A backport needs that
> commit, which is tagged for stable itself.
> 
> Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

