Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5223E9DE68
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA896B0005; Thu,  9 Apr 2026 04:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BDD6B0088; Thu,  9 Apr 2026 04:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EACA06B008A; Thu,  9 Apr 2026 04:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D208E6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:51:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B49E1A06C9
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:51:56 +0000 (UTC)
X-FDA: 84638399832.14.C02685E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 67C52C0002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:51:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="1/6mHsbJ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zKA35l6H;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="1/6mHsbJ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zKA35l6H;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775724714; a=rsa-sha256;
	cv=none;
	b=AY6Ov1xOQ/TE8Tl5s2EM+3CGrshuDb1AaMnllJYAvd5ab3VZKi/qBSegwDYGA6HDnxZVtb
	MglvXkF2hYcddvsjKuCdV2vLqTR2jpP8ipYAbDZ1J/p49CZy8spBVKFg7trbxOErFJUoXQ
	KQFy3NAexoYi5YYFYOXUukHLbq/4Qzk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="1/6mHsbJ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zKA35l6H;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="1/6mHsbJ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zKA35l6H;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775724714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3UzexDVgj3hY9DW/GeYeGvfNpeCar+zlMKW2FpGQGE=;
	b=XQ40mHsuZWpuNWgk0KBdzbzRRcuiGSc3NdgP+iGgnf8bNlrHmxZTOu7YblbWn57FZJSAFy
	eqlWdXzljEo3eeFMRt7sDQ3HdV264e0It+Ocewn2Tg5Tl0r6TjbewOq3Ju8pXHyFzowafn
	FTen4gaXOR5lD6yIPuSEfzaHUb27Fd0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A7BB4EE4B;
	Thu,  9 Apr 2026 08:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775724712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S3UzexDVgj3hY9DW/GeYeGvfNpeCar+zlMKW2FpGQGE=;
	b=1/6mHsbJZhTkDFD+R641iqLHXBrz3ldYShDidr0cDdCyGKoyiyl4PtofD2WC+Y6FZl6xzG
	rHX3DQKy16EHVdaLBNkD8+XyrOLfHdG/5BHrE5BtVSnOVt/g2z4quNErwzFc15LLGQKdVe
	o8D6eosGdmB7kfRXYKk0FFHn6Ea9eRQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775724712;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S3UzexDVgj3hY9DW/GeYeGvfNpeCar+zlMKW2FpGQGE=;
	b=zKA35l6HIsWaGbm41z3H5VCAGv6L9t/7wXvibqa7azITS04o8+vkqkoa52a2miY9val6ei
	/bp5fTSZh7xdIzBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775724712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S3UzexDVgj3hY9DW/GeYeGvfNpeCar+zlMKW2FpGQGE=;
	b=1/6mHsbJZhTkDFD+R641iqLHXBrz3ldYShDidr0cDdCyGKoyiyl4PtofD2WC+Y6FZl6xzG
	rHX3DQKy16EHVdaLBNkD8+XyrOLfHdG/5BHrE5BtVSnOVt/g2z4quNErwzFc15LLGQKdVe
	o8D6eosGdmB7kfRXYKk0FFHn6Ea9eRQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775724712;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S3UzexDVgj3hY9DW/GeYeGvfNpeCar+zlMKW2FpGQGE=;
	b=zKA35l6HIsWaGbm41z3H5VCAGv6L9t/7wXvibqa7azITS04o8+vkqkoa52a2miY9val6ei
	/bp5fTSZh7xdIzBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D87B4A0B3;
	Thu,  9 Apr 2026 08:51:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T9PhHqdo12k4JwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 09 Apr 2026 08:51:51 +0000
Date: Thu, 9 Apr 2026 09:51:49 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: anthony.yznaga@oracle.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, david@kernel.org, 
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jannh@google.com, Jason@zx2c4.com, 
	shuah@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot be
 locked
Message-ID: <urtokyyat4gw3zvfffdpz5yq6pvwrzjvc3cttpps2xiuucflzz@ujutvveagq2l>
References: <20260402235933.10588-1-anthony.yznaga@oracle.com>
 <20260402235933.10588-3-anthony.yznaga@oracle.com>
 <20260403123120.82cb5becb19e1b572d474394@linux-foundation.org>
 <83b56ffb-6e2e-4c9b-b0cf-9f04b61ebe7f@oracle.com>
 <20260408140251.6158aa7a56f71128471f327e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408140251.6158aa7a56f71128471f327e@linux-foundation.org>
