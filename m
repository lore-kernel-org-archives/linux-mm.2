Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD0CC55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 15:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B506B009D; Thu, 30 Jul 2026 11:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606776B009E; Thu, 30 Jul 2026 11:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5F36B00A0; Thu, 30 Jul 2026 11:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA016B009D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:03:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3B0D1C0198
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:03:24 +0000 (UTC)
X-FDA: 85045761528.16.68BA76C
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8D9B016000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:03:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=irv9ghe1;
	spf=pass (imf08.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785423802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9UdmMkwBkbwHpnQxJHOFAJgHRQBiC2eogIeFtsGPq2M=;
	b=dhlMk6KbWxNseenfjgQpjDtfK6vWgMwRHmHz9p0TLNVwyeG2FwT1KmPzjimY+a7vAY7i11
	U5gbP1uJhwmsY5b4KWe3fGRCNa9+gEgJvMEVLAUEtLxgZ3qgyLUiVaZWG552g4HQ9UAZwU
	4SSDjxAAZdWiNXMyNbyVE/EbGpe59/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785423802;
	b=J5FZOFdfHjRgFJnntWwwLjdNzmxpVRwXJKufxw6scr8TEOjDSv1VUO6o1xyvVkx56PpvCW
	q0+8oPWkiZdt0D/FrHG+95AuxFhdRubOkVsIyLn8n4V2C4kf+wnh+lDHizX1FGgq3cLBFj
	UhDsoIdgeSjXcQBdDtl//ZEwHnxHm04=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=irv9ghe1;
	spf=pass (imf08.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a051904222so2424119a12.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785423801; x=1786028601; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9UdmMkwBkbwHpnQxJHOFAJgHRQBiC2eogIeFtsGPq2M=;
        b=irv9ghe1LW3tLNQCeI3xqKsgHoqMlsNb3z/22+CfrhHgXsFPl69XkVgIgpVltmxuKF
         F985CjIffox9Ls5ns3UYyTvjB+JvX9891apBZwQSouUJJ/as8eUD1azKQNfA67cZneF6
         SjXfuMnKcT5Tp6L6OV7oTbLW/mzugPVrzLFrLJZaZxvhRB1bD+Wzuq612JJGahCWIAzE
         hlNdIpjRazpBNRPkYj8l+SRuFMr52nPSSYaB6ASa+EMNqtQKK3oCoGoEImDx1nXglhVb
         r1U1Z4swWghE+1mcRHY54HXnGmnjDxSKwZ1k3P1MSC++e6MK5ldcz3KRyx2gRN40cjDT
         Dc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785423801; x=1786028601;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9UdmMkwBkbwHpnQxJHOFAJgHRQBiC2eogIeFtsGPq2M=;
        b=hELmSezKWQCTT7GxUsSWId7lgRTN+MA5afCOq8UZxIty6mwKLzoK7kzQ+G2SmK0kia
         zYhncFyphFVR7AM2lHsSuZGe1WSQyu6VPy0HFmZZisLP6KX0Y3F+6ghgGt7jy5L9R0Os
         5oDc5DWYz5zkCuFQ7zm4p5eYWBsj02H0QuizjaxmvcnyCkhOGy7M5LBlvkGMHFpWoDOE
         ybCSONihh2icCUJ0aqcgwz38aFQxNSkxUxBwiDLfb02/ejE8Jn9qygG2Hbyeui/Adaog
         bgv+ARFd0rWWUVkbNr0mco7flUO6HSlpRTaFc7dy5dz8zUNMVTQEEQDCetPA7rHJXu5V
         DxMA==
X-Forwarded-Encrypted: i=1; AHgh+RqQhJlhHT7DrC7W4kfukO4dXIAh6rGPJFCNszUdXL1lhGmxav1bWJT3uOTjl4cN7M5/YunezLrzdQ==@kvack.org
X-Gm-Message-State: AOJu0YwuAm7YFBL6ZtnSsnwTtDuyRNVCjOHsneCSVw4vmuD9f3vEEPvh
	tsdN/B8Ug89wfmUbcR4cBhh6ockL89x25VBBn3hWRR+2bOzTB/tScBTBw5CnYQ==
X-Gm-Gg: AR+sD10+6FtunHI7JHOMypmUBTJF92ur5go13X2AcLJ/rydoQEp1gOpZV53ekngYW/d
	MDZU2HZzaC0Qxm3NyGpdRWI5FZPMGTdtm5C0RmCdd4SYWfYR/GioPTGLRwWvjrdRnxT1dd5+eWu
	y9SQf+mchjCsuo8oIhTYkBMasqckDJ0BscWsFyRX5W7C7O+TZ/tEfASC+jSnmXhkVmsWssdiGnz
	000EL5NXLBSksTKtzQGlsR6fcxaxE1KJnuCK47SBtLUoN7e8iIUFeXCJmylQZgIw9y8LFxz9MK1
	uz9rBNti3xW8PPsvG6+oGfVHMssQHpcfSNw2KNTfGq81wWLdIT8LjWGEqSKeLoletiHys7vTeGA
	FFqPmw4FCdGDUi+erIOusBITJz1d4LaFo1mVW+j80vGEvTf7l5I+dvhK0IeEv925XEiyPxW/MRX
	5QJ5w1l/ctlhnfltRAVbvYi60LQDBop+6LKHwuoCSO6x5PmaiuMGeTvLr6A9TQ3T8zmmqJC6Sk+
	E5+Oz5R51mttUO3mSzFl8iQAMU2gS7v2RF1DMhQ6qXHHw==
X-Received: by 2002:a05:6402:3604:b0:6a0:32ec:511e with SMTP id 4fb4d7f45d1cf-6a090d3ef16mr386314a12.11.1785423800678;
        Thu, 30 Jul 2026 08:03:20 -0700 (PDT)
Received: from [127.0.1.1] (h-62-63-197-109.NA.cust.bahnhof.se. [62.63.197.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a07bf18ff8sm729116a12.0.2026.07.30.08.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 08:03:19 -0700 (PDT)
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Subject: [PATCH RFC v2 0/3] Demote to lower tier using non-temporal stores
Date: Thu, 30 Jul 2026 17:02:56 +0200
Message-Id: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKFna2oC/3WNwQrCMBBEf6Xs2ZU0aKGeBKEf4FV6SJONjdAmb
 GJQS//dtp49zvDmzQSR2FGEUzEBU3bR+XEJcleA7tV4J3RmySCFrMRRVshW45jQ0OATobDKKmO
 NEaKCZROYrHttvhtcmwu0vzI+uwfptJpWrHcxeX5vr7nc4D8HuUSB1NW6PkhpFNnzJyTtOey1H
 6Cd5/kLyuwjvMMAAAA=
X-Change-ID: 20260526-rfc-nt-demote-0fafadfdd006
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
 Frank van der Linden <fvdl@google.com>, Jonathan Cameron <jic23@kernel.org>, 
 Raghavendra K T <rkodsara@amd.com>, 
 "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
 Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net, 
 Ryan Roberts <ryan.roberts@arm.com>, Huan Nguyen <nhuhuan@google.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, 
 Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, 
 Alirad Malek <alirad.malek@zptcorp.com>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8D9B016000E
X-Stat-Signature: yeuyy589onu33irnzkwe8mf1fnmoatht
X-Rspam-User: 
X-HE-Tag: 1785423802-627797
X-HE-Meta: U2FsdGVkX19PdfjLoC9fbsJsH9tH7EhwYEVYQiGstRa6vjo1dTVwtTl60gea8A5YXZf5NVG5c6gsob44CB2GhIijPW+sbpDC8KGxPWfQJ9ik4eEY8dFYOfERiT6SjQPIZ53vXDr3RbdiF+j71osRjcrhFSX1XDvdQS3LeEVghCBMQvRtPhYgkM9scXHK6VTJSyj+M4twr1N+QBuTo2kmlvADZ3yPQCfvZelGsuX7gpEB+UgUD0Cdf0fetEuxcJ58qnE1uaKuJFysZpQXIEbeaoQtbe8YE65gt4uCwD+9W5Uo6W/mJVt6Ml0ehAX6qg/jyIT3JATgmY3IV/NvHoVL4nZ8Pk+g0KKmUbVn3H9Kie7BSdWqPHKA7lnIQ4QhoxlzgnjJK102RLIyScLvaZbVcGfI2B46swyul5SFYdRg8+T75ssX/evMFZvopT3o3FfsbBYfbSjYmIkfMsGkgrK/2/J2zVntcTzyyxAlHiwXnAHDvQypVvMSUeDEBD9XEXG2T/VK/MgDIXemBF5f3qjN53fZE24oMKklRf7oxAK8T8/BSfts12U79k7EW2d/sdNdNJ1OteTnttb0xOoJlwo6EfiDPB3mbWFG/YLxxwHCK7WAwYkjnJiCh+hX+CYtQjxKkAWqJPJuAGyGqa0EZeFkqH40xxeIZZEh/x27z5k0r7dPNtaUqWeTtld3B2pAxmfUfyUnseZ4ooSDPA/7NG+MWtAA6P4buZaNLipqeYbvbIj+9UbAQ8+wPohcYwkJSJX5PITV3llydfOPwPPzy7+K2JNEfaQxOIE7JSSR80QKwRW8f7QsdaN2bB6Dgz8SBLG6h7ndQX26suoVyd2htg4eZ3+VqSKw7HmpR4xMqUvwTlDFU92hQcTsn7URcmy5lG0jN1b2wzPr9MvkavRYAd2/CFFEuSy7BomXj7XTIrpc+KnGbT9wKibAz+OCqeAvs0BJL+zKc4ko2uid0ofkCi+
 zziMYYu1
 1SQpczDAtNVMGsjTf8rrtUiuCLE+/ikSq+OoXubI/68yrP9xUysD28PLl9f30gfHj7eoL8zu1veRC+EzKmwStioWORcGS6To9fAsD00D3AlMXFO/wayu3l7GuDJjtohcbgA4h7EHZNFY/ATuVOmABXlmhCGgtl560OcNBYZYLaq8pxWZ2B7QWVUTRwg3AjAka54xZV59q+5A0Y4qfX18cY6G8q/aEpRpmXpZC7eRDTl8GxoHECeBdxpBjWz/8BlAK3CTjab/MIw/xUtS9mMx16RR/ORqCSnUSpo1T2wm1ke1Cx74f/jMh+pd0ff4rPV0/m91N+WjJCnj0et9miHy99pTg1N9ZH2vFJCMDzFotzf112YoEkCB3yWu5nPMeTCfoIzaeTO9Mzn8a0gv4Rphz6kfJ2BmcWmqb2SoYfqZthhqGkKLBHst6SZgCesv7hmqhb7s2voMg8007t4Ya48BIA1W9ozFHnxE0Lv47X+kfj5jh063X5PEhYtQ6YHKxHe2AQzWjOPdy/8tyiJFraP+/g0OF4dd+UUc4KnIC/8Ii0dElLl4YmWYIJj5Mc9zTrROkUTL1IczF1zMKlTTBXuxYnbLfcyEWwayQ25RF4BOkoXM/zSuzKDFqZp7OWNJyRtgvAmiXjktBCEWEfdKjLyJh5U047UlZ5YD1zgSJRM9yeQfNt4QFyfhQh9pl7ZYSeaKhAj/ynA5ube9oyqxGS936cpdn859D0gHKoVEnzQ/O77anuRrG9P3c62rD5bp6Uxzs1bsGuq6eeWbV1kAevQ1M2YNo9mfN+Ds3iFJT4FzPZbXB4YUZD8GKiqOr6c6oEt1URzpCZvZa/cCGb6G/k44ByAv612jwgEPCNDk2M9lIGR45dlwW6QVKRLGlTAqGwp1ehZ3+jlAXB7mDHzOPUPNF5HPgZ9FQ0jrTHcCavPqMRMPAgP6pz7MDUFUFi3rSUlMi69LyDWSQSFTfBAFGlYL/EKzZ9SdC
 7aZMrHzx
 F87MUr7Oflnmp91ZjZxzyOIcNTv58YQoDPBiCROnO/vVCKTCNv1x7hwwsTqfM2P9oxDUGLSksnXA/f5mfqP98ffGKadsjhmRuGgnfdoMUjdb3898mU0MaxGEmKF4OCGS0S6B3tTS2Vr83oceuYdHhOyDxNGZaaJYSVDrJ05z+briTdHTVQlbehla8SKpiq2Qx2U4ZsWbqKzwFI4aauMiOZKHd6FfKFZMCRtjWmGy5KMmrJyv9OD3zLsEPFI4IBCEdPFHFmreqhuinrkVhtsbsziD06SGJwHSDfyicTHUtIfB20YjrU5CoyxPw4WCFz/cPNRTomht5zY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In most memory tiering scenarios, the memory to be demoted is expected
to be cold and most likely out of the node's last-level cache (as well
as target pages in the target node). Using non-temporal stores instead
of a standard memcpy path can reduce the cache pollution in the local
node and the bandwidth overhead to the target node. Furthermore, for
certain types of CXL devices that support in-line memory compression,
the last-level cache eviction patterns can negatively affect the
bandwidth of the device. Non-temporal stores can mitigate this.

This patch-set introduces a new migrate_mode flag for using non-temporal
stores that is used only in the demotion path. Patch 1 adds some helpers in
x86 and mm to bring non-temporal stores support to a respective folio_copy
function. Patch 2 adds the new flag and necessary changes for compatibility
with the existing behavior. Patch 3 uses the new flag for demotions.

Experimental data: in a CXL system with 1 memory expander, a microbenchmark
that allocates N=64 GB memory in the local node and then triggers demotion
using memory.reclaim, shows a practically complete elimination of read
traffic on the device, i.e. write traffic is N GB with and without the
patch, while read traffic drops from N to almost 0 with the patch.

Opens:
1. There is some "duplication" in the x86 tree and a bit in mm. Can we do
   something better there? As it is now in copy_mc_to_kernel_nt we
duplicate the machine check functionality, which if available will override
the non-temporal. We were not sure how to prioritize these two and what's
the best approach here. Can we completely skip the machine checked for this
path? Huan Nguyen has some ideas here that we will align for the next
version.
2. I am not sure how this should be structured so that it is easily
adopted in other architecture trees (e.g. aarch64). We rely on
memcpy_flushcache for x86_64 but this does not use non temporal stores
in ARM. ARM support is currently out of our scope but any input is
appreciated.

Signed-off-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
---
Changes in v2:
- Remove the KConfig option that was guarding this feature (patch 3) and
  use it always in x86_64 and memcpy_flushcache (non-temporal stores
should be there).
- Link to v1: https://patch.msgid.link/20260526-rfc-nt-demote-v1-0-eb9c9422daef@zptcorp.com

To: Thomas Gleixner <tglx@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: x86@kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Trond Myklebust <trondmy@kernel.org>
To: Anna Schumaker <anna@kernel.org>
To: Zi Yan <ziy@nvidia.com>
To: Matthew Brost <matthew.brost@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Rakie Kim <rakie.kim@sk.com>
To: Byungchul Park <byungchul@sk.com>
To: Gregory Price <gourry@gourry.net>
To: Ying Huang <ying.huang@linux.alibaba.com>
To: Alistair Popple <apopple@nvidia.com>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Brendan Jackman <jackmanb@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-nfs@vger.kernel.org
Cc: linux-trace-kernel@vger.kernel.org

---
Alirad Malek (3):
      mm, x86: support copying a folio using non-temporal stores
      mm: new migrate_mode flag for async using non-temporal stores
      mm: use non-temporal stores for demotion

 arch/x86/include/asm/uaccess.h |  4 ++++
 arch/x86/lib/copy_mc.c         | 26 ++++++++++++++++++++++++++
 fs/nfs/write.c                 |  2 +-
 include/linux/highmem.h        | 32 ++++++++++++++++++++++++++++++++
 include/linux/migrate_mode.h   |  9 +++++++++
 include/linux/mm.h             |  1 +
 include/trace/events/migrate.h |  1 +
 mm/compaction.c                | 18 +++++++++---------
 mm/migrate.c                   | 22 +++++++++++++++-------
 mm/util.c                      | 17 +++++++++++++++++
 10 files changed, 115 insertions(+), 17 deletions(-)
---
base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
change-id: 20260526-rfc-nt-demote-0fafadfdd006

Best regards,
--  
Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>


