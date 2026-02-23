Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BC15E98DF0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124F36B0095; Mon, 23 Feb 2026 02:05:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C54D6B0096; Mon, 23 Feb 2026 02:05:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1DEA6B0098; Mon, 23 Feb 2026 02:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA4EE6B0095
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:05:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 762261C2B7
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:05:02 +0000 (UTC)
X-FDA: 84474834444.15.3EDB29C
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id BBF81C0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:05:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kccQBUf2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3G_ybaQsKCNY24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3G_ybaQsKCNY24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771830300; a=rsa-sha256;
	cv=none;
	b=H/nCH3agjVW/ULuqx51FUiVo8+639kj1EMsZ4h8pRd5vKQhiQaYyTfLWjogpWEhfnLsuCu
	Tja1sDtG5I54PSjMaUi4WSwk0rfebhGgSee9EQNsV/MfGfcE8mUQhe9AYm4Zn3t1aNzs+k
	kDLMEJheq6UuyLwB84pIba3SCCMLjJY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kccQBUf2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3G_ybaQsKCNY24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3G_ybaQsKCNY24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771830300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8EPkBYTIogg/WcIy2FNnZriREPEXUqsGjhG96y07ko=;
	b=FmEI0eGW9S1rqmc7t8425bC2wsnyuus+gtP2Ce9eSqEkxUdKxzqCYYq3aJHaY/wAAD7BUq
	xnsTMt2uD/exMCCkoCRWDdTZ0O8HqbKkgwx4Q9LzNA3ncARThylxaatnnDfFYk9mnIKL+j
	5Ugzd8z/Ku0jQwuft3V3sbo48OU1trI=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a77040ede0so48548115ad.2
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830300; x=1772435100; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8EPkBYTIogg/WcIy2FNnZriREPEXUqsGjhG96y07ko=;
        b=kccQBUf24OOLN/o/duH6++GZo1A8Kl7GeAgzz/LwfMPP/dg/yYjpvL8cvXCLqmWLCl
         gX7ZCMfIhFfOr6qSwfWbQPM9VTNZISGnHrmpu5XyhPp2dbFVOnnc0IkAXRt7E1by/7ax
         9tqhIrD1y0kcb5eMgFOnCrSWOpiRfRAgLL6pAKH7tXVoZ/j4n43xx6cvCLqusD42vHqU
         yiJ36PUSII2/57KPod9LbRpSI5d4fu/FLG/dfX59BR5gQferNbT2xC4V2IlC3OS/hIq4
         k4dqRA6n63CCEjO9Y7Ex5RNIFidVYwv8jBP6nh04MblsKDwHr2kXLiJzphc9eBUK5D/r
         FKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830300; x=1772435100;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W8EPkBYTIogg/WcIy2FNnZriREPEXUqsGjhG96y07ko=;
        b=rcPiDWxZ4tisjEBpT9q+U6+7xcuehCE0Oh9VH0/zbI4DLX7Cskff+vMJNWekNzJo05
         xqr3ABthGshLlbr5kfz1DUcPQqfpbOwPHnnqPAZOCjmnvBHwJRKnUaQChX+A1o6CxUS3
         MzppBODk/ZPryXp/k8xWaZn3D9EvZXg1HQzHRoXHJxnfiWq8zG+W5li6RiZ/JuPOg+in
         Jhqs6HwkFmZHnPWnPE0NvLa1xXbjTb4Q2t8s8sAHe/pNwMj4Zbsabub8JH8PVbWkz5XG
         6VOGi/aG75wH18lJH+eDd+YxxKkQyEGHMPqNdnQkHTZKOKp/ggB3FoHFtPja5+aGLr9+
         0qmg==
X-Gm-Message-State: AOJu0YyZqmsjeTi94u8zuNugnDnMg30lBypJIwEzht5MO5Q3hHF+lIIh
	C6v67M/pA7uO065T0Kqm9LsH3RF90whjs1G0QMDFktlFsdUKWvP+0ReoAy6ELnqzBjy5fpDvmTZ
	0PetyTcwQ1Vo8TURu7zXwgEOjUZQQ6pDbDELmo0Njo3jXdjojmz7R3T99cpCCTq3yEnz7Oi99b4
	i7QtCxDqzvY5ds2n9VCkO5210ll2cm8IcDlW+wMZHcsFEE0pSKgsXcyLqZYA==
