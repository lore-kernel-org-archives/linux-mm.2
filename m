Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20039CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 14:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66F1F8E000C; Thu,  2 Oct 2025 10:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647318E0002; Thu,  2 Oct 2025 10:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536C68E000C; Thu,  2 Oct 2025 10:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6F18E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 10:39:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D10D2C04EE
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 14:39:31 +0000 (UTC)
X-FDA: 83953432542.05.57789F9
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id F23E316000C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 14:39:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=floxxIxr;
	spf=pass (imf08.hostedemail.com: domain of 3oI7eaAgKCIUsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3oI7eaAgKCIUsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759415970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXmRPiiy/jxXhEQ2QANIVQqqqCVGSfAH9NdCa3WEjBc=;
	b=v/7rYuCtyhCe5mnyULzNZA7E0gSuOer5pVlOkKIJi9whUc0wUqyMWZwGkzXxNyXqwSkgWM
	OXnDs0zzyxM4pnqzXTduJUvVxR7oRPXGTkW4L0WZ4AldP//xtCbTbHONcWHo5/WU1RoE++
	h424dzvU3nbyfKVpDn3UJCfdvW8nFpM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=floxxIxr;
	spf=pass (imf08.hostedemail.com: domain of 3oI7eaAgKCIUsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3oI7eaAgKCIUsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759415970; a=rsa-sha256;
	cv=none;
	b=8bNiYT4rJDyVPkXHO2VOZDYmnQlVPNUXzFTYL/d1HlnGVeATQZEoNtUJVoqr8oquc+pU8m
	Mgi+DUNl2RBtuSkFTJqKQIY3A8N8cwsv/2L70QG1Njt3Nj3fT4+0ctpj9+PvXVXmfJe8MP
	wgafPMRuzCyGHcGlGzUiXEetdd1GoiI=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-afcb72a8816so100851966b.0
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 07:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759415968; x=1760020768; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OXmRPiiy/jxXhEQ2QANIVQqqqCVGSfAH9NdCa3WEjBc=;
        b=floxxIxrR0FDzCvEZXUBDcEJcQq3GdrzafFmO3/84ADA5uRzKbhpHt9KIpXBAHvw8Q
         Pl6/YtVQabVXnDkHdQ7DnvAKM1Y1Nr6uNqJNBoGZNpaNsrhAA/mY2LXF8ZSbUeXEAXKy
         AZqnlXnMgcQYj7I6W7NllM6muoAgY7432Fpb5RvVQcit/CKupyAntQYbNYb3j1uU7YC4
         vjFQSaUCP/Osg42lucIWfZ8dSvRZHSc0yGWLrlu0Iok3dZ9q/UnGFey56KiZNT9JPPex
         O7rZdRtT6AUwrxO8khiOKV9fjtLRUwOonpV0pCjQLxC6CCZ4vnQzlHPDZHQR4SRwx92C
         ljIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759415968; x=1760020768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OXmRPiiy/jxXhEQ2QANIVQqqqCVGSfAH9NdCa3WEjBc=;
        b=Wd3JXChejhGbgePoW3kXr5d47cDxfsBi4l3crECY0MzyfN5E8BOe7AiDQKHECv1Ito
         V6M5EJclkKj9CqY7BDxQRT6GJ/hEFji/7dy2LMKw9PkyG0w2vHKDU0t4y9vD5U0xPhYQ
         5VBDwJFDd0AYdUzIqZOIRCvbYEQmtgOHdwdOz+WOEFCZgck9gndkAfLBQ5edQpNhW0cd
         pcYg0qwZRUHMjOGLmLuyeTwB2VfYKEdmPC16rdjBEN1L1yQxmdqehoHYeM0D1PqMOLPW
         qQ5zMCWxk/7JdHK1kyMWUprYgp/Y1vf5b12mAUzN16OWkRPp/k3ARWQQxFGyje4fB7ja
         CrrA==
X-Forwarded-Encrypted: i=1; AJvYcCUEK5R4ox+HLqArRDZ4OJPORTXeryCHpWTyejVgyW3K2BYL3LS9KbUzVcOo8ciqV+ajvzeAR4vi0w==@kvack.org
X-Gm-Message-State: AOJu0Yz6m+4X8Q74M5gIp6PWSxpeIRtX6gVdUQbB+4V4E2TUY2kEQxiY
	qJ4HJxxg9OVWb4UT9Bvy+WLSDSru9lAPzDtVLSS36Xmk9oaNgfoa8lvLBRbY9He6bOEe/M61No7
	2WAFDoU5jwC2+Aw==
X-Google-Smtp-Source: AGHT+IFnRkf9ot3Skun0op0G7EM1gEJs7lrJQJnh2eFwDF5s4NKmeG9rSXFP7Ix3NYG+PqPTDK5hgURKWHPSPw==
X-Received: from ejbo22.prod.google.com ([2002:a17:906:3596:b0:b3a:79ae:c785])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d43:b0:b3e:babd:f263 with SMTP id a640c23a62f3a-b46e4b8ec24mr986902266b.3.1759415968473;
 Thu, 02 Oct 2025 07:39:28 -0700 (PDT)
Date: Thu, 02 Oct 2025 14:39:27 +0000
In-Reply-To: <caee3410-a01b-4e40-9f0c-ff7810caf323@intel.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-11-2d861768041f@google.com> <caee3410-a01b-4e40-9f0c-ff7810caf323@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DD7WWPE3YSPZ.1E51AQNHNEU2G@google.com>
Subject: Re: [PATCH 11/21] mm: introduce freetype_t
From: Brendan Jackman <jackmanb@google.com>
To: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: <peterz@infradead.org>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<mingo@redhat.com>, <tglx@linutronix.de>, <akpm@linux-foundation.org>, 
	<david@redhat.com>, <derkling@google.com>, <junaids@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <reijiw@google.com>, 
	<rientjes@google.com>, <rppt@kernel.org>, <vbabka@suse.cz>, <x86@kernel.org>, 
	<yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: rgum5nhtxas3gez3igiew76xw1i1dkak
X-Rspam-User: 
X-Rspamd-Queue-Id: F23E316000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1759415969-620974
X-HE-Meta: U2FsdGVkX1/GpU4mI0Sd4lxpCEIAO5i2jmYXiG5YKT2FPP99d6XwcOiq1CWYs3IJfaVBNm2twHzkUcnDxG1lpKhwXs8N7heR7lqaSjKonaqH/EH8lpPb0Bx2GAZeODu2ogYH1TpkLx9pGjCnJV2oMDitiiBYTD6RaGz/fGA8SNiC3P0fBej39nNb5+fAli3nrGeX5bNgydjMTygmt7kbcS30vjSruIagQLCqgNuf07EpG01STbaOVSrUPGSrU4416b185r2QdTzv2W3+2GiFSXRTSOlvzSiehHJoXbHmITwLaB5bXa/uouSBeCPF4CH4cE2lZ4LcKE3erzMjr2TebmYMnyYPrmvpn/wfRU97QEsSeVkG6gQBB/CEFJoMeX5ineMiJjyXdvYMrTveVUyLvPRFW5sPqZ1K0m5dH2lE3lZLU+HV+OrazkCROv/R/v8SNZEzc4jFSHV+cmNfZqJ6B2wgFM0yvs0YQXjFCXXW6cPCBMH3AoVcOKafInSBgQ0s/Ku44BUXM58gQmCYu/zl79QykOFu41TR0J36CO0mg5qbkawzCKEWwqwkwfjQctY5yN086slFhPY5gH7s9H5Q8jJL7ImhH8aJQn40jdvAhXtoY1ohWDoCf8O3BpxCWPAjj9gMc+XPDapDgx4BufThFbHlZSBbxsORaamvvj7rcG/nvSJ1MvHMIUo8haCTRCoTrqI97KBbsJqXMDdSFUOzTVLWdXAhwvbnDkAlO9vCbCLLg4CkWxn2atvQlDfyx0d43A2mldSptbnUNvLBAZZW3Dw2aIPcJATYSpAuH/oYXIFTQfLxHZGGuIUg+cURBHkwzGQREQ+YUe3TyQc6wVwvpSQ4Nd/6Cj22Tge+hmBB1vQ8SqZYitAvSmdiDfnUDNVvaoKUBf+gP1K0S09nI9nQMdrY28l2je+m276KYq9draHb0wLOgEkPbyy38Y97X2p+3qy3j/qz5v+htbsWxdU
 XLc/HKwH
 7mSfuHuNl/ft2m+PQk3lXqLX6+ls9UFR6PR1tal+jbpWI84NkKZPATXAGlx0oVhoBEephI/Qhxm8/Q+Ce1ESZZIx9xKb6S7CPKOVN6sLU/YUVhOxvQTEds4/L94/U5As081X85YAsMUtvoWG1xtEQALwX8DCyPrzRLqpkQIghCONOZ8+lAITV+ByhACyUj5TQ+oOz1A//HLeQDSZrZI6IiNSkLIpEj8WZ1EuKYbNybqdLeH3D6coLKELwVL9Znm0tsBc6o39fqV5AEs1Vsb/xWCZ3tEz9e+rRiMbxFY/m91y+9dFoBE1i0fdU6zVDHdlq4SFzlwZd3TO4eSxI1nL8/eVdset3rgfEPpUsxLnSCunJHPPVeCcy7GDzlJJMPOLFU6AwZVHFUb/Pnp5p7DiZ9wjvUc4WIqXTULd1kJAJejD6g74NVTVZLozN6NlgNSHB6LgJ3tQecTk31aqsRvjpbEbGTW/Oci15Vp/2keXOLDw0XlqouupeTPFz/3HpEBo7ubj0lHpEluhSqgvGfmioC/kAMh4DamWZZbf3ie5YTeGL/uJHeTUyi0ibgbPnRAhGYN9KpTfMlH4pDO4La194PC/3012ALgVQmHeQVGfuZJ5+vgfBvsv0GVkQTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Oct 1, 2025 at 9:20 PM UTC, Dave Hansen wrote:
> On 9/24/25 07:59, Brendan Jackman wrote:
>> @@ -2234,7 +2235,7 @@ static bool should_proactive_compact_node(pg_data_t *pgdat)
>>  static enum compact_result __compact_finished(struct compact_control *cc)
>>  {
>>  	unsigned int order;
>> -	const int migratetype = cc->migratetype;
>> +	const freetype_t freetype = cc->freetype;
>
> Just as I'm scanning this series at a high level, this patch looks too
> big to me. There is too much mixing of mechanical changes like this
> s/int/freetype_t/ and s/migratetype/freetype/ with new functionality.
>
> I'd be looking for ways to split this up a lot more.

Ack. One avenue I didn't fully explore would be to break it into:

1. Introduce freetype_t as nothing else than an annoying wrapper around
   migratetype.

2. Add the sensitive field when ASI is compiled in. 

The reason I shied away from this, is that part 1 will look kinda weird,
because in some place I'll be switching the code to freetype while
others will still use migratetype (code that will never care about
sensitivity), and the distinction might not be obvious without first
reading part 2. I'll just have to try and write a good commit message I
suppose.

