Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B3BEF06E2
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 13:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECAE56B0089; Sun,  8 Feb 2026 08:57:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78426B0092; Sun,  8 Feb 2026 08:57:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D767A6B0093; Sun,  8 Feb 2026 08:57:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C5EBE6B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 08:57:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65B8413B258
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:57:46 +0000 (UTC)
X-FDA: 84421442532.20.1DAF9EA
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 98EAB140007
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:57:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iF8kgTkk;
	spf=pass (imf23.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770559064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=laAbqFSG/YMXdSL9qlzHaO6Y+AMdhAXScO1IYuxjFow=;
	b=hZWAuGomYVFIWH98lpnnNYzNIblFt06pJLy0enVRx6oWfbYhP4Mk9boMvmWykdAjaZszn7
	7kX1z9MLPwbxNsGUcRjHIGm+gF+so1L9cyVf7KTLjMlEhGyWRTjjocRKLfhvJDXuaELObq
	ZzasnQqw178vPTmbnOvM+37Bl2Qd65Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iF8kgTkk;
	spf=pass (imf23.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770559064; a=rsa-sha256;
	cv=none;
	b=2yDt/WNDC5IEryTGcRO3M9LylhONmCfYUDvdvLqiKljffInQRWyP8tcjPpAqo+KAlpuSuf
	x/63HSzR4j5WueCnZIxgA4+kGBTaSqP1WVQrqz3M1CNXMoWEBaWUKdwq145JZt+9eWERod
	dpILBWuxPOaiONpuTZknUIm6VFfcsAw=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4359228b7c6so1272593f8f.2
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 05:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770559063; x=1771163863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=laAbqFSG/YMXdSL9qlzHaO6Y+AMdhAXScO1IYuxjFow=;
        b=iF8kgTkk/rr7kZ7W6+wgtg1g4JFeKB0J2ABP88GHbDcwU8WIO1Gy5MLIfGgvpGIZyW
         i3zluM9QiWXFS04illzcojh/q4WcYlpjPx8RI7f0qOi3FbpJv3hFoM2fXSmJJpfeO2yu
         1AGfDpQkO5FdkS7Qjsor/tHH9787xBhRZFWBWcKwGdg1fFBnK3+4pq3mUKgexem+4vv0
         aO5LFNjfiHNDjbvj5VRQ6mCgNFGxA7keIXcUi527hDKjeFtzWmGzSBACRdhCot/qV0+L
         PwF4bzhhOqPCi4uH4/NXCmVj3vOnNHJycv5RJldaoGXueDhHZtW58C05GJ2iYjieR+JA
         nZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770559063; x=1771163863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=laAbqFSG/YMXdSL9qlzHaO6Y+AMdhAXScO1IYuxjFow=;
        b=XG9Te4AKV1FicKEIfQJqcH/YL+c1ifpPY9Fcw+Sc4qMdFMT6oaWAofKb+6X4AWdZW0
         5fuOjruH5wrMOWgKNNR2m59k0btgfqu2welXrVOCitDvauYDr7OR+AlbVeFmFvfc1rtJ
         JfbkjvHVVXyePjnijo4++0UqUGXuYPmRo1H3fERF1E6PtZf6kms/gHcbDvLM85RWT6nW
         G0Q/7gfLzXfkC5wzjFOg7zRzQ3+VA7RAP6hj8yNMC0kzshfQuDgQUku9kiqIMEPRiq2X
         lHngiUSLrGo3BjzzkKhrY4ZGWoHfgWyIkI0twNMbhviI8iE+I+VOoGbMY3cjluw13N79
         GxYQ==
X-Gm-Message-State: AOJu0YyGRhFO356vYUZVjxYHIxkvht13Fw7ezamy6upfjIW9R5oXM0Mv
	IvdowKad7FuCcoE58+e71S1642kKzB0mIca5klRiNjhqE5AxMlcewb0xBp2Q+A==
X-Gm-Gg: AZuq6aJgEWyNU006wRgJYBmNUmrzMY47ViynLu0XEWI3iyScYI2A2ix8EXQ48/WUsu2
	MM3XFblIy/xeybudBT7Onj2/cRP/fCnbuSQGr2YMtHiDG1umGRCbohFenS+et3OvA3cL7Yt2ogk
	/a9g/mcQEryOUNqf18rYcv+fZzfPYsGcx70iUMGQc9juCif0uofmKj1b/jnSqrLL//a3QE0WgfU
	C2Fxdo0LABW3rPHTP/dIum4l9bgqqmDu4fWSXEif/7rBlDk8vM2K4ZPC7SfQ7nZbiZ2sAMpp3Qy
	Md8GkZPhNANUylmG52N/2iRjqMf1wtEX+roJLzXb4LyUfzp+8zb6SGX4UtgSnGDoRrTvFabXFWM
	daNAX4IFRDVeFw2FRZiep1EYqswpAY/LjOwPyvZ25mDXYWa9H5y3mfRH7c30vhcZdXOAKiZlkyU
	RixFnTOFXowtP81XODvEv50NtgZNBBwv2UDa6xe6sZ8rewaBxOTmPy5pK663ig+0KSAFTNx997F
	o/rBTpEitQuVwWpCQ4TcBfRVtkSue/JQYVRroukUfs0+5t4CNOdkUWagMnU+fZlI4BLp8g=
X-Received: by 2002:a05:6000:186c:b0:435:a135:7772 with SMTP id ffacd0b85a97d-43629244604mr11519638f8f.4.1770559062461;
        Sun, 08 Feb 2026 05:57:42 -0800 (PST)
Received: from 2a01cb0006769b001185461c960a9b50.ipv6.abo.wanadoo.fr (2a01cb0006769b001185461c960a9b50.ipv6.abo.wanadoo.fr. [2a01:cb00:676:9b00:1185:461c:960a:9b50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-436296bd4desm20045169f8f.18.2026.02.08.05.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 05:57:42 -0800 (PST)
From: klourencodev@gmail.com
To: linux-mm@kvack.org
Cc: jack@suse.cz,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	vbabka@suse.cz,
	brauner@kernel.org,
	linux-fsdevel@vger.kernel.org,
	Kevin Lourenco <klourencodev@gmail.com>
Subject: [PATCH v2] mm/fadvise: validate offset in generic_fadvise
Date: Sun,  8 Feb 2026 14:57:38 +0100
Message-ID: <20260208135738.18992-1-klourencodev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <CAFveykMPrkb=VYwQAjCEARsC_WAGfQXMz_gf8Q0CTHWHooNHVA@mail.gmail.com>
References: <CAFveykMPrkb=VYwQAjCEARsC_WAGfQXMz_gf8Q0CTHWHooNHVA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 98EAB140007
X-Stat-Signature: giskaw4ta84y3a6uxnwcgc83ubib5auo
X-Rspam-User: 
X-HE-Tag: 1770559064-978410
X-HE-Meta: U2FsdGVkX18IwNb58PPiWvnusPlFZpYHqWcfnVJptFtjpVHtDHz0JSdyYqzu2X575DmKNAjwdActsA6vuLueC4bkHsa0ojLyKP9PkeefXDVRJQKrvMPQTxZhYINK+MQZtzezyc2YdZi2CMEyt6LprPTtPHpRrwJ2snvH6po3dK3Bt9E2OEOHFlb+OqwpNS5i/5DDX6B7DZnujHGSsn+REjVj8qncEmFTdM7VJ1t4GqOIdcRPpw10ILFp3W5O5vnXsY3SEbsIQVyfgsLZZJFVprzlqXN1T7TUEuMFdF4ry8LKsyP1uxqlOwK6E5jYp5CpfCXOBVVTYMk7Svzbv7nEXS7y0VO/ONWPuv1Pl2pOhQlPLg7bolBApVyEr57u6XU8ke7meAjcsRRXbsEhGLIGbJkP0UkClk9nyPR39Et6M7PL8nmFaLG/O+lV72XU3fgEheKJbtFDntjivQPP0kUkCLdCCXOxl5Wl0k41zNDj+FOWz4iCBWiP3QhFB+o8quRvuKAFn0PdG5/m+9caYqtVp4eNig98gAv+CdVQIjs7yOyk95PunBwrC30G89evmW4B3xhK9rpbMjd2knjhr0fKz8urYgqwx1qicg45aXen0NucvYEkDV2IAOJNHrxYrh+XjbriyRlzbgbqQ9eGIT0vILtAiphn6AilWNkf/RqP4xYz6587lcflkK/1UnY8y8jRpAWfgsNbWnEOxtymLlI7SxHFCDwrW2othpyjHHZvx/e2Scxy6xienfbdbyGWk2P/hCriGz3fLFWG399pZsFYV5Jx4tnaJPdQnlKSEMQZ2iDpfCJULjHvlZV/LEK44jEqE0/K0Nf0hfGNQF5XdkfMO2eKpDI2AHwUgLS4rOTMaxTaSS4VcqUNa9JBO1f1YOxjO27PzbQ33bDfToEsj4PFhBZWiWPhSDBz01YYQsTlVRsVXmgqlLRnQbCt46p0oZuj2bd5ObRzkbwOVuJEZvA
 +YCnJxIT
 lg9Ewtd4Wq4bAc0KHHP3fBMtHeyZd9a+YoL30sPXBq2sytoHhwEsl275HmMJzZeGsPIvKdTt26WSeHenU0aydfkNThRlnIJTWsYgslt7E1c9/AQ88YplAbNMIEbPaXMELSrR7WbizNyMEv8iDOQo6wYMQ/dWfj1b1imMje2oX75hDsUkCI4Z6Vg+dU91gbhlP9wjhVID74pPGa6dEkX5azWFEoHjVnhjrzwC7nL9JtkLXkEhArBP/i4qmIJQ+XL6uLr1YN4A9v/2NdaR8Y+ZOY6xNy4OGCWIxEUpxclXA1lgnjWY9apCtaC9uDzvXN7RfbCbfoZ/foKNWx1ESppouCdbHypzSCM2MIKKwJH55bLpNFtzJFrQMC8VZ4XkHEoM9QYsSTT9+YYE0EZ/vAEdD5rZAwJ2rGkc30y5WoZ4+FCQFZQ/lY9W+rybPpIJGLuvEubmK12q4rFiC1J8fAlx7G+PQGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kevin Lourenco <klourencodev@gmail.com>

When converted to (u64) for page calculations, a negative offset can
produce extremely large page indices. This may lead to issues in certain
advice modes (excessive readahead or cache invalidation).

Reject negative offsets with -EINVAL for consistent argument validation
and to avoid silent misbehavior.

POSIX and the man page do not clearly define behavior for negative
offset/len. FreeBSD rejects negative offsets as well, so failing with
-EINVAL is consistent with existing practice. The man page can be
updated separately to document the Linux behavior.

Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
---
 mm/fadvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/fadvise.c b/mm/fadvise.c
index 67028e30aa91..b63fe21416ff 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -43,7 +43,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		return -ESPIPE;
 
 	mapping = file->f_mapping;
-	if (!mapping || len < 0)
+	if (!mapping || len < 0 || offset < 0)
 		return -EINVAL;
 
 	bdi = inode_to_bdi(mapping->host);
-- 
2.52.0


