Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 478C2CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 08:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434DC8E0036; Thu,  9 Oct 2025 04:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CF08E0002; Thu,  9 Oct 2025 04:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323C08E0036; Thu,  9 Oct 2025 04:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED068E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:01:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C80A111A7D6
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:01:40 +0000 (UTC)
X-FDA: 83977831560.23.305D7CC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id A318680017
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:01:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Y9ZWb5GX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rifxSvZ+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZxIoF4LO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yK4OMB9e;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759996898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LxltF4dkzdwh6jot7QMtNml0hcUKaWzZhVwWOrFpfOk=;
	b=tYSwtV6BFqCM2ukjguF7PmLQNzpSpHtqiByhe1zUhTeBvQDP5XCH3lWVsd9lz2U1ZEtbhL
	VBNRgXu8c+7sZWSqxO4a4U0LojKZIIGgZae4EQ1bJcuhdTGwJRJ+/NwYYK2+afWxBMtyO0
	d1vLRWhJ8KRn3ilFlRj4R9GL5tkVJPU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Y9ZWb5GX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rifxSvZ+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZxIoF4LO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yK4OMB9e;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759996899; a=rsa-sha256;
	cv=none;
	b=hMZzofOTCUi8aFUNznHEirabhVXsuMAx08riQBmfR0b72+fQ+mmCZQ0fVU3cAIH2VadzQ6
	4/WkxK6efA5NCrM5oyerIL3tZTSI9AvUrt/YnMZgzbtI4a15PaStMYvkJWEVi/yr6NfPo6
	TjpZraETX03pF8XgfHBoDy7wcjuQNKw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3C5152245E;
	Thu,  9 Oct 2025 08:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759996892; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LxltF4dkzdwh6jot7QMtNml0hcUKaWzZhVwWOrFpfOk=;
	b=Y9ZWb5GXyC7HLDHnuy3lGQZgvXzHlmQtuYSXnrJ0ZWYmdzaUj4CfZAGjoAJfGQUX3JLrW5
	ane2RhKtAzQITCXc+bpOuCoX5XddEIiyd1dnDVjz8bfX501p0ZGP6P7fnk/2nvKFXS49oz
	NABSJyWvOWkmrd9BHOh6w61lrltHsx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759996892;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LxltF4dkzdwh6jot7QMtNml0hcUKaWzZhVwWOrFpfOk=;
	b=rifxSvZ+fbU/gYJ/h1EEg83AXCdY5jTDt9lXvzpyMXfkVy+zqhY4uLzs3VR3C6fPkuT47p
	OZ3EKQcQIyIUf0DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759996887; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LxltF4dkzdwh6jot7QMtNml0hcUKaWzZhVwWOrFpfOk=;
	b=ZxIoF4LOjZ3VshzQhSmJwnmcNKEUApnXVcbWo+6zhdja2EAR5eCza6N1vGYvd4j1mxdaP9
	GQHBsbxIQHQa5acXI/yc6VOQrLtsWNZuqfxqKCKT5ohxEgukwJ1+AimW/lZFVzmZScG9if
	ZgP1uvKS1cI8W66Lz/x6jYDC9MN+o8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759996887;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LxltF4dkzdwh6jot7QMtNml0hcUKaWzZhVwWOrFpfOk=;
	b=yK4OMB9ewdh/PY1JGi6fU+gIHv+ZPZC5ucv28NWOq4GH48AvW//T2S/bKl/Xi0Pq7NrJeG
	U32+FeIrBgkC3/Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 83AEB13AAC;
	Thu,  9 Oct 2025 08:01:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q6ZsHdZr52j2DQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 09 Oct 2025 08:01:26 +0000
Date: Thu, 9 Oct 2025 10:01:16 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH v2 1/5] mm/page_owner: introduce struct stack_print_ctx
Message-ID: <aOdrzAmu5zgCqT6m@localhost.localdomain>
References: <20251001175611.575861-1-mfo@igalia.com>
 <20251001175611.575861-2-mfo@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001175611.575861-2-mfo@igalia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A318680017
