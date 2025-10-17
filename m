Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72050CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC0C8E0051; Fri, 17 Oct 2025 04:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83718E0016; Fri, 17 Oct 2025 04:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4B188E0051; Fri, 17 Oct 2025 04:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0DD38E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:49:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E01AC059F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:49:52 +0000 (UTC)
X-FDA: 84006983424.29.74DB19A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 21F04140007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:49:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CQEwr1EB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bHTGOQzT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CQEwr1EB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bHTGOQzT;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760690990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ae9iFhBeXshfh1bj1GOOzcJ8d83WfJcMqGbedf9QLpw=;
	b=YJhFDHHKWEbhhuXdWwT89oTN1zSXTb9kHYYCfnuIbQUutXyRAuqlm0P+sq13H9e3SK5eSO
	OVHXdxH8BwgbG4198EDCnDn88s9He8JhumtAigKZK5GkASSND1kArSZQupSDhaPCpIRdhd
	KG/0w5MbhXE+RzUsCoYgFbCn13xcE6k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760690990; a=rsa-sha256;
	cv=none;
	b=0vnhmOMYpZQNn+s7EKS12a1FSjGJeuDDkDQsJDdOp8206fN7DT0vQ3+Qn11hRkK6ZKXKrx
	NQ4Oh33rVZa7O6thIxquB7zhnrQ7C3vIMPWQHHeS/AAC5tFk8NlGCH3Fvek87FmnrXycX3
	7oKU0W0NgCoBNM01G7EAzHnZYasdiSg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CQEwr1EB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bHTGOQzT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CQEwr1EB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bHTGOQzT;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 03F4621894;
	Fri, 17 Oct 2025 08:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760690988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=ae9iFhBeXshfh1bj1GOOzcJ8d83WfJcMqGbedf9QLpw=;
	b=CQEwr1EBkzJAxG+B0Ws44J7ZMn7iSMs0MhomXxwGeEZvYvHD+KXpweEyc4TGHOA2VUEVNB
	6BhnSe0JkWkcTxM/Kig9RmZc5GXTLD4hw/jBpaxrVoBqSEC0r2jOsvTUEAsmUp3QOEvX3T
	EsOZsL/Qp4hy+O8dh7Qhd4tfFMhLVO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760690988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=ae9iFhBeXshfh1bj1GOOzcJ8d83WfJcMqGbedf9QLpw=;
	b=bHTGOQzTecnzuI9Xy+Ph/653r+VxT6OU1GB4Q1v9RpuddMAbk/8mqwTTdKXyeypmsXTXz6
	6SAW66iyMf/V+nDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760690988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=ae9iFhBeXshfh1bj1GOOzcJ8d83WfJcMqGbedf9QLpw=;
	b=CQEwr1EBkzJAxG+B0Ws44J7ZMn7iSMs0MhomXxwGeEZvYvHD+KXpweEyc4TGHOA2VUEVNB
	6BhnSe0JkWkcTxM/Kig9RmZc5GXTLD4hw/jBpaxrVoBqSEC0r2jOsvTUEAsmUp3QOEvX3T
	EsOZsL/Qp4hy+O8dh7Qhd4tfFMhLVO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760690988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=ae9iFhBeXshfh1bj1GOOzcJ8d83WfJcMqGbedf9QLpw=;
	b=bHTGOQzTecnzuI9Xy+Ph/653r+VxT6OU1GB4Q1v9RpuddMAbk/8mqwTTdKXyeypmsXTXz6
	6SAW66iyMf/V+nDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E21DF13A71;
	Fri, 17 Oct 2025 08:49:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F5LcNisD8mjvCQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 17 Oct 2025 08:49:47 +0000
