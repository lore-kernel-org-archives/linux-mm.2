Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9116D711D6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F21EB6B0089; Thu, 18 Dec 2025 20:40:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E626B008A; Thu, 18 Dec 2025 20:40:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E056B008C; Thu, 18 Dec 2025 20:40:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C79BC6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:40:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AFFD8AA30
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:40:27 +0000 (UTC)
X-FDA: 84234515694.16.604468E
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 74159140008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:40:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T6ihzbC9;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766108425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXujcQG4d4pSPfLnwY7QQ/B3L24bc/JbXH3UhT7rcLI=;
	b=RQu3jIRXadnP1bKQthEsbT9d+h8nuC7gZTAueOFEwofv6evH6VRmD6KQG2zVLvQEoYKCie
	UUhGQWJHtPqyIeIz84puw8+SbZjljM2wAbcxIGZ8OhdCaMvaeLr+5rY5INsce2OnCR5HjS
	Or6Hz+aeZeBv49Uc7FlEY9ZAP1G5LaA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T6ihzbC9;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766108425; a=rsa-sha256;
	cv=none;
	b=GIyd9Gcd8OrHHb8Wp8ELgp/ad7MyfzSGWe80dAvdpRWRsB4dQEoaYwElO+gaTQ1TfD8X5K
	oq8jIsPCpf02p+xTn8CLZ9TYvt8QiI5nyxl00JTuiTPQScKXf/cd8TIsn+ZZzURnA71VfA
	bCiTaL/XO4KBsCEAkEl0PIk2T+FTIgA=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-64472c71fc0so1083225d50.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766108424; x=1766713224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXujcQG4d4pSPfLnwY7QQ/B3L24bc/JbXH3UhT7rcLI=;
        b=T6ihzbC9gUACDKt6XoUFum7afdZXAGgZU3gIWEBlU2wFeE6Q++HZ1Qt5BmeSfRnKsd
         e+wxmx1fKctvqOlaQObMlSHh399MzdjIeNDDq6YuP8RpQ3bPSMneH9PjJYEpSgUo0IeO
         zIraixSz/NFvtMNehaCUJP06Q9+Yo17fOGFJWP805+5yMP2O6PjvCtVM3tSNeIpsUI6w
         tJ5fK/bosFa0T0p0bKDkqWjPKxNf9m36Z6SjPvvNTN6xCI14KwdUwSEMqSUeK54qD2JH
         zmtqXxvPaw/asZbk6J2pON1+VMmWmbt58PCO2aR0jVcSEChQvVJZ7gCY/g+E90uGhU5N
         1qrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766108424; x=1766713224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lXujcQG4d4pSPfLnwY7QQ/B3L24bc/JbXH3UhT7rcLI=;
        b=ldad8q1B3ZJc7Ovc4kW6hhWCS+Z21AozgKPqZp1zt8tcTc1ZcfnWlzdpDXntcmNv9i
         6NL7OJNGR+bry+ZZRpSx5gpx7MaVIrfBipp5idpng+BpUu55puU3sxtkslmLLCM9Bsi2
         yPvmJ8ADryKA3CPgiCPQE9pW4w3a0blrZONq24x2ze6fLyekRCUA/rq3bznklgQb2kQv
         NVKebscESEOucgu7XAL0lIri0OXx0cRYiHUFddAMDsmTAgjMSuvz8K8Yw1+NjiTBm8XW
         0Ta7fBE0S+6VIByDr4wC8XYzDgYs55nOhfW+CXuqhFgl3og78Myf21sc4VfOFVnvM6+k
         m5ig==
X-Forwarded-Encrypted: i=1; AJvYcCUE7EJTaWwcyqJ2pw2Q5bHf0gTPV05s/fWtdudd1yhz+Bp6REtAlt5VUR+LFoKf3FkgBktkmOYLag==@kvack.org
X-Gm-Message-State: AOJu0YxS6MHTbdxjwr0BfvwgQSXeT0wi9QuCpKGLHMJVQj0vFts3ABKu
	E0ZBLqXnewJdsu6uxPgQanYIdpZbyIuwXPexg82xFDAj91VFqw2nQAWN
X-Gm-Gg: AY/fxX7vidOk1bqMaofhGw9avg0snXrFZOXIvy5afN6JjFGIqpjamvx2Dol1y3aZgpg
	bP3ycQNB3NDcntEFoEMO2gheQgd4l+dAiFqftEsba2G5GH1btsyL+aInmAKjxt5aRUsZ3rix4ih
	3NBy2WS6qnS0KSyNCDhbF42PQ66QnJWt12P+b9cvCfRLI/SMHo2ZyuLlx9dZP64xR9Jspb+8ppr
	WUwbzoji3OkEIoHfcM3XcaWNUj7OVRyUSwNpukB5p3dFvUgjMgRsN5EbIWoFASHN7bSyKtMiAZ4
	ieHVtBYL97lo2P5gH/QkH3KAirFDLFahMSIlbR/3ZvWiB/NRUwhw2xwr6PyG0z7vLQmMqTzrARL
	16BkBcHGM5VRUd7Mo5ia+sInHCZDYveyph4ZRNQMqzzUQ1B1wYY+Sm21G0oVp8n1YNgaH3TRA/1
	AQYWr71KzqS4Q=
