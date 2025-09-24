Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DE28CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB568E0002; Wed, 24 Sep 2025 06:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F088E0001; Wed, 24 Sep 2025 06:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A816C8E0002; Wed, 24 Sep 2025 06:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD158E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:24:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D1F511AD3C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:24:14 +0000 (UTC)
X-FDA: 83923758828.25.87B6132
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 326DC2000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:24:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZFHRgOt3;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758709452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sw6pLFSQlgK9PmXn7/WRyXp/tUvvcWarjA+fMyiXP/E=;
	b=S0yR5+Puw5MdqoiRKeahWHWf5DnfpCqwYFOfCgUkLTEveGoBYgRbiYyFzoObY6sUZnLtS1
	Kd9dQz4bME8oy6gMJpLhBWgHfnvl35Byl0XT/+rFamsNRbn6SmuuH5Oc7mnkuZ35nei9Sa
	4XQWgKOa6arcNlnZcvg/h0d4oVv0wCc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZFHRgOt3;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758709452; a=rsa-sha256;
	cv=none;
	b=WgyeNSAY3tAFAGy0oy04kFbjfhGZUboqR2ZXnlSGIT3VyanSJ/lPlaGaC5wAkLR4HvxXde
	wJBQnv11sLyFAeS9EqaeyPBwHfWjX8dpgNcpt7oYhri/rulTuBby59x+5Wltomdp89upK3
	t2pcQ1/UFUtnhttePhY4YjZPLivNdW8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758709451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sw6pLFSQlgK9PmXn7/WRyXp/tUvvcWarjA+fMyiXP/E=;
	b=ZFHRgOt3YY9n1RiVIoZI2r1vBK/N7NPm+ZgaaDtJTLj4bTYQzWUvp8Eh5Psm3lErVFCkhQ
	ND6ovKhY+iL1WBBMf7olWtc3BJNDf8jLog5EaOKRl7exlThFFPiZfd+rW2H27uoqY176u0
	5tYYQSIpIWDQ2M7lIfwT0qpO9QsIMXM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-513-yEkpl_NoPF2ZU5OYcXTCqA-1; Wed,
 24 Sep 2025 06:24:06 -0400
X-MC-Unique: yEkpl_NoPF2ZU5OYcXTCqA-1
X-Mimecast-MFC-AGG-ID: yEkpl_NoPF2ZU5OYcXTCqA_1758709445
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5C651956054;
	Wed, 24 Sep 2025 10:24:04 +0000 (UTC)
Received: from localhost (unknown [10.72.112.54])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 323F51955F19;
	Wed, 24 Sep 2025 10:24:02 +0000 (UTC)
Date: Wed, 24 Sep 2025 18:23:58 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNPGvsQplsBeIMfu@MiWiFi-R3L-srv>
References: <20250924091746.146461-1-bhe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20250924091746.146461-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Gvp1DjZH5ADvu_YpUFOMqU9qzJg4LFAoU43tPxpqcGY_1758709445
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: baswodkmyr5pje3p3a6jycg7wrdpb1kj
X-Rspam-User: 
X-Rspamd-Queue-Id: 326DC2000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1758709452-554625
X-HE-Meta: U2FsdGVkX19pV1/YEqIyhpEfbGydSZZ9oDhzUrBaS9f9g4IvNnkRyBwne8BLHeXJgFTC5L8bDNdNczL6tNt73xDMcHxrd/2n14pK603JKo20oCAhoAhwyKIlcFe2svn+Lo2WBg6GfZiGTAjlDeMpypWHuLWt2BLKSwpZk0hYHrudsvewXu0du8OV3yWDAjj1wLRORkC8LyWfV3zKhfFGSGXj+0AHgVzoxEfLV1F+SzUfroiEiQu8jr861T7iGPBS/plMulN0Q7GbbBK5uTwf07kxe3BOI8vH+EHP0jCYs62JoSh+y/mMB7RqPLgP+c5mxWPx5hk55OrLCkFreqTcpDVAXA7XY13RlAh66LBJRo30g/p3uIgmdmd7W7A4s7Nofa6jpEYFsR6U7L5a2F9pE/rR1rAS8X/HnKE5h6Er5fShKdBY/28L6VXe5b2I4+a8LpYLmLYkP7WTYXty98m9Hu8aen/xqgQDrDyNTLiG2ie6NIoTbIAcuJ6h50jT9hSsH0cP8uM616Bz1u539r2cgaks2H+ToCMX2diru3IQCBpgB/CcGA879NwgqDD26zwALya+8dFVHgRfZfY/Tyu+6nzRIikWTI1r/tcAstNPjyr6tEaa0KUZqbVpLRzIkO4l7p+WMG/VmDlpHTTuDKanOV9/xustw5bayS19A+Hm5AgXhDg6oUr/2hqxrKALrLAsxK1AkoEWXIgeYj99uQ4HZvJd3F67j+c9JtVgR0oIlR6kL5e35U6mpXAgcAxQFyuKWZnQVDiPCbFmZMHp3MdONZ8DfqoccLYJf+EunaEQJjoqTGXo7n8ftx7qADhbB6Qh9djXmuBpZt8Squ1EmpuksvJXW2L0JrRf3lr6wiHpg3OMm3HdbVpUtvmZ5qggzGDPhwMqYcaUgFy+gfrX7K/ZoeJ55aJEY/P9kVvNdggEkuVn7ZO/THegw70M2Ah57dePt+XU+xUD6Z2pROsmTe0
 aqAcp8ai
 CC6OqtPhj4vV/P5vtow5vbt8hSFonCjVCU7zFB+jZA09/DIx6APi1HrlcWAvASy47KRbfaVTVAQR2480pLcgKPBsy738r+tXI06Fkl9gKDzhGBmo3U8DuUUwk3IkTtDr8SH9T2PIRVTpg2n/PVdRCtQodW01AX5c05VlJwj7JmuWcTlZ6854P9qDJvayZxxdyYb8/20hd2xWEiI39RknEJ69P6Aw4IgbCtASaUfZwLERvz/koN4i0s48DKFWP6joqOqHYbf4L9UmpuVyoT24AAISSoaOUT6rM1a2U60j7iUB96x1Ygz7zKnL8f5kgSGauDTClLMhJlLTHmTKEzm60zDxgPutrPmQXH5L34R3z5DXBJ1GCJokAtzCcDoS/rgNpvS+JJhTWy3Qh8QH7RRu9s7EI2fbGA8acjHYcXXgDnOWAM/amz1SuzVgpZ3P7NHoUUP8R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/24/25 at 05:17pm, Baoquan He wrote:
