Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C7C606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=JJHHwj+X
Received: by kanga.kvack.org (Postfix)
	id 7078C6B05C5; Fri, 30 Oct 2026 10:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8756B05C6; Fri, 30 Oct 2026 10:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AB5C6B05C7; Fri, 30 Oct 2026 10:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8BB6B05C5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:46:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7CA21C40B0
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:46:15 +0000 (UTC)
X-FDA: 85379567910.12.65EE77E
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id CA38F4000D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:46:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=JJHHwj+X;
	spf=pass (imf11.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yCMnnIVyw92jHKfgNzcCEWbI9184jZi+CFDafz0WrU0=;
	b=IypXW1r7wvfGZSmW5tdkhfsRm0gn/UVabUx0yU7uE4bXV/SYfM7rfaJhs5rcQk02K2uBq8
	I94e26pY3Cov41E/RlRuT3fWN7cjnS9GcePu45B6uWZ7fyxoc6Focr9W+EwnaLKtyWk7rq
	WbOuWl+I3iTgxAkbuVf0xlGKq06g9+k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=JJHHwj+X;
	spf=pass (imf11.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371573;
	b=gm1aG+tUsdutjgLryB3yJWOaSNsfeuVY3cBie06onJIAGf0q1fglrFS9TE0gfrma62jqVG
	+mKz5q2KGxgQPJ3HSdBCCyIV0Ruh6WWD5zlbp5gw+mlvn6SKk0fMD1AsZ+65IlV3SAwBYa
	cVoHSMXLsBvAW8cr8shlOE+gGH8fXQY=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91c63449320so9943196d6.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371573; x=1793976373; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yCMnnIVyw92jHKfgNzcCEWbI9184jZi+CFDafz0WrU0=;
        b=JJHHwj+XUTSwrBMsN0UDSifRognlwV+Zow775eprfnqhtIGVmT/9v38Nf4xtXv3WER
         qUg3zohLJETcNr+ok57xJKO7xrqAAoH6tPl28ciIUfbG5r0XkW/B4UH9RBi+uJyVcSib
         3fQ6N3Gz/4fvMrsZdiBzkXcbTA5pN/rfv2jrfsPpTEfhbmIGkv/pn0oyYP+QIrOE1eEi
         YpZnktrFNaZNWHltNY0um8x4BwUFW7C92hxbZMmrdshMG+T38YG5NPaNFg2Q2QoKnf+V
         oT5PGOvvF4xab0Ci8FpuTIEKigraDNrOEVYiHuATCMMX+SQNHpZ+TUrbRlYtyLnq3uWa
         K0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371573; x=1793976373;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yCMnnIVyw92jHKfgNzcCEWbI9184jZi+CFDafz0WrU0=;
        b=lJdRklFQCOH3VXbt9GfE+fPvFMXOqvvpyboGgzL6z4l1xjdeXUq6Fhy/byL7WFrpWi
         q9oIfJFY52I8Xy/S23ciIKq0VwvT7vtQCL8PzNSFYyJSEnLOu4/D9dCeZsQXVAkO7vpc
         Us9WPcD7ErPMCi0aQ3a8shyVNTdk1UXuqHQ487CbuAVFNsZd6mwcBeggw8CPOebq7F34
         u1wpmg/tcHn+HQdDpksCd22BrvT8sEZSbRk6LOWeXC2EfOcM6v4zf4nXDuELUPCBF3gJ
         R5UNLhIf8TcLS22qdlUVIghjvdlF75jG7M4MNY7oMiM62QI+pUTurYtOHelyRGaaEAof
         9oWQ==
X-Gm-Message-State: AFq9FYIeEDJoLIUhRiVQuIjW1Ys01TCkee2JxQYznh6lzHxBiR35YGRg
	JNiNRCztvUJko4sRGs6GrMVEF373kJ6vCrgC27p/0vNY9arr8a+qE38lKr0Q7N4sypgo2aKZmsF
	J7tKi9IU=
X-Gm-Gg: AYBFou2ISyZEmvejtAalr74Niz28oKjAQTvuEgvdpZ1oChiaQL6o4w4C8eDNPHJTYCM
	SsYumF54cPqunTUKRMVCs/hxas5FoMCmO2vmOOoFlHNMtOTcrMnFJZzITia2T4RUF4ur84dyIuB
	VO5X5zJmC7o4SHbm0r00TeC4cUN87qso5FGWZfX9+VfAiUs8IP5+MS17BflHtXQN3kY7VW6m9Cu
	+UMuwLSLdA/cqGXU/ZeO/2V0pej04a0bAIADhsSkFd3ESjo7qhTPPt0qqiKV9s1v1FCpqmCW/ZR
	PaDQJVGVLjlnA6rc5wADaNfbZUm74XVHGW7o9qzYF97GAD0oFoG94MaYb6UNv6lgspISRDA2Jph
	Vmrp0rleQSR8CQ38/HXOGfLoi+/ehLDUB7Tk3/JJt1AiUoF6wTuuhpHalch/P6Iulx4pzfGx9VV
	KHDKTI7k1jxcfJ+rLxy+xOd9UHQHdYh/oW9rrkqPI+n32CkFxFFLBPPEsf5PKkUHay6aOkQTZfI
	T7uOBfOnI5w/wUTwI+N7yRcH4mm/fom0VtyFJe5C6rVD7MJPIaGIUQBmkgzopBBeDelmaTQ6qBl
	h/XIQpC0osVcZJ3XYlEtYpF7bL65pzCroLIdQOjPZK3Q
X-Received: by 2002:a05:6214:4507:b0:91c:7c3d:715b with SMTP id 6a1803df08f44-91ca4baa257mr36060366d6.55.1793371572909;
        Fri, 30 Oct 2026 07:46:12 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca807047bsm16670696d6.39.2026.10.30.07.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:46:12 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 0/2] binfmt_elf: don't ignore a failed unmap while loading
 an image
Date: Fri, 30 Oct 2026 14:46:03 +0000
Message-Id: <20261030-b4-binfmt-elf-trim-v1-0-dbd8683bccf9@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKyt5GoC/1WMQQ7CMAwEv1L5jEVaAge+gjjEiU2NaEBJipCq/
 p2EnjjOaHcWyJyUM5y7BRK/NeszVuh3HfjRxRujhsowmOHUm4NBskgaZSrID8GSdEIKQuYoHCw
 ZqMdXYtHPL3q5bpxnurMvrdQW5DIjJRf92BTZ/Wb+w7CuXxsq7/SgAAAA
X-Change-ID: 20261030-b4-binfmt-elf-trim-bdfb05fed4b0
To: Kees Cook <kees@kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371570; l=1006;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=lg/mj6Jw3ZBjdLAYc6y3MhHuv172qISBdY785SlJBPE=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDzHcdXgLRvL7F9gDO3Le73SlD8R8UEbq0KX7qbr+KM1rRWzz9y1RBSZsofbVeEELhi1tAVcaTS
 liawpc9eNhgc=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA38F4000D
X-Stat-Signature: xzftiah5sf3qdp8yrd3o6ohb3z4tosa3
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793371573-359829
X-HE-Meta: U2FsdGVkX18jS0OrMIwUYzU34o4ZVcA77ZRg+quy886DC0X6ARHY1IXPVLziiqQi8rXjKIoAZaoyeFEZF7q5PemWRsyQ1M67y0QV+fiKPWekWH9j/mN5Bs2h8H4tvzqGEqxViNCLMkrrUI3k+giUuWWArK4Sf5P84cxfqhuc7UpTIMzOWhyWSRo72nn3u2hqzXObK7YPspt3Jn7rjGw797/6w6/fyejWcehfI43nH/jKzyCaLTsDVIJ93W54AXByPBzbJRwgbEaLomMJG58qk90/mYjldcZPnsLI9LICwOWN9hw7ZODpn8d+w16JhZRLpDVbqAmDrxpy+Aci/Ijg8wOiAlEf3R3fKC2S743oobORs5Ho67XqMVoQdUlV2pWWoE122PfkjvNhxKOVBhSqs7qTYtFczaxtglL1D6qoRHvkpo0NGQxb1MUPGUZFjqCPLsTxX3QueSFaGXiXwBVx+bha2Qh4xbtBlY999TocQJoTAPFVkH7oDFvSodGVasYpOV2E+W0V71bDHaa06IMc8lVGEJ3/yoKJ48brpcylyPQVYk6r1qhWaqRFeup1SEdWMHaIohV/Cm0pEJHoX2rsCjNYBgUOP/ZMkFV0UvIxliE4kIMNljx9VE47BnqxpeXUyPT0NnDf//Wyvv+uLVjavluhiqf7xF7IOETfcZ8A4apvp8/xFTIcPvUu0g/1MZZhS3xGrGwlYyRNDQdwQeNMIkthz0lwqqzpnSDRS9XAcKU8/3ImLuIq2ifC37nlZc4YQ/rCKXjXcQp6VwzluJZxBvBUr3/2tulzb8XxgF4QJfX9yE3qxcYjuqeDf426YUrAN7mSkuMb6TLzQZW9HjnOZuljAzIe2+FuHP2e4Ntq/nwlt7oBqIGUBAubRZd83pUqlgI3buGDeR+c6H9Ef+z+PlnEmj2vsHlBIW/DWiE9hvc90MritJTPea1Q4nR0IW/5SuN3po/LmKRUtxlgkWZ
 RdztMpk9
 AxO2bYmM4Wj6klyivTqRlGKrKxbXdnkKhAEjVLyD04mbr7yKvdiPM+SeXMY44Fv9/7cNUcJ8rdQMq+QSasWId26+IKVrlocwZJ6Hk/H2iC6WSkQQKS8Z5CuRqR1NW4wSP3kFOFp03MdkmHMubj1vR2WsTETlehFUNB6vFVqAQgrxfO/pCGYwM9CjIj0kchkMlSdNLWLAX5A0a5WL3IRm0VLmk68H1Q/pfaULmHX1djgPPDJOwfEHvb2QmMMO9zZZtZT9XIjypGsLwDCMWYGB+ld8I7r5Oy7Sb5Eheo34pHHFbcS+ov00rrABKoNFBb1Urv35/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

I went through everybody who ignores the return value of the munmap
family to see who can't cope with a VMA split failing, and the ELF
loader is the one that stood out.  elf_map() maps the whole image and
trims it down to the first segment, and if the trim fails we carry on
and run the image with its holes filled in.

The second patch is the same thing for the mapping we use to probe for
an aligned address for a static PIE.  That one doesn't need a split, I
only found it by reading.

I tested the first one with a loop that fails each allocation inside
execve() in turn and compares the layout of the new image.  Thanks,

Josef

---
Josef Bacik (2):
      binfmt_elf: fail the exec if the image can't be trimmed
      binfmt_elf: don't leave the alignment probe mapped

 fs/binfmt_elf.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)
---
base-commit: cd1d0b147afa81f80927f9711e53401703964217
change-id: 20261030-b4-binfmt-elf-trim-bdfb05fed4b0


