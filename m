Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC625CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 22:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D0B6B0095; Wed, 14 Oct 2026 18:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E0A6B0096; Wed, 14 Oct 2026 18:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E59B6B0098; Wed, 14 Oct 2026 18:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E03C6B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:25:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE8091A0834
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:25:07 +0000 (UTC)
X-FDA: 85322663454.15.798E774
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10A43180002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:25:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fkKKHkZ4;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792016706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pX7eJVw8NKbWVjClJVlyeDcXYqLdmF7XB6xKTvch9pw=;
	b=ThtciUtDPg0BiLXLNakF4f/2T3pmA1Trv2h29taMePMpeEXZevHSMc4vDwe4ye+WsV7PiP
	5m6w98flFW9zMrmLTM1W6rS1lZf+9W3a0X6cJsEWYt4HG8qBedMctAXzdjnqDaQCJkdwtF
	L0w5HMyOA4f1QagtV30CMBNTJ7qSJB8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fkKKHkZ4;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792016706;
	b=woZSDu1JhsxIF4ZImBFkQZ2GCKuTBdttOeSbw6FnLGjt/flY+OBTweQ7cp0hvXbCDyTuG8
	OAedFzE5FOewaCbVYxSl3J/mhQiSastyytc2xoDGUVDoFf4hd3tGgcwU+Mb8Xukp2yzWP4
	TjZ16Xyjf59f4dZqHB212mkSp9a55Ys=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-533930955a4so42407651cf.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792016705; x=1792621505; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pX7eJVw8NKbWVjClJVlyeDcXYqLdmF7XB6xKTvch9pw=;
        b=fkKKHkZ4ACIb+4fKVwxekh9/TlqyYV9IYfxhi4mVw5x4Es8cTRIRnVmCe+qTmky8b0
         8dRc85MqK3ke6VfzT7MkD8croEW9hIZ9PdA+ap0ndsKmcxcjnoLYKg9yxadqMZP5UIgo
         uBjliKgniKM3dKADHRYgpZZ13WGw26dtrOUXtkIGCtJr02kuTHgGgBF/Amv1/1lRbv76
         wUh2cln+OgWM8/t6fIGZR8xQLRU9BFxK4jPKJeg+iO5ccAiDngaEG+3oeFGtovvuPNsM
         F2KXaeWJUuESHREO4yBmYzCSaDiwpsnSNaEcbxeuFoLjRo/n9jS6ZxpgP8vUGelTaG5s
         UcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792016705; x=1792621505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pX7eJVw8NKbWVjClJVlyeDcXYqLdmF7XB6xKTvch9pw=;
        b=Lt1yNY83ovgdBD27+9b11HcIfeR4ozl+k/+M0jO0abhgTjTRxi1vlsHRXkQMq8dXDX
         x0EzATiCGK6Y0mvhVLo8fgpPjOfpl/MhE+PsH+qqN5vISb3PVmGjW6qNsn6a7sT2Zgt6
         N5ivyZikOGDTNDs9WB+BYQbNwj6Dw9j9oeF5XtfuaI8CbxVq8uR+Qrh76VTY3xss+3sc
         rucIs0sILfIVLSgtTcyEc2ZPtPkyozZ3WAk/Acg/nXLMo2yukKt3kisM8tX+Az+V8RnC
         6RIQC0ByvohKVz0PDxbowxxBLu9KAvfHvIPabXAd8SO3HQJy7eHvqnKxNJqEPp47dWaN
         rR/g==
X-Gm-Message-State: AFq9FYKPiLxC3Jvgwd2gI5RXxiBstY38a2hTfZnTxjws8R0PNT170lAj
	Hy6ky46Dtq9CMElEzBn6JHVq6Z/pUIuY/QHNoKPiK8LmUIs7/7bCG8OEl5ch5Eh22WrtyLL0ohe
	xYQaZ2nw=
X-Gm-Gg: AYBFou1QR6mxu0SXtDplHL8UN4G5fjiPlhIzqj0VxMvsQ82+QMPdRXzXphRKVniQ4Di
	vHqTWGQD6OL+fXFroiYBQ8UfjjjKvqMZ06XqrLkbWNjeTSM7WD6dPB9N83LzTwj5IvtMAYUIgej
	JipmFTFU+pKVxpPBjwOSjQzI/S+oXmmtxrU9s/g00En9JM4e5squvuHkFaauHOybiYo30vuDpL8
	n6ZASvhDQvM4Mthe0OgWrmEbq0GDGZjgPk4Gl81R5J7vHnak4rLBs0jL5KOhpIzT4h/cPXUU8+I
	NKcGTgv36eiAUr+PFbDAFLae//Pi5dh77JqOiPGkalGZ0qGQVQFhmQ27D70KMBEQgITLbq1nRwd
	+xxoORgPHNfENPmDdnbFRf0IyQqs7T8nkiiHwETWlihuJduQp3lpk14O9Gy67VQEoVKewjXNu4W
	JlsScX1JagZkb8KsCoeXGHHTPAMNe1jX9w/EydB9pcSmKKOrD2qTA9MKxTXPQY2NAr6D2MyIe0w
	ubu8hwWt3hOcfGIO8jdqXvfyB4kUDt6UPWiE3wBTkTbRz9YVjyXDryLuPHR
X-Received: by 2002:a05:622a:13ca:b0:535:25db:17ae with SMTP id d75a77b69052e-5359f48cabdmr289086201cf.11.1792016705227;
        Wed, 14 Oct 2026 15:25:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536128418b2sm8652601cf.30.2026.10.14.15.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 15:25:04 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	david@kernel.org,
	mgorman@techsingularity.net
