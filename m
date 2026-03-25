Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99294109C059
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4106B0005; Wed, 25 Mar 2026 14:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C0F6B0089; Wed, 25 Mar 2026 14:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3426B008A; Wed, 25 Mar 2026 14:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC4F86B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:40:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6844FBC1BD
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:40:05 +0000 (UTC)
X-FDA: 84585449970.25.FC79D2D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id E36D6A0018
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:40:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R82g9xbk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CeKczkdZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ahQQq2GP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A3buodUM;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774464003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYDGDrGfIn122PZC9+Po4r/LTcmi8K6tGyJ7hJ3pxfU=;
	b=rYJWZpm8OGQrpnu55NCJjd8f6E4IOkXMdD65vG4H+WLVLMSzDtQaCcF4UkTosnQjXZ3JhU
	LtkUzQ5xzJciSYM5Q4wiNdU/s1tS9ThuLPsMiuH9aqoM1s9DLotKZrj+cAEMFUTWDoRXy4
	Skez9Cz1lXd9vIiYW9IcIIgVH4d0YZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774464003; a=rsa-sha256;
	cv=none;
	b=57tb8Xiyx8q7JsZx13wemDnr+seGhgfJqouuTGu30soXoOCk6mix1Jgm93ljEYahxJukoJ
	fo29EkMrVh0GDM/Jagl7JAqSGBkpxXPQQRxtxQcWuurT1nreiFOC/v+zohPkxw0+Ezi451
	2Hl/yt/OZmbELcsP6nimtW1FM18fkXw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R82g9xbk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CeKczkdZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ahQQq2GP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A3buodUM;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2C3A95BCF8;
	Wed, 25 Mar 2026 18:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774464001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YYDGDrGfIn122PZC9+Po4r/LTcmi8K6tGyJ7hJ3pxfU=;
	b=R82g9xbkKRFUHDDEQ0sYaqpkgMyIA/uThYtui3aHU8RIAH4fXR2zekzITuIJIAY9TzAQMe
	i3l+bePv+AeOWBQfb7j3LrxZoXnF1oHRl4KZ//PoISvSNE8g79x+Hl2/3rxQsZ/O2pbwNs
	lV8wy6DuFgUA6d8L9aUM9WhDs8tTz0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774464001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YYDGDrGfIn122PZC9+Po4r/LTcmi8K6tGyJ7hJ3pxfU=;
	b=CeKczkdZKp+ZH0otzOb+1i8ldwwh29DdNYBJXt/l5s73zBSg/aujgeRvfXgpmdhU1mFHGb
	DQJ8O5vR+4ADF8AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774464000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YYDGDrGfIn122PZC9+Po4r/LTcmi8K6tGyJ7hJ3pxfU=;
	b=ahQQq2GPbGUZ/H/+nbVfo8WGKCPHnKFbq8iFFU2lYW/t7svJLKxAqmSUuvLoUlLcuOFdzm
	0EgpA/s0y/usHEcoeO1hRpL5YjJGmvr1asFc+ad39x6LijiB1NwXF+2Oylyu8hSLz4GdBo
	gW43moFk3FMkwZGeqCxjnpcCoiXOkIE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774464000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YYDGDrGfIn122PZC9+Po4r/LTcmi8K6tGyJ7hJ3pxfU=;
	b=A3buodUM4dUxTK65Jm8S0deVGOmbR8Y7lBnKO2SfyM9XNernv7ihWdK7NTeRY2KzMna7Bz
	57wa0HlvX3g3XNDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2451644543;
	Wed, 25 Mar 2026 18:40:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SInMCAAsxGleTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Mar 2026 18:40:00 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A307DA0B32; Wed, 25 Mar 2026 17:12:23 +0100 (CET)
Date: Wed, 25 Mar 2026 17:12:23 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Jianzhou Zhao <luckd0g@163.com>
Subject: Re: [PATCH v2 2/2] udf: Fix race between file type conversion and
 writeback
