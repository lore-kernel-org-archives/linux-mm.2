Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA32CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A57D6B00CC; Tue, 12 May 2026 17:07:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CB36B00CE; Tue, 12 May 2026 17:07:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894026B00CF; Tue, 12 May 2026 17:07:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B18E6B00CC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4887F1C147D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:43 +0000 (UTC)
X-FDA: 84760004406.29.8796DD9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 146F1C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f6oZPxAS;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=carebiiwA0WkwpCm1TTKgYlVMa/8U14hyqClEOGQapg=;
	b=Nk3sqJfYgLlTwcR0jVndsx6/L+vRafuf+ViI0d65ThhKZ27ITPnNIxzzH5ba0VdBCqYoCX
	5uce642gi5IOndQ960+08oD0zM221N3Z9dHkf4TjrXH6MZU/JzaaloGNOsWnpOplkKi0HM
	gmmCo81P5qAcDqbnUqacVRKUlhfDoWE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f6oZPxAS;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620061; a=rsa-sha256;
	cv=none;
	b=CJHJDEgftAFKp1LFXEnSYB0ULAkqOxXDXkFwaLEO0QFr0KbQ+WfRuGAoi7HSU2IX5alM/z
	K+U9LjIf4hjrfUabTFkxVeJtIipb9M3WZwraN5B7Wo2JpItk2iczWz20kGisrlzcbWiUY4
	vxxmAHPWAzHEiPfLV3TuKiqIc+tgVcs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=carebiiwA0WkwpCm1TTKgYlVMa/8U14hyqClEOGQapg=;
	b=f6oZPxASmNfFerhXuJ3uUadYqe5fYEQs132GNXXS2BY6AMH5gH5VQGK7mXVQLHnWv/yGnw
	HmYPACphMmBis6IfOqTmaaDJjommlULmlx5hVe2fL0nl/aNDBA+rGppy7+MQjEnRsdMFW1
	TuUbDIliT5ZBHmh8bXmMioNtyyjd9Cc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-GwbAdd_POKeASao5SAdOnw-1; Tue, 12 May 2026 17:07:39 -0400
X-MC-Unique: GwbAdd_POKeASao5SAdOnw-1
X-Mimecast-MFC-AGG-ID: GwbAdd_POKeASao5SAdOnw_1778620058
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48906aa28cbso52280605e9.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620056; x=1779224856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=carebiiwA0WkwpCm1TTKgYlVMa/8U14hyqClEOGQapg=;
        b=qOZAWug4QGOXmYtfl87EGxUkxYJ0CUwD7fpw3mEuJV5JqMMnVunnamzWmYm2Sqijaw
         i6eSFh0M2F0J1UyVWpCHhgYZO/jvg5ZqNK3LLJN33vS9A9EIpGejHlT0WvEdThMu+uI4
         Ww7U7bIXHl0vkY2XS5fB47skT7r6pW7nt7Yu88xENx2/xD4lSLn3ZxvfJRsCzUXiiu+C
         KzUqlrMnkRP1bSK++RYhrxGRXjVlF7wQAqZaTSL8cNrPKAL56WzrDOvjDCszs5uHP2Z8
         zZcxOJgkHWYV6tXa4pDexZdgOzCqpJULUGXu5+fDBkzdMxAEjKipUby5QVCavmlWrfO+
         x0rQ==
X-Forwarded-Encrypted: i=1; AFNElJ+gYBV9J7vTQClY1sLoJsp4ExrYIzPvr+DfrtGTmcAAU1OToWLqixXiYztPkYP55D52zPi0LLeSiw==@kvack.org
X-Gm-Message-State: AOJu0YyNxGK2g1MO/Y8Ub6OK1dSf+gzedo4d3nwB3W7us1+xhmC32Ljl
	DeBFNOk9ZFIqw87W/Q/7RlfW8Yii/PcMqb4NQi2D3Cb8teQVR3RGLGcjacov1E0pyoOrOHPT5EY
	TgUE+zZdKAMYFWWStfylI4Xyd7C8IVGhtSZ0CqiK24yi1KBEj2sBu
X-Gm-Gg: Acq92OFcgf02zZez949p1tf+vKWykuDOrFP1RV+TIpYvc/XoYbbDIdv3lexYrhsvkL+
	29BgCRCmR4AtPM2+faiA76AmsDYEq/FnvOSRhcSbVUcBWCfAaFG5Puo4hFXm1/ml1Svlz+sYGPk
	NMURDkAORs5hs8oUHcYWz/dGzsGGKlceT4ZMFNmYTUJdNBxyqFdYiydKYeOSBM89EIlk5p9Wzo/
	euBhrG7ZCXnCeCdk8EE0CiDT4g2teq0Mjwz+V7BBk91tn0R5YhLTV824ltBIfbavDz+Pko9p9A0
	PJcyXdCV/F50nSI6YFTrEGLrkqdKif/uNe2nzzu3n0zaDMeQoXWN417XRUBAao0WZyL+BqMpnz9
	e9joeU3Z3mKTwVExHmRHlMcvZ75zeSlSL06JojcCg
