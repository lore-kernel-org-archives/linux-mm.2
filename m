Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ADB5E784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 22:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1E76B0088; Sun, 28 Dec 2025 17:07:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F456B0089; Sun, 28 Dec 2025 17:07:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271096B008A; Sun, 28 Dec 2025 17:07:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1368A6B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 17:07:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5350A8ABA8
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 22:07:53 +0000 (UTC)
X-FDA: 84270268026.21.E21E1D0
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6701D180003
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 22:07:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jjNEIKCx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766959671; a=rsa-sha256;
	cv=none;
	b=S6D3hoioBEjeI92c3T9b/ZfPhstG//eLM6VbIpDdj+AGCdVM5FkYRRAk2avF2a264NI5qF
	CcaK0G/DF1Tzqd+BKs26R+rvdZJMrGE3zyhJRXQ9gu5RGv0sIY2zmeq5LhNppe3Mb9u7F2
	iJec9pxOP/xl1rne+cWhSWa3AzbTaIo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jjNEIKCx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766959671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHBjZr2ZhvRBrA9UdDR3gLaOLu2CNko+VVfEqeoCkX0=;
	b=Dlt2TuU0GLmlvyvqWKetQ9uoMxSsPr775n7GJm/5Ec3e57a2buvelJgzYPPjg7q+Ypc6zc
	3GKLg6Js+nqyC2vDT6FOCP8oL8MA7Bu+HdT0U6zpQX8S3/ceow5ZS1d0E5w8lxkMzifemX
	Yo2CGRVbUjLqExMdSzDZoLfkiDxRAqg=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7f1243792f2so5660488b3a.1
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 14:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766959670; x=1767564470; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHBjZr2ZhvRBrA9UdDR3gLaOLu2CNko+VVfEqeoCkX0=;
        b=jjNEIKCxgAsb7Mv7e/pA2UH/B8rXQbiqUJI6ETM4Ls7WXgca+q0I30ibLaarMeqM8/
         fh5NwyaYJ7KXHcG+7UxA6tSYbDmAgwOgmrwzT5Gc4eAXq3rHis99TYSbSfpjiSNe5bjg
         HQswruHBAMIxA3s13ozyDj+XING39TebZigb03F/tR4kskWfghpHYlIQpRECa5Vjz4PI
         s6xYBIenSo6rMZ6K1HcDtkL9k3j/efPtlLPqf8lG/uOOz3bnH4ucX1GkLuwjt3J+MV1x
         mfHWdG20foBw4PkDyw7ycay8XmShDzebQYT8SvtXXip8d02mw7mKowWCwvp5UkYJLxJQ
         paEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766959670; x=1767564470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jHBjZr2ZhvRBrA9UdDR3gLaOLu2CNko+VVfEqeoCkX0=;
        b=aZkIJ2kAJsubcWLpy6Z3YXbEb9Uu/7Y4qTbIKycU2cTC2dK7oVHCFITJgBJiQo16rR
         zU80UhuLo/ozdKlaICCAV2HD+qSKilvj/FHkfXnz+ME96xdvFhMs1MkDNxxOHN7JO3yY
         htkMAJqWtofjnuodh+1lkjhuib006j2QaB6/t8JR14ugihU21s9ZXZyoOW8ZZbScyTOZ
         HMBl9AXvLzglw2SGrL5Q2y08KhkCpmjEcuAIeh6Ru/QAGy6r9oRtZH0nJwQRI7PkBP60
         QSJJOE/mX1TZVu9PnnjVFh1dLHcT/TRIAsopI1OCosZrk/I0m2xRJcgPP4YoevWL+d0/
         z4sw==
X-Forwarded-Encrypted: i=1; AJvYcCU/1rR0odQzJjOd72RoJbQIzibkZ3SvI4JCdJ2+3qcL2l+YeaAt01+IX5FfjA+Oma9cyJ8Nt0k22Q==@kvack.org
X-Gm-Message-State: AOJu0YxS06pdz1SciTXa+1PihU4V+lWRYkkMPBqfMSCWRJTzcXCdDbdc
	lflBG58TbaUpX+kxIDoBAyC1sOr9mWDGldVhvuk8j+raRDC4SWwkzozu
