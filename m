Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 635B9CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3586B0095; Tue, 23 Jun 2026 02:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B4E6B0096; Tue, 23 Jun 2026 02:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24276B0098; Tue, 23 Jun 2026 02:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92D4A6B0095
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:53:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1828F8CD47
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:53:02 +0000 (UTC)
X-FDA: 84910260204.03.2B0CCDC
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0E7DC4000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ugukt4or;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782197580;
	b=uWoUG0FyhZ9pEj/jGhWSeW4JjxY7JwQBBVV7DhdHcU+ZJokytzrJ+f/jpb6jPTKCQdvFvu
	Nc5Loj9V1DxREHEnaVc63el8QQqzI2lZgyHI6DFCS0YUcOe5nbsqlp61jkfhsrNJ9ul3nF
	55hIred5RPZ+/eRZ3BpotqLRT9AoYLE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782197580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTLHd+1oM45Tb0ayVFKU2fogrT4VnS2NCHonHOYwY8w=;
	b=rx7ySaSfGlApgGqCSWG62GECxzbHwhLmGwYOGy2E8PTDqVAYmZyyQm8EujG8oTSLUFnTku
	TU4wrW1XMHTRn9bjOUIA8SN/XU2kZ9q9e6u2Dki5iR/znecMreCTKLH4PeViZ2mnLFiZ0M
	pwpTW2hkbmTN22IjmtOoKS4JZBLZnUk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ugukt4or;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782197578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NTLHd+1oM45Tb0ayVFKU2fogrT4VnS2NCHonHOYwY8w=;
	b=Ugukt4orz9/h6CKbhSueVDUtSTJA/a0Fzz+6i4dek5nPdOHcgiPahsP++ZG8XhzhVMaKic
	b9Zfx7ACe1rX8nH88g5a66QikcWvHToBFestsNxco291BJbJzOK6nfBxfIazhgiEOHJ91f
	z5OkN0zEjPBmZ1Pl1W+x8GJzmk4A5TQ=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] mm/page_owner: add missing newline to count_threshold format string
Date: Tue, 23 Jun 2026 14:52:29 +0800
Message-ID: <20260623065234.31866-5-ye.liu@linux.dev>
In-Reply-To: <20260623065234.31866-1-ye.liu@linux.dev>
References: <20260623065234.31866-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 4rs4xsjqmmtyn1zfh6pwj9qeteyynm8n
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0E7DC4000B
X-HE-Tag: 1782197579-472766
X-HE-Meta: U2FsdGVkX19Q1ChT9J3hDshn3HOupaFzG2S6n21TNHK7WqQxpKk7B5VqjW54cv1huvdmkmzZFtKDE7kTAr/6I4CggwUSQfoIflG6Od7hdLZU1GMpnBTB7y/pHKaAXGKeyR0TuiApbH8vekOwQdDmlLx22YvmAeJmFQMDjQWgxeZILP9E4Jwlbpbc22JVVqsdYCp5xzBU+SSJgagjdYkjli0v7iMXi7J0RtAsEuH8rUrn46QAwpvaAOw3/0LtA/rbSzKgzuV8PZO/iECAcaMhvlv89Bb2b45h2/bJfDaqjJrxNjQOKOb5HjFDfoTxUrVy3PvUd43Sc0pHRiDP+zjA5A56/h10vAlf5m2ereDVRYwqVw/SR3e7rtG4IWZJ9UVFy9dxXt3Lt6CwU9NLBxciEkSEvHkVUj9s0rxxalqwFKuqfNVmjnkaciqE3NpeviGK4LhWX1J2k3wlR+C0oSF5CAuyS+Z1DDv4bteXUFjs2BOGU79pEsrHTqpBqa+nuV0HKVQ+s/x0KYhH7ze6rIu+FSyNow6e0WcSA4fVUpPsJh/vNUxGvKer6cw+WTWvvVf0aX0+eZuHUGxw6VZVu1qw0XMMFaZaTI8x01Q7otpyeZjLXsZT8DU3rWF1kVZ1pBGSbVqznfuf5xEDNRa4PNHPBqJ2Dw1R4c4asF0U4ml2bG2hxlFJt0T5yVgRFaHNoG/WjlUDuSjQ2tCNl1T+eMtEGV/2/CP2i8W50eelM3B1b2fkcKc/4998kFofiIb5j4kysile6MDdRAGnWWntCr84pYZbC4LDL34y2xyzcTjPEiMONvwsIZcm4sNU+1xOq3udw5VQg9MS9LLP+nzi3woHZSQahV+e+J59S4ZXvvmsnNwabiPMibx0AkCx1NhxUSckPe9aKgUHb5OOrGuXmrP/A+fqXp7WzRs6TuothnsYH0D5PjpZQPCK/3xu7udVOeFgf5st29rhnaj57vEKo1v
 8GYiysRY
 F+pbinELBTWxwGVh65Hhy6+ntJxhI4qzrwjn6uwu8JLmjE49FqXzHxfc/yjV+5hnbn+q2EDmjgTjJRxuGYWMtQJLHp+JEj6ECGMO9tXbr1/UTWARD96m/8QNLyitvDPqCZV/Bc/UTBeyvSyDIuU9griMn10nRJ00TVRIIW6uxnKH3a5tzftiYrm6jMZgM3/gNbbANUA7chMV1jCDvxa+eGbNZMH8Uf1YvyAlVlaKEHCscifZhJ3+e4RWC+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops
is missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the
standard debugfs attribute convention.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 5d8773c90cd9..958151ccb587 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -981,7 +981,7 @@ static int page_owner_threshold_set(void *data, u64 val)
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
-- 
2.43.0


