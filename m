Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11FE3F483D6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0921E6B008A; Mon, 23 Mar 2026 12:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016556B0093; Mon, 23 Mar 2026 12:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83796B008C; Mon, 23 Mar 2026 12:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF1D16B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:30:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 422E8BD67F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:30:37 +0000 (UTC)
X-FDA: 84577866114.24.9B90444
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7229A0016
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:30:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bisqIszU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+th+FtZg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=evhy27M6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=khittVQW;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774283435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SJMWNkiLagjFGDjQC6+/v3NAdffr6/HOuKpCkuBEj4E=;
	b=wltQr658xts7eRZ9YcszcZrDMIEtmk5MOyNpLTbKLfBWKRG1UPgG+A/GG2l5DbQ9DPgHio
	mBlnwxdCG4lfV0FY+sxj9J5u+k0tc2bQcTAx5nReKZJ1IWfDTYO9Cu5zxF95hkwaMYwXHx
	l8pTNnrrRzGMiGlpPFxhW2hWo2liTTk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bisqIszU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+th+FtZg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=evhy27M6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=khittVQW;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774283435; a=rsa-sha256;
	cv=none;
	b=fludk5ivw9d35XJLN5UnfuhLnKT4hnq6Wi9jxVcTFBz8WjWOIEgqrC3pXvlyhgJ39a4tMX
	l/PzfBobtpLjR6ZVYE9zfa6QGW6C9oCspl1El8LUEoRs2dSTrPuortrUtAAHgwh+Kr+ddg
	ah7/fUE6Y8lRmEK7ozD3KmNpgaQHBmw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 243F14D365;
	Mon, 23 Mar 2026 16:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774283433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SJMWNkiLagjFGDjQC6+/v3NAdffr6/HOuKpCkuBEj4E=;
	b=bisqIszU5pOb5/kOb7cVmEdQKPBRcnIO55YLUpKUW/3uHAYt1daELm/VOJuEi4f+d626iY
	OTTHn1OMr32RSoWyNqvVjBvZaqK5D6y/BzaMXl8WDyvCkf80xOjQgghSGmjU8epi1hdP8O
	6uMyqIXP6VCTNPR1SYX+eclgcAm2h8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774283433;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SJMWNkiLagjFGDjQC6+/v3NAdffr6/HOuKpCkuBEj4E=;
	b=+th+FtZgjwR5mtXJtBOcKx2Xa+bBRZozN11bwl+mcZ4SPSRyregRaGXYwhmAkwQK6VzFev
	hyaPju6+PBgm0JBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774283432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SJMWNkiLagjFGDjQC6+/v3NAdffr6/HOuKpCkuBEj4E=;
	b=evhy27M6rW7jXFBav5R2LC+hAF+lv99ACkjw/uzDsRSZZeETOdFOnF3JtkLOEJ3+1tjWEL
	fw+6YBWg/i68orSbw8dxcOGOOhXybY3Hv7EQEHsc29lNb0o6OtvNbEQuFKgLgP+fhp3TSK
	6q0vP+IVT4he+thYR8t1traTsnQg69A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774283432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SJMWNkiLagjFGDjQC6+/v3NAdffr6/HOuKpCkuBEj4E=;
	b=khittVQWe3mDTyNq3doUCPuepd4avFXo8ktzHJBKVIPIA3L7vLp9bB+JysXSkDY/Nhz5Wy
	pa63ccij7mq1enCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11A6D43985;
	Mon, 23 Mar 2026 16:30:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /e3dA6hqwWm6IAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 16:30:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B42B4A0B32; Mon, 23 Mar 2026 17:30:27 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] udf: Fix race between file type conversion and writeback
