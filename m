Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9517CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBC66B03A0; Tue,  2 Jun 2026 09:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D44B6B03A2; Tue,  2 Jun 2026 09:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C4A6B03A4; Tue,  2 Jun 2026 09:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCC116B03A0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:47:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CC4F14093D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:47:04 +0000 (UTC)
X-FDA: 84835098768.07.1B1E753
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id 72E4720003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:47:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bDPAhczT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=S+XdiAPw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WsFuQ4d5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="4t//PCFP";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780408022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmVb47wh2hH8fLzFAOWLUOjb7eKLNxkG0RvgTDTKxVU=;
	b=RKbjHtlUzAHOdFxh0isSVpi/i8aXg1/FJOw9GG580JgmnLDpkQwl4wL8VafwGDNRsFi61h
	7H8XhjiTMiOtNMaTBYuktsEelF5rmnNrSUSaxGntdLqK/lmME9xg7kTZoYbsFwWvMNAl3K
	ARJeOAmnnkN1CbZjEzYDXL/yjO51nGk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bDPAhczT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=S+XdiAPw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WsFuQ4d5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="4t//PCFP";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780408022;
	b=vHuCI8gFhQUxWJfx+MOFL2nQMPd1Tms+YoQlLoOny8sRDBayun/gKMao51r4IfvL79npHu
	HgM0BABtEECcU78sfIfkaoD+G3VA+ky75MwPWsig9uMftjLXZrTsfqt/C7/5kRBi2vImwO
	/ctl4sXr/geWJJWGluImfViwrfoHdDk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D7F2667EE6;
	Tue,  2 Jun 2026 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780408020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmVb47wh2hH8fLzFAOWLUOjb7eKLNxkG0RvgTDTKxVU=;
	b=bDPAhczT57Bx3yapCXs1A22p9HhKItXr2vadOkJeljpDRKTzh+Os0zhWtgW6cirR/XpF0i
	BiId/NradA+gu7D3WCraIZQR1rUO7CyqdsI6UJimb90oJViOhWF9MyI077CkYnMPBr9fDO
	NdUOyH8/JGSL8Klce9ncoS7zbVU+IiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780408020;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmVb47wh2hH8fLzFAOWLUOjb7eKLNxkG0RvgTDTKxVU=;
	b=S+XdiAPw9z4xsrDNETCzQr6EXuqMMFt/EXdUhmw56nT4V/0bf1qrBmEi+Uiz+L8JhdvJUb
	iQnaCFD1/S+DaLDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780408019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmVb47wh2hH8fLzFAOWLUOjb7eKLNxkG0RvgTDTKxVU=;
	b=WsFuQ4d5+DlBtAGOsUf1HXUU9dR3jz+tHgKL7kuJ/vzTfYOpHwZ8GsrradUAfUcDJ6177p
	0HHfSk4Rtn6QgSAshLk2fIbX6ZLCZP5sY/jUjRQWrOFFgoxX4F+u395Pu0j9objN4tPz3q
	e/XGGB88vXqYVl4Thi4/5IxH4c+zMyI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780408019;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cmVb47wh2hH8fLzFAOWLUOjb7eKLNxkG0RvgTDTKxVU=;
	b=4t//PCFPaT+VqzdJNYfbtazRtPQOy6lTyKr2BqnlrV6xIw2g7IxIiEd5L9lljU2TFqpxXz
	tJbR0XtmT4/fGZBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16270779A7;
	Tue,  2 Jun 2026 13:46:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YJ3xAdPeHmraSwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 02 Jun 2026 13:46:59 +0000
Date: Tue, 2 Jun 2026 14:46:57 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Dennis Zhou <dennis@kernel.org>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>, akpm@linux-foundation.org, 
	tj@kernel.org, cl@gentwo.org, mhocko@suse.com, vbabka@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, muchun.song@linux.dev, 
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
Message-ID: <ah7eYOb5YU0Jhs-Y@pedro-suse.lan>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
 <ahlameE6FBEZj_gt@pedro-suse.lan>
 <ahld5va1b9w8j659@pedro-suse.lan>
 <5a4aa532-77a0-436a-8f5e-1bbcf2db6bbb@linux.dev>
 <ahrm4x2ubbjs4An1@palisades.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ahrm4x2ubbjs4An1@palisades.local>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 72E4720003
