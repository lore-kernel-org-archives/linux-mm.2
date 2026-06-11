Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE754CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 446296B0093; Thu, 11 Jun 2026 11:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D436B0095; Thu, 11 Jun 2026 11:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3340A6B0096; Thu, 11 Jun 2026 11:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 245256B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:57:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D52941406F9
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:57:48 +0000 (UTC)
X-FDA: 84868087416.14.1C79B2C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 75F801C0012
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:57:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bkaPjTca;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781193466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CaTVBIrexKm22hRMB++bwqNcNQ1H7GPFCEOimwy1d5I=;
	b=lPOIAwQPBHViH7FVRaJTJsnmvo5O+16S3UAu9HXspKa90UgwoH30nALA2k27XfXwajwv9d
	DG0WjQ7MbUhAHqy+I1AUGO5ZyDk2IjFUyCm3mRU/CGBedObV5nseceCvRWDGYNnwSLkzwD
	r5IK+z33iS/g44kkbLgpOTnErTlWvhE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781193466;
	b=cx4sNyFGUpEM4/A5rOWEEox8xvHtuwTBMDaLxPrTA6UmwHVmQVI7VJ0BXXuyy8Z2A0O3GE
	ZLauDUfNvBuhkeNlMTyPBkjZ/YK2NIuxeWITp+KBNKMTC1NR2JqdBP6tf3yav21/yYJqze
	iLZVR+eAs9RTlIH2J5gyIY1+Cwem72Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bkaPjTca;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781193465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CaTVBIrexKm22hRMB++bwqNcNQ1H7GPFCEOimwy1d5I=;
	b=bkaPjTcaz/CuhGg3GJZmEtzdX3Ujn+UGGXbjrXNPaPgwlPbntr0DXoN+7YD4AowZ2t4wWh
	sfe92c5JMuaL4nglrqMzVu+Ecc+J+0qKu/7hMBA60RsgCfHXjlqr/TPmQWAX0PDzo1szLR
	pLBEBdUV60zqo0lMguTiBw9gGC3VxRw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-_3uaU3pPPX-8tz-6YCcP0A-1; Thu, 11 Jun 2026 11:57:44 -0400
X-MC-Unique: _3uaU3pPPX-8tz-6YCcP0A-1
X-Mimecast-MFC-AGG-ID: _3uaU3pPPX-8tz-6YCcP0A_1781193463
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490cc1ae292so158605e9.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781193463; x=1781798263;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CaTVBIrexKm22hRMB++bwqNcNQ1H7GPFCEOimwy1d5I=;
        b=Fz2Hz4m4kBMZmaeg955Ag6QG9AQDO/v6gMd2fh4I6dWk8LmM/x7JItj4QtxKqwwboi
         K+IdE2H/h0cxLUUoijndyNcBMOIpXfFRZa7lVu8lv1wMvO1xRjOuAIMAFUGTtoQNMnjd
         xZpvvkLq3Zw659XpX5cBZWPZlqwQzVzI3nxDO9pb41lK3rSuaCJSr3s+1opCUbAJG0Rh
         Ttjv2vKi/spvKb0PDyJUlxpcdyhN8TQvFCdXt+vsHkEuvGV0+rtO8c9t+Ls3vHhpXiI/
         Wm8o1Bxi1WXDOqFzdVmCIEo2kIXix3hFnbDQle9St9LlL9Mk1kZxW3wiqupkcSLk5w4I
         6Rgg==
X-Gm-Message-State: AOJu0YzjmvbsSb+JFe83XmziOnQAx5CkGXOloP4srrH2nCV1YnC8y24i
	WldQUQ4Y5ncxJmvNEGG9qPxhAAH1g2adWQrr2yC8PynwBYXqQNduDCNw1YurEzr+9SYFtoHbV/T
	Qul0RQNZgS8Ea4VcHkchV7xzdyskQp/gjIRaWWgGhVepSQsLHYDUNAAHdpXyh62zltO80M4UI7B
	1lWTCeBvLHc7AfZrAayiKaNqixXVInlzWzhQ==
