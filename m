Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D04EC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E326B0092; Thu,  3 Sep 2026 05:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55D06B00A5; Thu,  3 Sep 2026 05:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B486B00A6; Thu,  3 Sep 2026 05:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 825EB6B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:05:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 003A9A44B0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:05:26 +0000 (UTC)
X-FDA: 85171867452.03.B23CD39
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id CB89EC000F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:05:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pOImHT7t;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fhO1Au+O;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MVHN7d5d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fsExBAMe;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788426325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6Lq1QyCS2pwB45xAjaigLwdvoXYKOAHiBjoA3F+oARo=;
	b=fvRB81njh5xOOqKlo0lq8B3dcKggk5qsca06cNf2kcQyzJd2DaVAlYwsl0G4h3pd7yBR9Z
	BkDyxHSnh/l9qm1YMhHWZ4zXrdS3SfjcU7wB902dp+v4GMndXV0o+jn0C1Pc5leVtxkd3G
	cypEoPHVCTQlP1U2JsdOaKSY/2muT14=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pOImHT7t;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fhO1Au+O;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MVHN7d5d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fsExBAMe;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788426325;
	b=61wNjJDmqC6QVLeVD0ET0pkzeC+AbNmOL0pDOy8YM/uXdGvLOW/vLx9SCzVhcqsh1H1gje
	EM7oF1V8KPdxWfNlAlBgX1BhPmg5oTbVcWNpbxA0ZAJC7UfkK00Lj2lpiwXCYEkrHH1I/D
	TnLiu6gbf7ZvYn/RmUcCsMJP4jb8IYE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 72B1121AB9;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788426319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6Lq1QyCS2pwB45xAjaigLwdvoXYKOAHiBjoA3F+oARo=;
	b=pOImHT7t1wS9lsRDZaMkOAa4TWFaw6XhATPeICdDNcLAnIcU3epzvjm3wTjaieaBfacTjF
	b60TvVfoZjV37gv+1lx2swLC7JWzy09HE6xUEhPfUb+36GKqqQvK9n8EuD8dRDd6CApb44
	c9fLSKozwriUJYHdLOH9imWMCokXDGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788426319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6Lq1QyCS2pwB45xAjaigLwdvoXYKOAHiBjoA3F+oARo=;
	b=fhO1Au+OpJl58qPnVCD25j2GKOZ/gOTS5DTpXoDGOBukD7r7w61Ta/AyUGeWmzmTSrdelr
	P4LorXuBfFAJyQBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788426315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6Lq1QyCS2pwB45xAjaigLwdvoXYKOAHiBjoA3F+oARo=;
	b=MVHN7d5dUCz77742lskdzC1eJ7yRHNvczWdzgd/eDjMCT9f1m0DNgj+/Dw1OwCsHeTfk+U
	Bt6V96HiYZJOc5ijCk2ufi6sZK3wxT8YHKsvxRODghdGY/lRSGli80y4P7McH/0Mkbrl81
	Nd44EGrfLY3DU5Mqrx8uyZ+6oUhv4ow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788426315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6Lq1QyCS2pwB45xAjaigLwdvoXYKOAHiBjoA3F+oARo=;
	b=fsExBAMe+agrEi70YIpparLvjnfy/d996k2Jlbldl++V3bm0fb+xQnjuRCyq5xTnhzbCRC
	Z/uRiWgFaHssDoAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D48C136E6;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yaPaEks4mWq/TAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 09:05:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DB83AA0867; Thu, 03 Sep 2026 11:05:14 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 0/2] quota: Verify special quota formats match sb type