X-Gm-Gg: AY/fxX4oVLfChXFJa8veQsOubn9wYtFyuPaOAZsiArF98MgLy8+WMbQDEQgsxNiETC3
	TEmpK750g4pdpWFzhC4trb59yEbHnuu6bYxWk6gj6pPPA81R4o3FccE8at1LWWt2Og5bhte6eHy
	WOvjlOXOw6DA1Ei2In/V+E9Z6ExmwWcG9HfVxK9HlQOj7TSlm09FdB8bMgGwIke9dVI+l6cyhaP
	h7Vj5gqJyp6qCrPQuL+SNmiLpbaH82BVcalV+sCIYiCJ+ON4EEobM8FzyoXuVDiQIaZE179SAj1
	6V3Dy7g1CHtZSWMQy5jo6Q4Lka2aaOBVw3+nA2Ld1Z+tXnF29AxdNodp5W44NQgpZ5rVqu+/oxe
	EREQEkh8HB9SE2hWJSrFOt0e1uy0j9LdXEzdUHCb/EKh4dfXQIDBm0IbPnrAHmFhHwWzZ1LmVhq
	5gkpl/x1qJViMx
X-Google-Smtp-Source: AGHT+IHLgsy3bh+Dvy3Jzn9k4YHqeQf5ozSOSceiWwDv/q1f9yZOXlUMyRmXoxSuTuJXJCcxTw5LfQ==
X-Received: by 2002:a05:6a00:600e:b0:7e8:43f5:bd39 with SMTP id d2e1a72fcca58-7ff66d5fca3mr25643947b3a.37.1766959670033;
        Sun, 28 Dec 2025 14:07:50 -0800 (PST)
