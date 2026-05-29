Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3A6CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC67E6B00FC; Fri, 29 May 2026 11:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9ECB6B00FD; Fri, 29 May 2026 11:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4416B00FE; Fri, 29 May 2026 11:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC2A6B00FC
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:25:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 684EAA01C0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:15 +0000 (UTC)
X-FDA: 84820830990.01.D017ECC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 266A9140009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e6b0snqX;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kNatCmWHyttmbkexMBnMmdZ3Q708953lxRldkYnzX4=;
	b=nQjqC4DifQugzxOnXd3uyUNz7douHmCAkkGHWsLWz5mCdi5FvhT+crlo79pmDFfpI+4lFd
	JAIYJzbJwLpLf/CMOb+m4nDqgdurXNXJXmk+CeSEkxmNUpfjnxSJ9S+eweffcXtb2Uvy8N
	sJSwup3Py0W/D3aM994rv84twsWIp3o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068313; a=rsa-sha256;
	cv=none;
	b=rFbgonbv4pAOKUF0iW34nPyeJ5J5sR4DDetHdJQj40c8MlWCadHrT1AdWcOCm6aOoRkUS4
	z9I11S556pr09PLPHoyrlR0K4pNxyBziqGr1HVMrJIWtYuVVrn7lii1TQWoFPM1ducCGxb
	beLyWWvEbla/o12/wE8GoZ9NcR9Od4k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e6b0snqX;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3kNatCmWHyttmbkexMBnMmdZ3Q708953lxRldkYnzX4=;
	b=e6b0snqX4PONJePy5k5SX0vOtBlB/ZL+IoRuNKCANEaMPiV7SjiTS6r/IZ6mMbYjFA0E4t
	6zcHRilscTdH5VAJLajqSp7giEOXyNU8zVXOD0IvqtbHK3VQrIyoTQc+bEDXSkCmkX9nej
	zr7paysGx4maSo8RvL62MR5tkoiLG78=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416--doKF_lOPEaPF5b3G1Bl3w-1; Fri, 29 May 2026 11:25:11 -0400
X-MC-Unique: -doKF_lOPEaPF5b3G1Bl3w-1
X-Mimecast-MFC-AGG-ID: -doKF_lOPEaPF5b3G1Bl3w_1780068310
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45e2f74da10so12750363f8f.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068310; x=1780673110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3kNatCmWHyttmbkexMBnMmdZ3Q708953lxRldkYnzX4=;
        b=VQ/Izwqvbn68bv5HziQk1zw8lSdFSJF9uGarCDicT8QCx9eEwnmD5d5JFAVl0TZtFt
         Cp4yYsp/9I8O1dfNrss/V2/b1wePfTCEyGcYylBfinze4JUGCiXOmXRGYSgy/j9p1kIH
         25ixjsY2/tQ9/JA1tBPC7a7jncvNtfPEFWAfKdUZynAJ57E5vKDmc6WHkg2UQJxTFlQf
         esCxy7wjUaASxZdlzh41svkGA80uvrJeNEfsTuK5WPcmJfsuvAoe46688YHdJMwmlUi4
         HVZld3Z4C831XgdoRkwtEzWe9KmKFHP00+5585CxOdixkZxFZyj3flKm/6M5DIJVnelB
         g1Qw==
X-Forwarded-Encrypted: i=1; AFNElJ8ZIHPkMaLyWkrljNMvQ1R6VL+NU4mzL/hSIQYuEXVm72TaVwLkLtckLeuQUanHa62ZQdxm1Ql4iA==@kvack.org
X-Gm-Message-State: AOJu0Yy3xaa6SjSJTsGgoNGZK+uVJlowF+Uw/BWvNANpnczoWCDNRnWr
	vxkSdwTm7czGVPIIDU6IYCoMcxHfex7IAbZ0DOMGq+juBg8HvRapIWQBsqhAnZ/l5NEklr1FwLF
	vo3sOU0ThZ+85duKzIol9yx2fBw+tf9sbozBq+F+llHfYl6LKpdYA
X-Gm-Gg: Acq92OHuzm2jVkF0lRBbGf0h/cedAvoCvHZGsky/h1exEiVeis7uURNiUmm3AQzw2BW
	zoZZt3NmArt9OCggozKqshXVI1NCkTkdrb009BJ+OuDGvsvF8WVuHRbu9WfKr0U7QXqSWZHqTn3
	3pdsrNMWs0RobySh364m6CFBCRYujXg2VaUsa/pwSXqbjiXQX2YD+d6rkFURlDlhNR22PEbZYOW
	NEPnqVmjc80mw/rtcnz2a1LU+RYcQ/xjZmA0R/DvpV+/rLTHnOk115YfSFPdqDiypyTITciO4sU
	2X3eWd04xItfAO9ApHmDmPdKIzXeHJDdfN0U5bss2isVTbDpCoOwBIkhNl6TaiOsW+LaGSJVdWE
	2AB33DNiET2lQvZ6WhXxY8cSPRb8QUJuWVtqkwQ1bsJU7NDweSmrweg==
X-Received: by 2002:a05:6000:2892:b0:45e:f581:6483 with SMTP id ffacd0b85a97d-45ef6b60373mr513518f8f.30.1780068309769;
        Fri, 29 May 2026 08:25:09 -0700 (PDT)
