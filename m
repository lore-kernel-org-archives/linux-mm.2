Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE4DD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336EF6B00A8; Mon,  1 Dec 2025 16:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30EBA6B00B1; Mon,  1 Dec 2025 16:39:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FDA36B00B2; Mon,  1 Dec 2025 16:39:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD4C6B00A8
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:39:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA82658AF7
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:39:46 +0000 (UTC)
X-FDA: 84172219572.19.0F5553D
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id C8B97180007
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:39:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ac3J2lki;
	spf=pass (imf24.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764625184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZmRqhdDnonRvflYIO2SfgDWhvVya0E7TMh9w4AtTjQ=;
	b=vS/k3geyRaTmEyxSXzOc1S6awYp2ro+BYQgthnZbYjuiArF6CTDR3r5I5ASn0TF941FcUZ
	Mu7ouS1/nJ8dsMq6gR1t311gm15BjaKCdPlrsIIrJBAs82bNKoonEAHdrmt/KUzzQfS9UU
	lZKcRBWjKzQpDKLfyY/EtXKEdDC0Tc4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ac3J2lki;
	spf=pass (imf24.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764625184; a=rsa-sha256;
	cv=none;
	b=fN/geemh5bR7YeCFWVzT61/aouUMRLnHGoOP9xPBAs04/t3HX9c09boWsn+lpKcZNdVN1s
	6KAyOlKafAPmxFCLD+nUiDjybUVThyE9dNWg3r9izrcV8SHSekKeeyKL1yvbS6k8AaWAvM
	/T0npa1gCMgsJPmfgnDkWCIPRX4bWfE=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42e2d52c24dso1020372f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 13:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764625183; x=1765229983; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uZmRqhdDnonRvflYIO2SfgDWhvVya0E7TMh9w4AtTjQ=;
        b=Ac3J2lkiE2sQm8Gck5q5HmLCiCg9RO469h0jEQub8OjUb3cPAhqilmLpB0qD2i8uQ0
         9wKSK9f5EkyehpW+PzraU4PwPyxwwXeIQv4KODQ9H8ToQHriYPCBAwnoN2uTj2qSZMO7
         zNxm5Vmm2nNGEdCs8ub4jpKF8IftjFpSizPlFhHBnpHfuk923RwOCIV1rfdv39qrmlAi
         WOzncGPk5Y7YGgK+C/T/0LQ5ZcwUmsk7uQqnCIG3eu16a/WOBXpbhzBNj9lE7XkokVjI
         c8Yw5vvQL87G53p7b8Mhqqm/tnqBqY/P+/QNNeXbJj5mgVZC53ACCf2sxA/mYE35tn0o
         1hsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764625183; x=1765229983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uZmRqhdDnonRvflYIO2SfgDWhvVya0E7TMh9w4AtTjQ=;
        b=rOgSvj0TBMukUn5G44qF990QksgwtUdEccyt888Z/iP92a7Uq4qh0KabZ6OwZwK3VG
         DJ5fd4Asd8+jitapKRdR1YZr4uZHw2uTjvEenTvnfYp2rg7rADpsg0GXpabrXJPL8AT0
         ThSU+SLd3Mw9DZLPfsUo6Z4VFHXpHrZ2yxCc7KvTJ26Ntyx4ToF7VbxzNgvRhlkU4r2u
         /LJtjQ/PGvxg74KALPu+x8ioJp7W2Ww/U1HxPIZRlDhYlm1R0dv0jQkbQuEMe//o7ogx
         LhLoUrrSNuicBUKzjMzhUwu7h2RhA81kCXR/bUe/tbCgy2QHIp6CgLJ6/S065rm7ixyh
         vvcg==
X-Forwarded-Encrypted: i=1; AJvYcCUHmfoWRpLYqwuQjjajSxKyJfA1s84K/nKnkNN9FvdIW3ufMoY/G4m1TSGhtCLOW4IyfhOUIYcUbg==@kvack.org
X-Gm-Message-State: AOJu0Yz50JiuRb5nJB+Ercn9VrYHovEBdJZZKE/yfFVzQetLS6Y+I6k2
	KvYJR1SqddGyaM7kWLvQ0baW4fG03RLSQNMrIe/WUgtbNxNVOpfJ/fW3
X-Gm-Gg: ASbGncvnaWAjx1MT1jxiklbQe9tgj4Lcb9LMqo1DGyMf+QqNLqyMCnI3eQzvuBUiAMF
	1MKSgO9rHoSUFx7j7p3HYWL6jZSGqDQJQ7qAMZZAZIv/NWSzFWbTnVdZrmFk7a4j1YAJ8eV3QPL
	RRR6ky3PNicTJlB6p2jGk2I5Dqocym1uK308CV8vFfz9mYC7E51R3L998zsifapAkHrkvQKtNeW
	eOOHXPC0MPUqozGAQNkk3Hi5K/ylpxN6ODNVFDt6ZN1B90if0fKyQEJClzZkuQDeXMNAccHm47Z
	NtBui5TwbhI1aWiHMhJl7boHrF9fAKPFzRcL+WBqhxEfFRKJfOzQZ2IVPWs51yhqS7azaovuRTJ
	PQAXQVqSo8GQDXiyYiIPXIM3E6kiFaeDnPSFvKavAAMtU8WT6aGAK3gRDYkdrMQy4IDuR/HhW5u
	2OlGFSeZ7OJNoalZg+pAZ75pYg0RKbPmT1Dm89yleseKel9xqsuERL
X-Google-Smtp-Source: AGHT+IF0GP+pqaKG4PhgW/HWMVcgie4ld9+aoLno5OGZiyBWMEqef3f9IS+F+vZ3lhE/VUXuRC3tJA==
X-Received: by 2002:a05:6000:2c0b:b0:429:d0b8:3850 with SMTP id ffacd0b85a97d-42cc1d0cd26mr39852844f8f.48.1764625182679;
        Mon, 01 Dec 2025 13:39:42 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caae37esm28492546f8f.40.2025.12.01.13.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 13:39:42 -0800 (PST)
Date: Mon, 1 Dec 2025 21:39:38 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roberto Sassu <roberto.sassu@huaweicloud.com>, Bernd Edlinger
 <bernd.edlinger@hotmail.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
 Kees Cook <kees@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Will
 Drewry <wad@chromium.org>, Christian Brauner <brauner@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Serge
 Hallyn <serge@hallyn.com>, James Morris <jamorris@linux.microsoft.com>,
 Randy Dunlap <rdunlap@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Yafang Shao <laoar.shao@gmail.com>, Helge Deller
 <deller@gmx.de>, Adrian Reber <areber@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov
 <ast@kernel.org>, "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, tiozhang
 <tiozhang@didiglobal.com>, Luis Chamberlain <mcgrof@kernel.org>, "Paulo
 Alcantara (SUSE)" <pc@manguebit.com>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Frederic Weisbecker <frederic@kernel.org>,
 YueHaibing <yuehaibing@huawei.com>, Paul Moore <paul@paul-moore.com>,
 Aleksa Sarai <cyphar@cyphar.com>, Stefan Roesch <shr@devkernel.io>, Chao Yu
 <chao@kernel.org>, xu xin <xu.xin16@zte.com.cn>, Jeff Layton
 <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand
 <david@redhat.com>, Dave Chinner <dchinner@redhat.com>, Shuah Khan
 <shuah@kernel.org>, Elena Reshetova <elena.reshetova@intel.com>, David
 Windsor <dwindsor@gmail.com>, Mateusz Guzik <mjguzik@gmail.com>, Ard
 Biesheuvel <ardb@kernel.org>, "Joel Fernandes (Google)"
 <joel@joelfernandes.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Hans Liljestrand <ishkamiel@gmail.com>, Penglei Jiang
 <superman.xpt@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Adrian Ratiu <adrian.ratiu@collabora.com>, Ingo Molnar <mingo@kernel.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>, Cyrill Gorcunov
 <gorcunov@gmail.com>, Eric Dumazet <edumazet@google.com>,
 zohar@linux.ibm.com, linux-integrity@vger.kernel.org, Ryan Lee
 <ryan.lee@canonical.com>, apparmor <apparmor@lists.ubuntu.com>
Subject: Re: Are setuid shell scripts safe? (Implied by
 security_bprm_creds_for_exec)
Message-ID: <20251201213938.184d71db@pumpkin>
In-Reply-To: <87ms42rq3t.fsf@email.froward.int.ebiederm.org>
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
	<AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
	<87tsyozqdu.fsf@email.froward.int.ebiederm.org>
	<87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
	<87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org>
	<6dc556a0a93c18fffec71322bf97441c74b3134e.camel@huaweicloud.com>
	<87v7iqtcev.fsf_-_@email.froward.int.ebiederm.org>
	<dca0f01500f9d6705dccf3b3ef616468b1f53f57.camel@huaweicloud.com>
	<87ms42rq3t.fsf@email.froward.int.ebiederm.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C8B97180007
X-Stat-Signature: zgawypd1hm63edjfu5yqrmibu6oingm8
X-Rspam-User: 
X-HE-Tag: 1764625184-37174
X-HE-Meta: U2FsdGVkX1/oaR9axHmedxD4khNjxO86VdEWFbT/CLMGfBFG2oRQ2cFqjXwYer/jUxwgImmDohyamUPPmxWmvjn7bi/TaLjQW4QjjuDhErmMDAyPGVaq3L+nK6hGTwtvn02KCfJR+Wh8d5DEdPOjK9P+fcsTl8LXYhjC+YvRrOIuA8UmSPq3f6iHHVOcp4AAMD7GQdsK1tNUB5hmgYWqWFQ5pZ4RsdXXKpij6V5Gd1u5h5yi+RyyGHWacYMwFwpZWKhfMonH3zNRpGdePmPDRGXNIyJvkYy3Uf12JbUN31mMSJFMC0tMqBuTBV+lsYmW3kwR4AcC7J9KJDDpwECfFXtXHYBcvxL7Ww6hNKWjg7HvokAhxPwho995bCJM2eHwl/95wynnEY4iRoGXULKiEH5wX42dmfVTsMNoOHQhSu6gJRUucTaSGBN1T6RmXiJYzSq7TsLCc6M/JApNDZDT4pgmvn7fo6QB5xUz9tpIs4IzzIKjg+6OJLEl2TU5MP1lcZ9+dzg/T2BpEX5HzFrAE8sg3kHT2eyUUMMAkw0yiudqMs1Mu0bnGih2M6za2N59/V22E10KTg781wfOSCjz+31n7mkLeWPMPpeNI57qYVkmGWHKwa2Z4h/C3PrjakxfsLv+2xlokmPbt93uhoTiTB9HT8U3JR5xN/Kjar0MvBTUh/EvcYAqHVcf/wYZFn2qw0KhK0KGl7YrS7zm2l5JIBsa4Px/1w/qWEu2akZIil1EJ32N/xjom1+2nU89I74ah5rWABxD8u8KnIPv7jVvM23/sufEpBmPAE0jBhQR7i9ettiD5ueB1swFoGnrPNlM5GOXDehlNMZ3knsu4yemjVAy+8HOqjkgn0fhdSWaPLPwKoZjziQKA4jkqp8hxwyTEQa/v645+WJo0c2jELu+S8gneNfGRCf0/qNYB3ud7lZezRhZehuofbVhvBlOsMeelws0xpWi7LXyvoksSCM
 wwddePay
 Q5o2wzFiXrShLEhzdkzetDPpIAYuO9Q4S0QbcXMf55zAfaBLCzg1uikU9nivgI0dssFMobmWZbPhTPWChFzJ+klBdEFQwvDyOLPmROJvQXAl7Mq86sQ7bNq1vm2egPzhjrlN8lqVsxTaj0bpoMNMWygZadOUrFlVLQsNimRyWWGX+hBUvj+1BXd2WDL69jdDnYwRS1ISjofYDMaYgrZjXsd9ZR/T17LT5dhdojn1+mJZnnzn2M2cA3WUGJOEMRhuKaiE2h1tN1+/Zz+ieA/rd9XKKMxGwQho/Ecfu79CIlDVik/sc/KaV/WLXzEpYeuPLYjLJcJNG0R2GDlLo48XSb+5CnurnxAhsbRfJ+gDQuLtXMmQPyIfnsd7i2dwzS5/vGqaZY4LE5tOW25X3+EtB1hcMbbvd4tSCFkOOT61LAP+JCL0RIiYedD2r4HDzKjEF0J0skrWe3lzLg2X+x6OrXauyEkOyWhOqKExEfKQqsFVTwgFgBICzLFEJrBrA2gMFJkV2+pqf/jXVyH6OL90QZefFBfcVWhgGaINWx1p12o08sQKNgVZ4BbTXNZX8n52m9Eux2650ubJweNQ7sQvVy9/Ylpa+qErsLSHWKwpevRG89VMECSgofEl80QqIeZCVqVNgtqNSwzBOdx4ajF2vtZxkmbzwevPMPM5ie94K6uW/5zONifgYmv5Km/yrcwEnCxDwr+UdCb3u0EY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 01 Dec 2025 12:53:10 -0600
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> Roberto Sassu <roberto.sassu@huaweicloud.com> writes:
...
> There is the partial solution of passing /dev/fd instead of passing the
> name of the script.  I suspect that would break things.  I don't
> remember why that was never adopted.

I thought that was what was done - and stopped the problem of a user
flipping a symlink between a suid script and one the user had written.

It has only ever been done for suid scripts when the uid actually changes.
Which makes it possible to set the permissions so that owner can't
run the script!
(The kernel only needs 'x' access, the shell needs 'r' access, so with 'x+s'
the owner can't execute the script but everyone else can.)

There is a much older problem that probably only affected the original 1970s
'sh' (not even the SVSV/Sunos version) that quoted redirects on the command
line would get actioned when the parameter was substituted - which I think
means the original 'sh' did post-substitution syntax analysis (the same
as cmd.exe still does).
That doesn't affect any shells used since the early 1980s.

	David

