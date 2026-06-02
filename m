Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB55CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0996B0088; Tue,  2 Jun 2026 17:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298666B008A; Tue,  2 Jun 2026 17:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187D16B008C; Tue,  2 Jun 2026 17:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04EBB6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:56:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96B0614016C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:07 +0000 (UTC)
X-FDA: 84836331174.15.0B04D67
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id A93174000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rjZ5qM/5";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3dFEfagYKCOsjlVUNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--wyihan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3dFEfagYKCOsjlVUNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780437365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=y7tMKLqZLoUguahKVkzXwJunwH2CC8Y+lNvapE/6WPM=;
	b=cofuMqxCKZo2WJQU3lz2/7ggPMbHYuDCfBe2F2hbNF9jZAgeCBTVviAIfGkzuyRYq/Wwyz
	Os0T03BMFb+cX/b6JC5jvSoMhf74pdOwBOhHJ1i0qig4FAdhhjdWo29ImDh0h047HLjI4r
	VR59RE2seRQgGFrhyTnUCa+Ba1KR2Tg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rjZ5qM/5";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3dFEfagYKCOsjlVUNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--wyihan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3dFEfagYKCOsjlVUNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--wyihan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780437365;
	b=2mLYxdOc0/ekoTIsZXbem1ICBbEATQUP/ch7tIWCibcMcOPQBvwKZvFNX1V9dRXO+k84NG
	XSS/fdFRLfO2t+/YQu3HjUFV1REQAeRoZlv2iGbucEzbMi+hlsLi4Va/P922EfOyRHbUl4
	dQ62c/N3QmI2z+MbXYlb1Ej1hLUQ2TY=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2bf32259e0eso48708745ad.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 14:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780437364; x=1781042164; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y7tMKLqZLoUguahKVkzXwJunwH2CC8Y+lNvapE/6WPM=;
        b=rjZ5qM/5xXZKW7WwaQgbDVRUQWclBF4VTaKqVKKAmCk5jRKg4SsGLbSq1dXRNJT+c5
         FUAmXW9AToM9vL4lBf/1N6yc6GD5oZnXiOOLc/SSPtjud/r3AfWbSHcaVLxvI1dNR6Mo
         2OsjadCKo/dw25unpo7mp8Q/ou6Kt/1L3sQMmbf/fgGU+PGsT0XGPz+vFyA8zB3m8irp
         EDFNgjGo3EcG9sUrkNyvHf04oWQNz8MfNatyYEXbqxys1q2UzdM8rbWG8beVRAwFc+Vl
         oXlzAiOdt3CUNGf7qBk+6/ZdNGeGdTWd14YfgnArtTQWXJAZto8jA2lDj5HXNS4hrlfx
         57GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780437364; x=1781042164;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7tMKLqZLoUguahKVkzXwJunwH2CC8Y+lNvapE/6WPM=;
        b=qMSWJ+4ZPkIC6ikY3ANRYkhWnFwUR+ALNyp2i/m/tVoBeLRDFZeTkeBipPnWbYi25N
         e5Rei/EbMqf3B5mIKjmbt0XfWESeRj+SUPeqWpAbhIl5jMA0QfrBLS1IABdBw99nk2pW
         GnAniKPSM4LI4WePBYYpQsF1QBC2KklHtti5GPLEmmBaSgBz+9sxHxzAYIRjz0nDXWbC
         qVJNCA9mOxSGBTaAFIZ48zfC8rvGGXyMlNLb2IhcIW6YC26WdIPwHjupM+BzpM25rT1S
         nNkd/sjAoyBB4WsbIWa3KHcP1IsLBjduodxdCXRlr3mfaoCVZhbWnag8ZR/bOd+FBAGK
         tZZQ==
