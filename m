Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3B3FEB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0F66B00A7; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303036B00B9; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2096B00AE; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 782456B00B6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 458EE1A0154
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
X-FDA: 84529998546.14.10593BC
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf12.hostedemail.com (Postfix) with ESMTP id 080A34000D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=M5sopbNY;
	spf=pass (imf12.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2usIxDjhRkASOutR4exhTHk15KIo0gd7aBkCkGRTxQ=;
	b=nXE0Lwp1CRzZUExA5TLfMxEzo5M+m//Qobj/YOqJTW2C6e7x4SSCYLxGH2D3vTPK8rwU+C
	KRLHsmIcNyhCD9zUIXceBclibOSzGM80njTBeZBvYU8KNQtuIjq+jlUQDj2DH9d64OCfYA
	PsfXaxkL6kXM0Eb1XOl4Qj696j7vwr0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143731; a=rsa-sha256;
	cv=none;
	b=v5WCDOZDpX3Od3TqdvVJtuldKBxp9bQZ/oYECrpBytXEMEb0DHye6Xl610Me+iqmOcWC6A
	S0mnGYjJ0YHmxfjlEJ8bImyDXt2JASwIS3QEseV3a3E/SsXcMwdnmJ6qRtCOfVrsCiAXn3
	4/sIDasJdp0LiFiv4a9MpReIgiqMJ+M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=M5sopbNY;
	spf=pass (imf12.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143727; bh=5jNhYM960jMlYUrL3T2we+u9wPA7QX8xb/YhMa8cGzI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=M5sopbNY66qmWa+2q+MLa+uKDQnYhARDVpHPBaPhnBAWxbQH6mILrzFzXoehD/OnN
	 XfkL39v7DGJAyVHbunl2dtyoz4/s+HQp68/tCQVMA+YzssNFiXbaAEz8Yvn1XdtigU
	 NmV3lEhKYunB5kPsVmat/OQepTdLQIWCI8jH5Ufw=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-e21d-7f0000032729-7f000001ba7e-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:10 +0100
Subject: [PATCH 44/61] target: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-44-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1611; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=5jNhYM960jMlYUrL3T2we+u9wPA7QX8xb/YhMa8cGzI=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZrwlPF0cTtka85RKXa/jq01klA6219EkbVF
 sAxzvkaF5OJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGawAKCRA0LQZT0ays
 26c3B/97YbFOVY+7aU+X20/OGHSJFO2zRY48bbypRSoZTJJvUVhT9k9LgthUke6q7t50KfcaKxO
 +ji7TT6hO8Cm4OsGah0c5lQCV8UQAJc4iRbI/bt93UQwIqQrpJeR9mDiRtZ63zuk53hAKMaouvF
 y6MARoN+FEiA3sHGmWk/DuFGtzf6I3rn5UIuUm1ckeIx7XgHZwxEQLChAjM+0RUA9PFCwYu/qm6
 9IpeMJ2V/nIZwaOJH7XMvW452VksCcG4pysYBM4gaKPDiw/aj9RS8erUS771tOWY6ZGy4Wx4+7y
 JX63QRv+rPmmYyTOxZi58eVjXbcoNvE3qP8qFHWJHKPRXuOf
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-8B66AF2F-B220D537/0/0
X-purgate-type: clean
X-purgate-size: 1613
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Stat-Signature: km8pbxwmawqtoxyhn6ogq79ft6iz3n3i
X-Rspamd-Queue-Id: 080A34000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773143730-985010
X-HE-Meta: U2FsdGVkX18ay8tUQ+8v1jiGAUMaecez8d7JK7OJEoDJFHk3GSTf+6HSBZcGAFrUlL4kgjz2w6JxBnwD9yEA8Tjnag1LdSA02U3KalCy3KJGspK1pA/A228TKlQJcnvWJW5bQTme+Mi4BxR1KZ+sC09YNuhqVcB/9TUaUECrbcqPVUMZaFPnn2m26VBF+lbt8lofIbNXubZy5auglVmdlkkMf2aXlBT2eKMMc3tUtfO4bvVawJwzbsgTQC+KxI67Cx7OQywO+UUsNJVwu0vZkAUvwGfoim61Y4C5+iUNdqbP0cRxR1h4dUJlOz+13EWVR7xEQfRCTkeRHR284rr3rZ+8W12RKtUPLthR7gWGMwyTMIVgGeSF54wtF8A2o67cbcB5NLC6dTPKPESRu8zBENrIp8Lbww7H6VuNv6lfqDwzMCaWiobmh/iMeIN97usXCnfc8GApDXToW/ZE0u1NQLbpPVJsig4wMp1xstqtvgCOcc5P+ovjIv93BrcuipmzIH4qBkN/8QdXzAYf9JW0PX6QMu8c/2I+VJ6n7aVDWVYKFOa956qjj1oUnpoHpiEmtfmyPJKeEK6zVN71i1pxfxJVeI+2cf0r8c/Thdh0x9KEXJrrjvBwtrWXV+FbuoAnGkMC3O9KWytMzvb+RwHdKDZTZYN+N71dpd2YQ+N+aZieP12xy/dqfcEJGizepixfBglrf0trAteXGNgvsAVmDu76+RtQLuciW8uibdyaVM8OxriXvLV9enrN4szMI/f6aNaf6xzyIvadPiWFdOptmm2FWE+r3WDCgM47hSWh9U6V7VmUVFgKiuWg4l77iaYXuXylV5caJ2ZAj/NzPV+O16WcgEjG2TjaAcdXgV6EaoWk0BI4whjcPxck9uGtAzl7SpN18EMCBRqn5MrMgt/2MX/vqGymMEaDksb2oUzW/6tJTnCPLNYcy9pEWHBtcsq7EqNKGkBiKYyB4f+wJNu
 ljWd+Alb
 nkjjQoNODzCzS24dj47EviAHfzRO4eCaut4LDAOhYm7bR4RiVWEllDKzqH9dc2/0DF1tkCfbuOBVq8Gz8jGoBtW/MCu879868nh2Si8pbgX7SkEU/2HNjW/iKQXC0RhJPNJl526vfhwVw4x3Q6o2nAaNRHzuslTHgTNaImg4veLlHmqCWG/Nj3uYMYGnMZ2DfLFFH+kOO3qUpIcXUnL2R9XYbkq7F86u96G/KD+pCcG4ddNXKiHVFI5lUzqcgWJ7P64jBZvrNI9iT6dpDfy8GR3eCKUFOtNiw7CeBkVHorhO9B+yX4GmIo5gyznpRfJcCkdPuONsctodouWpuzgHMreWY5XgP48cI1PbS1EwEJotmHbSSSErnSzF/1wnz9vdpLs4QQYHKh85K1zumjOkShCHoN3LLghyjnaKn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/target/target_core_fabric_configfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 331689b30f8540c8e78de3eae32c1f8cd4906213..20d57d766ada6ba24cbd2d44d0107cdff9483a68 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -479,7 +479,7 @@ static struct config_group *target_fabric_make_np(
 	}
 
 	se_tpg_np = tf->tf_ops->fabric_make_np(se_tpg, group, name);
-	if (!se_tpg_np || IS_ERR(se_tpg_np))
+	if (IS_ERR_OR_NULL(se_tpg_np))
 		return ERR_PTR(-EINVAL);
 
 	se_tpg_np->tpg_np_parent = se_tpg;
@@ -937,7 +937,7 @@ static struct config_group *target_fabric_make_tpg(
 	}
 
 	se_tpg = tf->tf_ops->fabric_make_tpg(wwn, name);
-	if (!se_tpg || IS_ERR(se_tpg))
+	if (IS_ERR_OR_NULL(se_tpg))
 		return ERR_PTR(-EINVAL);
 
 	config_group_init_type_name(&se_tpg->tpg_group, name,
@@ -1112,7 +1112,7 @@ static struct config_group *target_fabric_make_wwn(
 	}
 
 	wwn = tf->tf_ops->fabric_make_wwn(tf, group, name);
-	if (!wwn || IS_ERR(wwn))
+	if (IS_ERR_OR_NULL(wwn))
 		return ERR_PTR(-EINVAL);
 
 	wwn->cmd_compl_affinity = SE_COMPL_AFFINITY_CPUID;

-- 
2.43.0


