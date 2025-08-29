Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5376CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3FB6B0025; Fri, 29 Aug 2025 14:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B2E6B0027; Fri, 29 Aug 2025 14:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A1C6B0025; Fri, 29 Aug 2025 14:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58F846B0025
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E2161185A7
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:14 +0000 (UTC)
X-FDA: 83830639788.29.6C73EFD
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2A07E80003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RKC4zCv1;
	spf=pass (imf30.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ee45j59z6EpVLajLN9KzFmkYRTRnW8AGAmUZ4eXAOA=;
	b=UV5hv6xARIobuUvMb3VkwG+EXGiqg7ew5b1+F52/1NO7LSGji5kcBFAEep38U4nEvn7yG+
	13eOK5QP+7lNBOWnhr+Z5egIym1iQqg1QC8LzbWZtWYqXP2sFog9dKMw/2Pcw2RBpkDtMl
	0D34VCoht8WvxVK63Ure14wXfmRwFP8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RKC4zCv1;
	spf=pass (imf30.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492332; a=rsa-sha256;
	cv=none;
	b=twBUR4rPJuR3pUceuycdGhy9Vzm3VnTH+FABBsG7Uq4PFJRM8HmjH+XkuxsDnUx9Bj3H+o
	Iv4XkSZQR65oNCgEKKyjez32j+jbtHgIjshEPn3v4NAR1E42PZ2SM1N1QoCsMnqTWznOBa
	1FYhucLCkI+LuoQ7IWTYiZXtzpmNPv0=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6188b6f7f15so2757690a12.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492330; x=1757097130; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ee45j59z6EpVLajLN9KzFmkYRTRnW8AGAmUZ4eXAOA=;
        b=RKC4zCv1VWiOkybMntA+T/zN+at7SId1HjSCLn//o3LA0Xq5FGfFh6/IBMQmt9h1ik
         qLzNNUpMsQAy3Zv7ckdNhmkSmlbppVVrCKdnepvvFkFGUFxrcSt9vFme/byckGFypvyq
         wGYRkNkX8GrpwCnTLg5w8KefOpoTNKnP1ZTTjCqqcdcRH9DMpMMChV3bxbTfDFxVYHg7
         kE+jwg/RLTo5TJLXPuob8IMR3x08kU4wPlXSt1yWBhMeKwt/vIjojo1uEAR+wpSK8m7l
         ff2FMVH/ZBdJmLtr3Gjw3NKk4U+VRrskPs7YHPBTDBskv5dWLdoBw4eiZ1Pwo0HoiNsf
         2Wog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492330; x=1757097130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ee45j59z6EpVLajLN9KzFmkYRTRnW8AGAmUZ4eXAOA=;
        b=EpQXe9XAU1b+CAHrz6+2a8oEmYhbQKomX++DivUsQpsizWFN3RtBTpiyE+k0habd/D
         X9hKYuknqLslT7ud1JCq6GbC8L++O7IJPKXUmdWW1Az4Xefr1oq0F8xR65VeQva2yAhq
         88DOfag3/U/kE/zj5w0WNHAoCIgiMm4P2aDn9m73ihQlXZqR8F2oIaduhHq+FqUJhNS6
         nh3k6HJtdWQumP02WYKrfBac/mEl7AZJPZ/Ph7KOY29FGFHnZ2wdMoPvxjT8b8qGsFr3
         YBHDrdCxcx9PZQe5eJ5KpRD2IDhrvge+SKCWwc67txnfVX35ojUa77T8l9TRwwtm3lNn
         chrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkNwW8YUn5HxRuK44bmXPX3vOsxx/Wgg7xhsSvkRXmLR6gW07sEut7o45JMC5yITmoqtjlshhgew==@kvack.org
X-Gm-Message-State: AOJu0YwjRSl0dRtTT9Ypf39PgAkN9yrvSHrFDmTqB5BknZaMOuHQnA/L
	gvQoTTbk+rmjbgj/tareEFOXp+aXBGBzKzJafMTvxIXpEyR8WczCaqmmAVLdGDMSYrg=
X-Gm-Gg: ASbGncusAcGujvjgIEYEyuVDrKXmOgEWWyRWNYnMHnWYPQYP42VfdCwUCDtvaZzQ0aM
	WKPuBhqrkRs+30eyiq/2b3WxkeqY/YrgMXp9u3fiPAy86/mAcKK0kWOEQLilWUT5BeUTW6NOv4v
	27RAL96GduXhtnuACfvSlOWOpWCgmc+aMQLpM5QaJnO633KBH5izgIGBQkCHxSngp2P2MgVwlfd
	voVdtECneggqwaZ5HFuPaK8EvdoRBHwSGbSXKEBDCEBGpzgfGmBIfoU9swft85Q/pvHxKyFvwJC
	GDiUizdhtpET+SiCVbXbCk7DvDZUpkmMkVjryLTsacboByyKDWryO00s4RGAxLG/fBgQ2uEDCG9
	8eXty+JELpl/dmkrvbEt6RTOz9LYTTWsShKi1qa4kTj4R8WBioge5uVm28JH8cl4rFhOpW1sIO/
	bl2ixDNZCjUc+1uXoBTb1wGA==
X-Google-Smtp-Source: AGHT+IGJSceHz2hcoyT5ehNIpZ1bJmh2WPC6/xWH9n3KGDraWBfmd4TrD/HA/jbZUtAL0eU1mP3doA==
X-Received: by 2002:a17:907:608b:b0:afe:d5bb:f433 with SMTP id a640c23a62f3a-afed5bc15edmr780600666b.25.1756492330481;
        Fri, 29 Aug 2025 11:32:10 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:10 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 04/12] include/fs.h: add `const` to several pointer parameters
Date: Fri, 29 Aug 2025 20:31:51 +0200
Message-ID: <20250829183159.2223948-5-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2A07E80003
X-Rspam-User: 
X-Stat-Signature: c8ouehew16rqwri1osn184bq9ordotqa
X-Rspamd-Server: rspam09
X-HE-Tag: 1756492331-804918
X-HE-Meta: U2FsdGVkX1+zlFwUO2NWlPc9a7CF9Age5ScxPiUCi679GojleRAF7yDKCUJTh3gPw+mQdD2w7gIXcRkEPNEWyx2HVCRhZHIAseWcEoTZalazeZwXBtPWpuHYegXlutfWvmaqY9YTgtkJ2VvJRQoRkl5qLFeCjnH67esmJQeDqrHadYOZ6DicZK7S7L5eC35Cn7ke4+aMiqegpbgROSCjgy+eAEQp5wr+eQvWBKgeul3flBL1XgGzWMRR3p85fmlh7eL+s+gmT69JH3k/vxMA7Sg7u1gam2djLBsVlIcOHTdwhPRJ7/wT7ga6kvWt9qdjYiVImdHsQi6sDNCzT/p11JwuHQ0tMFOcqvPnCA8TEms8VBg0KU6754BvZ6biBEaX9k2woTlSqCbTDLNj3UYHKBOpuJSAH+OguA5nZUIs+q6NfdRXpej55b/ZLmppPi00IpkacgXvIFT3/r9p8KK6xaHl5SV9CFefLGRzq/YWtoXWgEjE2zIGCiMhbXSyVsMsGdK9/j/1JQlFVei9/99s5kKSgl+i7Q5b6+EQ75/rbpC99ah4qEr+Vn28rWyJVPSXn2ZmcuZ/41WnOtIMIHH4/Cj3XSm+aSpTxcdrY4g+gbK0zyK7HqEgnHCiOtk76jFucYi7vTHEI/2CH/mHZXCAuE5x8HO03cDW1Ofb5ETMdDRdx5OEQRW2FynF12s6xGxWpa9LFpLgBPeqYRj5vEgDeI9tL16zdRwfvrrY2irNf8PzF75GWsaOt1sDU3eyUTKIwW7yczBrnMLz2UXdsQx/H0H/2esEZ5KHxawKvseM51XeeZHXa1d12G1UxjLXXEYCsbT9IGJX/fkS2KpZMbvI+r5mxuJbAefrbZt8bb+6GXDcHd058gmzxoWL4J/cinNfulXzbSfuq7eTOQoeZ9n3ayFLD070BSYq1wVqLOjodZ/y3ERKRiZUf5iPZMy62fw4vWgMZYcR3mRjmfSXUWD
 mq8PPlRc
 FFkg0UqbMMjeGnLktuP0z7Q1yKTI5CKgLSzaXJI9ziA6xP6R7nfecWYnrJttEW4o7TATPf+v/L4rAAgIaDH3vagx39WNDBdaI0o1QB2LAsylUh8F3so+icFRtezttMgya42jwYMf8e5Gbhv9qVOEhcEUNWk2hctpUl1SUe6SUqVKRbshj7682Jf+igMj1S+QmludpFuJECEMqjJ42ZyeL8IPztZB49IGF8yjueH4Xmv1ddtBOHJgEwM5ActAXrROLQZDaNBTcnboZzcUnv0sqXL1NwASLix1pb6nqwiKnpK7BiHpbFobkQJbOwXBaIQ5MfzJmlXKsAB9PcJ0QVvH5WUpLym4XWnAhNV8bjtuO2CMsFvg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/fs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b9f54446db0..0b43edb33be2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -537,7 +537,7 @@ struct address_space {
 /*
  * Returns true if any of the pages in the mapping are marked with the tag.
  */
-static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
+static inline bool mapping_tagged(const struct address_space *mapping, xa_mark_t tag)
 {
 	return xa_marked(&mapping->i_pages, tag);
 }
@@ -585,7 +585,7 @@ static inline void i_mmap_assert_write_locked(struct address_space *mapping)
 /*
  * Might pages of this file be mapped into userspace?
  */
-static inline int mapping_mapped(struct address_space *mapping)
+static inline int mapping_mapped(const struct address_space *mapping)
 {
 	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
@@ -599,7 +599,7 @@ static inline int mapping_mapped(struct address_space *mapping)
  * If i_mmap_writable is negative, no new writable mappings are allowed. You
  * can only deny writable mappings, if none exists right now.
  */
-static inline int mapping_writably_mapped(struct address_space *mapping)
+static inline int mapping_writably_mapped(const struct address_space *mapping)
 {
 	return atomic_read(&mapping->i_mmap_writable) > 0;
 }
-- 
2.47.2


