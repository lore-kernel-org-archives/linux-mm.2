Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CEE2CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A0D6B00B2; Thu, 25 Jun 2026 22:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20AF16B00B4; Thu, 25 Jun 2026 22:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA796B00B5; Thu, 25 Jun 2026 22:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6A626B00B2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:44:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50EBC1C5F7F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:44:09 +0000 (UTC)
X-FDA: 84920519418.16.291D1EA
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9043640005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:44:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WlbG/ADc";
	spf=pass (imf04.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782441847;
	b=gtP76mc6sui4fWr2eyqWFsTUiNhtwE7qjIER2/AZDmnMwyKEo9tYYDBuKadm3pnuB9LClG
	7OcqPzs9551Z8w09zL5qY6tU84+TFlmnQL43MIXT8aWNZyltP3MpYYsRiHI3rub6jyt8aY
	EAOaz84LUT0qYkddKaA2R3yzuRgtsvw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782441847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kl5DUTG1z92bRujT2x2JYDXqAErM2eCZgRpvWF3a6j0=;
	b=A8WbkGe/tgDve1Wfvdn0IeD5sBTORqTSssbh+zpR4SaGlanNkddZEwS2E0L5j93Hm7nz4r
	/onxWOsO2K+Do24c9C+FHbuMv2GiifiVjoRNgDlDEBZvktDnag92WBylLHnEm0186KT2Oi
	FYtrDZM9SJA+qDCxTkKi/fNxzfSCzes=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WlbG/ADc";
	spf=pass (imf04.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490c0c92cffso3119515e9.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782441846; x=1783046646; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kl5DUTG1z92bRujT2x2JYDXqAErM2eCZgRpvWF3a6j0=;
        b=WlbG/ADcTDYEbiof7GxZ3uj6n0W/R8w67shbZFDwuxKKlDMQJBkTfLOVuVFy+4sQjD
         EwWX/sdPm4qz51Y3qTchKMjmBNbTyx9hFmev5ZKaG/nNw7b03ouHn5mUZ2ycwmpbfP4P
         i2wLsL+sWwO5TP/qCEfZtDycnxGM3B7RLTrRLwWhve5JiOsSCijoAUa0ZTvosC3uHSq+
         q+4Dbp17xkeYNG1TelIa5DOXUb060QalmpGpLbum2zjxDNivBX8TkGoRC+R5WEKxGHO6
         X4y+EEoJI0HZXfIiH40+SIdQAhExXlDVmxWbh2CsZNEsmcaU9oILWh8yZ4ckNpXwByCi
         nHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782441846; x=1783046646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kl5DUTG1z92bRujT2x2JYDXqAErM2eCZgRpvWF3a6j0=;
        b=r6hSUq/F9xJQ/MslmGaR8nlP8CW/7wUA4aNodQiyAIN3yei7+vrTG3YnlKKhK8Eor1
         Kvqg1H+Xhlf+Hm44wnSFOQwDZVtwoi6WvXkbeM1uSTRJJhbxf7dVtgLIikNT/aiDueSI
         db9GkjEzGLhDfCRuBtj410SNYJ3iESJbla9cvTopnJHzjLhk8bkQgOzLyENfEHIWeLS/
         WHxoNnERS4mi9tPfcLxrJJLpxfIN4whvTMWQEdWgmVxXjoKl+nm9OvFzhdOhDb5pKe1z
         W9WXAj+VSrZve6nRn6kW44t03Xyr/5L91ztk/cQDIbg4D+H+lSbt7tzZIiW5SXS9/3mX
         iXRw==
X-Forwarded-Encrypted: i=1; AFNElJ+WDmu4hjmbLSX+F7VEMjomgiRVQHfrJz77L4RnXh3IgSeJ4DJP0Lb8ZAtse80uB8jZCgl6Gs/hiw==@kvack.org
X-Gm-Message-State: AOJu0YxZ6NqF6Wwj2tyQSZdW+ja7xxzyOvLzlroR7+OT/gHlVnYc+h7q
	xFXqmirQIhwNv1rVjsporkjrQKEq4TvEKf7rClzP62nuveaJT96P7DUt
X-Gm-Gg: AfdE7ckoiVojxAqwqqJP3NdA/aROjHprSp/l7AeHx3mLBqLIWhJ2qbfnEbPZBWvoAV7
	g8kzcKEu1dys20vVM0uCGa1J+LOeZSu4Ej+fVao9F+19i8hEEmlPPE9rNEk368UL2zV32wbSQu8
	v013W/UBSvYc4poUtxB87tlBNdGLEx4/YKRWwsNkCakH1OTNLODYbha+H8r7h5UNveYrjPgRgSl
	rJzLF9Bm3fTcF1ZtzSGtuFXZASaY6Zlv+0cjEXlksb/ojt5bXVrTenLJY9xNYsf0xgk9ETEVzlW
	R5aWj8c7b+vvHgUP748yzf/bdVmkZCdGp34r72W3TMsXJu7UqpdHEYlk5lmglKzEskD6lQiJT5P
	YtA88csfwS1Q09M7x/q2pOtWFAq52jALC1v0y7iS86u6c3RfJS2M2ZMlgbdyo1VqQ40MeKYHfNq
	KC8pTKDProm2scPXr34LyHkA==
X-Received: by 2002:a05:600c:820d:b0:490:bcc1:4edb with SMTP id 5b1f17b1804b1-49266884b7emr68105355e9.27.1782441845987;
        Thu, 25 Jun 2026 19:44:05 -0700 (PDT)
Received: from user ([104.28.154.196])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46f0db007b3sm1605212f8f.2.2026.06.25.19.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 19:44:05 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	yahia ahmed <yahia.a.abdrabou@gmail.com>
Subject: [PATCH] mm/shmem: handle integer underflow in shmem_fallocate
Date: Fri, 26 Jun 2026 05:44:00 +0300
Message-ID: <20260626024400.67853-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6if6pe4gufdtudegf7qcjbguy46hayku
X-Rspamd-Queue-Id: 9043640005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782441847-830116
X-HE-Meta: U2FsdGVkX1/PjsLROrYY0WbUS5qrqCExq8SRH2Eq5mwAfWw5BWOBo+/iNjqBFmQGLKzB78WObdMvQZL1O9II3FQouJcnog9XuyEyvLtt0TI7b4jfm+aEruFmTnJV9X+jSTA6yRhZpzoGcO1VUAsUzAvvkjLKTSgGK/YsuNoQraywfiYe4tA0zrJRcq/agmgqzmX4GMW0uux7qbgfdsbGQrQMNLfD8POSNzYLnlcF8mkwv6OHkG/8uXGoJuYqYcuVxLtl4GnxZdhOMiuYyYyP+7PMLgiHigqX+sv+XGHtahO2Jhc3DRJIL3pOc2innfDYieead73VRePIGj0xW5fMZLqv1XdZk3uTytZala2vemlxsHyNiPisxI3BtbbZ61A4ryR96oVl4yrrHeXxsk3s0hmrHae5xmevoFjKTy4yDaUuL+BMwBrgCm1NhET5rfG02x18NHOqYAUIH7a1QE5LvyPdSjx+3qS0HWnyrDEz0irpVJSye0JnZCQJAut/yfb7Ieq+bTv4MAihRjCRxslVprCNf2HpohJVzwH1DRQcs9mmlYRb9/ojLphbwuvRjMqR/ioZQ/AvPFCKMLBMwXpyuCEaA8K6AdUttscC6aAhjhtIIHEx60xAYywoy+Vaofa2zwklwZsL99JIS2anuyedaCAvnIKiiLX9643jf/0pvIUGW7yEDsUfDkTypeJynPRMyDF2Vn8GHo9gNSgFsc51sTJp7K0SWfVyUs4WSWY6NZfFvWlvuAxBc+yYVqid35oNipplmrSDg1JWmwProhYA+yqRQstn1RXKAoy/HBR1Im+hm0fqiOpFKeU0Ns8aztrIWmfIFjT1XLy7lkA+vgbYQP1yWAQ8jU9rVljABDvO+g/9zj+QCAxv+od9i7ddW2mKoneSNwdE/phOOTx0WdJL7X1Z8OES7/MF2/vWyYwnqwJE/L4pPHMeMf1MXX8g2zgSEzJ/xhlrSI6BTwr+o0X
 +wwgvepN
 eh+iJQevHxXqt4XFXcZEtf4zFBZSVVhLxXMBGax/4Bbqd1+NTUFw63S0OP/QC0y8IDCntrmNUHZjAf1FCku1GPOg7jVpPUMR3dgUlOlOoteq0Kj/j974r7VshENiuPK1GbNQ7Mm6z145pT0zk2q8677CNJX378UFv4YE9PqSOG8N4Sk4R5OAJod10sDKwvhjqBG1duoxepgmt5wTunfe7ebLSdvOVWgfDodqEVNr9demBJnHOxXKiL8f12YXVlgngINBYiAJ4muQUWXx3uOMzPjlkFrmyVXP7jyAXMSjDRuYxAJmlSSCKQL7zgk/Lsic7c3lk5IzU+EdMRbMar0icjyBIXA0jNlcjB5uJXJTC2YCLKRpidBiOlmWH9uK1JpMslWRbSOfEpH3ekw9Xa1T4lT3+DeCCtXSGD7F5Vb2sRdaIHO+gdcxFS//KpRxXAGbxrAAkykH0AXQ7h5ltmFI3pP8urVCJEsBx19s9M+1kR/SlAMw+7k7BnAFIv8LnJUBGsG/V3Tsu/HpKIkwSxI/U6V2xXYoyQYEpzitAX/FMTUdC60/STRvMhHeVd4LQLuB7afti
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yahia ahmed <yahia.a.abdrabou@gmail.com>

In shmem_fallocate(), The calculation of unmap_end
is done via round_down(offset + len, PAGE_SIZE) - 1,
so for any value less than PAGE_SIZE, round_down will
produce the value -1, which is handled because unmap_end
is a signed integer (loff_t), but later the condition
(u64)unmap_end > (u64)unmap_start is evaluated, which
would mean that unmap_end would be equal to the maximum
value because u64 can't handle negative values, thus making
the evaluation always true and calling unmap_mapping_range
function which would perform a TLB shootdown of the file, but
will be kept by page cache, Fixing it would require removing
casting the integers to u64.

Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..33829f296f1c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3633,7 +3633,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		inode->i_private = &shmem_falloc;
 		spin_unlock(&inode->i_lock);
 
-		if ((u64)unmap_end > (u64)unmap_start)
+		if (unmap_end > unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
 					    1 + unmap_end - unmap_start, 0);
 		shmem_truncate_range(inode, offset, offset + len - 1);
-- 
2.54.0


