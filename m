Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10181F419B9
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 17:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2527D6B0005; Wed, 15 Apr 2026 13:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229966B0088; Wed, 15 Apr 2026 13:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1672B6B0089; Wed, 15 Apr 2026 13:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 082886B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:40:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB61B13B176
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:40:57 +0000 (UTC)
X-FDA: 84661505754.06.E20AFBA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40F54C0013
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:40:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2shBBi3d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W6bztLOy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="r/jnHiMi";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="cQIKW/EN";
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776274855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fOAqbQ+KWx7Iq4Jk4o0vTv5cvwzxS/CD54a2lpB+Ois=;
	b=0lBY6WOOjzPfdizsPnNBlM4uy/qXK/4ujjgoSHDzehH+eNljYUIVXz4bq+GHQ7gxrIBlcp
	lbwBGNj6DTLN1om0tkhOOKSGwgxdBIh5ggrb2S7TjvRW6oONFis5yoLwZTotQNXcGZP+Fq
	toDPOKz7J5zYjl3y/o+OkeeKmaaj8MU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2shBBi3d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W6bztLOy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="r/jnHiMi";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="cQIKW/EN";
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776274855; a=rsa-sha256;
	cv=none;
	b=rm5w9DzGatHIjnkgRQC4fshd6E6V1bPVMa8dQpSoTzfl+bG9RQMN9UiOUR7gb7TeqHSCsi
	2VgPbJGExoVTjGv2AB2srafbQ8Cy8pfjjee71rc0JdNK/qXaK8iKB0HbjpLJkT6WowI6dE
	STCAOT85j9TcNk4vfzvnXAB7dwHkra4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4791A6A7F0;
	Wed, 15 Apr 2026 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776274853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fOAqbQ+KWx7Iq4Jk4o0vTv5cvwzxS/CD54a2lpB+Ois=;
	b=2shBBi3duodbqKjmrBUuwD3klJhfc18zpkZY8bMnwntvNGArBXCAwQ3Gu+pkpr0+aca463
	9VwjLpQkkjHrT/5q6JA74c2vISiYX559UT/I4+Ac8Nr2b7EGcXje37/aLRYFf0NOZNX12c
	JgH/ZaO2YtxSL7JDl/zN7JYpSh9qxn0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776274853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fOAqbQ+KWx7Iq4Jk4o0vTv5cvwzxS/CD54a2lpB+Ois=;
	b=W6bztLOyLHQblbA2aX8F/vqYGGOyUiyDDq92x8suvbkY323wKfhmP9Na35BdlsdVKOmxZa
	fbCTcbDFnh7UeRCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776274852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fOAqbQ+KWx7Iq4Jk4o0vTv5cvwzxS/CD54a2lpB+Ois=;
	b=r/jnHiMiHjWCzEwr02XQKam/ncPcqsjy15FzG6jWpeU+z5LLEvccty6D79p/T879Q7Ymfz
	vanwaN3BzVk/rfQ/WqO0li+q44rOgVg+ZrbIRasG6otfw/bRn6DhyCgjCTuJ1ZyyFG2rFt
	FAIAiph2Nm6ER6vARqYqyZdY7PrB2hQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776274852;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fOAqbQ+KWx7Iq4Jk4o0vTv5cvwzxS/CD54a2lpB+Ois=;
	b=cQIKW/ENmZr8HWqE9mqwQQlMPN6Q7ZOWTdeuf3i4k9nfeFrnJn2E6YO3MlnFs+K1IYIcp4
	pFToHgy8yO3j5+Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38CE94BB1E;
	Wed, 15 Apr 2026 17:40:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EQ11DaTN32mWXAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 15 Apr 2026 17:40:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E26B4A0B59; Wed, 15 Apr 2026 19:40:51 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	<linux-mm@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH] MAINTAINERS: Add page cache reviewer
