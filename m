Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEE3C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 15:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50666B00D6; Wed, 23 Jul 2025 11:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D648E0002; Wed, 23 Jul 2025 11:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93DDB6B00D9; Wed, 23 Jul 2025 11:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86D6C6B00D6
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:33:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32861C0125
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:33:03 +0000 (UTC)
X-FDA: 83695922646.05.B7AAAF6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id BFD3E4000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:33:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mJXcMAvC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8dbAjp8S;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bTZryZDH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GKLkOVTu;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753284781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pU+3sJNbYBelT2fQpiIx0haZ7OiDqvI5XNfu681tSA=;
	b=q9HnDnik86RkJ4jdQQYHrg/M2079QWF9fI7lhnhpWia0P+kvg0P4q0XMHEExwbmjbHpvgX
	vS0IPrrpmn93WxaUZtCLUT3OC7ImkTnoDG3Yql6VBMO03l9n1eRBycOu4blkiJm7FrRArT
	UnvGY9huyayEvPNVnpxhZBJUrbBcnf8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mJXcMAvC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8dbAjp8S;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bTZryZDH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GKLkOVTu;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753284781; a=rsa-sha256;
	cv=none;
	b=8oBnRKmdRoL1HVLSthliIIvteE+NNBGWftEePpvLsvcAZDvSl1tykveOpGefdbDkcFLyES
	bR+rQr0p1+cKNdmIWya0FvDJyaPthcRv+cWt9GGBnlivFqYHD0JjnI5Up1Ig2ACo2iuKAJ
	GJJUo9WCliWWXTFwvPwnywVlLG/nzXA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 203B321843;
	Wed, 23 Jul 2025 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753284779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5pU+3sJNbYBelT2fQpiIx0haZ7OiDqvI5XNfu681tSA=;
	b=mJXcMAvCu4pXu1tD8Fjrj9bz2ycM+cSnUsjUcd0O0bJQNCl4p5IhQjHChgQQuHplvuEMvU
	jMg+VrC1YiJYtrBoVIacSsUVyEaWnig1GTgi+jBR/ukcUTT8qXzBUNviXsilWWFM0xSHSb
	caNtBWhbIOpwMZsZeRImupMveOf+a4I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753284779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5pU+3sJNbYBelT2fQpiIx0haZ7OiDqvI5XNfu681tSA=;
	b=8dbAjp8Sn/DHPpAeVB8khtYLy3g6bq5zfhMcQygia4sHlQKZGgHJD/D/raasY8cNwf1y8g
	j8AXOK6+t6F4o5CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753284778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5pU+3sJNbYBelT2fQpiIx0haZ7OiDqvI5XNfu681tSA=;
	b=bTZryZDH15sOP7xNn+GQuGTjwFkOZe/X4I2nQeS8O36uTbCm/UN8tyBpYZgfbu0/cDV/zd
	xNVl2sunTnZUrR2a2BNcjJXboqleHE+3Ak34s8YhH4OVnZrav/QyZHXl1ofTb0W/zBc7mV
	9wCa5HvlWKB88Spu7pnuNWd42hsVsCs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753284778;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5pU+3sJNbYBelT2fQpiIx0haZ7OiDqvI5XNfu681tSA=;
	b=GKLkOVTuQQfRF48P8ffgXMzJkoCClBU7NGb7IX7XTtt/L2BQBi26Fl0yhE0hIHZj9Cgn5n
	VD3J9ZVLRAeWcVCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0CF1713302;
	Wed, 23 Jul 2025 15:32:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BSLIAqoAgWgQRwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 15:32:58 +0000