X-Received: by 2002:a05:6000:2892:b0:45e:f581:6483 with SMTP id ffacd0b85a97d-45ef6b60373mr513407f8f.30.1780068309118;
        Fri, 29 May 2026 08:25:09 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef3556f51sm4162514f8f.25.2026.05.29.08.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:25:08 -0700 (PDT)
Date: Fri, 29 May 2026 11:25:04 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v9 32/37] virtio_balloon: disable reporting zeroed
 optimization for confidential guests
Message-ID: <1c8bd24b901c36666c675044bfebf498740d1594.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eP0OL4WE1AGDuJK98zB1PJSQiRcfu38aSZgV_Ho9CB0_1780068310
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Stat-Signature: yxo8t7xkggprd7uoakzp5nxpnoibgn1b
X-Rspamd-Queue-Id: 266A9140009
X-Rspam-User: 
X-HE-Tag: 1780068312-354401
X-HE-Meta: U2FsdGVkX18mp5+H5VYil/gNYcfKuI5M87mkpRlGfZ/sCrsVrLGX9KQ4zmlH6wAgsmerTjJpiip3d54B2/jXzON1dVUFzsR+QdPxpu0CBMNcLVHqn3Mh2fHmOGeZCpBTUeV4Cmqrlv7p6FDBshvtB9h56NFs/LAXEKJxakHDareh1zTDXuqkRcmBdfThbCRh/MSUSwuN6vGmp47sah7h1DFK3WWwGE483ZtErua1T206OVu36VSOiZCtgkyMgqyInBR7oFs3uu2T+TJpNoNc5V8FPPR2YAIqTxG6Bac8oXvTwwVdvOti7tUBtFtjMuW0JejidbSnkVNAPXN3ltcDSPpcjLB5cMQIfrURWehgDaiOWVpKf1WqWlp2GQAeMu5VsfSgdNTE/5WbyZxwT0zUktgci+002atXPNTNWSMeoYeZ87Y+/Srr42hckY+IW8SzxCSpDPvC596Bqe44VLeF2PBCKCM5UhPCfKGOOhbbxKadyDnTQqQQVc+TnXc7H78kvsQaI+IeTu3gS0z6z/udANjKIED0o0RR+j3NlDXMMdJwGrwxmtfa7dRfuigwers0mn/wbitrW1VCcu2GUI0M1d85kzhYua9jHdNOIg7RyvbLruDOdvUywt8bQDeGBO6iACoA5cHf7fo0Yf9j/tWpqk67sy8noGClVPGhpVUYKnTqOd8FC1zxTDs4QA4JQVQ/wcXiO5yB8BaFLCMvR7KvpiQWZ0imLiTvec2RPNJtlJw6kSjLYQVSoJdhDRotDnpDPtSNH1AmIONlejoD9kMxRMEzdT140rvqbDDpRWx4FJhsxBzfEKxV+q5WRe2+4OlUkDE+pY5KiRXxkdop0Ig1aahrkAuFDiMspk7R6Eu6eUx5VKYw+ru7mOp2/wWKgEFxnieWgVrh+3ny+rpVo+Gq+GdtJdIiUHLypiIICzNJMhB+b7DyFnaJrBNNALp+ODqst/xELMMpqMx7VVQ66Ef
 jsJ3LjMV
 8UA0IW1Ij2XyzBJZsGvLxEsibA//e1Xx5EuUITuJpca6CN3u/EQgnh63teqXHMhFItaDn4i8MmEgzWZMYhajx0enLkvRYyKTtfrgQ3FOCXz6X8woeOPpNPhkW9YwMl7uXdQD+D0nybbr6LfDrxbTb2fD92Lsq9JEpjAnSr/nXi1yBELp4wcwh8WmXuehAyiBaz+T+8biFowWTtjVN5eLxopQzL62nwq6HBjzY2GGo36g7V0dQiL++kl1fIWNkiJtFAgfI7QKYcztL78cuHwBBIWhRttrF13zo4mDl80vMuIZNUGFSny0ElCmTa7ytE6Sst4Le4ddIGSjTk5j5K23rdePGe1KIeNxNXse9+4BJPEtyxEuUewsFadKPui8eRvQpvOAc/sjLjs7cvVhd/c8uyc2FhecczvSD9ozYutJYYc9FkXzwjV1kIjbJwAK9GeagD7F/9VGRSNFzg9xSxg3APH2J1697NAkjNN1K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In confidential computing environments (TDX, SEV-SNP), the host
is untrusted and may lie about zeroing reported pages. Clear
DEVICE_INIT_REPORTED in validate() so the guest does not skip
re-zeroing based on hints from an untrusted device.

Note: currently REPORTING remains enabled and
VIRTIO_F_ACCESS_PLATFORM is cleared in CC environments.
This is known to leak free page physical addresses to the
host.  Whether that, or ballooning in general, is a security
concern in CC is up to the user.  This patch only disables
our new zeroed-page hints where the host is untrusted.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 drivers/virtio/virtio_balloon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index e3afa6f32ba5..bf1172ad5419 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,7 @@
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
+#include <linux/cc_platform.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -1193,6 +1194,8 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	    !want_init_on_free())
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 	/*
 	 * Balloon submits 1-2 sg entries max per buffer, virtqueue
 	 * sizes are 128+.  Disable indirect descriptors to avoid
-- 
MST


