Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31EA3FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FAF6B0088; Wed, 29 Apr 2026 14:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906F76B008A; Wed, 29 Apr 2026 14:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D196B008C; Wed, 29 Apr 2026 14:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 709306B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:01:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0181C1B93D6
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:01:19 +0000 (UTC)
X-FDA: 84712360320.21.FA28DEA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05988100037
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:01:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VwgK4i0E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cSmqgUTN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VwgK4i0E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cSmqgUTN;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777485675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=22CrtvaJP1t96S+6LM3K3HP8ruSHZOqtPHt/ayPf0HQ=;
	b=bXylgR4Q9i/s+cvPKiJcfaDA8OLAnZx66Eaq1L4UbTt0MtuSGqicNY9rgiXpOlQE5syWO2
	GLj/9ZQGUzWlEcRb3aKFaGAqzc4ILHdkyGwrwbSi9iazendrv3W5JEpCdgW/Yi4knGuZjH
	e8PUHqZ84v1rsTJXAdNVafD5m71Sz6k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777485675; a=rsa-sha256;
	cv=none;
	b=nT25CXi2cJwrHHwtq5p8iLv0R7JxwPVLUcbzz8snNPjbQb1EiOOTQZBljuBzf9EPWfqySe
	v/H/quBINGy6lYVu4nsupRn47qhcG6hQdt70vb9f0/IDgwSQVsAqEohlXqnk5R6kRkQU+X
	fcGaVaS5FA+kx9iDq8dhOGZrjOMvfWI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VwgK4i0E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cSmqgUTN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VwgK4i0E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cSmqgUTN;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0B0BE5BD15;
	Wed, 29 Apr 2026 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777485673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=22CrtvaJP1t96S+6LM3K3HP8ruSHZOqtPHt/ayPf0HQ=;
	b=VwgK4i0ECljQiC3txy4D2xP4fhj0IYeEY0VOwYKYfg5cJAYpbnnbI7tgoPD019YZF7e64L
	+1hh59Gd1HPrLOwCGyRw4Q9LQiALe9Z4/ocNqW63ADXY38MHtDHCMt9zuXTz5Mib06AlR0
	GV2YhGg5qNEMNAWzkq7n50YItcNh+Bo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777485673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=22CrtvaJP1t96S+6LM3K3HP8ruSHZOqtPHt/ayPf0HQ=;
	b=cSmqgUTNd1p3N3PzNCylOvwVpjnxzv0SGV6V4loqFY92UpQ0+BZAjI9y061rGhw2JZqek+
	JM6ILtIB6wbpr5Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777485673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=22CrtvaJP1t96S+6LM3K3HP8ruSHZOqtPHt/ayPf0HQ=;
	b=VwgK4i0ECljQiC3txy4D2xP4fhj0IYeEY0VOwYKYfg5cJAYpbnnbI7tgoPD019YZF7e64L
	+1hh59Gd1HPrLOwCGyRw4Q9LQiALe9Z4/ocNqW63ADXY38MHtDHCMt9zuXTz5Mib06AlR0
	GV2YhGg5qNEMNAWzkq7n50YItcNh+Bo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777485673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=22CrtvaJP1t96S+6LM3K3HP8ruSHZOqtPHt/ayPf0HQ=;
	b=cSmqgUTNd1p3N3PzNCylOvwVpjnxzv0SGV6V4loqFY92UpQ0+BZAjI9y061rGhw2JZqek+
	JM6ILtIB6wbpr5Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0267F593B0;
	Wed, 29 Apr 2026 18:01:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JGCUAGlH8mnQOwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 29 Apr 2026 18:01:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AE3EAA0B53; Wed, 29 Apr 2026 20:01:04 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH RFC 0/4] fs: Deferred inode reclaim
