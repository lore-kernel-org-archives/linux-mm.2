Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A13BCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721D88E0118; Thu, 18 Sep 2025 09:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9458E0112; Thu, 18 Sep 2025 09:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8158E0118; Thu, 18 Sep 2025 09:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC218E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:28:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7DEC83BD1
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:28:24 +0000 (UTC)
X-FDA: 83902450128.28.40854A1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id A55768000E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:28:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XXE4Ghsx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/5JvUO01";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XXE4Ghsx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/5JvUO01";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758202103; a=rsa-sha256;
	cv=none;
	b=PuVIqLeJXjjrglFv8R8TRfaezndiMbGSko/JAlgFrogKWM7RyImUdl3miKDU3MY66+3Uur
	h8GNXTKzLjicB1olhzL87TtZ16sDrk3ibg9/L4m5HRPI8GA7WygJ3D4uY5EjljG+ydJIbk
	8AR4MDdUoT04kjdPH2KWZz5DW33JAn4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XXE4Ghsx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/5JvUO01";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XXE4Ghsx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/5JvUO01";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758202103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xm9X1U5lwGO/ypkag3EDrIMMEEF0BDQGAkYPjCwoAJ4=;
	b=fmRhGLsbkYYqdiq+qIbYBCdon1AXQ20wchxwCY+nSQsAf+xo3idOQQ+qcAi5yo4I/NKj+F
	JLA3cGKt2587lfsa69hG8oKKCC7x5JFwyLgu2RZvqCADrIcBO6baRFc4UP/UeDdoOfMFN6
	nampf1E36CfPoAOreutkCu5rU3liNiE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 000611F793;
	Thu, 18 Sep 2025 13:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758202101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xm9X1U5lwGO/ypkag3EDrIMMEEF0BDQGAkYPjCwoAJ4=;
	b=XXE4GhsxG8OSG49egkHLGq+vQn6+l0MlN41O5i91wWAln7+JpMHOjmEKuy+v7OQBgduEvB
	/v3ZDIGb3oceVgM5XQM8Iq0mEfrJ9J2MIzK+adL3IuXo5ZiKO8W02Ujnzd9CrdiEXGjsDw
	kEF+U9unVx3lYCvAve7oI4EO5N0JQUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758202101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xm9X1U5lwGO/ypkag3EDrIMMEEF0BDQGAkYPjCwoAJ4=;
	b=/5JvUO01Wysy6NkRzT32nayJe74BjRmg4EkwDOYA6mxNa4XV1UWpJMNt/CmC+ckkm6bXdS
	VQ/5YVOCs/c8vvAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758202101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xm9X1U5lwGO/ypkag3EDrIMMEEF0BDQGAkYPjCwoAJ4=;
	b=XXE4GhsxG8OSG49egkHLGq+vQn6+l0MlN41O5i91wWAln7+JpMHOjmEKuy+v7OQBgduEvB
	/v3ZDIGb3oceVgM5XQM8Iq0mEfrJ9J2MIzK+adL3IuXo5ZiKO8W02Ujnzd9CrdiEXGjsDw
	kEF+U9unVx3lYCvAve7oI4EO5N0JQUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758202101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xm9X1U5lwGO/ypkag3EDrIMMEEF0BDQGAkYPjCwoAJ4=;
	b=/5JvUO01Wysy6NkRzT32nayJe74BjRmg4EkwDOYA6mxNa4XV1UWpJMNt/CmC+ckkm6bXdS
	VQ/5YVOCs/c8vvAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1AC1513A39;
	Thu, 18 Sep 2025 13:28:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ea16A/QIzGiNLwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 18 Sep 2025 13:28:20 +0000
Date: Thu, 18 Sep 2025 15:28:18 +0200
From: Oscar Salvador <osalvador@suse.de>
To: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>, akpm@linux-foundation.org,
	clm@meta.com, Jonathan.Cameron@huawei.com,
	alison.schofield@intel.com, dakr@kernel.org, dave.jiang@intel.com,
	gregkh@linuxfoundation.org, kamezawa.hiroyu@jp.fujitsu.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rafael@kernel.org,
	ritesh.list@gmail.com, yury.norov@gmail.com, ziy@nvidia.com
