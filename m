Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8235ACCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CDF38E000A; Wed,  5 Nov 2025 12:30:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97EEB8E0002; Wed,  5 Nov 2025 12:30:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894F98E000A; Wed,  5 Nov 2025 12:30:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7524D8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:30:09 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2078258C36
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:30:09 +0000 (UTC)
X-FDA: 84077241738.08.42A19B8
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 43C60160013
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:30:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="K1BKINd/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762363807; a=rsa-sha256;
	cv=none;
	b=iikU/HvlzGwAlYuTEpemcOjhfD+oBYRN8yzfOp+GkM+Tne3myarxxqjNvk7Alw2LXTuYat
	By/eJBgcF4TeOGtSaQS2vteXammoIzmH8FHt9naUIFrqXmuUUswRIUYE/I1mCD3CTJGMRu
	LBYHet0V6Pd9/AufFvvjqsbij/Itd0Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="K1BKINd/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762363807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ECvbQOCleXWV41glKff6TwUAo/ctHSkBw2CY6tJdeAU=;
	b=M1rfcTVdRFkgCtCeTRuh/7W0PjSb6hsPSLSJlHPnWMicEkMiIldU6awmFFnD2gQsiAHahz
	iuJZSnYNULVbMs+SLqxS2qXV9WlTzp3PJ3ozglYVIHleyOBgo8rBvnlB9zRyEST+b82+I+
	KiSvXHTxTfPQYMVPi3/mnMjWY/JVXv4=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c6dbdaced8so343653a34.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 09:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762363806; x=1762968606; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ECvbQOCleXWV41glKff6TwUAo/ctHSkBw2CY6tJdeAU=;
        b=K1BKINd/oPfffHvG9i3T8v2pzdHuvJAFLVXUsLWmdOfIim2BhwbJOY6cjCGkyXUBtW
         8utDeRLH1C1otpc1kAsUCwV+9b0rUqzCNvR0zREV0Gp1Wg7GWgzu6gYyLPSFpWYnIQfk
         mqzYH2sUK2/3JmYDILbstxBnKJW28eCN0TY8AigAqpOUyvldcIoHt4Ys3Je7WbAlVB/u
         552svbeVd/KM02GD+lj831K2iturt7xZN7/yZfFF91yzID/SNKN5eNbyJQIb5/6i5eh1
         8wVYRM00H2BL8SIF+itZmpdfxt66nndOUX2sz8SDvv3BywrTUu+SO5/opTA/bRC7W0zO
         3sSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762363806; x=1762968606;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ECvbQOCleXWV41glKff6TwUAo/ctHSkBw2CY6tJdeAU=;
        b=KwKuBEbrBi7rRx3wYmrFlT6FnxvN/E+qvYX1hyo0Bsz6vojpWDjai9fDQ1zVma2qVY
         QMiiv4c1Zthitc5R0Sy1gAkKQsVkicen98GT+GuY12sgY8Vz7aZWMa4jkflJI2+BtCx1
         6tTHOVaX+P4ZvsUE680vkgl2HZuDDydhKB9127wV9nrCwsE8rNpdVCa71PLrg/dAaPhB
         EPY8S66xjyA/oBqNooXXImNoXSJJcnx1fzAmcKJEqKAnKqc1NwBVV3VIBvSAd3JlOVJY
         vhXiW/Z42iYOdUBnHWvl9ZXpIKRL/FbLDoSx/9X7k4N9tdSaTZ7oL9FxzPZrwsrarUho
         Pcew==
X-Forwarded-Encrypted: i=1; AJvYcCWaJf88JT1cQJfzNa8CiBrhJUwv72dwW7QqNltpbe67J0e2xM762hunBaXdEluAU5Bf6cWV9Gptpg==@kvack.org
X-Gm-Message-State: AOJu0Yw6gGN0MYqWb6kddCCe02QnOi05rDUDT8DGJgMFGy/FF4NGQJXD
	w4j8jO6BEI5nNWOmtl4oqYJt/TCRcvHgP5orqb3NYUiDJbmevo1lYNii
