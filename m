Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99510C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 19:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FB796B0095; Sun, 23 Aug 2026 15:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC926B009B; Sun, 23 Aug 2026 15:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2566B009D; Sun, 23 Aug 2026 15:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18F3D6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:41:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69FCF160394
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:16 +0000 (UTC)
X-FDA: 85133552952.15.5CA1030
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf26.hostedemail.com (Postfix) with ESMTP id 86531140004
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HaA9HnhP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 32EyLagYKCPkxzjibohpphmf.dpnmjovy-nnlwbdl.psh@flex--wyihan.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=32EyLagYKCPkxzjibohpphmf.dpnmjovy-nnlwbdl.psh@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787514074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1YHDRXuyabVdapSHSXZFO8jE+pTDDymBWhtJlJpEAUs=;
	b=KwE4kQuhZESKnl2+639F9LQLn0A7o7o0u+75M4bmynbIMJEz1DzGEk46XhR1ymidSWL+Wn
	OCvWjHg0UfGi5YPZvYM7/nfKvcdso6rZVJ+w2KVYHOx4CBxik1B2SSLJduReQy7Aao7QJu
	1LZPCQ8+KEPtDgATFoszl635FrROfbc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HaA9HnhP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 32EyLagYKCPkxzjibohpphmf.dpnmjovy-nnlwbdl.psh@flex--wyihan.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=32EyLagYKCPkxzjibohpphmf.dpnmjovy-nnlwbdl.psh@flex--wyihan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787514074;
	b=Ruo68cjTkRJ+v+zfhB2ts822aq/iVcWvPyPhdWKY/pVKHNhMypTT+FmNKKF1ljsXCt18NP
	xAR7HW/O7psHVsoU4MPNv2SmCI+0sxX+fr3GmUWPenIm6g4NalKKxwxDcT/P8bk98QCTfz
	MOr4bDssyEl1LTTpW1gbgDwldrh6EzM=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84857446424so4797373b3a.1
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787514073; x=1788118873; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1YHDRXuyabVdapSHSXZFO8jE+pTDDymBWhtJlJpEAUs=;
        b=HaA9HnhPwFuG2ZUibs12moWwSbl3YwZ61zPLOrNJBwERzrvH1hPY6vT71N1xU297WA
         MEgjeBbDhrM1P129h1UcPguXjeD8t1r98pMKLyqhGnfwSrnN1mqffNzi6SntXiRfQFLp
         hI4VYdqW36D1qnjG8FOxDe2Frbpvwrdd+8qpfRM293/QkgHPf8ASWm2+yphyQOYHPY1J
         PXuhVNFqNwPXnlxMKNTubbs0bZUi3BqJAsJ+RH31sIYfX1llSs/rC3BAZ3j38XujTUw3
         8AC1d2NY/qSU8JesoxHfI+BkuL6Gt4hYuTsZ40pAPTwNo7CRk2pzOMSrImZxCg7w94pi
         kK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787514073; x=1788118873;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1YHDRXuyabVdapSHSXZFO8jE+pTDDymBWhtJlJpEAUs=;
        b=G3e4udJ5SDMykIMe+1mO02FPb7tkpaW3fIWucZ9dZroD6tXDqcFs+9onHp/rjY8KaM
         Y1ZGbxR9QnCTfd+5wjkpsWyQGdkPVZ0j0ErPtvmt2U2cyPVnr3YBGxoDF240ykdokdtl
         1CgEJMtdoxKjDGjUiwFP6kFTpjeDFSSU+SNsdo7oQJJaaFtxxyISfMVoDFwKgx0nPLz/
         aERSPfgh1RzMAHfJecQuJTy1fTqnvPKNcjmtEG9AeOicppV1pqeAE7LxdHi8RuFLC6dn
         5ZaBpixulTIa5vnbr8vS800tMFbt3+wKYvwEZAbGoviOLMjCU0teUA12ljyJPElSRcdS
         Gslg==
