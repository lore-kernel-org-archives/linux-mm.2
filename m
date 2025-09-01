Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FED1CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6AD8E0041; Mon,  1 Sep 2025 08:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801838E0013; Mon,  1 Sep 2025 08:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607058E0041; Mon,  1 Sep 2025 08:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3028E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:30:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E447413B193
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:45 +0000 (UTC)
X-FDA: 83840615250.03.EC59A03
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1DEE34000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=VFOriOf5;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729844; a=rsa-sha256;
	cv=none;
	b=2oQ9g/esGQhW4cHEAb1Mxdp9PexASZQQcN3bl9okDQ+tWc9As02NSsZla4ZE+i5Li3RIfT
	hsh1pL9lshfocxdB+WAixiDnPDYgs3zBkZ812TedjeTdMMVmVN8HkGFXoB0a2Q5faNPUDD
	LxlFJ1Npkqpz7IVHhUg6xhLLvf9aEtE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=VFOriOf5;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlcCpJbD4nPkPuY3yUCOwN5ViUagWq+iHpO5z1mw7KA=;
	b=Lw+SoNgUxN02PFkdZxbWuWxI0ZlbEqyixkbYSf89kBe+HkNxi927zXCNz7SHZ2wUhd+ZBD
	hVDSD932p+gv41MeYRw/dWZmS4KyFZF6AazEVaV4I5yhmmeLDRLDeAQbUIVg541hLpB2cj
	QQ4tl7+pfqFzf0+wHNhDu1RPZ6+NAGc=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61e425434bbso1805450a12.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729843; x=1757334643; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qlcCpJbD4nPkPuY3yUCOwN5ViUagWq+iHpO5z1mw7KA=;
        b=VFOriOf5V8DGOHu7mizjNpoPWvTaLlPNiWdsFmGW3/1kDfO4jzqGto7W/JjUN9Jah7
         byqbjBv10b1HS/UapRT0HUM2GDSuhijFud+Jpbbl/EmzJpGR/QYVGT5E4hDA4qSXuVo0
         LOnSNXtPH79XiNZ9s7I01Q5sisOc9n5wCFN4W6AiCyW5hScsP5CVvkAl8Q6+nn76CPyd
         0qnACe6Ccz2AqZhvW1LMhlgLbaLENDSW4dK0QKC61JiQkYj6Nj0ClcZapF0DCOYPNY55
         PybJkbXmITAAqM+6jz49oSxKEpkrvAUQWbLsMog/iRb8AWYnzVaFVlfU0RF0LJyFv1lh
         ve8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729843; x=1757334643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qlcCpJbD4nPkPuY3yUCOwN5ViUagWq+iHpO5z1mw7KA=;
        b=vQk76abTMaISprdgQO0Xjg/WLbcZiDbxaGj3xod5tbfl7WPlkX/lpL1qsLCCwdvMZu
         EGNVCkF41lQ8sDYijlUFuAIQM0y3l28KNz1F6SspslyG9tFA2ofkpUDTJWRyKzusL1+q
         dHk8/7uds5T6I7t+Rcw7B9won8qAjGNpUbHpRTpd+EE0bj3EoOmSfJezQlqhP6mwy6Ag
         1tDiWAas+gUWM6rR3FPvpFhdscY4bK1gTzDpf6SXTzXDeZoV8UH8iM6+EmziemEeizh9
         1+Jp24nVXP6SE6KkptbSybZDYkpXkX8madFhIQY0c53Bf1KYR72PLU3f6QksHswQpj0Y
         SmyA==
X-Forwarded-Encrypted: i=1; AJvYcCW1NelCp0v6E+q4PXiZQpjVAdvHzwXroMKEKB5mSBI4IEsD/OxayppOPcQ8bXX7DAAcAZN+DnTfDQ==@kvack.org
X-Gm-Message-State: AOJu0YzthRAsb1LQY+GwBajozbOnfFki4Gy4/XEcnRN202GYqTj5aYy8
	JtwB5cHRg05vs1nThnwhymoEMJDBcfD4Zg+BIQfJzR+1NQKNAAsTmEEnq4I0flIkeE0=
X-Gm-Gg: ASbGnctQC3d0Ui9720T1F/x7sVEiaXE/4uqXkwOLrqIQtvbXo0AXP1+VYJESYMMsJTz
	xE/sNVBkckHa6uykS7wZaVDB/JuS/5In848nILX5e6RQ3Al+YgUSNjoaj5upjzipyWdHvk6MV9G
	Sl9IdItMV++8b7w+9pQo23mHmwGlNUCEDcixnBe9gUDTJLZm7SIH+GwrU+iBzKfKMuZrGW2kyLK
	c70NY5Wx52wUtykEVI3zoYkIoOQKlZCZXKk6/AscB2m25/u74iNrdTnHR/hi5f63zkFvM6LW1qH
	7o/izQi5aR83533aR36DsyJt0Wzv64mk12tH7UGZchgvWi7zQvDZWsPSMPlIjWtXLSs0L/JVPqs
	m9bieYYLdoNcbHpmeQLEQi2K/PBl2TQTW/vEacrm7Wknk5IV1MWMM5nEQ0/ccuvpfT5DICubU7j
	lYEzMPZayeyeceFqg7Fak8vQ==
