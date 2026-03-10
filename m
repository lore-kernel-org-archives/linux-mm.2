Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C5C7EB105A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5EC56B00A1; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954DF6B00A4; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F78C6B00A0; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5628D6B009F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1AEEEC017F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
X-FDA: 84529998462.05.F78E292
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf10.hostedemail.com (Postfix) with ESMTP id D2ED9C000C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=ZhZk+uUN;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf10.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTXCjBRniTLoTR5IZDzkCFvkxhSidV7zyOsOCp6MmUg=;
	b=vt8w89nWuvp1hD3sLi6FtVSex9qr/TNYgtD5gdBocK+yV0MjsC6eSRmmwMPKK7iL5W/oxT
	eGX7v20a8A3tYjIocAFeSCmeKUvu1ST2hGKrTwlaBpSpa2oghyPLD8oso4WBygcvTlRa7+
	LFAj46ORYdQvl2sHtVp0R0MHeWx4Qw4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143729; a=rsa-sha256;
	cv=none;
	b=QzjPYxrVR7mJ6R1XE+m4wua6tVZIn6euWrrQBC6VzZDc9yUC70OgxHerKDYrmdueizL9zY
	SL0pF22Fn9UL7T5ZMYwpx/ORmfQkfIs+9oDG6lVGvz10Z5JSnC0iC+2I6kJQ/XFnX2GCsx
	GTSzqajKIpJr9NOR6GZh9EFfhKJXFoQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=ZhZk+uUN;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf10.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=kiPG2WUM9IIy6uswgVTVvYBzahqCQdDF2WT1QCoS/Vw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZhZk+uUNXnEjnXl3w1yfhkldMOPDqhhLXZDAMjGv1auPlOiTaiSmNuwae77r69zpo
	 wcrpRdQM8a/BZjLbD65ntammcni0DoJ16RicrUwWgtwucTmCe9C/jdQpatxzC+dLyR
	 7BX2TKdOEfp7WLvyJKm7RVbstZgrWU81uOV3ziCw=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-2367-7f0000032729-7f0000019d32-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:40 +0100