Message-ID: <7b8ec9ae-3eaf-4e66-b903-ba3c7f9a20be@suse.cz>
Date: Wed, 23 Jul 2025 17:32:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] MAINTAINERS: add MM MISC section, add missing files to
 MISC and CORE
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20250723095823.21940-1-lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250723095823.21940-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: BFD3E4000A
X-Rspamd-Server: rspam06
X-Stat-Signature: 6u5hojuwrxt8st3fxttgioj8owi8s9u5
X-HE-Tag: 1753284780-75715
X-HE-Meta: U2FsdGVkX1/azkDJp7f1czYD+m7GZ/gwod524T8TlJ+GrVbHpACJI3UF9CtgFVAng8EgutlYzkBX/j7CYtB3fRAPNJZw+OSLt/4ylPuyWaFX8t4vZirezAQWvrIus0xzuDCDKYiV2vqSveX8Fwd/2SZDdW8PdRTAhKYL5xVBtVdC7ns9IoqkvVc2Gkv9MWGQlt0OZvmzc/6FRzVLsqPqIaZJ1XlsfkKJqKqFUwZK1cmUxKZMnxzN1/cnLPu0bbUSn80UromogAbPt7rYpbuBxPtrnaaJBQYNzqcXQ0TllpD6V2KlzDvFRPZmYNco0gOE/JnJLwBoBbPJUWR04JTd6E5wXLkhU21ZlxscjKanXNncr/XG1v4y0my8tHSzGQZgEzJ0NmKj7t3M2TKu4Mf3UstMsCD1XzWzLvvt1Qcp9dTNC9gps4opVrPYzowsUFx9SkxNX0EiF44UUMG46S59sO3l8NtRTS7Ah+N6skJAZTvAsyB7p0NvIDPMDHsDht2bVds7eleaqb6lMKIjrAPjIY5TQ23ED5tmrRZBIynKGmkeoVCloSq4ZzpVHRoO6iLl6Kp4y6HQYqAs52EDWU3NOi6NctORv8jVYHIOS18CBF9V+uPadLmYNbVVjJRsPKj3KrAZUfZ4xzEHtRs0Zub0l7rq805slznE6ZaxhaDNYj5YQCloboKMTh8UxhYis62De17oBClb5Do83Dd2dZrv9Z3EMYsqZZCWMA1W+hFKDd0oVnINBGJRCxZ18V/TZoxFMnLz2O1GsEdDrpqEiin6yIegaJoOj1JYLWz/vexbx/EZL7eciJwQB8E2gvOr0jtKyxvp93L/ojXuxIN5uoMpdix3AY0qQ9BCd+dTPQlIOn5euy+Uk3rkpvpW8wCgGtPQINAyvvye300BPWPR5oFaeXDgGkHULqkicnlfHjxEdkXWsKgwLoRl8rDXZ2yCMQGXRv9U4DPxP0tyZ8zCRR+
 KY2wsB3t
 2q7X42eg7cmbRK4fELaprKwqIYiz3dtG+AFqjJu9F41rjRTAR3ObNiEwY+6wvGTenS4mpiC4W12jUEnp4yT4njEhssLG0dmINCRFkpNk9b5GSY1H/KJseCKa0CBqUSDcQzo1SqQ38jDADPGcK2r1e4LM4WZrtvGtoNYpkXm0DIRiY/Ghrj0799JKMIFN9S/UpUxyre2QAjsZJYD5erv4ztdIEmn5hdZS0VI90dc8a2+uM2dca3b+ePXrSbNYPm7ZkroAhH9DYGeGWEKIdhBt8gzlD/qZgaVdos6q3xzwQ+vMKDe9zMbj5lUP0gq9raCJYWWFqeo13WqohrCk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/25 11:58, Lorenzo Stoakes wrote:
> Add a MEMORY MANAGEMENT - MISC section to contain files that are not described
> by other sections, moving all but the catch-all mm/ and tools/mm/ from MEMORY
> MANAGEMENT to MEMORY MANAGEMENT - CORE and MEMORY MANAGEMENT - MISC as
> appropriate.
> 
> In both sections add remaining missing files. At this point, with the other
> recent MAINTAINERS changes, this should now mean that every memory
> management-related file has a section and assigned maintainers/reviewers.
> 
> Finally, we copy across the maintainers/reviewers from MEMORY MANAGEMENT -
> CORE to MEMORY MANAGEMENT - MISC, as it seems the two are sufficiently
> related for this to be sensible.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Vlastimil Babka <vbabka@suse.cZ>


