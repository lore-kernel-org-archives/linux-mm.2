Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC706086044
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aX7X6vfm
Received: by kanga.kvack.org (Postfix)
	id 278D86B02BE; Mon, 19 Oct 2026 11:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBDE6B02BF; Mon, 19 Oct 2026 11:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C35C6B02C0; Mon, 19 Oct 2026 11:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C89976B02BE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:49:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DD0D1C3F83
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:49:47 +0000 (UTC)
X-FDA: 85339811214.14.3217FAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 691CD120010
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:49:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aX7X6vfm;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792424985;
	b=VHpek7NAd4rjUnssYim2l4QI7ZGI1NGgi1oaaKTkppc27UWrZtScJUVcuGYdfG81XN7IDI
	6Wdz/B0T0jRxDqOnOTuJDip2mow3k9qqUWnHOFVkO+1ZoP1MB9+twSy8RIso6pN3q466cn
	qPkZHo8Qc2XU14RbK3tKDunh8Fm7MfY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aX7X6vfm;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792424985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kbgj/cbxLipXGxpjxY36dW9YWtUesmr6PYKnaG71cGs=;
	b=4GasyomlgiKOLZRm7AQTMY1/NY8ozrPNUPcOciei0L9Sis9akkFeTH9WLD9K7XZbaV+sK+
	kYaPn34FSb1YNmh9I7zV9t4M2vK24ImrQrqu6om0dEkN4Bc5zvXNxsn08F+GkXiPLPKA7v
	+YnWFfsEtDncQklG/MbSbuPHI1NC290=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 042CF60220;
	Mon, 19 Oct 2026 15:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFFC1F000CC;
	Mon, 19 Oct 2026 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792424984;
	bh=Kbgj/cbxLipXGxpjxY36dW9YWtUesmr6PYKnaG71cGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aX7X6vfmHNEuQMJMFfOOXMbvZtqZYhjJkvcNuMefk6NG9jWJrId3Q7jSrnjqZbZJW
	 OQoWG3wXoqpbhVoDvNc4JxH/QWO+boYfB3Pi5x/+p5QvOC3+py8GPiFulDcmy4IdPR
	 SbfYcNqdYnA73EJj3XOfvl+p3fzGVz0NTJ5Ehj6RJPFM2jxGW+aC8yuFV7VLf5nBfn
	 RVgIhvf2j3Y59TYYsKg2TLzAuxdriBiX99e+etgHQ2GZPZ1IZ7L2EPMo0nOQNM/Xdw
	 I8vPk89j52md+Iz1NOi27aCjYfeYPmFE4pgM27HSJjf5CfWWUj7/2bNQzbt/Cp7IK/
	 PsXKclby5SGlg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6B6CF1980047;
	Mon, 19 Oct 2026 11:49:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 19 Oct 2026 11:49:41 -0400
X-ME-Sender: <xms:EDzWalKKW2rLUrzcCGmEAjXNjh6INGLxQ9OY3FD-cACD_m0UdU6DtA>
    <xme:EDzWamaktN3t914H6nnQAtvre-q1v5NfKuv_Dc5jNOSSVyARhyTGBJTk9i4wk_wEP
    jkAOhnejOeO_MprDjcuBlZbK9uQ7lO5uHYC_z7B_bgFUvB7DGFlG1KA0Q>
X-ME-Received: <xmr:EDzWagXz8dftMhBzFjNvkUMrqN8Lf81lQ0KWnLgXpAniddrNFAczEmxc9iI>
X-ME-Proxy-Cause: dmFkZTESqR4vElUNfwe4Wb1kabMg9MdYUtHyNIvlHi5jfGRsEd0tjiYfzpqh5FemuLlMuA
    +QzWL/iolJzzDzQk8vzuoT2/u2xyL/YZG/CihU2eaSQe3uAw7YKu/Z/hQfgMIJpEQrBQkK
    hH3KJVpCmjg+gNXnnOIkdBMKpJa1pvTLqzuojrt68Uovke10kpOzVhZrNEf3d58NDgoR+6
    GBwzdAiHoLFFDGJo3/r+XBHeUTBbw+IeFaYdgC0j5JEQlKAOMB5I7tBUfVMuw5hMfUnXf2
    vE1DwOk7N/x2FbtU++Y3QX/1ODQhD5sTVGp3EMvK4jUTItTZrn4RBPsK+PhnbeHfl8Jcd/
    yYYEKmAGT8vWogHsS/MLpG4mGVeUeUcl8fzs7/zHA9gd8BbEgXpb1CoSUIZuL9AsGdcCeL
    +gXC3GBZVeiw6q1+GKFOmx8OVmgLnX3toJ5chCtufQcBsun6EpjJaG+M15ijPymLjtuB1N
    FD7FJ16WFMZH3bHDTYwl4ViatPxmQL4lcXqk/pVAVOGizVyQLMIwi0unAXmKltJ2BEqr5S
    32YVsgd9l8nrPOu7EChRRHchU7/xpjfB5k04bMWbcc2A+1JkfyBbqlxnUaxqdwKP/Ztfj7
    OS9iW/9oAv4Gm0mAtI4sFlKSdYDo0XfmQz3m1GzlmlQx0HIQJKcwJvH46hFA
