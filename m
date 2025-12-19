Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B44D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76ABD6B0088; Thu, 18 Dec 2025 20:40:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713D96B0089; Thu, 18 Dec 2025 20:40:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF626B008A; Thu, 18 Dec 2025 20:40:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8156B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:40:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECD37136324
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:40:25 +0000 (UTC)
X-FDA: 84234515610.11.E083E43
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2223C160010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:40:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ceBL6V+/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766108424; a=rsa-sha256;
	cv=none;
	b=xuxPDxF4gmxGOocoJ4K/mKeH3DZRM9DPoyvAeGpxZoRsilfqhflf72s0rsvdmnARBmYPrx
	uypCx6ZyVRd6yjV4mgiILG5oCNqjQEIMVbE8qhkRYflwDxe+LFhWrnGgiQ+xJaRCH013vy
	di+FPdutHzO84l9y3t104okq7neG1ng=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ceBL6V+/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766108424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWU/939i2tSCrFcjT+226pu70w6qgHLxJ5V3Gj7ooMY=;
	b=Z4+1QHHuUhq1ule9YPk2asWTWUrMCPTmeQZ//SqMIlGKWuurfdCcLiAtu4FpD2v1w6+yYM
	CQ6fCZmIKXwW5VN6zxP5NSC6fZFyjM/KBw5BNgajYwwNaGlohcgzOYlFQPJ231DaKw1xvE
	WzANySkS/gp5rJM4oE7fWBzV3Px3FFQ=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-78c38149f9fso8686467b3.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766108423; x=1766713223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zWU/939i2tSCrFcjT+226pu70w6qgHLxJ5V3Gj7ooMY=;
        b=ceBL6V+/YA09GEwbCaTb8K1ertIYPUq8GMMiWRWwm8GB0QHDKrAyZFMEPSAAjYEH5P
         8XRIWxL4/c1jdRO6RbmJCcp/todLL5coYsa6kGLO7QYJXPHGMZ8o3dPFyBLey2weqSVO
         1YkWbu0SIDiAP5vQ96fUksDe452FLh2wmjNlrA13zzDRf+qXFUe6sKDir+LLjPcRcKQn
         EdMfE+W1lRjEAcDasdZbF8O/eFWwAflp5PwY5s/7OkAb+0TqMy8O6ivTF/6BGGThoPVx
         ced90toDV1sPv5D6ZTHxnX4uUxq0yIapTKhhFKcnV7J5q9++WFrdg6nAhsYSnRjEY502
         qwEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766108423; x=1766713223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zWU/939i2tSCrFcjT+226pu70w6qgHLxJ5V3Gj7ooMY=;
        b=uGYUxLSMbKODieDXR250Na5HZRA5rCUwDjihef+P7SMeYEWHV/M8zM951urKFIy+xp
         up1lb4P0FwR0jRUxL/qevHixylnUSon4XqHDjSYFPZQPO0Ot3eitEFwYBTLiyrpOBzln
         gT4MEbpyroGab+y9jQVFcyiXCLPweOXcGpMOWN/AM6CdH00EvDoq46Ln0HFkcUpmHLu4
         G87mcMyRzxngNHzDf29pRO5jgwbwEHRD2wCefgm+L5OoGBJ2Sx2wy/Q25PtdTZ+saPpz
         Gxi+gmtDWom10d+sSI0vkUR6eI78DDAA9rcjXb2MWNLeysFtZM/67QGiS/FdBPNQiug9
         T+9w==
X-Forwarded-Encrypted: i=1; AJvYcCVGaIJNMRKsEYoOvO8FpOQFXxu11/rFRN8L6xi1KVT7UyCbDi4PAXcA/QgiThrBSdStavDn+iS+WA==@kvack.org
X-Gm-Message-State: AOJu0Yzr6QpT5vby3EJ2lVeivmri5bd8ITJ3WRd4Joz2/yMVF+EAvr5r
	oeafvlIsR87TVD5qhu1DtwM32fSURyjTHoT1In5qgzgkuxJ9lUfrNogW
X-Gm-Gg: AY/fxX6//RNURBlExEKwhy+nr07lvTCn6QIpER0IAj75ACim/duplSDzvyQ4H6dF7lN
	idlPbFAXyl0L4SKPjTnKQjAJk/5OMpXFi0S4K4ECyGOecJKwB1Bz0I6g6XjcImP3pJpVFXosbLY
	e6o8lhusxvMFaQgN4U1pEQWldmgvxjraUq0j6l0UPcuB4naAskLgcLlyuimIO/d2bczZx1yitrf
	nOIlJW01iBACFac/4Qc+rw/7tT0B/MpmCArgMVrsMzqB3hE0irE5mihkZ5Mplc6J68kkexvH7KV
	f9GxruvuVNdL4zSN1OE+INIQmzECze9/XC/VMBAaeXlbo88JhAmC7UNtSFUqh2CAyLBzGjWZUHW
	aHu3K5OA/PRqb+AXjsbELrJcNYi+EaObzTxKPvw90j3MZbdH2GWV1073RBwNg09Ld/QDcqdBwVG
	T5ely41TtbGgY=
