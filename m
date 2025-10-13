Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2845CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4EA8E0017; Mon, 13 Oct 2025 04:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F258E0002; Mon, 13 Oct 2025 04:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26EA48E0017; Mon, 13 Oct 2025 04:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0AC8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:07:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF96213A7E3
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:07:08 +0000 (UTC)
X-FDA: 83992360536.14.374B6F7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 85C521A0013
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:07:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Zr3D/VXT";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Wx9/QFhS";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vYqgbwpw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=l48zKrz4;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342826; a=rsa-sha256;
	cv=none;
	b=rgdN6mOJTEtw3o2JFL06dzgxHLwBRu5X/KyX5TUvA0YhCV3T3sDmY9v1t/SX3BjmSRaXCx
	gClvPYhDPjGi4wyQMmmlOtS0C1ixfn8pvqXfNlks2v2KN5HyVmwX2q8JThipp65p0sRNN2
	KZeMkcIaIIB2xEOs3o5Ib09cFPtJ8ug=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Zr3D/VXT";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Wx9/QFhS";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vYqgbwpw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=l48zKrz4;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6w01YLeD8Y7xeK5Gmx9nkKpU4qtns8801YbVOhrxlRw=;
	b=Hk/mpzJ/cugEWvFtzlK9dBbo+igqp8tEs46eaZYNNyq9MRivVek6+/4pz6r+pJQwa+RHI0
	uBZ1nY0hl8pIUC5uqqoL46BmVgScYn0tn7UxdxSwQjwzTRme+vp0gmX3EGbhS2uWcuixtd
	1yMds/ZtBVzmu6xU6HM+W4PFQUecKJ4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 287B0211CC;
	Mon, 13 Oct 2025 08:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6w01YLeD8Y7xeK5Gmx9nkKpU4qtns8801YbVOhrxlRw=;
	b=Zr3D/VXT+EBv3Vsijzg8uCr2TS86lZAtrDAHB+XWEuDaW8b/UXvDIoVYd6fmqdiSMZC3Qi
	LmUsIH7wgtra1qQKefS87CMjZ0RXqO71fNGQt+RdlHGilg3vL2CcWPZabieZEXU9B2g489
	zsxF8vLXqiaIYiyQkItPBhyHxkOSN+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342820;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6w01YLeD8Y7xeK5Gmx9nkKpU4qtns8801YbVOhrxlRw=;
	b=Wx9/QFhSLQ15pl9GXGO9Xd7GUKxZPcbXLMvPCBEqy4C237hdEGoXmfNwcoRLhoFBquVTtj
	x9Qp1fNKFj8m84Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6w01YLeD8Y7xeK5Gmx9nkKpU4qtns8801YbVOhrxlRw=;
	b=vYqgbwpw/BLdRfvuqgxFwOaFJsnscL8yRzrKIbzFO0ft3vQC6f/ciCgk1VD7H/khkUPZXe
	I0CQOCkwTutAQZrBlQoG7MOvS5pY6rZ9zpJkasTgRTQb/Wr1TRrNKZnG6tKYt1ezZTGZ/E
	3Rbla2zD3Uv4Y3eky86ahqOUjCbVaKc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6w01YLeD8Y7xeK5Gmx9nkKpU4qtns8801YbVOhrxlRw=;
	b=l48zKrz4/O7RBu10ddw+yNKgWIp7Da6Mta/5wf9kqqL2FwkVuabbvGXY5Jrfa1A7UW0n50
	M/XMFo4RQD4gK4Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BEEBD13874;
	Mon, 13 Oct 2025 08:06:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EvnaKx2z7Gh3GQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 13 Oct 2025 08:06:53 +0000
Date: Mon, 13 Oct 2025 10:06:52 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, david@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hugetlb.h: flatten logic in
 arch_hugetlb_migration_supported