Subject: [PATCH 14/61] seq_file: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-14-bd63b656022d@avm.de>
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
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1255; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=kiPG2WUM9IIy6uswgVTVvYBzahqCQdDF2WT1QCoS/Vw=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYFWY4XXOtO7D0H7zI3NI24qzy0WRyWgjhsq
 Pb/2PtoUG2JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGBQAKCRA0LQZT0ays
 2/mIB/9Q6s+1zeiVLXadpRpmyYqAancRy7Bn2FComUQinQhHrSfolPuiVxb6YyfHfnSDtXR2P+o
 ZC/nc1mJGpByDWP4SS6acK19nNK/UVhicQydNeQRM17jmZovojRAWhs2/Nh6sutbizWZwHsYvxg
 dtISFMErQIBKR+INYDqNnYmu1VPajdqnQ2qfmPWd9l1FO4V1847kZKmczXV6MF80eYNGSPwebB7
 l5j+3Vv8ufK5FuVMTE1IDmjxjEXHtLbmfXLvEEcTc8Z+XvV4Rj3NOSWzcbcpJ8pMZ35IaPEecEu
 E1IfNqm4CamuHsKtBBAJcEXcTCoiSwuZuARjawKppxNaRDTT
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-84C8DE1F-2119C3CC/0/0
X-purgate-type: clean
X-purgate-size: 1257
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D2ED9C000C
X-Stat-Signature: sfhrekpoxp1ubfroocb61683x9a97h56
X-Rspam-User: 
X-HE-Tag: 1773143728-118663
X-HE-Meta: U2FsdGVkX1/D3SGiVfDMKVkdyoQMZIEEQccpDz43xaVV+tHabaSwr4EunnxV2gjPC8apbLz1OQRkMH98HMEKFSVSpDdYdWx3Xb3VTY1mMDPc6MPv+rHy/fJ3lZZfA1pRUp3eIjhqhm0gLFwgPQRewkA0jMMramaPIzUUc8r3b5LSa1wYwYBOjpTaItDqxOrHqI2FXcbTJXTu4xcUIzL6uBwywVQlpQOSkEQ3toFwYxC0AqL/HVztRK8Bc97ag+bI9wiP0TcTqe/6jIn61VobcPjT9HvyhRHTj06AnmF8BKbLtrgqt+BshRFsgHU+w+Ma4BgD3b+gUhPAiF5czuzNNRLyB+9SmdIe7TVy0uCySLVm82vW7B1mKvtddJsw05xJVU2+/EzOoGJL9/5LhXvJo3XsFrAlqMc+njMyCLixd9MZYd57PmR1tra+99ajvTW8I0memd1d42TxrEj9Np7q5PTwXewq6gJCVzqwHJRx7mSmk2NkSqEG5eG54xQEUooSxiqrPRWZBg/CbXwNPz+q/RKP6HrbTfu0wJu230++fVbMejmhIimi4mpvAPso3BY29ipKCmrUwhifJ6alhfXEgyWA6jZ5HF3Bfi8d3+fKDqQraJeiEV1JE7KM67N6EI9oxximDed33JbHd/PCrA3rl2oWlbmoNIcPvjqqv3OajdmdO4EVI9DzzjxgxW7MiEeRBMOb2BRfCObQKX2SXaQ0pVrGIn3LI1XvBsmmfn4zVQS+NZrqAjQBOkWjUeCzt8Cb1u+ns27R8Axh0dsc6u1dz2q12AuWV7LQosUed9PO75WDaOnd8NJiLYZl93ayRuf96d7NIUort8lbM0UMH1lA9PZkgSwp2YoSfFDDW6R46ZCd/oTS6bzOAL+ELJLsroX9pgt0BmQCwriYrYvkb+L62N+RrEnS06+LdfSb3ozz4HNUFjIW0XENQSsxhWcjvq+YZeAZI0qtazNcFs0/W/4
 6dCqml73
 b7eIigmjSHrvajCTqFl9X7Bp4djoaOslGszirS86/l5pQI07n0PeQTZq/ynOUf0PjyQaUM6p0DGDrDoMy0kRcDDzfRXjkFDcN6qwtM8skkLbUIi1l6Jdejc3DznLPWeZdrhYPTXiTTQZQw0ZuxECJDtVk06lspjsY6JFXYFgFNlTjI3pI4T8y5SoXXzSNerGgHpEzO2xCftaHzdpVzXajnMzM1P4HeqCPdwpM29R0oNA/X/5G/CGOwSbL5D2ABaHz3qRn8OZ5ZHox/sc99tbb6i9a0Fu+o28OnnbrnnszJtSkeQesur8vbseyxXUdaDnESq+DrBTjchVwqymfeBqDk6g3pmQeQ/Cw7QFR0w7FtqQP+OjfeuxbbXkKwqZhLb/vms+2ydwr2Pgt/dlbW99sAS9dje2/8M4OpvW86lDhnW2IBIOGASx3TqfFgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/seq_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 4745db2a34d12b1084cb059a667c367f4fb56dad..da30cbd6485ca8eff6c2572eab10659c694387d2 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -226,7 +226,7 @@ ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	p = m->op->start(m, &m->index);
 	while (1) {
 		err = PTR_ERR(p);
-		if (!p || IS_ERR(p))	// EOF or an error
+		if (IS_ERR_OR_NULL(p))	// EOF or an error
 			break;
 		err = m->op->show(m, p);
 		if (err < 0)		// hard error
@@ -266,7 +266,7 @@ ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 					    m->op->next);
 			m->index++;
 		}
-		if (!p || IS_ERR(p))	// no next record for us
+		if (IS_ERR_OR_NULL(p))	// no next record for us
 			break;
 		if (m->count >= iov_iter_count(iter))
 			break;

-- 
2.43.0


