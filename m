Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B46D711D5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E546B0092; Thu, 18 Dec 2025 20:40:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6CA6B0093; Thu, 18 Dec 2025 20:40:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3D56B0095; Thu, 18 Dec 2025 20:40:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA0B06B0092
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:40:29 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A86C1B8F86
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:40:29 +0000 (UTC)
X-FDA: 84234515778.17.B8EE748
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id A93F6140006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:40:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e1dSNyZc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766108427; a=rsa-sha256;
	cv=none;
	b=2YkfKpu98PibhbHdNibQENQpybRrTF7Bp0wYuoRhXGebK3Jf2wJKdJ2hIUlMSnLHjvTqT7
	rCzoBXbgv1B0mNwvulHJaeyma3N/ISDKzkPJJj+EwAuYcw7ZTXKLWxStu0GBXwkauN/qwQ
	w86mXLjzwPSwf5OYw9ke57ZYI6SnWeI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e1dSNyZc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766108427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWXueLrhDneeDmCGizpSHzMSgAg8yMgxTmeT/qXEn+I=;
	b=plra1vxNAmu2QFnJvR2CN3mfG5EcFBMXBoQcaDCKQ+85xYvFmb3zxNnSBq82P33ql3dgNQ
	dr9xXH0JKwT6VQd3QY62cmKj+aNKmoSF6aN/kxLHmw5puaMBLgWy7xaURv2b5fU2ABQDoP
	JZNw+4kHLItiTncq53jVew1wLPlxYI0=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-78ab039ddb4so12192737b3.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766108427; x=1766713227; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWXueLrhDneeDmCGizpSHzMSgAg8yMgxTmeT/qXEn+I=;
        b=e1dSNyZcxj2QBCKmpYCMpOdeF04g8nCGOu4Ydv9Ggkr6lKnimhbx+s1Kr2LUBgF0qU
         /qzuhuB1ORV+YS6LJFD68zIIa1jp6q+YrbTnqgbMhdh59+BMtv8Q5PVIiAaPydEcxsnZ
         59F1iZWbGqYANaZTotrmDbwFFrFDweUuyD/pEeHBgcanOwo5AJW8Ph7Heq/k4Ve0A4sZ
         DJLs/+E4jp1hs0w7D78JtltfN3eCnwONV67jaGCizdbgruBoGd61S9OTjzPskEwRtJNS
         JhhqVxDGeGJFyqPS8V1SF2v3viPQoj9Pxn3975iWwpUGWkkTOdymB1EFvGf9MYV7/Mmx
         cB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766108427; x=1766713227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TWXueLrhDneeDmCGizpSHzMSgAg8yMgxTmeT/qXEn+I=;
        b=LBsp4iNXSPdasMEOJ7pXJtqDmIrc+z1/96+zhhoLDyiWAO+JTNUzBLK5FHj5x7Ke/y
         60aXSiirRnH2kDUuR7LAGJ6rEHs5mo+4mH8GjNP/Upez+8o8NVwaVBUAk6Dbcasjsel+
         OBAaMQYcZoW8hIkgdrg4X3IBMPcRJbuDeS5pKb8YDj9u1TRm/W8LphpM01YFToSOuA0b
         TZNFNp5cGYAv9Ip4kpPdUvqZZSy0tfDUSv1I+CSI6qbWDMZ1jDKwH23r78MOXwfVYjAY
         xEaRCrgKjnsYHMaoHqWZ+daVrcBYfL10gJgVGM3VKsyUD/0CqtNgJD7bQBEjhTj8Llzk
         9dcw==
X-Forwarded-Encrypted: i=1; AJvYcCXafz/eKIPbbaACyKyJBJuceKRm5efiqd8aJDVUpA7DJu6IAi8/1XFg8lKMq9byQx3YZ6dLsMEYEA==@kvack.org
X-Gm-Message-State: AOJu0Yxfyp9J4VKH/oMut0+bN7E5c/8cjxruqgtOkgGhwe7/50eEoYDA
	+I9Dr6p0Q3IVsDD0iPFfUtRN6XAEsTJu3XMWszXPLnq+2CtfPKl1pX2/
X-Gm-Gg: AY/fxX50c7Wj/2TrXn3Wz65u3fFOr+oa45KSI0XsTpbIW8QqY5IEiN6k2FhJ6Ia/2TI
	ZeHfF+kWmhuVElJAIH13fyLhfjRxdGXDLAadjiJt4EX5fMhEdUQCdGnG8lFNk8R26p5kUFy0tQZ
	MBEypBPx2oKrxetOrzgoo3oeyvA96kQHPUfy5ysoEza0PNWmhBEYBgW+V3bxLdl3fWQb9kZ5ee3
	zj89NQ42gtVO/rG0rILY+6xAVcqgKrlvr8/qcNQGjZDrfWQnWxs9zOu08SQ0S1UQF1gMmACiE+4
	0hH+4RIRH6/om13HDnzzLYzB2mRzlEn2Z72JQlIvYyAcU0BEp+OWmFtahrcL7DtqiKYXOX9ISG0
	Fs8mqqa0wBNZSxhwyNDuqrc+TAzNYX3+Nx0aOWRgwMKQWebRoiTsepotF/ux+cHiMkFIxcchg7i
	AD3bEO0aHEVadzHNzvv5OzVQ==
