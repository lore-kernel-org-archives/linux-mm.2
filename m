Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCF95C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 13:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C43D6B0088; Fri, 25 Sep 2026 09:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575A16B008A; Fri, 25 Sep 2026 09:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464096B008C; Fri, 25 Sep 2026 09:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 269C96B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:57:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E25680609
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:57:33 +0000 (UTC)
X-FDA: 85252437186.18.60B666C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 764C44000A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:57:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n9VrK9KR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="EYWd8/Ng";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fa5QEv9A;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="pHZ/02op";
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790344651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SstOdJt0LU4xkWey0oMkpBZLgP+NLIAF6nid2CItQJg=;
	b=ZsMVa0ARcKeVfhKgriLo6BHOUWJBDKTKRYCLFXmhEcnM4mWg+kJEKAbBm7rt5gZfq0fIie
	J1Txk5kJC9ghFu4k/1TDI95VWZ2EgYdSBB6LaD/DAiLr5z9AMKsEhBsrGOVAgbDmv0c8Pf
	tVkJe++rjIBl+yBZHXyw3UiiOOKzyD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790344651;
	b=vB2IJvXosx7FAdLhxMpz1oJugesDdHQJqh0Yu/oBx+N6lauw2XYWEixUU1Dqu8OzecKnj4
	FzUUxVDWHCv9WgABK8uNw8Lkdi96BGCIG9XDokLTRs3mfLV7km4HFF/TB0Wuc7MYueXkcb
	WFBGEoHI3xKdCY9Lb8mQ5FnGN0ZnR98=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n9VrK9KR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="EYWd8/Ng";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fa5QEv9A;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="pHZ/02op";
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A64BF1FF47;
	Fri, 25 Sep 2026 13:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790344645; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=SstOdJt0LU4xkWey0oMkpBZLgP+NLIAF6nid2CItQJg=;
	b=n9VrK9KRs2BOzamyYU+QSlM1mA92T8Opl+ox4ZIObU/b3St/tiC4sVDmHnPlgKkKBnMmdI
	ycTwcOxWGM2HXQI0OE7x0FWAAie41ctiCOdnZwAcInnLOaMCzVb7o0/m/fliwJx5vZM6qI
	Tmib3sSYESjtZvAfnh4C0ljSBquknAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790344645;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=SstOdJt0LU4xkWey0oMkpBZLgP+NLIAF6nid2CItQJg=;
	b=EYWd8/NgWX6+Vg7TH1qRhawkh6w7YvH59/f5QwnmOulc8fjYwXA2kOCN+EaqAzkeGu9ekk
	RD4iyw6txJQGkAAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790344641; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=SstOdJt0LU4xkWey0oMkpBZLgP+NLIAF6nid2CItQJg=;
	b=fa5QEv9AlfV+Uv3jV3YsjTZcqmjIpVSyPZS+QpJ4JqKSyx5LQevukbejL4BTuX5ErVvbUP
	EZd6HtdY6TZdzIdPVU19HSAxCk+A4HQ0l4rGDKvQeXyY43F26oybkHeveJfgfGahzxhS9E
	Fa+kYCsVgqusdqs6IcjzZWGsBH5lKts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790344641;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=SstOdJt0LU4xkWey0oMkpBZLgP+NLIAF6nid2CItQJg=;
	b=pHZ/02opGhRfoDmnYoE1EyA8qPTxGllnghc8q9GDyq5kRCISa8Awt17DcByu7QtvtrkLbS
	u9HJbwBlAAUHDVCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 98D3E13274;
	Fri, 25 Sep 2026 13:57:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9S3lGcB9tmp3TQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 25 Sep 2026 13:57:20 +0000
Date: Fri, 25 Sep 2026 14:57:18 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org
Subject: THP placement BoF at LPC 2026
Message-ID: <arZ5-VB0xkq-dJzG@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 764C44000A
X-Stat-Signature: zx66eox9p6bc1gztrox1rfwut469nzx9
X-HE-Tag: 1790344651-127737
X-HE-Meta: U2FsdGVkX1/re7vnYvSJ2LGY+k65qPYwUmVDEiQvwdyKSZQjtotoVBhx9mRmSPTvwGaewrvpGHhHhywJF2foSFZWjIFgo5sxdaeSqiZLRe57dEoZNJ/jt9SpvfuUl5++L8/acq1HdN/mtSFjqiYNusR7/E+St84yvxOoZeDlki6IGx7nz/V8B52xl2kNyj6BFxMwdk02PQIUbt6jz4qL/439o61hBLvY+M2CIEBU1SJKWUZpPq4YCoZulv5C86D0LfXnUy7pmbYOjdyEjrBbURBmEZoM+uTzuYyxXMPOKnfts3TbPQh/2N7WZw+rFB1kybFrIt01mFssA/8cnlXxa22POmF4Op5DWYZVWPF9T4bOEfw09uBUo4RVXJxzbdVizb9GIC3CM7o8vd6YYJyT4aKLm/GkoOcc2q6i1pIu23BLuOzjgGWYd79KIPIANdRNmyGodQlToiH4WRrBkzkGR7rEn5uoK8xf/rForj7WQCn1XMCmlobc+HS0U5h9IK+RmuoMOVASRn19a+6YBXwcKW1MZKZ6FtzByO2xoDEtgq3eiaZJyhPjaap7YN6kCYvACS1vdzX8gM4+tBOT7TjswvC24YKYnpIX+dtdz/Gp0uDYj90jG7nMJB+pW2LDGVx4zPfnD+Tp5sUJ6Rw3pgfj3jLgIeS1w0lq/Ff2RwGjnTPmQ1qHD1q5fUUClBNjpB3D7Fl1xW7PHpi5yeeKtSFlHVLpJTlm+rDZ2Jd4W4yvcWQN+0yZr/gRd00G0jUWSiiueJ+H3chua5EUjCRixlWcMHdU0632UfaACDMe81ysPxNFrchb0BR6fac6uRDNysmRVRVI3V9t/1nsncYTeMy4yPPUnKcj+DpL68CP4hmqQwDhYq8mbDSBxHkC8f6BfHBPLq7xo4Qd9DygyDdv9zkjQRm1yAji4ZhEQgzWXbif2yOJ9RFMww28Dj/rXmbxXc64wv47GajK38osywwQ/km
 MR0mhWzG
 WHdze6I/4JeiekjAvhXx5aAw7G0IQekS3P9lidyDvdqBdJhoOuevYoXf/eSUKTknF953OaGfitt7kQx3hsrwNp2lW0qw3/ebrOaEdfFuPnpxke/2T22hq3lcbmYa+QBH45fB3JETUmkAWUwtCCbUl+EzwMWpnCIwsaF217MJaOct2KZAKxxDRiLBs+PMfivW5sq1NdSvcG1UJYpeG3K7v/aigouvpyUeoa0a60ZcxyWV8RY/GgkUhlAEdXs3obO4A5Zyahno4qKJB+hppzyNdpLt7N/FznxEBOdJ3bu1+cI+fRXC3e+PL5/wsP89YAbzyqKc6WmorxSnzadFTzy6O79PicYmM91maObRp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi folks,

we will be holding a BoF about all things THP (but more focused on fixing
placement/not-automagic-THP issues) at Plumbers 2026.

Session link: https://lpc.events/event/20/contributions/2452/

The point of the session is to build upon the latest THP discussion at LSFMM,
and build upon the latest problems that have been raised over the last few
month, to get somewhere meaningful.

I added a bunch of probably relevant people - it would be great to see you
there! and anyone else that may want to join of course :)

-- 
Pedro