X-Forwarded-Encrypted: i=1; AHgh+RojR+g7K+7OkjvzZX1R2UMCgDJbyHZKF+QBsQQZaVwZ2b59Kn45wCu3XyaBSmyezJVVthDIYYrWDQ==@kvack.org
X-Gm-Message-State: AFuF++klgjTfXbB0BRWhHXzDNSisjHqvliQ+ZPF/P7LhlulUOO1d/V+M
	H4kScM7NzNl9iUMzCzpYx9WzZVztNeEH9VBzCjafSXD7127RnKlFmKTnttNoKemhkhZ1DSnvLTU
	nfc+6YA==
X-Received: from pfcj21.prod.google.com ([2002:a05:6a00:1755:b0:848:3f4b:c4da])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:997:b0:84a:29a7:f650
 with SMTP id d2e1a72fcca58-8520b06403bmr21400701b3a.0.1787514072766; Sun, 23
 Aug 2026 12:41:12 -0700 (PDT)
Date: Sun, 23 Aug 2026 19:40:53 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAMVMi2oC/4WNQQ6CMBBFr0K6dkzTUEBX3sOwmLZTmIRS0yqRE
 O5uxQO4fC/5728iU2LK4lptItHCmeNcQJ8qYUecBwJ2hYWSqpFatRAoxLSCR55eiSB4cDThSg4
 8v6F1GjtfY4edEaXxSFT00b/3hUfOzzI/7pb6a3/lRqo/5aUGCaiNbZ3ReDHqNsQ4THS2MYh+3 /cP6eGeecsAAAA=
X-Change-Id: 20260527-memory-failure-mf-delayed-fix-7d5a8f4a8a8b
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787514072; l=1927;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=BmydyRyqabJ0xq1KtEZLfqJqBfIHdz1QSKABi+pLLAI=; b=aQ8VY631+PZ+8I90X2r+jykIUJ42Q/O5yclWaB3EPJYnhT9dbJJbqum/jUJQCww5qrZd1UDmT
 KWwnaZyjzf1Cp4Ox8aHXsiwWhudY/IUqGTsKjYbYdn1AS3GCUvptlH1
