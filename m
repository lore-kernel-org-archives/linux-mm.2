Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E9DCF9C7D
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 18:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0C76B002E; Thu, 20 Nov 2025 13:45:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8B86B002F; Thu, 20 Nov 2025 13:45:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF1B6B0030; Thu, 20 Nov 2025 13:45:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC396B002E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:45:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 336771A02FF
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:45:08 +0000 (UTC)
X-FDA: 84131862696.06.7D08BB7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 071DEA0012
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:45:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D8jF1NVw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RNATp3Q+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vuoClXjZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kYflBcMh;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763664306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vyLZ9Cl5mg+DCaMSmo20e+pJu+99Aflghs/P56oZOu0=;
	b=q9iPbRNk3mBf70kVZRWf2nOiA6uEXM4qDRjQS0KQi/BIalegu/WFkMdpVyDhhr4WijKspn
	FlQGbidIihyf5Nvvm1oCKFCj2gCLCnbr6oG9J/YQmvf5RfIRRaHuaZu/Lq6LSmLnIHRwgz
	D+1+yl+Mwvx+yF8/gZAfLU3np9r23QM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763664306; a=rsa-sha256;
	cv=none;
	b=dcEFoJGVaf+McTkqxFS+NTYRhc1n0o7XtNCtKZmdLuHdJR5Lspd/utdPXHoq7qb7BK2hoS
	l3OAkRJxrGG/284IwgkceMeXWHFpxZkEen3Oi9w2MWWZaIoD5KOeFhvdoSBTcjTcrQEIyl
	ula5bV2PcjTZfPYhI35+9xFsvhowzUo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D8jF1NVw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RNATp3Q+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vuoClXjZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kYflBcMh;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1103020B6E;
	Thu, 20 Nov 2025 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763664304; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=vyLZ9Cl5mg+DCaMSmo20e+pJu+99Aflghs/P56oZOu0=;
	b=D8jF1NVwmcKiETR+inH9FwuyufKaVgbBMZR1Bdi0tdj3zzBPdWy3N4iW96lgtxyAAatM1E
	tEkzVEqcs2ltnlRypVc3SdKcmBhmsxR85fbNiJ7qJCpSKu8IKFKfoNtcOhw0MPgB8LhLuq
	237gHieQ3gtSBShfvoQbbIHH2f5DGtw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763664304;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=vyLZ9Cl5mg+DCaMSmo20e+pJu+99Aflghs/P56oZOu0=;
	b=RNATp3Q+NMDv6w3AXfeHl9WOkvprePIvBpOEu8gkDZbzPoRW4vwxzx43utokBsiPRsR7cN
	gwbizmwXAqMvOGDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763664303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=vyLZ9Cl5mg+DCaMSmo20e+pJu+99Aflghs/P56oZOu0=;
	b=vuoClXjZ6gSHTUWiSxG+63SCob11jEEKndRQifabvYjTTszJ8+Pk5vHc41Uez8hHelOGrI
	6rV6k+cnYsEB2we2uCQ5O0dYlNRJcA0l9sfbxZjsEAPv/+DLggwH5Nt7N8X+xa7aZ2kvuJ
	Y87scHK7zcWmvEXSxT9Nb02iBIbpLCQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763664303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=vyLZ9Cl5mg+DCaMSmo20e+pJu+99Aflghs/P56oZOu0=;
	b=kYflBcMhk2Z0bvQSJeBdFccBVl0EWBgJH9AfDPExkCNQriq7pOVD+eIegSPUzFB2rZxWR4
	9lMwuc0eF0kcX/Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E73673EA61;
	Thu, 20 Nov 2025 18:45:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZmseOK5hH2lnQgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 20 Nov 2025 18:45:02 +0000
Message-ID: <3f4ec3be-0725-43cc-a75b-72549ebdc5c9@suse.cz>
Date: Thu, 20 Nov 2025 19:45:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fix for 6.18-rc7
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 071DEA0012
X-Stat-Signature: pwdgpkfi1kaswxntkk1rfe5nr1maqgrr
X-HE-Tag: 1763664305-606892
X-HE-Meta: U2FsdGVkX188lfFbBuzcz64PBhtJdA2UpXXZU5c0lu6Whj8zMyzTo2qQTnA0n+hSwSGSgi3dfmYUeZvzIrfgxfpBVWMAq82a1Zkwxf/c2z9u7bLYAl0ik0vI5rADcqXgjfPQPwW4v//9b6M4dWUHVu7zFrMQcligWdGbpDundtpW8fA/HFbNzsGMv1vpRQPh628qrAUva3QZnrbMsu4qW7Ecu2jXokPhed8WIIAptKtadWOG71v5jWalpePV32ri96NMki/e2S5WgnSPGaPJxEbwec2s5j9aoDRSp6Le8LvZJ0djR3ACku5gsmCdzsozpaiw7Te8abeHyWlMXCYbKNI1j0U5SePoMyXqGGEZz1upV1lt7bnGkVWmkT98PuyZGr3KJYseIIBGQcbt8Ol53ElvgxKJKAZfF2iYTR8kC2TP/hQKqSRpGwluMqJVJvAvzXkaWQljyyEzjSICPujMYi+gusDWsc2aumnIUKNnmVu+WTdVx8Ew1mmJvkTAyxvxhMV4Src1ue/TxBfwfHqcoPHYQq5Bn99c+oq7xfGQbpBv9vnu6WCpGDiZgWsu6hOqCIjvFL8J4dejeyGBOFh60fsZTuEPN/8ErO1x8GnjbwXborCNawFHP5ug3VJkOASJIYsPNasIK9Oa0oBaOx1uFsNwurnWRZsA+4kSBMo2VsA6Qd0nBtuZ9VoULmF9eaKc9LFfRGsagW5FJ94R0/3m/ZiHQXa4kCEQzl3AkgJ2ESmRcCqJqOTGwgWEdtQuCg8tP5ZMLOv5+OiI57wrusG7hgecF7pFk26CWwJ4flcRkslk6b1GADmthW2f/FT2qCNAUxRgDxtj9I6QBdfhDwdQsRUF0lDr/PYYdyy66Hedr/pO5MDLSHvJKSSJHXxecHkMgZoslQUcFdXvwtodIVcoDd6iiF4qSfVKk4THYU4XXj224K3gXIinKyEjJ1YUQcTBSjC56ibELS+R0XLIF8W
 zxOgVPdE
 WojRO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes (actually mempool specific this time,
which is under SLAB in MAINTAINERS now as well).

Thanks,
Vlastimil

======================================

* Fix mempool poisoning order>0 pages with CONFIG_HIGHMEM (Vlastimil Babka)

======================================

The following changes since commit cbcff934fa7deb670d9545a3aad4d07e8f1e4f3c:

  mm/slub: fix memory leak in free_to_pcs_bulk() (2025-11-13 19:56:46 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc7

for you to fetch changes up to ec33b59542d96830e3c89845ff833cf7b25ef172:

  mm/mempool: fix poisoning order>0 pages with HIGHMEM (2025-11-14 17:55:23 +0100)

----------------------------------------------------------------
slab fix for 6.18-rc7

----------------------------------------------------------------
Vlastimil Babka (1):
      mm/mempool: fix poisoning order>0 pages with HIGHMEM

 mm/mempool.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