X-Stat-Signature: zuxnk3wwin16mun78qscberq1zarz8c8
X-HE-Tag: 1780408022-42309
X-HE-Meta: U2FsdGVkX186WawbIB9n8VsATk6QEmkW0EJ8oChmv2McLk5XxLr4D4y6jEpAWxS+wX+5qnMN142H++fGXuWMb2br5B/gY793gisSltn1BO5ArAs1ESbQQkxA+wptbJoHiypRngHLZuhoPb9rWfPwZLa5VfdhVBp+8kX+RHjLobPXBo5TdEtdvu+mXpQ4c4XsYA/yPGPoJAXJoQrhp3r7gk/oCZLoNSVEdZEPDa2TUB3D6Aa/O8uun8IOHOkUf/ypbHdxmqFmYBCZCWIVpuAxe1DBc0p9ZUt7g/Z84ZdIgadUdq4pE/LcnhR2+7jZwAhrE3YNu5z0yLXx+fE5RSilxvgb6mFPHEVYueJbW5JPHJBmPWDk0Aw7gqh4qM/3vwYCqJtTITgOFrw9PDmMYnJO8t+gjHeqjG0kOdYqk1VdYMJqzPOC/4QPpbdafZNECTkThusxH8qZ1Fy4Z+cHnWmRUPKBSbWsHdfC/t0Ax2drY3gxPwW/8vza9soqLgqCDic2X/lvV7JJA4cL0D+C0RfsiGFGIO7eIJHL7D8B/tqLWscqGgRcE+P21dErqT4bcymNagUkjX0beSuBbkNalW26IZoJwKAkTSAaa/gh9NIwK/yxn3ntuc3wBorDjxmcI3pDKk1qh2wTysBPkZoL4poV/eqC/qWSWtLQ3kXCxcaIg8pzLIl85E0X0b3E/XLAd2VUupiPNL9xAwOk+9Z1klA4yJ7zCwlypDvTAvBhdW/X4PIuK+xD025ZQdsNZfUmSD+Yq5edWdrFYLldv2NYG5OsgvyHhrj5G0uLwJQ+ASitF0g7EAL6fpZn3GHIYyqmWS4dgDYS3OVMoMW/KHOpr3d9DkQWI33ctOUV/W1a0qtfODilJo0Jj1mN1h5OXqKm4LgWBi7joFx0khGQi30ufj7eHelKksbsJrSvc6k1X4+iwNJRe0s8gcDT7IZCeeXefoMpu0I4LAAnuKQLa4+pCXc
 czrpsdzz
 IF9rlJoMTAFaq3n/8QvEyPBQkg+HimOSpZISukDjsfQGZ0Udz1k16liC8UDqjXRHR1IcQDbtfDKtshpF88k1Zs6K9mZTWDuqvpoz+2Vucnch5R8gjyhWgGtSqif7FPbhQsmjqt5MmaI390vE/HNfFe2I6dbf0YH8Mu4U5MNeJKvSfYuDgYajfB7mCupQCD3JXYyei1eM7fdG7uQQuDh1Ar0KVIzXLYWwFdEnvo+4FHdtln5VVVD4AtvQYRKLszvdG4MUodbA4nZXpEOzA8deNdJwi6hVl1L8Qk0uvXhLRZ2qkuxtzJQTQ36Lhn2I6MxYGwf8X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 03:32:19PM +0200, Dennis Zhou wrote:
<snip>
> > 
> > I’ll try to do it.
> > 
> > Following your suggestion, including in [PATCH 2/2], I will also try a
> > different approach and fix the issue by reducing the scope of the
> > pcpu_alloc_mutex critical section.
> > 
> 
> No please don't. The point of the percpu mutex is to ensure that only
> one person is ever possibly creating a new chunk. If you drop the mutex,
> then you have to deal with concurrent callers when available percpu
> memory is low. Percpu memory is expensive and unmovable so the cost is
> in the control plane to avoid excess fragmentation.

And so is slab memory, yet this is not a problem. We shouldn't keep
problematic locks just because they may aid fragmentation slightly.


-- 
Pedro