Date: Wed, 29 Apr 2026 20:00:50 +0200
Message-ID: <20260429174850.18223-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=729; i=jack@suse.cz; h=from:subject:message-id; bh=xvunP+QgKoT5YeKhRTXmekiPiO/O4wHjm0MpotEVYPs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBp8kdR+NLtRSLgO4grYtS868zysozthYSdcS0Kg zSjAPGEsluJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCafJHUQAKCRCcnaoHP2RA 2bbGB/9ExsX8BTOKg1aXOjSipav0wC6y6/Aob4MY6sLV18jLwVCkgJbEX3wwHZrdqpuAr8S/Zaw spHmYVHBbAHQrTj7aneL1Jp94Gl1Y7Ksl+WA8bRGdo5xIWWMysVgsd5NL3iWD0a3zOOYi610vpA y4lH6OJOr6LmVc1lVnb9iMlDMI+8gjt5eYgsQb2jTV8Z/bHE6VI6H+HbiGLP/tBqR4EQsLuI3fq Sm4RdW25erHVC6vgufiLyJNC1rMkzKnQGi3Q+ixOJdgzBV+FgatvmkaPGqCjBpEv1yV6/82aO1w sjvrKwPN0Q8bHZFgJWr9rL9cJIccjh+Xc7qHKoYSYVzokTbl
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 05988100037
X-Rspamd-Server: rspam04
X-Stat-Signature: oyrez8sipk8ohih5zn5pozr6da4y55sa
X-HE-Tag: 1777485674-491704
X-HE-Meta: U2FsdGVkX1/FIZbmTTz2uSJsQ/j1CrB1OpvmQBR0Sygh7b1PAtHs4pK+OJqxfrgMferwBudlFxvKmbOH0/9qsrIQYRYKEq5C8mW/28jjWZn1eS+iy84x1Cc9yCOREyEGcAzE8tkYuN6I8hXs/g2/cKBOa5wbEP4DfzKdPcXHLenx8/J6SdZWMH7ktwfLSAIqoCn5x7rS0WK1sAiyeKA9WHLl4E/U0bTIQnj+c6zyNj2u90Fx26z/zuTDTUgJ2kkm1Mo/9RvcZ/mtedRXYnWmIYJ+Lx3/8JxsqqPGB7G1jzc19Bm4lkGEPq6Vnm/otAE+qE2+2vPjSlqiJG2F9PEZQ9ZNHUAkFQfcH8XtRdxOptOzd4j2VrRkcqamRx+TYKSANz6iRIuWqve2/mgLz91mPUBbmSPdZEi5+Jd+i5M00mRokpoccpBgjKv8EWKTbb/se2tWYXDzoehvrAuZA69DGFmEiCspcpmSIrCxkxnrerDX1nQO2Qodp++ltpGIlCzyCJDh+ELkSYXUmx5mG51S+TmnPAbXYRXVJnLLVd3y91p9/a/91dcA6PYNN0BjvAr2P0EPa4sLHnh5YZxC8hdTAp5WGEmkfzyLMKkDyIUIpjPA4zS6L8VaWCWWIyFVAecxsbWSZAGSfylnc34N9j8eiOQTtOl2un8pqVjD7oyndxUkN1/HZ+/J5+xznFQzNBzw1VFqgrLPKMAhtrzjdVsOrERZoj0kMMFraJStY18Ji02aRtwV9n45C3szztYevIzOgTx5P1Pzipg68I5BgOQFi4Casp+nK1fMeQFzWvNUiAVmZkKvwH1ZH/N9BNkQzVyyf8IlWsUmxO/uQxxtb7sSsth3QM38PE8kxom9d9gQEqxtps2jLu016us4RMoaAgryYvp3t9bmPbDgocAJo1g5eHAEZGcnBKam6W3KTIoGZJX/bcemXoSclah4BS8oAS3MjxDElswE+Rea2PRIXrh
 fvGWZr2a
 EI8aGU/y1Ft4AYzhjsw8mC8SHZekv/qZ9xxL+pCH6bJubpEiV9gIsVC7zltUI8VM2iI2oRLzApBLKPCegpEswpY3wJ90RnXtWectcNrG+RVSN0Wi1UIieDEsaFZaYJ4bf0I+npcx9hrDWX03+eTbVIEcH9HEYwzfcVo8HP2bvkYo/3GBk6GBzVevrQu7B8Y2BtL6aNclau/gYp8kCLHMH8Z2s8Jt1Kspz908UbM3OD47Z4yI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

here are patches implementing deferred inode reclaim to deal with MM warnings
due to GFP_NOFAIL allocations from reclaim paths. The patches are only very
lightly tested and are meant mainly as a starting point of discussion we are
going to have at LSF/MM/BPF summit (yay for conference driven development).

The first patch dealing with lazy timestamp updates is kind of standalone
as I've decided to handle that in writeback infrastructure instead but it is
also a case where we happen to do GFP_NOFAIL allocations from reclaim path.
There are obviously other filesystems that need similar treatment as ext4
but let's handle that once the infrastructure is settled.

Comments are welcome.

								Honza

