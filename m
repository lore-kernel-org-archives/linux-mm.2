Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F306010BA45E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456316B009D; Fri, 27 Mar 2026 05:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42DF16B00A1; Fri, 27 Mar 2026 05:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36BA96B00A2; Fri, 27 Mar 2026 05:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 28E336B009D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:20:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BEC97BE4A2
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:20:23 +0000 (UTC)
X-FDA: 84591297126.29.D8A8C59
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 700A920003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:20:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GrmxH8jv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="KS03rM/9";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PPV76cpg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aPnrj2AD;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774603221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8BMCUzJxEw4enY0q6sxGqyucLFct5YuV2nEkJy/Wlg=;
	b=MnmDdypKkuf6SUOMMCWKcLQ1g1uhWEN1vSa+DR/gPvvxXfZQj/pYhnAyADCcUmLKbchb9R
	JIBcP30zmlvTE3qlKoPy3KdNcJndiRoIocGTcIQjb+iUHEH9O8RCKoqjGNUB85c8Lm6jDX
	MApyom0phGC2IEfZcmmNeLNnHvrMV60=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GrmxH8jv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="KS03rM/9";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PPV76cpg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aPnrj2AD;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774603221; a=rsa-sha256;
	cv=none;
	b=ZcWg97Lj8Y5ZiVzVS9ML9gtgwmFv0vZgfBqsEUYWUFY4f9WOZK0YtvHwFrBFREFaXMasov
	4qx8V5RTa6VhLt1jgbqSaa8RSi/amuwSsQRxb926R9t/QfLjYnKTWdPLlLQQvCelv8twrr
	Mn2hcjIQEsbr52yVo3UO1eD5Q7J7cNM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EA8EC5BCD1;
	Fri, 27 Mar 2026 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774603220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V8BMCUzJxEw4enY0q6sxGqyucLFct5YuV2nEkJy/Wlg=;
	b=GrmxH8jvI5Dl/g9vZ8ywd9Rd1xB9Ml8unfQrHgoBnENTJvxfev1UIPNSG5lEcOm53sSOqa
	TngjHodPi2TNsy4vDSobgxkzf3ZKV1tl/WR98vVWxWw///pjEJmCfOUneKJIU74l1J9F+8
	ZYU62stgAEUOht+DRz5RtZfW0g8pJo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774603220;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V8BMCUzJxEw4enY0q6sxGqyucLFct5YuV2nEkJy/Wlg=;
	b=KS03rM/9/xmpgvlQzeRsTtMSzr3DQ0N278jP82kwrYDCSbypzkC+EcLpaO5iAqcV251DOU
	2x41mJ3R2IhEOjAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774603219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V8BMCUzJxEw4enY0q6sxGqyucLFct5YuV2nEkJy/Wlg=;
	b=PPV76cpgvLHlgb00TPtC+bK/qeu0+6dYlFWyXQwkE9Z9LAH2PMK13UQIDLU1WYPoN6h41o
	Z3TVd+cgaLQKTBicrjKP6FwKaVpE4h3kBLeed2T3CWvtF2wTyEVBcnW6QfMj5OqwjGieN2
	QIp56fxMSeWT8n7oDBBf+CRKHortd9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774603219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V8BMCUzJxEw4enY0q6sxGqyucLFct5YuV2nEkJy/Wlg=;
	b=aPnrj2ADkyBHtcFhud0BLMEr/TY7XjVo7TGptxQJnnOzGE/C7L8fyKDi4b1e9d8ZDD9aK+
	Ymq8ki4JAqvAz5AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 25F0E4A0A2;
	Fri, 27 Mar 2026 09:20:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L7TvBdNLxmkhFgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Mar 2026 09:20:19 +0000
Date: Fri, 27 Mar 2026 09:20:17 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jianzhou Zhao <luckd0g@163.com>, 
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH 2/3] mm: abstract reading sysctl_max_map_count, and
 READ_ONCE()
Message-ID: <357u5es4z7jjnpkyefubvlygpkcinqomnyg233ra6geeamq35y@fuor6y4es3cp>
References: <cover.1773249037.git.ljs@kernel.org>
 <0715259eb37cbdfde4f9e5db92a20ec7110a1ce5.1773249037.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0715259eb37cbdfde4f9e5db92a20ec7110a1ce5.1773249037.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 700A920003
