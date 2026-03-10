Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28D22EB105A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4EB6B00B3; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA0A6B00B5; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0076B00B4; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 493336B00B2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2CDD140147
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
X-FDA: 84529998504.19.7AF7FCB
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf07.hostedemail.com (Postfix) with ESMTP id A66D840013
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=XrOjEMLx;
	spf=pass (imf07.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bw00K/cYen8HzVy4Opfh9Xr2YPOPoH4QqmKdT33VAv8=;
	b=rXFx86gV3INzP/Xo0WXuSAJHGhBcEUXbneGx7G5vXeBpslwxnC/TCkfARTqnP1FoMkKqHI
	eu5tC3n0RMzZijVb+B3rHUpBs4VDBr2GAzqOgcye1fo07ujMIKPXTcFP/6hamkLspcWkNb
	Ri6xFUQ8PF+E4u6mPzUH0IeBpX3Z8Ak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143731; a=rsa-sha256;
	cv=none;
	b=eyUW+MXz3GgOK1TFzebgWkcq/eLP5EodHIGCzAyo0302/mNTpT5KfNa0EIktvzmaN5BItg
	Vs+sjR9rDmVCfG5ACgIbef6K6oiuq+cKBR/cs3WpV1lpp5vp5QvlyQhhBAGAlhS9ro9ZrK
	1a6HMFQk0REUeB7QJY1LEiDnkh6q9hc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=XrOjEMLx;
	spf=pass (imf07.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143725; bh=pn4l4Bneda6cRvLB6hSFUDCMaCdQu5yrimDpnU+4XNM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XrOjEMLxKN0Q5AmyrWHNIKWYwAXYvxSGofpRw1fSzyTCz7O3kSu9wZMVhCigrODma
	 xaDgiBmBXDbNfcoI5fcc6yYimuO3Cnj4vKRdoox62XvE8LKZz+/gN4z3zTXbmuJ2J8
	 09unIVObBESNuzHAoxHz8OyIcq6YqGzcxhMd6Jyc=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-2367-7f0000032729-7f0000019d5a-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:46 +0100
Subject: [PATCH 20/61] apparmor: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-20-bd63b656022d@avm.de>
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
Cc: John Johansen <john.johansen@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1034; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=pn4l4Bneda6cRvLB6hSFUDCMaCdQu5yrimDpnU+4XNM=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYZg+c1WuLJkNtjs3nyvfVhnVwRMFZkjRyjg
 9Bta5ElUMSJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGGQAKCRA0LQZT0ays
 21AMCAC7XRT2CFV3uyPK4StoEGsXQYqMR1ynn7bit9TqTcf+0Wgtn6TYvMctAHR6A5S0MhH7yf7
 gILWOKn6+HLqPdr3lmY3ZuYwuYUr4OHhvBA9aCnbDXWOuH1dD12oVxx3wu0+3drbZUUw1a5lJWN
 hsJfyDm3gNagxfOpgqCfQqiJ9xVVghJWjS+o0/hto7AZgqOBw9ObaanKLghJUEDwwTwpQEVda2+
 0LDNyTd4iej+Ak8COmDse1KGC2gcs+EiSzfYOC0pte2fBmGM11VRcAnsxd2vAsBFmvs/mJ8XFJS
 YSqDB3vEx2vFoOZdvhWx2ECAhXN2w/fnobSlleabiSgRaViM
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-914AAE1F-0BAD1D24/0/0
X-purgate-type: clean
X-purgate-size: 1036
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Stat-Signature: 1expxj7zu4fjixjy7jfk3ceapc73wy13
X-Rspam-User: 
X-Rspamd-Queue-Id: A66D840013
X-Rspamd-Server: rspam12
X-HE-Tag: 1773143730-445922
X-HE-Meta: U2FsdGVkX1+f/zX8pRndr9QLuMJN2ysXv9QRsvbwCqWGP/e8nPodhEc68+RvKSieggT1ceNeAXeNtw7964pgqgugrUM0+8ei9tima12lz4Fz3yxlIUZSfJw5lPvgFCl+GkS2sf7fWExIuKuhDv/D2hyL6ko63mmCqvhRkYk1WrWghkBpR3ftagOTm5gL4mwbBg0piS5emZZ4EhP4gYAst2JjqvR2wWlzUDAoBpUU0kOxCQnWaDMhlVmJS16/SJSchNiSVQO94IdhaR6mg4jR1H50wMREXgOFDxuPvhu6FKCDKfFO0RlVUToulRFkn26uMGI42z5VyJy5fQt0GA6MTD8G4GGVAwFDmPhFkYuNYJm3CQ3Pdm4AriEISie8DIWaZ0oAGwd7BQJElWiXQ6UONu+FACwY1ZnP8wAW9t2Q14+d2zRxmucrxC6roQ8e/zoUgVCsKBHVS0yM7/NXSD5XX0RJ5qkmLcEvgbzT8zYih8m7yEnjmoN1Ww8xl/Qpw4qI0gfkEyoV6dEtncMid21ciZrfsVL4qlIT/bueMc2dDBWYbY92i41vLk2cSfgVejf+cPBRvFu39lgMYHKdF2InFRgfEGDjWyvfmRHhEnvU2P0ljZeFk4VAIrDPQlrqSiDtiH920SDfHUi/TWefY0OKgXDeem4tqVHtOz3oUFgi8RUIqY77B/48VA7ZOV40HWwPHng5Z6EGHwx8p/exJ3+lIA2mznpt4KervwcRvK2ES/0koycteO336hDg59Kw2n0e+Ti8aDA7pqbn0JbB5Q5a9GkthAfUuDAtpaVYtLrW4hJU/AqtEnvfOFa8ay75n2jRnHpnA9kusCI1NpuA1YokkGHmUBUNaE4iPeTmMKMKaJvSPa9By8smYdc/KuLA99S9DqM6LuNktlORjtGONPMAt1jHC1le1yXJHXAlJH6G7PIdWt34JdoBfzSO9KGwakiAM0T3tt8V6N6Xb/4ymH7
 0qPHbJtu
 pLLDeyiQVWySXPR1gDivvMOOAC3Qt66o6YIddfcdwguK/Ak/iNXoQ1JSdoOcGU/vOH4BfbmpFFnkUQIEm+yn/JlqEywoKkPKQGAXg27nUJjw32n3mF9e3fBv0HFk9/tHvmfC0i+JwPz9jHv/6fa7TAFH5rIbHE1dcwBjzkGY7/T+carqhmcAj6VJlkyDYJH8nrBa8akgGaFvwsEIjmxp3x3RKHv5I/U+IzpgCaCawYPaNQn7+8QHnlbp+S2dtrFDEA1liOS2QY5NI0zMV8T2rqDJ1LXY+7ZVX3RKcwy2riWYKCAOW6icbd7+SSQdO7jj8IkKoPFFXhDoLT8aPVQJ5n7r3UDLKIK/CVRrS3DycrvuHnww6SX2keFDJq/mIR2IwOANRzpA7+ETnOJoro7LZ+lQPCpVSDewCPARsZvlPyhH42I1w4bmKmjOH3jBb81K4v7OHWJXm4ix+AlTm7spZsKU56NfPAC6weWWzDjTdgJP/v+Y35FHoKscsEnoxqB+k7zA8Ml+Svv+E8/qKUwlE8xFEhZ2DeK7GXnDfNkaga0zIxGNfWJTMeecKRwdIaYpvOwgM1Q5V5L9rsiVlgXxunAObQMI+fQIMhL7dbac8TCsx3RKH1phZXRgUDek+2yYT5+Pa7p+WntBwE3exNERLLqz+02UXs1z9Z1jY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: John Johansen <john.johansen@canonical.com>
To: Paul Moore <paul@paul-moore.com>
To: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: apparmor@lists.ubuntu.com
Cc: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 security/apparmor/apparmorfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 2f84bd23edb69e7e69cb097e554091df0132816d..5145b0c9c699514697291967c5a7b1e96b8753d1 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -352,7 +352,7 @@ static void aafs_remove(struct dentry *dentry)
 {
 	struct inode *dir;
 
-	if (!dentry || IS_ERR(dentry))
+	if (IS_ERR_OR_NULL(dentry))
 		return;
 
 	/* ->d_parent is stable as rename is not supported */

-- 
2.43.0