X-Google-Smtp-Source: AGHT+IH3p9ADp/oHBdoztOVSqKQjC9Vqk5imr82sTyt1OVvJnxpaC916KbcOtyFMgx08q9d2A6awgA==
X-Received: by 2002:a05:690e:1a20:b0:63e:145f:a4bd with SMTP id 956f58d0204a3-6466a849f02mr942310d50.22.1766108426712;
        Thu, 18 Dec 2025 17:40:26 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb43782bfsm4425717b3.5.2025.12.18.17.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 17:40:22 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 27D7F4001B5F; Fri, 19 Dec 2025 08:40:18 +0700 (WIB)
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
	George Anthony Vernon <contact@gvernon.com>,
	Thomas Graf <tgraf@suug.ch>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH mm-hotfixes 2/4] textsearch: Describe @list member in ts_ops search
Date: Fri, 19 Dec 2025 08:40:05 +0700
Message-ID: <20251219014006.16328-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219014006.16328-2-bagasdotme@gmail.com>
References: <20251219014006.16328-2-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=896; i=bagasdotme@gmail.com; s=Zp7juWIhw0R1; h=from:subject; bh=1tOY86lhWOCbSHsqmK/tuDEilXGPwKXl/15tM3wSixs=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJkuqxc3vZ90ZFcEw8Rtxid2Hom5f4yhYqXFcq57N+59L vj0bM6pRR2lLAxiXAyyYooskxL5mk7vMhK50L7WEWYOKxPIEAYuTgGYiNE2RobF7lMmi/C/YzPS 7fCZWpbXxTBf8soDN/VTbIlqj6/Ud19jZGjc83oDg/Gns/PlE4ouzVAQWMm0aaeV5R+r5y+cjA4 wf+EFAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A93F6140006
X-Stat-Signature: 3p71i1wtu1cn6x8zksb4wd5yijiryc6d
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766108427-64620
X-HE-Meta: U2FsdGVkX1/qY7UQF9/NibRextHfLrIg8yHhNbWptQPh+K62RwTQxgg+Sc3LBswwtLrIOHHN05cY0fODWjdH4IIx9YA5VzY4f1n18W9dU/PTlpTzuaSOv3aWzqFvBiZowERCIATTwCBjlwYud+OOvdfjrKwUJbw6BKCJeWhTz8MFxAag9d8kKXj/1gwX4Q9slcym6L+zeu9YaZD+jsCe/zll/r8uMMFU/4jOsVqsrEp2vkc6bQqBPraaa0r0EAebqD6YyPG5ZJ31CCKvzCwcVokgpvOo2TfHVd6/5lQD/iUNK7l1Rkki2mhovsm5QL7lV4a2HcMfiVc5xYx+zPAGUWnupyb8MUGRWRPRx4cxa/ME1utkWspPd5zXfAV2661sHijqRpjRd27Nycs5Xh+7gNX+RoN8r22Vndob7PcirmGGXOLNpHs0WbUL6AqT0/ZuNQsQQ65tgSjcGIbF16kc4pCmdvT8cnMUG9GEb/Ha8+jy8/sgCRSyl0fobvz4Sn7Wkunt3oLaYFXmMU4+Ikx+/GotdREi1rtLKNJZCkmgC/YF9OY+hXCaIbt5rAR8Zl1aMwsXuVixmbwqsaUN71wk40JjnabAe8U/H4/mPlfcj4+nljWNsFoEF8nNQbEhYzcmdDnv12NyF+wya+RwmL2Zq9Gu98QO01Gg3QUTd0JLcSSPlqelXOvX4W7RKBNYZUBNDoosDa0CeFBZx2/UbAIeZPr4PTDjv8/545GowiDxBTgN+Ok5tAYQ2K38V39lhqvoI+Hdd89GCLn2qyU+rvYZKAvek6GdKfhSDcsq2YI/Im9mAOuCaxsVs4RX6ClEYlKdOeTrSywFOUHc1ZQYOJNY669R16Sg/dj89i0O4lKaC3ImvHvTAOCyF3QVVjMamsPtDMGMjl7ctZRsW+B9QH6HJ3dihbNT9cWFDJZGN84KQ4qe3E719EwCEwkQ5NabKLXkR9c5rrl1wqul4L2cIP2
 lb0u9M7E
 4UMMhMozYhK17iKvUDHHvCAoXsY7UPrA4yyZbxTkuFOJkdc70dk0WTj3SUrbHcD8dK2xXoTQY+Nq2plOVU370oprUOnBcbHr0aTTHKOlpCKI8VN/uDFuNrrzaaIpxVd3xbNgfEph/266pTFGexLv7llfEXm+kVXgkB53cq071yWZ4vjns3X78fSQ94Muf9qJVAh4UleI9dbm0EyFDcbo40sifNAzJNelllc/ImG2SAXiS+R/Sq/kbxZj4vOUuqAzrHe88xniPYqhmAeDh4SP0Wb3PqBS7rjkFePVI7KW2a00Rp8eNAJ9gpgcTNUr4H7S58bYohr+yEQ/mAOflHaAGBeXQAGJUTSDpBpzLhstyQZobc5g63qNdVoAbgjWppNhIVksWOGkoBdoP3LmecxeGKekBIjYTSybKUlKNWP383jvnRM1IJs+kkmUSm+2Zgs5v87Su5L95oH8qzUj3+xRw54JRdE2cT5UBlebvxfVh5Pe9IYAqcpkE5VDnuAWKqfgo7RGqxA6i/r1L4iNbfu2YV2M83AOicZreKhq493B4+ARCJG5095hLV/QFDYLjPTPQD+YsEkajKmoT5lol8UwzIue+gkwCB1pJq5xMSei5s5FpsY2D0/6H4PTmtwb71JjE6s8mTjcR83yb98OT2CkgtBNhLQYHndF4agAZAmq2kaivs+U=
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


