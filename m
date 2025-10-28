Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D213CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 03:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A66D8010C; Mon, 27 Oct 2025 23:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45730800E4; Mon, 27 Oct 2025 23:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345BD8010C; Mon, 27 Oct 2025 23:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 27AC2800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:51:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC36612A822
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:51:35 +0000 (UTC)
X-FDA: 84046148550.17.10CD093
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 314F216000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:51:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=sUSJOybj;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761623494; a=rsa-sha256;
	cv=none;
	b=yW+nR2n52LWC5b30PWTxq7byvQIuBTAEkl7ou7/N/G9Dv6y0FaQvBUF2BXXlQS6OYgOqvQ
	cJOy5nvWjG6kjrahorc6dKmr1LOfhejFMF4xkV2li8Rg+GxRbqcnnmloKZOT4x9U3dqEkD
	eRBG4V0jtrEd0vYH2L6hbicD8MKLNmM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=sUSJOybj;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761623494;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjABcLkX96mDLYP3tAGhqk752u5vTsDaNzggixdicbg=;
	b=alUeXni7snfaNRwH/JyBpgQG5+sptKzB5uaEjd5KvpDRBUx6UQRYhgtK458i3avshZrE34
	JbRKpnmDmyy5JnwTAbayqznDgzbSKWuWBD7UaWpVfjzaDva9qLA7VmIRSuSJtYwu9TAUCr
	++Wecx9OnDGNPwaztufrfEWTJqQ9KMI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bjABcLkX96mDLYP3tAGhqk752u5vTsDaNzggixdicbg=; b=sUSJOybjZSquw0aIdYKAiSQYOT
	GwWqmw+Le174gLr73NQueXN2zWXOWWYpJuOr7pVusWkGejLfCcDDWvCrGglGAiNXfdzzbSeDjILoj
	zFRVRH8p1ZsLKxvYHkU11NtWicY0w2uqaju6nFXGfdwQGvBR33ugm/dqNWf5uMvgAeAnaXjAooiZB
	KpCavnvH0eyGf1E2z0O/JSi8s76OMdZEax3TS9Jbi1emAT0LyUjHed1GDLDsBkfSWw1EKZCPamRwt
	n20m9Gkn5bSWkiFE0H/ieHG9jNW4qTx0No/FD3nYrH/hPfoo57ueM9EcNY87ZYzl8MXPkl+bkre79
	0pReYUJg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqw-00000001eq3-00Tt;
	Tue, 28 Oct 2025 00:46:22 +0000
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
Subject: [PATCH v2 49/50] kill securityfs_recursive_remove()
Date: Tue, 28 Oct 2025 00:46:08 +0000
Message-ID: <20251028004614.393374-50-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: djdzqk7g34wyt4zi8eyjxm6zqy5rx3e1
X-Rspamd-Queue-Id: 314F216000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1761623493-439152
X-HE-Meta: U2FsdGVkX19BwbfO+dRxrloB7l0S7Gddih4R2YuGedYB4VKbU2kh3v9VZkixfQpJu21k8MMn8NT2Upkyrg3NlU3+ya3IBCxcBnUzCJ9xNovWJD/94GVKrYVUnASgqRD5VVyI8kHfEVSZB1wH7k6BNGA0ckM1mi3PlI+S3IPeePFVFBsfeyLJiEDedPZLEl0aql1bouXg+EbhlEf0/Q0IpsgM+lsUKO8z1qkMq+9F0tIbZ8IxoXtmCUczsbH8Ug/vJvqwecoIgVKHRsJ7ayhRKNU6LUP93eP82/4zRrnwZob2KPQkt3yp8LeeAtx8VqWm3aaOER1EdLItQdATV1E2xFoL6BZ5nfl8cDVrYuz9S1/50mEkMyU1KzaEAhaAdO8Dh2Qh84axbAVZV76+K4NDpbXPJM69cGq7xtYyYfXV4/KAUiW6oHmuQfkaxhYDTLbc+LHICEvROCeTY3QM0qmcPYt5oIibQv6QjP8r9ZIupgBjUKnB2PQIF6ohrMobsmKzAzlAiCNZOFxAHzUWBqmWA1F+v37X+CWINOj4kKXyO9QKT7M2d43GrrxXZO/O+PQU9jfCzfGG6C3s8A6ZtfDGQM/J4mcElWozgUqjcL/y3Gyv7kJQ0QTcAwf9ZtRE7mssH2ODsc0Nnbf/mVDbCSLpv3Wfq/U4/4eC2GZd61u+TA0XM7VsTxx9AX7hECXqe41miJcLSaaoxJ96dJkvhvU/LHv6lXBfgs6P+xtFNcI8RkOTHwokxKesaC0K8d8wA8Hn7ycBxNnriGDk+4vmq3e+WAbtRKfv3cgaQQrr77pip4MtzCbafPzpcYeupKaELZjeDBMg4yNueW5cziPKOZylzkf14zYEUUg/HJ/OUoVbrrI8bDThdXeEswcKgf7qBdYxJjhHjApuP3S7KlXc6OcAsD6gjabvSRKUP76NAX3mnj3Nq8ezKS8wBbUPVDIW23h4DQylKKjRkqy8cQrbhVF
 NVcmZ3a6
 S3cDXrvfddTi1zuZkOPZPUnfs9CPymxgdwrBB/PfcTj/6KQfjZoEaGQB3ZCXkd8ZEpPG4lF46oLBZWj8NZr6U8oWOvAru4xfa/td76HHS1+7zfWGESzS+XENHcYx2iJwACUBqmhD+LeCsvcfHOe78CeDuYvTSclEAaTYhEbv54YefzCFDKOtyYbSOtn+mH89EqiNqLm1F/m4g6BMH1ycV62QFm0be/AP26m98HhuTjC/vIGxy7kHlwovATPVpdtiYiPl3MRHzJKM0ImtKzMkIBNNG1bxGERZ0w4Ee68kn7K6jg70vME4KzhyDL2/vOKJDGJSzeTVJQf82C0B3N8JRkb867VhNOWqHzdBWbVInr5p+omF54PCQMpEmtAY3JhBjxNqh4eak19dLn8HYatPHtdDrk3Bk75bPhxcZkkGZChrdynMoX5GfT4R655+vkkDAEzQfvrVbJcbE2iPjy5mVGBwGfPriGVWXxKH9CCx4EWDwowLYXSslCRqdHwSs1goLUirSussldxIKuZbV0ZAxaQNsPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

it's an unused alias for securityfs_remove()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/security.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 92ac3f27b973..9e710cfee744 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2258,8 +2258,6 @@ static inline void securityfs_remove(struct dentry *dentry)
 
 #endif
 
-#define securityfs_recursive_remove securityfs_remove
-
 #ifdef CONFIG_BPF_SYSCALL
 union bpf_attr;
 struct bpf_map;
-- 
2.47.3


