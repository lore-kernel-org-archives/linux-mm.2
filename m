Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F997C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 999E56B0095; Fri, 10 Jul 2026 05:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925366B0098; Fri, 10 Jul 2026 05:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836196B0095; Fri, 10 Jul 2026 05:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5710A6B0095
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0443A0307
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:29 +0000 (UTC)
X-FDA: 84972354138.28.9B6FC68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3349310000F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nN7+0tvZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrs5lraalE2UG0MriVBsYhlbNUjZEy2u+I/gnOfdohU=;
	b=PJtr5jpjuh5EraE7uz4zksHIYHykJVIvMULhQNc5p4mCLHLjkuZX4Cl+kGiKmFyg+xHPVR
	Pizx6zOHUl6FAJUZEdro6RDyNskeBc9KXJKaAyp4vTm1awNCdCRw/XHjhXTkKLDi7ZV5Gt
	Dmo7lQj1y+0PLOc5c5npRysL0h/U02o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nN7+0tvZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676008;
	b=Hwk3b9yV0/DzbmWcFxGkHDYI/PRJfprmbgjQaq1zWuSozQv+81NDPebEG+6dCCYGrycVQH
	3sOVCVCEl5iDGRtbE8IMFlSUXbjKwAyJu44cFXRkuMNG6Trj/Q6b4bvek9qV6g01FCrmG5
	zeSiLzLywsSFZxgzHFVN61clwyR//aw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C542160EEF;
	Fri, 10 Jul 2026 09:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2AC1F00A3A;
	Fri, 10 Jul 2026 09:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676007;
	bh=xrs5lraalE2UG0MriVBsYhlbNUjZEy2u+I/gnOfdohU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nN7+0tvZRI8ao2T+BWyC2xVLZc9ZQ6PLswTiXRS2Z9lqXMUCPS1wpQxTSbT22Exct
	 K1JLTiwFpJ/XWy5Rf8To66gjwDJBIXlEHoAHCGj8HjSBts4kRQrHj/hUPv/49oukbI
	 I4MVlqSXSao9gatsjqV9Ttgi6B8iBiGZGJc3QRoFCK/YeKRyoj+uAb67EiQ4CT8hy8
	 IchSa1/AR8ooDSzLMgxajnyCOF8u1sBMi626J6ze54bXDSIhq+4PMpHnyJXsrj9gtz
	 zcgrxWBy3LYJXwckMZUfLM5vv2JFNAnyKJ1hgS6YY2ZkGl6OgcE+2tCgTzRzY/3HHN
	 Z4W3URY0XuuuA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:04 +0200
Subject: [PATCH v3 03/24] binfmt_misc: reject a flag character as the field
 delimiter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-3-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2408; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LJghwtw/rZdPZpzGD37v4e9liYjTcIOPdSBYtvPd6LM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7IkLu1Tdkxr3luHWi29BHPxrVucsefmc+cTOA490o
 jfVJmZe6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIjJOMDCcn+nFPWZjX5ePN
 x7z6tcfrj3NOL9yf+NnnVoTVrgXrSvcyMjQHXBAQvhmS2lkjH2+2O7VxgfSVQKvfBTFB2SnZP37
 48AMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 5zbb1dzntuwxorueujoo8weaqozgu3ki
