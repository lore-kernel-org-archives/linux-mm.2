Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4077D5B173
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53A66B000A; Mon, 15 Dec 2025 06:39:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDD386B000C; Mon, 15 Dec 2025 06:39:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA0A6B000D; Mon, 15 Dec 2025 06:39:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83D206B000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:39:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 489C51DE7BB
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:15 +0000 (UTC)
X-FDA: 84221509470.01.BD46F27
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 413F1140010
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DWC3H6JA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765798753; a=rsa-sha256;
	cv=none;
	b=7OkNyNk3dGDi2O1va92HqT/sBVdFQlsGL7/jJZbRkegEMGufPvC70NhAb/u0dV7+Dlk5zS
	HwHoQQGayna8MF5hQyG3sIEFUdmHGIrF8/QB/svliGtPUj0DL0i6aZHAeNs72KqVGKIjhK
	sDS42FleIgQ6z64oZToVHNWgAMYKwUU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DWC3H6JA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWXueLrhDneeDmCGizpSHzMSgAg8yMgxTmeT/qXEn+I=;
	b=IF3VPI7rX9ORAAOL6DAZISPKNA1/oXT932LEW+J/8VsXPa5MlpwCCn359FI/ibG00Zvokn
	aUms6WS24gqs7UdHVjeeyEyNFtYQdEHKpVVp4rONJuvi3ugnCLI2xPBzlBWm5t9Vn/z2wR
	qP86Ta99PY7+gQJuLixJBbkqbfxSJ0c=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a0a95200e8so12476255ad.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798752; x=1766403552; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWXueLrhDneeDmCGizpSHzMSgAg8yMgxTmeT/qXEn+I=;
        b=DWC3H6JA8jRHJbMPNq0RpRfO4lDkYHtKhzzchfM3p1RQJqlNkmP1qM565VagEkMKvi
         8KsNMdRTkPzOnSPX28WJWaVdwH4Ie3vty7RdedZR4Q2V/FdTBgaQnTl0L7i0bXFFRs7a
         dylVD0fohkus6GK/+lldwzJUXTo/jL/r799lkqjQiH3OvIe5FupQGg/fYmmeut4Sy69g
         ThAan3iXyATvdJ9xyPU9FkIPoSlh3CpX8LSbvCzcat4AlNsRV5v0ousO89YyyFWAnzpk
         T3ZBG7tP8/5kDtoiRKil4mYAH3DhCJZPxoSr15EXwEqdnL3I2TAAxBd9AvIbgZe0xQjU
         EcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798752; x=1766403552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TWXueLrhDneeDmCGizpSHzMSgAg8yMgxTmeT/qXEn+I=;
        b=qK2kgi+ru2l6PHQ3L5pUaE6J7trBp2EGf4ER0edtSf4WXk3fqPCu40BbogJ9C/6Imj
         vUJ8FB+egD1VxZ+X4a+xtxgJvUZz8K3SOccB9lLAnnm91NRO3CmlGynn6MzLGhgnFuoU
         593kGSQtjGK+z9r8tRrRRpC54zXU4HBW0lN8mUDOUAH6UoMxmk386LYYBFGzaWOK23wR
         wLdLNpScr01uO0y6Ana8et2/OBYMyKSVpmjQ/uivIYRLmu6Ho9jKdEB+lH7P4pwLc/wc
         XdtpysS4AMQhzf3mCzLFFhWHD/QISB7A0SDYjb16RLk1tXhAjvQbOwUhGTcZ8H4n4Msj
         8pmw==
X-Forwarded-Encrypted: i=1; AJvYcCXj9wBD18R8Q3PqVe+26Tl9Yuk6wenDb4DPCWbJH0U2T+diwIxI8Yxh4aPQYyR/hm9lrbI06TqRdw==@kvack.org
X-Gm-Message-State: AOJu0YxgrHWD7SG0l1tRrcws/3lE82SEMuxm0ZbAZh35crYcSpxltdx/
	qnC2C5jbTRSS2TQUHb8Allr588LpaKXA2aDhRe0/5EMkuvVCw+N9Feg1
X-Gm-Gg: AY/fxX7lEDQquEto6zfq86f6blhzB5VvUshJauYHRFWceOgyAHxFOi4W6XO+8eR5XpP
	1/qPp4Zxc9/3z+7S1E4uMGp00FGXfSXHODfZXBWKruRRQd4uncOYy0F+eQqsp9z1IBpXW11NWtW
	2SM1KAXDxBks7pRYLYz/leWBHRF6ZVVuw+dqu8dBk0IktWS6uCMG0zPRuQUeWXbksPPzWYOIlC1
	9pZyDhjcO3FSztMfjt4lEVnB/qmIDJ6NnsLlmCF/lv0rdEUnLib3ejppi0306VkDbNf8qXelCK8
	V2tScDBpxx5MxbiU0Qicmsfzahbg2oIdM+QPk5nhKK3V9rLMUHcKoNNCywZ3+YoplC7JQhl/iyW
	E+4Q94HEa9YvzMbi+nW4okHOzrN91nRovZzUZPBXRAMdCF3SDRj6XBLn4qF2xAJ+23EY/UWObeg
	TNwcMKpsFXK+w=
X-Google-Smtp-Source: AGHT+IHBwyvn37cMWft6XaLu78i521F3TitB1ZgZCjrLkgz/dWJXwkRq1mT1+qz6m/LgaTgF4rxTDQ==
X-Received: by 2002:a17:903:3d10:b0:2a0:a4b7:44af with SMTP id d9443c01a7336-2a0a4b74893mr49683665ad.26.1765798752075;
        Mon, 15 Dec 2025 03:39:12 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d36ddcsm132733715ad.32.2025.12.15.03.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:39:11 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 504F3444B392; Mon, 15 Dec 2025 18:39:05 +0700 (WIB)
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
	George Anthony Vernon <contact@gvernon.com>,
	Thomas Graf <tgraf@suug.ch>
