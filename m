Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D21C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2376B00B3; Wed,  2 Sep 2026 09:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CF56B00B5; Wed,  2 Sep 2026 09:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EADF26B00CB; Wed,  2 Sep 2026 09:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C60266B00B3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:37:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94AB7A0227
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:37:25 +0000 (UTC)
X-FDA: 85168924050.26.0F087F2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6E45240004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:37:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kFeJI7Fa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wEgnbpYw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=igvW0iwd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PwtNXQkN;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788356243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sDedlMCOvuW3EuoVUGCGcUVQWdalOVctmMo52iR6yfA=;
	b=AVOqLO8ITss8/dc98y4/C609hQLvKjvzp2GpA4Zfb+WrKdihKWfCVsLfRasz6z4dXxdtA4
	I054YdKfR8U/YfE3ZSf361jV/BeXmH5aHS2CbJhl0AfzrPFmB1bhjKhblEq4TA/pbYmkC4
	lBd7pozB8HX+cElfVQLfHUn6ZXX2yxA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788356243;
	b=roX5+lISGlWv0whHfoKgCfiIofrty+B7Q7bD2BLBEXw4+r8fRhIEppBIWBGA/y+saPKSci
	XNHeLcg1NUIzth62NI4f8EmEGloHYbQb+PEYA3qqwVcQ5Ma2E1Rm8pv+PbtLJiKAp8w3Xq
	wLfQlTS7n1kVHOHQNlmI5iI8l61weOc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kFeJI7Fa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wEgnbpYw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=igvW0iwd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PwtNXQkN;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 791981F7F9;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sDedlMCOvuW3EuoVUGCGcUVQWdalOVctmMo52iR6yfA=;
	b=kFeJI7Fa3DhbCAVEHKHilo19tMTpdMJkRx6xn2UT7/LP9xp7WOxdBFJ+9Rg9HACBuK0HL9
	5fMLIO1/4H3/OKQCp8GtkrWak0dYeiEHJGNnKCL46H+sbyHQWAC0pmHPgdQ2u9MExiURcC
	QThkqQX9sBHq0hwgyWH86sspj5k4r70=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sDedlMCOvuW3EuoVUGCGcUVQWdalOVctmMo52iR6yfA=;
	b=wEgnbpYw5Lxg1SPixxID+ZWVZlB/UljwKlgMMrKFy4EP3m1MOfozgDxVcNic2nTfnPwXdB
	xTgdAifV1oi63vBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sDedlMCOvuW3EuoVUGCGcUVQWdalOVctmMo52iR6yfA=;
	b=igvW0iwdrxCnf6k+H+Bmt4wWEuRIFsatDloZb39czqxS21A0ZXeqcbfRxjAw8I7fVlZhV5
	yfi/JeScBaspSVbs6Yey/4ygM2K1dCM6DKQvwjqtmPlZKpqZ7B4ddHOd14XewZbaceaLFk
	cvxUMelMN3EVLoruBzXJsESiFtUPWv4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sDedlMCOvuW3EuoVUGCGcUVQWdalOVctmMo52iR6yfA=;
	b=PwtNXQkN4GvkX2GYghSltfo1a1JrvNYni0Da+xfbpeh/51iZSSQotlc5zj9l3eUz2KL2zH
	oYrfebUy1JxiyJDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45FB813736;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /rQDEYkmmGrAYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 13:37:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BA25FA13B5; Wed, 02 Sep 2026 15:37:08 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] quota: Verify special quota formats match sb type
