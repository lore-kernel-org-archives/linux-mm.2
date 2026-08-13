Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0053C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848526B028A; Thu, 13 Aug 2026 07:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8207E6B04AB; Thu, 13 Aug 2026 07:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70EDA6B04AC; Thu, 13 Aug 2026 07:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 561A76B028A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:05:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EAAAF805A7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:05:41 +0000 (UTC)
X-FDA: 85095965682.07.91518C6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id EF37340009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:05:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="QgTKfof/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SW7399y7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Egm2Kt59;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4gsKVIcM;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786619140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uibj/eRl0gzKJwNpAnrp43JZg6Px+9DiZOe91L9wuN8=;
	b=RRmH+ZX4WdxbQNGSJWffUSMMZAyM/cDJnhCw2NVaK7GjPKakyjvzK8L/7CnHDvMb6FmbPZ
	UexWBwbZhiClZvjdqLD2KMwNGq2R7DvdmY6LHKHIL6JOxyEhiYMJeC4t47of/O66sdTwFq
	MKfVSgCXFcYcmoeGBYprZJ7U4WepbSA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786619140;
	b=gX/Tri6WeOZi1Hq/DV58ToOPXTSXkBUQYegValtddQJY/Ie3QYSRskbWT7GgFnAp/a1dXE
	y8nGgEGJzMZdLurK6JNt0mxi/8UOEVDHkKwcXNJDxBF1tkAHYujjjwZb/l4rYCSyTUAqQ8
	A1xGhsT+tXBI/kqexUudaPGDBlsn4Zo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="QgTKfof/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SW7399y7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Egm2Kt59;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4gsKVIcM;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5DDB43E0D;
	Thu, 13 Aug 2026 11:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786619134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uibj/eRl0gzKJwNpAnrp43JZg6Px+9DiZOe91L9wuN8=;
	b=QgTKfof/u5YafqZjss7nLIyoDdhbu0rWmTfUtW3X73CscD1Z/pf2BmZlJecWfka7+QROGT
	vJJ6+U6c6v8oPs+hgtV6LREykNAnqfhQ96eBpgFfonygZvP15bq92VW0pwZZrpAYN77N3q
	HoR/dZRxuSql2lojVdyMELhZT9kIzH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786619134;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uibj/eRl0gzKJwNpAnrp43JZg6Px+9DiZOe91L9wuN8=;
	b=SW7399y7HoYBZ0WJ7OcOs1nsPwhpKY43dW3G0yIGi/XucHa8sgXHXHmdWAjoYHL7OFFtV0
	w9HycSRwZ21CdoCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786619130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uibj/eRl0gzKJwNpAnrp43JZg6Px+9DiZOe91L9wuN8=;
	b=Egm2Kt59TwMHWdUX27Fdj5GOjzex5mEMjU36hKeSVpguV9y/0B0LQXmTkcune7jXHIBqqy
	XIb5NnFFrkSGlJaLBxAZcuWKQvYGXi7O4Uu5C/v2fvZ+CYvJ5dGs380HXiLIrfKpbZSPK/
	3k9dy+Ar9ttljGNhG3cMm938KcwBxmY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786619130;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uibj/eRl0gzKJwNpAnrp43JZg6Px+9DiZOe91L9wuN8=;
	b=4gsKVIcM7P+VVUu1H36KE4YDc81I0L/28ZXTJTL7A8msOqiuxtjIaFLOBlP2IfKBlpx8vU
	CPI6xpownYAJABCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 650CE77DAB;
	Thu, 13 Aug 2026 11:05:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rjM+FfmkfWp9AgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 13 Aug 2026 11:05:29 +0000
Date: Thu, 13 Aug 2026 12:05:27 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>, 
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v9 12/15] filemap: Remove checks in
 mapping_set_folio_order_range()
