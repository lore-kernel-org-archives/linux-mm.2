Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4D9C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46CDB6B00C3; Tue, 30 Jun 2026 12:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41DCE6B00C5; Tue, 30 Jun 2026 12:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F2C6B00C6; Tue, 30 Jun 2026 12:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB6126B00C3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:13:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7037CC017F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:13:34 +0000 (UTC)
X-FDA: 84937074348.13.8BCD681
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3D9AF140009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:13:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v9WqNGKn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tunOzFkj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v9WqNGKn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tunOzFkj;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782836012;
	b=IkKSVideQm34yIA6jAYmNSSBZMSsPjI3XkHZ68bq6qwrn+fb2rq6T7mTeh9XhxbDr2fs0O
	HAI5UJuer7mNXeWVPxZtttXMVb68Qvg9oMMcdh4uzGb8C44Wi9elGKgw/Fh90IwWR6QOjG
	LZHhxi3Po8fdfwXmkLoEmPHVhhwCpqU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782836012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLf+RJvHUaUKivNibqE5Uf2foJk6TxbjpsW5/os9DCg=;
	b=wV2A9f+fWZrV2vt14FmwdyZW5wGJ54tigLnSHdTWoUp5WHc2RPgTQtiyEefpYGZTLrvO7v
	zAzRq/jp7Nd+Kc6756RD64XDmr/hw17Nk1TaI4bzda5N8aLUFqTFeSP5ZEk8CiuyItHuTi
	gssPQihDRNLHyYbXUv+GTWW9cu0jdls=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v9WqNGKn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tunOzFkj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v9WqNGKn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tunOzFkj;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 27CB871C6E;
	Tue, 30 Jun 2026 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782836011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iLf+RJvHUaUKivNibqE5Uf2foJk6TxbjpsW5/os9DCg=;
	b=v9WqNGKn2JwYJF1bja78IEjkJEe94FUX1+tlCs7GugW2rPr3ErFYv7pZeCKgmpTNU3CIpR
	ZxXeAmWfvDEyf8+wKaTlhZ8MFYeLK8FA0w/fX4XIHgBrrNSUTZa3zWIwJ8jrQ9tIfe2GZH
	EYIefAU1bqKwPqkOJatb3MlFSTqbBHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782836011;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iLf+RJvHUaUKivNibqE5Uf2foJk6TxbjpsW5/os9DCg=;
	b=tunOzFkjyt4t7284nQZal6u63sJstvt0kVM0JkCTVEygxqLau1Nn4W/IRdqetbUSPtM4sB
	H+cAeDiDenOwoTAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782836011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iLf+RJvHUaUKivNibqE5Uf2foJk6TxbjpsW5/os9DCg=;
	b=v9WqNGKn2JwYJF1bja78IEjkJEe94FUX1+tlCs7GugW2rPr3ErFYv7pZeCKgmpTNU3CIpR
	ZxXeAmWfvDEyf8+wKaTlhZ8MFYeLK8FA0w/fX4XIHgBrrNSUTZa3zWIwJ8jrQ9tIfe2GZH
	EYIefAU1bqKwPqkOJatb3MlFSTqbBHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782836011;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iLf+RJvHUaUKivNibqE5Uf2foJk6TxbjpsW5/os9DCg=;
	b=tunOzFkjyt4t7284nQZal6u63sJstvt0kVM0JkCTVEygxqLau1Nn4W/IRdqetbUSPtM4sB
	H+cAeDiDenOwoTAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96779779A8;
	Tue, 30 Jun 2026 16:13:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id edY4ISbrQ2otaAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:13:26 +0000
Date: Tue, 30 Jun 2026 17:13:24 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 04/30] mm: introduce and use vma_end_pgoff()
Message-ID: <akPrDixmnd2o2ABS@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>
X-Stat-Signature: kawpa4gc35yqek6ffqa4mrww3ihrkhi9
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D9AF140009
X-Rspamd-Server: rspam02
X-HE-Tag: 1782836012-831900
X-HE-Meta: U2FsdGVkX1/5uGNgz8ieEPl0HqQVtIlEYfmXXhOGhFO4FQEmgXUm2gJHHqg5de1r7z7nh1/0vWVI61Nl3BmAs7Z5sQ7fOdEWb6nA+Xn/CgQqlE1SaQeKZOFJ8DHlU1JNPrke4NFVOo9UuyOUWNxbyPbYWSBbxuBRcre1XZcf9jqhbleQeayGUvd3M3/3a2wJ6dMCBXaTxtBGYj0d15i+CdU9ZEy8ZApEK6NQO4gqIAoITemhtNT1TDkRnn4HT/JWt7ileyuLVQk8N0QT5Hi22OdWe4o7w9w9X3NqUn9pyQyyymB6yQO/796s8VF4BVgLLtkgocLAfgaS265PRalwq7R24eEDqIKsBsfuccmMiiHw3LUhMxRdK18S3HjwBp8+UwidaB9//NOC23R3Ukn3pV8Xxsk0Sv5H1eAjaXnNlIsMyXIpvtu3oGde4XEFb/0Bku5acKlPjoDh4OiX6jTVMxLBr34J5wo60RLNRjdA0w2Wiv/byXrnOQB5JTZLJiqQLJldwhWi7xswxGJeJtU3OGKJUy6f91CV6Wf/bEHXByZoKHQQ1lGRfsmQT4CblEe2FpEty2dvE7UnVLgGNkbgVKEVJXfOcmQ1oK4DbjIrjq0F2zD6R75O/VZc3Gibb3sGi4fOjGQmG5fG9z+SAtx/eNVx4+CKVGIWjIEz/ROZhIagJITE2r0YgmoQblF/eOR9AQhR83sZQ4JM8LX/ynNVNPkSO0cWflY4frViDkU5B5iZhs475j+5p9s+k620wBkj/XKrjTapimpI9z/KEmYeYYj9M6a/psCW8iclVpdU39uQuYt/gYceDNIv50+xdmWBEAYdMGD8o8MQdFc7BGxY+PPyppxDwNZBi0zvHmajTSn+Vc7/hGcu9jW1YUe/D0CArFVvux8dLQ5T5gfmohV34L6wMGjyMFomSW8GDAx9Z1UI/bCjYuD4IENen3rJhsGd0+REflwcEd52CN1Ye1D
 +fs0hwfY
 Yy6xRkGQSZG85/UvjNqlYZ6IjTrNQMtFi98gmgk6Ga/lozF99l43xsxlt54/U48ZjrsJhUMocn5QNVcY7UXYtEHV0h8feijCJdyIGfpRjaSPU2x3xP54JCsgYv+vzx9zUCo32kT0gfss0jevz8cgcDrAkAgATnnTNO8NBpkGnHI7cjTBoUik0vKv2CEuGWUG5MlNyrm34ltyL5PcKRuJpySvozGoM13NVUvwjFEGYbgHSKuYBhxCVKkHwoyHxCVcgXAxA4sbIAc0/FC5EWrgVZKalqFW5eqm2NOjmdKJdXh5rAyHHtBvXH5amhlDxNNf8SmU5KIS/ezFmPRGZn7Dh3rJ0c2WEUc1D+bznJI5BC2peIqs3OXC6QtUuOegFmAd5XaXvFVO5nw4o28ts0TK/GV7XgAO68wXT4xkW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:15PM +0100, Lorenzo Stoakes wrote:
> We already have vma_last_pgoff() which retrieves the last page offset
> within a VMA.
> 
> However, code often wishes to span a page offset range, which requires the
> exclusive end of this range.
> 
> So provide this in vma_end_pgoff() and update vma_last_pgoff() to use this
> function.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

