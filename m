Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E05D7CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E2D8E0119; Thu, 18 Sep 2025 09:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305A48E0112; Thu, 18 Sep 2025 09:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223398E0119; Thu, 18 Sep 2025 09:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE468E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:30:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B17CD11855F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:30:01 +0000 (UTC)
X-FDA: 83902454202.14.666584E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7D67640009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:29:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BYa5AdAp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SLbnRiPI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QBV22+Jf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A0e1aUmn;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758202199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fTYoCWRW+L4YjxiFOSgMgnFo1xCFk5eZgY4MSn+A3o=;
	b=fLofPlVgqbAzhEV23KjbQPsOfpRn+9d2k4CiV/5Jtjq9GcJ/GsVpUpcapWGKT3xvdip2Hl
	H5Fp4s1XOfUdvMBlyTsIdQl2y3B4KfRXiTLWj8E7hLuBeXvTvxRMS/k6ryWgWa5UTfOJsK
	yxeLcqQu1oALhjNpaiGA344VfS2ImEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758202199; a=rsa-sha256;
	cv=none;
	b=7nfQNtpkTRFOZBH9VFnn/7T7/ZViFfW+/2JxUiTPGheZfVqm73efhEfig5VY/HtF6x6rdR
	0pt0YZMOJPvpKPG+OD7sUGurqANIyHkobFnBT4NewoozNa5x5hIDqzm43IguXEbq5C2D3b
	zeY+icJzR3JC7149fhxK5s1PUBUiPdA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BYa5AdAp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SLbnRiPI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QBV22+Jf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A0e1aUmn;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D655B1F810;
	Thu, 18 Sep 2025 13:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758202198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7fTYoCWRW+L4YjxiFOSgMgnFo1xCFk5eZgY4MSn+A3o=;
	b=BYa5AdApOCI9L1qon3mTcKg6c6/zqqdouNc5pLRjR/723HJIRedILVA15XeArV6WqJv5HK
	Q0c21RDeh+nMpNPqye9R2c1GakMpZdcrgMtnR3Sy9Bieqa+fsP+hmCfE5bbMyuiLK7LGLc
	+5nbbBtIMHQITDT4CvfTAnGasfyM9Yw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758202198;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7fTYoCWRW+L4YjxiFOSgMgnFo1xCFk5eZgY4MSn+A3o=;
	b=SLbnRiPI4rjvDB4k8gKO1CE2cb56BnEKSUmYKPD7QOuTSz4K2qnIjVS83bdzaC9PtlxzrR
	swpdMXmOEZKNLlDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758202197; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7fTYoCWRW+L4YjxiFOSgMgnFo1xCFk5eZgY4MSn+A3o=;
	b=QBV22+Jf+VAK8o4k5MJWCbw32X9qS3KoZ7Yk6VwdJFK92dL2N9rVjLF8tmhsSMxTnFl40b
	NsNB2qZEZvqeyzig5sXgk+gHKGikyMvlmG2Q9FMZTWDgp4UvXFbWBYxI+eIQtv2Io5WnV0
	UYImvCSLChK0El7KCq0col1hlfeaUUE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758202197;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7fTYoCWRW+L4YjxiFOSgMgnFo1xCFk5eZgY4MSn+A3o=;
	b=A0e1aUmnAjElGy89nAtCMSe6k/opsvZtDzVKmSGxIdqpnq5exiF91nlmIl6ZmcHOB4ZJIK
	pImNVl2THuH7SYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0457D13A51;
	Thu, 18 Sep 2025 13:29:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 73azOVQJzGg3MAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 18 Sep 2025 13:29:56 +0000
Date: Thu, 18 Sep 2025 15:29:55 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Donet Tom <donettom@linux.ibm.com>
Cc: akpm@linux-foundation.org, clm@meta.com, Jonathan.Cameron@huawei.com,
	alison.schofield@intel.com, dakr@kernel.org, dave.jiang@intel.com,
	david@redhat.com, gregkh@linuxfoundation.org,
	kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, rafael@kernel.org, ritesh.list@gmail.com,
	yury.norov@gmail.com, ziy@nvidia.com