X-Stat-Signature: do55tn9o71nqb8uueuf6roimgisq368n
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774603221-239707
X-HE-Meta: U2FsdGVkX19a9YiVJ8GaFngwS0HZP7bbdqt8jWgXCOUF1M1OSdg2wFg5UnMS8m0x4C+LfXNnb/0pu2H8Js+IjaavBqjgorUL1wiS5WmLtP9qnLi8PnltZD0jo2gaW90KOYfa9aG8hbw6+6OVull1+OYadsCI3/k73jfrZWLKI5HFsK7KkXhMKfutsGXkYO7EcNmfnthl/gnmm2uQbTcG7wznU4vDCXJG462iG4HmfQBiJgtzrygThG1rPkqAzM/rOZih7VgQ22vXm0/JYLyi6o0Xpq4qra1G7Yc85RNX+SfV9Sq8Li5BoXdkqwyhLnu5h+vBiUYzSb3lz9oOnqxu5by1k4l9fCQ5IqYmVGJi5YZD3LNC7NRJztlBPMzAi+9Yq3b8pDEc0+Yx53Gpmp/9pfmyoOSrw0G/7CQ95uYMovASZodsKIDjM2APDD0z2Z+RAtDzNHyPfZRAadoKcAwTu4n4g//bHm3Vu12BrviSEKFsGCH1vKBhH7K8Lgxe4G5qClclku0j9AWTX27r5AltTwGdBaDcVzY5bReZOI8PO/YFSX4K3C9p+hyMBKdDYjmoLIrzDNj5lldYtFbygzWApk2i/e4YN6qlSnCryaW3dFaW23hDj6mDbt9G0hG709PAyy++M1PnPWoKoKVVzp3+GGOe2nn/4Q9GSGdLMic9ah1BjOEm9swQR7PfZtUq9WfkA2ZZliJjWo/xWjfcpST31FneQ6ha77R3umRtelnKsNfmZab1/3Wo2lmqIkDdIMLGqEgeLfMgtIabbcqAYVd+MR9HksJf8bRBeV9apVH6/7P0SyA6QFUzBQJeqQgJ+U6XmdUmAfQxhhaICKKBCHXykcwqn/vEO+A4fdJmt+WFeGryvaOdWh0TJPMVW+jdcHiB7AWUnk4naTrb+LNo7kOjza6bcMIReFpxso5G2rEjjRZH1eAV6IXWHMbITHPCsEohgcM9jD0NgQaMhbB9DqF
 RORz6LDY
 OXyz0wVZpkeS9O1JB5xxs8Jxm01c8lhWTIKL1L7E1oyIQejMUl7RXRL0O6HereUJl38Ad0+FcXBlK/a2JEYSW/40Md6qKoc8Gt3myNUEVbKexg9pvmszHqqNr5yab+HUsaBKB08UMIJdHkE2aYJQV9F1UkQBPi0LRQZKNzSGGlLSrPjtjhaEuJg8F0wzISsofEQXq+XvzfFRmmEk0pRgNqhNU74EwoS7UAheH0kWui0M5Ll8tTZtqEkj18ddF/ksl1FqSGU+AjqW7kUmfP74lo/9BP/aFZNyuBPsLz9Xyr7sggqJhas9S/Yl26hCnDiMBLNpqHB0ZNQjREYbuSlZB3kPBevn4ueVwgBQskW68FJTJxiK3QUbJcf8fmodcNK/UTEvWvl4D0x6U/1GnWDLsBiHdHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 05:24:37PM +0000, Lorenzo Stoakes (Oracle) wrote:
> Concurrent reads and writes of sysctl_max_map_count are possible, so we
> should READ_ONCE() and WRITE_ONCE().
> 
> The sysctl procfs logic already enforces WRITE_ONCE(), so abstract the read
> side with get_sysctl_max_map_count().
> 
> While we're here, also move the field to mm/internal.h and add the getter
> there since only mm interacts with it, there's no need for anybody else to
> have access.
> 
> Finally, update the VMA userland tests to reflect the change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

