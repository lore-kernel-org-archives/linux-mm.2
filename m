Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC6D5CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A77F6B0088; Mon, 18 May 2026 02:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3578F6B008C; Mon, 18 May 2026 02:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2952D6B0092; Mon, 18 May 2026 02:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA316B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:22:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0EC7407DE
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:22:20 +0000 (UTC)
X-FDA: 84779546040.20.834E880
Received: from eggs.gnu.org (eggs.gnu.org [209.51.188.92])
	by imf12.hostedemail.com (Postfix) with ESMTP id DBC924000F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:22:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gnu.org header.s=fencepost-gnu-org header.b=qN69ukL4;
	spf=pass (imf12.hostedemail.com: domain of janneke@gnu.org designates 209.51.188.92 as permitted sender) smtp.mailfrom=janneke@gnu.org;
	dmarc=pass (policy=none) header.from=gnu.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779085339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDbhPa2Ho+FjDBUMNwlLcEab30t5ml8asm6EXkzfelg=;
	b=yb4pRmZEAdHrClMRMhyw09xQRk/IWJ7dY5owJboStUspIj85APCMjaO8IWIdQJLTD44QKq
	Vf16J4BO8yjgXtlZ1GCrJg5RB+4/6JH2x4Qz31Y/pl7VHeEcSFnX0Ba9dbL7J65lHfmtcy
	8/cE8x4KsrKAI44ajnk+PaVtdjSHgYA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gnu.org header.s=fencepost-gnu-org header.b=qN69ukL4;
	spf=pass (imf12.hostedemail.com: domain of janneke@gnu.org designates 209.51.188.92 as permitted sender) smtp.mailfrom=janneke@gnu.org;
	dmarc=pass (policy=none) header.from=gnu.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779085339; a=rsa-sha256;
	cv=none;
	b=qU93M+qG5B3zPNMuRqdQ75pTrBqVzlTL+yRyuoGGPNUMOpz95KzCYZhFfYQWMXXLKoQ+s1
	fe/HK715LOxn6/9l1z9y4OaPxAKnjbdzwFg25Ro//RK7L2IOh1egGSd98PJPHEHbqDQsYR
	x0oJKnvpCYwU48sl57U2RW/mp45sYmE=
Received: from fencepost.gnu.org ([2001:470:142:3::e])
	by eggs.gnu.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.90_1)
	(envelope-from <janneke@gnu.org>)
	id 1wOrMd-0004lD-GT; Mon, 18 May 2026 02:22:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=gnu.org;
	s=fencepost-gnu-org; h=MIME-Version:Date:References:In-Reply-To:Subject:To:
	From; bh=yDbhPa2Ho+FjDBUMNwlLcEab30t5ml8asm6EXkzfelg=; b=qN69ukL4dr+BAdb9B8nL
	zNHI0r602ltONKY6zdz0cDxL8HJVXHbkJpah7SB41SHGselmiZzb/G9qWGifysDFz5/Ytq47s89Wb
	UL0dXe44O3c1QZalO6Q5DlVoK80UBoG8Fhff1Cb1Y1DMSYj0lc4FDXMYS3uK+m4+5menBhK/sEevn
	FmVhPcR5CAl1tIgDNKY2pT1GSyn1tpMancY7cUbxOkKRwm/xxQAwF5WaY2KtUGmlNFsc1GVwFwynT
	p2j7KF3HKWB7zRaQyyjvIhDY6A/lgNkK9uWHJmsTBfwmleqZmNATmTrMgR9pm2k+XMkjQE1XuGm4W
	gPm4ZJ7O12JvxA==;
From: Janneke Nieuwenhuizen <janneke@gnu.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  Hugh Dickins
 <hughd@google.com>,  Ludovic =?utf-8?Q?Court=C3=A8s?= <ludo@gnu.org>,
  Rutger van Beusekom
 <rutger@reasonable-sourcery.coop>,  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] shmem: support xattr gnu.* namespace for the Hurd
