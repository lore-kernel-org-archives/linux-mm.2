Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D535EC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76666B009E; Mon,  7 Sep 2026 09:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26B46B009F; Mon,  7 Sep 2026 09:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16566B00A0; Mon,  7 Sep 2026 09:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 969856B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:22:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26B131C07E2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:22:12 +0000 (UTC)
X-FDA: 85187029704.19.D188846
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id ED5E5140014
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:22:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hx3YcInZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788787329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViElzflaszjSFY7ZUxClX7Wwc/oOQXR/RJoA4DtKYyY=;
	b=Xyur9hDfZI051aSowTy/4TwFiWMoe56jEUzHjIphGZl3UNf3Ta42zgTK1yMZ/Om33ljnZz
	GqTNqOQeUMNIeGMhwPvw/pULMth39H9Gevb/DEiOVjTw13k/2mtRbnDgu039yrNv7hFf3r
	lsGlKDhIsxQiOU3U7Bw3JijP0Ol/o9I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hx3YcInZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788787329;
	b=qeYCXMmEVxgvJ9EyV09DIYgqYNwzxHP2gJSG30xuQHZxMYOWrwS0paeP9mnPWWnxXp20Xq
	r5rIPueV/z4vFQQ5chmOCXsvs4nMk7TAi67Qp++TLfZRY1quNLIuyyXPtYYAbPkjC+U4aN
	vytNUPmM7nIIgAQapwHSyoyy6oTpWlI=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48436251906so4050078f8f.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 06:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788787328; x=1789392128; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ViElzflaszjSFY7ZUxClX7Wwc/oOQXR/RJoA4DtKYyY=;
        b=hx3YcInZ3poJCIQRxFMmC6NHz4WChN8/kUtWXSHYmFPBM+KbPv3VCgW7DOzn1JLSe4
         9qS8yDVxMg9aDFsaCVoso8U3LG+TExdUXmobkF7723bTqQ494yElPm0pAxmojtuxP8sz
         1CLuwbbytTVvmcHAoO6s/M4S/6vWuoWITDqxvslO9biWMCPjV28pmEc3OMB+H//3gR8w
         itj6TJN9KvvDEFoTcdr/KQUeg1WHsYuWqDakTBVj4vTTAN2IRwi2ez3QcvW5ivbdde+k
         isdsrsIPUilcOxYUHz2YGib8Opi/38HSdYI4qLn+1eSZGKroEkMSdA+rXvQNiK7nl1Qf
         GNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788787328; x=1789392128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ViElzflaszjSFY7ZUxClX7Wwc/oOQXR/RJoA4DtKYyY=;
        b=FOyfyioYkfkWs4gPZ35TRimQ+ifyqj8YvYQQYGedbVkmga61W5ZP2BfCK8ZV6Yzv3i
         WEg125GspVGx3+VS8WtixrOQ99o9bqoqC/G+qTxHmI0Vs/OXdns4UfoPXfvABeta7JLJ
         FBRto+XTmc+PWTJLSW2RexdHfN20q7kCzd2B2C/8Lu/mKOOzt9CjHZwpqjiX8+qSERqE
         Qnv54PsW2m6QIm2OpFCs5A8BdkorTF4v7JhmT7qn39FUmXkD4EtCUEh+nln8o0ka0Beq
         wWfQ+jDqBvbAd8P1lZRPETXv+B3isruHhnH7K0VOt9lw5/LwHKugSdgrhiDUBkN/YCFo
         j0+g==
X-Forwarded-Encrypted: i=1; AKwUvBzER45mr0yuomBI/HkubrU3etN3sj7ND51byb9Rg4gK3SVHhHObvWI+cBX0yQGE0WMcYJ+Zi95ZRg==@kvack.org
X-Gm-Message-State: AFuF++nhRLIN+sanFL2+4unPxTELeYnAaQ31XFCID4nEogsSJePDkNj2
	ZS+YwApaJPTZbS2BqH5N2DS1ETJWRBaSgBscrgBuVBsPhlurk/OxMJMR
X-Gm-Gg: AYBFou3TI65ok7Z0LLv5ZDiiehZFOMYNox1FXXm1pF96NdCPUbIuo4zOY5gFI/Tye7b
	66k/Kj1+U92GuN+x8WItuJs0ahX1lBZ9oEXMZ6E8/+dt/JogEoi1dHpiUWhgzVdY8KWPGkLOTgg
	hPPoOjSU06yAJTt9XDPfLMDuVaB8uM2HzpYWm2ZXCH6oyDAgA6ndZmDmvoNikOGutKJbMHEwRdm
	rPsv+Me8432rgUWNAESxGbeTlFz0XKqrG+TTf2FoiSYYOfgEOXAn30LDgUOikId48EAJPhAh/yz
	f51nxd60aqV5JN5Lr9+aQyZPu1mWRZU/BEa7PZxkYMfadwynBBgb9RuEYcB7X6CllOg23YnQA4G
	uCFvJSAvlZr3Hcmz9GbL3poOUbo/ZHzeR3zmoHMJTP4PGyVqyUJCBD75BaqSS6hMJL5auz+AK2J
	E97UPBmRp7Wmp7H72IyAkkm/uKYE/coBQeeow/+6o6oY0riy6XdxNibFWGUaimR5OD0b7xxaEF+
	RzUV5LuRDAFErt2vpWPbLOhN1+ZjPxOcZtZ+iWTLMlTQuFsZeFpWBkdIoL1bN7lmQjLX89dXsN5
	d4VInK2uRKSJ7IV2+tZRmL0Qa44wvL2oRYyxTxqs6pvP+b+2KcViq3nk6LCWWLfKlmDmX9MCOLx
	sgbpABTc9HerD7GDEOg==
