Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29073EB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51346B0099; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB256B00A0; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8462A6B0099; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 576336B00A1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2026D1BD3E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
X-FDA: 84529998420.07.06AD7EC
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf15.hostedemail.com (Postfix) with ESMTP id D771AA000E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=J3wSWYAg;
	spf=pass (imf15.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xi8Rxb9N8gVUASmXPG2lAu3yO+J9YHYyyksDmdHBdxY=;
	b=2std2llrvTmuLP4hvSL4BjFrTlTW6SAtXA5bMOL899aLnp5t2KcG3HI97vylk39VrOlZs/
	OsPKm5h8ajveSZuy9wzx6xx75OiJFIZcP+ET3i5O0c5gxY6dDhYzom+vE8uIKty7iCgVY0
	4ob/Gz1+5l0YceBQsZxZlfIjM8sz6Ic=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=J3wSWYAg;
	spf=pass (imf15.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143728; a=rsa-sha256;
	cv=none;
	b=GTiCdkUIaf1By4Q4ISmQZ9zI8MIDHukO7puyFi4S3y0R2HjAUr6/MCelrelRZ7e6BSfhRA
	Nm4MLajXwQHm05SruBdZVTFURLn8UF+xoULmlgvW/PquLlq5PppjrJmBHrPgGv99MQmZeE
	N2hJpreU0GlWZwmLpFgX4bJazDoHjpo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=1PXfnuytcDxCJ5WvjcpjD44YA1sDO5ZH9mYGPwGsGfw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=J3wSWYAgTHffE/RASKBpQWq2ySnTd5MpW6YLASVrV89gusHRkOxfAkrwsTjGvFaNS
	 hDxuWWXJL4XVOl+LI/t97dlq56rN6Kpzc7n2jHPxY+V+uUTEo8r5Ulk5M3qiRSRkq1
	 dYJqASb6U15Y8KxN9uh8urreNs5K4N5plRC3Hf68=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-b734-7f0000032729-7f000001bff0-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:42 +0100
Subject: [PATCH 16/61] sched: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-16-bd63b656022d@avm.de>
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
Cc: Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>, 
 Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1398; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=1PXfnuytcDxCJ5WvjcpjD44YA1sDO5ZH9mYGPwGsGfw=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYMDPZu3smBGrrjEDAZgewRd/vSzrMtCJxCU
 Ab0/aCneJOJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGDAAKCRA0LQZT0ays
 2yYuCACBFSism0sJT51wNOH3mmVipRWFOp8Vg+RkYWteB8QGePJlSbJv9OJm09HMkW7tLjwUyWX
 VVHeC9B16w6ID+8gEcOTClH7t/fK4Dy8WecKHkh0F285AVZWcglgZ3SjIJUNbcIL4vnctyxVDTz
 UXRKVqYZS83Tz67A8a3xEjr7wme1UPPk+FME5Cb8slTwxHRkeibjPT1wP0LHzCbUOIo6nCgv8R7
 jLfvDCodAoO4aPJRzL3vfdPDFaqXegciQKVWThwHK6Iz+gXqJuudCNdAk8Oa0FFSpSor2eNbdWj
 hK6ZRlUo0db2BRvH/nraA1HapgaLEA9P2vfUY2mJwp9Lzm4g
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-E0DD4A3D-EB59D507/0/0
X-purgate-type: clean
X-purgate-size: 1400
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: D771AA000E
X-Stat-Signature: qabjexmjs9ie8jkuf5drs584t4cjim86
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773143727-779593
X-HE-Meta: U2FsdGVkX19gmmNPiukOdMLr8TNKP+/fqxd13K8FqQAEitZkKZyeaiJjRWbxL0cnpkAlPvmQ/CIWRXIVU2jw/7ArIfhoyPVdvaAoMExr+f4vM+el+FiTHF7/AhOfNcx78eQDSzcX8LbVIUyzwEXVLia0twDb+C7aO8oAoL2TFJK6jsDWw+O10Pss8u+c4eaj7U7EF+qPVT8NQlKLFBEhMQ4ADAt0ixAK9mgg1VOpXDCSyXFSgQ14lpAl83kMlSpqTRkWjy/ZxHMtc2rnm5d+Rkxnf47H8ExZGoy0afO2LZsAODUerMvFPSvuWVhecWqqZ9fzRmsPWQ9ZGURWUCe6XAL9EE0c+t8e8RQQavRI1SUHvebgWzmmzqkR5oNaKa4BVNUfB6u6nrhFuQaUl+Ny+MKJgJ4rvU7Wkc7QP+t06C3TWq+9k9XOwUT3DAb+BLaM3uAnvcGFxqDnjlSb0jHyEnbZwY4v7FPavRlpTK2o2R3t4DVQFrWAxbSVgA7ORgl3V7iyCTvZsstX4+YRliYoUyChW0OjY3N8/R4pWNO2zKgNsYG1AbgyGF7mjImic7SmSr0Lj7n6A2XcEvtCfR4B/z+7JIUzKNzaadeOFBF09apYkvW4x4G14+42Fprhxyc6ANEK9Zht3YuVKXCEp4SBu9g9LtIJ+n6R9R0d/wcTWRJJPdQN9g0gaN7T6H7YNRpJiBvlrGdjauo9TuWouki7N8vmQge2zVhJTjSK4DXLXzdvvvuNr4OPsceOq/i9pYyBTZx7oWAgKYUVnAD1Y6XTydijm4Uv0nK/2PdruQTtumubSKN2QbmcvcbUuLaSvoEEWn1XuN/cAElSizgCoC/iT1YEHGyKAPzAMtI/9EtJFS2QPZFkDnYhzi7jlJodZ5NllRQTFg0kI9TSz7A8gKVTaOhVU2Txld4Ll1Hsa7LIL97A7QZku+1aT2b4xH4mR5Ag4uSlck8N4GQLdsqOf5/
 u5ulRaSN
 +ZERm1ijR50VehScYg5VWcf+Fvn5Ubf8jreiWEksj+DlkooBB8oimq5YRIbnbcdUavmEhpt4H1AkdatopWNiN2VKfc7c1M5ygWLBwHnk1axiED8M+vZUXA4/l548x299r4VP2Xkuqrxl+dU+LZ6VO085fj7Z7Ut+phi3R/Z1qKhUbM2VJ3A+Rx6ls1v/qYsk2vE/9Yps6b13xEE4FKmffK6AuEJjkmoNmakD4q+N7BQN1X4DekCFV/HI9sFTg+OqiB/zf0ygrmUt2s5pE9doME1k+comJ2ZV+l/fX8cAqFbCONKGJy2f9AQlGTCycIK1HkeTUz+TPqNxXm8YOxfPYtsl2it5/WfsgcgNfMJUQ4TBOOXM3jhCLSVVyLz85ipxDLTS3gZGnaZfoaiJj/Usyah2jpaRIJClEFYDe4pxZFXoIIoml35lq5eOhGplmxGzuilsFPqAqla6Hh2DzwrETpFAVad/6ezvWlNIe4f3VS1fj5sxgf4c5gHr+caF6evHJcQA32KQ3jJNe0PySkCN/pWNzFIirRXC68/N/endwf2wZOle1Cibe9aqMnAGgY8VFP7wc7HA7+IXRCr/YvCLy+3LnI+UenXgtdWOhXwbcWiR1F2oL3f08STeCXGwZF/dymvaYAiaZcAg+XFnfkOe3wqkErNvFRFVTQ7ynk7pHM9y9irvrlBKWk6bkgs4dumjNUPXGeiFOe1jFPKyj24ZtS7xOqeQxG0x2Dii58oWxOHcoHDIXs1WlSZOzjWU2512/Wjnu83PbyXa3zhcuPWZG3/SZF15CzMYFNHzv1TGtMb72MDgtu7YGST593g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>
To: Andrea Righi <arighi@nvidia.com>
To: Changwoo Min <changwoo@igalia.com>
To: Ingo Molnar <mingo@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@redhat.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
To: Ben Segall <bsegall@google.com>
To: Mel Gorman <mgorman@suse.de>
To: Valentin Schneider <vschneid@redhat.com>
Cc: sched-ext@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 1594987d637b09e586ae788b7f2e6336332d605a..cfa869bd7de5406a5ca094992ab04c62b0e92fd0 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3688,7 +3688,7 @@ static void scx_sched_free_rcu_work(struct work_struct *work)
 	do {
 		rhashtable_walk_start(&rht_iter);
 
-		while ((dsq = rhashtable_walk_next(&rht_iter)) && !IS_ERR(dsq))
+		while (!IS_ERR_OR_NULL((dsq = rhashtable_walk_next(&rht_iter))))
 			destroy_dsq(sch, dsq->id);
 
 		rhashtable_walk_stop(&rht_iter);

-- 
2.43.0


