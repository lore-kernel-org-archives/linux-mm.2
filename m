Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96894E98DEE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3348A6B0092; Mon, 23 Feb 2026 02:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26FE86B0093; Mon, 23 Feb 2026 02:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188B16B0095; Mon, 23 Feb 2026 02:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 038AD6B0092
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:05:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81B3F5B7C5
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:04:59 +0000 (UTC)
X-FDA: 84474834318.21.B5BF064
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id B8AD518000F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:04:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="JcVlY/Ky";
	spf=pass (imf16.hostedemail.com: domain of 3GPybaQsKCNMz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3GPybaQsKCNMz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771830297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9REamna2TtkXRPR+lDCH1E9Zwr056ciH8ECe5GsnKJE=;
	b=fRuiI/gAOzAbC57CNGaRf0kO9jWIMnBIzi0OfexC8BwK8fptOO52vUNiOhsTuKhQ+PDc16
	e40ekOFL/DbGMMtE5MZchfjeDYWd4wLizvpWKFl7t89Y0Q8QGke8unU4CZ98EYO4JrBflz
	QABDqKHD/f3SU2ATb8C4qsdjL8AGwmI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="JcVlY/Ky";
	spf=pass (imf16.hostedemail.com: domain of 3GPybaQsKCNMz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3GPybaQsKCNMz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771830297; a=rsa-sha256;
	cv=none;
	b=bkCPHSzxjnL3vpGfVnCCwZHJYZj4paIXm8emNNkYGDjvrY9HKdKLIxgokuLQgJ+2HZeDmw
	hfXxSqyrYq1OgdRolysU9P1pCPoKNRT4vtlYa+l+9V6xTb+CYrKN0zk9ySh4EdL1h+9HE2
	AoPwLO6Awr5cJW5c6YoUAV7+PVTiers=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aae3810558so46254605ad.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830296; x=1772435096; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9REamna2TtkXRPR+lDCH1E9Zwr056ciH8ECe5GsnKJE=;
        b=JcVlY/KyIUZyVn6udZTByFEw1C5kQdOjd2dhKnepQaYkRmgEQaDLm31y+C5MhUcFp6
         ftRk/Rmjh067XUZfkpMgmFgFXYlPeofVoTC+/kf0ceOB2IWbRJ49R6vxPwbQwVDJm14/
         dbQUZOck4tlJeiGm/6/hN43WcE9+tLwkOJiE04OCBEkUXCj9JmZWr7pGqlANBuGgCQSz
         1NsKrDdMBky+wD3X5YPvXhFDxRaQ9D6aVb44qAUOpb/wWAjY9uBhjEqaOpS7P6AQEnJT
         91JoxREKMT44yBq3OiwgCJysUmU5qtdwEK4rdg/ehnhUaMHPLvN76rkF9nmC9VUx2KfD
         x59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830296; x=1772435096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9REamna2TtkXRPR+lDCH1E9Zwr056ciH8ECe5GsnKJE=;
        b=H53K1J9TxSHcuF7pNCtJo+FWt+OFNusrsltTojtISecjN4wENPwLGyzzBbBSZhorJ9
         DpjU9WpymwHUNrGvUvMXl4f9+suBufHPFQ0QG89c1k6+n77KFgJMdV62XdAN3RfdiQwH
         AmuSnRZYfWAZeoZe5E0DfOZe6zqe48ZUv4Tlq4+5DDwGSJoUQA0kL/IoSNGh+zOWmQCt
         mdPStq46od4mKj9tV80BA/iaaXdyxvpr1DfbEgIlNmphZWifVVlgnrsl/GkvDe0BuaRZ
         bCU8jMTkNDI74VupqimMbAE1Gaoj7bqtTtrjIII3rILxY6R5p/Yfk1cQIpFdqD8Qk3O+
         FElg==
X-Gm-Message-State: AOJu0YwhDErbiPG03tDMSqay5W4WHmj8EuML6lm07ZkJdpr0FQqLu3xy
	fNTVbu6jcrHxhQQmF+C6AavLUNUgaYWQlAL+0jm8m+yE5BxL9Zi97foxSnJ2Gef/k5qZzpMbObj
	hroam9iwQS+C7+Ce2XBjpW1IklDC9uEANK7AsJjT9xMcGxymRLSGq3oZ9v7CeQlhVzjECnGadQN
	+mZjZHrEuS8+KFjc17AU5bGv5e3+XIGyKxM7utl5kku33SNaTMcQrWsO5DhQ==
X-Received: from pjst15.prod.google.com ([2002:a17:90b:18f:b0:34c:ab9b:76d2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:56cb:b0:353:4f7:cc3a with SMTP id 98e67ed59e1d1-358ae6a20c3mr5721991a91.0.1771830296257;
 Sun, 22 Feb 2026 23:04:56 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:37 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <85a7e5a06f0fff049e5440daea079f0be4c47ff5.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 04/10] KVM: guest_memfd: Implement evict_inode for guest_memfd
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8AD518000F
X-Stat-Signature: ediprpjathz981uc4msom9kquaqh6tye
X-Rspam-User: 
X-HE-Tag: 1771830297-191402
X-HE-Meta: U2FsdGVkX19uDnaf/TyfhpXLiqpvMnj/9e60xgHanqeplK2aK93rOhNStUyNUd50bfYGqavVzW7YMhRqJLe/gNsXwD4FNXGBR8+Sz1hUx6hJYDaSisL+gM+BYl5GnhcMMTIroPRn0jVEKaWjE08+tTXZ2O5GKjr9Nhcn7z7mDWf7p4UUkpm6OOnlaH0QSUwu8RlihhLO0COwXs4/IOVxjBjxxJv3ZyDh/y7UUXA4tv0ubZ0yo4zgtv+cTTe2+MI/BdDC6Bqs+3mhEK0PP6ml0Ccikxw80OHAOeq3liDuKmgg88u6jzOFm5Qwt3UzyoQ/usgviB5mXadAe/Rauki6BxtltiJ/x/hZ8lI7z5Q+jxcgjAXYZ1V5vE15juu3QFO6n7Wjc4FfBUUfKnNdlwLRapP69Y9Qac/+HD4KUfhyMiKtm8PX05aE5YDRyhoi5161vi2uGx+R1GJJHEMvKEWTfqnoiNvoJAi0+dbmDIyIf7KyZ4qLOg87ClSbFCXBJTPEH2lLM3dZFTfowEEHGUMg55e5Xbop3SJ/xuBx1ZateeJrYFtPEZ/7D+jHN1Ktpj15FQZH/lSDT/V7f85du/HYuSNeTllYpTB9Ie5sFKR0sRSjz927L/0tcLbXzidd3vAQ2xBiFN8bGReteLldAKQfY+j227WHVP0Krp0hEvLGUJKy7s53gk9EfvyPzrXTrs/WKQPzl+ED0nxCsalznQk3FDIvWVvH8dDeuX9glmUj1srZjnPjcGlbNUcAI2jAbzWznJmCdHqFo6BX5vOvvuNlovvXoI7ZrbG6cdmt/8D9tXA0z2jgeWKxHmGHcn2ZqKftNWylrnPecwEE4EPfHO9so3AoTdIZiAYt2NeRTffOFB3ujx0m3Nn4qas2CMuwbior1Ob+JmpvoZ2/yKEG+0G7y8jelFlhGH/+RbcPzRgXaqoS29hnM4Q3/ELq5elCXoN4neHpY23PtMDR4/MVdO0
 oT5lWiUE
 aLawns4/fI5v3ntzuXRmiTNIyRdFg+hK6GACNDpxArq6OhmYZKvN4kQi3ZILY70pFchPKlYop//LjGz3c+MFn/6XwPsZmxrMwgIgT7s5cjVu+a36iGFogkWo1M3e41ISu+nMoXnddmyS2F/5VUxHXkdzTApB5ZYzn8Hl3R3dkAbBLHIgUQVTHdWtxqLw3kOrr1gV4BACTurE8mcvE6aMs+NQcMPMI1Uqjook7Sb4oW7kXwXGRYs/TAyQa+065GJ8fEfQFEOQxmmwFGjDNq2M+tbdZ5G3mbKHOWSIjH8MOL9B3b8htXy1pIPQeKkEyy1FEgNk3Ivbb+CoSr5l9Ch9qG1uK0kko1tpUvEmD5sQOO2u7jHro3nzxu5aI+R5OWRNO7/BI2PD7GL3vO+Fdm18iJ/pL0QSRee8+u9mhDWvAON/PghNF7MeY0Ae4hEgsdqZYXbHgvkxhc6vXNW56JFI59gKaSk7wbTNSgqrk6GoOrb564uI69V2dbduLarfgsyvCGPtg25NGZnn/ZVNsWjSKZJDDP4Z2vBoa7TelJJu/jtLR6HQui1Kpjr9/0ItV8A71d32DmhyXWVRicCfSp/f7jbQ6nsk1LGdgYnvrZroxC7taP7y8bwsc2LVgkAdEbvYDoE6SL8hmUuKiQMp8FAduADxOAA5T3vViDth1v2gcGZCbaRrswglAcVQIaAims3EDEDUmVqhh2x774H1D4E3fiTM6Sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In a later patch, guest_memfd will be using a custom truncation
routine. This is a preparatory patch, which implements .evict_inode for
guest_memfd, but just performs exactly what would have been done if
.evict_inode were not implemented.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2488d7b8f2b0d..57dec458bfa77 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -978,11 +978,23 @@ static void kvm_gmem_free_inode(struct inode *inode)
 	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
 }
 
+static void kvm_gmem_evict_inode(struct inode *inode)
+{
+	struct address_space *mapping = inode->i_mapping;
+
+	truncate_inode_pages_final_prepare(mapping);
+
+	truncate_inode_pages_range(mapping, 0, inode->i_size);
+
+	clear_inode(inode);
+}
+
 static const struct super_operations kvm_gmem_super_operations = {
 	.statfs		= simple_statfs,
 	.alloc_inode	= kvm_gmem_alloc_inode,
 	.destroy_inode	= kvm_gmem_destroy_inode,
 	.free_inode	= kvm_gmem_free_inode,
+	.evict_inode	= kvm_gmem_evict_inode,
 };
 
 static int kvm_gmem_init_fs_context(struct fs_context *fc)
-- 
2.53.0.345.g96ddfc5eaa-goog