X-Rspamd-Server: rspam03
X-Stat-Signature: 49drtxusftfd3e8og9j95hy1iy33cdwq
X-HE-Tag: 1759996898-647372
X-HE-Meta: U2FsdGVkX19PjB3ELgPcMZ9GVpO1OQSWacngr6zCnimTmoxNFpKbBhyzYboo/9r2XEPlfy5Fih3wdE+3KKr5bKEXI0gLHLywWlWVPXQlrMPPgN1N9tQVxcNOlgCXRBIN+eylYSwP9CgVoT9kdCj63WWc4FuVEL7AsOPHR866+zkoAMiSMbKYE8dyE7JtX6nQF1yXMHZ+2/6hOSlgmd4VYGml/wi7DOh/BFibjjZNL6vYxJ/zd0v83A1zbQf9D0It8dm2bo7Kco0RyFekKA+u+dJvy6QkLW8iwGFKkROU9yIBwaRFvkqELwMtABMTHFhX7sGqd5nV9gUabMPCW0tw6X4Oa5+iX2B5fXJBBhTCUMS8S/F5JLn4HMlvtf45wfTF07uI52eiSdsc2pp5+Say89jlRUjd+YrGZLOkeVppVu0Cmbc0xiW0Gj4ESE/xPpCoVywU5bfGbjjJHm3MMbP3IiPkdnAqY7uXt4Br1GlFSEBP/46RV6zt92TSHOJd9BlDNtc/Wc4tEQhZutAZKWBcUfdyAiNNZLfNki+UKpDHsa2rN8Q8p1IwYhuO3evT/qCcFiCPYZOOSRdQhHpqFpqFrhF1mWm0xE0DNjN4/xk2+Z4HA7lwRU6yS6kK2nDfF8eqQGaRtSi8+PxoZ3yqn/KG9QzpQHMIvO4e4jSblzT9TndGSb5w16Fl9sSMXuFC0JwsB7HDpJ0OabmxWymud8B8d6sRV4CPnMB61d4FwVkcV633JBacY0P2TzC1vrxqIoZr7TcRN5/NM1SAOk/G0DAn8hFb/EgoSFlIevrs2SsjlEwrEX5GrQfY3lE6sU5mOAO/VmY23NQ7JUtPVSRQN3rWTbkzizR0NEa/Arr4nMtiI87i/DUWB1KqewD3Ne+7sNhEXh6g3izDIumi7bTQxDlsxk7C/CJqTU/KZx26o4Ev+yvul0Q1X/tYZ3uZG/S37Opi/uwP2RsObRhvc6Ml/aZ
 ROyS2z3H
 QVuk80GZbcCpY/N1hy3fSohdA6FWG/LF2boYQdLNwbaCQCxnTm/eDArnspI6Vcjtb0sJOhFvxhyyLhcfhceJAper7piqClPSP8iCYAeHMueykQ3pKodg0Ld2+3E6im1HVOUAKQBuOGotCBqVQ83YvCMyCvHGlf32xLFUfjbaEemdN7e0lZsHmJkt2vv4wDLfa2NrHTakw7d6su1ebYuR9wOVIWjD3E8qcPrv95rDNUai9R1zs26H1vxjd2ca5Tftz2XB8oxF7yoMBZJlGD0XTYOWOGC4N41rzORylC/A+Kj+MUkv9Igl57rF5FUiDH4NPmkSVb20q1SRYd4jAiUDpMWaw1aUP5bqSpJrqozm5CtQW8IPzRIJ5Txl7Ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 02:56:07PM -0300, Mauricio Faria de Oliveira wrote:
> Currently, struct seq_file.private is used as an iterator in stack_list
> by stack_start|next(), for stack_print().
> 
> Create a context struct for this, in order to add another field next.
> 
> No behavior change intended.
> 
> P.S.: page_owner_stack_open() is expanded with separate statements for
> variable definition and return just in preparation for the next patch.
> 
> Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

