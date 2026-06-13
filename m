Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7843ACD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 22:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496E76B0005; Sat, 13 Jun 2026 18:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447886B008A; Sat, 13 Jun 2026 18:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336866B008C; Sat, 13 Jun 2026 18:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF016B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 18:15:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0E5A140501
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 22:15:12 +0000 (UTC)
X-FDA: 84876296064.18.22F9634
Received: from mail-dy1-f194.google.com (mail-dy1-f194.google.com [74.125.82.194])
	by imf15.hostedemail.com (Postfix) with ESMTP id E1EF6A000B
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 22:15:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fgoMuvPP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of enelsonmoore@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=enelsonmoore@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781388910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lF35aRux9Iz0wuMqz2nIPnJQBNpp+Q2EiADmco2quR4=;
	b=DJxgjC3JQZJvozJ3l3YN9Jh+q2rVRsbx16ZyWgmOBW0Fl7oAoquaI5B22NBaFcw5FvF1+Q
	nk7z4KtdSHcydaEk9ZCaTmxDPNsoM34/xFaMcTyY9ojIT/uBY6DbIQBt7//jomu2fR6zX3
	Fv9EuXHrenOFMlWnkAJ8EMEwq5AQwac=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fgoMuvPP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of enelsonmoore@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=enelsonmoore@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781388911;
	b=HXZiw4+itFbNHYJJDzCFNTaMEQR6bvzemj/Tfixh50ZDjFdruiRpC6+5vZZf9WqcZ0H2oe
	DnIm/JSUq8+zzkJa1LXAod0d7XQW0mPVdI9n9Fpq9ahILJs6RFDORTMWkEZHlQxH8OGi0e
	CLleULNfwGPTnbury6rqN37S3V2dyDU=
Received: by mail-dy1-f194.google.com with SMTP id 5a478bee46e88-304fb780deaso2298729eec.1
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 15:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781388910; x=1781993710; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lF35aRux9Iz0wuMqz2nIPnJQBNpp+Q2EiADmco2quR4=;
        b=fgoMuvPPi+7HfxGYNLtJm75XpAtr+dlB/97yPrPJtqQDZpBU9T1ukikxdYC3sgrnKv
         AtBJE8AoWRl38WqIUZw5qAPpLI5hkXn/VRxrbn3cnDMjVo+4rCbWu/Sq/fk8bNqEQBY3
         aQnM7CE9UjQIroeecYF6i2tD9gRuc478j6pKjH7u9HV/QfwZ+HNmUINY62d81cy5CzEk
         4afd8PxHDvo2yaZ+mMS6z34XevDa/HkI9fiPAKrBxZwJJcafXagw9Bz1BNi3BHT9tgFJ
         sRp5LRni1FWVtSd0Uhw7mTsmmlzK0hHgVx4aoOG8qMyq0uBhDRbsj9ndvMHoPKlPuAuj
         Ps3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781388910; x=1781993710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lF35aRux9Iz0wuMqz2nIPnJQBNpp+Q2EiADmco2quR4=;
        b=k3k3PbRmw4AF8dj6kT9T9dQuxNw0m6oTvJ+Hreyw9dPN+bJJGbgtcUnj36ANHWTVyR
         xV2EIivzyrFe/om6O8D4c+lWRlLjHeXD0M+e42uQraib/ZjWKurqWH/dofPMTxpEWkUI
         YhkWe3GHSSALmvRRNaGyInTgt9qsE7l+NrD3D1vsctjeE/SR//yzcz0jpgHm9keEvpuc
         QDol2Cvij/e7xMTRAGYhHQxls94BsRv/gnFhZtUGzFz63QGb/UNhdrgglnW+G18rdx8m
         MaFHAaxNfaVeyUL5QJ4f8PQ2bibIZbRrYoZEkX0Tug95/YxFOrD34ep0lHVVwsRhnYrN
         beFw==