X-Gm-Gg: ASbGncur6CAJwksfN7TTg2ZaanKYNrEQW1DaWOHhdZQctab0WyzNOedMTiVU7v+Uqej
	i5MIIXj3SgzxyG+FB2iOSB+PRrX8n0540vlLM7qBb9XRU2QwrLAALUw4+WnR5mX0aqOjUNcYN1i
	gp55kVWtaWcU+cuV1y0nqs9AucQ4BGvdsJxpvVyyoNKUx8f5Y3bHd46oEdBCMQvw68PrX4yUnds
	7sRM5FSH/0Fz2yJ2KxDzlpxwjClZMELQi65ZMFVS4jdYBJW5uqDp/Rs56SLLuLCyCcew1YW2ohs
	RJR/qKp4rxUh9CBs7wwa+FeUZik3/26MzIGqV81TXX2G2OkrJw5EqrU0H5ROp7VA9YpWlXasb7B
	Sg35hJLdxcyMbe4y1CZOQTqFlZ+T+XB6L9mfvPiIZ1SwvBxkgiomMihl2Wh0jYaewj7Ricc4wTu
	TdvJlcqoSMW+pDAn03xfx0TRPcB4FIuv5WxNc8aIGgqtRUr8JTA2i+IpHtxM/08siWYnQ=
X-Google-Smtp-Source: AGHT+IEEGoBFr8oSk1ZccH795h94yD/tdE3zaD5H9+9COL+gtAHu17GIo7aa9d7OyusPpetKtRbniQ==
X-Received: by 2002:a05:6830:63cb:b0:7c6:a6fd:fcd6 with SMTP id 46e09a7af769-7c6d132f342mr2506695a34.11.1762363806080;
        Wed, 05 Nov 2025 09:30:06 -0800 (PST)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c6c25108b3sm2248313a34.30.2025.11.05.09.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 09:30:05 -0800 (PST)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v3 0/3] ksm: perform a range-walk to jump over holes in break_ksm
Date: Wed,  5 Nov 2025 14:27:53 -0300
Message-ID: <20251105172756.167009-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 43C60160013
X-Stat-Signature: 69bzzfzr7qjkrpsckj4oadz4spkyokjr
X-HE-Tag: 1762363807-214798
X-HE-Meta: U2FsdGVkX1/RY4GWuGmH69lT05puM3T09JGv7iEibYWxrPZ5q1ZV32aMtf8XNi30juuJjfsnwPYG1IOCSHKnkjfPz7yt4ULMgsVCRKITknWGvGqFZaW+uauVDU/J2WFFuZe4cWN8354StWBXENS8KHKNRHwnx/eNqW74JfnpsDzeJeKTmcxtM7cY+7r2V3mFuhULonTjXM3ZAsF3JA2z38w6uZzW9qvI9Pso/f8q72B9mfe6psyqpoVhZDrvci9qFPQMhASATup/oTAiZVjqxqnXOzVOqAIg9F60HOXn+vaqz7zgDe8wDyjScHl/u3vZhtMX3FzCj/Ooq7Fl10FADyFog/RDCY0TBR746oXE/WS6++TANqJ/9bkkBJ1adswNrME2ovHj2KTpxc1Bhk7237MeMaQLwpBfGp/qq0dSEftruJJIjGMIv3yU2DnsIiA01ze2WiWIhlAE/7YjKl7ls/dRnNQKCl59ha9WtKsaMMomKsXMV5AJZLOTCh7jpdHZRhc5lEcP1+sWCC4AFEvXYuba/dZp/L6JOBdKwFMlIL0bIgr1mEFx+pxwGSqdYpzcKa6WZTgOnsd+lOB6U70n2CrRUCifAIDXmLSimsEgQ2FFelJ9YjnCmzL4vJQEGPYfxl83BXYWVFdepX/zliyZ+x6eGz3tiRpqit63rbaRHz+23Z3fR00wT8l5pk3vfQkN4hSvH4z4NIYaE12OpcUoKad25ue4f0nVVckGzvK03ZQM6Mg0Kthis+GneDvreyuL69W9GJXJ0MwQJy5IooRwWGcnzrmRyVnd4yJzk3UjQpiBXKG+nx11yO5ZqeBpzgF7P6PozU6Bb56yZFvvttxB/qGh3+7BxFvT986zOGF9+Z3QiccoBURJifBgy5zB4tSqi8JrPL4EfMSokd3KMWYHW1iUFiNrxPRyIa71UfmpVeUdDl8ODhbKEUyuJE3tYCRDXOHdeSBcWEunNsBTvHI
 /gDbbT/0
 J0qiEL4r150TqV5/3jFf8ttvLvUMExGOAZTlGKq7f9lBfMwpegJfpjeaApNcaLiTz+CcZD3neElBBpW3trM93IuATJK0KwXGo6QdO7jnIhzVX5yajC77zMm6te3kUOmUfXVSzeUbOwM6fCpg3dG4vEUG7khKikfCcLq6wAUd9+6Ihd5SyxMiYAimyoWY5hdoS9PH6/kzFNEu7mLyU1hVkWgHAck4ABRi8xpF8IuZjpQ3kossyNUJOmlRFwO9l0YgsNWA5GovrqL4GGTVEu22QcD0EHo9xDvespWhy6EwBmx6fSwTOuKLlm7gf4Xg8zqymTXsM3dKYjfZzxySdalknnJc+ZFYqroAWEU1Is58AxlIxBgqnB2oq99NysToLcVjyU0RMJUtdhKWE8r67smHbfialbAHLuW/buyoKSzVY7ySYI5ur1hGNjEnLcz2QJujPQnoGBmarFp3qRQgSblblZ9WA6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When unmerging an address range, unmerge_ksm_pages function walks every
