Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBF1C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9606B008C; Wed, 26 Aug 2026 05:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88ADA6B0095; Wed, 26 Aug 2026 05:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79D816B008C; Wed, 26 Aug 2026 05:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5211C6B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D347212018F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:13 +0000 (UTC)
X-FDA: 85142869266.26.9935D13
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf25.hostedemail.com (Postfix) with ESMTP id 00680A0006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OIop7ZpE;
	spf=pass (imf25.hostedemail.com: domain of 3Uq-OagsKCEcjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Uq-OagsKCEcjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735892;
	b=C+jqEy730Ih9r0DzewOV70mbhHN1w/y3pW028ttlz0oafyTLLyUshG5bxtlW8CXPY/W9FL
	OEXTD1WwHrBRtlVM2qbjU84XJJTLgMQvICaXJG0bkMU+5TAf63FSvR83zGfHuIOG7cEwoA
	7ZTQPszaS7qTmVwr4i6YDO+K15trt14=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OIop7ZpE;
	spf=pass (imf25.hostedemail.com: domain of 3Uq-OagsKCEcjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Uq-OagsKCEcjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XDSSI9/m82E8oEwBtVX/wDbyuOojUfBfVTSxkje5Co=;
	b=J83PynziYl+EPn4wuHQBkz6FHNhZZ7xp32z4oVU3DYGEwEyR65Fc/22zbx7aam+h7eVTn+
	Te7uCIjEwdJqk9zJlvAqi6YbxnXTdGwIJRdgEoNt+xpWJfs+XuU/dPObpEA1s1Hr9K5GRB
	6ZMyLETETKqK3sY02DvrJv434wcY5L4=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfa55c9430so9735395ad.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735891; x=1788340691; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8XDSSI9/m82E8oEwBtVX/wDbyuOojUfBfVTSxkje5Co=;
        b=OIop7ZpEU98pixe3CRkKHoVKd7LNc2hklVpx44Lcy0u1hPistgJT6+CRvnYZ8OM/mc
         LJ6++IZQ3e6v4zODQGWs6mBk8ajFzfarXN/XrGbT3bthHkSbpuNddE81/sBv3CGqmiXS
         KN/obAIeYT/QbykOT6AZGBq9pyH80IVSie43hMYAtuthxlMpJS92RSXdAeaIkXfDurUC
         NtPPSdGEBMgaggC654wjyhm2SgRy8rs/ukf7hXy8BqeaGFt93z6IerHabhyj+Prl1aNV
         rBe6gCh0MzyG6luPse3kzbXyeaIwcZa0sFkLDXrWDTunXMYUDPnc+zZDlMGBs5BcwaAQ
         NxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735891; x=1788340691;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8XDSSI9/m82E8oEwBtVX/wDbyuOojUfBfVTSxkje5Co=;
        b=T1zZQ+m0A7Xj05dqKOJt1tBcTSYCpdbNFfZ3xYfwb6b7qQaN3rypwP51vCGkKBea42
         VVTFuURy3MLjmsqmTpcrIDzMV4HvUMXUfFpnVVnDFqZo6nNh1rJDZ8BK44HDmKz5RSKl
         1xlhUGyzc9GJuE9yqzciGDTNP/HpsA17kDSJNgZBIblPwPAtTtMrz3Xcs+zE3e33aHFT
         Vejx3wFKMpSD7TjuSSSHQLMSUg7lMQ5ae0iPBnrE3pH40dFsrOmQQnfxanJb2xqoXEhB
         W+kZ+/qlWb9YPsJP0LKy4yjG+nunGkhvbUuAXwxA0PDRE33UwxdT8VkZgYk27TyZzPNQ
         hokg==
X-Forwarded-Encrypted: i=1; AHgh+RraGzq2Y+QdMFj4S+EH5ReZdDs0l6LUe6UH88berXG0ZwK2sRWZyOe1DgxgREhS45HEIzX6tfs24g==@kvack.org
X-Gm-Message-State: AFuF++kEIstwT8p481MvdOGGbeYs6594Q7C+YqxdrI2wWnnCtwIO6BG4
	7TksLtu2bNWXURaLcdgzZshifjZC+aysDpi9pBptWDeMB7aPajAfz7Ykm+GcGrd8UovwIGVL+Qw
	niMzgsIBf3xCcwEKSiUx3tMtKLw==
X-Received: from pldb5.prod.google.com ([2002:a17:902:ed05:b0:2cf:b7f5:bad5])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f70f:b0:2bf:7b62:a038 with SMTP id d9443c01a7336-2d707b7f68emr92673465ad.9.1787735890408;
 Wed, 26 Aug 2026 02:18:10 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:00 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=1236;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=x4GiehEvwthbo+pCvL6V9adeW5xOS5C7xTsIhL+6Zek=; b=s+IQgM8B+Ybq43NAJgLoaKZkS9bVwFm6R6sUMh7Ta7t1ZqeXaVdBjvNLlZzPswTgV7Us8uM7H
 f7uNAG5zSptDljo14pDwFoYLa2yBFAGT9eOULI9I1qN+OBHVWQBkK3T
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-2-0a15d8a799aa@google.com>
Subject: [PATCH v11 02/46] KVM: guest_memfd: Use kvm_mem_is_private() when
 populating guest_memfd memory
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 00680A0006
X-Stat-Signature: 9xfgqeens91r668xzyp77dxeg4gh9otj
X-HE-Tag: 1787735891-353233
X-HE-Meta: U2FsdGVkX19barm2GfbyB+wp12qvWLInoAeTy0RfG9ODdaPiboZ14M2PtkAnX64s56jL9JuxyNPqV7A0V1GcgCn5Zz22ELcPKnbIIvI639nNP1Hj6CXA7UyrBhEQPHCFRmiXC9Nh43iUu4bH3gbw50umg0pbwuUYYr7QKg3a0Tx0JbJOYHmjD699/c+83kP8m7l3UPJZfqNK8KGahNAVV4LhYRuAL+atfYKFMQqpZk/UfAYdO7Fg+DqAO5XZEzdyODy6GAYZ4jaKrVP1vMD7ksKccXxTMC82rDYROovLaVs6B1pieSSqu932ygD0OhVGZDoUoOUuTnHj9ek3UM8pIlblJ3VMDQpNwlETZsf7MjYMikxxHi9FyPR8H2+e9OIAwh+gbYULtqWNYBEro0hALAG51EVVEQMsruqHMqKkPRCb8+EvzeZP9WzCqCnj+dqLQcmEyeTU1rM9SWeyP8rUjCb0oXyZ7ituwisxC5CP7yxyQ4KwiVo2rNCgL2lem1rGaVhfkpMDEPGZlVL8etmfW3DdMNcLobRh+aMesrcr2s+/xvxNTHdBl5NP22cCm4WV5MWc7R4j+UbovOYeDwdu7/2rtf7iyWO+AHN2vbK4cRLvlLpUf8scXImWqlaBO3awbuFvGyu9Tj9ihWeb2utwaibC89wCVDEhXMJxu+Rm8MzwDbInYHgq5mREiVN5uAeqWh2BRYhzSnZX9l13PvKnH8cOQ10gwoYGgohs07bhUIywJG+QbkWJY9aZ3c2Bzie8C9O75Bls77DigezZAu225mnGxifRzikaK/kWMCb8I8Gs72PrGBaOmyv+ScU69Fta5/Ailph92JExxPo6WhpMzfrNgXlr/3/Nfb5a3XzU5N26BZJ9qLEaBu4PvSVIvD7RNTtxNZPDWQWBEclv8+TlfJOZuVYKr0H0/hn0ggUwAaJKjAbla1mpQBkMvADGgP6VHn/zfaEYSTCActiTx9Z
 jc8tol3g
 Y1sOsOKeg4Bwxqrqv2i49N40iOpEwDrp68Lw1MOBBVk2PWtB+XbDzwYLEO1N5YBnnw/JUkm54iltrLablKa3wK9o0tlxMlFYA3CwzTxE46+PuVzjyKh0yQMjIWF8RR64CggYnhgJUVkh5qnJppSD4kwuIo0TsJAJRCx4cey/sOrysopA2ok1z/Jkza9Zj+wA2nJl/4QHJKxFKIt5e7GFUzFQcqWYzC4/UplwHKtwT6faZj/TKlb4FVcEr0UahWjoxFDvRtgWcXeiAcbC0/LaLnDW9osxROS8wnH5Y7PiwF9fIBbUUC1ijLRsZuhw/mLywlQTYoPOS4chTft2Q1I/F/64nvm6gfNqXnulhRgnB8teBzDjJgo7UyNBE077UzgALiZQOGmKebvGs0sJ/0cYI/kfBDbyGPLdjqaKFa5lnJaDGJEwsROTc6LR+v6zJUVEh44TfSAB+oIZzYph5CBPhFVgj7NlKWLF88JLcmUmvLa2YABgnUlL+Sgvu9u28XYoo5oLdg5jOzFrvVJcEZ295DqMTFHQVbXJZM8rQLn06CWElVs/Evg9SsPZFjox9Xr/m/BC+abtJu6+4dINsIHaSkCZ18W0pVwAJH1T5GFIf+8xj129h+744F14/Ioav/UnYVFYoqjLGycwaujtbgoZ51oeZ4DduBWYOy84XFUI9N6ow9YrCUcqlBmD3bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Use kvm_mem_is_private() when populating guest_memfd instead of using an
open coded equivalent.  In addition to simplifying the populate code *now*,
this avoids the need to provide a range-based gmem lookup API in the future
as well.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8f8e5b6b70134..2c5857a73ec94 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -805,9 +805,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+	if (!kvm_mem_is_private(kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}

-- 
2.55.0.887.g758fc8c411-goog


