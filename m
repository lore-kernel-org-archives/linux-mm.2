Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A20EDEC1B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 07:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2516B008A; Wed,  4 Mar 2026 02:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570E56B008C; Wed,  4 Mar 2026 02:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4808F6B0092; Wed,  4 Mar 2026 02:28:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 388D56B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:28:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1E09B96E6
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:28:12 +0000 (UTC)
X-FDA: 84507552024.17.92464AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3599CC0003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:28:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mj4r4Azp;
	spf=pass (imf28.hostedemail.com: domain of devnull+maximilianpezzullo.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+maximilianpezzullo.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772609291;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZiMkd8gAFAY6M23FWY4CNybQVyGBlD8lKKIn2h83Ou4=;
	b=WrkjZhxNz6C6dFuMh7Zn9Uph6sOmawP87LPYW+/eY9wUnQZU6B9qAqE5toll17TCPC+AvU
	BhdCWWInGoZL/TNFS4O18pdcBNtnLAc3pRQgSFVJvkOWRZeNJqbzrzEFY/jO3FsVRBahXd
	coDKIdkcnLP1hJh0T0eehWVC6+SohNI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772609291; a=rsa-sha256;
	cv=none;
	b=OFNwO82v6bjSQ02IoCP2kmS/LrP1Uf4jSyjZFcCkJjK3Inxj3aCDatelbHOhukEPMEofpv
	Y4tyKUug0a3lR60pkb6CRXwV5kKA3sP8AaHrn65QtC+NqG4zQdQUKYZQRN5eOkVQlnqmJ9
	qDA0dyTNwlAghE4MQD7G4qX4qjdbmoQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mj4r4Azp;
	spf=pass (imf28.hostedemail.com: domain of devnull+maximilianpezzullo.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+maximilianpezzullo.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68DE460097;
	Wed,  4 Mar 2026 07:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09779C19423;
	Wed,  4 Mar 2026 07:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772609290;
	bh=X9lIunOrna/iIZwoPlS1GBm2SgOAKz0WSDrE8Dnqyms=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=Mj4r4AzpuiAjxRfG5N+kpumkKOANltMWs9HMI6BRKe0v4zOi2Qyk00Z0jCi0HY0cV
	 LAxnzJd1grHLHMS+sCBIx4S8QfJ5de7AQ7jBDqHkW7sLaw5Kv5oydFz5GkYjuftu1P
	 vmhKROvK2RMN0rpSIpgskPlaD/uL5akQxJaYXWlp6oiNVGv5lalVHxNlKO1toHLDCJ
	 oFDDadnrw2qIm49xSBxeYU4nYbUNaiYZ4/NK1Z6fVPbj4pupmWg0w4/CJAhSNgFw6K
	 tKRrucFZnMgFKpBfVrSHtAoGHYcOSP6F/ZWKgt75GQngdaHwkGajwC28eNigeVslt+
	 kb5yMsk5P1abQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB8F2EDEC1B;
	Wed,  4 Mar 2026 07:28:09 +0000 (UTC)
From: Maximilian Pezzullo via B4 Relay <devnull+maximilianpezzullo.gmail.com@kernel.org>
Date: Wed, 04 Mar 2026 08:27:38 +0100
Subject: [PATCH] mm/vmstat: reject zero vm.stat_interval to prevent
 busy-loop
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-mm-vmstat-reject-zero-vm-stat_interval-to-prevent-busy-loop-v1-1-c03c9555ff15@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2N0QrCMAxFf2Xk2cCs3QR/RUSyGTWytqONRR37d
 6OP53C5Z4HCWbjAoVkgc5UiKRpsNw2Md4o3RrkYg2td3+5ajyFgDUVJMfODR8UP52QKf+4sUTl
 XmlATzvbHUXF4ljdOKc04UOd9T53bE4EVbHGV179+PK3rF2FrJJaNAAAA
X-Change-ID: 20260304-mm-vmstat-reject-zero-vm-stat_interval-to-prevent-busy-loop-ba5446a527aa
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Terry M <terrym3201@bugzilla.kernel.org>, 
 Maximilian Pezzullo <maximilianpezzullo@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772609289; l=1836;
 i=maximilianpezzullo@gmail.com; s=20260303; h=from:subject:message-id;
 bh=qPVkk+RjNot6d1aWiuzGeSKqQMeQqa4dNJWr0ISRIT8=;
 b=8fIpGxrHPIjYGDUNowEueBvSdu3/qSDNnV63gL4/GDUISpQasaYU5bPCTo9KPkXdNirrDWSy9
 6SqTQxrYgilAzGICa/sFavlePMaT9YGB/y/IPJL6frSt1jLWjtDo1ar
X-Developer-Key: i=maximilianpezzullo@gmail.com; a=ed25519;
 pk=TRTR4c2Vb1IfluQvv5OUDPg7EE+pIzdPBND85UU559w=
X-Endpoint-Received: by B4 Relay for maximilianpezzullo@gmail.com/20260303
 with auth_id=658
X-Original-From: Maximilian Pezzullo <maximilianpezzullo@gmail.com>
Reply-To: maximilianpezzullo@gmail.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3599CC0003
X-Stat-Signature: w6ndu8thc8z7z7axmjfb4ygpsg75o6zf
X-Rspam-User: 
X-HE-Tag: 1772609291-357109
X-HE-Meta: U2FsdGVkX18SAtJygLIHlFrvoE9OpgQGZOTtl1H50bLUQjisi/fdC1ydzbiQzImf1UvgtzhqN343EQVjFpaXNgRPc+8YkiOpKHCCmw4aiJdmfany80d2N1Ely/RXji3gwChTnAWl5PSBMhDcbZprpaGfUFvhb4HiAeIoVEd/nOe+fuqJA8x2g0hYhhGyyllnx8WoBlFDInpjXA4rDRkoavxKRGZjYcZGtJ4oakrKteNCx+F40x0kFj5Q6XD8CzxMeWvH7T3oObhmO8qho9ZQaz4lb+/nTNzvdX9I8da96SIQjaR21QQgVccpLTLyfWG09oZNHo16RooVmKLezw4AtQ1tEWC6fw/215e2IDAYkWRBt1W3mr0dg64Rx7Z3gPNysy1FvHRh6tLy5eooFJKS5gZ2Mtv7ItfoLTnHxtZqw0n4k9y2wcCrP+/+cx0Rg93dawIvp+D1PKnRh9VXa8sryvnFFKUmeawcYLe3Hy/Uiu0c5cRlDvV2wZgFqrAxwpMfeWZ+zGchkw/LWsM/bF0tHaFm84aRy0i1rFYyA3KWlYhDLHiqVQsYB09vrbic4w/tRb9+WsRrILXuyoY/OVgGDFgzwzBxaQu2xl7uA5W57HLsy+J9QWnQob8sUwo3qxBYekXGA57I0/qYra33VTX+ElBfQiNt+JuZA73jQs+oBVjGNmMZy8w0p0GxmzRoS2w79flWwewddHvMJPhO2lLAgqwF0BWte1jMCJEAnb4HCStlE/fUw9T1Pur6O4DP0BWAsPIS+rW9Y7dn+BYi4Ewq3nnK28kkb7gAY6zHXMkfc0zkVg3nZagvzBULF0g+kI6wiTMmrNUUayxX8ZIdnV3IFYvIhzTDK1/auBiE6Pe30N+L9XgwAOw3wJvwl6NquM4BMN0wmGhzPWvXVNUANWWpFbrWuK9hL3QlmcWuKEBc5b0mf7lZoXustXMwPMEruyjupSOFSq7vS+LrWujm3cP
 qJnM2Yrr
 3rsk06/DVhoX8MvgIoyOC4Ef2bR/KrvbGYj5T5QG4W+jHXZik8Kr8CK8O6M6qakWfgJXItJorE2Y7gZqDp3lgekarvvqmPCGS9bUuBhPPFYrLNJ2TRqCOeYC7Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maximilian Pezzullo <maximilianpezzullo@gmail.com>

Setting vm.stat_interval to 0 causes excessive kworker CPU usage
because vmstat_shepherd() and vmstat_update() reschedule themselves
with round_jiffies_relative(0), which resolves to an immediate
reschedule and creates a busy-loop.

Add a custom sysctl handler that rejects 0 and restores the previous
value, similar to how dirtytime_interval_handler() handles
vm.dirtytime_expire_seconds.

Reported-by: Terry M <terrym3201@bugzilla.kernel.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220226
Signed-off-by: Maximilian Pezzullo <maximilianpezzullo@gmail.com>
---
 mm/vmstat.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 86b14b0f77b5..6eeb4341b215 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2114,6 +2114,18 @@ void vmstat_flush_workqueue(void)
 	flush_workqueue(mm_percpu_wq);
 }
 
+static int vmstat_interval_handler(const struct ctl_table *table, int write,
+				    void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret = proc_dointvec_jiffies(table, write, buffer, lenp, ppos);
+
+	if (ret == 0 && write && sysctl_stat_interval == 0) {
+		sysctl_stat_interval = HZ;
+		return -EINVAL;
+	}
+	return ret;
+}
+
 static void vmstat_shepherd(struct work_struct *w)
 {
 	int cpu;
@@ -2236,7 +2248,7 @@ static const struct ctl_table vmstat_table[] = {
 		.data		= &sysctl_stat_interval,
 		.maxlen		= sizeof(sysctl_stat_interval),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
+		.proc_handler	= vmstat_interval_handler,
 	},
 	{
 		.procname	= "stat_refresh",

---
base-commit: af4e9ef3d78420feb8fe58cd9a1ab80c501b3c08
change-id: 20260304-mm-vmstat-reject-zero-vm-stat_interval-to-prevent-busy-loop-ba5446a527aa

Best regards,
-- 
Maximilian Pezzullo <maximilianpezzullo@gmail.com>



