Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A95D10BA458
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909F96B00A9; Fri, 27 Mar 2026 05:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1306B00AA; Fri, 27 Mar 2026 05:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7866B00AB; Fri, 27 Mar 2026 05:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD096B00A9
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:15:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 077C4140FFF
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:15:22 +0000 (UTC)
X-FDA: 84591284484.06.D8022E8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88E76A0019
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:15:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ruEuZ21s;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gbYfiEwd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ruEuZ21s;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gbYfiEwd;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774602920; a=rsa-sha256;
	cv=none;
	b=Ga6/ub+NbBtfEY/rApmZEIbSTRR5r1U2XbTvYPXi52bGrh8B6oFDvBX1HiKcb/mwrYaqV9
	fUIEDYZOVTmG28gVEa2JqjCiFIwRNK3hFlhUw0PoGUPIA8K978boykMYPhZ/cxwIZfueKa
	AmYMVIAS5iUf5SAu+GlBe5mzRP9YHZc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774602920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HaDss835MfLx7foIbg4N4ZI0UGMh1mQZ/fV8pFbtVE0=;
	b=AY5QP0BFwvqSwpOdgqTGUorTSufiQdKVs7G7rnIk2GW33qXPZ3vHeR0UI1+FFtAE1pt2h9
	x0cWEYhfHbJ+RfpsEMjJm1+/fx+TM/KC9oa4YVtiWhNudQiYX1plusFX4FH8B2SeKE/gOU
	ojAaZavqcfmHeK1bv6f/a67fZg8gLy8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ruEuZ21s;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gbYfiEwd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ruEuZ21s;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gbYfiEwd;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B73685BCD1;
	Fri, 27 Mar 2026 09:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774602917; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HaDss835MfLx7foIbg4N4ZI0UGMh1mQZ/fV8pFbtVE0=;
	b=ruEuZ21sc3X+vWY06FXw9EtPiBexd5OzZctCruOGDAhvL+kpCo2s07iBd4mEpMzPm4S1AL
	2cpvedt3vYcndI+AvIgfh0OVhIM5nslBYrxHt6eB8kt1r2J/chMUJrcKUwD15XZQ/JM4P4
	nY+iZAW4ou/tsfsnFqnWNZAeX6uUJUg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774602917;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HaDss835MfLx7foIbg4N4ZI0UGMh1mQZ/fV8pFbtVE0=;
	b=gbYfiEwd+fBhipCiPcE/Q2vBDqdPonnLWeQT2wbAnSF0aCtPESL7kzB0D2040OkTw0qzBb
	kPDKfH0bpyUGTrAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774602917; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HaDss835MfLx7foIbg4N4ZI0UGMh1mQZ/fV8pFbtVE0=;
	b=ruEuZ21sc3X+vWY06FXw9EtPiBexd5OzZctCruOGDAhvL+kpCo2s07iBd4mEpMzPm4S1AL
	2cpvedt3vYcndI+AvIgfh0OVhIM5nslBYrxHt6eB8kt1r2J/chMUJrcKUwD15XZQ/JM4P4
	nY+iZAW4ou/tsfsnFqnWNZAeX6uUJUg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774602917;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HaDss835MfLx7foIbg4N4ZI0UGMh1mQZ/fV8pFbtVE0=;
	b=gbYfiEwd+fBhipCiPcE/Q2vBDqdPonnLWeQT2wbAnSF0aCtPESL7kzB0D2040OkTw0qzBb
	kPDKfH0bpyUGTrAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B73C4A0A2;
	Fri, 27 Mar 2026 09:15:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pHIJO6RKxmkIEQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Mar 2026 09:15:16 +0000
