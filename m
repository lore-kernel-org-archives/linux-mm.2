Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B02ADD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0596B000C; Mon, 15 Dec 2025 06:39:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB226B000D; Mon, 15 Dec 2025 06:39:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C0B6B000E; Mon, 15 Dec 2025 06:39:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4571C6B000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:39:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18F9C16015D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:16 +0000 (UTC)
X-FDA: 84221509512.07.9DF8AD9
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1552014000D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dgJ+rCnC;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lORwJoeOdmqWvp6Gaq9g1tKkad6KEP5mAC3mejLEu6E=;
	b=3SHWXe+5Ku8DhxvZhgG4HviuYz/8xPPe5fuMyLRVYc7R4LlROU460hDXGSiRYSUDDPJ714
	sG4QZyaw5Adegr8pPX+OL/XXkFC6nRYAa6ZupgrCogyULrzYJIhwoVdmwrpfKDCamGFvkt
	E/W8k9zrqmJuk1ebww+uqhp/+oqxPOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765798754; a=rsa-sha256;
	cv=none;
	b=N3ECfldoHuTPmeUo2ApYoONaMrMxFTOuTBXs80YAUC3U6Iog8N2J4ZnRyARDeBb/7K08iB
	ZVgrDeN98sbhll1ZAoc2LjZrfcAKZK1NRDbFnC5tjzUYRClnkLi5VZQTQXIxQuf1glqmGP
	ApRNJaBCepOfUMA7JgwUk8eaVZjsBm0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dgJ+rCnC;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so3571830b3a.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798753; x=1766403553; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lORwJoeOdmqWvp6Gaq9g1tKkad6KEP5mAC3mejLEu6E=;
        b=dgJ+rCnCRkVd+Kwfl2aPt32qTBKYfcW7Frbo/L9mxnyQd+tGiNFlsiC2tLV3tj1wXH
         u5jXoOHUiVULqG3qeZEGzEmobZbSnZW7mE2dOQ34iX2CsOipu7eLq80dkWB9UGdnKu1h
         bJbXEXATa8HK3IijyydnSPH/id/g6c4PuRVQyFhaRe568zGiBkidj7trxascaSG9Dg2W
         aulixHkQini66MGTGdDF4q9gY9m/6m+JYPxV7isaJsD7hBKLFh8gXub5TPVWNXJ4az97
         bX1XhatccHj5jkTYNYiqAFSG3ao58xgiJHGOO73aoGFa/G3dI3EpExWIvChB5Tu8KpgH
         YoQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798753; x=1766403553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lORwJoeOdmqWvp6Gaq9g1tKkad6KEP5mAC3mejLEu6E=;
        b=YlWH3V2lRqET/QIXATbenlScE+fm8lpTY0aoeSxuj8AcPg9Ni5kyqi2L8+nAUwhNEa
         sXdBzLnjjzU2DMyzlCh9WHS6mnusw/s9s2qmO7gQCargGEnSAW+KJl+pqhXEZ4Jh2A0a
         7xkMis0Sw86ZkAs+9xKps2CCGUsuloA16BlKOiWLhQba7GorJ9236j8SBNN9D+pJUPdK
         zx3ZTzyqoEjY3u+WSmNgmqwLFgrw0kS60n2Kvj9xagzCPpdK9n/5nrx2VSsUqb7URJTg
         g9DfC9ZB3/w4EC3SJDlbQ6ckP+tTSs2naJEwlg9hLaZVE+t8ftsWs12p9EwE2DelqJ4b
         9plg==
X-Forwarded-Encrypted: i=1; AJvYcCV8cx3f4vlqN3cHPcHAtv5LAHiDvm5hpMbLV9AwTBavKbe9sX9Sq+lMZUR5xgNkxcUnh0X+c+heTw==@kvack.org
X-Gm-Message-State: AOJu0Yw84oXnHj1sMoDlIfmjPHd3yKMeGHxgtfxks+D2Px0Tx5fKKzj9
	6gO19kBbcOdAyx+Bw9sdH1rNfbERWFY/Bf0d/rzlp6LzxSYqmXye0S6z
X-Gm-Gg: AY/fxX4OR9MKhPBT5l8NL/MeoZLLmbTRn2pXq0PX3v+vUskSaS2/MKU1vxH77oYIQ6A
	VjERhwV4GvSJs+DRdmet3n9fv80LRwWGYet9Aflyuo9TyJ4YbHCy2q6BuFtst8tpPc2L/CtwTgq
	KDSMYZKDYCx32mtM4LQAj+7HibNoblWxoFsZDXslrAsLMyh6qw34cH6R1V3j8j0xW33xUCfi9f9
	dRmQjqsb+vmITiUmm+3DMbViqukb9+Ngy05WqLIabRV7nnxBJuAVteHe8oYOwQVz91b7n6bpRCA
	2jKa8RQVhnVGJZ1QWlvOH0tvh+NjES42oYMwuAFX6JfFqXdmiqHw5gRTEKYGW2c8SUOn6xvy7T+
	IMSYgU0TXLwR0z0HPgbhZNagoCRY1iQvOuQEGyBgUszC+HwPNv1ATbXCiKrTOPClt36JVJs5K4t
	hFP1zcn20kPew=