X-Rspamd-Queue-Id: 3349310000F
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783676008-889987
X-HE-Meta: U2FsdGVkX1/Yi9xlPfDOklQyhGgCAR8HN/gSn79CkxuDEOaliqonZzf7j6wIVLt4c8kqKSF3q3YuxwMge+fEUB9DhFWOaweSDzir7oQpltgF57GGwx0j3uFlRBdWvi40pY1O63tLQ8kA6+2HWNvfVeBJ2EUYSUygQAkIPRp11JAQ/uyfcrPSCnhpyrbBOQtzI+aGsCuLpqibdObuu6G1KciOuPMtsJPmZkELy+I5AH1npZVUaeCerUTCb+U3fXz50kyPbx0zaL6L4uvxCPwCu71GI1r0KpOf8W/DlvlTOXzSzHy8jH26gs3Eamqmsm4aejvuE3Qlh7hoS0E25Hf9jAypMtoT4SxifJBrwF1HBjvcKngLqfKujrcOgSgQXGllmsoqgZ2Svcwv2G4ADFNaAXMP8aHK4AKMPm2MnjoRUr8TfAKUk6FxaRs1flnHOBlRBqlH5NW+Syp7x809Ht4fYp1OHcgKwf9CXBP3b0dDZt5h668nT73NuyRyG7Z1umatmBJ/N1TcJVszeqLGKp5SCKUglPSG5d/QO3iUrUCn8YDhjI5rb6YZ/inikRE6D2l4wIWMsszzyp9Vv0KnTH+X1hpmTOq2PdugyB2DbRoH3ob36VwR7sjHUNjxHqTAjQUUGtrMUcodZJaqoJIUGl8M2XfxsqnMwc1BLoveTwJ8T5uID04eqUQcDGkHp3pnEKoFs7RcWabC/WDP14ITVpwthUnHQtX8Fg3FNJoL1+GtHGxbN+xSQzF5GRTG/kTwqXbti6Lj1BiF+uDXmY60kRtfq4gNxHoLrYYMNWjwlI9+kWuOodBN3hBWeliFdYoPOjM5n1O6usb7hsDcT5lh5vpyy0idzWavlYeZLlCngJYMmAy+mvSQZSUQRbV3Oe5G2yXZLkXj+ERuhAbQUf+9bvOUkt3T5UW9jiNj/Or5lOo1PTd75dLX182lOXqFV4qwkZdBt/pQ0LsZUuJDKhWKx5B
 VgrZBmgn
 CSFiMO79WWmNZvK5S3Dg2o+M8Gf+r1Im1kGOSoIuJGhuA/JxTWD22ghQTc8kyKpjkn8Cu8ZkIdS4amNnbNlMtsdkbCbfyl0IwGliNB2ZZ/zO0RBWd+2PfIaM2xASBLhk+7m4ufUuhSH8U4afZLHg8ZOTeduV5spwJxkMraDXqh856H8amATt7bAgXZ0I2Q035zRxAll1NWf4bgQw+qwPfDBowRMTiDrlQUI4hW3BnCNgPR9Fjy0noVYK4y3uUFzgv2Rx3YLYca8JjOhUJM6yk43fVhvxUIM9G4Z34B/HAA5iHnmSLUsTztpUGJfM6WSEfcjWl3PN9VEBOimUPIRIbQVv6wba+0vfnM7JZrpdzb0VRt/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The registration string starts with a user chosen delimiter that
separates the individual fields. So that the field parsers terminate
even on a truncated string create_entry() pads the buffer with that
same delimiter:

	memset(buf + count, del, 8);

Most fields are scanned for the delimiter with strchr()/scanarg() and
happily stop on the padding. The flags field is different: instead of
scanning for the delimiter check_special_flags() consumes the flag
characters 'P', 'O', 'C' and 'F' and stops at the first byte that is
none of them, relying on the trailing delimiter to end the scan.

If the delimiter is itself a flag character the padding no longer acts
as a terminator. The scan swallows all eight padding bytes and keeps
reading past the end of the allocation until it hits a byte that is
not a flag character. For example registering

	PaPEPPxPPiP

with 'P' as the delimiter (name "a", type extension, magic "x",
interpreter "i", empty flags) leaves the flag scan running off the end
of the buffer. The registration is rejected in the end because the
parser does not stop exactly at buf + count, but only after the out of
bounds read has already happened. With an unlucky allocation layout the
scan can walk into an unmapped page; under KASAN it is reported as a
slab out of bounds read. binfmt_misc mounts are available to
unprivileged users in a user namespace so the read is reachable without
privileges.

Reject a delimiter that is one of the flag characters up front. Such a
registration was always rejected anyway, only after the out of bounds
read, so no valid registration string changes meaning.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 24142859658c..b7664d90eb8f 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -385,6 +385,10 @@ static Node *create_entry(const char __user *buffer, size_t count)
 
 	pr_debug("register: delim: %#x {%c}\n", del, del);
 
+	/* A flag-char delimiter runs the flag scan off the buffer. */
+	if (del == 'P' || del == 'O' || del == 'C' || del == 'F')
+		goto einval;
+
 	/* Pad the buffer with the delim to simplify parsing below. */
 	memset(buf + count, del, 8);
 

-- 
2.53.0