Subject: [PATCH 2/2] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
Date: Wed, 14 Oct 2026 18:24:56 -0400
Message-ID: <20261014222456.2318284-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014222456.2318284-1-gourry@gourry.net>
References: <20261014222456.2318284-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4tkn61r8uuiw1x6zscue84ya3eo6nitz
X-Rspam-User: 
X-Rspamd-Queue-Id: 10A43180002
X-Rspamd-Server: rspam08
X-HE-Tag: 1792016705-7866
X-HE-Meta: U2FsdGVkX1+1xFlbXqjIlAKU6EA4MpRTjXjZPcuqPzDAjfg+yfInWpjU1FVtTWURgFECv6l6eUcDOhSY+nOyh0hSazvIU9osE+SkFiVxTrboHJhx9I5IIRbs1plJLrDHHEQ2Q/lWtuMMDXCbvScfG/HldFByr4+G6DN6Gnq6jG4zT+S5TPmF+dS/ITwM9IulN3Vt/r1I9l1zliuzw9E+WwJtrgks89yNsPB2L7sI4gQ4BSU6A/kvWMW+pKvPVilDUwlmVfHPfqpWwXcXb+867mpc8/1FKIAcjmo2svy3ayUobT2pVH4IKy1nL1JHpQzjkxdlsC9M6kyhAiCTPmegSocTERjEN2gKwMSISRi6BgSpZsF6AAaDrJYgwbD9bhVjXNZgRVIwkOA4yFeMbmnu8caGn3f/TCPvNqZObBY4JP0uWLBmdVFbO+B4/AHWjzMm4Anzh6kSCivkd8CzKggA8mQP4AZtu1xZY0F4/8wavRDfxUAdG/xkiqpmrJHFTTDfy+uJdR7gfmQK2YukTOL3+i8HqDtYkllRn4MbPj9XsbE/8g4YpMYana5x68/m/C0QByPhq+MzSEoLcY+lOV1Iyp98utnJTE/h+O8K5XlwFaVVUow9awgAoqZW79NLLyN9ri6eUVf+ZQBqDaN0VXHRFuUBPLMviQWEwCaVLNmz2Nej3+HG4NvYu3hsAIVX67RlRcvU4wbl3RdqhZ2RoEh4XYREBPGb82PryauR1wfn7219Y8dH90aX6j7Qk3d17sOpJVA0O+MGe9v9R0RNULiaN/5gmTNCBiapVe4gpsVLA5wezTRstp9Gv/bS75MvY74KQyaXoPd6ANU3UZ+mgWig0wTLNBmDZZovPbaNWGEo8geCq6pmGeO0x/eQZxV9mrS/wWweMtcb4V909RK0aBE2UpZN7FuxZH63kHe0FkphF3pkS+ASzaW4esma5Q3FKSR7HMmfBzaN655OF1MPeGM
 dOcWZoEP
 ukcIIf0l5lyBy8ny5yWdp62GclZUc2VrUEhqtIA7aBTUThTx1fgmoVfbj/fcChulSU6nKBKHGh4uuGx5IwKXJgKhR+Op5+UkuDIRcRL8FAE3Slq5if2k2rZLw/o+P8asDOvVfvi/qMLWDqUYreIqFfWWcazZZXASht8U+fkQCk5P9/JxDkC+cpCt8xzPVLRdp64lxbDfHDzMTu+nakASzFSXi/LvdM6I33RAM5Yavr6RKp/vrc/xFH+NdQtCgxo0UYFCep+wdyPLi6s2w+nbMfJsUIaYvO36bvPG+7Fvjyr2gu1iRfWN4NGUW0YwLGXJoZuqvNWJTkmhUmtfHme4TpufikrB0h9G0lXho
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A cpuset update changes the task's mems_allowed and rebinds its
mempolicy in separate steps under mems_allowed_seq, but the check
reads both without it.  This can cause a spurious numa placement
miss under some cpuset/mempolicy combinations.

A reader that loads one mask before the update and the other after
it can see a spurious empty intersection and drop the nodemask.

For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the 
cpuset moves to mems={1,2}, the policy is rebound to {1}.

The allocator can race and compare the old mems_allowed {0} against
the new policy {1} - which will result in a dropped nodemask and a
misplaced allocation on node 2.

Simply retry the intersection until mems_allowed_seq is stable.

This covers the task policy, which is rebound under mems_allowed_seq.
VMA policies are rebound afterwards by mpol_rebind_mm(), outside
mems_allowed_seq, and are not covered by this change.

Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/cgroup/cpuset.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3f52717c19654..8ee239d5c6b48 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4354,10 +4354,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
  * @nodemask: the nodemask to be checked
  *
  * Are any of the nodes in the nodemask allowed in current->mems_allowed?
+ *
+ * A cpuset update rebinds the task's mempolicy and changes mems_allowed in
+ * separate steps, so retry if an update raced with the check.
  */
 int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
 {
-	return nodes_intersects(*nodemask, current->mems_allowed);
+	unsigned int seq;
+	int ret;
+
+	do {
+		seq = read_mems_allowed_begin();
+		ret = nodes_intersects(*nodemask, current->mems_allowed);
+	} while (read_mems_allowed_retry(seq));
+
+	return ret;
 }
 
 /*
-- 
2.53.0-Meta