Received: from barry-desktop.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a939ea2sm27065659b3a.4.2025.12.28.14.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 14:07:49 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org
Cc: 21cnbao@gmail.com,
	chrisl@kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	wale.zhang.ftd@gmail.com
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on set_pmd_migration_entry.
Date: Mon, 29 Dec 2025 11:07:41 +1300
Message-ID: <20251228220742.11157-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251228133742.a1f90fc552d346c4c43aad8b@linux-foundation.org>
References: <20251228133742.a1f90fc552d346c4c43aad8b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6701D180003
X-Stat-Signature: ykeow9z9bmyjy8u4oy1nzeqjcij1rbrq
X-HE-Tag: 1766959671-312168
X-HE-Meta: U2FsdGVkX181wILO3KEoZAk/VqddlJMnkAoNoYo8XHWGfI8zKoIguN8vOTpkf7Ld4AkVXw5heMyq09CYw7oodt9ncE0Ql1bt59LsZjiV8FImDdt7ehEwq8hiqykaZ1L00gDpHa0SVG8cOfj1AkhNw0/SnC2OsrNHrUBcXBsk1m+3/WW8BR9YvXFHp5GL4t/WnzrjnGQG4S3Ysxeyednf2SDKvE0Gi8WlCLaYGOS022CUnG/TpseDbYG+NFFk20oa4GS07gFfFHfEwKCezj89nSZ90HLd6/y32sEIr4iaY18wq/zqB3IxE/kyyWKOuoYNy6y1DFXsX8g2F3Sbm9mABX8doOl+MhdePd4L5cDZgSK3b0fptHW1xx/NHVu5SYadEsFwiDuPb/JVZFQFUddkwK8ttOB2zY275Nw1Bdt2voUfWHwFEPo4uLr50fSwoT6GuUerHuQ+3yw6PyzTrnaFBmKmczcSNFzSIFBu2mMHQd1AfwdowpAJuZnQiAoAVrzlQI+bAZpLz6HuuAZ1rVHlNJS6hk15QwewKYU0dLe6wIx7QL3GPg/bRKcxOvsxgKIeYFIRwQz9EuAYHRAouuM2O6Gr08KVGF7BfoyJhed+Fw2P5VY8qdt3znwXLOV7BrCAMIDWjYzi2x5MrBcIjrv1wBjxw8q+SK8dl7pM8FlgRgYFTDiqlsanGWldOlW6a+GZ4TmNsedGWUBYKtTBhmXHWfl32d8gc5MGU7NA8hOeVqRzwT8O0J4WGPpujj7zjZalrpTIU9rghe8Q/PQfl8DhESCHN/FGIDSgYsHXU9hZGPt8iV1TarrLzi2uG7yeU6FtSY//2RNbkk7QvUdWzM8oFDPCMYLWRTk/9KwQP/91KgPFF/6SKYJr+Cc7vJuLKJ/Lrd3/qjYMkBo9jp4Q4mbq/8624QJDvD19ZqOV49eYuOi+7SatcT6eBV527NthUQLNVeD08PnlnJ3SaTKYfoy
 7g2PNkUI
 96P8b2iFz0uRBYF8UUCSc7jrbp0n40TSEbEbZu0vx+kJf2mpbMasx2hRxyFPLtjtsgLJ5yHm11P5FTHdaw1y5i0IWtza7YeF14TOJ84vL3l7y364Dwly/VgnL0HG6vDda2VA5kH7NSDz+fnEdyQlEt0iwJjY5Kv3pUv3fiLTV7+92XWLadJKTppyubZDr4DcQUGUkBLaNPn3bvqRo1SBisIQullHyzPp0EnG2dDEJX79jqCN9C9YKNbvx35H7XOqkSxUv8EK4RaPh3tFH0Lfgx5amcZHg1pItnNkKF7AjuID9ZFMcLsfDOybH9jx8wdvv25oqcczgkpVlJJZt1MYPlSTiphkv+Gsac84KWg8oSb2sGWwOigZIHtcguEuQBnuejBdb3OY3uPPTFNHKKladymJwN6fKL6pq1hKgYQk1qcy4pOerNLCfhhjUQXURsQZFnpjDKAdzBbseZnu2MFmKU0yG4oXkoGReCXNdFjUcoIDEGDXMFsU0OuCwhk301yuh8sK7hb+3WS1jU331VWIto5hNL+PLN7tV0RFW5VJEf9GrLd/H+Rhs0PeLu/IfTu4j3s7oixqv2zoi9oownxusFRRzF0DrYYdgbQrWe0XN/pedTpMA7nlO4uohYMXf/Trg7uWLYlz/GaCVSXcTyTLCRDpDBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 10:37 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Sat, 27 Dec 2025 17:58:40 +0800 wale zhang <wale.zhang.ftd@gmail.com> wrote:
>
> > > No. You still don’t understand my point. The BUILD_BUG means this
> > > code will never have a chance to be compiled under any possible
> > > kernel configuration. That makes it dead code. If there is any
> > > kernel .config in which it can be built, then we should fix it.
> > >
> > > This set_pmd_migration_entry() has no chance of ever being built.
> >
> > Hello Barry,
> >
>
> Please share the .config which was used to trigger this build error.
>
> (It is strange to have this should-never-be-compiled code.  Why not just
> delete it and let the compiler/linker report the error.)

Right. We should entirely drop it in mainline. If Wale does want an
O0 build, then the only call to set_pmd_migration_entry() that is not
under

#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION

is migrate_vma_collect_huge_pmd() in mm/migrate_device.c.

Then what we really need is as follows:

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 8cfc966eae48..fdd4375d5d90 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -339,17 +339,6 @@ static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
 }
 
 #else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
-static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
-		struct page *page)
-{
-	BUILD_BUG();
-}
-
-static inline void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
-		struct page *new)
-{
-	BUILD_BUG();
-}
 
 static inline void pmd_migration_entry_wait(struct mm_struct *m, pmd_t *p) { }
 
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 23379663b1e1..74d23c91626a 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -195,8 +195,9 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 		return migrate_vma_collect_skip(start, end, walk);
 	}
 
-	if (thp_migration_supported() &&
-		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
+
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+	if ((migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
 		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
 		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
 
@@ -226,6 +227,7 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 		spin_unlock(ptl);
 		return 0;
 	}
+#endif
 
 fallback:
 	spin_unlock(ptl);

Thanks
Barry