X-Forwarded-Encrypted: i=1; AFNElJ+tp0kBkPIDhnvujxNnMMVDGZ5UHN4KVmbivJAA+GXlRuYlsWbaAFXp8Vv6Ij3ZpSA5iiolZAS6UA==@kvack.org
X-Gm-Message-State: AOJu0YwG+nWiV0X5bkbJ1l6/q2S7sDhY1Gd23g/SNQHJrS2WU1Rnmg58
	iIYOmhX6ITe084a22hpdBvOhnsQbHGPDj0djKeag4o9/L6ihA2RT/MfE
X-Gm-Gg: Acq92OGfCJDDnRaafUuJWg/f/T0DUVImH54PH/3LLsFD2wY3pzhdfroDwTc71yXfq+d
	QQe774indo8VxlIZ+PJINreFsA0XDrQS2EAHqVlMA+mEO8lrfaJP2fBWFgQKFNa1nkFVMMiYKfR
	XuvNxrHceXytmZpuQgWQnLY4I7Jq1wKBtdh3eLAY5CM9kxxtuWlzPGOz7QI26lxI4zDdrrRstv9
	XuMNI2sqTRrWqGVWRbUlTKD6UGnAYVR6YnwidaNHNdQ+3Gxzppgxrl8YDxPwjAw1P7g9WeTBWYZ
	R687LrkcCtIrFYhofR1F81n19RM3C8vELYabFqQxzFXrl+RID4ZWjJqS/njsGKpLBOIqmwZU0J7
	bxu6aTSSp+ippl4vlO9iTxZJo0GizNvD3l4S2wLAqe2c9AWA1Jy4/yrtY7G78c5yibOPIi7NDhz
	dCC1VI/ni3lW19va95jZwuhl36Klavi/p2h+jxqwU990TWawyOaMZDNNY7ayg3MWnone3psBNXA
	LD2t3NWjAEfABpRPNjEmWtRxP5o4bznM0em7m03LoYi2LWE+dbWwiDsAv675qcF1W7wYuz5qIwd
	Mx+b/d0deoRCvZ/YakTTLJmuNV9R
X-Received: by 2002:a05:7300:8b84:b0:304:e587:5063 with SMTP id 5a478bee46e88-3081ff7ca07mr4483226eec.12.1781388908835;
        Sat, 13 Jun 2026 15:15:08 -0700 (PDT)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081eb95342sm9077739eec.29.2026.06.13.15.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 15:15:08 -0700 (PDT)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] docs/mm: describe current criteria for enabling split page table lock for PTE tables
