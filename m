Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A9CC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6216B008A; Thu,  9 Jul 2026 18:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48B76B008C; Thu,  9 Jul 2026 18:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86886B0092; Thu,  9 Jul 2026 18:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB3726B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33B821C32B2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:23 +0000 (UTC)
X-FDA: 84970683126.12.E19AC51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 48F48180011
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRKp+h8B;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=677B5n0kvLgyERJskeE3rTX4vg8H2agSafboCd79Yqo=;
	b=EbnS2uqqsctgMG5qwUPSPo1inqYAV9d/F906Z1ddjgtDoD9HRCfEEifZNCNBEwOPvUPGw8
	t2LugDZZZ0AdZPunuO0S1KBPNLXjl4XukkUPJWhqf3DKaLGtl4VDhLEFYXQ+tD41o/jTMk
	1KKDdPdsSn6b1IiXC5wQA3bISx402pg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRKp+h8B;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636221;
	b=WpPtTbB2MvZ2bTiKoIw8o5H8ZN74yFVKxU/3bSIMAY9zyhJgO0HDu5zHh+Aos5hmI28x/D
	o8TkRDKy+3Kh219a4fLtLK8WtoF6bzhc+eAETkT5GFCh/vUaisTsg48Rj+4ZlzpsNxbIPQ
	9k0Jx9yBRJJ83Hc7O0fy2R53U1XYVuY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91A2042AB1;
	Thu,  9 Jul 2026 22:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E396B1F000E9;
	Thu,  9 Jul 2026 22:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636220;
	bh=677B5n0kvLgyERJskeE3rTX4vg8H2agSafboCd79Yqo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lRKp+h8BWaSeDykoHoqJ5mrqlRIS7VQXlre/ap9aJ/0RlrHcyAhk6na3dJU3uSyrW
	 ctG+55gZWNCsY7zihUV0+qp3xgbTtpkPPuV8lHecUZ5Esggt5NJft8AkTKFPlNXk0m
	 VZSIEdHZYx6K/f/a+w5k9vBbZlhn9DrBDbu+WSmkEV9hOshFgeUiHUM2dM+qK0Vo5g
	 j4v1eY4em9b/9UCzakYT+3deEWb/j7q0SQitS44/z0G/UrWi2egiNRXmBUyY7b3SYf
	 M/5Pc06+47TTRggx8pyDNQ71FptEwEU0xnTEOhUQnwzOO2/e3SlwuQ8qTy4/L3LYhn
	 Qr0tDeKYYF2KQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:29:57 +0200
Subject: [PATCH v2 02/23] binfmt_misc: use exe_file_deny_write_access() for
 the interpreter clone
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-2-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2087; i=brauner@kernel.org;
 h=from:subject:message-id; bh=AYPobXhR7tlhSW9eVD0N+FrhRjSI1w+57SYynhHowac=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHx92v+Ba8sr9bpOt5yDwT9ftWx4s+jNjVzJ0skxc
 THy9+587ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjImURGhmu3lp+0ehIurTtL
 OP6FkG3TicD9wql+209++jFfoH7JX3NGhmb1Bk+PX1vnmOjz8s0WfetnMrt3Vkuv6Nr/B+e2nTU
 6xQIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 48F48180011