Date: Wed, 15 Apr 2026 19:40:40 +0200
Message-ID: <20260415174039.13016-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=575; i=jack@suse.cz; h=from:subject; bh=AnYdRSkpK16gyCJHY4l7/7D7E4F7gGFB8UpWTNjgw/U=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBp382Xqa+hPL1iu4KIEURTE+x4zkUxC8ADBPXDX BiwHbHEBvaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCad/NlwAKCRCcnaoHP2RA 2eNQCADothi9W+AuDdyN2BmXgNAdxzzC10wfNZXzgxyQi7IrwdB8Rnm6MtKvV7defaig1+hSZFw V3IFWN9xiRcNG2wfagz+V9jfDrg6gteSex9JZ9e5+5MoXY2I+ehPn6K/rT2PveXPgYLcZWwmQZj 1atTIyl4JFHfFJb8a+5BWVldalMgJu6mbOrNK2RGNeSp2C79is2R4KXBUkkTwnV/vTVD4y4WArU KNpgDptRM/fS4n15kFqbgUtnBIHaI4kVq2yHFAccrMxiqFlI5juxzPD59qEOtdd0NjU3ktpq1UN WBXkch58v2r52a8jQqlZXLZja6B6GpCNdSUPqgPnOU8P8cy5
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40F54C0013
X-Stat-Signature: g17renkjbwiqnhfzorbj3wxn4dstpph6
X-Rspam-User: 
X-HE-Tag: 1776274854-70414
X-HE-Meta: U2FsdGVkX19wOxZuKNyMDzCCV/A14VqZqHxlKpFynNVxqAqDLDCQ4nEtRj+nr8CNkxbDOejKOmoW26A4KGBFzaUtRBvw3YhHMc14UDp3jRpZd7316i+lnLP3P/561by4sUKK8SogyTTwLJXg9B5xZIGpUfRgyogte3OeZSoKiiH8nzy5h60L/f1B7ZH8vALjSC8VGvfrVoV2U6fFhuBp5zvDPSYEtaNYo8NCzDFVG8lfLZwW7+NeatrDuXD1umcvTZ1LtlkCc5CQobQaMrbB7RcWAZFWbkfusfU23KttMG+vrdLhGWQy9ns6Hm/9c4Joisi/DJUae+jQDIGBhNHm1x0iBs+cYG9gyRE/u3yZniygG6nuvnSC44CWGhr9A5WBNdUN+vBbDspsSlZzW41HYHCgVjEmw0HyHre98RD+i0EDJt12kwG9Bwi5f3vzTniXeNE5U2YIZTLBfbOmXQFDqd38LnoXIcXnpRUvZIF11y63nPgQUgZIQgdZdQv4t/lKvuGuo2DSTtLaOMaX9A24Cwk12F9plQHUPKmwKmRR6/ACZxjLavDEjD2vLkLQrHnm3FGgxfEUL59QPywIALVi9b8aNmbkL5WvZYrxNPa1SLuS/HvOu9DjqkmOKSoQr+wevH5RgiC0csQQcoWOwFEu7PoN2ZEUeG6nR7hHSXCo48Z1sOBBCPsTKCQrjLeW2amM4PveADTpt8elUz4rwaON1V/3mL28rbTDFpAMnGJD8Vxc//n0Y0ChaaMPns1/5XD/uXeymHVqatrMvhWRoW/W1f5LcXFIBZaRmMMxeeQnfgXaYphIs1MexL8BTu4p7DS5jRbVeLG4ki66X6Y32kSUdh58fAZufwtOkQ1adXbZVG4kBsc4dNwRe0OUO5rV3dskf0fJtf2S9zIN7lcaT7qZ3/eQWqWMpKeDe1kVeqY1AqPQTk0PGvaT1wWX7dea0BcvJidt2TXr49b2l1WT529
 CLxkU73Y
 ajXl/1MRQlODWBkwwE15f6ZmyG1WqdSKjACMOvZ5h1Umd5sDJt7I0DDI4LhqPCWG3e9KHzIfNKCF5DRa9vkZIaWC3/Z3sLJS7Ebr7pIGC/jwfd3VfHr0ost79t+eUDx9u+ClPs7kY0ndZZ46x4LtpSM7Jdjyy/FC5f9/a5Mk18SybzPScjOR26C2fAeDlbD+QkLeK0Uss8Oi+Z0krbD8Tff4P32idSu9vm12WqeH4ldBYZQ29NGSG0x62mgXcgPoJu40Tfy5Fte0mPOm0YvF97HouePec/85X+iDe3bDr/BWlKvLunLXB0JaY8JiElHrONZUj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add myself as a page cache reviewer since I tend to review changes in
these areas anyway.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d1cc0e12fe1f..2af750f5f06d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19961,6 +19961,7 @@ F:	kernel/padata.c
 
 PAGE CACHE
 M:	Matthew Wilcox (Oracle) <willy@infradead.org>
+R:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
 T:	git git://git.infradead.org/users/willy/pagecache.git
-- 
2.51.0


