Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F096FCA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 08:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05A76B008A; Thu,  8 Oct 2026 04:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DCDB6B008C; Thu,  8 Oct 2026 04:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3696B0092; Thu,  8 Oct 2026 04:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 683FB6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 04:47:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDA7C804DA
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:47:51 +0000 (UTC)
X-FDA: 85298831142.28.A9EDB81
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id CD66640004
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:47:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DCGpDcS7;
	spf=pass (imf27.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791449270;
	b=s/0FgWiq4ox1FIZ4vEMe3rf7OVepg4vZDUYuVz71QAkz0XVRXzXcljfsEv6lxJjo75nsPF
	oU1j8IgfGngMNevlBTC179uDTpWjEp2chfUWAEuMhi/v5NLHRODf0wYt6lBcp5XrMHBwlI
	3rBbt2rVLLLYybptRpF18VXoxU78Zlo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DCGpDcS7;
	spf=pass (imf27.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791449270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=U7NJNES3puZ+Pxk2gqGTRhP0OXitYJJuvg8/36BldrT5SEBlSQz9AKJaYuX613pYYyoUgG
	mkH61yhyGwndcxvekMMitFWCjgimgJ/ecGHNHQFa2xdvLO6ILApbf0qRpcHz6wcl/E90yl
	HrP+Mae13e7qeGwlRl7qtFSEZf2OmOY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791449269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=DCGpDcS7bmolhrP+LuJ+ez4KJd7v3t2xlFFGdYqYj7+bTkGSdYDhUaaNlxFZUOimQFR/Ks
	t8aJ24w+wjetplfVSZ/SuMQ4R8OERAt7XN0epTFlSsTnNzkOci4tugL/jC7dknOPz3xXKt
	uU7Q7IhKaNxqD/pUtNbFSmcSLBgzTIU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-HQ4NxhHbM0W5xtcG8UkwTA-1; Thu,
 08 Oct 2026 04:47:47 -0400
X-MC-Unique: HQ4NxhHbM0W5xtcG8UkwTA-1
X-Mimecast-MFC-AGG-ID: HQ4NxhHbM0W5xtcG8UkwTA_1791449265
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01BD6180ACF4;
	Thu,  8 Oct 2026 08:47:44 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.90])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6CB6B1800446;
	Thu,  8 Oct 2026 08:47:37 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v16 1/8] mm: Make readahead store folio count in readahead_control
