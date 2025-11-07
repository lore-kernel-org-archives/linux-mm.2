Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1821DCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 13:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23BD48E0002; Fri,  7 Nov 2025 08:51:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FEB78E000C; Fri,  7 Nov 2025 08:51:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013828E0002; Fri,  7 Nov 2025 08:51:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF0F88E0009
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:51:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAA724B9FD
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:51:50 +0000 (UTC)
X-FDA: 84083949180.20.321E255
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 59D00A000E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:51:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QysSwRDl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OiwMZ6Do;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QysSwRDl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OiwMZ6Do;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762523508; a=rsa-sha256;
	cv=none;
	b=WZQyuQCNrZZ/nde8/sv9mSyG3AqIV1vOXFeD4bH8yhqEhN49lTlQsc5evmgihan0eoJvFB
	DC17SKM0EDTDoGnHcO0mYRh1m0zqvqp7EvdUhqOjI8yprHa22RWPh+quRZIg8AjlLleq29
	JqMmggG1Nk3GP5JUlslcRvbMPCqhVRU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QysSwRDl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OiwMZ6Do;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QysSwRDl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OiwMZ6Do;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762523508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZOKUn5/c3sgqBKSdzqv5puBNSGqcxYOY50bMuPQ6FtQ=;
	b=gbF5RxCdt4UP01G6AA4WxqnymuD8KVw91D+jcKoHdpX1vC44haEfh0pM7SOzXN7PUB0CZz
	f5NijTIQigkr7DMI7tm6Iymt9lvShM2/Bj3hjrSSL0t08KXexKHpMmE6bAswdPAYlAFnz8
	hOwo/KvVeEE0z9eHw+IJJwHZZsYd/Qk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 82B381F393;
	Fri,  7 Nov 2025 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762523506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZOKUn5/c3sgqBKSdzqv5puBNSGqcxYOY50bMuPQ6FtQ=;
	b=QysSwRDlJjot7XbCTUK4+VwAd0JrkqSAvtQMF01zszePAkvqqnLrVLfCm3pF0w2n4bMzUf
	TbeLdY8Aq3TNYFLOKv0BJdRutQR9sONjqXwDWTr0ZDe8KkxTZ+MGjLYCwHWKinAfW3Hr1l
	rumOGdL+M3CCQ4azzvj6wCCfrh74MOI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762523506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZOKUn5/c3sgqBKSdzqv5puBNSGqcxYOY50bMuPQ6FtQ=;
	b=OiwMZ6Do9EnqP6Q8PRpRkv62XnohGr/qpNLg+ZMD5S9pfYyg/2wbEywK7M5skMWj4ViiT9
	rFytoJpbdMwhatDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762523506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZOKUn5/c3sgqBKSdzqv5puBNSGqcxYOY50bMuPQ6FtQ=;
	b=QysSwRDlJjot7XbCTUK4+VwAd0JrkqSAvtQMF01zszePAkvqqnLrVLfCm3pF0w2n4bMzUf
	TbeLdY8Aq3TNYFLOKv0BJdRutQR9sONjqXwDWTr0ZDe8KkxTZ+MGjLYCwHWKinAfW3Hr1l
	rumOGdL+M3CCQ4azzvj6wCCfrh74MOI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762523506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZOKUn5/c3sgqBKSdzqv5puBNSGqcxYOY50bMuPQ6FtQ=;
	b=OiwMZ6Do9EnqP6Q8PRpRkv62XnohGr/qpNLg+ZMD5S9pfYyg/2wbEywK7M5skMWj4ViiT9
	rFytoJpbdMwhatDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6FB001395F;
	Fri,  7 Nov 2025 13:51:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f5XvGnL5DWlFCwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 07 Nov 2025 13:51:46 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 0/4] slab: cmpxchg cleanups enabled by -fms-extensions
Date: Fri, 07 Nov 2025 14:51:22 +0100
Message-Id: <20251107-slab-fms-cleanup-v1-0-650b1491ac9e@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFr5DWkC/x3MQQqAIBBA0avErBvQSIquEi3UxhooC4cikO6et
 HyL/zMIJSaBocqQ6GbhIxbougK/2rgQ8lwMjWqM1qpD2azDsAv6jWy8TuxJe2+CITe3ULIzUeD
 nX47T+37G4gNZYgAAAA==
