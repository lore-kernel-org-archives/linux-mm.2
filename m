Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF071CCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 09:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27AF28E0024; Sat, 11 Oct 2025 05:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22BBD8E0005; Sat, 11 Oct 2025 05:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11A2E8E0024; Sat, 11 Oct 2025 05:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F19068E0005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 05:01:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85C1413B480
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:01:45 +0000 (UTC)
X-FDA: 83985240570.20.2BD6145
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 26FD1180009
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:01:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zdqX0Wlf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AIsr5yR7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zdqX0Wlf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AIsr5yR7;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760173303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eTLbl2b226xZ5INaE8Vg7caBgv/GfAbCanwyLTd4Am4=;
	b=c0ewHApsIHHSe69E7S5fhrpqeHpY/yR1+e08JOcQYRiQql2nKLtW56H4/iDciyqUJlnOaC
	kYK60dTzzZ9V30QEl3Sfun4iRH9GF0ex4juz0Ixh8Zi6M6/YwIsnE0EuZGin4EMx1zkvd+
	r/99ydgGMilkeoGkcECAhNd94MHr8SU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zdqX0Wlf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AIsr5yR7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zdqX0Wlf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AIsr5yR7;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760173303; a=rsa-sha256;
	cv=none;
	b=tKfQrZi/5AzQFI2Eim+IiQyHmWU9YeCX8DiyVtsJOqW7709lUwOoA78k8Shet0SgHL63ay
	9Jp0+QrtwebtKhuvcGjWmxelD5l9FPKadspOBiiJUId4eagbRDwF48iL15yJuTASz4qtWh
	g8c00e19SZ2qGJvyUcc2FHP/1PYKHTI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 58FF2211CF;
	Sat, 11 Oct 2025 09:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760173301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=eTLbl2b226xZ5INaE8Vg7caBgv/GfAbCanwyLTd4Am4=;
	b=zdqX0Wlfh27b/HrsFcWYeI3jzO8dLmYy9T/FLlTLzeDvZMMZO7eCn6bpl8CfmNw9L0dBLv
	uelbDoL1xD6NCG4Vex6yYzVyL1xHNefAgi/umYEJgqOPq/b54xMkuSNFa18Uk7ImwgLcBu
	afDpU2rBLj0W6upaIbT/9rCPn49098Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760173301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=eTLbl2b226xZ5INaE8Vg7caBgv/GfAbCanwyLTd4Am4=;
	b=AIsr5yR7jH/9JrOmyHYatE376cKsfC2/AhuxumCKisu+G5O11D3k9Gzns8jRcPLJcMDO+u
	SqdLxzrfkSxH8GDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760173301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=eTLbl2b226xZ5INaE8Vg7caBgv/GfAbCanwyLTd4Am4=;
	b=zdqX0Wlfh27b/HrsFcWYeI3jzO8dLmYy9T/FLlTLzeDvZMMZO7eCn6bpl8CfmNw9L0dBLv
	uelbDoL1xD6NCG4Vex6yYzVyL1xHNefAgi/umYEJgqOPq/b54xMkuSNFa18Uk7ImwgLcBu
	afDpU2rBLj0W6upaIbT/9rCPn49098Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760173301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=eTLbl2b226xZ5INaE8Vg7caBgv/GfAbCanwyLTd4Am4=;
	b=AIsr5yR7jH/9JrOmyHYatE376cKsfC2/AhuxumCKisu+G5O11D3k9Gzns8jRcPLJcMDO+u
	SqdLxzrfkSxH8GDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 37FF713693;
	Sat, 11 Oct 2025 09:01:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aMrfDPUc6miCGAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sat, 11 Oct 2025 09:01:41 +0000
