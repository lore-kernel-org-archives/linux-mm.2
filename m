Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8766260A2603
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=aW54aYx3
Received: by kanga.kvack.org (Postfix)
	id B06026B05BA; Wed, 18 Nov 2026 10:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7186B05BB; Wed, 18 Nov 2026 10:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5FF6B05BC; Wed, 18 Nov 2026 10:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 726D76B05BA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:18:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18D3214077E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:18:02 +0000 (UTC)
X-FDA: 85448595204.22.0F318C3
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 227A420006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:17:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aW54aYx3;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NayqA+2VU8BL3bQ4QlYOm2bPtjimdoFBif/UfurJ/Ic=;
	b=VCNbEtSvg3O1yziKr+BOASGO2G42xaX5LpP2i5I3sAoJzWqA3a/0B9+gYnWxCvnm/fz4hl
	5fk3pnKgFQgNA0aahsYbGptgYmTauHlAQ6OZmBm9vif0twslgbjkO1VkWnXKx9TX7z206n
	hrT+uS3FppqRL3uVpKF9HwaSro/vzlI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aW54aYx3;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015080;
	b=XNAuEdqvsyij6EX5H+7VNtp1/6N/XH1rmKvEWKtLACNBNvYii1smaIFHv5YeFp14NAjHfG
	JDE3EB2bx1AOZwDwDPoB9USeUdSTogw4K/Cv7drY4BK+xX4uoMKXwUWSxJZfji3PuzXLXe
	t1vgaCfJolSgj4JOVcl9zOUpY5xzY0E=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-920fed989b2so9138916d6.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795015079; x=1795619879; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NayqA+2VU8BL3bQ4QlYOm2bPtjimdoFBif/UfurJ/Ic=;
        b=aW54aYx3O6SLD1W+c0CS5SvEPPFk5ul/YnDvAOrcT/StDNpvMuAWTt5+kEzILOZe66
         LNO2RUxz4JNAQOhnZqTnDwV5saVqypH1ds1+uwRHWbpcLyNSBcFj5P14vxtPB+lQ7sy9
         bOSsTX+tRLVfMxtpuV74RgNeMb9+M9dAuN9OShx5ZVrjlcxvt3mEhSRML6tqijYNBX3h
         kTM9HmdxMiOvEdU1wcFyLOergnas5pvw/VUDBr0rbqAs41xQE089mtETAVK4AR2YAs6H
         aKS51w6kknWru48fCS0TS4zAWauUtCip5MU8l/WVXm7Ocke/hOYvowo0H58U6CZfY207
         0kBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795015079; x=1795619879;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NayqA+2VU8BL3bQ4QlYOm2bPtjimdoFBif/UfurJ/Ic=;
        b=nD95DHlsNuUs7i0WOJmZAY6/5Kx8ILB9fSc+M+gNdLtzQAoQekcgs9pIRhFMtF8fGt
         ngrCw/CCppYRo0bPAwbypZ0OVk+L8WCVAzdmVHsaqFMsAiSb5m53/ZK+0ek75P9CQfTW
         rgvLpieiadG6Eo01qyoQOarvjHziaYnu1sT81WuHQWO4VV7wJzaTqcEx//joIlMZG5HQ
         tP1k/PkByv+ystW6VmW3G5Bfma44T+xvn1+1LrvgWX5C4ffqwsBaaE9P6jJy3uht2vvW
         2UH125INYG1yHs+tW8IDZsaGGcE+pcagFuSq6fwGTf+XzCpLjt+gt94k7Ni0S3IVSDz8
         LdKg==
X-Forwarded-Encrypted: i=1; AL+hErHYOD6N3gHqGC6fr3WqOeOaxVSL1y7qyxmhLTM6DkytZU6uOMM28amlG7m/Y0LE1jcCJvRxlIr9Sg==@kvack.org
X-Gm-Message-State: APuU4Z9csn6jOarPdL3CIRdKAf/w9wZXTJpa5Xjan3FOAuqk8bmzZegE
	cZ1T3l87BG4qIrUfCBrHfns6yadZEKs9oSZwcm5ukyVLwIqAd2iWpAYq5it98DHi5S8=