X-Change-ID: 20251107-slab-fms-cleanup-8e1cc5f5ebd4
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59D00A000E
X-Stat-Signature: 3kc6nkar63npko5kko84jma8rxcnpmt8
X-HE-Tag: 1762523508-956565
X-HE-Meta: U2FsdGVkX18tdb2TRFVPrIKwZ++zT4sViFpT8wizKFTaDRTKbrJVSJXz6+u7Ay1YiRMRDp0/2EtYCrru/M98MDLjZSAxXEP2a2CVKty6Pup3jebSN4gze+yt8GUItAYeWt9kj/OeYYkO1w02Pfs1DiPOzhoEPYoxNFptnlFH1sE93CGxG2ZB2F1EA3S+/9dE+SDdwQV/5IsZQ/r8NGv36lm+2aaLTD1oRvmfgmjwxOw3x995PBCHc99kW38ridd8ShCxr/3XfblK2DAbwyl0jR5/i05/68rXNRBc5BnmhSxW69YfO3owcov4rD7gS4wp+NuQTUx9cqcaZ+Y4389iNNfN8UiOe/RDv4Fo2hVSserySL0qqomayPQsDM3gzQP9vfMgol4y+nlAeNUtk14SmfWd5f+ac97yQyIvKAOve1jAD0gRSuibdOPsk52ta4AFKfcm/eLTNTNfdK3nxj9TkWoRUg6P58LLB1kTkSj4sxUfdjC35PIl4XAmsZLRqhRrIjM/abKtcH9uUH8Be0Ayf73DVHb7A07lvl5EhoYYbDyCE8gQ4EyK/Estao1iYlgxOlrmp4y6kFy2s5UhRnyTBTLCgEsRcSHHNJWJ4xlxifcl2NGJ50RLekU5inACd3OlP1CBmn4mF071eFtpUdr/I2duM3/omdbcxtkyGTmx+lSXFa4Oq0UzV7cPfg9TPhaawe+oqGJBO12zG5TUFqMvGwvdptdRYsHpL/Rdmng1yv8r2Py90+gYWyJq1GVhQEr91yP2MYmKLuF9c6u3yJofWl5z7TV7jPUEUCjwmBymSZ2dIO9r5zNxhmBd0iA7vUfc8vUyta31ckpjR2IVeR3DqT1IromHZY09ifuwhOGt34tIOivjHMriEqKU0Fq8lgokxFwZpIwENaSBUfv9C8+6hdFPyP64nK6N75L+5KYunUZaxcBqYjJ4HSf9j8cJoWiXhZ36iKnIF2dbNTr0x+A
 NwnNjZ8G
 sP/thOjJUapFZfkaIFQbEQQjxw7hTQYpBBWjsxfdzVZTVsG0rl547+/UHMP0qmRZR42Wufy3CHMEu6wIixHp3+PfbJ9xO2UdUFOdC+0cBhjcZY37AhbNVowJi2ZAegY5/nND2/9S4eo84dVSu3MPMrjGRBetiV1UPfjSDKzH7sDCkMyJwE3c+3c6+GP3qSjduzS8+4XX9ImLCqBtAcQhTLvkwnE97YpfjDMsgj0m24spois90BXFkdA8cXyMsjTaGsK4SsPNE5D2WVDkoDXoqApQxP0XhYWEbIqcXMfVTZP8kTRRenyb62k1Ut76NIH9ydmQsXWM0EP7NKYiiI4ym5Q7yZ/CDLm3ATJ18
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After learning about -fms-extensions being enabled for 6.19, I realized
there is some cleanup potential in slub code by extending the definition
and usage of freelist_aba_t, as it can now become an unnamed member of
struct slab. This series performs the cleanup, with no functional
changes intended. Additionally we turn freelist_aba_t to struct
freelist_counters as it doesn't meet any criteria for being a typedef,
per Documentation/process/coding-style.rst

It is based on:
- slab/for-next-fixes
- this cleanup patch https://patch.msgid.link/20251103-fix-nolock-loop-v1-1-6e2b3e82b9da@suse.cz
  (first of another series) to avoid conflicts in __slab_free()
- merge 'kbuild-ms-extensions-6.19' of git://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux

All of that is provided here:
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/slab-fms-cleanup

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Vlastimil Babka (4):
      slab: separate struct freelist_tid from kmem_cache_cpu
      slab: turn freelist_aba_t to a struct and fully define counters there
      slab: use struct freelist_counters for local variables instead of struct slab
      slab: use struct freelist_counters as parameters in relevant functions

 mm/slab.h |  52 ++++++++++-----------
 mm/slub.c | 155 ++++++++++++++++++++++++++++----------------------------------
 2 files changed, 93 insertions(+), 114 deletions(-)
---
base-commit: c77d09928c398df0556e8ef659b4235559e0a374
change-id: 20251107-slab-fms-cleanup-8e1cc5f5ebd4

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


