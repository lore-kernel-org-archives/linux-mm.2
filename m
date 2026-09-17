Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72754C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 20:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78886B0095; Thu, 17 Sep 2026 16:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5536B0098; Thu, 17 Sep 2026 16:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826276B0099; Thu, 17 Sep 2026 16:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 54EAA6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:45:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA63EC0472
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:13 +0000 (UTC)
X-FDA: 85224434106.12.C337860
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf15.hostedemail.com (Postfix) with ESMTP id F01DBA0004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NkjFVnPN;
	spf=pass (imf15.hostedemail.com: domain of 3VlGsagYKCAc35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3VlGsagYKCAc35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789677911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWbGWX7ba0RN8OdLexXyHstVRWEHpkbx670qUQ+b2/Y=;
	b=asEFh0NEEREfQ3+iLsZAb9S2OuTq1CZIpj6C5gIyD4sq8pFmKMUTLGojkvKD+CAMTZhR1+
	N1ftWFTYhTVdGV4uvj/DnLW6cNqm+Lt64mq2Ob7K8foQPtzHxe+5pShed/FR/JhC7cuMpe
	fulq5bfztFAx5I6IhLwGR4M7qPdzDU4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789677912;
	b=rzvTVMNHL2tN3EaSZc+zzTief+vzL2f+wayJRnL2nEoXMnJ9kh+k+r57w0Q0TMJyItAvIo
	TqVA2dsK5GMrDonr2WjWGNfa84w5WGK30BoycEPdCBilb/fkuKGtI9KCLab2ykJSxlSizW
	C7FrxdKO4cKHui2r/qylNb6ikfKs2z0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NkjFVnPN;
	spf=pass (imf15.hostedemail.com: domain of 3VlGsagYKCAc35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3VlGsagYKCAc35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d6fed0652bso680465ad.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789677911; x=1790282711; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FWbGWX7ba0RN8OdLexXyHstVRWEHpkbx670qUQ+b2/Y=;
        b=NkjFVnPNfBNEVZvVVHsbl5vIw+7+Jw0/f72foMHAq7cCe6n3PNPpBe8wczJ8yY8aQm
         4SCHYfqGIiKefUL7rgSbQQGEk3v6fo0wp0sGUN8PAs/s8yyrcOxLeigWvXeMYAhmMZgx
         U+4Zo62aLushIF//xl3GiV/mYVdsv9EA8aVwncKgI0tZLT9TpYkQ55qo4+dNndTjRKmq
         s3X6rwBJWAdb3Z6VThFRhzjRdbtSiPuf8/P9g3lVJtpqMqgkipmNvehZvPAPonKPMolZ
         IukoM9jwMSsYMIhBai0PJwkD03YI3B00L3DWAE/VPBJYwJyNR8aAxalwW0VBw1b2QOp+
         aAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789677911; x=1790282711;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FWbGWX7ba0RN8OdLexXyHstVRWEHpkbx670qUQ+b2/Y=;
        b=VyhTGu2YZn/BnXmzDUc2UkNmnndEUU77PuqfIaL82Xeb630qiNIAolsDEI53zmJhYH
         gXEWyYsBxKe5whWzty7DCQ3iYkAMnL/vf9xJ8PZb8QRjxy6SY9Ga4CTSUrTf4J4+6XUG
         /dAPtP/Ochduxvn4sYd+JBDqcVjGJVnsKKgUfooTkGPu7mnWmaR1L14tQmPG93/FLBFq
         n0I9XWU/7MG425ldm9tgme7UPnCCFpYTd8LzPH8sYA66n/3QAwCBbnvR75OVs3+L6RJq
         FUR5apG6ifLaL5cip6cIp/6MwS/4OglGWi/p7TkxrlkZ4gvKBhnp/G6coQhgRpCLKxBP
         UTqg==
X-Forwarded-Encrypted: i=1; AKwUvBzskuyhHaOF8y60vkAAmHhcu/FxS4sc/f2QjDqakiHsGUvAv3uUWn3R7wOf+wO7MKwS5TE0MwExxw==@kvack.org
X-Gm-Message-State: AFuF++k7Ih6m1CKZVaC5Ukd7bSvzMDh/xWRJezlaH/raVIHTqy78ZkkO
	lFWmjMFfP3le/Ao36+h0x/sNWrPOtD16QzjoEAqaEwOLdERvbYxUNz9pcU2iO5E56jYgCpfc+Fo
	3GaqoZg==
X-Received: from plml16.prod.google.com ([2002:a17:903:1850:b0:2db:78a3:f716])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32c6:b0:2dd:ad74:ac29
 with SMTP id d9443c01a7336-2ddb1bae2b9mr6705575ad.27.1789677910414; Thu, 17
 Sep 2026 13:45:10 -0700 (PDT)
Date: Thu, 17 Sep 2026 20:43:49 +0000
In-Reply-To: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
Mime-Version: 1.0
References: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789677906; l=1749;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=3xlog7W6+Eb7uaognsijeu++wSjtW/1ijfNh02cWLeM=; b=mnhxUqOuObNj+R5apFx/dutD/hRRG/ythFNvIOI5goZLBTNWbCm8BcyPLsM2Vszxyyckiwnet
 SZYrzREtHi+DHtWpEun46A6CGi7NLx95gjCXlHx8OcmRZ0VdUKFkwcO
X-Mailer: b4 0.14.3
Message-ID: <20260917-memory-failure-mf-delayed-fix-v6-3-4b00856b5364@google.com>
Subject: [PATCH v6 3/5] mm: shmem: Update shmem handler to the MF_DELAYED definition
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F01DBA0004
X-Stat-Signature: p6c1aq63u5ab1d6rk4iw499d34rq87ri
X-Rspam-User: 
X-HE-Tag: 1789677911-705994
X-HE-Meta: U2FsdGVkX19imfV7eWdfmGG3uUB9rjI/3snJvs5S1swcHvGalwQ01pxjX7xpnh3XZZJiC91jwe/Z47o6y99shHU1/Eqzxoke2E1EzvebOsIytV20DylpKBINeUDOUgSUb8vByM7B4/3ecEFhuIo1EuSO6iS8sMTlijodgTJAjm+ZIGFc9wv3L0YfpHMrG6ZAHbTtqlLwTKrBdFavaFbrqEbk+e/E8cDONCXQzyv1FNsr/ZYLccT1ld3vuv5IPhpHv7vFLXxvuhWD/lUwMuRCEWNw9onttt8b9KSxvcAzYXZc3sJbwJxXRmlYoYvyfVOZx5JVWFgkIDYXlgzn5t2MrZ9woY4KYVw7IZCSc+zATUZfm9zXslQxjbSM6Jn96KCBWIVlKGgNPB8fgJigeiWqbPWGM6ZXDkGv3mvMFANkjslXtqTiTvlwyjC8uwxWQbAh/GOljVZFA8eU1TFmBo0V0Jk3Fki5JMNI2uGhx+Vm2/UHNoXIJAJAo/OIxi46QlZb0bnepxR8fJQZn6RjlSE1rqGJVmuFTuurJH8TO++Yv4sntPEBLk9rSXvSwSc+FxkpbRJ2TNfyGXE/oNDm1xrkg6IitjFz0dTm6I/7JPP9+rOavSkC2r3DpW6Ud7ivual7fp4n+ziS+2Jy1GspUpOd2RdwV/P9Y5oa9ITCHexd/xlJxKLlQ+kWDygasrxSyj0VCIazmwoIVsti7mWG21eTc8/jif8Td/S449zrj938/+2rpGKeiihcKgTNAjIj/XTkfrmcavHOlsyOnBBcaeIEk3dIBfyfPJiD5H5CjUoEvZBp0LahlwWba7+zt9SlDsRr3cCYBjPquvE3T/APEZid7rKieczhzweZ3Iy/MbzpTrJXRTeBtlhnK1ILXrmQPbjqhszU2wBeY66vaTPr8Ep0GYN4DYweFU9o1S/L1e3Y+NGlmClRvnMPXLV8FDXIWSN7K4R4jnDrMRmONK0VX8H
 5cuxnCA9
 ge9YFc0fj2AH0fevjcqyTIEmJMC8aAmXhzhqEMBF6ljIn704bfoZoGCntdN04C7hypk5JHW3OSJi7v6FmYYi0EPKdXvTMCcPOMcAlCov8B4MaBorbsDGtZ9xUWB4Ar5i1HywsdkUUCHIX6OJNSgA+H28XF98T1lBmXrR+Kbx8I4+TUVZMuDypGuM2VDdc8RNnQQCDez4Z3DtCOVmu4RqZPfWF3liWKf8JrGLBz1JWQdZ5zGnVWI7J2NAjYWBVXECSPzYo47P0XjEps6cCasq8TffKGdFUsdHZNcIXoQtP/tDTk1iHjgmtoUsSpywj3b2OzMVUk70YbmYMW/lYldwrK/gee4IQcJ46TETvX6MG25VWR8+0qDtZGz1TPhvdV6t8Kmr9zuhV7e6moQ7B2LplCijYZ8tD2XcZ7l8TVAIwMoJ1t1n2nFAFaRaTG/i9b/GKlmrIRXvSS8NoaY1vkMliZxX8m1y98iRyBypykOhT7mPYGEVgsjcgSaxvSX8WTSVtvA7ZQKP0+/YgQ7JZRNJbI38bhnMoohFyAXY3Iw7P87+I8AkMV35QocO7EjB2Z4jO1kPlREPaC7+xE9AEzdyMHT/eBHWCSWHzv93IVODAq9WZcfNpYSLysTFk1vwZq9tIRiM0/u6baFaGMfPJL3pMtnFRSXpVp8WkMWfIvpW3HFYKgJu2icnsuAAoM1ghd2mpnOxU4GdXumWK4HS1MHou2otpvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To align with the definition of MF_DELAYED, update
shmem_error_remove_folio() to return MF_DELAYED.

shmem handles memory failures but defers the actual file truncation. The
function's return value should therefore be MF_DELAYED to accurately
reflect the state.

Currently, this logical error does not cause a bug, because:

- For shmem folios, folio->private is not set.
- As a result, filemap_release_folio() is a no-op and returns true.
- This, in turn, causes truncate_error_folio() to incorrectly return
  MF_RECOVERED.
- The caller then treats MF_RECOVERED as a success condition, masking the
  issue.

The previous patch relays MF_DELAYED to the caller of
truncate_error_folio() before any logging, so returning MF_DELAYED from
shmem_error_remove_folio() will retain the original behavior of not
adding any logs.

The return value of truncate_error_folio() is consumed in action_result(),
which treats MF_DELAYED the same way as MF_RECOVERED, hence action_result()
also returns the same thing after this change.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 774f4b18ff5c..d6f94786e709 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5136,7 +5136,7 @@ static void __init shmem_destroy_inodecache(void)
 static int shmem_error_remove_folio(struct address_space *mapping,
 				   struct folio *folio)
 {
-	return 0;
+	return MF_DELAYED;
 }
 
 static const struct address_space_operations shmem_aops = {

-- 
2.55.0.1082.g2b9226bbc0-goog