Message-ID: <a22d61d0-9291-455e-8aa1-c19a4574d772@suse.cz>
Date: Fri, 17 Oct 2025 10:49:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fixes for 6.18-rc2
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
X-Rspamd-Server: rspam01
X-Stat-Signature: 9eukexm6hsqhuhx8f8jf14t8cm5ffse9
X-Rspam-User: 
X-Rspamd-Queue-Id: 21F04140007
X-HE-Tag: 1760690989-105498
X-HE-Meta: U2FsdGVkX1/ubJsKJxTQRVCfvUV6m7Jx/Zi13AI00mjPTKhhOnOERLVRRqU7mH9xqvShSATSrlEEwSzl3jth+LlQX/UovmuW/hZwI3kN1qx5Mep6Ir1oMk8KkMEa8i/SghIurG/lBCZ4ggniHtI/Fw4JAIZny1cOhF7UQXlAuImjkk7IHpzvHV/D18shsJkENVoimLkdbG5jHXhDSXBl8zsg6a1qLKj0TL+5IOOdlja5IhN5kGIh/P85Mew9MGJKM011OfG5etw95jZ2ymzSgHq+LWsnD6fi3h8JrbhybTbLVd0a4+9IiR3JhXq8thVZJD5mxAZj3Ao25aK6IPN4YPqSTvOP2F0CLMMJzO532BIx+OpwQIY8UbKkt7PAIqAZAsnAaID6AGRzIU+zBNYCimerrVXDhAoVXq/qQpQzqyNedT1HdA5yiFCeVI4i+Dxi/3rzyh/gesAzfeVKp07LOCQBQ38oqvSbgEJfWKlOdoJsyXn8ybpXLILbFiSI68ghSbpYkCM2REG+r0JIhBcFhZWtKgXFhh/vIMB+n5Spi/glfxkGld4kfeV6Ncma+TwAr7GhT3NkMiuJJRvR60LFMK3ZCs6ENc5UnpXP/B1memFJ/6Qw0t+zlxKfCXTZ4akXFtiw4mWTFh2YxzT3BB3HC2+gy4veeYTXQllrvCcG9QYBo/ixHlYEPUtQ2NQpQzwmd1APrOuw+m0kNTBaOu9VDG/YI0qQ0XS+c/1pOgXM6C/BsQqc4GplaCgVpz1TIpRgFq7X+6Rmn79zMS+FJmAxmZXrwm8xV4f7UPoId9pMEMPPNgKeu9Ank5WWHrz2MvjJ1+OxfRDmoAOHAzdSSG35sQpOh6wbrdnZbZw+3ZVAIxtKac76f9s1lSuNpaFNBlIpqVw9ZzSl4Yo82BfFkJw3gNIYrJBk+9ycefxsqA3qlOcA2SQhWn9O6yuzOGiNRDFdKXeCJxjrNg9ZtUKjG80
 VO3VCv9N
 21LsL+GVklJ5R5BU2tgBejmxFeXUmLeALApOrxN32wUnM+PRzUyW7x7uAApNnzclqjGuFrDhP6T6zTEXhdAaRFTKARkVYJsfUpCyofcJejR0wDCWGB8hXA6x//CFMmkPEDFB0WoEVaBI2X3RlUf9dk9c5kcPE4z14F3L6kgRNN5Mt0LBwuCvLbClKYgH/7ML3GylX5S5FWS8MTlvn/XPd486GndROwOEJbaqK5teDK6wX/LdzCq8UTYOKUeYl5G/N9Ccw5OLotXratz2AOl1pizWNr6SkbuT6PqVRdYynGbsTMHIW1zimaC2R9HBPNv8hSZsyXFOD5AEBBpdcpBDFGodowB4/lmrFkFd1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc2

Thanks,
Vlastimil

======================================

* Fixes for two bugs that can be triggered when debugging options are 
  enabled (Hao Ge, Vlastimil Babka)

----------------------------------------------------------------
Hao Ge (1):
      slab: reset slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL

Vlastimil Babka (1):
      slab: fix clearing freelist in free_deferred_objects()

 mm/slub.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

