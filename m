Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75900D711D6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414C56B008A; Thu, 18 Dec 2025 20:40:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9A66B0092; Thu, 18 Dec 2025 20:40:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257176B008A; Thu, 18 Dec 2025 20:40:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7166B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:40:28 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1029C04AE
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:40:27 +0000 (UTC)
X-FDA: 84234515694.11.CAE42E2
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id D921C1C0003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:40:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gGEpicko;
	spf=pass (imf21.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766108425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzPw2N/ioM2S0JlkpKSATVvxATE7Ky1v1N7KaRK6I20=;
	b=VWU8m5+JwU7WvAO3BLr9yA4vedHUGvjQuWdW9xvZLRV9E6w+EX/84HduWj5RnCIx3VzPig
	mZGwgVy503Fgz8OCUc4EefOZlfBTbz4qmkBw4AuBWVnqqlBRGBa3b9F9tiguM7Z7PhcWhZ
	ZcQzgegBMkXoyud2cIwsIPda5fWg4rQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gGEpicko;
	spf=pass (imf21.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766108425; a=rsa-sha256;
	cv=none;
	b=INC4ASjqyyTAimLnXVoVIcAmp+J/6L3gsjZdgtgL3SDPyDbDKUmBWSjWoSn9TBevlCM8CC
	R2lZp37WNy0fjvMhcxum54gqGdVnYDj0HXoJBBUoCrJY0gtN+/PyGfrGcv+m5b4Epch9+Z
	ipo1Orvqbh3tnlqdNQnu6TTcvHDneDI=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78c66bdf675so10935117b3.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766108425; x=1766713225; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzPw2N/ioM2S0JlkpKSATVvxATE7Ky1v1N7KaRK6I20=;
        b=gGEpicko5/sDamn0Ee7bExYleW2eA0vA5J4lRm74TPe+aDuglWdk9rBeb7dV+wg7BG
         qBrp88Ch5Xf41/ysif3WRgd734N+bA6mWFowxSwjLkgk2+olvGBt209JhSmRj2DWkJw4
         1FIPusibGn9cvClLaOlLC5AWtQjAZfLIPrSYFCae+nT2nqR8ThCYXe8WH3I6QXKnRqWg
         GHbuZLSBYgcv6GEjzGvOj+WXFUazEiCLgqg88FT9eY3Pq3bBMg8spRevURRtRPPGf5ni
         whLrYiBjUXVJnjFkI6iusC6PY2mrnb7kxOjttUMMO1B+tnq1UtPDhazi9OKPy5aaY/Lj
         7EWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766108425; x=1766713225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hzPw2N/ioM2S0JlkpKSATVvxATE7Ky1v1N7KaRK6I20=;
        b=gQxBNEgx/Gzea7QHXkYvgEjk3zC7PincLB0vls0o0KAoi4lwY4frc/ttSz6j8AW0Gq
         /0MQndhYJfekklVZngb+z6TgyjRFf0RRSSF4UolzwuDfLpIZdNznVGDJlx1E11ULbBj4
         VmMvazrLFw6Vmy0EXdCPzYZsrOEpj4NiPrKPNIf11VL34VvYMSmBKrJ5M5E0f+oijnCX
         K+EMtZoJE0wfwCV/7C98/jZTf8HslL0t0UNrpraHKdqjHBdnaG/9pQYFxSFdU3VmsFX4
         3b9dEvvaViV7rtJvy5B+gAZc55RaXhYlRNdqK2ANw69VwW669kNfBwPL/OO8X1Lv1dXV
         6XCA==
X-Forwarded-Encrypted: i=1; AJvYcCVA1GML/3yB5F+pC3s/N351c/CPdovylxSKm/6G/vj0OLtmRAZbHfB8GQPovagYMvoe4VVzERq4Bw==@kvack.org
X-Gm-Message-State: AOJu0YxASGu43gawFR9FA8tzt6b1DLoIKKHg3sbmgHoRuKLIt98/kzBn
	f3IFXztmVL5EIcGZuotzFA0g/ApKO6e6U9JkIsm1y714wCxGPzNh8xqh
X-Gm-Gg: AY/fxX47bj9uC7TTc8+EJvw69FJsdUDaRrdFihUjzDF4lAcixrAJBsJT6Mh6eDLyajs
	y4t/PaHiLTmGoWxTyJEuNKdV/pXLB3O4cFOJFbRSmZ33dCXDjjaXMKhp+GaWa7eZC3rJ1yvoTRt
	+7ITOndgYNnW3l6lDZNScB1vIfJCC0IryOR7K2bJBlfiFM22mXTy2/Nac3mNAZAl7rQWrQb0b4m
	jINEo8zF0QlaYwCZwaUQ052QJvgwacgxzMtO8LYACaa7z8joJiLu8zpDovgNVKODLJ8lV/v2lcJ
	DNcHYXT2hzss8fIqyOa3wtwn1NV18JQ3T3KKWEaRwyY+3srbpwmNkwmCEOZrIXkkrAgU2hBihIL
	DbNCY98QV0gJeOr8s+nZEz+uCP5iETaws3lsEudr37fLxE00RFJil/IJedkue7XCbFHu/GNJHdb
	cTkfP95NUNNmQ=
X-Google-Smtp-Source: AGHT+IFlzEyRZbzDwokD8f3jVoeX8J+z1/v2Ahkwq9baLdKstEVjn+R/Ae3XQyq/3bI8aWngyy6zUg==
X-Received: by 2002:a05:690c:6e88:b0:786:581d:d517 with SMTP id 00721157ae682-78fb418761amr10808607b3.49.1766108424964;
        Thu, 18 Dec 2025 17:40:24 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb452c471sm4223507b3.45.2025.12.18.17.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 17:40:22 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 407C14001B60; Fri, 19 Dec 2025 08:40:19 +0700 (WIB)
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
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH mm-hotfixes 3/4] mm: vmalloc: Fix up vrealloc_node_align() kernel-doc macro name
Date: Fri, 19 Dec 2025 08:40:06 +0700
Message-ID: <20251219014006.16328-5-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219014006.16328-2-bagasdotme@gmail.com>
References: <20251219014006.16328-2-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1086; i=bagasdotme@gmail.com; s=Zp7juWIhw0R1; h=from:subject; bh=JzTmiFxxFP9ywosc1/PrB927sw9juQIkycc1i5dnVic=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJkuqxfL7flauWn9i8K7y1seKHYf4ElsWpntmn/F9BrHv cQt816Ld5SyMIhxMciKKbJMSuRrOr3LSORC+1pHmDmsTCBDGLg4BWAifK2MDMtfy/t1mpS0fxQR Vz2l/DJPToqR86pIu8aK58c8u5SkOBgZbmtlrrPwncQzddJ0tvgj37ke9Pd/PJjntXapaWfqfVl rVgA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D921C1C0003
X-Stat-Signature: phnb5u96yr18ey7z6wd7fdmqt466czk1
X-HE-Tag: 1766108425-919803
X-HE-Meta: U2FsdGVkX1/JIyzuMnB5P8E/2S0rTrLXJ7Q5l3+YLBtp8+ouJ/Cbd+WLwQAc6J6MyBXWEVT//fy4z9k98P+HQfbWr1XVIuqUgfIUJrIv4fgJigETDxNNxwnrgp6+MNX/lIlvT8tm4G8J4yq2W9iQBb0fjuIsRorGl9fb61MH73sZQSD82Pnq7F9TwP1wjYtdWTOUr6RJGEtCPG0hM7NQlFgY6H46OLfHob7Cd3wEwOqXmhXrXq5GTJIhbjatdrkUGd5b5V9EGXlIMaK63iid+8RLPMVceiBYrLJawul7xm9Fw4SpYauD/C7ttZDlg+kWpBk+6Y1QfqUWPLE0lON2WipxPivV0h35Ld7MZsVApRWmq0MbF0NfSf1rNOJGT2Ket+6pdoDyUvH47y3m/BXH+hqWqz0smVmn6EO9725P8IQm7UnP3WGxqaszE0vq0nmYlk4VcjLvJCZKb+c7bERePHF0sEj3Jiov+dhbIufudRDijD1A/q46TW2wHTOtJNgsGYcYBqUgvG3lnYkgGcUdTf8RS4IFPIcw69HSoEjKRpUjNZNMQm9N5LkbYrP68EnEbH/0cC0YHvPQHZQDgDht2AcCfsRhoHt8rA4WbFbmN1jJqkKaJ6y7BrgPa9RNQ/OVDQzNSTKwTpZhl+ul1M4N+XReZmKjL3ATQARX/DbCV4P+3lWnSdMpPajT7etYBW7ZWB500gwE9KPMqN71E7GUTsbWCMfhoXDSGw6FOUZeigmj+HVGNVekdo0/Lh7hZw6FqjMOYYTH0Z+jFGeBcVvg8DJXoAWDaLOyImWQmUmN9BNvQ4dBtgc6ulmxlYfBYbeLLs5GRA/12gMazb5Iq3nGe9ND6wkAvWx+/tXsYXIPK2wcSSgavgfACmv0Cwq9jKaUyeyTSTs7veR9fkZdkHtXnt0AewqAEap7Uu1wDu9eI645TcRgcrXs4se2cb4EZ9XaljBzBWC8aL3b6UvdpGV
 MunnW44v
 /WaDswt/wh8bS0UdXETETRxCuKWfUs44yCX33QgtZuhIXZT8bwPQHQIgDYK887GvsitpuGAXwUPd4wDUYYNS8Mof0VISd8FD0PXMWw0laSJ9z2t/yr1yYAcsambWh/f/M+9L51Yy0g4G4VkmK+S0qh4Zfi+cRnQmDp4Y9McqHYwOTDjO35Cc9g+ZxJdVyNtxiuaUidEIjOmkDmuYMELQ5ZDp7+xFQGCxEQBi0sZftI6s30hTBOZ3T+zriEug7gY3o9DQ5SFBDNbherJ3CStph8hYsewT/gMJvCzrW8pBTenhkHWkOhR3+C81ykMNswtN16hl1aHLPsxQQcGfsnFFsQM9oeOSVLUKccxirDE1daEcWV7dNzU3mjIMdoXkj5qyMWGvu6/rGxhM2mp3UgLBbP+/wpttYXdJHduCiK+Gi5I8ZZvXsxXlPkoLiVsyv6lEjt7/rCL0LCiRITz8cz4WGlhkNXdwMSlM5xWAeOfr/KUW8DDCyl1NvuUVI7ZIBx9YUnj85InUpWpW1n7VpIuwKGD4FUVD+K3vp+9YqQlTTdeQKLzbkFojJ9v5mRbaWXaj8bCWI
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
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 41dd01e8430c54..628f96e83b1187 100644
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