Date: Fri, 27 Mar 2026 09:15:15 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	antonius <bluedragonsec2023@gmail.com>
Subject: Re: [PATCH mm-hotfixes] mm/mseal: update VMA end correctly on merge
Message-ID: <snn3ppipjfbrkmuuqtuh36tq2ympo7udu7oe5hlwmxggw7q5r2@3ka7jeknrcxw>
References: <20260327090640.146308-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327090640.146308-1-ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 88E76A0019
X-Stat-Signature: zokhfwqefugq798qaureffutxow7dyjb
X-HE-Tag: 1774602919-330728
X-HE-Meta: U2FsdGVkX18eZulHMq82kCQAqW2BH5GhWuJZuIuUwlssc6vUitN68wvXInWn+kvL2ldVYDFeoR8n0ZQGmptSES6FDwsaPts2w8rcgrfvv9vj8tDLq3YRMga2kXwS6EWWIKtkIz79GLnPUZR643xYIQ/13wn4Tttsh3fQlp7JjxXDiFnCnfY5/bsP4b+mqcXPuCIr/+x+kr4KQ1edrxHG/NJCYKABrd//JG3d4OBd4pAET+/2dMXPV+EA8jWjkeldmdOraQo4zUVBs0fhwwGhjyq/x/uJp2Xaeyrk5c0mk7UnokL1PEjGPP2tWc4UafbeWW9mWMPPluT9KLCx8ZVxMMpCpDmquXDaun08zNT/YM36VUh2Q/26u8ja05Mwfz1N2iXrWZomQCu8lFeaN0k6DoQIKz7EbPvCM/jHa8VpkAQ+wC/O1s/SL+y7mTpkCco9UUB5jrLbXNF/tbXsyRJdlow9QJHspbJLrjJtMIxfI+wZl7p/Vcq/qU+GJV5IILPkIwRvdsEcP8E4qvn26F4gUEr0r2EwEjQhPmTVhIemW7XnV4EPmLvClvSq1apSY2K8BRorKCyk0M4c3Jtwj1b3FVlQ6nPCuDPc3TErYs76cxd7QHZBk51SpOhey5m4wwtKQIAO4fkxMmf81o0ZY69FZyBdxFsu/zOkVZLpTw7ID7N1yHXR1/JZFMW8KCO1+LA9hN3SS8XTRRbbg7SZoHixHDni8j0OxSqOZopmcKpu71zkj58CNclbnLltIu7HBbYo1UFtS1jyfo4VAs+jnK8AHYHqiHN9T0Ms7ylHDl0NMfAowrI13ojvou9/4A205c2BB1Js8aDbgJaNCbr5avxS3P93F0H7EwuX08NctQvXmY0bZJ53cTXhCZ6QKzx/8cGQ7Fx5jOHKPnhbqxWTZlfPWX0aYUubE3iw9kX8B+whS0fbij7+atREIBn5N5DmVzNEC3nMOmWTmBIgxzFsQsL
 eBy1tn7t
 USBKvkVOvFgKowZ+gVWuUrDsVPmF+qs3goEifti8NPqUziPVOTGs+0GVjS8IaSRKp7gyKyWe/wl31UlFw6DxgTEEh7DzwkHL4xOBz+6iK2IBYhGZ+Y3jMpj9zxwKFSO49bRBOK8JA0cYB8BtuMgtjkVTR1ZF2zA2yLVPLgdVBXLuPFnUwhTlcCuJe6LULlfCbaeYhQlIz60R13/5O6ozH8u2dVJlP282DnmzGSuuaS0re0pazQcw2fJb6QiHJNoWj6IbR5SY8/jBD4IJG7can5jDQgDUwU773A6kwyk8QKYdo4fVpE8RmHNeUU2M3BOAr4E9W9iv4cV+Bvf6/TU5LiYy3H0Y3GqN6ahmYI+Md5ep8jXosvkMHewqYYssytTKExWW0H1O+XTK0XvFT6Medto5woA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 09:06:40AM +0000, Lorenzo Stoakes (Oracle) wrote:
> Previously we stored the end of the current VMA in curr_end, and then upon
> iterating to the next VMA updated curr_start to curr_end to advance to the
> next VMA.
> 
> However, this doesn't take into account the fact that a VMA might be
> updated due to a merge by vma_modify_flags(), which can result in curr_end
> being stale and thus, upon setting curr_start to curr_end, ending up with
> an incorrect curr_start on the next iteration.
> 
> Resolve the issue by setting curr_end to vma->vm_end unconditionally to
> ensure this value remains updated should this occur.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
> Cc: <stable@vger.kernel.org>
> Reported-by: Antonius <antonius@bluedragonsec.com>
> Closes: https://lore.kernel.org/linux-mm/CAK8a0jyHXqBpt8Xe8v9SNDbnRiwz7OthA8SKY=NLRY7smPEP3Q@mail.gmail.com/

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