Subject: [PATCH 03/14] textsearch: Describe @list member in ts_ops search
Date: Mon, 15 Dec 2025 18:38:51 +0700
Message-ID: <20251215113903.46555-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=896; i=bagasdotme@gmail.com; h=from:subject; bh=1tOY86lhWOCbSHsqmK/tuDEilXGPwKXl/15tM3wSixs=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4Mqzx7cbGl2s1Xb5iYDm7bLkws+2881173X3pa/f UbeT2+PjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEzk0hqGfzoRZw50iXbWS+pV RRyxzVGfNT/eQV3w9+MclUw9PumMlYwMO5cdc7i131P/rrG85octa1tun66WP3rW6W/Ropnr7E6 G8AIA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 413F1140010
X-Stat-Signature: a1cfon1ibdhc9krw7suwf18fptcf6tpf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765798753-171988
X-HE-Meta: U2FsdGVkX19zXxbI2BkPmHxhGuszR2Sb1q2yg78fWeJdWMtE5gqSU2XS9xsywkrjBLzNtjrkzcLIhvM+Kb9U0zQrhYsEOFsf8+2TMy1OsA5AbUe1Y4Ptkrjv0H1iMRS4/lVWq4UWl7DiILFIU7TqL+nicrSRyPLtTei3MnriH9FLeK554YKN6sVsJVWFUWoGw/I4f1xWS/cpL+VAjoWAWYSX7GsTVVcFNreeGoBKjax6L2kxgusKb1edqi/SBLxSEz7rjoMZy8KQio/xWUtH5sZLxawRBUg3KE7p07uNTl52z7TsBws8sFfriJoaRV3NPQBgdZKFI8/Gp3TGxM00n3DLbWjB8gz60mNFFPWI2gOpnDF1cRJtBXAU5flwFIkSzXQUPdOP2LAM9egO6Yzq8AYXZ1Rd/loDBX7oNSAWDLsk3Lla4QxwKZiXIipXO3qCFq+oQ3C/1GJ1gVy31R4zbz7qa1Kfx93kg4xp/PgKRFsR74h23E6mUZ5vat4kZIUfHNJNyxnNvx9HVLD+/ifk/1A0lAfhZ0iRDKrQGJ7r6+ud6l3E0Ku2K0KAP4JTUaf+jUYDYy1w8ce4VkQhKj8ZJTUc2nxgQ4rTZmMtQOu/lXtQMo+WENCRMceFEqYXs5K4Vrom2DmqueBk5ZVF/AlLT63ZIdT5+HLP2y2WQkNZOk/IQIfjgZikxzofzajFa/5+EKIYAzu+N2JRoJzm2t56Bd6QKHOUaUTU8Us01K6sX1ypjSgRcG1IXnHsfDOSIv8dQIT2T+1MCbo7VlzBNlPFoViAqWhNGdXLQXZNF5n542jR9KdsOE58txZphVn9RkUbDI3No6fv12Z4rA3b2MEBz7cuv6+drbFJRXHLoFQvTu+GJkQgxnmh//Dna4lHhd6G9nDks7K/mSSyCBVHrG0SQn+37onVCJQflKGIMQMRrP9fDl0wehrkENU7Fs5xpwolowi0SF4WyuYejeMA0oT
 /g/1uWr7
 N3FAdZY6sqBEVcpSF+cbCojzFfZjnyCHQLLakZEoFBVBNpMKfX7avcTYjhzIW+gh6sz1rU5Q4dq28KuD/Mn4qg4i+Ptd99xNOaJQqo6YFx5EbxDQRlq29TynTLiKZnxzLUhYGGHRUZNe+1xJWmcASF+HnqMtmMSOMcTSYCicmrdXz4AqFnog3BKeGdznjapqtFkcez21Lxq9ejqU1qmtLU/7essBeTApuXz+KyqQHXNUMA7UF3djtKfnzn1ztKJResV/N3Yg/2HWt5JJzGNnA8xg7N5GOjbwkEhr/ExYcg02i8AGPTtQxXTOwvycg/La/kAq1pgrCFI0ypzG3j8P2iRrPlTHRGSBOHmF9EEvyyA/a8GpmlNmRIvMfgYWTc9hIbPnfHdvyruYRpn3f7TxiYOKATe62SZMbEA1Qz+Y82/quOOyoz+048TZ1kLxJavdkmxcCqw1QAPC3rr115vG2WlJM1EWyMLT3BevUk2nGCuyM8NJhgS+MsllnqUUIT4FtGp5BIQBTC5BMgip/AOd2PQMO0ke5ueE2RPt3VkqgAHd/f8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/textsearch.h:49 struct member 'list' not described in 'ts_ops'

Describe @list member to fix it.

Cc: Thomas Graf <tgraf@suug.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Fixes: 2de4ff7bd658c9 ("[LIB]: Textsearch infrastructure.")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 include/linux/textsearch.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/textsearch.h b/include/linux/textsearch.h
index 6673e4d4ac2e1b..4933777404d618 100644
--- a/include/linux/textsearch.h
+++ b/include/linux/textsearch.h
@@ -35,6 +35,7 @@ struct ts_state
  * @get_pattern: return head of pattern
  * @get_pattern_len: return length of pattern
  * @owner: module reference to algorithm
+ * @list: list to search
  */
 struct ts_ops
 {
-- 
An old man doll... just what I always wanted! - Clara