X-Forwarded-Encrypted: i=1; AFNElJ8cAC8iei/+1YbH5E8cG8n3yAl+q70zp71VS73dES9+tLQHfcnV/HjxrlnCt88iFzt4UGqOFm7ADQ==@kvack.org
X-Gm-Message-State: AOJu0Yxic7jvr+qkXeowDdPWP/QTo5EjLBwznZstvR1AV+OUwR0NRkmO
	JuZmRUDe5zUlTxuwZngkv1+6qkaB2nPxAOQaJ5eOwURPUtxglln4RBfzgtOmgMhf8KsSovzg2S/
	YwaPvQA==
X-Received: from plbbh1.prod.google.com ([2002:a17:902:a981:b0:2bd:bfca:529b])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c948:b0:2b2:4d36:7aa
 with SMTP id d9443c01a7336-2c1644cab59mr5323895ad.35.1780437364217; Tue, 02
 Jun 2026 14:56:04 -0700 (PDT)
Date: Tue, 02 Jun 2026 21:55:40 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAFxRH2oC/x3MQQqDMBBG4avIrDsgQWvwKuJiav60A0ZlQqUi3
 t3Q5fcW76QMU2Tqq5MMu2Zdl4LmUdH0keUN1lBMrnbPunUdJ6TVDo6i89fAKXLALAcCR/1xF1r xsREv/kXlsRlK/v+H8bpu5AUH/28AAAA=
X-Change-Id: 20260527-memory-failure-mf-delayed-fix-7d5a8f4a8a8b
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780437363; l=2245;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=fRnbbxlBDk4YfThNS9s3/pmtvrbRvFIdtObDaBTv/hU=; b=D5bk2bmUWWudEj1T7hfEsakTn+vs93FjxKXokW9ffFkWPkCyo4/U4PI0D+/WRcNzSfFoIDCq0
 DrI7ZczMCBoD8NfOhTuMdcBZJb+mUexkYE+ixEiHfOjRm1AvyTZ5eaw
