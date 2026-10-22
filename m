Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43ACE606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eO6XFW7T
Received: by kanga.kvack.org (Postfix)
	id 14F836B028A; Wed, 21 Oct 2026 22:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100476B083E; Wed, 21 Oct 2026 22:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31156B083F; Wed, 21 Oct 2026 22:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8A0E6B028A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:18:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C642A40740
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:18:41 +0000 (UTC)
X-FDA: 85348653642.02.926A476
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 014E3140003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:18:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eO6XFW7T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792635520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVLKVn5aYrORuK3mJHdyAM2K05yQ1I4f1Gd2eeFrBFc=;
	b=GZWlF9g3yw4oczkF31hfMk5Es1GrO29itYC4uVCRYo2H65D6L/53IQd0yu/lXqOFqf2LNh
	xV/Sy6MtbvxORQcKywJLBVUNUqBNycxSIVkKvobeGXqYbGjE20iEL0HS8n1A4T/SVF1Lr9
	bgtubkGrBOLn1yF4sB2+5//i+wJ7n7Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eO6XFW7T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792635520;
	b=LXt/XqqH1lw270eTwVOyjZDRx09P1DPw4i2Z/f5iIwxsJRVTBjo8ttU212ayYFXLjUfYtv
	O6rR+ekFrTBHVSMPUMRTwsi/jr1YN46MXIYCIzorBg2snAGolMoQ1fsi/t3TV7ZbMIpqUt
	0jkYM38ZREOoCh6nZq6QO5mwqmppIcY=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3514b90bb89so3733935eec.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792635519; x=1793240319; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YVLKVn5aYrORuK3mJHdyAM2K05yQ1I4f1Gd2eeFrBFc=;
        b=eO6XFW7TcaTdHCnXhfw9Tm3jPqT6LinjPTNeROg2IW9vgPZqBfLrMz8H++CsjYny6i
         CKzg1ZVrNybvaUKTOWcxpGOqjDA1zsHkNd+OsjWdwg3HUb6vp/+dKhmzbpCXv8T9xQVD
         dFlMHB2KEYu/VEaiV1ACohYk6ejJeqY7KleNRMmtsdMpSrZwkhLeqUtkeIncB7vTAYjP
         rKwXKx6KGojU1+LDa7IDrzZ/kYnxrnRMASCT5FvaUqHYJNQ5/ebyIUbcIGI1wMIlAckm
         cmQxvJEVfsbuhHBilYwkCOkSj1w6S2cb/zfsolbzbN+A8lVzNcdY0JlNNY0Os3Exyb4k
         Sebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792635519; x=1793240319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YVLKVn5aYrORuK3mJHdyAM2K05yQ1I4f1Gd2eeFrBFc=;
        b=ymIRWGXjlJsH6gXNpRi4NCYMPGPnQWpJw+OCAZKwopLt/urtKjq+YgMal0vPuqzQwG
         O34sIWxGhKX49kNG/KgqmqbgTwyeNHp+7EMEzlWYN5YgfnJUxZ2OFEMm1UzghDZ2XzSY
         iDDi0wNqz7lgEN+GoJ6bNidHSS3hRaCspybba3PYz0rzSkyukTD5Zu+sHYF5GYlwLxMn
         WII+74LPUJJIORgzspWHBXJP9/tS8RujSR8R03Xi3o4gHfO14Y19oEV+90ta8EIQ33ZQ
         OXOt1J2EFNPTE//NQSmcz5VF+BGpthhuxB9oyl2qUKOdf3E+ziPcoBkPiPxzJyxPq1K4
         EBLQ==
X-Forwarded-Encrypted: i=1; AKwUvBy4fk0tSmegRCFug+Tm0JpVchhinLeVHq3L8HTRvif7LYRFKCL0amciGin96+GneNp7Mmm8VBEMNw==@kvack.org
X-Gm-Message-State: AFq9FYLoe67HB/pI4aHVXPnLEDhPzYf9G2kUIfb3Oivr87EFFTvKrohx
	WFRoUqIJM6+mlKvwPzK2Qkoc/8nJAvagoFVW7A+QjZyMgP/6e/0F3adx
X-Gm-Gg: AYBFou0BF2EAFL7Ka8W7YGaSjWINijL3O2l4z7ChjA2I1yqpZwT64gm1jqF9DZ0lGvo
	AX0QZHIxE80V+1vwnTopBnnNoYeAma31YfrfBEm3JX/suAa2U8hXjSoUUHVRXHztVIEyGsfKM3T
	hsLoqUBYVfdBZPsIYk9hRFMNMxqgFldKlHnuyx672PuEDxM7gl/uiccaJdIzovbD0oXzD6NCB/q
	PHt7SYNmXoiemdgVl11oDgeC4tiZrW6wmvSTHdL8EDhVwZoL2bDTIuHqhn36GdTu6IdGNZWEyfO
	j3bElPw6w9s+n5C3GtJuOuwebWSTLvpvJ/D7+zdGHY+wTJ9V/EdQDO75YiaeRgFuvqNNtnZ9Def
	k8KGTiQrq32t01EF62TOq2tTMBGjQtAMYbK4W+MY6AO00Pf462k9i7Fch8iH8fyMSrT5nteqD+1
	x01JsTGdXqutYvRW3CHEE3CB3J8kg3p0hC0VYvSADB6RfLvkcJ1REqgCWP4CcEVxB5XmxiAocwg
	xUOBVPEFMOnBb0P41HPgD+m9Nt3bSVeVSd1Y6DjVXkDPBk=
