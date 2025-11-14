Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D31B7CDE032
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB8F8E0003; Fri, 14 Nov 2025 03:35:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17C6E8E0002; Fri, 14 Nov 2025 03:35:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9568E0003; Fri, 14 Nov 2025 03:35:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0A6F8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:35:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FDA658584
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:35:07 +0000 (UTC)
X-FDA: 84108552654.27.F62B442
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7BE1320007
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:35:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763109305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/cKNJTcTlyiteERL9EHdNddCyOefHsJbJvaO3/qah1k=;
	b=RhuPqM3lD1ZZUZHUVMA1tJm+bKZFwmWheWgXefDwVxb9XGeAYD075jP+bSBXFSYu+Mgq1i
	6MEfvnzTEwM2NYeyV3n3mJka/Im/FnyxCHL1IYR+jPX6YFTyDhPpivD08Scyzl8wOOJcvt
	SbpmLAZU2QKLkBtYpvbDRL/f+uOYDU0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763109305; a=rsa-sha256;
	cv=none;
	b=Pze4VeGV/Ee86TDvxG0UiUYb+VBCv//SAABlVAlYJ2ZD6B5ja9zVZV5UehmgsxfVoCiLmm
	1z5EuYRJUdod+OKqcHI7JLik8m64/4lGaco0jux6v2mqotuL4IkBtvtwaHKyE956Euppls
	rAolqPYHGQRFoWvcNui8PnsZsTTOqks=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 011732124A;
	Fri, 14 Nov 2025 08:35:04 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F5E93EA61;
	Fri, 14 Nov 2025 08:35:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id J//bH7fpFmlWHgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 14 Nov 2025 08:35:03 +0000
Date: Fri, 14 Nov 2025 09:34:54 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/cma: Remove CONFIG_CMA_SYSFS option
Message-ID: <aRbprimDjrVCn0Ye@localhost.localdomain>
References: <20251113145636.731a24e4@endymion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113145636.731a24e4@endymion>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: disp7tni6z6qz6q874wxbt5hibe7znyx
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BE1320007
X-Rspamd-Server: rspam10
X-HE-Tag: 1763109305-664476
X-HE-Meta: U2FsdGVkX182uUpLHy6ZTJMlEF/q4QdLOIuPFU1LX0KH3Ziy3eqm1CtG00pU5SObOUKlHPBAlXc/rtLFXPZpK3in4xs3eSds8+A6PRhJhNNpx8eM6li1MAFutUC6uXxU9vxFq7H0Y7tvQTII9jirbAhWmNm7BpDOrB92EP13ABEh6DxrNPB/yTPUANM/xJBQZOqEj+BN5B7D0KUYvmh9vSabzXKi69xfc3fmCFx4ORwB7kPvsLOOeBrb9NMfcZSx1Fbkmqme6t3FnRzxg9I1Ci+kGRiOxRM1Pqk+r44DAHwPpsBz0hL4uwFHPy5vC75lQREtInoC5zakC8R6Vvg3kg76MAu5TsPuRkDLXnU356b3tt51pxWOkXX9ubfUbAyjBcYWYDb9dYpaLDfVzdt2W66svch5NkGz62CFzbwcydYQhq64UgT3OTcnuFL/hP1JkPRhuk5kUyJ9AHKUYe4WoPAklG9Tv2aqhgsYWNQCZeEHqPnTabXxduTExf+dnBikFaAkZQ46Ny9rTcHzQ7IEAqLknnBhbuz5W6fnjfpMD9cWHNMRYaZgJddiT3rCDh+nDMerx1wEPFG4o80LLKslkb7PdcUcYAI4ZExCo6051x8PD255jgG4bh+XSt3QCrhxlumEMY7mU3ebtr7lAffPV553ZkH/7vgpGLMu+S2bbVBVr+dRGZwIpcQsy6jhYxNyDiJrLxyYXQy7Pv1NTKN/Za5OdKE/6pOWn8DqIQePg/bX38hiBa+6KTgKsMQHOpxG4oJva0WynMww1FSSa1NF6F9I+j7wn0oTTEMoNnfH/eQYufx+cFAN5JivhskYjl2VKTKmtJXWP8OF01usWKc/7Pd3CEng9cuYvrpCfKe5UvlIOXxFeKpHBML5/1lJNOGLVEjOVe1U0Aj7iCAjKmKh51yW8sDjGkUOZ+RAP97iiybSvzeDDTBsWv5uIzz0rRC9/7zsEZs45fUoUKcToh2
 NhuU5gAj
 JUoF3s68clrxMEmea86PBPF83wlRVfwYDZ45qOHIEdFUfE/HhKW3qcF6SwZmP/2RUJd+qTO0iWdvu7CWVsgoZr7RTh3iKnRqyneKfIdkrsDN0FKmIijsQXfAM9GFCPOqetofuhW/RtDmCKztrYqHOB+hMI+pBnlP3fyT+dNRU/jkSjxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 02:56:36PM +0100, Jean Delvare wrote:
> The sysfs interface to CMA has a marginal runtime cost and a small
> footprint, there's no reason not to include it in all kernels where
> the dependencies are satisfied.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

