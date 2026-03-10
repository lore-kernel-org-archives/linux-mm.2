Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C60CEB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD02A6B009E; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62F86B009F; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FF916B009D; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54F316B009D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 26F4F54FE8
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
X-FDA: 84529998420.11.1D6D95C
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf22.hostedemail.com (Postfix) with ESMTP id 062E0C0013
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=ZioiLNZ6;
	spf=pass (imf22.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFGvRlKzm+7M1qonE6vgNo7ccQBlVkvo/OM+PnyhH+0=;
	b=QECt/P8xwdMfPeWqWrIfs10WFgH+XoyOEaAQ/FAD8dowIAJtNOFxkJBrTvrMScCBBa+orV
	RXIXOfseU4Kvlupm3qRNHSHBMX8JtMuqgY9mXA1OZE/4KSyHWoJrzeVFSLrW8it9WQ+ls/
	t/bYj3Vi/rxZsy546YlM+BZbGtd7+So=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143728; a=rsa-sha256;
	cv=none;
	b=kTN4cBBFkvjXiuFdkC2tpoue0f8pF8O3Y6/inUezD61DlfaSn1Y0QLb1N+u+oVY1j4eAgE
	LwxJg0Wl4crOy+4kkCxeJhoomPYJJILepRuapuht79Y329iXR5r431n7hXfdR5jRI9vIUJ
	bQJZ/PH2NTcSoAB7YCF6npLQfxn/dP0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=ZioiLNZ6;
	spf=pass (imf22.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143723; bh=KX6X+DDiGt9UXTjcCHLPV6DtScldl/2cIRjPuvT9tTY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZioiLNZ6EfhKGMrW73+pjGIuwzOuvOKiSTcZ7wPJiCwebXNzeEOuXWZ+A1nFHvhW4
	 kJcOoKZ0VhxgqpRswcks1O+/9tUDVhOk4k88nkZD85ItDoYcz2HVcAjttfrO5CwuLe
	 NFoc05VLkE1QM4ORDb0Hi3i8FcBzsZqAPnJdPzxQ=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-2367-7f0000032729-7f0000019d06-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:32 +0100
Subject: [PATCH 06/61] 9p: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-6-bd63b656022d@avm.de>
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
Cc: Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=932; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=KX6X+DDiGt9UXTjcCHLPV6DtScldl/2cIRjPuvT9tTY=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXqJp0CDUjw9jEvsvX+a/KbvAdXeFk7KScmA
 k1gbpU+8P+JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF6gAKCRA0LQZT0ays
 29mrCACj+Vud6UtbAeAOyyVoHbFLvMA1jaglqqRGws0fgYsgwpzXFXvy2i2CmaAOIcTuq4UVTOl
 2Cp9O2MO0VDKHA4864zJOud8em6WQkYpTs1edDKjyZ8gpLnrkl+uUALuLIZHLcn32/PFl6USje2
 0rlhbB9Ue5RZDoT7EFzcp3mX899jCdSGzalbeWr5SPDgRQW0S9l7PbTpDgAvlvTr4+JT6Q76sJ+
 Xum3jXXZ29Rm368akWgnu/SoCzltjqdTHnSYloTAliMoi8hFFj6gbktEQSHRbMEzLVXTgNcHq2l
 4mfiDZbzmkqs8S8e3yaP+Mk/R/tjrHLygop2cIGzqTfhnlfW
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-77CF7E1F-303E842C/0/0
X-purgate-type: clean
X-purgate-size: 934
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Stat-Signature: hrbqy6fwxfx3nqo85of4uijf9zu5hxjd
X-Rspam-User: 
X-Rspamd-Queue-Id: 062E0C0013
X-Rspamd-Server: rspam12
X-HE-Tag: 1773143727-969469
X-HE-Meta: U2FsdGVkX18//Eu2WTYCKX4vZLD/jmQ0eVhHth8Si1OkoQKWDV89M4wZQq6dNRdYOCZsp3kojOAUfSxMwHMS6Ijkn+l6NWA50/Lo2MRMiE6K2COSWYThf2ZZzxkkWHLbueX0dxBUEjtnqzMHhNR8kT0Xn7rqjqM0WgfkxYHn3Le/442nlaI9v/UhbtMufALEF3Qk1sjjDrX6rUplkaASNNF8eQ3QstHElRaM7DMtLM/rx3u/ldUPmVuj6/H6sNuiTPtZbchLTzBruUERVxjfzLTN2O/lW82vp9GJjVNWHtGELO0H0CM11aKhIXbKfFGTNRTFwb93TbL7RfKPGmM/WCmdeJqLEVqbvYxpaM+RN0Ben9Qju/ev2J1J5xDfdEuiNpRlxGoss2MdcLrGD9xWp0NAu6BWLXvIzXnIPrYOogqG6/5aziFMMtH6qhn/cXaVJI34QB0i3dCMKKdvakHzZB9uLPOGvn4W+SCmQTc5IwmkANLp80mnjTLSYBAn1Lfll4QjqC+OkITACAzUfBB3ITR2Pf5U/K+8XE9o0LOBKjfY4lSSRg4Q5t5Qe/Y4Cwkrvf7nEgdpeKuxXkshYXJijujO++qQu/Ri54I1Rv4ySLDDwBhOnvyZ0GrLV7k++KLZVlNCkiFTA5FLZwhtYZy56M+JHAArYk0Jyd02PkmEwBlDWyEQAXDyAygghRMOVK5CrCYRf2BnzXMzoGJ2IDYBA4eceuYtoYYv0wMhuxtIvQ1TuQfen/s2JMoUybLrEN5og4J5Qp3YC+nyIWdumog9DZBAG///9N+xINLXfzi6WpyOeia2XoQ5KIugd3hHjiHWWCadb8poql2UOeLc9myLK9MB9ZBs5FQblHXUVuNKUKz4W3WnbI73KMeaAQPWfWf394fu+hMa3/ZWq0cAw2jJwVISOxv0R7cZItJPNAaAppmXYufXxv0JeUDN+JaF0OzwyhcaubutBpGVgxYDnud
 Hiz+HroG
 n+6mayViunu824/rJjYahMN+oCeDEGWZl09ESn1BDdtPCLFYuoJTwNoACXdbwh5pvSSKQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Eric Van Hensbergen <ericvh@kernel.org>
To: Latchesar Ionkov <lucho@ionkov.net>
To: Dominique Martinet <asmadeus@codewreck.org>
To: Christian Schoenebeck <linux_oss@crudebyte.com>
Cc: v9fs@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/9p/fid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/fid.h b/fs/9p/fid.h
index 0d6138bee2a3d1ab565ab2d210c0a3f3bf97e4e3..3bb7ef4380e972a2d9ab67eb4aab6cc5bfe2eea7 100644
--- a/fs/9p/fid.h
+++ b/fs/9p/fid.h
@@ -27,7 +27,7 @@ static inline struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
 	struct p9_fid *fid, *nfid;
 
 	fid = v9fs_fid_lookup(dentry);
-	if (!fid || IS_ERR(fid))
+	if (IS_ERR_OR_NULL(fid))
 		return fid;
 
 	nfid = clone_fid(fid);

-- 
2.43.0


