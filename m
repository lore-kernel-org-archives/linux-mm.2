Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D642D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28F276B0008; Mon, 15 Dec 2025 06:39:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1AC6B000A; Mon, 15 Dec 2025 06:39:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11B06B000C; Mon, 15 Dec 2025 06:39:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF3496B0008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:39:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8ABB713862E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:14 +0000 (UTC)
X-FDA: 84221509428.14.0D0E130
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 73CA3A000E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iiONWOy4;
	spf=pass (imf25.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6vVzDCLpyU2LgSSSdcXlxGJ4GVOIz+XeeVoTvfPkdk=;
	b=sQ/Ssnhgv6bDjbMUoraSOmUbZH8wHmQyAOf2xCKJpFX4IkllBMCoUSnE4/OAzBNMvMeJ2z
	w7a/9PxnP4vjnHfnhVjkpoACGIW7jFc6LDdEMIZTLA0B8oOksDd4Gn/p6UmgzHuJFmPXFg
	9+T6fN23rYZIuVJ6U93FXrU8puGZz8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765798752; a=rsa-sha256;
	cv=none;
	b=gm+Pr7DqBcG73eu4YwqSrNv8BsHYXkW3P4fE0kZnGrCmUXFmkhrxMUSiMYXmojerI6UrS9
	5Fxs792swslwjf/JSJ3mai6m2b+uRdcDC5SU0AHwGIGoTWMdZZFoDCsX1J0QdN8Qu5WVrC
	m4dkw+txNPaRYrrghfFDjiYw/WY4cng=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iiONWOy4;
	spf=pass (imf25.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7f216280242so956416b3a.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798751; x=1766403551; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H6vVzDCLpyU2LgSSSdcXlxGJ4GVOIz+XeeVoTvfPkdk=;
        b=iiONWOy4lUdBoCDn2EudUtPZI0h9sruqxm9XFk2kW/QtnTcKOcNGcjJcePQIdW0aIh
         ErJowF/qkTIerprlALR8zrKGunNSGPPhBba98eaD0Ti77QvTKTgBHAzDpgQMJ0+d66aR
         YUzFVi5Z5gbedvmdxM6nbkuSv3b+bRgbGnDmWCR1OcVB6A26jBbK2NNSeZ5n1tvB+yYY
         eG+xVakWBvCURbViE/3lZsI/KXM0f5Gh2rw/+ZsH7RlQ7wzeYJJGyf27YdFngshxTHY2
         rkOflfphs1AEPjxVsaPW1wUj4cpIH0xMTk3GTaxjAwMyh6a4/QQap1mePGccEwz1QSfd
         bZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798751; x=1766403551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H6vVzDCLpyU2LgSSSdcXlxGJ4GVOIz+XeeVoTvfPkdk=;
        b=T0EiKwRMeePD8hXdRuB4hTjd1u5d1HJv+MDttrfBBTk7FJW/ssOkeBT0cuZT61LyLl
         KTTEu9u5nrk6IS2Fd49infjIcvN7UiiuYepfzkD22zWbtq72cSnT/rH0cnStrGuh2KHp
         cvKq3nhKyBG2kk3DzJeaHf7tzEjxBfbjQ8aAS7krv3BPaS00hi6eWu7JCIjmYpas+OTb
         MQVEvaMvTL4Cs/8FBe4vGWB83sKSZFnK0cKnqoNiDi+7Ia2I0Tw0yxKXaW2nGTDNGrlJ
         WlhY2YZ3P+nwpIHN6ENfitfpogEwGz0AlMBpUPAp54x8ttMu96hNII6dD7elQN+d/DNA
         KTWg==
X-Forwarded-Encrypted: i=1; AJvYcCXMdLkgoy5qo/p75LeCvQrf0aCq0dzj9Yu4z2nZ107mRe7lgsAS6bmbROpeINZnvRDRw8EmcnGglQ==@kvack.org
X-Gm-Message-State: AOJu0YylkXJ74EBbFrnIl03vAUXakxRpov93fk2bdIPd7KCwcTJgbOJT
	2/YzCX5Dkbo4irbRxni9hEOGMGD19fteWNvTvQ9odVexUdGNfp2vjsye
X-Gm-Gg: AY/fxX7YgDRLShrSVdy3aKzLh8xF+6iJ3MBoDhjYf7yXTDt/F/4m2JCtQu/yJ2kTdkR
	4AfcORqi2DppLfTb4rIEdwn3VKBd+2T/r/vIzUdmNh/NLCTjPhMa5XWStDHwLqE8HfBXuah/llI
	YfEZJt4c+s8rN7kkNBolB7t6UcAbda25IyGmP+WFg6VqTtt1DnE3CW+nZWMWBzriW89QOar+Llk
	KqrNoZA3RxcVxTjxQGYn6bgC/lqnZWDtmy9jhh1M7rD4Fj0PxyAfw99OUGRXqPippsOxayBIU38
	pkPVwvIPf1AlYUKevLh/hVkdIs4Fdj2AYOKrkfDBkC4r5UXfQTXsV+3fFog87OADEYlwFpnqgRC
	FBjTv4+PpvzCk3FcVFbbly19zqMPJ+odvA5S2eueld5quwnLAUDDBTErMUjWqV3aQD6RspMcyMc
	2U48OZQVfUusw=
X-Google-Smtp-Source: AGHT+IFlU3I+cKXX8C9kVGFzGiJyAz7/LTk2+tkj0Oiyk+q1A92AqVW93jQniiO/3heM3uCR/CKzzA==
X-Received: by 2002:a05:6a20:728e:b0:366:14b0:4b16 with SMTP id adf61e73a8af0-369aa740ecamr11005465637.33.1765798751132;
        Mon, 15 Dec 2025 03:39:11 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9b3850csm133388085ad.17.2025.12.15.03.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:39:10 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 1D26D444B391; Mon, 15 Dec 2025 18:39:05 +0700 (WIB)
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
Subject: [PATCH 02/14] mm: Describe @flags parameter in memalloc_flags_save()
Date: Mon, 15 Dec 2025 18:38:50 +0700
Message-ID: <20251215113903.46555-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=950; i=bagasdotme@gmail.com; h=from:subject; bh=zaXx2zRxHwtjfsFTgY05kdIMv0UeQBx9b1FFiByYYYk=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4N0b+unPg8UXJx6+/+iP9I7pV1rdBYrPMm9NqGYl enCm2OnOkpZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCR246MDN8qzkf5GvF8u6h8 fK78A+u9Z2vjTS5MNJ2mcnT+/S07J0sxMvTNsLugLdEgeebaKl/Lt7ZFnv2pX8UvGPzINA+RNZw /gQsA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i8z58o5mpkxtbmz8mbai46cifhg4m98r
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 73CA3A000E
X-Rspam-User: 
X-HE-Tag: 1765798752-982406
X-HE-Meta: U2FsdGVkX1/4z+VRAFnw6BaN46Fz6LiXr8cepyeN38adhmpL80225EUl8ZqA+5nk6PmfUBoaLG5FAYZHqA0cU1Stwugj3ctqXW619KrZxP6QgYukYhhnWdxdlXiCtgSXZVurPtt2OUKkmgfaULr6PJtMosktPobGPNPReXETD/qpklHa6x4cySNA0qCK3XEXT0AiR5t/Jd1IqQQla+MsTrUk5NSaCOUL9aw1aHmoqPPuORs8tILwgqym+SDcFGgvHDEK6ob4XHNiV7dPM/k0wfnuwnkz32poPOAg+FRjfgMXlLtAGv/WYHNYW3Ir6v2fwIQT6kqLZER6HwyubyhDkTLDgWBvZcyiOI3t+tfijpbt1N50oowZ73OtLxtIDiGd2JAffRPZQPl3RWcJOqnkqJIBbGiem95kiSpAAziZdLOynhAFUQCaxdbXflYxiUaBixw/SQS0wkPa86qa4Ej8zsKc6VqdrXP17Atjs995XOGdzlgHwn2Dym3VKOgff5AWYq4CxGrHV/f6u3NKQgzju0VapsyskHiSMpZUU9Y+s/W7CxwCR/RVjYr1nDlNetSIcViq7aCPzHGxtmlu5985YmJsI0iENgj7GKmWEkOX7aCiXKRLoXT91Fmda7o0X9MeeXfuisllvFAe7FyhrFJE2r4oagh3HkzAYfcX7Qf+ipbXm/nrvt+oRLzvWFl1ynt0Jry3D+gmqAksETSWAb2wOgFSqYYNZGN4ZJf/b3yCZo48x+P8s/9rUDLedpiYIbtrtK1crQmpse4TygGoBIcPeUdlulSMdEzpcs6153k+GbuODbxf8OvokmquDzWRF+FNVUe5afFAgmxXMFAa62TRGXIuB9OsyClgu2aCG/EAWe+xtSehxSMTH5cgJR5W1XWiXkOE98tgEK5jF3UnOkboot1vUBQGYeCPE5m1p5oW6hwRPA+DAOWa9ricvSj/um+AHX8Lf6QlPWzHuf22Um2
 KDZRCQKY
 kUADFMpQcRQ8EefKMAgYmmNGnoMwU6cZRnPFPlhXus3Azj2A6RLj89MtVayjyP3EaJH3x+DYkOgfG4sOyvaTBdned42SuQABh+IxCH3OBumxjd1bwJ1Dy6KrS6Xl1LRNDqm20N9wzQG3XbAY4zCUyG5HZBjCLwKaqw5yYwszWpiI0VzG4vFLGI/UOTB0F/V3/JmGMI3rk5O+hiNFMhyzhgfhXGouqk6L9D3VXTth9OT2mVqXuUaPDcsmOIMhartPHALcT2AI9OhuSGDtb4/XW8A506NtvWYZYwtfumChDREDunAOq68xBM7o3mJ1CAhL6pbG7kgi+3bRBM2ylxKUtfLoIiFrjgloOBonUD31fp8hqpelcvCrfjQ1w9+0Cs3r1fqubYHRr9vEVJM6DcYN219Rv0kQbTkwIUkuBnjvByK/ZFYM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/sched/mm.h:332 function parameter 'flags' not described in 'memalloc_flags_save'

Describe @flags to fix it.

Fixes: 3f6d5e6a468d02 ("mm: introduce memalloc_flags_{save,restore}")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 include/linux/sched/mm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 0e1d73955fa511..95d0040df58413 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -325,6 +325,7 @@ static inline void might_alloc(gfp_t gfp_mask)
 
 /**
  * memalloc_flags_save - Add a PF_* flag to current->flags, save old value
+ * @flags: Flags to add.
  *
  * This allows PF_* flags to be conveniently added, irrespective of current
  * value, and then the old version restored with memalloc_flags_restore().
-- 
An old man doll... just what I always wanted! - Clara