X-Google-Smtp-Source: AGHT+IH43ZxDlO+sXZpKsRY9ws0CLb4ZSMlMGi8iin8W4Uc9EL2/AE6hhR6bEKC++ztievLapVcsEA==
X-Received: by 2002:a05:6a20:6a28:b0:364:387:8f4e with SMTP id adf61e73a8af0-369ae490337mr10620715637.34.1765798752795;
        Mon, 15 Dec 2025 03:39:12 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2ae4e3casm12755809a12.21.2025.12.15.03.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:39:12 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 811FA444B394; Mon, 15 Dec 2025 18:39:06 +0700 (WIB)
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
Subject: [PATCH 05/14] mm, kfence: Describe @slab parameter in __kfence_obj_info()
Date: Mon, 15 Dec 2025 18:38:53 +0700
Message-ID: <20251215113903.46555-6-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=849; i=bagasdotme@gmail.com; h=from:subject; bh=mcnZ1soLgF/JTT1YuxC/XOQhVy9SZYDoshinxHejwDU=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4P0Tdf6vI2dt8iwUrrPLU6ToytxCmtRXso3wY/50 fGG9Ws6SlkYxLgYZMUUWSYl8jWd3mUkcqF9rSPMHFYmkCEMXJwCMBHZKwz/nVbIB4ee2zunpOHQ vBz35Ga7xwYL3V6/ES+tt/jmsMTsOCPDXNsiGd24sMjVrB9Z5rD2NZvPm8/+bp/rS8/i2IdH8rc yAgA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 17n6o48fk9m3q4tu8ydki5ts3a6n5ak7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1552014000D
X-Rspam-User: 
X-HE-Tag: 1765798753-52326
X-HE-Meta: U2FsdGVkX19jZmU5Pci3BfiFh5lbx95ZobykXGrYngeKo2BvnZHSEdX1EvbIYLj8oQdZn8H7UFIA5GMGgmbcnf+kz3u543Z0b3ztWBd1nceKcPgomK/ubQZZ6bSZLWzPOs+O44M0ejUW/vZJ3wclpnZeW+PkU05U7UyrKtz97mxVpcntJzjf09FmA5a+IYpB8B5LGFOgbsbIw+i7ExQGAbenqedmcPUKwsv4Po161kwHpyEfle+urwKQnDnxBPJToGY9R+HkuV4rhJLd1hreJbkfhfD2WvOUae6lTiafPYGNNbLYm8GEkM/EK0f07gcMUVDmCCYBcXz1gu7R80rUIHSq0ddN0TGUnRstyrOAp8VpO3t99YX0cvLFfesUHQkmfb7NrcgSOIo81blz+HUor3H3V8TD20DpVs5pHOY6pYVT4Fdf5G09ZwoYAKKKoR/xx+LHs6yNkuQZSAOujdAciaoKVAJWihS2TyNka01NfYYvIkR0nKwp4K+ghI0+NWyWS+D6IUlnTUYsTVwVw8qiAiOBJK7BZlU/bJCbxhHkN5JDvVeJcuBPCn2kMH8UKbrp19B+EDD0S7RS7HSXPuvD9Z9k5k+LQETfZ+EIuxcPd4gHYjlnNmU7iYPA2+GM7+HS2FfypwX5f1XzTnq+hzsNGhxHH/WVXZZIeF7nuVTzQfVnxHZvKPIXPSpS7fYF/lPotC2/u1cRlBXsSqCTfBVTMIA2iQH4ryd31EbQwr0SJpzX/ADgKD3hZ2w6YsnmRd2Ut5EpiAY439JtrQb3P5AT/PIoVDTnkOnfS9qh47a0zo6VLzPYNmIeXOcSGZHgD5x3ByLduHfUZ04jWAPjujH9yp27KrV0SMPoARPLEi10s+fbssQMWa9AZwB8NAHNqJ1nu6j2LaK9K7vZXPnu+UMjbVYWubikiQVHm1/+e4ZprVzew0TAVzjwF6dTTfMh8P485nHan1xtorQ63WU0JPM
 RfmggVDq
 6hTneVXq3WKltq2sWcVe409M+TUtLggQ5TZx0BedtdWI+abTDBPmakHDFADBONRmubZHJihoxaV0QPHurYQscKRcOeRF0eUWr24KbDOlQSrY+HMDqf6GiTSE6FZtZ3tWj5LZZ/8IY4BRWmkb8x0UoGGHKcScjmnselxedImzH1XxfWkvL74gn4Y1wc3bmJyfO1edE98Z8KVJ7Nm3n/dTcRHz2uEmM8VVX/Qfr+7rVVPW/qUWR4zwD4A+W94+8lMLi94yKn7QrNaI6IZD5corrbmP34Q1aTfOhIizCWWgJ4T8G1OHYDQM0sDLwnu7lf9WW752N0NDbmErMAFu8543NV5P/qsAYO1N8ZaGmE4sZKvcHn3UKxRqY98wssxu3q4Bk7PsL63ZufCAWcWOBu4qcnFJKqb+hKs05OU2mZe2wauI1qVZLtyhod5fX/VO4yWkT0SW7Ip8vHZ9V/K4LdeDtGoQrk6tWtKoklzsyOLtsmqd+el4qo2xwk0AN7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/kfence.h:220 function parameter 'slab' not described in '__kfence_obj_info'

Fix it by describing @slab parameter.

Fixes: 2dfe63e61cc31e ("mm, kfence: support kmem_dump_obj() for KFENCE objects")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 include/linux/kfence.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 0ad1ddbb8b996a..e5822f6e7f2794 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -211,6 +211,7 @@ struct kmem_obj_info;
  * __kfence_obj_info() - fill kmem_obj_info struct
  * @kpp: kmem_obj_info to be filled
  * @object: the object
+ * @slab: the slab
  *
  * Return:
  * * false - not a KFENCE object
-- 
An old man doll... just what I always wanted! - Clara