Message-ID: <an2j-26QD3KxczRO@pedro-suse.lan>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-13-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805210557.1118966-13-willy@infradead.org>
X-Rspam-User: 
X-Stat-Signature: 1imiib4fhouaouruzcdbh94yn88d7uiy
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EF37340009
X-HE-Tag: 1786619139-871064
X-HE-Meta: U2FsdGVkX18Yl3aXtvMIcp1ScSGH6+lUW0e8u6zMHsdetNMofyAmjP6MA2WWIC/ZrGjU7a9Pjx8238Jv4YjVIKzhA2+brWgR1iVOCxbwAiCSSBAygfQ+42CzfeDHQ4repz79jmEg4t88cuuI2gouBeN9ox+lQjUzLuaw/YC+Izsdd9DZYYeKam+oATU8LfX7yBbvuBZLlN3QXUYYvZB6QvEaMyqEPmX1UpGPNiB34NTSViTLP2ZANmBll0IAzju14NQAa9HfUeXc6xvPZwwRCqOyQJTKx7k9A/UdlpnEg2Dpq+86Sc/kF1pPkWhxXwuj+nYHbkbJshIErySW/Z5ahX/2Blr1t8LY8OePSIOlTBYAjwwFAgjTpIqRvMAI5jxlU8JwMq050We8LCKDb+hjKTlUheLQAgeal7to6kn5NpLlXnoudxyPWsRMdhBrEK6p6CURayuD/+DTcFKEC02ErfypDdHL39nCfxIjuuBXzzDxAvvLhkIotPJnzc69+M6MGhfp8lTDWT4DB44iPnuO5AEIkNKZlAkI9Vn/kDvr2lXs+sm8DPRn8mnua50Z3zJ81Gc4dFZMKFydzFOwY+EySrwMuERVRjxmQ8RNI+Sa59t1VdL1Au7xRAzTuw2/9LTN1rvpjxgQuGfbf+sYrIXqRKC1VYUHTlrTV07x1dm4xTFK/WAczpSBmSKDCxOlpAuzqSEKGszDua4RY6bwFWWzA7AUReQ0OOQiIKyoPGB0Y0MSwweQAepl3EKpE8KqEc/VSQNfnW9vLYLkqSsOpeZ/vZoPg6uAbcnaEvG0glOn2sYipeUFJj1ucp2qhR49ZJTfzHQPA7824k31hYle/ysoze8hTguD+H5FIrQYB6+t1mi5mHPnZcSDfEfwe1EoMihmarT0by7MtupLnPyLt+2UK5vD6Oik5CAv1AsHXFFczukX0tk1R4jZwbr0d+R+rDS4g3hKzHEAzkzYagnpEzn
 N1jmOgby
 2HkNkwPM6j/HulLD6Jg+rVq3YzWbBvJD6FCMy/OrZpVS+eyixz23D/4RVHRqQMo5Jyo4mrcxM/LQshxNjZKctl8nRx1xAaFG3J9JpjHhR00vNmRFtts0MUzg6K89e/WIgq/cBoU9vFpSB8QcIzcr6ZtD3FvFpGIwf5yYLf2TB/QGr2lc0lf1wsWolgkWmMCaW1B6b7/rdMVYL+MkrT3cRLUPZfZyRpqSZ7CT7qjdYlf4tr16lCfBno5fZ55mbwLKCdhjQzJNqnx6keDSUyOh2kTS9jTf55OwHH73bAZiL6MX2BsQpHyuzsm0QlKoM5c+/2zL71eHlWLs+10iocehRyETK43TAzCDLdB8albRTvhM8PpPnSak9lk3cRl8ThBERbkALdTU4hA9hQiOX6ChqBu6XkXFzuA8vm7UBxV2uQ6zTUV3M7w9voozoeoamoNAGDqjdbM6QuT0XnEZqSF3dSh5csq25zpJvG5c7lGp3aIkzltlZJ2mDT+fk1Ez0tCExESXXo8XO+COSHmOJbCy0dZHtCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 10:05:52PM +0100, Matthew Wilcox (Oracle) wrote:
> These checks make it impossible to use mapping_set_folio_order_range()
> in hugetlb.  They add very little value and can simply be removed.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

