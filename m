Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F21A7606A323
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=Gpz9X4i6
Received: by kanga.kvack.org (Postfix)
	id 21F696B05B5; Fri, 30 Oct 2026 10:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D12C6B05B6; Fri, 30 Oct 2026 10:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0C76B05B7; Fri, 30 Oct 2026 10:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3A3F6B05B5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:43:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 59E281A075B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:06 +0000 (UTC)
X-FDA: 85379559972.15.510DC30
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3B71440003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=Gpz9X4i6;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TtQPujh2Z6EFGDVb1MA2CbjYL8flrdHZZ0jYfe7yfAM=;
	b=kE6T2JqBfUR7Hk1eIZHf2dxCs2p8+92i0S1vUZuuUEJED334AWZih01HECk6XxbZHIfhdw
	9PfB0CIHp7X3BTO5rwcChaiTTO5K16NOic+VQpcXSf07iB0k2vRwNznxsDmA9JanynFohn
	4S6dUFVs/ctSTsDjUuYVNebzs6SXums=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=Gpz9X4i6;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371384;
	b=Y1dnPnwb3GoC93OQvQ08bY/Y/3LxVC+kfJ0DjmcEKzZvzH3T992Drv9aDKW3XQOEw3CUuZ
	nuuUEsq3rccptZEGH5Y5OBI/reultC1KyWTwcBhN/ygHqs4kb4EXjRFK3/09JRyXp9jh9j
	vRYdhJoBSTN/jh65QOsZuciJ3gfetBo=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso568621f8f.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371383; x=1793976183; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TtQPujh2Z6EFGDVb1MA2CbjYL8flrdHZZ0jYfe7yfAM=;
        b=Gpz9X4i6txt6NAo8ENEdZ78GR8C5VCtj2T1PLttMXSS9vzJyntxKvxYk+kKUYu9Wg3
         BjkodjetY3N+MnXt75TJxYZ9JOtcf6hdkOHoC3WAg2eYDX/Qnxh1TfxLy9LwbcJnha9z
         BJBz8F0r3UR99KynNEIMTF4DjtGOVSKn+0PCNxUWYW8Uiv7W2eplwB5t+59GLt/bJqix
         KK9UMKgfFkoYcZERTW/ZCLyoVyZN18eNXjjawt5ShKtcJToFdVVodLgzjVhJSUut9iAd
         8BoTFpr3ixBE0QujySinj43dH1N33VocRyM7piAG23MEbd+l6gxylDWyhUn1/rZy+SyG
         oMng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371383; x=1793976183;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TtQPujh2Z6EFGDVb1MA2CbjYL8flrdHZZ0jYfe7yfAM=;
        b=pCiphPgAUwx22OKfE3ZVcW7wdkRIPWgc9tOLQ9pngziT4EWQNq6WGvExLvAtM6ingh
         CQB7GAkNkF9MNm7TPkI78DoYKYWEDzV13aZM9S3SSAKedq1eV3tsafOGQWC9TNWZ1MCa
         Z6PnWeH5Uytn3nEySvNew+qP8tLAVVpNXEXR3Vy8XJ8lKAj9UBDExgzUac0nJmUCWNZM
         ia2maghiHhkh1lRLQnbtPilEw4y+LojVKQZkca8aCnbU2W7fRTq9NhL3xbqBNeGe13HZ
         e5z4tLJMRs5tWR1/gHlIxnVhSh44k1W3HxznFYIv986HEkYY/J2u3ERRU1l9C63ilfFE
         ehOA==
X-Forwarded-Encrypted: i=1; AKwUvByT0X9B43gdzFzJWgA4nQoeiR0xtxaNvvUnDu+aLH4W2TlWkLmnD5xH6FUvYrp3Y7i/3DnOIGNSxg==@kvack.org
X-Gm-Message-State: AFq9FYJ50vlhNYEx6QZed7IoW/lDGhjki3eGZD4tzd03RUkK3h3ETBT2
	/S88SDTGI4AsWQ5iJ7Z6OIPIexaZ5avk6P7oC4aPYFQ5hHx8Yx03iZq9QIulCGIrKIeP6ga9Od1
	GvtE7q5k=