Message-ID: <903ea271-9413-40ed-93cd-104062c18a84@suse.cz>
Date: Sat, 11 Oct 2025 11:01:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab hotfix for 6.18-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Phil Auld <pauld@redhat.com>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 26FD1180009
X-Stat-Signature: unmw6kxua1cqry99tu5t9tfg3kcn1995
X-Rspam-User: 
X-HE-Tag: 1760173302-202688
X-HE-Meta: U2FsdGVkX1+rD7/5i+yNI2mZTloE4e0SQc1aq5kidMv4vN2MLa7sL5e/KOIikxeRpIPpnjErATMyc7W1aIPK2lGTmLzK9fl7ABA3AOKwRsEIjc2VcFgFJHCQ4v7TnK4433utLo+4J22q3rAQ/L0FvFPrdwKItOxeFn+LYBY5lshQV9GKL11gOtsHJFM500PwHSmptRxQw/YShCjCJPqWJSexW8I7ivjuTcQxQolY7TaQsmQoHj4wKt/FFEcNFR7pHfw4NSRjoLffPTnGt66/fCtXI2eacSdHrPUHbv0ooUhxM3LaB+NHJkzUxXqplEXFbMJ9XYFQV4Matc9NEg2+SdeDLQ/4RuH408HTKVr+Qw6sonB1xGjhGJRy82x3vlwWQ38O3+DIpTF8b6oKHf3OO0EG0GsiU99tRxew0aDEntotVToBkz6aOY4OV4ZjxjGBGK+ZdD4cyASX1T9PLlo9FW+3yN2HBQ5QF/++qhBq6dr4Hj/yxLxElZ6JjM2jHk38cqFpxAiB3qIUTudHDgpixFhPiIflO8wDYivshJuvfsoJJMdFBaHSG4gBRrJdlZ8qGVKnneqVJz0u6R1GxhOxVRQ9d87/ayfLigcWvgwzB1nO+FlX9Ab/A8F7EwO+Tz6EWSHOhG22kfIAcR4N/tque/LApjpdetiZKm0b9NVX0qfOo0/EHrBpudZ84YftQ0QNoMOVPsvUWFaK8lMSxN7E2/eo31eM9fKJb84FgV2at4PPsEH2UT1hZI6Aecw53kkcugNZUF023VOiDAuLpOf5r7sn4ZS4LiFkacnbIv0l8/Wvkz/97tR2PqCCTNFWkYt9CPi6J0ZzDWgTy6VHCMmCq8S4NoZ5I2ngIB9QvqyeE3LPp7nM0WkesvBTk1ghxH2rUVr328ITMmZhnpjgLeUyiEnGenk/4e+yn0vWJBbM/AKL++7LADtI0TQoOvwoXKl+BnrLR76amRKrUkuP1Pm
 cWSTdweN
 t8sqSlgxy6csh5IQKtmXR/lMtn5HxsmcwQrrBj6Vn2RqV6ohUE+8kqTr8PIPjdi6boY6tf3ZZk/jexlV6PiAviiFIAFR7mzkYjkG+zhV9FfSgozkEHiRJTj1TVSJWmFZuFUjK112Sa2nM/kchshMYSPjj/eYtuXBqf3lo8nsaxy/OiuY7DW7I80f7FCsJKMo5XjGpMQTmtfLmuC1HqSCODkqnK6OI7QPPSkRI4Om8nJBuIbQw7RHcHH/iU1A6+HIvZou1aPjNWjFXj1nxtGNXSTqobJmZIhvxRiFz/H07lJzbC3XR/v448LNJuofnms8JGD2rQhnp8VUW6sgHgUQr4/f+1oPr5CjJ9SUk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

here's the NULL pointer deref hotfix in the form of a PR

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc1-hotfix

Obviously it wasn't in -next yet and was just sent out formally for review,
and it's weekend so that's an unfortunate timing. Releasing rc1 might
however mean more exposure to such memoryless node systems so I didn't want
to delay. You can decide to pull or wait.

Sorry for the trouble and thanks,
Vlastimil

======================================

* Fix for NULL pointer dereferences in sheaves code on some systems with
  memoryless nodes (Vlastimil Babka)

----------------------------------------------------------------
Vlastimil Babka (1):
      slab: fix barn NULL pointer dereference on memoryless nodes

 mm/slub.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 14 deletions(-)