X-Gm-Gg: AZFdTZfsgVixKxrq0dqCFIOgU0cGiiXSAW8txoMGz8Tu0lhFTaU21rO60gyVs26MCfP
	Guw5eFMtJyMapVjUkMqO6eT1aYUJkm6QaLvztZoHdcDltwVb4AS3uZeI9Ti+0+O75yj71Xl1pRc
	6vCdh9rv/Qej9Ed1EiLGUbZeu/xFkHOyG8iPO+cm5m6wWpxjWPVx7ZD6nhVB0x8oXSbwh1SpM2h
	Gn+DUQSN/+vNODir8FbPu1u+nmdHBMm3HEe/1kU+76TpD0n64g/ZQa3mdZ9jLN64VdmbAjOv73H
	50i/BxRhGCjX16usoML0dCrZVVIp2/uz6kjuBeJnZtGw0W+VmXhvvtMZHjNuAjLjBkaZgXT49WM
	ayI0bd7vzO0Cwiyty8pxaZMDQ6i5aBAckcZI2bmy4Ek4r0t68OeIy3o5zIcuC2tWMpen6pKaNqu
	WbFy3EBQp+qd5VoaF+eyq8ffRYa5HL4V+nHQwtcahHQI7ZjYCsnnmDNejmZ3UA2uS5A2Z5ctVbA
	Gp1fEmpVEOYq4TRYvLaK1id3r8prPD0ZiqJ5AN6KF9LkN/o5hiS8LuxVERJLwwLT/1ZeMhptVN3
	GcOeBSkWrHEWeGRgD1XOS+H8hh6vmE1Djs7evDn3V6zNHTe40wvSyG4lXLtH8nwU/hr2f3UUnkK
	06yD1DI9/uzBgLG2HPv3eEuy7ahLH
X-Received: by 2002:a05:6214:5d88:b0:91f:2222:b498 with SMTP id 6a1803df08f44-92114f8f66fmr40206726d6.27.1795015079071;
        Wed, 18 Nov 2026 07:17:59 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92114d35dabsm23793796d6.17.2026.11.18.07.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:17:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/22] mm: add node-state-filtered zone and node
 iterators
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 linux-doc@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-serial@vger.kernel.org, linux-pm@vger.kernel.org, 
 damon@lists.linux.dev, linux-cxl@vger.kernel.org, akpm@linux-foundation.org, 
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
 surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
 skhan@linuxfoundation.org, rdunlap@infradead.org, 
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
 johan@kernel.org, jirislaby@kernel.org, kasong@tencent.com, 
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
 baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, yury.norov@gmail.com, 
 linux@rasmusvillemoes.dk, pavel@kernel.org, lenb@kernel.org, 
 hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
 sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
 xu.xin@linux.dev, chengming.zhou@linux.dev, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, 
 byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
