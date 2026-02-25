Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3B4AF357DA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421536B008C; Wed, 25 Feb 2026 02:20:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBFF6B0092; Wed, 25 Feb 2026 02:20:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321FD6B0093; Wed, 25 Feb 2026 02:20:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0CEF36B008C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:20:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA3431A03FB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:49 +0000 (UTC)
X-FDA: 84482131818.13.CCCD84F
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id B7E21180008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dNmoPCpV;
	spf=pass (imf16.hostedemail.com: domain of 3zqKeaQsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3zqKeaQsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772004048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxvzdHDHaSHLdjnOnYt7Pz8oF0XFcbFcMtFEzYFn1AQ=;
	b=nq4PKtr0xvhbXZ2I7pzsS5tkUkC0ZytRLOxNdmgzUPh2/7PJ6MJ4ierGfDYOrJ014DPqAu
	1sGahEptoveqQjd5y1A95gcLNL4e7a+tTs9S6LH78rvMMSeCCaaYINacumMEZ5Xjmzlq1X
	lMMVDpkvPVFIgDUdx2t01HSMKwZYco8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dNmoPCpV;
	spf=pass (imf16.hostedemail.com: domain of 3zqKeaQsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3zqKeaQsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772004048; a=rsa-sha256;
	cv=none;
	b=CnssaBc6h40LPG4CteGPx7Rnywilc7N0+Xehwbbi7cZ4vD8cuDg4LrWnNmFEcekHB/1jcS
	OIEwJTJKP1ou2xwKWtjLSKkPW5B+eiZ/tpk2Fzk4Oz4dyc+dMk/FvrA9js1wZJmIo1UX94
	zFcti13MZIFQ/9gaPMtROz1XGYicRnw=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aaf0dbd073so77078115ad.3
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772004046; x=1772608846; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RxvzdHDHaSHLdjnOnYt7Pz8oF0XFcbFcMtFEzYFn1AQ=;
        b=dNmoPCpVgE+9Ma//EDbICkYTMwlBenH7mSihlDfOTBXQMA0Y+g54MILwGu08qEC3X+
         npNprRyTL3OYYhPgSTOa96LBESr4uUI3exYn4ZIGSyeHl9eAfcit65kWPcCYPf7tnnLk
         bcKR5UNJdQxU9cAquSeK1vUepU3Q6eg8k/YlHcdjd1+SioCxg/CSCnny2jpiAMDsF6GS
         aSxSO0gG3LshUt6cHadN2cYYCZHYeqVwI3RTUg38LEL8w7TYgg5BXSTzmohqjmZdphYb
         f8fS2Jou10TfXL8erremqmuBwhIK6CkMU6uJYhpHNZCKfq1wHDBsZQQjjS0/z5EixG3F
         4yCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772004046; x=1772608846;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RxvzdHDHaSHLdjnOnYt7Pz8oF0XFcbFcMtFEzYFn1AQ=;
        b=f/GHyfj456V+1c/XlRBSMFcy0tFHhxKUOc68HrI9E8ZtTLDR+IatNWAU+6RIEfZhZb
         SYExzbWFcp8ej04FpP4Zm4AEMzHy3QTQ7iJnsBvb5OV+lJ4OLTFz7W7nTejGxTcCCh+I
         13QKhWHwyMbaIk1V/cv+FLylXngyUSplo+GX34e0HgtRJxO7p20UQcj9G8XzKLZT3lNS
         kNXMM7/2oya81JNUOG8US+OlTs6Hcztgp/slPhZ5Kq/MZJGyOmtcDpG1hcMvJz2VICn/
         uFTGNVWV4m5N7vunSXJvXVRf73bXLJ3e4QrLvcTs6V91aYFvhHZq1JfnlsMR6Fc6K9ZC
         ljwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVQ7zoIKM/6pgqcSq6qx+TvxCl2Au0ZlkgzdPe1ru5jfQe6NdGecQS5694wYKmuX7uxGnRkjNVog==@kvack.org
X-Gm-Message-State: AOJu0YxgrhKrisD1nrK+eQyROZvRojUK07p3w6mwUiVdYEuqGheVPY8a
	i0l5K0iNUpWkmJW/cTJgVyPQdWKSabIRJess3AnD6BSFNx9TI8xrWCvdD8+O7iq5UWm/puVdGqU
	uvimuaoAqYf+8aZLsJnN50LCPXA==
X-Received: from pjbjs14.prod.google.com ([2002:a17:90b:148e:b0:358:df96:881])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:2982:b0:35d:53dc:cb61 with SMTP id adf61e73a8af0-39545ed4ecbmr13199551637.24.1772004046254;
 Tue, 24 Feb 2026 23:20:46 -0800 (PST)
Date: Wed, 25 Feb 2026 07:20:36 +0000
In-Reply-To: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
Mime-Version: 1.0
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772004043; l=1374;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ZMQPV7Y8H88+MGQYlAsk4qj1ohZaV8k9fkkraEOtToU=; b=UnVR/uLYP7ieBpWEAadpA6sROUIT4SgE39FHR7vRTz9HvHgkz8Qjcpq+AL3FU4w88yU1gGUOS
 sJFEPjg87ZGArJKumnOvSjc+SZz2h+qBgaWpg2xkrvCz9aXcDFKM56w
X-Mailer: b4 0.14.3
Message-ID: <20260225-gmem-st-blocks-v2-1-87d7098119a9@google.com>
Subject: [PATCH RFC v2 1/6] KVM: guest_memfd: Don't set FGP_ACCESSED when
 getting folios
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B7E21180008
X-Stat-Signature: i87pekq3xnqf19n8irnb3b31q3e1hh8k
X-Rspam-User: 
X-HE-Tag: 1772004047-201198
X-HE-Meta: U2FsdGVkX1/RrknYG0dMAc4/rWnyfSo4OrS76rqEe+0Eni2nZ6iCIXi9k4TGM5ErvNV/2hwch9EPI9rv8uNPD9CY8BepiTtBbspR7aq5R0oroNVpaZ6OqGvUOVEePB0ui2bA7KuV/Dn47LUTpIT5giIay6tA9eDUhCO1sSqqdjcL93DjnYhoj4d0exuRfSJTiRHVjQbGOkJaj3O2VI61wNmy71xT7FT0dMNT4TVj/mMp1W9cy7GAG8w52A4QFdGgpXwsjucwkHJAQjjNYHFEvlv/DEUQi6es77lHNOgCdb/ZM0qACVYsz7Zi4piyxnTtpZeE8SZ3wvZIy0vRyNtX7WhXQsrg5btxqcM0zo9xx/NeRtCPTRDRooNbxdoNkcSvhvuvrCbq65E7bSIrrabHVSO0iyxQ8EJ7WyNK2FbiGklo3prZLnXeS7AI2o4SA+gJ0uBzwhsDbZN+dyUSksMSB83SpB0dFMikv9DSEDs1nErRUsr0fiGLQ9SXbaMcdwEtqXc8hvgKrZ0PWkeLIL/gYmMtZZS1codzX+udgHq+c8fAmUTJJAAUIbAEns9wptauE+LbNWtX4XU9EdlH24szOJ1j1Xx2z3ZKCyFXPF6Bnm20NZv1uYRz8fD8D8eLs9GHYU6jPXptXVq33QetFXEVf83JNM7vv1w5jDnt1hkaIv4nZfkA6RVrx7uFI0qkf7ugjne4pd98R8kI0lZ45yKJkNXckCpUO2AQ/aS34dx/cVVWGgcQrDs7Zy6AEe0TC3ewfnCBMyVyqIVT4sveZf3oXbwDSuPjCcNytI+QHgBFUBj5ToYAxeqRp4pCB26Uj1tz24Ey7UxokwECK7PUye1845aVuLliDEjIuSnzbLd5d4I8U6b4JoE0UnAn82XWWVzcXEjZ4hwc9UdLXQ4Lx7+6P3p5EOgrinonDSbnWbkXBNVgk43Tk8BARaydVSLmC9OoWnhgKN4e0IneKxDdVei
 cfZFMgUE
 BC1F0zfecWg/WhExMOQVPxtI8y0v0UkS+vaWO12uavf4glk2cVk9uR+Ts7LHnmIWS6uKuUZdn0UbV6yazvOvHOKrZqv04jBOOp9aUld3f+zLDahzBBAcYp4AOY5RIt0jUnlyXux/al8UBW8a21lJbAlEtRvQuISC3InNTe6Au+BDeXcFsLiiR1CuvfJdJOVfDR8UiKw+8gNZ8bTPYz158x3WjNM/AydZ8zWwmOMyrrudtQUfa/GWoFmMM4rsAcnVLOFy9B2gUHgzTpWASLXEfGchzm7a1qoIRWpDShsFDjyfe6VrJ9aeWmojzur2jhKZt23KigthOci3bzy9tHN/EMz3yjhslO0c1r1dMCEkPH/gbKWpqVwiKVlDmV13DI27EuS78qi3ttIFCJjZVfoG6AtOlMMFIctm9UsBav8Zoy3aR0tQXWckPdARqt37yPKVyJxM9DDmYykWDNHST4yf1exekSEOL7hfpTepyvSGM1infAL4DWdMD17TGc22HzkfEGQ9gE1yqbcnCJrw8Z17JmqAk8lSQYLClJddM/MGvJQPSjATnIH44QKiNY13Ek5c/DaQetizAQyoErZhEKesH8woPyHqQwKPHvDaCu8sOGOHixfgUw76RzzGCFkRyLgnOVELqvCktPUxH0e8S1cR4CaHM9DfH28SnStPCYMaAjxUdLQ3dc0oLn1z1dFQBzvMcmNk+8rK1WZFMtp1NxrbApSK0FkFXpOX+TfDHysHau8Qo9d4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd folios don't care about accessed flags since the memory is
unevictable and there is no storage to write back to, hence, cleanup the
allocation path by not setting FGP_ACCESSED.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
---
 virt/kvm/guest_memfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 923c51a3a5256..2df27b6443115 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -126,14 +126,13 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-				    FGP_LOCK | FGP_ACCESSED, 0);
+	folio = filemap_lock_folio(inode->i_mapping, index);
 	if (!IS_ERR(folio))
 		return folio;
 
 	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
 	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					 FGP_LOCK | FGP_CREAT,
 					 mapping_gfp_mask(inode->i_mapping), policy);
 	mpol_cond_put(policy);
 

-- 
2.53.0.414.gf7e9f6c205-goog