X-Mailer: b4 0.14.3
Message-ID: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
Subject: [PATCH v5 0/5] mm: Fix MF_DELAYED handling on memory failure
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
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fdziyehi1w1631473fq49jxk8j3q9hf3
X-Rspamd-Queue-Id: 86531140004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787514074-233680
X-HE-Meta: U2FsdGVkX1+kGkagRhXI6yTnItFg9Bx1QyWrR7dgSI6LC+/q5B1OWhN1pv49lj5jTMfD5F0bG3boqOnOUvOwGKatx2kPHeiUtM3Br4SLd5Py8A1RS42zcaElxXjAsTvkqGhzOn9Sq9BpjrGemvqhYbimCWykSSyVTOClg+mDc/n4Fq9rf7TCUr4lMS4In5MpZWAGr+e8V57Q203xB4ilQaFmPXl7gXMBhzfhZqrn9JzeCTvLvHHmk+SUw/hMxmiVDFNNiVyuvhNcaOGHUusi5cF1/uxO/G7sOielpN6vhMd6JZfiflcLuopTDo0WPkR7TVULMC7VeQPB0bPxmsORo4lfK8zB5BZmOU4kd8WEhvGylsGb73IBgVBdD5hf+VrEC0WcqPkcvO11Y/a+1vRYeqaee63P+3/wXVzvMXAwtPQDR0S3dcvSuZgdjXI4dGgbHo5T4T3APhkBy5TsmNbEosN0gMNKGQnhssdaK0TjW4s36FwWyYvvmga2j2l0/3i62ermYNijSOzgiZza5JGR8/BHzOeFNPXP6Y955+UEkYKKAR89fep65QSEO6IpKu343Q0LDW1zlQDc7UqCQMDOC6/KSJBnUse/vEwG3jWx1T0e0w8IUxcso8N3jYK58UBJubht/pIplBJy+bmOzxcdcGR2HRvae8hM22FJxfJx9v6RcaS9Qjjkv5hZM47K6dFnvdu3P4dYMFo9eeK8i9Toz2lAg1CgEzF2cDNbGtWswy3sjrX5mLp+myAxSbLmv58SYWPMtQyCCID4xQ8zK/7u8ADV05DC0x3tlAciHV2I2X0bfT68VI3j7PHhy+eGL2NR/3FXCPZ5VFHGxixMNMelHx1TKbB9pHcDxaLuSTSWr4Ydn4CSOhtbdoXhvaIse3ofw+t75VumER0qJ0K5A0VIcwoqHWf9W0Tz0/jdohLnlY0LyqjtNCJI0ymIdpu8XzxBo1L2ymyaa/07gfuhs//
 uuwRSnX5
 DWj5K3Tj4cFzLl7bbDqtydM3YcyZIg23g5OvY5u7/FScPBNSGArMWdv8kl631pBUpq/pPQl88Inj+eAaA7x9y4Nm6HV05n0eoB3ogrvH84vQDfp38CnCTYqWPhS4Iktn4ViXd8K7kVXqEx8c+KxQdY2CFc9t2pmd/VOel0dZMJNZMP94LN8HBAOl1xYFuaO22Rj89iTIQ1sMeVZr/3Gx+4q1V0b6ChuVDrHwIeu7sM1YyV63FcX4MHixlnWqaKT9W6y6cF36V87clMyuHElZkF4pmpdpiKfyQtNl4SOrWUGuJnpz9hSC7GiQqXbB72ouzJTu2t1ZBcoIQJmm5/dHlXDlpLCHCKza1guabewS+xPCak32lHIsSpdQtfDLbm0nyXy1pY6I9U07eS3a4ZtMxn1KKhu8NcC0U9rzgMHzv4drcxlW6s1LyrVfHSeINRmqHB8WH9PIcE8qYxDRxNYu1PXm20R5Kw1qIP0cw6iPVQWxTrJOUki64pajYJUMrriEJnbg5Su24vyWYDZPuPLcFgofh5vqWUOdbq3TodsuW9/vvzT0fCnotw36fh3LgwiR7ExCCI/WnE6Zqo1ZQ1YYE3eWU8TFT9QmuAgBJlg2SZ48cGU+hcb/gUlKuppX7AxP013pryRjR3HUR5qOz3s2/QQh/AZ9KSuktSoGwLkRdzA0qpmxozCNpOP3H5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here's a fifth revision to fix MF_DELAYED handling on memory failure.

This patch series addresses an issue in the memory failure handling path
where MF_DELAYED is incorrectly treated as an error. This issue was
discovered while testing memory failure handling for guest_memfd.

The proposed solution involves -
1. Clarifying the definition of MF_DELAYED to mean that memory failure
   handling is only partially completed, and that the metadata for the
   memory that failed (as in struct page/folio) is still referenced.
2. Updating shmem=E2=80=99s handling to align with the clarified definition=
.
3. Updating how the result of .error_remove_folio() is interpreted.

Changes from v4:
+ Add "fallthrough;" in the memory-failure test, as suggested by David
+ Add Fixes tags in the commit message, as suggested by Miaohe
+ Rebase to the branch "mm-stable"
+ Split the KVM selftests to the future series

Thanks for review from Ackerley, Andrew, David and Miaohe!

+ RFC v4: https://lore.kernel.org/all/20260602-memory-failure-mf-delayed-fi=
x-v4-0-a5bc7db5a9b2@google.com/

Signed-off-by: Lisa Wang <wyihan@google.com>
---
Lisa Wang (5):
      mm: memory_failure: Clarify the MF_DELAYED definition
      mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
      mm: shmem: Update shmem handler to the MF_DELAYED definition
      mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED =
cases
      mm: selftests: Add shmem into memory failure test

 mm/memory-failure.c                         |  29 ++++---
 mm/shmem.c                                  |   2 +-
 tools/testing/selftests/mm/memory-failure.c | 118 ++++++++++++++++++++++++=
+++-
 3 files changed, 130 insertions(+), 19 deletions(-)
---
base-commit: 08745c62350126bc31b09548137be87e2866f628
change-id: 20260527-memory-failure-mf-delayed-fix-7d5a8f4a8a8b

Best regards,
--=20
Lisa Wang <wyihan@google.com>