Message-ID: <mrtedxufgnu3pguazamd6p3fgu7crj2hkx2gkmckodmn2zccfb@x3g5vrmntkxa>
References: <20260324105132.30490-1-jack@suse.cz>
 <20260324105316.28684-4-jack@suse.cz>
 <acN6YNzbgVUPGETm@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acN6YNzbgVUPGETm@infradead.org>
X-Rspamd-Queue-Id: E36D6A0018
X-Stat-Signature: he1xnxi9im6m4xoorhx7h9xw93zt6gpi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774464002-145695
X-HE-Meta: U2FsdGVkX19lXVMSoMq3C7EHkkP13OHhLmALa9vUfEv5jObyaF/tPhla314XBXO1BD26rXwDKE3mPcOJza5GU68OtJXKwIOJY31yZMmM+TB4o9O/Ion444hjESZh/yckPFkRrVJv2EiaI04zYbIIn+MC+Xsjxo+n2/c1By4kTpgYS4poLUKX3zGBW032SO84hKA/YR7FbMF6GHHN7H5QQ213t8qgznc+ZW45upqcDB0EiBOafS6tzFeyzIqnVo+8s6E6A8tUb7kd88FHN3Tp37TYvdy2JIwxobNvtQzKF5HIipWRyk2iqYv+aAJbE93KnL2nS/p6Y2KvDROylUN5lgOXu2fRQkXySWNj1XSNCTiRhRnDhicW2+RDFaeWcolRvFCisCwLan3oXk0bffskfIPOabIMV+1iNRT97kdT2BgppQiaqqtH7wcdIxdFcDzp5GLz1kJ9t0DORrJ/xogX/bJg2A5JZUhwtMGdYVszgL+IekzZZbLathxCP5TCJ/+k+cjXprtTUASIffNO16drRn6mib6V8i+zehmvmpCthB6H8jRfXTSos64cjZ8i+P5+734Numn2MkDfTXBiHZbO1POMNbWOB2MGUgc8k8aNFZEFTC4ekZ4X7WS5kAA9bTFJmuFW5Nkzw4V9QzObwV4kolygVENTY+9NlJ1/wG4wlVMQ8lcJOu8pthTyoGVkcPsYhy+nFC0seWY5abrG+tDtpHxQxlyuIfYkOHtAMGaS8T2Ao8rbyNjVC78T3/IdVf/icsv10dG/zQ6KFHOlLQec4dCPF04O7RS6rNYKPGy/6oK3fzJA0hRQBArD4DE+Qg/7GncqOX0t++gqVOhV15vbcTx58AQUqyVR9NPaqLMn814/jOQQEQqPIg6ek0Hv9wzfJ5vpdjufcOidSBBghp22OH5sOmmh7TGMK4Fnbf9Bz9ujCUraUbe0N/2U2bDXDXdQhkIHWPjY2hbiqQ5a5h9
 mXMZUsUG
 YWM6cREJIXiVumStUPZsF6XPeyWwgzLq5Mmg8EuOFMuV+lxjMNtiPMCOOh5/9ZstVrr4sEs8+kK9buvuqp/ZHYpPzB2VA3ua5quv/4pFjTSTTzxKFIkKdCS1xKqu35mrIYH0SqFWULgEfH4QpIXdcip4zFJZPDo6bNqsITi3Gx8KT1n8GOwkvf7+aNMuGmXgKsCGoXcuWIe9+PisVf7rkXBD67X3EIuOFqqIzLvv4I16mRqtNIW76NdpHkWG93uVIa8vZE4DobEq+Rxcy/pdYYh5JDsA3aDS4O4eMjKee06hIhVLoXg7f/hLh8VMNZzQE8HBA01ihoFfxaY/aeRQsfRJcdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 24-03-26 23:02:08, Christoph Hellwig wrote:
> The race is real, but I don't like exporting the writeback internals
> for it.
> 
> It seems like the somewhat cleaner version would be to have a version
> of mpage_writepages that takes and extra callback called in the
> writeback_iter() loop and allows bypassing mpage_write_folio when
> say returning a positive value?

With a single user I don't think that's really worth it. I think it's
easier to just opencode that small function in UDF. It won't be the first
filesystem doing the "is it dirty, wait for writeback, clear dirty bit"
dance on its own. Thanks for feedback!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