X-Google-Smtp-Source: AGHT+IEkhnBkI2xTy6+krjkg4oy487XdWneFBVKVRcd59MnMtD1xOFax36K9/qEz+okpBApxnUzeXg==
X-Received: by 2002:a05:690e:4102:b0:646:5127:9cde with SMTP id 956f58d0204a3-6466a8345d6mr1205460d50.14.1766108424525;
        Thu, 18 Dec 2025 17:40:24 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6466a92d91esm515295d50.18.2025.12.18.17.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 17:40:22 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 5E2A74001B63; Fri, 19 Dec 2025 08:40:19 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Media <linux-media@vger.kernel.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	linaro-mm-sig@lists.linaro.org
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Max Kellermann <max.kellermann@ionos.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Harry Yoo <harry.yoo@oracle.com>,
	Mao Zhu <zhumao001@208suo.com>,
	Shaomin Deng <dengshaomin@cdjrlc.com>,
	Charles Han <hanchunchao@inspur.com>,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	George Anthony Vernon <contact@gvernon.com>
Subject: [PATCH mm-hotfixes 4/4] mm, kfence: Describe @slab parameter in __kfence_obj_info()
Date: Fri, 19 Dec 2025 08:40:07 +0700
Message-ID: <20251219014006.16328-6-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219014006.16328-2-bagasdotme@gmail.com>
References: <20251219014006.16328-2-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=993; i=bagasdotme@gmail.com; s=Zp7juWIhw0R1; h=from:subject; bh=V7JnR2C4dn0LioMgl7WguO8w6hFl8CYJrTRxC+i2SGY=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJkuqxc7T7vRwlFjGfXAJPPZEb6MmU3nPfJK+S1u/Pfr2 nAoY83ujlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEzExpSRYbVy1V+uKhNfl31d 3tY/1yd5qPVxrz/kbjrv6KwU7VU7PzP8la6Z2vvv9mRZvSKz/YeLxOqYTjn7fuPIvP55y5Tuc40 LOAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 74159140008
X-Stat-Signature: ponyrifsnx3e9s5n7qqpufckjjrgakrj
X-Rspam-User: 
X-HE-Tag: 1766108425-15980
X-HE-Meta: U2FsdGVkX18Kk63aAPImG+7CzmrKeK6x8ggdjnaIZQ2SbgAqYwboCD0qghrfAhP0qR/k1ymxpZyOx78n6c3ElqU7fzubWS+dMYTbegA75mfJHLIDhYIWAXJi95DzYCziXUFWxWLoNw4XPA28legAREhdadlF+XlmK7ARqV7tiLZW6lD8yAXaW7JTqc4xlQDctvLfIIZxDu52i18V1lsh/cNvP3Fc88qNpLhch8ou8HT4c4vI3CclaQQEuKvjDljepHqW5e6CX9KFRohcNCHawSZTYOQH362yVu5UfEPRuz72zkjZt4WIki8saEfMEEhHp4YLFaeN/4Doq7krZcbMRt32LSYxdVFlmDjOy5pQbEMMP8MVPXMFvD0Hzyt3WHLpYxzZn6XlkN5bUi5uare3Kqm2IPQy6TxLTymRpkpDtKffJZUqRel0XXUwcCvNjHU6I+KjX9Bmo5fn4iPCtmJiMzFpVz0AqXVv9L68/BCdxGt/uQ6v3Wzs8M2zFQq3mfl5/yuIhpyXmF2v/gUwly6KcdgAwX9fpaEMoJgblzDZOoD6SmbEhLup7QJSp5qnsG7bwqcUfViBOh+MHXsYdx/gEsh4QOWJIfXKJFRvRGylNBrPXRA5sxMMcY7bHZwKM6hk/SGrvpC2O6WJ/3/ya2VRkcvNfOlrhspacYwmLOk4b7akbliAm045KEYR6inXifi5Z6DOgowENaB+G8ur/FCiXIbboFCSo1D8Ac+uEhvqpCZBdfeF3vpRp2PVlMy11PkMqajFoQrBTpsv6b3SOLfU2M8uEsvIbl8BDLeE3yaSO7sMgLvV7uFT9yYIm0qQR3zFfwEzo6qLRgv6tkvQFalrFxL/4G110T4aZUhTuBqIztjDTEsuKLuKbCOhNm7gd/w2dLoGgbQg89lxeWyJ1fMcD6E9uF+2UelLRQrUJbcxjl0xREH9upUa4reT6+BtGkPsJmUl6w2XgV1wnHIyUEV
 DDdYgHHw
 BUF0E9rItHpafb9W9ok/ImSAC7rHt+NAozb6FpM01rlxoRnfeGeCbrdGiJFMO85ziIu0Kx2ZDnbEUas2UC4ye0ZNX2beIV0ewsGRgmDUUpivOLNVqrvgra2GZc8ncC5SiOmmh89fdCNfq3E9LNwlY11bHRl7D+V0m3YIimUlXYcpOZhxDCTjPdVLVZad92MtmpARy0hRGId56m09Vq6VH/tmVLeZW/UeCgovnXzjTEAasMHG7qRDdC+PpHCJv3G0axfXdk+1CIye91ZAbcjaawySk2bKWWwfPmSSkg8ZC5KkxbKwbXLlR9YRwamQXI1W22r+TIYWvPVLCXC22HYzUoR9DhC+VxOwknXmgKiA4s+oE8/FYHSV0G9nafyvF3mMbS9cQe8BQJm/WwfyBZhwKpmUaFD0C+J4yy4VRxlxDggWfYHFGr+HqxB0ZZFEu16/0eNzxQ0ogDVXdHXSMwAy66ukKXmVAdk7X33/Y7X+H/fz+nWuTwuxygJF0t44bs6Yd9q9urFE6o3g8wtaePVlcpHxS90UEpYdqnGT6pYoiU5cQYVANJC8/SgGVcA==
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
Acked-by: Marco Elver <elver@google.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
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