X-Mailer: b4 0.14.3
Message-ID: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
Subject: [PATCH v4 0/7] mm: Fix MF_DELAYED handling on memory failure
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A93174000A
X-Stat-Signature: 9o3atakzd5gr9yha4d4jqe5yezjpgego
X-HE-Tag: 1780437365-163457
X-HE-Meta: U2FsdGVkX1+xjNhDdf4LfrU0txpzYjJKqV/cCXsMiLZFsVezvrqtGIiRO2K5Q0zUKgGw6lFapphv+PDstZA0vdRJwofLs//+g1glI0Z/qiiCsO9cKuDDxiIqMOlk0JA6dkl73eHB0tyxq8x6zCl2akut4WzvoDW0rntH7sSLFJPBlRUJCpwz0u42espItSWxz6vSvygyPu7N2Z/0X5iPFOvMTk4InhbnOfnmVcmPWWL5u23JZiDe1zlUP/wyiYefTY63xZ6mWnbhswUfFVUNHqg5TEZRd/ZKdjC/6MOx7LflCgyvkBpEei4UoCBsxN3kuOTtnD7kJddhTqFehfTaD+Jl9YUMmr94uDKxK1khe5FVE8WyO1VccuH/g/gzxQyMppzASu7kohQeOvoyB4fTPF8ffnXzRSS0SAlsj+a/cyhNvj1al+hLc8GAmVwQoATiV1zd8/FGXxOw21fyFBVRoQsEm4kZya8fKlV1GydFDi6gCUEOoYA+0rK/7OsKjODS9CuXpz5yYmfK+fWQfoCSE76cPq1koLYHcKEcWnsUWdeRhuIWrrs8sNcqP/KG25CsEyKl0jLzNmXU20CfzuFi40WMXB1KAMrJEoHzO5lXWqqbDhUpOkJrHMjLn5lt48TyIsISlsSazyZ2AHXZc+09l7TUFtI89BPKM6+h7T2gPoR7TdWXeKUZ3GNiNlnqsYzeol0CyYkn48kCLbK4N21QCzKWVskr0ehXni5qtimeB0YDtqR5KZ9q95EfbwErUDM5Sxwn89348JTIp81kfvEPsMFBToih/Lsh1PTG/MzpxMbzJ9A+CCVvdc7UBXv1QrvFpQg0Y4A91seJL5B+wvd5r0pZ/Ce98bGWtrZ348UjtleJbgp6llkuURVUeroo+WqlR5w0hvb5V0iWcaK04JfLfpq8Tsqgn2rstRJOCEnvZ5we66PHgMb02rbSn9oqk9ba4zfYtJBgK9G/21Rm4Ss
 keYsVS7R
 OxRd1s0LE5ltkJ9ITCc/vuC3Tgll9sA986n6nE3eWuQD2uOeoYOVk/HjJB+n2QVr9kaJesI0zqeQ/7VV/i5SBVeiwBvGWr2Acv+wgSfGegmZX/Gad+holdNVxWJhdH7+vjHtyA5raeXOLIWPsu/hvtigMo5KbBYJG4IBcEQnh4Nv01BuAfxFxOKGcSlopc8JD6mXxwa73R2h3DlaLyq6kXfdQxUKCqDzM6KPxKvPggWdTtRPuYhn1bR77Oc9UAaUPsw/i6mwwpxksop+XkBISOI4VmC6l4mEC4aWEbHq2zY2f2LIPTU0IqAoUK9G6e//93EIigBwopZddmu7KWLIK1SlL2jDgJOSJSkyXxl9Tb7N0ANDa1J6sriK4MEVXQ9EPwgx5MxxAHjmvviEPE6MTMKf5AP/Mxywjl3F41f0MffGIMM+mA4Ba7MDgQO2I84SLRtE2rrSa+35DHGFA177F8g0Ivmb9FN0mLGBvg9cqtM5PPi+wllTNH2aFXRbKcQ7mJofryXUU5Gi+yr0xwkagbg4TCoziXD9GmlwLN+Kc7N6LdO8HfmzG7S+zYDWFnH5SaOhRly7GTzOKjtGOPGrXOvKiCvbjuUsKcQpHfEkIriXiTvEmfiXOMI6wN7HMqQ6sjIdBWkYpZelrfbie6Qc+BVm+KapOofrRN6I5r+rQM+EGnGMTtQ3vKqeU9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here's a fourth revision to fix MF_DELAYED handling on memory failure.

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

Changes from v3:
+ Split an independent guest_memfd_memory_failure_test, as suggested by
  Ackerley and Sean
+ Align error logging style in truncate_error_folio, as suggested by
  Miaohe and David
+ Verify a clean shmem page can be read successfully after soft-offline
  memory failure, as suggested by Miaohe
Thanks!

+ RFC v3: https://lore.kernel.org/all/20260408-memory-failure-mf-delayed-fi=
x-rfc-v3-v3-0-718f45eb7c75@google.com/

Signed-off-by: Lisa Wang <wyihan@google.com>
---
Lisa Wang (7):
      mm: memory_failure: Clarify the MF_DELAYED definition
      mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
      mm: shmem: Update shmem handler to the MF_DELAYED definition
      mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED =
cases
      mm: selftests: Add shmem into memory failure test
      KVM: selftests: Add the guest_memfd memory failure test
      KVM: selftests: Test guest_memfd behavior with respect to stage 2 pag=
e tables

 mm/memory-failure.c                                |  29 +-
 mm/shmem.c                                         |   2 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   2 +
 .../kvm/guest_memfd_memory_failure_test.c          | 402 +++++++++++++++++=
++++
 tools/testing/selftests/mm/memory-failure.c        | 111 +++++-
 5 files changed, 527 insertions(+), 19 deletions(-)
---
base-commit: 38741a8e3bc1b809d64f8c8885ab15c3e40700ff
change-id: 20260527-memory-failure-mf-delayed-fix-7d5a8f4a8a8b

Best regards,
--=20
Lisa Wang <wyihan@google.com>