X-Gm-Gg: Acq92OHwLRLoKK0oLXKRlq0WmUT3Sz7XTiW9Ny8ZOraS4Tfgs+3WQLGahC970XfTnDg
	FJBrfZ4hIpLkjcx4qhcy/m4scxcEQ5q4gdLvlnOqsolAS6LRsQbuZaNyvJwK9bl4h3dmk/7goDV
	/QdCxUzV4Ini8rrZGv0xW1/I6I1gGAi/t0rSwdFLHB0BMTw/ehgwFZhWShiCZGurtstOF/hSxXo
	GeIU6HbsJMmEuXjFGqHmeRThVT1frtYnglfE7K7Hc3DBMXA3jGbdRD6sIKInjhM3FkklqTHe7vQ
	QCFHTEd80ZkjPyYStAnU9GnKf0ov1hm6r20MlstJcPfN5UgJEmprlmpicYNUwm5Eg6cV4GULbSs
	xZ8vKEaLLgnn5V5hl7MY1VnXZ6FR3ZGP0Zbcqu34OA8qBPrMiOCgIgdT/D9bO8b1IDWik4P7HNf
	Y=
X-Received: by 2002:a05:600c:3ba7:b0:490:9dc3:3483 with SMTP id 5b1f17b1804b1-490e52cad04mr42831665e9.2.1781193463255;
        Thu, 11 Jun 2026 08:57:43 -0700 (PDT)
X-Received: by 2002:a05:600c:3ba7:b0:490:9dc3:3483 with SMTP id 5b1f17b1804b1-490e52cad04mr42830875e9.2.1781193462659;
        Thu, 11 Jun 2026 08:57:42 -0700 (PDT)
Received: from [172.31.99.182] (91.red-83-48-118.staticip.rima-tde.net. [83.48.118.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2c7ead0sm84150385e9.3.2026.06.11.08.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 08:57:42 -0700 (PDT)
Message-ID: <c5401e8d-0b46-4cc0-88b3-f438d610e73b@redhat.com>
Date: Thu, 11 Jun 2026 09:58:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Nico Pache <npache@redhat.com>
Subject: [Bug Report] Elevated PMD nr_anon after running selftests
To: Linux MM <linux-mm@kvack.org>, linux-kselftest@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, linux-cxl@vger.kernel.org
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5iNQtTzFfXhjiWiT1bdnmxhebGbXAXyk3Ww0Aws3mZc_1781193463
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 75F801C0012
X-Rspam-User: 
X-Stat-Signature: rbecow4ddzpbmq8r5dsj6qaehmdnudos
X-Rspamd-Server: rspam08
X-HE-Tag: 1781193466-771104
X-HE-Meta: U2FsdGVkX1/t9KbItfh9yXwUjhk74PCdOVzotssaaV0MKiimlQpvH44DXUwCVQq/YkZcxKl99KwA66ZWO7AG6MDh0Ft6nf5udrtAfHEHsCqHp8dNLAu251Dzl2uS9/Lfu8KDlUiGPv0jVcb8RcbkQ07G4OUO1JnVTIVcZtYFcSer2Fb7eFKxABUDo2cuqzOEQNmK94Hr3/y+8R6MAdyOengk0swEh1SsCDVx6SKRboBNxdMgpmaGTAEMsI0zDikX0Kk4KrHOiIo4GbRaS0w2ulWAZrnCUaHZPuLAStV9yf3zV4YApr5H8NbFoOUIrpFF//P6OU9HeEEOVChBbxzd9z0tdDHyAWzjdlwbQppaBX2Lbi8gpgkYdEahSvLUYnxcTBZLWzcdlW/xIqp9PSoTQcly6tgDBih997KNUJZwWPmA3aO7hT0LoiY8tHtcDUh7dRu1cdxYCLprkw2Ap90k5RSfc9hcvx5Fx+majQxmhQ9ncrKzlcIpiXlQgIi9+rZw5njfmF83TodNLeMcj8GE4iixQGnsK4a8C1ZhQIMRopvp4gsjwl6WmC+KXf3hj43qxN2naQF8bUlyO3rTcifRrV9cj7NGV59ZuUFl+No16FW1fEoqu+wN++qrp3zJm2sqgSztqmdPw6Ay5eQ3DXsnEq8Dj5gOwKhvCA6cec49KFVt6vYkdjrTpMIJMBoHtKvt3xDI/5bq3Abyfp3AAXDZQGS/w6MULACqzSBQhv6SMmd/sE4D14V+vHWH5TochnDq4YbO2S1ZavWsyXmy0Z+L+a0NZHaimoqSDjfq0s2eCkW3pKAzk5BOjJO9jS1SK4WfCJGBKQqBIf5EGV4SQesFYWKoTrNskyBfv1/8aE/NTcDTjjscNWkSpJau/a7zmVmxvyExPDDg6VDFIMFdNPTu2lgcb0vcyV+o27y9bEIHN3WMkqwTm8wRgdK/JF12OeyMVQlPzfNDj9wEboEaEFi
 XiVl24jb
 iZbskkXUlcPYNbtownAUujWr2SAKpXqCBn4fVIueptfXEjyOMTc2eLpr7LkowsF2M9asVxCTLx6e060xxmus1y5ttNlFI/uss10i8vytXK1FEqRw2MbQ2gevDqrvTP1513uB7HgkEfCQG5hfK4RNXpsAFpIlQzswClgxyDETPxlfcQ9A57ZMWf4qZA6WL60ZewkK1mlY0dQjubrH8u5EXCGTR1zk5P22uomzI6/mQc0IekSy1K2MmlTYc+M/2PYxZ1ijWD2iLg+UmuzxvsNafCOCYBLDnVYTMp1y7O8NzXVt5+ZRde86gFEBBxIqH1CeF7IPmQUlfOUYe+5gACNPS26eQjasCOOSaKfcSuvESO4ZwolAqEBo7bXHgQm67wvKOvOaeKiE++yCAJaWl8O41D548U0kCMJl2A3ZosKm0LDzcvz8BjWQAsWLI+PMKQRB9Zw/kNl74eyA0VqDXJd+sSoe14e63HJotfXCifeaUdwb7wXyehYnG2lLmXj6i50G2p5NNqr6r3AFW+XzLybvKFAmnqz+AtFT3rBCg5U7JT1ffWy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

While testing my mTHP code I noticed that mm selftests caused an accounting error in
/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/stats/nr_anon

At first I thought I might have caused a regression, but when retesting with 7.1-rc5 (without my code), the issue was still present.

This issue occurs in two mm selftests:
1) hmm test
2) migration - private_anon_htlb test