> Currently, on system with multiple swap devices, swap allocation will
> select one swap device according to priority. The swap device with the
> highest priority will be chosen to allocate firstly.
> 
> People can specify a priority from 0 to 32767 when swapon a swap device,
> or the system will set it from -2 then downwards by default. Meanwhile,
> on NUMA system, the swap device with node_id will be considered first
> on that NUMA node of the node_id.
> 
> In the current code, an array of plist, swap_avail_heads[nid], is used
> to organize swap devices on each NUMA node. For each NUMA node, there
> is a plist organizing all swap devices. The 'prio' value in the plist
> is the negated value of the device's priority due to plist being sorted
> from low to high. The swap device owning one node_id will be promoted to
> the front position on that NUMA node, then other swap devices are put in
> order of their default priority.
> 
> E.g I got a system with 8 NUMA nodes, and I setup 4 zram partition as
> swap devices.
> 
> Current behaviour:
> their priorities will be(note that -1 is skipped):
> NAME       TYPE      SIZE USED PRIO
> /dev/zram0 partition  16G   0B   -2
> /dev/zram1 partition  16G   0B   -3
> /dev/zram2 partition  16G   0B   -4
> /dev/zram3 partition  16G   0B   -5
> 
> And their positions in the 8 swap_avail_lists[nid] will be:
> swap_avail_lists[0]: /* node 0's available swap device list */
> zram0   -> zram1   -> zram2   -> zram3
> prio:1     prio:3     prio:4     prio:5
> swap_avali_lists[1]: /* node 1's available swap device list */
> zram1   -> zram0   -> zram2   -> zram3
> prio:1     prio:2     prio:4     prio:5
> swap_avail_lists[2]: /* node 2's available swap device list */
> zram2   -> zram0   -> zram1   -> zram3
> prio:1     prio:2     prio:3     prio:5
> swap_avail_lists[3]: /* node 3's available swap device list */
> zram3   -> zram0   -> zram1   -> zram2
> prio:1     prio:2     prio:3     prio:4
> swap_avail_lists[4-7]: /* node 4,5,6,7's available swap device list */
> zram0   -> zram1   -> zram2   -> zram3
> prio:2     prio:3     prio:4     prio:5

By the way, when testing, I hacked zram kernel code to assign device_id
to zram->disk->node_id to emulate those disk with node_id. 

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 8acad3cc6e6e..b0bb6531b029 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2719,6 +2719,7 @@ static int zram_add(void)
 	zram->disk->flags |= GENHD_FL_NO_PART;
 	zram->disk->fops = &zram_devops;
 	zram->disk->private_data = zram;
+	zram->disk->node_id = device_id % nr_node_ids;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 	atomic_set(&zram->pp_in_progress, 0);
 	zram_comp_params_reset(zram);