X-Gm-Gg: AYBFou3qPIJpXPzqVhXRVi+NfOendn+eXHWaBoldkFdtbLsF3oxNX1h8rDL2bUJO3Br
	Edpi2KW3L6ZgRtsHEtfyyc3cPATXvnyI/IXUnjWOL15fa5f1aHVf7ZPumTj8YTW6Txz48r8GHU2
	o8zKj19P5YBJ1RlKe8U4ZqiY+C/Tok1gmpxUk+dDWhPJPv50N6L6wTuf/2DFEsFV2xN4Hj7lThE
	wYB5ucjnory8qOKnP2E/mMSLxTLD5pW1EcbIrAgDPih/p+7uDraT/h52IIerjAD0DZlEkDhLgHY
	AfFqH79Qu2E+ldZ2Ah9fitPYlEii+8E3PO1erqOkqfIoCytGme88CZUzMVzyXSSQR1e60K2fIhS
	VRSTYHcRknuFTZzYcY/R9dXWyYM3ia0nDdSLSdk25RJOnlbvp6AL4phQ09WhtGAwGuYMBLxIaFn
	udpIzA00L2hM5WvdJEAd7gIUG/f61PKwQMi1CjYPF/9Cw6HJQa/lWOD3sUq61wdLz/DbbFJ47OU
	J1IV+jsPb8DAUSPB9MKREra640QyELivVQcv1coEaJHTDb5sbc7HtouPVrjA4Qi7Tse6vQ7ZE2d
	fvlKLJtsXwUDIHUa8XYS3sNLtYsJO01zU3RPCz3BAGhaag==
X-Received: by 2002:a5d:5d13:0:b0:48e:103e:846f with SMTP id ffacd0b85a97d-48e6e2f91b5mr6296751f8f.9.1793371382383;
        Fri, 30 Oct 2026 07:43:02 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b725a2sm3454862f8f.13.2026.10.30.07.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:43:01 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 0/6] mm/mremap: report a failed split before moving
 anything
Date: Fri, 30 Oct 2026 14:42:45 +0000
Message-Id: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOas5GoC/12MSQ7CMAxFr1J5jUXShC64CmKRwVAjGqK4RUhV7
 05SdizfH94KQoVJ4NytUOjNwq9UQR86CKNLd0KOlaFX/aCVUegtToUmlzEXQslPnlEbZ+LJxiH
 6CPVZmxt/duvl+mNZ/IPC3FRt4Z0Q+uJSGFvk7XFP/s2wbV+l5uH3ogAAAA==
X-Change-ID: 20261030-b4-mremap-pre-split-13a3d54d6dbd
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371378; l=2256;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=G/p9kYfhBVnc/GDhjsqodhiJwDhAqmNFszrnjyTOZ4s=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QOVY24ule8ljYjad9dt1Lw9nOAlvfltuTV+PDM67JYWqeppOo9Jmy+Kkc2B3S2JvFWR+cGruJ6p
 hK8DCrLOWkw0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B71440003