I spoke to David about this and he suggested the following diff which seems to have solved both issues.

David would you like to send a formal patch or patches?

Cheers,
-- Nico

Diff for (1)

diff --git a/mm/memremap.c b/mm/memremap.c
index 053842d45cb1..683a77dd679d 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -425,6 +425,7 @@ void free_zone_device_folio(struct folio *folio)
        mem_cgroup_uncharge(folio);

        if (folio_test_anon(folio)) {
+               mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, -1);
                for (i = 0; i < nr; i++)
                        __ClearPageAnonExclusive(folio_page(folio, i));
        }
-- 
2.54.0

For (2) he suggested

diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716..9fd50ea25d2d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -590,7 +590,8 @@ static int __folio_migrate_mapping(struct address_space *mapping,
                /* No turning back from here */
                newfolio->index = folio->index;
                newfolio->mapping = folio->mapping;
-               if (folio_test_anon(folio) && folio_test_large(folio))
+               if (folio_test_anon(folio) && folio_test_large(folio) &&
+                   !folio_test_hugetlb(folio))
                        mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
                if (folio_test_swapbacked(folio))
                        __folio_set_swapbacked(newfolio);
@@ -623,7 +624,8 @@ static int __folio_migrate_mapping(struct address_space *mapping,
         */
        newfolio->index = folio->index;
        newfolio->mapping = folio->mapping;
-       if (folio_test_anon(folio) && folio_test_large(folio))
+       if (folio_test_anon(folio) && folio_test_large(folio) &&
+           !folio_test_hugetlb(folio))
                mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
        folio_ref_add(newfolio, nr); /* add cache reference */
        if (folio_test_swapbacked(folio))
-- 
2.54.0