X-Stat-Signature: rru7x5psenud7oirra44pbumh5soqzyr
X-HE-Tag: 1783636221-847340
X-HE-Meta: U2FsdGVkX1+trzMkXnaTC9WUCX19TNVq30hbTl6DiIFQ3pjDn3r/ZV4JfCrt1qivC+5ksoXYVW/Whbx8f1KyCsAHogaOTHVP4I6i75MjaOhQLCcjhvzemDpsohT857MqMj+dxct17iPFCbl2RJN2Plbr1keODe0kM1gHjDiEREiBlPQQgUcty1+F+Via2tf0u2YcdkAUfVRulr9XeVSoO6bl1iU1cWJOPIyaqT3zV0FJraBPRiOqw7uUjAWhy11XiNo33VkEjSlT2DmtGnFvQsKpsJkNue/mu5aUfpBLKMlViKlHsDyh1Pwo545m36rkNo7yhKx4UVEzhoYF4ydbr6wEiTGgUOilz4r5mRyNBVij9d+5QnGH8CAkUGjiahEmoYRgkzu/vlAog53RlpDQJYQroFfEz7ULi3e/nLAS+oGN/MnagXPEmw1DkHIPkZQ5oG51IyuG/sxz9LsO5KC77SqjLSxNokPB4RNprosF43LyjxNf3T18HyryfBdpdfy4SZwa684X8CiicX0P0CHfNjcCnZ6tKq7K0IsHADgJUXJJkV0y8VWSumY3XCClmAY2VHT99GMiMq2fTNVLlgEBL/n+qNSjDaTGB7hQoIS2qOu/45PoMsrSqSatOhe29ROr71KNjW6mE78vVRgeccHnh3g23n3CJrYNv4QVwC0/vUvRXyJLS9Zk6ZisRiRG/Wd087pA9o9FDEkrpmZyzqCrIq/v4gpxTbo3nCL2LzvVbqCw11gJIQ+tyOvkRtEZJG1FMipBo9ApMmy8CuDOS0Xf+RGOcaNiA6iA1lVt6Z/XeNAhxAONa7utCR7XoRyP0yDpoPOZDfKjp4/G19ZG4yZROGLCKPGIwCUY+BfG3ZGBFETe98Z/bx05wCAF5uMszKGhZPyAuMSMNETb9eh9fWgOYVzUxlryqtOurdTRAHt6RwUIUcHUcDgbfCQSsaifZA8l4+4hOpCGN3DFuQYSUFx
 M9btdeNh
 RXxRssqugdR5P/PMN9U818CrPFAPKM0Qk3RK6cZz2JbF6QakSXkn+a6C6epbY3/XDjQWNQdZDOBqH8EeUxIQhbvOWPWKJr2RZFEn0i/jL7pXbUWNevXgTQJ5HXjgs791ruioiAe52w1ZPagFrZP8DZQEjV6Jxph/t0W6dO331IFKY9tCCOd7FczdeXkpsJi+v1JbyJ1O9EMk2xLXHsjjq5qWs2YGLeG5MWa76piGROyD9jF2W2e+NxOOl/2np402EgUC7/vSE0kWx38PrriL7T2eXFRjpAEIf6Id30wquLEaXWBj+TcPCdR96ahrZx2fj5NnfCoJSJ/behnQst3OEsgo2WNOAxckvODWznTBu9IkknhrxP+7bENRqQYDLOnllN/cI9WLtYcboVvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For MISC_FMT_OPEN_FILE entries load_misc_binary() clones the
registered interpreter file and denies write access to the clone via
plain deny_write_access(). The clone is installed as
bprm->interpreter and later released by the exec machinery through
exe_file_allow_write_access() which skips the i_writecount increment
for files with FMODE_FSNOTIFY_HSM set.

The deny and allow side can therefore come to different conclusions
when pre-content watches are in play: if a pre-content watch is added
to the interpreter after registration every subsequent exec through
that entry takes a write denial on the clone that is never paired
with a write allowance, driving the interpreter inode's i_writecount
further down with each exec and leaving the interpreter unwritable
even after the entry and all its users are gone.

Take the write denial via exe_file_deny_write_access() so both sides
of the pairing base their decision on the same file mode, and
propagate failure instead of silently ignoring it: an interpreter
that is concurrently open for writing now fails the exec with
ETXTBSY, exactly like an interpreter freshly opened via open_exec()
would.

Fixes: 0357ef03c94e ("fs: don't block write during exec on pre-content watched files")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index de50a7468b07..24142859658c 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -252,8 +252,14 @@ static int load_misc_binary(struct linux_binprm *bprm)
 
 	if (fmt->flags & MISC_FMT_OPEN_FILE) {
 		interp_file = file_clone_open(fmt->interp_file);
-		if (!IS_ERR(interp_file))
-			deny_write_access(interp_file);
+		if (!IS_ERR(interp_file)) {
+			int err = exe_file_deny_write_access(interp_file);
+
+			if (err) {
+				fput(interp_file);
+				interp_file = ERR_PTR(err);
+			}
+		}
 	} else {
 		interp_file = open_exec(fmt->interpreter);
 	}

-- 
2.53.0