Date: Thu,  8 Oct 2026 09:47:13 +0100
Message-ID: <20261008084722.963948-2-dhowells@redhat.com>
In-Reply-To: <20261008084722.963948-1-dhowells@redhat.com>
References: <20261008084722.963948-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 4E5eqaXeMG0g74HlR3Dvpz6uI_DPv3jBwH8m89C_M8E_1791449265
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CD66640004
X-Stat-Signature: k3g3y3ktbfd114cippqerfi6wenisgpu
X-HE-Tag: 1791449269-646426
X-HE-Meta: U2FsdGVkX1+2zpU8dTUYlDaZhe2FhktncUtoIFmmzxgOXBHEQuq2eoxgU3JLI/CD71RgcadSMuojstrKNCreHx2r9V9wn6GRo8+RFkKC3iKIakghLYEzih8JV+xpeZICSY0akrl1Z1uoPEe3pcp6GBdQgb9EDGr6vsroh0VwXBMQYhl0lTu/T+MiyfLN6jE9tGsG5qDgMNLOzdZNWcK01EXY7RzncaWCvXxOwJ54Ck+Gyi9rcluG73kH4mybIWaNafba6s9GfKM+0Ls0MNYv1P0j/aOmqEw/Pz1UGuyElmqKSGU2FnGaIlA6tLTiMN32LK3BKnhgfKcmaPQiGiaiPWZb9F19dY4d8YmcvijHRj8beNUYbsREZdt/vcX6kHmKdB1rKd8FKF+2Q3KgTABR/rHqRFJCl/EkbQ1rTwGK/0UrifmCkTBPyX62UKq/lV7/V7Nznb5X/5Jh4qwvvwD+HBkdod/Z1W1eQdTCFjxX0qLpcj1Jy+VyaQ27mTdX6R+gWE2n0T0W4Z62BU28Auu1L/eV/6+JHdK6rujq2CD32nPMLZiBFd1m7C61bQxKrh6nsrHqH25VE900ExbAvsi2vU2v837EuvcATzj5AeByOUrg5tojaG9stWPadlDgYsQCgM+FdbqSlxn+ql7UUXELltNoZbHykhiWXr1bwIn/GuIrNrDdkElTNDAvUB2Tld7Xo3JAExDTmY9sGxSc2MIYsTGMt1u7tK3Muccy1Rs819YNpuaBL+jBtjJgaeJJxCABOSR4s9su74jLvTBwTVKJ9nMcBHnMX3cPC5mET379MZSvr6c0vv7E6aDV1GkYr+EZJDUlPE/hcv7KByfkOyWWbj7DOSR9a3fnTezCD9UwK4QazqfG2YkK8vUEVvjkBbDf13PAAr+ax61jKNValozgEPKjEHZc5gsF8I68sfL3v6YQJHaQ4c2SALXsaodSCqe7vrysW5T0t9oHepHIUrJ
 MhEYs2Z7
 oYtLVj6VZaA9Hcn1aQsyBPeDTm4RmgusqwP1gl0Ss05NywyaMgapkGc9Z0LSYMFYrPbIfv2AE790GP9LLKxp0upReJ2bKLJS++iOjbdby3MWXV4gu9yQ10mHrygLm3wGO7jhw+6C+C3sqmUCdNT52pHLhHm3Pp2KSHsOZ0OEYmNn3Xjot9o/YCCnvolWBrHVaNh+hOClX7N9RWHR5BpVV3QQyWKvmWHvH9Yh4XDl1f1WGSnziUq2H1ajOP+B96C6lRBxV3k9bKW0+lC04/Z4ByjzTevnKDJQavTnC6N4h+jLtur2m7fveU1cjQ5kuMaeRz2SO72vJWDL0kwTRltIuPTM0WBfTGY0mRRp5F92LIMlFQ8NBZkXdiNYTjhLY0Ma7lvmoTIFyjJYY6Rr7OjeRyPbSbAykpZj9zEoJkROwZdEBXZExWDwmWZlATw7/ok3TvZT8+bZ81hPEX4YlK0fbpNb/yKBV9Bmw5AI8NqJY8fC/JBfZFUH/tCR3r/7ok6xMuKykq/yMXlMGDMJD1oN94lVqbte51+eV2FgLviIemyp0sWctmRC3Z7vUPwOlt6vN9Iy/u0eG4NHGhtC/EViAMNXpbn1U3aUnchJstT6EJFFc7iHoVb9fKJTn65uSyCQ1rdVb/jUddsZrQm3HJsU+iVKSIbdUZm8FWoKi+cBZ44ivokORsAgM64epiRYSj3CNG/A4tPgHtn20IY+l83of/ATSZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make readahead store folio count in readahead_control so that the
filesystem can know in advance how many folios it needs to keep track of.

This is cleared by read_pages() in case it is called from a loop.

The count is accessed by the filesystem with readahead_folio_count().

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 include/linux/pagemap.h | 10 ++++++++++
 mm/readahead.c          |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..b7154b81d0d7 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1411,6 +1411,7 @@ struct readahead_control {
 	struct file_ra_state *ra;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
+	unsigned int _nr_folios;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
 	bool dropbehind;
@@ -1590,6 +1591,15 @@ static inline size_t readahead_batch_length(const struct readahead_control *rac)
 	return rac->_batch_count * PAGE_SIZE;
 }
 
+/**
+ * readahead_folio_count - Get the number of folios in this readahead request.
+ * @rac: The readahead request.
+ */
+static inline unsigned int readahead_folio_count(const struct readahead_control *rac)
+{
+	return rac->_nr_folios;
+}
+
 static inline unsigned long dir_pages(const struct inode *inode)
 {
 	return (unsigned long)(inode->i_size + PAGE_SIZE - 1) >>
diff --git a/mm/readahead.c b/mm/readahead.c
index 6e5563290287..196542fb1c93 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -188,6 +188,7 @@ static void read_pages(struct readahead_control *rac)
 	if (unlikely(rac->_workingset))
 		psi_memstall_leave(&rac->_pflags);
 	rac->_workingset = false;
+	rac->_nr_folios = 0;
 
 	BUG_ON(readahead_count(rac));
 }
@@ -303,6 +304,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 		if (i == mark)
 			folio_set_readahead(folio);
 		ractl->_workingset |= folio_test_workingset(folio);
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		i += min_nrpages;
 	}
@@ -473,6 +475,7 @@ static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 		return err;
 	}
 
+	ractl->_nr_folios++;
 	ractl->_nr_pages += 1UL << order;
 	ractl->_workingset |= folio_test_workingset(folio);
 	return 0;
@@ -822,6 +825,7 @@ void readahead_expand(struct readahead_control *ractl,
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		ractl->_index = folio->index;
 	}
@@ -851,6 +855,7 @@ void readahead_expand(struct readahead_control *ractl,
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		if (ra) {
 			ra->size += min_nrpages;


