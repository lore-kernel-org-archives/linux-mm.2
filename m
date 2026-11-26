Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87410606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UtsNJXH5
Received: by kanga.kvack.org (Postfix)
	id B07AF6B05B9; Thu, 26 Nov 2026 06:15:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADEFA6B05BA; Thu, 26 Nov 2026 06:15:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6556B05BB; Thu, 26 Nov 2026 06:15:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 750FB6B05B9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:15:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CAE21A03D5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:06 +0000 (UTC)
X-FDA: 85477013412.16.671BAC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4F62D40005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UtsNJXH5;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691704;
	b=oGESPpGz6VmvxF7F0iYxIJCLzAzre7olHBOmPvmE5Q3D1BH7K28GAU61O5Tyj2GpGgHfuq
	mRIXoyOcaBOLl8rbGzi/3KPffvtakIe3ctgQoD/vtlWlVEjduOkLIcw1lxx89W05hTvQaK
	11p2GLz+Cf3abeaKY4NPT3hRsCngr4U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bj8/4t1D3486bMWuOXwhLcAKxLKyES2zSNh6vuKXpeY=;
	b=q1v1rsH0PIR1hePfuqiERfiHpBFDDyrTaGfMX5bJk++C6rAyYleaU812lBXjGWO924dvPD
	5wiOMlGzzbyVl4DZufEIn3xT/NfS1Uh1M2fg7Uy/okpHe0sbWNUDX4xmG6e02dmVyXfvmC
	YZo1WNQ0giBkqlRo/NgwD1vujqJ8kWQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UtsNJXH5;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 919D645CBF;
	Thu, 26 Nov 2026 11:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18B61F000C0;
	Thu, 26 Nov 2026 11:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691703;
	bh=bj8/4t1D3486bMWuOXwhLcAKxLKyES2zSNh6vuKXpeY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UtsNJXH5LkGbLvmX8h3OWLUUPvo5d1Agxt9hiYQPPnM54LtZfxIJvEkh7mIytiaPL
	 R/iQ8gA7kJPLRFnQ2FHCXHvqEw5yPC6eW6oxNL4Gli3chYbPmwhbjwy2PutbebUGMc
	 R73R+kL6N6mVGWCCB1VsAFs8AB9+g4AyJv+7cH0WQ+PHsw7ExmQ0tVphZP274UDziY
	 3gfWXTO7rOPovoqCNUi+BQdyjUiAqRxeTnYvKTBDnS5fdyx3AoxmmN1YYITXMeU6u5
	 58JA57EHTN+Mt/ar7zYd+kdqSTSqOfYOBW/fd8UrNniZmSKj+/mHWAgxeBE9NdurAa
	 swzGR3b7HpeBA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:16 +0200
