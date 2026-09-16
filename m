Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 367ECC982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 20:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1936B0088; Wed, 16 Sep 2026 16:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA416B008C; Wed, 16 Sep 2026 16:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20276B0092; Wed, 16 Sep 2026 16:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D75396B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:03:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2629E1C01BB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:03:15 +0000 (UTC)
X-FDA: 85220699550.09.978F231
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2881C100007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:03:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=blk2F85Q;
	spf=pass (imf14.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789588993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cm7PqqNIPClVmPDMmUp9xjOnmThb9Anvlth6X9ui2WI=;
	b=ywnph4RUl+UFsXFJe1Bcg+s9Ih/IZoqdwNqAAiZuKKOKA90Uz63uTaLbRvhPT9zaWYhhO3
	+5BYT+UwrC1bBdnSWCnJ0VtcHdIPLjULMWOzSJvH7UYQogCCyqhIB8cjPbIppk+2Dn6xMh
	Ov4cyclKlHxmpcw1TnL0uJev6XiPwGg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789588993;
	b=o7N2YamB7LvFp9D8PKctRKlolrGGl/ty0SQVw39nQ52gvORoozkM/arVoO9DVZyq/VgxlR
	KJACSF5Vr8cseDqdH1zk0vwbL5lrYDZpa2d96a3Wfy2X5+smYAv7RiFMGm6+GEnHWnME3W
	itWi8PPhlIUO0V5NI3A+mj4mPm2sHrA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=blk2F85Q;
	spf=pass (imf14.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9D9B340E022C;
	Wed, 16 Sep 2026 20:03:09 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id RmiEDj15sgaS; Wed, 16 Sep 2026 20:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789588982; bh=tt4wGiGWSGVWCHbdak83aGerpHRJn8vrvoGhdde9P2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=blk2F85QFszaob+Y1xO6ahKBOS2FgDvoEvkATB/sVUDpf1rkDZvEkxvnXIYfMx9DK
	 rj092M8OcL76s0/QHurHv3WifWK7tiMADyWig8Kj1NUtCiIAlMRj1f6MGiTYP/QL8+
	 s9iVQpUP4Xh+1n6J6fyqiK5jxNpPtU4tgeRjKVj5RVzkCREqlmgv3TQRa2BQbfSdB9
	 XWBem+1JKnnNlDzKBNC26wfv9FtanTuqDcR/5kJPQXTnAzJHKD9C82mGx6l8WXrjMF
	 nTUTaOfEgL+DhJn5Bar5CezMf4zzXUJ0yRKIVTm2CDsc4IdI2VQ/wPHAr3+kr+9B8u
	 G0IVD6BIegxGt/gbLEifGe91mzFdC0nN0DAb/w3Zwlo24prvNav3a8dh+UzfQYZpWD
	 Y84NxQfJ5K12Wx6uG1tAx7v55XnPyFw63HKRAScwteodUibkfDjTmukB9EDROcYIsr
	 hO2W9VFW509dBSlfBL5mVyt/eBB6sH4S/diucCUK3sUbZ63cgDM1xu/LAmb4x6mLp8
	 +TsVQO/hcF1HP0C69Jh1aykMcLWFqyLVoAuNNjaskXC9B2DPOKY/JsEAThY2Ap/8M9
	 9ZmnGuO1Wv9KWdxZbpVkzHpPD2QGUEqkdkHhtCCF44+Q3PqVemUqWcQnbRjpYzkGYW
	 i93Um7YzT0iEcrpcjnnY7ys8=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 23C6340E015B;
	Wed, 16 Sep 2026 20:02:49 +0000 (UTC)
Date: Wed, 16 Sep 2026 13:02:47 -0700
From: Borislav Petkov <bp@alien8.de>
To: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>
Cc: Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: don't apply va_align to hugetlb mappings on AMD
 F15h
Message-ID: <20260916200247.GFaqr15333nu5IAfjU@fat_crate.local>
References: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
 <3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.com>
 <20260829174704.GAapMbGAZMwImcvIN7@fat_crate.local>
 <0B48BE2C-2E72-4961-91D9-35E215F537A9@quelquesmots.fr>
 <20260829185120.GBapMqKFM35KtL0Mod@fat_crate.local>
 <78225f07785ed89e0c3e5def8a8bb1a48e444322.camel@quelquesmots.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <78225f07785ed89e0c3e5def8a8bb1a48e444322.camel@quelquesmots.fr>
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: n5ntjsrk1rtpoftcgmnjwbnckwgp7qtw
X-Rspam-User: 
X-Rspamd-Queue-Id: 2881C100007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789588993-716085
X-HE-Meta: U2FsdGVkX1+VS4lWXIsh9RLt/jNBB3ukXzP5gd3rL0r5Mol6gdLybqwDpg/QzxNYVPbPjZl+pz2IEAcvPDMXyZ7gtwBkiGgZe8WWXan/+S7NGEVnKYcVFu1ahx5bkfBsQ68uISJT4yVGedlf135tazXoj4xLh37WzheTEGcZ5itnBqj7DAPEBQ3nifzUdVXoh1mdN4CCbfyxjVBfWX4LdqokEcA5mZUW2G0DzfE3kfxZpCXnToV728v7LD3/gR2sYIMJbL048sFPxG1ayAPcQkmLszSDJ4Q3L5Pr//RkB7R5BRKGZvGKoTa9mpYhkVnFdqqhLBG5yygTLc0tB+5sZRTQTEf5Jsd/+Pse+EfxONxpW8Z95pw/nrny2FT1qDJIkzw2JFlDH3jyayHnxnrl2Tmay0I3HZPsuiZBfTuu1JxlxIigv7sj7dd9GV/XBoFF7nH9nlXXZR/HZ/m7Sn743nQU0jHVkEwRdUFMQHxD2b3F18fsHNv+3FjIoP1rDcmphoeWP7HHbTJCfAlAmayzC6yWd/mZJwDaitVRfdLLAE9dezjOyEljaxM+rh6lUGAoafDFlZ40QXqBtpryuZfCGeIqyU0T19qTD6vAEKyQ8alsr/ckVYkcbu8mJXv9G/rS+/tr+0353MjMgN4AFdKEw0AqSNX4l5SwxhNjnRlwteApqdYUaEpYqczIvUQuMxbbZbqBhaR3CKpd+g+njh5sTcK6wSkTZLrIkAXS/ydjbAi78FQrri5ZLVPoBwG+0K/yJ5CCS2QjhoycRxoiI2ybLc33scm4mJcpn0XnxJMlvGuOaAr0Di57QhySeN3QQgmAiJ0XwHNEmLjtEGsDLW1ZZZd5t+SaideHUMLalmScKVMb4IsM2slAWSIMhV1P/9LhW7zV556MNc7f+WOoy540jImlf3YS60Z+3c1H8uVusp24UoP2E57d16jJv6/A/P3ri2tQd9DPiiAsCbztBQM
 u+6BcfAF
 bwwQeZVKNYQRh7vVEEPoAjOgvtPmR3YXqXpPWGw6PLMULFaB7dNP8lzQVUo77Jdj3v/PPkI1GTp7Xjwjd9GhPMQilh+jU0j7UTrXhG9Si3c9r/Eo+u8qBfwt/Zp3G6zC1by9dCIE/QxMO3r8eTWcowHYWE+bT5NT3iih5OYyRGrxnAlrQTWcIoDeeDXDrbCwHVXa1WUMAj99esmxaYUUfYfttOfFqkCMZ6eE34l+SGpJOBT5/Fq0TgwOfjVgGtYkVbnwrb08oNmIPLy0PmJzJDlhdBvl8tWmCvPsdACJOaz03lh6so0Svrddt6Hz19A0/ZpVCSrbr/8sMoMRZgPxwxhAPZfcfakj/GhjRt84hTEZ/Wg3GrKHt8APipqt5Z+f7SDVdZpW8sO4Mi6ULoLi2b+dY6ZendlySKp3chWvYI6saTEI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 10:12:07AM +0200, Laurent Wandrebeck wrote:
> Sorry about, replied from my phone without thinking about it.

No worries.

> FYI, patched kernel has run a couple more days without any problem, and
> I=E2=80=99m now running 7.3-rc1 with the same patch flawlessly.

...
=20
> Can I do anything else ?

Does Dave's suggestion work too?

https://lore.kernel.org/all/3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.co=
m/

Thx.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

