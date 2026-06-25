Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1EDFCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8AA6B00A3; Thu, 25 Jun 2026 01:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63706B00A4; Thu, 25 Jun 2026 01:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC9F6B00A5; Thu, 25 Jun 2026 01:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6496B00A3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 07C971A04E6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:30 +0000 (UTC)
X-FDA: 84917254380.05.C125AE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6C7121C0007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhevelcq;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364108;
	b=Hn0p6llXaZP1vmopTadg8lVhA7l3BIp7uo5rabJtS5ja1IQmIvqbmMhf5PdyJMJodUlVqO
	bWeMeGIX3N2TcJiDJYCnetjwjiLN2SLYqV+44FSuCfFXLQicfkpAV8/ZOlhnOWysdTghsq
	mLLO8UwGE+oCO7uOs+gKIFJwVPKQXs8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQV3GfOG7VWGJtv7W6ZwKyzWFgMIO6rC7OdU4Z34lgE=;
	b=JHrcd8GrxX4kbT/pDCTZuq7gDa41rmyST1dakOeNplm+prpJCsfe0ImWJ9fX88UKuX6d/d
	rOjvpojAhaSy/mdl5UbwnY4DUogXZxZZVPar32uSByk+xJbAQcBYolT/YNNp3c6rtW9i+A
	+FkpbJbe2AMd0/WYSBkEkq3JQr7Dkho=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhevelcq;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FAD260018;
	Thu, 25 Jun 2026 05:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAA01F00A3D;
	Thu, 25 Jun 2026 05:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364107;
	bh=sQV3GfOG7VWGJtv7W6ZwKyzWFgMIO6rC7OdU4Z34lgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhevelcq64era/6pxT7EePZrcWe7Fj58AEygJmXqmsyOHj7e9N2U9XdcW23kB+J6y
	 6zelKo67pdkntEByDGfpEJJyMrRymy86tDrk0DdQ7OMxEQhhFypV4w9qxP29pwizC5
	 X0MNQ4FTsEB3qrociZXTL83V6tpnE3/44rIJV7tSQukq/q9iUp8oc4pdL02vEV+uRg
	 TOprJwnU3kTSB1rbs6z77SU37b9C2Id5o0XhVjFzOJnpfSPwR6zFVZMZCSByAg+5HV
	 oO7C88H7yXO9nxv5T2s6+W4VO1P6PtYaJdiXXZbbL6+0zGIp4pWcgz8Ne1tgHrfXyU
	 23j2/dcOqJiag==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 11/11] mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/
Date: Wed, 24 Jun 2026 22:07:54 -0700
Message-ID: <20260625050756.91115-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625050756.91115-1-sj@kernel.org>
References: <20260625050756.91115-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mhuh99qtg9mgn6qqd3f8dqmbd1wzabqk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6C7121C0007
X-HE-Tag: 1782364108-795232
X-HE-Meta: U2FsdGVkX1+dcd3iv3HHPin3R/qWJExCK9XS3V+aQuE+rSGxsGOsZ7VKSxOkj//dPqTB1kjAwEIxbfOBxCAzQiI0w/ApcSRbG6aDwmLC/5sh3kALFzRCoW319O2ky01L8VA5vWCxceYbWJLeMeJaL+BQOUZCwFQUU9N7TaXkPNEbJe9T9dUm3uqsqKOy0oSmJyQ/MbgDPDy6KC1nODtrENRq1qYug4RE0bW+bYNAWlqfQwxmpsX+JhAt5+iR9FOadbG7SoJ0tsFTYNo4pLax/wk86fvcGJxtU9wLRpZzpEzwi/Ws/3jfufRao5lgj4pLuHMP4Tqcxg3kXDKoq7NkH2YcPebhs3iVoTrVVZi2h4M5z0yDInyzJ/1rPrwW26UTW4AiGi65MFkCq6WhdVfZk8WCbsDuMswb6BVm/0DyPvjIjeUDn9P086z05ranZH+sB35OKmTv1U6eyqYN+S0TaAY3zCIWkASI9KJZjfP3y7TdqRuTrj04rdRXu9vRWGOKsjLXsEpKDYSMe9BOqvgFIswiajuEz9n0ZbqoNWDIS+WGv7lvO2BDeW4t34zzzT45WtIxA9ZdxNiCHL2tSSXakyX/bPtwNHRLbz0DShjKsQPivWigl8wzNsCMvMfAuiQ1SdEP1QfegI5gJ6tMPfH8bBfkVvcLJKDPl6mEgSRnRENAnpuL2Gu0T4gbmCPSyFu3xbhykwrew9OyuigxIx8CS60rl0WLhYOdL2XBszjvHNri9qP8g+kOVVH8Oac+2/XOWKbXbZne6ca6uCV1VjrgGIqLy0TqeGze4vaL3+fVRwPfZiSEdN66VoL9g49FA6prf0GMVARcWzkr05qWI0x9npAb5teuSrfyWwfRtoeopRx9pNQWTWpGYuwIwL5T/TEBwro1INvFkU/WWSolNSA+tMT9eiqOQbECldu5OblHRd2cHoI92VSZH078xNaWoi1uWkNFtZoqchTicoXwpV/
 mb0NlP2p
 fPXTt5TCPAK8keWO2Aa4IP2NAd3ZeA1o0kBcUfW9kagbO0lBj/IjOYy4gm1/MzmySh1nP2jLERT56YhiAB1pWbrBcvuOO5P+65ZYYEOiC2pSdt+qEfVLq5wPtBXRT2aWmIBA/2LpH9LEsJwH6HERUGgL86PocvH0X6LXVK9Ns7b3NHpgTssv/GFg5xqpI5CCE5NtH39fSexDHII94T4dyAj17Xx0Ar+OsKzI+cjvOxAWMSFyTpgDiYRXbqSNdwF9s9wcuVFNdj1PDLoxLMZciFb57SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_probe_{add,rm}_dirs names a variable for damon_sysf_probe
as 'attr'.  Probably a trivial copy-pasta error, but it makes the code
not pleasant to read.  Fix those.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index f3bb146b204df..36d71f1675426 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1068,7 +1068,7 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_probe);
 }
 
-static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
+static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 {
 	struct damon_sysfs_filters *filters;
 	int err;
@@ -1076,22 +1076,22 @@ static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
 	filters = damon_sysfs_filters_alloc();
 	if (!filters)
 		return -ENOMEM;
-	attr->filters = filters;
+	probe->filters = filters;
 
 	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
-			&attr->kobj, "filters");
+			&probe->kobj, "filters");
 	if (err) {
 		kobject_put(&filters->kobj);
-		attr->filters = NULL;
+		probe->filters = NULL;
 	}
 	return err;
 }
 
-static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *attr)
+static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
-	if (attr->filters) {
-		damon_sysfs_filters_rm_dirs(attr->filters);
-		kobject_put(&attr->filters->kobj);
+	if (probe->filters) {
+		damon_sysfs_filters_rm_dirs(probe->filters);
+		kobject_put(&probe->filters->kobj);
 	}
 }
 
-- 
2.47.3