X-Received: from pjbx30.prod.google.com ([2002:a17:90a:38a1:b0:356:3562:569c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:248:b0:2a0:a33f:3049 with SMTP id d9443c01a7336-2ad743fe006mr64180505ad.4.1771830299282;
 Sun, 22 Feb 2026 23:04:59 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:39 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <e08ed6869b9f555169476d220d7e8112e7163cee.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 06/10] mm: filemap: Export filemap_remove_folio()
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BBF81C0005
X-Stat-Signature: d6ddyz71pds3j19u1tzyquxa35rxr9gq
X-HE-Tag: 1771830300-625248
X-HE-Meta: U2FsdGVkX1/BU7kIBGKxtgvYcSR7rU1aKn0fAdYeiAA7dZt3ODBRVcmiHAeW5rLI6a+ARvfByIhsddERsU6j29rGlFh/UT2PQbxORb36zbjg63N+5wP6ByprJPeNZRJjzX5ugzYi85xk7EdCMgasIsRxA9KhEew6efB91CIEQTqwc063Eac4peOpY37IITs0+ZoSyT+ZqJyPFLD7ivt8mBn6QXcWIOiYxUp2+c/YDFqnoANLHof8A5pjKhYjvGdrjo20bkiSCAU+FEsfiElroxGCFluAlncjUl0XXcHadWZcQ49Nb3uNplVkA38ZMVILiYglJDxbL/feLn1KzUJBwYa0h8if8lADtmcOK7i+JKZ+wD6sXxgjuKwooCrsolbvEeG9u6PS+iAqCUKAq59vgMg56BBXc6l/PpX8O47njagHKBWpxWy3BK/I0pwr3UMwSUMqZJ2/Y4PhyvVa6Wp1BMP9kemzpKxJ0VVdkyWYAUb1x59mKHzpzHSyPeLaocDhDuubwUhSCGYiXADy9YiqCj1G5wvyTm6zbXZRJQhDl90VckFGUJq+FDB/BOTAj57IjWH6WmlJ26yIO4rdU7F0B+TP+voSlfNg9D17JrLBKpHcM8cm94q6kucpkH+RetziVtZl8BC+slyUR1kOS7vz+wQgzBTuM5uAxYualBCO4kU/J75eCPYJX52EItYfvPNp4xuA0liMlmMFdW9Gl5QPVa1QNfQdfU3cTPeI/bWeLysF9ZZ8mPKtJzLtilZVm2Ks1ly4Ons/hSYYEYSV+taoIbCgF7V5HqxlQS8ETiB4sIBCykbIX8gkic9YzSA16KbxbC3STB2NvGfqOwHs+ye13lwuHuxr0pIPl28Pe3nKl4lEVz5ZB5KNNyaQ6Ba9/r1Mqm2mkvoUxtJI1Hg+CW5n8Ev7FKH+RDzRbru+3roChDG21LJthdtQft+MaK/6UHwVEdFn/unDYp8Radbc3mG
 VAsrnSIc
 tOhghD7TtjVrZfQlJaIot+T5/3qRkd+ql9HSTzBR9lBbrPCZWGD+gLuOaHin2JC59aaAgTROiy+7jSjjO5GkqCo/Vophq70uKwXOSPFij3rFDzJ5/p6xGBm+u5NWeBy5oztZo20p2Vc8piitxhz7R3a30Wt6MI6KTl9ySNp8oEHzOA71tu3r0kIJ9R45bXGo4OoGZRMGaOX9uKtvUXu9vQmvUL4Fyhhebtdi6wjmVYYI4o+xJvVqWJGT1YrZEn8z1Q1WqeAf9wdkVgKcK0Shz+0hBISBCv0OTXaAgTixb5g0yQDk0sOXTUnlO9TGMYASIQwET7vJmQafFr67bnFIXN7QtQjKNMkDq/C6xtaykZV3cVwUy5kugu6MX8ROhDiBpDO+wUKZrO5ZVOyWgM/J+ecKQbnufy7r1R9790jSOnAAJ0wgH6a5vy3UoYpaoHMVi2WCFS28AYolkaFAte7tje1G3VkDrDflUFOyMsoW0sp/4LagX+3+PbVO9M32YnwAjAUtkirQJK5MuNSYGsdX+6ZRBvYdPpxaaGMiHha6aSXGp5fOKOoQJWYEVCTBlbpCieJ4xj3XgLODFRQC3QzuFRieKBM2yN/n/VT+4sFhVvS5kmL82nsw5XlnB+BGWTJYxQQzsdxgZQra1e99rnPZTVuwqrQnHl/W/WzhE2+1Yhoef5QJvnANJxVRRMBqMQk/Hrudm3ylVU6uMC75v27mRoci5Ep9G+ScwkFJm1E590dofgqhPwcyJjltawA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Export filemap_remove_folio() for use by KVM.

KVM requires this function to remove folios from guest_memfd's filemap.

guest_memfd used to rely on higher-level, exported truncation functions. To
track memory that is actually allocated (i.e. i_blocks, st_blocks),
guest_memfd will need a custom truncation function to do accounting cleanup
and will be using filemap_remove_folio() for truncation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/filemap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index ebd75684cb0a7..379d62239fc5f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -49,6 +49,7 @@
 #include <linux/sched/mm.h>
 #include <linux/sysctl.h>
 #include <linux/pgalloc.h>
+#include <linux/kvm_types.h>
 
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -262,6 +263,7 @@ void filemap_remove_folio(struct folio *folio)
 
 	filemap_free_folio(mapping, folio);
 }
+EXPORT_SYMBOL_FOR_KVM(filemap_remove_folio);
 
 /*
  * page_cache_delete_batch - delete several folios from page cache
-- 
2.53.0.345.g96ddfc5eaa-goog


