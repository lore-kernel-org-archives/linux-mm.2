Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D425D46C1D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 00:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0586B0089; Fri, 30 Jan 2026 19:15:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69BA76B008A; Fri, 30 Jan 2026 19:15:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DEA6B008C; Fri, 30 Jan 2026 19:15:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5F26B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 19:15:49 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBC4914021F
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:15:48 +0000 (UTC)
X-FDA: 84390340776.23.A2D7931
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id 19CBA20003
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:15:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WEi4EAsL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3sUl9aQsKCIwqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3sUl9aQsKCIwqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769818547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tie1ca0WqdbWncjWD6Fm6z7ENfJLpUk05Sjlx+K86FM=;
	b=6FPsNzK5a1naQ8uGuWxk/q0o5BGZbfblRQNOADq/gLlWk+75ZYnTwXe4FS0mxAtDLvB2R7
	JiYhNjZf6iEZYuGB4yZjo7+uezXjSxCx/bFq2nNvhwLXKwKZ9MS2Mzo4lQaeKlQmLsRj9W
	Af07XrBn6goKhl98tRKRVpoQNrPpj3E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769818547; a=rsa-sha256;
	cv=none;
	b=ZTqgd+/595SbLRlwVKbBexyNSpShC0iH1eLgVMzNL13o5ckW/w5Rj6ccOxugUWioXH/Cgy
	JNXoL1NhwHMOxP24XSs++VVVujQY2BLYEhu8thTCMg7zCPelcDTS37+TYQku0Oei9vUU2J
	Hm+Vg7JQP7HD7u5kzKYURAg/fspyMa4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WEi4EAsL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3sUl9aQsKCIwqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3sUl9aQsKCIwqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0f47c0e60so61656295ad.3
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769818546; x=1770423346; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tie1ca0WqdbWncjWD6Fm6z7ENfJLpUk05Sjlx+K86FM=;
        b=WEi4EAsLoURQS03/XDP4p6EWJCCAQwYh4ECa0P0AnZFGovDr0z6BIxuBVbjBgbcYSK
         M/wAvXalU6WEr86+YycC+3YV4/wuuPJ0Ug9z7OAMZJ+YL6ipPfFCaC2236ML0xQoHdoS
         huz5oGhIXCyNQ+9Pxcn+mp/lA9PaEnWE1RZLoKvZB2H/Aonyp1yb5AcE3D2witS7cAis
         eTuSO0vOya4g9WZMQQGP0Gbo9oMkVtUmj+Z8JdqrNqUpBuUucwVCaT3eonlWbbqzV9if
         CeQIR9fG8TVKmg2+E97NTxGq6Z5rE9qMyDZryXhSdRqf2z+T2rJyhsw7k8wt0WxcvmVm
         w9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769818546; x=1770423346;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tie1ca0WqdbWncjWD6Fm6z7ENfJLpUk05Sjlx+K86FM=;
        b=haNyl72K8aacqKZec8ZP4QM+PBveqEhWQmoxeFL0D3gxYDfDenljDQYf0ew54NJe71
         Y4UgWVdDyKpCyJLmcg84Oqa5YBsoa81Ut/j2BqXCnD11za2YZA4fvNXIuc7YFo78CfZM
         bc0mLTnTMktQMYykNZkGlefo+4exX142R8cZDxIvO62K8x0di6CZFDWpyfeutiC4NakY
         p3nU4YN5piULxlkYuqX0ZEVKd3izJtemCG1y9z50nJ9damxLNK7KyIXCvdnhpGplYMVv
         rYjtGRFBhC58XwmqiuPxPrMUkdiS71/pZ/1h86/thdPtvQBRxKzX40zdca2MRFU3zhZq
         tS2w==
X-Forwarded-Encrypted: i=1; AJvYcCXYdGLFkgkGzhPGN3VhVNQMAYChERGV01R8/xBMl+mp4VCOs4etdVkO53/HsVJL4aVrvgY5stuXrg==@kvack.org
X-Gm-Message-State: AOJu0Yxm4Szhm9RLmBQg94eSojjNJ86ZNsxNikSeM/KGiOdiIYcvKGmb
	cBC1n/mDC1P3DJ61Tl0/wfsbdEdk23DedcnWt283XZWTMh06uhbKoeps9wnvFaklrCK4jfvL37P
	oivKHIaUWOIo72KPwWM8a2Y5pwQ==
X-Received: from plrd9.prod.google.com ([2002:a17:902:aa89:b0:2a3:e79c:6cfb])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:124c:b0:2a0:de4f:ca7 with SMTP id d9443c01a7336-2a8d959c1e8mr47669015ad.1.1769818545853;
 Fri, 30 Jan 2026 16:15:45 -0800 (PST)
Date: Fri, 30 Jan 2026 16:15:36 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <cover.1769817142.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 0/2] Fix storing in XArray check_split tests
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@redhat.com, michael.roth@amd.com, dev.jain@arm.com, 
	vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 19CBA20003