Subject: Re: [PATCH] drivers/base/node: Fix double free in register_one_node()
Message-ID: <aMwJU37LhxCUO6pZ@localhost.localdomain>
References: <20250918054144.58980-1-donettom@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918054144.58980-1-donettom@linux.ibm.com>
X-Rspamd-Action: no action
X-Stat-Signature: hmt7x4t4ohdgwj9kd71po5rtoz5rd46i
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D67640009
X-Rspamd-Server: rspam10
X-HE-Tag: 1758202199-156932
X-HE-Meta: U2FsdGVkX1/DtPl97BQJGyVC1wsmnek5LEjmEYdPMrM24KfZAiTFF8JLSUCmJX2ymmXuUl4YsqBRciKcn9pC4Cs6i3eBmYvxIv/F0GgMJA+wmVBFrwxNdAFV+FI+529kJpNJrM2HH+/BtLTO9GKze7aGWqx1ofacN7bNeNkoP+qnIL3YJKSzYB8Y35UUM4hfKYhwwbrnJ9bRlobUdfTaaP+OabID3AujbdPhGKK8g7uTlowcSP+eHYlsRartk0oOhc4NBjNz+4ka8gnm1u/7V2PS4uxEJi+dbWnxMUgwHKftC1HIaow/bcw0AntL69JqfMUST0kZVMAWXUBddi7VZzMBkop6lFfYNvgh/GU0A0kbPt4ayOSwXVHQeWU/o1o6PBEk75RIcjdfKGldlGrngx0ZAdHgJCExqZ+/Xc0FX1TV/UNp607C3T9GCd/C0VBde7lDGQyecUBZjzunxVDlSUP2xpbz0vDuP/c7jhxVxJbkDDotv2PC+nN7OaD3epVDdYYPARJ6YwZ+9jMZpS/MRqDoaz+j06xXTjX1YHJ64yaSlK1m5yWtYYaZAW7cYrCb5sUud3NIphAWhTHugEkZfc1LQ/7dkdpix3ydIpelxOf4Zlov+KHe/eAqsHgD0yBzSJsWkn+8mZ5/50MLFKPVz31zqZssvhI+LZHLPacsxwRggGe4LVgNug5dVpWnJ8l9Zk5jW9muFzxDAwBLs+2zFPG2zq4A3oRBxCC+2IlnDhmkuaFmGoe7jrI//run4Kl8oapia/u/JdXqK0QkmTDHN4MgEwEEaZubMHaOHM7zmGqYISqKm5JMfcePc+5D+BJ+BGLN2WN6z9lKq7FliDY57Nv3avuNFTetCiyr4I1YhqkdncL7JRGFejY5CarVHLNcEfNAX30jFmMGcHoHw9OHqBkKwwlW3sP2w1sdqDengPMRLtkFTlhu0YNULZmDfdbj78i9nhwwyptqwgLlB8+
 83WQLVB/
 juPuy1tjcSbvcVp8XbJj94h6IzIV6EWKroUbMSA4ItJM+VcVZWeiB4QE/X4AJ1oYRjEFE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 11:11:44AM +0530, Donet Tom wrote:
> When device_register() fails in register_node(), it calls
> put_device(&node->dev). This triggers node_device_release(),
> which calls kfree(to_node(dev)), thereby freeing the entire
> node structure.
> 
> As a result, when register_node() returns an error, the node
> memory has already been freed. Calling kfree(node) again in
> register_one_node() leads to a double free.
> 
> This patch removes the redundant kfree(node) from
> register_one_node() to prevent the double free.
> 
> Fixes: 786eb990cfb7 ("drivers/base/node: handle error properly in register_one_node()")
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

