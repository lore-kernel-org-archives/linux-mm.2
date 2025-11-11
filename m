Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D940CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7DB18E0025; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5173D8E0013; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E31C8E001D; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B73E88E001D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71A8258EAC
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.22.159647E
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9F635180018
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XqMCp+ks;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoHAGF5loUqH0LAFPRC8F4kXyPuIEz0vDtopK5rWb5o=;
	b=wofNBCu9WBysRF3SLtWi1oKjMpQ2TQ9FXVc+BmxJt40BOt+JTOb4KdxKZhgeGjr50nYcUo
	/8g/G1F5mbp9h8NXfGyb27GLzlPUxaxqy/0ao82qG2aXqaHIo055hxjLJWoKVFAJaGeX7J
	JrBelUteoe1B3AmA+F+BORBG4I5GS+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=2HIjepY11kOlqSIlGeLmmcqldKs8PLb58lJzyrBT/fZdT9UnC3hYhAmqkB0JzF00PlNeqt
	kl0QOpUUsBuKKMCU4r7iWFk67LQcH/Opyn4IWclTLF63cJE9Rg9bfqM2FVxuwFye0+K7RI
	NKxYOYRtmDesCLshR8h26L3wfb1Zemc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XqMCp+ks;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eoHAGF5loUqH0LAFPRC8F4kXyPuIEz0vDtopK5rWb5o=; b=XqMCp+ksCwtHsAxc3vOlMm2BUc
	Crr7QM0NFZWC+h5EJiUX7b0C4eorZyJDxSelasJeNRilwOKqX1onn9TmLulW/PLZTAbTtuBBe9026
	IXlnGKv8naAwkRak7PIahFF/jhRL/KVz1lNDiwxRlkCfDrG2RoyjemrjuACPkd5lHVt49BDGwtaAS
	DlcF+c5z2DoUdglLan7F9XNJ9OH5AJ2S53oe8R3vudDUMMA1pdyGSpqAFireguyYxE0m907oc75Ep
	3HsdFESeGr7wgdHVftqHeVTX0VrtHc0zQWVSj6D1dLR1tjerFHNGzTpWrp3HD7o3YiPcxrvQQRDyI
	kxOdGCEg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHl-0000000Bwzq-3whg;
	Tue, 11 Nov 2025 06:55:25 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: [PATCH v3 28/50] binderfs_binder_ctl_create(): kill a bogus check
Date: Tue, 11 Nov 2025 06:54:57 +0000
Message-ID: <20251111065520.2847791-29-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sb9n8tztr78eqaytex8ynrbrh7f56uzx
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F635180018
X-Rspamd-Server: rspam01
X-HE-Tag: 1762844130-768971
X-HE-Meta: U2FsdGVkX19+3yYUt13e2g5K7YtH0dJF4Ri1BqR1EliaPqmo9k/P1tDnhVNLxYuTih7wArn9BtyuPYe6sjf/emTyIin6IkC9SEs55W6xgfXOrZl7Jm30uu6OzcqG7spC5OLpqs6gGPvioVy/gXDq68s1+jSJpAwd+TU9hGE8SDK2UOdgtj2fhYmHyYoAgthdnRKRnsdg8HxmJDz5hK2DDatzL57v30HGVYqwQYYrelay4WmDtV3zM9wlQzL5iY6jJHJ6wCvXP8nxARwur7YPzEmU8M3adyy7PL03+qnQXNz1ICSy8rfScljnOSkWH8NtAWaeEgp5wJ3quugJbj1Ig/c5lQjyjIOts0EmV/xlEaljFbxEJsIdrV3wvLjKlJpdqCIHqQgN6XwP+4RZytmkLJk2jhsCFjf2jM8+kp0t6fcJjFUOLvT++456n5z8cMDGf4TsT4Rn8vBIibI69wNDnCziT2Ypg5A1W1LeXfQDPY2l7UWKJgKL8qOXkbkQVJSbOQqCQ9UAnhzkaXY+VjQdorcgfW5q2TykRR1eQM9oyxWLBpRc1jI0IkWW8MvIUNRlERIiVpsnF5t1ZN+3VdPDilnZqqEHvib6DqThOnARLNToc6z4581bAtMuw3/D6GXqajS2tHQetjvcSd6dPwEP7tTkXFG+3jJvVU25BXUaf0M0W5sm/A0uTOygNUqEYiyv5ozjX5IwBIjRI/lD/BVfsplu2WtfNSMg922Y2aU0gwSywqM4ylCJA43vN/5jvWcVDIa2fQrbhm1HIFSnwKoBT1oB2POgNKpQo9z81Iu/lUWjYPW9BD4B4421FWjyjJDHyltV4y3zn39wgJVj+MRl+NSrQHqyA3sAdMIWR1/CF+CcZfiHhW++t3g5Ez1YWjODg8rEoFNVqirJpF+SaLev/eioHcc3j6B3t0zBMbcZRueBsCdrHkadpkaxxpk646af62FuV/R2f+fxwnd6n6H
 CyLZ49Cc
 tTss+uOdAdehdYdetLCnA6YEL+WCWqYeSmTG36pb8y8KJwwQxmQPbE26CulzbrlsTt2TYnCP1mfLOykjwewqGZKSi6nXRJZIk2LkHUVv77t3DHHoj8pOvPzEQNH3ULcpjjoj1ciltDfIsBh5lzDzDDqpG/VvvG+4m5BUQr0oHNy3OYvD5byp9Dyh7JW8LEWg892KjSjALnLN6SEaRtndaVI/NbQ1OTNvSsaveYa6K6+PqbmXfp/ZOaO0dSM8243Xj1P762MfHNUc16QYCllF1E1NBP5NsHsqw4KFi/QHRuvrQmo5C1tOP91sJDQXfLVNa3N/jWnTABpnHVSSUZwTlE/ZuObMAtAwyIL9XMnRhHfHd3iYzneZujtSzCS3B60LalNynHZQ95EPVYxqlsZ6jk4Kr74hRLGU0Le6pHs0Q+Xn8Ad0fiEdRnZyRmZ2jRf1j4zk2zK8cL+Hp4qkV7tGv3Mz/SS6Zkg9cg/v+tw7oAdH6WIg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's called once, during binderfs mount, right after allocating
root dentry.  Checking that it hadn't been already called is
only obfuscating things.

Looks like that bogosity had been copied from devpts...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/android/binderfs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/android/binderfs.c b/drivers/android/binderfs.c
index a7b0a773d47f..8253e517ab6c 100644
--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -397,12 +397,6 @@ static int binderfs_binder_ctl_create(struct super_block *sb)
 	if (!device)
 		return -ENOMEM;
 
-	/* If we have already created a binder-control node, return. */
-	if (info->control_dentry) {
-		ret = 0;
-		goto out;
-	}
-
 	ret = -ENOMEM;
 	inode = new_inode(sb);
 	if (!inode)
-- 
2.47.3