Subject: Re: [PATCH] drivers/base/node: Fix double free in register_one_node()
Message-ID: <aMwI8n2-w1J_AOiD@localhost.localdomain>
References: <20250918054144.58980-1-donettom@linux.ibm.com>
 <5512b1b6-31f8-4322-8a5f-add8d1e9b22f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5512b1b6-31f8-4322-8a5f-add8d1e9b22f@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A55768000E
X-Stat-Signature: yu46pgnzut93yx8hcop4rtfxyt4o9oxc
X-Rspam-User: 
X-HE-Tag: 1758202102-571284
X-HE-Meta: U2FsdGVkX1/KGeyZXLuXPb1uOd5ub813SLoyYx63CkOp4kBbQ1g3kc/RgZDVX2nG9KN+CEkkW8ZlFzDRlwKT8sDpDY/C/3Poqc6OcLDzYJfmfBrLKoPSMkBTb4Tdm1Mv5TJd5+QBMJdXuTxetOlFb7YBlV34JwjVTAxxNG2PLAjTpAfKS0vzXFJqbowXVVJDCZuhF/3UqLAxeQVpvyVdFlDpYGL0D/b6Ly8npF6sZun/H+y/DAkCGFu9FXIigDLDAOmE7jabdmkhdxjH5uf/1lOOAa2JkhXCsR2BddcHKRN+PSTpfx+gnfceOpLbc4lR2gqo7UNtTaB7ZMZgpC6sa9WYDdDdj2KVV/7YtGx/GVTUhW5HE9n871MP8bmYdfhZRWTX5TZalwAN4npPI2vtc8qL9nLw7gkrGM1uTChUml8TRHRQttuMiOPq2qKjr8hqYvLRYeCrXpJseMbj+7WsfC0bdrXyXN6ZKhTAZpMtX2PmA5xmLSsDCtXB5Ny1OpWt7jV9c/fQbQPFF5vJg8lxiuPKg6ZGGrZIcOWKoDkQK9xEJC99y7/KcymRXMv4OGe1WbLhD/X7+P4V834LTpI7//rPlhOKeU3Jkagd1G6jKEXrl0AK1pXjodw51VgxoiIlIk1+UyXUyl1Urq77GJ2WNk2y3rfRxdSK3cFNXgPKWJ6rWsUcTD/vBngc59MvNnFWeL64ZqBxpBf9LYBxL2gqXUc8/PR0mQH+QoA5GoyGdb+zv4n4ZT02OJK+jksy3mmUlA3j1WWrlrc1sy45oP9EUWxQn19gKWBZnNsxyzrTFpVCkmuT2rkua8cU1YGI5LtOkx3U+BeWTyIUas349cKP6AiuGAudiDQtszAYMoYk3JpWNZrtymewUbyDkW5UhDUjuv8wTa7W3J3kidbeOr/FAJiniN5tbcNGoRkvg+5BQIZokxE3x723zApie8FSq/JpxOJiHkbB3cQkl8vGUz6
 rfnmwGz7
 mpm373rZRBjaradj2MnB7IKz/tBmPAUFWrCw4w0QpwhX5QhTlPbNbQn21wG8J89CT/yBY1gIjeFgnTj+45LE0JMdJNnhM8KNPScl/ZrxtKBp9dp1uB1hqZRti+AVrCCNTZu1hmFR90zWl1VU73E/Xx5u8afFLGcifKj53+LTaIClcyXAGDq7YxwGQ/1zAR7F7Pq2AcI3P+2q4fJG1WYeF6DNPPy7Gz68xVBne9N7CExQIpuxQmDP2Dv+hDAbb428hruZ43ssh31QfFbU0X5rGuBYfsRuKDiBczgoXFWBJCdNI/9KJU5h3LZ6DWvEsDU4Q4edkytiUmrlDcD0HzP+xsolsHF+2Ese9ZUkRgI0yNkpwXB2xkT4tJnFYbGs9J6mtU2sa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 07:55:07AM +0200, David Hildenbrand wrote:
> Yes, that matches what other users (staring at mm/memory-tiers.c) do.
> 
> I wonder if we should just inline register_node() into register_one_node().
> 
> Then it's clearer that we perform a put_device() already in there.
> 
> On top of that, we could then just s/register_one_node/register_node/
> 
> And then we could do a similar cleanup for unregister_one_node /
> unregister_node where I don't consider the split function really valuable.

Yap, that makes sense to me as well.

 

-- 
Oscar Salvador
SUSE Labs