X-Stat-Signature: uo8ha1e6fqf1cnpiu889xmagrs5rjog6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769818546-837833
X-HE-Meta: U2FsdGVkX19JF0wUiasGl0F5uY9v8aGZv8ftMPJN1bsvIa9dg1BDw4nrLeovdVA+TsjP+IjfhZMUTsKQP/tjjj2miHIJtMTaGO590KXgRTaI1Pt3TpnqFyuekEG1uJqu8afIsqytCm2n6PLZxu8C08xFTP6BI+ApWY08lJIsGytBq5+8902LoHiCv6QtLDaI3cyhtSTwt+1ff1mC5PK5c9VwEFMUk/CDn3MnhEKoFnBD0fk3PVsKZcDKMaEoNK8wzac+zJ2njUBSAHZD50nZh4B7HjXakbTyk6QMqYFJgOxonk3+3XhrSlRJcoLLrkQtyJp3pFP908Hm2JX/6lgQAxjvtztwUNlXc+pBLX+Hl3Sw05w4Tb1iqpSo80JWV5Y6KutjUTb29SbWU/ybtJujrmS+stg0yCSCwwaWmlWKLQzj992/Ez3g/Sy/ZhmHqNRvm4MVAShwiqP6xM1S8sQfa3t1YruSHrMGNLfsO7WR/wycaolSIYlByMgOq7wRCG0vfF9wkj9LXLRFTTgoagufZU8wmHPVevvKkArGGq//vkPMMjh+cL+mK1v+Z6iQ04X4a/U2Q5tZZ2GLgXJD0Ssf94KTb3xcRMzL1PULrRsiYCMtPmyVlzeYxiRmbvUDIKc0SH7yZSIkqa3lM+TRljeTgKbpahtF66gLkmVkwbiKKLUa1B2GRlEXqap2TPvCA4TovYrfJ7FhLOIeqckI8Nwxn92J0Ucx8VsXOFGhiAFvGC+Pn+EUuTdBewmGIOHQcUllQpzElu7ZYg9z9UK8pBdFrsVTEy6W0kMq49uShGWbOrx6YvUSn8Y6emVj7KquOBwStkHky73VJzawN2sLxlzwvQ/cpgU0G7lmbSXvYXH9AJlhW3Q6ogb26bxRPFLIbqeMO3eVM9KEC3LN8IUgiln+jX2QnrJOIOgpe3Pxn2+cJ1foKRckepflbd5FaBIBvMgxIPEWOz3Qb0lp3gYdSXK
 dhqjRjQw
 0IWFRek+QKfNjbCKe+UsFvaenwoC/cmgIHyuYxEnKj9Z9Ev+y2miNK9tYV7mdZ1iv1zbl56Xcj64XQPH4vTdaMrTb+SCOTOGMph4/CiWOKuiI0smlAMWWDQUeKtc4gMAkfgfejozz3fZBsW+ym/Uv2QZllzi37wu5m6VfRBDlSwnT3SuUOZuTSGUaKfZ0I4EyboezxtKKlQ7E1kJrjC1xhhARvYXRLCJMQzbTkH0kSkcwWmEuUTrwSCalH+9J4gxsfx/j4UB9xWYa3QWzFeZvuGwKWOszXQISPipUCX3u+2bKogB0NBMsdusOa3vmfWy1V76TpmTsjrkxhDfNc1LaZcKhr4oeb3lI3mwekbHWtkomkzmqCCCp4k5hyxbfEGtN/bfJNzWy0tJcDDARgbbTQ37F50K/rpUw+sShMRQGPpMQT/CXeIJGeinOAEzIkfB6Edu+BYSetojNbeK7fhxHBke0EXa4cxzgfbr+xyhwZK2/9uaxQ9Wy3D1OF2wz5uPOEhpyL2GI2oRyxJTmW7ZiYNvJUvV9cZGo45prWRmS7ml3ZI8ATYmVkyk8wU7al7qTHKsIg+Yq7uHxof+2nQCuYIbRLac6j5y2wUZD6aGTd+xlwBsVt82oI8uGtOFqKrpjk3apqBZdEIwXXsMEmrkviikwPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I hit an assertion while making some modifications to
lib/test_xarray.c [1] and I believe this is the fix.

In check_split, the tests split the XArray node and then store values
after the split to verify that splitting worked. While storing and
retrieval works as expected, the node's metadata, specifically
node->nr_values, is not updated correctly.

This led to the assertion being hit in [1], since the storing process
did not increment node->nr_values sufficiently, while the erasing
process assumed the fully-incremented node->nr_values state.

Would like to check my understanding on these:

1. In the multi-index xarray world, is node->nr_values definitely the
   total number of values *and siblings* in the node?

2. IIUC xas_store() has significantly different behavior when entry is
   NULL vs non-NULL: when entry is NULL, xas_store() does not make
   assumptions on the number of siblings and erases all the way till
   the next non-sibling entry. This sounds fair to me, but it's also
   kind of surprising that it is differently handled when entry is
   non-NULL, where xas_store() respects xas->xa_sibs.

3. If xas_store() is dependent on its caller to set up xas correctly
   (also sounds fair), then there are places where xas_store() is
   used, like replace_page_cache_folio() or
   migrate_huge_page_move_mapping(), where xas is set up assuming 0
   order pages. Are those buggy?

[1] https://lore.kernel.org/all/20251028223414.299268-1-ackerleytng@google.com/

Ackerley Tng (2):
  XArray tests: Fix check_split tests to store correctly
  XArray tests: Verify xa_erase behavior in check_split

 lib/test_xarray.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--
2.53.0.rc1.225.gd81095ad13-goog