In-Reply-To: <d5cd1ce3-db3a-4053-8556-a52982ff4a16@linux.alibaba.com> (Baolin
	Wang's message of "Mon, 18 May 2026 11:54:03 +0800")
Organization: AvatarAcademy.nl
References: <87se7stpgy.fsf@gnu.org>
	<d5cd1ce3-db3a-4053-8556-a52982ff4a16@linux.alibaba.com>
X-Url: https://AvatarAcademy.nl
Date: Mon, 18 May 2026 08:22:02 +0200
Message-ID: <87jyt1ck51.fsf@gnu.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DBC924000F
X-Stat-Signature: djj1ys7jn1yh9eerjby3gbtdwyk3a6x4
X-HE-Tag: 1779085338-673912
X-HE-Meta: U2FsdGVkX18NzsMKFx/b4tfATXlmOwPYbvzUN+q/+NwhPz7YyyguerJ38cypGSs+q2Skqrbva65IPSQmvtAvRhBu7aEpVjkShlLEPPoNSpYDNtZmyVdsozFkoTHIMhc5KUpLotg7v3ezpMmHXM93KRUUsYaUJWByo5lWy5jZo583CCpKDSTDD9E6wbAaOZKKR3tvP78nSXPdxpmvFlSD9rMcLblEZIN8ardj6ug7gO607gkn+1YFjKxz4CMe8ny9MiEh9sAW+c5okeTvuXYjvHnK6kR3qMDNW4KJTdeCaOFr7kTSDZ3LdP7CJniz2MFq+x3WVNA9LahKlwZnjLARryQHl9U3Vf70T646A0WeGgpFD/khl5nigK9qbpyMKyFcXwV+AmIRzyUiZclF8YThXoQMuJ2GzArjbwYwmStMtnDDEAcZ5tzyPaNo+KM/NrykUcUiIQ0GFI8VqQiBSpDu0zQSbdWkWDDzDVMCmr5Z6Kkdp4/lAiXPbQJMwK5aESeB74ljoA+kqF/4d/1YbZ5HcXwqdt/+XL1OrdDiwkNQHr3lFVPHI3+ebTKmiSCXMiGwhruCP1HGUvzLH+DB1iimLQOKgnG/odmy99fKywIS5NDtC3aAa2ONhp2zwTlypQzjxGgVZ0xp/hwuqwc3HpQNprRIvTYBZkvOgd5R3b2pjXlbgPl2qrIVTtTkHUae4ymvDLyHwU0C097h5snAXPZiGcWNh1qwpWiBQUhX9NKXzg5hW7AKg7sNaYpvcs6OGH0hUCvqiWAvHsMzhFl2CvFl+/8A4jzlyGgCy2uMczJyt1gGEC6dIZSKittyUjngqIfeCmdTsXljnCbCryUBf7dfVWyTNVPagtC3HPzgZwZYJnjFe0E2WvlYFp8KQ5PIm87MK+WAWuNVtg0viHa1Rrd77xp1vYm14qyFOUxAo1pSnwVRBr15AVlkEI6WjcI+iSCbEhr24XjC7YAzCs8eOpO
 QJRwZrBj
 kS33CzAaSio5tdESFlezdc/GM5xZN3S1m9fLJVbgSWTNEqVWCp/z667yVmFYsloZiwYETqhn6KZ+bDUqJ1PppgHFagQGXpvIUFpHmVx22Rve41pyxar93so/p7HwStDyTc8dbgxNQ5ZwWHU1H85V2bTts6IzbGXyonX/iFjn+0KuDNypNRBee+2Fj6B2k8ruanpUoyQjSZqqgQmnkZEjQn8vPBcdpLm/fARbKgQwfnk+yoUFv8Fk4gVYw44UBCluGH80czXVEZ1IB6U7YEk4sz5unwtGCIdbN7LUeWGC5oMJ+VsVlj9Pr7CkASW/H6QWQLbnaf14zJyEsfccBZJ7mJjUkLnBew7Rlw/38XXUDcAP2bOH8mJZnFjfpSZWaUigjeZarew/Q1k9ZcqL/TI5gPObLVOKuht6PYS4C5yAtUSTeR7dtBn/J/uSLCTI8dSuxDSqhRgF8u7GLgtTXvqdfGGxUGuyzLyeoCgEHZOS3fssBFhJLDAZKKVTC/a1thx90kJ5V4Lf6PeUxQ0Nr85VYRRzfWr+v/cf2xAqW059W5y92BBal4P6DC5gOveOITsAwExAYjp+39anc1TvBacZsEnnHa13NHswBv/690xPO04aPF2TaCbcQLgDzJa5kVeFCY3wYXIKhSOs5MGyVBJQq47rW21srQW3Nq93By/UmskPVEgXTn3myziqg0pL2mFsysKJ9HwGhZgeHEpby5hlJJrn6FmHCTp57arKoVgX9heN+E8XMhWmtpcscKkmaURqKES/B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--=-=-=
Content-Type: text/plain

Baolin Wang writes:

Hi Baolin,

> On 5/16/26 3:58 AM, Janneke Nieuwenhuizen wrote:
>>  From d8291d06b67db045033664fb440f59001d7755a1 Mon Sep 17 00:00:00 2001
>> From: Janneke Nieuwenhuizen <janneke@gnu.org>
>> Date: Fri, 15 May 2026 10:12:30 +0200
>> Subject: [PATCH] shmem: support xattr gnu.* namespace for the Hurd
[..]
>> to setup a pipe translator, which is being used to create an
>> initial file-system image for the Hurd from GNU Guix[4].
>
> Please add your Singed-off-by tag.

Done; find a new version attached.

Greetings,
Janneke


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-shmem-support-xattr-gnu.-namespace-for-the-Hurd.patch

From 4ff8927bb044dab11fca9b258e7b9c0b221ac912 Mon Sep 17 00:00:00 2001
From: Janneke Nieuwenhuizen <janneke@gnu.org>
Date: Fri, 15 May 2026 10:12:30 +0200
Subject: [PATCH] shmem: support xattr gnu.* namespace for the Hurd

The Hurd gained[0] support for moving the translator and author
fields out of the inode and into the "gnu.*" xattr namespace.

In anticipation of that, an xattr INDEX was reserved[1].  The Hurd has
now been brought into compliance[2] with that, and so has ext4[3].

This patch adds support for reading and writing such attributes from
a Linux tmpfs; you can now do something like

    mkdir -p hurd-root
    mount -t tmpfs -o size=2M tmpfs hurd-root
    mkdir -p hurd-root/servers/socket
    touch hurd-root/servers/socket/1
    setfattr --name=gnu.translator --value='"/hurd/pflocal\0"' \
        hurd-root/servers/socket/1
    getfattr --name=gnu.translator hurd-root/servers/socket/1
    # file: 1
    gnu.translator="/hurd/pflocal"

to setup a pipe translator, which is being used to create an
initial file-system image for the Hurd from GNU Guix[4].

[0] https://summerofcode.withgoogle.com/projects/#5869799859027968
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3980bd3b406addb327d858aebd19e229ea340b9a
[2] https://git.savannah.gnu.org/cgit/hurd/hurd.git/commit/?id=a04c7bf83172faa7cb080fbe3b6c04a8415ca645
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=88ee9d571b6d8ed345f877e05f685814412e359b
[4] https://codeberg.org/guix/guix/pulls/8632

Signed-off-by: Janneke Nieuwenhuizen <janneke@gnu.org>
---
 mm/shmem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..5d60aa4dba92 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -15,6 +15,7 @@
  * Extended attribute support for tmpfs:
  * Copyright (c) 2004, Luke Kenneth Casson Leighton <lkcl@lkcl.net>
  * Copyright (c) 2004 Red Hat, Inc., James Morris <jmorris@redhat.com>
+ * Copyright (C) 2026 Janneke Nieuwenhuizen <janneke@gnu.org>
  *
  * tiny-shmem:
  * Copyright (c) 2004, 2008 Matt Mackall <mpm@selenic.com>
@@ -4371,10 +4372,17 @@ static const struct xattr_handler shmem_user_xattr_handler = {
 	.set = shmem_xattr_handler_set,
 };
 
+static const struct xattr_handler shmem_hurd_xattr_handler = {
+	.prefix = XATTR_HURD_PREFIX,
+	.get = shmem_xattr_handler_get,
+	.set = shmem_xattr_handler_set,
+};
+
 static const struct xattr_handler * const shmem_xattr_handlers[] = {
 	&shmem_security_xattr_handler,
 	&shmem_trusted_xattr_handler,
 	&shmem_user_xattr_handler,
+	&shmem_hurd_xattr_handler,
 	NULL
 };
 
-- 
2.54.0


--=-=-=
Content-Type: text/plain


-- 
Reasonable | Free Software for Correctness | GNU Dezyne -- https://dezyne.org
+Sourcery+ | Correctness for Free Software | https://reasonable-sourcery.coop

--=-=-=--

