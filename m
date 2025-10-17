Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA12CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992AB8E0033; Fri, 17 Oct 2025 16:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FCD68E0006; Fri, 17 Oct 2025 16:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76DAD8E0033; Fri, 17 Oct 2025 16:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5282E8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FA511A02F7
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:45 +0000 (UTC)
X-FDA: 84008704290.17.D093427
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 697B6180007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1Buf2s0s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3OqPyaAsKCJk35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3OqPyaAsKCJk35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4k+wUXHe9yzfzIaac4y4gtWpxK47yZCE3hgs7ubdV9A=;
	b=xvKMo06nck2cvgoF3qNe2P+fQtUfTwXPBOwmg7AD50Gro426kj2ACPWAu8vqxFrZlFd71/
	Anx1bmkfOBdumAQAYkTEGWH6V7gFPb1lh6DP+Yitt7KERcBK6553y90cB5nbPMt7k9uPF3
	zWTmv7NyGtgaCxmpqgWVzS+BA0RNRYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731963; a=rsa-sha256;
	cv=none;
	b=fNPu19LIC9aRm11eTDq3aDDCp526tA10od502B5eKOKIZIgJFWvquu9t6xJGsRMMHRASYw
	D+fqy7E+dZYBGDCbvU8ZqzdfYLhP1XsSmdwoCCrQk+ip0QgsFa8Oz3vAMBmz/DnYup5jRN
	OVITNyB8dCbHQgAi9dtL8v+DKimJMMM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1Buf2s0s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3OqPyaAsKCJk35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3OqPyaAsKCJk35D7KE7RMG99HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bba464b08so1791726a91.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731962; x=1761336762; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4k+wUXHe9yzfzIaac4y4gtWpxK47yZCE3hgs7ubdV9A=;
        b=1Buf2s0sccZ4c4UxRN/UR5ZEHdQ7aVbF1mpVm37dwMpvh0+rHqFspUML+XHP5ORSkj
         AqN8Et/BFDMLXTMEYkfJZDork4TOwmmgTGCk3f6vdqd0y63EMNr8dYdQHc0k7Ren6q4f
         JWN/0qjbEbtLD/OK+4vZ88Tu/tJ5un1dj8X0bekDHYrR6SeZFFqgmnfPfeuKsHEGzu3U
         EVYp1Ib8vWXx6Qi9qk1SbBHo47Mh1JkK4IpmKcD9refETZtqic7fVOjiP1LZWuQzsRva
         u3OmOS0JgIEDPl0RDuU+jV4lPit/FbbVP2bgJBgXH1osYv0g/ekSwb8n+1KsLq62bpcx
         TUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731962; x=1761336762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4k+wUXHe9yzfzIaac4y4gtWpxK47yZCE3hgs7ubdV9A=;
        b=q7dTaXKhCdktmK+FfzMF6hX/m3YGXZueqxjLKDmE32/3vMMrL7QY+ZRrxHa1uJwEa3
         KlFdDfVovjnyb/nQOkL2Urxy9CGrI1H6GCnK5/0iAfBUXyucmMzWIzAPU7rum1fOJLon
         UqDCk1+TUyyeUoQ7DidladG7H3UbjCglgtcjwcBzibV/N5TLjztw+ek1x/CGld5jqySV
         LFzsfKwTD7/4ThR4y7aSayyydvPzmideWjj5rOurr9yAvVCKM0klIcvQi6TFLLV+SgLc
         670bKNpdwuZDmivmSlaEWGPv2U2OPHdtq7MhAjymkXDI0tVEHZ1Vz6OlEA406ONZ5Azs
         97iA==
X-Forwarded-Encrypted: i=1; AJvYcCV/b4madXbraly2BVf/oinxkA/ouPQu+xOAbIHbyMLUDqCzQVGMGCMQiXQ9ZIzlbp/bLCcavAKOAw==@kvack.org
X-Gm-Message-State: AOJu0YzkbsOOK4OUj0Wqpq62n3wTTktP6ipHDMOVRKGki7AEPLgXlzn5
	qvLh6uPgaU1Jxjypz1uO1oAmAVdsyVZv9+9CnG5XmKctwsWPc4HrLoiN5+jpRvQwIuDzmBBmqEY
	xoKgCDu4KJgPMRa2megGk3K51GA==