X-Received: by 2002:a05:7301:618e:20b0:35e:2c6:d46c with SMTP id 5a478bee46e88-3674c63d579mr5523810eec.10.1792635518735;
        Wed, 21 Oct 2026 19:18:38 -0700 (PDT)
Received: from ubuntu.. ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-368b4b8e9c6sm3556805eec.1.2026.10.21.19.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:18:38 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shuah Khan <shuah@kernel.org>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.infradead.org,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Peter Collingbourne <peter@pcc.me.uk>
Subject: Re: [PATCH 1/2] word-at-a-time: check the first byte in load_unaligned_zeropad()
Date: Thu, 22 Oct 2026 10:18:20 +0800
Message-ID: <20261022021820.1789083-1-odys.yuan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAPAsAGyrH1quaLuyui6Qm5sokid8=yjNbAM3cOunynfPNQtfgg@mail.gmail.com>
References: <20261019-bug-word-at-a-time-zeropad-kasan-v1-0-f21a3ed6a477@gmail.com> <20261019-bug-word-at-a-time-zeropad-kasan-v1-1-f21a3ed6a477@gmail.com> <CAPAsAGyrH1quaLuyui6Qm5sokid8=yjNbAM3cOunynfPNQtfgg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 014E3140003
X-Stat-Signature: p8m6fxthww4qsk54m74rehba7ig4g7ka
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792635519-124747
X-HE-Meta: U2FsdGVkX1+5G+fEFKpc73JA92okIWDn6G7y+F7imUA5evp+KoOBEOJzsu8UIIfgfhEe6jXRnBrKliYkXJbwjRlYTYoT1zctr0HyU36ZcDr1QU5zGNXNUgDZjyEQi6ahJRA1L8HNrBZA+YPQGwsz5zbKoHW4vi75Ncb5etJp6u3R6ho1R3I/z5KM/1gnH/vHqrDo46sNm+P7UZzL4ngiW93SOft/BaF7t1V0ctJJQHuU/mm3IYTlILZ/fkwkHysRPmg3W9EYVJWQ40Ncc0R/U9NNhgRtTACa8pnvtw7K/GQuMjkeqYykByKZoykQaum4DPhuUmiG88/h9uskdAF7VPtGvpCNIcbT30BXQz4WkeFlDB5pU27IUd/dMFO7TsE74pxaD/TLwX1Vdbz3RHR1oBAMAWYECW7M3MwQEYt/4PCZJTgjn/MauECOGW+me4uCg4TyrUvXZ3McUiDpCoWBh/S5bfCRjGnOYXbVVqpbEZUll183k7sG+t1+C62WM81gzDOYur8v1AY3V2jTQ8PYQiOFicisdtp+ab9codiDydFlgcFRhvoxkpE7cDwok8pEHd5Y//EDJO0MzaCoKR9HFv7wfeiB0GmHq+PfMz53kBg3FS8fyTAIrFm7osvTt2fx8zzqKIqF8liCKBoN1oncwnvox0rK8zhQI4ErHfvm3CSmHpJ+WwJbtL6U60mwHCOH9jjN6guvAMGMXlrUZ2YHBDn0DWKO7Ec9oHpBiprPrgg2jfyBi1YBgyfdSNApHch4FE2i3Vpbwk1vqN5oTCcZh4ouD8t2hdTW27kuPSLqyJ1/g0Kra3/tcToIwEQ2/aW7HYT/rRRSwjdHRLeBo4VVxgrEv7IJOxGhuscmAJDG5sWO13ylgg1MpkZqZ75BkUzn+20Bwp3Qvh9ck4NtCIWfYU6gg65WFDI4P8CRGmZJmxT528uMTdJfKpnU7D+ETP5O7FuC3LXV1p27Yh6F6yV
 jNbw6+J4
 wWjG94fph38+0FlgSC39FFTX8Y3x2uUb/hHiYC6X9yrlVTv3EolhNkLCwS+ySYHU0UbwRdj9CAfbW9T5evCaL071A1Kqm+3XnMeUtWoJr/jSkHenC1x7EIolX0XFTSVxVEmS+eRaVs5HJMeSNEZouUXIIT7EZnXwIBS3DP9risfZxONULTCXnLGQ1C04MR4Gf32DHDvqaJLeqVhlokwBJlhrvmsPD5qYFcy/gmePJrPTS69UpXTMD9ssS3+Fj0mwKmzboebNadygiYUtV6BOLYtDdXZzJvqjw7kj0V6FpDyTdfgQJdmUrxdGde+X8yiWnSBTmmqspDWC91VttTgHyXKwfvDqSmWn3Yg5Bs/3rXPIy9fJl0N0cwM9E/SZ3PZSl1daaHLiIMueHYqFUQgcrhTrsJ0A4ix1yjjzQAv3oC4OAVWudMWiL2mRtsOvP0jfaRAM/WWXE4wWH3TqJQp1/yNGJGcjdwX4Ok76uufNPJXTypG1h6BcUIvU30J9Lk/7ye+2HwyuFrBPQ40hY1uU4DMUabQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 12:58:54 -0400, Andrey Ryabinin wrote:
>> +	/* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
>
> Why it's open-coded ?

For the same reason as read_word_at_a_time(): commit ece69af2ede1
("rwonce: handle KCSAN like KASAN in read_word_at_a_time()") open-coded
it "to avoid having to pull the entire instrumented.h header into
rwonce.h". I kept the six asm/word-at-a-time.h headers to the same two
small headers, kasan-checks.h and kcsan-checks.h, rather than pulling in
instrumented.h with linux/bug.h and kmsan-checks.h.

Thanks,
Qiliang