X-Google-Smtp-Source: AGHT+IGs2tukAAuVEYuoyvWSAIB55Pm8uLOrTuzGSfqj+LUZLTOqGV1IGLSl8HlgwDUbktyFC3gpDw==
X-Received: by 2002:a05:690e:2508:b0:644:60d9:7509 with SMTP id 956f58d0204a3-6466a91f1abmr672663d50.89.1766108423013;
        Thu, 18 Dec 2025 17:40:23 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6466a9219ecsm521431d50.13.2025.12.18.17.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 17:40:22 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id F36A8400AC5A; Fri, 19 Dec 2025 08:40:18 +0700 (WIB)
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
Subject: [PATCH mm-hotfixes 1/4] mm: Describe @flags parameter in memalloc_flags_save()
Date: Fri, 19 Dec 2025 08:40:04 +0700
Message-ID: <20251219014006.16328-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219014006.16328-2-bagasdotme@gmail.com>
References: <20251219014006.16328-2-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1052; i=bagasdotme@gmail.com; s=Zp7juWIhw0R1; h=from:subject; bh=eU57T2ZpTrhAT3InMTPZqCoWbG3clhbzONj6eMsT294=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJkuqxfNrogMCI4/WrDUaoO+3RymE3bV6Q+sNzRe2pcud Lf809ZTHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZiInxTDf4cMXcuuCb+M7mxc JlueWqmSuHnp9SdZCbMLqzXbzJpYIhkZLuu3a+wR9BT+vXnhUY+bUZ9Zb5hPXcn0objE7/XDOj0 HJgA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2223C160010
X-Rspamd-Server: rspam03
X-Stat-Signature: w4uqcbkyte36p48xkjhqt4hq35suurnu
X-Rspam-User: 
X-HE-Tag: 1766108423-80271
X-HE-Meta: U2FsdGVkX19lq7V4dsfgwaeNVknXTC5o/f0LXfGAVWRz3GC1rGVQU21sVRWdlnMN4ICUeuobcAGxWkVgFi9bK8KsP2YeQ6kaiItqZgfINBzCZhMHcz9JTl9PIqJE2x8hd2gCysalbbZU9HzgHZj7FohwZfgCqVS8btFzxsJ1D0wRV5H3yBo7m8Im9XQKSPDZ1IQsSDT5cKyt/IWRyrwH08aQeJ4BLxITO5gLitxWoLRYgmItLk4rE5MqDwCdxC9ww0Ip2le6s70SXacaEL4rWBVvFt5/IXSnY34LCcl+4/z0l/ayID0sAlISnF3sj+vqwecXymM1If7C07OWsyS18fTj9CbiqDESr10gE2fy81Hw757na+us/iBrJhCr6fj92cIPFtaq5EEDvclB7ZIbvQHGo7QkJPnVZZ0sMeL5e96kl7NjAINBeIL0YKIscBVi1GXF2wAQf/lIfYPyQfBXLfqHBvKaVArx46exN98KyNMB4F3ZCW58o74LuZOZJVjt2kZ17qxeNngcy1CMmam5qiBxHVxMDVXQmpdpeBsd6EFjDpiZuuhDnFl71Mo759IAqWjI4G4yGW2TpQ7RjY5IP+DaEdBWSf24yL/rbMTqeil2kppmmwAJViR3F/3B84kePE08F27pixW6EPjCj958Jlyd3Niay1myndto8traH/7VQJnCQb4iOOajpWITdHH/J7yLcU3JzLFq/a+c/wqkVhToVZ0kRSFsEo01V8/SAmyDwrzZJQbeKfQq4MmthNBcvz0qMvdVkvEnfgFKF3x+3rHnnKVpFPBioPGJ9i1U4xfgmkPAP66njbrJN2zuiPdPXloL+o3LHKp0hnAQL8uVvy6AbnjwBHv62sKDykw4MaSAtA5RGjYCjGwXz0VgFKTTe7Y1pm+oewIrY2krZWcuRkAAonsBqJ4GWcE+TQHRIAPJy+zxV0VIFwIIJECN0fTJge7B4SUDZtAkr9rR4WA
 jod3JqaD
 /BDkUfVsWtcQiPEoVO6SXXO/P/94yYRTaRDh3RCqLXcgMDL6jTytmelNzL9KalZmbjFBNqybPXbE16kzVujAh0h73Zm008jNE7Z3bZM++ppp0RKUtF/29bD3XeGs4vnZ84/10R0w1HX6x5uQ=
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
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
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


