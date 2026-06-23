Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B5F1CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 15:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC826B0092; Tue, 23 Jun 2026 11:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35496B0095; Tue, 23 Jun 2026 11:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926C96B0096; Tue, 23 Jun 2026 11:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6132D6B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:38:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7DB7A04CE
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:38:18 +0000 (UTC)
X-FDA: 84911583876.06.07B6999
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id C1A9240007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:38:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qeF62V9C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bV41k8LH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qeF62V9C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bV41k8LH;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782229096;
	b=kZ4OXCaKQx09nYLdip2L3e9ZcxWTPyz3xRNfPV7qyfvNKP0G1Pi7toMe62qHXPqP0jKHes
	4q8fUSpu33PELkCWykygjD7Ja/u9M/GTPKqcVWQ2RGKZXe7hU4/qfhXIHXfT9GTz3xugRx
	PLzYUO1dcaVArG3AHjSgGCOLfT+Xp2E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782229096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aA3HPVOr7YF8xREs33IURQZghuJZuFxX+5WHttHNZ+c=;
	b=Guc+rSUeB+T9r+RqSYq+gazWrrQz6yXw7aeVfr+3/vhcs0Lzv9jHK/MTuLExfD/oF5ZOs1
	jEmJFbUEr/BUFeDVX3RsOQTn0f1/GaMpT04CiVnaVV9UPh90z8sFRVBOHbbiUT15ksgiUP
	7kqZOh6x5tgroQ946OdRFAiG0neGSP4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qeF62V9C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bV41k8LH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qeF62V9C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bV41k8LH;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4D57175FC1;
	Tue, 23 Jun 2026 15:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782229095; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aA3HPVOr7YF8xREs33IURQZghuJZuFxX+5WHttHNZ+c=;
	b=qeF62V9CLDIcvxVPfO3FGBs5RmtTxvGGB4DIR+wwZhBSgFRrc9ONWp5qCuHM8t5T6KkxSB
	l1rgJdBUFRsuVJpTPtWTro7ptFk0mVN2a6hulOLAj2MO7iIASDNNynjf4jSSRqvg2cLeJk
	Fbh2Vh9L9RFMXCdPaQTQpaFXObH1DdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782229095;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aA3HPVOr7YF8xREs33IURQZghuJZuFxX+5WHttHNZ+c=;
	b=bV41k8LHrFXfB0yMTmoPXJn9PvnYGMnNJaAiWzI0Si28RUQh+xy7DvF7H/GpM3FY8vtTvi
	VDdV/1JqwenKSFBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782229095; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aA3HPVOr7YF8xREs33IURQZghuJZuFxX+5WHttHNZ+c=;
	b=qeF62V9CLDIcvxVPfO3FGBs5RmtTxvGGB4DIR+wwZhBSgFRrc9ONWp5qCuHM8t5T6KkxSB
	l1rgJdBUFRsuVJpTPtWTro7ptFk0mVN2a6hulOLAj2MO7iIASDNNynjf4jSSRqvg2cLeJk
	Fbh2Vh9L9RFMXCdPaQTQpaFXObH1DdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782229095;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aA3HPVOr7YF8xREs33IURQZghuJZuFxX+5WHttHNZ+c=;
	b=bV41k8LHrFXfB0yMTmoPXJn9PvnYGMnNJaAiWzI0Si28RUQh+xy7DvF7H/GpM3FY8vtTvi
	VDdV/1JqwenKSFBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1878A779A8;
	Tue, 23 Jun 2026 15:38:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QkqWAmaoOmqtcQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 23 Jun 2026 15:38:14 +0000
Date: Tue, 23 Jun 2026 16:38:12 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	liam@infradead.org, ljs@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, vbabka@kernel.org, jannh@google.com, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, david@kernel.org
Subject: Re: [PATCH 1/2] mm/swap: rename subpage->page in
 folio_dup_swap/folio_put_swap
