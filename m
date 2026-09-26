Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13C98C98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 07:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4E76B0092; Sat, 26 Sep 2026 03:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95E56B0093; Sat, 26 Sep 2026 03:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B846B6B0095; Sat, 26 Sep 2026 03:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6C26B0092
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:11:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 060DFA6F18
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:11:37 +0000 (UTC)
X-FDA: 85255043034.29.CB56BF0
Received: from mail-pz2-f38.google.com (mail-pz2-f38.google.com [74.125.228.38])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3ABF940004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:11:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UTaOZIoZ;
	spf=pass (imf04.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.38 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790406695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1uflVYidz7MNBUBcoHSIOw+jh4ssEiqibOfcA56ewY=;
	b=WgmWTQ9hMl2R5hflnU3tDsAS6UVd8k7h7UvwfYopTF1GcEKbqlALimRN6umVMA46rteILu
	UzhH6H5Ikpt2QMUvpSM1X47EUivpGR3XKqXvoZ8N1qoY45iQzUABBYDAxob7/P3f+/xiyW
	T115ACkLubyUMizkc4bPHAsVCbzrCOE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790406695;
	b=ZBz1CjRy9Mrsjpk8GCnMi6FEpPz1Aw0ldDx53nKwQo5l9YagV1oZYaqO0o7vJ+GpKGtVGP
	WAZBAnfag1i15tp+jtC/A2vRf9RfSwFPHXoca6BpLWwxU8fjktgIAO6jTmZ7I753+C+JjP
	aSTU+1JmXk88rRHKXD9u+S2wqcInRMo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UTaOZIoZ;
	spf=pass (imf04.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.38 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f38.google.com with SMTP id d2e1a72fcca58-881d9da69b1so26365b3a.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790406694; x=1791011494; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e1uflVYidz7MNBUBcoHSIOw+jh4ssEiqibOfcA56ewY=;
        b=UTaOZIoZFlQelqpqhkcHQJsMsqmNDHVzuf4e/2tHFvITB7FE2Sok1yPdfVtidGq6qT
         som2Rd2j1+Aa+Bg1LEZ7pAZKW3/1FxTTHMKfO8noAoh4eLkTOsx+y29YZSjF6YfnTakF
         xcQPQMQdqnhJBHIfSdxo4yS5BU6IUAG8qHjOsJ37RC872U4Pv5S6/DxZBIWi9HOZZeo9
         aRV0KdS9XQno/J4ils28ZlOw7j61nX3oLuS0Uw0NIG63IFwFIDXUGZBTDGSxJUkDDSm6
         B9Ifv8NTj3fpQDF5kDVyW6gOP6eH6VfR//dlxOCsUhoVS66pt/j6xrOjLoc44p2fThlS
         2uuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790406694; x=1791011494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e1uflVYidz7MNBUBcoHSIOw+jh4ssEiqibOfcA56ewY=;
        b=ZS9aqdf8IYfnQ4fiLAcEYGn776+q3rimUG81jLluzXu5pA82CbG+/hm9fi7Byvai/u
         JCnGRIXlGeQeZnAeYKuuXCCSRi3xd/nIQrPw8GqxESHZrREKE/oP0McyQiVGzJus4i6d
         3li9T2WFhuw9SUBnlPDV5WodFkgzhnUpL9QZttfsMLPj+JU7GOeLhDaNQgHmSm9987ey
         klRBj39e5dVwIJmlYstKYHdSeex81sPPTy7fyNbCT2BuryxkYGQxOMUEtxcD/i/v3KeP
         QnpkiIo+rLdrL/fnL0nKkfHZ9AG4ID6MOxhH89lyuKFe4g+7lQVGMYDIZldDUqsUpiuK
         DjrA==
X-Forwarded-Encrypted: i=1; AKwUvByXoLNr9TdBheiiXCOOx7Xzx/EaobkY6pv+iql+evdkMCBtbm7vcZufgfKJBbXiv1Uxg2IeWl2Fsw==@kvack.org
X-Gm-Message-State: AFuF++nEX5Bcvi5hmM7dskaOQPMRxANBSxLoEKMY+CHXNvgJKNjd05+3
	KKH+uZD8BoF8YmkDUiPZD6uSZuFWdvDMpMTlW7xaAFfXHRM/kSFoMLs=
X-Gm-Gg: AYBFou2ZCuG9Vs1/rXW9c6QQaL9QuoZChcAedjvM6UheIL4rDU7HdgTTVMAMxdoY+ir
	BjYZQ15N7S2fBD3VB6YoRYE9b9ogUXaBeu0AlpV/FiV45gCF+aCjp9fnPwT87phth11hmx9lq95
	YqCfZteUXRNqqsHszL4w8meSmOTSdyL1wlzm3QMID09QjqVwaiIa93ZjigfUFTROroHHubox5Ri
	GWFPUL1wTisXC8RZaMrsTIbCd9em/yHw7LV5F8SZTd7nL1FuxSzedxV0RQNJH+tNynE4DET88Uf
	DRPxhVytPhbWbW+5oM3NBwcfFjEv3HlG/dNS1a4QnuDRLjO8jPwEnqk0WhSsLXehU11/HVhKoL0
	EmrldrtAvY4o13w9F/lzInbuGB+RRAxhtGvy7/Wl4fUcDQJIjrwaVdumiJ8waiXO3Kdwg2lMzd0
	g1lEyO8MtOMwN6ZxtOVQ9HQa7+/CDv7+9O0/ixBSIG61yduhXW3SPGl3iDfWmifdMZlm//mWj6G
	Bv/vRb+GaKByHmeCmMHAWvL
X-Received: by 2002:a05:6a00:b904:b0:881:79ec:a65d with SMTP id d2e1a72fcca58-88179eca7c0mr762226b3a.32.1790406693845;
        Sat, 26 Sep 2026 00:11:33 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87feae8d827sm1971825b3a.36.2026.09.26.00.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 00:11:33 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kirill@shutemov.name,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Sat, 26 Sep 2026 16:11:26 +0900
Message-ID: <20260926071126.2869041-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8f60eae1-31ba-4ff4-adf9-951240561f13@kernel.org>
References: <20260925042907.2330519-1-donggeunyoo.kernel@gmail.com> <20260925042907.2330519-2-donggeunyoo.kernel@gmail.com> <20260924214811.19ef8af417d37071ed8338c4@linux-foundation.org> <8f60eae1-31ba-4ff4-adf9-951240561f13@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3ABF940004
X-Stat-Signature: r8qhgfs1x6fjk81wtisx4shdga75you4
X-HE-Tag: 1790406695-995411
X-HE-Meta: U2FsdGVkX1/EBoNWE7XuiymBVNbgz4MLBXYZja1HsSc7abPBjZqeaU2N/qveFTvGBMymAyf7ulqlHEJ6Er6/m++x1idSDceK40PxZgQl76AeGLYyn1siYulACI1iDOXgnGgfI2mhnbVvRBci/NxndNbvc5bQPfZLqyAiGdrfiPiyIj35q+Lq+nueEUrY0IFe3141tgxL3lMp44Bwtwq13ovJ8lKrRpuSJNTn8IPzhLcLYSc4B+y9UJIZI2CoctWDDzYu7seFYInSirJS8Cd/3PflUfIielUMZ2JhFt7YgKFXA7DLOMqMQS66UO1hMuYtgd0ZerSkc1oHaRWhl3oEI3B9DBp58N3aqDOyOMCP1piChpw3rcF5NDx/96RTqA+XvIQCL7IzMv5KDQHCDDFsKIhFlGOwUbtYs4QMJEJawTgOhcFn2YbN9m9U8t0onE9homg20stz1JIh22bb/P5M+fGgUb2xVf9oExu6vM6mFGYAYZKN5MYT3Kaqjas9BOiaj8NGQtBuN2Zo095bqhTocqZiv2FHiwPjA0Mgm4o1wrRUPyFR0FEEjSERSpud6OOjxDiXAfG9G6DbvNTBRoxGxIa41L8GYAGh9WPJmbMlJGEqJqksFEO6jbVIfKV2gY4suo4vUhfiLFR/IHKrDH3qGUoBv44dSMAiyCJIqUAXXPswGPOF3cJk+7BbK8CzipOgCvk+rMxLdA/JASbiTDEcHIsNsVhROusBqkpRMgyqtSZi+Ou2bvV0oejmPMw40vRCkKhDK7cuMmO0eJ5nzllw/sdmCG7Y+bpcsiKqbwLDjX9j0PwZDjrULpJ7etPZw+l5DrMnJUGldupUyTlU+MSnLqB//esiMRkwepuIwN3ibwrySw/HPosp3Xv8o85FWWWFPfvwwiE8+41qHwiJ/qCIdu97pQ5wPwmiDM6t2rv6l8gvKqB52pR9wGG9mkjKp/ubwGUhBIZDsKmarOMYgkK
 BipHRDlt
 j2aOVSkXyHiXQKk67FpPbKmPitbJcfZwnOHKHLioxJECVkeu8NAI6Jg6XoOFUrNfakMsIXBcPTcW+VlCxBk5j9ncUg54FLHuCjupaGHS7I+IDVFldKCLZTgVXh+9h+7Mdxv9QCTbkdOWHBAcaSf8We4VkPLvNaePbhw6q1nWgbJeg0WG6YeyNzVsT5wG7s8GqeDcOZPjsifSggs3hQXUjDpyOqPNW5idq5wDw+UlywGxDpDU5HQmOhFdirupCVntYZ1tXfy7N+PHS3Y0wNZZTpwTtRqqd0fI8TMeS61xTNfhLu5WbnuQRVSrertTJ/1V7mTsSNrrocPovYnbV/6rGg7B1ajuxqhzeW0HjcR2dmgTINxFI8l1XrEu/RtOScdin4+Ue4HrtW4d2va+tvI//IBBut5llN2ea9AkQlgBrCCWEoLOwOng8kkstVtG8nlxK7k6o/37EjZY9mvAtJcRFFo6eY8cgig0JcpazQ4tRaWXOCQ1liUxHYdRP5T1HPlNAYDe8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Sep 2026 09:36:26 +0200, David Hildenbrand (Arm) wrote:
> It would also be helpful to describe if this was actually hit in practice so
> far. IOW, how relevant is this in practice.

Not that I know of.  An LLM found it reading the code, and I couldn't find
a report of it on linux-mm or lkml.

> Will this trigger a kernel splat later?

Yes, with CONFIG_PAGE_TABLE_CHECK.  When the moved page is faulted in at
the destination, do_swap_page() copies the uffd bit to the present PTE and,
because the destination isn't WP-registered, also makes it writable.  A
read fault is enough:

  WARNING: mm/page_table_check.c:202 at __page_table_check_ptes_set+0x185/0x1e0
  Call Trace:
   set_ptes+0x67/0xc0
   do_swap_page+0x990/0xfe0
   __handle_mm_fault+0x7d0/0xeb0
   handle_mm_fault+0x9c/0x250
   do_user_addr_fault+0x207/0x650
   exc_page_fault+0x65/0x150
   asm_exc_page_fault+0x26/0x30

That's on 7.3-rc4 in QEMU, from a WP- or RWP-armed source; with this
patch applied it doesn't fire.  I'll put it in the v3 changelog.

Thanks,
Donggeun

