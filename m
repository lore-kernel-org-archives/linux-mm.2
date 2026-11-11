Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C69606A330
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=otOxawUx;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Fg+Nrul0;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=EhbSiBds;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=3pIOXjjl
Received: by kanga.kvack.org (Postfix)
	id 2D9776B05B2; Wed, 11 Nov 2026 08:00:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262F46B05B3; Wed, 11 Nov 2026 08:00:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1047E6B05B5; Wed, 11 Nov 2026 08:00:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DEAF66B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:00:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E22AC02FA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:00:02 +0000 (UTC)
X-FDA: 85422845844.26.26966A1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2309F40009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:59:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=otOxawUx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fg+Nrul0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EhbSiBds;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3pIOXjjl;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794402000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vckRnu8yhYPujC9czlRHD4eY30Ogbh/EdkpZK4P1gpY=;
	b=g/rX8t+OD+Y9dtvskuv681SyeVOSrkmjCkUycA6kqMw0IzucmEXduOpjPdOG+p61KQLRJG
	RC/Nw2dPyDV+9YoAslAQYdx5RmP4+vluD4fCzsoCAwFttyc/e33ExPi5usHZPk65FIhb8E
	aLOrBYztZK7LCKsuwLNPKwpT4q9/s/c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=otOxawUx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fg+Nrul0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EhbSiBds;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3pIOXjjl;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794402000;
	b=jH05aodubKbEpFUUEW09NpFi3q6KwySnlynBAFlbpl2I48MYA5F6xUM8086ByQrf7UN/K+
	AEOdg7oNeZr1OPMRxLUVME0hWIOXnq2n3P0TMbDlSksYU5+MwW3QORrQoOiVtx+isGGf3L
	j3fpCnropfbkdlUHS1pwP5c3w1djDo4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1077822163;
	Wed, 11 Nov 2026 12:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794401998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vckRnu8yhYPujC9czlRHD4eY30Ogbh/EdkpZK4P1gpY=;
	b=otOxawUxw790/QFBjM3l+MFthA3861nlTmYALPAV8UroFCQPTuhWdqQLx2Bc1uIFTNjUSf
	mnB6pWLs5IMmL/6Nh1C4bBTDNKUwUU7gS0QrpHdV+W4K35O9r7vi4hE7ol2MHfBI5rkx3k
	JbleWrObvsXGVSk2sYZAGh9tC4q+53o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794401998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vckRnu8yhYPujC9czlRHD4eY30Ogbh/EdkpZK4P1gpY=;
	b=Fg+Nrul0Jyo5LklpxiAuZ0HYrvjr7mnXZnx3MVHOfvH21g/exOhh1s1UL3D/FUe/akkrR2
	wP4WfFpYZXc1TlDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794401997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vckRnu8yhYPujC9czlRHD4eY30Ogbh/EdkpZK4P1gpY=;
	b=EhbSiBdsrSVaKSADwnL0R0h2FhNTtiQe8O4S+eqdUQd7Xrl3mwHjJ524yrql/BM+FAIbBh
	HcAzG0kPGFOJOYhrbr+minyw5ZLHbacQpG6BNn1fmyvfN8AukapPIrVspm4teWxjv0DZBr
	REDvjtoemSrILrH4izF8HUQ1q72PYZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794401997;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vckRnu8yhYPujC9czlRHD4eY30Ogbh/EdkpZK4P1gpY=;
	b=3pIOXjjlSEb/Dd0pQ3rAW5PfZnnK2WJEDuZe2OvPfIrsqGCueoEmJPkiIgDh+2Aw4Jz8eq
	hcEUcN+9syH0oIBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E94B11339F;
	Wed, 11 Nov 2026 12:59:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SHrxKstm9GqAMwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 11 Nov 2026 12:59:55 +0000
Message-ID: <64a26d9d-664b-4443-8d71-b854bb01316d@suse.de>
Date: Wed, 11 Nov 2026 13:59:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] drm/gem: Switch to __nonnull_args() macro
To: Dmitry Ilvokhin <d@ilvokhin.com>, Alex Deucher
 <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Joel Stanley <joel@jms.id.au>,
 Andrew Jeffery <andrew@codeconstruct.com.au>,
 Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai
 <billy_tsai@aspeedtech.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Kees Cook <kees@kernel.org>,
 Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Whitcroft
 <apw@canonical.com>, Joe Perches <joe@perches.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-aspeed@lists.ozlabs.org, linux-hardening@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
