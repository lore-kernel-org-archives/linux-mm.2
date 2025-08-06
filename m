Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6287FC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 22:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14F36B0093; Wed,  6 Aug 2025 18:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6326B0095; Wed,  6 Aug 2025 18:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDBD06B0096; Wed,  6 Aug 2025 18:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACB056B0093
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:00:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5633781C28
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:00:28 +0000 (UTC)
X-FDA: 83747702136.06.C14B56C
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 92606120011
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:00:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="GkHtuX/H";
	spf=pass (imf29.hostedemail.com: domain of 3edCTaAYKCLQmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3edCTaAYKCLQmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754517626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0DGq3Zp4fJ6DZNHeIX2b5x/XDF+UYujZX+55RuFP5IM=;
	b=Q1qZoXVovetBx2JxlWAqLeTgEMmc0Le+fwCVsXhcOYV5KyQBdwGady45Di9FRYB7myj5L4
	83nxOQ6+riHO9ow6XvQDnQlfs/VS6Kb/33qmTY8/F0522y/DUEM9dxlyrDlG8ZScMCaNlO
	kIEqptkLU6hrnzbi1je5Hd4pWnRSb28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754517626; a=rsa-sha256;
	cv=none;
	b=D649xY25UtzrLX2seB6TkDFUl9DJtXey4oanVcHJYofBtNZm3cmt4cFzV0PWRjFwpCOEQG
	sIIvw/KuA6KPzPxDigpXtmoLY+BeSNVOACNMSq7Brz0xJVOvJyq6itCURHVeOcxnFiA3V+
	vgusH2VL2WnMYWklXhMfvBVhp8j9Zm0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="GkHtuX/H";
	spf=pass (imf29.hostedemail.com: domain of 3edCTaAYKCLQmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3edCTaAYKCLQmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c37558eccso231361a12.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 15:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754517625; x=1755122425; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0DGq3Zp4fJ6DZNHeIX2b5x/XDF+UYujZX+55RuFP5IM=;
        b=GkHtuX/HPXi3CZ7ttXpo7/Tgmlap+bx0MMp3iyCXcNuVeF9O/7wb/m7Ae5XUGM8iYS
         mqHoFZTeDqGyZIRtwEDkZtPZTchl5lvi9cm7qkPMkRhZ1Lu7l5sHT8tr8X9o8MYDDVBE
         lCYzYai41SoUlyPsH0vdFTBG73EmS62ye2eDYhWN4Qu4qOrftQhW9uNdmbB6y7DLBio4
         78UmdtffLXgPBE+ma2FhJ4fXEWUDBxwnexWw9e1PeOS3y0Y3MpqSQHnWkrrOQgaxOtOt
         AMGE8LNXKJa8V1ZK/5Bq88BiSJL4GYIRE4XfstCApdi8N/BP8hrNExukrmUDxRtk16CQ
         RSRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754517625; x=1755122425;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0DGq3Zp4fJ6DZNHeIX2b5x/XDF+UYujZX+55RuFP5IM=;
        b=Y1rDl6DoTy1G6Ug0iAQie4zVU8Ii5ZLmbg35evqnimSE49CQEqmD0p4eyVMPMKpwrv
         dbaj0guPCtOAiI8+4Ecfh+hDClfQHL52dtvEscNIh28791GTUr3LhBCAoKqwH/G3l0mA
         xpZu3bbdW45yWScp4W+QL0RqEvOxquA4ZWMdc2VGJkqPngfiWXh7joHJtwWCyiNLoolj
         GKbu6DLqS3I+NOjOpSq6E4GieRG3+rRSTRljxa3I5yB1XKdH85vwP3MO+kOFqZZVxpyf
         hDnpeMuYFaNPWRor2IDYYYoL7OfKF/5cGiSG20zYX0k30RAOZ2PqKBrrZs2LX84xKFke
         Lw1g==
X-Forwarded-Encrypted: i=1; AJvYcCU85cDCYUcs3SSIxElHEcrRkaRufi6Ta/vRdWjSVDlLePPOGvYt9mzaUx1UVFuKP0Kw90C9Sktx3Q==@kvack.org
X-Gm-Message-State: AOJu0YwhrWVWFlXrTOzZQSRVdWf85VXOAay9CDo9TffWueGc79nvOZGS
	ESw+TR0Ny0wHsSvkVVa9Y8CUF9ZVgyN8XkUJycADHXw2oHcdiLwbeJ7PtYMYkqXEHB19FCDUWem
	bLrKEnA==
X-Google-Smtp-Source: AGHT+IEgXVgvOPOZLzpUU0uxEIMp34b7pNlfgpNcH4fA0yFqf6+H+2ZoRWuQLabxen09rQvlDcn4hw3n9b0=
X-Received: from pjob20.prod.google.com ([2002:a17:90a:8c94:b0:31f:a0:fad4])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54b:b0:240:8f4:b36e
 with SMTP id d9443c01a7336-2429f30a072mr61870205ad.34.1754517625374; Wed, 06
 Aug 2025 15:00:25 -0700 (PDT)
Date: Wed,  6 Aug 2025 15:00:22 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806220022.926763-1-surenb@google.com>
Subject: [PATCH v4 1/1] userfaultfd: fix a crash in UFFDIO_MOVE when PMD is a
 migration entry
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: peterx@redhat.com, david@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, surenb@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 92606120011
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: kufgoe4aietxx7hf9mg4n3k3a67t46zd
X-HE-Tag: 1754517626-177422
X-HE-Meta: U2FsdGVkX1+lVHEQidbOM9B2E5Gcmn1ATFuaNr37hm/mDV2w8rP0JzKUOxYMEdTfkcoiw3Tx7608x3c2H8857p6SaPTtHk3cspim7hqWwqq0doE9/JV2qkc2Jqk4BDK9eDaj8wF++Q28CzXiIRWVNkoNA5fn/sTeedM6gchDE9lReO2RN5UFJr/XQGZDEh/mOv+85b+m63fdmiaa+OcPJwa0BALD2pdJYBKPLRdZQF5e3jk1OkMFTvsmO41FrLKaD05euK+IYH0QYpv4t2+GNoxxaKOBaG8BGFo+cojofqmRtVgOQTVeMpvJ7d8Qg/KApaACLJTiIFppjxVz7LDTarW5DSi8i4HW0ACzm83IR8/MJyw7uaApbixeDpeipFUHcLzcArsmT3Uqh5THRtz54gIeXZ6ayA80pKBHxH+gnXuap9XDy+FikbqO6SnW6vgk5GMtI5KipsUI9FSi3n3nFKoT2FDSAjfN4aUw6VRiMDX9CZcocjp3mI2qrZqTd1bLzLFWUyurv7VRBs8W/r7nvj6umqXpT6cV01gmg5zOdn647xa7IBvaPgooAI1KdzhgwRccoK2/1sYu1MymP7y/uVYjv50nqjsrV9h88GAbfFkilz2HnoRAB/yqJxPX81ZGLiOAYIkxwZKQ/NYRfzTdewhgw/Yzk2LJzfKNNolVfuIeupU4yz0tdlUlaG7desEUHw6EQMTg1urIDbYV3w5c2HNYYn1ulSnonCrJIuDxULLMP8l3CsiSQaPnPwQzEQY2gSD1elYbCDqfTmZq/+vM2LBX78jgUO3TrmV+glrfJwlsYtpw5gxaj50ifoKxMGMY81i4i3GPxNJQwPsFqjhuhFXvY9Ko4tOOFJpoVRvBicrQR4j6hPHs5851oGhcSXE0Fz64ZpOhv9Nw9l3J5XDyu63W2il6pfPcQoQT63CldpH+be3J3UUb8ofHiW+qWfH21ilvZMJmdEeiU7bW0/y
 pD1ZAgEI
 p8s2LwUV1dRDpexUKVKunjAqrhKkdqGaBSPUsWggYepv17tZJLXO9jqAwSwDqexBk8dCi52Yy1AJ++I2sOSlAGBG097EWbwcd8qVnNgZs+u3fokUZpqAWx7H1U04Pos3oSpYNS3DzPltSX6wmlKSDZn4R0FNWbqRFUUFP2eiceVBMumvfo25iOvSUH3IRRsD44O8CpySkotydBqFn+SM2YUM/jnXIcBwC+vBUtNjX562ENaA+LFsfBKZNneu5isXuTiHFPS0nNuCpCCHnjzZMpsjW3MIihN0NRAoXpuNPLkg5o5U4C/8erQf1H8Uia8JFDwQuAd8QjbpxVmN5jBfV8f6493GfPQ1PT3vxZAPsnnBf4r3W6HOqF7TgnDfBYeVL7CFe8DpG7Hv+aN/kYh22k0c+7OnbdeHGiD7G6SSX+Rp5kaxLJCnarwZTmJJlI1Nhy2mxFMIz5GcSdptPDOm+CmclszV+xgwxKOMZXKsyEP9U03IfoI/IYPS1vW5+WlcDJ5SYZXoKXOwDSIQBOn3h1VuD1Ks8tq0VfBCe5bdiqo+1//Z4OBFEozKFuUWXlbkrhXZ4hIeHuKRwNicRC6bcek+4ZStNIpbFlchagw/02Cr5DJsELRYLVIRQcxyTDT570YPp478DCVAuj8T0OR44xkbO8A2CWsC/c8eG4Rl1HZO8Ll79Nsg5irXxo+WwNRzzCAc/HxDusVhsxrAOecFJgMT4+2qwTAV7w13Mdj47lPF6ZGwsT43IcQivkWRz3NP2M7YPkEmk0VXhEl8uO+Q6y662MZhaTbSFSk1tBPwojnCTctQ9YJrBFivrsKL4a39wXEmrp17Tv700BaJIRN8QWW3Nm1c9HOslloxU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
obtaining a folio and accessing it even though the entry is swp_entry_t.
Add the missing check and let split_huge_pmd() handle migration entries.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
---
Changes since v3 [1]
- Updated the title and changelog, per Peter Xu
- Added Reviewed-by: per Peter Xu

[1] https://lore.kernel.org/all/20250806154015.769024-1-surenb@google.com/

 mm/userfaultfd.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 5431c9dd7fd7..116481606be8 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1826,13 +1826,16 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pmd_folio(*src_pmd);
-
-				if (!folio || (!is_huge_zero_folio(folio) &&
-					       !PageAnonExclusive(&folio->page))) {
-					spin_unlock(ptl);
-					err = -EBUSY;
-					break;
+				/* Can be a migration entry */
+				if (pmd_present(*src_pmd)) {
+					struct folio *folio = pmd_folio(*src_pmd);
+
+					if (!folio || (!is_huge_zero_folio(folio) &&
+						       !PageAnonExclusive(&folio->page))) {
+						spin_unlock(ptl);
+						err = -EBUSY;
+						break;
+					}
 				}
 
 				spin_unlock(ptl);

base-commit: 8e7e0c6d09502e44aa7a8fce0821e042a6ec03d1
-- 
2.50.1.565.gc32cd1483b-goog