In-Reply-To: <av1hKrtcATVjCnCM@MWDK4CY14F>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-2-gourry@gourry.net> <av1hKrtcATVjCnCM@MWDK4CY14F>
Date: Wed, 18 Nov 2026 10:17:57 -0500
Message-Id: <179501507729.1206716.6880334614636468959.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 227A420006
X-Stat-Signature: 7fyjcbsmeif8eaaqjt561pnm5j9tipuk
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795015079-68843
X-HE-Meta: U2FsdGVkX1+bKXeVHY50pH2DhctjJJEeAhx681I9/iQ8tqUvJEGDPpRpDEWImHJovKbys0ZW9rphbnGM8dgZnNT19Coh/TC5btwNdEK2gCDhxkG/gUcFz9b3CGVsxIDTfp2LWBpAp8Qin8bpCj7KGF738/r++EcaCs6vo5kkwHJo+cTNu7vaw8t19o3zczTx7MUaFP9KOl/Q2fWqpVxIAztuKIUSHe8xvzRJU4x3k7hbqxRt1ww6/ZBbo8wVefEiPcwdwXhU33gnuLl125PmpyEZkfzSCR1LfeAopAEPUYnDKDVpEIPdPepS+Z3bFxvosZQZ4Pz7X9Z3FQDm9B7Eo55Dx6tpJyyNdgru/s7JQaiemEkutykvW4ab4gVNJT3rFJJMzO8FqQB8kpkCBkUAsl/Kmz8RC7oBx3N7ts/98+Hbiygu5Zj3mMi8DSaihqdBzLVBB/X+0dNvuYzZLTxkU2nsXoSXsBQBgbzLFa72yJTx1tfhq4paQQ4gzHJ/Ssrm/eOtFrruoA8s5aEfWUR8aTplxJigca5uXQjUtDz9OsJiIv2/RNAJgTRj7s3PicwAOduBGtJFQIkL8bPbTww1hgM6Nlr8/VfJuDlsnwOnTXSnpbJZUvtkVm3cuVyhzlZD1LAUSqy9pw06Y/IAJ2821bZdMJI7b59QtKzJFt4p9mEs12X7qUB2TS5YB8z2GKP4nkkVGLb5/PcEkAg8zchmgMHZcvt/q/Fsgb+/PjcDi57flothuJgRhEO/sC4gcIm/FxLWl+p6SAOynd9HvWcHhps6UUJBGFj9ZmW1L9zlYKR55hoqsK8+yDJQk9tJpSHgpJyBDkYmaY8AEcDCAdQRgNNSdd5BxIJXP2puOyCzoOSLppySHX7IxYzwvtDDmhTgmbZhd3gvEZI6vzsTWDW9bDv/aCVl/uYKScc1wyNpqfbr+cyB5MFFeLevMFevEx78MQyKmqXtQhEcfaIFCRk
 17zWsIBL
 TdPBUUbGA43UtozzkNRcgTVs8NmXE6lgNTXrwN3kVyF3Vf59ygKX6TFWBphKkiKm5s6GowWa5ZH7Sj75RKYfeGf+HIqpXFR9wyMuy7OvQJTEcD76PZ5cJlCZFV+FZ8AiwLnmTXMtnTwQe3ZcTMklnDtvrh/+2M11MluzprJZicDNB9Qu0d7wrYon9GzmnSuMb7aHofo299aczyxI+QN1B9dhEaOrwCJYOaV04ZWauF7dXzXfpc7Xiq84YeAMcaQrksBKdwC9aBk6MC4S9XQmnQXKG+weClAvHiBm9R2Kl8D4BBpKwKL2eDOL7WNeN0UJ4YC2bpp563NhBRpY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-18 16:29 +0800, Richard Cheng wrote:
> On Sat, Nov 14, 2026 at 02:09:38AM +0800, Gregory Price (Meta) wrote:
> > +/**
> > + * for_each_zone_node_state - iterate zones in intersect(nodemask, node_state(state))
> > + * @zone: The current zone in the iterator
> > + * @z: The current pointer within zonelist->_zonerefs being iterated
> > + * @zlist: The zonelist being iterated
> > + * @highidx: The zone index of the highest zone to return
> > + * @nodemask: Nodemask allowed by the allocator
> > + * @state: The node state the zone's node must be in
> > + *
> > + * The state filter is part of the iteration rather than a trailing if, so that
> > + * this expands to a single for statement: a macro ending in an unbraced if
> > + * silently steals a following else from the caller.
> > + */
> > +#define for_each_zone_node_state(zone, z, zlist, highidx, nodemask, state)	\
> > +	for (z = first_zones_zonelist_state(zlist, highidx, nodemask, state),	\
> > +		zone = zonelist_zone(z);					\
> > +		zone;								\
> > +		z = next_zones_zonelist_state(++z, highidx, nodemask, state),	\
> > +		zone = zonelist_zone(z))
> > +
> 
> A question on consistency. This one is a single for statement, with 2 new helper functions.
> for_each_populated_zone_state() in the same patch uses "if (!cond) ; else" form instead.
> 
> Both forms keep a caller's else correct. The only difference I can find is that the if/else
> form give a -Wdangling-else warning when the loop is the unbraced body of an if.
> 
> Is that the reason for the 2 helper function here? If the warning doesn't matter, this could
> use the same short form and drop the 2 functions. If it does matter, should
> for_each_populated_zone_state() be a single statement too ?
> 

Yeah I was getting that warning from various checks. I'd convinced
byself this was a false-positive, but it does look very funky indeed.

Let me look into this again, it's possible I can massage this better to
use the short form still.  It's also possible that I should just use a
different shape entirely than trying to use the existing pattern.

-- 
~Gregory