Date: Mon, 23 Mar 2026 17:30:10 +0100
Message-ID: <20260323162617.2421-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=336; i=jack@suse.cz; h=from:subject:message-id; bh=NO8cAxClAqGsssaMA8oeXcUMKStK7FPcCHR/7Y3gbTA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpwWqRqTyiBfqCRPOla1cB5RovA6dDtOCNqZw5B yT6LWdFtm+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacFqkQAKCRCcnaoHP2RA 2fFGCACFb+4a5554mkaOQqvYIHqqhbX+QmSbNn2ovGjvn1r9oOdTMEeDQ5eQsKqemEatiaZjeJ1 fA0Ea8c4imJBFXTMzfrs4dvdZAD35nydURWn8efQQFsGgVdalBDom5CJPLoQ+yaZUGMt7cbpZ10 vvuuA0KqUJWlUlSuTBnHItO2IG53/omoG9u9seCkZKNcHWdGGekOxhHVwpDQDWAItOkWAGixwAs AbhXGNW7eIJHn+UILcW5toZkWQoaaFmwr/MdYgdxVbf5OPInZ5LCaVGBWZZBL6UqqooTmS4Y8ct gM/NVt9PWRUwfFKvGzCsBFniWYso7aQe7wxjzpiDb++S/7AA
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D7229A0016
X-Stat-Signature: z5tcacc3em9f7z6pwj967n86rmyphj9e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774283434-289409
X-HE-Meta: U2FsdGVkX18zinzeeLry7EvZjMwuLfToYNNMgt2X+N80QWk9Yfd5+XXPQAeCIrjZdkY1xzlfxBwZZPKAg27ZUPKeaqpq1yAPjZysPs4Oa4+RagfViPkLT5vzNQFnTXRQlQHmrtm5VDS7wJuTUxfGtN9HgVDqsg+B9lcjXh/Vl1mC2pQfSAh3wEtjgrgH4nMsZzauB7RRcWesKNGonp4bAHt/9owbS4g8RO+wX8N+jTQxlwDdAAiYbO6gyQrnwVcSLV3nZqULdoMVOwWVnVVsa/vSRK8pdMZTk57iGY3zKhcg1ye0deYFgnLHEFgXzMLQj0DmtPzhorQMCS63kVsbK5vX3XU/7Yhv8a7vH2bB16nWbt+83l7IwrRN4cIfsFCBDh/AmmRZRUURP92MWKwvy+Xw21HdZcZjQ5SPQmcYODXAehuFunW7bRYlLqIk14QwrXuqiqFx8aOFXTgxqqBfcSUFTiyQy4CuEU3mxz/qXYNTq5o4wqnV82+af9yP7wumRebjD+55WTolZjem65vhGM2oSTFq7hjL3DJ2UnhdLAGEC48xSx9YpBxHiIHQMCZcT89eRC/Pcvj/VeBa/Xxt2SecSkKoJaN1+ka62V/Q7zy54dRERnH8THBsX0i9DpUcBsy+EG+sd//zgasmCXEYWxz/tDhCG9FxEeX6hAUe3/VhE9eafAx7RZd6A86RlTwa3lMFAhEu2iVLGl/9bNJHQBrdOkChiW9tCZdq7DkRKXwANEW9Ayuq2GjV7t4RFOHZ2X0Hq7PS5ZeLVraiNcuuqshBF+tlzK1wWnX5mL2szfX0+ThSxq29byiUF/Um3T3GIuAH1io2bxLp06RywKXrRG2oDAprLKMhbffOOkQEj2l/hqTIoNCIuqVmpelLP89HUB4DvSZZ5enaouTNhC2uP6C2J3mxiNUxQ+ppt+xJayJJyaRMXIHn4B0dQYwODCMKEorpfS0JKVxohotOQmD
 V9u6kUnA
 E3/Ve1Nhrx7faCRDxnlGw26i/KLD9NqcUMRqDz1M9PmI6QVk/Lp3VXxzB7Ysd/AFaPvqN/6UfwZMnU/AqwM6WDclL3ZvGr/RSiFFX36Exby35Fc4rIpW2Y5czN8lsuAFp8GUIGtPrngwrqjNBmZC7LWFeYMB0C1MKuYUd2rT6HwiAFfEOboGTiDRN3KkP0sGW7ptHWLr7tm8LYnoY4YH+6sTO0gCT7n0YH6ny8DIsxUC42PHdkkA/kcTEfnYVUqyq1P8LeYeAkaeR+/K6PaHL+8XjuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

these patches fix a race between conversion of UDF file from inline format to
the standard format and writeback resulting in possible memory corruption.
Review/Acks are welcome in particular for the export of
folio_prepare_writeback(). I'd like to push the fix to Linus soon as it's kind
of nasty issue.

								Honza