Message-ID: <aOyzHMRf_eI3FiqK@localhost.localdomain>
References: <20251008212614.86495-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008212614.86495-1-gourry@gourry.net>
X-Rspamd-Action: no action
X-Stat-Signature: 6dzpaz9qc3u16pek6ytqwcf4u76kpdn4
X-Rspamd-Queue-Id: 85C521A0013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760342826-965571
X-HE-Meta: U2FsdGVkX1/TfOx2VRPmQ9FHjRiXFVQ+Bk5f+BdERIAV/LfSsLK5lrA7ku43lROj5eW68tOawFeI4mgw5D3TathI0CeGa64fCbJzHjjr2/CTXmdLZoeo8BOG50IbpTEOFkJpp/hkaoRBq1X+RbrA1Z7dSp8p200fwUjn9lBmId+iT6bUCiqjgiLdzqJOxA/HmCJGXbh8TuURa6pmg5kIHZ8g5CRIpKgjyuyUfuf6SwQy/2ySS/F71J0PG3O9eNVgEGtZwYwJEq6OzPBjVFi8nOO2h2GJL7NMbLoGh7tZUH8FuXuAiIZhea2XFndIyvyyzs3wHoFs3PhPnDs+egID4n2OMHdX8FmTEiZzYtL1pfd0Zl8rRq3VdtHd0tguaYzRiq7EoasKil5pfcJxvPFu1EMQTKjchYRDXX8aZLSi2pRnR4pNvPr3jcYPxhom/epn9i3UkAO9//XnIKlaR2euEs+lv0yF8hibLr41/SlJs45sO5IugHETLENpsMx2eQe1i9D607OW99p1zrlsg5YFoZNeI8jrZ//azVSZVzLd50a0/V0J4SsHZV4Ls0gX6XaPAk6ldaetGCSm0lbWjDEVWBSyMxaRzG1LtK7nD4B0/lXm++ZmOG0YMpWgRboFYOxZ7rNxO/HoAdo29QXODL9LBG4+Kh3O1qrYbV2WmKGyYiwPTo5/4fUKaZzq5blr6Ab8XxbRIbYdv4ke/y4NFYQLYj84ECvNUNBMtWTG4MOOiehqse3TnyHSdZloOX/1mIjBEiwSvgh0xa0NyM1EDZx3OZ+DPef+DTOqBcvmMV8byLKo56iwZSL3jBAGLsu0QZzzvR7+The8tMMcOufeDwG3O1sQ0J3+xGRvjeL7VzWUfAc+tIoFtAcpns6S0Rc/gsU5OrLO5/pbHg/kyteYEGFi8QDvYjujyS83M1abfK6Z3tHXW+Az2PRyNF0+VqptMX0yEi9SQToWUX8V0i+JbyI
 Aevr7qKh
 cnBZVbnq44cNfcHHS8kqTNr0cA0+I0k/06KiFP/Tyq6o5V3v6rK3uouCpKlnQ83ZfAO9i9zSsym+9wYuUuKMbWJJxZQETM9I8Rq05Kurwc6V93rqv+VUJgl63Imz5hmTU+hMXWCVXQx8f0jnM5sAvaXyQ/mM3+X1/LH29lpeTeAvlnb7SI/u13F2q4gCovMPtlOyLvsL0dp5LCQdnoOUnXOBJ2mG/Vb2lE030tQKHZK0xBGQdyIjW39jZ5AlQdoPPGtjMINGJlwYiqVZ+23TPi4N8DSH8lBycZp1R53AUa+HymUFJUrnB8NDhSyYGVwwHoFtcwg1kjFgm05LBzGZE2VAjU4JWj6oaQy5DhYIontp9ygQcU11BJt6wivMwzR7LZhRRpg8FkFjwRg8bJ9B0IWJC0h7OuXuM9AgzEADN6kM5qIQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 05:26:13PM -0400, Gregory Price wrote:
> Simplify if-true-return-true-else-false logic.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