References: <cover.1793027261.git.d@ilvokhin.com>
 <5bfdc1491d297b5e98cf42322c790f06481c28c7.1793027261.git.d@ilvokhin.com>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <5bfdc1491d297b5e98cf42322c790f06481c28c7.1793027261.git.d@ilvokhin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.00
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2309F40009
X-Stat-Signature: 5qkfzmi4upe6bca95ku8pwgfx6tn3j4t
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794401999-3530
X-HE-Meta: U2FsdGVkX1+4WDErDpA8KkKJEb/W+HUaxn2mL7Se2RBKxeywmtrI7R6rxVNplkIQOnoYNwrev8zeYG8U1XzgJrnUOkTw677F9sLLN3qbcX1cFgRjXO30gBoWnduo4iWRox9ZrYOY+yihUr+ojjdxdX7MSUhXVJFj/pGcIFH7DSN7luBCCyzbI3sZrQIfjF//7xlbWbA/MEjwL95QkvntBFBAFFTjT7lXYowB+BaySjEyhPL4fenbrA9Fji9pcPCi2JfyDR1P2IN8io4Cj/C8s+E68yvLskD863QOfrM+bI7k0Y12HMRevu4t096FqDNC6Dz6fIN60qZcAZ7g2Q4TeS6+fuvVYpZ6kZ5BsB7uVw7CRC0kJCLBGj/2BguwalT5p37ICHRYK2uThbbfJmnqIHg2bpEDaOhlIUKGddmBphWaAKhKCYPSV7Obwxb7aOa7veL2sJcZaojPrdiFZXVoZp1tyBsKNaTfdzee2LudmB2ueOW6G8J6O1Q7lLPwcNFAjwubxTnh9+p+oUxwesfHNLIp5udWYdBGni67QFh2b0iDTqzPZJtKFP1rjuBFeZ5fUyvfD9kunYlB+gFQAMj2ZkYLCWQrtLDepXmwfKlJoPHxxgdh1NRcOpMw4gJKdjOJX6vnzk7UTRKi9+LWYz/0Cc9f1A9clvfFM/8uuKMNvneD9tontxmRI6oluTEHz5dRNyImets32FGC86hIHeeQtPhTECIq7Wy5sN3VioXNxEh/iM/5XYmuBvl87Esmo/FTYbmB11krad0HlQwIdIP4l30iz8CNndy2ScPSKkvKUWVrVKBJR0wAiysMx1u9BhlgmgwzNA3miOtK0bWv59yOM4PnzFsPHe+9dQtSFf301MJsCNdahdrqjPBoBgafQOKwaVa/m5XWuUiJdVaqfGe8UGAt9IyUJUrvRYinG3C7EsN8Oh8hni8Z7a2qICa6aOXd12YTMjlTwuY1OCiS+eD
 Plf/5lqP
 5Tfe0SiDZnIYm3AGN0nSYzzZyXavrAZQplB+WNSPytZTq0eH6NE7CgxWbWS0YsL16R+G7kxEa4yqpCstgLG8CS3/LHzsE25fpCWtslIwi6ItDqEc825B/mybdtUTGsn15k/Y9jDqPlkt1Z3iSiCPg27nBgKpKeV8lVGhvg2ifoyMlyngSIdJXIeoXn7sqgN/v4rDlpJFnf1ROblaoUrnkoqcc9hPs1mT9JEeOJ9v/PDg26LVvW8I2jPd23m1dIkNbw3JSBK4s+z+9hN954uPmsATp6+Opu1VlvOD6ZpAex+yqhdW9ukuhQNFup4hKa+8vGCRJBxp2IEIZPLwQebG9FclOULsNrXD/GvbRZEYHM0r8Z2FlW6GVe0cxSIfojcLz1jnq7JksHyBKfEhgMeZq9BgzXJD+bsTBXH+QNgbSPCK+hb5IIGLuWwEiKk+chtHt+lRZMHgX6yWociiSCY8jNx9f1GAoHCsTvuZc0i1TX//6w3teTt4y6MVa4e0oA5nYyozInuBtaWaYa/mzSYkq1VAYxhZGJfrrskzf7effqsrJNZm7i+NG0ezztKPrkAK6WQgxWOnXyuRIw5rJVB1olC3I2DM9ERb9pWnG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



Am 28.10.26 um 09:19 schrieb Dmitry Ilvokhin:
> Commit 22302af28d3f ("cleanup: Annotate guard constructors with
> nonnull") added the macro __nonnull_args() to wrap raw compiler
> attribute.
>
> Replace __attribute__((nonnull)) with __nonnull_args() to standardize
> nonnull attribute usage across the tree and keep the attribute's quirks
> in one place rather than open-coded at every call site.
>
> Suggested-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

I've added this patch to drm-misc-next

> ---
>   include/drm/drm_gem.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> index ed329408acbe..56dd15921c7a 100644
> --- a/include/drm/drm_gem.h
> +++ b/include/drm/drm_gem.h
> @@ -566,7 +566,7 @@ static inline void drm_gem_object_get(struct drm_gem_object *obj)
>   	kref_get(&obj->refcount);
>   }
>   
> -__attribute__((nonnull))
> +__nonnull_args()
>   static inline void
>   __drm_gem_object_put(struct drm_gem_object *obj)
>   {

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)



