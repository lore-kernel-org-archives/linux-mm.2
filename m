Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 503FBD5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D3A6B0011; Mon, 15 Dec 2025 06:48:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92DF76B0022; Mon, 15 Dec 2025 06:48:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5FC6B0023; Mon, 15 Dec 2025 06:48:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0506B0011
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:48:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2198BC0168
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:48:43 +0000 (UTC)
X-FDA: 84221533326.02.12AB6E4
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1906CC000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:48:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RUYaZFSG;
	spf=pass (imf28.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765799321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUAs+7T6aM5YvKJFQXSXqoVkTtSxZtzq470O+YaXF94=;
	b=N+6q3P9bJZeK1VlGecmIQiE0smTtudMaOBy6KF44JAETyiKvc+Rvqsc+sxOU2i4h+y0UDt
	knFuJ7yS0DLWbXgATnwuEFbRRDaDjjuYI08Qq4I607QIcOfjZ0AB9eG22CGX4neu46CA43
	LULxqjCvH8Csop6XR6voDc0oawFRtAs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RUYaZFSG;
	spf=pass (imf28.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765799321; a=rsa-sha256;
	cv=none;
	b=DW4DZtArvK3WpCMOmUlnHxk009xmbkqpTktlFQlGWkcQ0Hw2SCoeRcJLZaKgITnTvLzL8Y
	pWCz1gJDdAQwcd2Z40qWHBfhx8gGZfQznvBVNDTIHCVSwkoVaPrEXnXeevHEwp2JpFDTYK
	bPEHD9ZbunOUcIS3fupkhNS8m5Y2SZs=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso19640535ad.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765799320; x=1766404120; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUAs+7T6aM5YvKJFQXSXqoVkTtSxZtzq470O+YaXF94=;
        b=RUYaZFSGtVdN2h8SIpHzs8V1cYpp2dcQIj7dKrpzxGeUcnrMmpHZNVBJQdS1g2x9JX
         hwUhOgWtyXoCKGjEJuY/2EPcgl+cNT8N9dGJsidQKCk/Tvu/fVylMLKWR5LOk5t9mUgv
         Qf04B3nYCd1FXjbwX9xMpwQ4N0TbERAhulVhSnOE5Bgqg/5JoX1JKDV2aKhzOzmrjBY4
         6hO1gT29RnCYqjXPyuIF3Ka/TcHqHgHBWe6Z0bj3hq1y/OQKRUKVhstZQJ+jR+Zba+n6
         KIiWG9GWj5twtP+67sv+7SXNhWh/z76SampDzNC2MO2m4ZLwNUgAOkcnqrIDf66xmUba
         ft3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765799320; x=1766404120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JUAs+7T6aM5YvKJFQXSXqoVkTtSxZtzq470O+YaXF94=;
        b=VF0pzoBgdofTP5op1PZsVs5qbDgb3V8nCNwShuhKo8zWqMY4Pl3w/j+Pb9muMMJhcY
         BVYxscg1uwx8jT0vddRKjblx5unpCPXcPfV+a2aHW9OMLq339tVUciGguVI0Kdh0MglJ
         4MChOnvjXGuiC8yZUG3N66chyN2urp5trSZWMswWDNR1qrzsj2tecH0LKbWBEbaVZy3r
         o0ID4nFAtlOJRu4uQVshRUSFuMp166xwH5vJNEro0gzyCTm3VywEV8sMy7WHk7ixRD5o
         1PVC822qBjk19WaaF4QL8FKU0PbcYXiLYpW1YlfVWefT5B5xYr4jGH9vAmbA6jegHbSh
         HCrg==
X-Forwarded-Encrypted: i=1; AJvYcCVZCHGHMXH8VjwKEu7HFc5ZwoJP62ZPW6L1j1faosX1DguzSNdjdgm6AYUP+7U3jNVSonZW1F6GqQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3y6aTJIFu6RfXKtnTAiFWsEjf0Jt3xfhRiG5DIUYjDpwgkVtJ
	aXzOZJxz3IJ88KEz41sqjTFQS9RSqYaX/gGq+rRLqo0Fx5umNkEjawya
X-Gm-Gg: AY/fxX43YnaKYKffydqP09HdvdXTlPMl5h7G5Q9Xb+tyQuVSiughmVhSea4Oy0Ghh+4
	HAREXiY17cXUuzrnHGamFDD4eryP9EaVof+4Intn04sqQHD9dOdBL1yEaMy02YkdtutpTjE10cD
	t8kIwb3KzHVtyyvU53qvbZT11BFOO6oqC/lUVRTi3WpTw4gC6FTCQMnTNOdYZ/lM5oxlWOwS7g4
	Rn9r5wixGAEC42g9hDlamiZg8SB06EvkYGN/rynUVMHrUZre6K4CH2IIWowy5dlDHviqyahjVem
	bQiuP2rAWzr9eOerAALVRId9I595UG/ZO5315g2eizRlk6A0aQbUDZOuY6EeXSenmsHaPamjWGP
	8twBUIOgu7GFzVEB+RZvNT9nD9vaMCaZTeDHHP86EtW6t5KvKm6W2HZt2y329aQQyALwduI5LZA
	Y0K3WSTn4zoRo=
X-Google-Smtp-Source: AGHT+IEA4ldqjntSU1IZe10aX19mQKLjoCVDqCMnCNeqo44SOanRLtLHyqhQX8MxC8RVHbAWKM2xrg==
X-Received: by 2002:a17:903:1a2e:b0:2a0:b02b:2105 with SMTP id d9443c01a7336-2a0b02b228amr63659225ad.56.1765799319837;
        Mon, 15 Dec 2025 03:48:39 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a0867ebe9dsm77190525ad.40.2025.12.15.03.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:48:39 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 46E2D447330A; Mon, 15 Dec 2025 18:39:06 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux AMDGPU <amd-gfx@lists.freedesktop.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>,
	Linux Media <linux-media@vger.kernel.org>,
	linaro-mm-sig@lists.linaro.org,
	kasan-dev@googlegroups.com,
	Linux Virtualization <virtualization@lists.linux.dev>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Network Bridge <bridge@lists.linux.dev>,
	Linux Networking <netdev@vger.kernel.org>
Cc: Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Philipp Stanner <phasta@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Taimur Hassan <Syed.Hassan@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	George Shen <george.shen@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Cruise Hung <Cruise.Hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Dominik Kaszewski <dominik.kaszewski@amd.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alexey Skidanov <alexey.skidanov@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Harry Yoo <harry.yoo@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Roopa Prabhu <roopa@cumulusnetworks.com>,
	Mao Zhu <zhumao001@208suo.com>,
	Shaomin Deng <dengshaomin@cdjrlc.com>,
	Charles Han <hanchunchao@inspur.com>,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	George Anthony Vernon <contact@gvernon.com>
Subject: [PATCH 12/14] drm/scheduler: Describe @result in drm_sched_job_done()
Date: Mon, 15 Dec 2025 18:39:00 +0700
Message-ID: <20251215113903.46555-13-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=982; i=bagasdotme@gmail.com; h=from:subject; bh=kdwYayfiPuGdbX+6/rKZkI1jkonQkDY24KG3T7ZKuZA=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4Pfzvv2aMJ6/2fiW3RmVPTpTFSM/fBW4Nu0ikdP3 J/+EMyq6ShlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBENP8y/FN2WnBW9dYhDc+y QzUe+4R7v/wRO/L/c0NDkJC4klf71CqG3yyrLnq/ur5px+nadXME75rW9sxVOp7eMOmL58xwZZ6 TlnwA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1906CC000C
X-Stat-Signature: emz5mp8xe8q93dabgwgcf9uiaoc3rimy
X-Rspam-User: 
X-HE-Tag: 1765799320-879469
X-HE-Meta: U2FsdGVkX1/BnBRzl3jlxrU/cu04hCBIF2w0YU1RX8S22z/pRMPrN6Cvd4fLsV5Guaa31dIq03ftyfeMf1gjH83mA57fDtgrFxy142LqHJmEPf/MBWF/IOnzYkRkmKrOTK5gEi60st9haxzk+CklXVK0TP7s87d7epPLrW0icMbp0xUJhqSsq7DSfR3J6rw1vpWUfphqsybeveDwJoZIsU/IVuTEiKmKzbA0CYBG6yBA2CzQXaMxDBGSspQcR5vDC59pcSH/EHzNjqymJ/qADLJ2MgJBZbPtbSUFbCFJihNE3l9ZoFFyR2HriXx0p6MsoC3Zhgtuta+bDBfTJfFrb0D2lopt1POoFZAqbfrc2BCChs7S1N8K8q8dl5buI/DJ62VDjOWf8c1yVMzTkUdhuC9Lyp7+XhR/TDDrf/Vfw32jgIk6c37/yuZmX/Fvse6ErqeO9ZJkT51h4nk3gF+1buqjVfAWjgHdoeiGK3VsgAb5vG/z8y+Owx9SCizuxFmEIfPqzCxM2BDIW+jVFgqbU6HvYa9mo83OMLRKWdTHMjHWFww8Zqxtbgif/8pw2pnewsU9O196Vv0udaDr3nrgll42BFvhDxYYq2/ejusWhjNV1kHXobVu9iJsbYIrcb4P2G42G++36RKWH5Nj6SU7OVnMjF12y7TH5Wz5LIup8ZUX5nKPkTbwTbjbXyw2OzyRVr1NSX+Djx2cOxUE/12Ed4dY7ENVsqCFtRUv1F/u+QwyGAzl+FgCoXWpZ4SNxfjps+3eYaJj6UNtyma/N5fKSULFAOxU7oodBI09hWmd7A6+cHvOdfp4mR5mcKzKxmRn47+SCWee/njE9ycqNZ46TElXz2UzkPNMMEkguerY/KtyTDlxrJsXDS6kbpVtpw1ySwTkGrUGapmwtDNgAXLCpbMDtFRFU/ieyndPEFKtWN0d8HTuUNwVXvfntjcu8PphKGzo7GcSwfVVk9XF3gh
 DL/GhXMs
 btjSctzWfO8bTTdyWUR5ka9n85jSl3fdlj2k5v99IVlHBzTKflOEjN2nBJBArPEkVvfc/KAJgsQ2/eN0VccIw8IkXIB1kPdYgNDQidsBxlrfcDJT4WYfBdbnn7f+xX6pqLIkehFBFSg/x1mDzyu1ULLTKF4KCy4VsOqKBpHi/HLz05UEbppBcdGfjZxsdj+J0UgcrrBD6gcbQUtxMIUZ6QYgf7qhA7EakNcSlmh4035ssIni5DvbfgLxNFHF5+BAj/QRdVXpJSYjopNI7EHMnxImAUY0RWP0BuAxvcqNKQUFc6WgmBW4sssdjKwz6bpzeWzAZkgr2tZivpuTFvFW/xIDHQhJqROnGYZP+79UhuyjVzNC/nFQJQ3bVLke+BIg9XEKEazaSN+fra8RqqEleMlFrspX8rYLF5uO+04XX9rIwxmZwSs/XPez2f41SZTkkK/yCgFhVCDm1q7I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warning:

WARNING: ./drivers/gpu/drm/scheduler/sched_main.c:367 function parameter 'result' not described in 'drm_sched_job_done'

Describe @result parameter to fix it.

Fixes: 539f9ee4b52a8b ("drm/scheduler: properly forward fence errors")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/gpu/drm/scheduler/sched_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 1d4f1b822e7b76..4f844087fd48eb 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -361,6 +361,7 @@ static void drm_sched_run_free_queue(struct drm_gpu_scheduler *sched)
 /**
  * drm_sched_job_done - complete a job
  * @s_job: pointer to the job which is done
+ * @result: job result
  *
  * Finish the job's fence and resubmit the work items.
  */
-- 
An old man doll... just what I always wanted! - Clara