Date: Sat, 13 Jun 2026 15:14:47 -0700
Message-ID: <20260613221448.98657-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E1EF6A000B
X-Stat-Signature: 7o44grh9sy475u7tznqaqxp4z13omnzt
X-HE-Tag: 1781388910-971987
X-HE-Meta: U2FsdGVkX1814pIHPtnp26IEgVICBeeifzHfSvbQ024X4BY6q31qtLGnixXXfC2Zi8blvh5BAY+Mhlmof/zA4xovmC3ePwSCiMhkhYTA/c7NDBiNf+Tt/K9TgZEh7GSiZPohWQp3PjcT/r8UmNAbGF/fQGIjQQNyk+X/hMlWyJbe/XHGcqidFkxpwrQOmHKmuF8dtGSxNoEAUZ6FehgcreX69wKD0ISmXhnlg+oBQY8iwd2suZKYuXvMzqxxdKTtVCqqxacrqaFuj2ka14BX7V6k7HvVoq+eEI/k5bHT96D6ko11W/e/nXrFhxMsC8WOLjZMtdzmY0NcF7qmv86yd7Zgf0k2ulQhT2vY4G9fxIfyoC3rwu77Cy2NyZRUqWWZTIhfuB6aR71bkBHW+Qgw43kENHrY6x48F6v/TTDhzSNtxV9IihSgp7dHg/TD2mjud7mShWNBMqVqWPqaoAqBLY0N6pcajbC+IXkFRFQIAJkRQBKyx+VwkTBPVe42xsyoDjUmr9+TYAD8LTjsP4J+BMVe7mDpNnOuFT/8EBlYjsCVWb4V8qeKgNRHk2iOp1uqPtktrcB28Zaw6OJN6fEA6Xj6w9tUnIuF6kmIPRB4FgBPSp6G1dAXDLZ7e/NKSid9JBhiQInOC1dFQqY0rXNh5lOmp/YKIXo1cuqD0h3PzrbJLHZ2xP4U9n9fqDE7esfykh4V0ZGlsvUe1d4IHKBRjW8AepzWolMP/SLgCTKHrN8YOimlwiTHKJi7h/LwKS4iMiK1F3DOlGSjhU1+3fN0ZM+/CUqvRVPnf28KEGZs1JUms42e8xSYrukcytHqzBJI0CEPAzybPvU+oSndcLLEyRvxcj4+OjJjSkNC8wHQw+G24hujboUIKLIQoodcwDXD0k2pawlOIWux3Se516DbyVW8UATK/L/c/I0wzKwZrfwpejU9kVOve8LCW9rg+IdMJrSKbBEw3/VW0AkTj1r
 sYNDt3nA
 k7x4vZeI7gc5Kk56a7VeGI35I94sdhQIhtNo0b0ubniZifLmabBbIQgxtL0PXB35Mv5kPywpctHg+gqtH0Se7a3eTQYeBNcTTTITNsI5j+E2LaGHJuzwP27AwY3bCf2cRaV6Un1DJ/+0gKL9a/xXz6OhmAytc1dNgVADdRm5Uig0CjypkR+HnGhjr1LvUTFM0WJUnV+FdZxNOj2hbhvzhW1Pcy8r6XVoUYPsYgz4FgIdZimcng0rOJMdL5A9x21Q5yCodIUODFOWrHFNazv7Fb6CyWB1YHwgk5sm8xVF7N3ssaB8u6RFZjUpoKs64aG0anrQI2jcXiUUeQBQYSR0pkff48jDZbgKAUCs4JQ3UbFy+u9COWHWf4eBWvUUgnZG+dLrWQ0OXcvkFYeh2QuY2f81k6iNKnnvQJdiXlQZhecBxqCjrCLJVTcjU8hy9Hkeg7shSIoMyVi68cGYrtHmEfuQ34j4WYzEJBx0otJ2Okd6PYx2Htkjy/kf+Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mm documentation regarding split page table lock for PTE tables
refers to the CONFIG_SPLIT_PTLOCK_CPUS config option, which was
superseded by CONFIG_SPLIT_PTE_PTLOCKS in commit 394290cba966 ("mm:
turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig
options"). Update the documentation to refer to the current option and
document the situations in which this feature is not supported.

Discovered while searching for CONFIG_* symbols referenced in the
kernel but not defined in any Kconfig file.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 Documentation/mm/split_page_table_lock.rst | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/split_page_table_lock.rst b/Documentation/mm/split_page_table_lock.rst
index cc3cd46abd1b..c9d16024543b 100644
--- a/Documentation/mm/split_page_table_lock.rst
+++ b/Documentation/mm/split_page_table_lock.rst
@@ -37,9 +37,12 @@ There are helpers to lock/unlock a table and other accessor functions:
  - pmd_lockptr()
 	returns pointer to PMD table lock;
 
-Split page table lock for PTE tables is enabled compile-time if
-CONFIG_SPLIT_PTLOCK_CPUS (usually 4) is less or equal to NR_CPUS.
-If split lock is disabled, all tables are guarded by mm->page_table_lock.
+Split page table lock for PTE tables is enabled compile-time (via
+CONFIG_SPLIT_PTE_PTLOCKS) if NR_CPUS is greater than or equal to 4 and an
+MMU is being used. However, it is not supported on ARM processors with
+virtually indexed, physically tagged caches, PA-RISC processors older than
+the PA-8000, or 32-bit SPARC processors. If split lock is disabled, all
+tables are guarded by mm->page_table_lock.
 
 Split page table lock for PMD tables is enabled, if it's enabled for PTE
 tables and the architecture supports it (see below).
-- 
2.43.0


