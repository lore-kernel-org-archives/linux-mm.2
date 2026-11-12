Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45A7606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 02:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=o8IXSB74
Received: by kanga.kvack.org (Postfix)
	id E6D076B05B1; Wed, 11 Nov 2026 21:34:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F276B05B2; Wed, 11 Nov 2026 21:34:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33FB6B05B3; Wed, 11 Nov 2026 21:34:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B37996B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:34:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 383FD404A1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:34:04 +0000 (UTC)
X-FDA: 85424897208.15.6FD160E
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4057840003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:33:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=o8IXSB74;
	spf=pass (imf04.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.137 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794450842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYKihU0pHL2+b602qOoekQ9OcZw08O4XsCNRkmiBQCw=;
	b=v1cwkOI9ORR9frGIegeD4YvKmbfMy6qyZhCmSbsAOBy7O5vW0/RUKZOJ0HBEsB50gEJVc+
	+NhGvi8NLHVrM533751KBy3/9ALcrzh0WdIe/L0cBx07QmlOshjxdqQRCyUs9rW4Nqpb+L
	Ll5QLzqnXjT2ilo7ceTNVs9kCe8dXjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794450842;
	b=Q6EjuhtfSJszs5mGKJ8v2HIBP+1PMhlz2eZAvMYiRd3jMxa9rSfk9kKBVNVtj/2JOfHv+z
	XQFYKFNLvKgBUSJ0//jM7PG0v7UssZjm7mom1KKPhlXlRNnYD/I0WjICgsF14xDoDSv0+W
	8KzOuXnsBlPGpeh/OS1EmjcUAuL22dw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=o8IXSB74;
	spf=pass (imf04.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.137 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=o8IXSB74wmd+uc8pmDKp0Au1EuB6498W7FTB1CVqxoUxpCvwQzgDx480XrVHgoxUba8nIfdpSSwwo
	 eyxOHkeqx+HSCuZvD3sQjncuMFx0JE0ejB3HOdF00XSnPNBLAA2z1exn9dgJBjtWBMz/D3yHF81QyS
	 gQHnQTaxt5dNv4Mg=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee86af5258d60a-7c876;
	Thu, 12 Nov 2026 10:33:51 +0800 (CST)
X-RM-TRANSID:2ee86af5258d60a-7c876
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from devin-VMware-Virtual-Platform (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea6af5258da4f-eeee5;
	Thu, 12 Nov 2026 10:33:50 +0800 (CST)
X-RM-TRANSID:2eea6af5258da4f-eeee5
From: Zhu Jun <zhujun2@cmss.chinamobile.com>
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhujun2@cmss.chinamobile.com
Subject: Re: [PATCH] shmem: Serialize fallocate progress with writeout
Date: Thu, 12 Nov 2026 10:33:49 +0800
Message-ID: <20261112023349.118385-1-zhujun2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <1291b635-6dd1-4887-bfb7-075eee45b7f6@linux.alibaba.com>
References: <1291b635-6dd1-4887-bfb7-075eee45b7f6@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 5o75pz3tbreo7gpwyan3469wg3ofm6ok
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 4057840003
X-Rspam-User: 
X-HE-Tag: 1794450838-481330
X-HE-Meta: U2FsdGVkX1/7cIsB5i9sFuOP9jt1B0EOgQnjqvb8v9lq8yGeBoTKoJ5Clp5+EtVCHCRt7L3c0Pl8cn38NzGUJZwztejmPXkr8v8ktHAxqWFCvobT7zIrJZpZj5HLW7X5sTQSAHz1OAR23t58F1+K22h6XaTLYHdgqM20DeGVfE+Ca5suapYuOCOD0ifClQD3fcfi+JI0Xh53iPd436+8HFspNUv6x9EDQmJjUGldDV7FqVt/QDK7JzUMnDZlzqlRQQH0laA9GH1h1Eunw6Mx9FyDUkAqHfd9YX0R67Fv3C613/x3gxo2gWSGNHNSUWkbxcP4ONxr+IUkr160D3ebWJNZ2Spqb2fdyc7NgtgH1nIgnb1W54Qx0uksyRr6qacPxvN4+UF3L4I/2+y+d5BA+cJC+kmCBanYEWCmWVdg3Hw7SuE49YDNqfKnK8gzGEvqV+0N9s3W5D6ngecJzGEMQGCuS+s9VIu+Nvq6c/xp0gPrfAq07JuuOUlwUHwvHIGQVyWVjND2ojrGTvuWFf3VYsUj0QWY+c0DIunlBmhX1S6ebP4pvIGKYXnT3EgzRAu0fwipHsazMaG/k67KyRZcQw7I/R7x7IEnTTHBorH+ddaE7StuOzvrbFoPIPV2TYyN15B2V/9iPEhYIHjmntfIvnRIEDxf92eAyTiK4vo5GeIkjPllGzOjCH66eoMZ5irXrenM7Z+tnYgvngq7HNFSmzAOI0u2mL/qvX8TuUR4GdTyQpy2L2RhRKo4jSazHmknDHKleLq8e9isRs446vlKxMHt3jf2TpAZ08QigBHrccPH8+QhNOc7xZLTdU4BB6O49+xfIdJUm+2o4HEiwAwGcKSYmf3XQ1gXA5iKXtmrUffMIOCx2McsaBKHIYxEG5EFF1BqXFNbF31wsqCtzqxQc1lRBkSvRcPopz/eUh/RLWKFbhLtWEPMb2BATBl95w9UAEoAheyZtA/k/LgHWPN
 v2/IcppZ
 wqA3+Q7MwU/vM9K/az1hoRRxicbkJ5g02//JNRJMDxUz+zHgt1dckrGFf/pYkUBa5NdHSjzzp5boTHoLNyv/t2X11EUQFUwnV6uVvE82CE3wpyycXGd70fTqZCF4RSoUWCcLT7mmhIDYWOrj0qUQV3WfDqd8GmeqCmyE7pawnSdVrw7ry0HX2Xp+fDUe4ifZHEXUmsXwlyNeGN18D7GH82QihZA0kBIqUiswAOsDTQZSxiGjCmEgGJUIQsNHvj4/ahxsgSfpjttImpDS8oO3HqHUchVetSipFk1z9GKMm1SStcGyWKjkeK0vqlJ4pP6JCKEyj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Baolin,

The KCSAN report I referred to is:
https://syzbot.org/bug?extid=aae8bd56cc1c38d50ec4

Full report:
https://syzbot.org/text?tag=CrashReport&x=16888bf5580000

At the reported revision, the conflicting accesses are the store to
shmem_falloc.next in shmem_fallocate() and the load of that field in
shmem_writeout().

I have not demonstrated a user-visible failure beyond the KCSAN warning,
and I have not reproduced this race locally. The VM tests I ran had no
swap, so they do not validate concurrent swap writeout.

I used i_lock to serialize the accesses, but I have not established that
the algorithm requires a consistent snapshot of the progress counters.
The report alone does not justify adding those locks. I will revisit
READ_ONCE()/WRITE_ONCE() for the shared accesses, while retaining the
existing writeout-side locking for i_private and counter updates.

Thanks for the review,
Zhu Jun