X-Google-Smtp-Source: AGHT+IFO4D7bAoVhJtV1jctvP5v6tn3ybzaRVaB/XhRQIb32ZxZbdyWzguubllrCoRGqVBHHdeayTw==
X-Received: by 2002:a05:6402:52cb:b0:609:9115:60f1 with SMTP id 4fb4d7f45d1cf-61d2699f676mr6340759a12.16.1756729842457;
        Mon, 01 Sep 2025 05:30:42 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:42 -0700 (PDT)
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
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 05/12] mm: constify process_shares_mm() for improved const-correctness
Date: Mon,  1 Sep 2025 14:30:21 +0200
Message-ID: <20250901123028.3383461-6-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1DEE34000A
X-Stat-Signature: dzfm3j7fsfeupwizidwtt586fehiu6hn
X-Rspam-User: 
X-HE-Tag: 1756729843-163147
X-HE-Meta: U2FsdGVkX1+jFBzKLPucd5tA/IHJ/WIdjevzWVrSxRxA+x3lAUbQcoIV97QcbxdEJUlHbhHcJmBBcv1UZwWUQz+P8jH1yfVbsLdeGtek7nqMFGIRmyfXFc6nzj6ifdC97bJ+dqoTf4OKHXDvjPzOkNwXpzZuuE4TaxR13qzthn5nj8ok+PoqV4f2wFlB5bfD1Bhgbn82JlnRFkdLIhg23vzQYocZm3ld46AaTljp2tx2vEbDuv5BqS3Jve1N0rQEC+1NAXW0gi/Gs04JCXboPQ+2rEvTKx8SNvqRPxhVF5ox0Ai7JCkNndKJxn3I7uD8e3DGfaQeG0lN/XjueWm+vinJPPL0/7tlI5IKPgRAsqM1JTGKkQawK80BHw9L+5DdH4v6SpTjTA5GO4s0efG2nV+NuE6m9aXp7g/eEJlbOUHOk8Yz9wAMUqLP4DvCT0YzHY4iRjB8+gBpfhRZazGHV8kWEkobAPg/dI593e+LJTN+sDq9/3oj5IX5XMATDhEMdjvZ1aNDViu8yS/SfUzTs+ebOnDRBmevwkFwVu4ZHypnp8PuaZufKk9jrS+YUddr11woT5w+tKVCTrVTiVoDNEpbgkSIXAvAe6aZ7S9Hhxp7w+Q+sf20XlaM4ylVtRPD+gMv5D+yX3U1RW94GRG64hmc8c88/7prO+EQJp6KpT9qwbKI6cYg4UsvgoUFBmOxEFDArkq7ePQchsIcKAq9TiY2vbz2CITC7iMZnSxSvrK+CunaDXCy9s5uNhOTmXbDMrokqWO7g3TMaytmFEPRjgbLYZP3xHPPzwSNQVXZ37Zi9OMNHsU5rLDVxwQsyEyOdSCiebvEMqhtUNc0hWxX3Qzazrfv5YeyO63J5nJl+EKY4YZoUmIB3dpbDl0OGosbGG6JEoUQ3QKlAuL5TQqmPR3mSS+zWa2jDlMNd4UuHvvuIm4W0OKbNXZ7uhJatWb5Xjo3hMjExo8CdXeMlYr
 Dn+3Sgov
 Dcwd6xfjoDeWKJh4D6vwGU8VX4XpMtpO3aw8rzAglru2gZZIRx1IIKz0rdX3ufPUyqn2vNrV7SsCGCFFTGN3opP4RIYf/BpcG5E5RfWpNmJmIu76qpvXGW19VpSBGP/PliRmqBdkUoimd7HvwsG9VpM307oywOcUAkRfV6qUahMfvL0+mAZ+UjCVYEceJUrfDdL813MEtefHZi0LV3Feiizta2fhImLAB8uQaexXLLgpbwGk/hHRyph4X8dmkSYzKD4JGCovXyNOYUqL3bMR32iqGOXJfV84AWawJRq7M5tvfTS3EinhdoblSUuDuiLulQmkafB9gIEeVbQiZ3I9/ImDJDeWZ/Bzt0aEt/7dPp/wh2KRrgDhzjk/b9aE63g5Pl/E/FQDFuKy3E1LssqBj0dT1rFY0SOjen/+KZeaJ4+kGXAIiBr7To0FvQ8xNNy+mbsku9bXLIaXDTL3jbbSlDuug67GuXrwnR5isy6pi/Z5Or7U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function only reads from the pointer arguments.

Local (loop) variables are also annotated with `const` to clarify that
these will not be written to.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mm.h | 2 +-
 mm/oom_kill.c      | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 18deb14cb1f5..f70c6b4d5f80 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3840,7 +3840,7 @@ static inline int in_gate_area(struct mm_struct *mm, unsigned long addr)
 }
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
-extern bool process_shares_mm(struct task_struct *p, struct mm_struct *mm);
+bool process_shares_mm(const struct task_struct *p, const struct mm_struct *mm);
 
 void drop_slab(void);
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 17650f0b516e..6a888a5de2a4 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -490,12 +490,13 @@ static bool oom_killer_disabled __read_mostly;
  * task's threads: if one of those is using this mm then this task was also
  * using it.
  */
-bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
+bool process_shares_mm(const struct task_struct *const p,
+		       const struct mm_struct *const mm)
 {
-	struct task_struct *t;
+	const struct task_struct *t;
 
 	for_each_thread(p, t) {
-		struct mm_struct *t_mm = READ_ONCE(t->mm);
+		const struct mm_struct *t_mm = READ_ONCE(t->mm);
 		if (t_mm)
 			return t_mm == mm;
 	}
-- 
2.47.2