X-Stat-Signature: uwkgpznq9zim36zmsekh86p8b3xuqgwo
X-Rspamd-Queue-Id: 67C52C0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775724714-979877
X-HE-Meta: U2FsdGVkX18y0SPBQ1aD1ZOaWPmbYrplxsi7e5QRy5ai8xJEykegOok0ADAtiHx5mblMmqssm9pyHnnmfUdQZJDpjeX7itbLW65+b5gV/9eYQWAewncvNEmonHyQjYmOeC9GIiqQXv3d7uCTK04cjb5KOnWzTKY3yJpcSRaTXPT7jXQUJjcjtzQW7v9NBEQjy9l9J7Klzu2cGCp+U1nlTZsqL8+3msln453daXMzM1178sD1WJG/HcMx9LMql10Xs1AQFAuK5vygKa+rPcCxMNo2+PtV4Cb75ChhbnQHI7RQblJuLb+Z01WhGoVEtrt4DmR0GgGugUIoKR7eZBztGHzWNuY8y691h7RQpfFGoEaXxcYSIBAaCoSXFpJ0kPHmNDcxwVb4nmMzxVg/B0Ig7rnyCdqUYYz87PgCVsUpEEXHNo3OBXGMx9+phS7VRIvsf/FBthY1NHt2zqHpVrGs3iND8IXkjF1bdylrmyQ5DXzWjpt9T4JKFudNiEyBFkBbQ9hQk/zAj+iZ03I4uvKtoE2ye9KfmshhPMQfUhrgqdighK6olAVf8rlVVoWZWPJ/wTjpbPyTvI33EiSilaVCkL7B4MjK0dL1JQit+e+VQMA3HDDT3RgDYJJ9zUmlk8s7hJLjChRL1FKA4RjyeQnvyVGjRO0f8KEWe4OK3M7xMrQw1zBc4hAcEP2kBYBZo3uKZPzpRP4k6OzPd79bmAori+VOeSU7kXz/0aIDOPBNv/ykj9aqhVkoAd5VFNbNZ7UOKdC+XX2pDotfjRMKzuZ7Yvh2z2JAkFoij2dNPfta2b2U2Wz/uEBhsxR1MeYKiH+Bk0o/aKEbiJkstZ8cXiikIA5Hlftee082PbiUB6GHihfSrjj3dkLfn/veAoV/9V7t0Hqt9KgE3y8wMfNuDWdprpsWBrINU1o1jsrBCFW5fRBRp7XWEoP0nqX6GpxzetVy0a6Ts2re7NI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 02:02:51PM -0700, Andrew Morton wrote:
> On Wed, 8 Apr 2026 13:35:42 -0700 anthony.yznaga@oracle.com wrote:
> 
> > 
> > On 4/3/26 12:31 PM, Andrew Morton wrote:
> > > On Thu,  2 Apr 2026 16:59:33 -0700 Anthony Yznaga <anthony.yznaga@oracle.com> wrote:
> > >
> > >> For configs that support MAP_DROPPABLE verify that a mapping created
> > >> with MAP_DROPPABLE cannot be locked via mlock(), and that it will not
> > >> be locked if it's created after mlockall(MCL_FUTURE).
> > > There are a few queries from the AI reviewbot;
> > > 	https://sashiko.dev/#/patchset/20260402235933.10588-1-anthony.yznaga@oracle.com
> > 
> > Interesting. Of the two issues, one is certainly legit. I need to add an 
> > munlockall() on early return from test_mlockall_future_droppable().
> 
> Cool.
> 
> > For the other, the question posed was whether the tests should handle 
> > possibly being run on an older kernel that doesn't implement 
> > MAP_DROPPABLE. It seems to me to that a selftest should not be expected 
> > to work (or even necessarily compile) on kernels older than when the 
> > selftest was introduced, but I don't want to assume.
> 
> I don't know that there's any policy on that.  My attitude is that
> selftests are not intended to be forward- or backward-compatible. 
> That's why we ship them with the kernel source!
> 
> If we get a selftests fixup then I do like to backport that into
> earlier kernels if appropriate, to keep those in good shape.  And that

/me puts on his gecko-shaped distro kernel hat

Yeah, adding selftests and selftests fixes to (upstream) stable is great.
Particularly when it comes to bugfixes (or CVEs) they are quite handy to
verify the fix is in place and works properly.

> has the effect of reducing people's motivation to run a later kernel's
> selftests on their current kernel.
> 

Yeah. Some people do that but... to each, their own :) It should not be
supported upstream.

-- 
Pedro