X-Google-Smtp-Source: AGHT+IGg5FDaopQnzU8E3MEM1vtMjI3mvE8ocZ5rZ8kLqVulK1tXCXVmLHJ4NfMXIzG1n1oaer7VJJObZU+ocU7zyg==
X-Received: from pjrv8.prod.google.com ([2002:a17:90a:bb88:b0:32e:b34b:92eb])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:48c8:b0:33b:ba55:f5dd with SMTP id 98e67ed59e1d1-33bcf93ab88mr4933500a91.37.1760731962171;
 Fri, 17 Oct 2025 13:12:42 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:49 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <dc5f58f5d3427b6291486a24061b6301761dda3d.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 08/37] KVM: guest_memfd: Don't set FGP_ACCESSED when
 getting folios
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 697B6180007
X-Rspamd-Server: rspam02
X-Stat-Signature: kca7zpsywhu3i1s3xecwjbbn93db3eos
X-HE-Tag: 1760731963-485820
X-HE-Meta: U2FsdGVkX1+KhxgvmVxgY6/pB7ah5/1Z4K53wcDsEcEWKxIh1sMZNjode8tTil94yOM/K5NDOpayFwsNHOyb2LMBbRJedNfmZCgK/HHkzvEOzqRDgUS8sUWzZGn2VsJyW+ZgrWFLpy9stUPlZDbWmJSMEbxXhrPSkEkNi+T9Zv9vYuxSX339CW3Ulv/Dojol6u0CIYUCfDMe+aWjNnaEF4z2d4QW3oWLqPme3btF9hQs8vuNDr+8pVc1PZ+wIN0YMLmr1GTbSJxhF0RwyTTuILoBCeHPsYyPKOhzSlt3lMpcPBkvf7vUYiB0wEHKstbyZOA9v4aq2nTrK4CMJtdeSHCg4V8qFH5y7JM1mzIynFVNmRN5A8PBQ/fJkLx2ZZVlO4TvFmu9lqiuTWZ3XID8D6lkdDmEbAs+knTZYCP8oxxyE1cM5fb5iwLXHAJvtyXXcHi369WsR1MhZtwYgaLyP044PxXgGeSoPsA6kpuLZ1fhfLpRW0zmh+X8/pATrNX8HYKXyqmOfbpRENnfqle0t+16Sei0xDQFedJsBcvgoHo50QVPcMEy6px2oPe3d8lCWzkHj5DHmhaoEgSQIHBDMJOqBLj3J3wBF07CvVnBtYaXb2q3tVf36ZkHPOc7fp7WeMrZ3fZ/Qkq8GaibGWqAtpP8YmznOGdlB2CjOGum16o3twtfYUvWXD0ay3Bk2zznBDJKZuSaIRxuzPgOCXQohBJp/PGrqm/3FQQlrSKhOpSJ8g+LR13yDIhSOYK7jSTysczSGW5N3J72f+ESTvodYiR3HZqv//ZKZVht31oW9q5FLH87u5+jiLM7ShjkNTKOMLl9xK3IZvppTSKMUr+yCp8zCS7pnERDXto3jbu70b6dh/NvezLcY9fovJOYvUEjNaGnFqELKzSsNsdB+VoLHsVx54K55NcX8j3HiHnOZjkZYMAxYk+d7T2k69chdoaN/0WRI6IlxHbrwLiQyA9
 QT9qyUTT
 akYT1DoaPcBy2i/KSILAqKdBXuEBQppekCTBTIV4AEDwR61UzLq2Ntbel5mDEbkivHoKfsXErXjkBF9FfDUUuJi/+na+x56//3gtpwV13dahdK+jzv3FL7N93s9GIxdcC75cVbkatKzuM63NAoM7qFjyJznhbcxtyFp+4WeJOXtaEN35gb5fFoVElASOIDrkVgoLn8JlAS/cymyvoHMbbuihEBJAxEgjSpZ1IxJu4DXaSIzgoSxGjM0e0ZFWGge72QstcqKsPd1zyOWAfgZ3h8cSvdsxeXs7L1NX3Y2LqJduec5NqJxQIYv4LZus3+kvepdmOoxt74HS9XT7urBLTg/QRaWFG+V2H3AufoQqtgGUYQ1Qvea/aIAXYwncGSFTsY6zxsVcQ24+Fon5IKrHfQAdDCKBPpLuLW3CSqbEdP7SzyqhjFLapxw2eEIsPQuFFnKYmxf7Q3RApIAV6FtNO0VGcAhv+8ojezJ2D4XHwWxgI6Gwo9jzUF3q1OvvpDJsn2OpUCkeaDB5iziKD+3bIp9UJ3X8LvtYzsV/M4EJx5gplyvwiFEjICfRNHy7BLPyG9nUlPpPSpsrHh1epQ+s2gu6AaFLsmIvM4QZYucCY20VGDNhSYMMIkmqpUr9Q+mDlU0/Zpy+XJqCkL/AsQqPJvhOLoH6OwOBR4HZdYiEMRgDt43o9yi3m7g6Vhrhp1fF4g1ymVSR0NMXYg60=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
[sean: split to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 855e682041311..2a9e9220a48aa 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -167,14 +167,13 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	 * Fast-path: See if folio is already present in mapping to avoid
 	 * policy_lookup.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-				    FGP_LOCK | FGP_ACCESSED, 0);
+	folio = filemap_lock_folio(inode->i_mapping, index);
 	if (!IS_ERR(folio))
 		return folio;
 
 	policy = kvm_gmem_get_folio_policy(GMEM_I(inode), index);
 	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					 FGP_LOCK | FGP_CREAT,
 					 mapping_gfp_mask(inode->i_mapping), policy);
 	mpol_cond_put(policy);
 
-- 
2.51.0.858.gf9c4a03a3a-goog


