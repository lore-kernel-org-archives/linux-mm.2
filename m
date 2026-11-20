Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68116606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=abmRvrgF
Received: by kanga.kvack.org (Postfix)
	id 7C6F56B05B2; Fri, 20 Nov 2026 01:21:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E786B05B3; Fri, 20 Nov 2026 01:21:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5176B05B4; Fri, 20 Nov 2026 01:21:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4538D6B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:21:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8B2B1A0D57
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:21:58 +0000 (UTC)
X-FDA: 85454501916.19.248FC43
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by imf05.hostedemail.com (Postfix) with ESMTP id 739D1100003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:21:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=abmRvrgF;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf05.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.135 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795155717;
	b=LLUowYmJT9RRLzUaDU/d6L27nsm5/YVL4vwR5LGfWAySFAX12G08PJSSoDE6lu8Wfqy943
	T/1lh03wFKrYdXytSGG79Pr8YXeojT7hV+om/JXIxLcNn++3PWPtpfF96sTKzJL2JPIic3
	dsTOZuGyisGaDE6ahAFPA8ERWXyL6cw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795155717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TtS5G+eK1OFnGUR4vbGgx9l74v6rzbgYovFHu3I+14s=;
	b=h7BRXpIAFtvF+0IKWKa21hd0C0XCODR/6bmigMbslc2fU9CgurdkQBTCErQDGwyRYMI2YX
	yCxrPkLz/oOQT/vaDXPVNJXdP/wjKKT4Ss1PltPdprqfW3jOFRzjZIbCdjLdb82/IldRWh
	ocXY/XVa3RBeShb7iOHeeswxapETNGs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=abmRvrgF;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf05.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.135 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=abmRvrgFxLRJeYPJUlt308R28e4NvjYz8lwDNKH1ZNoT9sCSXDIvkZeF2QWYxmjwmRRmDSW4md1mq
	 I6w5Ma5kU2GUYrehqRH/mtij9siIqPyD7IWPsbGzYlfKgdM2citAGWDeWwOG8GHEAeTiwyPcIZ4G6c
	 MS1oT9yBChBsFliA=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee36affe6fce39-f0e2d;
	Fri, 20 Nov 2026 14:21:48 +0800 (CST)
X-RM-TRANSID:2ee36affe6fce39-f0e2d
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from devin-VMware-Virtual-Platform.localdomain (unknown[10.55.1.71])
	by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee96affe6fa3f0-186da;
	Fri, 20 Nov 2026 14:21:48 +0800 (CST)
X-RM-TRANSID:2ee96affe6fa3f0-186da
From: Zhu Jun <zhujun2@cmss.chinamobile.com>
To: vbabka@kernel.org
Cc: hannes@cmpxchg.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	iamjoonsoo.kim@lge.com,
	linux-mm@kvack.org,
	Zhu Jun <zhujun2@cmss.chinamobile.com>
Subject: [PATCH] tools/mm: Report page_owner_sort output errors
Date: Fri, 20 Nov 2026 14:21:46 +0800
Message-ID: <20261120062146.98518-1-zhujun2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.51.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: 1ohskhnmy4qw96wzdm6fkmabsbropt3b
X-Rspamd-Queue-Id: 739D1100003
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795155715-347705
X-HE-Meta: U2FsdGVkX1/dwUN1jXLeoMoUERzAiL1rQe9xi0HlibpshRve7oAPWoZuMnTA/lgQz7xSnAanVkFAl6htVDpUTGColA1c2jfl4rcBwZ+sgcXO7o+E+xd4LkcR9g/wtWC+eugA67Y9HujViADlgH4nRKC62Dy+TP3mpTEEjijwWkFwSS3RjR1UYnbXQkWPAPsEG84N1MMlOO+aWTPeihrWgBcnGpQ3TxGFSzzsjxbmcDUXA5j5TJmK1gSJ8PmVEUe3nCSprn+kawGeE6DNNuJkmGDLZ5mOdiJWp1rHewYb7FD1xEdXoevAYngtRemdLj1KleTKcdK8PzMNmgJEuA8yRm96HIkMBpp0VmtlLJ5eMTY1/7efePW4YG7TYUC5lai6cNeabH+7YhnP4iH6kR+Er99LFWMOLgNeWFANbhPzPVZKKkZZ1QLs+GR1mPO1TnjvCgUO8l7th6bDylsgVEicmt2UlV2JcyUxyzgaPlCsgAJe043zWxbzdCvhPAGvyMETr8spAn0AHRGrmk8hRnGZnqRM3uFa7FaBwjcpjUSpB3tv2dtK91Ir2JNt8Zi2B+MLNMuL1EfiYZGo0GQc3/XhM9pKcxIbSusDT6dZ57ACSU9HthcQkZePJeIAUrCg9+nW77yXrmvSl3G6ibL5qO1jtfDe65Btpque5KEtIMCnl64p4Nm6VcuMaEjky91FEpBdth6IW95WhpT+Mh4cYL3FFoIH+zjEJZeCKQZWQcxOTc03zURBAiF2NJvKLLgRSzIc8dyJsMod0byW+c1JifWNFIrBAV+tYRY5Y1qiefsWSscgi0EEDyELiZakR6wSsMLfzh9QOFTGwxCwKitewW6z/2//lnAt+1bhHPIbi9oKBQ50uwWW0092ToNO01kFORBOrdNR2Kjkm7nl3C9Gs3jX9rpLTnpRdnUVBOFzQu/k5n4eWBLDYnJViL+p017SWkHYJjfkRwnnyp7KDLYAV/D
 W4KJ7rV9
 PvGKu9j3ZfCu/g5jiGaRLzPEhORyjkKb458GwdeJJBq+cOgGV79Hk4fvbzvrf4X7khYU6Is/0onEUNYj15MWy6q8dyYAbQh3nuPl4AdzoZ/4CbW4f+e+0bLAWwVlm5kJcO/yRuJRgkzYLo2QTf9fuXj0DUyPzW2nfLzjnQJZDVDVVxZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_owner_sort does not check its output stream for errors and relies
on process exit to flush buffered data. For example, writing a small
result to /dev/full returns success even though no output is saved.

Check for earlier stream errors and explicitly close the output before
reporting success, so errors flushing the final buffer also produce a
failing exit status.

Fixes: 48c96a368579 ("mm/page_owner: keep track of page owners")
Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
---
 tools/mm/page_owner_sort.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 48c403d3de4f..13166199ef0d 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -1024,6 +1024,11 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (ferror(fout) || fclose(fout)) {
+		perror("write output");
+		exit(1);
+	}
+
 out_free:
 	if (ext_buf)
 		free(ext_buf);