page address in the specified range to locate ksm pages. This becomes
highly inefficient when scanning large virtual memory areas that contain
mostly unmapped regions, causing the process to get blocked for several
minutes.

This patch makes break_ksm, function called by unmerge_ksm_pages for
every page in an address range, perform a range walk, allowing it to skip
over entire unmapped holes in a VMA, avoiding unnecessary lookups.

As pointed by David Hildenbrand in [1], unmerge_ksm_pages() is called
from:

* ksm_madvise() through madvise(MADV_UNMERGEABLE). There are not a lot
of users of that function.

* __ksm_del_vma() through ksm_del_vmas(). Effectively called when
disabling KSM for a process either through the sysctl or from s390x gmap
code when enabling storage keys for a VM.

Consider the following test program which creates a 32 TiB mapping in
the virtual address space but only populates a single page:

#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>

/* 32 TiB */
const size_t size = 32ul * 1024 * 1024 * 1024 * 1024;

int main() {
        char *area = mmap(NULL, size, PROT_READ | PROT_WRITE,
                          MAP_NORESERVE | MAP_PRIVATE | MAP_ANON, -1, 0);

        if (area == MAP_FAILED) {
                perror("mmap() failed\n");
                return -1;
        }

        /* Populate a single page such that we get an anon_vma. */
        *area = 0;

        /* Enable KSM. */
        madvise(area, size, MADV_MERGEABLE);
        madvise(area, size, MADV_UNMERGEABLE);
        return 0;
}


Without this patch, this program takes 9 minutes to finish, while with
this patch it finishes in less then 5 seconds.

[1] https://lore.kernel.org/linux-mm/e0886fdf-d198-4130-bd9a-be276c59da37@redhat.com/

Changelog:

v3:
  - Remove leftover code from previous version
  - Call is_ksm_zero_pte() only if the folio is present
  - Rename variable ret to found in first patch

v2: https://lore.kernel.org/all/20251031174625.127417-1-pedrodemargomes@gmail.com/
  - Use folios in break_ksm_pmd_entry
  - Pass address pointer to walk_page_range_vma private parameter
    instead of struct break_ksm_arg
  - Do not unnecessarily initialize start_ptep
  - Order local variable declarations from longest to shortest line
  - Improve patch 2 description (do not reference the cover letter)
  - Quite a few styling fixes and improvements as suggested by reviewer

v1: https://lore.kernel.org/all/20251028131945.26445-1-pedrodemargomes@gmail.com/

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>

Pedro Demarchi Gomes (3):
  Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to
    folio_walk"
  ksm: perform a range-walk in break_ksm
  ksm: replace function unmerge_ksm_pages with break_ksm

 mm/ksm.c | 137 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 82 insertions(+), 55 deletions(-)

-- 
2.43.0