X-Stat-Signature: twqfc584p4f87f3xawfgmbxrhkbcmpac
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793371384-694281
X-HE-Meta: U2FsdGVkX1/u5Or4nHbFOCFfubeDDcCR1zXv/i+7KJf9f5wiJ+JmNHgQoc0tgW/Wln87N18elVgSfgsedohP1SytPPB3cHI3CumsNsDD9QpOJciLSpGBXUArF6GVFyfDZDXA51fGarxzcpr7LXEVrW8XB8LXsJuqoM/UurGH+C6hWhiKYn1kqMzCUXEBHeScUg3pL7iwxWqMLYVvjp8fuHwlQtIf62lT5ayTaq3vQUmwt1i0kSx2Vhm/SK37jXt+H8AWoL8mhQMAme58JLIggPTYKniUNtpV0/drsmTDX2m47kD2On4teoXBrXjmhJssL0gmBcSKCVLE8VnmR60nbHDPn93ELXAkwPu3sYnwsGhhnLW0tH+5oCiTMWI4YLVYDojtcU/w/6VX9qgxuAn4rdL2lIGDREEZ1NloB55O76WTpowRaNm2vMpuNx80lPwN/ndf9J852YpilYowygyhvFWDOlHmasyEfYJO+RTrhBMfXFUMZ6xGXmzv3hFj1Ux55b5JhbIKFTcZ7jRkaqkADXLkqzhiA8u+yYxYjmq9hHAtpA8ukC1BnyyomLDY65o3ORDmo3nITdQMHKvNrDzZ/L3VDHRJldtHmCIo5m3hH0E4QwtmT91k6v0KqO6RJp4G4vacAefpFwwe3+eQomE+7JAs2rxEBb4HruqKisSgJaE2bEKUgNJnM+qFfWaYDRq5ikv6tkX0ybQPN3RydsYupy0DCEwKP/axjignoAE3G0wexeMT9jdw/NoCIXF5ThqhOgRRfv/FYD5cIhzgInDRL5qiNXgcw0V3wz8XUL8zuHCrQsLAPkIkmNZPNrM+0+tH124S5atTok0ISzjeP+vKq866WmX3KUmT1V9JYOpc0gO0yOE57dNWAwatrL4u95BbGND4It5w5f4ubWbptpStCkAsTy4IkFSUXLZlqAm1K+6dsta1+aeXyC99CX/Oq8za9AmeMHC3POS8wecLflO
 /SmmmwyG
 xlDoYITKKwfMOeXL9UjLwRGfFa2/jV8Blx5kTTJjAR5DwT96GSTYFQqOvxamOCJhyqZS0eCz9wcbuqe6zmlwyW8qSSEbLdRidqzikorQX6q3B5NeXjpDxyIJ2SmF1WrEL2q+27aOJLvu4p3Ca2CAP0YfWP6CTA2R26ajYYgc4ucosVOYmqKhLq9Thiv9LVB9oXncw3oba2dTudMCrfLs6Zrv/1842PUR/X3QP9v3eG1FIL2TAWaPYgr5+tUd/xK40EO4sFW9o2n21mAY6c8EZU+Uy9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

I went through the callers of __split_vma() to see who can't cope with
it failing, and mremap() is the bad one.  If you move part of a VMA we
don't split it until the very end, when we unmap the old range.  By then
the page tables have moved and there's nothing to go back to, so we fix
up the accounting and return success with the old range still mapped.

Lorenzo recently added a way to split ahead of the move for the mlock()
+ MREMAP_DONTUNMAP case.  This series uses that for every move that
unmaps its source, so a split that fails is reported before we've done
anything.

Doing that turned up a real bug in hugetlb.  We take the reservation map
away from the whole old VMA before the part that's moving is split off,
so the parts that stay never give their reservations back.  That fix is
the first patch so it can go to stable by itself, and the second patch
is a selftest for it.

The next two fix the accounting for when the unmap at the end does fail,
we either charged memory that was never accounted or lost track of the
charge for the whole VMA.  That gets a lot harder to hit with the last
patch but it's still possible.  There's also a test for an old size of
0, which nothing covered.

I tested this with the mm selftests and with a loop that fails each
allocation inside mremap() in turn and checks that we either moved or
didn't.  The numbers for moving part of a mapping don't change.  Thanks,

Josef

---
Josef Bacik (6):
      mm/mremap: fix hugetlb reservation leak on partial move
      selftests/mm: test a partial mremap() of hugetlb memory
      mm/mremap: reaccount on unmap failure only if accounted
      mm/mremap: restore VM_ACCOUNT if the unmap fails
      selftests/mm: test mremap() with an old size of 0
      mm/mremap: split first so a failed split is reported

 mm/mremap.c                                 | 55 +++++++++++++++++++++++------
 tools/testing/selftests/mm/hugetlb-mremap.c | 52 +++++++++++++++++++++++++--
 tools/testing/selftests/mm/mremap_test.c    | 52 ++++++++++++++++++++++++++-
 3 files changed, 145 insertions(+), 14 deletions(-)
---
base-commit: cd1d0b147afa81f80927f9711e53401703964217
change-id: 20261030-b4-mremap-pre-split-13a3d54d6dbd