Date: Wed,  2 Sep 2026 15:36:58 +0200
Message-ID: <20260902132458.23590-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=938; i=jack@suse.cz; h=from:subject:message-id; bh=rhIIYZj1gDRfV0Zzn4IWd+CiaRTCYW8nS183KX0IZFk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqmCZ5ZBNRLRaTvLmR1BJv3UcV7BS6owiHdQlkN TOgWyUOkyqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCapgmeQAKCRCcnaoHP2RA 2YidCACr/oac7mhnqq7jMWaceCGKrOqWSpp5PIRyDM61jGoSKjN+YvfTWvh+a0HlOO8ND3J6JBa 4+N0GjFjudQRqsOtzqr2zdGRvyJXZBOBM4YfLkjEufpbxLwawOMPfI2f4aET5Af3zixP1pX8p8p MHELEEb5x/bJ71wTmc4CPkT5lpzGRxAjHE/MRMhf9alxRSnMPnlHhvTZIu+VUO59N/Yh0URPVCW 7Of1ssp4OJKYqK6ZmD7+50M+paALliTCS0jZmF/ko+2SzbIAn1qFgBd63DDCs5IrB1pgGudROwb ZhWcIYaZdiHX3jwedReBvFFqwBYMAkoSWqoa6ZAB5I05kQJY
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k4zs6noh3gfuaskjmy73rio9jxfh9j7q
X-Rspamd-Queue-Id: 6E45240004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788356243-535425
X-HE-Meta: U2FsdGVkX1/sKiOqT1a+YY50lOmvOyFeZ1w4xXo+7w4MRR4rUxny172x6wCTntCyCgpt4ymB23+K2hcvMUjC4kAoaV96/rdhZfW0A3WzMxSf/hPB6K9CQJJ/yUkRi+a5jKgVcok/PINdZMFTWnNv0RXnNb6yJn4IoR8VkFuWGnKriTrOMIjnVccqQiC7zIS/mCxjFGx+JNiZW6U4yfDki6nnO5gcAkyUbT/uywq9ie/eVAa5xV1QvA49nEjlLFQU4DTyuQm7j3zr/F8x9M5h5sRI73a76CqE714HcXfMJNakzndIADx8PqIdkVQlBjFyTR5O0+si+nMQJRyFoViiAlc32ziiN82L0I0HrD24Qvf5BGnVeFbLs0gNSS5M/LsQXHmQbjpadd114YoB+RWHu3ykpvZxUquyYXyE0P2Ys5I8u4EmzUnAIQbrYj3+A5qpMIgOf+NWNhKg0rKiY4siCz8rL/TKA7Fc9K6fGtspDXk19QPPUSff8t5EaMfjC1W2ulUGlUyrr0fSy3ndO5N+3h+aciqO+4Nq74L+mlHJScHiiRp4Lf+/4zQJm4SOU9qUnG1FwzUuFmMz4d+Nbifm5gJrswI7tH6REx81mhG1nVn135SlQ0OHxKlIN/gdQ9TRhawvYlUXnDBRK3DsFB45RFDSVE3vaR9QmLqKOYpj+joFpIOYOBW5BZrCOtkpOfw0Lbf659QQ8IyR6PhPFdJDu2KAjIiF543RcxPZ263MBSH4PhIovhtSnZcs9bHzyGKT2EcH4eBfmbGYXSrMQ9OLJLdfcb3a2hesqad+gXFMi0o2o1TvHkUnEkfGl0Ztx6SSfbune2BtySpKuFHk20q0unMCDbyFKozVCKjEhFNMqJzSBmnI3t2m6+PkliYVIaSoZbeNvf69/G0xL1iIRldYSILAxo1Qs4dMwiIpk2fwwzicz4/a3Q0cP/M59THuorX80F5+SJawID9AvxI5ph/
 fLvqMV9b
 eu7pC6pgF6AUgLdllv6k1/NiDfOFoxWkH2yI6vi5SQ3A2ak5j8z4KQaSwlGJwT6BztkqOEKFDSNrouh06ys7m21lXVDVC0FprwIzeUZunVD9DVZoVqovddl3bGD76v+F7t1ry74DLXDb3azEj6QVOlLr20Lg3T/6d5cT8i/9CceYheW3BOw5iBBYy93QXxKO3lZMdl8RFUNyasfDHhrUALmQmADob/lutj7BxlN6dAYiQQ3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

there are certain quota formats that are created only for particular
filesystems - ocfs2 and tmpfs quota formats in particular. Make sure these
formats are indeed being enabled only for filesystem of appropriate type.
Otherwise quota format operations can easily crash as was spotted by fuzz
testing. The only gripe I have with this solution is the recognition of
filesystem type based on sb->s_type->name looks a bit hacky. Another way to do
this would be to directly compare against e.g. shmem_fs_type but that is a bit
cumbersome since struct file_system_type is generally declared in a relatively
narrow scope (not available where quota ops are implemented) so the filesystem
would need to provide a helper to compare against it. Let me know what people
prefer.

Once reviewed, I can merge these patches through my tree as they are only quota
related and very unlikely to clash with anything.

								Honza

