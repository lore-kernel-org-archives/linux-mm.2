Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C39C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 21:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2756B0088; Thu,  9 Jul 2026 17:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9BB6B008A; Thu,  9 Jul 2026 17:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEB76B008C; Thu,  9 Jul 2026 17:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF0DF6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:08:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 516098D03E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:08:07 +0000 (UTC)
X-FDA: 84970475814.06.733481B
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7FE26A000F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:08:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gxVzJfCu;
	spf=pass (imf25.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783631285;
	b=erM9b+fP/CvPwrej0WcnOR02Pr4IjVf0zK3vLdZtMVMVGlpaKuTuzhSpcXmFdWQ1g28Kkn
	RQnEs403JtvmC/ieEyiM4DM+fBR4Igl1BDLmn8sC8rvM3OV8wEzDK/RfWQP2rMVIwbM0Wk
	2GjzNXqILNu/cu+UaSYXmg/qL85ax8A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gxVzJfCu;
	spf=pass (imf25.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783631285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V0KVGZRCHe3lhMIcIGEFuk1MRndt1TvP4zvcKQxYCUs=;
	b=iyGmfZ1ja3c5nUL0xlHyWZyB1DOSSfBbmv1CLmZsKDgZaAvst1xQl64NUCZDfkxPGpxqts
	bo8rlg1EXaOLfWKmLAXxExipus4Bg/hgs9EFR1IW/zrKZ3Beyiu9NnHQbB0YtCt2b+qpCL
	wce/umH+RhOZ2tH9b195uvkb2B/+OBA=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47d6c634f45so199219f8f.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 14:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783631284; x=1784236084; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V0KVGZRCHe3lhMIcIGEFuk1MRndt1TvP4zvcKQxYCUs=;
        b=gxVzJfCudAfID/5K6krLyvSa0LthyLCViI+K2ajd+T3sKcZydRz2Kkk0gWth/eViKJ
         LTd1/A20LlRt+s8Ew60q0ycUZHCLMNWy4qajcoJoMEo6ogZwHbIFVfRChhPrvAH1kdAo
         mTaT4kwr8VxZCmonpmnDZQtWcSDgAcO30xaVI3WhN4bQ+XVXloxHJFgbeRWSiHO7GcC1
         X32hCMN9tMwzllTvWIVjPp1adjX1+AhKi/dkL8yUO5v1ua0IDkO11GpvDLTe7ZEhVNBJ
         sfdQ4tTKhMu80U7R6SOSOnRJSuSuR4/Q5EHzaCuUYrlP2eDRslDFR3eDZBATHJIy7el2
         5P3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783631284; x=1784236084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V0KVGZRCHe3lhMIcIGEFuk1MRndt1TvP4zvcKQxYCUs=;
        b=aAhy1Wq4lIuMSGHS6OZV5dQGDjOzslL4jQzM6CU2KfkI5jOHhOH565UVE44rX1J6z2
         6jg19/zoVwN+FfsZ6BwOIPRIyy6Mp733L1gFHbdGQejE1+Lz9cWVE78T9FA+bYCQIsk6
         zpRkjdLo+y617fuC68330syF9y38JAc1dFDTAwRh//ylI4UYHIZDLMUJg33G1rcgSXdK
         EwUxhv8TmupG+RqauZWteoopYAg90dzcOZbVlGsGxNOfMANnPeZpoqaA38anzst1HnRp
         BPlBTAcUC4Nw953yLTchfm8blEPz+faqCXSYC+jT9ZpBycpeB9HPQirTB9lEhzjb5J1B
         2rCw==
X-Forwarded-Encrypted: i=1; AHgh+RrrE7zTVXNlD38qA4oL1Qq7Ar0RTBDJScrU88MNotZh0li0mlwLceQKahn1IyXuNlomI8cF+MsJCw==@kvack.org
X-Gm-Message-State: AOJu0Yxmj/Nqw1+LohvrAf8PD8Zry0OaeQLkVCaZYHVRbkXjxjoExjN2
	bEeqz6poGGqqI7En7cZloUgiT9KGJs98FKAx2IvVQVzksrXmiFGZdQVm
X-Gm-Gg: AfdE7cn7IPS0qRjv88+AsJ6UIElwIEKegVjECZLnsnxzm7vA83KK1tOJorRmu+D+0zy
	xJgcfwZUMrDnnv0NmIqKzZGMzGXdaXIiMToCl8Ohz77x1Ms7JDStyxQ3Gp/GxL3YxbEBq3+fNfI
	Gbbb3kEgBpRl89Z2fuA3j9ZSTtMepjMp4ENUIzb1vZ7IOvxxWS6zAiJQ3g/1hLwqChMSB3+LpR7
	5trMfxMlyOFr9TiuXGSV5KxM/5xZ4uT6pwFXaVy6mPVyMPKjtqx6z+4s6pS0LCz6pTstPTnwIcd
	OJYUSJTeB51FbSDrWmc8a405tTMwztARQ2UGrbxHEU7ToY3IAjni0x2vJG1AuAPyaH4rJBByBvS
	7oN9rIQVKmwFbxt/QlCG379CHafEa9jndqDkqW6C/4s+dvxIm76cS0eIEsemaJ7saXGvD1CQa04
	lfKvVc5hxrzoGz70mCDfyuABeHQMKLLlZCZO9wX4jR65DGn1KbN250kUYKJR3dyv7voT4fb5nzO
	hZxidBAMLjoa0+be0DDPw==
X-Received: by 2002:a05:6000:230d:b0:474:8aad:2e0 with SMTP id ffacd0b85a97d-47df071c082mr9354691f8f.9.1783631283658;
        Thu, 09 Jul 2026 14:08:03 -0700 (PDT)
Received: from localhost.localdomain (stev-08-b2-v4wan-169520-cust2225.vm32.cable.virginm.net. [81.98.232.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d8410sm55607342f8f.15.2026.07.09.14.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 14:08:02 -0700 (PDT)
From: shijujose2008@gmail.com
To: rafael@kernel.org,
	bp@alien8.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	dferguson@amperecomputing.com,
	linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	tony.luck@intel.com,
	lenb@kernel.org,
	Yazen.Ghannam@amd.com,
	mchehab@kernel.org,
	ashok.raj@oss.qualcomm.com
Cc: jic23@kernel.org,
	linuxarm@huawei.com,
	rientjes@google.com,
	jiaqiyan@google.com,
	Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com,
	naoya.horiguchi@nec.com,
	james.morse@arm.com,
	jthoughton@google.com,
	somasundaram.a@hpe.com,
	erdemaktas@google.com,
	pgonda@google.com,
	duenwen@google.com,
	gthelen@google.com,
	wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com,
	nifan.cxl@gmail.com,
	tanxiaofei@huawei.com,
	prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com,
	kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com,
	shijujose2008@gmail.com
Subject: [PATCH v22 0/2] ACPI: Add support for ACPI RAS2 feature table
Date: Thu,  9 Jul 2026 22:07:48 +0100
Message-Id: <20260709210750.424659-1-shijujose2008@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7FE26A000F
X-Stat-Signature: 8f53k93jakp8xftb3eotek8exks9abiz
X-HE-Tag: 1783631285-840281
X-HE-Meta: U2FsdGVkX1/D5+CubY6+5iUP36d2IQAPruWbpQeT2fW+LuiVeFi0Z7r2cGLNr4lMCRAtZWoevOClV7VTVtP2rglk2e3a2OjmH/3kBI/vCxsoMNN9SJb9VjJVJpsrsKVskphJNjVMOyPZkigDgRWi1nljENiCSdG1gV1xlMST2rVw8LPWedI+1bUoDL4XqfuHWCLM6JtBwGdHEjub+ZY51nnOHxxWLPvBKxtnBeXVhRvMlndPf+DuquASjeWuj3nEARY9mt5VuLU9riIN9+m0faAmUhHO7XZFfqPdbACgj8E3PvpePikDpABwQIadke2a61jZ4rAq3OuKYOGpiysqZFJYGa2fmxgcZWDUjVv91sBR/pup0swecQgXHbwkx60Fm0mw+kDUpLBnRLiOuIQ1brdiy+4/7AFYGSY93jjY6TKGDRxuQaXx/KTvjmh8uSmwS5Qa/NW8HqS8eZRl8PX8zPguWa4FjHQUYknPEHKBMhjFWi8QImKp2ueJu9QMbTf24noCICa35+S9vVjyaD5GZuF0ZaX6sVuEW+9Pn4O7Tnji/M75qp4hcAkFZH91bZ7l0lwtHirMPjnwEidq+/WznRV73+rFoi4t/bHyp4mkJEN7o+06L+H4Ul07xsL6bfUfUvNeb9atnEkM2k9OFrv/66QY45I/oq/zXEIjnwHlAdMID8sFJSlfDh2ug0smSFG6PlA0GxhDVrUArSi6VSHj3eG1qXA1RTEicPuCk01yZx2+2Zq87XZ9zvMS4JB5y3NQoPsh3Gtsb8iDpvvKgRxSPXaIZ1m5Myph69tHammuSG0t9Gl11qAnNi5BLJ+WiyLdV8kSvrUw+pB1cn2SwlRSN7EohL4q7CzO4/KM1epQIgdpuO1FHci1IsdxIvbHJ8FbDQO3jERviVdBaBrHgonhnCKQfVWPdEVdv8f0G4kpo0nzBPTd+g5jfpLUt6eFyDjjS5eO0BYPZ3WKKW8qpDk
 Rs2S8ZWF
 Qd8wkwFt6tqqSouO2Ron+zUmIgB4m9kA2qDqya9AvWMjfFumCG9dFmDVkoyx4fXgjPif6KObi/R8RGnKBsft1ewlXNLtOUhUoMeVUCdJraNVPHfetNcJjn/loAMFtO9/mtK2n6kHWKgU+XCMd7UTLVmpgig1MHtQAwvrtM2H/bfqI4QZlN2h1XU+xkkMumf/lHWOeLtgW2JFgak8mr6otoXi847bd6Dcu5sb0cDi3HiU1xlAuT2ovSQrruJBKDg+cxMJA0S9U7FD3zF7Vt9qU+3kTbqAX50MXxQY5rdlhqz/oY1m70IwckpvgCg+BKyBNrGoG5ryEFUX/uimGdf86Sa9Z2fbl3lBcuIeD8X+tOK+3QTDT/kGOyvOlOQuNyFg0d0eZ5qcWmYaUJ/0POaDjuSMedEOykIORMqI3gIfxn19Hi84EHF6o1FN/er6GRSqj1CA3B233Bix3cC2PqrvsE2WPWWFONeb6DSc6NM6GvxxaC08n2+w1hAQ3zXS3Jl2iEaPlZ2a7koUFSLVALFfC67q6GemX0gpNhCA5DStDe9/Mdh5VNjXsPRe6rbfJZxk+qq+wLu3VXfzcEcmbOA1CXi2VtkZhKmKmgb35mua2Zn4AtwBCgETXsckLSX3a97JWylhkvICFFwAT/adhEaIPh6k3D/8Vex6vBrGgZNSzstdbFf01+6FGwN71kpW+tNJYw5wpzXMukC/sNIRpJnxIlgVCy9pZ6fBJVw4lRm+KzbPucBuVafGNu/PI30jFaBn0HYsB+hcfIvHhi3KKheikTb8A0ZYO7G9vYWHeWBU5JmUmvxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shiju Jose <shijujose2008@gmail.com>

Add support for ACPI RAS2 feature table (RAS2) defined in the
ACPI 6.5 specification, section 5.2.21 and RAS2 HW based memory
scrubbing feature.

ACPI RAS2 patches were part of the EDAC series [1].

The code is based on linux.git v7.2-rc2 [2].

1. https://lore.kernel.org/linux-cxl/20250212143654.1893-1-shiju.jose@huawei.com/
2. https://github.com/torvalds/linux.git

Changes
=======
v21 -> v22:
1. Fixed following issue with mutex_init for pcc_lock reported by Ashok Raj. Thanks.
https://lore.kernel.org/all/akx2wqr3ULcmpCmc@hu-ashoraj-lv.qualcomm.com/

2. Added fix for some of the gemini AI reported issues and added comments for the
rest of the issues.
https://sashiko.dev/#/patchset/20260706000338.362421-1-shijujose2008%40gmail.com

3. Rebased to v7.2-rc2. 

v20 -> v21:
1. Added fixes for gemini AI reported issues shared by Borislav. Thanks.
https://sashiko.dev/#/patchset/20260704220745.110773-1-shijujose2008%40gmail.com

v19 -> v20:
1. Added possible fixes for gemini AI reported issues shared by Borislav. Thanks.
   https://sashiko.dev/#/patchset/20260408172850.183-1-shiju.jose%40huawei.com
   Unfortunately could not get a local sashiko review setup to verify the fixes
   before posting patches.

v18 -> v19:
1. Fixed gemini tool reported issues sent by Borislav. Thanks.
https://sashiko.dev/#/patchset/20260325165714.294-1-shiju.jose%40huawei.com
 - Replace with iowriteX() and ioreadX() for reading fields in RAS2 shared memory
   tables throughout patches considering big-endian architectures. 
 - In ras2_send_pcc_cmd(), add extra check for non-zero last_mpar_reset,
   changed time_delta to s64, add lockdep_assert_held().
 - In register_pcc_channel(), handled case of pcc_chan->latency is 0
   and fixed timeout of 0 to readw_relaxed_poll_timeout().
 - Fixed double free case When auxiliary_device_add() fails, the driver calls
   auxiliary_device_uninit(&ras2_ctx->adev).
 - In parse_ras2_table(), add check to verify table length is large enough to contain the
   num_pcc_descs elements it iterates over.
 - Add some missing cases to acquire pcc_lock, such as ras2_hw_scrub_read_addr()
   and ras2_hw_scrub_read_size(). 
 - Removed clearing base and size in ras2_scrub_monitor_thread() when demand scrubbing
   has finished, to avoid clearing the user set values, though chances are very little.
 - Add new field set_scrub_cycle to ras2_ctx to avoid user set value is being cleared when
   ras2_update_patrol_scrub_params_cache() is being called. 
 - In ras2_hw_scrub_set_enabled_od(), redesigned to avoid prematurely restart the background scrub
   due to race condition in ras2_scrub_monitor_thread(). 
 - rename ras2_probe() to ras2_mem_drv_probe()
 - add ras2_mem_drv_remove() and call kthread_stop() to stop the ras2_scrub_monitor_thread().
   However unregistering the EDAC device which registered in the ras2_mem_drv_probe() will
   automatically happen in the EDAC via the devm_add_action_or_reset() in edac_dev_register(),
   edac_dev_unreg() and edac_dev_release().
   
v17 -> v18:
1. Fixed few AI tool reported issues shared by Borislav. Thanks.
https://lore.kernel.org/all/20260312165247.GSabLvX5DjzhDtmyuh@fat_crate.local/
2. Re-add support for user setting scrub address range for Daniel's 
   reply in v16, which was removed in v13 because of request to simplify the code and
   with the expectation that the firmware will do the full node demand scrubbing and
    may enable these attributes later in the follow-up patches.
   https://lore.kernel.org/all/df5fe0ed-3483-4ac5-8096-447e4e560816@os.amperecomputing.com/

v16 -> v17:
1. Merged all changes suggested by Borislav.
https://lore.kernel.org/all/20260126171552.GJaXehSJp33nFnpvVd@fat_crate.local/
2. Changes for Borislav's feedback "Add remove_aux_device() which unwinds everything
   add_aux_device() does for all those devices".

v15 -> v16:
Attempt to modify throughout the code and logs for the below comments from Borislav.
Thanks for the comments.
https://lore.kernel.org/all/20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local/
https://lore.kernel.org/all/20251231131512.GBaVUh4NSWqvr2xhbM@fat_crate.local/
https://lore.kernel.org/all/20260119111701.GBaW4Sres045xnfkpz@fat_crate.local/

v14 -> v15:
1. Incorporated new changes suggested by Borislav on v13.
   https://lore.kernel.org/all/20251231131512.GBaVUh4NSWqvr2xhbM@fat_crate.local/
   
2. Rebase to v6.19-rc5.

v13 -> v14:
1. Modifications for changes wanted by Borislav.
   https://lore.kernel.org/all/20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local/

2. Changes for the comments from Randy Dunlap 
   https://lore.kernel.org/all/4807417b-a8f7-47a3-b38a-94ea7bdbf775@infradead.org/
   https://lore.kernel.org/all/af7b6cdc-c0a7-4896-ba6b-6bb933898d37@infradead.org/
   https://lore.kernel.org/all/26083ba9-1979-4d14-8465-3f54f2f96d23@infradead.org/
   
v12 -> v13:
1. Fixed some bugs reported and changes wanted by Borislav.
   https://lore.kernel.org/all/20250910192707.GAaMHRCxWx37XitN3t@fat_crate.local/ 

2. Tried modifying the patch header as commented by Borislav.

3. Fixed a bug reported by Yazen.
   https://lore.kernel.org/all/20250909162434.GB11602@yaz-khff2.amd.com/

4. Changed setting 'Requested Address Range' for GET_PATROL_PARAMETERS
   command to meet the requirements from Daniel for Ampere Computing
   platform. 
   https://lore.kernel.org/all/7a211c5c-174c-438b-9a98-fd47b057ea4a@os.amperecomputing.com/

5. In RAS2 driver, removed support for scrub control attributes 'addr' and
   'size' for the time being with the expectation that a firmware will do
   the full node demand scrubbing and may enable these attributes in the
   future.
   
6. Add 'enable_demand' attribute to the EDAC scrub interface to start/stop
   the demand scrub, which is used for the RAS2 demand scrub control.

v11 -> v12:
1. Modified logic for finding the lowest contiguous phy memory addr range for
NUMA domain using node_start_pfn() and node_spanned_pages() according to the
feedback from Mike Rapoport in v11.
https://lore.kernel.org/all/aKsIlFTkBsAF5sqD@kernel.org/

2. Rebase to 6.17-rc4.

v10 -> v11:
1. Simplified code by removing workarounds previously added to support
   non-compliant case of single PCC channel shared across all proximity
   domains (which is no longer required). 
   https://lore.kernel.org/all/f5b28977-0b80-4c39-929b-cf02ab1efb97@os.amperecomputing.com/

2. Fix for the comments from Borislav (Thanks).
   https://lore.kernel.org/all/20250811152805.GQaJoMBecC4DSDtTAu@fat_crate.local/

3. Rebase to 6.17-rc1.

v9 -> v10:
1. Use pcc_chan->shmem instead of 
   acpi_os_ioremap(pcc_chan->shmem_base_addr,...) as it was
   acpi_os_ioremap internally by the PCC driver to pcc_chan->shmem.
   
2. Changes required for the Ampere Computing system where uses a single
   PCC channel for RAS2 memory features across all NUMA domains. Based on the
   requirements from by Daniel on V9
   https://lore.kernel.org/all/547ed8fb-d6b7-4b6b-a38b-bf13223971b1@os.amperecomputing.com/
   and discussion with Jonathan.
2.1 Add node_to_range lookup facility to numa_memblks. This is to retrieve the lowest
    physical continuous memory range of the memory associated with a NUMA domain.
2.2. Set requested addr range to the memory region's base addr and size
   while send RAS2 cmd GET_PATROL_PARAMETER 
   in functions ras2_update_patrol_scrub_params_cache() &
   ras2_get_patrol_scrub_running().
2.3. Split struct ras2_mem_ctx into struct ras2_mem_ctx_hdr and struct ras2_pxm_domain
   to support cases, uses a single PCC channel for RAS2 scrubbers across all NUMA
   domains and PCC channel per RAS2 scrub instance. Provided ACPI spec define single
   memory scrub per NUMA domain.
2.4. EDAC feature sysfs folder for RAS2 changed from "acpi_ras_memX" to  "acpi_ras_mem_idX"
   because memory scrub instances across all NUMA domains would present under
   "acpi_ras_mem_id0" when a system uses a single PCC channel for RAS2 scrubbers across
   all NUMA domains etc.
2.5. Removed Acked-by: Rafael from patch [2], because of the several above changes from v9.

v8 -> v9:
1. Added following changes for feedback from Yazen.
 1.1 In ras2_check_pcc_chan(..) function
    - u32 variables moved to the same line.
    - Updated error log for readw_relaxed_poll_timeout()
    - Added error log for if (status & PCC_STATUS_ERROR), error condition.
    - Removed an impossible condition check.
  1.2. Added guard for ras2_pc_list_lock in ras2_get_pcc_subspace().
        
2. Rebased to linux.git v6.16-rc2 [2].

v7 -> v8:
1. Rebased to linux.git v6.16-rc1 [2].

v6 -> v7:
1. Fix for the issue reported by Daniel,
   In ras2_check_pcc_chan(), add read, clear and check RAS2 set_cap_status outside
   if (status & PCC_STATUS_ERROR) check. 
   https://lore.kernel.org/all/51bcb52c-4132-4daf-8903-29b121c485a1@os.amperecomputing.com/

v5 -> v6:
1. Fix for the issue reported by Daniel, in start scrubbing with correct addr and size
   after firmware return INVALID DATA error for scrub request with invalid addr or size.
   https://lore.kernel.org/all/8cdf7885-31b3-4308-8a7c-f4e427486429@os.amperecomputing.com/
   
v4 -> v5:
1. Fix for the build warnings reported by kernel test robot.
   https://patchwork.kernel.org/project/linux-edac/patch/20250423163511.1412-3-shiju.jose@huawei.com/
2. Removed patch "ACPI: ACPI 6.5: RAS2: Rename RAS2 table structure and field names"
   from the series as the patch was merged to linux-pm.git : branch linux-next
3. Rebased to ras.git: edac-for-next branch merged with linux-pm.git : linux-next branch.
      
v3 -> v4:
1.  Changes for feedbacks from Yazen on v3.
    https://lore.kernel.org/all/20250415210504.GA854098@yaz-khff2.amd.com/

v2 -> v3:
1. Rename RAS2 table structure and field names in 
   include/acpi/actbl2.h limited to only necessary
   for RAS2 scrub feature.
2. Changes for feedbacks from Jonathan on v2.
3. Daniel reported a known behaviour: when readback 'size' attribute after
   setting in, returns 0 before starting scrubbing via 'addr' attribute.
   Changes added to fix this.
4. Daniel reported that firmware cannot update status of demand scrubbing
   via the 'Actual Address Range (OUTPUT)', thus add workaround in the
   kernel to update sysfs 'addr' attribute with the status of demand
   scrubbing.
5. Optimized logic in ras2_check_pcc_chan() function
   (patch - ACPI:RAS2: Add ACPI RAS2 driver).
6. Add PCC channel lock to struct ras2_pcc_subspace and change
   lock in ras2_mem_ctx as a pointer to pcc channel lock to make sure
   writing to PCC subspace shared memory is protected from race conditions.
   
v1 -> v2:
1.  Changes for feedbacks from Borislav.
    - Shorten ACPI RAS2 structures and variables names.
    - Shorten some of the other variables in the RAS2 drivers.
    - Fixed few CamelCases.

2.  Changes for feedbacks from Yazen.
    - Added newline after number of '}' and return statements.
    - Changed return type for "ras2_add_aux_device() to 'int'.
    - Deleted a duplication of acpi_get_table("RAS2",...) in the ras2_acpi_parse_table().
    - Add "FW_WARN" to few error logs in the ras2_acpi_parse_table().
    - Rename ras2_acpi_init() to acpi_ras2_init() and modified to call acpi_ras2_init()
      function from the acpi_init().
    - Moved scrub related variables from the struct ras2_mem_ctx from  patch
      "ACPI:RAS2: Add ACPI RAS2 driver" to "ras: mem: Add memory ACPI RAS2 driver".


Shiju Jose (2):
  ACPI:RAS2: Add driver for the ACPI RAS2 feature table
  ras: mem: Add ACPI RAS2 memory driver

 Documentation/ABI/testing/sysfs-edac-scrub |  14 +-
 Documentation/edac/scrub.rst               |  70 +++
 drivers/acpi/Kconfig                       |  11 +
 drivers/acpi/Makefile                      |   1 +
 drivers/acpi/bus.c                         |   3 +
 drivers/acpi/ras2.c                        | 502 +++++++++++++++++
 drivers/edac/scrub.c                       |  12 +
 drivers/ras/Kconfig                        |  13 +
 drivers/ras/Makefile                       |   1 +
 drivers/ras/acpi_ras2.c                    | 603 +++++++++++++++++++++
 include/acpi/ras2.h                        |  86 +++
 include/linux/edac.h                       |   4 +
 12 files changed, 1315 insertions(+), 5 deletions(-)
 create mode 100644 drivers/acpi/ras2.c
 create mode 100644 drivers/ras/acpi_ras2.c
 create mode 100644 include/acpi/ras2.h

-- 
2.25.1