Message-ID: <ajqoTDkE2-iDGsv2@pedro-suse>
References: <20260623125723.2503832-1-dev.jain@arm.com>
 <20260623125723.2503832-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623125723.2503832-2-dev.jain@arm.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C1A9240007
X-Stat-Signature: 334s5yxpk95m8zz9u6izy5siotna36m9
X-HE-Tag: 1782229096-3086
X-HE-Meta: U2FsdGVkX19WOAB7DkyM1V+b/hoYDtfCGFD09PqNiteeYosxtYoUAUsBxf8zYx3wEIgwU6Vx9xChRe+KNvOVJoaJWeTG2HlaGNE9s6xdudc5clZjFCrkKCKfgT8nF/9LQ9WwBLs0UQbrmVuZToDDAk3WS9flvHiAnENKgimQyg+fKYDWDP+f8Clp7f5BCBWYv7TDWPJdCzQ+FdUXob9ohRLZxt5ZitlpBbCx3BFfuyHdUc1KNzYbSenMujG0RpfV5XipYt1RJ7ckHZmTJmiEeme/n0X8K3GBLbd4K75uT1zAi1f2sj8k53f+q1TJAGfFpt4XCRBQK0D04OrykC5jTw8zXoVzzDIwiJ3iI2Hy9Rzm3SSj4JFKPw0NWxj6sipNoPt4As52nJpe1KOUUB2hVrDpvoaj57QmpZyOSu1XZ4sWpkCcCVzrSuvbH+/Abf/jzABj1JAsCeOwhdPfV6FKp/cy6BhZ6qaNiXNmQes7csqs37GwoPThjWbAN/UT76sz7IZLnFv88oBOilJeqIBGW18Q8CXqqprcpHgFuUHCG9xjrRyxVxBea33wH0MdnGOS7Qw+NndGCk80MsFlRLhuETohEtHsKVHrCVXEKyPYkQCmc36M8U+3cVk/uLtwFZr1FYeXzT/Y3f6Bk5qFjG9CV0HjWUT0QAqqTSnA75Qmd7Q559xxNIu4N1s/qxFfxYpB4SD4GssKbMK/NC7r7oTyD1b10vBlJ19LBtgg8LO1P41yHCbQRXVqaY5fXs3zEgptw7mlJXNVDdaR4ukdp1y15Qu8OzbnDOuP6uG2unedOmkwp2a4nBVKtQYgRPC4GZNMUt6ZqDOj+cr9z3cvAGeNtsY9eulNlD8/UUCyD+gvDVeMBRCYYzYBn5AHkIRibqYAHcTkgfzcWsmfMcTMjClP8KTnjdWdDXW6rKwewpAn6EoPEltajt2fjJozolCDCoLzxg6aLNHV2Iwsl6H2J7M
 iQulcE5l
 jVAsyP4odnpyvpR3UfBPvX9PbloIsaK/0OWovTARcjPyJT0YWNEIvrJ5qlDbpBkhMhlxtxo8clu7ry6wMSlmpXeAO+f+O+R4VaX+Bo41e/cs9loYiK1zu3ukMI3bgPGClUNDKj2ATP5YCdXkWZHAjOI1teHRzVIeOH56jvbcOHfppsgFU+2Yz7aCNpsaykMlj7nkwVjd27fboBWxOQhzfY1GL51F4735oHMnz4EWaR73PtamAvYrDOiEOVLm2+i7G92H8vQm+D/BcUhBW5Iu8YRUQrj10wt+W/qqeMT/+dKoCyWQCgug25gls6BqF4FT5xZE7UXFp+3QhhtMNL1a9k17VeRokMrSv1GdQyCMiSbYAaj/Az7o8XyH0q4L76PVpo0BlP3AND98uPnI984+disTVapTcFE5JKUMA98voixboggp9Tf1GPNem4dAoewOUfi/CzKuXb/Ubv8SpDC2KKOilXffJLKzpgCncp4Wnu0XzmkzvGIubZiitPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 12:57:21PM +0000, Dev Jain wrote:
> Folios have pages, not subpages. Rename 'subpage' parameters to 'page'.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