X-Received: by 2002:a05:600c:3f12:b0:49c:c8de:96a9 with SMTP id 5b1f17b1804b1-49cf7fdd2dfmr448928055e9.2.1788787327897;
        Mon, 07 Sep 2026 06:22:07 -0700 (PDT)
Received: from Ubuntu.ts.net (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48588394fa1sm27458397f8f.8.2026.09.07.06.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:22:07 -0700 (PDT)
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>,
	oe-kbuild-all@lists.linux.dev,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH] ocfs2: remove unnecessary ret variable in ocfs2_calc_xattr_init()
Date: Mon,  7 Sep 2026 15:22:00 +0200
Message-ID: <20260907132202.48834-1-krystianmkaniewski@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <202609040247.8B3lmoqX-lkp@intel.com>
References: <202609040247.8B3lmoqX-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4e641fq38y7neq3mpsrju8cgyjr7cgjn
X-Rspamd-Queue-Id: ED5E5140014
X-HE-Tag: 1788787329-750006
X-HE-Meta: U2FsdGVkX19PrhzIBgMHayK9ObEW4JffWH6EJSvYXds0jITc/b3A+G6z8OHdwtIxtmj8qd0DvRuREVcf6+Y20euCvSrHUw/zJygoSZ67pqzSHli0LqAoj9jfuBErGAa1o/orKI9UD87L0x1zmUnXpypv7u43NJt2z6gr0aYjK7J9nwg60Rx1bOcETU1+Vq3MrQAyecJUrQkTMdKFMTpa0V9DxxjFlJgzsXKL56hxQBFucWzyX1s7eDZQFK+p+VdoskfIIOpT31HW+pVJnONmuTK9Y+DUCabnc+PWbMpiJQqJfUw8vcRoqRv3+vyngZtdGI8jxngfRcnd918i63doqPXQyL3g7zuNgQRivF58ypTy0bDjZ1ROprvMZ0CbH9tbN/ZnHjwasMbeJ5nPFyCTiViMKo8XcPLS/V+FJB2Ps265IRh/gHSytUQ5XLgkPwJMSZk+w4NnwRWZQ8AIWGgUdK7iCXzd/3jUEuXfhSCouqe+2ux9fpiN0HTG2Jb8UIYNkIfE7MVX358mrjOEYmEjwM+ENbKSYMlOnMy4VmmHsomSgXW1/7BGrrsjHB9D58nAVwD9fi8+zNsLVpWorjhZ2Cm26GH6Lvl93Yr0g+JCvS1U7/fzI7SEQtHHT4a4rLk5qf+dRxWKECwLBANNvnjcFYhMpNbAm6wMjvTIMieoe+C2h4gci/haY9MBEJu/Hd1x+47HOQSC6j+jOzXEnkNz5DI9ZM+CLbqQKDiIA1i1lL5eAdDOmN8v6n6fsFw5qfqrH42RlqPhUVf0V9QlQyVsgrt63thYCJAO1Z8XWi4eIZ60bbVzsZ4PTIpBzn0mBvfWasAtDz0/nNPmuap1T42ipHphqH8DIIyKPsveVXvVAzSn4gaNDJTAAknEva5JeJA74UWZcmBDy0dX7P9oxn5wdVu5YXRiM60wMeFlvs8/vOYsKQl12NImWT143XxcvlDyCNNW2BUa6qeyoacx9Xe
 mdQByV4S
 cTFg+zhB1wxczkUMRxMnFDsZCEV1Y33ksAcG3xZv309rAs7X7fOJHprzDC4AsvvKb75EkFrfK/CsDVLmHDM4YG1MI/L93I3bD/IKjceRrltSuAPwZv3kVmKznSdykWM06Ax2NalAsZdw4ucoTRtQB+fbD7/7R66XrFLrrC60CjhFp1DJLJLmwxUsGvEZHg7tI1UbM9B9PQshtINQgxdCxB20V8PQJ4PkSXeRri3xujJsUyXfKXbrPFCQNcKuyk2/z1KL2MHx85UX9tYmsFiRdyyq2weV9tjnysmBO34oF391Eb+r332zqdGMdChxvY5pzCZhLhKWBsTvoE5ty0bFoZwHNUVy2LJe8RKVPL2E1IsggjfFQM6iSZZLHkJ4hVz8HPC2UIKSl/fsrFS3NGNutHAnd8ugXJ+8pcuNLIdIpNQP7nVSoMdkJ4COnEFNgIUWxSb0yLPY11vjU1sVehvOCG3Ayglwj97Q35mW6vuRVNnSDUIyHfnkFQlU2cySf2aNLOI/6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit bd7c05fb4a47 ("ocfs2: fix circular locking dependency in
ocfs2_init_acl()") removed the only code that could change ret in
ocfs2_calc_xattr_init(). The variable is now always zero, so remove it
and return zero directly.

This fixes the reported Coccinelle warning without changing behavior.

Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
---
 fs/ocfs2/xattr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 35bcbb0ff607..ab3b645983c9 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -640,7 +640,6 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 			  int *want_clusters, int *xattr_credits,
 			  int *want_meta, struct ocfs2_acl_state *acl_state)
 {
-	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
 
@@ -662,7 +661,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 	}
 
 	if (!(s_size + a_size))
-		return ret;
+		return 0;
 
 	/*
 	 * The max space of security xattr taken inline is
@@ -729,7 +728,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static int ocfs2_xattr_extend_allocation(struct inode *inode,

base-commit: bc35965f6940a9bf834d54187b6088b8eb09206d
-- 
2.53.0