X-ME-Proxy: <xmx:EDzWamETvnJHnrvb_jfF9MCEbmlHlDHpGhYwRKQmxJ86rD3lcu0nSg>
    <xmx:EDzWatD021DoQamQf30N_3YICdTTwNu1Jps7NLmgwrtOpkbTEqX8RA>
    <xmx:EDzWahUvs2AcCacNO783zoF_zNcXGlND7aaU_HULAoExtTs4KErymA>
    <xmx:EDzWat4jdA356dqYToLkpgozhEiRUV-5PoXbZAsqKgZUgGQSDbx5Cg>
    <xmx:ETzWaiH_L2oQ-xKhUgvpq5FBLVZGJO_fk39Fvf4EAZDrZXkYkOu14-KP>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:49:36 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH 03/18] fuse: don't move a folio with PG_rcu_free into a fuse file
Date: Mon, 19 Oct 2026 16:48:56 +0100
Message-ID: <20261019154913.1765974-4-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dxxi8hx41jhnnoqib3j6bajfdszob4fz
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 691CD120010
X-Rspam-User: 
X-HE-Tag: 1792424985-746998
X-HE-Meta: U2FsdGVkX1+QtKbEVFolq69C06dV7VDBTBkYbpIowqD1RD2gkjfgXA3Nn7DIzuLWJXn+amAMNEok6K7r1MZxmEpPX5V4QFGgvL13LhBBzCxGOpuzmpBU1Qr4UzUhv1+naHwVsoYr1VHWMm2YuEt7m+5jgW8TlNngYI+Jf4C4rohR2JpFAngGOm83xdVubuuyuCFu3WdXkezPJboTx42JjkihyhJLJY2za0h+d8D1zvdX+syNbkC/jVwj2mqLTvtVdFZxoe3HwCfmvJg6pheF2WmC3bZAU3TPY6/h4c3ns2APdmxMJZMFuxkH9+euHzutMIozbSJVY7PJbA2gYpC7/zWgvYLg2O/ILfxwSSch4xp/dBxq/nFU1VqcOY6oJArlOa6UBj8W/KiMsUJLpIKF2ac/d4yEm8O5Wx8LVtc0VAYR2DBQDzCrrGOrdQmucE/CCCX1keulfeJNqrj5uZ8wKbRgCtpoQ2Bko0ZGeaqKc9PdevhmQRkSO8/W20UTlHhPH07wKLiPQkiVYviVjviLmFMka3fndaXgh5FLrl2Gf08VjI4hjQtOhwIqhGEuwW2K3mNmVid7JOZzRCopyIHFJWNc3Pg/oI3pmeFEYo+lW1cFTNhy76BnWWFDVEYwQc4eaG3ku6AodxrwPvJY1iOvb+zGJNgGDA6UhRCnIY67K5NsrouSZdPBpdzOZeGh0pAXV6q0SYtTZ5U7/HXbUFuzDoPE/7nYhRdG0hz4yQ0YCXv3f/U5e9l9xF0e17wv43FE2OQJb/dgKov3XtzSlgKSctdPKd1dC9I0Eq2Q11yhmgaXQ38b0/eQDoPu8ZzDxY6CwFlo1HWHjfgoswCxauRrjvRGdzOldptftEFhXw+Oz6f4GaknC3WZsyqf4rzAqdVYYd9z8FKM3yylBhT0fMqXnBqNUD305IMVLlEOaycXQ8eyf4uP4khvRTpvkcWbU2piIoT7ZaZWPpJ4MA/tH3q
 9IQUM8nH
 7+27EUlrRhAXrRtHlLP/FI59YJVAtXXIr0+dbpAoUeM9kBriKkWBb3D6uNgdpAcDH2i65NYnLQDDqPsSY6Gze0XBZmAdz+MH7nDOy06Gb+cCtBRMa5G9a5f7jQMgmr6XhlKsTbpp9D5r72CZ9Zlp4BNJr/s7PNCKrOD8FGlJKuSW6PQpxyHMNEA0D2rRCTCzHN1WJFk2XaG3OI8CR9fCL9UF81VSif48bwRQco1+tzaghXW5nK8BRN9AmkKp6/5zMBmp3mJ5CueubeEUDaUQKeUyfnryxw9mV9UkOqHS7ToY8uZJgrd+OIxljmXFwtI+LAssoXXVrWEDYcZl+SkgGhVL0zMqO9YQk7oLN3BKlSsAokmlc/O7etBGGhUDu9R3IlQRC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fuse_try_move_folio() takes the folio of a pipe buffer and puts it into
a fuse file, where writes change it.  A folio with PG_rcu_free may still
be copied by a lockless page cache read that found it before it left
the page cache.

Such a folio reaches fuse when a mapped file page is gifted with
vmsplice(SPLICE_F_GIFT) and its file is then truncated.
fuse_check_folio() refuses it only because the flag is not among those
it allows, and with a dump_page().

Copy such a folio instead, as fuse does whenever it cannot take one.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/fuse/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 4fec31fc0b84..526929c7b3f1 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1152,6 +1152,10 @@ static int fuse_try_move_folio(struct fuse_copy_state *cs, struct folio **foliop
 
 	newfolio = page_folio(buf->page);
 
+	/* A lockless page cache read may still be copying from it */
+	if (folio_test_rcu_free(newfolio))
+		goto out_fallback_unlock;
+
 	folio_clear_uptodate(newfolio);
 	folio_clear_mappedtodisk(newfolio);
 
-- 
2.54.0


