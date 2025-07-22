Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A8F4C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 12:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082676B0088; Tue, 22 Jul 2025 08:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032A16B00AB; Tue, 22 Jul 2025 08:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB18B6B00AC; Tue, 22 Jul 2025 08:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D84E16B0088
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:01:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3A861303CB
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:01:38 +0000 (UTC)
X-FDA: 83691761076.17.1909E11
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id A223612000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:01:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753185696; a=rsa-sha256;
	cv=none;
	b=uP14rlQhlUbgsNdA4jzRCTAVRWyt+KCyT/d8j4utZeo5ctpOqebqok3tQQDWaQ8WqdyR5x
	HmAhgL4ni2bdV8SYy+RCHUaNw6dG5jlzIJVqJP3/RXNCD+dorS7HqYUq5ObVft1DJPi5AM
	pLnIID+fQFCptHJg9/n+KqaNb64GqzA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753185696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQKEvBAhBMZ92+P0CAKQzNN26DGtLry7WS05D5lDTQU=;
	b=SSFxBk7uBEmV+7cikrS0spkmQBZq+6nuYPqt0z0hcfyasNPHzKjHQtUANgREo4dlKbsscH
	nhEOoBsOKFAjeyUi5ZgKEeNa8la5U+yUBhbmnjSfAIBGlGkXAJxuc0LZsSLpADZkwAzrYD
	EQjUcIBKYyeGw1Cag1OyywmcR2wRykI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 547C41F797;
	Tue, 22 Jul 2025 12:01:35 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 89D2413A32;
	Tue, 22 Jul 2025 12:01:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FnhVHp59f2hsUQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 22 Jul 2025 12:01:34 +0000
Date: Tue, 22 Jul 2025 13:01:32 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: kernel test robot <oliver.sang@intel.com>, 
	Bernard Metzler <bmt@zurich.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, 
	oe-lkp@lists.linux.dev, lkp@intel.com, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, David Howells <dhowells@redhat.com>, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm, slab] 5660ee54e7:
 BUG:KASAN:stack-out-of-bounds_in_copy_from_iter
Message-ID: <22ohbihitxnnvgugbp34x7tlsdlvcdrji7h6unlgpxqy3golrb@ha4ywpuyo5ro>
References: <202507220801.50a7210-lkp@intel.com>
 <jehx7y7mwer77d2rrx323qixc456ffod3qrcssemkebjotstbh@fpklsa72lzky>
 <05001622-737d-40e7-8adc-5dd23e6b9bcb@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05001622-737d-40e7-8adc-5dd23e6b9bcb@suse.cz>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: 67idcgiwp8gjuo3rj7oxb9zjf6sb3dip
X-Rspam-User: 
X-Rspamd-Queue-Id: A223612000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1753185696-147194
X-HE-Meta: U2FsdGVkX1/4qW7KU9CeYjkLM5PwDOYHSxucDHCdXQNM51P6T8exkEHJDnLq1Tn12ExsDsJTlmT+GQD6r4fpOnFPnwKkf//VwJH1oUg8nvHdjpfOEs1YPtooNFC0Z+5OEY16RDVcihpIHQJ/4Vw8JSlDL6mCmOCIdeG/rp/FpaIMi22w1Vp/WdHH39GakORvWH+dLTB+l0Z/zVG5OTtF2rlI6ESAfBY/UO6nbhzDqlXOYz3yquxw4M2kLbXARVTU8M1ojrI1Gq1Kq1b7AnoCkrnY8m7vdMwsoyZzyHtHNxfDtakQJZBg0Jh7Vfp5AzlwumaDePSPYmxqZ9CnkaRzjb5ya8Y2MIYM4RD19KkiE9CHmO9zXIs3Mao7W/ozEJhpgkyFTImGjdfX/1geI1vGRCD8NBG53NnqEM/iDYF1iHPp2f0qaEJSFR4zMWVaahFp4piX7jTETxUljZvUs0ImhmZHNwafYXHjixx+sKsrrYaBFvVU+lRrQuVA0/f1W46NYXVHO1uSgyXvvK0PPy60BkErjl7Vp55zG1xIQ5K/HIBMjOFeWqtzjmDsvyRoPAsdySZmZ2oT8J7vFiyJm19hWUPIFnViiaZH2wLYMm8ftzRMtIZE6c8DbKDuGVbHgNORLzsvtpLEvIg2Orf5zPGa2rrPeWTGvhdtO6lNmvEWZvKk3DQntfsdHkByLUE3dNCVU7euSVthkffi+vFfQtNxodXf3bfjSDSRGqWxc7XwQE7zEiWoyVwzS+ZLyrZAEjDwnC98uvowV0uooQIY9Y8w4YFbZO9zoqC6BgFb3BDkru4Zjk2dQXY+H7CGIZRVxt2Qrjs9pDELmBYGRi+nMrmIkbTPR0Aq7c2bq+l0YfX6R0iMu/94EWFx4mnQG4bUL1OPpD3rn+cn8QCzDhNYycibc0MW4A7r9UzP6wpvLdHbyTldz6ekrjWOog9LFZokCOgE0B2YAli1CmF1GVFDBJi
 W0JruyRF
 j5e3NK4ySfv5I9r4OElUmXkZavebaAlmikPOqb5PZrzG7JrpoFMC4Va1BW1CsWgKG9T2L23CvncdNsuCSE4Ig5MRP2HogsYmfHk7jPkh5cBxAY0ONi0gF6osNbIbN6TM0C5f6qXlVRxBfe47osSOC+v3EcYIKQkNwpsANiOpJNdGpppTmAGaAIpESzTZLIf0JjU9fwlcF0Q8x8IXDKwSYCYlEHOKANzFkN4DQskJyfZrSNduHISrRo7niWB4+iEAfKrLQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 01:32:09PM +0200, Vlastimil Babka wrote:
> On 7/22/25 12:52, Pedro Falcato wrote:
> > +cc dhowells
> 
> +Cc siw+infiniband maintainers too.
> 
> Thanks Pedro. Hope there can be either a hotfix for 6.16, or the fix is part
> of 6.17 merge window (and I tell Linus to merge slab only afterwards), or I
> get the blessing to include it in my tree preceding commit 5660ee54e798 (to
> be merged in 6.17 merge window).
> 
> Also would you submit the fix formally?

Yep, I'll send it out as soon as we figure out the tree situation
(I was also waiting for comments from David, if any).

-- 
Pedro

