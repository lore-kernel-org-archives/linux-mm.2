Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EB2FD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BFC06B000D; Mon, 15 Dec 2025 06:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749866B000E; Mon, 15 Dec 2025 06:39:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EA536B0010; Mon, 15 Dec 2025 06:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9F86B000D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:39:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F35B6551B3
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:16 +0000 (UTC)
X-FDA: 84221509512.28.FC7F3BD
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id EB583A000E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K921nKO9;
	spf=pass (imf25.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYIA++CxPIcYPKgHl3oGianXtJJpe/hDcX33067gP64=;
	b=Gp+tW3iKeWcdGxPYZgx73T6r7niyvk/6Jw/08IqUCJqFijhGNSJXKsN+IK0faPrsjc+FfT
	CiAviFt2jW3gOKYHXvDa8i1UyLYOusxKSWokzhcRNiuZMCxXgOkJa02okB6SxhJ25Zh/av
	VDTPf059tkruOFcrFcxtgL8T8v7EXNo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K921nKO9;
	spf=pass (imf25.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765798755; a=rsa-sha256;
	cv=none;
	b=iTkEgNkrYktWpvyptnzJtxfloqaMXl1fS4R0yblP1ekP18fxVOdukCUilpvOiE3jMkJDZG
	PvatjCIe0pgoCg8BSzSKAJdU0+eQhpMcXDsa7kpfSzjS7Q7NdMNviKWU5LoeSH5wbjI1ft
	lbdNqzWIV4ZE9D3+jPRzCyTNgv2YLPE=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso3579505b3a.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798754; x=1766403554; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYIA++CxPIcYPKgHl3oGianXtJJpe/hDcX33067gP64=;
        b=K921nKO9G2Ly6PDLHEVgZuBA9YtMAA3anObBIPexc45+tfLSy5oSnE5xr4zzys8P8n
         ERCRki0Q+/h19irEpKTjR5eYapdaHhDNjtZWmftG9U3Mz/Y7rHAqQySQ7NiAEUIrso4J
         BB5OTAoKpAgtiLNARPpLECnDzifGXCvHf7K3HKOoGTT4+lRJrZG57q9Ejx5MmodNT7Md
         s0mDpShj1feppEu4ZdWQCseswmfnCIE403Z3JtdmzXx7W0cIt+GQXXXDdWYDBuYOG1tM
         nXNPsG1PfwxCc+54cXtt/mM2WbyhYvbTZm964pwicJxVngaYjZC5qkmEwkIVPSV/AYF6
         uK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798754; x=1766403554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yYIA++CxPIcYPKgHl3oGianXtJJpe/hDcX33067gP64=;
        b=sR4tfIGHGpqkJ+ExljyE1aRML4j+cy3jBOj3iduu5S9qQJu9u3aFjKdLS55A1hn0zl
         GsJeIEgxJ5pXj6xiotR6WgtzN8tBDz6uL9oRItHDAOq0O8Xl28+4VEJOqlR6yCEo5VpX
         YmpeIrRlzTQkXm+ejGnx9KmMl1GXAfRw9yvFKkPJ0+OZ4MSBFcf7r14AqhMS5WdUXlgY
         qC/gy+oeaPGcXWstN+3kjcccJYAJgi+riY2h/fdVwRKpXoAgWH90XzZFU1Fb91SzahbV
         /NBZrii+QeF0Dv3YOuH/NIWplrDHYOZlLwdQG53URlnVSH59xhUA/SAH29CSUmPuidSU
         B6rw==
X-Forwarded-Encrypted: i=1; AJvYcCUMtYHeW5qiiFiO7zC+jjSaugEdz7fzSKDK3ZPAAg2sfinQ3/ZkoNoPGtON8hZxNpUZQ0EWMzG8sw==@kvack.org
X-Gm-Message-State: AOJu0Yx6aNTnHRVX7kR7jdbwbQ74Rm16dET4M93Z7KIxYG8s2tPe7TtY
	WkebxWAlc8iFED6LRGdKLNrGVBYtPkhNA9VmoEMRhlGoHUSvrm91tF18
X-Gm-Gg: AY/fxX5wmqCSmq681/ONcROthBzSBxfF5ZRMptWdpobn9LNMrOu3BE9LKdD+HWcVQw+
	WGVNoPF4Re8u/clGIRebo2wijoqe4rNuDJYapel4ARheRa7lO+HHlNtjgLs6uXLq3Ij9a01NdcV
	VruZlLrfD+sr4Io1r+PYZPEHzcEf+b3jdlJLjU/u9y+kUC7jPLq1ZPSdXWH7PG33ORXwYZZ6Lv/
	V6TIVMCkA4ED6nUT/EffqM4kFdiacyWn8FGVKY4FJ456kIQGsWL/XPEy7+rElSo6W3TzZD3f4gT
	5+olD4GEzVu46Kg2hQOQdN1Lwc8QVe9K9Xtnpdw/8g3YNUAO/S6ckrHb4HNhymM+esAa1b9St8A
	d03Qyd/YqKMOtwV4xH/Vv9iduAQVOTKXDilBTgehz2w1n1MVJiH0GWhM4Jqmfz2BBkX/NxWDyAO
	CS3gdLC5Q+I/0=
X-Google-Smtp-Source: AGHT+IHZqxApH7RH4SvWeJJw7f7kzbBWfG87+pyKENlTOJ0etjJH+97jX9IVf9ZouLQDPcaXmCZT+w==
X-Received: by 2002:a05:6a20:3d8b:b0:35e:11ff:45b4 with SMTP id adf61e73a8af0-369adfb3407mr9418258637.21.1765798753761;
        Mon, 15 Dec 2025 03:39:13 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c26eb0f6bsm12221315a12.14.2025.12.15.03.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:39:12 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 70D25444B393; Mon, 15 Dec 2025 18:39:05 +0700 (WIB)
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
Subject: [PATCH 04/14] mm: vmalloc: Fix up vrealloc_node_align() kernel-doc macro name
Date: Mon, 15 Dec 2025 18:38:52 +0700
Message-ID: <20251215113903.46555-5-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1025; i=bagasdotme@gmail.com; h=from:subject; bh=sT1prVB7LRNvf/W4XodTbc9bjm2B3700BxVWkrXUues=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4OyyibMaS/TcJdL00op76xZei7L2Pv7hFORU9uuV vT80n3YUcrCIMbFICumyDIpka/p9C4jkQvtax1h5rAygQxh4OIUgInIP2BkeHzeo3teoLm8pE9N cXOPl0J5QO7s9Yesjvev3nrjTaKBPiND/5K7Lkx+c2t1WS5sWq6V/2tGhSPf8dA5nnLdX2fcuhb OBwA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB583A000E
X-Stat-Signature: wgwcykfxir8pdq8sc3dt7syejwn1btcy
X-HE-Tag: 1765798754-844652
X-HE-Meta: U2FsdGVkX1+gCmfIlXCKUVFJs0OYI/cjfyJkIDTd+I6Sj64unDc6ITfaT0BXuw7DAARN80i/QlHtqjLZBQkMJB6b68SMEVUDXRqOO0zGYR3boAHj330aGskAau/129V5FTlCphiGNzxJRIGk7kB+o8bqcMWBzl1MrdyYITDRbcS4Ir/sf6cT934z9I94qmEDLVO80mavXKh5YsHNR5ePeNmIcznBsSugkEN5rQr3oS+4+ud4Rh5/Frah9vMOz/Od+Uws5NwJS05MIQi2GfbqJSNFhLtvUeRaEeTu2C78qGWw55Y91cY7kDTESK6EDwCamWbmRKU+K6jp4lD77nltCiBs+YRPAcijcK7FaFLUGkr86Z0pdsrJvAcVT1ZEVNxkbWhb+QXsBV0YPZCOxiVx+egPeWk6JhXmfHXmmiZmOSCoJQuYSbLwEgd3de0GAUOk/nlbpbZHv9VpWYEgxmlF2ffmqOIcej7INEULoLW/7ByEqeUTe/9lxIMfdPo8rlJsiMxEOggBRcXIe72u2YsXBL1oCLWy8JK5kWwEVewb2iNpkgW1tGo+Jc7AUg1H2FrfAZjDgZeXlRTo8J1QprBRr3yCByLIXfZ1KvrmM3FmpAf0lljr8UxExXmZsijYafKjxf6kX+Gvgj4TT/oeuROWAMP3baNhSCjpZRgRBSNjP5LkfnlKHpaqUiNSlhI1aPupUXCDgEqqQE1rrDXFtYumIgkgUQ+fyQ3E1bXJ5Se45UF+HU2GW04s7/wGZt2+xirKjkHJvRdRRc4vHdtTOnf/X9L1BjVrjj6HyI9wJ50AmuUMt3fegmWukCBnB14RHZemdfuPa7LB9Dv14zwZT9am6HlXB2S1HD35dEA2U1t3mcZftcWluL6rlFzxBOjUt5bVcks9Phd0mpnjL28+E8/1s3Of2YiKy/HUacTX5UKkh7DH9bYOZHN2tQ+K+PAqMfDesqIFP+cCSTwTIO90ejw
 cgMAi2M/
 N7Ma7DRiW+o58rhnL0wZn8lq9NspcnKoQnII/luGZxg603Ur3UVhMv7OPp5HXIOj58kmhFc6Wpw2Nr3bxy8tyxQJmmc0y/y2i7M1zNhr4jXhFValaGV1tK7GUMi54YureoETjwlxDtY+Ep9032zjy1u07jYDNx7kFKtVCDBgmsLT9kTCw0dI2Z52uGAEMF68eCtCb32nSIp88KW8xzZW/jBhzEFoA4bcuKEJfNraZrSeF5WP+n/rXb1hCedUXEvdur/JEr+7M1tJzhtisC+271S0m4G8/1K09Z848D/HDkujBoJZSBDLRK1YNIS/LG5d/qE/akAknv7ExcXn7XdVknb+2ydqDSEyxNSSznlPKfXQYgWIecXkOrCxTFBYeuyLO95SPa1h4pcjmEJOnJCHxdYJhlkEo5+0+UXRShm1g+BH711Aa/AqSqjCKSNQwixsx4SRf/ThZ08cS0pu5c6IkKB1dwe2gK6UheEgSloYTMPnv1DN2duyeLMzs0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warning:

WARNING: ./mm/vmalloc.c:4284 expecting prototype for vrealloc_node_align_noprof(). Prototype was for vrealloc_node_align() instead

Fix the macro name in vrealloc_node_align_noprof() kernel-doc comment.

Fixes: 4c5d3365882dbb ("mm/vmalloc: allow to set node and align in vrealloc")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f9c..2c3db9fefeb7ab 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4248,7 +4248,7 @@ void *vzalloc_node_noprof(unsigned long size, int node)
 EXPORT_SYMBOL(vzalloc_node_noprof);
 
 /**
- * vrealloc_node_align_noprof - reallocate virtually contiguous memory; contents
+ * vrealloc_node_align - reallocate virtually contiguous memory; contents
  * remain unchanged
  * @p: object to reallocate memory for
  * @size: the size to reallocate
-- 
An old man doll... just what I always wanted! - Clara