Date: Thu,  3 Sep 2026 11:05:03 +0200
Message-ID: <20260903090053.13120-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=950; i=jack@suse.cz; h=from:subject:message-id; bh=nmbFlumIvFt8cCksagegtdhPcrgXqvGgK6oycSl8LHk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqmTg+QxytiwmIb8NKJnEByIzbyS55nQjAfkavF dzNt9qHp5eJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCapk4PgAKCRCcnaoHP2RA 2XoXB/9eZkpdjWsEivOpKLA29bTh2ynB34PS/VrbR6ZUPdLhPzxT+c8ozFt3w7m32M712EJV3l7 Pu6opTUeTkSgAPowQhYCPjW/JRA0z++LWjzLEbuS3y1bW5kZEx8McjUVfAQvZapLpUV7lpLxMpO 8BxmA2EBvO43neqvjLxD+5L/7w55QDy+bysJJizB6HCnHn8iFGdIVdPB0kzaD5QAwuRJJsVWGra A27lNVyr1R6ATfUr2ZiQVZlcIyXRcFb7QBViOPiL8QWffRgNQfWTmmedR3knJyrrWxphgE+H1Fb qbfore8scvpfKxB8tdKIVqDKNKDsaAbMki0yrq6UMUt3qV84
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mamgwiax9g6rpu45jcfdo9t6jacj4py7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB89EC000F
X-Rspam-User: 
X-HE-Tag: 1788426324-889263
X-HE-Meta: U2FsdGVkX19fxSuYIyOkUPIrC5seF3J3EeXTjVdIvbotZOWy/uwOkpD6pRee1RlfD43rIFQOZXwRq+1Viyg4+fms5xxEm9XI0pKNHXVfvYckOWiREOR3bCuFA77cq2ujHd/c9APTD1N1pl927kJHWm+ena/BRFCGZkRnLzpcunXaBr/vA+DOaUeY0hSwKwu5zzCLcT+zwHJMuDQKie/0S14EfKMS9lxZr0YLhsHwQS3QLht4VTl2QX+yUU+k0DSyNz187hvcTDPxX0CKQOFx8QULZUxd2LKn7p1DkG3XFRBRO4fpigiKXy3wghtrESsT9cnRaXwji8ZyQXl35EAgWi4m0hiSww2Kdc8RSDqfl+e2GHfx3P0Nl2AZsl6WAuKBn8LhQOjsfNEQzllMvGg+ZopBFqLiwRHKHfS0ZNU0qps5Y/dH7mdVawv73zJDFQ4mIhFDK7FYRfGlRyU8I3mOHNiTS1OhGdICTOXVkf/8cssZZORiEAevzclNjMkT9x/BcmGSZcdkBfEnUXzMQBAjxqtCxYM9Z3C7ULlNZ4bGMRn3Eu5D7RVs1hcvRf8US+a5ANdtmsIDgbaPy3tMW9Noo3yUVl1Asby+UNdUWX1d6mETbthwRRd3mQi6eB7WI+wjNL6ZDSBCKn6RoNumMiNTB5Af0qCR4Nfp+vlw9hKzWNwJ57xyoPPMNxeY7hF1oz/Y4pPlUFwJ0JzgZ0lPizw/e3qf3KuYqmLM1lpDWwMsmTgj7Yvc7ZUDfkBLAA7+/geBOH2cJ1H5C+ri3ONaW1J1ALYcaZ1zI5JR+d4e/8/0fVQSrFZTEg8iPAGqCKyJ8kQ04cwbr+nBa3vow+7PgGc8DSjCjb+cyfP58AgNonmqTQdpfmFmxa6yV6q2RrCqeBaXz3gmYhewIj99tJ132i+m02x3UaOb/P+YqxkrSIGGUow+2/mOBsVYsy0e+VPBnujEfli80gaweqVA4gj76SI
 gcWfTRhn
 VVeqm8dkpHY6MsK8A6yPIlAX2+VrgaQvpkH9Ftz1WeCVXEIqs5M7ykvVyEMqk4a4NpdhNoSu0kG0SZTRjr+RXtI2pDFG8HFvrGkq41bsWO3Sep2aBmSGBMsNJNIFHFnriZOwFbCIInoZsJggE+57HF+tNEWMsMc9oDMAOluIaFzT1esivMZw65EIKIKfCRN+C0mnSUDs7uC0gyUlzU4PakRdJwGRwSSM6xj5vpgiBx7/UO4lmNiWDjobwLcmncEuX53wg/ZED0FIH+nDi84hoCaKgtcIJ0AieDyho
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

here is v2 of the patches for fix quota crashes when quota format doesn't match
filesystem type. I'm now using s_magic instead of s_type for superblock type
checking as Hugh pointed out (thus I also didn't pick up OCFS2 guys' R-b tags
because the patch is different now). Once reviewed, I can merge these patches
through my tree as they are only quota related and very unlikely to clash with
anything.

Changes since v1:
* Use s_magic instead of s_type for superblock type checking

Original cover letter:

There are certain quota formats that are created only for particular
filesystems - ocfs2 and tmpfs quota formats in particular. Make sure these
formats are indeed being enabled only for filesystem of appropriate type.
Otherwise quota format operations can easily crash as was spotted by fuzz
testing. 


								Honza

Previous versions:
Link: http://lore.kernel.org/r/20260902132458.23590-1-jack@suse.cz # v1

