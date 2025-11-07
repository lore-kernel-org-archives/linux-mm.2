Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C707CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 08:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841B28E0008; Fri,  7 Nov 2025 03:53:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81AB98E0002; Fri,  7 Nov 2025 03:53:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F118E0008; Fri,  7 Nov 2025 03:53:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 616F58E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:53:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01188C03C3
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:53:35 +0000 (UTC)
X-FDA: 84083197632.25.938E6DC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8FE304000E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:53:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mttVLyU5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DOXnMeol;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mttVLyU5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DOXnMeol;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762505614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OI+g9VEn/lEjydhs1xOusp0hhTH8pGOALrK0SGGXGuU=;
	b=1uyOBzsG+NNMNu50H3hmSs6HY9ZOv/HRj5UxJc9o6yhqrTNDw2xfr1towV9dyJbQXwKesF
	Tc006JomIxWtZ1yVVQbJ3Y7AlDA/BZ7owryYyWGG269/RFpcW14euH++6NNfDxIB/RGQKy
	qX9NzrGk8pczwlGPA2PXqA1J7m7c3aQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mttVLyU5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DOXnMeol;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mttVLyU5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DOXnMeol;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762505614; a=rsa-sha256;
	cv=none;
	b=DQSri30S7AgVHjfgFIcm++AREmDeev2EiIX0M43jn0hNZWhTUygr/eU0Ipz24hiOaNl/6H
	C9MDfgp2gx3IVJd3mVA5vxmOeMEyQHl8XJ+IzVAtypvJJ1x1dYgz+Od25bBpD7UOkq/woq
	XlFMTMFgK7JE0qXWwtzy27obDtvxYts=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9102121196;
	Fri,  7 Nov 2025 08:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762505611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=OI+g9VEn/lEjydhs1xOusp0hhTH8pGOALrK0SGGXGuU=;
	b=mttVLyU5nYz4nSQEYswqriFYUtcaUfJsl8b0ZT/jxmoq2TX5lddeaYKIy/uWLJUi6yd+49
	GiWZOGR/weElSSn7KtHArqHGMSb9KyCIuX6FH7WCwneDJO2A5n8ugjC9qM7RtqBQOPWq5M
	VxTq9XFNzXCg2clV+rx6iiA3EsEWPqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762505611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=OI+g9VEn/lEjydhs1xOusp0hhTH8pGOALrK0SGGXGuU=;
	b=DOXnMeolrIqKTq6hovhbao+XArJpKFNPUn9z3I48ksOevHEh2WVtkOkwhnEN+U2/9Q/VkK
	nAl0dgvwa6P961AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762505611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=OI+g9VEn/lEjydhs1xOusp0hhTH8pGOALrK0SGGXGuU=;
	b=mttVLyU5nYz4nSQEYswqriFYUtcaUfJsl8b0ZT/jxmoq2TX5lddeaYKIy/uWLJUi6yd+49
	GiWZOGR/weElSSn7KtHArqHGMSb9KyCIuX6FH7WCwneDJO2A5n8ugjC9qM7RtqBQOPWq5M
	VxTq9XFNzXCg2clV+rx6iiA3EsEWPqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762505611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=OI+g9VEn/lEjydhs1xOusp0hhTH8pGOALrK0SGGXGuU=;
	b=DOXnMeolrIqKTq6hovhbao+XArJpKFNPUn9z3I48ksOevHEh2WVtkOkwhnEN+U2/9Q/VkK
	nAl0dgvwa6P961AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7AF66132DD;
	Fri,  7 Nov 2025 08:53:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WaCxHYuzDWmQYAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 07 Nov 2025 08:53:31 +0000
Message-ID: <2dfea88a-5ba1-4311-87d2-e1e66c2f885e@suse.cz>
Date: Fri, 7 Nov 2025 09:53:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fix for 6.18-rc5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8FE304000E
X-Stat-Signature: mbay9i44ysjcyidoz3hyhy9b6qxz9t35
X-Rspam-User: 
X-HE-Tag: 1762505613-523230
X-HE-Meta: U2FsdGVkX1/0Mcp+OiaJtkMUos/rJNK3i/c9l/TE4WqNqevL6HO/laIrab+xXO6q5y3Eu1Qy0kQryt7vCpZvqza7jRVBAp3odBLdJx68vahkfdGEK5tYn7WJQ9oExwlWFME7iqJYICZzNa0n7kQL99doEFAt9WaIOFy3Z0HUZtCYxqMRYN2GxL9/yrBtAnEHl5EqLapXi8JmOnoRYO4xmhCBOeGUnIVjmhV6WsaAkHIKdf5QOdxieHYfREKHCpxnAPP9ZSP4+RkVSz5pMLLNU4DMLkvcFHy8BKeeHI6XQ9Dd71oysWMKEYKOICD7+SFHPVxQmDMCCwyONSwNmTJr/BzygOwuokXCI5OYhn+C0GcvmqulIYi61iPEOA4h4/vv3UqT/dPNkWZ84qtGaukeOUlsQ0yn0BQ1WJH/ayY9VrcifAKltuDUu2VzAodvtYoMDUGGlKj15y/uIFH3tfYbemlYVh7ywJ92gh67OddONQbohW2Jb9Qx0Re6IDTUlFJwfBw/rz4jV4EAIFvZ4dUT1bIlj1DjPZL3eVn3KEXYmbRDw0yQIUvE70sYAH2wm3MHcoF+kBksUIoKng06QiClZJ4BztspVuKHubBWE8Y8r6ynhmDKtBNUkAj6/ZWFrc9g4wq71b8GJ9BTZJ+Xh4hVL9zxql1GGrTYIXieMQIGlHnF0GyC1GrjPFOTDiJXSWr36EHjXqQ7NZftqmqULi193SZHbw1VPoptwnGm5zp470zO3eP7D5nsUA/aSv0hQ91zLCQ4sWlRyTbSr/kJaSywRs37EOTMs7eCbEhTliedR0o4jGChrbxkXKS10ywOcQGGlS54vKkw7DQxfY5EyqktBCG2ELL0vT4UC/ttpyy1W1I5A/OLVDzzs/qrDnQaOqJpusWV4H3y++a+YVjV0rts6Fyz/ZpR5Tqqn6jzBLY/l4N44JmZHpdSzYpbztqJbggAQkY3+EqBk1U3yJ5d73n
 +DySfH1q
 RGS9wN9dTqWC9v/7YSeypi8zaJSJnF/Nz2Nvr/pQt38nZ+RNm6v3fItzull8loKOT9VrtZ2hygavWmB9FSx60hInaxM3PnVbbhDg5VgkxMWNlQfQ8CHanhJlrNglswld15jmZ1r/azIuMGwYc6SDeqrTLt2ZsVjCg8y8QDKgqULr/utbzzhK2fbKB0YZGISHsz/LjmtBbyuMHxpyCCGe/hPyjkavVdcP/GOV1gvbpSDjLXp+ptcOJdRNU1S0XG6bxvjOTpPlg7wC4MtNucDFGMQ/2I8GYg4cG2K7z51FzLNL70s7yiffH7vgyTfzND7+XDYUGQzweofTmlMeq1PSTafYfThhcf0bUIqEC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc5

Thanks,
Vlastimil

======================================

* Fix for potential infinite loop in kmalloc_nolock() when debugging
  is enabled for the cache (Vlastimil Babka)

----------------------------------------------------------------
Vlastimil Babka (1):
      slab: prevent infinite loop in kmalloc_nolock() with debugging

 mm/slub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