Subject: [PATCH RFC v2 03/54] s390/boot: parse boolean parameters like the
 kernel
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-3-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Rspamd-Queue-Id: 4F62D40005
X-Stat-Signature: t1c3oigqws3sxrhize7mjqxtozta3qrq
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691704-191255
X-HE-Meta: U2FsdGVkX1/kV9AOTO5aZvShc6sl//xn90e7o4ureDlEm7TzoCGUrn31ukwBs03ggBXsOk4etfy8SCeHpU/hR8YImjzFh0TfSzddJ123UF2F1WRF8SSbwXK4K5t14UStorB5ewoTpdau+K5UK/gC7jmfsmrVZhv9KxD6nFt9PHD+V/us67j/80P9LP4UxflSz2pxwmm1VReJWVbuENfklBlcMrxk6GpYtNVPfFIO0ohKLIpp3HX8g/jEajh3w9jp/o0HacEn3D2zfjCuCSFxPMkn7ZNS+EuCpFC76OuvODUJYVNkiVENIjfSPUpAdZOHp92UGuayrxfU7DhuxTr2dAenrX40roWvPV5ZrDPRI/6A36cD/oHXeyFgoP5fU876b8xqdoKaLVuliRj5+rERJ3vFKQMkHMq0CmWdEgIGoiqDL3gDxc+GPyKM2tzqfJMgO57xbYACjsedGSmIge4mS91Nj0mVOv7Me9YmNUmRiiaD52uUFgIRSw/c7Xs3c5Ewn7NwUWIUalWICNMOA+tv8gbin9TGEkYdAkcu0bHbN0c5IyDj1iAQ2Z+6YJzRLlEw+UMW1FlMaEasVNm6hcNy5Xt7oi8gNVIgjtJoNhUepii1Urp+a4fab7XhtVWc4c22kxEcK4QBwt11J0Y0x5mQOrIC5AV0tWR0WCj001B5IBc1XFfo0lsndZt7o0mcov399UbW0pIr1cWfj3a48iVombTdnYyAqaR1Oq0XzDXS1gddAty6z0ViE4ecLQQaFbweYPTd8BsFSxSfXcJjZN3DhWs8k2UcftqczeoQowdB1y/dOxO7tIL76gMzREhGSrVj9WxejOOeulWBJwDZEmL59MezYaodiVzASHaaa4HSDcJJlFmcDHefK+ItMkbOJKwwrkjhgczlobb0eP/cAe/RV68mYMt5I3TCNfb/qzuw5kxG4AEluEocmq8ebBuE5Cfxi+9cBYPvcoUfLzHQR1n
 6a1FjXD0
 N2zlP8WiycDZxnJdnNRFhALUfilUErrgYonm5R6GcyKo5symQdfas8HT+uBRVh3vUzxNLYM4ni6BwgbC/p6vXG940tPEM/PftMtF8cWpbg3nvYl7fOZoBJSLkMYmtwrQ1dxsfLOr2Pq725rdTfjm3G2mkCL2ue1a9k7Bj3r5mOglVoRDEy/gL5+bj64T10C3lOPt/DIZWcC/8p2aA2XYolyG3tPFpSlmIhN3C90oo64zQuSKwxYhy/sKNyVyCWjXcPBCMhFE1Wv/GDlxMRJGvvOAo4b8SQELalPVoI7zXNKlULpGPgufBWGXnmBS1iv4LbvkcwHXAw10sd1L8iVoX6U6j7wyunmBdN29Ycl/o8JeGXOgRDYSX8RASexzH9+D4Yyy7VU5C3kOM7fF0UAZ1HmJeI+cqTd1/qymyeoE9w7ylpSWBo/C/xdH6D4OMVFQ7aWNT1dM41M6X+h9Zg+Upeg5FLec9c4yUt8ik
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The decompressor has a copy of kstrtobool() that takes only y/n, 1/0 and
on/off. The kernel's kstrtobool() also takes true/false since 0d6ea3ac94ca
("lib/kstrtox.c: add "false"/"true" support to kstrtobool()") and
enabled/disabled since ae5b3500856f ("kstrtox: add support for enabled and
disabled in kstrtobool()").

The decompressor ignores these values, so "cmma=false" leaves CMMA enabled
and "prot_virt=true" does not enable it.

Copy kstrtobool() from lib/kstrtox.c. This also adds the break after the
on/off switch, which only replaces a fall through to the empty default
case.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/boot/string.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/s390/boot/string.c b/arch/s390/boot/string.c
index e4ad196cb720..c12fee2670e3 100644
--- a/arch/s390/boot/string.c
+++ b/arch/s390/boot/string.c
@@ -132,13 +132,21 @@ int kstrtobool(const char *s, bool *res)
 		return -EINVAL;
 
 	switch (s[0]) {
+	case 'e':
+	case 'E':
 	case 'y':
 	case 'Y':
+	case 't':
+	case 'T':
 	case '1':
 		*res = true;
 		return 0;
+	case 'd':
+	case 'D':
 	case 'n':
 	case 'N':
+	case 'f':
+	case 'F':
 	case '0':
 		*res = false;
 		return 0;
@@ -156,6 +164,7 @@ int kstrtobool(const char *s, bool *res)
 		default:
 			break;
 		}
+		break;
 	default:
 		break;
 	}

-- 
2.53.0