X-Received: by 2002:a05:600c:4e55:b0:48a:761:5816 with SMTP id 5b1f17b1804b1-48fc99275d3mr8053745e9.8.1778620056292;
        Tue, 12 May 2026 14:07:36 -0700 (PDT)
X-Received: by 2002:a05:600c:4e55:b0:48a:761:5816 with SMTP id 5b1f17b1804b1-48fc99275d3mr8053095e9.8.1778620055793;
        Tue, 12 May 2026 14:07:35 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fc8d1986fsm19697375e9.3.2026.05.12.14.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:07:35 -0700 (PDT)
Date: Tue, 12 May 2026 17:07:30 -0400
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
Subject: [PATCH v7 27/31] virtio_balloon: disable reporting zeroed
 optimization for confidential guests
Message-ID: <cb436acb343cef1282f380cdb68f2aee53ba24fd.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IIbsNcevKRyfoc6LuzXqs1eQnt-c_RgPitesGtCM5MQ_1778620058
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 146F1C000B
X-Rspam-User: 
X-Stat-Signature: 4b1iqqiny5jq1hyh1ix3rfj7jptybs3t
X-HE-Tag: 1778620060-978168
X-HE-Meta: U2FsdGVkX18AcapsQejKIGhQtSBC1YBM6A3yV1s99khMZmKVR4xJhzWbJRyI1LuwZ4twi0DglWcVl78KARQq9sTlsJnZu5jUzYmYsjVHEcA3JHf+SYRthKD0TO2+hukYHzCAtGVdWTNcJx9P0FTzdMXaWy1eypV7RS2RRoUbJDa4vLfXZtgwltW3aRs3nNIZBMMlIxHQb7Yq9QP1wQgeIkdQEwChdn4uvjfEOqRXFtKyur54/Dn+pRN8jNRPFDkRqyaMl4dwxwMLOPrr0FCLI6S8/uAdbI7/YY+Sm2u/qraqWl1nGZnwofP+HvzDx/i4VsImj+uJadnF1GGYnXBgHD0H1oajUmp0pl7W3dq3fQG0FuZ/Jlx1HTv+gEiUVesGwetjjjoNS7Fp6bu+4dfA+2hcDogMrIJKAZF93XEyiB1LYuRYE+PKc3i6/CQZ59XPuMXDlBWnm2TMaZnNecpq66iPf8A3KM1NCyntRMbKdHgXAmN5hcI0gChg360rA1xOqW/4q7c8g+n421V+tXq/TjS/3TQjPd90Z0TSLjkZyaHrNqZBlUMur9HzYDQF+M7iBWgZrSVjkaIJhIpsyrqd5dieb8DlIZJX4U4y+pw8Lac1i5GrRcIHDNtZXXg9BTCZJrtk/FkZE9lO7DbAB2SlgYe1Ri5UVyj3Ddbcz3cO4h7rLDGqEuoFEPrwm1DNWQTZ/mCuMdfI5Whvusc9Wr3jxsPQIDNjb08IVNFz6Iu3C3hcyp3tMJUGqHHdXP5N6bRmK50JG8bMlDS5osFrDBbDrxM9OoQHEb7zFucJkFRYLrJvfo4MiCodoYqv0lNubG89O7BCLpY91fTtYIVoo2qC8EHMH0hsJCW8wlQOcTMHg6sfQVX0Nssoj9hcpzs304eeRkIsJ+Jj/cP33IMcGWVhWZMYfx6QiFF5Rw5/Yd50mYSNWAwrGHU3RjTTmdtx8lA9NsAPJk+/P3jEhR4mdcs
 4yX/+My/
 GvfjV1gdUsNW2I+0fAwPEdVkr1kPpPkjafk9lHoCxRBkhxhiJ1J67o/pj8cE5Clo15rqSC/m5cikVIULBR1Q68iuksY7swpUp8utQcURcQkpeO7vaNgI7fUlgLa4J6cvyWzwwV0VDD3ok61TQjRG0xhgWfrE3oc3cNH1halx5HKGZwK9XAdSHcGuVLd/h1iyHxFGaQhui+uQjIdIVaGm0s0apiPGMKCNjMmGBdPorlS7LF1wSGvBialwQ6D+vNA3LUivZlqu+SHwtd1+UsIUbcISofGcSPkqyxleU4TRxeErfR/76eX6QMAvH2dG1eccwIqjnfQKZ6AZ3a+OSjRRykM3lsZxGWfYk7sKqgMzd4oZoPkUChhzSoLYFH58JQN9r2y5GvWKl8DsxDLvmvXy8XS82s5JkluZ619cJ8iGTYIqGDzm5T+8Z5hXKx7GTHck4hSsr347mURc7FnuCkBXfCKKiipHbQPNpenvW
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

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 drivers/virtio/virtio_balloon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 6586699396b7..02d21147d4c6 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -18,6 +18,7 @@
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
+#include <linux/cc_platform.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -1190,6 +1191,8 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	    !want_init_on_free())
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
 	return 0;
 }
-- 
MST


